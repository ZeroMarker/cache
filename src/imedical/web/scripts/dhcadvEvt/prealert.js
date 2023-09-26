/// Creator: congyue
/// CreateDate: 2016-04-29
//  Descript: Ԥ��ƽ̨

var url = "dhcadv.repaction.csp";
$(function(){
	var myDate = new Date();
	var StDate="";
	if(DateFormat=="4"){ //���ڸ�ʽ 4:"DMY" DD/MM/YYYY
		StDate="01"+"/"+"01"+"/"+myDate.getFullYear();  //���꿪ʼ����
	}else if(DateFormat=="3"){ //���ڸ�ʽ 3:"YMD" YYYY-MM-DD
		StDate=myDate.getFullYear()+"-"+"01"+"-"+"01";  //���꿪ʼ����
	}else if(DateFormat=="1"){ //���ڸ�ʽ 1:"MDY" MM/DD/YYYY
		StDate="01"+"/"+"01"+"/"+myDate.getFullYear();  //���꿪ʼ����
	}
	var date=CurentTime(); //��ȡ��ǰ����
	var params=StDate+"^"+date;
	var param=StDate+"^"+date+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID;
	WardInfo(); //��ʼ��ͳ���б�
	UntreatedInfo();//���챨��ͳ���б�
	//����ͳ��
	$('#warddg').datagrid({
		url:url+'?action=StaticPreAlert',	
		queryParams:{
			params:params}
	});
	
	$('#untreated').datagrid({
	  url:url+'?action=UntreatedList',	
		queryParams:{
			param:param}
	});

	//ҽ�Ƶȼ��ֲ�
	$.ajax({
		type: "POST",
		url: url+"?action=QueryLelAnalysis&params="+params,
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
	});
	//�����ֲ�
	$.ajax({
		type: "POST",
		url: url+"?action=AnalyPreAlert&params="+params,
		success: function(jsonString){

			var ListDataObj = jQuery.parseJSON(jsonString);
			var option = ECharts.ChartOptionTemplates.Bars(ListDataObj); 
			option.title ={
				//text: '�����ֲ�',
				//subtext: '��״ͼ',
				//x:'center'
			}
			var container = document.getElementById('wardcharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	});
})

// ���챨���ʼ���б�
function UntreatedInfo(){
		//����columns
	var columns=[[
		{field:'name',title:'��������',width:150,align:'center'},
		{field:'value',title:'��������',width:150,align:'center'},
	]];
	//����datagrid
	$('#untreated').datagrid({
		//url: url+"?action=UntreatedList&param="+param,
		url:'',
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
function WardInfo()
{
	//����columns
	var columns=[[
		{field:"name",title:'����',width:150,align:'center',sortable:true},
		{field:'reptype',title:'��������',width:150,align:'center'},
		{field:'value',title:'��������',width:150,align:'center'},
	]];
	//����datagrid
	$('#warddg').datagrid({
		url:'',
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