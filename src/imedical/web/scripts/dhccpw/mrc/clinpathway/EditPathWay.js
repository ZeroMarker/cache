/*!
 * 编写日期:2010-04-27
 * 作者：李宇峰
 * 说明：临床路径的维护界面
 * 名称：EditPathWay.js
 */
function EditPathWay(WayRowid){
	var obj = new Object();
	obj.pathWayRowid=""
	obj.updateType=""
	//obj.pageSize=50
	obj.PathWayStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
	}));
	
	obj.PathWayStore = new Ext.data.Store({
		proxy: obj.PathWayStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'code', mapping: 'code'}
			,{name: 'desc', mapping: 'desc'}
			,{name: 'active', mapping: 'active'}
			,{name: 'dateFrom', mapping: 'dateFrom'}
			,{name: 'dateTo', mapping: 'dateTo'}
			,{name: 'type', mapping: 'type'}
			,{name: 'typeDesc', mapping: 'typeDesc'}
			,{name: 'cost', mapping: 'cost'}
			,{name: 'CPWDays', mapping: 'CPWDays'}
			,{name: 'CPWICD', mapping: 'CPWICD'}
			,{name: 'CPWLabel', mapping: 'CPWLabel'}
		])
	});
	obj.PathWayGrid = new Ext.grid.GridPanel({
		id : 'PathWayGrid'
		,store : obj.PathWayStore
		,buttonAlign : 'center',
		region:"center"
		,height : 270
		,width:590
		,columns: [
			{header: '代码', width: 80, dataIndex: 'code', sortable: true}
			,{header: '名称', width: 200, dataIndex: 'desc', sortable: true}
			,{header: '激活标志', width: 50, dataIndex: 'active', sortable: true}
			,{header: '开始日期', width: 80, dataIndex: 'dateFrom', sortable: true}
			,{header: '结束日期', width: 80, dataIndex: 'dateTo', sortable: true}
			,{header: '类型', width: 100, dataIndex: 'typeDesc', sortable: true}
			,{header: '参考费用', width: 80, dataIndex: 'cost', sortable: false}
			,{header: '参考天数', width: 60, dataIndex: 'CPWDays', sortable: false}
			,{header: '准入ICD', width: 60, dataIndex: 'CPWICD', sortable: false}
			,{header: '准入提示', width: 60, dataIndex: 'CPWLabel', sortable: false}
		]
		/*,bbar: new Ext.PagingToolbar({
			pageSize : obj.pageSize,
			store : obj.PathWayStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})*/

});
	obj.PathWayLab1 = new Ext.form.Label({
		id : 'PathWayLab1'
		,height : 10
		,width : 100
		,anchor : '99%'
});
	obj.PathCode = new Ext.form.TextField({
		id : 'PathCode'
		,width : 200
		,anchor : '99%'
		,allowBlank:false
		,validateOnBlur: false
		,fieldLabel : '代码'
});
	obj.PathDesc = new Ext.form.TextField({
		id : 'PathDesc'
		,width : 200
		,anchor : '99%'
		,allowBlank:false
		,validateOnBlur: false
		,fieldLabel : '名称'
});
	obj.PathActive = new Ext.form.ComboBox({
		id:'cpwActive'
		,fieldLabel:"激活标志"
		,width:200
		,anchor : '99%'
		,msgTarget:'under'
		,validationEvent: false
    	,validateOnBlur: false
		,displayField:'active'
		,valueField:'active'
		,editable:false
		,triggerAction: 'all'
		,mode:'local'
    	,store:new Ext.data.ArrayStore({
	      	fields:['active']
	      	,data:	[[''],['Yes'],['No']]
      	})
	});
	obj.PathDateFrom = new Ext.form.DateField({
		id : 'PathDateFrom'
		,fieldLabel : '开始日期'
		,allowBlank:false
		,validateOnBlur: false
		,format:"Y-m-d"
		,width : 200
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
	});
	obj.PathDateTo = new Ext.form.DateField({
		id : 'PathDateTo'
		,fieldLabel : '结束日期'
		,format:"Y-m-d"
		,width : 200
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
	});
	obj.PathCost = new Ext.form.TextField({
		id : 'PathCost'
		,width : 200
		,anchor : '99%'
		//,allowBlank:false
		,validateOnBlur: false
		,fieldLabel : '参考费用'
	});
	obj.PathDays = new Ext.form.TextField({
		id : 'PathDays'
		,width : 200
		,anchor : '99%'
		//,allowBlank:false
		,validateOnBlur: false
		,fieldLabel : '参考天数'
	});
	obj.PathICD = new Ext.form.TextField({
		id : 'PathICD'
		,width : 200
		,anchor : '99%'
		//,allowBlank:false
		,validateOnBlur: false
		,fieldLabel : '准入ICD'
	});
	obj.PathLabel = new Ext.form.TextField({
		id : 'PathLabel'
		,width : 200
		,anchor : '99%'
		//,allowBlank:false
		,validateOnBlur: false
		,fieldLabel : '准入提示'
	});
	obj.PathTypeComStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.PathTypeComStore = new Ext.data.Store({
		proxy: obj.PathTypeComStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			id: 'Rowid'
		}, 
		[
			{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Code', mapping: 'code'}
			,{name: 'Desc', mapping: 'desc'}
		])
	});
	obj.PathTypeCom = new Ext.form.ComboBox({
		id:'com_pathType',
		width:200,
		anchor : '99%',
		store:obj.PathTypeComStore,
		displayField:'Desc',
		fieldLabel:"类型",
		triggerAction:'all',
		valueField:'Rowid',
		editable:false,
		pageSize:15
		//forceSelection:true,
		//selectOnfocus:true,
		//validationEvent:false,
		//validateOnBlur:false,
		//msgTarget:'under',
		//mode:'remote'
	});
	
	obj.PathAdd = new Ext.Button({
		id : 'PathAdd'
		,text : '添加',
		iconCls:"icon-add"
	});
	
	obj.PathUpdate = new Ext.Button({
		id : 'PathUpdate'
		,text : '保存',
		iconCls:"icon-save"
	});
	
	obj.ClearBtn = new Ext.Button({
		id : 'Path_ClearBtn'
		,text : '清空',
		iconCls:"icon-cancel"
	});
	
	obj.PathDelete = new Ext.Button({
		id : 'PathDelete'
		,text : '删除',
		iconCls:"icon-delete"
	});
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,text : '查询',
		iconCls:"icon-find"
	});

	obj.SubPanel1 = new Ext.Panel({
		id : 'SubPanel1'
		,buttonAlign : 'center'
		,columnWidth : .01
		,layout : 'form'
		,items:[
		]
	});
	obj.SubPanel4 = new Ext.Panel({
		id : 'SubPanel4'
		,buttonAlign : 'center'
		,columnWidth : .01
		,layout : 'form'
		,items:[
		]
	});
	obj.SubPanel3 = new Ext.Panel({
		id : 'SubPanel3'
		,buttonAlign : 'center'
		,columnWidth : .49
		,layout : 'form'
		,items:[
			obj.PathDateFrom
			,obj.PathDateTo
			,obj.PathCost
			,obj.PathDays
			,obj.PathLabel
		]
	});
