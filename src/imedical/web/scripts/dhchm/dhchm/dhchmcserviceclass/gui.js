function InitViewport1(){
	var obj = new Object();
	
	obj.ID = new Ext.form.TextField({
		id : 'ID'
		,hidden : true
});
	obj.ID1 = new Ext.form.TextField({
		id : 'ID1'
		,hidden : true
});
	obj.SCCode = new Ext.form.TextField({
		id : 'SCCode'
		,fieldLabel : ExtToolSetting.RedStarString+'代码'
		,allowBlank:false
});
	obj.SCPrice = new Ext.form.NumberField({
		id : 'SCPrice'
		,fieldLabel : '建议价格'
});
	obj.SCActive = new Ext.form.Checkbox({
		id : 'SCActive'
		,fieldLabel : '激活'
		,checked:true
});
	obj.Panel7 = new Ext.Panel({
		id : 'Panel7'
		,buttonAlign : 'center'
		,columnWidth : .5
		,defaults:{anchor:"90%"}
		,labelWidth:55
		,layout : 'form'
		,items:[
			obj.SCCode
			,obj.SCPrice
			,obj.SCActive
		]
	});
	obj.SCDesc = new Ext.form.TextField({
		id : 'SCDesc'
		,region : 'west'
		,fieldLabel : ExtToolSetting.RedStarString+'描述'
		,allowBlank:false
});
	obj.SCMonths = new Ext.form.NumberField({
		id : 'SCMonths'
		,fieldLabel : '随访间隔时间(月)'
});
	obj.Panel81 = new Ext.Panel({
		id : 'Panel81'
		,defaults:{anchor:"90%"}
		,labelWidth:55
		
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.SCDesc
			,obj.SCMonths
		]
	});
	obj.Panel8 = new Ext.Panel({
		id : 'Panel8'
		,buttonAlign : 'center'
		//,width : 600
		
		,region : 'column'
		,columnWidth : .5
		,layout : 'column'
		,items:[
			obj.Panel7
			,obj.Panel81
		]
	});
	obj.SCRemark = new Ext.form.TextArea({
		id : 'SCRemark'
		//,width : 350
		,fieldLabel : '备注'
});
	obj.Panel9 = new Ext.Panel({
		id : 'Panel9'
		,buttonAlign : 'center'
		//,width : 600
		,defaults:{anchor:"90%"}
		,labelWidth:55
		,layout : 'form'
		,items:[
			obj.SCRemark
			,obj.ID
		]
	});
	obj.btSave = new Ext.Button({
		id : 'btSave'
		,iconCls : 'icon-save'
		,text :  '保存'
});
	obj.btCancel = new Ext.Button({
		id : 'btCancel'
		,iconCls : 'icon-new'
		,text : '  清空'
});
	obj.btFind = new Ext.Button({
		id : 'btFind'
		,iconCls : 'icon-find'
		,text : '查找'
});
	obj.FormPanel3 = new Ext.form.FormPanel({
		
		id : 'FormPanel3'
		,region : 'north'
		,height : 220
		,labelAlign : 'right'
		,buttonAlign : 'center'
		,labelWidth : 110
		,title : '服务级别维护'
		,layout : 'form'
		,frame : true
		,items:[
			obj.Panel8
			,obj.Panel9
		]
	,	buttons:[
			obj.btSave
			,obj.btCancel
			//,obj.btFind
		]
	});
	obj.ItemListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.ItemListStore = new Ext.data.Store({
		proxy: obj.ItemListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			
			{name: 'ID', mapping: 'ID'}
			,{name: 'SCCode', mapping: 'SCCode'}
			,{name: 'SCDesc', mapping: 'SCDesc'}
			,{name: 'SCActive', mapping: 'SCActive'}
			,{name: 'SCPrice', mapping: 'SCPrice'}
			,{name: 'SCMonths', mapping: 'SCMonths'}
			,{name: 'SCRemark', mapping: 'SCRemark'}
		])
	});

	obj.ItemList = new Ext.grid.GridPanel({
		id : 'ItemList'
		,buttonAlign : 'center'
		,store : obj.ItemListStore
		,region : 'center'
		,columns: [
			
			{header: '代码', width: 100, dataIndex: 'SCCode', sortable: true}
			,{header: '描述', width: 100, dataIndex: 'SCDesc', sortable: true}
			,{header: '激活', width: 50, dataIndex: 'SCActive', sortable: true,renderer:ShowCheckStatus}
			,{header: '建议价格', width: 100, dataIndex: 'SCPrice', sortable: true}
			,{header: '随访间隔时间', width: 50, dataIndex: 'SCMonths', sortable: true}
			,{header: '备注', width: 100, dataIndex: 'SCRemark', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.ItemListStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})


		});

	obj.Panel18 = new Ext.Panel({
		id : 'Panel18'
		,buttonAlign : 'center'
		,width : 520
		,height:500
		,region : 'center'
		,layout : 'border'
	
		,items:[
			obj.FormPanel3
			,obj.ItemList
		]
	});
	obj.SCQLParRef = new Ext.form.Label({
		id : 'SCQLParRef'
		,fieldLabel : '所属级别ID'
		,text : '-----'
});
	obj.SCQuestionnaireDRStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.SCQuestionnaireDRStore = new Ext.data.Store({
		proxy: obj.SCQuestionnaireDRStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			
			,{name: 'ID', mapping: 'ID'}
			,{name: 'QActive', mapping: 'QActive'}
			,{name: 'QCode', mapping: 'QCode'}
			,{name: 'QDesc', mapping: 'QDesc'}
			,{name: 'QRemark', mapping: 'QRemark'}
			,{name: 'QType', mapping: 'QType'}
		])
	});
	obj.SCQuestionnaireDR = new Ext.form.ComboBox({
		id : 'SCQuestionnaireDR'
		,minChars : 1
		,store : obj.SCQuestionnaireDRStore
		,fieldLabel : ExtToolSetting.RedStarString+'问卷'
		,displayField : 'QDesc'
		,valueField : 'ID'
		,triggerAction : 'all'
		,width:128
		,allowBlank:false
});

	
	obj.SCQLOrder = new Ext.form.NumberField({
		id : 'SCQLOrder'
		,fieldLabel : ExtToolSetting.RedStarString+'顺序号'
		,allowBlank:false
});
	obj.btSubSave = new Ext.Button({
		id : 'btSubSave'
		,text : '保存'
		,iconCls : 'icon-save'
		
});
	obj.btSubCancel = new Ext.Button({
		id : 'btSubCancel'
		,text : '清空'
		,iconCls : 'icon-new'
});
	obj.btDelete = new Ext.Button({
		id : 'btDelete'
		,iconCls : 'icon-delete'
		,text : '删除'
});
	obj.FormPanel2 = new Ext.form.FormPanel({
		id : 'FormPanel2'
		,labelAlign : 'right'
		
	 ,height:210
		,region : 'north'
		,labelWidth : 80
		,title : '关联问卷'
		
		,buttonAlign : 'center'
		,items:[
			obj.SCQLParRef
			,obj.SCQuestionnaireDR
			,obj.SCQLOrder
			,obj.ID1
		]
	,	buttons:[
			obj.btSubSave
			,obj.btSubCancel
			,obj.btDelete
		]
	});
	obj.GridPanel10StoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.GridPanel10Store = new Ext.data.Store({
		proxy: obj.GridPanel10StoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
	
			,{name: 'ID1', mapping: 'ID'}
			,{name: 'SCQLParRef', mapping: 'SCQLParRef'}
			,{name: 'QDesc', mapping: 'QDesc'}
			,{name: 'SCQLCQuestionnaireDR', mapping: 'SCQLCQuestionnaireDR'}
			,{name: 'SCQLOrder', mapping: 'SCQLOrder'}
			,{name: 'QRemark', mapping: 'QRemark'}
		])
	});

	obj.GridPanel10 = new Ext.grid.GridPanel({
		id : 'GridPanel10'
		,store : obj.GridPanel10Store
		,region : 'center'
		,height:380
		,buttonAlign : 'center'
		,columns: [
			
			{header: '问卷', width: 200, dataIndex: 'QDesc', sortable: true}
			,{header: '顺序', width: 50, dataIndex: 'SCQLOrder', sortable: true}
			,{header: '备注', width: 100, dataIndex: 'QRemark', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.GridPanel10Store,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})

});
	obj.thepopwin = new Ext.Panel({
		id : 'thepopwin'
		,width : 450
		,frame:true
		,buttonAlign : 'center'
                ,layout : 'border'
		,region : 'east'
		,items:[
			obj.FormPanel2
			,obj.GridPanel10
		]
	});


