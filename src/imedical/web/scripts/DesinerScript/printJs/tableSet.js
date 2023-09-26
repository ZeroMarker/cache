var indexTemp = null;

$(document).ready(function() {
    $("#txtCtrl-Width").keydown(number_onkeyDown);
    $("#btnAdd").click(addCol);
    $("#btnUpdate").click(updateCol);
    $("#btnDelete").click(deleteCol);
    $("#btnMoveUp").click(moveUpCol);
    $("#btnMoveDown").click(moveDownCol);
    $("#ddpAllCol").change(selectCol);
    $("#btnConfirm").click(confirm);
    $("#btnCancel").click(cancel);
    var allColumns = window.dialogArguments;
    showColumns(allColumns);
});

//数字控件鼠标按下时的处理
//1-9  tab    backspace  clear shift ctrl ALT Delete a  c  v  x  z
function number_onkeyDown() {
    if ((window.event.keyCode >= 48 && window.event.keyCode <= 57) || (window.event.keyCode >= 96 && window.event.keyCode <= 105) ||
			window.event.keyCode == 109 || window.event.keyCode == 110 || window.event.keyCode == 8 || window.event.keyCode == 9 ||
			window.event.keyCode == 13 || window.event.keyCode == 12 || window.event.keyCode == 16 || window.event.keyCode == 17 || window.event.keyCode == 18 ||
			window.event.keyCode == 46 || (window.event.keyCode == 65 && event.ctrlKey == true) || (window.event.keyCode == 67 && event.ctrlKey == true) ||
			(window.event.keyCode == 88 && event.ctrlKey == true) || (window.event.keyCode == 90 && event.ctrlKey == true) || (window.event.keyCode >= 33 && window.event.keyCode <= 40)) {
        return true;
    }
    else {
        event.returnValue = false;
        return false;
    }
}

//添加列
function addCol() {
    var colName = document.getElementById("txtName").value;
    var colWidth = document.getElementById("txtCtrl-Width").value;
    var colPrintValue = document.getElementById("txtDefaultValue").value;
    if ($.trim(colName) != "" && $.trim(colWidth) != "") {
        indexTemp = indexTemp + 1;
        var varItem = new Option($.trim(document.getElementById("txtName").value), indexTemp);
        varItem.colWidth = colWidth;
        varItem.printValue = $.trim(colPrintValue);
        document.getElementById("ddpAllCol").options.add(varItem);
        setState();
    }
    else {
        if ($.trim(colName) == "") {
            alert("字段名不能为空!");
        }
        else {
            alert("宽度不能为空!");
        }
    }
}

//更新列
function updateCol() {
    var colName = document.getElementById("txtName").value;
    var colWidth = document.getElementById("txtCtrl-Width").value;
    var colPrintValue = document.getElementById("txtDefaultValue").value;
    if ($.trim(colName) != "" && $.trim(colWidth) != "") {
        var item = getItem();
        item.innerText = colName;
        item.colWidth = colWidth;
        item.printValue = $.trim(colPrintValue);
    }
    else {
        if ($.trim(colName) == "") {
            alert("字段名不能为空!");
        }
        else {
            alert("宽度不能为空!");
        }
    }
}

//删除列
function deleteCol() {
    var ctrlAllCol = document.getElementById("ddpAllCol");
    var value = ctrlAllCol.value;
    for (var index = 0; index < ctrlAllCol.options.length; index++) {
        if (ctrlAllCol.options[index].value == value) {
            ctrlAllCol.options.remove(index);
            setState();
            return;
        }
    }
}

//上移列
function moveUpCol() {
    var ctrlAllCol = document.getElementById("ddpAllCol");
    var value = ctrlAllCol.value;
    for (var index = 0; index < ctrlAllCol.options.length; index++) {
        if (ctrlAllCol.options[index].value == value) {
            var item = ctrlAllCol.options[index];
            var preIndex = index - 1;
            if (preIndex > -1) {
                var preItem = ctrlAllCol.options[preIndex];
                ctrlAllCol.options.removeChild(item);
                ctrlAllCol.options.insertBefore(item, preItem);
            }
            return;
        }
    }
}

//下移列
function moveDownCol() {
    var ctrlAllCol = document.getElementById("ddpAllCol");
    var value = ctrlAllCol.value;
    for (var index = 0; index < ctrlAllCol.options.length; index++) {
        if (ctrlAllCol.options[index].value == value) {
            var item = ctrlAllCol.options[index];
            var nextIndex = index + 2;
            if (nextIndex < ctrlAllCol.length) {
                var nextItem = ctrlAllCol.options[nextIndex];
                ctrlAllCol.options.removeChild(item);
                ctrlAllCol.options.insertBefore(item, nextItem);
            }
            else if (nextIndex == ctrlAllCol.length) {
                ctrlAllCol.options.removeChild(item);
                ctrlAllCol.options.insertBefore(item);
            }
            return;
        }
    }
}

//选中某项
function selectCol() {
    var item = getItem();
    if (item != null) {
        document.getElementById("txtName").value = item.innerText;
        document.getElementById("txtCtrl-Width").value = item.colWidth;
        document.getElementById("txtDefaultValue").value = item.printValue;
    }
    setState();
}

//显示所有列
function showColumns(allColumns) {
    var count = allColumns.length;
    var ctrlAllCol = document.getElementById("ddpAllCol");
    for (var index = 0; index < count; index++) {
        var varItem = new Option(allColumns[index].name, index);
        varItem.colWidth = allColumns[index].style.width.replace("px", "");
        varItem.printValue = allColumns[index].innerText;
        ctrlAllCol.options.add(varItem);
    }
    indexTemp = count - 1;
    setState();
}

//取得当前选中的项
function getItem() {
    var ctrlAllCol = document.getElementById("ddpAllCol");
    var value = ctrlAllCol.value;
    for (var index = 0; index < ctrlAllCol.options.length; index++) {
        if (ctrlAllCol.options[index].value == value) {
            return ctrlAllCol.options[index];
        }
    }
    return null;
}

//设定状态
function setState() {
    if (getItem() != null) {
        document.getElementById("btnDelete").disabled = false;
        document.getElementById("btnUpdate").disabled = false;
        document.getElementById("btnMoveUp").disabled = false;
        document.getElementById("btnMoveDown").disabled = false;
    }
    else {
        document.getElementById("btnDelete").disabled = true;
        document.getElementById("btnUpdate").disabled = true;
        document.getElementById("btnMoveUp").disabled = true;
        document.getElementById("btnMoveDown").disabled = true;
        document.getElementById("txtName").value = "";
        document.getElementById("txtCtrl-Width").value = "";
        document.getElementById("txtDefaultValue").value = "";
    }
}

function confirm() {
    var tdItemArray = new Array();
    var ctrlAllCol = document.getElementById("ddpAllCol");
    if (ctrlAllCol.options.length == 0) {
        alert("没有设置列");
        return;
    }
    for (var index = 0; index < ctrlAllCol.options.length; index++) {
        var tdItem = new Object();
        var varItem = ctrlAllCol.options[index];
        tdItem.width = varItem.colWidth;
        tdItem.name = varItem.innerText;
        tdItem.printValue = varItem.printValue;
        tdItemArray.push(tdItem);
    }
    window.returnValue = tdItemArray;
    window.close();  
}

function cancel() {
    window.returnValue = null;
    window.close();  
}
