/**
 * 团体导入  dhcpe.importginfo.js
 * @Author   wangguoying
 * @DateTime 2020-04-27
 */

var interval_num = 9; //进度条刷新频率 每interval_num条记录刷新一次
var aCity = {
    11: "北京",
    12: "天津",
    13: "河北",
    14: "山西",
    15: "内蒙古",
    21: "辽宁",
    22: "吉林",
    23: "黑龙江",
    31: "上海",
    32: "江苏",
    33: "浙江",
    34: "安徽",
    35: "福建",
    36: "江西",
    37: "山东",
    41: "河南",
    42: "湖北",
    43: "湖南",
    44: "广东",
    45: "广西",
    46: "海南",
    50: "重庆",
    51: "四川",
    52: "贵州",
    53: "云南",
    54: "西藏",
    61: "陕西",
    62: "甘肃",
    63: "青海",
    64: "宁夏",
    65: "新疆",
    71: "台湾",
    81: "香港",
    82: "澳门",
    91: "国外"
}
var editRows = new Array(); //编辑的行索引记录
/**定义数组删除函数**/
Array.prototype.remove = function(val) {
    var index = this.indexOf(val);
    if (index > -1) {
        this.splice(index, 1);
    }
};

$(init);
function init(){
    $(".datagrid-wrap.panel-body.panel-body-noheader.panel-header-gray").css("border-radius","0 0 4px 4px");
    $(".datagrid-wrap.panel-body.panel-body-noheader.panel-header-gray").css("border-top","0");
}

var actionListObj = $HUI.datagrid("#actionList", {

    onSelect: function(rowIndex, rowData) {
        if (rowIndex > -1) {
            var p = actionListObj.getPanel();
            p.find("#editIcon").linkbutton("enable", false);
            p.find("#delIcon").linkbutton("enable", false);
        }
    },
    frozenColumns: [
        [{
            field: 'TOperate',
            title: '操作',
            width: 50,
            align: "center",
            formatter: function(value, row, index) {
                return "<span style='cursor:pointer;padding-left:5px;' class='icon-write-order' title='修改记录' alt='修改记录' onclick='edit_row(\""+index+"\",this)'>&nbsp;&nbsp;</span>\
                <span style='cursor:pointer;padding-left:0px;' class='icon-cancel' title='删除记录' alt='删除记录' onclick='delete_row(\""+index+"\",\"\")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>"
                
            }
        }, {
            field: 'TStatus',
            title: '状态',
            width: 60,
            sortable: 'true',
            align: "center",
            formatter: function(value, row, index) {
                var content = "";
                switch (row.TStatus) {
                    case 0:
                        content = "未验证";
                        break;
                    case 1:
                        content = "验证通过";
                        break;
                    case 2:
                        content = "导入成功";
                        break;
                    case -1:
                        content = "验证失败";
                        break;
                    case -2:
                        content = "导入失败";
                        break;
                }
                return "<div style='color:#ffffff;'>" + content + "</div>";
            },
            styler: function(value, row, index) {
                var color = "#ffffff";
                switch (row.TStatus) {
                    case 0:
                        color = "#40A2DE";
                        break;
                    case 1:
                        color = "#40A2DE";
                        break;
                    case 2:
                        color= "rgb(101, 222, 101)";
                        break;
                    case -1:
                        color = "red";
                        break;
                    case -2:
                        color = "red";
                        break;
                }
                return "background-color:" + color + ";";
            },
        }, {
            field: 'TTeam',
            width: 80,
            title: '分组名称',
            editor: 'text'
        }, {
            field: 'TRegNo',
            width: 100,
            title: '登记号',
            editor: 'text'
        }, {
            field: 'TName',
            width: 100,
            title: '姓名',
            editor: 'text'
        }, {
            field: 'TIDCard',
            width: 180,
            title: '身份证号',
            editor: 'text'
        }, {
            field: 'TTipMsg',
            title: '行提示信息',
            hidden: 'true'
        }]
    ],
    columns: [
        [{
            field: 'TSex',
            width: 40,
            align: "center",
            title: '性别',
            editor: 'text'
        }, {
            field: 'TAge',
            width: 40,
            title: '年龄',
            editor: {
                type: 'numberbox',
                options: {
                    min: 1
                }
            }
        }, {
            field: 'TDob',
            width: 80,
            title: '出生日期',
            editor: 'text'
        }, {
            field: 'TMarital',
            width: 60,
            title: '婚姻状况',
            editor: 'text'
        }, {
            field: 'TTel',
            width: 100,
            title: '移动电话',
            editor: 'text'
        }, {
            field: 'TTel1',
            width: 100,
            title: '联系电话',
            editor: 'text'
        }, {
            field: 'TDepartment',
            width: 80,
            title: '部门',
            editor: 'text'
        }, {
            field: 'TBeginDate',
            width: 80,
            title: '开始日期',
            editor: 'text'
        }, {
            field: 'TEndDate',
            width: 80,
            title: '结束日期',
            editor: 'text'
        }, {
            field: 'TAsCharged',
            width: 60,
            title: '视同收费',
            editor: 'text'
        }, {
            field: 'TRecReport',
            width: 60,
            title: '个人报告领取',
            editor: 'text'
        }, {
            field: 'TCashierType',
            width: 60,
            title: '结算方式',
            editor: 'text'
        }, {
            field: 'TGAdd',
            width: 60,
            title: '公费加项',
            editor: 'text'
        }, {
            field: 'TAddLimit',
            width: 60,
            title: '加项金额限制',
            editor: 'text'
        }, {
            field: 'TAddAmt',
            width: 60,
            title: '加项金额',
            editor: 'text'
        }, {
            field: 'TGMedical',
            width: 60,
            title: '允许开药',
            editor: 'text'
        }, {
            field: 'TMedicalLimit',
            hidden: true,
            title: '加药金额限制',
            editor: 'text'
        }, {
            field: 'TMedicalAmt',
            hidden: true,
            title: '加药金额',
            editor: 'text'
        }, {
            field: 'TCompany',
            width: 80,
            title: '工作单位',
            editor: 'text'
        }, {
            field: 'TNation',
            width: 60,
            title: '民族',
            editor: 'text'
        }, {
            field: 'TNewCard',
            width: 60,
            title: '新发卡',
            editor: 'text'
        }, {
            field: 'TAddress',
            width: 120,
            title: '联系地址',
            editor: 'text'
        }, {
            field: 'TPatType',
            width: 60,
            title: '病人类型',
            editor: 'text'
        }, {
            field: 'THealthArea',
            width: 100,
            title: '健康区域',
            editor: 'text'
        }, {
            field: 'TCardNo',
            width: 100,
            title: '就诊卡号',
            editor: 'text'
        }, {
            field: 'TVIPLevel',
            width: 60,
            title: 'VIP等级',
            editor: 'text'
        }, {
            field: 'TEmployeeNo',
            width: 80,
            title: '工号',
            editor: 'text'
        }, {
            field: 'TFileNo',
            width: 80,
            title: '档案号',
            editor: 'text'
        }, {
            field: 'TPost',
            width: 80,
            title: '职务',
            editor: 'text'
        }, {
            field: 'TProduct',
            width: 80,
            title: '工种',
            editor: 'text'
        }, {
            field: 'TServLength',
            width: 80,
            title: '接害工龄',
            editor: 'text'
        }]
    ],
    data: {
        "total": 0,
        "rows": []
    },
    fit: true,
    rownumbers: true,
    fitColumns: true,
    onSortColumn: function(sort, order) {
        sortTStatus(order);
    },
    rowTooltip: function(index, row) { //datagrid拓展属性  返回行提示信息
        return row.TTipMsg;
    },
    rowStyler: function(index, row) {
        var rowStyle = "";
        switch (row.TStatus) {
            case 0: //未验证
                break;
            case 1: //验证通过
                break;
            case 2: //导入成功
                rowStyle = 'background-color:#65de65;';
                break;
            case -1: //验证未通过
                rowStyle = 'background-color:rgb(251, 136, 226);';
                break;
            case -2: //导入未通过
                break;
        }
        return rowStyle;
    },
    toolbar: [{
        iconCls: 'icon-add',
        text: '新增行',
        handler: function() {
            add_row();
        }
    }, {
        iconCls: 'icon-cancel',
        text: '删除【验证失败】记录',
        handler: function() {
            delete_row("", -1);
        }
    }, {
        iconCls: 'icon-cancel',
        text: '删除【导入成功】记录',
        handler: function() {
            delete_row("", 2);
        }
    }, {
        iconCls: 'icon-reset',
        text: '清空数据',
        handler: function() {
            delete_row("", 9);
        }
    }, {
        iconCls: 'icon-reload',
        text: '刷新数据',
        handler: function() {
            refresh_datagrid();
        }
    }, {
        iconCls: 'icon-export',
        text: '导出错误数据',
        handler: function() {
            export_errData();
        }
    }, {
        iconCls: 'icon-key-switch',
        text: '置验证成功',
        handler: function() {
            update_status(1);
        }
    }]
});

