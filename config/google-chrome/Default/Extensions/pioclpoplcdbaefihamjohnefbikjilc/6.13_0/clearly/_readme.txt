
    These are the Clearly Components:
    =================================

        detect          => main-content detection, on arbitrary pages, using Clearly's content-detection algorithm
        next            => works with "detect", and provides multi-page detection and main-content detection on the pages found
        reformat        => re-displays HTML and re-styles it using CLearly's CSS
        highlight       => provides content highlighting, in arbitrary pages/windows

        detect_custom   => content detection, on specific sites/pages, using per-site rules
        reformat_custom => re-styles specific sites/pages, using per-site layouts

        
        All components have jQuery as a dependency.
        All components have a "test" folder, which functions both as a kind of unit-test, and as a fast way to quickly run/verify/debug each component.
        All components have usage examples, in the source comments, at the top.
        All components but "next" and "reformat_custom" work independently of each other:
            "next" has "detect" as a dependency; "reformat_custom" has "detect_custom" as a dependency.


    Folder structure:
    =================
    
        detect, 
        next, 
        reformat, 
        highlight,

        detect_custom, 
        reformat_custom  => the source for each component 
        
        _tests           => a set of test-suites for each component, and a few component combinations; these can be compiled into chrome extensions
        _do              => commands/scripts used
        __minified       => a copy of each component, but with the source minified
    
    
    Commands available:
    ===================
    
        _do/build-tests.py                          => will update the test-suites in "_tests" with the current source of each component
        _do/build-minified.py                       => will build the "__minified" directory, and will also minify the sources in "__tests"
        _do/jslint/jsl -conf _do/jslint/jsl.conf    => will run jslint on the individual component sources -- both the normal and minified versions
        