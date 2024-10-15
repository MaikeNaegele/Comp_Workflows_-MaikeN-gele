params.step = 0

// check if the number is even 
def isEven(n) {
        return n % 2 == 0
    }



workflow{

    // Task 1 - Extract the first item from the channel

    if (params.step == 1) {
        in_ch = channel.of(1,2,3)
        in_ch.first().view()
    }

    // Task 2 - Extract the last item from the channel
    
    if (params.step == 2) {

        in_ch = channel.of(1,2,3)
        in_ch.last().view()

    }

    // Task 3 - Use an operator to extract the first two items from the channel

    if (params.step == 3) {

        in_ch = channel.of(1,2,3)
        first_two_items= in_ch.take(2)
        first_two_items.view()


    }

    // Task 4 - Return the squared values of the channel
    
    if (params.step == 4) {

        in_ch = channel.of(2,3,4)
        squared_values = in_ch.map { it -> it * it}
        squared_values.view()
    }

    // Task 5 - Remember the previous task where you squared the values of the channel. Now, extract the first two items from the squared channel

    if (params.step == 5) {

        in_ch = channel.of(2,3,4)
        squared_values = in_ch.map {it -> it * it}.take(2)
        squared_values.view()
        
    }

    // Task 6 - Remember when you used bash to reverse the output? Try to use map and Groovy to reverse the output

    if (params.step == 6) {
        
        in_ch = channel.of('Taylor', 'Swift')
        reversed_output = in_ch.map {it -> it.reverse()}
        reversed_output.view()

    }

    // Task 7 - Use fromPath to include all fastq files in the "files_dir" directory, then use map to return a pair containing the file name and the file path (Hint: include groovy code)

    if (params.step == 7) {
        //Use fromPath to include all fastq files in the "files_dir" directory
        in_ch = channel.fromPath('files_dir/*.fq')
        //then use map to return a pair containing the file name and the file path (Hint: include groovy code)
        pair = in_ch.map { fastq_files -> [fastq_files.getName(), fastq_files] }
        pair.view()

        
    }

    // Task 8 - Combine the items from the two channels into a single channel

    if (params.step == 8) {

        ch_1 = channel.of(1,2,3)
        ch_2 = channel.of(4,5,6)
        out_ch = channel.of("a", "b", "c")
        combined_items = out_ch.mix(ch_1,ch_2)
        combined_items.view()

    }

    // Task 9 - Flatten the channel

    if (params.step == 9) {

        in_ch = channel.of([1,2,3], [4,5,6])
        flattened_channel = in_ch.flatten()
        flattened_channel.view()


    }

    // Task 10 - Collect the items of a channel into a list. What kind of channel is the output channel (value)?

    if (params.step == 10) {

        in_ch = channel.of(1,2,3)
        items_in_list = in_ch.collect()
        items_in_list.view()


    }
    


    // Task 11 -  From the input channel, create lists where each first item in the list of lists is the first item in the output channel, followed by a list of all the items its paired with
    // e.g. 
    // in: [[1, 'A'], [1, 'B'], [1, 'C'], [2, 'D'], [2, 'E'], [3, 'F']]
    // out: [[1, ['A', 'B', 'C']], [2, ['D', 'E']], [3, ['F']]]

    if (params.step == 11) {

        in_ch = channel.of([1, 'V'], [3, 'M'], [2, 'O'], [1, 'f'], [3, 'G'], [1, 'B'], [2, 'L'], [2, 'E'], [3, '33'])
        paired_list = in_ch.groupTuple()        
        paired_list.view()
    }

    // Task 12 - Create a channel that joins the input to the output channel. What do you notice
    // 

    if (params.step == 12) {

        left_ch = channel.of([1, 'V'], [3, 'M'], [2, 'O'], [1, 'B'], [3, '33'])
        right_ch = channel.of([1, 'f'], [3, 'G'], [2, 'L'], [2, 'E'],)
        joined_input_output = left_ch.join(right_ch)
        joined_input_output.view()

    }

    // Task 13 - Split the input channel into two channels, one of all the even numbers and the other of all the odd numbers. Write the output of each channel to a list
    //           and write them to stdout including information which is which

    if (params.step == 13) {

        in_ch = channel.of(1,2,3,4,5,6,7,8,9,10)

        // Filter the channel for even numbers
        in_ch.branch{
            odd: it % 2 !=0
            even: it % 2 ==0
        }
        .set {out_ch}
        out_ch.odd.collect().dump(tag: 'odd')
        out_ch.even.collect().dump(tag: 'even')       
        

    }

    // Task 14 - Nextflow has the concept of maps. Write the names in the maps in this channel to a file called "names.txt".
    //           Each name should be on a new line. 
    //           Store the file in the "results" directory under the name "names.txt"

    if (params.step == 14) {

        in_ch = channel.of(
            ['name': 'Harry', 'title': 'student'],
            ['name': 'Ron', 'title': 'student'],
            ['name': 'Hermione', 'title': 'student'],
            ['name': 'Albus', 'title': 'headmaster'],
            ['name': 'Snape', 'title': 'teacher'],
            ['name': 'Hagrid', 'title': 'groundkeeper'],
            ['name': 'Dobby', 'title': 'hero'],
        )
        

        // Write names to the file
        in_ch
            .map { it.name } // Extract names
            .collectFile(newLine: true,  name:"names.txt", storeDir: "results")
            .view()
            }
    
    




    // Task 15 - Create a process that reads in a list of names and titles from a channel and writes them to a file.
    //          Store the file in the "results" directory under the name "names.tsv"
    process WRITETOFILE {
        // Specify the output file path
        output:
        path "results/names.tsv"

        // Define the input channel
        input:
        val nameData

        // Script to write names and titles to the file
        script:
        """
        echo ${nameData} > names.tsv
        """
    }

    



}