/**
 * [更新行状态]
 * @param   {[int]}   status [状态代码]
 * @Author   wangguoying
 * @DateTime 2020-12-02
 */
function update_status(status) {
    var selectObj = $("#actionList").datagrid("getSelected");
    var selectIndex = $("#actionList").datagrid("getRowIndex", selectObj);
    if (selectObj == null) {
        $.messager.alert("提示", "请选择需修改的行记录", "info");
        return false;
    }
    selectObj.TStatus = status;
    $('#actionList').datagrid('updateRow', {
        index: selectIndex,
        row: selectObj
    });
}


/**
 * [导出错误数据]
 * @Author   wangguoying
 * @DateTime 2020-11-12
 */
function export_errData() {
    var exportData = [];
    var title = ["错误信息", "分组名", "登记号", "姓名", "身份证号", "性别", "年龄", "出生日期", "婚姻状况", "移动电话", "联系电话", "部门", "开始日期", "结束日期", "视同收费", "个人报告领取", "结算方式", "公费加项", "加项金额限制", "加项金额"];
    exportData.push(title);
    var data = actionListObj.getRows();
    var len = data.length;
    for (var i = 0; i < len; i++) {
        if (data[i].TStatus < 0) {
            var row = [];
            row.push(data[i].TTipMsg);
            row.push(data[i].TTeam);
            row.push(data[i].TRegNo);
            row.push(data[i].TName);
            row.push(data[i].TIDCard);
            row.push(data[i].TSex);
            row.push(data[i].TAge);
            row.push(data[i].TDob);
            row.push(data[i].TMarital);
            row.push(data[i].TTel);
            row.push(data[i].TTel1);
            row.push(data[i].TDepartment);
            row.push(data[i].TBeginDate);
            row.push(data[i].TEndDate);
            row.push(data[i].TAsCharged);
            row.push(data[i].TRecReport);
            row.push(data[i].TCashierType);
            row.push(data[i].TGAdd);
            row.push(data[i].TAddLimit);
            row.push(data[i].TAddAmt);
            exportData.push(row);
        }
    }
    var sheet = XLSX.utils.aoa_to_sheet(exportData);
    download_excel(sheet2blob(sheet), $("#GDesc").val() + '_错误数据.xlsx');
}


/**
 * [行操作]
 * @param    {[int]}    index [行索引]
 * @param    {[object]}    t     [按钮对象]
 * @Author   wangguoying
 * @DateTime 2020-05-15
 */
