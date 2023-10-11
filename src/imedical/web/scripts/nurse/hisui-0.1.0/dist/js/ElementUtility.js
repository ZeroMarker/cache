/**
     * 所有的Element的基类
**/
function AbstractElement()
{
}
AbstractElement.prototype = {
    elementId:null,
    banding: function (id,val) { throw $g("必须重写"); },
    enable: function (id, val) { throw $g("必须重写"); },
    disEnable: function (id, val) { throw $g("必须重写"); },
    SetRequired: function (id, isRequired) { throw $g("必须重写"); },
    getValueById: function (id) {
        return "";
    },
    getNumberValueById: function (id) {//主要用于获取参与统计的值
        return -9999;//表示无效值，不参与统计
    },
	getNumberValueFromTableEditRowById:function(id){
		return 1;
	},
    getValueByName: function (name) {
        return "";
    },
    hasValueByName: function (name) {
        return false;
    },
    //验证是否满足
    isValid: function () {
        return true;
    },
    /**判断两个对象是否满足条件
     * 根据下拉的当前值，获取级联需要跟新的元素信息   
     * @param { ValueByNameOrId } 通过getValueByName，getValueById获取到的值
     * @param { sign } 运算符
     * @param { simpleValArry } 数组，sign函数的参数
     @return { false/true } 
    **/
    CheckIsTrue: function (ValueByNameOrId, sign, simpleValArry) {
        return false;
    },
    /**撤销级联的上次操作
    *
    * @param { id } ID
    * @param { dataSouce } 级联对象的dataSouce
    @param { currentvalue } 这一次的值   
    **/
    UnDoLastAction: function (id, dataSouce, currentvalue) {
        throw $g("必须重写");
    },
    /**撤销级联的上次操作的数据设置
    *
    * @param { id } ID
    * @param { Data } 上次操作的数据
    **/
    UnDoLastActionData: function (id, Data) {
        throw $g("必须重写");
    },
    isForm: function () {
        return false;
    },
    hasFocus: function (id) {
        return false;
    },
    focus: function (id) {
    },
    isFocusEnable: function () {
        return false;
    },
    isEqual: function (value, other) {
        if (IsPatientCA(value))//患者签名，只有签名保存成功后，服务端回写业务表，所以，暂时忽略。
            return true;
        if (!value)
            value = "";
        return value === other;
    },
    getExplanation: function (id) {
        return "";
    },
    //清空选中项
    Clear: function (name) {
    },
    bindingLeaveMarkLogEvent: function (id) {
    },
    isEnable: function (id) {
        return false;
    },
    validate: function (id) {

    }
}

/**
     * Label标签
**/
function LableElement() {

}
LableElement.prototype = new AbstractElement();
LableElement.prototype.banding = function (id, val) {
    if ($.type(val) != 'string') {
        $.messager.alert(" ","元素[" + id + "]赋值格式不正确","error");
        return;
    }
    if ($("div[id='" + id + "']").length > 0)
        $("div[id='" + id + "']").text(val);
}
LableElement.prototype.enable = function (id, val) {
    
}
LableElement.prototype.disEnable = function (id, val) {
}

/**
     * MutiLabel标签
**/
function MutiLableElement() {

}
MutiLableElement.prototype = new AbstractElement();
MutiLableElement.prototype.banding = function (id, val) {
    if ($.type(val) != 'string') {
        $.messager.alert(" ", "元素[" + id + "]赋值格式不正确", "error");
        return;
    }
    if (val.indexOf("\n")) { //数据源换行显示
        val = val.replace("\n", "<br />");
    }
    if ($("p[id='" + id + "']").length > 0)
        $("p[id='" + id + "']").text(val);
}
MutiLableElement.prototype.enable = function (id, val) {

}
MutiLableElement.prototype.disEnable = function (id, val) {
}

/**
     * 复选输入框
**/
function CheckElement() {

}
CheckElement.prototype = new AbstractElement();
CheckElement.prototype.banding = function (id, val) {
    if (!$.isArray(val)) {
        $.messager.alert(" ", "元素[" + id + "]赋值格式不正确", "error");
        return;
    }
    if (!!val) {
        $("input[name=" + id + "]").each(function (i) {
            var item = $(this);
            $(item).checkbox('setValue', false);
        });
    }
    $("input[name=" + id + "]").each(function (i) {
        var item = $(this);
        $.each(val, function (i,v) {
            if ($(item).val() == v.Value)
            {
                $(item).checkbox('setValue', true);  
            }   
        });
    });
}
CheckElement.prototype.HighLight = function (id, checked) {
    if (checked) {
        $("#" + id).next().css("font-weight", "bold").css("color", "red");
    }
    else {
        $("#" + id).next().css("font-weight", "normal").css("color", "black");
    }
}
CheckElement.prototype.Clear = function (id) {
    $("input[name=" + id + "]").each(function (i) {
        var item = $(this);
        var ch = $(this).prop("checked");
        if (ch) {
            $(item).checkbox('setValue', false);
            if (!!$(item).checkbox('options').onCheckChange) {
                $(item).checkbox('options').onCheckChange.call($(item));
            }
        }
    });
}
CheckElement.prototype.enable = function (id, val) {
    $("input[name=" + id + "]").each(function (i) {
        $(this).checkbox('setDisable', !val);
    });
}
CheckElement.prototype.disEnable = function (id, val) {
    $("input[name=" + id + "]").each(function (i) {
        $(this).checkbox('setDisable', val);
    });
}
CheckElement.prototype.UnDoLastActionData = function (id, val) {
    $("input[name=" + id + "]").each(function (i) {
        var item = $(this);
        $.each(val, function (i, v) {
            if ($(item).val() == v.Value)
                $(item).checkbox('setValue', false);;
        });
    });
}
CheckElement.prototype.UnDoLastAction = function (id, dataSouce, currentvalue) {
    var oldvalue = $('#' + id).attr('oldVal');
    if (!!oldvalue) {
        oldvalue = jQuery.parseJSON(oldvalue);
        var dataOld = GetDataSource(id, dataSouce, oldvalue);
        if (dataOld) {
            UnDoChangeData(dataOld,currentvalue);
        }
    }
    
    if (currentvalue != "") {
        $('#' + id).attr('oldVal', JSON.stringify(currentvalue));
    }
    else {
        $('#' + id).attr('oldVal', "");
    }
    
}
CheckElement.prototype.CheckIsTrue = function (ValueByNameOrId, sign, simpleValArry) {   
    if (sign == "EqEmptyArray") {
        if (ValueByNameOrId == undefined)
            return true;
        else
            return eval(sign + "(ValueByNameOrId,simpleValArry);");
    }
    if (sign == "EqUnEmptyArray") {
        if (ValueByNameOrId == undefined)
            return false;
        else
            return eval(sign + "(ValueByNameOrId,simpleValArry);");
    }
    
    var idArr = [];
    for (var i = 0; i < ValueByNameOrId.length; i++) {
        idArr.push(ValueByNameOrId[i].Value);
    }
    var idList = idArr.join(',');
    return eval(sign + "(idList,simpleValArry);");  
}
CheckElement.prototype.SetRequired = function (name, isRequired) {
    $("input[name=" + name + "]").checkbox('setRequired', isRequired);
}
CheckElement.prototype.isValid = function (name) {
    return $("#" + name).checkbox("isValid");
}
CheckElement.prototype.getValueById = function (id) {
    var value = "";
    var ch = $("#" + id).prop("checked");
    if (ch) {
        value = $('#' + id).val();
    }
    return value;
}
CheckElement.prototype.getNumberValueById = function (id,type) {
    var dataValues = this.getValueByName(id);
    var re = 0;
    if (dataValues.length == 0) {
        return -9999;
    }
     
    $.each(dataValues, function (dindex, dvalue) {
        var temp = 0;
        if (dvalue.hasOwnProperty("NumberValue"))
            temp += +dvalue.NumberValue;
        else
            temp += +dvalue.Value;

        if (type == "max") {
            if (dindex == 0)
                re = temp;
            else if (temp > re)
                re = temp;
        }
        else if (type == "min") {
            if (dindex == 0)
                re = temp;
            else if (temp < re)
                re = temp;
        }
        else {
            re += temp;
        }
    });

    return re;
}
CheckElement.prototype.getNumberValueFromTableEditRowById = function (id,type) {
	var dataValues = GetTableCellData(id);
    var re = 0;
    if (!dataValues || dataValues.length == 0) {
        return re;
    }

    $.each(dataValues, function (dindex, dvalue) {
        var temp = 0;
        if (dvalue.hasOwnProperty("NumberValue"))
            temp += +dvalue.NumberValue;
        else
            temp += +dvalue.Value;

        if (type == "max") {
            if (dindex == 0)
                re = temp;
            else if (temp > re)
                re = temp;
        }
        else if (type == "min") {
            if (dindex == 0)
                re = temp;
            else if (temp < re)
                re = temp;
        }
        else {
            re += temp;
        }
    });

    return re;
}
CheckElement.prototype.getValueByName = function (name) {
    var value = [];
    $("input[name=" + name + "]").each(function (i) {
        if ($(this).prop("checked"))
        {
            var item = {};
            item.NumberValue = $(this).attr("NumberValue");
            item.Text = $(this).attr("label");
            item.Value = $(this).val();
            value.push(item);
        }
        
    });
    return value;
}
CheckElement.prototype.hasValueByName = function (name) {
    return this.getValueByName(name).length > 0;
}
CheckElement.prototype.isForm = function () {
    return true;
}
CheckElement.prototype.isEnable = function (id) {
    return !$("#"+id).checkbox('options').disabled;
}
CheckElement.prototype.isEqual = function (value, other) {
    var sourceArr = !!value ? value : [];
    var otherArr = other;
    var isEq = true;

    if (sourceArr.length != otherArr.length)
        return false;
    $.each(sourceArr, function (i, val) {
        if (!isObjEqual(sourceArr[i], otherArr[i])) {
            isEq = false;
            return false;
        }
    });
    return isEq;
}
CheckElement.prototype.getExplanation = function (id) {
    var explanation = "";
    explanation = $("#" + id).attr("Explanation");
    if (!explanation)
        return "";
    if ($.type(explanation) === "function")
        return window[explanation](this.getValueById(id));
    else
        return explanation.replace(/\{0\}/, GetComboboxString("text", this.getValueById(id)));
}
CheckElement.prototype.bindingLeaveMarkLogEvent = function (id) {
    $("input[name=" + id + "]").each(function (i) {
        var iditem = $(this).attr("id");
        $("#div_" + iditem).mouseenter(function() {
            OnShowLeaveMarkLog(this,id);
        });
        $("#div_" + iditem).mouseleave(function() {
            OnHideLeaveMarkLog(this)
        });

    });
}

