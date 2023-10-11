// 名称:采购计划单
// 编写日期:2012-06-19

var deptId = locId;
var deptName = "";
var purId = planNnmber;
var purNo = "";
var PurPlan="";
var PlanPageSize=9999
var UserId = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'];
var CtLocId = session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
var APPName="DHCSTPURPLANAUDIT"
var PurPlanParam=PHA_COM.ParamProp(APPName)


//var arr = window.status.split(":");
//var length = arr.length;
var inciDr = "";
var colArr = [];
var Msg_LostModified=$g('数据已录入或修改，你当前的操作将丢失这些结果，是否继续?');

var gParamIngd = PHA_COM.ParamProp("DHCSTIMPORT")

if(gParam.length<1){
	GetParam();
}
if(gParamCommon.length<1){
	GetParamCommon();  
}

/// 检查管控药品  Y :管控 N:不管控
function CheckPoisonLimit(Vendor,inci,inciDesc){
	if (!Vendor || !inci) return "N";
	var limitFalg = "N"
	var VendorPoisonLimit = gParamIngd.VendorPoisonLimit
	if (VendorPoisonLimit){
		var poisonFlag = tkMakeServerCall("web.DHCST.Common.DrugInfoCommon","CheckPoisonForVendor",inci)
           if (poisonFlag == "Y") {
	           var vendorPoisonFlag = tkMakeServerCall("PHA.IN.Vendor.Query","GetVendorPoisonLimit",Vendor)
               var vendorPoisonObj = JSON.parse(vendorPoisonFlag)
               if(vendorPoisonObj.PoisonCFlag != "Y" && vendorPoisonObj.PoisonPFlag != "Y"){
	               Msg.info("warning", $g(inciDesc+"为麻醉精一药品，而经营企业无麻醉精一药品录入权限!"));
	               if(VendorPoisonLimit == 2) 
	                {
	                    limitFalg = "Y"
	                }
               }
           }
	}
	return limitFalg;
}


function getDrugList2(record) {
	if (record == null || record == "") {
		return false;
	}
	inciDr = record.get("InciDr");
	// 选中行
	//var rowrecord = PlanGrid.getSelectionModel().getSelected();
	//var row = PlanGridDs.indexOf(rowrecord)
	 var cell = PlanGrid.getSelectionModel().getSelectedCell();
     var row = cell[0];
	var findIndex=PlanGridDs.findExact ('IncId',inciDr,0);
	
	if(findIndex>=0 && findIndex!=row){
		Msg.info("warning",$g("药品重复录入!"));
		var col=GetColIndex(PlanGrid,"Qty");
		PlanGrid.startEditing(row, col);
	}
	
	var rowData = PlanGrid.getStore().getAt(row);
	var InciDesc = record.get("InciDesc")
	rowData.set("IncId",inciDr);
	rowData.set("IncCode",record.get("InciCode"));
	rowData.set("IncDesc",InciDesc);
	//经营企业id^经营企业名称^产地id^产地名称^配送企业id^配送企业名称^入库单位id^入库单位^进价^售价^申购科室库存量^库存上限^库存下限^通用名^商品名^剂型^规格
	//{success:'true',info:'7^GAYY-北京广安医药联合中心^61^bjymzy-北京益民制药厂^^^26^盒[20片]^0^0^0^^^艾司唑仑片^^普通片剂^[1mg*20]'}
	//取其它药品信息
	var locId = Ext.getCmp('locField').getValue();
	var Params=session['LOGON.GROUPID']+'^'+locId+'^'+UserId;	
	if(locId!=""){
		Ext.Ajax.request({
			url : 'dhcst.inpurplanaction.csp?actiontype=GetItmInfo&lncId='+ inciDr+'&Params='+Params,
			method : 'POST',
			waitMsg : $g('查询中...'),
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText.replace(/\r/g,"").replace(/\n/g,""));
				if (jsonData.success == 'true') {
					var data=jsonData.info.split("^");
					var VenId = data[0];
					var Vendor = data[1];
					/// 检查麻醉精一药品管控
					var Ret = CheckPoisonLimit(Vendor,inciDr,InciDesc)
					if (Ret == "Y"){
						rowData.set("IncId","");
						rowData.set("IncCode","");
						rowData.set("IncDesc","");
						return;
					}
					addComboData(Ext.getCmp("Vendor").getStore(),VenId,Vendor);
					rowData.set("VenId", VenId);    //经营企业
					var ManfId = data[2];
					var Manf = data[3];
					
					addComboData(PhManufacturerStore,ManfId,Manf);
					rowData.set("ManfId", ManfId);    //生产商
					var CarrierId = data[4];
					var Carrier = data[5];
					addComboData(CarrierStore,CarrierId,Carrier);
					rowData.set("CarrierId", CarrierId);    //配送企业
					var UomId=data[6];
					var Uom=data[7];
					addComboData(ItmUomStore,UomId,Uom);
					rowData.set("UomId", UomId);    //默认为大单位调价
					rowData.set("Rp", data[8]); 
					rowData.set("Sp", data[9]); 
					rowData.set("CurStkQty", data[10]); 
					rowData.set("MaxQty", data[11]);     
					rowData.set("MinQty", data[12]);  
					rowData.set("Gene", data[13]);     
					rowData.set("GoodName", data[14]);     
					rowData.set("Form", data[15]);     
					rowData.set("Spec", data[16]); 
					rowData.set("BUomId", data[17]); 
					rowData.set("ConFacPur", data[18]); 
					rowData.set("FreeDrugFlag", data[20]);
					
				    //===========判断资质信息===========
				    var inci=record.get("InciDr")
				    var DataList=VenId+"^"+inci+"^"+ManfId
				    //alert(DataList)
				   // var urldh = DictUrl+ "ingdrecaction.csp?actiontype=Check&DataList="+ DataList
				    
				     if (setEnterSort(PlanGrid, colArr)) {
                                addNewRow();
                            }
				    var CertExpDateInfo = tkMakeServerCall("PHA.IN.Cert.Query","CheckExpDate",VenId,ManfId)
                    if (CertExpDateInfo != ""){
	                  	Msg.info("warning", CertExpDateInfo);
	                    return;  
                    }         
 
				    //===========判断资质信息===========	
				} 
			},
			scope : this
		});
	}else{
		Msg.info("error", $g("请选择科室!"));
	}
	
}
	
function GetPhaOrderInfo2(item, group) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",getDrugList2);
	}
}

//=========================采购计划单=============================
var dateField = new Ext.ux.DateField({
	id:'dateField',
    allowBlank:false,
	fieldLabel:'日期',
	anchor:'90%',
	value:new Date(),
	editable:false,
	disabled:true
});

// 打印采购按钮
var PrintBT = new Ext.Toolbar.Button({
	id : "PrintBT",
	text : $g('打印'),
	tooltip : $g('点击打印采购单'),
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
	  var zbflagstr=getZBflag();
		
		PrintInPur(PurPlan,zbflagstr);
	}
});
 //复制按钮
var CopyBT = new Ext.Toolbar.Button({
			text : $g('复制采购计划'),
			width : 70,
			height : 30,
			iconCls : 'page_copy',
			handler : function() {
				FindPlan(Copy);
			}
		});
