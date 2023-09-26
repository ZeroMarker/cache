// /名称: 台账查询
// /描述: 台账查询
// /编写者：zhangdongmei
// /编写日期: 2012.08.09
var gNewCatId="";
var GridSelectWinType="";
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	//var LoginLocId = session['LOGON.COMMUNITYROWID'];   //DTHealth需要改一下
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    Ext.Ajax.timeout = 900000;
    /*
    Ext.getDoc().on("contextmenu", function(e){
	    e.stopEvent();
	});*/
    
   	if(gParamCommon.length<1){
		GetParamCommon();  //初始化公共参数配置 

	}
	ChartInfoAddFun();

	function ChartInfoAddFun() {

	//统计科室
	var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '科室',
			id : 'PhaLoc',
			name : 'PhaLoc',
			groupId:gGroupId,
	        listeners : {
	            'select' : function(e) {
	                 var SelLocId=Ext.getCmp('PhaLoc').getValue();//add wyx 根据选择的科室动态加载类组
	                 StkGrpType.getStore().removeAll();
	                 StkGrpType.getStore().setBaseParam("locId",SelLocId)
	                 StkGrpType.getStore().setBaseParam("userId",UserId)
	                 StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
	                 StkGrpType.getStore().load();
				}
			}
	});
		
	// 起始日期
	var StartDate = new Ext.ux.DateField({
			fieldLabel : '起始日期',
			id : 'StartDate',
			name : 'StartDate',
			anchor : '90%',
			width : 120,
			value : new Date()
		});

	// 结束日期
	var EndDate = new Ext.ux.DateField({
			fieldLabel : '结束日期',
			id : 'EndDate',
			name : 'EndDate',
			anchor : '90%',
			width : 120,
			value : new Date()
		});	
	
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			fieldLabel:'类　　组',
			StkType:App_StkTypeCode,     //标识类组类型
			LocId:gLocId,
			UserId:userId,
			anchor:'90%'
		});
	StkGrpType.on('change',function(){
		Ext.getCmp("DHCStkCatGroup").setValue("");
	});
		
	var DHCStkCatGroup = new Ext.ux.ComboBox({
			fieldLabel : '库存分类',
			id : 'DHCStkCatGroup',
			name : 'DHCStkCatGroup',
			anchor : '90%',
			width : 120,
			store : StkCatStore,
			valueField : 'RowId',
			displayField : 'Description',
			params:{StkGrpId:'StkGrpType'}
		});

	var InciDr = new Ext.form.TextField({
			fieldLabel : '药品RowId',
			id : 'InciDr',
			name : 'InciDr',
			anchor : '90%',
			width : 140,
			valueNotFoundText : ''
		});

	var ItmDesc = new Ext.form.TextField({
			fieldLabel : '药品名称',
			id : 'ItmDesc',
			name : 'ItmDesc',
			anchor : '90%',
			width : 160,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var StkGrp= Ext.getCmp("StkGrpType").getValue();
						GetPhaOrderInfo(field.getValue(),StkGrp);
						//GetPhaOrderInfo(field.getValue(),'');
					}
				}
			}
		});
				
	/**
	 * 调用药品窗体并返回结果
	 */
	function GetPhaOrderInfo(item, group) {
					
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, group, App_StkTypeCode, "", "", "", "",
					getDrugList);
		}
	}

	/**
	 * 返回方法
	*/
	function getDrugList(record) {
		if (record == null || record == "") {
			return;
		}
		var inciDr = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		;
		Ext.getCmp("ItmDesc").setValue(inciDesc);
		Ext.getCmp('InciDr').setValue(inciDr);			
		searchMainData();
		Ext.getCmp("ItmDesc").focus(true,1000);				
	}
	
	// 药学大类
	var PhcCat = new Ext.form.ComboBox({
			fieldLabel : '药学大类',
			id : 'PhcCat',
			name : 'PhcCat',
			anchor : '90%',
			width : 120,
			store : PhcCatStore,
			valueField : 'RowId',
			displayField : 'Description',
			allowBlank : true,
			triggerAction : 'all',
			selectOnFocus : true,
			forceSelection : true,
			minChars : 1,
			pageSize : 20,
			listWidth : 250,
			valueNotFoundText : '',
			enableKeyEvents : true,
			listeners : {
				'beforequery' : function(e) {
					refill(PhcCatStore, "PHCCat", Ext.getCmp('PhcCat')
									.getRawValue());
				}
			}
		});

