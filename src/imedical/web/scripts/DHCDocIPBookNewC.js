var DateFormat=tkMakeServerCall("websys.Conversions","DateFormat")
var PatPhoneFlag=""
var LocWardCheckBox="LocWard^LinkWard^AllWard"
document.body.onbeforeunload = DocumentUnloadHandler;
$(function(){
	//��ʼ������Tableģ��
	LoadDataTable();	
});
function BodyLoadHandler(){
	//��ʼ��Comb���
	CombListCreat()
	
	//ԤԼ���ڸ�ʽ
	$('#InSdate').datebox('setValue',NowDate);
	//���ѡ��
	$('#AdmDiadesc').keydown(LookupDiaDesc);
	//���ͼ��ѡ��
	$('#imgAdmDiadesc').click(LookDia);
	//ȥ�����
	$('#DelDiangose').click(DelDiangose);
	//����סԺ֤
	$('#Save').click(SaveCon);
	//סԺ֤��ӡ
	$('#Print').click(Print);
	//�ռ���������
	$('#OpertionLink').click(OpenOpertionClick);
	
	//סԺ֤��ѯ
	$('#OrderListFind').click(OrderListFind);
	//�����б��ѯ
	$('#AdmListFind').click(AdmListFind);
	//סԺ֤���沢��ӡ
	$('#SaPrint').click(SaPrint);
	//�����л�
	$('#CreatNew').click(CreatNew);
	//ҽ��¼��
	$('#OrderLink').click(OrderLinkClick);
	//��ϵ�绰�޸�
	$('#PatPhone').blur(PatPhoneOnblur);
	//������Ժ��
	$('#LocWard').click(WardClick);
	//����������
	$('#LinkWard').click(WardClick);
	//����������
	$('#AllWard').click(WardClick);
	
	//��ʼ����ѯ
	//��ʼ��������Ϣ	
	IntPaMes();
	//��ʼ��������Ϣ
	IntAmdMes();
	//��ʼ��סԺ֤��Ϣ
	IntBookMes();
	
	PatPhoneFlag=DHCC_GetElementData('PatPhone')
	
	window.setTimeout("Find()",10);

	
}
function OpenOpertionClick()
{
		OpenOpertion("Handel")
}

function PatPhoneOnblur()
{
	var PatPhone=DHCC_GetElementData("PatPhone");
	if(PatPhone!=PatPhoneFlag){
		if (PatPhone=="")
		{
			alert("��ϵ�绰����Ϊ��");
			websys_setfocus(PatPhone);
			return false;
		}
		if (PatPhone.indexOf('-')>=0){
			var Phone=PatPhone.split("-")[0]
			var Phonearr=PatPhone.split("-")[1]
			if(Phone.length==3){
				if(Phonearr.length!=8){
				alert("�̶��绰���ȴ���,�̶��绰���ų���Ϊ��3����4��λ,�̶��绰���볤��Ϊ��7����8��λ,�������ӷ���-������,���ʵ!")
				websys_setfocus(PatPhone);
	        	return false;
				}
			}else if(Phone.length==4){
				if(Phonearr.length!=7){
				alert("�̶��绰���ȴ���,�̶��绰���ų���Ϊ��3����4��λ,�̶��绰���볤��Ϊ��7����8��λ,�������ӷ���-������,���ʵ!")
				websys_setfocus(PatPhone);
	        	return false;
				}
			}else{
				alert("�����ڹ̶��绰,���ʵ!")
				websys_setfocus(PatPhone);
	        	return false;
			}
			
		}else{
			if(PatPhone.length!=11){
				alert("��ϵ�绰�绰����ӦΪ��11��λ,���ʵ!")
				websys_setfocus(PatPhone);
	        	return false;
			}
		}
	}
	
}
function Find()
{
	OrderListFind()
	AdmListFind()
	
}
///¼��Ժǰҽ��
function OrderLinkClick()
{
	if (BookIDMain==""){
		alert("ȱ��ԤԼ��Ϣ")
		return false
	}
	var url=tkMakeServerCall("web.DHCDocIPBookNew","GetOrderLink",BookIDMain)
	if (url==""){
		alert("��ԤסԺ״̬���ܿ�ҽ��")
		return false
	}
	if(typeof websys_writeMWToken=='function') url=websys_writeMWToken(url);
	var winName="IPBookOrderWrite"; 
	var awidth=screen.availWidth/6*5; 
	var aheight=screen.availHeight/5*4; 
	var atop=(screen.availHeight - aheight)/2;
	var aleft=(screen.availWidth - awidth)/2;
	var param0="scrollbars=0,status=0,menubar=0,resizable=2,location=0"; 
	var params="top=" + atop + ",left=" + aleft + ",width=" + awidth + ",height=" + aheight + "," + param0 ;
	win=window.open(url,winName,params); 
	win.focus(); 	
}

///�л�����
function CreatNew()
{
	var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCExamPatList"
	if(typeof websys_writeMWToken=='function') url=websys_writeMWToken(url);
	var winName="BookCreat"; 
	var awidth=screen.availWidth; 
	var aheight=screen.availHeight; 
	var atop=(screen.availHeight - aheight);
	var aleft=(screen.availWidth - awidth);
	var param0="scrollbars=0,status=0,menubar=0,resizable=2,location=0"; 
	var params="top=" + atop + ",left=" + aleft + ",width=" + awidth + ",height=" + aheight + "," + param0 ;
	win=window.open(url,winName,params); 
	win.focus(); 	
}

//�л����߻ص�����
function ChangePerson(PAAdmNew){
	
	if (PAAdmNew!=""){
		ClearAll()
		EpisodeID=PAAdmNew
		BookIDMain=""
		//��ʼ��������Ϣ
		IntPaMes();
		//��ʼ��������Ϣ
		IntAmdMes();
		//��ʼ��סԺ֤��Ϣ
		IntBookMes();
		//��ʼ����ѯ
		OrderListFind()
		AdmListFind()
	}
	
	
}
function SaPrint(){
	if (Save()){
		Print()
	}
}

