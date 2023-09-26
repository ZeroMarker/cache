(function($) {
    $.FWDesiner = function(objHtml, config) {
        objHtml.contentEditable = true;
        objHtml.focus();
        objHtml.onbeforeeditfocus = ctrlEditFoucus;
        var $thisObj = $('#' + objHtml.id);

    };
    $.fn.FWDesiner = function(xmlSrc, config) {
        try {
            if (this.length != 1) {
                throw ('设计器初始化失败。');
            }
            var defaults = $.fn.FWDesiner.defaults;
            var Settings = $.extend({}, defaults, config);
            for (var prop in Settings) {
                if (defaults[prop] === undefined) throw (prop + '没有被定义,请检查属性是否正确！');
            }
            //Settings.xmlSource = xmlSrc;
            this.options = Settings;
            this.options.element = this[0];
            this.ExcuteCmd = excuteOperation;
            this.getNewCtrlId = createNewCtrlId;
            this.setCtrlHtml = setChildHtml;
            this.ShowCtrlSelEdge = showCtrlRegion;
            this.AddCtrl = addNewCtrl;
            this.UnDo = excuteUnDo;
            this.ReDo = excuteReDo;
            this.SaveUnDo = excuteSaveUnDo;
            this.SaveReDo = excuteSaveReDo;
            this.options.unDoData = CreateXMLDOM();
            this.options.reDoData = CreateXMLDOM();
            this.options.unDoData.loadXML("<root></root>");
            this.options.reDoData.loadXML("<root></root>");
            this.each(function() {
                new $.FWDesiner(this, Settings);
            });
            return this;
        } catch (ex) {
            if (typeof ex === 'object') alert(ex.message); else alert(ex);
        }
    };
    //公共方法
    $.fn.FWDesiner.defaults = {
        positionMode: 'absolute',
        element: null,
        selectCtrls: new Array(),
        bdLayout: null,
        otherData: null,
        unDoData: null,
        reDoData: null
    };
    //取得新控件Id
    function createNewCtrlId(ctrlType) {
        var index = 0;
        while (true) {
            index++;
            var cId = ctrlType + index;
            if ($("#" + cId).length == 0) {
                return cId;
            }
        }
    };
    //设定新控件的html
    function setChildHtml(cId, ctrlHtml) {
        var selCtrls = this.options.selectCtrls;
        if (selCtrls.length == 1) {
            var cType = selCtrls[0].ctrlType;
            if (cType == "div" || cType == "fieldset" || selCtrls[0].tagName == "TD" || cType == "list") {
                selCtrls[0].innerHTML += ctrlHtml;
                ctrlFixSize(document.getElementById(cId));
                return;
            }
        }
        this.options.element.innerHTML += ctrlHtml;
        return;
    };
    //显示选中控件的边框
    function showCtrlRegion() {
        parent.frLayout.focus();
        var count = this.options.selectCtrls.length;
        if (count > 0) {
            try {
                var oControlRange = document.body.createControlRange();
                for (var index = count - 1; index > -1; index--) {
                    oControlRange.add(editor.options.selectCtrls[index]);
                }
                oControlRange.select();
            } catch (e) {
            }
        }
    }
    //添加控件
    function addNewCtrl(ctrlType) {
        excuteSaveUnDo.apply(this);
        ctrlType = ctrlType.toLowerCase();
        var cId;
        var ctrlHtml;
        var positionMode = this.options.positionMode;
        switch (ctrlType.toLowerCase()) {
            case "label":
                {
                    if (this.options.selectCtrls.length == 1 && this.options.selectCtrls[0].ctrlType == "list") {
                        this.options.selectCtrls = new Array();
                    }
                    cId = this.getNewCtrlId(ctrlType);
                    ctrlHtml = "<label ctrlType='" + ctrlType + "'id=" + cId + " name=" + cId + " style='position:" + positionMode + ";left:0px;top:0px;border: 1px dotted #C0C0C0;'onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() defaultvalue=\"false\">[" + cId + "]</label>";
                    break;
                }
            case "button":
                {
                    cId = this.getNewCtrlId(ctrlType);
                    ctrlHtml = "<button ctrlType='" + ctrlType + "'id=" + cId + " style='position:" + positionMode + ";left:0px;top:0px;width:75px;height:25px;border:1px outset' onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd()>" + cId + "</button>";
                    break;
                }
            case "hr":
                {
                    cId = this.getNewCtrlId(ctrlType);
                    ctrlHtml = "<HR ctrlType='" + ctrlType + "' id=" + cId + " width='95' color='silver' style='position:" + positionMode + ";left:0px;top:0px;width:165px;height:2px;' onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() />";
                    break;
                }
            case "href":
                {
                    cId = this.getNewCtrlId(ctrlType);
                    ctrlHtml = "<a ctrlType='" + ctrlType + "' id=" + cId + " style='position:" + positionMode + "; left:0px; Top:0px; height:15px; Width:80px; 'onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() href='#'>超级连接</a>";
                    break;
                }
            case "text":
                {
                    cId = this.getNewCtrlId(ctrlType);
                    ctrlHtml = "<input ctrlType='" + ctrlType + "'id='" + cId + "'style='position:" + positionMode + ";left:0px; border-width:1px; border-color:#7F9DB9; top:0px; width:110px; height:20px; border-style:solid ' onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() />";
                    break;
                }
            case "numbertext":
                {
                    cId = this.getNewCtrlId(ctrlType);
                    ctrlHtml = "<input ctrlType='" + ctrlType + "' id=" + cId + " style='position:" + positionMode + ";left:0px; border-width:1px; border-color:#7F9DB9; top:0px;width:110px;height:20px; border-style:solid' onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() />";
                    break;
                }
            case "textarea":
                {
                    cId = this.getNewCtrlId(ctrlType);
                    ctrlHtml = "<textarea ctrlType='" + ctrlType + "' id=" + cId + " style='position:" + positionMode + "; left:0px; top:0px; width:100px; height:85px; ' onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() ></textarea>";
                    break;
                }
            case "datetext":
                {
                    cId = this.getNewCtrlId(ctrlType);
                    ctrlHtml = "<input ctrlType='" + ctrlType + "' id=" + cId + " style='position:" + positionMode + ";left:0px; border-width:1px; border-color:#7F9DB9; top:0px;width:110px;height:20px; border-style:solid' onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() />";
                    break;
                }
            case "timetext":
                {
                    cId = this.getNewCtrlId(ctrlType);
                    ctrlHtml = "<input ctrlType='" + ctrlType + "' id=" + cId + " style='position:" + positionMode + ";left:0px;top:0px;width:110px; border-width:1px; border-color:#7F9DB9; height:20px; border-style:solid' onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() />";
                    break;
                }
            case "checkboxlist":
                {
                    cId = this.getNewCtrlId(ctrlType);
                    ctrlHtml = "<DIV ctrlType='" + ctrlType + "' id=" + cId + " style='background-color:#d4d0c8; overflow:auto;position:" + positionMode + ";left:0px;top:0px;width:300px;height:200px;border:solid 1 black; 'onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() ></DIV>";
                    break;
                }
            case "checkbox":
                {
                    cId = this.getNewCtrlId(ctrlType);
                    ctrlHtml = "<div ctrlType='" + ctrlType + "' nowrap id='" + cId + "' style='position:" + positionMode + "; left:0px; top:0px; width:80; height:20px;' onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() ><input type=checkbox id='chkItem" + cId + "' disabled><label for='chkItem" + cId + "'>复选框</label></div>";
                    break;
                }
            case "radiolist":
                {
                    cId = this.getNewCtrlId(ctrlType);
                    ctrlHtml = "<DIV ctrlType='" + ctrlType + "' id=" + cId + " style='background-color:#d4d0c8; overflow:auto;position:" + positionMode + ";left:0px;top:0px;width:300px;height:200px;border: 1px solid black; ' onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() ></DIV>";
                    break;
                }
            case "radio":
                {
                    cId = this.getNewCtrlId(ctrlType);
                    ctrlHtml = "<fieldset ctrlType='" + ctrlType + "' id='" + cId + "'contentEditable=false value=-1  style='position:" + positionMode + ";left:0px;top:0px;height:96px;width:152px; ' onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() field='100' ><legend>单选表</legend></fieldset>";
                    break;
                }
            case "chart":
                {
                    cId = this.getNewCtrlId(ctrlType);
                    ctrlHtml = "<img ctrlType='" + ctrlType + "' id=" + cId + " type=graph style='position:" + positionMode + ";Left:0px;Top:0px; Height:188px; Width:326px;' src='../images/ctrlImg/graph.gif' onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() />";
                    break;
                }
            case "bandbox":
                {
                    cId = this.getNewCtrlId(ctrlType);
                    ctrlHtml = "<select ctrlType='" + ctrlType + "' id=" + cId + " style='position:" + positionMode + ";left:0px; top:0px; width:100; height:80px;' onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() />";
                    break;
                }
            case "combobox":
                {
                    cId = this.getNewCtrlId(ctrlType);
                    ctrlHtml = "<select ctrlType='" + ctrlType + "' id=" + cId + " style='position:" + positionMode + "; left:0px; top:0px; width:120px; height:25px; ' onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd()></select>";
                    break;
                }
            case "listbox":
                {
                    cId = this.getNewCtrlId(ctrlType);
                    ctrlHtml = "<select ctrlType='" + ctrlType + "' id=" + cId + " size=8  style='position:" + positionMode + "; left:0px; top:0px; width:100px; height:80px; ' onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd()></select>";
                    break;
                }
            case "img":
                {
                    cId = this.getNewCtrlId(ctrlType);
                    ctrlHtml = "<img ctrlType='" + ctrlType + "' id=" + cId + " name=" + cId + " style='position:" + positionMode + ";Left:0px;Top:0px;' onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() />";
                    break;
                }
            case "reporttable":
                {
                    cId = this.getNewCtrlId(ctrlType);
                    ////                    var tdId1 = this.getNewCtrlId("td");
                    ////                    var index = parseInt(tdId1.replace("td", ""), 10) + 1;
                    ////                    var tdId2 = "td" + index;
                    ////                    index = index + 1;
                    ////                    var tdId3 = "td" + index;
                    ctrlHtml = "<table ctrlType='" + ctrlType + "' id = '" + cId + "' cellpadding='0' cellspacing='1' style='position:" + positionMode + ";background-color: #99BBE8;width:300px;height:25px;'onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd()><tr style='background-color:white;'><td style='width:100px;' name='col1'>col1</td><td style='width:100px;' name='col2'>col2</td><td style='width:100px;' name='col3'>col3</td></tr></table>";
                    break;
                }
            case "shape":
                {
                    this.options.selectCtrls = new Array();
                    cId = this.getNewCtrlId(ctrlType);
                    ctrlHtml = '<v:line id="' + cId + '" name="' + cId + '" ctrlType="shape" lineType ="1" style="POSITION: absolute; TOP: 10px; LEFT: 10px;width:100px;height:10px;" onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() from = "0,0" to = "100px,0" cover="9" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>';
                    break;
                }
            case "div":
                {
                    cId = this.getNewCtrlId(ctrlType);
                    ctrlHtml = "<div ctrlType='" + ctrlType + "' id=" + cId + " style='BORDER-BOTTOM: 1px solid black; BORDER-LEFT: 1px solid black; BORDER-RIGHT: 1px solid black; BORDER-TOP: 1px solid black; margin:0px; padding:0px; position:" + positionMode + "; left:0px; Top:0px; width:280px; height:200px;' onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() ></div>";
                    break;
                }
            case "fieldset":
                {
                    cId = this.getNewCtrlId(ctrlType);
                    var ctrlHtml = "<fieldset ctrlType='" + ctrlType + "' id=" + cId + " style='BORDER-BOTTOM: 1px solid black; BORDER-LEFT: 1px solid black; BORDER-RIGHT: 1px solid black; BORDER-TOP: 1px solid black; margin:0px; padding:0px; position:" + positionMode + "; left:0px; Top:0px; width:280px; height:200px;'  onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() ><legend>标题</legend></fieldset>";
                    break;
                }

            case "dictionary":
                {

                    cId = this.getNewCtrlId(ctrlType);
                    var ctrlHtml = "<input ctrlType='" + ctrlType + "' id=" + cId + " style='position:" + positionMode + ";left:0px;top:0px; border-width:1px; border-color:#7F9DB9;width:110px;height:20px; border-style:solid' onresizestart=resizeStart() onresizeend=resizeEnd() onmovestart=moveStart() onmoveend=moveEnd() />";
                    break;
                }
            case "list":
                {
                    if (this.options.element.innerHTML.indexOf("ctrlType=\"list\"") > -1) {
                        alert("报表中只能包含一个列表。");
                        return;
                    }
                    this.options.selectCtrls = new Array();
                    cId = this.getNewCtrlId(ctrlType);
                    ctrlHtml = "<div ctrlType='" + ctrlType + "' id=" + cId + " style='border: 1px solid #99BBE8; margin:0px; padding:0px; position:" + positionMode + "; left:0px; Top:0px; width:280px; height:60px;' CurrentRow='1' onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() ></div>";
                    break;
                }
            case "listitem":
                {
                    var selCtrls = this.options.selectCtrls;
                    if (selCtrls.length != 1 || (selCtrls.length == 1 && selCtrls[0].ctrlType != "list")) {
                        alert("该项只能添加到列表中。");
                        return;
                    }
                    cId = this.getNewCtrlId(ctrlType);
                    ctrlHtml = "<label ctrlType='" + ctrlType + "'id=" + cId + " name=" + cId + " style='position:" + positionMode + ";left:0px;top:0px;border: 1px dotted #C0C0C0;'onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() defaultvalue=\"false\">[" + cId + "]</label>";
                    break;
                }
                //            case "tab":
                //                {
                //                    cId = this.getNewCtrlId(ctrlType);
                //                    ctrlHtml = "<div id=" + cId + " ctrlType='" + ctrlType + "' onresize=ctrlResize() onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmove=ctrlMove() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() style='position:absolute;top:0px;left:0px;width:402px;height:320px'>"
                //            + "<table id=fcpagesubtable bgcolor=white onmousedown=pageonclick() onresizestart=CancelEvent()><tbody><tr contentEditable=false><td style='background-color:white;border-left:1px solid #8BA7B6;border-top:1px solid #8BA7B6;border-right:1px solid #8BA7B6;color:red;' width=80px height=20px align=center><font size=2>页签1</font></td><td style='background-color:white;border-left:1px solid #8BA7B6;border-right:1px solid #8BA7B6;border-top:1px solid #8BA7B6;' width=80px height=20px align=center><font size=2>页签2</font></td></tr></tbody></table>"
                //            + "<div id=fcpagesub style='z-index:1;background-color:white;position:absolute;top:22px;height:250px;border-left:1px solid #8BA7B6;border-bottom:1px solid #8BA7B6;border-right:1px solid #8BA7B6;border-top:1px solid #8BA7B6;' onmovestart=CancelEvent() onresizestart=CancelEvent() oncontrolselect=controlselect()></div>"
                //            + "<div id=fcpagesub style='background-color:white;position:absolute;top:22px;height:250px;border-left:1px solid #8BA7B6;border-bottom:1px solid #8BA7B6;border-right:1px solid #8BA7B6;border-top:1px solid #8BA7B6;' onmovestart=CancelEvent() onresizestart=CancelEvent() oncontrolselect=controlselect()></div>"
                //            + "</div>";
                //                    break;
                //                }
                //            case "upload":
                //                {
                //                    try {
                //                        obj = upload1.id;
                //                        alert("每个表单上只能有一个File Field控件！");
                //                        return;
                //                    } catch (e) {
                //                        ArrNum[name]++;
                //                        var sHtml = "<div controltype='" + name + "' id='upload1' style='BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid;  BORDER-RIGHT: 1px solid;BORDER-TOP: 1px solid;overflow: auto;position:" + fcpubdata.position + ";Left:0;Top:0;Height:48;Width:152; ' onmovestart=moveStart() onmoveend=moveEnd() onresizestart=resizeStart() onresizeend=resizeEnd() ><table  border=0 cellPadding=0 cellSpacing=0  frame=box style='table-layout:fixed;BORDER-COLLAPSE: collapse;'> <tr height=30><td colspan=5  >&nbsp;&nbsp;<a href='javascript:uploadAddFile()'>增加附件</a></td></tr>  </table>  </div> ";
                //                    }
                //                    break;
                //                }
                //            case "spin":
                //                {
                //                    cId = this.getNewCtrlId(ctrlType);
                //                    ctrlHtml = "<img ctrlType='" + ctrlType + "' id=" + cId + " Min='1' Max='32000' NextNum='1' style='position:" + positionMode + ";Left:0;Top:0; Height:22; Width:70;' src='../images/ctrlImg/spin.gif' onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() />";
                //                    break;
                //                }

        }
        this.setCtrlHtml(cId, ctrlHtml);
        this.options.selectCtrls = new Array();
        this.options.selectCtrls.push(document.getElementById(cId));
        this.ShowCtrlSelEdge();
        parent.frCtrlAttr.showCtrlAttr();
    };
    //执行菜单命令
    //$.fn.FWDesiner.ExcuteCmd = function(cmdType) {
    function excuteOperation(cmdType) {
        this.ShowCtrlSelEdge();
        switch (cmdType.toUpperCase()) {
            case "PRINTVIEW":
                printView();
                break;
            case "SAVE":
                SaveXml();
                break;
            case "CUT":
                if (this.options.selectCtrls.length > 0) {
                    excuteSaveUnDo.apply(this);
                }
                copyCtrl();
                document.execCommand("Delete");
                this.options.selectCtrls = new Array();
                break;
            case "COPY":
                copyCtrl();
                break;
            case "PASTE":
                pastCtrl();
                break;
            case "DELETE":
                if (this.options.selectCtrls.length > 0) {
                    excuteSaveUnDo.apply(this);
                }
                document.execCommand("Delete");
                this.options.selectCtrls = new Array();
                parent.frCtrlAttr.showCtrlAttr();
                break;
            case "UNDO":
                this.UnDo();
                break;
            case "REDO":
                this.ReDo();
                break;
            case "LEFTALIGN":
                AlignCtrl("LEFTALIGN");
                break;
            case "BOTTOMALIGN":
                AlignCtrl("BOTTOMALIGN");
                break;
            case "TOPALIGN":
                AlignCtrl("TOPALIGN");
                break;
            case "RIGHTALIGN":
                AlignCtrl("RIGHTALIGN");
                break;
            case "H-ALIGN":
                AlignCtrl("H-ALIGN");
                break;
            case "V-ALIGN":
                AlignCtrl("V-ALIGN");
                break;
            case "H-EQUAL":
                AlignCtrl("H-EQUAL");
                break;
            case "W-EQUAL":
                AlignCtrl("W-EQUAL");
                break;
            case "S-EQUAL":
                AlignCtrl("S-EQUAL");
                break;
            case "H-SPACEEQUAL":
                break;
            case "V-SPACEEQUAL":
                break;
            case "TOFRONT":
                adjustCtrlPosition(true);
                break;
            case "TOBACK":
                adjustCtrlPosition(false);
                break;
        }
    };

    //撤销
    function excuteUnDo() {
        var undoDoc = this.options.unDoData;
        if (undoDoc.documentElement.childNodes.length == 0) return;
        excuteSaveReDo.apply(this);
        var index = undoDoc.documentElement.childNodes.length - 1;
        var thisNode = undoDoc.documentElement.childNodes[index];
        var ctrlHtml = unescape(thisNode.childNodes[0].text);
        this.options.element.innerHTML = ctrlHtml;
        var bodyElem = thisNode.childNodes[1];
        var size = bodyElem.text.split("|");
        this.options.bdLayout.style.height = size[0];
        this.options.bdLayout.style.width = size[1];
        deleteUnDoRecord.call(this, index);
    };
    //重复
    function excuteReDo() {
        var redoDoc = this.options.reDoData;
        if (redoDoc.documentElement.childNodes.length == 0) return;
        excuteSaveUnDo.call(this, true);
        var index = redoDoc.documentElement.childNodes.length - 1;
        var thisNode = redoDoc.documentElement.childNodes[index];
        var ctrlHtml = unescape(thisNode.childNodes[0].text);
        this.options.element.innerHTML = ctrlHtml;
        var bodyElem = thisNode.childNodes[1];
        var size = bodyElem.text.split("|");
        this.options.bdLayout.style.height = size[0];
        this.options.bdLayout.style.width = size[1];
        deleteReDoRecord.call(this, index);
    };
    //保存撤销
    function excuteSaveUnDo(flg) {
        var undoDoc = this.options.unDoData;
        var root = undoDoc.documentElement;
        var newNode = undoDoc.createNode(1, "record", "");

        var htmlElem = undoDoc.createElement("HTML");
        newNode.appendChild(htmlElem);
        newNode.lastChild.text = escape(this.options.element.innerHTML);

        var bodyElem = undoDoc.createElement("BODY");
        newNode.appendChild(bodyElem);
        newNode.lastChild.text = this.options.bdLayout.style.height + "|" + this.options.bdLayout.style.width;
        root.appendChild(newNode);
        if (undoDoc.documentElement.childNodes.length > 10) {
            deleteUnDoRecord.call(this, 0);
        }
        if (!flg) {
            var redoDoc = this.options.reDoData;
            var count = redoDoc.documentElement.childNodes.length;
            if (count > 0) {
                for (var index = count - 1; index > -1; index--) {
                    redoDoc.documentElement.removeChild(redoDoc.documentElement.childNodes.item(index));
                }
            }
        }
    };
    //保存重复
    function excuteSaveReDo() {
        var redoDoc = this.options.reDoData;
        var root = redoDoc.documentElement;
        var newNode = redoDoc.createNode(1, "record", "");

        var htmlElem = redoDoc.createElement("HTML");
        newNode.appendChild(htmlElem);
        newNode.lastChild.text = escape(this.options.element.innerHTML);

        var bodyElem = redoDoc.createElement("BODY");
        newNode.appendChild(bodyElem);
        newNode.lastChild.text = this.options.bdLayout.style.height + "|" + this.options.bdLayout.style.width;
        root.appendChild(newNode);
        if (redoDoc.documentElement.childNodes.length > 10) {
            deleteReDoRecord.call(this, 0);
        }
    };
    //删除重复
    function deleteReDoRecord(index) {
        this.options.reDoData.documentElement.removeChild(this.options.reDoData.documentElement.childNodes.item(index));
    };
    //删除撤销
    function deleteUnDoRecord(index) {
        this.options.unDoData.documentElement.removeChild(this.options.unDoData.documentElement.childNodes.item(index));
    }
})(jQuery);