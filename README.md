# ViaCEP Flutter DIO
Projeto de consumo da API Via CEP em flutter - Bootcamp Santader DIO

## Requisitos:
<ol>
    <li>- [x] Criar uma aplicação Flutter​​​</li>
    <li>- [x] Criar uma classe de CEP no Back4App​​</li>
    <li>- [x] Consulte um Cep no ViaCep, após retornado se não existir no Back4App, realizar o cadastro​​</li>
    <li>- [x] Listar os CEPs cadastrados em forma de lista, possibilitando a alteração e exclusão do CEP​ ​</li>
</ol>

## Fluxograma:

```mermaid
graph LR
A((Inicio)) --> B[Home Page]
B -- Inserir CEP --> C{Consulta VIACEP}
C -- CEP válido --> D[Exibe o CEP na HOME]
C -- CEP inválido --> E[Trata Erros e informa usuário]
B -- Salvar CEP --> F{Verifica CEP}
F -- CEP Válido --> G[Salva/Edita CEP no Back4App]
F -- CEP Inválido ou já existe --> H[Trata erros e informa usuário]
B --> I[Lista endereços salvos]
I --> J[Editar um Endereço]
J --> F
I --> K[Excluir um Endereço]
K --> L{Verifica Dados}
L -- Dados válidos --> M[Exclui endereço no back4app]
L -- Dados inválidos --> N[Trata erros e informa usuário]
I -- Voltar --> B
```

### Minhas redes sociais, conecte-se comigo:
[![Perfil DIO](https://img.shields.io/badge/-Meu%20Perfil%20na%20DIO-30A3DC?style=for-the-badge)](https://www.dio.me/users/otavio_89908)

[![LinkedIn](https://img.shields.io/badge/-LinkedIn-000?style=for-the-badge&logo=linkedin&logoColor=30A3DC)](https://www.linkedin.com/in/ot%C3%A1vio-cunha-827560209/)

[![GitHub](https://img.shields.io/badge/-github-000?style=for-the-badge&logo=github&logoColor=30A3DC)](https://github.com/otaviotfcunha)

### Um pouco do meu GitHub:

![Top Langs](https://github-readme-stats-git-masterrstaa-rickstaa.vercel.app/api/top-langs/?username=otaviotfcunha&layout=compact&bg_color=000&border_color=30A3DC&title_color=FFF&text_color=FFF)

![GitHub Stats](https://github-readme-stats.vercel.app/api?username=otaviotfcunha&theme=transparent&bg_color=000&border_color=30A3DC&show_icons=true&icon_color=30A3DC&title_color=FFF&text_color=FFF)