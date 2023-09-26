// /名称: 入库单制单
// /描述: 入库单制单
// /编写者：zhangdongmei
// /编写日期: 2012.06.27
var impWindow = null;
var gUserId = session['LOGON.USERID'];
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
var gHospId=session['LOGON.HOSPID'];

var loadMask=null;
var colArr=[];
if(gParam.length<1){
	GetParam();  //初始化参数配置
}
var gPhaMulFlag = gParam[18];		//物资弹窗是否多选
var AllowEnterSpec=gParam[22]=='Y'?true:false;

//取高值管理参数
var UseItmTrack="";
var CreBarByIngdrec="";     //是否在入库时候生成高值条码参数
var PhaOrderHVFlag = '';	//物资弹窗的高值过滤标志(Y:仅高值,N:仅低值,'':所有)
if(gItmTrackParam.length<1){
	GetItmTrackParam();
	UseItmTrack=gItmTrackParam[0]=='Y'?true:false;
	CreBarByIngdrec=gItmTrackParam[3]=='Y'?true:false;
	if(UseItmTrack && !gHVINGdRec && !CreBarByIngdrec){
		PhaOrderHVFlag = 'N';
	}
}

var isBarcodeEdit=true,isIncdescEdit=true;
if(!UseItmTrack){
	if(gHVINGdRec){
		isIncdescEdit=false;
		Msg.info("warning","此菜单不使用!");
	}else{
		isBarcodeEdit=false;
	}
}else{
	if(gHVINGdRec){	//高值菜单
		isIncdescEdit=false;
	}else{			//非高值菜单
		isBarcodeEdit=false;
	}
}
	
var PhaLoc=new Ext.ux.LocComboBox({
	fieldLabel : '入库部门',
	id : 'PhaLoc',
	name : 'PhaLoc',
	anchor:'90%',
	emptyText : '入库部门...',
	groupId:gGroupId,
	stkGrpId : "StkGrpType",
	childCombo : 'Vendor'
});

var VirtualFlag = new Ext.form.Checkbox({
	hideLabel:true,
	boxLabel : '虚库',
	id : 'VirtualFlag',
	name : 'VirtualFlag',
	anchor : '90%',
	checked : false,
	listeners:{
		check:function(chk,bool){
			if(bool){
				var phaloc=Ext.getCmp("PhaLoc").getValue();
				var url="dhcstm.utilcommon.csp?actiontype=GetMainLoc&loc="+phaloc;
				var response=ExecuteDBSynAccess(url);
				var jsonData=Ext.util.JSON.decode(response);
				if(jsonData.success=='true'){
					var info=jsonData.info;
					var infoArr=info.split("^");
					var vituralLoc=infoArr[0],vituralLocDesc=infoArr[1];
					addComboData(Ext.getCmp("PhaLoc").getStore(),vituralLoc,vituralLocDesc);
					Ext.getCmp("PhaLoc").setValue(vituralLoc);
				}
			}else{
				SetLogInDept(Ext.getCmp("PhaLoc").getStore(), "PhaLoc");
			}
		}
	}
});
var VendorParmasObj;
if(CommParObj['ApcScg'] == 'Y'){
	VendorParmasObj = {LocId : 'PhaLoc',ScgId : 'StkGrpType'};
}else{
	VendorParmasObj = {LocId : 'PhaLoc'};
}

var Vendor=new Ext.ux.VendorComboBox({
	id : 'Vendor',
	name : 'Vendor',
	anchor:'90%',
	params : VendorParmasObj,
	listeners : {
		select : function(){
			if(DetailGrid.getStore().getCount() == 0){
				//AddBT.handler();
			}
		}
	}
});
var INFOPbCarrier = new Ext.ux.ComboBox({
		fieldLabel: '配送商',
		id: 'INFOPbCarrier',
		name: 'INFOPbCarrier',
		store: CarrierStore,
		valueField: 'RowId',
		displayField: 'Description',
		filterName: 'CADesc'
	});
// 物资类组
var StkGrpType=new Ext.ux.StkGrpComboBox({ 
	id : 'StkGrpType',
	name : 'StkGrpType',
	StkType:App_StkTypeCode,     //标识类组类型
	LocId:gLocId,
	UserId:gUserId,
	anchor:'90%',
	listeners:{
		select:function(){
			if(CommParObj['ApcScg'] == 'Y'){
				Ext.getCmp("Vendor").setValue("");
			}
			Ext.getCmp("StkCat").setValue('');
		}
	}
}); 
// 库存分类
var StkCat = new Ext.ux.ComboBox({
	fieldLabel : '库存分类',
	id : 'StkCat',
	name : 'StkCat',
	store : StkCatStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'StkCatName',
	params:{StkGrpId:'StkGrpType'}
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
			var cell = DetailGrid.getSelectionModel().getSelectedCell();
			var record = DetailGrid.getStore().getAt(cell[0]);
			var IncRowid = record.get("IncId");	
			var desc=this.getRawValue();
			this.store.removeAll();    //load之前remove原记录，否则容易出错
			this.store.setBaseParam('SpecItmRowId',IncRowid)
			this.store.setBaseParam('desc',desc)
			this.store.load({params:{start:0,limit:this.pageSize}})
		} ,
		'specialkey' : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				if(setEnterSort(DetailGrid,colArr)){
					addNewRow();
				}
			}
		}
	})
});
// 入库类型
var OperateInType = new Ext.form.ComboBox({
	fieldLabel : '入库类型',
	id : 'OperateInType',
	name : 'OperateInType',
	anchor : '90%',
	store : OperateInTypeStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : true,
	triggerAction : 'all',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	valueNotFoundText : ''
});
// 默认选中第一行数据
setDefaultInType();
// 入库单号
var InGrNo = new Ext.form.TextField({
	fieldLabel : '入库单号',
	id : 'InGrNo',
	name : 'InGrNo',
	anchor : '90%',
	disabled : true
});

// 入库日期
var InGrDate = new Ext.ux.DateField({
	fieldLabel : '入库日期',
	id : 'InGrDate',
	name : 'InGrDate',
	anchor : '90%',
	value : new Date(),
	disabled : true
});
// 请求部门
var RequestLoc = new Ext.ux.LocComboBox({
			fieldLabel : '接收科室',
			id : 'RequestLoc',
			name : 'RequestLoc',
			anchor:'90%',
			width : 120,
			emptyText : '接收科室...',
			defaultLoc:{}
});

// 采购人员
if(IngrParamObj.UseAllUserAsPur == 'Y'){
	var PurchaseUser = new Ext.ux.ComboBox({
		id : 'PurchaseUser',
		fieldLabel : '采购人员',
		store : AllUserStore,	//取所有人员
		filterName : 'Desc'
	});
}else{
	var PurchaseUser = new Ext.ux.ComboBox({
		fieldLabel : '采购人员',
		id : 'PurchaseUser',
		store : PurchaseUserStore,
		valueField : 'RowId',
		displayField : 'Description'
	});
	PurchaseUserStore.load({
		callback : function(r,options,success){  
			for(var i=0;i<r.length;i++){ 
				if(PurchaseUserStore.data.items[i].data["Default"]=="Y"){ 
					PurchaseUser.setValue(PurchaseUserStore.data.items[i].data["RowId"]);   
				}  
			}
		}
	});
}

var AcceptUser = new Ext.ux.ComboBox({
	fieldLabel : '验收人',	
	id : 'AcceptUser',
	anchor : '90%',
	store : UStore,
	filterName : 'name',
	params : {locId:'PhaLoc'}
});

// 备注
var InGrRemarks = new Ext.form.TextArea({
	id:'InGrRemarks',
	fieldLabel:'备注',
	allowBlank:true,
	height:50,
	emptyText:'备注...',
	anchor:'90%',
	selectOnFocus:true
});
var InPoNumField= new Ext.form.TextField({
	fieldLabel : '随行单',
	id : 'InPoNumField',
	name : 'InPoNumField',
	anchor : '90%',
	listeners : {
	 specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				SynInGdRec(field.getValue());
			}
		}
	}
});
function SynInGdRec(barcode){
	var url = DictUrl
			+ "sciaction.csp?actiontype=CreateInGdRecBySciPo";
	var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		params:{BarCode:barcode,LocId:gLocId,user:gUserId},
		waitMsg : '处理中...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON
					.decode(result.responseText);
			if (jsonData.success == 'true') {
				// 刷新界面
				var IngrRowid = jsonData.info;
				Msg.info("success", "保存成功!");
				gIngrRowid=IngrRowid;
				Query(IngrRowid);
				if(gParam[3]=='Y'){
					PrintRec(IngrRowid,'Y');
				}
			} else {
				var ret=jsonData.info;
				if(ret==-99){
					Msg.info("error", "加锁失败,不能保存!");
				}else if(ret==-2){
					Msg.info("error", "生成入库单号失败,不能保存!");
				}else if(ret==-3){
					Msg.info("error", "保存入库单失败!");
				}else if(ret==-912){
					Msg.info("error", "该随行单没有要保存的入库信息！");
				}else if(ret==-911){
					Msg.info("error", "随行单完成失败！");
				}else if(ret==-4){
					Msg.info("error", "未找到需更新的入库单,不能保存!");
				}else if(ret==-5){
					Msg.info("error", "保存入库单明细失败!");
				}else {
					Msg.info("error", "保存不成功："+ret);
				}
			}
			loadMask.hide();
		},
		scope : this
	});
}
	
// 完成标志
var CompleteFlag = new Ext.form.Checkbox({
	boxLabel : '完成',
	id : 'CompleteFlag',
	name : 'CompleteFlag',
	anchor : '90%',
	checked : false,
	disabled:true
});
	
// 赠药入库标志
var PresentFlag = new Ext.form.Checkbox({
	boxLabel : '捐赠',
	id : 'PresentFlag',
	name : 'PresentFlag',
	anchor : '90%',
	checked : false,
	listeners: {
		'check':function(cb,checked){
			if(checked==true){
				Msg.info("warning","您勾选了捐赠标志!")
			}		
		}
	}
});

// 调价换票标志
var ExchangeFlag = new Ext.form.Checkbox({		
	id : 'ExchangeFlag',
	name : 'ExchangeFlag',
	anchor : '100%',
	checked : false,
	boxLabel:'调价换票',
	listeners: {
		'check':function(cb,checked){
			if(checked==true){
				Msg.info("warning","您勾选了调价换票标志!")
			}		
		}
	}
});

var SourceOfFund = new Ext.ux.ComboBox({
	fieldLabel : '资金来源',
	id : 'SourceOfFund',
	name : 'SourceOfFund',
	anchor : '90%',
	store : SourceOfFundStore,
	valueField : 'RowId',
	filterName:'Desc',
	displayField : 'Description'
});
// 默认选中第一行数据
setDefaultSourceOfFund();
// 打印入库单按钮
var PrintBT = new Ext.Toolbar.Button({
	id : "PrintBT",
	text : '打印',
	tooltip : '打印入库单票据',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		if((gParam[26]=="N")&&(Ext.getCmp('CompleteFlag').getValue()==false)){
			Msg.info('warning','不允许打印未完成的入库单!');
			return;
		}
		PrintRec(gIngrRowid);
	}
});

var EvaluateBT = new Ext.Toolbar.Button({
	id : "EvaluateBT",
	text : '供应商评价',
	tooltip : '点击评价供应商',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function() {
		if(gIngrRowid=="" || gIngrRowid==null){
			Msg.info("error", "请选择入库单!");
			return false;			
		}else{
			evaluateWin(gIngrRowid);
		}
	}
});

