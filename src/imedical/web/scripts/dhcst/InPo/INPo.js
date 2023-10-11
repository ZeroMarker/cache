// 名称:订单录入
// 编写日期:2013-01-21
var deptId = 0;
var deptName = "";
var poId = "";
var poNo = "";
var mainRowId="";
var reasonId = "";
//var newqty="";
var parrefRowId = "";
var UserId = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'];
var CtLocId = session['LOGON.CTLOCID'];
var gParamIngd= PHA_COM.ParamProp("DHCSTIMPORT")
var APPName="DHCSTPURPLANAUDIT"
var PurPlanParam=PHA_COM.ParamProp(APPName)

//var arr = window.status.split(":");
//var length = arr.length;
var inciDr = "";
var rpdecimal=2;
var spdecimal=2;
var GroupId=session['LOGON.GROUPID']
var colArr = [];
function addComboData(store, id, desc) {
	var defaultData = {
		RowId : id,
		Description : desc
	};
	var r = new store.recordType(defaultData);
	store.add(r);
}

var locField = new Ext.ux.LocComboBox({
	id:'locField',
	fieldLabel:$g('订单科室'),
	listWidth:210,
	allowBlank:true,
	emptyText:$g('订单科室...'),
	triggerAction:'all',
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	anchor:'90%',
	groupId:GroupId,
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
// 打印订单按钮
var PrintBT = new Ext.Toolbar.Button({
	id : "PrintBT",
	text :$g( '打印'),
	tooltip : $g('点击打印订单'),
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		PrintInPo(mainRowId);
	}
});
GetGroupDeptStore.load();
GetGroupDeptStore.on('load',function(ds,records,o){
	if((deptId!=null)&&(deptId!="")&&(deptId!=0)){
		Ext.getCmp('locField').setValue(deptId);
		Ext.getCmp('locField').setRawValue(deptName);
		INPoItmGridDs.proxy = new Ext.data.HttpProxy({url:INPoItmGridUrl+'?actiontype=queryItem',method:'GET'});
		INPoItmGridDs.removeAll();
		INPoItmGridDs.load({params:{start:0,limit:999,sort:'RowId',dir:'IncDesc',parref:mainRowId}});
            
     }else{ 
             
	}
});	


/// 检查管控药品  Y :管控 N:不管控
function CheckPoisonLimit(inci,inciDesc){
	var Vendor = Ext.getCmp('Vendor').getValue();
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
	
	var cell = INPoItmGrid.getSelectionModel().getSelectedCell();
	// 选中行
	var row = cell[0];
	var rowData = INPoItmGrid.getStore().getAt(row);
	/// 检查麻醉精一药品管控
	var Ret = CheckPoisonLimit(inciDr,record.get("InciDesc"))
	if (Ret == "Y"){
		return;
	}
	rowData.set("IncId",inciDr);
	rowData.set("IncCode",record.get("InciCode"));
	rowData.set("IncDesc",record.get("InciDesc"));
	//产地id^产地名称^配送企业id^配送企业名称^入库单位id^入库单位^进价^售价^申购科室库存量^库存上限^库存下限^通用名^商品名^剂型^规格
	//{success:'true',info:'7^GAYY-北京广安医药联合中心^61^bjymzy-北京益民制药厂^^^26^盒[20片]^0^0^0^^^艾司唑仑片^^普通片剂^[1mg*20]'}
	//取其它药品信息
	var locId = Ext.getCmp('locField').getValue();
	var Params=session['LOGON.GROUPID']+'^'+CtLocId+'^'+UserId;	
	if(locId!=""){
		Ext.Ajax.request({
			url : INPoItmGridUrl+'?actiontype=GetItmInfo&IncId='+ inciDr+'&Params='+Params,
			method : 'POST',
			waitMsg : $g('查询中...'),
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText.replace(/\r/g,"").replace(/\n/g,""));
				if (jsonData.success == 'true') {
					var data=jsonData.info.split("^");
					var ManfId = data[0];
					var Manf = data[1];
					addComboData(PhManufacturerStore,ManfId,Manf);
					//alert(ManfId)
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
					rowData.set("FreeDrugFlag", data[17]);
					
                    //==============资质判断==========
                    var venId = Ext.getCmp('Vendor').getValue();
                    var inci=record.get("InciDr")
                    var DataList=venId+"^"+inci+"^"+ManfId
      				var CertExpDateInfo = tkMakeServerCall("PHA.IN.Cert.Query","CheckExpDate",venId,ManfId)
                    if (CertExpDateInfo != ""){
	                  	Msg.info("warning", CertExpDateInfo);
	                    return;  
                    }
					//==============资质判断==========
				} 
			},
			scope : this
		});
	}else{
		Msg.info("error", $g("请选择!"));
	}
	 if (setEnterSort(INPoItmGrid, colArr)) {
                        addNewRow();
                    }
	
}

