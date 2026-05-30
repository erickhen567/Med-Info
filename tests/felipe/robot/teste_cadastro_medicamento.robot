*** Settings ***
# Teste de Interface 1 — Cadastro de Medicamento
# Técnica: Tabela de Decisão
# Referência: RF4, HU7, RN5, RN9, RN10

Library     SeleniumLibrary
Suite Setup     Abrir Navegador e Fazer Login
Suite Teardown  Fechar Navegador

*** Variables ***
${URL_ADMIN}            http://localhost:5500/admin.html
${BROWSER}              chrome
${INPUT_EMAIL}          id=inputEmail
${INPUT_SENHA}          id=inputSenha
${BTN_LOGIN}            id=btnLogin
${PAINEL_ADMIN}         id=painelAdmin
${INPUT_NOME}           id=cadNome
${INPUT_DATA}           id=cadData
${INPUT_SUBSTANCIAS}    id=cadSubstancias
${INPUT_CATEGORIA}      id=cadCategoria
${INPUT_TIPO}           id=cadTipo
${INPUT_PROBLEMAS}      id=cadProblemas
${INPUT_DESCRICAO}      id=cadDescricao
${INPUT_ROTULO}         id=cadRotulo
${BTN_CADASTRAR}        id=btnCadastrar
${MSG_CADASTRO}         id=mensagemCadastro

*** Test Cases ***

CT01 - Deve cadastrar medicamento com dados válidos
    Limpar Formulário
    Input Text        ${INPUT_NOME}         Ibuprofeno 400mg
    Input Text        ${INPUT_DATA}         10/05/1969
    Input Text        ${INPUT_SUBSTANCIAS}  Ibuprofeno
    Input Text        ${INPUT_CATEGORIA}    Anti-inflamatório
    Input Text        ${INPUT_TIPO}         genérico
    Input Text        ${INPUT_PROBLEMAS}    Inflamação, Dor, Febre
    Input Text        ${INPUT_DESCRICAO}    Anti-inflamatório não esteroidal
    Input Text        ${INPUT_ROTULO}       Tomar com alimentos
    Click Button      ${BTN_CADASTRAR}
    Sleep             2s
    ${msg}=    Get Text    ${MSG_CADASTRO}
    Should Contain    ${msg}    sucesso

CT02 - Deve validar campos obrigatórios ausentes
    Limpar Formulário
    Input Text        ${INPUT_NOME}         Ibuprofeno 400mg
    Input Text        ${INPUT_DATA}         10/05/1969
    Click Button      ${BTN_CADASTRAR}
    Sleep             2s
    ${msg}=    Get Text    ${MSG_CADASTRO}
    Should Not Be Empty    ${msg}

CT03 - Deve validar data em formato inválido
    Limpar Formulário
    Input Text        ${INPUT_NOME}         Ibuprofeno 400mg
    Input Text        ${INPUT_DATA}         1969-05-10
    Input Text        ${INPUT_SUBSTANCIAS}  Ibuprofeno
    Input Text        ${INPUT_DESCRICAO}    Anti-inflamatório
    Input Text        ${INPUT_ROTULO}       Tomar com alimentos
    Click Button      ${BTN_CADASTRAR}
    Sleep             2s
    ${msg}=    Get Text    ${MSG_CADASTRO}
    Should Not Be Empty    ${msg}

CT04 - Deve validar nome obrigatório
    Limpar Formulário
    Input Text        ${INPUT_DATA}         10/05/1969
    Input Text        ${INPUT_SUBSTANCIAS}  Ibuprofeno
    Input Text        ${INPUT_DESCRICAO}    Anti-inflamatório
    Input Text        ${INPUT_ROTULO}       Tomar com alimentos
    Click Button      ${BTN_CADASTRAR}
    Sleep             2s
    ${msg}=    Get Text    ${MSG_CADASTRO}
    Should Not Be Empty    ${msg}

CT05 - Deve validar medicamento duplicado
    Limpar Formulário
    Input Text        ${INPUT_NOME}         Paracetamol 500mg
    Input Text        ${INPUT_DATA}         01/01/1956
    Input Text        ${INPUT_SUBSTANCIAS}  Paracetamol
    Input Text        ${INPUT_DESCRICAO}    Analgésico e antipirético
    Input Text        ${INPUT_ROTULO}       1 comprimido a cada 6h
    Input Text        ${INPUT_PROBLEMAS}    Febre
    Click Button      ${BTN_CADASTRAR}
    Sleep             2s
    ${msg}=    Get Text    ${MSG_CADASTRO}
    Should Not Be Empty    ${msg}

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

Limpar Formulário
    Clear Element Text    ${INPUT_NOME}
    Clear Element Text    ${INPUT_DATA}
    Clear Element Text    ${INPUT_SUBSTANCIAS}
    Clear Element Text    ${INPUT_CATEGORIA}
    Clear Element Text    ${INPUT_TIPO}
    Clear Element Text    ${INPUT_PROBLEMAS}
    Clear Element Text    ${INPUT_DESCRICAO}
    Clear Element Text    ${INPUT_ROTULO}
    Sleep    0.5s

Fechar Navegador
    Close Browser
