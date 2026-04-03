$HOSTNAME = ""
params.outdir = 'results'  

// enable required indexes to build them
params.use_Bowtie2_Index = (params.run_Sequential_Mapping == "yes" || params.run_Bowtie2 == "yes") ? "yes" : ""
params.use_Bowtie_Index  = (params.run_Sequential_Mapping == "yes") ? "yes" : ""
params.use_STAR_Index    = (params.run_Sequential_Mapping == "yes") ? "yes" : ""

def pathChecker(input, path, type){
	def cmd = "mkdir -p check && mv ${input} check/. "
	if (!input || input.empty()){
		input = file(path).getName().toString()
		cmd = "mkdir -p check && cd check && ln -s ${path} ${input} && cd .."
		if (path.indexOf('s3:') > -1 || path.indexOf('S3:') >-1){
			def recursive = (type == "folder") ? "--recursive" : ""
			cmd = "mkdir -p check && cd check && aws s3 cp ${recursive} ${path} ${workDir}/${input} && ln -s ${workDir}/${input} . && cd .."
		} else if (path.indexOf('gs:') > -1 || path.indexOf('GS:') >-1){
			if (type == "folder"){
				cmd = "mkdir -p check ${workDir}/${input} && cd check && gsutil rsync -r ${path} ${workDir}/${input} && cp -R ${workDir}/${input} . && cd .."
			} else {
				cmd = "mkdir -p check && cd check && gsutil cp ${path} ${workDir}/${input} && cp -R ${workDir}/${input} . && cd .."
			}
		} else if (path.indexOf('/') == -1){
			cmd = ""
		}
}
	return [cmd,input]
}
if (!params.reads){params.reads = ""} 
if (!params.mate){params.mate = ""} 
if (!params.custom_additional_genome){params.custom_additional_genome = ""} 
if (!params.homerdb){params.homerdb = ""} 
if (!params.report_footer_logo){params.report_footer_logo = ""} 
if (!params.report_header_logo){params.report_header_logo = ""} 
if (!params.report_institute_css){params.report_institute_css = ""} 
// Stage empty file to be used as an optional input where required
ch_empty_file_1 = file("$baseDir/.emptyfiles/NO_FILE_1", hidden:true)
ch_empty_file_2 = file("$baseDir/.emptyfiles/NO_FILE_2", hidden:true)
ch_empty_file_3 = file("$baseDir/.emptyfiles/NO_FILE_3", hidden:true)
ch_empty_file_4 = file("$baseDir/.emptyfiles/NO_FILE_4", hidden:true)
ch_empty_file_5 = file("$baseDir/.emptyfiles/NO_FILE_5", hidden:true)
ch_empty_file_6 = file("$baseDir/.emptyfiles/NO_FILE_6", hidden:true)
ch_empty_file_7 = file("$baseDir/.emptyfiles/NO_FILE_7", hidden:true)
ch_empty_file_8 = file("$baseDir/.emptyfiles/NO_FILE_8", hidden:true)
ch_empty_file_9 = file("$baseDir/.emptyfiles/NO_FILE_9", hidden:true)
ch_empty_file_10 = file("$baseDir/.emptyfiles/NO_FILE_10", hidden:true)
ch_empty_file_11 = file("$baseDir/.emptyfiles/NO_FILE_11", hidden:true)
ch_empty_file_12 = file("$baseDir/.emptyfiles/NO_FILE_12", hidden:true)

if (params.reads){
Channel
	.fromFilePairs( params.reads,checkExists:true , size: params.mate == "single" ? 1 : params.mate == "pair" ? 2 : params.mate == "triple" ? 3 : params.mate == "quadruple" ? 4 : -1 ) 
	.set{g_1_1_g71_28}
 (g_1_0_g71_18) = [g_1_1_g71_28]
 } else {  
	g_1_1_g71_28 = Channel.empty()
	g_1_0_g71_18 = Channel.empty()
 }

Channel.value(params.mate).set{g_2_1_g72_26}
(g_2_1_g72_30,g_2_1_g72_46,g_2_1_g71_11,g_2_1_g71_16,g_2_1_g71_21,g_2_1_g71_24,g_2_0_g71_28,g_2_0_g71_31,g_2_1_g71_18,g_2_1_g71_23,g_2_1_g71_19,g_2_1_g71_20,g_2_1_g73_10,g_2_1_g73_3,g_2_0_g87_6,g_2_0_g87_9,g_2_1_g74_82,g_2_0_g74_131) = [g_2_1_g72_26,g_2_1_g72_26,g_2_1_g72_26,g_2_1_g72_26,g_2_1_g72_26,g_2_1_g72_26,g_2_1_g72_26,g_2_1_g72_26,g_2_1_g72_26,g_2_1_g72_26,g_2_1_g72_26,g_2_1_g72_26,g_2_1_g72_26,g_2_1_g72_26,g_2_1_g72_26,g_2_1_g72_26,g_2_1_g72_26,g_2_1_g72_26]
g_86_2_g78_58 = params.custom_additional_genome && file(params.custom_additional_genome, type: 'any').exists() ? file(params.custom_additional_genome, type: 'any') : ch_empty_file_1
g_96_1_g95_2 = file(params.homerdb, type: 'any')
g_96_0_g95_5 = file(params.homerdb, type: 'any')
g_102_8_g_99 = params.report_footer_logo && file(params.report_footer_logo, type: 'any').exists() ? file(params.report_footer_logo, type: 'any') : ch_empty_file_9
g_103_9_g_99 = params.report_header_logo && file(params.report_header_logo, type: 'any').exists() ? file(params.report_header_logo, type: 'any') : ch_empty_file_10
g_108_10_g_99 = params.report_institute_css && file(params.report_institute_css, type: 'any').exists() ? file(params.report_institute_css, type: 'any') : ch_empty_file_11

//* params.run_Adapter_Removal =   "no"   //* @dropdown @options:"yes","no" @show_settings:"Adapter_Removal"
//* @style @multicolumn:{seed_mismatches, palindrome_clip_threshold, simple_clip_threshold} @condition:{Tool_for_Adapter_Removal="trimmomatic", seed_mismatches, palindrome_clip_threshold, simple_clip_threshold}, {Tool_for_Adapter_Removal="fastx_clipper", discard_non_clipped}


//* autofill
if ($HOSTNAME == "default"){
    $CPU  = 5
    $MEMORY = 5
}
//* platform
//* platform
//* autofill

process Adapter_Trimmer_Quality_Module_Adapter_Removal {

input:
 tuple val(name), file(reads)
 val mate

output:
 tuple val(name), file("reads/*.fastq.gz")  ,emit:g71_18_reads01_g71_31 
 path "*.{fastx,trimmomatic}.log"  ,emit:g71_18_log_file10_g71_11 

errorStrategy 'retry'

when:
(params.run_Adapter_Removal && (params.run_Adapter_Removal == "yes")) || !params.run_Adapter_Removal

shell:
phred = params.Adapter_Trimmer_Quality_Module_Adapter_Removal.phred
Tool_for_Adapter_Removal = params.Adapter_Trimmer_Quality_Module_Adapter_Removal.Tool_for_Adapter_Removal
Adapter_Sequence = params.Adapter_Trimmer_Quality_Module_Adapter_Removal.Adapter_Sequence
//trimmomatic_inputs
min_length = params.Adapter_Trimmer_Quality_Module_Adapter_Removal.min_length
seed_mismatches = params.Adapter_Trimmer_Quality_Module_Adapter_Removal.seed_mismatches
palindrome_clip_threshold = params.Adapter_Trimmer_Quality_Module_Adapter_Removal.palindrome_clip_threshold
simple_clip_threshold = params.Adapter_Trimmer_Quality_Module_Adapter_Removal.simple_clip_threshold

//fastx_clipper_inputs
discard_non_clipped = params.Adapter_Trimmer_Quality_Module_Adapter_Removal.discard_non_clipped
    
remove_previous_reads = params.Adapter_Trimmer_Quality_Module_Adapter_Removal.remove_previous_reads
discard_non_clipped_text = ""
if (discard_non_clipped == "yes") {discard_non_clipped_text = "-c"}
nameAll = reads.toString()
nameArray = nameAll.split(' ')
file2 = ""
if (nameAll.contains('.gz')) {
    newName =  nameArray[0] 
    file1 =  nameArray[0]
    if (mate == "pair") {file2 =  nameArray[1] }
} 
'''
#!/usr/bin/env perl
 use List::Util qw[min max];
 use strict;
 use File::Basename;
 use Getopt::Long;
 use Pod::Usage;
 use Cwd qw();
 
runCmd("mkdir reads adapter unpaired");

open(OUT, ">adapter/adapter.fa");
my @adaps=split(/\n/,"!{Adapter_Sequence}");
my $i=1;
foreach my $adap (@adaps)
{
 print OUT ">adapter$i\\n$adap\\n";
 $i++;
}
close(OUT);

my $quality="!{phred}";
print "fastq quality: $quality\\n";
print "tool: !{Tool_for_Adapter_Removal}\\n";

if ("!{mate}" eq "pair") {
    if ("!{Tool_for_Adapter_Removal}" eq "trimmomatic") {
        runCmd("trimmomatic PE -threads !{task.cpus} -phred${quality} !{file1} !{file2} reads/!{name}.1.fastq.gz unpaired/!{name}.1.fastq.unpaired.gz reads/!{name}.2.fastq.gz unpaired/!{name}.2.fastq.unpaired.gz ILLUMINACLIP:adapter/adapter.fa:!{seed_mismatches}:!{palindrome_clip_threshold}:!{simple_clip_threshold} MINLEN:!{min_length} 2> !{name}.trimmomatic.log");
    } elsif ("!{Tool_for_Adapter_Removal}" eq "fastx_clipper") {
        print "Fastx_clipper is not suitable for paired reads.";
    }
} else {
    if ("!{Tool_for_Adapter_Removal}" eq "trimmomatic") {
        runCmd("trimmomatic SE -threads !{task.cpus}  -phred${quality} !{file1} reads/!{name}.fastq.gz ILLUMINACLIP:adapter/adapter.fa:!{seed_mismatches}:!{palindrome_clip_threshold}:!{simple_clip_threshold} MINLEN:!{min_length} 2> !{name}.trimmomatic.log");
    } elsif ("!{Tool_for_Adapter_Removal}" eq "fastx_clipper") {
        runCmd("fastx_clipper  -Q $quality -a !{Adapter_Sequence} -l !{min_length} !{discard_non_clipped_text} -v -i !{file1} -o reads/!{name}.fastq.gz > !{name}.fastx.log");
    }
}
if ("!{remove_previous_reads}" eq "true") {
    my $currpath = Cwd::cwd();
    my @paths = (split '/', $currpath);
    splice(@paths, -2);
    my $workdir= join '/', @paths;
    splice(@paths, -1);
    my $inputsdir = join '/', @paths;
    $inputsdir .= "/work";
    print "INFO: inputs reads will be removed if they are located in the $workdir $inputsdir\\n";
    my @listOfFiles = `readlink -e !{file1} !{file2}`;
    foreach my $targetFile (@listOfFiles){
        if (index($targetFile, $workdir) != -1 || index($targetFile, $inputsdir) != -1) {
            runCmd("rm -f $targetFile");
            print "INFO: $targetFile deleted.\\n";
        }
    }
}


##Subroutines
sub runCmd {
    my ($com) = @_;
    if ($com eq ""){
		return "";
    }
    my $error = system(@_);
    if   ($error) { die "Command failed: $error $com\\n"; }
    else          { print "Command successful: $com\\n"; }
}
'''

}


process Adapter_Trimmer_Quality_Module_Adapter_Removal_Summary {

publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /adapter_removal_detailed_summary.tsv$/) "adapter_removal_detailed_summary/$filename"}
input:
 path logfile
 val mate

output:
 path "adapter_removal_summary.tsv"  ,emit:g71_11_outputFileTSV05_g_75 
 path "adapter_removal_detailed_summary.tsv" ,optional:true  ,emit:g71_11_outputFile11 

shell:
'''
#!/usr/bin/env perl
use List::Util qw[min max];
use strict;
use File::Basename;
use Getopt::Long;
use Pod::Usage;
use Data::Dumper;

my @header;
my %all_files;
my %tsv;
my %tsvDetail;
my %headerHash;
my %headerText;
my %headerTextDetail;

my $i = 0;
chomp( my $contents = `ls *.log` );

my @files = split( /[\\n]+/, $contents );
foreach my $file (@files) {
    $i++;
    my $mapOrder = "1";
    if ($file =~ /(.*)\\.fastx\\.log/){
        $file =~ /(.*)\\.fastx\\.log/;
        my $mapper   = "fastx";
        my $name = $1;    ##sample name
        push( @header, $mapper );

        my $in;
        my $out;
        my $tooshort;
        my $adapteronly;
        my $noncliped;
        my $Nreads;

        chomp( $in =`cat $file | grep 'Input:' | awk '{sum+=\\$2} END {print sum}'` );
        chomp( $out =`cat $file | grep 'Output:' | awk '{sum+=\\$2} END {print sum}'` );
        chomp( $tooshort =`cat $file | grep 'too-short reads' | awk '{sum+=\\$2} END {print sum}'`);
        chomp( $adapteronly =`cat $file | grep 'adapter-only reads' | awk '{sum+=\\$2} END {print sum}'`);
        chomp( $noncliped =`cat $file | grep 'non-clipped reads.' | awk '{sum+=\\$2} END {print sum}'`);
        chomp( $Nreads =`cat $file | grep 'N reads.' | awk '{sum+=\\$2} END {print sum}'` );

        $tsv{$name}{$mapper} = [ $in, $out ];
        $headerHash{$mapOrder} = $mapper;
        $headerText{$mapOrder} = [ "Total Reads", "Reads After Adapter Removal" ];
        $tsvDetail{$name}{$mapper} = [ $in, $tooshort, $adapteronly, $noncliped, $Nreads, $out ];
        $headerTextDetail{$mapOrder} = ["Total Reads","Too-short reads","Adapter-only reads","Non-clipped reads","N reads","Reads After Adapter Removal"];
    } elsif ($file =~ /(.*)\\.trimmomatic\\.log/){
        $file =~ /(.*)\\.trimmomatic\\.log/;
        my $mapper   = "trimmomatic";
        my $name = $1;    ##sample name
        push( @header, $mapper );
        
        my $in;
        my $out;

        if ( "!{mate}" eq "pair"){
            chomp( $in =`cat $file | grep 'Input Read Pairs:' | awk '{sum+=\\$4} END {print sum}'` );
            chomp( $out =`cat $file | grep 'Input Read Pairs:' | awk '{sum+=\\$7} END {print sum}'` );
        } else {
            chomp( $in =`cat $file | grep 'Input Reads:' | awk '{sum+=\\$3} END {print sum}'` );
            chomp( $out =`cat $file | grep 'Input Reads:' | awk '{sum+=\\$5} END {print sum}'` );
        }
        


        $tsv{$name}{$mapper} = [ $in, $out ];
        $headerHash{$mapOrder} = $mapper;
        $headerText{$mapOrder} = [ "Total Reads", "Reads After Adapter Removal" ];
        
    }
    
}

my @mapOrderArray = ( keys %headerHash );
my @sortedOrderArray = sort { $a <=> $b } @mapOrderArray;

my $summary          = "adapter_removal_summary.tsv";
my $detailed_summary = "adapter_removal_detailed_summary.tsv";
writeFile( $summary,          \\%headerText,       \\%tsv );
if (%headerTextDetail){
    writeFile( $detailed_summary, \\%headerTextDetail, \\%tsvDetail );  
}

sub writeFile {
    my $summary    = $_[0];
    my %headerText = %{ $_[1] };
    my %tsv        = %{ $_[2] };
    open( OUT, ">$summary" );
    print OUT "Sample\\t";
    my @headArr = ();
    for my $mapOrder (@sortedOrderArray) {
        push( @headArr, @{ $headerText{$mapOrder} } );
    }
    my $headArrAll = join( "\\t", @headArr );
    print OUT "$headArrAll\\n";

    foreach my $name ( keys %tsv ) {
        my @rowArr = ();
        for my $mapOrder (@sortedOrderArray) {
            push( @rowArr, @{ $tsv{$name}{ $headerHash{$mapOrder} } } );
        }
        my $rowArrAll = join( "\\t", @rowArr );
        print OUT "$name\\t$rowArrAll\\n";
    }
    close(OUT);
}

'''
}

//* @style @condition:{single_or_paired_end_reads="single", barcode_pattern1,remove_duplicates_based_on_UMI}, {single_or_paired_end_reads="pair", barcode_pattern1,barcode_pattern2}


process Adapter_Trimmer_Quality_Module_UMIextract {

input:
 tuple val(name), file(reads)
 val mate

output:
 tuple val(name), file("result/*.fastq.gz")  ,emit:g71_23_reads00_g71_19 
 path "${name}.*.log"  ,emit:g71_23_log_file10_g71_24 

container 'quay.io/ummsbiocore/fastq_preprocessing:1.0'

when:
params.run_UMIextract == "yes" 

script:
readArray = reads.toString().split(' ')
file2 = ""
file1 =  readArray[0]
if (mate == "pair") {file2 =  readArray[1]}


single_or_paired_end_reads = params.Adapter_Trimmer_Quality_Module_UMIextract.single_or_paired_end_reads
barcode_pattern1 = params.Adapter_Trimmer_Quality_Module_UMIextract.barcode_pattern1
barcode_pattern2 = params.Adapter_Trimmer_Quality_Module_UMIextract.barcode_pattern2
UMIqualityFilterThreshold = params.Adapter_Trimmer_Quality_Module_UMIextract.UMIqualityFilterThreshold
phred = params.Adapter_Trimmer_Quality_Module_UMIextract.phred
remove_duplicates_based_on_UMI = params.Adapter_Trimmer_Quality_Module_UMIextract.remove_duplicates_based_on_UMI

"""
set +e
source activate umi_tools_env 2> /dev/null || true
mkdir result
if [ "${mate}" == "pair" ]; then
umi_tools extract --bc-pattern='${barcode_pattern1}' \
                  --bc-pattern2='${barcode_pattern2}' \
                  --extract-method=regex \
                  --stdin=${file1} \
                  --stdout=result/${name}_R1.fastq.gz \
                  --read2-in=${file2} \
                  --read2-out=result/${name}_R2.fastq.gz\
				  --quality-filter-threshold=${UMIqualityFilterThreshold} \
				  --quality-encoding=phred${phred} \
				  --log=${name}.umitools.log 


else
umi_tools extract --bc-pattern='${barcode_pattern1}' \
                  --log=${name}.umitools.log \
                  --extract-method=regex \
                  --stdin ${file1} \
                  --stdout result/${name}.fastq.gz \
				  --quality-filter-threshold=${UMIqualityFilterThreshold} \
				  --quality-encoding=phred${phred}
	if [ "${remove_duplicates_based_on_UMI}" == "true" ]; then		  
        mv result/${name}.fastq.gz  result/${name}_umitools.fastq.gz && gunzip result/${name}_umitools.fastq.gz
        ## only checks last part of the underscore splitted header for UMI
        awk '(NR%4==1){name=\$1;header=\$0;len=split(name,umiAr,"_");umi=umiAr[len];} (NR%4==2){total++;if(a[umi]!=1){nondup++;a[umi]=1;  print header;print;getline; print; getline; print;}} END{print FILENAME"\\t"total"\\t"nondup > "${name}.dedup.log"}' result/${name}_umitools.fastq > result/${name}.fastq
        rm result/${name}_umitools.fastq
        gzip result/${name}.fastq
	fi			  
fi
"""

}

//* params.run_Trimmer =   "no"   //* @dropdown @options:"yes","no" @show_settings:"Trimmer"
//* @style @multicolumn:{trim_length_5prime,trim_length_3prime}, {trim_length_5prime_R1,trim_length_3prime_R1}, {trim_length_5prime_R2,trim_length_3prime_R2} @condition:{single_or_paired_end_reads="single", trim_length_5prime,trim_length_3prime}, {single_or_paired_end_reads="pair", trim_length_5prime_R1,trim_length_3prime_R1,trim_length_5prime_R2,trim_length_3prime_R2}

//* autofill
//* platform
//* platform
//* autofill

process Adapter_Trimmer_Quality_Module_Trimmer {

input:
 tuple val(name), file(reads)
 val mate

output:
 tuple val(name), file("reads/*q.gz")  ,emit:g71_19_reads00_g71_20 
 path "*.log" ,optional:true  ,emit:g71_19_log_file10_g71_21 

errorStrategy 'retry'

when:
(params.run_Trimmer && (params.run_Trimmer == "yes")) || !params.run_Trimmer

shell:
phred = params.Adapter_Trimmer_Quality_Module_Trimmer.phred
single_or_paired_end_reads = params.Adapter_Trimmer_Quality_Module_Trimmer.single_or_paired_end_reads
trim_length_5prime = params.Adapter_Trimmer_Quality_Module_Trimmer.trim_length_5prime
trim_length_3prime = params.Adapter_Trimmer_Quality_Module_Trimmer.trim_length_3prime
trim_length_5prime_R1 = params.Adapter_Trimmer_Quality_Module_Trimmer.trim_length_5prime_R1
trim_length_3prime_R1 = params.Adapter_Trimmer_Quality_Module_Trimmer.trim_length_3prime_R1
trim_length_5prime_R2 = params.Adapter_Trimmer_Quality_Module_Trimmer.trim_length_5prime_R2
trim_length_3prime_R2 = params.Adapter_Trimmer_Quality_Module_Trimmer.trim_length_3prime_R2
remove_previous_reads = params.Adapter_Trimmer_Quality_Module_Trimmer.remove_previous_reads



file1 =  reads[0] 
file2 = ""
if (mate == "pair") {file2 =  reads[1] }
rawFile1 = "_length_check1.fastq"
rawFile2 = "_length_check2.fastq"
'''
#!/usr/bin/env perl
 use List::Util qw[min max];
 use strict;
 use File::Basename;
 use Getopt::Long;
 use Pod::Usage; 
 use Cwd qw();
 
runCmd("mkdir reads");
runCmd("zcat !{file1} | head -n 100 > !{rawFile1}");
if ("!{mate}" eq "pair") {
	runCmd("zcat !{file2} | head -n 100 > !{rawFile2}");
}
my $file1 = "";
my $file2 = "";
if ("!{mate}" eq "pair") {
    $file1 = "!{file1}";
    $file2 = "!{file2}";
    my $trim1 = "!{trim_length_5prime_R1}:!{trim_length_3prime_R1}";
    my $trim2 = "!{trim_length_5prime_R2}:!{trim_length_3prime_R2}";
    my $len=getLength("!{rawFile1}");
    print "length of $file1: $len\\n";
    trimFiles($file1, $trim1, $len);
    my $len=getLength("!{rawFile2}");
    print "INFO: length of $file2: $len\\n";
    trimFiles($file2, $trim2, $len);
} else {
    $file1 = "!{file1}";
    my $trim1 = "!{trim_length_5prime}:!{trim_length_3prime}";
    my $len=getLength("!{rawFile1}");
    print "INFO: length of file1: $len\\n";
    trimFiles($file1, $trim1, $len);
}
if ("!{remove_previous_reads}" eq "true") {
    my $currpath = Cwd::cwd();
    my @paths = (split '/', $currpath);
    splice(@paths, -2);
    my $workdir= join '/', @paths;
    splice(@paths, -1);
    my $inputsdir= join '/', @paths;
    $inputsdir .= "/inputs";
    print "INFO: inputs reads will be removed if they are located in the workdir inputsdir\\n";
    my @listOfFiles = `readlink -e !{file1} !{file2}`;
    foreach my $targetFile (@listOfFiles){
        if (index($targetFile, $workdir) != -1 || index($targetFile, $inputsdir) != -1) {
            runCmd("rm -f $targetFile");
            print "INFO: $targetFile deleted.\\n";
        }
    }
}



sub trimFiles
{
  my ($file, $trim, $len)=@_;
    my @nts=split(/[,:\\s\\t]+/,$trim);
    my $inpfile="";
    my $com="";
    my $i=1;
    my $outfile="";
    my $param="";
    my $quality="-Q!{phred}";

    if (scalar(@nts)==2)
    {
      $param = "-f ".($nts[0]+1) if (exists($nts[0]) && $nts[0] >= 0 );
      $param .= " -l ".($len-$nts[1]) if (exists($nts[0]) && $nts[1] > 0 );
      $outfile="reads/$file";  
      $com="gunzip -c $file | fastx_trimmer $quality -v $param -z -o $outfile  > !{name}.fastx_trimmer.log" if ((exists($nts[0]) && $nts[0] > 0) || (exists($nts[0]) && $nts[1] > 0 ));
      print "INFO: $com\\n";
      if ($com eq ""){
          print "INFO: Trimmer skipped for $file \\n";
          runCmd("mv $file reads/.");
      } else {
          runCmd("$com");
          print "INFO: Trimmer executed for $file \\n";
      }
    }

    
}


sub getLength
{
   my ($filename)=@_;
   open (IN, $filename);
   my $j=1;
   my $len=0;
   while(my $line=<IN>)
   {
     chomp($line);
     if ($j >50) { last;}
     if ($j%4==0)
     {
        $len=length($line);
     }
     $j++;
   }
   close(IN);
   return $len;
}

sub runCmd {
    my ($com) = @_;
    if ($com eq ""){
		return "";
    }
    my $error = system(@_);
    if   ($error) { die "Command failed: $error $com\\n"; }
    else          { print "Command successful: $com\\n"; }
}

'''

}