// 查询入库单按钮
var SearchInGrBT = new Ext.Toolbar.Button({
	id : "SearchInGrBT",
	text : '查询',
	tooltip : '查询已保存的入库单',
	width : 70,
	height : 30,
	iconCls : 'page_find',
	handler : function() {
		DrugImportGrSearch(DetailStore,Query);
	}
});
	
function ImpByPoFN() {
	ImportByPo(Query);
}

function ImpBySciPoFN() {
	ImportBySciPo(Query);
}

// 清空按钮
var ClearBT = new Ext.Toolbar.Button({
	id : "ClearBT",
	text : '清空',
	tooltip : '清空当前页面的编辑信息',
	width : 70,
	height : 30,
	iconCls : 'page_clearscreen',
	handler : function() {
		if (isDataChanged(HisListTab,DetailGrid)){
			Ext.Msg.show({
				title:'提示',
				msg: '已经对该单数据做了修改，继续执行将丢失掉修改，继续吗？',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
					if (btn=='yes') {
						clearData();
						SetFormOriginal(HisListTab);
					}
				}
			})
		}else{
			clearData(); 
			SetFormOriginal(HisListTab);
		}
	}
});
// 完成按钮
var CompleteBT = new Ext.Toolbar.Button({
	id : "CompleteBT",
	text : '完成',
	tooltip : '设置当前单据为<完成>',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function() {
		// 判断入库单是否已完成
		var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
		if (CompleteFlag != null && CompleteFlag != 0) {
			Msg.info("warning", "入库单已完成!");
			return;
		}		
		if (gIngrRowid == null || gIngrRowid=="") {
			Msg.info("warning", "没有需要完成的入库单!");
			return;
		}
		var rowData = DetailStore.getAt(0);
		if(rowData==""||rowData==undefined){
			Msg.info("warning","没有需要完成的数据明细!");
			return;
		}
		
		//预算结余判断
		var HRPBudgResult = HRPBudg();
		if(HRPBudgResult === false){
			return;
		}
		
		var mainData=GetIngrMainData(gIngrRowid);
		var mainArr=mainData.split("^");
		var phaLocDesc=mainArr[11];
		if(gHVINGdRec){
			Ext.Msg.show({
				title:'提示',
				msg: '当前入库科室为"'+phaLocDesc+'", 是否继续？',
				buttons: Ext.Msg.YESNO,
				fn: function(b,t,o){
					if (b=='yes'){
						Complete();
					}
				},
				icon: Ext.MessageBox.QUESTION
			});
		}else{
			Complete();
		}
	}
});

// 取消完成按钮
var CancleCompleteBT = new Ext.Toolbar.Button({
	id : "CancleCompleteBT",
	text : '取消完成',
	tooltip : '取消单据的<完成>标志，恢复到可编辑状态',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function() {
		CancleComplete();
	}
});

// 删除按钮
var DeleteBT = new Ext.Toolbar.Button({
	id : "DeleteBT",
	text : '删除',
	tooltip : '删除当前单据',
	width : 70,
	height : 30,
	iconCls : 'page_delete',
	handler : function() {
		deleteData();
	}
});
	
var viewImage= new Ext.Toolbar.Button({
	text : '入库图片',
	tooltip : '查看入库图片',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function() {
		if ((gIngrRowid=='')||(gIngrRowid==undefined)) {
			Msg.info("error","请选择入库单!");
			return false;
		}
		var PicStore = new Ext.data.JsonStore({
			url : 'dhcstm.synpicaction.csp?actiontype=GetInGdRecProductImage',
			root : 'rows',
			totalProperty : "results",
			fields : ["rowid","picsrc","imgtype"]
		});
		var type="";
		ShowInGdRecProductImageWindow(PicStore,gIngrRowid,type);
	}
});      

var ImportButton = new Ext.SplitButton({
		text: '导入',
		width : 70,
		height : 30,
		iconCls : 'page_add',
		tooltip: '下拉导入按钮',
		menu : {
			items: [{
				text: '<b>引入文本文件</b>', handler: ImpFromTxtFN
			},{
				text: '<b>导入Excel</b>', handler: ImportExcelFN
			},{
				text: '<b>导入订单</b>', handler: ImpByPoFN
			},{
				text: '<b>导入云平台订单</b>', handler: ImpBySciPoFN
			},{
				text: '<b>下载Excel模板</b>', handler: ExportExcel
			}]
		}
})
	
function ImpFromTxtFN() {
	var CmpFlag = Ext.getCmp("CompleteFlag").getValue();
	if (CmpFlag != null && CmpFlag != 0) {
		Msg.info("warning", "入库单已完成不可修改!");
		return;
	}
	if (Ext.getCmp('Vendor').getValue()==''){
		Msg.info('error','请选择供应商!');
		Ext.getCmp('Vendor').focus();
		return;
	}
	if (Ext.getCmp('StkGrpType').getValue()==''){
		Msg.info('warning','请选择类组!');
		return;
	}			
	var fd = new ActiveXObject("MSComDlg.CommonDialog");
	fd.Filter = "Text(*.txt)|*.txt";
	fd.FilterIndex = 1;	
	// 必须设置MaxFileSize. 否则出错
	fd.MaxFileSize = 32767;
	// 显示对话框
	fd.ShowOpen();
	var fileName=fd.FileName;
	if (fileName=='') return;
	MakeRecFromTxt(fileName,impLine);			
}

function ImportExcelFN(){
	var CmpFlag = Ext.getCmp("CompleteFlag").getValue();
	if (CmpFlag != null && CmpFlag != 0) {
		Msg.info("warning", "入库单已完成不可修改!");
		return;
	}
	if (Ext.getCmp('Vendor').getValue()==''){
		Msg.info('error','请选择供应商!');
		Ext.getCmp('Vendor').focus();
		return;
	}
	if (Ext.getCmp('StkGrpType').getValue()==''){
		Msg.info('warning','请选择类组!');
		return;
	}
	if (impWindow){
		impWindow.ShowOpen();
	}else{
		impWindow = new ActiveXObject("MSComDlg.CommonDialog");
		impWindow.Filter = "Excel(*.xls;*xlsx)|*.xls;*.xlsx";
		impWindow.FilterIndex = 1;
		// 必须设置MaxFileSize. 否则出错
		impWindow.MaxFileSize = 32767;
		impWindow.ShowOpen();
	}
	
	var fileName = impWindow.FileName;
	if (fileName==''){
		Msg.info('error','请选择Excel文件!');
		return;
	}
	ReadFromExcel(fileName, impLine);
}
///根据行数据导入一条记录
function impLine(s, rowNumber)
{
	var ss=s.split('\t');
	try {
//			代码 ------- 发票号---- - 数量----- - 单价----- 金额 - ----批号- ------效期------
		var inciCode =ss[0];
		var invNo =ss[1];
		var qty =ss[2];
		var rp =ss[3];
		var amt =ss[4];
		var batNo =ss[5];
		var expDate =ss[6];
		var hosp=session["LOGON.HOSPID"];
		if(Ext.isEmpty(inciCode)){
			return false;
		}
		var url="dhcstm.drugutil.csp?actiontype=GetItmInfoByCode&ItmCode="+inciCode+"&HospId="+hosp ;	
		var responseText = ExecuteDBSynAccess(url);		
		var jsonData = Ext.util.JSON.decode(responseText);
		if (jsonData.success == 'true') {
			var list = jsonData.info.split("^");		
			var inci=list[15];
			var inciCode=list[0];
			var IncDesc=list[1];
			var Spec=list[16];
			var Sp=list[11];
			var ManfId=list[17];
			var Manf=list[18];
			var IngrUomId=list[8];
			var IngrUom=list[9];
			var BUomId=list[6];
			var NotUseFlag=list[19];
			var BatchReq = list[20];
			var ExpReq = list[21];			
			if(NotUseFlag=='Y'){
				Msg.info('warning', '第'+rowNumber+'行: '+inciCode+' 为"不可用"状态!');
				return;
			}
			colArr=sortColoumByEnterSort(DetailGrid); //将回车的调整顺序初始化好
			// 新增一行
			addNewRow();	
			addComboData(PhManufacturerStore,ManfId,Manf);
			addComboData(ItmUomStore,IngrUomId,IngrUom);
			var row=DetailGrid.getStore().getCount();
			var rec=DetailGrid.getStore().getAt(row-1);			
			rec.set('IncCode',inciCode);
			rec.set('InvNo',invNo);			
			rec.set('RecQty',qty);
			rec.set('Rp',rp);
			rec.set('RpAmt',amt);
			rec.set('BatchNo',batNo);
			var d=new Date();
			d = Date.parseDate(expDate, "Y-n-j");
			rec.set('ExpDate',d);					
			rec.set('IncId',inci);
			rec.set('IncDesc',IncDesc);
			rec.set('Spec',Spec);
			rec.set('Sp',Sp);
			rec.set('ManfId',ManfId);
			rec.set('IngrUomId',IngrUomId);
			rec.set('BUomId',BUomId);
			rec.set('BatchReq',BatchReq);
			rec.set('ExpReq',ExpReq);			
		}else{
			Msg.info('error','第'+rowNumber+'行读取错误!');
			return false ;				
		}	
		// 变更按钮是否可用
		//查询^清除^新增^保存^删除^完成^取消完成
		changeButtonEnable("0^1^1^1^1^1^0^1^1");
		SetFieldDisabled(true);
		return true;
	}catch (e){
		Msg.info('error','读取数据错误!');
		return false;
	}

}	

/**
 * 清空方法
 */
function clearData() {
	gIngrRowid="";
	Ext.getCmp("Vendor").setValue("");
	Ext.getCmp("SourceOfFund").setValue("");
	Ext.getCmp("StkGrpType").setValue("");
	Ext.getCmp("StkGrpType").getStore().load();
	Ext.getCmp("StkCat").setValue("");
	Ext.getCmp("StkCat").getStore().load();
	Ext.getCmp("InGrNo").setValue("");
	Ext.getCmp("InGrDate").setValue(new Date());
	Ext.getCmp("CompleteFlag").setValue(false);
	Ext.getCmp("PresentFlag").setValue(false);
	Ext.getCmp("ExchangeFlag").setValue(false);
	Ext.getCmp("InGrRemarks").setValue("");
	Ext.getCmp("VirtualFlag").setValue(false);
	SetLogInDept(PhaLoc.getStore(),"PhaLoc");
	Ext.getCmp("RequestLoc").setValue("");
	Ext.getCmp("OperateInType").setValue(""); //入库类型
	setDefaultInType();
	setDefaultSourceOfFund();
	Ext.getCmp("InPoNumField").setValue("");  //随行单
	Ext.getCmp("PurchaseUser").setValue("");  // 采购员
	Ext.getCmp("AcceptUser").setValue("");
	Ext.getCmp("INFOPbCarrier").setValue("");
	
	DetailGrid.store.removeAll();
	DetailGrid.getView().refresh();
	//查询^清除^新增^保存^删除^完成^取消完成
	changeButtonEnable("1^1^1^0^0^0^0^1^1");
	SetFieldDisabled(false);
	Ext.getCmp("Vendor").setDisabled(false);
	//清除可能存在href变量
	CheckLocationHref();
}

