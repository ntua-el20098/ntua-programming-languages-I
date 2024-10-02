open Printf

let is_divisible n d = n mod d = 0

let rec is_base_valid num base = 
  match num with
  | 1 -> true
  | _ -> 
    if is_divisible (num - 1) base 
    && is_base_valid ((num - 1) / base) base 
    then true 
    else false

let find_base num digit =
  let rec search_base base =
    if is_base_valid num base 
    then base 
    else if base * base > num 
    then num - 1 
    else search_base (base + 1)
  in search_base (digit + 1)

let solve_min_base n =
  match n with
  | 1 -> 2
  | 2 -> 3
  | _ ->
    let rec check_divisor divisor current_min =
      let updated_min =
        if is_divisible n divisor then
          let potential_base = find_base (n / divisor) divisor in
          if potential_base < current_min && potential_base > divisor 
          then potential_base 
          else current_min
        else current_min
      in
      if divisor * divisor >= n 
      then updated_min 
      else check_divisor (divisor + 1) updated_min
    in check_divisor 1 (n + 1)

let find_min_bases num_list = List.map solve_min_base num_list

let () =
  (* Read input file name from command line argument *)
  let input_filename = Sys.argv.(1) in
  (* Open the input file and read all lines *)
  let lines = ref [] in
  let input_channel = open_in input_filename in
  try
    while true; do
      lines := input_line input_channel :: !lines
    done
  with End_of_file ->
    close_in input_channel;
    (* The first line contains the count of numbers, we ignore it *)
    let lines = List.rev !lines in
    match lines with
    | _ :: rest ->
      let numbers = List.filter_map (fun s -> 
        match int_of_string_opt s with
        | Some n -> Some n
        | None -> None) rest in
      (* Process each number to find the minimal base *)
      let results = find_min_bases numbers in
      (* Print results, each on a new line *)
      List.iter (printf "%d\n") results
    | _ -> ()