// 按照科室库存生成采购计划单
var ConWinBT = new Ext.Toolbar.Button({
	id : "ConWinBT",
	text : $g('生成采购计划单'),
	tooltip : $g('生成采购计划单'),
	iconCls : 'page_goto',
	width : 70,
	height : 30,
	handler : function() {
		InPurPlanConWin(Select);
	}
});
var planNumField = new Ext.form.TextField({
	id:'planNum',
	fieldLabel:$g('计划单号'),
	allowBlank:true,
	emptyText:$g('计划单号...'),
	disabled:true,
	anchor:'90%',
	selectOnFocus:true
});
// 药品类组
var groupField=new Ext.ux.StkGrpComboBox({ 
	id : 'groupField',
	name : 'groupField',
	StkType:App_StkTypeCode,     //标识类组类型
	anchor : '90%',
	LocId:CtLocId,
	UserId:UserId
}); 
		
var locField = new Ext.ux.LocComboBox({
	id:'locField',
	fieldLabel:$g('科室'),
	anchor:'90%',
	listWidth:210,
	allowBlank:true,
	emptyText:$g('科室...'),
	groupId:gGroupId,
	listeners : {
			'select' : function(e) {
                          var SelLocId=Ext.getCmp('locField').getValue();//add wyx 根据选择的科室动态加载类组
                          groupField.getStore().removeAll();
                          groupField.getStore().setBaseParam("locId",SelLocId)
                          groupField.getStore().setBaseParam("userId",UserId)
                          groupField.getStore().setBaseParam("type",App_StkTypeCode)
                          groupField.getStore().load();
			}
	}
});

		   // 招标
		var ZBFlag = new Ext.form.Radio({
			boxLabel : $g('招标'),
			id : 'ZBFlag',
			name : 'ZBType',
			anchor : '80%'
				});
					   // 非招标
		var NotZBFlag = new Ext.form.Radio({
			boxLabel : $g('非招标'),
			id : 'NotZBFlag',
			name : 'ZBType',
			anchor : '80%'
				});
					   // 全部
		var AllFlag = new Ext.form.Radio({
			boxLabel : $g('全部'),
			id : 'AllFlag',
			name : 'ZBType',
			anchor : '80%',
			checked : true
				});	
		
//====================================================
var Uom = new Ext.form.ComboBox({
	fieldLabel : $g('单位'),
	id : 'Uom',
	name : 'Uom',
	anchor : '90%',
	store : ItmUomStore,
	valueField : 'RowId',
	displayField : 'Description',
	emptyText : $g('单位...'),
	triggerAction : 'all',
	forceSelection : true,
	allowBlank : false,
	selectOnFocus : true,
	valueNotFoundText : '',
	listeners:{
		specialKey:function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				if (setEnterSort(PlanGrid, colArr)) {
                                addNewRow();
                            }		
			}
		},
		'focus':function(field){
			var cell = PlanGrid.getSelectionModel().getSelectedCell();
     		var row = cell[0];
			var record = PlanGrid.getStore().getAt(row);
			var ItmId=record.get("IncId");
			if(ItmId==null||ItmId==""){
				Msg.info("warning",$g("请先录入药品名称!"));
				return;
			}		
			ItmUomStore.removeAll();
			ItmUomStore.load({
				params:{ItmRowid:ItmId}
			});
		}
	}
});		
ItmUomStore.on("load",function(store){
	var cell = PlanGrid.getSelectionModel().getSelectedCell();
     var row = cell[0];
	var record = PlanGrid.getStore().getAt(row);
	var UomId=record.get("UomId");	
	Uom.setValue(UomId);
})
/**
 * 单位展开事件
 */
Uom.on('beforequery', function(combo) {
			var cell = PlanGrid.getSelectionModel().getSelectedCell();
    		var row = cell[0];
			var record = PlanGrid.getStore().getAt(row);
			var ItmId = record.get("IncId");
			var UomId=record.get("UomId");		
			ItmUomStore.removeAll();
			ItmUomStore.load({
				params:{ItmRowid:ItmId}
			});
		});
Uom.on('select', function(combo) {
	var cell = PlanGrid.getSelectionModel().getSelectedCell();
    var row = cell[0];
	var rowData = PlanGrid.getStore().getAt(row);
	var qty = rowData.get('Qty');
	if((qty=="")||(qty==null)){
		qty = 0;
	}

	var seluom=combo.getValue();
	var rp = rowData.get("Rp"); //原进价
	var sp = rowData.get("Sp"); //原售价
	var buom=rowData.get("BUomId")
	var confac=rowData.get("ConFacPur")
	var uom=rowData.get("UomId")
	if(seluom!=uom){
		if(seluom!=buom){     //原单位是基本单位，目前选择的是入库单位
			rowData.set("Rp", Number(rp).mul(confac)); 
			rowData.set("Sp", Number(sp).mul(confac));
			rowData.set("RpAmt", Number(rp).mul(confac).mul(qty)); //购入金额
			rowData.set("SpAmt", Number(sp).mul(confac).mul(qty)); //零售金额
		}else{					//目前选择的是基本单位，原单位是入库单位
			rowData.set("Rp", Number(rp).div(confac)); 
			rowData.set("Sp", Number(sp).div(confac));
			rowData.set("RpAmt", Number(rp).div(confac).mul(qty)); //购入金额
			rowData.set("SpAmt", Number(sp).div(confac).mul(qty)); //零售金额
		}
	}
	rowData.set("UomId", seluom);
});

var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : $g('经营企业'),
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%',
	emptyText : $g('经营企业...'),
	listWidth : 250,
	listeners:{
		specialkey:function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER) {
				 if (setEnterSort(PlanGrid, colArr)) {
                                addNewRow();
                            }		
			}
		},
		select:function(field,record,index){
			var vendor = record.id
			var cell = PlanGrid.getSelectionModel().getSelectedCell();
     		var row = cell[0];
	 		var rowData = PlanGrid.getStore().getAt(row);
	 		var Inci = rowData.data.IncId;
	 		var InciDesc = rowData.data.IncDesc;
	 		var Ret = CheckPoisonLimit(vendor,Inci,InciDesc)
	 		if (Ret == "Y" ){
		 		Ext.getCmp("Vendor").setValue("");
	 		}
	 		
			
		}
	}
});		

var Carrier = new Ext.ux.ComboBox({
	fieldLabel : $g('配送企业'),
	id : 'Carrier',
	name : 'Carrier',
	store : CarrierStore,
	valueField : 'RowId',
	displayField : 'Description',
	emptyText : $g('配送企业...'),
	filterName:'CADesc',
	listeners:{
		specialkey:function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER) {
				 if (setEnterSort(PlanGrid, colArr)) {
                                addNewRow();
                            }		
			}
		}
	}
});		
			
var Manf = new Ext.ux.ComboBox({
	fieldLabel : $g('生产企业'),
	id : 'Manf',
	name : 'Manf',
	store : PhManufacturerStore,
	valueField : 'RowId',
	displayField : 'Description',
	emptyText : $g('生产企业...'),
	filterName:'PHMNFName',
	listeners:{
		specialkey:function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER) {
				 if (setEnterSort(PlanGrid, colArr)) {
                                addNewRow();
                            }		
			}
		}
	}
});		

var ReqLoc = new Ext.ux.LocComboBox({
	fieldLabel : $g('申购科室'),
	id : 'ReqLoc',
	name : 'ReqLoc',
	defaultLoc:'',
     //disabled:true
	listeners:{
		specialkey:function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER) {
				 if (setEnterSort(PlanGrid, colArr)) {
                                addNewRow();
                            }		
			}
		}
	}
});	