function ExportExcel(){
	window.open("../scripts/dhcstm/InGdRec/入库单导入模板.xls","_blank");
}
var DeleteDetailBT=new Ext.Toolbar.Button({
	id:'DeleteDetailBT',
	text:'删除一条',
	tooltip:'删除一条入库明细记录',
	width:70,
	height:30,
	iconCls:'page_delete',
	handler:function(){
		deleteDetail();
	}
});
// 增加按钮
var AddBT = new Ext.Toolbar.Button({
	id : "AddBT",
	text : '增加一条',
	tooltip : '增加一条入库明细记录',
	width : 70,
	height : 30,
	iconCls : 'page_add',
	handler : function() {
	var NewGridFlag = (DetailGrid.getStore().getCount() == 0);
		// 判断入库单是否已审批
		var CmpFlag = Ext.getCmp("CompleteFlag").getValue();
		if (CmpFlag != null && CmpFlag != 0) {
			Msg.info("warning", "入库单已完成不可修改!");
			return;
		}
		// 判断是否选择入库部门和供货厂商
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc == null || phaLoc.length <= 0) {
			Msg.info("warning", "请选择入库部门!");
			return;
		}
		var vendor = Ext.getCmp("Vendor").getValue();
		if (vendor == null || vendor.length <= 0) {
			Msg.info("warning", "请选择供应商!");
			Ext.getCmp('Vendor').focus();
			return;
		}
		if (Ext.getCmp('StkGrpType').getValue()==''){
			Msg.info('warning','未选择类组，请谨慎核实数据!');
			//return;
		}  
		var operateInType = Ext.getCmp("OperateInType").getValue();
		if ((gParam[8]=="Y")&(operateInType == null || operateInType.length <= 0)) {
			Msg.info("warning", "请选择入库类型!");
			Ext.getCmp("OperateInType").focus();
			return;
		}
		
		if (gParam[15]=="Y") {
			Msg.info("warning", "入库单需和订单保持一致,不能增加!");
			return;
		}
		var SourceOfFund = Ext.getCmp("SourceOfFund").getValue();
		if((SourceOfFund==null || SourceOfFund=="")&&gParam[29]=="Y"){
			Msg.info("warning", "资金来源不能为空!");
			Ext.getCmp("SourceOfFund").focus();
			return false;
		}
		colArr=sortColoumByEnterSort(DetailGrid); //将回车的调整顺序初始化好
		// 新增一行
		addNewRow();
		// 变更按钮是否可用
		//查询^清除^新增^保存^删除^完成^取消完成
		changeButtonEnable("0^1^1^1^1^1^0^1^1");
		SetFieldDisabled(true);
		if(!NewGridFlag){
			Ext.getCmp("StkGrpType").setDisabled(true);
		}

	}
});

function SetFieldDisabled(bool){
	Ext.getCmp("PhaLoc").setDisabled(bool);
	//Ext.getCmp("Vendor").setDisabled(bool);
	//Ext.getCmp("StkGrpType").setDisabled(bool);
	Ext.getCmp("StkCat").setDisabled(bool);
}
	
/**
 * 新增一行
 */
function addNewRow() {
	if(DetailGrid.activeEditor!=null){DetailGrid.activeEditor.completeEdit();}
	var inciIndex=GetColIndex(DetailGrid,"IncDesc");
	var barcodeIndex=GetColIndex(DetailGrid,"HVBarCode");
	var col=gHVINGdRec?barcodeIndex:inciIndex;
	var lastInvNo="",lastInvDate="";
	// 判断是否已经有添加行
	var rowCount = DetailGrid.getStore().getCount();
	if (rowCount > 0) {
		var rowData = DetailStore.data.items[rowCount - 1];
		var data = rowData.get("IncId");
		if (data == null || data.length <= 0) {
			DetailGrid.startEditing(DetailStore.getCount() - 1, col);
			return;
		}
		//==============与上次入库物资名称和进价进行比较==============
		if(gParam[31]=="Y"){
			var inci=data;
			var rprice=rowData.get("Rp");
			var inciDesc=rowData.get("IncDesc");
			var url = 'dhcstm.ingdrecaction.csp?actiontype=CheckNamePrice&inci='+inci+'&rp='+rprice;					
			var CheckResult = ExecuteDBSynAccess(url);
			var CheckJsonData = Ext.util.JSON.decode(CheckResult)				
			if (CheckJsonData.success == 'true') {
				if(CheckJsonData.info == -1){
					Msg.info("warning", inciDesc + '的名称已修改!');
				}else if(CheckJsonData.info == -2){
					Msg.info("warning", inciDesc + '的进价已调整!');
				}
			}
		}
		if(gParam[14]=='Y'){
			if(rowCount>0){
				var lastrowData = DetailStore.data.items[rowCount - 1];
				lastInvNo=lastrowData.get('InvNo');
				lastInvDate=lastrowData.get('InvDate');
				rowData.set('InvNo',lastInvNo);
				rowData.set('InvDate',lastInvDate);
			}
		}
	}
	var defaData = {InvNo : lastInvNo,InvDate:lastInvDate};
	var NewRecord = CreateRecordInstance(DetailStore.fields,defaData);
	DetailStore.add(NewRecord);	
	DetailGrid.startEditing(DetailStore.getCount() - 1, col);
}

// 保存按钮
var SaveBT = new Ext.ux.Button({
	id : "SaveBT",
	text : '保存',
	tooltip : '保存当前的单据',
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
		if(DetailGrid.activeEditor != null){
			DetailGrid.activeEditor.completeEdit();
		}
		if(CheckDataBeforeSave()==true){
			if(BatSpFlag != '1' && IngrParamObj.AllowAspWhileReceive == 'Y'){
				var rowCount = DetailGrid.getStore().getCount();
				AdjPriceShow(0, rowCount-1);
			}else{
				saveOrder();
			}
		}
	}
});

function AdjPriceShow(ind,rowCount){
	try{
		var record = DetailStore.getAt(ind);
		var IncRowid=record.get("IncId");
	}catch(e){}
	if(Ext.isEmpty(IncRowid)){
		//检索完所有非空行
		saveOrder();
		return;
	}
	var AdjSpUomId=record.get("IngrUomId");
	var uomdesc=record.get("IngrUom");
	var ResultSp= record.get("Sp"); 
	var ResultRp=record.get("Rp");
	var incicode=record.get("IncCode");
	var incidesc=record.get("IncDesc");
	var StkGrpType = Ext.getCmp("StkGrpType").getValue();
	var strParam=gGroupId+"^"+gLocId+"^"+gUserId
	var url=DictUrl + "ingdrecaction.csp?actiontype=GetPrice&InciId="+IncRowid+"&UomId="+AdjSpUomId+"&StrParam="+strParam;
	var pricestr=ExecuteDBSynAccess(url);
	var priceArr=pricestr.split("^");
	var PriorRp=priceArr[0];
	var PriorSp=priceArr[1];
	var data = IncRowid + "^" + AdjSpUomId + "^" + PriorSp + "^" + ResultRp + "^" + gUserId
			+ "^" +PriorRp+"^"+ResultSp+"^"+StkGrpType+"^"+gLocId+ "^" +incicode
			+ "^" +incidesc+ "^" +uomdesc;
	var adjspFlag=tkMakeServerCall("web.DHCSTM.INAdjSalePrice","CheckItmAdjSp",IncRowid,""); //如果存在调价单则不进行提示
	if((IncRowid!="")&&(PriorSp!=ResultSp)&&(adjspFlag!=1)){
		var ret=confirm(incidesc+"价格发生变化，是否生成调价单?");
		if (ret==true){
			SetAdjPrice(data,ind,rowCount,AdjPriceShow);	//循环调用
		}else{
			if(ind >= rowCount){
				saveOrder();
			}else{
				AdjPriceShow(++ind,rowCount);
			}
		}
	}else if((IncRowid!="")&&(PriorSp!=ResultSp)&&(adjspFlag==1)){
		var ret=confirm(incidesc+"价格发生变化，存在未审核的调价单，不能再次生成，是否继续?");
		if (ret==true){
			if(ind >= rowCount){
				saveOrder();
			}else{
				AdjPriceShow(++ind,rowCount);
			}
		}else{
			return;
		}
	}else{
		if(ind >= rowCount){
			saveOrder();
		}else{
			AdjPriceShow(++ind,rowCount);
		}
	}
}
	
/**
 * 保存入库单前数据检查
 */		
function CheckDataBeforeSave() {
	var nowdate = new Date();
	// 判断入库单是否已审批
	var CmpFlag = Ext.getCmp("CompleteFlag").getValue();
	if (CmpFlag != null && CmpFlag != 0) {
		Msg.info("warning", "入库单已完成不可修改!");
		return false;
	}
	// 判断入库部门和供货商是否为空
	var phaLoc = Ext.getCmp("PhaLoc").getValue();
	if (phaLoc == null || phaLoc.length <= 0) {
		Msg.info("warning", "请选择入库部门!");
		Ext.getCmp("PhaLoc").focus();
		return false;
	}
	var vendor = Ext.getCmp("Vendor").getValue();
	if (vendor == null || vendor.length <= 0) {
		Msg.info("warning", "请选择供应商!");
		Ext.getCmp('Vendor').focus();
		return false;
	}
	var carrid=Ext.getCmp("INFOPbCarrier").getValue();
	/*if (carrid==null||carrid.length<=0){
		Msg.info("warning", "请选择供配送商!");
		Ext.getCmp('INFOPbCarrier').focus();
		return false;
		
		}*/
	var PurUserId = Ext.getCmp("PurchaseUser").getValue();
	if((PurUserId==null || PurUserId=="")&(gParam[7]=='Y')){
		Msg.info("warning", "采购员不能为空!");
		Ext.getCmp("PurchaseUser").focus();
		return false;
	}
	var IngrTypeId = Ext.getCmp("OperateInType").getValue();
	if((IngrTypeId==null || IngrTypeId=="")&(gParam[8]=='Y')){
		Msg.info("warning", "入库类型不能为空!");
		Ext.getCmp("OperateInType").focus();
		return false;
	}
	var SourceOfFund = Ext.getCmp("SourceOfFund").getValue();
	if((SourceOfFund==null || SourceOfFund=="")&&gParam[29]=="Y"){
		Msg.info("warning", "资金来源不能为空!");
		Ext.getCmp("SourceOfFund").focus();
		return false;
	}
	// 1.判断入库物资是否为空
	var rowCount = DetailGrid.getStore().getCount();
	// 有效行数
	var count = 0;
	for (var i = 0; i < rowCount; i++) {
		var item = DetailStore.getAt(i).get("IncId");
		if (item != "") {
			count++;
		}
	}
	if (rowCount <= 0 || count <= 0) {
		Msg.info("warning", "请输入入库明细!");
		return false;
	}
	// 2.重新填充背景
	for (var i = 0; i < rowCount; i++) {
		changeBgColor(i, "white");
	}

	// 3.物资信息输入错误
	for (var i = 0; i < rowCount; i++) {
		var rowData = DetailStore.getAt(i);
		var expDateValue = rowData.get("ExpDate");
		var item = rowData.get("IncId");
		if(item==null || item==""){
			break;
		}
		var InvNo=rowData.get('InvNo')
		if ((item != "") && (InvNo=="")&&(gParam[20]=="Y")) {
			Msg.info("warning", "发票号不可为空!");
			DetailGrid.getSelectionModel().select(i, 1);
			changeBgColor(i, "yellow");
			return false;
		}
		var ExpReq = rowData.get('ExpReq');
		if(ExpReq=='R'){
			if ((expDateValue==null)||(expDateValue==""))
			{
				Msg.info("warning","有效期不可为空!");	
				return false;		
			}
			var ExpDate = new Date(Date.parse(expDateValue));
			if ((item != "") && (ExpDate.format(ARG_DATEFORMAT) <= nowdate.format(ARG_DATEFORMAT))) {
				Msg.info("warning", "有效期不能小于或等于当前日期!");
				DetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}
		}
		var BatchNo = rowData.get('BatchNo');
		var BatchReq = rowData.get('BatchReq');
		if(BatchReq=='R'){
			if ((item != "") && (BatchNo=="")) {
				Msg.info("warning", "批号不可为空!");
				DetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}
		}
		var qty = rowData.get("RecQty");
		if ((item != "") && (qty == null || qty <= 0)) {
			Msg.info("warning", "入库数量不能小于或等于0!");
			DetailGrid.getSelectionModel().select(i, 1);
			changeBgColor(i, "yellow");
			return false;
		}
		var inpoqty=rowData.get("InPoQty");
		if((gParam[13] != "Y") && (inpoqty!="") && (Number(qty) > Number(inpoqty))){
			Msg.info("warning", "入库数量不能大于订购数量!");
			DetailGrid.getSelectionModel().select(i, 1);
			changeBgColor(i, "yellow");
			return false;
		}
		var realPrice = rowData.get("Rp");
		if ((item != "")&& (realPrice == null || realPrice < 0)) {
			Msg.info("warning", "入库进价不能小于0!");
			DetailGrid.getSelectionModel().select(i, 1);
			changeBgColor(i, "yellow");
			return false;
		}
		var Sp = rowData.get("Sp");
		if (Sp<0){
			Msg.info("warning","第"+(i+1)+"行售价不能为小于0");
			DetailGrid.getSelectionModel().select(i, 1);
			changeBgColor(i, "yellow");
			return false;
		}
		if((gParam[24] == "N")  ){
			var ManfId=rowData.get("ManfId");
			if(ManfId=='' || ManfId==undefined || ManfId==null){
				Msg.info("warning", "入库厂商不能为空!");
				DetailGrid.getSelectionModel().select(i, 1);
				return false;
			}
		}
	}
	return true;
}
	
