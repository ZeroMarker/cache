// Creator: congyue
// CreateDate: 2016-04-05
// Descript: �����¼��ȼ�ͳ��

var url = "dhcadv.repaction.csp";
var TypeArr = [{"value":"Pie","text":'��״ͼ'}, {"value":"Bars","text":'����ͼ'}];
var LevelArr = [{"value":"0","text":'�ǲ����¼�'}, {"value":"1","text":'��'},{"value":"2","text":'��'}, {"value":"3","text":'��'},{"value":"4","text":'����'}];
$(function(){
	$("#stdate").datebox("setValue", formatDate(-7));  //Init��ʼ����
	$("#enddate").datebox("setValue", formatDate(0));  //Init��������
	//����
	$('#type').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:TypeArr
	});
	//��������  wangxuejian 2016/11/4
	$('#reporttype').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
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
    $('#find').bind('click',function(event){
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
	
	if(!compareSelTowTime(StDate,EndDate)){
		
	   $.messager.alert("��ʾ:","��ʼ���ڲ��ܴ��ڽ������ڣ�");
		return false;
	}
	var level=$('#level').combobox('getValue');
	if (level==undefined){level="";}
	var reporttype=$('#reporttype').combobox('getValue');  //��������
	if (reporttype==undefined){reporttype="";}
	var params=StDate+"^"+EndDate+"^"+level+"^"+reporttype;
	var type=$('#type').combobox('getValue');
	
	$('#maindg').datagrid({
		url:url+'?action=QueryLelStatic',	
		queryParams:{
			params:params}
	});
	if(type=="Pie"){
	$.ajax({
		type: "POST",
		url: url+"?action=QueryLelAnalysis&params="+params,
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
		url: url+"?action=QueryLelAnalysis&params="+params,
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
	initScroll("#maindg");//��ʼ����ʾ���������
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
}