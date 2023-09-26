
var UserId=session['LOGON.USERID'];
var CloseODSDivFlag="1";
var CurID="";
var EDWin;
var ResultWin;
var ReportWin;
document.body.onload = BodyLoadHandler;

function BodyLoadHandler()
{
	SetAreaTextHeight();
	var obj=document.getElementById("EpisodeID");
	if (obj) var EpisodeID=obj.value;
   //�����ύ
   	var obj=document.getElementById(EpisodeID+"^Save");
	if (obj) obj.onclick=Audit_click;
    //�����ܼ�
	var obj=document.getElementById(EpisodeID+"^Auto");
	if (obj) obj.onclick=SumResult_click;
	//ȡ�����
	 var obj=document.getElementById(EpisodeID+"^Cancel");
	if (obj) obj.onclick=StationSCancelSub;
	 var obj=document.getElementById(EpisodeID+"^Look");
	if (obj) obj.onclick=ShowResultLook_click;
    //���ν��
	var obj=document.getElementById(EpisodeID+"^History");
	if (obj) obj.onclick=GetContrastWithLast;
	//����Ԥ��
	var obj=document.getElementById(EpisodeID+"^Report");
	if (obj) obj.onclick=PreviewReport;
	//���鱣��
	var obj=document.getElementById(EpisodeID+"^SaveD");
	if (obj) obj.onclick=Save_click;
	//����ϲ�
	var obj=document.getElementById(EpisodeID+"^ShowUnite");
	if (obj) obj.onclick=ShowUnite_click;
	//��Σ
	var obj=document.getElementById(EpisodeID+"^HighRisk");
	if (obj) obj.onclick=HighRiskReport;
	//��鱨��
	var obj=document.getElementById(EpisodeID+"^CheckResult");
	if (obj) obj.onclick=ShowCheckResult;
	//������
	var obj=document.getElementById(EpisodeID+"^CheckPISResult");
	if (obj) obj.onclick=ShowCheckPISResult;
	//������
	var obj=document.getElementById(EpisodeID+"^Conc");
	if (obj) obj.onclick=Conclusion;
	//�����ϱ�
	var obj=document.getElementById(EpisodeID+"^QM");
	if (obj) obj.onclick=QMManager;
	//ָ����Ԥ��
	var obj=document.getElementById(EpisodeID+"^PreviewDirect");
	if (obj) obj.onclick=PreviewDirect;
	//���
	var obj=document.getElementById(EpisodeID+"^SendAudit");
	if (obj) obj.onclick=SendAudit;
	//ȫѡ����
	var obj=document.getElementById(EpisodeID+"^Select");
	if (obj) obj.onclick=SelectAdvice;
	//�����ύ
	var obj=document.getElementById(EpisodeID+"^SaveF");
	if (obj) obj.onclick=Audit_click;
	//ȡ������
	var obj=document.getElementById(EpisodeID+"^CancelF");
	if (obj) obj.onclick=StationSCancelSub;
	//ȡ������
	var obj=document.getElementById(EpisodeID+"^CancelC");
	if (obj) obj.onclick=StationSCancelSub;
 	//���潨��
    var obj=document.getElementById(EpisodeID+"^SaveAP");
	if (obj) obj.onclick=SaveAdviceApp;

	var obj=document.getElementById("OnlyRead");
	if (obj) OnlyRead=obj.value;
	var ReloadFlag="N"
	var obj=document.getElementById("ReloadFlag");
	if (obj) ReloadFlag=obj.value;
	var MainDoctor="",AuditUser="";
	var obj=document.getElementById("MainDoctor");
	if (obj) MainDoctor=obj.value;
	var obj=document.getElementById("AuditUser");
	if (obj) AuditUser=obj.value;
	if ((OnlyRead!="Y")&&(ReloadFlag!="Y")&&(MainDoctor!="Y")&&(AuditUser=="")){
		SumResult_click();
	}
	var obj=document.getElementById("SSID");
	if (obj) GSID=obj.value;
	var ObjArr=document.getElementsByName("DeleteButton");
	var ArrLength=ObjArr.length;	
	for (var i=0;i<ArrLength;i++)
	{
		var ID=ObjArr[i].id;
	    var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosis","GetSSDiagnosisAdvice",ID);
	    var arr=ret.split("^");
	   // alert(arr);
		var obj=document.getElementById(ID+"^JY");
		if (obj) obj.value=arr[0];
		var obj=document.getElementById(ID+"^JL");
		if (obj) obj.value=arr[1];
	
	}
	try{
		//alert(parent.frames("baseinfo"))
		if (parent.frames("baseinfo"))
		{
			setTimeout("SetParentFocues()",200)
		}
	}
	catch(e){
		//alert("catch")
	}
	//FormatAreaHeight();
}
function SetParentFocues()
{
	parent.frames["baseinfo"].websys_setfocus("RegNo");
}
//���潨��
   
