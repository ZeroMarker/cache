var desinerSelCtrl = null;
$(document).ready(function() {
    $(".numberStyle").keydown(number_onkeyDown);
    $(".numberStyle").focusout(setCtrlAttr);
    $(".selStyle").change(setCtrlAttr);
    $(".txtStyle").focusout(setCtrlAttr);
    $(".txtStyle").keydown(txt_onkeyDown);
    $("#btnSetCol").click(setTable);
    $("#txtName").keyup(txt_onkeyup);
    $("#txtDefaultValue").keyup(txt_Removechar);
});

//数字控件鼠标按下时的处理
//1-9  tab    backspace  clear shift ctrl ALT Delete a  c  v  x  z
function number_onkeyDown() {
    if ((window.event.keyCode >= 48 && window.event.keyCode <= 57) || (window.event.keyCode >= 96 && window.event.keyCode <= 105) ||
			window.event.keyCode == 109 || window.event.keyCode == 110 || window.event.keyCode == 8 || window.event.keyCode == 9 ||
			window.event.keyCode == 13 || window.event.keyCode == 12 || window.event.keyCode == 16 || window.event.keyCode == 17 || window.event.keyCode == 18 ||
			window.event.keyCode == 46 || (window.event.keyCode == 65 && event.ctrlKey == true) || (window.event.keyCode == 67 && event.ctrlKey == true) ||
			(window.event.keyCode == 88 && event.ctrlKey == true) || (window.event.keyCode == 90 && event.ctrlKey == true) || (window.event.keyCode >= 33 && window.event.keyCode <= 40)) {
        if (window.event.keyCode == 13) {
            setCtrlAttr();
        }
        return true;
    }
    else {
        event.returnValue = false;
        return false;
    }
}

function txt_onkeyup() {
    var ctrl = window.event.srcElement;
    ctrl.value = ctrl.value.replace(/\W/g, '');
}

