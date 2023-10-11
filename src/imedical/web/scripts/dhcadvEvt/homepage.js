/// Creator: congyue
/// CreateDate: 2017-09-29
//  Descript: ��ҳ

var url = "dhcadv.repaction.csp";
var StrParam="";
var StDate="";
var EndDate="";
$(function(){
	InitPageComponent(); 	  /// ��ʼ������ؼ�����
	InitPageDataList();		  /// ��ʼ��ҳ����,ͼ�η��� ����
	InitPageStyle();          /// ��ʼ��ҳ����ʽ
})
/// ��ʼ������ؼ�����
function InitPageComponent(){
	 //hxy 2017-09-05 ���ͳ�ơ���ѯ�������ʾ��������
	 $("#w_click_show,#c_click_show,#s_click_show").mouseleave(function(){
	   $(this).hide();
	 });
	$("#gologin").hide(); //2017-11-23 cy ������ҳ��ť
	/* var myDate = new Date();
	if(DateFormat=="4"){ //���ڸ�ʽ 4:"DMY" DD/MM/YYYY
		StDate="01"+"/"+"01"+"/"+"2018";  //���꿪ʼ����
		EndDateByYear="31"+"/"+"12"+"/"+myDate.getFullYear()
	}else if(DateFormat=="3"){ //���ڸ�ʽ 3:"YMD" YYYY-MM-DD
		StDate="2018"+"-"+"01"+"-"+"01";  //���꿪ʼ����
		EndDateByYear=myDate.getFullYear()+"-"+"12"+"-"+"31"
	}else if(DateFormat=="1"){ //���ڸ�ʽ 1:"MDY" MM/DD/YYYY
		StDate="01"+"/"+"01"+"/"+"2018";  //���꿪ʼ����
		EndDateByYear="12"+"/"+"31"+"/"+myDate.getFullYear()
	} */
	if((LgGroupDesc=="����")||(LgGroupDesc=="Nursing Manager")){
		$('#cancel').show();  //������ѯ��������չ��
	}else{
		$('#cancel').hide(); 
	} 
	runClassMethod("web.DHCADVCOMMON","GetStaEndDate",{'LgParam':LgParam},function(data){
		var tmp=data.split("^"); 
		StDate=tmp[0];
		EndDate=tmp[1];
	},'',false)
}

/// ��ʼ��ҳ����,ͼ�η��� ����
function InitPageDataList(){
	var DateList=StDate+"^"+EndDate;
	StaticbyType(DateList);//�����¼�������ͳ��
	StaticbyMon(DateList); //�����¼�����ͳ��
	WardInfo(DateList); //��ʼ��ͳ���б�  �����ֲ�
}
/// ��ʼ��ҳ����ʽ
function InitPageStyle(){
	 //hxy 2017-09-05 ���ͳ�ơ���ѯ�������������Ӧλ��
	 $("#w_click_show").css("left",102+($(window).width()-1164)/2);
	 $("#w_click_show,#c_click_show,#s_click_show").css("top",95);//2017-10-12 add ����ie8(��)
	 $("#c_click_show").css("left",507+($(window).width()-1164)/2);
	 $("#s_click_show").css("left",900+($(window).width()-1164)/2);
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
}
// ���챨���ʼ���б�
function UntreatedInfo(param){
		//����columns
	var columns=[[
		{field:'name',title:$g("��������"),width:150,align:'center'},
		{field:'value',title:$g("��������"),width:150,align:'center'}
	]];
	//����datagrid
	$('#untreated').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=UntreatedList'+'&param='+param,
		//url:'',
		fit:true,
		columns:columns,
		rownumbers:true,
	    singleSelect:false,
		loadMsg: $g("���ڼ�����Ϣ..."),
		showFooter:true,
		pageSize:10,  // ÿҳ��ʾ�ļ�¼����
		pageList:[10,20,30],
		pagination:true
	});
	initScroll("#untreated");//��ʼ����ʾ���������
	}

