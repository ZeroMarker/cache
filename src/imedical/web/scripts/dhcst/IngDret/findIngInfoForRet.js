// /名称: 已审核入库单查询与修改
// /描述: 已审核入库单查询与修改
// /编写者：zhangdongmei
// /编写日期: 2012.07.18
		
FindIngInfo=function() {
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
	
	var fVendor=new Ext.ux.VendorComboBox({
		id : 'fVendor',
		name : 'fVendor',
		width : 200
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
			text : '查询',
			tooltip : '点击查询入库单信息',
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
		StartDate=StartDate.format(App_StkDateFormat);
	}else{
		Msg.info("warning","请选择开始日期!");
		return;
	}
	var EndDate = Ext.getCmp("EndDate").getValue();
	if(EndDate!=null && EndDate!=""){
		EndDate=EndDate.format(App_StkDateFormat);
	}else{
		Msg.info("warning","请选择截止日期!");
		return;
	}
	var InGrNo = Ext.getCmp("InGrNo").getValue();
	var Vendor = Ext.getCmp("fVendor").getValue();
	var PhaLoc = Ext.getCmp("PhaLoc").getValue();	
	if(PhaLoc==""){
		Msg.info("warning", "请选择入库部门!");
		return;
	}
	var AuditFlag="Y";
	var InvNo= Ext.getCmp("InvNo").getValue();
	var ListParam=StartDate+'^'+EndDate+'^'+InGrNo+'^'+Vendor+'^'+PhaLoc+'^^^'+AuditFlag+'^'+InvNo;
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
			text : '保存',
			tooltip : '点击保存',
			height:30,
			width:70,
			iconCls : 'page_save',
			handler : function() {
			
				var newVendor=Ext.getCmp("fVendor").getRawValue();
				var newVendorId=Ext.getCmp("fVendor").getValue();
				var selectRec=GrMasterInfoGrid.getSelectionModel().getSelected();
				if(selectRec==null){
					Msg.info("warning","请选择要修改的入库单!");
					return;
				}
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
				UpdateVendor();  //更新供应商
			}
		});
		
	function UpdateVendor(){
		var newVendor=Ext.getCmp("fVendor").getRawValue();
		var newVendorId=Ext.getCmp("fVendor").getValue();	
		var selectRec=GrMasterInfoGrid.getSelectionModel().getSelected();
		var oldVendor=selectRec.get("Vendor");
		if(newVendor==oldVendor){
			return;
		}
		Ext.Msg.show({
			title:'提示',
			msg:'是否确定修改供应商？',
			buttons:Ext.Msg.YESNO,
			icon:Ext.Msg.QUESTION,
			fn:function(buttonId,text,opt){
				if(buttonId=="yes"){
					Ext.Ajax.request({
						url:DictUrl+ "ingdrecaction.csp?actiontype=UpdateVendor",
						method:'POST',
						params:{Ingr:gIngrRowid,Vendor:newVendorId},
						success:function(response,opt){
							var jsonData=Ext.util.JSON.decode(response.responseText);
							if(jsonData.success=='true'){
								Msg.info('success',"更新供应商成功!");
								GrMasterInfoGrid.store.reload();
								//selectRec.set("Vendor",newVendor);
							}else{
								var ret=jsonData.info;
								switch(ret){
									case '-11':
										Msg.info("warning","入库单存在明细已退货制单,不能修改供应商");
										break;
									case '-12':
										Msg.info("warning","入库单存在明细已付款制单,不能修改供应商");
										break
									default:
										Msg.info('error',"更新供应商失败"+ret);
										break;
								}
							}
						
						}
					})
				}
			}
		});
	}
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
				var ExpDate =Ext.util.Format.date(rowData.get("ExpDate"),App_StkDateFormat);
				var SxNo = rowData.get("SxNo");
				var InvNo=rowData.get("InvNo");
				var InvDate =Ext.util.Format.date(rowData.get("InvDate"),App_StkDateFormat);
				var InvAmt=rowData.get("InvMoney");
				var Rp=rowData.get("Rp");
				//验证加成率							
				var sp=rowData.get("Sp");
				var margin=sp/Rp;
				var cnt=i+1	
				if(margin>gParam[5] || margin<1){
				//Msg.info("warning",	"第"+cnt+"行加成率超出限定范围!");
				break;
						}
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
		var url = DictUrl+ "ingdrecaction.csp?actiontype=UpdateRecInfo";
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			params:{ListDetail:ListDetail},
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'false') {
					ret=jsonData.info;					
				}
				mask.hide();
			},
			scope : this
		});
		
		return ret;
	}
// 清空按钮
var clearBT = new Ext.Toolbar.Button({
			text : '清屏',
			tooltip : '点击清屏',
			height:30,
			width:70,
			iconCls : 'page_clearscreen',
			handler : function() {
				clearData();
			}
		});

