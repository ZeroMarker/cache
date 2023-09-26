var ctrlTemp = null;
var idTemp = null;
//控件的最小宽度
var ctrlMinWidth = 10;
//控件的最小高度
var ctrlMinHeight = 10;

function ctrlResize() {
}

function ctrlResizeStart() {
    editor.SaveUnDo();
}

//调整控件大小结束后进行的处理
function ctrlResizeEnd() {
    ctrlFixSize(event.srcElement);
}

function ctrlMove() {
}

function ctrlMoveStart() {
    editor.SaveUnDo();
}

//移动控件结束后进行的处理
function ctrlMoveEnd() {
    ctrlFixSize(event.srcElement);
}

//修正控件的大小
function ctrlFixSize(ctrl) {
    if (!ctrl) return;
    var o = ctrl;
    if (o == null) return;
    if (ctrl.ctrlType == "shape") {
        if (ctrl.lineType == "1") {
            ctrl.from = "0,0";
            ctrl.to = ctrl.style.width + ",0";
        }
        else if (ctrl.lineType == "2") {
            ctrl.from = "0,0";
            ctrl.to = "0," + ctrl.style.height;
        }
        else if (ctrl.lineType == "3") {
            ctrl.from = "0," + ctrl.style.height;
            ctrl.to = ctrl.style.width + ",0";
        }
        else if (ctrl.lineType == "4") {
            ctrl.from = "0,0";
            ctrl.to = ctrl.style.width + "," + ctrl.style.height;
        }
    }
    var oP = o.parentNode;
    if (oP.id == editor.options.element.id) { return; }
    var leftval = parseInt(o.style.left.replace("px", ""),10);
    var topval = parseInt(o.style.top.replace("px", ""), 10);
    var widthval = parseInt(o.style.width.replace("px", ""), 10);
    widthval = widthval > ctrlMinWidth ? widthval : ctrlMinWidth;
    var heightval = parseInt(o.style.height.replace("px", ""), 10);
    heightval = heightval > ctrlMinHeight ? heightval : ctrlMinHeight;
    var totalwidth = parseInt(oP.style.width.replace("px", ""), 10);
    var totalheight = parseInt(oP.style.height.replace("px", ""), 10);
    if (widthval >= totalwidth) {
        widthval = (totalwidth - 2)
        o.style.width = widthval + "px";
    }
    if (heightval >= totalheight) {
        heightval = (totalheight - 2);
        o.style.height = heightval + "px";
    }
    if (leftval < 0) {o.style.left = "0px";} 
    else if (leftval + widthval >= totalwidth-2) {
        o.style.left = (totalwidth - widthval-1).toString() + "px";
    } else {
        o.style.left = o.style.left;
    }

    if (topval < 0) { o.style.top = "0px";}
    else if (topval + heightval >= totalheight-2) {
        o.style.top = (totalheight - heightval-1).toString() + "px";
    } else {
        o.style.top = o.style.top;
    }
}

//选中控件
function ctrlSelect(cId) {
    try {
        var oControlRange = document.body.createControlRange();
        oControlRange.add(eval(cId));
        oControlRange.select();
        //document.getElementById(cId).createControlRange();
    } catch (e) {
     }
}

//禁止编辑控件的内容
function ctrlEditFoucus() {
    event.returnValue = false;
}

//取得父控件
function getParentCtrl(thisCtrl) {
    var ctrl = thisCtrl;
    while (!ctrl.parentElement.ctrlType) {
        ctrl = ctrl.parentElement;
    }
    return ctrl.parentElement;
}

//停止控件的事件
function stopCtrlEvent() {
    event.returnValue = false;
    if (window.event) {
        if (event != null) {
            event.cancelBubble = true;
        }
    } else {
        if (event != null) {
            event.stopPropagation();
        }
    }
}

//点击控件的子内容
function clickChildCtrl() {
    var parentCtrl = getParentCtrl(event.srcElement);
    if (event.button == 1) {
        if (event.ctrlKey || event.shiftKey) {
            var count = editor.options.selectCtrls.length;
            if (count > 0) {
                for (var index = count - 1; index > -1; index--) {
                    if (editor.options.selectCtrls[index].id == parentCtrl.id) {
                        editor.options.selectCtrls.splice(index, 1);
                        return;
                    }
                }
                if (parentCtrl.parentElement.id != editor.options.selectCtrls[0].parentElement.id) {
                    editor.options.selectCtrls = new Array();
                }
            }
            editor.options.selectCtrls.push(parentCtrl);
        }
        else {
            editor.options.selectCtrls = new Array();
            editor.options.selectCtrls.push(parentCtrl);
        }
    }
    else {
        if (event.ctrlKey || event.shiftKey) {
            var count = editor.options.selectCtrls.length;
            if (count == 0) {
                editor.options.selectCtrls.push(parentCtrl);
            }
        }
        else {
            editor.options.selectCtrls = new Array();
            editor.options.selectCtrls.push(parentCtrl);
        }
    }
}