function txt_Removechar() {
    var ctrl = window.event.srcElement;
    ctrl.value = ctrl.value.replace(/</g, '');
    ctrl.value = ctrl.value.replace(/>/g, '');
    ctrl.value = ctrl.value.replace(/&/g, '');
    ctrl.value = ctrl.value.replace(/\"/g, '');
}

//文本控件鼠标按下时的处理
function txt_onkeyDown() {
    if (window.event.keyCode == 13) {
        setCtrlAttr();
    }
}

//显示控件的属性
function showCtrlAttr() {
    hideAll();
    var selCtrls = parent.frLayout.editor.options.selectCtrls;
    if (selCtrls.length != 1) {
        if (selCtrls.length == 0) {
            desinerSelCtrl = parent.frLayout.editor.options.bdLayout;
            document.getElementById("trCtrl-Height").style.display = "block";
            document.getElementById("txtCtrl-Height").setAttribute("value", desinerSelCtrl.style.height.replace("px", ""));
            document.getElementById("trCtrl-Width").style.display = "block";
            document.getElementById("txtCtrl-Width").setAttribute("value", desinerSelCtrl.style.width.replace("px", ""));
            document.getElementById("trPrtPaperSet").style.display = "block";
            if (desinerSelCtrl.PrtPaperSet) {
                document.getElementById("ddpPrtPaperSet").value = desinerSelCtrl.PrtPaperSet;
            }
            else {
                document.getElementById("ddpPrtPaperSet").value = "HAND";
            }
            document.getElementById("trPrtDirection").style.display = "block";
            if (desinerSelCtrl.LandscapeOrientation) {
                document.getElementById("ddpPrtDirection").value = desinerSelCtrl.LandscapeOrientation;
            }
            else {
                document.getElementById("ddpPrtDirection").value = "Y";
            }
        }
        else {
            desinerSelCtrl = null;
        }
        return;
    }
    desinerSelCtrl = selCtrls[0];
    if (desinerSelCtrl.ctrlType != "listitem") {
        document.getElementById("trRePrt").style.display = "block";
        if (desinerSelCtrl.RePrtHeadFlag) {
            document.getElementById("ddpRePrt").value = desinerSelCtrl.RePrtHeadFlag;
        }
        else {
            document.getElementById("ddpRePrt").value = "N";
        }
    }

    document.getElementById("trCtrl-X").style.display = "block";
    document.getElementById("txtCtrl-X").value = desinerSelCtrl.style.left.replace("px", "");
    document.getElementById("trCtrl-Y").style.display = "block";
    document.getElementById("txtCtrl-Y").value = desinerSelCtrl.style.top.replace("px", "");
    if (desinerSelCtrl.ctrlType == "list") {
        document.getElementById("trPageRows").style.display = "block";
        if (desinerSelCtrl.PageRows) {
            document.getElementById("txtPageRows").value = desinerSelCtrl.PageRows;
        }
        else {
            document.getElementById("txtPageRows").value = "10";
        }
        document.getElementById("trCurrentRow").style.display = "block";
        if (desinerSelCtrl.CurrentRow != undefined) {
            document.getElementById("txtCurrentRow").value = desinerSelCtrl.CurrentRow;
        }
        else {
            document.getElementById("txtCurrentRow").value = "1";
        }
        document.getElementById("trTableHeight").style.display = "block";
        document.getElementById("txtTableHeight").value = desinerSelCtrl.style.height.replace("px", "");
        document.getElementById("trRowPad").style.display = "block";
        if (desinerSelCtrl.XStep) {
            document.getElementById("txtRowPad").value = desinerSelCtrl.XStep;
        }
        else {
            document.getElementById("txtRowPad").value = 0;
        }
        return;
    }
    if (desinerSelCtrl.ctrlType == "shape") {
        document.getElementById("trCtrl-Height").style.display = "block";
        document.getElementById("txtCtrl-Height").setAttribute("value", desinerSelCtrl.style.height.replace("px", ""));
        document.getElementById("trCtrl-Width").style.display = "block";
        document.getElementById("txtCtrl-Width").setAttribute("value", desinerSelCtrl.style.width.replace("px", ""));

        document.getElementById("trLineType").style.display = "block";
        document.getElementById("ddpLineType").value = desinerSelCtrl.lineType;
//        if (desinerSelCtrl.from.x == desinerSelCtrl.to.x) {
//            document.getElementById("ddpLineType").value = "2";
//        }
//        else if (desinerSelCtrl.from.y == desinerSelCtrl.to.y) {
//            document.getElementById("ddpLineType").value = "1";
//        }
//        else if (desinerSelCtrl.from.x == 0 && desinerSelCtrl.to.y == 0) {
//            document.getElementById("ddpLineType").value = "3";
//        }
//        else if (desinerSelCtrl.from.y == 0 && desinerSelCtrl.to.x == 0) {
//            document.getElementById("ddpLineType").value = "4";
//        }
        return;
    }
    if (selCtrls[0].ctrlType == "img") {
        document.getElementById("trCtrlName").style.display = "block";
        document.getElementById("txtName").value = desinerSelCtrl.name;
        document.getElementById("trCtrlDefaultValue").style.display = "block";
        document.getElementById("txtDefaultValue").value = desinerSelCtrl.src;
        document.getElementById("trCtrl-Height").style.display = "block";
        document.getElementById("txtCtrl-Height").setAttribute("value", desinerSelCtrl.style.height.replace("px", ""));
        document.getElementById("trCtrl-Width").style.display = "block";
        document.getElementById("txtCtrl-Width").setAttribute("value", desinerSelCtrl.style.width.replace("px", ""));
        return;
    }
    document.getElementById("trCtrlFontSize").style.display = "block";
    if (desinerSelCtrl.style.fontSize) {
        document.getElementById("txtFontSize").value = desinerSelCtrl.style.fontSize.replace("pt", "");
    }
    else {
        document.getElementById("txtFontSize").value = "12";
    }
    document.getElementById("trCtrlFontBold").style.display = "block";
    if (desinerSelCtrl.style.fontWeight == "bold") {
        document.getElementById("ddpFontBold").value = "true";
    }
    else {
        document.getElementById("ddpFontBold").value = "false";
    }
    document.getElementById("trCtrlFontName").style.display = "block";
    if (desinerSelCtrl.style.fontFamily) {
        document.getElementById("ddpFontName").value = desinerSelCtrl.style.fontFamily;
    }
    else {
        document.getElementById("ddpFontName").value = "宋体";
    }
    if (desinerSelCtrl.ctrlType == "label" || desinerSelCtrl.ctrlType == "listitem") {
        document.getElementById("trCtrlName").style.display = "block";
        document.getElementById("txtName").value = desinerSelCtrl.name;
        if (desinerSelCtrl.ctrlType == "label") {
            document.getElementById("trCtrlDefaultValue").style.display = "block";
            if (desinerSelCtrl.defaultvalue == "true") {
                document.getElementById("txtDefaultValue").value = desinerSelCtrl.innerText;
            }
            else {
                document.getElementById("txtDefaultValue").value = "";
            }
        }
		//Lid 2015-11-01 给文本控件添加二维码属性
		document.getElementById("trCtrlIsQRCode").style.display = "block";
        if (desinerSelCtrl.isqrcode) {
            document.getElementById("ddpIsQRCode").value = desinerSelCtrl.isqrcode;
        }
        else {
            document.getElementById("ddpIsQRCode").value = "N";
        }
		document.getElementById("trCtrlQRWidth").style.display = "block";
		if(desinerSelCtrl.width){
			document.getElementById("txtQRWidth").value = desinerSelCtrl.width;
		}else{
			document.getElementById("txtQRWidth").value = 30;
		}
		document.getElementById("trCtrlQRHeight").style.display = "block";
        if(desinerSelCtrl.height){
			document.getElementById("txtQRHeight").value = desinerSelCtrl.height;
		}else{
			document.getElementById("txtQRHeight").value = 30;
		}
    }

    if (desinerSelCtrl.ctrlType == "reporttable") {
        document.getElementById("trPageRows").style.display = "block";
        if (desinerSelCtrl.PageRows) {
            document.getElementById("txtPageRows").value = desinerSelCtrl.PageRows;
        }
        else {
            document.getElementById("txtPageRows").value = "10";
        }
        document.getElementById("trReportCol").style.display = "block";
        document.getElementById("trTableHeight").style.display = "block";
        document.getElementById("txtTableHeight").value = desinerSelCtrl.style.height.replace("px", "");
        document.getElementById("trRowPad").style.display = "block";
        if (desinerSelCtrl.XStep) {
            document.getElementById("txtRowPad").value = desinerSelCtrl.XStep;
        }
        else {
            document.getElementById("txtRowPad").value = 0;
        }
    }
   
}

//设定控件的属性
function setCtrlAttr() {
    //var selCtrls = parent.frLayout.editor.options.selectCtrls;
    //var selctrl = null;
    //if (selCtrls.length > 1) return;
    //if (selCtrls.length == 0) {
    //    selctrl = parent.frLayout.editor.options.bdLayout;
    //}
    //else {
    //    selctrl = selCtrls[0];
    //}
    if (desinerSelCtrl == null) return;
    var ctrl = event.srcElement;
    if (ctrl.className == "numberStyle" && ctrl.value == "") {
        return;
    }
    switch (ctrl.id) {
        case "txtCtrl-Height":
            desinerSelCtrl.style.height = ctrl.value + "px";
            break;
        case "txtCtrl-Width":
            desinerSelCtrl.style.width = ctrl.value + "px";
            break;
        case "ddpPrtPaperSet":
                desinerSelCtrl.PrtPaperSet = ctrl.value;
            break;
        case "ddpPrtDirection":
                desinerSelCtrl.LandscapeOrientation = ctrl.value;
            break;
        case "txtCtrl-X":
            desinerSelCtrl.style.left = ctrl.value + "px";
            break;
        case "txtCtrl-Y":
            desinerSelCtrl.style.top = ctrl.value + "px";
            break;
        case "txtName":
            if (desinerSelCtrl.ctrlType == "label" || desinerSelCtrl.ctrlType == "listitem") {
                if (parent.frLayout.testParamData) {
                    parent.frLayout.testParamData = parent.frLayout.testParamData.replace("\"" + desinerSelCtrl.name + "\"", "\"" + ctrl.value + "\"");
                }
                if (desinerSelCtrl.defaultvalue == "false") {
                    desinerSelCtrl.innerText = "[" + ctrl.value + "]";
                }
            }
            desinerSelCtrl.name = $.trim(ctrl.value);
            break;
        case "txtFontSize":
            desinerSelCtrl.style.fontSize = ctrl.value + "pt";
            break;
        case "ddpFontBold":
            if (ctrl.value == "true") {
                desinerSelCtrl.style.fontWeight = "bold";
            }
            else {
                desinerSelCtrl.style.fontWeight = "";
            }
            break;
        case "ddpFontName":
            desinerSelCtrl.style.fontFamily = ctrl.value;
            break;
        case "txtDefaultValue":
            if (desinerSelCtrl.ctrlType == "label") {
                if ($.trim(ctrl.value) != "") {
                    desinerSelCtrl.innerText = ctrl.value;
                    desinerSelCtrl.defaultvalue = "true";
                }
                else {
                    desinerSelCtrl.innerText = "[" + desinerSelCtrl.name + "]";
                    desinerSelCtrl.defaultvalue = "false";
                }
            }
            else if (desinerSelCtrl.ctrlType == "img") {
                desinerSelCtrl.src = $.trim(ctrl.value);
            }
            break;
        case "ddpRePrt":
              desinerSelCtrl.RePrtHeadFlag = ctrl.value;
            break;
        case "ddpLineType":
            var fromAttr = "";
            if (ctrl.value == "1") {
                desinerSelCtrl.from = "0,0";
                desinerSelCtrl.to = desinerSelCtrl.style.width + ",0";
                //desinerSelCtrl.setAttribute("from", "0,0");
                //desinerSelCtrl.setAttribute("to", desinerSelCtrl.style.width + ",0");
            }
            else if (ctrl.value == "2") {
                desinerSelCtrl.from = "0,0";
                desinerSelCtrl.to = "0," + desinerSelCtrl.style.height;
                //desinerSelCtrl.setAttribute("from", "0,0");
                //desinerSelCtrl.setAttribute("to", "0," + desinerSelCtrl.style.height);
            }
            else if (ctrl.value == "3") {
            desinerSelCtrl.from = "0," + desinerSelCtrl.style.height;
            desinerSelCtrl.to = desinerSelCtrl.style.width + ",0";
                //desinerSelCtrl.setAttribute("from", "0," + desinerSelCtrl.style.height);
                //desinerSelCtrl.setAttribute("to", desinerSelCtrl.style.width + ",0");
            }
            else if (ctrl.value == "4") {
                desinerSelCtrl.from = "0,0";
                desinerSelCtrl.to = desinerSelCtrl.style.width + "," + desinerSelCtrl.style.height ;
                //desinerSelCtrl.setAttribute("from", "0,0");
                //desinerSelCtrl.setAttribute("to", desinerSelCtrl.style.width + "," + desinerSelCtrl.style.height);
            }
            desinerSelCtrl.lineType = ctrl.value;
            break;
        case "txtPageRows":
                var rows = parseInt(ctrl.value, 10);
                desinerSelCtrl.PageRows = rows;
                break;
            case "txtCurrentRow":
                var currentRowNumber = parseInt(ctrl.value, 10);
                desinerSelCtrl.CurrentRow = currentRowNumber;
                break;
        case "txtTableHeight":
            if (desinerSelCtrl.ctrlType == "list") {

                desinerSelCtrl.style.height = ctrl.value + "px";
            }
            else if (desinerSelCtrl.ctrlType == "reporttable") {
                //desinerSelCtrl.rows[0].style.height = ctrl.value + "px";
                desinerSelCtrl.style.height = ctrl.value + "px";
            }
            break;
        case "txtRowPad":
                desinerSelCtrl.XStep = ctrl.value;
            break;
		case "ddpIsQRCode":	//Lid 2015-11-01 增加二维码属性
			desinerSelCtrl.isqrcode= ctrl.value;
			break;
		case "txtQRWidth":
			desinerSelCtrl.width= ctrl.value;
			break;
		case "txtQRHeight":
			desinerSelCtrl.height= ctrl.value;
			break;
    }
    if ((ctrl.id == "txtCtrl-Height" || ctrl.id == "txtCtrl-Width") && desinerSelCtrl.ctrlType == "shape") {
        if (desinerSelCtrl.lineType == "1") {
            desinerSelCtrl.from = "0,0";
            desinerSelCtrl.to = desinerSelCtrl.style.width+ ",0";
        }
        else if (desinerSelCtrl.lineType == "2") {
            desinerSelCtrl.from = "0,0";
            desinerSelCtrl.to = "0," + desinerSelCtrl.style.height;
        }
        else if (desinerSelCtrl.lineType == "3") {
        desinerSelCtrl.from = "0," + desinerSelCtrl.style.height;
        desinerSelCtrl.to = desinerSelCtrl.style.width + ",0";
        }
        else if (desinerSelCtrl.lineType == "4") {
            desinerSelCtrl.from = "0,0";
            desinerSelCtrl.to = desinerSelCtrl.style.width + "," + desinerSelCtrl.style.height;
        }
    }
}
function setTable() {
    if (desinerSelCtrl == null) return;
    openWin("ReportTableConfig.HTML", "500px", "300px", desinerSelCtrl.rows[0].cells);
}

function openWin(src, width, height, argment) {
    var resultArray = window.showModalDialog(src, argment, "location:No;status:No;help:No;dialogWidth:" + width + ";dialogHeight:" + height + ";scroll:no;");
    if (resultArray != null) {
        var width = 0;
        var count = desinerSelCtrl.rows[0].cells.length;
        for (var i = count-1; i >-1; i--) {
            desinerSelCtrl.rows[0].deleteCell(i);
        }
        for (var index = 0; index < resultArray.length; index++) {
            var newTd = desinerSelCtrl.rows[0].insertCell(index);
            newTd.style.width = resultArray[index].width;
            newTd.name = resultArray[index].name;
            newTd.innerText = resultArray[index].printValue;
            width = width + parseInt(resultArray[index].width, 10);
            
        }
        desinerSelCtrl.style.width = width + "px";
    }
}

function hideAll() {
    $(".trCtrlAttr").css("display", "none");
}