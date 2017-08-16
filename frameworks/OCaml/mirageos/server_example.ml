(* server_example.ml *)
open Lwt
open Cohttp
open Cohttp_lwt_unix

let server =
  let callback _conn req body =

    let header = Cohttp.Header.init_with "Server" "MirageOS" in
    let headers = Cohttp.Header.add header "Content-Type" "text/plain" in
    let headers = Cohttp.Header.add headers "Date" "Mon, 01 Jan 1970 00:00:01 GMT" in

    Server.respond_string ~headers ~status:`OK ~body:"Hello, world!" ()
  in
  Server.create ~mode:(`TCP (`Port 8080)) (Server.make ~callback ())

(* See https://github.com/mirage/ocaml-cohttp/issues/511 *)
(* https://github.com/samoht/irmin/commit/629c3958f5f8487cf2290efec9d5464ff16e6461 *)
let () = Lwt.async_exception_hook := ignore

let () = ignore (Lwt_main.run server)
