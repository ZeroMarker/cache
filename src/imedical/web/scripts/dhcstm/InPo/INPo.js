// 名称:订单录入
// 编写日期:2013-01-21

var mainRowId="";
var UserId = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'];
var CtLocId = session['LOGON.CTLOCID'];
var gGroupId = session['LOGON.GROUPID'];

//保存参数值的object
var InPoParamObj = GetAppPropValue('DHCSTPOM');

var locField = new Ext.ux.LocComboBox({
	fieldLabel : '订单科室',
	id : 'locField',
	anchor : '90%',
	emptyText : '订单科室...',
	groupId : gGroupId,
	stkGrpId : 'StkGrpType',
	childCombo : 'Vendor'
});

function getDrugList2(record) {
	if (record == null || record == "") {
		return false;
	}
	inciDr = record.get("InciDr");
	var cell = INPoItmGrid.getSelectionModel().getSelectedCell();
	// 选中行
	var row = cell[0];
	var findIndex=INPoItmGridDs.findExact('IncId',inciDr,0);
	if(findIndex>=0 && findIndex!=row){
		Msg.info("warning","物资不可重复录入!");
		var col=GetColIndex(INPoItmGrid,"IncDesc");
		INPoItmGrid.startEditing(row, col);
		return;
	}
	var rowData = INPoItmGrid.getStore().getAt(row);
	
	//取其它物资信息
	var locId = Ext.getCmp('locField').getValue();
	if(locId==""){
		Msg.info("error", "请选择科室!");
	}
	var Params=session['LOGON.GROUPID']+'^'+locId+'^'+UserId;
	Ext.Ajax.request({
		url : INPoItmGridUrl+'?actiontype=GetItmInfo&IncId='+ inciDr+'&Params='+Params,
		method : 'POST',
		waitMsg : '查询中...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText.replace(/\r/g,"").replace(/\n/g,""));
			if (jsonData.success == 'true') {
				var data=jsonData.info.split("^");
				
				//资质判断
				var venId = Ext.getCmp('Vendor').getValue();
				var ManfId = data[0];
				var inciDesc = record.get("InciDesc");
				var DataList=venId+"^"+inciDr+"^"+ManfId;
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
				rowData.set("IncCode",record.get("InciCode"));
				rowData.set("IncDesc",record.get("InciDesc"));
				
				
				var ManfId = data[0];
				var Manf = data[1];
				addComboData(PhManufacturerStore,ManfId,Manf);
				rowData.set("ManfId", ManfId);    //生产商
				rowData.set("Manf", Manf);    
				var UomId=data[4];
				var Uom=data[5];
				addComboData(ItmUomStore,UomId,Uom);
				rowData.set("PurUomId",UomId);//默认为大单位调价
				rowData.set("PurUom",Uom);
				rowData.set("Sp", data[7]);   
				rowData.set("Rp", data[6]); 
				rowData.set("Spec", data[14]);
				rowData.set("BUom", data[15]);
				rowData.set("ConFac", data[16]);
				
				var colindex=GetColIndex(INPoItmGrid,"PurQty");
				INPoItmGrid.getSelectionModel().select(row,colindex);
				INPoItmGrid.startEditing(row, colindex);
			}
		},
		scope : this
	});
}

var Uom = new Ext.form.ComboBox({
	fieldLabel : '单位',
	id : 'Uom',
	name : 'Uom',
	anchor : '90%',
	store : ItmUomStore,
	valueField : 'RowId',
	displayField : 'Description',
	emptyText : '单位...',
	mode:'local',
	listeners:{
		specialKey:function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var cell=INPoItmGrid.getSelectionModel().getSelectedCell();
				var col=GetColIndex(INPoItmGrid,"Qty");
				INPoItmGrid.startEditing(cell[0], col);		
			}
		},
		'focus':function(field){
			var cell = INPoItmGrid.getSelectionModel().getSelectedCell();			
			var record = INPoItmGrid.getStore().getAt(cell[0]);
			var ItmId=record.get("IncId");
			if(ItmId==null||ItmId==""){
				Msg.info("warning","请先录入物资名称!");
				return;
			}
		}
	}
});		

