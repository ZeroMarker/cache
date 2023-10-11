/*
Creater���δ���
CreateDate��2020-07-22
Description��ҽ��¼��ͨ�ô���������������
*/

/* ��ȡurl�в���ֵ */
function GetUrlParam(winlocation,name){
	var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
    var r = winlocation.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]); return "";
}

/* �������� */
function HideWindowMask(){
	$(".window-mask.alldom").hide();
}

function DeepCopyObject(source) { 
	var result={};
	for (var key in source) {
      result[key] = typeof source[key]==='object'?deepCoyp(source[key]): source[key];
   } 
   return result; 
}
/* ����dialog */
function destroyDialog(id){
   //�Ƴ����ڵ�Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}
/* ����dialog */
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class=''></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    var collapsed=true;
   	if (GlobalObj.DefaultExpendTemplateOnPopTemplate==1){
	   collapsed=false;
   	}
    $("#"+id).dialog({
	    zIndex:99999,
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        collapsible: true,
        minimizable:false,
        maximizable: false,
        collapsed:collapsed,
        modal: false,
        closed: false,
        closable: false,
        content:_content,
        buttons:_btntext,
        inline:true,
        resizable:false,
        isTopZindex:true,
        left:$(window).width()-300,
        onClose:function(){
	        //destroyDialog(id);
	    },
	    onBeforeOpen:function(){
		    if (_event!="") eval(_event);
		    return true;
		}
    });
}
/* �޸İ�ť����״̬ */
function DisableBtn(id,disabled){
	if (disabled){
		$HUI.linkbutton("#"+id).disable();
	}else{
		$HUI.linkbutton("#"+id).enable();
	}
}
/* ת���ַ��� */
function escapeJquery(srcString) {
	 // ת��֮��Ľ��
	 var escapseResult = srcString;
	 // javascript������ʽ�е������ַ�
	 var jsSpecialChars = ["\\", "^", "$", "*", "?", ".", "+", "(", ")", "[",
	   "]", "|", "{", "}"];

	 // jquery�е������ַ�,����������ʽ�е������ַ�
	 var jquerySpecialChars = ["~", "`", "@", "#", "%", "&", "=", "'", "\"",
	   ":", ";", "<", ">", ",", "/"];
	 for (var i = 0; i < jsSpecialChars.length; i++) {
	  escapseResult = escapseResult.replace(new RegExp("\\"
	        + jsSpecialChars[i], "g"), "\\"
	      + jsSpecialChars[i]);
	 }
	 for (var i = 0; i < jquerySpecialChars.length; i++) {
	  escapseResult = escapseResult.replace(new RegExp(jquerySpecialChars[i],
	      "g"), "\\" + jquerySpecialChars[i]);
	 }
	 return escapseResult;
}
/* ��¼������������ʹ�ô��� */
function DHCDocUseCount(ValueId, TableName) {
    var rtn = tkMakeServerCall("DHCDoc.Log.DHCDocCTUseCount", "Save", TableName, ValueId, session["LOGON.USERID"], "U", session["LOGON.USERID"])
}
/* ��ʽ��С�� */
function FormateNumber(Number) {
    Number=Number.toString().replace(/\s*/g,"");
    if(Number == "") return Number;
    if(Number.indexOf('-')==-1){
        return parseFloat(Number);
    }
    var NumberArr=Number.split('-');
    //-ֻ��������λ ��Ϊ���� ������
    if((NumberArr.length==2)&&(Number.indexOf('-')==0)){
        return parseFloat(Number);
    }
    var NewNumber="";
    for(var i=0;i<NumberArr.length;i++){
        if(NewNumber=="") NewNumber=parseFloat(NumberArr[i]);
        else NewNumber+="-"+parseFloat(NumberArr[i]);
    }
    return NewNumber;
}
/* ��ҽ��¼�������е���ת��װ��ͳһ���� */
/* rowid ��ID,JumpAry ��Ҫ��ת����������,IsAddRow �Ƿ���Ҫ������ */
function CellFocusJump(rowid, JumpAry, IsAddRow) {
    if (!$.isArray(JumpAry)) return;
    var JumpCellName="";
    var IsJumpSess = false;
    for (var i = 0; i < JumpAry.length; i++) {
        var OneJumpCellName = JumpAry[i];
        var CellObj = document.getElementById(rowid + "_" + OneJumpCellName);
        if (CellObj && (CellObj.disabled == false)) {
            SetFocusCell(rowid, OneJumpCellName);
            IsJumpSess = true;
            JumpCellName=OneJumpCellName;
            break;
        }
    }
    if (!IsJumpSess && IsAddRow) {
        //window.setTimeout("Add_Order_row()", 200);
        Add_Order_row();
        JumpCellName="OrderName";
    }

    return JumpCellName;
}
/* д�ļ�����,��Ȩ��д�ļ� */
function WriteLogFile(FileTxt, Address) {
    var fs, f1, itmString, CountString, TempList;
    fs = new ActiveXObject("Scripting.FileSystemObject");
    if (fs.FileExists(Address)) { fs.DeleteFile(Address, false); }
    f1 = fs.CreateTextFile(Address, true);
    f1.WriteLine(FileTxt);
    f1.Close();
    return true;
}
/* ����־д�뵽�ı�,FunctionName ���ô˷��������ں����� */
function SetTimeLogToServer(FunctionName) {
    if (GlobalObj.isSetTimeLog!='Y') return;

    var myDate = new Date();
    var DateTime = myDate.toLocaleString() + '.' + myDate.getMilliseconds();

    var UserId = session['LOGON.USERID'];
    var PageTimeLogData = $('#PageTimeLogData').data(UserId);
    PageTimeLogData = PageTimeLogData + String.fromCharCode(10) + String.fromCharCode(13) + '��' + FunctionName + '��д�����,ʱ��:' + DateTime + String.fromCharCode(10) + String.fromCharCode(13);

    var ret = tkMakeServerCall("web.DHCDocOrderEntry", "SaveOrderTimeLog", UserId, PageTimeLogData);
    return;
}
/* ��¼ʱ����־,�����ڲ���ҳ�湦�ܵ�ʱ����Ҫ��¼ʱ�� */
/* FunctionName ���ô˷��������ں�������Position �ں����е�λ�� */
function SetTimeLog(FunctionName, Position) {
    if (GlobalObj.isSetTimeLog!='Y') return;

    var myDate = new Date();
    var DateTime = myDate.toLocaleString() + '.' + myDate.getMilliseconds();
    var TimeLogStr = 'FunctionName:' + FunctionName + ',Position:' + Position + ',DateTime:' + DateTime;

    var UserId = session['LOGON.USERID'];
    var PageTimeLogData = $('#PageTimeLogData').data(UserId);
    if (!PageTimeLogData) {
        PageTimeLogData = TimeLogStr;
    } else {
        PageTimeLogData = PageTimeLogData + String.fromCharCode(10) + String.fromCharCode(13) + TimeLogStr;
    }
    //����һ�������Զ����¼�¼
    if (PageTimeLogData.length > 32749) {
        $('#PageTimeLogData').data(UserId, TimeLogStr)
    } else {
        $('#PageTimeLogData').data(UserId, PageTimeLogData)
    }

    return;
}
/* ��ȡһ�е�״̬�Ƿ�ѡ�м������δ���/��ҽ��ѡ��(1.1) */
function GetRowCheckFlag(rowid) {
    var CheckFlag = "-1"
    var ArryObj = document.getElementsByTagName("INPUT");
    for (var SubInput = 0; SubInput < ArryObj.length; SubInput++) {
        if (ArryObj[SubInput].id == ("jqg_Order_DataGrid_" + rowid)) {
            if (ArryObj[SubInput].checked) { CheckFlag = "Y" } else { CheckFlag = "N" }
        }
    }
    return CheckFlag
}
/* ����һ�е�ѡ������ Statu:true,false */
function SetRowCheckFlag(rowid, Statu) {
    var ArryObj = document.getElementsByTagName("INPUT");
    for (var SubInput = 0; SubInput < ArryObj.length; SubInput++) {

        if (ArryObj[SubInput].id == ("jqg_Order_DataGrid_" + rowid)) {
            ArryObj[SubInput].checked = Statu
        }
    }
}
function formateTime(time){
	if (time=="") return time;
	if(time.split(":").length==2){
		time=time+":00";
	}
	var NewTime="";
	for (var timei=0;timei<time.split(":").length;timei++){
		var OneTime=time.split(":")[timei];
		if ((+OneTime<=9)&&(OneTime.length==1)) OneTime="0"+OneTime;
		if (NewTime=="") NewTime=OneTime;
		else NewTime=NewTime+":"+OneTime;
	}
	return NewTime.replace(/:/g,"");
}
/* �õ��˵����� */
function GetMenuPara(ParaName) {
    var myrtn = "";
    var frm = dhcsys_getmenuform();
    if (frm) {
	    if (eval("frm." + ParaName)){
        	myrtn = eval("frm." + ParaName + ".value");
        }
    }
    return myrtn;
}
/* ����������֤ */
function keypressisnumhandler(e) {
    try { keycode = websys_getKey(e); } catch (e) { keycode = websys_getKey(); }
    if (e.target.name=="OrderSpeedFlowRate"){
        if (((keycode >= 46) && (keycode < 58)) ||(keycode==189) ||(keycode==45)) {
	    }else if((keycode == 13) || (keycode == 9)){
		    window.event.keyCode = 0;
		    window.setTimeout("Add_Order_row()", 200);
		    return websys_cancel();
		} else {
           window.event.keyCode = 0;
           return websys_cancel();
        }
    }else{
	    if (keycode == 45) { window.event.keyCode = 0; return websys_cancel(); }
        if ((keycode > 47) && (keycode < 58)) {} else {
           window.event.keyCode = 0;
           return websys_cancel();
        }
    }
}
/* �����ͼ���Ԫ����ͬһ����?Ҫ����Ԫ�صĿ�� */
function AdjustWidth(objwidth) {
    if (objwidth != "") {
        var objwidtharr = objwidth.split("px")
        var objwidthnum = objwidtharr[0] - 25;
        objwidth = objwidthnum + "px"
    }
    return objwidth
}

