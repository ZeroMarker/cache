//20170302+dyl
Ext.onReady(function(){
	var obj = new Object();
    Ext.QuickTips.init();
    var bd = Ext.getBody();
    var txtCode=new Ext.form.TextField({
		id:'txtCode'
		,labelSeparator: ''
		,fieldLabel:'代码'
		,anchor:'98%'
	});
    var txtDesc=new Ext.form.TextField({
		id:'txtDesc',
		fieldLabel:'描述'
		,labelSeparator: ''
		,anchor:'98%'
	}); 
	//---------------------类型---,E,I,T,C,S,A,R
	var TypeData=[
		['','']
		,['E','术前']
		,['I','术中']
		,['T','术后']
		,['C','同意书']
		,['S','小结总结']
		,['A','镇痛访视']
		,['R','复苏室']
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
		,editable :false
		,labelSeparator: ''
		,valueField:'TypeCode'
		,triggerAction : 'all'
		,anchor : '98%'
	});	
	//---------------------是否使用
	var IfUseData=[
		['','']
		,['Y','是']
		,['N','否']
		];
	var IfUseStoreProxy = new Ext.data.MemoryProxy(IfUseData);
	var columnName = new Ext.data.Record.create([
		{ name: "IfUseCode", type: "string" },
		{ name: "IfUseDesc", type: "string" }
		]);
	var reader = new Ext.data.ArrayReader({}, columnName);
	var IfUseStore = new Ext.data.Store({
		proxy: IfUseStoreProxy,
        reader: reader,
		autoLoad: true
		});
	IfUseStore.load();	
	var IfUse=new Ext.form.ComboBox({
		id:'IfUse'
		,store :IfUseStore		
		,minChars : 1
		,displayField:'IfUseDesc'
		,fieldLabel:'是否使用'
		,labelSeparator: ''
		,valueField:'IfUseCode'
		,triggerAction : 'all'
		,editable :false
		,anchor : '98%'
	});	
	    var txtValue=new Ext.form.TextField({
		id:'txtValue',
		fieldLabel:'值(用;分隔)'
		,labelSeparator: ''
		,anchor:'98%'
	});
    var txtNote=new Ext.form.TextField({
		id:'txtNote',
		fieldLabel:'备注'
		,labelSeparator: ''
		,anchor:'98%'
	}); 
	
    var btnInsert=new Ext.Button({
		id:'btnInsert',
		iconCls:'icon-insert',
		text:'新增',
		width:86,
		handler: function() {
        	btnInsert_click();
    	}
	});
    var btnDelete=new Ext.Button({
		id:'btnDelete',
		iconCls:'icon-delete',
		text:'删除',
		width:86,
		handler: function() {
        	btnDelete_click();
    	}
	});
	var btnModify=new Ext.Button({
		id:'btnModify',
		iconCls:'icon-updateSmall',
		text:'修改',
		style:'margin-top:3px',
		width:86,
		handler: function() {
        	btnModify_click();
    	}
	});
	var btnFind=new Ext.Button({
		id:'btnFind',
		text:'查找',
		iconCls:'icon-find',
		style:'margin-top:3px',
		width:86,
		handler: function() {
        	btnFind_click();
    	}
	});

	var pnlCode=new Ext.Panel({
	    id:'pnlCode',
		layout:'form',
		columnWidth:.2,
        items:[
        	txtCode
        	,txtValue
        ]	
    });
	var pnlDesc=new Ext.Panel({
	    id:'pnlDesc',
		layout:'form',
		columnWidth:.2,
        items:[
        	txtDesc
        	,txtNote
        ]	
    });
	var pnlType=new Ext.Panel({
	    id:'pnlType',
		layout:'form',
		labelWidth:100,
		columnWidth:.2,
        items:[
        	cboType
        	,IfUse
        ]	
    });
    var pnlBtn1=new Ext.Panel({
	    id:'pnlBtn1',
		layout:'form',
		style:'margin-left:20px',
		columnWidth:.2,
        items:[
        	btnInsert
		    ,btnModify
        ]	
    });
	var pnlBtn2=new Ext.Panel({
	    id:'pnlBtn2',
		layout:'form',
		style:'margin-left:20px',
		columnWidth:.2,
        items:[
        	btnDelete
		    ,btnFind
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
			,pnlBtn1
			,pnlBtn2
		]
	});
	
    
	var pnlTop=new Ext.Panel({
		id:'pnlTop'
		,frame:true
		,items:[
			pnlTop1
			,Rowid
		]
	});
	var  myGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	var myGridStore=new Ext.data.Store({
		proxy: myGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ANCRRowId'
		}, 
		[
			{name: 'ANCRRowId', mapping: 'ANCRRowId'},
			{name: 'ANCRCode', mapping: 'ANCRCode'},
			{name: 'ANCRDesc', mapping: 'ANCRDesc'},
			{name: 'ANCRType', mapping: 'ANCRType'},
			{name: 'ANCRTypeDesc', mapping: 'ANCRTypeDesc'},
			{name: 'ANCRFlag', mapping: 'ANCRFlag'},
			{name: 'ANCRValue', mapping: 'ANCRValue'},
			{name: 'ANCRNote', mapping: 'ANCRNote'}
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
			{header:'RowId',width:80,dataIndex:'ANCRRowId',sortable:true},
			{header:'代码',width:100,dataIndex:'ANCRCode',sortable:true},
			{header:'描述',width:100,dataIndex:'ANCRDesc',sortable:true},
			{header:'类型',width:100,dataIndex:'ANCRType',sortable:true},
			{header:'类型描述',width:150,dataIndex:'ANCRTypeDesc',sortable:true},
			{header:'是否使用',width:100,dataIndex:'ANCRFlag',sortable:true},
			{header:'值',width:250,dataIndex:'ANCRValue',sortable:true},
			{header:'备注',width:200,dataIndex:'ANCRNote',sortable:true}
		]
	});
	myGrid.addListener('rowclick',GridRowClick);
	var pnlButtom=new Ext.Panel({
		id:'pnlButtom',
		frame:true,
        title:'配置项',
        iconCls : 'icon-result',
        height:500,        
		//width:650,
		layout:'table',
		items:[
			myGrid
		]
	});
	//data
	var pnlRisk=new Ext.Panel({
		id:'pnlRisk',
		labelAlign : 'right',
		frame:true,
        title:'手麻配置项维护',
        iconCls : 'icon-manage',
        //width:1015,
        layout:'form',
        items: [
	        pnlTop
	        ,pnlButtom
        ],
        renderTo: bd		
	});
	
	myGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCANConfigItem';
			param.QueryName = 'FindRecordOrder';
			param.Arg1 = txtCode.getValue();
			param.ArgCnt = 1;
		});
	myGridStore.load({
			params : {
				start:0,
				limit:200
			}
		});  
	//InitViewScreenEvent(obj);
	
	//cmbCtloc.on("select",cmbCtloc_select,obj);
	//cmbCtloc.on("keyup",cmbCtloc_keyup,obj);
	//btnAdd.on("click",btnAdd_click,obj);
    //btnDelete.on("click",btnDelete_click,obj);
    //btnModify.on("click",btnModify_click,obj);
    //obj.LoadEvent(arguments);
    
    var _DHCANConfigItem=ExtTool.StaticServerObject('web.DHCANConfigItem');
	var RRowId;
	var SelectedRowID = 0;
	var preRowID=0;
	function GridRowClick() 
	{
		var selectObj=myGrid.getSelectionModel().getSelected();
	    var linenum=myGrid.getSelectionModel().lastActive;
	    if(selectObj)
	    {
		    SelectedRowID=selectObj.get("ANCRRowId");
		    if(preRowID!=SelectedRowID)
		    {
			    txtCode.setValue(selectObj.get("ANCRCode"));
			    txtDesc.setValue(selectObj.get("ANCRDesc"));
			    cboType.setValue(selectObj.get("ANCRType"));
			    IfUse.setValue(selectObj.get("ANCRFlag"));
			    txtValue.setValue(selectObj.get("ANCRValue"));
			    txtNote.setValue(selectObj.get("ANCRNote"));
			    preRowID=SelectedRowID;
		    }
		    else
		    {
			    txtCode.setValue(selectObj.get(""));
			    txtDesc.setValue(selectObj.get(""));
			    cboType.setValue(selectObj.get(""));
			    IfUse.setValue(selectObj.get(""));
			    txtValue.setValue(selectObj.get(""));
			    txtNote.setValue(selectObj.get(""));
			    SelectedRowID = 0;
			    preRowID=0;
			    myGrid.getSelectionModel().deselectRow(linenum);
		    }
	    }
	}
    function btnInsert_click()
	{
		var ANCRCode=txtCode.getValue()
		var ANCRDesc=txtDesc.getValue()
		var ANCRType=cboType.getValue()
		var ANCRFlag=IfUse.getValue()
		var ANCRValue=txtValue.getValue()
		var ANCRNote=txtNote.getValue()
		if(ANCRCode=="")
		{
			alert("代码不能为空！！！");
			return;
		}
		var ret1=""
		ret1=_DHCANConfigItem.PanduanMessage(ANCRCode)
		if(ret1==0)
		{
			alert("代码有重复！！！");
			return;
		}
		var ret=_DHCANConfigItem.InsertMessage(ANCRCode,ANCRDesc,ANCRType,ANCRFlag,ANCRValue,ANCRNote);
		if(ret<0) alert(ret);
		else
		{
			alert("插入数据成功！！！");
			txtCode.setValue("");
			txtDesc.setValue("");
			cboType.setValue("");
			IfUse.setValue("");
			txtValue.setValue("");
			txtNote.setValue("");
		}
		myGridStore.reload();
		btnFind_click()
	}
	function btnDelete_click()
	{
		var Rowid=""
		var selectObj=myGrid.getSelectionModel().getSelected();
		if(selectObj)Rowid=selectObj.get('ANCRRowId');
		if(Rowid=="")
		{
			alert("请选择一条记录");
			return;
		}
		///alert(Rowid)
		var ret=_DHCANConfigItem.DeleteMessage(Rowid);
		///alert(ret);
		if(ret!=0) alert(ret);
		else
		{
			alert("删除数据成功！！！");
			txtCode.setValue("");
			txtDesc.setValue("");
			cboType.setValue("");
			IfUse.setValue("");
			txtValue.setValue("");
			txtNote.setValue("");
		}
		myGridStore.reload();
		btnFind_click()
	}
	function btnModify_click()
	{
		var RowId=""
		var selectObj=myGrid.getSelectionModel().getSelected();
		if(selectObj) RowId=selectObj.get('ANCRRowId');
		if(RowId=="")
		{
			alert("请选择一条记录");
			return;
		}
		var ANCRCodeSel=selectObj.get("ANCRCode");
		var ANCRCode=txtCode.getValue()
		var ANCRDesc=txtDesc.getValue()
		var ANCRType=cboType.getValue()
		var ANCRFlag=IfUse.getValue()
		var ANCRValue=txtValue.getValue()
		var ANCRNote=txtNote.getValue()
		if(ANCRCode=="")
		{
			alert("代码不能为空！！！");
			return;
		}
		var ret1="1"
		if(ANCRCode!=ANCRCodeSel){
			ret1=_DHCANConfigItem.PanduanMessage(ANCRCode)
		};
		if(ret1==0)
		{
			alert("代码有重复！！！");
			return;
		}

		var ret=_DHCANConfigItem.UpdateMessage(RowId,ANCRCode,ANCRDesc,ANCRType,ANCRFlag,ANCRValue,ANCRNote);
		if(ret<0) alert(ret);
		else
		{
			alert("修改数据成功！！！");
			txtCode.setValue("");
			txtDesc.setValue("");
			cboType.setValue("");
			IfUse.setValue("");
			txtValue.setValue("");
			txtNote.setValue("");
		}
		myGridStore.reload();
		btnFind_click() 
	}
	function btnFind_click()
	{
		myGridStore.removeAll();
		myGridStore.load({
			params : {
				start:0
				,limit:200
			}
		});
	}
    
});