Uom.on('expand', function(combo) {
	var cell = INPoItmGrid.getSelectionModel().getSelectedCell();
	var record = INPoItmGrid.getStore().getAt(cell[0]);
	var ItmId=record.get("IncId");
	ItmUomStore.removeAll();
	ItmUomStore.load({params:{ItmRowid:ItmId}});
});

Uom.on('select', function(combo) {
	var cell = INPoItmGrid.getSelectionModel().getSelectedCell();
	var rowData = INPoItmGrid.getStore().getAt(cell[0]);
	var qty = rowData.get('PurQty');
	if((qty=="")||(qty==null)){
		qty = 0;
	}

	var seluom=combo.getValue();
	var rp = rowData.get("Rp"); //原进价
	var sp = rowData.get("Sp"); //原售价
	var uom = rowData.get("PurUomId");
	var buom = rowData.get("BUom");
	var confac = Number(rowData.get("ConFac"));
	if(seluom!=uom){
		if(seluom!=buom){     //原单位是基本单位，目前选择的是入库单位
			rowData.set("Rp", Number(rp).mul(confac)); 
			rowData.set("Sp", Number(sp).mul(confac));
			rowData.set("rpAmt", Number(rp).mul(confac).mul(qty)); //购入金额
			rowData.set("spAmt", Number(sp).mul(confac).mul(qty)); //零售金额
		}else{					//目前选择的是基本单位，原单位是入库单位
			rowData.set("Rp", Number(rp).div(confac)); 
			rowData.set("Sp", Number(sp).div(confac));
			rowData.set("rpAmt", Number(rp).div(confac).mul(qty)); //购入金额
			rowData.set("spAmt", Number(sp).div(confac).mul(qty)); //零售金额
		}
	}
	rowData.set("PurUomId", seluom);
});

	
function GetPhaOrderInfo2(item, group) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", HospId,getDrugList2);	
	}
}

//=========================订单录入=============================
var needDateField = new Ext.ux.DateField({
	id:'needDateField',
	fieldLabel:'要求到货日期',
	anchor:'90%',
	value:new Date().add(Date.DAY, parseInt(InPoParamObj.NeedDays))
});

var inpoNoField = new Ext.form.TextField({
	id:'inpoNoField',
	fieldLabel:'订单号',
	allowBlank:true,
	//width:150,
	listWidth:150,
	emptyText:'订单号...',
	anchor:'90%',
	selectOnFocus:true,
	disabled:true
});

// 物资类组
var groupField=new Ext.ux.StkGrpComboBox({ 
		id : 'groupField',
		name : 'groupField',
		StkType:App_StkTypeCode,     //标识类组类型
		LocId:CtLocId,
		UserId:UserId,
		anchor:'90%'
	}); 

var Vendor = new Ext.ux.VendorComboBox({
		id : 'Vendor',
		name : 'Vendor',
		anchor : '90%',
		params : {LocId : 'locField',ScgId : 'groupField'}
	});

var remarkField = new Ext.form.TextField({
	id:'remarkField',
	fieldLabel:'备注',
	allowBlank:true,
	width:200,
	listWidth:200,
	emptyText:'备注...',
	anchor:'90%',
	selectOnFocus:true
});

var finishCK = new Ext.form.Checkbox({
	id: 'finishCK',
	fieldLabel:'完成',
	disabled:true,
	allowBlank:true,
	anchor:'90%'
});

