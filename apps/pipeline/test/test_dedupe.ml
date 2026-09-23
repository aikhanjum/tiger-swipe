open Pipeline

let email ~id ~received_at ~subject ~body : Email.t =
  { id; from = id ^ "@princeton.edu"; subject; body; received_at; links = [] }

let hackathon =
  "TigerHacks is back for its fifth year. Join two hundred hackers for twenty four \
   hours of building, free meals, workshops on machine learning and web \
   development, and over ten thousand dollars in prizes. The event runs December \
   eighth and ninth in the Friend Center. Applications close November thirtieth \
   so apply early to guarantee your spot."

let print_clusters cs =
  List.iter
    (fun (c : Dedupe.cluster) ->
      Printf.printf "%s <- [%s]\n" c.canonical.id
        (String.concat "; " (List.map (fun (e : Email.t) -> e.id) c.duplicates)))
    cs

let%expect_test "same event forwarded to three listservs" =
  print_clusters
    (Dedupe.cluster
       [
         email ~id:"whitman" ~received_at:"2026-09-20T10:05:00Z"
           ~subject:"[Whitman-Wire] TigerHacks 2026"
           ~body:(hackathon ^ " Sent to the Whitman College listserv.");
         email ~id:"mathey" ~received_at:"2026-09-20T09:00:00Z"
           ~subject:"[Mathey] TigerHacks 2026"
           ~body:(hackathon ^ " Mathey College announcements, unsubscribe below.");
         email ~id:"yoga" ~received_at:"2026-09-20T11:00:00Z"
           ~subject:"Sunrise yoga on Poe Field"
           ~body:"Stretch with us every Tuesday at seven in the morning on Poe \
                  Field. Mats provided, beginners welcome, no signup needed.";
         email ~id:"butler" ~received_at:"2026-09-20T12:00:00Z"
           ~subject:"[Butler] TigerHacks 2026"
           ~body:(hackathon ^ " Butler College weekly digest.");
       ]);
  (* mathey is the earliest copy, so it is canonical. Its cluster comes first
     because mathey precedes yoga in the input. *)
  [%expect {|
    mathey <- [whitman; butler]
    yoga <- []
    |}]

let%expect_test "every email is its own cluster when nothing matches" =
  print_clusters
    (Dedupe.cluster
       [
         email ~id:"a" ~received_at:"1" ~subject:"Chess club" ~body:"Weekly blitz night in Frist.";
         email ~id:"b" ~received_at:"2" ~subject:"Debate" ~body:"Parliamentary debate tryouts Thursday.";
       ]);
  [%expect {|
    a <- []
    b <- []
    |}]

let%expect_test "empty input" =
  print_clusters (Dedupe.cluster []);
  [%expect {| |}]

let%expect_test "grouping is transitive" =
  let w = String.concat " " in
  let base = List.init 20 (fun i -> Printf.sprintf "w%d" i) in
  let drift n = List.init 20 (fun i -> Printf.sprintf "w%d" (i + n)) in
  print_clusters
    (Dedupe.cluster ~threshold:0.5 ~k:1
       [
         email ~id:"a" ~received_at:"1" ~subject:"" ~body:(w base);
         email ~id:"b" ~received_at:"2" ~subject:"" ~body:(w (drift 5));
         email ~id:"c" ~received_at:"3" ~subject:"" ~body:(w (drift 10));
       ]);
  (* a~b and b~c pass the threshold (15/25 = 0.6), a~c does not (10/30),
     yet all three land in one cluster. *)
  [%expect {| a <- [b; c] |}]