process Adapter_Trimmer_Quality_Module_Trimmer_Removal_Summary {

input:
 path logfile
 val mate

output:
 path "trimmer_summary.tsv"  ,emit:g71_21_outputFileTSV06_g_75 

shell:
'''
#!/usr/bin/env perl
use List::Util qw[min max];
use strict;
use File::Basename;
use Getopt::Long;
use Pod::Usage;
use Data::Dumper;

my @header;
my %all_files;
my %tsv;
my %tsvDetail;
my %headerHash;
my %headerText;
my %headerTextDetail;

my $i = 0;
chomp( my $contents = `ls *.log` );

my @files = split( /[\\n]+/, $contents );
foreach my $file (@files) {
    $i++;
    my $mapOrder = "1";
    if ($file =~ /(.*)\\.fastx_trimmer\\.log/){
        $file =~ /(.*)\\.fastx_trimmer\\.log/;
        my $mapper   = "fastx_trimmer";
        my $name = $1;    ##sample name
        push( @header, $mapper );
        my $in;
        my $out;
        chomp( $in =`cat $file | grep 'Input:' | awk '{sum+=\\$2} END {print sum}'` );
        chomp( $out =`cat $file | grep 'Output:' | awk '{sum+=\\$2} END {print sum}'` );

        $tsv{$name}{$mapper} = [ $in, $out ];
        $headerHash{$mapOrder} = $mapper;
        $headerText{$mapOrder} = [ "Total Reads", "Reads After Trimmer" ];
    }
}

my @mapOrderArray = ( keys %headerHash );
my @sortedOrderArray = sort { $a <=> $b } @mapOrderArray;

my $summary          = "trimmer_summary.tsv";
writeFile( $summary,          \\%headerText,       \\%tsv );

sub writeFile {
    my $summary    = $_[0];
    my %headerText = %{ $_[1] };
    my %tsv        = %{ $_[2] };
    open( OUT, ">$summary" );
    print OUT "Sample\\t";
    my @headArr = ();
    for my $mapOrder (@sortedOrderArray) {
        push( @headArr, @{ $headerText{$mapOrder} } );
    }
    my $headArrAll = join( "\\t", @headArr );
    print OUT "$headArrAll\\n";

    foreach my $name ( keys %tsv ) {
        my @rowArr = ();
        for my $mapOrder (@sortedOrderArray) {
            push( @rowArr, @{ $tsv{$name}{ $headerHash{$mapOrder} } } );
        }
        my $rowArrAll = join( "\\t", @rowArr );
        print OUT "$name\\t$rowArrAll\\n";
    }
    close(OUT);
}

'''
}

//* params.run_Quality_Filtering =   "no"   //* @dropdown @options:"yes","no" @show_settings:"Quality_Filtering"
//* @style @multicolumn:{window_size,required_quality}, {leading,trailing,minlen}, {minQuality,minPercent} @condition:{tool="trimmomatic", minlen, trailing, leading, required_quality_for_window_trimming, window_size}, {tool="fastx", minQuality, minPercent}

//* autofill
//* platform
//* platform
//* autofill

process Adapter_Trimmer_Quality_Module_Quality_Filtering {

input:
 tuple val(name), file(reads)
 val mate

output:
 tuple val(name), file("reads/*.gz")  ,emit:g71_20_reads00_g72_46 
 path "*.{fastx,trimmomatic}_quality.log" ,optional:true  ,emit:g71_20_log_file10_g71_16 

when:
(params.run_Quality_Filtering && (params.run_Quality_Filtering == "yes")) || !params.run_Quality_Filtering    

shell:
tool = params.Adapter_Trimmer_Quality_Module_Quality_Filtering.tool
phred = params.Adapter_Trimmer_Quality_Module_Quality_Filtering.phred
window_size = params.Adapter_Trimmer_Quality_Module_Quality_Filtering.window_size
required_quality_for_window_trimming = params.Adapter_Trimmer_Quality_Module_Quality_Filtering.required_quality_for_window_trimming
leading = params.Adapter_Trimmer_Quality_Module_Quality_Filtering.leading
trailing = params.Adapter_Trimmer_Quality_Module_Quality_Filtering.trailing
minlen = params.Adapter_Trimmer_Quality_Module_Quality_Filtering.minlen


// fastx parameters
minQuality = params.Adapter_Trimmer_Quality_Module_Quality_Filtering.minQuality
minPercent = params.Adapter_Trimmer_Quality_Module_Quality_Filtering.minPercent

remove_previous_reads = params.Adapter_Trimmer_Quality_Module_Quality_Filtering.remove_previous_reads

nameAll = reads.toString()
nameArray = nameAll.split(' ')
file2 ="";
if (nameAll.contains('.gz')) {
    file1 =  nameArray[0] 
    if (mate == "pair") {file2 =  nameArray[1]}
} 
'''
#!/usr/bin/env perl
 use List::Util qw[min max];
 use strict;
 use File::Basename;
 use Getopt::Long;
 use Pod::Usage; 
 use Cwd qw();
 
runCmd("mkdir reads unpaired");
my $param = "SLIDINGWINDOW:"."!{window_size}".":"."!{required_quality_for_window_trimming}";
$param.=" LEADING:"."!{leading}";
$param.=" TRAILING:"."!{trailing}";
$param.=" MINLEN:"."!{minlen}";

my $quality="!{phred}";

print "INFO: fastq quality: $quality\\n";
     
if ("!{tool}" eq "trimmomatic") {
    if ("!{mate}" eq "pair") {
        runCmd("trimmomatic PE -phred${quality} !{file1} !{file2} reads/!{name}.1.fastq.gz unpaired/!{name}.1.fastq.unpaired.gz reads/!{name}.2.fastq.gz unpaired/!{name}.2.fastq.unpaired.gz $param 2> !{name}.trimmomatic_quality.log");
    } else {
        runCmd("trimmomatic SE -phred${quality} !{file1} reads/!{name}.fastq.gz $param 2> !{name}.trimmomatic_quality.log");
    }
} elsif ("!{tool}" eq "fastx") {
    if ("!{mate}" eq "pair") {
        print("WARNING: Fastx option is not suitable for paired reads. This step will be skipped.");
        runCmd("mv !{file1} !{file2} reads/.");
    } else {
        runCmd("fastq_quality_filter  -Q $quality -q !{minQuality} -p !{minPercent} -v -i !{file1} -o reads/!{name}.fastq.gz > !{name}.fastx_quality.log");
    }
}
if ("!{remove_previous_reads}" eq "true") {
    my $currpath = Cwd::cwd();
    my @paths = (split '/', $currpath);
    splice(@paths, -2);
    my $workdir= join '/', @paths;
    splice(@paths, -1);
    my $inputsdir= join '/', @paths;
    $inputsdir .= "/inputs";
    print "INFO: inputs reads will be removed if they are located in the workdir inputsdir\\n";
    my @listOfFiles = `readlink -e !{file1} !{file2}`;
    foreach my $targetFile (@listOfFiles){
        if (index($targetFile, $workdir) != -1 || index($targetFile, $inputsdir) != -1) {
            runCmd("rm -f $targetFile");
            print "INFO: $targetFile deleted.\\n";
        }
    }
}

##Subroutines
sub runCmd {
    my ($com) = @_;
    if ($com eq ""){
		return "";
    }
    my $error = system(@_);
    if   ($error) { die "Command failed: $error $com\\n"; }
    else          { print "Command successful: $com\\n"; }
}


'''

}


process Adapter_Trimmer_Quality_Module_Quality_Filtering_Summary {

input:
 path logfile
 val mate

output:
 path "quality_filter_summary.tsv"  ,emit:g71_16_outputFileTSV07_g_75 

shell:
'''
#!/usr/bin/env perl
use List::Util qw[min max];
use strict;
use File::Basename;
use Getopt::Long;
use Pod::Usage;
use Data::Dumper;

my @header;
my %all_files;
my %tsv;
my %headerHash;
my %headerText;

my $i = 0;
chomp( my $contents = `ls *.log` );
my @files = split( /[\\n]+/, $contents );
foreach my $file (@files) {
    $i++;
    my $mapper   = "";
    my $mapOrder = "1";
    if ($file =~ /(.*)\\.fastx_quality\\.log/){
        $mapper   = "fastx";
        $file =~ /(.*)\\.fastx_quality\\.log/;
        my $name = $1;    ##sample name
        push( @header, $mapper );
        my $in;
        my $out;
        chomp( $in =`cat $file | grep 'Input:' | awk '{sum+=\\$2} END {print sum}'` );
        chomp( $out =`cat $file | grep 'Output:' | awk '{sum+=\\$2} END {print sum}'` );
        $tsv{$name}{$mapper} = [ $in, $out ];
        $headerHash{$mapOrder} = $mapper;
        $headerText{$mapOrder} = [ "Total Reads", "Reads After Quality Filtering" ];
    } elsif ($file =~ /(.*)\\.trimmomatic_quality\\.log/){
        $mapper   = "trimmomatic";
        $file =~ /(.*)\\.trimmomatic_quality\\.log/;
        my $name = $1;    ##sample name
        push( @header, $mapper );
        my $in;
        my $out;
        if ( "!{mate}" eq "pair"){
            chomp( $in =`cat $file | grep 'Input Read Pairs:' | awk '{sum+=\\$4} END {print sum}'` );
            chomp( $out =`cat $file | grep 'Input Read Pairs:' | awk '{sum+=\\$7} END {print sum}'` );
        } else {
            chomp( $in =`cat $file | grep 'Input Reads:' | awk '{sum+=\\$3} END {print sum}'` );
            chomp( $out =`cat $file | grep 'Input Reads:' | awk '{sum+=\\$5} END {print sum}'` );
        }
        $tsv{$name}{$mapper} = [ $in, $out ];
        $headerHash{$mapOrder} = $mapper;
        $headerText{$mapOrder} = [ "Total Reads", "Reads After Quality Filtering" ];
    }
    
}

my @mapOrderArray = ( keys %headerHash );
my @sortedOrderArray = sort { $a <=> $b } @mapOrderArray;

my $summary          = "quality_filter_summary.tsv";
writeFile( $summary,          \\%headerText,       \\%tsv );

sub writeFile {
    my $summary    = $_[0];
    my %headerText = %{ $_[1] };
    my %tsv        = %{ $_[2] };
    open( OUT, ">$summary" );
    print OUT "Sample\\t";
    my @headArr = ();
    for my $mapOrder (@sortedOrderArray) {
        push( @headArr, @{ $headerText{$mapOrder} } );
    }
    my $headArrAll = join( "\\t", @headArr );
    print OUT "$headArrAll\\n";

    foreach my $name ( keys %tsv ) {
        my @rowArr = ();
        for my $mapOrder (@sortedOrderArray) {
            push( @rowArr, @{ $tsv{$name}{ $headerHash{$mapOrder} } } );
        }
        my $rowArrAll = join( "\\t", @rowArr );
        print OUT "$name\\t$rowArrAll\\n";
    }
    close(OUT);
}

'''
}


process Adapter_Trimmer_Quality_Module_Umitools_Summary {

input:
 path logfile
 val mate

output:
 path "umitools_summary.tsv"  ,emit:g71_24_outputFileTSV00 

shell:
'''
#!/usr/bin/env perl
use List::Util qw[min max];
use strict;
use File::Basename;
use Getopt::Long;
use Pod::Usage;
use Data::Dumper;

my @header;
my %all_files;
my %tsv;
my %tsvDetail;
my %headerHash;
my %headerText;
my %headerTextDetail;

my $i = 0;
chomp( my $contents = `ls *.log` );

my @files = split( /[\\n]+/, $contents );
foreach my $file (@files) {
    $i++;
    my $mapOrder = "1";
    if ($file =~ /(.*)\\.umitools\\.log/){
        $file =~ /(.*)\\.umitools\\.log/;
        my $mapper   = "umitools";
        my $name = $1;    ##sample name
        push( @header, $mapper );
        my $in;
        my $out;
        my $dedupout;
        chomp( $in =`cat $file | grep 'INFO Input Reads:' | awk '{sum=\\$6} END {print sum}'` );
        chomp( $out =`cat $file | grep 'INFO Reads output:' | awk '{sum=\\$6} END {print sum}'` );
        my $deduplog = $name.".dedup.log";
        $headerHash{$mapOrder} = $mapper;
        if (-e $deduplog) {
            print "dedup log found\\n";
            chomp( $dedupout =`cat $deduplog | grep '$name' | awk '{sum=\\$3} END {print sum}'` );
            $tsv{$name}{$mapper} = [ $in, $out, $dedupout];
            $headerText{$mapOrder} = [ "Total Reads", "Reads After Umiextract", "Reads After Deduplication" ]; 
        } else {
            $tsv{$name}{$mapper} = [ $in, $out ];
            $headerText{$mapOrder} = [ "Total Reads", "Reads After Umiextract" ]; 
        }
        
        
    }
}

my @mapOrderArray = ( keys %headerHash );
my @sortedOrderArray = sort { $a <=> $b } @mapOrderArray;

my $summary          = "umitools_summary.tsv";
writeFile( $summary,          \\%headerText,       \\%tsv );

sub writeFile {
    my $summary    = $_[0];
    my %headerText = %{ $_[1] };
    my %tsv        = %{ $_[2] };
    open( OUT, ">$summary" );
    print OUT "Sample\\t";
    my @headArr = ();
    for my $mapOrder (@sortedOrderArray) {
        push( @headArr, @{ $headerText{$mapOrder} } );
    }
    my $headArrAll = join( "\\t", @headArr );
    print OUT "$headArrAll\\n";

    foreach my $name ( keys %tsv ) {
        my @rowArr = ();
        for my $mapOrder (@sortedOrderArray) {
            push( @rowArr, @{ $tsv{$name}{ $headerHash{$mapOrder} } } );
        }
        my $rowArrAll = join( "\\t", @rowArr );
        print OUT "$name\\t$rowArrAll\\n";
    }
    close(OUT);
}

'''
}


//* autofill
if ($HOSTNAME == "default"){
    $CPU  = 1
    $MEMORY = 10
}
//* platform
//* platform
//* autofill

process Adapter_Trimmer_Quality_Module_FastQC {

publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /.*.(html|zip)$/) "fastqc/$filename"}
input:
 val mate
 tuple val(name), file(reads)

output:
 path '*.{html,zip}'  ,emit:g71_28_FastQCout04_g_70 

when:
(params.run_FastQC && (params.run_FastQC == "yes"))

script:
"""
fastqc ${reads} 
"""
}

//* autofill
if ($HOSTNAME == "default"){
    $CPU  = 1
    $MEMORY = 10
}
//* platform
//* platform
//* autofill

process Adapter_Trimmer_Quality_Module_FastQC_after_Adapter_Removal {

input:
 val mate
 tuple val(name), file(reads)

output:
 path '*.{html,zip}'  ,emit:g71_31_FastQCout015_g_70 

when:
(params.run_FastQC && params.run_FastQC == "yes" && params.run_Adapter_Removal && params.run_Adapter_Removal == "yes")

script:
"""
fastqc ${reads} 
"""
}

//* params.gtf =  ""  //* @input
//* params.genome =  ""  //* @input
//* params.commondb =  ""  //* @input
//* params.genome_source =  ""  //* @input
//* params.gtf_source =  ""  //* @input
//* params.commondb_source =  ""  //* @input @optional

def downFile(path, task){
	println workDir
    if (path.take(1).indexOf("/") == 0){
      target=path
      if (task.executor == "awsbatch" || task.executor == "google-batch") {
      	a=file(path)
    	fname = a.getName().toString()
    	target = "${workDir}/${fname}"
    	if (!file(target).exists()){
    		a.copyTo(workDir)
    	}
      }
    } else {
      a=file(path)
      fname = a.getName().toString()
      target = "${workDir}/${fname}"
      if (!file(target).exists()){
    		a.copyTo(workDir)
      } 
    }
    return target
}

def getLastName (str){
	if (str.indexOf("/") > -1){
		return  str.substring(str.lastIndexOf('/')+1,str.length())
	} 
	return ""
}

process Check_and_Build_Module_Check_Genome_GTF {


output:
 path "${newNameFasta}"  ,emit:g78_21_genome00_g78_58 
 path "${newNameGtf}"  ,emit:g78_21_gtfFile10_g78_57 

container 'quay.io/ummsbiocore/pipeline_base_image:1.0'

when:
params.run_Download_Genomic_Sources == "yes"

script:
genomeSource = !file("${params.genome}").exists() ? params.genome_source : params.genome
genomeName = getLastName(genomeSource)

gtfSource = !file("${params.gtf}").exists() ? params.gtf_source : params.gtf
gtfName = getLastName(gtfSource)


newNameGtf = gtfName
newNameFasta = genomeName
if (gtfName.contains('.gz')) { newNameGtf =  newNameGtf - '.gz'  } 
if (genomeName.contains('.gz')) { newNameFasta =  newNameFasta - '.gz'  } 

runGzip = ""
if (gtfName.contains('.gz') || genomeName.contains('.gz')) {
    runGzip = "ls *.gz | xargs -i echo gzip -df {} | sh"
} 

slashCountGenome = params.genome_source.count("/")
cutDirGenome = slashCountGenome - 3;

slashCountGtf = params.gtf_source.count("/")
cutDirGtf = slashCountGtf - 3;

"""
if [ ! -e "${params.genome_source}" ] ; then
    echo "${params.genome_source} not found"
	if [[ "${params.genome_source}" =~ "s3" ]]; then
		echo "Downloading s3 path from ${params.genome_source}"
		aws s3 cp ${params.genome_source} ${workDir}/${genomeName} && ln -s ${workDir}/${genomeName} ${genomeName}
	elif [[ "${params.genome_source}" =~ "gs" ]]; then
		echo "Downloading gs path from ${params.genome_source}"
		gsutil cp  ${params.genome_source} ${genomeName}
	else
		echo "Downloading genome with wget"
		wget --no-check-certificate --secure-protocol=TLSv1 -l inf -nc -nH --cut-dirs=$cutDirGenome -R 'index.html*' -r --no-parent  ${params.genome_source}
	fi

else 
	ln -s ${params.genome_source} ${genomeName}
fi

if [ ! -e "${params.gtf_source}" ] ; then
    echo "${params.gtf_source} not found"
	if [[ "${params.gtf_source}" =~ "s3" ]]; then
		echo "Downloading s3 path from ${params.gtf_source}"
		aws s3 cp  ${params.gtf_source} ${workDir}/${gtfName} && ln -s ${workDir}/${gtfName} ${gtfName}
	elif [[ "${params.gtf_source}" =~ "gs" ]]; then
		echo "Downloading gs path from ${params.gtf_source}"
		gsutil cp  ${params.gtf_source} ${gtfName}
	else
		echo "Downloading gtf with wget"
		wget --no-check-certificate --secure-protocol=TLSv1 -l inf -nc -nH --cut-dirs=$cutDirGtf -R 'index.html*' -r --no-parent  ${params.gtf_source}
	fi

else 
	ln -s ${params.gtf_source} ${gtfName}
fi

$runGzip

"""




}


process Check_and_Build_Module_convert_gtf_attributes {

input:
 path gtf

output:
 path "out/${gtf}"  ,emit:g78_57_gtfFile01_g78_58 

when:
params.replace_geneID_with_geneName == "yes"

shell:
'''
#!/usr/bin/env perl 

## Replace gene_id column with gene_name column in the gtf file
## Also check if any transcript_id defined in multiple chromosomes.
system("mkdir out");

open(OUT1, ">out/!{gtf}");
open(OUT2, ">notvalid_!{gtf}");
my %transcipt;
my $file = "!{gtf}";
open IN, $file;
while( my $line = <IN>)  {
    chomp;
    @a=split("\\t",$line);
    @attr=split(";",$a[8]);
    my %h;
    for my $elem (@attr) {
        ($first, $rest) = split ' ', $elem, 2;
        $h{$first} = $rest.";";
    }
    my $geneId = "";
    my $transcript_id = "";
    if (exists $h{"gene_name"}){
        $geneId = $h{"gene_name"};
    } elsif (exists $h{"gene_id"}){
        $geneId = $h{"gene_id"};
    }
    if (exists $h{"transcript_id"}){
        $transcript_id = $h{"transcript_id"};
    } elsif (exists $h{"transcript_name"}){
        $transcript_id = $h{"transcript_name"};
    } elsif (exists $h{"gene_id"}){
        $transcript_id = $h{"gene_id"};
    }
    if ($geneId ne "" && $transcript_id ne ""){
        ## check if any transcript_id defined in multiple chromosomes.
        if (exists $transcipt{$transcript_id}){
             if ($transcipt{$transcript_id} ne $a[0]){
               print OUT2 "$transcript_id: $transcipt{$transcript_id} vs $a[0]\\n";
                next;
                }
        } else {
             $transcipt{$transcript_id} = $a[0];
        }
        $a[8]=join(" ",("gene_id",$geneId,"transcript_id",$transcript_id));
        print OUT1 join("\\t",@a), "\\n";
    }  else {
        print OUT2 "$line";
    }
}
close OUT1;
close OUT2;
close IN;
'''
}


