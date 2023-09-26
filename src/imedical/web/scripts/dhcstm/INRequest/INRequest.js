// 名称:出库请求
// 编写日期:2012-07-19
var gGroupId=session['LOGON.GROUPID'];
var abConsumeReq = reqByabConsume;		//页面跳转变量
var CtLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];
var gHospId=session['LOGON.HOSPID'];
var URL = 'dhcstm.inrequestaction.csp';
var req = "";		//定义全局变量:主表rowid
var defaReqType="O";
var byTemplate=false;	//根据模板制单标志

gHVInRequest = typeof(gHVInRequest)=='undefined'?false:gHVInRequest;		//2016-04-29 添加高值标志
//取高值管理参数
var UseItmTrack="";
if(gItmTrackParam.length<1){
	GetItmTrackParam();
	UseItmTrack=gItmTrackParam[0]=='Y'?true:false;
}

if(gParam.length<1){
		GetParam();  //初始化参数配置
	}
var requestNnmber = new Ext.form.TextField({
	id:'requestNnmber',
	fieldLabel:'请求单号',
	listWidth:150,
	anchor:'90%',
	selectOnFocus:true,
	disabled:true
});

// 请求部门
var LocField= new Ext.ux.LocComboBox({
	fieldLabel : '请求部门',
	id : 'LocField',
	name : 'LocField',
	anchor:'90%',
	emptyText : '请求部门...',
	groupId:gGroupId,
	protype : INREQUEST_LOCTYPE,
	linkloc:CtLocId,
	listeners:{
		'select':function(cb){
			var requestLoc=cb.getValue();
			var defprovLocs=tkMakeServerCall("web.DHCSTM.DHCTransferLocConf","GetDefLoc",requestLoc,gGroupId)
			var mainArr=defprovLocs.split("^");
			var defprovLoc=mainArr[0];
			var defprovLocdesc=mainArr[1];
			if(!Ext.isEmpty(defprovLoc) && !Ext.isEmpty(defprovLocdesc)){
				addComboData(Ext.getCmp('supplyLocField').getStore(),defprovLoc,defprovLocdesc);
				Ext.getCmp("supplyLocField").setValue(defprovLoc);
				var provLoc=Ext.getCmp('supplyLocField').getValue();
				Ext.getCmp("groupField").setFilterByLoc(requestLoc,provLoc);
			}
		}
	}
	//defaultLoc:{}    //默认值为空
});

//类组
var groupField = new Ext.ux.StkGrpComboBox({
	id:'groupField',
	StkType:App_StkTypeCode,
	LocId:CtLocId,
	anchor:'90%',
	UserId:UserId
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
	params:{LocId:'LocField'},
	filterName : 'FilterDesc',
	listeners:{
		'select':function(cb){
			var provLoc=cb.getValue();
			var requestLoc=Ext.getCmp('LocField').getValue();
			Ext.getCmp("groupField").setFilterByLoc(requestLoc,provLoc);
		}
	}
});

var remark = new Ext.form.TextArea({
	id:'remark',
	fieldLabel:'备注',
	anchor:'90%',
	height:100,
	selectOnFocus:true
});
function startedit (row, colIndex){
	InRequestGrid.startEditing(row, colIndex);
	}
