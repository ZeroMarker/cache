// /名称: 退货单制单
// /描述: 退货单制单
// /编写者：zhangdongmei
// /编写日期: 2012.10.31

var URL = 'dhcstm.ingdretaction.csp';
var HospId=session['LOGON.HOSPID'];
var userId = session['LOGON.USERID'];
var locId = session['LOGON.CTLOCID'];
var groupId=session['LOGON.GROUPID'];
var gIngrt= gIngrtId;	//退货主表id

var buomRp="";	//基本单位进价
var buomSp="";	//基本单位售价
var puomRp="";	//入库单位进价
var puomSp="";	//入库单位售价
GetParam();
//取高值管理参数

var UseItmTrack="";
if(gItmTrackParam.length<1){
	GetItmTrackParam();
	UseItmTrack=gItmTrackParam[0]=='Y'?true:false;
}

var dateField = new Ext.ux.DateField({
	id:'dateField',
	listWidth:150,
	allowBlank:false,
	fieldLabel:'日期',
	anchor:'90%',
	value:new Date(),
	editable:false,
	disabled:true
});

var dretField = new Ext.form.TextField({
	id:'dret',
	fieldLabel:'退货单号',
	allowBlank:true,
	emptyText:'',
	anchor:'90%',
	selectOnFocus:true,
	disabled:true
});

var locField = new Ext.ux.LocComboBox({
	id:'locField',
	fieldLabel:'退货科室',
	emptyText:'退货科室...',
	anchor:'90%',
	groupId:groupId,
	stkGrpId : 'groupField',
	childCombo : 'Vendor'
});

var groupField=new Ext.ux.StkGrpComboBox({ 
	id : 'groupField',
	name : 'groupField',
	StkType:App_StkTypeCode,     //标识类组类型
	LocId:locId,
	UserId:userId,
	anchor:'90%'
}); 

var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : '供应商',
	id : 'Vendor',
	name : 'Vendor',
	anchor:'90%',
	params : {LocId : 'locField',ScgId : 'groupField'}
});

var pNameField = new Ext.form.TextField({
	id:'pName',
	fieldLabel:'物品名称',
	allowBlank:true,
	width:180,
	listWidth:150,
	emptyText:'',
	anchor:'90%',
	selectOnFocus:true,
	listeners :{
		specialKey :function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER){
				//调出物资窗口
				var group = Ext.getCmp("groupField").getValue();
				//GetPhaOrderInfo(field.getValue(),group);
			
				var inputVen=field.getValue();
				var Locdr=Ext.getCmp('locField').getValue();
				var NotUseFlag='N';
				var QtyFlag=1;
				var ReqLoc='';
				var Vendor=Ext.getCmp('Vendor').getValue();
				var VendorName=Ext.getCmp('Vendor').getRawValue();
				VendorItmBatWindow(inputVen, group, App_StkTypeCode, Locdr,Vendor,VendorName, NotUseFlag, QtyFlag, HospId, ReqLoc, AddList);
			}
		}	
	}
});

var HVBarCodeEditor = new Ext.form.TextField({
	selectOnFocus : true,
	listeners : {
		specialkey : function(field, e) {
			var Barcode=field.getValue();
			if (Barcode!="" && e.getKey() == Ext.EventObject.ENTER){
				var row=IngDretDetailGrid.getSelectionModel().getSelectedCell()[0];
				var findHVIndex=IngDretDetailGridDs.findExact('HVBarCode',Barcode,0);
				if(findHVIndex>=0 && findHVIndex!=row){
					Msg.info("warning","不可重复录入!");
					return;
				}
				Ext.Ajax.request({
					url : 'dhcstm.itmtrackaction.csp?actiontype=GetItmByBarcode&Barcode='+Barcode,
					method : 'POST',
					waitMsg : '查询中...',
					success : function(result, request){
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if(jsonData.success == 'true'){
							var itmArr=jsonData.info.split("^");
							var status=itmArr[0],type=itmArr[1],lastDetailAudit=itmArr[2],lastDetailOperNo=itmArr[3];
							var inclb=itmArr[4],inciDr=itmArr[5],inciCode=itmArr[6],inciDesc=itmArr[7];
							var scgID=itmArr[8],scgDesc=itmArr[9],ingri=itmArr[10];
							if(status!="Enable"){
								Msg.info("warning","该高值条码处于不可用状态,不可制单!");
								IngDretDetailGrid.store.getAt(row).set("HVBarCode","");
								return;
							}else if(Ext.getCmp("groupField").getValue()!=scgID){
								Msg.info("warning","条码"+Barcode+"属于"+scgDesc+"类组,与当前不符!");
								IngDretDetailGrid.store.getAt(row).set("HVBarCode","");
								return;
							}else if(ingri==""){
								Msg.info("warning","该条码尚未办理入库,不能退货!");
								return;
							}else if(lastDetailAudit!="Y"){
								Msg.info("warning","该高值材料有未审核的"+lastDetailOperNo+",请核实!");
								return;
							}else if(type=="T"){
								Msg.info("warning","该高值材料已经出库,不可制单!");
								return;
							}
							var phaLoc = Ext.getCmp("locField").getValue();
							var vendor = Ext.getCmp("Vendor").getValue();
							var zeroFlag = '0';
							var strPar = phaLoc+"^"+inciDr+"^"+vendor+"^"+zeroFlag+"^"+ingri+"^"+inclb;
							var url = "dhcstm.ingdretaction.csp?actiontype=selectBatch&strPar="+strPar+"&start=0&limit=1";
							var result=ExecuteDBSynAccess(url);
							var info=Ext.util.JSON.decode(result);
							var inforesults=info.results;
							if(inforesults=='0'){
								Msg.info("warning","该条码对应库存为零，不能退货!");
								return;
							}
							var inforows=info.rows[0];
							var InfoRecord=new Ext.data.Record(inforows);
							AddList(InfoRecord);
						}else{
							Msg.info("warning","该条码尚未注册!");
							return;
						}
					}
				});
			}
		}
	}
});

