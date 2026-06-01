*** Settings ***
# Teste de Interface 1 — Listagem Geral de Medicamentos
# Técnica: Análise de Valor Limite
# Referência: RF1, HU1, HU14, RN3

Library     SeleniumLibrary
Suite Setup     Abrir Navegador na Tela de Busca
Suite Teardown  Fechar Navegador

*** Variables ***
${URL}                  http://localhost:5500/index.html
${BROWSER}              chrome
${SEL_TIPO_BUSCA}       id=tipoBusca
${SEL_CAMPO_BUSCA}      id=campoBusca
${BTN_BUSCAR}           id=btnBuscar
${MSG_RESULTADO}        id=mensagem
${TOTAL_RESULTADOS}     id=totalResultados
${LISTA_RESULTADOS}     id=listaResultados

*** Test Cases ***

CT01 - Deve exibir múltiplos resultados na listagem geral
    [Documentation]    Valor limite mínimo funcional: busca ampla retorna múltiplos resultados
    Dado que o usuário seleciona o tipo de busca    Por Nome
    E preenche o campo de busca com               a
    Quando clicar em Pesquisar
    Então deve exibir mais de um resultado

CT02 - Deve exibir resultados com busca de 1 caractere
    [Documentation]    Valor limite: 1 caractere é o menor input válido
    Dado que o usuário seleciona o tipo de busca    Por Nome
    E preenche o campo de busca com               L
    Quando clicar em Pesquisar
    Então deve exibir ao menos um resultado na lista

CT03 - Deve exibir resultado exato com nome completo
    [Documentation]    Valor exato: nome completo retorna resultado preciso
    Dado que o usuário seleciona o tipo de busca    Por Nome
    E preenche o campo de busca com               Metformina 850mg
    Quando clicar em Pesquisar
    Então deve exibir ao menos um resultado na lista

CT04 - Deve exibir mensagem ao pesquisar com campo vazio
    [Documentation]    Valor limite mínimo inválido: campo vazio exibe validação
    Dado que o usuário seleciona o tipo de busca    Por Nome
    E preenche o campo de busca com               ${EMPTY}
    Quando clicar em Pesquisar
    Então deve exibir mensagem de campo obrigatório

CT05 - Deve atualizar placeholder ao trocar tipo de busca
    [Documentation]    Limite de troca: mudar dropdown atualiza placeholder
    Select From List By Label    ${SEL_TIPO_BUSCA}    Por Substância
    ${placeholder}=    Get Element Attribute    ${SEL_CAMPO_BUSCA}    placeholder
    Should Contain    ${placeholder}    Ex

*** Keywords ***

Abrir Navegador na Tela de Busca
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Title Should Be    Med Info — Consulta de Medicamentos

Fechar Navegador
    Close Browser

Dado que o usuário seleciona o tipo de busca
    [Arguments]    ${opcao}
    Select From List By Label    ${SEL_TIPO_BUSCA}    ${opcao}

E preenche o campo de busca com
    [Arguments]    ${valor}
    Clear Element Text    ${SEL_CAMPO_BUSCA}
    Run Keyword If    '${valor}' != '${EMPTY}'    Input Text    ${SEL_CAMPO_BUSCA}    ${valor}

Quando clicar em Pesquisar
    Click Button    ${BTN_BUSCAR}
    Sleep    1.5s

Então deve exibir ao menos um resultado na lista
    ${total_text}=    Get Text    ${TOTAL_RESULTADOS}
    Should Contain    ${total_text}    encontrado

Então deve exibir mais de um resultado
    ${qtd}=    Get Element Count    css=#listaResultados .resultado-item
    Should Be True    ${qtd} > 1

Então deve exibir mensagem de campo obrigatório
    ${msg}=    Get Text    ${MSG_RESULTADO}
    Should Not Be Empty    ${msg}
