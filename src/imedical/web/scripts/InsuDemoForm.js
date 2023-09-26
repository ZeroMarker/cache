var UserId=session['LOGON.USERID'];
var Handle="0"
var AdmreasonDr,ExpStr
function BodyLoadHandler() {
	ini()
	var obj=document.getElementById("ReadCard")
	if(obj){obj.onclick=ReadCard_click}
	var obj=document.getElementById("OPReg")
	if(obj){obj.onclick=OPReg_click}
	var obj=document.getElementById("OPRegStr")
	if(obj){obj.onclick=OPRegStr_click}
	var obj=document.getElementById("OPDivide")
	if(obj){obj.onclick=OPDivide_click}
	var obj=document.getElementById("OPDivideStr")
	if(obj){obj.onclick=OPDivideStr_click}
	var obj=document.getElementById("IPReg")
	if(obj){obj.onclick=IPReg_click}
	var obj=document.getElementById("IPRegStr")
	if(obj){obj.onclick=IPRegStr_click}
	var obj=document.getElementById("IPUpDetails")
	if(obj){obj.onclick=IPUpDetails_click}
	var obj=document.getElementById("IPDelDetails")
	if(obj){obj.onclick=IPDelDetails_click}
	var obj=document.getElementById("IPDivide")
	if(obj){obj.onclick=IPDivide_click}
	var obj=document.getElementById("IPDivideStr")
	if(obj){obj.onclick=IPDivideStr_click}
	var obj=document.getElementById("IPPrintJSD")
	if(obj){obj.onclick=IPPrintJSD_click}
	var obj=document.getElementById("IPDividePre")
	if(obj){obj.onclick=IPDividePre_click}
	var obj=document.getElementById("FInsuTarUp")
	if(obj){obj.onclick=FInsuTarUp_click}
	var obj=document.getElementById("FInsuTarDown")
	if(obj){obj.onclick=FInsuTarDown_click}
	var obj=document.getElementById("FInsuDicDown")
	if(obj){obj.onclick=FInsuDicDown_click}

	
}
function ini(){
	///取医保字典中，pacadmreasondr到医保接口调用的对照
	var GetStr
	var QueStr=tkMakeServerCall("web.INSUDicDataCom","QueryDicData","AdmReasonDrToDLLType","")
	if(QueStr.split("^")[0]==0){
		alert("医保字典pacadmreasondr到医保接口调用的对照未维护");
		return
	}
	var obj=document.getElementById("AdmReasonDr")
	if(obj){
		obj.size=1
		obj.multiple=false
		for(var i=0;i<QueStr.split("^")[0];i++){
			GetStr=tkMakeServerCall("web.INSUDicDataCom","GetDicData",QueStr.split("^")[1],i+1)
			obj.options[i]=new Option(GetStr.split("^")[3],GetStr.split("^")[2]);	
			}
	}
}
function ReadCard_click(){
	var InsuNo=document.getElementById("InsuNO").value
	//function InsuReadCard(Handle,UserId,InsuNo,ExpString)
	var AdmreasonDr=document.getElementById("AdmReasonDr").value
	var InsuTypeCode=tkMakeServerCall("web.INSUDicDataCom","QueryByCode","AdmReasonDrToDLLType",AdmreasonDr).split("^")[5]
	//alert(UserId+"^"+)
	var flag=InsuReadCard(Handle,UserId,InsuNo,InsuTypeCode)
	document.getElementById("BackStr").value=flag
	}
function OPReg_click(){
	GetPacExp()
	if(ExpStr==""){alert("门诊挂号参数不可为空");return}
	var flag=InsuOPReg(Handle,UserId,"",1,AdmreasonDr,ExpStr)
	document.getElementById("BackStr").value=flag
}
function OPRegStr_click(){
	GetPacExp()
	var InsuAdmDr=document.getElementById("InsuAdmRowid").value 
	if (InsuAdmDr==""){alert("门诊退号缺少必要参数");return}
	var flag=InsuOPRegStrike(Handle,UserId,InsuAdmDr,1,AdmreasonDr,ExpStr)
	document.getElementById("BackStr").value=flag	
}
function OPDivide_click(){
	GetPacExp();
	var PrtRowid=document.getElementById("PrtRowid").value
	if (PrtRowid==""||ExpStr==""){alert("门诊结算缺少必要参数");return}
	var Flag=InsuOPDivide(Handle , UserId, PrtRowid, 1, AdmReasonDr,ExpStr,"")
	document.getElementById("BackStr").value=Flag	
	
}
function OPDivideStr_click(){
	GetPacExp();
	var DivideDr=document.getElementById("DivideDr").value
	if (DivideDr==""){alert("门诊退费缺少必要参数");return}
	var Flag=InsuOPDivide(Handle , UserId, DivideDr, 1, AdmReasonDr,ExpStr)
	document.getElementById("BackStr").value=Flag	
	
}
function IPReg_click(){
	GetPacExp();
	var PaadmDr=document.getElementById("PaadmRowid").value
	if(PaadmDr==""){alert("住院登记就诊号不能为空");return}
	var Flag=InsuIPReg(Handle,UserId,PaadmDr,1,AdmReasonDr,ExpStr)
	document.getElementById("BackStr").value=Flag	
	}