var transOrder = new Ext.form.Checkbox({
	id: 'transOrder',
	fieldLabel:'调价换票',
	anchor:'90%',
	allowBlank:true
});

//"完成"标志
var complete = new Ext.form.Checkbox({
	id: 'complete',
	fieldLabel:'完成',
	disabled:true,
	allowBlank:true,
	disabled:true,
	anchor:'90%'
});

//"审核"标志
var auditChk = new Ext.form.Checkbox({
	id: 'audited',
	fieldLabel:'审核',
	disabled:true,
	allowBlank:true,
	disabled:true,
	anchor:'90%'
});

var noViewZeroItem = new Ext.form.Checkbox({
	id: 'noViewZeroItem',
	fieldLabel:'不显示库存为零的项',
	allowBlank:true,
	checked:true
});

var noViewZeroVendor = new Ext.form.Checkbox({
	id: 'noViewZeroVendor',
	fieldLabel:'不显示库存为零的供应商',
	allowBlank:true
});

ReasonForReturnStore.load();
var newBT = new Ext.Toolbar.Button({
	text:'新建',
	tooltip:'新建退货单',
	iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		//addDetailRow();
		if (Ext.getCmp('groupField').getValue()==''){
		    Msg.info('error','请选择类组!');
		    return;
	          }
		NewRet()
	}
});

var clearBT = new Ext.Toolbar.Button({
	text:'清空',
	tooltip:'清空',
	iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function() {
		if (isDataChanged(formPanel,IngDretDetailGrid)){
			Ext.Msg.show({
				title:'提示',
				msg: '已经对该单数据做了修改，继续执行将丢失掉修改，继续吗？',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
					if (btn=='yes') {
						clearData();
						SetFormOriginal(formPanel);
					}
				}
			})
		}else{
			clearData(); 
			SetFormOriginal(formPanel);
		}
	}
});

var AddDetailBT=new Ext.Button({
	text:'增加一条',
	tooltip:'',
	iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		if (Ext.getCmp('groupField').getValue()==''){
		    Msg.info('error','请选择类组!');
		    return;
	          }
		addDetailRow();
	}
});

var DelDetailBT=new Ext.Button({
	text:'删除一条',
	tooltip:'',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		DeleteDetail();
	}
});

var GridColSetBT = new Ext.Toolbar.Button({
	text:'列设置',
	tooltip:'列设置',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		GridColSet(IngDretDetailGrid,"DHCSTRETURNM");
	}
});

// 当页条数 
var NumAmount = new Ext.form.TextField({
	emptyText : '当页条数',
	id : 'NumAmount',
	name : 'NumAmount',
	anchor : '90%',
	width:200
});	

// 进价合计
var RpAmount = new Ext.form.TextField({
	emptyText : '进价合计',
	id : 'RpAmount',
	name : 'RpAmount',
	anchor : '90%',
	width : 200
});

// 售价合计
var SpAmount = new Ext.form.TextField({
	emptyText : '售价合计',
	id : 'SpAmount',
	name : 'SpAmount',
	anchor : '90%',
	width : 200
});

//合计
function GetAmount(){
	var rpAmt=0,spAmt=0;
	var Count = IngDretDetailGrid.getStore().getCount();
	for(var i=0; i<Count; i++){
		var rowData = IngDretDetailGridDs.getAt(i);
		var qty = Number(rowData.get("qty"));
		var Rp = Number(rowData.get("rp"));
		var Sp = Number(rowData.get("sp"));
		var rpAmt1=Rp.mul(qty);
		var spAmt1=Sp.mul(qty);
		rpAmt=rpAmt.add(rpAmt1);
		spAmt=spAmt.add(spAmt1);
	}
	var	rpAmt=rpAmt.toFixed(2);
	var	spAmt=spAmt.toFixed(2);
	Count="当前条数:"+" "+Count;
	rpAmt="退货进价合计:"+" "+rpAmt+" "+"元";
	spAmt="退货售价合计:"+" "+spAmt+" "+"元";
	Ext.getCmp("NumAmount").setValue(Count);
	Ext.getCmp("RpAmount").setValue(rpAmt);
	Ext.getCmp("SpAmount").setValue(spAmt);
}
var findIngDret = new Ext.Toolbar.Button({
	text:'查询',
	tooltip:'查询',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		if(Ext.getCmp("locField").getValue()==""){
			Msg.info("warning","退货科室不可为空!");
			return;
		}
		findIngDret();
	}
});