/*function getDrugList2(record) {
	// 选中行
	var row = cell[0];
	var rowData = PlanGrid.getStore().getAt(row);
	rowData.set("IncId",inciDr);
	rowData.set("IncCode",record.get("InciCode"));
	rowData.set("IncDesc",record.get("InciDesc"));
	
}

*/
var Uom = new Ext.form.ComboBox({
	fieldLabel : $g('单位'),
	id : 'Uom',
	name : 'Uom',
	anchor : '90%',
	store : ItmUomStore,
	valueField : 'RowId',
	displayField : 'Description',
	emptyText : $g('单位...'),
	mode:'local',
	listeners:{
		specialKey:function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				if (setEnterSort(INPoItmGrid, colArr)) {
                        addNewRow();
                    }	
			}
		},
		'focus':function(field){
			var cell = INPoItmGrid.getSelectionModel().getSelectedCell();			
			var record = INPoItmGrid.getStore().getAt(cell[0]);
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
	var cell = INPoItmGrid.getSelectionModel().getSelectedCell();	
	var record = INPoItmGrid.getStore().getAt(cell[0]);
	var UomId=record.get("PurUomId");	
	Uom.setValue(UomId);
});
Uom.on('beforequery', function(combo) {
			var cell = INPoItmGrid.getSelectionModel().getSelectedCell();	
			var record = INPoItmGrid.getStore().getAt(cell[0]);
			var ItmId = record.get("IncId");		
			ItmUomStore.removeAll();
			ItmUomStore.load({
				params:{ItmRowid:ItmId}
			});
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
		GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",getDrugList2);	
	}
}

//=========================订单录入=============================
var needDateField = new Ext.ux.DateField({
	id:'needDateField',
	//width:210,
	listWidth:210,
    //allowBlank:false,
	fieldLabel:$g('要求到货日期'),
	anchor:'90%',
	value:new Date()
});

var inpoNoField = new Ext.form.TextField({
	id:'inpoNoField',
	fieldLabel:$g('订单号'),
	allowBlank:true,
	//width:150,
	listWidth:150,
	emptyText:$g('订单号...'),
	anchor:'90%',
	selectOnFocus:true,
	disabled:true
});

		// 药品类组
var groupField=new Ext.ux.StkGrpComboBox({ 
		id : 'groupField',
		name : 'groupField',
		StkType:App_StkTypeCode,     //标识类组类型
		LocId:CtLocId,
		UserId:UserId,
		anchor:'90%'
	}); 

var Vendor=new Ext.ux.VendorComboBox({
		id : 'Vendor',
		name : 'Vendor',
		anchor : '90%',
		listeners:{
			select: function(combo,record,opts) {
	            var startValue = combo.startValue
	            var limitFalg = checkPoison();
	            if (limitFalg == "Y") Ext.getCmp("Vendor").setValue(startValue);
               
            }
		}
	});
	
	 /// 判断是否符合麻醉精一药品控制 ： Y需要限制 N不需要限制
    function checkPoison()
    {
	    var limitFalg = "N"
	    var Vendor = Ext.getCmp("Vendor").getValue();
	    var VendorPoisonLimit = gParamIngd.VendorPoisonLimit
      	if (VendorPoisonLimit){
            var vendorPoisonFlag = tkMakeServerCall("PHA.IN.Vendor.Query","GetVendorPoisonLimit",Vendor)
            var vendorPoisonObj = JSON.parse(vendorPoisonFlag)
            if(vendorPoisonObj.PoisonCFlag != "Y" && vendorPoisonObj.PoisonPFlag != "Y")
            {
	            var DetailPoisonFlag = CheckDetailPoison();
	            if(DetailPoisonFlag != ""){
	                Msg.info("warning", $g(DetailPoisonFlag+"为麻醉精一药品，而经营企业无麻醉精一药品录入权限!"));
	                if(VendorPoisonLimit == 2) 
	                {
	                    limitFalg = "Y"
	                }
	            }
            }
        }
        return limitFalg;
    }
    
    ///判断订单明细中是否有麻醉精一药品
    function CheckDetailPoison(){
	   	var DetailPoisonFlag = ""
	    var rowCount = INPoItmGrid.getStore().getCount();
        for (var i = 0; i < rowCount; i++) {
           var rowData = INPoItmGridDs.getAt(i);
           var IncId = rowData.get("IncId"); 
           if(!IncId) continue;
           var InciDesc = rowData.get("IncDesc"); 
           var poisonFlag = tkMakeServerCall("web.DHCST.Common.DrugInfoCommon","CheckPoisonForVendor",IncId)
           if (poisonFlag == "Y") {
	           DetailPoisonFlag = InciDesc 
	           break;
           }
       }
       return DetailPoisonFlag;
    }