function dateadd(date1, day) {
    var T = new Date();
    if (day < 0) day = 0;
    var t = Date.parse(date1) + day * 1000 * 3600 * 24;
    T.setTime(t);
    return T;
}
function ConervToDate(OrderStartDate) {
    if (PageLogicObj.defaultDataCache==3){
        var OrderStartDateArr = OrderStartDate.split("-");
        var OrderStartDateYear = OrderStartDateArr[0];
        var OrderStartDateMonth = parseInt(OrderStartDateArr[1], 10) - 1;
        var OrderStartDateDay = OrderStartDateArr[2];
    }else{
        var OrderStartDateArr = OrderStartDate.split("/");
		var OrderStartDateYear = OrderStartDateArr[2];
		var OrderStartDateMonth = parseInt(OrderStartDateArr[1], 10) - 1;
		var OrderStartDateDay = OrderStartDateArr[0];
    }
    var objDate = new Date(OrderStartDateYear, OrderStartDateMonth, OrderStartDateDay, 0, 0, 0);
    return objDate;
}
/* �ж��Ƿ�Ϊ������ */
function isInteger(objStr) {
    var reg = /^\+?[0-9]*[0-9][0-9]*$/;
    var ret = objStr.match(reg);
    if (ret == null) { return false } else { return true }
}
/* �ж��Ƿ�Ϊ���� */
function isNumber(objStr) {
    var strRef = "-1234567890.";
    for (i = 0; i < objStr.length; i++) {
        tempChar = objStr.substring(i, i + 1);
        if (strRef.indexOf(tempChar, 0) == -1) { return false; }
    }
    return true;
}
function mPiece(s1, sep, n) {
    //Getting wanted piece, passing (string,separator,piece number)
    //First piece starts from 0
    //Split the array with the passed delimeter
    var delimArray = s1.split(sep);
    //If out of range, return a blank string
    if ((n <= delimArray.length - 1) && (n >= 0)) return delimArray[n];
	return "";
}
/* ���������б�ֵ */
function ClearAllList(obj) {
    for (var i = obj.options.length - 1; i >= 0; i--) obj.options[i] = null;
}
/*******************************************
*ChangeRowStyle(rowid,StyleConfigObj)
*˵����2014-08-15  ����

*����е���ʽ���� �ı䵥Ԫ��༭״̬  
*ֻ�����Ƿ�ɱ༭  ����������
*��������ʽ�Ŀ��ƶ����浽 StyleConfigStr �ֶ�
*value=false:���ɱ༭  
*value=true :���Ա༭
*
********************************************/
function ChangeRowStyle(rowid, StyleConfigObj) {
    if ($.isNumeric(rowid) == true) {

    }
    //New
    for (var key in StyleConfigObj) {
        var name = key;
        var value = StyleConfigObj[key];
        if (value == undefined) { continue; }
        //���õ�Ԫ�񲻿ɱ༭
        if ($.isNumeric(rowid) == true) {
	        if ((name=="OrderName")||(name=="OrderInstr")||(name=="OrderFreq")||(name=="OrderDur")){
		        if (value == false) {
			        $("#" + rowid + "_" + name).lookup('disable');
			    }else{
				    $("#" + rowid + "_" + name).lookup('enable');
				}
            }else if (name=="OrderDoseQty"){
	            if (value == false) {
		            $("#" + rowid + "_" + name).addClass("disable");
	                $("#" + rowid + "_" + name).attr('disabled', true);
	            }else if (value == "readonly") {
		            //ͬƵ�β�ͬ����ҽ��,����Ҫ��������¼�,������disabled
		            $("#" + rowid + "_" + name).addClass("disable Input-display");
	                $("#" + rowid + "_" + name).attr('readonly', true);
		        }else{
			        $("#" + rowid + "_" + name).removeClass("disable Input-display");
	                //$("#" + rowid + "_" + name).attr('readonly', false); 
	                $("#" + rowid + "_" + name).removeAttr("readonly").attr('disabled', false);
			    }
	        }else{
	            if (value == false) {
	                //false:���ɱ༭ 
	                //���class:disable
	                $("#" + rowid + "_" + name).addClass("disable");
	                $("#" + rowid + "_" + name).attr('disabled', true);
	            } else if (value == true) {
	                //�ı�Ϊ�ɱ༭
	                $("#" + rowid + "_" + name).removeClass("disable");
	                $("#" + rowid + "_" + name).attr('disabled', false);
	            }
	        }
        } else {
	        if ((name=="OrderName")||(name=="OrderInstr")||(name=="OrderFreq")||(name=="OrderDur")){
		        if (value == false) {
			        $("#" + name).lookup('disable');
			    }else{
				    $("#" + name).lookup('enable');
				}
            }else{
	            if (value == false) {
	                $("#" + name).attr('disabled', true);
	            } else if (value == true) {
	                $("#" + name).attr('disabled', false);
	            }
            }
        }
    }
    
    //�������ö����ַ�����
    var oldStyleConfigStr = GetCellData(rowid, "StyleConfigStr");
    if (oldStyleConfigStr != "") {
        var oldStyleConfigobj = eval("(" + oldStyleConfigStr + ")");
        //�̳�
        $.extend(oldStyleConfigobj, StyleConfigObj);
        var StyleConfigStr = JSON.stringify(oldStyleConfigobj);
        SetCellData(rowid, "StyleConfigStr", StyleConfigStr);
    } else {
        var StyleConfigStr = JSON.stringify(StyleConfigObj);
        SetCellData(rowid, "StyleConfigStr", StyleConfigStr);
    }
}
/**********************************************
 *ChangeCellDisable(rowid,StyleConfigObj)
 *˵����2014-08-15
 *���õ�Ԫ���Ƿ�ɲ��� ���������в��� 
 *StyleConfigObj={OrderFreq:true}
 *RowDisableStr ���ֶ�ֻ���ڴ洢���������е���ʽ
 *���¼����ı���ֶ� ʹ��ChangeRowStyle(rowid,StyleConfigObj)
 ***********************************************/
