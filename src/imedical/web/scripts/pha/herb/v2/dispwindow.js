/**
 * 名称:	 草药房管理-发药窗口
 * 编写人:	 MaYuqiang
 * 编写日期: 2022-06-14
 */
var DispWinDialog = {
	callback: ""
}

function InitDispWinDialog(opts){	
	DispWinDialog.callback = opts.callback;
	$('#btnSelectWin').on('click', SelectWindow);
	InitWinDict();
	InitGridWindow();
}
		
//初始化
function InitWinDict(){
	//初始化发药窗口
	PHA.ComboBox("dispWindow", {
		url: PHA_HERB_STORE.WindowStore(gLocId).url,
		width: 200
	});
}

function InitGridWindow(){
	var columns = [
		[	
			{
				field: 'TPhwId',
				title: '窗口Id',
				align: 'center',
				hidden: true,
				width: 90
			}, {
				field: 'TPhwDesc',
				title: '药房窗口',
				align: 'center',
				width: 200
			}, {
				field: 'TPhwState',
				title: '窗口状态',
				align: 'center',
				width: 200,
				editor:{
					type:'switchbox',
					options:{
						onClass:'primary',
						offClass:'gray',
						onText:'有人',
						offText:'无人',
						onSwitchChange: function (e,obj) {
							if (obj.value == true){
								var state = "1"
							}
							else{
								var state = "0"
							}
							var selRowData = $('#gridDispWindow').datagrid('getSelected');
							var phwId = selRowData.TPhwId;
							var ret = tkMakeServerCall("PHA.OP.CfDispWin.OperTab", "UpdWinDoFlag", phwId, state, LogonInfo);
							if (ret == 0) {
								return true;
							} else if (ret == -11) {
								$.messager.alert('提示',"请确保至少一个窗口为有人状态!","info");
								return false;
							} else {
								$.messager.alert('提示',"修改窗口状态失败,错误代码:" + ret,"info");
								return false;
							}
						}
					}
				}
			}
		]
	];
	var dataGridOption = {
		fit: true,
		rownumbers: false,
		columns: columns,
		nowrap:false ,
		pagination: false,
		//pageSize:100,
		//pageList:[100,300,500,999],
		singleSelect: true,
		fitcolumns: true,
		toolbar: gridDispWindowBar,
		url: $URL,
		queryParams: {
			ClassName: "PHA.HERB.Dispen.Query",
			QueryName: "GetWindowList"
		},
		onClickRow: function (index){
			EditRow();
		},
		onLoadSuccess: function () {
			
		}
	};
	PHA.Grid("gridDispWindow", dataGridOption);

}

function EditRow() {
	$('#gridDispWindow').datagrid('endEditing');
	var selRow = $('#gridDispWindow').datagrid('getSelected');
	if (!selRow) {
		PHA.Popover({
			msg: "请先选择要编辑的数据！",
			type: 'alert'
		});
		return;
	}
	var rowIndex = $('#gridDispWindow').datagrid('getRowIndex', selRow);
	$('#gridDispWindow').datagrid('beginEditRow', {
		rowIndex: rowIndex,
	});
	

}

function InitDialogDispWin(){
	var title = "发药窗口选择"
	$('#diagDispWindow').dialog({
		title: title,
		iconCls: 'icon-w-find',
		modal: true,
		closable: false,
		isTopZindex:true ,
		width: 424,
		height: 300
	});
}
// 打开窗口界面
function ShowWindowInfo() {
	InitDialogDispWin();
	$('#diagDispWindow').dialog('open');
	/* 加载界面之后自动执行查询，延迟查询，避免窗口还没打开就执行查询 */
	setTimeout("QueryDispWindow()",200);
	
}

// 返回发药窗口信息
function SelectWindow(){
	var windowId = $('#dispWindow').combobox('getValue') ;
	var windowDesc = $('#dispWindow').combobox('getText') ;
	if (windowId == ""){
		$.messager.alert('提示',"请先选择发药窗口!","info");
		return;	
	}

	var param = {
		windowId: windowId,	
		windowDesc: windowDesc
	}
	if(DispWinDialog.callback){
		DispWinDialog.callback(param);	
	}
	$('#diagDispWindow').dialog('close');
}

function QueryDispWindow(){
	$('#gridDispWindow').datagrid('query', {
        phaLocId: gLocId
    });
}