/**
     * 下拉输入框
**/
function DropListElement() {

}
DropListElement.prototype = new AbstractElement();
/**
     @param { val } 可以是对象{source:[{Text:"",Value:"",NumberValue:""}],values:[{Text:"",Value:"",NumberValue:""}]}
     或者是数组[{Text:"",Value:"",NumberValue:""}]，只表示保存值。
**/
DropListElement.prototype.banding = function (id, val) {
    var values = [];
    if (!!val && $("#" + id).length > 0) {
        if ($.isPlainObject(val)) {
            if ($.isArray(val.source)) {
                $('#' + id).combobox("loadData", val.source);
                if (val.source.length > 0 && val.source[0].NumberValue !== undefined) {
                    var NumberValuesData = {};
                    $.each(val.source, function (i, n) {
                        NumberValuesData[n.Value] = n.NumberValue;
                    });
                    $('#' + id).data("NumberValues", NumberValuesData);
                }
            } else {
                $.messager.alert(" ", "元素[" + id + "]赋值格式不正确", "error");
                return;
            }
            if ($.isArray(val.values)) {
                values = val.values;
            } else {
                $.messager.alert(" ", "元素[" + id + "]赋值格式不正确", "error");
                return;
            }
        }
        else if ($.isArray(val)) {
            values = val;
        }
        else {
            $.messager.alert(" ", "元素[" + id + "]赋值格式不正确", "error");
            return;
        }

        if (values.length > 0) {
            if (values[0].Value == "")//自定义编辑输入或者来自数据源
            {
                var findValue = [];
                $.each($("#" + id).combobox("getData"), function (dindex, dvalue) {
                    if (dvalue.Text === values[0].Text)
                    {
                        findValue.push(dvalue.Value);
                        return false;
                    }
                });
                if (findValue.length > 0)
                    $('#' + id).combobox('setValues', findValue);
                else {
                    $('#' + id).combobox('setValues', []);
                    $('#' + id).combobox('setText', values[0].Text);
                }
            }
            else
            {
                $('#' + id).combobox('setValues', PickDropListValues(values));
                $("#" + id).combobox('options').onSelect.call($('#' + id)[0], values[0]);
            }
        }
        else {//values == []
            $('#' + id).combobox('setValues', values);
            $("#" + id).combobox('options').onSelect.call($('#' + id)[0], undefined);
        }
        $("#" + id).combobox('validate');
    }   
}
DropListElement.prototype.validate = function (id) {
    $("#" + id).combobox('validate');
}
DropListElement.prototype.Clear = function (id) {
    $('#' + id).combobox("clear");
}
DropListElement.prototype.enable = function (id, val) {
    if (val) {
        $('#' + id).combobox("enable");
        $('#' + id).combobox("options").disable = false;
    }
    else {
        $('#' + id).combobox("disable");
        $('#' + id).combobox("options").disable = true;
    }
}
DropListElement.prototype.disEnable = function (id, val) {
    if (val) {
        $('#' + id).combobox("disable");
        $('#' + id).combobox("options").disable = true;
    }
    else {
        $('#' + id).combobox("enable");
        $('#' + id).combobox("options").disable = false;
    }
}
DropListElement.prototype.isValid = function (id) {  
    return $("#" + id).combobox('isValid');
}
DropListElement.prototype.getValueById = function (id) {

    var dataValues = [];
    var values = $("#" + id).combobox("getValues");
    var disText = $("#" + id).combobox("getText");
    if (!!$("#" + id).data('dhcCurrentVal') && $("#" + id).data('dhcCurrentVal') === "undefined")
    {
        if ((values.length == 0 || (values.length == 1 && values[0] == "")) && disText != "")//自定义编辑输入
        {
            return [{ Text: disText, Value: "" }];
        }
        else 
        {
            return [];
        }
    }
        
    if ((values.length == 0 || (values.length == 1 && values[0] == "")) && disText != "")//自定义编辑输入
    {
        return [{ Text: disText, Value: "" }];
    }

    var numberValues = $("#" + id).data("NumberValues");
    $.each($("#" + id).combobox("getData"), function (dindex, dvalue) {
        if (values.length == 0)
            return false;
        $.each(values, function (vindex, vvalue) {
            if (vvalue == dvalue.Value) {
                if (!!numberValues) {
                    var temp = {};
                    temp.NumberValue = numberValues[dvalue.Value];
                    temp.Text = dvalue.Text;
                    temp.Value = dvalue.Value;
                    dvalue = temp;
                }
                    
                dataValues.push(dvalue);
                return false;
            }
        });
    });
    return dataValues;
}
DropListElement.prototype.getNumberValueById = function (id) {
    var dataValues = this.getValueById(id);
    var numberValues = $("#" + id).data("NumberValues");
    if (dataValues.length == 0)
    {
        return -9999;
    }
    if (!!numberValues)
        return numberValues[dataValues[0].Value];
    else
        return dataValues[0].Value;
}
DropListElement.prototype.getNumberValueFromTableEditRowById = function (id) {
	var dataValues = GetTableCellData(id);
    var re = 0;
    if (!dataValues || dataValues.length == 0) {
        return re;
    }

    $.each(dataValues, function (dindex, dvalue) {
        if (dvalue.hasOwnProperty("NumberValue"))
            re += +dvalue["NumberValue"];
        else
            re += +dataValues[dindex].Value;
    });

    return re;
}
DropListElement.prototype.UnDoLastActionData = function (id, val) {
    if (val) {
        if ($.isArray(val.source)) {
            if (val.source.length > 0) {
                  $('#' + id).combobox("loadData", []);
            }
         
        } else {
            $.messager.alert(" ", $g("DropListElement数据格式错误"), "error");
            return;
        }
        if ($.isArray(val.values)) {
            if (val.values.length > 0) {
                $('#' +id).combobox('setValues', "");
            }
        }
        else {
            $.messager.alert(" ", $g("DropListElement数据格式错误"), "error");
            return;
        }
    }
}
DropListElement.prototype.UnDoLastAction = function (id, dataSouce, currentvalue) {
    var oldvalue = $('#' + id).attr('oldVal');
    if (!!oldvalue) {
        oldvalue = jQuery.parseJSON(oldvalue);
        var dataOld = GetDataSource(id, dataSouce, oldvalue);
        if (dataOld) {
            UnDoChangeData(dataOld,currentvalue);
        }
    }
    if (currentvalue != "") {
        $('#' + id).attr('oldVal', JSON.stringify(currentvalue));
    }
    else {
        $('#' + id).attr('oldVal', "");
    }
}
DropListElement.prototype.CheckIsTrue = function (ValueByNameOrId, sign, simpleValArry) {
    if (sign == "EqEmptyArray") {
        if (ValueByNameOrId == undefined)
            return true;
        else
            return eval(sign + "(ValueByNameOrId,simpleValArry);");
    }
    if (sign == "EqUnEmptyArray") {
        if (ValueByNameOrId == undefined)
            return false;
        else
            return eval(sign + "(ValueByNameOrId,simpleValArry);");
    }
    var currentVal = undefined;
    if ($.isArray(ValueByNameOrId)) {
        if (ValueByNameOrId.length == 0)
            currentVal = "";
        else
            currentVal = ValueByNameOrId[0].Value;
    }
    if (currentVal === undefined) {
        return false;
    }
     
    return eval(sign + "(currentVal,simpleValArry);");
}
DropListElement.prototype.SetRequired = function (id, isRequired) {
    $("#" + id).combobox('options').required = isRequired;
    $("#" + id).combobox('textbox').validatebox('options').required = isRequired;
    $("#" + id).combobox('validate');
}
DropListElement.prototype.getValueByName = function (name) {
    //由于hisui封装，所以特殊处理
    return this.getValueById(name);
}
DropListElement.prototype.hasValueByName = function (name) {
    return this.getValueByName(name).length > 0;
}
DropListElement.prototype.isForm = function () {
    return true;
}
DropListElement.prototype.isEnable = function (id) {
    return !$('#' + id).combobox("options").disabled;
}
DropListElement.prototype.hasFocus = function (id) {
    return $("#" + id).parent().children("span").first().children("input").first().is(":focus");
}
DropListElement.prototype.focus = function (id) {
    return $("#" + id).parent().children("span").first().children("input").first().focus();
}
DropListElement.prototype.isFocusEnable = function (id) {
    return !$('#' + id).combobox("options").disabled && !IsHidden(id);
}
DropListElement.prototype.isEqual = function (value,other) {
    var sourceArr = [];
    if ($.isPlainObject(value)) {
        sourceArr = value.values;
    }
    else
        sourceArr = value;
    var otherArr = other;
    var isEq = true;

    if (sourceArr.length != otherArr.length)
        return false;
    $.each(sourceArr, function (i, val) {
        if (!isObjEqual(sourceArr[i], otherArr[i])) {
            isEq = false;
            return false;
        }
    });
    return isEq;
}
DropListElement.prototype.getExplanation = function (id) {
    var explanation = "";
    explanation = $("#" + id).attr("Explanation");
    if (!explanation)
        return "";
    if ($.type(explanation) === "function")
        return window[explanation](this.getValueById(id));
    else
        return explanation.replace(/\{0\}/, GetComboboxString("text", this.getValueById(id)));
}
DropListElement.prototype.bindingLeaveMarkLogEvent = function (id) {
    $("#" + id).combobox('textbox').mouseenter(function () {
        OnShowLeaveMarkLog(this, id);
    });
    $("#" + id).combobox('textbox').mouseleave(function () {
        OnHideLeaveMarkLog(this)
    });
}
/**
     * 单选输入框
**/
function RadioElement() {

}
RadioElement.prototype = new AbstractElement();
RadioElement.prototype.banding = function (id, val) {
    if (!$.isArray(val)) {
        $.messager.alert(" ", "元素[" + id + "]赋值格式不正确", "error");
        return;
    }
    if (!!val) {
        $("input[name=" + id + "]").each(function (i) {
            var item = $(this);
            $(item).radio('setValue', false);
        });
    }
    $("input[name=" + id + "]").each(function (i) {
        var item = $(this);
        $.each(val, function (i, v) {
            if ($(item).val() == v.Value)
            {
                $(item).radio('setValue', true);
            }     
        });

    });
}
RadioElement.prototype.enable = function (id, val) {
    $("input[name=" + id + "]").each(function (i) {
        $(this).radio('setDisable', !val);
    });
}
RadioElement.prototype.disEnable = function (id, val) {
    $("input[name=" + id + "]").each(function (i) {
        $(this).radio('setDisable', val);
    });
}
RadioElement.prototype.getValueById = function (id) {
    var value = "";
    var ch = $("#" + id).prop("checked");
    if (ch) {
        value = $('#' + id).val();
    }
    return value;
}
RadioElement.prototype.HighLight = function (id, checked) {
    if (checked) {
        $("#" + id).next().css("font-weight", "bold").css("color", "red");
    }
    else {
        $("#" + id).next().css("font-weight", "normal").css("color", "black");
    }
}
RadioElement.prototype.Clear = function (name) {
    $("input[name=" + name + "]").each(function (i) {
        var item = $(this);
        if ($(this).prop("checked")) {
            $(item).radio('setValue', false);
            if (!!$(item).radio('options').onCheckChange) {
                $(item).radio('options').onCheckChange.call($(item));
            }
        }
    });
}
RadioElement.prototype.getNumberValueById = function (id) {
    var dataValues = this.getValueByName(id);
    var re = 0;
    if (dataValues.length == 0) {
        return -9999;
    }

    $.each(dataValues, function (dindex, dvalue) {
        if (dvalue.hasOwnProperty("NumberValue"))
            re += +dvalue.NumberValue;
        else
            re += +dvalue.Value;
    });

    return re;
}
RadioElement.prototype.getNumberValueFromTableEditRowById = function (id) {
	var dataValues = GetTableCellData(id);
    var re = 0;
    if (!dataValues || dataValues.length == 0) {
        return re;
    }

    $.each(dataValues, function (dindex, dvalue) {
        if (dvalue.hasOwnProperty("NumberValue"))
            re += +dvalue["NumberValue"];
        else
            re += +dataValues[dindex].Value;
    });

    return re;
}
RadioElement.prototype.SetRequired = function (name, isRequired) { 
    $("input[name=" + name + "]").radio('setRequired', isRequired);
}
RadioElement.prototype.isValid = function (name) {
    return $("#" + name).radio("isValid");
}
RadioElement.prototype.getValueByName = function (name) {
    var value = [];
    $("input[name=" + name + "]").each(function (i) {
        if ($(this).prop("checked"))
        {
            var item = {};
            item.NumberValue = $(this).attr("NumberValue");
            item.Text = $(this).attr("label");
            item.Value = $(this).val();
            value.push(item);
        }
    });
    return value;
}
RadioElement.prototype.hasValueByName = function (name) {
    return this.getValueByName(name).length > 0;
}
RadioElement.prototype.CheckIsTrue = function (ValueByNameOrId, sign, simpleValArry) {
    if (sign == "EqEmptyArray") {
        if (ValueByNameOrId == undefined)
            return true;
        else
            return eval(sign + "(ValueByNameOrId,simpleValArry);");
    }
    if (sign == "EqUnEmptyArray") {
        if (ValueByNameOrId == undefined)
            return false;
        else
            return eval(sign + "(ValueByNameOrId,simpleValArry);");
    }
    
    var selectedIndex = -1;
    if (ValueByNameOrId.length == 0)
        selectedIndex = "";
    else
        selectedIndex = ValueByNameOrId[0].Value;
    return eval(sign + "(selectedIndex,simpleValArry);");
}
RadioElement.prototype.UnDoLastActionData = function (id, val) {
  $("input[name=" + id + "]").each(function(i) {
        var item = $(this);
        $.each(val, function (i, v) {
            if ($(item).val() == v.Value)
                $(item).radio('setValue', false);
        });
  });
}
RadioElement.prototype.UnDoLastAction = function (id, dataSouce, currentvalue) {
    var oldvalue = $('#' + id).attr('oldVal');
    if (!!oldvalue) {
        oldvalue = jQuery.parseJSON(oldvalue);
        var dataOld = GetDataSource(id, dataSouce, oldvalue);
        if (dataOld) {
            UnDoChangeData(dataOld,currentvalue);
        }
    }
    
    if (currentvalue != "") {
        $('#' + id).attr('oldVal', JSON.stringify(currentvalue));
    }
    else {
        $('#' + id).attr('oldVal', "");
    }
}
RadioElement.prototype.isForm = function () {
    return true;
}
RadioElement.prototype.isEnable = function (id) {
    return !$("#" + id).radio('options').disabled;
}
RadioElement.prototype.isEqual = function (value, other) {
    var sourceArr = !!value ? value : [];
    var otherArr = other;
    var isEq = true;

    if (sourceArr.length != otherArr.length)
        return false;
    $.each(sourceArr, function (i, val) {
        if (!isObjEqual(sourceArr[i], otherArr[i])) {
            isEq = false;
            return false;
        }
    });
    return isEq;
}
RadioElement.prototype.getExplanation = function (id) {
    var explanation = "";
    explanation = $("#" + id).attr("Explanation");
    if (!explanation)
        return "";
    if ($.type(explanation) === "function")
        return window[explanation](this.getValueById(id));
    else
        return explanation.replace(/\{0\}/, GetComboboxString("text", this.getValueById(id)));
}
RadioElement.prototype.bindingLeaveMarkLogEvent = function (id) {
    $("input[name=" + id + "]").each(function (i) {
        var iditem = $(this).attr("id");
        $("#div_" + iditem).mouseenter(function () {
            OnShowLeaveMarkLog(this, id);
        });
        $("#div_" + iditem).mouseleave(function () {
            OnHideLeaveMarkLog(this)
        });

    });
}

