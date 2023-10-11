var PageLogicObj = {
    CardTypeId: "",
    CardTypeDesc: "",
    m_CardRegDOMArr: new Array(),
    m_DefaultId: ""
}
$(function () {
    var hospComp = GenUserHospComp();
    //初始化
    Init()
    //事件初始化
    InitEvent()
    hospComp.jdata.options.onSelect = function (e, t) {
        //卡类型表格初始化
        CardTypeListDataGridLoad()
        LoadPatType()
    }
    hospComp.jdata.options.onLoadSuccess = function (data) {
        //卡类型表格初始化
        CardTypeListDataGridLoad();
        LoadPatType()
        isjQueryLoadend();
    }
})
//判断JQ是否加载完成没有的话 继续判断
function isjQueryLoadend() {
    if ($("#CardTypeWin").length > 0) {
        InitCache();
    } else {
        setTimeout(isjQueryLoadend, 1000)
    }
}
function InitCache() {
    var hasCache = $.DHCDoc.ConfigHasCache();
    if (hasCache != 1) {
        $.DHCDoc.CacheConfigPage();
        $.DHCDoc.storageConfigPageCache();
    }
}
function Init() {
    InitCardTypeDataGrid();
    //初始化卡号检索方式
    InitSearchCardNoMode()
    //初始化联系人信息必填(年龄)
    InitForeignInfoByAge()
    setTimeout("LoadCardWin()", 100)
}
//初始化卡号检索方式
function InitSearchCardNoMode() {
    $.cm({
        ClassName: "web.DHCBL.UDHCCommFunLibary",
        QueryName: "InitListObjectValueNew",
        ClassName1: "User.DHCCardTypeDef",
        PropertyName: "CTDSearchCardNoMode",
        rows: 99999
    }, function (GridData) {
        var cbox = $HUI.combobox("#SearchCardNoMode", {
            valueField: 'ValueList',
            textField: 'DisplayValue',
            editable: true,
            data: GridData["rows"],
            value: ServerObj.SearchCardNoMode,
            onChange: function (newValue, oldValue) {

            }
        });
    });
}
function InitForeignInfoByAge() {
    var cbox = $HUI.combobox("#ForeignInfoByAge", {
        valueField: 'Value',
        textField: 'Desc',
        editable: true,
        data: [
            { Value: "13", Desc: "13岁以下" },
            { Value: "14", Desc: "14岁以下" },
            { Value: "15", Desc: "15岁以下" },
            { Value: "16", Desc: "16岁以下" },
            { Value: "17", Desc: "17岁以下" },
            { Value: "18", Desc: "18岁以下" }
        ]
    })
}
function InitEvent() {
    $("#BFind").click(BFindClickHandle)
    $("#GlobalSet").click(GlobalSetHandle)
    $("#SetSave").click(SetSaveHandle)
    $("#i-config").click(SaveSelecconfig);
}
function BFindClickHandle() {
    CardTypeListDataGridLoad()
}
function InitCardTypeDataGrid() {
    var Columns = [[
        { field: 'RowId', title: '', hidden: true, },
        { field: 'CTDCode', title: '代码', width: 80 },
        { field: 'CTDDesc', title: '描述', width: 120 },
        { field: 'CTDFareType', title: '收费标志', width: 80 },
        { field: 'CTDPrtINVFlag', title: '需要发票 ', width: 80 },
        { field: 'CTDUseINVType', title: '发票类型', width: 80 },
        { field: 'CTDReclaimFlag', title: '能否回收', width: 80 },
        { field: 'CTDDefaultFlag', title: '默认类型', width: 80 },
        { field: 'CTDCardFareCost', title: '卡费', width: 80, align: 'center' },
        { field: 'CTDCardNoLength', title: '卡号长度', width: 80 },
        { field: 'CTDDateFrom', title: '生效日期', width: 100 },
        { field: 'CTDDateTo', title: '失效日期', width: 100 }
    ]]
    var CardTypeListDataGrid = $("#CardTypeList").datagrid({
        fit: true,
        border: false,
        striped: true,
        singleSelect: true,
        fitColumns: false,
        autoRowHeight: false,
        pagination: true,
        pageSize: 20,
        idField: 'EpisodeID',
        columns: Columns,
        toolbar: [
            {
                iconCls: 'icon-add ',
                text: '新增',
                handler: function () {
                    $("#CardTypeList").datagrid('uncheckAll');
                    PageLogicObj.CardTypeId = "";
                    clearCardTypeWin()
                    $('#CardTypeWin').dialog("open")
                }
            }, {
                iconCls: 'icon-write-order',
                text: '修改',
                handler: function () {
                    if (PageLogicObj.CardTypeId == "") {
                        $.messager.alert("提示", "请选择卡类型!", 'info');
                        return
                    }
                    LoadCardTypeData(PageLogicObj.CardTypeId)
                    $('#CardTypeWin').dialog("open")
                }
            }, '-', {
                text: '授权医院',
                iconCls: 'icon-house',
                handler: ReHospitalHandle
            }/*,{
	        text: '翻译',
	        iconCls: 'icon-translate-word',
	        handler:function(){
		        if(PageLogicObj.CardTypeId==""){
					$.messager.alert("提示", "请选择卡类型!", 'info');
					return 
				}
				
				CreatTranLate("User.DHCCardTypeDef","CTDDesc",PageLogicObj.CardTypeDesc)
		        }
		}
		/*,{
			iconCls: 'icon-cancel',
			text:'删除',
			handler: function(){
				if(PageLogicObj.CardTypeId==""){
					$.messager.alert("提示", "请选择卡类型!", 'info');
					return 
				}
				DeleteCardType(PageLogicObj.CardTypeId)
			}
		}*/
        ],
        onCheck: function (index, row) {

        }, onSelect: function (index, rowData) {
            var CardTypeId = rowData["RowId"];
            PageLogicObj.CardTypeId = CardTypeId
            PageLogicObj.CardTypeDesc = rowData["CTDDesc"]
        },
        onDblClickRow: function (index, row) {
            var CardTypeId = row["RowId"];
            PageLogicObj.CardTypeId = CardTypeId
            PageLogicObj.CardTypeDesc = row["CTDDesc"]
            //LoadCardWin()
            $('#CardTypeWin').dialog("open")
            LoadCardTypeData(PageLogicObj.CardTypeId)
        }
    });
    CardTypeListDataGrid.datagrid('loadData', { 'total': '0', rows: [] });
    return CardTypeListDataGrid;
}
function CardTypeListDataGridLoad() {
    var HospID = $HUI.combogrid('#_HospUserList').getValue();
    $.cm({
        ClassName: "web.DHCBL.CARD.CardTypeDef",
        MethodName: "GetCardTypes",
        Code: $("#SearchCode").val(),
        Desc: $("#SearchDesc").val(),
        HospID: HospID,
        rows: 99999
    }, function (GridData) {
        $("#CardTypeList").datagrid({ loadFilter: DocToolsHUI.lib.pagerFilter }).datagrid('loadData', GridData);
        $("#CardTypeList").datagrid("unselectAll")
    });
}