function SaveAdviceApp(CloseFlag)
{
	var ObjArr=document.getElementsByName("DeleteButton");
	var ArrLength=ObjArr.length; 
	var Strings="",Remark="",OEItemId="",EDCRowId="";
	for (var i=0;i<ArrLength;i++)
	{
		var tr=ObjArr[i].parentNode.parentNode;
		var Sort=tr.rowIndex+1;
		var ID=ObjArr[i].id;
		var Advice="";
		var obj=document.getElementById(ID+"^JY");
		if (obj) Advice=obj.value;
		obj=document.getElementById('TReCheckz'+i);
		var ReCheck="N";
		var obj=document.getElementById(ID+"^MD");
		if(obj){
			if (obj.checked){ReCheck="Y" }
			else{
				/*
				if ((MainAuditFlag=="1")&&(confirm("��"+(i+1)+"��ȷʵҪɾ����")))
				{
					ReCheck="N";
				}else{
					ReCheck="Y";
				}
				*/
			}
		}
		var DisplayDesc="";
		var obj=document.getElementById(ID+"^JL");
		if (obj) DisplayDesc=obj.value;
		//alert(Sort+"^"+DisplayDesc)
		if (Strings=="")
		{
			Strings=ID+"&&"+Remark+"&&"+Advice+"&&"+Sort+"&&"+EDCRowId+"&&"+OEItemId+"&&"+DisplayDesc+"&&"+ReCheck;
		}
		else
		{
			Strings=Strings+"^"+ID+"&&"+Remark+"&&"+Advice+"&&"+Sort+"&&"+EDCRowId+"&&"+OEItemId+"&&"+DisplayDesc+"&&"+ReCheck;
		}
	
	}
	//alert("Strings:"+Strings)
	if (Strings=="") {
		alert("����ͽ���Ϊ��");
		return false;
	}
	
	var MainDoctor="";
	var obj=document.getElementById("MainDoctor");
	if (obj) MainDoctor=obj.value;
	var flag=tkMakeServerCall("web.DHCPE.ResultDiagnosis","UpdateStationDRemark",Strings,MainDoctor)
	//alert("flag:"+flag)
	
	//var flag=cspRunServerMethod(encmeth,Strings,MainDoctor);
	var SaveSortInfo=""
	if (SaveSortInfo!=""){
		var GSID="";
		var obj=document.getElementById("GSID");
		if (obj) GSID=obj.value;
		var ret= tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","SaveSortInfo",GSID,SaveSortInfo);
	} 
	if (CloseFlag==0) return false;
	  window.location.reload();
	if (opener){
		opener.location.reload();
	}
	window.returnValue=1;
	window.close();
}


