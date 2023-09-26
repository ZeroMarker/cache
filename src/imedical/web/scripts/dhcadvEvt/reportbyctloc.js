// Creator: yangyongtao
// CreateDate: 2017-09-30
// Descript: ����������/������������ͳ��

var url = "dhcadv.repaction.csp";
var TypeArr = [{"value":"Pie","text":'��״ͼ'}, {"value":"Bars","text":'����ͼ'}];
$(function(){
	$("#stdate").datebox("setValue", formatDate(-2));  //Init��ʼ����
	$("#enddate").datebox("setValue", formatDate(0));  //Init��������
	//����
	$('#type').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:TypeArr
	});
	
	 //��������  
	$('#reptype').combobox({
		//panelHeight:"auto",  //���������߶��Զ�����
		url:url+'?action=selEvent'	
	});
	
	 //����
	$('#dept').combobox({
		//panelHeight:"auto",  //���������߶��Զ�����
		url:url+'?action=SelAllLoc'
		
	})
	$('#type').combobox('setValue',"Pie");   
	$('#Find').bind("click",Query);  //�����ѯ

	Statisticmain(); //��ʼ��ͳ���б�
})
//��ѯ
function Query()
{
	//1�����datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	//2����ѯ
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var reptype=$('#reptype').combobox('getValue');  //��������
	var LocID=$('#dept').combobox('getValue');     //����ID
    if(reptype == undefined){reptype=""}	
	if(LocID == undefined){LocID=""}
	var params=StDate+"^"+EndDate+"^"+reptype+"^"+LocID;
	alert(params)
	var type=$('#type').combobox('getValue');
	$('#maindg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYCTLOC&MethodName=StatAllRepByCTloc',
		//url:url+'?action=StatisticReport',	
		queryParams:{
			params:params}
	});
	if(type=="Pie"){
	$.ajax({
		type: "POST",
		url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYCTLOC&MethodName=AnalysisRepByCtLoc'+'&params='+params,
		//url: url+"?action=AnalysisReport&params="+params,
		success: function(jsonString){
			var ListDataObj = jQuery.parseJSON(jsonString);
			var option = ECharts.ChartOptionTemplates.Pie(ListDataObj); 
			option.title ={
				//text: '������Ӧ�¼�ͳ�Ʒ���',
				//subtext: '��״ͼ',
				//x:'center'
			}
			var container = document.getElementById('charts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	});}
	if(type=="Bars"){
	$.ajax({
		type: "POST",
		url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYCTLOC&MethodName=AnalysisRepByCtLoc'+'&params='+params,
		//url: url+"?action=AnalysisReport&params="+params,
		success: function(jsonString){
			var ListDataObj = jQuery.parseJSON(jsonString);
			var option = ECharts.ChartOptionTemplates.Bars(ListDataObj); 
			option.title ={
				//text: '������Ӧ�¼�ͳ�Ʒ���',
				//subtext: '��״ͼ',
				//x:'center'
			}
			var container = document.getElementById('charts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	});}
}
//��ʼ��ͳ���б�
function Statisticmain()
{
	//����columns
	var columns=[[
		{field:"name",title:'��������',width:150,align:'center'},
		{field:'value',title:'����',width:150,align:'center'},
	]];
	//����datagrid
	$('#maindg').datagrid({
		url:'',
		fit:true,
		columns:columns,
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		showFooter:true,
		pagination:true,
		onLoadSuccess: function (data) {
		}
	});
	initScroll("#maindg");//��ʼ����ʾ���������
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 

}