var completeBT = new Ext.Toolbar.Button({
	text:'完成',
	tooltip:'完成',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		Complete();
	}
});

var cancelCompleteBT = new Ext.Toolbar.Button({
	text:'取消完成',
	tooltip:'取消完成',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		cancelComplete();
	}
});

// 打印退货单
var printBT = new Ext.Toolbar.Button({
	id : "printBT",
	text : '打印',
	tooltip : '打印退货单',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		PrintIngDret(gIngrt);
	}
});

var saveIngDret = new Ext.ux.Button({
	text:'保存',
	tooltip:'保存',
	iconCls:'page_save',
	width : 70,
	disabled:true,
	height : 30,
	handler:function(){
		//1.保存主表信息
		var retNo = Ext.getCmp('dret').getValue();
		var scg = Ext.getCmp('groupField').getValue();
		if((scg=="")||(scg==null)){
			Msg.info("error","请选择类组!");
			return false;
		}
		var vendorId=Ext.getCmp("Vendor").getValue();
		if((vendorId=="")||(vendorId==null)){
			Msg.info("error","请选择供应商!");
			return false;
		}
		var locId=Ext.getCmp("locField").getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error","请选择科室!");
			return false;
		}
		var stkType = "";
		var adjChequeFlag = (Ext.getCmp('transOrder').getValue()==true?'Y':'N');
		var mainInfo=locId+"^"+vendorId+"^"+userId+"^"+scg+"^"+adjChequeFlag;
		
		if(IngDretDetailGrid.activeEditor != null){
			IngDretDetailGrid.activeEditor.completeEdit();
		}
		var rows = "";
		var count = IngDretDetailGridDs.getCount();		
		if(!count>0){Msg.info('error','没有需要保存的数据!') ;return}
		for(var index=0;index<count;index++){
			var row = IngDretDetailGridDs.getAt(index);
			//新增或数据发生变化时执行下述操作
			if(row.data.newRecord || row.dirty){	
				var ingrti = row.get('ingrti'); 	//退货子表rowid(DHC_INGRtItm)
				var ingri = row.get('ingri'); 		//入库子表rowid(DHC_INGdRecItm)
				if(ingri==null || ingri==""){
					continue;
				}
				var qty = row.get('qty'); 			//数量
				if((ingri!="")&&(qty==null || qty==""||qty<0)){
					Msg.info("warning","第"+(index+1)+"行退货数量为空或者小于0!");
					return;
				}
				var uomId = row.get('uom'); 		//单位
				var rp = row.get('rp'); 			//进价
				var rpAmt = row.get('rpAmt'); 		//进价金额
				var sp = row.get('sp'); 			//售价
				var spAmt = row.get('spAmt'); //售价金额
				var oldSp = row.get('oldSp'); //批次售价
				var oldSpAmt = row.get('oldSpAmt'); //批次售价金额
				var invNo = row.get('invNo'); //发票号
				var invDate = row.get('invDate'); //发票日期
				if((invDate!="")&&(invDate!=null)){
					invDate = invDate.format(ARG_DATEFORMAT);
				}else{
					invDate="";
				}
				var invAmt = row.get('invAmt'); //发票金额
				var sxNo = row.get('sxNo'); //随行单号
				if(sxNo==null){
					sxNo = "";
				}
				var reason = row.get('reasonId'); //退货原因
				if((ingri!="")&&(reason==null || reason=="")&&(gParam[8]!="Y")){
					Msg.info("warning","第"+(index+1)+"行退货原因为空!");
					return;
				}
				var aspa = row.get('aspAmt'); //退货调价金额
				var HVBarCode = row.get('HVBarCode')
				var Remark = row.get('Remark')
				var SpecDesc = row.get('SpecDesc')
				//
				//退货明细id^入库明细id^数量^单位^进价^售价^发票号^发票日期^发票金额^随行单^退货原因
				var data =  ingrti+"^"+ingri+"^"+qty+"^"+uomId+"^"+rp+"^"+sp+"^"+invNo+"^"+invDate+"^"+invAmt+"^"+sxNo+"^"+reason+"^"+HVBarCode+"^"+Remark+"^"+SpecDesc;
				if(rows!=""){
					rows = rows+xRowDelim()+data;
				}else{
					rows = data;
				}
			}
		}
		
		if(rows=="" && !IsFormChanged(formPanel)){Msg.info('error','没有需要保存的数据!');return}
		var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
		Ext.Ajax.request({
			url: URL+'?actiontype=save',
			params:{ret:gIngrt,MainData:mainInfo,Detail:rows},
			failure: function(result, request) {
				Msg.info("error","请检查网络连接!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success=='true') {
					Msg.info("success","保存成功!");
					gIngrt =  jsonData.info; //退货单主表Id					
					Select(gIngrt);
					IngDretDetailGridDs.load({params:{start:0,limit:999,sort:'ingrti',dir:'desc',ret:gIngrt}});
					if(gParam[5] == 'Y'){
						PrintIngDret.defer(300,this,[gIngrt, 'Y']);
					}
				}else{
					var ret=jsonData.info;
					if(ret=='-10'){
						Msg.info("warning","可用库存不足于退货!");
					}else if(ret=='-3'){
						Msg.info("warning","生成退货单号失败!");
					}else if(ret=='-4'){
						Msg.info("warning","保存退货单失败!");
					}else if(ret=='-6'){
						Msg.info("warning","保存退货明细失败!");
					}else{
						Msg.info("error","保存失败:"+ret);
					}
				}
				loadMask.hide();
			},
			scope: this
		});
	}
});

