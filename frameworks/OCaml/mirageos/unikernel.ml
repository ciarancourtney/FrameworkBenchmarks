module Main (CON:Conduit_mirage.S) = struct
  let src = Logs.Src.create "conduit_server" ~doc:"Conduit HTTP server"
  module Log = (val Logs.src_log src: Logs.LOG)

  module H = Cohttp_mirage.Server(Conduit_mirage.Flow)

  let start conduit =
    let http_callback _conn_id req _body =
      let path = Uri.path (Cohttp.Request.uri req) in
      Log.debug (fun f -> f "Got request for %s\n" path);
      let header = Cohttp.Header.init_with "Server" "MirageOS" in
      let headers = Cohttp.Header.add header "Content-Type" "text/plain" in
      H.respond_string ~headers ~status:`OK ~body:"Hello, world!" ()
    in

    let spec = H.make ~callback:http_callback () in
    CON.listen conduit (`TCP 8080) (H.listen spec)
end
