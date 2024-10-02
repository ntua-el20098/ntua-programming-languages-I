open Printf

module Position = struct
  type t = { x: int; y: int }
end

let directions = [|
  ("NW", -1, -1); ("N", -1, 0); ("NE", -1, 1);
  ("W", 0, -1);              ("E", 0, 1);
  ("SW", 1, -1); ("S", 1, 0); ("SE", 1, 1)
|]

let is_valid x y n = x >= 0 && x < n && y >= 0 && y < n

let reconstruct_path parent_x parent_y n =
  let rec aux x y path =
    if x = 0 && y = 0 then path
    else
      let found = ref false in
      let nx, ny, direction = ref 0, ref 0, ref "" in
      for i = 0 to Array.length directions - 1 do
        let dir, dx, dy = directions.(i) in
        let px = x - dx in
        let py = y - dy in
        if is_valid px py n && parent_x.(x).(y) = px && parent_y.(x).(y) = py then
          (nx := px; ny := py; direction := dir; found := true)
      done;
      if !found then aux !nx !ny (!direction :: path) else path
  in
  let path = aux (n - 1) (n - 1) [] in
  "[" ^ (String.concat "," path) ^ "]"

let find_shortest_path n grid =
  let visited = Array.make_matrix n n false in
  let parent_x = Array.make_matrix n n (-1) in
  let parent_y = Array.make_matrix n n (-1) in
  let q = Queue.create () in
  Queue.add { Position.x = 0; Position.y = 0 } q;
  visited.(0).(0) <- true;

  let rec bfs () =
    if Queue.is_empty q then "IMPOSSIBLE"
    else
      let current = Queue.take q in
      if current.Position.x = n - 1 && current.Position.y = n - 1 then
        reconstruct_path parent_x parent_y n
      else (
        Array.iter (fun (dir, dx, dy) ->
          let new_x = current.Position.x + dx in
          let new_y = current.Position.y + dy in
          if is_valid new_x new_y n && not visited.(new_x).(new_y)
            && grid.(new_x).(new_y) < grid.(current.Position.x).(current.Position.y) then
          (
            visited.(new_x).(new_y) <- true;
            parent_x.(new_x).(new_y) <- current.Position.x;
            parent_y.(new_x).(new_y) <- current.Position.y;
            Queue.add { Position.x = new_x; Position.y = new_y } q
          )
        ) directions;
        bfs ()
      )
  in
  bfs ()

let main () =
  if Array.length Sys.argv <> 2 then
    printf "Usage: %s <input_file>\n" Sys.argv.(0)
  else
    let filename = Sys.argv.(1) in
    try
      let ic = open_in filename in
      let n = int_of_string (input_line ic) in
      let grid = Array.init n (fun _ ->
        let line = input_line ic in
        Array.of_list (List.map int_of_string (String.split_on_char ' ' line))
      ) in
      close_in ic;
      let result = find_shortest_path n grid in
      printf "%s\n" result
    with
    | Sys_error msg -> prerr_endline msg
    | Failure msg -> prerr_endline ("Failure: " ^ msg)

let () = main ()