function Print()
{
	
	var MyPara=""
	var PDlime=String.fromCharCode(2);
	if (BookIDMain==""){
		$.messager.alert('����','ȱ��ԤԼ��Ϣ,');
		return 
	}
	var encmeth=DHCC_GetElementData('GetPatBookMes')
	var BookMesag= cspRunServerMethod(encmeth,BookIDMain);
	if (BookMesag==""){
		$.messager.alert('����','ȱ��ԤԼ��Ϣ,');
		return 
	}
	var BookMesagArry=BookMesag.split("^")
	var PatID=BookMesagArry[1]
	var encmeth=DHCC_GetElementData('GetPatDetail')
	var PatMes= cspRunServerMethod(encmeth,PatID);
	var PatMesArry=PatMes.split("^")
	
	//����סԺ֤��ʼ�������Ϣ
	var DiagnoseStr=BookMesagArry[36] ;
	var DiagnoseStrArry=DiagnoseStr.split(String.fromCharCode(2))
	var Legnt1=DiagnoseStrArry.length
	var DiaS=""
	for (var i=0;i<Legnt1;i++){
		var Desc=DiagnoseStrArry[i].split(String.fromCharCode(1))[0]
		var ID=DiagnoseStrArry[i].split(String.fromCharCode(1))[1]
		if ((ID=="")&&(Desc=="")){continue}
		if (DiaS==""){DiaS=Desc}
		else{DiaS=DiaS+","+Desc}
	
	}
	
	//���� �Ա� ���� �ǼǺ� ����λ ������λ סַ ��ϵ�绰 ��ϵ�� ��ϵ ��ϵ�˵绰 ���
	//סԺ���� סԺ���������ã� ����ҽԺ�����ã� �����û����� �������� ԤԼ����
	MyPara=MyPara+"PatName"+PDlime+PatMesArry[2]+"^"+"PatSex"+PDlime+PatMesArry[3]+"^"+"PatAge"+PDlime+PatMesArry[5];
	MyPara=MyPara+"^"+"PatRegNo"+PDlime+PatMesArry[1]+"^"+"PatStat"+PDlime+PatMesArry[19];
	MyPara=MyPara+"^"+"PatCom"+PDlime+PatMesArry[15]+"^"+"PatAdd"+PDlime+PatMesArry[17];
	MyPara=MyPara+"^"+"PatTel"+PDlime+PatMesArry[13];
	MyPara=MyPara+"^"+"PatContact"+PDlime+PatMesArry[20]+"^"+"PatRelation"+PDlime+PatMesArry[22];
	MyPara=MyPara+"^"+"PatReTel"+PDlime+PatMesArry[21]+"^"+"PatMR"+PDlime+DiaS;
	
	MyPara=MyPara+"^"+"PatInDep"+PDlime+BookMesagArry[30]+"^"+"PatInDays"+PDlime+"";
	MyPara=MyPara+"^"+"PatFirHos"+PDlime+""+"^"+"PatUserCode"+PDlime+session['LOGON.USERNAME'];
	MyPara=MyPara+"^"+"PatDocSign"+PDlime+"________"+"^"+"CreatDate"+PDlime+BookMesagArry[4];
	MyPara=MyPara+"^"+"BookDate"+PDlime+BookMesagArry[10];
	
	MyPara=MyPara+"^"+"Price"+PDlime+BookMesagArry[17];
	MyPara=MyPara+"^"+"StateIDDesc"+PDlime+BookMesagArry[25]; 
	MyPara=MyPara+"^"+"CreatUserDesc"+PDlime+BookMesagArry[26]; 
	MyPara=MyPara+"^"+"CreatDocIDDesc"+PDlime+BookMesagArry[27]; 
	MyPara=MyPara+"^"+"WardIdDesc"+PDlime+BookMesagArry[28]; 
	MyPara=MyPara+"^"+"BedDesc"+PDlime+BookMesagArry[29]; 
	MyPara=MyPara+"^"+"ICDDesc"+PDlime+BookMesagArry[31]; 
	MyPara=MyPara+"^"+"AdmInitStateDesc"+PDlime+BookMesagArry[32]; 
	MyPara=MyPara+"^"+"InReasnDesc"+PDlime+BookMesagArry[33]; 
	MyPara=MyPara+"^"+"InSourceDesc"+PDlime+BookMesagArry[34]; 
	MyPara=MyPara+"^"+"InBedTypeDesc"+PDlime+BookMesagArry[35]; 
	MyPara=MyPara+"^"+"ICDListStr"+PDlime+BookMesagArry[36]; 
	MyPara=MyPara+"^"+"UpdateUserDesc"+PDlime+BookMesagArry[37]; 
	MyPara=MyPara+"^"+"UpdateDate"+PDlime+BookMesagArry[38]; 
	MyPara=MyPara+"^"+"UpdateTime"+PDlime+BookMesagArry[39];
	MyPara=MyPara+"^"+"PatitnLevel"+PDlime+BookMesagArry[40]; 
	MyPara=MyPara+"^"+"CTLocMedUnit"+PDlime+BookMesagArry[41]; 
	MyPara=MyPara+"^"+"InDoctorDR"+PDlime+BookMesagArry[42]; 
	MyPara=MyPara+"^"+"TreatedPrinciple"+PDlime+BookMesagArry[43]; 
	MyPara=MyPara+"^"+"IPBookingNo"+PDlime+BookMesagArry[44]; 
	MyPara=MyPara+"^"+"PatitnLevelDesc"+PDlime+BookMesagArry[45]; 
	MyPara=MyPara+"^"+"CTLocMedUnitDesc"+PDlime+BookMesagArry[46]; 
	MyPara=MyPara+"^"+"InDoctorDesc"+PDlime+BookMesagArry[47]; 
	MyPara=MyPara+"^"+"TreatedPrincipleDesc"+PDlime+BookMesagArry[48]; 
	MyPara=MyPara+"^"+"HospDesc"+PDlime+BookMesagArry[49]; 
	MyPara=MyPara+"^"+"PatDate"+PDlime+BookMesagArry[50]; 
	
	var myobj=document.getElementById("ClsBillPrint");
	PrintFun(myobj,MyPara,"");
}

//��ѯ�����¼
function AdmListFind(){
	if (IPBKFlag=="Booking"){
		var AdmDateF=$('#AdmDateF').combobox('getValue') //ԤԼ����
		var AdmDateN=$('#AdmDateN').combobox('getValue') //ԤԼ����
		var queryParams = new Object();
		queryParams.ClassName ='web.DHCDocIPBookNew';
		queryParams.QueryName ='FindAdmList';
		queryParams.Arg1 =PatientID;
		queryParams.Arg2 =AdmDateF;
		queryParams.Arg3 =AdmDateN;
		queryParams.ArgCnt =3;
		var opts = AdmDataGrid.datagrid("options");
		opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
		AdmDataGrid.datagrid('load', queryParams);
		AdmDataGrid.datagrid('unselectAll');
	}
	
}

///��ѯסԺ֤�б�
function OrderListFind()
{
	if (IPBKFlag=="Booking"){
		var FindBookDateF=$('#FindBookDateF').combobox('getValue') //ԤԼ����
		var FindBookDateN=$('#FindBookDateN').combobox('getValue') //ԤԼ����
		var queryParams = new Object();
		queryParams.ClassName ='web.DHCDocIPBookNew';
		queryParams.QueryName ='FindBookList';
		queryParams.Arg1 =PatientID;
		queryParams.Arg2 =FindBookDateF;
		queryParams.Arg3 =FindBookDateN;
		queryParams.ArgCnt =3;
		var opts = BookListDataGrid.datagrid("options");
		opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
		BookListDataGrid.datagrid('load', queryParams);
		BookListDataGrid.datagrid('unselectAll');
		//console.log(PatientID+","+FindBookDateF+","+FindBookDateN)
	}
	
}

function SaveCon()
{
	var DoFlag="Y"
	if (BookIDMain!=""){
		var InCurStatu=$('#InCurStatu').combobox('getValue'); //סԺ֤״̬
		var encmeth=DHCC_GetElementData('GetPatBookMes')
		var BookMesag= cspRunServerMethod(encmeth,BookIDMain);
		if (BookMesag!=""){
			var BookMesagArry=BookMesag.split("^")
			var diastr=tkMakeServerCall("web.DHCDocIPBookNew","GetDHCDocIPBDictory",InCurStatu)
			var diastrArry=diastr.split("^")
			if ((BookMesagArry[8]!=InCurStatu)&&(("Register^SignBed").indexOf(BookMesagArry[53])>=0))
			{
				DoFlag="N"
				$.messager.confirm("ȷ��","��ǰסԺ֤״̬Ϊ��"+BookMesagArry[25]+"��,��Ҫ����Ϊ��"+diastrArry[1]+"��,�Ƿ�������棿",function(r){
					if (r){
						Save()
					}
				})
				
			}
		}
	}
	if (DoFlag=="Y"){
		Save()
	}
}