var remarkField = new Ext.form.TextField({
	id:'remarkField',
	fieldLabel:$g('备注'),
	allowBlank:true,
	width:200,
	listWidth:200,
	emptyText:$g('备注...'),
	anchor:'90%',
	selectOnFocus:true
});

var finishCK = new Ext.form.Checkbox({
	id: 'finishCK',
	fieldLabel:$g('完成'),
	disabled:true,
	allowBlank:true,
	anchor:'90%',
	listeners:{
		'check':function(chk,v){
			//alert('check');
			//var grid=Ext.getCmp('INScrapMGrid');
			setGridEditable(INPoItmGrid,!v);
		}	
	}
	
});



var INPoItmGrid="";

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
		Msg.info('warning',$g('当前订单已完成,禁止增加明细记录!'));
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
	
	var record = Ext.data.Record.create([
		{
			name : 'PoItmId',
			type : 'string'
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
			name : 'PurUomId',
			type : 'string'
		},{
			name : 'PurUom',
			type : 'string'
		},{
			name : 'Spec',
			type : 'string'
		}, {
			name : 'ManfId',
			type : 'int'
		}, {
			name : 'Manf',
			type : 'string'
		},{
			name : 'PurQty',
			type : 'int'
		}, {
			name : 'Rp',
			type : 'double'
		}, {
			name : 'rpAmt',
			type : 'double'
		}, {
			name : 'Sp',
			type : 'double'
		}, {
			name : 'spAmt',
			type : 'double'
		}, {
			name : 'pp',
			type : 'double'
		}, {
			name : 'ppAmt',
			type : 'double'
		}, {
			name : 'ConFac',
			type : 'double'
		}, {
			name : 'FreeDrugFlag',
			type : 'string'
		}
		
		
	]);
	
	var NewRecord = new record({
		PoItmId:'',
		IncId:'',
		IncCode:'',
		IncDesc:'',
		PurUomId:'',
		PurUom:'',
		Spec:'',
		ManfId:'',
		Manf:'',
		PurQty:'',
		Rp:'',
		rpAmt:'',
		Sp:'',
		spAmt:'',
		pp:'',
		ppAmt:'',
		ConFac:'',
		FreeDrugFlag:''
	});
					
	INPoItmGridDs.add(NewRecord);
	//光标跳到名称
	groupField.setDisabled(true);
	var colindex=GetColIndex(INPoItmGrid,"IncDesc");
	INPoItmGrid.getSelectionModel().select(INPoItmGridDs.getCount() - 1, colindex);
	INPoItmGrid.startEditing(INPoItmGridDs.getCount() - 1, colindex);
	
}

