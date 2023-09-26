var editor = null;
var URLParams = null;
var innitHtml = null;
$(document).ready(function() {
    this.body.onbeforeunload = frmDesiner_onbeforeunload;
    this.body.onmouseup = frmDesiner_onmouseup;
    this.body.onmousemove = frmDesiner_onmousemove;
    this.body.onmousedown = frmDesiner_onmousedown;
    this.body.onresize = frmDesiner_onresize;
    this.body.ondblclick = frmDesiner_ondblclick;
    this.body.onclick = frmDesiner_onclick;
    this.body.onkeydown = frmDesiner_onkeydown;
    frmDesiner_onload();
});

//窗体装入事件代码
function frmDesiner_onload() {
    editor = $('#divEditor').FWDesiner(null, { bdLayout: document.getElementById("dbLayout") });
    document.execCommand("2D-Position", true, true);
    document.execCommand("MultipleSelection", true, true);
    getUrlParam();
    if (URLParams["action"] == "Update") {
        OpenReport();
    }
    var tempXmlData = $("#srcHtml").text();
    $("#srcHtml").text("");
    innitHtml = document.getElementById("dbLayout").outerHTML;
    $("#srcHtml").text(tempXmlData);
}

//在设计器面板中点击鼠标时的处理
function frmDesiner_onmousedown() {
    if (document.getElementById("srcHtml").style.display != "none") {
        return;
    }
    //点击子控件
    if (!event.srcElement.ctrlType && event.srcElement.id != "dbLayout") { 
        clickChildCtrl();
        return;
    }
    
    if (event.button == 1) {
        if (event.srcElement.id != "dbLayout") {
            if (event.ctrlKey || event.shiftKey) {
                var count = editor.options.selectCtrls.length;
                if (count > 0) {
                    for (var index = count - 1; index > -1; index--) {
                        if (editor.options.selectCtrls[index].id == event.srcElement.id) {
                            editor.options.selectCtrls.splice(index, 1);
                            return;
                        }
                    }
                    if (event.srcElement.parentElement.id != editor.options.selectCtrls[0].parentElement.id) {
                        editor.options.selectCtrls = new Array();
                        editor.options.selectCtrls.push(event.srcElement);
                    }
                    else {
                        editor.options.selectCtrls.push(event.srcElement);
                    }
                }
                else {
                    editor.options.selectCtrls.push(event.srcElement);
                }
            }
            else {
                editor.options.selectCtrls = new Array();
                editor.options.selectCtrls.push(event.srcElement);
            }
        }
        else {
            editor.options.selectCtrls = new Array();
        }
    }
    else {
        if (event.srcElement.id != "dbLayout") {
            if (event.ctrlKey || event.shiftKey) {
                var count = editor.options.selectCtrls.length;
                if (count == 0) {
                    editor.options.selectCtrls.push(event.srcElement);
                }
            }
            else {
                editor.options.selectCtrls = new Array();
                editor.options.selectCtrls.push(event.srcElement);
            }
        }
        else {
            editor.options.selectCtrls = new Array();
        }
    }
}

//在设计面板中按键时的处理
function frmDesiner_onkeydown() {
    if (event.srcElement.id == "srcHtml") {
        return;
    }
    if (event.keyCode == 46 || //delete
        event.keyCode == 17 ||    //ctrl
        (event.ctrlKey && (event.keyCode == 88 ||    //ctrl +X
        event.keyCode == 67 ||   //ctrl +c
        event.keyCode == 86 ||   //ctrl +v
        event.keyCode == 89 ||  //ctrl +y
        event.keyCode == 90 )))    //ctrl +z
    {
        if (event.ctrlKey) {
            if (event.keyCode == 88) {
                editor.ExcuteCmd("CUT");
            }
            else if (event.keyCode == 67) {
                editor.ExcuteCmd("COPY");
            }
            else if (event.keyCode == 86) {
                editor.ExcuteCmd("PASTE");
            }
            else if (event.keyCode == 89) {
            editor.ExcuteCmd("REDO");
            }
            else if (event.keyCode == 90) {
            editor.ExcuteCmd("UNDO");
            }
        }
        if (event.keyCode == 46) {
            editor.ExcuteCmd("DELETE");
        }
    }
    event.returnValue = false;
}

function frmDesiner_onresize() {

}

function frmDesiner_ondblclick() {

}

function frmDesiner_onbeforeunload() {
}

function frmDesiner_onmouseup() {
    if (document.getElementById("srcHtml").style.display != "none") {
        return;
    }
    editor.ShowCtrlSelEdge();
    parent.frCtrlAttr.showCtrlAttr();
    //event.returnValue = false;
}

function frmDesiner_onmousemove() {

}

function frmDesiner_onclick() {

}

function getUrlParam() {
    URLParams = new Array();
    var aParams = parent.window.location.search.substr(1).split('&');
    for (i = 0; i < aParams.length; i++) {
        var aParam = aParams[i].split('=');
        URLParams[aParam[0]] = aParam[1];
    }
}

function haveEdit() {
    var tempXmlData = $("#srcHtml").text();
    $("#srcHtml").text("");
    var htmlNow = document.getElementById("dbLayout").outerHTML;
    $("#srcHtml").text(tempXmlData);
    if (htmlNow != innitHtml) {
        return true;
    }
    return false;
}