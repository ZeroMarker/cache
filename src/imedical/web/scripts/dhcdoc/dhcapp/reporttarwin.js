/// �շ���Ŀ��ϸ����

showTarItmWin = function(param){
	var ParamId=param.split("||")[0]+"Part"+param.split("^")[1].split("$$")[0];
	if ($('#dgTarItm'+ParamId).length>0){
		$('#dgTarItm'+ParamId).remove();
	}
	$("#CellTar"+ParamId).popover({
		width:600,
		height:$("#CellTar"+ParamId).offset().top-90,
		title:"�շ���ϸ",
		content:'<table id="dgTarItm'+ParamId+'"></<table>',
		trigger:'hover',
		placement:'auto-top',
		onShow:function(){
			initTarItmList(param);
			//LoadTarItmList(param)
		}
	});
	$("#CellTar"+ParamId).popover('show');
	/*if($("#newTarWin").is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

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
	LoadTarItmList(param);*/
}

/// �շ���Ŀ��ϸ DataGrid��ʼ����
function initTarItmList(param){
	
	///  ����columns
	var columns=[[
		{field:'TarCode',title:'��Ŀ����',width:100,formatter:SetCellFontColor},
		{field:'TarDesc',title:'��Ŀ����',width:220},
		{field:'TarQty',title:'����',width:80},
		{field:'TarPrice',title:'����',width:80},
		{field:'TarCost',title:'�۸�',width:80,formatter:SetCellFontColor},
		{field:'TarDiscCost',title:'�ۺ��',width:80,formatter:SetCellFontColor}
		
	]];
	$('#dgTarItm'+param.split("||")[0]+"Part"+param.split("^")[1].split("$$")[0]).datagrid({  
		fit : true,
		width : 'auto',
		border : true,
		//striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryExaReqTarList&param="+param,
		loadMsg : '������..',  
		pagination : true,  //�Ƿ��ҳ
		rownumbers : true,  //
		idField:"TarCode",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :columns,
		onClickRow:function(rowIndex, rowData){
		
		},
       onLoadSuccess:function(data){
	       //$("#Moster"+param.split("||")[0]).popover('show');
	   },
	   onBeforeLoad:function(param){
	   }
	});
	/*///  ����datagrid
	var option = {
		rownumbers : true,
		singleSelect : true
	};

	var uniturl = "";
	new ListComponent('dgTarItm', columns, uniturl, option).Init(); */
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