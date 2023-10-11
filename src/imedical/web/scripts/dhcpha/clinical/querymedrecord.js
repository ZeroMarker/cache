///Creator:sufan
///date:2016/10/28
var url="dhcpha.clinical.action.csp";
var StatusArray = [{ "value": "Save", "text": $g('���') }];
var HospID=session['LOGON.HOSPID']
function initPageDefault()
{
	initMedrecordlist();   // ��ʼ��ҩ���б�
	initButton();		   // ��ʼ��ҳ��İ�ť
	initCombobox();		   // ��ʼ��ҳ���������
	GetDateStr();		   // ��ʼ��ʱ��
}
///����datagrid
function initMedrecordlist()
{
	//  ����columns
	var columns=[[
		{field:'PatientID',title:$g('����ID'),width:80,align:'center',hidden:'true'},
		{field:'Admdr',title:$g('�����'),width:80,align:'center',hidden:'true'},
		{field:'Patno',title:$g('�ǼǺ�'),width:80,align:'center'},
		{field:'PatName',title:$g('����'),width:80,align:'center'},
		{field:'SexDesc',title:$g('�Ա�'),width:60,align:'center'},
		{field:'PatAge',title:$g('����'),width:60,align:'center'},
		{field:'CtlocDesc',title:$g('�������'),width:100,align:'center'},
		{field:'WardDesc',title:$g('���ﲡ��'),width:100,align:'center'},
		{field:"MainDiag",title:$g('���'),width:300,align:'center'},
		{field:'Episodtype',title:$g('��������'),width:60,align:'center'},
		{field:'status',title:$g('ҩ��״̬'),width:100,align:'center'},
		{field:"Createuser",title:$g('ҩʦ'),width:200,align:'center'},
		{field:'operate',title:$g('����'),width:100,align:'center',formatter:getpatientrecord},
	]];
	// ��ʼ�� datagrid
	$('#medrecordlist').datagrid({
		title:'',
		fit:true,
		nowrap:false,
		rownumbers:true,
		columns:columns,
		pageSize:20,  		// ÿҳ��ʾ�ļ�¼����
		pageList:[20,40],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: $g('���ڼ�����Ϣ...'),
		pagination:true
	});
	$('#medrecordlist').datagrid('loadData', {total:0,rows:[]}); 
}

/// ��ʼ����ť
function initButton()
{
	// ��ѯ��ť
	$('a:contains('+$g("��ѯ")+')').bind("click",querymedrecord);
	
	// �س��¼�
	$("#patno").bind("keypress",function(event){
		if(event.keyCode==13)
		{
			var patno=$("#patno").val();
			getpatno(patno);    // ��ȫ�ǼǺ�
			querymedrecord();
			}
		});
}

/// ��ȫ�ǼǺ�λ��
function getpatno(patno)
{
	if(patno!=""){
	var patnolen=patno.length;
	var len=10-patnolen
	for (var i=0;i<len;i++)
	{
		patno="0"+patno;
		}
	$("#patno").val(patno)
	}
}

/// ��ʼ��combobox
function initCombobox()
{
	// ҩ��״̬
	var StatusCombobox = new ListCombobox("statue",'',StatusArray,{panelHeight:"auto",editable:false});
	StatusCombobox.init();
	//$("#statue").combobox("setValue","Save");
   
	// ����
	/*var uniturl = LINK_CSP+"?ClassName=web.DHCCM.QueryPatient&MethodName=";	
	var url = uniturl+"SelAllWard";
	new ListCombobox("wing",url,'').init();
	$("#wing").combobox("setValue");*/
	 $('#wing').combobox({
		mode:'remote',	
		onShowPanel:function(){ //liubeibei 2018/7/3 ֧��ƴ����ͺ���
			$('#wing').combobox('reload',url+'?action=GetAllWardNewVersion&hospId='+HospID+'  ')			
		}
	});
}

