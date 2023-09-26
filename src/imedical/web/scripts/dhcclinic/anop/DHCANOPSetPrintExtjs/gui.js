//by+2017-03-02
function InitViewScreen()
{
	var obj = new Object();
	
	
	//-----------手术麻醉打印单据设置------------
	obj.code = new Ext.form.TextField({
		id :'code'
		,fieldLabel :'代码'
		,labelWidth:60
		,labelSeparator:''
		,anchor :'95%'
	});	
	
	obj.filename = new Ext.form.TextField({
		id :'filename'
		,fieldLabel :'文件名'
		,labelWidth:60
		,labelSeparator:''
		,anchor :'95%'
	});	
	
	obj.Panel1 = new Ext.Panel({
		id :'Panel1'
		,buttonAlign :'center'
		,columnWidth :.35
		,labelWidth:60
		,layout :'form'
		,items:[
			obj.code
			,obj.filename	
		]
	});
	
	obj.name = new Ext.form.TextField({
		id :'name'
		,fieldLabel :'名称'
		,labelSeparator:''
		,anchor :'95%'
	});
	
	obj.operStatStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url :ExtToolSetting.RunQueryPageURL
	}));
    
	obj.operStatStore = new Ext.data.Store({
		proxy:obj.operStatStoreProxy,
		reader:new Ext.data.JsonReader({
			root:'record',
			totalProperty:'total',
			idProperty:'tCode'
		}, 
		[
		     {name:'tCode', mapping:'tCode'}
			,{name:'tDesc', mapping:'tDesc'}
		])
	});	
	obj.operStat = new Ext.form.ComboBox({
		id :'operStat'
		,store:obj.operStatStore
		,minChars:1	
		,displayField:'tDesc'	
		,fieldLabel :'手术状态'
		,labelSeparator:''
		,valueField :'tCode'
		,triggerAction :'all'
		,anchor :'95%'
		,editable :false
		,mode:'local'
	}); 	
	
	obj.operStatStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'LookUpComCode';
		param.Arg1 = 'OpaStatus';
		param.ArgCnt = 1;
	});
	obj.operStatStore.load({});
	
	

    obj.Panel2 = new Ext.Panel({
		id :'Paneltemp2'
		,buttonAlign :'center'
		,columnWidth :.35
		,layout :'form'
		,items:[
			obj.name
			,obj.operStat
		]
	});
	
	
	
	
	//例如和注意标签
	obj.labelExample1=new Ext.form.Label(
	{
		id:'labelExample1'
		//,text:'例如:代码:SSD 名称:手术单 文件名:SSD.xls 手术状态:安排'
		,html:'<font color="red"><strong>例如:代码:SSD 名称:手术单 文件名:SSD.xls 手术状态:安排</strong></font>'
		//,cls:'red'
	});
	obj.labelNotice1=new Ext.form.Label(
	{
		id:'labelNotice1'
		//,text:'注意:单击一条记录,在右边界面中定义打印列'
		,html:'<font color="red"><strong>注意:单击一条记录,在右边界面中定义打印列</strong></font>'
		//,cls:'red'
	});
	obj.PanelText1 = new Ext.Panel({
		id :'PanelText1'
		,buttonAlign :'center'
		,height:40
		,region :'center'
		,layout :{ type :'vbox'}
		,items:[
			obj.labelExample1
			,obj.labelNotice1	
		]
	});
	
	obj.addbutton = new Ext.Button({
		id :'addbutton'
		,width:60
		,text :'增加'
		,iconCls :'icon-add'
	});
	obj.updatebutton = new Ext.Button({
		id :'updatebutton'
		,width:60
		,text :'修改'
		,style:'margin-top:3px;'
		,iconCls :'icon-updateSmall'
	});
	obj.deletebutton = new Ext.Button({
		id :'deletebutton'
		,width:60
		,text :'删除'
		,iconCls :'icon-delete'
	});
	obj.addpanel = new Ext.Panel({
		id :'addpanel'
		,buttonAlign :'right'
		,columnWidth :.15
		,layout :'form'
		,style:'margin-left:10px;'
		,items:[
		    obj.addbutton
		    ,obj.updatebutton
		    
		]

	});
	
	obj.updatepanel = new Ext.Panel({
		id :'updatepanel'
		,buttonAlign :'center'	
		,columnWidth :.15
		,layout :'column'
		,style:'margin-left:10px;'
		,items:[
		    obj.deletebutton
		]

	})
	/*
	obj.buttonPanel = new Ext.form.FormPanel({
		id :'buttonPanel'
		,buttonAlign :'center'
		,labelAlign :'right'
		,labelWidth :60
		,height :30
		,columnWidth :.2
		,region :'south'
		,layout :'form'
		,items:[
			obj.addpanel
			,obj.deletepanel
		]
	});*/
	obj.fPanel = new Ext.form.FormPanel({
		id:"fPanel"
		,buttonAlign:"center"
		,labelAlign:"right"
		,labelWidth:60
		,height:60
		,region:"north"
		,layout:"column"
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.addpanel
			,obj.updatepanel
		]
	});
	obj.floorPanel = new Ext.Panel({
		id :'floorPanel'
		,buttonAlign :'center'
		,height :115
		,region :'north'
		,layout :'border'
		,frame :true
		//,collapsible:true
		,animate:true
		,items:[
			obj.fPanel
			,obj.PanelText1
		]
    });
    
    obj.retGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url :ExtToolSetting.RunQueryPageURL
	}));
	obj.retGridPanelStore = new Ext.data.Store({
		proxy:obj.retGridPanelStoreProxy,
		reader:new Ext.data.JsonReader({
			root:'record',
			totalProperty:'total',
			idProperty:'code'
		}, 
	    [
			{name:'tcode', mapping :'code'}
			,{name:'tname', mapping:'name'}
			,{name:'tfilename', mapping:'filename'}
			,{name:'toperStat', mapping:'operStat'}
			,{name:'tstatCode', mapping:'statCode'}

		])
	});
	var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable:true // columns are not sortable by default           
		}
        ,columns:[
			new Ext.grid.RowNumberer(),
			{header:'代码',width:120,dataIndex:'tcode',sortable:true}
			,{header:'名称',width:120,dataIndex:'tname',sortable:true}
        	,{header:'文件名',width:120,dataIndex:'tfilename',sortable:true}
			,{header:'手术状态',width:120,dataIndex:'toperStat',sortable:true}
			,{header:'状态代码',width:120,dataIndex:'tstatCode',hidden:true}
		]
	});
	
	 obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id :'retGridPanel'
		,store :obj.retGridPanelStore
		,sm:new Ext.grid.RowSelectionModel({singleSelect:true}) 
		,clicksToEdit:1    
		,loadMask :true
		,region :'center'
		,buttonAlign :'center'
		,cm:cm
		,bbar:new Ext.PagingToolbar({
			pageSize :200,
			store :obj.retGridPanelStore,
		    displayMsg:'显示记录： {0} - {1} 合计： {2}',
			displayInfo:true,
		    emptyMsg:'没有记录'
		})
	});
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPSET';
		param.QueryName = 'FindQueryType';
		param.ArgCnt = 0;
	});
	obj.retGridPanelStore.load({});
	
	obj.Panel23 = new Ext.Panel({
		id :'Panel23'
		,hidden:true
		,buttonAlign :'center'
		,region :'north'
		,items:[
		]
	});
	
	obj.Panel25 = new Ext.Panel({
		id :'Panel25'
		,hidden:true
		,buttonAlign :'center'
		,region :'south'
		,items:[
		]
	});
	
	obj.resultPanel = new Ext.Panel({
		id :'resultPanel'
		,buttonAlign :'center'
		,region :'center'
		,layout :'border'
		,frame :true
		,items:[
		    obj.Panel23
			,obj.Panel25
		    ,obj.retGridPanel
		]
	});
	obj.AnOpSetPrint = new Ext.Panel({
		id :'AnOpSetPrint'
		,buttonAlign :'center'
		,height :200
		,width:500
		,title :'手术麻醉打印列设置'
		,region :'center'
		,iconCls :'icon-manage'
		,layout :'border'
		,frame :true
		//,collapsible:true
		,animate:true
		,items:[
			obj.floorPanel
			,obj.resultPanel
		]
	});
	//--------------------
   
   
    //-----------手术麻醉打印单列表-----------
    obj.seqno = new Ext.form.TextField({
		id :'seqno'
		,fieldLabel :'序号'
		,labelSeparator:''
		,anchor :'95%'
	});
	
	obj.columnLinkStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url :ExtToolSetting.RunQueryPageURL
	}));
    
	obj.columnLinkStore = new Ext.data.Store({
		proxy:obj.columnLinkStoreProxy,
		reader:new Ext.data.JsonReader({
			root:'record',
			totalProperty:'total',
			idProperty:'ID'
		}, 
		[
		     {name:'tDesc', mapping:'desc'}
			,{name:'tID', mapping:'ID'}
		])
	});	
	obj.columnLink = new Ext.form.ComboBox({
		id :'columnLink'
		,store:obj.columnLinkStore
		,minChars:1	
		,displayField:'tDesc'	
		,fieldLabel :'列关联'
		,labelSeparator:''
		,valueField :'tID'
		,triggerAction :'all'
		,anchor :'95%'
		,editable :false
		,mode:'local'
	}); 	
	
	obj.columnLinkStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPSET';
		param.QueryName = 'FindAllVarLink';
		param.Arg1=obj.columnLink.getValue();
		param.ArgCnt = 1;
	});
	obj.columnLinkStore.load({});	
		
	
    obj.PanelList1 = new Ext.Panel({
		id :'PanelList1'
		,buttonAlign :'center'
		,columnWidth :.35
		,layout :'form'
		,items:[
			obj.seqno
			,obj.columnLink	
		]
	});
	
	obj.columnName = new Ext.form.TextField({
		id :'columnName'
		,fieldLabel :'打印列名'
		,labelSeparator:''
		,anchor :'95%'
	});
	
    
    obj.rw = new Ext.form.TextField({
		id :'rw'
		,hidden :true
    });	
    
    obj.PanelList2 = new Ext.Panel({
		id :'PanelList2'
		,buttonAlign :'center'
		,columnWidth :.35
		,layout :'form'
		,items:[
			obj.columnName
			,obj.rw	
		]
	});
    
	
	
	//显示例如和注意等提示标签
	obj.labelExample2=new Ext.form.Label(
	{
		id:'labelExample2'
		//,text:'例如:序号:1 打印列名:手术间 列关联:手术间'
		,html:'<font color="red"><strong>例如:序号:1 打印列名:手术间 列关联:手术间</strong></font>'
		//,cls:'red'
	});
	obj.labelNotice2=new Ext.form.Label(
	{
		id:'labelNotice2'
		//,text:'注意:序号列必须按1,2,3,4......顺序;打印列名可自已定义;如选择列关联则打印相应值,否则打印空值'
		,html:'<font color="red"><strong>注意:序号列必须按1,2,3,4......顺序;打印列名可自已定义;如选择列关联则打印相应值,否则打印空值</strong></font>'
		//,cls:'red'
	});
	obj.PanelText2 = new Ext.Panel({
		id :'PanelText1'
		,buttonAlign :'center'
		,region :'center'
		,layout :{ type :'vbox'}
		,items:[
			obj.labelExample2
			,obj.labelNotice2	
		]
	});
	
	obj.addbuttonList = new Ext.Button({
		id :'addbuttonList'
		,width:60
		,text :'增加'
		,iconCls :'icon-add'
	});
	obj.updatebuttonList = new Ext.Button({
		id :'updatebuttonList'
		,width:60
		,text :'更新'
		,style:'margin-top:3px;'
		,iconCls :'icon-updateSmall'
	});
	obj.deletebuttonList = new Ext.Button({
		id :'deletebuttonList'
		,width:60
		,text :'删除'
		,iconCls :'icon-delete'
	});
	obj.addpanelList = new Ext.Panel({
		id :'addpanelList'
		,buttonAlign :'right'
		,columnWidth :.15
		,layout :'form'
		,style:'margin-left:10px;'
		,items:[
		    obj.addbuttonList
		    ,obj.updatebuttonList
		]

	});
	obj.updatepanelList = new Ext.Panel({
		id :'updatepanelList'
		,buttonAlign :'center'	
		,columnWidth :.15
		,style:'margin-left:5px;'
		,layout :'column'
		,items:[
		    obj.deletebuttonList
		]

	});
	/*
	obj.deletepanelList = new Ext.Panel({
		id :'deletepanelList'
		,buttonAlign :'center'
		,columnWidth :.2
		,layout :'column'
		,items:[
		    obj.deletebuttonList
		    ]

	});	*/
	obj.fPanelList = new Ext.form.FormPanel({
		id:"fPanelList"
		,buttonAlign:"center"
		,labelAlign:"right"
		,labelWidth:60
		,height:60
		,region:"north"
		,layout:"column"
		,items:[
			obj.PanelList1
			,obj.PanelList2
			,obj.addpanelList
			,obj.updatepanelList
		]
	});
	/*
	obj.buttonPanelList = new Ext.form.FormPanel({
		id :'buttonPanelList'
		,buttonAlign :'center'
		,labelAlign :'right'
		,labelWidth :60
		,height :30
		,region :'south'
		,layout :'column'
		,items:[
			obj.addpanelList
			,obj.updatepanelList
			,obj.deletepanelList
		]
	});*/
	obj.floorPanelList = new Ext.Panel({
		id :'floorPanelList'
		,buttonAlign :'center'
		,height :160
		,region :'north'
		,layout :'border'
		,frame :true
		,collapsible:true
		,animate:true
		,items:[
			obj.fPanelList
			,obj.PanelText2
		]
    });
    
    obj.retGridPanelListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url :ExtToolSetting.RunQueryPageURL
	}));
	obj.retGridPanelListStore = new Ext.data.Store({
		proxy:obj.retGridPanelListStoreProxy,
		reader:new Ext.data.JsonReader({
			root:'record',
			totalProperty:'total',
			idProperty:'seqno'
		}, 
	    [
			{name:'tseqno', mapping :'seqno'}
			,{name:'tname', mapping:'name'}
			,{name:'tColLink', mapping:'ColLink'}
			,{name:'tColLinkID', mapping:'ColLinkID'}
			,{name:'trw', mapping:'rw'}
			
		])
	});
	var cmList = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable:true // columns are not sortable by default           
		}
        ,columns:[
			new Ext.grid.RowNumberer(),
			{header:'序号',width:100,dataIndex:'tseqno',sortable:true}
			,{header:'列名',width:100,dataIndex:'tname',sortable:true}
        	,{header:'列关联',width:100,dataIndex:'tColLink',sortable:true}
			,{header:'列关联ID',width:100,dataIndex:'tColLinkID',sortable:true}
			,{header:'rw',width:100,dataIndex:'trw',sortable:true}
		]
	});
	
	 obj.retGridPanelList = new Ext.grid.EditorGridPanel({
		id :'retGridPanelList'
		,store :obj.retGridPanelListStore
		,sm:new Ext.grid.RowSelectionModel({singleSelect:true}) 
		,clicksToEdit:1    
		,loadMask :true
		,region :'center'
		,buttonAlign :'center'
		,cm:cmList
		,bbar:new Ext.PagingToolbar({
			pageSize :200,
			store :obj.retGridPanelListStore,
		    displayMsg:'显示记录： {0} - {1} 合计： {2}',
			displayInfo:true,
		    emptyMsg:'没有记录'
		})
	});
	obj.retGridPanelListStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPSET';
		param.QueryName = 'FinTypeSetPrint';
		param.Arg1 = obj.code.getValue();
		param.ArgCnt = 1;
	});
	obj.retGridPanelListStore.load({});
	
	obj.PanelList23 = new Ext.Panel({
		id :'PanelList23'
		,hidden:true
		,buttonAlign :'center'
		,region :'north'
		,items:[
		]
	});
	
	obj.PanelList25 = new Ext.Panel({
		id :'PanelList25'
		,hidden:true
		,buttonAlign :'center'
		,region :'south'
		,items:[
		]
	});
	
	obj.resultPanelList = new Ext.Panel({
		id :'resultPanelList'
		,buttonAlign :'center'
		,region :'center'
		,layout :'border'
		,frame :true
		,items:[
		    obj.PanelList23
			,obj.PanelList25
		    ,obj.retGridPanelList
		]
	});
    
    obj.AnOpSetPrintList = new Ext.Panel({
		id :'AnOpSetPrintList'
		,buttonAlign :'center'
		,height :200
		,width:600
		,title :'手术麻醉打印列表'
		,iconCls:'icon-result'
		,region :'east'
		,layout :'border'
		,frame :true
		,collapsible:true
		,animate:true
		,items:[
			obj.floorPanelList
			,obj.resultPanelList
		]
	});

    //------------------------------------
    
   	obj.ViewScreen = new Ext.Viewport({
		id :'ViewScreen'
		,layout :'border'
		,items:[
			obj.AnOpSetPrint
			,obj.AnOpSetPrintList
		]
	}); 
	
	/////////////////////////////////
	InitViewScreenEvent(obj);
	
	
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
    obj.addbutton.on("click", obj.addbutton_click, obj);
    obj.updatebutton.on("click", obj.updatebutton_click, obj);
    obj.deletebutton.on("click", obj.deletebutton_click, obj);
    
    
    obj.retGridPanelList.on("rowclick", obj.retGridPanelList_rowclick, obj);
    obj.addbuttonList.on("click", obj.addbuttonList_click, obj);
    obj.updatebuttonList.on("click", obj.updatebuttonList_click, obj);
    obj.deletebuttonList.on("click", obj.deletebuttonList_click, obj);
    
     
    obj.LoadEvent(arguments);    
    return obj;	
   
}