//科室库存项批次信息窗口关闭时回调函数
function returnInfo(record) {
	if (record == null || record == "") {
		return;
	}
	var cell = INPoItmGrid.getSelectionModel().getSelectedCell();
	var rowData = INPoItmGrid.getStore().getAt(cell[0]);
	rowData.set("PurUomId",record.get("PurUomId"));
	rowData.set("PurUom",record.get("PurUomDesc"));
	rowData.set("Sp",record.get("Sp"));
	rowData.set("Rp",record.get("Rp"));
	
	INPoItmGrid.startEditing(INPoItmGridDs.getCount() - 1, 9);
}
//====================================================
//====================================================
function addNewRow() {
	if ((mainRowId!="")&&(Ext.getCmp('finishCK').getValue()==true))
	{
		Msg.info('warning','当前订单已完成,禁止增加明细记录!');
		return;
	}
	var rowCount =INPoItmGrid.getStore().getCount();
	if(rowCount>0){
		var rowData = INPoItmGridDs.data.items[rowCount - 1];
		var data=rowData.get("IncId")
		if(data=="" || data.length<=0){
			var colindex=GetColIndex(INPoItmGrid,"IncDesc");
			INPoItmGrid.startEditing(INPoItmGridDs.getCount() - 1, colindex);
			return;
		}
	}
	groupField.disable();
	var NewRecord = CreateRecordInstance(INPoItmGridDs.fields, {});
	INPoItmGridDs.add(NewRecord);
	//光标跳到名称
	var colindex=GetColIndex(INPoItmGrid,"IncDesc");
	INPoItmGrid.getSelectionModel().select(INPoItmGridDs.getCount() - 1, colindex);
	INPoItmGrid.startEditing(INPoItmGridDs.getCount() - 1, colindex);
}

var SpecDesc = new Ext.ux.ComboBox({
	fieldLabel : '具体规格',
	store : SpecDescStore,
	valueField : 'Description',
	displayField : 'Description',
	emptyText : '具体规格...',
	filterName : 'desc'
});

SpecDesc.on('beforequery', function(combo) {
	var cell = INPoItmGrid.getSelectionModel().getSelectedCell();
	var ItmId = INPoItmGrid.getStore().getAt(cell[0]).get('IncId');
	SpecDescStore.load({params : {start:0,limit:this.pageSize,SpecItmRowId:ItmId}});
});

//配置数据源
var INPoItmGridUrl = 'dhcstm.inpoaction.csp';
var INPoItmGridProxy= new Ext.data.HttpProxy({url:INPoItmGridUrl+'?actiontype=QueryDetail',method:'GET'});
var INPoItmGridDs = new Ext.data.Store({
	proxy:INPoItmGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results'
    }, [
		{name:'PoItmId'},
		{name:'IncId'},
		{name:'IncCode'},
		{name:'IncDesc'},
		{name:'PurUomId'},
		{name:'PurUom'},
		{name:'Spec'},
		{name:'ManfId'},
		{name:'Manf'},
		{name:'PurQty'},
		{name:'Rp'},
		{name:'rpAmt'},
		{name:'Sp'},
		{name:'spAmt'},
		{name:'BUom'},
		{name:'ConFac'},
		'SpecDesc','DemandDate','remark'
	]),
	remoteSort:false,
	pruneModifiedRecords : true
});

