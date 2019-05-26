### ~ ~ ~ Run LTR_FINDER in parallel ~ ~ ~
This is a Perl wrapper for [LTR_FINEDR](https://github.com/xzhub/LTR_Finder). All rights reserved to the original author. It's free for non-commercial use. For commercial use, a software agreement is required for LTR_FINDER.

## Installation: No need. Just download and run.

Date: 09/19/2018
Update: 05/25/2019

Usage: perl LTR_FINDER_parallel -seq [file] -size [int] -threads [int]
Options:        -seq    [file]  Specify the sequence file.
                -size   [int]   Specify the size you want to split the genome sequence.
                                Please make it large enough to avoid spliting too many LTR elements. Default 5000000 (bp)
                -time   [int]   Specify the maximum time to run a subregion (a thread).
                                This helps to skip simple repeat regions that take a substantial of time to run. Default: 1500 (seconds).
                                Suggestion: 300 for -size 1000000. Increase -time when -size increased.
                -try1   [0|1]   If a region requires more time than the specified -time (timeout), decide:
                                        0, discard the entire region.
                                        1, further split to 50 Kb regions to salvage LTR candidates (default);
                -harvest_out    Output LTRharvest format if specified. Default: output LTR_FINDER table format.
                -next           Only summarize the results for previous jobs without rerunning LTR_FINDER (for -v).
                -verbose|-v     Retain LTR_FINDER outputs for each sequence piece.
                -cut    [file]  The path to the program cut.pl to split the sequence.
                -finder [file]  The path to the program LTR_FINDER.
                -threads|-t     [int]   Indicate how many CPU/threads you want to run LTR_FINDER.


## Parameter setting for LTR_FINDER
Currently there is no parameter settings for LTR_FINDER in this parallel version. I have chose the "best" parameters for you:
	> -w 2 -C -D 15000 -d 1000 -L 7000 -l 100 -p 20 -M 0.85
Please refer to LTR_FINDER for details of these parameters.
If you want to use other parameters in LTR_FINDER_parallel, please edit the file `LTR_FINDER_parallel` line 9 to change the preset parameters.

## Issues
I am using a non-overlapping way to cut the original sequence. Some LTR elements could be broken due to this. So far the side-effect is minimal (< 1% loss) comparing to the performance boost (up to 9,500X faster). I don't have a plan to update it to a sliding window scheme. Welcome to improve it and request for merge.
For any other issues please open a thread and I will be happy to help.
