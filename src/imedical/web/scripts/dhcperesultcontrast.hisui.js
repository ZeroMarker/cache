
/*
 * FileName:    dhcperesultcontrast.hisui.js
 * Author:      xy
 * Date:        20221206
 * Description: ����Ա�
 */
 
$(function(){
	
	//��ʼ������
	InitResultContrastGrid();
	
})

function InitResultContrastGrid(){
	$HUI.datagrid("#ResultContrastGrid",{
		height: 663,
		url:$URL,
		striped: false, //�Ƿ���ʾ������Ч��
		singleSelect: true,
		selectOnCheck: false,
		autoRowHeight: false,
		showFooter: true,
		nowrap:false,
		loadMsg: 'Loading...',
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		pageSize: 10,
		pageList: [10, 20, 40, 40],
		queryParams:{
			ClassName:"web.DHCPE.ResultContrast",
			QueryName:"ContrastWithLast", 
			PAADM:PAADM
		},columns:[[ 
			{field:'PAADM',title:'PAADM',hidden: true},
			{field:'TARCIMItem',width:120,title:'ҽ����'},
			{field:'TLastTime',width:300,title:'�ϴ�'},
			{field:'TCurrentTime',width:300,title:'����'},
			{field:'TLastTime2',width:300,title:'���ϴ�'},
			
			
		]]
	
	})
}