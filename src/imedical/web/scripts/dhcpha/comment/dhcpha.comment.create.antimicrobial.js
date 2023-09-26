/// 抗菌药专项点评
/// Creator:LiangQiang
/// CreatDate:2012-05-20

var unitsUrl = 'dhcpha.comment.main.save.csp';

var comwidth = 150;
var ruleformwd = 800;
var parstr = "";
var systaskflag = "";

Ext.onReady(function() {
    Ext.QuickTips.init(); // 浮动信息提示
    Ext.Ajax.timeout = 900000;
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

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

    var DocCentField = new Ext.form.TextField({
        width: comwidth,
        id: "DocCentField",
        fieldLabel: "医生比例(具开抗生素资质)"
    });
    Ext.getCmp("DocCentField").setValue("50");

    var PrescCentField = new Ext.form.TextField({
        width: comwidth,
        id: "PrescCentField",
        fieldLabel: "处方张数(每位医生)"
    })
    Ext.getCmp("PrescCentField").setValue("50");

    /// 定义分级
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
    var ComBoCtrl = new Ext.ux.form.LovCombo({
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
    });
    MaxNumField.setDisabled(true);

    var QueryButton = new Ext.Button({
        width: 65,
        id: "QueryButton",
        text: '统计处方总数',
        iconCls: "page_find",
        listeners: {
            "click": function() {
                Ext.MessageBox.confirm('注意', '确认要统计处方吗 ? ', QueryKCommentData);
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
        title: '抗菌药专项点评',
        labelWidth: 80,
        region: 'center',
        frame: true,
        height: 150,
        tbar: [QueryButton], //, "-", SubmitButton],
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
                items: [StDateField, EndDateField]
            }, {
                columnWidth: 0.3,
                xtype: 'fieldset',
                labelWidth: 180,
                labelAlign: 'right',
                items: [DocCentField, PrescCentField]
            }, {
                columnWidth: 0.25,
                xtype: 'fieldset',
                labelAlign: 'right',
                items: [ComBoCtrl, MaxNumField]
            }]
        }]
    });

    var CreateForm = new Ext.Panel({
        region: 'center',
        frame: true,
        title: '生成点评单',
        height: 120,
        tbar: [SaveButton],
        layout: 'fit',
        items: [{
            style: "padding-top:10px;",
            layout: 'column',
            xtype: 'fieldset',
            defaults: { border: false },
            items: [{
                columnWidth: 0.5,
                xtype: 'fieldset',
                labelAlign: 'right',
                items: [ComNoField]
            }]
        }]
    })

    var QueryForm = new Ext.Panel({
        region: 'center',
        frame: true,
        items: [RuleForm, CreateForm]
    })

    var port = new Ext.Viewport({
        layout: 'fit',
        items: [QueryForm]
    });

    ////-----------------Events-----------------///

    ///检查
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

        var doccent = Ext.getCmp("DocCentField").getRawValue();
        var doccent = trim(doccent);
        if (doccent == "") {
            Ext.Msg.show({
                title: '注意',
                msg: '请先填写医生比例!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return -1;
        }
        if (!(doccent > 0)) {
            Ext.Msg.show({
                title: '注意',
                msg: '医生比例格式不正确!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return -1;
        }
        if (parseFloat(doccent) > 60) {
            Ext.Msg.show({
                title: '注意',
                msg: '比例不能大于60!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return -1;
        }
        var presccent = Ext.getCmp("PrescCentField").getRawValue();
        var presccent = trim(presccent);
        if (presccent == "") {
            Ext.Msg.show({
                title: '注意',
                msg: '请先填写处方数量!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return -1;
        }
        if (!(presccent > 0)) {
            Ext.Msg.show({
                title: '注意',
                msg: '处方数量格式不正确!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return -1;
        }
        if (parseFloat(presccent) > 60) {
            Ext.Msg.show({
                title: '注意',
                msg: '处方数量不能大于60!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return -1;
        }
        return 0;
    }

    /// 获取界面item值
    function GetParStr() {
        var waycode = "K" //方式
        var sdate = Ext.getCmp("startdt").getRawValue();
        var edate = Ext.getCmp("enddt").getRawValue();
        var doccent = Ext.getCmp("DocCentField").getRawValue(); //医生比例
        var presccent = Ext.getCmp("PrescCentField").getRawValue(); //处方张数
        var poisonstr = Ext.getCmp("ComCtrlID").getValue(); //管制分类
        parstr = sdate + "^" + edate + "^" + doccent + "^" + presccent + "^" + poisonstr + "^" + waycode;
        return parstr;
    }

    /// 保存动作
    function SaveClick() {
        var ret = CheckBeforeSave();
        if (ret < 0) {
            return;
        }
        Ext.MessageBox.confirm('注意', '确认要生成抗菌药处方点评单吗 ? ', SaveCommentData);
    }

    /// 抗生素专项
    function SaveCommentData(btn) {
        if (btn == "no") {
            return;
        }
        var params = GetParStr();
        waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候...", removeMask: true });
        waitMask.show();
        var userId = session['LOGON.USERID'];
        var locId = session['LOGON.CTLOCID'];
        var pid = tkMakeServerCall("web.DHCSTCNTS.Main", "JobSaveAntiCommentData", params, locId, userId);
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

    /// 统计处方数
    function QueryKCommentData(btn) {
        if (btn == "no") {
            return;
        }
        waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候...", removeMask: true });
        waitMask.show();
        var params = GetParStr();
        var userId = session['LOGON.USERID'];
        var locId = session['LOGON.CTLOCID'];
        var pid = tkMakeServerCall("web.DHCSTCNTS.Main", "JobGetAntiPrescDataNum", params, locId);
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

    new Ext.ToolTip({
        target: 'QueryButton',
        anchor: 'buttom',
        width: 500,
        anchorOffset: 50,
        hideDelay: 9000,
        html: "<font size=3 color=blue>所有开具了抗菌药物的医师 * 医生比例, 在这些医师中按 处方张数 抽取</font>"
    });
});

/*如下为原系统任务事件*/
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
	})

	 //提交系统任务
    function SubmitClick() {
        if (CheckDataBeforeSave() == true) {
            Ext.MessageBox.confirm('注意', '确认要提交系统任务吗 ? ', SaveSysTask);
        }　
    }

    //保存系统任务
    function SaveSysTask(btn) {
        if (btn == "no") {
            return;
        }
        parstr = GetParStr();
        var User = session['LOGON.USERID'];　
        waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候...", removeMask: true });　
        waitMask.show();
        Ext.Ajax.request({
            url: unitsUrl + '?action=SaveKSysTask&User=' + User + '&ParStr=' + parstr,
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
        /// 松查是否可以提交任务
    function CheckDataBeforeSave() {
        var maxnum = Ext.getCmp("MaxNumField").getRawValue();
        var maxnum = trim(maxnum);
        if (systaskflag != "1") {
            if (maxnum > 0) {
                Ext.Msg.show({
                    title: '错误',
                    msg: '可以统计出处方总数,不允许提交任务！',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });

            } else {
                Ext.Msg.show({
                    title: '错误',
                    msg: '请先点击<统计处方总数>,如果可以实时显示处方总数,则不允许提交任务！',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
            }
            return false;
        }
        return true;
    }
	*/