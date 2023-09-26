// /名称: 采购计划辅助制单（依据库存上下限）
// /描述: 采购计划辅助制单（依据库存上下限）
// /编写者：zhangdongmei
// /编写日期: 2012.08.03

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var LocId=session['LOGON.CTLOCID']

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


	   // 药品招标
	    var ZBCombo=new Ext.ux.ZBComboBox({ 
			id : 'ZBComBoBox',
			name : 'ZBComBoBox',
			anchor : '90%'
		});


			// 补货标准取整比例
		var RepLevFac =new Ext.form.NumberField({
			fieldLabel : '补货标准取整比例',
			id : 'RepLevFac',
			emptyText:'0-1之间的小数',
			name : 'RepLevFac',
			anchor : '90%',
			enableKeyEvents:true,
			listeners:{
				'keyup':function(e){

					if(Ext.getCmp('RepLevFac').getRawValue()>1){
						Msg.info("warning", "只能录0-1之间的小数!");
                        Ext.getCmp('RepLevFac').setValue('');
					}
				}
		    }
	});

	// 药品类组
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:App_StkTypeCode,     //标识类组类型
		LocId:session['LOGON.CTLOCID'],
		UserId:session['LOGON.USERID'],
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
		//库存分类
        var stkCatId = Ext.getCmp('M_StkCat').getValue();
		var zbflagstr=Ext.getCmp("ZBComBoBox").getValue();
		if (zbflagstr=="")
		{
			zbflagstr=1;
		}
		if (PurLoc == undefined || PurLoc.length <= 0) {
			Msg.info("warning", "请选择采购部门!");
			return;
		}

		//科室id,类组id,补货标准取整比例
		var ListParam=PurLoc+'^'+stkgrp+'^'+fac+'^'+userId+"^"+zbflagstr+"^"+stkCatId;					
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
		var uomId = rowData.data["PurUomId"];
		var vendorId = rowData.data["VenId"];
		var rp =rowData.data["Rp"];
		var manfId =rowData.data["ManfId"];
		var carrierId =rowData.data["CarrierId"];
		var reqLocId ='';
		var prolocqty=rowData.data["PurQty"];
		var dataRow = rowid+"^"+incId+"^"+qty+"^"+uomId+"^"+vendorId+"^"+rp+"^"+manfId+"^"+carrierId+"^"+reqLocId+"^"+prolocqty;
		if (qty!=0) {
		if(data==""){
			data = dataRow;
		}else{
			data = data+xRowDelim()+dataRow;
		}
	   }
	}

	var zbflagstr=Ext.getCmp("ZBComBoBox").getValue();
	if (zbflagstr=="")
	{
		zbflagstr=1;
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
				tooltip : '点击清屏(Alt+C)',
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
		Ext.getCmp('M_StkCat').setValue("");
		Ext.getCmp('ZBComBoBox').setValue("");
		
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		ShowAllLocStkQtyWin("",DetailGrid,3,"","");
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

	
    
	var HelpBT = new Ext.Button({
		　　　　id:'HelpBtn',
				text : '帮助',
				width : 70,
				height : 30,
				renderTo: Ext.get("tipdiv"),
				iconCls : 'page_help'
				
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
	 * 删除选中行药品
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
				+ 'inpurplanaction.csp?actiontype=QueryLocItmForPurchByLim';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = [ "Inci","InciCode","InciDesc", "Spec","PurUomId", "PurUomDesc", "PurQty",
			 "VenDesc", "ManfDesc","StkQty","Rp","CarrierDesc", "MaxQty","MinQty","RepQty","LevelQty",
			 "BUomId","ConFac","VenId","ManfId","CarrierId","RepLev",{name:'Qty',convert:function(v,rec){return rec.PurQty;}},"ApcWarn","StkCatDesc"];
			
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
	
	//其他科室库存信息
	// 访问路径
	var AllLocStkUrl =  DictUrl
				+ 'inpurplanaction.csp?actiontype=GetAllLocStk&start=&limit=';
	// 通过AJAX方式调用后台数据
	var AllLocStkProxy = new Ext.data.HttpProxy({
				url : AllLocStkUrl,
				method : "POST"
			});
	// 指定列参数
	var AllLocStkFields = [ "Loc","Uom","StkQty","MaxQty","MinQty","RepQty"];
			
	// 支持分页显示的读取方式
	var AllLocStkReader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "Loc",
				fields : AllLocStkFields
			});
	var AllLocStkStore = new Ext.data.Store({
				proxy : AllLocStkProxy ,
				reader : AllLocStkReader
			});
	
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
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
				header : '药品名称',
				dataIndex : 'InciDesc',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : '库存分类',
				dataIndex : 'StkCatDesc',
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
								if (qty < 0) {
									Msg.info("warning", "采购数量不能小于0!");
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
	var GridColSetBT = new Ext.Toolbar.Button({
	text:'列设置',
    tooltip:'列设置',
    iconCls:'page_gear',
    //	width : 70,
    //	height : 30,
	handler:function(){
		GridColSet(DetailGrid,"DHCSTPURPLANBYLIM");
	}
    });

	
	var DetailGrid = new Ext.grid.EditorGridPanel({
				title : '',
				height : 200,
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				sm : new Ext.grid.CellSelectionModel({}),
				clicksToEdit : 1,
				tbar:[DeleteItmBT,'-',GridColSetBT]
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
        	items: [PurLoc,M_StkCat]			
		}
	var col2={ 				
			columnWidth: 0.25,
        	xtype: 'fieldset',        	
        	items: [StkGrpType,ZBCombo]			
		}			
	var col3={ 				
			columnWidth: 0.25,
        	xtype: 'fieldset',        	
        	items: [RepLevFac]			
		}
	var col4={ 				
			columnWidth: 0.4,
        	xtype: 'fieldset',        	
        	items: []		
		}
	var HisListTab = new Ext.form.FormPanel({
		labelWidth: 120,	
		labelAlign : 'right',
		autoHeight:true,
		frame : true,
		autoScroll : false,
		tbar : [SearchBT, '-', ClearBT,'-',SaveBT,'-',HelpBT],		
		items : [{
			xtype:'fieldset',
			title:'查询条件',
			style : DHCSTFormStyle.FrmPaddingV,
			layout: 'column',    // Specifies that the items will now be arranged in columns		
			defaults: {border:false},  
			items:[col1,col2,col3,col4]
			}]
		
	});

	// 页面布局
	var mainPanel = new Ext.Viewport({
				layout : 'border',
				items : [            // create instance immediately
		            {
		                region: 'north',
		                title:'采购计划单制单-依据库存上下限',
		                height: DHCSTFormStyle.FrmHeight(2), // give north and south regions a height
		                layout: 'fit', // specify layout manager for items
		                items:HisListTab
		            }, {
		                region: 'center',
		                title: '明细',			               
		                layout: 'fit', // specify layout manager for items
		                items: DetailGrid       
		               
		            }
       			],
				renderTo : 'mainPanel'
			});




	//-------------------Events-------------------//

    //设置Grid悬浮显示窗体
	//Creator:LiangQiang 2013-11-20
    DetailGrid.on('mouseover',function(e){
		
		var rowCount = DetailGrid.getStore().getCount();
		if (rowCount>0)
		{  
			var ShowInCellIndex=3;  //在第几列显示
			var index = DetailGrid.getView().findRowIndex(e.getTarget());
			var record = DetailGrid.getStore().getAt(index);
			if (record)
			{
				var desc=record.data.InciDesc;
				var inci=record.data.Inci;
				//alert(index+":"+desc+"^"+inci)
			}
	
			ShowAllLocStkQtyWin(e,DetailGrid,ShowInCellIndex,desc,inci);
		}

	},this,{buffer:200});



   /*给帮助按钮增加tip提示
   * LiangQiang 2013-11-21
   */
   new Ext.ToolTip({
        target: 'HelpBtn',
        anchor: 'buttom',
        width: 500,
        anchorOffset: 50,
		hideDelay : 9000,
        html: "<font size=3 color=blue>补货标准>=1,且补货标准取整比例不为空：建议采购量=补货标准*N,N=M+R" +  "      M=(标准库存-科室库存)/补货标准，取整数部分" +
				"((标准库存-科室库存)#补货标准)/补货标准<补货标准取整比例时，R=0,否则R=1,#代表取余" +"     补货标准<1,或补货标准取整比例为空，建议采购量=标准库存-科室库存</font>"
    });


   /*加载界面按钮快捷键
   * LiangQiang 2013-11-22
   */
    Ext.getCmp('HelpBtn').focus('',100); //初始化页面给某个元素设置焦点
   	var map = new Ext.KeyMap(document, [
	{
		key: [116], // F5
		fn: function(){ },
		//stopEvent: true,  //禁用
		scope: this
	},{
		key: [37,39,115], //方向键左,右,F4
		alt: true,   //Alt
		fn: function(){ },
		//stopEvent: true,
		scope: this
	}, {
		key: [82],  // ctrl + R
		ctrl: true, //Ctrl
		fn: function(){},
		//stopEvent: true,
		scope: this
	}, {
		key: [83],  // Alt + S  
		alt: true, 
		fn: function(){/*do anything*/},
		scope: this
	}, {
		key: [67],  // Alt + C  
		alt: true, 
		fn: function(){clearData();},
		scope: this
	}, {
		key: [81],  // Alt + Q
		alt: true, 
		fn: function(){},
		scope: this
	}, {
		key: [87],  // Alt + W
		alt: true, 
		fn: function(){},
		scope: this
	}, {
		key: [82],  // Alt + R
		alt: true, 
		fn: function(){},
		scope: this
	}, {
		key: [68],  // Alt + D
		alt: true, 
		fn: function(){},
		scope: this
	}, {
		key: [70],  // Alt + F
		alt: true, 
		fn: function(){},
		scope: this
	}, {
		key: [80],  // Alt + P
		alt: true, 
		fn: function(){},
		scope: this
	}]);
	map.enable();




})