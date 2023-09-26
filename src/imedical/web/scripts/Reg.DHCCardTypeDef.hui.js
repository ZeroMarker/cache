var PageLogicObj = {
    CardTypeId: ""
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
    }
    hospComp.jdata.options.onLoadSuccess = function (data) {
        //�����ͱ���ʼ��
        CardTypeListDataGridLoad()
    }
})
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
        },
        onDblClickRow: function (index, row) {
            var CardTypeId = row["RowId"];
            PageLogicObj.CardTypeId = CardTypeId
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
    $.cm({
        ClassName: "web.DHCBL.UDHCCommFunLibary",
        QueryName: "ReadComponentItem",
        ComponentName: "UDHCCardPatInfoRegExp",
        DisType: "",
        HiddenFlag: 0,
        rows: 99999
    }, function (GridData) {
        var cbox = $HUI.combobox("#" + jsonObj.id, {
            valueField: 'Name',
            textField: 'Caption',
            editable: true,
            data: GridData["rows"]
        });
    });
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
        return $("#" + id).combobox("getValue")
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
        $("#" + id).combobox("setValue", val)
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
