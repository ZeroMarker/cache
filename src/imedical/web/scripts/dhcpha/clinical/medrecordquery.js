
/// Creator: bianshuai
/// CreateDate: 2014-06-22
//  Descript: ҩ����ѯ

//����Url
var url="dhcpha.clinical.action.csp";

$(function(){
	
	//����columns
	var columns=[[
	    {field:'AdmDr',title:'AdmDr',width:100},
		{field:'PatNo',title:'�ǼǺ�',width:80},
		{field:'PatName',title:'����',width:80},
		{field:'Ward',title:'����',width:160},
		{field:'AdmLoc',title:'�������',width:120},
		{field:'PatInDate',title:'��Ժʱ��',width:100},
		{field:'CreateTime',title:'����ʱ��',width:140},
		{field:'CreateUser',title:'������',width:100},
		{field:'MedView',title:'���',width:100,
			formatter:unitformatter
		}
	]];
	
	//����datagrid
	$('#dg').datagrid({
		title:'ҩ����ѯ',    
		url:'',
		fit:true,
		//fitColumns:true,
		rownumbers:true,
		columns:columns,
		pageSize:30,  // ÿҳ��ʾ�ļ�¼����
		pageList:[30,45],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true
	});
	
	initScroll();//��ʼ����ʾ���������
	
	$("#StartDate").datebox("setValue", formatDate(-1));  //Init��ʼ����
	$("#EndDate").datebox("setValue", formatDate(0));  //Init��������
	
	//�û�
	$('#User').combobox({
		//panelHeight:"auto",  //���������߶��Զ�����
		url:url+'?actiontype=SelUserByGrp&grpId='+session['LOGON.GROUPID']
	}); 
	
	//��ѯ��ť���¼�
	$('#Query').bind('click',function(){
		Query();  //��ѯ
		//createMedViewWin(); //���
	})
})

/// Ĭ����ʾ���������
function initScroll(){
	var opts=$('#dg').datagrid('options');    
	var text='{';    
	for(var i=0;i<opts.columns.length;i++)
	{    
		var inner_len=opts.columns[i].length;    
		for(var j=0;j<inner_len;j++)
		{    
			if((typeof opts.columns[i][j].field)=='undefined')break;    
			text+="'"+opts.columns[i][j].field+"':''";    
			if(j!=inner_len-1){    
				text+=",";    
			}    
		}    
	}    
	text+="}";    
	text=eval("("+text+")");    
	var data={"total":1,"rows":[text]};    
	$('#dg').datagrid('loadData',data);  
	$("tr[datagrid-row-index='0']").css({"visibility":"hidden"});
}

/// ��ʽ������
function formatDate(t)
{
	var curr_time = new Date();  
	var Year = curr_time.getFullYear();
	var Month = curr_time.getMonth()+1;
	var Day = curr_time.getDate()+parseInt(t);
	return Month+"/"+Day+"/"+Year;
}

/// ��ʽ��
function unitformatter(value, rowData, rowIndex){
	return "<a href='#' onclick='showWin("+rowData.AdmDr+")'>���</a>";
}

/// ��ѯ
function Query()
{
	var StDate=$('#StartDate').datebox('getValue'); //��ʼ����
	var EndDate=$('#EndDate').datebox('getValue');  //��ֹ����
	var UserID=$('#User').combobox('getValue'); //�û�ID
	var KeyWords=$('#keywords').val();          //�ؼ���[���]
	var params=StDate+"^"+EndDate+"^"+UserID+"^"+KeyWords;
	$('#dg').datagrid({
		url:url+'?action=QueryMedRecord',	
		queryParams:{
			params:params}
	});
}

///��ʾ���� formatter="SetCellUrl"
function showWin(AdmDr)
{
	createMedViewWin(AdmDr); //���ô��� createMedViewWin
}

///�����������
function createMedViewWin(adm)
{
	//�������,�Ƚ����Ƴ�
	if($('#win').is(":visible")){
		$('#win').remove();
	}  
	
	$('body').append('<div id="win"></div>');

	$('#win').window({
		title:'ҩ�����',
		width:1200,
		height:520,
		border:true,
		closed:"true",
		collapsible:true,
		maximized:true, //�������
		onClose:function(){
			$('#win').remove();  //���ڹر�ʱ�Ƴ�win��DIV��ǩ
		}
	}); 

	var PatientID="108075";
	var EpisodeID=adm;
	var DocID="55";
	var UserID=session['LOGON.USERID'];
	
	var PrintDocID=521;
	var TemplateDocID=72;
	var ChartItemID="ML521";
	var content = '<iframe id = "framRecord" scrolling="no" frameborder="0" src="epr.newfw.episodelistbrowser.csp?USERNAME=epr&PASSWORD=1&LANGID=1&DEPARTMENT=QY-ȫԺ&EpisodeID='+EpisodeID+'" style="width:100%;height:100%;"></iframe>';

	$('#win').html(content);
	$('#win').window('open');
}

