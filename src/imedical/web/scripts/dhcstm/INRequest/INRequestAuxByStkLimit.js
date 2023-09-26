// 名称:辅助请求(依据<库存上下限>)
// 编写日期:2012-08-10
var CtLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];
var URL = 'dhcstm.inrequestaction.csp';
var strPar = "";
var gGroupId=session['LOGON.GROUPID'];
var rowDelim=xRowDelim();


// 请求部门
var LocField= new Ext.ux.LocComboBox({
	fieldLabel : '请求部门',
	id : 'LocField',
	emptyText : '请求部门...',
	groupId:gGroupId,
	linkloc:CtLocId,
	protype : INREQUEST_LOCTYPE,
	listeners:
	{
		'select':function(cb)
		{
			var requestLoc=cb.getValue();
			var defprovLocs=tkMakeServerCall("web.DHCSTM.DHCTransferLocConf","GetDefLoc",requestLoc,gGroupId)
			var mainArr=defprovLocs.split("^");
	        var defprovLoc=mainArr[0];
	        var defprovLocdesc=mainArr[1];
			addComboData(Ext.getCmp('supplyLocField').getStore(),defprovLoc,defprovLocdesc);
			Ext.getCmp("supplyLocField").setValue(defprovLoc);
			var provLoc=Ext.getCmp('supplyLocField').getValue();
			Ext.getCmp("group").setFilterByLoc(requestLoc,provLoc);	
		}
	}
});

var supplyLocField = new Ext.ux.ComboBox({
	id:'supplyLocField',
	fieldLabel:'供给部门',
	listWidth:210,
	emptyText:'供给部门...',
	displayField:'Description',
	valueField:'RowId',
	store:frLocListStore,
	params:{LocId:'LocField'},
	filterName:'FilterDesc',
	listeners:
	{
		'select':function(cb)
		{
			var provLoc=cb.getValue();
			var requestLoc=Ext.getCmp('LocField').getValue();
			Ext.getCmp("group").setFilterByLoc(requestLoc,provLoc);
		}
	}
});

var group = new Ext.ux.StkGrpComboBox({
	id:'group',
	StkType:App_StkTypeCode,
	LocId:CtLocId,
	anchor:'90%',
	UserId:UserId
});
//自动加载登陆科室的默认供给部门
LocField.fireEvent('select',LocField);
var reqOrder = new Ext.form.TextField({
	id:'reqOrder',
	fieldLabel:'请求单号',
	allowBlank:true,
	width:200,
	listWidth:200,
	emptyText:'',
	anchor:'90%',
	selectOnFocus:true,
	readOnly:true
});

var IntSigner = new Ext.form.Checkbox({
	id: 'IntSigner',
	fieldLabel:'包装量取整',
	allowBlank:true
});

var ManagerDrugSigner = new Ext.form.Checkbox({
	id:'ManagerDrugSigner',
	fieldLabel:'重点关注标志',
	allowBlank:true
});

