

var url="dhcpha.clinical.action.csp";
if ("undefined"!==typeof(websys_getMWToken)){
	url += "?MWToken="+websys_getMWToken()
	}
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
		{field:"moeori",title:'moeori',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
		{field:'priorty',title:$g('���ȼ�'),width:80,align:'center'},
		{field:'StartDate',title:$g('��ʼ����'),width:80,align:'center'},
		{field:'startTime',title:$g('��ʼʱ��'),width:80,align:'center'},
		{field:'incidesc',title:$g('ҽ��'),width:280},		
		{field:'instru',title:$g('�÷�'),width:80,align:'center'},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'dosage',title:$g('����'),width:40,align:'center'},
		//{field:'unitDR',title:'��λ',width:40,align:'center'},
		{field:'freq',title:$g('Ƶ��'),width:60,align:'center'},
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'EndDate',title:$g('ֹͣ����'),width:80,align:'center'},
		{field:'endTime',title:$g('ֹͣʱ��'),width:80,align:'center'},
		{field:'doctor',title:$g('ҽ��'),width:80,align:'center'},		
		{field:'OeFlag',title:'OeFlag',width:80,hidden:true},
		{field:'oeDesc',title:$g('״̬'),width:80,align:'center'},		
		{field:'execStat',title:$g('�Ƿ�ִ��'),width:80,align:'center'},
		{field:'sendStat',title:$g('�Ƿ�ҩ'),width:80,align:'center'},
		{field:'orderbak',title:$g('ҽ����ע'),width:80,align:'center'},
		{field:'groupFlag',title:$g('�������'),width:80,align:'center'}			
	]];

 	$('#medInfo').datagrid({   
		title:$g('ҽ����Ϣ'),
		url:url+'&action=GetPatOEInfo',
		fit:true,
		fitColumns:true,		/// ������Ӧ
		rownumbers:true,
		columns:columns,
		nowrap: false,		
		pageSize:20, 			/// ÿҳ��ʾ�ļ�¼����
		pageList:[20,40,60],   	/// ��������ÿҳ��¼�������б�
		pagination:true,
	    singleSelect:true,
		loadMsg: $g('���ڼ�����Ϣ...'),
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
				if(rowData.moeori==""){
					window.parent.medadvises(rowData.orditm)		
				}
				else{
				   window.parent.medadvises(rowData.moeori)	
				}
               
            }
					
	}); 
	
}

//��ѯ����/��ҽ��
function LoadPatMedInfo(priCode)
{
	$('#medInfo').datagrid({
		url:url+'&action=GetPatOEInfo',	
		queryParams:{
			params:EpisodeID,
			PriCode:priCode
			}
	});
	initScroll("#medInfo");		//��ʼ����ʾ���������
}