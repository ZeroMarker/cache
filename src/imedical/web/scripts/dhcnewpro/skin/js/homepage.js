/// Creator: congyue
/// CreateDate: 2017-09-29
//  Descript: ��ҳ

var url = "dhcadv.repaction.csp";
var StrParam="";
var StDate="";
$(function(){
	
	initParams();    //��ȡһ�½���ȫ�ֱ���

	 //hxy 2017-09-05 ���ͳ�ơ���ѯ�������������Ӧλ��
	 $("#w_click_show").css("left",102+($(window).width()-1164)/2);
	 $("#w_click_show,#c_click_show,#s_click_show").css("top",95);//2017-10-12 add ����ie8(��)
	 $("#c_click_show").css("left",507+($(window).width()-1164)/2);
	 $("#s_click_show").css("left",900+($(window).width()-1164)/2);
	 //hxy 2017-09-05 ���ͳ�ơ���ѯ�������ʾ��������
	 $("#w_click_show,#c_click_show,#s_click_show").mouseleave(function(){
	   $(this).hide();
	 });
	 //hxy 2017-08-21 ����С��������Ӧpadding
	 $(".index-function-button-one i").each(function(){
	    if($(this).text()!=""){
		    $(this).addClass("index-function-button-num")
		}else{
 			$(this).next().css("margin-top","17px");//hxy 2017-09-29
		}
	 });
	 $(".index-function-button-two i").each(function(){
	    if($(this).text()!=""){
		    $(this).addClass("index-function-button-num")
		}else{
			$(this).parent().find("p").css("margin-top","17px");//09-29 ��̬��ֵ���ֺ�������ƫ��
		}
	 });//hxy end	
	$("#gologin").hide(); //2017-11-23 cy ������ҳ��ť
	var myDate = new Date();
	
	//var DateFormat="3" ;
	if(DateFormat=="4"){ //���ڸ�ʽ 4:"DMY" DD/MM/YYYY
		StDate="01"+"/"+"01"+"/"+"2018";  //���꿪ʼ����
	}else if(DateFormat=="3"){ //���ڸ�ʽ 3:"YMD" YYYY-MM-DD
		StDate="2018"+"-"+"01"+"-"+"01";  //���꿪ʼ����
	}else if(DateFormat=="1"){ //���ڸ�ʽ 1:"MDY" MM/DD/YYYY
		StDate="01"+"/"+"01"+"/"+"2018";  //���꿪ʼ����
	}
	var date=formatDate(0);  //CurentTime(); //��ȡ��ǰ����
	var params=StDate+"^"+date;
	var param=StDate+"^"+date+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID;
	StaticbyType(myDate.getFullYear());//�����¼�������ͳ��
	StaticbyMon(myDate.getFullYear()); //�����¼�����ͳ��
	
	//StaticbyTypeLoc(myDate.getFullYear());//�����¼�������ͳ�� ������
	WardInfo(params); //��ʼ��ͳ���б�  �����ֲ�
	/* //����ͳ��
	$('#untreated').datagrid({
	  url:url+'?action=UntreatedList',	
		queryParams:{
			param:param}
	}); */
	/* //����ͳ��
	$('#warddg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=StaticPreAlert'+'&params='+params,
		queryParams:{
			param:params}
	}); 
	
	//ҽ�Ƶȼ��ֲ�
	$.ajax({
		type: "POST",
		url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYLEVEL&MethodName=QueryLelAnalysis'+'&params='+params,
		success: function(jsonString){

			var ListDataObj = jQuery.parseJSON(jsonString);
			var option = ECharts.ChartOptionTemplates.Bars(ListDataObj); 
			option.title ={
				//text: 'ҽ�Ƶȼ��ֲ�',
				//subtext: '��״ͼ',
				//x:'center'
			}
			var container = document.getElementById('medcharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	});*/
	
	if((LgGroupDesc=="����")||(LgGroupDesc=="Nursing Manager")){
		$('#HomeStatusList').hide(); //�����б�չ��
		//$('#TypeListWard').show();  //�����б�չ��
		
		//$('#TypeListLoc').hide();  //�����б�չ��
		//$('#MonList').show();  //�����б�չ��
		$('#cancel').show();  //������ѯ��������չ��
	}else{
		$('#HomeStatusList').show();
		//WardInfo(params); //��ʼ��ͳ���б�
		//$('#TypeListWard').show();
		//$('#TypeListLoc').hide();
		//$('#MonList').show();
		$('#cancel').hide(); 
	} 
})

