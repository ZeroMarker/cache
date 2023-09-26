// 名称:月度申领计划制单
// 编写日期:2012-07-19

var gGroupId=session['LOGON.GROUPID'];
var CtLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];
var gHospId=session['LOGON.HOSPID'];
var URL = 'dhcstm.inrequestaction.csp';
var strParam = "";
var req = "";			//定义全局变量:主表rowid
var statu = "N";		//定义全局变量:完成状态(默认状态:N)
var byTemplate=false;	//根据模板制单标志
var opaId=opaId	//手术安排Id
var requestNumber = new Ext.form.TextField({
	id:'requestNumber',
	fieldLabel:'申领计划单号',
	listWidth:150,
	anchor:'90%',
	selectOnFocus:true,
	disabled:true
});

var LocField= new Ext.ux.LocComboBox({
	fieldLabel : '申领部门',
	id : 'LocField',
	name : 'LocField',
	anchor:'90%',
	emptyText : '申领部门...',
	groupId:gGroupId,
	protype : INREQUEST_LOCTYPE,
	linkloc:CtLocId,
	listeners:{
		'select':function(cb){
			temStore.setBaseParam("locId",Ext.getCmp('LocField').getValue());
			temStore.removeAll();
			temStore.reload();
		}
	}
});

var dateField = new Ext.ux.DateField({
	id:'dateField',
	listWidth:150,
	fieldLabel:'制单日期',
	anchor:'90%',
	value:new Date(),
	disabled:true
});

var timeField=new Ext.form.TextField({
	id:'timeField',
	disabled:true,
	anchor:'90%',
	fieldLabel:'制单时间'
});
var userField=new Ext.form.TextField({
	id:'userField',
	disabled:true,
	anchor:'90%',
	fieldLabel:'制单人'
});

var supplyLocField = new Ext.ux.ComboBox({
	id:'supplyLocField',
	fieldLabel:'供给部门',
	anchor:'90%',
	store:frLocListStore,
	displayField:'Description',
	valueField:'RowId',
	listWidth:210,
	emptyText:'供给部门...',
	params:{LocId:'LocField'}
});

var remark = new Ext.form.TextField({
	id:'remark',
	fieldLabel:'备注',
	anchor:'100%',
	selectOnFocus:true
});

var temName = new Ext.form.TextField({
	id:'temName',
	fieldLabel:'模版名称',
	anchor:'100%',
	selectOnFocus:true
});

var completeCK = new Ext.form.Checkbox({
	id: 'completeCK',
	fieldLabel:'完成',
	anchor:'100%',
	disabled:true,
	allowBlank:true,
	listeners : {
		check : function(checkbox,checked){
			if(checked){
				Ext.getCmp("save").disable();
				Ext.getCmp("delete").disable();
				Ext.getCmp("complete").disable();
				Ext.getCmp("cancelComp").enable();
			}else{
				Ext.getCmp("save").enable();
				Ext.getCmp("delete").enable();
				Ext.getCmp("complete").enable();
				Ext.getCmp("cancelComp").disable();
			}
		}
	}
});

var templateFlag=new Ext.form.Checkbox({
	id: 'template',
	fieldLabel:'模板标志',
	anchor:'100%',
	allowBlank:true
});

var Specom = new Ext.form.ComboBox({
	fieldLabel : '具体规格',
	id : 'Specom',
	name : 'Specom',
	anchor : '90%',
	width : 120,
	listWidth :210,
	store : SpecDescStore,
	valueField : 'Description',
	displayField : 'Description',
	triggerAction : 'all',
	emptyText : '具体规格...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 10,
	valueNotFoundText : '',
	listeners:({
		'beforequery':function(){
			var cell = InRequestGrid.getSelectionModel().getSelectedCell();
			var record = InRequestGrid.getStore().getAt(cell[0]);
			var IncRowid = record.get("inci");
			var desc=this.getRawValue();
			this.store.removeAll();    //load之前remove原记录，否则容易出错
			this.store.setBaseParam('SpecItmRowId',IncRowid)
			this.store.setBaseParam('desc',desc)
			this.store.load({params:{start:0,limit:this.pageSize}})
		}
	})
});

var TypeStore=new Ext.data.SimpleStore({
	fields:['RowId','Description'],
	data:[['O','请领单'],['C','申领计划']]
});
var reqType=new Ext.form.ComboBox({
	id:'reqType',
	fieldLabel:'请求单类型',
	store:TypeStore,
	valueField:'RowId',
	displayField:'Description',
	emptyText:'请求单类型...',
	triggerAction:'all',
	anchor:'90%',
	minChars:1,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	mode:'local',
	disabled:true,
	disabled:true
});
Ext.getCmp('reqType').setValue('C');

