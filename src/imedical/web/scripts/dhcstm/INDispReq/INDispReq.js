// 名称:物资请领
// 编写日期:2012-07-19
var gGroupId=session['LOGON.GROUPID'];
var CtLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];
var gHospId = session['LOGON.HOSPID'];
var URL = 'dhcstm.indispreqaction.csp';

//保存参数值的object
var InDispReqParamObj = GetAppPropValue('DHCINDISPREQM');

var strParam = "";
var INDispReqRowId = ""; //定义全局变量:主表rowid
var statu = "N"; //定义全局变量:完成状态(默认状态:N)

var dsrqNo = new Ext.form.TextField({
	id:'dsrqNo',
	fieldLabel:'请领单号',
	listWidth:150,
	anchor:'90%',
	selectOnFocus:true,
	disabled:true
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
	fieldLabel:'日期',
	anchor:'90%',
	value:new Date(),
	disabled:true
});

var timeField=new Ext.form.TextField({
	id:'timeField',
	disabled:true,
	anchor:'90%',
	fieldLabel:'时间'
});
var userField=new Ext.form.TextField({
	id:'userField',
	disabled:true,
	anchor:'90%',
	fieldLabel:'请领人'
});

var sublocField = new Ext.ux.LocComboBox({
	id:'sublocField',
	fieldLabel:'科室',
	anchor:'90%',
	listWidth:210,
	emptyText:'科室...',
	groupId:gGroupId,
	stkGrpId : 'groupField'
});

sublocField.on("select",function(cmb,rec,id ){
	add.disable();
});

var remark = new Ext.form.TextArea({
	id:'remark',
	fieldLabel:'备注',
	anchor:'90%',
	height:100,
	selectOnFocus:true,
	maxLength:40
});

var statusCombo=new Ext.form.ComboBox({
	fieldLabel:'状态',
	id:'reqStatus',
	anchor:'90%',
	mode:'local',
	disabled:true,
	store:new Ext.data.ArrayStore({
		id:0,
		fields: ['code','description'],
		data:[['C','已处理'],['O','待处理'],['X','已作废'],['R','已拒绝']]
	}),
	valueField:'code',
	displayField:'description',
	triggerAction: 'all',
	forceSelection : true
});

