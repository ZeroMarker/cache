///Description: �Ǽƻ��ٴ��������浥
///Creator: lp
///Creatdate: 18-5-10
var RepDate=formatDate(0); 	//ϵͳ�ĵ�ǰ����
var Opename=""; // �������� code
$(document).ready(function(){
	InitButton();				// ��ʼ����ť
	reportControl();			// ������  	
	InitNonPlanReport(recordId);//����ҳ����Ϣ
	InitLayoutHtml();			//��ʼ��ҳ�沼�� 18-1-20
})
function InitButton(){
	
	// ����
	$("#SaveBut").on("click",function(){
		SavePipeReport(0);
	})
	
	// �ύ
	$("#SubmitBut").on("click",function(){
		SavePipeReport(1);
	})	
	
}
// ������
function reportControl(){
	// ԭ��������
	chkdate("NonPlanRepaTheOperDate");
	// ����������
	//chkdate("NonPlanRepaAgainOperDate");
	RepOpeEnter("NonPlanRepTheOperName");
	RepOpeEnter("NonPlanRepAgainOperName");

}

//���ر�������Ϣ
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	InitPatInfoCom(EpisodeID);
	$("#from").form('validate'); 
}

//���ر�����Ϣ
function InitNonPlanReport(recordId)
{
	InitReportCom(recordId);
	if((recordId=="")||(recordId==undefined)){
	}else{
		//������Ϣ
    	$("#from").form('validate');			
	} 
}

//���汣��
function SavePipeReport(flag)
{
	if($('#PatName').val()==""){
		$.messager.alert($g("��ʾ:"),$g("��������Ϊ�գ�������ǼǺŻ򲡰��Żس�ѡ���¼¼�뻼����Ϣ��"));	
		return false;
	} 
	///����ǰ,��ҳ���������м��
	 if(!checkRequired()){
		return;
	}

	SaveReportCom(flag);
}


function InitLayoutHtml(){
	$('#NonPlanRepaDiag').css('width','500px');
	$('#NonPlanRepaDiag').css('max-width','500px');
	$('#NonPlanRepaAgainOperRes-738').css('width','500px');
	$('#NonPlanRepaAgainOperRes-738').css('max-width','500px');
	$('#NonPlanRepaOperGoal').css('width','500px');
	$('#NonPlanRepaOperGoal').css('max-width','500px');
	$('#lableNonPlanRepaAgainOperRes-735-736 .lable-input').css({
		'float':'left',
		'margin-left':'50px',
		'width':'300px',
		'max-width':'300px'
	}
	)
}



function doOther(obj){
	//�����������س̶�
	id=$(obj).attr("id")
	parref=$(obj).parent().attr("data-parref");
	if(parref.indexOf("MedAdvEventLev")>=0){
		if($(obj).attr("checked")=="checked"){
			$("label[data-parref='MedAdvInjuryLevByType']").show();
			$("label[data-parref='"+parref+"']").not("#lable"+id).children().removeAttr("checked");
			if(id=="MedAdvEventLev-641"){
				$("label[data-parref='MedAdvInjuryLevByType']").not('#lableMedAdvInjuryLevByType-654').hide();	
			}if(id=="MedAdvEventLev-642"){
				$("label[data-parref='MedAdvInjuryLevByType']").not('#lableMedAdvInjuryLevByType-653,#lableMedAdvInjuryLevByType-652,#lableMedAdvInjuryLevByType-651,#lableMedAdvInjuryLevByType-650').hide();	
			}if(id=="MedAdvEventLev-643"){
				$("label[data-parref='MedAdvInjuryLevByType']").not('#lableMedAdvInjuryLevByType-649,#lableMedAdvInjuryLevByType-648,#lableMedAdvInjuryLevByType-647').hide();	
			}if(id=="MedAdvEventLev-644"){
				$("label[data-parref='MedAdvInjuryLevByType']").not('#lableMedAdvInjuryLevByType-646').hide();	
			}
		}else{
			$("label[data-parref='MedAdvInjuryLevByType']").each(function(){
				$(this).show();	
			})
		}	
	}
}

