Oftentimes, it's convenient to write a bash script.  Sure, you 
can probably make some equivalent python script, but sometimes
that's just overkill.

For example, say you want to write a simple command line script that downloads
a pre-trained model from TensorFlow's Object Detection Model Zoo, untars it,
then removes the tar file.  Given the script has been written, the call
from the command line will look similar for a bash or python script:

```
python get_tf_odz_model.py 'ssd_mobilenet_v2_coco_2018_03_29.tar.gz'
bash get_tf_odz_model.bash 'ssd_mobilenet_v2_coco_2018_03_29.tar.gz'
```

However, underneath the hood is a world of difference.  Check out how simple 
the bash script is:
```bash
URL="http://download.tensorflow.org/models/object_detection"  
wget ${URL}/${1}.tar.gz && tar -xvf ${1}.tar.gz && rm ${1}.tar.gz
```

Now look at the complexity of thisn equivalent python script:
```python
import urllib.request as urllib_request
import tarfile
import argparse
import os
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('model')
    args = parser.parse_args()
    URL="http://download.tensorflow.org/models/object_detection"
    opener = urllib_request.URLopener()
    opener.retrieve(URL+'/'+args.model+'.tar.gz', args.model+'.tar.gz')
    tar_file = tarfile.open(args.model+'.tar.gz')
    for file in tar_file.getmembers():
        file_name = os.path.basename(file.name)
        if 'frozen_inference_graph.pb' in file_name:
            tar_file.extract(file, os.getcwd())
    tar = tarfile.open(args.model+'.tar.gz', "r:gz")
    tar.extractall()
    tar.close()
    os.remove(args.model+'.tar.gz')
```

It's possible that some python ninja can write a slightly more terse script,
but not as terse as that bash script!

However, there is a slight catch.

Though the boilerplate `argparse` code in the python script almost seems like 
overkill for a single, positional command line argument, it very easily extends
to many positional args, keyword args, and boolean flags.  Bells and whistles
are very easy to add (default values, help info, constraints, and more).  

The same cannot exactly be said for bash scripts.  Using the positional
arguments (like `$1`, `$2`, and so on) can only get you so far.  However,
bash does have various ways to deal with command line arguments in a more
sophisticated way -- though I cannot promise all the bells and whistles
that `argparse` can provide in a python script.  But that's ok!  Bash
scripts are the best choice for simple-to-moderate tasks: usually they
are incredibly efficient and easy to write, and often they are extremely 
fast (piping together bash commands is highly optimized).  

Below, I provide several ways that can provide your bash scripts with
the ability to cope with more intricate command line needs.  




# Method 1:  "Args with Dollar-At ($@)"


This technique can handle many types of args: 
* flag
* -flag
* --flag
* key=val
* -key=val
* --key=val


Its only real weakness (if you want to call it that) is that you must
include an '=' sign for key-value pairs (some command line scripts are ok
if you use an equals sign or a space, e.g., `./myScript --arg=1` vs
`./myScript --arg 1`).  But that's such a minor gripe!  Other than that,
this method is very useful and robust.

The "dollar-at" method works almost the same exact way as the "dollar-hash"
method below.  The difference is that the dollar-at method is very tolerant
towards "bending the rules", while the dollar-hash method is very strict.  
Which one you choose really depends on your preference.  The dollar-hash
method's strictness gives you tight control over the function's behavior,
however the dollar-at method's tolerance gives some capacity to have clever
and/or flexible hacks.  

Here is an example script: `args_with_dollar_at.sh`
```
echo
for ARG in "$@"; do
    KEY=$(echo $ARG | cut -d= -f1 )
    VALUE=$(echo $ARG | cut -d= -f2 )   
    case "$KEY" in
        -v)    
            verbose=1
            ;;
        -f)
            filename=${VALUE} 
            ;;
        --test)
            test=1
            ;;
        --help)
            help=1
            ;;
        --color)
            color=${VALUE}
            ;;
        *)   
    esac    
done

if [ ! -z ${verbose} ]; then
  echo "-v is just a simple, single character boolean flag (-v is the same as -v=aNyThInG)"
  echo "verbose has been set to ${verbose}"
fi; echo
if [ ! -z ${filename} ]; then
  echo "-f requires a value: -f=<filename>"
  echo "filename has been set to ${filename}"
fi; echo
if [ ! -z ${test} ]; then
  echo "--test is just a simple, explicitly-named boolean flag, e.g., "
  echo "--test is same --test=AnYtHiNg"
  echo "test has been set to ${test}"
fi; echo
if [ ! -z ${help} ]; then
  echo "--help is just a simple, explicitly-named boolean flag, e.g., "
  echo "--help is same --help=AnYtHiNg"
  echo "help has been set to ${help}"
fi; echo
if [ ! -z ${color} ]; then
   echo "--color is an explicitly-named key; it requires a value (e.g., --color=green)"
  echo "color has been set to ${color}"
fi; echo
```

Try out a few things to see how it works:
```
# Simple boolean flags
bash args_with_dollar_at.sh -v               # sets verbose=1
bash args_with_dollar_at.sh -v=aNyThInG      # sets verbose=1
# Simple key-value pairs
bash args_with_dollar_at.sh -f=myFile.txt    # sets filename=myFile.txt
# Explicitly named boolean flags
bash args_with_dollar_at.sh --help           # sets help=1
bash args_with_dollar_at.sh --help=WhAtEvEr  # sets help=1
# Explicitly named key-value pairs
bash args_with_dollar_at.sh --color=GREEN    # sets color=GREEN
```






