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
	///ȡҽ���ֵ��У�pacadmreasondr��ҽ���ӿڵ��õĶ���
	var GetStr
	var QueStr=tkMakeServerCall("web.INSUDicDataCom","QueryDicData","AdmReasonDrToDLLType","")
	if(QueStr.split("^")[0]==0){
		alert("ҽ���ֵ�pacadmreasondr��ҽ���ӿڵ��õĶ���δά��");
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
	if(ExpStr==""){alert("����ҺŲ�������Ϊ��");return}
	var flag=InsuOPReg(Handle,UserId,"",1,AdmreasonDr,ExpStr)
	document.getElementById("BackStr").value=flag
}
function OPRegStr_click(){
	GetPacExp()
	var InsuAdmDr=document.getElementById("InsuAdmRowid").value 
	if (InsuAdmDr==""){alert("�����˺�ȱ�ٱ�Ҫ����");return}
	var flag=InsuOPRegStrike(Handle,UserId,InsuAdmDr,1,AdmreasonDr,ExpStr)
	document.getElementById("BackStr").value=flag	
}
function OPDivide_click(){
	GetPacExp();
	var PrtRowid=document.getElementById("PrtRowid").value
	if (PrtRowid==""||ExpStr==""){alert("�������ȱ�ٱ�Ҫ����");return}
	var Flag=InsuOPDivide(Handle , UserId, PrtRowid, 1, AdmReasonDr,ExpStr,"")
	document.getElementById("BackStr").value=Flag	
	
}
function OPDivideStr_click(){
	GetPacExp();
	var DivideDr=document.getElementById("DivideDr").value
	if (DivideDr==""){alert("�����˷�ȱ�ٱ�Ҫ����");return}
	var Flag=InsuOPDivide(Handle , UserId, DivideDr, 1, AdmReasonDr,ExpStr)
	document.getElementById("BackStr").value=Flag	
	
}
function IPReg_click(){
	GetPacExp();
	var PaadmDr=document.getElementById("PaadmRowid").value
	if(PaadmDr==""){alert("סԺ�ǼǾ���Ų���Ϊ��");return}
	var Flag=InsuIPReg(Handle,UserId,PaadmDr,1,AdmReasonDr,ExpStr)
	document.getElementById("BackStr").value=Flag	
	}
function IPRegStr_click(){
	GetPacExp();
	var PaadmDr=document.getElementById("PaadmRowid").value
	if(PaadmDr==""){alert("ȡ���ǼǾ���Ų���Ϊ��");return}
	var Flag=InsuIPRegStrike(Handle,UserId,PaadmDr, 1, AdmReasonDr,ExpStr)
	document.getElementById("BackStr").value=Flag	
	}
function IPUpDetails_click(){
	GetPacExp();
	var BillDr=document.getElementById("BillDr").value
	if(BillDr==""){alert("�ʵ��Ų���Ϊ��");return}
	var Flag=InsuIPMXUnload(Handle,UserId,BillDr,1,AdmReasonDr,ExpStr)
	document.getElementById("BackStr").value=Flag	
	}
function IPDelDetails_click(){
	GetPacExp();
	var BillDr=document.getElementById("BillDr").value
	if(BillDr==""){alert("�ʵ��Ų���Ϊ��");return}
	var Flag=InsuIPMXCancel(Handle,UserId,BillDr,1,AdmReasonDr,ExpStr)
	document.getElementById("BackStr").value=Flag	
}
function IPDivide_click(){
	GetPacExp();
	var BillDr=document.getElementById("BillDr").value
	if(BillDr==""){alert("�ʵ��Ų���Ϊ��");return}
	var Flag=InsuIPDivide(Handle,UserId,BillDr,1,AdmReasonDr,ExpStr)
	document.getElementById("BackStr").value=Flag	
	}
function IPDivideStr_click(){
	GetPacExp();
	var BillDr=document.getElementById("BillDr").value
	if(BillDr==""){alert("�ʵ��Ų���Ϊ��");return}
	var Flag=InsuIPDivideCancle(Handle,UserId,BillDr,1,AdmReasonDr,ExpStr)
	document.getElementById("BackStr").value=Flag	
	}
function IPPrintJSD_click(){
	///port����
	GetPacExp();
	var BillDr=document.getElementById("BillDr").value
	if(BillDr==""){alert("�ʵ��Ų���Ϊ��");return}
	var Flag=InsuIPMXUnload(Handle,UserId,BillDr,1,AdmReasonDr,ExpStr)
	document.getElementById("BackStr").value=Flag	
	}
function IPDividePre_click(){
	GetPacExp();
	var BillDr=document.getElementById("BillDr").value
	if(BillDr==""){alert("�ʵ��Ų���Ϊ��");return}
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
	alert("Port���޴�����")	
	
}
function GetPacExp(){
	AdmreasonDr=document.getElementById("AdmReasonDr").value
	ExpStr=document.getElementById("ExpStr").value
	}
document.body.onload = BodyLoadHandler;