//配置数据源
var INPoItmGridUrl = 'dhcst.inpoaction.csp';
var INPoItmGridProxy= new Ext.data.HttpProxy({url:INPoItmGridUrl+'?actiontype=QueryDetailAll',method:'GET'});
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
		{name:'pp'},
		{name:'ppAmt'},
		{name:'BUom'},
		{name:'ConFac'},
		{name:'FreeDrugFlag'}
	]),
    remoteSort:false,
    listeners:{
    //'datachanged':function(){alert('datachanged')}
    }
    
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
        header:$g("代码"),
        dataIndex:'IncCode',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("名称"),
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
							poNeeddate=poNeeddate.format("Y-m-d");
						}
						if((poLoc=="")||(poLoc==null)){
							Msg.info("error",$g("请选择订单科室!"));
							return false;
						}
						if((poNeeddate=="")||(poNeeddate==null)){
							Msg.info("error",$g("请选择到货日期")) ;
							return false;
						}
						var venId = Ext.getCmp('Vendor').getValue();
						if((venId=="")||(venId==null)){
							Msg.info("error",$g("请选择经营企业!"));
							return false;
						}
						var group=Ext.getCmp("groupField").getValue();
						GetPhaOrderInfo2(Ext.getCmp('descField').getValue(),group);
					}
				}
			}
        })
    },{
        header:$g("规格"),
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
        header:$g("生产企业"),
        dataIndex:'Manf',
        width:150,
        align:'left',
        sortable:true
    },{
        header:$g("数量"),
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
						if (setEnterSort(INPoItmGrid, colArr)) {
                        addNewRow();
                    }
					}
				}
			}
        })
    },{
        header:$g("单位"),
        dataIndex:'PurUomId',
        id:'ePurUomId',
        width:100,
        align:'left',
        sortable:true,
         editor : new Ext.grid.GridEditor(Uom),
		renderer : Ext.util.Format.comboRenderer2(Uom,"PurUomId","PurUom")       
     },{
        header:$g("单位"),
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
        header:$g("进价"),
        dataIndex:'Rp',
        id:'eRp',
        width:100,
        align:'right',
        sortable:true,
    	editor : new Ext.grid.GridEditor(new Ext.ux.NumberField({
			selectOnFocus : true,
			allowBlank : false,
			id:'PoRp',
			//decimalPrecision:rpdecimal,
			formatType: 'FmtRP',
			listeners : {						      
				'specialkey': function(field, e) {
					//enter键
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = INPoItmGrid.getSelectionModel().getSelectedCell();
    					var row = cell[0];
						var rowData = INPoItmGrid.getStore().getAt(row);
						var FreeDrugFlag = rowData.get('FreeDrugFlag');
						var resultRpNew = field.getValue();
						if (resultRpNew == null|| resultRpNew.length <= 0) {
			               Msg.info("warning", $g("进价不能为空!"));
			               return;
	               		}
	               		else if(FreeDrugFlag=="Y"){
		               		if(resultRpNew!=0){
				   				Msg.info("warning",	$g("免费药的价格只能为零0!"));
				    			return;
		               		}
			            }
			   			else if (resultRpNew <=0) {
				   			Msg.info("warning",	$g("进价不能小于或等于0!"));
				    		return;
			            }
			            else{
						    if (setEnterSort(INPoItmGrid, colArr)) {
			                        addNewRow();
			                    }
						}
					}
				}
			}
		})
	)
					
        //----------
    },{
        header:$g("进价金额"),
        dataIndex:'rpAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer: FormatGridRpAmount
    },{
        header:"ConFac",
        dataIndex:'ConFac',
        width:100,
        align:'right',
        sortable:true,
        hidden:true
    }/*,{
        header:"批价",
        dataIndex:'pp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"批价金额",
        dataIndex:'ppAmt',
        width:100,
        align:'right',
        sortable:true
    }*/
    ,{
        header: $g("免费药标识"),
        dataIndex: 'FreeDrugFlag',
        width: 80,
        align: 'center',
        sortable: true
    }
]);
		
//初始化默认排序功能
INPoItmGridCm.defaultSortable = true;

var addINPoM = new Ext.Toolbar.Button({
	text:$g('新建'),
    tooltip:$g('新建'),
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
	text:$g('查询'),
    tooltip:$g('查询'),
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		FindINPo(Query);
	}
});


var clearINPoM = new Ext.Toolbar.Button({
	text:$g('清屏'),
    tooltip:$g('清屏'),
    iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		clearData();
	}
});

var saveINPoM = new Ext.Toolbar.Button({
	text:$g('保存'),
    tooltip:$g('保存'),
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
			Msg.info("error",$g("请选择订单科室!"));
			return false;
		}
		var scg = Ext.getCmp('groupField').getValue();
		if(((scg=="")||(scg==null))&(gParamCommon[9]=="N")){
			Msg.info("error",$g("请选择类组!"));
			return false;
		}
		var venId = Ext.getCmp('Vendor').getValue();
		if((venId=="")||(venId==null)){
			Msg.info("error",$g("请选择经营企业!"));
			return false;
		}
		return true;
}

