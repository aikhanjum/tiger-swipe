(* TigerSwipe pipeline service. Routes beyond /health are yours to write:
   next up is POST /dedupe (JSON list of emails in, clusters out). *)

let () =
  let port = try int_of_string (Sys.getenv "PORT") with _ -> 4100 in
  Dream.run ~interface:"0.0.0.0" ~port
  @@ Dream.logger
  @@ Dream.router
       [ Dream.get "/health" (fun _ -> Dream.json {|{"status":"ok"}|}) ]
