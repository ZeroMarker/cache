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
				fieldLabel : '<font color=blue>消耗科室</font>',
				id : 'ConsumeLoc',
				name : 'ConsumeLoc',
				anchor : '90%',
				emptyText : '消耗科室...',
				defaultLoc:""
			});
	SetLogInDept(ConsumeLoc.getStore(), 'ConsumeLoc');
	
	// 订购部门
	var PurLoc = new Ext.ux.LocComboBox({
				fieldLabel : '采购部门',
				id : 'PurLoc',
				name : 'PurLoc',
				anchor : '90%',
				emptyText : '采购部门...',
				groupId:session['LOGON.GROUPID'],
				stkGrpId : 'groupField'
			});
			
	// 起始日期
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '起始日期',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				
				value : DefaultStDate()
			});
	// 截止日期
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '截止日期',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				
				value : DefaultEdDate()
			});
			
	var UseDays =new Ext.form.NumberField({
			fieldLabel : '参考天数',
			id : 'UseDays',
			name : 'UseDays',
			anchor : '90%',
			value : 30
	});

	var NotUseDaysFlag = new Ext.form.Checkbox({
		boxLabel : '不使用参考天数',
		id : 'NotUseDaysFlag',
		anchor : '90%',
		checked : false
	});
	
	var HospitalFlag = new Ext.form.Checkbox({
		boxLabel : '根据全院消耗',
		id : 'HospitalFlag',
		name : 'HospitalFlag',
		anchor : '90%',
		checked : false,
		listeners : {
			check : function(checkbox,value) {
				if(value == true){
					Ext.getCmp("TFlag").setValue(false);
					Ext.getCmp("KFlag").setValue(false);
					Ext.getCmp("TFlag").setDisabled(true);
					Ext.getCmp("KFlag").setDisabled(true);
				}else{
					Ext.getCmp("TFlag").setDisabled(false);
					Ext.getCmp("KFlag").setDisabled(false);
				}
			}
		}
	});
	
	// 物资类组
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:App_StkTypeCode,     //标识类组类型
		LocId:session['LOGON.CTLOCID'],
		UserId:userId,
		anchor : '90%'
	}); 

	var TFlag = new Ext.form.Checkbox({
		hideLabel : true,
		boxLabel : '转出',
		id : 'TFlag',
		anchor : '90%',
		checked : false
	});
	var KFlag = new Ext.form.Checkbox({
		hideLabel : true,
		boxLabel : '转入',
		id : 'KFlag',
		anchor : '90%',
		checked : false
	});
	
	var PYFHFlag = new Ext.form.Checkbox({
		hideLabel : true,
		boxLabel : '医嘱消耗',
		id : 'PYFHFlag',
		anchor : '90%',
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
					///Query();
					DetailGrid.load();
				}
			});
	/**
	 * 查询方法
	 */
	function Query() {
		var PurLoc = Ext.getCmp("PurLoc").getValue();
		var ConsumeLoc = Ext.getCmp("ConsumeLoc").getValue();
		var startDate = Ext.getCmp("StartDate").getValue();
		if(Ext.isEmpty(startDate)){
			Msg.info('warning', '起始日期不可为空');
			return false;
		}
		startDate = startDate.format(ARG_DATEFORMAT);
		var endDate = Ext.getCmp("EndDate").getValue();
		if(Ext.isEmpty(endDate)){
			Msg.info('warning', '截止日期不可为空');
			return false;
		}
		endDate = endDate.format(ARG_DATEFORMAT);
		var UseDays = Ext.getCmp("UseDays").getValue();
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
		var NotUseDaysFlag = Ext.getCmp('NotUseDaysFlag').getValue()?1:0;		//不使用参考天数的标志
		if (UseDays == undefined || UseDays.length <= 0 && NotUseDaysFlag==0) {
			Msg.info("warning", "请填写参考天数!");
			return;
		}
		var stkgrp=Ext.getCmp("StkGrpType").getValue();
		var HospFlag=Ext.getCmp("HospitalFlag").getValue();
		var TransType='';
		var TFlag=(Ext.getCmp("TFlag").getValue()==true?'T':'');
		var KFlag=(Ext.getCmp("KFlag").getValue()==true?'K':'');
		var PYFHFlag = Ext.getCmp('PYFHFlag').getValue()? 'P,Y,F,H' : '';
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
		if(PYFHFlag!=''){
			if(TransType!=''){
				TransType = TransType+','+PYFHFlag;
			}else{
				TransType = PYFHFlag;
			}
		}
		if (TransType == null || TransType.length <= 0) {
			Msg.info("warning", "请选择业务类型!");
			return;
		}
		
		if(HospFlag==true){
			//开始日期,截止日期,用药天数,类组id,业务类型串,采购科室id,UserId,不使用参考天数标志
			var ListParam=startDate+'^'+endDate+'^'+UseDays+'^'+stkgrp+'^'+TransType
					+'^'+PurLoc+'^'+userId+'^'+NotUseDaysFlag;	
			var url= DictUrl
				+ 'inpurplanaction.csp?actiontype=QueryAllItmForPurch';
		}else{
			if (ConsumeLoc == undefined || ConsumeLoc.length <= 0) {
				Msg.info("warning", "请选择消耗部门!");
				return;
			}
			//消耗科室id,开始日期,截止日期,用药天数,类组id,业务类型串,采购科室id,UserId,不使用参考天数标志
			var ListParam=ConsumeLoc+'^'+startDate+'^'+endDate+'^'+UseDays+'^'+stkgrp
					+'^'+TransType+'^'+PurLoc+'^'+userId+'^'+NotUseDaysFlag;				
			var url= DictUrl
				+ 'inpurplanaction.csp?actiontype=QueryLocItmForPurch';
		}
		
		DetailStore.proxy = new Ext.data.HttpProxy({
			url : encodeURI(url),
			method : "POST"
		});
		DetailStore.removeAll();
		DetailStore.load({params:{start:0, limit:999,strParam:ListParam}});
	}
	
