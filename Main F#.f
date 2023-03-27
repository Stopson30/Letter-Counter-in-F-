open System

let countLetters (input: string) =
    input |> Seq.fold (fun acc c -> if Char.IsLetter(c) then acc + 1 else acc) 0

[<EntryPoint>]
let main argv =
    Console.WriteLine("Enter a sentence:")
    let input = Console.ReadLine()
    let numLetters = countLetters input
    Console.WriteLine($"Number of letters in the sentence: {numLetters}")
    Console.ReadLine() |> ignore
    0