var Complete=new Ext.form.Checkbox({
	fieldLabel : $g('完成'),
	id : 'Complete',
	name : 'Complete',
	anchor : '90%',
	width : 150,
	checked : false,
	disabled:true,
	listeners:{
		'check':function(chk,v){
			setGridEditable(PlanGrid,!v);
		}	
	}
});

//====================================================

function addNewRow() {
	var rowCount =PlanGrid.getStore().getCount();
	if(rowCount>0){
		var rowData = PlanGridDs.data.items[rowCount - 1];
		var data=rowData.get("IncId")
		if(data=="" || data.length<=0){
			var col=GetColIndex(PlanGrid,'IncDesc');
			//PlanGrid.getSelectionModel().selectRow(PlanGridDs.getCount() - 1)
			PlanGrid.startEditing(PlanGridDs.getCount() - 1, col);
			return;
		}
	}
	var record = Ext.data.Record.create([
		{
			name : 'RowId',
			type : 'int'
		}, {
			name : 'IncId',
			type : 'int'
		}, {
			name : 'IncCode',
			type : 'string'
		}, {
			name : 'IncDesc',
			type : 'string'
		}, {
			name : 'Spec',
			type : 'string'
		}, {
			name : 'ManfId',
			type : 'int'
		}, {
			name : 'Manf',
			type : 'string'
		}, {
			name : 'Qty',
			type : 'string'
		}, {
			name : 'UomId',
			type : 'int'
		}, {
			name : 'Uom',
			type : 'string'
		}, {
			name : 'Rp',
			type : 'double'
		}, {
			name : 'Sp',
			type : 'double'
		}, {
			name : 'RpAmt',
			type : 'double'
		}, {
			name : 'SpAmt',
			type : 'double'
		}, {
			name : 'VenId',
			type : 'int'
		}, {
			name : 'Vendor',
			type : 'string'
		}, {
			name : 'CarrierId',
			type : 'int'
		}, {
			name : 'Carrier',
			type : 'string'
		}, {
			name : 'Gene',
			type : 'string'
		}, {
			name : 'GoodName',
			type : 'string'
		}, {
			name : 'Form',
			type : 'string'
		}, {
			name : 'PoId',
			type : 'int'
		}, {
			name : 'ReqLocId',
			type : 'int'
		}, {
			name : 'ReqLoc',
			type : 'string'
		}, {
			name : 'StkQty',
			type : 'int'
		}, {
			name : 'MaxQty',
			type : 'int'
		}, {
			name : 'MinQty',
			type : 'int'
		}, {
			name : 'ProPurQty',
			type : 'string'
		}, {
			name : 'CurStkQty',
			type : 'string'
		}, {
            name: 'FreeDrugFlag',
            type: 'string'
        }
	]);
	
	var NewRecord = new record({
		RowId:'',
		IncId:'',
		IncCode:'',
		IncDesc:'',
		Spec:'',
		ManfId:'',
		Manf:'',
		Qty:'',
		UomId:'',
		Uom:'',
		Rp:'',
		Sp:'',
		RpAmt:'',
		SpAmt:'',
		VenId:'',
		Vendor:'',
		CarrierId:'',
		Carrier:'',
		Gene:'',
		GoodName:'',
		Form:'',
		PoId:'',
		ReqLocId:'',
		ReqLoc:'',
		StkQty:'',
		MaxQty:'',
		MinQty:'',
		ProPurQty:'',
		CurStkQty:'',
		FreeDrugFlag:'',
		DispQty:''
	});
					
	PlanGridDs.add(NewRecord);
	//PlanGrid.getSelectionModel().selectRow(PlanGridDs.getCount() - 1);
	var col=GetColIndex(PlanGrid,'IncDesc');
	PlanGrid.startEditing(PlanGridDs.getCount() - 1, col);
}

var PlanGrid="";
//配置数据源
var PlanGridUrl = 'dhcst.inpurplanaction.csp';
var PlanGridProxy= new Ext.data.HttpProxy({url:PlanGridUrl+'?actiontype=queryItem',method:'POST'});
var PlanGridDs = new Ext.data.Store({
	proxy:PlanGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results'
    }, [
	/*
	子表Rowid^库存项id^代码^名称^规格^生产企业id^生产企业^数量^单位id^单位
/// ^进价^售价^进价金额^售价金额^经营企业id^经营企业^配送企业id^配送企业^通用名^商品名^剂型^订单RowId
/// ^申购科室id^申购科室名称^申购科室库存量^库存上限^库存下限
*/
		{name:'RowId'},
		{name:'IncId'},
		{name:'IncCode'},
		{name:'IncDesc'},
		{name:'Spec'},
		{name:'ManfId'},
		{name:'Manf'},
		{name:'Qty'},
		{name:'UomId'},
		{name:'Uom'},
		{name:'Rp'},
		{name:'Sp'},
		{name:'RpAmt'},
		{name:'SpAmt'},
		{name:'VenId'},
		{name:'Vendor'},
		{name:'CarrierId'},
		{name:'Carrier'},
		{name:'Gene'},
		{name:'GoodName'},
		{name:'Form'},
		{name:'PoId'},
		{name:'ReqLocId'},
		{name:'ReqLoc'},
		{name:'StkQty'},
		{name:'MaxQty'},
		{name:'MinQty'},
		{name:'BUomId'},
		{name:'ConFacPur'},
		{name:'ProPurQty'},
		{name:'CurStkQty'},
		{name:'FreeDrugFlag'},
		{name:'DispQty'},
		
	]),
    remoteSort:true,
    pruneModifiedRecords:true,
    baseParams:{
    	parref:''
    }
});

