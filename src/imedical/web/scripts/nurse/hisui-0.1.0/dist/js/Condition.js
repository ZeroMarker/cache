
function DisEnableList(list,isEnable)
{
    for (var i = 0; i < list.length;i++)
    {
        var id = list[i];
        DisEnableOne(id, isEnable);
    }
}
function EnableList(list, isEnable) {
    for (var i = 0; i < list.length; i++) {
        var id = list[i];
       EnableOne(id, isEnable);
    }
}
//最大值
function NumberMax(list){
    var val = "";
    var numResult = null;
    var hasVal = false;
    for (var i = 0; i < list.length; i++) {
        var id = list[i];
        var tem = GetNumberValueById(id,"max");
        if (tem != -9999) {//-9999表示无效值
            var num = ToNumber(tem);
            if (num != -9999) {
                hasVal = true;
                if (numResult == null) {
                    numResult = num;
                }
                else if (num > numResult) {
                    numResult = num;
                }
            }
        }
    }
    if (hasVal)
        return numResult;
    else
        return val;
}
//最小值
function NumberMin(list) {
    var val = "";
    var numResult = null;
    var hasVal = false;
    for (var i = 0; i < list.length; i++) {
        var id = list[i];
        var tem = GetNumberValueById(id,"min");
        if (tem != -9999) {//-9999表示无效值
            var num = ToNumber(tem);
            if (num != -9999) {
                hasVal = true;
                if (numResult == null) {
                    numResult = num;
                }
                else if (num < numResult) {
                    numResult = num;
                }
            }
        }
    }
    if (hasVal)
        return numResult;
    else
        return val;
}
function NumberSum(list) {
    var val = "";
    var numResult = 0;
    var hasVal = false;
    for (var i = 0; i < list.length; i++) {
        var id = list[i];
        var tem = GetNumberValueById(id,"none");
        if (tem != -9999) {//-9999表示无效值
            var num = ToNumber(tem);
            if (num != -9999) {
                hasVal = true;
                numResult += num;
            }
        }     
    }
    if (hasVal)
        return numResult;
    else
        return val;
}
function TextMerge(list,delimiter) {
    var val = [];
    for (var i = 0; i < list.length; i++) {
        var id = list[i];
        var temp = GetValueByName(id);
        if ($.isArray(temp)) {
            temp = GetComboboxString("text", temp);
        }
        val.push(temp);
    }
    var filterArr =$.grep(val, function (n, i) {
        return !!n;
    });
    return filterArr.join(delimiter);
}
function ShowList(list, isEnable) {
    for (var i = 0; i < list.length; i++) {
        var id = list[i];
        ShowOne(id, isEnable);
    }
}
function HideList(list, isEnable) {
    for (var i = 0; i < list.length; i++) {
        var id = list[i];
        HideOne(id, isEnable);
    }
}
function ShowOne(id, isShow)
{
    var parentId = "div_" + id;
    var obj = $("#" + parentId);
    if (obj.length == 0)
        return;
    if (isShow) {
        obj.show();
    }
    else {
        obj.hide();
    }
    var testReg = /^edit/;
    if (!testReg.test(id)) {
        //通过子元素判断父元素 --add by yao 20191105
        ShowWithParent($("#" + "div_" + id), isShow);
    }
    else if (IsTableCellEdit(GetTableIdByIndentity(id))) {
        UpdateEditCellNotEditStatus(id,isShow);
    }
}
function IsHidden(id)
{
    var parentId = "div_" + id;
    var obj = $("#" + parentId);

    return obj.css("display") == "none";
}
function IsEnable(id) {
    var helper = GetElementHelper(id);
    return helper.isEnable(id);
}
function HideOne(id, isShow) {
    ShowOne(id, !isShow);
}
function DisEnableOne(id, val) {
    var testReg = /^edit/;
    var helper = GetElementHelper(id);
    if (testReg.test(id) && IsTableCellEdit(GetTableIdByIndentity(id))) {
        if ($("#" + id).length > 0) {
            if (helper != undefined)
                helper.disEnable(id, val);
            UpdateEditCellNotEditStatus(id, !val);
        }
        else {
            UpdateEditCellNotEditStatus(id, !val);
        }       
    }
    else
    {
        if (helper != undefined)
            helper.disEnable(id, val);
    }
}
function EnableOne(id, val) {
    var testReg = /^edit/;
    var helper = GetElementHelper(id);
    if (testReg.test(id) && IsTableCellEdit(GetTableIdByIndentity(id))) {
        if ($("#" + id).length > 0) {
            if (helper != undefined)
                helper.enable(id, val);
            UpdateEditCellNotEditStatus(id, val);
        }
        else {
            UpdateEditCellNotEditStatus(id, val);
        }
    }
    else {
        if (helper != undefined)
            helper.enable(id, val);
    }
}
function SetOneValue(id, val)
{
    var helper = GetElementHelper(id);
	var testReg = /^edit/;
    if (testReg.test(id) && IsTableCellEdit(GetTableIdByIndentity(id))) {
		SetTableCellData(id,val);
	}
	else {		
    if (helper != undefined)
        helper.banding(id, val);

	}
}
function ToNumber(tempValue) {
    var t = parseFloat(tempValue);
    if (isNaN(t))
        return -9999;//表示无效值
    else
        return t;
}
function GetValueById(id) {
    var value = "";
	var testReg = /^edit/;
	var helper = GetElementHelper(id);
    if (testReg.test(id) && IsTableCellEdit(GetTableIdByIndentity(id))) {
		value = GetTableCellData(id);
	}
	else 	
    {
        if (helper != undefined)
            value = helper.getValueById(id);
    }
	return value;
}
function GetNumberValueById(id,type) {

	var value = "";
	var testReg = /^edit/;
	var helper = GetElementHelper(id);
    if (testReg.test(id) && IsTableCellEdit(GetTableIdByIndentity(id))) {
		if (helper != undefined){
			value = helper.getNumberValueFromTableEditRowById(id,type);
		}		
	}
	else 	
    {
		if (helper != undefined)
			value = helper.getNumberValueById(id,type);
	}
    return value;	
}
function GetValueByName(formName) {
	var id = formName;
    var value = "";
	var testReg = /^edit/;
	var helper = GetElementHelper(id);
    if (testReg.test(id) && IsTableCellEdit(GetTableIdByIndentity(id))) {
		value = GetTableCellData(id);
	}
	else 	
    {
		if (helper != undefined)
			value = helper.getValueByName(formName);
    }
	return value;
}
function HasValueByName(formName)
{
    var id = formName;
    var hasValue = false;
    var testReg = /^edit/;
    var helper = GetElementHelper(id);
    if (testReg.test(id) && IsTableCellEdit(GetTableIdByIndentity(id))) {
        var value = GetTableCellData(id);
        if (!!value) {
            hasValue = true;
            if ($.isArray(value) && value.length == 0)
                hasValue = false;         
        } 
    }
    else {
        if (helper != undefined)
            hasValue = helper.hasValueByName(formName);
    }
    return hasValue;
}
//只有被隐藏的对象在容器里时，才需要递归处理容器本身。规则是：容器里只有被隐藏的对象时，容器才被隐藏。
function ShowWithParent(currentEl, isShow) {
    var ContainerEle = currentEl.parent().parent();
    if (!ContainerEle) return;
    var testReg = /^Container/;
    if (!testReg.test($(ContainerEle).attr("id")))
        return;
    var lineAreas = ContainerEle.children();
    
    var hasFlag = false;

    for (var j = 0; j < lineAreas.length; j++) {

        var childs = $(lineAreas[j]).children();

        for (var i = 0; i < childs.length; i++) {
            if ($(childs[i]).hasClass("clearboth"))
                continue;
            if ($(childs[i]).css('display') != 'none') {
                hasFlag = true;
                break;
            }
        }
    }
    
	if (isShow) {
		if (hasFlag == true) {
		    ContainerEle.show();
		    ShowWithParent(ContainerEle, isShow);
		}
    }
    else {
		if (hasFlag == false) {
		    ContainerEle.hide();
		    ShowWithParent(ContainerEle, isShow);  //如果有多个上级元素，需要迭代判断。
		}
    }
}
function GetElementHelper(id)
{
    var type = GetElementStringType(id);
    if (!!type) {
        var helpler = ElementUtility[type];
        if (!!helpler)
            helpler.elementId = id;
        return helpler;
    }
    return undefined;
}
function SetOneRequired(ID, isRequired) {
    var helper = GetElementHelper(ID);
    if (helper != undefined)
        helper.SetRequired(ID, isRequired);
}




