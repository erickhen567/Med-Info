*** Settings ***
# Teste de Interface 2 — Fluxo Completo de Navegação
# Técnica: Tabela de Decisão
# Referência: RF1, RF3, HU1, HU3, HU4, HU5, HU6

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
${MODAL_DESCRICAO}      id=modalDescricao
${MODAL_PROBLEMAS}      id=modalProblemas
${MODAL_ROTULO}         id=modalRotulo
${BTN_FECHAR_MODAL}     id=btnFecharModal

*** Test Cases ***

CT01 - Deve completar fluxo completo: busca, detalhes e fechar
    [Documentation]    Fluxo completo: buscar, abrir modal, fechar e retornar
    Dado que o usuário busca por    Por Nome    Paracetamol
    Quando clicar no primeiro resultado
    Então o modal de detalhes deve ser exibido
    E clicar no botão fechar modal
    Então o modal deve ser fechado

CT02 - Busca sem resultado não deve abrir modal
    [Documentation]    Sem resultado: modal não deve aparecer
    Dado que o usuário busca por    Por Nome    MedicamentoInexistente99
    Então deve exibir a mensagem de nenhum resultado
    Element Should Not Be Visible    ${MODAL}

CT03 - Modal deve permanecer aberto sem ação de fechar
    [Documentation]    Modal aberto: permanece visível enquanto não fechar
    Dado que o usuário busca por    Por Nome    Amoxicilina
    Quando clicar no primeiro resultado
    Então o modal de detalhes deve ser exibido
    Element Should Be Visible    ${MODAL}
    [Teardown]    Click Button    ${BTN_FECHAR_MODAL}

CT04 - Modal deve exibir todos os campos obrigatórios
    [Documentation]    Campos RN5: nome, substâncias, descrição, problemas e rótulo visíveis
    Dado que o usuário busca por    Por Nome    Metformina
    Quando clicar no primeiro resultado
    Então o modal de detalhes deve ser exibido
    ${nome}=        Get Text    ${MODAL_NOME}
    ${sub}=         Get Text    ${MODAL_SUBSTANCIAS}
    ${desc}=        Get Text    ${MODAL_DESCRICAO}
    ${prob}=        Get Text    ${MODAL_PROBLEMAS}
    ${rotulo}=      Get Text    ${MODAL_ROTULO}
    Should Not Be Empty    ${nome}
    Should Not Be Empty    ${sub}
    Should Not Be Empty    ${desc}
    Should Not Be Empty    ${prob}
    Should Not Be Empty    ${rotulo}
    [Teardown]    Click Button    ${BTN_FECHAR_MODAL}

CT05 - Deve exibir dados corretos em buscas consecutivas
    [Documentation]    Duas buscas consecutivas exibem dados corretos de cada medicamento
    Dado que o usuário busca por    Por Nome    Paracetamol
    Quando clicar no primeiro resultado
    ${nome1}=    Get Text    ${MODAL_NOME}
    Should Contain    ${nome1}    Paracetamol
    Click Button    ${BTN_FECHAR_MODAL}
    Sleep    0.5s
    Dado que o usuário busca por    Por Nome    Dipirona
    Quando clicar no primeiro resultado
    ${nome2}=    Get Text    ${MODAL_NOME}
    Should Contain    ${nome2}    Dipirona
    [Teardown]    Click Button    ${BTN_FECHAR_MODAL}

*** Keywords ***

Abrir Navegador na Tela de Busca
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Title Should Be    Med Info — Consulta de Medicamentos

Fechar Navegador
    Close Browser

Dado que o usuário busca por
    [Arguments]    ${tipo}    ${valor}
    Select From List By Label    ${SEL_TIPO_BUSCA}    ${tipo}
    Clear Element Text    ${SEL_CAMPO_BUSCA}
    Input Text    ${SEL_CAMPO_BUSCA}    ${valor}
    Click Button    ${BTN_BUSCAR}
    Sleep    1.5s

Quando clicar no primeiro resultado
    Click Element    css=#listaResultados .resultado-item:first-child
    Sleep    1s

E clicar no botão fechar modal
    Click Button    ${BTN_FECHAR_MODAL}
    Sleep    0.5s

Então o modal de detalhes deve ser exibido
    Element Should Be Visible    ${MODAL}

Então o modal deve ser fechado
    Element Should Not Be Visible    ${MODAL}

Então deve exibir a mensagem de nenhum resultado
    ${msg}=    Get Text    ${MSG_RESULTADO}
    Should Contain    ${msg}    encontrado
