function InitViewScreen()
{
	var obj = new Object();
	var dateFormat=tkMakeServerCall("web.DHCClinicCom","GetDateFormat");
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
	obj.icuaId = new Ext.form.TextField({
		id : 'icuaId'
		,fieldLabel : 'icuaId'
		,anchor : '95%'
	});
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.txtRegNo
			,obj.icuaId
		]
	});
	obj.dateFrm = new Ext.form.DateField({
		id : 'dateFrm'
		,value : new Date()
		,format : dateFormat
		,fieldLabel : '查看日期'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		    obj.dateFrm
		]
	});
	obj.btnView = new Ext.Button({
		id : 'btnView'
		,text : '查看特护单'
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
			idProperty: 'icuaId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'tStartDateTime', mapping : 'tStartDateTime'}
			,{name: 'tEndDateTime', mapping: 'tEndDateTime'}
			,{name: 'tRegNo', mapping: 'tRegNo'}
			,{name: 'tPatName', mapping: 'tPatName'}
			,{name: 'tAdmLocDesc', mapping: 'tAdmLocDesc'}
			,{name: 'tStatus', mapping: 'tStatus'}
			,{name: 'tBedCode', mapping: 'tBedCode'}
			,{name: 'tDiagDesc', mapping: 'tDiagDesc'}
			,{name: 'tWardDesc', mapping: 'tWardDesc'}
			,{name: 'icuaId', mapping: 'icuaId'}
			,{name: 'tEpisodeID', mapping: 'tEpisodeID'}
			,{name: 'tPatHeight', mapping: 'tPatHeight'}
			,{name: 'tPatWeight', mapping: 'tPatWeight'}
			,{name: 'tMedCareNo', mapping: 'tMedCareNo'}
			,{name: 'tBodySquare', mapping: 'tBodySquare'}
			,{name: 'icuBedId', mapping: 'icuBedId'}
			,{name: 'curWardId', mapping: 'curWardId'}
			,{name: 'sex', mapping: 'sex'}
			,{name: 'age', mapping: 'age'}
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
			,{header: '开始日期', width: 150, dataIndex: 'tStartDateTime', sortable: true}
			,{header: '结束日期', width: 150, dataIndex: 'tEndDateTime', sortable: true}
			,{header: '登记号', width: 100, dataIndex: 'tRegNo', sortable: true}
			,{header: '病人姓名', width: 60, dataIndex: 'tPatName', sortable: true}
			,{header: '病人科室', width: 150, dataIndex: 'tAdmLocDesc', sortable: true}
			,{header: '病人状态', width: 60, dataIndex: 'tStatus', sortable: true}
			,{header: '病人床位', width: 60, dataIndex: 'tBedCode', sortable: true}
			,{header: '诊断', width: 50, dataIndex: 'tDiagDesc', sortable: true}
			,{header: '病区', width: 150, dataIndex: 'tWardDesc', sortable: true}
			,{header: 'icuaId', width: 50, dataIndex: 'icuaId', sortable: true}
			,{header: 'tEpisodeID', width: 80, dataIndex: 'tEpisodeID', sortable: true}
			,{header: '身高', width: 50, dataIndex: 'tPatHeight', sortable: true}
			,{header: '体重', width: 50, dataIndex: 'tPatWeight', sortable: true}
			,{header: '病案号', width: 100, dataIndex: 'tMedCareNo', sortable: true}
			,{header: '身体表面积', width: 100, dataIndex: 'tBodySquare', sortable: true}
			,{header: 'icuBedId', width: 80, dataIndex: 'icuBedId', sortable: true,hidden:true}
			,{header: 'curWardId', width: 80, dataIndex: 'curWardId', sortable: true,hidden:true}
			,{header: '性别', width: 35, dataIndex: 'sex',sortable: true,hidden:true}
			,{header: '年龄', width: 45, dataIndex: 'age',sortable: true,hidden:true}
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
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridPanelStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,plugins : obj.retGridPanelCheckCol
		,viewConfig:
		{
			forceFit: false
		}
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
		,title : '<span style=\'font-size:14px;\'>重症列表查询结果</span>'
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