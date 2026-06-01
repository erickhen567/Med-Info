*** Settings ***
# Teste de Interface 1 — Exclusão de Medicamento
# Técnica: Tabela de Decisão
# Referência: RF7, HU9, RN9

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

*** Test Cases ***

CT01 - Deve excluir medicamento ao confirmar
    [Documentation]    Admin logado confirma exclusão — removido com sucesso
    Element Should Be Visible    ${PAINEL_ADMIN}
    ${qtd_antes}=    Get Element Count    css=.med-row
    Should Be True    ${qtd_antes} > 0
    Click Element    css=.btn-excluir
    Sleep    1s
    Handle Alert    ACCEPT
    Sleep    2s
    ${qtd_depois}=    Get Element Count    css=.med-row
    Should Be True    ${qtd_depois} < ${qtd_antes}

CT02 - Deve exibir tela de login ao acessar sem autenticação
    [Documentation]    Sem login — tela de login deve ser exibida
    Open Browser    ${URL_ADMIN}    ${BROWSER}
    Sleep    2s
    Element Should Be Visible    ${TELA_LOGIN}
    Close Browser
    Open Browser    ${URL_ADMIN}    ${BROWSER}
    Maximize Browser Window
    Sleep    2s
    Input Text          ${INPUT_EMAIL}    admin@medinfo.com
    Input Password      ${INPUT_SENHA}    Admin@123
    Click Button        ${BTN_LOGIN}
    Sleep    3s

CT03 - Deve manter medicamento ao cancelar exclusão
    [Documentation]    Admin cancela exclusão — medicamento permanece na lista
    Element Should Be Visible    ${PAINEL_ADMIN}
    ${qtd_antes}=    Get Element Count    css=.med-row
    Click Element    css=.btn-excluir
    Sleep    1s
    Handle Alert    DISMISS
    Sleep    1s
    ${qtd_depois}=    Get Element Count    css=.med-row
    Should Be Equal    ${qtd_antes}    ${qtd_depois}

CT04 - Deve carregar lista de medicamentos no painel
    [Documentation]    Painel admin exibe lista de medicamentos
    Element Should Be Visible    ${PAINEL_ADMIN}
    ${qtd}=    Get Element Count    css=.med-row
    Should Be True    ${qtd} > 0

CT05 - Deve exibir botão de excluir para cada medicamento
    [Documentation]    Cada item da lista deve ter botão de exclusão
    Element Should Be Visible    ${PAINEL_ADMIN}
    ${btns}=    Get Element Count    css=.btn-excluir
    Should Be True    ${btns} > 0

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
