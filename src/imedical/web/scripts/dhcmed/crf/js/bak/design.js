Eform.Design = function () { }
Eform.Design.prototype = {
    addObj: Addobj,
    savePubData: SavePubData,
    loadPubData: LoadPubData,
    getNewContID: getNewContID,
    main_ondblclick: main_ondblclick,
    main_onkeydel: main_onkeydel,
    main_onkeyup: main_onkeyup,
    main_onkeydown: main_onkeydown,
    selFieldToArr: SelFieldToArr,
    isDivCont: IsDivCont,
    htmlToCont: htmltocont,
    addContXml: AddContXml,
    copyCont: CopyCont,
    pasteCont: PasteCont,
    currSel: CurrSel,
    selectObj: SelectObj,
    openObjList: openobjlist,
    showAllField: ShowAllField,
    addBindField: AddBindField,
    getFieldInputStr: getFieldInputStr,
    autoAddDsMain: AutoAddDsMain,
    autoAddQueryDj: AutoAddQueryDj,
    addRecentFile: ef_AddRecentFile,
    refreshRecentFile: ef_RefreshRecentFile
}
if (Type.parse("Eform.Design") == null) Eform.Design.registerClass("Eform.Design");

Eform.UnDo = function () { }
Eform.UnDo.prototype =
{
    init: initoUndooRedo,
    saveRedo: SaveoRedoOneRecord,
    saveUndo: SaveoUndoOneRecord,
    readRedo: ReadoRedoOneRecord,
    readUndo: ReadoUndoOneRecord,
    delRedo: DeleteoRedoOneRecord,
    delUndo: DeleteoUndoOneRecord,
    cmdRedo: cmdRedo,
    cmdUndo: cmdUndo
}
if (Type.parse("Eform.UnDo") == null) Eform.UnDo.registerClass("Eform.UnDo");

Eform.Wizard = function () { }
Eform.Wizard.prototype =
{
    disabledButton: function uf_DisabledButton() {
        var objNav = parent.mainform.topic.objNav;
        if (objNav.prevPage == "") {
            cmdPrev.disabled = true;
        } else {
            cmdPrev.removeAttribute("disabled");
        }
        if (objNav.nextPage == "") {
            cmdNext.disabled = true;
            cmdOk.removeAttribute("disabled");
        } else {
            cmdNext.removeAttribute("disabled");
            cmdOk.disabled = true;
        }
    },

    prev: function cmdPrev_onclick() {
        parent.mainform.topic.objNav.saveConfig();
        if (parent.mainform.topic.objNav.isOk == false) return;
        var htmlPath = parent.mainform.topic.objNav.prevPage;
        if (htmlPath != "") {
            cmdPrev.disabled = true;
            parent.mainform.location.replace("djframe.htm?djsn=" + htmlPath);
        }
    },
    next: function cmdNext_onclick() {
        parent.mainform.topic.objNav.saveConfig();
        if (parent.mainform.topic.objNav.isOk == false) return;
        var htmlPath = parent.mainform.topic.objNav.nextPage;
        if (htmlPath != "") {
            cmdNext.disabled = true;
            parent.mainform.location.replace("djframe.htm?djsn=" + htmlPath);
        }
    }
}


if (Type.parse("Eform.Wizard") == null) Eform.Wizard.registerClass("Eform.Wizard");