function ChangeCellDisable(rowid, StyleConfigObj) {
    if ($.isNumeric(rowid) == true) {}
    for (var key in StyleConfigObj) {
        var name = key;
        var value = StyleConfigObj[key];
        if (value == undefined) { continue; }
        //���õ�Ԫ�񲻿ɱ༭
        if ($.isNumeric(rowid) == true) {
            if($("#" + rowid + "_" + name).hasClass('combobox-f')){
                $("#" + rowid + "_" + name).combobox(value==false?'disable':'enable');
            }else if ($("#" + rowid + "_" + name).hasClass('lookup')){
                $("#" + rowid + "_" + name).lookup(value==false?'disable':'enable');
            }else{
	            //false:�����Ա༭
	            if (value == false) {
	                //�ĳ����� disabled  2014-05-21
	                $("#" + rowid + "_" + name).attr('disabled', true);
	                $("#" + rowid + "_" + name).addClass("disable");
	            } else if (value == true) {
	                //�ɱ༭
	                $("#" + rowid + "_" + name).attr('disabled', false)
	                .removeClass("disable Input-display")
	                .removeAttr("readonly");
	            }
            }
        } else {
	        if($("#" + rowid + "_" + name).hasClass('combobox-f')){
                $("#" + rowid + "_" + name).combobox(value==false?'disable':'enable');
            }else if ($("#" + rowid + "_" + name).hasClass('lookup')){
                $("#" + rowid + "_" + name).lookup(value==false?'disable':'enable');
            }else{
	            if (value == false) {
	                $("#" + name).attr('disabled', true);
	            } else if (value == true) {
	                $("#" + name).attr('disabled', false);
	            }
	        }
        }
    }
    //�������ö����ַ�����
    var oldRowDisableStr = GetCellData(rowid, "RowDisableStr");
    if (oldRowDisableStr != "") {
        var oldStyleConfigobj = eval("(" + oldRowDisableStr + ")");
        //�̳�
        $.extend(oldStyleConfigobj, StyleConfigObj);
        var StyleConfigStr = JSON.stringify(oldStyleConfigobj);
        SetCellData(rowid, "RowDisableStr", StyleConfigStr);
    } else {
        var StyleConfigStr = JSON.stringify(StyleConfigObj);
        SetCellData(rowid, "RowDisableStr", StyleConfigStr);
    }
}
//ȡ��ǰ�༭��ID
function GetFoucsRowId(e) {
    return PageLogicObj.FocusRowIndex;
}
//ȡ��һ��ID ��������ȡ��ǰ���һ��
function GetPreRowId(rowid) {
    var prerowid = "";
    var rowids = $('#Order_DataGrid').getDataIDs();
    if ($.isNumeric(rowid) == true) {
        for (var i = rowids.length; i >= 0; i--) {
            if (rowids[i] == rowid) {
                if (i == 0) {
                    prerowid = rowids[i];
                } else {
                    prerowid = rowids[i - 1];
                }
                break;
            }
        }
    }
    if (prerowid == "") {
        if (rowids.length == 0) {
            prerowid = ""
        } else {
            prerowid = rowids[rowids.length - 1];
        }
    }
    return prerowid;
}
function GetNextRowId(rowid) {
    var nextrowid = "";
    var rowids = $('#Order_DataGrid').getDataIDs();
    if ($.isNumeric(rowid) == true) {
        for (var i = rowids.length; i >= 0; i--) {
            if (rowids[i] == rowid) {
                if (i == rowids.length - 1) {
                    nextrowid = rowids[i];
                } else {
                    nextrowid = rowids[i + 1];
                }
                break;
            }
        }
    }
    return nextrowid;
}
function GetRowIdByOrdSeqNo(OrdSeqNo){
	var RowIndex="";
	var rowids = GetAllRowId();
	for (var index = 0; index < rowids.length; index++) {
		var id=GetCellData(rowids[index], "id");
		if (id==OrdSeqNo) {
			RowIndex=rowids[index];
			break;
		}
	}
	return RowIndex;
}
function ChangTest(e) {
    var obj = websys_getSrcElement(e);
    var type = websys_getType(e);
    var key = websys_getKey(e);
    if (key != 13 && type != 'click') {
        return;
    }
    //$.messager.alert("����",this.id);
    var rowid = obj.id.split("_")[0];
}
function IsLongPrior(OrderPriorRowId) {
    var ret = 0;
    if ((OrderPriorRowId == GlobalObj.LongOrderPriorRowid) || (OrderPriorRowId == GlobalObj.OMSOrderPriorRowid) || (OrderPriorRowId == GlobalObj.OMCQZTOrderPriorRowid)) {
        ret = 1
    }
    return ret;
}
//���ý���λ��
function SetFocusCell(rowid, colname) {
    if ($.isNumeric(rowid) == true) {
        var obj = document.getElementById(rowid + "_" + colname);
        if (obj) {
            //websys_setfocus(rowid+"_"+colname);
            //$("#"+rowid+"_"+colname)[0].focus();
            //ҽ��ʵʱ������easyui��Ϊext
            /*if ((colname == "OrderName") && (GlobalObj.OEORIRealTimeQuery == 1)) {
                try {
                    setTimeout($('#' + rowid + '_OrderName').next('span').find('input').focus(), 50)
                } catch (e) { $.messager.alert("����", e.message); }
            } else {
                websys_setfocus(rowid + "_" + colname);
            }*/
            if ($(obj).hasClass("combobox-f")){
                try{
                    setTimeout(function(){
                        //var focusObj= $(obj).next().find(".combo-text:not(:disabled)")[0]
                        var focusObj=$(obj).combobox("textbox")[0];
                        if (focusObj){
                            focusObj.focus();focusObj.select();
                        }},50)
                }catch(e){}
            }else{
                websys_setfocus(rowid + "_" + colname);
            }
            
        }
        PageLogicObj.FocusRowIndex=rowid;
    } else {
        var obj = document.getElementById(colname);
        if (obj) {
            websys_setfocus(colname);
            //$("#"+colname)[0].focus();
        }
    }
}
//��ѡ��ѡ 
function SetCellChecked(rowid, colname, type) {
    if ($.isNumeric(rowid) == true) {
        var obj = document.getElementById(rowid + "_" + colname);
        if (obj) {
            $("#" + rowid + "_" + colname).prop("checked", type);
        }
    } else {
        var obj = document.getElementById(colname);
        if (obj) {
            $("#" + colname).prop("checked", type);
        }
    }
}
//��Ԫ��ֵ  2014-03-24
function SetCellData(rowid, colname, data) {
    if ($.isNumeric(rowid) == true) {
        var obj = document.getElementById(rowid + "_" + colname);
        if (obj) {
            if (obj.type == "checkbox") {
                // data: true or  false
                var olddata = $("#" + rowid + "_" + colname).prop("checked");
                $("#" + rowid + "_" + colname).prop("checked", data);
            }else if ($(obj).hasClass("combobox-f")){
                $("#" + rowid + "_" + colname).combobox("setValue",data);
            } else {
                var olddata = $("#" + rowid + "_" + colname).val();
                $("#" + rowid + "_" + colname).val(data);
                //hisui lookup(comboq)bug�˴�����,��ֵpreviousValue
                var comboqObj=$.data($("#" + rowid + "_" + colname)[0],"comboq");
			    if(typeof(comboqObj)=='object') comboqObj.previousValue=data;
            }
            //�����������Ե������޸�,ģ��onpropertychange�¼���ʵ��,��change�¼���Ҫͬ������
            CellDataPropertyChange(rowid, colname, olddata, data);
            if ($("#"+rowid + "_"+colname).hasClass("flatpickr-input")) {
	            //var index=$.hisui.indexOfArray(PageLogicObj.fpArr,"rowid",rowid);
	            //PageLogicObj.fpArr[index][colname].setDate(data,true);
	        }
        } else {
            //rowid,colname,nData,cssp,attrp, forceupd
            //forceupd:true �������ֵ
            $("#Order_DataGrid").setCell(rowid, colname, data, "", "", true);
        }
    } else {
        var obj = document.getElementById(colname);
        if (obj) {
            $("#" + colname).val(data);
        }
    }
}
//��Ԫ��ȡֵ  2014-03-24
function GetCellData(rowid, colname,descFlag) {
    var CellData = "";
    if ($.isNumeric(rowid) == true) {
        var obj = document.getElementById(rowid + "_" + colname);
        //���Ϊselect ȡ text
        if (obj) {
            if (obj.type == "select-one") {
                CellData = $("#" + rowid + "_" + colname + " option:selected").text();
            } else if (obj.type == "checkbox") {
                if ($("#" + rowid + "_" + colname).prop("checked")) {
                    CellData = "Y";
                } else {
                    CellData = "N";
                }
            }else if ($(obj).hasClass("combobox-f")){
                CellData = descFlag?$("#" + rowid + "_" + colname).combobox("getText"):$("#" + rowid + "_" + colname).combobox("getValue");
            } else {
                CellData = $("#" + rowid + "_" + colname).val();
            }
        } else {
            CellData = $("#Order_DataGrid").getCell(rowid, colname);
        }
    } else {
        var obj = document.getElementById(colname);
        if (obj) {
            CellData = $("#" + colname).val();
        }
    }
    return CellData;
}

