/// 处方综合点评
/// Creator:LiangQiang
/// CreatDate:2012-05-20

/// 调取后台csp
var unitsUrl = 'dhcpha.comment.main.save.csp';

/// 默认值
var comwidth = 150;
var ruleformwd = 1000;
var fromheight = 250;
var maxcentnum = 0.8; //最大抽取百分比数

var parstr = ""; //入参
var CardTypeDs = [];
var systaskflag = "";
var LogonLocId = session['LOGON.CTLOCID']
var gNewCatIdOther = ""; // 新药理学分类

Ext.onReady(function() {
    Ext.Ajax.timeout = 900000;
    Ext.QuickTips.init(); // 浮动信息提示
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    Ext.ux.form.LovCombo = Ext.form.LovCombo || Ext.ux.form.LovCombo;

    // 医生科室
    var ComBoDocLocDs = new Ext.data.Store({
        autoLoad: true,
        proxy: "",
        reader: new Ext.data.JsonReader({
            totalProperty: "results",
            root: 'rows',
            id: 'DocLocID'
        }, ['DocLocDesc', 'DocLocID'])
    });
    ComBoDocLocDs.on(
        'beforeload',
        function(ds, o) {
            ds.proxy = new Ext.data.HttpProxy({ url: unitsUrl + '?action=GetDocLocDs', method: 'GET' });
        }
    );
    var DocLocSelecter = new Ext.ux.form.LovCombo({
        fieldLabel: '医生科室',
        id: 'DocLocSelecter',
        name: 'DocLocSelecter',
        store: ComBoDocLocDs,
        width: comwidth,
        listWidth: 250,
        emptyText: '选择医生科室...',
        hideOnSelect: false,
        maxHeight: 300,
        valueField: 'DocLocID',
        displayField: 'DocLocDesc',
        queryMode: 'remote',
        triggerAction: 'all',
        showSelectAll: true,
        //mode:'local',
        queryParam: 'combotext',
        minChars: 1,
        resizable: true
    });

    /// 处方类型
    var ComBoPresctypeDs = new Ext.data.Store({
        autoLoad: true,
        proxy: "",
        reader: new Ext.data.JsonReader({
            totalProperty: "results",
            root: 'rows',
            id: 'PTypeID'
        }, ['PTypeDesc', 'PTypeID'])
    });
    ComBoPresctypeDs.on(
        'beforeload',
        function(ds, o) {
            ds.proxy = new Ext.data.HttpProxy({ url: unitsUrl + '?action=GetPresctypeDs', method: 'GET' });
        }
    );
    var PresctypeSelecter = new Ext.ux.form.LovCombo({
        fieldLabel: '处方类型',
        id: 'PresctypeCmb',
        name: 'PresctypeSelecter',
        store: ComBoPresctypeDs,
        width: comwidth,
        listWidth: 250,
        emptyText: '选择处方类型...',
        hideOnSelect: false,
        maxHeight: 300,
        valueField: 'PTypeID',
        displayField: 'PTypeDesc',
        triggerAction: 'all',
        mode: 'local'
    });

    /// 剂型  
    var ComBoPHCFormDs = new Ext.data.Store({
        autoLoad: true,
        proxy: new Ext.data.HttpProxy({
            url: unitsUrl +
                '?action=GetPHCFormDs',
            method: 'GET'
        }),
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows', id: 'PHCFID' }, ['PHCFDesc', 'PHCFID'])
    });
    var PHCFormSelecter = new Ext.form.ComboBox({
        fieldLabel: '剂型',
        id: 'PHCFormCmb',
        name: 'PHCFormSelecter',
        store: ComBoPHCFormDs,
        width: comwidth,
        //listWidth : 100,
        emptyText: '选择剂型...',
        hideOnSelect: false,
        maxHeight: 300,
        valueField: 'PHCFID',
        displayField: 'PHCFDesc',
        triggerAction: 'all',
        mode: 'local',
        valueNotFoundText: ''
    });

    /// 疗程  
    var ComBoPHCDUDs = new Ext.data.Store({
        autoLoad: true,
        proxy: new Ext.data.HttpProxy({
            url: unitsUrl +
                '?action=GetPHCDUDs',
            method: 'GET'
        }),
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows', id: 'PHCDUID' }, ['PHCDUDesc', 'PHCDUID'])
    });
    var PHCDUSelecter = new Ext.form.ComboBox({
        fieldLabel: '疗程大于',
        id: 'PHCDUCmb',
        name: 'PHCDUSelecter',
        store: ComBoPHCDUDs,
        width: comwidth,
        //listWidth : 100,
        emptyText: '选择疗程大于...',
        hideOnSelect: false,
        maxHeight: 300,
        valueField: 'PHCDUID',
        displayField: 'PHCDUDesc',
        triggerAction: 'all',
        mode: 'local',
        valueNotFoundText: ''
    });

    /// 医嘱项名称  
    var ComBoArcimDs = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: unitsUrl,
            method: 'POST'
        }),
        reader: new Ext.data.JsonReader({
            totalProperty: "results",
            root: 'rows',
            id: 'arcimId'
        }, ['arcimId', 'arcimCode', 'arcimDesc'])
    });
    var tpl = new Ext.XTemplate(
        '<table cellpadding=2 cellspacing = 1><tbody>',
        '<tr><th style="font-weight: bold; font-size:15px;">名称</th><th style="font-weight: bold; font-size:15px;">代码</th><th style="font-weight: bold; font-size:15px;">ID</th></tr>',
        '<tpl for=".">',
        '<tr class="combo-item">',
        '<td style="width:500; font-size:15px;">{arcimDesc}</td>',
        '<td style="width:20%; font-size:15px;">{arcimCode}</td>',
        '<td style="width:50; font-size:15px;">{arcimId}</td>',
        '</tr>',
        '</tpl>', '</tbody></table>');
    var ArcimSelecter = new Ext.form.ComboBox({
        id: 'ArcimSelecter',
        fieldLabel: '医嘱名称',
        store: ComBoArcimDs,
        valueField: 'arcimId',
        displayField: 'arcimDesc',
        pageSize: 50,
        width: comwidth,
        autoHeight: true,
        listWidth: 550,
        triggerAction: 'all',
        emptyText: '选择医嘱名称...',
        name: 'ArcimSelecter',
        selectOnFocus: true,
        forceSelection: true,
        tpl: tpl,
        itemSelector: 'tr.combo-item',
        listeners: {
            specialKey: function(field, e) {
                if (e.getKey() == Ext.EventObject.ENTER) {
                    ComBoArcimDs.proxy = new Ext.data.HttpProxy({
                        url: unitsUrl +
                            '?action=GetArcimDs&searchItmValue=' +
                            Ext.getCmp('ArcimSelecter').getRawValue(),
                        method: 'POST'
                    })
                    ComBoArcimDs.reload({
                        params: {
                            start: 0,
                            limit: ArcimSelecter.pageSize
                        }
                    });
                }
            }
        }
    });

    var StDateField = new Ext.form.DateField({
        xtype: 'datefield',
        //format:'j/m/Y' ,
        fieldLabel: '开始日期',
        name: 'startdt',
        id: 'startdt',
        tabIndex: '0',
        //invalidText:'无效日期格式,正确格式是:日/月/年,如:15/02/2011',
        width: comwidth,
        value: new Date()
    })

    var EndDateField = new Ext.form.DateField({
        //format:'j/m/Y' ,
        fieldLabel: '截止日期',
        name: 'enddt',
        id: 'enddt',
        tabIndex: '0',
        width: comwidth,
        value: new Date
    });

    /// 随机数
    var RandomNumField = new Ext.form.TextField({
        width: comwidth,
        id: "RandomNumField"
    });

    /// 百分比
    var PercentageField = new Ext.form.TextField({
        width: comwidth,
        id: "PercentageField"
    });
    PercentageField.setDisabled(true);

    /// 处方总数
    var MaxNumField = new Ext.form.TextField({
        width: comwidth,
        id: "MaxNumField",
        fieldLabel: "处方总数"
    });
    MaxNumField.setDisabled(true);

    /// 单号
    var ComNoField = new Ext.form.TextField({
        width: comwidth,
        height: 25,
        id: "ComNoField",
        fieldLabel: "点评单号"
    });
    ComNoField.setDisabled(true);

    var NumRadio = new Ext.form.Radio({
        FieldLabel: '随机数',
        id: "NumRad",
        checked: true,
        listeners: {
            'check': function() {
                if (NumRadio.getValue()) {
                    Ext.getCmp("PercentageField").setRawValue("");
                    CentRadio.setValue(false);
                    PercentageField.setDisabled(true);
                    NumRadio.setValue(true);
                }
                RandomNumField.setDisabled(false);
            }
        }
    });

    var CentRadio = new Ext.form.Radio({
        FieldLabel: '百分比',
        id: "CentRad",
        listeners: {
            'check': function() {
                if (CentRadio.getValue()) {
                    Ext.getCmp("RandomNumField").setRawValue("");
                    NumRadio.setValue(false);
                    RandomNumField.setDisabled(true);
                    CentRadio.setValue(true);
                }
                PercentageField.setDisabled(false);
            }
        }
    });

    var SpaceQtyField = new Ext.form.TextField({
        emptyText: '录入后回车校验...',
        width: comwidth,
        id: "SpaceQtyTxt",
        fieldLabel: "间隔数",
        listeners: {
            specialKey: function(field, e) {
                if (e.getKey() == Ext.EventObject.ENTER) {
                    CheckTheoryQty();
                }
            },
            focus: function() {
                GetSpaceQty()
            }
        }
    });

    var WriteQtyField = new Ext.form.TextField({
        width: comwidth,
        id: "WriteQtyTxt",
        fieldLabel: "抽查数"
    });
    WriteQtyField.setDisabled(true);

    var TheoryQtyField = new Ext.form.TextField({
        width: comwidth,
        id: "TheoryQtyTxt",
        fieldLabel: "理论所需总数"
    });
    TheoryQtyField.setDisabled(true);

    var ASpaceQtyField = new Ext.form.TextField({
        width: comwidth,
        id: "ASpaceQtyTxt",
        fieldLabel: "建议间隔数"
    });
    ASpaceQtyField.setDisabled(true);

    var QueryButton = new Ext.Button({
        width: 65,
        id: "QueryButton",
        text: '统计处方总数',
        iconCls: "page_find",
        listeners: {
            "click": function() {
                Ext.MessageBox.confirm('注意', '确认要统计处方吗 ? ', QueryCommentData);
            }
        }
    });

    var SaveButton = new Ext.Button({
        width: 65,
        id: "SaveButton",
        text: '抽取处方样本',
        iconCls: "page_checkout",
        listeners: {
            "click": function() {
                SaveClick();
            }
        }
    });

    /// 就诊类型 
    var OpTypeData = [
        ['门诊', '1'],
        ['急诊', '2'],
        ['全部', '3']
    ];
    var OpTypestore = new Ext.data.SimpleStore({
        fields: ['optypedesc', 'optypeid'],
        data: OpTypeData
    });
    var OpTypeCombo = new Ext.form.ComboBox({
        store: OpTypestore,
        displayField: 'optypedesc',
        mode: 'local',
        width: comwidth,
        id: 'OptypeCmb',
        emptyText: '',
        valueField: 'optypeid',
        emptyText: '就诊类型...',
        fieldLabel: '就诊类型',
        valueNotFoundText: ''
    });



    // 医生
    var ComBoDocDs = new Ext.data.Store({
        autoLoad: true,
        proxy: new Ext.data.HttpProxy({
            url: unitsUrl +
                '?action=GetDoctorDs',
            method: 'POST'
        }),
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows', id: 'doctordr' }, ['docname', 'doctordr'])
    });
    var DoctorCombo = new Ext.form.ComboBox({
        store: ComBoDocDs,
        displayField: 'docname',
        mode: 'local',
        width: comwidth,
        id: 'DoctorCmb',
        emptyText: '',
        valueField: 'doctordr',
        emptyText: '选择医生...',
        fieldLabel: '医生',
        valueNotFoundText: ''
    });
    DocLocSelecter.on(
        'select',
        function() {
            ComBoDocDs.proxy = new Ext.data.HttpProxy({
                url: unitsUrl + '?action=GetDoctorDs&DocLocDrStr=' + Ext.getCmp("DocLocSelecter").getValue(),
                method: 'POST'
            });
            ComBoDocDs.load();
        }
    );


    /// 抗菌药物级别
    var ComCtrlDs = new Ext.data.Store({
        autoLoad: true,
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows', id: 'CtrlID' }, ['CtrlDesc', 'CtrlID'])
    });
    ComCtrlDs.on(
        'beforeload',
        function(ds, o) {
            ds.proxy = new Ext.data.HttpProxy({ url: unitsUrl + '?action=GetComBoCtrlDs', method: 'GET' });
        }
    );
    var ComCtrl = new Ext.ux.form.LovCombo({
        fieldLabel: '抗菌药物级别',
        id: 'ComCtrlID',
        name: 'ComCtrlID',
        store: ComCtrlDs,
        width: comwidth,
        listWidth: 250,
        emptyText: '选择抗菌药物级别...',
        hideOnSelect: false,
        maxHeight: 300,
        valueField: 'CtrlID',
        displayField: 'CtrlDesc',
        triggerAction: 'all',
        mode: 'local'
    });

    /// 医嘱费别
    var BillTypeDs = new Ext.data.Store({
        autoLoad: true,
        proxy: new Ext.data.HttpProxy({
            url: unitsUrl +
                '?action=GetAdmReasonDs',
            method: 'POST'
        }),
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows', id: 'billdr' }, ['billdesc', 'billdr'])

    });
    var BillTypeCombo = new Ext.form.ComboBox({
        store: BillTypeDs,
        displayField: 'billdesc',
        mode: 'local',
        width: comwidth,
        id: 'BillTypeCmb',
        emptyText: '',
        valueField: 'billdr',
        emptyText: '选择医嘱费别...',
        fieldLabel: '医嘱费别',
        valueNotFoundText: ''
    });


    /// 药房
    var PhaLocDs = new Ext.data.Store({
        autoLoad: true,
        proxy: new Ext.data.HttpProxy({
            url: unitsUrl +
                '?action=GetPhaLocDs',
            method: 'POST'
        }),
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows', id: 'phalocdr' }, ['phalocdesc', 'phalocdr'])
    });
    var PhaLocCombo = new Ext.form.ComboBox({
        store: PhaLocDs,
        displayField: 'phalocdesc',
        queryMode: 'remote',
        width: comwidth,
        id: 'PhaLocCmb',
        emptyText: '',
        valueField: 'phalocdr',
        emptyText: '请选择药房...',
        fieldLabel: '药房名称',
        valueNotFoundText: '',
        queryParam: 'combotext',
        minChars: 0
    });

    /// 管制分类
    var PoisonDs = new Ext.data.Store({
        autoLoad: true,
        proxy: new Ext.data.HttpProxy({
            url: unitsUrl +
                '?action=GetPoisonDs',
            method: 'POST'
        }),
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows', id: 'posiondr' }, ['posiondesc', 'posiondr'])
    });
    var PoisonCombo = new Ext.form.ComboBox({
        store: PoisonDs,
        displayField: 'posiondesc',
        mode: 'local',
        width: comwidth,
        listWidth: 250,
        id: 'PoisonCmb',
        emptyText: '',
        valueField: 'posiondr',
        emptyText: '选择管制分类...',
        fieldLabel: '管制分类',
        valueNotFoundText: ''
    });

    /// 基本药物
    var BasicDrugChkBox = new Ext.form.Checkbox({
        fieldLabel: '基本药物',
        id: 'BasicDrugChk',
        inputValue: '1',
        checked: false
    });

    /// 药学分类
    var DrugCatField = new Ext.form.TextField({
        width: 130,
        id: "DrugCatTxt",
        readOnly: true,
        fieldLabel: "药学分类"
    });

    /// 新药学分类    
    var PHCCATALLOTHButton = new Ext.Button({
        id: 'PHCCATALLOTHButton',
        text: '...',
        handler: function() {
            PhcCatNewSelect(gNewCatIdOther, GetAllCatNewList)
        }
    });

    /// 处方金额
    var PrescAmtField = new Ext.form.TextField({
        width: comwidth,
        id: "PrescAmtTxt",
        fieldLabel: "处方金额大于"
    });

    var PatAgeField = new Ext.form.TextField({
        width: comwidth,
        id: "PatAgeTxt",
        fieldLabel: "病人年龄下限"
    })

    var PatAgeLTField = new Ext.form.TextField({
        width: comwidth,
        id: "PatAgeLTTxt",
        fieldLabel: "病人年龄上限" //病人年龄小于
    })

    var RuleForm = new Ext.Panel({
        title: '处方综合点评',
        labelWidth: 80,
        region: 'center',
        frame: true,
        height: 300,
        autoWidth: 'true',
        tbar: [QueryButton], //, "-", SubmitButton],
        layout: 'fit',
        items: [{
            style: "padding-top:10px;",
            layout: 'column',
            xtype: 'fieldset',
            defaults: { border: false },
            items: [{
                columnWidth: 0.25,
                xtype: 'fieldset',
                labelAlign: 'right', //DrugCatButton
                items: [StDateField, OpTypeCombo, PresctypeSelecter, BillTypeCombo, { xtype: 'compositefield', fieldLabel: "药学分类", items: [DrugCatField, PHCCATALLOTHButton] }, PatAgeField, PHCDUSelecter]
            }, {
                columnWidth: 0.25,
                xtype: 'fieldset',
                labelAlign: 'right',
                items: [EndDateField, DocLocSelecter, ComCtrl, PhaLocCombo, PrescAmtField, PatAgeLTField]
            }, {
                columnWidth: 0.25,
                xtype: 'fieldset',
                labelAlign: 'right',
                items: [MaxNumField, DoctorCombo, ArcimSelecter, PoisonCombo, PHCFormSelecter, BasicDrugChkBox]
            }]
        }]
    });

    var CreateForm = new Ext.Panel({
        region: 'center',
        id: 'createfrm',
        frame: true,
        title: '生成点评单',
        height: 300,
        tbar: [SaveButton],
        layout: "fit",
        items: [{
            style: "padding-top:10px;",
            layout: 'column',
            xtype: 'fieldset',
            defaults: { border: false },
            items: [{
                columnWidth: 0.25,
                xtype: 'fieldset',
                labelAlign: 'right',
                items: [ComNoField, WriteQtyField, SpaceQtyField, TheoryQtyField, ASpaceQtyField]
            }, {
                columnWidth: 0.25,
                xtype: 'fieldset',
                labelAlign: 'right',
                items: [{ xtype: 'compositefield', fieldLabel: "随机数", items: [NumRadio, RandomNumField] }]
            }, {
                columnWidth: 0.25,
                xtype: 'fieldset',
                labelAlign: 'right',
                items: [{ xtype: 'compositefield', fieldLabel: "百分比", items: [CentRadio, PercentageField] }]
            }]
        }]
    })

    var QueryForm = new Ext.Panel({
        region: 'center',
        frame: true,
        items: [RuleForm, CreateForm]
    })


    var port = new Ext.Viewport({
        layout: 'border',
        items: [QueryForm]
    });

    ////-----------------Events-----------------///

    function CheckBeforeQuery() {
        var amtnum = Ext.getCmp("PrescAmtTxt").getRawValue();
        var amtnum = trim(amtnum);
        if (!(amtnum > 0) && (amtnum != 0) && (amtnum != "")) {
            Ext.Msg.show({
                title: '注意',
                msg: '处方金额大于填写不正确!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
            return -1;
        }
        var aqenum = Ext.getCmp("PatAgeTxt").getRawValue();
        var aqenum = trim(aqenum);
        if ((!(aqenum > 0)) && (aqenum != 0) && (aqenum != "")) {
            Ext.Msg.show({
                title: '注意',
                msg: '病人年龄下限填写不正确!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
            return -1;
        }
        var aqeltnum = Ext.getCmp("PatAgeLTTxt").getRawValue();
        var aqeltnum = trim(aqeltnum);
        if ((!(aqeltnum > 0)) && (aqeltnum != 0) && (aqeltnum != "")) {
            Ext.Msg.show({
                title: '注意',
                msg: '病人年龄下限填写不正确!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
            return -1;
        }
    }

    function CheckBeforeSave() {
        if (CheckBeforeQuery() < 0) {
            return;
        }
        var maxnum = Ext.getCmp("MaxNumField").getRawValue();
        var maxnum = trim(maxnum);
        if (maxnum == "") {
            Ext.Msg.show({
                title: '注意',
                msg: '请先统计处方总数!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
            return -1;
        }
        if (maxnum == 0) {
            Ext.Msg.show({
                title: '注意',
                msg: '处方总数为0,没有可抽取的处方,请先统计处方总数!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
            return -1;
        }
        if (Ext.getCmp("NumRad").getValue()) {
            var rnum = Ext.getCmp("RandomNumField").getRawValue();
            var rnum = trim(rnum)
            if (rnum == "") {
                Ext.Msg.show({
                    title: '注意',
                    msg: '请先填写随机数!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
                return -1;
            }
            if (!(rnum > 0)) {
                Ext.Msg.show({
                    title: '注意',
                    msg: '随机数格式不正确!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
                return -1;
            }
            var rnumstr = rnum.split(".")
            if (rnumstr[0] !== rnum) {
                Ext.Msg.show({
                    title: '注意',
                    msg: '随机数不能为小数',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
                return -1;
            }
            maxnum = parseFloat(maxnum);
            if (parseFloat(rnum) > parseFloat((maxnum * maxcentnum))) {
                Ext.Msg.show({
                    title: '注意',
                    msg: '随机数超过总处方数的' + maxcentnum * 100 + '%,建议调整随机数!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
                return -1;
            }
        } else {
            var pcent = Ext.getCmp("PercentageField").getRawValue();
            var pcent = trim(pcent)
            if (pcent == "") {
                Ext.Msg.show({
                    title: '注意',
                    msg: '请先填写百分比!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
                return -1;
            }
            if (!(pcent > 0)) {
                Ext.Msg.show({
                    title: '注意',
                    msg: '百分比格式不正确!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
                return -1;
            }
            if (parseFloat(pcent) > (maxcentnum * 100)) {
                Ext.Msg.show({
                    title: '注意',
                    msg: '百分比不能大于' + maxcentnum * 100,
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
                return -1;
            }
            if ((parseFloat(pcent) * parseFloat(maxnum) / 100) < 1) {
                Ext.Msg.show({
                    title: '注意',
                    msg: '按百分比抽取随机数小于1,不能抽取!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
                return -1;
            }
        }
        //间隔数
        var spaceqtynum = Ext.getCmp("SpaceQtyTxt").getRawValue();
        var spaceqtynum = trim(spaceqtynum);
        if ((!(spaceqtynum > 0)) && (spaceqtynum != 0) && (spaceqtynum != "")) {
            Ext.Msg.show({
                title: '注意',
                msg: '间隔数填写不正确!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
            return -1;
        }
        if ((parseInt(spaceqtynum) != spaceqtynum) && (spaceqtynum != "")) {
            Ext.Msg.show({
                title: '注意',
                msg: '间隔数只能填整数!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
            return -1;
        }
        return 0;
    }

    ///获取界面item值
    function GetParStr() {
        var waycode = "P"; //方式
        var sdate = Ext.getCmp("startdt").getRawValue();
        var edate = Ext.getCmp("enddt").getRawValue();
        var doclocdr = Ext.getCmp("DocLocSelecter").getValue(); //科室
        var arcim = Ext.getCmp("ArcimSelecter").getValue(); //医嘱药品
        var rnum = Ext.getCmp("RandomNumField").getValue(); //随机数
        if (trim(rnum) != "") {
            rnum = parseInt(rnum);
        }
        var cent = Ext.getCmp("PercentageField").getValue(); //百分比  
        var optype = Ext.getCmp("OptypeCmb").getValue(); //操作类型
        var doctordr = Ext.getCmp("DoctorCmb").getValue(); //医生
        var ctrlstr = Ext.getCmp("ComCtrlID").getValue(); //分级
        var presctype = Ext.getCmp("PresctypeCmb").getValue(); //处方类型
        var billtype = Ext.getCmp("BillTypeCmb").getValue(); //病人费别
        var phaloc = Ext.getCmp("PhaLocCmb").getValue(); //药房名称
        var poison = Ext.getCmp("PoisonCmb").getValue(); //管制分类
        var phacatstr = Ext.getCmp("DrugCatTxt").getValue(); //药学分类
        var prescamt = Ext.getCmp("PrescAmtTxt").getValue(); //处方金额大于
        var phcform = Ext.getCmp("PHCFormCmb").getValue(); //剂型
        var phcdu = Ext.getCmp("PHCDUCmb").getValue(); //疗程
        var basicdrug = Ext.getCmp("BasicDrugChk").getValue(); //基本药物
        if (basicdrug) {
            var basicdrugflag = 1
        } else {
            var basicdrugflag = 0
        }
        var patage = Ext.getCmp("PatAgeTxt").getValue(); //病人年龄大于
        var patagelt = Ext.getCmp("PatAgeLTTxt").getValue(); //病人年龄小于
        var spaceqty = Ext.getCmp("SpaceQtyTxt").getValue(); //间隔数
        if (trim(spaceqty) != "") {
            spaceqty = parseInt(spaceqty);
        }
        parstr = sdate + "^" + edate + "^" + doclocdr + "^" + arcim + "^" + rnum + "^" + cent + "^" + optype + "^" + doctordr + "^" + ctrlstr + "^" + waycode + "^" + presctype + "^" + billtype + "^" + phaloc;
        parstr = parstr + "^" + poison + "^" + gNewCatIdOther + "^" + prescamt + "^" + basicdrugflag + "^" + patage + "^" + spaceqty + "^" + patagelt + "^" + phcform + "^" + phcdu
        return parstr;
    }

    /// 统计处方数
    function QueryCommentData(btn) {
        if (btn == "no") {
            return;
        }
        systaskflag = ""; //清空任务标志      
        if (CheckBeforeQuery() < 0) {
            return;
        }
        Ext.getCmp("MaxNumField").setValue("");
        Ext.getCmp("ASpaceQtyTxt").setValue("");
        Ext.getCmp("WriteQtyTxt").setValue("");
        Ext.getCmp("SpaceQtyTxt").setValue("");
        Ext.getCmp("TheoryQtyTxt").setValue("");
        Ext.getCmp("ComNoField").setValue("");
        Ext.getCmp("RandomNumField").setValue("");
        Ext.getCmp("PercentageField").setValue("");
        waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候...", removeMask: true });
        waitMask.show();
        var params = GetParStr();
        var userId = session['LOGON.USERID'];
        var locId = session['LOGON.CTLOCID'];
        var pid = tkMakeServerCall("web.DHCSTCNTS.Main", "JobGetPrescDataNum", params, locId);
        // 调后台,5s一次
        var jobInterval = setInterval(function() {
            var jobRet = tkMakeServerCall("web.DHCSTCNTS.Main", "JobRecieve", pid);
            if (jobRet != "") {
                clearInterval(jobInterval);
                waitMask.hide();
                var jobRetArr = jobRet.split("^");
                var jobRetSucc = jobRetArr[0];
                var jobRetVal = jobRetArr[1];
                if (jobRetSucc < 0) {
                    Ext.Msg.show({
                        title: '提示',
                        msg: jobRetVal,
                        buttons: Ext.Msg.OK,
                        icon: Ext.MessageBox.INFO
                    });
                } else {
                    if (jobRetVal == 0) {
                        var msgInfo = "没有符合条件的处方,请更换查询条件后再试!";
                        Ext.Msg.show({ title: '提示', msg: msgInfo, buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
                    } else {
                        Ext.getCmp("MaxNumField").setValue(jobRetVal);
                    }
                }

            }
        }, 5000);
    }

    /// 保存动作
    function SaveClick() {
        var ret = CheckBeforeSave();
        if (ret < 0) {
            return;
        }
        if (CheckTheoryQty()) {
            Ext.MessageBox.confirm('注意', '确认要生成普通处方点评单吗 ? ', SaveCommentData);
        }
    }

    /// 生成点评单
    function SaveCommentData(btn) {
        if (btn == "no") {
            return;
        }
        parstr = GetParStr();
        waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候...", removeMask: true });
        waitMask.show();
        var params = GetParStr();
        var userId = session['LOGON.USERID'];
        var locId = session['LOGON.CTLOCID'];
        var pid = tkMakeServerCall("web.DHCSTCNTS.Main", "JobSaveCommentData", params, locId, userId);
        // 调后台
        var jobInterval = setInterval(function() {
            var jobRet = tkMakeServerCall("web.DHCSTCNTS.Main", "JobRecieve", pid);
            if (jobRet != "") {
                clearInterval(jobInterval);
                waitMask.hide();
                var jobRetArr = jobRet.split("^");
                var jobRetSucc = jobRetArr[0];
                var jobRetVal = jobRetArr[1];
                if (jobRetSucc < 0) {
                    Ext.Msg.show({ title: '提示', msg: jobRetVal, buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
                } else {
                    Ext.Msg.show({ title: '提示', msg: "抽取成功", buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
                    Ext.getCmp("ComNoField").setValue(jobRetVal);
                }

            }
        }, 5000);
    }

    /// 新药理学分类
    function GetAllCatNewList(catdescstr, newcatid) {
        Ext.getCmp("DrugCatTxt").setValue(catdescstr);
        gNewCatIdOther = newcatid;
    }

    /// 计算理论最大数
    function CheckTheoryQty() {
        if (CheckBeforeSave() < 0) {
            return false;
        }
        var advqty = Ext.getCmp("ASpaceQtyTxt").getRawValue();
        var advqty = parseInt(advqty);
        var maxnum = Ext.getCmp("MaxNumField").getRawValue();
        var writeqty = Ext.getCmp("WriteQtyTxt").getRawValue();
        var writeqty = trim(writeqty);
        var spaceqty = Ext.getCmp("SpaceQtyTxt").getRawValue();
        var spaceqty = trim(spaceqty);
        if (spaceqty == 0) { return true; }
        if (spaceqty == "") {
            return true;
        } else {
            spaceqty = parseInt(spaceqty);
        }
        var theorymax = parseInt(writeqty * spaceqty)

        if (spaceqty > 0) {

            if (spaceqty > advqty) {
                Ext.Msg.show({
                    title: '错误',
                    msg: '大于建议间隔数,不能进行!请参考建议间隔数,重新更改录入间隔数！',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
                return false;
            } else {
                Ext.getCmp("TheoryQtyTxt").setValue(theorymax);
                return true;
            }
        } else {
            return false;
        }
    }

    // 计算间隔数,理论最大值
    function GetSpaceQty() {
        var spaceqty = Ext.getCmp("SpaceQtyTxt").getRawValue();
        var spaceqty = trim(spaceqty);
        if (spaceqty == "") { spaceqty = 0; }
        var rnum = Ext.getCmp("RandomNumField").getRawValue();
        var rnum = trim(rnum);
        var maxnum = Ext.getCmp("MaxNumField").getRawValue();
        if (rnum != "") {
            var rnum = parseInt(rnum);
            var writeqty = rnum;

        } else {
            var cent = Ext.getCmp("PercentageField").getRawValue();
            var cent = trim(cent);
            var rnum = parseInt(maxnum * cent / 100);
            var writeqty = rnum;
        }
        Ext.getCmp("WriteQtyTxt").setValue(writeqty);
        if (rnum != 0) {
            Ext.getCmp("ASpaceQtyTxt").setValue(Math.floor(maxnum / rnum));
        } else {
            Ext.getCmp("ASpaceQtyTxt").setValue("");
        }
        if (spaceqty == 0) {
            Ext.getCmp("TheoryQtyTxt").setValue('');
        } else {
            Ext.getCmp("TheoryQtyTxt").setValue(parseInt(writeqty * spaceqty));
        }
    }

    /// 检查随机数
    function CheckRNumber() {
        var rnum = Ext.getCmp("RandomNumField").getRawValue();
        var rnum = trim(rnum);
        var maxnum = Ext.getCmp("MaxNumField").getRawValue();
        var maxnum = trim(maxnum);
        if (Math.floor(maxnum * maxcentnum) < rnum) {
            Ext.Msg.show({ title: '错误', msg: '随机数不能超出处方总数抽查范围,请重新录入！', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
            return -1;
        }
        if (Math.floor(maxnum / 30) > rnum) {
            Ext.MessageBox.confirm('注意', '建议随机数不能小于处方总数百分之30,是否重新录入? ', function(btn) {
                if (btn == "yes") {
                    return -1;
                } else {
                    return 0;
                }
            })
        } else {
            return 0;
        }
    }
});


/* 如下为提交系统任务,升级后不再使用*/
/*
var SubmitButton = new Ext.Button({
	width: 65,
	id: "SubmitButton",
	text: '提交系统任务',
	iconCls: "page_save",
	listeners: {
		"click": function() {
			SubmitClick();
		}
	}
});
/// 提交系统任务-停用
function SubmitClick() {
    if (CheckDataBeforeSave() == true) {
        Ext.MessageBox.confirm('注意', '确认要提交系统任务吗 ? ', SaveSysTask);
    }　
}

/// 保存系统任务
function SaveSysTask(btn) {
    var num = Ext.getCmp("RandomNumField").getValue(); //随机数
    if (Ext.getCmp("NumRad").getValue()) {
        if (!(parseInt(num) > 0)) {
            Ext.Msg.show({ title: '错误', msg: '随机数必须大于0的整数!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
            return;
        }
    }
    var cent = Ext.getCmp("PercentageField").getValue(); //百分比 
    if (Ext.getCmp("CentRad").getValue()) {
        if (!(parseInt(cent) > 0)) {
            Ext.Msg.show({ title: '错误', msg: '随机百分比必须大于0的整数!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
            return;
        }
    }
    var spaceqtynum = Ext.getCmp("SpaceQtyTxt").getRawValue();
    if (btn == "no") { return; }
    parstr = GetParStr();
    var User = session['LOGON.USERID'];
    waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候...", removeMask: true });
    waitMask.show();
    Ext.Ajax.request({
        url: unitsUrl + '?action=SaveSysTask&User=' + User + '&ParStr=' + parstr,
        method: 'POST',
        failure: function(result, request) {
            waitMask.hide();
            Ext.Msg.show({
                title: '错误',
                msg: '请检查网络连接!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
        },
        success: function(result, request) {
            waitMask.hide();
            var jsonData = Ext.util.JSON.decode(result.responseText);
            if (jsonData.retvalue > 0) {
                msgtxt = "提交成功";
                systaskflag = "";
                Ext.getCmp("ComNoField").setValue(jsonData.retinfo);
            } else {
                msgtxt = jsonData.retinfo;
            }
            Ext.Msg.show({
                title: '提示',
                msg: msgtxt,
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
        },
        scope: this
    });
}

// 松查是否可以提交任务
function CheckDataBeforeSave() {
    if (systaskflag != "1") {
        var maxnum = Ext.getCmp("MaxNumField").getRawValue();
        var maxnum = trim(maxnum);
        if (maxnum > 0) {
            Ext.Msg.show({
                title: '错误',
                msg: '可以实时显示处方总数,不允许提交任务！',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
        } else {
            Ext.Msg.show({
                title: '错误',
                msg: '请尝试点击<统计处方总数>,如果系统查询时长超2分钟,则点击提交任务！',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
        }
        return false;
    }
    return true;
}

/// 库存项名称
  var ComBoIncitmDs = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: unitsUrl,
            method: 'POST'
        }),
        reader: new Ext.data.JsonReader({
            totalProperty: "results",
            root: 'rows',
            id: 'rowId'
        }, ['rowId', 'itmcode', 'itmdesc'])
    });
    var tpl = new Ext.XTemplate(
        '<table cellpadding=2 cellspacing = 1><tbody>',
        '<tr><th style="font-weight: bold; font-size:15px;">药品名称</th><th style="font-weight: bold; font-size:15px;">编码</th><th style="font-weight: bold; font-size:15px;">ID</th></tr>',
        '<tpl for=".">',
        '<tr class="combo-item">',
        '<td style="width:500; font-size:15px;">{itmdesc}</td>',
        '<td style="width:20%; font-size:15px;">{itmcode}</td>',
        '<td style="width:50; font-size:15px;">{rowId}</td>',
        '</tr>',
        '</tpl>', '</tbody></table>');
    var IncitmSelecter = new Ext.form.ComboBox({
        id: 'InciSelecter',
        fieldLabel: '药品名称',
        store: ComBoIncitmDs,
        valueField: 'rowId',
        displayField: 'itmdesc',
        //typeAhead : true,
        pageSize: 50,
        //minChars : 1,
        width: comwidth,
        // heigth : 150,
        autoHeight: true,
        listWidth: 550,
        triggerAction: 'all',
        emptyText: '选择药品名称...',
        //allowBlank : false,
        name: 'IncitmSelecter',
        selectOnFocus: true,
        forceSelection: true,
        tpl: tpl,
        itemSelector: 'tr.combo-item',
        listeners: {
            specialKey: function(field, e) {
                if (e.getKey() == Ext.EventObject.ENTER) {
                    ComBoIncitmDs.proxy = new Ext.data.HttpProxy({
                        url: unitsUrl +
                            '?action=GetIncitmDs&searchItmValue=' +
                            Ext.getCmp('InciSelecter').getRawValue(),
                        method: 'POST'
                    })
                    ComBoIncitmDs.reload({
                        params: {
                            start: 0,
                            limit: IncitmSelecter.pageSize
                        }
                    });
                }
            }
        }
    });
*/