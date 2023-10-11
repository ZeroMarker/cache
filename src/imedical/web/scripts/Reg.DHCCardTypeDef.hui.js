var PageLogicObj = {
    CardTypeId: "",
    CardTypeDesc: "",
    m_CardRegDOMArr: new Array(),
    m_DefaultId: ""
}
$(function () {
    var hospComp = GenUserHospComp();
    //��ʼ��
    Init()
    //�¼���ʼ��
    InitEvent()
    hospComp.jdata.options.onSelect = function (e, t) {
        //�����ͱ���ʼ��
        CardTypeListDataGridLoad()
        LoadPatType()
    }
    hospComp.jdata.options.onLoadSuccess = function (data) {
        //�����ͱ���ʼ��
        CardTypeListDataGridLoad();
        LoadPatType()
        isjQueryLoadend();
    }
})
//�ж�JQ�Ƿ�������û�еĻ� �����ж�
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
    //��ʼ�����ż�����ʽ
    InitSearchCardNoMode()
    //��ʼ����ϵ����Ϣ����(����)
    InitForeignInfoByAge()
    setTimeout("LoadCardWin()", 100)
}
//��ʼ�����ż�����ʽ
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
            { Value: "13", Desc: "13������" },
            { Value: "14", Desc: "14������" },
            { Value: "15", Desc: "15������" },
            { Value: "16", Desc: "16������" },
            { Value: "17", Desc: "17������" },
            { Value: "18", Desc: "18������" }
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
        { field: 'CTDCode', title: '����', width: 80 },
        { field: 'CTDDesc', title: '����', width: 120 },
        { field: 'CTDFareType', title: '�շѱ�־', width: 80 },
        { field: 'CTDPrtINVFlag', title: '��Ҫ��Ʊ ', width: 80 },
        { field: 'CTDUseINVType', title: '��Ʊ����', width: 80 },
        { field: 'CTDReclaimFlag', title: '�ܷ����', width: 80 },
        { field: 'CTDDefaultFlag', title: 'Ĭ������', width: 80 },
        { field: 'CTDCardFareCost', title: '����', width: 80, align: 'center' },
        { field: 'CTDCardNoLength', title: '���ų���', width: 80 },
        { field: 'CTDDateFrom', title: '��Ч����', width: 100 },
        { field: 'CTDDateTo', title: 'ʧЧ����', width: 100 }
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
                text: '����',
                handler: function () {
                    $("#CardTypeList").datagrid('uncheckAll');
                    PageLogicObj.CardTypeId = "";
                    clearCardTypeWin()
                    $('#CardTypeWin').dialog("open")
                }
            }, {
                iconCls: 'icon-write-order',
                text: '�޸�',
                handler: function () {
                    if (PageLogicObj.CardTypeId == "") {
                        $.messager.alert("��ʾ", "��ѡ������!", 'info');
                        return
                    }
                    LoadCardTypeData(PageLogicObj.CardTypeId)
                    $('#CardTypeWin').dialog("open")
                }
            }, '-', {
                text: '��ȨҽԺ',
                iconCls: 'icon-house',
                handler: ReHospitalHandle
            }/*,{
	        text: '����',
	        iconCls: 'icon-translate-word',
	        handler:function(){
		        if(PageLogicObj.CardTypeId==""){
					$.messager.alert("��ʾ", "��ѡ������!", 'info');
					return 
				}
				
				CreatTranLate("User.DHCCardTypeDef","CTDDesc",PageLogicObj.CardTypeDesc)
		        }
		}
		/*,{
			iconCls: 'icon-cancel',
			text:'ɾ��',
			handler: function(){
				if(PageLogicObj.CardTypeId==""){
					$.messager.alert("��ʾ", "��ѡ������!", 'info');
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
    //��ʼ��������Ԫ��
    var json = []
    // �շѱ�־
    json.push({ id: "FareType", UserName: "User.DHCCardTypeDef", PropertyName: "CTDFareType" })
    //��Ʊ����
    json.push({ id: "UseINVType", UserName: "User.DHCCardTypeDef", PropertyName: "CTDUseINVType" })
    //������ʽ
    json.push({ id: "ReadCardMode", UserName: "User.DHCCardTypeDef", PropertyName: "CTDReadCardMode" })
    //�˿��Ƿ�������
    json.push({ id: "PANoCardRefFlag", UserName: "User.DHCCardTypeDef", PropertyName: "CTDPreCardFlag" })
    //�˿����˻��Ĺ�ϵ
    json.push({ id: "CardAccountRelation", UserName: "User.DHCCardTypeDef", PropertyName: "CTDCardAccountRelation" })
    //�Ƿ�Ԥ�����ɿ���Ϣ
    json.push({ id: "PreCardFlag", UserName: "User.DHCCardTypeDef", PropertyName: "CTDPreCardFlag" })
    //�Ƿ�Ԥ�����ɵǼǺ�
    json.push({ id: "SearchMasFlag", UserName: "User.DHCCardTypeDef", PropertyName: "CTDSearchMasFlag" })
    //��������ת����֤ 
    json.push({ id: "StChangeValidateFlag", UserName: "User.DHCCardTypeDef", PropertyName: "CTDStChangeValidateFlag" })
    //���࿨�Ƿ���д
    json.push({ id: "OverWriteFlag", UserName: "User.DHCCardTypeDef", PropertyName: "CTDOverWriteFlag" })
    //��֤��ʽ
    json.push({ id: "ValidateMode", UserName: "User.DHCCardTypeDef", PropertyName: "CTDValidateMode" })

    for (var i = 0; i < json.length; i++) {
        var jsonObj = json[i]
        InitCombobox(jsonObj)
    }
    //��ʼ���ۼ�Ԫ��
    var focusJson = []
    focusJson.push({ id: "ReadCardFocusElement" })
    focusJson.push({ id: "CardRefFocusElement" })
    focusJson.push({ id: "SetFocusElement" })
    for (var i = 0; i < focusJson.length; i++) {
        var jsonObj = focusJson[i]
        InitFocusElement(jsonObj)
    }
    //��ʼ�������豸
    InitHardComDR()
    //��ʼ�������豸
    InitBarCodeComDR()
    //��Ʊ��ӡģ������
    InitINVPRTXMLName()
    //������ҳ��ӡģ��
    InitPatPageXMLName()
    //��������
    LoadPatType()
    // ��ʼ���ⲿ������
    InitExtCardLinkStr()
    //֤�������б�
    InitCreadType()
	//�˻�����ģʽ
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
    ///��ʼ�����水ť
    $HUI.linkbutton("#Save", {})
    $("#Save").bind("click", SaveClick)

    $("#CardNoLength").keyup(function () {  //keyup�¼����� 
        $(this).val($(this).val().replace(/\D|^0/g, ''));
    }).bind("paste", function () {  //CTR+V�¼����� 
        $(this).val($(this).val().replace(/\D|^0/g, ''));
    }).css("ime-mode", "disabled");  //CSS�������뷨������

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
///��ʼ�������豸
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
            valueField: 'ģ������',
            textField: 'ģ������',
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
            valueField: 'ģ������',
            textField: 'ģ������',
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
            //alert("�����ӿ����ͳɹ�")
            CardTypeListDataGridLoad()
            $('#CardTypeWin').dialog('close')
        }
    });
}
///ɾ��������
function DeleteCardType(CardTypeId) {
    if (CardTypeId == "") return
    if (!confirm("�Ƿ�ɾ��������?")) return
    $m({
        ClassName: "web.DHCBL.CARD.CardTypeDef",
        MethodName: "Delete",
        RowId: CardTypeId
    }, function (txtData) {
        if (txtData == 1) {
            CardTypeListDataGridLoad()
            $.messager.show({
                title: '��ʾ',
                msg: '������ɾ���ɹ�',
                timeout: 3000,
                showType: 'slide'/*,
				style:{
				right:'',
					top:document.body.scrollTop+document.documentElement.scrollTop, //�����м���ʾ
					bottom:''
			}*/
            });
            PageLogicObj.CardTypeId = ""
        } else {
            $.messager.show({
                title: '��ʾ',
                msg: '������ɾ��ʧ��',
                timeout: 3000,
                showType: 'slide'/*,
				style:{
				right:'',
					top:document.body.scrollTop+document.documentElement.scrollTop, //�����м���ʾ
					bottom:''
			}*/
            });
        }
    });
}
///����ǰ����ȷ���ж�
function CheckBefore() {
    var Code = $.trim($("#Code").val())
    if (Code == "") {
        $.messager.alert("��ʾ", "���벻��Ϊ��", 'info');
        $("#Code").focus()
        return false
    }
    var Desc = $.trim($("#Desc").val())
    if (Desc == "") {
        $.messager.alert("��ʾ", "��������Ϊ��", 'info');
        $("#Desc").focus()
        return false
    }
    var DateFrom = $("#DateFrom").datebox("getValue")
    if (DateFrom == "") {
        $.messager.alert("��ʾ", "��Ч���ڲ���Ϊ��", 'info');
        $("#DateFrom").focus()
        return false
    }
    var FareType = $("#FareType").combobox("getValue")
    var CardFareCost = $("#CardFareCost").val()
    if ((FareType == "C") && (+CardFareCost == "0")) {
        $.messager.alert("��ʾ", Desc + "�շѱ�־��Charge,֧���Ľ���Ϊ�ջ�0", 'info');
        return false;
    }
    var CardNoLength = getValue("CardNoLength");
    var UsePANoToCardNO = getValue("UsePANoToCardNO");
    if ((UsePANoToCardNO == "Y") && (CardNoLength != 10)) {
        $.messager.alert("��ʾ", "���ź͵ǼǺų��Ȳ�һ��,�������õǼǺ�������!�ǼǺų��ȣ�10", 'info', function () {
            $("#CardNoLength").focus();
        });
        return false;
    }
    var ExtCardLinkStr = getValue("ExtCardLinkStr");
    var AllowNoCardNoFlag = getValue("AllowNoCardNoFlag");
    if ((AllowNoCardNoFlag == "Y") && (ExtCardLinkStr == "")) {
        $.messager.alert("��ʾ", "���ⲿ���ſ�Ϊ�ա�����,����ά���ⲿ������", 'info', function () {
            $("#ExtCardLinkStr").focus();
        });
        return false;
    }
    var AccMCreatMod = $("#AccMCreatMode").combobox("getValue")
    if (AccMCreatMod==""){
	    $.messager.alert("��ʾ", "�����˻����Ͳ���Ϊ��", 'info', function () {
            $("#AccMCreatMode").focus();
        });
        return false;
	    }
    return true
}
///����Ԫ�ص�classname��ȡԪ��ֵ
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
///��Ԫ�ظ�ֵ
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
		//���valΪ��ʱ����comboboxΪ��ѡ���ᵼ��ѡ������ʱ��һ��"," ������(�磺NotPayCardFeePatType)
        var valArr = (val!="") ? val.split(",") : [];
        $("#" + id).combobox("setValues", valArr);
    } else if (className.indexOf("hisui-datebox") >= 0) {
        $("#" + id).datebox("setValue", val)
    } else {
        $("#" + id).val(val)
    }
    return ""
}
///�����ͱ༭��������
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
        $.messager.popover({ msg: '����ɹ�!', type: 'success', timeout: 1000 });
    }
    )
}
function ReHospitalHandle() {
    if (PageLogicObj.CardTypeId == "") {
        $.messager.alert("��ʾ", "��ѡ������!", 'info');
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
        text: '����',
        iconCls: 'icon-add',
        handler: function () { ReHospitaladdClickHandle(); }
    }, {
        text: 'ɾ��',
        iconCls: 'icon-remove',
        handler: function () { ReHospitaldelectClickHandle(); }
    }];
    var Columns = [[
        { field: 'Rowid', hidden: true, title: 'Rowid' },
        { field: 'HospID', hidden: true, title: 'HospID' },
        { field: 'HospDesc', title: 'ҽԺ', width: 100 }
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
        $.messager.alert("��ʾ", "��ѡ��ҽԺ", "info");
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
            $.messager.alert("��ʾ", "�����ظ�", "info");
        } else {
            $.messager.popover({ msg: data.split("^")[1], type: 'success', timeout: 1000 });
            LoadReHospitalDataGrid();
        }
    })
}
function ReHospitaldelectClickHandle() {
    var SelectedRow = PageLogicObj.m_ReHospitalDataGrid.datagrid('getSelected');
    if (!SelectedRow) {
        $.messager.alert("��ʾ", "��ѡ��һ��", "info");
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
        $.messager.popover({ msg: 'ɾ���ɹ�!', type: 'success', timeout: 1000 });
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
    //���ͼ��
    var target = $("#CredTypeList")[0];
    $(target).width($(target).width() - 40).addClass('combo2');
    var arrow = $('<span class="combo2-arrow"></span>').insertAfter(target);
    $(arrow).off('click.combo2').on('click.combo2', function () {
        if ($(this).hasClass('disabled')) return false;
        OpenCredTypeList();
    })
    //��������
    var Data = $.cm({
        ClassName: "web.UDHCAccCredType",
        MethodName: "GetActiveCredType"
    }, false);
    for (var i = 0; i < Data.length; i++) {
        $("#jzul").append("<li id='in-" + Data[i]["TCredTypeID"] + "' value=" + Data[i]["TCredTypeID"] + ">" + Data[i]["TCredDesc"] + "</li>");
        $("#jzul-set").append("<li id='i-" + Data[i]["TCredTypeID"] + "' value=" + Data[i]["TCredTypeID"] + ">" + "����ΪĬ��" + "</li>");
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
            if ($(this).text() == "Ĭ��") {
                $(this).text("����ΪĬ��").removeClass("default");
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
                $("#i-" + curCid).html("Ĭ��");
                $("#i-" + curCid).addClass("default");
                PageLogicObj.m_DefaultId = curCid;
            } else {
                $(this).removeClass('selected');
                $("#i-" + curCid).html("����ΪĬ��");
                $("#i-" + curCid).removeClass("default");
            }
        } else {
            $(this).removeClass('active');
            $(this).removeClass('selected');
            if ($("#i-" + curCid).text() == "Ĭ��") {
                $("#i-" + curCid).text("����ΪĬ��").removeClass("default");
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
        var Msg = "��ȷ��<span style='color:blue; font-size:16px;'>����ΪĬ��</span>��" + LocName + "��ΪĬ��ô��";
        var action = "edit";
        if (isDefault) {
            Msg = "��ȷ��<span style='color:red; font-size:16px;'>ȡ��</span>��" + LocName + "��Ĭ��ô��";
            action = "cancel";
        }
        $.messager.confirm('��ʾ', Msg, function (r) {
            if (r) {
                if (action == "cancel") {
                    inLoc = "";
                }
                if (action == "cancel") {
                    $("#in-" + cid).removeClass('selected');
                    $("#i-" + cid).text("����ΪĬ��");
                    $("#i-" + cid).removeClass("default");
                    PageLogicObj.m_DefaultId = "";
                } else {
                    if (PageLogicObj.m_DefaultId != "") {
                        $("#in-" + PageLogicObj.m_DefaultId).removeClass("selected");
                        $("#i-" + PageLogicObj.m_DefaultId).removeClass("default");
                        $("#i-" + PageLogicObj.m_DefaultId).text("����ΪĬ��");
                    }
                    $("#in-" + cid).addClass("selected");
                    $("#in-" + cid).addClass("active");
                    $("#i-" + cid).addClass("default");
                    $("#i-" + cid).text("Ĭ��");
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
            data: [{id:"P",text:"����������"},{id:"C",text:"������"}],
            onSelect: function (rec) {
                //PatTypeOnChange();
            }
        })
	}