function edit_row(index, t) {
    if (editRows.indexOf(index) > -1) {
        t.alt = "修改记录";
        t.title = "修改记录";
        actionListObj.endEdit(index);
        editRows.remove(index);
        var data = actionListObj.getRows();
        data[index].TStatus = 0;
        data[index].TTipMsg = "";
        actionListObj.loadData(data);
        $("#DisplayMsg").html("编辑 1 记录，当前共 " + data.length + " 记录");
    } else {
        if (editRows.length > 0) {
            $.messager.alert("提示", "存在未保存的数据，请保存后操作", "info");
            return false;
        }
        t.alt = "保存记录";
        t.title = "保存记录";
        actionListObj.beginEdit(index);
        var tr = actionListObj.getRowDom(index);
        tr.tooltip("destroy").children("td[field]").each(function() {
            $(this).tooltip("destroy");
        });
        editRows.push(index);
    }
}



/**
 * [状态列冒泡排序]
 * @param    {[string]}    order [asc:升序  desc:降序]
 * @Author   wangguoying
 * @DateTime 2020-05-11
 */
function sortTStatus(order) {
    var data = actionListObj.getRows();
    for (var i = 0; i < data.length; i++) {
        for (var j = 0; j < data.length - i - 1; j++) {
            var preObj = data[j];
            var sufObj = data[j + 1];
            if ((preObj.TStatus > sufObj.TStatus && order == "asc") || (preObj.TStatus < sufObj.TStatus && order == "desc")) {
                data[j] = sufObj;
                data[j + 1] = preObj;
            }
        }
    }
    actionListObj.loadData(data);
}


/**
 * [加载Excel数据]
 * @Author   wangguoying
 * @DateTime 2020-04-28
 */
function load_excel() {
    var fileList = $("#TemplateFile").filebox("files");
    if (fileList.length == 0) {
        $.messager.alert("提示", "请选择模板！", "info");
        return false;
    }
    $('#Loading').css('display', "block");
    console.log("开始读取 " + new Date());
    getExcelJsonArr(fileList[0], 0, function(excelArr) {
        console.log("读取完成，共" + excelArr.length + "记录 " + new Date());
        fillExcelData(excelArr);
    });
}

/**
 * [填充Excel数据]
 * @param    {JsonArray}    excelArr [Excel数据]
 * @Author   wangguoying
 * @DateTime 2020-04-28
 */
function fillExcelData(excelArr) {
    if (excelArr == "" || excelArr == "undefind" || excelArr.length == 0) {
        $.messager.alert("提示", "未读取到模板数据，请检查！", "info");
        $('#Loading').fadeOut('fast');
        return false;
    }
    console.log("开始填充界面：" + new Date());
    setData(excelArr, 0, actionListObj.getData());
}
/**
 * [追加DataGrid 数据包]
 * @param    {[JSONArray]}    excelArr [Excel数据]
 * @param    {[int]}    i        [description]
 * @param    {[Object]}    OldData  [DataGrid 数据包]
 * @Author   wangguoying
 * @DateTime 2020-04-30
 */