ExtTool.SetTabIndex("SCCode$1^SCDesc$2^SCPrice$3^SCMonths$4^SCActive$5^SCRemark$6");

	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'

		,layout : 'border'
		,items:[
			obj.Panel18
			,obj.thepopwin
			
			
		]
	});
	obj.ItemListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCHM.BaseDataSet';
			param.QueryName = 'GetCServiceClass';
			param.Arg1 = obj.SCCode.getValue();
			param.Arg2 = obj.SCDesc.getValue();
			param.Arg3 = obj.SCActive.getValue();
			param.Arg4 = obj.SCMonths.getValue();
			param.Arg5 = obj.SCPrice.getValue();
			param.Arg6 = obj.SCRemark.getValue();
			param.ArgCnt = 6;
			//SCActive^SCCode^SCDesc^SCMonths^SCPrice^SCRemark
	});
	obj.ItemListStore.load({
	params : {
		start:0
		,limit:20
	}});

	obj.SCQuestionnaireDRStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCHM.BaseDataSet';
			param.QueryName = 'GetCQuestionnaire';
			param.ArgCnt = 0;
	});
	obj.GridPanel10StoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCHM.BaseDataSet';
			param.QueryName = 'GetCSCQLink';
			param.Arg1 = obj.SCQLParRef.text;
			param.ArgCnt = 1;
	});
	obj.GridPanel10Store.load({
	params : {
		start:0
		,limit:20
	}});

	InitViewport1Event(obj);
	//事件处理代码
	obj.btSave.on("click", obj.btSave_click, obj);
	obj.btCancel.on("click", obj.btCancel_click, obj);
	obj.btFind.on("click", obj.btFind_click, obj);
	obj.ItemList.on("cellclick", obj.ItemList_cellclick, obj);
	obj.ItemList.on("rowclick", obj.ItemList_rowclick, obj);
	obj.btSubSave.on("click", obj.btSubSave_click, obj);
	obj.btSubCancel.on("click", obj.btSubCancel_click, obj);
	obj.btDelete.on("click", obj.btDelete_click, obj);
	obj.GridPanel10.on("rowclick", obj.GridPanel10_rowclick, obj);
  obj.LoadEvent(arguments);
  
  function ShowCheckStatus(v, p, record){
  
 
  	p.css += ' x-grid3-check-col-td';
            return '<div class="x-grid3-check-col' +
           (v == 'true' ? '-on' : '')+
            ' x-grid3-cc-' +
            this.id +
            '">&#160;</div>';
  }
  
    obj.SCCode.focus(true,3); 
  return obj;
}

