open Pipeline

let print_set s = Text.String_set.iter print_endline s

let%expect_test "normalize: case, punctuation, whitespace" =
  print_endline (Text.normalize "  Hello,   WORLD!! ");
  [%expect {| hello world |}]

let%expect_test "normalize: listserv subject" =
  print_endline (Text.normalize "[Whitman-Wire] TigerHacks 2024 -- Apply NOW!!!");
  [%expect {| whitman wire tigerhacks 2024 apply now |}]

let%expect_test "normalize: empty and all-punctuation" =
  Printf.printf "[%s] [%s]\n" (Text.normalize "") (Text.normalize "!!! ...");
  [%expect {| [] [] |}]

let%expect_test "shingles: k=2" =
  print_set (Text.shingles ~k:2 "a b c");
  [%expect {|
    a b
    b c
    |}]

let%expect_test "shingles: fewer words than k" =
  print_set (Text.shingles ~k:3 "Hi there");
  [%expect {| hi there |}]

let%expect_test "shingles: empty text" =
  Printf.printf "%d\n" (Text.String_set.cardinal (Text.shingles ~k:3 "  !! "));
  [%expect {| 0 |}]

let%expect_test "shingles: repeated phrases collapse (it's a set)" =
  print_set (Text.shingles ~k:2 "go go go");
  [%expect {| go go |}]
