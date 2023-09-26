function InitInquiryTool(obj)
{
	obj.menuItemClearTimeLineData = new Ext.menu.Item({
		id : 'menuItemClearTimeLineData'
		,iconCls : 'icon-table_delete'
		,text : '<span title=\'清空后将在查询过程中重新生成时间序列数据\'>清空时间序列数据</span>'
	});
	obj.menuItemClearInquiryItem = new Ext.menu.Item({
		id : 'menuItemClearInquiryItem'
		,iconCls : 'icon-bullet_cross'
		,text : '<span title=\'将清空策略对应的所有策略项目,请慎重!\'><span style=\'color:red;\'>☆</span>清空策略项目<span style=\'color:red;\'>☆</span></span>'
	});

	obj.menuItemClearInquiryItem_click=function(args)
	{
		if(!obj.CheckSelectInquiry()) return;
		Ext.Msg.show({
		   title:'确认清除？',
		   msg: '将清空策略对应的所有策略项目，确定清除吗？',
		   buttons: Ext.Msg.YESNOCANCEL,
		   animEl: 'complexSeachPanel',
		   fn:function(args){
		   		if(args=="yes") ClearInquiryItem();
		   },
		   icon: Ext.MessageBox.QUESTION
		});
	}

	function ClearInquiryItem()
	{
		var ret = obj._DHCANOPStat.ClearInquiryItem(obj.anciId);
		if(ret=="0")
		{
			alert("清空策略项目数据成功！");
			obj.retGridPanelStore.removeAll();
			obj.InquiryItemGridStore.load({});
			obj.retSumTypeStore.removeAll();
			obj.retGridHeaderStore.load({});
		}
		else alert(ret);
	}
	
	obj.menuItemClearTimeLineData_click=function(args)
	{
		if(!obj.CheckSelectInquiry()) return;
		var ret = obj._DHCANOPStat.ClearTimeLineData(obj.anciId);
		if(ret=="0") alert("清空时间序列数据成功！");
		else alert(ret);
	}

	obj.menuItemClearInquiryItem.on("click",obj.menuItemClearInquiryItem_click,obj);
	obj.menuItemClearTimeLineData.on("click",obj.menuItemClearTimeLineData_click,obj);

	obj.menuItemExportInquiryItem = new Ext.menu.Item({
		id : 'menuItemExportInquiryItem'
		,iconCls : 'icon-application_go'
		,text : '<span title=\'导出策略配置内容文本\'>导出策略</span>'
	});
	obj.menuItemExportInquiryItem.on("click",function()
	{
		if(!obj.CheckSelectInquiry()) return;
		var html = GetInquiryJsonStr();

		obj.winScreenItemExport.show();
		obj.inquiryItemExportArea.setValue(html);
	});

	function GetInquiryJsonStr()
	{
		var result = '{';
		result = result+'ANCICode:\"'+obj.txtInquiryCode.getValue()+'\",';
		result = result+'ANCIDesc:\"'+obj.txtInquiryDesc.getValue()+'\",';
		result = result+'ANCIType:\"'+obj.comANCIType.getValue()+'\",';
		result = result+'ANCIDataType:\"'+obj.comANCIDataType.getValue()+'\",';
		result = result+'ANCIItems:[';
		result = result+GetInquiryItemsJsonStr();
		result = result+']';
		result = result+'}';

		return result;
	}
	function GetInquiryItemsJsonStr()
	{
		var result="",single="";
		var record,field;
		for(var i=0;i<obj.InquiryItemGridStore.totalLength;i++)
		{
			record = obj.InquiryItemGridStore.getAt(i);
			single = "";
			for(var j=0;j<obj.InquiryItemGridStore.fields.items.length;j++)
			{
				field = obj.InquiryItemGridStore.fields.items[j];
				single = single+field.name+":\""+record.get(field.name)+"\"";
				if(j<obj.InquiryItemGridStore.fields.items.length-1) single = single+",";
			}

			result = result+"{"+single+"}";
			if(i<obj.InquiryItemGridStore.totalLength-1) result = result+",";
		}
		return result;
	}

	obj.inquiryItemExportArea = new Ext.form.TextArea({
		grow:false
		,height:300
		,width:500
		,readOnly:true
		,anchor : '95%'
	})

	obj.winScreenItemExport = new Ext.Window({
		height : 320
		,buttonAlign : 'center'
		,width : 520
		,title : '导出策略配置内容(请自行粘贴到导入界面)'
		,modal : false
		,draggable : true
		,resizable : true
		,closeAction : 'hide'
		,layout : 'fit'
		,items:[
			{
				frame:true
				,layout:'fit'
				,title:'策略导出'
				,autoScroll:true
				,items: [obj.inquiryItemExportArea]
			}
		]
	});

	obj.menuItemImportInquiryItem = new Ext.menu.Item({
		id : 'menuItemImportInquiryItem'
		,iconCls : 'icon-application_get'
		,text : '<span title=\'通过文本导入策略配置内容\'>导入策略</span>'
	});

	obj.menuItemImportInquiryItem.on("click",function()
	{
		if(obj.InquiryItemGridStore.totalLength || obj.comInquiry.getValue())
		{
			Ext.Msg.show({
			   title:'确认保存？',
			   msg: '你有正在修改的策略，导入时将移除之前的修改，是否需要保存？',
			   buttons: Ext.Msg.YESNOCANCEL,
			   animEl: 'complexSeachPanel',
			   fn:function(args){
			   		if(args=="yes") obj.btnSaveInquiry_click();
			   		if(args!="cancel")
			   		{
			   			obj.winScreenItemImport.show();
			   			obj.inquiryItemImportArea.setValue("");
			   		}
			   },
			   icon: Ext.MessageBox.QUESTION
			});
		}
		else
		{
			obj.winScreenItemImport.show();
			obj.inquiryItemImportArea.setValue("");
		}
	});

	obj.btnImportInquiryItem = new Ext.Button({
		id : 'btnImportInquiryItem'
		,text : '确认导入'
	});

	obj.btnImportInquiryItem.on("click",function()
	{
		ImportInquiryItem();
	});

	function ImportInquiryItem()
	{
		obj.ClearSelectInquiry();
		try
		{
			var data = obj.inquiryItemImportArea.getValue();
			if(data)
			{
				var jsonData = eval('('+data+')');
				obj.txtInquiryCode.setValue(jsonData.ANCICode);
				obj.txtInquiryDesc.setValue(jsonData.ANCIDesc);
				obj.comANCIType.setValue(jsonData.ANCIType);
				obj.comANCIDataType.setValue(jsonData.ANCIDataType);

				var inquiryItemsData = {record:[],total:0};

				inquiryItemsData.record = jsonData.ANCIItems;
				inquiryItemsData.total = jsonData.ANCIItems.length;

				obj.InquiryItemGridStore.loadData(inquiryItemsData);
			}
			else
			{
				alert("数据为空，请填入导出的策略项目数据后再点击导入");
				return;
			}
			obj.winScreenItemImport.hide();
		}
		catch(ex)
		{
			alert("数据错误，请重新填入导出的策略项目数据！");
		}
	}

	obj.btnCancelInquiryItem = new Ext.Button({
		id : 'btnCancelInquiryItem'
		,text : '取消'
	});

	obj.btnCancelInquiryItem.on("click",function()
	{
		obj.winScreenItemImport.hide();
	});

	obj.inquiryItemImportArea = new Ext.form.TextArea({
		grow:false
		,height:300
		,width:500
		,anchor : '95%'
	})

	obj.winScreenItemImport = new Ext.Window({
		height : 320
		,buttonAlign : 'center'
		,width : 520
		,title : '导入策略配置内容(策略导入后请自行保存)'
		,modal : false
		,draggable : true
		,resizable : true
		,closeAction : 'hide'
		,layout : 'fit'
		,items:[
			{
				frame:true
				,layout:'fit'
				,title:'策略导入(请粘贴导出内容到输入框)'
				,autoScroll:true
				,items: [obj.inquiryItemImportArea]
				,buttons:[obj.btnImportInquiryItem,obj.btnCancelInquiryItem]
			}
		]
	});

	obj.inquiryToolMenu.addItem(obj.menuItemClearTimeLineData);
	obj.inquiryToolMenu.addItem(obj.menuItemClearInquiryItem);
	obj.inquiryToolMenu.addItem(obj.menuItemExportInquiryItem);
	obj.inquiryToolMenu.addItem(obj.menuItemImportInquiryItem);
}