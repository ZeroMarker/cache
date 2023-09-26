//DHCOPTepChange.js
document.body.onload = BodyLoadHandler;

var mDoctorId="";
var mDepRowId="";
var mReasonRowId="";
var SelectedRow=0;
function BodyLoadHandler(){
	var obj=document.getElementById("Stop");
	if(obj)obj.onclick=Stop_Click;
	var obj=document.getElementById("Update");
	if(obj)obj.onclick=Update_Click;
	
	var Loc=DHCC_GetElementData('Loc');
	if (document.getElementById('Loc')){
			var DepStr=DHCC_GetElementData('DepStr');
			combo_ERepLoc=dhtmlXComboFromStr("Loc",DepStr);
			combo_ERepLoc.enableFilteringMode(true);
			combo_ERepLoc.selectHandle=combo_ERepLocKeydownhandler;
			
			combo_ERepLoc.setComboText(Loc);
		}
	if (document.getElementById('Doc')){
			combo_ERepDoctor=dhtmlXComboFromStr("Doc",'');
			combo_ERepDoctor.enableFilteringMode(true);
			combo_ERepDoctor.selectHandle=combo_ERepDoctorKeydownhandler;
		}
	if (document.getElementById('Reason')){
			var ReasonStr=DHCC_GetElementData('ReasonStr');
			combo_EStopReason=dhtmlXComboFromStr("Reason",ReasonStr);
			combo_EStopReason.enableFilteringMode(true);
			combo_EStopReason.selectHandle=combo_EStopReasonKeydownhandler;
		}		
}
function SetRepDocDetail(DepRowId,DocRowId){
	if ((DocRowId=="")||(DepRowId=="")){
		return;
	}
	var encmeth=DHCC_GetElementData('GetResDocDetailMethod');
	if (encmeth!=''){
		var retDetail=cspRunServerMethod(encmeth,DepRowId,DocRowId);
		var Arr=retDetail.split('^');
		var ResClinicGroupRowId=Arr[0];
		var ResSessionTypeRowId=Arr[1];
		if (ResSessionTypeRowId!=""){
			combo_ERepSessionType.setComboValue(ResSessionTypeRowId);
		}else{
			combo_ERepSessionType.setComboText('');
		}
	}	
}
function combo_ERepDoctorKeydownhandler(e){
	var DepRowId=DHCC_GetElementData('DepId')
	var DocRowId=DHCC_GetComboValue(combo_ERepDoctor);
	mDoctorId=DocRowId;
	SetRepDocDetail(DepRowId,DocRowId);
	websys_nexttab(combo_ERepDoctor.tabIndex);
	
}

function combo_ERepLocKeydownhandler(e){
	var DepRowId=combo_ERepLoc.getActualValue();
	mDepRowId=DepRowId
	DHCC_SetElementData('DepId',DepRowId);
	if (combo_ERepDoctor){
		combo_ERepDoctor.clearAll();
		combo_ERepDoctor.setComboText("");
		var encmeth=DHCC_GetElementData('GetResDocEncrypt');
		if ((encmeth!="")&&(DepRowId!="")){
			combo_ERepDoctor.addOption('');
			var DocStr=cspRunServerMethod(encmeth,DepRowId,"","","",1);
			if (DocStr!=""){
				var Arr=DHCC_StrToArray(DocStr);
				combo_ERepDoctor.addOption(Arr);
			}
		}
	}	
	websys_nexttab(combo_ERepLoc.tabIndex);
}

function combo_EStopReasonKeydownhandler(e){
	var ReasonRowId=combo_EStopReason.getActualValue();      //by shp  20120507
	mReasonRowId=ReasonRowId
	websys_nexttab(combo_EStopReason.tabIndex);
}