function Addobj(name) {
    var oAddField = null;
    switch (name) {
        case "button": 
            {
                ArrNum[name]++;
                var sid = getNewContID(name, oContXml);
                var sHtml = "<button controltype='" + name + "' style='position:" + fcpubdata.position + ";left:0px;top:0px;width:75px;height:25px;border:1px outset' onresize=resize() onresizestart=resizeStart() onresizeend=resizeEnd() onmove=move() onmovestart=moveStart() onmoveend=moveEnd() oncontrolselect=controlselect() id=" + sid + ">" + sid + "</button>";
                htmltocont(sHtml, name);
                SelectObj(sid);
                break;
            }
        case "spin": 
            {
                ArrNum[name]++;
                var sid = getNewContID(name, oContXml);
                var sHtml = "<img controltype='" + name + "' id=" + sid + " Min='1' Max='32000' NextNum='1' style='position:" + fcpubdata.position + ";Left:0;Top:0; Height:22; Width:70;' src='../images/ef_designer_numedit.gif' onmovestart=moveStart() onmoveend=moveEnd() onresizestart=resizeStart() onresizeend=resizeEnd() />";
                htmltocont(sHtml, name);
                SelectObj(sid);
                oAddField = $id(sid);
                break;
            }
        case "label":
            {
                ArrNum[name]++;
                var sid = getNewContID(name, oContXml);
                var sHtml = "<label controltype='" + name + "' style='position:" + fcpubdata.position + ";left:0px;top:0px;width:65px;height:15px; ' onresize=resize() onresizestart=resizeStart() onresizeend=resizeEnd() onmove=move() onmovestart=moveStart() onmoveend=moveEnd() oncontrolselect=controlselect() id=" + sid + ">" + sid + "</label>";
                htmltocont(sHtml, name);
                SelectObj(sid);
                break;
            }
        case "hr": 
            {
                ArrNum[name]++;
                var sid = getNewContID(name, oContXml);
                var sHtml = "<HR controltype='" + name + "' id=" + sid + " width='95' color='silver' style='position:" + fcpubdata.position + ";left:0px;top:0px;width:165px;height:2px;' onresize=resize() onresizestart=resizeStart() onresizeend=resizeEnd() onmove=move() onmovestart=moveStart() onmoveend=moveEnd() oncontrolselect=controlselect()>";
                htmltocont(sHtml, name);
                break;
            }
        case "a": 
            {
                ArrNum[name]++;
                var sid = getNewContID(name, oContXml);
                var sHtml = "<a controltype='" + name + "' style='position:" + fcpubdata.position + "; left:0px; Top:0px; height:15px; Width:80px; ' onresize=resize() onresizestart=resizeStart() onresizeend=resizeEnd() onmove=move() onmovestart=moveStart() onmoveend=moveEnd() oncontrolselect=controlselect() id=" + sid + " >超级连接</a>";
                htmltocont(sHtml, name);
                SelectObj(sid);
                break;
            }
        case "text":
            {
                ArrNum[name]++;
                var sid = getNewContID(name, oContXml);
                var sHtml = "<input controltype='" + name + "'  style='position:" + fcpubdata.position + ";left:0px; border-width:1px; border-color:#7F9DB9; top:0px; width:110px; height:20px; border-style:solid ' onresize=resize() onresizestart=resizeStart() onresizeend=resizeEnd() onmove=move() onmovestart=moveStart() onmoveend=moveEnd() oncontrolselect=controlselect() china='" + sid + "' field='100' id='" + sid + "' />";
                htmltocont(sHtml, name);
                SelectObj(sid);
                oAddField = $id(sid);
                break;
            }
        case "numbertext":
            {
                ArrNum[name]++;
                var sid = getNewContID(name, oContXml);
                var sHtml = "<input controltype='" + name + "'  style='position:" + fcpubdata.position + ";left:0px; border-width:1px; border-color:#7F9DB9; top:0px;width:110px;height:20px; border-style:solid' onresize=resize() onresizestart=resizeStart() onresizeend=resizeEnd() onmove=move() onmovestart=moveStart() onmoveend=moveEnd() oncontrolselect=controlselect() onblur=bill_onexit() china='" + sid + "' id=" + sid + " />";
                htmltocont(sHtml, name);
                SelectObj(sid);
                oAddField = $id(sid);
                break;
            }
        case "datetext":
            {
                ArrNum[name]++;
                var sid = getNewContID(name, oContXml);
                var sHtml = "<input controltype='" + name + "'  style='position:" + fcpubdata.position + ";left:0px; border-width:1px; border-color:#7F9DB9; top:0px;width:110px;height:20px; border-style:solid' onresize=resize() onresizestart=resizeStart() onresizeend=resizeEnd() onmove=move() onmovestart=moveStart() onmoveend=moveEnd() oncontrolselect=controlselect() onblur=bill_onexit() ondblclick=bill_ondblclick() china='" + sid + "' id=" + sid + " />";
                htmltocont(sHtml, name);
                SelectObj(sid);
                oAddField = $id(sid);
                break;
            }
        case "timetext":
            {
                ArrNum[name]++;
                var sid = getNewContID(name, oContXml);

                var sHtml = "<input controltype='" + name + "'  style='position:" + fcpubdata.position + ";left:0px;top:0px;width:110px; border-width:1px; border-color:#7F9DB9; height:20px; border-style:solid' onresize=resize() onresizestart=resizeStart() onresizeend=resizeEnd() onmove=move() onmovestart=moveStart() onmoveend=moveEnd() oncontrolselect=controlselect() onblur=bill_onexit() china='" + sid + "' id=" + sid + " />";
                htmltocont(sHtml, name);
                SelectObj(sid);
                oAddField = $id(sid);
                break;
            }
        case "checkboxlist": 
            {
                ArrNum[name]++;
                var sid = getNewContID(name, oContXml);
                var sHtml = "<DIV controltype='" + name + "' id=" + sid + " style='background-color:#d4d0c8; overflow:auto;position:" + fcpubdata.position + ";left:0;top:0;width:300;height:200;border:solid 1 black; ' onmovestart=moveStart() onmoveend=moveEnd() onresizestart=resizeStart() onresizeend=resizeEnd() ></DIV>";
                htmltocont(sHtml, name);
                SelectObj(sid);
                break;
            }
        case "radiolist": 
            {
                ArrNum[name]++;
                var sid = getNewContID(name, oContXml);
                var sHtml = "<DIV controltype='" + name + "' id=" + sid + " style='background-color:#d4d0c8; overflow:auto;position:" + fcpubdata.position + ";left:0;top:0;width:300;height:200;border: solid 1 black; ' onmovestart=moveStart() onmoveend=moveEnd() onresizestart=resizeStart() onresizeend=resizeEnd() ></DIV>";
                htmltocont(sHtml, name);
                SelectObj(sid);
                break;
            }
        case "chart": 
            {
                ArrNum[name]++;
                var sid = getNewContID(name, oContXml);
                var sHtml = "<img controltype='" + name + "' id=" + sid + " type=graph style='position:" + fcpubdata.position + ";Left:0;Top:0; Height:188; Width:326;' src='../images/ef_designer_graph.gif' onmovestart=moveStart() onmoveend=moveEnd() onresizestart=resizeStart() onresizeend=resizeEnd() />";
                htmltocont(sHtml, name);
                SelectObj(sid);
                break;
            }
        case "dropdownlist": 
            {
                ArrNum[name]++;
                var sid = getNewContID(name, oContXml);
                var sHtml = "<img controltype='" + name + "' id=" + sid + " multiselect='否' addrow='否'  blnempty='否'  blninput='是' visible='是' style='position:" + fcpubdata.position + ";left:0; top:0; width:100; height:18 ;' src='" + fcpubdata.path + "/DHCForm/images/ef_designer_fccode.gif' onmovestart=moveStart() onmoveend=moveEnd() onresizestart=resizeStart() onresizeend=resizeEnd() />";
                htmltocont(sHtml, name);
                SelectObj(sid);
                oAddField = $id(sid);
                break;
            }
        case "checkbox":
            {
                ArrNum[name]++;
                var sid = getNewContID(name, oContXml);
                var sHtml = "<div controltype='" + name + "' nowrap id='" + sid + "' truevalue='是' falsevalue='否' value='否' style='position:" + fcpubdata.position + "; left:0px; top:0px; width:80; height:20px;'onresize=resize() onresizestart=resizeStart() onresizeend=resizeEnd() onmove=move() onmovestart=moveStart() onmoveend=moveEnd() oncontrolselect=controlselect() field='100' china='" + sid + "'><input type=checkbox id='chk" + sid + "'  oncontrolselect=controlselectcancel() onclick=bill_onclick()><label for='chk" + sid + "'>复选框</label></div>";
                htmltocont(sHtml, name);
                SelectObj(sid);
                oAddField = $id(sid);
                break;
            }
        case "dictionary":
            {
                ArrNum[name]++;
                var sid = getNewContID(name, oContXml);
                //var sHtml = "<div controltype='" + name + "' nowrap id='" + sid + "' style='position:" + fcpubdata.position + "; left:0px; top:0px; width:170px; height:20px; border-style:none'onresize=resize() onresizestart=resizeStart() onresizeend=resizeEnd() onmove=move() onmovestart=moveStart() onmoveend=moveEnd() oncontrolselect=controlselect() field='100' china='" + sid + "'><input type='text' id='chk" + sid + "' style='width:120px;' oncontrolselect=controlselectcancel() /><input type='button' style='width:25px; height:22px; display:none;' id='btn" + sid + "' onclick='bill_onclick()' oncontrolselect=controlselect() value='...' /></div>";
                //var sHtml = "<img controltype='" + name + "' id=" + sid + " type=graph style='position:" + fcpubdata.position + ";Left:0;Top:0; Height:22px; Width:150px;' src='../images/Dictionary.JPG' onmovestart=moveStart() onmoveend=moveEnd() onresizestart=resizeStart() onresizeend=resizeEnd() />";
                var sHtml = "<input controltype='" + name + "'  style='position:" + fcpubdata.position + ";left:0px;top:0px; border-width:1px; border-color:#7F9DB9;width:110px;height:20px; border-style:solid' onresize=resize() onresizestart=resizeStart() onresizeend=resizeEnd() onmove=move() onmovestart=moveStart() onmoveend=moveEnd() oncontrolselect=controlselect() onblur=bill_onexit() china='" + sid + "' id=" + sid + " />";
                htmltocont(sHtml, name);
                SelectObj(sid);
                oAddField = $id(sid);
                break;
            }
        case "radio":
            {
                ArrNum[name]++;
                var sid = getNewContID(name, oContXml);
                var sHtml = "<fieldset controltype='" + name + "' id='" + sid + "' contentEditable=false value=-1  style='position:" + fcpubdata.position + ";left:0;top:0;height:96;width:152; ' onmovestart=moveStart() onmoveend=moveEnd() onresizestart=resizeStart() onresizeend=resizeEnd() field='100' china='" + sid + "'><legend>单选表</legend></fieldset>";
                htmltocont(sHtml, name);
                SelectObj(sid);
                oAddField = $id(sid);
                break;
            }
            
        case "Patient":     //add by wuqk 2012-11-21
        		{
        				ArrNum[name]++;
        				var sid = "objPatient";
        				//var sHtml = "<fieldset contentEditable=true controltype='" + name + "' id='" + sid + "' contentEditable=false value=-1  style='position:" + fcpubdata.position + ";left:0;top:0;height:96;width:152; ' onmovestart=moveStart() onmoveend=moveEnd() onresizestart=resizeStart() onresizeend=resizeEnd() field='100' china='" + sid + "'><legend>基本信息</legend><LABEL>A</LABEL><INPUT id=objPatient.name  onresizeend=resizeEnd() oncontrolselect=controlselect() style='BORDER-BOTTOM: #7f9db9 1px solid; POSITION: absolute; BORDER-LEFT: #7f9db9 1px solid; WIDTH: 110px; HEIGHT: 20px; BORDER-TOP: #7f9db9 1px solid; TOP: 0px; BORDER-RIGHT: #7f9db9 1px solid; LEFT: 50px' onresize=resize() onmove=move() onmovestart=moveStart() onmoveend=moveEnd() onresizestart=resizeStart() ></fieldset>";
                
                var sHtml = ef_BuildPatientFieldSet(name , sid)
                htmltocont(sHtml, name);
                SelectObj(sid);
                oAddField = $id(sid);
                break;
                
                
                /*
                <DIV onresizeend=resizeEnd() oncontrolselect=controlselect() style="BORDER-BOTTOM: black 1px solid; POSITION: absolute; BORDER-LEFT: black 1px solid; PADDING-BOTTOM: 0px; MARGIN: 0px; PADDING-LEFT: 0px; WIDTH: 562px; PADDING-RIGHT: 0px; HEIGHT: 81px; BORDER-TOP: black 1px solid; TOP: 37px; BORDER-RIGHT: black 1px solid; PADDING-TOP: 0px; LEFT: 100px" id=div1 onresize=resize() onmove=move() onmovestart=moveStart() onmoveend=moveEnd() onresizestart=resizeStart() controltype="div">
                
                <LABEL onresizeend=resizeEnd() oncontrolselect=controlselect() style="POSITION: absolute; WIDTH: 65px; HEIGHT: 15px; TOP: 5px; LEFT: 5px" onresize=resize() onmove=move() onmovestart=moveStart() onmoveend=moveEnd() onresizestart=resizeStart() controltype="label">姓名</LABEL>
                
                <INPUT onresizeend=resizeEnd() oncontrolselect=controlselect() style="BORDER-BOTTOM: #7f9db9 1px solid; POSITION: absolute; BORDER-LEFT: #7f9db9 1px solid; WIDTH: 110px; HEIGHT: 20px; BORDER-TOP: #7f9db9 1px solid; TOP: 0px; BORDER-RIGHT: #7f9db9 1px solid; LEFT: 50px" id=objPatient.name onresize=resize() onmove=move() onmovestart=moveStart() onmoveend=moveEnd() onresizestart=resizeStart() field="100" china="text3" controltype="text">
                
                </DIV>
                */
        		}
        case "listbox": 
            {
                ArrNum[name]++;
                var sid = getNewContID(name, oContXml);
                var sHtml = "<select controltype='" + name + "' size=8  style='position:" + fcpubdata.position + "; left:0px; top:0px; width:100px; height:80px; ' onresize=resize() onresizestart=resizeStart() onresizeend=resizeEnd() onmove=move() onmovestart=moveStart() onmoveend=moveEnd() oncontrolselect=controlselect() id=" + sid + "></select>";
                htmltocont(sHtml, name);
                SelectObj(sid);
                oAddField = $id(sid);
                break;
            }
        case "textarea": 
            {
                ArrNum[name]++;
                var sid = getNewContID(name, oContXml);
                var sHtml = "<textarea controltype='" + name + "' style='position:" + fcpubdata.position + "; left:0px; top:0px; width:100px; height:85px; ' onresize=resize() onresizestart=resizeStart() onresizeend=resizeEnd() onmove=move() onmovestart=moveStart() onmoveend=moveEnd() oncontrolselect=controlselect() value=" + sid + " field='100' china='" + sid + "' id=" + sid + "></textarea>";
                htmltocont(sHtml, name);
                SelectObj(sid);
                oAddField = $id(sid);
                break;
            }
        case "combobox": 
            {
                ArrNum[name]++;
                var sid = getNewContID(name, oContXml);
                var sHtml = "<select controltype='" + name + "' style='position:" + fcpubdata.position + "; left:0px; top:0px; width:120px; height:25px; ' onresize=resize() onresizestart=resizeStart() onresizeend=resizeEnd() onmove=move() onmovestart=moveStart() onmoveend=moveEnd() oncontrolselect=controlselect() field='100' china='" + sid + "' id=" + sid + "></select>";
                htmltocont(sHtml, name);
                SelectObj(sid);
                oAddField = $id(sid);
                break;
            }
        case "upload": 
            {
                try {
                    obj = upload1.id;
                    alert("每个表单上只能有一个File Field控件！");
                    return;
                } catch (e) {
                    ArrNum[name]++;
                    var sHtml = "<div controltype='" + name + "' id='upload1' style='BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid;  BORDER-RIGHT: 1px solid;BORDER-TOP: 1px solid;overflow: auto;position:" + fcpubdata.position + ";Left:0;Top:0;Height:48;Width:152; ' onmovestart=moveStart() onmoveend=moveEnd() onresizestart=resizeStart() onresizeend=resizeEnd() ><table  border=0 cellPadding=0 cellSpacing=0  frame=box style='table-layout:fixed;BORDER-COLLAPSE: collapse;'> <tr height=30><td colspan=5  >&nbsp;&nbsp;<a href='javascript:uploadAddFile()'>增加附件</a></td></tr>  </table>  </div> ";
                }
                htmltocont(sHtml, name);
                SelectObj(upload1);
                break;
            }
        case "dbimg": 
            {
                ArrNum[name]++;
                var sid = getNewContID(name, oContXml);
                var sHtml = "<img controltype='" + name + "' id=" + sid + "  alt='用鼠标双击此可选择图形' ondblclick=uploadImg() style='position:" + fcpubdata.position + ";Left:0;Top:0;' onmovestart=moveStart() onmoveend=moveEnd() onresizestart=resizeStart() onresizeend=resizeEnd() >";
                htmltocont(sHtml, name);
                SelectObj(sid);
                oAddField = $id(sid);
                break;
            }
        case "img": 
            {
                ArrNum[name]++;
                var sid = getNewContID(name, oContXml);
                var sHtml = "<img controltype='" + name + "' id=" + sid + " style='position:" + fcpubdata.position + ";Left:0;Top:0;' onmovestart=moveStart() onmoveend=moveEnd() onresizestart=resizeStart() onresizeend=resizeEnd() >";
                htmltocont(sHtml, name);
                SelectObj(sid);
                break;
            }
        case "tree": 
            {
                ArrNum[name]++;
                var sid = getNewContID(name, oContXml);
                var sHtml = "<img controltype='" + name + "' id=" + sid + " isAll='true' ischecked='false'  src='../images/ef_designer_tree.gif' style='position:" + fcpubdata.position + ";Left:0;Top:0;Height:205;Width:187;' onmovestart=moveStart() onmoveend=moveEnd() onresizestart=resizeStart() onresizeend=resizeEnd() >";
                htmltocont(sHtml, name);
                SelectObj(sid);
                break;
            }
        case "tab": 
            {
                var sidtype = name;
                ArrNum[sidtype]++;
                var sid = getNewContID(name, oContXml);
                var sHtml = "<div id=" + sid + " controltype='" + name + "' onresize=page_onresize() onresizestart=resizeStart() onresizeend=resizeEnd() onmovestart=moveStart() onmoveend=moveEnd() style='position:absolute;top:0px;left:0px;width:402px;height:320px'>"
            + "<table id=fcpagesubtable bgcolor=white onmousedown=pageonclick() onresizestart=CancelEvent()><tbody><tr contentEditable=false><td style='background-color:white;border-left:1px solid #8BA7B6;border-top:1px solid #8BA7B6;border-right:1px solid #8BA7B6;color:red;' width=80px height=20px align=center><font size=2>页签1</font></td><td style='background-color:white;border-left:1px solid #8BA7B6;border-right:1px solid #8BA7B6;border-top:1px solid #8BA7B6;' width=80px height=20px align=center><font size=2>页签2</font></td></tr></tbody></table>"
            + "<div id=fcpagesub style='z-index:1;background-color:white;position:absolute;top:22px;height:250px;border-left:1px solid #8BA7B6;border-bottom:1px solid #8BA7B6;border-right:1px solid #8BA7B6;border-top:1px solid #8BA7B6;' onmovestart=CancelEvent() onresizestart=CancelEvent() oncontrolselect=controlselect()></div>"
            + "<div id=fcpagesub style='background-color:white;position:absolute;top:22px;height:250px;border-left:1px solid #8BA7B6;border-bottom:1px solid #8BA7B6;border-right:1px solid #8BA7B6;border-top:1px solid #8BA7B6;' onmovestart=CancelEvent() onresizestart=CancelEvent() oncontrolselect=controlselect()></div>"
            + "</div>";
                htmltocont(sHtml, name);
                SelectObj(sid);
                break;
            }
        case "shape":
            {
                ArrNum[name]++;
                var sid = getNewContID(name, oContXml);
                var sidtype = "shape";
                var sHtml = '<v:line onresizeend=resizeEnd() style="POSITION: absolute; WIDTH: 100px; HEIGHT: 100px; TOP: 10px; LEFT: 10px" id="' + sid + '" onmovestart=moveStart() onmoveend=moveEnd() onresizestart=resizeStart() controltype="shape" linetype="横线" cover="9" from = "0,0" to = "75pt,0" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>';
                htmltocont(sHtml, name);
                SelectObj(sid);
                break;
            }
        case "grid": 
            {
                var sidtype = name;
                ArrNum[sidtype]++;
                var sid = getNewContID(name, oContXml);
                var sHtml = "<img controltype='" + name + "' id=" + sid + " style='position:" + fcpubdata.position + ";Left:0;Top:0;Height:140;Width:300;' src='../images/ef_designer_webgrid.gif' onmovestart=moveStart() onmoveend=moveEnd() onresizestart=resizeStart() onresizeend=resizeEnd() >";
                htmltocont(sHtml, name);
                SelectObj(sid);
                break;
            }
        case "dataset": 
            {
                var no = 1;
                var sidtype = name;
                ArrNum[sidtype]++;
                var sid = getNewContID(name, oContXml);
                var sHtml = "<img controltype='" + name + "' id=" + sid + " opensortno=" + no + " style='position:absolute;Left:5;Top:5;Height:25;Width:25;' src='../images/ef_designer_dataset.gif' onmovestart=moveStart() onmoveend=moveEnd() onresizestart=resizeStart() onresizeend=resizeEnd() >";
                htmltocont(sHtml, name);
                SelectObj(sid);
                break;
            }
        case "div": 
            {
                ArrNum[name]++;
                var sid = getNewContID(name, oContXml);
                var sHtml = "<div controltype='" + name + "' id=" + sid + " style='BORDER-BOTTOM: 1px solid black; BORDER-LEFT: 1px solid black; BORDER-RIGHT: 1px solid black; BORDER-TOP: 1px solid black; margin:0px; padding:0px; position:" + fcpubdata.position + "; left:0; Top:0; width:280; height:200;' onresize=resize() onresizestart=resizeStart() onresizeend=resizeEnd() onmove=move() onmovestart=moveStart() onmoveend=moveEnd() oncontrolselect=controlselect()></div>";
                htmltocont(sHtml, name);
                SelectObj(sid);
                break;
            }
        case "fieldset":
            {
                ArrNum[name]++;
                var sid = getNewContID(name, oContXml);
                var sHtml = "<fieldset controltype='" + name + "' id=" + sid + " style='BORDER-BOTTOM: 1px solid black; BORDER-LEFT: 1px solid black; BORDER-RIGHT: 1px solid black; BORDER-TOP: 1px solid black; margin:0px; padding:0px; position:" + fcpubdata.position + "; left:0; Top:0; width:280; height:200;' onresize=resize() onresizestart=resizeStart() onresizeend=resizeEnd() onmove=move() onmovestart=moveStart() onmoveend=moveEnd() oncontrolselect=controlselect()><legend>标题</legend></fieldset>";
                htmltocont(sHtml, name);
                SelectObj(sid);
                break;
            }
        case "ebshow": 
            {
                try {
                    obj = ebshow1.id;
                    alert("每个表单上只能有一个显示e表结果控件！");
                    return;
                } catch (e) {
                    ArrNum[name]++;
                    var sid = "ebshow1";
                    var sHtml = "<div controltype='" + name + "' id=" + sid + " style='BORDER-BOTTOM: 1px solid black; BORDER-LEFT: 1px solid black; BORDER-RIGHT: 1px solid black; BORDER-TOP: 1px solid black;overflow: auto; background-color:#ffffff; position:" + fcpubdata.position + "; left:0; Top:0; width:280; height:200;' onresize=resize() onresizestart=resizeStart() onresizeend=resizeEnd() onmove=move() onmovestart=moveStart() onmoveend=moveEnd() oncontrolselect=controlselect() InHtml='" + escape('<iframe id=fcebTopic style="WIDTH:100%; height:100%;" NORESIZE=NORESIZE SCROLLING=auto MARGINWIDTH=0 MARGINHEIGHT=0 FRAMESPACING=0 FRAMEBORDER=0 ALLOWTRANSPARENCY="true"></iframe>') + "'></div>";
                    htmltocont(sHtml, name);
                    SelectObj(sid);
                }
                break;
            }
        case "ebiao": 
            {
                ArrNum[name]++;
                var sid = getNewContID(name, oContXml);
                var sHtml = "<div controltype='" + name + "' id=" + sid + " style='BORDER-BOTTOM: 1px solid black; BORDER-LEFT: 1px solid black; BORDER-RIGHT: 1px solid black; BORDER-TOP: 1px solid black;overflow: auto; background-color:#ffffff; position:" + fcpubdata.position + "; left:0; Top:0; width:500; height:360;' onresize=resize() onresizestart=resizeStart() onresizeend=resizeEnd() onmove=move() onmovestart=moveStart() onmoveend=moveEnd() oncontrolselect=controlselect() ondrop='new Eapi.EformEbiao().dragEnter();' ondragend='new Eapi.EformEbiao().dragExit();' ondragstart='new Eapi.EformEbiao().dragStart();'></div>";

                htmltocont(sHtml, name);
                SelectObj(sid);
                break;
            }
        case "excel": 
            {
                ArrNum[name]++;
                var sid = getNewContID(name, oContXml);
                var sHtml = "<object controltype='" + name + "' classid='clsid:0002E510-0000-0000-C000-000000000046' id=" + sid + " style='position:" + fcpubdata.position + "; left:0; Top:0; width:80%; height:200;'><param name='HTMLURL' value><param name='HTMLData' value='&lt;html xmlns:x=&quot;urn:schemas-microsoft-com:office:excel&quot;xmlns=&quot;http://www.w3.org/TR/REC-html40&quot;&gt;&lt;head&gt;&lt;style type=&quot;text/css&quot;&gt;&lt;!--tr{mso-height-source:auto;}td{black-space:nowrap;}.wc4590F88{black-space:nowrap;font-family:宋体;mso-number-format:General;font-size:auto;font-weight:auto;font-style:auto;text-decoration:auto;mso-background-source:auto;mso-pattern:auto;mso-color-source:auto;text-align:general;vertical-align:bottom;border-top:none;border-left:none;border-right:none;border-bottom:none;mso-protection:locked;}--&gt;&lt;/style&gt;&lt;/head&gt;&lt;body&gt;&lt;!--[if gte mso 9]&gt;&lt;xml&gt;&lt;x:ExcelWorkbook&gt;&lt;x:ExcelWorksheets&gt;&lt;x:ExcelWorksheet&gt;&lt;x:OWCVersion&gt;9.0.0.2710&lt;/x:OWCVersion&gt;&lt;x:Label Style='border-top:solid .5pt silver;border-left:solid .5pt silver;border-right:solid .5pt silver;border-bottom:solid .5pt silver'&gt;&lt;x:Caption&gt;Microsoft Office Spreadsheet&lt;/x:Caption&gt; &lt;/x:Label&gt;&lt;x:Name&gt;Sheet1&lt;/x:Name&gt;&lt;x:WorksheetOptions&gt;&lt;x:Selected/&gt;&lt;x:Height&gt;7620&lt;/x:Height&gt;&lt;x:Width&gt;15240&lt;/x:Width&gt;&lt;x:TopRowVisible&gt;0&lt;/x:TopRowVisible&gt;&lt;x:LeftColumnVisible&gt;0&lt;/x:LeftColumnVisible&gt; &lt;x:ProtectContents&gt;False&lt;/x:ProtectContents&gt; &lt;x:DefaultRowHeight&gt;210&lt;/x:DefaultRowHeight&gt; &lt;x:StandardWidth&gt;2389&lt;/x:StandardWidth&gt; &lt;/x:WorksheetOptions&gt; &lt;/x:ExcelWorksheet&gt;&lt;/x:ExcelWorksheets&gt; &lt;x:MaxHeight&gt;80%&lt;/x:MaxHeight&gt;&lt;x:MaxWidth&gt;80%&lt;/x:MaxWidth&gt;&lt;/x:ExcelWorkbook&gt;&lt;/xml&gt;&lt;![endif]--&gt;&lt;table class=wc4590F88 x:str&gt;&lt;col width=&quot;56&quot;&gt;&lt;tr height=&quot;14&quot;&gt;&lt;td&gt;&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;/body&gt;&lt;/html&gt;'> <param name='DataType' value='HTMLDATA'> <param name='AutoFit' value='0'><param name='DisplayColHeaders' value='-1'><param name='DisplayGridlines' value='-1'><param name='DisplayHorizontalScrollBar' value='-1'><param name='DisplayRowHeaders' value='-1'><param name='DisplayTitleBar' value='0'><param name='DisplayToolbar' value='-1'><param name='DisplayVerticalScrollBar' value='-1'> <param name='EnableAutoCalculate' value='-1'> <param name='EnableEvents' value='-1'><param name='MoveAfterReturn' value='-1'><param name='MoveAfterReturnDirection' value='0'><param name='RightToLeft' value='0'><param name='ViewableRange' value='1:65536'></object>";
                htmltocont(sHtml, name);
                SelectObj(sid);
                break;
            }
        case "focus":
            {
                var FocusParamArr = new Array();
                var sXml = TaborderXml();
                FocusParamArr.push(sXml);
                FocusParamArr.push($("#SKbillsheet")[0]);
                var oX = SetDom(sXml);
                var sX = oX.childNodes(0).childNodes.length;
                if (RemoveRoot(sXml) != "" && sX >= 2) {
                    SaveoUndoOneRecord();
                    var sRet = DjOpen('SKDBfocus', FocusParamArr, '展现', "有模式窗口", "直接", "焦点次序");
                    fcpubdata.area.billtaborder = sRet;
                    SaveoRedoOneRecord();
                } else {
                    alert("有两个或以上控件才能使用此控制！");
                }
                break;
            }
        case "align": 
            {
                sArray = CurrSel();
                if (sArray.length < 2) {
                    alert("选中两个或以上控件才能使用此控制");
                    break;
                }
                if (sArray != "") {
                    SaveoUndoOneRecord();
                    var sRet = DjOpen('SKDBalign', sArray, '展现', "有模式窗口", "直接", "对齐面板");
                    SaveoRedoOneRecord();
                }
                break;

            }
        case "menu": 
            {
                var str = DjOpen('menu', '', '展现', "无模式窗口", "直接", "");
                break;
            }
        case "cut":
            if (CopyCont()) {
                main_onkeydown(46);
                main_exec('Delete');
                main_onkeyup(46);
            }
            break;
        case "copy":
            if (CopyCont() == false) {
                document.execCommand("Copy");
            }
            break;
        case "paste":
            if (PasteCont() == false) {
                document.execCommand("Paste");
            }
            break;

        case "front": 
            {
                AdjustPositionBefore("是");
                break;
            }
        case "behind": 
            {
                AdjustPositionBefore("否");
                break;
            }
        case "formatTab": 
            {
                var Htm = DjOpen('fcs_NewFormatTab', 'SKbillsheet', '展现', "有模式窗口", "直接", "新建版式表格");
                if (typeof Htm == 'undefined') {
                    fcpubdata.area.innerHTML += "";
                } else {
                    htmltocont(Htm);
                }
                blnChange = true;
                break;
            }
        case "HtmlTab":
            {
                var sHTab = DjOpen('fcs_NewHtmlTab', fcpubdata, '展现', "有模式窗口", "直接", "新建表格");
                if (typeof sHTab == 'undefined') {
                    fcpubdata.area.innerHTML += "";
                } else {
                    try {
                        htmltocont(sHTab);
                    } catch (e) { }
                }
                blnChange = true;
                break;
            }
        case "form":
            {
                var arrForm = new Array();
                arrForm[0] = fcpubdata.area;
                arrForm[2] = fcpubdata.area;
                arrForm[5] = pstrUserFunction;
                arrForm[6] = parent.objlist.browser;
                var sRet = DjOpen('form', arrForm, '展现', "有模式窗口", "直接", "表单属性");
                if (sRet == "ok") {
                    var iwidth = 0;
                    if (isSpace(fcpubdata.area.poswidth) == false) {
                        iwidth = parseInt(fcpubdata.area.poswidth);
                        if (bigmain.offsetWidth < iwidth) {
                            bigmain.style.width = iwidth;
                        }
                    }
                    var iheight = 0;
                    if (isSpace(fcpubdata.area.posheight) == false) {
                        iheight = parseInt(fcpubdata.area.posheight);
                        if (bigmain.offsetHeight < iheight) {
                            bigmain.style.height = iheight;
                        }
                    }
                    blnChange = true;
                }
                break;
            }
        case "listconfig": 
            {
                DjOpen("FormElementInfo", window, "展现", "有模式窗口", "直接", "列出本表单的配置信息");
                break;
            }
        case "ebiaoform": 
            {
                var obj = parent.dialogArguments;
                var s1 = obj.eform_winprop;
                if (typeof s1 == "undefined") s1 = "";
                var sRet = DjOpen('eb_parawin', [s1, fcpubdata.area], '展现', "有模式窗口", "直接", "设置窗口相关属性");
                if (IsSpace(sRet) == false) {
                    obj.eform_winprop = sRet;
                }
                break;
            }
        case "ebiaobind": 
            {
                if (curSelElement == null) {
                    alert("请在界面上选中一个控件后再试!");
                    break;
                }
                var tmpType = curSelElement.controltype;
                if (tmpType != "text" && tmpType != "checkbox" && tmpType != "radio" && tmpType != "listbox" && tmpType != "combobox" && tmpType != "dropdownlist" && tmpType != "textarea" && tmpType != "spin") {
                    alert("当前选中的控件不能绑定!");
                    break;
                }
                var s2 = curSelElement.id;
                if (IsSpace(s2)) {
                    alert("当前选中的控件的id不能为空!");
                    break;
                }
                var obj = parent.dialogArguments;
                var s1 = obj.e_argsbak;
                if (typeof s1 == "undefined") s1 = "";
                var sRet = DjOpen('eb_parabind', [s1, s2], '展现', "有模式窗口", "直接", "报表参数绑定");
                if (IsSpace(sRet) == false) {
                    obj.e_argsbak = sRet;
                }
                break;
            }
        case "userfunction": 
            {
                var stmp = DjOpen('userfunction', pstrUserFunction, '展现', "有模式窗口", "直接", "自定义函数");
                if (typeof stmp != "undefined") pstrUserFunction = stmp;
                blnChange = true;
                break;
            }
        case "userfunction1": 
            {
                try {
                    var l = new ActiveXObject("CodeMax.Language.3");
                } catch (e) {
                    if (window.confirm("没有安装codemax或是IE的安全设置属性框中对没有标记为安全的activex控件进行初始化和脚本运行的选项没为启动；是否下载安装codemax!") == true) {
                        window.open("../design/download.htm", "", "height=250,width=300,left=300,top=150,resizabel=no,menubar=no");
                    }
                    break;
                }
                var stmp = DjOpen('userfunction1', pstrUserFunction, '展现', "有模式窗口", "直接", "带颜色的自定义函数");
                if (typeof stmp != "undefined") pstrUserFunction = stmp;
                blnChange = true;
                break;
            }
        case "addhtml": 
            {
                var stmp = DjOpen('addhtml', pstrAddHtml, '展现', "有模式窗口", "直接", "附加页面");
                if (typeof stmp != "undefined") pstrAddHtml = stmp;
                blnChange = true;
                break;
            }
        case "opendj":
            {
                alert("暂不开放此功能");
                return false;
                var sRet = DjOpen('opendj', '', '修改', "有模式窗口", "直接", "选择从数据库中打开的表单");
                if (isSpace(sRet) == false) {
                    DesignDjOpen(sRet);
                }
                break;
            }
        case "opendjfile":
            {
                //spath应该是DHCWebForm/FormModule下面的目录路径
                spath = '';
                var sRet = DjOpen('getUrl', [spath, 'file', 'yes', 'dj'], '展现', '有模式窗口', '直接', '选择文件');
                if (IsSpace(sRet) == false) {
                    pdjFilePath = sRet;
                    var shtm = "";
                    $.ajax({
                        type: "POST",
                        url: fcpubdata.path + "/WebFormService/GetFileContent.CSP",   //fcpubdata.path + "/Form.do/GetFileContent",
                        data: "sPath=" + escape(sRet),
                        async: false,
                        success: function (obj) {
                            var innerStr = "";
                            var fileDom = SetDom(obj);
                            
                            if (fileDom.childNodes(0).childNodes != null && fileDom.childNodes(0).childNodes.length > 0) {
					                    if (fileDom.childNodes(0).childNodes(1) != null) {
					                        innerStr = fileDom.childNodes(0).childNodes(1);
					                        var htmlDom = SetDom(fileDom.childNodes(0).childNodes[1].xml);
					                        $("#middlediv").html(htmlDom.childNodes(0).childNodes(0).text);
					                        fcpubdata.area = $id("SKbillsheet");
					                        ArrNum = OpenControlNo(fcpubdata.area.controlno, ArrNum)
					                    }
				
					                    var Controls = $("[controltype]");
					                    Controls.removeAttr("onmouseout");
					                    Controls.removeAttr("onmouseover");
				
					                    if (fileDom.childNodes(0).childNodes(4) != null) {
					                        var treeDom = SetDom(fileDom.childNodes(0).childNodes[4].xml);
					                        parent.objlist.CreateTreeByHtml(treeDom.childNodes(0).childNodes(0).text);
					                    }
					                    //维护控件ID
					                    if (TooContXml()) {
					                        openobjlist();
					                    }
					                    $("#SKbillsheet").attr("isUpdate", true);
					                }
                            /*
                            if (obj.Result) {
                                if (obj.DataObject != null && obj.DataObject.length > 0) {
                                    if (obj.DataObject[0] != null) {
                                        innerStr = obj.DataObject[0];
                                        $("#middlediv").html(innerStr);
                                        //下面这句话不可少，因为保存的时候要解析fcpubdata.area sbin amend 2010-10-26
                                        if (obj.DataObject[1] != null) {
                                            $("#SKbillsheet").attr("FormEntityInfo", obj.DataObject[1]);
                                        } else {
                                            $("#SKbillsheet").attr("FormEntityInfo", "");
                                        }
                                        fcpubdata.area = $id("SKbillsheet");
                                        ArrNum = OpenControlNo(fcpubdata.area.controlno, ArrNum)
                                    }
                                    if (obj.DataObject[2] != null) {
                                        parent.objlist.CreateTreeByHtml(obj.DataObject[2]);
                                    }
                                    //维护控件ID
                                    if (TooContXml()) {
                                        openobjlist();
                                    }
                                    $("#SKbillsheet").attr("isUpdate", true);
                                }
                            }
                            else {
                                $("#SKbillsheet").attr("isUpdate", false);
                            }*/

                        },
                        error: function (msg) {
                            var obj = eval("(" + msg + ")");
                            alert(obj.Message);
                        }
                    });
                }
                break;
            }
        case "save": 
            {
                SubmitDjSave(true,true)
                blnChange = false;
                break;
            }
        case "saveas":
            {
                SubmitDjSave(false,true);
                blnChange = false;
                break;
            }
        case "new": 
            {
                parent.objlist.select1.options.length = 0;
                DesignDjNew("是");
                break;
            }
        case "newempty": 
            {
                parent.objlist.select1.options.length = 0;
                DesignDjNew();
                break;
            }
        case "djpreview": 
            {
                var djsn = fcpubdata.area.dj_sn;
                if (typeof djsn == "undefined") {
                    alert("请进入表单属性窗口输入了单据sn后才能预览!");
                    return;
                }
                if (blnChange) {
                    var stmp = SubmitDjSave(true,false);
                    if (IsSpace(stmp) == false) {
                        return;
                    }
                }
                var sUrl = fcpubdata.path + "/" + fcpubdata.root + "/design/opendj.htm?djsn=";
                var isfile = fcpubdata.area.isfile;
                if (isfile == "是") {
                    var objBillType = BillTypeNameToPath(fcpubdata.area.type);
                    sUrl += objBillType.path + djsn + "&isfile=yes";
                } else {
                    sUrl += djsn + "&isfile=test";
                }
                open(sUrl);
                break;
            }
        case "directrun":
            {
                var djsn = fcpubdata.area.dj_sn;

                var stmp = SubmitDjSave(true, false);
                if (IsSpace(stmp) == false) {
                    return;
                }
								var curFormId =eval("(" + $("#SKbillsheet").attr("FormEntityInfo") + ")").ID;
								/*
                var sUrl = "../FormModule/";
                var FormStr = $("#SKbillsheet").attr("FormEntityInfo");
                var typePath = "CRF";
                var PrjId = "";
                var FormEntity = null;
                if (FormStr != null && FormStr != "") {
                    FormEntity = eval("(" + FormStr + ")");
                    PrjId = FormEntity.ProjectID;
                    typePath = FormEntity.Type;
                }
                */

                //var prjObj = AjaxReturn("../../PrjManage.do/GetById", { prjId: PrjId }, "POST", false);
                //sUrl = sUrl + typePath + "/" + prjObj.Name + "/" + djsn + ".html";
                //sUrl = sUrl + "CRF/" + djsn + ".html"
                var sUrl = fcpubdata.path + "/WebFormService/directrun.csp?EName="+djsn+"&formid="+curFormId;
                open(sUrl);
                break;
            }
        case "billtype":
            {
                alert("暂不开放此功能！");
                return false;
                var sRet = DjOpen('billtypefile', '', '展现', "有模式窗口", "直接", "表单分类维护");
                break;
            }
        case "createhtmfile": 
            {
                if (isSpace(fcpubdata.area.dj_sn)) {
                    var s1 = '表单sn不能为空!请进入表单属性窗口输入表单SN.';
                    alert(s1);
                    return;
                }
                DesignStr_RunStr_Before(fcpubdata.area);
                fcpubdata.area.removeAttribute("contentEditable");
                fcpubdata.area.removeAttribute("unselectable");

                var sRun = fcpubdata.area.outerHTML;
                sRun = DesignStr_RunStr_After(sRun);
                sRun = "<scr" + "ipt>" + pstrUserFunction + "</scr" + "ipt>" + sRun + pstrAddHtml;
                sRun = "<![CDATA[" + sRun + "]]>";
                var sFile = new Eapi.Str().trim(fcpubdata.area.dj_sn) + ".htm";
                var sPath = "dj/" + sFile;
                var sXml = "<no>djsn</no><no>" + sRun + "</no><no>" + sPath + "</no>" + "<No>" + fcpubdata.path + "</No>";
                var ret = savedesignhtml(sXml);
                if (ret == "") {
                    alert(sFile + "文件保存成功!");
                    return "";
                } else {
                    alert(ret);
                    return ret;
                }
                break;
            }
        case "undo": { cmdUndo(); break; }
        case "redo": { cmdRedo(); break; }
    }

    if (fcpubdata.autoAddField == "yes" && oAddField != null && $id("DsMain") != null) {
        var s = $id("DsMain").formatxml;
        var curNo = 0;
        if (typeof s == "undefined") {
            s = ""
        } else {
            s = RemoveRoot(s);
            curNo = getMaxFieldNo();
        }
        var sF = '<tr><td>field' + curNo + '</td><td>field' + curNo + '</td><td>字符</td><td>50</td><td>0</td><td>数据项</td><td></td><td></td><td>否</td><td>否</td><td>否</td><td>否</td><td>是</td><td>否</td><td>否</td><td>否</td><td></td><td></td><td>left</td><td>80</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
        $id("DsMain").formatxml = "<root>" + s + sF + "</root>";
        oAddField.dataset = "DsMain";
        oAddField.field = "field" + curNo;
    }
    function getMaxFieldNo() {
        var comType = "DsMain_field";
        var curNo = 0;
        if (isNaN(parseInt(ArrNum[comType])) == false) {
            ;
            curNo = parseInt(ArrNum[comType]);
        }
        var oXml = SetDom($id("DsMain").formatxml);
        if (oXml.documentElement != null) {
            for (var i = curNo; i < curNo + 200; i++) {
                var oNode = oXml.documentElement.selectSingleNode("/root/tr/td[0][.= 'field" + i + "']");
                if (oNode == null) {
                    ArrNum[comType] = i + 1;
                    return i;
                }
            }
            alert("DsMain数据集的字段名重复，请立即修改。");
        }
        return curNo;
    }
    function AdjustPositionBefore(yes) {
        var slen = oContXml.selectNodes("//id").length;
        if (slen < 2) {
            alert("单个控件不能设置此控制");
            return;
        }
        var sArray = CurrSel();
        ilen = sArray.length;
        if (ilen > 0) {
            SaveoUndoOneRecord();
            var oParent = sArray[0].parentNode;
            var parentid = oParent.id;
            var strHtm = "";
            for (var i = 0; i < ilen; i++) {
                upid = sArray[i].parentNode.id;
                if (upid == parentid) {
                    stmp = sArray[i].outerHTML;
                    sArray[i].outerHTML = "";
                    strHtm = strHtm + stmp;
                }
            }
            var ss = oParent.innerHTML;
            if (yes == "是") {
                oParent.innerHTML = ss + strHtm;
            } else {
                oParent.innerHTML = strHtm + ss;
            }
            blnChange = true;
            SaveoRedoOneRecord();
        }
    }
}