/**
 * 保存入库单
 */
function saveOrder() {
	loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
	var IngrNo = Ext.getCmp("InGrNo").getValue();
	var VenId = Ext.getCmp("Vendor").getValue();
	var Completed = (Ext.getCmp("CompleteFlag").getValue()==true?'Y':'N');
	var LocId = Ext.getCmp("PhaLoc").getValue();
	var CreateUser = gUserId;
	var ExchangeFlag =(Ext.getCmp("ExchangeFlag").getValue()==true?'Y':'N');
	var PresentFlag = (Ext.getCmp("PresentFlag").getValue()==true?'Y':'N');
	var IngrTypeId = Ext.getCmp("OperateInType").getValue();
	var PurUserId = Ext.getCmp("PurchaseUser").getValue();
	var StkGrpId = Ext.getCmp("StkGrpType").getValue();
	var InGrRemarks = Ext.getCmp("InGrRemarks").getValue();
	InGrRemarks=InGrRemarks.replace(/\r/g,'').replace(/\n/g,xMemoDelim());
	var SourceOfFund = Ext.getCmp("SourceOfFund").getValue();		
	var RequestLoc = Ext.getCmp("RequestLoc").getValue(); 
	var AcceptUserId = Ext.getCmp("AcceptUser").getValue();
	var StkCatId = Ext.getCmp("StkCat").getValue();
	var carrid=Ext.getCmp("INFOPbCarrier").getValue();
	var MainInfo = VenId + "^" + LocId + "^" + CreateUser + "^" + PresentFlag + "^" + ExchangeFlag 
			+ "^" + IngrTypeId + "^" + PurUserId + "^"+StkGrpId+"^"+""+"^"+InGrRemarks
			+ "^"+SourceOfFund+"^"+RequestLoc + "^^^" + AcceptUserId+"^^"+StkCatId+"^"+carrid;
	var ListDetail="";
	var rowCount = DetailGrid.getStore().getCount();
	for (var i = 0; i < rowCount; i++) {
		var rowData = DetailStore.getAt(i);
		//新增或数据发生变化时执行下述操作
		if(rowData.data.newRecord || rowData.dirty){	
			var Ingri=rowData.get("Ingri");
			var IncId = rowData.get("IncId");
			if(IncId==null || IncId==""){continue;}
			var Sp=rowData.get("Sp");
			var BatchNo = rowData.get("BatchNo");
			var ExpDate =Ext.util.Format.date(rowData.get("ExpDate"),ARG_DATEFORMAT);
			var ManfId = rowData.get("ManfId");
			var IngrUomId = rowData.get("IngrUomId");
			var RecQty = rowData.get("RecQty");
			var Rp = rowData.get("Rp");
			if(Rp == 0 && confirm('第' + (i+1) + '行:' + rowData.get('IncDesc') + ' 进价为0, 是否继续?') == false){
				loadMask.hide();
				return false;
			}
			//==============与上次入库物资名称和进价进行比较==============
			if(gParam[31]=="Y"){
				var inciDesc=rowData.get("IncDesc");
				var url = 'dhcstm.ingdrecaction.csp?actiontype=CheckNamePrice&inci='+IncId+'&rp='+Rp;					
				var CheckResult = ExecuteDBSynAccess(url);
				var CheckJsonData = Ext.util.JSON.decode(CheckResult)				
				if (CheckJsonData.success == 'true') {
					if(CheckJsonData.info == -1){
						Msg.info("warning", inciDesc + '的名称已修改!');
					}else if(CheckJsonData.info == -2){
						Msg.info("warning", inciDesc + '的进价已调整!');
					}
				}
			}
			var NewSp =rowData.get("NewSp");
			var SxNo = rowData.get("SxNo");
			var InvNo = rowData.get("InvNo");
			var InvDate =Ext.util.Format.date(rowData.get("InvDate"),ARG_DATEFORMAT);
			var Remark=rowData.get("Remark");
			var Remarks=rowData.get("Remarks");
			var QualityNo=rowData.get("QualityNo");
			var MtDesc=rowData.get("MtDesc");
			var MtDr=rowData.get("MtDr");
			var BarCode=rowData.get("HVBarCode");
			var SterilizedNo=rowData.get("SterilizedNo");
			var AdmNo = rowData.get("AdmNo");
			var AdmExpDate =Ext.util.Format.date(rowData.get("AdmExpdate"),ARG_DATEFORMAT);
			var SpecDesc=rowData.get("SpecDesc");
			var reqLoc = rowData.get("reqLocId"); 
			//20180211
			var Tax=rowData.get("Tax")
			var InvSupplyDate =Ext.util.Format.date(rowData.get("InvSupplyDate"),ARG_DATEFORMAT);
			var str = Ingri + "^" + IncId + "^"	+ BatchNo + "^" + ExpDate + "^" + ManfId
					+ "^" + IngrUomId + "^" + RecQty+ "^" + Rp + "^" + NewSp + "^" + SxNo
					+ "^" + InvNo + "^" + InvDate + "^" + "" + "^" + Remark + "^" + Remarks
					+ "^" + QualityNo + "^" + MtDr + "^"+ BarCode + "^" + SterilizedNo + "^" + AdmNo
					+ "^" + AdmExpDate + "^^" + SpecDesc + "^^" + reqLoc
					+ "^" + Sp+"^" +Tax+"^"+InvSupplyDate;
			if(ListDetail==""){
				ListDetail=str;
			}
			else{
				ListDetail=ListDetail+RowDelim+str;
			}
		}
	}
	if(!IsFormChanged(HisListTab) && ListDetail==""){
		Msg.info("error", "没有内容需要保存!");
		loadMask.hide();
		return false;
	}
	var url = DictUrl
		+ "ingdrecaction.csp?actiontype=Save";
	//var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		params:{Ingr:gIngrRowid,MainInfo:MainInfo,ListDetail:ListDetail},
		waitMsg : '处理中...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON
					.decode(result.responseText);
			if (jsonData.success == 'true') {
				// 刷新界面
				var IngrRowid = jsonData.info;
				Msg.info("success", "保存成功!");
				DetailStore.commitChanges();
				// 7.显示入库单数据
				gIngrRowid=IngrRowid;
				Query(IngrRowid);
				if(gParam[3]=='Y'){
					PrintRec(IngrRowid,'Y');
				}
				Ext.getCmp("Vendor").setDisabled(true);
			} else {
				var ret=jsonData.info;
				if(ret==-99){
					Msg.info("error", "加锁失败,不能保存!");
				}else if(ret==-2){
					Msg.info("error", "生成入库单号失败,不能保存!");
				}else if(ret==-3){
					Msg.info("error", "保存入库单失败!");
				}else if(ret==-4){
					Msg.info("error", "未找到需更新的入库单,不能保存!");
				}else if(ret==-5){
					Msg.info("error", "保存入库单明细失败!");
				}else {
					Msg.info("error", "部分明细保存不成功："+ret);
				}
				loadMask.hide();
			}
		},
		scope : this
	});
}
// 显示入库单数据
function Query(IngrRowid) {
	if (IngrRowid == null || IngrRowid.length <= 0 || IngrRowid <= 0) {
		return;
	}
	var url = DictUrl
		+ "ingdrecaction.csp?actiontype=Select&IngrRowid="
		+ IngrRowid;
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '查询中...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				var list = jsonData.info.split("^")
				if (list.length > 0) {
					gIngrRowid=IngrRowid;
					Ext.getCmp("InGrNo").setValue(list[0]);
					addComboData(Ext.getCmp("Vendor").getStore(),list[1],list[2]);
					Ext.getCmp("Vendor").setValue(list[1]);
					addComboData(Ext.getCmp("PhaLoc").getStore(),list[10],list[11]);
					Ext.getCmp("PhaLoc").setValue(list[10]);
					addComboData(OperateInTypeStore,list[17],list[18]);
					Ext.getCmp("OperateInType").setValue(list[17]);
					addComboData(Ext.getCmp("PurchaseUser").getStore(),list[19],list[20]);
					Ext.getCmp("PurchaseUser").setValue(list[19]);
					Ext.getCmp("InGrDate").setValue(list[12]);
					Ext.getCmp("CompleteFlag").setValue(list[9]=='Y'?true:false);
					Ext.getCmp("PresentFlag").setValue(list[30]=='Y'?true:false);
					Ext.getCmp("ExchangeFlag").setValue(list[31]=='Y'?true:false);
					addComboData(null,list[27],list[28],StkGrpType);
					Ext.getCmp("StkGrpType").setValue(list[27]);
					var InGrRemarks=handleMemo(list[32],xMemoDelim());
					Ext.getCmp("InGrRemarks").setValue(InGrRemarks);
					addComboData(Ext.getCmp("SourceOfFund").getStore(),list[33],list[34]);
					Ext.getCmp("SourceOfFund").setValue(list[33]);
					addComboData(Ext.getCmp("RequestLoc").getStore(),list[21],list[22]);
					Ext.getCmp("RequestLoc").setValue(list[21]);
					addComboData(Ext.getCmp("AcceptUser").getStore(),list[23],list[24]);
					Ext.getCmp("AcceptUser").setValue(list[23]);
					addComboData(null,list[36],list[37],StkCat);
					Ext.getCmp("StkCat").setValue(list[36]);
					addComboData(Ext.getCmp("INFOPbCarrier").getStore(),list[38],list[39]);
					Ext.getCmp("INFOPbCarrier").setValue(list[38]);
					// 显示入库单明细数据
					getDetail(IngrRowid);
					SetFieldDisabled(true);
				}
				SetFormOriginal(HisListTab);
			} else {
				if(loadMask){loadMask.hide();}
				Msg.info("warning", jsonData.info);
			}
		},
		scope : this
	});
}

// 入库明细
// 访问路径
var DetailUrl =DictUrl+
	'ingdrecaction.csp?actiontype=QueryDetail&Parref=&start=0&limit=999';
