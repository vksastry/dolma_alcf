## Installations on Polaris: 
```bash
module load conda/2023-10-04
conda activate base
pip install dolma
```

Note: Dolma installed in your .local here. 

## Data Example
The expected document in a file (in other terms, a jsonl entry/line in each jsonl file). Important to note that, the dolma toolkit requires 'id' associated with each of the jsonl files to be used. 
```bash
{'id': '1', 'source': 'wikipedia', 'version': 'v0', 'text': 'April\n\nApril (Apr.) is the fourth month of the year in the Julian and Gregorian calendars, and comes between March and May. It is one of the four months to have 30 days.\nApril always begins on the same day of the week as July, and additionally, January in leap years. April always ends on the same day of the week as December.\nThe Month.\nApril comes between March and May, making it the fourth month of the year. It also comes first in the year out of the four months that have 30 days, as June, September and November are later in the year.\nApril begins on the same day of the week as July every year and on the same day of the week as January in leap years. April ends on the same day of the week as December every year, as each other\'s last days are exactly 35 weeks (245 days) apart.\nIn common years, April starts on the same day of the week as October of the previous year, and in leap years, May of the previous year. In common years, April finishes on the same day of the week as July of the previous year, and in leap years, February and October of the previous year. In common years immediately after other common years, April starts on the same day of the week as January of the previous year, and in leap years and years immediately after that, April finishes on the same day of the week as January of the previous year.\nIn years immediately before common years, April starts on the same day of the week as September and December of the following year, and in years immediately before leap years, June of the following year. In years immediately before common years, April finishes on the same day of the week as September of the following year, and in years immediately before leap years, March and June of the following year.\nApril is a spring month in the Northern Hemisphere and an autumn/fall month in the Southern Hemisphere. In each hemisphere, it is the seasonal equivalent of October in the other.\nIt is unclear as to where April got its name. A common theory is that it comes from the Latin word "aperire", meaning "to open", referring to flowers opening in spring. Another theory is that the name could come from Aphrodite, the Greek goddess of love. It was originally the second month in the old Roman Calendar, before the start of the new year was put to January 1.\nQuite a few festivals are held in this month. In many Southeast Asian cultures, new year is celebrated in this month (including Songkran). In Western Christianity, Easter can be celebrated on a Sunday between March 22 and April 25. In Orthodox Christianity, it can fall between April 4 and May 8. At the end of the month, Central and Northern European cultures celebrate Walpurgis Night on April 30, marking the transition from winter into summer.\nApril in poetry.\nPoets use "April" to mean the end of winter. For example: "April showers bring May flowers."', 'created': '2023-10-01T00:00:00.000Z', 'added': '2024-01-24T20:02:59.580Z', 'metadata': {'revid': '9086769', 'url': 'https://simple.wikipedia.org/wiki?curid=1', 'length': 600}}​
```

## Directory structure 

