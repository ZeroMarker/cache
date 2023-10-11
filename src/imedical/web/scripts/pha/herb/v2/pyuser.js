/**
 * ����:	 ��ҩ������-��ҩҩʦ
 * ��д��:	 MaYuqiang
 * ��д����: 2022-06-27
 */
var PYUserDialog = {
	callback: ""
}

function InitPYUserDialog(options){	
	PYUserDialog.callback = options.callback;
	$('#btnSelectPYUser').on('click', SelectPYUser);
	InitPYUserDict();;

}
		
//��ʼ��
function InitPYUserDict(){
	//��ʼ����ҩ��
	PHA.ComboBox("pyUser", {
		url: PHA_HERB_STORE.PYUserStore(gLocId,gUserID).url,
		width: 135
	});
}

function InitDialogPYUser(){
	var title = "��ҩҩʦѡ��"
	$('#diagPYUser').dialog({
		title: title,
		iconCls: 'icon-w-find',
		modal: true,
		closable: false,
		isTopZindex:true
	});
}
// �򿪴��ڽ���
function ShowPYUserInfo() {
	InitDialogPYUser();
	$('#diagPYUser').dialog('open');
}

// ���ط�ҩ������Ϣ
function SelectPYUser(){
	var pyUserId = $('#pyUser').combobox('getValue') ;
	var pyUserName = $('#pyUser').combobox('getText') ;
	if (pyUserId == ""){
		$.messager.alert('��ʾ',"����ѡ����ҩ��!","info");
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