//模型
var INPoItmGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"rowid",
        dataIndex:'PoItmId',
        width:150,
        align:'left',
        sortable : true,
		hidden : true
    },{
        header:"incirowid",
        dataIndex:'IncId',
        width:150,
        align:'left',
        sortable : true,
		hidden : true
    },{
        header:"物资代码",
        dataIndex:'IncCode',
        width:100,
        align:'left',
        renderer :Ext.util.Format.InciPicRenderer('IncId'),
        sortable:true
    },{
        header:"物资名称",
        id:'eIncDesc',
        dataIndex:'IncDesc',
        width:250,
        align:'left',
        sortable:true,
		editor:new Ext.form.TextField({
			id:'descField',
			allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var poLoc = Ext.getCmp('locField').getValue();
						var poNeeddate=Ext.getCmp('needDateField').getValue();
						if(poNeeddate!="" && poNeeddate!=""){
							poNeeddate=poNeeddate.format(ARG_DATEFORMAT);
						}
						if((poLoc=="")||(poLoc==null)){
							Msg.info("error","请选择订单科室!");
							return false;
						}
						if((poNeeddate=="")||(poNeeddate==null)){
							Msg.info("error","请选择到货日期") ;
							return false;
						}
						var venId = Ext.getCmp('Vendor').getValue();
						if((venId=="")||(venId==null)){
							Msg.info("error","请选择供应商!");
							return false;
						}
						var group=Ext.getCmp("groupField").getValue();
						GetPhaOrderInfo2(Ext.getCmp('descField').getValue(),group);
					}
				}
			}
        })
    },{
        header:"规格",
        dataIndex:'Spec',
        width:150,
        align:'left',
        sortable:true
    },{
        header:"manfid",
        dataIndex:'ManfId',
        width:150,
        align:'left',
        sortable : true,
		hidden : true
    },{
        header:"厂商",
        dataIndex:'Manf',
        width:150,
        align:'left',
        sortable:true
    },{
        header:"数量",
        id:'ePurQty',
        dataIndex:'PurQty',
        width:100,
        align:'right',
        sortable:true,
		editor:new Ext.form.NumberField({
			id:'qtyField',
			allowBlank:false,
			listeners:{
				specialKey:function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell=INPoItmGrid.getSelectionModel().getSelectedCell();
						var colindex=GetColIndex(INPoItmGrid,"Rp");
						INPoItmGrid.startEditing(cell[0],colindex);
					}
				}
			}
        })
    },{
        header:"单位",
        dataIndex:'PurUomId',
        id:'ePurUomId',
        width:100,
        align:'left',
        sortable:true,
         editor : new Ext.grid.GridEditor(Uom),
		renderer : Ext.util.Format.comboRenderer2(Uom,"PurUomId","PurUom")       
     },{
        header:"单位",
        dataIndex:'PurUom',
        width:100,
        align:'left',
		hidden:true
    },/*{
        header:"售价",
        dataIndex:'Sp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"售价金额",
        dataIndex:'spAmt',
        width:100,
        align:'right',
        sortable:true
    },*/{
        header:"进价",
        dataIndex:'Rp',
        id:'eRp',
        width:100,
        align:'right',
        sortable:true,
    	editor : new Ext.grid.GridEditor(
    		new Ext.ux.NumberField({
    			formatType : 'FmtRP',
				selectOnFocus : true,
				allowBlank : false,
				listeners : {
					'specialkey': function(field, e) {
						//enter键
						if (e.getKey() == Ext.EventObject.ENTER) {
							var resultRpNew = field.getValue();
							if (resultRpNew == null|| resultRpNew.length <= 0) {
				               Msg.info("warning", "进价不能为空!");
				               return;
		               		}
				   			if (resultRpNew <= 0) {
					   			Msg.info("warning",	"进价不能小于或等于0!");
					    		return;
				            }
							addNewRow();
						}
					}
				}
			})
		)
    },{
        header:"进价金额",
        dataIndex:'rpAmt',
        width:100,
        align:'right',
        sortable:true
    },{
		header:"具体规格",
		dataIndex:'SpecDesc',
		width:100,
		align:'left',
		editor : new Ext.grid.GridEditor(SpecDesc),
		renderer : Ext.util.Format.comboRenderer2(SpecDesc,'SpecDesc','SpecDesc')
	}, {
		header : "要求送达日期",
		dataIndex : 'DemandDate',
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
						var CompleteFlag = Ext.getCmp("finishCK").getValue();
						if (CompleteFlag != null && CompleteFlag != false) {
							Msg.info("warning", "订单已完成!");
							return;
						}
					}
				}
			}
		})
	},{
		header:"订单备注",
		dataIndex:'remark',
		id:'remark',
		width:250,
		align:'left',
		sortable:true,
		editor:new Ext.form.TextField({
			id:'remark',
			allowBlank:false
		})
	}
]);
		
//初始化默认排序功能
INPoItmGridCm.defaultSortable = true;

var addINPoM = new Ext.Toolbar.Button({
	text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		//addNewRow();
		clearData();
		Ext.getCmp('Vendor').focus();
	}
});

var findINPoM = new Ext.Toolbar.Button({
	text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		FindINPo(Query);
	}
});