var find = new Ext.Toolbar.Button({
	text:'请领单状态查询',
	tooltip:'请领单状态查询',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		if (isDataChanged()){
			Ext.Msg.show({
				title:'提示',
				msg: '已经对该单数据做了修改，继续执行将丢失掉修改，继续吗？',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
					if (btn=='yes') {
						clearReq();
						if(IsSplit()=="Y"){
							findReqSplit(refresh);
						}else{
							findReq(refresh);
						}
					}
				}
			});
		}else{
			if(IsSplit()=="Y"){
				findReqSplit(refresh);
			}else{
				findReq(refresh);
			}
		}
	}
});

var clear = new Ext.Toolbar.Button({
	id:'clear',
	text:'清空',
	tooltip:'清空',
	iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		if (isDataChanged()){
			Ext.Msg.show({
				title:'提示',
				msg: '已经对该单数据做了修改，继续执行将丢失掉修改，继续吗？',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
					if (btn=='yes') {
						clearReq();
						SetFormOriginal(formPanel);
					}
				}
			})
		}else{
			clearReq();
			SetFormOriginal(formPanel);
		}
	}
});

function clearReq(){
	req="";
	InRequestGridDs.removeAll();
	remark.setValue("");
	requestNumber.setValue("");
	dateField.setValue(new Date());
	completeCK.setValue(false);
	del.enable();
	Ext.getCmp('template').setValue(false);
	Ext.getCmp('template').setDisabled(false);
	timeField.setValue("");
	userField.setValue("");
	reqType.setValue("C");
	Ext.getCmp('save').enable();
	add.setDisabled(false);
}

function changeBgColor(row, color) {
	InRequestGrid.getView().getRow(row).style.backgroundColor = color;
}

function getDrugList2(records) {
	records = [].concat(records);
	if (records == null || records == "") {
		return false;
	}
	Ext.each(records,function(record,index,allItms){
		var inciDr = record.get("InciDr");
		var findIndex = InRequestGridDs.findExact('inci',inciDr);
		var cell = InRequestGrid.getSelectionModel().getSelectedCell();
		// 选中行
		var row = cell[0];
		var rowData = InRequestGridDs.getAt(row);
		rowData.set("inci",record.get("InciDr"));
		rowData.set("code",record.get("InciCode"));
		rowData.set("desc",record.get("InciDesc"));
		rowData.set("spec",record.get("Spec"));
		rowData.set("provloc",record.get("provLoc"));
		rowData.set("provlocid",record.get("provLocid"));
		rowData.set("HVFlag",record.get("HVFlag"));
		rowData.set("ZeroStkFlag",record.get("ZeroStkFlag"));
		//供应商id^供应商名称^厂商id^厂商名称^配送商id^配送商名称^入库单位id^入库单位^进价^售价^申购科室库存量^库存上限^库存下限^通用名^商品名^剂型^规格
		//取其它物资信息
		var locId = Ext.getCmp('LocField').getValue();
		if(locId!=""){
			var inci=record.get("InciDr");
			var uom="";
			var params=gGroupId+"^"+locId+"^"+UserId+"^"+uom;
			GetItmInfo(inci,params,rowData)
		}else{
			Msg.info("error","请选择科室!");
		}
 		addNewRow();
    })		
    var colIndex=InRequestGrid.getColumnModel().getIndexById('colQty');
    if (!InRequestGrid.getColumnModel().isHidden(colIndex)){
    var count=InRequestGridDs.getCount()
        var row
        for(i=0;1<count;i++){
            if(Ext.isEmpty(InRequestGridDs.getAt(i).get('qty')))
            {row=i;break}
        }
        InRequestGrid.getSelectionModel().select(row, colIndex);
        InRequestGrid.startEditing(row, colIndex);
    }
}

function GetItmInfo(inci,paramstr,rowData){
	var url=URL+'?actiontype=GetItmInfo&IncId='+ inci +'&Params='+paramstr;
	var response=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(response);
	if(jsonData.success=='true'){
		var data=jsonData.info.split("^");
		var ManfId = data[0];
		var Manf = data[1];
		rowData.set("manf", Manf);
		var UomId=data[2];
		var Uom=data[3];
		rowData.set("uom", UomId);
		rowData.set("uomDesc", Uom);
		rowData.set("sp", data[5]);
		rowData.set("rp", data[4]);
		rowData.set("spAmt",accMul(Number(rowData.get('qty')),Number(rowData.get('sp'))));
		rowData.set("rpAmt",accMul(Number(rowData.get('qty')),Number(rowData.get('rp'))));
		rowData.set("repLev", data[10]);
	}
}

function GetPhaOrderInfo2(item, group) {
	if (item != null && item.length > 0) {
		var toloc=Ext.getCmp('LocField').getValue()
		GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", gHospId,getDrugList2,toloc,"","","","C","N","Y");
	}
}

