///����:     ҩ��ɹ���������¼��
///����:     ҩ��ɹ���������¼��
///��д�ߣ�  hulihua
///��д����: 2018.07.30
///dhcst/dhcreportforynsdr.js
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var gGroupId = session["LOGON.GROUPID"];
    var gLocId = session["LOGON.CTLOCID"];
    var gUserId = session["LOGON.USERID"];
    var UserName = session["LOGON.USERNAME"];
    var PhaLoc = new Ext.ux.LocComboBox({
        fieldLabel: "<font color=blue>"+$g("����")+"</font>",
        id: "PhaLoc",
        name: "PhaLoc",
        anchor: "90%",
        emptyText: "����...",
        groupId: gGroupId,
        listeners: {
            select: function(e) {
                var SelLocId = Ext.getCmp("PhaLoc").getValue(); //add wyx ����ѡ��Ŀ��Ҷ�̬��������
                StkGrpType.getStore().removeAll();
                StkGrpType.getStore().setBaseParam("locId", SelLocId);
                StkGrpType.getStore().setBaseParam("userId", UserId);
                StkGrpType.getStore().setBaseParam("type", App_StkTypeCode);
                StkGrpType.getStore().load();
            }
        }
    });
    var TypeStore = new Ext.data.SimpleStore({
        fields: ["RowId", "Description1"],
        data: [
            ["11", $g("��ʽ�ɹ�")],
            ["12", $g("��ʱ�ɹ�")],
            ["", $g("����")]
        ]
    });
    //�ɹ�����
    var OperateType = new Ext.form.ComboBox({
        fieldLabel: "<font color=blue>"+$g("�ɹ�����"),
        id: "OperateType",
        name: "OperateType",
        anchor: "90%",
        width: 100,
        store: TypeStore,
        valueField: "RowId", //����������ֵ������ֵΪSM������ʾ�����ݼ�Ϊ�����š���
        displayField: "Description1", //��������ʾ����
        mode: "local",
        allowBlank: true,
        triggerAction: "all",
        selectOnFocus: true,
        listWidth: 150,
        forceSelection: true
    });
    Ext.getCmp("OperateType").setValue(11); //����Ĭ��ѡ��.

    var TypeStore = new Ext.data.SimpleStore({
        fields: ["RowId", "Description"],
        data: [
            ["0", $g("�ƻ�>ʵ��")],
            ["1", $g("�ƻ�=ʵ��")],
            ["2", $g("�ƻ�<ʵ��")]
        ]
    });
    //ͳ�Ʊ�־
    var QueryFlag = new Ext.form.ComboBox({
        fieldLabel: "<font color=blue>"+$g("ͳ�Ʊ�־"),
        id: "QueryFlag",
        name: "QueryFlag",
        anchor: "90%",
        width: 100,
        store: TypeStore,
        valueField: "RowId", //����������ֵ������ֵΪSM������ʾ�����ݼ�Ϊ�����š���
        displayField: "Description", //��������ʾ����
        mode: "local",
        allowBlank: true,
        triggerAction: "all",
        selectOnFocus: true,
        listWidth: 150,
        forceSelection: true
    });
    Ext.getCmp("QueryFlag").setValue(0); //����Ĭ��ѡ��.

    var DateFrom = new Ext.ux.EditDate({
        fieldLabel: "<font color=blue>"+$g("��ʼ����")+"</font>",
        id: "DateFrom",
        name: "DateFrom",
        anchor: "90%",
        value: DefaultStDate()
    });

    var StartTime = new Ext.form.TextField({
        fieldLabel: "<font color=blue>"+$g("��ʼʱ��")+"</font>",
        id: "StartTime",
        name: "StartTime",
        anchor: "90%",
        //value :DefaultEdTime(),
        regex: /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
        regexText: $g("ʱ���ʽ������ȷ��ʽhh:mm:ss"),
        width: 120,
        //value :DefaultEdTime(),
        listeners: {
            specialkey: function(field, e) {
                if (e.getKey() == Ext.EventObject.ENTER) {
                    var item = field.getValue();
                    if (item != null && item.length > 0) {
                        var eTime = SetCorrectTimetype(item);
                        Ext.getCmp("StartTime").setValue(eTime);
                    }
                }
            }
        }
    });
    //--------------------add by myq 20140414 ����ͬ����ׯ

    //-----------------��ʱ���趨��ȷ�ĸ�ʽ add by myq 20140420
    function SetCorrectTimetype(item) {
        //���¼�����Ϣ�ں��С������� ������
        if (item.indexOf(":") > 0) {
            return item;
        }

        var datelength = item.length;
        var Hdate = item.substring(0, 2);
        var Mdate = item.substring(2, 4);
        var Sdate = item.substring(4, 6);

        if (datelength < 1) {
            alert($g("������ʱ�䣡"));
            return;
        }
        if (Hdate > 24) {
            alert($g("�����Сʱ��ʽ����Ӧ��0~24֮��..."));
            return;
        }
        if (Hdate.length < 2) {
            var Hdate = "0" + Hdate;
        }

        if (Mdate > 60) {
            alert($g("����ķ��Ӹ�ʽ����Ӧ��0~60֮��..."));
            return;
        }
        if (Mdate.length < 1) {
            var Mdate = "00";
        }
        if (Mdate.length < 2 && Mdate.length > 0) {
            var Mdate = Mdate + "0";
        }

        if (Sdate > 60) {
            alert($g("��������ʽ����Ӧ��0~60֮��..."));
            return;
        }
        if (Sdate.length < 1) {
            var Sdate = "00";
        }
        if (Sdate.length < 2 && Sdate.length > 0) {
            var Sdate = Sdate + "0";
        }

        var result = Hdate + ":" + Mdate + ":" + Sdate;

        return result;
    }
    //-----------------��ʱ���趨��ȷ�ĸ�ʽ add by myq 20140420
    var DateTo = new Ext.ux.EditDate({
        fieldLabel: "<font color=blue>"+$g("��ֹ����")+"</font>",
        id: "DateTo",
        name: "DateTo",
        anchor: "90%",
        value: DefaultEdDate()
    });

    var EndTime = new Ext.form.TextField({
        fieldLabel: "<font color=blue>"+$g("��ֹʱ��")+"</font>",
        id: "EndTime",
        name: "EndTime",
        anchor: "90%",
        //value :DefaultEdTime(),
        regex: /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
        regexText: $g("ʱ���ʽ������ȷ��ʽhh:mm:ss"),
        width: 120,
        //value :DefaultEdTime(),
        listeners: {
            specialkey: function(field, e) {
                if (e.getKey() == Ext.EventObject.ENTER) {
                    var item = field.getValue();
                    if (item != null && item.length > 0) {
                        var eTime = SetCorrectTimetype(item);
                        Ext.getCmp("EndTime").setValue(eTime);
                    }
                }
            }
        }
    });
    //--------------------add by myq 20140414 ����ͬ����ׯ
    // ҩƷ����
    var StkGrpType = new Ext.ux.StkGrpComboBox({
        id: "StkGrpType",
        name: "StkGrpType",
        anchor: "90%",
        StkType: App_StkTypeCode, //��ʶ��������
        LocId: gLocId,
        UserId: gUserId
    });

    // �ƻ��������������
    var FlagComparePurPlanAndIngr = new Ext.form.Radio({
        boxLabel: $g("�ƻ�������������ձ���"),
        id: "FlagComparePurPlanAndIngr",
        name: "ReportType",
        anchor: "80%",
        checked: true
    });

    // �ƻ��������浥
    var FlagPurPlan = new Ext.form.Radio({
        boxLabel: $g("�ƻ��������浥"),
        id: "FlagPurPlan",
        name: "ReportType",
        anchor: "80%",
        checked: false
    });

    var ClearBT = new Ext.Toolbar.Button({
        id: "ClearBT",
        text: $g("����"),
        tooltip: $g("�������"),
        width: 70,
        height: 30,
        iconCls: "page_clearscreen",
        handler: function() {
            Ext.getCmp("HisListTab")
                .getForm()
                .items.each(function(f) {
                    f.setValue("");
                });
            SetLogInDept(PhaLoc.getStore(), "PhaLoc");
            Ext.getCmp("DateFrom").setValue(DefaultStDate());
            Ext.getCmp("DateTo").setValue(DefaultEdDate());
            Ext.getCmp("StkGrpType")
                .getStore()
                .load();
            Ext.getCmp("OperateType").setValue(11);
            Ext.getCmp("QueryFlag").setValue(0);
            FlagComparePurPlanAndIngr.setValue(true);
            document.getElementById("frameReport").src = BlankBackGroundImg;
        }
    });

    // ͳ�ư�ť
    var OkBT = new Ext.Toolbar.Button({
        id: "OkBT",
        text: $g("ͳ��"),
        tooltip: $g("���ͳ��"),
        width: 70,
        iconCls: "page_find",
        height: 30,
        handler: function() {
            ShowReport();
        }
    });

    function ShowReport() {
        if (Ext.getCmp("DateFrom").getValue() == "") {
            Msg.info("warning", $g("��ѡ��ʼ����!"));
            return;
        }
        if (Ext.getCmp("DateTo").getValue() == "") {
            Msg.info("warning", $g("��ѡ���ֹ����!"));
            return;
        }
        var StartDate = Ext.getCmp("DateFrom")
        	.getValue()
			.format(App_StkDateFormat)
			.toString();
        var EndDate = Ext.getCmp("DateTo")
            .getValue()
            .format(App_StkDateFormat)
            .toString();
        var LocId = Ext.getCmp("PhaLoc").getValue();
        if (LocId == "") {
            Msg.info("warning", $g("��ѡ�����!"));
            return;
        }
        var OperateType = Ext.getCmp("OperateType").getValue();
        var QueryFlag = Ext.getCmp("QueryFlag").getValue();
        var reportFrame = document.getElementById("frameReport");
        var p_URL = "";
        var FlagComparePurPlanAndIngr = Ext.getCmp("FlagComparePurPlanAndIngr").getValue();
        var FlagPurPlan = Ext.getCmp("FlagPurPlan").getValue();
        var DispLocDesc = Ext.getCmp("PhaLoc").getRawValue();
        //ҩ�����õǼǱ���
        if (FlagComparePurPlanAndIngr == true) {
            p_URL = "dhccpmrunqianreport.csp?reportName=DHCST_DrugStat_PlanAndIngrCompareRep.raq&tStartDate=" + StartDate + "&tEndDate=" + EndDate + "&tDispLocId=" + LocId + "&OperateType=" + OperateType + "&QueryFlag=" + QueryFlag + "&DispLocDesc=" + DispLocDesc+"&RQDTFormat="+App_StkRQDateFormat+" "+App_StkRQTimeFormat;
        }
        //�ƻ���������
        else if (FlagPurPlan == true) {
            p_URL = "dhccpmrunqianreport.csp?reportName=DHCST_DrugStat_TotalPlanAndIngrRep.raq&DispLocId=" + LocId + "&StartDate=" + StartDate + "&EndDate=" + EndDate+"&RQDTFormat="+App_StkRQDateFormat+" "+App_StkRQTimeFormat;
        }
        reportFrame.src = p_URL;
    }
    var HisListTab = new Ext.form.FormPanel({
        id: "HisListTab",
        labelWidth: 60,
        labelAlign: "right",
        frame: true,
        autoScroll: true,
        bodyStyle: "padding:5px;",
        tbar: [OkBT, "-", ClearBT],
        items: [
            {
                xtype: "fieldset",
                title: $g("��ѯ����"),
                items: [PhaLoc, DateFrom, DateTo, QueryFlag]
            },
            {
                xtype: "fieldset",
                title: $g("��������"),
                items: [FlagComparePurPlanAndIngr, FlagPurPlan]
            }
        ]
    });

    var reportPanel = new Ext.Panel({
        layout: "fit",
        html: '<iframe id="frameReport" height="100%" width="100%" src=' + DHCSTBlankBackGround + ">"
    });
    // ҳ�沼��
    var mainPanel = new Ext.Viewport({
        layout: "border",
        items: [
            {
                region: "west",
                title: $g("ҩ��ƻ���ʵ�ʽ���ͳ��"),
                width: 300,
                split: true,
                collapsible: true,
                minSize: 250,
                maxSize: 350,
                layout: "fit",
                items: HisListTab
            },
            {
                region: "center",
                layout: "fit",
                items: reportPanel
            }
        ]
    });
});
