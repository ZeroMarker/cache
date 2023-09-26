//20170302+dyl
Ext.onReady(function(){
    Ext.QuickTips.init();
    var bd = Ext.getBody();
    var txtCode=new Ext.form.TextField({
		id:'txtCode',
		fieldLabel:'代码',
		anchor:'95%'
		,labelSeparator: ''
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
		,['P','计划手术  P']
		,['PR','术前  PR']
		,['I','诱导  I']
		,['A','麻醉  A']
		,['PA','复苏室  PA']
		,['PO','术后  PO']
		,['R','恢复  R']
		,['OPS','安全核查  OPS']
		,['OPC','手术清点  OPC']
		,['T','手术转运  T']
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
		,editable :false
		,anchor : '80%'
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
		,labelSeparator: ''
		,valueField:'ActiveCode'
		,triggerAction : 'all'
		,editable :false
		,anchor : '80%'
	});	
    var txtOption=new Ext.form.TextField({
		id:'txtOption',
		fieldLabel:'值(用;分隔)',
		anchor:'95%'
		,labelSeparator: ''
	});
	
    var txtRelateCode=new Ext.form.TextField({
		id:'txtRelateCode',
		fieldLabel:'关联字段',   //改成combox
		anchor:'95%'
		,labelSeparator: ''
	});
	
    	var pnlCode=new Ext.Panel({
	    id:'pnlCode',
		layout:'form',
		labelWidth:100,
		columnWidth:.2,
        items:[
        	txtCode
        	,txtOption
        ]	
    });
	var pnlDesc=new Ext.Panel({
	    id:'pnlDesc',
		layout:'form',
		labelWidth:60,
		columnWidth:.2,
        items:[
        	txtDesc
        	,txtRelateCode
        ]	
    });
	var pnlType=new Ext.Panel({
	    id:'pnlType',
		layout:'form',
		columnWidth:.2,
		labelWidth:80,
        items:[
        	cboType
        	,Active
        ]	
    });
	
    var Rowid = new Ext.form.TextField({
		id : 'Rowid'
		,hidden : true
    	});
		var btnSave=new Ext.Button({
		id:'btnSave',
		text:'保存',
		width:86,
		iconCls : 'icon-save',
		handler: function() {
        	btnSave_click();
    	}
	});
	var btnFind=new Ext.Button({
		id:'btnFind',
		iconCls : 'icon-find',
		width:86,
		style:'margin-top:3px',
		text:'查找',
		handler: function() {
        	btnFind_click();
    	}
	});
	var btnDelete=new Ext.Button({
		id:'btnDelete',
		iconCls : 'icon-delete',
		text:'删除',
		width:86,
		handler: function() {
        	btnDelete_click();
    	}
	});
   var btn1=new Ext.Panel({
	    id:'btn1',
		layout:'form',
		style:'margin-left:20px',
		columnWidth:.2,
        items:[
        	btnSave
        	,btnFind
        ]	
    });
var btn2=new Ext.Panel({
	    id:'btn2',
		layout:'form',
		style:'margin-left:20px',
		columnWidth:.2,
        items:[
        	btnDelete
        ]	
    });
	var pnlTop1=new Ext.Panel({
		id : 'pnlTop1'
		,labelAlign:'right'
		
		,buttonAlign : 'center'
		,layout : 'column'
		,items:[
			pnlCode
			,pnlDesc
			,pnlType
			,btn1
			,btn2
		]
	});

	var pnlTop=new Ext.Panel({
		id:'pnlTop'
		,frame:true
		,labelAlign:'right'
        ,title:'维护项'
        ,iconCls : 'icon-normalinfo'
        ,height:100
		,layout:'form'
		,items:[
			pnlTop1
			//,pnlTop2
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
			idProperty: 'ANCOPAERowId'
		}, 
		[
			{name: 'ANCOPAERowId', mapping: 'ANCOPAERowId'},
			{name: 'ANCOPAECode', mapping: 'ANCOPAECode'},
			{name: 'ANCOPAEDesc', mapping: 'ANCOPAEDesc'},
			{name: 'ANCOPAEType', mapping: 'ANCOPAEType'},
			{name: 'ANCOPAETypeDesc', mapping: 'ANCOPAETypeDesc'},
			{name: 'ANCOPAEActive', mapping: 'ANCOPAEActive'},
			{name: 'ANCOPAEOption', mapping: 'ANCOPAEOption'},
			{name: 'ANCOPAESortNo', mapping: 'ANCOPAESortNo'},
			{name: 'ANCOPAEANOPACode', mapping: 'ANCOPAEANOPACode'}
		])
	});
	var myGrid=new Ext.grid.GridPanel({
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
			{header:'RowId',width:80,dataIndex:'ANCOPAERowId',sortable:true},
			{header:'代码',width:100,dataIndex:'ANCOPAECode',sortable:true},
			{header:'描述',width:100,dataIndex:'ANCOPAEDesc',sortable:true},
			{header:'类型',width:100,dataIndex:'ANCOPAEType',sortable:true},
			{header:'类型描述',width:150,dataIndex:'ANCOPAETypeDesc',sortable:true},
			{header:'是否有效',width:100,dataIndex:'ANCOPAEActive',sortable:true},
			{header:'值',width:250,dataIndex:'ANCOPAEOption',sortable:true},
			{header:'排序号',width:100,dataIndex:'ANCOPAESortNo',sortable:true},
			{header:'关联字段',width:100,dataIndex:'ANCOPAEANOPACode',sortable:true}
			
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : myGridStore,
		    displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
		    emptyMsg: '没有记录'
		})
	});
	myGrid.addListener('rowclick',GridRowClick);
	var pnlButtom=new Ext.Panel({
		id:'pnlButtom',
		frame:true,
        title:'配置项',
        iconCls : 'icon-result',
        height:480,        
		//width:650,
		autoScroll : true,
        bodyStyle : 'overflow-x:hidden; overflow-y:scroll',
		layout:'table',
		items:[
			myGrid
		]
	});
	//data
	var pnlRisk=new Ext.Panel({
		id:'pnlRisk',
		frame:true,
        title:'手麻配置项维护:只添加一次性填写数据',
        iconCls : 'icon-manage',
        //bodyPadding:5,
        //width:1015,
        layout:'form',
        items: [
	        pnlTop
	        ,pnlButtom
        ],
        renderTo: bd		
	});
	
	myGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCANOPArrangeExtend';
			param.QueryName = 'FindArrangeExtend';
			param.ArgCnt = 0;
		});
	myGridStore.load({});  
    var _DHCANOPArrangeExtend=ExtTool.StaticServerObject('web.DHCANOPArrangeExtend');
	var SelectedRowID = 0;
	var preRowID=0;
	function GridRowClick() 
	{
		var selectObj=myGrid.getSelectionModel().getSelected();
	    var linenum=myGrid.getSelectionModel().lastActive;
	    if(selectObj)
	    {
		    SelectedRowID=selectObj.get("ANCOPAERowId");
		    if(preRowID!=SelectedRowID)
		    {
			    txtCode.setValue(selectObj.get("ANCOPAECode"));
			    txtDesc.setValue(selectObj.get("ANCOPAEDesc"));
			    cboType.setValue(selectObj.get("ANCOPAEType"));
			    Active.setValue(selectObj.get("ANCOPAEActive"));
			    txtOption.setValue(selectObj.get("ANCOPAEOption"));
			    txtRelateCode.setValue(selectObj.get("ANCOPAEANOPACode"));
			    preRowID=SelectedRowID;
		    }
		    else
		    {
			    txtCode.setValue("");
			    txtDesc.setValue("");
			    cboType.setValue("");
			    Active.setValue("");
			    txtOption.setValue("");
			    txtRelateCode.setValue("");
			    SelectedRowID = 0;
			    preRowID=0;
			    myGrid.getSelectionModel().deselectRow(linenum);
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
		txtRelateCode.setValue("");
	}
    function btnSave_click()
	{
		var ANCOPAECode=txtCode.getValue()
		var ANCOPAEDesc=txtDesc.getValue()
		var ANCOPAEType=cboType.getValue()
		var ANCOPAEActive=Active.getValue()
		var ANCOPAEValue=txtOption.getValue()
		var ANCOPAESortNo=""
		var ANCOPAEANOPACode=txtRelateCode.getValue()
		if(ANCOPAECode=="")
		{
			alert("代码不能为空！！！");
			return;
		}
		var para=ANCOPAECode+"^"+ANCOPAEDesc+"^"+ANCOPAEType+"^"+ANCOPAEActive+"^"+ANCOPAEValue+"^"+ANCOPAESortNo+"^"+ANCOPAEANOPACode
		var ret=_DHCANOPArrangeExtend.SaveExtendItem(para);
		if(ret<0) alert(ret);
		else
		{
			alert("保存数据成功！！！");
			ClearControls();
		}
		myGridStore.reload();
		btnFind_click()
	}
	function btnDelete_click()
	{
		var selectObj=myGrid.getSelectionModel().getSelected();
		if(selectObj)
		{
			Rowid=selectObj.get('ANCOPAERowId');
			var ret=_DHCANOPArrangeExtend.DeleteExtendItem(Rowid);
			if(ret!=0) alert(ret);
			else
			{
				alert("删除数据成功！！！");
				ClearControls();
			}
			myGridStore.reload();
			btnFind_click();
		}
		else
		{
			alert("请先选中一行记录!");
		}
	}

	function btnFind_click()
	{
		myGridStore.removeAll();
		myGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCANOPArrangeExtend';
			param.QueryName = 'FindArrangeExtend';
			param.Arg1 = txtCode.getValue();
			param.Arg2 = cboType.getValue();
			param.ArgCnt = 2;
		});
		myGridStore.load({});
				
	}
    
});