//模型
var PlanGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"RowId",
        dataIndex:'RowId',
        width:100,
        align:'left',
        hidden:true,
        sortable:true
    }, {
        header:$g("代码"),
        dataIndex:'IncCode',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("名称"),
        dataIndex:'IncDesc',
        id:'IncDesc',
        width:250,
        align:'left',
        sortable:true,
		editor:new Ext.form.TextField({
			id:'descField',
			selectOnFocus : true,
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						GetPhaOrderInfo2(Ext.getCmp('descField').getValue(),Ext.getCmp("groupField").getValue());
					}
				}
			}
        })
    },{
        header:$g("单位"),
        dataIndex:'UomId',
        id:'UomId',
        width:80,
        align:'left',
		editor : new Ext.grid.GridEditor(Uom),
		renderer : Ext.util.Format.comboRenderer2(Uom,"UomId","Uom")
    },{
        header:$g("采购数量"),
        dataIndex:'Qty',
        id:'Qty',
        width:80,
        align:'right',
        sortable:true,
		editor: new Ext.form.NumberField({
			id:'qtyField',
            allowBlank:false,
			selectOnFocus:true,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						/*var col=GetColIndex(PlanGrid,"VenId")
						var rowrecord = PlanGrid.getSelectionModel().getSelected();
						var row = PlanGridDs.indexOf(rowrecord)
						PlanGrid.startEditing(row, col);*/
						 if (setEnterSort(PlanGrid, colArr)) {
                                addNewRow();
                            }	
					}
				},
				'change':function() { 
					var cell = PlanGrid.getSelectionModel().getSelectedCell();
     				var row = cell[0];
					var rowData = PlanGrid.getStore().getAt(row);
					var qty = rowData.get('Qty');
					rowData.set("RpAmt", rowData.get('Rp')*qty); //购入金额
					rowData.set("SpAmt", rowData.get('Sp')*qty); //零售金额
				} 
			}
        })
    },{
        header:$g("进价"),
        dataIndex:'Rp',
        id:'Rp',
        width:80,
        align:'right',
        sortable:true,
        editor:new Ext.ux.NumberField({
			selectOnFocus : true,
			allowBlank : false,
			formatType: 'FmtRP',
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cost = field.getValue();
						var cell = PlanGrid.getSelectionModel().getSelectedCell();
    					 var row = cell[0];
						var rowData = PlanGrid.getStore().getAt(row);
						var FreeDrugFlag = rowData.get('FreeDrugFlag');
						if(cost==0&&FreeDrugFlag!="Y") {
							Msg.info("warning", $g("非免费药进价不能为零"));
							return;
						}
						else if (cost!=0&&FreeDrugFlag=="Y"){
							Msg.info("warning", $g("免费药进价必须为零"));
							return;
						}
						else if ((cost == null || cost=="" || cost==0)&(gParam[0].trim()=="Y")&&(FreeDrugFlag!="Y")) {
							Msg.info("warning", $g("进价不能为空或零!"));
							return;
						}

						if (cost < 0) {
							Msg.info("warning",$g("进价不能小于0!"));
							return;
						}
					
					
						// 计算指定行的进货金额
						
						var spcost = rowData.get('Sp');
						/* 采购不是最终进价，无需判断进售价关系
						if (Number(cost)>Number(spcost)){
						   Msg.info("warning",$g("进价不能大于售价!"));
						   var colIndex=GetColIndex(PlanGrid,"Rp");
						   PlanGrid.startEditing(row, colIndex);
						   rowData.set("Rp","");
						   return;
							}
							*/
						
						var qty = rowData.get('Qty');
						rowData.set("RpAmt", Number(cost).mul(qty)); //购入金额
						
						// 新增一行
						 if (setEnterSort(PlanGrid, colArr)) {
                                addNewRow();
                            }	
					}
				}
			}
		})

    },{
        header:$g("售价"),
        dataIndex:'Sp',
        width:80,
        align:'right',
        sortable:true
    },{
        header:$g("经营企业"),
        dataIndex:'VenId',
        id:'VenId',
        width:250,
        align:'left',
        sortable:true,
		editor : new Ext.grid.GridEditor(Vendor),
		renderer : Ext.util.Format.comboRenderer2(Vendor,"VenId","Vendor")
    },{
        header:$g("配送企业"),
        dataIndex:'CarrierId',
        id:'CarrierId',
        width:200,
        align:'left',
        sortable:true,
		editor : new Ext.grid.GridEditor(Carrier),
		renderer : Ext.util.Format.comboRenderer2(Carrier,"CarrierId","Carrier")
    },{
        header:$g("生产企业"),
        dataIndex:'ManfId',
        id:'ManfId',
        width:200,
        align:'left',
        sortable:true,
		editor : new Ext.grid.GridEditor(Manf),
		renderer : Ext.util.Format.comboRenderer2(Manf,"ManfId","Manf")
    },{
        header:$g("申购科室"),
        dataIndex:'ReqLocId',
        id:'ReqLocId',
        width:150,
        align:'left',
        sortable:true,
		editor : new Ext.grid.GridEditor(ReqLoc),
		renderer : Ext.util.Format.comboRenderer2(ReqLoc,"ReqLocId","ReqLoc")
    },{
        header:$g("规格"),
        dataIndex:'Spec',
        width:120,
        align:'left'
    },{
        header:$g("库存下限"),
        dataIndex:'MinQty',
        width:100,
        align:'right'
    },{
        header:$g("库存上限"),
        dataIndex:'MaxQty',
        width:100,
        align:'right'
    },{
        header:$g("处方通用名"),
        dataIndex:'Gene',
        width:150,
        align:'left'
    },{
        header:$g("购入金额"),
        dataIndex:'RpAmt',
        width:120,
        align:'right',
        renderer: FormatGridRpAmount
    },{
        header:$g("零售金额"),
        dataIndex:'SpAmt',
        width:120,
        align:'right', 
        renderer: FormatGridSpAmount 
    },{
        header:$g("商品名"),
        dataIndex:'GoodName',
        width:150,
        align:'left'
    },{
    	header:$g("建议采购量"),
    	dataIndex:'ProPurQty',
    	width:100,
    	align:'right',
    	sortable:true
    },{
    	header:$g("消耗数量"),
    	dataIndex:'DispQty',
    	width:100,
    	align:'right',
    	sortable:true
    },{
    	header:$g("申购科室库存"),
    	dataIndex:'StkQty',
    	width:100,
    	align:'right',
    	sortable:true
    },{
    	header:$g("采购科室库存"),
    	dataIndex:'CurStkQty',
    	width:100,
    	align:'right',
    	sortable:true
    }, {
            header: $g("免费药标识"),
            dataIndex: 'FreeDrugFlag',
            width: 80,
            align: 'left',
            sortable: true
        }
    
]);
//初始化默认排序功能
//PlanGridCm.defaultSortable = true;

var findPlan = new Ext.Toolbar.Button({
	id:'findbtn',
	text:$g('查询'),
    tooltip:$g('查询'),
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		FindPlan(Select);
	}
});

var addPlan = new Ext.Toolbar.Button({
	text:$g('增加一条'),
    tooltip:$g('增加一条'),
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		var v = Ext.getCmp('locField').getValue();
		if((v=="")||(v==null)){
			Msg.info("error",$g("请选择科室!"));
		}else{
			groupField.setDisabled(true);
			addNewRow();
		}
	}
});