function LoadCardWin() {
    if (typeof $("#CardTypeWin")[0] == "undefined") {
        $.ajax("reg.dhccardtypedef.win.hui.csp", {
            "type": "GET",
            "dataType": "html",
            "success": function (data, textStatus) {
                $("#previewPanelTemp").html(data)
                $('#CardTypeWin').dialog({
                    resizable: true,
                    modal: true,
                    closed: true
                });
                InitCardTypeWin()

            }
        });
    } else {
        //$('#CardTypeWin').dialog("open")
    }
}
function InitCardTypeWin() {
    //初始化窗口内元素
    var json = []
    // 收费标志
    json.push({ id: "FareType", UserName: "User.DHCCardTypeDef", PropertyName: "CTDFareType" })
    //发票类型
    json.push({ id: "UseINVType", UserName: "User.DHCCardTypeDef", PropertyName: "CTDUseINVType" })
    //读卡方式
    json.push({ id: "ReadCardMode", UserName: "User.DHCCardTypeDef", PropertyName: "CTDReadCardMode" })
    //此卡是否建立对照
    json.push({ id: "PANoCardRefFlag", UserName: "User.DHCCardTypeDef", PropertyName: "CTDPreCardFlag" })
    //此卡于账户的关系
    json.push({ id: "CardAccountRelation", UserName: "User.DHCCardTypeDef", PropertyName: "CTDCardAccountRelation" })
    //是否预先生成卡信息
    json.push({ id: "PreCardFlag", UserName: "User.DHCCardTypeDef", PropertyName: "CTDPreCardFlag" })
    //是否预先生成登记号
    json.push({ id: "SearchMasFlag", UserName: "User.DHCCardTypeDef", PropertyName: "CTDSearchMasFlag" })
    //数据类型转换验证 
    json.push({ id: "StChangeValidateFlag", UserName: "User.DHCCardTypeDef", PropertyName: "CTDStChangeValidateFlag" })
    //此类卡是否重写
    json.push({ id: "OverWriteFlag", UserName: "User.DHCCardTypeDef", PropertyName: "CTDOverWriteFlag" })
    //验证方式
    json.push({ id: "ValidateMode", UserName: "User.DHCCardTypeDef", PropertyName: "CTDValidateMode" })

    for (var i = 0; i < json.length; i++) {
        var jsonObj = json[i]
        InitCombobox(jsonObj)
    }
    //初始化聚集元素
    var focusJson = []
    focusJson.push({ id: "ReadCardFocusElement" })
    focusJson.push({ id: "CardRefFocusElement" })
    focusJson.push({ id: "SetFocusElement" })
    for (var i = 0; i < focusJson.length; i++) {
        var jsonObj = focusJson[i]
        InitFocusElement(jsonObj)
    }
    //初始化读卡设备
    InitHardComDR()
    //初始化条码设备
    InitBarCodeComDR()
    //发票打印模版名称
    InitINVPRTXMLName()
    //病案首页打印模版
    InitPatPageXMLName()
    //患者类型
    LoadPatType()
    // 初始化外部卡数据
    InitExtCardLinkStr()
    //证件类型列表
    InitCreadType()
	//账户创建模式
	InitAccMCreatMode()
	
    var cbox = $HUI.datebox("#DateFrom", {})

    var cbox = $HUI.datebox("#DateTo", {})

    $.each(FieldJson, function (name, value) {
        var className = $("#" + value).attr("class")
        if (className.indexOf("hisui-switchbox") >= 0) {
            $HUI.switchbox("#" + value, {})
        }
    })
    /*var arr=$(".hisui-switchbox")
    for(var i=0;i<arr.length;i++){
        $HUI.switchbox("#"+arr[i].id,{})
    }*/
    ///初始化保存按钮
    $HUI.linkbutton("#Save", {})
    $("#Save").bind("click", SaveClick)

    $("#CardNoLength").keyup(function () {  //keyup事件处理 
        $(this).val($(this).val().replace(/\D|^0/g, ''));
    }).bind("paste", function () {  //CTR+V事件处理 
        $(this).val($(this).val().replace(/\D|^0/g, ''));
    }).css("ime-mode", "disabled");  //CSS设置输入法不可用

}
///"UDHCCardPatInfoRegExp","","0"
function InitFocusElement(jsonObj) {
    /*$.cm({
            ClassName:"web.DHCBL.UDHCCommFunLibary",
            QueryName:"ReadComponentItem",
            ComponentName:"UDHCCardPatInfoRegExp",
            DisType:"",
            HiddenFlag:0,
            rows:99999
        },function(GridData){
            var cbox = $HUI.combobox("#"+jsonObj.id, {
                    valueField: 'Name',
                    textField: 'Caption', 
                    editable:true,
                    data: GridData["rows"]
             });
    });*/
    var HospID = $HUI.combogrid('#_HospUserList').getValue();
    $.cm({
        ClassName: "web.DHCBL.CARD.CardPATRegConfig",
        MethodName: "GetCardRegDOMCache",
        HospId: HospID //session['LOGON.HOSPID']
    }, function (data) {
        for (var oe in data) {
            var text = data[oe];
            PageLogicObj.m_CardRegDOMArr.push({ "id": oe, "text": text });
        }
        var cbox = $HUI.combobox("#" + jsonObj.id, {
            valueField: 'id',
            textField: 'text',
            data: PageLogicObj.m_CardRegDOMArr
        });
    })
}
function InitCombobox(jsonObj) {
    $.cm({
        ClassName: "web.DHCBL.UDHCCommFunLibary",
        QueryName: "InitListObjectValueNew",
        ClassName1: jsonObj.UserName,
        PropertyName: jsonObj.PropertyName,
        rows: 99999
    }, function (GridData) {
        var cbox = $HUI.combobox("#" + jsonObj.id, {
            valueField: 'ValueList',
            textField: 'DisplayValue',
            editable: true,
            data: GridData["rows"]
        });
    });
}
///初始化读卡设备
function InitHardComDR() {
    $.cm({
        ClassName: "web.DHCBL.CARD.CardTypeDef",
        QueryName: "CardEquipmentQuery",
        Name: "",
        rows: 99999
    }, function (GridData) {
        var cbox = $HUI.combobox("#HardComDR", {
            valueField: 'CCM_RowID',
            textField: 'CCM_Desc',
            editable: true,
            data: GridData["rows"],
            filter: function (q, row) {
                //return (row["DisplayValue"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["Alias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
            }
        });
    });
}
function InitBarCodeComDR() {
    $.cm({
        ClassName: "web.DHCBL.CARD.CardTypeDef",
        QueryName: "BarCodeEquipmentQuery",
        Name: "",
        rows: 99999
    }, function (GridData) {
        var cbox = $HUI.combobox("#BarCodeComDR", {
            valueField: 'CCM_RowID',
            textField: 'CCM_Desc',
            editable: true,
            data: GridData["rows"]
        });
    });
}
function InitINVPRTXMLName() {
    $.cm({
        ClassName: "web.DHCBL.CARD.CardTypeDef",
        QueryName: "XMLPConfigQuery",
        Name: "",
        rows: 99999
    }, function (GridData) {
        var cbox = $HUI.combobox("#INVPRTXMLName", {
            valueField: '模板名称',
            textField: '模板名称',
            editable: true,
            data: GridData["rows"]
        });
    });
}
function InitPatPageXMLName() {
    $.cm({
        ClassName: "web.DHCBL.CARD.CardTypeDef",
        QueryName: "XMLPConfigQuery",
        Name: "",
        rows: 99999
    }, function (GridData) {
        var cbox = $HUI.combobox("#PatPageXMLName", {
            valueField: '模板名称',
            textField: '模板名称',
            editable: true,
            data: GridData["rows"]
        });
    });
}
function LoadCardTypeData(CardTypeId) {
    clearCardTypeWin()
    $.cm({
        ClassName: "web.DHCBL.CARD.CardTypeDef",
        MethodName: "GetCardTypeDataJson",
        RowId: CardTypeId,
        jsonFiledStr: JSON.stringify(FieldJson),
        ClassDesc: "User.DHCCardTypeDef"
    }, function (CardTypeData) {
        //alert(JSON.stringify(CardTypeData))
        if (CardTypeData != "") {
            $.each(CardTypeData, function (name, value) {
                if (name == "ActiveFlag") {
                    value = (value == "IE" ? "Y" : "N")
                }
                setValue(name, value)
            })
        }
    });
}