function setData(excelArr, i, OldData) {
    var obj = excelArr[i];
    var jsonObj = new Object();
    jsonObj.TStatus = 0;
    var TeamName = "";
    if (obj.分组名称) TeamName = StringIsNull(obj.分组名称);
    jsonObj.TTeam = TeamName; //TName1
    var RegNo = "";
    if (obj.登记号) RegNo = StringIsNull(obj.登记号);
    jsonObj.TRegNo = RegNo; //RegNo2
    var Name = "";
    if (obj.姓名) Name = StringIsNull(obj.姓名);
    jsonObj.TName = Name; //Name3

    var IDCard = "";
    if (obj.身份证号) IDCard = StringIsNull(obj.身份证号);
    IDCard = ReplaceStr(IDCard, "'", "");
    IDCard = ReplaceStr(IDCard, String.fromCharCode(10), "");
    IDCard = ReplaceStr(IDCard, String.fromCharCode(13), "")

    jsonObj.TIDCard = IDCard; //IDCard4

    if (IDCard != "") {
        var curRegNo = tkMakeServerCall("web.DHCPE.ImportGInfo", "CheckRegNoByCardId", IDCard, "");
        if (jsonObj.TRegNo == "" && curRegNo.length > 1) {
            jsonObj.TRegNo = curRegNo.split("^")[curRegNo.split("^").length - 1];
        }
    }

    var Birth = GetBirthByIDCard(IDCard);
    var Sex = "";
    var Arr = Birth.split("^");
    Birth = Arr[0];
    if (Birth != "") {
        Sex = Arr[1];
    }
    var ExcelDesc = "";
    if (obj.性别) ExcelDesc = StringIsNull(obj.性别);

    if (Sex != "") ExcelDesc = Sex;
    jsonObj.TSex = ExcelDesc; //Sex5

    var Age = "";
    if (obj.年龄) Age = StringIsNull(obj.年龄);
    jsonObj.TAge = Age; //Age6
    var ExcelBirth = "";
    if (Birth != "") {
        ExcelBirth = Birth;
    } else {
        if (obj.生日) ExcelBirth = StringIsNull(obj.生日);
    }

    jsonObj.TDob = ExcelBirth; //Birth7

    var StrValue = "";
    if (obj.婚姻状况) StrValue = StringIsNull(obj.婚姻状况);
    if (StrValue == "") StrValue = "";
    jsonObj.TMarital = StrValue; //Married8
    StrValue = "";
    if (obj.移动电话) StrValue = StringIsNull(obj.移动电话);
    jsonObj.TTel = StrValue; //MoveTel9
    StrValue = "";
    if (obj.联系电话) StrValue = StringIsNull(obj.联系电话);
    jsonObj.TTel1 = StrValue; //Tel10
    StrValue = "";
    if (obj.部门) StrValue = StringIsNull(obj.部门);
    jsonObj.TDepartment = StrValue; //Address11
    StrValue = "";
    if (obj.开始日期) StrValue = StringIsNull(obj.开始日期);
    jsonObj.TBeginDate = StrValue; //StartDate12        
    StrValue = "";
    if (obj.结束日期) StrValue = StringIsNull(obj.结束日期);
    jsonObj.TEndDate = StrValue; //EndDate13
    StrValue = "";
    if (obj.视同收费) StrValue = StringIsNull(obj.视同收费);
    jsonObj.TAsCharged = StrValue; //AsCharged14
    StrValue = "";
    if (obj.个人报告领取) StrValue = StringIsNull(obj.个人报告领取);
    jsonObj.TRecReport = StrValue; //IReportSend15
    StrValue = "";
    if (obj.结算方式) StrValue = StringIsNull(obj.结算方式);
    jsonObj.TCashierType = StrValue; //ChargedMode16
    StrValue = "";
    if (obj.公费加项) StrValue = StringIsNull(obj.公费加项);
    jsonObj.TGAdd = StrValue; //AddItem17
    StrValue = "";
    if (obj.加项金额限制) StrValue = StringIsNull(obj.加项金额限制);
    jsonObj.TAddLimit = StrValue; //AddItemLimit18
    StrValue = "";
    if (obj.加项金额) StrValue = StringIsNull(obj.加项金额);
    jsonObj.TAddAmt = StrValue; //AddItemAmount19
    StrValue = "";
    if (obj.允许开药) StrValue = StringIsNull(obj.允许开药);
    jsonObj.TGMedical = StrValue; //AddMedical20
    StrValue = "";
    // if(obj.加药金额限制) StrValue = StringIsNull(obj.加药金额限制);
    // jsonObj.TMedicalLimit= StrValue;             //AddMedicalLimit21
    // StrValue="";
    // if(obj.加药金额) StrValue = StringIsNull(obj.加药金额);
    // jsonObj.TMedicalAmt= StrValue;           //AddMedicalAmount22
    // StrValue="";
    if (obj.工作单位) StrValue = StringIsNull(obj.工作单位);
    jsonObj.TCompany = StrValue; //工作单位23
    StrValue = "";
    if (obj.民族) StrValue = StringIsNull(obj.民族);
    StrValue = tkMakeServerCall("web.DHCPE.PreCommon", "GetNationDR", StrValue)
    jsonObj.TNation = StrValue; //民族24
    StrValue = "";
    if (obj.新发卡) StrValue = StringIsNull(obj.新发卡);
    jsonObj.TNewCard = StrValue; //新发卡25
    StrValue = "";
    if (obj.联系地址) StrValue = StringIsNull(obj.联系地址);
    jsonObj.TAddress = StrValue; //部联系地址26
    StrValue = "";
    if (obj.病人类型) StrValue = StringIsNull(obj.病人类型);
    jsonObj.TPatType = StrValue; //病人类型27
    StrValue = "";
    if (obj.健康区域) StrValue = StringIsNull(obj.健康区域);
    jsonObj.THealthArea = StrValue; //健康区域28
    StrValue = "";
    if (obj.就诊卡号) StrValue = StringIsNull(obj.就诊卡号);
    jsonObj.TCardNo = StrValue; //就诊卡号29
    StrValue = "";
    if (obj.VIP等级) StrValue = StringIsNull(obj.VIP等级);
    jsonObj.TVIPLevel = StrValue; //VIP等级30
    StrValue = "";
    if (obj.工号) StrValue = StringIsNull(obj.工号);
    jsonObj.TEmployeeNo = StrValue; //工号31
    StrValue = "";
    if (obj.病案号) StrValue = StringIsNull(obj.病案号);
    jsonObj.TFileNo = StrValue; //病案号32
    StrValue = "";
    if (obj.职务) StrValue = StringIsNull(obj.职务);
    jsonObj.TPost = StrValue; //职务33
    StrValue = "";

    if (obj.工种) StrValue = StringIsNull(obj.工种);
    jsonObj.TProduct = StrValue; //工种 34 
    StrValue = "";
    if (obj.接害工龄) StrValue = StringIsNull(obj.接害工龄);
    jsonObj.TServLength = StrValue; //接害工龄35
    OldData.rows.push(jsonObj);

    if (i == (excelArr.length - 1)) {
        actionListObj.loadData(OldData);
        afterFill(excelArr.length);
    } else {
        if (i % interval_num == 0) {
            $("#LoadMsg").html("填充数据：<font color='red'> " + (i + 1) + "</font>/" + excelArr.length);
            // onsole.log($("#LoadMsg").html());
        }
        setTimeout(function() {
            setData(excelArr, i + 1, OldData);
        }, 0);
    }
}


/**
 * [填充数据完成事件]
 * @param    {[int]}    length [读取总记录数]
 * @Author   wangguoying
 * @DateTime 2020-05-08
 */
function afterFill(length) {
    console.log("填充完成：" + new Date());
    $("#TemplateFile").filebox("clear");
    $("#DisplayMsg").html("本次加载<font color='red'> " + length + "</font> 记录，当前共<font color='red'> " + actionListObj.getRows().length + "</font> 记录");
    $('#Loading').fadeOut('fast');
    $("#LoadMsg").html("处理中……");
}



