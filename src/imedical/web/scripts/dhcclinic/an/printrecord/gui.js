function InitViewScreen()
{
 var obj=new Object();
 obj.dateFrm = new Ext.form.DateField({
   id : 'dateFrm'
  ,value : new Date()
  ,format : 'd/m/Y'
  ,fieldLabel : '开始日期'
  ,anchor : '85%'
 });  
 obj.dateTo = new Ext.form.DateField({
   id : 'dateTo'
  ,value : new Date()
  ,format : 'd/m/Y'
  ,fieldLabel : '结束日期'
  ,anchor : '85%'
 });
 obj.panel1 = new Ext.Panel({
   id : 'panel1'
  ,columnWidth : .2
  ,labelWidth:60
  ,layout : 'form'
  ,items:[
     obj.dateFrm
    ,obj.dateTo
   ]
 });
 
 obj.cboLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
	url : ExtToolSetting.RunQueryPageURL
	}));
 obj.cboLocStore = new Ext.data.Store({
	proxy: obj.cboLocStoreProxy,
	reader: new Ext.data.JsonReader({
	root: 'record',
	totalProperty: 'total',
	idProperty: 'ctlocId'
	}, 
	[
	{ name: 'checked', mapping : 'checked'}
	,{name: 'ctlocId', mapping: 'ctlocId'}
	,{name: 'ctlocDesc', mapping: 'ctlocDesc'}
	,{name: 'ctlocCode', mapping: 'ctlocCode'}
		])
	});
 obj.cboLoc = new Ext.form.ComboBox({
	id : 'cboLoc'
	,store : obj.cboLocStore
	,minChars : 1
	,displayField : 'ctlocDesc'
	,fieldLabel : '科室'
	,valueField : 'ctlocId'
	,triggerAction : 'all'
	,anchor : '95%'
	});
 obj.cboLocStoreProxy.on('beforeload', function(objProxy, param){
	param.ClassName = 'web.DHCCLCom';
	param.QueryName = 'FindLocList';
	param.Arg1 = obj.cboLoc.getRawValue();
	param.Arg2 = 'AN^OP';
	param.ArgCnt = 2;
	});
 var sessLoc=session['LOGON.CTLOCID'];
 obj.cboLocStore.load({
 callback:function()
 {
  obj.cboLoc.setValue(sessLoc)
 }
 });
 obj.cboLocH=new Ext.form.TextField({
 id:'cboLocH',
 hidden:true
 })
 obj.cboLocH.setValue(sessLoc);
 var data=[
             ['AN','手术麻醉']
            ,['OPCOUNT','器械清点'] 
          ]			
 obj.cboTypeStoreProxy=data
 obj.cboTypeStore=new Ext.data.Store({
    id:'cboTypeStore'
	,proxy:new Ext.data.MemoryProxy(data)
	,reader:new Ext.data.ArrayReader({},[
    {name:'code'},
    {name:'desc'}
    ])
	})
 obj.cboType = new Ext.form.ComboBox({
	id : 'cboType'
	,store : obj.cboTypeStore
	,minChars : 1
	,displayField : 'desc'
	,fieldLabel : '类型'
	,valueField : 'code'
	,triggerAction : 'all'
	,anchor : '95%'
	});	
 obj.panel2=new Ext.Panel({
    id:'panel2'
    ,columnWidth:.2
    ,layout:'form'
    ,labelWidth:60
    ,items:[
    obj.cboLoc
	,obj.cboType
  ]
	 })
 obj.txtRegNo = new Ext.form.TextField({
	id : 'txtRegNo'
	,fieldLabel : '登记号'
	,anchor : '95%'
	,enableKeyEvents:true
	,vtype:'lengthRange'
	,lengthRange:{min:0,max:8}
	});
 obj.cboOpRoomStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
	url : ExtToolSetting.RunQueryPageURL
	}));
 obj.cboOpRoomStore = new Ext.data.Store({
	proxy: obj.cboOpRoomStoreProxy,
	reader: new Ext.data.JsonReader({
	root: 'record',
	totalProperty: 'total',
	idProperty: 'oprId'
		}, 
	[
	{name: 'checked', mapping : 'checked'}
	,{name: 'oprId', mapping: 'oprId'}
	,{name: 'oprDesc', mapping: 'oprDesc'}
	,{name: 'oprCode', mapping: 'oprCode'}
		])
	});
 obj.cboOpRoom = new Ext.form.ComboBox({
	id : 'cboOpRoom'
	,store : obj.cboOpRoomStore
	,minChars : 1
	,value:'' //retRoomStr.split("^")[0]
	,displayField : 'oprDesc'
	,fieldLabel : '手术间'
	,valueField : 'oprId'
	,triggerAction : 'all'
	,anchor : '95%'
	});
 obj.cboOpRoomStoreProxy.on('beforeload', function(objProxy, param){
	param.ClassName = 'web.UDHCANOPArrange';
	param.QueryName = 'FindAncOperRoom';
	param.Arg1 = obj.cboOpRoom.getRawValue();
	param.Arg2 = ''; //sessLoc;
	param.Arg3 = 'OP^OUTOP^EMOP';
	param.Arg4 = '';
	param.Arg5 = '';
	param.Arg6 = 'T';
	param.Arg7 = obj.cboLocH.getValue();
	param.ArgCnt = 7;
	});
 obj.cboOpRoomStore.load({})
 obj.cboOpRoomH=new Ext.form.TextField({
 id:'cboOpRoomH',
 hidden:true
 })
 try
 {
    var _DHCANOPCom=ExtTool.StaticServerObject('web.DHCANOPCom');
	var ipset=new ActiveXObject("rcbdyctl.Setting"); 
	var localIPAddress="";
	localIPAddress=ipset.GetIPAddress;
	var retRoomStr=_DHCANOPCom.GetRoomIdByIp(localIPAddress);
	if(retRoomStr!="")
	{
	 obj.cboOpRoom.setValue(retRoomStr.split("^")[1])
	 obj.cboOpRoomH.setValue(retRoomStr.split("^")[0])
	}
 }
 catch(e){}
 obj.panel3=new Ext.Panel({
  id:'panel3'
  ,labelWidth:50
  ,layout:'form'
  ,columnWidth:.2
  ,items:[
  obj.txtRegNo
  ,obj.cboOpRoom
  ]
  })
 obj.btnSch=new Ext.Button({
  id:'btnSch'
  ,text:'查询'
  })
 obj.panelNorth=new Ext.Panel({
  id:'panelNorth',
  buttonAlign:'center',
  height:120,
  frame:true,
  layout:'column',
  region:'north',
  items:[
  obj.panel1,
  obj.panel2,
  obj.panel3
  ]
  ,buttons:
  [
   obj.btnSch
  ]
  })
 obj.panelWest=new Ext.Panel({
  id:'panelWest',
  region:'west',
  items:[]
  })
 obj.panelEast=new Ext.Panel({
  id:'panelEast',
  region:'east',
  items:[]
  })
 obj.panelSouth=new Ext.Panel({
  id:'panelSouth',
  region:'south',
  items:[]
  })
 obj.grdPnlResultStoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
  url:ExtToolSetting.RunQueryPageURL
  }))
 obj.grdPnlResultStore=new Ext.data.GroupingStore({
    proxy:obj.grdPnlResultStoreProxy,
	groupField:'tPatName',
	remoteGroup:true, 
	sortInfo:{
	field: "tOpRoom"
	,direction: "ASC"
	},
	reader:new Ext.data.JsonReader({
	root: 'record',
	totalProperty: 'total',
	idProperty: 'clprId'
	},
	[
	{name:'tPatName'},
	{name:'tRegNo'},
	{name:'tOpName'},
	{name:'tOpDateTime'},
	{name:'tOpRoom'},
	{name:'tPrtTitle'},
	{name:'tLoc'},
	{name:'tPrStatus'},
	{name:'tNote'},
	{name:'tUser'},
	{name:'tPrDate'},
	{name:'tPrTime'},
	{name:'opaId'}
	])})
 
 var cm=new Ext.grid.ColumnModel({
   defaults:{
   sortable:true
   },
   columns:[
   new Ext.grid.RowNumberer,
   {
   header:'手术间',
   width:80,
   dataIndex:'tOpRoom'
   //sortable: true
   },
   {
   header:'病人姓名',
   width:60,
   dataIndex:'tPatName'
   //,hidden:true 
   },
   {
   header:'登记号',
   width:100,
   dataIndex:'tRegNo'
   },
   {
   header:'手术名称',
   width:180,
   dataIndex:'tOpName',
   renderer: function(value, meta, record) {      
   meta.attr = 'style="white-space:normal;"';      
   return value;      
   } 
   },
   {
   header:'手术日期',
   width:120,
   dataIndex:'tOpDateTime'
   },
   {
   header:'类型',
   width:80,
   dataIndex:'tPrtTitle'
   },
   {
   header:'科室',
   width:100,
   dataIndex:'tLoc'
   },
   {
   header:'操作状态',
   width:120,
   dataIndex:'tPrStatus'
   },
   {
   header:'备注',
   width:300,
   dataIndex:'tNote',
   renderer: function(value, meta, record) {      
   meta.attr = 'style="white-space:normal;"';      
   return value;      
   } 
   },
   {
   header:'操作人',
   width:50,
   dataIndex:'tUser'
   }, 
   {
   header:'生成日期',
   width:80,
   dataIndex:'tPrDate'
   },
   {
   header:'生成时间',
   width:50,
   dataIndex:'tPrTime'
   },
   {
   header:'opaId',
   width:50,
   dataIndex:'opaId'
   }]
 })
 obj.grdPnlResult=new Ext.grid.GridPanel({
    id:'grdPnlResult',
	region:'center',
    frame:true,
	store:obj.grdPnlResultStore,
	cm:cm,
	loadMask:true,
	viewConfig: new Ext.grid.GroupingView({
    forceFit:false,
    groupTextTpl: '{text} ({[values.rs.length]} {["条记录"]})',
	getRowClass: function(record, index)
	{
	var status = record.get('tPrStatus');
	switch (status)
	{
	 case '启动监护' :
	 return 'lightblue';
	 break;
	 case 'PDF上传成功' :
	 return 'red' ;//red 
	 break;
	 //case 'PDF上传失败' :
	 //return 'purple';
	 //break;
	}
	}
	
    })

 })
 obj.grdPnlResultStoreProxy.on('beforeload', function(objProxy, param){
	param.ClassName = 'web.DHCANOPPrintRecord';
	param.QueryName = 'FindPrintRecord';
	param.Arg1 = obj.dateFrm.getRawValue();
	param.Arg2 = obj.dateTo.getRawValue();
	param.Arg3 = obj.cboOpRoomH.getValue();
	param.Arg4 = obj.cboLocH.getValue();
	param.Arg5 = obj.cboType.getValue();
	param.Arg5 = obj.cboType.getValue();
	param.Arg6 = obj.txtRegNo.getValue();
	param.ArgCnt = 6;
		});
 obj.grdPnlResultStore.load({})
 obj.ViewScreen=new Ext.Viewport({
  id:'viewScreen',
  layout:'border',
  items:[
  obj.panelNorth,
  obj.grdPnlResult
  ]
  })
 InitViewScreenEvent(obj);
 obj.btnSch.on('click',obj.btnSch_click,obj)
 obj.cboOpRoom.on("expand",obj.cboOpRoom_expand,obj)
 obj.cboOpRoom.on("select", obj.cboOpRoom_select, obj);
 obj.cboOpRoom.on("keyup", obj.cboOpRoom_keyup, obj);
 obj.cboLoc.on("expand",obj.cboLoc_expand,obj)
 obj.cboLoc.on("select", obj.cboLoc_select, obj);
 obj.cboLoc.on("keyup", obj.cboLoc_keyup, obj);
  return obj
}