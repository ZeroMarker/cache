// /名称: 入库单红冲
// /描述: 对于已经入库审核且出库而且已经生成月报，没有其他业务操作的情况
// /编写者：zhangdongmei
// /编写日期: 2012.07.18

Ext.onReady(function() {
	var gUserId = session['LOGON.USERID'];
	var HospId=session['LOGON.HOSPID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gIngrRowid="";
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;	

	if(gParam.length<1){
		GetParam();  //加载入库配置参数
	}
	var PhaLoc=new Ext.ux.LocComboBox({
		fieldLabel : '入库部门',
		id : 'PhaLoc',
		name : 'PhaLoc',
		width : 200,
		emptyText : '入库部门...',
		groupId:gGroupId
	});
	
	var Vendor=new Ext.ux.VendorComboBox({
		id : 'Vendor',
		name : 'Vendor',
		params : {LocId : 'PhaLoc'}
	});
	
	// 入库单号
	var InGrNo = new Ext.form.TextField({
				fieldLabel : '入库单号',
				id : 'InGrNo',
				name : 'InGrNo',
				anchor : '90%',
				width : 120,
				disabled : false
			});

	// 发票号
	var InvNo = new Ext.form.TextField({
				fieldLabel : '发票号',
				id : 'InvNo',
				name : 'InvNo',
				anchor : '90%',
				width : 120,
				disabled : false
			});
	
	// 起始日期
	var StartDate= new Ext.ux.DateField({
				fieldLabel : '起始日期',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '80%',
				
				width : 120,
				value : DefaultStDate()
			});

	// 结束日期
	var EndDate= new Ext.ux.DateField({
				fieldLabel : '结束日期',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '80%',
				
				width : 120,
				value : DefaultEdDate()
			});

// 检索按钮
var searchBT = new Ext.Toolbar.Button({
			text : '检索',
			tooltip : '点击检索入库单信息',
			height:30,
			width:70,
			iconCls : 'page_find',
			handler : function() {
				searchDurgData();
			}
		});

function searchDurgData() {
	var StartDate = Ext.getCmp("StartDate").getValue();
	if(StartDate!=null && StartDate!=""){
		StartDate=StartDate.format(ARG_DATEFORMAT);
	}else{
		Msg.info("warning","请选择开始日期!");
		return;
	}
	var EndDate = Ext.getCmp("EndDate").getValue();
	if(EndDate!=null && EndDate!=""){
		EndDate=EndDate.format(ARG_DATEFORMAT);
	}else{
		Msg.info("warning","请选择截止日期!");
		return;
	}
	var InGrNo = Ext.getCmp("InGrNo").getValue();
	var Vendor = Ext.getCmp("Vendor").getValue();
	var PhaLoc = Ext.getCmp("PhaLoc").getValue();	
	if(PhaLoc==""){
		Msg.info("warning", "请选择入库部门!");
		return;
	}
	var AuditFlag="Y";
	var InvNo= Ext.getCmp("InvNo").getValue();
	var ListParam=StartDate+'^'+EndDate+'^'+InGrNo+'^'+Vendor+'^'+PhaLoc+'^^^'+AuditFlag+'^'+InvNo+'^'+gUserId;
	var Page=GridPagingToolbar.pageSize;
	GrMasterInfoStore.setBaseParam('ParamStr',ListParam);
	GrDetailInfoStore.removeAll();
	GrMasterInfoStore.removeAll();
	GrMasterInfoStore.load({
		params:{start:0, limit:Page},
		callback:function(r,options, success) {
			if(success==false){
     			Msg.info("error", "查询错误，请查看日志!");
     		}else{
     			if(r.length>=1){
     				GrMasterInfoGrid.getSelectionModel().selectFirstRow();
     				GrMasterInfoGrid.fireEvent('select',this,0);
     				GrMasterInfoGrid.getView().focusRow(0);
     			}
     		}
		}
	});
}

// 选取按钮
var acceptBT = new Ext.Toolbar.Button({
			text : '红冲',
			tooltip : '点击红冲',
			height:30,
			width:70,
			iconCls : 'page_save',
			handler : function() {
			
				var newVendor=Ext.getCmp("Vendor").getRawValue();
				var newVendorId=Ext.getCmp("Vendor").getValue();
				var selectRec=GrMasterInfoGrid.getSelectionModel().getSelected();
				if(selectRec==null){
					Msg.info("warning","请选择要修改的入库单!");
					return;
				}
				
			  if(GrDetailInfoGrid.activeEditor != null){
		    	GrDetailInfoGrid.activeEditor.completeEdit();
		        }
		      var ListDetail="";
		      var rowCount = GrDetailInfoGrid.getStore().getCount();
		      //明细id^厂商id^批号^效期^随行单号^发票号^发票日期^发票金额^进价
		     for (var i = 0; i < rowCount; i++) {
			    var rowData = GrDetailInfoStore.getAt(i);	
			   //新增或数据发生变化时执行下述操作
			    if(rowData.data.newRecord || rowData.dirty){					
				  var Ingri=rowData.get("Ingri");
				  var incidesc=rowData.get("IncDesc");
				  var ManfId = rowData.get("ManfId");
				  var BatNo = rowData.get("BatchNo");
				  var ExpDate =Ext.util.Format.date(rowData.get("ExpDate"),ARG_DATEFORMAT);
				  var SxNo = rowData.get("SxNo");
				  var InvNo=rowData.get("InvNo");
				  var InvDate =Ext.util.Format.date(rowData.get("InvDate"),ARG_DATEFORMAT);
				  var InvAmt=rowData.get("InvMoney");
				  var Rp=rowData.get("Rp");
				  var str = Ingri+"^"+Rp;	
				  if(ListDetail==""){
					    ListDetail=str;
				    }
				     else{
				        	ListDetail=ListDetail+xRowDelim()+str;
				    }
			      }
		         }
		         if(ListDetail==""){
			         Msg.info("warning", "没有需要保存的明细！");
			       //return -1;  //没有需要更新的明细
		         }
		      var ret=0;  //更新成功
		      var mask=ShowLoadMask(Ext.getBody(),"处理中...");
		      var url = DictUrl+ "ingdrecredaction.csp?actiontype=UpdateRecInfo";
		      Ext.Ajax.request({
			    url : url,
			    method : 'POST',
			    params:{ListDetail:ListDetail},
			    success : function(result, request) {
				    var jsonData = Ext.util.JSON.decode(result.responseText);
				  
				    if (jsonData.success == 'false') {
					ret=jsonData.info;	
					if(ret==-4){Msg.info("error", "入库明细不能再次红冲！");	
					return	
					}else if(ret==-63){Msg.info("error", incidesc+"已经做退货处理！");	
					return	
					}else if(ret==-3){Msg.info("error", incidesc+"已经付款！");	
					return	
					}else if(ret==-66){Msg.info("error", incidesc+"已调整处理！");	
					return	
					}else if(ret==-67){Msg.info("error", incidesc+"已报损处理！");	
					return	
					}else if((ret==-5)||(ret==-6)){Msg.info("error", incidesc+"新做红冲入库单失败!");	
					return	
					}else if((ret==-7)||(ret==-8)){Msg.info("error", incidesc+"补录入库单失败！");	
					return	
					}else if((ret==-9)||(ret==-10)){Msg.info("error", incidesc+"红冲出库单失败！");	
					return	
					}else if(ret==-11){Msg.info("error", incidesc+"补录出库单失败！");	
					return	
					}else if(ret==-65){Msg.info("error", incidesc+"更新批次信息表进价失败！");	
					return	
					}		
				    }else{
					Msg.info("success", "入库单红冲成功!");
					// 7.显示入库单数据
					Query(gIngrRowid);
					
					}
				mask.hide();
			    },
			     scope : this
		       });
		       mask.hide();
				/*
				var oldVendor=selectRec.get("Vendor");
				//更新明细
				var ret=Update();
				
			
				if(ret==0){
					Msg.info("success", "入库单明细更新成功!");
					// 7.显示入库单数据
					Query(gIngrRowid);
				}else if((ret==-1)&(newVendor==oldVendor)){
					Msg.info("warning", "数据没有发生变化，不需要保存!");
					return;
				}else if(ret!=-1){
					Msg.info("error", "更新某明细失败："+ret);	
				}
				//UpdateVendor();  //更新供应商
				*/
			}
		});
		
	
	/**
	 * 保存验收信息
	 */
	function Update() {
		if(GrDetailInfoGrid.activeEditor != null){
			GrDetailInfoGrid.activeEditor.completeEdit();
		}
		var ListDetail="";
		var rowCount = GrDetailInfoGrid.getStore().getCount();
		//明细id^厂商id^批号^效期^随行单号^发票号^发票日期^发票金额^进价
		for (var i = 0; i < rowCount; i++) {
			var rowData = GrDetailInfoStore.getAt(i);	
			//新增或数据发生变化时执行下述操作
			if(rowData.data.newRecord || rowData.dirty){					
				var Ingri=rowData.get("Ingri");
				var ManfId = rowData.get("ManfId");
				var BatNo = rowData.get("BatchNo");
				var ExpDate =Ext.util.Format.date(rowData.get("ExpDate"),ARG_DATEFORMAT);
				var SxNo = rowData.get("SxNo");
				var InvNo=rowData.get("InvNo");
				var InvDate =Ext.util.Format.date(rowData.get("InvDate"),ARG_DATEFORMAT);
				var InvAmt=rowData.get("InvMoney");
				var Rp=rowData.get("Rp");
				var str = Ingri + "^" + ManfId + "^"	+ BatNo + "^" + ExpDate + "^"
						+ SxNo + "^" + InvNo + "^" + InvDate+"^"+InvAmt+"^"+Rp;	
				if(ListDetail==""){
					ListDetail=str;
				}
				else{
					ListDetail=ListDetail+xRowDelim()+str;
				}
			}
		}
		if(ListDetail==""){
			return -1;  //没有需要更新的明细
		}
		var ret=0;  //更新成功
		var mask=ShowLoadMask(Ext.getBody(),"处理中...");
		var url = DictUrl+ "ingdrecredaction.csp?actiontype=UpdateRecInfo";
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			params:{ListDetail:ListDetail},
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'false') {
					ret=jsonData.info;		
					Msg.info("error", "更新某明细失败："+ret);	
					return			
				}
				mask.hide();
			},
			scope : this
		});
		
		return ret;
	}
