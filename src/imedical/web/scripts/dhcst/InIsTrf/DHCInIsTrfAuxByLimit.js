// /名称: 库存转移单辅助制单（依据请求方库存上下限）
// /描述: 库存转移单辅助制单（依据请求方库存上下限）
// /编写者：zhangdongmei
// /编写日期: 2012.07.25

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];

	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	// 请求部门
	var RequestPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : $g('请求部门'),
				id : 'RequestPhaLoc',
				name : 'RequestPhaLoc',
				anchor : '90%',				
				emptyText : $g('请求部门...'),
				defaultLoc:''
			});

	// 供给部门
	var SupplyPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : $g('供给部门'),
				id : 'SupplyPhaLoc',
				name : 'SupplyPhaLoc',
				anchor : '90%',				
				emptyText : $g('供给部门...'),
				groupId:session['LOGON.GROUPID'],
				listeners : {
					'select' : function(e) {
						var SelLocId=Ext.getCmp('SupplyPhaLoc').getValue();//add wyx 根据选择的科室动态加载类组
						StkGrpType.getStore().removeAll();
						StkGrpType.getStore().setBaseParam("locId",SelLocId)
						StkGrpType.getStore().setBaseParam("userId",userId)
						StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
						StkGrpType.getStore().load();
						GetParam(e.value);	//修改供给科室后,以供给科室配置为准
					}
				}
			});
	
	// 补货标准取整比例
	var RepLevFac =new Ext.form.NumberField({
			fieldLabel : $g('补货标准取整比例'),
			id : 'RepLevFac',
			name : 'RepLevFac',
			anchor : '90%',
			width : 120
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
	
	// 查询按钮
	var SearchBT = new Ext.Toolbar.Button({
				text : $g('查询'),
				tooltip :$g( '点击查询'),
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
		var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
		if (supplyphaLoc == undefined || supplyphaLoc.length <= 0) {
			Msg.info("warning", $g("请选择供给部门!"));
			return;
		}
		var requestphaLoc = Ext.getCmp("RequestPhaLoc").getValue();
		if (requestphaLoc == undefined || requestphaLoc.length <= 0) {
			Msg.info("warning", $g("请选择请求部门!"));
			return;
		}
		if (supplyphaLoc == requestphaLoc) {
			Msg.info("warning", $g("选择的供给部门和请求部门一致，请重新选择!"));
			return;
		}
		var fac =  Ext.getCmp("RepLevFac").getValue();
		var stkgrp=Ext.getCmp("StkGrpType").getValue();
		var ListParam=supplyphaLoc+'^'+requestphaLoc+'^'+fac+'^'+stkgrp;
		DetailStore.load({params:{start:0, limit:999,ParamStr:ListParam}});
	}

	// 清空按钮
	var ClearBT = new Ext.Toolbar.Button({
				text : $g('清屏'),
				tooltip :$g( '点击清屏'),
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
		Ext.getCmp("RequestPhaLoc").setValue("");
		Ext.getCmp("SupplyPhaLoc").setValue("");
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}

	// 保存按钮
	var SaveBT = new Ext.Toolbar.Button({
				text :$g( '保存'),
				tooltip : $g('点击保存'),
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {
					save();
				}
			});
			// 单位
	var CTUom = new Ext.form.ComboBox({
				fieldLabel : $g('单位'),
				id : 'CTUom',
				name : 'CTUom',
				anchor : '90%',
				width : 120,
				store : CTUomStore,
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : false,
				triggerAction : 'all',
				emptyText : $g('单位...'),
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
				var ReqStkQty=record.get("curqty");
				var DirtyQty=record.get("ResQty");
				var AvaQty=record.get("AvaQty");
				var RepQty=record.get("repqty");
				var LevQty=record.get("levelQty");
				var MaxQty=record.get("maxQty");
				var MinQty=record.get("minQty");
				if (value == undefined || value.length <= 0) {
					return;
				} else if (TrUom == value) {
					return;
				} else if (value==BUom) {     //新选择的单位为基本单位，原显示的单位为大单位
					record.set("sp", Sp/ConFac);
					record.set("stkQty", StkQty*ConFac);
					record.set("curqty", ReqStkQty*ConFac);
					record.set("ResQty", DirtyQty*ConFac);
					record.set("AvaQty", AvaQty*ConFac);
					record.set("repqty", RepQty*ConFac);
					record.set("levelQty", LevQty*ConFac);
					record.set("maxQty", MaxQty*ConFac);
					record.set("minQty", MinQty*ConFac);
				} else{  //新选择的单位为大单位，原先是单位为小单位
					record.set("sp", Sp*ConFac);
					record.set("stkQty", StkQty/ConFac);
					record.set("curqty", ReqStkQty/ConFac);
					record.set("ResQty", DirtyQty/ConFac);
					record.set("AvaQty", AvaQty/ConFac);
					record.set("repqty", RepQty/ConFac);
					record.set("levelQty", LevQty/ConFac);
					record.set("maxQty", MaxQty*ConFac);
					record.set("minQty", MinQty*ConFac);
				}
				record.set("pUom", combo.getValue());
	});
	
	/**
	 * 生成转移单
	 */
	function save() {
		//供应科室RowId^请求科室RowId^库存转移请求单RowId^出库类型RowId^完成标志^单据状态^制单人RowId^类组RowId^库存类型^备注
		var inItNo = '';
		var supplyPhaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
		if(supplyPhaLoc==""){
			Msg.info("warning",$g("请选择供给部门!"));
			return;
		}
		var requestPhaLoc = Ext.getCmp("RequestPhaLoc").getValue();
		if(requestPhaLoc==""){
			Msg.info("warning",$g("请选择请求部门!"));
			return;
		}
		var reqid='';
		var operatetype = '';	
		var Complete='N';
		var Status=10;
		var StkGrpId = Ext.getCmp("StkGrpType").getValue();
		var StkType = App_StkTypeCode;					
		var remark = '';
		
		var MainInfo = supplyPhaLoc + "^" + requestPhaLoc + "^" + reqid + "^" + operatetype + "^"
				+ Complete + "^" + Status + "^" + userId + "^"+StkGrpId+"^"+StkType+"^"+remark;
		//明细id^批次id^数量^单位^请求明细id^备注
		var ListDetail="";
		var rowCount = DetailGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = DetailStore.getAt(i);					
			var Initi = '';
			var Inclb = rowData.get("INCLB");
			var Qty = rowData.get("batTraQty");
			if(Qty==0){
				continue;
			}
			var UomId = rowData.get("pUom");
			var ReqItmId = '';
			var Remark ='';
			
			var str = Initi + "^" + Inclb + "^"	+ Qty + "^" + UomId + "^"
					+ ReqItmId + "^" + Remark;	
			if(ListDetail==""){
				ListDetail=str;
			}
			else{
				ListDetail=ListDetail+xRowDelim()+str;
			}				
		}
		if(ListDetail==""){
			Msg.info("warning",$g("没有需要保存的数据!"));
			return;
		}
		var url = DictUrl
				+ "dhcinistrfaction.csp?actiontype=Save";
		Ext.Ajax.request({
					url : url,
					params:{Rowid:'',MainInfo:MainInfo,ListDetail:ListDetail},
					method : 'POST',
					waitMsg : $g('处理中...'),
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// 刷新界面
							var InitRowid = jsonData.info;
							Msg.info("success", $g("保存成功!"));
							// 跳转到出库制单界面
							window.location.href='dhcst.dhcinistrf.csp?Rowid='+InitRowid+'&QueryFlag=1';

						} else {
							var ret=jsonData.info;
							if(ret==-99){
								Msg.info("error", $g("加锁失败,不能保存!"));
							}else if(ret==-2){
								Msg.info("error", $g("生成出库单号失败,不能保存!"));
							}else if(ret==-1){
								Msg.info("error", $g("保存出库单失败!"));
							}else if(ret==-5){
								Msg.info("error", $g("保存出库单明细失败!"));
							}else {
								Msg.info("error", $g("部分明细保存不成功：")+ret);
							}
							
						}
					},
					scope : this
				});
		
	}
	
			/**
	 * 删除选中行药品
	 */
	function deleteDetail() {
		
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", $g("没有选中行!"));
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
				+ 'dhcinistrfaction.csp?actiontype=QueryDetailForTransByLim';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = [ "inci","code","desc", "pUom", "pUomDesc", "batTraQty","manf",
			 "batNo", "expDate", "stkQty","INCLB","sp","sbDesc", "oritrqty", "ResQty", "AvaQty",
			 "curqty","repqty","levelQty","maxQty","minQty","BUomId","Fac"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "INCLB",
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
	
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
				header : $g("药品Id"),
				dataIndex : 'inci',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g('药品代码'),
				dataIndex : 'code',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g('药品名称'),
				dataIndex : 'desc',
				width : 220,
				align : 'left',
				sortable : true
			}, {
				header : $g("批次Id"),
				dataIndex : 'INCLB',
				width : 180,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("批号"),
				dataIndex : 'batNo',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : $g("效期"),
				dataIndex : 'expDate',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : $g("生产企业"),
				dataIndex : 'manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : $g("转移数量"),
				dataIndex : 'batTraQty',
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
									Msg.info("warning", $g("转移数量不能为空!"));
									return;
								}
								if (qty <= 0) {
									Msg.info("warning", $g("转移数量不能小于或等于0!"));
									return;
								}
								var cell = DetailGrid.getSelectionModel()
										.getSelectedCell();
								var record = DetailGrid.getStore()
										.getAt(cell[0]);									
								var AvaQty = record.get("AvaQty");
								if (qty > AvaQty) {
									Msg.info("warning", $g("转移数量不能大于可用库存数量!"));
									return;
								}
							}
						}
					}
				})
			}, {
				header : $g("转移单位"),
				dataIndex : 'pUom',
				width : 80,
				align : 'left',
				sortable : true,
				renderer : Ext.util.Format.comboRenderer(CTUom), // pass combo instance to reusable renderer					
				editor : new Ext.grid.GridEditor(CTUom)
			}, {
				header : $g("售价"),
				dataIndex : 'sp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : $g("货位码"),
				dataIndex : 'sbDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g("批次库存"),
				dataIndex : 'stkQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : $g("占用数量"),
				dataIndex : 'ResQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : $g("可用数量"),
				dataIndex : 'AvaQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : $g("请求方总库存"),
				dataIndex : 'curqty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : $g("请求方标准库存"),
				dataIndex : 'repqty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : $g("参考库存"),
				dataIndex : 'levelQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : $g("库存上限"),
				dataIndex : 'maxQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : $g("库存下限"),
				dataIndex : 'minQty',
				width : 80,
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
				sm : new Ext.grid.CellSelectionModel({}),
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
				text: $g('删除' )
			}
		] 
	}); 
	
	//右键菜单代码关键部分 
	function rightClickFn(grid,rowindex,e){ 
		e.preventDefault(); 
		rightClick.showAt(e.getXY()); 
	}

	var HisListTab = new Ext.form.FormPanel({
		labelWidth: 60,	
		labelAlign : 'right',
		frame : true,		
		tbar : [SearchBT, '-', ClearBT,'-',SaveBT],
		items : [{
			layout: 'column',    // Specifies that the items will now be arranged in columns
			xtype:'fieldset',
			title:$g('查询条件'),
			style:DHCSTFormStyle.FrmPaddingV,
			defaults: {border:false},    // Default config options for child items
			items:[{ 				
				columnWidth: 0.3,
	        	xtype: 'fieldset',	  	        	
	        	items: [SupplyPhaLoc]				
			},{ 				
				columnWidth: 0.3,
	        	xtype: 'fieldset',	        	
	        	items: [RequestPhaLoc]
				
			},{ 				
				columnWidth: 0.2,
	        	xtype: 'fieldset',     	
	        	items: [StkGrpType]				
			},{ 				
				columnWidth: 0.2,
	        	xtype: 'fieldset',	
	        	labelWidth: 120,        	
	        	items: [RepLevFac]				
			}]
		}]
		
	});

	// 页面布局
	var mainPanel = new Ext.Viewport({
				layout : 'border',
				items : [            // create instance immediately
		            {
		            	title:$g('库存转移-依据请求方库存上下限'),
		                region: 'north',
		                height: DHCSTFormStyle.FrmHeight(1), // give north and south regions a height
		                layout: 'fit', // specify layout manager for items
		                items:HisListTab
		            }, {
		                region: 'center',
		                title: $g('待出库明细'),			               
		                layout: 'fit', // specify layout manager for items
		                items: DetailGrid       
		               
		            }
       			],
				renderTo : 'mainPanel'
			});
})