// 通过AJAX方式调用后台数据
var proxy = new Ext.data.HttpProxy({
	url : DetailUrl,
	method : "POST"
});

// 指定列参数
var fields = ["Ingri", "IncId", "IncCode", "IncDesc","ManfId","Manf","BatchNo", {name:'ExpDate',type:'date',dateFormat:DateFormat},
	"IngrUomId","IngrUom","RecQty","Rp", "Marginnow", "Sp","NewSp","InvNo","InvMoney", {name:'InvDate',type:'date',dateFormat:DateFormat},"RpAmt", "SpAmt", "NewSpAmt",
	"QualityNo","SxNo","Remark","Remarks","MtDesc","PubDesc","BUomId","ConFacPur","MtDr","HVFlag","HVBarCode","Spec","SterilizedNo","InPoQty","BatchReq","ExpReq",
	"BarCode","AdmNo",{name:'AdmExpdate',type:'date',dateFormat:DateFormat},"SpecDesc","reqLocId","reqLocDesc","Tax","TaxAmt",{name:'InvSupplyDate',type:'date',dateFormat:DateFormat}];
// 支持分页显示的读取方式
var reader = new Ext.data.JsonReader({
	root : 'rows',
	totalProperty : "results",
	id : "Ingri",
	fields : fields
});
// 数据集
var DetailStore = new Ext.data.Store({
	proxy : proxy,
	reader : reader
});
// 显示入库单明细数据
function getDetail(IngrRowid) {
	if (IngrRowid == null || IngrRowid.length <= 0 || IngrRowid <= 0) {
		return;
	}
	DetailStore.load({
		params:{start:0,limit:999,Parref:IngrRowid},
		callback:function(r,success,options){
			if(loadMask){loadMask.hide();}
		}
	});
	// 变更按钮是否可用
	//查询^清除^新增^保存^删除^完成^取消完成
	var inGrFlag = Ext.getCmp("CompleteFlag").getValue();
	if(inGrFlag==true){
		changeButtonEnable("1^1^0^0^0^0^1^0^0");
	}else{
		changeButtonEnable("1^1^1^1^1^1^0^1^1");
	}
	
}

// 变更按钮是否可用
function changeButtonEnable(str) {
	var list = str.split("^");
	for (var i = 0; i < list.length; i++) {
		if (list[i] == "1") {
			list[i] = false;
		} else {
			list[i] = true;
		}
	}
	//查询^清除^新增^保存^删除^完成^取消完成
	SearchInGrBT.setDisabled(list[0]);
	ClearBT.setDisabled(list[1]);
	AddBT.setDisabled(list[2]);
	SaveBT.setDisabled(list[3]);
	DeleteBT.setDisabled(list[4]);
	CompleteBT.setDisabled(list[5]);
	CancleCompleteBT.setDisabled(list[6]);
	ImportButton.setDisabled(list[7]);
}

function deleteData() {
	// 判断入库单是否已审批
	var inGrFlag = Ext.getCmp("CompleteFlag").getValue();
	if (inGrFlag != null && inGrFlag != 0) {
		Msg.info("warning", "入库单已完成不可删除!");
		return;
	}
	if (gIngrRowid == "") {
		Msg.info("warning", "没有需要删除的入库单!");
		return;
	}

	Ext.MessageBox.show({
		title : '提示',
		msg : '是否确定删除整张入库单?',
		buttons : Ext.MessageBox.YESNO,
		fn : showDeleteGr,
		icon : Ext.MessageBox.QUESTION
	});
}

/**
 * 删除入库单提示
 */
function showDeleteGr(btn) {
	if (btn == "yes") {
		var url = DictUrl
			+ "ingdrecaction.csp?actiontype=Delete&IngrRowid="
			+ gIngrRowid;

		Ext.Ajax.request({
			url : url,
			method : 'POST',
			waitMsg : '查询中...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					// 删除单据
					Msg.info("success", "入库单删除成功!");
					clearData();
				} else {
					var ret=jsonData.info;
					if(ret==-1){
						Msg.info("error", "入库单已经完成，不能删除!");
					}else if(ret==-2){
						Msg.info("error", "入库单已经审核，不能删除!");
					}else if(ret==-3){
						Msg.info("error", "入库单部分明细已经审核，不能删除!");
					}else{
						Msg.info("error", "删除失败,请查看错误日志!");
					}
				}
			},
			scope : this
		});
	}
}

/**
 * 删除选中行物资
 */
function deleteDetail() {
	// 判断入库单是否已完成
	var CmpFlag = Ext.getCmp("CompleteFlag").getValue();
	if (CmpFlag != null && CmpFlag != false) {
		Msg.info("warning", "入库单已完成不能删除!");
		return;
	}
	if (gParam[15]=="Y") {
		Msg.info("warning", "入库单需和订单保持一致,不能删除!");
		return;
	}
	var cell = DetailGrid.getSelectionModel().getSelectedCell();
	if (cell == null) {
		Msg.info("warning", "没有选中行!");
		return;
	}
	// 选中行
	var row = cell[0];
	var record = DetailGrid.getStore().getAt(row);
	var Ingri = record.get("Ingri");
	if (Ingri == "" ) {
		DetailGrid.getStore().remove(record);
		DetailGrid.getView().refresh();
	} else {
		Ext.MessageBox.show({
			title : '提示',
			msg : '是否确定删除该物资信息?',
			buttons : Ext.MessageBox.YESNO,
			fn : showResult,
			icon : Ext.MessageBox.QUESTION
		});
	}
}
/**
 * 删除提示
 */
function showResult(btn) {
	if (btn == "yes") {
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		var row = cell[0];
		var record = DetailGrid.getStore().getAt(row);
		var Ingri = record.get("Ingri");

		// 删除该行数据
		var url = DictUrl
			+ "ingdrecaction.csp?actiontype=DeleteDetail&Rowid="
			+ Ingri;

		Ext.Ajax.request({
			url : url,
			method : 'POST',
			waitMsg : '查询中...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", "删除成功!");
					DetailGrid.getStore().remove(record);
					DetailGrid.getView().refresh();
				} else {
					var ret=jsonData.info;
					if(ret==-1){
						Msg.info("error", "入库单已经完成，不能删除!");
					}else if(ret==-2){
						Msg.info("error", "入库单已经审核，不能删除!");
					}else if(ret==-4){
						Msg.info("error", "该明细数据已经审核，不能删除!");
					}else{
						Msg.info("error", "删除失败,请查看错误日志!");
					}
				}
			},
			scope : this
		});
	}
}

/**
 * 完成入库单
 */
function Complete() {
	// 判断入库单是否已完成
	var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
	if (CompleteFlag != null && CompleteFlag != 0) {
		Msg.info("warning", "入库单已完成!");
		return;
	}
	var InGrNo = Ext.getCmp("InGrNo").getValue();
	if (InGrNo == null || InGrNo.length <= 0) {
		Msg.info("warning", "没有需要完成的入库单!");
		return;
	}
	//===========================
	var rowData = DetailStore.getAt(0);
	if(rowData==""||rowData==undefined){
		Msg.info("warning","没有需要完成的数据明细!");
		return;
	}
	var Count = DetailGrid.getStore().getCount();
//		for (var i = 0; i < Count; i++) {
//			var rowData = DetailStore.getAt(i);
//			var Sp = Number(rowData.get("Sp"));
//			if(Sp<0){
//				Msg.info("warning","第"+(i+1)+"行售价不能小于0!");
//				return;
//			}
//		}
	
	var url = DictUrl
			+ "ingdrecaction.csp?actiontype=MakeComplete";
	Ext.Ajax.request({
		url : url,
		params : {Rowid:gIngrRowid,User:gUserId,GroupId:gGroupId},
		method : 'POST',
		waitMsg : '查询中...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON
					.decode(result.responseText);
			if (jsonData.success == 'true') {
				// 审核单据
				Msg.info("success", "成功!");
				// 显示入库单数据
				Query(gIngrRowid);
				//查询^清除^新增^保存^删除^完成^取消完成
				changeButtonEnable("1^1^0^0^0^0^1^0^0");
				var AuditAfterComp=gParam[12];	//完成后自动审核参数
				var PrintAfterAudit=gParam[4];	//审核后自动打印参数
				if(AuditAfterComp=='Y' && PrintAfterAudit=='Y'){
					PrintRec(gIngrRowid,'Y');
				}if(gParam[23]==""){
					window.location.reload();
				}
				
			} else {
				var Ret=jsonData.info;
				if(Ret==-1){
					Msg.info("error", "操作失败,入库单Id为空或入库单不存在!");
				}else if(Ret==-2){
					Msg.info("error", "入库单已经完成!");
				}else {
					Msg.info("error", "操作失败!");
				}
			}
		},
		scope : this
	});
}

/**
 * 取消完成入库单
 */
function CancleComplete() {
	
	var InGrNo = Ext.getCmp("InGrNo").getValue();
	if (InGrNo == null || InGrNo.length <= 0) {
		Msg.info("warning", "没有需要取消完成的入库单!");
		return;
	}
	var url = DictUrl
			+ "ingdrecaction.csp?actiontype=CancleComplete&Rowid="
			+ gIngrRowid + "&User=" + gUserId;
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '查询中...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON
					.decode(result.responseText);
			if (jsonData.success == 'true') {
				// 审核单据
				Msg.info("success", "取消成功!");
				// 显示入库单数据
				Query(gIngrRowid);
				//查询^清除^新增^保存^删除^完成^取消完成
				changeButtonEnable("1^1^1^1^1^1^0^1^1");
			} else {
				var Ret=jsonData.info;
				if(Ret==-1){
					Msg.info("error", "入库单Id为空或入库单不存在!");
				}else if(Ret==-2){
					Msg.info("error", "入库单尚未完成!");
				}else if(Ret==-4){
					Msg.info("error", "入库单已经审核!");
				}else{
					Msg.info("error", "操作失败!");
				}
			}
		},
		scope : this
	});
}

// 单位
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
	valueNotFoundText : '',
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				if(setEnterSort(DetailGrid,colArr)){
					addNewRow();
				}
			}
		}
	}
});

// 生产厂商
var Phmnf = new Ext.ux.ComboBox({
	fieldLabel : '厂商',
	id : 'Phmnf',
	name : 'Phmnf',
	anchor : '90%',
	width : 100,
	store : PhManufacturerStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'PHMNFName',
	params : {LocId : 'PhaLoc',ScgId : 'StkGrpType'},
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				if(setEnterSort(DetailGrid,colArr)){
					addNewRow();
				}
			}
		}
	}
});

var ExpDateEditor = new Ext.ux.DateField({
	selectOnFocus : true,
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				if(setEnterSort(DetailGrid,colArr)){
					addNewRow();
				}
			}
		}
	}
});

var InvNoEditor=new Ext.form.TextField({
	selectOnFocus : true,
	allowBlank : true,
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				if(setEnterSort(DetailGrid,colArr)){
					addNewRow();
				}			
			}
		}
	}
});