// ���챨���ʼ���б�
function UntreatedInfo(param){
		//����columns
	var columns=[[
		{field:'name',title:'��������',width:150,align:'center'},
		{field:'value',title:'��������',width:150,align:'center'}
	]];
	//����datagrid
	$('#untreated').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=UntreatedList'+'&param='+param,
		//url:'',
		fit:true,
		columns:columns,
		rownumbers:true,
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		showFooter:true,
		pageSize:10,  // ÿҳ��ʾ�ļ�¼����
		pageList:[10,20,30],
		pagination:true
	});
	initScroll("#untreated");//��ʼ����ʾ���������
	}

//��ʼ��ͳ���б�
function WardInfo(params)
{
	//����columns
	var columns=[[
		{field:"name",title:'����',width:150,align:'center',sortable:true},
		{field:'reptype',title:'��������',width:150,align:'center'},
		{field:'value',title:'��������',width:150,align:'center'}
	]];
	//����datagrid
	$('#warddg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=StaticPreAlert'+'&params='+params,
		fit:true,
		columns:columns,
		rownumbers:true,
		remoteSort:false,  //��������
		sortName:'name',
		sortOrder:'asc',
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		showFooter:true,
		pageSize:10,  // ÿҳ��ʾ�ļ�¼����
		pageList:[10,20,30],
		pagination:true
	});
	initScroll("#warddg");//��ʼ����ʾ���������
	
}

//��ȡ��ǰ����
function CurentTime()
{ 
	var now=new Date();
	var year=now.getFullYear();  //��
	var month=now.getMonth() + 1;  //��
	var day=now.getDate();  //��
	var clock=year+"-";
	
	if(month<10)
	clock+="0";
	clock+=month+"-";
	if(day<10)
	clock+="0";
	clock+=day;
 	return(clock);
}
///�¼�� ����
function JumpBtn(){
	$("#w_click_show").show();
	var UserList=LgUserID+"^"+LgCtLocID+"^"+LgGroupID;
    $.ajax({
		type: "POST",
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=GetRepTypeList'+'&UserList='+UserList,		
		async: false, //ͬ��
		dataType: "json", 
		success: function(data){
		var htmlname='<img style="margin-top:-30px" src="../scripts/dhcnewpro/images/adv_top.png" alt="" width="28" height="28">';
		    var htmlstr = "";
		    //alert(data.length);
			for (var i=0; i<data.length; i++){
		        htmlstr = htmlstr +'<div class="w_click_row"><div class="w_click_par"><div class="w_click" id="'+ data[i].id +'" onclick="InterfaceJump(this.id,this.innerText)">'+ data[i].value +'</div></div></div>'
		    }
		    $('#w_click_show').html(htmlname+htmlstr);   //InterfaceJump(this.id)
		    //layoutform.csp?code=advNursing
		}});
}