var completeCK = new Ext.form.Checkbox({
	id: 'completeCK',
	boxLabel : '完成',
	anchor:'90%',
	disabled:true,
	allowBlank:true,
	listeners : {
		check : function(checkbox,checked){
			Ext.getCmp("CancelDetailBT").setDisabled(!checked);
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

var find = new Ext.Toolbar.Button({
	text:'查询',
	tooltip:'查询',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		//find.btnEl.mask() 
		var subLoc=Ext.getCmp('sublocField').getValue();
		if ((subLoc==null)||(subLoc=='')){
			Msg.info('warning','请选择科室!');
			return;
		}
		if (isDataChanged()){
			Ext.Msg.show({
				title:'提示',
				msg: '已经对该单数据做了修改，继续执行将丢失掉修改，继续吗？',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
					if (btn=='yes') {
						clearReq();
						findDispReq(subLoc,refresh);
					}
				}
			});
		}else{
			findDispReq(subLoc,refresh);
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
		if (isDataChanged())
		{
			Ext.Msg.show({
				title:'提示',
				msg: '已经对该单数据做了修改，继续执行将丢失掉修改，继续吗？',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
					if (btn=='yes') {clearReq();SetFormOriginal(formPanel);}
				}
			})
		}
		else{
			clearReq(); 
			SetFormOriginal(formPanel);
		}
	}
});

function clearReq()
{
	INDispReqRowId="";  //公共变量值
	INDispReqGridDs.removeAll();
	remark.setValue("");
	dsrqNo.setValue("");  //groupField
	//sublocField.setValue("");
	//sublocField.setRawValue("");
	//dateField.setValue(new Date());
	dateField.setValue('');
	completeCK.setValue(false);
	del.enable();
	groupField.setValue("");
	groupField.setRawValue("");
	timeField.setValue("");
	userField.setValue("");
	//reqType.setValue("");
	byUser.setValue(true);
	byUserGrp.setValue(false);
	GrpList.setValue('');
	statusCombo.setValue('');
	
	Ext.getCmp('save').enable();
	add.setDisabled(false);
	//SetLogInDept(LocField.getStore(),'LocField');

	groupField.store.load();
	setEditEnable();
}

function getDrugLists(records) {
	if (records == null || records == "") {
		return false;
	}
	Ext.each(records,function(item, index, allItems){
		getDrugList2(item);
	});
	
	var count = INDispReqGridDs.getCount()
	var row;
	var col=GetColIndex(INDispReqGrid,'qty');
	for(i=0; i<count; i++){
		if(Ext.isEmpty(INDispReqGridDs.getAt(i).get('qty'))){
			row = i;
			break;
		}
	}
	INDispReqGrid.startEditing(row, col);
}

function getDrugList2(record) {
//	if (record == null || record == "") {
//		return false;
//	}
	var cell = INDispReqGrid.getSelectionModel().getSelectedCell();
	// 选中行
	var row = cell[0];
	var inciDr=record.get("InciDr");
	var findIndex=INDispReqGridDs.findExact('inci',inciDr,0);
	if(findIndex>=0 && findIndex!=row){
		Msg.info("warning",record.get("InciDesc")+"已存在于第"+(findIndex+1)+"行");
		return;
	}
	var rowData = INDispReqGridDs.getAt(row);
	rowData.set("inci",record.get("InciDr"));
	rowData.set("code",record.get("InciCode"));
	rowData.set("desc",record.get("InciDesc"));
	
	var locId = Ext.getCmp('sublocField').getValue();
	//var locId=session['LOGON.CTLOCID'] ;
	if(locId!=""){
		var url = 'dhcstm.indispreqaction.csp?actiontype=GetItmInfo&IncId='+ record.get("InciDr")+'&LocId='+locId;
		var result = ExecuteDBSynAccess(url);
		var jsonData = Ext.util.JSON.decode(result.replace(/\r/g,"").replace(/\n/g,""));
		if (jsonData.success == 'true') {
			var data=jsonData.info.split("^");
			var ManfId = data[2];
			var Manf = data[3];
			rowData.set("manf", data[3]);    //生产商
					
			var UomId=data[6];
			var Uom=data[7];
			addComboData(ItmUomStore,data[6],data[7]);
			rowData.set("uom", UomId);    //单位Id
			rowData.set("uomDesc", Uom);    //单位名称
			rowData.set("sp", data[9]);
			rowData.set("spec", data[11]);
			rowData.set("BUomId",data[12]);
			rowData.set("ConFac",data[13]);
		}
		var lastIndex=INDispReqGridDs.getCount()-1;
		if(INDispReqGridDs.getAt(lastIndex).get('inci')!=""){
			addNewRow();
		}else{
			var col=GetColIndex(INDispReqGrid,'desc');
			INDispReqGrid.startEditing(lastIndex,col);
		}
	}else{
		Msg.info("error","请选择科室!");
	}
}

function GetPhaOrderInfo2(item, group) {
	if (item != null && item.length > 0) {
		var LocId = Ext.getCmp("sublocField").getValue();
		//取其支配科室(defloc)
		LocId = tkMakeServerCall("web.DHCSTM.Common.UtilCommon","GetLeadLoc",LocId);
		GetPhaOrderWindow(item, group, App_StkTypeCode, LocId, "N",
			"1", gHospId,getDrugLists,"","",
			"","","","","Y");
	}
}

function addNewRow() {
	//alert(INDispReqRowId);
	//alert(Ext.getCmp('completeCK').getValue());	
	if ((INDispReqRowId!="")&&(Ext.getCmp('completeCK').getValue()==true))
	{
		Msg.info('warning','当前请领单已提交');
		return;
	}
	var col=GetColIndex(INDispReqGrid,'desc');
	// 判断是否已经有添加行
	var rowCount = INDispReqGrid.getStore().getCount();
	if (rowCount > 0) {
		var rowData = INDispReqGridDs.data.items[rowCount- 1];
		var data = rowData.get("inci");
		if (data == null || data.length <= 0) {
			INDispReqGrid.startEditing(INDispReqGridDs.getCount() - 1, col);
			return;
		}
	}
	
	var NewRecord = CreateRecordInstance(INDispReqGridDs.fields);
	INDispReqGridDs.add(NewRecord);
	INDispReqGrid.startEditing(INDispReqGridDs.getCount() - 1, col);
	
	setEditDisable();
}

//配置数据源
var INDispReqGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=SelDispReqItm',method:'GET'});
var INDispReqGridDs = new Ext.data.Store({
	proxy:INDispReqGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results'
		}, [
		{name:'rowid',mapping:'dsrqi'},
		{name:'inci'},
		{name:'code',mapping:'inciCode'},
		{name:'desc',mapping:'inciDesc'},
		{name:'spec'},
		{name:'manf'},		
		{name:'qty'},
		{name:'uom'},
		{name:'uomDesc'},
		{name:'sp'},
		{name:'spAmt'},
		{name:'remark'},
		"BUomId","ConFac","moveStatus"
	]),
	remoteSort:false
});

