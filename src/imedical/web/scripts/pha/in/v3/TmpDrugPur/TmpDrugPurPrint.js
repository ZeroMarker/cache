/// ¡Ÿπ∫“©∆∑¥Ú”°

function PrintTmpDrug(Hosp, TDPNo) {
    var prtData = tkMakeServerCall('PHA.IN.TmpDrugPurch.Print', 'PrintTmpDrug', Hosp, TDPNo);
    if (prtData == '{}') {
        return;
    }
    var prtJson = JSON.parse(prtData);

    PRINTCOM.XML({
        printBy: 'lodop',
        XMLTemplate: 'DHCTmpDrugPurch',
        data: prtJson,
    });
}
