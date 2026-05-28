*** Settings ***
# Teste de Interface 2 — Login do Administrador
# Técnica: Particionamento de Equivalência
# Referência: RF5 (Autenticação de administrador), RN12 (Autenticação obrigatória)
# HU: HU11, HU12

Library     SeleniumLibrary
Suite Setup     Abrir Navegador na Tela de Login
Suite Teardown  Fechar Navegador

*** Variables ***
${URL}              http://localhost:5500/admin.html
${BROWSER}          chrome
${INPUT_EMAIL}      id=inputEmail
${INPUT_SENHA}      id=inputSenha
${BTN_LOGIN}        id=btnLogin
${MSG_LOGIN}        id=mensagemLogin
${PAINEL_ADMIN}     id=painelAdmin
${BTN_LOGOUT}       id=btnLogout

# Credenciais válidas do sistema
${EMAIL_VALIDO}     admin@medinfo.com
${SENHA_VALIDA}     Admin@123

*** Test Cases ***

CT01 - Deve realizar login com credenciais válidas
    [Documentation]    Partição válida: credenciais corretas devem exibir o painel admin
    Dado que o usuário preenche o email com    ${EMAIL_VALIDO}
    E preenche a senha com                    ${SENHA_VALIDA}
    Quando clicar em Entrar
    Então o painel administrativo deve ser exibido
    [Teardown]    Fazer Logout

CT02 - Deve exibir erro ao usar email sem formato válido
    [Documentation]    Partição inválida: email sem @ deve retornar mensagem de erro
    Dado que o usuário preenche o email com    adminmedinfo.com
    E preenche a senha com                    ${SENHA_VALIDA}
    Quando clicar em Entrar
    Então deve exibir a mensagem de erro      Email inválido

CT03 - Deve exibir erro ao usar senha incorreta
    [Documentation]    Partição inválida: senha errada deve retornar credenciais inválidas
    Dado que o usuário preenche o email com    ${EMAIL_VALIDO}
    E preenche a senha com                    SenhaErrada999
    Quando clicar em Entrar
    Então deve exibir a mensagem de erro      Credenciais inválidas

CT04 - Deve exibir erro ao deixar campos vazios
    [Documentation]    Partição inválida: envio sem preencher deve mostrar validação
    Dado que o usuário preenche o email com    ${EMPTY}
    E preenche a senha com                    ${EMPTY}
    Quando clicar em Entrar
    Então deve exibir a mensagem de erro      Preencha email e senha.

CT05 - Deve exibir erro ao usar email inexistente no sistema
    [Documentation]    Partição inválida: email não cadastrado deve retornar credenciais inválidas
    Dado que o usuário preenche o email com    usuarioInexistente@medinfo.com
    E preenche a senha com                    ${SENHA_VALIDA}
    Quando clicar em Entrar
    Então deve exibir a mensagem de erro      Credenciais inválidas

*** Keywords ***

Abrir Navegador na Tela de Login
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Title Should Be    Med Info — Área Administrativa

Fechar Navegador
    Close Browser

Dado que o usuário preenche o email com
    [Arguments]    ${email}
    Clear Element Text    ${INPUT_EMAIL}
    Run Keyword If    '${email}' != '${EMPTY}'    Input Text    ${INPUT_EMAIL}    ${email}

E preenche a senha com
    [Arguments]    ${senha}
    Clear Element Text    ${INPUT_SENHA}
    Run Keyword If    '${senha}' != '${EMPTY}'    Input Password    ${INPUT_SENHA}    ${senha}

Quando clicar em Entrar
    Click Button    ${BTN_LOGIN}
    Sleep    1.5s    # Aguarda resposta assíncrona da API

Então o painel administrativo deve ser exibido
    Element Should Be Visible    ${PAINEL_ADMIN}
    Element Text Should Be    ${BTN_LOGOUT}    Sair

Então deve exibir a mensagem de erro
    [Arguments]    ${mensagem_esperada}
    ${msg}=    Get Text    ${MSG_LOGIN}
    Should Contain    ${msg}    ${mensagem_esperada}

Fazer Logout
    Click Button    ${BTN_LOGOUT}
    Sleep    0.5s