//复制控件
function copyCtrl() {
    var ctrls = editor.options.selectCtrls;
    var count = ctrls.length;
    if (count > 0) {
        ctrlTemp = new Array();
        for (var index = count - 1; index > -1; index--) {
            ctrlTemp.push(ctrls[index].outerHTML);
        }
    }
  }
  
  //粘贴控件
  function pastCtrl() {
      if (ctrlTemp == null || ctrlTemp.length == 0) {
          return;
      }
      editor.SaveUnDo();
      var count = ctrlTemp.length;
      for (var index = count - 1; index > -1; index--) {
          var ctrl = $(ctrlTemp[index]);
          if (ctrl[0].ctrlType == "listitem") {
                    var selCtrls = editor.options.selectCtrls;
                    if (selCtrls.length != 1  || (selCtrls.length==1 && selCtrls[0].ctrlType != "list")) {
                        alert("列表项只能添加到列表中");
                        return;
                    }
          }
          changeCtrlHtml(ctrl[0]);
          editor.setCtrlHtml(ctrl[0].id, ctrl[0].outerHTML);
      }
  }

  //改变控件的Html
  function changeCtrlHtml(ctrl) {
      if (!ctrl.ctrlType) return;
      idTemp = new Array();
      if (ctrl.ctrlType != "div" && ctrl.ctrlType != "fieldset" && ctrl.ctrlType != "td" && ctrl.ctrlType != "list") {
          var cId = getCoyId(ctrl.ctrlType);
          ctrl.innerHTML = ctrl.innerHTML.replace(eval("/" + ctrl.id + "/g"), cId);
          ctrl.id = cId;
          ctrl.name = cId;
          idTemp.push(cId);
      }
      else {
          for (var oneCtrl in ctrl.children()) {
              changeCtrlHtml(oneCtrl);
          }
          var cId = getCoyId(ctrl.ctrlType);
          ctrl.id = cId;
          idTemp.push(cId);
      }
  }

  //取得复制时控件的ID
  function getCoyId(ctrlType) {
      var cId = editor.getNewCtrlId(ctrlType);
      while (exsitId(cId)) {
          var index = parseInt(cId.replace(ctrlType, ""), 10) + 1;
          cId = ctrlType + index;
      }
      return cId;
  }

  //判断Id是否存在
  function exsitId(cId) {
      if (document.getElementById(cId)) {
          return true;
      }
      if (idTemp == null || idTemp.length == 0) {
          return false;
      }
      for (var i = 0; i < idTemp.length; i++) {
          if (idTemp[i] == cId) {
              return true;
          }
      }
      return false;
  }

  //对齐控件
  function AlignCtrl(cmdType) {
      var count = editor.options.selectCtrls.length;
      if (count > 1) {
          editor.SaveUnDo();
          var compCtrl = editor.options.selectCtrls[0];
          var compCtrlHeight = 0;
          var compCtrlWidth = 0;
          var fontSize = "12";
          if (compCtrl.style.height.replace("px", "") == "") {
              compCtrlHeight = compCtrl.getClientRects()[0].bottom - compCtrl.getClientRects()[0].top;
          }
          else {
              compCtrlHeight = parseInt(compCtrl.style.height.replace("px", ""), 10);
          }
          if (compCtrl.style.width.replace("px", "") == "") {
              compCtrlWidth = compCtrl.getClientRects()[0].right - compCtrl.getClientRects()[0].left;
          }
          else {
              compCtrlWidth = parseInt(compCtrl.style.width.replace("px", ""), 10);
          }
          for (var i = 1; i < count; i++) {
              fontSize = "12";
              var ctrl = editor.options.selectCtrls[i];
              var ctrlHeight = 0;
              var ctrlWidth = 0;
              if (ctrl.style.height.replace("px", "") == "") {
                  ctrlHeight = ctrl.getClientRects()[0].bottom - ctrl.getClientRects()[0].top;
              }
              else {
                  ctrlHeight = parseInt(ctrl.style.height.replace("px", ""), 10);
              }
              if (ctrl.style.width.replace("px", "") == "") {
                  ctrlWidth = ctrl.getClientRects()[0].right - ctrl.getClientRects()[0].left;
              }
              else {
                  ctrlWidth = parseInt(ctrl.style.width.replace("px", ""), 10);
              }
              switch (cmdType) {
                  case "LEFTALIGN":
                      ctrl.style.left = compCtrl.style.left;
                      break;
                  case "TOPALIGN":
                      ctrl.style.top = compCtrl.style.top;
                      break;
                  case "BOTTOMALIGN":
                      ctrl.style.top = (parseInt(compCtrl.style.top.replace("px", ""), 10) + compCtrlHeight - ctrlHeight) + "px";
                      break;
                  case "RIGHTALIGN":
                      ctrl.style.left = (parseInt(compCtrl.style.left.replace("px", ""), 10) + compCtrlWidth - ctrlWidth) + "px";
                      break;
                  case "H-ALIGN":
                      ctrl.style.top = (parseInt(compCtrl.style.top.replace("px", ""), 10) + (compCtrlHeight - ctrlHeight)/2) + "px";
                      break;
                  case "V-ALIGN":
                      ctrl.style.left = (parseInt(compCtrl.style.left.replace("px", ""), 10) + (compCtrlWidth - ctrlWidth)/2) + "px";
                      break;
                  case "H-EQUAL":
                      ctrl.style.height = compCtrlHeight +"px";
                      break;
                  case "W-EQUAL":
                      ctrl.style.width = compCtrlWidth + "px";
                      break;
                  case "S-EQUAL":
                      ctrl.style.height = compCtrlHeight + "px";
                      ctrl.style.width = compCtrlWidth + "px";
                      break;
                  case "H-SPACEEQUAL":
                      break;
                  case "V-SPACEEQUAL":
                      break;
              }
          }
      }
  }

  //调整控件的位置
  function adjustCtrlPosition(flg) {
      var selCtrls = editor.options.selectCtrls;
      var count = selCtrls.length;
      for (var i = 0; i < count; i++) {
          var ctrlHtml = selCtrls[i].outerHTML
          var parentCtrl = selCtrls[i].parentNode;
          if (parentCtrl != null) {
              parentCtrl.innerHTML = parentCtrl.innerHTML.replace(ctrlHtml, "");
              if (flg) {
                  parentCtrl.innerHTML = parentCtrl.innerHTML + ctrlHtml;
              }
              else {
                  parentCtrl.innerHTML = ctrlHtml + parentCtrl.innerHTML;
              }
          }
      }
  }