/// cell->edittype:'custom'ʱ����Ҫʵ�����Զ������Ĵ���������ֻ����һ��input����������ʵ����InitRowLookUpȥʵ��
function CustomElement (value, options) {
    var el = document.createElement("input");
    el.type="text";
    el.value = value;
    el.style="width:inherit"
    return el;
}
/// cell->edittype:'custom'ʱ����Ҫʵ�����Զ���Ķ���ֵ��������
function CustomValue(elem, operation, value) {
    if ($(elem).hasClass("combobox-f")){
        if(operation === 'get') {
            return $(elem).combobox('getText');
        } else if(operation === 'set') {
            $(elem).combobox('setText',value)
        }
    }else{
        if(operation === 'get') {
            return $(elem).val();
        } else if(operation === 'set') {
            $('input',elem).val(value);
        }
    }
}
//��ȡ������ID
function GetNewrowid() {
    var rowid = "";
    var rowids = $('#Order_DataGrid').getDataIDs();
    if (rowids.length > 0) {
        var prerowid = rowids[rowids.length - 1];
        if (prerowid.indexOf(".") != -1) {
            rowid = parseInt(prerowid.split(".")[0]) + 1;
        } else {
            rowid = parseInt(prerowid) + 1;
        }
    } else {
        rowid = 1;
    }
    /*
    $.ajax({
        url: "oeorder.oplistcustom.new.request.csp?action=GetRowId",
        data: {USERID:session['LOGON.USERID'],ADMID:GlobalObj.EpisodeID},
        async:false,//ͬ��
        success: function(response){        
            rowid=parseInt(response);           
        }
    });
    */
    return rowid;
}
// numΪ�����ֵ��nΪ������С��λ
function fomatFloat(num,n){   
    var f = parseFloat(num);
    if(isNaN(f)){
        return false;
    }   
    f = Math.round(num*Math.pow(10, n))/Math.pow(10, n); // n ��   
    var s = f.toString();
    var rs = s.indexOf('.');
    //�ж����������������С�����ٲ�0
    if(rs < 0){
        rs = s.length;
        s += '.'; 
    }
    while(s.length <= rs + n){
        s += '0';
    }
    return s;
}  
//�ж��Ƿ������ҽ�� (����OrderItemRowid)
function CheckIsItem(rowid) {
    var id = parseInt(rowid);
    if ($.isNumeric(id) == true) {
        var OrderItemRowid = GetCellData(id, "OrderItemRowid");
        if (OrderItemRowid != "") {
            return true;
        } else {
            return false;
        }
    } else {
        return false;
    }
}
//��ť��Ӧ����
function fn(e) {
    var obj = websys_getSrcElement(e);
    dhcsys_alert(obj.value);
}
//��ȡһ������ ��Ҫ��ǰ��Ϊ����״̬
function GetRowData(rowid) {
    var curRowData = "";
    if (GetEditStatus(rowid) == false) {
        curRowData = $("#Order_DataGrid").getRowData(rowid);
    } else {
        $.messager.alert("����", "��ǰ��δ����");
    }
    return curRowData;
}
//��ȡ�¼����к�
function GetEventRow(e) {
    var rowid = "";
    var obj = websys_getSrcElement(e);
    if (obj && obj.id.indexOf("_") > 0) {
        rowid = obj.id.split("_")[0];
    }
    return rowid
}
//��ȡ������ID ��������
function GetAllRowId() {
    var rowids = $('#Order_DataGrid').getDataIDs();
    return rowids;
}
//���㵽���һ��
function SetLastRowFocus() {
    var rowids = GetAllRowId();
    var lastrowid = rowids[rowids.length - 1];
    if (GetEditStatus(lastrowid) == true) {
        SetFocusCell(rowid, "OrderName")
    }
}
//��ȡѡ����ID ��������
function GetSelRowId() {
    var rowids = $('#Order_DataGrid').getGridParam("selarrrow");
    return rowids;
}
//��ȡѡ����ID ��������
function GetSelRowData() {
    var DataArry = new Array();
    var rowids = $('#Order_DataGrid').getGridParam("selarrrow");
    for (var i = 0; i < rowids.length; i++) {
        //��ȡ�Ѿ����ҽ��
        //if(CheckIsItem(rowids[i])==true){continue;}
        //������  88888
        EndEditRow(rowids[i]);
        var curRowData = $("#Order_DataGrid").GetRowData(rowids[i]);
        DataArry[DataArry.length] = curRowData;
    }
    return DataArry;
}
//������Ƿ�հ���
function CheckIsClear(rowid) {
    //OrderARCIMRowidΪ����Ϊ�հ���
    var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
    var OrderARCOSRowid = GetCellData(rowid, "OrderARCOSRowid");
    if ((OrderARCIMRowid != "")||(OrderARCOSRowid!="")) {
        return false;
    } else {
        return true;
    }
}
//һ��༭��
function EditRowCommon(rowid, EnableOrd) {
    if ($.isNumeric(rowid) == true) {
        $('#Order_DataGrid').editRow(rowid, false); //false ȥ���س�����
        if ((typeof EnableOrd != "undefined") && (EnableOrd == false)) {
            return
        }
    }
}