/**
     * 日期输入框
**/
function DateElement() {

}
DateElement.prototype = new AbstractElement();
DateElement.prototype.banding = function (id, val) {
    if ($.isArray(val)) {
        $.messager.alert(" ", "元素[" + id + "]赋值格式不正确", "error");
        return;
    }
    /*把数据库中制定格式的日期转为要求的格式的日期*/
    var text = val;
    if (!!val) {
        var Format = $('#' + id).attr("format");
        if (Format != "yyyy-MM-dd")
        {
            var data2 = parserToDate(val, "yyyy-MM-dd");         
            text = data2.format(Format);
        }      
    }
    if ($('#' + id).length > 0) {
        $('#' + id).dateboxq('setValue', text);
        if (text) {
            var Format = $('#' + id).attr("format");
            if (!Format) {
                Format = "yyyy-MM-dd";
            }
            var data2 = parserToDate(text, Format);
            $("#" + id).dateboxq('options').onSelect.call($('#' + id)[0], data2);
        }
        $("#" + id).dateboxq('validate');
    }
}
DateElement.prototype.validate = function (id) {
    $("#" + id).dateboxq('validate');
}
DateElement.prototype.Clear = function (id) {
    $('#' + id).dateboxq('setValue', "");
}
DateElement.prototype.enable = function (id, val) {
    if (val) {
        $('#' + id).dateboxq("enable");
        $('#' + id).dateboxq("options").disabled = false;
    }
    else {
        $('#' + id).dateboxq("disable");
        $('#' + id).dateboxq("options").disabled = true;
    }
}
DateElement.prototype.UnDoLastActionData = function (id, val) {
    /*把数据库中制定格式的日期转为要求的格式的日期*/
       var text = val;
       if (val) {
           $('#' + id).dateboxq('setValue', "");
       }
}
DateElement.prototype.UnDoLastAction = function (id, dataSouce, currentvalue) {
    var oldvalue = $('#' + id).attr('oldVal');
    if (!!oldvalue) {
        var dataOld = GetDataSource(id, dataSouce, oldvalue);
        if (dataOld) {
            UnDoChangeData(dataOld,currentvalue);
        }
    }
    if (currentvalue!="")
    {
		//var data2 = parserToDate(currentvalue, "yyyy-MM-dd");
        $('#' + id).attr('oldVal', currentvalue.format("yyyy-MM-dd"));
    }
    else {
        $('#' + id).attr('oldVal', "");
    }
   
}
DateElement.prototype.CheckIsTrue = function (ValueByNameOrId, sign, simpleValArry) {
    var textvalue = ValueByNameOrId;  
    return eval(sign + "(textvalue," + "simpleValArry);");
}
DateElement.prototype.disEnable = function (id, val) {
    if (val) {
        $('#' + id).dateboxq("disable");
        $('#' + id).dateboxq("options").disabled = true;
    }
    else {
        $('#' + id).dateboxq("enable");
        $('#' + id).dateboxq("options").disabled = false;
    }
}
DateElement.prototype.getValueById = function (id) {
    var value = "";
    /*提交数据时，把要求的格式的日期转为数据库中特定格式的日期*/
    value = $('#' + id).dateboxq('getValue');
    var text = value;
    if (value)
    {
        var Format = $('#' + id).attr("format");
        if (Format != "yyyy-MM-dd") {
            var data2 = parserToDate(value, Format);
            text = data2.format("yyyy-MM-dd");
        }      
    }   
    return text;
}
DateElement.prototype.SetRequired = function (id, isRequired) {
    $("#" + id).dateboxq('options').required = isRequired;
    $("#" + id).dateboxq('textbox').validatebox('options').required = isRequired;
    $("#" + id).dateboxq('validate');
}
DateElement.prototype.isValid = function (id) {
    return $("#" + id).dateboxq('isValid');
}
DateElement.prototype.getValueByName = function (name) {
    //由于hisui封装，所以特殊处理
    return this.getValueById(name);
}
DateElement.prototype.hasValueByName = function (name) {
    return this.getValueByName(name) != "";
}
DateElement.prototype.isForm = function () {
    return true;
}
DateElement.prototype.isEnable = function (id) {
    return !$('#' + id).dateboxq("options").disabled;
}
DateElement.prototype.hasFocus = function (id) {
    return $("#" + id).is(":focus");
}
DateElement.prototype.focus = function (id) {
    return $("#" + id).focus();
}
DateElement.prototype.isFocusEnable = function (id) {
    return !$('#' + id).dateboxq("options").disabled && !IsHidden(id);
}
DateElement.prototype.getExplanation = function (id) {
    var explanation = "";
    explanation = $("#" + id).attr("Explanation");
    if (!explanation)
        return "";
    if ($.type(explanation) === "function")
        return window[explanation](this.getValueById(id));
    else
        return explanation.replace(/\{0\}/, this.getValueById(id));
}
DateElement.prototype.bindingLeaveMarkLogEvent = function (id) {
    $("#" + id).mouseenter(function () {
        OnShowLeaveMarkLog(this, id);
    });
    $("#" + id).mouseleave(function () {
        OnHideLeaveMarkLog(this)
    });
}
/**
     * 多行文本输入框
**/
function TextareaElement() {

}
TextareaElement.prototype = new AbstractElement();
TextareaElement.prototype.banding = function (id, val) {
    if ($.isArray(val)) {
        $.messager.alert(" ", "元素[" + id + "]赋值格式不正确", "error");
        return;
    }
    if ($('#' + id).length > 0) {
        $('#' + id).val(val);
        var e = $._data($("#" + id)[0], "events");
        if (e && e["change"])
            $('#' + id).change();
        $("#" + id).validatebox('validate');
        if ($('#' + id).attr("ToolTipContent") == "True") {
            if ($("#" + 'div_' + id).length > 0) {
                    $("#" + 'div_' + id)[0].title = $('#' + id).val();
            }
        }
    }
}
TextareaElement.prototype.validate = function (id) {
    $("#" + id).validatebox('validate');
}
TextareaElement.prototype.Clear = function (id) {
    $('#' + id).val("");
}
TextareaElement.prototype.enable = function (id, val) {
    if (val) {
        $('#' + id).removeAttr("disabled");
    }
    else {
        $("#" + id).attr("disabled", "disabled");
    }
}
TextareaElement.prototype.disEnable = function (id, val) {
    if (val) {

        $("#" + id).attr("disabled", "disabled");
    }
    else {
        $('#' + id).removeAttr("disabled");
    }
}
TextareaElement.prototype.getValueById = function (id) {
    var value = "";
    value = $('#' + id).val();
    return value;
}
TextareaElement.prototype.getNumberValueById = function (id) {
    var values = this.getValueById(id);   
    return values;
}
TextareaElement.prototype.getNumberValueFromTableEditRowById = function (id) {
	return GetTableCellData(id);
}
TextareaElement.prototype.getValueByName = function (name) {
    var id = $("textarea[name=" + name + "]").attr("id");
    return this.getValueById(id);
}
TextareaElement.prototype.hasValueByName = function (name) {
    return this.getValueByName(name) != "";
}
TextareaElement.prototype.SetRequired = function (id, isRequired) {
    $("#" + id).validatebox('options').required = isRequired;
    $("#" + id).validatebox('validate');
}
TextareaElement.prototype.isValid = function (id) {
    return !$("#" + id).hasClass("validatebox-invalid");
}
TextareaElement.prototype.UnDoLastActionData = function (id, val) {
    $('#' + id).val("");
}
TextareaElement.prototype.UnDoLastAction = function (id, dataSouce, currentvalue) {
    var oldvalue = $('#' + id).attr('oldVal');
    if (!!oldvalue) {
        var dataOld = GetDataSource(id, dataSouce, oldvalue);
        if (dataOld) {
            UnDoChangeData(dataOld,currentvalue);
        }
    }
    $('#' + id).attr('oldVal', currentvalue);
}
TextareaElement.prototype.CheckIsTrue = function (ValueByNameOrId, sign, simpleValArry) {
    var textvalue = ValueByNameOrId; 
    return eval(sign + "(textvalue,simpleValArry);");
}
TextareaElement.prototype.isForm = function () {
    return true;
}
TextareaElement.prototype.isEnable = function (id) {
    return $("#" + id).attr("disabled") != "disabled";
}
TextareaElement.prototype.hasFocus = function (id) {
    return $("#" + id).is(":focus");
}
TextareaElement.prototype.focus = function (id) {
    return $("#" + id).focus();
}
TextareaElement.prototype.isFocusEnable = function (id) {
    return $("#" + id).attr("disabled") != "disabled" && !IsHidden(id);
}
TextareaElement.prototype.getExplanation = function (id) {
    var explanation = "";
    explanation = $("#" + id).attr("Explanation");
    if (!explanation)
        return "";
    if ($.type(explanation) === "function")
        return window[explanation](this.getValueById(id));
    else
        return explanation.replace(/\{0\}/, this.getValueById(id));
}
TextareaElement.prototype.bindingLeaveMarkLogEvent = function (id) {
    $("#" + id).mouseenter(function () {
        OnShowLeaveMarkLog(this, id);
    });
    $("#" + id).mouseleave(function () {
        OnHideLeaveMarkLog(this)
    });
}
/**
     * 单行文本输入框
**/
function TextElement() {

}
TextElement.prototype = new AbstractElement();
TextElement.prototype.banding = function (id, val, noFireEvent) {
    if ($.isArray(val)) {
        $.messager.alert(" ", "元素[" + id + "]赋值格式不正确", "error");
        return;
    }
    if ($('#' + id).length > 0) {
        if (!$('#' + id).attr("Signature") || $('#' + id).attr("Signature") == "None") {
            $('#' + id).val(val);
        }
        else if ($('#' + id).attr("Signature") == "Patient") {
            if (IsPatientCA(val)) {
                $('#' + id).attr("PatientSignVal", val);
                var signDataID = val.split("@")[1];
                var msg = tkMakeServerCall("NurMp.CA.DHCNurCASignVerify", "getPatRecSignInfo", signDataID);
                var reMsg = JSON.parse(msg)
                if (MsgIsOK(reMsg)) {
                    var signInfo = reMsg.data;
                    PatientCASignDisplayImg(id, signInfo);
                }
            }
        }
        else {
            var SignatureFull = "";
            if (!!val) {
                if (IsCA(val))
                    SignatureFull = val.substring(2);//去掉前缀CA
                else
                    SignatureFull = val;
                var split = $('#' + id).attr("SignatureSplit");
                var showOrder = $('#' + id).attr("SignatureShow"); 
                $('#' + id).val(DisplayCA(SignatureFull,split,showOrder));
                if (IsCA(val))
                    CASignDisplayImg(id, SignatureFull, showOrder);
            }
            else
                $('#' + id).val("");

            $('#' + id).attr("SignatureFullVal", SignatureFull);
        }
        if (!noFireEvent) {
            var e = $._data($("#" + id)[0], "events");
            if (e && e["change"])
                $('#' + id).change();
        }
        
        $("#" + id).validatebox('validate');
        if ($('#' + id).attr("ToolTipContent") == "True") {
            if ($("#" + 'div_' + id).length > 0) {
                $("#" + 'div_' + id)[0].title = $('#' + id).val();
            }
        }
    }
}
TextElement.prototype.validate = function (id) {
    $("#" + id).validatebox('validate');
}
TextElement.prototype.enable = function (id, val) {
    if (val) {
        $('#' + id).removeAttr("disabled");
    }
    else {
        $("#" + id).attr("disabled", "disabled");
    }
}
TextElement.prototype.SetRequired = function (id, isRequired) {
    $("#" + id).validatebox('options').required = isRequired;
    $("#" + id).validatebox('validate');
}
TextElement.prototype.Clear = function (id) {
    $('#' + id).val("");
}
TextElement.prototype.isValid = function (id) {
    return !$("#" + id).hasClass("validatebox-invalid");
}
TextElement.prototype.disEnable = function (id, val) {
    if (val) {
        $("#" + id).attr("disabled", "disabled");
    }
    else {
        $('#' + id).removeAttr("disabled");
    }
}
TextElement.prototype.getValueById = function (id) {
    var value = "";
    var testReg = /^CA/;
    if ($('#' + id).attr("Signature") == "None" || !$('#' + id).attr("Signature")) {
        value = $('#' + id).val();
    }
    else
    {
        var SignatureFull = $('#' + id).attr("SignatureFullVal");
        if (!!SignatureFull)
        {
            if (testReg.test(SignatureFull))
                value = SignatureFull;
            else
                value = "CA" + SignatureFull;
        }            
    }
    return value;
}
TextElement.prototype.getNumberValueById = function (id) {
    var values = this.getValueById(id);
    return values;
}
TextElement.prototype.getNumberValueFromTableEditRowById = function (id) {
	return GetTableCellData(id);
}
TextElement.prototype.getValueByName = function (name) {
    var id = $("input[name=" + name + "]").attr("id");
    return this.getValueById(id);
}
TextElement.prototype.hasValueByName = function (name) {
    return this.getValueByName(name) != "";
}
TextElement.prototype.isForm = function () {
    return true;
}
TextElement.prototype.UnDoLastActionData = function (id, val) {
    $('#' + id).val("");
}
TextElement.prototype.UnDoLastAction = function (id, dataSouce, currentvalue) {
    var oldvalue = $('#' + id).attr('oldVal');
    if (!!oldvalue) {
        var dataOld = GetDataSource(id, dataSouce, oldvalue);
        if (dataOld) {
            UnDoChangeData(dataOld,currentvalue);
        }
    }
    $('#' + id).attr('oldVal', currentvalue);
}
TextElement.prototype.CheckIsTrue = function (ValueByNameOrId, sign, simpleValArry) {
    var textvalue = ValueByNameOrId;
    return eval(sign + "(textvalue,simpleValArry);");
}
TextElement.prototype.isEnable = function (id) {
    return $("#" + id).attr("disabled") != "disabled";
}
TextElement.prototype.hasFocus = function (id) {
    return $("#" + id).is(":focus");
}
TextElement.prototype.focus = function (id) {
    return $("#" + id).focus();
}
TextElement.prototype.isFocusEnable = function (id) {
    return $("#" + id).attr("disabled") != "disabled" && !IsHidden(id);
}
TextElement.prototype.getExplanation = function (id) {
    var explanation = "";
    explanation = $("#" + id).attr("Explanation");
    if (!explanation)
        return "";
    if ($.type(explanation) === "function")
        return window[explanation](this.getValueById(id));
    else
        return explanation.replace(/\{0\}/, this.getValueById(id));
}
TextElement.prototype.bindingLeaveMarkLogEvent = function (id) {
    $("#" + id).mouseenter(function () {
        OnShowLeaveMarkLog(this, id);
    });
    $("#" + id).mouseleave(function () {
        OnHideLeaveMarkLog(this)
    });
}
/**
     * 时间输入框
**/
function TimeElement() {

}
TimeElement.prototype = new AbstractElement();
TimeElement.prototype.banding = function (id, val) {
    if ($.isArray(val)) {
        $.messager.alert(" ", "元素[" + id + "]赋值格式不正确", "error");
        return;
    }
    if ($('#' + id).length > 0) {
        $('#' + id).timespinner("setValue", val);
        $("#" + id).timespinner('validate');
    }
}
TimeElement.prototype.validate = function (id) {
    $("#" + id).timespinner('validate');
}
TimeElement.prototype.enable = function (id, val) {
    if (val) {
        $('#' + id).prop("disabled", false);
        $('#' + id).timespinner("options").disabled = false;
    }
    else {
        $('#' + id).prop("disabled", true);
        $('#' + id).timespinner("options").disabled = true;
    }
}
TimeElement.prototype.SetRequired = function (id, isRequired) {
    $("#" + id).timespinner('options').required = isRequired;
    $("#" + id).timespinner().validatebox('options').required = isRequired;
    $("#" + id).timespinner('validate');
}
TimeElement.prototype.isValid = function (id) {
    return $("#" + id).timespinner('isValid');
}
TimeElement.prototype.Clear = function (id) {
    $('#' + id).timespinner("setValue", "");
}
TimeElement.prototype.disEnable = function (id, val) {
    if (val) {
        $('#' + id).prop("disabled", true);
        $('#' + id).timespinner("options").disabled = true;
    }
    else {
        $('#' + id).prop("disabled", false);
        $('#' + id).timespinner("options").disabled = false;
    }
}
TimeElement.prototype.getValueById = function (id) {
    var value = "";
    value = $('#' + id).timespinner('getValue');
    return value;
}
TimeElement.prototype.getValueByName = function (name) {
    var id = $("input[name=" + name + "]").attr("id");
    return this.getValueById(id);
}
TimeElement.prototype.hasValueByName = function (name) {
    return this.getValueByName(name) != "";
}
TimeElement.prototype.isForm = function () {
    return true;
}
TimeElement.prototype.UnDoLastActionData = function (id, val) {
    $('#' + id).timespinner("setValue", "");
}
TimeElement.prototype.UnDoLastAction = function (id, dataSouce, currentvalue) {
    var oldvalue = $('#' + id).attr('oldVal');
    if (!!oldvalue) {
        var dataOld = GetDataSource(id, dataSouce, oldvalue);
        if (dataOld) {
            UnDoChangeData(dataOld,currentvalue);
        }
    }
    $('#' + id).attr('oldVal', currentvalue);
}
TimeElement.prototype.CheckIsTrue = function (ValueByNameOrId, sign, simpleValArry) {
    var textvalue = ValueByNameOrId;
    return eval(sign + "(textvalue,simpleValArry);");
}
TimeElement.prototype.isEnable = function (id) {
    return !$('#' + id).timespinner("options").disabled;
}
TimeElement.prototype.hasFocus = function (id) {
    return $("#" + id).is(":focus");
}
TimeElement.prototype.focus = function (id) {
    return $("#" + id).focus();
}
TimeElement.prototype.isFocusEnable = function (id) {
    return !$('#' + id).timespinner("options").disabled && !IsHidden(id);
}
TimeElement.prototype.getExplanation = function (id) {
    var explanation = "";
    explanation = $("#" + id).attr("Explanation");
    if (!explanation)
        return "";
    if ($.type(explanation) === "function")
        return window[explanation](this.getValueById(id));
    else
        return explanation.replace(/\{0\}/, this.getValueById(id));
}
TimeElement.prototype.bindingLeaveMarkLogEvent = function (id) {
    $("#" + id).mouseenter(function () {
        OnShowLeaveMarkLog(this, id);
    });
    $("#" + id).mouseleave(function () {
        OnHideLeaveMarkLog(this)
    });
}
/**
     * 数字输入框
**/
function NumberElement() {

}
NumberElement.prototype = new AbstractElement();
NumberElement.prototype.banding = function (id, val) {
    if ($.isArray(val)) {
        $.messager.alert(" ", "元素[" + id + "]赋值格式不正确", "error");
        return;
    }
    if ($('#' + id).length > 0) {
        $('#' + id).numberbox("setValue", val);
        var e = $._data($("#" + id)[0], "events");
        if (e && e["change"])
            $('#' + id).change();
        $("#" + id).numberbox('validate');
    }
}
NumberElement.prototype.validate = function (id) {
    $("#" + id).numberbox('validate');
}
NumberElement.prototype.Clear = function (id) {
    $('#' + id).numberbox("setValue", "");
}
NumberElement.prototype.enable = function (id, val) {
    if (val) {
        $('#' + id).numberbox("enable");
    }
    else {
        $('#' + id).numberbox("disable");
    }
}
NumberElement.prototype.getNumberValueFromTableEditRowById = function (id) {
	return GetTableCellData(id);
}
NumberElement.prototype.disEnable = function (id, val) {
    if (val) {
        $('#' + id).numberbox("disable");
    }
    else {
        $('#' + id).numberbox("enable");
    }
}
NumberElement.prototype.getValueById = function (id) {
    var value = "";
	value = $('#' + id).val();
	//value = $('#' + id).numberbox('getValue');
    return value;
}
NumberElement.prototype.isValid = function (id) {
    return !$("#" + id).hasClass("validatebox-invalid");
}
NumberElement.prototype.SetRequired = function (id, isRequired) {
    $("#" + id).numberbox('options').required = isRequired;
    $("#" + id).numberbox().validatebox('options').required = isRequired;
    $("#" + id).numberbox('validate');
}
NumberElement.prototype.getValueByName = function (name) {
    //由于hisui封装，所以特殊处理
    return this.getValueById(name);
}
NumberElement.prototype.hasValueByName = function (name) {
    return this.getValueByName(name) != "";
}
NumberElement.prototype.getNumberValueById = function (id) {
    var values = this.getValueById(id);
    return values;
}
NumberElement.prototype.isForm = function () {
    return true;
}
NumberElement.prototype.UnDoLastActionData = function (id, val) {
   $('#' + id).numberbox("setValue", "0");
}
NumberElement.prototype.UnDoLastAction = function (id, dataSouce, currentvalue) {
    var oldvalue = $('#' + id).attr('oldVal');
    if (!!oldvalue) {
        var dataOld = GetDataSource(id, dataSouce, oldvalue);
        if (dataOld) {
            UnDoChangeData(dataOld,currentvalue);
        }
    }
    $('#' + id).attr('oldVal', currentvalue);
}
NumberElement.prototype.CheckIsTrue = function (ValueByNameOrId, sign, simpleValArry) {
    var valueCurrent = 0;
    if ($.isNumeric(ValueByNameOrId)) {
        valueCurrent = parseFloat(ValueByNameOrId);
    }
	else if (sign == "EqEmptyText" || sign == "EqUnEmptyText")
	{
		valueCurrent = ValueByNameOrId;
	}
    else {
        return false;
    }
    return eval(sign + "(valueCurrent,simpleValArry);");
}
NumberElement.prototype.isEnable = function (id) {
    return $("#" + id).attr("disabled") != "disabled";
}
NumberElement.prototype.hasFocus = function (id) {
    return $("#" + id).is(":focus");
}
NumberElement.prototype.focus = function (id) {
    return $("#" + id).focus();
}
NumberElement.prototype.isFocusEnable = function (id) {
    return $("#" + id).attr("disabled") != "disabled" && !IsHidden(id);
}
NumberElement.prototype.getExplanation = function (id) {
    var explanation = "";
    explanation = $("#" + id).attr("Explanation");
    if (!explanation)
        return "";
    if ($.type(explanation) === "function")
        return window[explanation](this.getValueById(id));
    else
        return explanation.replace(/\{0\}/, this.getValueById(id));
}
NumberElement.prototype.bindingLeaveMarkLogEvent = function (id) {
    $("#" + id).mouseenter(function () {
        OnShowLeaveMarkLog(this, id);
    });
    $("#" + id).mouseleave(function () {
        OnHideLeaveMarkLog(this)
    });
}
/**
     * 水平线
**/
function HLineElement() {

}
HLineElement.prototype = new AbstractElement();
HLineElement.prototype.banding = function (id, val) {
}
HLineElement.prototype.enable = function (id, val) {   
}
HLineElement.prototype.disEnable = function (id, val) {
}