var deleteIngDret = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		if(gIngrt==null || gIngrt==""){
			Msg.info("error","没有要删除的退货单!");
			return false;
		}else{
			if (Ext.getCmp('complete').getValue()==true)
			{
				Msg.info("warning","已经完成,禁止删除!");
				return;
			}
			Ext.MessageBox.confirm('提示','确定要删除该退货单?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:URL+'?actiontype=delete&Ingrt='+gIngrt,
							waitMsg:'删除中...',
							failure: function(result, request) {
								Msg.info("error","请检查网络连接!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success","删除成功!");
									clearData();
								}else{
									Msg.info("error","删除失败!");
								}
							},
							scope: this
						});
					}
				}
			)
		}
	}
});

////删除一条明细记录
function DeleteDetail(){
	if ((gIngrt!="")&&(Ext.getCmp('complete').getValue()==true)){
		Msg.info('warning','当前退货单已完成,禁止删除明细记录!');
		return;
	}
	var cell=IngDretDetailGrid.getSelectionModel().getSelectedCell();
	if (!cell) {
		Msg.info("warning",'请选择明细记录!');
		return;
	}
	var rowindex=cell[0];
	if(rowindex==null){
		Msg.info("error","请选择数据!");
		return false;
	}else{
		var record = IngDretDetailGrid.getStore().getAt(rowindex);
		var RowId = record.get("ingrti");
		if(RowId!=""){
			Ext.MessageBox.confirm('提示','确定要删除选定的行?',
				function(btn) {
					if(btn == 'yes'){
						
						Ext.Ajax.request({
							
							url:URL+'?actiontype=deleteDetail&rowid='+RowId,
							waitMsg:'删除中...',
							failure: function(result, request) {
								Msg.info("error","请检查网络连接!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success","删除成功!");
									if (IngDretDetailGrid.getStore().getCount()==0)
									{
										setEditEnable();
									}
									IngDretDetailGridDs.load({params:{start:0,limit:20,sort:'ingrti',dir:'desc',ret:gIngrt}});
								}else{
									Msg.info("error","删除失败!");
								}
							},
							scope: this
						});
					}
				}
			)
		}else{
			IngDretDetailGrid.getStore().remove(record);
			IngDretDetailGrid.getView().refresh();
			if (IngDretDetailGrid.getStore().getCount()==0)
			{
				setEditEnable();
			}
		}
	}
}

var Cause2 = new Ext.form.ComboBox({
	fieldLabel : '退货原因',
	id : 'Cause2',
	name : 'Cause2',
	anchor : '90%',
	width : 120,
	store : ReasonForReturnStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : '退货原因...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 999,
	listWidth : 250,
	valueNotFoundText : '',
	listeners:{
		specialKey:function(field, e) {
			if(e.getKey() == Ext.EventObject.ENTER){
				var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
				var row = IngDretDetailGridDs.getAt(cell[0]);
				//row.set('retReason',field.getRawValue());
				//row.set('retReasonId',field.getValue());
				
				//var col=GetColIndex(IngDretDetailGrid,"invNo");
				//IngDretDetailGrid.startEditing(cell[0],col);
				addDetailRow();
			}
		}
	}
});		

//配置数据源
var IngDretDetailGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=select',method:'GET'});
var IngDretDetailGridDs = new Ext.data.Store({
	proxy:IngDretDetailGridProxy,
	reader:new Ext.data.JsonReader({
		totalProperty:'results',
		root:'rows'
	}, [
		{name:'ingrti'},
		{name:'ingri'},
		{name:'manf'},
		{name:'inclb'},
		{name:'uom'},
		{name:'uomDesc'},
		{name:'qty'},
		{name:'rp'},
		{name:'rpAmt'},
		{name:'sp'},
		{name:'spAmt'},
		{name:'invNo'},
		{name:'invDate',type:'date',dateFormat:DateFormat},
		{name:'invAmt'},
		{name:'sxNo'},
		{name:'oldSp'},
		{name:'oldSpAmt'},
		{name:'code'},
		{name:'desc'},
		{name:'spec'},
		{name:'batNo'},
		{name:'expDate'},
		{name:'reasonId'},
		{name:'retReason'},
		{name:'stkqty'},
		{name:'buom'},
		{name:'confac'},
		{name:'HVFlag'},
		{name:'HVBarCode'},
		{name:'Remark'},
		{name:'SpecDesc'}
	]),
	remoteSort:false
});

// 单位
var CTUom = new Ext.form.ComboBox({
	//fieldLabel : '单位',
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
	listWidth : 250	,
	valueNotFoundText : ''
});

CTUom.on('beforequery', function(combo) {
	var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
	var record = IngDretDetailGrid.getStore().getAt(cell[0]);
	var inclb = record.get("inclb");
	var InciDr = inclb.split("||")[0];
	CTUom.store.setBaseParam('ItmRowid',InciDr);
	CTUom.store.removeAll();
	CTUom.store.load();
});

/**
 * 单位变换事件
 */