//������Ƿ�ɱ༭
function CheckCanEdit(rowid) {
    //����˻��ѱ���ҽ�����ܱ༭
    /*
    var OrderItemRowid=GetCellData(rowid,"OrderItemRowid");
    if(OrderItemRowid != "" && OrderItemRowid != null && OrderItemRowid != undefined){
        return false;
    }else{
        return true;
    }
    */
    /////tanjishan 2015-09
    ////����ҩ�ɱ༭
    var OrderType = GetCellData(rowid, "OrderType");
    var OrderItemRowid = GetCellData(rowid, "OrderItemRowid");
    if ((OrderType == "R" && OrderItemRowid != null && OrderItemRowid != undefined) || (OrderItemRowid == "")) {
        return true;
    } else {
        return false;
    }
}
//�ж����Ƿ��ڱ༭״̬
function GetEditStatus(rowid) {
    var obj = document.getElementById(rowid + "_OrderName");
    if (obj) {
        return true;
    } else {
        return false;
    }
}
//������
function EndEditRow(rowid) {
    var obj = document.getElementById(rowid + "_OrderName");
    if (obj) {
        $("#Order_DataGrid").saveRow(rowid);
        //ȥ��jqgrid�Դ�������ʾ
        $("#Order_DataGrid").find('tr#'+rowid).find('td[role=gridcell]').removeAttr('title');
    }
}
function GetCurr_time() {
    //ȡ��ǰ���ں�ʱ��(������)
    var CurrDateTime = cspRunServerMethod(GlobalObj.GetCurrentDateTimeMethod, PageLogicObj.defaultDataCache, "1");
    var CurrDateTimeArr = CurrDateTime.split("^");
    var CurrDate = CurrDateTimeArr[0];
    var CurrTime = CurrDateTimeArr[1];
    var CurrDateTime = CurrDate + " " + CurrTime;
    return CurrDateTime;
}
function GetItemStr(lstcnt,tabidx){
	var ItemStr="";
	var selector = '#ngroup' + lstcnt + 'Z' + tabidx;
	var select=$(selector).children("div").children("label");
	for (var i=0;i<select.length;i++){
		var value=select[i].id;
		var itemid = value.split(String.fromCharCode(4))[2];
		if (ItemStr=="") ItemStr=itemid;
		else ItemStr=ItemStr+"^"+itemid
	}
	return ItemStr;
}
//��ʼ���۽�����QP
function setInputSelection(input, startPos, endPos) {
    input.focus();
    if (typeof input.selectionStart != "undefined") {
        input.selectionStart = startPos;
        input.selectionEnd = endPos;
    } else if (document.selection && document.selection.createRange) {
        // IE branch
        input.select();
        var range = document.selection.createRange();
        range.collapse(true);
        range.moveEnd("character", endPos);
        range.moveStart("character", startPos);
        range.select();
    }
}
function headerDblClick() {
    if (GlobalObj.lookupListComponetId != "") {
        var flag = tkMakeServerCall("web.SSGroup", "GetAllowWebColumnManager", session['LOGON.GROUPID']);
        if (flag == 1) websys_lu('../csp/websys.component.customiselayout.csp?ID=' + GlobalObj.lookupListComponetId + '&CONTEXT=K' + GlobalObj.ListColSetCls + '.' + GlobalObj.ListColSetMth + '.' + GlobalObj.XCONTEXT + "&GETCONFIG=1", false);
    }
}