var RpEditor=new Ext.ux.NumberField({
	formatType : 'FmtRP',
	selectOnFocus : true,
	allowBlank : false,
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				// 新增一行
				if(setEnterSort(DetailGrid,colArr)){
					addNewRow();
				}
			}
		}
	}
})
var reqLoc = new Ext.ux.LocComboBox({
			fieldLabel : '接收科室',
			id : 'reqLoc',
			name : 'reqLoc',
			anchor:'90%',
			width : 120
});
var nm = new Ext.grid.RowNumberer();
var DetailCm = new Ext.grid.ColumnModel([nm, {
		header : "rowid",
		dataIndex : 'Ingri',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "IncRowid",
		dataIndex : 'IncId',
		width : 80,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : '物资代码',
		dataIndex : 'IncCode',
		width : 80,
		align : 'left',
		renderer :Ext.util.Format.InciPicRenderer('IncId'),
		sortable : true
	}, {
		header : '物资名称',
		dataIndex : 'IncDesc',
		width : 230,
		align : 'left',
		sortable : true,
		editable : isIncdescEdit,
		editor : new Ext.grid.GridEditor(new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						// 判断入库单是否已完成																		
						var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
						if (CompleteFlag != null && CompleteFlag != false) {
							Msg.info("warning", "入库单已完成!");
							return;
						}
						var group = Ext
								.getCmp("StkGrpType")
								.getValue();
						GetPhaOrderInfo(field.getValue(),
								group);
					}
					
				}
			}
		}))
	}, {
		header : '规格',
		dataIndex : 'Spec',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : "高值标志",
		dataIndex : 'HVFlag',
		width : 80,
		align : 'center',
		sortable : true,
		hidden : true
	}, {
		header : "高值条码",
		dataIndex : 'HVBarCode',
		width : 180,
		align : 'left',
		sortable : true,
		hidden : !isBarcodeEdit,
		editable : isBarcodeEdit,
		editor : new Ext.grid.GridEditor(new Ext.form.TextField({
			selectOnFocus : true,
			listeners : {
				specialkey : function(field, e) {
					if (field.getValue()!="" && e.getKey() == Ext.EventObject.ENTER){
						var Barcode=field.getValue();
						var row=DetailGrid.getSelectionModel().getSelectedCell()[0];
						var findHVIndex=DetailStore.findExact('HVBarCode',Barcode,0);
						if(findHVIndex>=0 && findHVIndex!=row){
							Msg.info("warning","不可重复录入!");
							field.setValue("");
							field.focus();
							return;
						}
						Ext.Ajax.request({
							url : 'dhcstm.itmtrackaction.csp?actiontype=GetItmByBarcode&Barcode='+Barcode,
							method : 'POST',
							waitMsg : '查询中...',
							success : function(result, request){
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if(jsonData.success == 'true'){
									var itmArr=jsonData.info.split("^");
									var status=itmArr[0],type=itmArr[1],lastDetailAudit=itmArr[2],lastDetailOperNo=itmArr[3];
									var inciDr=itmArr[5],inciCode=itmArr[6],inciDesc=itmArr[7],scgID=itmArr[8],scgDesc=itmArr[9];
									if(Ext.getCmp("StkGrpType").getValue()!=scgID){
										Msg.info("warning","条码"+Barcode+"属于"+scgDesc+"类组,与当前不符!");
										DetailGrid.store.getAt(row).set("HVBarCode","");
										return;
									}else if((type!="Reg" && type!="G")||(type=="G" && lastDetailAudit=="Y")){
										Msg.info("warning","该条码已办理入库!");
										DetailGrid.store.getAt(row).set("HVBarCode","");
										return;
									}else if(type=="G" && lastDetailAudit!="Y"){
										Msg.info("warning","有未完成或未审核的"+lastDetailOperNo);
										DetailGrid.store.getAt(row).set("HVBarCode","");
										return;
									}
									var record = Ext.data.Record.create([{
											name : 'InciDr',
											type : 'string'
										}, {
											name : 'InciCode',
											type : 'string'
										}, {
											name : 'InciDesc',
											type : 'string'
										}]);
									var InciRecord = new record({
										InciDr : inciDr,
										InciCode : inciCode,
										InciDesc : inciDesc,
										HVFlag : 'Y'
									});
									getDrugList(InciRecord)
								}else{
									Msg.info("error","该条码尚未注册!");
									DetailGrid.store.getAt(row).set("HVBarCode","");
									return;
								}
							}
						});
					}
				}
			}
		}))
	}, {
		header : "厂商",
		dataIndex : 'ManfId',
		width : 180,
		align : 'left',
		sortable : true,
		editor : new Ext.grid.GridEditor(Phmnf),
		renderer :Ext.util.Format.comboRenderer2(Phmnf,"ManfId","Manf")
	}, {
		header : "批号",
		dataIndex : 'BatchNo',
		width : 90,
		align : 'left',
		sortable : true,
		editor : new Ext.grid.GridEditor(new Ext.form.TextField({
			selectOnFocus : true,
			listeners : {
				specialkey : function(field, e) {
					 if (e.getKey() == Ext.EventObject.ENTER) {
						 if(setEnterSort(DetailGrid,colArr)){
							 addNewRow();
						 }
					 }
				}
			}
		}))
	}, {
		header : "有效期",
		dataIndex : 'ExpDate',
		width : 100,
		align : 'center',
		sortable : true,
		renderer : Ext.util.Format.dateRenderer(DateFormat),
		editor : ExpDateEditor
	}, {
		header : "单位",
		dataIndex : 'IngrUomId',
		width : 80,
		align : 'left',
		sortable : true,
		renderer :Ext.util.Format.comboRenderer2(CTUom,"IngrUomId","IngrUom"),								
		editor : new Ext.grid.GridEditor(CTUom)
	}, {
		header : "数量",
		dataIndex : 'RecQty',
		width : 80,
		align : 'right',
		sortable : true,
		editor : new Ext.ux.NumberField({
			formatType : 'FmtQTY',
			selectOnFocus : true,
			allowBlank : false,
			allowNegative : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						// 判断入库单是否已完成																		
						var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
						if (CompleteFlag != null && CompleteFlag != false) {
							Msg.info("warning", "入库单已完成!");
							return;
						}
						var qty = field.getValue();
						if (qty == null || qty.length <= 0) {
							Msg.info("warning", "入库数量不能为空!");
							return;
						}
						if (qty <= 0) {
							Msg.info("warning", "入库数量不能小于或等于0!");
							return;
						}
						// 计算指定行的进货金额和入库售价
						var cell = DetailGrid.getSelectionModel()
								.getSelectedCell();
						var record = DetailGrid.getStore()
								.getAt(cell[0]);
						var RealTotal = Number(record.get("Rp")).mul(qty);
						var SaleTotal = Number(record.get("Sp")).mul(qty);
						var NewSpAmt = Number(record.get("NewSp")).mul(qty);
						record.set("RpAmt", RealTotal);
						record.set("SpAmt", SaleTotal);
						record.set("NewSpAmt", NewSpAmt);
						record.set("InvMoney",RealTotal);
						if(setEnterSort(DetailGrid,colArr)){
							addNewRow();
						}								
					}
				}
			}
		})
	}, {
		header : "进价",
		dataIndex : 'Rp',
		width : 60,
		align : 'right',
		sortable : true,
		editor : RpEditor
	}, {
		header : "售价",
		dataIndex : 'Sp',
		width : 60,
		align : 'right',
		sortable : true
	}, {
		header : "当前加成",
		dataIndex : 'Marginnow',
		width : 60,
		align : 'right',
		sortable : true	
	}, {
		header : "入库售价",
		dataIndex : 'NewSp',
		width : 60,
		align : 'right',
		sortable : true,
		editor : new Ext.ux.NumberField({
			formatType : 'FmtSP',
			selectOnFocus : true,
			allowBlank : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cost = field.getValue();
						if (cost == null
								|| cost.length <= 0) {
							Msg.info("warning", "入库售价不能为空!");
							return;
						}
						// 计算指定行的售价金额
						var cell = DetailGrid.getSelectionModel().getSelectedCell();
						var record = DetailGrid.getStore().getAt(cell[0]);
						var NewSpAmt = accMul(record.get("RecQty"),cost);
						record.set("NewSpAmt",NewSpAmt);
						if(setEnterSort(DetailGrid,colArr)){
							addNewRow();
						}
					}
				}
			}
		})
	}, {
		header : "发票号",
		dataIndex : 'InvNo',
		width : 80,
		align : 'left',
		sortable : true,
		editor : InvNoEditor
	}, {
		header :"发票金额",
		dataIndex :'InvMoney',
		width :80,
		align :'right',
		editable : false,
		summaryType : 'sum',
		editor : new Ext.ux.NumberField({
			formatType : 'FmtRA',
			selectOnFocus : true,
			allowNegative : false
		})
	}, {
		header : "发票日期",
		dataIndex : 'InvDate',
		width : 100,
		align : 'center',
		sortable : true,
		renderer : Ext.util.Format.dateRenderer(DateFormat),
		editor : new Ext.ux.DateField({
			selectOnFocus : true,
			allowBlank : true,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						// 判断入库单是否已完成
						var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
						if (CompleteFlag != null && CompleteFlag != false) {
							Msg.info("warning", "入库单已完成!");
							return;
						}
						var invDate = field.getValue();
						if (invDate == null || invDate.length <= 0) {
							// Msg.info("warning", "发票日期不能为空!");
							return;
						}
						if(setEnterSort(DetailGrid,colArr)){
							addNewRow();
						}
					}
				}
			}
		})
	},{
		header : "质检单号",
		dataIndex : 'QualityNo',
		width : 90,
		align : 'left',
		sortable : true,
		editor : new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : true,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if(setEnterSort(DetailGrid,colArr)){
							addNewRow();
						}
					}
				}
			}
		})
	}, {
		header : "随行单号",
		dataIndex : 'SxNo',
		width : 90,
		align : 'left',
		sortable : true,
		editor : new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : true,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if(setEnterSort(DetailGrid,colArr)){
							addNewRow();
						}
					}
				}
			}
		})
	}, {
		header : "进货金额",
		dataIndex : 'RpAmt',
		width : 100,
		align : 'right',
		sortable : true,
		summaryType : 'sum',
		editable:(gParam[6]=='Y'?true:false),
		editor:new Ext.ux.NumberField({
			formatType : 'FmtRA',
			selectOnFocus : true,
			allowNegative:false,
			allowBlank : false
		})
	}, {
		header : "入库售价金额",
		dataIndex : 'NewSpAmt',
		width : 100,
		align : 'right',
		sortable : true
	},{
		header : "定价类型",
		dataIndex : 'MtDesc',
		width : 180,
		align : 'left',
		sortable : true,
		hidden : true
	},{
		header : "招标轮次",
		dataIndex : 'PubDesc',
		width : 180,
		align : 'left',
		sortable : true,
		hidden : true
	},{
		header : "摘要",
		dataIndex : 'Remark',
		width : 90,
		align : 'left',
		sortable : true,
		editor : new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : true,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if(setEnterSort(DetailGrid,colArr)){
							addNewRow();
						}
					}
				}
			}
		})
	},{
		header : "备注",
		dataIndex : 'Remarks',
		width : 90,
		align : 'left',
		sortable : true,
		editor : new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : true,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if(setEnterSort(DetailGrid,colArr)){
							addNewRow();
						}
					}
				}
			}
		})
	},{
		header : "BUomId",
		dataIndex : 'BUomId',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	},{
		header : "ConFacPur",
		dataIndex : 'ConFacPur',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	},{
		header : "MtDr",
		dataIndex : 'MtDr',
		width : 80,
		align : 'left',
		sortable : true,
		hidden : true
	},{
		header : "MtDr2",
		dataIndex : 'MtDr2',
		width : 80,
		align : 'left',
		sortable : true,
		hidden : true
	},{
		header : "灭菌批号",
		dataIndex : 'SterilizedNo',
		width : 90,
		align : 'left',
		sortable : true,
		editor : new Ext.grid.GridEditor(new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : true,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						// 判断入库单是否已完成
						var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
						if (CompleteFlag != null && CompleteFlag != false) {
							Msg.info("warning", "入库单已完成!");
							return;
						}
						if(setEnterSort(DetailGrid,colArr)){
							addNewRow();
						}
					}
				}
			}
		}))
	}, {
		header : '订购数量',
		dataIndex : 'InPoQty',
		width : 80,
		align : 'left',
		hidden:true,
		sortable : true
	},{
		header : "批号要求",
		dataIndex : 'BatchReq',
		width : 80,
		align : 'center',
		hidden : true
	},{
		header : "有效期要求",
		dataIndex : 'ExpReq',
		width : 80,
		align : 'center',
		hidden : true
	}, {
		header : "条码",
		dataIndex : 'BarCode',
		width : 180,
		align : 'left',
		sortable : true,
		editable : isIncdescEdit,
		editor : new Ext.grid.GridEditor(new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : true,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						// 判断入库单是否已完成
						var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
						if (CompleteFlag != null && CompleteFlag != false) {
							Msg.info("warning", "入库单已完成!");
							return;
						}
						var group = Ext
								.getCmp("StkGrpType")
								.getValue();
						var Barcode=field.getValue();
						GetPhaOrderInfo2(Barcode,group);
					}
				}
			}
		}))
	}, {
		header : "注册证号",
		dataIndex : 'AdmNo',
		width : 90,
		align : 'left',
		tooltip:'同时按Ctrl+Alt+Enter，可选择厂商的注册证号',
		sortable : true,
		editor : new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank : true,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if ((Ext.EventObject.altKey)&&(Ext.EventObject.ctrlKey))
							{
								showCertInfo();
							}
							else
							{
								if(setEnterSort(DetailGrid,colArr)){
									addNewRow();
								}
							}
						}
					}
				}
			})
	}, {
		header : "注册证有效期",
		dataIndex : 'AdmExpdate',
		width : 100,
		align : 'center',
		sortable : true,	
		renderer : Ext.util.Format.dateRenderer(DateFormat),
		editor : new Ext.ux.DateField({
			selectOnFocus : true,
			allowBlank : true,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if(setEnterSort(DetailGrid,colArr)){
							addNewRow();
						}
					}
				}
			}
		})
	},{
		header:"具体规格",
		dataIndex:'SpecDesc',
		width:100,
		editable : AllowEnterSpec,
		align:'left',
		sortable:true,
		editor : new Ext.grid.GridEditor(Specom),
		renderer : Ext.util.Format.comboRenderer2(Specom,"SpecDesc","SpecDesc")
	},{
		header : "请求部门",
		dataIndex : 'reqLocId',
		width : 80,
		align : 'left',
		sortable : true,
		renderer :Ext.util.Format.comboRenderer2(reqLoc,"reqLocId","reqLocDesc"),								
		editor : reqLoc
	}, {
		header : "单品税额",
		dataIndex : 'Tax',
		width : 100,
		align : 'right',
		sortable : true,
		editor:new Ext.ux.NumberField({
			selectOnFocus : true,
			allowNegative:false,
			allowBlank : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						//20180211
						var Tax=field.getValue();
						var cell=DetailGrid.getSelectionModel().getSelectedCell();
						var record=DetailGrid.getStore().getAt(cell[0]);
						var TaxAmt=Number(record.get("RecQty")).mul(Tax)
						record.set("TaxAmt",TaxAmt)
						if(setEnterSort(DetailGrid,colArr)){
							addNewRow();
						}
					}
				}
			}
		})
	}, {
		header : "单品总税额",
		dataIndex : 'TaxAmt',
		width : 100,
		align : 'right',
		sortable : true
	}, {
		header : "发票提供日期",
		dataIndex : 'InvSupplyDate',
		width : 100,
		align : 'center',
		sortable : true,	
		renderer : Ext.util.Format.dateRenderer(DateFormat),
		editor : new Ext.ux.DateField({
			selectOnFocus : true,
			allowBlank : true,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if(setEnterSort(DetailGrid,colArr)){
							addNewRow();
						}
					}
				}
			}
		})
	}
]);

