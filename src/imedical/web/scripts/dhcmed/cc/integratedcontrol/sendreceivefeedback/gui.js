
function InitwinSendReceiveFeedback(){
	var obj = new Object();
	obj.txtMsg = new Ext.form.TextArea({
		height : 150
		,width : 180
		//,fieldLabel : '�ܾ�ԭ��'
});
	obj.btnOK = new Ext.Button({
		text : 'ȷ��'
});
	obj.btnCancel = new Ext.Button({
		text : 'ȡ��'
});
	obj.winReject = new Ext.Window({
		buttonAlign : 'center'
		,width : 310
		,height : 251
		,title : '������ܾ�ԭ��'
		,layout : 'fit'
		,modal : true
		,items:[
			obj.txtMsg
		]
		,buttons:[
			obj.btnOK
			,obj.btnCancel
		]
	});
	InitwinSendReceiveFeedbackEvent(obj);
	//�¼��������
	obj.btnOK.on("click", obj.btnOK_click, obj);
	obj.btnCancel.on("click", obj.btnCancel_click, obj);
  obj.LoadEvent(arguments);
  return obj;
}

