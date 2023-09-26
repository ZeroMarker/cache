// dhcpha.addlocgrp.js
// hulihua 2014-06-26

var CurrentRow;
function BodyLoadHandler()
{

	
	obj=document.getElementById("Add") ;
    if (obj) obj.onclick=AddClick;
    
    obj=document.getElementById("Delete") ;
    if (obj) obj.onclick=DeleteClick;

    
    obj=document.getElementById("Update") ;
    if (obj) obj.onclick=UpdateClick;
    
	obj=document.getElementById("Query") ;
    if (obj) obj.onclick=QueryClick;

    var obj=document.getElementById("DispLoc"); 
	if (obj) 
	{obj.onkeydown=popDispLoc;
	obj.onblur=DispLocCheck;
	}
	 obj=document.getElementById("BodyLoaded");
	 if (obj.value!=1)
	 {
		//GetDefLoc() ;
	
	 }
	 setBodyLoaded();
	
}

function setBodyLoaded()
{
	var obj=document.getElementById("BodyLoaded") ;
	if (obj) obj.value=1;
}

function DispLocCheck()
{
	var obj=document.getElementById("DispLoc");
	var obj2=document.getElementById("DispLocRowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
	}
function popDispLoc()
{ 
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  DispLoc_lookuphandler();
		}
}

function AddClick()
{
	var obj=document.getElementById("LocGrpName");
	var objdisploc=document.getElementById("DispLocRowid"); 
	var locgrpdesc=trim(obj.value);
	if (locgrpdesc=="")
	{
		alert("科室组名称不能为空,请重试")
		return;
	}
	var disploc=trim(objdisploc.value);
	if (disploc=="")
	{
		alert("发药科室不能为空,请重试")
		return;
	}
	if (disploc=="全部")
	{
		alert("发药科室不能为全部,请重试")
		return;
	}
	
	
	
	if ((obj)&&(objdisploc)) 
	{	
	    var LocDesc=(trim(obj.value));
	    var disploc=(trim(objdisploc.value));
		if ((LocDesc!="")&&(disploc!=""))
		{
	
			var obj=document.getElementById("mInsert") ;
			if (obj) {var encmeth=obj.value;} else {var encmeth='';}
			var ret=cspRunServerMethod(encmeth,LocDesc,disploc) ;
			if (ret==-4){
				alert("当前科室组描述已存在!")
			}
			else if (ret<0){
				alert("保存失败,请重试,错误代码:"+ret)
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
		alert("科室组名称不能为空,请重试")
		return;
	}
		
	var objdisploc=document.getElementById("DispLocRowid")
	var disploc=trim(objdisploc.value);
	if (disploc=="")
	{
		alert("发药科室不能为空,请重试")
		return;
	}
	if (disploc=="全部")
	{
		alert("发药科室不能为全部,请重试")
		return;
	}
	var obj=document.getElementById("mUpdate") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,descrowid,locdesc,disploc) ;
	if (ret==-4){
		alert("当前科室组描述已存在,不需要更新!")
	}
	else if (ret<0){
		alert("保存失败,请重试,错误代码:"+ret)
	}
	else{
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
     SetDispLoc();
     SetLocGrpIDToItm();
     QueryLocGrpItm();

 }

function SetLookUpLocRowid(str)
{	var loc=str.split("^");
	var obj=document.getElementById("DispLocRowid");
	if (obj)
	{if (loc.length>0)   obj.value=loc[1] ;
		else	obj.value="" ;  
	}
} 
function GetDefLoc()
{	
	var objBodyLoaded=document.getElementById("BodyLoaded") ;
	if (objBodyLoaded) BodyLoaded=objBodyLoaded.value;
	
	if (BodyLoaded!=1)
	{
		var userid=session['LOGON.USERID'] ;
		var obj=document.getElementById("mGetDefaultLoc") ;
		if (obj) {var encmeth=obj.value;} else {var encmeth='';}
		var ss=cspRunServerMethod(encmeth,'setDefLoc','',userid) ;
		objBodyLoaded.value=1;
	}
}
function setDefLoc(value)
{
	var defloc=value.split("^");
	if (defloc.length>0)
	var locdr=defloc[0] ;
	var locdesc=defloc[1] ;
	if (locdr=="") return ;
	var obj=document.getElementById("DispLoc") ;
	if (obj) obj.value=locdesc
	var obj=document.getElementById("DispLocRowid") ;
	if (obj) obj.value=locdr
	
} 
function SetDesc()
 {
	 var obj=document.getElementById("Tdesc"+"z"+CurrentRow)
	 var desc=obj.innerText;
	 var objDesc=document.getElementById("LocGrpName")
	 objDesc.value=desc; 
 }
 
 function SetDispLoc()
 {
	 var obj=document.getElementById("Tdisploc"+"z"+CurrentRow)
	 var desc=obj.innerText;
	 var objDesc=document.getElementById("DispLoc")
	 objDesc.value=desc; 
	 var obj=document.getElementById("TdisplocId"+"z"+CurrentRow)
	 var rowid=obj.value;
	 var objrowid=document.getElementById("DispLocRowid")
	 objrowid.value=rowid; 	 
 }
 
function SetLocGrpIDToItm()
{
	 var objRowid=document.getElementById("Trowid"+"z"+CurrentRow)
	 var rowid=objRowid.innerText;
	 var docu=parent.frames['dhcpha.addlocgrpitm'].document
	 var objRowid=docu.getElementById("mRowid")
	 objRowid.value=rowid;

}
 
function QueryClick()
{
	var obj=document.getElementById("DispLocRowid"); 
	if (obj){var DispLocRowid=trim(obj.value);}
	Query_click();
}
 
function QueryLocGrpItm()
 {
	 
	 var objRowid=document.getElementById("Trowid"+"z"+CurrentRow);
	 var rowid=objRowid.innerText;
	 var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.addlocgrpitm&mRowid="+rowid;
     parent.frames['dhcpha.addlocgrpitm'].location.href=lnk;
 }
 
function QueryLocGrpItmByRowid(rowid)
 {
	 
	 var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.addlocgrpitm&mRowid="+rowid;
     parent.frames['dhcpha.addlocgrpitm'].location.href=lnk;
 }
 
document.body.onload=BodyLoadHandler;