function save(){
	var purNo = '';
	var locId = Ext.getCmp('PurLoc').getValue();
	var stkGrpId = Ext.getCmp('StkGrpType').getValue();
	var rowCount = DetailGrid.getStore().getCount();
	var data="";
	for(var i=0;i<rowCount;i++){
		var rowData = DetailGrid.getStore().getAt(i);	
		var rowid = '';
		var incId = rowData.data["Inci"];
		var qty = rowData.data["PurQty"];
		var uomId = rowData.data["PurUomId"];
		var vendorId = rowData.data["VenId"];
		var rp =rowData.data["Rp"];
		var manfId =rowData.data["ManfId"];
		var carrierId =rowData.data["CarrierId"];
		var reqLocId ='';
		var dataRow = rowid+"^"+incId+"^"+qty+"^"+uomId+"^"+vendorId+"^"+rp+"^"+manfId+"^"+carrierId+"^"+reqLocId;
		if(data==""){
			data = dataRow;
		}else{
			data = data+xRowDelim()+dataRow;
		}
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
					location.href="dhcstm.inpurplan.csp?planNnmber="+jsonData.info+'&locId='+locId;
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
						Msg.info("error","保存计划单明细失败,不能生成计划单!");
					}else if(jsonData.info==-7){
						Msg.info("error","失败物资：部分明细保存不成功，提示不成功的物资!");
					}else{
						Msg.info("error","保存失败!");
					}
				}
			},
			scope: this
		});
	}
}

	// 清空按钮
	var ClearBT = new Ext.Toolbar.Button({
				text : '清空',
				tooltip : '点击清空',
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
		SetLogInDept(PurLoc.getStore(),'PurLoc');
		SetLogInDept(ConsumeLoc.getStore(), 'ConsumeLoc');
		Ext.getCmp("StartDate").setValue(DefaultStDate());
		Ext.getCmp("EndDate").setValue(DefaultEdDate());
		Ext.getCmp("UseDays").setValue(30);
		Ext.getCmp("StkGrpType").getStore().reload();
		Ext.getCmp("TFlag").setValue(false);
		Ext.getCmp("KFlag").setValue(false);
		Ext.getCmp('PYFHFlag').setValue(false);
		Ext.getCmp("HospitalFlag").setValue(false);
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}

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
				store : CTUomStore,
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
				var InciDr = record.get("inci");
				var url = DictUrl
						+ 'drugutil.csp?actiontype=INCIUom&ItmRowid='
						+ InciDr;
				CTUomStore.proxy = new Ext.data.HttpProxy({
							url : url
						});
				CTUom.store.load();
			});

	/**
	 * 单位变换事件
	 */
	CTUom.on('select', function(combo) {
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var record = DetailGrid.getStore().getAt(cell[0]);

				var value = combo.getValue();        //目前选择的单位id
				var BUom = record.get("BUomId");
				var ConFac = record.get("Fac");   //大单位到小单位的转换关系					
				var TrUom = record.get("pUom");    //目前显示的出库单位
				var Sp = record.get("sp");
				var StkQty = record.get("stkQty");
				var DirtyQty=record.get("ResQty");
				var AvaQty=record.get("AvaQty");
				var PurQty=record.get("purQty");
				
				if (value == undefined || value.length <= 0) {
					return;
				} else if (TrUom == value) {
					return;
				} else if (value==BUom) {     //新选择的单位为基本单位，原显示的单位为大单位
					record.set("sp", accDiv(Sp,ConFac));
					record.set("stkQty", accMul(StkQty,ConFac));
					record.set("ResQty", accMul(DirtyQty,ConFac));
					record.set("AvaQty", accMul(AvaQty,ConFac));
					record.set("purQty", accMul(PurQty,ConFac));
				} else{  //新选择的单位为大单位，原先是单位为小单位
					record.set("sp", accMul(Sp,ConFac));
					record.set("stkQty", accDiv(StkQty,ConFac));
					record.set("ResQty", accDiv(DirtyQty,ConFac));
					record.set("AvaQty", accDiv(AvaQty,ConFac));
					record.set("purQty", accDiv(PurQty,ConFac));
				}
				record.set("pUom", combo.getValue());
	});
	
	/**
	 * 删除选中行物资
	 */
	function deleteDetail() {
		
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", "没有选中行!");
			return;
		}
		// 选中行
		var row = cell[0];
		var record = DetailGrid.getStore().getAt(row);
		DetailGrid.getStore().remove(record);
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
			 "BUomId","ConFac","ApcWarn"];
			
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
	
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = [{
				header : "物资Id",
				dataIndex : 'Inci',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : '物资代码',
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '物资名称',
				dataIndex : 'InciDesc',
				width : 180,
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
				dataIndex : "PurUomId",
				xtype:'combocolumn',
				valueField: "PurUomId",
				displayField: "PurUomDesc",
				editor:CTUom
			}, {
				header : "供应商",
				dataIndex : 'VenDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "厂商",
				dataIndex : 'ManfDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "进价",
				dataIndex : 'Rp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : "科室库存",
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
			}, {
				header : "配送商",
				dataIndex : 'CarrierDesc',
				width : 80,
				align : 'right',
				sortable : true
			},{
				header : "资质信息",
				dataIndex : 'ApcWarn',
				width : 240,
				align : 'left',
				sortable : true
			},{
				header : "供应商id",
				dataIndex : 'VenId',
				width : 50,
				align : 'left',
				sortable : true
			},{
				header : "厂商id",
				dataIndex : 'ManfId',
				width : 50,
				align : 'left',
				sortable : true
			},{
				header : "配送商id",
				dataIndex : 'CarrierId',
				width : 50,
				align : 'left',
				sortable : true
			}];

		function GetMasterParams(){
		var PurLoc = Ext.getCmp("PurLoc").getValue();
		var ConsumeLoc = Ext.getCmp("ConsumeLoc").getValue();
		var startDate = Ext.getCmp("StartDate").getValue();
		if(Ext.isEmpty(startDate)){
			Msg.info('warning', '起始日期不可为空');
			return false;
		}
		startDate = startDate.format(ARG_DATEFORMAT);
		var endDate = Ext.getCmp("EndDate").getValue();
		if(Ext.isEmpty(endDate)){
			Msg.info('warning', '截止日期不可为空');
			return false;
		}
		endDate = endDate.format(ARG_DATEFORMAT);
		var UseDays = Ext.getCmp("UseDays").getValue();
		if (PurLoc == undefined || PurLoc.length <= 0) {
			Msg.info("warning", "请选择采购部门!");
			return false;
		}
		
		if (startDate == undefined || startDate.length <= 0) {
			Msg.info("warning", "请选择开始日期!");
			return false;
		}
		if (endDate == undefined || endDate.length <= 0) {
			Msg.info("warning", "请选择截止日期!");
			return false;
		}
		var NotUseDaysFlag = Ext.getCmp('NotUseDaysFlag').getValue()?1:0;		//不使用参考天数的标志
		if (UseDays == undefined || UseDays.length <= 0 && NotUseDaysFlag==0) {
			Msg.info("warning", "请填写参考天数!");
			return false;
		}
		var stkgrp=Ext.getCmp("StkGrpType").getValue();
		var HospFlag=Ext.getCmp("HospitalFlag").getValue();
		var TransType='';
		var TFlag=(Ext.getCmp("TFlag").getValue()==true?'T':'');
		var KFlag=(Ext.getCmp("KFlag").getValue()==true?'K':'');
		var PYFHFlag = Ext.getCmp('PYFHFlag').getValue()? 'P,Y,F,H' : '';
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
		if(PYFHFlag!=''){
			if(TransType!=''){
				TransType = TransType+','+PYFHFlag;
			}else{
				TransType = PYFHFlag;
			}
		}
		if (TransType == null || TransType.length <= 0) {
			Msg.info("warning", "请选择业务类型!");
			return false;
		}
		
		if(HospFlag==true){
			//开始日期,截止日期,用药天数,类组id,业务类型串,采购科室id,UserId,不使用参考天数标志
			var ListParam=startDate+'^'+endDate+'^'+UseDays+'^'+stkgrp+'^'+TransType
					+'^'+PurLoc+'^'+userId+'^'+NotUseDaysFlag;
		}else{
			if (ConsumeLoc == undefined || ConsumeLoc.length <= 0) {
				Msg.info("warning", "请选择消耗部门!");
				return false;
			}
			//消耗科室id,开始日期,截止日期,用药天数,类组id,业务类型串,采购科室id,UserId,不使用参考天数标志
			var ListParam=ConsumeLoc+'^'+startDate+'^'+endDate+'^'+UseDays+'^'+stkgrp
					+'^'+TransType+'^'+PurLoc+'^'+userId+'^'+NotUseDaysFlag;
		}
		return {"strParam":ListParam};
	}
	var DetailGrid = new Ext.dhcstm.EditorGridPanel({
		height : 200,
		collapsible: true,
		title: '',
		id : 'DetailGrid',
		contentColumns : DetailCm,
		actionUrl : 'dhcstm.inpurplanaction.csp',
		queryAction : "QueryLocItmForPurch",
		selectFirst : false,
		idProperty : "Inci",
		checkProperty : "Inci",
		paramsFn : GetMasterParams,
		paging : false,
		showTBar : false
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
		DetailGrid.getSelectionModel().select(rowindex, 0);
		rightClick.showAt(e.getXY());
	}
	
	var col1={
		columnWidth: 0.2,
		xtype: 'fieldset',
		autoHeight: true,
		border: false,
		items: [PurLoc,ConsumeLoc,StkGrpType,HospitalFlag]
	}
	var col2={
		columnWidth: 0.2,
		xtype: 'fieldset',
		autoHeight: true,
		border: false,
		items: [StartDate,EndDate,UseDays,NotUseDaysFlag]
	}
	var col3={
		columnWidth: 0.15,
		title:'业务类型',
		xtype: 'fieldset',
		bodyStyle : 'padding:0 0 0 15px;',
		layout: 'form',
		items:[TFlag,KFlag,PYFHFlag]
	}
		
//	var col4={
//		columnWidth: 0.15,
//		xtype: 'fieldset',
//		labelWidth: 30,	
//		autoHeight: true,
//		border: false,
//		items: [HospitalFlag, NotUseDaysFlag]
//	}
		
	var col5 = {
		columnWidth : 0.42,
		bodyStyle : 'padding:0 0 0 15px;',
		html:'<font size=2 color=blue>1. 以"消耗科室"作为统计单元,可以是库房也可以是临床科室.'
			+ ' 仅勾选"转入"时按转入数量绝对值统计, 同时勾选其他选项时(比如勾选转出)则按代数和统计.'
			+ ' 勾选"根据全院消耗"时科室库存指采购科室, 否则指消耗科室.'
			+ '<br>2. 医嘱消耗包含医嘱撤销部分.'
			+ '<br>3. 勾选"不使用参考天数"时, 采购量=消耗量, 否则 采购量=(消耗量 / 时间间隔) * 参考天数 - 科室库存.</font>'
	};
	
	var HisListTab = new Ext.ux.FormPanel({
		title : '采购计划辅助制单(依据消耗)',
		labelWidth : 60,
		tbar : [SearchBT, '-', ClearBT,'-',SaveBT],
		items : [{
			xtype:'fieldset',
			title:'查询条件',
			style : 'padding:5px 0px 5px 5px;',
			layout : 'column',
			items:[col1,col2,col3,col5]
		}]
	});

	// 页面布局
	var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [HisListTab, {
				region: 'center',
				title: '明细',
				layout: 'fit',
				items: DetailGrid
			}]
		});
})