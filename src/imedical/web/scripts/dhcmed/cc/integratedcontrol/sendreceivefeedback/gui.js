
function InitwinSendReceiveFeedback(){
	var obj = new Object();
	obj.txtMsg = new Ext.form.TextArea({
		height : 150
		,width : 180
		//,fieldLabel : '拒绝原因'
});
	obj.btnOK = new Ext.Button({
		text : '确定'
});
	obj.btnCancel = new Ext.Button({
		text : '取消'
});
	obj.winReject = new Ext.Window({
		buttonAlign : 'center'
		,width : 310
		,height : 251
		,title : '请输入拒绝原因'
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
	//事件处理代码
	obj.btnOK.on("click", obj.btnOK_click, obj);
	obj.btnCancel.on("click", obj.btnCancel_click, obj);
  obj.LoadEvent(arguments);
  return obj;
}

