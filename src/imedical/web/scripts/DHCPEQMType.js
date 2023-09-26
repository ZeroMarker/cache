/// DHCPEQMType.js

var CurrentSel=0

function BodyLoadHandler() {
   
	var obj;
	obj=document.getElementById("BSave");
	if (obj){ obj.onclick=BSave_click;}
	
	//清屏
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }
}


function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
function BSave_click() { 
    var encmeth="",ID="",Code="",Desc="",Remark="",ExpStr="",ActiveFlag="N";
	var obj=document.getElementById("SaveClass");
	if (obj) encmeth=obj.value;
	var obj=document.getElementById("Code");
	if (obj) Code=obj.value;
	var obj=document.getElementById("Desc");
	if (obj) Desc=obj.value;
	var obj=document.getElementById("Remark");
	if (obj) Remark=obj.value;
	var obj=document.getElementById("ExpStr");
	if (obj) ExpStr=obj.value;
	var obj=document.getElementById("ActiveFlag");
	if (obj&&obj.checked) ActiveFlag="Y";
	var obj=document.getElementById("ID");
	if (obj) ID=obj.value;
   
    if (""==Code) {
		obj=document.getElementById("Code")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("代码不能为空");
		return false;
	 }
	 
      if (""==Desc) {
		obj=document.getElementById("Desc")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("描述不能为空");
		return false;
	 }

	if (""==ExpStr) {
		obj=document.getElementById("ExpStr")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("扩展信息不能为空");
		return false;
	 }

	var SaveInfo=Code+"^"+Desc+"^"+Remark+"^"+ExpStr+"^"+ActiveFlag
	var Ret=cspRunServerMethod(encmeth,ID,SaveInfo);
	var Arr=Ret.split("^");
	if (Arr[0]>0){
		location.reload();
	}else{
		alert(Arr[1]);
	} 

}

function ShowCurRecord(selectrow) {

	var SelRowObj;
	var obj;
	
	SelRowObj=document.getElementById('TCode'+'z'+selectrow);
	obj=document.getElementById("Code");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.innerText); }

	SelRowObj=document.getElementById('TDesc'+'z'+selectrow);
	obj=document.getElementById("Desc");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.innerText); }

	SelRowObj=document.getElementById('TID'+'z'+selectrow);
	obj=document.getElementById("ID");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }

	SelRowObj=document.getElementById('TRemark'+'z'+selectrow);
	obj=document.getElementById("Remark");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.innerText); }
	
	SelRowObj=document.getElementById('TExpStr'+'z'+selectrow);
	obj=document.getElementById("ExpStr");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.innerText); }
	// ----------------------------------------------------------------
	SelRowObj=document.getElementById('TActiveFlag'+'z'+selectrow);
	if (SelRowObj && obj) { 
		obj=document.getElementById("ActiveFlag");
		obj.checked=SelRowObj.checked;	
	}
	
}
function SelectRowHandler() {
	
	var eSrc=window.event.srcElement;
	
	var rowObj=getRow(eSrc);

	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	if (selectrow==CurrentSel) {
		Clear_click();	    
		CurrentSel=0;
		return;
	}
	CurrentSel=selectrow;
	ShowCurRecord(CurrentSel);
}
function Clear_click() {
	
	var obj;
	
	obj=document.getElementById("ID");
	if (obj) { obj.value=""; }

	obj=document.getElementById("Code");
	if (obj) { obj.value=""; }
	
	obj=document.getElementById("Desc");
	if (obj) { 
		obj.value=""; 
	}

	obj=document.getElementById("Remark");
	if (obj) {
		obj.value=""; 
	}

	obj=document.getElementById("ActiveFlag");
	if (obj) { obj.checked=false; }
	
	//扩展信息
	obj=document.getElementById("ExpStr");
	if(obj){obj.value="";}

	
}
document.body.onload = BodyLoadHandler;