var clearINPoM = new Ext.Toolbar.Button({
	text:'清空',
    tooltip:'清空',
    iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function() {
		if (isDataChanged(formPanel,INPoItmGrid)){
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

var saveINPoM = new Ext.ux.Button({
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(CheckDataBeforeSave()==true){
				// 保存订单
				save();
		}
	}	
});

function CheckDataBeforeSave(){
		var user = UserId;
		var locId = Ext.getCmp('locField').getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error","请选择订单科室!");
			return false;
		}
		var scg = Ext.getCmp('groupField').getValue();
		if((scg=="")||(scg==null)){
			Msg.info("error","请选择类组!");
			return false;
		}
		var venId = Ext.getCmp('Vendor').getValue();
		if((venId=="")||(venId==null)){
			Msg.info("error","请选择供应商!");
			return false;
		}
		return true;
}

function save(){
	var poUser = UserId;
	var poInst = "";
	var poLoc = Ext.getCmp('locField').getValue();
	var poComp = (Ext.getCmp('finishCK').getValue()==true?'Y':'N');
	var poScg = Ext.getCmp('groupField').getValue();
	var poVendor = Ext.getCmp("Vendor").getValue();
	var remark = Ext.getCmp('remarkField').getValue();
	var poNeeddate = Ext.getCmp('needDateField').getValue();
	poNeeddate = Ext.isEmpty(poNeeddate)? '' : poNeeddate.format(ARG_DATEFORMAT);
	var tmpData = poVendor+"^"+poLoc+"^"+poUser+"^"+poScg+"^"+poComp+"^"+remark+"^"+poNeeddate;
	//alert(tmpData);	
	if(tmpData!=""){
		var ListDetail="";
		var rowCount = INPoItmGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = INPoItmGridDs.getAt(i);	
			//新增或数据发生变化时执行下述操作
			if(rowData.data.newRecord || rowData.dirty){					
				var Inpoi=rowData.get("PoItmId");
				var inci = rowData.get("IncId");
				if(Ext.isEmpty(inci)){
					continue;
				}
				var uom = rowData.get("PurUomId");
				var qty = rowData.get("PurQty");
				if(qty==""){
					Msg.info("error","请填写数量!");
					var colindex=GetColIndex(INPoItmGrid,"PurQty");
					INPoItmGrid.startEditing(i,colindex);
					return false;
				}
				var Rp = rowData.get("Rp");
				if(Rp==""||Rp<=0){
					Msg.info("error","请填写进价!");
					var colindex=GetColIndex(INPoItmGrid,"Rp");
					INPoItmGrid.startEditing(i,colindex);
					return false;
				}
				var reqQty=qty; //暂时使用购买数量
				var SpecDesc = rowData.get("SpecDesc");
				var DemandDate=rowData.get("DemandDate");
				DemandDate = Ext.isEmpty(DemandDate)? '' : DemandDate.format(ARG_DATEFORMAT);
				var remark =rowData.get("remark");
				var str = Inpoi + "^" + inci + "^"	+ uom + "^" + Rp+"^"+qty
					+"^"+ reqQty + "^" + SpecDesc + "^" + DemandDate+"^"+remark;
				if(ListDetail==""){
					ListDetail=str;
				}
				else{
					ListDetail=ListDetail+xRowDelim()+str;
				}
			}
		}
		
		if(ListDetail==""){
			//alert(mainRowId);
			if (mainRowId=='')
			{
				Msg.info("error","没有明细!");
				return ;
			}
 		}
        var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
		    url: INPoItmGridUrl+"?actiontype=Save",
		    params:{Main:mainRowId,MainInfo:tmpData,ListDetail:ListDetail},
			method : 'POST',
			waitMsg : '处理中...',
			failure: function(result,request) {
				mask.hide();
				Msg.info("error","请检查网络连接!");
			},
			success: function(result,request) {				
				var jsonData = Ext.util.JSON.decode( result.responseText );
				
				if (jsonData.success=='true') {
					Msg.info("success","保存成功!");
					mainRowId = jsonData.info;
					Query(mainRowId);					
                    changeButtonEnable("1^1^1^1^1^1^0^1")
				}else{
					Msg.info("error","保存失败!"+jsonData.info);
				}
				mask.hide();
			},
			scope: this
		});
	}
}

