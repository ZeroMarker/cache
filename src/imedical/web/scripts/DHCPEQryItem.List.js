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
	   alert("ûѡ����Ŀ,���ܱ���");
	   return false;
   }

	var ParRef="";
	var obj=document.getElementById("ParrefRowId");
	if (obj) ParRef=obj.value;
	if (ParRef==""){
		alert("û�в�ѯ��������������");
		return false;
	}
	
	var ret=tkMakeServerCall("web.DHCPE.PositiveRecord","SavePositiveItem",ParRef,Items)
	alert("�������")
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