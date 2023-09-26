function BodyLoadHandler()
{
	var Obj=document.getElementById("Exit");
	if (Obj)Obj.onclick=Exit_click;
	var Obj=document.getElementById("Update");
	if (Obj)Obj.onclick=Update_click;
	var Obj=document.getElementById("Clear");
	if (Obj)Obj.onclick=Clear_click;
	
	var Obj=document.getElementById("OEOrderNotes");
	var NotesObj=document.getElementById("Notes");
	if (NotesObj)NotesObj.value=Obj.value;
}
function BodyUnLoadHandler()
{
	/*
	var FocusRowObj=document.getElementById("FocusRowIndex");
	if (FocusRowObj)var FocusRow=FocusRowObj.value;
	var obj=window.opener.document.getElementById("OrderDoseQtyz"+FocusRow);
	if (obj) {
		try {
			obj.focus();
			obj.select();
		} catch(e) {}
	}
	setTimeout('BodyUnLoadHandler()',50);
	*/
	//Exit_click();
}

function Exit_click()
{
	/*
	var FocusRowObj=document.getElementById("FocusRowIndex");
	if (FocusRowObj)var FocusRow=FocusRowObj.value;
	var obj=window.opener.document.getElementById("OrderDoseQtyz"+FocusRow);
	if (obj) {
		try {
			obj.focus();
			obj.select();
		} catch(e) {}
	}
	//setTimeout('Exit_click()',50);
	*/
	window.close();
}
function Update_click()
{
	var FocusRowObj=document.getElementById("FocusRowIndex");
	if (FocusRowObj)var FocusRow=FocusRowObj.value;
	if (FocusRow=="") {
		alert("已丢失医嘱录入界面选择的行!");
		return false;
	}
	var NotesObj=document.getElementById("Notes");
	if (NotesObj){
		var value=escape(NotesObj.value);
		if (value==""){
			alert("备注内容不能为空");
			return false;
		}
		window.returnValue=value; //escape(NotesObj.value);
		window.close();
	}
}
function Clear_click()
{
	var ClearArr=new Array("Notes");
	for (var i=0;i<ClearArr.length;i++)
	{
		var Obj=document.getElementById(ClearArr[i]);
		if ((Obj.tagName=="TEXTAREA")||(Obj.tagName=="label")||(Obj.tagName=="INPUT")){
			Obj.value="";
		}else if (Obj.tagName=='checkbox'){
				Obj.checked=false;
		}else {}
	}
	
}
document.body.onload=BodyLoadHandler;
document.body.onunload=BodyUnLoadHandler;