function SaveClick() {
    if (!CheckBefore()) return
    var dataJson = {}
    $.each(FieldJson, function (name, value) {
        var val = getValue(value)
        if (value == "ActiveFlag") {
            val = (val == "Y" ? 'IE' : 'SU')
        }
        val = '"' + val + '"'
        eval("dataJson." + name + "=" + val)
    })
    var jsonStr = JSON.stringify(dataJson)
    var HospID = $HUI.combogrid('#_HospUserList').getValue();
    $m({
        ClassName: "web.DHCBL.CARD.CardTypeDef",
        MethodName: "SaveByJson",
        CardTypeId: PageLogicObj.CardTypeId, HospID: HospID,
        JsonStr: jsonStr
    }, function (txtData) {
        if (txtData == 0) {
            //alert("新增加卡类型成功")
            CardTypeListDataGridLoad()
            $('#CardTypeWin').dialog('close')
        }
    });
}
///删除卡类型
function DeleteCardType(CardTypeId) {
    if (CardTypeId == "") return
    if (!confirm("是否删除该类型?")) return
    $m({
        ClassName: "web.DHCBL.CARD.CardTypeDef",
        MethodName: "Delete",
        RowId: CardTypeId
    }, function (txtData) {
        if (txtData == 1) {
            CardTypeListDataGridLoad()
            $.messager.show({
                title: '提示',
                msg: '卡类型删除成功',
                timeout: 3000,
                showType: 'slide'/*,
				style:{
				right:'',
					top:document.body.scrollTop+document.documentElement.scrollTop, //顶端中间显示
					bottom:''
			}*/
            });
            PageLogicObj.CardTypeId = ""
        } else {
            $.messager.show({
                title: '提示',
                msg: '卡类型删除失败',
                timeout: 3000,
                showType: 'slide'/*,
				style:{
				right:'',
					top:document.body.scrollTop+document.documentElement.scrollTop, //顶端中间显示
					bottom:''
			}*/
            });
        }
    });
}
///保存前的正确性判断
function CheckBefore() {
    var Code = $.trim($("#Code").val())
    if (Code == "") {
        $.messager.alert("提示", "代码不能为空", 'info');
        $("#Code").focus()
        return false
    }
    var Desc = $.trim($("#Desc").val())
    if (Desc == "") {
        $.messager.alert("提示", "描述不能为空", 'info');
        $("#Desc").focus()
        return false
    }
    var DateFrom = $("#DateFrom").datebox("getValue")
    if (DateFrom == "") {
        $.messager.alert("提示", "生效日期不能为空", 'info');
        $("#DateFrom").focus()
        return false
    }
    var FareType = $("#FareType").combobox("getValue")
    var CardFareCost = $("#CardFareCost").val()
    if ((FareType == "C") && (+CardFareCost == "0")) {
        $.messager.alert("提示", Desc + "收费标志是Charge,支付的金额不能为空或0", 'info');
        return false;
    }
    var CardNoLength = getValue("CardNoLength");
    var UsePANoToCardNO = getValue("UsePANoToCardNO");
    if ((UsePANoToCardNO == "Y") && (CardNoLength != 10)) {
        $.messager.alert("提示", "卡号和登记号长度不一致,不能设置登记号做卡号!登记号长度：10", 'info', function () {
            $("#CardNoLength").focus();
        });
        return false;
    }
    var ExtCardLinkStr = getValue("ExtCardLinkStr");
    var AllowNoCardNoFlag = getValue("AllowNoCardNoFlag");
    if ((AllowNoCardNoFlag == "Y") && (ExtCardLinkStr == "")) {
        $.messager.alert("提示", "【外部卡号可为空】配置,需先维护外部卡关联", 'info', function () {
            $("#ExtCardLinkStr").focus();
        });
        return false;
    }
    var AccMCreatMod = $("#AccMCreatMode").combobox("getValue")
    if (AccMCreatMod==""){
	    $.messager.alert("提示", "创建账户类型不能为空", 'info', function () {
            $("#AccMCreatMode").focus();
        });
        return false;
	    }
    return true
}
///根据元素的classname获取元素值
function getValue(id) {
    var className = $("#" + id).attr("class")
    if (typeof className == "undefined") {
        return ""
    }
    if (className.indexOf("hisui-switchbox") >= 0) {
        var val = $("#" + id).switchbox("getValue")
        return val = (val ? 'Y' : 'N')
    } else if (className.indexOf("hisui-combobox") >= 0) {
        /*if(id=="NotPayCardFeePatType"){
            return $("#"+id).combobox("getValues")
        }
        else return $("#"+id).combobox("getValue") */
        return $("#" + id).combobox("getValues")
    } else if (className.indexOf("hisui-datebox") >= 0) {
        return $("#" + id).datebox("getValue")
    } else {
        return $("#" + id).val()
    }
    return ""
}
///给元素赋值
function setValue(id, val) {
    var className = $("#" + id).attr("class")
    if (typeof className == "undefined") {
        return ""
    }
    if (className.indexOf("hisui-switchbox") >= 0) {
        val = (val == "Y" ? true : false)
        $("#" + id).switchbox("setValue", val)
    } else if (className.indexOf("hisui-combobox") >= 0) {
        /*if(id=="NotPayCardFeePatType"){
            if (val!=""){
                var valarr=val.split(",")
                $("#"+id).combobox("setValues",valarr)
            }else {
                $("#"+id).combobox("setValues","")
            }
        }
        else $("#"+id).combobox("setValue",val) */
		//如果val为空时，且combobox为多选，会导致选择数据时多一个"," 有问题(如：NotPayCardFeePatType)
        var valArr = (val!="") ? val.split(",") : [];
        $("#" + id).combobox("setValues", valArr);
    } else if (className.indexOf("hisui-datebox") >= 0) {
        $("#" + id).datebox("setValue", val)
    } else {
        $("#" + id).val(val)
    }
    return ""
}
///卡类型编辑窗口清屏
function clearCardTypeWin() {
    $.each(FieldJson, function (name, value) {
        var val = '"' + "" + '"'
        setValue(value, "")
    })
}
function GlobalSetHandle() {
    $('#CardGlobalSet').dialog("open")
    $('#CardGlobalSet').dialog("center")
    $m({
        ClassName: "web.DHCBL.CARD.CardTypeDef",
        MethodName: "GetCardTypeSet"
    }, function (txtData) {
        var txtDataArr = txtData.split("^")
        $("#SearchCardNoMode").combobox("setValue", txtDataArr[0])
        $("#AllowAgeNoCreadCard").val(txtDataArr[1])
        var CanNoCread = txtDataArr[2]
        if (CanNoCread == "Y") {
            $("#CanNoCread").switchbox("setValue", true)
        } else {
            $("#CanNoCread").switchbox("setValue", false)
        }
        $("#ForeignInfoByAge").combobox("setValue", txtDataArr[3])
    }
    )

}
function SetSaveHandle() {
    var SearchCardNoMode = $("#SearchCardNoMode").combobox("getValue")
    var AllowAgeNoCreadCard = $("#AllowAgeNoCreadCard").val()
    var CanNoCread = $("#CanNoCread").switchbox("getValue")
    var ForeignInfoByAge = $("#ForeignInfoByAge").combobox("getValue")
    if (!ForeignInfoByAge) ForeignInfoByAge = ""
    CanNoCread = (CanNoCread ? 'Y' : 'N')
    $m({
        ClassName: "web.DHCBL.CARD.CardTypeDef",
        MethodName: "SaveCardTypeSet",
        SetStr: SearchCardNoMode + "^" + AllowAgeNoCreadCard + "^" + CanNoCread + "^" + ForeignInfoByAge
    }, function (txtData) {
        $.messager.popover({ msg: '保存成功!', type: 'success', timeout: 1000 });
    }
    )
}
function ReHospitalHandle() {
    if (PageLogicObj.CardTypeId == "") {
        $.messager.alert("提示", "请选择卡类型!", 'info');
        return
    }
    GenHospWin("DHC_CardTypeDef", PageLogicObj.CardTypeId, function () {
        debugger;
    });
    /*$("#ReHospital-dialog").dialog("open");
    $.cm({
            ClassName:"DHCDoc.DHCDocConfig.InstrArcim",
            QueryName:"GetHos",
            rows:99999
        },function(GridData){
            var cbox = $HUI.combobox("#Hosp", {
                editable:false,
                valueField: 'HOSPRowId',
                textField: 'HOSPDesc', 
                data: GridData["rows"],
                onLoadSuccess:function(){
                    $("#Hosp").combobox('select','');
                }
             });
    });
    PageLogicObj.m_ReHospitalDataGrid=ReHospitalDataGrid();
    LoadReHospitalDataGrid();*/
}
function ReHospitalDataGrid() {
    var toobar = [{
        text: '增加',
        iconCls: 'icon-add',
        handler: function () { ReHospitaladdClickHandle(); }
    }, {
        text: '删除',
        iconCls: 'icon-remove',
        handler: function () { ReHospitaldelectClickHandle(); }
    }];
    var Columns = [[
        { field: 'Rowid', hidden: true, title: 'Rowid' },
        { field: 'HospID', hidden: true, title: 'HospID' },
        { field: 'HospDesc', title: '医院', width: 100 }
    ]]
    var ReHospitalDataGrid = $("#ReHospitalTab").datagrid({
        fit: true,
        border: false,
        striped: false,
        singleSelect: true,
        fitColumns: true,
        autoRowHeight: false,
        rownumbers: true,
        pagination: true,
        rownumbers: true,
        pageSize: 20,
        pageList: [20, 50, 100],
        idField: 'Rowid',
        columns: Columns,
        toolbar: toobar
    });
    return ReHospitalDataGrid;
}
function LoadReHospitalDataGrid() {
    $.q({
        ClassName: "web.DHCOPRegConfig",
        QueryName: "FindHopital",
        BDPMPHTableName: "DHC_CardTypeDef",
        BDPMPHDataReference: PageLogicObj.CardTypeId,
        Pagerows: PageLogicObj.m_ReHospitalDataGrid.datagrid("options").pageSize, rows: 99999
    }, function (GridData) {
        PageLogicObj.m_ReHospitalDataGrid.datagrid("unselectAll");
        PageLogicObj.m_ReHospitalDataGrid.datagrid({ loadFilter: DocToolsHUI.lib.pagerFilter }).datagrid('loadData', GridData);
    });
}
function ReHospitaladdClickHandle() {
    var HospID = $("#Hosp").combobox("getValue")
    if (HospID == "") {
        $.messager.alert("提示", "请选择医院", "info");
        return false;
    }
    $.cm({
        ClassName: "DHCDoc.Common.Hospital",
        MethodName: "SaveHOSP",
        BDPMPHTableName: "DHC_CardTypeDef",
        BDPMPHDataReference: PageLogicObj.CardTypeId,
        BDPMPHHospital: HospID,
        dataType: "text",
    }, function (data) {
        if (data == "1") {
            $.messager.alert("提示", "增加重复", "info");
        } else {
            $.messager.popover({ msg: data.split("^")[1], type: 'success', timeout: 1000 });
            LoadReHospitalDataGrid();
        }
    })
}
function ReHospitaldelectClickHandle() {
    var SelectedRow = PageLogicObj.m_ReHospitalDataGrid.datagrid('getSelected');
    if (!SelectedRow) {
        $.messager.alert("提示", "请选择一行", "info");
        return false;
    }
    $.cm({
        ClassName: "DHCDoc.Common.Hospital",
        MethodName: "DeleteHospital",
        BDPMPHTableName: "DHC_CardTypeDef",
        BDPMPHDataReference: PageLogicObj.CardTypeId,
        BDPMPHHospital: SelectedRow.HospID,
        dataType: "text",
    }, function (data) {
        $.messager.popover({ msg: '删除成功!', type: 'success', timeout: 1000 });
        LoadReHospitalDataGrid();
    })
}
function LoadPatType() {
    var HospID = $HUI.combogrid('#_HospUserList').getValue();
    var SessionStr = "^" + session['LOGON.USERID'] + "^" + session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'] + "^" + HospID + "^" + session['LOGON.SITECODE'] + "^"
    $.cm({
        ClassName: "web.UDHCOPOtherLB",
        MethodName: "ReadPatTypeAll",
        JSFunName: "GetPatTypeToHUIJson",
        ListName: "",
        SessionStr: SessionStr,
        dataType: "text",
    }, function (data) {
        $("#NotPayCardFeePatType").combobox({
            valueField: 'id',
            textField: 'text',
            multiple: true,
            editable: false,
            blurValidValue: true,
            data: JSON.parse(data),
            onSelect: function (rec) {
                //PatTypeOnChange();
            }
        })
    })
}
function InitExtCardLinkStr() {
    var cbox = $HUI.combobox("#ExtCardLinkStr", {
        valueField: 'id',
        textField: 'text',
        editable: false,
        multiple: true,
        rowStyle: 'checkbox',
        selectOnNavigation: false,
        panelHeight: "auto",
        data: eval("(" + ServerObj.ExtCardJson + ")"),
        onLoadSuccess: function () {
            return;
            var sbox = $HUI.combobox("#ExtCardLinkStr");
            var DiagOtherInfoArr = ServerObj.DiagOtherInfo.split(String.fromCharCode(1));
            for (i = 0; i < DiagOtherInfoArr[8].split("^").length; i++) {
                sbox.select(DiagOtherInfoArr[8].split("^")[i]);
            }
        }
    });
}