function addNewRow() {
	if ((req!="")&&(Ext.getCmp('completeCK').getValue()==true)){
		Msg.info('warning','当前申领计划单已完成');
		return;
	}
	var rowCount =InRequestGrid.getStore().getCount();
	if(rowCount==0 || InRequestGridDs.getAt(rowCount - 1).get("inci")!=''){
		var defaData = {};
		var NewRecord = CreateRecordInstance(InRequestGridDs.fields,{});		
		InRequestGridDs.add(NewRecord);
	}
	var colIndex=GetColIndex(InRequestGrid,'desc');
	if (!InRequestGrid.getColumnModel().isHidden(colIndex)){
		InRequestGrid.startEditing(InRequestGridDs.getCount() - 1, colIndex);
	}
}

var CTUom = new Ext.form.ComboBox({
		fieldLabel : '单位',
		id : 'CTUom',
		name : 'CTUom',
		anchor : '90%',
		width : 120,
		store : ItmUomStore,
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : false,
		triggerAction : 'all',
		emptyText : '单位...',
		selectOnFocus : true,
		forceSelection : true,
		minChars : 1,
		pageSize : 10,
		listWidth : 250,
		valueNotFoundText : ''
	});
	
CTUom.on('expand', function(combo) {
		var cell = InRequestGrid.getSelectionModel().getSelectedCell();
		var record = InRequestGrid.getStore().getAt(cell[0]);
		var IncRowid = record.get("inci");
		ItmUomStore.removeAll();
		ItmUomStore.load({params:{ItmRowid:IncRowid}});
	});

CTUom.on('select', function(combo) {
		var cell = InRequestGrid.getSelectionModel().getSelectedCell();
		var record = InRequestGrid.getStore().getAt(cell[0]);
		var value = combo.getValue();        //目前选择的单位id
		var uom=value;
		var inci=record.get("inci");
		var LocId=Ext.getCmp('LocField').getValue();
		var params=gGroupId+"^"+LocId+"^"+UserId+"^"+uom;
		GetItmInfo(inci,params,record);
	});

//配置数据源
var InRequestGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=queryDetail',method:'GET'});
var InRequestGridDs = new Ext.data.Store({
	proxy:InRequestGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results'
		}, [
		{name:'rowid'},
		{name:'inci'},
		{name:'code'},
		{name:'desc'},
		{name:'repLev'},
		{name:'qty'},
		{name:'uom'},
		{name:'uomDesc'},
		{name:'spec'},
		{name:'manf'},
		{name:'sp'},
		{name:'spAmt'},
		{name:'rp'},
		{name:'rpAmt'},
		{name:'generic'},
		{name:'drugForm'},
		{name:'remark'},
		{name:'provloc'},
		{name:'HVFlag'},
		{name:'ZeroStkFlag'},
		{name:'SpecDesc'},
		{name:'provlocid'}
	]),
	remoteSort:false,
	listeners : {
		load : function(ds){
			//根据模板制单时,将rowid置空
			if (byTemplate){
				var cnt=ds.getCount();
				for (var i=0;i<cnt;i++){
					var rec=ds.getAt(i);
					rec.set('rowid','');
				}
				byTemplate=false;
			}
		}
	}
});

