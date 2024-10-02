(* Define a datatype for binary trees *)
datatype 'a tree = Empty | Node of 'a * 'a tree * 'a tree

fun parse file =
    let
        (* Read an integer from the open file. *)
        fun readInt input = 
                Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

        (* Open input file. *)
        val inStream = TextIO.openIn file

        (* Read an integer (how many numbers?) and consume newline. *)
        val n = readInt inStream
        val _ = TextIO.inputLine inStream

        (* A function to read N integers from the open file. *)
        fun readInts 0 acc = rev acc (* Properly reverse the list when done *)
            | readInts i acc =
                let
                    val nextInt = readInt inStream
                in
                    if nextInt = 0 then
                        readInts i (nextInt :: acc) (* If the current integer is 0, keep the count the same *)
                    else
                        readInts (i - 1) (nextInt :: acc) (* Otherwise, decrease the count and add the integer to the list *)
                end
    in
        (n, readInts n [])
    end

(* Function to build a binary tree from the given preorder traversal list *)
fun buildTree preorder =
    let
        (* Helper function to recursively construct the tree *)
        fun buildTreeHelper [] = (Empty, [])
          | buildTreeHelper (x::xs) =
            if x = 0 then (Empty, xs)
            else let
                val (leftSubtree, remaining1) = buildTreeHelper xs
                val (rightSubtree, remaining2) = buildTreeHelper remaining1
                in
                    (Node(x, leftSubtree, rightSubtree), remaining2)
                end
    in
        #1 (buildTreeHelper preorder)
    end

fun arrangeCore Empty = (Empty, 0) 
  | arrangeCore(Node(x, Empty, Empty)) = (Node(x, Empty, Empty), x) 
  | arrangeCore(Node(x, l, Empty)) = 
    let 
        val (arranged, min_element) = arrangeCore(l) 
    in 
        if x > min_element then 
            (Node(x, arranged, Empty), min_element) 
        else 
            (Node(x, Empty, arranged), x) 
    end
  | arrangeCore(Node(x, Empty, r)) = 
    let 
        val (arranged, min_element) = arrangeCore(r) 
    in 
        if x > min_element then 
            (Node(x, arranged, Empty), min_element) 
        else 
            (Node(x, Empty, arranged), x) 
    end
  | arrangeCore(Node(x, l, r)) = 
    let 
        val (left_arranged, minl_element) = arrangeCore(l)
        val (right_arranged, minr_element) = arrangeCore(r) 
    in 
        if minl_element > minr_element then 
            (Node(x, right_arranged, left_arranged), minr_element) 
        else 
            (Node(x, left_arranged, right_arranged), minl_element) 
    end;


fun traverse Empty = ()
  | traverse (Node(value, left, right)) = 
    (traverse left; 
     print (Int.toString value ^ " "); 
     traverse right);

fun arrange filename =
    let
        val S = #2 (parse filename)
        val tree = buildTree S
        val (finalTree, _) = arrangeCore tree
    in
        traverse finalTree;
        print "\n"
    end;