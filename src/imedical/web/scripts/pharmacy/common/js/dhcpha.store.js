/**
 * creator:		yunhaibao
 * createdate:	2018-05-23
 * description:	药房公共store,仅对应query名称
 */
var DHCPHA_STORE = ({
    // HIS常量
    Constant: {
        // 登记号长度
        PatNoLen: 10
    },
    ComboBox: {
        // 医生科室
        DocLoc: {
            ClassName: 'web.DHCSTPharmacyDict',
            QueryName: 'DocLoc'
        },
        // 本科室人员
        LocUser: {
            ClassName: 'web.DHCSTPharmacyDict',
            QueryName: 'LocUser'
        },
        // 科室组
        LocGrp: {
            ClassName: "web.DHCSTPharmacyDict",
            QueryName: "DHCStkLocGroup"
        },
        // 病区
        Ward: {
            ClassName: "web.DHCSTPharmacyDict",
            QueryName: "PACWard"
        },
        // 药房
        PhaLoc: {
            ClassName: "web.DHCSTPharmacyDict",
            QueryName: "PhaLoc"
        },
        // 所有科室
        CtLoc: {
            ClassName: "web.DHCSTPharmacyDict",
            QueryName: "CtLoc"
        },
        IncUom: {
            ClassName: "web.DHCSTPharmacyDict",
            QueryName: "IncUom"
        },
        // 退药原因
        RetReason: {
            ClassName: 'web.DHCSTPharmacyDict',
            QueryName: 'RetReason',
            hospId:session['LOGON.HOSPID']
        },
        // 申请退药原因
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
                    { field: 'incCode', title: '药品代码', width: 100, sortable: true },
                    { field: 'incDesc', title: '药品名称', width: 400, sortable: true },
                    { field: 'incSpec', title: '规格', width: 100, sortable: true }
                ]
            ],
            idField: 'incRowId',
            textField: 'incDesc'
        }
    }
})
