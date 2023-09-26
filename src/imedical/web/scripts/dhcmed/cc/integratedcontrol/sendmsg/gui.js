
function InitwinSendMessage(){
	var obj = new Object();
	obj.txtTitle = new Ext.form.TextField({
		width : 180
		,fieldLabel : '主题'
});
	obj.txtMsg = new Ext.form.TextArea({
		height : 150
		,width : 180
		,fieldLabel : '消息内容'
});
	obj.btnOK = new Ext.Button({
		text : '确定'
});
	obj.btnCancel = new Ext.Button({
		text : '取消'
});
	obj.winSendMsg = new Ext.Window({
		buttonAlign : 'center'
		,width : 310
		,height : 251
		,title : '发送消息'
		,layout : 'form'
		,modal : true
		,items:[
			obj.txtTitle
			,obj.txtMsg
		]
	,	buttons:[
			obj.btnOK
			,obj.btnCancel
		]
	});
	InitwinSendMessageEvent(obj);
	//事件处理代码
	obj.btnOK.on("click", obj.btnOK_click, obj);
	obj.btnCancel.on("click", obj.btnCancel_click, obj);
  obj.LoadEvent(arguments);
  return obj;
}