var DetailGrid = new Ext.grid.EditorGridPanel({
	id : 'DetailGrid',
	title:'入库单明细',
	region : 'center',
	cm : DetailCm,
	store : DetailStore,
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
	sm : new Ext.grid.CellSelectionModel({}),
	tbar:{items:[AddBT,'-',DeleteDetailBT,'-',{height:30,width:70,text:'列设置',iconCls:'page_gear',handler:function(){GridColSet(DetailGrid,"DHCSTIMPORTM");}}]},
	clicksToEdit : 1,
	plugins : new Ext.grid.GridSummary(),
	listeners:{
		'beforeedit' : function(e){
			if(Ext.getCmp("CompleteFlag").getValue()==true){
				return false;
			}
			if(e.field=="HVBarCode"){
				if(!UseItmTrack || e.record.get("HVFlag")=='N' ||(e.record.get("Ingri")!="" && e.record.get("HVBarCode")!="")){
					e.cancel=true;
				}
			}
			if(e.field=="RecQty" || e.field=="IncDesc" || e.field=="IngrUomId" || e.field=="HVBarCode"){
				if(e.record.get("HVBarCode")!="" && e.record.get("HVFlag")=="Y"){
					e.cancel=true;
				}
			}
			if(e.field=="ExpDate" && e.record.get('ExpReq')=='N'){
				e.cancel=true;
			}
			if(e.field=="BatchNo" && e.record.get('BatchReq')=='N'){
				e.cancel=true;
			}
		},
		'afteredit' : function(e){
			if(e.field=='ExpDate'){
				if(e.record.get('ExpReq')!='R'){
					return;
				}
				var expDate = e.value;
				if(expDate==null || expDate==""){
					Msg.info("warning","有效期不可为空!");
					e.record.set('ExpDate',e.originalValue);
					return;
				}else{
					expDate=expDate.format(ARG_DATEFORMAT);
				}
				var Inci = e.record.get('IncId');
				var flag=ExpDateValidator(expDate,Inci);
				if(flag==false){
					//Msg.info('warning','该物资距离失效期少于'+gParam[2]+'天!');
					e.record.set('ExpDate',e.originalValue);
					return;
				}
			}else if(e.field=='BatchNo'){
				if(e.record.get('BatchReq')!='R'){
					return;
				}
				var BatchNo = e.value;
				if(BatchNo==null || BatchNo==""){
					Msg.info("warning","批号不可为空!");
					e.record.set('BatchNo',e.originalValue);
					return;
				}
			}else if(e.field=='Rp'){
				var cost = e.value;
				if (Ext.isEmpty(cost)) {
					Msg.info("warning", "进价不能为空!");
					e.record.set('Rp',e.originalValue);
					return;
				}else if (cost < 0) {
					//2016-09-26进价可为0
					Msg.info("warning", "进价不能小于0!");
					e.record.set('Rp',e.originalValue);
					return;
				}
				var IncId=e.record.get('IncId');
				var UomId=e.record.get('IngrUomId');
				var Params=session['LOGON.GROUPID']+'^'+session['LOGON.CTLOCID']+'^'+gUserId;
				var sp = tkMakeServerCall('web.DHCSTM.DHCINGdRec', 'GetSpForRec', IncId, UomId, cost, Params);
				e.record.set("Sp",sp);
				//验证加成率
				var ChargeFlag = tkMakeServerCall('web.DHCSTM.Common.DrugInfoCommon','GetChargeFlag',IncId);
				var margin = 0;
				if(cost!=0 && gParam[5]!=0 && ChargeFlag=='Y'){
					margin = accSub(accDiv(sp, cost), 1);
					if(margin>gParam[5] || margin<0){
						Msg.info("warning",	"加成率超出限定范围!");
						e.record.set('Rp',e.originalValue);
						return false;
					}
				}
				// 计算指定行的进货金额
				var RealTotal = accMul(e.record.get("RecQty"), cost);
				e.record.set("RpAmt",RealTotal);
				e.record.set("InvMoney",RealTotal);
				e.record.set("Marginnow",margin.toFixed(3));
				
				//预算结余判断
				var InciId = e.record.get('IncId');
				var RpAmt = Number(e.record.get('RpAmt'));
				if(!Ext.isEmpty(InciId) && !(Number <= 0)){
					HRPBudg(InciId);
				}
			}else if(e.field=='RecQty'){
				var RealTotal = accMul(e.record.get("Rp"), e.value);
				//20180223
				if(typeof(e.record.get("Tax"))!="undefined"){
				var TaxAmt = accMul(e.record.get("Tax"), e.value);
				e.record.set("TaxAmt",TaxAmt);
				}
				e.record.set("RpAmt",RealTotal);
				e.record.set("InvMoney",RealTotal);
				
				//预算结余判断
				var InciId = e.record.get('IncId');
				var RpAmt = Number(e.record.get('RpAmt'));
				if(!Ext.isEmpty(InciId) && !(Number <= 0)){
					HRPBudg(InciId);
				}
			}else if(e.field=='Tax'){
				//20180223
				var TaxAmt = accMul(e.record.get("RecQty"), e.value);
				e.record.set("TaxAmt",TaxAmt);
			}else if(e.field=='InvNo'){
				var flag=InvNoValidator(e.value, gIngrRowid);
				if(flag==false){
					Msg.info("warning","发票号" + e.value + "已存在于别的入库单!");
				}
			}
		},
		//右键菜单
		'rowcontextmenu' : rightClickFn
	}
});

var rightClick = new Ext.menu.Menu({
	id:'rightClickCont',
	items: [
		{
			id: 'mnuDelete',
			handler: deleteDetail,
			text: '删除'
		}
	]
});

//右键菜单代码关键部分 
function rightClickFn(grid,rowindex,e){
	e.preventDefault();
	grid.getSelectionModel().select(rowindex,0);
	rightClick.showAt(e.getXY());
}

/*
 * 预算结余,调用HRP预算接口
 */
function HRPBudg(CurrInciId){
	CurrInciId = typeof(CurrInciId) == 'undefined'? '' : CurrInciId;
	var LocId = Ext.getCmp('PhaLoc').getValue();
	if(Ext.isEmpty(LocId)){
		return;
	}
	var DataStr = '';
	var Count = DetailGrid.getStore().getCount();
	for(i = 0; i < Count; i++){
		var RowData = DetailGrid.getStore().getAt(i);
		var Ingri = RowData.get('Ingri');
		var IncId = RowData.get('IncId');
		var RpAmt = RowData.get('RpAmt');
		if ((IncId == '') || !(RpAmt > 0)){
			continue;
		}
		var Data = Ingri + '^' + IncId + '^' + RpAmt;
		if(DataStr == ''){
			DataStr = Data;
		}else{
			DataStr = DataStr + RowDelim + Data;
		}
	}
	if(DataStr != ''){
		var Result = tkMakeServerCall('web.DHCSTM.ServiceForHerpBudg', 'IngrBalance', CurrInciId, LocId, DataStr);
		if(!Ext.isEmpty(Result)){
			Msg.info('error', '当前采购超出预算,请核实修改:' + Result);
			return false;
		}
	}
	return true;
}

//判断库存项重复行(非高值材料)
function  GetRepeatResult(store,colName,colValue,beginIndex,inciDesc,row){
	beginIndex=store.findExact(colName,colValue,beginIndex);
	if(beginIndex!=-1){
		changeBgColor(row, "yellow");
		Msg.info("warning","物资 "+inciDesc+" 已存在于第"+(beginIndex+1)+"行!");
		changeBgColor(beginIndex, "yellow");
		GetRepeatResult(store,colName,colValue,beginIndex+1,inciDesc,row);
	}
}

/**
 * 调用物资窗体并返回结果
 */
