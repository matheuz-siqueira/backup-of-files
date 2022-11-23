#!/usr/bin/env bash
############################################################
# Script: backup.sh                                        #
# Descrição:                                               #
#           Script para realizar backup compactado de      #
#           diretórios/arquivos                            #
#                                                          #
# Autor: Matheus Siqueira (matheussiqueira.work@gmail.com) #
# Mantenedor: Matheus Siqueira                             #
#..........................................................#
# Exemplo de uso:                                          #
# ./backup.sh  -c zip -d $(pwd)                            #
#  Neste exemplo o programa vai compactar o diretório      #
#  atual utilizando o zip e vai gerar um arquivo com o     #
#  nome padrão                                             #
#......................................................... #
# O programa recebe como parâmetros o compactador desejado #
# e o diretório a ser compactado e então realiza a         #
# a compactação do diretório/arquivo                       #
#..........................................................#
# Testado em:                                              #
#        bash 5.1.16                                       #
#..........................................................#
# Histórico:                                               #
#         13/10/2022, Matheus                              #
#           - Criação do programa                          #
#         14/10/2022, Matheus                              #
#           - Adicionando diretório padrão                 #
#         16/10/2022, Matheus                              #
#           - Editando arquivo README.md                   # 
############################################################

#..............................VARIÁVEIS..............................#

FILE_CONFIG="config.cf"
DIR_BACKUP=
FLAG_DIR=0
SAVE_DIR_BACKUP=
SEP=:
VERSION="v1.0"
COMPACT=
DIR=
NAME_FILE=
MANUAL="
  Uso: $(basename $0) - [OPÇÕES]...
    -n - (opcional) especifica o nome do arquivo que será gerado
    -c - define o compactador que será utilizado [zip/tar]
    -d - especifica o diretório que será compactado
    -h - exibi o manual de uso
    -v - exibi a versão do programa
"
SUCCESS="\033[32m[SUCESSO]\033[0m - Compactação realizada com sucesso."
FAILURE="\033[31m[ERRO]\033[0m - Não foi possível compactar os arquivos."

# #..............................FUNÇÕES..............................#

validate_compactor(){
  local compactor="$1"
  [[ "$compactor" != "tar" && "$compactor" != "zip" ]] && echo "Erro. compactador não existe." && exit 1
}

validate_directory(){
  local dir="$1"
  [[ ! -d "$dir" ]] && echo "Erro. Diretório não existe." && exit 1
}

existing_file(){
  local file="$1"
  if [ -e "$file" ]
  then
    read -p "Existe um arquivo com este nome, deseja substituir? [y/n]" resp
    [[ "$resp" = "Y" || "$resp" = "y" ]] && rm "$file"
  fi
}

compressed_name_file(){
  local name="$1"

  if [[ "$COMPACTOR" = "tar" ]]
  then
     NAME_FILE="backup-$(date +%Y-%m-%d).tar.gz"
  else
    NAME_FILE="backup-$(date +%Y-%m-%d).zip"
  fi
}

set_parameters(){
  local parameters="$(echo "$1" | cut -d $SEP -f 1)"
  local value="$(echo "$1" | cut -d $SEP -f 2)"

  case $parameters in
    DIR_BACKUP)DIR_BACKUP="$value"            ;;
    SAVE_DIR_BACKUP)SAVE_DIR_BACKUP="$value"  ;;
  esac

}

make_directory_backup(){
  local value="$1"
  if [[ "$value" = "true" ]]
  then
    [[ ! -d "/home/$(whoami)/Backup" ]] && mkdir /home/$(whoami)/Backup && FLAG_DIR=1
    [[ -d "/home/$(whoami)/Backup" ]] && FLAG_DIR=1
  elif [[ "$value" = "false" ]]
  then
    [[ -d "/home/$(whoami)/Backup" ]] && FLAG_DIR=1
  fi
}

save_dir_backup(){
  local save="$1"
  local confirmation=$2

  if [[ "$save" = "true" && $confirmation -eq 1 ]]
  then
      find /home/$(whoami)/Backup/"$NAME_FILE" > /dev/null 2>&1
      if [[ $? -eq 0 ]]
      then
        read -p "Já existe um arquivo com este nome no diretório Backup, deseja substituir? [y/n]" resp
        case "$resp" in
          [yY]) rm /home/$(whoami)/Backup/"$NAME_FILE" && mv "$NAME_FILE" /home/$(whoami)/Backup
                output_result "$?"         ;;
           * ) exit 0                      ;;
        esac
      else
        mv "$NAME_FILE" /home/$(whoami)/Backup
        output_result "$?"
      fi
  fi
}

output_result () {
  local value=$1
  [[ $1 -eq 0 ]] && echo -e "$SUCCESS" || echo -e "$FAILURE"
}


# #..............................TESTES..............................#
while getopts "vhn:c:d:f" OPT
do
  case "$OPT" in
    "c") COMPACTOR="$OPTARG"                                                 ;;
    "d") DIR="$OPTARG"                                                       ;;
    "h") echo "$MANUAL" && exit 0                                            ;;
    "n") NAME_FILE="$OPTARG"                                                 ;;
    "v") echo "$VERSION" && exit 0                                           ;;
     *) echo "Opção inválida, verifique o manual com a opção -h."  && exit 1 ;;
 esac
done

[[ ! -x "$(which tar)" ]] && sudo apt install tar -y # tar instalado?
[[ ! -x "$(which zip)" ]] && sudo apt install zip -y # zip instalado?
[[ ! -x "$(which progress)" ]] && sudo apt install progress -y # progress instalado?

validate_compactor "$COMPACTOR" # o compactador informado existe?
validate_directory "$DIR" # o diretório que será compactado existe?
[ -z "$NAME_FILE" ] && compressed_name_file "$COMPACTOR"
existing_file "$NAME_FILE"

while read -r line
do
  [ "$(echo "$line" | cut -c1)" = "#" ] && continue
  [ ! "$line" ] && continue
  set_parameters "$line"
done < "$FILE_CONFIG"

make_directory_backup "$DIR_BACKUP"

# #..............................EXECUÇÃO..............................#

if [[ "$COMPACTOR" = "tar" ]]
then
  tar -czf $NAME_FILE $DIR | progress
  output_result "$?"
fi
if [[ "$COMPACTOR" = "zip" ]]
then
   zip -r -q $NAME_FILE $DIR| progress
   output_result "$?"
fi

[[ "$SAVE_DIR_BACKUP" = "true" && $FLAG_DIR -ne 1 ]] && echo "Erro. Não existe o diretório Backup!" && exit 1


save_dir_backup "$SAVE_DIR_BACKUP" "$FLAG_DIR"
