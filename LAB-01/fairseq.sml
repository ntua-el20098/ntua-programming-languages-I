(* Input parse code by Stavros Aronis, modified by Nick Korasidis. *)
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
            fun readInts 0 acc = acc (* Replace with 'rev acc' for proper order. *)
                | readInts i acc = readInts (i - 1) (readInt inStream :: acc)

        in
            (n, readInts n [])
        end

fun minAbsDiff (N, S) =
        let
            val totalSum = Array.foldl op+ 0 S
        
            val minDiff = ref totalSum
            val leftIndex = ref 0
            val currentSum = ref 0
            val diff = ref totalSum

            fun updateMinDiff diff = 
                    if abs(diff) < !minDiff then minDiff := abs(diff)
                    else ()

            fun processElement rightIndex =
                    let
                        val value = Array.sub(S, rightIndex)
                    in
                        currentSum := !currentSum + value;
                        diff := totalSum - 2 * !currentSum;

                        if !diff > 0 then updateMinDiff (!diff)
                        else if !diff < 0 then
                                let
                                    val rec removeElements = fn () =>
                                            (
                                                updateMinDiff (!diff);
                                                if !diff < 0 andalso !leftIndex < rightIndex then
                                                    (currentSum := !currentSum - Array.sub (S, !leftIndex);
                                                        diff := totalSum - 2 * !currentSum;
                                                        updateMinDiff (!diff);
                                                        leftIndex := !leftIndex + 1;
                                                        removeElements ())
                                                else ()
                                            )
                                in
                                    removeElements ()
                                    
                                end
                            else minDiff := 0
                    end

            fun processArray () =
                    let
                        val N = Array.length S
                    in
                        Array.tabulate (N, processElement);
                        !minDiff
                    end
        in
            processArray ()
        end

fun fairseq filename =
        let
            val (N, S) = parse filename
            val result = minAbsDiff (N, Array.fromList S)
        in
            print (Int.toString result ^ "\n")
        end