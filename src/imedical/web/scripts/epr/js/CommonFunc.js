//该脚本文件存放经常使用并且可以复用的JS函数，以减少重复写代码
//添加函数的时候请不要与现有的函数重名
//如果要调用该文件，请放在最后面调用，以保证其引用的正确性
//sbin amend 2010-07-09

//是否验证通过
var IsValidPass = false;

//设置表格的普通样式，即设置字体和提示信息
function SetStyle(value, object, record) {
    return "<div style='font-family:宋体; font-size:12px' title='" + value + "'>" + value + "</div>";
}

function SetPasswordStyle(value, object, record) {
    return "<div style='font-family:宋体; font-size:12px' >******</div>";
}

//设置性别的展示样式
function SetGenderStyle(value, object, record) {
    var ret = "";
    if (value == "1") {
        ret = "<div style='font-family:宋体; font-size:12px' >男</div>";
    } else if (value == "2") {
        ret = "<div style='font-family:宋体; font-size:12px' >女</div>";
    } else if (value == "0") {
        ret = "<div style='font-family:宋体; font-size:12px' >不确定</div>";
    } else if (value == "-1") {
        ret = "<div style='font-family:宋体; font-size:12px' >未知</div>";
    }
    return ret;
}

/**  
 * 时间对象的格式化;  
 */  
Date.prototype.format = function(format) {   
    /*  
     * eg:format="YYYY-MM-dd hh:mm:ss";  
     */  
    var o = {   
        "M+" :this.getMonth() + 1, // month   
        "d+" :this.getDate(), // day   
        "h+" :this.getHours(), // hour   
        "m+" :this.getMinutes(), // minute   
        "s+" :this.getSeconds(), // second   
        "q+" :Math.floor((this.getMonth() + 3) / 3), // quarter   
        "S" :this.getMilliseconds()   
    // millisecond   
    }   
    if (/(y+)/.test(format)) {   
        format = format.replace(RegExp.$1, (this.getFullYear() + "")   
                .substr(4 - RegExp.$1.length));   
    }  
    for ( var k in o) {   
        if (new RegExp("(" + k + ")").test(format)) {   
            format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k]   
                    : ("00" + o[k]).substr(("" + o[k]).length));   
        }   
    }   
    return format;   
}  

//设置只显示日期的的样式
function SetDateStyle(value) {
    if (value == null || value.length < 1) {
        return "";
    }
    value = value.replace(new RegExp('(^|[^\\\\])\/Date\\((-?[0-9]+)\\)\/', 'g'), "$1new Date($2)");
    value = eval("(" + value + ")");
    value = value.format("yyyy-MM-dd");
    value = value == "1-01-01" ? "" : value;
    return value;
}

//设置显示日期和时间的样式
function SetDateTimeStyle(value) {
    if (value == null || value.length < 1) {
        return "";
    }
    value = value.replace(new RegExp('(^|[^\\\\])\/Date\\((-?[0-9]+)\\)\/', 'g'), "$1new Date($2)");
    value = eval("(" + value + ")");
    value = value.format("yyyy-MM-dd hh:mm:ss");
    value = value == "yyyy-01-01 08:00:00" ? "" : value;
    return value;
}

//将Bool型的数据显示成为checkbox的形式
function CheckRender(val) {
    val = val.toString().toLowerCase();
    if (val == 'true' || val == 'yes' || val == '1') {
        return "<input type='checkbox' checked='checked' />";
    }
    else {
        return "<input type='checkbox' />";
    }
}

//下拉列表改变的时候触发的事件
function ComboZNChange(AObj) {
    Ext.Msg.show({
        title: '提示',
        msg: '你确定要将当前职能更换为[ ' + $(AObj).val() + ' ]?',
        buttons: { ok: "确定", cancel: "取消" },
        icon: Ext.MessageBox.INFO
    });
}

/*function ComboSexRender(val) {
    return "<select style='width:100%; height:20px; margin-top:0px;'><option value='男'>男</option><option value='女'>女</option><option value='未知'>未知</option><option value='不确定'>不确定</option></select>";
}
*/

//DataPicker 2010-9-7
Ext.ux.DatePicker = Ext.extend(Ext.DatePicker, {
    afterRender: function () {
        this.el.setStyle('position', 'absolute');
        this.el.setLeftTop(Ext.get(this.renderTo).getX(), Ext.get(this.renderTo).getY() + Ext.get(this.renderTo).getHeight());
        this.on("select", function (src, date) {
            Ext.getDom(this.renderTo).value = date.format(this.format);
            this.hide();
            Ext.get(this.renderTo).focus();
        });
        var datePicker = this;
        Ext.get(this.renderTo).on('dblclick', function () {
            if (!datePicker.hidden) {
                datePicker.hide();
            } else {
                datePicker.show();
            }

        });
    }

});

