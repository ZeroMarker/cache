/// dhcpha.edit.tools
/// 组件编辑公共方法

/// 取组件ID
function GetComponentID(GetComponentField)
{
	var componentId="";
	var obj=document.getElementById("TFORM")
	if (obj) {var tformName=obj.value;}  else {var tformName="";}
	var obj=document.getElementById(GetComponentField)
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	componentId=cspRunServerMethod(encmeth,tformName);
	return componentId;
}

/// Disable 某组件及其附属组件
function DisableFieldByID(GetComponentField,fldName)
{
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld){
		fld.disabled = true;
		//fld.readonly =true;
		//fld.style.display='none'
		fld.className = "disabledField";
		if (lbl) lbl.className = "";
	}
	if (GetComponentField!=""){
		componentId=GetComponentID(GetComponentField);
		if (componentId>0){
			var lup=document.getElementById("ld"+componentId+"i"+fldName);
			if (lup) lup.disabled=true;
		}
	}
}

/// Enable 某组件及其附属组件
function EnableFieldByID(GetComponentField,fldName)
{
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld){
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl.className = "";
	}
	if (GetComponentField!=""){
		componentId=GetComponentID(GetComponentField);
		if (componentId>0) {
			var lup=document.getElementById("ld"+componentId+"i"+fldName);
			if (lup) lup.disabled = false;
		}
	}
}

function GetCalDate(mfld,sdate)
{
	var obj=document.getElementById(mfld);
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var date=cspRunServerMethod(encmeth,'','',sdate) ;
	return date	
}
////Disable the Button;
function DHCWeb_DisBtn(obj){
	obj.disabled=true;
	obj.onclick=function(){return false;}
}
////Disable the Button;
function DHCWeb_DisBtnA(objName){
	var obj=document.getElementById(objName);
	if (obj){
		obj.disabled=true;
		obj.onclick=function(){return false;}
	}
}
function DHCWeb_AddToList(ListName,txtdesc,valdesc,ListIdx)	{
	var ListObj=document.getElementById(ListName);
	if (!ListObj){
		return;
	}
	var aryitmdes=txtdesc		//.split("^");
	var aryitminfo=valdesc		//.split("^");
	if (aryitmdes.length>0)	{
		ListObj.options[ListIdx] = new Option(aryitmdes,aryitminfo);	//,aryval[i]	
	}
}

function DHCWeb_AddToListA(ListName,txtdesc,valdesc,ListIdx,SelFlag)	{
	var ListObj=document.getElementById(ListName);
	if (!ListObj){
		return;
	}
	var aryitmdes=txtdesc		//.split("^");
	var aryitminfo=valdesc		//.split("^");
	if (aryitmdes.length>0)	{
		ListObj.options[ListIdx] = new Option(aryitmdes,aryitminfo);	//,aryval[i]	
		if (isNaN(SelFlag)){ SelFlag=0;}
		if (SelFlag==1){
			ListObj.options[ListIdx].selected=true;
			
			///ListObj.selectedIndex=ListIdx;
		}
	}
}
function DHCWeb_GetListBoxValue(ObjName)
{
	///get ListBox Control Current Value;
	
	var myValue="";
	var obj=document.getElementById(ObjName);
	if (obj){
		var myIdx=obj.options.selectedIndex;
		if(myIdx<0){
			return myValue;
		}
		myValue=obj.options[myIdx].value;
	}
	return myValue;
	
}