var uGroupList=new Ext.data.Store({
	url:"dhcstm.sublocusergroupaction.csp?actiontype=getGrpListByUser",
	reader:new Ext.data.JsonReader({
		totalProperty:'results',
		root:"rows"	,
		idProperty:'RowId'
	},['RowId','Description']),
	listeners:{
		'beforeload':function(ds){
			ds.setBaseParam('user',UserId);
			ds.setBaseParam('subloc',Ext.getCmp('sublocField').getValue());
			ds.setBaseParam('reqFlag',1);
		},
		'load':function(ds){
			if (ds.getCount()==1){
			var rec=ds.getAt(0);
			var grp=rec.get('RowId');
			if (GrpList){
				GrpList.setValue(grp);}
			}
		}
	}
});

var GrpList = new Ext.ux.ComboBox({
	fieldLabel:'专业组',
	id:'UserGrp',
	anchor : '90%',
	disabled:true,
	store:uGroupList,
	valueField:'RowId',
	displayField:'Description'
});

var byUserGrp=new Ext.form.Radio({
	name:'dispMode',
	id:'byUserGrpMode',
	boxLabel:'专业组领用',
	inputValue:0,
	listeners:{
		'check':function(b){
			if (b.getValue()==1) {
				Ext.getCmp('UserGrp').setDisabled(false);
				Ext.getCmp('UserGrp').getStore().load();
			}else{
				Ext.getCmp('UserGrp').setValue('');
				Ext.getCmp('UserGrp').setDisabled(true);
			}
		}
	}
})

var byUser=new Ext.form.Radio({
	name:'dispMode',
	id:'byUserMode',
	boxLabel:'个人领用',
	inputValue:1,
	checked:true
})

var selectDSRQMode=new Ext.form.RadioGroup
({
	id:'dsMode',
	fieldLabel:'请领方式',
	items:[byUserGrp,byUser]
})

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
	var cell = INDispReqGrid.getSelectionModel().getSelectedCell();
	var record = INDispReqGrid.getStore().getAt(cell[0]);
	var InciDr = record.get("inci");
	ItmUomStore.removeAll();
	ItmUomStore.load({params:{ItmRowid:InciDr}});
});

CTUom.on('select', function(combo) {
	var cell = INDispReqGrid.getSelectionModel().getSelectedCell();
	var rowData = INDispReqGrid.getStore().getAt(cell[0]);
	var seluom = combo.getValue();		//目前选择的单位id
	var BUom = rowData.get("BUomId");
	var qty = rowData.get('qty');
	if((qty=="")||(qty==null)){
		qty = 0;
	}

	var seluom=combo.getValue();
	var sp = rowData.get("sp"); //原售价
	var buom=rowData.get("BUomId");
	var confac=rowData.get("ConFac");
	var uom=rowData.get("uom");
	if(seluom!=uom){
		if(seluom!=buom){     //原单位是基本单位，目前选择的是入库单位
			rowData.set("sp", Number(sp).mul(confac));
			rowData.set("spAmt", Number(sp).mul(confac).mul(qty)); //零售金额
		}else{					//目前选择的是基本单位，原单位是入库单位
			rowData.set("sp", Number(sp).div(confac));
			rowData.set("spAmt", Number(sp).div(confac).mul(qty)); //零售金额
		}
	}
	rowData.set("uom", seluom);
});
		