//点击页签的切换的事件
function tabClick(idx, count) {
    //debugger;
    for (i_tr = 0; i_tr < count; i_tr++) {
        if (i_tr == idx) {
            var tabImgLeft = document.getElementById('tabImgLeft__' + idx);
            var tabImgRight = document.getElementById('tabImgRight__' + idx);
            var tabLabel = document.getElementById('tabLabel__' + idx);
            var tabContent = document.getElementById('tabContent__' + idx);

            tabImgLeft.src = '../scripts/epr/Pics/query/tab_active_left.gif';
            tabImgRight.src = '../scripts/epr/Pics/query/tab_active_right.gif';
            tabLabel.style.backgroundImage = 'url(../scripts/epr/Pics/query/tab_active_bg.gif)';
            tabContent.style.visibility = 'visible';
            tabContent.style.display = 'block';
            continue;
        }
        var tabImgLeft = document.getElementById('tabImgLeft__' + i_tr);
        var tabImgRight = document.getElementById('tabImgRight__' + i_tr);
        var tabLabel = document.getElementById('tabLabel__' + i_tr);
        var tabContent = document.getElementById('tabContent__' + i_tr);

        tabImgLeft.src = '../scripts/epr/Pics/query/tab_unactive_left.gif';
        tabImgRight.src = '../scripts/epr/Pics/query/tab_unactive_right.gif';
        tabLabel.style.backgroundImage = 'url(../scripts/epr/Pics/query/tab_unactive_bg.gif)';
        tabContent.style.visibility = 'hidden';
        tabContent.style.display = 'none';
    }
    document.getElementById('FrameWork_YOYO_LzppccSelectIndex').value = idx;
}

/*
 * 创建基于表格的查询条件元素，带有选择器列，支持文本和下拉
 * 参数：
 * itemDivName:包含查询条件元素的Div的名字
 * tableDivName:表格Div的名字
 * colModelConfig:表格的ColModel对象的Config属性
 * itemTypes:元素类型数组，不包含选择器列，支持select(下拉框)和text(文本框)，不区分大小写
 * isMultiTitleRow:是否是多表头表格
 * */
function CreateFilterItem(itemDivName, tableDivName, colModelConfig, itemTypes, isMultiTitleRow) {
    //多表头的情况下请使用下面的这行代码
	if (isMultiTitleRow) {
		$("#"+itemDivName).html($($("#"+tableDivName).find("table")[1]).find("thead").parent().html());
	} else {
    	$("#"+itemDivName).html($("#"+tableDivName).find("table").find("thead").parent().html());
    }
    var nCount = $("#"+tableDivName).find("table").find("thead").find("td").length;
    for (i = 0; i < nCount; i++) {
        InnerStr = "";
        nWidth = $($("#"+itemDivName).find("THEAD").find("TD")[i]).css("width");
        nWidth = nWidth.substring(0, nWidth.length - 2) - 4;
        if (i == '0') {
            InnerStr = "<input type='checkbox' id='" + colModelConfig[i].dataIndex + "' style='width:" + nWidth + "px' />";
        } else {
        if (itemTypes[i - 1].toLowerCase() == "select") {
            InnerStr = "<select style='width:" + nWidth + "px' id='" + colModelConfig[i].dataIndex + "'></select>";
        }
        else if (itemTypes[i - 1].toLowerCase() == "password") {
            InnerStr = "<input type='hidden' id='" + colModelConfig[i].dataIndex + "' style='width:" + nWidth + "px' />";
        }
        else {
            InnerStr = "<input type='text' id='" + colModelConfig[i].dataIndex + "' style='width:" + nWidth + "px' />";
        }
        }

        $("#"+itemDivName).find("THEAD").find("TD")[i].innerHTML = InnerStr;
    }
}

/*
*  改变表头宽度的时候执行的方法
*  参数说明： GridDivId： 表格所在的Div的ID，一般默认为"hello"
*            FilterDivId: 过滤条件所在的Table的ID，一般默认为"FilterDiv"
*/
function AutoFitGridWidth(GridDivId, FilterDivId) {
    //多表头的情况下请使用下面的这行代码
    var DataArr = new Array();
    var nCount = $("#" + FilterDivId).find("THEAD").find("TD").length;
    for (i = 0; i < nCount; i++) {
        var TdNode = $($("#" + FilterDivId).find("THEAD").find("TD")[i]);
        var DataNode = null;
        if (TdNode.find("input")[0] != null) {
            DataNode = TdNode.find("input")[0];
        } else {
            DataNode = TdNode.find("select")[0];
        }
        DataArr[i] = DataNode;
    }

    $("#" + FilterDivId).html($("#" + GridDivId).find("table").find("thead").parent().html());

    for (i = 0; i < nCount; i++) {
        InnerStr = "";
        nWidth = $($("#" + GridDivId).find("table").find("thead").find("TD")[i]).css("width");
        nWidth = nWidth.substring(0, nWidth.length - 2) - 4;
        nWidth = nWidth + "px";
        var obj = DataArr[i];
        if (obj != null) {
            obj.style.width = nWidth;
        }
        $("#" + FilterDivId).find("THEAD").find("TD")[i].innerHTML = obj.outerHTML;
    }
}