///ͳ�Ʒ��� ���� 2017-11-15
function StaticBtn(){
	$("#c_click_show").show();
	$("#reportbydt").unbind();
	//�����¼���̬ͳ��
	$("#reportbydt").click(function(){
	   var Rel='dhcadv.statisticsdhcadv.csp';
		location.href=Rel;
	});
	
	/* //���ȼ�ͳ��
	$("#reportbylevel").click(function(){
	   var Rel='dhcadv.reportbylevel.csp';
		location.href=Rel;
	});
	//���¼�����ͳ��
	$("#reportbyevent").click(function(){
	   var Rel='dhcadv.reportbyevent.csp';
		location.href=Rel;
	});
	//�����¼�����ͳ��
	$("#reportbymon").click(function(){
	   var Rel='dhcadv.reportbymon.csp';   //qqa
	   //var Rel='dhcadv.statisticsdhcadv.csp';
		location.href=Rel;
	});
	//�����¼�������ͳ��
	$("#reportbyqau").click(function(){
	   var Rel='dhcadv.reportbyqau.csp';
		location.href=Rel;
	});
	//������/������������ͳ��
	$("#reportbyctloc").click(function(){
	   var Rel='dhcadv.reportbyctloc.csp';
		location.href=Rel;
	});
	//ѹ�������ʼ���
	$("#PreSorePerQuarter").click(function(){
	   var Rel='dhccpmrunqianreport.csp?reportName=DHCADV_PreSorePerQuarter.raq';
		location.href=Rel;
	});
	//��ҩ������������ͳ��
	$("#MedErrorPerMonth").click(function(){
	   var Rel='dhccpmrunqianreport.csp?reportName=DHCADV_MedErrorPerMonth.raq';
		location.href=Rel;
	});
	//ȫ����¸���ѹ��ͳ��
	$("#PreSoresAtLevel").click(function(){
	   var Rel='dhccpmrunqianreport.csp?reportName=DHCADV_PreSoresAtLevel.raq';
		location.href=Rel;
	});
	//ȫ����¸��������¼�ͳ��
	$("#FallEventsAtLevels").click(function(){
	   var Rel='dhccpmrunqianreport.csp?reportName=DHCADV_FallEventsAtLevels.raq';
		location.href=Rel;
	});
	//����Ժ�ڷ���ѹ����ͳ��
	$("#InPerPSore").click(function(){
	   var Rel='dhccpmrunqianreport.csp?reportName=DHCADV_InPerPSore.raq';
		location.href=Rel;
	});
	//Ժ�ڸ���λѹ����ͳ��
	$("#InPartPSore").click(function(){
	   var Rel='dhccpmrunqianreport.csp?reportName=DHCADV_InPartPSore.raq';
		location.href=Rel;
	});
	//��Σ���ߵ����������±�
	$("#HRPatFallIncidence").click(function(){
	   var Rel='dhccpmrunqianreport.csp?reportName=DHCADV_HRPatFallIncidence.raq';
		location.href=Rel;
	});
	//���˺������������±�
	$("#HurtFall").click(function(){
	   var Rel='dhccpmrunqianreport.csp?reportName=DHCADV_HurtFall.raq';
		location.href=Rel;
	});
	//��Ժ����ѹ����ͳ��
	$("#OutPressureNumber").click(function(){
	   var Rel='dhccpmrunqianreport.csp?reportName=DHCADV_OutPressureNumber.raq';
		location.href=Rel;
	});
	//ѹ���������±�
	$("#PreUlcer").click(function(){
	   var Rel='dhccpmrunqianreport.csp?reportName=DHCADV_PreUlcer.raq';
		location.href=Rel;
	});
	//�����������±�
	$("#PreSlip").click(function(){
	   var Rel='dhccpmrunqianreport.csp?reportName=DHCADV_PreSlip.raq';
		location.href=Rel;
	});
	//��Σѹ���������±�
	$("#PreHighScore").click(function(){
	   var Rel='dhccpmrunqianreport.csp?reportName=DHCADV_PreHighScore.raq';
		location.href=Rel;
	}); */
	

}

///�����ۺϲ�ѯ ����
function QueryBtn(){
	$("#s_click_show").show();
	$("#query").click(function(){
	   var Rel='dhcadv.reportquery.csp?StrParam='+"";
		location.href=Rel;
	});
	$("#audit").click(function(){
	   var Rel='dhcadv.reportaudit.csp?StrParam='+"";
		location.href=Rel;
	});
	$("#cancel").click(function(){
	   var Rel='dhcadv.reportquery.csp?cancelflag='+"Y";
		location.href=Rel;
	});
	
}

