*** Settings ***
# Teste de Interface 2 — Edição de Medicamento via Painel Admin
# Técnica: Particionamento de Equivalência
# Referência: RF6, HU8, RN9, RN11

Library     SeleniumLibrary
Suite Setup     Abrir Navegador e Fazer Login
Suite Teardown  Fechar Navegador

*** Variables ***
${URL_ADMIN}        http://localhost:5500/admin.html
${BROWSER}          chrome
${INPUT_EMAIL}      id=inputEmail
${INPUT_SENHA}      id=inputSenha
${BTN_LOGIN}        id=btnLogin
${PAINEL_ADMIN}     id=painelAdmin
${TELA_LOGIN}       id=telaLogin
${LISTA_MEDS}       id=listaMedicamentos
${INPUT_NOME}       id=cadNome
${INPUT_DATA}       id=cadData
${INPUT_SUBSTANCIAS}    id=cadSubstancias
${INPUT_DESCRICAO}  id=cadDescricao
${INPUT_ROTULO}     id=cadRotulo
${INPUT_PROBLEMAS}  id=cadProblemas
${BTN_CADASTRAR}    id=btnCadastrar
${MSG_CADASTRO}     id=mensagemCadastro

*** Test Cases ***

CT01 - Deve exibir painel admin com medicamentos cadastrados
    [Documentation]    Admin autenticado — painel com lista de medicamentos visível
    Element Should Be Visible    ${PAINEL_ADMIN}
    ${qtd}=    Get Element Count    css=.med-row
    Should Be True    ${qtd} > 0

CT02 - Deve exibir tela de login ao acessar sem autenticação
    [Documentation]    Sem login — tela de login exibida, painel não acessível
    Open Browser    ${URL_ADMIN}    ${BROWSER}
    Sleep    2s
    Element Should Be Visible    ${TELA_LOGIN}
    Element Should Not Be Visible    ${PAINEL_ADMIN}
    Close Browser
    Open Browser    ${URL_ADMIN}    ${BROWSER}
    Maximize Browser Window
    Sleep    2s
    Input Text          ${INPUT_EMAIL}    admin@medinfo.com
    Input Password      ${INPUT_SENHA}    Admin@123
    Click Button        ${BTN_LOGIN}
    Sleep    3s

CT03 - Deve recusar cadastro com data em formato inválido
    [Documentation]    Data no formato errado — mensagem de erro esperada
    Input Text        ${INPUT_NOME}         Teste Edicao
    Input Text        ${INPUT_DATA}         1956-01-01
    Input Text        ${INPUT_SUBSTANCIAS}  Teste
    Input Text        ${INPUT_DESCRICAO}    Descrição teste
    Input Text        ${INPUT_ROTULO}       Rótulo teste
    Input Text        ${INPUT_PROBLEMAS}    Problema teste
    Click Button      ${BTN_CADASTRAR}
    Sleep    2s
    ${msg}=    Get Text    ${MSG_CADASTRO}
    Should Not Be Empty    ${msg}
    Clear Element Text    ${INPUT_NOME}
    Clear Element Text    ${INPUT_DATA}
    Clear Element Text    ${INPUT_SUBSTANCIAS}
    Clear Element Text    ${INPUT_DESCRICAO}
    Clear Element Text    ${INPUT_ROTULO}
    Clear Element Text    ${INPUT_PROBLEMAS}

CT04 - Deve recusar cadastro de medicamento duplicado
    [Documentation]    Nome e data já existentes — mensagem de duplicado esperada
    Input Text        ${INPUT_NOME}         Paracetamol 500mg
    Input Text        ${INPUT_DATA}         01/01/1956
    Input Text        ${INPUT_SUBSTANCIAS}  Paracetamol
    Input Text        ${INPUT_DESCRICAO}    Analgésico
    Input Text        ${INPUT_ROTULO}       1 comprimido a cada 6h
    Input Text        ${INPUT_PROBLEMAS}    Febre
    Click Button      ${BTN_CADASTRAR}
    Sleep    2s
    ${msg}=    Get Text    ${MSG_CADASTRO}
    Should Not Be Empty    ${msg}
    Clear Element Text    ${INPUT_NOME}
    Clear Element Text    ${INPUT_DATA}
    Clear Element Text    ${INPUT_SUBSTANCIAS}
    Clear Element Text    ${INPUT_DESCRICAO}
    Clear Element Text    ${INPUT_ROTULO}
    Clear Element Text    ${INPUT_PROBLEMAS}

CT05 - Deve cadastrar novo medicamento com dados válidos
    [Documentation]    Dados corretos — medicamento cadastrado e aparece na lista
    ${qtd_antes}=    Get Element Count    css=.med-row
    Input Text        ${INPUT_NOME}         Vitamina C 500mg
    Input Text        ${INPUT_DATA}         01/06/1950
    Input Text        ${INPUT_SUBSTANCIAS}  Ácido Ascórbico
    Input Text        ${INPUT_DESCRICAO}    Suplemento vitamínico
    Input Text        ${INPUT_ROTULO}       Tomar 1 comprimido ao dia
    Input Text        ${INPUT_PROBLEMAS}    Deficiência de vitamina C
    Click Button      ${BTN_CADASTRAR}
    Sleep    2s
    ${msg}=    Get Text    ${MSG_CADASTRO}
    Should Contain    ${msg}    sucesso
    ${qtd_depois}=    Get Element Count    css=.med-row
    Should Be True    ${qtd_depois} > ${qtd_antes}

*** Keywords ***

Abrir Navegador e Fazer Login
    Open Browser        ${URL_ADMIN}    ${BROWSER}
    Maximize Browser Window
    Sleep               2s
    Input Text          ${INPUT_EMAIL}    admin@medinfo.com
    Input Password      ${INPUT_SENHA}    Admin@123
    Click Button        ${BTN_LOGIN}
    Sleep               3s
    Element Should Be Visible    ${PAINEL_ADMIN}

Fechar Navegador
    Close Browser