obj.SubPanel2 = new Ext.Panel({
		id : 'SubPanel2'
		,buttonAlign : 'center'
		,columnWidth : .49
		,layout : 'form'
		,items:[
				obj.PathCode
				,obj.PathDesc
				,obj.PathActive
				,obj.PathTypeCom
				,obj.PathICD
		]
	});

obj.formPanel=new Ext.form.FormPanel({
					id : 'panelTitle'
					,buttonAlign : 'center'
					,labelWidth : 70
					,labelAlign : 'right'
					,height : 150
					,frame : true
					,layout:'column'
					,region : 'south'
					,items:[
						obj.SubPanel1
						,obj.SubPanel2
						,obj.SubPanel3
						,obj.SubPanel4
					]
				})

	obj.PathWayWin = new Ext.Window({
		id : 'PathWayWin'
		,height : 650
		,buttonAlign : 'center'
		,width : 900
		,title : '临床路径维护'
		,layout : 'border'
		,closeAction: 'close',
		resizable:false
		,closable:true
		,modal: true
		,items:[
			obj.PathWayGrid,
			obj.formPanel
		]
		,buttons:[
			obj.btnQuery
			,obj.PathUpdate
			,obj.ClearBtn
			,obj.PathAdd
			,obj.PathDelete
			
		]
	});
	obj.PathWayStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.CliPathWay';
			param.QueryName = 'GetPathWays';
			param.Arg1=obj.PathTypeCom.getValue();
			param.ArgCnt = 1;
	});
	obj.PathWayStore.load({});
	obj.PathTypeComStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.PathWayType';
			param.QueryName = 'GetPathWayType';
			param.ArgCnt = 0;
	});
	obj.PathTypeComStore.load({});
	EditPathWayEvent(obj,WayRowid);
	
	//事件处理代码
	obj.LoadEvent();
  
	return obj;
}

