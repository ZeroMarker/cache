//UDHCDocPilotProDeptSeting.js
function BodyLoadHandler(){
	var obj=document.getElementById("Update");
	if (obj){obj.onclick=Update_Click;}
	
}

function Update_Click(){
	var objtbl=document.getElementById('tUDHCDocPilotProDeptSeting');
	var rows=objtbl.rows.length;
	for (var i=1;i<rows;i++) {
		var LocDesc=DHCC_GetColumnData("Desc",i);
		var rowid=DHCC_GetColumnData("rowid",i);
		var IfApprove=DHCC_GetColumnData("IfApprove",i);
		if (IfApprove==true) var Flag=1
		else Flag=""
			var SaveMethod=DHCC_GetElementData("SaveMethod");
			if (SaveMethod!=""){
				var rtn=cspRunServerMethod(SaveMethod,"DeptApprove",rowid,Flag);
				if (rtn!=0) alert(LocDesc+",保存不成功.")
			}
	}
	alert("保存成功")
}

document.body.onload = BodyLoadHandler;