//模型
var InRequestGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:"明细rowid",
		dataIndex:'rowid',
		width:100,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"物资rowid",
		dataIndex:'inci',
		width:100,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"物资代码",
		dataIndex:'code',
		width:100,
		align:'left',
		renderer :Ext.util.Format.InciPicRenderer('inci'),
		sortable:true
	},{
		header:"物资名称",
		dataIndex:'desc',
		id:'colDesc',
		width:150,
		align:'left',
		sortable:true,
		editor:new Ext.form.TextField({
			id:'descField',
			allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var stkGrp='';
						GetPhaOrderInfo2(Ext.getCmp('descField').getValue(),stkGrp);
					}
				}
			}
		})
	},{
		header:"规格",
		dataIndex:'spec',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"厂商",
		dataIndex:'manf',
		width:150,
		align:'left',
		sortable:true
	},{
        header:"请领基数",
        dataIndex:'repLev',
        width:100,
        align:'right',
        sortable:true
	},{
		header:"申领数量",
		dataIndex:'qty',
		id:'colQty',
		xtype:'numbercolumn',
		format:'0',
		width:100,
		align:'right',
		sortable:true,
		editor:new Ext.form.NumberField({
			id:'qtyField',
			allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var qty = field.getValue();
						var cell = InRequestGrid.getSelectionModel().getSelectedCell();
						var repLev = InRequestGridDs.getAt(cell[0]).get('repLev');
						if (repLev!=""&repLev!=null&repLev!=0){repLev=qty%repLev;}
						if (repLev!=""&repLev!=null&repLev!=0){
							Msg.info("error", "请求数量需要是请求基数的整数倍!");
							return;
						}
						else{
							//var colIndex=InRequestGrid.getColumnModel().getIndexById('colRemark');
							var colIndex=InRequestGrid.getColumnModel().getIndexById('colDesc');
							if (!InRequestGrid.getColumnModel().isHidden(colIndex)){
							InRequestGrid.startEditing(InRequestGridDs.getCount() - 1,colIndex ); }
						}		
					}
				}
			}
		})
	},{
		header:"零售单价",
		dataIndex:'sp',
		xtype:'numbercolumn',
		width:100,
		align:'right',
		sortable:true
	},{
		header:"售价金额",
		dataIndex:'spAmt',
		xtype:'numbercolumn',
		width:100,
		align:'right',
		sortable:true,
		hidden:true
	},{
		header:'进价',
		dataIndex:'rp',
		xtype:'numbercolumn',
		width:100,
		aligh:'right'
	},{
		header:'进价金额',
		dataIndex:'rpAmt',
		xtype:'numbercolumn',
		width:100,
		aligh:'right',
		hidden:true
	},{
		header:"单位",
		dataIndex:'uom',
		id:'colUom',
		width:100,
		align:'left',
		sortable:true,
		editor : new Ext.grid.GridEditor(CTUom),
		renderer : Ext.util.Format.comboRenderer2(CTUom,"uom","uomDesc")
	},{
		header:"备注",
		dataIndex:'remark',
		id:'colRemark',
		width:200,
		align:'left',
		sortable:true,
		editor:new Ext.form.TextField({
			id:'remarkField',
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = InRequestGrid.getSelectionModel().getSelectedCell();
						if(InRequestGridDs.getAt(cell[0]).get('qty')==0){
							Msg.info("error","申领数量不能为0!");
							
							var colIndex=InRequestGrid.getColumnModel().getIndexById('colQty');
							if (!InRequestGrid.getColumnModel().isHidden(colIndex)){
								InRequestGrid.startEditing(InRequestGridDs.getCount() - 1,colIndex );
							}
						}else{
							//增加一行
							addNewRow();
						}
					}
				}
			}
		})
	},{
		header:"供应仓库",
		dataIndex:'provloc',
		width:150,
		align:'left',
		renderer:function(v,cellmeta){
		return '<span style="color:red;font-weight:bold">'+v+'</span>';
		},
		sortable:true
	},{
		header:"供应仓库id",
		dataIndex:'provlocid',
		width:60,
		align:'left',
		hidden:true
	},{
		header:"高值标志",
		dataIndex:'HVFlag',
		width:80,
		align:'center',
		renderer :function(v){
			if(v=="Y"){return "是"}
			else{return "否"}
		},
		sortable:true
	},{
		header:"零库存标志",
		dataIndex:'ZeroStkFlag',
		width:80,
		align:'center',
		renderer :function(v){
			if(v=="Y"){return "是"}
			else{return "否"}
		},
		sortable:true
	},{
		header:"具体规格",
		dataIndex:'SpecDesc',
		width:100,
		align:'left',
		sortable:true,
		editor : new Ext.grid.GridEditor(Specom),
		renderer : Ext.util.Format.comboRenderer2(Specom,"SpecDesc","SpecDesc")
	}
]);

var add = new Ext.Toolbar.Button({
	text:'新建',
	id:'newReq',
	iconCls:'page_add',
	tooltip:'新建申领计划单',
	width : 70,
	height : 30,
	handler:function(){
		if (isDataChanged())
		{
			Ext.Msg.show({
				title:'提示',
				msg: '已经对该单数据做了修改，继续执行将丢失掉修改，继续吗？',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
					if (btn=='yes') {
						clearReq();
					}
				}
			})
		} else {
			clearReq();
		}
	}
});

