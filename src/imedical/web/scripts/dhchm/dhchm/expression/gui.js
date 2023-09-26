function InitWindowEx(){
	var obj = new Object();
	obj.ECQuestionnaireDRStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.ECQuestionnaireDRStore = new Ext.data.Store({
		proxy: obj.ECQuestionnaireDRStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ECQuestionnaireDR'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ECQuestionnaireDR', mapping: 'ECQuestionnaireDR'}
			,{name: 'QActive', mapping: 'QActive'}
			,{name: 'QCode', mapping: 'QCode'}
			,{name: 'QDesc', mapping: 'QDesc'}
			,{name: 'QRemark', mapping: 'QRemark'}
			,{name: 'QType', mapping: 'QType'}
		])
	});
	obj.ECQuestionnaireDR = new Ext.form.ComboBox({
		id : 'ECQuestionnaireDR'
		,minChars : 1
		,store : obj.ECQuestionnaireDRStore
		,fieldLabel : ExtToolSetting.RedStarString+'问卷'
		,displayField : 'QDesc'
		,valueField : 'ECQuestionnaireDR'
		,triggerAction : 'all'
		,mode : 'local'
		,allowBlank:false
});
	obj.EAgeMin = new Ext.form.NumberField({
		id : 'EAgeMin'
		,fieldLabel : '年龄下限'
});
obj.ExTypeStore = new Ext.data.SimpleStore({
        fields: ['ExTypeCode', 'ExTypeDesc'],
        data: [['F', '函数'], ['E', '表达式']]
    });
	obj.EExpressionType = new Ext.form.ComboBox({
		id : 'EExpressionType'
		,minChars : 1
		,fieldLabel : '表达式类型'
		,triggerAction : 'all'
		,store: obj.ExTypeStore
    ,mode: 'local'
    ,valueField: 'ExTypeCode'
    ,displayField: 'ExTypeDesc'
    ,value: 'E'
});
	obj.EParameters = new Ext.form.TextField({
		id : 'EParameters'
		,fieldLabel : '参数'
});
	obj.ESourceID = new Ext.form.TextField({
		id : 'ESourceID'
		,hidden : true
});
	obj.ExID = new Ext.form.TextField({
		id : 'ExID'
		,hidden : true
});
	obj.PanelEx1 = new Ext.Panel({
		id : 'PanelEx1'
		,defaults : {width : 200}
		,height : 120
		,buttonAlign : 'center'
		,width : 404
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.ECQuestionnaireDR
			,obj.EAgeMin
			,obj.EExpressionType
			,obj.EParameters
			,obj.ESourceID
			,obj.ExID
		]
	});
	obj.SexStore = new Ext.data.SimpleStore({
        fields: ['SexCode', 'SexDesc'],
        data: [['M', '男'], ['F', '女'], ['N', '不限']]
    });
  
	obj.ESex = new Ext.form.ComboBox({
		id : 'ESex'
		,minChars : 1
		,fieldLabel : '性别'
		,triggerAction : 'all'
		,store: obj.SexStore
    ,mode: 'local'
    ,valueField: 'SexCode'
    ,displayField: 'SexDesc'
    ,value: 'N'
});
	obj.EAgeMax = new Ext.form.NumberField({
		id : 'EAgeMax'
		,fieldLabel : '年龄上限'
});
	obj.EExpression = new Ext.form.TextField({
		id : 'EExpression'
		,fieldLabel : '表达式'
});
	obj.EUnit = new Ext.form.TextField({
		id : 'EUnit'
		,fieldLabel : '单位'
});
	obj.EType = new Ext.form.TextField({
		id : 'EType'
		,hidden : true
});
	obj.PanelEx2 = new Ext.Panel({
		id : 'PanelEx2'
		,defaults : {width : 200}
		,height : 120
		,buttonAlign : 'center'
		,width : 404
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.ESex
			,obj.EAgeMax
			,obj.EExpression
			,obj.EUnit
			,obj.EType
		]
	});
	obj.ERemark = new Ext.form.TextArea({
		id : 'ERemark'
		,width : 500
		,fieldLabel : '备注'
});
	obj.PanelEx3 = new Ext.Panel({
		id : 'PanelEx3'
		,height : 65
		,buttonAlign : 'center'
		,width : 808
		,columnWidth : 1
		,layout : 'form'
		,items:[
			obj.ERemark
		]
	});
	obj.ExSave = new Ext.Button({
		id : 'ExSave'
		,iconCls : 'icon-save'
		,text : '保存'
});
	obj.ExClear = new Ext.Button({
		id : 'ExClear'
		,iconCls : 'icon-new'
		,text : '清空'
});
	obj.ExDelete = new Ext.Button({
		id : 'ExDelete'
		,iconCls : 'icon-cancel'
		,text : '删除'
});
	obj.FormPanelEx = new Ext.form.FormPanel({
		id : 'FormPanelEx'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 240
		,region : 'north'
		,layout : 'column'
		,frame : true
		,width : 820
		,items:[
			obj.PanelEx1
			,obj.PanelEx2
			,obj.PanelEx3
		]
	,	buttons:[
			obj.ExSave
			,obj.ExClear
			,obj.ExDelete
		]
	});
	obj.GridPanelExStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.GridPanelExStore = new Ext.data.Store({
		proxy: obj.GridPanelExStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ExID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ExID', mapping: 'ExID'}
			,{name: 'QDesc', mapping: 'QDesc'}
			,{name: 'EExpression', mapping: 'EExpression'}
			,{name: 'EExpressionType', mapping: 'EExpressionType'}
			,{name: 'EParameters', mapping: 'EParameters'}
			,{name: 'ESex', mapping: 'ESex'}
			,{name: 'EAgeMax', mapping: 'EAgeMax'}
			,{name: 'EAgeMin', mapping: 'EAgeMin'}
			,{name: 'EUnit', mapping: 'EUnit'}
			,{name: 'ERemark', mapping: 'ERemark'}
			,{name: 'ECQuestionnaireDR', mapping: 'ECQuestionnaireDR'}
			,{name: 'ESourceID', mapping: 'ESourceID'}
			,{name: 'EType', mapping: 'EType'}
		])
	});
	obj.GridPanelExCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.GridPanelEx = new Ext.grid.GridPanel({
		id : 'GridPanelEx'
		,height : 245
		,buttonAlign : 'center'
		,width : 820
		,region : 'center'
		,store : obj.GridPanelExStore
		,columns: [
			{header: 'ID', width: 0, dataIndex: 'ExID', sortable: true}
			,{header: '问卷', width: 100, dataIndex: 'QDesc', sortable: true}
			,{header: '表达式', width: 100, dataIndex: 'EExpression', sortable: true}
			,{header: '表达式类型', width: 100, dataIndex: 'EExpressionType', sortable: true, renderer: function(value)
				{
					if(value == 'E'){return '表达式'}
					if(value == 'F'){return '函数'}
				}}
			,{header: '参数', width: 80, dataIndex: 'EParameters', sortable: true}
			,{header: '性别', width: 60, dataIndex: 'ESex', sortable: true, 
				renderer:function(value)
				{
				if(value == 'M'){return '男'}
				if(value == 'F'){return '女'}
				if(value == 'N'){return '不限'}
				}}
			,{header: '年龄上限', width: 80, dataIndex: 'EAgeMax', sortable: true}
			,{header: '年龄下限', width: 80, dataIndex: 'EAgeMin', sortable: true}
			,{header: '单位', width: 80, dataIndex: 'EUnit', sortable: true}
			,{header: '备注', width: 100, dataIndex: 'ERemark', sortable: true}
			,{header: 'ECQuestionnaireDR', width: 0, dataIndex: 'ECQuestionnaireDR', sortable: true}
			,{header: 'ESourceID', width: 0, dataIndex: 'ESourceID', sortable: true}
			,{header: 'EType', width: 0, dataIndex: 'EType', sortable: true}
		]});

	obj.WindowEx = new Ext.Window({
		id : 'WindowEx'
		,height : 517
		,buttonAlign : 'center'
		,width : 650
		,title : '表达式维护'
		,layout : 'border'
		,modal : true
		,items:[
			obj.FormPanelEx
			,obj.GridPanelEx
		]
		,constrain:true
	});
	obj.ECQuestionnaireDRStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCHM.ExpressionSet';
			param.QueryName = 'FindQN';
			param.ArgCnt = 0;
	});
	obj.ECQuestionnaireDRStore.load({});
	obj.GridPanelExStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCHM.ExpressionSet';
			param.QueryName = 'FindExpression';
			param.Arg1 = obj.ESourceID.getValue();
			param.Arg2 = obj.EType.getValue();
			param.ArgCnt = 2;
	});
	InitWindowExEvent(obj);
	//事件处理代码
	obj.ExSave.on("click", obj.ExSave_click, obj);
	obj.ExClear.on("click", obj.ExClear_click, obj);
	obj.ExDelete.on("click", obj.ExDelete_click, obj);
	obj.GridPanelEx.on("rowclick", obj.GridPanelEx_rowclick, obj);
  obj.LoadEvent(arguments);
  return obj;
}

