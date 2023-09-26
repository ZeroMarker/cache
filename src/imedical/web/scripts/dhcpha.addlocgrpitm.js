// dhcpha.addlocgrpitm.js
// hulihua 2014-06-26

var CurrentRow;
function BodyLoadHandler()
{
	
	obj=document.getElementById("Add") ;
    if (obj) obj.onclick=AddClick;
	
}


function AddClick()
{
	var obj=document.getElementById("mRowid") 
    var mrowid=obj.value;
	if (mrowid==""){
		alert("请先选择科室组!");
		return;
	}
	if (confirm("确认要保存吗?")==false)  return ;
	//if (DeleteItm()==-1)
	//{
	//	QueryClick();
	//	return;
	//} 
    var objtbl=document.getElementById("t"+"dhcpha_addlocgrpitm")
    var cnt=getRowcount(objtbl) ;
    var str="",delstr=""
	for (var i=1;i<=cnt;i++)
	{
		var objsel=document.getElementById("Tselect"+"z"+i);
		var objrowid=document.getElementById("Trowid"+"z"+i);
		var locrowid=objrowid.innerText;
		
		if (objsel.checked==true )
		{
			if (str=="")
			{
				
				str=locrowid;
			}
			else
			{
				str=str+"^"+locrowid;
			}
		}
		else
		{
			if (delstr=="")
			{
				
				delstr=locrowid;
			}
			else
			{
				delstr=delstr+"^"+locrowid;
			}
		}
	}
	if ((str=="")&&(delstr==""))
	{
		QueryClick();
		return;
	}
	if (str!=""){
		var obj=document.getElementById("mInsert") ;
		if (obj) {var encmeth=obj.value;} else {var encmeth='';}
		var ret=cspRunServerMethod(encmeth,str,mrowid) ;
		if (ret<0)
		{
			alert("保存失败,请重试")
		}
	}
	if (delstr!=""){
		var ret=tkMakeServerCall("web.DHCSTPHAADDLOCGRP","DeleteLocGrpItm",delstr,mrowid)
		if (ret<0)
		{
			alert("未勾选信息保存失败,请重试")
		}
	}
	QueryClick();

}
function SelectRowHandler()
 {
	 
	 var row=selectedRow(window);
	 CurrentRow=row;


 }
 
 
function QueryClick()
 {
	 var obj=document.getElementById("mRowid") ;
	 var rowid= obj.value;
	 var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.addlocgrpitm&mRowid="+rowid;
     parent.frames['dhcpha.addlocgrpitm'].location.href=lnk;
 }
 

 
document.body.onload=BodyLoadHandler;