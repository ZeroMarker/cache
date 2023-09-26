function InitSortItemWindow(obj){

	obj.menuItemSetItemSort = new Ext.menu.Item({
		id : 'menuItemSetItemSort'
		,iconCls : 'icon-application_view_list'
		,text : '设置结果行排序'
	});

	obj.toolMenu.addItem(obj.menuItemSetItemSort);

	obj.winComSortItem = new Ext.form.ComboBox({
		id : 'winComSortItem'
		,store : obj.ANCInquiryItemStore
		,minChars : 1
		,minListWidth : 200
		,displayField : 'desc'
		,fieldLabel : '查询项'
		,valueField : 'code'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.winComSortValue = new Ext.form.ComboBox({
		id : 'winComSortValue'
		,store : obj.refCommonQueryStore
		,minChars : 1
		,minListWidth : 400
		,pageSize : obj.pageSize
		,displayField : 'desc'
		,fieldLabel : '项目值'
		,valueField : 'value'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.winNumSortNo = new Ext.form.NumberField({
		id : 'winNumSortNo'
		,anchor : '95%'
		,fieldLabel : '排序号'
		,enableKeyEvents:true
		,allowNegative:false
		,decimalPrecision:0
		,minValue:0
		,maxLength:5
    });
	obj.winTxtSortExtraDesc = new Ext.form.TextField({
		id : 'winTxtSortExtraDesc'
		,fieldLabel : '备注'
		,anchor : '95%'
		,enableKeyEvents:true
		,minLength:0
		,maxLength:50 
	});
	obj.winBtnSortAdd = new Ext.Button({
		id : 'winBtnSortAdd'
		,iconCls : 'icon-add'
		,text : '新增'
	});
	obj.winBtnSortUpdate = new Ext.Button({
		id : 'winBtnSortUpdate'
		,iconCls : 'icon-table_edit'
		,text : '修改'
	});
	obj.winBtnSortDelete = new Ext.Button({
		id : 'winBtnSortDelete'
		,iconCls : 'icon-delete'
		,text : '删除'
	});
	obj.winSortFormPanel = new Ext.form.FormPanel({
		id : 'winSortFormPanel'
		,buttonAlign : 'center'
		,labelWidth : 50
		,height : 80
		,region : 'north'
		,labelAlign : 'right'
		,layout : 'column'
		,frame :true
		,items : [
			{
				columnWidth : .3
				,layout : 'form'
				,items :[
					obj.winComSortItem
				]
			}
			,{
				columnWidth : .4
				,layout : 'form'
				,items :[
					obj.winComSortValue
				]
			}
			,{
				columnWidth : .15
				,layout : 'form'
				,items :[
					obj.winNumSortNo
				]
			}
			,{
				columnWidth : .15
				,layout : 'form'
				,items :[
					obj.winTxtSortExtraDesc
				]
			}
		]
		,buttons:[
			obj.winBtnSortAdd
			,{
				xtype: 'tbspacer', 
				width: 50
			}
			,obj.winBtnSortUpdate
			,{
				xtype: 'tbspacer', 
				width: 50
			}
			,obj.winBtnSortDelete
		]
	});
	obj.winItemSortGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.winItemSortGridStore = new Ext.data.Store({
		proxy: obj.winItemSortGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'sortId'
		}, 
		[
			{name: 'sortId', mapping: 'sortId'}
			,{name: 'anciiCode', mapping: 'anciiCode'}
			,{name: 'anciiDesc', mapping: 'anciiDesc'}
			,{name: 'sortValueId', mapping: 'sortValueId'}
			,{name: 'sortValue', mapping: 'sortValue'}
			,{name: 'sortNo', mapping: 'sortNo'}
			,{name: 'sortExtraDesc', mapping: 'sortExtraDesc'}
		])
	});
	obj.winItemSortGridStoreProxy.on('beforeload',function(objProxy, param){
		param.ClassName = 'web.DHCANOPStat';
		param.QueryName = 'GetANCIItemSortList';
		param.Arg1 = obj.winComSortItem.getValue();
		param.ArgCnt = 1;
	});
	obj.winItemSortGridPanel = new Ext.grid.EditorGridPanel({
		id : 'winItemSortGridPanel'
		,store : obj.winItemSortGridStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
		,clicksToEdit:1    //单击编辑
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,cm:new Ext.grid.ColumnModel({
			columns: [
				new Ext.grid.RowNumberer()
				,{header: '项目代码',width: 80,dataIndex: 'anciiCode',sortable: false}
				,{header: '项目描述',width: 80,dataIndex: 'anciiDesc',sortable: false}
				,{header: '值',width: 80,dataIndex: 'sortValueId',sortable: false}
				,{header: '值描述',width: 150,dataIndex: 'sortValue',sortable: false}
				,{header: '排序号',width: 60,dataIndex: 'sortNo',sortable: false}
				,{header: '备注',width: 80,dataIndex: 'sortExtraDesc',sortable: false}
			]
		})
		,viewConfig:
		{
			forceFit: false
		}
	});
	obj.winScreenItemSort = new Ext.Window({
		id : 'winScreenItemSort'
		,height : 450
		,buttonAlign : 'center'
		,width : 650
		,title : '查询项目结果行排序设置'
		,modal : true
		,draggable : true
		,resizable : true
		,closeAction : 'hide'
		,layout : 'border'
		,items:[
			obj.winSortFormPanel
			,obj.winItemSortGridPanel
		]
	});

	obj.winComSortItem_select=function()
	{
		var inquiryItemCode = obj.winComSortItem.getValue();
		var index = obj.ANCInquiryItemStore.find('code',inquiryItemCode);
		obj.winItemSortGridStore.load({});
		obj.ResetRefCommonStore(index,"");
	}
	
	obj.winComSortValue_specialkey=function()
	{
		if(window.event.keyCode==13)
		{
			var inquiryItemCode = obj.winComSortItem.getValue();
			var index = obj.ANCInquiryItemStore.find('code',inquiryItemCode);
			var thisValue = obj.winComSortValue.getRawValue();
			obj.ResetRefCommonStore(index,thisValue);
		}
		else if(window.event.keyCode==8)
		{
			obj.winComSortValue.setValue("");
		}
	}
	
	obj.winBtnSortAdd_click=function()
	{
		var anciiCode = obj.winComSortItem.getValue();
		var anciiDesc = obj.winComSortItem.getRawValue();
		var sortValueId = obj.winComSortValue.getValue();
		var sortValue = obj.winComSortValue.getRawValue();
		var sortNo = obj.winNumSortNo.getValue();
		var sortExtraDesc = obj.winTxtSortExtraDesc.getValue();
		var ret = obj._DHCANOPStat.AddANCIItemSort(anciiCode+"^"+anciiDesc+"^"+sortValueId+"^"+sortValue+"^"+sortNo+"^"+sortExtraDesc);
		if(ret=="0")
		{
			obj.winItemSortGridStore.load({});
			alert("添加成功");
		}
		else
		{
			alert("添加失败:"+ret);
		}
	}
	
	obj.winBtnSortUpdate_click=function()
	{
		var sortId = "";
		var rowSelectObj=obj.winItemSortGridPanel.getSelectionModel().getSelected();
		if(rowSelectObj)
		{
			sortId = rowSelectObj.get("sortId");
		}
		else
		{
			alert("请选中一行再点击修改!");
			return;
		}
		var anciiCode = obj.winComSortItem.getValue();
		var anciiDesc = obj.winComSortItem.getRawValue();
		var sortValueId = obj.winComSortValue.getValue();
		var sortValue = obj.winComSortValue.getRawValue();
		var sortNo = obj.winNumSortNo.getValue();
		var sortExtraDesc = obj.winTxtSortExtraDesc.getValue();
		var ret = obj._DHCANOPStat.UpdateANCIItemSort(sortId,anciiCode+"^"+anciiDesc+"^"+sortValueId+"^"+sortValue+"^"+sortNo+"^"+sortExtraDesc);
		if(ret=="0")
		{
			obj.winItemSortGridStore.load({});
			alert("更新成功");
		}
		else
		{
			alert("更新失败:"+ret);
		}
	}
	
	obj.winBtnSortDelete_click=function()
	{
		var sortId = "";
		var rowSelectObj=obj.winItemSortGridPanel.getSelectionModel().getSelected();
		if(rowSelectObj)
		{
			sortId = rowSelectObj.get("sortId");
		}
		else
		{
			alert("请选中一行再点击删除!");
			return;
		}
		var ret = obj._DHCANOPStat.DeleteANCIItemSort(sortId);
		if(ret=="0")
		{
			obj.winItemSortGridStore.load({});
			alert("更新成功");
		}
		else
		{
			alert("更新失败:"+ret);
		}
	}
	
	obj.winItemSortGridPanel_rowclick=function()
	{
		var rowSelectObj=obj.winItemSortGridPanel.getSelectionModel().getSelected();
		if(rowSelectObj)
		{
			obj.winComSortItem.setValue(rowSelectObj.get("anciiCode"));
			obj.winComSortItem.setRawValue(rowSelectObj.get("anciiDesc"));
			obj.winComSortValue.setValue(rowSelectObj.get("sortValueId"));
			obj.winComSortValue.setRawValue(rowSelectObj.get("sortValue"));
			obj.winNumSortNo.setValue(rowSelectObj.get("sortNo"));
			obj.winTxtSortExtraDesc.setValue(rowSelectObj.get("sortExtraDesc"));
		}
	}

	obj.menuItemSetItemSort_click=function(args)
	{
		obj.SetAllInquiryItem("");
		obj.winItemSortGridStore.load({});
		obj.winScreenItemSort.show();
	}

	obj.menuItemSetItemSort.on('click',obj.menuItemSetItemSort_click,obj);
	obj.winComSortItem.on("select",obj.winComSortItem_select,obj);
	obj.winComSortValue.on("specialkey",obj.winComSortValue_specialkey,obj);
	obj.winBtnSortAdd.on("click",obj.winBtnSortAdd_click,obj);
	obj.winBtnSortUpdate.on("click",obj.winBtnSortUpdate_click,obj);
	obj.winBtnSortDelete.on("click",obj.winBtnSortDelete_click,obj);
	obj.winItemSortGridPanel.on("rowclick",obj.winItemSortGridPanel_rowclick,obj);
}