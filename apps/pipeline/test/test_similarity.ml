open Pipeline

let set l = Text.String_set.of_list l

let%expect_test "jaccard" =
  let show a b = Printf.printf "%.3f\n" (Similarity.jaccard (set a) (set b)) in
  show [ "a"; "b" ] [ "a"; "b" ];
  show [ "a"; "b" ] [ "b"; "c" ];
  show [ "a" ] [ "b" ];
  show [ "a"; "b"; "c"; "d" ] [ "a" ];
  show [] [];
  [%expect {|
    1.000
    0.333
    0.000
    0.250
    0.000
    |}]