function saveReq(tempFlag,comp)
{  
	if(InRequestGrid.activeEditor != null){
		InRequestGrid.activeEditor.completeEdit();
	}
	
	if (tempFlag){
		var remark=Ext.getCmp('remark').getValue();
		var xx=remark.trim();
		if ((xx=="")||(xx==null)){
			Msg.info('error',"请在<备注>填写模板名称。");
			return;
		}
	}
	
	//请求部门
	var toLoc = Ext.getCmp('LocField').getValue(); 
	if((toLoc=="")||(toLoc==null)){
		Msg.info("error", "请选择申领部门!");
		return false;
	}
	/* 请求部门=供应部门  */
	var frLoc =toLoc;
	//登陆用户
	var user = UserId;
	var scg="";  /* 类组="" */
	
	//完成标志(暂时为空)
	var status =Ext.getCmp('reqType').getValue(); 
	//备注
	var remark = Ext.getCmp('remark').getValue(); 
	remark=remark.replace(/\r/g,'').replace(/\n/g,xMemoDelim());
	//主表信息字符串
	var reqInfo = frLoc+"^"+toLoc+"^"+user+"^"+scg+"^"+status+"^"+remark+"^"+(tempFlag?'Y':'')+"^^^"+opaId;
	
	//子表明细
	var data = "";
	var count= InRequestGrid.getStore().getCount();
	for(var index=0;index<count;index++){
		var rec = InRequestGridDs.getAt(index);	
		//新增或数据发生变化时执行下述操作
		if(rec.data.newRecord || rec.dirty){
			var inc = rec.data['inci'];
			var qty = rec.data['qty'];
			var colRemark=rec.data['remark'];
			var SpecDesc=rec.data['SpecDesc'];
			var repLev=rec.data['repLev'];
			var provloc=rec.data['provloc'];
			var provlocid=rec.data['provlocid'];
			if (repLev!=""&repLev!=null&repLev!=0){repLev=qty%repLev;}
			if((inc!="")&&(inc!=null)){
				if(qty==0){
					Msg.info("warning","第"+(InRequestGridDs.indexOf(rec)+1)+"行申领数量不能为空或0!");
					return;
				}
				if(qty<0){
					Msg.info("warning","第"+(InRequestGridDs.indexOf(rec)+1)+"行申领数量不能小于0!");
					return;
				}
				if(provloc==""||provloc==null){
					Msg.info("warning","第"+(InRequestGridDs.indexOf(rec)+1)+"行供应仓库为空!");
					return;
				}
				var Creqparams=GetAppPropValue("DHCSTINREQM",provlocid);
				if((repLev!=""&repLev!=null&repLev!=0)&&(Creqparams.IfAllowReqBQtyUsed=="Y")){
					Msg.info("warning","第"+(InRequestGridDs.indexOf(rec)+1)+"行申领数量不是请求基数的整数倍!");
					return;
				}
				var tmp = rec.data['rowid']+"^"+inc+"^"+rec.data['uom']+"^"+qty+"^"+colRemark+"^"+scg+"^"+SpecDesc;
				if(data==""){
					data = tmp;
				}else{
					data = data+xRowDelim()+tmp;
				}
			}
		}
	}
	if(comp=="Y"){
	if ( (req=='')&& (data=="")) {return false;};	
	if(!IsFormChanged(formPanel) && data==""){return false;};	
	}
	else
	{
	if ( (req=='')&& (data=="")) {Msg.info("error", "没有内容需要保存!");return false;};	
	if(!IsFormChanged(formPanel) && data==""){Msg.info("error", "没有内容需要保存!");return false;};	
	}
	Ext.Ajax.request({
		url : 'dhcstm.inrequestaction.csp?actiontype=save',
		params:{req:req,reqInfo:reqInfo,data:data},
		method : 'POST',
		waitMsg : '保存中...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "保存成功!");
				req = jsonData.info;
				refresh(req);
				temStore.load()
			}else{
				if(jsonData.info==-1){
					Msg.info("error", "主表保存失败!");
				}else if(jsonData.info==-99){
					Msg.info("error", "主表加锁失败!");
				}else if(jsonData.info==-2){
					Msg.info("error", "主表解锁失败!");
				}else if(jsonData.info==-5){
					Msg.info("error", "明细保存失败!");
				}else if(jsonData.info==-4){
					Msg.info("error", "主表单号设置失败!");
				}else if(jsonData.info==-3){
					Msg.info("error", "主表保存失败!");
				}else{
					Msg.info("error", "保存失败!");
				}
			}
		},
		scope : this
	});
	complete.enable();
	add.enable();
}

var save = new Ext.ux.Button({
	text:'保存',
	id:'save',
	tooltip:'保存',
	iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		var templateFlag=Ext.getCmp('template').getValue();
		saveReq(templateFlag);
	}
});

var findTemplate = new Ext.Toolbar.Button({
	text:'模板编辑',
	id:'findTemplate',
	iconCls:'page_gear',
	tooltip:'查看并编辑模板',
	width : 70,
	height : 30,
	handler:function(){
		findReqTemplateWin(Ext.getCmp('reqType').getValue(),"");
	}
});

var ReqByTemplate=new Ext.Toolbar.Button({
	text:'模板制单',
	id:'reqByTemplate',
	iconCls:'page_add',
	tooltip:'根据模板制单',
	width : 70,
	height : 30,
	handler:function(){
		xReqByTemplateWin(Ext.getCmp('reqType').getValue(),"");
	}
});

function refresh(req){
	Select(req);
	InRequestGridDs.removeAll();
	InRequestGridDs.load({params:{start:0,limit:999,sort:'rowid',dir:'desc',req:req}});
}

