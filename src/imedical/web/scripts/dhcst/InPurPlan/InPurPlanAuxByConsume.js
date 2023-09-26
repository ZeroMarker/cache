// /名称: 采购计划辅助制单（依据消耗）
// /描述: 采购计划辅助制单（依据消耗）
// /编写者：zhangdongmei
// /编写日期: 2012.08.01

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];

	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	if(gParam.length<1){
		GetParam();
	}
	
	var ConsumeLoc = new Ext.ux.LocComboBox({
				fieldLabel : '消耗科室',
				id : 'ConsumeLoc',
				name : 'ConsumeLoc',
				anchor : '90%',
				emptyText : '消耗科室...',
				defaultLoc:""
			});

	// 订购部门
	var PurLoc = new Ext.ux.LocComboBox({
		fieldLabel : '采购部门',
		id : 'PurLoc',
		name : 'PurLoc',
		anchor : '90%',
		emptyText : '采购部门...',
		groupId:session['LOGON.GROUPID'],
		listeners : {
			'select' : function(e) {
				var SelLocId=Ext.getCmp('PurLoc').getValue();//add wyx 根据选择的科室动态加载类组
				StkGrpType.getStore().removeAll();
				StkGrpType.getStore().setBaseParam("locId",SelLocId)
				StkGrpType.getStore().setBaseParam("userId",userId)
				StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
				StkGrpType.getStore().load();
			}
		}
	});
			
	// 起始日期
	var StartDate = new Ext.ux.EditDate({
				fieldLabel : '起始日期',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				value : DefaultStDate()
			});
	// 截止日期
	var EndDate = new Ext.ux.EditDate({
				fieldLabel : '截止日期',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				value : DefaultEdDate()
			});
			
	var UseDays =new Ext.form.NumberField({
			fieldLabel : '用药天数',
			id : 'UseDays',
			name : 'UseDays',
			anchor : '90%'
	});
	
	var HospitalFlag = new Ext.form.Checkbox({
		boxLabel : '根据全院消耗',
		id : 'HospitalFlag',
		name : 'HospitalFlag',
		anchor : '90%',
		//width : 120,
		checked : false,
		handler:function(){
				Ext.getCmp("TFlag").setValue(false);
				Ext.getCmp("KFlag").setValue(false);
		}
	});
	var AllLocQtyFlag = new Ext.form.Checkbox({
		boxLabel : '根据全院库存',
		id : 'AllLocQtyFlag',
		name : 'AllLocQtyFlag',
		anchor : '90%',
		//width : 120,
		checked : false
	});
	var IncludeZeroFlag = new Ext.form.Checkbox({
		boxLabel : '包含计划数量为0',
		id : 'IncludeZeroFlag',
		name : 'IncludeZeroFlag',
		anchor : '90%',
		//width : 120,
		checked : false
	});
		   // 招标
		var ZBFlag = new Ext.form.Radio({
			boxLabel : '招标',
			id : 'ZBFlag',
			name : 'ZBType',
			anchor : '80%'
				});
					   // 非招标
		var NotZBFlag = new Ext.form.Radio({
			boxLabel : '非招标',
			id : 'NotZBFlag',
			name : 'ZBType',
			anchor : '80%'
				});
					   // 全部
		var AllFlag = new Ext.form.Radio({
			boxLabel : '全部',
			id : 'AllFlag',
			name : 'ZBType',
			anchor : '80%',
			checked : true
				});
	//改变根据全院消耗的值
	HospitalFlag.on('check', function(checkbox,value) {
		if(value==true){
			Ext.getCmp("TFlag").setDisabled(true);
			Ext.getCmp("KFlag").setDisabled(true);
		}else{
			Ext.getCmp("TFlag").setDisabled(false);
			Ext.getCmp("KFlag").setDisabled(false);
		}
		
	
	});
	// 药品类组
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:App_StkTypeCode,     //标识类组类型
		LocId:session['LOGON.CTLOCID'],
		UserId:userId,
		anchor : '90%'
	}); 
	// 库存分类
