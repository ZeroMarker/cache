// /名称: 药品信息查询
// /描述: 药品信息查询
// /编写者：zhangdongmei
// /编写日期: 2012.06.15
var drugRowid = "";
var storeConRowId="";
var userId = session['LOGON.USERID'];
var LocId=session['LOGON.CTLOCID'];
var GroupId=session['LOGON.GROUPID'];
var gNewCatIdOther="";
var InciDescLookupGrid;
Ext.onReady(function() {
		Ext.QuickTips.init();
		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
		//============================DrugList.js====================================================================
		//==========函数==========================
		/**
		 * 返回方法
		 */
		function getDrugList(record) {
			if (record == null || record == "") {
				return;
			}
			var inciDr = record.get("InciDr");
			var InciCode=record.get("InciCode");
			var InciDesc=record.get("InciDesc");
			Ext.getCmp("M_InciDesc").setValue(InciDesc);
			Ext.getCmp("M_InciCode").setValue(InciCode);
			drugRowid=inciDr;
			Search();
		}

		//==========函数==========================
		
		//==========控件==========================
		// 药品编码
		var M_InciCode = new Ext.form.TextField({
			fieldLabel : '药品编码',
			id : 'M_InciCode',
			name : 'M_InciCode',
			anchor : '90%',
			width : 150,
			valueNotFoundText : '',
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						Search();
					}
				}
			}
		});
		var showshow=0
		var M_InciDesc = new Ext.form.TextField({
			fieldLabel : '药品名称',
			id : 'M_InciDesc',
			name : 'M_InciDesc',
			anchor : '90%',
			width : 150,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						/*
						if (document.getElementById('bodyLookupComponetId').innerHTML!=""){
							if (document.getElementById('bodyLookupComponetId').style.display!="none"){
								e.stopEvent();
								e.preventDefault();
								e.stopPropagation();
								return false;
							}
						}*/
						var stktype = Ext.getCmp("M_StkGrpType").getValue();
						var allCatGrpFlag=(stktype=="")?"Y":"";
						GetPhaOrderLookUp(field.getValue(), stktype, App_StkTypeCode, "", "", "0", "",getDrugList,"",allCatGrpFlag);
					}
				}
			}
		})
		
		// 药品别名
		var M_GeneName = new Ext.form.TextField({
			fieldLabel : '药品别名',
			id : 'M_GeneName',
			name : 'M_GeneName',
			anchor : '90%',
			width : 150,
			valueNotFoundText : '',
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						Search();
					}
				}
			}
		});

		// 药品类组
		var M_StkGrpType=new Ext.ux.StkGrpComboBox({
			fieldLabel : '类　　组', 
			id : 'M_StkGrpType',
			name : 'M_StkGrpType',
			StkType:App_StkTypeCode,     //标识类组类型
			anchor:'90%',
			//LocId:LocId,
			UserId:UserId,
			listeners:{
				select:function(){
					M_StkCat.setValue('');
					M_StkCat.setRawValue('');
				}
			}
		}); 
		// 库存分类
		var M_StkCat = new Ext.ux.ComboBox({
			fieldLabel : '库存分类',
			id : 'M_StkCat',
			name : 'M_StkCat',
			store : StkCatStore,
			valueField : 'RowId',
			displayField : 'Description',
			params:{StkGrpId:'M_StkGrpType'}
		});

		// 药学大类
		var M_PhcCat = new Ext.ux.ComboBox({
			fieldLabel : '药学大类',
			id : 'M_PhcCat',
			name : 'M_PhcCat',
			store : PhcCatStore,
			valueField : 'RowId',
			displayField : 'Description',
			filterName:'PhccDesc'
		});

		M_PhcCat.on('change', function() {
			Ext.getCmp('M_PhcSubCat').setValue("");
			Ext.getCmp('M_PhcMinCat').setValue("");
		});
		
		// 药学子类
		var M_PhcSubCat = new Ext.ux.ComboBox({
			fieldLabel : '药学子类',
			id : 'M_PhcSubCat',
			name : 'M_PhcSubCat',
			store : PhcSubCatStore,
			valueField : 'RowId',
			displayField : 'Description',
			params:{PhcCatId:'M_PhcCat'}
		});

		M_PhcSubCat.on('change', function() {
			Ext.getCmp('M_PhcMinCat').setValue("");
		});
		
		// 药学小类
		var M_PhcMinCat = new Ext.ux.ComboBox({
			fieldLabel : '药学小类',
			id : 'M_PhcMinCat',
			name : 'M_PhcMinCat',
			store : PhcMinCatStore,
			valueField : 'RowId',
			displayField : 'Description',
			params:{PhcSubCatId:'M_PhcSubCat'}
		});
		
