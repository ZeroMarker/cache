document.body.onload = BodyLoadHandler;
function BodyLoadHandler()
{
	var myobj = document.getElementById('Save');
	if (myobj) {
		myobj.onclick = Save_click;
	}
	var obj=document.getElementById('SynDesc');
	if (obj) obj.onkeydown = SynDescKeydownHandler;
}
function SynDescKeydownHandler(e){
	var key=websys_getKey(e);
	if (key==13) {
		return false;
	}
}
function Save_click()
{
	var Adm=websys_$('Adm').value
	var MRDiagnoeRowId=websys_$('MRDiagnoeRowId').value
	if (Adm==""){aletr("缺少有效的就诊信息");return }
	if (MRDiagnoeRowId==""){aletr("缺少有效的诊断信息");return}
	var Str=GetInsertSynStr()
	//var SynStr=GetInsertSynStr()
	var SynStr=Str.split("$")[0]
	var NewSynStr=Str.split("$")[1]
	var Rtn=tkMakeServerCall("web.DHCDocDiagnosNew","InsertDiaSynd",Adm,MRDiagnoeRowId,SynStr,session['LOGON.USERID'],NewSynStr);
	if (Rtn==0){alert("OK");return Find_click();}
	else{alert("Fail")}
}
function GetInsertSynStr()
{
	var objtbl=document.getElementById('tDHCDocDiagnosSyndSelect');
	var rows=objtbl.rows.length;
	var ReturnStr="",NewReturnStr=""
	for (var i=1;i<rows;i++){
		var syndr=websys_$('DSYMDrz'+i).value
		if (syndr!=""){
			if (NewReturnStr==""){NewReturnStr=syndr}
			else{NewReturnStr=NewReturnStr+"^"+syndr}
			var Obj=websys_$('CheckDSYz'+i)
			if (Obj.checked){
				if (ReturnStr==""){ReturnStr=syndr}
				else{ReturnStr=ReturnStr+"^"+syndr}
			}
		}
	}
	return ReturnStr+"$"+NewReturnStr
}