var INRequestAuxByStkLimitGrid="";
//配置数据源
var INRequestAuxByStkLimitGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=queryFZByLimit',method:'GET'});
var INRequestAuxByStkLimitGridDs = new Ext.data.Store({
	proxy:INRequestAuxByStkLimitGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty : "results"
	}, [
		{name:'inci'},
		{name:'code'},
		{name:'desc'},
		{name:'uom'},
		{name:'qty'},
		{name:'minQty'}, //下限
		{name:'maxQty'}, //上限
		{name:'repQty'},
		{name:'incil'},
		{name:'pUom'},
		{name:'pUomDesc'},
		{name:'sbdesc'}, //货位
		{name:'reqQty'}, //请求数量
		{name:'realReqQty'},
		{name:'pid'},
		{name:'ind'}
	]),
	remoteSort:false,
	pruneModifiedRecords:true,
	listeners:{
		'load':function(ds){
			if (ds.getCount()>0) {
				Ext.getCmp('LocField').setDisabled(true);
				Ext.getCmp('supplyLocField').setDisabled(true);
				Ext.getCmp('group').setDisabled(true);
				Ext.getCmp('IntSigner').setDisabled(true);
				Ext.getCmp('ManagerDrugSigner').setDisabled(true);
			}else{
				Ext.getCmp('LocField').setDisabled(false);
				Ext.getCmp('supplyLocField').setDisabled(false);
				Ext.getCmp('group').setDisabled(false);
				Ext.getCmp('IntSigner').setDisabled(false);
				Ext.getCmp('ManagerDrugSigner').setDisabled(false);
			}
		}
	}
});
//模型
var INRequestAuxByStkLimitGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
		header:"物资rowid",
		dataIndex:'inci',
		width:80,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"物资代码",
		dataIndex:'code',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"物资名称",
		dataIndex:'desc',
		width:250,
		align:'left',
		sortable:true
	},{
		header:"单位",
		dataIndex:'pUomDesc',
		width:80,
		align:'left',
		sortable:true
	},{
		header:"建议申请量",
		dataIndex:'reqQty',
		width:120,
		align:'right',
		sortable:true
	},{
		header:"实际申请量",
		dataIndex:'realReqQty',
		width:120,
		align:'right',
		sortable:true,
		editor:new Ext.form.NumberField({
			id:'reqQtyField',
			allowBlank:false
		})
	},{
		header:"当前库存",
		dataIndex:'qty',
		width:120,
		align:'right',
		sortable:true
	},{
		header:"库存上限",
		dataIndex:'maxQty',
		width:120,
		align:'right',
		sortable:true
	},{
		header:"库存下限",
		dataIndex:'minQty',
		width:120,
		align:'right',
		sortable:true
	},{
		header:"标准库存",
		dataIndex:'repQty',
		width:120,
		align:'right',
		sortable:true
	},{
		header:"pid",
		dataIndex:'pid',
		width:80,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"ind",
		dataIndex:'ind',
		width:80,
		align:'left',
		sortable:true,
		hidden:true
	}
]);

function getPid(){
	var pid="";
	if(INRequestAuxByStkLimitGridDs.getCount()>0){
		var record=INRequestAuxByStkLimitGridDs.getAt(0);
		pid=record.get("pid")
	}
	return pid;
}

var find = new Ext.Toolbar.Button({
	text:'查询',
	tooltip:'查询',
	iconCls:'page_find',
	width:70,
	height:30,
	handler:function(){
		INRequestAuxByStkLimitGridDs.removeAll();
		//供给部门
		var frLoc = Ext.getCmp('supplyLocField').getValue();
		if((frLoc=="")||(frLoc==null)){
			Msg.info("error", "请选择供给部门!");
			return false;
		}
		//请求部门
		var toLoc = Ext.getCmp('LocField').getValue();
		if((toLoc=="")||(toLoc==null)){
			Msg.info("error", "请选择请求部门!");
			return false;
		}
		/*求部门和供给部门不能相同*/
		if (frLoc==toLoc){
			Msg.info("error", "请求部门和供给部门不能相同!");
			return false;
		}
		//类组
		var groupId = Ext.getCmp('group').getValue();
		//alert(groupId)
		if ((groupId=='')||(groupId==null)){
			Msg.info("error", "类组不能为空!");
			return false;
		}
		//重点关注标志
		var man = (Ext.getCmp('ManagerDrugSigner').getValue()==true?1:0);
		//取整标志
		var round = (Ext.getCmp('IntSigner').getValue()==true?'Y':'N');
		var pid=getPid();
		strPar = toLoc+"^"+frLoc+"^"+groupId+"^"+man+"^"+round;
		INRequestAuxByStkLimitGridDs.load({
			params:{start:0,limit:pagingToolbar.pageSize,sort:'code',dir:'desc',strPar:strPar+"^"+pid+"^0"},
			callback:function(r,options, success){
				if(success==false){
					Msg.info("error", "查询错误，请查看日志!");
				}
			}
		});
	}
});

