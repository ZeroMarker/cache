var TFORM="tDHCPEQrySet_List"
function GetSelectSetIDs()
{
	var objtbl=document.getElementById(TFORM);
	if (objtbl) { var rows=objtbl.rows.length; }
	var SelRowObj,SetIDs="",OneID="";
	for (var i=1;i<rows;i++)
	{
		SelRowObj=document.getElementById('TSelect'+'z'+i);
		if (SelRowObj && SelRowObj.checked){
			var IDObj=document.getElementById('TID'+'z'+i);
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