var M_StkCat = new Ext.ux.ComboBox({
	fieldLabel : '库存分类',
	id : 'M_StkCat',
	name : 'M_StkCat',
	store : StkCatStore,
	valueField : 'RowId',
	displayField : 'Description',
	params:{StkGrpId:'StkGrpType'}
});
	var PFlag = new Ext.form.Checkbox({
		boxLabel : '住院发药',
		id : 'PFlag',
		name : 'PFlag',
		anchor : '90%',
		//width : 80,
		checked : false
	});
	var YFlag = new Ext.form.Checkbox({
		boxLabel : '住院退药',
		id : 'YFlag',
		name : 'YFlag',
		anchor : '90%',
		//width : 80,
		checked : false
	});
	var FFlag = new Ext.form.Checkbox({
		boxLabel : '门诊发药',
		id : 'FFlag',
		name : 'FFlag',
		anchor : '90%',
		//width : 80,
		checked : false
	});
	var HFlag = new Ext.form.Checkbox({
		boxLabel : '门诊退药',
		id : 'HFlag',
		name : 'HFlag',
		anchor : '90%',
		//width : 80,
		checked : false
	});
	var TFlag = new Ext.form.Checkbox({
		boxLabel : '转出',
		id : 'TFlag',
		name : 'TFlag',
		anchor : '90%',
		//width : 80,
		checked : false
	});
	var KFlag = new Ext.form.Checkbox({
		boxLabel : '转入',
		id : 'KFlag',
		name : 'KFlag',
		anchor : '90%',
		//width : 80,
		checked : false
	});
	// 查询按钮
	var SearchBT = new Ext.Toolbar.Button({
				text : '查询',
				tooltip : '点击查询',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					Query();
				}
			});
	/**
	 * 查询方法
	 */
	function Query() {
		var PurLoc = Ext.getCmp("PurLoc").getValue();
		var ConsumeLoc = Ext.getCmp("ConsumeLoc").getValue();
		var startDate = Ext.getCmp("StartDate").getRawValue();
		var endDate = Ext.getCmp("EndDate").getRawValue();
		var UseDays = Ext.getCmp("UseDays").getValue();
		var ZBFlag=Ext.getCmp("ZBFlag").getValue();
		var NotZBFlag=Ext.getCmp("NotZBFlag").getValue();
		var AllFlag=Ext.getCmp("AllFlag").getValue();
		var AllLocQtyFlag=(Ext.getCmp('AllLocQtyFlag').getValue()==true?'Y':'N');
		var IncludeZeroFlag=(Ext.getCmp('IncludeZeroFlag').getValue()==true?'Y':'N');
		 //库存分类
        var stkCatId = Ext.getCmp('M_StkCat').getValue();
		if (AllFlag==true){
			var zbflagstr=1;
			}
		else if(ZBFlag==true){
			var zbflagstr=2;
			}
		else{
			var zbflagstr=3;
			}
			
		if (PurLoc == undefined || PurLoc.length <= 0) {
			Msg.info("warning", "请选择采购部门!");
			return;
		}
		
		if (startDate == undefined || startDate.length <= 0) {
			Msg.info("warning", "请选择开始日期!");
			return;
		}
		if (endDate == undefined || endDate.length <= 0) {
			Msg.info("warning", "请选择截止日期!");
			return;
		}
		if (UseDays == undefined || UseDays.length <= 0) {
			Msg.info("warning", "请填写用药天数!");
			return;
		}
		var stkgrp=Ext.getCmp("StkGrpType").getValue();
		var HospFlag=Ext.getCmp("HospitalFlag").getValue();
		var TransType='';
		var PFlag=(Ext.getCmp("PFlag").getValue()==true?'P':'');
		var YFlag=(Ext.getCmp("YFlag").getValue()==true?'Y':'');
		var FFlag=(Ext.getCmp("FFlag").getValue()==true?'F':'');
		var HFlag=(Ext.getCmp("HFlag").getValue()==true?'H':'');
		var TFlag=(Ext.getCmp("TFlag").getValue()==true?'T':'');
		var KFlag=(Ext.getCmp("KFlag").getValue()==true?'K':'');
		if(PFlag!=''){
			if(TransType!=''){
				TransType=TransType+','+PFlag;
			}else{
				TransType=PFlag;
			}
		}
		if(YFlag!=''){
			if(TransType!=''){
				TransType=TransType+','+YFlag;
			}else{
				TransType=YFlag;
			}
		}
		if(FFlag!=''){
			if(TransType!=''){
				TransType=TransType+','+FFlag;
			}else{
				TransType=FFlag;
			}
		}
		if(HFlag!=''){
			if(TransType!=''){
				TransType=TransType+','+HFlag;
			}else{
				TransType=HFlag;
			}
		}
		if(TFlag!=''){
			if(TransType!=''){
				TransType=TransType+','+TFlag;
			}else{
				TransType=TFlag;
			}
		}
		if(KFlag!=''){
			if(TransType!=''){
				TransType=TransType+','+KFlag;
			}else{
				TransType=KFlag;
			}
		}
		if (TransType == null || TransType.length <= 0) {
			Msg.info("warning", "请选择业务类型!");
			return;
		}
		if(HospFlag==true){
			//开始日期,截止日期,用药天数,类组id,业务类型串,采购科室id
			var ListParam=startDate+'^'+endDate+'^'+UseDays+'^'+stkgrp+'^'+TransType+'^'+PurLoc+'^'+userId+"^"+zbflagstr+"^"+stkCatId+"^"+AllLocQtyFlag+"^"+IncludeZeroFlag;	
			var url= DictUrl
				+ 'inpurplanaction.csp?actiontype=QueryAllItmForPurch';
	
		}else{
			if (ConsumeLoc == undefined || ConsumeLoc.length <= 0) {
				Msg.info("warning", "请选择消耗部门!");
				return;
			}
			//消耗科室id,开始日期,截止日期,用药天数,类组id,业务类型串,采购科室id
			var ListParam=ConsumeLoc+'^'+startDate+'^'+endDate+'^'+UseDays+'^'+stkgrp+'^'+TransType+'^'+PurLoc+'^'+userId+"^"+zbflagstr+"^"+stkCatId+"^"+AllLocQtyFlag+"^"+IncludeZeroFlag;					
			var url= DictUrl
				+ 'inpurplanaction.csp?actiontype=QueryLocItmForPurch';
		}
		DetailStore.proxy = new Ext.data.HttpProxy({
			url : encodeURI(url),
			method : "POST"
		});
		DetailStore.load({params:{start:0, limit:999,strParam:ListParam},
			callback : function(o,response,success) { 
				if (success == false){  
					Ext.MessageBox.alert("查询错误",DetailStore.reader.jsonData.Error);
					DetailGrid.loadMask.hide();  
				}
			}
		});
	}
	
