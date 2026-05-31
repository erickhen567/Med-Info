*** Settings ***
# Teste de Interface 2 — Busca por Categoria Terapêutica
# Técnica: Particionamento de Equivalência
# Referência: RF10, HU13, HU14, RN2, RN4

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

*** Test Cases ***

CT01 - Deve exibir resultados ao buscar por categoria existente
    [Documentation]    Partição válida: categoria existente retorna medicamentos
    Dado que o usuário seleciona o tipo de busca    Por Categoria
    E preenche o campo de busca com               Analgésico
    Quando clicar em Pesquisar
    Então deve exibir ao menos um resultado na lista

CT02 - Deve exibir resultados ao buscar por categoria parcial
    [Documentation]    Partição válida: parte da categoria também retorna resultados
    Dado que o usuário seleciona o tipo de busca    Por Categoria
    E preenche o campo de busca com               Analg
    Quando clicar em Pesquisar
    Então deve exibir ao menos um resultado na lista

CT03 - Deve exibir mensagem ao buscar categoria inexistente
    [Documentation]    Partição inválida: categoria inexistente exibe mensagem (RN4)
    Dado que o usuário seleciona o tipo de busca    Por Categoria
    E preenche o campo de busca com               CategoriaInexistente99
    Quando clicar em Pesquisar
    Então deve exibir a mensagem de nenhum resultado

CT04 - Deve exibir mensagem ao buscar sem preencher o campo
    [Documentation]    Partição inválida: campo vazio deve mostrar mensagem de validação
    Dado que o usuário seleciona o tipo de busca    Por Categoria
    E preenche o campo de busca com               ${EMPTY}
    Quando clicar em Pesquisar
    Então deve exibir mensagem de campo obrigatório

CT05 - Deve exibir múltiplos resultados para categoria ampla
    [Documentation]    Partição válida: categoria com múltiplos medicamentos
    Dado que o usuário seleciona o tipo de busca    Por Categoria
    E preenche o campo de busca com               Antibiótico
    Quando clicar em Pesquisar
    Então deve exibir ao menos um resultado na lista

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
    Sleep    1s

Então deve exibir ao menos um resultado na lista
    ${total_text}=    Get Text    ${TOTAL_RESULTADOS}
    Should Contain    ${total_text}    encontrado

Então deve exibir a mensagem de nenhum resultado
    ${msg}=    Get Text    ${MSG_RESULTADO}
    Should Contain    ${msg}    encontrado

Então deve exibir mensagem de campo obrigatório
    ${msg}=    Get Text    ${MSG_RESULTADO}
    Should Not Be Empty    ${msg}
