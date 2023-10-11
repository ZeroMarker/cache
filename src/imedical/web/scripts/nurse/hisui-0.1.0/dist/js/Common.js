/**
 ***************************
公用js
 ***************************
 **/

var kongbiaotou = "空表头";
/* 判断$g是否存在的方法，如果不存在，则定义一个
*/
if (typeof $g === "function") { //FunName为函数名称  
} else {
    $g = function (text) {
        return text;
    }
}
/*
* 便于内网调试，将全局WebIp替换为内网
* @method InnerNetDebug
**/
function InnerNetDebug() {

    ////同步，返回非json
    //var Data = $m({
    //    ClassName: "",
    //    MethodName: "",
    //    Para: ""
    //}, false);

    ////同步，返回json
    //var jsonData = $cm({
    //    ClassName: "",
    //    MethodName: "",
    //    UserName: ""
    //}, false); 
    window.WebIp = window.location.href.split("/csp/")[0];
}
//把数值转为几小时几分钟，小时分钟相加后处理
//产程，小时分钟，合计小时和分钟
function ToHourMinute(val) {
    var hour = parseInt(val / 1);
    var text = "";
    if (!!hour)
        text = hour + "小时" + Math.abs(Math.round((val - hour) * 60)) + "分钟";
    else
        text = Math.round((val - hour) * 60) + "分钟";
    return text;
}
//把日期和时间字符串合并为一个日期数据
function parserDateTimeTextToDate(dateText, TimeText) {
    var text = dateText + " " + TimeText;
    var Date1 = Date.parse(text);
    if (isNaN(Date1)) {
        var datetoday = new Date();
        var year = datetoday.getFullYear();
        var month = datetoday.getMonth();
        var day = datetoday.getDate();
        var dateTextArry = dateText.split("-"); //yyyy-mm-dd               
        if (dateTextArry.length == 1) {
            dateTextArry = dateText.split("/"); //yyyy/mm/dd
        }
        if (dateTextArry.length == 3) {
            year = parseInt(dateTextArry[0]);
            month = parseInt(dateTextArry[1]) - 1;
            day = parseInt(dateTextArry[2]);
        }
        var TimeTextArry = TimeText.split(":"); //hh:mm:ss
        if (TimeTextArry.length >= 2) {
            var hour = parseInt(TimeTextArry[0]);
            var minute = parseInt(TimeTextArry[1]);
            var second = 0;
            return new Date(year, month, day, hour, minute, second);
        }
        else {
            return new Date(year, month, day);
        }
    }
    return Date1;
}
/**
     *获取日志辅助信息
     @method __GetLogAuxiliaryInfo
**/
function GetLogAuxiliaryInfo() {
    var logAuxiliaryInfo = {};

    logAuxiliaryInfo["LOGON.CTLOCID"] = session['LOGON.CTLOCID'];
    logAuxiliaryInfo["LOGON.WARDID"] = session['LOGON.WARDID'];
    logAuxiliaryInfo["LOGON.GROUPDESC"] = session['LOGON.GROUPDESC'];
    logAuxiliaryInfo["LOGON.USERID"] = session['LOGON.USERID'];
    logAuxiliaryInfo["LOGON.SSUSERLOGINID"] = session['LOGON.SSUSERLOGINID'];
    logAuxiliaryInfo["LOGON.LANGID"] = session['LOGON.LANGID']
    logAuxiliaryInfo["SubjectionTemplateGuid"] = GetTopTempletGuid();

    return JSON.stringify(logAuxiliaryInfo);
}
//把数值转为小时,两个日期相减的结果处理
function GetHours(val) {
    var totalSecond = val / 1000;//总秒数
    var hours = totalSecond / (60 * 60);//计算整数小时数 
    return hours.toFixed(2);
}
//把数值转为分钟,两个日期相减的结果处理
function GetMinutes(val) {
    var totalSecond = val / 1000;//总秒数
    var Minutes = totalSecond / 60;//单位是分钟
    return (Minutes).toFixed(2);
}
function FormatDateCalToDay(val) {
    var totalSecond = val / 1000;//总秒数
    var day = parseInt(totalSecond / (24 * 60 * 60));//计算整数天数
    var afterDay = totalSecond - day * 24 * 60 * 60;//取得算出天数后剩余的秒数
    var hour = (afterDay / (60 * 60)).toFixed(2);//计算整数小时数   
    var text = "";
    if (day > 0) {
        text += day + "天";
    }
    text += hour + "小时";
    return text;
}
//把数值转为天,小时,分钟两个日期相减的结果处理
function FormatDateCalToDayHourMinutes(val) {
    var totalSecond = val / 1000;//总秒数
    var day = parseInt(totalSecond / (24 * 60 * 60));//计算整数天数
    var afterDay = totalSecond - day * 24 * 60 * 60;//取得算出天数后剩余的秒数
    var hour = parseInt(afterDay / (60 * 60));//计算整数小时数  
    var Minutes = parseInt((afterDay - hour * 60 * 60) / 60);//单位是分钟
    var text = "";
    if (!!day) {
        text += day + "天";
    }
    if (!!hour) {
        if (!!text)
            text += Math.abs(hour) + "小时";
        else
            text += hour + "小时";
    }
    if (!!Minutes) {
        if (!!text)
            text += Math.abs(Minutes) + "分钟";
        else
            text += Minutes + "分钟";
    }
    return text;
}
function FormatDateCalToHour(val) {
    var text = GetHours(val) + "小时";
    return text;
}
/*var str='这是一个测试的字符串：{str0} {str1}'.format({str0:'Hello',str1:'world'});
var str='这是一个测试的字符串：{0} {1}'.format('Hello','world');
*/
String.prototype.format = function (args) {
    var result = this;
    if (arguments.length > 0) {
        if (arguments.length == 1 && typeof (args) == "object") {
            for (var key in args) {
                if (args[key] != undefined) {
                    var reg = new RegExp("({" + key + "})", "g");
                    result = result.replace(reg, args[key]);
                }
            }
        }
        else {
            for (var i = 0; i < arguments.length; i++) {
                if (arguments[i] != undefined) {
                    var reg = new RegExp("({)" + i + "(})", "g");
                    result = result.replace(reg, arguments[i]);
                }
            }
        }
    }
    return result;
}
//转义文字中的特殊字符，避免生成的拼接的HTML导致其他的错误
function html_encode(str) {
    var s = "" + str;
    if (!s) {
        return "";
    }
    if (s.length == 0)
        return "";
    s = s.replace(/&/g, "&amp;"); //替换&号
    s = s.replace(/</g, "&lt;"); //替换小于号
    s = s.replace(/>/g, "&gt;"); //替换大于号
    //s = s.replace(/ /g, "&nbsp;"); //替换空格
    s = s.replace(/\'/g, "&#39;"); //替换单引号
    s = s.replace(/\"/g, "&quot;"); //替换双引号
    s = s.replace(/\n/g, "<br/>"); //替换换行符
    s = s.replace(/\\n/g, "<br/>"); //替换换行符
    return s;
}
function html_decode(str) {
    var s = "" + str;
    if (!s) {
        return "";
    }
    if (s.length == 0)
        return "";
    s = s.replace(/&amp;/g, "&");
    s = s.replace(/&lt;/g, "<");
    s = s.replace(/&gt;/g, ">");
    //s = s.replace(/&nbsp;/g, " ");
    s = s.replace(/&#39;/g, "\'");
    s = s.replace(/&quot;/g, "\"");
    s = s.replace(/<br\/>/g, "\n");
    return s;
}
/**
 *根据服务生成的identity,获取具体类型的字符串表示
@method GetElementStringType
@return string
 **/
function GetElementStringType(identity) {
    var testReg = /^edit/;
    if (testReg.test(identity))
        return GetEditElementStringType(identity);
    else
        return identity.split("_")[0];
}

function IsTableCellEdit(tableId) {
    return $("#" + tableId).datagrid("options").cellEdit;
}

function GetTableIdByIndentity(identity) {
    var testReg = /^edit/;
    if (testReg.test(identity)) {
        var tarry = identity.split("_");
        var t = tarry[0] + "_" + tarry[1];
        return t.replace("edit", "");
    }
    else
        return "";
}

function GetTableFieldByIndentity(identity) {
    var testReg = /^edit/;
    if (testReg.test(identity)) {
        var tarry = identity.split("_");
        var t = tarry[2] + "_" + tarry[3];
        t = t.replace("Statistics","");
        return t;
    }
    else
        return "";

}

/**
 *根据服务生成的identity,获取具体类型的字符串表示
@method GetEditElementStringType
@return string
 **/
function GetEditElementStringType(identity) {
    var type = identity.split("_")[2];

    if (type == "CheckElement" || type == "RadioElement") {
        return "DropListElement";
    }

    return type;
}

/**
 *获取数据表格选中的数据的rowID
@method DataTableCheckRowIds
@param { DataTableElementId } 表格的HTML的ID
@return string
 **/
function DataTableCheckRowIds(DataTableElementId) {
    var ids = [];

    if (IsHisUIDataTable(DataTableElementId)) {
        var rows = $('#' + DataTableElementId + '').datagrid('getChecked');
        if (rows.length > 0) {

            $.each(rows, function (index, row) {
                ids.push(row.ID);
            });

            return ids.toString();
        }
    }
    else if (IsRowToColDataTable(DataTableElementId)) {
        var selectedID = null;
        $('#' + DataTableElementId + ' .datagrid-row-selected').each(function (i) {
            selectedID = $(this).attr("rowID");
            return false;
        });
        return selectedID;
    }

    return null;
}

/**
 *数据表格的某条数据是否是作废的
@method IsCancelDataTableRow
@param { DataTableElementId } 表格的HTML的ID
@param { RowID } 流水ID
@return bool
 **/
function IsCancelDataTableRow(DataTableElementId, RowID) {
    var isCancel = false;

    if (IsHisUIDataTable(DataTableElementId)) {
        var rows = $('#' + DataTableElementId + '').datagrid('getRows');
        if (rows.length > 0) {
            $.each(rows, function (index, row) {
                if (row.ID == RowID) {
                    if (!!row.CancelInfo && row.CancelInfo != "null")
                        isCancel = true;
                    return false;
                }
            });
        }
    }
    else if (IsRowToColDataTable(DataTableElementId)) {

        var rows = $('#' + DataTableElementId + '').data("Rows");
        if (rows.length > 0) {
            $.each(rows, function (index, row) {
                if (row.ID == RowID) {
                    if (!!row.CancelInfo && row.CancelInfo != "null")
                        isCancel = true;
                    return false;
                }
            });
        }
    }

    return isCancel;
}

/**
获取HISUI表格操作列修改按钮生成脚本
@method formatterEdit
@param { value } 当前单元格的值
@param { rowData } 当前行的值
@param { index } 行序号
@param { TemplateGuid } 回调的模板ID
@param { callBack } 回调函数
@return string

 **/
function formatterEdit(value, rowData, index, templateIndentity, callBack, windowsInfo) {
    if (!!rowData.ID) {
        var windowsInfostr = "null"
        if (windowsInfo) {
            windowsInfostr = JSON.stringify(windowsInfo)
        }
        var a = [];
        var urlPartParam = "NurMPDataID=" + rowData.ID;
        a.push("<a style='text-decoration:none;'");
        a.push(" href='javascript:void(OpenWindow(");
        //四个参数
        a.push("\"" + templateIndentity + "\"");
        a.push(",");
        a.push("\"");
        a.push(callBack);
        a.push("\"");
        a.push(",");
        a.push("null");
        a.push(",");
        a.push("\"" + urlPartParam + "\"");
        a.push(",");
        a.push("" + windowsInfostr + "");
        a.push(")"); //void关闭
        a.push(")"); //OpenWindow关闭
        a.push("'"); //属性关闭
        var text = $g('修改');
        a.push("><span title='" + text + "'>" + text + "</span></a>&nbsp;&nbsp;");
        return a.join("");
    }
}

/**
HISUI表格需复评列生成脚本
**/
function formatterReaccreditation(value, rowData, index, callBack, windowsInfo) {
    if (!value)
        return;
    var windowsInfostr = "null"
    if (!!windowsInfo) {
        windowsInfostr = JSON.stringify(windowsInfo)
    }

    var a = [];
    a.push("<a style='text-decoration:none;'");
    a.push(" href='javascript:void(Reaccreditation(");
    //三个参数
    a.push(JSON.stringify(rowData));
    a.push(",");
    a.push("\"" + callBack + "\"");
    a.push(",");
    a.push(windowsInfostr);
    a.push(")"); //void关闭
    a.push(")"); //OpenWindow关闭
    a.push("'"); //属性关闭
    var text = $g('复评');
    a.push("><span title='" + text + "'>" + text + "</span></a>&nbsp;&nbsp;");
    return a.join("");
}

/**
HISUI复评操作列业务逻辑
**/
function Reaccreditation(rowData, callBack, windowsInfo) {
    //撤销需复评
    HisUIStatisticsOpenWindow(rowData, callBack, windowsInfo);
}

/**
获取HISUI表格合并列生成脚本
@method formatterMergerColumns
@param { value } 当前单元格的值
@param { rowData } 当前行的值
@param { index } 行序号
@param { mergerColumnsInfo } 需要合并列的相关信息
@return string

 **/
function formatterMergerColumns(value, rowData, index, mergerColumnsInfo) {
    var a = [];
    var text = "";
    for (var p in mergerColumnsInfo) {
        var field = p; //属性名称,字段名称
        var title = mergerColumnsInfo[p]; //此列对应的标题
        var data = rowData[field];
        var data = data.replace(/<br\/>/g, "\n"); //把转义的换行符替换回去
        text += title + ":" + data + ";\r\n";
    }
    a.push("<span ");
    a.push("title='");
    a.push(text);
    a.push("'");
    a.push(">");
    if (!value) {
        a.push(value);
    } else {
        a.push(text);
    }
    a.push("</span>");
    return a.join("");
}
/**
获取HISUI表格操作列删除按钮生成脚本
@method formatterDel
@param { value } 当前单元格的值
@param { rowData } 当前行的值
@param { index } 行序号
@param { TemplateGuid } 回调的模板ID
@param { callBack } 回调函数
@return string

 **/
function formatterDel(value, rowData, index, templateIndentity, callBack) {
    var a = [];
    var urlPartParam = "NurMPDataID=" + rowData.ID; //和主键对应
    a.push("<a style='text-decoration:none;'");
    a.push(" href='javascript:void(DelWindow(");
    //四个参数
    a.push("\"" + TemplateIndentity + "\"");
    a.push(",");
    a.push("\"");
    a.push(callBack);
    a.push("\"");
    a.push(",");
    a.push("null");
    a.push(",");
    a.push("\"" + urlPartParam + "\"");
    a.push(")"); //void关闭
    a.push(")"); //OpenWindow关闭
    a.push("'"); //属性关闭
    var text = $g('删除');
    a.push("><span  title='" + text + "'>" + text + "</span></a>&nbsp;&nbsp;");
    //a.push(" < span class='icon-edit'  title='修改'>修改</span>");
    return a.join("");
}

function formatterHisuiCellStyle(value, customSytle,rowData) {
    var styler = "";
    $.each(customSytle, function (i, style) {
        if (!!value && eval(style.Condition)) {
            styler = "";
            if (!!style.CellColor)
                styler += "background-color:" + style.CellColor + ";";
            if (!!style.TextColor)
                styler += "color:" + style.TextColor + ";";
        }
    });

    return styler;
}

/**
 * 判断是否是Hisui数据表格
 * @method IsHisUIDataTable
 * @param { int } DataTableElementId 表格的HTML的ID
 * @return { bool } 
 **/
function IsHisUIDataTable(DataTableElementId) {
    var testReg = /^HISUIDataTableElement/;
    if (testReg.test(DataTableElementId))
        return true;
    else
        return false;
}

/**
 * 判断是否是单列Hisui数据表格
 * @method IsSCHisUIDataTable
 * @param { int } DataTableElementId 表格的HTML的ID
 * @return { bool } 
 **/
function IsSCHisUIDataTable(DataTableElementId) {
    var testReg = /^SingleColumnHISUIDataTableElement/;
    if (testReg.test(DataTableElementId))
        return true;
    else
        return false;
}

/**
 * 判断是否是行转列数据表格
 * @method IsRowToColDataTable
 * @param { int } DataTableElementId 表格的HTML的ID
 * @return { bool } 
 **/
function IsRowToColDataTable(DataTableElementId) {
    var testReg = /^RowToColDataTableElement/;
    if (testReg.test(DataTableElementId))
        return true;
    else
        return false;
}

/**
设置HISUI表格行的背景色24小结，日结 需要在表格的对应行上用不同的底色显示
@method HISUITableRowStyler
@param { index } 行序号
@param { rowData } 当前行的值
@param { Fields } 绑定的 Field数组
@return string

 **/
function HISUITableRowStyler(index, rowData, tableID) {
    var opts = $('#' + tableID).datagrid('options');
    if (rowData != undefined && !!rowData.StatisticsInfo) {
        if (!opts.statisticsResultDoubleBlack) {
            if (rowData.StatisticsInfo.type == "TwentyFourHoursStatistics") {
                return DataRowBackColorStyle["TwentyFourHoursStatistics"] == "" ? 'background-color:#F7FE2E;' : "background-color:" + DataRowBackColorStyle["TwentyFourHoursStatistics"];
            }
            if (rowData.StatisticsInfo.type == "TimeQuantumStatistics") {
                return DataRowBackColorStyle["TimeQuantumStatistics"] == "" ? 'background-color:#A7FE2E;' : "background-color:" + DataRowBackColorStyle["TimeQuantumStatistics"];
            }
            if (rowData.StatisticsInfo.type == "DaytimeStatistics") {
                return DataRowBackColorStyle["DaytimeStatistics"] == "" ? 'background-color:#A7FE2E;' : "background-color:" + DataRowBackColorStyle["DaytimeStatistics"];
            }
        }
        if (rowData.StatisticsInfo.type == "SingleItemStatistics") {
            return DataRowBackColorStyle["SingleItemStatistics"] == "" ? 'background-color:#A7FE2E;' : "background-color:" + DataRowBackColorStyle["SingleItemStatistics"];
        }
        if (rowData.PrintFormFeed == "true") {
            return DataRowBackColorStyle["PrintFormFeed"] == "" ? 'background-color:#93B4FC;' : "background-color:" + DataRowBackColorStyle["PrintFormFeed"];
        }
        if (rowData.StatisticsInfo.type == "MaxMinStatistics") {
            return rowData.StatisticsInfo.color == "" ? 'background-color:#FF0000;' : "background-color:" + rowData.StatisticsInfo.color;
        }
    }
    if (rowData != undefined && !!rowData.PrintInfo && rowData.PrintInfo != "null") {
        return { class: 'datagrid-row-mp-printed' };
    }

    if (rowData != undefined && !!rowData.PrintAlled && rowData.PrintAlled == "true") {
        return { class: 'datagrid-row-mp-printed' };
    }

    if (opts.cancelRecShowRed && !!rowData.CancelInfo && rowData.CancelInfo != "null")
        return "color:red;";
    return "";
}
function DelWindow(TemplateGuid, callbackFun, gatherFun, urlPartParam) {
}
/**
 * 从服务获取某个模板的全部数据或者指定数据
 * @method GetDataFromService
 * @param { int } templateVersionGuid 模板的版本GUID
 * @param { array } specifyFileds 指定字段，空数组时获取全部数据，否则获取指定数据
 * @param { string } pageInfo  分页信息
 * @param { object } queryInfo 查询信息
 * @param { bool } async 是否异步
 **/
function GetDataFromService(templateVersionGuid, specifyFileds, pageInfo, queryInfo, async) {

    var dataPost = {};

    var queryObj = GetQueryObject();
    if (!!queryObj.NurMPDataID) //数据ID
    {
        dataPost["NurMPDataID"] = queryObj.NurMPDataID;
    }
    if (!!templateVersionGuid) {
        dataPost["templateVersionGuid"] = templateVersionGuid;
    } else {
        dataPost["templateVersionGuid"] = window.TemplateGUID;
    }
    if (!!specifyFileds) {
        dataPost["specifyFileds"] = specifyFileds;
    }
    if (!!pageInfo) {
        dataPost["pageInfo"] = UrlParamsToObject(pageInfo);
    }
    if (!!queryInfo) {
        dataPost["queryInfo"] = queryInfo;
    }

    if (!!queryObj["EpisodeID"])
        dataPost["EpisodeID"] = queryObj["EpisodeID"];
    else
        dataPost["EpisodeID"] = window.EpisodeID;

    if (!!specifyFileds)
        console.time(specifyFileds.join("_"));
    else
        console.time();
    var url = WebIp + "/csp/dhcnurmpgetdata.csp?ClassName=NurMp.TemplateSet&MethodName=GetCodeList";
    url = GetMWToken(url);
    $.ajax({
        type: "POST",
        url: url,
        data: { datapost: JSON.stringify(dataPost) },
        async: async == false ? false : true, //除非指定是同步，否则默认都是异步
        beforeSend: function (XMLHttpRequest) {
            if (!!specifyFileds) {
                if (specifyFileds[0].indexOf("HISUIDataTableElement") > -1) {
                    $("#" + specifyFileds[0]).datagrid("loading")
                }
            }
        },
        complete: function (XMLHttpRequest, textStatus) {
            if (!!specifyFileds) {
                if (specifyFileds[0].indexOf("HISUIDataTableElement") > -1) {
                    $("#" + specifyFileds[0]).datagrid("loaded")
                }
            }
        },
        success: function (msg) {

            var reMsg = JSON.parse(msg);
            if (!MsgIsOK(reMsg)) {
                if (reMsg.msg.indexOf("升级中") > -1) {
                    if (specifyFileds == null)//避免多次alert，只保证页面第一个请求提示即可
                        $.messager.alert(" ", $g("加载失败\n错误原因：") + reMsg.msg, "error");
                }
                else
                    $.messager.alert(" ", $g("加载失败\n错误原因：") + reMsg.msg, "error");               
                return;
            }
            if (!!reMsg.data["tNurMPDataID"])
                window.tNurMPDataID = reMsg.data["tNurMPDataID"];//单次评估单的流水号（注意不要乱用）
            //导入新建需要过滤的表单元素
            if (!!queryObj.FilterImportItems) {
                $.each(queryObj.FilterImportItems.split(','), function (i, n) {
                    if (reMsg.data.hasOwnProperty(n)) {
                        delete reMsg.data[n];
                    }
                });
            }


            var currentWindowGuid = GetQueryString("OpenWindowGuid");
            var gatherData = null;
            if (!!currentWindowGuid && !!window.parent.OpenWindowsObj)
                gatherData = window.parent.OpenWindowsObj[currentWindowGuid].gatherData;

            //通过采集带入的值，优先级最高
            if (!!gatherData) {
                $.each(gatherData.keys, function (i, n) {
                    if (!IsSysElement(n))
                        return true;
                    var val = gatherData.vals[i];
                    if ($.isArray(val)) { //下拉元素，返回的是数组，里面是一个object{Text，Value}
                        if (val.length == 1) {
                            //样例： 2018-05-05(10:20) Y 1-
                            if (DynamicTableTitleTest(val[0]["Text"])) {
                                var _title = val[0]["Text"];
                                val = _title.replace(/\s{1}(Y|N)\s{1}/, val[0]["Value"] + " ");
                            }
                            else if (val[0]["Text"] === kongbiaotou) {
                                val = kongbiaotou;
                            }
                        }
                    }
                    if (!IsHisUIDataTable(n) && !IsRowToColDataTable(n)) {
                        if (!!reMsg.data[n]) {
                            if (val === "")
                                delete reMsg.data[n];//用默认值或者自动带
                            else
                                reMsg.data[n] = val;
                        }
                        else {
                            reMsg.data[n] = val;
                        }
                    }
                });
            }

            BindingData(reMsg.data);
            if (specifyFileds == null) {//表示获取所有表单数据(非表格数据)
                window.FoundationDataReady = true;
                window.CAOldFormData = reMsg.data;
            }

            if (!!specifyFileds)
                console.timeEnd(specifyFileds.join("_"));
            else
                console.timeEnd();
        }
    });
}
/**
 * 记录下新增时页面的原始数据
 **/
function UpdateCAOldFormData() {
    var queryObj = GetQueryObject();
    if (!!queryObj.NurMPDataID) {
        //以服务端返回的数据为准,在GetDataFromService里赋值
    }
    else {
        var dataPost = GatherTemplateData();
        window.CAOldFormData = dataPost;
    }
}
/**
 * 把数据绑定到模板
 * @method BindingData
 * @param { object } data数据，可以是object
 **/
function BindingData(data) {
    var uesd = [];
    if (window.LoadFormElements != undefined) {
        $.each(LoadFormElements, function (i, eleID) {
            if (data.hasOwnProperty(eleID)) {
                SetOneValue(eleID, data[eleID]);
                uesd.push(eleID);
            }
        });
    }
    $.each(data, function (id, value) {
        if ($.inArray(id, uesd) == -1)
            SetOneValue(id, value);
    });
}
/**
 * 通过模板Guid打开新窗口
 * @method OpenWindow
 * @param { string } TemplateGuid 模板Guid
 * @param { function } callbackFun 回调的方法
 * @param { function } gatherFun 收集信息的方法
 * @param { string } urlPartParam 额外的URL参数 "name=李四&age=18"
 * @param { object } 和后台WindowsInfo类对应，是JSON结构
"{"width": width,"height": height}";
 **/
function OpenWindow(TemplateEmrCode, callbackFun, gatherFun, urlPartParam, windowsInfo, callbackFunParams) {

    if (!TemplateEmrCode)
        return;

    var url = WebIp + "/csp/nur.emr." + TemplateEmrCode.toLowerCase() + ".csp";

    url = UrlJoinParam(url, "EpisodeID=" + EpisodeID);

    if (callbackFun)
        url = UrlJoinParam(url, "callback=" + callbackFun);

    var AuthorityFlag = GetQueryString("AuthorityFlag");
    if (!!AuthorityFlag)
        url = UrlJoinParam(url, "AuthorityFlag=" + AuthorityFlag);

    var ModelId = GetQueryString("ModelId");
    if (!!ModelId)
        url = UrlJoinParam(url, "ModelId=" + ModelId);

    if (urlPartParam)
        url = UrlJoinParam(url, urlPartParam)

    var openWindowGuid = newGuid();
    url = UrlJoinParam(url, "OpenWindowGuid=" + openWindowGuid);

    if (window.OpenWindowsObj == undefined)
        window.OpenWindowsObj = {};

    window.OpenWindowsObj[openWindowGuid] = { gatherData: null };

    if (!!gatherFun) {
        window.OpenWindowsObj[openWindowGuid].gatherData = window[gatherFun]();
    }
    url = GetMWToken(url);
    if (!!url)
        url = encodeURI(url);
    
    window.CommonModalDialog = OpenCommonModalDialog($g("信息"), url, windowsInfo, callbackFun, callbackFunParams);
    
    // 超融合
    OpenExtendPage();
}
/**
 * hisui,用于统计用的表格，双击打开新窗口
 * @method HisUIStatisticsOpenWindow
 * @param { object } rowData 表格行数据
 * @param { function } callbackFun 回调的方法
 * @param { object } 和后台WindowsInfo类对应，是JSON结构
 **/
function HisUIStatisticsOpenWindow(rowData, callbackFun, windowsInfo) {
    var templateEmrCode = rowData.EmrCode;
    var episodeID = rowData.Adm;
    var urlPartParam = "NurMPDataID=" + rowData.ID.split("^")[0] + "&EpisodeID=" + episodeID;
    OpenWindow(templateEmrCode, callbackFun, null, urlPartParam, windowsInfo);
}
/**
 * 获取模态窗口的属性
 * @method GetWindowModalFeatures
 * @param { object } windowsInfo 窗口高度，宽度，滚动条
 **/
function GetWindowModalFeatures(windowsInfo) {
    var set = [];
    if (windowsInfo && !!windowsInfo.height) {
        set.push("dialogHeight=" + windowsInfo.height + "px");
    } else {
        set.push("dialogHeight=" + screen.availHeight + "px");
    }
    if (windowsInfo && !!windowsInfo.width) {
        set.push("dialogWidth=" + windowsInfo.width + "px");
    } else {
        set.push("dialogWidth=" + screen.availWidth + "px")
    }
    if (windowsInfo && !!windowsInfo.scrollbars) {
        set.push("scroll=yes");
    } else {
        set.push("scroll=no");
    }
    return set.join(";");
}
/**
 * 拼接URL参数
 * @method UrlJoinParam
 * @param { string } url
 * @param { string } urlParams   URL参数
 **/
function UrlJoinParam(url, urlParams) {
    if (urlParams == "")
        return url;
    if (url.indexOf("?") > -1) {
        url = url + "&" + urlParams;
    } else {
        url = url + "?" + urlParams
    }
    return url;
}
/**
 * 获取URL中的参数
 * @method GetQueryString
 * @param { string } name 要获取的参数的名字
 **/
function GetQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var result = window.location.search.substr(1).match(reg);
    if (result != null) {
        return decodeURIComponent(result[2]);
    } else {
        return null;
    }
}
function GetMWToken(url) {
    if ('undefined' !== typeof websys_getMWToken) {
        if (url.indexOf("?") == -1) {
            url = url + "?MWToken=" + websys_getMWToken();
        } else {
            url = url + "&MWToken=" + websys_getMWToken();
        }
    }
    return url;
}
/**
 * 获取URL中的参数
 * @method GetQueryObject
 * @return { object } 以对象方式返回所有的参数
 **/
function GetQueryObject() {
    var url = location.search;
    var theRequest = new Object();

    if (url.indexOf("?") != -1) {
        var str = url.substr(1);
        strs = str.split("&");
        for (var i = 0; i < strs.length; i++) {
            var item = strs[i];
            var key = item.split("=")[0];
            var value = item.split("=")[1];
            theRequest[key] = decodeURI(value);
        }
    }
    return theRequest;
}
/**
 * 收集模板所有的输入信息
 * @method GatherTemplateData
 * @return { Object } key/value 以formName/value格式返回

 **/
function GatherTemplateData() {
    var re = {};
    var testReg = /^[a-zA-Z]{2,}_[0-9]{1,}$/; //命名规则是字母下划线数值三部分，//下拉单选，下拉多选会自动生成部分input，需要排除

    $.each(ElementUtility, function (key, helper) {
        if (helper.isForm()) {
            var tempInputFormNames = [];
            $("input[name^='" + key + "_']").each(function (i) {
                var name = $(this).attr("name");
                if (tempInputFormNames.indexOf(name) == -1) {
                    if (testReg.test(name)) {
                        tempInputFormNames.push(name);
                    }
                }
            });
            $("select[id^='" + key + "_']").each(function (i) {
                var name = $(this).attr("id");
                if (tempInputFormNames.indexOf(name) == -1) {
                    if (testReg.test(name)) {
                        tempInputFormNames.push(name);
                    }
                }
            });
            $("textarea[name^='" + key + "_']").each(function (i) {
                var name = $(this).attr("name");
                if (tempInputFormNames.indexOf(name) == -1) {
                    if (testReg.test(name)) {
                        tempInputFormNames.push(name);
                    }
                }

            });
            $("img[name^='" + key + "_']").each(function (i) {
                var name = $(this).attr("name");
                if (tempInputFormNames.indexOf(name) == -1) {
                    if (testReg.test(name)) {
                        var marker = $("#" + name).attr("marker");
                        var markerFree = $("#" + name).attr("markerFree");
                        var upload = $("#" + name).attr("upload");
                        if ((marker !== undefined && marker === "true")
                            || (markerFree !== undefined && markerFree == "true")
                            || (upload !== undefined && upload == "true")) {
                            tempInputFormNames.push(name);
                        }
                    }
                }
            });
            $("image[id^='" + key + "_']").each(function (i) {
                var name = $(this).attr("id");
                if (tempInputFormNames.indexOf(name) == -1) {
                    if (testReg.test(name)) {
                        var saveData = $("#" + name).attr("saveData");
                        if (saveData !== undefined && saveData == "true") {
                            tempInputFormNames.push(name);
                        }
                    }
                }
            });

            $.each(tempInputFormNames, function (index, formName) {
                if (!!window.HiddenNoSubmit) {
                    var parentId = "div_" + formName;
                    var elementType = GetElementStringType(formName);
                    if (elementType != "HiddenTextElement" && $("#" + parentId).is(':hidden'))
                        return true;
                }
                re[formName] = helper.getValueByName(formName);
            });
        }
    });
    return re;
}
/**
 * 收集模板里指定的字段的信息
 * @method GatherTemplateSpecifyFiledsData
 * @param { array } specifyFileds [TextElement_3,TextElement_5]
 * @return { obj } {keys:[],vals:[]} 以formName/value格式返回

 **/
function GatherTemplateSpecifyFiledsData(specifyFileds) {
    var re = {
        keys: [],
        vals: []
    };
    if (specifyFileds.length == 0)
        return re;

    var callerStack = GetFunctionCallerStack();
    var saveFunc = ["__SaveCore", "Save", "TemporarySave", "RealTimeSave", "SaveAndCloseWindow", "SaveAndGeneratePic", "SaveAndGeneratePicAndCloseWindow"];
    var isSaveCaller = false;
    $.each(saveFunc, function (i, n) {
        var b = callerStack.lastIndexOf(n);
        if (b > -1) {
            isSaveCaller = true;
            return false;
        }
    });
    
    $.each(specifyFileds, function (index, formName) {
        var helper = GetElementHelper(formName);
        var queryBandingField = $("#" + formName).attr("querybanding");
        var fieldValue = helper.getValueByName(formName);
        var queryReSetPrintPageNo = $("#" + formName).attr("reSetPrintPageNo")
        if (!isSaveCaller && !!queryBandingField) { //查询条件，都知道自己是属于哪个表格
            if (queryBandingField.split(":").length > 1) {
                re.keys.push(queryBandingField.split(":")[1]);
                re.vals.push(fieldValue);
            }
        }
        else if (!isSaveCaller && !!queryReSetPrintPageNo) {//查询条件
            re.keys.push("StartPageNo");
            re.vals.push(fieldValue);
        }
        else {
            re.keys.push(formName);
            re.vals.push(fieldValue);
        }
    });

    return re;
}
/**
 * 收集模板里指定的字段的信息
 * @method CombineSpecifyFiledsData
 * @param { obj } {keys:['textElement_1','dataElement_2'],vals:['小明','2019-2-26']} 
 * @return { obj } 以formName/value格式返回

 **/
function CombineSpecifyFiledsData(specifyFiledsData) {

    var re = {};

    $.each(specifyFiledsData.keys, function (index, formName) {
        var val = specifyFiledsData.vals[index];
        if ($.isArray(val)) //下拉元素，返回的是数组，里面是一个object{Text，Value}
        {
            if (val.length == 1) {
                //样例： 2018-05-05(10:20) Y 1-
                if (DynamicTableTitleTest(val[0]["Text"])) {
                    var _title = val[0]["Text"];
                    val = _title.replace(/\s{1}(Y|N)\s{1}/, val[0]["Value"] + " ");
                }
                else if (val[0]["Text"] === kongbiaotou) {
                    val = kongbiaotou;
                }
            }
        }

        re[formName] = val;
    });

    return re;
}
/**
 * 初始化隐藏域
 * @method InitHiddenField
 **/
function InitHiddenField() {
    //
}

function InitImageEditor(id) {
      $("#"+id+" .tie-btn-history").hide();
      $("#"+id+" .tui-image-editor-controls").hide();
      $("#"+id+" .tui-image-editor-submenu").css("height", "0px");
      $("#" + id + " .tui-image-editor-menu-draw").css("padding-bottom", "0px");
      $("#" + id + " .tui-image-editor-range-value").css("margin-top", "0px");

      $(".tui-image-editor-submenu-item > li").eq(0).hide();
      $(".tui-image-editor-submenu-item > li").eq(1).hide();
      $(".tui-image-editor-submenu-item > li").eq(2).hide();
      $(".tui-image-editor-submenu-item > li").eq(3).hide();
}

/**
 * 初始化自动签名
 * @method InitAutoSignature
 **/
function InitAutoSignature() {

    $("input[SignatureAuto='True']").each(function (i) {

        if (typeof DistrictCfg != "undefined") {
            if (HandoverVerifyItemEnable($(this)))
                JobNumEnterToName($(this), true);
        }
        else
            JobNumEnterToName($(this), true);
    });
}
/**
 * 动态修改空白表头对应的输入项的标签
 * @method InitDynamicTableTitleLabel
 **/
function InitDynamicTableTitleLabel() {
    var queryObject = GetQueryObject();
    if (!queryObject["IsDynamicTableTitle"])
        return;

    function EmptyTitleHandle(labelElement) {
        //空白表头不能录入
        var inputFormName = $(labelElement).parent().next().children(":first").attr("id");
        if (IsSysElement(inputFormName)) {
            var helper = GetElementHelper(inputFormName);
            helper.disEnable(inputFormName, true);
        }
    }

    var currentWindowGuid = GetQueryString("OpenWindowGuid");
    var gatherData = null;
    if (!!currentWindowGuid && !!window.parent.OpenWindowsObj)
        gatherData = window.parent.OpenWindowsObj[currentWindowGuid].gatherData;

    if (!!gatherData) {
        $.each(gatherData.keys, function (i, n) {
            var val = gatherData.vals[i];
            var isDynamicTableTitle = false;
            if ($.isArray(val)) //下拉元素，返回的是数组，里面是一个object{Text，Value}
            {
                if (val.length == 1) {
                    //样例： 2018-05-05(10:20) Y 1-
                    if (DynamicTableTitleTest(val[0]["Text"])) {
                        var _title = val[0]["Text"];
                        val = _title.replace(/\s{1}(Y|N)\s{1}/, val[0]["Value"] + " ");
                        isDynamicTableTitle = true;
                    }
                    else if (val[0]["Text"] === kongbiaotou) {
                        val = kongbiaotou;
                        isDynamicTableTitle = true;
                    }
                }
            }
            if (isDynamicTableTitle) {
                var tableTitle = val;
                if (tableTitle == kongbiaotou) {
                    //动态变更可变的标签
                    $("div[dynamic]").each(function (i) {
                        EmptyTitleHandle(this);
                    });
                    return false;
                }

                var _titles = tableTitle.split(" ");
                _titles.shift(); //跳过日期

                if (queryObject["IsDynamicTableTitle"].indexOf("true") > -1 && tableTitle != "") {

                    var filterParentTitleIndexs = queryObject["IsDynamicTableTitle"].split("^");
                    filterParentTitleIndexs.shift();
                    //过滤已经使用的父表头
                    _titles = $.grep(_titles, function (n, i) {
                        return $.inArray(n.split("-")[0], filterParentTitleIndexs) > -1;
                    }, true);

                    var DynamicTitleLoadDropInputs = [];
                    //动态变更可变的标签
                    $("div[dynamic]").each(function (i) {
                        var _title = _titles[i];
                        if (!!_title && _title.split("-").length > 1 && _title.split("-")[1] != "") {
                            $(this).text(_title.split("-")[1]);
                            //处理下拉系列，勾选了根据表头动态加载
                            var id = $(this).attr("id");
                            var dropInput = $("select[dhccLableFor='" + id + "']");
                            if (dropInput.length == 1)
                            {
                                if (dropInput.attr("DynamicTitleLoad") == "true") {
                                    DynamicTitleLoadDropInputs.push({ dropInputId: $(dropInput).attr("id"), dyTitle: _title.split("-")[1] });
                                }
                            }
                        } else {
                            EmptyTitleHandle(this);
                        }
                    });

                    var rtnData = GetTableEditDyTitleDependencyBatch(DynamicTitleLoadDropInputs);
                    $.each(rtnData, function (i, n) {
                        SetOneValue(i,n);
                    });

                }
                return false;
            }
        });
    }
}
/**
 * 初始化签名域控制
 * @method InitSignDomain
 **/
function InitSignDomain() {
    
    $("div[id^='ContainerElement_']").each(function (i) {
        var currentContainerEle = this;
        var signdomainctrl = $(currentContainerEle).attr("signdomainctrl");
        if (!!signdomainctrl) {
            var signEles = signdomainctrl.split(",");
            var signVals = "";
            $.each(signEles, function (i, signEleId) {
                if (ElementUtility["TextElement"].hasValueByName(signEleId))
                    signVals += window.CAOldFormData[signEleId];//只能取数据库里存储的值，从而避免签名自动带入，带来的问题
            });

            if (!!signVals) {
                if (signVals.indexOf(session['LOGON.USERCODE']) > 0)
                    return false;
                else {
                    var childInputElements = getInputElementsByContainer($(currentContainerEle).attr("id"));

                    $.each(childInputElements, function (i, ele) {
                        DisEnableOne(ele,true);
                    });
                }
            }
        }
    });
}
/**
 * 得到指定容器下的所有表单项
 * @method getInputElementsByContainer
 **/
function getInputElementsByContainer(Container) {
    var testReg = /^[a-zA-Z]{2,}_[0-9]{1,}$/; //命名规则是字母下划线数值三部分，//下拉单选，下拉多选会自动生成部分input，需要排除
    var tempInputFormNames = [];

    $.each(ElementUtility, function (key, helper) {
        if (helper.isForm()) {
            
            $("#" + Container + " input[name^='" + key + "_']").each(function (i) {
                var name = $(this).attr("name");
                if (tempInputFormNames.indexOf(name) == -1) {
                    if (testReg.test(name)) {
                        tempInputFormNames.push(name);
                    }
                }
            });
            $("#" + Container + " select[id^='" + key + "_']").each(function (i) {
                var name = $(this).attr("id");
                if (tempInputFormNames.indexOf(name) == -1) {
                    if (testReg.test(name)) {
                        tempInputFormNames.push(name);
                    }
                }
            });
            $("#" + Container + " textarea[name^='" + key + "_']").each(function (i) {
                var name = $(this).attr("name");
                if (tempInputFormNames.indexOf(name) == -1) {
                    if (testReg.test(name)) {
                        tempInputFormNames.push(name);
                    }
                }

            });
        }
    });

    return tempInputFormNames;
}


/**
 * 将普通的object转换成适合URL传递的参数格式
 * @method ObjectToUrlParams
 * @param { object } obj {keys:[],vals:[]}
 * @param { string } joinSymbol 连接符号，默认&
 * @return { string } "name=aa&id=2"
 **/
function ObjectToUrlParams(obj, joinSymbol) {
    if (!joinSymbol)
        joinSymbol = "&";

    if (typeof obj == "string")
        return "";

    var re = "";
    $.each(obj.keys, function (i, k) {
        var val = obj.vals[i];

        if ($.isArray(val)) //下拉元素，返回的是数组，里面是一个object{Text，Value}
        {
            if (val.length > 0) {
                //样例： 2018-05-05(10:20) Y 1-
                if (DynamicTableTitleTest(val[0]["Text"])) {
                    var _title = val[0]["Text"];
                    val = _title.replace(/\s{1}(Y|N)\s{1}/, val[0]["Value"] + " ");
                }
                else if (val[0]["Text"] === kongbiaotou) {
                    val = kongbiaotou;
                }
                else {
                    val = PickDropListValues(val).toString();
                }
            }
            else
                val = "";
        }

        re += k + "=" + val + joinSymbol;
    });

    if (re != "")
        re = re.substring(0, re.length - 1);

    return re;
}
/**
 * 将URL传递的参数格式转换成普通的object
 * @method UrlParamsToObject
 * @param { string } "name=aa&id=2"
 * @param { string } joinSymbol 连接符号，默认&
 * @return { object } obj {name:"aa",id:2}
 **/
function UrlParamsToObject(urlParams, joinSymbol) {
    if (!joinSymbol)
        joinSymbol = "&";
    var assignSymbol = "=";

    return StringObjectToObject(urlParams, joinSymbol, assignSymbol);
}
/**
 * 将字符串格式转换成普通的object
 * @method StringObjectToObject
 * @param { string } "name=aa&id=2"
 * @param { string } joinSymbol 连接符号
 * @param { string } assignSymbol 赋值符号
 * @return { object } obj {name:"aa",id:2}
 **/
function StringObjectToObject(targetString, joinSymbol, assignSymbol) {

    if (!joinSymbol || !assignSymbol) {
        $.messager.alert(" ", $g("StringObjectToObject()调用失败，参数不能为空"), "error");
        return null;
    }
    var obj = new Object();

    var strs = targetString.split(joinSymbol);
    for (var i = 0; i < strs.length; i++) {
        obj[strs[i].split(assignSymbol)[0]] = unescape(strs[i].split(assignSymbol)[1]);
    }

    return obj;
}
/**
 * 表单元素快速切换
 * @method ShortcutFormElementFocus
 **/
function ShortcutFormElementFocus() {
    $(window).keydown(function (e) {
        var nextFormElement = "";
        var preFormElement = "";

        var index = -1;
        var tempElements = window.LoadFormElements;
        if (!!window.HisuiEditors) {
            $.each(window.HisuiEditors, function (k, v) {
                if (v.editIndex != undefined) {
                    tempElements = v.editElements;
                    return false;
                }
            });
        }

        $.each(tempElements, function (i, n) {
            var helper = GetElementHelper(n);
            var type = GetElementStringType(n);
            if (!!window.HisuiEditors && (type == "CheckElement" || type == "RadioElement")) {
                helper = ElementUtility["DropListElement"];
            }
            if (helper.hasFocus(n)) {
                index = i;
                return false;
            }
        });
        if (index == -1) return;

        var preIndex = index;
        do {
            if (preIndex == 0) {
                preFormElement = "";
                break;
            }

            preFormElement = tempElements[--preIndex];
            var helper = GetElementHelper(preFormElement);
            var type = GetElementStringType(preFormElement);
            if (!!window.HisuiEditors && (type == "CheckElement" || type == "RadioElement")) {
                helper = ElementUtility["DropListElement"];
            }
            if (helper.isFocusEnable(preFormElement)) {
                break;
            }
        } while (preIndex > 0)

        var nextIndex = index;
        do {
            if (nextIndex == tempElements.length - 1) {
                nextFormElement = "";
                break;
            }

            nextFormElement = tempElements[++nextIndex];
            var helper = GetElementHelper(nextFormElement);
            var type = GetElementStringType(nextFormElement);
            if (!!window.HisuiEditors && (type == "CheckElement" || type == "RadioElement")) {
                helper = ElementUtility["DropListElement"];
            }
            if (helper.isFocusEnable(nextFormElement)) {
                break;
            }
        } while (nextIndex < tempElements.length)
        var currentElement = tempElements[index];
        var currentElementType = GetElementStringType(currentElement);
        if ((currentElementType == "DropCheckboxElement" || currentElementType == "DropListElement"
            || currentElementType == "DropRadioElement")
            && $("#" + tempElements[index]).combobox('panel').is(":visible"))
            return;
        if (currentElementType == "DateElement") {
            if ($("#" + tempElements[index]).comboq('panel')) {
                if ($("#" + tempElements[index]).comboq('panel').is(":visible")) {
                    return;
                }
            }
        }

        if (e.keyCode == 38) { //键盘方向上箭头
            if (preFormElement != "") {
                var helper = GetElementHelper(preFormElement);
                var helper2 = GetElementHelper(currentElement);
                helper2.validate(currentElement);
                helper.focus(preFormElement);
                console.log(preFormElement);
            }
        }
        /*
        else if (e.keyCode == 40) //键盘方向下箭头
        {
            if (nextFormElement != "") {
                var ElementType = GetElementStringType(nextFormElement);
                ElementUtility[ElementType].focus(nextFormElement);
                console.log(nextFormElement);
            }
        }
		*/
        if (e.keyCode == 13) //回车
        {
            if (GetElementStringType(tempElements[index]) == "TextareaElement")
                return;
            if (nextFormElement != "") {
                var helper = GetElementHelper(nextFormElement);
                var helper2 = GetElementHelper(currentElement);
                helper2.validate(currentElement);
                helper.focus(nextFormElement);
                if (window.EnterSelectNextVal === true)
                    $('#' + nextFormElement).select();
                console.log(nextFormElement);
            }
            return false;
        }
    });
}
/**
 * 提取下拉表单元素选中的值
 * @method PickDropListValues
 * @param { array } dataValues [{"Text":"java","Value":"20"},{"Text":"net","Value":"30"}]
 * @return { array } ["20","30"]
 **/
function PickDropListValues(dataValues) {
    var re = [];
    $.each(dataValues, function (index, value) {
        if (!!value.Value)
            re.push(value.Value);
    });

    return re;
}
/**
 * 提取下拉表单元素选中的数值值
 * @method PickDropListNumberValues
 * @param { array } dataValues [{"Text":"java","Value":"20"},{"Text":"net","Value":"30"}]
 * @return { array } ["20","30"]
 **/
function PickDropListNumberValues(dataValues) {
    var re = [];
    $.each(dataValues, function (index, value) {
        if (!!value.NumberValue)
            re.push(value.NumberValue);
        else if (!!value.Value)
            re.push(value.Value);
    });

    return re;
}
/**
 * 提取下拉表单元素选中的文本值
 * @method PickDropListTextValues
 * @param { array } dataValues [{"Text":"java","Value":"20"},{"Text":"net","Value":"30"}]
 * @return { array } ["20","30"]
 **/
function PickDropListTextValues(dataValues) {
    var re = [];
    $.each(dataValues, function (index, value) {
        if (!!value.Text)
            re.push(value.Text);
    });

    return re;
}
/**
 * 服务返回的消息是否成功
 * @method MsgIsOK
 * @param { object } msg 服务端返回的消息
 * @return { bool }
 **/
function MsgIsOK(msg) {
    return msg.status == "0"
}
/**
 * 医嘱导入回调
 * @method DoctorAdviceImportCallback
 * @param { array } 导入的记录
 * @param { array } 要处理的元素ID
 **/
function DoctorAdviceImportCallback(recs, targetElements, extendParams) {

    if (!recs)
        return;

    if (targetElements.length == 0 || recs.length == 0)
        return;

    var checkRule = true;
    var importRules = {};
    var testReg = /^edit/;
    $.each(targetElements, function (k, elementId) {
        var tableID = GetTableIdByIndentity(elementId);
        var field = GetTableFieldByIndentity(elementId);
        if (testReg.test(elementId) && IsTableCellEdit(tableID)) {
            var importrule = window.HisuiEditors[tableID].ImportRule[field + "_importrule"];
            var importtype = window.HisuiEditors[tableID].ImportRule[field + "_importtype"];
            var importmulti = window.HisuiEditors[tableID].ImportRule[field + "_importmulti"];
            if (!importrule || !importmulti || !importtype) {
                checkRule = false;
                return false;
            }
            importRules[field + "_importrule"] = importrule;
            importRules[field + "_importtype"] = importtype;
            importRules[field + "_importmulti"] = importmulti;
        }
        else {
            var _input = $("#" + elementId);
            var importrule = $(_input).attr("importrule");
            var importmulti = $(_input).attr("importmulti");
            var importtype = $(_input).attr("importtype");
            if (!importrule || !importmulti || !importtype) {
                checkRule = false;
                return false;
            }
            importRules[elementId + "_importrule"] = importrule;
            importRules[elementId + "_importmulti"] = importmulti;
            importRules[elementId + "_importtype"] = importtype;
        }
    });

    if (!checkRule) {
        $.messager.alert(" ", $g("请配置解析规制"), "info");
        return;
    }
    function GetNumber(item) {
        var text = item;
        var reFloat = /^[0-9]\d*\.\d*|0\.\d*[1-9]\d*$/;
        var reInt = /^[1-9]\d*|0$/;
        var re = reFloat.exec(item);
        if (!!re) {
            text = re[0]; //浮点数
        } else {
            var re2 = reInt.exec(item);
            if (!!re2) { //整数
                text = re2[0];
            } else { //范围 (300-230)ml (0.2-0.3)g       
                var reInt2 = /\((\d{1,}|(\d{1,}\.\d{1,}))-(\d{1,}|(\d{1,}\.\d{1,}))\)/;
                var re3 = reInt2.exec(item);
                if (!!re3) { //整数
                    text = re3[0];
                }
            }           
        }
        return text;
    }
    var isTableCellEdit = false;
    var tableID = null;
    $.each(targetElements, function (k, elementId) {
        tableID = GetTableIdByIndentity(elementId);
        var fieldKey = elementId;
        if (testReg.test(elementId) && IsTableCellEdit(tableID)) {
            fieldKey = GetTableFieldByIndentity(elementId);
            isTableCellEdit = true;
        }

        var importrule = importRules[fieldKey + "_importrule"];
        var importtype = importRules[fieldKey + "_importtype"];
        var importmulti = importRules[fieldKey + "_importmulti"];

        var _result = "";
        $.each(recs, function (k, rec) {
            $.each(importrule.split(","), function (k2, field) {
                var isKeyField = false;
                var testReg2 = /^\$/;
                isKeyField = testReg2.test(field);
                if (isKeyField) {
                    field = field.replace(/\$/g, "");
                    field = field.replace(/\!/g, "");
                    if (!!rec[field])
                        _result += rec[field];
                }
                else if (!isKeyField) {
                    _result += field;
                }
            });

            if (importmulti == "False")
                return false;
            else
                _result += "&";
        });
        if (_result != "" && importmulti == "True")
            _result = _result.substring(0, _result.length - 1);
        if (!!extendParams) {
            var itemArray = _result.split("&");
            if (importtype == "Text") {//项目
                if (extendParams.textHidePreUnderline == "true") {//子医嘱不显示下划线
                    $.each(itemArray, function (i, item) {
                        if (item.substr(0, 5) == "_____")
                            itemArray[i] = item.substr(5);
                    });
                }
                if (!!extendParams.textFilterNumberUnit) { //过滤指定单位
                    var reNumberUnit = /@.+|$/;
                    var filter = extendParams.textFilterNumberUnit.split(",");
                    $.each(itemArray, function (i, item) {
                        var re = reNumberUnit.exec(item);
                        if (!!re) {
                            itemArray[i] = item.replace(re[0], "");
                            var temp = re[0];
                            temp = temp.substring(1, temp.length - 1); //去掉开头的@和结尾的|,必须数或者(
							var isExist = false;
                            for (var j = 0; j < filter.length; j++) {
                                var reUnit = new RegExp("[0-9)]" + filter[j] + "$");
                                if (reUnit.test(temp)) {
                                    isExist = true;
                                    break;
                                }
                            }
							if(!isExist)
							{
								itemArray[i] += temp;
							}

                        }
                    });
                }
            }
            else {//量
                if (!!extendParams.numberImportSpecialUnit) {//只导入指定单位的量
                    var filter = extendParams.numberImportSpecialUnit.split(",");
                    itemArray = $.map(itemArray, function (item) {
                        var isExist = false;
                        $.each(filter, function (k, f) {
                            var re = new RegExp("[0-9)]"+f + "$");//必须数或者(
                            if (re.test(item)) {
                                isExist = true;
                                return false;
                            }
                        });
                        if (isExist)
                            return item;
                        else
                            return "";
                    });
                }
                if (extendParams.numberUnitCombine == "true") {//单位一致合并
                    var reFloat = /^[0-9]\d*\.\d*|0\.\d*[1-9]\d*$/;
                    var reInt = /^[1-9]\d*|0$/;
                    var numTotal = {};
                    $.each(itemArray, function (i, item) {                      
                        var re = reFloat.exec(item);
                        if (!!re) {
                            var unit = item.replace(re[0], "");
                            if (!!numTotal[unit])
                                numTotal[unit] += +re[0];
                            else
                                numTotal[unit] = +re[0];
                        }
                        else {
                            re = null;
                            re = reInt.exec(item);
                            if (!!re) {
                                var unit = item.replace(re[0], "");
                                if (!!numTotal[unit])
                                    numTotal[unit] += +re[0];
                                else
                                    numTotal[unit] = +re[0];
                            }
                        }
                    });
                    itemArray = [];
                    $.each(numTotal, function (k, v) {
                        itemArray.push(v + "" + k);
                    });
                }
                if (extendParams.numberUnitNoImport == "true") {//单位不导入                  
                    $.each(itemArray, function (i, item) {
                        itemArray[i] = GetNumber(item);                       
                    });
                }
            }

            if (!!extendParams.mutilJoinSymbol)//多条记录连接符
            {
               // _result = itemArray.join(extendParams.mutilJoinSymbol);
                _result = "";
                var tmpArr = [];
                for (var j = 0; j < itemArray.length; j++) {                   
                    if (itemArray[j]!="") {                   
                        tmpArr.push(itemArray[j]);
                    }
                }
                _result = tmpArr.join(extendParams.mutilJoinSymbol);
            }
            else
                _result = itemArray.join("&");
        }

        SetOneValue(elementId, _result);
    });
    if (isTableCellEdit && window.HisuiEditors[tableID].editIndex !== undefined) {
        OnHisuiEditEnd(tableID);
        //$("#" + tableID).datagrid('refreshRow', window.HisuiEditors[tableID].editIndex);
    }
    else {
        if (targetElements.length > 0) {
            var firstFormElement = targetElements[0];
            var ElementType = GetElementStringType(firstFormElement);
            ElementUtility[ElementType].focus(firstFormElement);
        }
    }

}
/**
 * 数据表格加载
 * @method      
 * @param { string } 要加载的表格HtmlId
 **/
function DBTableLoadData(tableHtmlId, pageNumber) {
    if (window.FoundationDataReady === undefined)
        return;
    var queryInfo = "";
    var patt1 = new RegExp(tableHtmlId);

    var queryFields = [];

    if (!pageNumber)
        pageNumber = GetDBTablePageNumber(tableHtmlId);

    $("input[querybanding],select[querybanding]").each(function () {

        if (patt1.test($(this).attr("querybanding"))) {
            var formName = $(this).attr("id");
            queryFields.push(formName);
        }
    });

    var tableQueryDatas = GatherTemplateSpecifyFiledsData(queryFields);
    if (IsHisUIDataTable(tableHtmlId))
    {
        var opts = $('#' + tableHtmlId).datagrid('options');
        if (!!opts.gatherParams) {
            var mapObj = {};
            var gatherQueryFields = $.map(opts.gatherParams.split(','), function (n) {
                if (n.indexOf('^') > -1) {
                    var eleId = n.split('^')[0];
                    var map = n.split('^')[1];
                    mapObj[eleId] = map;
                    return eleId;
                }
                else
                    return n;
            });

            var gatherQueryDatas = GatherTemplateSpecifyFiledsData(gatherQueryFields);
            for (var i = 0; i < gatherQueryDatas.keys.length; i++) {
                var gatherParam = gatherQueryDatas.keys[i];
                if (tableQueryDatas.keys.indexOf(gatherParam) == -1){
                    if (!!mapObj[gatherParam])        
                        tableQueryDatas.keys.push(mapObj[gatherParam]);
                    else
                        tableQueryDatas.keys.push(gatherParam);
                    tableQueryDatas.vals.push(gatherQueryDatas.vals[i]);
                }
            }
        }
    }

    queryInfo = ObjectToUrlParams(tableQueryDatas, "^");
    $("#" + tableHtmlId).attr("queryInfo", queryInfo);
    GetDataFromService(null, [tableHtmlId], GetDBTablePageInfo(tableHtmlId, pageNumber), queryInfo);
}
/**
 * 数据表格第一次加载
 * @method      
 * @param { string } 要加载的表格HtmlId
 * @param { bool } ture:加载最新页面的数据 false:加载第一页的数据
 **/
function DBTableFirstLoadData(tableHtmlId, showLastPage) {
    if (showLastPage) {
        var queryInfo = "";
        var queryFields = [];
        var total = 0;
        var pageSize = null;
        var patt1 = new RegExp(tableHtmlId);

        $("input[querybanding],select[querybanding]").each(function () {

            if (patt1.test($(this).attr("querybanding"))) {
                var formName = $(this).attr("id");
                queryFields.push(formName);
            }
        });

        queryInfo = ObjectToUrlParams(GatherTemplateSpecifyFiledsData(queryFields), "^");

        var msg = tkMakeServerCall("NurMp.Template.EventSet", "FindRecordCounts", window.TemplateGUID, window.EpisodeID, queryInfo, tableHtmlId);
        var reMsg = JSON.parse(msg);
        if (MsgIsOK(reMsg)) {
            total = +(reMsg.data);
        }
        var sortOrder = "asc";
        if (IsRowToColDataTable(tableHtmlId))//行转列表格
        {
            if ($("#" + tableHtmlId + "Pager").length > 0)
                pageSize = $("#" + tableHtmlId + "Pager").pagination('options').pageSize;

            var BasicInfo = $("#" + tableHtmlId).attr("BasicInfo");
            BasicInfo = BasicInfo.replace(/'/g, '"');
            var json = jQuery.parseJSON(BasicInfo);
            sortOrder = json.SortOrder;
        }
        else {
            if ($("#" + tableHtmlId).datagrid('getPager').length > 0)
                pageSize = $("#" + tableHtmlId).datagrid('getPager').pagination('options').pageSize;
            sortOrder = $('#' + tableHtmlId).datagrid('options').sortOrder;
        }
        if (total == 0 || pageSize == null)
            DBTableLoadData(tableHtmlId,1);
        else if (!!pageSize && total > 0 && sortOrder === "asc")
            DBTableLoadData(tableHtmlId, Math.ceil(total / pageSize));
        else
            DBTableLoadData(tableHtmlId,1);
    }
    else {
        DBTableLoadData(tableHtmlId);
    }
}
/**
 * 判断是否是系统生成的元素HtmlId
 * @method IsSysElement
 * @param { string } 要判断的htmlId
 **/
function IsSysElement(htmlId) {
    var testReg = /^[a-zA-Z]{2,}_[0-9]{1,}$/;
    if (!testReg.test(htmlId))
        return false;
    var IsFind = false;
    $.each(ElementUtility, function (k, v) {
        if (GetElementStringType(htmlId) == k) {
            IsFind = true;
            return false;
        }
    });

    return IsFind;
}
/**
 * 浏览器窗口关闭事件代理，用来处理在关闭时需要回传一些值场景（例如：医嘱导入，首次评估单内部链接）
 * @method dan
 * @param { val } 要回传的值
 **/
function WindowBeforeCloseProxy(val, isCloseWindow) {
    if (!!window.parent)
        window.parent.ModalDialogReturn = val;

    if (isCloseWindow) {
        if (!!window.parent)
            window.setTimeout(window.parent.CloseCommonModalDialog, 500);
    }
}
/**
 * 获取以结果返回的值
 * @method GetResultReturn
 * @return { obj } {keys:[],vals:[]} 以formName/value格式返回
 **/
function GetResultReturn() {

    var returnFields = [];
    $("input[resultreturn],select[resultreturn],textarea[resultreturn]").each(function () {
        var formName = $(this).attr("id");
        returnFields.push(formName);
    });

    return GatherTemplateSpecifyFiledsData(returnFields);
}
/**
 * 获取表格当前显示的分页信息
 * @method GetDBTablePageInfo
 * @param { tableHtmlId } tableHtmlId 指定的表格
 * @return { string }  'PageStart=1&PageEnd=10
 **/
function GetDBTablePageInfo(tableHtmlId, pageNumber) {

    var PageStart = 0;
    var PageEnd = 0;
    var pageSize = 3;

    if (IsRowToColDataTable(tableHtmlId))//行转列表格
    {
        if ($("#" + tableHtmlId + "Pager").length > 0)
            pageSize = $("#" + tableHtmlId + "Pager").pagination('options').pageSize;
        else
            return null;
    }
    else {
        if ($("#" + tableHtmlId).datagrid('getPager').length > 0)
            pageSize = $("#" + tableHtmlId).datagrid('getPager').pagination('options').pageSize;
        else
            return null;
    }

    PageStart = (pageNumber - 1) * pageSize + 1;
    PageEnd = pageNumber * pageSize;
    $("#" + tableHtmlId).data("nurPageNumber", pageNumber);
    $("#" + tableHtmlId).data("nurPageSize", pageSize);
    return 'PageStart=' + PageStart + '&PageEnd=' + PageEnd;
}
/**
 * 获取表格当前显示的页码
 * @method GetDBTablePageNumber
 * @param { tableHtmlId } tableHtmlId 指定的表格
 * @return { int }  页码
 **/
function GetDBTablePageNumber(tableHtmlId) {

    var currentPageNumber = 1;
    if (IsRowToColDataTable(tableHtmlId))//行转列表格
    {
        if ($("#" + tableHtmlId + "Pager").length > 0)
            currentPageNumber = $("#" + tableHtmlId + "Pager").pagination('options').pageNumber;
    }
    else {
        if ($("#" + tableHtmlId).datagrid('getPager').length > 0)
            currentPageNumber = $("#" + tableHtmlId).datagrid('getPager').pagination('options').pageNumber;
    }
    return currentPageNumber;
}
/**根据全局的JS变量，查找指定的数据，级联
 * 根据下拉的当前值，获取级联需要跟新的元素信息
 * @method GetDataSource
 * @param { sourceElementID } 发生改变的元素
 * @param { dataSource } 级联的js数据对象
 * @param { val } 当前选中元素的值，AbstractElement类调用getValueById，getValueByName获取的值可能不是一个简单的文本值，下拉，下拉单选，下拉多选是一个对象，
@return { obj }
 **/
function GetDataSource(sourceElementID, dataSource, val, onlySatisfy) {
    var datas = [];
    var helper = GetElementHelper(sourceElementID);
    for (var i = 0; i < dataSource.length; i++) {
        var simpleValArry = dataSource[i].Value.split(",");
        if (dataSource[i].hasOwnProperty("Value2")) {
            simpleValArry.push(dataSource[i].Value2);
        }
        var ConditionSign = dataSource[i].ConditionSign;
        if (helper.CheckIsTrue(val, dataSource[i].Sign, simpleValArry)) {
            var isOK = true;
            if (ConditionSign == "And") {
                var AppendConditions = dataSource[i].AppendConditions;
                if (AppendConditions) {
                    isOK = eval(AppendConditions);
                }
            }
            if (isOK) {
                datas.push(dataSource[i]);
                if (onlySatisfy) { break; }
            }
        }
        else {
            if (ConditionSign == "Or") {
                var isOK = false;
                var AppendConditions = dataSource[i].AppendConditions;
                if (AppendConditions) {
                    isOK = eval(AppendConditions);
                }
                if (isOK) {
                    datas.push(dataSource[i]);
                    if (onlySatisfy) { break; }
                }
            }
        }
    }
    return datas;
}
/**级联需要跟新的元素信息 ，更新UI
 * @method ChangeData
 * @param { data } 获取级联需要跟新的元素信息
 *@param { currentvalue } 当前选中元素的值，AbstractElement类调用getValueById，getValueByName获取的值可能不是一个简单的文本值，下拉，下拉单选，下拉多选是一个对象，
 **/
function ChangeData(data, currentvalue, sourceId) {
    if (data) {
        if (data.Childs) {
            var childs = data.Childs;

            for (var i = 0; i < childs.length; i++) {
                var oneEle = childs[i];
                var id = oneEle.ID;
                //SetOneRequired内部实现存在问题，会导致如果存在Data，会不起作用，必须放在最前边
                if (oneEle.hasOwnProperty("Verify")) { //存在验证
                    var Verifyobj = oneEle.Verify;
                    if (Verifyobj.hasOwnProperty("Required")) { //必填
                        var isRequired = Verifyobj.Required;
                        SetOneRequired(id, isRequired);
                    }
                }
                if (oneEle.hasOwnProperty("Data")) {
                    if (oneEle.hasOwnProperty("HadDataNoAction") && oneEle.HadDataNoAction) {
                        if (!HasValueByName(id))
                            SetOneValue(id, oneEle.Data);
                    }
                    else
                        SetOneValue(id, oneEle.Data);
                }
                if (oneEle.hasOwnProperty("Fun")) {
                    if (oneEle.hasOwnProperty("HadDataNoAction") && oneEle.HadDataNoAction) {
                        if (!HasValueByName(id)) {
                            var testdata = window[oneEle.Fun].call(this, id, currentvalue, sourceId);
                            if (testdata != undefined)
                                SetOneValue(id, testdata);
                        }
                    }
                    else {
                        var testdata = window[oneEle.Fun].call(this, id, currentvalue, sourceId);
                        if (testdata != undefined)
                            SetOneValue(id, testdata);
                    }
                }
                if (oneEle.hasOwnProperty("IsHide")) {
                    var currentElementType = GetElementStringType(id);
                    if (currentElementType == "CheckElement" || currentElementType == "RadioElement") {
                        $("input[name=" + id + "]").each(function (i) {
                            HideOne($(this).attr("id"), oneEle.IsHide);
                        });
                    }
                    else {
                        HideOne(id, oneEle.IsHide);
                        if (currentElementType == "HISUIDataTableElement" && !oneEle.IsHide) {
                            DBTableFirstLoadData(id, false);
                        }
                    }
                }
                if (oneEle.hasOwnProperty("Disable")) {
                    var currentElementType = GetElementStringType(id);
                    if (currentElementType == "CheckElement" || currentElementType == "RadioElement") {
                        $("input[name=" + id + "]").each(function (i) {
                            DisEnableOne($(this).attr("id"), oneEle.Disable);
                        });
                    }
                    else
                        DisEnableOne(id, oneEle.Disable);

                }

            }
        }
    }
}
/**撤销上一步的修改 ，更新UI
 * @method UnDoChangeData
 * @param { data } 获取级联需要跟新的元素信息
 **/
function UnDoChangeData(data, currentvalue) {
    if (data) {
        if (data.Childs) {
            var childs = data.Childs;

            for (var i = 0; i < childs.length; i++) {
                var oneEle = childs[i];
                var id = oneEle.ID;
                //SetOneRequired内部实现存在问题，会导致如果存在Data，会不起作用，必须放在最前边
                if (oneEle.hasOwnProperty("Verify")) { //存在验证
                    var Verifyobj = oneEle.Verify;
                    if (Verifyobj.hasOwnProperty("Required")) { //必填
                        var isRequired = Verifyobj.Required;
                        SetOneRequired(id, !isRequired);
                    }
                }

                if (oneEle.hasOwnProperty("Data")) {
                    UnDoLastActionData(id, oneEle.Data)
                }
                if (oneEle.hasOwnProperty("Fun")) {
                    var testdata = window[oneEle.Fun].call(this, id, currentvalue);
                    if (testdata != undefined)
                        UnDoLastActionData(id, testdata);
                }
                if (oneEle.hasOwnProperty("IsHide")) {
                    var currentElementType = GetElementStringType(id);
                    if (currentElementType == "CheckElement" || currentElementType == "RadioElement") {
                        $("input[name=" + id + "]").each(function (i) {
                            HideOne($(this).attr("id"), !oneEle.IsHide);
                        });
                    }
                    else
                        HideOne(id, !oneEle.IsHide);

                }
                if (oneEle.hasOwnProperty("Disable")) {
                    var currentElementType = GetElementStringType(id);
                    if (currentElementType == "CheckElement" || currentElementType == "RadioElement") {
                        $("input[name=" + id + "]").each(function (i) {
                            DisEnableOne($(this).attr("id"), !oneEle.Disable);
                        });
                    }
                    else
                        DisEnableOne(id, !oneEle.Disable);

                }
            }
        }
    }
}
function UnDoLastAction(id, dataSouce, currentvalue) {
    var helper = GetElementHelper(id);
    if (helper != undefined)
        helper.UnDoLastAction(id, dataSouce, currentvalue);
}
function UnDoLastActionData(id, data) {
    var helper = GetElementHelper(id);
    if (helper != undefined)
        helper.UnDoLastActionData(id, data);
}
/**
 * 约束只能输入数字
 * @method RestrictNumerical
 * @param { object } input对象
 **/
function RestrictNumerical(sender) {
    if ($(sender).val() != "")
        $(sender).val($(sender).val().replace(/[\u4e00-\u9fa5]/g, ''));
}
/**
 * CA登录验证框（异步）
 * @method CALoginASync
 * @param { forceOpen } 0,1  
 * @param { callBack }  
**/
function CALoginASync(userCode, forceOpen, callBack, inputId) {

    var innerCallBack = function (rtn) {
        if (!rtn.IsSucc) {
            window.CAVarCert = "";
            window.CAContainerName = "";
            window.CAUserCertCode = "";
            alert("证书未登录,请重新登录证书!");
            return;
        }
        else {
	        if (!!rtn.ca_key) {
		        var varCertCode = rtn.ca_key.GetUniqueID(rtn.varCert,rtn.ContainerName);
	        } else {
            	var varCertCode = GetUniqueID(rtn.varCert,rtn.ContainerName);
	        }
            var currentUserCode = tkMakeServerCall("NurMp.CA.DHCNurSignVerify", "GetUsrCodeByKey", varCertCode);
            if (!!currentUserCode && currentUserCode.toLowerCase() != userCode.toLowerCase()) {//当uk绑定的工号和签名框里输入的工号不一致时。
                window.CAVarCert = "";
                window.CAContainerName = "";
                window.CAUserCertCode = "";
                alert("证书未登录,请重新登录证书!");
                return;
            }
            window.CAVarCert = rtn.varCert;
            window.CAContainerName = rtn.ContainerName;
            if (!!rtn.CAUserCertCode) {
                window.CAUserCertCode = rtn.CAUserCertCode;
            } else {
                window.CAUserCertCode = varCertCode;
            }
            window.CARtn = rtn;
            var testReg = /^edit/;
            var tidentity = inputId;
            var tTableEditRowIndex = undefined;
            if (testReg.test(tidentity)) {//表示表格可编辑行录入
                var tableID = GetTableIdByIndentity(tidentity);
                tidentity = GetTableFieldByIndentity(tidentity);
                var trowIndex = window.HisuiEditors[tableID].editIndex;

                //if编辑行有流水号，用【tableid+流水号】表示
                //elseif编辑行有临时流水号，用【tableid+临时流水号】表示
                //else就给这行新建一个临时的流水号（guid），用【tableid+guid】表示
                var rowDatas = $('#' + tableID).datagrid("getRows");
                if (!!rowDatas[trowIndex]["ID"])
                    tTableEditRowIndex = tableID + rowDatas[trowIndex]["ID"];
                else if (!!rowDatas[trowIndex]["newTempID"])
                    tTableEditRowIndex = tableID + rowDatas[trowIndex]["newTempID"];
                else {
                    rowDatas[trowIndex]["newTempID"] = newGuid();
                    tTableEditRowIndex = tableID + rowDatas[trowIndex]["newTempID"];
                }
            }
            var tempSignedInfo = { userID: userCode, certCode: window.CAUserCertCode, certNo: GetCertNo(window.CAContainerName), inputId: tidentity, rowIdentity: tTableEditRowIndex };
            if (window.CASignedInfos === undefined) window.CASignedInfos = [];
            var isExist = false;
            $.each(window.CASignedInfos, function (i, SignedInfo) {
                if (isObjEqual(SignedInfo, tempSignedInfo)) {
                    isExist = true;
                    return false;
                }
            });
            if (!isExist) {
                window.CASignedInfos.push(tempSignedInfo);
            }
        }
        if (!!callBack)
            callBack();
    }

    if (IsIE()) {
        if (window.CAIntegration != undefined && window.CAIntegration === 1)
            dhcsys_getcacert({ modelCode: "NurMp", callback: innerCallBack, SignUserCode: userCode }, undefined, undefined, undefined);
        else {
            var re = dhcsys_getcacert(innerCallBack, undefined, undefined, forceOpen);
            innerCallBack(re);
        }
    }
    else {//chrome
        if (window.CAIntegration != undefined && window.CAIntegration === 1)
            dhcsys_getcacert({ modelCode: "NurMp", callback: innerCallBack, SignUserCode: userCode }, undefined, undefined, undefined);
        else
            dhcsys_getcacert({ callback: innerCallBack, SignUserCode: userCode, isHeaderMenuOpen: false }, undefined, undefined, forceOpen);
    }
}
/**
 * 输入工号回车代入姓名
 * @method JobNumEnterToName
 * @param { object } input对象
**/
function JobNumEnterToName(sender, auto) {
    var isDestroy = false;
    var identity = "";
    if ($(sender).length == 0) {
        identity = sender.selector.replace("#", "");
        isDestroy = true;
        CreateTempSignTextBox(identity);
        sender = $("#" + identity);
    }

    var CARepeatLoginAsync = function (forceOpen) {
        //重新用UK进行登录验证
        var tidentity = $(sender).attr("id");
        CALoginASync(userCode, forceOpen, SignAjax, tidentity);
    }
    var ClearTempSign = function (SignatureFull) {
        if (!!SignatureFull && !!$(sender).attr("tempSignature")) {
            var _SignArray2 = SignatureFull.split("|");
            if (_SignArray2.length >= 1 && _SignArray2[_SignArray2.length - 1] == $(sender).attr("tempSignature"))
                _SignArray2.pop();
            
            SignatureFull = _SignArray2.join("|");
        }
        return SignatureFull;
    }
    var url = WebIp + "/csp/dhcnurmpgetdata.csp?ClassName=NurMp.Sources.Comm&MethodName=getUserName";
    url = GetMWToken(url);
    var SignAjax = function () {
        $.ajax({
            type: "POST",
            url: url,
            data: { datapost: JSON.stringify(dataPost) },
            async: false,
            success: function (msg) {

                var reMsg = JSON.parse(msg);
                if (!MsgIsOK(reMsg)) {
                    $.messager.alert(" ", $g(reMsg.msg, "info"));
                    return;
                }
                var Signature = reMsg.data + "*" + userCode;
                if ($(sender).attr("Signature") == "Common" || $(sender).attr("Signature") == "CommonNOReplace") {
                    $(sender).attr("SignatureFullVal", Signature);
                }
                else if ($(sender).attr("Signature") == "Repeat" || $(sender).attr("Signature") == "Double") {
                    var SignatureFull = $(sender).attr("SignatureFullVal");
                    SignatureFull = ClearTempSign(SignatureFull);
                    if (!!SignatureFull) {
                        if (SignatureFull.indexOf(Signature) == -1) {
                            if ($(sender).attr("Signature") == "Double" && SignatureFull.match(/\*/g).length == 2) {
                                var _SignArray = SignatureFull.split("|");
                                SignatureFull = _SignArray[0] + "|" + Signature;
                            }
                            else {
                                SignatureFull = SignatureFull + "|" + Signature;
                            }
                            $(sender).attr("SignatureFullVal", SignatureFull);
                        }
                    }
                    else
                        $(sender).attr("SignatureFullVal", Signature);
                }
                else if ($(sender).attr("Signature") == "Free") {
                    var SignatureFull = $(sender).attr("SignatureFullVal")
                    SignatureFull = ClearTempSign(SignatureFull);
                    if (!!SignatureFull) {
                        SignatureFull = SignatureFull + "|" + Signature;
                        $(sender).attr("SignatureFullVal", SignatureFull);
                    }
                    else
                        $(sender).attr("SignatureFullVal", Signature);
                }
                $(sender).attr("tempSignature", Signature);
                SetOneValue($(sender).attr("id"), "CA" + $(sender).attr("SignatureFullVal"));
                if (isDestroy)
                    DestroyTempSignTextBox(identity);
            }
        });
    }
    var dataPost = {};
    var userCode = $(sender).val();
    if (!auto && !!userCode) {
        //if (userCode.toLowerCase() != session['LOGON.USERCODE'].toLowerCase())
        //{
        //    alert("必须用当前登录的账户进行签名");
        //    return;
        //}
        dataPost["userCode"] = userCode;
    }
    else {
        if ($(sender).attr("Signature") == "CommonNOReplace" && !!$(sender).attr("SignatureFullVal") && auto)
            return false;
        userCode = session['LOGON.USERCODE'];
        dataPost["userCode"] = session['LOGON.USERCODE'];
    }
    dataPost["hospitalID"] = session['LOGON.HOSPID'];
    dataPost["locID"] = session['LOGON.CTLOCID'];

    window.CAVarCert = null;
    window.CAContainerName = null;
    window.CAUserCertCode = null;
    if (window.CAVerify > 0) {
        var forceOpen = 0;//默认0，表示没有登录过则弹出，登录过则不弹出。 1强制弹出签名窗口
        if (session['LOGON.USERCODE'] != userCode)
            forceOpen = 1;
        //是否开启强制验证
        if (window.CAStrict != undefined && window.CAStrict) {
            forceOpen = 1;
        }
        CARepeatLoginAsync(forceOpen);
    }
    else if (window.SignPWDVerify != undefined && window.SignPWDVerify) {
        if ($("#signPWDVerifyDialog").length == 0)
            $("body").append(document.getElementById('SignPWDVerifyDialogTemplate').innerHTML);
        $("#signPWDVerifyDialog").dialog({
            width: 300,
            height: 129,
            modal: true,
            closed: true,
            title: $g("密码验证"),
            buttons: [{
                text: $g('确认'),
                handler: function () {
                    if (window.SignPWDClassFunc == undefined || !window.SignPWDClassFunc) {
                        $.messager.alert(" ", $g("请配置签名密码验证的类方法", "info"));
                        return;
                    }
                    var className = window.SignPWDClassFunc.split("*")[0];
                    var funName = window.SignPWDClassFunc.split("*")[1];

                    try {
                        var re = tkMakeServerCall(className, funName, userCode, $('#signPWD').val());

                        if (re == "0") {
                            $.messager.alert(" ", $g("密码错误", "info", function () {
                                $HUI.dialog('#signPWDVerifyDialog').close();
                            }));
                            return;
                        }
                        else {
                            $HUI.dialog('#signPWDVerifyDialog').close();
                            SignAjax();
                        }
                    }
                    catch (e) {
                        $.messager.alert(" ", $g("密码验证失败", "error", function () {
                            $HUI.dialog('#signPWDVerifyDialog').close();
                        }));
                        return;
                    }
                }
            }, {
                text: $g('取消'),
                handler: function () {
                    $HUI.dialog('#signPWDVerifyDialog').close();
                }
            }],
            onOpen: function () {
                $('#signPWD').focus();
                $('#signPWD').val("");
                $('#signPWD').unbind().bind('keydown', function (e) {
                    if (e.keyCode == 13) {
                        if (window.SignPWDClassFunc == undefined || !window.SignPWDClassFunc) {
                            $.messager.alert(" ", $g("请配置签名密码验证的类方法", "info"));
                            return;
                        }
                        var className = window.SignPWDClassFunc.split("*")[0];
                        var funName = window.SignPWDClassFunc.split("*")[1];

                        try {
                            var re = tkMakeServerCall(className, funName, userCode, $('#signPWD').val());

                            if (re == "0") {
                                $.messager.alert(" ", $g("密码错误", "info", function () {
                                    $HUI.dialog('#signPWDVerifyDialog').close();
                                }));
                                return;
                            }
                            else {
                                $HUI.dialog('#signPWDVerifyDialog').close();
                                SignAjax();
                            }
                        }
                        catch (e) {
                            $.messager.alert(" ", $g("密码验证失败", "error", function () {
                                $HUI.dialog('#signPWDVerifyDialog').close();
                            }));
                            return;
                        }
                    }
                });
            }
        });
        if (JudgeIfUserExist(userCode) == '1') {
            $("#signPWDVerifyDialog").dialog('open');
        } else {
            $.messager.popover({ msg: '用户不存在！', type: 'error', timeout: 1000 });
            return;
        }
    }
    else {
        SignAjax();
    }

}
function CreateTempSignTextBox(identity) {
    var cellData = GetTableCellData(identity);
    var tableId = GetTableIdByIndentity(identity);
    var field = GetTableFieldByIndentity(identity);
    var op = $("#" + tableId).datagrid("getColumnOption", field);
    var l = $.data($("#" + tableId)[0], "datagrid").options;
    var r = l.editors["validatebox"];
    var editor = !!op.editor ? op.editor : op.editor1;
    r.init("body", editor.options);
    HideOne(identity, true);
    r.setValue($("#" + identity), cellData);
}
function DestroyTempSignTextBox(identity) {
    var tableId = GetTableIdByIndentity(identity);
    var field = GetTableFieldByIndentity(identity);
    var op = $("#" + tableId).datagrid("getColumnOption", field);
    var l = $.data($("#" + tableId)[0], "datagrid").options;
    var r = l.editors["validatebox"];
    r.destroy($("#" + identity));
    $("#div_" + identity).remove();
}
/**
 * 清空签名框
 * @method ClearSign
 * @param { object } input对象
**/
function ClearSign(sender) {
    if ($(sender).attr("Signature") == "Patient") {
        $("img[id^='" + $(sender).attr("id") + "']").remove();
        $(sender).attr("PatientSignVal", "");
        $(sender).removeData("casign");
    }
    else {
        window.CAVarCert = null;
        window.CAContainerName = null;
        window.CAUserCertCode = null;
        var userCode = $(sender).val();
        if (!!userCode) {
            var signs = $(sender).attr("SignatureFullVal").split("|");
            var i = signs.length;
            while (i--) {
                var v = signs[i];
                if (v.split("*")[1] == userCode)
                    signs.splice(i, 1);
            }

            $(sender).attr("SignatureFullVal", signs.join("|"));
        }
        else {
            $(sender).attr("SignatureFullVal", "");
        }

        if ($(sender).attr("SignatureFullVal") == "") {
            SetOneValue($(sender).attr("id"), "");
            $("img[id^='" + $(sender).attr("id") + "']").remove();
        }
        else
            SetOneValue($(sender).attr("id"), "CA" + $(sender).attr("SignatureFullVal"));
    }
}
/**
 * 返回显示签名
 * @method DisplayCA
 * @param { string } SignatureFull 不带CA前缀的签名字符串 格式例如（护士01*hs01|护士02*hs02）
**/
function DisplayCA(SignatureFull, ItemsSplitString, ShowOrder) {

    var Signatures = SignatureFull.split("|");
    var SignatureDisplay = [];
    if (!ItemsSplitString)
        ItemsSplitString = ",";
    $.each(Signatures, function (i, n) {
        SignatureDisplay.push(n.split("*")[0]);
    });
    if (Signatures.length > 0){
        if (ShowOrder == "LIFO")
            SignatureDisplay = SignatureDisplay.reverse();
        return SignatureDisplay.join(ItemsSplitString);
    }
    else
        return "";
}

/**
 * 判读数据格式是否是签名格式
 * @method IsCA
 * @param { string } data 签名数据
**/
function IsCA(data) {

    if (!data)
        return false;

    var testReg = /^CA/;
    if (testReg.test(data) && data.indexOf("*") > 0) {
        return true;
    }
    else
        return false;
}

/**
 * 判断数据格式是否是患者签名格式
 * @method IsPatientCA
 * @param { string } data 签名数据
**/
function IsPatientCA(data) {

    if (!data)
        return false;

    var testReg = /^PatientCA@[1-9]\d*$/;
    if (testReg.test(data)) {
        return true;
    }
    else
        return false;
}

/**
 * 打印插件检查升级
 * @method PrintActivexUpgrade 
**/
function PrintActivexUpgrade() {

    if ("undefined" == typeof EnableLocalWeb || 0 == EnableLocalWeb || "undefined" == typeof NurEmrPrint) {
  
        if (window.PrintXAutoUpdate === undefined || window.PrintXAutoUpdate === false)
            return;
        console.time("activexUpgrade");
        var hisURI = WebIp;
        try {
            var obj = document.PrintActiveX;
            if (typeof (obj) == "undefined") {
                // $.messager.alert(" ", $g("PrintActiveX未定义"), "error");
                console.error("PrintActiveX未定义");
                return;
            }
            var msg = obj.CheckUpgrade(hisURI);

            if (msg != "ok") {
                var reMsg = JSON.parse(msg);
                if (MsgIsOK(reMsg))//升级成功
                {
                    $.messager.alert(" ", $g("打印插件升级成功，请关闭浏览器，重新打开。"), "success");
                }
                else if (reMsg.status == "-1") {//升级失败
                    $.messager.alert(" ", reMsg.msg, "error");
                }
            }

        } catch (ex) {
            $.messager.alert(" ", $g("打印插件CheckUpgrade无法使用。请确认重启了浏览器！") + ex.Description, "error");
        }
        console.timeEnd("activexUpgrade");
    }

}

/**
 * 打开一个模态对话框
 * @param { string } title 标题
 * @param { string } url  要打开的url
 * @param { object } windowsInfo 窗口属性（高度，宽度）
 * @method OpenCommonModalDialog 
**/
function OpenCommonModalDialog(title, url, windowsInfo, callbackFun, callbackFunParams) {
    var left = null;
    var top = null;

    var dialogHtml = "<div class='commonModalDialog'><iframe id='dialogFrame' src=''></iframe></div>";

    if (!windowsInfo) {
        windowsInfo = { width: 500, height: 500 };
    }
    else {
        left = windowsInfo.left;
        top = windowsInfo.top;
        if (!!left && !!top)
            dialogHtml = "<div style='left:" + left + "px;top:" + top + "px' class='commonModalDialog'><iframe id='dialogFrame' src=''></iframe></div>";
    }

    //重新计算弹出窗口的尺寸以自适应 yjn
    var winWidth = windowsInfo.width;
    var winHeight = windowsInfo.height;
    var docWidth = $(this).width();
    var docHeight = $(this).height();
    if (winWidth > docWidth) {
        winWidth = docWidth - 10;
    }
    if (winHeight > docHeight) {
        winHeight = docHeight - 10;
    }

    var dialog = $(dialogHtml).dialog({
        title: title,
        //width: windowsInfo.width,
        //height: windowsInfo.height,
        width: winWidth,   //yjn
        height: winHeight,
        closed: false,
        cache: false,
        modal: true,
        onLoad: function () {
        },
        onBeforeClose: function () {
            return BeforeCloseCommonModalDialog();
        },
        onOpen: function () {
            $('body').css({
                "overflow-y": "hidden"
            });
        },
        onClose: function () {
            var currentWindowGuid = GetQueryString("OpenWindowGuid");
            delete window.OpenWindowsObj[currentWindowGuid];
            $('body').css({
                "overflow-y": "auto"
            });
            $(this).dialog('destroy');

            if (!!callbackFun) {
                window[callbackFun].extendParams = callbackFunParams;
                if (!!window.ModalDialogReturn) {
                    window[callbackFun](window.ModalDialogReturn);
                    window.ModalDialogReturn = null;
                }
                else
                    window[callbackFun]();
            }
        }
    });


    //$("#dialogFrame").attr("height", windowsInfo.height - 37);//37 为bar的高度
    //$("#dialogFrame").attr("width", windowsInfo.width);

    //弹出窗口需要自适应尺寸 yjn
    $("#dialogFrame").attr("height", winHeight - 37);
    $("#dialogFrame").attr("width", winWidth);

    $("#dialogFrame").attr("src", url);

    return dialog;
}

/**
 * 关闭正在打开的模态对话框
 * @method CloseCommonModalDialog 
**/
function CloseCommonModalDialog() {
    if (!!window.CommonModalDialog) {
        $(window.CommonModalDialog).dialog('close');
        window.CommonModalDialog = null;
    }

}

/**
 * 补打
 * @method RePrint 
**/
function RePrint() {

    var tableID = $("#rePrintDialog").data("TableID");
    var hisURI = window.WebIp;
    var printTemplateEmrCode = "";
    var episodeID = window.EpisodeID;

    if (!!tableID) {
        var opts = $('#' + tableID).datagrid('options');
        printTemplateEmrCode = opts.rePrintTemplateIndentity;
    }

    if (!printTemplateEmrCode) {
        $.messager.alert(" ", $g("没有配置打印模板"), "info");
        return;
    }
    if (!$("#rePrintDialog #startPageNo").numberbox('isValid') || !$("#rePrintDialog #startRowNo").numberbox('isValid'))
        return;
    var printRowId = $("#hisUITableMenu").data("RowID");
    var printStartPageNo = $("#rePrintDialog #startPageNo").numberbox('getValue');
    var printStartIndex = $("#rePrintDialog #startRowNo").numberbox('getValue');


    if (RePrintPrintViewIsOpen == 0) {
        RePrintPrintViewIsOpen = 1;
        if (typeof (PrintProvider) == "undefined") {
            $.messager.alert(" ", $g("PrintProvider未定义"), "error");
            return;
        }
        try {
            var sessionJson = GetLogAuxiliaryInfo();
            PrintProvider.Print(hisURI, printTemplateEmrCode, episodeID, false, printRowId, printStartPageNo, printStartIndex, -1, window.CADisplayPic, RePrintPrintCallBackFun, "", sessionJson);

        } catch (ex) {
            RePrintPrintViewIsOpen = 0;
            $.messager.alert($g("提示"), $g("打印插件Print无法使用") + ex.Description, "info");
        }
    } else {
        // $.messager.alert($g("提示"), $g("打印预览的界面未关闭"), "info");
    }
}
function RePrintGetPrintinfo() {
    var rowid = $("#hisUITableMenu").data("RowID");
    var dataPost = {};
    dataPost.RowId = rowid;
    var url = WebIp + "/csp/dhcnurmpgetdata.csp?ClassName=NurMp.TempalteRecConPrint&MethodName=PrintInfo";
    url = GetMWToken(url);
    $.ajax({
        type: "POST",
        url: url,
        data: { datapost: JSON.stringify(dataPost) },
        //async: async == false ? false : true, //除非指定是同步，否则默认都是异步
        success: function (msg) {
            var strs = msg.split("^"); //字符分割 StartPageNo|1^StartIndex|4行^EndPageNo|1^EndIndex|4
            if (strs.length >= 2) {
                $("#rePrintDialog #IsPrint").text("已打印");
                if (strs.length >= 4) {
                    var printTrace = StringObjectToObject($.trim(msg), "^", "|");
                    var content = "开始页:{0}开始:{1},结束页:{2}结束:{3}";
                    content = $g(content).format(printTrace.StartPageNo, printTrace.StartIndex, printTrace.EndPageNo, printTrace.EndIndex)
                    $("#rePrintDialog #PrintInfo").text(content);
                    $("#rePrintDialog #startPageNo").numberbox("setValue", printTrace.StartPageNo);
                    $("#rePrintDialog #startRowNo").numberbox("setValue", printTrace.StartIndex);
                }
            }
        }
    })
}
//是否弹出了打印预览对话框
var RePrintPrintViewIsOpen = 0;
function RePrintPrintCallBackFun(ret) {
    RePrintPrintViewIsOpen = 0;
    if (ret.msg == "success") {
        var msg = ret.rtn;
        var reMsg = JSON.parse(msg);
        if (MsgIsOK(reMsg)) {
            if (reMsg.msg) {
                $.messager.alert($g("提示"), $g(reMsg.msg), "info");
            }
        }
        else {
            $.messager.alert($g("提示"), $g(reMsg.msg), "info");
        }
    }
    else {
        $.messager.alert($g("提示"), $g(ret.msg), "info");
    }
}

/**
 * hisui数据表格扩展
 * @param { string } rowNo 表格所在的行号
 * @param { string } tableId  表格的ID
 * @param { string } isHorizontalExtend 是否水平扩展
 * @param { string } isVerticalExtend  是否垂直扩展
 * @method HisUITable_SelfAdaption 
**/
function HisUITable_SelfAdaption(rowNo, tableId, isHorizontalExtend, isVerticalExtend) {
    var iframe = GetCurrentPageFrameContainer();
    if (!iframe)
        return false;

    var frameHeight = $(window.parent.document).find(iframe).height();
    var frameWidth = $(window.parent.document).find(iframe).width();
    var scrollBarWidth = getScrollBarWidth();

    var tablePlaceLineWidth = $("body > div[LineNo='" + rowNo + "']").outerWidth(true);

    if (isHorizontalExtend && frameWidth) {
        var isVScroll = false;
        if (!isVerticalExtend)//不垂直扩展，并且所有行的高度加一起>frameHeight,那么一定出垂直滚动条
        {
            var wholeLineHeight = 0;
            for (var i = 1; i <= rowNo; i++) {
                if (!$("body > div[LineNo='" + i + "']").is(':hidden'))
                    wholeLineHeight += $("body > div[LineNo='" + i + "']").outerHeight(true);
            }
            if (wholeLineHeight > frameHeight) {
                isVScroll = true;
            }
        }
        var tableLeftRightMargin = $("body > div[LineNo='" + rowNo + "']").outerWidth(true) - $("body > div[LineNo='" + rowNo + "']").width();

        var adaptionWidth = 0;
        if (isVScroll)
            adaptionWidth = frameWidth - tableLeftRightMargin - scrollBarWidth;
        else
            adaptionWidth = frameWidth - tableLeftRightMargin;

        $("body > div[LineNo='" + rowNo + "']").width(adaptionWidth);
        $("#div_" + tableId).width(adaptionWidth);

        $('#' + tableId).datagrid('resize', { width: adaptionWidth });

    }

    if (isVerticalExtend && frameHeight) {
        //任意行的宽度>frameWidth，那么就一定会出水平滚动条
        var isHScroll = false;
        for (var i = 1; i <= rowNo; i++) {
            if ($("body > div[LineNo='" + i + "']").is(':hidden'))
                continue;
            if ($("body > div[LineNo='" + i + "']").outerWidth(true) > frameWidth) {
                isHScroll = true;
                break;
            }
        }

        var usedHeight = 0;
        for (var i = 1; i < rowNo; i++) {
            if (!$("body > div[LineNo='" + i + "']").is(':hidden'))
                usedHeight += $("body > div[LineNo='" + i + "']").outerHeight(true);
        }
        var tableTopBottomMargin = $("body > div[LineNo='" + rowNo + "']").outerHeight(true) - $("body > div[LineNo='" + rowNo + "']").height();

        var adaptionHeight = 0;
        if (isHScroll)
            adaptionHeight = frameHeight - usedHeight - tableTopBottomMargin - scrollBarWidth;
        else
            adaptionHeight = frameHeight - usedHeight - tableTopBottomMargin;

        $("body > div[LineNo='" + rowNo + "']").height(adaptionHeight);
        $("#div_" + tableId).height(adaptionHeight);

        $('#' + tableId).datagrid('resize', { height: adaptionHeight });
    }
}

function GetCurrentPageFrameContainer() {
    var findFrameContainer = undefined;
    if (window.parent.frames.length > 0) {
        $.each($(window.parent.document).find('iframe'), function (i, frame) {
            if (!!$(frame).attr("src") && $(frame).attr("src").indexOf(window.TemplateIndentity.toLowerCase() + ".csp") > -1) {
                findFrameContainer = frame;
                return false;
            }
        });
    }
    return findFrameContainer;
}

/**
 * 获取滚动条的宽度
 * @method getScrollBarWidth 
**/
function getScrollBarWidth() {
    var el = document.createElement("p"),
        styles = {
            width: "100px",
            height: "100px",
            overflowY: "scroll"
        },
        i;

    for (i in styles) {
        el.style[i] = styles[i];
    }

    // 将元素加到body里面
    document.body.appendChild(el);

    var scrollBarWidth = el.offsetWidth - el.clientWidth;
    //将添加的元素删除
    document.body.removeChild(el);
    return scrollBarWidth;
}

/**
 * 函数防止多次提交
**/
function Throttle(method, context, params) {
    clearTimeout(method.tId);
    method.tId = setTimeout(function () {
        method.apply(context, params);
    }, 500);
}

/**
 * 添加CSS样式
**/
function AddCssStyle(cssStyle) {
    var nod = document.createElement("style");
    nod.type = "text/css";

    if (nod.styleSheet) {         //ie下  
        nod.styleSheet.cssText = cssStyle;
    } else {
        nod.innerHTML = cssStyle;    //或者写成 nod.appendChild(document.createTextNode(str))  
    }
    document.getElementsByTagName("head")[0].appendChild(nod);
}

/**
 * 从SpecifyFiledsData获取表格的ID，因为表格的值为null，所以只是获取key
 * @method GetDataTabelIdFormSpecifyFiledsData
 * @param { obj } SpecifyFiledsData  {keys:['textElement_1','dataElement_2'],vals:['小明','2019-2-26']}
 * @return { string } 
 **/
function GetDataTabelIdFormSpecifyFiledsData(SpecifyFiledsData) {
    var DataTabelId = null;
    if (!!SpecifyFiledsData && !!SpecifyFiledsData.keys && SpecifyFiledsData.keys.length > 0) {
        $.each(SpecifyFiledsData.keys, function (i, n) {
            if (IsHisUIDataTable(n)) {
                DataTabelId = n;
                return false;
            }
            else if (IsRowToColDataTable(n)) {
                DataTabelId = n;
                return false;
            }
            else if (IsSCHisUIDataTable(n)) {
                DataTabelId = n;
                return false;
            }
        });
        return DataTabelId;
    }
    else
        return null;
}

/**
 * 是否是统计行（24小时统计，日间小结，时间段统计）
 * @method IsStatisticsRow
 * @param { obj } rowData  行数据
 * @return { bool } 
 **/
function IsStatisticsRow(rowData) {

    if (!!rowData.StatisticsInfo && (rowData.StatisticsInfo.type == "TwentyFourHoursStatistics" || rowData.StatisticsInfo.type == "TimeQuantumStatistics"
        || rowData.StatisticsInfo.type == "DaytimeStatistics" || rowData.StatisticsInfo.type == "SingleItemStatistics" || rowData.StatisticsInfo.type == "MaxMinStatistics"))
        return true;
    else
        return false;
}

/**
 * 智护全部打印
 * @method AINursePrintAll
 * @param { string } hisURI  "http://114.115.136.233/imedical/web"
 * @param { string } printTemplateEmrCode  打印模板的Emrcode
 * @param { string } episodeID  就诊号
 * @param { string } Params   打印参数 
 * @param { int } CAVerify   当前登录账户的科室，是否开启了CA验证
 @param { string } isShowPreViewstr //如果是0，不弹出打印预览，否则根据打印模板的配置走
 @param { string } printerName //打印机名称
 **/
function AINursePrintAll(hisURI, printTemplateEmrCode, episodeID, Params, CAVerify,isShowPreViewstr, printerName) {
    if (AINursePrintAllViewIsOpen == 0) {
        AINursePrintAllViewIsOpen = 1;
        if (typeof (Params) == "undefined") {
            alert($g("打印参数传递错误"));
            return;
        }
        if (typeof (PrintProvider) == "undefined") {
            alert($g("PrintProvider未定义"));
            return;
        }
        try {
            var _CAVerify = arguments[4] ? arguments[4] : 0;
            var IsPrintAll = 1;
            var sessionJson = GetLogAuxiliaryInfo();
            PrintProvider.PrintALL(hisURI, printTemplateEmrCode, episodeID, Params, _CAVerify, AINursePrintALLCallBackFun, "", IsPrintAll, sessionJson, isShowPreViewstr, printerName);

        } catch (ex) {
            AINursePrintAllViewIsOpen = 0;
            alert($g("打印插件PrintALL无法使用") + ex.Description);
        }
    } else {
        // alert($g("打印预览的界面未关闭"));
    }
}
//是否弹出了打印预览对话框
var AINursePrintAllViewIsOpen = 0;
function AINursePrintALLCallBackFun(ret) {
    AINursePrintAllViewIsOpen = 0;
    if (ret.msg == "success") {
        var msg = ret.rtn;
        var reMsg = JSON.parse(msg);
        if (MsgIsOK(reMsg)) {//交班本没有使用HISUI，不能使用HISUI的弹出框
            if (reMsg.msg) {
                if ($.messager && $.messager.alert) {
                    $.messager.alert(" ", $g(reMsg.msg), "info");
                }
                else {
                    alert($g(reMsg.msg));
                }
            }
        }
        else {
            if ($.messager && $.messager.alert) {
                $.messager.alert(" ", $g(reMsg.msg), "error");
            }
            else {
                alert($g(reMsg.msg));
            }
        }
    }
    else {
        //  alert(ret.msg);
        if ($.messager && $.messager.alert) {
            $.messager.alert(" ", $g(ret.msg), "error");
        }
        else {
            alert($g(ret.msg));
        }
    }
}
/**
 * 交接单初始化
 * @method InitHandover
 **/
function InitHandover() {
    if (typeof DistrictCfg != "undefined") {
        $.each(DistrictCfg.Sections, function (index, section) {
            var filterInputs = $.grep(section.Inputs, function (n, i) {
                return IsEnable(n);
            });
            section.Inputs = filterInputs;
            DisEnableList(section.Inputs, true);
        });

        $.each(DistrictCfg.Sections, function (index, section) {
            if (DistrictCfg.Strict) {
                var allowAccess = false;
                var userRole = "";
                if (section.StrictType == 1) //InpatientWard
                    userRole = session['LOGON.WARDID'];
                else if (section.StrictType == 2) //Departments
                    userRole = session['LOGON.CTLOCID']
                else if (section.StrictType == 3) //SecureGroup
                    userRole = session['LOGON.GROUPID']

                if (!!section.RoleCompareElement) {
                    if (IsSysElement(section.RoleCompareElement)) {
                        //一定是，下拉||下拉单选
                        var helper = GetElementHelper(section.RoleCompareElement);
                        var vals = PickDropListValues(helper.getValueByName());
                        if (vals.length == 1 && vals[0] == userRole)
                            allowAccess = true;
                    }
                }
                else {
                    $.each(section.Roles, function (index, role) {
                        if (userRole == role) {
                            allowAccess = true;
                            return false;
                        }
                    });
                }


                if (allowAccess) {
                    DisEnableList(section.Inputs, false);
                }
            }
            else {
                DisEnableList(section.Inputs, false);
            }

            if (DistrictCfg.OrderFill && !HandoverVerifySecionOrderNext(section)) {
                return false;
            }
        });
    }
}

/**
 * 校验交接单里的某个元素是否可用
 * @method HandoverVerifyItemEnable
 **/
function HandoverVerifyItemEnable(element) {
    var isEnable = false;
    $.each(DistrictCfg.Sections, function (index, section) {
        if (DistrictCfg.Strict) {
            var allowAccess = false;
            var userRole = "";
            if (section.StrictType == 1) //InpatientWard
                userRole = session['LOGON.WARDID'];
            else if (section.StrictType == 2) //Departments
                userRole = session['LOGON.CTLOCID']
            else if (section.StrictType == 3) //SecureGroup
                userRole = session['LOGON.GROUPID']

            $.each(section.Roles, function (index, role) {
                if (userRole == role) {
                    allowAccess = true;
                    return false;
                }
            });

            if (allowAccess) {
                $.each(section.Inputs, function (index, input) {
                    if ($(element).attr("id") == input) {
                        isEnable = true;
                        return false;
                    }
                });
            }
        }
        else {
            $.each(section.Inputs, function (index, input) {
                if ($(element).attr("id") == input) {
                    isEnable = true;
                    return false;
                }
            });
        }

        if (isEnable || (DistrictCfg.OrderFill && !HandoverVerifySecionOrderNext(section))) {
            return false;
        }
    });

    return isEnable;
}

/**
 * 校验交接单某个段落是否以填写完毕，可以进行下一个段落的填写
 * @method HandoverVerifyItemEnable
 **/
function HandoverVerifySecionOrderNext(section) {
    var isNext = false;
    if (!!section.NextFlags && section.NextFlags.length == 0)
        return false;

    if (section.NextFlagFunType == 1) // and
    {
        isNext = true;
        $.each(section.NextFlags, function (index, flag) {
            if (!HasValueByName(flag)) {
                isNext = false;
                return false;
            }
        });

    }
    else if (section.NextFlagFunType == 2) // or
    {
        isNext = false;
        $.each(section.NextFlags, function (index, flag) {
            if (HasValueByName(flag)) {
                isNext = true;
                return false;
            }
        });

    }
    else if (section.NextFlagFunType == 3) // custom
    {
        isNext = window[section.NextFlagCustomFun](section);
    }

    return isNext;
}

/**
     *患者CA签名，带出图片
     @method PatientCASignDisplayImg
**/
function PatientCASignDisplayImg(signFormName, signInfo, showOrder) {
    $("img[id^='" + signFormName + "']").remove();
    var ImgProcess = function (domID, imgBase64Str, imgWidth, imgHeight) {
        $("#" + signFormName).css("vertical-align", "top");
        $("#" + signFormName).parent().css("width", "auto");
        $("#" + signFormName).parent().css("height", "auto");

        if ($("#" + domID).length > 0) {
            $("#" + domID).attr("src", "data:image/jpeg;base64," + imgBase64Str);
        }
        else {
            $("<img id='" + domID + "' src='" + "data:image/jpeg;base64," + imgBase64Str + "'>").css("vertical-align", "middle").css("width", imgWidth).css("height", imgHeight).appendTo("#div_" + signFormName);
        }
    }

    if (!!signInfo.SignScript && signInfo.SignScript != "undefined") {
        var domId = signFormName + "_Script";
        ImgProcess(domId, signInfo.SignScript, window.CAPicStyle.PatWordPictureWidth, window.CAPicStyle.PatWordPictureHeight);
    }

    if (!!signInfo.HeaderImage && signInfo.HeaderImage != "undefined") {
        var domId = signFormName + "_Header";
        ImgProcess(domId, signInfo.HeaderImage, window.CAPicStyle.PatHeadPictureWidth, window.CAPicStyle.PatHeadPictureHeight);
    }

    if (!!signInfo.Fingerprint && signInfo.Fingerprint != "undefined") {
        var domId = signFormName + "_Finger";
        ImgProcess(domId, signInfo.Fingerprint, window.CAPicStyle.PatFingerPictureWidth, window.CAPicStyle.PatFingerPictureHeight);
    }
}

/**
     *CA签名，带出图片
     @method CASignDisplayImg
     @param { string } SignatureFull 不带CA前缀的签名字符串 格式例如（护士01*hs01|护士02*hs02）
**/
function CASignDisplayImg(signFormName, SignatureFull) {
    if (window.CADisplayPic == 1 && SignatureFull != "") {
        var signImgs = [];

        var Signatures = SignatureFull.split("|");
        var SignatureNumbers = [];
        $.each(Signatures, function (i, n) {
            SignatureNumbers.push(n.split("*")[1]);
        });

        var signedInfos = [];
        if (!!window.CASignedInfos) {
            $.each(window.CASignedInfos, function (i, info) {
                if ($.inArray(info.userID, SignatureNumbers) > -1) {
                    signedInfos.push({ userID: info.userID, certCode: info.certCode, certNo: info.certNo });
                }
            });
        }
        var msg = tkMakeServerCall("NurMp.CA.DHCNurSignVerify", "GetUserSignImageWeb", SignatureNumbers.join(","), signFormName, window.tNurMPDataID, JSON.stringify(signedInfos));
        var reMsg = JSON.parse(msg);
        if (!MsgIsOK(reMsg)) {
            console.log("签名框[" + signFormName + "]取图片失败");
            return;
        }

        signImgs = reMsg.data;
        $("img[id^='" + signFormName + "']").remove();
        $.each(SignatureNumbers, function (i, userCode) {
            var domID = signFormName + "_" + userCode;
            var imgBase64Str = signImgs[i];
            $("#" + signFormName).css("vertical-align", "top");
            $("#" + signFormName).parent().css("width", "auto");
            $("#" + signFormName).parent().css("height", "auto");

            if (!!imgBase64Str && imgBase64Str != "undefined") {
                if ($("#" + domID).length > 0) {
                    $("#" + domID).attr("src", "data:image/jpeg;base64," + imgBase64Str);
                }
                else {
                    $("<img id='" + domID + "' src='" + "data:image/jpeg;base64," + imgBase64Str + "'>").css("vertical-align", "middle").css("width", window.CAPicStyle.NursePictureWidth).css("height", window.CAPicStyle.NursePictureHeight).appendTo("#div_" + signFormName);
                }
            }
        });

    }
}

/**
     *患者CA签名响应
     @method OnPatientCASign
**/
function OnPatientCASign(sender) {
    if (!!window.CAPatientPDF)
    {
        OnPatientCAPDFSign(sender);
    }
    else {
        if (window.CAPatientVerify === 0) {
            $.messager.alert(" ", $g("请配置患者签名第三方接口"), "info");
            return;
        }
        var signFormName = $(sender).attr("id");
        var signInfo = PatientCASign();
        if (!!signInfo) {
            $(sender).data("casign", signInfo);
            PatientCASignDisplayImg(signFormName, signInfo);
        }
    }
}

function OnPatientCAPDFSign(sender) {

    var InstanceId = GetCurNurMPDataID();
    if (!InstanceId)
    {
        $.messager.alert("提示", $g("请先保存后再进行患者签名!"), "info");
        return;
    }
    
    var signFormNameArray = [];
    signFormNameArray = $.map($("input[Signature='Patient']"), function (n) {
        var id = $(n).attr("id");
        var eleLabelFor = $("#" + id).attr("dhccLableFor");
        var labelFor = "";
        if (!!eleLabelFor) {
            $.each(eleLabelFor.split("!"), function (i, k) {
                labelFor += $("#" + k).text();
            });
        }
        return labelFor + "^" + $(n).attr("PaSignType");
    });

    var signObjectArray = [];
    $.each(signFormNameArray, function (i, n) {
        var kObj = { keyWord: "", keyWordTip: "", keyWordType: "sign", opinionType: "agree", signerType: "patient" };
        kObj.keyWord = n.split("^")[0];
        kObj.signerType = n.split("^")[1];
        signObjectArray.push(kObj);
    });


    var signArgs = {
        episodeID: window.EpisodeID,
        userID:session['LOGON.USERID'],
        instanceID: InstanceId,
        signKeyWord: JSON.stringify(signObjectArray),
        signLogonType: window.CAPatientPDFShowLogonType
    };
    
    PatientPDASignHelper.sign(signArgs);
}

/**
     *患者CA签名，调用设备接口
     @method PatientCASign
**/
function PatientCASign() {
    try {
        var signerInfo = handSignInterface.getSignerInfo(window.EpisodeID);
        var evidenceData = handSignInterface.getEvidenceData(signerInfo);

        if (typeof evidenceData === 'undefined')
            return;
        //evidenceData = $.parseJSON(evidenceData);

        var signLevel = 'Patient';
        var signUserId = handSignInterface.getUsrID(evidenceData);
        var userName = 'Patient';
        var description = $g('患者');
        var img = handSignInterface.getSignScript(evidenceData);
        var headerImage = handSignInterface.getSignPhoto(evidenceData);
        var fingerImage = handSignInterface.getSignFingerprint(evidenceData);
        var hash = "";
        if (evidenceData.hasOwnProperty("Hash"))
            hash = evidenceData.Hash;
        else
            hash = evidenceData;

        var dataPost = GatherTemplateData();
        var CASignTemplateData = $.extend(true, {}, dataPost);  //签名数据 
        var signData = JSON.stringify(CASignTemplateData);
        var signValue = handSignInterface.getSignDataValue(hash, signData);

        var signInfo = { SignScript: img, HeaderImage: headerImage, Fingerprint: fingerImage, Hash: hash, SignValue: signValue };
        return signInfo;

    } catch (err) {
        if (err.message === '用户取消签名,错误码：61') {
            return null;
        }
        $.messager.alert(" ", err.message, "error");
        return null;
    }
}

/**
     *患者CA签名，表格带出图片
     @method PatientCASignTableDisplayImg
     @param { string } 患者签名字符串 格式例如（PatientCA@24）
**/
function PatientCASignTableDisplayImg(val) {
    var imgs = "";
    var signDataID = val.split("@")[1];
    var msg = tkMakeServerCall("NurMp.CA.DHCNurCASignVerify", "getPatRecSignInfo", signDataID);
    var reMsg = JSON.parse(msg)
    if (MsgIsOK(reMsg)) {
        var signInfo = reMsg.data;

        if (!!signInfo.SignScript && signInfo.SignScript != "undefined") {
            imgs += "<img src='" + "data:image/jpeg;base64," + signInfo.SignScript + "' style='width:" + window.CAPicStyle.PatWordPictureWidth + "px;height:" + window.CAPicStyle.PatWordPictureHeight + "px;'>";
        }

        if (!!signInfo.HeaderImage && signInfo.HeaderImage != "undefined") {
            imgs += "<img src='" + "data:image/jpeg;base64," + signInfo.HeaderImage + "' style='width:" + window.CAPicStyle.PatHeadPictureWidth + "px;height:" + window.CAPicStyle.PatHeadPictureHeight + "px;'>";
        }

        if (!!signInfo.Fingerprint && signInfo.Fingerprint != "undefined") {
            imgs += "<img src='" + "data:image/jpeg;base64," + signInfo.Fingerprint + "' style='width:" + window.CAPicStyle.PatFingerPictureWidth + "px;height:" + window.CAPicStyle.PatFingerPictureHeight + "px;'>";
        }
    }
    return imgs;
}

/**
     *CA签名，表格带出图片
     @method CASignTableDisplayImg
     @param { string } SignatureFull 不带CA前缀的签名字符串 格式例如（护士01*hs01|护士02*hs02）
**/
function CASignTableDisplayImg(SignatureFull, oneRowData, ItemsSplitString, field, SignShowOrder, async, index, tableID) {
    SignatureFull = SignatureFull.replace("CA", "");//保证某列绑定了多个签名字段的场景
    var GetSignImgs = function (SignatureFull) {
        var signImgs = [];

        var Signatures = SignatureFull.split("|");
        var SignatureNumbers = [];
        var SignatureNames = [];
        $.each(Signatures, function (i, n) {
            SignatureNumbers.push(n.split("*")[1]);
            SignatureNames.push(n.split("*")[0]);
        });
        var imgs = "";
        if (async) {
            console.log("异步获取签名图片");
            $cm({
                ClassName: "NurMp.CA.DHCNurSignVerify",
                MethodName: "GetUserSignImageWeb",
                userCode: SignatureNumbers.join(","),
                signFormName: field,
                rowId: oneRowData.ID,
                signedInfos: ""

            }, function (reMsg) {
                var imgs = "";
                if (!MsgIsOK(reMsg)) {
                    console.log("签名取图片失败");
                    imgs = SignatureNames.join(',');
                }
                else {
                    var signImgs = reMsg.data;
                    $.each(SignatureNumbers, function (i, userCode) {
                        var imgBase64Str = signImgs[i];

                        if (!!imgBase64Str && imgBase64Str != "undefined") {

                            imgs += "<img src='" + "data:image/jpeg;base64," + imgBase64Str + "' style='width:" + window.CAPicStyle.NursePictureWidth + "px;height:" + window.CAPicStyle.NursePictureHeight + "px;'>";
                        }
                        else {
                            imgs += SignatureNames[i];
                        }
                    });
                }
                window.AsyncSignImgs[tableID][index + "-" + field] = imgs;
                oneRowData.asyncSignImg = true;
                console.log("异步获取签名图片成功，渲染显示");
                $('#' + tableID).datagrid('refreshRow', index);
            }, function (rtn) {
                imgs = SignatureNames.join(',');
                oneRowData.asyncSignImg = true;
                console.log("异步签名取图片失败");
                $('#' + tableID).datagrid('refreshRow', index);
            });
        }
        else {
            var reMsg = $cm({
                ClassName: "NurMp.CA.DHCNurSignVerify",
                MethodName: "GetUserSignImageWeb",
                userCode: SignatureNumbers.join(","),
                signFormName: field,
                rowId: oneRowData.ID,
                signedInfos: ""

            }, false);

            if (!MsgIsOK(reMsg)) {
                console.log("签名取图片失败");
                return SignatureNames.join(',');
            }

            signImgs = reMsg.data;
            
            $.each(SignatureNumbers, function (i, userCode) {
                var imgBase64Str = signImgs[i];

                if (!!imgBase64Str && imgBase64Str != "undefined") {

                    imgs += "<img src='" + "data:image/jpeg;base64," + imgBase64Str + "' style='width:" + window.CAPicStyle.NursePictureWidth + "px;height:" + window.CAPicStyle.NursePictureHeight + "px;'>";
                }
                else {
                    imgs += SignatureNames[i];
                }

            });
        }

        return imgs;
    }

    if (!!window.CAPuppet) {//假CA
        return GetSignImgs(SignatureFull);
    }
    else if (window.CADisplayPic == 1) {
        if (oneRowData.CAStart == "")//非严格模式
        {
            //能取出图片，就显示图片，取不出图片就显示文字
            return GetSignImgs(SignatureFull);
        }
        else if (oneRowData.CAStart == "true")//严格模式，并且CA签过名
        {
            //能取出图片，就显示图片,取不出图片就显示字
            return GetSignImgs(SignatureFull);
        }
        else if (oneRowData.CAStart == "false")//严格模式，未CA签过名
        {
            return DisplayCA(SignatureFull, ItemsSplitString, SignShowOrder);
        }
        else {
            return GetSignImgs(SignatureFull);
        }
    }
    else {
        return DisplayCA(SignatureFull, ItemsSplitString, SignShowOrder);
    }
}

/**
     *高危上报
     @method HighRiskReport
**/
function InitHighRiskReport() {

    var HighRiskReportSetRadioStyle = function (status) {
        var highRiskReportFlagInputs = $("input[HighRiskReportFlag]");
        if (highRiskReportFlagInputs.length == 0)
            return;
        if (highRiskReportFlagInputs.length == 1) {
            highRiskReportFlagInputs.each(function () {
                var formID = $(this).attr("id");
                HideOne(formID, true);
            });
            return;
        }

        var reportInput = highRiskReportFlagInputs[0];
        var cancelReportInput = highRiskReportFlagInputs[1];

        var highRiskReportFlagFormName = $(highRiskReportFlagInputs[0]).attr("HighRiskReportFlag");

        if (status == 0)//全部隐藏
        {
            highRiskReportFlagInputs.each(function () {
                var formID = $(this).attr("id");
                $HUI.radio("#" + formID).setValue(false);
                HideOne(formID, true);
            });
        }
        else if (status == 1)//上报选中，并且撤销上报隐藏 
        {
            ShowOne($(reportInput).attr("id"), true);
            SetOneValue(highRiskReportFlagFormName, [{ Text: '', Value: '1' }]);
            HideOne($(cancelReportInput).attr("id"), true);
        }
        else if (status == 2)//撤销上报选中，并且上报隐藏
        {
            ShowOne($(cancelReportInput).attr("id"), true);
            SetOneValue(highRiskReportFlagFormName, [{ Text: '', Value: '2' }]);
            HideOne($(reportInput).attr("id"), true);
        }
    }
    var OnHighRiskReport = function () {

        if (!IsHighRiskReport()) {
            $.messager.alert(" ", $g("高危上报没有开启，可能原因：<br/>1.本模板没有配置为高危上报<br/>2.本模板没有配置高危阈值"), "info");
            return;
        }

        var msg = tkMakeServerCall("NurMp.Template.EventSet", "isReportVal", window.TemplateGUID, window.EpisodeID);
        var reMsg = JSON.parse(msg);
        if (!MsgIsOK(reMsg)) {
            $.messager.alert(" ", $g("获取上报状态失败\n错误原因：") + reMsg.msg, "error");
            return;
        }
        var isReported = reMsg.data;
        var highRiskReportRealVal = GetValueByName(window.HighRiskReportFormName);
        if (!$.isNumeric(highRiskReportRealVal))
            return;
        highRiskReportRealVal = ToNumber(highRiskReportRealVal);

        if (!!window.HighRiskReportObj.Submit.OperativeSymbol) {
            var rangeVal = [window.HighRiskReportObj.Submit.ThresholdVal1, window.HighRiskReportObj.Submit.ThresholdVal2];
            if (isReported == "0") {
                if (window[window.HighRiskReportObj.Submit.OperativeSymbol](highRiskReportRealVal, rangeVal)) {
                    //上报
                    HighRiskReportSetRadioStyle(1);
                }
                else {
                    HighRiskReportSetRadioStyle(0);
                }
            }
        }

        if (!!window.HighRiskReportObj.Cancel.OperativeSymbol) {
            var rangeVal = [window.HighRiskReportObj.Cancel.ThresholdVal1, window.HighRiskReportObj.Cancel.ThresholdVal2];
            if (isReported == "1") {
                if (window[window.HighRiskReportObj.Cancel.OperativeSymbol](highRiskReportRealVal, rangeVal)) {
                    //撤销上报
                    HighRiskReportSetRadioStyle(2);
                }
                else {
                    if (isFistRecCycle == '1')
                        HighRiskReportSetRadioStyle(1);
                    else
                        HighRiskReportSetRadioStyle(0);
                }
            }
        }
    }
    var IsHighRiskReport = function () {
        window.HighRiskReportObj = null;
        window.HighRiskReportFormName = "";

        $("input[highRiskReport]").each(function () {
            var formName = $(this).attr("id");
            window.HighRiskReportObj = JSON.parse($(this).attr("highRiskReport"));
            window.HighRiskReportFormName = formName;
            return false;
        });

        if (window.HighRiskReportEnable == '1' && !!window.HighRiskReportObj)
            return true;
        else
            return false;
    }

    HighRiskReportSetRadioStyle(0);

    var _nurMPDataID = "";
    var _queryObj = GetQueryObject();
    if (_queryObj.NurMPDataID != undefined && !!_queryObj.NurMPDataID)//流水ID
        _nurMPDataID = _queryObj.NurMPDataID;
    else if (window.tNurMPDataID != undefined && !!window.tNurMPDataID)
        _nurMPDataID = window.tNurMPDataID;
    if (IsHighRiskReport()) {
        var isFistRecCycle = tkMakeServerCall("NurMp.Template.EventSet", "ISFistRecCycle", _nurMPDataID);

        var testReg = /^NumberElement/;
        if (testReg.test(window.HighRiskReportFormName)) {
            $("#" + window.HighRiskReportFormName).numberbox({ onChange: OnHighRiskReport });
        }
        else {
            $("#" + window.HighRiskReportFormName).change(function () {
                OnHighRiskReport();
            });
        }


        if (isFistRecCycle == '1') {
            HighRiskReportSetRadioStyle(1);
        }
    }
}

/**
     *患者PDF签名
     @method InitPatientPDF
**/
function InitPatientPDF() {
    if (!!window.CAPatientPDF)
        PatientPDASignHelper.refresh();
}

/**
 * 判读对模板的某个操作是否有许可
 * @emrCode { string } 模板的guid
 * @action { string } 操作类型
**/
function IsPermission(emrCode, action, params) {

    var userId = session['LOGON.USERID'];
    var episodeId = window.EpisodeID;
    var locId = session['LOGON.CTLOCID'];
    var msg = { denied: false, errMsg: "", warnDialogShow: true };

    if ($.type(window.CustomPermission) === 'function') {
        msg = window.CustomPermission(emrCode, action, params);
    }
    if (msg.denied && !!msg.errMsg) {
        return msg;
    }
    var ModelId = GetQueryString("ModelId");
    var re = tkMakeServerCall("NurMp.Service.Template.Authority", "getAuthority", session['LOGON.HOSPID'], userId, action, locId, ModelId, episodeId);
    if (re != "Y") {
        msg.denied = true;
        msg.errMsg = $g("限制操作");
        return msg;
    }
    if (window.OutPatientEdit != undefined && window.OutPatientEdit) {
        var re = tkMakeServerCall("NurMp.Quality.Service.Authority", "getPatEmrAction", episodeId, emrCode, userId, action);
        msg.denied = re == 0;
        if (msg.denied) {
            msg.errMsg = $g("病人已出院，限制操作，请申请出院病历授权");
            msg.warnDialogShow = false;

            var regNo = $m({
                ClassName: "NurMp.Common.Base.Patient",
                MethodName: "GetRegNo",
                EpisodeID: window.EpisodeID
            }, false);

            var oldOk = $.messager.defaults.ok;
            $.messager.defaults.ok = $g("申请授权");
            var msgDiv = $.messager.confirm("提示", msg.errMsg, function (r) {
                if (r) {
                    var url = "nur.emr.dischargerecordauthorizeapply.csp?mouldType=HLBL&regNo=" + regNo;
                    url = GetMWToken(url);
                    websys_createWindow(url, $g("申请授权"), "top=5%,left=10,width=98%,height=90%,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes");
                } else {
                    //cancel
                }
                /*要写在回调方法内,否则在旧版下可能不能回调方法*/
                $.messager.defaults.ok = oldOk;
            });
            var msgIconDiv = $(msgDiv).children("div.messager-icon");
            $(msgIconDiv).removeClass("messager-question").addClass("messager-info");
            var msgmsgBtns = $(msgDiv).children("div.messager-button");
            msgmsgBtns.children("a:eq(0)").css("width", "auto");
            $(msgDiv).parent().next().height($(msgDiv).parent().height());
        } 
        return msg;
    }
    return msg;
}

/**
 * 得到最外面（上面）模板的Guid
**/
function GetTopTempletGuid() {
    var guid = window.TemplateGUID;
    var parentWindow = window.parent;
    while (!!parentWindow && !!parentWindow.TemplateGUID && parentWindow != parentWindow.parent) //递归取模板的guid
    {
        guid = parentWindow.TemplateGUID;
        parentWindow = parentWindow.parent;
    }
    return guid;
}

/**
 * 刷新中间框架的模板树
**/
function RefreshMiddleFrameTemplateTree() {
    var parentWindow = window.parent;
    while (!!parentWindow && !!parentWindow.TemplateGUID && parentWindow != parentWindow.parent) {
        parentWindow = parentWindow.parent;
    }
    if ($.type(parentWindow.refreshTempTree) === "function")
        parentWindow.refreshTempTree();
}

/**
 * 循环切换下一个患者
**/
function SwitchPatient(order,episodeID) {
    var parentWindow = window.parent;
    while (!!parentWindow && !!parentWindow.TemplateGUID && parentWindow != parentWindow.parent) {
        parentWindow = parentWindow.parent;
    }
    if ($.type(parentWindow.selectOnePatient) === "function")
        parentWindow.selectOnePatient(order, episodeID);
}

/**
 * 判断两个对象是否相等
**/
function isObjEqual(o1, o2) {
    var props1 = Object.getOwnPropertyNames(o1);
    var props2 = Object.getOwnPropertyNames(o2);
    if (props1.length != props2.length) {
        return false;
    }
    for (var i = 0, max = props1.length; i < max; i++) {
        var propName = props1[i];
        if (o1[propName] !== o2[propName]) {
            return false;
        }
    }
    return true;
}

/**
 * 回调，返回值映射匹配
**/
function CallbackReturnAssemble(returnObject, arrCallbackElements, callbackReturnMap) {
    if (arrCallbackElements.length == 0)
        return;
    if (!returnObject || returnObject.keys.length == 0 || returnObject.vals.length == 0)
        return arrCallbackElements;


    var arrMap = [];
    if (!!callbackReturnMap)
        arrMap = callbackReturnMap.split(",");

    if (arrCallbackElements.length == 1 && callbackReturnMap == "")//兼容2.2.1.20之前
    {
        SetOneValue(arrCallbackElements[0], returnObject.vals[0]);
        return;
    }

    $.each(arrCallbackElements, function (i, callbackEle) {
        var mapField = "";
        $.each(arrMap, function (j, map) {
            if (map.split("^")[0] == callbackEle) {
                mapField = map.split("^")[1];
                return false;
            }
        });
        if (!!mapField) {
            $.each(returnObject.keys, function (k, val) {
                if (val == mapField) {
                    SetOneValue(callbackEle, returnObject.vals[k]);
                    return false;
                }

            });
        }
    });
}

/**
 * 采集，带入值映射匹配
**/
function GatherImportAssemble(arrGatherElements, gatherImportMap) {
    if (arrGatherElements.length == 0)
        return null;

    var data = GatherTemplateSpecifyFiledsData(arrGatherElements);
    if (!gatherImportMap)
        return data;

    var arrMap = [];
    if (!!gatherImportMap)
        arrMap = gatherImportMap.split(",");

    if (!!data && data.keys.length > 0) {
        $.each(data.keys, function (i, gatherEle) {
            var mapField = "";
            $.each(arrMap, function (j, map) {
                if (map.split("^")[0] == gatherEle) {
                    mapField = map.split("^")[1];
                    return false;
                }
            });
            if (!!mapField) {
                data.keys[i] = mapField;
            }
        });
    }

    return data;
}

/**
 * 判断用户工号是否存在
**/
function JudgeIfUserExist(userCode) {
    var result = $m({
        ClassName: "NurMp.NursingRecordsSet",
        MethodName: "judgeIfUserExist",
        UserCode: userCode
    }, false);
    return result;
}

function GetComboboxString(type, data, itemsSplitString, special) {
    var re = [];
    var specialIndexs = [];
    if (special != undefined && !!special)
        specialIndexs = special.split(",");
    if (!itemsSplitString)
        itemsSplitString = ",";
    $.each(data, function (i, v) {
        if (specialIndexs.length == 0) {
            if (type == "text")
                re.push(v.Text);
            else if (type == "value")
                re.push(v.Value);
            else if (type == "numberValue")
                re.push(v.NumberValue);
        }
        else {
            $.each(specialIndexs, function (j, vv) {
                if (vv === v.Value) {
                    if (type == "text")
                        re.push(v.Text);
                    else if (type == "value")
                        re.push(v.Value);
                    else if (type == "numberValue")
                        re.push(v.NumberValue);
                    return false;
                }
            });
        }
    });

    return re.join(itemsSplitString);
}

function BeforeCloseCommonModalDialog() {
    var idcolse = true;
    var oldwindow = document.getElementById("dialogFrame").contentWindow;
    if (oldwindow.CloseAlertFlag && (typeof oldwindow.CanClosewindow === "function")) {
        idcolse = oldwindow.CanClosewindow();
    }
    return idcolse;//return false to cancel the close
}
/**
     *表单数据是否修改
     是否可以关闭窗口
**/
function CanClosewindow() {
    var idcolse = true;
    var olddataJson = window.CAOldFormData;
    var dataPost = window.GatherTemplateData();
    var queryObj = GetQueryObject();
    var isadd = false;
    var GatherSpecifyFiledsData = "";
    if (queryObj.NurMPDataID && olddataJson)//数据ID,修改
    {
        var button = $("a[buttonType='savebutton']");
        if (button.length > 0) {
            GatherSpecifyFiledsData = $(button).attr("GatherSpecifyFiledsData");
            var dataIsChanged = FormDataIsChanged(olddataJson, dataPost, isadd, GatherSpecifyFiledsData);
            if (dataIsChanged) {
                var r = confirm($g('有修改，是否保存？选择取消直接关闭，选择确定自动保存。'));
                if (r) {
                    idcolse = false;
                    var button = $("a[buttonType='savebutton']");
                    if (button.length > 0) {
                        button.click();
                    }
                }
                else {
                    idcolse = true;
                }
            }
        }
        else {
            idcolse = true;
        }
    } else {//新增
        isadd = true;
        var button = $("a[buttonType='savebutton']");
        if (button.length > 0) {
            GatherSpecifyFiledsData = $(button).attr("GatherSpecifyFiledsData");
            var dataIsChanged = FormDataIsChanged(olddataJson, dataPost, isadd, GatherSpecifyFiledsData);
            if (dataIsChanged) {
                var r = confirm($g('有修改，是否保存？选择取消直接关闭，选择确定自动保存。'));
                if (r) {
                    idcolse = false;
                    autoSave();
                }
                else {
                    idcolse = true;
                }
            }
        }
        else {
            idcolse = true;
        }
    }
    if (idcolse) {
	    if (typeof websys_emit == 'function'){
	    	websys_emit("onSelectIPPatient",{ EpisodeID:window.EpisodeID });
	    }
    }
    return idcolse;
}

function autoSave() {
    var button = $("a[buttonType='savebutton']");
    if (button.length > 0) {
        button.click();
    }
}

function FormIsChanged() {
    var dataIsChanged = false;
    var olddataJson = window.CAOldFormData;
    var dataPost = window.GatherTemplateData();
    var queryObj = GetQueryObject();
    var GatherSpecifyFiledsData = "";
    if (queryObj.NurMPDataID && olddataJson)//数据ID,修改
    {
        var isadd = false;
        dataIsChanged = FormDataIsChanged(olddataJson, dataPost, isadd, GatherSpecifyFiledsData);

    } else {//新增
        var isadd = true;
        var button = $("a[buttonType='savebutton']");
        if (button.length > 0) {
            GatherSpecifyFiledsData = $(button).attr("GatherSpecifyFiledsData");
            dataIsChanged = FormDataIsChanged(olddataJson, dataPost, isadd, GatherSpecifyFiledsData);
        }
    }
    return dataIsChanged;
}
/**
     *表单数据是否修改
     @method __FormDataIsChanged
**/
function FormDataIsChanged(oldData, newData, isadd, GatherSpecifyFiledsData) {
    var changed = false;
    if (oldData === undefined)
        oldData = {};
    $.each(newData, function (key, val) {
        var helper = GetElementHelper(key);
        if (isadd) {
            if (GatherSpecifyFiledsData != "") {
                if (GatherSpecifyFiledsData.indexOf(key) != -1) {
                    if (oldData[key] == undefined) {
                        var newVal = newData[key];
                        if (newVal != "") {
                            changed = true;
                            return changed;
                        }
                    }
                    else {
                        var isEqual = helper.isEqual(oldData[key], newData[key]);
                        if (!isEqual) {
                            changed = true;
                            return changed;
                        }
                    }
                }
            }
            else {
                if (oldData[key] == undefined) {
                    var newVal = newData[key];
                    if (newVal != "") {
                        changed = true;
                        return changed;
                    }
                }
                else {
                    var isEqual = helper.isEqual(oldData[key], newData[key]);
                    if (!isEqual) {
                        changed = true;
                        return changed;
                    }
                }
            }
        }
        else //if (!helper.isEqual(oldData[key], newData[key])) {
        {
            if (GatherSpecifyFiledsData != "") {
                if (GatherSpecifyFiledsData.indexOf(key) != -1) {
                    var isEqual = helper.isEqual(oldData[key], newData[key]);
                    if (!isEqual) {
                        changed = true;
                        return changed;
                    }
                }
            }
            else {
                var isEqual = helper.isEqual(oldData[key], newData[key]);
                if (!isEqual) {
                    changed = true;
                    return changed;
                }
            }

        }
    });
    var tableChanged = false;
    if (!!window.HisuiEditors) {
        $.each(window.HisuiEditors, function (tableID, v) {
            var changeRows = $('#' + tableID).datagrid('getChanges');
            if (changeRows.length > 0) {
                tableChanged = true;
                return false;
            }
        });
    }
    return changed || tableChanged;
}
/**
     *动态加载JS
     @method loadJS
**/
function loadJS(url, callback) {
    var script = document.createElement('script'), fn = callback || function () { };
    script.type = 'text/javascript';
    if (script.readyState) {//IE
        script.onreadystatechange = function () {
            if (script.readyState == 'loaded' || script.readyState == 'complete') {
                script.onreadystatechange = null;
                fn();
            }
        };
    } else {//其他浏览器
        script.onload = function () {
            fn();
        };
    }
    script.src = url;
    document.getElementsByTagName('head')[0].appendChild(script);
}
/**
     *显示留痕悬浮框
**/
function OnShowLeaveMarkLog(t, id) {

    if (window.LeaveMarkLogs == undefined)
        return;
    var queryObj = GetQueryObject();
    var nurMPDataID = queryObj.NurMPDataID;

    var tempLeaveMarkLogObj = null;
    if (!!nurMPDataID)
        tempLeaveMarkLogObj = window.LeaveMarkLogs[nurMPDataID];
    else
        tempLeaveMarkLogObj = window.LeaveMarkLogs[window.TemplateGUID];

    $
    if (!tempLeaveMarkLogObj)
        return;

    var leaveMarkLogs = tempLeaveMarkLogObj[$("#" + id).attr("SaveField")];
    if (!!leaveMarkLogs && leaveMarkLogs.length > 0) {
        var detailHtml = "<table class='tooltipTable'>";
        detailHtml += "<tr><th>"+$g("操作时间")+"</th><th>"+$g("操作人")+"</th><th>"+$g("旧值")+"</th><th>"+$g("新值")+"</th></tr>";
        $.each(leaveMarkLogs, function (i, n) {
            detailHtml += "<tr><td style='width:100px;'>" + n.OperationDateTime + "</td><td style='width:100px;'>" + $g(n.OperationUser) + "</td><td style='width:100px;'>" + n.ModifyOldValue + "</td><td style='width:100px;'>" + n.ModifyNewValue + "</td></tr>";
        });
        detailHtml += "</table>";
        $(t).popover({ title: '', trigger: 'manual', cache: false, content: detailHtml });
        $(t).data("hasPopover2", true);
        $(t).popover("show");
    }
}
/**
     *隐藏留痕悬浮框
**/
function OnHideLeaveMarkLog(t) {
    if ($(t).data("hasPopover2") === true)
        $(t).popover("hide");
}
/**
     *获取留痕信息
**/
function GetLeaveMarkLogs() {
    var queryObj = GetQueryObject();
    var nurMPDataIDs = queryObj.NurMPDataID == undefined ? "" : queryObj.NurMPDataID;
    if (window.ShowLeaveMark) {
        var msg = tkMakeServerCall("NurMp.Template.LeaveMarkLog", "getLeaveMarkLog", window.EpisodeID, window.TemplateGUID, nurMPDataIDs);
        var reMsg = JSON.parse(msg)
        if (MsgIsOK(reMsg)) {
            window.LeaveMarkLogs = reMsg.data;
        }
    }
}
/**
     *为表单元素绑定鼠标滑动事件（留痕日志悬浮框）
**/
function BindingLeaveMarkLogEvent() {
    $.each(window.LoadFormElements, function (i, eleID) {
        var helper = GetElementHelper(eleID);
        if (helper != undefined)
            helper.bindingLeaveMarkLogEvent(eleID);
    });
}
/**
     *动态表头格式化
**/
function DynamicTableTitleFormater(tableTitle) {
    if (DynamicTableTitleTest(tableTitle)) {
        tableTitle = tableTitle.replace(/\s{1}(Y|N)\s{1}/, " ");//去掉中间的标志符
    }
    return tableTitle;
}
/**
     *动态表头正则测试
**/
function DynamicTableTitleTest(tableTitle) {
    return /^(?:(?!0000)[0-9]{4}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)-02-29)\(([01][0-9]|2[0-3]):[0-5][0-9]\)\s{1}(Y|N)\s{1}1-/.test(tableTitle);
}
/**
     *护理分级
**/
function InitNursingGrade() {

    $cm({
        ClassName: "NurMp.Template.EventSet",
        MethodName: "getFormEntry",
        TCindentity: window.TemplateGUID,
        EpisodeID: window.EpisodeID
    }, function (jsonData) {
        if (MsgIsOK(jsonData)) {
            var requireElement = jsonData.data;
            if (!!requireElement) {
                $.each(requireElement.split("^"), function (i, n) {
                    SetOneRequired(n, true);
                });
            }
        }
    });
}
/**
     *初始化单元格鼠标滑动事件（关联悬浮框）
**/
function InitTableCellPopover() {
    $("td[popoverEleID]").mouseenter(function () {
        OnShowCellPopover(this);
    });
    $("td[popoverEleID]").mouseleave(function () {
        OnHideCellPopover(this)
    });
}
/**
     *显示单元格悬浮框
**/
function OnShowCellPopover(t) {
    var popId = $(t).attr("popoverEleID");
    if (!!popId) {
        $(t).popover({ title: '', trigger: 'manual', cache: false, content: $("#div_ContainerElement_" + popId).html() });
        $(t).data("hasPopover2", true);
        $(t).popover("show");
    }
}
/**
     *显示单元格悬浮框
**/
function OnHideCellPopover(t) {
    if ($(t).data("hasPopover2") === true)
        $(t).popover("hide");
}
/**
     *是否为IE浏览器
**/
function IsIE() {
    if (!!window.ActiveXObject || "ActiveXObject" in window)
        return true;
    else
        return false;
}
/**
     *生成GUID 
**/
function newGuid() {
    var guid = "";
    for (var i = 1; i <= 32; i++) {
        var n = Math.floor(Math.random() * 16.0).toString(16);
        guid += n;
        if ((i == 8) || (i == 12) || (i == 16) || (i == 20))
            guid += "-";
    }
    return guid;
}
/**
     *动态加载图片
     param {identity} 图片元素HTMLID
**/
function InitImg(identity) {
    var imgData = tkMakeServerCall("NurMp.Template.EventSet", "GetImgData", window.TemplateGUID, identity);
    if (!!imgData) {
        var helper = GetElementHelper(identity);
        helper.banding(identity, imgData);
    }
}
function GetFunctionName(func) {
    if (typeof func == 'function' || typeof func == 'object') {
        var name = ('' + func).match(/function\s*([\w\$]*)\s*\(/);
    }
    return name && name[1];
}
function GetFunctionCallerStack()
{
    var stack = [],
    caller = arguments.callee.caller;
    while (caller) {
        stack.unshift(GetFunctionName(caller));
        caller = caller && caller.caller;
    }
    return stack;
}

function CallItemBeforeInit()
{
    if ($.type(window.ItemBeforeInit) === 'function') {
        window.ItemBeforeInit();
    }
}

function CallItemAfterInit() {
    if ($.type(window.ItemAfterInit) === 'function') {
        window.ItemAfterInit();
    }
}

function CallItemBeforeSetValue() {
    if ($.type(window.ItemBeforeSetValue) === 'function') {
        window.ItemBeforeSetValue();
    }
}

function CallItemAfterSetValue() {
    if ($.type(window.ItemAfterSetValue) === 'function') {
        window.ItemAfterSetValue();
    }

    //续打满页提醒
    setTimeout(function () {
        ContinuPrintMaxPageAlter();
    }, 200);

    //惠美CDSS
    if ($.type(window.initCdssData) === "function") {
        setTimeout(function () {
            initCdssData(window.EpisodeID);
        }, 1000)
    }

}

//获取当前记录ID
function GetCurNurMPDataID() {
	var NurMPDataID = "";
	var queryObj = GetQueryObject();
    if (queryObj.NurMPDataID)//记录单修改或者导入新建
    {
        if (!!queryObj.IsNewFlag && queryObj.IsNewFlag == "true"){//导入新建
            //
        }
        else{
            NurMPDataID = queryObj.NurMPDataID;
        }   
    }
    else if (!!window.currentNurMPDataID)//此值只在页面保存成功时存在
    {
        NurMPDataID = window.currentNurMPDataID;
    }
	else if (!!window.tNurMPDataID) {//此值只在单次评估单二次加载成功时存在
		NurMPDataID = window.tNurMPDataID;
	}
	return NurMPDataID;
}

//初始化热力图
function InitHotRegionImg(svgId,params) {
    var HighlightColor = params.HighLightColor;
    var NormalColor = params.NormalColor; 
    var NormalOpacity = params.NormalOpacity; //.3
    var HighlightOpacity = params.HighLightOpacity; //.7


    var CascadingFunc = function (eleId,checked) {

        var type = eleId.split("_")[0];
        if (type == "CheckElement"){
            $('#' + eleId).checkbox('setValue', checked);
        }
        else if (type == "RadioElement") {
            $('#' + eleId).radio('setValue', checked);
        }
    }

    var innerCallback = function () {
        var mouseOver = function (d) {
            d3.selectAll(".nurRegion").filter(function (d, i) {
                return d !== "active";
            })
            .transition()
            .duration(200)
            .style("opacity", NormalOpacity)
            .style("stroke", "transparent");
            d3.select(this).attr("fill", NormalColor)
                .transition()
                .duration(200)
                .style("opacity", HighlightOpacity)
                .style("stroke", "black");
        }

        var mouseLeave = function () {

            d3.selectAll(".nurRegion").filter(function (d, i) {  
                return d !== "active";
            })
            .transition()
            .duration(200)
            .style("opacity", NormalOpacity)
            .style("stroke", "transparent");

            if (d3.select(this).datum() === "active") {
                d3.select(this).attr("fill", HighlightColor)
                .style("opacity", HighlightOpacity)
                .style("stroke", "black")
            }
        }

        function click(d) {
            
            if (d3.select(this).datum() === "active") {
                d3.select(this).attr("fill", NormalColor)
                .style("opacity", NormalOpacity)
                .style("stroke", "transparent")
                .datum(null);
                if (params.Cascading) {
                    var cascadingItem = $(this).attr("cascadingItem");
                    if (!!cascadingItem)
                    {
                        //取消选中
                        CascadingFunc(cascadingItem,false);
                    }
                }
            }
            else
            {
                if (!params.MultiSelect) {
                    d3.selectAll(".nurRegion").filter(function (d, i) {
                        return d === "active";
                    })
                    .datum(null)
                    .attr("fill", NormalColor)
                    .transition()
                    .duration(200)
                    .style("opacity", NormalOpacity)
                    .style("stroke", "transparent");
                    
                }

                d3.select(this).attr("fill", HighlightColor)
                .style("opacity", HighlightOpacity)
                .style("stroke", "black")
                .datum("active");

                if (params.Cascading) {
                    var cascadingItem = $(this).attr("cascadingItem");
                    if (!!cascadingItem) {
                        //取消选中
                        CascadingFunc(cascadingItem, true);
                    }
                }
            }         
        }

        var svg = d3.select("#" + svgId);

        svg.selectAll("path")
        .style("stroke", "transparent")
        .style("opacity", NormalOpacity)
        .style("stroke", "transparent")
        .on("mouseover", mouseOver)
        .on("mouseleave", mouseLeave)
        .on("click", click);
    }

    
    innerCallback();
}

// 超融合
function OpenExtendPage() {
	if (typeof websys_emit == 'function') {
		var win = websys_getMenuWin()||window;
		if (typeof win.OpenEventJson!='undefined' && win.OpenEventJson["onOpenRecordDialog"]){
			win.OpenEventJson["onOpenRecordDialog"].OEPageUrl = 'nur.emr.' + TemplateIndentity.toLowerCase() + '.csp';
			websys_emit("onOpenRecordDialog",{ EpisodeID: window.EpisodeID }); 
		} 
	}
}