//生成请领单
function CreateReq(){
	var frLoc = Ext.getCmp('supplyLocField').getValue();
	if((frLoc=="")||(frLoc==null)){
		Msg.info("warning", "请选择供给部门!");
		return;
	}
	//请求部门
	var toLoc = Ext.getCmp('LocField').getValue();
	if((toLoc=="")||(toLoc==null)){
		Msg.info("warning", "请选择请求部门!");
		return;
	}
	//类组
	var scg = Ext.getCmp('group').getValue();
	var reqInfo=frLoc+"^"+toLoc+"^"+UserId+"^"+scg;
	var count = INRequestAuxByStkLimitGridDs.getCount();
	if(count==0){
		Msg.info("warning","没有请领明细,不能生成请求单!");
		return;
	}
	var record=INRequestAuxByStkLimitGridDs.getAt(0);
	var pid=record.get("pid");
	if(pid==null || pid==""){
		Msg.info("warning","没有请领明细,不能生成请求单!");
		return;
	}

	Ext.Ajax.request({
		url : 'dhcstm.inrequestaction.csp?actiontype=CreateReqByLim&Pid='+pid+'&ReqInfo='+reqInfo,
		method : 'POST',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "生成请求单成功!");
				var infoArr = jsonData.info.split("^");
				var req = infoArr[0];
				var reqNo = infoArr[1];
				Ext.getCmp("reqOrder").setValue(reqNo);

				location.href="dhcstm.inrequest.csp?reqByabConsume="+req;
			}else{
				Msg.info("error", "生成请求单失败:"+jsonData.info);
			}
		},
		scope : this
	});
}
var CreateBtn = new Ext.Toolbar.Button({
	text:'生成请求单',
	tooltip:'点击生成请求单',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	disabled:false,
	handler:function(){
		CreateReq();
	}
});
var productReqOrder = new Ext.Toolbar.Button({
	text:'保存',
	tooltip:'保存',
	iconCls:'page_save',
	width : 70,
	height : 30,
	disabled:false,
	handler:function(){
		var count = INRequestAuxByStkLimitGridDs.getCount();
		if(count==0){
			Msg.info("warning","没有请求明细,禁止保存!");
			return;
		}
		var str = "";
		var pid="";
		for(var index=0;index<count;index++){
			var rec = INRequestAuxByStkLimitGridDs.getAt(index);
			if(rec.data.newRecord || rec.dirty){
				pid=rec.data["pid"];
				var ind = rec.data['ind'];
				var qty = rec.data['realReqQty'];

				var tmp = ind+"^"+qty;
				if(str==""){
					str = tmp;
				}else{
					//str = str +","+ tmp;
					str = str + rowDelim+ tmp;
				}
			}
		}
		if(pid==""){
			Msg.info("warning","没有请求明细,禁止保存!");
			return;
		}

		Ext.Ajax.request({
			url : 'dhcstm.inrequestaction.csp?actiontype=SaveForAuxByLim',
			params:{Pid:pid,ListData:str},
			method : 'POST',
			waitMsg : '查询中...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", "保存成功!");
//					var reqNo=jsonData.info;
//					Ext.getCmp('reqOrder').setValue(reqNo);  //请求单号
				}else{
					Msg.info("error", "保存失败:"+jsonData.info);
				}
			},
			scope : this
		});
	}
});
var clear = new Ext.Toolbar.Button({
	id:'clearData',
	text:'清空',
	tooltip:'清空',
	iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		Ext.Msg.show({
			title:'提示',
			msg: '是否确定清空辅助请求数据?(注:此数据为临时统计结果,可重新统计.)',
			buttons: Ext.Msg.YESNO,
			fn: function(btn){
				if (btn=='yes') {clearDataGrid();}
			}
		})
	}
});