function clearData() {
	Ext.getCmp("InGrNo").setValue("");
	Ext.getCmp("fVendor").setValue("");
	//Ext.getCmp("PhaLoc").setValue("");
	SetLogInDept(PhaLoc.getStore(),'PhaLoc');
	Ext.getCmp("InvNo").setValue("");
	Ext.getCmp("StartDate").setValue(DefaultStDate());
	Ext.getCmp("EndDate").setValue(DefaultEdDate());
	GrMasterInfoGrid.store.removeAll();
	GrDetailInfoGrid.store.removeAll();
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
		
var cancelBT=new Ext.Toolbar.Button({
	text : '取消审核',
	tooltip : '点击取消审核',
	height:30,
	width:70,
	iconCls : 'page_gear',
	handler : function() {
		CancelAudit();
	}
});

function CancelAudit(){
	if(gIngrRowid==""){
		Msg.info("warning", "请选择需要取消审核的入库单!");
		return;
	}
	
	var mask=ShowLoadMask(Ext.getBody(),"处理中...");
	var url = DictUrl+ "ingdrecaction.csp?actiontype=CancelAudit";
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		params:{Ingr:gIngrRowid},
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				// 刷新界面
				Msg.info("success", "取消审核成功!");
				searchDurgData();
			} else {
				var ret=jsonData.info;
				if(ret==-7){
					Msg.info("error","该入库单已发生库存转移业务!");
				}else if(ret==-8){
					Msg.info("error", "该入库单有明细已退货制单!");
				}else if(ret==-9){
					Msg.info("error", "该入库单已经生成付款单");
				}else{	
					Msg.info("error", "取消审核失败："+ret);
				}							
			}
			mask.hide();
		},
		scope : this
	});
}

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
		"StkGrp","RpAmt","SpAmt","AcceptUser","VenId","InvNoflag"];
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
			hidden : true,
			hideable : false
		}, {
			header : "入库单号",
			dataIndex : 'IngrNo',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			header : "供货厂商",
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
		}, {
			header : '是否有货到票未到',
			dataIndex : 'InvNoflag',
			width : 70,
			align : 'left',
			sortable : true,
			hidden : true
		}]);
GrMasterInfoCm.defaultSortable = true;
var GridPagingToolbar = new Ext.PagingToolbar({
	store:GrMasterInfoStore,
	pageSize:PageSize,
	displayInfo:true,
	displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
	emptyMsg:"没有记录"
});
var GrMasterInfoGrid = new Ext.grid.GridPanel({
			id : 'GrMasterInfoGrid',
			title : '',
			height : 170,
			cm : GrMasterInfoCm,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			store : GrMasterInfoStore,
			trackMouseOver : true,
			stripeRows : true,
			loadMask : true,
			//-----------------------------add by myq 20140425
		
		   
			//-----------------------------add by myq 20140425
			bbar:[GridPagingToolbar]
		});

// 添加表格单击行事件
GrMasterInfoGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, rec) {
	var InGr = GrMasterInfoStore.getAt(rowIndex).get("IngrId");
	var VenId=GrMasterInfoStore.getAt(rowIndex).get("VenId");
	var VenDesc=GrMasterInfoStore.getAt(rowIndex).get("Vendor");
	addComboData(Ext.getCmp("fVendor").getStore(),VenId,VenDesc);
	Ext.getCmp("fVendor").setValue(VenId);
	gIngrRowid=InGr;
	Query(InGr);
	
});

// 生产厂商
var Phmnf = new Ext.form.ComboBox({
			fieldLabel : '生产厂商',
			id : 'Phmnf',
			name : 'Phmnf',
			anchor : '90%',
			width : 100,
			store : PhManufacturerStore,
			valueField : 'RowId',
			displayField : 'Description',
			//allowBlank : false,
			triggerAction : 'all',
			emptyText : '生产厂商...',
			selectOnFocus : false,
			forceSelection : true,
			//editable:true,
			minChars : 3,
			typeAhead:true,
			pageSize : 20,
			listWidth : 250,
			valueNotFoundText : '',
			listeners : {
				'beforequery' : function(e) {
					var filter=Ext.getCmp('Phmnf').getRawValue();
					PhManufacturerStore.load({params : {start : 0,limit : 20,PHMNFName:filter}});	
					e.cancel=true;
				}
			}
		});

function Query(Parref){
	GrDetailInfoStore.load({params:{start:0,limit:999,sort:'Rowid',dir:'Desc',Parref:Parref}});
}

// 访问路径
var DetailInfoUrl = DictUrl
				+ 'ingdrecaction.csp?actiontype=QueryIngrDetail';