function importReqTem(req){
	byTemplate=true;
	//清除formPanel上控制赋值
	clearReq();
	SetFormOriginal(formPanel);
	Ext.Ajax.request({
		url : 'dhcstm.inrequestaction.csp?actiontype=select&ReqId='+req,
		method : 'POST',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				var data=jsonData.info;
				if(data.length>0){
					var dataArr=data.split("^");
					addComboData(Ext.getCmp('LocField').getStore(),dataArr[2],dataArr[13]);
					Ext.getCmp('LocField').setValue(dataArr[2]); 
					//Ext.getCmp('userField').setValue(dataArr[14]); 
					Ext.getCmp('reqType').setValue(dataArr[5]);
				}
			}
		}
	});
	
	InRequestGridDs.removeAll();
	InRequestGridDs.load({params:{start:0,limit:999,sort:'rowid',dir:'desc',req:req}});
}

function Select(reqid){
	if(reqid==null || reqid==''){
		return;
	}
	req=reqid;
	Ext.Ajax.request({
		url : 'dhcstm.inrequestaction.csp?actiontype=select&ReqId='+reqid,
		method : 'POST',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				var data=jsonData.info;
				if(data.length>0){
					var dataArr=data.split("^");
					Ext.getCmp('requestNumber').setValue(dataArr[1]);
					addComboData(Ext.getCmp('LocField').getStore(),dataArr[2],dataArr[13]);
					Ext.getCmp('LocField').setValue(dataArr[2]);
					Ext.getCmp('dateField').setValue(dataArr[6]);
					Ext.getCmp('timeField').setValue(dataArr[9]);
					Ext.getCmp('userField').setValue(dataArr[14]);
					Ext.getCmp('template').setValue(dataArr[18]=='Y'?true:false);
					Ext.getCmp('reqType').setValue(dataArr[17]);
					Ext.getCmp("completeCK").setValue(dataArr[11]=="Y");
					Ext.getCmp("completeCK").fireEvent('check',Ext.getCmp("completeCK"),(dataArr[11]=="Y"));
					Ext.getCmp('remark').setValue(handleMemo(dataArr[10],xMemoDelim()));
					SetFormOriginal(formPanel);
					Ext.getCmp('template').setDisabled(true);
				}
			}
		},
		scope : this
	});
}

var complete = new Ext.Toolbar.Button({
	id:'complete',
	text:'确认完成',
	tooltip:'确认完成',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	disabled:true,
	handler:function(){
		if (req=='') 
		{
			Msg.info('warning','没有任何单据！');
			return ;
		}
		var templateFlag=Ext.getCmp('template').getValue();
		//确认完成时候保存
		saveReq(templateFlag,"Y");
		var statu=(Ext.getCmp('completeCK').getValue()==true?"Y":"N");
		if((statu=="N")||(statu=="")||(statu==null)){
			Ext.Ajax.request({
				url : 'dhcstm.inrequestaction.csp?actiontype=SetComp',
				params : {req : req},
				method : 'POST',
				waitMsg : '查询中...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "确认完成成功!");
						completeCK.setValue(true);
						Ext.getCmp("completeCK").fireEvent('check',Ext.getCmp("completeCK"),true);
					}else{
						if(jsonData.info==-2){
							Msg.info("error", "设置失败!");
						}else if(jsonData.info==-1){
							Msg.info("error", "加锁失败!");
						}else{
							Msg.info("error", "设置失败!");
						}
					}
				},
				scope : this
			});
		}
	}
});

