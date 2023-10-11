/// Description:��Һ��Ӧר��浥
/// Creator:lvpeng
/// CreateDate: 2017-12-18
var drugname="";
var url="dhcadv.repaction.csp";
var RepDate=formatDate(0); //ϵͳ�ĵ�ǰ����
$(document).ready(function(){
	InitButton();				// ��ʼ����ť
	ReportControl();			// ������
	InitCheckRadio();
	CheckTimeorNum();  //ʱ��У��
	InitReport(recordId);
	
})
function InitButton(){
	
	// ����
	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	
	// �ύ
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
	})	
	/*$('#MedBut').on("click",function(){  //sufan 2019-06-24  ���Ҫ���ʽͳһ,�س�����ҩƷ�б�
		initMedModal();
	})*/
	
	$("input[id^='TransRctDrugInfo-']").live('keydown',function(e)
	{
		if(e.keyCode==13)
		{
			drugname=$(this).attr("name")
			initMedModal(this.id);
		}
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
	})
}
// ������
function ReportControl(){
	//��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
	//��ѡ��ť�¼�
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
	// ��ע���ڿ���
	chkdate("TransRctLiqInfuDate","TransRctLiqInfuTime");
	// �������ڿ���
	chkdate("TransRctPunDate");

	// ҩҵ�����ͼ첿��ʱ�� ����
	chkdate("TransRctMedDepDate","TransRctMedDepTime");
	
	// ���ܼ�������ͼ첿�� ʱ�����
	chkdate("TransRctCatheterDate","TransRctCatheterTime");
}
//ҳ���ʼ����checkbox,radio������Ԫ�ز�������д
function InitCheckRadio(){
	// ���ߵ��ٴ����� Ƥ�� ��ѡ ��
	if($('#TransRctCliniMan-94148-94149').is(':checked')){
		$('#TransRctCliniMan-94148-94150-94153').nextAll(".lable-input").val("");
		$('#TransRctCliniMan-94148-94150-94153').nextAll(".lable-input").hide();
	}
	// ҩҺ�����ͼ첿�� �Ƿ�ѡ
	if($('#TransRctLiqMedDep-94242').is(':checked')){
		RepSetRead("TransRctMedDepDate","datebox",0);
		RepSetRead("TransRctMedDepTime","input",0);
	}else{
		RepSetRead("TransRctMedDepDate","datebox",1);
		RepSetValue("TransRctMedDepDate","datebox","");
		RepSetValue("TransRctMedDepTime","input","");
		RepSetRead("TransRctMedDepTime","input",1);
	}
	// ���ܼ�������ͼ첿��  �Ƿ�ѡ
	if($('#TransRctCatheterDep-94246').is(':checked')){
		RepSetRead("TransRctCatheterDate","datebox",0);
		RepSetRead("TransRctCatheterTime","input",0);
	}else{
		RepSetRead("TransRctCatheterDate","datebox",1);
		RepSetValue("TransRctCatheterDate","datebox","");
		RepSetValue("TransRctCatheterTime","input","");
		RepSetRead("TransRctCatheterTime","input",1);
	}
	
	
}

//��ʼ��Һ�����ƴ���
function initMedModal(id){
    if(EpisodeID==""){
	   $.messager.alert('Warning',$g('����ѡ���߾����¼��'));
	   return;
	}
	var gridTotalId=$('#TransRctDrugInfo').next().attr("id");
	var $tr=$("#"+gridTotalId).find("ul > li >div >table >tbody").children("tr");
	if($tr.length==0){
	   $.messager.alert('Warning',$g('���ȵ����ҩƷ��Ϣ������ӡ���ť���һ�У�'));
	   return;	
	}
	GetGridMedWin(id);	 //"admnogridMed"
}

function GetGridMedWin(id){
	var input=input+'&StkGrpRowId=&StkGrpType=G&Locdr=&NotUseFlag=N&QtyFlag=0&HospID=' ;
	var mycols=[[
		{field:"orditm",title:'orditm',width:90,hidden:false},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
		{field:'incidesc',title:$g('����'),width:140},
		{field:'genenic',title:$g('ͨ����'),width:140},
	    {field:'batno',title:$g('��������'),width:70,hidden:false},
	    {field:'staDate',title:$g('��ʼ����'),width:60,hidden:true},
	    {field:'endDate',title:$g('��������'),width:60,hidden:false},
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'dosage',title:$g('����'),width:60},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'instru',title:$g('�÷�'),width:80},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'freq',title:$g('Ƶ��'),width:40},//priorty
		{field:'priorty',title:$g('���ȼ�'),width:60},//priorty
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'duration',title:$g('�Ƴ�'),width:40},
		{field:'durId',title:'durId',width:80,hidden:true},
		{field:'apprdocu',title:$g('��׼�ĺ�'),width:140},
		{field:'manf',title:$g('����'),width:140},
		{field:'manfdr',title:'manfdr',width:80,hidden:true},
		{field:'form',title:$g('����'),width:80},
		{field:'formdr',title:'formdr',width:80,hidden:true}
	]];
	var mydgs = {
		url:'dhcadv.repaction.csp'+'?action=GetPatOEInfo'+'&params='+EpisodeID+'&instrutype='+'DZ' ,
		columns: mycols,  //����Ϣ
		pagesize:10,  //һҳ��ʾ��¼��
		table: "#admnogridmed", //grid ID
		field:'orditm', //��¼Ψһ��ʶ
		params:null,  // �����ֶ�,��Ϊnull
		tbar:null, //�Ϲ�����,��Ϊnull
	}
	var rownum=id.split(".")[1];
	var win=new CreatMyDiv(input,$("input[id^='TransRctDrugInfo-'][id$='."+rownum+"']"),"drugsfollower","1000px","335px","admnogridmed",mycols,mydgs,"","",addDrgTest);	
	win.init();	
}