//模型
var INDispReqGridCm = new Ext.grid.ColumnModel([
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
		sortable:true
	},{
		header:"物资名称",
		dataIndex:'desc',
		id:'colDesc',
		width:150,
		align:'left',
		sortable:true,
		editor:new Ext.grid.GridEditor(new Ext.form.TextField({
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
		}))
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
		header:"请领数量",
		dataIndex:'qty',
		id:'colQty',
		width:100,
		align:'right',
		sortable:true,
		editor:new Ext.form.NumberField({
			id:'qtyField',
			allowBlank:false,
			allowNegative:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = INDispReqGrid.getSelectionModel().getSelectedCell();
						var col=GetColIndex(INDispReqGrid,"remark");
						INDispReqGrid.startEditing(cell[0], col);
					}
				}
			}
		})
	},{
		header:"零售单价",
		dataIndex:'sp',
		width:100,
		align:'right',
		sortable:true,
		hidden:true
	},{
		header:"售价金额",
		dataIndex:'spAmt',
		width:100,
		align:'right',
		sortable:true,
		hidden:true
	},{
		header:"单位rowid",
		dataIndex:'uom',
		width:100,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"单位",
		dataIndex:'uom',
		width:100,
		align:'left',
		sortable:true,
		renderer :Ext.util.Format.comboRenderer2(CTUom,"uom","uomDesc"),					
		editor : new Ext.grid.GridEditor(CTUom)
	},{
		header:"备注",
		dataIndex:'remark',
		id:'colRemark',
		width:200,
		align:'left',
		sortable:true,
		editor:new Ext.form.TextField({
			id:'remarkField',
			allowBlank:false,
			maxLength:30,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = INDispReqGrid.getSelectionModel().getSelectedCell();
						if(INDispReqGridDs.getAt(cell[0]).get('qty')==0){
							Msg.info("error","请领数量不能为0!");
							var col = GetColIndex(INDispReqGrid,'qty');
							INDispReqGrid.startEditing(cell[0], col);
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
		header : '状态',
		dataIndex : 'moveStatus',
		width : 60,
		aligh : 'left',
		renderer : function(value){
			var status="";
			if(value=="G"){
				status="未发放";
			}else if(value=="D"){
				status="已发放";
			}else if(value=="X"){
				status="已取消";
			}else if(value=="R"){
				status="已拒绝";
			}
			return status;
		}
	}
]);

var add = new Ext.Toolbar.Button({
	text:'新建',
	id:'newReq',
	iconCls:'page_add',
	tooltip:'新建请领单',
	width : 70,
	height : 30,
	//disabled:true,
	handler:function(){
		if (isDataChanged()){
			Ext.Msg.show({
				title:'提示',
				msg: '已经对该单数据做了修改，继续执行将丢失掉修改，继续吗？',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
					if (btn=='yes') {
						clearReq();
						addNewRow();
					}
				}
			})
		}else {
			clearReq();
			addNewRow();
		}
	}
});
function saveReq(){
	//主表信息
	//供给部门
	var subLoc = Ext.getCmp('sublocField').getValue(); 
	if((subLoc=="")||(subLoc==null)){
		Msg.info("error", "请选择供给部门!");
		return false;
	}
	var dsrqNo=Ext.getCmp('dsrqNo').getValue(); 
	
	//登陆用户
	var user = UserId;
	//类组
	var scg = Ext.getCmp('groupField').getValue(); 
	if((scg=="")||(scg==null)){
		Msg.info("error", "请选择类组!");
		return false;
	}
	//完成标志(暂时为空)
	//var status =Ext.getCmp('reqType').getValue(); 
	//var reqMode=Ext.getCmp("dsMode").getValue().getGroupValue();
	var reqMode = Ext.getCmp("formPanel").getForm().findField('dispMode').getGroupValue();
	if(reqMode==""){
		Msg.info("warning","请选择请领方式!");
		return;
	}
	var userGrp=Ext.getCmp('UserGrp').getValue();
	if(reqMode==0 && userGrp==""){
		Msg.info("warning","请选择专业组!");
		return;
	}
	
	//备注
	var remark = Ext.getCmp('remark').getValue(); 
	remark=remark.replace(/\r/g,'').replace(/\n/g,xMemoDelim());
	
	//主表信息字符串
	var reqInfo =INDispReqRowId+'^'+dsrqNo +"^"+ subLoc+"^"+user+"^"+scg+"^"+remark+"^"+reqMode+"^"+userGrp+"^"+user;
	//alert(reqInfo)
	
	if(RowDelim==null){
		Msg.info("error", "行分隔符有误，不能保存!");
		return false;
	}
	
	if(INDispReqGrid.activeEditor != null){
		INDispReqGrid.activeEditor.completeEdit();
	}
	//子表明细
	var data = "";
	var count= INDispReqGrid.getStore().getCount();
	for(var index=0;index<count;index++){
		var rec = INDispReqGridDs.getAt(index);	
				//新增或数据发生变化时执行下述操作
		if(rec.data.newRecord || rec.dirty){
			var inc = rec.data['inci'];
			var qty = rec.data['qty'];
			var colRemark=rec.data['remark'];
			if((inc!="")&&(inc!=null)&&(qty!="")&&(qty!=null)&&(qty!=0)){
				var tmp = rec.data['rowid']+"^"+inc+"^"+rec.data['uom']+"^"+qty+"^"+colRemark;
				if(data==""){
					data = tmp;
				}else{
					data = data+xRowDelim()+tmp;
				}
			}
		}
	}
	
	if ( (INDispReqRowId=='')&& (data=="")) {Msg.info("error", "没有内容需要保存!");return false;}
	if(!IsFormChanged(formPanel) && data==""){Msg.info("error", "没有内容需要保存!");return false;}
	
	Ext.Ajax.request({
		url : 'dhcstm.indispreqaction.csp?actiontype=SaveDispReq',
		params:{dsrq:INDispReqRowId,mData:reqInfo,dData:data},
		method : 'POST',
		waitMsg : '查询中...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "保存成功!");
				INDispReqRowId = jsonData.info;
				//alert(INDispReqRowId);
				refresh(INDispReqRowId);
			}else{
				if(jsonData.info==-1){
					Msg.info("error", "主表保存失败!");
				}else if(jsonData.info==-99){
					Msg.info("error", "主表加锁失败!");
				}else if(jsonData.info==-2){
					Msg.info("error", "明细保存失败!");
				}else if(jsonData.info==-4){
					Msg.info("error", "主表单号设置失败!");
				}else if(jsonData.info==-3){
					Msg.info("error", "主表保存失败!");
				}else{
					Msg.info("error", "保存失败,"+jsonData.info);
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
		if(INDispReqGrid.avtiveEditor!=null){
			INDispReqGrid.activeEditor.completeEdit();
		}
		//保存时传入三个字符串
		//1.主表rowid
		//2.主表的信息：subLoc、toLoc、user、scg、status、remark
		//3.子表明细信息：req、明细字符串rows(rows信息：reqi(明细rowid)、data(inci、uom、qty))
		
		saveReq();
	}
});

function refresh(dsrq){
	INDispReqRowId=dsrq;
	Select(INDispReqRowId);
	INDispReqGridDs.load({params:{start:0,limit:999,sort:'',dir:'asc',dsrq:INDispReqRowId}});
}

function Select(reqid){
	if(reqid==null || reqid==''){
		return;
	}
	INDispReqRowId=reqid;
	Ext.Ajax.request({
		url : 'dhcstm.indispreqaction.csp?actiontype=SelectDsReq&dsrq='+reqid,
		method : 'POST',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				var data=jsonData.info;
				if(data.length>0){
					var dataArr=data.split("^");
					var no=dataArr[1];
					var loc=dataArr[2];
					var scg=dataArr[4];
					var scgDesc=dataArr[5];
					var d=dataArr[6];
					var t=dataArr[7];
					var opUser=dataArr[8];
					var opUserName=dataArr[9];
					var mode=dataArr[10];
					var reqGrp=dataArr[11];
					var reqUser=dataArr[12];
					var status=dataArr[13];
					var remark=dataArr[14];
					remark=handleMemo(remark,xMemoDelim());
					var comp=dataArr[15];
					var reqGrpDesc=dataArr[16];
					
					//dsrq_"^"_rqno_"^"_loc_"^"_locDesc_"^"_scg_"^"_scgDesc_"^"_d_"^"_t_"^"_opuser_"^"_opuserName_"^"_mode_"^"_grp_"^"_requser_"^"_status_"^"_remark_"^"_comp
					
					Ext.getCmp('dsrqNo').setValue(no);
					Ext.getCmp('sublocField').setValue(loc);
					Ext.getCmp('dateField').setValue(d);
					Ext.getCmp('timeField').setValue(t);
					Ext.getCmp('userField').setValue(opUserName);
					addComboData(groupField.getStore(),scg,scgDesc,groupField);
					Ext.getCmp('groupField').setValue(scg);
					Ext.getCmp('remark').setValue(remark);
					Ext.getCmp('reqStatus').setValue(status);
					
					if (mode==0) {
						byUser.setValue(false) ;
						byUserGrp.setValue(true);
						addComboData(GrpList.getStore(),reqGrp,reqGrpDesc);
						GrpList.setValue(reqGrp);
					}
					else {
						byUserGrp.setValue(false) ;
						byUser.setValue(true) ;
					}
					Ext.getCmp("completeCK").setValue(comp=="Y");
					Ext.getCmp("completeCK").fireEvent('check',Ext.getCmp("completeCK"),(comp=="Y"));
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
	text:'提交',
	tooltip:'提交',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	disabled:true,
	handler:function(){
		if (INDispReqRowId=='') 
		{
			Msg.info('warning','没有任何请领单！');
			return ;
		}
		var statu=(Ext.getCmp('completeCK').getValue()==true?"Y":"N");
		if((statu=="N")||(statu=="")||(statu==null)){
			statu = "Y";
			Ext.Ajax.request({
				url : 'dhcstm.indispreqaction.csp?actiontype=SetComp&dsrq='+INDispReqRowId,
				method : 'POST',
				waitMsg : '查询中...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "提交成功!");
						statu = "Y";
						completeCK.setValue(statu=='Y'?true:false);
					}else{
						if(jsonData.info==-2){
							Msg.info("error", "设置失败!");
						}else if(jsonData.info==-1){
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

var cancelComplete = new Ext.Toolbar.Button({
	text:'取消提交',
	tooltip:'取消提交',
	id:'cancelComp',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	disabled:true,
	handler:function(){
		if (INDispReqRowId=='') 
		{
			Msg.info('warning','没有任何请领单！');
			return ;
		}
		var reqStatus=Ext.getCmp("reqStatus").getValue()
		if(reqStatus=="X"){
			Msg.info("error","单据已作废, 不可修改!");
			return;
		}
		if(reqStatus=="C"){
			Msg.info("error","单据已处理, 不可取消提交!");
			return;
		}
		
		var statu=(Ext.getCmp('completeCK').getValue()==true?"Y":"N");
		if(statu=="Y"){
			Ext.Ajax.request({
				url : 'dhcstm.indispreqaction.csp?actiontype=CancelComp&dsrq='+INDispReqRowId,
				method : 'POST',
				waitMsg : '查询中...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "取消提交成功!");
						refresh(INDispReqRowId);
					}else{
						if(jsonData.info==-2){
							Msg.info("error", "设置失败!"+jsonData.info);
						}else if(jsonData.info==-1){
							Msg.info("error", "当前请领单已转为正式单,禁止取消提交!");
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

function delReq()
{
	if(INDispReqRowId==null || INDispReqRowId==""){
		Msg.info("warning","请选择要删除的请领单!");
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
					url:URL+ "?actiontype=DelDispReq",
					method:'POST',
					params:{DSRQ:INDispReqRowId},
					success:function(response,opts){
						 
						var jsonData=Ext.util.JSON.decode(response.responseText);
						//alert(jsonData.success);
						
						if(jsonData.success=='true'){
							Msg.info("success","删除成功!");
							Ext.getCmp("clear").handler.call(Ext.getCmp("clear").scope);
						}else{
							if(jsonData.info==-1){
								Msg.info("warning","该请领单已提交，不允许删除！");
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

var cancelButton= new Ext.Toolbar.Button({
	text:'作废请领单',
	id:'cancelReq',
	tooltip:'作废请领单',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		cancelReq();
	}
});

var printBT = new Ext.Toolbar.Button({
	text : '打印',
	tooltip : '打印请领单',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		if(INDispReqRowId==null || INDispReqRowId==""){
			Msg.info("warning","没有需要打印的请领单!");
			return;
		}
		PrintINDispReq(INDispReqRowId);
	}
});

function cancelReq()
{
	if(INDispReqRowId==null || INDispReqRowId==""){
		Msg.info("warning","请选择要作废的请领单!");
		return;
	}
	Ext.Msg.show({
		title:'提示',
		msg:'是否确定作废当前请领单？',
		buttons:Ext.Msg.YESNO,
		icon: Ext.MessageBox.QUESTION,
		fn:function(b,txt){
			if (b=='no')	{return;}
			else 	
			{
				Ext.Ajax.request({
					url:URL+ "?actiontype=CancelDispReq",
					method:'POST',
					params:{dsrq:INDispReqRowId},
					success:function(response,opts){
						 
						var jsonData=Ext.util.JSON.decode(response.responseText);
						//alert(jsonData.success);
						
						if(jsonData.success=='true'){
							Msg.info("success","作废成功!");
							Ext.getCmp("clear").handler.call(Ext.getCmp("clear").scope);
						}else{
							if(jsonData.info=='-99'){
								Msg.info('warning','加锁失败!');
							}
							else if (jsonData.info=='-98'){
								Msg.info('warning','已处理，不能作废!');
							}
							else if (jsonData.info=='-97'){
								Msg.info('warning','未完成，无需作废!');
							}
							else if (jsonData.info=='-96'){
								Msg.info('warning','已处理，不能作废!');
							}
							else if (jsonData.info=='-95'){
								Msg.info('warning','已作废，不能再次作废!');
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
//删除转移请领明细
function DeleteDetail(){
	if ((INDispReqRowId!="")&&(Ext.getCmp('completeCK').getValue()==true))
	{
		Msg.info('warning','当前请领单已提交');
		return;
	}
	var cell = INDispReqGrid.getSelectionModel().getSelectedCell();
	if(cell==null){
		Msg.info("error","请选择数据!");
		return false;
	}
	else{
		var record = INDispReqGridDs.getAt(cell[0]);
		var reqItm = record.get("rowid");
		//alert(reqItm);
		if(reqItm!=""){
			Ext.MessageBox.confirm('提示','确定要删除该记录?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url : 'dhcstm.indispreqaction.csp?actiontype=DelDispReqItm&DSRQI='+reqItm,
							waitMsg:'删除中...',
							failure: function(result, request) {
								Msg.info("error", "请检查网络连接!");
								return false;
							},
							success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
									INDispReqGridDs.load({params:{start:0,limit:999,sort:'rowid',dir:'desc',dsrq:INDispReqRowId}});
								}else{
									if(jsonData.info==-1){
										Msg.info("error", "明细Id为空，删除失败!");
										return false;
									}else if(jsonData.info==-2){
										Msg.info("error", "已处理, 不允许删除!");
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
		}
		else{
			INDispReqGridDs.remove(record);
			INDispReqGrid.getView().refresh();
		}
	
		if (INDispReqGridDs.getCount()==0){
			setEditEnable();
		}
	}
}

//初始化默认排序功能
INDispReqGridCm.defaultSortable = true;

var AddDetailBT=new Ext.Button({
	text:'增加一条',
	tooltip:'点击增加',
	iconCls:'page_add',
	height:30,
	width:70,
	handler:function(){
		/*
		var toLoc = Ext.getCmp('LocField').getValue(); 
		if((toLoc=="")||(toLoc==null)){
			Msg.info("warning", "请选择请领部门!");
			return ;
		}
		*/
		
		var subLoc = Ext.getCmp('sublocField').getValue(); 
		if((subLoc=="")||(subLoc==null)){
			Msg.info("warning", "请选择供给部门!");
			return ;
		}
		
		//类组
		var scg = Ext.getCmp('groupField').getValue(); 
		if((scg=="")||(scg==null)){
			Msg.info("warning", "请选择类组!");
			return false;
		}
		addNewRow();
	}
})
var DelDetailBT=new Ext.Button({
	text:'删除一条',
	tooltip:'',
	iconCls:'page_delete',
	height:30,
	width:70,
	handler:function()
	{
		DeleteDetail();
	}
})

var CancelDetailBT = new Ext.Button({
	id : 'CancelDetailBT',
	text : '取消一条',
	iconCls : 'page_edit',
	height : 30,
	width : 70,
	checked : false,
	handler : function(){
		CancelItm();
	}
});

function CancelItm(){
	var cell = INDispReqGrid.getSelectionModel().getSelectedCell();
	if(cell==null){
		Msg.info("error","请选择数据!");
		return false;
	}
	if(Ext.getCmp('completeCK').getValue()!==true){
		Msg.info('warning','当前请领单尚未提交,直接修改即可!');
		return;
	}
	var reqStatus = Ext.getCmp('reqStatus').getValue();
	if(reqStatus=="O"){
		Msg.info("warning","该请领单尚未处理,取消提交后直接修改即可!");
		return;
	}else if(reqStatus=="X"){
		Msg.info("warning","该请领单已经作废,不可取消明细!");
		return;
	}else if(reqStatus=="R"){
		Msg.info("warning","该请领单已被拒绝,不可取消明细!");
		return;
	}
	var record = INDispReqGridDs.getAt(cell[0]);
	var reqItm = record.get("rowid");
	var moveStatus = record.get("moveStatus");
	var dsrqiDesc = record.get("desc");
	if(moveStatus!="G"){
		Msg.info("warning","该明细已经处理,不可取消!");
		return;
	}
	if(reqItm!=""){
		Ext.MessageBox.confirm('提示','确定要取消该记录?',
			function(btn) {
				if(btn == 'yes'){
					Ext.Ajax.request({
						url : 'dhcstm.indispreqaction.csp?actiontype=HandleItm&dsrqi='+reqItm+'&moveStatus=X',
						waitMsg:'取消中...',
						failure: function(result, request) {
							Msg.info("error", "请检查网络连接!");
							return false;
						},
						success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info("success","取消成功!");
								INDispReqGridDs.load({params:{start:0,limit:999,sort:'rowid',dir:'desc',dsrq:INDispReqRowId}});
							}else{
								var info = jsonData.info;
								if(info==-96){
									Msg.info("warning",dsrqiDesc+"已发放制单,不可取消!");
								}else if(info==-95){
									Msg.info("warning","该请求单已作废,不可取消明细!");
									return false;	//停止迭代
								}else if(info==-94){
									Msg.info("warning","该请求单已拒绝,不可取消明细!");
									return false;	//停止迭代
								}else if(info==-93){
									Msg.info("warning",dsrqiDesc+"已发放,不可取消!");
									return;
								}else if(info==-92){
									Msg.info("warning",dsrqiDesc+"已拒绝,不可重复处理!");
									return;
								}else{
									Msg.info("error",dsrqiDesc+"取消失败:"+jsonData.info);
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
		Msg.info("warning","该明细尚未保存,直接删除即可!");
	}
}

//表格
INDispReqGrid = new Ext.ux.EditorGridPanel({
	id:'reqItmEditGrid',
	title:'科室内物资请领',
	store:INDispReqGridDs,
	cm:INDispReqGridCm,
	trackMouseOver:true,
	stripeRows:true,
	region:'center',
	sm:new Ext.grid.CellSelectionModel({
		singleSelect:true,
		listeners : {
			cellselect : function(sm,rowIndex,colIndex){
				var comp = Ext.getCmp("completeCK").getValue();
				var enalbeValue = comp && (INDispReqGridDs.getAt(rowIndex).get('rowid')!="");
				CancelDetailBT.setDisabled(!enalbeValue);
			}
		}
	}),
	loadMask:true,
	clicksToEdit:1,
	tbar:[AddDetailBT,'-',DelDetailBT,'-',CancelDetailBT],
	listeners:{
		afteredit:function(e){
			if(e.field=="qty"){	
				e.record.set("spAmt",accMul(e.value,Number(e.record.get('sp')))); 
			}
		},
		beforeedit : function(e){
			if(Ext.getCmp("completeCK").getValue()===true){
				return false;
			}
		}
	}
});

//zdm,增加右键删除明细功能
INDispReqGrid.addListener("rowcontextmenu",function(grid,rowindex,e){
	grid.getSelectionModel().select(rowindex,0);
	e.preventDefault();
	rightClickMenu.showAt(e.getXY());
});

var rightClickMenu=new Ext.menu.Menu({
	id:'rightClickMenu',
	items:[{id:'mnuDelete',text:'删除',handler:DeleteDetail}]
});

//===========模块主页面===========================================

var formPanel = new Ext.ux.FormPanel({
	id:'formPanel',
	title:'科室内物资请领',
	tbar:[find,'-',add,'-',save,'-',del,'-',cancelButton,'-',complete,'-',cancelComplete,'-',clear,'-',printBT],
	items : [{
		xtype : 'fieldset',
		title : '请领单信息',
		layout : 'column',	
		style : 'padding:5px 0px 0px 5px',
		defaults:{border:false,xtype:'fieldset'},
		items : [{
			columnWidth:0.3,
			items : [sublocField,groupField,byUser,{
				anchor:'90%',
				layout:'column',
				items:[{columnWidth:0.4,layout:'fit',items:byUserGrp},
					{columnWidth:0.6,layout:'fit',items:GrpList}]
			}]
		},{
			columnWidth : 0.25,
			items : [dsrqNo,userField,dateField,timeField]
		},{
			columnWidth : 0.25,
			items : [remark]
		},{
			columnWidth : 0.2,
			items : [completeCK,statusCombo]
		}]
	}]
});

//查看请领单数据是否有修改
function isDataChanged()
{
	var changed=false;
	var count1= INDispReqGrid.getStore().getCount();
	//看主表数据是否有修改
	//修改为主表有修改且子表有数据时进行提示
	if((IsFormChanged(formPanel))&&(count1!=0))
	{
		changed = true;	
	}
	if (changed) return changed;
	//看明细数据是否有修改
	var count= INDispReqGrid.getStore().getCount();
	for(var index=0;index<count;index++){
		var rec = INDispReqGridDs.getAt(index);	
				//新增或数据发生变化时执行下述操作
		if(rec.data.newRecord || rec.dirty){
			changed = true;
		}
	}
	return changed;
}

Ext.onReady(function(){
	Ext.QuickTips.init();
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,{
			region:'center',
			layout:'fit',
			items:[INDispReqGrid]
		}]
	});
});

//===========模块主页面===========================================
///设置可编辑组件的disabled属性
function setEditDisable()
{
	Ext.getCmp('groupField').setDisabled(true);
}
///放开可编辑组件的disabled属性
function setEditEnable()
{
	Ext.getCmp('groupField').setDisabled(false);
}