# Method 2: "Args with Dollar-Hash ($#)"

Like the dollar-at method above, the dollar-hash technique can handle many types 
of args: 
* flag
* -flag
* --flag
* key=val
* -key=val
* --key=val

It is very strict compared to the dollar-at method:
* if an argument is defined as a "key=value" pair in the script, then
  the argument better be a "key=value" pair at the command line
* likewise, if an argument is defined as a "flag" in the script (no "=" sign),
  then it better be a "flag" at the command line (`flag=aNyThInG` will 
  cause an error)
* the `exit` statement for the catchall case (`*`) helps convey
  how strict the dollar-hash method is; you can comment it out, but
  that only means that the strict behaviors just described will silently
  fail; the `exit` statement is just so natural for dollar-hash
  - similarly, you could add the `exit` statement to the more tolerant
    dollar-at method above; however, it won't change the tolerance for mutating
    flags and key-value pairs, though it will exit if a completely unrecognized 
    argument is passed 


```
while [ $# -gt 0 ]; do
  case "$1" in
    -v)
      verbose=1
      ;;
    -f=*)
      filename="${1#*=}"
      ;;
    --help)
      help=1
      ;;
    --test)
      test=1
      ;;
    --color=*)
      color="${1#*=}"
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument.*\n"
      printf "***************************\n"
      exit 1
  esac
  shift
done

if [ ! -z ${verbose} ]; then
  echo "-v is just a simple, single character boolean flag (-v is the same as -v=aNyThInG)"
  echo "verbose has been set to ${verbose}"
fi; echo
if [ ! -z ${filename} ]; then
  echo "-f requires a value: -f=<filename>"
  echo "filename has been set to ${filename}"
fi; echo
if [ ! -z ${test} ]; then
  echo "--test is just a simple, explicitly-named boolean flag, e.g., "
  echo "--test is same --test=AnYtHiNg"
  echo "test has been set to ${test}"
fi; echo
if [ ! -z ${help} ]; then
  echo "--help is just a simple, explicitly-named boolean flag, e.g., "
  echo "--help is same --help=AnYtHiNg"
  echo "help has been set to ${help}"
fi; echo
if [ ! -z ${color} ]; then
   echo "--color is an explicitly-named key; it requires a value (e.g., --color=green)"
  echo "color has been set to ${color}"
fi; echo
```

# Method 3:  Some Sort of Dollar-Hash, Dollar-At Juggernaut Hybrid
If you really want to see a well thought out argument handler, then
check out this GitHub gist that really seems to up the ante:
* https://gist.github.com/dgoguerra/9206418

Just in case that ever goes away, I'll copy and paste it here for 
convenience.  It's very instructive, though it might be overkill for quickly
writing simple, efficient scripts.

```
# File name
readonly PROGNAME=$(basename $0)
# File name, without the extension
readonly PROGBASENAME=${PROGNAME%.*}
# File directory
readonly PROGDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# Arguments
readonly ARGS="$@"
# Arguments number
readonly ARGNUM="$#"

usage() {
	echo "Script description"
	echo
	echo "Usage: $PROGNAME -i <file> -o <file> [options]..."
	echo
	echo "Options:"
	echo
	echo "  -h, --help"
	echo "      This help text."
	echo
	echo "  -i <file>, --input <file>"
	echo "      Input file. If \"-\", stdin will be used instead."
	echo
	echo "  -o <file>, --output <file>"
	echo "      Output file."
	echo
	echo "  --"
	echo "      Do not interpret any more arguments as options."
	echo
}

while [ "$#" -gt 0 ]
do
	case "$1" in
	-h|--help)
		usage
		exit 0
		;;
	-i|--input)
		input="$2"

		# Jump over <file>, in case "-" is a valid input file 
		# (keyword to standard input). Jumping here prevents reaching
		# "-*)" case when parsing <file>
		shift
		;;
	-o|--output)
		output="$2"
		;;
	--)
		break
		;;
	-*)
		echo "Invalid option '$1'. Use --help to see the valid options" >&2
		exit 1
		;;
	# an option argument, continue
	*)	
	    # You can add some printf and exit statements here if you want
	    ;;
	esac
	shift
done

# script content!
```

# Method 4:  getopts

I'm just including this one for completeness.  It also happens to be the one
I see on the web the most...despite the fact that it is the most restrictive.
This technique only accepts single-dash arguments.

```
#!/bin/bash
usage() { "Usage: $0 [-s <45|90>] [-p <string>]" 1>&2; exit 1; }
while getopts ":t:h:gg" opt; do
  case $opt in
    t) 
      test="$OPTARG"
      ;;
    h) 
      help="$OPTARG"
      ;;
    s)
      s=${OPTARG}
      ((s == 45 || s == 90)) || usage
      ;;
    p)
      p=${OPTARG}
      ;;
    *)
      usage
      ;;
  esac
done
```



More on `getopts`
* https://www.mkssoftware.com/docs/man1/getopts.1.asp