var cancelComplete = new Ext.Toolbar.Button({
	text:'取消完成',
	tooltip:'取消完成',
	id:'cancelComp',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	disabled:true,
	handler:function(){
		if (req=='') 
		{
			Msg.info('warning','没有任何申领计划单！');
			return ;
		}
		var statu=(Ext.getCmp('completeCK').getValue()==true?"Y":"N");
		if(statu=="Y"){
			Ext.Ajax.request({
				url : 'dhcstm.inrequestaction.csp?actiontype=CancelComp',
				params : {req : req},
				method : 'POST',
				waitMsg : '查询中...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "取消完成成功!");
						completeCK.setValue(false);
						Ext.getCmp("completeCK").fireEvent('check',Ext.getCmp("completeCK"),false);
					}else{
						if(jsonData.info==-21){
							Msg.info("error", "已汇总提交申领计划,禁止取消完成!");
						}else if(jsonData.info==-1){
							Msg.info("error", "当前请求单已转为正式库存转移单,禁止取消完成!");
						}else if (jsonData.info==-11) {
							Msg.info("error", "当前请求单已审核,禁止取消完成!");
						}else if (jsonData.info==-99) {
							Msg.info("error", "加锁失败!");
						}else{
							Msg.info("error", "设置失败!"+jsonData.info);
						}
					}
				},
				scope : this
			});
		}
	}
});
var SplitPlan = new Ext.Toolbar.Button({
	text:'拆分计划单',
	tooltip:'拆分计划单',
	id:'SplitPlan',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	//disabled:true,
	handler:function(){
		if (req=='') 
		{
			Msg.info('warning','没有任何申领计划单！');
			return ;
		}
		var statu=(Ext.getCmp('completeCK').getValue()==true?"Y":"N");
		if(statu=="N"){
		    Msg.info('warning','计划单未完成！');
		    return ;
		}else if(statu=="Y"){
			Ext.Ajax.request({
				url : 'dhcstm.inrequestaction.csp?actiontype=SplitPlan',
				params : {req : req},
				method : 'POST',
				waitMsg : '查询中...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "计划单拆分成功!");
					}else{
						if (jsonData.info==-99) {
							Msg.info("error", "计划单已经拆分!");
						}else{
							Msg.info("error", "计划单拆分失败!");
						}
					}
				},
				scope : this
			});
		}
	}
});
function delReq()
{
	if(req==null || req==""){
		Msg.info("warning","请选择要删除的单!");
		return;
	}
	Ext.Msg.show({
		title:'提示',
		msg:'是否确定删除？',
		buttons:Ext.Msg.YESNO,
		icon: Ext.MessageBox.QUESTION,
		fn:function(b,txt){
			if (b=='yes'){
				Ext.Ajax.request({
					url:DictUrl+"inrequestaction.csp?actiontype=Delete",
					method:'POST',
					params:{req:req},
					success:function(response,opts){
						var jsonData=Ext.util.JSON.decode(response.responseText);
						
						if(jsonData.success=='true'){
							Msg.info("success","删除成功!");
							Ext.getCmp("clear").handler.call(Ext.getCmp("clear").scope);
						}else{
							if(jsonData.info==-1){
								Msg.info("warning","该申领计划单已完成，不允许删除！");
							}else{
								Msg.info("error","删除失败:"+jsonData.info);
							}
						}
					},
					failure:function(response,opts){
						Msg.info("error","server-side failure with status code："+response.status);
					}
				});
			}
		}
	});
}

var del = new Ext.Toolbar.Button({
	text:'删除',
	id:'delete',
	tooltip:'删除',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		delReq();
	}
});

var printBT = new Ext.Toolbar.Button({
	text : '打印',
	tooltip : '打印申领计划单',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		if(req==null || req==""){
			Msg.info("warning","没有需要打印的申领计划单!");
			return;
		}
		if((gParam[6]=="N")&&(Ext.getCmp('completeCK').getValue()==false)){
			Msg.info('warning','不允许打印未完成的请求单!');
			return;
		}
		PrintINRequest(req);
	}
});

//删除转移申领计划明细
function DeleteDetail(){
	if ((req!="")&&(Ext.getCmp('completeCK').getValue()==true))
	{
		Msg.info('warning','当前申领计划单已完成');
		return;
	}
	
	var cell = InRequestGrid.getSelectionModel().getSelectedCell();
	if(cell==null){
		Msg.info("error","请选择数据!");
		return false;
	}
	else{
		var record = InRequestGridDs.getAt(cell[0]);
		var reqItm = record.get("rowid");
		if(reqItm!=""){
			Ext.MessageBox.confirm('提示','确定要删除该记录?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url : 'dhcstm.inrequestaction.csp?actiontype=del&reqItm='+reqItm,
							waitMsg:'删除中...',
							failure: function(result, request) {
								Msg.info("error", "请检查网络连接!");
								return false;
							},
							success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
									InRequestGridDs.load({params:{start:0,limit:999,sort:'rowid',dir:'desc',req:req}});
								}else{
									if(jsonData.info==-1){
										Msg.info("error", "明细Id为空，删除失败!");
										return false;
									}else if(jsonData.info==-2){
										Msg.info("error", "不允许删除!");
										return false;
									}else{
										Msg.info("error", "删除失败!");
										return false;
									}
								}
							},
							scope: this
						});
					}else{
						return false;
					}
				}
			)
		}else{
			InRequestGridDs.remove(record);
			InRequestGrid.getView().refresh();
		}
	}
}

var AddDetailBT=new Ext.Button({
	text:'增加一条',
	tooltip:'点击增加',
	iconCls:'page_add',
	height : 30,
	width : 70,
	handler:function(){
		var toLoc = Ext.getCmp('LocField').getValue(); 
		if((toLoc=="")||(toLoc==null)){
			Msg.info("warning", "请选择申领部门!");
			return ;
		}
		addNewRow();
	}
})
var DelDetailBT=new Ext.Button({
	text:'删除一条',
	tooltip:'',
	iconCls:'page_delete',
	height : 30,
	width : 70,
	handler:function()
	{
		DeleteDetail();
	}
})