process Check_and_Build_Module_Add_custom_seq_to_genome_gtf {

input:
 path genome
 path gtf
 path custom_fasta

output:
 path "${genomeName}_custom.fa"  ,emit:g78_58_genome00_g78_52 
 path "${gtfName}_custom_sorted.gtf"  ,emit:g78_58_gtfFile10_g78_53 

when:
params.add_sequences_to_reference == "yes"

script:
genomeName = genome.baseName
gtfName = gtf.baseName
is_custom_genome_exists = custom_fasta.name.startsWith('NO_FILE') ? "False" : "True" 

"""
#!/usr/bin/env python 
import requests
import os
import pandas as pd
import re
import urllib
from Bio import SeqIO

def add_to_fasta(seq, sqid, out_name):
	new_line = '>' + sqid + '\\n' + seq + '\\n'
	with open(out_name + '.fa', 'a') as f:
		f.write(new_line)

def createCustomGtfFromFasta(fastaFile, outCustomGtfFile):

    fasta_sequences = SeqIO.parse(open(fastaFile),'fasta')
    with open(outCustomGtfFile, "w") as out_file:
        for fasta in fasta_sequences:
            name, sequence = fasta.id, str(fasta.seq)
            last = len(sequence)
            line1 = "{gene}\\tKNOWN\\tgene\\t{first}\\t{last}\\t.\\t+\\t.\\tgene_id \\"{gene}\\"; gene_version \\"1\\"; gene_type \\"protein_coding\\"; gene_source \\"KNOWN\\"; gene_name \\"{gene}\\"; gene_biotype \\"protein_coding\\"; gene_status \\"KNOWN\\"; level 1;".format(gene=name, first="1", last=last)
            line2 = "{gene}\\tKNOWN\\ttranscript\\t{first}\\t{last}\\t.\\t+\\t.\\tgene_id \\"{gene}\\"; gene_version \\"1\\"; transcript_id \\"{gene}_trans\\"; transcript_version \\"1\\"; gene_type \\"protein_coding\\"; gene_source \\"KNOWN\\"; transcript_source \\"KNOWN\\"; gene_status \\"KNOWN\\"; gene_name \\"{gene}\\"; gene_biotype \\"protein_coding\\"; transcript_type \\"protein_coding\\"; transcript_status \\"KNOWN\\"; transcript_name \\"{gene}_1\\"; level 1; tag \\"basic\\"; transcript_biotype \\"protein_coding\\"; transcript_support_level \\"1\\";".format(gene=name, first="1", last=last)
            line3 = "{gene}\\tKNOWN\\texon\\t{first}\\t{last}\\t.\\t+\\t.\\tgene_id \\"{gene}\\"; gene_version \\"1\\"; transcript_id \\"{gene}_trans\\"; transcript_version \\"1\\"; exon_number 1; gene_type \\"protein_coding\\"; gene_source \\"KNOWN\\"; transcript_source \\"KNOWN\\"; gene_status \\"KNOWN\\"; gene_name \\"{gene}\\"; gene_biotype \\"protein_coding\\"; transcript_type \\"protein_coding\\"; transcript_status \\"KNOWN\\"; transcript_biotype \\"protein_coding\\"; transcript_name \\"{gene}_1\\"; exon_number 1; exon_id \\"{gene}.1\\"; level 1; tag \\"basic\\"; transcript_support_level \\"1\\";".format(gene=name, first="1", last=last)
            out_file.write("{}\\n{}\\n{}\\n".format(line1, line2, line3))

	
os.system('cp ${genomeName}.fa ${genomeName}_custom.fa')  
os.system('cp ${gtfName}.gtf ${gtfName}_custom.gtf')  

if ${is_custom_genome_exists}:
	os.system("tr -d '\\r' < ${custom_fasta} > ${custom_fasta}_tmp && rm ${custom_fasta} && mv ${custom_fasta}_tmp ${custom_fasta}")
	os.system('cat ${custom_fasta} >> ${genomeName}_custom.fa')
	createCustomGtfFromFasta("${custom_fasta}", "${custom_fasta}.gtf")
	os.system('cat ${custom_fasta}.gtf >> ${gtfName}_custom.gtf')
	
os.system('samtools faidx ${genomeName}_custom.fa')
os.system('igvtools sort ${gtfName}_custom.gtf ${gtfName}_custom_sorted.gtf')
os.system('igvtools index ${gtfName}_custom_sorted.gtf')

"""
}

//* params.gtf2bed_path =  ""  //* @input
//* params.bed =  ""  //* @input

process Check_and_Build_Module_Check_BED12 {

input:
 path gtf

output:
 path "${gtfName}.bed"  ,emit:g78_53_bed03_g78_54 

container "${ params.IMAGE_BASE ? "${params.IMAGE_BASE}/rnaseq:4.0" : "quay.io/ummsbiocore/rnaseq:4.0" }"

when:
params.run_Download_Genomic_Sources == "yes"

script:
gtfName  = gtf.baseName
beddir = ""
if (params.bed.indexOf('/') > -1){
	beddir  = params.bed.substring(0, params.bed.lastIndexOf('/')) 
}
"""

if [ ! -e "${params.bed}" ] ; then
    echo "${params.bed} not found"
    perl ${params.gtf2bed_path} $gtf > ${gtfName}.bed
else 
	cp -n ${params.bed} ${gtfName}.bed
fi
if [ "${beddir}" != "" ] ; then
	mkdir -p ${beddir}
	cp -n ${gtfName}.bed ${params.bed} 
fi
"""




}

//* params.gtf2bed_path =  ""  //* @input
//* params.genome_sizes =  ""  //* @input

process Check_and_Build_Module_Check_chrom_sizes_and_index {

input:
 path genome

output:
 path "${genomeName}.chrom.sizes"  ,emit:g78_52_genomeSizes02_g78_54 

when:
params.run_Download_Genomic_Sources == "yes"

script:
genomeName  = genome.baseName
genome_sizes_dir = ""
if (params.genome_sizes.indexOf('/') > -1){
	genome_sizes_dir  = params.genome_sizes.substring(0, params.genome_sizes.lastIndexOf('/')) 
}

"""
if [ ! -e "${params.genome_sizes}" ] ; then
    echo "${params.genome_sizes} not found"
    cat ${genome} | awk '\$0 ~ ">" {print c; c=0;printf substr(\$1,2,100) "\\t"; } \$0 !~ ">" {c+=length(\$0);} END { print c; }' > ${genomeName}.chrom.sizes
    ##clean first empty line
    sed -i '1{/^\$/d}' ${genomeName}.chrom.sizes
    if [ "${genome_sizes_dir}" != "" ] ; then
    	mkdir -p ${genome_sizes_dir}
		cp -n ${genomeName}.chrom.sizes ${params.genome_sizes} 
	fi
else 
	cp ${params.genome_sizes} ${genomeName}.chrom.sizes
fi

"""




}


process Check_and_Build_Module_check_files {

input:
 path gtf
 path genome
 path genomeSizes
 path bed

output:
 path "*/${gtf2}" ,optional:true  ,emit:g78_54_gtfFile01_g72_47 
 path "*/${genome2}" ,optional:true  ,emit:g78_54_genome10_g72_47 
 path "*/${genomeSizes2}" ,optional:true  ,emit:g78_54_genomeSizes22_g74_131 
 path "*/${bed2}" ,optional:true  ,emit:g78_54_bed31_g74_134 

container 'quay.io/ummsbiocore/pipeline_base_image:1.0'
stageInMode 'copy'

script:
(cmd1, gtf2) = pathChecker(gtf, params.gtf, "file")
(cmd2, genome2) = pathChecker(genome, params.genome, "file")
(cmd3, genomeSizes2) = pathChecker(genomeSizes, params.genome_sizes, "file")
(cmd4, bed2) = pathChecker(bed, params.bed, "file")
"""
$cmd1
$cmd2
$cmd3
$cmd4
"""
}

build_Bowtie2_index = params.Bowtie2_Module_Check_Build_Bowtie2_Index.build_Bowtie2_index
bowtie2_build_parameters = params.Bowtie2_Module_Check_Build_Bowtie2_Index.bowtie2_build_parameters
//* params.bowtie2_index =  ""  //* @input

process Bowtie2_Module_Check_Build_Bowtie2_Index {

input:
 path genome

output:
 path "$index"  ,emit:g73_17_bowtie2index00_g73_14 

when:
build_Bowtie2_index == true && ((params.run_Bowtie2 && (params.run_Bowtie2 == "yes")) || !params.run_Bowtie2)

script:
bowtie2_build_parameters = params.Bowtie2_Module_Check_Build_Bowtie2_Index.bowtie2_build_parameters
basename = genome.baseName
index_dir = ""
if (params.bowtie2_index.indexOf('/') > -1 && params.bowtie2_index.indexOf('s3://') < 0){
	index_dir  = file(params.bowtie2_index).getParent()
}
index = "Bowtie2Index" 


"""
if [ ! -e "${index_dir}/${basename}.rev.1.bt2" ] ; then
    echo "INFO: ${index_dir}/${basename}.rev.1.bt2 Bowtie2 index not found. Building it..."
    
    mkdir -p $index && mv $genome $index/. && cd $index
    bowtie2-build ${bowtie2_build_parameters} ${genome} ${basename}
    cd ..
    if [ "${index_dir}" != "" ] ; then
		mkdir -p ${index_dir}
		cp -R -n $index  ${index_dir}
	fi
else 
	ln -s ${index_dir} $index
fi
"""

}


process Bowtie2_Module_check_Bowtie2_files {

input:
 path bowtie2index

output:
 path "*/${bowtie2new}" ,optional:true  ,emit:g73_14_bowtie2index02_g73_3 

container 'quay.io/ummsbiocore/pipeline_base_image:1.0'
stageInMode 'copy'

when:
(params.run_Bowtie2 && (params.run_Bowtie2 == "yes")) || !params.run_Bowtie2

script:
(cmd, bowtie2new) = pathChecker(bowtie2index, params.bowtie2_index, "folder")
"""
$cmd
"""
}

download_build_sequential_mapping_indexes = params.Sequential_Mapping_Module_Download_build_sequential_mapping_indexes.download_build_sequential_mapping_indexes

//* autofill
if ($HOSTNAME == "default"){
    $CPU  = 1
    $MEMORY = 50
}
//* platform
//* platform
//* autofill

process Sequential_Mapping_Module_Download_build_sequential_mapping_indexes {

input:
 path genome
 path gtf

output:
 path "${commondbName}"  ,emit:g72_47_commondb00_g72_43 
 path "${bowtieIndex}" ,optional:true  ,emit:g72_47_bowtieIndex11_g72_43 
 path "${bowtie2Index}" ,optional:true  ,emit:g72_47_bowtie2index22_g72_43 
 path "${starIndex}" ,optional:true  ,emit:g72_47_starIndex33_g72_43 

when:
download_build_sequential_mapping_indexes == true && params.run_Sequential_Mapping == "yes"

script:
slashCount = params.commondb_source.count("/")
cutDir = slashCount - 3;
commondbSource = !file("${params.commondb}").exists() ? params.commondb_source : params.commondb
commondbName = "commondb"
inputName = file("${params.commondb}").getName().toString()

selectedSeqList = params.Sequential_Mapping_Module_Sequential_Mapping._select_sequence
alignerList = params.Sequential_Mapping_Module_Sequential_Mapping._aligner
genomeIndexes = selectedSeqList.findIndexValues { it ==~ /genome/ }
buildBowtieIndex = alignerList[genomeIndexes].contains("bowtie")
buildBowtie2Index = alignerList[genomeIndexes].contains("bowtie2")
buildSTARIndex = alignerList[genomeIndexes].contains("STAR")

basename = genome.baseName
bowtie2Index = "Bowtie2Index" 
bowtieIndex = "BowtieIndex" 
starIndex = "STARIndex"
bowtie_index_dir = ""
bowtie2_index_dir = ""
star_index_dir = ""
if (params.bowtie_index.indexOf('/') > -1 && params.bowtie_index.indexOf('s3://') < 0){
	bowtie_index_dir  = params.bowtie_index.substring(0, params.bowtie_index.lastIndexOf('/')) 
}
if (params.bowtie2_index.indexOf('/') > -1 && params.bowtie2_index.indexOf('s3://') < 0){
	bowtie2_index_dir  = params.bowtie2_index.substring(0, params.bowtie2_index.lastIndexOf('/')) 
}
if (params.star_index.indexOf('/') > -1 && params.star_index.indexOf('s3://') < 0){
	star_index_dir  = params.star_index.substring(0, params.star_index.lastIndexOf('/')) 
}

"""
if [ ! -e "${params.commondb}" ] ; then
    echo "${params.commondb} not found"
	if [[ "${params.commondb_source}" =~ "s3" ]]; then
		echo "Downloading s3 path from ${params.commondb_source}"
		aws s3 cp --recursive ${params.commondb_source} ${workDir}/${commondbName} && ln -s ${workDir}/${commondbName} ${commondbName}
	elif [[ "${params.commondb_source}" =~ "gs" ]]; then
		echo "Downloading gs path from ${params.commondb_source}"
		gsutil cp -r ${params.commondb_source} ${workDir}/. && ln -s ${workDir}/${commondbName} ${commondbName}
	else
		echo "Downloading commondb with wget"
		wget --no-check-certificate --secure-protocol=TLSv1 -l inf -nc -nH --cut-dirs=$cutDir -R 'index.html*' -r --no-parent --directory-prefix=\$PWD/${commondbName} ${params.commondb_source}
	fi

else 
	ln -s ${params.commondb} ${commondbName}
fi


if [ "${buildBowtie2Index}" == "true" ]; then
	if [ ! -e "${bowtie2_index_dir}/${basename}.rev.1.bt2" ] ; then
    	echo "${bowtie2_index_dir}/${basename}.rev.1.bt2 Bowtie2 index not found"
    	mkdir -p $bowtie2Index && cp $genome $gtf $bowtie2Index/. && cd $bowtie2Index
    	bowtie2-build ${genome} ${basename}
    	cd ..
    	if [ "${bowtie2_index_dir}" != "" ] ; then
			mkdir -p ${bowtie2_index_dir}
			cp -R -n $bowtie2Index  ${bowtie2_index_dir}
		fi
	else 
		ln -s ${bowtie2_index_dir} $bowtie2Index
	fi
fi

if [ "${buildBowtieIndex}" == "true" ]; then
	if [ ! -e "${bowtie_index_dir}/${basename}.rev.2.ebwt" ] ; then
    	echo "${bowtie_index_dir}/${basename}.rev.2.ebwt Bowtie index not found"
    	mkdir -p $bowtieIndex && cp $genome $gtf $bowtieIndex/. && cd $bowtieIndex
    	bowtie-build ${genome} ${basename}
    	cd ..
    	if [ "${bowtie_index_dir}" != "" ] ; then
			mkdir -p ${bowtie_index_dir}
			cp -R -n $bowtieIndex  ${bowtie_index_dir}
		fi
	else 
		ln -s ${bowtie_index_dir} $bowtieIndex
	fi
fi 

if [ "${buildSTARIndex}" == "true" ]; then
	if [ ! -e "${params.star_index}/SA" ] ; then
    	echo "STAR index not found"
    	mkdir -p $starIndex 
    	STAR --runMode genomeGenerate --genomeDir $starIndex --genomeFastaFiles ${genome} --sjdbGTFfile ${gtf}
		if [ "${star_index_dir}" != "" ] ; then
			mkdir -p ${star_index_dir}
			cp -R $starIndex  ${params.star_index}
		fi
	else 
		ln -s ${params.star_index} $starIndex
	fi
fi
"""




}

//* params.gtf =  ""  //* @input
//* params.genome =  ""  //* @input
//* params.commondb =  ""  //* @input

process Sequential_Mapping_Module_Check_Sequential_Mapping_Indexes {

input:
 path commondb
 path bowtieIndex
 path bowtie2Index
 path starIndex

output:
 path "*/${commondb2}" ,optional:true  ,emit:g72_43_commondb05_g72_44 
 path "*/${bowtieIndex2}" ,optional:true  ,emit:g72_43_bowtieIndex12_g72_44 
 path "*/${bowtie2Index2}" ,optional:true  ,emit:g72_43_bowtie2index23_g72_44 
 path "*/${starIndex2}" ,optional:true  ,emit:g72_43_starIndex34_g72_44 

container 'quay.io/ummsbiocore/pipeline_base_image:1.0'
stageInMode 'copy'

when:
params.run_Sequential_Mapping  == "yes"

script:
(cmd1, commondb2) = pathChecker(commondb, params.commondb, "folder")
(cmd2, bowtieIndex2) = pathChecker(bowtieIndex, params.bowtie_index, "folder")
(cmd3, bowtie2Index2) = pathChecker(bowtie2Index, params.bowtie2_index, "folder")
(cmd4, starIndex2) = pathChecker(starIndex, params.star_index, "folder")
"""
$cmd1
$cmd2
$cmd3
$cmd4
"""
}

//* params.bowtie_index =  ""  //* @input
//* params.bowtie2_index =  ""  //* @input
//* params.star_index =  ""  //* @input

//both bowtie and bowtie2 indexes located in same path
bowtieIndexes = [rRNA:  "commondb/rRNA/rRNA", ercc:  "commondb/ercc/ercc", miRNA: "commondb/miRNA/miRNA", tRNA:  "commondb/tRNA/tRNA", piRNA: "commondb/piRNA/piRNA", snRNA: "commondb/snRNA/snRNA", rmsk:  "commondb/rmsk/rmsk"]
genomeIndexes = [bowtie: "BowtieIndex", bowtie2: "Bowtie2Index", STAR: "STARIndex"]


//_nucleicAcidType="dna" should be defined in the autofill section of pipeline header in case dna is used.
_select_sequence = params.Sequential_Mapping_Module_Sequential_Mapping._select_sequence
index_directory = params.Sequential_Mapping_Module_Sequential_Mapping.index_directory
name_of_the_index_file = params.Sequential_Mapping_Module_Sequential_Mapping.name_of_the_index_file
_aligner = params.Sequential_Mapping_Module_Sequential_Mapping._aligner
aligner_Parameters = params.Sequential_Mapping_Module_Sequential_Mapping.aligner_Parameters
description = params.Sequential_Mapping_Module_Sequential_Mapping.description
filter_Out = params.Sequential_Mapping_Module_Sequential_Mapping.filter_Out
sense_antisense = params.Sequential_Mapping_Module_Sequential_Mapping.sense_antisense

desc_all=[]
description.eachWithIndex() {param,i -> 
    if (param.isEmpty()){
        desc_all[i] = name_of_the_index_file[i]
    }  else {
        desc_all[i] = param.replaceAll("[ |.|;]", "_")
    }
}
custom_index=[]
index_directory.eachWithIndex() {param,i -> 
    if (_select_sequence[i] == "genome"){
        custom_index[i] = genomeIndexes[_aligner[i]]
    }else if (_select_sequence[i] == "custom"){
        custom_index[i] = param+"/"+name_of_the_index_file[i]
    }else {
        custom_index[i] = bowtieIndexes[_select_sequence[i]]
    }
}

selectSequenceList = []
mapList = []
paramList = []
alignerList = []
filterList = []
indexList = []
senseList = []

//concat default mapping and custom mapping
mapList = (desc_all) 
paramList = (aligner_Parameters)
alignerList = (_aligner)
filterList = (filter_Out)
indexList = (custom_index)
senseList = (sense_antisense)
selectSequenceList = (_select_sequence)

mappingList = mapList.join(" ") // convert into space separated format in order to use in bash for loop
paramsList = paramList.join(",") // convert into comma separated format in order to use in as array in bash
alignersList = alignerList.join(",") 
filtersList = filterList.join(",") 
indexesList = indexList.join(",") 
senseList = senseList.join(",")
selectSequencesList = selectSequenceList.join(",")

//* @style @condition:{remove_duplicates="yes",remove_duplicates_based_on_UMI_after_mapping},{remove_duplicates="no"},{_select_sequence="custom", index_directory,name_of_the_index_file,description,_aligner,aligner_Parameters,filter_Out,sense_antisense},{_select_sequence=("rRNA","ercc","miRNA","tRNA","piRNA","snRNA","rmsk","genome"),_aligner,aligner_Parameters,filter_Out,sense_antisense}  @array:{_select_sequence,_select_sequence, index_directory,name_of_the_index_file,_aligner,aligner_Parameters,filter_Out,sense_antisense,description} @multicolumn:{_select_sequence,_select_sequence,index_directory,name_of_the_index_file,_aligner,aligner_Parameters,filter_Out, sense_antisense, description},{remove_duplicates,remove_duplicates_based_on_UMI_after_mapping}


//* autofill
if ($HOSTNAME == "default"){
    $CPU  = 4
    $MEMORY = 20
}
//* platform
//* platform
//* autofill

process Sequential_Mapping_Module_Sequential_Mapping {

publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /.*\/.*_sorted.bam$/) "sequential_mapping/$filename"}
publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /.*\/.*_sorted.bam.bai$/) "sequential_mapping/$filename"}
publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /.*\/.*_duplicates_stats.log$/) "sequential_mapping/$filename"}
input:
 tuple val(name), file(reads)
 val mate
 path commondb
 path bowtie_index
 path bowtie2_index
 path star_index

output:
 tuple val(name), file("final_reads/*.gz")  ,emit:g72_46_reads00_g73_3 
 tuple val(name), file("bowfiles/?*") ,optional:true  ,emit:g72_46_bowfiles10_g72_26 
 path "*/*_sorted.bam" ,optional:true  ,emit:g72_46_bam_file20_g72_44 
 path "*/*_sorted.bam.bai" ,optional:true  ,emit:g72_46_bam_index31_g72_44 
 val filtersList  ,emit:g72_46_filter42_g72_26 
 path "*/*_sorted.dedup.bam" ,optional:true  ,emit:g72_46_bam_file50_g72_45 
 path "*/*_sorted.dedup.bam.bai" ,optional:true  ,emit:g72_46_bam_index61_g72_45 
 path "*/*_duplicates_stats.log" ,optional:true  ,emit:g72_46_log_file70_g72_30 
 path "*/*.bw" ,optional:true  ,emit:g72_46_bigWig_file88 

when:
params.run_Sequential_Mapping == "yes"

script:
nameAll = reads.toString()
nameArray = nameAll.split(' ')
file2 = ""
file1 =  nameArray[0] 
if (mate == "pair") {file2 =  nameArray[1]}


remove_duplicates = params.Sequential_Mapping_Module_Sequential_Mapping.remove_duplicates
remove_duplicates_based_on_UMI_after_mapping = params.Sequential_Mapping_Module_Sequential_Mapping.remove_duplicates_based_on_UMI_after_mapping
create_bigWig = params.Sequential_Mapping_Module_Sequential_Mapping.create_bigWig
remove_previous_reads = params.Sequential_Mapping_Module_Sequential_Mapping.remove_previous_reads

