/// /// 对应组件 DHCPEHighRiskType 高危维护
var CurrentSel=0
var SelectedRow=-1
var TFORM="tDHCPEHighRiskCondition"
function BodyLoadHandler()
{	
	var obj;
	
	obj=document.getElementById("Update");
	if (obj) obj.onclick=Update_Click;
	
	obj=document.getElementById("Delete");
	if (obj) obj.onclick=Delete_Click;
	
	obj=document.getElementById("ConditionFlag");
	if (obj) obj.onclick=ConditionFlag_click;
	
	obj=document.getElementById("Clear");
	if (obj) obj.onclick=Clear_Click;
}

//增加
function Update_Click()
{	
    var obj;
	var iCode="",iDesc=""
  	var obj=document.getElementById("Code");
    if (obj){
		iCode=obj.value
	}
	if (""==iCode){
		alert("请选择填写编号");
		return false
  	} 
  	var obj=document.getElementById("Desc");
    if (obj){
		iDesc=obj.value
	}
	if (""==iDesc){
		alert("请选择填写高危描述");
		return false
  	} 
        var String=iCode+"^"+iDesc
    	var Ins=document.getElementById('UpdateBox');
        if (Ins) {var encmeth=Ins.value} 
        else {var encmeth=''};
        var flag=cspRunServerMethod(encmeth,String)
       
     	
  location.reload();
}
//删除
function Delete_Click()
{	

	var obj="",Code="",Desc="";
	if(SelectedRow==-1){alert("请选择删除记录")}
    var SelRowObj=document.getElementById('TCode'+'z'+SelectedRow);
	obj=document.getElementById("Code");
	if (SelRowObj && obj) { Code=SelRowObj.innerText; }
	var Ins=document.getElementById('DeleteBox');
	if (Ins) {var encmeth=Ins.value; } 
	else {var encmeth=''};
	var flag=cspRunServerMethod(encmeth,Code);
	if ('0'==flag) {}
     location.reload();
     parent.frames["DHCPEHighRiskCondition"].location.href=lnk; 
}
function Clear_Click()
{	 

	
   location.reload();
   //parent.frames["DHCPEHighRiskCondition"].location.reload()

}
// **************************************************************

function ShowCurRecord(selectrow) {

	var SelRowObj;
	var obj;

	SelRowObj=document.getElementById('TCode'+'z'+selectrow);
	obj=document.getElementById("Code");
	if (SelRowObj && obj) { obj.value=SelRowObj.innerText; }

	SelRowObj=document.getElementById('TDesc'+'z'+selectrow);
	obj=document.getElementById("Desc");
	if (SelRowObj && obj) { obj.value=SelRowObj.innerText; }
	
	SearchConditionCom_click()
	
}
function SelectRowHandler(){  

	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCPEHighRiskType');
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;
	if (selectrow!=SelectedRow) {
		ShowCurRecord(selectrow);		
		SelectedRow = selectrow;
	}
	else { SelectedRow=0; }
	
}
function SearchConditionCom_click() {
 
	var iCode="",iDesc="";
	var objParam;
	var lnk="";
	iCode=document.getElementById("Code").value;	
	iDesc=document.getElementById("Desc").value;

	
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEHighRiskCondition"
			+"&Code="+iCode+"&Desc="+iDesc;

	
	parent.frames["DHCPEHighRiskCondition"].location.href=lnk; 

}




document.body.onload = BodyLoadHandler;