function SavePubData(Sub, strContent, userData) {
    var Main = "pubdata";
    if (typeof userData == "undefined") {
        userData = parent.menu.oForm.oInput;
    }

    if (userData != undefined) {
        userData.setAttribute(Main + userData.value, strContent);
        userData.save(Sub + userData.value);
    }

}

function LoadPubData(Sub, userData) {
    var Main = "pubdata";
    if (typeof userData == "undefined") {
        if (parent.menu.oForm != undefined) {
            userData = parent.menu.oForm.oInput;
        }
        
    }
    var sTmp = null;
    if (userData != undefined) {
        userData.load(Sub + userData.value);
        sTmp = userData.getAttribute(Main + userData.value);
    }

    if (sTmp == null) { sTmp = ""; }
    return sTmp;
}


function getNewContID(comType, oContXml) {
    var sRet = "id1";
    var curNo = 1;
    if (isNaN(parseInt(ArrNum[comType])) == false) {
        ;
        curNo = parseInt(ArrNum[comType]);
    }
    for (var i = curNo; i < curNo + 200; i++) {
        var sid = comType + i;
        var oList = oContXml.documentElement.selectNodes("//id[. ='" + sid + "']");
        if (oList.length == 0) {
            ArrNum[comType] = i;
            return sid;
        }
    }
    alert(sid + "控件名称重复!请立即修改!");
    return sid;
}