// 清空按钮
var clearBT = new Ext.Toolbar.Button({
			text : '清空',
			tooltip : '点击清空',
			height:30,
			width:70,
			iconCls : 'page_clearscreen',
			handler : function() {
				clearData();
			}
		});

function clearData() {
	Ext.getCmp("InGrNo").setValue("");
	Ext.getCmp("Vendor").setValue("");
	//Ext.getCmp("PhaLoc").setValue("");
	SetLogInDept(PhaLoc.getStore(),'PhaLoc');
	Ext.getCmp("InvNo").setValue("");
	Ext.getCmp("StartDate").setValue(DefaultStDate());
	Ext.getCmp("EndDate").setValue(DefaultEdDate());
	GrMasterInfoGrid.store.removeAll();
	GrDetailInfoGrid.store.removeAll();
	gIngrRowid="";
}

// 3关闭按钮
var closeBT = new Ext.Toolbar.Button({
			text : '关闭',
			tooltip : '关闭界面',
			iconCls : 'page_close',
			handler : function() {
				window.close();
			}
		});
		


// 访问路径
var MasterInfoUrl = DictUrl	+ 'ingdrecaction.csp?actiontype=Query';
// 通过AJAX方式调用后台数据
var proxy = new Ext.data.HttpProxy({
			url : MasterInfoUrl,
			method : "POST"
		});

