/**
 * 处方点评西药处方预览
 */
var unitsUrl = 'dhcpha.comment.prescription.save.csp';
var PrescNo = "";
var EpisodeID = "";
var PrescTextFieldStyle = "background:white;color:black;opacity:1;border-color:#8DB2E3;background-image:url();"
Ext.onReady(function() {
    Ext.QuickTips.init(); // 浮动信息提示
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

    var Request = new Object();
    Request = GetRequest();
    if (Request) {
        PrescNo = Request['PrescNo'];
        EpisodeID = Request['EpisodeID'];

    }
    var PatNameLab = new Ext.form.Label({
        id: "PatNameLabField",
        text: '姓名'
    });

    var PatNameVal = new Ext.form.TextField({
        width: 100,
        id: "PatNameValField",
        style: PrescTextFieldStyle,
        readOnly: true
    })

    var PatAgeLab = new Ext.form.Label({
        id: "PatAgeLabField",
        text: '　年龄'
    })
    var PatAgeVal = new Ext.form.TextField({
        width: 75,
        id: "PatAgeValField",
        readOnly: true,
        style: PrescTextFieldStyle
    })

    var PatSexLab = new Ext.form.Label({
        id: "PatSexLabField",
        text: '　性别'
    })


    var PatSexVal = new Ext.form.TextField({
        width: 50,
        id: "PatSexValField",
        readOnly: true,
        style: PrescTextFieldStyle

    })

    var PatHeightLab = new Ext.form.Label({
        id: "PatHeightLabField",
        text: '　身高'
    })

    var PatHeightVal = new Ext.form.TextField({
        id: "PatHeightValField",
        width: 50,
        readOnly: true,
        style: PrescTextFieldStyle
    })

    var PatWidthLab = new Ext.form.Label({
        id: "PatWidthLabField",
        text: '　体重'
    })

    var PatWidthVal = new Ext.form.TextField({
        width: 50,
        id: "PatWidthValField",
        readOnly: true,
        style: PrescTextFieldStyle
    })

    var BillTypeLab = new Ext.form.Label({
        id: "BillTypeLabField",
        text: '　费别'
    })

    var BillTypeVal = new Ext.form.TextField({
        width: 90,
        id: "BillTypeValField",
        readOnly: true,
        style: PrescTextFieldStyle
    })

    var PatLocLab = new Ext.form.Label({
        id: "PatLocLabField",
        text: '　科室'
    })

    var PatLocVal = new Ext.form.TextField({
        width: 110,
        id: "PatLocValField",
        readOnly: true,
        style: PrescTextFieldStyle
    })

    var TotalAmtLab = new Ext.form.Label({
        id: "TotalAmtField",
        text: '处方总额'
    })

    var TotalAmtVal = new Ext.form.TextField({
        width: 90,
        id: "TotalAmtValField",
        readOnly: true,
        style: PrescTextFieldStyle
    })

    var DoctorNameLab = new Ext.form.Label({
        id: "DoctorNameField",
        text: '　医生'
    })

    var DoctorNameVal = new Ext.form.TextField({
        width: 90,
        id: "DoctorNameValField",
        readOnly: true,
        style: PrescTextFieldStyle
    })

    var PyUserLab = new Ext.form.Label({
        id: "PyUserField",
        text: '　配药药师'
    })

    var PyUserVal = new Ext.form.TextField({
        width: 90,
        id: "PyUserValField",
        readOnly: true,
        style: PrescTextFieldStyle
    })

    var FyUserLab = new Ext.form.Label({
        id: "FyUserField",
        text: '　发药药师'
    })

    var FyUserVal = new Ext.form.TextField({
        width: 90,
        id: "FyUserValField",
        readOnly: true,
        style: PrescTextFieldStyle
    })

    var PrescTitleLab = new Ext.form.Label({
        id: "PrescTitleField",
        text: '类型'
    })

    var PrescTitleVal = new Ext.form.TextField({
        width: 100,
        id: "PrescTitleValField",
        readOnly: true,
        style: PrescTextFieldStyle
    })

    var detailgridcm = new Ext.grid.ColumnModel({
        columns: [
            { header: '药品名称', dataIndex: 'drugname', width: 300 },
            { header: '数量', dataIndex: 'qty', width: 80 },
            { header: '用法用量', dataIndex: 'freq', width: 250 },
            { header: '单价', dataIndex: 'price', width: 60 },
            { header: '金额', dataIndex: 'amt', width: 80 }
        ]
    });


    var detailgridds = new Ext.data.Store({
        proxy: '',
        reader: new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: 'results'
        }, [
            'drugname',
            'qty',
            'freq',
            'price',
            'amt'
        ]),
        remoteSort: true
    });

    var detailgrid = new Ext.grid.GridPanel({
        frame: false,
        region: 'center',
        stripeRows: true,
        //width:650,
        height: 290,
        width:650,
        autoScroll: true,
        enableHdMenu: false,
        ds: detailgridds,
        cm: detailgridcm,
        enableColumnMove: false,
        view: new Ext.ux.grid.BufferView({
            // custom row height
            rowHeight: 25,
            // render rows as they come into viewable area.
            scrollDelay: false
        }),
        trackMouseOver: 'true'
    });

    var diaggridcm = new Ext.grid.ColumnModel({

        columns: [
            { header: '诊断列表', dataIndex: 'diag', width: 200 }
        ]
    });

    var diaggridds = new Ext.data.Store({
        proxy: '',
        reader: new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: 'results'
        }, [
            'diag'
        ]),
        remoteSort: true
    });

    var diaggrid = new Ext.grid.GridPanel({
        frame: false,
        region: 'center',
        stripeRows: true,
        //width:650,
        height: 290,
        autoScroll: true,
        enableHdMenu: false,
        ds: diaggridds,
        cm: diaggridcm,
        enableColumnMove: false,
        view: new Ext.ux.grid.BufferView({
            // custom row height
            rowHeight: 25,
            // render rows as they come into viewable area.
            scrollDelay: false
        }),
        trackMouseOver: 'true'
    });

    var PrescInfoForm = new Ext.form.FormPanel({
        title: '处方信息',
        region: "center",
        height: 430,
        defaults: { border: false },
        bodyStyle: "background-color: #DFE8F6",
        items: [{
            layout: 'column',
            defaults: { border: false },
            xtype: 'fieldset',
            frame: false,
            labelAlign: 'right',
            style: "padding-bottom:0;padding-top:0;",
            items: [{
                defaults: { border: false },
                columnWidth: 1,
                xtype: 'fieldset',
                labelAlign: 'right',
                labelWidth: 10,
                width: 1200,
                items: [{
                    xtype: 'compositefield',
                    style: "padding-top:15px;padding-bottom:0px",
                    fieldLabel: " ",
                    labelSeparator: "",
                    items: [
                        PatNameLab, PatNameVal,
                        PatSexLab, PatSexVal,
                        PatAgeLab, PatAgeVal,
                        PatHeightLab, PatHeightVal,
                        PatWidthLab, PatWidthVal,
                        BillTypeLab, BillTypeVal,
                        PatLocLab, PatLocVal
                    ]
                },{
                    xtype: 'compositefield',
                    style: "padding-top:15px;padding-bottom:0px",
                    fieldLabel: " ",
                    labelSeparator: "",
                    items: [
                        PrescTitleLab, PrescTitleVal
                    ]
                }]
            }]
        }, {
            layout: "column",
            style: "padding-left:20",
            bodyStyle: "background-color: #DFE8F6;",
            defaults: { border: false },
            items: [{
                columnWidth: .2,
                items: [diaggrid]
            }, {
                columnWidth: .8,
                items: [detailgrid]
            }]
        }, {
            layout: 'column',
            defaults: { border: false },
            xtype: 'fieldset',
            frame: false,
            labelAlign: 'right',
            style: "padding-bottom:0px;padding-top:0px",
            items: [{
                defaults: { border: false },
                columnWidth: 1,
                xtype: 'fieldset',
                labelAlign: 'right',
                labelWidth: 10,
                width: 1000,
                items: [{
                    xtype: 'compositefield',
                    style: "padding-top:15px;padding-bottom:0px",
                    fieldLabel: " ",
                    labelSeparator: "",
                    items: [
                        TotalAmtLab, TotalAmtVal,
                        DoctorNameLab, DoctorNameVal,
                        PyUserLab, PyUserVal,
                        FyUserLab, FyUserVal
                    ]
                }]
            }]
        }]
    })

    var port = new Ext.Viewport({
        layout: 'border',
        items: [PrescInfoForm]
    });

    GetPatInfo(PrescNo)

    ///取病人基本信息
    function GetPatInfo(PrescNo) {
        Ext.Ajax.request({
            url: unitsUrl + '?action=GetPatInfo&PrescNo=' + PrescNo,
            waitMsg: '处理中...',
            failure: function(result, request) {
                Ext.Msg.show({ title: '错误', msg: '请检查网络连接!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
            },
            success: function(result, request) {
                var jsonData = Ext.util.JSON.decode(result.responseText);
                var str = jsonData.retvalue;
                if (str != "") {
                    SetPatInfo(str);
                }
            },
            scope: this
        });


    }

    function SetPatInfo(str) {
        tmparr = str.split("^");
        Ext.getCmp("PatNameValField").setValue(tmparr[1]);
        Ext.getCmp("PatAgeValField").setValue(tmparr[2]);
        Ext.getCmp("PatSexValField").setValue(tmparr[3]);
        Ext.getCmp("BillTypeValField").setValue(tmparr[32]);
        Ext.getCmp("PatLocValField").setValue(tmparr[16]); //就诊科室tmparr[23]
        Ext.getCmp("DoctorNameValField").setValue(tmparr[24]);
        Ext.getCmp("PrescTitleValField").setValue(tmparr[22]);
        Ext.getCmp("TotalAmtValField").setValue(tmparr[33]);
        Ext.getCmp("PyUserValField").setValue(tmparr[6]);
        Ext.getCmp("FyUserValField").setValue(tmparr[7]);
        Ext.getCmp("PatWidthValField").setValue(tmparr[5]);
        Ext.getCmp("PatHeightValField").setValue(tmparr[34]);
        FindDiagData(EpisodeID);
        FindOrdDetailData(PrescNo)
    }

    ///取病人诊断信息
    function FindDiagData(adm) {

        diaggridds.removeAll();
        diaggridds.proxy = new Ext.data.HttpProxy({ url: unitsUrl + '?action=GetMRDiagnosDesc&adm=' + adm });
        diaggridds.load({
            callback: function(r, options, success) {
                if (success == false) {
                    Ext.Msg.show({ title: '注意', msg: '查询失败 !', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
                }
            }
        });
    }

    ///取病人医嘱信息
    function FindOrdDetailData(PrescNo) {
        detailgridds.removeAll();
        detailgridds.proxy = new Ext.data.HttpProxy({ url: unitsUrl + '?action=GetXYOrdDetail&PrescNo=' + PrescNo });
        detailgridds.load({
            callback: function(r, options, success) {
                if (success == false) {
                    Ext.Msg.show({ title: '注意', msg: '查询失败 !', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
                }
            }
        });
    }
});