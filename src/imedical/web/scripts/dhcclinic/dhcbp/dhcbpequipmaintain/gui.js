//20170307+dyl
function InitViewScreen(){
	var obj=new Object();
	//文本1
	obj.equipName = new Ext.form.TextField({
		id : 'equipName'
		,fieldLabel : '设备分类'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	// 设备型号
	obj.equipTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.equipTypeStore = new Ext.data.Store({
		proxy: obj.equipTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tID'
		}, 
		[
			{name: 'tID', mapping: 'tID'}
			,{name: 'tBPCEMDesc', mapping: 'tBPCEMDesc'}
			,{name: 'tBPCEMAbbreviation', mapping: 'tBPCEMAbbreviation'}
		])
	});	
	obj.equipType = new Ext.form.ComboBox({
		id : 'equipType'
		,minChars : 1
		,fieldLabel : '设备型号'
		,labelSeparator: ''
		,triggerAction : 'all'
		,mode:'local'
		,store : obj.equipTypeStore
		,displayField : 'tBPCEMDesc'
		,valueField : 'tID'
		,anchor : '95%'
	});
	obj.equipTypeStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCEquipModel';
		param.QueryName = 'FindEModel';
		//param.Arg1 = "";
		param.ArgCnt = 0;
	});
	obj.equipTypeStore.load({});
	
	
	//厂家名称
	obj.manufactNameStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.manufactNameStore = new Ext.data.Store({
		proxy: obj.manufactNameStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tRowId'
		}, 
		[
			{name: 'tRowId', mapping: 'tRowId'}
			,{name: 'BPCMDesc', mapping: 'BPCMDesc'}
		])
	});	
	obj.manufactName = new Ext.form.ComboBox({
		id : 'manufactName'
		,minChars : 1
		,fieldLabel : '厂家名称'
		,labelSeparator: ''
		,triggerAction : 'all'
		,mode:'local'
		,store : obj.manufactNameStore
		,displayField : 'BPCMDesc'
		,valueField : 'tRowId'
		,anchor : '95%'
	});	
	obj.manufactNameStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCManufacturer';
		param.QueryName = 'FindEManufacturer';
		param.Arg1 = "";
		param.ArgCnt = 1;
	});
	obj.manufactNameStore.load({});
		
	obj.tRowId = new Ext.form.TextField({
		id : 'tRowId'
		,hidden : true
    });
    	
	//床位号
	obj.bpbeBedDrstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    function seltextbed(v, record) { 
         return record.tRowId+" || "+record.tBPCBDesc; 
    } 
	obj.bpbeBedDrstore = new Ext.data.Store({
		proxy: obj.bpbeBedDrstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tRowId'
		}, 
		[
		     {name: 'tRowId', mapping: 'tRowId'}
			,{ name: 'selecttext', convert:seltextbed }
			//,{name: 'tBPCBDesc', mapping: 'tBPCBDesc'}
		])
	});	
	
    obj.bedNo = new Ext.form.ComboBox({
		id : 'bedNo'
		,minChars : 1
		,fieldLabel : '床位号'
		,labelSeparator: ''
		,triggerAction : 'all'
		,mode:'local'
		,store : obj.bpbeBedDrstore
		,displayField : 'selecttext'
		,valueField : 'tRowId'
		,anchor : '95%'
	});
	obj.bpbeBedDrstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCBed';
		param.QueryName = 'FindBPCBed';
		param.ArgCnt = 0;
	});
	obj.bpbeBedDrstore.load({});
	
	//设备状态
	var Statusdata=[
		['US','在用'],
		['SP','备用'],
		['SC','报废']
	]
	obj.equipStatusStoreProxy = new Ext.data.MemoryProxy(Statusdata),
	
	obj.equipStatusStore = new Ext.data.Store({
		proxy: obj.equipStatusStoreProxy,
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'code'}
			,{name: 'desc'}
		])
	});
	obj.equipStatusStore.load({});
	obj.equipStatus=new Ext.form.ComboBox({
		id : 'equipStatus'
		,minChars : 1
		,fieldLabel : '设备状态'
		,labelSeparator: ''
		,triggerAction : 'all'
		,mode:'local'
		,store : obj.equipStatusStore
		,displayField : 'desc'
		,valueField : 'code'
		,anchor : '95%'
	});
	
	obj.buyDate = new Ext.form.DateField({
		id : 'buyDate'
		//,value : new Date()
		//,format : 'Y-m-d'
		,fieldLabel:'购买日期'
		,anchor : '95%'
	});
	
	obj.buyMoney = new Ext.form.TextField({
		id : 'buyMoney'
		,fieldLabel : '购买金额(万)'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.note = new Ext.form.TextField({
		id : 'note'
		,fieldLabel : '备注'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.guarYears = new Ext.form.TextField({
		id : 'guarYears'
		,fieldLabel : '保修年限(年)'
		,labelSeparator: ''
		,anchor : '95%'
	});
		

	obj.installPersonOut = new Ext.form.TextField({
		id : 'installPersonOut'
		,fieldLabel : '安装人员(外)'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.installPersonInStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.installPersonInStore = new Ext.data.Store({
	    proxy : obj.installPersonInStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'Id'
		},
		[   
		     {name: 'checked', mapping : 'checked'}
		    ,{name:'Name',mapping:'Name'}
			,{name:'Id',mapping:'Id'}
		])
	
	});
	
	//obj.installPersonInStore.load({})
	//obj.installPersonInStore.load({});
	obj.installPersonIn = new Ext.ux.form.LovCombo({
	    id : 'installPersonIn'
		,store : obj.installPersonInStore
		,minChars : 1
		,displayField : 'Name'
		,fieldLabel : '安装人员(内)'
		,labelSeparator: ''
		,valueField : 'Id'
		,triggerAction : 'all'
		,hideTrigger:false
		,grow:true
		,lazyRender : true
		,hideOnSelect:false
		,anchor : '95%'
	}); 

	obj.takeCarePerson = new Ext.ux.form.LovCombo({
	    id : 'takeCarePerson'
		,store : obj.installPersonInStore
		,minChars : 1
		,displayField : 'Name'
		,fieldLabel : '保管人员'
		,labelSeparator: ''
		,valueField : 'Id'
		,triggerAction : 'all'
		,multiSelect:true  
		,anchor : '95%'
		,showSelectAll :true
	}); 
	obj.installPersonInStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'FindUserByLoc';
		param.Arg1 = session['LOGON.CTLOCID'];
		param.Arg2 = session['LOGON.USERID'];
		param.ArgCnt = 2;
	});
	
	obj.equipSeqNo = new Ext.form.TextField({
		id : 'equipSeqNo'
		//,allowBlank : false
		,fieldLabel : '设备序列号'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.equipHosNo = new Ext.form.TextField({
		id : 'equipHosNo'
		//,allowBlank : false
		,fieldLabel : '设备院内编号'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .23
		,layout : 'form'
		,items:[
			obj.manufactName
			,obj.buyDate
			,obj.installPersonIn
			//,obj.bedNo
		]
	});
	
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .23
		,layout : 'form'
		,items:[
			obj.equipType
			,obj.equipStatus
			,obj.installPersonOut 
		]
	});
	
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .23
		,layout : 'form'
		,items:[
			obj.equipSeqNo
			,obj.buyMoney
			,obj.takeCarePerson
		]
	});	
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,labelWidth:110
		,columnWidth : .23
		,layout : 'form'
		,items:[
			obj.equipHosNo
			,obj.guarYears
			,obj.note
			,obj.tRowId
		]
	});
	
	obj.conditionPanel = new Ext.form.FormPanel({
		id : 'conditionPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,region : 'center'
		,layout : 'column'
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.Panel4
		]
	});
	
	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,width:86
		,iconCls:'icon-add'
		,text : '新增'
	});

	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,width:86
		,iconCls:'icon-edit'
		,style:'margin-left:10px'
		,text : '更新'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,width:86
		,iconCls:'icon-delete'
		,text : '删除'
		,style:'margin-left:10px'
		,hidden : true
	});
	obj.findbutton = new Ext.Button({
		id : 'findbutton'
		,width:86
		,iconCls:'icon-find'
		,style:'margin-left:10px'
		,text : '查找'
		//,hidden : true // 隐藏
	});
	
	obj.maintainBtn = new Ext.Button({
		id : 'maintainBtn'
		,width:100
		,iconCls:'icon-normalinfo'
		,style:'margin-left:10px'
		,text : '维护记录'
		//,hidden : true // 隐藏
	});
	
	obj.ExportExlBtn = new Ext.Button({
		id : 'ExportXlsBtn'
		,width:100
		,style:'margin-left:10px'
		,iconCls:'icon-export'
		,text : '导出Excel'
		//,hidden : true // 隐藏
	});
	
	obj.labelUsing=new Ext.form.Label(
	{
		id:'labColorUsing'
		,style:'margin-left:10px'
		,cls:'icon-onuse'
		,width:100
		,height:25
	})
	obj.labelSpare=new Ext.form.Label(
	{
		id:'labColorSpare'
		,cls:'icon-preparetouse'
		,width:100
		,height:25
	})
	
	obj.labelScrap=new Ext.form.Label(
	{
		id:'labColorScrap'
		,style:'margin-left:10px'
		,cls:'icon-nouse'
		,width:100
		,height:25
	})
	


	obj.keypanel = new Ext.Panel({
		id : 'keypanel'
		,buttonAlign : 'center'
		//,columnWidth : .70
		,layout : 'column'
        ,items:[
            obj.addbutton
            ,obj.updatebutton
            ,obj.findbutton
            ,obj.maintainBtn
            ,obj.ExportExlBtn
			,obj.deletebutton
			,obj.labelUsing
            ,obj.labelSpare
            ,obj.labelScrap
       ]
	});

	obj.buttonPanel = new Ext.form.FormPanel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 100
		,height : 30
		,region : 'south'
		,layout : 'column'
		,frame : false
		,items:[
			obj.keypanel
		]
	});
	
	obj.detectionPanel = new Ext.Panel({
		id : 'detectionPanel'
		,buttonAlign : 'center'
		,height : 150
		,title : '设备档案维护'
		,region : 'north'
		,iconCls:'icon-manage'
		,layout : 'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.conditionPanel
			,obj.buttonPanel
		]
    });
	
	//gridview定义
	obj.retGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.retGridPanelStore = new Ext.data.Store({
		proxy: obj.retGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tBPCERowId'
		}, 
	    [
			{name: 'tBPCERowId', mapping: 'tBPCERowId'} //ROWID
			,{name: 'tBPCECode', mapping: 'tBPCECode'}//设备院内编号
			,{name: 'tBPCEDesc', mapping: 'tBPCEDesc'}//设备名称
			,{name: 'tBPCENo', mapping: 'tBPCENo'}//设备序列号
			,{name: 'tBPCEFromDate', mapping: 'tBPCEFromDate'}//
			,{name: 'tBPCEToDate', mapping: 'tBPCEToDate'}//
			,{name: 'tBPCEStatus', mapping: 'tBPCEStatus'}//
			,{name: 'tBPCEStatusD', mapping: 'tBPCEStatusD'}//设备状态
			,{name: 'tBPCENote', mapping: 'tBPCENote'}//备注
			,{name: 'tBPCEBPCEquipModelDr', mapping: 'tBPCEBPCEquipModelDr'}//设备型号id
			,{name: 'tBPCEBPCEquipModel', mapping: 'tBPCEBPCEquipModel'}//设备型号
			,{name: 'tBPCEBPCEAbbre', mapping: 'tBPCEBPCEAbbre'}//设备型号缩写
			,{name: 'tBPCEMType', mapping: 'tBPCEMType'}//设备类型
			,{name: 'tBPCEBPCEquipMFDr', mapping: 'tBPCEBPCEquipMFDr'}//厂家id
			,{name: 'tBPCEBPCEquipMFDesc', mapping: 'tBPCEBPCEquipMFDesc'}//厂家名称
			,{name: 'tBPCESoftwareVersion', mapping: 'tBPCESoftwareVersion'}//版本
			,{name: 'tBPCEPart', mapping: 'tBPCEPart'}//部件
			,{name: 'tBPCEInstallDate', mapping: 'tBPCEInstallDate'}//安装日期
			,{name: 'tBPCETotalWorkingHour', mapping: 'tBPCETotalWorkingHour'}//总运行时间
			,{name: 'tBPCEPurchaseDate', mapping: 'tBPCEPurchaseDate'}//购买日期
			,{name: 'tBPCEPurchaseAmount', mapping: 'tBPCEPurchaseAmount'}//购买金额
			,{name: 'tBPCEWarrantyYear', mapping: 'tBPCEWarrantyYear'}//保修年限
			,{name: 'installPerIdLtIn', mapping: 'installPerIdLtIn'}//安装人员(内)IDlist
			,{name: 'installPerNameLtIn', mapping: 'installPerNameLtIn'}//安装人员(内)Namelist
			,{name: 'installPersonOut', mapping: 'installPersonOut'}//安装人员(院外)
			,{name: 'keepPerIdList', mapping: 'keepPerIdList'}//保管人员IDlist
			,{name: 'keepPerNameList', mapping: 'keepPerNameList'}//保管人员Namelist
			,{name: 'tBPBEBedDr', mapping: 'tBPBEBedDr'}//床位ID
			,{name: 'tBPBEBed', mapping: 'tBPBEBed'}//床位名称
			
		])
	});

    obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
		,clicksToEdit:1    //单击编辑
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '系统号', width: 50, dataIndex: 'tBPCERowId', sortable: true}
			,{header: '床位', width: 80, dataIndex: 'tBPBEBed', sortable: true}
			,{header: '厂家名称', width: 100, dataIndex: 'tBPCEBPCEquipMFDesc', sortable: true}
			,{header: '设备型号', width: 180, dataIndex: 'tBPCEBPCEquipModel', sortable: true}
			,{header: '设备序列号', width: 180, dataIndex: 'tBPCENo', sortable: true}
			,{header: '设备院内编号', width: 180, dataIndex: 'tBPCECode', sortable: true}
			,{header: '购买日期', width: 100, dataIndex: 'tBPCEPurchaseDate', sortable: true}
			,{header: '设备状态', width: 100, dataIndex: 'tBPCEStatusD', sortable: true}
			,{header: '设备类型', width: 100, dataIndex: 'tBPCEMType', sortable: true}
			,{header: '购买金额(万)', width: 100, dataIndex: 'tBPCEPurchaseAmount', sortable: true}
			,{header: '保修年限(年)', width: 100, dataIndex: 'tBPCEWarrantyYear', sortable: true}
			,{header: '安装人员(院内)', width: 100, dataIndex: 'installPerNameLtIn', sortable: true}
			,{header: '安装人员(院外)', width: 100, dataIndex: 'installPersonOut', sortable: true}
			,{header: '保管人员', width: 100, dataIndex: 'keepPerNameList', sortable: true}
			,{header: '备注', width: 100, dataIndex: 'tBPCENote', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.retGridPanelStore,
		    displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
		    emptyMsg: '没有记录'
		})
		,viewConfig:
		{
			forceFit: false,
			//Return CSS class to apply to rows depending upon data values

			getRowClass: function(record, index)
			{
				var status = record.get('tBPCEStatus');
				//var type=record.get('jzstat');

				switch (status)
				{
					case 'US':
						return 'white'; //blue /refuse
						break;
					case 'SP':
						return 'palegreen';  //green //arranged
						break;
					case 'SC':
						return 'red' ;//yellow //finish
						break;
				}
			}
		}
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
	obj.resultPanel = new Ext.Panel({
		id : 'resultPanel'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,items:[
		    obj.Panel23
			,obj.Panel25
		    ,obj.retGridPanel
		]
	});
	
    obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.detectionPanel
			,obj.resultPanel
		]
	});
	
	//***数据绑定处理***
	//gridview
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCEquip';
		param.QueryName = 'FindEquip';
		param.Arg1 = obj.equipType.getValue();
		param.Arg2 = obj.buyDate.getRawValue();
		param.Arg3 = obj.equipHosNo.getValue();
		param.Arg4 = obj.equipSeqNo.getValue();	
		param.ArgCnt = 1;
	});
	obj.retGridPanelStore.load({});
 
	InitViewScreenEvent(obj);
	
	//事件处理代码
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.ExportExlBtn.on("click",obj.ExportExlBtn_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);
	obj.findbutton.on("click", obj.selectbutton_click, obj);
	obj.maintainBtn.on("click", obj.maintainBtn_click, obj);
	obj.equipType.on("select",obj.equipType_select,obj);
	obj.manufactName.on("select",obj.manufactName_select,obj);
  	obj.LoadEvent(arguments);
	return obj;
}