//���ҩƷ
function addDrgTest(rowData)
{   

	if(rowData==""){
		return;	
	}
    var row = rowData;
    var gridTotalId=$('#TransRctDrugInfo').next().attr("id");
      var $tr =$("#"+gridTotalId).find("ul > li >div >table >tbody").children("tr");
      if($tr.length>=1){
	      var num=0;
	      var flag=0; //�ж��Ƿ��п���
	      $.each($tr,function(index){drugname
			  //var $td =$("#"+gridTotalId).find("ul > li >div >table >tbody >tr:eq("+index+")").children("td"); //Ϊ�˸�Ĭ�ϵĵ�һ�и�ֵ  //sufan 2019-6-25 �ĳ���name��λ�������У����������޸������������
			   var $td =$("input[name='"+drugname+"'][type=input]").parent().parent().children('td'); 
			  //if(GetIfNullFlag()==0){
					//$.messager.alert('Warning','�����һ������������ݣ�');
	   				//return false;		  
			  //}
			  
			  //if(($td.eq(0).find("input").val()=="")){ //sufan 2019-06-24 ȥ�����ж�
				  $td.eq(0).find("input").val(row.genenic+"/["+row.form+"]"); //ͨ�����ƣ������ͣ�
			      $td.eq(1).find("input").val(row.dosage+"/"+row.instru+"/"+row.freq); //�÷�����
			      $td.eq(2).find("input").val(row.manf);  //��������
			      $td.eq(3).find("input").val(row.batno);
			      $td.eq(4).find(".combo-value").val(row.endDate); //��������
			      $td.eq(4).find(".combo-text").val(row.endDate); //��������  
			      num=1;
			      //return false;
			  //}
			   
    
		  })
	  }  
}

function GetIfNullFlag(){
	var flag=0;
	var gridTotalId=$('#TransRctDrugInfo').next().attr("id");
	var $tr =$("#"+gridTotalId).find("ul > li >div >table >tbody").children("tr");	
	 if($tr.length>=1){
		$.each($tr,function(index){
			var $td =$("#"+gridTotalId).find("ul > li >div >table >tbody >tr:eq("+index+")").children("td"); //Ϊ�˸�Ĭ�ϵĵ�һ�и�ֵ
			if($td.eq(0).find("input").val()==""){
				flag=1;	
			}	
		})	 
	}
	return flag;
}

//���ر�������Ϣ
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	InitPatInfoCom(EpisodeID);
	$("#from").form('validate'); 
	InitCheckRadio();

}
//���ر���Ĭ����Ϣ
function InitReport(recordId)
{    
   InitReportCom(recordId);
	if((recordId=="")||(recordId==undefined)){
	}else{
		//������Ϣ
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
	///����ǰ,��ҳ���������м��
	if(!(checkRequired())){
		return;
	}
	var msg=checkTableRequired();
	if(msg!=""){
		return;
	}
	SaveReportCom(flag);
}



//������ʾ
function doOther(obj){
}

//ʱ�� ����У��
function CheckTimeorNum(){
	//ʱ������У��
	//Һ����עʱ��
	chktime("TransRctLiqInfuTime","TransRctLiqInfuDate");
	//ҩҺ�����ͼ첿��ʱ��
	chktime("TransRctMedDepTime","TransRctMedDepDate");
	//���ܼ�������ͼ첿��ʱ��
	chktime("TransRctCatheterTime","TransRctCatheterDate");	
	
	// ��������У��
	// Һ����ע����
	chknum("TransRctLiqConfig",1,1);
	// P ����
	chknum("PatientStatus-94856-94858-94863",0);
	chknum("PatientStatus-94856-94871-94877",0);
	// R ����
	chknum("PatientStatus-94856-94858-94866",0);
	chknum("PatientStatus-94856-94871-94880",0);
	// SpO2
	chknum("PatientStatus-94856-94858-94869",1,1,100);
	chknum("PatientStatus-94856-94871-94883",1,1,100);
	// BP
	checkBP("PatientStatus-94856-94858-94860");
	checkBP("PatientStatus-94856-94871-94874");
	
}
//���table�еı���
function checkTableRequired(){
	var errMsg=""
	
	$("#TransRctDrugInfo").next().find("tbody tr").each(function(i){
		var rowMsg=""
		// ҩ��ͨ������
		var str=$(this).children('td').eq(0).find("input").val();
		if(str.length==0){
			rowMsg=rowMsg+"ҩ��ͨ������,"
		}
		// �÷�����
		var str1=$(this).children('td').eq(1).find("input").val();
		if(str1.length==0){
			rowMsg=rowMsg+"�÷�����,"
		}
		
		if(rowMsg!=""){
			errMsg=errMsg+"\n"+rowMsg+"����Ϊ��."
		}	
	
	})
	if(errMsg!=""){
		$.messager.alert($g("��ʾ:"),errMsg);
	}
	return errMsg;
}