/*
* 当设计的主界面双击的时候触发的事件。
* 该事件一般是弹出控件的属性编辑器
* sbin amend 2010-09-16
*/
function main_ondblclick(obj) {
    var arr = new Array();
    //得到当前点击的对象   
    if (typeof obj == "undefined") {
        try {
            var obj = event.srcElement;
//            if (obj.parentElement != null && obj.parentElement.controltype == "dictionary") {
//                obj = obj.parentElement;
//            }
        } catch (e) {
            obj = curSelElement;
        }
    } else {
        try {
            parent.topic.focus();
        } catch (e) { }
    }
    if (obj == null) {
        Addobj('form');
        return;
    }
    if (typeof obj.tagName == "undefined") {
        obj = curSelElement;
    }

    if (obj.tagName == "TABLE") {
        RightMenuTab.showMenu(window, RightMenuTab.dataSource.documentElement.selectSingleNode('//MenuTableItem'), window.document.body, event.x, event.y);
    }

    var strid = obj.id;
    if (isSpace(strid)) {
        try {
            var stmp1 = obj.parentNode.controltype;
            if (stmp1 == "checkbox") {
                obj = obj.parentNode;
                strid = obj.id;
            }
        } catch (e) { }

    }
    if (strid == "fcpagesub") return;
    arr[0] = obj;
    arr[1] = SelFieldToArr();
    arr[2] = fcpubdata.area;
    arr[3] = oContXml;
    try {
        arr[4] = Printer;
    } catch (e) { }
    arr[5] = pstrUserFunction;
    arr[6] = parent.objlist.browser;
    SaveoUndoOneRecord();
    var arrCur = CurrSel();
    if (arrCur.length > 1) {
        arr[0] = arrCur;
        var sRet = DjOpen('pubAttr', arr, '展现', '有模式窗口', '直接', '设置多个控件的属性');
    } else {
        if (isSpace(obj.controltype) == false) {
            if (obj.controltype == "ebiao") {
                var oTable = new Eapi.EformEbiao().open(obj);
                var oRet = window.showModalDialog("../ereport/ebdesign.htm", oTable, "center:yes;dialogWidth:800px;dialogHeight:600px;resizable:yes");
                new Eapi.EformEbiao().ret(obj, oRet, oTable);
            } else {
                var sRet = DjOpen(obj.controltype, arr, '展现', '有模式窗口', '直接', obj.controltype + '属性');
                if (obj.controltype == "dataset") {
                    ShowAllField();
                }
            }
        } else {
            var bool = false;
            var ArrNameNew = new Array();
            ArrNameNew["SKButton"] = "SKButton";
            ArrNameNew["SKDBedit"] = "SKDBedit";
            ArrNameNew["SKDBcheckbox"] = "checkbox";
            ArrNameNew["Label"] = "label";
            ArrNameNew["SKDBRadioGroup"] = "radio";
            ArrNameNew["SKDBListBox"] = "listbox";
            ArrNameNew["SKDBMemo"] = "textarea";
            ArrNameNew["SKDBcombobox"] = "combobox";
            ArrNameNew["password"] = "password";
            ArrNameNew["SKuploadfile"] = "upload";
            ArrNameNew["SKDBtext"] = "SKDBtext";
            ArrNameNew["SKDBchart"] = "chart";
            ArrNameNew["SKDBImage"] = "dbimg";
            ArrNameNew["Image"] = "img";
            ArrNameNew["SKBILLgrid"] = "SKBILLgrid";
            ArrNameNew["Shape"] = "shape";
            ArrNameNew["PageControl"] = "tab";
            ArrNameNew["FCDiv"] = "div";
            ArrNameNew["SKDBTreeView"] = "SKDBTreeView";
            ArrNameNew["SKDBLike"] = "a";
            ArrNameNew["FCButton"] = "button";
            ArrNameNew["FCDBedit"] = "text";
            ArrNameNew["HR"] = "hr";
            ArrNameNew["divcheckbox"] = "checkboxlist";
            ArrNameNew["divradio"] = "radiolist";
            ArrNameNew["fccode"] = "textarea";
            ArrNameNew["imgwebgrid"] = "grid";
            ArrNameNew["imgdataset"] = "dataset";
            ArrNameNew["NumEdit"] = "spin";
            ArrNameNew["excel"] = "excel";
            ArrNameNew["Tree"] = "tree";
            ArrNameNew["numbertext"] = "numbertext";
            ArrNameNew["datetext"] = "datetext";
            ArrNameNew["timetext"] = "timetext";
            ArrNameNew["dictionary"] = "dictionary";
            ArrNameNew["fieldset"] = "fieldset";
            ArrNameNew["combobox"] = "combobox";

            var ArrName1 = new Array();
            ArrName1[0] = "SKButton";
            ArrName1[1] = "SKDBedit";
            ArrName1[2] = "SKDBcheckbox";
            ArrName1[3] = "Label";
            ArrName1[4] = "SKDBRadioGroup";
            ArrName1[5] = "SKDBListBox"
            ArrName1[6] = "SKDBMemo"
            ArrName1[7] = "SKDBcombobox"
            ArrName1[8] = "password";
            ArrName1[9] = "SKuploadfile";
            ArrName1[10] = "SKDBtext";
            ArrName1[11] = "SKDBchart";
            ArrName1[12] = "SKDBImage";
            ArrName1[13] = "Image";
            ArrName1[14] = "SKBILLgrid";
            ArrName1[15] = "Shape";
            ArrName1[16] = "PageControl";
            ArrName1[17] = "FCDiv";
            ArrName1[18] = "SKDBTreeView";
            ArrName1[19] = "SKDBLike";
            ArrName1[20] = "FCButton";
            ArrName1[21] = "FCDBedit"
            ArrName1[22] = "HR";
            ArrName1[23] = "divcheckbox";
            ArrName1[24] = "divradio";
            ArrName1[25] = "fccode";
            ArrName1[26] = "imgwebgrid";
            ArrName1[27] = "imgdataset";
            ArrName1[28] = "NumEdit";
            ArrName1[29] = "excel";
            ArrName1[30] = "Tree";
            ArrName1[31] = "numbertext";
            ArrName1[32] = "datetext";
            ArrName1[33] = "timetext";
            ArrName1[34] = "dictionary";
            ArrName1[35] = "fieldset";
            ArrName1[36] = "combobox";

            var l = ArrName1.length;
            for (var i = 0; i < l; i++) {
                if (strid.indexOf(ArrName1[i]) == 0) {
                    var sRet = DjOpen(ArrNameNew[ArrName1[i]], arr, '展现', '有模式窗口', '直接', ArrNameNew[ArrName1[i]] + '属性');
                    bool = true;
                    break;
                }
            }
            if (bool == false) {
                var sTag = obj.tagName;
                if (isSpace(sTag) == false) {
                    sTag = sTag.toUpperCase();
                    if (sTag == "INPUT" || sTag == "SELECT" || sTag == "TEXTAREA" || sTag == "BUTTON" || sTag == "A" || sTag == "IMG") {
                        var sRet = DjOpen('SetCtrlType', arr, '展现', '有模式窗口', '直接', '属性');
                    }
                }
            }
        }
        SaveoRedoOneRecord();
        return;
    }
}