// 指定列参数
var fields = ["IngrId","IngrNo", "Vendor", "RecLoc", "IngrType", "PurchUser",
		"PoNo", "CreateUser", "CreateDate", "Complete", "ReqLoc",
		"StkGrp","RpAmt","SpAmt","AcceptUser","VenId"];
// 支持分页显示的读取方式
var reader = new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			id : "IngrId",
			fields : fields
		});
// 数据集
var GrMasterInfoStore = new Ext.data.Store({
			proxy : proxy,
			reader : reader
		});
var nm = new Ext.grid.RowNumberer();
var GrMasterInfoCm = new Ext.grid.ColumnModel([nm, {
			header : "RowId",
			dataIndex : 'IngrId',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true//,
			//hideable : false
		}, {
			header : "入库单号",
			dataIndex : 'IngrNo',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			header : "厂商",
			dataIndex : 'Vendor',
			width : 200,
			align : 'left',
			sortable : true
		}, {
			header : '验收人',
			dataIndex : 'AcceptUser',
			width : 70,
			align : 'left',
			sortable : true
		}, {
			header : '到货日期',
			dataIndex : 'CreateDate',
			width : 90,
			align : 'center',
			sortable : true
		}, {
			header : '采购员',
			dataIndex : 'PurchUser',
			width : 70,
			align : 'left',
			sortable : true
		}, {
			header : "完成标志",
			dataIndex : 'Complete',
			width : 70,
			align : 'left',
			sortable : true
		}]);
