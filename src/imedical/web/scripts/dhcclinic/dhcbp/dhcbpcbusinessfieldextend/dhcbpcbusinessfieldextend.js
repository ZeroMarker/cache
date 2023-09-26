//by+2017-03-07
Ext.onReady(function(){
    Ext.QuickTips.init();
    var bd = Ext.getBody();
    var SelectedRowID = 0;
	var preRowID=0;	
    var txtCode=new Ext.form.TextField({
		id:'txtCode',
		fieldLabel:'代码',
		labelSeparator: ''
		,anchor:'95%'
	});
    var txtDesc=new Ext.form.TextField({
		id:'txtDesc',
		fieldLabel:'描述',
		anchor:'95%'
		,labelSeparator: ''
	}); 
	//---------------------类型--- P,PR,I,A,PA,PO,R   
	//----------Plan,PreVisit,Induce,Anaesthesia,PACU,PostVisit,Recovery
	var TypeData=[
		['','']
		,['S','方案  S']
		,['A','安排  A']
		];
	var TypeStoreProxy = new Ext.data.MemoryProxy(TypeData);
	var columnName = new Ext.data.Record.create([
		{ name: "TypeCode", type: "string" },
		{ name: "TypeDesc", type: "string" }
		]);
	var reader = new Ext.data.ArrayReader({}, columnName);
	var TypeStore = new Ext.data.Store({
		proxy: TypeStoreProxy,
        reader: reader,
		autoLoad: true
		});
	TypeStore.load();	
	var cboType=new Ext.form.ComboBox({
		id:'cboType'
		,store :TypeStore		
		,minChars : 1
		,displayField:'TypeDesc'
		,fieldLabel:'类型'
		,labelSeparator: ''
		,valueField:'TypeCode'
		,triggerAction : 'all'
		,anchor : '95%'
	});	
	//---------------------是否使用
	var ActiveData=[
		['','']
		,['Y','是']
		,['N','否']
		];
	var ActiveStoreProxy = new Ext.data.MemoryProxy(ActiveData);
	var columnName = new Ext.data.Record.create([
		{ name: "ActiveCode", type: "string" },
		{ name: "ActiveDesc", type: "string" }
		]);
	var reader = new Ext.data.ArrayReader({}, columnName);
	var ActiveStore = new Ext.data.Store({
		proxy: ActiveStoreProxy,
        reader: reader,
		autoLoad: true
		});
	ActiveStore.load();	
	var Active=new Ext.form.ComboBox({
		id:'Active'
		,store :ActiveStore		
		,minChars : 1
		,displayField:'ActiveDesc'
		,fieldLabel:'是否使用'
		,valueField:'ActiveCode'
		,labelSeparator: ''
		,triggerAction : 'all'
		,anchor : '95%'
	});	
	    var txtOption=new Ext.form.TextField({
		id:'txtOption',
		fieldLabel:'值(用;分隔)',
		anchor:'95%'
		,labelSeparator: ''
	});
	
	var btnSave=new Ext.Button({
		id:'btnSave',
		width :86,
		text:'保存',
		iconCls : 'icon-save',
		style:'margin-left :20px;',
		handler: function() {
        	btnSave_click();
    	}
	});
	var btnFind=new Ext.Button({
		id:'btnFind',
		text:'查找',
		width :86,
		iconCls : 'icon-find',
		style:'margin-left :20px;margin-top:3px',
		handler: function() {
        	btnFind_click();
    	}
	});
	var btnDelete=new Ext.Button({
		id:'btnDelete',
		text:'删除',
		width :86,
		style:'margin-left :20px;',
		iconCls : 'icon-delete',
		handler: function() {
        	btnDelete_click();
    	}
	});
	var pnlOption=new Ext.Panel({
	    id:'pnlOption',
		layout:'form',
		labelAlign : 'right',
		labelWidth : 80,
        items:[
        	txtOption
        ]	
    });	
    var pnlButton=new Ext.Panel({
		id:'pnlButton',
		columnWidth:.2,
		layout:'form',
		items:[
			btnSave,
			btnFind
		]
	});
	var pnlButton2=new Ext.Panel({
		id:'pnlButton2',
		columnWidth:.2,
		layout:'column',
		items:[
			btnDelete
		]
	});
	
	var pnlCode=new Ext.Panel({
	    id:'pnlCode',
		layout:'form',
		columnWidth:.2,
		labelWidth : 80,
		labelAlign : 'right',
        items:[
        	txtCode
        	,txtOption
        ]	
    });
	var pnlDesc=new Ext.Panel({
	    id:'pnlDesc',
		layout:'form',
		columnWidth:.2,
		labelWidth : 80,
		labelAlign : 'right',
        items:[
        	txtDesc
        	,Active
        ]	
    });
	var pnlType=new Ext.Panel({
	    id:'pnlType',
		layout:'form',
		labelAlign : 'right',
		labelWidth : 45,
		columnWidth:.2,
        items:[
        	cboType
        ]	
    });

	
    var Rowid = new Ext.form.TextField({
		id : 'Rowid'
		,hidden : true
    	});
	   
	var pnlTop1=new Ext.Panel({
		id : 'pnlTop1'
		,buttonAlign : 'center'
		
		,layout : 'column'
		,items:[
			pnlCode
			,pnlDesc
			,pnlType
			,pnlButton
			,pnlButton2
		]
	});
/*
	var pnlTop2=new Ext.Panel({
		id : 'pnlTop2'
		,buttonAlign : 'center'
		,layout : 'column'
		,items:[
			pnlButton
		]
	});*/
	var pnlTop=new Ext.Panel({
		id:'pnlTop'
		,frame:true
        //,title:'维护项'
        ,iconCls : 'icon-manage'
        ,height:65
		,layout:'form'
		//,region : 'center'
		,items:[
			pnlTop1
			,Rowid
		]
	});
	//------------------data------------
	var myGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	var myGridStore=new Ext.data.Store({
		proxy: myGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tRowId'
		}, 
		[
			{name: 'tRowId', mapping: 'tRowId'},
			{name: 'BPBusFieldExtCode', mapping: 'BPBusFieldExtCode'},
			{name: 'BPBusFieldExtDesc', mapping: 'BPBusFieldExtDesc'},
			{name: 'BPBusFieldExtType', mapping: 'BPBusFieldExtType'},
			{name: 'BPBusFieldExtTypeDesc', mapping: 'BPBusFieldExtTypeDesc'},
			{name: 'BPBusFieldExtActive', mapping: 'BPBusFieldExtActive'},
			{name: 'BPBusFieldExtOption', mapping: 'BPBusFieldExtOption'},
			{name: 'BPBusFieldExtSortNo', mapping: 'BPBusFieldExtSortNo'},
			{name: 'BPBusFieldExtANOPACode', mapping: 'BPBusFieldExtANOPACode'}
		])
	});
	/*var myGrid=new Ext.grid.GridPanel({
		id:'myGrid',
		store:myGridStore,
		autoHeight:true,
		applyTo:myGrid,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}), //设置为单行选中模式
		//clicksToEdit:1,    //单击编辑
		//loadMask:true,
		//region:'center',
		//buttonAlign:'center',
		columns:[
			new Ext.grid.RowNumberer(), 
			{header:'tRowId',width:80,dataIndex:'tRowId',sortable:true},
			{header:'代码',width:120,dataIndex:'BPBusFieldExtCode',sortable:true},
			{header:'描述',width:180,dataIndex:'BPBusFieldExtDesc',sortable:true},
			{header:'类型',width:100,dataIndex:'BPBusFieldExtType',sortable:true},
			{header:'类型描述',width:150,dataIndex:'BPBusFieldExtTypeDesc',sortable:true},
			{header:'是否有效',width:100,dataIndex:'BPBusFieldExtActive',sortable:true},
			{header:'值',width:250,dataIndex:'BPBusFieldExtOption',sortable:true},
			{header:'排序号',width:100,dataIndex:'BPBusFieldExtSortNo',sortable:true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 19,
			store : myGridStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
	});*/
	var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns:[
			new Ext.grid.RowNumberer(), 
			{header:'tRowId',width:80,dataIndex:'tRowId',sortable:true},
			{header:'代码',width:120,dataIndex:'BPBusFieldExtCode',sortable:true},
			{header:'描述',width:180,dataIndex:'BPBusFieldExtDesc',sortable:true},
			{header:'类型',width:100,dataIndex:'BPBusFieldExtType',sortable:true},
			{header:'类型描述',width:150,dataIndex:'BPBusFieldExtTypeDesc',sortable:true},
			{header:'是否有效',width:100,dataIndex:'BPBusFieldExtActive',sortable:true},
			{header:'值',width:250,dataIndex:'BPBusFieldExtOption',sortable:true},
			{header:'排序号',width:100,dataIndex:'BPBusFieldExtSortNo',sortable:true}
		]
	})
	var myGrid = new Ext.grid.EditorGridPanel({
		id : 'myGrid'
		,store : myGridStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
		,clicksToEdit:1    //单击编辑
		,loadMask : true
		,height:530
		//,region : 'center'
		//,buttonAlign : 'center'
		,cm:cm
		,viewConfig:
		{
			forceFit: false
			//Return CSS class to apply to rows depending upon data values
			
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 50,
			store : myGridStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		//,plugins : obj.retGridPanelCheckCol
	});
	
	myGrid.addListener('rowclick',GridRowClick);
	var pnlButtom=new Ext.Panel({
		id:'pnlButtom',
		//frame:true,
        title:'配置项',
        iconCls : 'icon-result',
        //buttonAlign : 'center',
		region : 'center',
        //height:480,        
		//width:650,
		layout:'table',
		items:[
			myGrid
		]
	});
	//data
	var pnlRisk=new Ext.Panel({
		id:'pnlRisk',
		frame:true,
        title:'血透配置项维护:只添加一次性填写数据',
        //bodyPadding:5,
        //width:1015,
        buttonAlign : 'center',
        iconCls : 'icon-manage',
		region : 'center',
        layout:'form',
        items: [
	        pnlTop
	        ,pnlButtom
        ],
        renderTo: bd		
	});
	myGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCBPCBusinessFieldExtend';
			param.QueryName = 'FindBusinessFieldExtend';
			param.Arg1 = txtCode.getValue();
			param.Arg2 = cboType.getValue();
			param.ArgCnt = 2;
		});
	myGridStore.load({
			params : {
				start:0,
				limit:50
			}
		});  
    var _DHCBPCBusinessFieldExtend=ExtTool.StaticServerObject('web.DHCBPCBusinessFieldExtend');
	function GridRowClick() 
	{
		var selectObj=myGrid.getSelectionModel().getSelected();
		SelectedRowID=selectObj.get("tRowId");
	  	if (selectObj){
		  	if(preRowID!=SelectedRowID){
			  	Rowid.setValue(selectObj.get("tRowId"));
			  	txtCode.setValue(selectObj.get("BPBusFieldExtCode"));
				txtDesc.setValue(selectObj.get("BPBusFieldExtDesc"));
				cboType.setValue(selectObj.get("BPBusFieldExtType"));
				Active.setValue(selectObj.get("BPBusFieldExtActive"));
				txtOption.setValue(selectObj.get("BPBusFieldExtOption"));
				preRowID=SelectedRowID;
			}else{
				SelectedRowID = 0;
		    	preRowID=0;
		    	ClearControls();
			}
		}
	}
	function ClearControls()
	{
		txtCode.setValue("");
		txtDesc.setValue("");
		cboType.setValue("");
		Active.setValue("");
		txtOption.setValue("");
		Rowid.setValue("");
	}
    function btnSave_click()
	{
		var rowid=Rowid.getValue();
		var BPBusFieldExtCode=txtCode.getValue()
		var BPBusFieldExtDesc=txtDesc.getValue()
		var BPBusFieldExtType=cboType.getValue()
		var BPBusFieldExtActive=Active.getValue()
		var BPBusFieldExtValue=txtOption.getValue()
		var BPBusFieldExtSortNo=""
		if(BPBusFieldExtCode=="")
		{
			alert("代码不能为空！！");
			return;
		}
		if(BPBusFieldExtType=="")
		{
			alert("类型不能为空！！");
			return;
		}
		var para=BPBusFieldExtCode+"^"+BPBusFieldExtDesc+"^"+BPBusFieldExtType+"^"+BPBusFieldExtActive+"^"+BPBusFieldExtValue+"^"+BPBusFieldExtSortNo
		var ret=_DHCBPCBusinessFieldExtend.SaveExtendItem(para,rowid);
		if(ret<0)
		{ Ext.Msg.alert("提示",ret+"更新失败！");}
		else
		{
			alert("保存数据成功！！！");
			//myGridStore.reload();
			ClearControls();
		}
		myGridStore.reload();
		//btnFind_click()
	}
	function btnDelete_click()
	{
		var selectObj=myGrid.getSelectionModel().getSelected();
		rowid=selectObj.get('tRowId');
		var ret=_DHCBPCBusinessFieldExtend.DeleteExtendItem(rowid);
		if(ret!=0) alert(ret);
		else
		{
			alert("删除数据成功！！！");
			ClearControls();
		}
		myGridStore.reload();
		//btnFind_click()
	}

	function btnFind_click()
	{
		myGridStore.removeAll();
		myGridStore.load({
			params : {
				start:0
				,limit:50
			}
		});
		ClearControls();
	}
    
});