function save(){
	var poUser = UserId;
	var poInst = "";
	var poNo = Ext.getCmp("inpoNoField").getValue();
	var poLoc = Ext.getCmp('locField').getValue();
	var poComp = (Ext.getCmp('finishCK').getValue()==true?'Y':'N');
	var poScg = Ext.getCmp('groupField').getValue();
	var poVendor = Ext.getCmp("Vendor").getValue();
	var remark = Ext.getCmp('remarkField').getValue();
	var poNeeddate = Ext.getCmp('needDateField').getRawValue();
	var tmpData = poVendor+"^"+poLoc+"^"+poUser+"^"+poScg+"^"+poComp+"^"+remark+"^"+poNeeddate;
	//alert(tmpData);	
	if(tmpData!=""){
		var ListDetail="";
		var rowCount = INPoItmGrid.getStore().getCount();
		// 3.判断重复输入药品
		for (var i = 0; i < rowCount - 1; i++) {
			for (var j = i + 1; j < rowCount; j++) {
				var item_i = INPoItmGridDs.getAt(i).get("IncId");;
				var item_j = INPoItmGridDs.getAt(j).get("IncId");;
				if (item_i != "" && item_j != ""
						&& item_i == item_j) {
					changeBgColor(i, "yellow");
					changeBgColor(j, "yellow");
					Msg.info("warning", $g("药品重复，请重新输入!"));
					return false;
				}
			}
		}
		
		for (var i = 0; i < rowCount; i++) {
			var rowData = INPoItmGridDs.getAt(i);	
			//新增或数据发生变化时执行下述操作
			if(rowData.data.newRecord || rowData.dirty){					
				var Inpoi=rowData.get("PoItmId");
				var inci = rowData.get("IncId");
				var uom = rowData.get("PurUomId");
				var qty = rowData.get("PurQty");
				if(qty==""){
					Msg.info("error",$g("请填写数量!"));
					var colindex=GetColIndex(INPoItmGrid,"PurQty");
					INPoItmGrid.startEditing(i,colindex);
					return false;
				}
				var Rp = rowData.get("Rp");
				var FreeDrugFlag = rowData.get('FreeDrugFlag');
				var icnt = i + 1;
				
				if(FreeDrugFlag=="Y"){
               		if(Rp!=0){
		   				Msg.info("warning",$g("第")+icnt+	$g("行免费药的价格只能为零0!"));
		    			return;
               		}
	            }
	   			else if (Rp <=0) {
		   			Msg.info("warning",	$g("第")+icnt+$g("行进价不能小于或等于0!"));
		    		return;
	            }
				
			
				var reqQty=qty  ; //暂时使用购买数量
				
				var str = Inpoi + "^" + inci + "^"	+ uom + "^" + Rp+"^"+qty +"^"+ reqQty;
						//alert(ListDetail)
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
				Msg.info("error",$g("没有明细!"));
				return ;
			}
 		}
 		var ret = CheckSaveBudget(mainRowId,ListDetail)
 		if(!ret) return;

 		
        var mask=ShowLoadMask(Ext.getBody(),$g("处理中请稍候..."));
		Ext.Ajax.request({
		    url: INPoItmGridUrl+"?actiontype=Save",
		    params:{Main:mainRowId,MainInfo:tmpData,ListDetail:ListDetail},
			method : 'POST',
			waitMsg : $g('处理中...'),
			failure: function(result,request) {
				 mask.hide();
				Msg.info("error",$g("请检查网络连接!"));
			},
			success: function(result,request) {				
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					Msg.info("success",$g("保存成功!"));
					mainRowId = jsonData.info;
					Query(mainRowId);
					SendBusiData(mainRowId,"INPO","SAVE")
				}else{
					Msg.info("error",$g("保存失败!")+jsonData.info);
				}
				mask.hide();
			},
			scope: this
		});
	}
}