// 通过AJAX方式调用后台数据
var proxy = new Ext.data.HttpProxy({
			url : DetailInfoUrl,
			method : "POST"
		});
// 指定列参数 	
var fields = ["Ingri", "BatchNo", "IngrUom",{name:"ExpDate",type:'date',dateFormat:App_StkDateFormat}, "Inclb",  "Margin", "RecQty",
		"IncCode", "IncDesc","InvNo", "ManfId","Manf", "Rp", "RpAmt","Sp", "SpAmt", {name:"InvDate",type:'date',dateFormat:App_StkDateFormat},"InvMoney","SxNo","Spec"];
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
	}
	
});

//货到票未到标红
GrDetailInfoStore.addListener('load',function(store,record,opt){
    var RowIndex=store.getCount();
    for(var i=0;i<RowIndex;i++){
       var invno=store.getAt(i).get("InvNo");
       if(invno==""){
          GrDetailInfoGrid.getView().getRow(i).style.backgroundColor = "#FF1493";
       }
    }
});

var nm = new Ext.grid.RowNumberer();
var GrDetailInfoCm = new Ext.grid.ColumnModel([nm, {
			header : "Ingri",
			dataIndex : 'Ingri',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true,
			hideable : false
		}, {
			header : '药品代码',
			dataIndex : 'IncCode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '药品名称',
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
			editor : Phmnf,
			renderer :Ext.util.Format.comboRenderer2(Phmnf,"ManfId","Manf")	
		}, {
			header : "批号",
			dataIndex : 'BatchNo',
			width : 90,
			align : 'left',
			sortable : true,
			editor:new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank : false,
				listeners : {
					change : function(field, newValue,oldValue) {
						
							var cell = GrDetailInfoGrid.getSelectionModel().getSelectedCell();
							var colIndex=GetColIndex(GrDetailInfoGrid,"BatchNo");
							if (newValue == null || newValue.length <= 0) {
								Msg.info("warning", "批号不能为空!");
								field.setValue("");
								//GrDetailInfoGrid.startEditing(cell[0], colIndex);
								return;
							}	
							//GrDetailInfoGrid.startEditing(cell[0], colIndex);
						
					}
				}
			})
		}, {
			header : "有效期",
			dataIndex : 'ExpDate',
			width : 100,
			align : 'left',
			sortable : true,
			renderer:Ext.util.Format.dateRenderer(App_StkDateFormat),
			editor:new Ext.ux.DateField({
				format:App_StkDateFormat,
				listeners:{
					change:function(field,newValue,oldValue){
						var cell = GrDetailInfoGrid.getSelectionModel().getSelectedCell();
						var col=GetColIndex(GrDetailInfoGrid,'ExpDate');
						var expDate = newValue.format('Y-m-d');
						var flag=ExpDateValidator(expDate);		
						
					    if(flag==false){
					    	Msg.info('Warning','效期不符,距离失效期不能少于'+gParam[2]+'天!');	
					    	field.setValue('');
					    	GrDetailInfoGrid.startEditing(cell[0], col);
					    	return;
					    }
						
						//GrDetailInfoGrid.startEditing(cell[0]+1, col);
					}				
				}
			})
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
			sortable : true,
			editor:new Ext.form.TextField({
				selectOnFocus:true,
				listeners:{
					change:function(field,newValue,oldValue){
						var cell = GrDetailInfoGrid.getSelectionModel().getSelectedCell();
						var col=GetColIndex(GrDetailInfoGrid,"InvNo");
						
						var flag=InvNoValidator(newValue,gIngrRowid);					
						if(flag==false){
							Msg.info("Warning","该发票号已存在于别的入库单");
							field.setValue('');					
							GrDetailInfoGrid.startEditing(cell[0], col);
							return;
						}	
						var lastRowIndex=GrDetailInfoGrid.getStore().getCount()-1;
						if(cell[0]<lastRowIndex){
							GrDetailInfoGrid.getSelectionModel().select(cell[0]+1, col);
							GrDetailInfoGrid.startEditing(cell[0]+1, col);	
						}
					}
				}
			
			})
		}, {
			header : "发票日期",
			dataIndex : 'InvDate',
			width : 100,
			align : 'left',
			sortable : true,
			renderer:Ext.util.Format.dateRenderer(App_StkDateFormat),
			editor:new Ext.ux.DateField({
				format:App_StkDateFormat,
				listeners:{
					specialkey:function(field,e){
						if(e.getKey() == Ext.EventObject.ENTER){
							var cell = GrDetailInfoGrid.getSelectionModel().getSelectedCell();
							var col=GetColIndex(GrDetailInfoGrid,"InvDate");
							GrDetailInfoGrid.startEditing(cell[0]+1, col);	
						}
					}				
				}
			})
		}, {
			header : "发票金额",
			dataIndex : 'InvMoney',
			width : 100,
			align : 'left',
			sortable : true,
			editor:new Ext.form.NumberField({
			
			})
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
			sortable : true,
			editor:new Ext.form.TextField({
				selectOnFocus:true,
				listeners:{
					specialkey:function(field,e){
						if(e.getKey() == Ext.EventObject.ENTER){
							var cell = GrDetailInfoGrid.getSelectionModel().getSelectedCell();
							var col=GetColIndex(GrDetailInfoGrid,"SxNo");
							GrDetailInfoGrid.startEditing(cell[0]+1, col);	
						}
					}				
				}
			})
		}, {
			header : "规格",
			dataIndex : 'Spec',
			width : 100,
			align : 'left',
			sortable : true
		}]);
