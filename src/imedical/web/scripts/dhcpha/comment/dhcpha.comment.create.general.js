/// �����ۺϵ���
/// Creator:LiangQiang
/// CreatDate:2012-05-20

/// ��ȡ��̨csp
var unitsUrl = 'dhcpha.comment.main.save.csp';

/// Ĭ��ֵ
var comwidth = 150;
var ruleformwd = 1000;
var fromheight = 250;
var maxcentnum = 0.8; //����ȡ�ٷֱ���

var parstr = ""; //���
var CardTypeDs = [];
var systaskflag = "";
var LogonLocId = session['LOGON.CTLOCID']
var gNewCatIdOther = ""; // ��ҩ��ѧ����

Ext.onReady(function() {
    Ext.Ajax.timeout = 900000;
    Ext.QuickTips.init(); // ������Ϣ��ʾ
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    Ext.ux.form.LovCombo = Ext.form.LovCombo || Ext.ux.form.LovCombo;

    // ҽ������
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
        fieldLabel: 'ҽ������',
        id: 'DocLocSelecter',
        name: 'DocLocSelecter',
        store: ComBoDocLocDs,
        width: comwidth,
        listWidth: 250,
        emptyText: 'ѡ��ҽ������...',
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

    /// ��������
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
        fieldLabel: '��������',
        id: 'PresctypeCmb',
        name: 'PresctypeSelecter',
        store: ComBoPresctypeDs,
        width: comwidth,
        listWidth: 250,
        emptyText: 'ѡ�񴦷�����...',
        hideOnSelect: false,
        maxHeight: 300,
        valueField: 'PTypeID',
        displayField: 'PTypeDesc',
        triggerAction: 'all',
        mode: 'local'
    });

    /// ����  
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
        fieldLabel: '����',
        id: 'PHCFormCmb',
        name: 'PHCFormSelecter',
        store: ComBoPHCFormDs,
        width: comwidth,
        //listWidth : 100,
        emptyText: 'ѡ�����...',
        hideOnSelect: false,
        maxHeight: 300,
        valueField: 'PHCFID',
        displayField: 'PHCFDesc',
        triggerAction: 'all',
        mode: 'local',
        valueNotFoundText: ''
    });

    /// �Ƴ�  
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
        fieldLabel: '�Ƴ̴���',
        id: 'PHCDUCmb',
        name: 'PHCDUSelecter',
        store: ComBoPHCDUDs,
        width: comwidth,
        //listWidth : 100,
        emptyText: 'ѡ���Ƴ̴���...',
        hideOnSelect: false,
        maxHeight: 300,
        valueField: 'PHCDUID',
        displayField: 'PHCDUDesc',
        triggerAction: 'all',
        mode: 'local',
        valueNotFoundText: ''
    });

    /// ҽ��������  
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
        '<tr><th style="font-weight: bold; font-size:15px;">����</th><th style="font-weight: bold; font-size:15px;">����</th><th style="font-weight: bold; font-size:15px;">ID</th></tr>',
        '<tpl for=".">',
        '<tr class="combo-item">',
        '<td style="width:500; font-size:15px;">{arcimDesc}</td>',
        '<td style="width:20%; font-size:15px;">{arcimCode}</td>',
        '<td style="width:50; font-size:15px;">{arcimId}</td>',
        '</tr>',
        '</tpl>', '</tbody></table>');
    var ArcimSelecter = new Ext.form.ComboBox({
        id: 'ArcimSelecter',
        fieldLabel: 'ҽ������',
        store: ComBoArcimDs,
        valueField: 'arcimId',
        displayField: 'arcimDesc',
        pageSize: 50,
        width: comwidth,
        autoHeight: true,
        listWidth: 550,
        triggerAction: 'all',
        emptyText: 'ѡ��ҽ������...',
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
        fieldLabel: '��ʼ����',
        name: 'startdt',
        id: 'startdt',
        tabIndex: '0',
        //invalidText:'��Ч���ڸ�ʽ,��ȷ��ʽ��:��/��/��,��:15/02/2011',
        width: comwidth,
        value: new Date()
    })

    var EndDateField = new Ext.form.DateField({
        //format:'j/m/Y' ,
        fieldLabel: '��ֹ����',
        name: 'enddt',
        id: 'enddt',
        tabIndex: '0',
        width: comwidth,
        value: new Date
    });

    /// �����
    var RandomNumField = new Ext.form.TextField({
        width: comwidth,
        id: "RandomNumField"
    });

    /// �ٷֱ�
    var PercentageField = new Ext.form.TextField({
        width: comwidth,
        id: "PercentageField"
    });
    PercentageField.setDisabled(true);

    /// ��������
    var MaxNumField = new Ext.form.TextField({
        width: comwidth,
        id: "MaxNumField",
        fieldLabel: "��������"
    });
    MaxNumField.setDisabled(true);

    /// ����
    var ComNoField = new Ext.form.TextField({
        width: comwidth,
        height: 25,
        id: "ComNoField",
        fieldLabel: "��������"
    });
    ComNoField.setDisabled(true);

    var NumRadio = new Ext.form.Radio({
        FieldLabel: '�����',
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
        FieldLabel: '�ٷֱ�',
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
        emptyText: '¼���س�У��...',
        width: comwidth,
        id: "SpaceQtyTxt",
        fieldLabel: "�����",
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
        fieldLabel: "�����"
    });
    WriteQtyField.setDisabled(true);

    var TheoryQtyField = new Ext.form.TextField({
        width: comwidth,
        id: "TheoryQtyTxt",
        fieldLabel: "������������"
    });
    TheoryQtyField.setDisabled(true);

    var ASpaceQtyField = new Ext.form.TextField({
        width: comwidth,
        id: "ASpaceQtyTxt",
        fieldLabel: "��������"
    });
    ASpaceQtyField.setDisabled(true);

    var QueryButton = new Ext.Button({
        width: 65,
        id: "QueryButton",
        text: 'ͳ�ƴ�������',
        iconCls: "page_find",
        listeners: {
            "click": function() {
                Ext.MessageBox.confirm('ע��', 'ȷ��Ҫͳ�ƴ����� ? ', QueryCommentData);
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

    /// �������� 
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
        emptyText: '��������...',
        fieldLabel: '��������',
        valueNotFoundText: ''
    });



    // ҽ��
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
        emptyText: 'ѡ��ҽ��...',
        fieldLabel: 'ҽ��',
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


    /// ����ҩ�Ｖ��
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
        fieldLabel: '����ҩ�Ｖ��',
        id: 'ComCtrlID',
        name: 'ComCtrlID',
        store: ComCtrlDs,
        width: comwidth,
        listWidth: 250,
        emptyText: 'ѡ�񿹾�ҩ�Ｖ��...',
        hideOnSelect: false,
        maxHeight: 300,
        valueField: 'CtrlID',
        displayField: 'CtrlDesc',
        triggerAction: 'all',
        mode: 'local'
    });

    /// ҽ���ѱ�
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
        emptyText: 'ѡ��ҽ���ѱ�...',
        fieldLabel: 'ҽ���ѱ�',
        valueNotFoundText: ''
    });


    /// ҩ��
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
        emptyText: '��ѡ��ҩ��...',
        fieldLabel: 'ҩ������',
        valueNotFoundText: '',
        queryParam: 'combotext',
        minChars: 0
    });

    /// ���Ʒ���
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
        emptyText: 'ѡ����Ʒ���...',
        fieldLabel: '���Ʒ���',
        valueNotFoundText: ''
    });

    /// ����ҩ��
    var BasicDrugChkBox = new Ext.form.Checkbox({
        fieldLabel: '����ҩ��',
        id: 'BasicDrugChk',
        inputValue: '1',
        checked: false
    });

    /// ҩѧ����
    var DrugCatField = new Ext.form.TextField({
        width: 130,
        id: "DrugCatTxt",
        readOnly: true,
        fieldLabel: "ҩѧ����"
    });

    /// ��ҩѧ����    
    var PHCCATALLOTHButton = new Ext.Button({
        id: 'PHCCATALLOTHButton',
        text: '...',
        handler: function() {
            PhcCatNewSelect(gNewCatIdOther, GetAllCatNewList)
        }
    });

    /// �������
    var PrescAmtField = new Ext.form.TextField({
        width: comwidth,
        id: "PrescAmtTxt",
        fieldLabel: "����������"
    });

    var PatAgeField = new Ext.form.TextField({
        width: comwidth,
        id: "PatAgeTxt",
        fieldLabel: "������������"
    })

    var PatAgeLTField = new Ext.form.TextField({
        width: comwidth,
        id: "PatAgeLTTxt",
        fieldLabel: "������������" //��������С��
    })

    var RuleForm = new Ext.Panel({
        title: '�����ۺϵ���',
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
                items: [StDateField, OpTypeCombo, PresctypeSelecter, BillTypeCombo, { xtype: 'compositefield', fieldLabel: "ҩѧ����", items: [DrugCatField, PHCCATALLOTHButton] }, PatAgeField, PHCDUSelecter]
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
        title: '���ɵ�����',
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
                items: [{ xtype: 'compositefield', fieldLabel: "�����", items: [NumRadio, RandomNumField] }]
            }, {
                columnWidth: 0.25,
                xtype: 'fieldset',
                labelAlign: 'right',
                items: [{ xtype: 'compositefield', fieldLabel: "�ٷֱ�", items: [CentRadio, PercentageField] }]
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
                title: 'ע��',
                msg: '������������д����ȷ!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
            return -1;
        }
        var aqenum = Ext.getCmp("PatAgeTxt").getRawValue();
        var aqenum = trim(aqenum);
        if ((!(aqenum > 0)) && (aqenum != 0) && (aqenum != "")) {
            Ext.Msg.show({
                title: 'ע��',
                msg: '��������������д����ȷ!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
            return -1;
        }
        var aqeltnum = Ext.getCmp("PatAgeLTTxt").getRawValue();
        var aqeltnum = trim(aqeltnum);
        if ((!(aqeltnum > 0)) && (aqeltnum != 0) && (aqeltnum != "")) {
            Ext.Msg.show({
                title: 'ע��',
                msg: '��������������д����ȷ!',
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
                title: 'ע��',
                msg: '����ͳ�ƴ�������!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
            return -1;
        }
        if (maxnum == 0) {
            Ext.Msg.show({
                title: 'ע��',
                msg: '��������Ϊ0,û�пɳ�ȡ�Ĵ���,����ͳ�ƴ�������!',
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
                    title: 'ע��',
                    msg: '������д�����!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
                return -1;
            }
            if (!(rnum > 0)) {
                Ext.Msg.show({
                    title: 'ע��',
                    msg: '�������ʽ����ȷ!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
                return -1;
            }
            var rnumstr = rnum.split(".")
            if (rnumstr[0] !== rnum) {
                Ext.Msg.show({
                    title: 'ע��',
                    msg: '���������ΪС��',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
                return -1;
            }
            maxnum = parseFloat(maxnum);
            if (parseFloat(rnum) > parseFloat((maxnum * maxcentnum))) {
                Ext.Msg.show({
                    title: 'ע��',
                    msg: '����������ܴ�������' + maxcentnum * 100 + '%,������������!',
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
                    title: 'ע��',
                    msg: '������д�ٷֱ�!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
                return -1;
            }
            if (!(pcent > 0)) {
                Ext.Msg.show({
                    title: 'ע��',
                    msg: '�ٷֱȸ�ʽ����ȷ!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
                return -1;
            }
            if (parseFloat(pcent) > (maxcentnum * 100)) {
                Ext.Msg.show({
                    title: 'ע��',
                    msg: '�ٷֱȲ��ܴ���' + maxcentnum * 100,
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
                return -1;
            }
            if ((parseFloat(pcent) * parseFloat(maxnum) / 100) < 1) {
                Ext.Msg.show({
                    title: 'ע��',
                    msg: '���ٷֱȳ�ȡ�����С��1,���ܳ�ȡ!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
                return -1;
            }
        }
        //�����
        var spaceqtynum = Ext.getCmp("SpaceQtyTxt").getRawValue();
        var spaceqtynum = trim(spaceqtynum);
        if ((!(spaceqtynum > 0)) && (spaceqtynum != 0) && (spaceqtynum != "")) {
            Ext.Msg.show({
                title: 'ע��',
                msg: '�������д����ȷ!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
            return -1;
        }
        if ((parseInt(spaceqtynum) != spaceqtynum) && (spaceqtynum != "")) {
            Ext.Msg.show({
                title: 'ע��',
                msg: '�����ֻ��������!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
            return -1;
        }
        return 0;
    }

    ///��ȡ����itemֵ
    function GetParStr() {
        var waycode = "P"; //��ʽ
        var sdate = Ext.getCmp("startdt").getRawValue();
        var edate = Ext.getCmp("enddt").getRawValue();
        var doclocdr = Ext.getCmp("DocLocSelecter").getValue(); //����
        var arcim = Ext.getCmp("ArcimSelecter").getValue(); //ҽ��ҩƷ
        var rnum = Ext.getCmp("RandomNumField").getValue(); //�����
        if (trim(rnum) != "") {
            rnum = parseInt(rnum);
        }
        var cent = Ext.getCmp("PercentageField").getValue(); //�ٷֱ�  
        var optype = Ext.getCmp("OptypeCmb").getValue(); //��������
        var doctordr = Ext.getCmp("DoctorCmb").getValue(); //ҽ��
        var ctrlstr = Ext.getCmp("ComCtrlID").getValue(); //�ּ�
        var presctype = Ext.getCmp("PresctypeCmb").getValue(); //��������
        var billtype = Ext.getCmp("BillTypeCmb").getValue(); //���˷ѱ�
        var phaloc = Ext.getCmp("PhaLocCmb").getValue(); //ҩ������
        var poison = Ext.getCmp("PoisonCmb").getValue(); //���Ʒ���
        var phacatstr = Ext.getCmp("DrugCatTxt").getValue(); //ҩѧ����
        var prescamt = Ext.getCmp("PrescAmtTxt").getValue(); //����������
        var phcform = Ext.getCmp("PHCFormCmb").getValue(); //����
        var phcdu = Ext.getCmp("PHCDUCmb").getValue(); //�Ƴ�
        var basicdrug = Ext.getCmp("BasicDrugChk").getValue(); //����ҩ��
        if (basicdrug) {
            var basicdrugflag = 1
        } else {
            var basicdrugflag = 0
        }
        var patage = Ext.getCmp("PatAgeTxt").getValue(); //�����������
        var patagelt = Ext.getCmp("PatAgeLTTxt").getValue(); //��������С��
        var spaceqty = Ext.getCmp("SpaceQtyTxt").getValue(); //�����
        if (trim(spaceqty) != "") {
            spaceqty = parseInt(spaceqty);
        }
        parstr = sdate + "^" + edate + "^" + doclocdr + "^" + arcim + "^" + rnum + "^" + cent + "^" + optype + "^" + doctordr + "^" + ctrlstr + "^" + waycode + "^" + presctype + "^" + billtype + "^" + phaloc;
        parstr = parstr + "^" + poison + "^" + gNewCatIdOther + "^" + prescamt + "^" + basicdrugflag + "^" + patage + "^" + spaceqty + "^" + patagelt + "^" + phcform + "^" + phcdu
        return parstr;
    }

    /// ͳ�ƴ�����
    function QueryCommentData(btn) {
        if (btn == "no") {
            return;
        }
        systaskflag = ""; //��������־      
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
        waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ������ݣ����Ժ�...", removeMask: true });
        waitMask.show();
        var params = GetParStr();
        var userId = session['LOGON.USERID'];
        var locId = session['LOGON.CTLOCID'];
        var pid = tkMakeServerCall("web.DHCSTCNTS.Main", "JobGetPrescDataNum", params, locId);
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
                        Ext.Msg.show({ title: '��ʾ', msg: msgInfo, buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
                    } else {
                        Ext.getCmp("MaxNumField").setValue(jobRetVal);
                    }
                }

            }
        }, 5000);
    }

    /// ���涯��
    function SaveClick() {
        var ret = CheckBeforeSave();
        if (ret < 0) {
            return;
        }
        if (CheckTheoryQty()) {
            Ext.MessageBox.confirm('ע��', 'ȷ��Ҫ������ͨ������������ ? ', SaveCommentData);
        }
    }

    /// ���ɵ�����
    function SaveCommentData(btn) {
        if (btn == "no") {
            return;
        }
        parstr = GetParStr();
        waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ������ݣ����Ժ�...", removeMask: true });
        waitMask.show();
        var params = GetParStr();
        var userId = session['LOGON.USERID'];
        var locId = session['LOGON.CTLOCID'];
        var pid = tkMakeServerCall("web.DHCSTCNTS.Main", "JobSaveCommentData", params, locId, userId);
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

    /// ��ҩ��ѧ����
    function GetAllCatNewList(catdescstr, newcatid) {
        Ext.getCmp("DrugCatTxt").setValue(catdescstr);
        gNewCatIdOther = newcatid;
    }

    /// �������������
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
                    title: '����',
                    msg: '���ڽ�������,���ܽ���!��ο���������,���¸���¼��������',
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

    // ��������,�������ֵ
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

    /// ��������
    function CheckRNumber() {
        var rnum = Ext.getCmp("RandomNumField").getRawValue();
        var rnum = trim(rnum);
        var maxnum = Ext.getCmp("MaxNumField").getRawValue();
        var maxnum = trim(maxnum);
        if (Math.floor(maxnum * maxcentnum) < rnum) {
            Ext.Msg.show({ title: '����', msg: '��������ܳ�������������鷶Χ,������¼�룡', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
            return -1;
        }
        if (Math.floor(maxnum / 30) > rnum) {
            Ext.MessageBox.confirm('ע��', '�������������С�ڴ��������ٷ�֮30,�Ƿ�����¼��? ', function(btn) {
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


/* ����Ϊ�ύϵͳ����,��������ʹ��*/
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
});
/// �ύϵͳ����-ͣ��
function SubmitClick() {
    if (CheckDataBeforeSave() == true) {
        Ext.MessageBox.confirm('ע��', 'ȷ��Ҫ�ύϵͳ������ ? ', SaveSysTask);
    }��
}

/// ����ϵͳ����
function SaveSysTask(btn) {
    var num = Ext.getCmp("RandomNumField").getValue(); //�����
    if (Ext.getCmp("NumRad").getValue()) {
        if (!(parseInt(num) > 0)) {
            Ext.Msg.show({ title: '����', msg: '������������0������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
            return;
        }
    }
    var cent = Ext.getCmp("PercentageField").getValue(); //�ٷֱ� 
    if (Ext.getCmp("CentRad").getValue()) {
        if (!(parseInt(cent) > 0)) {
            Ext.Msg.show({ title: '����', msg: '����ٷֱȱ������0������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
            return;
        }
    }
    var spaceqtynum = Ext.getCmp("SpaceQtyTxt").getRawValue();
    if (btn == "no") { return; }
    parstr = GetParStr();
    var User = session['LOGON.USERID'];
    waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ������ݣ����Ժ�...", removeMask: true });
    waitMask.show();
    Ext.Ajax.request({
        url: unitsUrl + '?action=SaveSysTask&User=' + User + '&ParStr=' + parstr,
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

// �ɲ��Ƿ�����ύ����
function CheckDataBeforeSave() {
    if (systaskflag != "1") {
        var maxnum = Ext.getCmp("MaxNumField").getRawValue();
        var maxnum = trim(maxnum);
        if (maxnum > 0) {
            Ext.Msg.show({
                title: '����',
                msg: '����ʵʱ��ʾ��������,�������ύ����',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
        } else {
            Ext.Msg.show({
                title: '����',
                msg: '�볢�Ե��<ͳ�ƴ�������>,���ϵͳ��ѯʱ����2����,�����ύ����',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
        }
        return false;
    }
    return true;
}

/// ���������
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
        '<tr><th style="font-weight: bold; font-size:15px;">ҩƷ����</th><th style="font-weight: bold; font-size:15px;">����</th><th style="font-weight: bold; font-size:15px;">ID</th></tr>',
        '<tpl for=".">',
        '<tr class="combo-item">',
        '<td style="width:500; font-size:15px;">{itmdesc}</td>',
        '<td style="width:20%; font-size:15px;">{itmcode}</td>',
        '<td style="width:50; font-size:15px;">{rowId}</td>',
        '</tr>',
        '</tpl>', '</tbody></table>');
    var IncitmSelecter = new Ext.form.ComboBox({
        id: 'InciSelecter',
        fieldLabel: 'ҩƷ����',
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
        emptyText: 'ѡ��ҩƷ����...',
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