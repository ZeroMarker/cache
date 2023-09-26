/// 成人专项点评
/// Creator:LiangQiang
/// CreatDate:2012-05-20

var unitsUrl = 'dhcpha.comment.main.save.csp';

var comwidth = 150;
var ruleformwd = 800;
var parstr = "";
var maxcent = 0.8; //抽取最大比例

Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.Ajax.timeout = 900000;
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

    // 定义医生科室
    var ComBoDocLocDs = new Ext.data.Store({
        autoLoad: true,
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows', id: 'DocLocID' }, ['DocLocDesc', 'DocLocID'])
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
        hiddenName: 'doclocstr',
        maxHeight: 300,
        valueField: 'DocLocID',
        displayField: 'DocLocDesc',
        triggerAction: 'all',
        queryMode: 'remote',
        queryParam: 'combotext',
        minChars: 1
    });

    var StDateField = new Ext.form.DateField({
        xtype: 'datefield',
        //format:'j/m/Y' ,
        fieldLabel: '开始日期',
        name: 'startdt',
        id: 'startdt',
        //invalidText:'无效日期格式,正确格式是:日/月/年,如:15/02/2011',
        width: comwidth,
        value: new Date
    });

    var EndDateField = new Ext.form.DateField({
        //format:'j/m/Y' ,
        fieldLabel: '截止日期',
        name: 'enddt',
        id: 'enddt',
        width: comwidth,
        value: new Date
    });

    var RandomNumField = new Ext.form.TextField({
        width: comwidth,
        id: "RandomNumField",
        fieldLabel: "随机数"
    });

    var AgeField = new Ext.form.TextField({
        width: comwidth,
        id: "agetxt",
        fieldLabel: "患者年龄"
    })
    AgeField.setDisabled(true);
    Ext.getCmp("agetxt").setValue(">15岁"); //

    ///类型 
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
        hiddenName: 'optypeid',
        emptyText: '选择类型...',
        fieldLabel: '类型'
    });
    Ext.getCmp("OptypeCmb").setValue("1");

    /// 定义分级
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
        //emptyText:'选择抗菌药物级别...',
        hideOnSelect: false,
        hiddenName: 'poisonstr',
        maxHeight: 300,
        valueField: 'CtrlID',
        displayField: 'CtrlDesc',
        triggerAction: 'all',
        mode: 'local'
    });

    var ComNoField = new Ext.form.TextField({
        height: 25,
        width: comwidth,
        id: "ComNoField",
        fieldLabel: "点评单号"
    })
    ComNoField.setDisabled(true);

    var MaxNumField = new Ext.form.TextField({
        width: comwidth,
        id: "MaxNumField",
        fieldLabel: "处方总数"
    })
    MaxNumField.setDisabled(true);

    var QueryButton = new Ext.Button({
        width: 65,
        id: "QueryButton",
        text: '统计处方总数',
        iconCls: "page_find",
        listeners: {
            "click": function() {
                QueryClick();
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

    var RuleForm = new Ext.Panel({
        title: '成人专项点评',
        labelWidth: 80,
        region: 'center',
        frame: true,
        height: 180,
        tbar: [QueryButton],
        layout: 'fit',
        items: [{
            style: "padding-top:10px;",
            layout: 'column',
            xtype: 'fieldset',
            defaults: { border: false },
            items: [{
                columnWidth: 0.25,
                xtype: 'fieldset',
                labelAlign: 'right',
                items: [StDateField, AgeField, MaxNumField]
            }, {
                columnWidth: 0.25,
                xtype: 'fieldset',
                labelAlign: 'right',
                items: [EndDateField, DocLocSelecter]
            }, {
                columnWidth: 0.25,
                xtype: 'fieldset',
                labelAlign: 'right',
                items: [OpTypeCombo, ComCtrl]
            }]
        }]
    });

    var CreateForm = new Ext.Panel({
        region: 'center',
        frame: true,
        title: '生成点评单',
        height: 150,
        tbar: [SaveButton],
        layout: 'fit',
        items: [{
            style: "padding-top:10px;",
            layout: 'column',
            xtype: 'fieldset',
            defaults: { border: false },
            items: [{
                columnWidth: 0.25,
                xtype: 'fieldset',
                labelAlign: 'right',
                items: [ComNoField, RandomNumField]
            }]
        }]
    })

    var QueryForm = new Ext.Panel({
        region: 'center',
        frame: true,
        items: [RuleForm, CreateForm]
    });

    var port = new Ext.Viewport({
        layout: 'fit',
        items: [QueryForm]
    });

    ////-----------------Events-----------------///
    //统计动作
    function QueryClick() {
        Ext.getCmp("RandomNumField").setValue("");
        Ext.getCmp("ComNoField").setValue("");
        Ext.MessageBox.confirm('注意', '确认要统计处方吗 ? ', QueryACommentData);
    }

    function GetParStr() {
        var waycode = "C"; //方式
        var sd = Ext.getCmp("startdt").getRawValue();
        var ed = Ext.getCmp("enddt").getRawValue();
        var rnum = Ext.getCmp("RandomNumField").getRawValue();
        var doclocstr = Ext.getCmp("DocLocSelecter").getValue(); //
        var poisonstr = Ext.getCmp("ComCtrlID").getValue(); //
        var optype = Ext.getCmp("OptypeCmb").getValue(); //操作类型
        var minage = Ext.getCmp("agetxt").getValue();
        var parstr = sd + "^" + ed + "^" + rnum + "^" + doclocstr + "^" + poisonstr + "^" + optype + "^" + waycode + "^" + minage;
        return parstr;
    }

    ///统计处方数
    function QueryACommentData(btn) {
        if (btn == "no") {
            return;
        }
        waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候...", removeMask: true });
        waitMask.show();
        var params = GetParStr();
        var userId = session['LOGON.USERID'];
        var locId = session['LOGON.CTLOCID'];
        var pid = tkMakeServerCall("web.DHCSTCNTS.Main", "JobGetAdultPrescDataNum", params, locId);
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
                    Ext.getCmp("MaxNumField").setValue("");
                } else {
                    if (jobRetVal == 0) {
                        var msgInfo = "没有符合条件的处方,请更换查询条件后再试!";
                        Ext.Msg.show({
                            title: '提示',
                            msg: msgInfo,
                            buttons: Ext.Msg.OK,
                            icon: Ext.MessageBox.INFO
                        });
                        Ext.getCmp("MaxNumField").setValue("");
                    } else {
                        Ext.getCmp("MaxNumField").setValue(jobRetVal);
                    }
                }
            }
        }, 5000);
    }

    /// 检查
    function CheckBeforeSave() {
        var maxnum = Ext.getCmp("MaxNumField").getRawValue();
        var maxnum = trim(maxnum);
        if (maxnum == "") {
            Ext.Msg.show({
                title: '注意',
                msg: '请先统计处方总数!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return -1;
        }

        if (maxnum == 0) {
            Ext.Msg.show({
                title: '注意',
                msg: '处方总数为0,没有可抽取的处方,请先统计处方总数!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return -1;
        }

        var rnum = Ext.getCmp("RandomNumField").getRawValue();
        var rnum = trim(rnum);
        if (rnum == "") {
            Ext.Msg.show({
                title: '注意',
                msg: '请先填写随机数!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return -1;
        }
        if (!(rnum > 0)) {
            Ext.Msg.show({
                title: '注意',
                msg: '随机数格式不正确!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return -1;
        }
        if (rnum.indexOf(".") > -1) {
            Ext.Msg.show({
                title: '注意',
                msg: '随机数不能为小数!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return -1;
        }
        if (rnum > 200) {
            Ext.Msg.show({
                title: '注意',
                msg: '随机数量不能大于200!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return -1;
        }
        if (parseFloat(rnum) > ((parseFloat(maxnum)) * maxcent)) {
            Ext.Msg.show({
                title: '注意',
                msg: '随机数量不能大于处方总数*' + maxcent,
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return -1;
        }
        return 0;
    }

    function SaveClick() {
        var ret = CheckBeforeSave();
        if (ret < 0) {
            return;
        }
        Ext.MessageBox.confirm('注意', '确认要生成成人处方点评单吗 ? ', SaveACommentData);
    }

    function SaveACommentData(btn) {
        if (btn == "no") {
            return;
        }
        var params = GetParStr();
        waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候...", removeMask: true });
        waitMask.show();
        var userId = session['LOGON.USERID'];
        var locId = session['LOGON.CTLOCID'];
        var pid = tkMakeServerCall("web.DHCSTCNTS.Main", "JobSaveAdultCommentData", params, locId, userId);
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
});