function SelFieldToArr() {
    var arr = new Array();

    var oNode = oContXml.documentElement.selectSingleNode("dataset");
    if (oNode != null) {
        var l = oNode.childNodes.length;
        var sOption = new Sys.StringBuilder();
        for (var i = 0; i < l; i++) {
            var id = oNode.childNodes(i).text;
            var ods = eval(id);
            sOption.append("<option value='" + id + "'>" + id + "</option>");
            arr[id] = ods.formatxml;
        }
        arr[0] = sOption.toString();
    }
    return arr;

}


function initoUndooRedo() {
    lngUndo = -1;
    lngRedo = -1;
    oUndo.loadXML("<root></root>");
    oRedo.loadXML("<root></root>");
}

function SaveoRedoOneRecord() {
    var root = oRedo.documentElement;
    var newNode = oRedo.createNode(1, "record", "");
    root.appendChild(newNode);

    //记录当前的控件列表信息
    var newElem = oRedo.createElement("contxml");
    newNode.appendChild(newElem);
    newNode.lastChild.text = escape(oContXml.documentElement.xml);

    //记录当前的html文本
    var newElem = oRedo.createElement("SKbillsheet");
    newNode.appendChild(newElem);
    newNode.lastChild.text = escape(fcpubdata.area.outerHTML);

    //记录右边的对象树形结构
    var newElem = oRedo.createElement("treeStr");
    newNode.appendChild(newElem);
    newNode.lastChild.text = escape($(parent.objlist.browser).html());

    if (oRedo.documentElement.childNodes.length > 8) {
        DeleteoRedoOneRecord(0);
    }
}

function SaveoUndoOneRecord() {
    var root = oUndo.documentElement;
    var newNode = oUndo.createNode(1, "record", "");
    root.appendChild(newNode);

    //记录当前的控件列表信息
    var newElem = oUndo.createElement("contxml");
    newNode.appendChild(newElem);
    newNode.lastChild.text = escape(oContXml.documentElement.xml);

    //记录当前的html文本
    var newElem = oUndo.createElement("SKbillsheet");
    newNode.appendChild(newElem);
    newNode.lastChild.text = escape(fcpubdata.area.outerHTML);

    //记录右边的对象树形结构
    var newTree = oUndo.createElement("treeStr");
    newNode.appendChild(newTree);
    newNode.lastChild.text = escape($(parent.objlist.browser).html());

    lngUndo = lngUndo + 1;
    if (oUndo.documentElement.childNodes.length > 8) {
        DeleteoUndoOneRecord(0);
        lngUndo = 7;
    }
}

function ReadoRedoOneRecord(lngKey) {
    oContXml = SetDom(unescape(oRedo.documentElement.childNodes(lngKey).childNodes(0).childNodes(0).xml));
    fcpubdata.area.outerHTML = unescape(oRedo.documentElement.childNodes(lngKey).childNodes(1).childNodes(0).xml);
    //恢复对象属树形结构(替代了下面的openobjlist()方法)
    $(parent.objlist.browser).html(unescape(oRedo.documentElement.childNodes(lngKey).childNodes(2).childNodes(0).xml))
    fcpubdata.area = $id("SKbillsheet");
    //openobjlist();
}

function ReadoUndoOneRecord(lngKey) {
    oContXml = SetDom(unescape(oUndo.documentElement.childNodes(lngKey).childNodes(0).childNodes(0).xml));
    fcpubdata.area.outerHTML = unescape(oUndo.documentElement.childNodes(lngKey).childNodes(1).childNodes(0).xml);
    //恢复对象属树形结构(替代了下面的openobjlist()方法)
    $(parent.objlist.browser).html(unescape(oUndo.documentElement.childNodes(lngKey).childNodes(2).childNodes(0).xml))
    fcpubdata.area = $id("SKbillsheet");
    //openobjlist();
}

function DeleteoRedoOneRecord(intR) {
    oRedo.documentElement.removeChild(oRedo.documentElement.childNodes.item(intR));
}

function DeleteoUndoOneRecord(intR) {
    oUndo.documentElement.removeChild(oUndo.documentElement.childNodes.item(intR));
}


function cmdRedo() {
    var intMaxR = oRedo.documentElement.childNodes.length - 1;
    if (lngRedo >= 0 && lngRedo <= intMaxR) {
        ReadoRedoOneRecord(lngRedo);
        lngUndo = lngRedo;
        lngRedo = lngRedo + 1;
    }
    window.focus();
    fcpubdata.area.focus();
}

function cmdUndo() {
    var intMaxR = oUndo.documentElement.childNodes.length - 1;
    if (lngUndo >= 0 && lngUndo <= intMaxR) {
        ReadoUndoOneRecord(lngUndo);
        lngRedo = lngUndo;
        lngUndo = lngUndo - 1;
    }
    window.focus();
    fcpubdata.area.focus();
}
function resizeStart() {
    SaveoUndoOneRecord();
}
function resizeEnd() {
    SaveoRedoOneRecord();
}
function moveStart() {
    SaveoUndoOneRecord();
}
function moveEnd() {
    SaveoRedoOneRecord();
    AutoFitToGrid();
}

/*
 * 函数功能： 自动对齐html控件到网格线上
 * 参数说明： 该函数截获拖拽的控件的移动事件，因此不需要传递参数。
 * 方法说明： 该函数通过被拖拽的控件的坐标（因为可以拖拽，所以肯定是绝对位置），来判断上下边框或者是左右边框相对控件边界
 *          的距离。并且自动“吸附”到离控件边界最近的边框上。实现类似“磁铁”似的吸附功能。为用户拖拽定位控件提供方便。
 * 原始作者： 佘 斌
 * 创作事件： 2010-09-21
 */
function AutoFitToGrid() {
    o = event.srcElement;
    var topvalue = parseInt(o.style.top.replace("px", "")); //防止高度后面带有单位，目前只考虑了像素的情况
    var heightvalue = parseInt(o.offsetHeight);  //需要使用offsetHeight属性，IE下没问题，比知道其他浏览器情况
    var leftvalue = parseInt(o.style.left.replace("px",""));
    var widthvalue = parseInt(o.offsetWidth);

    //取当前控件离最近的表格线的最小距离的绝对值
    var TopOffset = topvalue % 10;
    if (TopOffset > 5) {
        TopOffset = 10 - TopOffset;
    }
    var BottomOffset = (topvalue + heightvalue) % 10;
    if (BottomOffset > 5) {
        BottomOffset = 10 - BottomOffset;
    }

    var LeftOffset = leftvalue % 10;
    if (LeftOffset > 5) {
        LeftOffset = 10 - LeftOffset;
    }
    var RightOffset = (leftvalue + widthvalue) % 10;
    if (RightOffset > 5) {
        RightOffset = 10 - RightOffset;
    }

    //根据绝对值的大小，定位控件的坐标
    if (TopOffset < BottomOffset) {
        if ((topvalue - TopOffset) % 10 == 0) {
            o.style.top = (topvalue - TopOffset).toString() + "px";
        } else {
            o.style.top = (topvalue + TopOffset).toString() + "px";
        }

    }
    else {
        if ((topvalue - BottomOffset) % 10 == 0) {
            o.style.top = (topvalue - BottomOffset).toString() + "px";
        } else {
            o.style.top = (topvalue + BottomOffset).toString() + "px";
        }
    }

    if (LeftOffset < RightOffset) {
        if ((leftvalue - LeftOffset) % 10 == 0) {
            o.style.left = (leftvalue - LeftOffset).toString() + "px";
        } else {
            o.style.left = (leftvalue + LeftOffset).toString() + "px";
        }
    }
    else {
        if ((leftvalue - RightOffset) % 10 == 0) {
            o.style.left = (leftvalue - RightOffset).toString() + "px";
        } else {
            o.style.left = (leftvalue + RightOffset).toString() + "px";
        }
    }
}

