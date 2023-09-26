/// ����ר�����
/// Creator:LiangQiang
/// CreatDate:2012-05-20

var unitsUrl = 'dhcpha.comment.main.save.csp';

var comwidth = 150;
var ruleformwd = 800;
var parstr = "";
var maxcent = 0.8; //��ȡ������

Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.Ajax.timeout = 900000;
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

    // ����ҽ������
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
        fieldLabel: 'ҽ������',
        id: 'DocLocSelecter',
        name: 'DocLocSelecter',
        store: ComBoDocLocDs,
        width: comwidth,
        listWidth: 250,
        emptyText: 'ѡ��ҽ������...',
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

    var AgeField = new Ext.form.TextField({
        width: comwidth,
        id: "agetxt",
        fieldLabel: "��������"
    })
    AgeField.setDisabled(true);
    Ext.getCmp("agetxt").setValue(">15��"); //

    ///���� 
    var OpTypeData = [
        ['����', '1'],
        ['����', '2'],
        ['ȫ��', '3']
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
        emptyText: 'ѡ������...',
        fieldLabel: '����'
    });
    Ext.getCmp("OptypeCmb").setValue("1");

    /// ����ּ�
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
    })
    MaxNumField.setDisabled(true);

    var QueryButton = new Ext.Button({
        width: 65,
        id: "QueryButton",
        text: 'ͳ�ƴ�������',
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
        text: '��ȡ��������',
        iconCls: "page_checkout",
        listeners: {
            "click": function() {
                SaveClick();
            }
        }
    });

    var RuleForm = new Ext.Panel({
        title: '����ר�����',
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
        title: '���ɵ�����',
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
    //ͳ�ƶ���
    function QueryClick() {
        Ext.getCmp("RandomNumField").setValue("");
        Ext.getCmp("ComNoField").setValue("");
        Ext.MessageBox.confirm('ע��', 'ȷ��Ҫͳ�ƴ����� ? ', QueryACommentData);
    }

    function GetParStr() {
        var waycode = "C"; //��ʽ
        var sd = Ext.getCmp("startdt").getRawValue();
        var ed = Ext.getCmp("enddt").getRawValue();
        var rnum = Ext.getCmp("RandomNumField").getRawValue();
        var doclocstr = Ext.getCmp("DocLocSelecter").getValue(); //
        var poisonstr = Ext.getCmp("ComCtrlID").getValue(); //
        var optype = Ext.getCmp("OptypeCmb").getValue(); //��������
        var minage = Ext.getCmp("agetxt").getValue();
        var parstr = sd + "^" + ed + "^" + rnum + "^" + doclocstr + "^" + poisonstr + "^" + optype + "^" + waycode + "^" + minage;
        return parstr;
    }

    ///ͳ�ƴ�����
    function QueryACommentData(btn) {
        if (btn == "no") {
            return;
        }
        waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ������ݣ����Ժ�...", removeMask: true });
        waitMask.show();
        var params = GetParStr();
        var userId = session['LOGON.USERID'];
        var locId = session['LOGON.CTLOCID'];
        var pid = tkMakeServerCall("web.DHCSTCNTS.Main", "JobGetAdultPrescDataNum", params, locId);
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
                    Ext.getCmp("MaxNumField").setValue("");
                } else {
                    if (jobRetVal == 0) {
                        var msgInfo = "û�з��������Ĵ���,�������ѯ����������!";
                        Ext.Msg.show({
                            title: '��ʾ',
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

    /// ���
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

        var rnum = Ext.getCmp("RandomNumField").getRawValue();
        var rnum = trim(rnum);
        if (rnum == "") {
            Ext.Msg.show({
                title: 'ע��',
                msg: '������д�����!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return -1;
        }
        if (!(rnum > 0)) {
            Ext.Msg.show({
                title: 'ע��',
                msg: '�������ʽ����ȷ!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return -1;
        }
        if (rnum.indexOf(".") > -1) {
            Ext.Msg.show({
                title: 'ע��',
                msg: '���������ΪС��!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return -1;
        }
        if (rnum > 200) {
            Ext.Msg.show({
                title: 'ע��',
                msg: '����������ܴ���200!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return -1;
        }
        if (parseFloat(rnum) > ((parseFloat(maxnum)) * maxcent)) {
            Ext.Msg.show({
                title: 'ע��',
                msg: '����������ܴ��ڴ�������*' + maxcent,
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
        Ext.MessageBox.confirm('ע��', 'ȷ��Ҫ���ɳ��˴����������� ? ', SaveACommentData);
    }

    function SaveACommentData(btn) {
        if (btn == "no") {
            return;
        }
        var params = GetParStr();
        waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ������ݣ����Ժ�...", removeMask: true });
        waitMask.show();
        var userId = session['LOGON.USERID'];
        var locId = session['LOGON.CTLOCID'];
        var pid = tkMakeServerCall("web.DHCSTCNTS.Main", "JobSaveAdultCommentData", params, locId, userId);
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
                    Ext.Msg.show({
                        title: '��ʾ',
                        msg: jobRetVal,
                        buttons: Ext.Msg.OK,
                        icon: Ext.MessageBox.INFO
                    });
                } else {
                    Ext.Msg.show({
                        title: '��ʾ',
                        msg: "��ȡ�ɹ�",
                        buttons: Ext.Msg.OK,
                        icon: Ext.MessageBox.INFO
                    });
                    Ext.getCmp("ComNoField").setValue(jobRetVal);
                }
            }
        }, 5000);
    }
});