function InitViewScreen()
{
	var obj = new Object();
	obj.txtMedCareNo = new Ext.form.TextField({
		id : 'txtMedCareNo'
		,fieldLabel : '病案号'
		,anchor : '95%'
	});
	obj.EpisodeID = new Ext.form.TextField({
		id : 'EpisodeID'
		,fieldLabel : '就诊号'
		,anchor : '95%'
	});
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.txtMedCareNo
			,obj.EpisodeID
		]
	});
	obj.txtRegNo = new Ext.form.TextField({
		id : 'txtRegNo'
		,fieldLabel : '登记号'
		,anchor : '95%'
	});
	obj.opaId = new Ext.form.TextField({
		id : 'opaId'
		,fieldLabel : 'opaId'
		,anchor : '95%'
	});
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.txtRegNo
			,obj.opaId
		]
	});
	var data=[
		['A','麻醉单'],
		['PA','恢复室'],
		['PR','术前访视'],
		['PO','术后访视']
	]
	obj.FTPTypeStoreProxy=data;
	obj.FTPTypeStore = new Ext.data.Store({
		proxy: new Ext.data.MemoryProxy(data),
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'code'}
			,{name: 'desc'}
		])
	});
	obj.FTPType = new Ext.form.ComboBox({
		id : 'FTPType'
		,minChars : 1
		,fieldLabel : '文件类型'
		,labelSeparator: ''
		,triggerAction : 'all'
		,store : obj.FTPTypeStore
		,displayField : 'desc'
		,valueField : 'code'
		,anchor : '95%'
	});
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.FTPType
		]
	});
	obj.btnView = new Ext.Button({
		id : 'btnView'
		,text : '查看麻醉单'
	});
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.btnView
		]
	});
	obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,region : 'center'
		,layout : 'column'
		,items:[
			//obj.Panel1
			//,obj.Panel2
			obj.Panel3
			,obj.Panel4
		]
	});
	obj.schPanel = new Ext.Panel({
		id : 'schPanel'
		,buttonAlign : 'center'
		,height : 100
		,title : ''
		,iconCls:'icon-find'
		,region : 'north'
		,layout : 'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.fPanel
		]
	});
	obj.Panel23 = new Ext.Panel({
		id : 'Panel23'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'north'
		,items:[
		]
	});
	obj.Panel25 = new Ext.Panel({
		id : 'Panel25'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'south'
		,items:[
		]
	});
	
	obj.retGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.retGridPanelStore = new Ext.data.Store({
		proxy: obj.retGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'opaId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'status', mapping: 'status'}
			,{name: 'jzstat', mapping: 'jzstat'}
			,{name: 'oproom', mapping: 'oproom'}
			,{name: 'regno', mapping: 'regno'}
			,{name: 'patname', mapping: 'patname'}
			,{name: 'sex', mapping: 'sex'}
			,{name: 'age', mapping: 'age'}
			,{name: 'opname', mapping: 'opname'}
			,{name: 'opdoc', mapping: 'opdoc'}
			,{name: 'loc', mapping: 'loc'}
			,{name: 'anmethod', mapping: 'anmethod'}
			,{name: 'andoc', mapping: 'andoc'}
			,{name: 'opaId', mapping: 'opaId'}
			,{name: 'adm', mapping: 'adm'}
			,{name: 'opdatestr', mapping: 'opdatestr'}
			,{name: 'medCareNo', mapping: 'medCareNo'}
			,{name: 'PatientID', mapping: 'PatientID'}
			,{name: 'PAADMMainMRADMDR', mapping: 'PAADMMainMRADMDR'}
			,{name: 'AnaesthesiaID', mapping: 'AnaesthesiaID'}
		])
	});
	obj.retGridPanelCheckCol = new Ext.grid.CheckColumn({
		header:'选择', 
		dataIndex: 'checked', 
		width: 40
	});

   obj.csm=new Ext.grid.CheckboxSelectionModel({
	 header:''
	 })

	var cm = new Ext.grid.ColumnModel({

		defaults:
		{
			sortable: true           
		}
        ,columns: [
			new Ext.grid.RowNumberer()
			,obj.csm
			,{header: '术间',width: 80,dataIndex: 'oproom',sortable: true}
			,{header: '科室',width: 70,dataIndex: 'loc',sortable: true}
			,{header: '登记号',width: 95,dataIndex: 'regno',sortable: true}
			,{header: '姓名',width: 55,dataIndex: 'patname',sortable: true}
			,{header: '性别', width: 35, dataIndex: 'sex',sortable: true}
			,{header: '年龄', width: 45, dataIndex: 'age',sortable: true}
			,{header: '手术名称',width: 105,dataIndex: 'opname',sortable: true,}
			,{header: '麻醉方法',width: 80,dataIndex: 'anmethod',sortable: true}
			,{header: '手术医生',width: 60,dataIndex: 'opdoc'}
			,{header: '麻醉医生',width: 80,dataIndex: 'andoc',sortable: true}
			,{header: '状态', width: 40, dataIndex: 'status', sortable: true}
			,{header: '类型', width: 40, dataIndex: 'jzstat', sortable: true}
			,{header: 'opaId', width: 40, dataIndex: 'opaId', sortable: true}
			,{header: '就诊号', width: 100, dataIndex: 'adm', sortable: true}
			,{header: '病案号', width: 80, dataIndex: 'medCareNo', sortable: true}
			,{header: '手术时间', width: 100, dataIndex: 'opdatestr', sortable: true}
			,{header: 'PatientID', width: 40, dataIndex: 'PatientID', sortable: true,hidden:true}
			,{header: 'PAADMMainMRADMDR', width: 40, dataIndex: 'PAADMMainMRADMDR', sortable: true,hidden:true}
			,{header: 'AnaesthesiaID', width: 40, dataIndex: 'AnaesthesiaID', sortable: true,hidden:true}
		]
	})
	obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
        ,sm:obj.csm
		,clicksToEdit:1
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,cm:cm

		,viewConfig:
		{
			forceFit: false,
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridPanelStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,plugins : obj.retGridPanelCheckCol
	});
	obj.txtPatname = new Ext.form.TextField({
	    id : 'txtPatname'
		,fieldLabel : '当前病人:  姓名'
		,labelSeparator: ''
		,width:100
		,anchor :'98%'
	});
	obj.txtPatRegNo = new Ext.form.TextField({
	    id : 'txtPatRegNo'
		,fieldLabel : '登记号'
		,labelSeparator: ''
		,width:80
		,anchor :'100%'
	});
	obj.txtPatSex = new Ext.form.TextField({
	    id : 'txtPatSex'
		,fieldLabel : '性别'
		,labelSeparator: ''
		,width:60
		,anchor :'100%'
	});
	obj.txtPatAge = new Ext.form.TextField({
	    id : 'txtPatAge'
		,fieldLabel : '年龄'
		,labelSeparator: ''
		,width:80
		,anchor :'100%'
	});
	obj.PanelP1 = new Ext.Panel({
	    id : 'PanelP1'
		,labelAlign : 'right'
		,labelWidth:100
		,columnWidth : .35
		,layout : 'form'
		,items : [
		    obj.txtPatname
		]
	});
	obj.PanelP2 = new Ext.Panel({
	    id : 'PanelP2'
		,labelAlign : 'right'
		,labelWidth:30
		,columnWidth : .15
		,layout : 'form'
		,items : [
			obj.txtPatAge
		]
	});
	obj.PanelP3 = new Ext.Panel({
	    id : 'PanelP3'
		,labelAlign : 'right'
		,labelWidth:30
		,columnWidth : .15
		,layout : 'form'
		,items : [
			obj.txtPatSex
		]
	});
	obj.PanelP4 = new Ext.Panel({
	    id : 'PanelP4'
		,labelAlign : 'right'
		,labelWidth:60
		,columnWidth : .35
		,layout : 'form'
		,items : [
			obj.txtPatRegNo
		]
	});
	obj.opManageMenu=new Ext.menu.Menu({});
	obj.tb=new Ext.Toolbar(
	{
		items:[
			new Ext.form.FormPanel({
				 id : 'patfPanel'
				 ,frame:true
				,labelWidth:60
				,labelAlign : 'right'
				,width : 500
				,height:35
				,layout : 'column'
				,items : [
				   obj.PanelP1
				   ,obj.PanelP2
				   ,obj.PanelP3
				   ,obj.PanelP4
				]
			})
		]
	});
	obj.resultPanel = new Ext.Panel({
		id : 'resultPanel'
		,buttonAlign : 'center'
		,title : '<span style=\'font-size:14px;\'>手术列表查询结果</span>'
		,iconCls:'icon-result'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,tbar:obj.tb
		,items:[
			obj.Panel23
			,obj.Panel25
			,obj.retGridPanel
		]
	});
	obj.PatientID = new Ext.form.TextField({
		id : 'PatientID'
	});
	obj.mradm = new Ext.form.TextField({
		id : 'mradm'
	});
	obj.hiddenPanel = new Ext.Panel({
		id : 'hiddenPanel'
		,buttonAlign : 'center'
		,region : 'south'
		,hidden : true
		,items:[
            obj.PatientID
			,obj.mradm
		]
	});
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.schPanel
			,obj.resultPanel
			,obj.hiddenPanel
		]
	});
	InitViewScreenEvent(obj);
	
	//事件处理代码
	obj.btnView.on("click", obj.btnView_click, obj);
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	obj.LoadEvent(arguments);
	return obj;
}