GrMasterInfoCm.defaultSortable = true;
var GridPagingToolbar = new Ext.PagingToolbar({
	store:GrMasterInfoStore,
	pageSize:PageSize,
	displayInfo:true
});
var GrMasterInfoGrid = new Ext.grid.GridPanel({
			region: 'west',
			title: '入库单',
			collapsible: true,
			split: true,
			width: 225,
			minSize: 175,
			maxSize: 400,
			margins: '0 5 0 0',
			id : 'GrMasterInfoGrid',
			cm : GrMasterInfoCm,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			store : GrMasterInfoStore,
			trackMouseOver : true,
			stripeRows : true,
			loadMask : true,
			bbar:[GridPagingToolbar]
		});

// 添加表格单击行事件
GrMasterInfoGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, rec) {
	var InGr = GrMasterInfoStore.getAt(rowIndex).get("IngrId");
	var VenId=GrMasterInfoStore.getAt(rowIndex).get("VenId");
	var VenDesc=GrMasterInfoStore.getAt(rowIndex).get("Vendor");
	//addComboData(Ext.getCmp("Vendor").getStore(),VenId,VenDesc);
	//Ext.getCmp("Vendor").setValue(VenId);
	gIngrRowid=InGr;
	Query(InGr);
});

// 生产厂商
var Phmnf = new Ext.ux.ComboBox({
			fieldLabel : '生产厂商',
			id : 'Phmnf',
			store : PhManufacturerStore,
			allowBlank : true,
			triggerAction : 'all',
			emptyText : '生产厂商...',
			selectOnFocus : false,
			forceSelection : true,
			filterName:'PHMNFName',
			params : {LocId : 'PhaLoc'}
		});

function Query(Parref){
	GrDetailInfoStore.load({params:{start:0,limit:999,sort:'Rowid',dir:'Desc',Parref:Parref}});
}

// 访问路径
var DetailInfoUrl = DictUrl
				+ 'ingdrecaction.csp?actiontype=QueryDetail';
// 通过AJAX方式调用后台数据
var proxy = new Ext.data.HttpProxy({
			url : DetailInfoUrl,
			method : "POST"
		});
// 指定列参数 	
var fields = ["Ingri", "BatchNo", "IngrUom",{name:"ExpDate",type:'date',dateFormat:DateFormat}, "Inclb",  "Margin", "RecQty",
		"IncCode", "IncDesc","InvNo", "ManfId","Manf", "Rp", "RpAmt","Sp", "SpAmt", {name:"InvDate",type:'date',dateFormat:DateFormat},"InvMoney","SxNo"];
// 支持分页显示的读取方式
var reader = new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			id : "Ingri",
			fields : fields
		});
// 数据集
var GrDetailInfoStore = new Ext.data.Store({
			proxy : proxy,
			reader : reader
		});
GrDetailInfoStore.addListener('update',function(store,record,opt){
	if(record.isModified("Rp")){							
		// 计算指定行的进货金额
		var RealTotal = Number(record.get("RecQty")).mul(Number(record.get("Rp")));
		record.set("RpAmt",RealTotal);
		record.set("InvMoney",RealTotal);
	}
	
});