var PHCCATALLOTH = new Ext.form.TextField({
	fieldLabel : '药学分类',
	id : 'PHCCATALLOTH',
	name : 'PHCCATALLOTH',
	anchor : '90%',
	readOnly : true,
	valueNotFoundText : '',
	disabled:true
});
function GetAllCatNew(catdescstr,newcatid){
	//if ((catdescstr=="")&&(newcatid=="")) {return;}
	Ext.getCmp("PHCCATALLOTH").setValue(catdescstr);
	gNewCatIdOther=newcatid;	
}

var PHCCATALLOTHButton = new Ext.Button({
	id:'PHCCATALLOTHButton',
	text : '药学分类',
	handler : function() {	
		PhcCatNewSelect(gNewCatIdOther,GetAllCatNew)

    }
});

var PHCCATClearButton = new Ext.Button({
	id:'PHCCATClearButton',
	text : '清空',
	handler : function() {	
		Ext.getCmp("PHCCATALLOTH").setValue("");
		gNewCatIdOther=""
		

    }
});
		

		// 全部
		var M_AllFlag = new Ext.form.Checkbox({
			fieldLabel : '全部',
			id : 'M_AllFlag',
			name : 'M_AllFlag',
			anchor : '90%',
			width : 150,
			checked : false
		});
		var M_DateFrom = new Ext.ux.DateField({
			fieldLabel : '开始日期',
			text:'开始日期',
			id : 'M_DateFrom',
			name : 'M_DateFrom',
			value:'',
			hidden:true
		});
		var M_DateFromText=new Ext.Toolbar.TextItem({
			id: 'M_DateFromText',
			text:'开始日期:',
			allowBlank:true,
			hidden:true
		});
		var M_DateTo = new Ext.ux.DateField({
			fieldLabel : '结束日期',
			text:'结束日期',
			id : 'M_DateTo',
			name : 'M_DateTo',
			value:'',
			hidden:true
		});
		var M_DateToText=new Ext.Toolbar.TextItem({
			id: 'M_DateToText',
			text:'结束日期:',
			allowBlank:true,
			hidden:true
		});

		//药品在用条件
		var InciUseConditionStore = new Ext.data.SimpleStore({
			fields : ['RowId', 'Description'],
			data : [['OnlyUse', '在用药品'], ['NewAdd','新增药品'],['OnlyNotUse', '停用药品'], ['ArcStop', '医嘱项截止'],["All","全　　部"]]
		});
		var InciUseCondition = new Ext.form.ComboBox({
				fieldLabel : '药品状态',
				id : 'InciUseCondition',
				name : 'InciUseCondition',
				store : InciUseConditionStore,
				valueField : 'RowId',
				displayField : 'Description',
				mode : 'local',
				allowBlank : true,
				triggerAction : 'all',
				selectOnFocus : true,
				forceSelection : true,
				anchor:'90%',  
				listeners : {
		            'select' : function(e) {
			            var tbarvisible=false;
			            if ((e.value=="NewAdd")||(e.value=="ArcStop")){tbarvisible=true}
				        Ext.getCmp('M_DateFrom').setVisible(tbarvisible);
			            Ext.getCmp('M_DateFromText').setVisible(tbarvisible);
			            Ext.getCmp('M_DateTo').setVisible(tbarvisible);
			            Ext.getCmp('M_DateToText').setVisible(tbarvisible);
		            }
    }
			});
		Ext.getCmp("InciUseCondition").setValue("OnlyUse");
		//==========控件==========================

		//配置数据源
		var DspPhaUrl = 'dhcst.druginfomaintainaction.csp';
		var proxy= new Ext.data.HttpProxy({url:DspPhaUrl+'?actiontype=GetItm',method:'POST'});

	
		// 指定列参数
		var fields = ["InciRowid", "InciCode", "InciDesc", "Spec", "Manf","PurUom", "Sp", "BUom", "BillUom", "Form", "GoodName","GenericName", "StkCat", "PhcCat", "PhcSubCat", "PhcMinCat","NotUseFlag","PhaCatAllDesc","ArcItemCat","OrderCat","Rp","InstrDesc","FreqDesc","PoisonDesc","ItmRemark","MaxSp","CountryBasicFlag","ProvinceBasicFlag","AntiFlag","InHosFlag","ImportFlag","CodexFlag","DrugUseInfo","OutUomDesc","InUomDesc"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			pageSize:30,
			//id : "InciRowid",
			fields : fields
		});
	
		// 数据集
		var DrugInfoStore = new Ext.data.Store({
			proxy : proxy,
			reader : reader,
			remoteSort: true
		});


		// 添加排序方式
		//DrugInfoStore.setDefaultSort('InciRowid', 'ASC');
	
		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '点击查询',
			iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
				Search();
			}
		});
		function Search(){
				var inciDesc = Ext.getCmp("M_InciDesc").getValue();
				var inciCode = Ext.getCmp("M_InciCode").getValue();
				var alias = Ext.getCmp("M_GeneName").getValue();
				var stkCatId = Ext.getCmp("M_StkCat").getValue();
				var PhcCatId = Ext.getCmp("M_PhcCat").getValue();
				var PhcSubCatId = Ext.getCmp("M_PhcSubCat").getValue();
				var PhcMinCatId = Ext.getCmp("M_PhcMinCat").getValue();
				var StkGrpType = Ext.getCmp("M_StkGrpType").getValue();
				var allFlag = (Ext.getCmp("M_AllFlag").getValue()==true?'Y':'N');
				var InciUseCondition=Ext.getCmp("InciUseCondition").getValue();
				var InciStartDate=Ext.getCmp("M_DateFrom").getValue();
				if (InciStartDate!=""){InciStartDate=InciStartDate.format('Y-m-d').toString();}
				var InciEndDate=Ext.getCmp("M_DateTo").getValue();
				if (InciEndDate!=""){InciEndDate=InciEndDate.format('Y-m-d').toString();}
				if (InciUseCondition=="All"){allFlag="Y"}
				//药学大类id^药学子类id^药学更小分类id^类组id^药学多级分类id^药品状态
				var others = ""+"^"+""+"^"+""+"^"+StkGrpType+"^"+gNewCatIdOther+"^"+InciUseCondition+"^"+InciStartDate+"^"+InciEndDate
				if ((inciDesc == "")&&(inciCode == "")&& (alias =="")&& (stkCatId == "")&&(StkGrpType=="")&&(others=="^^^^^^^")) {
					Msg.info("warning", "请选择查询条件!");
					return false;
				}

				var Params=inciDesc+RowDelim+inciCode+RowDelim+alias+RowDelim+stkCatId+RowDelim+allFlag+RowDelim+others ;
				DrugInfoStore.setBaseParam('Params',Params);
				DrugInfoStore.load({
					params:{start:0,limit:StatuTabPagingToolbar.pageSize},			
					callback : function(r,options, success) {					//Store异常处理方法二
						if(success==false){
		 					Ext.MessageBox.alert("查询错误",DrugInfoStore.reader.jsonData.Error);  
		 				}         				
					}
				});	
		}
		// 清空按钮
		var ClearBT = new Ext.Toolbar.Button({
			text : '清屏',
			tooltip : '点击清屏',
			width : 70,
			height : 30,
			iconCls : 'page_clearscreen',
			handler : function() {
				Ext.getCmp("M_DateFrom").setValue("");
				Ext.getCmp("M_DateTo").setValue("");
				M_InciCode.setValue("");
				M_InciDesc.setValue("");
				M_StkGrpType.setValue("");
				M_StkCat.setValue("");
				M_PhcCat.setValue("");
				M_PhcSubCat.setValue("");
				M_PhcMinCat.setValue("");
				M_StkGrpType.setRawValue("");
				M_StkCat.setRawValue("");
				M_PhcCat.setRawValue("");
				M_PhcSubCat.setRawValue("");
				M_PhcMinCat.setRawValue("");
				M_GeneName.setValue("");
				M_AllFlag.setValue(false);
				DrugInfoGrid.getStore().removeAll();
				DrugInfoGrid.getView().refresh();
			    Ext.getCmp("PHCCATALLOTH").setValue("");
				gNewCatIdOther=""
				Ext.getCmp("InciUseCondition").setValue("OnlyUse");
				Ext.getCmp('M_DateFrom').setVisible(false);
				Ext.getCmp('M_DateFromText').setVisible(false);
				Ext.getCmp('M_DateTo').setVisible(false);
				Ext.getCmp('M_DateToText').setVisible(false);
				drugRowid="";
				DrugInfoStore.setBaseParam('Params',"");
				DrugInfoStore.load({
					params:{start:0,limit:0},			
					callback : function(r,options, success) {					
						if(success==false){
		 					Ext.MessageBox.alert("查询错误",DrugInfoStore.reader.jsonData.Error);  
		 				}         				
					}
				});	
			}
		});
		// 另存按钮
		var SaveAsBT = new Ext.Toolbar.Button({
					text : '另存',
					tooltip : '另存为Excel',
					iconCls : 'page_export',
					width : 70,
					height : 30,
					handler : function() {
						ExportAllToExcel(DrugInfoGrid);

					}
				});
		var nm = new Ext.grid.RowNumberer();
			
		var DrugInfoCm = new Ext.grid.ColumnModel([nm, 
			{
				header : "库存项id",
				dataIndex : 'InciRowid',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true,
				hideable : false
			}, {
				header : "代码",
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '名称',
				dataIndex : 'InciDesc',
				width : 250,
				align : 'left',
				sortable : true
			}, {
				header : "规格",
				dataIndex : 'Spec',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "厂商",
				dataIndex : 'Manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "售价(入库单位)",
				dataIndex : 'Sp',
				width : 100,
				align : 'right',				
				sortable : true
			}, {
				header : "进价(入库单位)",
				dataIndex : 'Rp',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "基本单位",
				dataIndex : 'BUom',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '入库单位',
				dataIndex : 'PurUom',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : "计价单位",
				dataIndex : 'BillUom',
				width : 80,
				align : 'left',
				sortable : true,
				hidden:true
			}, {
				header : "门诊发药单位",
				dataIndex : 'OutUomDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "住院发药单位",
				dataIndex : 'InUomDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "剂型",
				dataIndex : 'Form',
				width : 60,
				align : 'left',
				sortable : true
			}, {
				header : "商品名",
				dataIndex : 'GoodName',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "处方通用名",
				dataIndex : 'GenericName',
				width : 130,
				align : 'left',
				sortable : true
			}, {
				header : "库存分类",
				dataIndex : 'StkCat',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "药学大类",
				dataIndex : 'PhcCat',
				width : 150,
				align : 'left',
				sortable : true,
				hidden:true
			}, {
				header : "药学子类",
				dataIndex : 'PhcSubCat',
				width : 150,
				align : 'left',
				sortable : true,
				hidden:true
			}, {
				header : "药学小类",
				dataIndex : 'PhcMinCat',
				width : 150,
				align : 'left',
				sortable : true,
				hidden:true
			}, {
				header : "药学分类",
				dataIndex : 'PhaCatAllDesc',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : "医嘱子类",
				dataIndex : 'ArcItemCat',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "医嘱大类",
				dataIndex : 'OrderCat',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "用法",
				dataIndex : 'InstrDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "频次",
				dataIndex : 'FreqDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "管制分类",
				dataIndex : 'PoisonDesc',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "批准文号",
				dataIndex : 'ItmRemark',
				width : 150,
				align : 'left',
				sortable : false
			}, {
				header : "最高售价",
				dataIndex : 'MaxSp',
				width : 70,
				align : 'right',
				sortable : false
			}, {
				header : "进口标志",
				dataIndex : 'ImportFlag',
				width : 80,
				align : 'center',
				sortable : true
			}, {
				header : "用药说明",
				dataIndex : 'DrugUseInfo',
				width : 150,
				align : 'left',
				sortable : false
			}, {
				header : "国家基本药物",
				dataIndex : 'CountryBasicFlag',
				width : 80,
				sortable : true,
				align : 'center',
				renderer : function(v, p, record) {
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col' + (((v == 'Y') || (v == true)) ? '-on': '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
				}
			}, {
				header : "省基本药物",
				dataIndex : 'ProvinceBasicFlag',
				width : 80,
				sortable : true,
				align : 'center',
				renderer: function(v, p, record) {
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col' + (((v == 'Y') || (v == true)) ? '-on': '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
				}
			}, {
				header : "抗菌药",
				dataIndex : 'AntiFlag',
				width : 80,
				sortable : true,
				align : 'center',
				renderer: function(v, p, record) {
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col' + (((v == 'Y') || (v == true)) ? '-on': '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
				}
			}, {
				header : "本院药品目录",
				dataIndex : 'InHosFlag',
				width : 80,
				sortable : true,
				align : 'center',
				renderer: function(v, p, record) {
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col' + (((v == 'Y') || (v == true)) ? '-on': '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
				}
			}, {
				header : "中国药典标志",
				dataIndex : 'CodexFlag',
				width : 80,
				sortable : true,
				align : 'center',
				renderer: function(v, p, record) {
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col' + (((v == 'Y') || (v == true)) ? '-on': '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
				}
			}, {
				header : "不可用",
				dataIndex : 'NotUseFlag',
				width : 45,
				align : 'center',
				renderer: function(v, p, record) {
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col' + (((v == 'Y') || (v == true)) ? '-on': '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
				},
				sortable : true
			}
		]);
		DrugInfoCm.defaultSortable = true;
		
				var StatuTabPagingToolbar = new Ext.PagingToolbar({
					store : DrugInfoStore,
					pageSize : 30,
					displayInfo : true,
					displayMsg : '当前记录 {0} -- {1} 条 共 {2} 条记录',
					emptyMsg : "No results to display",
					prevText : "上一页",
					nextText : "下一页",
					refreshText : "刷新",
					lastText : "最后页",
					firstText : "第一页",
					beforePageText : "当前页",
					afterPageText : "共{0}页",
					emptyMsg : "没有数据"
				});
				
		var DrugInfoGrid = new Ext.grid.GridPanel({
			id:'DrugInfoGrid',
			region:'center',
			//height:420,
			//width : 495,
			autoScroll:true,
			cm:DrugInfoCm,
			store:DrugInfoStore,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({singleSelect:false}),
			loadMask : true,
			bbar:StatuTabPagingToolbar		
		});
	
		var HospPanel = InitHospCombo('ARC_ItmMast',function(combo, record, index){
			HospId = this.value; 
			DrugInfoStore.reload();
		});

		var HisListTab = new Ext.form.FormPanel({
			height:DHCSTFormStyle.FrmHeight(3),
			labelWidth:60,
			labelAlign : 'right',
			title:'药品信息查询',
			frame : true,
			autoScroll : false,
			region : 'north',	
			tbar : [SearchBT, '-', ClearBT,'-',SaveAsBT,'-',M_DateFromText,M_DateFrom,M_DateToText,M_DateTo],
			items:[{
				xtype:'fieldset',
				title:'查询条件',
				layout: 'column',    // Specifies that the items will now be arranged in columns
				style:DHCSTFormStyle.FrmPaddingV,	
				items : [{ 				
					columnWidth: 0.3,
	            	xtype: 'fieldset',
	            	//labelWidth: 60,	
	            	defaults: {width: 200, border:false},    // Default config options for child items
	            	defaultType: 'textfield',
	            	autoHeight: true,
	            	
	            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
	            	border: false,
	            	//style: {
	                //	"margin-left": "10px", // when you add custom margin in IE 6...
	                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
	            	//},
	            	items: [M_InciCode,M_InciDesc,M_GeneName]
					
				}, {
					columnWidth: 0.3,
	            	xtype: 'fieldset',
	            	//labelWidth: 60,	
	            	defaults: {width: 180, border:false},    // Default config options for child items
	            	defaultType: 'textfield',
	            	autoHeight: true,
	            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
	            	border: false,				
					items : [M_StkGrpType,M_StkCat,InciUseCondition]
				}, {
					columnWidth: 0.4,
	            	xtype: 'fieldset',
	            	//labelWidth: 60,	
	            	defaults: {width: 295, border:false},    // Default config options for child items
	            	defaultType: 'textfield',
	            	autoHeight: true,
	            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
	            	border: false,				
					items : [{xtype:'compositefield',items:[PHCCATALLOTH,PHCCATALLOTHButton,PHCCATClearButton]}]
				}]			
			}]			
		});
		
		
		/***
		**添加右键菜单,zdm,2012-01-04***
		**/
		/*
		DrugInfoGrid.addListener('rowcontextmenu', rightClickFn);//右键菜单代码关键部分 
		var rightClick = new Ext.menu.Menu({ 
			id:'rightClickCont', 
			items: [ 
				{ 
					id: 'mnuInciAlias', 
					handler: editIncAliasInfo, 
					text: '库存项别名' 
				},{ 
					id: 'mnuArcAlias', 
					handler: editArcAliasInfo, 
					text: '医嘱项别名' 
				},{ 
					id: 'mnuDoseEquiv', 
					handler: editDoseEquivInfo, 
					text: '等效数量' 
				}
			] 
		}); 
		*/
		//======Grid点击事件===================================
		
		//RefreshGridColSet(DrugInfoGrid,"DHCST.DrugQuery");   //根据自定义列设置重新配置列             
		
		var viewport = new Ext.Viewport({
            layout: 'border',           
            title: '药品列表',
			items:[
				{
					region:'north',
					height:'500px',
					items:[HospPanel,HisListTab]
				},DrugInfoGrid
			]
        });
       
    
})