function clearDataGrid()
{
	//清空临时global数据
	var record=INRequestAuxByStkLimitGridDs.getAt(0);
	if (record!=undefined&&record!=""){
		var pid=record.get("pid");
		KillTmpGlobal(pid) ;
	}
	INRequestAuxByStkLimitGrid.getStore().removeAll();
	INRequestAuxByStkLimitGrid.getView().refresh();
	Ext.getCmp('supplyLocField').setDisabled(false);
	Ext.getCmp('LocField').setDisabled(false);
	Ext.getCmp('group').setDisabled(false);
	Ext.getCmp('IntSigner').setDisabled(false);
	Ext.getCmp('ManagerDrugSigner').setDisabled(false);
	
	Ext.getCmp("supplyLocField").setValue("");
	Ext.getCmp("LocField").setValue("");
	Ext.getCmp("group").setValue("");
	Ext.getCmp("IntSigner").setValue(false);
	Ext.getCmp("ManagerDrugSigner").setValue(false);
	SetLogInDept(LocField.getStore(),"LocField");
	
	var requestLoc=Ext.getCmp("LocField").getValue();
	var defprovLocs=tkMakeServerCall("web.DHCSTM.DHCTransferLocConf","GetDefLoc",requestLoc,gGroupId)
	var mainArr=defprovLocs.split("^");
	var defprovLoc=mainArr[0];
	var defprovLocdesc=mainArr[1];
	addComboData(Ext.getCmp('supplyLocField').getStore(),defprovLoc,defprovLocdesc);
	Ext.getCmp("supplyLocField").setValue(defprovLoc);
	var provLoc=Ext.getCmp('supplyLocField').getValue();
	Ext.getCmp("group").setFilterByLoc(requestLoc,provLoc);
}

//初始化默认排序功能
INRequestAuxByStkLimitGridCm.defaultSortable = true;

var pagingToolbar = new Ext.PagingToolbar({
	store:INRequestAuxByStkLimitGridDs,
	pageSize:PageSize,
	displayInfo:true,
	displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
	emptyMsg:"没有记录",
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B[A.sort]='rowid';
		B[A.dir]='desc';
		var pid=getPid();
		B['strPar']=strPar+"^"+pid+"^1";  //1:表示翻页
		var data=INRequestAuxByStkLimitGridDs.getModifiedRecords();
		if(data.length>0){
			Msg.info("warning","本页有尚未保存的记录，请先保存！");
			return;
		}
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//表格
INRequestAuxByStkLimitGrid = new Ext.grid.EditorGridPanel({
	store:INRequestAuxByStkLimitGridDs,
	cm:INRequestAuxByStkLimitGridCm,
	trackMouseOver:true,
	stripeRows:true,
	region:'center',
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	bbar:pagingToolbar
});

function KillTmpGlobal(pid)
{
	Ext.Ajax.request({
		url : 'dhcstm.inrequestaction.csp?actiontype=KillTmpGlobal',
		params:{Pid:pid},
		method : 'POST',
		success:function(){

		},
		failure:function(){
			Msg.info('error','后台临时数据清空错误!')
		}
	});
}


Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var formPanel = new Ext.form.FormPanel({
		title : '库存请求辅助制单(依上下限)',
		region:'north',
		labelAlign : 'right',
		autoHeight : true,
		frame : true,
		bodyStyle : 'padding:5px;',
		tbar:[find,'-',productReqOrder,'-',CreateBtn,'-',clear],
		items : [{
			title : '选项信息',
			xtype : 'fieldset',
			layout : 'column',
			defaults : {layout : 'form'},
			items : [{
				columnWidth : 0.25,
				items : [LocField, supplyLocField]
			},{
				columnWidth : 0.25,
				items : [group]
			},{
				columnWidth : 0.25,
				items : [IntSigner, ManagerDrugSigner]
			}]
		}]
	});

	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,INRequestAuxByStkLimitGrid]
	});
});
