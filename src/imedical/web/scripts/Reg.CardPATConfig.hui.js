var PageLogicObj = {
    m_RowId: "",
    m_CardRegDOMArr: new Array(),
    //建卡页面必填信息元素 必须要勾选的元素列表
    m_CardRegMustFillInArr: ["姓名", "性别", "出生日期", "年龄", "患者类型", "联系电话"]
}
$(function () {
    //初始化
    Init();
    //事件初始化
    InitEvent()

})
function Init() {
    //初始化医院
    var hospComp = GenHospComp("DHC_CardPATRegConfig");
    hospComp.jdata.options.onSelect = function (e, t) {
        var HospID = t.HOSPRowId;
        $(".hisui-combobox").combobox('setValue', "");
        $(".textbox").val("");
        $(".hisui-lookup").lookup('setText', "");
        DataListLoad();
    }
    hospComp.jdata.options.onLoadSuccess = function (data) {
        //初始化界面上ComboBox
        InitComboBox();
        InitLookup();
        InitDataGrid();
        //初始化卡号检索方式
        InitSearchCardNoMode();
        //初始化联系人信息必填(年龄)
        InitForeignInfoByAge()
        //注册配置加载数据
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
            { Value: "13", Desc: "13岁以下" },
            { Value: "14", Desc: "14岁以下" },
            { Value: "15", Desc: "15岁以下" },
            { Value: "16", Desc: "16岁以下" },
            { Value: "17", Desc: "17岁以下" },
            { Value: "18", Desc: "18岁以下" }
        ]
    })
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
        $.messager.popover({ msg: '保存成功!', type: 'success', timeout: 1000 });
    })
}
function InitDataGrid() {
    var toolbar = [{
        text: '新增',
        iconCls: 'icon-add',
        handler: function () { AddClick(); }
    }, {
        text: '修改',
        iconCls: 'icon-write-order',
        handler: function () { UpdateClick(); }
    }
    ]
    var Columns = [[
        { field: 'ID', title: '', width: 1, hidden: true },
        { field: 'Hosp', title: '医院', width: 120 },
        {
            field: 'SearchMasFlag', title: '读卡是否读取PA_PatMas信息', width: 120,
            formatter: function (value, row, index) {
                if (value == "Y") {
                    return "<span class='c-ok'>是</span>"
                } else {
                    return "<span class='c-no'>否</span>"
                }
            }
        },
        { field: 'SetFocusElement', title: '自动聚焦功能', width: 70 },
        {
            field: 'PatMasFlag', title: '写入患者基本信息标志', width: 150,
            formatter: function (value, row, index) {
                if (value == "Y") {
                    return "<span class='c-ok'>是</span>"
                } else {
                    return "<span class='c-no'>否</span>"
                }
            }
        },
        {
            field: 'CardRefFlag', title: '写入卡信息标志', width: 70,
            formatter: function (value, row, index) {
                if (value == "Y") {
                    return "<span class='c-ok'>是</span>"
                } else {
                    return "<span class='c-no'>否</span>"
                }
            }
        },
        {
            field: 'AccManageFlag', title: '写入患者账户信息标志', width: 100,
            formatter: function (value, row, index) {
                if (value == "Y") {
                    return "<span class='c-ok'>是</span>"
                } else {
                    return "<span class='c-no'>否</span>"
                }
            }
        },
        { field: 'ParseTag', title: '分析信息维护界面与 Cache解耦合标志', width: 70 },
        { field: 'DefualtCoury', title: '国家', width: 100 },
        { field: 'DefualtCouryDR', title: '国家', hidden: true },
        { field: 'DefualtNation', title: '民族', width: 70 },
        { field: 'DefualtNationDR', title: '民族', hidden: true },
        { field: 'DefualtProvince', title: '省份', width: 100 },
        { field: 'DefualtProvinceDR', title: '', hidden: true },
        { field: 'DefualtCity', title: '城市', width: 100 },
        { field: 'DefualtCityDR', title: '', hidden: true },
        {
            field: 'CPRIsNotStructAddressFLag', title: '是否结构化地址', width: 100,
            formatter: function (value, row, index) {
                if (value == "Y") {
                    return "<span class='c-ok'>是</span>"
                } else {
                    return "<span class='c-no'>否</span>"
                }
            }
        },
        { field: 'CPRCardRegMustFillIn', title: '建卡页面必填信息元素', width: 120, hidden: true },
        { field: 'CPRCardRegJumpSeq', title: '建卡页面元素跳转顺序', width: 120, hidden: true }
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
    ///初始化 读卡是否读取PA_PatMas信息
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
    ///初始化 写入患者基本信息标志 
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
    ///初始化 写入卡信息标志 
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
    ///初始化 写入患者账户信息标志 
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
    ///初始化 是否结构化地址
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
    ///初始化医院
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
    ///初始化建卡页面必填信息元素
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
            rowStyle: 'checkbox', //显示成勾选行形式
            valueField: 'id',
            textField: 'text',
            data: PageLogicObj.m_CardRegDOMArr
        });
        var dataGrid = $("#CardRegDOMTab").datagrid({
            title: '建卡页面元素跳转顺序',
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
                { field: 'id', title: 'DOM元素ID', width: 100, hidden: true },
                { field: 'text', title: 'DOM元素名称', width: 180 },
            ]],
            data: { "total": PageLogicObj.m_CardRegDOMArr.length, "rows": PageLogicObj.m_CardRegDOMArr }
        });
        return dataGrid;
    });
}
function InitLookup() {
    //初始化 国家
    $("#Country").lookup({
        url: $URL,
        mode: 'remote',
        method: "Get",
        idField: 'ID',
        textField: 'Description',
        columns: [[
            { field: 'Description', title: '国家', width: 150 },
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
    //初始化 省份
    $("#Province").lookup({
        url: $URL,
        mode: 'remote',
        method: "Get",
        idField: 'HIDDEN',
        textField: 'Description',
        columns: [[
            { field: 'Description', title: '省份', width: 150 },
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
    //初始化 城市
    $("#City").lookup({
        url: $URL,
        mode: 'remote',
        method: "Get",
        idField: 'HIDDEN',
        textField: 'Description',
        columns: [[
            { field: 'Description', title: '城市', width: 150 },
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
    //初始化 民族
    $("#Nation").lookup({
        url: $URL,
        mode: 'remote',
        method: "Get",
        idField: 'HIDDEN',
        textField: 'Description',
        columns: [[
            { field: 'Description', title: '民族', width: 150 },
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
                $.messager.popover({ msg: '新增成功！', type: 'success', timeout: 1000 });
            } else {
                $.messager.popover({ msg: '更新成功！', type: 'success', timeout: 1000 });
                PageLogicObj.m_RowId = "";
            }
            DataListLoad()
            clear()
        } else if (txtData == "Repeat") {
            $.messager.alert("提示", "记录重复!一家医院只能维护一条数据!");
        }
    });
}
function CheckData() {
    var Hosp = $HUI.combogrid('#_HospList').getValue(); //getValue("Hosp");
    if (Hosp == "") {
        $.messager.alert("提示", "医院不能为空!", 'info');
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
        $.messager.alert("提示", "建卡页面必填信息元素的 " + CardRegMustFillInMsg + "是必须要勾选的元素!", 'info');
        return false;
    }
    /*if ((CardRegMustFillIn=="")||(!isContained(CardRegMustFillIn.split(","),PageLogicObj.m_CardRegMustFillInArr))){
        $.messager.alert("提示", PageLogicObj.m_CardRegMustFillInArr+ "是必须要勾选的元素!", 'info');
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
        $.messager.alert("提示", "省份或城市不为空时,需选择国家!", 'info', function () {
            $("#Country").focus();
        });
        return false
    }
    if ((ProvinceId == "") && (CityId != "")) {
        $.messager.alert("提示", "城市不为空时,需选择省份!", 'info', function () {
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
        $.messager.alert("提示", "读卡是否读取PA_PatMas信息不能为空", 'info');
        return false
    }
    var PatMasFlag = getValue("PatMasFlag")
    if (PatMasFlag == "") {
        $.messager.alert("提示", "写入患者基本信息标志不能为空", 'info');
        return false
    }
    var CardRefFlag = getValue("CardRefFlag")
    if (CardRefFlag == "") {
        $.messager.alert("提示", "写入卡信息标志不能为空", 'info');
        return false
    }

    return true
}
function AddClick() {
    SaveData("")
}
function UpdateClick() {
    if (PageLogicObj.m_RowId == "") {
        $.messager.alert("提示", "请选择配置数据", 'info');
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

///根据元素的classname获取元素值
function getValue(id) {
    var className = $("#" + id).attr("class")
    if (typeof className == "undefined") {
        return $("#" + id).val()
    }
    if (className.indexOf("hisui-lookup") >= 0) {
        var txt = $("#" + id).lookup("getText")
        //如果放大镜文本框的值为空,则返回空值
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
///给元素赋值
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
///卡类型编辑窗口清屏
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

//界面元素和表里字段对照 
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
        $.messager.alert("提示", "请选择需要移动的行!");
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
//是否被包含,是返回true,不是返回false
function isContained(a, b) {
    if (!(a instanceof Array) || !(b instanceof Array)) return false;
    if (a.length < b.length) return false;
    var aStr = a.toString();
    for (var i = 0, len = b.length; i < len; i++) {
        if (aStr.indexOf(b[i]) == -1) return false;
    }
    return true;
}
