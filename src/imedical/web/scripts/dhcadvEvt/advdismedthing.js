/// Description: һ����ҽ����Ʒ�����¼����浥
/// Creator: congyue
/// CreateDate: 2017-12-18
var eventtype=""
var RepDate=formatDate(0); //ϵͳ�ĵ�ǰ����
$(document).ready(function(){
	ReportControl();			// ������  	
	InitButton();				// ��ʼ����ť
	InitReport(recordId);//����ҳ����Ϣ
	
});
// ������
function ReportControl(){
	// ͣ�����ڿ���
	chkdate("DisMedThingDeactivateDate");
	// ֲ�����ڣ���ֲ�룩����
	chkdate("DisMedThingImlantDate");
}
//��ť�����뷽����
function InitButton(){
	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
	})
if (RepStaus!=""){
		$("#PatOutcomBut").show(); //��ʾת�鰴ť		
		if(winflag==2){
			if(LocHeadNurEvaFlag=="1"){
				$("#LocHeadNurEvaBut").show(); // ����������ʾ���۰�ť 2019-07-25 cy
			}
			if(NurDepEvaFlag=="1"){
				$("#NurDepEvaBut").show(); // ����������ʾ���۰�ť 2019-07-25 cy
			}
		} 
	}
	var LocHeadNurEvaId=GetAssessRecordID("LocHeaNurEvaluate"); 
	if(LocHeadNurEvaId!=""){
		$("#LocHeadNurEvaBut").show();
	}
   	$("#LocHeadNurEvaBut").on("click",function(){ 
		showAssessmentWin("LocHeaNurEvaluate",LocHeadNurEvaId);
	})
	// ��������
	var NurDepEvaId=GetAssessRecordID("NurDepEvaluate");  
	if(NurDepEvaId!=""){
		$("#NurDepEvaBut").show();
	}
	$("#NurDepEvaBut").on("click",function(){ 
		showAssessmentWin("NurDepEvaluate",NurDepEvaId);
	})
	/// ת�����
	$("#PatOutcomBut").on("click",function(){ 
		showPatOutcomWin("PatOutcomform");
	})}

//���ر�����Ϣ
function InitReport(recordId)
{
	InitReportCom(recordId);
	if((recordId=="")||(recordId==undefined)){	
	}else{
    	$("#from").form('validate');			
	}
}
//���汣��
function SaveReport(flag)
{
	if($('#PatName').val()==""){
		$.messager.alert($g("��ʾ:"),$g("��������Ϊ�գ�������ǼǺŻ򲡰��Żس�ѡ���¼¼�뻼����Ϣ��"));	
		return false;
	}
	if(!compareSelTowTime($('#DisMedThingImlantDate').datebox('getValue'),$('#DisMedThingDeactivateDate').datebox('getValue')))
	{
		$.messager.alert($g("��ʾ:"),$g("��ֲ�����ڡ����ܴ��ڡ�ͣ�����ڡ���"));
		return false;
	}
	///����ǰ,��ҳ���������м��
	if(!(checkRequired())){
		return;
	}
	SaveReportCom(flag);
}
//���ر�������Ϣ
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	InitPatInfoCom(EpisodeID);
	$("#from").form('validate'); 
}
	