//��ʼ��ͳ���б�
function WardInfo(param)
{
	//����columns
	var columns=[[
		{field:"name",title:$g("����/����"),width:150,align:'center',sortable:true},
		{field:'reptype',title:$g("��������"),width:150,align:'center'},
		{field:'value',title:$g("��������"),width:150,align:'center'}
	]];
	//����datagrid
	$('#warddg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=StaticPreAlert'+'&params='+param+'&LgParam='+LgParam,
		fit:true,
		columns:columns,
		rownumbers:true,
		remoteSort:false,  //��������
		sortName:'name',
		sortOrder:'asc',
	    singleSelect:false,
		loadMsg: $g("���ڼ�����Ϣ..."),
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
	var UserList=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+LgHospID;
    $.ajax({
		type: "POST",
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=GetRepTypeByWFList'+'&UserList='+UserList,		
		async: false, //ͬ��
		dataType: "json", 
		success: function(data){
		var htmlname='<img style="margin-top:-30px" src="../scripts/dhcadvEvt/images/adv_top.png" alt="" width="28" height="28">';
		    var htmlstr = "";
			for (var i=0; i<data.length; i++){
		        htmlstr = htmlstr +'<div class="w_click_row"><div class="w_click_par"><div class="w_click" id="'+ data[i].id +'" onclick="HomeInterfaceJump(this.id,this.innerText)">'+ data[i].value +'</div></div></div>'
		    }
		    $('#w_click_show').html(htmlname+htmlstr);   //InterfaceJump(this.id)
		}});
}

///ͳ�Ʒ��� ���� 2017-11-15
function StaticBtn(){
	$("#c_click_show").show();
	//�����¼���̬ͳ��
	$("#reportbydt").click(function(){
	   //var Rel='dhcadv.reportbymon.csp';   //qqa
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
	
	$("#reportbyml").click(function(){
	   var Rel='dhcadv.exportbylocmon.csp';
		location.href=Rel;
	});
	$("#reportbyqm").click(function(){
	   var Rel='dhcadv.reportbymon.csp';
		location.href=Rel;
	});
	
	$("#compstaquery").click(function(){
	   var Rel="dhcadv.model.report.csp?&code=" +""+'&quoteflag=1';
		location.href=Rel;
	});
}

///�����ۺϲ�ѯ ����
function QueryBtn(){
	$("#s_click_show").show();
	$("#querylink").click(function(){
	   var Rel='dhcadv.reportquery.csp?StrParam='+"";
		location.href=Rel;
	});
	$("#auditlink").click(function(){
	   var Rel='dhcadv.reportaudit.csp?StrParam='+"";
		location.href=Rel;
	});
	$("#cancellink").click(function(){
	   var Rel='dhcadv.repcancel.csp?cancelflag='+"Y";
		location.href=Rel;
	});
	
}

//�ռ�һ�� ����  �����ձ�ʶΪ1 �������Լ�����������  ��Ϊ���˽��չ��ı��棩
function RecListBt(){
	var StrParam=StDate+"^"+EndDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^^^1^Y^^^^^^^^^^^^2";
	var Rel='dhcadv.reportaudit.csp?StrParam='+StrParam+'&audittitle='+encodeURI(encodeURI("(�ռ�һ��)"));
	location.href=Rel;
}
//�ѱ��¼� ����  �������ڱ��������ύ�ı��棩
function CompleBt(){
	var StrParam=StDate+"^"+EndDate+"^"+LgCtLocID+"^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^Y^^^^^^^^^^^^Y^^N^^1";
	var Rel='dhcadv.reportquery.csp?StrParam='+StrParam+'&querytitle='+encodeURI(encodeURI("(�ѱ��¼�)"));
	location.href=Rel;
}
// �ص��ע ����
function RepImpBt(){
	var StrParam=StDate+"^"+EndDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^^^^^Y^^^^^^^^^^^2";
	var Rel='dhcadv.reportaudit.csp?StrParam='+StrParam+'&audittitle='+encodeURI(encodeURI("(�ص��ע)"));
	location.href=Rel;
}
//�ݸ��� ����
function DraftsBt(){
	var StrParam=StDate+"^"+EndDate+"^"+LgCtLocID+"^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^N^^^^^^^^^^^^N^^N^^1";
	var Rel='dhcadv.reportquery.csp?StrParam='+StrParam+'&querytitle='+encodeURI(encodeURI("(�ݸ���)"));
	location.href=Rel;
}
//�鵵�¼�
function FileBt(){
	var StrParam=StDate+"^"+EndDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^^^^^^^^^Y^^^^^^^2";  //24
	var Rel='dhcadv.reportaudit.csp?StrParam='+StrParam+'&audittitle='+encodeURI(encodeURI("(�鵵�¼�)"));
	location.href=Rel;
}
//����������
function PendAuditBt(){
	var StrParam=StDate+"^"+EndDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^^^^^^Y^^^^^^^^^^2";
	var Rel='dhcadv.reportaudit.csp?StrParam='+StrParam+'&audittitle='+encodeURI(encodeURI("(����������)"));
	location.href=Rel;
}
//���˻ر��� ����
function BackBt(){
	var StrParam=StDate+"^"+EndDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^^^2^^^^Y^^^^^^^^^2";
	var Rel='dhcadv.reportaudit.csp?StrParam='+StrParam+'&audittitle='+encodeURI(encodeURI("(���˻ر���)"));
	location.href=Rel;
}
//��дʱ��
function FillTimeBt(){
	var RepLoc=LgCtLocID;
	var StrParam=StDate+"^"+EndDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^^^^^^^^^^^^^Y^^^1";
	var Rel='dhcadv.reportquery.csp?StrParam='+StrParam+'&querytitle='+encodeURI(encodeURI("(��дʱ��)"));
	location.href=Rel;
}
//����ʱ��
function AcceptTimeBt(){
	var StrParam=StDate+"^"+EndDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^^^^^^^^^^^Y^^^^^2";
	var Rel='dhcadv.reportaudit.csp?StrParam='+StrParam+'&audittitle='+encodeURI(encodeURI("(����ʱ��)"));
	location.href=Rel;
}
//ȫ���Ѵ�����
function AuditBt(){
	var StrParam=StDate+"^"+EndDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^^^^^^^^Y^^^^^^^^2";
	var Rel='dhcadv.reportaudit.csp?StrParam='+StrParam+'&audittitle='+encodeURI(encodeURI("(ȫ���Ѵ�����)"));
	location.href=Rel;
}
//�����¼�������ͳ��
function StaticbyType(DateList)
{
	$.ajax({
		type: "POST",
		url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYEVENT&MethodName=AnalysisReport'+'&params='+DateList+'&LgParam='+LgParam,
		success: function(jsonString){
			var ListDataObj = jQuery.parseJSON(jsonString);
			var option = ECharts.ChartOptionTemplates.Blt(ListDataObj,"","#"); 
			option.title ={
				
			}
			var container = document.getElementById('typecharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	});
}

//�����¼�������ͳ��
function StaticbyTypeLoc(DateList)
{
	$.ajax({
		type: "POST",
		url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYEVENT&MethodName=AnalysisReport'+'&params='+DateList+'&LgParam='+LgParam,
		success: function(jsonString){
			var ListDataObj = jQuery.parseJSON(jsonString);
			var option = ECharts.ChartOptionTemplates.Bars(ListDataObj,"","#"); 
			option.title ={
				
			}
			var container = document.getElementById('typeloccharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	});
}


//�����¼�����ͳ��
 function StaticbyMon(DateList)
{

	var params=DateList+"^"+"";
	var columns=[[
		{field:"name",title:$g("�·�"),width:150,align:'center'},
		{field:'value',title:$g("����"),width:150,align:'center'}
	]];
	//����datagrid
	$('#dgbymon').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYMON&MethodName=StatAllRepByMon'+'&params='+params+'&LgParam='+LgParam,		
		fit:true,
		columns:columns,
	    singleSelect:false,
		loadMsg: $g("���ڼ�����Ϣ..."),
		showFooter:true,
		pageSize:10,  // ÿҳ��ʾ�ļ�¼����
		pageList:[10,20,30],
		pagination:true,
		height:200

	});
	initScroll("#dgbymon");//��ʼ����ʾ���������
		
	$.ajax({
		type: "POST",
		url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYMON&MethodName=AnalysisRepByMon'+'&params='+params+'&LgParam='+LgParam,	
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
//congyue 2019-01-22 �����ҳ�������תҳ��
function HomeInterfaceJump(code,desc){
	if (code=="index"){
		Gologin();
	}else{
		var Rel='dhcadv.layoutform.csp?code='+code+'&desc='+desc+'&freshflag=0'+"&TmpEpisodeID=";
		location.href=Rel;
	}
}
//congyue 2017-09-06 �����ҳͼ�꣬������ҳ
function Gologin(){
	location.href='dhcadv.homepage.csp';
}