function Stop_Click()
{
  var StartDate=DHCC_GetElementData('StartDate');
  var EndDate=DHCC_GetElementData('EndDate');
  var Loc=DHCC_GetElementData('Loc');
  var Doc=DHCC_GetElementData('Doc');  

  if(StartDate==""){alert("��ʼ���ڲ���Ϊ��!");
  return;
  }
  if(EndDate==""){alert("�������ڲ���Ϊ��!");
  return;
  }
  if(Loc==""){alert("���Ҳ���Ϊ��!");
  return;
  }
  if(Doc==""){alert("ҽ������Ϊ��!");
  return;
  }
  var ComDateFlag=CompareDate(StartDate,EndDate)
  if (!ComDateFlag){
	  alert("��ѡ����Ч������ʱ��!")
	  return;
  }
  
  //�ж��Ƿ��������Ű��ԤԼ��¼
  var encmethCheck=DHCC_GetElementData('CheckResData');
  if(encmethCheck!=""){
	var retValue=cspRunServerMethod(encmethCheck,StartDate,EndDate,mDepRowId,mDoctorId);
	var StrArr=retValue.split("^");
	if((StrArr[0]=="-200")&&(StrArr[1]=="")){
		var rtn=confirm("��ҽ���ڴ˷�Χ���Ű��¼?");
		if (!rtn){return}
	}
	else if((StrArr[0]=="")&&(StrArr[1]=="-201")){
		var rtn=confirm("��ҽ���Ѿ���ԤԼ��¼?");
		if (!rtn){return}
	}
	else if((StrArr[0]=="-200")&&(StrArr[1]=="-201")){
		var rtn=confirm("��ҽ���ڴ˷�Χ���Ű��¼,�����Ѿ���ԤԼ��¼?");
		if (!rtn){return}
	}
	else{}
  }
  var Reason=DHCC_GetElementData('Reason');
  var Notes=DHCC_GetElementData('Notes');
  var UserID=session['LOGON.USERID'];   
  var encmeth=DHCC_GetElementData('StopEncrypt');
  if(encmeth!="")
  {
      var ret=cspRunServerMethod(encmeth,StartDate,EndDate,mDepRowId,mDoctorId,mReasonRowId,Notes,UserID,"S");
      if(ret=="0")alert("�����ɹ�!");
      else if(ret=="-202")alert("�����ʧ��!");
      else if(ret=="Repeat")alert("�ü�¼�Ѵ��ڻ�������ڲ�������Ч���Ű��¼!");
      else alert("����ʧ��!");
      
  }
  var ref="websys.default.csp?WEBSYS.TCOMPONENT=DHCBatchStop";
  location.href=ref;	
}
function Update_Click()
{
	var StartDate=DHCC_GetElementData('StartDate');
    var EndDate=DHCC_GetElementData('EndDate');
    if(SelectedRow==0){
	    alert("��ѡ����!");
	    return;
	    }
    var NARowId=DHCC_GetColumnData("NARowid",SelectedRow)
 
    var UserID=session['LOGON.USERID'];
    var encmeth=DHCC_GetElementData('UpdateEncrypt');
    if(encmeth!="")
    {
	  var NAFlag=DHCC_GetColumnData("NAFlag",SelectedRow)
      if (NAFlag=="N"){alert("�ü�¼�Ѿ�Ϊ����״̬���賷��!");return}
	  var ret=cspRunServerMethod(encmeth,NARowId,UserID,"N");
      if(ret=="0")alert("�����ɹ�!");
      else if(ret=="-203")alert("��ѡ����!");
      else if(ret=="Repeat")alert("�ü�¼�Ѵ��ڳ���״̬��¼,�����ٳ���!");
      else alert("����ʧ��!");
	}
	var ref="websys.default.csp?WEBSYS.TCOMPONENT=DHCBatchStop";
    location.href=ref;
}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCBatchStop');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	if (selectrow!=SelectedRow){
		SelectedRow = selectrow;
	}else{
		SelectedRow=0
	}
}
function Clear_Click()
{
	DHCC_SetElementData("ERepLoc","")
	DHCC_SetElementData("ERepSessionType","")
	DHCC_SetElementData("ETimeRange","")
	DHCC_SetElementData("NewAdmDoc","")	
	DHCC_SetElementData("OldAdmDoc","")	

}