// 显示订单数据
function Query(InpoRowid) {
	mainRowId=InpoRowid;  //这一句很重要，必须有
	if (InpoRowid == null || InpoRowid.length <= 0 || InpoRowid <= 0) {
		return;
	}
	Ext.Ajax.request({
		url : INPoItmGridUrl + "?actiontype=Select&InpoId=" + InpoRowid,
		method : 'POST',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.results>0) {
			var data=jsonData.rows[0];			
			//alert(data);
			if(data){
				Ext.getCmp('inpoNoField').setValue(data['INPO_No']);
				locField.setValue(data['PoLoc']);
				locField.setRawValue(data['PoLocDesc']);
				needDateField.setValue(data['INPO_DateNeeded']);
				
				addComboData(Vendor.getStore(),data['INPO_APCVM_DR'],data['vendorName']);
				Vendor.setValue(data['INPO_APCVM_DR']);
				//Vendor.setRawValue(data['vendorName']);
				addComboData(null,data['StkGrpId'],data['StkGrpDesc'],groupField);
				groupField.setValue(data['StkGrpId']);
				//groupField.setRawValue(data['StkGrpDesc']);
				//remark=handleMemo(remark,xMemoDelim());
				//remarkField.setValue(remark);	
				if( data['INPO_Completed']=="Y"){				
					changeButtonEnable("1^1^1^0^0^0^1^1")
					finishCK.setValue(true);
					/*
					saveINPoM.disable();
					deleteINPoM.disable();
					*/
				}
				else{
					changeButtonEnable("1^1^1^1^1^1^0^1")					
					finishCK.setValue(false);
					/*
					saveINPoM.enable();
					deleteINPoM.enable();
					*/
				}
	 
				Ext.getCmp('remarkField').setValue(handleMemo(data['INPO_Remarks'],xMemoDelim()));
				
				//检索明细
				getDetail(InpoRowid);
			}				
			}
		},
		scope : this
	});	
}
		
// 显示报损单明细数据
function getDetail(InpoRowid) {
	if (InpoRowid == null || InpoRowid.length <= 0 || InpoRowid <= 0) {
		return;
	}
	INPoItmGridDs.removeAll();
	INPoItmGridDs.load({params:{start:0,limit:999,Parref:InpoRowid}});

	// 变更按钮是否可用
	//查询^清除^新增^保存^删除^完成^取消完成
	//var inGrFlag = Ext.getCmp("CompleteFlag").getValue();
	//if(inGrFlag==true){
	//	changeButtonEnable("1^1^0^0^0^0^1");
	//}else{
	//	changeButtonEnable("1^1^1^1^1^1^0");
	//}
}
		
/**
 * 删除选中行物资
 */