//����סԺ֤
function Save()
{
	if (CanSave!="Y"){
		return
	}
	
	//����ǰ�Ծ������-Ŀǰ�������סԺ֤ ����-2���ж�
	var Rtn=tkMakeServerCall("web.DHCDocIPBookNew","CheckBeforeSave",EpisodeID,BookIDMain,"1")
	if (Rtn!=0){
			var RtnArry=Rtn.split("^")
			if (RtnArry[0]=="-1"){
				$.messager.alert('����',RtnArry[1]);
				return false
			}
	}
	
	var BookID=BookIDMain; //סԺ֤ID
	var PatID=PatientID; //����ID
	var PAAdmOP=EpisodeID; //����ID ����
	var PAAdmIP=EpisodeIDIP; //����סԺID
	var CreateDate="" //��������
	var CreateTime="" //����ʱ��
	var CreaterUser=session['LOGON.USERID']
	var CreaterDocIDUser=session['LOGON.USERID']
	var InCurStatu=$('#InCurStatu').combobox('getValue'); //סԺ֤״̬
	var BookActive="Y" //סԺ֤��Ч״̬
	var InSdate=$('#InSdate').combobox('getValue') //ԤԼ����
	var InWard=$('#InWard').combobox('getValue') //����
	var InBed="" //$('#InBed').combobox('getValue') //��λ
	var InCtloc=$('#InCtloc').combobox('getValue') //����
	var ICDList=GetAllDia() //�������ICD
	var InResumeText=$("#InResumeText").val().replace(/(^\s*)|(\s*$)/g,''); //��ע
	var IPDeposit=$("#IPDeposit").val().replace(/(^\s*)|(\s*$)/g,''); //סԺѺ��
	var AdmInitState=$("#AdmInitState").combobox('getValue'); //��Ժ����
	var InReason=$("#InReason").combobox('getValue'); //����ԭ��
	var InSorce=$("#InSorce").combobox('getValue'); //��Ժ;��
	var InBedType=$("#InBedType").combobox('getValue'); //���鴲λ����
	var MRCCondtion="" //�����������عأ�-�°治��
	var ICDCode="" //ICD���-�°治��
	var CTLocMedUnit=$("#CTLocMedUnit").combobox('getValue') //ҽ�Ƶ�Ԫ
	var InDoctor=$("#InDoctor").combobox('getValue') //����ҽʦ
	var PatientLevel=$("#PatientLevel").combobox('getValue') //���ߵȼ�
	var TreatedPrinciple=$("#TreatedPrinciple").combobox('getValue') //����ԭ��
	var IsDayFlag="";
	var LocLogOn=session['LOGON.CTLOCID'];
	if($('#IsDayFlag').is(':checked')) {
	    IsDayFlag="Y";
	}
	var IsOutTriage="";
	if($('#IsOutTriage').is(':checked')) {
	    IsOutTriage="Y";
	}
	
	//-----------
	var Flag=$("#InCurStatu").combobox('getValue');
	if ((IPBKFlag!="Booking")){
		//��ԤԼȨ���û� BookID����Ϊ��ֻ�ܱ���
		if (BookID==""){
			$.messager.alert('����','סԺ֤�����������ڲ�����������.');   
			return false
		}
	}
	
	
	//����ѡ������
	var WardFlag=WardSelectFind()
	
	//�ɲ�����״̬
	var CanDoStatu=GetCanDoBookCode()
	
	//��֯��Ϣ
	var Instr=BookID+"^"+PatID+"^"+PAAdmOP+"^"+PAAdmIP+"^"+CreateDate+"^"+CreateTime+"^"+CreaterUser+"^"+CreaterDocIDUser
	var Instr=Instr+"^"+InCurStatu+"^"+BookActive+"^"+InSdate+"^"+InWard+"^"+InBed+"^"+InCtloc
	var Instr=Instr+"^"+ICDCode+"^"+InResumeText+"^"+""+"^"+IPDeposit+"^"+MRCCondtion
	//----------�°�����
	var Instr=Instr+"^"+AdmInitState+"^"+InReason+"^"+InSorce+"^"+InBedType+"^"+ICDList
	var Instr=Instr+"^"+CTLocMedUnit+"^"+InDoctor+"^"+PatientLevel+"^"+TreatedPrinciple
	var Instr=Instr+"^"+IsDayFlag+"^"+IsOutTriage+"^"+WardFlag+"^"+LocLogOn
	
	
	//����ǰ�Ե������
	var Rtn=tkMakeServerCall("web.DHCDocIPBookNew","CheckBeforeSave",PAAdmOP,BookID,"2",Instr,CanDoStatu)
	if (Rtn!=0){
			var RtnArry=Rtn.split("^")
			if (RtnArry[0]=="-1"){
				$.messager.alert('����',RtnArry[1]);
				return false
			}
	}
	
	//����
	var encmeth=DHCC_GetElementData('UpdateBook')
	var rtn=cspRunServerMethod(encmeth,Instr);
	if ((rtn=="-100")&&(rtn<0)){
		 $.messager.alert('����','סԺ֤����ʧ��',rtn);
		 return false;
	}else{
		 BookIDMain=rtn
		 var encmeth=DHCC_GetElementData('GetPatBookMes')
		 var BookMesag= cspRunServerMethod(encmeth,BookIDMain);
		 var Statu=BookMesag.split("^")[25]
		 if ((Statu=="����")&&(IPBKFlag=="Booking")){
			 BookIDMain=""
			 ClearBookMes()
		 }
		 $.messager.alert('��ʾ','�ɹ�!'); 
		 var PatPhone=DHCC_GetElementData('PatPhone')
		 if(PatPhone!=PatPhoneFlag){
			var Rtn=tkMakeServerCall("web.DHCDocIPBookNew","SetPatPhoneByPatID",PatientID,PatPhone)
			if(Rtn!=0){
				alert("��ϵ�绰�޸�ʧ��")
			}
		}
		   
	}
	//��ѯ
	OrderListFind()
	AdmListFind()
	
	//������Զ���
	OpenOpertion("Auto")
	return true;
	
}

function GetAllDia(){
	//��ȡ���м����ڽ�����ѡ�е����ICD
	var Str=""
	var ObjInputs=document.getElementsByName("ICDList")
    for(var i=0;i<ObjInputs.length;i++){
        var inputObj=ObjInputs[i];
        if ((inputObj)&&(inputObj.checked)){
	       var Desc=inputObj.getAttribute("DescICD")
	       var ICD=inputObj.id; //+String.fromCharCode(2)+Desc
	       if (ICD==""){
		       ICD=""+String.fromCharCode(2)+Desc;
		   }else{
			   ICD=ICD+String.fromCharCode(2)+"";
		   }
	       if (Str==""){Str=ICD}
	       else{Str=Str+"!"+ICD}
	    } 
    }
    return Str
}