"""
#!/bin/bash
mkdir reads final_reads bowfiles
workflowWorkDir=\$(cd ../../ && pwd)
if [ -n "${mappingList}" ]; then
    #rename files to standart format
    if [ "${mate}" == "pair" ]; then
        mv $file1 ${name}.1.fastq.gz 2>/dev/null
        mv $file2 ${name}.2.fastq.gz 2>/dev/null
        mv ${name}.1.fastq.gz ${name}.2.fastq.gz reads/.
    else
        mv $file1 ${name}.fastq.gz 2>/dev/null
        mv ${name}.fastq.gz reads/.
    fi
    #sequential mapping
    k=0
    prev="reads"
    IFS=',' read -r -a selectSeqListAr <<< "${selectSequencesList}"
    IFS=',' read -r -a paramsListAr <<< "${paramsList}" #create comma separated array 
    IFS=',' read -r -a filtersListAr <<< "${filtersList}"
    IFS=',' read -r -a indexesListAr <<< "${indexesList}"
    IFS=',' read -r -a alignersListAr <<< "${alignersList}"
    IFS=',' read -r -a senseListAr <<< "${senseList}"
    wrkDir=\$(pwd)
    startDir=\$(pwd)
    for rna_set in ${mappingList}
    do
        ((k++))
        printf -v k2 "%02d" "\$k" #turn into two digit format
        mkdir -p \${rna_set}/unmapped
        cd \$rna_set
        ## create link of the target file to prevent "too many symlinks error"
        for r in \${startDir}/\${prev}/*; do
            targetRead=\$(readlink -e \$r)
            rname=\$(basename \$r)
            echo "INFO: ln -s \$targetRead \$rname"
            ln -s \$targetRead \$rname
        done
        basename=""
        genomeDir="\${startDir}/\${indexesListAr[\$k-1]}"
        
        if [[ \${indexesListAr[\$k-1]} == s3* ]]; then
        	s3dir=\$(echo \${indexesListAr[\$k-1]} | sed 's|\\(.*\\)/.*|\\1|' | sed 's![^/]\$!&/!')
        	s3file=\$(echo \${indexesListAr[\$k-1]} | sed 's|.*\\/||')
        	# Remove fa/fasta suffix if it exists
        	s3file="\${s3file%.fa}"
        	s3file="\${s3file%.fasta}"
        	echo "INFO: s3dir: \$s3dir" 
        	echo "INFO: s3file: \$s3file" 
        	echo "INFO: rna_set: \$rna_set" 
        	aws s3 cp --recursive \${s3dir} \${startDir}/custom_seqs/\${rna_set}
        	genomeDir="\${startDir}/custom_seqs/\${rna_set}"
        	indexesListAr[\$k-1]="\${startDir}/custom_seqs/\${rna_set}/\${s3file}"
        fi
        
        if [ "\${selectSeqListAr[\$k-1]}" == "genome" ]; then
        	wrkDir="\${startDir}"
        	if [ "\${alignersListAr[\$k-1]}" == "bowtie" ]; then
        		basename="/\$(basename \${startDir}/\${indexesListAr[\$k-1]}/*.rev.1.ebwt | cut -d. -f1)"
        	elif [ "\${alignersListAr[\$k-1]}" == "bowtie2" ]; then
        		basename="/\$(basename \${startDir}/\${indexesListAr[\$k-1]}/*.rev.1.bt2 | cut -d. -f1)"
        	elif [ "\${alignersListAr[\$k-1]}" == "STAR" ]; then
        		basename="/\$(basename \${startDir}/\${indexesListAr[\$k-1]}/*.gtf | cut -d. -f1)"
        	fi
        elif [ "\${selectSeqListAr[\$k-1]}" == "custom" ] ; then
        	wrkDir=""
        fi
        echo "INFO: basename: \$basename"
        echo "INFO: genomeDir: \$genomeDir"
        echo "INFO: check bowtie index: \${wrkDir}/\${indexesListAr[\$k-1]}\${basename}.rev.1.ebwt"
        echo "INFO: check bowtie2 index: \${wrkDir}/\${indexesListAr[\$k-1]}\${basename}.1.bt2"
        echo "INFO: check star index: \${genomeDir}/SAindex"
        if [ -e "\${wrkDir}/\${indexesListAr[\$k-1]}\${basename}.rev.1.ebwt" -o -e "\${wrkDir}/\${indexesListAr[\$k-1]}\${basename}.1.bt2" -o  -e "\${wrkDir}/\${indexesListAr[\$k-1]}\${basename}.fa"  -o  -e "\${wrkDir}/\${indexesListAr[\$k-1]}\${basename}.fasta"  -o  -e "\${genomeDir}/SAindex" ]; then
            if [ -e "\${wrkDir}/\${indexesListAr[\$k-1]}\${basename}.fa" ] ; then
                fasta=\${wrkDir}/\${indexesListAr[\$k-1]}\${basename}.fa
            elif [ -e "\${wrkDir}/\${indexesListAr[\$k-1]}\${basename}.fasta" ] ; then
                fasta=\${wrkDir}/\${indexesListAr[\$k-1]}\${basename}.fasta
            fi
            echo "INFO: fasta: \$fasta"
            if [ -e "\${wrkDir}/\${indexesListAr[\$k-1]}\${basename}.1.bt2" -a "\${alignersListAr[\$k-1]}" == "bowtie2" ] ; then
                echo "INFO: \${wrkDir}/\${indexesListAr[\$k-1]}\${basename}.1.bt2 Bowtie2 index found."
            elif [ -e "\${wrkDir}/\${indexesListAr[\$k-1]}\${basename}.1.ebwt" -a "\${alignersListAr[\$k-1]}" == "bowtie" ] ; then
                echo "INFO: \${wrkDir}/\${indexesListAr[\$k-1]}\${basename}.1.ebwt Bowtie index found."
            elif [ -e "\$genomeDir/SAindex" -a "\${alignersListAr[\$k-1]}" == "STAR" ] ; then
                echo "INFO: \$genomeDir/SAindex STAR index found."
            elif [ -e "\${wrkDir}/\${indexesListAr[\$k-1]}\${basename}.fa" -o  -e "\${wrkDir}/\${indexesListAr[\$k-1]}\${basename}.fasta" ] ; then
                if [ "\${alignersListAr[\$k-1]}" == "bowtie2" ]; then
                    bowtie2-build \$fasta \${wrkDir}/\${indexesListAr[\$k-1]}\${basename}
                elif [ "\${alignersListAr[\$k-1]}" == "STAR" ]; then
                    if [ -e "\${wrkDir}/\${indexesListAr[\$k-1]}\${basename}.gtf" ]; then
                        STAR --runMode genomeGenerate --genomeDir \$genomeDir --genomeFastaFiles \$fasta --sjdbGTFfile \${wrkDir}/\${indexesListAr[\$k-1]}\${basename}.gtf --genomeSAindexNbases 5
                    else
                        echo "WARNING: \${wrkDir}/\${indexesListAr[\$k-1]}\${basename}.gtf not found. STAR index is not generated."
                    fi
                elif [ "\${alignersListAr[\$k-1]}" == "bowtie" ]; then
                    bowtie-build \$fasta \${wrkDir}/\${indexesListAr[\$k-1]}\${basename}
                fi
            fi
                
            if [ "${mate}" == "pair" ]; then
                if [ "\${alignersListAr[\$k-1]}" == "bowtie2" ]; then
                    bowtie2 \${paramsListAr[\$k-1]} -x \${wrkDir}/\${indexesListAr[\$k-1]}\${basename} --no-unal --un-conc-gz unmapped/${name}.unmapped.fastq.gz -1 ${name}.1.fastq.gz -2 ${name}.2.fastq.gz --al-conc-gz ${name}.fq.mapped.gz -S \${rna_set}_${name}_alignment.sam 2>&1 | tee \${k2}_${name}.bow_\${rna_set}
                    mv unmapped/${name}.unmapped.fastq.1.gz unmapped/${name}.unmapped.1.fastq.gz
                    mv unmapped/${name}.unmapped.fastq.2.gz unmapped/${name}.unmapped.2.fastq.gz
                elif [ "\${alignersListAr[\$k-1]}" == "STAR" ]; then
                    STAR \${paramsListAr[\$k-1]}  --genomeDir \$genomeDir --readFilesCommand zcat --readFilesIn ${name}.1.fastq.gz ${name}.2.fastq.gz --outSAMtype SAM  --outFileNamePrefix ${name}.star --outReadsUnmapped Fastx
                    mv ${name}.starAligned.out.sam \${rna_set}_${name}_alignment.sam
                    mv ${name}.starUnmapped.out.mate1 unmapped/${name}.unmapped.1.fastq
                    mv ${name}.starUnmapped.out.mate2 unmapped/${name}.unmapped.2.fastq
                    mv ${name}.starLog.final.out \${k2}_${name}.star_\${rna_set}
                    gzip unmapped/${name}.unmapped.1.fastq unmapped/${name}.unmapped.2.fastq
                elif [ "\${alignersListAr[\$k-1]}" == "bowtie" ]; then
                	gunzip -c ${name}.1.fastq.gz > ${name}.1.fastq
                	gunzip -c ${name}.2.fastq.gz > ${name}.2.fastq
                    bowtie \${paramsListAr[\$k-1]}   \${wrkDir}/\${indexesListAr[\$k-1]}\${basename}  --un  unmapped/${name}.unmapped.fastq -1 ${name}.1.fastq -2 ${name}.2.fastq -S  \${rna_set}_${name}_alignment.sam 2>&1 | tee \${k2}_${name}.bow1_\${rna_set}  
                    rm ${name}.1.fastq ${name}.2.fastq
                    mv unmapped/${name}.unmapped_1.fastq unmapped/${name}.unmapped.1.fastq
                    mv unmapped/${name}.unmapped_2.fastq unmapped/${name}.unmapped.2.fastq
                    gzip unmapped/${name}.unmapped.1.fastq unmapped/${name}.unmapped.2.fastq
                fi
            else
                if [ "\${alignersListAr[\$k-1]}" == "bowtie2" ]; then
                    bowtie2 \${paramsListAr[\$k-1]} -x \${wrkDir}/\${indexesListAr[\$k-1]}\${basename} --no-unal --un-gz unmapped/${name}.unmapped.fastq -U ${name}.fastq.gz --al-gz ${name}.fq.mapped.gz -S \${rna_set}_${name}_alignment.sam 2>&1 | tee \${k2}_${name}.bow_\${rna_set}  
                elif [ "\${alignersListAr[\$k-1]}" == "STAR" ]; then
                    STAR \${paramsListAr[\$k-1]}  --genomeDir \$genomeDir --readFilesCommand zcat --readFilesIn ${name}.fastq.gz --outSAMtype SAM  --outFileNamePrefix ${name}.star --outReadsUnmapped Fastx
                    mv ${name}.starAligned.out.sam \${rna_set}_${name}_alignment.sam
                    mv ${name}.starUnmapped.out.mate1 unmapped/${name}.unmapped.fastq
                    mv ${name}.starLog.final.out \${k2}_${name}.star_\${rna_set}
                    gzip unmapped/${name}.unmapped.fastq
                elif [ "\${alignersListAr[\$k-1]}" == "bowtie" ]; then
                	gunzip -c ${name}.fastq.gz > ${name}.fastq
                    bowtie \${paramsListAr[\$k-1]}  \${wrkDir}/\${indexesListAr[\$k-1]}\${basename}  --un  unmapped/${name}.unmapped.fastq  ${name}.fastq  -S \${rna_set}_${name}_alignment.sam 2>&1 | tee \${k2}_${name}.bow1_\${rna_set}  
                    gzip unmapped/${name}.unmapped.fastq
                    rm  ${name}.fastq
                fi
            fi
            echo "INFO: samtools view -bT \${fasta} \${rna_set}_${name}_alignment.sam > \${rna_set}_${name}_alignment.bam"
            samtools view -bT \${fasta} \${rna_set}_${name}_alignment.sam > \${rna_set}_${name}_alignment.bam
            rm -f \${rna_set}_${name}_alignment.sam
            if [ "\${alignersListAr[\$k-1]}" == "bowtie" ]; then
                mv \${rna_set}_${name}_alignment.bam \${rna_set}_${name}_tmp0.bam
                echo "INFO: samtools view -F 0x04 -b \${rna_set}_${name}_tmp0.bam > \${rna_set}_${name}_alignment.bam"
                samtools view -F 0x04 -b \${rna_set}_${name}_tmp0.bam > \${rna_set}_${name}_alignment.bam  # Remove unmapped reads
                if [ "${mate}" == "pair" ]; then
                    echo "# unique mapped reads: \$(samtools view -f 0x40 -F 0x4 -q 255 \${rna_set}_${name}_alignment.bam | cut -f 1 | sort -T '.' | uniq | wc -l)" >> \${k2}_${name}.bow1_\${rna_set}
                else
                    echo "# unique mapped reads: \$(samtools view -F 0x40 -q 255 \${rna_set}_${name}_alignment.bam | cut -f 1 | sort -T '.' | uniq | wc -l)" >> \${k2}_${name}.bow1_\${rna_set}
                fi
            fi
            if [ "${mate}" == "pair" ]; then
                mv \${rna_set}_${name}_alignment.bam \${rna_set}_${name}_alignment.tmp1.bam
                echo "INFO: samtools sort -n -o \${rna_set}_${name}_alignment.tmp2 \${rna_set}_${name}_alignment.tmp1.bam"
                samtools sort -n -o \${rna_set}_${name}_alignment.tmp2.bam \${rna_set}_${name}_alignment.tmp1.bam 
                echo "INFO: samtools view -bf 0x02 \${rna_set}_${name}_alignment.tmp2.bam >\${rna_set}_${name}_alignment.bam"
                samtools view -bf 0x02 \${rna_set}_${name}_alignment.tmp2.bam >\${rna_set}_${name}_alignment.bam
                rm \${rna_set}_${name}_alignment.tmp1.bam \${rna_set}_${name}_alignment.tmp2.bam
            fi
            echo "INFO: samtools sort -o \${rna_set}@${name}_sorted.bam \${rna_set}_${name}_alignment.bam"
            samtools sort -o \${rna_set}@${name}_sorted.bam \${rna_set}_${name}_alignment.bam 
            echo "INFO: samtools index \${rna_set}@${name}_sorted.bam"
            samtools index \${rna_set}@${name}_sorted.bam
            
            if [ "${create_bigWig}" == "yes" ]; then
				echo "INFO: creating genome.sizes file"
				cat \$fasta | awk '\$0 ~ ">" {print c; c=0;printf substr(\$0,2,100) "\\t"; } \$0 !~ ">" {c+=length(\$0);} END { print c; }' > \${rna_set}.chrom.sizes && sed -i '1{/^\$/d}' \${rna_set}.chrom.sizes
				echo "INFO: creating bigWig file"
				bedtools genomecov -split -bg -ibam \${rna_set}@${name}_sorted.bam -g \${rna_set}.chrom.sizes > \${rna_set}@${name}.bg && wigToBigWig -clip -itemsPerSlot=1 \${rna_set}@${name}.bg \${rna_set}.chrom.sizes \${rna_set}@${name}.bw 
			fi
			
             # split sense and antisense bam files. 
            if [ "\${senseListAr[\$k-1]}" == "Yes" ]; then
                if [ "${mate}" == "pair" ]; then
                    echo "INFO: paired end sense antisense separation"
                	samtools view -f 65 -b \${rna_set}@${name}_sorted.bam >\${rna_set}@${name}_forward_sorted.bam
	                samtools index \${rna_set}@${name}_forward_sorted.bam
	                samtools view -F 16 -b \${rna_set}@${name}_forward_sorted.bam >\${rna_set}@${name}_sense_sorted.bam
	                samtools index \${rna_set}@${name}_sense_sorted.bam
	                samtools view -f 16 -b \${rna_set}@${name}_forward_sorted.bam >\${rna_set}@${name}_antisense_sorted.bam
	                samtools index \${rna_set}@${name}_antisense_sorted.bam
                else
	                echo "INFO: single end sense antisense separation"
	                samtools view -F 16 -b \${rna_set}@${name}_sorted.bam >\${rna_set}@${name}_sense_sorted.bam
	                samtools index \${rna_set}@${name}_sense_sorted.bam
	                samtools view -f 16 -b \${rna_set}@${name}_sorted.bam >\${rna_set}@${name}_antisense_sorted.bam
	                samtools index \${rna_set}@${name}_antisense_sorted.bam
                fi
                if [ "${create_bigWig}" == "yes" ]; then
					echo "INFO: creating bigWig file for sense antisense bam"
					bedtools genomecov -split -bg -ibam \${rna_set}@${name}_sense_sorted.bam -g \${rna_set}.chrom.sizes > \${rna_set}@${name}_sense.bg && wigToBigWig -clip -itemsPerSlot=1 \${rna_set}@${name}_sense.bg \${rna_set}.chrom.sizes \${rna_set}@${name}_sense.bw 
					bedtools genomecov -split -bg -ibam \${rna_set}@${name}_antisense_sorted.bam -g \${rna_set}.chrom.sizes > \${rna_set}@${name}_antisense.bg && wigToBigWig -clip -itemsPerSlot=1 \${rna_set}@${name}_antisense.bg \${rna_set}.chrom.sizes \${rna_set}@${name}_antisense.bw 
				fi
            fi
            
            
            
            if [ "${remove_duplicates}" == "yes" ]; then
                ## check read header whether they have UMI tags which are separated with underscore.(eg. NS5HGY:2:11_GTATAACCTT)
                umiCheck=\$(samtools view \${rna_set}@${name}_sorted.bam |head -n 1 | awk 'BEGIN {FS="\\t"}; {print \$1}' | awk 'BEGIN {FS=":"}; \$NF ~ /_/ {print \$NF}')
                
                # based on remove_duplicates_based_on_UMI_after_mapping
                if [ "${remove_duplicates_based_on_UMI_after_mapping}" == "yes" -a ! -z "\$umiCheck" ]; then
                    echo "INFO: umi_mark_duplicates.py will be executed for removing duplicates from bam file"
                    echo "python umi_mark_duplicates.py -f \${rna_set}@${name}_sorted.bam -p 4"
                    python umi_mark_duplicates.py -f \${rna_set}@${name}_sorted.bam -p 4
                else
                    echo "INFO: Picard MarkDuplicates will be executed for removing duplicates from bam file"
                    if [ "${remove_duplicates_based_on_UMI_after_mapping}" == "yes"  ]; then
                        echo "WARNING: Read header have no UMI tags which are separated with underscore. Picard MarkDuplicates will be executed to remove duplicates from alignment file (bam) instead of remove_duplicates_based_on_UMI_after_mapping."
                    fi
                    echo "INFO: picard MarkDuplicates OUTPUT=\${rna_set}@${name}_sorted.deumi.sorted.bam METRICS_FILE=${name}_picard_PCR_duplicates.log  VALIDATION_STRINGENCY=LENIENT REMOVE_DUPLICATES=false INPUT=\${rna_set}@${name}_sorted.bam"
                    picard MarkDuplicates OUTPUT=\${rna_set}@${name}_sorted.deumi.sorted.bam METRICS_FILE=${name}_picard_PCR_duplicates.log  VALIDATION_STRINGENCY=LENIENT REMOVE_DUPLICATES=false INPUT=\${rna_set}@${name}_sorted.bam 
                fi
                #get duplicates stats (read the sam flags)
                samtools flagstat \${rna_set}@${name}_sorted.deumi.sorted.bam > \${k2}@\${rna_set}@${name}_duplicates_stats.log
                #remove alignments marked as duplicates
                samtools view -b -F 0x400 \${rna_set}@${name}_sorted.deumi.sorted.bam > \${rna_set}@${name}_sorted.deumi.sorted.bam.x_dup
                #sort deduplicated files by chrom pos
                echo "INFO: samtools sort -o \${rna_set}@${name}_sorted.dedup.bam \${rna_set}@${name}_sorted.deumi.sorted.bam.x_dup"
                samtools sort -o \${rna_set}@${name}_sorted.dedup.bam \${rna_set}@${name}_sorted.deumi.sorted.bam.x_dup 
                samtools index \${rna_set}@${name}_sorted.dedup.bam
                #get flagstat after dedup
                echo "##After Deduplication##" >> \${k2}@\${rna_set}@${name}_duplicates_stats.log
                samtools flagstat \${rna_set}@${name}_sorted.dedup.bam >> \${k2}@\${rna_set}@${name}_duplicates_stats.log
                if [ "${create_bigWig}" == "yes" ]; then
					echo "INFO: creating bigWig file for dedup bam"
					bedtools genomecov -split -bg -ibam \${rna_set}@${name}_sorted.dedup.bam -g \${rna_set}.chrom.sizes > \${rna_set}@${name}_dedup.bg && wigToBigWig -clip -itemsPerSlot=1 \${rna_set}@${name}_dedup.bg \${rna_set}.chrom.sizes \${rna_set}@${name}_dedup.bw 
				fi
                
                # split sense and antisense bam files. 
	            if [ "\${senseListAr[\$k-1]}" == "Yes" ]; then
	                if [ "${mate}" == "pair" ]; then
	                    echo "INFO: paired end sense antisense separation"
	                	samtools view -f 65 -b \${rna_set}@${name}_sorted.dedup.bam >\${rna_set}@${name}_forward_sorted.dedup.bam
		                samtools index \${rna_set}@${name}_forward_sorted.dedup.bam
		                samtools view -F 16 -b \${rna_set}@${name}_forward_sorted.dedup.bam>\${rna_set}@${name}_sense_sorted.dedup.bam
		                samtools index \${rna_set}@${name}_sense_sorted.dedup.bam
		                samtools view -f 16 -b \${rna_set}@${name}_forward_sorted.dedup.bam >\${rna_set}@${name}_antisense_sorted.dedup.bam
		                samtools index \${rna_set}@${name}_antisense_sorted.dedup.bam
	                else
		                echo "INFO: single end sense antisense separation"
		                samtools view -F 16 -b \${rna_set}@${name}_sorted.dedup.bam >\${rna_set}@${name}_sense_sorted.dedup.bam
		                samtools index \${rna_set}@${name}_sense_sorted.dedup.bam
		                samtools view -f 16 -b \${rna_set}@${name}_sorted.dedup.bam >\${rna_set}@${name}_antisense_sorted.dedup.bam
		                samtools index \${rna_set}@${name}_antisense_sorted.dedup.bam
	                fi
	                if [ "${create_bigWig}" == "yes" ]; then
						echo "INFO: creating bigWig file for sense antisense bam"
						bedtools genomecov -split -bg -ibam \${rna_set}@${name}_sense_sorted.dedup.bam -g \${rna_set}.chrom.sizes > \${rna_set}@${name}_sense_sorted.dedup.bg && wigToBigWig -clip -itemsPerSlot=1 \${rna_set}@${name}_sense_sorted.dedup.bg \${rna_set}.chrom.sizes \${rna_set}@${name}_sense_sorted.dedup.bw
						bedtools genomecov -split -bg -ibam \${rna_set}@${name}_antisense_sorted.dedup.bam -g \${rna_set}.chrom.sizes > \${rna_set}@${name}_antisense_sorted.dedup.bg && wigToBigWig -clip -itemsPerSlot=1 \${rna_set}@${name}_antisense_sorted.dedup.bg \${rna_set}.chrom.sizes \${rna_set}@${name}_antisense_sorted.dedup.bw
					fi
	            fi
            fi
            
        
            for file in unmapped/*; do mv \$file \${file/.unmapped/}; done ##remove .unmapped from filename
            if [ "\${alignersListAr[\$k-1]}" == "bowtie2" ]; then
                grep -v Warning \${k2}_${name}.bow_\${rna_set} > ${name}.tmp
                mv ${name}.tmp \${k2}_${name}.bow_\${rna_set}
                cp \${k2}_${name}.bow_\${rna_set} ./../bowfiles/.
            elif [ "\${alignersListAr[\$k-1]}" == "bowtie" ]; then
                cp \${k2}_${name}.bow1_\${rna_set} ./../bowfiles/.
            elif [ "\${alignersListAr[\$k-1]}" == "STAR" ]; then
                cp \${k2}_${name}.star_\${rna_set} ./../bowfiles/.
            fi
            cd ..
            # if filter is on, remove previously created unmapped fastq. 
            if [ "\${filtersListAr[\$k-1]}" == "Yes" ]; then
                if [ "\${prev}" != "reads" ]; then
                    echo "INFO: remove prev: \${prev}/*"
                    rm -rf \${prev}/*
                elif  [ "${remove_previous_reads}" == "true" ]; then
                    echo "INFO: inputs reads will be removed if they are located in the workdir"
                    for f in \${prev}/*; do
                        targetFile=\$(readlink -e \$f)
                        echo "INFO: targetFile: \$targetFile"
                        if [[ \$targetFile == *"\${workflowWorkDir}"* ]]; then
                            rm -f \$targetFile
                            echo "INFO: \$targetFile located in workdir and deleted."
                        fi
                    done
                fi
            # if filter is off remove current unmapped fastq
            else
                echo "INFO: remove \${rna_set}/unmapped/*"
                rm -rf \${rna_set}/unmapped/*
            fi
        else
            echo "WARNING: \${startDir}/\${indexesListAr[\$k-1]}\${basename} Mapping skipped. File not found."
            cd unmapped 
            ln -s \${startDir}/\${rna_set}/*fastq.gz .
            cd ..
            cd ..
        fi
        
        if [ "\${filtersListAr[\$k-1]}" == "Yes" ]; then
            prev=\${rna_set}/unmapped
        fi
    done
    cd final_reads && ln -s \${startDir}/\${prev}/* .
else 
    mv ${reads} final_reads/.
fi
## fix for google cloud, it cannot publish symlinks which has reference to outside of the workdir
for file in "\${startDir}/final_reads"/*; do
	echo "INFO: file in final_reads folder: \$file" 
    if [ -h "\$file" ]; then
        # Check if it's a symlink
        link_target=\$(readlink "\$file")
        if [ -e "\$link_target" ]; then
            # If the target of the symlink exists, replace the symlink with the target
            rm "\$file"
            cp -a "\$link_target" "\$file"
            echo "INFO: Replaced symlink '\$file' with the original file."
        else
            # If the target doesn't exist, the symlink is broken
            echo "INFO: Broken symlink: '\$file'"
        fi
    fi
done
"""

}