//���ڱ༭�� 
function InitDatePicker(cl) {
	return false;
}
//����������QP
function SetWdateFoucus() {
	var WdateIframe = $dp.dd.getElementsByTagName("iframe");
	if (WdateIframe.length > 0) {
		WdateIframe = WdateIframe[0];
	} else {
		return;
	}
	var doc = WdateIframe.contentWindow.document;
	//�����������غ��ִ���¼�����
	var _tables = doc.getElementsByTagName("table");
	if (_tables.length == 0) {
		setTimeout(SetWdateFoucus, 100);
		return;
	}
	
	var $domOBJ = $(doc).find('.tB,.tE');
	$domOBJ.eq(0).focus();
}

//����������QP
function setWdatePickerStyle() {
	var WdateIframe = $dp.dd.getElementsByTagName("iframe");
	if (WdateIframe.length > 0) {
		WdateIframe = WdateIframe[0];
	} else {
		return;
	}
	var doc = WdateIframe.contentWindow.document;
	//�����������غ��ִ���¼�����
	var _tables = doc.getElementsByTagName("table");
	if (_tables.length == 0) {
		setTimeout(setWdatePickerStyle, 100);
		return;
	}
	$(doc).find('#dpTimeUp,#dpTimeDown').each(function (index, element) {
		$(element).hide();
	});
	var $domOBJ = $(doc).find('.tB,.tE');
	var $okOBJ = $(doc).find("#dpOkInput");
	$domOBJ.each(function (index, element) {
		$(element).unbind();
		$(element).bind('keyup',function(e){
			e.stopPropagation()
			var curValue = $(this).val();
			if (curValue.length==2) {
				if (index != 2) {
				$domOBJ.eq(index+1).focus();
				} else {
					$domOBJ.eq(0).focus();
				}
			}
			if (e.keyCode == "39") {
				if (index != 2) {
					$domOBJ.eq(index+1).focus();
				} else {
					$domOBJ.eq(0).focus();
				}
				return false;
			}
			if (e.keyCode == "37") {
				if (index != 0) {
					$domOBJ.eq(index-1).focus();
				} else {
					$domOBJ.eq(2).focus();
				}
				return false;
			}
			if (e.keyCode == "13") {
				$okOBJ.trigger("click");
				$dp.hide();
			}

		})
	});
}
/* �������õ��� */
function UIConfigHandler() {
    var UIConfigImgURL = "oeorder.oplistcustom.config.csp";
    if(typeof websys_writeMWToken=='function') UIConfigImgURL=websys_writeMWToken(UIConfigImgURL);
    window.open(UIConfigImgURL, "", "status=1,scrollbars=1,top=100,left=100,width=760,height=420");
}
//��ȡ����δ��˵�ҽ����ID
function GetNewOrderIDS() {
    var rowids = GetAllRowId();
    var RowIdArry = new Array();
    for (var i = 0; i < rowids.length; i++) {
        var OrderItemRowid = GetCellData(rowids[i], "OrderItemRowid");
        var OrderARCIMRowid = GetCellData(rowids[i], "OrderARCIMRowid");
        if (OrderItemRowid != "" || OrderARCIMRowid == "") { continue; }
        RowIdArry[RowIdArry.length] = rowids[i]
    }
    return RowIdArry;
}
//����������  2014-04-10
//setRowData(rowid,data, cssprop)
function SetRowData(rowid, dataObj, cssprop) {
    if ($.isNumeric(rowid) == false) { return; }
    //data ����
    /*
    var obj={};
    if(data != ""){
        obj=eval("("+data+")");
    }
    */
    if (GetEditStatus(rowid) == true) {
        //var data={OrderName:"JHSDFASGAET"};       
        EndEditRow(rowid);
        var ret = $("#Order_DataGrid").setRowData(rowid, dataObj, cssprop);
        //$.messager.alert("����",ret);
        //EditRow(rowid);
    } else {
        $("#Order_DataGrid").setRowData(rowid, dataObj, cssprop);
    }
}
function IsWYInstr(InstrRowid) {
    if (InstrRowid == "") return false;
    if (GlobalObj.WYInstr == "") return false;
    var Instr = "^" + InstrRowid + "^"
    if (("^" + GlobalObj.WYInstr + "^").indexOf(Instr) < 0) return false;
    return true;
}
//��ǰ��Ҫ�ı��ҽ�������Ƿ����
function CheckNowOrderPrior(rowid, PriorRowid) {
    var check = false;
    var OrderPriorStr = GetCellData(rowid, "OrderPriorStr");
    var ArrData = OrderPriorStr.split(";");
    for (var i = 0; i < ArrData.length; i++) {
        var ArrData1 = ArrData[i].split(":");
        if (PriorRowid == ArrData1[0]) {
            check = true;
            break;
        }
    }
    return check;
}
function ClearOrderDur(rowid) {
    SetCellData(rowid, "OrderDur", "");
	SetCellData(rowid, "OrderDurRowid", "");
	SetCellData(rowid, "OrderDurFactor", 1);
}
function ClearOrderFreq(rowid) {
    SetCellData(rowid, "OrderFreq", "");
    SetCellData(rowid, "OrderFreqFactor", 1);
    SetCellData(rowid, "OrderFreqInterval", "");
    SetCellData(rowid, "OrderFreqRowid", "");
    SetCellData(rowid, "OrderFreqDispTimeStr", "");
    SetCellData(rowid, "OrderNurseExecLinkDispTimeStr", "");
}
function CheckDosingRecLoc(RecDepRowId) {
    if ((GlobalObj.IPDosingRecLoc != "") && (RecDepRowId != "")) {
        var ArrData = GlobalObj.IPDosingRecLoc.split("^");
        if ($.inArray(RecDepRowId, ArrData) != -1) { return true } else { return false }
    }
    return false
}
//���ô��й��Ʒ����ҽ������ʽ
function SetPoisonOrderStyle(OrderPoisonCode, OrderPoisonRowid, Row) {
	//codeTable:PHC_Poison ,PHC_DrgMast->PHCD_PHCPO_DR
	if (OrderPoisonRowid != "") {
		$("#" + Row).find("td").addClass("SkinTest");
	}
}

