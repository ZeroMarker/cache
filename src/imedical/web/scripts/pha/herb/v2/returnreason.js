/**
 * 名称:	 草药房管理-退药、退药申请原因选择
 * 编写人:	 MaYuqiang
 * 编写日期: 2022-09-29
 */
var ReasonDialog = {
	callback: ""
}

function InitReasonDialog(options){	
	ReasonDialog.callback = options.callback;
	var admType = options.admType;
	var hospId = options.hospId;
	//console.log("admType:"+admType)
	$('#btnSelectReason').on('click', SelectReason);
	InitReasonDict(admType, hospId);

}
		
//初始化
function InitReasonDict(admType, hospId){
	// 初始化退药原因
	PHA.ComboBox("retReason", {
		url: PHA_HERB_STORE.RetReasonStore(admType, hospId).url,
		width: 135
	});
}

function InitReturnReason(){
	var title = "退药原因选择"
	$('#diagRetReason').dialog({
		title: title,
		iconCls: 'icon-w-find',
		modal: true,
		closable: false,
		isTopZindex:true
	});
}
// 打开窗口界面
function ShowReason() {
	InitReturnReason();
	$('#diagRetReason').dialog('open');
}

// 返回发药窗口信息
function SelectReason(){
	var reasonId = $('#retReason').combobox('getValue') ;
	var reasonName = $('#retReason').combobox('getText') ;
	if (reasonId == ""){
		$.messager.alert('提示',"请先选择退药原因!","info");
		return;	
	}

	var param = {
		reasonId: reasonId,
		reasonName: reasonName
	}
	if(ReasonDialog.callback){
		ReasonDialog.callback(param);	
	}
	$('#diagRetReason').dialog('close');
}
