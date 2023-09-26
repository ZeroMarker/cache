function InitDicSet(){
	var obj = new Object();
	obj.ItemID = arguments[0];
	obj.txtQryClassName = Common_TextField('txtQryClassName','��������<font color="red">*</font>');
	obj.txtQryMethodName = Common_TextField('txtQryMethodName','����Qry��<font color="red">*</font>');
	obj.txtArgs = Common_TextField('txtArgs','���');
	obj.txtDisCode = Common_TextField('txtDisCode','����<font color="red">*</font>');
	obj.txtDisDesc = Common_TextField('txtDisDesc','����<font color="red">*</font>');
	obj.txtChooseValue = Common_TextField('txtChooseValue','ѡ���ֵ<font color="red">*</font>');
	obj.chkIsLoadAll = Common_Checkbox('chkIsLoadAll','��ʾȫ����Ϣ');
	obj.chkIsActive = Common_Checkbox('chkIsActive','�Ƿ���Ч');

	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,text : '��������'
		,width : 40
	});

	obj.WinDicSet = new Ext.Window({
		id : 'WinDicSet'
		,height : 300
		,width : 400
		,modal : true
		,title : '�ۺϲ�ѯ�������ֵ�����'
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