function CombListCreat(){
	//����
	AdmInitStateCombCreat()
	//��ǰ״̬
	InCurStatuCombCreat()
	//����ԭ��
	InReasonCombCreat()
	//��Ժ;��
	InSorceCombCreat()
	//סԺ����
	InCtlocCombCreat()
	//���鴲λ���� 
	InBedTypeCombCreat()
	//add by xz ���˵ȼ�
	PatientLevelCreat()
	//add by xz ����ԭ��
	TreatedPrincipleCreat()
	
	
}

//ȥ��δѡ�е����
function DelDiangose()
{
	//ȥ���б���δѡ�е����
	var ObjInputs=document.getElementsByName("ICDList")
	var Str=""
    for(var i=0;i<ObjInputs.length;i++){
        var inputObj=ObjInputs[i];
        if ((inputObj)&&(inputObj.checked)){
	       var Desc=inputObj.getAttribute("DescICD")
	       var ICD=inputObj.id;
	       if (Str==""){Str=Desc+"^"+ICD}
	       else{Str=Str+"!"+Desc+"^"+ICD}
	    } 
    }
    if (Str==""){
	    $.messager.alert('����','��ע������ǰ�ٴ���ϱ����Ϊ��,�뼰ʱѡ��');   
	}
    //���¸�ֵ
	DianosListICD=Str
	IntDianosList()
	
}

///���---�Ŵ�ѡ���¼�
function LookupDiaDesc(e){
try{
	var obj=websys_getSrcElement(e);
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		LookDia()
	}
   }catch(e){}

}

function LookDia(){
	//ʹ�����¼��ͳһ�ӿ�
	var DiaType="0"
	var Desc=$("#AdmDiadesc").val().replace(/(^\s*)|(\s*$)/g,'')
	var Obj=document.getElementById("DiaType");
	if ((Obj)&&(Obj.checked)){
		DiaType="1"
	}
	var url='websys.lookup.csp';
	url += "?ID=MRDiagnos";
	url += "&CONTEXT=Kweb.DHCMRDiagnos:LookUpWithAlias";
	url += "&TLUJSF=DiaSelect";
	url += "&P1=" +Desc;
	url += "&P5=" +DiaType;
	websys_lu(url,1,'');
	return websys_cancel();	
}

//�Ŵ�ѡ�����֮����
function DiaSelect(inStr)
{
	if (inStr!=""){
		var StrArry=inStr.split("^")
		var Desc=StrArry[0]
		var ID=StrArry[1]
		if (DianosListICD==""){DianosListICD=Desc+"^"+ID}
		else{DianosListICD=DianosListICD+"!"+Desc+"^"+ID}
		//ѡ��֮��ֱ�Ӵ������б�	
		IntDianosList()
	}
	DHCC_SetElementData("AdmDiadesc","")
	websys_setfocus("AdmDiadesc");
	
}

//סԺ����Comb
function InCtlocCombCreat()
{
	$('#InCtloc').combobox({      
    	valueField:'CombValue',   
    	textField:'CombDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'web.DHCDocIPBookNew';
			param.QueryName = 'CombListFind'
			param.Arg1="InCtloc"
			param.Arg2=session['LOGON.CTLOCID']
			param.Arg3=""
			param.Arg4=""
			param.ArgCnt =4;
		},
		onSelect: function(rec){
		   if ((rec)&&(rec.CombDesc.indexOf("-")>=0)&&(rec.CombDesc.split("-")[1]!="")) {
			   $('#InCtloc').combobox('setText', rec.CombDesc.split("-")[1]);
		   }
		   
		  diaplayWardCheck(rec.CombValue)
		   //$('#InCtloc').combobox('setValue',rec.CombValue);
		  //ѡ��סԺ���Һ��ʼ������
          InWardCombCreat()
          //add by xz  ѡ��סԺ���Һ��ʼ��ҽ�Ƶ�Ԫ
          CTLocMedUnitCreat()
          //add by xz ѡ��סԺ���Һ��ʼ��סԺҽʦ
          InDoctorCreat()
        },
        onHidePanel:function(){
	       /*window.setTimeout(function (){
		       var CombDesc=$('#InCtloc').combobox('getText')
		       if ((CombDesc.indexOf("-"))&&(CombDesc.split("-")[1]!="")){
			       $('#InCtloc').combobox('setText', CombDesc.split("-")[1]);
		       }
	       },0)*/
	    },
		onChange:function(newValue,oldValue){
			if (newValue==""){
				$('#CTLocMedUnit').combobox('loadData', {});
				$('#CTLocMedUnit').combobox('setText', "");
				$('#CTLocMedUnit').combobox('setValue', "");

				$('#InDoctor').combobox('loadData', {});
				$('#InDoctor').combobox('setText', "");
				$('#InDoctor').combobox('setValue', "");
				
				$('#InWard').combobox('loadData', {});
				$('#InWard').combobox('setText', "");
				$('#InWard').combobox('setValue', "");
				
				
			}else if (newValue!=oldValue){
				 //ѡ��סԺ���Һ��ʼ������
				InWardCombCreat()
				//add by xz  ѡ��סԺ���Һ��ʼ��ҽ�Ƶ�Ԫ
				CTLocMedUnitCreat()
				//add by xz ѡ��סԺ���Һ��ʼ��סԺҽʦ
				InDoctorCreat()
				
				InBedCombCreat()
			}
		},filter: function(q, row){
			var opts = $(this).combobox('options');
			return row[opts.textField].indexOf(q.toUpperCase()) >= 0;
	    }

	});	
}

//����Comb��ʼ��
function InWardCombCreat()
{
	
	var WardFlag=WardSelectFind()
	var Ctloc=$('#InCtloc').combobox('getValue');	
	$('#InWard').combobox({      
    	valueField:'CombValue',   
    	textField:'CombDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'web.DHCDocIPBookNew';
						param.QueryName = 'CombListFind'
						param.Arg1="InWard"
						param.Arg2=Ctloc
						param.Arg3="" //Ĭ������
						param.Arg4=WardFlag
						param.ArgCnt =4;
		},
	  onLoadSuccess: function (data) {
	       //�����������֮����ض�Ӧ�Ĵ�λ��Ϣ
	       InBedCombCreat()
	      //ѡ���� Ԥ��Ժ�����Զ��ı�״̬��Ԥ��Ժ
	     var InWard=$('#InWard').combobox('getValue')
	    
	      //����ѡ�����ı�סԺ֤״̬
		 ChangeStatuByWard(InWard)
	       

        },
      onSelect: function(rec){
	    
	    //����ѡ�����ı�סԺ֤״̬
		ChangeStatuByWard(rec.CombValue)
			         
		 //ѡ��סԺ���Һ��ʼ����λ
         InBedCombCreat()
        },filter: function(q, row){
			var opts = $(this).combobox('options');
			return row[opts.textField].indexOf(q.toUpperCase()) >= 0;
	    }
	});	
}
///add by xz ҽ�Ƶ�Ԫ��ʼ��
function CTLocMedUnitCreat()
{
	//return false
	var Ctloc=$('#InCtloc').combobox('getValue');
	$('#CTLocMedUnit').combobox({      
    	valueField:'CombValue',   
    	textField:'CombDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'web.DHCDocIPBookNew';
						param.QueryName = 'CombListFind'
						param.Arg1="CTLocMedUnit"
						param.Arg2=Ctloc
						param.Arg3="" //Ĭ������
						param.Arg4=""
						param.ArgCnt =4;
		},
	  onLoadSuccess: function (data) {
	       

        },
      onSelect: function(rec){
		  //ѡ��ҽ�Ƶ�Ԫ���ʼ��סԺҽʦ
          InDoctorCreat()
        },
	 onChange:function(newValue,oldValue){
		if (newValue==""){
			$('#InDoctor').combobox('loadData', {});
			$('#InDoctor').combobox('setText', "");
			$('#InDoctor').combobox('setValue', "");
			InDoctorCreat()
		}
		}
	});	
	}
