function InitStartConfig(SubjectID){
	var obj = new Object();
	obj.SubjectID = "";
	if (!SubjectID) {
		obj.SubjectID = SubjectID;
	}
	
  obj.IDListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.IDListStore = new Ext.data.Store({
		proxy: obj.IDListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Description', mapping: 'Description'}
			,{name: 'VarName', mapping: 'VarName'}
			,{name: 'RunType', mapping: 'RunType'} 
			,{name: 'SubjectID', mapping: 'SubjectID'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'StartIndex', mapping: 'StartIndex'}
			,{name: 'Expression', mapping: 'Expression'}
			,{name: 'ResumeText', mapping: 'ResumeText'}
	])});
	obj.IDListCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.IDList = new Ext.grid.GridPanel({
		store : obj.IDListStore
		,loadMask : true
		,region : 'center'
		,height : 130
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '代码', width: 100, dataIndex: 'Code', sortable: true}
			,{header: '描述', width: 100, dataIndex: 'Description', sortable: true}
			,{header: '变量名', width: 100, dataIndex: 'VarName', sortable: true}
			,{header: '有效', width: 100, dataIndex: 'IsActive', sortable: true, 
					renderer : function(v)
					{
						if(v == "1")
							return "<IMG SRC='../scripts/dhcmed/img/accept.png' height='16px' width='16px'/>";
						else
							return "";	
					}
				}
			,{header: '表达式', width: 100, dataIndex: 'Expression', sortable: true}
		]
		,viewConfig : {
			forceFit : true
		}
	});
	
	
	obj.IDCode = new Ext.form.TextField({
		fieldLabel : '代码'
		,anchor : '99%'
	});
	obj.Description = new Ext.form.TextField({
		fieldLabel : '描述'
		,anchor : '99%'
	});
	obj.VarName = new Ext.form.TextField({
		anchor : '99%'
		,fieldLabel : '变量名'
	});
	
	var myRunTypeData = [
		['S', '初始化虚拟机时运行'],
		['L', '监控每个病人时运行']
	];
	
	
	obj.cboRunTypeStore = new Ext.data.ArrayStore({
        fields: [
           {name: 'Code'},
           {name: 'Desc'}
        ]
    });
 	obj.cboRunTypeStore.loadData(myRunTypeData);	   
	obj.cboRunType = new Ext.form.ComboBox({
				width : 215,
				store : obj.cboRunTypeStore,
				fieldLabel : '运行类别',
        displayField:'Desc',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
				valueField : 'Code',
				editable : false
			});

	obj.IsActive = new Ext.form.Checkbox({
		checked : true
		,fieldLabel : '有效'
	});
	obj.pnExpression = new Ext.form.TextField({
		buttonAlign : 'center'
		,fieldLabel : '表达式'
		,anchor : '99%'
	});
	obj.cboStartIndex = new Ext.form.NumberField({
					
					name:'number'
    			,fieldLabel:"启动顺序"
    			,allowNegative: false       //不允许输入负数
    			,allowDecimals: false  //不允许输入小数
    			,nanText: "请输入有效数字" //无效数字提示
    			,minValue : 0
					,maxValue : 150
					,minText : "输入的数字必须大于0"
					,maxText : "输入的数字必须小于150"
					,anchor : '99%'
 					
   });
	obj.pnResumeText = new Ext.form.TextArea({
		fieldLabel : '备注'
		,anchor : '75%'	
});
	obj.btnFind = new Ext.Button({
	  iconCls : 'icon-find'
		,anchor : '99%'
		,text : '查询'
	});
	obj.btnSave = new Ext.Button({
		iconCls : 'icon-save'
		,anchor : '99%'
		,text : '保存'
	});
	obj.btnDelete = new Ext.Button({
		iconCls : 'icon-delete'
		,anchor : '99%'
		,text : '删除'
	});
	
	obj.pnfItemLeft = new Ext.Panel({
		layout : 'form'
		,labelAlign : 'right'
		,labelWidth : 60
		,columnWidth : .50
		,items:[
			obj.IDCode
			,obj.Description
			,obj.VarName
			,obj.cboRunType
		]
	});
	obj.pnfItemRight = new Ext.Panel({
		layout : 'form'
		,labelAlign : 'right'
		,labelWidth : 90
		,columnWidth : .50
		,items:[
			//obj.cboTitle,
			obj.IsActive
			,obj.pnExpression
			,obj.cboStartIndex
			
		]
	}); 
	 
	obj.pnItemUp = new Ext.Panel({
		layout : 'column'
		,anchor : '100%'
		,items:[
			obj.pnfItemLeft
			,obj.pnfItemRight
		]
	});
	obj.Panel = new Ext.Panel({
		buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,columnWidth : .70
		,region : 'south'
		,layout : 'form'
		,height: 280
		,title:'信息编辑'
		,frame : true
		,items:[
			obj.pnItemUp
			,obj.pnResumeText
		]
		,buttons:[
			obj.btnFind
			,obj.btnSave
			,obj.btnDelete
		]
	});
		obj.winStartConfig = new Ext.Window({
		title : '自动监控启动设置'
		,layout : 'border'
		,height : 500
		,width : 600
		,modal : true
		,items:[
			obj.IDList
			,obj.Panel
		]
	});
	obj.IDListStoreProxy.on('beforeload', function(objProxy, param){
				param.ClassName = 'DHCMed.CCService.Sys.VMStartConfigSrv';
				param.QueryName = 'QryBySubject';
				//alert(obj.SubjectID);
				param.Arg1 = SubjectID;
				param.Arg2 = "";
				param.ArgCnt =2;
	});
	obj.IDListStore.load({});
	InitStartConfigEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}