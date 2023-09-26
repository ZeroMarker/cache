

var url="dhcpha.clinical.action.csp";
var	PatientID="";
var	EpisodeID="";
var flag="";
$(function(){
	
	PatientID=getParam("PatientID");
	EpisodeID=getParam("EpisodeID");
	InitPatMedGrid();					/// ��ʼ���б�
	LoadPatMedInfo("");					/// ��������
});

function InitPatMedGrid()
{
	//����columns
	var columns=[[
		
		{field:"ck",checkbox:true,width:20,hidden:true},
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
		{field:'priorty',title:'���ȼ�',width:80,align:'center'},
		{field:'StartDate',title:'��ʼ����',width:80,align:'center'},
		{field:'startTime',title:'��ʼʱ��',width:80,align:'center'},
		{field:'incidesc',title:'ҽ��',width:280},		
		{field:'instru',title:'�÷�',width:80,align:'center'},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'dosage',title:'����',width:40,align:'center'},
		//{field:'unitDR',title:'��λ',width:40,align:'center'},
		{field:'freq',title:'Ƶ��',width:60,align:'center'},
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'EndDate',title:'ֹͣ����',width:80,align:'center'},
		{field:'endTime',title:'ֹͣʱ��',width:80,align:'center'},
		{field:'doctor',title:'ҽ��',width:80,align:'center'},		
		{field:'OeFlag',title:'OeFlag',width:80,hidden:true},
		{field:'oeDesc',title:'״̬',width:80,align:'center'},		
		{field:'execStat',title:'�Ƿ�ִ��',width:80,align:'center'},
		{field:'sendStat',title:'�Ƿ�ҩ',width:80,align:'center'},
		{field:'orderbak',title:'ҽ����ע',width:80,align:'center'},
		{field:'groupFlag',title:'�������',width:80,align:'center'}			
	]];

 	$('#medInfo').datagrid({   
		title:'ҽ����Ϣ',
		url:url+'?action=GetPatOEInfo',
		fit:true,
		fitColumns:true,		/// ������Ӧ
		rownumbers:true,
		columns:columns,
		nowrap: false,		
		pageSize:20, 			/// ÿҳ��ʾ�ļ�¼����
		pageList:[20,40,60],   	/// ��������ÿҳ��¼�������б�
		pagination:true,
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		striped : true, 		/// �Ƿ���ʾ������Ч��		
		queryParams:{
			EpisodeID:EpisodeID
		},	   
		onClickRow:function(rowIndex, rowData){
			
			///һ��ҽ��ͬʱѡ��
			var items = $('#medInfo').datagrid('getRows');
			$.each(items, function(index, item){ 										/// qunianpeng 2017/2/8
				var mainGroupOrd=(rowData.moeori=="")&&(item.moeori==rowData.orditm); 	/// ѡ��������ҽ����ͬʱѡ�г���ҽ��
				var otherGroupOrd=(rowData.moeori!="")&&((item.moeori=="")&&(rowData.moeori==item.orditm)||(rowData.moeori==item.moeori)); //ѡ���в�����ҽ�������ǳ���ҽ���е�һ����ͬʱѡ�г���ҽ��
				if(mainGroupOrd||otherGroupOrd){
					$("[datagrid-row-index='" + index + "']").css({ "background-color": "#ccffee" });
				}
				else{
					$("[datagrid-row-index='" + index + "']").css({ "background-color":"" });
				}
			});		
		},
		onDblClickRow:function(rowIndex, rowData){
			window.parent.medadvises(rowData.orditm)
			
}
					
	}); 
	
}

//��ѯ����/��ҽ��
function LoadPatMedInfo(priCode)
{
	$('#medInfo').datagrid({
		url:url+'?action=GetPatOEInfo',	
		queryParams:{
			params:EpisodeID,
			PriCode:priCode
			}
	});
	initScroll("#medInfo");		//��ʼ����ʾ���������
}