function operate_data(type) {
    var job = session['LOGON.USERID'];
    var jobObj = document.getElementById("Job");
    if (jobObj) job = jobObj.value;
    KillImportGlobal(job);
    var rows = actionListObj.getRows();
    if (rows.length == 0) {
        $.messager.alert("提示", "未加载任何数据", "info");
        return false;
    }
    if (editRows.length > 0) {
        $.messager.alert("提示", "存在未保存的数据，请保存后操作", "info");
        return false;
    }
    $('#Loading').css('display', "block");
    if (type == "Check") {
        valid_rowData(job, rows, 0, 0);
    }
    if (type == "Import") {
        var needNum = getNumByStatus(1);
        import_rowData(job, rows, 0, 0, 0, needNum);

        //团体导入日志
        if(needNum!="0"){
                tkMakeServerCall("web.DHCPE.GAdmRecordManager","Insert",$("#GID").val(),"P","Import","","");
          }


    }
}
/**
 * [按索引验证指定数据]
 * @param    {[int]}    job [进程号]
 * @param    {[array]}    rowData [表格数据包]
 * @param    {[int]}    index   [索引坐标]
 * @param    {[int]}    failNum   [验证失败记录数]
 * @Author   wangguoying
 * @DateTime 2020-05-08
 */
function valid_rowData(job, rowData, index, failNum) {
    var data = rowData[index];
    if (data.TStatus != 2) { //导入成功的不再验证
        var instring = valid_obj(job, data, index);
        if (instring == "") {
            failNum++;
            data.TStatus = -1;
        } else {
            data.TStatus = 1;
        }
    }

    if (index == (rowData.length - 1)) {
        KillImportGlobal(job);
        actionListObj.loadData(rowData);
        afterValid(failNum);
    } else {
        if (index % interval_num == 0) {
            $("#LoadMsg").html("验证数据：<font color='red'> " + (index + 1) + "</font>/" + rowData.length);
        }
        setTimeout(function() {
            valid_rowData(job, rowData, index + 1, failNum);
        }, 0);
    }

}

/**
 * [验证数据行]
 * @param    {[int]}    job [进程号]
 * @param    {[object]}    obj   [行数据]
 * @param    {[int]}    index [行索引]
 * @Author   wangguoying
 * @DateTime 2020-05-12
 */