//��Σ
function HighRiskReport()
{
	var iEpisodeID="";
	obj=document.getElementById("EpisodeID");
	if (obj) { iEpisodeID=obj.value; }
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPESendMessageNew"
			+"&PAADM="+iEpisodeID+"&OrderItemID=";
	var wwidth=600;
	var wheight=400;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)
	return false;
}
function PreviewAllReport()
{
	var iReportName="",iEpisodeID="";
	obj=document.getElementById("ReportNameBox");
	if (obj) { iReportName=obj.value; }
	obj=document.getElementById("EpisodeID");
	if (obj) { iEpisodeID=obj.value; }
	
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no'
		+',left=0'
		+',top=0'
		+',width='+window.screen.availWidth
		+',height='+(window.screen.availHeight-40)
		;
	var lnk=iReportName+"?PatientID="+iEpisodeID;
	if (ReportWin) ReportWin.close();
	ReportWin=window.open(lnk,"ReportWin",nwin)
}
function ShowLocResult(e)
{
	var OEORDItemID=e.id;
	var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENewOneResult&StationID=a&OEORDItemID="+OEORDItemID;
  	var wwidth=550;
	var wheight=600; 
	var xposition = ((screen.width - wwidth) / 2)-20;
	var yposition = ((screen.height - wheight) / 2)-100;
	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes'
			+',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	if (ResultWin) ResultWin.close();
	ResultWin=window.open(url,"ResultWin",nwin)
	
	//window.open(url,"_blank",nwin)
}
function SetAreaTextHeight()
{
	var objArr=document.getElementsByTagName("textarea");
	var objLength=objArr.length;
	for (var i=0;i<objLength;i++)
	{
		setTareaAutoHeight(objArr[i]);
	}
}
function FormatAreaHeight()
{
	var ObjArr=document.getElementsByName("DeleteButton");
	var ArrLength=ObjArr.length;
	for (var i=0;i<ArrLength;i++)
	{
		var ID=ObjArr[i].id;
		var JYObj=document.getElementById(ID+"^JY");
		var JLObj=document.getElementById(ID+"^JL");
		if (JYObj&&JLObj){
			if (JLObj.scrollHeight>JYObj.scrollHeight){
				JYObj.style.height=100+" px";
				//alert("a"+JYObj.style.height+"^"+JLObj.style.height)
			}else{
				JLObj.style.height=100+" px"
				//alert("b"+JYObj.style.height+"^"+JLObj.style.height)
			}
		}
	}
}
function Save_click()
{
	var ObjArr=document.getElementsByName("DeleteButton");
	var ArrLength=ObjArr.length;	
	var Strings="",Remark="",OEItemId="",EDCRowId="";
	for (var i=0;i<ArrLength;i++)
	{
		var ID=ObjArr[i].id;
		var obj=document.getElementById(ID+"^Sort");
		var Sort=obj.innerText;
		var Advice="";
		var obj=document.getElementById(ID+"^JY");
		if (obj) Advice=obj.value;
		obj=document.getElementById('TReCheckz'+i);
		var ReCheck="N";
		var DisplayDesc="";
		var obj=document.getElementById(ID+"^JL");
		if (obj) DisplayDesc=obj.value;
		if (Strings=="")
		{
			Strings=ID+"&&"+Remark+"&&"+Advice+"&&"+Sort+"&&"+EDCRowId+"&&"+OEItemId+"&&"+DisplayDesc+"&&"+ReCheck;
		}
		else
		{
			Strings=Strings+"^"+ID+"&&"+Remark+"&&"+Advice+"&&"+Sort+"&&"+EDCRowId+"&&"+OEItemId+"&&"+DisplayDesc+"&&"+ReCheck;
		}
	
	}
	if (Strings=="") return false;
	var obj=document.getElementById("UpdateClass");
	if (obj) var encmeth=obj.value;
	var MainDoctor="";
	var obj=document.getElementById("MainDoctor");
	if (obj) MainDoctor=obj.value;
	var flag=cspRunServerMethod(encmeth,Strings,MainDoctor)
	if (flag!=0){
		alert(t[flag])
	}
return false;	
}
function DeleteAdvice(e,ConfirmFlag)
{
	if(ConfirmFlag==1){
		if (!confirm(t['Del'])) {
			window.location.reload();
			return false;
		}
	}
	var ID=e.id;
	var obj=document.getElementById("AddEDClass");
	if (obj) var encmeth=obj.value;
	if (ID=="") return false;
	var SSID=ID.split("||")[0];
	var MainDoctor="";
	var obj=document.getElementById("MainDoctor");
	if (obj) MainDoctor=obj.value;
	var flag=cspRunServerMethod(encmeth,SSID,ID,"2",MainDoctor);
	DeleteTableRow(e);
	//window.location.reload();
}
function DeleteTableRow(e)
{
	var Rows=e.parentNode.parentNode.rowIndex;
	//var TableObj=document.getElementById("EditAdvice");
	var TableObj=e.parentNode.parentNode.parentNode;
	TableObj.deleteRow(Rows);

}
function PreviewReport()
{
	var obj;
	var iReportName="",iEpisodeID="";
	obj=document.getElementById("ReportNameBox");
	if (obj) { iReportName=obj.value; }
	obj=document.getElementById("EpisodeID");
	if (obj) { iEpisodeID=obj.value; }
	
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no'
		+',left=0'
		+',top=0'
		+',width='+window.screen.availWidth
		+',height='+window.screen.availHeight
		;
	var lnk=iReportName+"?PatientID="+iEpisodeID; //+"&OnlyAdvice=Y";
	open(lnk,"_blank",nwin);
	return false;
}
function GetContrastWithLast()
{
	var obj;
	var iEpisodeID="";
	obj=document.getElementById("EpisodeID");
	if (obj) { iEpisodeID=obj.value; }
	//alert(iEpisodeID)
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEContrastWithLast"
			+"&PAADM="+iEpisodeID
	
		var wwidth=1000;
	var wheight=600; 
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes'
			+',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	window.open(lnk,"_blank",nwin)	
	//return true;
	return false;
}
function SumResult_click()
{
	var Type=0
	obj=document.getElementById("SSID");
	if (obj) var SSID=obj.value;
	if (SSID!="")
	{
		if (confirm(t['04'])){
			var Type=1;
		}else{
			return false;
		}
	}
	obj=document.getElementById("EpisodeID");
	if (obj) var PAADM=obj.value;
	if (PAADM=="") return false;
	obj=document.getElementById("IsCanSumResult");
	if (obj) var encmeth=obj.value;
	var flag=cspRunServerMethod(encmeth,PAADM);
	var values=flag.split("^");
	flag=values[0];
	if (flag!=0)
	{
		if (!confirm(values[1]+t[flag]+",�Ƿ�����ܼ�?")) return false;
	}
	obj=document.getElementById("SumResultBox");
	if (obj) var encmeth=obj.value;
	var Remark=""
	var flag=cspRunServerMethod(encmeth,PAADM,Type,Remark);
	var values=flag.split("^");
	flag=values[0];
	if (flag==0)
	{
		//window.location.reload();
		window.location.href=window.location.href+"&ReloadFlag=Y"
		return false;
	}
	alert(values[1]+t[flag]);
	return false;
}
function SelectAdvice()
{
	var objArr=document.getElementsByName("MainFlag");
	for (var i=0;i<objArr.length;i++)
	{
		objArr[i].checked=true;
	}
	return false;
}
function SaveAdvice(AlertFlag)
{
	Save_click();
	//return false;
	var SaveInfo="";
	var NoUseInfo=""
	var objArr=document.getElementsByName("MainFlag");
	var ArrLength=objArr.length;
	for (var i=0;i<objArr.length;i++)
	{
		if (objArr[i].checked){
			if (SaveInfo==""){
				SaveInfo=objArr[i].id;
			}else{
				SaveInfo=SaveInfo+"^"+objArr[i].id;
			}
		}else{
			if (NoUseInfo==""){
				NoUseInfo=objArr[i].id;
			}else{
				NoUseInfo=NoUseInfo+"^"+objArr[i].id;
			}
		}
	}
	/*
	if (SaveInfo==""){
			if (AlertFlag=="1") alert("û��ѡ����,���ܱ���.");
			return false;
	}*/
	if ((SaveInfo=="")&&(ArrLength=="0")){
		if (!confirm("û�н���,�Ƿ�����ύ")) return false;
		
	}
	
	if ((SaveInfo=="")&&(ArrLength!="0")){
			if (AlertFlag=="1") alert("û��ѡ����,���ܱ���.");
			return false;
	}
	if (AlertFlag=="1"){
		if (NoUseInfo!=""){
			if (!confirm("��ûѡ�еĽ���,�Ƿ����")) return false;
		}
	}

	
	var encmeth="";
	var obj=document.getElementById("SaveMainCheckClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,SaveInfo,NoUseInfo,UserId);
	return ret;
	//return true;
}
function ShowResult_click(SaveFlag)
{
	var obj,GSID="",MainDoctor="";
	obj=document.getElementById("SSID");
	if (obj) GSID=obj.value;
	//alert(GSID)
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENewGSSDetail&GSID="+GSID+"&ButtonFlag="+SaveFlag;
	var  iWidth=1000; //ģ̬���ڿ��
  	var  iHeight=700;//ģ̬���ڸ߶�
  	var  iTop=(window.screen.height-iHeight)/2;
  	var  iLeft=(window.screen.width-iWidth)/2;
  	var ret=window.showModalDialog(lnk, "", "dialogwidth:1000px;dialogheight:600px;center:1"); 
	//var ret=window.open(lnk, "", "");
	if(!ret){
               ret=window.returnValue;
            }
    
    
	return ret;
}
function ShowResultLook_click()
{
	var obj,GSID="",MainDoctor="";
	obj=document.getElementById("SSID");
	if (obj) GSID=obj.value;
	//alert(GSID)
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENewGSSDetail&GSID="+GSID+"&ButtonFlag="+0;
	var  iWidth=1000; //ģ̬���ڿ��
  	var  iHeight=700;//ģ̬���ڸ߶�
  	var  iTop=(window.screen.height-iHeight)/2;
  	var  iLeft=(window.screen.width-iWidth)/2;
  	var ret=window.showModalDialog(lnk, "", "dialogwidth:1000px;dialogheight:600px;center:1"); 
	//var ret=window.open(lnk, "", "");
	if(!ret){
               ret=window.returnValue;
            }
    
	return false;
}
function ShowUnite_click()
{
	var MainDoctor="";
	var obj=document.getElementById("MainDoctor");
	if (obj) MainDoctor=obj.value;
	
	if (MainDoctor=="Y"){
		//���챣�潨��
		var ret=SaveAdvice("0");
		//if (!ret) return false;
	}else{
		//���潨��
		Save_click();
	}
	
	//Save_click();
	ModifyAdviceApp("");
	return false;
}
function ModifyAdvice(e)
{
	var ret=ModifyAdviceApp(e.id)
}
function ModifyAdviceApp(StationID)
{
	var obj,GSID="",MainDoctor="";
	obj=document.getElementById("SSID");
	if (obj) GSID=obj.value;
	obj=document.getElementById("MainDoctor");
	if (obj) MainDoctor=obj.value;
	var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENewEditAdvice&GSID="+GSID+"&StationID="+StationID+"&MainDoctor="+MainDoctor;
  	var  iWidth=800; //ģ̬���ڿ��
  	var  iHeight=600;//ģ̬���ڸ߶�
  	var  iTop=(window.screen.height-iHeight)/2;
  	var  iLeft=(window.screen.width-iWidth)/2;
  	
	var wwidth=800;
	var wheight=600;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	//var ret=window.showModalDialog(url, "", "dialogwidth:800px;dialogheight:600px;center:1"); 
  	
	var cwin=window.open(url,"_blank",nwin)	
	return false
	
	if (StationID!=""){
		var obj=document.getElementById("GetAdviceByStation");
		if (obj) encmeth=obj.value;
		//GSID,CurStation,MainDoctorFlag
		var ret=cspRunServerMethod(encmeth,GSID,StationID,MainDoctor,"Y");
		var Arr=ret.split("^");
		var ID=Arr[0];
		var Info=Arr[1];
		var obj=document.getElementById(ID);
		if (obj) obj.innerHTML=Info;
	}else{
		//var objArr=document.getElementsByName("StationAdvice");
		window.location.reload();
	}
	if(ret!=1){
		return false;
	}
	//if (StationID!="") window.location.reload();
	
	return true
}
function Audit_click()
{
	//UpdateGSSDetail
	var MainDoctor="";
	var obj=document.getElementById("MainDoctor");
	if (obj) MainDoctor=obj.value;
	if (MainDoctor=="Y"){
		//���챣�潨��
		var ret=SaveAdvice("1");
		if (!ret) return false;
	}else{
		//���潨��
		Save_click();
	}
	obj=document.getElementById("EpisodeID");
	if (obj) var PAADM=obj.value;
	
	//�ж��Ƿ�������Ա�һ�µĹؼ���
	var SelectMark=""
	var SelectMark=tkMakeServerCall("web.DHCPE.ReportGetInfor","SelectMarkDesc",PAADM);
	if(SelectMark!=""){
		if (!confirm("�������Ա�һ�¹ؼ���: "+SelectMark+" ,�Ƿ����?")) return false;
		
		}

	//�ж��Ƿ���û�н������Ŀ
	obj=document.getElementById("NoResultItemClass");
	if (obj) var encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,PAADM);
	if (ret!=""){
		var Char_1=String.fromCharCode(1);
		var NoResultArr=ret.split(Char_1);
		var NoResultDesc=NoResultArr[1];
		if (confirm("����δ��ɵ���Ŀ'"+NoResultDesc+"'�Ƿ�Ѹ���Ŀ����")){
			//�����Ƿ����
			var NoResultIDs=NoResultArr[0];
			obj=document.getElementById("RefuseItems");
			if (obj) var encmeth=obj.value;
			var ret=cspRunServerMethod(encmeth,NoResultIDs);
		}
	}
	// �Զ���������
	if (MainDoctor=="N"){
		var CurLocID=session['LOGON.CTLOCID'];
		var ConRet=tkMakeServerCall("web.DHCPE.OtherPatientToHP","InsertConOrder",PAADM,"",UserId,UserId,CurLocID)
		var ConArr=ConRet.split("^");
		if (ConArr[0]=="-1"){
			alert(ConArr[1]);
			return false;
		}else if (ConArr[0]=="-2"){
			if (!confirm(ConArr[1]+",�Ƿ����?")) return false;
		}
	}
	//if (!ModifyAdviceApp("")) return false;
	/* �����ܵĽ����ᵽ���֮ǰ  wgy*/
	var obj=document.getElementById("CreateGSSDetail");
	if (obj) var encmeth=obj.value;
	obj=document.getElementById("SSID");
	if (obj) GSID=obj.value;
	var ret=cspRunServerMethod(encmeth,GSID,MainDoctor);
	var ret=ShowResult_click(1);
	if (ret!=1) return false;
	/*end*/
	obj=document.getElementById("AuditBox");
	if (obj) var encmeth=obj.value;
	var flag=cspRunServerMethod(encmeth,PAADM,"Submit","0",MainDoctor);
	if (flag=="0")
	{
		window.location.reload();
		return false;
	}
	alert(t[flag]);
	return false;
}
function StationSCancelSub()
{
	StatusChange("Cancel","0");
}
function StatusChange(Type,QXType)
{
	obj=document.getElementById("EpisodeID");
	if (obj) var PAADM=obj.value;
	var MainDoctor="";
	var obj=document.getElementById("MainDoctor");
	if (obj) MainDoctor=obj.value;
	
	if(Type=="Cancel")
	{
		var AuditUser=tkMakeServerCall("web.DHCPE.ResultDiagnosis","GetAuditUserId",PAADM,MainDoctor);
		if (AuditUser==""){
			alert(t["NoAudit"]);
			return false;
		}
		if((AuditUser!=UserId)&&(UserId!="1177")&&(UserId!="2386")){
			alert("�Ǳ����ύ���ܷ����ύ");
			window.location.reload();
			return;	
		}
			
	}
	
	//����ǩ��
	try{
		var SignType="2";
		if (MainDoctor=="Y") SignType=3;
		if (!PESaveCASign(SignType,PAADM,"")) return false;
	}catch(e){}
   //
	obj=document.getElementById("AuditBox");
	if (obj) var encmeth=obj.value;
	var flag=cspRunServerMethod(encmeth,PAADM,Type,QXType,MainDoctor);
	if (flag=="0")
	{
		window.location.reload();
		return false;
	}
	else{
		alert(t[flag]);
		return false;
	}
}
function ShowEDInfo(e)
{
	var OnlyRead="N";
	var obj=document.getElementById("OnlyRead");
	if (obj) OnlyRead=obj.value;
	if (OnlyRead=="Y") return false;
	
	var Status="";
	var obj=document.getElementById("Status");
	if (obj) Status=obj.value;
	if ((Status==2)||(Status=="")) return false;  //�Ѹ���
	var MainDoctor="";
	var obj=document.getElementById("MainDoctor");
	if (obj) MainDoctor=obj.value;
	if ((Status==1)&&(MainDoctor=="N")) return false; //��������ѳ���
	if ((Status==0)&&(MainDoctor=="Y")) return false; //�������δ����
		
	
	var OEORDItemID=e.id;
	CurID=OEORDItemID;
	var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEShowEDInfo&OEORDItemID="+OEORDItemID;
  	var wwidth=300;
	var wheight=600; 
	var xposition = screen.width-wwidth-30;
	var yposition = ((screen.height - wheight) / 2)-100;
	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes'
			+',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	if (EDWin) EDWin.close();
	EDWin=window.open(url,"EDWin",nwin);
	
}
function ShowOneResult(e)
{
	obj=document.getElementById("MainDoctor");
	if (obj) MainDoctor=obj.value;
	var OEORDItemID=e.id;
	var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENewOneResult&OEORDItemID="+OEORDItemID;
  	var wwidth=550;
	var wheight=600; 
	var xposition = ((screen.width - wwidth) / 2)-20;
	var yposition = ((screen.height - wheight) / 2)-100;
	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes'
			+',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	if (ResultWin) ResultWin.close();
	ResultWin=window.open(url,"ResultWin",nwin)
}
function RemoveAllDiv(Type)
{
	if (CloseODSDivFlag=="1"){
		var div=document.getElementById("ODSDiv");  
		if (div!=null) document.body.removeChild(div);
	}else{
		CloseODSDivFlag="1";
	}
	var div=document.getElementById("EDDetail");  
    if (div!=null) document.body.removeChild(div);
	var div=document.getElementById("ALLEDDesc");  
    if (div!=null) document.body.removeChild(div);
	if (Type=="1")
	{
		var div=document.getElementById("EDDiv");  
		if (div!=null) document.body.removeChild(div);
	}
}
function getoffset(elem)   
{
	if ( !elem ) return {left:0, top:0};

    var top = 0, left = 0;

    if ( "getBoundingClientRect" in document.documentElement ){

        //jquery����

        var box = elem.getBoundingClientRect(), 

        doc = elem.ownerDocument, 

        body = doc.body, 

        docElem = doc.documentElement,

        clientTop = docElem.clientTop || body.clientTop || 0, 

        clientLeft = docElem.clientLeft || body.clientLeft || 0,

        top  = box.top  + (self.pageYOffset || docElem && docElem.scrollTop  || body.scrollTop ) - clientTop,

        left = box.left + (self.pageXOffset || docElem && docElem.scrollLeft || body.scrollLeft) - clientLeft;

    }else{

        do{

            top += elem.offsetTop || 0;

            left += elem.offsetLeft || 0;

            elem = elem.offsetParent;

        } while (elem);

	}
	var rec = new Array(1);   
	rec[0] = top;   
	rec[1] = left;   
	return rec 
}