var GridColSetBT = new Ext.Toolbar.Button({
	text:'列设置',
	tooltip:'列设置',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		GridColSet(InRequestGrid,"DHCSTINREQM");
	}
});
var HelpBT = new Ext.ux.Button({
	text:'帮助与使用说明（F1)',
	tooltip:'帮助与使用说明（F1)',
	iconCls:'page_gear',
	key:Ext.EventObject.F1,
	ctrl:false,
	alt:false,
	handler:function(){
		window.onhelp = function(){return false;}
		Msg.info("warning","处理中");
	}
});
//表格
InRequestGrid = new Ext.grid.EditorGridPanel({
	region:'center',
	id:'InRequestGrid',
	title:'申领计划单',
	store:InRequestGridDs,
	cm:InRequestGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	tbar:[AddDetailBT,'-',DelDetailBT,'-',GridColSetBT],
	listeners : {
		beforeedit : function(e){
			if(Ext.getCmp('completeCK').getValue()==true){
				return false;
			}
		},
		afteredit : function(e){
			if(e.field == 'qty'){
				e.record.set("spAmt",accMul(e.value, e.record.get('sp')));
				e.record.set("rpAmt",accMul(e.value, e.record.get('rp')));
			}
		}
	}
});

//zdm,增加右键删除明细功能
InRequestGrid.addListener("rowcontextmenu",function(grid,rowindex,e){
	e.preventDefault();
	rightClickMenu.showAt(e.getXY());
});

var rightClickMenu=new Ext.menu.Menu({
	id:'rightClickMenu',
	items:[{id:'mnuDelete',text:'删除',handler:DeleteDetail}]
});

var formPanel = new Ext.form.FormPanel({
	labelAlign : 'right',
	title:'申领计划制单',
	region:'center',
	frame : true,
	bodyStyle : 'padding:5px;',
	tbar:[find,'-',add,'-',save,'-',del,'-',complete,'-',cancelComplete,'-',clear,'-',printBT,'-',findTemplate,'-',ReqByTemplate],
	items : [{
		layout : 'column',
		xtype : 'fieldset',
		title : '申领计划信息',
		style:'padding:5px 0px 0px 0px',
		defaults:{border:false},
		items : [{
			columnWidth:0.3,
			xtype:'fieldset',
			items : [LocField,reqType,requestNumber]
		},{
			columnWidth : 0.25,
			xtype:'fieldset',
			items : [dateField,timeField,userField]
		},{
			columnWidth : 0.25,
			xtype:'fieldset',
			items : [remark]
		},{
			columnWidth : 0.2,
			xtype:'fieldset',
			items : [completeCK,templateFlag]
		}]
	}]
});

//查看请求单数据是否有修改
function isDataChanged()
{
	var changed=false;
	var count1= InRequestGrid.getStore().getCount();
	//看主表数据是否有修改
	//修改为主表有修改且子表有数据时进行提示
	if((IsFormChanged(formPanel))&&(count1!=0))
	{
		changed = true;	
	}
	if (changed) return changed;
	//看明细数据是否有修改
	var count= InRequestGrid.getStore().getCount();
	for(var index=0;index<count;index++){
		var rec = InRequestGridDs.getAt(index);	
				//新增或数据发生变化时执行下述操作
	    if(rec.data.newRecord || rec.dirty){
			changed = true;
		}
	}
	return changed;
}

var temCm=new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
	{
		header:'req',
		dataIndex:'req',
		hidden:true
	},{
		header:"模板名称(备注)",
		dataIndex:'Remark',
		width:150
	}
]);
var temStore=new Ext.data.Store({
		url:URL+'?actiontype=GetTemplate',
		autoLoad:true,
		baseParams:{
					locId:Ext.getCmp('LocField').getValue(),
					reqType:Ext.getCmp('reqType').getValue(),
					HVflag:''
				},
		reader:new Ext.data.JsonReader({
			totalProperty:'result',
			root:'rows',
			fields:['req','reqNo','Date','Time','User','Remark','completed']
		})
	});
var temGrid=new Ext.grid.GridPanel({
	title:'模版',
	region:'east',
	width:180,
	store:temStore,
	cm:temCm,
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
	deferRowRender : false,
	listeners:{
		'rowdblclick':function(Grid ,rowIndex ,e){
			var record=Grid.getStore().getAt(rowIndex);
			var req=record.get("req");
			importReqTem(req);
		}
	}
});	
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var panel=new Ext.Panel({
		region:'north',
		height:210,
		layout:'border',
		items:[formPanel,temGrid]
	})
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[panel,InRequestGrid]
	});
	
	RefreshGridColSet(InRequestGrid,"DHCSTINREQM");   //根据自定义列设置重新配置列
});