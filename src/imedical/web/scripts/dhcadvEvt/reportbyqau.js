// Creator: yangyongtao
// CreateDate: 2017-09-20
// Descript: �����¼�����ͳ�� 

var url = "dhcadv.repaction.csp";

 $(function(){
	 
	 //���
	$("#yearChoose").combobox({   
      valueField:'year',    
      textField:'year' 
      //panelHeight:'auto' //auto���������߶��Զ�����,(���ù̶�������ʾ��������)
 
     });   	
   var data = [];//�����������
   var startYear;//��ʼ���
   var thisYear=new Date().getUTCFullYear();//����
   var endYear=thisYear+1;//�������
   //�������ֵ��2006-2016��//��������Լ��޸�
   for(startYear=endYear-10;startYear<endYear;startYear++)
    {
         data.push({"year":startYear});
    }
   
   $("#yearChoose").combobox("setValue", thisYear); //Ĭ�ϵ�ǰ��
   
   $("#yearChoose").combobox("loadData", data);//�������������
       
   

	//��������
	$('#type').combobox({
		//panelHeight:"auto",  //���������߶��Զ�����
		url:url+'?action=selEvent'	
	});
	
	
 	//��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
		});
	});
		
	$('#Find').bind("click",Query);  //�����ѯ
	StatAllRepByQau(); //��ʼ��ͳ���б�	
	
})
	
//��ѯ
 function Query()
{
	//1�����datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	//2����ѯ
	//������Ϣ
	 var SeasonCode="";
    if($("#seaone").is(':checked')){
	    SeasonCode+='1,';
	}; //��һ����
    if($("#seatwo").is(':checked')){
	    SeasonCode+='2,';
	}; //�ڶ�����
    if($("#seathree").is(':checked')){
	    SeasonCode+='3,';
    }; //��������
    if($("#seafour").is(':checked')){
	    SeasonCode+='4,';
	}; //���ļ���
	SeasonCode=SeasonCode==''?'':SeasonCode.substring(0,SeasonCode.length-1); 
	
	var yearCode=$('#yearChoose').combobox('getValue');  //���
	var typeCode=$('#type').combobox('getValue');  //��������
	if(typeof typeCode == "undefined"){typeCode=""}	//�������û�ж��壬�͸�ֵΪ��	
	var params=yearCode+"^"+typeCode+"^"+SeasonCode;
	//(function(){
		$('#maindg').datagrid({
			url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYQAU&MethodName=QueryRepByQau',
			//url:url+'?action=StatAllRepByQau',	
			queryParams:{
				params:params}
		});
	//})();
	$.ajax({
		type: "POST",
		url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYQAU&MethodName=AnalysisRepByQau'+'&params='+params,
		//url: url+"?action=AnalysisRepByQau&params="+params,
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


	//��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			setCheckBoxRelation(this.id);
		});
	});


//��ʼ��ͳ���б�
function StatAllRepByQau()
{
	//����columns
	var columns=[[
		{field:"name",title:'����',width:169,align:'center'},
		{field:'value',title:'����',width:169,align:'center'},
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