//ͨ������id��ȡ��������������Ϣ
function RepOpeEnter(id){
	if((recordId!="")&&(recordId!=undefined)){
		return ;
	}else{
		$('#'+id).bind('keydown',function(event){
			if(event.keyCode == "13")    
			{
				if(EpisodeID==""){
					$.messager.alert($g("��ʾ:"),$g("����ѡ���߾����¼��"));
					return;
				}
				if($("#admopegrid").length>0)
				{
				   $("#admopegrid").remove(); 
				}
				GetOpeGridWin(EpisodeID,id);
			}
		});
	}
	
}
//ͨ��סԺ�ţ������ţ����ǼǺ� ��ȡ���˻�����Ϣ
function GetOpeGridWin(EpisodeID,id){
	Opename=id;
	var input=input+'&StkGrpRowId=&StkGrpType=G&Locdr=&NotUseFlag=N&QtyFlag=0&HospID=' ;
	var mycols = [[
		{field:'OPSID',title:$g('��������ID'),width:80},
		{field:'AppCareProvDesc',title:$g('����ҽ��'),width:60},
		{field:'OperDesc',title:$g('��������'),width:60}, 
		
		{field:'SourceTypeDesc',title:$g('��������'),width:120}, 
		{field:'StatusDesc',title:$g('����״̬'),width:80},
		{field:'OperDate',title:$g('������ʼ����'),width:70},
		{field:'ROperDuration',title:$g('����ʱ��'),width:70}
		
		//{field:'Adm',title:'Adm',width:60,hidden:true} 
	]];
	var mydgs = {
		//url:'dhcadv.repaction.csp'+'?action='+actiontype+'&Input='+patientNO+'&Type='+""+'&LgHospID='+LgHospID , //hxy 2020-02-18 +'&LgHospID='+LgHospID 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVINTERFACE&MethodName=QueryPatOpeList'+'&EpisodeID='+EpisodeID,
		columns: mycols,  //����Ϣ
		nowrap:false,
		pagesize:10,  //һҳ��ʾ��¼��
		table: '#admdsgrid', //grid ID
		field:'OPSID', //��¼Ψһ��ʶ
		params:null,  // �����ֶ�,��Ϊnull
		tbar:null //�Ϲ�����,��Ϊnull
	}
	var win=new CreatMyDiv(input,$("#"+id),"admopegrid","460px","335px","admdsgrid",mycols,mydgs,"","",SetPatOpeVal);	
	win.init();
}
//��ȡ������/�ǼǺ�ѡ���¼����
function SetPatOpeVal(Data)
{
	var OperDesc=Data.OperDesc;		//��������		
		var AppCareProvDesc=Data.AppCareProvDesc;  				// ����ҽʦ
		var ROperDuration=Data.ROperDuration;					// ����ʱ��
		var OperDate=Data.OperDate;					// ������ʼ����
	if(Opename=="NonPlanRepTheOperName"){
		RepSetValue("NonPlanRepTheOperName","input",OperDesc); 
		RepSetRead("NonPlanRepTheOperName","input",1);
		RepSetValue("NonPlanRepaTheBthDoc","input",AppCareProvDesc);
		RepSetRead("NonPlanRepaTheBthDoc","input",1);
		RepSetValue("NonPlanRepaOperDurTime","input",ROperDuration);
		RepSetRead("NonPlanRepaOperDurTime","input",1);		
      	if(OperDate!=""){
			RepSetRead("NonPlanRepaTheOperDate","datebox",1);
			RepSetValue("NonPlanRepaTheOperDate","datebox",OperDate);
		}else {
			RepSetRead("NonPlanRepaTheOperDate","datebox",0);
			RepSetValue("NonPlanRepaTheOperDate","datebox","");
		}			
	}
	
	if(Opename=="NonPlanRepAgainOperName"){
		var NonPlanRepaTheOperDate=$("#NonPlanRepaTheOperDate").datebox("getValue");
		if(NonPlanRepaTheOperDate==""){
			$.messager.alert($g("��ʾ:"),$g("����ѡ����ԭ������¼��"));
			return;
		}
		if((NonPlanRepaTheOperDate!="")&&(!compareSelTowTime(NonPlanRepaTheOperDate,OperDate))){
			$.messager.alert($g("��ʾ:"),$g("�ٴ��������ڲ���С��ԭ�������ڣ�"));
			return;
		}
		RepSetValue("NonPlanRepAgainOperName","input",OperDesc); 
		RepSetRead("NonPlanRepAgainOperName","input",1);
		RepSetValue("NonPlanRepaAgainBthDoc","input",AppCareProvDesc);
		RepSetRead("NonPlanRepaAgainBthDoc","input",1);
      	if(OperDate!=""){
			RepSetRead("NonPlanRepaAgainOperDate","datebox",1);
			RepSetValue("NonPlanRepaAgainOperDate","datebox",OperDate);
		}else {
			RepSetRead("NonPlanRepaAgainOperDate","datebox",0);
			RepSetValue("NonPlanRepaAgainOperDate","datebox","");
		}			
	}
	
}
