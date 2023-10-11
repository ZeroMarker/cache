/**
 * 名称:	 草药房管理-配药药师
 * 编写人:	 MaYuqiang
 * 编写日期: 2022-06-27
 */
var PYUserDialog = {
	callback: ""
}

function InitPYUserDialog(options){	
	PYUserDialog.callback = options.callback;
	$('#btnSelectPYUser').on('click', SelectPYUser);
	InitPYUserDict();;

}
		
//初始化
function InitPYUserDict(){
	//初始化配药人
	PHA.ComboBox("pyUser", {
		url: PHA_HERB_STORE.PYUserStore(gLocId,gUserID).url,
		width: 135
	});
}

function InitDialogPYUser(){
	var title = "配药药师选择"
	$('#diagPYUser').dialog({
		title: title,
		iconCls: 'icon-w-find',
		modal: true,
		closable: false,
		isTopZindex:true
	});
}
// 打开窗口界面
function ShowPYUserInfo() {
	InitDialogPYUser();
	$('#diagPYUser').dialog('open');
}

// 返回发药窗口信息
function SelectPYUser(){
	var pyUserId = $('#pyUser').combobox('getValue') ;
	var pyUserName = $('#pyUser').combobox('getText') ;
	if (pyUserId == ""){
		$.messager.alert('提示',"请先选择配药人!","info");
		return;	
	}

	var param = {
		pyUserId: pyUserId,
		pyUserName: pyUserName
	}
	if(PYUserDialog.callback){
		PYUserDialog.callback(param);	
	}
	$('#diagPYUser').dialog('close');
}
