/*
Creator:LiangQiang
CreatDate:2016-01-15
Description:֪ʶ�����ѯ
*/
var url='dhcpha.clinical.ckbaction.csp' ;
var levelArray=[{ "value":"", "text": "ȫ��" },{ "value": "C", "text": "����" },{ "value": "W", "text": "��ʾ" },{ "value": "S", "text": "��ʾ" }]; 


function BodyLoadHandler()
{	
	$("#stdate").datebox("setValue", formatDate(-1));  
	$("#enddate").datebox("setValue", formatDate(0));  
	
	$('#admLoc').combobox({
		mode:"remote",
		onShowPanel:function(){
			//$('#admLoc').combobox('reload',url+'?action=SelAllLoc')
			$('#admLoc').combobox('reload',url+'?action=GetAllLocNewVersion')
		}
	}); 
	
	// ������
	$('#levelMan').combobox({
		panelHeight:"auto", 
		data:levelArray
	});  
	$('#levelMan').combobox('setValue',""); //����comboboxĬ��ֵ
	
	//Ŀ¼
	$('#label').combobox({
		onShowPanel:function(){
			$('#label').combobox('reload',url+'?action=GetLabel');
		}
 	});  
	$('#label').combobox('setText',"ȫ��"); //����comboboxĬ��ֵ
	
	$('#Find').bind("click",Query);  //�����ѯ
	$('#reset').bind("click",Reset);  // ����	

	var columns =[[  
		      {field:'adm',title:'����id',width:50,hidden:true}, 
		      {field:'patNo',title:'�ǼǺ�',width:80,align:'center',hidden:true},
              {field:'patName',title:'��������',width:80,align:'center'},
			  {field:'medicalNo',title:'������',width:80,hidden:true}, 
			  {field:'admLocDesc',title:'�������',width:160},
			  {field:'admDate',title:'��������',width:80,align:'center'},
			  {field:'arcDesc',title:'ҽ������',width:200},
              {field:'doseQty',title:'����',width:60,align:'center'},
			  {field:'unitDesc',title:'������λ',width:60,align:'center'},
			  {field:'instrDesc',title:'�÷�',width:80,align:'center'},
			  {field:'phFreqDesc',title:'Ƶ��',width:80,align:'center'},
			  {field:'course',title:'�Ƴ�',width:60,align:'center'},
			  {field:'rmanf',title:'��������',width:200},
			  {field:'speciFaction',title:'���',width:80},
			  {field:'labelDesc',title:'Ŀ¼',width:80,align:'center'},
			  {field:'level',title:'������',width:80,align:'center'},
			  {field:'trueMsg',title:'��ʾ��Ϣ',width:300,showTip:true,tipWidth:450},
			  {field:'rowId',title:'rowId',hidden:true}
			  ]];

    $HUI.datagrid('#libdatagrid',{
		title:'',
		url:url+'?action=QueryLibOrdData',
		fit:true,
		rownumbers:true,
		showFooter:true,
		columns:columns,
		pageSize:100,  
		pageList:[100],   
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		singleSelect:true,
		idField:'rowid',
		striped: true, 
		pagination:true
		//nowrap:false
/* 		onLoadSuccess : function (data) {
		    if (data.total == 0) {
		        $('#libdatagrid').datagrid('insertRow', {
		            row : {}
		        });
		        $("tr[datagrid-row-index='0']").css({
		            "visibility" : "hidden"
		        });
		    }
		} */	
		
	});
	$('#libdatagrid').datagrid('loadData', {total:0,rows:[]}); 
	initScroll("#libdatagrid");//��ʼ����ʾ���������
}


//��ѯ
function Query()
{
    var stDate=$('#stdate').datebox('getValue');
	var endDate=$('#enddate').datebox('getValue');		//��ֹ����
	var levelMan=$('#levelMan').combobox('getValue');	//������
	var label=$('#label').combobox('getValue'); 		//Ŀ¼
	var labelDesc=$('#label').combobox('getText'); 	
	var admLoc=$('#admLoc').combobox('getValue'); 		//�������
	if (admLoc === undefined){
		admLoc = "";
	}
	
 	var params=stDate+"^"+endDate+"^"+levelMan+"^"+label+"^"+labelDesc+"^"+admLoc; 
 	
	$('#libdatagrid').datagrid({
		url:url+'?action=QueryLibOrdData',	
		queryParams:{
			params:params}
	});
	$('#libdatagrid').datagrid('loadData', {total:0,rows:[]});  
}

/// Description:	��ѯ��������
/// Creator:		QuNianpeng
/// CreateDate:		2017-09-18
function Reset()
{
	$("#stdate").datebox("setValue", formatDate(-1));  
	$("#enddate").datebox("setValue", formatDate(0));  
	
	$('#levelMan').combobox('setValue',"");
	$('#label').combobox('setValue',"");
	$('#admLoc').combobox('setValue',"");
	$('#label').combobox('setText',"ȫ��"); //����comboboxĬ��ֵ
	Query();
}

