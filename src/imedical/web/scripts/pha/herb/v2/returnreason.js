/**
 * ����:	 ��ҩ������-��ҩ����ҩ����ԭ��ѡ��
 * ��д��:	 MaYuqiang
 * ��д����: 2022-09-29
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
		
//��ʼ��
function InitReasonDict(admType, hospId){
	// ��ʼ����ҩԭ��
	PHA.ComboBox("retReason", {
		url: PHA_HERB_STORE.RetReasonStore(admType, hospId).url,
		width: 135
	});
}

function InitReturnReason(){
	var title = "��ҩԭ��ѡ��"
	$('#diagRetReason').dialog({
		title: title,
		iconCls: 'icon-w-find',
		modal: true,
		closable: false,
		isTopZindex:true
	});
}
// �򿪴��ڽ���
function ShowReason() {
	InitReturnReason();
	$('#diagRetReason').dialog('open');
}

// ���ط�ҩ������Ϣ
function SelectReason(){
	var reasonId = $('#retReason').combobox('getValue') ;
	var reasonName = $('#retReason').combobox('getText') ;
	if (reasonId == ""){
		$.messager.alert('��ʾ',"����ѡ����ҩԭ��!","info");
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