CTUom.on('select', function(combo) {
	var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
	var record = IngDretDetailGrid.getStore().getAt(cell[0]);
	
	var value = combo.getValue();        //目前选择的单位id
	var BUom = record.get("buom");
	var ConFac = record.get("confac");   //大单位到小单位的转换关系		
	var Uom = record.get("uom");    //目前显示的退货单位
	var BatStkQty=record.get("stkqty");
	var NewStkQty=BatStkQty;
	if(value!=Uom){
		if(value==BUom){
			NewStkQty=BatStkQty*ConFac;
		}else{
			NewStkQty=BatStkQty/ConFac;
		}
		record.set("stkqty",NewStkQty)
	}
	var ingri=record.get("ingri");
	record.set("uom", combo.getValue());
	var Uom=record.get("uom");
	SetIngriPrice(record,ingri,Uom);
});

//模型
var IngDretDetailGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:"退货子表rowid",
		dataIndex:'ingrti',
		width:80,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"入库子表rowid",
		dataIndex:'ingri',
		width:80,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"批次DR",
		dataIndex:'inclb',
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
		id:'desc',
		width:200,
		align:'left',
		sortable:true,
		editor:pNameField
	},{
		header:"高值标志",
		dataIndex:'HVFlag',
		width:60,
		align:'center',
		sortable:true,
		hidden:true
	},{
		header:"高值条码",
		dataIndex:'HVBarCode',
		id:'HVBarCode',
		width:200,
		align:'left',
		sortable:true,
		editable : false,
		hidden:true,		//!UseItmTrack
		editor:HVBarCodeEditor
	},{
		header:"厂商",
		dataIndex:'manf',
		width:200,
		align:'left',
		sortable:true
	},{
		header:"规格",
		dataIndex:'spec',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"批次库存",
		dataIndex:'stkqty',
		width:100,
		align:'left',
		sortable:true    	
	},{
		header:"退货数量",
		dataIndex:'qty',
		width:100,
		id:'qty',
		align:'right',
		sortable:true,
		editor:new Ext.form.NumberField({
			id:'dretQtyField',
			allowBlank:true,
			allowNegative:false,
			listeners:{
				specialKey:function(field, e) {
					var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
					var row = IngDretDetailGridDs.getAt(cell[0]);
					if (e.getKey() == Ext.EventObject.ENTER) {
						var count = field.getValue();
						if(count>row.get("stkqty")||count<0){
							field.setValue("");
							Msg.info("error","退货数量不能大于库存数量或者小于0!");
						}else{
							var col=GetColIndex(IngDretDetailGrid,"reasonId");
							IngDretDetailGrid.startEditing(cell[0],col);
							//row.set("invAmt", count*row.get("rp")); 
						}
					}
				}
			}
		})
	},{
		header:"退货单位",
		dataIndex:'uom',
		id:'uom',
		width:100,
		align:'left',
		sortable:true,
		renderer:Ext.util.Format.comboRenderer2(CTUom,"uom","uomDesc"),								
		editor : new Ext.grid.GridEditor(CTUom),
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {	
					var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
					var colIndex=GetColIndex(IngDretDetailGrid,"uom");
					IngDretDetailGrid.startEditing(cell[0], colIndex);									
				}
			}
		}
	},{
		header:"退货原因",
		dataIndex:'reasonId',
		width:100,
		id:'reasonId',
		align:'left',
		sortable:true,
		editor:new Ext.grid.GridEditor(Cause2),
		renderer:Ext.util.Format.comboRenderer2(Cause2,"reasonId","retReason")
	},{
		header:"退货进价",
		dataIndex:'rp',
		width:100,
		align:'right',
		sortable:true
	},{
		header:"退货进价金额",
		dataIndex:'rpAmt',
		width:100,
		align:'right',
		sortable:true
	},{
		header:"售价",
		dataIndex:'sp',
		width:100,
		align:'right',
		sortable:true
	},{
		header:"退货售价金额",
		dataIndex:'spAmt',
		width:100,
		align:'right',
		sortable:true
	},{
		header:"批号",
		dataIndex:'batNo',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"效期",
		dataIndex:'expDate',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"发票号",
		dataIndex:'invNo',
		id:'invNo',
		width:100,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({
			id:'invNoField',
			allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
						var colindex=GetColIndex(IngDretDetailGrid,"invDate");
						IngDretDetailGrid.startEditing(cell[0],colindex);
					}
				}
			}
		})
	},{
		header:"发票日期",
		dataIndex:'invDate',
		id:'invDate',
		width:100,
		align:'left',
		sortable:true,
		renderer:Ext.util.Format.dateRenderer(DateFormat),
		editor: new Ext.ux.DateField({
			id:'invDateField2',
			allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
						var row = IngDretDetailGridDs.getAt(cell[0]);	
						var colindex=GetColIndex(IngDretDetailGrid,"invAmt");
						IngDretDetailGrid.startEditing(cell[0],colindex);	
					}
				}
			}
		})
	},{
		header:"退发票金额",
		dataIndex:'invAmt',
		id:'invAmt',
		width:100,
		align:'right',
		sortable:true,
		editor: new Ext.ux.NumberField({
			formatType : 'FmtRA',
			id:'invAmtField2',
			allowBlank:true
		})
	},{
		header:"随行单号",
		dataIndex:'sxNo',
		id:'sxNo',
		width:100,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({
			id:'sxNo',
			allowBlank:true
		})
	},{
		header:"备注",
		dataIndex:'Remark',
		id:'Remark',
		width:100,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({})
	},{
		header:"具体规格",
		dataIndex:'SpecDesc',
		width:100,
		align:'left',
		sortable:true
	}
]);

