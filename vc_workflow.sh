cd projects/data/
fastqc -t 4 control.fq.gz  subject.fq.gz
trimmomatic SE -threads 4 subject.fq.gz suboutput.fq.gz ILLUMINACLIP:../ref/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:25
bwa index ../ref/ref.fa
bwa mem -t 4 ../ref/ref.fa suboutput.fq.gz > output_signal.sam
samtools view -S -b output_signal.sam > output_signal.bam
samtools sort -o output_signal.sorted.bam output_signal.bam
samtools flagstat output_signal.sorted.bam > output_signal.sorted.bam_flagstat
bcftools mpileup -O b -o output_signal.raw.bcf -f ../ref/ref.fa output_signal.sorted.bam
bcftools call --ploidy 1 -m -v -o  output_signal.variants.vcf output_signal.raw.bcf
trimmomatic SE -threads 4 control.fq.gz conoutput.fq.gz ILLUMINACLIP:../ref/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:25
bwa mem -t 4 ../ref/ref.fa conoutput.fq.gz > output_con.sam
samtools view -S -b output_con.sam > output_con.bam
samtools sort -o output_con.sorted.bam output_con.bam
samtools flagstat output_con.sorted.bam > output_con.sorted.bam_flagstat
bcftools mpileup -O b -o output_con.raw.bcf -f ../ref/ref.fa output_con.sorted.bam
bcftools call --ploidy 1 -m -v -o  output_con.variants.vcf output_con.raw.bcf
cp output_con.variants.vcf  output_signal.variants.vcf  ../programs/
cd ../programs/
echo "comparing Control_variant.vcf with Signal_variant.vcf "
python compare.py output_con.variants.vcf output_signal.variants.vcf
echo "comparing Signal_variant.vcf with Control_variant.vcf "

python compare.py output_signal.variants.vcf output_con.variants.vcf