/*
*  改变表头列的顺序的时候执行的方法
*  参数说明： GridDivId： 表格所在的Div的ID，一般默认为"hello"
*            FilterDivId: 过滤条件所在的Table的ID，一般默认为"FilterDiv"
*/
var doMove = false;
function AutoFitGridControls(GridDivId, FilterDivId, oldIndex, newIndex) {
    if (oldIndex == newIndex) {
        return true;
    }
    if (doMove == false) {
        doMove = true;
        return;
    }
    //多表头的情况下请使用下面的这行代码
    var DataArr = new Array();

    var nCount = $("#" + FilterDivId).find("THEAD").find("TD").length;
    for (i = 0; i < nCount; i++) {
        var TdNode = $($("#" + FilterDivId).find("THEAD").find("TD")[i]);
        var DataNode = null;
        if (TdNode.find("input")[0] != null) {
            DataNode = TdNode.find("input")[0];
        } else {
            DataNode = TdNode.find("select")[0];
        }
        DataArr[i] = DataNode;
    }

    var OldObj = DataArr[oldIndex];
    //这个地方逻辑有问题，不是换位置了，而是从新排序了
    if (oldIndex > newIndex) {  //向前拖动
        for (var i = oldIndex; i > newIndex; i--) {
            DataArr[i] = DataArr[i - 1];
        }
        DataArr[newIndex] = OldObj;
    } else if (oldIndex < newIndex) {
        for (var i = oldIndex; i < newIndex; i++) {
            DataArr[i] = DataArr[i + 1];
        }
        DataArr[newIndex] = OldObj;
    }


    $("#" + FilterDivId).html($("#" + GridDivId).find("table").find("thead").parent().html());

    for (i = 0; i < nCount; i++) {
        InnerStr = "";
        nWidth = $($("#" + GridDivId).find("table").find("thead").find("TD")[i]).css("width");
        nWidth = nWidth.substring(0, nWidth.length - 2) - 4;
        nWidth = nWidth + "px";
        var obj = DataArr[i];
        if (obj != null) {
            obj.style.width = nWidth;
        }
        $("#" + FilterDivId).find("THEAD").find("TD")[i].innerHTML = obj.outerHTML;
    }
    doMove = false;
}

// 将对象数组转换成下拉框内容
// objs：对象数组
// addEmptyItem：是否有空选项
// idName：ID属性名称（用于处理数据）
// nameName：名称属性名称（用于显示）
// gaojb 2010-11-20
function MakeSelectOptions(objs, addEmptyItem, idName, nameName) {
	var innerStr="";
	if (addEmptyItem) {innerStr = "<option></option>";}
	$(objs).each(function(i, d) {
		innerStr += "<option value='" + d[idName] + "'>" + d[nameName] + "</option>";
	});
	return innerStr;
}

// 查询的where条件数组类，对应后台SQLMapper类的WhereConditions属性
function conditionsClass() {
	this.data=new Array();
}

// 如果没有填写条件值，则不做为查询条件进入conditionsClass
// 这里使用prototype，为避免引用data而产生闭包
conditionsClass.prototype.Add=function(cond) {
	if ((cond.ConditionValue!="")&&(cond.ConditionValue!="null")) {	this.data.push(cond);}
}

// 获取查询条件数组
conditionsClass.prototype.Get=function() {
	return this.data;
}	

// 具体的查询条件类，对应后台的FieldWhereCondition类
function aCondition(fname,condition,cvalue) {
	this.FieldName = fname;
	this.Condition = condition;
	this.ConditionValue = cvalue;
}

/*
* 获取过滤条件列表的方法，针对表格下面的过滤条件
* Obj :  当前收集到的查询条件对象
* FilterDivId ： 过滤框的ID，一般默认为"FilterDiv"
* FieldMap: 字段的映射，用来处理显示的字段和提交的字段不一致的情况
*           使用方法类似：var FieldMap = new Object();
                        FieldMap["DeptID"] = "DeptName";
            意思是：DeptID的值去找ID为DeptName的控件的Value.
            有多个的情况按照这种方法继续写，如果没有可以不传或者传null
*/
function GetFilterConditions(Obj, FilterDivId, FieldMap) {
    var ConditionArr = new conditionsClass();
    for (var o in Obj) {
        var oval = o.toString();
        if (Obj[oval] != "") {
            var curObj = $("#" + FilterDivId).find("#" + oval);
            if (curObj == null || curObj.length < 1) {
                if (oval.toUpperCase() != "ID" && FieldMap != null) {
                    curObj = $("#" + FilterDivId).find("#" + FieldMap[oval]);
                }
            }

            if (curObj != null && curObj.length > 0) {
                if (curObj[0].type == "hidden") {
                    continue;
                }
                else {
                    var fname = escape($.trim(oval));
                    var condition = "eq";

                    if (curObj[0].type == "text") {
                        condition = "like";
                        if ($("#" + FilterDivId).find("#" + oval)[0].id == "ID") {
                            condition = "eq";
                        }
                    }
                    var ConditionValue = new Array();
                    ConditionValue[0] = Obj[oval];
                    var Condi = new aCondition(fname, condition, ConditionValue);
                    ConditionArr.Add(Condi)
                }
            }

        }
    }
    return ConditionArr;
}