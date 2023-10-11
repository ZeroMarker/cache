/**
 * creator:		yunhaibao
 * createdate:	2018-05-23
 * description:	ҩ������store,����Ӧquery����
 */
var DHCPHA_STORE = ({
    // HIS����
    Constant: {
        // �ǼǺų���
        PatNoLen: 10
    },
    ComboBox: {
        // ҽ������
        DocLoc: {
            ClassName: 'web.DHCSTPharmacyDict',
            QueryName: 'DocLoc'
        },
        // ��������Ա
        LocUser: {
            ClassName: 'web.DHCSTPharmacyDict',
            QueryName: 'LocUser'
        },
        // ������
        LocGrp: {
            ClassName: "web.DHCSTPharmacyDict",
            QueryName: "DHCStkLocGroup"
        },
        // ����
        Ward: {
            ClassName: "web.DHCSTPharmacyDict",
            QueryName: "PACWard"
        },
        // ҩ��
        PhaLoc: {
            ClassName: "web.DHCSTPharmacyDict",
            QueryName: "PhaLoc"
        },
        // ���п���
        CtLoc: {
            ClassName: "web.DHCSTPharmacyDict",
            QueryName: "CtLoc"
        },
        IncUom: {
            ClassName: "web.DHCSTPharmacyDict",
            QueryName: "IncUom"
        },
        // ��ҩԭ��
        RetReason: {
            ClassName: 'web.DHCSTPharmacyDict',
            QueryName: 'RetReason',
            hospId:session['LOGON.HOSPID']
        },
        // ������ҩԭ��
        ReqRetReason: {
            ClassName: 'web.DHCINPHA.Request',
            QueryName: 'BLCReasonForRefund',
            hospId:session['LOGON.HOSPID']
        }
    },
    ComboGrid: {
        IncItm: {
            QueryParams: {
                ClassName: "web.DHCSTPharmacyDict",
                QueryName: "IncItm",
                inputStr: ""
            },
            pageNumber: 0,
            panelWidth: 750,
            columns: [
                [
                    { field: 'incRowId', title: 'incItmRowId', width: 100, sortable: true, hidden: true },
                    { field: 'incCode', title: 'ҩƷ����', width: 100, sortable: true },
                    { field: 'incDesc', title: 'ҩƷ����', width: 400, sortable: true },
                    { field: 'incSpec', title: '���', width: 100, sortable: true }
                ]
            ],
            idField: 'incRowId',
            textField: 'incDesc'
        }
    }
})