var savePlan = new Ext.Toolbar.Button({
	text:$g('保存'),
    tooltip:$g('保存'),
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(PlanGrid.activeEditor != null){
			PlanGrid.activeEditor.completeEdit();
		} 
		var rowCount =PlanGridDs.getCount();
		if(rowCount==0) 
		{
			Msg.info('warning',$g('明细数据为空，请核对明细!'))
			return;
		}
		var mod=Modified();
		if (mod==false)
		{
			Msg.info('warning',$g('没有需要保存的数据!'))
			return;
		}
		var purNo = Ext.getCmp('planNum').getValue();
		var locId = Ext.getCmp('locField').getValue();
		var stkGrpId = Ext.getCmp('groupField').getValue();
		var userId = UserId;
		if(locId==null || locId==""){
			Msg.info("warning",$g("科室不可为空!"));
			return;
		}
		if((stkGrpId==null || stkGrpId=="")&(gParamCommon[9]=="N")){
			Msg.info("warning",$g("类组不可为空!"));
			return;
		}
		
		//获取所有的新记录
		var mr=PlanGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var rowid = mr[i].data["RowId"];
			var incId = mr[i].data["IncId"];
			var InciDesc = mr[i].data["IncDesc"];
			var qty = mr[i].data["Qty"];
			var uomId = mr[i].data["UomId"];
			var vendorId = mr[i].data["VenId"];
			if(incId!="" && vendorId==""){Msg.info("warning",$g("第")+(PlanGridDs.indexOf(mr[i])+1)+$g("行中经营企业为空!"));
							return}
							
		    var Ret = CheckPoisonLimit(vendorId,incId,InciDesc)
	 		if (Ret == "Y" ){
		 		return;
	 		}
			var rp = mr[i].data["Rp"];
			var sp = mr[i].data["Sp"];
			var desc=mr[i].data["IncDesc"]
			var FreeDrugFlag=mr[i].data["FreeDrugFlag"]
			if(incId!=""){
				if(rp==0&&FreeDrugFlag!="Y") {
					Msg.info("warning", $g("非免费药进价不能为零"));
					return;
				}
				else if (rp!=0&&FreeDrugFlag=="Y"){
					Msg.info("warning", $g("免费药进价必须为零"));
					return;
				}
				else if ((rp == null || rp=="" || rp==0)&(gParam[0].trim()=="Y")&&(FreeDrugFlag!="Y")) {
					Msg.info("warning", $g("进价不能为空或零!"));
					return;
				}
				if (rp<0){
					Msg.info("warning",$g("进价不能小于0"));
					return;
				}
			}
			/* 采购时并不能确定进价，去掉判断
			if(Number(rp)>Number(sp)){
				Msg.info("warning",desc+$g(",进价不能大于售价!"));
				return;
			}*/						
							
							
			var manfId = mr[i].data["ManfId"];
			var carrierId = mr[i].data["CarrierId"];
			var reqLocId = mr[i].data["ReqLocId"];
			if(incId!="" && qty==""){
				Msg.info("warning",$g("第")+(PlanGridDs.indexOf(mr[i])+1)+$g("行采购数量为空!"));
				return;
			}
			if(qty!="" && incId!=""){
				var dataRow = rowid+"^"+incId+"^"+qty+"^"+uomId+"^"+vendorId+"^"+rp+"^"+manfId+"^"+carrierId+"^"+reqLocId;
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
			// 判断重复输入药品,经营企业&厂家&药品名称,需判断所有,yunhaibao20151117
			var mrrow=PlanGridDs.indexOf(mr[i])
			for (var j =0; j < rowCount; j++) {
				if (j==mrrow){continue;}
				var item_inci = PlanGridDs.getAt(j).get("IncId");
				var item_manf = PlanGridDs.getAt(j).get("ManfId");
				var item_vendor = PlanGridDs.getAt(j).get("VenId");
				var jcnt=j+1;
				var incidesc=PlanGridDs.getAt(j).get("IncDesc");
				if (item_inci == incId && item_manf == manfId && item_vendor == vendorId) {
					changeBgColor(mrrow, "yellow");
					changeBgColor(j, "yellow");
					Msg.info("warning", incidesc+$g(",第")+(mrrow+1)+","+(j+1)+$g("行药品相关信息录入重复，请重新输入!"));
					return;
				}
			}
			
		}
		if ((data=="")&& (mod==false) ){
			Msg.info("warning",$g("没有需要保存的数据!"));
			return;
		}
		//验证预算数据
		var ret = CheckSaveBudget(purNo,data)
		if(!ret) return;

	//	if(data!=""){  //alert(stkGrpId);
			Ext.Ajax.request({
				url: PlanGridUrl+'?actiontype=save',
				params:{purNo:purNo,locId:locId,stkGrpId:stkGrpId,userId:userId,data:data},
				failure: function(result, request) {
					Msg.info("error",$g("请检查网络连接!"));
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success",$g("保存成功!"));
						purId=jsonData.info;
						Select(purId);
						SendBusiData(purId,"PURPLAN","SAVE")
						
					}else{
						if(jsonData.info==-1){
							Msg.info("error",$g("科室或人员为空!"));
						}else if(jsonData.info==-99){
							Msg.info("error",$g("加锁失败!"));
						}else if(jsonData.info==-2){
							Msg.info("error",$g("生成计划单号失败!"));
						}else if(jsonData.info==-3){
							Msg.info("error",$g("保存计划单失败!"));
						}else if(jsonData.info==-4){
							Msg.info("error",$g("未找到需更新的计划单!"));
						}else if(jsonData.info==-5){
							Msg.info("error",$g("保存计划单明细失败,不能生成计划单!"));
						}else if(jsonData.info==-7){
							Msg.info("error",$g("失败药品：部分明细保存不成功，提示不成功的药品!"));
						}else if(jsonData.info==-8){
							Msg.info("error",$g("采购计划已完成!"));
						}else if(jsonData.info==-9){
							Msg.info("error",$g("采购计划已审核!"));
						}else{
							Msg.info("error",$g("保存失败!"));
						}
					}
				},
				scope: this
			});
		//}
    }
});


function CheckSaveBudget(purNo,data){
	if (_BudgetSaveFlag != "LIMIT" && _BudgetSaveFlag != "WARN") return true;
	var locId = Ext.getCmp('locField').getValue();
	var locDesc = Ext.getCmp('locField').getRawValue();
	var budgetId = Ext.getCmp('BudgetProComb').getRawValue();
	if(!budgetId) {
		Msg.info("warning","保存数据需核对HRP预算系统，请选择一个预算项目!");
		return false;
	}
	var MianObj={
		project_id : "", //项目id
		project_desc: "", //项目名称
		loc_id : locId, //科室id
		loc_desc : locDesc, //科室名称
		business : "PURPLAN", //业务类型
		businode : "SAVE", //业务节点
		main_id : "", //业务主表id
		main_no : purNo, //业务单号
		operate : "INSERT", //操作类型
		Detail : data //明细数据
	}
	var BusiData = JSON.stringify(MianObj)
	var ret = tkMakeServerCall("PHA.IN.Budget.Client.Interface","SendBusiData",BusiData)
	var RetJson = JSON.parse(ret);
	if(RetJson.code < 0 )
	{
		Msg.info("error",RetJson.msg);
		return false;
	}
	else if(RetJson.code == 1)
	{
		Msg.info("warning",RetJson.msg);
	}
	return true;
}


var deletePlan = new Ext.Toolbar.Button({
	text:$g('删除'),
    tooltip:$g('删除'),
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		if(purId==null || purId==""){
			Msg.info("warning",$g("请选择要删除的计划单!"));
			return;
		}
		var compFlag=Ext.getCmp('Complete').getValue();
		var mod=Modified();
		if  ( (mod) &&(!compFlag) ) {
				Ext.Msg.show({
				   title:$g('提示'),
				   msg: Msg_LostModified,
				   buttons: Ext.Msg.YESNO,
				   fn: function(b,t,o){
				   	if (b=='yes'){Delete();}
				   },
				   //animEl: 'elId',
				   icon: Ext.MessageBox.QUESTION
				});
		}
		else
		{Delete();}	
	}
});