function valid_obj(job, obj, index) {
    var IInString = "";
    var TeamName = "";
    if (obj.TTeam) TeamName = StringIsNull(obj.TTeam);
    IInString = TeamName; //TName1
    var RegNo = "";
    if (obj.TRegNo) RegNo = StringIsNull(obj.TRegNo);
    IInString = IInString + "^" + RegNo; //RegNo2
    var Name = "";
    if (obj.TName) Name = StringIsNull(obj.TName);
    IInString = IInString + "^" + Name; //Name3
    if (Name == "") {
        obj.TTipMsg = "姓名为空";
        return "";
    }
    var IDCard = "";
    if (obj.TIDCard) IDCard = StringIsNull(obj.TIDCard);
    IDCard = ReplaceStr(IDCard, "'", "");
    IDCard = ReplaceStr(IDCard, String.fromCharCode(10), "");
    IDCard = ReplaceStr(IDCard, String.fromCharCode(13), "")
    var IsvalidIDCard = isCardID(IDCard);
    if (IsvalidIDCard != true) {
        obj.TTipMsg = IsvalidIDCard;
        return "";
    }
    IInString = IInString + "^" + IDCard; //IDCard4
    var Birth = GetBirthByIDCard(IDCard);
    var Sex = "";
    var Arr = Birth.split("^");
    Birth = Arr[0];
    if (Birth != "") {
        if (!IsDate(Birth)) {
            obj.TTipMsg = "身份证录入的生日不对";
            return "";
        }
        Sex = Arr[1];
    }
    var ExcelDesc = "";
    if (obj.TSex) ExcelDesc = StringIsNull(obj.TSex);
    if ((Sex != "") && (ExcelDesc != "") && (ExcelDesc != Sex)) {
        obj.TTipMsg = "身份证中的性别和模版录入的性别不一致";
        return "";
    }
    if (Sex != "") ExcelDesc = Sex;
    IInString = IInString + "^" + ExcelDesc; //Sex5

    var Age = "";
    if (obj.TAge) Age = StringIsNull(obj.TAge);
   
   if(Birth!="") {
        var CardAge=tkMakeServerCall("web.DHCDocCommon","GetAgeDescNew",Birth,"");
        var CardAge=CardAge.split("岁")[0];
    }else{
        var CardAge=""
    }
    
    if ((CardAge != "") && (Age != "") && (CardAge != Age)) {
        obj.TTipMsg = "身份证中的年龄和模版录入的年龄不一致";
        return "";
    }


    IInString = IInString + "^" + Age; //Age6
    var ExcelBirth = "";
    if (Birth != "") {
        ExcelBirth = Birth;
    } else {
        if (obj.TDob) ExcelBirth = StringIsNull(obj.TDob);
    }
    if (ExcelBirth != "") {
        if (!IsDate(ExcelBirth)) {
            obj.TTipMsg = "生日不正确";
            return "";
        }
    }
    IInString = IInString + "^" + ExcelBirth; //Birth7
    var StrValue = "";
    if (obj.TMarital) StrValue = StringIsNull(obj.TMarital);
    if (StrValue == "") StrValue = "";
    IInString = IInString + "^" + StrValue; //Married8
    /*StrValue = "";
    if (obj.TTel) StrValue = StringIsNull(obj.TTel);
    IInString = IInString + "^" + StrValue; //MoveTel9
    StrValue = "";
    if (obj.TTel1) StrValue = StringIsNull(obj.TTel1);
    IInString = IInString + "^" + StrValue; //Tel10
    */
    var Tel = "";
    if (obj.TTel) Tel = StringIsNull(obj.TTel);
    var IsvalidTel="";
    if(Tel!=""){
    var IsvalidTel = CheckTelOrMobile(Tel);
        if (IsvalidTel != true) {
            obj.TTipMsg = IsvalidTel;
            return "";
        }
    }
    IInString = IInString + "^" + Tel; //MoveTel9

    var Tel1=""
    if (obj.TTel1) Tel1 = StringIsNull(obj.TTel1);
    var IsvalidTel1="";
    if(Tel1!=""){
    var IsvalidTel1 = CheckTelOrMobile(Tel1);
        if (IsvalidTel1 != true) {
            obj.TTipMsg = IsvalidTel1;
            return "";
        }
    }
    IInString = IInString + "^" + Tel1; //Tel10

    StrValue = "";
    if (obj.TDepartment) StrValue = StringIsNull(obj.TDepartment);
    IInString = IInString + "^" + StrValue; //Address11
    StrValue = "";
    if (obj.TBeginDate) StrValue = StringIsNull(obj.TBeginDate);
    IInString = IInString + "^" + StrValue; //StartDate12       
    StrValue = "";
    if (obj.TEndDate) StrValue = StringIsNull(obj.TEndDate);
    IInString = IInString + "^" + StrValue; //EndDate13
    StrValue = "";
    if (obj.TAsCharged) StrValue = StringIsNull(obj.TAsCharged);
    IInString = IInString + "^" + StrValue; //AsCharged14
    StrValue = "";
    if (obj.TRecReport) StrValue = StringIsNull(obj.TRecReport);
    IInString = IInString + "^" + StrValue; //IReportSend15
    StrValue = "";
    if (obj.TCashierType) StrValue = StringIsNull(obj.TCashierType);
    IInString = IInString + "^" + StrValue; //ChargedMode16
    StrValue = "";
    if (obj.TGAdd) StrValue = StringIsNull(obj.TGAdd);
    IInString = IInString + "^" + StrValue; //AddItem17
    StrValue = "";
    if (obj.TAddLimit) StrValue = StringIsNull(obj.TAddLimit);
    IInString = IInString + "^" + StrValue; //AddItemLimit18
    StrValue = "";
    if (obj.TAddAmt) StrValue = StringIsNull(obj.TAddAmt);
    IInString = IInString + "^" + StrValue; //AddItemAmount19
    StrValue = "";
    if (obj.TGMedical) StrValue = StringIsNull(obj.TGMedical);
    IInString = IInString + "^" + StrValue; //AddMedical20
    StrValue = "";
    if (obj.TMedicalLimit) StrValue = StringIsNull(obj.TMedicalLimit);
    IInString = IInString + "^" + StrValue; //AddMedicalLimit21
    StrValue = "";
    if (obj.TMedicalAmt) StrValue = StringIsNull(obj.TMedicalAmt);
    IInString = IInString + "^" + StrValue; //AddMedicalAmount22
    StrValue = "";
    if (obj.TCompany) StrValue = StringIsNull(obj.TCompany);
    IInString = IInString + "^" + StrValue; //工作单位23
    StrValue = "";
    if (obj.TNation) StrValue = StringIsNull(obj.TNation);
    StrValue = tkMakeServerCall("web.DHCPE.PreCommon", "GetNationDR", StrValue)
    IInString = IInString + "^" + StrValue; //民族24
    StrValue = "";
    if (obj.TNewCard) StrValue = StringIsNull(obj.TNewCard);
    IInString = IInString + "^" + StrValue; //新发卡25
    StrValue = "";
    if (obj.TAddress) StrValue = StringIsNull(obj.TAddress);
    IInString = IInString + "^" + StrValue; //部联系地址26
    StrValue = "";
    if (obj.TPatType) StrValue = StringIsNull(obj.TPatType);
    IInString = IInString + "^" + StrValue; //病人类型27
    StrValue = "";
    if (obj.THealthArea) StrValue = StringIsNull(obj.THealthArea);
    IInString = IInString + "^" + StrValue; //健康区域28
    StrValue = "";
    if (obj.TCardNo) StrValue = StringIsNull(obj.TCardNo);
    IInString = IInString + "^" + StrValue; //就诊卡号29
    StrValue = "";
    if (obj.TVIPLevel) StrValue = StringIsNull(obj.TVIPLevel);
    IInString = IInString + "^" + StrValue; //VIP等级30
    StrValue = "";
    if (obj.TEmployeeNo) StrValue = StringIsNull(obj.TEmployeeNo);
    IInString = IInString + "^" + StrValue; //工号31
    StrValue = "";
    if (obj.TFileNo) StrValue = StringIsNull(obj.TFileNo);
    IInString = IInString + "^" + StrValue; //病案号32
    StrValue = "";
    if (obj.TPost) StrValue = StringIsNull(obj.TPost);
    IInString = IInString + "^" + StrValue; //职务33
    StrValue = "";

    if (obj.TProduct) StrValue = StringIsNull(obj.TProduct);
    IInString = IInString + "^" + StrValue; //工种 34 
    StrValue = "";
    if (obj.TServLength) StrValue = StringIsNull(obj.接害工龄);
    IInString = IInString + "^" + StrValue; //接害工龄35

    IInString = IInString + "^" + (index + 1); //行号放到最后

    var ReturnValue = tkMakeServerCall("web.DHCPE.ImportGInfo", "GetGPersonInfo", $("#GID").val(), IInString, "Check", job, $("#GDesc").val(), $("#AllowCF").val());
    if (ReturnValue != 0) {
        var RetArr = ReturnValue.split("&");
        if (RetArr.length > 1) {
            obj.TTipMsg = RetArr[0] + ":" + RetArr[1];
        } else {
            obj.TTipMsg = RetArr[0];
        }
        return "";
    }

    return IInString;
}

/**
 * [验证完成事件]
 * @param    {[int]}    failNum   [验证失败记录数]
 * @Author   wangguoying
 * @DateTime 2020-05-08
 */
