// Creator: yangyongtao
// CreateDate: 2017-09-26
// Descript:���ȼ�ͳ��
var url = "dhcadv.repaction.csp";
var TypeArr = [{"value":"Pie","text":'��״ͼ'}, {"value":"Bars","text":'����ͼ'}];
var LevelArr = [{"value":"��","text":'һ��'},{"value":"��","text":'����'}, {"value":"��","text":'����'},{"value":"����","text":'�ļ�'}];
$(function(){
	$("#stdate").datebox("setValue", formatDate(-7));  //Init��ʼ����
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
	$('#type').combobox('setValue',"Pie");   
	//$('#Find').bind("click",Query);  //�����ѯ
	//�ȼ�
	$('#level').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:LevelArr
	});
	
    // ���Ұ�ť�󶨵����¼�  
    $('#Find').bind('click',function(event){
         Query(); //���ò�ѯ
    });
	
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
	var level=$('#level').combobox('getValue');
	if (level==undefined){level="";}
	var reptype=$('#reptype').combobox('getValue');  //��������
	if (reptype==undefined){reptype="";}
	var params=StDate+"^"+EndDate+"^"+level+"^"+reptype;
	var type=$('#type').combobox('getValue');
	$('#maindg').datagrid({
		//url:url+'?action=QueryLelStatic',	
		url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYLEVEL&MethodName=QueryLelStatic',
		queryParams:{
			params:params}
	});
	if(type=="Pie"){
	$.ajax({
		type: "POST",
		data : {'params':params},
		//url: url+"?action=QueryLelAnalysis&params="+params,
		url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYLEVEL&MethodName=QueryLelAnalysis',
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
		data : {'params':params},
		url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYLEVEL&MethodName=QueryLelAnalysis', //+'&params='+params,
		//url: url+"?action=QueryLelAnalysis&params="+params,
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
		{field:"name",title:'�¼��ȼ�',width:150,align:'center'},
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
	//initScroll("#maindg");//��ʼ����ʾ���������
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
}