function InitCreadType() {
    //添加图标
    var target = $("#CredTypeList")[0];
    $(target).width($(target).width() - 40).addClass('combo2');
    var arrow = $('<span class="combo2-arrow"></span>').insertAfter(target);
    $(arrow).off('click.combo2').on('click.combo2', function () {
        if ($(this).hasClass('disabled')) return false;
        OpenCredTypeList();
    })
    //加载数据
    var Data = $.cm({
        ClassName: "web.UDHCAccCredType",
        MethodName: "GetActiveCredType"
    }, false);
    for (var i = 0; i < Data.length; i++) {
        $("#jzul").append("<li id='in-" + Data[i]["TCredTypeID"] + "' value=" + Data[i]["TCredTypeID"] + ">" + Data[i]["TCredDesc"] + "</li>");
        $("#jzul-set").append("<li id='i-" + Data[i]["TCredTypeID"] + "' value=" + Data[i]["TCredTypeID"] + ">" + "设置为默认" + "</li>");
    }
    $("#jzul>li,#zydateul>li,#prelocul>li").on('click', function () {
        if ($(this).hasClass('active')) {
            $(this).removeClass('active');
        } else {
            $(this).addClass('active');
        }
    });
    return
}
function SaveSelecconfig() {
    var CredTypeList = "";
    var CredTypeListStr = "";
    var CredTypeDefault = "";
    $("#jzul>li.active").each(function () {
        if (CredTypeListStr == "") {
            CredTypeListStr = $(this).attr("value");
            CredTypeList = $(this).text();
        } else {
            CredTypeListStr = CredTypeListStr + "," + $(this).attr("value");
            CredTypeList = CredTypeList + "," + $(this).text();
        }
    })
    $("#jzul-set>li.default").each(function () {
        if (CredTypeDefault == "") {
            CredTypeDefault = $(this).attr("value");
        } else {
            CredTypeDefault = CredTypeDefault + "," + $(this).attr("value");
        }
    })
    $("#CredTypeList").val(CredTypeList);
    $("#CredTypeListStr").val(CredTypeListStr);
    $("#CredTypeDefault").val(CredTypeDefault);
    $('#dialog-CreadSelect').window('close');
    return;
}