process Sequential_Mapping_Module_Deduplication_Summary {

publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /deduplication_summary.tsv$/) "sequential_mapping_summary/$filename"}
input:
 path flagstat
 val mate

output:
 path "deduplication_summary.tsv"  ,emit:g72_30_outputFileTSV00 

errorStrategy 'retry'
maxRetries 2

shell:
'''
#!/usr/bin/env perl
use List::Util qw[min max];
use strict;
use File::Basename;
use Getopt::Long;
use Pod::Usage;
use Data::Dumper;

my @header;
my %all_files;
my %tsv;
my %headerHash;
my %headerText;

my $i=0;
chomp(my $contents = `ls *_duplicates_stats.log`);
my @files = split(/[\\n]+/, $contents);
foreach my $file (@files){
    $i++;
    $file=~/(.*)@(.*)@(.*)_duplicates_stats\\.log/;
    my $mapOrder = int($1); 
    my $mapper = $2; #mapped element 
    my $name = $3; ##sample name
    push(@header, $mapper) unless grep{$_ eq $mapper} @header; 
        
    # my $duplicates;
    my $aligned;
    my $dedup; #aligned reads after dedup
    my $percent=0;
    if ("!{mate}" eq "pair" ){
        #first flagstat belongs to first bam file
        chomp($aligned = `cat $file | grep 'properly paired (' | sed -n 1p | awk '{sum+=\\$1+\\$3} END {print sum}'`);
        #second flagstat belongs to dedup bam file
        chomp($dedup = `cat $file | grep 'properly paired (' | sed -n 2p | awk '{sum+=\\$1+\\$3} END {print sum}'`);
    } else {
        chomp($aligned = `cat $file | grep 'mapped (' | sed -n 1p | awk '{sum+=\\$1+\\$3} END {print sum}'`);
        chomp($dedup = `cat $file | grep 'mapped (' | sed -n 2p | awk '{sum+=\\$1+\\$3} END {print sum}'`);
    }
    # chomp($duplicates = `cat $file | grep 'duplicates' | awk '{sum+=\\$1+\\$3} END {print sum}'`);
    # $dedup = int($aligned) - int($duplicates);
    if ("!{mate}" eq "pair" ){
       $dedup = int($dedup/2);
       $aligned = int($aligned/2);
    } 
    $percent = "0.00";
    if (int($aligned)  > 0 ){
       $percent = sprintf("%.2f", ($aligned-$dedup)/$aligned*100); 
    } 
    $tsv{$name}{$mapper}=[$aligned,$dedup,"$percent%"];
    $headerHash{$mapOrder}=$mapper;
    $headerText{$mapOrder}=["$mapper (Before Dedup)", "$mapper (After Dedup)", "$mapper (Duplication Ratio %)"];
}

my @mapOrderArray = ( keys %headerHash );
my @sortedOrderArray = sort { $a <=> $b } @mapOrderArray;

my $summary = "deduplication_summary.tsv";
open(OUT, ">$summary");
print OUT "Sample\\t";
my @headArr = ();
for my $mapOrder (@sortedOrderArray) {
    push (@headArr, @{$headerText{$mapOrder}});
}
my $headArrAll = join("\\t", @headArr);
print OUT "$headArrAll\\n";

foreach my $name (keys %tsv){
    my @rowArr = ();
    for my $mapOrder (@sortedOrderArray) {
        push (@rowArr, @{$tsv{$name}{$headerHash{$mapOrder}}});
    }
    my $rowArrAll = join("\\t", @rowArr);
    print OUT "$name\\t$rowArrAll\\n";
}
close(OUT);
'''
}

//* autofill
//* platform
//* platform
//* autofill

process Sequential_Mapping_Module_Sequential_Mapping_Summary {

input:
 tuple val(name), file(bowfile)
 val mate
 val filtersList

output:
 path '*.tsv'  ,emit:g72_26_outputFileTSV00_g72_13 
 val "sequential_mapping_sum"  ,emit:g72_26_name11_g72_13 

errorStrategy 'retry'
maxRetries 2

shell:
'''
#!/usr/bin/env perl
open(my \$fh, '>', '!{name}.tsv');
print $fh "Sample\\tGroup\\tTotal Reads\\tReads After Sequential Mapping\\tUniquely Mapped\\tMultimapped\\tMapped\\n";
my @bowArray = split(' ', "!{bowfile}");
my $group= "\\t";
my @filterArray = (!{filtersList});
foreach my $bowitem(@bowArray) {
    # get mapping id
    my @bowAr = $bowitem.split("_");
    $bowCount = $bowAr[0] + -1;
    # if bowfiles ends with underscore (eg. bow_rRNA), parse rRNA as a group.
    my ($RDS_In, $RDS_After, $RDS_Uniq, $RDS_Multi, $ALGN_T, $a, $b, $aPer, $bPer)=(0, 0, 0, 0, 0, 0, 0, 0, 0);
    if ($bowitem =~ m/bow_([^\\.]+)$/){
        $group = "$1\\t";
        open(IN, $bowitem);
        my $i = 0;
        while(my $line=<IN>){
            chomp($line);
            $line=~s/^ +//;
            my @arr=split(/ /, $line);
            $RDS_In=$arr[0] if ($i=~/^1$/);
            # Reads After Filtering column depends on filtering type
            if ($i == 2){
                if ($filterArray[$bowCount] eq "Yes"){
                    $RDS_After=$arr[0];
                } else {
                    $RDS_After=$RDS_In;
                }
            }
            if ($i == 3){
                $a=$arr[0];
                $aPer=$arr[1];
                $aPer=~ s/([()])//g;
                $RDS_Uniq=$arr[0];
            }
            if ($i == 4){
                $b=$arr[0];
                $bPer=$arr[1];
                $bPer=~ s/([()])//g;
                $RDS_Multi=$arr[0];
            }
            $ALGN_T=($a+$b);
            $i++;
        }
        close(IN);
    } elsif ($bowitem =~ m/star_([^\\.]+)$/){
        $group = "$1\\t";
        open(IN2, $bowitem);
        my $multimapped;
		my $aligned;
		my $inputCount;
		chomp($inputCount = `cat $bowitem | grep 'Number of input reads' | awk '{sum+=\\$6} END {print sum}'`);
		chomp($uniqAligned = `cat $bowitem | grep 'Uniquely mapped reads number' | awk '{sum+=\\$6} END {print sum}'`);
		chomp($multimapped = `cat $bowitem | grep 'Number of reads mapped to multiple loci' | awk '{sum+=\\$9} END {print sum}'`);
		## Here we exclude "Number of reads mapped to too many loci" from multimapped reads since in bam file it called as unmapped.
		## Besides, these "too many loci" reads exported as unmapped reads from STAR.
		$RDS_In = int($inputCount);
		$RDS_Multi = int($multimapped);
        $RDS_Uniq = int($uniqAligned);
        $ALGN_T = $RDS_Uniq+$RDS_Multi;
		if ($filterArray[$bowCount] eq "Yes"){
            $RDS_After=$RDS_In-$ALGN_T;
        } else {
            $RDS_After=$RDS_In;
        }
    } elsif ($bowitem =~ m/bow1_([^\\.]+)$/){
        $group = "$1\\t";
        open(IN2, $bowitem);
        my $multimapped;
		my $aligned;
		my $inputCount;
		my $uniqAligned;
		chomp($inputCount = `cat $bowitem | grep '# reads processed:' | awk '{sum+=\\$4} END {print sum}'`);
		chomp($aligned = `cat $bowitem | grep '# reads with at least one reported alignment:' | awk '{sum+=\\$9} END {print sum}'`);
		chomp($uniqAligned = `cat $bowitem | grep '# unique mapped reads:' | awk '{sum+=\\$5} END {print sum}'`);
		## Here we exclude "Number of reads mapped to too many loci" from multimapped reads since in bam file it called as unmapped.
		## Besides, these "too many loci" reads exported as unmapped reads from STAR.
		$RDS_In = int($inputCount);
		$RDS_Multi = int($aligned) -int($uniqAligned);
		if ($RDS_Multi < 0 ){
		    $RDS_Multi = 0;
		}
        $RDS_Uniq = int($uniqAligned);
        $ALGN_T = int($aligned);
		if ($filterArray[$bowCount] eq "Yes"){
            $RDS_After=$RDS_In-$ALGN_T;
        } else {
            $RDS_After=$RDS_In;
        }
    }
    
    print $fh "!{name}\\t$group$RDS_In\\t$RDS_After\\t$RDS_Uniq\\t$RDS_Multi\\t$ALGN_T\\n";
}
close($fh);



'''

}


process Sequential_Mapping_Module_Merge_TSV_Files {

input:
 path tsv
 val outputFileName

output:
 path "${name}.tsv"  ,emit:g72_13_outputFileTSV00_g72_14 

errorStrategy 'retry'
maxRetries 3

script:
name = outputFileName[0]
"""    
awk 'FNR==1 && NR!=1 {  getline; } 1 {print} ' *.tsv > ${name}.tsv
"""
}


process Sequential_Mapping_Module_Sequential_Mapping_Short_Summary {

publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /sequential_mapping_detailed_sum.tsv$/) "sequential_mapping_summary/$filename"}
input:
 path mainSum

output:
 path "sequential_mapping_short_sum.tsv"  ,emit:g72_14_outputFileTSV01_g_75 
 path "sequential_mapping_detailed_sum.tsv"  ,emit:g72_14_outputFile11 

errorStrategy 'retry'
maxRetries 2

shell:
'''
#!/usr/bin/env perl
use List::Util qw[min max];
use File::Basename;
use Getopt::Long;
use Pod::Usage;
use Data::Dumper;

my @header;
my %all_rows;
my @seen_cols_short;
my @seen_cols_detailed;
my $ID_header;

chomp(my $contents = `ls *.tsv`);
my @files = split(/[\\n]+/, $contents);
foreach my $file (@files){
        open IN,"$file";
        my $line1 = <IN>;
        chomp($line1);
        ( $ID_header, my @h) = ( split("\\t", $line1) );
        my $totalHeader = $h[1];
        my $afterFilteringHeader = $h[2];
        my $uniqueHeader = $h[3];
        my $multiHeader = $h[4];
        my $mappedHeader = $h[5];
        push(@seen_cols_short, $totalHeader) unless grep{$_ eq $totalHeader} @seen_cols_short; #Total reads Header
        push(@seen_cols_detailed, $totalHeader) unless grep{$_ eq $totalHeader} @seen_cols_detailed; #Total reads Header

        my $n=0;
        while (my $line=<IN>) {
                
                chomp($line);
                my ( $ID, @fields ) = ( split("\\t", $line) ); 
                #SHORT
                push(@seen_cols_short, $fields[0]) unless grep{$_ eq $fields[0]} @seen_cols_short; #mapped element header
                $all_rows{$ID}{$fields[0]} = $fields[5];#Mapped Reads
                #Grep first line $fields[1] as total reads.
                if (!exists $all_rows{$ID}{$totalHeader}){    
                        $all_rows{$ID}{$totalHeader} = $fields[1];
                } 
                $all_rows{$ID}{$afterFilteringHeader} = $fields[2]; #only use last entry
                #DETAILED
                $uniqueHeadEach = "$fields[0] (${uniqueHeader})";
                $multiHeadEach = "$fields[0] (${multiHeader})";
                $mappedHeadEach = "$fields[0] (${mappedHeader})";
                push(@seen_cols_detailed, $mappedHeadEach) unless grep{$_ eq $mappedHeadEach} @seen_cols_detailed;
                push(@seen_cols_detailed, $uniqueHeadEach) unless grep{$_ eq $uniqueHeadEach} @seen_cols_detailed;
                push(@seen_cols_detailed, $multiHeadEach) unless grep{$_ eq $multiHeadEach} @seen_cols_detailed;
                $all_rows{$ID}{$mappedHeadEach} = $fields[5];
                $all_rows{$ID}{$uniqueHeadEach} = $fields[3];
                $all_rows{$ID}{$multiHeadEach} = $fields[4];
    }
    close IN;
    push(@seen_cols_short, $afterFilteringHeader) unless grep{$_ eq $afterFilteringHeader} @seen_cols_short; #After filtering Header
}


#print Dumper \\%all_rows;
#print Dumper \\%seen_cols_short;

printFiles("sequential_mapping_short_sum.tsv",@seen_cols_short,);
printFiles("sequential_mapping_detailed_sum.tsv",@seen_cols_detailed);


sub printFiles {
    my($summary, @cols_to_print) = @_;
    
    open OUT, ">$summary";
    print OUT join ("\\t", $ID_header,@cols_to_print),"\\n";
    foreach my $key ( keys %all_rows ) { 
        print OUT join ("\\t", $key, (map { $all_rows{$key}{$_} // '' } @cols_to_print)),"\\n";
        }
        close OUT;
}

'''


}


//* autofill
if ($HOSTNAME == "default"){
    $CPU  = 3
    $MEMORY = 18
}
//* platform
//* platform
//* autofill

process Bowtie2_Module_Map_Bowtie2 {

publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /${name}.bow$/) "bowtie2/$filename"}
input:
 tuple val(name), file(reads)
 val mate
 path bowtie2index

output:
 tuple val(name), file("${name}.bow")  ,emit:g73_3_bowfiles00_g73_10 
 tuple val(name), file("${name}.unmap*.fastq") ,optional:true  ,emit:g73_3_unmapped_fastq11 
 tuple val(name), file("${name}.bam")  ,emit:g73_3_bam_file20_g73_4 
 path "${name}.bow"  ,emit:g73_3_bowfiles312_g_70 

when:
(params.run_Bowtie2 && (params.run_Bowtie2 == "yes")) || !params.run_Bowtie2

script:
Map_Bowtie2_parameters = params.Bowtie2_Module_Map_Bowtie2.Map_Bowtie2_parameters

nameAll = reads.toString()
nameArray = nameAll.split(' ')
file2 = "";

if (nameAll.contains('.gz')) {
    file1 =  nameArray[0] 
    if (mate == "pair") {file2 =  nameArray[1] }
} 

""" 
basename=\$(basename ${bowtie2index}/*.rev.2.bt2 | cut -d. -f1)
if [ "${mate}" == "pair" ]; then
    bowtie2 -x ${bowtie2index}/\${basename} ${Map_Bowtie2_parameters} --no-unal  -1 ${file1} -2 ${file2} -S ${name}.sam > ${name}.bow 2>&1
else
    bowtie2 -x ${bowtie2index}/\${basename} ${Map_Bowtie2_parameters}  -U ${file1} -S ${name}.sam > ${name}.bow 2>&1
fi
grep -v Warning ${name}.bow > ${name}.tmp
mv  ${name}.tmp ${name}.bow 
samtools view -bS ${name}.sam > ${name}.bam 
rm -rf ${name}.sam
"""


}

//* autofill
//* platform
//* platform
//* autofill

process Bowtie2_Module_Bowtie_Summary {

input:
 tuple val(name), file(bowfile)
 val mate

output:
 path '*.tsv'  ,emit:g73_10_outputFileTSV00_g73_11 
 val "bowtie_sum"  ,emit:g73_10_name11_g73_11 

shell:
'''
#!/usr/bin/env perl
open(my \$fh, '>', "!{name}.tsv");
print $fh "Sample\\tTotal Reads\\tUnique Reads Aligned (Bowtie2)\\tMultimapped Reads Aligned (Bowtie2)\\n";
my @bowArray = split(' ', "!{bowfile}");
my ($RDS_T, $RDS_C1, $RDS_C2)=(0, 0, 0);
foreach my $bowitem(@bowArray) {
    # get mapping id
    open(IN, $bowitem);
    my $i = 0;
    while(my $line=<IN>)
    {
        chomp($line);
        $line=~s/^ +//;
        my @arr=split(/ /, $line);
        $RDS_T+=$arr[0] if ($i=~/^1$/);
        if ($i == 3){
            $RDS_C1+=$arr[0];
        }
        if ($i == 4){
            $RDS_C2+=$arr[0];
        }
        $i++;
    }
    close(IN);
}
print $fh "!{name}\\t$RDS_T\\t$RDS_C1\\t$RDS_C2\\n";
close($fh);



'''

}


process Bowtie2_Module_Merge_TSV_Files {

input:
 path tsv
 val outputFileName

output:
 path "${name}.tsv"  ,emit:g73_11_outputFileTSV00_g_75 

errorStrategy 'retry'
maxRetries 3

script:
name = outputFileName[0]
"""    
awk 'FNR==1 && NR!=1 {  getline; } 1 {print} ' *.tsv > ${name}.tsv
"""
}

//* autofill
//* platform
//* platform
//* autofill

process Overall_Summary {

publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /overall_summary.tsv$/) "summary/$filename"}
input:
 path starSum
 path sequentialSum
 path adapterSum
 path trimmerSum
 path qualitySum

output:
 path "overall_summary.tsv" ,optional:true  ,emit:g_75_outputFileTSV011_g_99 

shell:
'''
#!/usr/bin/env perl
use List::Util qw[min max];
use strict;
use File::Basename;
use Getopt::Long;
use Pod::Usage;
use Data::Dumper;

my @header;
my %all_rows;
my @seen_cols;
my $ID_header;

chomp(my $contents = `ls *.tsv`);
my @rawFiles = split(/[\\n]+/, $contents);
if (scalar @rawFiles == 0){
    exit;
}
my @files = ();
# order must be in this order for chipseq pipeline: bowtie->dedup
# rsem bam pipeline: dedup->rsem, star->dedup
# riboseq ncRNA_removal->star
my @order = ("adapter_removal","trimmer","quality","extractUMI","extractValid","tRAX","sequential_mapping","ncRNA_removal","bowtie","star","hisat2","tophat2", "dedup","rsem","kallisto","salmon","esat","count");
for ( my $k = 0 ; $k <= $#order ; $k++ ) {
    for ( my $i = 0 ; $i <= $#rawFiles ; $i++ ) {
        if ( $rawFiles[$i] =~ /$order[$k]/ ) {
            push @files, $rawFiles[$i];
        }
    }
}

print Dumper \\@files;
##add rest of the files
for ( my $i = 0 ; $i <= $#rawFiles ; $i++ ) {
    push(@files, $rawFiles[$i]) unless grep{$_ == $rawFiles[$i]} @files;
}
print Dumper \\@files;

##Merge each file according to array order

foreach my $file (@files){
        open IN,"$file";
        my $line1 = <IN>;
        chomp($line1);
        ( $ID_header, my @header) = ( split("\\t", $line1) );
        push @seen_cols, @header;

        while (my $line=<IN>) {
        chomp($line);
        my ( $ID, @fields ) = ( split("\\t", $line) ); 
        my %this_row;
        @this_row{@header} = @fields;

        #print Dumper \\%this_row;

        foreach my $column (@header) {
            if (! exists $all_rows{$ID}{$column}) {
                $all_rows{$ID}{$column} = $this_row{$column}; 
            }
        }   
    }
    close IN;
}

#print for debugging
#print Dumper \\%all_rows;
#print Dumper \\%seen_cols;

#grab list of column headings we've seen, and order them. 
my @cols_to_print = uniq(@seen_cols);
my $summary = "overall_summary.tsv";
open OUT, ">$summary";
print OUT join ("\\t", $ID_header,@cols_to_print),"\\n";
foreach my $key ( keys %all_rows ) { 
    #map iterates all the columns, and gives the value or an empty string. if it's undefined. (prevents errors)
    print OUT join ("\\t", $key, (map { $all_rows{$key}{$_} // '' } @cols_to_print)),"\\n";
}
close OUT;

sub uniq {
    my %seen;
    grep ! $seen{$_}++, @_;
}

'''


}



//* autofill
//* platform
//* platform
//* autofill

process Bowtie2_Module_Merge_Bam {

publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /.*_sorted.*bam$/) "bowtie2/$filename"}
input:
 tuple val(oldname), file(bamfiles)

output:
 tuple val(oldname), file("${oldname}.bam")  ,emit:g73_4_merged_bams00 
 tuple val(oldname), file("*_sorted*bai")  ,emit:g73_4_bam_index11 
 tuple val(oldname), file("*_sorted*bam")  ,emit:g73_4_sorted_bam20_g87_0 

errorStrategy 'retry'
maxRetries 6

shell:
'''
num=$(echo "!{bamfiles.join(" ")}" | awk -F" " '{print NF-1}')
if [ "${num}" -gt 0 ]; then
    samtools merge !{oldname}.bam !{bamfiles.join(" ")} && samtools sort -O bam -T !{oldname} -o !{oldname}_sorted.bam !{oldname}.bam && samtools index !{oldname}_sorted.bam
else
    mv !{bamfiles.join(" ")} !{oldname}.bam 2>/dev/null || true
    samtools sort  -T !{oldname} -O bam -o !{oldname}_sorted.bam !{oldname}.bam && samtools index !{oldname}_sorted.bam
fi
'''
}


process Sequential_Mapping_Module_Sequential_Mapping_Bam_Dedup_count {

publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /.*.counts.tsv$/) "sequential_mapping_counts/$filename"}
input:
 path bam
 path index
 path bowtie_index
 path bowtie2_index
 path star_index
 path commondb

output:
 path "*.counts.tsv"  ,emit:g72_45_outputFileTSV00 