/* //�ǼǺ��Զ���0
function getRePatNo(regno)
{
	//return regno;
	var len=regno.length;
	var  reglen=10
	var zerolen=reglen-len
	var zero=""
	for (var i=1;i<=zerolen;i++)
	{zero=zero+"0" ;
		}
	return zero+regno ;
}
//ͨ��סԺ�ţ������ţ���ȡ���˻�����Ϣ
function PatMedNoEnter(){
	$('#PatMedicalNo').bind('keydown',function(event){
		if(event.keyCode == "13")    
		{
			var patientNO=$('#PatMedicalNo').val();
			if (patientNO=="")
			{
				$.messager.alert("��ʾ:","���˲����Ų���Ϊ�գ�");
				return;
			}
			//var  patientNO=getRePatNo(patientNO);
			var input=input+'&StkGrpRowId=&StkGrpType=G&Locdr=&NotUseFlag=N&QtyFlag=0&HospID=' ;
			var mycols = [[
				{field:'RegNo',title:'����id',width:80},
				{field:'AdmTypeDesc',title:'��������',width:60}, 
				{field:'AdmLoc',title:'�������',width:120}, 
				{field:'AdmDate',title:'��������',width:80},
				{field:'AdmTime',title:'����ʱ��',width:70},
				{field:'Adm',title:'Adm',width:60,hidden:true} 
			]];
			var mydgs = {
				url:'dhcadv.repaction.csp'+'?action=GetAdmList&Input='+patientNO ,
				columns: mycols,  //����Ϣ
				nowrap:false,
				pagesize:10,  //һҳ��ʾ��¼��
				table: '#admdsgrid', //grid ID
				field:'Adm', //��¼Ψһ��ʶ
				params:null,  // �����ֶ�,��Ϊnull
				tbar:null //�Ϲ�����,��Ϊnull
			}
			var win=new CreatMyDiv(input,$("#PatMedicalNo"),"drugsfollower","460px","335px","admdsgrid",mycols,mydgs,"","",SetAdmIdTxtVal);	
			win.init();
		}
	});
}
//��ȡ������ѡ���¼����
function SetAdmIdTxtVal(rowData)
{
	EpisodeID=rowData.Adm;
	if(EpisodeID==undefined){
		EpisodeID="";
	}
	InitPatInfo(EpisodeID);
}
//�ǼǺŻس��¼�
function PatIDEnter(){
	$('#PatID').bind('keydown',function(event){

		 if(event.keyCode == "13")    
		 {
			 var PatID=$('#PatID').val();
			 if (PatID=="")
			 {
				 	$.messager.alert("��ʾ:","���˵ǼǺŲ���Ϊ�գ�");
					return;
			 }
			 var PatID=getRegNo(PatID);
			 var input=input+'&StkGrpRowId=&StkGrpType=G&Locdr=&NotUseFlag=N&QtyFlag=0&HospID=' ;
			 var mycols = [[
			 	{field:'Adm',title:'Adm',width:60}, 
			 	{field:'AdmLoc',title:'�������',width:220}, 
			 	{field:'AdmDate',title:'��������',width:80},
			 	{field:'AdmTime',title:'����ʱ��',width:80},
			 	{field:'RegNo',title:'����id',width:80}
			 ]];
			 var mydgs = {
				 url:'dhcadv.repaction.csp'+'?action=GetAdmDs&Input='+PatID ,
				 columns: mycols,  //����Ϣ
				 pagesize:10,  //һҳ��ʾ��¼��
				 table: '#admdsgrid', //grid ID
				 field:'Adm', //��¼Ψһ��ʶ
				 params:null,  // �����ֶ�,��Ϊnull
				 tbar:null //�Ϲ�����,��Ϊnull
				}
			 var win=new CreatMyDiv(input,$("#PatID"),"drugsfollower","650px","335px","admdsgrid",mycols,mydgs,"","",SetAdmTxtVal);	
			 win.init();
		}
	});	
}
//��ȡ�ǼǺ�ѡ���¼����
function SetAdmTxtVal(rowData)
{
	EpisodeID=rowData.Adm;
	if(EpisodeID==undefined){
		EpisodeID=""
	}
	InitPatInfo(EpisodeID);
	
}*/
/* //ȷ������  2018-04-24
function FormConfirmAudit()
{	
	var NextLoc="";  //$('#matadrNextLoc').combobox('getValue');
	var LocAdvice="";  //$('#matadrLocAdvice').val();
	var params=RepID+"^"+StatusNextID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+adrReceive+"^"+RepTypeCode;   //������
	runClassMethod("web.DHCADVCOMMONPART","AuditMataReport",{'params':params},
	function(jsonString){ 
		if(jsonString.ErrCode < 0){
			$.messager.alert("��ʾ:","��˴���,����ԭ��:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");   ///+"��"+errnum+"������"
		}
		if(jsonString.ErrCode == 0){
			window.parent.CloseWinUpdate();
			window.parent.Query();
		}
	},"json");
		
}
//�������� 2018-04-24
function FormCancelAuditBt()
{	var NextLoc="" //$('#matadrNextLoc').combobox('getValue');
	var LocAdvice="" //$('#matadrLocAdvice').val();
	if ((StaFistAuditUser!="")&(StaFistAuditUser!=LgUserName)){
		$.messager.alert("��ʾ:","����Ϊ���ر��棬��δ���ظ���ǰ��¼�ˣ���Ȩ�޳�����ˣ�");
		return;
	}
	var params=RepID+"^"+StatusLastID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+adrReceive+"^"+RepTypeCode;   //������
	//alert(params);
	//��������
	runClassMethod("web.DHCADVCOMMONPART","CancelAuditReport",{'params':params},
	function(jsonString){ 
		//var resobj = jQuery.parseJSON(jsonString);
		//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  ��ȡ���� ������һ�в�������
		if(jsonString.ErrCode < 0){
			$.messager.alert("��ʾ:","��˴���,����ԭ��:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");   ///+"��"+errnum+"������"
		}
		if(jsonString.ErrCode == 0){
			window.parent.CloseWinUpdate();
			window.parent.Query();
		}
	},"json");
		
}
 */