function deleteDetail() {
	// 判断订单是否已完成
	var CmpFlag = Ext.getCmp("finishCK").getValue();
	if (CmpFlag != null && CmpFlag != false) {
		Msg.info("warning", "当前订单已完成,禁止删除明细记录!");
		return;
	}
	var cell = INPoItmGrid.getSelectionModel().getSelectedCell();
	if (cell == null) {
		Msg.info("warning", "没有选中行!");
		return;
	}
	// 选中行
	var row = cell[0];
	var record = INPoItmGrid.getStore().getAt(row);
	var Inpoi = record.get("PoItmId");
	if (Inpoi == "" ) {
		INPoItmGrid.getStore().remove(record);
		INPoItmGrid.getView().refresh()
	} else {
		Ext.MessageBox.show({
			title : '提示',
			msg : '是否确定删除该物资信息',
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
		var cell = INPoItmGrid.getSelectionModel().getSelectedCell();
		var row = cell[0];
		var record = INPoItmGrid.getStore().getAt(row);
		var Inpoi = record.get("PoItmId");
		//alert("Inpoi="+Inpoi)

		// 删除该行数据
		var url = INPoItmGridUrl + "?actiontype=deleteItem&InPoi=" + Inpoi;

		Ext.Ajax.request({
					url : url,
					method : 'POST',
					waitMsg : '删除中...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
								//alert("jsonData="+jsonData)
						if (jsonData.success == 'true') {
							Msg.info("success", "删除成功!");
							INPoItmGrid.getStore().remove(record);
							INPoItmGrid.getView().refresh();
						} else {
							var ret=jsonData.info;
							if(ret==-1){
								Msg.info("error", "订单已经完成，不能删除!");
							}else{
								Msg.info("error", "删除失败,请查看错误日志!");
							}
						}
					},
					scope : this
				});
	}
}

var deleteINPoM = new Ext.Toolbar.Button({
	text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
	/*	var cell = INPoItmGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error","请选择数据!");
			return false;
		}else{  */
			
			var rowid = mainRowId
			if(rowid!=""){
				Ext.MessageBox.confirm('提示','确定要删除该订单?',
					function(btn) {
							if(btn == "yes"){
							Ext.Ajax.request({
								//url : INPoItmGridUrl + "?actiontype=delete&InpoId=" +mainRowId,
								url : INPoItmGridUrl + "?actiontype=delete&InpoId=" +rowid,
								waitMsg:'删除中...',
								failure: function(result, request) {
									Msg.info("error", "请检查网络连接!");
									return false;
								},
								success : function(result, request) {
									var jsonData = Ext.util.JSON.decode(result.responseText);
									if (jsonData.success == 'true') {
										//INPoItmGridDs.load({params:{Parref:mainRowId}});
										Msg.info("success", "订单删除成功!");
									    clearData();
									}else{
										var ret=jsonData.info;
									if(ret==-1){
										Msg.info("error", "订单已经完成，不能删除!");
									}if(ret==-3){
										Msg.info("error", "删除订单失败!");
									}if(ret==-4){
										Msg.info("error", "删除订单附加表失败!");
									}else{
										Msg.info("error", "删除失败,请查看错误日志!");
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
				Msg.info("error", "订单Id为空,不允许删除!");
				return false;
			}
		//}
	}
});
//--------------------
function clearData(){
	SetLogInDept(locField.getStore(),'locField')
	mainRowId='';
	Ext.getCmp('needDateField').setValue(new Date());
	Ext.getCmp('inpoNoField').setValue("");
	Ext.getCmp('remarkField').setValue("");
	Ext.getCmp("Vendor").setValue("");
	Ext.getCmp("finishCK").setValue(false);
	groupField.setDisabled(false);
	groupField.getStore().load();
	INPoItmGridDs.removeAll();
	//saveINPoM.enable();
	//deleteINPoM.enable();
	changeButtonEnable("1^1^1^1^0^0^0^0")
}

var finshInpo = new Ext.Toolbar.Button({
	text:'完成',
    tooltip:'完成',
    iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		if((mainRowId=="")||(mainRowId==null)){
			Msg.info("error", "订单为空!");
			return false;
		}else{
			if(Ext.getCmp("finishCK").getValue()==true){
				Msg.info("warning","该订单已经完成!")
				return;
			}
			Ext.MessageBox.confirm('提示','确定要完成该订单吗?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'dhcstm.inpoaction.csp?actiontype=finish&InpoId='+mainRowId+'&Usr='+UserId,
							waitMsg:'更新中...',
							failure: function(result, request) {
								Msg.info("error", "请检查网络连接!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success", "订单设置为完成状态!");
									Query(mainRowId);
									changeButtonEnable("1^1^1^0^0^0^1^1")
								}else{
									
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
	}
});

var noFinshInpo = new Ext.Toolbar.Button({
	text:'取消完成',
    tooltip:'取消完成',
    iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		if((mainRowId=="")||(mainRowId==null)){
			Msg.info("error", "订单为空!");
			return false;
		}else{
			if(Ext.getCmp("finishCK").getValue()==false){
				Msg.info("warning","该单据尚未完成!!")
				return;
			}
			Ext.MessageBox.confirm('提示','确定要取消完成该订单吗?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'dhcstm.inpoaction.csp?actiontype=noFinish&InpoId='+mainRowId+'&Usr='+UserId,
							waitMsg:'处理中...',
							failure: function(result, request) {
								Msg.info("error", "请检查网络连接!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success", "订单设置为未完成状态!");
									Query(mainRowId);
									changeButtonEnable("1^1^1^1^1^1^0^1")
								}else{
									if(jsonData.info==-2){
										Msg.info("error", "该订单已经转入库,禁止修改状态!");
										return false;
									}else if(jsonData.info==-11){
										Msg.info("error", "订单已经验收!");
										return false;
									}else{
									  Msg.info("error", "操作失败!");
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
	}
});

// 打印订单按钮
var PrintBT = new Ext.Toolbar.Button({
	id : "PrintBT",
	text : '打印',
	tooltip : '点击打印订单',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		PrintInPo(mainRowId);
	}
});

var formPanel = new Ext.form.FormPanel({
	region : 'north',
	autoHeight : true,
	title:'订单录入',
	labelAlign : 'right',
	frame : true,
	layout:'fit',
	//bodyStyle : 'padding:5px;',
    tbar:[addINPoM,'-',findINPoM,'-',saveINPoM,'-',deleteINPoM,'-',clearINPoM,'-',finshInpo,'-',noFinshInpo,'-',PrintBT],
	items : [{
		xtype : 'fieldset',
		title : '订单主信息',
		layout : 'column',		
		autoHeight : true,
		items : [{
			columnWidth : .25,
			layout : 'form',
			items : [locField,Vendor]
		}, {
			columnWidth : .25,
			layout : 'form',
			items : [inpoNoField,needDateField]
		}, {
			columnWidth : .25,
			layout : 'form',
			items : [groupField,remarkField]
		}, {
			columnWidth : .25,
			layout : 'form',
			items : [finishCK]
		}]
	}]

});

var AddDetailBT=new Ext.Button({
	text:'增加一条',
	tooltip:'',
	height:30,
	width:70,
	iconCls:'page_add',
	handler:function()
	{	
             	var locId = Ext.getCmp('locField').getValue();
		if((locId=="")||(locId==null)){
			Msg.info("warning","请选择订单科室!");
			return false;
		}
		var scg = Ext.getCmp('groupField').getValue();
		if((scg=="")||(scg==null)){
			Msg.info("warning","请选择类组!");
			return false;
		}
		var venId = Ext.getCmp('Vendor').getValue();
		if((venId=="")||(venId==null)){
			Msg.info("warning","请选择供应商!");
			return false;
		}
		addNewRow();
		changeButtonEnable("1^1^1^1^0^0^0^0")
	}
});

var DelDetailBT=new Ext.Button({
	text:'删除一条',
	tooltip:'',
	height:30,
	width:70,
	iconCls:'page_delete',
	handler:function()
	{
		deleteDetail();
	}
});

//表格
var INPoItmGrid = new Ext.grid.EditorGridPanel({
	title:'订单明细',
	store:INPoItmGridDs,
	cm:INPoItmGridCm,
	trackMouseOver:true,
	region:'center',
	height:650,
	stripeRows:true,
	loadMask:true,
	tbar:{items:[AddDetailBT,'-',DelDetailBT,'-',{text:'列设置',iconCls:'page_gear',height:30,width:70,handler:function(){	GridColSet(INPoItmGrid,"DHCSTPOM");}}]},
	clicksToEdit:1,
	sm:new Ext.grid.CellSelectionModel({}),
	listeners:{
		beforeedit:function(e){
			if(Ext.getCmp('finishCK').getValue()){
				return false;
			}
		},
		afteredit:function(e){
			if(e.field=='PurQty'){
				e.record.set("spAmt", accMul(e.value, e.record.get('Sp')));
				e.record.set("rpAmt", accMul(e.value, e.record.get('Rp')));
			}else if(e.field=='Rp'){
				var newQty=e.record.get("PurQty");
				e.record.set("rpAmt", accMul(e.value, newQty));
			}
		},
		rowcontextmenu : function(grid,rowindex,e){ 
			e.preventDefault(); 
			rightClick.showAt(e.getXY()); 
		}
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
	//新建^查询^清空^保存^删除^完成^取消完成
	addINPoM.setDisabled(list[0]);
	findINPoM.setDisabled(list[1]);
	clearINPoM.setDisabled(list[2]);
	saveINPoM.setDisabled(list[3]);
	deleteINPoM.setDisabled(list[4]);
	finshInpo.setDisabled(list[5]);
	noFinshInpo.setDisabled(list[6]);
	PrintBT.setDisabled(list[7]);
}
changeButtonEnable("1^1^1^1^0^0^0^0")
//=========================订单录入=============================

//===========模块主页面=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:'订单录入',
		activeTab:0,
		region:'north',
		height:170,
		layout:'fit',
		items:[formPanel]
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,INPoItmGrid],
		renderTo:'mainPanel'
	});
	
	RefreshGridColSet(INPoItmGrid,"DHCSTPOM");   //根据自定义列设置重新配置列
});
//===========模块主页面=============================================