shell:
mappingListQuoteSep = mapList.collect{ '"' + it + '"'}.join(",")
rawIndexList = indexList.collect{ '"' + it + '"'}.join(",")
selectSeqListQuote = selectSequenceList.collect{ '"' + it + '"'}.join(",")
alignerListQuote = alignerList.collect{ '"' + it + '"'}.join(",")
'''
#!/usr/bin/env perl
use List::Util qw[min max];
use File::Basename;
use Getopt::Long;
use Pod::Usage;
use Data::Dumper;

my @header;
my @header_antisense;
my @header_sense;
my %all_files;
my %sense_files;
my %antisense_files;

my @mappingList = (!{mappingListQuoteSep});
my @rawIndexList = (!{rawIndexList});
my @selectSeqList = (!{selectSeqListQuote});
my @alignerList = (!{alignerListQuote});

my %indexHash;
my %selectSeqHash;
my %alignerHash;
my $dedup = "";
@indexHash{@mappingList} = @rawIndexList;
@selectSeqHash{@mappingList} = @selectSeqList;
@alignerHash{@mappingList} = @alignerList;

chomp(my $contents = `ls *.bam`);
my @files = split(/[\\n]+/, $contents);
foreach my $file (@files){
        $file=~/(.*)@(.*)_sorted(.*)\\.bam/;
        my $mapper = $1; 
        my $name = $2; ##header
        #print $3;
        if ($3 eq ".dedup"){
            $dedup = ".dedup";
        }
        if ($name=~/_antisense$/){
        	push(@header_antisense, $name) unless grep{$_ eq $name} @header_antisense; #mapped element header
        	$antisense_files{$mapper} .= $file." ";
        }
        elsif ($name=~/_sense$/){
        	push(@header_sense, $name) unless grep{$_ eq $name} @header_sense; #mapped element header
        	$sense_files{$mapper} .= $file." ";
        }
        else{
			push(@header, $name) unless grep{$_ eq $name} @header; #mapped element header
	        $all_files{$mapper} .= $file." ";
        }
}

runCov(\\%all_files, \\@header, \\@indexHash, "", $dedup);
runCov(\\%sense_files, \\@header_sense, \\@indexHash, "sense", $dedup);
runCov(\\%antisense_files, \\@header_antisense, \\@indexHash, "antisense", $dedup);

sub runCov {
	my ( \$files, \$header, \$indexHash, \$sense_antisense, \$dedup) = @_;
	open OUT, ">header".\$sense_antisense.".tsv";
	print OUT join ("\\t", "id","len",@{\$header}),"\\n";
	close OUT;
	my $par = "";
	if ($sense_antisense=~/^sense\$/){
      $par = "-s";
    }elsif($sense_antisense=~/^antisense\$/){
      $par = "-S";
    }
	
	foreach my $key (sort keys %{\$files}) {  
	   my $bamFiles = ${\$files}{$key};
	   
	   my $prefix = ${indexHash}{$key};
	   my $selectedSeq = ${selectSeqHash}{$key};
	   my $aligner = ${alignerHash}{$key};
	   if ($selectedSeq eq "genome"){
	   	  if ($aligner eq "bowtie"){
	   		$basename = `basename $prefix/*.rev.1.ebwt | cut -d. -f1`;
	   	  } elsif ($aligner eq "bowtie2"){
	   		$basename = `basename $prefix/*.rev.1.bt2 | cut -d. -f1`;
	   	  } elsif ($aligner eq "STAR"){
	   	    $basename = `basename $prefix/*.gtf | cut -d. -f1`;
	   	  }
	   	  $basename =~ s|\\s*$||;
	   	  $prefix = $prefix."/".$basename;
	   }  elsif($selectedSeq eq "custom"){
	   	  if (substr($prefix, 0, length("s3")) eq "s3"){
	   	  	 my $filename = (split '/', $prefix)[-1];
	   	  	 $filename =~ s/\\.fa//;
	   	  	 $prefix = "custom_seqs/${key}/${filename}";
	   	  	 print "new prefix $prefix\\n";
	   	  }
       }
	   
		unless (-e $prefix.".bed") {
            print "2: bed not found run makeBed\\n";
                if (-e $prefix.".fa") {
                    makeBed($prefix.".fa", $key, $prefix.".bed");
                } elsif(-e $prefix.".fasta"){
                    makeBed($prefix.".fasta", $key, $prefix.".bed");
                }
        }
	    
		my $com =  "bedtools multicov $par -bams $bamFiles -bed ".$prefix.".bed > $key${dedup}${sense_antisense}.counts.tmp\\n";
        print $com;
        `$com`;
        my $iniResColumn = int(countColumn($prefix.".bed")) + 1;
	    `awk -F \\"\\\\t\\" \\'{a=\\"\\";for (i=$iniResColumn;i<=NF;i++){a=a\\"\\\\t\\"\\$i;} print \\$4\\"\\\\t\\"(\\$3-\\$2)\\"\\"a}\\' $key${dedup}${sense_antisense}.counts.tmp> $key${dedup}${sense_antisense}.counts.tsv`;
	    `sort -k3,3nr $key${dedup}${sense_antisense}.counts.tsv>$key${dedup}${sense_antisense}.sorted.tsv`;
        `cat header${sense_antisense}.tsv $key${dedup}${sense_antisense}.sorted.tsv> $key${dedup}${sense_antisense}.counts.tsv`;
	}
}

sub countColumn {
    my ( \$file) = @_;
    open(IN, \$file);
    my $line=<IN>;
    chomp($line);
    my @cols = split('\\t', $line);
    my $n = @cols;
    close OUT;
    return $n;
}

sub makeBed {
    my ( \$fasta, \$type, \$bed) = @_;
    print "makeBed $fasta\\n";
    print "makeBed $bed\\n";
    open OUT, ">$bed";
    open(IN, \$fasta);
    my $name="";
    my $seq="";
    my $i=0;
    while(my $line=<IN>){
        chomp($line);
        if($line=~/^>(.*)/){
            $i++ if (length($seq)>0);
            print OUT "$name\\t1\\t".length($seq)."\\t$name\\t0\\t+\\n" if (length($seq)>0); 
            $name="$1";
            $seq="";
        } elsif($line=~/[ACGTNacgtn]+/){
            $seq.=$line;
        }
    }
    $name=~s/\\r//g;
    print OUT "$name\\t1\\t".length($seq)."\\t$name\\t0\\t+\\n" if (length($seq)>0); 
    close OUT;
}

'''
}


process Sequential_Mapping_Module_Sequential_Mapping_Bam_count {

publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /.*.counts.tsv$/) "sequential_mapping_counts/$filename"}
input:
 path bam
 path index
 path bowtie_index
 path bowtie2_index
 path star_index
 path commondb

output:
 path "*.counts.tsv"  ,emit:g72_44_outputFileTSV00 

shell:
mappingListQuoteSep = mapList.collect{ '"' + it + '"'}.join(",")
rawIndexList = indexList.collect{ '"' + it + '"'}.join(",")
selectSeqListQuote = selectSequenceList.collect{ '"' + it + '"'}.join(",")
alignerListQuote = alignerList.collect{ '"' + it + '"'}.join(",")
'''
#!/usr/bin/env perl
use List::Util qw[min max];
use File::Basename;
use Getopt::Long;
use Pod::Usage;
use Data::Dumper;

my @header;
my @header_antisense;
my @header_sense;
my %all_files;
my %sense_files;
my %antisense_files;

my @mappingList = (!{mappingListQuoteSep});
my @rawIndexList = (!{rawIndexList});
my @selectSeqList = (!{selectSeqListQuote});
my @alignerList = (!{alignerListQuote});

my %indexHash;
my %selectSeqHash;
my %alignerHash;
my $dedup = "";
@indexHash{@mappingList} = @rawIndexList;
@selectSeqHash{@mappingList} = @selectSeqList;
@alignerHash{@mappingList} = @alignerList;

chomp(my $contents = `ls *.bam`);
my @files = split(/[\\n]+/, $contents);
foreach my $file (@files){
        $file=~/(.*)@(.*)_sorted(.*)\\.bam/;
        my $mapper = $1; 
        my $name = $2; ##header
        #print $3;
        if ($3 eq ".dedup"){
            $dedup = ".dedup";
        }
        if ($name=~/_antisense$/){
        	push(@header_antisense, $name) unless grep{$_ eq $name} @header_antisense; #mapped element header
        	$antisense_files{$mapper} .= $file." ";
        }
        elsif ($name=~/_sense$/){
        	push(@header_sense, $name) unless grep{$_ eq $name} @header_sense; #mapped element header
        	$sense_files{$mapper} .= $file." ";
        }
        else{
			push(@header, $name) unless grep{$_ eq $name} @header; #mapped element header
	        $all_files{$mapper} .= $file." ";
        }
}

runCov(\\%all_files, \\@header, \\@indexHash, "", $dedup);
runCov(\\%sense_files, \\@header_sense, \\@indexHash, "sense", $dedup);
runCov(\\%antisense_files, \\@header_antisense, \\@indexHash, "antisense", $dedup);

sub runCov {
	my ( \$files, \$header, \$indexHash, \$sense_antisense, \$dedup) = @_;
	open OUT, ">header".\$sense_antisense.".tsv";
	print OUT join ("\\t", "id","len",@{\$header}),"\\n";
	close OUT;
	my $par = "";
	if ($sense_antisense=~/^sense\$/){
      $par = "-s";
    }elsif($sense_antisense=~/^antisense\$/){
      $par = "-S";
    }
	
	foreach my $key (sort keys %{\$files}) {  
	   my $bamFiles = ${\$files}{$key};
	   
	   my $prefix = ${indexHash}{$key};
	   my $selectedSeq = ${selectSeqHash}{$key};
	   my $aligner = ${alignerHash}{$key};
	   if ($selectedSeq eq "genome"){
	   	  if ($aligner eq "bowtie"){
	   		$basename = `basename $prefix/*.rev.1.ebwt | cut -d. -f1`;
	   	  } elsif ($aligner eq "bowtie2"){
	   		$basename = `basename $prefix/*.rev.1.bt2 | cut -d. -f1`;
	   	  } elsif ($aligner eq "STAR"){
	   	    $basename = `basename $prefix/*.gtf | cut -d. -f1`;
	   	  }
	   	  $basename =~ s|\\s*$||;
	   	  $prefix = $prefix."/".$basename;
	   }  elsif($selectedSeq eq "custom"){
	   	  if (substr($prefix, 0, length("s3")) eq "s3"){
	   	  	 my $filename = (split '/', $prefix)[-1];
	   	  	 $filename =~ s/\\.fa//;
	   	  	 $prefix = "custom_seqs/${key}/${filename}";
	   	  	 print "new prefix $prefix\\n";
	   	  }
       }
	   
		unless (-e $prefix.".bed") {
            print "2: bed not found run makeBed\\n";
                if (-e $prefix.".fa") {
                    makeBed($prefix.".fa", $key, $prefix.".bed");
                } elsif(-e $prefix.".fasta"){
                    makeBed($prefix.".fasta", $key, $prefix.".bed");
                }
        }
	    
		my $com =  "bedtools multicov $par -bams $bamFiles -bed ".$prefix.".bed > $key${dedup}${sense_antisense}.counts.tmp\\n";
        print $com;
        `$com`;
        my $iniResColumn = int(countColumn($prefix.".bed")) + 1;
	    `awk -F \\"\\\\t\\" \\'{a=\\"\\";for (i=$iniResColumn;i<=NF;i++){a=a\\"\\\\t\\"\\$i;} print \\$4\\"\\\\t\\"(\\$3-\\$2)\\"\\"a}\\' $key${dedup}${sense_antisense}.counts.tmp> $key${dedup}${sense_antisense}.counts.tsv`;
	    `sort -k3,3nr $key${dedup}${sense_antisense}.counts.tsv>$key${dedup}${sense_antisense}.sorted.tsv`;
        `cat header${sense_antisense}.tsv $key${dedup}${sense_antisense}.sorted.tsv> $key${dedup}${sense_antisense}.counts.tsv`;
	}
}

sub countColumn {
    my ( \$file) = @_;
    open(IN, \$file);
    my $line=<IN>;
    chomp($line);
    my @cols = split('\\t', $line);
    my $n = @cols;
    close OUT;
    return $n;
}

sub makeBed {
    my ( \$fasta, \$type, \$bed) = @_;
    print "makeBed $fasta\\n";
    print "makeBed $bed\\n";
    open OUT, ">$bed";
    open(IN, \$fasta);
    my $name="";
    my $seq="";
    my $i=0;
    while(my $line=<IN>){
        chomp($line);
        if($line=~/^>(.*)/){
            $i++ if (length($seq)>0);
            print OUT "$name\\t1\\t".length($seq)."\\t$name\\t0\\t+\\n" if (length($seq)>0); 
            $name="$1";
            $seq="";
        } elsif($line=~/[ACGTNacgtn]+/){
            $seq.=$line;
        }
    }
    $name=~s/\\r//g;
    print OUT "$name\\t1\\t".length($seq)."\\t$name\\t0\\t+\\n" if (length($seq)>0); 
    close OUT;
}

'''
}

//* params.run_Remove_Multimappers_with_Samtools =  "no"  //* @dropdown @options:"yes","no" @show_settings:"Remove_Multimappers"


process ChIP_Module_Samtools_Remove_Multimappers {

publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /bam\/${name}.bam$/) "samtools_deduplication/$filename"}
input:
 tuple val(name), file(bam)

output:
 tuple val(name), file("bam/${name}.bam")  ,emit:g87_0_mapped_reads00_g87_1 

when:
params.run_Remove_Multimappers_with_Samtools == "yes" 

script:
MAPQ_quality = params.ChIP_Module_Samtools_Remove_Multimappers.MAPQ_quality
"""
mkdir bam
samtools view -hb -q ${MAPQ_quality} ${bam} > ${name}_unique.bam
mv ${name}_unique.bam bam/${name}.bam
"""

}

//* params.run_Picard_MarkDuplicates =  "yes"  //* @dropdown @options:"yes","no"

//* autofill
if ($HOSTNAME == "default"){
    $CPU  = 1
    $MEMORY = 32
}
//* platform
//* platform
//* autofill

process ChIP_Module_Picard_MarkDuplicates {

publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /${name}.*$/) "picard_deduplication/$filename"}
input:
 tuple val(name), file(bam)

output:
 tuple val(name), file("bam/${name}.bam")  ,emit:g87_1_mapped_reads01_g87_6 
 tuple val(name), file("${name}*")  ,emit:g87_1_publish11 
 path "*_duplicates_stats.log" ,optional:true  ,emit:g87_1_log_file22 

container 'quay.io/ummsbiocore/picard:1.0'

when:
(params.run_Picard_MarkDuplicates && (params.run_Picard_MarkDuplicates == "yes")) || !params.run_Picard_MarkDuplicates     

script:
"""
mkdir bam
picard MarkDuplicates OUTPUT=${name}_dedup.bam METRICS_FILE=${name}_PCR_duplicates  VALIDATION_STRINGENCY=LENIENT REMOVE_DUPLICATES=true INPUT=${bam} 
mv ${name}_dedup.bam bam/${name}.bam
grep "Unknown" *_PCR_duplicates|awk -F '\t' '{print "${name}\t" \$9}' > ${name}_picardDedup_summary.txt
"""
}

//* params.bedtools_path =  ""  //* @input
macs3_callpeak_parameters = params.ChIP_Module_ChIP_Prep.macs3_callpeak_parameters
peak_calling_type = params.ChIP_Module_ChIP_Prep.peak_calling_type
band_width = params.ChIP_Module_ChIP_Prep.band_width
bedtoolsCoverage_Parameters = params.ChIP_Module_ChIP_Prep.bedtoolsCoverage_Parameters
compare_Custom_Bed = params.ChIP_Module_ChIP_Prep.compare_Custom_Bed
output_prefix = params.ChIP_Module_ChIP_Prep.output_prefix
sample_prefix = params.ChIP_Module_ChIP_Prep.sample_prefix
input_prefix = params.ChIP_Module_ChIP_Prep.input_prefix
//* @spreadsheet:{output_prefix,sample_prefix,input_prefix} @multicolumn:{output_prefix,sample_prefix,input_prefix},{macs3_callpeak_parameters,peak_calling_type,band_width,bedtoolsCoverage_Parameters}
samplehash = [:]
inputhash = [:]
output_prefix.eachWithIndex { key, i -> inputhash[key] = input_prefix[i] }
output_prefix.eachWithIndex { key, i -> samplehash[key] = sample_prefix[i] }

// String nameList = output_prefix.collect { "\"$it\"" }.join( ' ' )
// String samplesList = sample_prefix.collect { "\"$it\"" }.join( ' ' )
// String inputsList = input_prefix.collect { "\"$it\"" }.join( ' ' )

process ChIP_Module_ChIP_Prep {

input:
 val mate
 tuple val(name), file(bam)

output:
 path "bam/*.bam"  ,emit:g87_6_bam_file01_g87_9 
 val output_prefix  ,emit:g87_6_name12_g87_9 

when:
(params.run_ChIP_MACS3 && (params.run_ChIP_MACS3 == "yes")) || !params.run_ChIP_MACS3

script:
"""
mkdir -p bam
mv ${bam} bam/${name}.bam
"""
}


process ChIP_Module_ChIP_MACS3 {

publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /bam\/.*.bam$/) "chip/$filename"}
publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /${name}.*$/) "chip/$filename"}
input:
 val mate
 path bam
 val name

output:
 val compare_bed  ,emit:g87_9_compare_bed00_g87_12 
 tuple val(name), file("*${peak_calling_type}Peak")  ,emit:g87_9_bedFile10_g87_11 
 tuple val(name), file("bam/*.bam")  ,emit:g87_9_bam_file22_g87_12 
 path "${name}*"  ,emit:g87_9_resultsdir310_g_70 

container "quay.io/ummsbiocore/macs3-samtools:1.0.2"

script:
genomeSizeText = ""
if (params.genome_build.contains("mouse")){
    genomeSizeText = "-g mm"
} else if (params.genome_build.contains("human")){
    genomeSizeText = "-g hs"
}

if (peak_calling_type == "narrow"){
    peakcallingType = ""
} else if (peak_calling_type == "broad"){
    peakcallingType = "--broad"
}

compare_bed = "merged.bed"
compare_Custom_Bed = compare_Custom_Bed.trim();
if (compare_Custom_Bed != ""){
    compare_bed = compare_Custom_Bed
}
inputsList = inputhash[name] 
samplesList = samplehash[name]

"""
echo ${samplesList}
echo ${inputsList}
echo $name
mkdir -p bam

#samplesList
samplesList="\$(echo -e "${samplesList}" | tr -d '[:space:]')" 
IFS=',' read -ra eachSampleAr <<< "\${samplesList}"
numSamples=\${#eachSampleAr[@]}
eachSampleArBam=( "\${eachSampleAr[@]/%/.bam }" )
sample_set=\${eachSampleArBam[@]}
bam_set=\${eachSampleArBam[@]}

#inputsList
input_set=""
inputsList="\$(echo -e "${inputsList}" | tr -d '[:space:]')" 
if [ "\${inputsList}" != "" ]; then
    IFS=',' read -ra eachInputAr <<< "\${inputsList}"
    eachInputArbam=( "\${eachInputAr[@]/%/.bam }" )
    input_set="-c \${eachInputArbam[@]}" 
    
fi
echo \${eachSampleArBam[@]}

macs3 callpeak --bw ${band_width} -t \${sample_set} \${input_set} -n ${name} ${genomeSizeText} ${macs3_callpeak_parameters} ${peakcallingType}

#bam files
if [ "\$numSamples" -gt "1" ]; then
    samtools merge bam/${name}.bam \$bam_set
else 
    cp  \$bam_set bam/${name}.bam
fi

"""
}

//* params.pdfbox_path =  ""  //* @input
//* autofill
if ($HOSTNAME == "default"){
    $CPU  = 1
    $MEMORY = 32
}
//* platform
//* platform
//* autofill

process BAM_Analysis_Module_Picard {

input:
 tuple val(name), file(bam)

output:
 path "*_metrics"  ,emit:g74_121_outputFileOut00_g74_82 
 path "results/*.pdf"  ,emit:g74_121_outputFilePdf12_g74_82 

container 'quay.io/ummsbiocore/picard:1.0'

when:
(params.run_Picard_CollectMultipleMetrics && (params.run_Picard_CollectMultipleMetrics == "yes")) || !params.run_Picard_CollectMultipleMetrics

script:
"""
picard CollectMultipleMetrics OUTPUT=${name}_multiple.out VALIDATION_STRINGENCY=LENIENT INPUT=${bam}
mkdir results && java -jar ${params.pdfbox_path} PDFMerger *.pdf results/${name}_multi_metrics.pdf
"""
}


process BAM_Analysis_Module_Picard_Summary {

publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /.*.tsv$/) "picard_summary/$filename"}
publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /results\/.*.pdf$/) "picard/$filename"}
input:
 path picardOut
 val mate
 path picardPdf

output:
 path "*.tsv"  ,emit:g74_82_outputFileTSV00 
 path "results/*.pdf"  ,emit:g74_82_outputFilePdf11 

script:
"""
#!/usr/bin/env perl
use List::Util qw[min max];
use strict;
use File::Basename;
use Getopt::Long;
use Pod::Usage; 
use Data::Dumper;

runCommand("mkdir results && mv *.pdf results/. ");

my \$indir = \$ENV{'PWD'};
my \$outd = \$ENV{'PWD'};
my @files = ();
my @outtypes = ("CollectRnaSeqMetrics", "alignment_summary_metrics", "base_distribution_by_cycle_metrics", "insert_size_metrics", "quality_by_cycle_metrics", "quality_distribution_metrics" );

foreach my \$outtype (@outtypes)
{
my \$ext="_multiple.out";
\$ext.=".\$outtype" if (\$outtype ne "CollectRnaSeqMetrics");
@files = <\$indir/*\$ext>;

my @rowheaders=();
my @libs=();
my %metricvals=();
my %histvals=();

my \$pdffile="";
my \$libname="";
foreach my \$d (@files){
  my \$libname=basename(\$d, \$ext);
  print \$libname."\\n";
  push(@libs, \$libname); 
  getMetricVals(\$d, \$libname, \\%metricvals, \\%histvals, \\@rowheaders);
}

my \$sizemetrics = keys %metricvals;
write_results("\$outd/\$outtype.stats.tsv", \\@libs,\\%metricvals, \\@rowheaders, "metric") if (\$sizemetrics>0);
my \$sizehist = keys %histvals;
write_results("\$outd/\$outtype.hist.tsv", \\@libs,\\%histvals, "none", "nt") if (\$sizehist>0);

}

sub write_results
{
  my (\$outfile, \$libs, \$vals, \$rowheaders, \$name )=@_;
  open(OUT, ">\$outfile");
  print OUT "\$name\\t".join("\\t", @{\$libs})."\\n";
  my \$size=0;
  \$size=scalar(@{\${\$vals}{\${\$libs}[0]}}) if(exists \${\$libs}[0] and exists \${\$vals}{\${\$libs}[0]} );
  
  for (my \$i=0; \$i<\$size;\$i++)
  { 
    my \$rowname=\$i;
    \$rowname = \${\$rowheaders}[\$i] if (\$name=~/metric/);
    print OUT \$rowname;
    foreach my \$lib (@{\$libs})
    {
      print OUT "\\t".\${\${\$vals}{\$lib}}[\$i];
    } 
    print OUT "\\n";
  }
  close(OUT);
}

sub getMetricVals{
  my (\$filename, \$libname, \$metricvals, \$histvals,\$rowheaders)=@_;
  if (-e \$filename){
     my \$nextisheader=0;
     my \$nextisvals=0;
     my \$nexthist=0;
     open(IN, \$filename);
     while(my \$line=<IN>)
     {
       chomp(\$line);
       @{\$rowheaders}=split(/\\t/, \$line) if (\$nextisheader && !scalar(@{\$rowheaders})); 
       if (\$nextisvals) {
         @{\${\$metricvals}{\$libname}}=split(/\\t/, \$line);
         \$nextisvals=0;
       }
       if(\$nexthist){
          my @vals=split(/[\\s\\t]+/,\$line); 
          push(@{\${\$histvals}{\$libname}}, \$vals[1]) if (exists \$vals[1]);
       }
       \$nextisvals=1 if (\$nextisheader); \$nextisheader=0;
       \$nextisheader=1 if (\$line=~/METRICS CLASS/);
       \$nexthist=1 if (\$line=~/normalized_position/);
     } 
  }
  
}


sub runCommand {
	my (\$com) = @_;
	if (\$com eq ""){
		return "";
    }
    my \$error = system(@_);
	if   (\$error) { die "Command failed: \$error \$com\\n"; }
    else          { print "Command successful: \$com\\n"; }
}
"""

}

//* params.bed =  ""  //* @input
//* autofill
if ($HOSTNAME == "default"){
    $CPU  = 1
    $MEMORY = 4
}
//* platform
//* platform
//* autofill

process BAM_Analysis_Module_RSeQC {

publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /result\/.*.out$/) "rseqc/$filename"}
input:
 tuple val(name), file(bam)
 path bed

output:
 path "result/*.out"  ,emit:g74_134_outputFileOut011_g_70 

label 'rseqc'

when:
(params.run_RSeQC && (params.run_RSeQC == "yes")) || !params.run_RSeQC