function save(){
	var purNo = '';
	var locId = Ext.getCmp('PurLoc').getValue();
	var stkGrpId = Ext.getCmp('StkGrpType').getValue();
	var rowCount = DetailGrid.getStore().getCount();				
	var data="";
	for(var i=0;i<rowCount;i++){
		var rowData = DetailStore.getAt(i);	
		var rowid = '';
		var incId = rowData.data["Inci"];
		var qty = rowData.data["PurQty"];
		var uomId = rowData.data["PurUomId"];
		var vendorId = rowData.data["VenId"];
		var rp =rowData.data["Rp"];
		var manfId =rowData.data["ManfId"];
		var carrierId =rowData.data["CarrierId"];
		var reqLocId =rowData.data["ReqLocId"]||"";	// 申购科室
		var prolocqty=rowData.data["ProLocQty"];;  //建议采购量
		var dataRow = rowid+"^"+incId+"^"+qty+"^"+uomId+"^"+vendorId+"^"+rp+"^"+manfId+"^"+carrierId+"^"+reqLocId+"^"+prolocqty;
		if(data==""){
			data = dataRow;
		}else{
			data = data+xRowDelim()+dataRow;
		}
	}
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
	if(data!=""){
		Ext.Ajax.request({
			url: DictUrl+'inpurplanaction.csp?actiontype=save',
			params:{purNo:purNo,locId:locId,stkGrpId:stkGrpId,userId:userId,data:data},
			failure: function(result, request) {
				Msg.info("error","请检查网络连接!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					Msg.info("success","保存成功!");
					location.href="dhcst.inpurplan.csp?planNnmber="+jsonData.info+'&locId='+locId+'&zbFlag='+zbflagstr;
				}else{
					if(jsonData.info==-1){
						Msg.info("error","科室或人员为空!");
					}else if(jsonData.info==-99){
						Msg.info("error","加锁失败!");
					}else if(jsonData.info==-2){
						Msg.info("error","生成计划单号失败!");
					}else if(jsonData.info==-3){
						Msg.info("error","保存计划单失败!");
					}else if(jsonData.info==-4){
						Msg.info("error","未找到需更新的计划单!");
					}else if(jsonData.info==-5){
						Msg.info("error","保存计划单明细失败,不能生成计划单!如果药品较少请检查是否有不可用药品");
					}else if(jsonData.info==-7){
						Msg.info("error","失败药品：部分明细保存不成功，提示不成功的药品!"+jsonData.info);
					}else{
						Msg.info("error","保存失败!"+jsonData.info);
					}
				}
			},
			scope: this
		});
	}
		}

	// 清空按钮
	var ClearBT = new Ext.Toolbar.Button({
				text : '清屏',
				tooltip : '点击清屏',
				width : 70,
				height : 30,
				iconCls : 'page_clearscreen',
				handler : function() {
					clearData();
				}
			});
	/**
	 * 清空方法
	 */
	function clearData() {
		Ext.getCmp("PurLoc").setValue(session['LOGON.CTLOCID']);
		Ext.getCmp("ConsumeLoc").setValue("");
		Ext.getCmp("StartDate").setValue(DefaultStDate());
		Ext.getCmp("EndDate").setValue(DefaultEdDate());
		Ext.getCmp("UseDays").setValue("");
		Ext.getCmp("StkGrpType").setValue("");
		Ext.getCmp("StkGrpType").setRawValue("");
		Ext.getCmp("PFlag").setValue(false);
		Ext.getCmp("YFlag").setValue(false);
		Ext.getCmp("FFlag").setValue(false);
		Ext.getCmp("HFlag").setValue(false);
		Ext.getCmp("TFlag").setValue(false);
		Ext.getCmp("KFlag").setValue(false);
		Ext.getCmp("HospitalFlag").setValue(false);
		Ext.getCmp("AllLocQtyFlag").setValue(false);
		Ext.getCmp("IncludeZeroFlag").setValue(false);
		Ext.getCmp("M_StkCat").setValue("");
		Ext.getCmp("M_StkCat").setRawValue("");
		Ext.getCmp("NotZBFlag").setValue(false);
		Ext.getCmp("ZBFlag").setValue(false);
		Ext.getCmp("AllFlag").setValue(true);
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}
	// 另存按钮
	var SaveAsBT = new Ext.Toolbar.Button({
				text : '另存',
				tooltip : '另存为Excel',
				iconCls : 'page_export',
				width : 70,
				height : 30,
				handler : function() {
					ExportAllToExcel(DetailGrid);
					//gridSaveAsExcel(DetailGrid); //本页页面数据
				}
			});
	// 保存按钮
	var SaveBT = new Ext.Toolbar.Button({
				text : '保存',
				tooltip : '点击保存',
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {
					save();
				}
			});
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
				valueNotFoundText : ''
			});

		/**
		 * 单位展开事件
		 */
		CTUom.on('expand', function(combo) {
					var cell = DetailGrid.getSelectionModel().getSelectedCell();
					var record = DetailGrid.getStore().getAt(cell[0]);
					var InciDr = record.get("Inci");
					ItmUomStore.removeAll();
					/*
					var url = DictUrl
							+ 'drugutil.csp?actiontype=INCIUom&ItmRowid='
							+ InciDr;
					CTUomStore.proxy = new Ext.data.HttpProxy({
								url : url
							}); */
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
				var ConFac = record.get("ConFac");   //大单位到小单位的转换关系					
				var TrUom = record.get("PurUomId");    //目前显示的出库单位
				var Rp = record.get("Rp");
				var StkQty = record.get("StkQty");
				//var DirtyQty=record.get("ResQty");
				//var AvaQty=record.get("AvaQty");
				var PurQty=record.get("PurQty");
				
				if (value == undefined || value.length <= 0) {
					return;
				} else if (TrUom == value) {
					return;
				} else if (value==BUom) {     //新选择的单位为基本单位，原显示的单位为大单位
					record.set("Rp", Rp/ConFac);
					record.set("StkQty", StkQty*ConFac);
					//record.set("ResQty", DirtyQty*ConFac);
					//record.set("AvaQty", AvaQty*ConFac);
					record.set("PurQty", PurQty*ConFac);
				} else{  //新选择的单位为大单位，原先是单位为小单位
					record.set("Rp", Rp*ConFac);
					record.set("StkQty", StkQty/ConFac);
					//record.set("ResQty", DirtyQty/ConFac);
					//record.set("AvaQty", AvaQty/ConFac);
					record.set("PurQty", PurQty/ConFac);
				}
				record.set("PurUomId", combo.getValue());
	});
	
	
	
			/**
	 * 删除选中行药品
	 */
	function deleteDetail() {
		var selectlist=DetailGrid.getSelectionModel().getSelections();
		if ((selectlist == null)||(selectlist=="")) {
			Msg.info("warning", "请选中需要删除的记录!");
			return;
		}
		var selectlength=selectlist.length
		for (var selecti=0;selecti<selectlength;selecti++){
			var selectrecord=selectlist[selecti];
			DetailGrid.getStore().remove(selectrecord);
		}	
		DetailGrid.getView().refresh();	
	}
	
	// 转移明细
	// 访问路径
	var DetailUrl =  DictUrl
				+ 'inpurplanaction.csp?actiontype=QueryLocItmForPurch';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = [ "Inci","InciCode","InciDesc", "PurUomId", "PurUomDesc", "PurQty","VenId",
			 "VenDesc", "ManfId", "ManfDesc","StkQty","Rp","CarrierId", "CarrierDesc", "DispensQty",
			 "BUomId","ConFac","ApcWarn","StkCatDesc","ProLocQty","HospStkQty","PackQty","PackUomDesc",
			 "PackPurFac","LastExpDate","ReqLocId"];
			
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "Inci",
				fields : fields
			});
	
	// 数据集
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	/**
	 * 显示明细前，装载必要的combox
	 */
	DetailStore.on('beforeload',function(store,options){
		//装载所有单位
		var url = DictUrl
						+ 'drugutil.csp?actiontype=CTUom&CTUomDesc=&start=0&limit=9999';
		CTUomStore.proxy = new Ext.data.HttpProxy({
							url : url
						});
		CTUomStore.load();
	});
	var sm = new Ext.grid.CheckboxSelectionModel();
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm,sm, {
				header : "药品Id",
				dataIndex : 'Inci',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : '药品代码',
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '库存分类',
				dataIndex : 'StkCatDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '药品名称',
				dataIndex : 'InciDesc',
				width : 220,
				align : 'left',
				sortable : true
			}, {
				header : "采购数量",
				dataIndex : 'PurQty',
				width : 80,
				align : 'right',
				sortable : true,
				editor : new Ext.form.NumberField({
					selectOnFocus : true,
					allowBlank : false,
					listeners : {
						specialkey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								var qty = field.getValue();
								if (qty == null || qty.length <= 0) {
									Msg.info("warning", "采购数量不能为空!");
									return;
								}
								if (qty <= 0) {
									Msg.info("warning", "采购数量不能小于或等于0!");
									return;
								}									
							}
						}
					}
				})
			}, {
				header : "单位",
				dataIndex : 'PurUomId',
				width : 80,
				align : 'left',
				sortable : true,
				renderer :Ext.util.Format.comboRenderer2(CTUom,"PurUomId","PurUomDesc"),								
				editor : new Ext.grid.GridEditor(CTUom)
			}, {
				header : "供应商",
				dataIndex : 'VenDesc',
				width : 140,
				align : 'left',
				sortable : true
			}, {
				header : "厂商",
				dataIndex : 'ManfDesc',
				width : 140,
				align : 'left',
				sortable : true
			}, {
				header : "进价",
				dataIndex : 'Rp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : "采购科室库存",
				dataIndex : 'StkQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "消耗总量",
				dataIndex : 'DispensQty',
				width : 80,
				align : 'right',
				sortable : true
			},{
				header : "建议采购量",
				dataIndex : 'ProLocQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "配送商",
				dataIndex : 'CarrierDesc',
				width : 80,
				align : 'right',
				sortable : true
			},{
				header : "资质信息",
				dataIndex : 'ApcWarn',
				width : 140,
				align : 'right',
				sortable : true
			},{
				header : "全院库存",
				dataIndex : 'HospStkQty',
				width : 90,
				align : 'right',
				sortable : true
			},{
				header : "大包装数量",
				dataIndex : 'PackQty',
				width : 90,
				align : 'right',
				sortable : true,
				hidden:true
			},{
				header : "大包装系数",
				dataIndex : 'PackPurFac',
				width : 90,
				align : 'right',
				sortable : true,
				hidden:true
			},{
				header : "大包装单位",
				dataIndex : 'PackUomDesc',
				width : 90,
				align : 'right',
				sortable : true
			},{
				header : "最后入库效期",
				dataIndex : 'LastExpDate',
				width : 90,
				align : 'right',
				sortable : true
			},{
				header : "申购科室Id",
				dataIndex : 'ReqLocId',
				width : 90,
				align : 'right',
				sortable : true
			}]);

	var DetailGrid = new Ext.grid.EditorGridPanel({
				title : '',
				height : 200,
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				sm :sm, // new Ext.grid.CellSelectionModel({}),
				clicksToEdit : 1
			});
	/***
	**添加右键菜单
	**/		
	DetailGrid.addListener('rowcontextmenu', rightClickFn);//右键菜单代码关键部分 
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
		rightClick.showAt(e.getXY()); 
	}


	
	var col1={ 				
			columnWidth: 0.3,
        	xtype: 'fieldset',
        	labelWidth: 60,	
        	defaults: {width: 180, border:false},    // Default config options for child items
        	defaultType: 'textfield',
        	autoHeight: true,
        	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
        	border: false,
        	//style: {
            //	"margin-left": "10px", // when you add custom margin in IE 6...
           	//	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0",  // you have to adjust for it somewhere else
           	//	"margin-bottom": "10px"
        	//},
        	items: [PurLoc,ConsumeLoc,StkGrpType]
			
		}
	var col2={ 				
			columnWidth: 0.15,
        	xtype: 'fieldset',
        	labelWidth: 60,	
        	defaults: {width: 180, border:false},    // Default config options for child items
        	defaultType: 'textfield',
        	autoHeight: true,
        	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
        	border: false,
        	//style: {
            //	"margin-left": "10px", // when you add custom margin in IE 6...
            //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
        	//},
        	items: [StartDate,EndDate,UseDays]
			
		}
	var col3={ 				
			width: 360,
			title:'业务类型',
			xtype: 'fieldset',
				frame : true,
				autoScroll : true,
				bodyStyle : 'padding-top:0px;',
				layout: 'column',  
				items:[{ 				
						columnWidth: 0.5,
		            	xtype: 'fieldset',
		            	//labelWidth: 50,	
		            	//defaults: {width: 80, border:false},    // Default config options for child items
		            	defaultType: 'textfield',
		            	autoHeight: true,
		            	border: false,	          
		            	items: [PFlag,YFlag,FFlag]
						
					},{ 				
						columnWidth: 0.5,
		            	xtype: 'fieldset',
		            	//labelWidth: 30,	
		            	//defaults: {width: 80, border:false},    // Default config options for child items
		            	defaultType: 'textfield',
		            	autoHeight: true,
		            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
		            	border: false,
		            	items: [TFlag,KFlag,HFlag]
						
					}]			
						
		}
		
	var col4={ 				
			columnWidth: 0.3,
        	xtype: 'fieldset',
        	labelWidth: 90,	
        	defaults: {width: 210, border:false},    // Default config options for child items
        	defaultType: 'textfield',
        	autoHeight: true,
        	border: false,
        	items: [M_StkCat,
        		 {xtype : 'compositefield',
        		 style: {"margin-left": "-55px","margin-top": "-5px"},
        		 items:[HospitalFlag,AllLocQtyFlag]},
        		 {xtype : 'compositefield',
        		 style: {"margin-left": "-55px","margin-top": "-5px"},
        		 items:[IncludeZeroFlag]}
        		
        		]			
		}
		var col5={ 				
			columnWidth: 0.2,
        	xtype: 'fieldset',
        	labelWidth: 80,	
        	defaults: {width: 100, border:false},    
        	defaultType: 'textfield',
        	autoHeight: true,
        	border: false,
        	items: [AllFlag,NotZBFlag,ZBFlag]
			
		}
	var HisListTab = new Ext.form.FormPanel({
		labelWidth : 60,
		labelAlign : 'right',
		frame : true,
		autoHeight:true,
		tbar : [SearchBT, '-', ClearBT,'-',SaveBT,'-',SaveAsBT],		
		items : [{
			xtype:'fieldset',
			layout: 'table',    // Specifies that the items will now be arranged in columns
			layoutConfig: {columns:5},
			title:'查询条件',
			style : 'padding-top:0px;padding-bottom:0px;',
			items:[col1,col2,col4,col5,col3]
		}]
		
	});

	// 页面布局
	var mainPanel = new Ext.Viewport({
				layout : 'border',
				items : [            // create instance immediately
		            {
		                region: 'north',
		                title:'采购计划制单-依据消耗',
		                height: 220, // give north and south regions a height
		                layout: 'fit', // specify layout manager for items
		                items:HisListTab
		            }, {
		                region: 'center',
		                title: '明细',			               
		                layout: 'fit', // specify layout manager for items
		                items: DetailGrid       
		               
		            }
       			]
			});
DetailGrid.on('mouseover',function(e){
	var rowCount = DetailGrid.getStore().getCount();
	if (rowCount>0)
	{  
		var ShowInCellIndex=GetColIndex(DetailGrid,"InciCode")  //在第几列显示
		var index = DetailGrid.getView().findRowIndex(e.getTarget());
		var record = DetailGrid.getStore().getAt(index);
		if (record)
		{
			var desc=record.data.InciDesc;
			var inci=record.data.Inci;
		}
		ShowAllLocStkQtyWin(e,DetailGrid,ShowInCellIndex,desc,inci);
	}

},this,{buffer:200});

})