function GetPhaOrderInfo(item, group) {					
	if (item != null && item.length > 0) {
		var vendor=""
		if(gParam[19]=="Y"){
			vendor=Ext.getCmp('Vendor').getValue()
		}
		var StkCat=Ext.getCmp("StkCat").getValue();
		GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N",
			"0", gHospId, getDrugList,"",0,
			"","","","",gPhaMulFlag,
			vendor, PhaOrderHVFlag,"",StkCat);
	}
}

//根据条码获取物资信息
function GetPhaOrderInfo2(item, group) {
	if (item != null && item.length > 0) {
		GetPhaOrderByBarcodeWindow(item, group, App_StkTypeCode, "", "N", "0", gHospId,
				getDrugList);
	}
}
/**
 * 返回方法
*/
function getDrugList(records) {
	records = [].concat(records);
	if (records == null || records == "") {
		return;
	}
	var vendor = Ext.getCmp("Vendor").getValue();
	var LocId=Ext.getCmp("PhaLoc").getValue();
	
	Ext.each(records,function(record,index,allItems){
		var inciDr = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		var HVFlag=record.get("HVFlag");
		// 选中行
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		var row = cell[0];
		var rowCount=DetailStore.getCount();
		for (var i = 0; i < rowCount; i++) {
			changeBgColor(i, "white");
		}
		if((!gHVINGdRec && HVFlag!="Y")){
			GetRepeatResult(DetailStore,'IncId',inciDr,0,inciDesc,row);
		}
		var rowData = DetailGrid.getStore().getAt(row);
		var ItmTrack=gItmTrackParam[0]=='Y'?true:false;
		//高值跟踪参数设置和菜单标志一致时, 不予提示
		if(UseItmTrack && !gHVINGdRec && HVFlag=='Y' && !CreBarByIngdrec){
			Msg.info("warning","高值材料,请根据条码入库!");
			rowData.set("IncDesc","");
			var colIndex=GetColIndex(DetailGrid,'HVBarCode');
			DetailGrid.startEditing(row, colIndex);
			return;
		}

		var Params=session['LOGON.GROUPID']+'^'+session['LOGON.CTLOCID']+'^'+gUserId;
		//取其它物资信息
		var url = DictUrl
			+ "ingdrecaction.csp?actiontype=GetItmInfo&IncId="
			+ inciDr+"&Params="+Params;
		var result = ExecuteDBSynAccess(url);
		var jsonData = Ext.util.JSON.decode(result);
		if (jsonData.success == 'true') {
			var data=jsonData.info.split("^");
			
			//=====================判断资质====================
			var DataList = vendor+"^"+inciDr+"^"+data[0];
			var url = 'dhcstm.utilcommon.csp?actiontype=Check&DataList=' + DataList;
			var CheckResult = ExecuteDBSynAccess(url);
			var CheckJsonData = Ext.util.JSON.decode(CheckResult)
			if (CheckJsonData.success == 'true') {
				if(CheckJsonData.info != ""){
					Msg.info("warning", inciDesc + ':' + CheckJsonData.info);
					if(CommParObj.StopItmBussiness == 'Y'){
						return;
					}
				}
			}
			
			rowData.set("IncId",inciDr);
			rowData.set("IncCode",inciCode);
			rowData.set("IncDesc",inciDesc);
			addComboData(PhManufacturerStore,data[0],data[1]);
			rowData.set("ManfId", data[0]);
			rowData.set("BatchNo", data[6]);
			rowData.set("ExpDate", toDate(data[7]));
			rowData.set("MtDesc", data[8]);
			rowData.set("PubDesc", data[9]);
			rowData.set("BUomId", data[10]);
			rowData.set("ConFacPur", data[11]);
			rowData.set("MtDr", data[12]);
			rowData.set("HVFlag",data[14]);
			var BatchReq = data[15],ExpReq = data[16];
			rowData.set("BatchReq",BatchReq);
			rowData.set("ExpReq",ExpReq);
			rowData.set("AdmNo",data[18]);
			rowData.set("AdmExpdate",toDate(data[19]));
			rowData.set("Spec",data[17]);
			rowData.set("BarCode",data[22]);
			if (gParam[30]=="1") {
				addComboData(ItmUomStore,data[10],data[25]);
				rowData.set("IngrUomId", data[10]);
				rowData.set("Rp", Number(data[23]));
				rowData.set("Sp", Number(data[24]));
				rowData.set("NewSp", Number(data[24]));
			} else {
				addComboData(ItmUomStore,data[2],data[3]);
				rowData.set("IngrUomId", data[2]);
				rowData.set("Rp", Number(data[4]));
				rowData.set("Sp", Number(data[5]));
				rowData.set("NewSp", Number(data[5]));
			}
			
			//对比最高售价
			if(gParam[9]=="Y" & data[13]!=""){
				if(Number(data[5])>Number(data[13])){
					Msg.info("error","当前售价高于最高售价!");
				}
			}

			if (Ext.getCmp('StkGrpType').getValue()==''){
				addComboData(null,data[30],data[31],Ext.getCmp("StkGrpType"));
				Ext.getCmp("StkGrpType").setValue(data[30]);
			}  
			var RequestLoc = Ext.getCmp("RequestLoc").getValue();
			var RequestLocdisplaytext = Ext.getCmp("RequestLoc").getRawValue()
			addComboData(Ext.getCmp("reqLoc").getStore(),RequestLoc,RequestLocdisplaytext);
			rowData.set("reqLocId", RequestLoc);
			var sp = rowData.get("Sp");
			var rp = rowData.get("Rp");
			if ((sp!=0)&&(rp!=0)){
				var margin = accSub(accDiv(sp, rp), 1);
				rowData.set("Marginnow",margin.toFixed(3));
			}
			//跳转控制
			if(gPhaMulFlag == 'Y' && index < allItems.length - 1){
				addNewRow();
			}else{
				if(setEnterSort(DetailGrid,colArr)){
					addNewRow();
				}
			}
		}
	});
}

/**
 * 单位展开事件
 */
CTUom.on('expand', function(combo) {
	var cell = DetailGrid.getSelectionModel().getSelectedCell();
	var record = DetailGrid.getStore().getAt(cell[0]);
	var InciDr = record.get("IncId");
	ItmUomStore.removeAll();
	ItmUomStore.load({params:{ItmRowid:InciDr}});
});

/**
 * 单位变换事件
 */
CTUom.on('select', function(combo) {
	var cell = DetailGrid.getSelectionModel().getSelectedCell();
	var record = DetailGrid.getStore().getAt(cell[0]);
	var value = combo.getValue();        //目前选择的单位id
	var BUom = record.get("BUomId");
	var ConFac = record.get("ConFacPur");   //大单位到小单位的转换关系
	var IngrUom = record.get("IngrUomId");    //目前显示的入库单位
	var Sp = Number(record.get("Sp"));
	var Rp = Number(record.get("Rp"));
	var NewSp = Number(record.get("NewSp"));
	if (value == null || value.length <= 0) {
		return;
	} else if (IngrUom == value) {
		return;
	} else if (value==BUom) {     //新选择的单位为基本单位，原显示的单位为大单位
		record.set("Sp", Sp.div(ConFac));
		record.set("NewSp", NewSp.div(ConFac));
		record.set("Rp", Rp.div(ConFac));
	} else{  //新选择的单位为大单位，原先是单位为小单位
		record.set("Sp", Sp.mul(ConFac));
		record.set("NewSp", NewSp.mul(ConFac));
		record.set("Rp", Rp.mul(ConFac));
	}
	var RpAmt=Number(record.get("Rp")).mul(record.get("RecQty"));
	var SpAmt=Number(record.get("Sp")).mul(record.get("RecQty"));
	var NewSpAmt=Number(record.get("NewSp")).mul(record.get("RecQty"));
	record.set("RpAmt",RpAmt);
	record.set("InvMoney",RpAmt);
	record.set("SpAmt",SpAmt);
	record.set("NewSpAmt",NewSpAmt);
	record.set("IngrUomId", combo.getValue());
});

// 变换行颜色
function changeBgColor(row, color) {
	DetailGrid.getView().getRow(row).style.backgroundColor = color;
}

var HisListTab = new Ext.form.FormPanel({
	labelWidth : 60,
	region : 'north',
	autoHeight : true,
	labelAlign : 'right',
	title:gHVINGdRec==true?'入库单制单(高值)':'入库单制单',
	frame : true,
	autoScroll : false,
	tbar : [SearchInGrBT, '-', SaveBT, '-',ClearBT, '-', DeleteBT, '-', CompleteBT,
			'-',CancleCompleteBT,'-',ImportButton,'-',PrintBT,'-',EvaluateBT,'-',viewImage
			],
	items:[{
		xtype:'fieldset',
		title:'入库信息',
		style:'padding:1px 0px 0px 10px',
		layout: 'column',    // Specifies that the items will now be arranged in columns
		defaults: {border:false},
		items : [{
			columnWidth: 0.3,
			xtype: 'fieldset',
			items: [PhaLoc,Vendor,StkGrpType,StkCat,SourceOfFund]
		},{
			columnWidth: gHVINGdRec?0.05:0.01,
			labelWidth : 10,
			items: gHVINGdRec?[VirtualFlag]:[]
		},{
			columnWidth: 0.25,
			xtype: 'fieldset',
			labelWidth: 60,
			defaultType: 'textfield',
			autoHeight: true,
			items: [InGrNo,InGrDate,OperateInType,RequestLoc,INFOPbCarrier]
		},{
			columnWidth: 0.2,
			xtype: 'fieldset',
			labelWidth: 60,
			defaultType: 'textfield',
			autoHeight: true,
			items: [PurchaseUser,InGrRemarks,InPoNumField]
		},{
			columnWidth: 0.2,
			xtype: 'fieldset',
			labelWidth: 60,
			defaultType: 'textfield',
			autoHeight: true,
			items: [AcceptUser,CompleteFlag,PresentFlag,ExchangeFlag]
		}]
	}]
});

function setCert(certNo,certExpDate)
{
	var cell = DetailGrid.getSelectionModel().getSelectedCell();
	var r=cell[0] ;
	var rdata=DetailGrid.getStore().getAt(r);
	rdata.set("AdmNo",certNo);
	rdata.set("AdmExpdate",certExpDate);
}
function showCertInfo()
{	 
	var cell = DetailGrid.getSelectionModel().getSelectedCell();
	var r=cell[0] ;
 	var rdata=DetailGrid.getStore().getAt(r);
	var inci=rdata.get("IncId");
	var manf=rdata.get("ManfId");
	certEdit(inci,manf,setCert);
}
/*设置缺省的入库类型
  注意：这一段应改为使用缺省值来设置，暂时如此。
*/	
function setDefaultInType()
{
	OperateInTypeStore.load({
		callback:function(r,options,success){
			if(success && r.length>0){
				OperateInType.setValue(r[0].get(OperateInType.valueField));
			}
		}
	});
}
/*设置缺省的资金来源，前提是参数设置成资金来源是必填项
  注意：这一段应改为使用缺省值来设置，暂时如此。
*/	
function setDefaultSourceOfFund()
{
	SourceOfFundStore.load({
		params:{start:0,limit:999},
		callback:function(r,options,success){
			if(success && r.length>0 &&gParam[29]=="Y"){
				SourceOfFund.setValue(r[0].get(SourceOfFund.valueField));
			}
		}
	});
}
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	// 页面布局
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [HisListTab, DetailGrid],
		renderTo : 'mainPanel'
	});
	
	RefreshGridColSet(DetailGrid,"DHCSTIMPORTM");   //根据自定义列设置重新配置列
	if(gIngrRowid!=null && gIngrRowid!='' && gFlag==1){
		Query.defer(100,this,[gIngrRowid]);
	}
})