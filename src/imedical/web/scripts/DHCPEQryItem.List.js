var TFORM="tDHCPEQryItem_List"
function BodyLoadHandler()
{
	var obj;
	obj=document.getElementById("BSave");
	if (obj){obj.onclick=BSave_click;}
}
function BSave_click()
{
	var Items=GetSelectItemIDs();
	  if(Items==""){
	   alert("没选中项目,不能保存");
	   return false;
   }

	var ParRef="";
	var obj=document.getElementById("ParrefRowId");
	if (obj) ParRef=obj.value;
	if (ParRef==""){
		alert("没有查询条件，不能设置");
		return false;
	}
	
	var ret=tkMakeServerCall("web.DHCPE.PositiveRecord","SavePositiveItem",ParRef,Items)
	alert("保存完成")
}
function GetSelectItemIDs()
{
	var objtbl=document.getElementById(TFORM);
	if (objtbl) { var rows=objtbl.rows.length; }
	var SelRowObj,SetIDs="",OneID="";
	for (var i=1;i<rows;i++)
	{
		SelRowObj=document.getElementById('TSelect'+'z'+i);
		if (SelRowObj && SelRowObj.checked){
			var IDObj=document.getElementById('TItemID'+'z'+i);
			if (IDObj) OneID=IDObj.value;
			if (SetIDs==""){
				SetIDs=OneID;
			}else{
				SetIDs=SetIDs+"$"+OneID;
			}
		}
	}
	return SetIDs;
}

document.body.onload = BodyLoadHandler;