script:
"""
mkdir result
# samtools index ${bam}
read_distribution.py  -i ${bam} -r ${bed}> result/RSeQC.${name}.out
infer_experiment.py -i $bam  -r $bed > result/${name}.infer_experiment.out
"""
}



//* autofill
if ($HOSTNAME == "default"){
    $CPU  = 1
    $MEMORY = 48
}
//* platform
//* platform
//* autofill

process BAM_Analysis_Module_UCSC_BAM2BigWig_converter {

publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /.*.bw$/) "bigwig/$filename"}
input:
 tuple val(name), file(bam)
 path genomeSizes

output:
 tuple val(name), file("*.bw")  ,emit:g74_142_bigWig_tuple00_g_109 

when:
(params.run_BigWig_Conversion && (params.run_BigWig_Conversion == "yes")) || !params.run_BigWig_Conversion

script:
nameAll = bam.toString()
if (nameAll.contains('_sorted.bam')) {
    runSamtools = "samtools index ${nameAll}"
    nameFinal = nameAll
} else {
    runSamtools = "samtools sort -o ${name}_sorted.bam $bam && samtools index ${name}_sorted.bam "
    nameFinal = "${name}_sorted.bam"
}

"""
$runSamtools
bedtools genomecov -split -bg -ibam ${nameFinal} -g ${genomeSizes} > ${name}.bg 
wigToBigWig -clip -itemsPerSlot=1 ${name}.bg ${genomeSizes} ${name}.bw 
"""
}


process tuple_to_file_for_bigwig {

input:
 tuple val(name), file(bigwig)

output:
 path bigwig  ,emit:g_109_bigWig_file03_g_99 

script:
"""
echo $bigwig
"""
}

igv_extention_factor = params.BAM_Analysis_Module_IGV_BAM2TDF_converter.igv_extention_factor
igv_window_size = params.BAM_Analysis_Module_IGV_BAM2TDF_converter.igv_window_size

//* autofill
if ($HOSTNAME == "default"){
    $CPU  = 1
    $MEMORY = 24
}
//* platform
//* platform
//* autofill

process BAM_Analysis_Module_IGV_BAM2TDF_converter {

publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /.*.tdf$/) "igv_tdf_converter/$filename"}
input:
 val mate
 tuple val(name), file(bam)
 path genomeSizes

output:
 path "*.tdf"  ,emit:g74_131_outputFileOut00 

when:
(params.run_IGV_TDF_Conversion && (params.run_IGV_TDF_Conversion == "yes")) || !params.run_IGV_TDF_Conversion

script:
pairedText = (params.nucleicAcidType == "dna" && mate == "pair") ? " --pairs " : ""
nameAll = bam.toString()
if (nameAll.contains('_sorted.bam')) {
    runSamtools = "samtools index ${nameAll}"
    nameFinal = nameAll
} else {
    runSamtools = "samtools sort -o ${name}_sorted.bam $bam && samtools index ${name}_sorted.bam "
    nameFinal = "${name}_sorted.bam"
}
"""
$runSamtools
igvtools count -w ${igv_window_size} -e ${igv_extention_factor} ${pairedText} ${nameFinal} ${name}.tdf ${genomeSizes}
"""
}

//* autofill
//* platform
//* platform
//* autofill

process MultiQC {

publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /multiqc_report.html$/) "multiQC/$filename"}
input:
 path "fastqc/*"
 path "macs/*"
 path "rseqc_bowtie/*"
 path "bowtie/*"
 path "after_adapter_removal/*"

output:
 path "multiqc_report.html" ,optional:true  ,emit:g_70_outputHTML00 

errorStrategy 'ignore'

script:
multiqc_parameters = params.MultiQC.multiqc_parameters
"""
multiqc ${multiqc_parameters} -e general_stats -d -dd 2 .
"""

}


process ChIP_Module_bed_merge {

input:
 path bed
 path genomeSizes

output:
 path "merged.bed"  ,emit:g87_11_bed01_g87_12 

container "quay.io/biocontainers/bedtools:2.31.1--h13024bc_3"

script:

"""
cat ${bed} \
| cut -f -6 \
| bedtools sort -i stdin \
| bedtools slop -i stdin -b 100 -g ${genomeSizes} \
| bedtools merge -i stdin \
| awk '{print \$0"\t"\$1"_"\$2"_"\$3}' > merged.bed
"""
}



process ChIP_Module_bedtools_coverage {

publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /.*.sum.txt$/) "chip/$filename"}
input:
 val compare_bed
 path bed
 tuple val(name), file(bam)

output:
 path "*.sum.txt"  ,emit:g87_12_outputFileTxt00_g87_13 

script:
bedtoolsCoverage_Parameters = params.ChIP_Module_bedtools_coverage.bedtoolsCoverage_Parameters
bedtoolsIntersect_Parameters = params.ChIP_Module_bedtools_coverage.bedtoolsIntersect_Parameters
"""
echo ${compare_bed}
if [ -s "${compare_bed}" ]; then 
    echo " bed file exists and is not empty "
        samtools view -H ${name}.bam | grep -P "@SQ\\tSN:" | sed 's/@SQ\\tSN://' | sed 's/\\tLN:/\\t/' > ${name}_chroms
        samtools sort -T ${name} -o ${name}_sorted.bam ${name}.bam
        bedtools intersect -abam ${name}_sorted.bam -b ${compare_bed} > temp_${name}.bam
        bedtools sort -faidx ${name}_chroms -i ${compare_bed}  | bedtools coverage ${bedtoolsCoverage_Parameters} -a stdin -b temp_${name}.bam  > temp_${name}.bed
        # 'The number of features in B that overlapped the A interval' multiplied by 'fraction of bases in A that had non-zero coverage from features in B'.
        awk '{\$NF=\$(NF-3)*\$NF;print }' OFS="\\t" temp_${name}.bed | grep -v all > temp_${name}_hist.bed
        l=`awk '{print NF}' temp_${name}_hist.bed | head -1 | awk '{print \$1-4}'`
        k=`awk '{print NF}' temp_${name}_hist.bed | head -1`
        bedtools groupby -i temp_${name}_hist.bed -g 1-\$l -c \$k -o sum > ${name}.sum.txt
        #rm -rf temp_*

else
  echo " bed file does not exist, or is empty "
  touch ${name}_empty.sum.txt
fi
"""

}


process ChIP_Module_ATAC_CHIP_summary {

publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /.*.tsv$/) "chip_summary/$filename"}
input:
 path file

output:
 path "*.tsv"  ,emit:g87_13_outputFile00 

script:
'''
#!/usr/bin/env perl

my $indir = $ENV{'PWD'};

opendir D, $indir or die "Could not open $indir\n";
my @alndirs = sort { $a cmp $b } grep /.txt/, readdir(D);
closedir D;
    
my @a=();
my %b=();
my %c=();
my $i=0;
foreach my $d (@alndirs){ 
    my $file = "${indir}/$d";
    print $d."\n";
    my $libname=$d;
    $libname=~s/\\.sum\\.txt//;
    print $libname."\n";
    $i++;
    $a[$i]=$libname;
    open IN,"${indir}/$d";
    $_=<IN>;
    while(<IN>)
    {
        my @v=split; 
        $b{$v[3]}{$i}=$v[4];
    }
    close IN;
}
my $outfile="${indir}/"."sum_counts.tsv";
open OUT, ">$outfile";
print OUT "Feature";

for(my $j=1;$j<=$i;$j++) {
    print OUT "\t$a[$j]";
}
print OUT "\n";
    
foreach my $key (keys %b){
    print OUT "$key";
    for(my $j=1;$j<=$i;$j++){
        print OUT "\t$b{$key}{$j}";
    }
    print OUT "\n";
}
close OUT;
'''
}


process HOMER_Module_HOMER_Annotate_Peaks {

publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /${name}_annotated_peaks.txt$/) "annotated_peaks/$filename"}
input:
 tuple val(name), file(bed_file)
 path homerdb

output:
 path "${name}_annotated_peaks.txt"  ,emit:g95_2_inputFileTxt02_g_99 

container "quay.io/ummsbiocore/homer:5.1"
stageInMode = 'copy'

when:
params.run_HOMER == "yes"

script:
def db = params.genome_build.split("_")[1]

"""
export HOMER_DATA=/opt/homerdata
mkdir -p /opt/homerdata/data
cp -R /opt/knownTFs /opt/homerdata/data/.
cp homerdb/config.txt /opt/homerdata/config.txt

for db_t in \$(ls homerdb/*.tar); do 
    tar -xf \${db_t}
    db_n=\$(basename \${db_t} | sed 's/.tar//g')
    mv  \$db_n /opt/homerdata/data
done

# Run annotation
annotatePeaks.pl ${bed_file} ${db} | tee ${name}_annotated_peaks.txt
"""

}


process HOMER_Module_HOMER_Motif_Finder {

publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /${name}_motifs$/) "motifs/$filename"}
input:
 path homerdb
 tuple val(name), file(bed_file)

output:
 path "${name}_motifs"  ,emit:g95_5_outputDir01_g_99 

stageInMode = 'copy'
container "quay.io/ummsbiocore/homer:5.1"


when:
params.run_HOMER == "yes"

script:

db = params.genome_build.split("_")[1]

//def name_n = new File(name.toString()).getName().split('\\.')[0]

motif_length = params.HOMER_Module_HOMER_Motif_Finder.motif_length
motif_size = params.HOMER_Module_HOMER_Motif_Finder.motif_size
motif_opti = params.HOMER_Module_HOMER_Motif_Finder.motif_opti
mismatches = params.HOMER_Module_HOMER_Motif_Finder.mismatches

rna_check = params.HOMER_Module_HOMER_Motif_Finder.rna_check
rna = ( rna_check == "true" ) ? "-rna" : ""
norevopp_check = params.HOMER_Module_HOMER_Motif_Finder.norevopp_check
norevopp = ( norevopp_check == "true" ) ? "-norevopp" : ""
nomotif_check = params.HOMER_Module_HOMER_Motif_Finder.nomotif_check
nomotif = ( nomotif_check == "true" ) ? "-nomotif" : ""
noknown_check = params.HOMER_Module_HOMER_Motif_Finder.noknown_check
noknown = ( noknown_check == "true" ) ? "-noknown" : ""

//* @style @condition:{rna_check="false", norevopp_check},{rna_check="true"} @multicolumn:{rna_check, norevopp_check, nomotif_check, noknown_check}

"""
export HOMER_DATA=/opt/homerdata
mkdir -p /opt/homerdata/data
cp -R /opt/knownTFs /opt/homerdata/data/.
cp homerdb/config.txt /opt/homerdata/config.txt

for db_t in \$(ls homerdb/*.tar); do 
    tar -xf \${db_t}
    db_n=\$(basename \${db_t} | sed 's/.tar//g')
    mv \$db_n /opt/homerdata/data
done

findMotifsGenome.pl ${bed_file} ${db} ${name}_motifs/ \
-len ${motif_length} -size ${motif_size} \
-S ${motif_opti} -mis ${mismatches} \
${norevopp} \
${nomotif} \
${noknown} \
"""

}

//* autofill
if ($HOSTNAME == "default"){
    $CPU  = 10
    $MEMORY = 40
}
//* autofill

process deepTools_Plot_Heatmap_deepTools_CreateMatrix {

input:
 tuple val(name), file(bigwig_file)
 path bed_file

output:
 tuple val(name), file("${name}_matrix.gz")  ,emit:g107_2_zipped_file00_g107_1 

container "quay.io/biocontainers/deeptools:3.5.6--pyhdfd78af_0"

when:

params.run_dtHeatmap == "yes"

script:

startLabel = params.deepTools_Plot_Heatmap_deepTools_CreateMatrix.startLabel
endLabel = params.deepTools_Plot_Heatmap_deepTools_CreateMatrix.endLabel
binsize = params.deepTools_Plot_Heatmap_deepTools_CreateMatrix.binsize
brsl = params.deepTools_Plot_Heatmap_deepTools_CreateMatrix.brsl
rbl = params.deepTools_Plot_Heatmap_deepTools_CreateMatrix.rbl
arsl = params.deepTools_Plot_Heatmap_deepTools_CreateMatrix.arsl

"""
computeMatrix scale-regions -S ${bigwig_file} -R ${bed_file} \
--outFileName ${name}_matrix.gz \
--beforeRegionStartLength ${brsl} \
--regionBodyLength ${rbl} \
--afterRegionStartLength ${arsl} \
--binSize ${binsize} \
--skipZeros --missingDataAsZero \
--startLabel ${startLabel} \
--endLabel ${endLabel} \
-p ${task.cpus}
"""

}


process deepTools_Plot_Heatmap_deepTools_PlotHeatmap {

input:
 tuple val(name), file(matrix_gz)

output:
 path "*_heatmap.*"  ,emit:g107_1_png07_g_99 

container "quay.io/biocontainers/deeptools:3.5.6--pyhdfd78af_0"

script:

plottitle = params.deepTools_Plot_Heatmap_deepTools_PlotHeatmap.plottitle
plottitleText = plottitle ? "--plotTitle ${plottitle}" : ""
sortregions = params.deepTools_Plot_Heatmap_deepTools_PlotHeatmap.sortregions
alpha = params.deepTools_Plot_Heatmap_deepTools_PlotHeatmap.alpha
heatmapwidth = params.deepTools_Plot_Heatmap_deepTools_PlotHeatmap.heatmapwidth
heatmapheight = params.deepTools_Plot_Heatmap_deepTools_PlotHeatmap.heatmapheight
dpi = params.deepTools_Plot_Heatmap_deepTools_PlotHeatmap.dpi
plottype = params.deepTools_Plot_Heatmap_deepTools_PlotHeatmap.plottype
plotff = params.deepTools_Plot_Heatmap_deepTools_PlotHeatmap.plotff

"""
plotHeatmap -m ${matrix_gz} --outFileName ${name}_heatmap.${plotff} \
--plotType ${plottype} \
--sortRegions ${sortregions} \
--heatmapWidth ${heatmapwidth} \
--heatmapHeight ${heatmapheight} \
--alpha ${alpha} \
--dpi ${dpi} \
${plottitleText} \
--plotFileFormat ${plotff}
"""

}


process ChIP_seq_Reporting {

publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /.*.html$/) "ChIP_Report/$filename"}
input:
 path qc, stageAs: "report/qc/*"
 path motifs, stageAs: "report/homer_motifs/*"
 path ann_peaks, stageAs: "report/annotated_peaks/*"
 path bigwig, stageAs: "report/bigwig/*"
 path chip, stageAs: "report/bed/*"
 path qc_a, stageAs: "report/qc_a/*"
 path bam, stageAs: "report/bam_file/*"
 path heatmap
 path poweredby_logo, stageAs: "poweredby_logo.png"
 path company_logo, stageAs: "company_logo.png"
 path report_institute_css
 path overall_summary, stageAs: "report/summary/*"

output:
 path "*.html"  ,emit:g_99_outputFileHTML00 

container "quay.io/ummsbiocore/chip-atac-report:1.0"

when:
!params.create_report || params.create_report == "yes"

script:

pipeline = params.pipe_name

"""
mkdir -p report/images/ report/bigwig

if [[ ${pipeline} == 'ChIP' ]]; then
    reporting_r='ChIPseq_Reporting.R'
    reporting_rmd='ChIPseq_Reporting.Rmd'
elif [[ ${pipeline} == 'ATAC' ]]; then
    reporting_r='atacseq_reporting.r'
    reporting_rmd='atacseq_reporting.rmd'
fi

path=\$(which \${reporting_rmd}) && cp \$path report/.
path=\$(which \${reporting_r}) && cp \$path .

cp ${company_logo} report/images/mainlogo.png
cp ${poweredby_logo} report/images/vslogo.png
cp ${heatmap} report/bigwig/

cp ${report_institute_css} 'report/style.css'

for file in report/bed/*_peaks*; do
    base="\${file##*/}" # strip directory
    name="\${base%%_peaks*}"  # strip from _peaks onward
    echo "INFO: Report generation started for sample: \$name"  

    peak_calling_type="\$(printf '%s' "\$base" | awk -F '.' '{print \$NF}' | sed 's/Peak\$//')"
    echo "INFO: sample=\$name  peak_calling_type=\$peak_calling_type"
    
    \${reporting_r} report/\${reporting_rmd} \${name} '${params.genome_build}' '${params.mate}' \${peak_calling_type} 'images/mainlogo.png' 'images/vslogo.png' 'TRUE' '${params.report_institute_web_page}' '${params.report_institute_email}' '${params.report_institute_name}' '${params.report_institute_message}' {{FOUNDRY_PIPELINE_ID}}
    mv report/${pipeline}-seq_Report_\${name}.html ${pipeline}-seq_Report_\${name}.html
done
"""
}


