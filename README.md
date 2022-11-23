# Script Backup

## Motivação 

Esse projeto foi desenvolvido como prática/estudo de automação de tarefas em sistemas linux utilizando shell script e também a manipulação de comandos no terminal. 

## Descrição

O script pode receber algumas opções (consultar ./backup -h) e poderá gerar arquivos compactados para facilitar o processo de backup.

## Tecnologias 

- Linux 
- Shell script
- editor atom

![sh-badge](https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)
![linux-badge](https://img.shields.io/badge/Linux-E34F26?style=for-the-badge&logo=linux&logoColor=black)
![Atom](https://img.shields.io/badge/Atom-%2366595C.svg?style=for-the-badge&logo=atom&logoColor=white)

## Exemplo de uso 

```
./backup.sh -c zip -d ~/Documentos
```
Neste exemplo o script vai gerar um arquivo compactado do diretório Documentos utilizando o programa zip.

## Status do projeto 

![Badge em Desenvolvimento](https://img.shields.io/static/v1?label=STATUS&message=EM%20DESENVOLVIMENTO&color=GREEN&style=for-the-badge)

## Aprendizados 

Além do aprimoramento dos conhecimentos em lógica de programção (incluindo as boas práticas da linguagem shell script), o desenvolvimento desse projeto me possibilitou entender melhor como trabalhar com arquivos no linux: validar permissões, verificar a existência de arquivos e diretórios e especialmente como trabalhar como arquivos de configuração! 