//初始化默认排序功能
IngDretDetailGridCm.defaultSortable = true;

//表格
var IngDretDetailGrid = new Ext.grid.EditorGridPanel({
	region: 'center',
	title:'明细记录',
	store:IngDretDetailGridDs,
	id:'IngDretDetailGrid',
	cm:IngDretDetailGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[AddDetailBT,'-',DelDetailBT,'-',GridColSetBT],
	clicksToEdit:1,
	bbar: new Ext.Toolbar({items:[NumAmount,RpAmount,SpAmount]}),
	listeners:{
		'beforeedit':function(e){
			if(Ext.getCmp('complete').getValue()){
				return false;
			}
			if(e.field=='qty'){
				if(UseItmTrack && e.record.get('HVFlag')=='Y'){
					e.cancel=true;
				}
			}
			if(e.field=="HVBarCode"){
				if(!UseItmTrack || e.record.get("HVFlag")=='N' || (e.record.get("ingrti")!="" && e.record.get("HVBarCode")!="")){
					e.cancel=true;
				}else{
					if(UseItmTrack && e.record.get("HVFlag")=="Y"){
						e.cancel=true;
					}
				}
			}
			if(e.field=="desc" && e.record.get("HVBarCode")!=""){
				e.cancel=true;
			}
		},
		'afteredit':function(e){
			if(e.field=='qty'){
				if(e.record.get("qty")>e.record.get("stkqty")){
					Msg.info("error","退货数量不能大于库存数量!");
					e.record.set("qty","");
				}else{
					e.record.set("rpAmt", accMul(e.value,e.record.get("rp"))); 
					e.record.set("spAmt", accMul(e.value,e.record.get("sp")));
					e.record.set("invAmt",accMul(e.value,e.record.get("rp")))
				}
			}
		},
		'rowcontextmenu' : rightClickFn
	}
});

IngDretDetailGrid.getView().on('refresh',function(grid){
	GetAmount();
});
var rightMenu=new Ext.menu.Menu({
	id:"rightClickMenu",
	items:[{
		id:"mnuDelete",
		text:"删除",
		handler:DeleteDetail
	}]
});

function rightClickFn(grid,rowindex,e){
	grid.getSelectionModel().select(rowindex,0);
	e.preventDefault();
	rightMenu.showAt(e.getXY());
}

var formPanel = new Ext.ux.FormPanel({
	title: '退货制单',
	tbar : [newBT,'-',findIngDret,'-',saveIngDret,'-',completeBT,'-',cancelCompleteBT,'-',deleteIngDret,'-',clearBT,'-',printBT],
	items:[{
		xtype:'fieldset',
		title:'退货单信息',
		style:'padding 0px 0px 0px 5px',
		layout: 'column',
		items : [{
			columnWidth: 0.25,
			layout:'form',
			items: [locField,groupField]
		},{
			columnWidth: 0.25,
			layout:'form',
			items: [Vendor,dretField]
		},{
			columnWidth: 0.20,
			layout:'form',
			items: [dateField]
		},{
			columnWidth: 0.15,
			layout:'form',
			items: [complete,transOrder]
		},{
			columnWidth: 0.15,
			layout:'form',
			items:[auditChk]
		}]
	}]
});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,IngDretDetailGrid],
		renderTo:'mainPanel'
	});
	
	RefreshGridColSet(IngDretDetailGrid,"DHCSTRETURNM");   //根据自定义列设置重新配置列
	
	if(gIngrt != ''){
		Select(gIngrt);
		IngDretDetailGridDs.load({params:{start:0,limit:999,sort:'',dir:'',ret:gIngrt}});
	}
});

function addDetailRow() {
	GetAmount();
	if(IngDretDetailGrid.activeEditor!=null){IngDretDetailGrid.activeEditor.completeEdit();}
	if ((gIngrt!="")&&(Ext.getCmp('complete').getValue()==true))
	{
		Msg.info('warning','当前退货单已完成,禁止增加明细记录!');
		return;
	}	
	var rowCount =IngDretDetailGrid.getStore().getCount();
	/*if(rowCount==0 || IngDretDetailGridDs.data.items[rowCount - 1].get('inclb')!=''){
		var NewRec = CreateRecordInstance(IngDretDetailGridDs.fields);
		IngDretDetailGridDs.add(NewRec);
	}*/
	var colIndex=GetColIndex(IngDretDetailGrid,"desc");
	var reasonId="";
	var retReason="";
	if(rowCount>0){
		if(IngDretDetailGridDs.data.items[rowCount - 1].get('inclb')==''){
		    IngDretDetailGrid.startEditing(IngDretDetailGridDs.getCount() - 1, colIndex);
			return;
		}
		var rowData = IngDretDetailGridDs.data.items[rowCount - 1];
		//退货原因
		if(gParam[7]=="Y"){
			reasonId=rowData.get("reasonId");
			retReason=rowData.get("retReason");
		}
	}
	var defaData={"reasonId":reasonId,"retReason":retReason}
	var NewRecord = CreateRecordInstance(IngDretDetailGridDs.fields,defaData)
	IngDretDetailGridDs.add(NewRecord);
	IngDretDetailGrid.getSelectionModel().select(IngDretDetailGridDs.getCount() - 1, colIndex);
	IngDretDetailGrid.startEditing(IngDretDetailGridDs.getCount() - 1, colIndex);
	setEditDisable();
	if (IngDretDetailGrid.getStore().getCount()>1){Ext.getCmp('Vendor').setDisabled(true);}
}

