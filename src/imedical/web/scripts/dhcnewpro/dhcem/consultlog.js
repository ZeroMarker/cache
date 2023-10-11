
/// ������־����
OpenCsLogWin = function(){

	if (CstItmID == ""){
		$.messager.alert("��ʾ:","����ѡ��һ�������¼��","warning");
		return;
	}
	
	if($('#LogWin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="LogWinDiv" style="padding:10px;"></div>');
	$("#LogWinDiv").append('<div id="LogWin"></div>');

	/// ��־����window
	var option = {
		collapsible:true,
		border:true,
		closed:"true",
		iconCls:'icon-w-paper', //hxy 2023-02-07 
		collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false
	};
	InitLogGrid();  /// ��ʼ���崰��DataGrid
	new WindowUX('������־����', 'LogWinDiv', (window.screen.availWidth-740), '400', option).Init();
	//$("#LogWin").html();
}

/// ��ʼ���崰��DataGrid
function InitLogGrid(){
	
	///  ����columns
	var columns=[[
		{field:'Status',title:'״̬',width:100,align:'center',formatter:
			function (value, row, index){
				if ((value == "ȡ��")||(value == "�ܾ�")||(value == "����")){
					return '<font style="color:red;font-weight:bold;">'+value+'</font>';
				}else{
					return '<font style="color:green;font-weight:bold;">'+value+'</font>';
				}
			}
		},
		{field:'LgDate',title:'����',width:100,align:'center'},
		{field:'LgTime',title:"ʱ��",width:100,align:'center'},
		{field:'LgUser',title:"������",width:100},
		{field:'LogNotes',title:"��ע",width:400,formatter:SetCellField}
	]];
	
	///  ����datagrid
	var option = {
		border:true, //hxy 2023-02-07 st
		bodyCls:'panel-header-gray', //ed
		//showHeader:false,
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
		pagination: true,
		fit : true,
		nowrap : false,
	    onDblClickRow: function (rowIndex, rowData) {
        }
	};
	
	var ReqFlag=""; //���ﴦ��-�����б�-������־������δ��ʾ������ҽ���Ĳ�����¼;
	if(parent.$("#QReqBtn").hasClass("btn-blue-select")){
		ReqFlag=1;
	}
	
	var uniturl = $URL+"?ClassName=web.DHCEMConsultQuery&MethodName=JsonCsLog&itmID="+CstItmID+"&ReqFlag="+ReqFlag;
	new ListComponent('LogWin', columns, uniturl, option).Init();
}

/// ���������ַ�
function SetCellField(value, rowData, rowIndex){
	return $_TrsTxtToSymbol(value);
}