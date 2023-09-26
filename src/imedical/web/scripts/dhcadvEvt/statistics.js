// Creator: congyue
// CreateDate: 2016-03-03
// Descript: �ۺ�ͳ�Ʋ�ѯ

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
	if(!compareSelTowTime(StDate,EndDate)){
		
	   $.messager.alert("��ʾ:","��ʼ���ڲ��ܴ��ڽ������ڣ�");
		return false;
		}
	var params=StDate+"^"+EndDate;
	//alert(params)
	var type=$('#type').combobox('getValue');
	$('#maindg').datagrid({
		url:url+'?action=StatisticReport',	
		queryParams:{
			params:params}
	});
	if(type=="Pie"){
	$.ajax({
		type: "POST",
		url: url+"?action=AnalysisReport&params="+params,
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
		url: url+"?action=AnalysisReport&params="+params,
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