function detailClick(e)
{
	var OnlyRead="N";
	var obj=document.getElementById("OnlyRead");
	if (obj) OnlyRead=obj.value;
	if (OnlyRead=="Y") return false;
	var Status="";
	var obj=document.getElementById("Status");
	if (obj) Status=obj.value;
	//if ((Status==2)||(Status=="")) return false;  //�Ѹ���
	
	var MainDoctor="";
	var obj=document.getElementById("MainDoctor");
	if (obj) MainDoctor=obj.value;
	if ((Status==1)&&(MainDoctor=="N")) return false; //��������ѳ���
	if ((Status==0)&&(MainDoctor=="Y")) return false; //�������δ����
	var Info=e.id;
	var InfoArr=Info.split("^");
	var OEORIRowId=InfoArr[0];
	CurID=OEORIRowId;
	var ODRowid=InfoArr[1];
	var ChartID=InfoArr[2];
	var otherDesc="";
	var EpisodeID=""
  	var obj=document.getElementById("EpisodeID");
    	if (obj){
		EpisodeID=obj.value
	}
	//if (EpisodeID=="4034840") alert(InfoArr)
	var temIns=document.getElementById("GetEDInfo");
	if(temIns){
			temIns=temIns.value;
	}
	//alert(OEORIRowId+"^"+EpisodeID+"^"+ODRowid+"^"+ChartID)
	var Info=cspRunServerMethod(temIns,OEORIRowId,EpisodeID,ODRowid,ChartID,otherDesc);
	CreateEDDIv(e,Info,ChartID);
}
function CreateEDDIv(Parentobj,Info,ChartID){
	var OnlyRead="N";
	var obj=document.getElementById("OnlyRead");
	if (obj) OnlyRead=obj.value;
	if (OnlyRead=="Y") return false;

    RemoveAllDiv(1);  
	if (Info=="") return false;
	div = document.createElement("div");   
    div.id="EDDiv";  
    div.style.position='absolute';  
    var op=getoffset(Parentobj);
	//alert(op)
    //div.style.top=op[0]+20; 
	div.style.top=30; 
	//div.style.height=500
	div.style.width=240
    //div.style.left=op[1]+20; 
	div.style.left=500; 
    div.style.zIndex =100;  
    div.style.backgroundColor='white';  
    div.style.border="1px solid #666";
    div.style.overflow="auto"  
    //div.className="td1";  
    var OneHeight=20;
	var TableHeight=0;
	
	var innerText="<TABLE border=0.5 width=220><TR height=20 align='right' bgcolor='lightblue'><TD colspan=2><button onclick='RemoveAllDiv(1)'>�ر�</button></TD></TR>"
    var Char_1=String.fromCharCode(1);
    var EDArr=Info.split(Char_1);
    var EDArrLength=EDArr.length;
	for (var i=0;i<EDArrLength;i++)
    {
    	var OneED=EDArr[i];
		TableHeight=TableHeight+OneHeight;
    	innerText=innerText+"<TR height=20 bgcolor='lightblue'><TD width=20>"+(i+1)+"</TD><TD style='cursor:hand' width=200 value='"+OneED+"^"+ChartID+"^"+Parentobj.id+"'   id='"+OneED+"^"+ChartID+"^"+Parentobj.id+"' onclick=EDDescClick(this,1)>"+OneED+"</TD>"
		/*
		i=i+1;
		if (i<EDArrLength)
		{
			var OneED=EDArr[i];
			innerText=innerText+"<TD style='cursor:hand' width=110 value='"+OneED+"^"+ChartID+"' onclick=EDDescClick(this,1)>"+OneED+"</TD>"
		}
		*/
		innerText=innerText+"</TR>"
	}
	
	if (TableHeight>500)
	{
		div.style.height=500;
	}
	//innerText=TableInfo+innerText;

    innerText=innerText+"</TABLE>"
    div.innerHTML=innerText;
    document.body.appendChild(div); 
	//rDrag.init(div);
}
////�϶�DIV
var rDrag = {
 
 o:null,
 
 init:function(o){
  o.onmousedown = this.start;
 },
 start:function(e){
  var o;
  e = rDrag.fixEvent(e);
               e.preventDefault && e.preventDefault();
               rDrag.o = o = this;
  o.x = e.clientX - rDrag.o.offsetLeft;
                o.y = e.clientY - rDrag.o.offsetTop;
  document.onmousemove = rDrag.move;
  document.onmouseup = rDrag.end;
 },
 move:function(e){
  e = rDrag.fixEvent(e);
  var oLeft,oTop;
  oLeft = e.clientX - rDrag.o.x;
  oTop = e.clientY - rDrag.o.y;
  rDrag.o.style.left = oLeft + 'px';
  rDrag.o.style.top = oTop + 'px';
 },
 end:function(e){
  e = rDrag.fixEvent(e);
  if (rDrag.o.id=="RoomRecord")
  {
	UpdateDivPosition();
  }
  rDrag.o = document.onmousemove = document.onmouseup = null;
 },
    fixEvent: function(e){
        if (!e) {
            e = window.event;
            e.target = e.srcElement;
            e.layerX = e.offsetX;
			e.layerY = e.offsetY;
			
        }
        return e;
    }
}
function EDDescClick(e,CloseODSFlag,ChartID)
{
	CloseODSDivFlag=CloseODSFlag;
	//var Desc=e.value;
	var Desc=e.id;
	var ChartID=Desc.split("^")[1];
	var OEOrdID=Desc.split("^")[2];
	var Desc=Desc.split("^")[0];
	var encmeth="";
	var obj=document.getElementById("GetEDInfoByDesc");
	if (obj) encmeth=obj.value;
	var Info=cspRunServerMethod(encmeth,ChartID,Desc,OEOrdID);
	CreateEDDetailDiv(e,Info)
}
function PreviewDirect()
{
	var viewmark=2;
	var EpisodeID=""
  	var obj=document.getElementById("EpisodeID");
    	if (obj){
		EpisodeID=obj.value
	}
	if (""==EpisodeID) { 
	    alert("��û��ѡ��ͻ�,����û�еǼ�")
	    return false;    
	}
	var flag= tkMakeServerCall("web.DHCPE.OtherPatientToHP","IsOtherPatientToHP",EpisodeID);
	if(flag=="1"){
		alert("סԺ��������Ԥ�����ﵥ");
		return false;
		}

	var PrintFlag=1;
	var PrintView=1;
	var Instring=EpisodeID+"^"+PrintFlag+"^PAADM"+"Y";	
	var Ins=document.getElementById('GetOEOrdItemBox');	
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,'','',Instring);
	Print(value,PrintFlag,viewmark);	//DHCPEIAdmItemStatusAdms.PatItemPrint
	
	return false;
}
function SendAudit()
{
	var UserID=session['LOGON.USERID'];
	var EpisodeID=""
  	var obj=document.getElementById("EpisodeID");
    if (obj){
		EpisodeID=obj.value
	}
	if (""==EpisodeID) { 
	    alert("��û��ѡ��ͻ�,����û�еǼ�")
	    return false;    
	}
	
	
	//�ж��Ƿ���û�н������Ŀ
	obj=document.getElementById("NoResultItemClass");
	if (obj) var encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,EpisodeID);
	if (ret!=""){
		var Char_1=String.fromCharCode(1);
		var NoResultArr=ret.split(Char_1);
		var NoResultDesc=NoResultArr[1];
		/*
		if (confirm("~{4fTZN4Mj3I5DOnD?~}'"+NoResultDesc+"'~{JG7q0Q8COnD?7EFz~}")){
			//~{4&@mJG7q7EFz~}
			var NoResultIDs=NoResultArr[0];
			obj=document.getElementById("RefuseItems");
			if (obj) var encmeth=obj.value;
			var ret=cspRunServerMethod(encmeth,NoResultIDs);
		}
		*/
	}
	
	var obj=document.getElementById("SendAuditClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,"",UserID,"0",EpisodeID);
	//alert("ret:"+ret)
	var Arr=ret.split("^");
	if (Arr[0]=="0"){
		try
		{
			/*if (parent.frames("baseinfo"))
			{
				parent.frames("baseinfo").websys_setfocus("RegNo");
			}*/
			if (parent.frames["baseinfo"])
			{
				parent.frames["baseinfo"].websys_setfocus("RegNo");
			}
		}catch(e){}
		return false;
	}
	if (Arr[0]=="-2")
	{
		var EnterKey=String.fromCharCode(13);
		var AlertInfo="�����Ѿ��ձ�"+EnterKey;
		if (Arr[1]!=""){
			AlertInfo=AlertInfo+"δ�����Ŀ:"+Arr[1]+EnterKey+"�Ƿ��������";
		}else{
			AlertInfo=AlertInfo+"�Ƿ��������";
		}
		if (!confirm(AlertInfo)) return false;
	}
	if (Arr[0]=="-3")
	{
		var EnterKey=String.fromCharCode(13);
		var AlertInfo="δ�����Ŀ:"+Arr[1]+EnterKey+"�Ƿ��������";
		if (!confirm(AlertInfo)) return false;
	}
	var ret=cspRunServerMethod(encmeth,"",UserID,"1",EpisodeID);
	var Arr=ret.split("^");
	if (Arr[0]!="0"){
		alert(Arr[1]);
		return false;
	}
	try
	{
		/*if (parent.frames("baseinfo"))
		{
			parent.frames("baseinfo").websys_setfocus("RegNo");
		}*/
		if (parent.frames["baseinfo"])
		{
			parent.frames["baseinfo"].websys_setfocus("RegNo");
		}

	}catch(e){};
	return false;
}
function CreateEDDetailDiv(obj,Info){  
    RemoveAllDiv(0);  
    div = document.createElement("div");   
    div.id="EDDetail";  
    div.style.position='absolute';  
    var op=getoffset(obj);  
    //div.style.top=op[0]+20; 
	div.style.top=30;
    //div.style.left=op[1];  
	div.style.left=520+220;  
    div.style.zIndex =100;  
    div.style.backgroundColor='white';  
    div.style.border="1px solid #666";  
    //div.className="td1";  
    var innerText="<TABLE border=0.5 width=300><TR align='right' bgcolor='lightblue'><TD colspan=2><button onclick='RemoveAllDiv(0)'>�ر�</button></TD></TR>"
    var Char_2=String.fromCharCode(2);
    var Char_1=String.fromCharCode(1);
    var EDArr=Info.split(Char_2);
    var EDArrLength=EDArr.length
    for (var i=0;i<EDArrLength;i++)
    {
    	var OneEDArr=EDArr[i];
    	var OneArr=OneEDArr.split(Char_1);
    	innerText=innerText+"<TR bgcolor='lightblue'><TD style='cursor:hand' value='"+OneArr[0]+"' id='EDID^"+OneArr[0]+"'  ondblclick=EDDblClick(this)>"+OneArr[1]+"</TD></TR>"
    }
    innerText=innerText+"</TABLE>"
    div.innerHTML=innerText;
    document.body.appendChild(div);  
}
function EDDblClick(e)
{
	//var EDID=e.value;
	var EDID=e.id;
	var EDID=EDID.split("^")[1];

	AddDiagnosis(EDID);	
}
function AddDiagnosis(EDID)
{
	var ID=EDID.split("^")[0];
	var SSIDObj=document.getElementById("SSID");
	if (SSIDObj) var SSID=SSIDObj.value;
	var obj=document.getElementById("AddEDClass");
	if (obj) var encmeth=obj.value;
	if (SSID=="") {alert(t["NoSS"]);return false;}
	var MainDoctor="";
	var obj=document.getElementById("MainDoctor");
	if (obj) MainDoctor=obj.value;
	var flag=cspRunServerMethod(encmeth,SSID,ID,"0",MainDoctor);
	var Arr=flag.split("^");
	if (Arr[0]==0){
		var MainDoctor="";
		var obj=document.getElementById("MainDoctor");
		if (obj) MainDoctor=obj.value;
		if (MainDoctor=="Y"){
			//���챣�潨��
			var ret=SaveAdvice("0");
			//if (!ret) return false;
		}else{
			//���潨��
			Save_click();
		}
		var obj=document.getElementById("GetAdviceByStation");
		if (obj) encmeth=obj.value;
		//GSID,CurStation,MainDoctorFlag
		var ret=cspRunServerMethod(encmeth,SSID,CurID,MainDoctor);
		var Char_1=String.fromCharCode(1);
		var Arr=ret.split(Char_1);
		var ID=Arr[0];
		var Info=Arr[1];
		var obj=document.getElementById(ID);
		if (obj) obj.innerHTML=Info;
		SetAreaTextHeight();
		return false;
	}
	alert(t[flag]);
	return false;
}
function setTareaAutoHeight(e) {
    //e.style.height = e.scrollHeight + "px";
	if (e.scrollHeight<32){
		e.style.height=32+"px";
	}else{
		e.style.height = e.scrollHeight + "px";
	}
}


