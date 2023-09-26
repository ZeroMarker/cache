var SelectedRow = 0;
var preRowInd=0;
function BodyLoadHandler(){
	var obj=document.getElementById('BAdd')
	if(obj) obj.onclick=BAdd_click;
	var obj=document.getElementById('BUpdate')
	if(obj) obj.onclick=BUpdate_click;
	var obj=document.getElementById('BDelete')
	if(obj) obj.onclick=BDelete_click;
}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCANCOPLevel');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('ANOPLRowId');
	var obj1=document.getElementById('Code');
	var obj2=document.getElementById('Desc');
	
	var SelRowObj=document.getElementById('RowIdz'+selectrow);
	var SelRowObj1=document.getElementById('ANCOPL_Codez'+selectrow);
	var SelRowObj2=document.getElementById('ANCOPL_Descz'+selectrow);
	if (preRowInd==selectrow){
		obj.value="";
		obj1.value="";
		obj2.value="";
   		preRowInd=0;
    }
	else{if (obj) obj.value=SelRowObj.innerText;
	if (obj1) obj1.value=SelRowObj1.innerText;
	obj2.value=SelRowObj2.innerText;
	preRowInd=selectrow;
   }
	return;
}
function BAdd_click(){
	var obj=document.getElementById('Code')
	if(obj) var Code=obj.value;
	else var Code=""
	if(Code==""){
		alert(t['01']) 
		return;
		}
	var obj=document.getElementById('Desc')
	if(obj) var Desc=obj.value;
	else var Desc=""
	if(Desc==""){
		alert(t['02']) 
		return;
		}
	var obj=document.getElementById('InsertANCOPLevel')
	if(obj)
	{
		var encmeth=obj.value;
		var retStr=cspRunServerMethod(encmeth,Code,Desc)
		if(retStr!='0')
		{
			alert(t['baulk']);
			return
		}
		else
		{
			alert(t['succeed']);
			window.location.reload();
		}
	}
}
function BUpdate_click(){
	if(preRowInd<1)return;
	var obj=document.getElementById('ANOPLRowId')
	if(obj) var ANOPLRowId=obj.value;
	else var ANOPLRowId=""
	if(ANOPLRowId==""){
		alert(t['03']) 
		return;
		}
	var obj=document.getElementById('Code')
	if(obj) var Code=obj.value;
	else var Code=""
	if(Code==""){
		alert(t['01']) 
		return;
		}
	var obj=document.getElementById('Desc')
	if(obj) var Desc=obj.value;
	else Desc=""
	if(Desc==""){
		alert(t['02']) 
		return;
		}
	var obj=document.getElementById('UpdateANCOPLevel')
	if(obj)
	{
		var encmeth=obj.value;
		var retStr=cspRunServerMethod(encmeth,ANOPLRowId,Code,Desc)
		if(retStr!='0')
		{
		    alert("该手术规模代码已存在！")
			return
		}
		else
		{
			alert(t['succeed']);
			window.location.reload();
		}
	}
}
function BDelete_click(){
	if(preRowInd<1)return;
	var obj=document.getElementById('ANOPLRowId')
	if(obj) var ANOPLRowId=obj.value;
	else var ANOPLRowId=""
	if(ANOPLRowId==""){
		alert(t['03']) 
		return;
		}
	var obj=document.getElementById('DeleteANCOPLevel')
	if(obj)
	{
		var encmeth=obj.value;
		var retStr=cspRunServerMethod(encmeth,ANOPLRowId)
		if(retStr!='0')
		{
			alert(retStr)
			return
		}
		else
		{
			alert(t['succeed']);
			window.location.reload();
		}
	}
}
document.body.onload=BodyLoadHandler;