The dolma toolkit has some dependency on the structure of the input directory. It assumes that the directory structure has the following directory tree. Ex: `{$PARENT_DIR}/documents/*.gz` where the `*.gz` are the jsonl files compressed under that directory. 
Ex: The wikipedia dataset uses: wikipedia/v0/documents/*.gz 

## Dolma Tagging 
```bash
dolma tag --documents "wikipedia/v0/documents/*" --experiment exp --taggers random_number_v1 cld2_en_paragraph_with_doc_score_v2  ft_lang_id_en_paragraph_with_doc_score_v2 char_length_with_paragraphs_v1 whitespace_tokenizer_with_paragraphs_v1 --processes 16
```
* --documents : path to the jsonl files.
* --experiment : The name of the o/p directory where the tagging attributes will be stored. For the above v0/documents/*.gz directory, The tagging information will be found under the following directory: v0/attributes/exp/*.gz -- These gz files will have the tagging information.
* --taggers : You can use the taggers that you are interested. Note that depending the type and number of taggers used, the time to process will vary considerably.  cld2_en_paragraph_with_doc_score_v2 and ft_lang_id_en_paragraph_with_doc_score_v2 takes a very long time.

The tagging information for the above data looks like below. 

Note: Each json line or entry is called a document. Each documents are split up to different paragraphs. ('\n' as the dilimiter). 
exp__whitespace_tokenizer_with_paragraphs_v1__document":[[0,2847,610.0]] suggests that the document has 2847 characters with 610 whitespaces. 
Attributes generated on paragraphs will generate in spans - (start_paragraph_idx, end_paragraph_idx, attribute value) For example look at attribute exp__cld2_en_paragraph_with_doc_score_v2__en (which indicates what probability the paragraph is from english languague), So ex: [7,170,0.99] says that a paragraph which starts from index 7 to index 170, the probability that it is english languague is 0.99. 

```bash
{"id":"1","attributes":{"exp__random_number_v1__random":[[0,2847,0.43444]],"exp__cld2_en_paragraph_with_doc_score_v2__en":[[0,6,0.0],[7,170,0.99],[170,327,0.99],[327,338,0.0],[338,542,0.99],[542,788,0.99],[788,1332,0.99],[1332,1739,0.99],[1739,1918,0.99],[1918,2290,0.99],[2290,2738,0.99],[2738,2755,0.94],[2755,2847,0.98]],"exp__cld2_en_paragraph_with_doc_score_v2__not_en":[[0,6,1.0],[7,170,0.01],[170,327,0.01],[327,338,1.0],[338,542,0.01],[542,788,0.01],[788,1332,0.01],[1332,1739,0.01],[1739,1918,0.01],[1918,2290,0.01],[2290,2738,0.01],[2738,2755,0.06],[2755,2847,0.02]],"exp__cld2_en_paragraph_with_doc_score_v2__doc_en":[[0,2847,0.98312]],"exp__cld2_en_paragraph_with_doc_score_v2__doc_not_en":[[0,2847,0.01688]],"exp__ft_lang_id_en_paragraph_with_doc_score_v2__en":[[0,6,0.6573],[7,170,0.97417],[170,327,0.98952],[327,338,0.95427],[338,542,0.99331],[542,788,0.98935],[788,1332,0.99042],[1332,1739,0.98888],[1739,1918,0.95124],[1918,2290,0.98682],[2290,2738,0.95478],[2738,2755,0.99506],[2755,2847,0.81944]],"exp__ft_lang_id_en_paragraph_with_doc_score_v2__not_en":[[0,6,0.3427],[7,170,0.02583],[170,327,0.01048],[327,338,0.04573],[338,542,0.00669],[542,788,0.01065],[788,1332,0.00958],[1332,1739,0.01112],[1739,1918,0.04876],[1918,2290,0.01318],[2290,2738,0.04522],[2738,2755,0.00494],[2755,2847,0.18056]],"exp__ft_lang_id_en_paragraph_with_doc_score_v2__doc_en":[[0,2847,0.9741]],"exp__ft_lang_id_en_paragraph_with_doc_score_v2__doc_not_en":[[0,2847,0.0259]],"exp__char_length_with_paragraphs_v1__paragraph":[[0,6,6.0],[7,170,163.0],[170,327,157.0],[327,338,11.0],[338,542,204.0],[542,788,246.0],[788,1332,544.0],[1332,1739,407.0],[1739,1918,179.0],[1918,2290,372.0],[2290,2738,448.0],[2738,2755,17.0],[2755,2847,92.0]],"exp__char_length_with_paragraphs_v1__document":[[0,2847,2847.0]],"exp__whitespace_tokenizer_with_paragraphs_v1__paragraph":[[0,6,2.0],[7,170,38.0],[170,327,35.0],[327,338,4.0],[338,542,46.0],[542,788,59.0],[788,1332,116.0],[1332,1739,79.0],[1739,1918,36.0],[1918,2290,80.0],[2290,2738,87.0],[2738,2755,5.0],[2755,2847,23.0]],"exp__whitespace_tokenizer_with_paragraphs_v1__document":[[0,2847,610.0]]},"source":"wikipedia"}
```

## Dedup 
```bash
dolma dedupe --documents "wikipedia/v0/documents/*" --dedupe.paragraphs.attribute_name 'bff_duplicate_paragraph_spans' --dedupe.skip_empty --bloom_filter.file /tmp/deduper_bloom_filter.bin --no-bloom_filter.read_only --bloom_filter.estimated_doc_count '6_000_000' --bloom_filter.desired_false_positive_rate '0.0001' --processes 16​
```
{"attributes":{"dedup":[]},"id":"1"}
{"attributes":{"dedup":[[397,408,1]]},"id":"2"}

de-dup work in terms of paragraph. Takes a document – which is one entry in each file. Then it checks for “\n” and splits it for that delimitter. So for each paragraph, say “April” or “The Month” in this case is mapped to [0,6] - creates a hash for this paragraph and inserts into a .bin file. In future when you comes across “The Month” in any other documents, there is a match. So it creates [paragraph_start_idx, paragraph_stop_idx, 1] - indicating that it is a duplicate. So paragraph de-dup is very exhaustive and also it has duplicate for even very short sentences.​ For example if you use a new bloom_filter.bin for wiki_00, the first document (id=1) has no duplicates, but it marks the id=2, [397,408,1] as duplicate, which corresponds to "The month" paragraph that was also present in the document id=1. 

If paragraph dedup is based on the filter.bin file we use. So if we want to make independent paragraph duplicates, we use separate .bin files. ​

To determine : By default, the min number of words to match between 2 paragraphs to mark it as a duplicate is 0. IMO it should be more than the sequence length we would like to try. ​

If you want to do the de-dup over the entire datasets, then use the same .bin file across all the documents under de-dup. Else specify a different bloom file for each file if you want to do it for a paragraph level inside the same directory. 

## Mixing or filtering 

Based on the tagging and de-deupe procedure, filter documents that match / do not match the constriants. ​
```bash
dolma -c wikipedia-mixer.yaml mix --processes 16​
```
Create this .yaml file as below. 

```bash
streams:
    - name: getting-started
      documents:
        - ./wikipedia/v0/documents/*.gz

      output:
        path: ./wikipedia/example0/documents
        max_size_in_bytes: 1_000_000_000
      attributes:
        - exp
        - dedup
      filter:
        include:
          - "$.attributes[?(@.exp__whitespace_tokenizer_with_paragraphs_v1__document[0][2] < 100000)]"
        exclude:
          - "$.attributes[?(@.exp__whitespace_tokenizer_with_paragraphs_v1__document[0][2] < 50)]"
          - "$.attributes[?(@.exp__ft_lang_id_en_paragraph_with_doc_score_v2__doc_en[0][2] <= 0.5)]"
          - "$@.attributes[?(@.bff_duplicate_paragraph_spans && @.bff_duplicate_paragraph_spans[0] && @.bff_duplicate_paragraph_spans[0][2] >= 1.0)]"

      span_replacement:
        - span: "$.attributes.exp__cld2_en_paragraph_with_doc_score_v2__not_en"
          min_score: 0.1
          replacement: ''

processes: 1
```
Filters for documents with 
  * less than 100000 words and more than 50 words
  * each paragraph has more than 0.5 probability of english. 
  * It is not tagged as duplicate. 