function IsDivCont() {
    if (curSelElement == null) return false;
    if (curSelElement.id == "fcpagesub" || curSelElement.controltype == "div" || curSelElement.controltype == "tab") return true;
    return false;

}

function htmltocont(sHtml, comType, NotOne) {
    SaveoUndoOneRecord();
    if (curSelElement == null) {
        fcpubdata.area.innerHTML += sHtml;
    } else if (curSelElement.id == "fcpagesub") {
        curSelElement.innerHTML += sHtml;
    } else if (curSelElement.controltype == "tab") {
        var l = curSelElement.childNodes.length;
        for (var i = 1; i < l; i++) {
            if (curSelElement.childNodes(i).style.zIndex == 1) {
                curSelElement.childNodes(i).innerHTML += sHtml;
                break;
            }
        }
    } else if (curSelElement.controltype == "div" || curSelElement.controltype == "fieldset" || curSelElement.tagName == "TD") {
        //sHtml = sHtml.replace("absolute", "static");
        var newDom = $(sHtml);
        newDom.css("top", "5px");
        newDom.css("left", "5px");
        sHtml = "";
        for (i = 0; i < newDom.length; i++) {
            sHtml = sHtml + newDom[i].outerHTML;
        }
        curSelElement.innerHTML += sHtml;
    }else if (curSelElement.controltype == "ebiao") {
        if (curSelElement.innerHTML != "") {
            var oTd = new Eapi.EformEbiao().getEmptyTd(curSelElement);
            if (oTd == null) {
                alert("没有能够装控件的单元格,控件将被加到外面.");
                fcpubdata.area.innerHTML += sHtml;
            } else {
                oTd.backupValue = oTd.innerText;
                oTd.innerHTML = sHtml;
                var oDrag = oTd.childNodes(0);
                oDrag.style.position = "static";
                oDrag.style.width = "100%";
                oDrag.style.height = "100%";

            }
        }
    } else {
        fcpubdata.area.innerHTML += sHtml;
    }

    //设置焦点，可以防止添加控件之后点击第一次无效（第一次是设置了焦点）的情况
    fcpubdata.area.focus();
    

    if (NotOne == "是") {
    } else {
        try {
            AddContXml(comType);
        } catch (e) { }
    }
    blnChange = true;
    SaveoRedoOneRecord();
}

//添加了一个参数ParentId，用来指定当前DOM节点的父节点
function AddContXml(comType, contID, ParentId) {
    if (isSpace(contID)) contID = comType + ArrNum[comType];
    var oNode = oContXml.documentElement.selectSingleNode("//id[. ='" + contID + "']");
    if (oNode != null) return;
    var oNode = oContXml.documentElement.selectSingleNode(comType);
    if (oNode == null) {
        var sxml = "<" + comType + "><id>" + contID + "</id></" + comType + ">";
        var oX = SetDom(sxml);
        oContXml.documentElement.appendChild(oX.documentElement);
    } else {
        var sxml = "<id>" + contID + "</id>";
        var oX = SetDom(sxml);
        oNode.appendChild(oX.documentElement);
    }

    //得到容器点的ID，以便形成树形结构.这个地方因为考虑到有些父控件是为了布局用的，所以使用了一个循环。可能还需要修改 sbin amend 2010-10-09
    if (ParentId == null || ParentId == "") {
        var curChild = document.getElementById(contID);
        var curElement = null;
        if (curChild != null) {
            curElement = document.getElementById(contID).parentElement;
        } else {
            curElement = curSelElement;
        }
        if (curElement != null) {
            ParentId = curElement.id;
            while (ParentId == "") {
                curElement = curElement.parentElement;
                ParentId = curElement.id;
            }
        }
    }
    
    if (ParentId != null && ParentId != "SKbillsheet") {
        parent.objlist.execScript("objlist_add('" + ParentId + "','" + contID + "','" + comType + "')");
    }
    else {
        parent.objlist.execScript("objlist_add('','" + contID + "','" + comType + "')");
    }
    
}


function CopyCont() {
    var sAll = "fc__~$#@__fc";
    var stype = "";
    if (document.selection.type == "Control") {
        var o = document.selection.createRange();
        strXml = "";
        function CreateContStr(obj) {
            for (var i = 0; i < obj.length; i++) {
                if (obj(i).children.length > 0) {
                    CreateContStr(obj(i).children);
                }
                var sid = obj(i).id;
                var svalue = obj(i).value;
                if (isSpace(obj(i).controltype)) {
                    for (var j = 0; j < ArrName.length; j++) {
                        if (sid.indexOf(ArrName[j]) >= 0) {
                            stype = ArrName[j];
                            break;
                        }
                    }
                } else {
                    stype = obj(i).controltype;
                }
                if (isSpace(stype)) return;
                strXml = "<Node><id>" + sid + "</id><type>" + stype + "</type></Node>" + strXml;
            }
        }
        CreateContStr(o);
        for (var i = 0; i < o.length; i++) {
            var strHtm = o(i).outerHTML;
            sAll += strHtm;
        }
            
    }
   
    if (sAll != "") {
        sAll = new Eapi.Str().trim(sAll);
        CopyToPub(sAll);
        SavePubData("stmpid", strXml);
        return true;
    } else {
        return false;
    }
}


function PasteCont() {
    try {
        fcpubdata.area.focus();
    } catch (e) { }
    var s1 = window.clipboardData.getData("Text");
    if (isSpace(s1)) return false;
    var sAll = "fc__~$#@__fc";
    if (s1.substring(0, 12) != sAll) {
        return false;
    }
    s1 = s1.substring(12, s1.length);
    sXml = LoadPubData("stmpid");
    if (isSpace(sXml)) return false;
    var oXml = new ActiveXObject("Microsoft.XMLDOM");
    oXml.async = false;
    oXml.loadXML("<root>" + sXml + "</root>");
    var newid = "";
    var sLen = oXml.documentElement.childNodes.length;
    var arrNewId = new Array();
    for (var i = 0; i < sLen; i++) {
        sid = oXml.documentElement.childNodes(i).childNodes(0).text;
        stype = oXml.documentElement.childNodes(i).childNodes(1).text;
        newid = sid;
        for (j = 0; j < ArrName.length; j++) {
            if (stype == ArrName[j]) {
                if (ObjIsHave(newid)) {
                    newid = getNewContID(stype, oContXml, ArrNum[stype]);
                }
                searchStr = "id=" + sid + " ";
                replaceStr = "id=" + newid + " ";
                svalue = "value=" + sid + " ";
                repvalue = "value=" + newid + " ";
                s1 = RepStr(s1, searchStr, replaceStr);
                s1 = RepStr(s1, svalue, repvalue);

                //如果能找到父节点就传父节点的值
                var parentid = "";
                var curnode = $(s1).find("#" + sid);
                if (curnode.length >0) {
                    parentnode = curnode[0].parentElement;
                    if (parentnode != undefined) {
                        parentid = parentnode.id;
                    }
                }
                AddContXml(stype, newid,parentid);
                arrNewId[i] = newid;
                break;
            }
        }
    }

    htmltocont(s1, "", "是");
    var oControlRange = document.body.createControlRange();
    for (var i = 0; i < sLen; i++) {
        try {
            oControlRange.add(eval(arrNewId[i]));
        } catch (e) { }
    }
    try {
        oControlRange.select();
    } catch (e) { }


    if (IsDivCont() == false) curSelElement = null;
    return true;
    function ObjIsHave(sid) {
        try {
            var obj = eval(sid);
            return true;
        } catch (E) {
            return false;
        }

    }
}
function CurrSel() {
    var sArray = new Array();
    if (document.selection.type == "Control") {
        var ii = 0;
        var o = document.selection.createRange();
        for (var i = 0; i < o.length; i++) {
            var sid = o(i).id;
            if (isSpace(sid) == false) {
                sArray[ii] = eval(sid);
                ii++;
            }
        }
    }
    return sArray;
}

function main_onkeydel() {
    if (curSelElement == null) return;
    if (curSelElement.id == "fcpagesub" || curSelElement.id == "fcpagesubtable") return;
    main_onkeydown(46);
    main_exec('Delete');
    main_onkeyup(46);
}
function main_onkeyup(skeycode) {
    if (typeof (skeycode) == "undefined") {
        var scode = event.keyCode;
    } else {
        var scode = skeycode;
    }
    if (scode == 46) {
        SaveoRedoOneRecord();
    }
}

function main_onkeydown(skeycode, sshift, sctrl) {
    var sArray = CurrSel();
    if (arguments.length == 0) {
        var scode = event.keyCode;
        var skey = event.shiftKey;
        var sctrlkey = event.ctrlKey;
    } else {
        var scode = skeycode;
        var skey = sshift;
        var sctrlkey = sctrl;
    }
    if (scode == 46) {
        var ltmp = sArray.length;
        for (var jj = 0; jj < ltmp; jj++) {
            if (isSpace(sArray[jj].controltype)) {
                try {
                    event.returnValue = false;
                } catch (e) { }
                return;
            }
        }
        SaveoUndoOneRecord();
        var oXml = null;
        var sxml = fcpubdata.area.billtaborder;
        if (isSpace(sxml) == false) {
            oXml = SetDom(sxml);
        }
        del_cont(sArray, oContXml, oXml);
        if (oXml != null) {
            fcpubdata.area.billtaborder = oXml.documentElement.xml;
        }
        curSelElement = null;
        return;
    }

    function del_cont(arr, oContXml, oXml) {
        for (var i = 0; i < arr.length; i++) {
            var sid = arr[i].id;
            if (isSpace(sid)) continue;
            var comType = arr[i].controltype;
            if (isSpace(comType)) {
                var l = ArrName.length;
                for (var ii = 0; ii < l; ii++) {
                    if (sid.indexOf(ArrName[ii]) == 0) {
                        comType = ArrName[ii];
                        break;
                    }
                }
            }
            if (isSpace(comType)) continue;
            var oNode = oContXml.documentElement.selectSingleNode(comType);
            if (oNode != null) {
                var oNodeSub = oNode.selectSingleNode("//id[. ='" + sid + "']");
                if (oNodeSub != null) {
                    oNode.removeChild(oNodeSub);
                    parent.objlist.execScript("objlist_del('" + sid + "')");
                    if (comType == "dataset") {
                        ShowAllField();
                    }
                }
            }
            if (oXml != null) {
                var oNode = oXml.documentElement.selectSingleNode("//taborder[. ='" + sid + "']");
                if (oNode != null) {
                    oXml.documentElement.removeChild(oNode);
                }
            }
            if (comType == "div") {
                del_cont(arr[i].all, oContXml, oXml);
            } else if (comType == "tab") {
                for (var jj = 1; jj < arr[i].childNodes.length; jj++) {
                    del_cont(arr[i].childNodes(jj).all, oContXml, oXml);
                }
            }
            if (arr[i].parentNode.tagName == "TD") {
                if (arr[i].parentNode.parentNode.parentNode.parentNode.parentNode.controltype == "ebiao") {
                    var oTd = arr[i].parentNode;
                    if (typeof (oTd.backupValue) != "undefined") {
                        oTd.innerText = oTd.backupValue;
                        oTd.removeAttribute("backupValue");
                    }
                }
            }
        }
    }

    if (sctrlkey == true) {
        switch (scode) {
            case 40:
                {
                    for (var s = 0; s < sArray.length; s++) {
                        if (sArray[s].style.top != null && sArray[s].style.top != "") {
                            sArray[s].style.top = parseInt(sArray[s].style.top) + 1;
                        }
                    }
                    blnChange = true;
                    event.returnValue = false;
                    break;
                }
            case 38:
                {
                    for (var M = 0; M < sArray.length; M++) {
                        if (sArray[M].style.top != null && sArray[M].style.top != "") {
                            sArray[M].style.top = parseInt(sArray[M].style.top) - 1;
                        }
                    }
                    blnChange = true;
                    event.returnValue = false;
                    break;
                }
            case 39:
                {
                    for (var t = 0; t < sArray.length; t++) {
                        if (sArray[t].style.left != null && sArray[t].style.left != "") {
                            sArray[t].style.left = parseInt(sArray[t].style.left) + 1;
                        }
                        
                    }
                    blnChange = true;
                    event.returnValue = false;
                    break;
                }
            case 37:
                {
                    for (var N = 0; N < sArray.length; N++) {
                        if (sArray[N].style.left != null && sArray[N].style.left != "") {
                            sArray[N].style.left = parseInt(sArray[N].style.left) - 1;
                        }
                        
                    }
                    blnChange = true;
                    event.returnValue = false;
                    break;
                }
            case 67: 
                {
                    if (CopyCont()) {
                        event.returnValue = false;
                    }
                    break;
                }
            case 86: 
                {
                    if (PasteCont()) {
                        event.returnValue = false;
                    }
                    break;
                }
            case 88: 
                {
                    if (CopyCont()) {
                        main_onkeydown(46);
                        main_exec('Delete');
                        main_onkeyup(46);
                        event.returnValue = false;
                    }
                    break;
                }
            case 90: 
                {
                    cmdUndo();
                    break;
                }
            case 89: 
                {
                    cmdRedo();
                    break;
                }
            case 83: 
                {
                    Addobj('save');
                    event.returnValue = false;
                    break;
                }
            case 65: 
                {
                    if (sArray.length == 1) {
                        try {
                            if (sArray[0].controltype == "ep_band")
                                BandSelectAll(sArray[0]);
                        }
                        catch (e) { };
                    }
                    event.returnValue = false;
                    break;
                }
        }
    }



    if (skey == true) {
        switch (scode) {
            case 40:
                {
                    for (var Lent = 0; Lent < sArray.length; Lent++) {
                        if (sArray[Lent].style.height != null) {
                            sArray[Lent].style.height = parseInt(sArray[Lent].style.height) + 1;
                        }
                    }
                    blnChange = true;
                    event.returnValue = false;
                    break;
                }
            case 38:
                {
                    for (var d = 0; d < sArray.length; d++) {
                        if (sArray[d].style.height != null) {
                            sArray[d].style.height = parseInt(sArray[d].style.height) - 1;
                        }
                    }
                    blnChange = true;
                    event.returnValue = false;
                    break;
                }
            case 39:
                {
                    for (var k = 0; k < sArray.length; k++) {
                        if (sArray[k].style.width != null) {
                            sArray[k].style.width = parseInt(sArray[k].style.width) + 1;
                        }
                    }
                    blnChange = true;
                    event.returnValue = false;
                    break;
                }
            case 37:
                {
                    for (var j = 0; j < sArray.length; j++) {
                        if (sArray[j].style.width != null) {
                            sArray[j].style.width = parseInt(sArray[j].style.width) - 1;
                        }
                    }
                    blnChange = true;
                    event.returnValue = false;
                    break;
                }
        }
    }
}