//�ռ�һ�� ����  �����ձ�ʶΪ1 �������Լ�����������  ��Ϊ���˽��չ��ı��棩
function RecListBt(){
	var StsDate=StDate;  //һ��ǰ������
	var EndDate=formatDate(0); //ϵͳ�ĵ�ǰ����
	var StrParam=StsDate+"^"+EndDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^^1^^Y^^^^^^^";
	var Rel='dhcadv.reportaudit.csp?StrParam='+StrParam+'&audittitle='+"(�ռ�һ��)";
	location.href=Rel;
}
//�ѱ��¼� ����  �������ڱ��������ύ�ı��棩
function CompleBt(){
	var StsDate=StDate;  //һ��ǰ������
	var EndDate=formatDate(0); //ϵͳ�ĵ�ǰ����
	var StrParam=StsDate+"^"+EndDate+"^"+LgCtLocID+"^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^Y^^^^Y^^N^^^";
	var Rel='dhcadv.reportquery.csp?StrParam='+StrParam+'&querytitle='+"(�ѱ��¼�)";
	location.href=Rel;
}
// �ص��ע ����
function RepImpBt(){
	var StsDate=StDate;  //һ��ǰ������
	var EndDate=formatDate(0); //ϵͳ�ĵ�ǰ����
	var StrParam=StsDate+"^"+EndDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^^^^^"+"Y"+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+"";
	var Rel='dhcadv.reportaudit.csp?StrParam='+StrParam+'&audittitle='+"(�ص��ע)";
	location.href=Rel;
}
//�ݸ��� ����
function DraftsBt(){
	var StsDate=StDate;  //һ��ǰ������
	var EndDate=formatDate(0); //ϵͳ�ĵ�ǰ����
	var StrParam=StsDate+"^"+EndDate+"^"+LgCtLocID+"^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^N^^^^N^^^^";
	var Rel='dhcadv.reportquery.csp?StrParam='+StrParam+'&querytitle='+"(�ݸ���)";
	location.href=Rel;
}
//�鵵�¼�
function FileBt(){
	var StsDate=StDate;  //һ��ǰ������
	var EndDate=formatDate(0); //ϵͳ�ĵ�ǰ����
	var StrParam=StsDate+"^"+EndDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^^^^^^^^^Y^^";  //19
	var Rel='dhcadv.reportaudit.csp?StrParam='+StrParam+'&audittitle='+"(�鵵�¼�)";
	location.href=Rel;
}
//����������
function PendAuditBt(){
	var StsDate=StDate;  //һ��ǰ������
	var EndDate=formatDate(0); //ϵͳ�ĵ�ǰ����
	var StrParam=StsDate+"^"+EndDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^^^^^^Y^^^^^";
	var Rel='dhcadv.reportaudit.csp?StrParam='+StrParam+'&audittitle='+"(����������)";
	location.href=Rel;
}
//���˻ر��� ����
function BackBt(){
	var StsDate=StDate;  //һ��ǰ������
	var EndDate=formatDate(0); //ϵͳ�ĵ�ǰ����
	var StrParam=StsDate+"^"+EndDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^^2^^^^^Y^^^^";
	var Rel='dhcadv.reportaudit.csp?StrParam='+StrParam+'&audittitle='+"(���˻ر���)";
	location.href=Rel;
}
//��дʱ��
function FillTimeBt(){
	var StsDate=StDate;  //һ��ǰ������
	var EndDate=formatDate(0); //ϵͳ�ĵ�ǰ����
	var RepLoc=LgCtLocID;
	var StrParam=StsDate+"^"+EndDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^^^^^^^^Y^";
	var Rel='dhcadv.reportquery.csp?StrParam='+StrParam+'&querytitle='+"(��дʱ��)";
	location.href=Rel;
}
//����ʱ��
function AcceptTimeBt(){
	var StsDate=StDate;  //һ��ǰ������
	var EndDate=formatDate(0); //ϵͳ�ĵ�ǰ����
	var StrParam=StsDate+"^"+EndDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^^^^^^^^^^^Y";
	var Rel='dhcadv.reportaudit.csp?StrParam='+StrParam+'&audittitle='+"(����ʱ��)";
	location.href=Rel;
}
//ȫ���Ѵ�����
function AuditBt(){
	var StsDate=StDate;  //һ��ǰ������
	var EndDate=formatDate(0); //ϵͳ�ĵ�ǰ����
	var StrParam=StsDate+"^"+EndDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^^^^^^^^Y^^^";
	var Rel='dhcadv.reportaudit.csp?StrParam='+StrParam+'&audittitle='+"(ȫ���Ѵ�����)";
	location.href=Rel;
}
//�����¼�������ͳ��
function StaticbyType(StDateYear)
{
	var params=StDateYear+"-"+"01"+"-"+"01"+"^"+StDateYear+"-"+"12"+"-"+"31"+"^"+""+"^"+""+"^"+"";
	$.ajax({
		type: "POST",
		url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYEVENT&MethodName=AnalysisReport'+'&params='+params,
		//url: url+"?action=AnalysisReport&params="+params,
		success: function(jsonString){
			var ListDataObj = jQuery.parseJSON(jsonString);
			var option = ECharts.ChartOptionTemplates.Bars(ListDataObj); 
			option.title ={
				
			}
			var container = document.getElementById('typecharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	});
}

//�����¼�������ͳ��
function StaticbyTypeLoc(StDateYear)
{
	var params=StDateYear+"-"+"01"+"-"+"01"+"^"+StDateYear+"-"+"12"+"-"+"31"+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID;
	$.ajax({
		type: "POST",
		url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYEVENT&MethodName=AnalysisReport'+'&params='+params,
		//url: url+"?action=AnalysisReport&params="+params,
		success: function(jsonString){
			var ListDataObj = jQuery.parseJSON(jsonString);
			var option = ECharts.ChartOptionTemplates.Bars(ListDataObj); 
			option.title ={
				
			}
			var container = document.getElementById('typeloccharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	});
}


//�����¼�����ͳ��
 function StaticbyMon(StDateYear)
{
	//1�����datagrid 
	//$('#dgbymon').datagrid('loadData', {total:0,rows:[]}); 
	//2����ѯ

	var params=StDateYear+"-"+"01"+"-"+"01"+"^"+StDateYear+"-"+"12"+"-"+"31"+"^"+"";
	var columns=[[
		{field:"name",title:'�·�',width:150,align:'center'},
		{field:'value',title:'����',width:150,align:'center'}
	]];
	//����datagrid
	$('#dgbymon').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYMON&MethodName=StatAllRepByMon'+'&params='+params,		
		fit:true,
		columns:columns,
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		showFooter:true,
		pageSize:10,  // ÿҳ��ʾ�ļ�¼����
		pageList:[10,20,30],
		pagination:true,
		height:200

	});
	initScroll("#dgbymon");//��ʼ����ʾ���������
		
	$.ajax({
		type: "POST",
		url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYMON&MethodName=AnalysisRepByMon'+'&params='+params,	
		//url: url+"?action=AnalysisRepByMon&params="+params,
		success: function(jsonString){
			var ListDataObj = jQuery.parseJSON(jsonString);
			var option = ECharts.ChartOptionTemplates.Lines(ListDataObj); 
			option.title ={
				//text: '������Ӧ�¼�ͳ�Ʒ���',
				//subtext: '��״ͼ',
				//x:'center'
			}
			var container = document.getElementById('moncharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	});
}



function initParams(){
	var params = LgHospID+"^"+LgCtLocID+"^"+LgGroupID+"^"+LgUserID
	$.ajax({
		type: "POST",
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=GetParams'+'&params='+params,	
		success: function(ret){
			showStatic = ret;
		},
		dataType: "text",
	});
}