function afterValid(failNum) {
    sortTStatus("asc"); //验证完成后排序，将错误的信息显示在上面
    $("#DisplayMsg").html("共验证 " + actionListObj.getRows().length + " 记录，失败<font color='red'> " + failNum + "</font> 记录");
    $('#Loading').fadeOut('fast');
    $("#LoadMsg").html("处理中……");
}


/**
 * [获取指定状态的记录总数]
 * @param    {[int]}    Status [0:未验证  1:验证成功  2:导入成功  -1:验证失败  -2:导入失败]
 * @return   {[int]}           [记录总数]
 * @Author   wangguoying
 * @DateTime 2020-05-12
 */
function getNumByStatus(Status) {
    var data = actionListObj.getData();
    var tatal = data.total;
    if (Status == "") return total;
    var num = 0;
    for (var row in data.rows) {
        if (data.rows[row].TStatus == Status) num++;
    }
    return num;
}

/**
 * [导入行数据]
 * @param    {[int]}    job        [进程号]
 * @param    {[object]}    rowData    [表格数据包]
 * @param    {[index]}    index      [行索引]
 * @param    {[int]}    failNum    [失败记录数]
 * @param    {[int]}    successNum [成功记录数]
 * @param    {[int]}    needNum    [应导入总数]
 * @Author   wangguoying
 * @DateTime 2020-05-12
 */
function import_rowData(job, rowData, index, failNum, successNum, needNum) {
    var CTLocID=session['LOGON.CTLOCID']
    var data = rowData[index];
    if (data.TStatus == 1) { //验证成功的才能执行导入
        var instring = valid_obj(job, data, index);
        if (instring == "") {
            failNum++;
            data.TStatus = -1;
        } else {
            var importRet = tkMakeServerCall("web.DHCPE.ImportGInfo", "Main", $("#GID").val(), job,CTLocID);
            var ReturnStr = importRet.split("^");
            var Flag = ReturnStr[0];
            if (Flag != 0) {
                if (Flag == "-119") Flag = "团体名称重复";
                failNum++;
                data.TStatus = -2;
                data.TTipMsg = Flag;
            } else {
                if (ReturnStr[3] == 1) {
                    successNum++;
                    data.TStatus = 2;
                } else {
                    failNum++;
                    data.TStatus = -2;
                    data.TTipMsg = tkMakeServerCall("web.DHCPE.ImportGInfo", "GetImportErr", $("#GID").val(), job, index + 1);
                }
            }
        }
    }
    if (needNum == (failNum + successNum)) {
        actionListObj.loadData(rowData);
        afterImport(failNum, needNum);
    } else {
        if ((failNum + successNum - 1) % interval_num == 0) {
            $("#LoadMsg").html("导入数据：<font color='red'> " + (failNum + successNum) + "</font>/" + needNum);
        }
        setTimeout(function() {
            import_rowData(job, rowData, index + 1, failNum, successNum, needNum);
        }, 0);
    }

}

/**
 * [导入完成事件]
 * @param    {[int]}    failNum   [导入失败记录数]
 * @param    {[int]}    successNum   [导入成功记录数]
 * @Author   wangguoying
 * @DateTime 2020-05-08
 */
function afterImport(failNum, successNum) {
    sortTStatus("asc"); //导入完成后排序，将错误的信息显示在上面
    $("#DisplayMsg").html("共导入 " + successNum + " 记录，失败<font color='red'> " + failNum + "</font> 记录");
    $('#Loading').fadeOut('fast');
    $("#LoadMsg").html("处理中……");
}


function refresh_datagrid() {
    actionListObj.reload();
}

function delete_row(index, status) {
    if (index != "" && index > -1) {
        var tr = actionListObj.getRowDom(index);
        tr.tooltip("destroy").children("td[field]").each(function() {
            $(this).tooltip("destroy");
        });
        actionListObj.deleteRow(index);
        actionListObj.loadData(actionListObj.getRows());
        $("#DisplayMsg").html("删除 1 记录，当前共 " + actionListObj.getRows().length + " 记录");
        $.messager.alert("提示", "已删除", "success");
        return;
    } else {
        var statusDesc = "";
        switch (status) {
            case 0:
                statusDesc = "未验证";
                break;
            case 1:
                statusDesc = "验证成功";
                break;
            case 2:
                statusDesc = "导入成功";
                break;
            case -1:
                statusDesc = "验证失败";
                break;
            case -2:
                statusDesc = "导入失败";
                break;
        }
        if (statusDesc == "") { //全清数据
            $.messager.confirm("提示", "清除全部记录？", function(r) {
                if (r) {
                    editRows = new Array();
                    actionListObj.loadData({
                        "total": 0,
                        "rows": []
                    });
                    $("#DisplayMsg").html("无数据");
                }
            });

        } else {
            $.messager.confirm("提示", "删除状态为【" + statusDesc + "】的全部记录？", function(r) {
                if (r) {
                    var data = actionListObj.getRows();
                    var oldLen = data.length;
                    var newData = [];
                    for (var i = 0; i < oldLen; i++) {
                        if (data[i].TStatus != status) {
                            newData.push(data[i]);
                        }
                    }
                    var newLen = newData.length;
                    actionListObj.loadData(newData);
                    $("#DisplayMsg").html("删除 " + (oldLen - newLen) + " 记录，当前共 " + newLen + " 记录");
                }
            });
        }

    }
}

function add_row() {
    actionListObj.appendRow({
        TStatus: 0
    });
    $("#DisplayMsg").html("新增 1 记录，当前共 " + actionListObj.getRows().length + " 记录");
}


function KillImportGlobal(job) {
    var ReturnValue = tkMakeServerCall("web.DHCPE.ImportGInfo", "KillImportGlobal", job);

    return ReturnValue;
}



