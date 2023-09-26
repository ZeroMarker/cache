var PageLogicObj = {
    m_RowId: "",
    m_CardRegDOMArr: new Array(),
    //����ҳ�������ϢԪ�� ����Ҫ��ѡ��Ԫ���б�
    m_CardRegMustFillInArr: ["����", "�Ա�", "��������", "����", "��������", "��ϵ�绰"]
}
$(function () {
    //��ʼ��
    Init();
    //�¼���ʼ��
    InitEvent()

})
function Init() {
    //��ʼ��ҽԺ
    var hospComp = GenHospComp("DHC_CardPATRegConfig");
    hospComp.jdata.options.onSelect = function (e, t) {
        var HospID = t.HOSPRowId;
        $(".hisui-combobox").combobox('setValue', "");
        $(".textbox").val("");
        $(".hisui-lookup").lookup('setText', "");
        DataListLoad();
    }
    hospComp.jdata.options.onLoadSuccess = function (data) {
        //��ʼ��������ComboBox
        InitComboBox();
        InitLookup();
        InitDataGrid();
        //��ʼ�����ż�����ʽ
        InitSearchCardNoMode();
        //��ʼ����ϵ����Ϣ����(����)
        InitForeignInfoByAge()
        //ע�����ü�������
        DataListLoad();
    }
}
function InitEvent() {
    $("#GlobalSet").click(GlobalSetHandle)
    $("#SetSave").click(SetSaveHandle)
}
function GlobalSetHandle() {
    $('#CardGlobalSet').dialog("open")
    $('#CardGlobalSet').dialog("center")
    $m({
        ClassName: "web.DHCBL.CARD.CardTypeDef",
        MethodName: "GetCardTypeSet",
        HospId: $HUI.combogrid('#_HospList').getValue()
    }, function (txtData) {
        var txtDataArr = txtData.split("^")
        $("#SearchCardNoMode").combobox("setValue", txtDataArr[0])
        $("#AllowAgeNoCreadCard").val(txtDataArr[1])
        var CanNoCread = txtDataArr[2]
        var BuildAddrHomeByIDCard = txtDataArr[4]
        var BuildAddrBirthByIDCard = txtDataArr[5]
        var BuildAddrLookUpByIDCard = txtDataArr[6]
        var BuildAddrHouseByIDCard = txtDataArr[7]
        if (CanNoCread == "Y") {
            $("#CanNoCread").switchbox("setValue", true)
        } else {
            $("#CanNoCread").switchbox("setValue", false)
        }
        $("#ForeignInfoByAge").combobox("setValue", txtDataArr[3])
        BuildAddrHomeByIDCard = (BuildAddrHomeByIDCard == "Y") ? true : false
        BuildAddrBirthByIDCard = (BuildAddrBirthByIDCard == "Y") ? true : false
        BuildAddrLookUpByIDCard = (BuildAddrLookUpByIDCard == "Y") ? true : false
        BuildAddrHouseByIDCard = (BuildAddrHouseByIDCard == "Y") ? true : false
        $("#BuildAddrHomeByIDCard").switchbox("setValue", BuildAddrHomeByIDCard)
        $("#BuildAddrBirthByIDCard").switchbox("setValue", BuildAddrBirthByIDCard)
        $("#BuildAddrLookUpByIDCard").switchbox("setValue", BuildAddrLookUpByIDCard)
        $("#BuildAddrHouseByIDCard").switchbox("setValue", BuildAddrHouseByIDCard)
    }
    )

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
function SetSaveHandle() {
    var SearchCardNoMode = $("#SearchCardNoMode").combobox("getValue")
    var AllowAgeNoCreadCard = $("#AllowAgeNoCreadCard").val()
    var CanNoCread = $("#CanNoCread").switchbox("getValue")
    var ForeignInfoByAge = $("#ForeignInfoByAge").combobox("getValue")
    var BuildAddrHomeByIDCard = $("#BuildAddrHomeByIDCard").switchbox("getValue")
    var BuildAddrBirthByIDCard = $("#BuildAddrBirthByIDCard").switchbox("getValue")
    var BuildAddrLookUpByIDCard = $("#BuildAddrLookUpByIDCard").switchbox("getValue")
    var BuildAddrHouseByIDCard = $("#BuildAddrHouseByIDCard").switchbox("getValue")
    if (!ForeignInfoByAge) ForeignInfoByAge = ""
    CanNoCread = (CanNoCread ? 'Y' : 'N')
    BuildAddrHomeByIDCard = BuildAddrHomeByIDCard ? "Y" : "N";
    BuildAddrBirthByIDCard = BuildAddrBirthByIDCard ? "Y" : "N";
    BuildAddrLookUpByIDCard = BuildAddrLookUpByIDCard ? "Y" : "N";
    BuildAddrHouseByIDCard = BuildAddrHouseByIDCard ? "Y" : "N";
    $m({
        ClassName: "web.DHCBL.CARD.CardTypeDef",
        MethodName: "SaveCardTypeSet",
        SetStr: SearchCardNoMode + "^" + AllowAgeNoCreadCard + "^" + CanNoCread + "^" + ForeignInfoByAge + "^" + BuildAddrHomeByIDCard + "^" + BuildAddrBirthByIDCard + "^" + BuildAddrLookUpByIDCard + "^" + BuildAddrHouseByIDCard,
        HospId: $HUI.combogrid('#_HospList').getValue()
    }, function (txtData) {
        $.messager.popover({ msg: '����ɹ�!', type: 'success', timeout: 1000 });
    })
}
function InitDataGrid() {
    var toolbar = [{
        text: '����',
        iconCls: 'icon-add',
        handler: function () { AddClick(); }
    }, {
        text: '�޸�',
        iconCls: 'icon-write-order',
        handler: function () { UpdateClick(); }
    }
    ]
    var Columns = [[
        { field: 'ID', title: '', width: 1, hidden: true },
        { field: 'Hosp', title: 'ҽԺ', width: 120 },
        {
            field: 'SearchMasFlag', title: '�����Ƿ��ȡPA_PatMas��Ϣ', width: 120,
            formatter: function (value, row, index) {
                if (value == "Y") {
                    return "<span class='c-ok'>��</span>"
                } else {
                    return "<span class='c-no'>��</span>"
                }
            }
        },
        { field: 'SetFocusElement', title: '�Զ��۽�����', width: 70 },
        {
            field: 'PatMasFlag', title: 'д�뻼�߻�����Ϣ��־', width: 150,
            formatter: function (value, row, index) {
                if (value == "Y") {
                    return "<span class='c-ok'>��</span>"
                } else {
                    return "<span class='c-no'>��</span>"
                }
            }
        },
        {
            field: 'CardRefFlag', title: 'д�뿨��Ϣ��־', width: 70,
            formatter: function (value, row, index) {
                if (value == "Y") {
                    return "<span class='c-ok'>��</span>"
                } else {
                    return "<span class='c-no'>��</span>"
                }
            }
        },
        {
            field: 'AccManageFlag', title: 'д�뻼���˻���Ϣ��־', width: 100,
            formatter: function (value, row, index) {
                if (value == "Y") {
                    return "<span class='c-ok'>��</span>"
                } else {
                    return "<span class='c-no'>��</span>"
                }
            }
        },
        { field: 'ParseTag', title: '������Ϣά�������� Cache����ϱ�־', width: 70 },
        { field: 'DefualtCoury', title: '����', width: 100 },
        { field: 'DefualtCouryDR', title: '����', hidden: true },
        { field: 'DefualtNation', title: '����', width: 70 },
        { field: 'DefualtNationDR', title: '����', hidden: true },
        { field: 'DefualtProvince', title: 'ʡ��', width: 100 },
        { field: 'DefualtProvinceDR', title: '', hidden: true },
        { field: 'DefualtCity', title: '����', width: 100 },
        { field: 'DefualtCityDR', title: '', hidden: true },
        {
            field: 'CPRIsNotStructAddressFLag', title: '�Ƿ�ṹ����ַ', width: 100,
            formatter: function (value, row, index) {
                if (value == "Y") {
                    return "<span class='c-ok'>��</span>"
                } else {
                    return "<span class='c-no'>��</span>"
                }
            }
        },
        { field: 'CPRCardRegMustFillIn', title: '����ҳ�������ϢԪ��', width: 120, hidden: true },
        { field: 'CPRCardRegJumpSeq', title: '����ҳ��Ԫ����ת˳��', width: 120, hidden: true }
    ]];
    var dataGrid = $("#CardPATConfigList").datagrid({
        fit: true,
        border: false,
        striped: true,
        singleSelect: true,
        fitColumns: false,
        autoRowHeight: false,
        pagination: true,
        pageSize: 20,
        idField: 'RowID',
        columns: Columns,
        toolbar: toolbar,
        onSelect: function (index, rowData) {
            PageLogicObj.m_RowId = rowData["ID"]
            DataGridSelect(rowData["ID"])
        }
    });
    dataGrid.datagrid('loadData', { 'total': '0', "rows": [] });
    return dataGrid;
}
function DataListLoad() {
    $.cm({
        ClassName: "web.DHCBL.CARD.CardPATRegConfig",
        QueryName: "CardPatRegConfigQueryT",
        HospId: $HUI.combogrid('#_HospList').getValue(),
        rows: 99999
    }, function (GridData) {
        $("#CardPATConfigList").datagrid({ loadFilter: DocToolsHUI.lib.pagerFilter }).datagrid('loadData', GridData);
        $("#CardPATConfigList").datagrid("clearSelections")
    });
}
function InitComboBox() {
    ///��ʼ�� �����Ƿ��ȡPA_PatMas��Ϣ
    $.cm({
        ClassName: "web.DHCBL.UDHCCommFunLibary",
        QueryName: "InitListObjectValueNew",
        ClassName1: "User.DHCCardPATRegConfig",
        PropertyName: "CPRSearchMasFlag",
        rows: 99999
    }, function (GridData) {
        var cbox = $HUI.combobox("#SearchMasFlag", {
            valueField: 'ValueList',
            textField: 'DisplayValue',
            editable: true,
            data: GridData["rows"]
        });
    });
    ///��ʼ�� д�뻼�߻�����Ϣ��־ 
    $.cm({
        ClassName: "web.DHCBL.UDHCCommFunLibary",
        QueryName: "InitListObjectValueNew",
        ClassName1: "User.DHCCardPATRegConfig",
        PropertyName: "CPRPatMasFlag",
        rows: 99999
    }, function (GridData) {
        var cbox = $HUI.combobox("#PatMasFlag", {
            valueField: 'ValueList',
            textField: 'DisplayValue',
            editable: true,
            data: GridData["rows"]
        });
    });
    ///��ʼ�� д�뿨��Ϣ��־ 
    $.cm({
        ClassName: "web.DHCBL.UDHCCommFunLibary",
        QueryName: "InitListObjectValueNew",
        ClassName1: "User.DHCCardPATRegConfig",
        PropertyName: "CPRCardRefFlag",
        rows: 99999
    }, function (GridData) {
        var cbox = $HUI.combobox("#CardRefFlag", {
            valueField: 'ValueList',
            textField: 'DisplayValue',
            editable: true,
            data: GridData["rows"]
        });
    });
    ///��ʼ�� д�뻼���˻���Ϣ��־ 
    $.cm({
        ClassName: "web.DHCBL.UDHCCommFunLibary",
        QueryName: "InitListObjectValueNew",
        ClassName1: "User.DHCCardPATRegConfig",
        PropertyName: "CPRAccManageFLag",
        rows: 99999
    }, function (GridData) {
        var cbox = $HUI.combobox("#AccManageFLag", {
            valueField: 'ValueList',
            textField: 'DisplayValue',
            editable: true,
            data: GridData["rows"]
        });
    });
    ///��ʼ�� �Ƿ�ṹ����ַ
    $.cm({
        ClassName: "web.DHCBL.UDHCCommFunLibary",
        QueryName: "InitListObjectValueNew",
        ClassName1: "User.DHCCardPATRegConfig",
        PropertyName: "CPRIsNotStructAddressFLag",
        rows: 99999
    }, function (GridData) {
        var cbox = $HUI.combobox("#IsNotStructAddress", {
            valueField: 'ValueList',
            textField: 'DisplayValue',
            editable: true,
            data: GridData["rows"]
        });
    });
    ///��ʼ��ҽԺ
    /*$.cm({
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
    });*/
    ///��ʼ������ҳ�������ϢԪ��
    var Hosp = $HUI.combogrid('#_HospList').getValue();
    $.cm({
        ClassName: "web.DHCBL.CARD.CardPATRegConfig",
        MethodName: "GetCardRegDOMCache",
        HospId: Hosp //session['LOGON.HOSPID']
    }, function (data) {
        for (var oe in data) {
            var text = data[oe];
            PageLogicObj.m_CardRegDOMArr.push({ "id": oe, "text": text });
        }
        var cbox = $HUI.combobox("#CardRegMustFillIn", {
            editable: false,
            multiple: true,
            rowStyle: 'checkbox', //��ʾ�ɹ�ѡ����ʽ
            valueField: 'id',
            textField: 'text',
            data: PageLogicObj.m_CardRegDOMArr
        });
        var dataGrid = $("#CardRegDOMTab").datagrid({
            title: '����ҳ��Ԫ����ת˳��',
            headerCls: 'panel-header-gray',
            fit: true,
            striped: true,
            singleSelect: true,
            fitColumns: false,
            autoRowHeight: false,
            pagination: false,
            pageSize: 20,
            idField: 'id',
            toolbar: [{
                iconCls: 'icon-arrow-top',
                handler: function () { Move('up') }
            }, {
                iconCls: 'icon-arrow-bottom',
                handler: function () { Move('down') }
            }],
            columns: [[
                { field: 'id', title: 'DOMԪ��ID', width: 100, hidden: true },
                { field: 'text', title: 'DOMԪ������', width: 180 },
            ]],
            data: { "total": PageLogicObj.m_CardRegDOMArr.length, "rows": PageLogicObj.m_CardRegDOMArr }
        });
        return dataGrid;
    });
}
function InitLookup() {
    //��ʼ�� ����
    $("#Country").lookup({
        url: $URL,
        mode: 'remote',
        method: "Get",
        idField: 'ID',
        textField: 'Description',
        columns: [[
            { field: 'Description', title: '����', width: 150 },
            { field: 'ID', title: 'ID', width: 50 }
        ]],
        pagination: true,
        panelWidth: 300,
        panelHeight: 300,
        isCombo: true,
        queryOnSameQueryString: true,
        queryParams: { ClassName: 'web.CTCountryNew', QueryName: 'LookUp' },
        onBeforeLoad: function (param) {
            var desc = param['q'];
            //if (desc=="") return false;
            param = $.extend(param, { desc: desc });
        },
        pagination: true,
        onSelect: function (index, rowData) {
            $("#CountryId").val(rowData["ID"]);
            $("#Province,#City").lookup('setText', '');
            $("#CityId,#ProvinceId").val('');
        }
    });
    //��ʼ�� ʡ��
    $("#Province").lookup({
        url: $URL,
        mode: 'remote',
        method: "Get",
        idField: 'HIDDEN',
        textField: 'Description',
        columns: [[
            { field: 'Description', title: 'ʡ��', width: 150 },
            { field: 'HIDDEN', title: 'ID', width: 50 }
        ]],
        pagination: true,
        panelWidth: 300,
        panelHeight: 300,
        isCombo: true,
        queryOnSameQueryString: true,
        queryParams: { ClassName: 'web.CTProvinceNew', QueryName: 'LookUp' },
        onBeforeLoad: function (param) {
            var desc = param['q'];
            var lookdefaultCountryId = $("#CountryId").val()
            param = $.extend(param, { lookDefaultProvinceDR: desc, defaultCountryDR: lookdefaultCountryId });
        },
        pagination: true,
        onSelect: function (index, rowData) {
            $("#ProvinceId").val(rowData["HIDDEN"]);
            $("#City").lookup('setText', '');
            $("#CityId").val('');
        }
    });
    //��ʼ�� ����
    $("#City").lookup({
        url: $URL,
        mode: 'remote',
        method: "Get",
        idField: 'HIDDEN',
        textField: 'Description',
        columns: [[
            { field: 'Description', title: '����', width: 150 },
            { field: 'HIDDEN', title: 'ID', width: 50 }
        ]],
        pagination: true,
        panelWidth: 300,
        panelHeight: 300,
        isCombo: true,
        queryOnSameQueryString: true,
        queryParams: { ClassName: 'web.CTCity', QueryName: 'LookUpWithProv' },
        onBeforeLoad: function (param) {
            var desc = param['q'];
            //if (desc=="") return false;
            var lookdefaultProvinceId = $("#ProvinceId").val()
            param = $.extend(param, { desc: desc, ProvinceDR: lookdefaultProvinceId });
        },
        pagination: true,
        onSelect: function (index, rowData) {
            $("#CityId").val(rowData["HIDDEN"])
        }
    });
    //��ʼ�� ����
    $("#Nation").lookup({
        url: $URL,
        mode: 'remote',
        method: "Get",
        idField: 'HIDDEN',
        textField: 'Description',
        columns: [[
            { field: 'Description', title: '����', width: 150 },
            { field: 'HIDDEN', title: 'ID', width: 50 }
        ]],
        pagination: true,
        panelWidth: 300,
        panelHeight: 300,
        isCombo: true,
        queryOnSameQueryString: true,
        queryParams: { ClassName: 'web.CTNationNew', QueryName: 'LookUp' },
        onBeforeLoad: function (param) {
            var desc = param['q'];
            param = $.extend(param, { lookDefaultNationDR: desc });
        },
        pagination: true,
        onSelect: function (index, rowData) {
            $("#NationId").val(rowData["HIDDEN"])
        }
    });
}
function SaveData(RowId) {
    if (!CheckData()) return false;
    var dataJson = {}
    $.each(FieldJson, function (name, value) {
        if (name == "CPRCardRegMustFillIn") {
            var MustFillInArr = new Array();
            var vals = $("#" + value).combobox('getValues');
            var texts = $("#" + value).combobox('getText');
            for (var i = 0; i < vals.length; i++) {
                MustFillInArr.push({ "id": vals[i], "text": texts.split(",")[i] });
            }
            var val = JSON.stringify(MustFillInArr);
            val = eval("('" + val + "')");
            dataJson[name] = val;
        } else if (name == "CPRCardRegJumpSeq") {
            var JumpSeqNoArr = new Array();
            var rows = $("#" + value).datagrid('getRows');
            for (var i = 0; i < rows.length; i++) {
                var id = rows[i]['id'];
                var text = rows[i]['text'];
                JumpSeqNoArr.push({ "id": id, "text": text });
            }
            var val = JSON.stringify(JumpSeqNoArr);
            val = eval("('" + val + "')");
            dataJson[name] = val;
        } else {
            var val = getValue(value);
            val = '"' + val + '"';
            eval("dataJson." + name + "=" + val);
        }
    });
    var jsonStr = JSON.stringify(dataJson)
    $m({
        ClassName: "web.DHCBL.CARD.CardPATRegConfig",
        MethodName: "SaveByJson",
        RowId: RowId,
        JsonStr: jsonStr
    }, function (txtData) {
        if (txtData == 0) {
            if (RowId == "") {
                $.messager.popover({ msg: '�����ɹ���', type: 'success', timeout: 1000 });
            } else {
                $.messager.popover({ msg: '���³ɹ���', type: 'success', timeout: 1000 });
                PageLogicObj.m_RowId = "";
            }
            DataListLoad()
            clear()
        } else if (txtData == "Repeat") {
            $.messager.alert("��ʾ", "��¼�ظ�!һ��ҽԺֻ��ά��һ������!");
        }
    });
}
function CheckData() {
    var Hosp = $HUI.combogrid('#_HospList').getValue(); //getValue("Hosp");
    if (Hosp == "") {
        $.messager.alert("��ʾ", "ҽԺ����Ϊ��!", 'info');
        return false
    }
    var CardRegMustFillInMsg = "";
    var CardRegMustFillIn = $("#CardRegMustFillIn").combobox('getText');
    for (var i = 0; i < PageLogicObj.m_CardRegMustFillInArr.length; i++) {
        var name = PageLogicObj.m_CardRegMustFillInArr[i];
        if (("," + CardRegMustFillIn + ",").indexOf(("," + name + ",")) >= 0) {
            flag = false;
        } else {
            if (CardRegMustFillInMsg == "") CardRegMustFillInMsg = name;
            else CardRegMustFillInMsg = CardRegMustFillInMsg + "," + name;
        }
    }
    if (CardRegMustFillInMsg != "") {
        $.messager.alert("��ʾ", "����ҳ�������ϢԪ�ص� " + CardRegMustFillInMsg + "�Ǳ���Ҫ��ѡ��Ԫ��!", 'info');
        return false;
    }
    /*if ((CardRegMustFillIn=="")||(!isContained(CardRegMustFillIn.split(","),PageLogicObj.m_CardRegMustFillInArr))){
        $.messager.alert("��ʾ", PageLogicObj.m_CardRegMustFillInArr+ "�Ǳ���Ҫ��ѡ��Ԫ��!", 'info');
        return false
    }*/
    var Country = $("#Country").lookup("getText")
    if (Country == "") {
        $("#CountryId").val("")
    }
    var Province = $("#Province").lookup("getText")
    if (Province == "") {
        $("#ProvinceId").val("")
    }
    var City = $("#City").lookup("getText")
    if (City == "") {
        $("#CityId").val("")
    }
    var CountryId = $("#CountryId").val();
    var ProvinceId = $("#ProvinceId").val();
    var CityId = $("#CityId").val();
    if ((CountryId == "") && ((ProvinceId != "") || (CityId != ""))) {
        $.messager.alert("��ʾ", "ʡ�ݻ���в�Ϊ��ʱ,��ѡ�����!", 'info', function () {
            $("#Country").focus();
        });
        return false
    }
    if ((ProvinceId == "") && (CityId != "")) {
        $.messager.alert("��ʾ", "���в�Ϊ��ʱ,��ѡ��ʡ��!", 'info', function () {
            $("#Province").focus();
        });
        return false
    }
    var Nation = $("#Nation").lookup("getText")
    if (Nation == "") {
        $("#NationId").val("")
    }
    var SearchMasFlag = getValue("SearchMasFlag")
    if (SearchMasFlag == "") {
        $.messager.alert("��ʾ", "�����Ƿ��ȡPA_PatMas��Ϣ����Ϊ��", 'info');
        return false
    }
    var PatMasFlag = getValue("PatMasFlag")
    if (PatMasFlag == "") {
        $.messager.alert("��ʾ", "д�뻼�߻�����Ϣ��־����Ϊ��", 'info');
        return false
    }
    var CardRefFlag = getValue("CardRefFlag")
    if (CardRefFlag == "") {
        $.messager.alert("��ʾ", "д�뿨��Ϣ��־����Ϊ��", 'info');
        return false
    }

    return true
}
function AddClick() {
    SaveData("")
}
function UpdateClick() {
    if (PageLogicObj.m_RowId == "") {
        $.messager.alert("��ʾ", "��ѡ����������", 'info');
        return
    }
    SaveData(PageLogicObj.m_RowId)
}
function DataGridSelect(RowId) {
    $.cm({
        ClassName: "web.DHCBL.CARD.CardPATRegConfig",
        MethodName: "GetDataJson",
        RowId: RowId,
        jsonFiledStr: JSON.stringify(FieldJson)
    }, function (JsonData) {
        if (JsonData != "") {
            $.each(JsonData, function (name, value) {
                if (name == "CardRegMustFillIn") {
                    $("#CardRegMustFillIn").combobox('loadData', PageLogicObj.m_CardRegDOMArr);
                    if (value != "") {
                        var arr = new Array();
                        value = JSON.parse(value);
                        for (var j = 0; j < value.length; j++) {
                            arr.push(value[j]['id']);
                        }
                        $("#CardRegMustFillIn").combobox('setValues', arr);
                    } else {
                        $("#CardRegMustFillIn").combobox('setValues', []);
                    }
                } else if (name == "CardRegDOMTab") {
                    $("#CardRegDOMTab").datagrid('uncheckAll')
                    $("#CardRegDOMTab").datagrid('loadData', { 'total': PageLogicObj.m_CardRegDOMArr.length, 'rows': PageLogicObj.m_CardRegDOMArr });
                    if (value != "") {
                        var rows = $("#CardRegDOMTab").datagrid('getRows');
                        var newArr = new Array();
                        var value1 = JSON.parse(value);
                        for (var i = value1.length - 1; i >= 0; i--) {
                            var id = value1[i]['id'];
                            var index = $("#CardRegDOMTab").datagrid('getRowIndex', id);
                            if (index < 0) {
                                value1.splice(i, 1);
                                newArr.push(rows[index]);
                            } else {
                                //$("#CardRegDOMTab").datagrid('deleteRow',index);
                            }
                        }
                        value1 = value1.concat(newArr); //$("#CardRegDOMTab").datagrid('getRows')
                        $("#CardRegDOMTab").datagrid('loadData', { 'total': value1.length, 'rows': value1 });
                    }
                } else {
                    setValue(name, value);
                }
            })
        }
    });
}

///����Ԫ�ص�classname��ȡԪ��ֵ
function getValue(id) {
    var className = $("#" + id).attr("class")
    if (typeof className == "undefined") {
        return $("#" + id).val()
    }
    if (className.indexOf("hisui-lookup") >= 0) {
        var txt = $("#" + id).lookup("getText")
        //����Ŵ��ı����ֵΪ��,�򷵻ؿ�ֵ
        if (txt != "") {
            var val = $("#" + id).val()
        } else {
            var val = ""
            $("#" + id + "Id").val("")
        }
        return val
    } else if (className.indexOf("hisui-combobox") >= 0) {
        var val = $("#" + id).combobox("getValue")
        if (typeof val == "undefined") val = ""
        return val
    } else if (className.indexOf("hisui-datebox") >= 0) {
        return $("#" + id).datebox("getValue")
    } else if (className.indexOf("combogrid-f") >= 0) {
        return $("#" + id).combogrid("getValue")
    } else {
        return $("#" + id).val()
    }
    return ""
}
///��Ԫ�ظ�ֵ
function setValue(id, val) {
    var className = $("#" + id).attr("class")
    if (typeof className == "undefined") {
        $("#" + id).val(val)
        return
    }
    if (className.indexOf("hisui-combobox") >= 0) {
        $("#" + id).combobox("setValue", val)
    } else if (className.indexOf("hisui-datebox") >= 0) {
        $("#" + id).datebox("setValue", val)
    } else if (className.indexOf("hisui-combogrid") >= 0) {
        $("#" + id).combogrid("setValue", val)
    } else {
        $("#" + id).val(val)
    }
    return ""
}
///�����ͱ༭��������
function clear() {
    $.each(FieldJson, function (name, value) {
        if (value == "CardRegMustFillIn") {
            $("#" + value).combobox('setValues', []);
        } else if (value == "CardRegDOMTab") {
            $("#" + value).datagrid('uncheckAll').datagrid('loadData', { 'total': PageLogicObj.m_CardRegDOMArr.length, 'rows': PageLogicObj.m_CardRegDOMArr });
        } else {
            setValue(value, "");
        }
    })
}

//����Ԫ�غͱ����ֶζ��� 
var FieldJson = {
    CPRSearchMasFlag: "SearchMasFlag",
    CPRSetFocusElement: "SetFocusElement",
    CPRPatMasFlag: "PatMasFlag",
    CPRCardRefFlag: "CardRefFlag",
    CPRAccManageFLag: "AccManageFLag",
    CPRParseTag: "ParseTag",
    CPRIsNotStructAddressFLag: "IsNotStructAddress",
    CPRDefaultCountryDR: "CountryId",
    CPRDefaultNationDR: "NationId",
    CPRDefaultProvinceDR: "ProvinceId",
    CPRDefaultCityDR: "CityId",
    CPRDefaultCountryDRDesc: "Country",
    CPRDefaultNationDRDesc: "Nation",
    CPRDefaultProvinceDRDesc: "Province",
    CPRDefaultCityDRDesc: "City",
    CPRHospDR: "_HospList",
    CPRCardRegMustFillIn: "CardRegMustFillIn",
    CPRCardRegJumpSeq: "CardRegDOMTab"
}
function Move(type) {
    var _tab = $('#CardRegDOMTab');
    var row = _tab.datagrid("getSelected");
    if (!row) {
        $.messager.alert("��ʾ", "��ѡ����Ҫ�ƶ�����!");
        return false;
    }
    var index = _tab.datagrid("getRowIndex", row);
    var rows = _tab.datagrid("getRows");
    if (type == "up") {
        if (index != 0) {
            var toup = _tab.datagrid('getData').rows[index];
            var todown = _tab.datagrid('getData').rows[index - 1];
            _tab.datagrid('getData').rows[index] = todown;
            _tab.datagrid('getData').rows[index - 1] = toup;
            _tab.datagrid('refreshRow', index);
            _tab.datagrid('refreshRow', index - 1);
            _tab.datagrid('selectRow', index - 1);
        }
    } else {
        if (index != (rows - 1)) {
            var todown = _tab.datagrid('getData').rows[index];
            var toup = _tab.datagrid('getData').rows[index + 1];
            _tab.datagrid('getData').rows[index + 1] = todown;
            _tab.datagrid('getData').rows[index] = toup;
            _tab.datagrid('refreshRow', index);
            _tab.datagrid('refreshRow', index + 1);
            _tab.datagrid('selectRow', index + 1);
        }
    }
}
//�Ƿ񱻰���,�Ƿ���true,���Ƿ���false
function isContained(a, b) {
    if (!(a instanceof Array) || !(b instanceof Array)) return false;
    if (a.length < b.length) return false;
    var aStr = a.toString();
    for (var i = 0, len = b.length; i < len; i++) {
        if (aStr.indexOf(b[i]) == -1) return false;
    }
    return true;
}
