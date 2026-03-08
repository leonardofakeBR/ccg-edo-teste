# Yu-Gi-Oh! Custom Cards - Registro de Evolução

Este repositório foi mantido como um espaço de teste e serve hoje como um registro histórico de como otimizamos a distribuição de cartas customizadas para o nosso servidor. A ideia aqui é arquivar o processo de aprendizado que tivemos com o uso do Git para gerenciar scripts de EDOPro.

### 📜 A Trajetória do Projeto

O método de atualização das nossas cartas passou por três fases principais:

1. **A Era do Google Drive:** Antigamente, os jogadores precisavam baixar o arquivo completo do EDOPro (com todas as cartas customizadas inclusas) manualmente a cada atualização. Era um processo demorado e pouco eficiente.
2. **Migração para o GitHub:** Tivemos a ideia de subir o EDOPro inteiro para o GitHub. Isso permitiu que as atualizações fossem feitas via `git clone` e `git pull`, facilitando a vida de quem já tinha o ambiente configurado, embora ainda lidássemos com arquivos pesados do client.
3. **Otimização por Expansão:** Com o tempo e a descoberta de funcionalidades que ainda não estavam documentadas, percebemos que não precisávamos do client inteiro no Git. Passamos a hospedar **apenas os nossos scripts e imagens**, configurando o arquivo de expansão do EDOPro para puxar os dados diretamente do repositório.

### 🚀 Repositório Oficial

Atualmente, todas as atualizações e o desenvolvimento ativo do projeto são mantidos pelo **KillerxG** no repositório oficial:

🔗 **[CCG-Brasil no GitHub](https://github.com/KillerxG/CCG-Brasil)**

---
*Este README foi gerado por IA.*