//去除字符串两端的空格
function Trim(String) {
    if ("" == String) {
        return "";
    }
    var m = String.match(/^\s*(\S+(\s+\S+)*)\s*$/);
    return (m == null) ? "" : m[1];
}

//去除字符串的空格
function jsTrim(str) {
    var reg = /\s/;
    if (!reg.test(str)) {
        return str;
    }
    return str.replace(/\s+/g, "");
}

function StringIsNull(String) {
    if (String == null) return ""
    //return String
    return jsTrim(String)
}

//去除字符串两端的空格
function ReplaceStr(s, Split, LinkStr) {
    if (s != "" && s != null && typeof(s) != "undefined") {
        s = s + "";
        var SArr = s.split(Split)
        s = SArr.join(LinkStr)
        return s
        var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
        return (m == null) ? "" : m[1];
    } else {
        return "";
    }

}

function GetBirthByIDCard(num) {
    if (num == "") return "";
    //alert(toString(num))
    var ShortNum = num.substr(0, num.length - 1)
    if (isNaN(ShortNum)) {
        //alert("输入的不是数字?");
        return "";
    }
    var len = num.length;
    var re;
    if (len == 15) re = new RegExp(/^(\d{6})()?(\d{2})(\d{2})(\d{2})(\d{3})$/);
    else if (len == 18) re = new RegExp(/^(\d{6})()?(\d{4})(\d{2})(\d{2})(\d{3})(\d)$/);
    else { //alert("身份证号输入的数字位数不对?");
        //websys_setfocus("IDCard");
        return "";
    }
    var a = (ShortNum + "1").match(re);
    if (a != null) {
        if (len == 15) {
            var D = new Date("19" + a[3] + "/" + a[4] + "/" + a[5]);
            var B = D.getYear() == a[3] && (D.getMonth() + 1) == a[4] && D.getDate() == a[5];
            var SexFlag = num.substr(14, 1);
        } else {
            var D = new Date(a[3] + "/" + a[4] + "/" + a[5]);
            var B = D.getFullYear() == a[3] && (D.getMonth() + 1) == a[4] && D.getDate() == a[5];
            var SexFlag = num.substr(16, 1);
        }


        if (!B) {
            //alert("输入的身份证号 "+ a[0] +" 里出生日期不对?");

            //websys_setfocus("IDCard"); //DGV2DGV2
            if (a[3].length == 2) a[3] = "19" + a[3];
            Str = a[3] + "-" + a[4] + "-" + a[5];
            return Str;
        }
        if (a[3].length == 2) a[3] = "19" + a[3];
        var Str = a[3] + "-" + a[4] + "-" + a[5];


        var SexNV = ""
        if (SexFlag % 2 == 1) {
            SexNV = "男";
        } else {
            SexNV = "女";
        }


        return Str + "^" + SexNV;

    }
    return "";
}

function IsDate(str) {
    var re = /^\d{4}-\d{1,2}-\d{1,2}$/;
    if (re.test(str)) {
        // 开始日期的逻辑判断??是否为合法的日期 
        var array = str.split('-');
        var date = new Date(array[0], parseInt(array[1], 10) - 1, array[2]);
        if (!((date.getFullYear() == parseInt(array[0], 10)) &&
                ((date.getMonth() + 1) == parseInt(array[1], 10)) &&
                (date.getDate() == parseInt(array[2], 10)))) {
            // 不是有效的日期 
            return false;
        }
        return true;
    }

    // 日期格式错误 
    return false;
}

function isCardID(sId) {
    var iSum = 0;
    var info = "";
    if (sId == "") return true;
    if (!/^\d{17}(\d|x)$/i.test(sId)) return "你输入的身份证长度或格式错误";
    sId = sId.replace(/x$/i, "a");
    if (aCity[parseInt(sId.substr(0, 2))] == null) return "你的身份证地区非法";
    sBirthday = sId.substr(6, 4) + "-" + Number(sId.substr(10, 2)) + "-" + Number(sId.substr(12, 2));
    var d = new Date(sBirthday.replace(/-/g, "/"));
    if (sBirthday != (d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate())) return "身份证上的出生日期非法";
    for (var i = 17; i >= 0; i--) iSum += (Math.pow(2, i) % 11) * parseInt(sId.charAt(17 - i), 11);
    if (iSum % 11 != 1) return "你输入的身份证号非法";
    //aCity[parseInt(sId.substr(0,2))]+","+sBirthday+","+(sId.substr(16,1)%2?"男":"女");//此次还可以判断出输入的身份证号的人性别
    return true;
}

//验证电话或移动电话
function CheckTelOrMobile(telephone){
    if (isMoveTel(telephone)) return true;
    if (telephone.indexOf('-')>=0){
         return "固定电话长度错误,固定电话区号长度为【3】或【4】位,固定电话号码长度为【7】或【8】位,并以连接符【-】连接,请核实!"; 
      
    }else{
        if(telephone.length!=11){
             return  "电话长度应为【11】位,请核实!"
        }else{
            return "不存在该号段的手机号,请核实!"
        }
    }
    return true;
}
/* 
用途：检查输入是否正确的电话和手机号 
输入： 电话号
value：字符串 
返回： 如果通过验证返回true,否则返回false 
*/  
function isMoveTel(telephone){
    
    var teleReg1 = /^((0\d{2,3})-)(\d{7,8})$/;
    var teleReg2 = /^((0\d{2,3}))(\d{7,8})$/; 
    var mobileReg =/^1[3|4|5|6|7|8|9][0-9]{9}$/;
    if (!teleReg1.test(telephone)&& !teleReg2.test(telephone) && !mobileReg.test(telephone)){ 
        return false; 
    }else{ 
        return true; 
    } 

}
