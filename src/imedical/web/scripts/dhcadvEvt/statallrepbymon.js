// Creator: yangyongtao
// CreateDate: 2016-03-14
// Descript: �����¼�ȫ����ͳ��

var url = "dhcadv.repaction.csp";
//var StDate=formatDate(-7);  //һ��ǰ������
//var EndDate=formatDate(0); //ϵͳ�ĵ�ǰ����

$(function(){
	//��ȡϵͳ������
    var now = new Date();
    var year = now.getFullYear();       //��
    var month = now.getMonth() + 1;     //��
    if(month<=9){
	    month="0"+month
	} 
    var  yearDate=""
    if(DateFormat=="4"){ //���ڸ�ʽ 4:"DMY" DD/MM/YYYY
        yearDate="01"+"/"+month+"/"+year
    }else if(DateFormat=="3"){ //���ڸ�ʽ 3:"YMD" YYYY-MM-DD
        yearDate=year+"-"+month+"-"+"01"
    }else if(DateFormat=="1"){ //���ڸ�ʽ 1:"MDY" MM/DD/YYYY
        yearDate=month+"/"+"01"+"/"+year
    }
	
	$("#stdate").datebox("setValue", yearDate);  //Init��ʼ����
	$("#enddate").datebox("setValue", formatDate(0));  //Init��������
    
	//��������
	$('#type').combobox({
		//panelHeight:"auto",  //���������߶��Զ�����
		url:url+'?action=selEvent'
		
	});
	
	$('#Find').bind("click",Query);  //�����ѯ
	StatAllRepByMon(); //��ʼ��ͳ���б�	
	
})
//��ѯ
 function Query()
{
	//1�����datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	//2����ѯ
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var typeCode=$('#type').combobox('getValue');  //��������

    if(!compareSelTowTime(StDate,EndDate)){	
	   $.messager.alert("��ʾ:","��ʼ���ڲ��ܴ��ڽ������ڣ�");
		return false;
	}
    
    
	if(typeof typeCode == "undefined"){typeCode=""}	

	var params=StDate+"^"+EndDate+"^"+typeCode;
	
	$('#maindg').datagrid({
		url:url+'?action=StatAllRepByMon',	
		queryParams:{
			params:params}
	});
	
	$.ajax({
		type: "POST",
		url: url+"?action=AnalysisRepByMon&params="+params,
		success: function(jsonString){
			var ListDataObj = jQuery.parseJSON(jsonString);
			var option = ECharts.ChartOptionTemplates.Lines(ListDataObj); 
			option.title ={
				//text: '������Ӧ�¼�ͳ�Ʒ���',
				//subtext: '��״ͼ',
				//x:'center'
			}
			var container = document.getElementById('charts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	});
}
//��ʼ��ͳ���б�
function StatAllRepByMon()
{
	//����columns
	var columns=[[
		{field:"name",title:'�·�',width:150,align:'center'},
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
		//rownumbers:true,//�к�  
		pagination:true

	});
	initScroll("#maindg");//��ʼ����ʾ���������
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
}
