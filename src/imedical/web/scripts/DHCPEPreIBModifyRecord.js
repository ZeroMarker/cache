//����	DHCPEPreIBModifyRecord.js
//����	���˻�����Ϣ�޸ļ�¼
//����	2018.08.31
//������  xy

$(function(){
	
	InitModifyRecordDataGrid();
	
})
function InitModifyRecordDataGrid(){
	$HUI.datagrid("#dhcpemodifyrecordlist",{
		 url:$URL,
        fit : true,
        border : false,
        striped : true,
        fitColumns : false,
        autoRowHeight : false,
		nowrap:false,
        singleSelect: false,
        selectOnCheck: true,
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		pageSize: 10,
		pageList: [10, 20, 40, 40],
	    displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������"
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