function SelectObj(sid, noadd_objlist) {
    blnChange = true;
    if (typeof noadd_objlist == "undefined") {
        if (curSelElement != null) {
            if (IsDivCont()) return;
        }
    }
    try {
        var oControlRange = document.body.createControlRange();
        oControlRange.add(eval(sid));
        oControlRange.select();
    } catch (e) { }
}

function openobjlist() {
    parent.objlist.document.onreadystatechange = function () {
        openobjlist_sub();
    }
    openobjlist_sub();
}

function openobjlist_sub() {
    if (parent.objlist.document.readyState == "complete") {

        //parent.objlist.select1.options.length = 0;
        var sOpt = new Sys.StringBuilder();
        var l = oContXml.documentElement.childNodes.length;
        for (var i = 0; i < l; i++) {
            var l1 = oContXml.documentElement.childNodes(i).childNodes.length;
            var comtype = oContXml.documentElement.childNodes(i).tagName;
            for (var j = 0; j < l1; j++) {
                sOpt.append("<option controltype='" + comtype + "'>" + oContXml.documentElement.childNodes(i).childNodes(j).text + "</option>");
            }
        }
        var objList = parent.objlist.select1;
        if (objList != null) {
            objList.outerHTML = SelectAddOption(objList, sOpt.toString());
        }
    }

}

function ShowAllField() {
    if (typeof (parent.objlist.cboField) == "undefined") {
        parent.objlist.document.onreadystatechange = function () {
            if (parent.objlist.document.readyState == "complete") _tempBody();
        }
    } else {
        _tempBody();
    }
    function _tempBody() {
        parent.objlist.cboField.options.length = 0;
        var sOption = new Sys.StringBuilder();
        var oNode = oContXml.documentElement.selectSingleNode("dataset");
        if (oNode != null) {
            var l = oNode.childNodes.length;
            for (var i = 0; i < l; i++) {
                var id = oNode.childNodes(i).text;
                var ods = eval(id);
                if (IsSpace(ods.formatxml)) continue;
                var oXml = SetDom(ods.formatxml);
                if (oXml.documentElement == null) continue;
                var ll = oXml.documentElement.childNodes.length;
                if (ll <= 1) continue;
                if (ll > 1) sOption.append("<OPTGROUP LABEL=\"" + id + "\">");
                for (var j = 0; j < ll; j++) {
                    sOption.append("<option value='" + oXml.documentElement.childNodes(j).childNodes(0).text + "'>" + oXml.documentElement.childNodes(j).childNodes(1).text + "</option>");
                }
                if (ll > 1) sOption.append("</OPTGROUP>");

            }
        }
        parent.objlist.cboField.outerHTML = '<SELECT size=2 id="cboField" style="width:100%;height:47%" ondblclick=selectField()>' + sOption.toString() + '</SELECT>';
    }
}

function AddBindField(dsName, fieldName, chnName) {
    var sPosition = "";
    if (curSelElement != null && curSelElement.tagName.toUpperCase() == "TD") {
        sPosition = "inTD";
    }
    var obj = getFieldInputStr(dsName, fieldName, chnName, sPosition);
    if (obj.content != "") {
        AddContXml(obj.type, obj.sid);
        htmltocont(obj.content, obj.type, "是");
        SelectObj(obj.sid);
    } else {
        alert("当前字段默认设置为隐藏！");
    }

}

function getFieldInputStr(dsName, fieldName, chnName, sPosition) {
    var sStr = new Sys.StringBuilder();
    var sType = "";
    var retWidth = 0, retHeight = 20;
    var sWid = "";
    var sHei = "20px";
    var sBorder = " BORDER-BOTTOM: silver 1px solid;";
    var sid = "";
    if (sPosition == "inTD") {
        sWid = "100%";
        sHei = "100%";
        sBorder = "";
        sPosition = "";
    }
    if (sWid == "") {
        var sSql = "select objwidth from " + fcpubdata.dbStruDict + " where fdname='" + fieldName + "'";
        sWid = SqlToField(sSql);
        sWid = sWid.trim();
        if (IsSpace(sWid)) {
            sWid = "80";
        }
    }
    retWidth = Num(sWid);
    var sSql = "select inputstyle from " + fcpubdata.dbStruDict + " where fdname='" + fieldName + "'";
    var sV1 = SqlToField(sSql);
    if (isSpace(sV1) == false && sV1 != "NULL") {
        var oo = SetDom(sV1);
        if (oo.documentElement != null) {
            if (oo.documentElement.childNodes.length >= 1) var sX0 = UnRepXml(oo.documentElement.childNodes(0).text);
            if (oo.documentElement.childNodes.length >= 2) var sX = UnRepXml(oo.documentElement.childNodes(1).text);
            if (oo.documentElement.childNodes.length >= 3) var sX2 = UnRepXml(oo.documentElement.childNodes(2).text);
            if (oo.documentElement.childNodes.length >= 4) var spubOption = UnRepXml(oo.documentElement.childNodes(3).text);
            if (oo.documentElement.childNodes.length >= 5) var spubFormat = UnRepXml(oo.documentElement.childNodes(4).text);
            var spubCheck = "1";
            if (IsSpace(sX2) == false) spubCheck = "2";
            sType = oo.documentElement.nodeName;
            switch (sType) {
                case 'radio': 
                    {
                        retHeight = 50;
                        sid = "rdo" + fieldName;
                        sStr.append('<FIELDSET id="' + sid + '" dataset="' + dsName + '"  china="' + chnName + '" field="' + fieldName + '" onresizeend=resizeEnd() onresizestart=resizeStart() onmoveend=moveEnd() contentEditable=false style="' + sPosition + '; WIDTH: ' + retWidth + '; HEIGHT: ' + retHeight + 'px; " onmovestart=moveStart() value="-1" controltype="radio" tempvalue="' + sX0 + '" temptext="' + sX + '" aspect="横向" readOnly="false" legend="' + chnName + '"><LEGEND>' + chnName + '</LEGEND>');
                        var rdolen = sX.split('\n');
                        var rdol = sX0.split('\n');
                        for (var jj = 0; jj < rdolen.length; jj++) {
                            sStr.append('<INPUT type=radio value="' + rdol[jj] + '" name=RGrdo' + fieldName + ' text="' + rdolen[jj] + '"><SPAN onclick=RGrdo' + fieldName + '[' + jj + '].checked=true;');
                            sStr.append('rdo' + fieldName + '.value=RGrdo' + fieldName + '[' + jj + '].value;RGrdo' + fieldName + '[' + jj + '].focus();>' + rdolen[jj] + '</SPAN>&nbsp;');
                        }
                        sStr.append('</FIELDSET>');
                        break;
                    }
                case 'readonly': 
                    {
                        sid = "txt" + fieldName;
                        sStr.append('<INPUT type=text onmove=move() readOnly oncontrolselect=controlselect() id="' + sid + '" onresizeend=resizeEnd() onresizestart=resizeStart() onmoveend=moveEnd() onresize=resize() ');
                        sStr.append('style="' + sPosition + '' + sBorder + '; WIDTH: ' + retWidth + '; HEIGHT: ' + retHeight + '; TEXT-ALIGN: left" onmovestart=moveStart() ');
                        sStr.append('controltype="text" dataset="' + dsName + '" value="' + chnName + '" CanSelect="false" china="' + chnName + '" field="' + fieldName + '"></INPUT>');
                        break;
                    }
                case 'facard': 
                    {
                        sid = "txt" + fieldName;
                        sStr.append('<INPUT type=text onmove=move() oncontrolselect=controlselect() id="' + sid + '" onresizeend=resizeEnd() onresizestart=resizeStart() onmoveend=moveEnd() onresize=resize() ');
                        sStr.append('style="' + sPosition + '' + sBorder + '; WIDTH: ' + retWidth + '; HEIGHT: ' + retHeight + '; " onmovestart=moveStart() ');
                        sStr.append('controltype="text" dataset="' + dsName + '" value="' + chnName + '" CanSelect="false" china="' + chnName + '" field="' + fieldName + '"></INPUT>');
                        var sfacard = "SelectZlSql('" + sX0 + "','" + sX2 + "','" + sX + "')";
                        var sPosition1 = "";
                        if (sPosition != "inTD" && sPosition != "") {
                            sPosition1 = new Eapi.Css().changePosition(sPosition, "LEFT", retWidth);
                        }

                        sStr.append('<BUTTON onmove=move() oncontrolselect=controlselect() id=cmd_' + fieldName + ' onresizeend=resizeEnd() onresizestart=resizeStart() onmoveend=moveEnd() onresize=resize() style="' + sPosition1 + 'BORDER-RIGHT: 0px; BORDER-TOP: 0px; BORDER-LEFT: 0px; WIDTH: 17px; BORDER-BOTTOM: 0px; BACKGROUND-REPEAT: no-repeat; HEIGHT: 18px; " onmovestart=moveStart() controltype="button" fc_onclick="bill_onclick(&quot;' + sfacard + '&quot;)" dropstyle="是"></BUTTON>');
                        retWidth += 17;
                        break;
                    }
                case 'hidden': 
                    {
                        sStr.append('');
                        retWidth = 0;
                        retHeight = 0;
                        break;
                    }
                case 'checkbox': 
                    {
                        retHeight = 20;
                        sid = "chk" + fieldName;
                        sStr.append('<DIV onmove=move() dataset="' + dsName + '"  china="' + chnName + '" field="' + fieldName + '" truevalue="' + sX0 + '" falsevalue="' + sX + '" oncontrolselect=controlselect() id="' + sid + '" onresizeend=resizeEnd() onresizestart=resizeStart() onmoveend=moveEnd() onresize=resize() style="' + sPosition + '; WIDTH: ' + retWidth + '; HEIGHT: ' + retHeight + 'px;" onmovestart=moveStart() noWrap value="否" falsevalue="否" truevalue="是" controltype="checkbox"><INPUT oncontrolselect=controlselectcancel() type=checkbox><SPAN>' + chnName + '</SPAN></DIV>');
                        break;
                    }
                case 'date': 
                    {
                        retHeight = 20;
                        retWidth = 80;
                        sid = "txt" + fieldName;
                        sStr.append('<INPUT type=text onmove=move() oncontrolselect=controlselect() id="' + sid + '" onresizeend=resizeEnd() onresizestart=resizeStart() onmoveend=moveEnd() onresize=resize() ');
                        sStr.append('style="' + sPosition + '' + sBorder + '; WIDTH: ' + retWidth + 'px; HEIGHT: ' + retHeight + 'px; TEXT-ALIGN: left" onmovestart=moveStart() ');
                        sStr.append('controltype="text" dataset="' + dsName + '" value="' + chnName + '" CanSelect="false" china="' + chnName + '" field="' + fieldName + '"></INPUT>');
                        var Selectdt = "SelectDate(txt" + fieldName + ")";
                        var sQuot = "&quot;";
                        var Seldate = "bill_onclick(" + sQuot + Selectdt + sQuot + ")";
                        var sPosition1 = "";
                        if (sPosition != "inTD" && sPosition != "") {
                            sPosition1 = new Eapi.Css().changePosition(sPosition, "LEFT", retWidth);
                        }
                        sStr.append('<BUTTON onmove=move() oncontrolselect=controlselect() id=cmd_' + fieldName + ' onresizeend=resizeEnd() onresizestart=resizeStart() onmoveend=moveEnd() onresize=resize() style="' + sPosition1 + 'BORDER-RIGHT: 0px; BORDER-TOP: 0px; BORDER-LEFT: 0px; WIDTH: 17px; BORDER-BOTTOM: 0px; BACKGROUND-REPEAT: no-repeat; HEIGHT: 18px; " onmovestart=moveStart() controltype="button" fc_onclick="' + Seldate + '" dropstyle="是"></BUTTON>');
                        retWidth += 17;
                        break;
                    }
                case 'textarea': 
                    {
                        retHeight = 50;
                        sid = "txt" + fieldName;
                        sStr.append('<TEXTAREA onmove=move() dataset="' + dsName + '"  china="' + chnName + '" field="' + fieldName + '" oncontrolselect=controlselect() id="' + sid + '" onresizeend=resizeEnd() onresizestart=resizeStart() onmoveend=moveEnd() onresize=resize() style="' + sPosition + ';WIDTH: ' + retWidth + '; HEIGHT: ' + retHeight + '" onmovestart=moveStart() cols=26 controltype="textarea" value=""></TEXTAREA>');
                        break;
                    }
                case 'combobox': 
                    {
                        retHeight = 25;
                        sid = "cbo" + fieldName;
                        sStr.append('<SELECT onmove=move() oncontrolselect=controlselect() id="' + sid + '" onresizeend=resizeEnd() onresizestart=resizeStart() onmoveend=moveEnd() onresize=resize() ');
                        sStr.append('style="' + sPosition + '; WIDTH: ' + retWidth + '; HEIGHT: ' + retHeight + 'px; " onmovestart=moveStart() controltype="combobox" ');
                        sStr.append('check="' + spubCheck + '" dataset="' + dsName + '" tempvalue="' + sX0 + '" temptext="' + sX + '" sql="' + sX2 + '"  china="' + chnName + '" field="' + fieldName + '">');
                        sStr.append(spubOption);
                        sStr.append('</SELECT>');
                        break;
                    }
                case 'listbox': 
                    {
                        retHeight = 50;
                        sid = "lst" + fieldName;
                        sStr.append('<SELECT onmove=move() oncontrolselect=controlselect() id="' + sid + '" onresizeend=resizeEnd() onresizestart=resizeStart() onmoveend=moveEnd() onresize=resize() style="' + sPosition + '; ');
                        sStr.append('WIDTH: ' + retWidth + '; HEIGHT: ' + retHeight + 'px; " onmovestart=moveStart() size=8 controltype="listbox"');
                        sStr.append('dataset="' + dsName + '" china="' + chnName + '" field="' + fieldName + '" check="' + spubCheck + '" tempvalue="' + sX0 + '" temptext="' + sX + '" sql="' + sX2 + '">');
                        sStr.append(spubOption);
                        sStr.append('</SELECT>');
                        break;
                    }
                case 'dropdownlist': 
                    {
                        sid = "ddl" + fieldName;
                        sStr.append('<IMG id="' + sid + '" onresizeend=resizeEnd() onresizestart=resizeStart() onmoveend=moveEnd() style="' + sPosition);
                        sStr.append('WIDTH: ' + retWidth + '; HEIGHT: ' + retHeight + 'px; ');
                        sStr.append('ButtonWidth: 10" onmovestart=moveStart() src="../images/ef_designer_fccode.gif" controltype="dropdownlist" ');
                        sStr.append('dataset="' + dsName + '" china="' + chnName + '" field="' + fieldName + '" check="' + spubCheck + '" tempvalue="' + sX0 + '" temptext="' + sX + '" visible="是" blninput="是" blnempty="否" addrow="否" multiselect="否" sql1="' + sX2 + '" xml="' + spubOption + '" format="' + spubFormat + '" >');
                        break;
                    }
                default: 
                    {
                        sType = "";
                    }
            }
        }
    }
    if (sStr.isEmpty() && sType == "") {
        sType = "text";
        sid = "txt" + fieldName;
        sStr.append('<INPUT type=text onmove=move() oncontrolselect=controlselect() id="' + sid + '" onresizeend=resizeEnd() onresizestart=resizeStart() onmoveend=moveEnd() onresize=resize() ');
        sStr.append('style="' + sPosition + '' + sBorder + 'FONT-SIZE: 12px; WIDTH: ' + retWidth + '; HEIGHT: ' + retHeight + 'px; TEXT-ALIGN: left" onmovestart=moveStart() ');
        sStr.append('controltype="text" dataset="' + dsName + '" value="' + chnName + '" CanSelect="false" china="' + chnName + '" field="' + fieldName + '"></INPUT>');
    }
    return { type: sType, sid: sid, content: sStr.toString(), width: retWidth, height: retHeight };

}