//加入退货列表
function AddList(row){
	if(row==null || row==""){
		return;
	}
	var cell=IngDretDetailGrid.getSelectionModel().getSelectedCell();
	var rowIndex=cell[0];
	var rowData = IngDretDetailGridDs.getAt(rowIndex);
	var HVBarCode=IngDretDetailGrid.store.getAt(rowIndex).get('HVBarCode');
	if(UseItmTrack && row.get('HVFlag')=='Y' && HVBarCode==""){
		Msg.info("warning","高值材料,请根据条码录入!");
		var colIndex=GetColIndex(IngDretDetailGrid,"HVBarCode");
		IngDretDetailGrid.startEditing(rowIndex,colIndex);
		return;
	}
	var INGRI = row.get('INGRI');
	var INCLB = row.get('INCLB');
	var code = row.get('code');
	var desc = row.get('desc');
	var mnf = row.get('mnf');
	var batch = row.get('batch');
	var sven = row.get('sven');
	var venid=row.get('venid');
	var pp = row.get('pp');
	var expdate = row.get('expdate');
	var uom = row.get('uom');
	var uomDesc = row.get('uomDesc');
	var idate = row.get('idate');
	var invDate = row.get('invDate');
	var recqty = row.get('recqty');
	if(recqty<0){
		Msg.info("warning","批次明细库存已红冲!!");
		return ;
		}
	var stkqty = row.get('stkqty');
	var rp = row.get('rp');
	var sp = row.get('sp');
	var invNo = row.get('invNo');
	var sxNo = row.get('sxNo');
	var cause = row.get('causeName');
	var causeId = row.get('causeId');
	var Drugform = row.get('Drugform');
	var spec = row.get('Spec');
	var buom=row.get('buom');
	var confac=row.get('confac');
	var HVFlag=row.get('HVFlag');
	var SpecDesc=row.get('SpecDesc');
	
	puomRp=rp;
	puomSp=sp;
	buomRp=puomRp/confac;
	buomSp=puomSp/confac;
	
	if(stkqty<=0){
		Msg.info("warning","该项目库存为零，不能退货!");
		return;
	}
	var selectVenid=Ext.getCmp("Vendor").getValue();
	if(selectVenid!=null & selectVenid!=""){
		if(selectVenid!=venid){    
			Msg.info("warning","该项目供应商不等于已选择项目的供应商，不能在同一张退货单上退货");
			return;
		}
	}else{
		addComboData(Vendor.getStore(),venid,sven);
		Ext.getCmp("Vendor").setValue(venid);
		Ext.getCmp('Vendor').setDisabled(true);
	}
	
	if(!(UseItmTrack && HVFlag=='Y')){
		var findIndex=IngDretDetailGridDs.findExact('ingri',INGRI,0);
		if(findIndex>=0 && findIndex!=rowIndex){
			Msg.info("warning","该入库明细数据已经存在于退货列表！")
			return;
		}
	}
	
	rowData.set('code',code);
	rowData.set('desc',desc);
	rowData.set('ingri',INGRI);
	rowData.set('inclb',INCLB);
	rowData.set('sp',sp);
	rowData.set('rp',rp);
	rowData.set('batNo',batch);
	rowData.set('expDate',expdate);
	addComboData(ItmUomStore,uom,uomDesc);
	rowData.set('uom',uom);
	rowData.set('uomDesc',uomDesc);
	rowData.set('spec',spec);
	rowData.set('manf',mnf);
	rowData.set('stkqty',stkqty);
	rowData.set('buom',buom);
	rowData.set('confac',confac);
	rowData.set('HVFlag',HVFlag);
	rowData.set('SpecDesc',SpecDesc);
	
	if(UseItmTrack && HVFlag=='Y'){
		rowData.set('qty',1);
		rowData.set("rpAmt", row.get("rp")); 
		rowData.set("spAmt", row.get("sp")); 
		rowData.set("invAmt", row.get("rp"));
		var colIndex=GetColIndex(IngDretDetailGrid,"reasonId");
		IngDretDetailGrid.startEditing(rowIndex,colIndex);
	}else{
		var colIndex=GetColIndex(IngDretDetailGrid,"qty");
		IngDretDetailGrid.startEditing(rowIndex,colIndex);
	}
	saveIngDret.enable();
	
	if (IngDretDetailGrid.getStore().getCount()>0){
		Ext.getCmp('Vendor').setDisabled(true);
	}
}
//新建退货单
function NewRet()
{
	clearData();
	saveIngDret.disable ();
	addDetailRow();
}

