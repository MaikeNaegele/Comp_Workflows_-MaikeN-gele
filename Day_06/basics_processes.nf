params.step = 0
params.zip = 'bz2'

//Task1 
process SAYHELLO {
    debug true

    script:
    """
    echo "Hello World!"
    """
}

//Task2
process SAYHELLO_PYTHON() {
    debug true
    
    script:
    """
    #!/usr/bin/env python
    print('Hello World!')
    """
}

//Task 3
process SAYHELLO_PARAM {
    debug true

    input:
    val greeting_ch

    script:
    """
    echo "${greeting_ch}" 
    """
}

//Task 4
process SAYHELLO_FILE {
    debug true  

    input:
    val greeting_ch

    output:
    path 'greeting.txt' 
    
    script:
    """
    printf "${greeting_ch}" > greeting.txt
    """
}

//Task 5 
process UPPERCASE{

    input:
    val greeting  

    output:
    path 'uppercase_greeting.txt' 
    
    script:
    """
    echo "${greeting}" | tr 'a-z' 'A-Z' > uppercase_greeting.txt
    """
}


//Task 6 
process PRINTUPPER{
    debug true

    input:
    path uppercase_file

    script:
    """
    cat $uppercase_file 
    
    """
}


//Task 7
process ZIPFILE_PARAMETER{
    input:
    path inputFile

    output:
    path "*.{gz,zip,bz2}"

    script:
    if(params.zip == 'zip' )
        """
        zip "${inputFile}.zip" "${inputFile}" 
        """

    else if( params.zip == 'gzip' )
        """
        gzip -f "${inputFile}"
        """

    else if( params.zip == 'bz2' )
        """
        bzip2 -f "${inputFile}"
        """
    
    else
        error "Invalid alignment mode: ${params.zip}"
}


//TAsk 8
process ZIPFILE{
    
    input:
    path inputFile

    output:
    path "${inputFile}.*"

    script:
    """
    zip "${inputFile}.zip" "${inputFile}" 
    gzip -c "${inputFile}" > "${inputFile}".gz
    bzip2 -c "${inputFile}" > "${inputFile}".bz2
    """
    
}

//Task 9
process WRITETOFILE{
    input:
    val in_ch

    output:
    path 'names.tsv'
    
    script:
    """
    echo "name\ttitle" > names.tsv
    echo "${in_ch.name}\t${in_ch.title}" >> names.tsv 
    """
}




workflow {

    // Task 1 - create a process that says Hello World! (add debug true to the process right after initializing to be sable to print the output to the console)
    if (params.step == 1) {
        SAYHELLO()
    }

    // Task 2 - create a process that says Hello World! using Python
    if (params.step == 2) {
        SAYHELLO_PYTHON()
    }

    // Task 3 - create a process that reads in the string "Hello world!" from a channel and write it to command line
    if (params.step == 3) {
        greeting_ch = Channel.of("Hello world!")
        SAYHELLO_PARAM(greeting_ch)
    }

    // Task 4 - create a process that reads in the string "Hello world!" from a channel and write it to a file. WHERE CAN YOU FIND THE FILE?
    if (params.step == 4) {
        greeting_ch = Channel.of("Hello world!")
        SAYHELLO_FILE(greeting_ch)
    }

    // Task 5 - create a process that reads in a string and converts it to uppercase and saves it to a file as output. View the path to the file in the console
    if (params.step == 5) {
        greeting_ch = Channel.of("Hello world!")
        out_ch = UPPERCASE(greeting_ch)
        out_ch.view()
    }

    // Task 6 - add another process that reads in the resulting file from UPPERCASE and print the content to the console (debug true). WHAT CHANGED IN THE OUTPUT?
    if (params.step == 6) {
        greeting_ch = Channel.of("Hello world!")
        out_ch = UPPERCASE(greeting_ch)
        PRINTUPPER(out_ch)
    }

    
    // Task 7 - based on the paramater "zip" (see at the head of the file), create a process that zips the file created in the UPPERCASE process either in "zip", "gzip" OR "bzip2" format.
    //          Print out the path to the zipped file in the console
    if (params.step == 7) {
        greeting_ch = Channel.of("Hello world!")
        out_ch = UPPERCASE(greeting_ch)
        zipped_ch = ZIPFILE_PARAMETER(out_ch)
        zipped_ch.view()
    }

    // Task 8 - Create a process that zips the file created in the UPPERCASE process in "zip", "gzip" AND "bzip2" format. Print out the paths to the zipped files in the console

    if (params.step == 8) {
        greeting_ch = Channel.of("Hello world!")
        out_ch = UPPERCASE(greeting_ch)
        zipped_ch = ZIPFILE(out_ch)
        zipped_ch.view()
    }


    if (params.step == 9) {
        in_ch = channel.of(
            ['name': 'Harry', 'title': 'student'],
            ['name': 'Ron', 'title': 'student'],
            ['name': 'Hermione', 'title': 'student'],
            ['name': 'Albus', 'title': 'headmaster'],
            ['name': 'Snape', 'title': 'teacher'],
            ['name': 'Hagrid', 'title': 'groundkeeper'],
            ['name': 'Dobby', 'title': 'hero'],
        )
        in_ch
            | WRITETOFILE
            | collectFile(name: "names.tsv", newLine:true,storeDir:"results", keepHeader:true)
            | view()       
    }

}