///add by xz  סԺҽʦ��ʼ��
function InDoctorCreat()
{
	var Ctloc=$('#InCtloc').combobox('getValue');
	var CTLocMedUnit=$('#CTLocMedUnit').combobox('getValue');
	$('#InDoctor').combobox({      
    	valueField:'CombValue',   
    	textField:'CombDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'web.DHCDocIPBookNew';
						param.QueryName = 'CombListFind'
						param.Arg1="InDoctor"
						param.Arg2=Ctloc
						param.Arg3=CTLocMedUnit //Ĭ������
						param.Arg4=""
						param.ArgCnt =4;
		},
	  onLoadSuccess: function (data) {
	       

        },
      onSelect: function(rec){
		  
        }
	});	
	}
///��λCombʼ��
function InBedCombCreat()
{
	var InWardDr=$('#InWard').combobox('getValue');
	$('#InBed').combobox({      
    	valueField:'CombValue',   
    	textField:'CombDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'web.DHCDocIPBookNew';
						param.QueryName = 'CombListFind'
						param.Arg1="InBed"
						param.Arg2=InWardDr
						param.Arg3="" //Ĭ������
						param.Arg4=""
						param.ArgCnt =4;
		}
	});	
}

//����ԭ��Comb��ʼ��
function InReasonCombCreat()
{
	//����IPBKFlag��־����Ĭ����ʾֵ
	var CodeDefault=""
	var DisplayCode=""
	if (IPBKFlag=="Booking"){
		CodeDefault="Admit"
		DisplayCode="Admit"
	}else{
		CodeDefault="Admit"
	}
	DHCDocIPBDictoryCommon("InReason","IPBookingStateChangeReason",CodeDefault,DisplayCode)
}

//��ǰ״̬Comb��ʼ��
function InCurStatuCombCreat()
{
	//����IPBKFlag��־����Ĭ����ʾֵ
	var CodeDefault=""
	var DisplayCode=""
	if (IPBKFlag=="Booking"){
		CodeDefault="Booking"
		DisplayCode=BookStr
	}
	else{
		DisplayCode=OtherBookStr
	}
	DHCDocIPBDictoryCommon("InCurStatu","IPBookingState",CodeDefault,DisplayCode);
	if (LogonDoctorType != "DOCTOR") {
		$("#InCurStatu").combobox({disabled:true}); 
	}

}

//����Comb��ʼ��
function AdmInitStateCombCreat()
{
	$('#AdmInitState').combobox({      
    	valueField:'CombValue',   
    	textField:'CombDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'web.DHCDocIPBookNew';
						param.QueryName = 'CombListFind'
						param.Arg1="AdmInitState"
						param.Arg2=""
						param.Arg3="" //Ĭ������
						param.Arg4=""
						param.ArgCnt =4;
		}
	});	
	//DHCDocIPBDictoryCommon("AdmInitState","IPBookingAdmInitState","Common","")
}

//���鴲λ���ͳ�ʼ��
function InBedTypeCombCreat()
{
	var CodeDefault="01"
	var DisplayCode=""
	DHCDocIPBDictoryCommon("InBedType","IPBookingBedType",CodeDefault,DisplayCode)
}

//��Ժ;����ʼ��
function InSorceCombCreat()
{
	$('#InSorce').combobox({      
	valueField:'CombValue',   
	textField:'CombDesc',
	url:"./dhcdoc.cure.query.combo.easyui.csp",
	onBeforeLoad:function(param){
					param.ClassName = 'web.DHCDocIPBookNew';
					param.QueryName = 'CombListFind'
					param.Arg1="InSorce"
					param.Arg2=""
					param.Arg3="" //Ĭ������
					param.Arg4=""
					param.ArgCnt =4;
	}
	});	
}
///���˵ȼ���ʼ��
function PatientLevelCreat()
{
	var CodeDefault=""	
	var DisplayCode=""
	DHCDocIPBDictoryCommon("PatientLevel","IPBookingPatientLevel",CodeDefault,DisplayCode)
}
//����ԭ���ʼ��
function TreatedPrincipleCreat()
{
	var CodeDefault=""
	var DisplayCode=""
	DHCDocIPBDictoryCommon("TreatedPrinciple","IPBookingTreatedPrinciple",CodeDefault,DisplayCode)
	
	$('#TreatedPrinciple').combobox({
		onSelect: function(record){
			IsDayFlagClick(record.CombValue)
		}
	});

}

///�����ֵ�Comb��������
///ListCombID �ֵ������Code Ĭ��Code���� ��ʾCode����
function DHCDocIPBDictoryCommon(ListName,CodeType,CodeDefault,DisplayCode)
{
	//alert(ListName+","+CodeType+","+CodeDefault+","+DisplayCode)
	$('#'+ListName+'').combobox({      
    	valueField:'CombValue',   
    	textField:'CombDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'web.DHCDocIPBookNew';
						param.QueryName = 'CombListFind'
						param.Arg1="DHCDocIPBDictory"
						param.Arg2=CodeType
						param.Arg3=CodeDefault//Ĭ������
						param.Arg4=DisplayCode
						param.ArgCnt =4;
		}
	});	
}

