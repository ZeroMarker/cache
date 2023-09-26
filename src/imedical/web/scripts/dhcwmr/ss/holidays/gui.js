function InitViewport1()
{
	var obj = new Object();
	obj.RecRowID = "";

	obj.TextYear = Common_TextField("TextYear","年份");
	obj.InputDate = Common_DateFieldToDate("InputDate","日期");
	obj.InputName = Common_TextField("InputName","节日名称");
	obj.InputHAlias = Common_TextField("InputHAlias","节假日别名");

	obj.InputType = new Ext.form.ComboBox({
		id : 'InputType'
		,name :'InputType'
		,fieldLabel : '节日类型'
		,labelSeparator :''
		,mode : 'local'
		,valueField : 'svalue'
		,displayField : 'stext'
		,triggerAction : 'all'
		,value : 'H'
		,anchor : '100%'
		,store: new Ext.data.ArrayStore({
			fields:[
			        'svalue',
			        'stext'
			],
			data:[["H","节假日"],["W","工作日"]]
		})
	});

	obj.cboType = new Ext.form.ComboBox({
		id : 'cboType'
		,name :'cboType'
		,fieldLabel : '类型'
		,labelSeparator :''
		,mode : 'local'
		,valueField : 'svalue'
		,displayField : 'stext'
		,triggerAction : 'all'
		,value : 'A'
		,anchor : '100%'
		,store: new Ext.data.ArrayStore({
			fields:[
			        'svalue',
			        'stext'
			],
			data:[["A","全部"],["H","节假日"],["W","工作日"]]
		})
	});

	obj.btnQry = new Ext.Button({
		id : 'btnQry'
		,iconCls : 'icon-find'
		,text : '查询'
	});

	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,text : '导出'
	});

	obj.btnImport = new Ext.Button({
		id : 'btnImport'
		,iconCls : 'icon-export'
		,text : '导入'
	});

	obj.ConditionPanel = new Ext.Panel({
		id :'ConditionPanel',
		layout:'column',
		height: 40,
		region: 'north',
		frame : true,
		items:[{
				region: 'center',
				layout : 'form',
				labelAlign : 'right',
				columnWidth: .2,
				items:[obj.TextYear]
			},{
				region: 'center',
				layout : 'form',
				labelAlign : 'right',
				columnWidth: .2,
				items: [obj.cboType]
			},{
				region: 'center',
				layout : 'form',
				labelAlign : 'right',
				columnWidth: .04
			},{
				region: 'center',
				layout : 'form',
				labelAlign : 'right',
				columnWidth: .07,
				items: [obj.btnQry]
			},{
				region: 'center',
				layout : 'form',
				labelAlign : 'right',
				columnWidth: .07,
				items: [obj.btnExport]
			}
		]
	});

	obj.DetailGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.DetailGridPanelStore = new Ext.data.GroupingStore({
		proxy: obj.DetailGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			 {name: 'ID', mapping: 'ID'}
			,{name: 'Year', mapping: 'Year'}
			,{name: 'Date', mapping: 'Date'}
			,{name: 'TypeCode', mapping: 'TypeCode'}
			,{name: 'TypeDesc', mapping: 'TypeDesc'}
			,{name: 'HAlias', mapping: 'HAlias'}
			,{name: 'HolidayStr',mapping: 'HolidayStr'}
			,{name: 'HName' , mapping: 'HName'}
		])
		,sortInfo:{field: 'Date', direction: "ASC"}
		,groupField:'HName'
	});

	obj.DetailGridPanel = new Ext.grid.GridPanel({
		id : 'DetailGridPanel'
		,autoExpandColumn: true
		,store : obj.DetailGridPanelStore
		,region : 'center'
		,frame : true
		,columnLines :true
		,trackMouseOver: true
		,buttonAlign : 'center'
		,view: new Ext.grid.GroupingView({
			forceFit:true,
			groupTextTpl: '{[values.rs[0].get("HolidayStr")]}',
			groupByText:'依本列分组'
		})
		,columns: [
			{header: '节假日名称', width: 90, dataIndex: 'HName', sortable: true}
			,{header: '节假日别名', width: 60, dataIndex: 'HAlias', sortable: true}
			,{header: '日期', width: 90, dataIndex: 'Date', sortable: true}
			,{header: '节日类型', width: 70, dataIndex: 'TypeDesc', sortable: true}
		]
	});
	
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-update'
		,width: 80
		,text : '更新'
	});
	
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,width: 80
		,text : '删除'
	});

	obj.EditPanel = new Ext.Panel({
		id :'EditPanel',
		layout:'column',
		height: 80,
		region: 'south',
		frame : true,
		buttonAlign :'center',
		items:[
			{
				layout: 'form',
				columnWidth : .15,
				labelAlign : 'right',
				labelWidth : 50,
				items: [obj.InputDate]
			},{
				layout: 'form',
				columnWidth : .15,
				labelAlign : 'right',
				labelWidth : 70,
				items: [obj.InputName]
			},{
				layout: 'form',
				columnWidth : .15,
				labelAlign : 'right',
				labelWidth : 70,
				items: [obj.InputType]
			},{
				layout: 'form',
				columnWidth : .20,
				labelAlign : 'right',
				labelWidth : 80,
				items: [obj.InputHAlias]
			}
		],
		buttons:[obj.btnUpdate,obj.btnDelete]
	});
	
	obj.txtFilePath = new Ext.form.TextField({
		id : 'txtFilePath'
		,width : 150
		,fieldLabel : '文件路径'
		,labelSeparator :''
		,anchor : '98%'
		,disabled : true
	});

	obj.btnSelect = new Ext.Button({
		id : 'btnSelect'
		,itemCls : 'icon-save'
		,text : '选择'
		,anchor : '98%'
	});

	obj.lsFileListStore = new Ext.data.Store({
		reader: new Ext.data.ArrayReader({id:0},
		[
			{name: 'ID', mapping: 0}
			,{name: 'FileName', mapping: 1}
		])
	});

	obj.lsFileList = new Ext.list.ListView({
		id : 'lsFileList'
        ,store: obj.lsFileListStore
        ,multiSelect: false
        ,reserveScrollOffset: true
        ,hideLabel: false
        ,hideHeaders: false
        ,height : 200
        ,anchor : '98%'
        ,fieldLabel : '文件列表'
		,labelSeparator :''
        ,columnSort : false
        ,columns: [
        {
        	header: '选择',
        	width: .15,
        	tpl:'<input type="checkbox" id="chkFileLV{ID}"></input>'
       	}
        ,{
            header: '文件名',
            width:.85,
            dataIndex: 'FileName'
        }
        ]
    });

    obj.lsFileListStore.loadData([]);

	obj.ImportPanle = new Ext.Panel({
		id : 'ImportPanle'
		,region : 'east'
		,width : 300
		,frame : true
		,layout : 'form'
		,buttonAlign : 'center'
		,items :[
			{
				 layout:'column'
				,items :[
					{
						columnWidth:.79
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items:[obj.txtFilePath]
					},{
						columnWidth:.2
						,layout : 'form'
						,items:[obj.btnSelect]
					}
				]
			},{
				 layout : 'form'
				,labelAlign : 'right'
				,labelWidth : 60
				,items : [obj.lsFileList]
			}
		]
		,buttons:[obj.btnImport]
	});
	
	obj.ViewPort = new Ext.Viewport({
		id:'ViewPort',
		layout:'border',
		items:[
			{
				 region : 'center'
				,layout : 'border'
				,items : [obj.ConditionPanel,obj.DetailGridPanel,obj.EditPanel]
			},{
				 region : 'east'
				,width : 300
				,frame : true
				,layout : 'form'
				,split:true
				,collapsible: true
				,collapsed : true
				,lines:false
				,animCollapse:false
				,animate: false
				,collapseMode:'mini'
				,collapseFirst:false
				,hideCollapseTool:true
				,items : [obj.ImportPanle]
			}
		]
	});

	obj.DetailGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCWMR.SSService.HolidaysSrv';
			param.QueryName = 'QryHolidays';
			param.Arg1 = obj.TextYear.getValue();
			param.Arg2 = obj.cboType.getValue();
			param.ArgCnt = 2;
	});
	InitViewportEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}