// /名称: 采购计划辅助制单（依据库存上下限）
// /描述: 采购计划辅助制单（依据库存上下限）
// /编写者：zhangdongmei
// /编写日期: 2012.08.03

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];

	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
		// 订购部门
	var PurLoc = new Ext.ux.LocComboBox({
		fieldLabel : '采购部门',
		id : 'PurLoc',
		name : 'PurLoc',
		anchor : '90%',
		emptyText : '采购部门...',
		groupId:session['LOGON.GROUPID'],
		stkGrpId : 'StkGrpType'
	});
			
			// 补货标准取整比例
	var RepLevFac =new Ext.form.NumberField({
			fieldLabel : '补货标准取整比例',
			id : 'RepLevFac',
			emptyText:'0-1之间的小数',
			name : 'RepLevFac',
			anchor : '90%'
	});

	// 物资类组
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:App_StkTypeCode,     //标识类组类型
		LocId:session['LOGON.CTLOCID'],
		UserId:session['LOGON.USERID'],
		anchor : '90%'
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
		var fac =  Ext.getCmp("RepLevFac").getValue();
		var stkgrp=Ext.getCmp("StkGrpType").getValue();
		if (PurLoc == undefined || PurLoc.length <= 0) {
			Msg.info("warning", "请选择采购部门!");
			return;
		}
        if(fac<0||fac>1){
	        Msg.info("warning","标准补货比例应该是0-1之间的数!");
	        return;
	        } 
		//科室id,类组id,补货标准取整比例
		var ListParam=PurLoc+'^'+stkgrp+'^'+fac+'^'+userId;				
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
		var rowData = DetailStore.getAt(i);	
		var rowid = '';
		var incId = rowData.data["Inci"];
		var qty = rowData.data["Qty"];
		var ProPurQty = rowData.data["PurQty"];
		var uomId = rowData.data["PurUomId"];
		var vendorId = rowData.data["VenId"];
		var rp =rowData.data["Rp"];
		var manfId =rowData.data["ManfId"];
		var carrierId =rowData.data["CarrierId"];
		var reqLocId ='';
		var dataRow = rowid+"^"+incId+"^"+qty+"^"+uomId+"^"+vendorId+"^"+rp+"^"+manfId+"^"+carrierId+"^"+reqLocId+"^^^^"+ProPurQty;
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
		//Ext.getCmp("PurLoc").setValue("");
		Ext.getCmp("RepLevFac").setValue("");
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
				var PurUom = record.get("PurUomId");    //目前显示的采购单位
				var Rp = record.get("Rp");
				var StkQty = record.get("StkQty");
				var MaxQty=record.get("MaxQty");
				var MinQty=record.get("MinQty");
				var PurQty=record.get("PurQty");
				var RepQty=record.get("RepQty");
				var LevelQty=record.get("LevelQty");
				
				if (value == undefined || value.length <= 0) {
					return;
				} else if (PurUom == value) {
					return;
				} else if (value==BUom) {     //新选择的单位为基本单位，原显示的单位为大单位
					record.set("Rp", Rp/ConFac);
					record.set("StkQty", StkQty*ConFac);
					record.set("MaxQty", MaxQty*ConFac);
					record.set("MinQty", MinQty*ConFac);
					record.set("RepQty", RepQty*ConFac);
					record.set("LevelQty", LevelQty*ConFac);
					record.set("PurQty", PurQty*ConFac);
				} else{  //新选择的单位为大单位，原先是单位为小单位
					record.set("Rp", Rp*ConFac);
					record.set("StkQty", StkQty/ConFac);
					record.set("MaxQty", MaxQty/ConFac);
					record.set("MinQty", MinQty/ConFac);
					record.set("RepQty", RepQty/ConFac);
					record.set("LevelQty", LevelQty/ConFac);
					record.set("PurQty", PurQty/ConFac);
				}
				record.set("PurUomId", combo.getValue());
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
		
	}
	
	// 转移明细
	// 访问路径
	var DetailUrl =  DictUrl
				+ 'inpurplanaction.csp?actiontype=QueryLocItmForPurchByLim';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = [ "Inci","InciCode","InciDesc", "Spec","PurUomId", "PurUomDesc", "PurQty",
			 "VenDesc", "ManfDesc","StkQty","Rp","CarrierDesc", "MaxQty","MinQty","RepQty","LevelQty",
			 "BUomId","ConFac","VenId","ManfId","CarrierId","RepLev",{name:'Qty',convert:function(v,rec){return rec.PurQty;}},"ApcWarn"];
			
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				//totalProperty : "results",
				id : "Inci",
				fields : fields
			});
	
	// 数据集
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
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
				header : "建议采购量",
				dataIndex : 'PurQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "实际采购量",
				dataIndex : 'Qty',
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
				renderer : Ext.util.Format.comboRenderer2(CTUom,"PurUomId","PurUomDesc"), // pass combo instance to reusable renderer					
				editor : new Ext.grid.GridEditor(CTUom)
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
				header : '规格',
				dataIndex : 'Spec',
				width : 180,
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
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "库存上限",
				dataIndex : 'MaxQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "库存下限",
				dataIndex : 'MinQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "标准库存",
				dataIndex : 'RepQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "参考库存",
				dataIndex : 'LevelQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "补货标准",
				dataIndex : 'RepLev',
				width : 80,
				align : 'right',
				sortable : true
			},{
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
			}]);

	var DeleteItmBT=new Ext.Toolbar.Button({
		id:'DeleteItmBT',
		text:'删除一条',
		iconCls:'page_delete',
		handler:function(){
			deleteDetail();
		}
	});
	
	var DetailGrid = new Ext.grid.EditorGridPanel({
				region : 'center',
				title : '明细',
				tbar:[DeleteItmBT],
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				sm : new Ext.grid.CellSelectionModel({}),
				clicksToEdit : 1
			});
			
	DetailGrid.on('beforeedit',function(e){
		if(e.field=="PurUomId"){
			var uomid=e.record.get("PurUomId");
			var uomdesc=e.record.get("PurUomDesc");
			addComboData(CTUom.getStore(),uomid,uomdesc);
		}
	});
	
	var col1={
			columnWidth: 0.25,
        	xtype: 'fieldset',
        	items: [PurLoc]
		}
	var col2={ 				
			columnWidth: 0.2,
        	xtype: 'fieldset',
        	items: [StkGrpType,RepLevFac]
		}
	var HisListTab = new Ext.ux.FormPanel({
		title:'采购计划单制单-依据库存上下限',
		labelWidth: 60,
		tbar : [SearchBT, '-', ClearBT,'-',SaveBT],
		items : [{
			xtype:'fieldset',
			title:'查询条件',
			style : 'padding:5px 0px 0px 5px;',
			layout: 'column',
			defaults: {border:false},
			items:[col1,col2,{
					columnWidth:0.5,
					html:"<font size=2 color=blue>补货标准>=1,且补货标准取整比例不为空：建议采购量=补货标准*N,N=M+R" +
						"<br>M=(标准库存-科室库存)/补货标准，取整数部分" +
						"<br>((标准库存-科室库存)#补货标准)/补货标准<补货标准取整比例时，R=0,否则R=1,#代表取余" +
						"<br>补货标准<1,或补货标准取整比例为空，建议采购量=标准库存-科室库存</font>"
					}]
		}]
	});

	// 页面布局
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
				items : [HisListTab, DetailGrid],
				renderTo : 'mainPanel'
			});

})