#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <task>"
    exit 1
fi
# Assign the argument to a variable
task="$1"
case "$task" in
    tag|dedup|mix)
        echo "Valid task: $task"
        ;;
    *)
        echo "Invalid task: $task. Valid options are: tag, dedup, or mix"
        exit 1
        ;;
esac
export input_dir="./wikipedia/v0/documents/"
export array=($(find $input_dir -type f -name "*.gz"))
export nfiles=${#array[@]}
echo $nfiles
echo $array
if [ $RANK -eq 0 ]; then
	echo "Number of files: $nfiles"
fi
#for (( i=0; i<$nfiles; i+=1 ))
for (( i=$RANK; i<$nfiles; i+=$SIZE ))
do 
	input_json=${array[i]}
	echo ${input_json}
	if [ "$task" == "tag" ]; then
		echo "Initiate Dolma 'tagging'"
		CMD="dolma tag --documents ${input_json} --experiment exp --taggers random_number_v1 cld2_en_paragraph_with_doc_score_v2  ft_lang_id_en_paragraph_with_doc_score_v2 char_length_with_paragraphs_v1 whitespace_tokenizer_with_paragraphs_v1 --processes $NUM_WORKERS"	
		echo $CMD
		eval ${CMD}
	elif [ "$task" == "dedup" ]; then
		echo "Initiate Dolma 'dedup'"
		filter_dir=${input_dir%%/documents/}
		filter_dir="${filter_dir}/filter/"
		#echo $filter_dir
		[ -e $filter_dir ] || mkdir -p $filter_dir
		file_name="${input_json##*/}"
		file_name="${file_name%%.*}"
                filter_file="${filter_dir}deduper_bf_${file_name}.bin"
		#echo $filter_file
		CMD="dolma dedupe --documents ${input_json} --dedupe.paragraphs.attribute_name 'bff_duplicate_paragraph_spans' --dedupe.skip_empty --bloom_filter.file ${filter_file} --no-bloom_filter.read_only --bloom_filter.estimated_doc_count '6_000_000' --bloom_filter.desired_false_positive_rate '0.0001' --processes $NUM_WORKERS"
		echo $CMD
		eval ${CMD}
	fi
done