var nm = new Ext.grid.RowNumberer();
var GrDetailInfoCm = new Ext.grid.ColumnModel([nm, {
			header : "Ingri",
			dataIndex : 'Ingri',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true//,
			//hideable : false
		}, {
			header : '物资代码',
			dataIndex : 'IncCode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '物资名称',
			dataIndex : 'IncDesc',
			width : 230,
			align : 'left',
			sortable : true
		}, {
			header : "厂商",
			dataIndex : 'ManfId',
			width : 180,
			align : 'left',
			sortable : true,
			//editor : Phmnf,
			renderer :Ext.util.Format.comboRenderer2(Phmnf,"ManfId","Manf")	
		}, {
			header : "批号",
			dataIndex : 'BatchNo',
			width : 90,
			align : 'left',
			sortable : true
		}, {
			header : "有效期",
			dataIndex : 'ExpDate',
			width : 100,
			align : 'left',
			sortable : true,
			renderer:Ext.util.Format.dateRenderer(DateFormat)
		}, {
			header : "单位",
			dataIndex : 'IngrUom',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "数量",
			dataIndex : 'RecQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : "进价",
			dataIndex : 'Rp',
			width : 60,
			align : 'right',
			sortable : true,
			editor : new Ext.form.NumberField({
				selectOnFocus : true,
				allowBlank : false,
				allowNegative:false
			})
		}, {
			header : "售价",
			dataIndex : 'Sp',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : "发票号",
			dataIndex : 'InvNo',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "发票日期",
			dataIndex : 'InvDate',
			width : 100,
			align : 'left',
			sortable : true,
			renderer:Ext.util.Format.dateRenderer(DateFormat)
		}, {
			header : "发票金额",
			dataIndex : 'InvMoney',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "进价金额",
			dataIndex : 'RpAmt',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "售价金额",
			dataIndex : 'SpAmt',
			width : 100,
			align : 'left',
			sortable : true
		},{			
			header : "随行单号",
			dataIndex : 'SxNo',
			width : 80,
			align : 'left',
			sortable : true
		}]);
GrDetailInfoCm.defaultSortable = true;
var GrDetailInfoGrid = new Ext.grid.EditorGridPanel({
			region: 'center',
			title: '入库单明细',
			cm : GrDetailInfoCm,
			sm : new Ext.grid.CellSelectionModel({}),
			store : GrDetailInfoStore,
			trackMouseOver : true,
			stripeRows : true,
			loadMask : true,
			clicksToEdit : 1,
			listeners:{
				afteredit:function(e){
					if(e.field=="Rp"){
						if(e.value==0){
							Msg.info("warning",	"进价不能等于0!");
							e.record.set('Rp',e.originalValue);
							GrDetailInfoGrid.startEditing(e.row,e.column);
							return;
						}
						/*
						//验证加成率							
						var sp=e.record.get("Sp");
						var margin=accDiv(sp,e.value);
						
						if(margin>gParam[5] || margin<1){
							Msg.info("warning",	"加成率超出限定范围!");
							e.record.set('Rp',e.originalValue);
							GrDetailInfoGrid.startEditing(e.row,e.column);
							return;
						}*/
					}
				}
			}
		});
	var InfoForm = new Ext.ux.FormPanel({
			labelWidth: 60,	
			title : '入库单红冲',
			id : "InfoForm",			
			tbar : [searchBT, '-', acceptBT,'-',clearBT],
			items : [{
				xtype:'fieldset',
				title:'查询条件',
				style:'padding:5px 0px 0px 10px',
				defaults: {border:false},    // Default config options for child items
				layout: 'column',    // Specifies that the items will now be arranged in columns
				items:[{
					columnWidth: 0.33,
	            	xtype: 'fieldset',	            	
	            	autoHeight: true,
	            	items: [PhaLoc,Vendor]					
				},{
					columnWidth: 0.33,
	            	xtype: 'fieldset',
	            	autoHeight: true,	            	
	            	items: [StartDate,EndDate]					
				},{
					columnWidth: 0.33,
	            	xtype: 'fieldset',	            
	            	items: [InGrNo,InvNo]
				}]
			}]
		});
		
	// 页面布局
	var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [InfoForm, GrMasterInfoGrid, GrDetailInfoGrid]			
	});
})