//���ڸ�ʽ����
function DateCahnge(date)
{
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (DateFormat==3){
		return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	}else if(DateFormat==4){
		return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	}
	//return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	//return y+'-'+m+'-'+d;
}
function myparser(s){
	if (!s) return new Date();
	if (DateFormat==3){
		var ss = (s.split('-'));
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}else if(DateFormat==4){
		var ss = (s.split('/'));
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
	return new Date(y,m-1,d);
	}else{
	return new Date();
	}
}
function IntPaMes(){
	
	if (PatientID!=""){
		
		ClearPatMest()
		///����ID^�ǼǺ�^����^�Ա�^����^���֤^����^ʡ^��^����״��^����^
		///�ֻ�^��ϵ�绰^�Ļ��̶�^������λ^^��ͥ��ַ^������^��Ա����^
		///��ϵ������^��ϵ�˵绰^��ϵ�˹�ϵ^��ϵ�˹�ϵID^���߼���^�����ܼ�
		var encmeth=DHCC_GetElementData('GetPatDetail')
		var Patmes= cspRunServerMethod(encmeth,PatientID);
		var PatmesArry=Patmes.split("^");
		var PatID=PatmesArry[0]
		var PatNO=PatmesArry[1]
		var PatName=PatmesArry[2]
		var PatSex=PatmesArry[3]
		var PatBob=PatmesArry[4]
		var PatAge=PatmesArry[5]
		var PatGov=PatmesArry[6]
		var PatContry=PatmesArry[7]
		var PatProvince=PatmesArry[8]
		var PatCity=PatmesArry[9]
		var PatMarital=PatmesArry[10]
		var patNation=PatmesArry[11]
		var patPhone=PatmesArry[12]
		var patTel=PatmesArry[13]
		var patEducation=PatmesArry[14]
		var patWorkAddress=PatmesArry[15]
		var patCategoryDesc=PatmesArry[16]
		var patAddress=PatmesArry[17]
		var patMrNo=PatmesArry[18]
		var patSocial=PatmesArry[19]
		var patLinkName=PatmesArry[20]
		var patLinkPhone=PatmesArry[21]
		var patLinkRelation=PatmesArry[22]
		var patLinkRelationDr=PatmesArry[23]
		var patEmployeeFunction=PatmesArry[24]
		var patSecretLevel=PatmesArry[25]
		
		DHCC_SetElementData("PatNo",PatNO)
		DHCC_SetElementData("PatName",PatName)
		DHCC_SetElementData("PatSex",PatSex)
		DHCC_SetElementData("PatAge",PatAge)
		DHCC_SetElementData("PatMRNo",patMrNo)
		if (patTel!=""){DHCC_SetElementData("PatPhone",patTel)}else{DHCC_SetElementData("PatPhone",patPhone)}
		DHCC_SetElementData("PatType",patSocial)
		DHCC_SetElementData("PatID",PatGov)
		DHCC_SetElementData("PatFName",patLinkName)
		DHCC_SetElementData("PatFPhone",patLinkPhone)
		DHCC_SetElementData("PatFRelation",patLinkRelation)
		DHCC_SetElementData("PatCompany",patWorkAddress)
		DHCC_SetElementData("PatAddress",patAddress)
		
	}
		
}
//
function IntAmdMes(){
	//��ȡ���ID
	if (EpisodeID!=""){
		//�жϾ����Ƿ������������סԺ֤
		if (IPBKFlag=="Booking"){
			var Rtn=tkMakeServerCall("web.DHCDocIPBookNew","CheckBeforeSave",EpisodeID,"",1)
			if (Rtn!=0){
				var RtnArry=Rtn.split("^")
				if (RtnArry[0]=="-1"){
					$.messager.alert('����',RtnArry[1]);
					CanSave="N"
					return
				}else{
					$.messager.alert('��ʾ',RtnArry[1]);
				}
			}
		}
		var encmeth=DHCC_GetElementData('GetAdmICDList')
		var AdmICDList= cspRunServerMethod(encmeth,EpisodeID);
		DianosListICD=AdmICDList
		IntDianosList()
		var encmeth=DHCC_GetElementData('GetPatAdmMes')
		var PatAdmMes= cspRunServerMethod(encmeth,EpisodeID);
		if (PatAdmMes!=""){
			var PatAdmMesArry=PatAdmMes.split("^")
			if (PatAdmMesArry[5]!=PatientID){
				PatientID=PatAdmMesArry[5]
				IntPaMes()
			}
		}	
	}	
}

///����б���
function IntDianosList()
{
	//������ϵ��Ѫ��^452!�ʸ�˹ϸ������^514!���˿���Z^23029
	var Obj=document.getElementById("MRDiaList"); 
	Obj.innerHTML=""
	if (DianosListICD!=""){
		var DianosListArry=DianosListICD.split("!")
		for (var i=0;i<DianosListArry.length;i++){
			var Desc=DianosListArry[i].split("^")[0];
			var ICDDr=DianosListArry[i].split("^")[1];
			//if ((ICDDr=="")||(ICDDr=="undefined")) continue;
			if (ICDDr=="undefined") continue;
			var InnerStr="<input type=checkbox id=\""+ICDDr+"\" name=\""+"ICDList"+ "\" "+"\" DescICD=\""+Desc+ "\" "+ "value=1 checked"+" onclick=DelDiangose() ><span>"+Desc+"</span>"+"&nbsp&nbsp&nbsp"
			Obj.innerHTML=Obj.innerHTML+InnerStr
		}
	}
}

//��ʼ��סԺ֤��Ϣ���סԺ֤���ڵĻ�����סԺ֤�ϵ���ϢΪ׼���¶Խ�����Ϣ��ʼ��
function IntBookMes(){	
	if (BookIDMain!=""){
		var encmeth=DHCC_GetElementData('GetPatBookMes')
		var BookMesag= cspRunServerMethod(encmeth,BookIDMain);
		if (BookMesag==""){
			return
		}
		var ArryBookMesag=BookMesag.split("^")
		//����סԺ֤��Ϣ��ʼ��������Ϣ
		if (PatientID!=ArryBookMesag[1]){PatientID=ArryBookMesag[1];IntPaMes();}
		if (EpisodeID!=ArryBookMesag[2]){EpisodeID=ArryBookMesag[2];IntAmdMes();}
		
		//����סԺ֤��ʼ�������Ϣ
		var DiagnoseStr=ArryBookMesag[36] ;
		var DiagnoseStrArry=DiagnoseStr.split(String.fromCharCode(2))
		var Legnt1=DiagnoseStrArry.length
		var TemStr=""
		for (var i=0;i<Legnt1;i++){
			var Desc=DiagnoseStrArry[i].split(String.fromCharCode(1))[0]
			var ID=DiagnoseStrArry[i].split(String.fromCharCode(1))[1]
			if ((ID=="")&&(Desc=="")){continue}
			if (TemStr==""){TemStr=Desc+"^"+ID}
			else{TemStr=TemStr+"!"+Desc+"^"+ID}
			
		}
		DianosListICD=TemStr
		IntDianosList()
	
		//��ǰ״̬
		$('#InCurStatu').combobox('setValue',ArryBookMesag[8]);
		$('#InCurStatu').combobox('setText',ArryBookMesag[25])
		//��Ժ����
		$('#AdmInitState').combobox('setValue',ArryBookMesag[20]);
		//����ԭ��
		$('#InReason').combobox('setValue',ArryBookMesag[21]);
		//��Ժ;��
		$("#InSorce").combobox('setValue',ArryBookMesag[22]);
		//Ԥ����
		DHCC_SetElementData("IPDeposit",ArryBookMesag[17])
		//��ע
		DHCC_SetElementData("InResumeText",ArryBookMesag[15])
		//���鴲λ����
		$("#InBedType").combobox('setValue',ArryBookMesag[23]);
		//ԤԼ����
		$('#InSdate').datebox('setValue',ArryBookMesag[10]);
		//����--�����ÿ��������ò���
		$("#InCtloc").combobox('select',ArryBookMesag[13]);
		var LocDesc=BookMesag.split("^")[30];
		if (LocDesc!=""){
			window.setTimeout("$('#InCtloc').combobox('setText','"+LocDesc+"')")
		}
		//���ò���ѡ����
		var WardType=ArryBookMesag[54];
		if (WardType>0){
			var LocWardCheckBoxArry=LocWardCheckBox.split("^")
			var WardTypeName=LocWardCheckBoxArry[WardType-1]
			if (WardTypeName!=""){
				$('#'+WardTypeName).attr("checked",true)
				MainWardClick(WardTypeName)
			}
		}
		
		//���ݿ�����������Ŀ�ڿ��ҳ�ʼ������change�¼��н��г�ʼ��
		//InWardCombCreat() //��ʼ������
		//CTLocMedUnitCreat()   //ҽ�Ƶ�Ԫ��ʼ��
		//InDoctorCreat()   //סԺҽʦ��ʼ��
		
		//$("#InWard").combobox('setValue',ArryBookMesag[11]);
		
		window.setTimeout("$('#InWard').combobox('setValue','"+ArryBookMesag[11]+"')",500)
		//��λ
		
		
		window.setTimeout("$('#InBed').combobox('setValue','"+ArryBookMesag[12]+"')",1000)
		
		
		$("#PatientLevel").combobox('select',ArryBookMesag[40]);
		$("#CTLocMedUnit").combobox('setValue',ArryBookMesag[41]);
	
		InDoctorCreat()   //סԺҽʦ��ʼ��
		$("#InDoctor").combobox('select',ArryBookMesag[42]);
		$("#TreatedPrinciple").combobox('select',ArryBookMesag[43]);
		if(ArryBookMesag[51]=="Y"){
			$("#IsDayFlag").attr('checked',true);	
		}else{
			$("#IsDayFlag").attr('checked',false);		
		}
		
		if(ArryBookMesag[52]=="Y"){
			$("#IsOutTriage").attr('checked',true);	
		}else{
			$("#IsOutTriage").attr('checked',false);		
		}
		
	}
}

