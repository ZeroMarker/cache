//����	DHCPEPreIBModifyRecord.js
//����	���˻�����Ϣ�޸ļ�¼
//����	2018.08.31
//������  xy
var Height="470"
$(function(){
	
	//�ֱ���
     if((screen.width=="1440")&&(screen.height=="900"))
     {
	     Height="595";
     }

	InitModifyRecordDataGrid();
	
})
function InitModifyRecordDataGrid(){
	$HUI.datagrid("#dhcpemodifyrecordlist",{
		height: Height,
		striped: true, //�Ƿ���ʾ������Ч��
		singleSelect: true,
		selectOnCheck: false,
		autoRowHeight: false,
		showFooter: true,
		nowrap:false,
		url: $URL,
		loadMsg: 'Loading...',
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		pageSize: 10,
		pageList: [10, 20, 40, 40],
		queryParams:{
			ClassName:"web.DHCPE.PreIBaseInfo",
			QueryName:"SearchPreIBModifyRecord", 
			SourceType:SourceType,
			SourceID:SourceID,
		},columns:[[ 
			{field:'User',width:'100',title:'�޸���'},
			{field:'Date',width:'100',title:'�޸�����'},
			{field:'Time',width:'100',title:'�޸�ʱ��'},
			{field:'OldInfo',width:'350',title:'�޸�ǰ����'},
			{field:'NewInfo',width:'380',title:'�޸ĺ�����'},
			
			
		]]
	
	})
}