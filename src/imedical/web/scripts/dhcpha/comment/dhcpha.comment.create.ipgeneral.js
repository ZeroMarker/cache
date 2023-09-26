/// 住院医嘱点评

/// 调取后台csp
var unitsUrl = 'dhcpha.comment.main.save.csp';

/// 默认值
var comwidth = 150;
var ruleformwd = 800;
var systaskflag = "";
var maxcentnum = 0.8; //最大抽取百分比数
var gNewCatIdOther = ""; // 新药理学分类

Ext.onReady(function() {
    Ext.QuickTips.init(); // 浮动信息提示
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

    var StDateField = new Ext.form.DateField({
        xtype: 'datefield',
        fieldLabel: '开始日期',
        name: 'startdt',
        id: 'startdt',
        width: comwidth,
        value: new Date
    })

    var EndDateField = new Ext.form.DateField({
        fieldLabel: '截止日期',
        name: 'enddt',
        id: 'enddt',
        width: comwidth,
        value: new Date
    })

    /// 随机数
    var RandomNumField = new Ext.form.TextField({
        width: comwidth,
        id: "RandomNumField"
    });

    /// 百分比
    var PercentageField = new Ext.form.TextField({
        width: comwidth,
        id: "PercentageField"
    })
    PercentageField.setDisabled(true);

    var NumRadio = new Ext.form.Radio({
        fieldLabel: '随机数',
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
        fieldLabel: '百分比',
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

    })
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

    var ComNoField = new Ext.form.TextField({
        height: 25,
        width: comwidth,
        id: "ComNoField",
        fieldLabel: "点评单号"
    });
    ComNoField.setDisabled(true);

    var MaxNumField = new Ext.form.TextField({
        width: comwidth,
        id: "MaxNumField",
        fieldLabel: "出院人数"
    });
    MaxNumField.setDisabled(true);

    var QueryButton = new Ext.Button({
        width: 65,
        id: "QueryButton",
        text: '统计出院人数',
        iconCls: "page_find",
        listeners: {
            "click": function() {
                Ext.MessageBox.confirm('注意', '确认要统计出院人数吗 ? ', QueryLeaveHosNum);
            }
        }
    });

    var SaveButton = new Ext.Button({
        width: 65,
        id: "SaveButton",
        text: '抽取出院病历',
        iconCls: "page_checkout",
        listeners: {
            "click": function() {
                SaveClick();
            }
        }
    });

    /// 医生科室
    var ComBoDocLocDs = new Ext.data.Store({
        autoLoad: true,
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows', id: 'DocLocID' }, ['DocLocDesc', 'DocLocID'])
    });
    ComBoDocLocDs.on(
        'beforeload',
        function(ds, o) {
            ds.proxy = new Ext.data.HttpProxy({
                url: unitsUrl + '?action=GetDocLocDs',
                method: 'GET'
            });
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
        triggerAction: 'all',
        showSelectAll: true,
        queryMode: 'remote',
        queryParam: 'combotext',
        resizable: true,
        minChars: 1
    });

    /// 医生
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


    // 抗菌药物级别
    var ComCtrlDs = new Ext.data.Store({
        autoLoad: true,
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows', id: 'CtrlID' }, ['CtrlDesc', 'CtrlID'])
    });
    ComCtrlDs.on(
        'beforeload',
        function(ds, o) {
            ds.proxy = new Ext.data.HttpProxy({
                url: unitsUrl + '?action=GetComBoCtrlDs',
                method: 'GET'
            });
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

    /// 社会地位
    var BillTypeDs = new Ext.data.Store({
        autoLoad: true,
        proxy: new Ext.data.HttpProxy({
            url: unitsUrl +
                '?action=GetBillTypeDs',
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
        emptyText: '选择患者费用类型...',
        fieldLabel: '患者费用类型',
        valueNotFoundText: ''
    });

    /// 药房
    var PhaLocDs = new Ext.data.Store({
        autoLoad: true,
        proxy: new Ext.data.HttpProxy({
            url: unitsUrl +
                '?action=GetIPPhaLocDs',
            method: 'POST'
        }),
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows', id: 'phalocdr' }, ['phalocdesc', 'phalocdr'])
    });
    var PhaLocCombo = new Ext.form.ComboBox({
        store: PhaLocDs,
        displayField: 'phalocdesc',
        queryMode: 'remote',
        width: comwidth,
        listWidth: 250,
        id: 'PhaLocCmb',
        emptyText: '',
        valueField: 'phalocdr',
        emptyText: '选择药房名称...',
        fieldLabel: '药房名称',
        queryParam: 'combotext',
        valueNotFoundText: '',
        minChars: 0
    });

    /// 基本药物
    var BasicDrugChkBox = new Ext.form.Checkbox({
        fieldLabel: '基本药物',
        id: 'BasicDrugChk',
        inputValue: '1',
        checked: false
    })

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

    /// 病人年龄
    var PatAgeField = new Ext.form.TextField({
        width: comwidth,
        id: "PatAgeTxt",
        fieldLabel: "病人年龄下限"
    })


    // 医嘱名称
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

    var RuleForm = new Ext.Panel({
        title: '住院医嘱点评',
        labelWidth: 80,
        region: 'center',
        frame: true,
        height: 230,
        tbar: [QueryButton],
        layout: "fit",
        items: [{
            layout: 'column',
            xtype: 'fieldset',
            defaults: { border: false },
            style: "padding-top:10px;",
            items: [{
                columnWidth: 0.25,
                xtype: 'fieldset',
                labelAlign: 'right',
                items: [StDateField, DocLocSelecter, PoisonCombo, { xtype: 'compositefield', fieldLabel: "药学分类", items: [DrugCatField, PHCCATALLOTHButton] }]
            }, {
                columnWidth: 0.25,
                xtype: 'fieldset',
                labelAlign: 'right',
                items: [EndDateField, ArcimSelecter, ComCtrl, PhaLocCombo]
            }, {
                columnWidth: 0.25,
                xtype: 'fieldset',
                labelAlign: 'right',
                items: [MaxNumField, DoctorCombo, PatAgeField, BillTypeCombo, BasicDrugChkBox]
            }]
        }]
    });

    var CreateForm = new Ext.Panel({
        region: 'center',
        frame: true,
        title: '生成点评单',
        height: 230,
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
    });

    var QueryForm = new Ext.Panel({
        region: 'center',
        frame: true,
        items: [RuleForm, CreateForm]
    })

    /// 框架定义
    var port = new Ext.Viewport({
        layout: 'fit',
        items: [QueryForm]
    });

    ////-----------------Events-----------------///

    function CheckBeforeQuery() {
        var aqenum = Ext.getCmp("PatAgeTxt").getRawValue();
        var aqenum = trim(aqenum);
        if ((!(aqenum > 0)) && (aqenum != 0) && (aqenum != "")) {
            Ext.Msg.show({
                title: '注意',
                msg: '病人年龄下限格式填写不正确!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
            return -1;
        }
    }

    /// 统计出院人数
    function QueryLeaveHosNum(btn) {
        if (btn == "no") {
            return;
        }
        var params = GetParStr();
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

        var userId = session['LOGON.USERID'];
        var locId = session['LOGON.CTLOCID'];
        var pid = tkMakeServerCall("web.DHCSTCNTS.Main", "JobGetLeavePersonNum", params, locId);
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
                    Ext.Msg.show({
                        title: '提示',
                        msg: jobRetVal,
                        buttons: Ext.Msg.OK,
                        icon: Ext.MessageBox.INFO
                    });
                } else {
                    if (jobRetVal == 0) {
                        var msgInfo = "没有符合条件的出院病历,请更换查询条件后再试!";
                        Ext.Msg.show({
                            title: '提示',
                            msg: msgInfo,
                            buttons: Ext.Msg.OK,
                            icon: Ext.MessageBox.INFO
                        });
                    } else {
                        Ext.getCmp("MaxNumField").setValue(jobRetVal);
                    }
                }

            }
        }, 5000);
    }

    function SaveClick() {
        var ret = CheckBeforeSave();
        if (ret < 0) {
            return;
        }
        if (CheckTheoryQty()) {
            Ext.MessageBox.confirm('注意', '确认要生成住院医嘱点评单吗 ? ', SaveIPCommentData);
        }
    }

    function SaveIPCommentData(btn) {
        if (btn == "no") {
            return;
        }
        waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候...", removeMask: true });
        waitMask.show();
        var params = GetParStr();
        var userId = session['LOGON.USERID'];
        var locId = session['LOGON.CTLOCID'];
        var pid = tkMakeServerCall("web.DHCSTCNTS.Main", "JobSaveIPCommentData", params, locId, userId);
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
                    Ext.Msg.show({
                        title: '提示',
                        msg: jobRetVal,
                        buttons: Ext.Msg.OK,
                        icon: Ext.MessageBox.INFO
                    });
                } else {
                    Ext.Msg.show({
                        title: '提示',
                        msg: "抽取成功",
                        buttons: Ext.Msg.OK,
                        icon: Ext.MessageBox.INFO
                    });
                    Ext.getCmp("ComNoField").setValue(jobRetVal);
                }
            }
        }, 5000);
    }

    /// 获取界面item值
    function GetParStr() {
        var waycode = "IP"; //方式
        var sd = Ext.getCmp("startdt").getRawValue();
        var ed = Ext.getCmp("enddt").getRawValue();
        var rum = Ext.getCmp("RandomNumField").getRawValue();
        var doclocdr = Ext.getCmp("DocLocSelecter").getValue(); //科室
        var arcim = Ext.getCmp("ArcimSelecter").getValue(); //药品
        var doctordr = Ext.getCmp("DoctorCmb").getValue(); //医生
        var billtype = Ext.getCmp("BillTypeCmb").getValue(); //病人费别  
        var poison = Ext.getCmp("PoisonCmb").getValue(); //管制分类
        var patage = Ext.getCmp("PatAgeTxt").getValue(); //病人年龄大于 
        var ctrlstr = Ext.getCmp("ComCtrlID").getValue(); //抗菌药物级别 
        var phaloc = Ext.getCmp("PhaLocCmb").getValue(); //药房名称   
        var basicdrug = Ext.getCmp("BasicDrugChk").getValue(); //基本药物  
        if (basicdrug) {
            var basicdrugflag = 1;
        } else {
            var basicdrugflag = 0;
        }
        var spaceqty = Ext.getCmp("SpaceQtyTxt").getValue(); //间隔数
        var cent = Ext.getCmp("PercentageField").getValue(); //百分比
        parstr = sd + "^" + ed + "^" + rum + "^" + doclocdr + "^" + cent + "^" + arcim + "^" + doctordr + "^" + poison;
        parstr = parstr + "^" + ctrlstr + "^" + patage + "^" + spaceqty + "^" + billtype + "^" + gNewCatIdOther + "^" + phaloc + "^" + basicdrug + "^" + waycode;
        return parstr;
    }

    ///提交任务前检查 
    function CheckDataBeforeSave() {
        var maxnum = Ext.getCmp("MaxNumField").getRawValue();
        var maxnum = trim(maxnum);
        if (systaskflag != "1") {
            if (maxnum > 0) {
                Ext.Msg.show({
                    title: '错误',
                    msg: '可以统计出院人数,不允许提交任务！',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
            } else {
                Ext.Msg.show({
                    title: '错误',
                    msg: '请先点击<统计出院人数>,如果可以实时显示出院人数,则不允许提交任务！',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
            }
            return false;
        }
        return true;
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
                msg: '未统计出院人数不能抽取出院病历，请先统计出院人数!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
            return -1;
        }

        if (maxnum == 0) {
            Ext.Msg.show({
                title: '注意',
                msg: '出院人数为0,没有可抽取的处方,请先统计处方总数!',
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

            maxnum = parseFloat(maxnum);
            if (parseFloat(rnum) > parseFloat(maxnum)) {
                Ext.Msg.show({
                    title: '注意',
                    msg: '随机数超过总处方数,建议调整随机数!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
                return -1;
            }

            if ((!(parseFloat(rnum) > 0)) || (parseFloat(rnum) % 1 > 0)) {

                Ext.Msg.show({
                    title: '注意',
                    msg: '随机数不合法!',
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
            if (!(parseFloat(pcent) > 0)) {
                Ext.Msg.show({
                    title: '注意',
                    msg: '百分比格式不正确!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
                return -1;
            }

            if (parseFloat(pcent) > 100) {
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

    //计算理论最大数
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
        if (spaceqty == 0) {
            return true;
        }
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

    /// 计算间隔数,理论最大数
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
        if (Math.floor(maxnum) < rnum) {
            Ext.Msg.show({
                title: '错误',
                msg: '随机数不能大于处方总数,请重新录入！',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
            return -1;
        }
        if (!(Math.floor(maxnum) > 0)) {
            Ext.MessageBox.confirm('注意', '建议随机数不能小于0,是否重新录入? ', function(btn) {
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

    /// 返回药学分类值
    SetDrugCatTxt = function(retcatstr) {
            Ext.getCmp("DrugCatTxt").setValue(retcatstr);
        }
        /// 新药理学分类
    function GetAllCatNewList(catdescstr, newcatid) {
        Ext.getCmp("DrugCatTxt").setValue(catdescstr);
        gNewCatIdOther = newcatid;

    }
});

/* 如下为提交系统任务,升级后不再使用*/
/*
/// 提交系统任务   
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
/// 提交任务
function SubmitClick() {
    if (CheckDataBeforeSave() == true) {
        var maxnum = Ext.getCmp("MaxNumField").getRawValue();
        var maxnum = trim(maxnum);
        if (maxnum == "") {
            Ext.MessageBox.confirm('注意', '确认要提交系统任务吗 ? ', SaveSysTask);
        }
    }　
}

//保存系统任务
function SaveSysTask(btn) {
    var num = Ext.getCmp("RandomNumField").getValue(); //随机数
    if (Ext.getCmp("NumRad").getValue()) {
        if (!(parseInt(num) > 0)) {
            Ext.Msg.show({
                title: '错误',
                msg: '随机数必须大于0的整数!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
            return;
        }
    }

    var cent = Ext.getCmp("PercentageField").getValue(); //百分比 
    if (Ext.getCmp("CentRad").getValue()) {
        if (!(parseInt(cent) > 0)) {
            Ext.Msg.show({
                title: '错误',
                msg: '随机百分比必须大于0的整数!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
            return;
        }
    }
    var spaceqtynum = Ext.getCmp("SpaceQtyTxt").getRawValue();
    if (btn == "no") {
        return;
    }
    parstr = GetParStr();
    var User = session['LOGON.USERID'];
    waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候...", removeMask: true });
    waitMask.show();
    Ext.Ajax.request({
        url: unitsUrl + '?action=SaveIPSysTask&User=' + User + '&ParStr=' + parstr,
        method: 'POST',
        failure: function(result, request) {
            waitMask.hide();
            Ext.Msg.show({ title: '错误', msg: '请检查网络连接!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
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
            Ext.Msg.show({ title: '提示', msg: msgtxt, buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });

        },
        scope: this
    });
}
*/