workflow {


if (!((params.run_Adapter_Removal && (params.run_Adapter_Removal == "yes")) || !params.run_Adapter_Removal)){
g_1_0_g71_18.set{g71_18_reads01_g71_31}
(g71_18_reads00_g71_23) = [g71_18_reads01_g71_31]
g71_18_log_file10_g71_11 = Channel.empty()
} else {

Adapter_Trimmer_Quality_Module_Adapter_Removal(g_1_0_g71_18,g_2_1_g71_18)
g71_18_reads01_g71_31 = Adapter_Trimmer_Quality_Module_Adapter_Removal.out.g71_18_reads01_g71_31
(g71_18_reads00_g71_23) = [g71_18_reads01_g71_31]
g71_18_log_file10_g71_11 = Adapter_Trimmer_Quality_Module_Adapter_Removal.out.g71_18_log_file10_g71_11
}


Adapter_Trimmer_Quality_Module_Adapter_Removal_Summary(g71_18_log_file10_g71_11.collect(),g_2_1_g71_11)
g71_11_outputFileTSV05_g_75 = Adapter_Trimmer_Quality_Module_Adapter_Removal_Summary.out.g71_11_outputFileTSV05_g_75
g71_11_outputFile11 = Adapter_Trimmer_Quality_Module_Adapter_Removal_Summary.out.g71_11_outputFile11


if (!(params.run_UMIextract == "yes")){
g71_18_reads00_g71_23.set{g71_23_reads00_g71_19}
g71_23_log_file10_g71_24 = Channel.empty()
} else {

Adapter_Trimmer_Quality_Module_UMIextract(g71_18_reads00_g71_23,g_2_1_g71_23)
g71_23_reads00_g71_19 = Adapter_Trimmer_Quality_Module_UMIextract.out.g71_23_reads00_g71_19
g71_23_log_file10_g71_24 = Adapter_Trimmer_Quality_Module_UMIextract.out.g71_23_log_file10_g71_24
}


if (!((params.run_Trimmer && (params.run_Trimmer == "yes")) || !params.run_Trimmer)){
g71_23_reads00_g71_19.set{g71_19_reads00_g71_20}
g71_19_log_file10_g71_21 = Channel.empty()
} else {

Adapter_Trimmer_Quality_Module_Trimmer(g71_23_reads00_g71_19,g_2_1_g71_19)
g71_19_reads00_g71_20 = Adapter_Trimmer_Quality_Module_Trimmer.out.g71_19_reads00_g71_20
g71_19_log_file10_g71_21 = Adapter_Trimmer_Quality_Module_Trimmer.out.g71_19_log_file10_g71_21
}


Adapter_Trimmer_Quality_Module_Trimmer_Removal_Summary(g71_19_log_file10_g71_21.collect(),g_2_1_g71_21)
g71_21_outputFileTSV06_g_75 = Adapter_Trimmer_Quality_Module_Trimmer_Removal_Summary.out.g71_21_outputFileTSV06_g_75


if (!((params.run_Quality_Filtering && (params.run_Quality_Filtering == "yes")) || !params.run_Quality_Filtering)){
g71_19_reads00_g71_20.set{g71_20_reads00_g72_46}
g71_20_log_file10_g71_16 = Channel.empty()
} else {

Adapter_Trimmer_Quality_Module_Quality_Filtering(g71_19_reads00_g71_20,g_2_1_g71_20)
g71_20_reads00_g72_46 = Adapter_Trimmer_Quality_Module_Quality_Filtering.out.g71_20_reads00_g72_46
g71_20_log_file10_g71_16 = Adapter_Trimmer_Quality_Module_Quality_Filtering.out.g71_20_log_file10_g71_16
}


Adapter_Trimmer_Quality_Module_Quality_Filtering_Summary(g71_20_log_file10_g71_16.collect(),g_2_1_g71_16)
g71_16_outputFileTSV07_g_75 = Adapter_Trimmer_Quality_Module_Quality_Filtering_Summary.out.g71_16_outputFileTSV07_g_75


Adapter_Trimmer_Quality_Module_Umitools_Summary(g71_23_log_file10_g71_24.collect(),g_2_1_g71_24)
g71_24_outputFileTSV00 = Adapter_Trimmer_Quality_Module_Umitools_Summary.out.g71_24_outputFileTSV00


Adapter_Trimmer_Quality_Module_FastQC(g_2_0_g71_28,g_1_1_g71_28)
g71_28_FastQCout04_g_70 = Adapter_Trimmer_Quality_Module_FastQC.out.g71_28_FastQCout04_g_70
(g71_28_FastQCout00_g_99) = [g71_28_FastQCout04_g_70]


Adapter_Trimmer_Quality_Module_FastQC_after_Adapter_Removal(g_2_0_g71_31,g71_18_reads01_g71_31)
g71_31_FastQCout015_g_70 = Adapter_Trimmer_Quality_Module_FastQC_after_Adapter_Removal.out.g71_31_FastQCout015_g_70
(g71_31_FastQCout05_g_99) = [g71_31_FastQCout015_g_70]


Check_and_Build_Module_Check_Genome_GTF()
g78_21_genome00_g78_58 = Check_and_Build_Module_Check_Genome_GTF.out.g78_21_genome00_g78_58
g78_21_gtfFile10_g78_57 = Check_and_Build_Module_Check_Genome_GTF.out.g78_21_gtfFile10_g78_57


if (!(params.replace_geneID_with_geneName == "yes")){
g78_21_gtfFile10_g78_57.set{g78_57_gtfFile01_g78_58}
} else {

Check_and_Build_Module_convert_gtf_attributes(g78_21_gtfFile10_g78_57)
g78_57_gtfFile01_g78_58 = Check_and_Build_Module_convert_gtf_attributes.out.g78_57_gtfFile01_g78_58
}



if (!(params.add_sequences_to_reference == "yes")){
g78_21_genome00_g78_58.set{g78_58_genome00_g78_52}
(g78_58_genome01_g78_54) = [g78_58_genome00_g78_52]
g78_57_gtfFile01_g78_58.set{g78_58_gtfFile10_g78_53}
(g78_58_gtfFile10_g78_54) = [g78_58_gtfFile10_g78_53]
} else {

Check_and_Build_Module_Add_custom_seq_to_genome_gtf(g78_21_genome00_g78_58,g78_57_gtfFile01_g78_58,g_86_2_g78_58)
g78_58_genome00_g78_52 = Check_and_Build_Module_Add_custom_seq_to_genome_gtf.out.g78_58_genome00_g78_52
(g78_58_genome01_g78_54) = [g78_58_genome00_g78_52]
g78_58_gtfFile10_g78_53 = Check_and_Build_Module_Add_custom_seq_to_genome_gtf.out.g78_58_gtfFile10_g78_53
(g78_58_gtfFile10_g78_54) = [g78_58_gtfFile10_g78_53]
}


Check_and_Build_Module_Check_BED12(g78_58_gtfFile10_g78_53)
g78_53_bed03_g78_54 = Check_and_Build_Module_Check_BED12.out.g78_53_bed03_g78_54


Check_and_Build_Module_Check_chrom_sizes_and_index(g78_58_genome00_g78_52)
g78_52_genomeSizes02_g78_54 = Check_and_Build_Module_Check_chrom_sizes_and_index.out.g78_52_genomeSizes02_g78_54

g78_58_gtfFile10_g78_54= g78_58_gtfFile10_g78_54.ifEmpty(ch_empty_file_1) 
g78_58_genome01_g78_54= g78_58_genome01_g78_54.ifEmpty(ch_empty_file_2) 
g78_52_genomeSizes02_g78_54= g78_52_genomeSizes02_g78_54.ifEmpty(ch_empty_file_3) 
g78_53_bed03_g78_54= g78_53_bed03_g78_54.ifEmpty(ch_empty_file_4) 


Check_and_Build_Module_check_files(g78_58_gtfFile10_g78_54,g78_58_genome01_g78_54,g78_52_genomeSizes02_g78_54,g78_53_bed03_g78_54)
g78_54_gtfFile01_g72_47 = Check_and_Build_Module_check_files.out.g78_54_gtfFile01_g72_47
g78_54_genome10_g72_47 = Check_and_Build_Module_check_files.out.g78_54_genome10_g72_47
(g78_54_genome10_g73_17) = [g78_54_genome10_g72_47]
g78_54_genomeSizes22_g74_131 = Check_and_Build_Module_check_files.out.g78_54_genomeSizes22_g74_131
(g78_54_genomeSizes21_g74_142,g78_54_genomeSizes21_g87_11) = [g78_54_genomeSizes22_g74_131,g78_54_genomeSizes22_g74_131]
g78_54_bed31_g74_134 = Check_and_Build_Module_check_files.out.g78_54_bed31_g74_134
(g78_54_bed31_g107_2) = [g78_54_bed31_g74_134]


Bowtie2_Module_Check_Build_Bowtie2_Index(g78_54_genome10_g73_17)
g73_17_bowtie2index00_g73_14 = Bowtie2_Module_Check_Build_Bowtie2_Index.out.g73_17_bowtie2index00_g73_14

g73_17_bowtie2index00_g73_14= g73_17_bowtie2index00_g73_14.ifEmpty(ch_empty_file_1) 


if (!((params.run_Bowtie2 && (params.run_Bowtie2 == "yes")) || !params.run_Bowtie2)){
g73_17_bowtie2index00_g73_14.set{g73_14_bowtie2index02_g73_3}
} else {

Bowtie2_Module_check_Bowtie2_files(g73_17_bowtie2index00_g73_14)
g73_14_bowtie2index02_g73_3 = Bowtie2_Module_check_Bowtie2_files.out.g73_14_bowtie2index02_g73_3
}


Sequential_Mapping_Module_Download_build_sequential_mapping_indexes(g78_54_genome10_g72_47,g78_54_gtfFile01_g72_47)
g72_47_commondb00_g72_43 = Sequential_Mapping_Module_Download_build_sequential_mapping_indexes.out.g72_47_commondb00_g72_43
g72_47_bowtieIndex11_g72_43 = Sequential_Mapping_Module_Download_build_sequential_mapping_indexes.out.g72_47_bowtieIndex11_g72_43
g72_47_bowtie2index22_g72_43 = Sequential_Mapping_Module_Download_build_sequential_mapping_indexes.out.g72_47_bowtie2index22_g72_43
g72_47_starIndex33_g72_43 = Sequential_Mapping_Module_Download_build_sequential_mapping_indexes.out.g72_47_starIndex33_g72_43

g72_47_commondb00_g72_43= g72_47_commondb00_g72_43.ifEmpty(ch_empty_file_1) 
g72_47_bowtieIndex11_g72_43= g72_47_bowtieIndex11_g72_43.ifEmpty(ch_empty_file_2) 
g72_47_bowtie2index22_g72_43= g72_47_bowtie2index22_g72_43.ifEmpty(ch_empty_file_3) 
g72_47_starIndex33_g72_43= g72_47_starIndex33_g72_43.ifEmpty(ch_empty_file_4) 


if (!(params.run_Sequential_Mapping  == "yes")){
g72_47_commondb00_g72_43.set{g72_43_commondb05_g72_44}
(g72_43_commondb05_g72_45,g72_43_commondb02_g72_46) = [g72_43_commondb05_g72_44,g72_43_commondb05_g72_44]
g72_47_bowtieIndex11_g72_43.set{g72_43_bowtieIndex12_g72_44}
(g72_43_bowtieIndex12_g72_45,g72_43_bowtieIndex13_g72_46) = [g72_43_bowtieIndex12_g72_44,g72_43_bowtieIndex12_g72_44]
g72_47_bowtie2index22_g72_43.set{g72_43_bowtie2index23_g72_44}
(g72_43_bowtie2index23_g72_45,g72_43_bowtie2index24_g72_46) = [g72_43_bowtie2index23_g72_44,g72_43_bowtie2index23_g72_44]
g72_47_starIndex33_g72_43.set{g72_43_starIndex34_g72_44}
(g72_43_starIndex34_g72_45,g72_43_starIndex35_g72_46) = [g72_43_starIndex34_g72_44,g72_43_starIndex34_g72_44]
} else {

Sequential_Mapping_Module_Check_Sequential_Mapping_Indexes(g72_47_commondb00_g72_43,g72_47_bowtieIndex11_g72_43,g72_47_bowtie2index22_g72_43,g72_47_starIndex33_g72_43)
g72_43_commondb05_g72_44 = Sequential_Mapping_Module_Check_Sequential_Mapping_Indexes.out.g72_43_commondb05_g72_44
(g72_43_commondb05_g72_45,g72_43_commondb02_g72_46) = [g72_43_commondb05_g72_44,g72_43_commondb05_g72_44]
g72_43_bowtieIndex12_g72_44 = Sequential_Mapping_Module_Check_Sequential_Mapping_Indexes.out.g72_43_bowtieIndex12_g72_44
(g72_43_bowtieIndex12_g72_45,g72_43_bowtieIndex13_g72_46) = [g72_43_bowtieIndex12_g72_44,g72_43_bowtieIndex12_g72_44]
g72_43_bowtie2index23_g72_44 = Sequential_Mapping_Module_Check_Sequential_Mapping_Indexes.out.g72_43_bowtie2index23_g72_44
(g72_43_bowtie2index23_g72_45,g72_43_bowtie2index24_g72_46) = [g72_43_bowtie2index23_g72_44,g72_43_bowtie2index23_g72_44]
g72_43_starIndex34_g72_44 = Sequential_Mapping_Module_Check_Sequential_Mapping_Indexes.out.g72_43_starIndex34_g72_44
(g72_43_starIndex34_g72_45,g72_43_starIndex35_g72_46) = [g72_43_starIndex34_g72_44,g72_43_starIndex34_g72_44]
}

g72_43_commondb02_g72_46= g72_43_commondb02_g72_46.ifEmpty(ch_empty_file_1) 
g72_43_bowtieIndex13_g72_46= g72_43_bowtieIndex13_g72_46.ifEmpty(ch_empty_file_2) 
g72_43_bowtie2index24_g72_46= g72_43_bowtie2index24_g72_46.ifEmpty(ch_empty_file_3) 
g72_43_starIndex35_g72_46= g72_43_starIndex35_g72_46.ifEmpty(ch_empty_file_4) 


if (!(params.run_Sequential_Mapping == "yes")){
g71_20_reads00_g72_46.set{g72_46_reads00_g73_3}
g72_46_bowfiles10_g72_26 = Channel.empty()
g72_46_bam_file20_g72_44 = Channel.empty()
g72_46_bam_file50_g72_45 = Channel.empty()
g72_46_bam_index31_g72_44 = Channel.empty()
g72_46_bam_index61_g72_45 = Channel.empty()
g72_46_filter42_g72_26 = Channel.empty()
g72_46_log_file70_g72_30 = Channel.empty()
g72_46_bigWig_file88 = Channel.empty()
} else {

Sequential_Mapping_Module_Sequential_Mapping(g71_20_reads00_g72_46,g_2_1_g72_46,g72_43_commondb02_g72_46,g72_43_bowtieIndex13_g72_46,g72_43_bowtie2index24_g72_46,g72_43_starIndex35_g72_46)
g72_46_reads00_g73_3 = Sequential_Mapping_Module_Sequential_Mapping.out.g72_46_reads00_g73_3
g72_46_bowfiles10_g72_26 = Sequential_Mapping_Module_Sequential_Mapping.out.g72_46_bowfiles10_g72_26
g72_46_bam_file20_g72_44 = Sequential_Mapping_Module_Sequential_Mapping.out.g72_46_bam_file20_g72_44
g72_46_bam_index31_g72_44 = Sequential_Mapping_Module_Sequential_Mapping.out.g72_46_bam_index31_g72_44
g72_46_filter42_g72_26 = Sequential_Mapping_Module_Sequential_Mapping.out.g72_46_filter42_g72_26
g72_46_bam_file50_g72_45 = Sequential_Mapping_Module_Sequential_Mapping.out.g72_46_bam_file50_g72_45
g72_46_bam_index61_g72_45 = Sequential_Mapping_Module_Sequential_Mapping.out.g72_46_bam_index61_g72_45
g72_46_log_file70_g72_30 = Sequential_Mapping_Module_Sequential_Mapping.out.g72_46_log_file70_g72_30
g72_46_bigWig_file88 = Sequential_Mapping_Module_Sequential_Mapping.out.g72_46_bigWig_file88
}


Sequential_Mapping_Module_Deduplication_Summary(g72_46_log_file70_g72_30.collect(),g_2_1_g72_30)
g72_30_outputFileTSV00 = Sequential_Mapping_Module_Deduplication_Summary.out.g72_30_outputFileTSV00


Sequential_Mapping_Module_Sequential_Mapping_Summary(g72_46_bowfiles10_g72_26,g_2_1_g72_26,g72_46_filter42_g72_26)
g72_26_outputFileTSV00_g72_13 = Sequential_Mapping_Module_Sequential_Mapping_Summary.out.g72_26_outputFileTSV00_g72_13
g72_26_name11_g72_13 = Sequential_Mapping_Module_Sequential_Mapping_Summary.out.g72_26_name11_g72_13


Sequential_Mapping_Module_Merge_TSV_Files(g72_26_outputFileTSV00_g72_13.collect(),g72_26_name11_g72_13.collect())
g72_13_outputFileTSV00_g72_14 = Sequential_Mapping_Module_Merge_TSV_Files.out.g72_13_outputFileTSV00_g72_14


Sequential_Mapping_Module_Sequential_Mapping_Short_Summary(g72_13_outputFileTSV00_g72_14)
g72_14_outputFileTSV01_g_75 = Sequential_Mapping_Module_Sequential_Mapping_Short_Summary.out.g72_14_outputFileTSV01_g_75
g72_14_outputFile11 = Sequential_Mapping_Module_Sequential_Mapping_Short_Summary.out.g72_14_outputFile11


Bowtie2_Module_Map_Bowtie2(g72_46_reads00_g73_3,g_2_1_g73_3,g73_14_bowtie2index02_g73_3)
g73_3_bowfiles00_g73_10 = Bowtie2_Module_Map_Bowtie2.out.g73_3_bowfiles00_g73_10
g73_3_unmapped_fastq11 = Bowtie2_Module_Map_Bowtie2.out.g73_3_unmapped_fastq11
g73_3_bam_file20_g73_4 = Bowtie2_Module_Map_Bowtie2.out.g73_3_bam_file20_g73_4
g73_3_bowfiles312_g_70 = Bowtie2_Module_Map_Bowtie2.out.g73_3_bowfiles312_g_70


Bowtie2_Module_Bowtie_Summary(g73_3_bowfiles00_g73_10.groupTuple(),g_2_1_g73_10)
g73_10_outputFileTSV00_g73_11 = Bowtie2_Module_Bowtie_Summary.out.g73_10_outputFileTSV00_g73_11
g73_10_name11_g73_11 = Bowtie2_Module_Bowtie_Summary.out.g73_10_name11_g73_11


Bowtie2_Module_Merge_TSV_Files(g73_10_outputFileTSV00_g73_11.collect(),g73_10_name11_g73_11.collect())
g73_11_outputFileTSV00_g_75 = Bowtie2_Module_Merge_TSV_Files.out.g73_11_outputFileTSV00_g_75

g73_11_outputFileTSV00_g_75= g73_11_outputFileTSV00_g_75.ifEmpty(ch_empty_file_1) 
g72_14_outputFileTSV01_g_75= g72_14_outputFileTSV01_g_75.ifEmpty(ch_empty_file_2) 
g71_11_outputFileTSV05_g_75= g71_11_outputFileTSV05_g_75.ifEmpty(ch_empty_file_3) 
g71_21_outputFileTSV06_g_75= g71_21_outputFileTSV06_g_75.ifEmpty(ch_empty_file_4) 
g71_16_outputFileTSV07_g_75= g71_16_outputFileTSV07_g_75.ifEmpty(ch_empty_file_5) 


Overall_Summary(g73_11_outputFileTSV00_g_75,g72_14_outputFileTSV01_g_75,g71_11_outputFileTSV05_g_75,g71_21_outputFileTSV06_g_75,g71_16_outputFileTSV07_g_75)
g_75_outputFileTSV011_g_99 = Overall_Summary.out.g_75_outputFileTSV011_g_99


Bowtie2_Module_Merge_Bam(g73_3_bam_file20_g73_4.groupTuple())
g73_4_merged_bams00 = Bowtie2_Module_Merge_Bam.out.g73_4_merged_bams00
g73_4_bam_index11 = Bowtie2_Module_Merge_Bam.out.g73_4_bam_index11
g73_4_sorted_bam20_g87_0 = Bowtie2_Module_Merge_Bam.out.g73_4_sorted_bam20_g87_0


Sequential_Mapping_Module_Sequential_Mapping_Bam_Dedup_count(g72_46_bam_file50_g72_45.collect(),g72_46_bam_index61_g72_45.collect(),g72_43_bowtieIndex12_g72_45,g72_43_bowtie2index23_g72_45,g72_43_starIndex34_g72_45,g72_43_commondb05_g72_45)
g72_45_outputFileTSV00 = Sequential_Mapping_Module_Sequential_Mapping_Bam_Dedup_count.out.g72_45_outputFileTSV00


Sequential_Mapping_Module_Sequential_Mapping_Bam_count(g72_46_bam_file20_g72_44.collect(),g72_46_bam_index31_g72_44.collect(),g72_43_bowtieIndex12_g72_44,g72_43_bowtie2index23_g72_44,g72_43_starIndex34_g72_44,g72_43_commondb05_g72_44)
g72_44_outputFileTSV00 = Sequential_Mapping_Module_Sequential_Mapping_Bam_count.out.g72_44_outputFileTSV00


if (!(params.run_Remove_Multimappers_with_Samtools == "yes")){
g73_4_sorted_bam20_g87_0.set{g87_0_mapped_reads00_g87_1}
} else {

ChIP_Module_Samtools_Remove_Multimappers(g73_4_sorted_bam20_g87_0)
g87_0_mapped_reads00_g87_1 = ChIP_Module_Samtools_Remove_Multimappers.out.g87_0_mapped_reads00_g87_1
}


if (!((params.run_Picard_MarkDuplicates && (params.run_Picard_MarkDuplicates == "yes")) || !params.run_Picard_MarkDuplicates)){
g87_0_mapped_reads00_g87_1.set{g87_1_mapped_reads01_g87_6}
g87_1_publish11 = Channel.empty()
g87_1_log_file22 = Channel.empty()
} else {

ChIP_Module_Picard_MarkDuplicates(g87_0_mapped_reads00_g87_1)
g87_1_mapped_reads01_g87_6 = ChIP_Module_Picard_MarkDuplicates.out.g87_1_mapped_reads01_g87_6
g87_1_publish11 = ChIP_Module_Picard_MarkDuplicates.out.g87_1_publish11
g87_1_log_file22 = ChIP_Module_Picard_MarkDuplicates.out.g87_1_log_file22
}


ChIP_Module_ChIP_Prep(g_2_0_g87_6,g87_1_mapped_reads01_g87_6)
g87_6_bam_file01_g87_9 = ChIP_Module_ChIP_Prep.out.g87_6_bam_file01_g87_9
g87_6_name12_g87_9 = ChIP_Module_ChIP_Prep.out.g87_6_name12_g87_9


ChIP_Module_ChIP_MACS3(g_2_0_g87_9,g87_6_bam_file01_g87_9.collect(),g87_6_name12_g87_9.unique().flatten())
g87_9_compare_bed00_g87_12 = ChIP_Module_ChIP_MACS3.out.g87_9_compare_bed00_g87_12
g87_9_bedFile10_g87_11 = ChIP_Module_ChIP_MACS3.out.g87_9_bedFile10_g87_11
(g87_9_bedFile14_g_99,g87_9_bedFile10_g95_2,g87_9_bedFile11_g95_5) = [g87_9_bedFile10_g87_11,g87_9_bedFile10_g87_11,g87_9_bedFile10_g87_11]
g87_9_bam_file22_g87_12 = ChIP_Module_ChIP_MACS3.out.g87_9_bam_file22_g87_12
(g87_9_bam_file26_g_99,g87_9_bam_file21_g74_131,g87_9_bam_file20_g74_142,g87_9_bam_file20_g74_134,g87_9_bam_file20_g74_121) = [g87_9_bam_file22_g87_12,g87_9_bam_file22_g87_12,g87_9_bam_file22_g87_12,g87_9_bam_file22_g87_12,g87_9_bam_file22_g87_12]
g87_9_resultsdir310_g_70 = ChIP_Module_ChIP_MACS3.out.g87_9_resultsdir310_g_70


BAM_Analysis_Module_Picard(g87_9_bam_file20_g74_121)
g74_121_outputFileOut00_g74_82 = BAM_Analysis_Module_Picard.out.g74_121_outputFileOut00_g74_82
g74_121_outputFilePdf12_g74_82 = BAM_Analysis_Module_Picard.out.g74_121_outputFilePdf12_g74_82


BAM_Analysis_Module_Picard_Summary(g74_121_outputFileOut00_g74_82.collect(),g_2_1_g74_82,g74_121_outputFilePdf12_g74_82.collect())
g74_82_outputFileTSV00 = BAM_Analysis_Module_Picard_Summary.out.g74_82_outputFileTSV00
g74_82_outputFilePdf11 = BAM_Analysis_Module_Picard_Summary.out.g74_82_outputFilePdf11


BAM_Analysis_Module_RSeQC(g87_9_bam_file20_g74_134,g78_54_bed31_g74_134)
g74_134_outputFileOut011_g_70 = BAM_Analysis_Module_RSeQC.out.g74_134_outputFileOut011_g_70


BAM_Analysis_Module_UCSC_BAM2BigWig_converter(g87_9_bam_file20_g74_142,g78_54_genomeSizes21_g74_142)
g74_142_bigWig_tuple00_g_109 = BAM_Analysis_Module_UCSC_BAM2BigWig_converter.out.g74_142_bigWig_tuple00_g_109
(g74_142_bigWig_tuple00_g107_2) = [g74_142_bigWig_tuple00_g_109]


tuple_to_file_for_bigwig(g74_142_bigWig_tuple00_g_109)
g_109_bigWig_file03_g_99 = tuple_to_file_for_bigwig.out.g_109_bigWig_file03_g_99


BAM_Analysis_Module_IGV_BAM2TDF_converter(g_2_0_g74_131,g87_9_bam_file21_g74_131,g78_54_genomeSizes22_g74_131)
g74_131_outputFileOut00 = BAM_Analysis_Module_IGV_BAM2TDF_converter.out.g74_131_outputFileOut00


MultiQC(g71_28_FastQCout04_g_70.flatten().toList(),g87_9_resultsdir310_g_70.flatten().toList(),g74_134_outputFileOut011_g_70.flatten().toList(),g73_3_bowfiles312_g_70.flatten().toList(),g71_31_FastQCout015_g_70.flatten().toList())
g_70_outputHTML00 = MultiQC.out.g_70_outputHTML00


ChIP_Module_bed_merge(g87_9_bedFile10_g87_11.collect{ file -> return file[1] }.collect(),g78_54_genomeSizes21_g87_11)
g87_11_bed01_g87_12 = ChIP_Module_bed_merge.out.g87_11_bed01_g87_12


ChIP_Module_bedtools_coverage(g87_9_compare_bed00_g87_12,g87_11_bed01_g87_12,g87_9_bam_file22_g87_12)
g87_12_outputFileTxt00_g87_13 = ChIP_Module_bedtools_coverage.out.g87_12_outputFileTxt00_g87_13


ChIP_Module_ATAC_CHIP_summary(g87_12_outputFileTxt00_g87_13.collect())
g87_13_outputFile00 = ChIP_Module_ATAC_CHIP_summary.out.g87_13_outputFile00


HOMER_Module_HOMER_Annotate_Peaks(g87_9_bedFile10_g95_2,g_96_1_g95_2)
g95_2_inputFileTxt02_g_99 = HOMER_Module_HOMER_Annotate_Peaks.out.g95_2_inputFileTxt02_g_99


HOMER_Module_HOMER_Motif_Finder(g_96_0_g95_5,g87_9_bedFile11_g95_5)
g95_5_outputDir01_g_99 = HOMER_Module_HOMER_Motif_Finder.out.g95_5_outputDir01_g_99


deepTools_Plot_Heatmap_deepTools_CreateMatrix(g74_142_bigWig_tuple00_g107_2,g78_54_bed31_g107_2)
g107_2_zipped_file00_g107_1 = deepTools_Plot_Heatmap_deepTools_CreateMatrix.out.g107_2_zipped_file00_g107_1


deepTools_Plot_Heatmap_deepTools_PlotHeatmap(g107_2_zipped_file00_g107_1)
g107_1_png07_g_99 = deepTools_Plot_Heatmap_deepTools_PlotHeatmap.out.g107_1_png07_g_99

g71_28_FastQCout00_g_99= g71_28_FastQCout00_g_99.ifEmpty(ch_empty_file_1) 
g95_5_outputDir01_g_99= g95_5_outputDir01_g_99.ifEmpty(ch_empty_file_2) 
g95_2_inputFileTxt02_g_99= g95_2_inputFileTxt02_g_99.ifEmpty(ch_empty_file_3) 
g_109_bigWig_file03_g_99= g_109_bigWig_file03_g_99.ifEmpty(ch_empty_file_4) 
g87_9_bedFile14_g_99= g87_9_bedFile14_g_99.ifEmpty(ch_empty_file_5) 
g71_31_FastQCout05_g_99= g71_31_FastQCout05_g_99.ifEmpty(ch_empty_file_6) 
g87_9_bam_file26_g_99= g87_9_bam_file26_g_99.ifEmpty(ch_empty_file_7) 
g107_1_png07_g_99= g107_1_png07_g_99.ifEmpty(ch_empty_file_8) 


ChIP_seq_Reporting(g71_28_FastQCout00_g_99.collect(),g95_5_outputDir01_g_99.collect(),g95_2_inputFileTxt02_g_99.collect(),g_109_bigWig_file03_g_99.collect(),g87_9_bedFile14_g_99.map{ file -> return file[1] }.collect(),g71_31_FastQCout05_g_99.collect(),g87_9_bam_file26_g_99.map{ file -> return file[1] }.collect(),g107_1_png07_g_99.collect(),g_102_8_g_99,g_103_9_g_99,g_108_10_g_99,g_75_outputFileTSV011_g_99)
g_99_outputFileHTML00 = ChIP_seq_Reporting.out.g_99_outputFileHTML00


}

workflow.onComplete {
println "##Pipeline execution summary##"
println "---------------------------"
println "##Completed at: $workflow.complete"
println "##Duration: ${workflow.duration}"
println "##Success: ${workflow.success ? 'OK' : 'failed' }"
println "##Exit status: ${workflow.exitStatus}"
}
