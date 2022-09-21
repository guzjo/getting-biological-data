#!/usr/bin/env nextflow

params.ids = file('uniprot_ids.txt')

process splitIds {
  output:
  file 'chunk_*' into uniprots

  script:
  """
  split -l 1 ${params.ids} chunk_
  """
}

process getUniprot {
  input:
  file x from uniprots.flatten()

  output:
  file 'uniprot.fa' into seqs_ch

  shell:
  '''
  CONTENTS=$(cat !{x})
  URL='https://rest.uniprot.org/uniprotkb/'
  curl ${URL}${CONTENTS}.fasta > uniprot.fa
  '''
}

process gatherFasta {
  input:
  file '*.fa' from seqs_ch.collect()

  output:
  file 'allseqs.fa' into gather_ch

  script:
  """
  cat *.fa >> allseqs.fa
  """

}

process runMuscle {
  conda '/home/josue/miniconda3/envs/msa'

  input:
  file z from gather_ch

  output:
  file 'output.fa' into align_ch

  script:
  """
  muscle -align ${z} -output output.fa
  """

}

align_ch.subscribe {it.copyTo("./")}