/// ��ѯ
function querymedrecord()
{
	var stdate=$("#stdate").datebox("getValue");
	var enddate=$("#enddate").datebox("getValue");
	var medicalno=$("#idnum").val();
	var patno=$("#patno").val();
	var ward=$("#wing").combobox("getText");
	var statues=$("#statue").combobox("getValue");
	params=stdate+"^"+enddate+"^"+medicalno+"^"+ward+"^"+patno+"^"+statues+"^"+HospID;
	$('#medrecordlist').datagrid(
		{
			url:'dhcapp.broker.csp?ClassName=web.DHCCM.QueryPatient&MethodName=QueryMedRecord',	
			queryParams:{
			params:params}
			});
}

/// ��������
function GetDateStr() 
{ 
	var now=new Date();			// ��ǰ����
	var y = now.getFullYear();
	var m = now.getMonth()+1;             
	var d = now.getDate(); 
	if (m<=9)
	{
		var m="0"+m;
		}
	if (d<=9)
	{
		var d="0"+d;
		}
	var startdate=y + "-" + m + "-" + d;
	$("#enddate").datebox("setValue",startdate);
	var lastdate=new Date(now.getTime()-1*24*3600*1000)   // ��ǰ���ڵ�ǰһ��
	var year=lastdate.getFullYear();
	var month=lastdate.getMonth()+1;
	var day=lastdate.getDate();
	if (month<=9)
	{
		var month="0" + month;
		}
	if (day<=9)
	{
		var day="0" + day;
		}
	var enddate=year + "-" + month + "-" + day
	$("#stdate").datebox("setValue",enddate);
} 

// ����
function getpatientrecord(value, rowData, rowIndex)
{   
	patientID=rowData.PatientID
	episodeID=rowData.Admdr
	patientName=rowData.PatName
	episodeType=rowData.Episodtype
	episodeLocID=rowData.AdmDocId
	statues=rowData.status
	/* if (statues=="�ڽ�")
	{
			var html = "";
			html = "<a href='#' style='margin:0px 5px;font-weight:bold;color:#DCDCDC;text-decoration:none;'>�鿴ҩ���б�</a>";
		}
	else{
			var html = "";
			html = "<a href='#' onclick=\"newCreateConsultWin('"+patientID+"','"+episodeID+"','"+patientName+"','"+episodeType+"','"+episodeLocID+"')\" style='margin:0px 5px;font-weight:bold;color:blue;text-decoration:none;'>�鿴ҩ���б�</a>";
    
    	} */
    	var html = "";
			html = "<a href='#' onclick=\"newCreateConsultWin('"+patientID+"','"+episodeID+"','"+patientName+"','"+episodeType+"','"+episodeLocID+"')\" style='margin:0px 5px;font-weight:bold;color:blue;text-decoration:none;'>"+$g("�鿴ҩ���б�")+"</a>";
    return html;
}

function newCreateConsultWin(patientID,episodeID,patientName,episodeType,episodeLocID)
{
	if($('#winonline').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="winonline"></div>');
	$('#winonline').window({
		title:patientName+"-"+$g('ҩ���б�'),
		collapsible:true,
		border:false,
		closed:"true",
		width:1370,
		height:600,
		minimizable : false,
		maximizable : false,
		collapsible:true		
	});
	$('#winonline').window('open');
	var iframe='<iframe id="scanrecord" scrolling="yes" width=100% height=100%  frameborder="0" src=""></iframe>';
		$('#winonline').html(iframe);
		LoadBrowsePage(patientID,episodeID,episodeType,episodeLocID);
	
	
}

/// ���ز������ҳ��
function LoadBrowsePage(patientID,episodeID,episodeType,episodeLocID)
{
	var url = "dhcpha.clinical.drugbrows.csp?PatientID="+patientID+"&EpisodeID="+episodeID+"&EpisodeLocID="+episodeLocID+"&AdmType="+episodeType;
	$('#scanrecord').attr("src",url);
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })