function InitDicSet(){
	var obj = new Object();
	obj.ItemID = arguments[0];
	obj.txtQryClassName = Common_TextField('txtQryClassName','检索类名<font color="red">*</font>');
	obj.txtQryMethodName = Common_TextField('txtQryMethodName','检索Qry名<font color="red">*</font>');
	obj.txtArgs = Common_TextField('txtArgs','入参');
	obj.txtDisCode = Common_TextField('txtDisCode','代码<font color="red">*</font>');
	obj.txtDisDesc = Common_TextField('txtDisDesc','描述<font color="red">*</font>');
	obj.txtChooseValue = Common_TextField('txtChooseValue','选择后值<font color="red">*</font>');
	obj.chkIsLoadAll = Common_Checkbox('chkIsLoadAll','显示全部信息');
	obj.chkIsActive = Common_Checkbox('chkIsActive','是否有效');

	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,text : '保存设置'
		,width : 40
	});

	obj.WinDicSet = new Ext.Window({
		id : 'WinDicSet'
		,height : 300
		,width : 400
		,modal : true
		,title : '综合查询数据项字典设置'
		,closable : true
		,layout : 'border'
		,buttonAlign : 'center'
		,items:[
			{
				layout:'form'
				,region:'center'
				,height:35
				,frame:true
				,labelAlign:'right'
				,labelWidth : 90
				,items:[obj.txtQryClassName,obj.txtQryMethodName,obj.txtArgs,obj.txtDisCode,obj.txtDisDesc,obj.txtChooseValue,obj.chkIsLoadAll,obj.chkIsActive]
			}
		]
		,buttons:[obj.btnSave]
	});

	InitDicSetEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}