function CheckSaveBudget(mainRowId,data){
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
		business : "INPO", //业务类型
		businode : "SAVE", //业务节点
		main_id : mainRowId, //业务主表id
		main_no : "", //业务单号
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


// 显示订单数据
function Query(InpoRowid) {
	mainRowId=InpoRowid;  //这一句很重要，必须有
	if (InpoRowid == null || InpoRowid.length <= 0 || InpoRowid <= 0) {
		return;
	}
	Ext.Ajax.request({
		url : INPoItmGridUrl	+ "?actiontype=Select&InpoId=" + InpoRowid,
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
				groupField.setValue(data['StkGrpId']);
				groupField.setRawValue(data['StkGrpDesc']);
				//remark=handleMemo(remark,xMemoDelim());
				//remarkField.setValue(remark);	
				if( data['INPO_Completed']=="Y"){
					finishCK.setValue(true);
					saveINPoM.disable();
					deleteINPoM.disable();
				}
				else{
					finishCK.setValue(false);
					saveINPoM.enable();
					deleteINPoM.enable();
				}
	 
				Ext.getCmp('remarkField').setValue(handleMemo(data['INPO_Remarks'],xMemoDelim()));
				
				//检索明细
				getDetail(InpoRowid);
			}				
			}
			groupField.setDisabled(true);
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
	//i/f(inGrFlag==true){
	//	changeButtonEnable("1^1^0^0^0^0^1");
	//}else{
	//	changeButtonEnable("1^1^1^1^1^1^0");
	//}
}
		
/**
 * 删除选中行药品
 */
function deleteDetail() {
	// 判断订单是否已完成
	var CmpFlag = Ext.getCmp("finishCK").getValue();
	if (CmpFlag != null && CmpFlag != false) {
		Msg.info("warning", $g("当前订单已完成,禁止删除明细记录!"));
		return;
	}
	var cell = INPoItmGrid.getSelectionModel().getSelectedCell();
	if (cell == null) {
		Msg.info("warning", $g("没有选中行!"));
		return;
	}
	// 选中行
	var row = cell[0];
	var record = INPoItmGrid.getStore().getAt(row);
	var Inpoi = record.get("PoItmId");
	if (Inpoi == "" ) {
		INPoItmGrid.getStore().remove(record);
		INPoItmGrid.getView().refresh();
	} else {
		Ext.MessageBox.show({
			title : $g('提示'),
			msg : $g('是否确定删除该药品信息'),
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
		var url = INPoItmGridUrl	+ "?actiontype=deleteItem&InPoi=" + Inpoi;

		Ext.Ajax.request({
					url : url,
					method : 'POST',
					waitMsg : $g('删除中...'),
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
								//alert("jsonData="+jsonData)
						if (jsonData.success == 'true') {
							Msg.info("success", $g("删除成功!"));
							INPoItmGrid.getStore().remove(record);
							INPoItmGrid.getView().refresh();
						} else {
							var ret=jsonData.info;
							if(ret==-1){
								Msg.info("error", $g("订单已经完成，不能删除!"));
							}else{
								Msg.info("error", $g("删除失败,请查看错误日志!"));
							}
						}
					},
					scope : this
				});
	}
}

var deleteINPoM = new Ext.Toolbar.Button({
	text:$g('删除'),
    tooltip:$g('删除'),
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
				Ext.MessageBox.confirm($g('提示'),$g('确定要删除该订单?'),
					function(btn) {
							if(btn == "yes"){
							Ext.Ajax.request({
								//url : INPoItmGridUrl + "?actiontype=delete&InpoId=" +mainRowId,
								url : INPoItmGridUrl + "?actiontype=delete&InpoId=" +rowid,
								waitMsg:$g('删除中...'),
								failure: function(result, request) {
									Msg.info("error", $g("请检查网络连接!"));
									return false;
								},
								success : function(result, request) {
									var jsonData = Ext.util.JSON.decode(result.responseText);
									if (jsonData.success == 'true') {
										//INPoItmGridDs.load({params:{Parref:mainRowId}});
										Msg.info("success", $g("订单删除成功!"));
									    clearData();
									}else{
										var ret=jsonData.info;
									if(ret==-1){
										Msg.info("error", $g("订单已经完成，不能删除!"));
									}if(ret==-3){
										Msg.info("error", $g("删除订单失败!"));
									}if(ret==-4){
										Msg.info("error", $g("删除订单附加表失败!"));
									}else{
										Msg.info("error", $g("删除失败,请查看错误日志!"));
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
				Msg.info("error", $g("订单Id为空,不允许删除!"));
				return false;
			}
		//}
	}
});
//--------------------
function clearData(){
	SetLogInDept(GetGroupDeptStore,'locField')
	mainRowId='';
	Ext.getCmp('needDateField').setValue(new Date());
	Ext.getCmp('inpoNoField').setValue("");
	Ext.getCmp('remarkField').setValue("");
	Ext.getCmp("Vendor").setValue("");
	Ext.getCmp("finishCK").setValue(false);
	groupField.setDisabled(false);
	groupField.getStore().load();
	INPoItmGridDs.removeAll();
	saveINPoM.enable();
	deleteINPoM.enable();
}

var finshInpo = new Ext.Toolbar.Button({
	text:$g('完成'),
    tooltip:$g('完成'),
    iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		if((mainRowId=="")||(mainRowId==null)){
			Msg.info("error", $g("订单为空!"));
			return false;
		}else{
			if(Ext.getCmp("finishCK").getValue()==true){
				Msg.info("warning",$g("该订单已经完成!"))
				return;
			}
		   	
		var count=INPoItmGrid.getStore().getCount();
		if (count==0) {Msg.info("warning",$g("该订单没有明细!"));return;}	
		    for (var i=0;i<count;i++){
		    var rowData=INPoItmGrid.getStore().getAt(i);
		     //新增或数据发生变化时执行下述操作
		    if(rowData.data.newRecord || rowData.dirty){  
		       Msg.info("warning",$g("订单明细已发生改变,请先保存后完成!"));
		       return;
		           }
		       
		       }
			
			
			
			Ext.MessageBox.confirm($g('提示'),$g('确定要完成该订单吗?'),
				function(btn) {
					if(btn == 'yes'){
						var ret = SendBusiData(mainRowId,"INPO","COMP")
						if(!ret) return;

						Ext.Ajax.request({
							url:'dhcst.inpoaction.csp?actiontype=finish&InpoId='+mainRowId+'&Usr='+UserId,
							waitMsg:$g('更新中...'),
							failure: function(result, request) {
								Msg.info("error", $g("请检查网络连接!"));
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success", $g("订单设置为完成状态!"));
									Query(mainRowId);
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
   // 变换行颜色
	function changeBgColor(row, color) {
		INPoItmGrid.getView().getRow(row).style.backgroundColor = color;
	}
var noFinshInpo = new Ext.Toolbar.Button({
	text:$g('取消完成'),
    tooltip:$g('取消完成'),
    iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		if((mainRowId=="")||(mainRowId==null)){
			Msg.info("error", $g("订单为空!"));
			return false;
		}else{
			if(Ext.getCmp("finishCK").getValue()==false){
				Msg.info("warning",$g("该单据尚未完成!!"))
				return;
			}
			//判断是否上传过医共体住院
			var ret=tkMakeServerCall("web.DHCST.INPO","GetMainINPoId",mainRowId)
			if(ret==2)
			{
				Msg.info("warning",$g("该单据已上传医共体主院，请先在订单到货查询界面取消上传!"))
				return;
			}
			else if(ret==1)
			{
				Msg.info("warning",$g("该单据为子院上传订单，主院不允许修改!"))
				return;
			}
			
			
			Ext.MessageBox.confirm($g('提示'),$g('确定要取消完成该订单吗?'),
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'dhcst.inpoaction.csp?actiontype=noFinish&InpoId='+mainRowId+'&Usr='+UserId,
							waitMsg:$g('处理中...'),
							failure: function(result, request) {
								Msg.info("error",$g( "请检查网络连接!"));
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success",$g( "订单设置为未完成状态!"));
									Query(mainRowId);
								}else{
									if(jsonData.info==-2){
										Msg.info("error", $g("该订单已经转入库,禁止修改状态!"));
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
	}
});

var formPanel = new Ext.form.FormPanel({
	labelWidth : 90,
	labelAlign : 'right',
	//autoScroll:true,
	autoHeight : true,
	frame : true,
	layout:'fit',
	//bodyStyle : 'padding:5px;',
    tbar:[findINPoM,'-',clearINPoM,'-',addINPoM,'-',saveINPoM,'-',finshInpo,'-',noFinshInpo,'-',PrintBT,'-',deleteINPoM],
	items : [{
		xtype : 'fieldset',
		title : $g('订单主信息'),
		layout : 'column',	
		style:DHCSTFormStyle.FrmPaddingV,	
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
			items : [finishCK,BudgetProComb]
		}]
	}]

});

var AddDetailBT=new Ext.Button({
	text:$g('增加一条'),
	tooltip:'',
	height:30,
	width:70,
	iconCls:'page_add',
	handler:function()
	{	
		addNewRow();
	}
});

var DelDetailBT=new Ext.Button({
	text:$g('删除一条'),
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
INPoItmGrid = new Ext.grid.EditorGridPanel({
	title:$g('订单明细'),
	store:INPoItmGridDs,
	cm:INPoItmGridCm,
	trackMouseOver:true,
	region:'center',
	height:650,
	stripeRows:true,
	loadMask:true,
	tbar:{items:[AddDetailBT,'-',DelDetailBT,'-',{text:$g('列设置'),height:30,width:70,iconCls:'page_gear',handler:function(){	GridColSet(INPoItmGrid,"DHCSTPO");}}]},
	clicksToEdit:1,
	sm:new Ext.grid.CellSelectionModel({}),
	listeners:{
		afteredit:function(e){
			if(e.field=='PurQty'){
				var newqty = e.value;
				//使页面的列中保留2位小数
				//小数位数变量
				var pos = 3;
				e.record.set("spAmt",Math.round(newqty*e.record.get('Sp')*Math.pow(10,pos))/Math.pow(10,pos)); 
				e.record.set("rpAmt",Math.round(newqty*e.record.get('Rp')*Math.pow(10,pos))/Math.pow(10,pos)); 
				e.record.set("ppAmt",Math.round(newqty*e.record.get('pp')*Math.pow(10,pos))/Math.pow(10,pos)); 
			}
			if(e.field=='Rp'){
				var resultRpNew = e.value;
				var newQty=e.record.get("PurQty");
				var pos = 3;
				e.record.set("rpAmt",Math.round(resultRpNew*newQty*Math.pow(10,pos))/Math.pow(10,pos)); 	
			}
		},
		beforeedit:function(e){
			var pouomid=e.record.get('PurUomId');
			var poinci=e.record.get('IncId');			
			var decimalstr=tkMakeServerCall("web.DHCST.Common.AppCommon","GetDecimalCommon",GroupId,CtLocId,UserId,poinci,pouomid);
			var decimalarr=decimalstr.split("^");
			Ext.getCmp("PoRp").decimalPrecision=decimalarr[0];
		}
	}
});

/***
		**添加右键菜单
		**/
		
	INPoItmGrid.addListener('rowcontextmenu', rightClickFn);//右键菜单代码关键部分 
	var rightClick = new Ext.menu.Menu({ 
		id:'rightClickCont', 
		items: [ 
			{ 
				id: 'mnuDelete', 
				handler: deleteDetail, 
				text: $g('删除' )
			}
		] 
	}); 
		
				//右键菜单代码关键部分 
		function rightClickFn(grid,rowindex,e){ 
			e.preventDefault(); 
			rightClick.showAt(e.getXY()); 
		}
//=========================订单录入=============================

//===========模块主页面=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	if(gParamCommon.length<1){
		GetParamCommon();  
	}
	var panel = new Ext.Panel({
		title:$g('订单录入'),
		activeTab:0,
		region:'north',
		height:DHCSTFormStyle.FrmHeight(2),
		layout:'fit',
		items:[formPanel]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[panel,INPoItmGrid],
		renderTo:'mainPanel'
	});
	RefreshGridColSet(INPoItmGrid,"DHCSTPO");   //根据自定义列设置重新配置列
	colArr = sortColoumByEnterSort(INPoItmGrid);
	SetBudgetPro(Ext.getCmp("locField").getValue(),"INPO",[1,2],"saveINPoM") //加载HRP预算项目
});

function setGridEditable(grid,b)
{
	var colId=grid.getColumnModel().getIndexById('eIncDesc');
	grid.getColumnModel().setEditable(colId,b);
	var colId=grid.getColumnModel().getIndexById('ePurUomId');	        
	grid.getColumnModel().setEditable(colId,b);
	
	var colId=grid.getColumnModel().getIndexById('ePurQty');	        
	grid.getColumnModel().setEditable(colId,b);
	
	var colId=grid.getColumnModel().getIndexById('eRp');	        
	grid.getColumnModel().setEditable(colId,b);
	
}
//===========模块主页面=============================================