var completeCK = new Ext.form.Checkbox({
	id: 'completeCK',
	boxLabel : '完成',
	hideLabel : true,
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
	boxLabel : '模板标志',
	hideLabel : true,
	anchor:'100%',
	allowBlank:true
});
//20180914
var ExpressFlag=new Ext.form.Checkbox({
	id: 'ExpressFlag',
	boxLabel : '送货标志',
	hideLabel : true,
	anchor:'100%',
	allowBlank:true
});
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
	var frLoc = Ext.getCmp('supplyLocField').getValue();
	var params=gGroupId+"^"+LocId+"^"+UserId+"^"+uom+"^"+frLoc;
	GetItmInfo(inci,params,record);
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
	listWidth : 250,
	valueNotFoundText : '',
	listeners:({
		'beforequery':function()

			{	var cell = InRequestGrid.getSelectionModel().getSelectedCell();
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
	data:[['O','临时请求'],['C','申领计划']]
})
var reqType=new Ext.form.ComboBox({
	id:'reqType',
	fieldLabel:'请求单类型',
	store:TypeStore,
	valueField:'RowId',
	displayField:'Description',
	value : 'O',
	triggerAction:'all',
	anchor:'90%',
	minChars:1,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	mode:'local',
	disabled:true
});
///取请求应用的参数值
var appname="DHCSTINREQM";
var proloc=Ext.getCmp('supplyLocField').getValue();
var reqparams=GetAppPropValue(appname,proloc);   //请求模块应用参数对象

var find = new Ext.Toolbar.Button({
	text:'查询',
    tooltip:'查询',
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
						findRec(refresh);
					}
				}
			})
		} else {
			findRec(refresh);
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

function clearReq()
{
	req="";
	InRequestGridDs.removeAll();
	remark.setValue("");
	requestNnmber.setValue("");  //groupField
	dateField.setValue(new Date());
	completeCK.setValue(false);
	del.enable();
	groupField.setValue("");
	groupField.setRawValue("");
	timeField.setValue("");
	userField.setValue("");
	reqType.setValue("");
	reqType.setValue(defaReqType)  //设置初始
	Ext.getCmp('template').setValue(false);
	Ext.getCmp('template').setDisabled(false);
	Ext.getCmp('ExpressFlag').setValue(false);
	Ext.getCmp('save').enable();
	add.setDisabled(false);
	
	if(!Ext.isEmpty(LocField.protype)){
		//Ext.getCmp('LocField').setValue("");  //申请科室使用关联科室,清除会显示登陆科室
		LocField.getStore().reload();
	}else{
		SetLogInDept(LocField.getStore(),'LocField');
	}
	supplyLocField.setValue("");
	groupField.store.load();
	setEditEnable();
	//清空csp传进的变量
	if(reqByabConsume>0){
		location.href="dhcstm.inrequest.csp";
	}
}

function changeBgColor(row, color) {
	InRequestGrid.getView().getRow(row).style.backgroundColor = color;
}

function getDrugList2(records) {
	records = [].concat(records);
	if (records == null || records == "") {
	return;
	}
	Ext.each(records,function(record,index,allItems){
		var inciDr = record.get("InciDr");
		var findIndex = InRequestGridDs.findExact('inci',inciDr);
		if(findIndex>=0){
			changeBgColor(findIndex,"yellow");
			Msg.info("warning",record.get("InciDesc")+"已存在于第"+(findIndex+1)+"行!");
			return;
		}
		var cell = InRequestGrid.getSelectionModel().getSelectedCell();
		// 选中行
		var row = cell[0];
		var rowData = InRequestGridDs.getAt(row);
		rowData.set("inci",record.get("InciDr"));
		rowData.set("code",record.get("InciCode"));
		rowData.set("desc",record.get("InciDesc"));
		rowData.set("spec",record.get("Spec"));
		rowData.set("stkQty",record.get("PAvaQty"));		//PuomQty
		rowData.set("reqPuomQty",record.get("reqPuomQty"));
		rowData.set("inciRemarks",record.get("remarks"));

		//供应商id^供应商名称^厂商id^厂商名称^配送商id^配送商名称^入库单位id^入库单位^进价^售价^申购科室库存量^库存上限^库存下限^通用名^商品名^剂型^规格
		//{success:'true',info:'7^GAYY-北京广安医药联合中心^61^bjymzy-北京益民制药厂^^^26^盒[20片]^0^0^0^^^艾司唑仑片^^普通片剂^[1mg*20]'}
		//取其它物资信息

		var locId = Ext.getCmp('LocField').getValue();
		if(locId!=""){
			var uom="";
			var frLoc = Ext.getCmp('supplyLocField').getValue();
			var params=gGroupId+"^"+locId+"^"+UserId+"^"+uom+"^"+frLoc
			GetItmInfo(record.get("InciDr"),params,rowData)
		}else{
			Msg.info("error","请选择科室!");
		}

		addNewRow()
	})
	var colIndex=GetColIndex(InRequestGrid,"qty");
	if (!InRequestGrid.getColumnModel().isHidden(colIndex)){
	var count=InRequestGridDs.getCount()
		var row
		for(i=0;i<count;i++){
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
		addComboData(ItmUomStore,data[2],data[3]);
		rowData.set("uom", UomId);
		rowData.set("sp", data[5]);
		rowData.set("rp", data[4]);
		rowData.set("spAmt",accMul(Number(rowData.get('qty')),Number(rowData.get('sp'))));
		rowData.set("rpAmt",accMul(Number(rowData.get('qty')),Number(rowData.get('rp'))));
		rowData.set("repLev", data[10]);
	}
}

function GetPhaOrderInfo2(item, group) {
	if (item != null && item.length > 0) {
		//供给部门
		var frLoc = Ext.getCmp('supplyLocField').getValue();
		//请求部门
		var toLoc = Ext.getCmp('LocField').getValue();
		var HV = gHVInRequest?'Y':UseItmTrack?'N':'';
		var frLocInRequestParamObj=GetAppPropValue('DHCSTINREQM',frLoc); ///依据库房判断
		var QtyFlag = (frLocInRequestParamObj.QtyFlag && frLocInRequestParamObj.QtyFlag =='Y') ? '1' : '0';
		GetPhaOrderWindow(item, group, App_StkTypeCode, frLoc, "N",
			QtyFlag, gHospId,getDrugList2,toLoc,"",
			"","","O","N","Y",
			"",HV,gParam[7]);
	}
}

function addNewRow() {
	if ((req!="")&&(Ext.getCmp('completeCK').getValue()==true))
	{
		Msg.info('warning','当前请求单已完成');
		return;
	}
	var rowCount =InRequestGrid.getStore().getCount();
	if(rowCount==0 || InRequestGridDs.getAt(rowCount - 1).get("inci")!=''){
		var defaData = {};
		var NewRecord = CreateRecordInstance(InRequestGridDs.fields,defaData);
		InRequestGridDs.add(NewRecord);
	}
	var colIndex=GetColIndex(InRequestGrid,"desc");
	if (!InRequestGrid.getColumnModel().isHidden(colIndex)){
		InRequestGrid.getSelectionModel().select(InRequestGridDs.getCount() - 1, colIndex);
		InRequestGrid.startEditing(InRequestGridDs.getCount() - 1, colIndex);
	}
	setEditDisable();
}

var InRequestGrid="";
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
		{name:'SpecDesc'},
		{name:'manf'},
		{name:'sp'},
		{name:'spAmt'},
		{name:'remark'},
		{name:'stkQty'},
		{name:'inciRemarks'},
		{name:'reqPuomQty'}
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
						var stkGrp=Ext.getCmp("groupField").getValue();
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
        header:"供方可用库存数",
        dataIndex:'stkQty',
        width:100,
        align:'right',
        sortable:true
	},{
        header:"请领基数",
        dataIndex:'repLev',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"请求数量",
        dataIndex:'qty',
        id:'colQty',
		xtype:'numbercolumn',
		//format:'0',
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
						var itm=InRequestGridDs.getAt(cell[0]).get('inci');
						if (itm=='') {return;}
						var repLev = InRequestGridDs.getAt(cell[0]).get('repLev');
						var stkQty = InRequestGridDs.getAt(cell[0]).get('stkQty');
						if (repLev!=""&repLev!=null&repLev!=0){repLev=qty%repLev;}
						if ((repLev!=""&repLev!=null&repLev!=0)&&(reqparams.IfAllowReqBQtyUsed=="Y")){
							Msg.info("error", "请求数量需要是请求基数的整数倍!");
							return;
						}else if ((gParam[8]!="Y")&&((qty-stkQty)>0)){
							Msg.info("error", "请求数量不可以大于库存数!");
							return;
						}else{
							var colIndex=GetColIndex(InRequestGrid,"qty");
							if (!InRequestGrid.getColumnModel().isHidden(colIndex)){
								var count=InRequestGridDs.getCount();
								var row;
								for(i=0;i<count;i++){
									if(Ext.isEmpty(InRequestGridDs.getAt(i).get('qty'))){row=i;break;}
								}
								if (row>=0){
									if(Ext.isEmpty(InRequestGridDs.getAt(row).get('inci'))){
										colIndex=GetColIndex(InRequestGrid,"desc");
									}
									InRequestGrid.getSelectionModel().select(row, colIndex);
									startedit.defer(20,this,[row, colIndex]);  /////延时处理下   防止和grid的事件冲突导致startEditing失败的问题
								}
							}else{
								addNewRow();
							}
						}
					}
					else if(e.getKey() == Ext.EventObject.DOWN)	{
						var cs=InRequestGrid.getSelectionModel();
						var ss=cs.getSelectedCell () ;
						var row=ss[0];
						var col=ss[1];
						var cnt=InRequestGrid.store.getCount();
						if ((row+1)<cnt){
							cs.select(row+1,col,'',false);
							InRequestGrid.startEditing(row+1,col);
						}
						
					}
					else if (e.getKey() == Ext.EventObject.UP)	{
						var colIndex=GetColIndex(InRequestGrid,"qty");
						var cs=InRequestGrid.getSelectionModel();
						var ss=cs.getSelectedCell () ;
						var row=ss[0];
						var col=ss[1];
						if (row>0){
							cs.select(row-1,col,'',false);
							InRequestGrid.startEditing(row-1,col);
						}
					}
				}
			}
        })
    },{
        header:"零售单价",
        dataIndex:'sp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"售价金额",
        dataIndex:'spAmt',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"单位",
        dataIndex:'uom',
        width:100,
        align:'left',
        sortable:true,
        editor : new Ext.grid.GridEditor(CTUom),
		renderer : Ext.util.Format.comboRenderer2(CTUom,"uom","uomDesc")
    },{
        header:"请求备注",
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
							Msg.info("error","请求数量不能为0!");

							var colIndex=GetColIndex(InRequestGrid,"qty");
							if (!InRequestGrid.getColumnModel().isHidden(colIndex))
							{
								InRequestGrid.startEditing(InRequestGridDs.getCount() - 1, colIndex);
							}
							return false;
						}else{
							//增加一行
							addNewRow();
						}
					}
				}
			}
        })
    },{
        header:"物资备注",
        dataIndex:'inciRemarks',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"具体规格",
        dataIndex:'SpecDesc',
        width:100,
        align:'left',
        sortable:true,
        editor : new Ext.grid.GridEditor(Specom),
        renderer : Ext.util.Format.comboRenderer2(Specom,"SpecDesc","SpecDesc")
    },{
        header:"本科室库存数",
        dataIndex:'reqPuomQty',
        width:100,
        align:'right',
        sortable:true
	}
]);