var PHCCATALL = new Ext.form.TextField({
	fieldLabel : '药学分类',
	id : 'PHCCATALL',
	name : 'PHCCATALL',
	anchor : '90%',
	readOnly : true,
	valueNotFoundText : ''
});
function GetAllCatNew(catdescstr,newcatid){
	//if ((catdescstr=="")&&(newcatid=="")) {return;}
	Ext.getCmp("PHCCATALL").setValue(catdescstr);
	gNewCatId=newcatid;
	
	
}

var PHCCATALLButton = new Ext.Button({
	id:'PHCCATALLButton',
	text : '药学分类',
	handler : function() {	
		PhcCatNewSelect(gNewCatId,GetAllCatNew)

    }
});
	var PHCDFPhcDoDR = new Ext.ux.ComboBox({
					fieldLabel : '管制分类',
					id : 'PHCDFPhcDoDR',
					name : 'PHCDFPhcDoDR',
					store : PhcPoisonStore,
					valueField : 'RowId',
					displayField : 'Description'
				});
				
	// 根据输入值过滤
	function refill(store, type, filter) {
		var url = "";
		if (type == "PHCCat") {
			url = DictUrl + 'drugutil.csp?actiontype=PhcCat&PhccDesc='
					+ filter + '&start=0&limit=999';
		}
		store.removeAll();
		store.proxy = new Ext.data.HttpProxy({
					url : encodeURI(url)
				});
		store.reload({
					params : {
						start : 0,
						limit : 20
					}
				});
	}
		
	//管理药
	var ManageDrug = new Ext.form.Checkbox({
			boxLabel : '管理药',
			id : 'ManageDrug',
			name : 'ManageDrug',
			anchor : '90%',
			checked : false
		});
	
	//业务损益标志
	var RetAspFlag = new Ext.form.Checkbox({
		boxLabel : '是否显示业务损益',
		id : 'RetAspFlag',
		name : 'RetAspFlag',
		anchor : '90%',
		checked : true
	});
				
	var TypeStore = new Ext.data.SimpleStore({
			fields : ['RowId', 'Description'],
			data : [['0', '全部'], ['1', '零消耗'], ['2', '非零消耗']]
		});
	//统计标志
	var QueryFlag = new Ext.form.ComboBox({
			fieldLabel : '统计标志',
			id : 'QueryFlag',
			name : 'QueryFlag',
			anchor : '90%',
			width : 100,
			store : TypeStore,
			valueField : 'RowId',
			displayField : 'Description',
			mode : 'local',
			allowBlank : true,
			triggerAction : 'all',
			selectOnFocus : true,
			listWidth : 150,
			forceSelection : true
		});
	Ext.getCmp("QueryFlag").setValue(0);
	
	/// 业务类型
	var TransType = new Ext.form.ComboBox({
		fieldLabel : '业务类型',
		id : 'TransType',
		name : 'TransType',
		anchor : '90%',					
		store : TransTypeStore,
		valueField : 'RowId',
		displayField : 'Description',
		mode : 'local',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		listWidth : 150,
		forceSelection : true
	});
	
	// 检索按钮
	var searchBT = new Ext.Toolbar.Button({
				text : '查询',
				tooltip : '点击查询台账',
				iconCls : 'page_find',
				height:30,
				width:70,
				handler : function() {
					searchMainData();
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
					GridSelectWinType=1
					GridSelectWin.show();
					
					//gridSaveAsExcel(StockQtyGrid);
				}
			});		
	var GridColSetBT = new Ext.Toolbar.Button({
	      text:'列设置',
          tooltip:'列设置',
          iconCls:'page_gear',
	      handler:function(){
		      GridSelectWinType=2
		      GridSelectWin.show();
	      }
        });
       	// 确定按钮
	var returnBT = new Ext.Toolbar.Button({
				text : '确定',
				tooltip : '点击确定',
				iconCls : 'page_goto',
				handler : function() {
					var selectradio = Ext.getCmp('GridSelectModel').getValue();
			        if(selectradio){
			            var selectModel =selectradio.inputValue;	
						if (selectModel=='1') {
							if (GridSelectWinType==1){
								ExportAllToExcel(MasterInfoGrid);		
							}
							else{
								GridColSet(MasterInfoGrid,"DHCSTLOCSTKMOVE");
							} 
						}
						else {
							if (GridSelectWinType==1){
								ExportAllToExcel(DetailInfoGrid);		
							}
							else{
								GridColSet(DetailInfoGrid,"DHCSTLOCSTKMOVEDETAIL");
							}							
						}						
			         }
			         GridSelectWin.hide();
			         GridSelectWinType="";
				}
			});

	// 取消按钮
	var cancelBT = new Ext.Toolbar.Button({
				text : '取消',
				tooltip : '点击取消',
				iconCls : 'page_delete',
				handler : function() {
					GridSelectWin.hide();
				}
			});

      //选择按钮
	 var GridSelectWin=new Ext.Window({
			title:'选择',
			width : 200,
			height : 110,
			labelWidth:100,
			closeAction:'hide' ,
			plain:true,
			modal:true,
			items:[{
				  xtype:'radiogroup',
				  id:'GridSelectModel',
				  anchor: '95%',
				  columns: 2,
				  style: 'padding:10px 10px 10px 10px;',
				  items : [{
						 checked: true,				             
				             boxLabel: '台账',
				             id: 'GridSelectModel1',
				             name:'GridSelectModel',
				             inputValue: '1' 							
						},{
						 checked: false,				             
				             boxLabel: '台账明细',
				             id: 'GridSelectModel2',
				             name:'GridSelectModel',
				             inputValue: '2' 							
						}]
			        }],
			
			buttons:[returnBT,cancelBT]
			})	
	function priceRender(val){
		//var val = Ext.util.Format.number(val,'0.00'); //不四舍五入
		if (this.header.indexOf("进")>=0){
			val=FormatGridRp(val);
		}else{
			val=FormatGridSp(val);
		}	
		return val;
	}	
	function amountRender(val){
		//var val = Ext.util.Format.number(val,'0.00'); //不四舍五入
		if (this.header.indexOf("进")>=0){
			val=FormatGridRpAmount(val);
		}else{
			val=FormatGridSpAmount(val);
		}
		if(val<0){
			return '<span style="color:red;">'+val+'</span>';
		}else if(val>0){
			return '<span style="color:green;">'+val+'</span>';
		}
		return val;
	}
	function searchMainData() {
		
		//wyx add 2014-01-15
		var StartDatetmp = Ext.getCmp("StartDate").getValue()
		if (StartDatetmp=="") {
		    Msg.info("warning", "开始日期不能为空！");
		    Ext.getCmp("StartDate").focus();
		    return;
				}
		
		var StartDate = Ext.getCmp("StartDate").getValue().format(App_StkDateFormat)
				.toString();;
		if(StartDate==null||StartDate.length <= 0) {
			Msg.info("warning", "开始日期不能为空！");
			return;
		}
		var EndDatetmp = Ext.getCmp("EndDate").getValue()
		if (EndDatetmp=="") {
		    Msg.info("warning", "截止日期不能为空！");
		    Ext.getCmp("EndDate").focus();
		    return;
				}
		var EndDate = Ext.getCmp("EndDate").getValue().format(App_StkDateFormat)
				.toString();
		if(EndDate==null||EndDate.length <= 0) {
			Msg.info("warning", "截止日期不能为空！");
			return;
		}
		
		var PhaLocDesc = Ext.getCmp("PhaLoc").getRawValue();
		if (PhaLocDesc ==""||PhaLocDesc == null || PhaLocDesc.length <= 0) {
				Msg.info("warning", "科室不能为空！");
				Ext.getCmp("PhaLoc").focus();
				return;
			}
		var PhaLoc = Ext.getCmp("PhaLoc").getValue();
		if(PhaLoc==null||PhaLoc.length <= 0) {
			Msg.info("warning", "科室不能为空！");
			return;
		}
		
		var StkGrp= Ext.getCmp("StkGrpType").getValue();
		var StkCat= Ext.getCmp("DHCStkCatGroup").getValue();
		var ItmDesc=Ext.getCmp("ItmDesc").getValue();
		var ItmRowid="";
		if(ItmDesc!="" & ItmDesc.length>0){
			ItmRowid= Ext.getCmp("InciDr").getValue();
		}
		
		var PhcCat= Ext.getCmp("PhcCat").getValue();
		var PoisonCat= Ext.getCmp("PHCDFPhcDoDR").getValue();
		var ManageFlag= Ext.getCmp("ManageDrug").getValue();
		if(ManageFlag==true){
			ManageFlag=1;
		}
		else{
			ManageFlag="";
		}
		var StateFlag= Ext.getCmp("QueryFlag").getValue();
		var TransType=Ext.getCmp("TransType").getValue();
		var Others=StkGrp+"^"+StkCat+"^"+ItmRowid+"^"+PhcCat+"^"+PoisonCat+"^"+ManageFlag+"^"+StateFlag+"^"+gNewCatId+"^"+TransType;
		MasterInfoStore.setBaseParam('startdate',StartDate);
		MasterInfoStore.setBaseParam('enddate',EndDate);
		MasterInfoStore.setBaseParam('phaloc',PhaLoc);
		MasterInfoStore.setBaseParam('others',Others);
		var size=StatuTabPagingToolbar.pageSize;
		MasterInfoStore.removeAll();
		DetailInfoGrid.store.removeAll();
		MasterInfoStore.load({
			params:{start:0,limit:size},
			callback : function(r,options, success){
				if(success==false){
     				Ext.MessageBox.alert("查询错误",this.reader.jsonData.Error);
     			}else{
     				if(r.length>0){
	     				MasterInfoGrid.getSelectionModel().selectFirstRow();
	     				MasterInfoGrid.getSelectionModel().fireEvent('rowselect',this,0);
	     				MasterInfoGrid.getView().focusRow(0);
     				}
     			}
			}
		});
		
		
	}

	// 清空按钮
	var clearBT = new Ext.Toolbar.Button({
				text : '清屏',
				tooltip : '点击清屏',
				iconCls : 'page_clearscreen',
				height:30,
				width:70,
				handler : function() {
					clearData();
				}
			});

	function clearData() {
		SetLogInDept(PhaLoc.getStore(),'PhaLoc');
		Ext.getCmp("StartDate").setValue(new Date());
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("StkGrpType").getStore().load();
		Ext.getCmp("DHCStkCatGroup").setValue('');
		Ext.getCmp("PhcCat").setValue('');
		Ext.getCmp("PHCDFPhcDoDR").setValue('');
		Ext.getCmp("QueryFlag").setValue(0);
		Ext.getCmp("ItmDesc").setValue('');
		Ext.getCmp("ManageDrug").setValue(false);
		Ext.getCmp("RetAspFlag").setValue(true);
		
		Ext.getCmp("TransType").setValue('');
		MasterInfoGrid.store.removeAll();
		MasterInfoGrid.store.load({params:{start:0,limit:0}});
		DetailInfoGrid.store.removeAll();
		DetailInfoGrid.store.load({params:{start:0,limit:0}});
		Ext.getCmp("PHCCATALL").setValue("");
	}

	// 3关闭按钮
	var closeBT = new Ext.Toolbar.Button({
				text : '关闭',
				tooltip : '关闭界面',
				iconCls : 'close',
				handler : function() {
					window.close();
				}
			});

				
	// 访问路径
	var MasterInfoUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=LocItmStkMoveSum&start=0&limit=20';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterInfoUrl,
				method : "POST"
			});
	// 指定列参数
	// INCIL^库存项代码^库存项名称^库存分类^入库单位^基本单位^期初数量(基本单位)
	// ^期初数量(带单位)^期初金额(进价)^期初金额(售价)^期末数量(基本单位)^期末数量(带单位)
	// ^期末金额(进价)^期末金额(售价)
	// 
	var fields = ["INCIL", "InciCode", "InciDesc","StkCat","PurUom","BUom","BegQty","BegQtyUom",
	"BegRpAmt","BegSpAmt","EndQty","EndQtyUom","EndRpAmt","EndSpAmt","PlusQty","MinusQty"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "INCIL",
				fields : fields
			});
	// 数据集
	var MasterInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader,
				remoteSort:true
			});
	var nm = new Ext.grid.RowNumberer();
	var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "INCIL",
				dataIndex : 'INCIL',
				width : 20,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "药品名称",
				dataIndex : 'InciDesc',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : '入库单位',
				dataIndex : 'PurUom',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '增加数量',
				dataIndex : 'PlusQty',
				width : 100,
				align : 'right',
				sortable : true,
				renderer:FormatGridQty
			}, {
				header : '减少数量',
				dataIndex : 'MinusQty',
				width : 100,
				align : 'right',
				sortable : true,
				renderer:FormatGridQty
			}, {
				header : '基本单位',
				dataIndex : 'BUom',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '期初库存',
				dataIndex : 'BegQtyUom',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '期初金额(进价)',
				dataIndex : 'BegRpAmt',
				width : 100,
				align : 'right',
				renderer:amountRender,
				sortable : true
			}, {
				header : '期初金额(售价)',
				dataIndex : 'BegSpAmt',
				width : 100,
				align : 'right',
				renderer:amountRender,
				sortable : true
			}, {
				header : '期末库存',
				dataIndex : 'EndQtyUom',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '期末金额(进价)',
				dataIndex : 'EndRpAmt',
				width : 100,
				align : 'right',
				renderer:amountRender,
				sortable : true
			}, {
				header : '期末金额(售价)',
				dataIndex : 'EndSpAmt',
				width : 100,
				align : 'right',
				renderer:amountRender,
				sortable : true
			}, {
				header : '库存分类',
				dataIndex : 'StkCat',
				width : 100,
				align : 'left',
				sortable : true
			}]);
	MasterInfoCm.defaultSortable = true;
	var StatuTabPagingToolbar = new Ext.PagingToolbar({
		store : MasterInfoStore,
		pageSize : PageSize,
		displayInfo : true,
		displayMsg : '当前记录 {0} -- {1} 条 共 {2} 条记录',
		prevText : "上一页",
		nextText : "下一页",
		refreshText : "刷新",
		lastText : "最后页",
		firstText : "第一页",
		beforePageText : "当前页",
		afterPageText : "共{0}页",
		emptyMsg : "没有数据"
	});
	var MasterInfoGrid = new Ext.grid.GridPanel({
				id : 'MasterInfoGrid',
				title : '',
				height : 250,
				cm : MasterInfoCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true,
							listeners:{
								'rowselect': function(sm,rowIndex,r){
									var Incil = MasterInfoStore.getAt(rowIndex).get("INCIL");
									var StartDate = Ext.getCmp("StartDate").getValue().format(App_StkDateFormat).toString();;
									var EndDate = Ext.getCmp("EndDate").getValue().format(App_StkDateFormat).toString();
									var TransType=Ext.getCmp("TransType").getValue();
									var size=StatuTabPagingToolbar2.pageSize;
									var RetAspFlag= Ext.getCmp("RetAspFlag").getValue();
									if(RetAspFlag==true){
										RetAspFlag=1;
									}
									else{
										RetAspFlag=0;
									}
									DetailInfoStore.setBaseParam('incil',Incil);
									DetailInfoStore.setBaseParam('startdate',StartDate);
									DetailInfoStore.setBaseParam('enddate',EndDate);
									DetailInfoStore.setBaseParam('transtype',TransType);
									DetailInfoStore.setBaseParam('RetAspFlag',RetAspFlag);
									DetailInfoStore.load({
										params:{start:0,limit:size},
										callback : function(r,options, success){
											if(success==false){
												Ext.MessageBox.alert("查询错误",this.reader.jsonData.Error);
											}
										}
									});
								}
							}
						}),
				store : MasterInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				columnLines      : true,
				loadMask : true,
				bbar : StatuTabPagingToolbar
			});

	// 添加表格单击行事件
	MasterInfoGrid.on('rowclick', function(grid, rowIndex, e) {
	});

	// 访问路径
	var DetailInfoUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=LocItmStkMoveDetail&start=0&limit=20';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailInfoUrl,
				method : "POST"
			});
	
	// 指定列参数
	//业务日期^批号^单位^售价^进价^结余数量(基本单位)^结余数量(带单位)^增减数量(基本单位)
	//^增减数量(带单位)^增减金额(进价)^增减金额(售价)^处理号^处理信息^摘要
	//^期末金额(进价)^期末金额(售价)^供应商^厂商^操作人	
	var fields = ["TrId","TrDate", "BatExp", "PurUom", "Sp","Rp","EndQty","EndQtyUom",
			"TrQty", "TrQtyUom", "RpAmt", "SpAmt","TrNo","TrAdm","TrMsg",
			"EndRpAmt", "EndSpAmt", "Vendor", "Manf","OperateUser","TypeFlag"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "TrId",
				fields : fields
			});
	// 数据集
	var DetailInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader,
				remoteSort:true
			});
	var nm = new Ext.grid.RowNumberer();
	var DetailInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "TrId",
				dataIndex : 'TrId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "日期时间",
				dataIndex : 'TrDate',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : '批号效期',
				dataIndex : 'BatExp',
				width : 185,
				align : 'left',
				sortable : true
			}, {
				header : "单位",
				dataIndex : 'PurUom',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "售价",
				dataIndex : 'Sp',
				width : 60,
				align : 'right',
				renderer:priceRender,				
				sortable : true
			}, {
				header : "进价",
				dataIndex : 'Rp',
				width : 60,
				renderer:priceRender,
				align : 'right'
			}, {
				header : "结余数量",
				dataIndex : 'EndQtyUom',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "数量",
				dataIndex : 'TrQtyUom',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "进价金额",
				dataIndex : 'RpAmt',
				width : 100,
				renderer:amountRender,
				align : 'right',
				
				sortable : true
			}, {
				header : "售价金额",
				dataIndex : 'SpAmt',
				width : 100,
				renderer:amountRender,
				align : 'right',
				
				sortable : true
			}, {
				header : "处理号",
				dataIndex : 'TrNo',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "处理信息",
				dataIndex : 'TrAdm',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "业务类型",
				dataIndex : 'TrMsg',
				width : 65,
				align : 'left',
				sortable : true
			}, {
				header : "结余金额(进价)",
				dataIndex : 'EndRpAmt',
				width : 100,
				renderer:amountRender,
				align : 'right',
				
				sortable : true
			}, {
				header : "结余金额(售价)",
				dataIndex : 'EndSpAmt',
				width : 100,
				renderer:amountRender,
				align : 'right',
				
				sortable : true
			}, {
				header : "供应商",
				dataIndex : 'Vendor',
				width : 160,
				align : 'left',
				sortable : true
			}, {
				header : "厂商",
				dataIndex : 'Manf',
				width : 160,
				align : 'left',				
				sortable : true
			}, {
				header : "操作人",
				dataIndex : 'OperateUser',
				width : 65,
				align : 'left',				
				sortable : true
			}, {
				header : "TypeFlag",
				dataIndex : 'TypeFlag',
				width : 65,
				align : 'left',				
				sortable : true,
				hidden : true
			}]);
	DetailInfoCm.defaultSortable = true;
	var StatuTabPagingToolbar2 = new Ext.PagingToolbar({
		store : DetailInfoStore,
		pageSize : 20,
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
	var DetailInfoGrid = new Ext.grid.GridPanel({
				title : '',
				height : 170,
				cm : DetailInfoCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : DetailInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				columnLines      : true,
				loadMask : true,
				bbar : StatuTabPagingToolbar2,
				viewConfig : {
					getRowClass: function(record, rowIndex,rowParams,store){
						var TypeFlag=record.get('TypeFlag');
						if(TypeFlag=="1"){return 'classGrassGreen'}
					}
				}
			});
    //右键菜单代码关键部分 
	function rightClickFn(grid,rowindex,e){
		//grid.getSelectionModel().select(rowindex,0);
		grid.getSelectionModel().selectRow(rowindex);
		var rows=DetailInfoGrid.getSelectionModel().getSelections() ; 
		selectedRow = rows[0];
		var TrId = selectedRow.get("TrId");
		if(TrId.indexOf("RetAsp")>-1)
		{
			return;
		}
		e.preventDefault(); 
		rightClick.showAt(e.getXY()); 
	}
	var rightClick = new Ext.menu.Menu({ 
		id:'rightClickCont', 
		items: [ 
			{ 
				id: 'mnumodTransBat',   //批次修改增加 bianshuai 2014-04-23
				handler: mQueryBusDetail, 
				text: '业务明细查询' 
			}
		] 
	});
    DetailInfoGrid.addListener('rowcontextmenu', rightClickFn);
    function mQueryBusDetail()
    {
		var rows=DetailInfoGrid.getSelectionModel().getSelections() ; 
		if(rows.length==0){
			Ext.Msg.show({title:'错误',msg:'请选择要查看的台账明细！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}else {
			selectedRow = rows[0];
			var TrId = selectedRow.get("TrId");
			if(TrId.indexOf("RetAsp")>-1)
			{
				TrId=TrId.split("RetAsp")[1];
				//Msg.info("warning", "损益类型没有业务明细，请查看原业务记录！");
				//return;
			}
		   	BusDetailWin(TrId)
		}
	}


	var HisListTab = new Ext.form.FormPanel({
			labelWidth : 80,
			region : 'north',
			labelAlign : 'right',
			frame : true,
			title:"台账查询",
			tbar : [searchBT, '-', clearBT,'-',SaveAsBT,'-',GridColSetBT],		
		    items:[{
						layout : 'column',			
						items : [{
									columnWidth:0.25,
									autoHeight : true,
									xtype: 'fieldset',
									title:'必选条件',	
									style:DHCSTFormStyle.FrmPaddingV+"background",  //css最后;结束不起作用
									layout : 'column',	
									defaults: { border:false},    // Default config options for child items
									items : [{
										columnWidth:1,
										xtype: 'fieldset',
										border:false,									
										items : [PhaLoc,StartDate,EndDate]
									}]
								},{
									columnWidth:0.75,
									autoHeight : true,									
									xtype: 'fieldset',
									title:'可选条件',
									style:DHCSTFormStyle.FrmPaddingV+"margin-left:10px",	
									defaults: { border:false}, 
									layout : 'column',	
									items : [{
												columnWidth:0.35,
												xtype: 'fieldset',
												border:false,									
												items : [StkGrpType,DHCStkCatGroup,ItmDesc]
											},{
												xtype: 'fieldset',
												columnWidth:0.25,
												border:false,											
												items : [PHCDFPhcDoDR,QueryFlag,TransType]
											},{
												columnWidth:0.4,
												xtype: 'fieldset',
												border:false,
												items : [{xtype:'compositefield',items:[PHCCATALL,PHCCATALLButton]},ManageDrug,RetAspFlag]
											}]										
								}]
		    }]	
		});
	// 5.2.页面布局
	var mainPanel = new Ext.Viewport({
				layout : 'border',				
				items : [{
							region:'north',
							height:DHCSTFormStyle.FrmHeight(3)-10,
							layout:'fit',
			                items:HisListTab
			            },
			            {
							region:'center',
							split:true,
							layout:'fit',
			                items:MasterInfoGrid
			            },{
							region:'south',
							split: true,
							minSize:0,
							maxSize:document.body.clientHeight*0.6,
							height:document.body.clientHeight*0.45,
							layout:'fit',
			                items:DetailInfoGrid
			            }]
			});
			RefreshGridColSet(MasterInfoGrid,"DHCSTLOCSTKMOVE");
		    RefreshGridColSet(DetailInfoGrid,"DHCSTLOCSTKMOVEDETAIL");

}
});