GrDetailInfoCm.defaultSortable = true;
var GrDetailInfoGrid = new Ext.grid.EditorGridPanel({
			title : '',
			height : 170,
			cm : GrDetailInfoCm,
			sm : new Ext.grid.CellSelectionModel({}),
			store : GrDetailInfoStore,
			trackMouseOver : true,
			stripeRows : true,
			loadMask : true,
			clicksToEdit : 1,
			listeners:{
				'beforeedit':function(e){
					if(e.field=="ManfId"){
						var store=Ext.getCmp('Phmnf').getStore();
						addComboData(store,e.record.get('ManfId'),e.record.get('Manf'));
					}
				},
				afteredit:function(e){
					if(e.field=="Rp"){
						if(e.value==0){
							Msg.info("warning",	"进价不能等于0!");
							e.record.set('Rp',e.originalValue);
							GrDetailInfoGrid.startEditing(e.row,e.column);
							return;
						}
						//验证加成率							
						var sp=e.record.get("Sp");
						var margin=sp/e.value;
						
						if(margin>gParam[5] || margin<1){
							Msg.info("warning",	"加成率超出限定范围!");
							e.record.set('Rp',e.originalValue);
							GrDetailInfoGrid.startEditing(e.row,e.column);
							return;
						}
					}
				}
			}
		});

	var InfoForm= new Ext.form.FormPanel({
			frame : true,
			labelWidth: 60,	
			labelAlign : 'right',
			id : "InfoForm",			
			tbar : [searchBT,'-',clearBT],
			items : [{
				xtype:'fieldset',
				title:'查询条件',
				style:DHCSTFormStyle.FrmPaddingV,
				defaults: {border:false},    // Default config options for child items
				layout: 'column',    // Specifies that the items will now be arranged in columns
				items:[{ 				
					columnWidth: 0.33,
	            	xtype: 'fieldset',	            	
	            	autoHeight: true,
	            	items: [PhaLoc,fVendor]					
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
	var findWin = new Ext.Window({
			layout : 'border',
			height:document.body.clientHeight*0.9,	
			width:document.body.clientWidth*0.9,
			minWidth:document.body.clientWidth*0.5,	
			minHeight:document.body.clientHeight*0.5,
			title : '依据入库单退货',
		    plain:true,
		    modal:true,
			items : [            // create instance immediately
	            {
	                region: 'north',
	                height: DHCSTFormStyle.FrmHeight(1), // give north and south regions a height
	                layout: 'fit', // specify layout manager for items
	                items:InfoForm
	            }, {
	                region: 'west',
	                title: '入库单--<font color=blue>深粉色代表该入库单货到票未到</font>',
	                collapsible: true,
	                split: true,
	                width: document.body.clientWidth*0.8*0.3,
	                minSize: document.body.clientWidth*0.8*0.1,
	                maxSize: document.body.clientWidth*0.8*0.8,
	                margins: '0 5 0 0',
	                layout: 'fit', // specify layout manager for items
	                items: GrMasterInfoGrid       
	               
	            }, {
	                region: 'center',
	                title: '入库单明细',
	                layout: 'fit', // specify layout manager for items
	                items: GrDetailInfoGrid       
	               
	            }
   			]			
	});
	//显示窗口
	findWin.show();
	GrMasterInfoGrid.on('rowdblclick',function(grid,rowIndex,e){
		var IngrId=GrMasterInfoStore.data.items[rowIndex].data["IngrId"];
		//alert(IngrId)
		SelectRec(IngrId);
		IngDretDetailGridDs.load({params:{start:0,limit:999,sort:'ingri',dir:'desc',ret:IngrId,type:'G'}});
		findWin.close();
	});
	RefreshGridColSet(GrMasterInfoGrid,"DHCSTIMPORT");   //根据自定义列设置重新配置列
	RefreshGridColSet(GrDetailInfoGrid,"DHCSTIMPORT");   //根据自定义列设置重新配置列


} 