var add = new Ext.Toolbar.Button({
	text:'新建',
	id:'newReq',
	iconCls:'page_add',
    tooltip:'新建库存转移请求单',
	width : 70,
	height : 30,
	handler:function(){
		if (isDataChanged()){
			Ext.Msg.show({
				title:'提示',
				msg: '已经对该单数据做了修改，继续执行将丢失掉修改，继续吗？',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
			   		if (btn=='yes') {clearReq();}
			   }
			})
		}
		else {
			clearReq();
		}
	}
});

function CheckBefore(tempFlag){
	if (tempFlag){
		var remark=Ext.getCmp('remark').getValue();
		var xx=remark.trim();
		if ((xx=="")||(xx==null)){
			Msg.info('error',"请在<备注>填写模板名称。");
			return;
		}
	}
	//主表信息
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
	if(frLoc == toLoc){
		Msg.info("warning", "请求部门和供应部门不能相同!");
		return;
	}
	//登陆用户
	var user = UserId;
	//类组
	var scg = Ext.getCmp('groupField').getValue();
	if(Ext.isEmpty(scg) && gParam[5]!='Y'){
		Msg.info("error", "请选择类组!");
		return false;
	}
	//完成标志(暂时为空)
	var status =Ext.getCmp('reqType').getValue();
	//备注
	var remark = Ext.getCmp('remark').getValue();
	remark=remark.replace(/\r/g,'').replace(/\n/g,xMemoDelim());
	var ExpressFlag=Ext.getCmp('ExpressFlag').getValue()?'Y':'N';
	//主表信息字符串
	var reqInfo = frLoc+"^"+toLoc+"^"+user+"^"+scg+"^"+status+"^"+remark+"^"+(tempFlag?'Y':'')+"^^^^"+ExpressFlag;
	if(RowDelim==null){
		Msg.info("error", "行分隔符有误，不能保存!");
		return false;
	}
	if(InRequestGrid.activeEditor != null){
		InRequestGrid.activeEditor.completeEdit();
	}
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
			var stkqty=rec.data['stkQty'];
			if (repLev!=""&repLev!=null&repLev!=0){repLev=qty%repLev;}
			if((inc!="")&&(inc!=null)){
				if(qty==0){
					Msg.info("warning","第"+(InRequestGridDs.indexOf(rec)+1)+"行请求数量不能为空或0!");
					return;
				}
				if((repLev!=""&repLev!=null&repLev!=0)&&(reqparams.IfAllowReqBQtyUsed=="Y")){
					Msg.info("warning","第"+(InRequestGridDs.indexOf(rec)+1)+"行请求数量不是请求基数的整数倍!");
					return;
				}
				if((gParam[8]!="Y")&&((qty-stkqty)>0)){
					Msg.info("warning","第"+(InRequestGridDs.indexOf(rec)+1)+"行请求数量不能大于库存数!");
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
	if ( (req=='')&& (data=="")) {Msg.info("error", "没有内容需要保存!");return false;};
	if(!IsFormChanged(formPanel) && data==""){Msg.info("error", "没有内容需要保存!");return false;};
	saveReq(req,reqInfo,data);
    /*
    Ext.Ajax.request({
		url : 'dhcstm.inrequestaction.csp?actiontype=ChecklimitReqDetail',
		params:{ListDetail:data,LocId:toLoc},
		method : 'POST',
		waitMsg : '查询中...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				var responseText22=jsonData.info;
				if(responseText22!=0){
                   var res=responseText22.split("^");
                   for (var ii=0;ii<res.length;ii++){
                       changeBgColor(res[ii]-1, "yellow");
                   }
                   Msg.info("warning", "变色行数量大于本科室月限制数量，请下月制单或联系库房!");
                   return false;
        
                }else{
	                saveReq(req,reqInfo,data);
                }
			}
		},
		scope : this
	});*/
	
}


function saveReq(req,reqInfo,data){
    
	Ext.Ajax.request({
		url : 'dhcstm.inrequestaction.csp?actiontype=save',
		params:{req:req,reqInfo:reqInfo,data:data},
		method : 'POST',
		waitMsg : '查询中...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "保存成功!");
				req = jsonData.info;
				refresh(req);
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
		if(abConsumeReq>0){
			req = abConsumeReq;
		}
		//保存时传入三个字符串
		//1.主表rowid
		//2.主表的信息：frLoc、toLoc、user、scg、status、remark
		//3.子表明细信息：req、明细字符串rows(rows信息：reqi(明细rowid)、data(inci、uom、qty))
		var templateFlag=Ext.getCmp('template').getValue();
		CheckBefore(templateFlag);
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
		findReqTemplateWin(Ext.getCmp('reqType').getValue(),(gHVInRequest==true?'Y':'N'));
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
		xReqByTemplateWin(Ext.getCmp('reqType').getValue(),(gHVInRequest==true?'Y':'N'));
	}
});
function refresh(req){
	Select(req);
	InRequestGridDs.removeAll();
	InRequestGridDs.load({params:{start:0,limit:999,sort:'rowid',dir:'desc',req:req}});
}

function importReqTem(req,Reqdetailidstr){
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
					Ext.getCmp('userField').setValue(dataArr[14]);
					Ext.getCmp('reqType').setValue(dataArr[5]);
					addComboData(Ext.getCmp('supplyLocField').getStore(),dataArr[8],dataArr[12]);
					Ext.getCmp('supplyLocField').setValue(dataArr[8]);
					addComboData(groupField.getStore(),dataArr[15],dataArr[16],groupField);
					Ext.getCmp('groupField').setValue(dataArr[15]);
				}
			}
		}
	});

	InRequestGridDs.removeAll();
	InRequestGridDs.load({params:{start:0,limit:999,sort:'rowid',dir:'desc',req:req,Reqdetailidstr:Reqdetailidstr}});
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
					Ext.getCmp('requestNnmber').setValue(dataArr[1]);
					addComboData(Ext.getCmp('supplyLocField').getStore(),dataArr[8],dataArr[12]);
					Ext.getCmp('supplyLocField').setValue(dataArr[8]);
					addComboData(Ext.getCmp('LocField').getStore(),dataArr[2],dataArr[13]);
					Ext.getCmp('LocField').setValue(dataArr[2]);
					Ext.getCmp('dateField').setValue(dataArr[6]);
					Ext.getCmp('timeField').setValue(dataArr[9]);
					Ext.getCmp('userField').setValue(dataArr[14]);
					Ext.getCmp('reqType').setValue(dataArr[5]);
					addComboData(groupField.getStore(),dataArr[15],dataArr[16],groupField);
					Ext.getCmp('groupField').setValue(dataArr[15]);
					Ext.getCmp("completeCK").setValue(dataArr[11]=="Y");
					Ext.getCmp("completeCK").fireEvent('check',Ext.getCmp("completeCK"),(dataArr[11]=="Y"));
					Ext.getCmp('remark').setValue(handleMemo(dataArr[10],xMemoDelim()));
					Ext.getCmp('template').setValue(dataArr[18]=='Y'?true:false);
					Ext.getCmp('template').setDisabled(true);
					Ext.getCmp('ExpressFlag').setValue(dataArr[22]=='Y'?true:false);
					setEditDisable();
					SetFormOriginal(formPanel);
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
		if (req=='') {
			Msg.info('warning','没有任何请求单！');
			return ;
		}
		var rowCount = InRequestGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			changeBgColor(i, "white");
		}
		var count = 0;
		for (var i = 0; i < rowCount; i++) {
			var rowdata=InRequestGridDs.getAt(i);
			var UseLocLimitQty=InRequestParamObj.UseLocLimitQty;
			if(UseLocLimitQty=="Y"){
				var ReqLocid=Ext.getCmp("LocField").getValue();
				var inci=rowdata.get('inci');
				var Uomid=rowdata.get('uom');
				var Qty=rowdata.get('qty');
				var LimitQtyStr=tkMakeServerCall("web.DHCSTM.LocLimitAmt","GetLimitQty",ReqLocid,inci,Uomid);
				var OnceReqQty=Number(LimitQtyStr.split("^")[0]);
				var AddReqQty=Number(LimitQtyStr.split("^")[1]);
				var AllReqQty=Number(LimitQtyStr.split("^")[2]);
				if ((OnceReqQty>0)&&(Qty>OnceReqQty)){
					Msg.info("warning","单次申请数量不允许超过"+OnceReqQty);
					changeBgColor(i,"yellow");
					return false;
				}
				if ((AllReqQty>0)&&(AddReqQty>AllReqQty)){
					Msg.info("warning","本时间段内申请数量不允许超过"+AllReqQty);
					changeBgColor(i,"yellow");
					return false;
				}
			}
			var item = InRequestGridDs.getAt(i).get("inci");
			if (item != undefined && item !='') {
				count++;
			}
		}
		if (rowCount <= 0 || count <= 0) {
			Msg.info("warning", "请输入明细!");
			return false;
		}
		var statu=(Ext.getCmp('completeCK').getValue()==true?"Y":"N");
		if((statu=="N")||(statu=="")||(statu==null)){
			Ext.Ajax.request({
				url : 'dhcstm.inrequestaction.csp?actiontype=SetComp&req='+req,
				method : 'POST',
				waitMsg : '查询中...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "确认完成成功!");
				        refresh(req);
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
		if (req=='') {
			Msg.info('warning','没有任何请求单！');
			return ;
		}
		var statu=(Ext.getCmp('completeCK').getValue()==true?"Y":"N");
		if(statu=="Y"){
			Ext.Ajax.request({
				url : 'dhcstm.inrequestaction.csp?actiontype=CancelComp&req='+req,
				method : 'POST',
				waitMsg : '查询中...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "取消完成成功!");
						completeCK.setValue(false);
						Ext.getCmp("completeCK").fireEvent('check',Ext.getCmp("completeCK"),false);
					}else{
						if(jsonData.info==-2){
							Msg.info("error", "设置失败!"+jsonData.info);
						}else if(jsonData.info==-1){
							Msg.info("error", "当前请求单已转为正式库存转移单,禁止取消完成!");
						}else if (jsonData.info==-99) {
							Msg.info("error", "加锁失败!");
						}else if (jsonData.info==-11) {
							Msg.info("error", "已审核,禁止取消完成!");
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

function delReq()
{
	if(req==null || req==""){
		Msg.info("warning","请选择要删除的请求单!");
		return;
	}

	Ext.Msg.show({
		title:'提示',
		msg:'是否确定删除？',
		buttons:Ext.Msg.YESNO,
		icon: Ext.MessageBox.QUESTION,
		fn:function(b,txt){
			if (b=='no')	{return;}
			else
			{
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
								Msg.info("warning","该请求单已完成，不允许删除！");
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
	tooltip : '打印请求单',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		if(req==null || req==""){
			Msg.info("warning","没有需要打印的请求单!");
			return;
		}
		if((gParam[6]=="N")&&(Ext.getCmp('completeCK').getValue()==false)){
			Msg.info('warning','不允许打印未完成的请求单!');
			return;
		}
		PrintINRequest(req);
	}
});

//删除转移请求明细
function DeleteDetail(){
	if ((req!="")&&(Ext.getCmp('completeCK').getValue()==true))
	{
		Msg.info('warning','当前请求单已完成');
		return;
	}

	var cell = InRequestGrid.getSelectionModel().getSelectedCell();
	if(cell==null){
		Msg.info("error","请选择数据!");
		return false;
	}else{
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

		if (InRequestGridDs.getCount()==0){
			setEditEnable();
		}
	}
}

//初始化默认排序功能
InRequestGridCm.defaultSortable = true;

var AddDetailBT=new Ext.Button({
	text:'增加一条',
	height : 30,
	width : 70,
	tooltip:'点击增加',
	iconCls:'page_add',
	handler:function(){
		var toLoc = Ext.getCmp('LocField').getValue();
		if((toLoc=="")||(toLoc==null)){
			Msg.info("warning", "请选择请求部门!");
			return ;
		}
		var frLoc = Ext.getCmp('supplyLocField').getValue();
		if((frLoc=="")||(frLoc==null)){
			Msg.info("warning", "请选择供给部门!");
			return ;
		}
		if (toLoc == frLoc) {
			Msg.info("warning", "请求部门和供应部门不能相同!");
			return;
		}
		//类组
		var scg = Ext.getCmp('groupField').getValue();
		if(Ext.isEmpty(scg) && gParam[5]!='Y'){
			Msg.info("warning", "请选择类组!");
			return false;
		}
		addNewRow();
	}
})
var DelDetailBT=new Ext.Button({
	text:'删除一条',
	height : 30,
	width : 70,
	iconCls:'page_delete',
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

//表格
InRequestGrid = new Ext.grid.EditorGridPanel({
	region:'center',
	id:'reqItmEditGrid',
	title:'出库请求单',
	store:InRequestGridDs,
	cm:InRequestGridCm,
	trackMouseOver:true,
	stripeRows:true,
	region:'center',
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	tbar:[AddDetailBT,'-',DelDetailBT,'-',GridColSetBT],
	listeners:{
		beforeedit:function(e){
			if(Ext.getCmp("completeCK").getValue()){
				return false;
			}
		},
		afteredit:function(e){
			if(e.field=='qty'){
				e.record.set('spAmt',accMul(e.value,e.record.get('sp')));
				var UseLocLimitQty=InRequestParamObj.UseLocLimitQty;
				if(UseLocLimitQty=="Y"){
					var ReqLocid=Ext.getCmp("LocField").getValue();
					var inci=e.record.get('inci');
					var Uomid=e.record.get('uom');
					var Qty=e.record.get('qty');
					var LimitQtyStr=tkMakeServerCall("web.DHCSTM.LocLimitAmt","GetLimitQty",ReqLocid,inci,Uomid);
					var OnceReqQty=Number(LimitQtyStr.split("^")[0]);
					var AddReqQty=Number(LimitQtyStr.split("^")[1]);
					var AllReqQty=Number(LimitQtyStr.split("^")[2]);
					if ((OnceReqQty>0)&&(Qty>OnceReqQty)){
						Msg.info("warning","单次申请数量不允许超过"+OnceReqQty);
						return false;
					}
					if ((AllReqQty>0)&&(AddReqQty>AllReqQty)){
						Msg.info("warning","本时间段内申请数量不允许超过"+AllReqQty);
						return false;
					}
				}
			}
		}
	}
});

//zdm,增加右键删除明细功能
InRequestGrid.addListener("rowcontextmenu",function(grid,rowindex,e){
	e.preventDefault();
	grid.getSelectionModel().select(rowindex,1);
	rightClickMenu.showAt(e.getXY());
});

var rightClickMenu=new Ext.menu.Menu({
	id:'rightClickMenu',
	items:[{id:'mnuDelete',text:'删除',handler:DeleteDetail}]
});

var formPanel = new Ext.ux.FormPanel({
	title:gHVInRequest?'出库请求制单(高值)':'出库请求制单',
	tbar:[find,'-',add,'-',save,'-',del,'-',complete,'-',cancelComplete,'-',clear,'-',printBT,'-',findTemplate,'-',ReqByTemplate],
	items : [{
		layout : 'column',
		xtype : 'fieldset',
		title : '请求单信息',
		style:'padding:5px 0px 0px 5px',
		defaults:{xtype:'fieldset',border:false},
		items : [{
			columnWidth:0.3,
			items : [LocField,supplyLocField,groupField,reqType]
		},{
			columnWidth : 0.25,
			items : [requestNnmber,dateField,timeField,userField]
		},{
			columnWidth : 0.25,
			items : [remark]
		},{
			columnWidth : 0.2,
			items : [completeCK,templateFlag,ExpressFlag]
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
				//新增或数据发?浠??敝葱邢率??僮?
		if(rec.data.newRecord || rec.dirty){
			changed = true;
		}
	}
	return changed;
}

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel, InRequestGrid]
	});

	RefreshGridColSet(InRequestGrid,"DHCSTINREQM");   //根据自定义列设置重新配置列
	//页面跳转来时 确认完成按钮的控制
	if(abConsumeReq>0){
		complete.enable();
		Select(abConsumeReq);
		InRequestGridDs.load({params:{start:0,limit:999,sort:'rowid',dir:'desc',req:abConsumeReq}});
	};

});

 ///设置可编辑组件的disabled属性
function setEditDisable(){
	Ext.getCmp('LocField').setDisabled(true);
	Ext.getCmp('groupField').setDisabled(true);
	Ext.getCmp('supplyLocField').setDisabled(true);
}
 ///放开可编辑组件的disabled属性
function setEditEnable(){
	Ext.getCmp('LocField').setDisabled(false);
	Ext.getCmp('groupField').setDisabled(false);
	Ext.getCmp('supplyLocField').setDisabled(false);
}


