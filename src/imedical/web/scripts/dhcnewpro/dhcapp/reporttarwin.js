/// �շ���Ŀ��ϸ����

showTarItmWin = function(param){

	if($("#newTarWin").is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="newTarWin"></div>');
	$("#newTarWin").append('<div id="dgTarItm"></div>');
	
	/// ԤԼ���鴰��
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		closed:"true"
	};
	
	new WindowUX('�շ���ϸ', 'newTarWin', '700', '400', option).Init();
	
	initTarItmList();   /// �շ���Ŀ��ϸ
	LoadTarItmList(param);
}

/// �շ���Ŀ��ϸ DataGrid��ʼ����
function initTarItmList(){
	
	///  ����columns
	var columns=[[
		{field:'TarCode',title:'��Ŀ����',width:100,formatter:SetCellFontColor},
		{field:'TarDesc',title:'��Ŀ����',width:220},
		{field:'TarQty',title:'����',width:80},
		{field:'TarPrice',title:'����',width:80},
		{field:'TarCost',title:'�۸�',width:80,formatter:SetCellFontColor},
		{field:'TarDiscCost',title:'�ۺ��',width:80,formatter:SetCellFontColor}
		
	]];
	
	///  ����datagrid
	var option = {
		rownumbers : true,
		singleSelect : true
	};

	var uniturl = "";
	new ListComponent('dgTarItm', columns, uniturl, option).Init(); 
}

/// �����շ�����ϸ
function LoadTarItmList(param){

	var uniturl = $URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryExaReqTarList&param="+param;
	$('#dgTarItm').datagrid({url:uniturl});
	
}

/// ����������ʾ��ɫ
function SetCellFontColor(value, rowData, rowIndex){
	
	var htmlstr = value;
	if (rowData.TarCode == "�ϼƣ�"){
		htmlstr = "<span style='color:red; font-weight:bold'>"+value+"</span>"
	}
	return htmlstr;
}