/**
     * 垂直线
**/
function VLineElement() {

}
VLineElement.prototype = new AbstractElement();
VLineElement.prototype.banding = function (id, val) {
}
VLineElement.prototype.enable = function (id, val) {
}
VLineElement.prototype.disEnable = function (id, val) {
}

/**
     * 图片
**/
function ImgElement() {

}
ImgElement.prototype = new AbstractElement();
ImgElement.prototype.banding = function (id, val) {
    var marker = $("#" + id).attr("marker");
    var markerFree = $("#" + id).attr("markerFree");
    var upload = $("#" + id).attr("upload");
    var hotMaper = $("#" + id).attr("hotmap");
    if (marker !== undefined && marker === "true") {
        if (val === "")//表示没有保存过
            return;
        if (!$.isArray(val)) {
            $.messager.alert(" ", "元素[" + id + "]赋值格式不正确", "error");
            return;
        }
        $("#" + id).data("Map", val);
        $.each(val, function (i, v) {
            __CreateMarker(id,v);
        });
    }
    else if (markerFree !== undefined && markerFree === "true") {
        if (!!val) {
            var paths = JSON.parse(val);
            paths.backgroundImage["src"] = window[id + "MarkFreeSrc"];
            var tt = JSON.stringify(paths);
            window[id + "MarkFree"].setss(tt);
        }
    }
    else if (hotMaper !== undefined && hotMaper === "true") {
        var HighlightColor = $("#" + id).attr("highlightColor");
        var HighlightOpacity = $("#" + id).attr("highlightOpacity");
        $.each(val.split(","), function (i, n) {
            $("path[id='" + n + "']").attr("fill", HighlightColor).css("opacity", +HighlightOpacity).css("stroke", "black").prop("__data__", "active");
        });
    }
    else {
        if ($.type(val) != 'string') {
            $.messager.alert(" ", "元素[" + id + "]赋值格式不正确", "error");
            return;
        }
        if ($("#" + id).length > 0) {
            $("#" + id).attr("src", val);
            if (upload !== undefined && upload === "true" && !!val)
                ShowOne(id, true);
        }
    }
}
ImgElement.prototype.isForm = function () {
    return true;
}
ImgElement.prototype.getValueByName = function (name) {
    var marker = $("#" + name).attr("marker");
    var markerFree = $("#" + name).attr("markerFree");
    var upload = $("#" + name).attr("upload");
    var hotMaper = $("#" + name).attr("hotmap");
    if (marker !== undefined && marker === "true") {
        if ($("#" + name).data("Map") != undefined)
            return $.extend(true, [], $("#" + name).data("Map"));
        else
            return [];
    }
    else if (markerFree !== undefined && markerFree === "true")
    {
        var paths = window[name + "MarkFree"].getss();
        if (!!paths && !!paths.objects && paths.objects.length > 0) {
            paths.backgroundImage["src"] = "";
            var tt = JSON.stringify(paths);
            return tt;
        }
        else
            return "";
        
    }
    else if (upload !== undefined && upload === "true") {
        return $("#" + name).attr("src");
    }
    else if (hotMaper !== undefined && hotMaper === "true") {
        var selectedPaths = $("#HotMap" + name + " > path").filter(function (i) {
            return $(this).prop("__data__") === "active";
        });

        var codes = $.map(selectedPaths, function (n) {
            return $(n).attr("id");
        });

        return codes.toString();
    }
    else
        return undefined;
}
ImgElement.prototype.getMarkFreeByName = function (name) {
    return window[name + "MarkFree"].toDataURL();
}
ImgElement.prototype.enable = function (id, val) {
    var marker = $("#" + id).attr("marker");
    if (marker !== undefined && marker === "true") {
        $("#" + id).attr("dhccEnable", true);
    }
    
    var markerFree = $("#" + id).attr("markerFree");
    if (markerFree !== undefined && markerFree === "true") {
        $(".tui-image-editor-help-menu").show();
    }
}
ImgElement.prototype.disEnable = function (id, val) {
    var marker = $("#" + id).attr("marker");
    if (marker !== undefined && marker === "true") {
        $("#" + id).attr("dhccEnable", false);
    }
    
    var markerFree = $("#" + id).attr("markerFree");
    if (markerFree !== undefined && markerFree === "true") {
        $(".tui-image-editor-help-menu").hide();
    }
}
ImgElement.prototype.isEqual = function (value, other) {
    var marker = $("#" + this.elementId).attr("marker");
    if (marker !== undefined && marker === "true") {
        if ($.isArray(value) && $.isArray(other))
        {
            var sourceArr = value;
            var otherArr = other;
            var isEq = true;
            if (sourceArr.length != otherArr.length)
                return false;
            $.each(sourceArr, function (i, val) {
                if (!isObjEqual(sourceArr[i], otherArr[i])) {
                    isEq = false;
                    return false;
                }
            });
            return isEq;
        }
        else {
            return false;
        }
    }
    else {
        return value === other;
    }
}

