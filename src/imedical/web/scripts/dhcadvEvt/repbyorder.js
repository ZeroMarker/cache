// Creator: congyue
// CreateDate: 2021-02-07
// Descript: ҽ����ز����¼��б�
var RepCode="",OrderID="",LgParam="";
$(function(){ 
	InitPageComponent(); 	  /// ��ʼ������ؼ�����
	InitPageDataGrid();		  /// ��ʼ��ҳ��datagrid
});
/// ��ʼ������ؼ�����
function InitPageComponent(){
	//��ҳ �����������
	RepCode=getParam("RepCode");
	OrderID=getParam("OrderID");
}

/// ��ʼ��ҳ��datagrid
function InitPageDataGrid()
{
	//����columns
	var columns=[[
		{field:"RepID",title:'RepID',width:80,hidden:true},
		{field:"recordID",title:'recordID',width:80,hidden:true},
		{field:'RepDate',title:'��������',sortable:true},
		{field:'RepType',title:'��������',width:260,hidden:true},
		{field:'OccurDate',title:'��������',width:100,hidden:true},
		{field:'OccurLoc',title:'��������',width:130,hidden:true},
		{field:'RepLocDr',title:'RepLocDr',width:150,hidden:true},
		{field:'RepLoc',title:'�������',width:130,hidden:true},	
		{field:'RepUser',title:'������',width:100,hidden:true},	
		{field:'RepLevel',title:'�����¼�����',width:120,hidden:true},
		{field:'RepInjSev',title:'�˺����ض�',width:120,hidden:true},
		{field:'AdmID',title:'����ID',width:80,hidden:true}
	]];
	//����datagrid
	$('#maindg').datagrid({
		title:'', 
		method:'get',
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryRepListByOrder'+'&LgParam='+LgParam+'&RepCode='+RepCode+'&OrderID='+OrderID,
		fit:true,
		rownumbers:true,
		columns:columns,
		remoteSort:false,
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		nowrap:true,
		onClickRow:function(rowIndex, rowData){
			$('#repfream').attr('src','dhcadv.layoutform.csp?recordId='+rowData.recordID+'&RepTypeDr='+rowData.RepTypeDr+'&code='+rowData.RepTypeCode+'&desc='+rowData.RepType+'&RepID='+rowData.RepID+'&editFlag=-1&AdmID='+rowData.AdmID);
    	},
		onLoadSuccess:function(data){
			$(".pagination").hide();
		}
	});
	
}