//�������
function ClearAll(){
	
	ClearBookMes()
	ClearPatMest()
	ClearAdmMes()	
}
//���סԺ֤��Ϣ
function ClearBookMes(){
	$("#InCtloc").combobox('setValue','');
	$('#InWard').combobox('loadData',{});
	$('#InBed').combobox('loadData', {});
	$('#AdmInitState').combobox('setValue','');
	$('#InReason').combobox('setValue','');
	$('#InSorce').combobox('setValue','');
	$("#InBedType").combobox('setValue','');
	$('#InSdate').datebox('setValue',NowDate);
	$('#CTLocMedUnit').combobox('loadData',{});
	$('#InDoctor').combobox('loadData',{});
	$('#TreatedPrinciple').combobox('setValue','');
	$('#PatientLevel').combobox('setValue','');
	$('#InBedType').combobox('setValue','');
	
	DHCC_SetElementData("IPDeposit",'')
	DHCC_SetElementData("InResumeText",'')	
}

//����������
function ClearAdmMes(){
	DianosListICD=""
	IntDianosList()
}
//������߻�����Ϣ
function ClearPatMest(){
	
	DHCC_SetElementData("PatNo",'')
	DHCC_SetElementData("PatName",'')
	DHCC_SetElementData("PatSex",'')
	DHCC_SetElementData("PatAge",'')
	DHCC_SetElementData("PatMRNo",'')
	DHCC_SetElementData("PatPhone",'')
	DHCC_SetElementData("PatType",'')
	DHCC_SetElementData("PatID",'')
	DHCC_SetElementData("PatFName",'')
	DHCC_SetElementData("PatFPhone",'')
	DHCC_SetElementData("PatFRelation",'')
	DHCC_SetElementData("PatCompany",'')
	DHCC_SetElementData("PatAddress",'')
}


function LoadDataTable()
{
	//סԺ֤�б�
	BookListDataGrid=$('#BookList').datagrid({  
		width : 'auto',
		border : true,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : true,
		url : '',
		queryParams : '',
		loadMsg : '������..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"BBookID",
		pageList : [10],
		//frozenColumns : FrozenCateColumns,
		columns :[[
					{field:'NO',title:'���',width:50},
					{field:'IPBookingNo',title:'סԺ֤��',width:80,align:'left'},
					{field:'BName',title:'����',width:70,align:'left'},
					{field:'BStatu',title:'״̬',width:50,align:'left'},
        			{field:'BBDate',title:'ԤԼ����',width:70},
					{field:'BBCTloc',title:'ԤԼ����',width:100},   
        			{field:'BBWard',title:'ԤԼ����',width:100},  
        			{field:'AdmInitStateDesc',title:'����',width:60},    
        			
        			{field:'BBBed',title:'ԤԼ��λ',width:100,hidden:true},
        			{field:'BBCreaterUser',title:'������',width:100},
        			{field:'BBCreaterDate',title:'��������',width:100},
        			{field:'rjss',title:'�Ƿ��ռ�����',width:100},
      
        			
        			{field:'BPatID',title:'����ID',width:100,hidden:true},
        			{field:'BAmdID',title:'����ID',width:100,hidden:true},
        			{field:'BBookID',title:'סԺ֤ID',width:100,hidden:true}  

    			 ]],
    		onSelect:function(rowid,RowData){
	    		//ѡ��סԺ֤��ȡ��Ӧ��Ϣ
				if (SelectBookRow==rowid){
					SelectBookRow="-1"
					$(this).datagrid('unselectRow', rowid);
					BookIDMain=""
				}else{
					BookIDMain=RowData.BBookID
					//��ʼ��סԺ֤��Ϣ
					IntBookMes();
					SelectBookRow=rowid;
				}
			},
			onLoadSuccess:function (data) {
				//console.log(data);
			}
			
	});	
	
	//�����б�--δ����סԺ֤�ľ���
	AdmDataGrid=$('#AdmList').datagrid({  
		width : 'auto',
		border : true,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : true,
		url : '',
		queryParams : '',
		loadMsg : '������..',  
		pagination : true,  //
		rownumbers : false,  //
		idField:"AdmID",
		pageList : [10],
		//frozenColumns : FrozenCateColumns,
		columns :[[
					{field:'NO',title:'���',width:50},
					{field:'AdmDate',title:'��������',width:100,align:'left'}, 
					{field:'AdmLoc',title:'�������',width:100},
        			{field:'AdmMark',title:'����ű�',width:100},
        			{field:'AdmDoc',title:'����ҽ��',width:50},
        			{field:'AdmDias',title:'���',width:200},
        			{field:'AdmID',title:'AdmID',width:100,hidden:true},
        			
    			 ]],
    		onSelect:function(rowid,RowData){
	    		//ѡ��סԺ֤��ȡ��Ӧ��Ϣ
				if (SelectAdmRow==rowid){
					SelectAdmRow="-1"
					$(this).datagrid('unselectRow', rowid);
					EpisodeID=""
					BookIDMain=""
				}else{
					BookIDMain=""
					EpisodeID=RowData.AdmID
					//��ʼ��סԺ֤��Ϣ
					SelectAdmRow=rowid;
					IntAmdMes()
				}
			}
   		
	});	
	
}

function PrintFun(PObj,inpara,inlist){
	////DHCPrtComm.js
	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
		var docobj=new ActiveXObject("MSXML2.DOMDocument.4.0");
		docobj.async = false;    //close
		var rtn=docobj.loadXML(mystr);
		if ((rtn)){
			
			////ToPrintDoc(ByVal inputdata As String, ByVal ListData As String, InDoc As MSXML2.DOMDocument40)			
			var rtn=PObj.ToPrintDocNew(inpara,inlist,docobj);
			////var rtn=PObj.ToPrintDoc(myinstr,myList,docobj);
		}
	}catch(e){
		alert(e.message);
		return;
	}
}

function DocumentUnloadHandler(){
	if (IPBKFlag!="Booking"){
		if (window.opener)
		{
			window.opener.location.reload();  
		}
	}
}

function ChangeStatuByWard(WardDr){
	
	if (BookIDMain!=""){return}
	//ѡ���� Ԥ��Ժ�����Զ��ı�״̬��Ԥ��Ժ
	var InpatWardFlag=tkMakeServerCall("web.DHCDocIPBookNew","GetWardPreInPatientFlag",WardDr)
	if (InpatWardFlag=="Y"){SetCurStatu("PreInPatient")}
	else{SetCurStatu("Booking")}
	
}

//���ղ�������λ�û�ȡ��ǰѡ�еò�������
function WardSelectFind()
{
	var WardFlag=""
	var CheckMutuallyArry=LocWardCheckBox.split("^")
	for (var i=0;i<CheckMutuallyArry.length;i++)
	{
		if (($("#"+CheckMutuallyArry[i]).is(':checked'))&(!$("#"+CheckMutuallyArry[i]).is(':hidden'))){WardFlag=(i+1)}
	}
	return WardFlag
}

function diaplayWardCheck(inlocdr){
	//����ѡ�к���ʾCheckBox
	if (inlocdr!=""){
		//��������������
		var LinkWard=tkMakeServerCall("web.DHCDocIPBookNew","GetLinkWard",inlocdr)
		if (LinkWard==""){if($('#LinkWard').length>0){$('#LinkWard').hide();$('#cLinkWard').hide();$('#LinkWard').attr("checked",false)}}
		else{if($('#LinkWard').length>0){$('#LinkWard').show();$('#cLinkWard').show()}}
		//�����Ʊ�ʶ
		var LocCureLimit=tkMakeServerCall("web.DHCDocIPBookNew","GetLocCureLimit",inlocdr)
		if (LocCureLimit!="Y"){if($('#AllWard').length>0){$('#AllWard').hide();$('#cAllWard').hide();;$('#AllWard').attr("checked",false)}}
		else{if($('#AllWard').length>0){$('#AllWard').show();$('#cAllWard').show()}}
		
		//δ�ҵ�ѡ�е�Ĭ��ѡ�е�һ��
		var WardFlag=WardSelectFind()
		if (WardFlag==""){
			$('#LocWard').attr("checked",true)
		}
	}
}
//��������ѡ��
function WardClick(){
	var Obj=GetEventElementObj()
	MainWardClick(Obj.name)
}

function MainWardClick(wartype){
	var CheckMutuallyArry=LocWardCheckBox.split("^")
	for (var i=0;i<CheckMutuallyArry.length;i++)
	{
		if (wartype!=CheckMutuallyArry[i]){if($("#"+CheckMutuallyArry[i]).length>0){$('#'+CheckMutuallyArry[i]).attr("checked",false)}}
	}
	
	//δ�ҵ�ѡ�е�Ĭ��ѡ�е�һ��
	var WardFlag=WardSelectFind()
	if (WardFlag==""){
		$('#'+CheckMutuallyArry[0]).attr("checked",true)
	}
	
	//ͨ���������ͳ�ʼ������
	InWardCombCreat()

	//��ʼ����λ��Ϣ
	InBedCombCreat()	
}


///��ȡ��Ӧ�¼��Ķ���
function GetEventElementObj(){
	var isIE=document.all ? true : false;  
	var obj = null;  
	if(isIE==true){  
		obj = document.elementFromPoint(event.clientX,event.clientY);  
	}else{  
		e = arguments.callee.caller.arguments[0] || window.event;   
		obj = document.elementFromPoint(e.clientX,e.clientY);  
	}
	return obj
}

//�ռ��������
function IsDayFlagClick(TreatedPrinciplevalue)
{
	if (TreatedPrinciplevalue==""){return}
	var diastr=tkMakeServerCall("web.DHCDocIPBookNew","GetDHCDocIPBDictory",TreatedPrinciplevalue)
	var diaarry=diastr.split("^")
	if(diaarry[0]=="DaySurg"){
		var findstatu="N"
		var dataobj=$('#InCurStatu').combobox('getData');
	 	var datalength=dataobj.length;
	 	for (var i=0;i<datalength;i++){
			var statudr=dataobj[i].CombValue;
			if (statudr==""){continue}
			var statustr=tkMakeServerCall("web.DHCDocIPBookNew","GetDHCDocIPBDictory",statudr)
			var statustrarry=statustr.split("^")
			if (statustrarry[0]=="PreInPatient"){
					findstatu="Y"
			}
		}
		if (findstatu=="N"){
				$.messager.alert('��ʾ',"ԤסԺ״̬������!");	
		}
		SetCurStatu("PreInPatient")
	}else{
		//SetCurStatu("Booking")
	}

	
}

function SetCurStatu(CurStatuCode)
{
		var dataobj=$('#InCurStatu').combobox('getData');
	 	var datalength=dataobj.length;
	 	for (var i=0;i<datalength;i++){
			var statudr=dataobj[i].CombValue;
			if (statudr==""){continue}
			var statustr=tkMakeServerCall("web.DHCDocIPBookNew","GetDHCDocIPBDictory",statudr)
			var statustrarry=statustr.split("^")
			if (statustrarry[0]==CurStatuCode){
				$('#InCurStatu').combobox('setValue',statudr);
			}
		}
	
}



//���ռ�����ID
function OpenOpertion(OpeType)
{
	var Url=""
	var rtn=tkMakeServerCall("web.DHCDocIPBookNew","HavveActiveOpertion",BookIDMain)
	var rtnArry=rtn.split("^")
	var rtnflag=rtnArry[0]
	if ((rtnflag==0)||(rtnflag==1)){
		if (OpeType=="Auto"){
			//�Զ�ģʽ��ֻ��δ����ĵ��ӲŴ�
			if (rtnflag==0){Url=tkMakeServerCall("web.DHCDocIPBookNew","GetBookOpertion",BookIDMain)}
		}else{
			Url=tkMakeServerCall("web.DHCDocIPBookNew","GetBookOpertion",BookIDMain)
		}
	}else{
		//�����������ĵ����Զ�ģʽ�²���ʾ
		if (OpeType=="Auto"){return}
		$.messager.alert('��ʾ',"���ܽ�����������:"+rtnArry[1]);	
		return
		
	}
	if(typeof websys_writeMWToken=='function') url=websys_writeMWToken(url);
	//�ռ���������̶����
	var winName="OpenOpertion"; 
	var awidth=1260 //screen.availWidth/6*5; 
	var aheight=680 ;screen.availHeight/5*4; 
	var atop=(screen.availHeight - aheight)/2;
	var aleft=(screen.availWidth - awidth)/2;
	var param0="scrollbars=0,status=0,menubar=0,resizable=2,location=0"; 
	var params="top=" + atop + ",left=" + aleft + ",width=" + awidth + ",height=" + aheight + "," + param0 ;
	win=window.open(Url,winName,params); 
	win.focus();
	
}

function GetCanDoBookCode(){
	//�ɲ�����״̬
	var CanDoStatu=""
	if (IPBKFlag=="Booking"){
		CanDoStatu=BookStr
	}
	else{
		CanDoStatu=OtherBookStr
	}
	return 	CanDoStatu
}