function IPRegStr_click(){
	GetPacExp();
	var PaadmDr=document.getElementById("PaadmRowid").value
	if(PaadmDr==""){alert("取消登记就诊号不能为空");return}
	var Flag=InsuIPRegStrike(Handle,UserId,PaadmDr, 1, AdmReasonDr,ExpStr)
	document.getElementById("BackStr").value=Flag	
	}
function IPUpDetails_click(){
	GetPacExp();
	var BillDr=document.getElementById("BillDr").value
	if(BillDr==""){alert("帐单号不能为空");return}
	var Flag=InsuIPMXUnload(Handle,UserId,BillDr,1,AdmReasonDr,ExpStr)
	document.getElementById("BackStr").value=Flag	
	}
function IPDelDetails_click(){
	GetPacExp();
	var BillDr=document.getElementById("BillDr").value
	if(BillDr==""){alert("帐单号不能为空");return}
	var Flag=InsuIPMXCancel(Handle,UserId,BillDr,1,AdmReasonDr,ExpStr)
	document.getElementById("BackStr").value=Flag	
}
function IPDivide_click(){
	GetPacExp();
	var BillDr=document.getElementById("BillDr").value
	if(BillDr==""){alert("帐单号不能为空");return}
	var Flag=InsuIPDivide(Handle,UserId,BillDr,1,AdmReasonDr,ExpStr)
	document.getElementById("BackStr").value=Flag	
	}
function IPDivideStr_click(){
	GetPacExp();
	var BillDr=document.getElementById("BillDr").value
	if(BillDr==""){alert("帐单号不能为空");return}
	var Flag=InsuIPDivideCancle(Handle,UserId,BillDr,1,AdmReasonDr,ExpStr)
	document.getElementById("BackStr").value=Flag	
	}
function IPPrintJSD_click(){
	///port暂无
	GetPacExp();
	var BillDr=document.getElementById("BillDr").value
	if(BillDr==""){alert("帐单号不能为空");return}
	var Flag=InsuIPMXUnload(Handle,UserId,BillDr,1,AdmReasonDr,ExpStr)
	document.getElementById("BackStr").value=Flag	
	}
function IPDividePre_click(){
	GetPacExp();
	var BillDr=document.getElementById("BillDr").value
	if(BillDr==""){alert("帐单号不能为空");return}
	var Flag=InsuIPDividePre(Handle,UserId,BillDr,1,AdmReasonDr,ExpStr)
	document.getElementById("BackStr").value=Flag		
	}
function FInsuTarUp_click(){
	var AdmreasonDr=document.getElementById("AdmReasonDr").value
	var InsuTypeCode=tkMakeServerCall("web.INSUDicDataCom","QueryByCode","AdmReasonDrToDLLType",AdmreasonDr).split("^")[5]
	var Flag=INSUUpLoadConAudit(InsuTypeCode)
	document.getElementById("BackStr").value=Flag	
}
function FInsuTarDown_click(){
	var AdmreasonDr=document.getElementById("AdmReasonDr").value
	var InsuTypeCode=tkMakeServerCall("web.INSUDicDataCom","QueryByCode","AdmReasonDrToDLLType",AdmreasonDr).split("^")[5]
	var Flag=INSUDownLoadConAudit(InsuTypeCode)	
	document.getElementById("BackStr").value=Flag
}
function FInsuDicDown_click(){
	alert("Port暂无此内容")	
	
}
function GetPacExp(){
	AdmreasonDr=document.getElementById("AdmReasonDr").value
	ExpStr=document.getElementById("ExpStr").value
	}
document.body.onload = BodyLoadHandler;