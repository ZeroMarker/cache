var CurrentRow;
function BodyLoadHandler()
{
	
	obj=document.getElementById("Add") ;
    if (obj) obj.onclick=AddClick;
    
    obj=document.getElementById("Delete") ;
    if (obj) obj.onclick=DeleteClick;
    
    
    obj=document.getElementById("Update") ;
    if (obj) obj.onclick=UpdateClick;
    
	
}

function AddClick()
{
	var obj=document.getElementById("LocGrpName"); 
	if (obj) 
	{	
	    var LocDesc=(trim(obj.value))
		if (LocDesc!="")
		{
	
			var obj=document.getElementById("mInsert") ;
			if (obj) {var encmeth=obj.value;} else {var encmeth='';}
			var ret=cspRunServerMethod(encmeth,LocDesc) ;
			if (ret<0)
			{
				alert("保存失败,请重试")
			}
			else
			{
				QueryClick();
				QueryLocGrpItmByRowid(ret);
				
			}

		}   
	} 
}


function UpdateClick()
{
	if (typeof(CurrentRow)=='undefined') 
	{
		alert("请先选中预修改的记录");
		return;
	}
	
	var obj=document.getElementById("Trowid"+"z"+CurrentRow) 
	var descrowid=obj.innerText;
	var objdesc=document.getElementById("LocGrpName") 
	var locdesc=trim(objdesc.value);
	if (locdesc=="")
	{
		alert("名称不能为空,请重试")
		return;
	}	
	
	var obj=document.getElementById("mUpdate") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,descrowid,locdesc) ;
	if (ret<0)
			{
				alert("保存失败,请重试")
			}
	else
			{
				QueryClick();
			}



}
function DeleteClick()
{
	if (typeof(CurrentRow)=='undefined') 
	{
		alert("请先选中删除的记录");
		return;
	}
	var obj=document.getElementById("Tdesc"+"z"+CurrentRow) 
	var locdesc=obj.innerText;
	
	if (confirm("确认要删除< 科室组:"+locdesc+" >相关记录吗?")==false)  return ; 
	
	var obj=document.getElementById("Trowid"+"z"+CurrentRow) 
	var descrowid=obj.innerText;

	var obj=document.getElementById("mDelete") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,descrowid) ;
	if (ret<0)
			{
				alert("删除失败,请重试")
			}
	else
			{
				var objDesc=document.getElementById("LocGrpName")
	 			objDesc.value="";
				QueryClick();
			}

}

function SelectRowHandler()
 {
	 
	 var row=selectedRow(window);
	 CurrentRow=row;
     SetDesc();
     SetLocGrpIDToItm();
     QueryLocGrpItm();

 }
 
 
function SetDesc()
 {
	 var obj=document.getElementById("Tdesc"+"z"+CurrentRow)
	 var desc=obj.innerText;
	 var objDesc=document.getElementById("LocGrpName")
	 objDesc.value=desc; 
 }
 
function SetLocGrpIDToItm()
{
	 var objRowid=document.getElementById("Trowid"+"z"+CurrentRow)
	 var rowid=objRowid.innerText;
	 var docu=parent.frames['DHCST.PIVA.LOCGRPITM'].document
	 var objRowid=docu.getElementById("mRowid")
	 objRowid.value=rowid;

}
 
function QueryClick()
 {
	 var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.LOCGRP";
     parent.frames['DHCST.PIVA.LOCGRP'].location.href=lnk;
 }
 
function QueryLocGrpItm()
 {
	 
	 var objRowid=document.getElementById("Trowid"+"z"+CurrentRow);
	 var rowid=objRowid.innerText;
	 var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.LOCGRPITM&mRowid="+rowid;
     parent.frames['DHCST.PIVA.LOCGRPITM'].location.href=lnk;
 }
 
function QueryLocGrpItmByRowid(rowid)
 {
	 
	 var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.LOCGRPITM&mRowid="+rowid;
     parent.frames['DHCST.PIVA.LOCGRPITM'].location.href=lnk;
 }
 
document.body.onload=BodyLoadHandler;