function InitwinScreen()
{
	var obj = new Object();

	obj.retGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.retGridPanelStore = new Ext.data.Store({
		proxy: obj.retGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tRowId'
		}, 
	    [
			{name: 'tRowId', mapping: 'tRowId'}
			,{name: 'tDBPCEquipDr', mapping: 'tDBPCEquipDr'}
			,{name: 'tDBPCEquipDesc', mapping: 'tDBPCEquipDesc'}
			,{name: 'tDBPEquipPartDr', mapping: 'tDBPEquipPartDr'}
			,{name: 'tDBPEquipPartDesc', mapping: 'tDBPEquipPartDesc'}
			,{name: 'tBPEMType', mapping: 'tBPEMType'}
			,{name: 'tBPEMTypeDesc', mapping: 'tBPEMTypeDesc'}
			,{name: 'tBPEMPartType', mapping: 'tBPEMPartType'}
			,{name: 'tBPEMPartTypeDesc', mapping: 'tBPEMPartTypeDesc'}
			,{name: 'StartDate', mapping: 'StartDate'}
			,{name: 'StartTime', mapping: 'StartTime'}
			,{name: 'EndDate', mapping: 'EndDate'}
			,{name: 'EndTime', mapping: 'EndTime'}
			,{name: 'Note', mapping: 'Note'}
			,{name: 'tBPEMExpense', mapping: 'tBPEMExpense'}
			,{name: 'UserID', mapping: 'UserID'}
			,{name: 'userNameList', mapping: 'userNameList'}
			,{name: 'userIdList', mapping: 'userIdList'}
			,{name: 'userNameOut', mapping: 'userNameOut'} // 院外参加人
		])
	});

    obj.retGridPanel1 = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel1'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
		,clicksToEdit:1    //单击编辑
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,columns:[
		new Ext.grid.RowNumberer()
		,{header: '维护时间', width: 100, dataIndex: 'StartDate', sortable: true}
		,{header: '更换部件', width: 150, dataIndex: 'tDBPEquipPartDesc', sortable: true}
		,{header: '维护内容', width: 100, dataIndex: 'tBPEMTypeDesc', sortable: true}
		,{header: '维护费用', width: 100, dataIndex: 'tBPEMExpense', sortable: true}
		,{header: '参加人(院内)', width: 180, dataIndex: 'userNameList', sortable: true}
		,{header: '参加人(院外)', width: 180, dataIndex: 'userNameOut', sortable: true}
		,{header: '备注', width: 180, dataIndex: 'Note', sortable: true}
		]

		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.retGridPanelStore,
		    displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
		    emptyMsg: '没有记录'
		})
	});

	obj.winMaintainDate = new Ext.form.DateField({
		id : 'winMaintainDate'
		//,value : new Date()
		,labelSeparator: ''
		,fieldLabel:'维护时间'
		,anchor : '95%'
	});
	
	//更换部件		
	obj.winEquipReplace = new Ext.form.TextField({
		id : 'winEquipReplace'
		,fieldLabel : '更换部件'
		,labelSeparator: ''
		,anchor : '95%'
	});
	var data=[
		['C','消毒'],
		['M','保养'],
		['R','维修']
	]
	obj.winMainDescStoreProxy = new Ext.data.MemoryProxy(data),
	
	obj.winMainDescStore = new Ext.data.Store({
		proxy: obj.winMainDescStoreProxy,
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'code'}
			,{name: 'desc'}
		])
	});
	obj.winMainDescStore.load({});
	obj.winMainDesc = new Ext.form.ComboBox({
		id : 'winMainDesc'
		,minChars : 1
		,fieldLabel : '维护内容'
		,labelSeparator: ''
		,triggerAction : 'all'
		,mode:'local'
		,store : obj.winMainDescStore
		,displayField : 'desc'
		,valueField : 'code'
		,anchor :'95%'
	});
	
	obj.winMaintainMoney = new Ext.form.TextField({
		id : 'winMaintainMoney'
		,labelSeparator: ''
		,fieldLabel : '维护费用'
		,anchor : '95%'
	});
	
	obj.installPersonInStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.installPersonInStore = new Ext.data.Store({
	    proxy : obj.installPersonInStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'Id'
		},
		[   
		     {name: 'checked', mapping : 'checked'}
		    ,{name:'Name',mapping:'Name'}
			,{name:'Id',mapping:'Id'}
		])
	
	});
	obj.winPersonMIn = new Ext.ux.form.LovCombo({
	    id : 'winPersonMIn'
		,store : obj.installPersonInStore
		,minChars : 1
		,displayField : 'Name'
		,fieldLabel : '院内参加人'
		,valueField : 'Id'
		,labelSeparator: ''
		,triggerAction : 'all'
		,anchor : '95%'
		,emptyText:'请选择'
		,allowBlank : false
		
	}); 
	obj.installPersonInStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'FindUserByLoc';
		param.Arg1 = session['LOGON.CTLOCID'];
		param.Arg2 = session['LOGON.USERID'];
		param.ArgCnt = 2;
	});
	obj.installPersonInStore.load({});
	
	obj.winNote = new Ext.form.TextField({
		id : 'winNote'
		,fieldLabel : '备注'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.winPersonMOut = new Ext.form.TextField({
		id : 'winPersonMOut'
		,fieldLabel : '院外参加人'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.winTxtRowId = new Ext.form.TextField({
		id : 'winTxtRowId'
		,fieldLabel : ''
		,anchor : '75%'
		,hidden : true
	});
	obj.winEquipInfo = new Ext.form.TextField({
		id : 'winEquipInfo'
		//,allowBlank : false
		,fieldLabel : ''
		,anchor : '75%'
		,hidden : true
	});
	
	obj.Panel11 = new Ext.Panel({
		id : 'Panel11'
		,buttonAlign : 'center'
		//,labelWidth:60
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.winMaintainDate
			,obj.winMaintainMoney
			,obj.winNote
		]
	});
	obj.Panel12 = new Ext.Panel({
		id : 'Panel12'
		,buttonAlign : 'center'
		,columnWidth : .35
		,layout : 'form'
		,labelWidth:80
		,items:[
			obj.winEquipReplace
			,obj.winPersonMIn
			,obj.winEquipInfo
		]
	});
	obj.Panel13= new Ext.Panel({
		id : 'Panel13'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,labelWidth:70
		,items:[
			obj.winMainDesc
			,obj.winPersonMOut
			,obj.winTxtRowId
		]
	});
	obj.basePanel = new Ext.Panel({
		id : 'basePanel'
		,buttonAlign : 'center'
		,labelWidth:60
		,layout : 'column'
		,items:[
			obj.Panel11
			,obj.Panel12
			,obj.Panel13
		]
	});
	
	obj.winBtnSave = new Ext.Button({
		id : 'winBtnSave'
		,iconCls : 'icon-save'
		,text : '保存'
	});
	obj.winBtnCancle = new Ext.Button({
		id : 'winBtnCancle'
		,iconCls : 'icon-cancel'
		,text : '取消'
	});
	obj.winBtnExcel = new Ext.Button({
		id : 'winBtnExcel'
		,iconCls : 'icon-export'
		,text : '导出Excel'
	});
	
	obj.admInfPanel = new Ext.form.FormPanel({
	    id : 'admInfPanel'
		,buttonAlign : 'center'
		,labelWidth : 100
		,title : '维护信息'
		,iconCls:'icon-manage'
		,labelAlign : 'right'
		,region : 'north'
		,layout : 'form'
		,height : 150
		,frame : true
		,items : [
		     obj.basePanel
			//,obj.Panel21
		]
		,buttons:[
			obj.winBtnSave
			,obj.winBtnCancle
			,obj.winBtnExcel
		]
	});
	
	obj.hiddenPanel = new Ext.Panel({
	    id : 'hiddenPanel'
	    ,buttonAlign : 'center'
	    ,region : 'south'
	    ,hidden : true
	    ,items:[	
	    ]
    });

	obj.winScreen = new Ext.Window({
		id : 'winScreen'
		,height : 400
		,buttonAlign : 'center'
		,width : 800
		,title : '编辑'
		,modal : true
		,layout : 'border'
		,items:[
			obj.admInfPanel
			,obj.retGridPanel1
			,obj.hiddenPanel
		]
	});
	InitwinScreenEvent(obj);
	//事件处理代码
	obj.winBtnCancle.on("click", obj.winBtnCancle_click, obj);
	obj.winBtnSave.on("click", obj.winBtnSave_click, obj);
	obj.winBtnExcel.on("click", obj.winBtnExcel_click, obj);
	obj.retGridPanel1.on("rowclick", obj.retGridPanel1_rowclick, obj);
	obj.LoadEvent(arguments);
	return obj;
}
