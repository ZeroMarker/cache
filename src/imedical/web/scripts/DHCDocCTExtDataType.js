///DHCDocCTExtDataType.js

var SelectedRow=0;

function BodyLoadHandler()
{
	var obj=document.getElementById('btnadd');
	if(obj){obj.onclick=AddClickHandler;}	
		
	var obj=document.getElementById('btnupdate');
	if(obj){obj.onclick=ModifyClickHandler;}	
	
	var obj=document.getElementById('CTEDTActive')
	if(obj){
		obj.size=1;
		obj.multiple=false;
		obj.options[0]=new Option("激活","Y");
		obj.options[1]=new Option("未激活","N");
	}
	ClearClickHandler();
}

function AddClickHandler()
{
	if (!CheckDate()){return}
	var obj=document.getElementById('CTEDTActive');
	if(obj) {var CTEDTActive=obj.options[obj.selectedIndex].value;}	
	var CTEDTCode=document.getElementById('CTEDTCode').value;
	var CTEDTDesc=document.getElementById('CTEDTDesc').value;
	var CTEDTClassName=document.getElementById('CTEDTClassName').value;
	var CTEDTQueryName=document.getElementById('CTEDTQueryName').value;
	
	var InStr=CTEDTCode+"^"+CTEDTDesc+"^"+CTEDTClassName+"^"+CTEDTQueryName+"^"+CTEDTActive;
	//alert(InStr)
	var Ins=document.getElementById('InsertMethod');
	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
	if(encmeth!=''){
		if(cspRunServerMethod(encmeth,InStr)!=0) alert("添加失败");
	}
	ClearClickHandler();
	window.location.reload();
}

function ModifyClickHandler()
{
	if(SelectedRow==0) {alert("请选择一条记录");return;}
	if (!CheckDate()){return}
	var CTEDTRowId=document.getElementById("TCTEDTRowIdz"+SelectedRow).value;
	var obj=document.getElementById('CTEDTActive');
	if(obj) {var CTEDTActive=obj.options[obj.selectedIndex].value;}	
	var CTEDTCode=document.getElementById('CTEDTCode').value;
	var CTEDTDesc=document.getElementById('CTEDTDesc').value;
	var CTEDTClassName=document.getElementById('CTEDTClassName').value;
	var CTEDTQueryName=document.getElementById('CTEDTQueryName').value;
	
	var InStr=CTEDTCode+"^"+CTEDTDesc+"^"+CTEDTClassName+"^"+CTEDTQueryName+"^"+CTEDTActive;
	var obj=document.getElementById('UpdateMethod');
	if(obj){var encmeth=obj.value;} else {var encmeth='';}
	if(encmeth!=''){
		if(cspRunServerMethod(encmeth,InStr,CTEDTRowId)==0){
			alert("更新成功");
			ClearClickHandler();
		}
		else{alert("更新失败");return;}
	}
	window.location.reload();
}

function DeleteClickHandler()
{
	if(SelectedRow==0) {alert("请选择一条记录");return;}
	var DelRowid=document.getElementById("HidRowidz"+SelectedRow).value;
	
	var Del=document.getElementById('Del');
	if(Del){var encmeth=Del.value;} else {var encmeth='';}	
	if(cspRunServerMethod(encmeth,DelRowid)!=0) {alert(t['tDel']);return;}
	ClearClickHandler();
	window.location.reload();
}

function ClearClickHandler()
{
	document.getElementById('CTEDTCode').value="";
	document.getElementById('CTEDTDesc').value="";
	document.getElementById('CTEDTRowId').value="";
	document.getElementById('CTEDTClassName').value="";
	document.getElementById('CTEDTQueryName').value="";
}

function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;//alert(selectrow)
	if(!selectrow) return;
	if(SelectedRow!=selectrow){
		SelectedRow=selectrow;
		document.getElementById('CTEDTRowId').value=document.getElementById('TCTEDTRowIdz'+selectrow).value;
		document.getElementById('CTEDTCode').value=document.getElementById('TCTEDTCodez'+selectrow).innerText;
		document.getElementById('CTEDTDesc').value=document.getElementById('TCTEDTDescz'+selectrow).innerText;
		document.getElementById('CTEDTClassName').value=document.getElementById('TCTEDTClassNamez'+selectrow).innerText;
		document.getElementById('CTEDTQueryName').value=document.getElementById('TCTEDTQueryNamez'+selectrow).innerText;
		var obj=document.getElementById('CTEDTActive');
		var TAF=document.getElementById('TCTEDTActivez'+selectrow).innerText;
		if(TAF=='是') obj.options[0].selected=true;
		else obj.options[1].selected=true;
	}
	else{
		SelectedRow=0
		ClearClickHandler();
		}
	
}
function CheckDate()
{
	var CTEDTActive=""
	var CTEDTCode=(document.getElementById('CTEDTCode').value).replace(/(^\s*)|(\s*$)/g,'');
	if (CTEDTCode==""){alert("请输入有效的代码!");return false}
	var CTEDTDesc=document.getElementById('CTEDTDesc').value.replace(/(^\s*)|(\s*$)/g,'');
	if (CTEDTDesc==""){alert("请输入有效的描述!");return false}
	var CTEDTClassName=document.getElementById('CTEDTClassName').value.replace(/(^\s*)|(\s*$)/g,'');
	if (CTEDTClassName==""){alert("请输入有效的类!");return false}
	var CTEDTQueryName=document.getElementById('CTEDTQueryName').value.replace(/(^\s*)|(\s*$)/g,'');
	if (CTEDTQueryName==""){alert("请输入有效的Query名称!");return false}
	var obj=document.getElementById('CTEDTActive');
	if(obj) {CTEDTActive=obj.options[obj.selectedIndex].value;}	
	if (CTEDTActive==""){alert("请选择有效标志!");return false}
	return true
	
}



document.body.onload=BodyLoadHandler;