//清空页面
function clearData(){
	gIngrt="";
	Ext.getCmp("Vendor").setValue("");
	Ext.getCmp("dret").setValue("");
	Ext.getCmp("complete").setValue(false);
	Ext.getCmp("transOrder").setValue(false);
	Ext.getCmp("audited").setValue(false);
	Ext.getCmp("dateField").setValue(new Date());
	IngDretDetailGridDs.removeAll();
	
	setEditEnable();
	//清除可能存在href变量
	CheckLocationHref();
}


/*退货单完成*/
function Complete() {
	if((gIngrt!="")&&(gIngrt!=null)){
		Ext.Ajax.request({
			url:URL+'?actiontype=complet&ret='+gIngrt,
			waitMsg:'执行中...',
			failure: function(result, request) {
				Msg.info("error","请检查网络连接!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					Msg.info("success","设置完成成功!");
					Select(gIngrt);
					IngDretDetailGridDs.load({params:{start:0,limit:999,sort:'',dir:'',ret:gIngrt}});
				}else{
					Msg.info("error","设置完成失败!"+jsonData.info);
				}
			},
			scope: this
		});
	}
}

/*取消完成*/
function cancelComplete() {
	if((gIngrt!="")&&(gIngrt!=null)){
		Ext.Ajax.request({
			url:URL+'?actiontype=cancelComompleted&ret='+gIngrt,
			waitMsg:'执行中......',
			failure: function(result, request) {
				Msg.info("error","请检查网络连接!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					Msg.info("success","取消完成成功!");
					Select(gIngrt);
					IngDretDetailGridDs.load({params:{start:0,limit:999,sort:'ingrti',dir:'desc',ret:gIngrt}});
				}else{
					switch (jsonData.info)
					{
					case '-1':
						Msg.info("warning","退货单不存在!");
						break;
					case '-10':
						Msg.info("warning","退货单已经审核,禁止取消完成!");
						break;
					case '-2':
						Msg.info("warning","退货单未完成!");
						break;
					case '-99':
						Msg.info("error","加锁失败!");
						break;
					default:
						Msg.info("error","取消完成失败!"+jsonData.info);
						break;
					}
				}
			},
			scope: this
		});
	}
}
function Select(Ingrt)
{
	if((Ingrt==null)||(Ingrt=="")){
		return;
	}
	gIngrt=Ingrt;
	Ext.Ajax.request({
		url:URL+'?actiontype=getOrder&rowid='+Ingrt,
		waitMsg:'查询中...',
		failure: function(result, request) {
			Msg.info("error","请检查网络连接!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				var strData=jsonData.info;
				var arrData=strData.split("^");
				Ext.getCmp('dret').setValue(arrData[6]);
				
				addComboData(Vendor.getStore(),arrData[1],arrData[20]);
				Ext.getCmp('Vendor').setValue(arrData[1]);
				addComboData(locField.getStore(),arrData[7],arrData[21]);
				Ext.getCmp("locField").setValue(arrData[7]);
				var compFlag=(arrData[4]=='Y'?true:false);
				Ext.getCmp("complete").setValue(compFlag);
				var adjchqFlag=(arrData[11]=='Y'?true:false);
				Ext.getCmp("transOrder").setValue(adjchqFlag);
				addComboData(null,arrData[14],arrData[24],groupField);
				Ext.getCmp('groupField').setValue(arrData[14]);
				
				var audited=(arrData[15]=='Y'?true:false);  //已审核
				Ext.getCmp("audited").setValue(audited);
				var ingrdate=arrData[22];
				Ext.getCmp("dateField").setValue(ingrdate);
				//alert(compFlag);
				if(compFlag==true){
					saveIngDret.setDisabled(true);
					completeBT.setDisabled(true);
					//newBT.setDisabled(true);
				}else{
					saveIngDret.setDisabled(false);
					completeBT.setDisabled(false);
					//newBT.setDisabled(false);
				}
			}
		
			setEditDisable();
			Ext.getCmp('Vendor').setDisabled(true);
		},	
		scope: this
	});
	
}

//取得指定单位的入库价格（进价+售价）
//ingri - 入库明细rowid
//uom - 单位rowid
function SetIngriPrice(rec,ingri,uom){
	Ext.Ajax.request({
		url:URL+'?actiontype=getIngriPrice'+"&ingri="+ingri+"&uom="+uom,
		failure:function(){
			Msg.info("error","失败!");
		},
		success:function(result, request){
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				var strData=jsonData.info;
				var arrData=strData.split("^");
				var rp=arrData[0];
				var sp=arrData[1];
				rec.set('rp',rp);
				rec.set('sp',sp);
				var qty=rec.get('qty');
				var rpAmt=accMul(rp,qty);
				var spAmt=accMul(sp,qty);
				rec.set('rpAmt',rpAmt);
				rec.set('spAmt',spAmt);
				rec.set('invAmt',rpAmt);
			}
		}
	})
}

//设置可编辑组件的disabled属性
function setEditDisable(){
	Ext.getCmp('groupField').setDisabled(true);
	Ext.getCmp('locField').setDisabled(true);
}
//放开可编辑组件的disabled属性
function setEditEnable(){
	Ext.getCmp('groupField').setDisabled(false);
	Ext.getCmp('locField').setDisabled(false);
	Ext.getCmp('Vendor').setDisabled(false);
}