//������ID  add by guorongyong
function GetAnaesthesiaID() {
    var AnaesthesiaID = "";
    var frm = dhcsys_getmenuform();
    if (frm) {
        AnaesthesiaID = frm.AnaesthesiaID.value;
    }
    return AnaesthesiaID;
}
function GetLogonLocByFlag() {
    var FindRecLocByLogonLoc;
    //�������¼����ȡ���տ���?�Ͱѵ�¼���Ҵ���ȥ
    /*var obj = document.getElementById("FindByLogDep");
    if (obj) {
        if (obj.checked) { FindRecLocByLogonLoc = 1 } else { FindRecLocByLogonLoc = 0 }
    }*/
    if ($("#FindByLogDep").checkbox("getValue")){
	    FindRecLocByLogonLoc=1;
	}else{
		FindRecLocByLogonLoc = 0;
	}
    var LogonDep = ""
    if (FindRecLocByLogonLoc == "1") { LogonDep = session['LOGON.CTLOCID'] }
    return LogonDep;
}
function IsNotFollowInstr(InstrRowId) {
    if (InstrRowId == "") return false;
    if (GlobalObj.NotFollowInstr == "") return false;
    var Instr = "^" + InstrRowId + "^";
    if (GlobalObj.NotFollowInstr.indexOf(Instr) < 0) return false;
    return true;
}
function GetDefaultLabSpec(LabSpecStr) {
    var DefaultSpecRowid = "";
    var DefaultSpecDesc = "";
    var ArrData = LabSpecStr.split(String.fromCharCode(2));
    for (var i = 0; i < ArrData.length; i++) {
        var ArrData1 = ArrData[i].split(String.fromCharCode(3));
        if (ArrData1[4] == "Y") {
            var DefaultSpecRowid = ArrData1[0];
            var DefaultSpecDesc = ArrData1[1];
        }
    }
    return DefaultSpecRowid
}
function ReBulidOrderPrior(OrderPriorRowid) {
	var OrderPriorRemarks="";
	switch (OrderPriorRowid) {
		case GlobalObj.OneOrderPriorRowid:
			OrderPriorRowid=GlobalObj.ShortOrderPriorRowid;
			OrderPriorRemarks="ONE";
			break;
		case GlobalObj.OMOrderPriorRowid:
			OrderPriorRowid=GlobalObj.ShortOrderPriorRowid;
			OrderPriorRemarks="OM";
			break;
		case GlobalObj.OMSOrderPriorRowid:
			OrderPriorRowid=GlobalObj.LongOrderPriorRowid;
			OrderPriorRemarks="OM";
			break;		
		case GlobalObj.OMCQZTOrderPriorRowid:
			OrderPriorRowid=GlobalObj.LongOrderPriorRowid;
			OrderPriorRemarks="ZT";
			break;
		case GlobalObj.OMLSZTOrderPriorRowid:
			OrderPriorRowid=GlobalObj.ShortOrderPriorRowid;
			OrderPriorRemarks="ZT";
			break;
		case GlobalObj.PRNOrderPriorRowid:
			break;
		case GlobalObj.OutOrderPriorRowid:
			break;
		case GlobalObj.LongOrderPriorRowid:
			break;
		case GlobalObj.ShortOrderPriorRowid:
			break;
		case GlobalObj.STATOrderPriorRowid:
			break;
		default:
	}
	return {
		OrderPriorRowid:OrderPriorRowid,
		OrderPriorRemarks:OrderPriorRemarks
	}
}
function ReSetOrderPriorRowid(OrderPriorRowid, OrderPriorRemarks) {
    switch (OrderPriorRemarks) {
        case "PRN":
            OrderPriorRowid = GlobalObj.PRNOrderPriorRowid;
            break;
        case "ONE":
            OrderPriorRowid = GlobalObj.OneOrderPriorRowid;
            break;
        case "OM":
            if (OrderPriorRowid != GlobalObj.LongOrderPriorRowid) {
                OrderPriorRowid = GlobalObj.OMOrderPriorRowid;
            } else {
                OrderPriorRowid = GlobalObj.OMSOrderPriorRowid;
            }
            break;
        case "ZT":
            if (OrderPriorRowid != GlobalObj.LongOrderPriorRowid) {
                OrderPriorRowid = GlobalObj.OMLSZTOrderPriorRowid;
            } else {
                OrderPriorRowid = GlobalObj.OMCQZTOrderPriorRowid;
            }
            break;
        case "OUT":
            OrderPriorRowid = GlobalObj.OutOrderPriorRowid;
            break;
        default:
    }
    return OrderPriorRowid;
}
///�ж��Ƿ��в�Σҽ��
function HavZFOrderStr(OrderItemStr)
{
    var BVFlag=tkMakeServerCall("web.DHCOEOrdItem","GetCriticalArcItemStr",OrderItemStr);
    return BVFlag
}

///ȡ�����ֵĳ���
function GetCurrentStrWidth(text, font) {
        var currentObj = $('<span>').hide().appendTo(document.body);
        $(currentObj).html(text).css('font', font);
        var width = currentObj.width();
        currentObj.remove();
        return width;
}

function OrdComm_SortNumberAsc(a,b){
	return a-b;	
}
function OrdComm_SortNumberDsc(a,b){
	return b-a;	
}
function ClearUnSaveRow()
{
    var rowids = new Array();
    var AllRowids = $('#Order_DataGrid').getDataIDs();
    for (var i = 0; i < AllRowids.length; i++) {
        if(CheckIsItem(AllRowids[i])) continue;
        rowids.push(AllRowids[i]);
    }
    if(rowids.length){
        DeleteRows(rowids);
    }
}
function strToUnicode(str)
{
    var arr=new Array();
    str=str.toString();
    var len=str.len;
    for(var i=0;i<str.length;i++){
        arr.push(str.charCodeAt(i));
    }
    return arr.join(',');
}
function unicodeToStr(str){
    var ret="";
    var arr=str.split(',');
    for(var i=0;i<arr.length;i++){
        ret+=String.fromCharCode(arr[i]);
    }
    return ret;
}