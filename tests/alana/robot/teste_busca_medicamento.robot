*** Settings ***
# Teste de Interface 1 — Busca de Medicamentos
# Técnica: Tabela de Decisão
# Referência: RF1 (Pesquisa por nome), RF2 (Pesquisa por substância), RN4 (Nenhum resultado)
# HU: HU1, HU2, HU14

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

CT01 - Deve exibir resultados ao buscar por nome existente
    [Documentation]    Partição válida: nome que existe no banco retorna lista de medicamentos
    Dado que o usuário seleciona o tipo de busca    Por Nome
    E preenche o campo de busca com               Paracetamol
    Quando clicar em Pesquisar
    Então deve exibir ao menos um resultado na lista

CT02 - Deve exibir resultados ao buscar por nome parcial
    [Documentation]    Partição válida: parte do nome também deve retornar resultados (RN1)
    Dado que o usuário seleciona o tipo de busca    Por Nome
    E preenche o campo de busca com               dipiro
    Quando clicar em Pesquisar
    Então deve exibir ao menos um resultado na lista

CT03 - Deve exibir mensagem de erro ao buscar nome inexistente
    [Documentation]    Partição inválida: nome que não existe deve exibir mensagem (RN4)
    Dado que o usuário seleciona o tipo de busca    Por Nome
    E preenche o campo de busca com               medicamentoQueNaoExiste99
    Quando clicar em Pesquisar
    Então deve exibir a mensagem de nenhum resultado

CT04 - Deve exibir resultados ao buscar por substância existente
    [Documentation]    Partição válida: substância conhecida retorna medicamentos (RF2, HU2)
    Dado que o usuário seleciona o tipo de busca    Por Substância
    E preenche o campo de busca com               Dipirona
    Quando clicar em Pesquisar
    Então deve exibir ao menos um resultado na lista

CT05 - Deve exibir mensagem ao buscar sem preencher o campo
    [Documentation]    Valor limite: campo vazio deve mostrar mensagem de validação
    Dado que o usuário seleciona o tipo de busca    Por Nome
    E preenche o campo de busca com               ${EMPTY}
    Quando clicar em Pesquisar
    Então deve exibir mensagem de campo obrigatório

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
    Sleep    1s    # Aguarda resposta assíncrona da API

Então deve exibir ao menos um resultado na lista
    ${total_text}=    Get Text    ${TOTAL_RESULTADOS}
    Should Contain    ${total_text}    encontrado

Então deve exibir a mensagem de nenhum resultado
    ${msg}=    Get Text    ${MSG_RESULTADO}
    Should Contain    ${msg}    encontrado

Então deve exibir mensagem de campo obrigatório
    ${msg}=    Get Text    ${MSG_RESULTADO}
    Should Not Be Empty    ${msg}