function OpenCredTypeList() {
    $('#dialog-CreadSelect').window('open');
    var CredTypeListStr = $("#CredTypeListStr").val();
    var CredTypeDefault = $("#CredTypeDefault").val();
    if (CredTypeListStr != "") {
        CredTypeListStr = "," + CredTypeListStr + ",";
    } else {
        $("#jzul-set>li").each(function () {
            if ($(this).text() == "默认") {
                $(this).text("设置为默认").removeClass("default");
            }
        });
    }
    $("#jzul>li").each(function () {
        var curCid = $(this).attr("value");
        cid = "," + curCid + ",";
        if (CredTypeListStr.indexOf(cid) >= 0) {
            if (!$(this).hasClass('active')) {
                $(this).addClass('active');
            }
            if (cid == ("," + CredTypeDefault + ",")) {
                $(this).addClass('selected');
                $("#i-" + curCid).html("默认");
                $("#i-" + curCid).addClass("default");
                PageLogicObj.m_DefaultId = curCid;
            } else {
                $(this).removeClass('selected');
                $("#i-" + curCid).html("设置为默认");
                $("#i-" + curCid).removeClass("default");
            }
        } else {
            $(this).removeClass('active');
            $(this).removeClass('selected');
            if ($("#i-" + curCid).text() == "默认") {
                $("#i-" + curCid).text("设置为默认").removeClass("default");
            }
        }
    });
    $("#jzul-set>li").unbind("click");
    $("#jzul-set>li").on('click', function () {
        var cidV = $(this).attr("id");
        cid = cidV.split("-")[1];
        var inLoc = cid;
        var isDefault = $(this).hasClass("default");
        var LocName = $("#in-" + cid).text();
        var Msg = "您确认<span style='color:blue; font-size:16px;'>设置为默认</span>【" + LocName + "】为默认么？";
        var action = "edit";
        if (isDefault) {
            Msg = "您确认<span style='color:red; font-size:16px;'>取消</span>【" + LocName + "】默认么？";
            action = "cancel";
        }
        $.messager.confirm('提示', Msg, function (r) {
            if (r) {
                if (action == "cancel") {
                    inLoc = "";
                }
                if (action == "cancel") {
                    $("#in-" + cid).removeClass('selected');
                    $("#i-" + cid).text("设置为默认");
                    $("#i-" + cid).removeClass("default");
                    PageLogicObj.m_DefaultId = "";
                } else {
                    if (PageLogicObj.m_DefaultId != "") {
                        $("#in-" + PageLogicObj.m_DefaultId).removeClass("selected");
                        $("#i-" + PageLogicObj.m_DefaultId).removeClass("default");
                        $("#i-" + PageLogicObj.m_DefaultId).text("设置为默认");
                    }
                    $("#in-" + cid).addClass("selected");
                    $("#in-" + cid).addClass("active");
                    $("#i-" + cid).addClass("default");
                    $("#i-" + cid).text("默认");
                    PageLogicObj.m_DefaultId = cid;
                }
            }
        });
    });
}
function InitAccMCreatMode(){
	$("#AccMCreatMode").combobox({
            valueField: 'id',
            textField: 'text',
            multiple: false,
            editable: false,
            blurValidValue: true,
            data: [{id:"P",text:"患者主索引"},{id:"C",text:"卡索引"}],
            onSelect: function (rec) {
                //PatTypeOnChange();
            }
        })
	}