function Conclusion()
{
	var SSID="";
	var SSIDObj=document.getElementById("SSID");
	if (SSIDObj) var SSID=SSIDObj.value;
	if (SSID=="") return false
	var UserID=session['LOGON.USERID'];
	var url="dhcpeconclusion.csp?GSID="+SSID+"&UserID="+UserID;
  	var wwidth=600;
	var wheight=500; 
	var xposition = ((screen.width - wwidth) / 2)-20;
	var yposition = ((screen.height - wheight) / 2)-100;
	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes'
			+',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	if (ResultWin) ResultWin.close();
	ResultWin=window.open(url,"ResultWin",nwin)
	return false;
}
function QMManager()
{
	var iEpisodeID="",obj;
	obj=document.getElementById("EpisodeID");
	if (obj) { iEpisodeID=obj.value; }
  	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEQualityManager"
   	+"&PAADM="+iEpisodeID;
  	var wwidth=600;
  	var wheight=400;
  	var xposition = (screen.width - wwidth) / 2;
  	var yposition = (screen.height - wheight) / 2;
  	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
   	+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
   	;
 	var cwin=window.open(lnk,"_blank",nwin)
 	return false;
}
/*
function ShowCheckResult()
{
	var iEpisodeID="",obj;
	obj=document.getElementById("EpisodeID");
	if (obj) { iEpisodeID=obj.value; }
  	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisclinicQueryOEItem"
   	+"&EpisodeID="+iEpisodeID;
  	var wwidth=600;
  	var wheight=400;
  	var xposition = (screen.width - wwidth) / 2;
  	var yposition = (screen.height - wheight) / 2;
  	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
   	+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
   	;
 	var cwin=window.open(lnk,"_blank",nwin)
 	return false;
}
function ShowCheckPISResult()
{
	var iEpisodeID="",obj;
	obj=document.getElementById("EpisodeID");
	if (obj) { iEpisodeID=obj.value; }
  	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPisclinicQueryOEItem"
   	+"&EpisodeID="+iEpisodeID;
  	var wwidth=600;
  	var wheight=400;
  	var xposition = (screen.width - wwidth) / 2;
  	var yposition = (screen.height - wheight) / 2;
  	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
   	+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
   	;
 	var cwin=window.open(lnk,"_blank",nwin)
 	return false;
}
*/
function ShowCheckResult()
{
	var iEpisodeID="",obj;
	obj=document.getElementById("EpisodeID");
	if (obj) { iEpisodeID=obj.value; }
	var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSendPisInterface");
	if(flag=="1"){
		//�²�Ʒ�鷽��
		 //lnk=tkMakeServerCall("web.DHCEMInterface","GetRepLinkUrl",iEpisodeID,"","E");
		  lnk=tkMakeServerCall("web.DHCAPPInterface","GetRepLinkUrl",iEpisodeID,"","E");
		}else{
		//pacs���
  		lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisclinicQueryOEItem"
   		+"&EpisodeID="+iEpisodeID;
		}
  	
  	var wwidth=1400;
  	var wheight=1200;
  	var xposition = (screen.width - wwidth) / 2;
  	var yposition = (screen.height - wheight) / 2;
  	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
   	+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
   	;
 	var cwin=window.open(lnk,"_blank",nwin)
 	return false;
}
function ShowCheckPISResult()
{
	var iEpisodeID="",obj;
	obj=document.getElementById("EpisodeID");
	if (obj) { iEpisodeID=obj.value; }
	var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSendPisInterface");
	if(flag=="1"){
		//�²�Ʒ�鷽��
		 //lnk=tkMakeServerCall("web.DHCEMInterface","GetRepLinkUrl",iEpisodeID,"","P");
		   lnk=tkMakeServerCall("web.DHCAPPInterface","GetRepLinkUrl",iEpisodeID,"","P");
		}else{
		//�������
  		lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPisclinicQueryOEItem"
   		+"&EpisodeID="+iEpisodeID;
		}
  	var wwidth=1400;
  	var wheight=1200;
  	var xposition = (screen.width - wwidth) / 2;
  	var yposition = (screen.height - wheight) / 2;
  	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
   	+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
   	;
 	var cwin=window.open(lnk,"_blank",nwin)
 	return false;
}