function Delete()
{
	Ext.MessageBox.confirm($g('提示'),$g('确定要删除该采购计划单?'),
		function(btn) {
			if(btn == 'yes'){
				Ext.Ajax.request({
					url:PlanGridUrl+'?actiontype=delete&rowid='+purId,
					waitMsg:$g('删除中...'),
					failure: function(result, request) {
						Msg.info("error", $g("请检查网络连接!"));
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Msg.info("success", $g("删除成功!"));
							clearData();									
						}else{
							if(jsonData.info==-1){
								Msg.info("error", $g("订单已经完成，不能删除!"));
								return false;
							}
							if(jsonData.info==-2){
								Msg.info("error", $g("订单已经审核，不能删除!"));
								return false;
							}
							if(jsonData.info==-3){
								Msg.info("error", $g("删除计划单主表失败!"));
								return false;
							}
							if(jsonData.info==-4){
								Msg.info("error", $g("删除计划单明细失败!"));
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
function FinishPurPlan()
{
	var completeFlag=Ext.getCmp('Complete').getValue();
	if (completeFlag==true) {	
		Msg.info('error',$g('当前采购计划单已经完成!'))
		return;
	}

	//获取所有的新记录
	var mr=PlanGridDs.getCount();
	if(mr<1){
		Msg.info('warning',$g('采购计划明细无数据,无需完成!'))
		return;
	}
	var data="";

	for(var i=0;i<mr;i++){
		
	    var record=PlanGridDs.getAt(i)
	    var incId = record.get("IncId");
           var vendorId = record.get("VenId");
           var rp = record.get("Rp");
           var FreeDrugFlag = record.get('FreeDrugFlag');
           var icnt=i+1
           if(incId!="" && vendorId==""){Msg.info("warning",$g("第")+icnt+$g("行中经营企业为空!"));
							return}
			if(incId!=""){
				
				
				
				if(rp==0&&FreeDrugFlag!="Y") {
					Msg.info("warning", $g("非免费药进价不能为零"));
					return;
				}
				else if (rp!=0&&FreeDrugFlag=="Y"){
					Msg.info("warning", $g("免费药进价必须为零"));
					return;
				}
				else if ((rp == null || rp=="" || rp==0)&(gParam[0].trim()=="Y")&&(FreeDrugFlag!="Y")) {
					Msg.info("warning", $g("进价不能为空或零!"));
					return;
				}

				if (rp < 0) {
					Msg.info("warning",$g("进价不能小于0!"));
					return;
				}
				
				
			}
							
	}		
	Ext.MessageBox.confirm($g('提示'),$g('确定要完成该计划单吗?'),
		function(btn) {
			if(btn == 'yes'){
				var ret = SendBusiData(purId,"PURPLAN","COMP")
				if(!ret) return;

				Ext.Ajax.request({
					url:PlanGridUrl+'?actiontype=finsh&rowid='+purId,
					waitMsg:$g('处理中...'),
					failure: function(result, request) {
						Msg.info("error", $g("请检查网络连接!"));
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Msg.info("success", $g("计划单完成!"));
							Ext.getCmp("Complete").setValue(true);
							addPlan.setDisabled(true);   //不可增加
							savePlan.setDisabled(true);   //不可保存
							deletePlan.setDisabled(true);   //不可删除
							finishPlan.setDisabled(true);   //不可完成
							Select(purId);
						}else{
							if(jsonData.info==-1){
								Msg.info("error", $g("计划单已经完成!"));
								return false;
							}else if(jsonData.info==-4){
								Msg.info("error", $g("自动审批失败!"));
								return false;
							}else{
								Msg.info("error", $g("操作失败:")+jsonData.info);
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
var finishPlan = new Ext.Toolbar.Button({
	text:$g('完成'),
    tooltip:$g('完成'),
    iconCls:'page_gear',
	width : 70,
	height : 30,
	disabled:true,
	handler:function(){
		if((purId=="")||(purId==null)){
			Msg.info("error", $g("计划单为空!"));
			return false;
		}else{
			var rowCount =PlanGridDs.getCount();
			if(rowCount==0) 
			{
				Msg.info('warning',$g('明细数据为空，请核对明细!'))
				return;
			}
			var mod=Modified();
			if (mod) {
				Ext.Msg.show({
			        title: $g('提示'),
			        msg: $g("数据已发生改变，请先保存!"),
			        buttons: Ext.Msg.OK,
			        icon: Ext.MessageBox.INFO
			    });
			    return;
			    
				Ext.Msg.show({
				   title:$g('提示'),
				   msg: Msg_LostModified,
				   buttons: Ext.Msg.YESNO,
				   fn: function(b,t,o){
				   	if (b=='yes'){FinishPurPlan();}
				   },
				   //animEl: 'elId',
				   icon: Ext.MessageBox.QUESTION
				});
			}			
			else
			{
				FinishPurPlan();
			}
		}
	}
});

function CancelFinish()
{
	var completeFlag=Ext.getCmp('Complete').getValue();
	if (completeFlag==false) 
	{	Msg.info('error',$g('当前采购计划单尚未完成!'))
		return;
	}
	
	
	Ext.MessageBox.confirm($g('提示'),$g('确定要取消完成该计划单吗?'),
		function(btn) {
			if(btn == 'yes'){
				Ext.Ajax.request({
					url:PlanGridUrl+'?actiontype=noFinsh&rowid='+purId,
					waitMsg:'处理中...',
					failure: function(result, request) {
						Msg.info("error", $g("请检查网络连接!"));
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Msg.info("success", $g("成功取消计划单完成状态!"));
							Ext.getCmp('Complete').setValue(false);
							finishPlan.setDisabled(false);   //完成
							savePlan.setDisabled(false);
							deletePlan.setDisabled(false);
							addPlan.setDisabled(false);
						}else{
							if(jsonData.info==-1){
								Msg.info("error",$g( "采购计划单尚未完成!"));
								return false;
							}
							if(jsonData.info==-2){
								Msg.info("error", $g("采购计划单已经审核，不能取消完成!"));
								return false;
							}
							if(jsonData.info==-3){
								Msg.info("error", $g("操作失败!"));
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
var noFinshPlan = new Ext.Toolbar.Button({
	text:$g('取消完成'),
    tooltip:$g('取消完成'),
    iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		if((purId=="")||(purId==null)){
			Msg.info("error", $g("计划单为空!"));
			return false;
		}else{
			var mod=Modified();
			if (mod) {
				Ext.Msg.show({
				   title:$g('提示'),
				   msg: Msg_LostModified,
				   buttons: Ext.Msg.YESNO,
				   fn: function(b,t,o){
				   	if (b=='yes'){CancelFinish();}
				   },
				   //animEl: 'elId',
				   icon: Ext.MessageBox.QUESTION
				});
			}else
			{CancelFinish();}
		}
	}
});

// 清空按钮
var ClearBT = new Ext.Toolbar.Button({
	id : "ClearBT",
	text : $g('清屏'),
	tooltip : $g('点击清屏'),
	width : 70,
	height : 30,
	iconCls : 'page_clearscreen',
	handler : function() {
		var compFlag=Ext.getCmp('Complete').getValue();
		var mod=Modified();
		if  ( mod&&(!compFlag) ) {
			Ext.Msg.show({
			   title:$g('提示'),
			   msg: Msg_LostModified,
			   buttons: Ext.Msg.YESNO,
			   fn: function(b,t,o){
			   		if (b=='yes'){clearData() ;}			   		
			   	},
	 		   //animEl: 'elId',
			   icon: Ext.MessageBox.QUESTION
			});
		}
		else
		{	clearData() ;}
	}
});


function clearData(){
	SetLogInDept(locField.getStore(),'locField');
	
	groupField.getStore().removeAll();
    groupField.getStore().setBaseParam("locId",Ext.getCmp("locField").getValue())
    groupField.getStore().setBaseParam("userId",UserId)
    groupField.getStore().setBaseParam("type",App_StkTypeCode)
    groupField.getStore().load();
                          
	Ext.getCmp("dateField").setValue(new Date());
	Ext.getCmp("planNum").setValue("");
	Ext.getCmp("Complete").setValue(false);
	addPlan.setDisabled(false);
	groupField.setDisabled(false);
	PlanGridDs.removeAll();
	PlanGrid.getView().refresh();
	purId='';
	purNo='';
	finishPlan.setDisabled(true);   //完成
	savePlan.setDisabled(false);
	deletePlan.setDisabled(false);
	addPlan.setDisabled(false);
	
	setOriginalValue('MainForm');
}
// 变换行颜色
function changeBgColor(row, color) {
	PlanGrid.getView().getRow(row).style.backgroundColor = color;
}
 ///复制请求单
function Copy(purid){
	Ext.Ajax.request({
		url: PlanGridUrl+'?actiontype=Copy',
		params:{parref:purid,userId:UserId},
		failure: function(result, request) {
			Msg.info("error",$g("请检查网络连接!"));
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success",$g("复制成功!"));
				purId=jsonData.info;
				Select(purId);
				
			}else{
				Msg.info("success",$g("复制失败!"));
				}
		}
	})

}
var formPanel = new Ext.form.FormPanel({
	id:'MainForm',
	labelWidth : 60,
	autoScroll:false,
	labelAlign : 'right',
	frame : true,
    tbar:[findPlan,'-',ClearBT,'-',savePlan,'-',finishPlan,'-',noFinshPlan,'-',ConWinBT,'-',CopyBT,'-',PrintBT,'-',deletePlan],
	items : [{
			layout : 'column',		
			xtype : 'fieldset',
			title : $g('采购信息'),
			defaults:{border:false},
			style:DHCSTFormStyle.FrmPaddingV,
			items : [{				
					columnWidth : .25,
					xtype : 'fieldset',
					items : [locField,dateField]
				}, {
					columnWidth : .25,
					xtype : 'fieldset',
					items : [planNumField,BudgetProComb] //,ZBFlag]
				},{
					columnWidth : .25,
					xtype : 'fieldset',
					items : [groupField] //NotZBFlag]
				}, {
					columnWidth : .25,
					xtype : 'fieldset',
					items : [Complete] //AllFlag]
			}]			
		}],
	listeners:{
	'afterrender':function(){
		//alert('afterrender');
		//setOriginalValue('MainForm');
	}
	
	}
	
});

//分页工具栏
var PlanPagingToolbar = new Ext.PagingToolbar({
    store:PlanGridDs,
	pageSize:PlanPageSize,
    displayInfo:true,
    displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
    emptyMsg:$g("没有记录")
});

//翻页之前，先检查有没有需要保存的数据
PlanPagingToolbar.on("beforechange",function(toolbar,params){
	PlanGridDs.commitChanges();
	var records=PlanGridDs.getModifiedRecords();
	if(records!=null){
		if(records.length>0){
			Msg.info("warning",$g("当前页数据已经发生变化，请进行保存或刷新！"));
			return false;
		}
	}
	
	return true;
});

var DelItmBT=new Ext.Toolbar.Button({
	id:'DelItmBT',
	iconCls:'page_delete',
	tooltip:$g('删除选中记录'),
	text:$g('删除记录'),
	width : 70,
	height : 30,
	handler:function(){
		DeleteItem();
	}
});
var GridColSetBT = new Ext.Toolbar.Button({
	text:$g('列设置'),
    tooltip:$g('列设置'),
    iconCls:'page_gear',
    //	width : 70,
    //	height : 30,
	handler:function(){
		GridColSet(PlanGrid,"DHCSTPURPLANAUDIT");
	}
    });
var newsm = new Ext.grid.CheckboxSelectionModel({  
        singleSelect : false, 
        ///yunhaibao20151118.shift,ctrl多选不冲突
		handleMouseDown : function(g, rowIndex, e){  
		        if (e.button !== 0 || this.isLocked()) {  
		               return;  
		        }  
		        var view = this.grid.getView();  
		        if (e.shiftKey && !this.singleSelect) {  
		             var last = this.last;  
		             this.selectRange(last, rowIndex, e.ctrlKey|| e.shiftKey);  
		             this.last = last;  
		             view.focusRow(rowIndex);  
		        }else{  
		             var isSelected = this.isSelected(rowIndex);  
		             if (e.ctrlKey && isSelected) {  
		                  this.deselectRow(rowIndex);  
		             }else if(!isSelected || this.getCount() > 0){  
		                  this.selectRow(rowIndex, e.ctrlKey || e.shiftKey);   
		                  view.focusRow(rowIndex);  
		             }  
		        }  
		  },
		onEditorKey : function(field, e){  
	        var k = e.getKey(),   
	        newCell,   
	        g = this.grid,   
	        last = g.lastEdit,  
	        ed = g.activeEditor,  
	        ae, last, r, c;  
	        var shift = e.shiftKey;  
	        if(k == e.TAB){  
	            e.stopEvent();  
	            ed.completeEdit();  
	            if(shift){  
	                newCell = g.walkCells(ed.row, ed.col-1, -1, this.acceptsNav, this);  
	            }else{  
	                newCell = g.walkCells(ed.row, ed.col+1, 1, this.acceptsNav, this);  
	            }  
	        }else if(k == e.ENTER){  
	            if(this.moveEditorOnEnter !== false){ 
	                if(shift){  
	                    newCell = g.walkCells(last.row - 1, last.col, -1, this.acceptsNav, this);  
	                }else{  
	            //CheckboxSelectionModel调用父类Ext.grid.RowSelectionModel的onEditorKey方法  
	            //newCell = g.walkCells(last.row+1, last.col, 1, this.acceptsNav, this);  
	                    newCell = g.walkCells(last.row , last.col, 1, this.acceptsNav, this);  
	                }  
	            }  
	        }  
	        if(newCell){  
	            r = newCell[0];  
	            c = newCell[1];  
	            if(last.row != r){  
	                this.selectRow(r);   
	            }  
  
	            if(g.isEditor && g.editing){   
	                ae = g.activeEditor;  
	                if(ae && ae.field.triggerBlur){  
	                    ae.field.triggerBlur();  
	                }  
	            }
	            var noeditcol=GetColIndex(this.grid,"IncDesc");
	            if (c!=noeditcol)  //解决IE11兼容问题
	            { 
	            	g.startEditing(r, c);
	            } 
	        }  
	    }  
}); 
//表格
PlanGrid = new Ext.grid.EditorGridPanel({
	store:PlanGridDs,
	title:$g('采购计划单明细'),
	cm:PlanGridCm,
	trackMouseOver:true,
	region:'center',
	height:650,
	stripeRows:true,
	sm :new Ext.grid.CellSelectionModel({}),// newsm,
	loadMask:true,
	bbar:PlanPagingToolbar,
	tbar:[addPlan,'-',DelItmBT,'-',GridColSetBT],
	clicksToEdit:1
});

PlanGrid.on('beforeedit',function(e){
	if(e.field=="UomId"){
		var inci=e.record.get("IncId");
		if(inci==null || inci==""){
			Msg.info("warning",$g("请先录入药品!"));
			e.cancel=true;
		}
	}
});
PlanGrid.on('headerclick',function(grid,columnIndex ,e)
	{
		var count=0
		count=grid.getStore().getCount()
		
		for(i=0;i<count;i++)
		{
		var record=grid.getStore().getAt(i)
		var rowid=record.get('RowId')       ///grid rowid
		if(Ext.isEmpty(rowid))
			{return false}
		}
	})
function DeleteItem(){	
		var completedFlag=Ext.getCmp('Complete').getValue();
		if (completedFlag) {
			Msg.info('error',$g('当前采购计划单已"完成"，禁止删除'));
			return;
		}
		
		var cell = PlanGrid.getSelectionModel().getSelectedCell();
		if (cell==null){
			Msg.info("error",$g("请选择数据!"));
			return false;
		}
		var recordrow = cell[0];
		var selectrecord = PlanGridDs.getAt(recordrow);	
		Ext.MessageBox.confirm($g('提示'),$g('确定要删除记录?'),
			function(btn) {
				if(btn == 'yes'){
						var planItm = selectrecord.data['RowId'];
						if ((planItm!="")&&(planItm!=null)){  //不用异步,否则refresh不起作用).
				            var deleteret=tkMakeServerCall("web.DHCST.INPurPlanItm","Delete",planItm);
				            if (deleteret=="0")
				            {
								PlanGridDs.remove(selectrecord);
				            }
				            else
				            {
					            if  (deleteret=="-1"){
					            	Msg.info("error",$g("采购计划已完成!"));
					            }
					            else if (deleteret=="-2"){
						            Msg.info("error",$g("采购计划已审核!"));							            
						        }
						        else if (deleteret=="-4"){
						            Msg.info("error",$g("删除采购计划单失败!"));							            
						        }
						        else{
							    	Msg.info("error",$g("删除失败!"));
							    }
					        	return false;
					        }
						}
						else{
							PlanGridDs.remove(selectrecord);
						}
			
					
					PlanGrid.getView().refresh();
				    //界面只有一条删除主表后清空条件！
					var rowCount =PlanGridDs.getCount();
					if(rowCount<1){
						if(purId) //存在采购单删除最后一条明细才删除主表
							Delete();
					}
				}
			}
		 )
	}

//zdm,2013-03-1,查询采购单主信息
function Select(purid){
	Ext.Ajax.request({
		url : 'dhcst.inpurplanaction.csp?actiontype=select&purId='+purid,
		method : 'POST',
		waitMsg : $g('查询中...'),
		success : function(result,request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			var arr = jsonData.info.split("^");
			purNo = arr[1];
			Ext.getCmp('planNum').setValue(purNo);
			addComboData(Ext.getCmp("locField").getStore(),arr[2],arr[3]);
			Ext.getCmp("locField").setValue(arr[2]);	
			Ext.getCmp("dateField").setValue(arr[4]);
			deptName = arr[3];
			Ext.getCmp('groupField').setValue(arr[15]);
			Ext.getCmp('groupField').setRawValue(arr[16]);
			Ext.getCmp('Complete').setValue(arr[11]=='Y'?true:false);	
			setOriginalValue('MainForm');  //
			if(arr[11]=='Y'){
				addPlan.setDisabled(true);   //不可增加
				savePlan.setDisabled(true);   //不可保存
				deletePlan.setDisabled(true);   //不可删除
				finishPlan.setDisabled(true);   //不可完成
			}else{
				addPlan.setDisabled(false);   //不可增加
				savePlan.setDisabled(false);   //不可保存
				deletePlan.setDisabled(false);   //不可删除
				finishPlan.setDisabled(false);   //不可完成
			}
			groupField.setDisabled(true);
		},
		scope : this
	});
	PurPlan=purid;
	PlanGridDs.setBaseParam("parref",purid);
	PlanGridDs.removeAll();
	PlanGridDs.load({params:{start:0,limit:PlanPagingToolbar.pageSize,sort:'RowId',dir:'asc'}});
}


//根据计划单号purId查询相关信息
if((purId!="")&&(purId!=null)&&(purId!=0)){
	Select(purId);
}
//=========================采购计划单=============================

//===========模块主页面=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:$g('采购计划制单'),
		activeTab:0,
		region:'north',
		height:DHCSTFormStyle.FrmHeight(2),
		layout: 'fit', 
		items:[formPanel]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[panel,PlanGrid],
		renderTo:'mainPanel'
	});
	setZBflag(); //add wyx 2013-09-24
	RefreshGridColSet(PlanGrid,"DHCSTPURPLANAUDIT");   //根据自定义列设置重新配置列	
	colArr = sortColoumByEnterSort(PlanGrid);
	SetBudgetPro(Ext.getCmp("locField").getValue(),"PURPLAN",[1,2],"savePlan") //加载HRP预算项目
});
//===========模块主页面=============================================
//对一个grid中的可编辑列(editor不为null的列)进行编辑设定。
// 
// grid - gridpanel
// b - true ,false
function setGridEditable(grid,b)
{	
	var cm=grid.getColumnModel();
	var colCount=cm.getColumnCount();
	
	for (var i=0;i<colCount;i++)
	{
		var colId=cm.getColumnId(i)
		var col=cm.getColumnById(colId);
		if (col.editor!=null)
		{
			cm.setEditable(i,b);
		}
	}
}

/*看是否修改*/
function Modified(){
	var detailCnt=0
	var rowCount=PlanGrid.getStore().getCount();
	for (var i = 0; i < rowCount; i++) {
				var item = PlanGrid.getStore().getAt(i).get("IncId");
				if (item != "") {
					detailCnt++;
				}
			}
	var result=false;
	//若为新单(purId="")，看子表是否有插入
	if ((purId<=0)||(purId==''))
	{
		if (detailCnt==0) {
			result=false;
		} else{
			result= true;
		}		
	}else{  //若不为新单，看主表或子表	
		var mod=Ext.getCmp('MainForm').getForm().isDirty();
		var modGrid=false;
		var rowsModified=PlanGrid.getStore().getModifiedRecords();
		if (rowsModified.length>0) modGrid=true
		if  (mod||modGrid) {
			result = true
		}
		else {
			result = false
		}
	}
	return result;
}
/*设置原始值，维持初始未修改状态*/
function setOriginalValue(formId)
{
	if (formId=="") return;
	Ext.getCmp(formId).getForm().items.each(function(f){ 		
		f.originalValue=String(f.getValue()); 
	});
}
function setZBflag(){
     if (zbFlag==1) {Ext.getCmp("AllFlag").setValue(true);}
else if (zbFlag==2) {Ext.getCmp("ZBFlag").setValue(true);}
else if (zbFlag==3) {Ext.getCmp("NotZBFlag").setValue(true);}
else {Ext.getCmp("AllFlag").setValue(true);}

}
function getZBflag(){

		var ZBFlag=Ext.getCmp("ZBFlag").getValue();
		var NotZBFlag=Ext.getCmp("NotZBFlag").getValue();
		var AllFlag=Ext.getCmp("AllFlag").getValue();
		
		if (AllFlag==true){
			var zbflagstr=1;
			}
		else if(ZBFlag==true){
			var zbflagstr=2;
			}
		else{
			var zbflagstr=3;
			}

    return zbflagstr;
}
	//-------------------Events-------------------//

    //设置Grid悬浮显示窗体
	//Creator:LiangQiang 2013-11-20
    PlanGrid.on('mouseover',function(e){
		
		var rowCount = PlanGrid.getStore().getCount();
		if (rowCount>0)
		{  
			var ShowInCellIndex=GetColIndex(PlanGrid,"IncCode")  //在第几列显示
			var index = PlanGrid.getView().findRowIndex(e.getTarget());
			var record = PlanGrid.getStore().getAt(index);
			if (record)
			{
				var desc=record.data.IncDesc;
				var inci=record.data.IncId;
			}
			ShowAllLocStkQtyWin(e,PlanGrid,ShowInCellIndex,desc,inci);
		}

	},this,{buffer:200});


   