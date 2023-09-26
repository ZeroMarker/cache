// /名称: 库存报警-按上下限
// /描述:  库存报警-按上下限
// /编写者：zhangdongmei
// /编写日期: 2012.08.14
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrParam='';
	var gGroupId=session['LOGON.GROUPID'];
	var gUserId=session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	
	//统计科室
	var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '科室',
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor:'90%',
			groupId:gGroupId,
	        listeners : {
                'select' : function(e) {
					ReloadStkGrpType();
				}
			}
	});
	
		function ReloadStkGrpType(){
			var SelLocId=Ext.getCmp('PhaLoc').getValue();//add wyx 根据选择的科室动态加载类组
			StkGrpType.getStore().removeAll();
			StkGrpType.getStore().setBaseParam("locId",SelLocId)
			StkGrpType.getStore().setBaseParam("userId",UserId)
			StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
			StkGrpType.getStore().load();
		}	
		
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //标识类组类型
			anchor:'90%',
			width : 140,
			LocId:gLocId,
			UserId:gUserId,
			listeners:{
				change:function(field,newValue,oldValue){
					Ext.getCmp('DHCStkCatGroup').setValue('');
				}
			}
		}); 
		
		var DHCStkCatGroup = new Ext.ux.ComboBox({
					fieldLabel : '库存分类',
					id : 'DHCStkCatGroup',
					name : 'DHCStkCatGroup',
					anchor : '90%',
					width : 140,
					store : StkCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{StkGrpId:'StkGrpType'}
				});

		var UseFlag = new Ext.form.Checkbox({
					fieldLabel : '仅在用品种',
					id : 'UseFlag',
					name : 'UseFlag',
					anchor : '90%',
					width : 100,
					height : 10,
					checked : false
				});

		var StkBin = new Ext.ux.ComboBox({
					fieldLabel : '货位码',
					id : 'StkBin',
					name : 'StkBin',
					anchor : '90%',
					width : 140,
					//store : StkBinStore,
					store : LocStkBinStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{LocId:'PhaLoc'},
					filterName:'Desc'
				});
		var LimitFlagStore = new Ext.data.SimpleStore({
					fields : ['RowId', 'Description'],
					data : [['0', '全部'], ['1', '库存量高于上限'], ['2', '库存量低于下限']]
				});
		var LimitFlag = new Ext.form.ComboBox({
					fieldLabel : '报警状态',
					id : 'LimitFlag',
					name : 'LimitFlag',
					anchor:'90%',
					store : LimitFlagStore,
					triggerAction : 'all',
					mode : 'local',
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					editable : false,
					valueNotFoundText : ''
				});
		Ext.getCmp("LimitFlag").setValue("0");

				
		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
					text : '查询',
					tooltip : '点击查询',
					iconCls : 'page_find',
					width : 70,
					height : 30,
					handler : function() {
						searchData();
					}
				});

		/**
		 * 查询方法
		 */
		function searchData() {
			// 必选条件
			var phaLoc = Ext.getCmp("PhaLoc").getValue();
			if (phaLoc == null || phaLoc.length <= 0) {
				Msg.info("warning", "科室不能为空！");
				Ext.getCmp("PhaLoc").focus();
				return;
			}
	
			// 可选条件
			var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
			var DHCStkCatGroup = Ext.getCmp("DHCStkCatGroup").getValue();
			var UseFlag = (Ext.getCmp("UseFlag").getValue()==true?'Y':'N');
			var StkBin=Ext.getCmp("StkBin").getValue();
			var LimitFlag=Ext.getCmp("LimitFlag").getValue();
			gStrParam=phaLoc+"^"+StkGrpRowId+"^"+DHCStkCatGroup
			+"^"+StkBin+"^"+UseFlag+"^"+LimitFlag;
			
			var pageSize=StatuTabPagingToolbar.pageSize;
			StockQtyStore.load({params:{start:0,limit:pageSize,Params:gStrParam},
				callback : function(o,response,success) { 
					if (success == false){  
						Ext.MessageBox.alert("查询错误",StockQtyStore.reader.jsonData.Error);  
					}
				}
			});

		}
		function StkStatColorRenderer(val,meta,record){	
			if(val=="高于上限"){
				meta.css='classRed';
			}else if(val=="低于下限"){
				meta.css='classGrassGreen';
			}
			return val;	
		}		
		// 清空按钮
		var RefreshBT = new Ext.Toolbar.Button({
					text : '清屏',
					tooltip : '点击清屏',
					iconCls : 'page_clearscreen',
					width : 70,
					height : 30,
					handler : function() {
						clearData();
					}
				});

		/**
		 * 清空方法
		 */
		function clearData() {
			gStrParam='';
			SetLogInDept(PhaLoc.getStore(),'PhaLoc');
			Ext.getCmp("DHCStkCatGroup").setValue('');
			Ext.getCmp("UseFlag").setValue(false);
			Ext.getCmp("StkBin").setValue('');
			Ext.getCmp("LimitFlag").setValue(0);
			ReloadStkGrpType();
			StockQtyGrid.store.removeAll();
			StockQtyGrid.getView().refresh();
		}
		// 另存按钮
		var SaveAsBT = new Ext.Toolbar.Button({
					text : '另存',
					tooltip : '另存为Excel',
					iconCls : 'page_export',
					width : 70,
					height : 30,
					handler : function() {
						ExportAllToExcel(StockQtyGrid);
					}
				});	
		var PrintBT = new Ext.Toolbar.Button({
				id : "PrintBT",
				text : '打印',
				width : 70,
				height : 30,
				iconCls : 'page_print',
				handler : function() {
					var rowCount=StockQtyStore.getCount();
					if (rowCount ==0) {
						Msg.info("warning", "无可用打印数据!");
						return;
					}
					var tmpParam = StockQtyStore.lastOptions; 
					if (tmpParam && tmpParam.params) {
							var gStrParam=tmpParam.params.Params;  //与界面Grid数据参数保持一致,yunhaibao20160419
							var gStrParamArr=gStrParam.split("^");
							var phaLoc=gStrParamArr[0];
							var StkGrpRowId=gStrParamArr[1];
							var DHCStkCatGroup=gStrParamArr[2];
							var StkBin=gStrParamArr[3];
							var UseFlag=gStrParamArr[4];
							var sort="",dir="";
							if (StockQtyStore.sortInfo){
								sort=StockQtyStore.sortInfo.field;
								dir=StockQtyStore.sortInfo.direction;
							}
							if (sort==undefined){sort=""}
							if (dir==undefined){dir=""}
							var LocDesc=Ext.getCmp("PhaLoc").getRawValue();		
							var RQDTFormat=App_StkRQDateFormat+" "+App_StkRQTimeFormat;					
							var fileName="DHCST_LocItmStkQtyLimitWarn.raq&qPar="+sort+"^"+dir
							+"&Loc="+phaLoc+"&SCG="+StkGrpRowId+"&INCSC="+DHCStkCatGroup+"&StkBin="+StkBin+"&IncludeNotUseFlag="+UseFlag+"&User="+session['LOGON.USERID']
							+"&LocDesc="+LocDesc+"&UserName="+session['LOGON.USERNAME']+"&HospDesc="+App_LogonHospDesc+"&RQDTFormat="+RQDTFormat;
							DHCCPM_RQPrint(fileName)
					}	
				}
			});
		var nm = new Ext.grid.RowNumberer();
		var sm = new Ext.grid.CheckboxSelectionModel();
		var StockQtyCm = new Ext.grid.ColumnModel([nm, {
					header : "incil",
					dataIndex : 'incil',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '报警状态',
					dataIndex : 'stkStat',
					width : 75,
					align : 'center',
					sortable : true,
					renderer:StkStatColorRenderer
				}, {
					header : '代码',
					dataIndex : 'code',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "名称",
					dataIndex : 'desc',
					width : 200,
					align : 'left',
					sortable : true
				}, {
					header : "规格",
					dataIndex : 'spec',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "单位",
					dataIndex : 'stkUom',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "库存量",
					dataIndex : 'avaQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "库存上限",
					dataIndex : 'maxQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "库存下限",
					dataIndex : 'minQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "标准库存",
					dataIndex : 'repQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "厂商",
					dataIndex : 'manf',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : '库存分类',
					dataIndex : 'incscDesc',
					width : 150,
					align : 'left',
					sortable : true
				}]);
		StockQtyCm.defaultSortable = true;

		// 访问路径
		var DspPhaUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=jsLocItmStkQtyLimitWarn&start=&limit=';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ["incil", "inci", "code", "desc","spec", "manf", "maxQty", "minQty",
				"repQty", "avaQty", "incscDesc", "stkUom","stkStat"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "incil",
					fields : fields
				});
		// 数据集
		var StockQtyStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader,
					remoteSort:true
				});

		var StatuTabPagingToolbar = new Ext.PagingToolbar({
					store : StockQtyStore,
					pageSize : PageSize,
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
					emptyMsg : "没有数据",
					doLoad:function(C){
						var B={},
						A=this.getParams();
						B[A.start]=C;
						B[A.limit]=this.pageSize;
						B[A.sort]='desc';
						B[A.dir]='ASC';
						
						B['Params']=gStrParam;
						if(this.fireEvent("beforechange",this,B)!==false){
							this.store.load({params:B});
						}
					}
				});

		var StockQtyGrid = new Ext.grid.GridPanel({
					id:'StockQtyGrid',
					region : 'center',
					cm : StockQtyCm,
					store : StockQtyStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : new Ext.grid.CheckboxSelectionModel(),
					loadMask : true,
					bbar : StatuTabPagingToolbar
					/*,
					viewConfig:{getRowClass : function(record,rowIndex,rowParams,store){ 
						var StkQty=record.get("avaQty");
						var MaxQty=record.get("maxQty");
						var MinQty=record.get("minQty");
						if(parseFloat(StkQty)>MaxQty){
							return 'classRed';
						}else if(parseFloat(StkQty)<MinQty){
							return 'classGrassGreen';
						}					
                    }}*/
		});
		
	var HisListTab = new Ext.form.FormPanel({
			labelWidth : 60,
			region : 'north',
			title:"库存报警-按上下限",
			autoHeight : true,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			tbar : [SearchBT, '-', RefreshBT,'-',PrintBT,'-',SaveAsBT],		
		    items:[{
				layout : 'column',	
				title:'查询条件',	
				xtype: 'fieldset',
				defaults: { border:false},
				style:DHCSTFormStyle.FrmPaddingV,
				items : [{
							columnWidth:0.3,
							xtype: 'fieldset',
							items : [PhaLoc,StkBin]
						},{
							columnWidth:0.25,
							xtype: 'fieldset',
							items : [StkGrpType,DHCStkCatGroup]
						},{
							columnWidth:0.25,
							xtype: 'fieldset',
							labelWidth : 90,
							items : [UseFlag,LimitFlag]
						},{
							columnWidth:0.2,
							xtype: 'fieldset',
							labelWidth : 110,
							defaultType: 'textfield',
							defaults: {width: 80, border:false},    // Default config options for child items
							items : [{
								fieldLabel:'库存量高于上限',
								disabled:true,
								cls: 'my-background-Red'
							},{
								fieldLabel:'库存量低于下限',
								disabled:true,							
								cls: 'my-background-GrassGreen'
							}]
						}]
		    }]	
		});

		// 5.2.页面布局
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [ 
						{	
							region: 'north',		               
			                layout: 'fit', // specify layout manager for items
							height:DHCSTFormStyle.FrmHeight(2),
							items:HisListTab       			               
						}, {
			                region: 'center',
			                title: '明细',			               
			                layout: 'fit', // specify layout manager for items
			                items: StockQtyGrid       			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
	
})