function AutoAddDsMain() {
    if (fcpubdata.autoAddField == "yes") {
        var tablename = "";
        var newdjsn = parent.Request.QueryString("newdjsn").toString();
        if (isSpace(newdjsn)) {
            tablename = "UD_" + getMaxNo("BBB");
        } else {
            tablename = "UD_" + newdjsn;
            fcpubdata.area.dj_sn = newdjsn;
        }
        var s1 = "GetSession('userid')['userid']";
        var sHtml = "<img controltype='dataset' id=DsMain opensortno=1 style='position:absolute;Left:400;Top:5;Height:47;Width:39;' src='../images/ef_designer_dataset.gif' onmovestart=moveStart() onmoveend=moveEnd() onresizestart=resizeStart() onresizeend=resizeEnd() formatxml=\"<root><tr><td>mainkey</td><td>mainkey</td><td>字符</td><td>11</td><td>0</td><td>数据项</td><td></td><td></td><td>否</td><td>否</td><td>否</td><td>否</td><td>是</td><td>否</td><td>否</td><td>否</td><td></td><td></td><td>left</td><td>80</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr><tr><td>userid</td><td>用户ID</td><td>字符</td><td>100</td><td>0</td><td>变量默认值</td><td>" + s1 + "</td><td></td><td>否</td><td>否</td><td>否</td><td>否</td><td>是</td><td>否</td><td>否</td><td>否</td><td></td><td></td><td>left</td><td>80</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr></root>\" AfterScroll=\"fcpubdata.keyValue=DsMain.Field('mainkey').Value\" BeforeOpen=\"DsMain.PageSize=1;\"   saveastable=\"" + tablename + "\" opensql=\"select * from " + tablename + " \" >";

        fcpubdata.area.innerHTML += sHtml;
        AddContXml("dataset", "DsMain");
        fcpubdata.area.keyfield = "mainkey";
        fcpubdata.area.toolbar = "单表输入工具栏";
        var newdjtype = parent.Request.QueryString("newdjtype").toString();
        if (isSpace(newdjtype) == false)
            fcpubdata.area.type = newdjtype;
        var newdjname = parent.Request.QueryString("newdjname").toString();
        if (isSpace(newdjname) == false)
            fcpubdata.area.caption = unescape(newdjname);
    }

}

function AutoAddQueryDj() {
    var allbak = fcpubdata.area.innerHTML;
    DsMain.id = "PubQueryGridDs"
    PubQueryGridDs.opensortno = "5";
    PubQueryGridDs.opensql = "";
    PubQueryGridDs.saveastable = "";
    PubQueryGridDs.BeforeOpen = "ActionQueryCond();";
    fcpubdata.area.innerHTML = '<DIV onmove=move() oncontrolselect=controlselect() id=divQueryFilter onresizeend=resizeEnd() onresizestart=resizeStart() onmoveend=moveEnd() onresize=resize() style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; OVERFLOW-Y: scroll; LEFT: 1px; OVERFLOW-X: scroll; OVERFLOW: auto; BORDER-LEFT: black 1px solid; WIDTH: 97%; BORDER-BOTTOM: black 1px solid; POSITION: absolute; TOP: 11px; HEIGHT: 214px; BACKGROUND-COLOR: #ffffff" onmovestart=moveStart() controltype="div" NotBg="否">' + allbak + '</DIV><IMG id=PubQueryGrid onresizeend=resizeEnd() onresizestart=resizeStart() onmoveend=moveEnd() style="LEFT: 1px; WIDTH: 979px; POSITION: absolute; TOP: 229px; HEIGHT: 289px" onmovestart=moveStart() src="' + fcpubdata.root + '/images/ef_designer_webgrid.gif" controltype="grid" dataset="PubQueryGridDs" canselect="是" autoheight="是" autowidth="是" autoappend="否" readonly="否" visible="是" titlerowheight usertitle="否" iscrosstab="否" rcount="否" rsum="否" rmin="否" rmax="否" ravg="否" ccount="否" csum="否" cmin="否" cmax="否" cavg="否" titlerows usertitlehtml crosstabtitle crosstabdatatype crosstabsumtype crosstabformat rowtitle coltitle crosstabsql>' + PubQueryGridDs.outerHTML;

    var o = window.document.all.tags("button");
    var l = o.length;
    for (var ii = 0; ii < l; ii++) {
        o[ii].style.display = "none";
    }
    fcpubdata.area.dj_sn = fcpubdata.area.dj_sn + "_auto_query";
    fcpubdata.area.toolbar = "查询工具栏";
    curdjid = 0;
    DesignDjSave("不提示");
}

function e_open_ebiao_form() {
    var obj = parent.dialogArguments;
    var s1 = obj.eform_winprop;
    if (typeof s1 == "undefined") s1 = "";
    var sRet = DjOpen('eb_parawin', s1, '展现', "有模式窗口", "直接", "设置窗口相关属性");
    if (IsSpace(sRet) == false) {
        obj.eform_winprop = sRet;
    }

}

function ef_AddRecentFile(sFile) {
    var s = fcpubdata.recentFile;
    if (typeof s == "undefined") return;
    if (s.length > 0) {
        var pos = s.indexOf(";");
        if (pos < 0) {
            s = s + ";" + sFile;
        } else {
            var s1 = s.substring(pos + 1, s.length);
            if (sFile != s1) {
                s = s1 + ";" + sFile;
            }
        }
    } else {
        s = sFile;
    }
    fcpubdata.recentFile = s;
}

function ef_RefreshRecentFile() {
    var s = fcpubdata.recentFile;
    if (typeof s == "undefined") return;
    if (s.length == 0) return;
    var oWin = parent.selhtml;
    var arr = s.split(";");
    var arr1 = arr[0].split(",");
    _genHref(arr1, oWin.recentFile1);
    if (arr.length > 1) {
        arr1 = arr[1].split(",");
        _genHref(arr1, oWin.recentFile2);
    }
    function _genHref(arr1, oHref) {
        if (arr1[0] == "-1") {
            oHref.href = "javascript:parent.topic.execScript('DesignDjOpenSub(readdesignhtml(\"<no>" + arr1[1] + "</no><no></no><No>" + fcpubdata.path + "</No>\"),0);pdjFilePath=\"" + arr1[1] + "\"')";
            oHref.innerText = arr1[1];
        } else {
            oHref.href = "javascript:parent.topic.execScript('DesignDjOpen(\"" + arr1[0] + "\")')";
            oHref.innerText = arr1[1] + "(" + arr1[2] + ")";
        }
    }
}

function ef_BuildPatientFieldSet(name,sid) {
	
	var sHtml = "<fieldset contentEditable=true controltype='" + name + "' id='" + sid + "' contentEditable=false value=-1  style='position:" + fcpubdata.position + ";left:0;top:0;height:96;width:300; ' onmovestart=moveStart() onmoveend=moveEnd() onresizestart=resizeStart() onresizeend=resizeEnd() field='100' china='" + sid + "'>";
	sHtml += "<legend>基本信息</legend>";
	
	sHtml += "<LABEL style='POSITION: absolute; TOP: 20px; LEFT: 5px; WIDTH: 65px; HEIGHT: 15px; ' onresizeend=resizeEnd() oncontrolselect=controlselect() onresize=resize() onmove=move() onmovestart=moveStart() onmoveend=moveEnd() onresizestart=resizeStart() >姓名</LABEL>";
	sHtml += "<INPUT style='POSITION: absolute; TOP: 20px; LEFT: 80px; WIDTH: 110px; HEIGHT: 20px; BORDER-TOP: #7f9db9 1px solid; BORDER-BOTTOM: #7f9db9 1px solid; BORDER-LEFT: #7f9db9 1px solid; BORDER-RIGHT: #7f9db9 1px solid;'";
	sHtml += "id=objPatient.name onresizeend=resizeEnd() oncontrolselect=controlselect() onresize=resize() onmove=move() onmovestart=moveStart() onmoveend=moveEnd() onresizestart=resizeStart() >";
	
	sHtml += "</fieldset>";
	return sHtml;
                	
}