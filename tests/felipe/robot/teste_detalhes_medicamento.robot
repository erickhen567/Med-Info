*** Settings ***
# Teste de Interface 2 — Visualização de Detalhes do Medicamento
# Técnica: Particionamento de Equivalência
# Referência: RF3, HU3, HU4, HU5, HU6

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
${MODAL}                id=detalheModal
${MODAL_NOME}           id=modalNome
${MODAL_SUBSTANCIAS}    id=modalSubstancias
${MODAL_PROBLEMAS}      id=modalProblemas
${BTN_FECHAR_MODAL}     id=btnFecharModal

*** Test Cases ***

CT01 - Deve exibir modal ao clicar no resultado
    Buscar Medicamento    Por Nome    Paracetamol
    Sleep    2s
    ${qtd}=    Get Element Count    css=.resultado-item
    Should Be True    ${qtd} > 0
    Click Element    css=.resultado-item
    Sleep    2s
    Element Should Be Visible    ${MODAL}
    Click Button    ${BTN_FECHAR_MODAL}
    Sleep    1s

CT02 - Deve exibir mensagem quando busca não retorna resultado
    Buscar Medicamento    Por Nome    MedicamentoInexistente99
    Sleep    2s
    ${msg}=    Get Text    ${MSG_RESULTADO}
    Should Not Be Empty    ${msg}

CT03 - Deve exibir substâncias no modal
    Buscar Medicamento    Por Nome    Dipirona
    Sleep    2s
    Click Element    css=.resultado-item
    Sleep    2s
    Element Should Be Visible    ${MODAL}
    ${sub}=    Get Text    ${MODAL_SUBSTANCIAS}
    Should Not Be Empty    ${sub}
    Click Button    ${BTN_FECHAR_MODAL}
    Sleep    1s

CT04 - Deve exibir problemas tratados no modal
    Buscar Medicamento    Por Nome    Amoxicilina
    Sleep    2s
    Click Element    css=.resultado-item
    Sleep    2s
    Element Should Be Visible    ${MODAL}
    ${prob}=    Get Text    ${MODAL_PROBLEMAS}
    Should Not Be Empty    ${prob}
    Click Button    ${BTN_FECHAR_MODAL}
    Sleep    1s

CT05 - Deve fechar o modal ao clicar no botão fechar
    Buscar Medicamento    Por Nome    Metformina
    Sleep    2s
    Click Element    css=.resultado-item
    Sleep    2s
    Element Should Be Visible    ${MODAL}
    Click Button    ${BTN_FECHAR_MODAL}
    Sleep    1s
    Element Should Not Be Visible    ${MODAL}

*** Keywords ***

Abrir Navegador na Tela de Busca
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Sleep    2s

Buscar Medicamento
    [Arguments]    ${tipo}    ${valor}
    Select From List By Label    ${SEL_TIPO_BUSCA}    ${tipo}
    Clear Element Text    ${SEL_CAMPO_BUSCA}
    Input Text    ${SEL_CAMPO_BUSCA}    ${valor}
    Click Button    ${BTN_BUSCAR}

Fechar Navegador
    Close Browser
