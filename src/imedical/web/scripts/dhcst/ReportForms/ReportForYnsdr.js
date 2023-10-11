///名称:     药库采购报表条件录入
///描述:     药库采购报表条件录入
///编写者：  hulihua
///编写日期: 2018.07.30
///dhcst/dhcreportforynsdr.js
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var gGroupId = session["LOGON.GROUPID"];
    var gLocId = session["LOGON.CTLOCID"];
    var gUserId = session["LOGON.USERID"];
    var UserName = session["LOGON.USERNAME"];
    var PhaLoc = new Ext.ux.LocComboBox({
        fieldLabel: "<font color=blue>"+$g("科室")+"</font>",
        id: "PhaLoc",
        name: "PhaLoc",
        anchor: "90%",
        emptyText: "科室...",
        groupId: gGroupId,
        listeners: {
            select: function(e) {
                var SelLocId = Ext.getCmp("PhaLoc").getValue(); //add wyx 根据选择的科室动态加载类组
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
            ["11", $g("正式采购")],
            ["12", $g("临时采购")],
            ["", $g("其它")]
        ]
    });
    //采购类型
    var OperateType = new Ext.form.ComboBox({
        fieldLabel: "<font color=blue>"+$g("采购类型"),
        id: "OperateType",
        name: "OperateType",
        anchor: "90%",
        width: 100,
        store: TypeStore,
        valueField: "RowId", //下拉框具体的值（例如值为SM，则显示的内容即为‘短信’）
        displayField: "Description1", //下拉框显示内容
        mode: "local",
        allowBlank: true,
        triggerAction: "all",
        selectOnFocus: true,
        listWidth: 150,
        forceSelection: true
    });
    Ext.getCmp("OperateType").setValue(11); //设置默认选项.

    var TypeStore = new Ext.data.SimpleStore({
        fields: ["RowId", "Description"],
        data: [
            ["0", $g("计划>实际")],
            ["1", $g("计划=实际")],
            ["2", $g("计划<实际")]
        ]
    });
    //统计标志
    var QueryFlag = new Ext.form.ComboBox({
        fieldLabel: "<font color=blue>"+$g("统计标志"),
        id: "QueryFlag",
        name: "QueryFlag",
        anchor: "90%",
        width: 100,
        store: TypeStore,
        valueField: "RowId", //下拉框具体的值（例如值为SM，则显示的内容即为‘短信’）
        displayField: "Description", //下拉框显示内容
        mode: "local",
        allowBlank: true,
        triggerAction: "all",
        selectOnFocus: true,
        listWidth: 150,
        forceSelection: true
    });
    Ext.getCmp("QueryFlag").setValue(0); //设置默认选项.

    var DateFrom = new Ext.ux.EditDate({
        fieldLabel: "<font color=blue>"+$g("开始日期")+"</font>",
        id: "DateFrom",
        name: "DateFrom",
        anchor: "90%",
        value: DefaultStDate()
    });

    var StartTime = new Ext.form.TextField({
        fieldLabel: "<font color=blue>"+$g("开始时间")+"</font>",
        id: "StartTime",
        name: "StartTime",
        anchor: "90%",
        //value :DefaultEdTime(),
        regex: /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
        regexText: $g("时间格式错误，正确格式hh:mm:ss"),
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
    //--------------------add by myq 20140414 北京同仁亦庄

    //-----------------给时间设定正确的格式 add by myq 20140420
    function SetCorrectTimetype(item) {
        //如果录入的信息内含有“：”则 不处理
        if (item.indexOf(":") > 0) {
            return item;
        }

        var datelength = item.length;
        var Hdate = item.substring(0, 2);
        var Mdate = item.substring(2, 4);
        var Sdate = item.substring(4, 6);

        if (datelength < 1) {
            alert($g("请输入时间！"));
            return;
        }
        if (Hdate > 24) {
            alert($g("输入的小时格式错误，应在0~24之间..."));
            return;
        }
        if (Hdate.length < 2) {
            var Hdate = "0" + Hdate;
        }

        if (Mdate > 60) {
            alert($g("输入的分钟格式错误，应在0~60之间..."));
            return;
        }
        if (Mdate.length < 1) {
            var Mdate = "00";
        }
        if (Mdate.length < 2 && Mdate.length > 0) {
            var Mdate = Mdate + "0";
        }

        if (Sdate > 60) {
            alert($g("输入的秒格式错误，应在0~60之间..."));
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
    //-----------------给时间设定正确的格式 add by myq 20140420
    var DateTo = new Ext.ux.EditDate({
        fieldLabel: "<font color=blue>"+$g("截止日期")+"</font>",
        id: "DateTo",
        name: "DateTo",
        anchor: "90%",
        value: DefaultEdDate()
    });

    var EndTime = new Ext.form.TextField({
        fieldLabel: "<font color=blue>"+$g("截止时间")+"</font>",
        id: "EndTime",
        name: "EndTime",
        anchor: "90%",
        //value :DefaultEdTime(),
        regex: /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
        regexText: $g("时间格式错误，正确格式hh:mm:ss"),
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
    //--------------------add by myq 20140414 北京同仁亦庄
    // 药品类组
    var StkGrpType = new Ext.ux.StkGrpComboBox({
        id: "StkGrpType",
        name: "StkGrpType",
        anchor: "90%",
        StkType: App_StkTypeCode, //标识类组类型
        LocId: gLocId,
        UserId: gUserId
    });

    // 计划与入库数量对照
    var FlagComparePurPlanAndIngr = new Ext.form.Radio({
        boxLabel: $g("计划与入库数量对照报表"),
        id: "FlagComparePurPlanAndIngr",
        name: "ReportType",
        anchor: "80%",
        checked: true
    });

    // 计划评估报告单
    var FlagPurPlan = new Ext.form.Radio({
        boxLabel: $g("计划评估报告单"),
        id: "FlagPurPlan",
        name: "ReportType",
        anchor: "80%",
        checked: false
    });

    var ClearBT = new Ext.Toolbar.Button({
        id: "ClearBT",
        text: $g("清屏"),
        tooltip: $g("点击清屏"),
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

    // 统计按钮
    var OkBT = new Ext.Toolbar.Button({
        id: "OkBT",
        text: $g("统计"),
        tooltip: $g("点击统计"),
        width: 70,
        iconCls: "page_find",
        height: 30,
        handler: function() {
            ShowReport();
        }
    });

    function ShowReport() {
        if (Ext.getCmp("DateFrom").getValue() == "") {
            Msg.info("warning", $g("请选择开始日期!"));
            return;
        }
        if (Ext.getCmp("DateTo").getValue() == "") {
            Msg.info("warning", $g("请选择截止日期!"));
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
            Msg.info("warning", $g("请选择科室!"));
            return;
        }
        var OperateType = Ext.getCmp("OperateType").getValue();
        var QueryFlag = Ext.getCmp("QueryFlag").getValue();
        var reportFrame = document.getElementById("frameReport");
        var p_URL = "";
        var FlagComparePurPlanAndIngr = Ext.getCmp("FlagComparePurPlanAndIngr").getValue();
        var FlagPurPlan = Ext.getCmp("FlagPurPlan").getValue();
        var DispLocDesc = Ext.getCmp("PhaLoc").getRawValue();
        //药房领用登记报表
        if (FlagComparePurPlanAndIngr == true) {
            p_URL = "dhccpmrunqianreport.csp?reportName=DHCST_DrugStat_PlanAndIngrCompareRep.raq&tStartDate=" + StartDate + "&tEndDate=" + EndDate + "&tDispLocId=" + LocId + "&OperateType=" + OperateType + "&QueryFlag=" + QueryFlag + "&DispLocDesc=" + DispLocDesc+"&RQDTFormat="+App_StkRQDateFormat+" "+App_StkRQTimeFormat;
        }
        //计划评估报表
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
                title: $g("查询条件"),
                items: [PhaLoc, DateFrom, DateTo, QueryFlag]
            },
            {
                xtype: "fieldset",
                title: $g("报表类型"),
                items: [FlagComparePurPlanAndIngr, FlagPurPlan]
            }
        ]
    });

    var reportPanel = new Ext.Panel({
        layout: "fit",
        html: '<iframe id="frameReport" height="100%" width="100%" src=' + DHCSTBlankBackGround + ">"
    });
    // 页面布局
    var mainPanel = new Ext.Viewport({
        layout: "border",
        items: [
            {
                region: "west",
                title: $g("药库计划与实际进货统计"),
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