/**
     * 行转列数据表格
**/
function RowToColDataTableElement() {

}
RowToColDataTableElement.prototype = new AbstractElement();
RowToColDataTableElement.prototype.banding = function (id, val) {
    if ($.type(val) == 'string') {
        $.messager.alert(" ", "元素[" + id + "]赋值格式不正确", "error");
        return;
    }
    if ($("#" + id).length > 0) {
        var BasicInfo = $("#" + id).attr("BasicInfo");
        if (!BasicInfo || !val)
            return;


        BasicInfo = BasicInfo.replace(/'/g, '"');
        var json = jQuery.parseJSON(BasicInfo);
        var _tempArray = [];
        var _tempRows = $.grep(json.Rows, function (n, i) {
            if ($.inArray(n.field, _tempArray) > -1)
                return false;
            else {
                _tempArray.push(n.field);
                return true;
            }
        });
        json.Rows = _tempRows;
        clearTableData();

        var StartColId = json.StartColId;//从哪一列开始绑定数据。序号从0开始

        for (var i = StartColId; i < $("#" + id).attr("cols") ; i++) {
            var dataRowNo = i - StartColId;
            var cols = $('#' + id + ' .col_' + i);
            if (dataRowNo >= val.rows.length)
                break;
            if (cols.length > 0) {
                for (var k = 0; k < cols.length; k++) {
                    var rowData = val.rows[dataRowNo];
                    var field = json.Rows[k].field;
                    var text = html_encode(rowData[field]);

                    if (IsCA(text)) {
                        var SignatureFull = text.substring(2);//去掉前缀CA
                        text = CASignTableDisplayImg(SignatureFull, rowData, json.Rows[k].splitStr, field, json.Rows[k].signShow, false);
                    }
                    else if (IsPatientCA(text)) {
                        text = PatientCASignTableDisplayImg(text);
                    }
                    if (json.CancelRecShowRed && !!rowData.CancelInfo && rowData.CancelInfo != "null") {
                        $(cols[k]).css("color","red");
                    }
                    else {
                        $(cols[k]).css("color", "");
                    }
                    $(cols[k]).html(text);
                    $(cols[k]).parent().attr("rowID", rowData['ID']);
                    if (rowData.PrintInfo && rowData.PrintInfo != "null")
                        $(cols[k]).parent().addClass("datagrid-row-mp-printed");
                    if (rowData.PrintAlled && rowData.PrintAlled == "true")
                        $(cols[k]).parent().addClass("datagrid-row-mp-printed");
                }
            }
        }

        $("#" + id).data("Rows", val);

        if ($("#" + id + "Pager").length > 0) {
            var pageNumber = !!$("#" + id).data("nurPageNumber") ? $("#" + id).data("nurPageNumber") : 1;
            $("#" + id + "Pager").pagination('refresh', {
                total: val.total,
                pageNumber: pageNumber
            });
        }

        function clearTableData()//清空已经加载的数据
        {
            var StartColId = json.StartColId;//从哪一列开始绑定数据。序号从0开始

            for (var i = StartColId; i < $("#" + id).attr("cols") ; i++) {
                var dataRowNo = i - StartColId;
                var cols = $('#' + id + ' .col_' + i);
                if (cols.length > 0) {
                    for (var k = 0; k < cols.length; k++) {
                        var field = json.Rows[k].field;
                        var text = "";
                        var align = json.Rows[k].align;//'left','right','center'
                        if ($(cols[k]).is("div")) {
                            $(cols[k]).html(text);
                            $(cols[k]).parent().removeAttr("rowID");
                            $(cols[k]).parent().removeClass("datagrid-row-mp-printed");
                            $(cols[k]).parent().removeClass("datagrid-row-selected");
                        }
                        else {
                            $(cols[k]).parent().addClass("col_" + i).attr("colid", "col_" + i);
                            $(cols[k]).parent().css("vertical-align", "middle").css("text-align", align).html(text);
                        }
                    }
                }
            }
        }
    }
}
RowToColDataTableElement.prototype.enable = function (id, val) {
}
RowToColDataTableElement.prototype.disEnable = function (id, val) {
}
RowToColDataTableElement.prototype.getValueByName = function (name) {
    return DataTableCheckRowIds(name);
}
/**
     * hisui数据表格
**/
function HISUIDataTableElement() {

}
HISUIDataTableElement.prototype = new AbstractElement();
HISUIDataTableElement.prototype.banding = function (id, val) {
    if ($.type(val) == 'string') {
        $.messager.alert(" ", "元素[" + id + "]赋值格式不正确", "error");
        return;
    }
    if ($("#" + id).length > 0) {
        var StatisticsMergeDis = false;
        var startField = "";
        var mergeFields = [];
        if (!!$("#" + id).data("StatisticsMergeDisColumns")) {
            StatisticsMergeDis = true;
            mergeFields = $("#" + id).data("StatisticsMergeDisColumns");
            startField = mergeFields[0];
        }

        var data = val;
        if ($.isArray(data)) {
            for (var i = 0; i < data.length; i++) {
                var onerow = data[i];
                var tempMerge = "";
                for (var p in onerow) {
                    var name = p;//属性名称
                    if ($.isPlainObject(onerow[p]))
                        continue;
                    var value = onerow[p];//属性对应的值
                }
            }
        }
        else {
            if (data.total > 0)//和hisUI表格要求的数据格式一致
            {
                for (var i = 0; i < data.rows.length; i++) {
                    var onerow = data.rows[i];
                    for (var p in onerow) {
                        var name = p;//属性名称
                        var tempMerge = "";
                        if ($.isPlainObject(onerow[p]))
                            continue;
                        var value = onerow[p];//属性对应的值
                    }

                    if (StatisticsMergeDis && (!!onerow.StatisticsInfo && (onerow.StatisticsInfo.type == "TwentyFourHoursStatistics" || onerow.StatisticsInfo.type == "TimeQuantumStatistics"
                    || onerow.StatisticsInfo.type == "DaytimeStatistics" || onerow.StatisticsInfo.type == "SingleItemStatistics"))) {
                        $.each(mergeFields, function (i, field) {
                            onerow[field + "old"] = onerow[field];
                            tempMerge += onerow[field] + " ";
                        });
                        onerow[startField] = tempMerge;
                    }
                }
            }
        }

        $('#' + id).datagrid("clearChecked");
        var op = $('#' + id).datagrid("options");
        var pageNumber = !!$("#" + id).data("nurPageNumber") ? $("#" + id).data("nurPageNumber") : 1;
        var pageSize = !!$("#" + id).data("nurPageSize") ? $("#" + id).data("nurPageSize") : op.pageSize;
        op.pageNumber = pageNumber;
        op.pageSize = pageSize;

        if (window.AsyncSignImgs === undefined)
            window.AsyncSignImgs = {};
        window.AsyncSignImgs[id] = {};

        $('#' + id).datagrid("loadData", data);
        $("#" + id).datagrid('getPager').pagination('refresh', {
            pageNumber: pageNumber,
            pageSize: pageSize,
            total: val.total
        });
        $('#' + id).datagrid("scrollTo", 0);
    }
}
HISUIDataTableElement.prototype.enable = function (id, val) {
}
HISUIDataTableElement.prototype.disEnable = function (id, val) {
}
HISUIDataTableElement.prototype.getValueByName = function (name) {
    return DataTableCheckRowIds(name);
}

/**
     * 单列hisui数据表格
**/
function SingleColumnHISUIDataTableElement() {

}
SingleColumnHISUIDataTableElement.prototype = new AbstractElement();
SingleColumnHISUIDataTableElement.prototype.banding = function (id, val) {
    var op = $('#' + id).datagrid("options");
    if (!!op.RelatedStoreDataID) {
        if ($("#" + id).length > 0) {
            var data = { total: 0, rows: [] };
            var relatedStoreDataStr = GetValueById(op.RelatedStoreDataID);
            var tempData = !!relatedStoreDataStr ? relatedStoreDataStr.split(","):[];
            if (tempData.length > 0) {
                data.total = tempData.length+"";
                var indexID = 0;
                data.rows = $.map(tempData, function (n) {
                    var d = {}
                    d[op.RelatedStoreDataID] = n;
                    d["ID"] = ++indexID + "";
                    return d;
                });
            }

            $('#' + id).datagrid("clearChecked");
            var pageNumber = !!$("#" + id).data("nurPageNumber") ? $("#" + id).data("nurPageNumber") : 1;
            var pageSize = !!$("#" + id).data("nurPageSize") ? $("#" + id).data("nurPageSize") : op.pageSize;
            op.pageNumber = pageNumber;
            op.pageSize = pageSize;

            $('#' + id).datagrid("loadData", data);
            $("#" + id).datagrid('getPager').pagination('refresh', {
                pageNumber: pageNumber,
                pageSize: pageSize,
                total: data.total
            });
        }
    }
    else {
        if ($.type(val) == 'string') {
            $.messager.alert(" ", "元素[" + id + "]赋值格式不正确", "error");
            return;
        }
        if ($("#" + id).length > 0) {
            var StatisticsMergeDis = false;
            var startField = "";
            var mergeFields = [];
            if (!!$("#" + id).data("StatisticsMergeDisColumns")) {
                StatisticsMergeDis = true;
                mergeFields = $("#" + id).data("StatisticsMergeDisColumns");
                startField = mergeFields[0];
            }

            var data = val;
            if ($.isArray(data)) {
                for (var i = 0; i < data.length; i++) {
                    var onerow = data[i];
                    var tempMerge = "";
                    for (var p in onerow) {
                        var name = p;//属性名称
                        if ($.isPlainObject(onerow[p]))
                            continue;
                        var value = onerow[p];//属性对应的值
                    }
                }
            }
            else {
                if (data.total > 0)//和hisUI表格要求的数据格式一致
                {
                    for (var i = 0; i < data.rows.length; i++) {
                        var onerow = data.rows[i];
                        for (var p in onerow) {
                            var name = p;//属性名称
                            var tempMerge = "";
                            if ($.isPlainObject(onerow[p]))
                                continue;
                            var value = onerow[p];//属性对应的值
                        }

                        if (StatisticsMergeDis && (!!onerow.StatisticsInfo && (onerow.StatisticsInfo.type == "TwentyFourHoursStatistics" || onerow.StatisticsInfo.type == "TimeQuantumStatistics"
                        || onerow.StatisticsInfo.type == "DaytimeStatistics" || onerow.StatisticsInfo.type == "SingleItemStatistics"))) {
                            $.each(mergeFields, function (i, field) {
                                onerow[field + "old"] = onerow[field];
                                tempMerge += onerow[field] + " ";
                            });
                            onerow[startField] = tempMerge;
                        }
                    }
                }
            }

            $('#' + id).datagrid("clearChecked");
            var op = $('#' + id).datagrid("options");
            var pageNumber = !!$("#" + id).data("nurPageNumber") ? $("#" + id).data("nurPageNumber") : 1;
            var pageSize = !!$("#" + id).data("nurPageSize") ? $("#" + id).data("nurPageSize") : op.pageSize;
            op.pageNumber = pageNumber;
            op.pageSize = pageSize;

            $('#' + id).datagrid("loadData", data);
            $("#" + id).datagrid('getPager').pagination('refresh', {
                pageNumber: pageNumber,
                pageSize: pageSize,
                total: val.total
            });
        }
    }
}
SingleColumnHISUIDataTableElement.prototype.enable = function (id, val) {
}
SingleColumnHISUIDataTableElement.prototype.disEnable = function (id, val) {
}
SingleColumnHISUIDataTableElement.prototype.getValueByName = function (name) {
    return DataTableCheckRowIds(name);
}

/**
     * 按钮
**/
function ButtonElement() {

}
ButtonElement.prototype = new AbstractElement();
ButtonElement.prototype.banding = function (id, val) {
}
ButtonElement.prototype.enable = function (id, val) {
    if (val) {
        $('#' + id).linkbutton("enable");
    }
    else {
        $('#' + id).linkbutton("disable");
    }
}
ButtonElement.prototype.disEnable = function (id, val) {
    if (val) {
        $('#' + id).linkbutton("disable");
    }
    else {
        $('#' + id).linkbutton("enable");
    }
}


/**
     * 下拉多选输入框
**/
function DropCheckboxElement() {

}
DropCheckboxElement.prototype = new AbstractElement();
/**
     @param { val } 可以是对象{source:[{Text:"",Value:"",NumberValue:""}],values:[{Text:"",Value:"",NumberValue:""}]}和数组[{Text:"",Value:"",NumberValue:""}]
**/
DropCheckboxElement.prototype.banding = function (id, val) {
    var values = [];
    if (!!val && $("#" + id).length > 0) {
        if ($.isPlainObject(val)) {
            if ($.isArray(val.source)) {
                $('#' + id).combobox("loadData", val.source);
                if (val.source.length > 0 && val.source[0].NumberValue !== undefined) {
                    var NumberValuesData = {};
                    $.each(val.source, function (i, n) {
                        NumberValuesData[n.Value] = n.NumberValue;
                    });
                    $('#' + id).data("NumberValues", NumberValuesData);
                }
            } else {
                $.messager.alert(" ", "元素[" + id + "]赋值格式不正确", "error");
                return;
            }
            if ($.isArray(val.values)) {
                values = val.values;
            } else {
                $.messager.alert(" ", "元素[" + id + "]赋值格式不正确", "error");
                return;
            }
        }
        else if ($.isArray(val)) {
            values = val;
        }
        else {
            $.messager.alert(" ", "元素[" + id + "]赋值格式不正确", "error");
            return;
        }
        if ($.isArray(values)) {
            if (values.length > 0) {
                $('#' + id).combobox('setValues', PickDropListValues(values));
                $("#" + id).combobox('options').onSelect.call($('#' + id)[0], values[0]);
            }
            else {//values == []
                $('#' + id).combobox('setValues', values);
                $("#" + id).combobox('options').onSelect.call($('#' + id)[0], undefined);
            }
        }
        $("#" + id).combobox('validate');
    }   
}
DropCheckboxElement.prototype.validate = function (id) {
    $("#" + id).combobox('validate');
}
DropCheckboxElement.prototype.Clear = function (id) {
    $('#' + id).combobox("clear");
}
DropCheckboxElement.prototype.enable = function (id, val) {
    if (val) {
        $('#' + id).combobox("enable");
        $('#' + id).combobox("options").disable = false;
    }
    else {
        $('#' + id).combobox("disable");
        $('#' + id).combobox("options").disable = true;
    }
}
DropCheckboxElement.prototype.SetRequired = function (id, isRequired) {
    $("#" + id).combobox('options').required = isRequired;
    $("#" + id).combobox('textbox').validatebox('options').required = isRequired;
    $("#" + id).combobox('validate');
}
DropCheckboxElement.prototype.isValid = function (id) {
    return $("#" + id).combobox('isValid');
}
DropCheckboxElement.prototype.disEnable = function (id, val) {   
    if (val) {
        $('#' + id).combobox("disable");
        $('#' + id).combobox("options").disable = true;
    }
    else {
        $('#' + id).combobox("enable");
        $('#' + id).combobox("options").disable = false;
    }
}
DropCheckboxElement.prototype.getValueById = function (id) {
    var dataValues = [];
    var values = $("#" + id).combobox("getValues");
    var numberValues = $("#" + id).data("NumberValues");
    values == undefined ? [] : values;
    $.each($("#" + id).combobox("getData"), function (dindex, dvalue) {
        if (values.length == 0)
            return false;
        $.each(values, function (vindex, vvalue) {
            if (vvalue == dvalue.Value)
            {
                if (!!numberValues) {
                    var temp = {};
                    temp.NumberValue = numberValues[dvalue.Value];
                    temp.Text = dvalue.Text;
                    temp.Value = dvalue.Value;
                    dvalue = temp;
                }
                dataValues.push(dvalue);
                return false;
            }
        });

    });


    return dataValues;
}
DropCheckboxElement.prototype.getNumberValueById = function (id,type) {
    var dataValues = this.getValueById(id);
    var numberValues = $("#" + id).data("NumberValues");
    var re = 0;
    if (dataValues.length == 0) {
        return -9999;
    }

    $.each(dataValues, function (dindex, dvalue) {
        var temp = 0;
        if (!!numberValues)
            temp += +numberValues[dataValues[dindex].Value];
        else
            temp += +dataValues[dindex].Value;

        if (type == "max") {
            if (dindex == 0)
                re = temp;
            else if (temp > re)
                re = temp;
        }
        else if (type == "min") {
            if (dindex == 0)
                re = temp;
            else if (temp < re)
                re = temp;
        }
        else {
            re += temp;
        }
    });

    return re;
}
DropCheckboxElement.prototype.getNumberValueFromTableEditRowById = function (id,type) {
	var dataValues = GetTableCellData(id);
    var re = 0;
    if (!dataValues || dataValues.length == 0) {
        return re;
    }

    $.each(dataValues, function (dindex, dvalue) {
        var temp = 0;
        if (dvalue.hasOwnProperty("NumberValue"))
            temp += +dvalue["NumberValue"];
        else
            temp += +dataValues[dindex].Value;

        if (type == "max") {
            if (dindex == 0)
                re = temp;
            else if (temp > re)
                re = temp;
        }
        else if (type == "min") {
            if (dindex == 0)
                re = temp;
            else if (temp < re)
                re = temp;
        }
        else {
            re += temp;
        }
    });

    return re;
}
DropCheckboxElement.prototype.getValueByName = function (name) {
    //由于hisui封装，所以特殊处理
    return this.getValueById(name);
}
DropCheckboxElement.prototype.hasValueByName = function (name) {
    return this.getValueByName(name).length > 0;
}
DropCheckboxElement.prototype.isForm = function () {
    return true;
}
DropCheckboxElement.prototype.UnDoLastActionData = function (id, val) {
    if (val) {
        if ($.isArray(val.source)) {
            if (val.source.length > 0) {
                $('#' + id).combobox("loadData", []);
            }
        } else {
            $.messager.alert(" ", $g("DropCheckboxElement数据格式错误"), "error");
            return;
        }
        if ($.isArray(val.values)) {
            $('#' + id).combobox('setValues',"");
        }
        else {
            $.messager.alert(" ", $g("DropCheckboxElement数据格式错误"), "error");
            return;
        }
    }
}
DropCheckboxElement.prototype.UnDoLastAction = function (id, dataSouce, currentvalue) {
    var oldvalue = $('#' + id).attr('oldVal');
    if (!!oldvalue) {
        oldvalue = jQuery.parseJSON(oldvalue);
        var dataOld = GetDataSource(id, dataSouce, oldvalue);
        if (dataOld) {
            UnDoChangeData(dataOld,currentvalue);
        }
    }
    if (currentvalue!="")
    {
        $('#' + id).attr('oldVal', JSON.stringify(currentvalue));
    }
    else {
        $('#' + id).attr('oldVal', "");
    }
   
}
DropCheckboxElement.prototype.CheckIsTrue = function (ValueByNameOrId, sign, simpleValArry) {
    if (sign == "EqEmptyArray") {
        if (ValueByNameOrId == undefined)
            return true;
        else
            return eval(sign + "(ValueByNameOrId,simpleValArry);");
    }
    if (sign == "EqUnEmptyArray") {
        if (ValueByNameOrId == undefined)
            return false;
        else
            return eval(sign + "(ValueByNameOrId,simpleValArry);");
    }
    var idArr = [];
    for (var i = 0; i < ValueByNameOrId.length; i++) {
        idArr.push(ValueByNameOrId[i].Value);
    }
    var idList = idArr.join(',');
    return eval(sign + "(idList,simpleValArry);");
}
DropCheckboxElement.prototype.isEnable = function (id) {
    return !$('#' + id).combobox("options").disabled;
}
DropCheckboxElement.prototype.hasFocus = function (id) {
    return $("#" + id).parent().children("span").first().children("input").first().is(":focus");
}
DropCheckboxElement.prototype.focus = function (id) {
    return $("#" + id).parent().children("span").first().children("input").first().focus();
}
DropCheckboxElement.prototype.isFocusEnable = function (id) {
    return !$('#' + id).combobox("options").disabled && !IsHidden(id);
}
DropCheckboxElement.prototype.isEqual = function (value, other) {
    var sourceArr = [];
    if ($.isPlainObject(value)) {
        sourceArr = value.values;
    }
    else
        sourceArr = value;
    var otherArr = other;
    var isEq = true;

    if (sourceArr.length != otherArr.length)
        return false;
    $.each(sourceArr, function (i, val) {
        if (!isObjEqual(sourceArr[i], otherArr[i])) {
            isEq = false;
            return false;
        }
    });
    return isEq;
}
DropCheckboxElement.prototype.getExplanation = function (id) {
    var explanation = "";
    explanation = $("#" + id).attr("Explanation");
    if (!explanation)
        return "";
    if ($.type(explanation) === "function")
        return window[explanation](this.getValueById(id));
    else
        return explanation.replace(/\{0\}/, GetComboboxString("text", this.getValueById(id)));
}
DropCheckboxElement.prototype.bindingLeaveMarkLogEvent = function (id) {
    $("#" + id).combobox('textbox').mouseenter(function () {
        OnShowLeaveMarkLog(this, id);
    });
    $("#" + id).combobox('textbox').mouseleave(function () {
        OnHideLeaveMarkLog(this)
    });
}
/**
     * 下拉单选输入框
**/
function DropRadioElement() {

}
DropRadioElement.prototype = new AbstractElement();
/**
     @param { val } 可以是对象{source:[{Text:"",Value:"",NumberValue:""}],values:[{Text:"",Value:"",NumberValue:""}]}和数组[{Text:"",Value:"",NumberValue:""}]
**/
DropRadioElement.prototype.banding = function (id, val) {
    var values = [];
    if (!!val && $("#" + id).length > 0) {
        if ($.isPlainObject(val)) {
            if ($.isArray(val.source)) {
                $('#' + id).DropDropRadio("loadData", val.source);
                if (val.source.length > 0 && val.source[0].NumberValue !== undefined)
                {
                    var NumberValuesData = {};
                    $.each(val.source, function (i, n) {
                        NumberValuesData[n.Value] = n.NumberValue;
                    });
                    $('#' + id).data("NumberValues", NumberValuesData);
                }
            }
            else {
                $.messager.alert(" ", "元素[" + id + "]赋值格式不正确", "error");
                return;
            }
            if ($.isArray(val.values)) {
                values = val.values;
            }
            else {
                $.messager.alert(" ", "元素[" + id + "]赋值格式不正确", "error");
                return;
            }
        }
        else if ($.isArray(val)) {
            values = val;
        }
        else {
            $.messager.alert(" ", "元素[" + id + "]赋值格式不正确", "error");
            return;
        }
        if ($.isArray(values)) {
            if (values.length > 0){
                if (values[0].Value == "")//自定义编辑输入或者来自数据源
                {
                    var findValue = [];
                    $.each($("#" + id).combobox("getData"), function (dindex, dvalue) {
                        if (dvalue.Text === values[0].Text) {
                            findValue.push(dvalue.Value);
                            return false;
                        }
                    });
                    if (findValue.length > 0)
                        $('#' + id).combobox('setValues', findValue);
                    else {
                        $('#' + id).combobox('setValues', []);
                        $('#' + id).combobox('setText', values[0].Text);
                    }
                }
                else {
                    $('#' + id).DropDropRadio('setValues', PickDropListValues(values));
                    $("#" + id).combobox('options').onSelect.call($('#' + id)[0], values[0]);
                }
            }
            else {//values == []
                $('#' + id).DropDropRadio('setValues', values);
                $("#" + id).combobox('options').onSelect.call($('#' + id)[0], undefined);
            }
        }
        $("#" +id).combobox('validate');
    }  
}
DropRadioElement.prototype.validate = function (id) {
    $("#" + id).combobox('validate');
}
DropRadioElement.prototype.Clear = function (id) {
    $('#' + id).DropDropRadio("clear");
}
DropRadioElement.prototype.SetRequired = function (id, isRequired) { 
    $("#" + id).combobox('options').required = isRequired;
    $("#" + id).combobox('textbox').validatebox('options').required = isRequired;
    $("#" + id).combobox('validate');
}
DropRadioElement.prototype.isValid = function (id) {
    return $("#" + id).combobox('isValid');
}
DropRadioElement.prototype.enable = function (id, val) {
    if (val) {
        $('#' + id).combobox("enable");
        $('#' + id).combobox("options").disable = false;
    }
    else {
        $('#' + id).combobox("disable");
        $('#' + id).combobox("options").disable = true;
    }
}
DropRadioElement.prototype.disEnable = function (id, val) {
    if (val) {
        $('#' + id).combobox("disable");
        $('#' + id).combobox("options").disable = true;
    }
    else {
        $('#' + id).combobox("enable");
        $('#' + id).combobox("options").disable = false;
    }
}
DropRadioElement.prototype.getValueById = function (id) {

    var dataValues = [];
    var values = $("#" + id).DropDropRadio("getValues");
    var numberValues = $("#" + id).data("NumberValues");
    $.each($("#" + id).DropDropRadio("getData"), function (dindex, dvalue) {
        if (values.length == 0)
            return false;

        $.each(values, function (vindex, vvalue) {
            if (vvalue == dvalue.Value) {
                if (!!numberValues)
                {
                    var temp = {};
                    temp.NumberValue = numberValues[dvalue.Value];
                    temp.Text = dvalue.Text;
                    temp.Value = dvalue.Value;
                    dvalue = temp;
                }
                dataValues.push(dvalue);
                return false;
            }
        });

    });


    return dataValues;
}
DropRadioElement.prototype.getNumberValueById = function (id) {
    var dataValues = this.getValueById(id);
    var numberValues = $("#" + id).data("NumberValues");
    if (dataValues.length == 0) {
        return -9999;
    }
    if (!!numberValues)
        return numberValues[dataValues[0].Value];
    else
        return dataValues[0].Value;
}
DropRadioElement.prototype.getNumberValueFromTableEditRowById = function (id) {
	var dataValues = GetTableCellData(id);
    var re = 0;
    if (!dataValues || dataValues.length == 0) {
        return re;
    }

    $.each(dataValues, function (dindex, dvalue) {
        if (dvalue.hasOwnProperty("NumberValue"))
            re += +dvalue["NumberValue"];
        else
            re += +dataValues[dindex].Value;
    });

    return re;
}
DropRadioElement.prototype.getValueByName = function (name) {
    //由于hisui封装，所以特殊处理
    return this.getValueById(name);
}
DropRadioElement.prototype.hasValueByName = function (name) {
    return this.getValueByName(name).length > 0;
}
DropRadioElement.prototype.isForm = function () {
    return true;
}
DropRadioElement.prototype.UnDoLastActionData = function (id, val) {
    if (val) {
        if ($.isArray(val.source)) {
            if (val.source.length > 0) {
                $('#' + id).DropDropRadio("loadData", []);
            }
        }
        else {
            $.messager.alert(" ", $g("DropRadioElement数据格式错误"), "error");
            return;
        }
        if ($.isArray(val.values)) {
            $('#' + id).DropDropRadio('setValues',"");
        }
        else {
            $.messager.alert(" ", $g("DropRadioElement数据格式错误"), "error");
            return;
        }
    }
}
DropRadioElement.prototype.UnDoLastAction = function (id, dataSouce, currentvalue) {
    var oldvalue = $('#' + id).attr('oldVal');
    if (!!oldvalue) {
        oldvalue = jQuery.parseJSON(oldvalue);
        var dataOld = GetDataSource(id, dataSouce, oldvalue);
        if (dataOld) {
            UnDoChangeData(dataOld,currentvalue);
        }
    }
    if (!!currentvalue) {
        $('#' + id).attr('oldVal', JSON.stringify(currentvalue));
    }
    else {
        $('#' + id).attr('oldVal', "");
    }

}
DropRadioElement.prototype.CheckIsTrue = function (ValueByNameOrId, sign, simpleValArry) {
    if (sign == "EqEmptyArray") {
        if (ValueByNameOrId == undefined)
            return true;
        else
            return eval(sign + "(ValueByNameOrId,simpleValArry);");
    }
    if (sign == "EqUnEmptyArray") {
        if (ValueByNameOrId == undefined)
            return false;
        else
            return eval(sign + "(ValueByNameOrId,simpleValArry);");
    }
    var currentVal = undefined;
    if ($.isArray(ValueByNameOrId)) {
        if (ValueByNameOrId.length == 0)
            currentVal = "";
        else
            currentVal = ValueByNameOrId[0].Value;
    }
    if (currentVal === undefined) {
        return false;
    }
    return eval(sign + "(currentVal,simpleValArry);");
}
DropRadioElement.prototype.isEnable = function (id) {
    return !$('#' + id).combobox("options").disabled;
}
DropRadioElement.prototype.hasFocus = function (id) {
    return $("#" + id).parent().children("span").first().children("input").first().is(":focus");
}
DropRadioElement.prototype.focus = function (id) {
    return $("#" + id).parent().children("span").first().children("input").first().focus();
}
DropRadioElement.prototype.isFocusEnable = function (id) {
    return !$('#' + id).combobox("options").disabled && !IsHidden(id);
}
DropRadioElement.prototype.isEqual = function (value, other) {    
    var sourceArr = [];
    if ($.isPlainObject(value)) {
        sourceArr = value.values;
    }
    else
        sourceArr = value;
    var otherArr = other;
    var isEq = true;

    if (sourceArr.length != otherArr.length)
        return false;
    $.each(sourceArr, function (i, val) {
        if (!isObjEqual(sourceArr[i], otherArr[i]))
        {
            isEq = false;
            return false;
        }
    });
    return isEq;
}
DropRadioElement.prototype.getExplanation = function (id) {
    var explanation = "";
    explanation = $("#" + id).attr("Explanation");
    if (!explanation)
        return "";
    if ($.type(explanation) === "function")
        return window[explanation](this.getValueById(id));
    else
        return explanation.replace(/\{0\}/, GetComboboxString("text", this.getValueById(id)));
}
DropRadioElement.prototype.bindingLeaveMarkLogEvent = function (id) {
    $("#" + id).combobox('textbox').mouseenter(function () {
        OnShowLeaveMarkLog(this, id);
    });
    $("#" + id).combobox('textbox').mouseleave(function () {
        OnHideLeaveMarkLog(this)
    });
}
/**
     * 链接
**/
function LinkElement() {

}
LinkElement.prototype = new AbstractElement();
LinkElement.prototype.banding = function (id, val) {
}
LinkElement.prototype.enable = function (id, val) {
}
LinkElement.prototype.disEnable = function (id, val) {
}

/**
     * 隐藏输入域
**/
function HiddenTextElement() {

}
HiddenTextElement.prototype = new AbstractElement();
HiddenTextElement.prototype.banding = function (id, val) {
    if ($.isArray(val)) {
        $.messager.alert(" ", "元素[" + id + "]赋值格式不正确", "error");
        return;
    }
    if ($('#' + id).length > 0) {
        $('#' + id).val(val);
        var e = $._data($("#" + id)[0], "events");
        if (e && e["change"])
            $('#' + id).change();
    }
}
HiddenTextElement.prototype.enable = function (id, val) {
    if (val) {
        $('#' + id).removeAttr("disabled");
    }
    else {
        $("#" + id).attr("disabled", "disabled");
    }
}
HiddenTextElement.prototype.disEnable = function (id, val) {
    if (val) {
        $("#" + id).attr("disabled", "disabled");
    }
    else {
        $('#' + id).removeAttr("disabled");
    }
}
HiddenTextElement.prototype.isValid = function (id) {
    return $("#" + id).validatebox('isValid');
}
HiddenTextElement.prototype.getValueById = function (id) {
    var value = "";
    value = $('#' + id).val();
    return value;
}
HiddenTextElement.prototype.getNumberValueById = function (id) {
    var values = this.getValueById(id);
    return values;
}
HiddenTextElement.prototype.getNumberValueFromTableEditRowById = function (id) {
	return GetTableCellData(id);
}
HiddenTextElement.prototype.getValueByName = function (name) {
    var id = $("input[name=" + name + "]").attr("id");
    return this.getValueById(id);
}
HiddenTextElement.prototype.hasValueByName = function (name) {
    return this.getValueByName(name) != "";
}
HiddenTextElement.prototype.isForm = function () {
    return true;
}
HiddenTextElement.prototype.UnDoLastActionData = function (id, val) {
    $('#' +id).val("");
}
HiddenTextElement.prototype.UnDoLastAction = function (id, dataSouce, currentvalue) {
    var oldvalue = $('#' + id).attr('oldVal');
    if (!!oldvalue) {
        var dataOld = GetDataSource(id, dataSouce, oldvalue);
        if (dataOld) {
            UnDoChangeData(dataOld,currentvalue);
        }
    }
    $('#' + id).attr('oldVal', currentvalue);
}
HiddenTextElement.prototype.CheckIsTrue = function (ValueByNameOrId, sign, simpleValArry) {
    var textvalue = ValueByNameOrId;
    return eval(sign + "(textvalue,simpleValArry);");    
}

window.ElementUtility = {
    LableElement: new LableElement(),
    MutiLableElement: new MutiLableElement(),
    CheckElement: new CheckElement(),
    DropListElement: new DropListElement(),
    RadioElement: new RadioElement(),
    DateElement: new DateElement(),
    TextareaElement: new TextareaElement(),
    TextElement: new TextElement(),
    TimeElement: new TimeElement(),
    NumberElement: new NumberElement(),
    HLineElement: new HLineElement(),
    VLineElement: new VLineElement(),
    ImgElement: new ImgElement(),
    RowToColDataTableElement: new RowToColDataTableElement(),
    HISUIDataTableElement: new HISUIDataTableElement(),
    SingleColumnHISUIDataTableElement: new SingleColumnHISUIDataTableElement(),
    ButtonElement: new ButtonElement(),
    DropCheckboxElement: new DropCheckboxElement(),
    DropRadioElement: new DropRadioElement(),
    LinkElement: new LinkElement(),
    HiddenTextElement: new HiddenTextElement()
}