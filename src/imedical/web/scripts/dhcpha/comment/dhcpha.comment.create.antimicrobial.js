/// ����ҩר�����
/// Creator:LiangQiang
/// CreatDate:2012-05-20

var unitsUrl = 'dhcpha.comment.main.save.csp';

var comwidth = 150;
var ruleformwd = 800;
var parstr = "";
var systaskflag = "";

Ext.onReady(function() {
    Ext.QuickTips.init(); // ������Ϣ��ʾ
    Ext.Ajax.timeout = 900000;
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

    var StDateField = new Ext.form.DateField({
        xtype: 'datefield',
        //format:'j/m/Y' ,
        fieldLabel: '��ʼ����',
        name: 'startdt',
        id: 'startdt',
        //invalidText:'��Ч���ڸ�ʽ,��ȷ��ʽ��:��/��/��,��:15/02/2011',
        width: comwidth,
        value: new Date
    });

    var EndDateField = new Ext.form.DateField({
        //format:'j/m/Y' ,
        fieldLabel: '��ֹ����',
        name: 'enddt',
        id: 'enddt',
        width: comwidth,
        value: new Date
    });

    var RandomNumField = new Ext.form.TextField({
        width: comwidth,
        id: "RandomNumField",
        fieldLabel: "�����"
    });

    var DocCentField = new Ext.form.TextField({
        width: comwidth,
        id: "DocCentField",
        fieldLabel: "ҽ������(�߿�����������)"
    });
    Ext.getCmp("DocCentField").setValue("50");

    var PrescCentField = new Ext.form.TextField({
        width: comwidth,
        id: "PrescCentField",
        fieldLabel: "��������(ÿλҽ��)"
    })
    Ext.getCmp("PrescCentField").setValue("50");

    /// ����ּ�
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
        fieldLabel: '����ҩ�Ｖ��',
        id: 'ComCtrlID',
        name: 'ComCtrlID',
        store: ComCtrlDs,
        width: comwidth,
        listWidth: 250,
        //emptyText:'ѡ�񿹾�ҩ�Ｖ��...',
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
        fieldLabel: "��������"
    })
    ComNoField.setDisabled(true);

    var MaxNumField = new Ext.form.TextField({
        width: comwidth,
        id: "MaxNumField",
        fieldLabel: "��������"
    });
    MaxNumField.setDisabled(true);

    var QueryButton = new Ext.Button({
        width: 65,
        id: "QueryButton",
        text: 'ͳ�ƴ�������',
        iconCls: "page_find",
        listeners: {
            "click": function() {
                Ext.MessageBox.confirm('ע��', 'ȷ��Ҫͳ�ƴ����� ? ', QueryKCommentData);
            }
        }
    });

    var SaveButton = new Ext.Button({
        width: 65,
        id: "SaveButton",
        text: '��ȡ��������',
        iconCls: "page_checkout",
        listeners: {
            "click": function() {
                SaveClick();
            }
        }

    });

    var RuleForm = new Ext.Panel({
        title: '����ҩר�����',
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
        title: '���ɵ�����',
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

    ///���
    function CheckBeforeSave() {
        var maxnum = Ext.getCmp("MaxNumField").getRawValue();
        var maxnum = trim(maxnum);
        if (maxnum == "") {
            Ext.Msg.show({
                title: 'ע��',
                msg: '����ͳ�ƴ�������!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return -1;
        }

        if (maxnum == 0) {
            Ext.Msg.show({
                title: 'ע��',
                msg: '��������Ϊ0,û�пɳ�ȡ�Ĵ���,����ͳ�ƴ�������!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return -1;
        }

        var doccent = Ext.getCmp("DocCentField").getRawValue();
        var doccent = trim(doccent);
        if (doccent == "") {
            Ext.Msg.show({
                title: 'ע��',
                msg: '������дҽ������!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return -1;
        }
        if (!(doccent > 0)) {
            Ext.Msg.show({
                title: 'ע��',
                msg: 'ҽ��������ʽ����ȷ!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return -1;
        }
        if (parseFloat(doccent) > 60) {
            Ext.Msg.show({
                title: 'ע��',
                msg: '�������ܴ���60!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return -1;
        }
        var presccent = Ext.getCmp("PrescCentField").getRawValue();
        var presccent = trim(presccent);
        if (presccent == "") {
            Ext.Msg.show({
                title: 'ע��',
                msg: '������д��������!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return -1;
        }
        if (!(presccent > 0)) {
            Ext.Msg.show({
                title: 'ע��',
                msg: '����������ʽ����ȷ!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return -1;
        }
        if (parseFloat(presccent) > 60) {
            Ext.Msg.show({
                title: 'ע��',
                msg: '�����������ܴ���60!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return -1;
        }
        return 0;
    }

    /// ��ȡ����itemֵ
    function GetParStr() {
        var waycode = "K" //��ʽ
        var sdate = Ext.getCmp("startdt").getRawValue();
        var edate = Ext.getCmp("enddt").getRawValue();
        var doccent = Ext.getCmp("DocCentField").getRawValue(); //ҽ������
        var presccent = Ext.getCmp("PrescCentField").getRawValue(); //��������
        var poisonstr = Ext.getCmp("ComCtrlID").getValue(); //���Ʒ���
        parstr = sdate + "^" + edate + "^" + doccent + "^" + presccent + "^" + poisonstr + "^" + waycode;
        return parstr;
    }

    /// ���涯��
    function SaveClick() {
        var ret = CheckBeforeSave();
        if (ret < 0) {
            return;
        }
        Ext.MessageBox.confirm('ע��', 'ȷ��Ҫ���ɿ���ҩ������������ ? ', SaveCommentData);
    }

    /// ������ר��
    function SaveCommentData(btn) {
        if (btn == "no") {
            return;
        }
        var params = GetParStr();
        waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ������ݣ����Ժ�...", removeMask: true });
        waitMask.show();
        var userId = session['LOGON.USERID'];
        var locId = session['LOGON.CTLOCID'];
        var pid = tkMakeServerCall("web.DHCSTCNTS.Main", "JobSaveAntiCommentData", params, locId, userId);
        // ����̨
        var jobInterval = setInterval(function() {
            var jobRet = tkMakeServerCall("web.DHCSTCNTS.Main", "JobRecieve", pid);
            if (jobRet != "") {
                clearInterval(jobInterval);
                waitMask.hide();
                var jobRetArr = jobRet.split("^");
                var jobRetSucc = jobRetArr[0];
                var jobRetVal = jobRetArr[1];
                if (jobRetSucc < 0) {
                    Ext.Msg.show({ title: '��ʾ', msg: jobRetVal, buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
                } else {
                    Ext.Msg.show({ title: '��ʾ', msg: "��ȡ�ɹ�", buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
                    Ext.getCmp("ComNoField").setValue(jobRetVal);
                }

            }
        }, 5000);
    }

    /// ͳ�ƴ�����
    function QueryKCommentData(btn) {
        if (btn == "no") {
            return;
        }
        waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ������ݣ����Ժ�...", removeMask: true });
        waitMask.show();
        var params = GetParStr();
        var userId = session['LOGON.USERID'];
        var locId = session['LOGON.CTLOCID'];
        var pid = tkMakeServerCall("web.DHCSTCNTS.Main", "JobGetAntiPrescDataNum", params, locId);
        // ����̨,5sһ��
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
                        title: '��ʾ',
                        msg: jobRetVal,
                        buttons: Ext.Msg.OK,
                        icon: Ext.MessageBox.INFO
                    });
                } else {
                    if (jobRetVal == 0) {
                        var msgInfo = "û�з��������Ĵ���,�������ѯ����������!";
                        Ext.Msg.show({
                            title: '��ʾ',
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
        html: "<font size=3 color=blue>���п����˿���ҩ���ҽʦ * ҽ������, ����Щҽʦ�а� �������� ��ȡ</font>"
    });
});

/*����Ϊԭϵͳ�����¼�*/
/*

    var SubmitButton = new Ext.Button({
        width: 65,
        id: "SubmitButton",
        text: '�ύϵͳ����',
        iconCls: "page_save",
        listeners: {
            "click": function() {
                SubmitClick();
            }
        }
	})

	 //�ύϵͳ����
    function SubmitClick() {
        if (CheckDataBeforeSave() == true) {
            Ext.MessageBox.confirm('ע��', 'ȷ��Ҫ�ύϵͳ������ ? ', SaveSysTask);
        }��
    }

    //����ϵͳ����
    function SaveSysTask(btn) {
        if (btn == "no") {
            return;
        }
        parstr = GetParStr();
        var User = session['LOGON.USERID'];��
        waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ������ݣ����Ժ�...", removeMask: true });��
        waitMask.show();
        Ext.Ajax.request({
            url: unitsUrl + '?action=SaveKSysTask&User=' + User + '&ParStr=' + parstr,
            method: 'POST',
            failure: function(result, request) {
                waitMask.hide();
                Ext.Msg.show({
                    title: '����',
                    msg: '������������!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
            },
            success: function(result, request) {
                waitMask.hide();
                var jsonData = Ext.util.JSON.decode(result.responseText);
                if (jsonData.retvalue > 0) {
                    msgtxt = "�ύ�ɹ�";
                    systaskflag = "";
                    Ext.getCmp("ComNoField").setValue(jsonData.retinfo);
                } else {
                    msgtxt = jsonData.retinfo;
                }
                Ext.Msg.show({
                    title: '��ʾ',
                    msg: msgtxt,
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.INFO
                });
            },
            scope: this
        });
    }
        /// �ɲ��Ƿ�����ύ����
    function CheckDataBeforeSave() {
        var maxnum = Ext.getCmp("MaxNumField").getRawValue();
        var maxnum = trim(maxnum);
        if (systaskflag != "1") {
            if (maxnum > 0) {
                Ext.Msg.show({
                    title: '����',
                    msg: '����ͳ�Ƴ���������,�������ύ����',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });

            } else {
                Ext.Msg.show({
                    title: '����',
                    msg: '���ȵ��<ͳ�ƴ�������>,�������ʵʱ��ʾ��������,�������ύ����',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
            }
            return false;
        }
        return true;
    }
	*/