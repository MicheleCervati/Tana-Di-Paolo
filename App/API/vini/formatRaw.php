<?php

function formatRaw(&$vino)
{
    $vino['cantina'] = [
        'id' => $vino['cid'],
        'nome' => $vino['cantina'],
    ];
    $vino['vitigno'] = [
        'id' => $vino['vid'],
        'nome' => $vino['vitigno'],
    ];
    $vino['tipologia'] = [
        'id' => $vino['tid'],
        'nome' => $vino['tipologia'],
    ];
    $vino['invecchiamento'] = [
        'id' => $vino['iid'],
        'nome' => $vino['invecchiamento'],
    ];
    unset($vino['cid']);
    unset($vino['vid']);
    unset($vino['tid']);
    unset($vino['iid']);
    if (array_key_exists('aromi', $vino)) {
        $aromi = explode('; ', $vino['aromi']);
        $vino['aromi'] = [];
        foreach ($aromi as $aroma) {
            $nome = explode(': ', $aroma);
            $vino['aromi'][$nome[0]] = explode(', ', $nome[1]);
        }
    }
}