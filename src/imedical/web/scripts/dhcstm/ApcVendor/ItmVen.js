// 名称:供应商供应项目维护
// 编写日期:2013-05-2
var currVendorRowId='';
var gUserId = session['LOGON.USERID'];	
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
var APCVendorGridUrl="dhcstm.itmvenaction.csp"

// 类组
var StkGrpType=new Ext.ux.StkGrpComboBox({ 
	id : 'StkGrpType',
	name : 'StkGrpType',
	StkType:App_StkTypeCode,     //标识类组类型
	LocId:gLocId,
	UserId:gUserId,
	anchor:'90%'
});
//供应商 
var conditionNameField = new Ext.ux.VendorComboBox({
	id:'conditionNameField',
	fieldLabel:'供应商名称',
	params : {ScgId : 'StkGrpType'},
	allowBlank:true,
	valueField : 'RowId',
	displayField : 'Description',
	emptyText:'供应商名称...',
	anchor:'90%'
});

//调用药品窗体并返回结果
function GetPhaOrderInfo(item, group) {				
	if (item != null && item.length > 0) {
	    GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",getDrugList);
	}
}
	
// 返回方法
function getDrugList(record) {
	if (record == null || record == "") {
		return;
	}
	var inciDr = record.get("InciDr");
	var inciCode=record.get("InciCode");
	var inciDesc=record.get("InciDesc");
	var conditionNameField=Ext.getCmp("conditionNameField").getValue();
	var cell = APCVendorGrid.getSelectionModel().getSelectedCell();
	// 选中行
	var row = cell[0];
	var rowData = APCVendorGrid.getStore().getAt(row);
	rowData.set("IncId",inciDr);
	rowData.set("MCode",inciCode);
	rowData.set("MDesc",inciDesc);
	rowData.set("Vendor",conditionNameField);
	var Params=session['LOGON.GROUPID']+'^'+session['LOGON.CTLOCID']+'^'+gUserId;	
	var url = DictUrl
				+ "ingdrecaction.csp?actiontype=GetItmInfo";
	Ext.Ajax.request({
				url : url,
				params : {IncId:inciDr,Params:Params},
				method : 'POST',
				waitMsg : '查询中...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						var data=jsonData.info.split("^");
						addComboData(PhManufacturerStore, data[0], data[1]);
						rowData.set("PhManf", data[0]);
					}
				},
				scope : this
			});

	//光标跳到配送商
	var colIndex=GetColIndex(APCVendorGrid,'Carrier');
	APCVendorGrid.startEditing(row, colIndex);			
}
//配送商
var Carrier = new Ext.ux.ComboBox({
	fieldLabel : '招标配送商',
	id : 'INFOPbCarrier',
	name : 'INFOPbCarrier',
	store : CarrierStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'CADesc'
});

// 生产厂商
var Phmnf = new Ext.ux.ComboBox({
	fieldLabel : '生产厂商',
	id : 'Phmnf',
	name : 'Phmnf',
	anchor : '90%',
	store : PhManufacturerStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'PHMNFName',
	params : {ScgId : 'StkGrpType'}
});

//质量层次
INFOQualityLevelStore.load();
var QutyLevel = new Ext.ux.ComboBox({
	fieldLabel : '质量层次',
	id : 'INFOQualityLevel',
	name : 'INFOQualityLevel',
	anchor : '90%',
	store : INFOQualityLevelStore,
	valueField : 'RowId',
	displayField : 'Description'
});

var findAPCVendor = new Ext.Toolbar.Button({
	text:'查询',
	tooltip:'查询',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		Query();
	}
});

var addAPCVendor = new Ext.Toolbar.Button({
	text:'新建',
	tooltip:'新建',
	iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		APCVendorGrid.store.removeAll();
		APCVendorPagingToolbar.getComponent(4).setValue(1);   //设置当前页码
		APCVendorPagingToolbar.getComponent(5).setText("页,共 1 页");//设置共几页
		APCVendorPagingToolbar.getComponent(12).setText("没有记录"); //设置记录条数
		addNewRow();
	}
});
var SaveBT = new Ext.Toolbar.Button({
	id : "SaveBT",
	text : '保存',
	tooltip : '点击保存',
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
		// 保存
		saveOrder();
	}
});

//删除按钮
var deleteMarkType = new Ext.Toolbar.Button({
    text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
    width : 70,
    height : 30,
    handler:function(){
	    deleteDetail();
	}
});
			
var Win = new Ext.grid.CheckColumn({
    header:'是否中标标志',
    dataIndex:'Win',
    width:80,
    sortable:true
});
var RecPurMark = new Ext.grid.CheckColumn({
    header:'备案采购标志',
    dataIndex:'RecPurMark',
    width:80,
    sortable:true
});
//模型
var nm = new Ext.grid.RowNumberer();
var APCVendorGridCm = new Ext.grid.ColumnModel([nm, {
			header : "RowId",
			dataIndex : 'RowId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : "IncRowid",
			dataIndex : 'IncId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : "物资代码",
			dataIndex : 'MCode',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			header : "物资名称",
			dataIndex : 'MDesc',
			width : 120,
			align : 'left',
			sortable : true,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
						selectOnFocus : true,
						allowBlank : false,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var Vendor = Ext.getCmp("conditionNameField").getValue();
									if (Vendor == "") {
										Msg.info("warning", "供应商不能为空!");
										return;
									}
									var group = Ext.getCmp("StkGrpType").getValue();
									GetPhaOrderInfo(field.getValue(), group);
								}
							}
						}
					}))
		}, {
			header : "供应商",
			dataIndex : 'Vendor',
			width : 250,
			align : 'left',
			sortable : true,
			renderer : Ext.util.Format.comboRenderer2(conditionNameField, "Vendor", "VendorDesc")
		}, {
			header : "厂商",
			dataIndex : 'PhManf',
			width : 250,
			align : 'left',
			sortable : true,
			editable : false,
			renderer : Ext.util.Format.comboRenderer2(Phmnf, "PhManf", "PhManfDesc"),
			editor : new Ext.grid.GridEditor(Phmnf, new Ext.form.TextField({
								selectOnFocus : true,
								listeners : {
									specialkey : function(field, e) {
										if (e.getKey() == Ext.EventObject.ENTER) {
											var cell = APCVendorGrid.getSelectionModel().getSelectedCell();
											var record = APCVendorGrid.getStore().getAt(cell[0]);
											var colIndex = GetColIndex(APCVendorGrid, 'StartDate');
											APCVendorGrid.startEditing(cell[0],colIndex);
										}
									}
								}
							}))
		}, {
			header : "配送商",
			dataIndex : 'Carrier',
			width : 250,
			align : 'left',
			sortable : true,
			renderer : Ext.util.Format.comboRenderer2(Carrier, "Carrier",
					"CarrierDesc"),
			editor : new Ext.grid.GridEditor(Carrier, new Ext.form.TextField({
								selectOnFocus : true,
								listeners : {
									specialkey : function(field, e) {
										if (e.getKey() == Ext.EventObject.ENTER) {
											var cell = APCVendorGrid.getSelectionModel().getSelectedCell();
											var record = APCVendorGrid.getStore().getAt(cell[0]);
											var colIndex = GetColIndex(APCVendorGrid, 'StartDate');
											APCVendorGrid.startEditing(cell[0],colIndex);
										}
									}
								}
							}))
		}, {
			header : "开始日期",
			dataIndex : 'StartDate',
			width : 100,
			align : 'left',
			sortable : true,
			renderer : Ext.util.Format.dateRenderer(DateFormat),
			editor : new Ext.ux.DateField({
				selectOnFocus : true,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var cell = APCVendorGrid.getSelectionModel().getSelectedCell();
							var record = APCVendorGrid.getStore().getAt(cell[0]);
							var colIndex = GetColIndex(APCVendorGrid, 'EndDate');
							APCVendorGrid.startEditing(cell[0], colIndex);
						}
					}
				}
			})
		}, {
			header : "截止日期",
			dataIndex : 'EndDate',
			width : 100,
			align : 'left',
			sortable : true,
			renderer : Ext.util.Format.dateRenderer(DateFormat),
			editor : new Ext.ux.DateField({
						selectOnFocus : true,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var cell = APCVendorGrid.getSelectionModel().getSelectedCell();
									var record = APCVendorGrid.getStore()
											.getAt(cell[0]);
									var SDate = record.get("StartDate")// .format(ARG_DATEFORMAT)
									var EDate = field.getValue()// .format(ARG_DATEFORMAT);
									if ((SDate != "") & (EDate != "")) {
										if (EDate.format(ARG_DATEFORMAT) < SDate.format(ARG_DATEFORMAT)) {
											Msg.info("warning","截止日期不能小于开始日期!");
											return;
										}
									}
									// alert(EDate)
									var colIndex = GetColIndex(APCVendorGrid,'BeforeRp');
									APCVendorGrid.startEditing(cell[0],colIndex);
								}
							}
						}
					})
		}, {
			header : "中标前进价",
			dataIndex : 'BeforeRp',
			width : 80,
			align : 'left',
			sortable : true,
			editor : new Ext.form.NumberField({
				selectOnFocus : true,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var cell = APCVendorGrid.getSelectionModel().getSelectedCell();
							var record = APCVendorGrid.getStore().getAt(cell[0]);
							var colIndex = GetColIndex(APCVendorGrid, 'DealRp');
							APCVendorGrid.startEditing(cell[0], colIndex);
						}
					}
				}
			})
		}, {
			header : "协议进价",
			dataIndex : 'DealRp',
			width : 80,
			align : 'left',
			sortable : true,
			editor : new Ext.form.NumberField({
						selectOnFocus : true,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var cell = APCVendorGrid.getSelectionModel().getSelectedCell();
									var record = APCVendorGrid.getStore().getAt(cell[0]);
									var colIndex = GetColIndex(APCVendorGrid,'BeforeSp');
									APCVendorGrid.startEditing(cell[0],colIndex);
								}
							}
						}
					})
		}, {
			header : "中标前售价",
			dataIndex : 'BeforeSp',
			width : 80,
			align : 'left',
			sortable : true,
			editor : new Ext.form.NumberField({
				selectOnFocus : true,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var cell = APCVendorGrid.getSelectionModel().getSelectedCell();
							var record = APCVendorGrid.getStore().getAt(cell[0]);
							var colIndex = GetColIndex(APCVendorGrid, 'DealSp');
							APCVendorGrid.startEditing(cell[0], colIndex);
						}
					}
				}
			})
		}, {
			header : '协议售价',
			dataIndex : 'DealSp',
			width : 80,
			align : 'left',
			sortable : true,
			editor : new Ext.form.NumberField({
						selectOnFocus : true,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var cell = APCVendorGrid.getSelectionModel().getSelectedCell();
									var record = APCVendorGrid.getStore().getAt(cell[0]);
									var colIndex = GetColIndex(APCVendorGrid,'QutyLevel');
									APCVendorGrid.startEditing(cell[0],colIndex);
								}
							}
						}
					})
		}, {
			header : '质量层次',
			dataIndex : 'QutyLevel',
			width : 100,
			align : 'left',
			sortable : true,
			renderer : Ext.util.Format.comboRenderer(QutyLevel),
			editor : new Ext.grid.GridEditor(QutyLevel, new Ext.form.TextField(
							{
								selectOnFocus : true,
								allowBlank : false,
								listeners : {
									specialkey : function(field, e) {
										if (e.getKey() == Ext.EventObject.ENTER) {
											var cell = APCVendorGrid.getSelectionModel().getSelectedCell();
											var record = APCVendorGrid.getStore().getAt(cell[0]);
											var colIndex = GetColIndex(APCVendorGrid, 'HighSp');
											APCVendorGrid.startEditing(cell[0],colIndex);
										}
									}
								}
							}))
		}, {
			header : '最高售价',
			dataIndex : 'HighSp',
			width : 80,
			align : 'left',
			sortable : true,
			editor : new Ext.form.NumberField({
						selectOnFocus : true,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var cell = APCVendorGrid.getSelectionModel().getSelectedCell();
									var record = APCVendorGrid.getStore().getAt(cell[0]);
									var colIndex = GetColIndex(APCVendorGrid,'Num');
									APCVendorGrid.startEditing(cell[0],colIndex);
								}
							}
						}
					})
		}, {
			header : '本轮招标次数',
			dataIndex : 'Num',
			width : 80,
			align : 'left',
			sortable : true,
			editor : new Ext.form.NumberField({
				selectOnFocus : true,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var cell = APCVendorGrid.getSelectionModel().getSelectedCell();
							var record = APCVendorGrid.getStore().getAt(cell[0]);
							var colIndex = GetColIndex(APCVendorGrid, 'Remark');
							APCVendorGrid.startEditing(cell[0], colIndex);
						}
					}
				}
			})
		}, {
			header : '类别',
			dataIndex : 'Sort',
			width : 150,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '备注',
			dataIndex : 'Remark',
			width : 150,
			align : 'left',
			sortable : true,
			editor : new Ext.form.TextField({
						selectOnFocus : true,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									addNewRow()
								}
							}
						}
					})
		}, Win, RecPurMark]);

//初始化默认排序功能
APCVendorGridCm.defaultSortable = true;

function addNewRow() {
	var NewRecord = CreateRecordInstance(APCVendorGridDs.fields,{})
    APCVendorGridDs.add(NewRecord);
    var col = GetColIndex(APCVendorGrid,'MDesc');
    APCVendorGrid.startEditing(APCVendorGridDs.getCount() - 1, col);
}

// 访问路径
var DetailUrl =DictUrl+
	'itmvenaction.csp?actiontype=Query';
// 通过AJAX方式调用后台数据
var proxy = new Ext.data.HttpProxy({
			url : DetailUrl,
			method : "POST"
	});
		
// 指定列参数
var fields = ["RowId", "IncId", "MDesc","Vendor","VendorDesc","Carrier","CarrierDesc","PhManf","PhManfDesc",{name:'StartDate',type:'date',dateFormat:DateFormat},
	{name:'EndDate',type:'date',dateFormat:DateFormat},"BeforeRp","DealRp","BeforeSp","DealSp",
	"QutyLevel","HighSp","Num","Sort","Remark","Win","RecPurMark","MCode"];
	
// 支持分页显示的读取方式
var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "RowId",
		fields : fields
});
// 数据集
var APCVendorGridDs = new Ext.data.Store({
		proxy : proxy,
		reader : reader
});

//保存供应项目明细
function saveOrder(){
	var Vendor=Ext.getCmp("conditionNameField").getValue();
	var ListDetail="";
	var rowCount = APCVendorGrid.getStore().getCount();
	for (var i = 0; i < rowCount; i++) {
		var rowData = APCVendorGridDs.getAt(i);
		//新增或数据发生变化时执行下述操作
		if(rowData.data.newRecord || rowData.dirty){
			var RowId=rowData.get("RowId"); 
			var IncId=rowData.get("IncId");
			var MDesc=rowData.get("MDesc");	
			var Carrier=rowData.get("Carrier");	
			var PhManf=rowData.get("PhManf");
			var StartDate =Ext.util.Format.date(rowData.get("StartDate"),ARG_DATEFORMAT);
			var EndDate =Ext.util.Format.date(rowData.get("EndDate"),ARG_DATEFORMAT);
			var BeforeRp=rowData.get("BeforeRp");
			var DealRp=rowData.get("DealRp");
			var BeforeSp=rowData.get("BeforeSp");
			var DealSp=rowData.get("DealSp");
			var QutyLevel=rowData.get("QutyLevel");
			var HighSp=rowData.get("HighSp");
			var Num=rowData.get("Num");
			var Sort=rowData.get("Sort");  
			var Remark=rowData.get("Remark");    
			var Win=rowData.get("Win");  
			var RecPurMark=rowData.get("RecPurMark");
			//alert("StartDate="+Vendor)
			var str= Vendor + "^" + IncId+"^"+Carrier+"^"+PhManf+"^"+StartDate+"^"+EndDate+"^"+BeforeRp+"^"
				    +DealRp+"^"+BeforeSp+"^"+DealSp+"^"+ QutyLevel+"^"+ HighSp+"^"+Num +"^"+Sort+"^"+ Remark +"^"+ Win +"^"+RecPurMark+"^"+RowId
				
			if(ListDetail==""){
				ListDetail=str;
			}else{
				ListDetail=ListDetail+RowDelim+str;
			}
		}
	}
	                   
	if(ListDetail==""){
		Msg.info("error","没有修改或添加新数据!");
		return false;
	}else{
		var url = DictUrl+"itmvenaction.csp?actiontype=Save";
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			params:{ListDetail:ListDetail},
			waitMsg : '处理中...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
							.decode(result.responseText);
				mask.hide();		
				if (jsonData.success == 'true') {
					// 刷新界面
					var IngrRowid = jsonData.info;
					Msg.info("success", "保存成功!");
					Query();
					//APCVendorGridDs.load();
				}else{
					var ret=jsonData.info;
					if (ret=-100){
						Msg.info("warning","该供应商的该物资已经维护");
						return;
					}else{
						Msg.info("error", "部分明细保存不成功："+ret);
					}
				}
			},
			scope : this
		});
	}
}

//查询函数
function Query(){
	var Vendor=Ext.getCmp("conditionNameField").getValue();
	var Stkcat=Ext.getCmp("StkGrpType").getValue();
	APCVendorGridDs.setBaseParam('Vendor',Vendor);
	APCVendorGridDs.setBaseParam('Stkcat',Stkcat);
	APCVendorGridDs.removeAll();
	APCVendorGridDs.load({
		params:{start:0,limit:APCVendorPagingToolbar.pageSize},
		callback:function(r,options,success){
			if(success==false){
				Msg.info("error","查询有误, 请查看日志!");
			}
		}
	});
}
function deleteDetail(){
	var cell = APCVendorGrid.getSelectionModel().getSelectedCell();
	if(cell==null){
		Msg.info("error","请选择数据!");
		return false;
	}else{
		var record = APCVendorGrid.getStore().getAt(cell[0]);
		var RowId = record.get("RowId");
		if (RowId!=""){
			Ext.MessageBox.confirm('提示','确定要删除选定的行?',function(btn){
				if(btn=="yes"){
					var url = DictUrl+"itmvenaction.csp?actiontype=Delete&rowid="+RowId;
					var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
					Ext.Ajax.request({
						url:url,
						waitMsg:'删除中...',
						failure: function(result, request) {
							Msg.info("error","请检查网络连接!");
							mask.hide();
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							mask.hide();
							if (jsonData.success=='true') {
								Msg.info("success","删除成功!");
									var Vendor=Ext.getCmp("conditionNameField").getValue();
									Query(Vendor)
							}else{
								Msg.info("error","删除失败!");
							}
						},
						scope: this
					});
				}
			})
		}else{
			var rowInd=cell[0];      
			if (rowInd>=0){
				APCVendorGrid.getStore().removeAt(rowInd);
			}
		}
	}   
}

var editAPCVendor = new Ext.Toolbar.Button({
	text:'编辑',
    tooltip:'编辑',
    iconCls:'page_edit',
	width : 70,
	height : 30,
	handler:function(){
		var rowindex = APCVendorGrid.getSelectionModel().getSelectedCell()[0]; 
		var rowObj=APCVendorGrid.getStore().getAt(rowindex)
		var len = rowObj.length;
		if(len < 1){
			Msg.info("error","请选择数据!");
			return false;
		}else{
			var IncId = rowObj.get('IncId');
			var PhManf = rowObj.get('PhManf');
			var list=IncId+"^"+PhManf;
			if (PhManf==""){
				Msg.info("warning","因厂商为空,不能显示厂商资质信息!");
				return;
			}else if (IncId==""){
				Msg.info("warning","物资名称不能为空!");
				return;
			}
			//窗口显示
			CreateEditWin(list);
		}
	}
});
 
var formPanel = new Ext.ux.FormPanel({
	title:'供应商供货列表维护',
    tbar:[findAPCVendor,'-',addAPCVendor,'-',SaveBT,'-',deleteMarkType],
	items : [{
		xtype : 'fieldset',
		title : '查询条件',
		layout : 'column',	
		style : 'padding:5px 0px 0px 5px',
		defaults:{border:false,xtype:'fieldset'},		
		items : [{
				columnWidth : .33,
				items : [StkGrpType]
			}, {
				columnWidth : .33,
				items : [conditionNameField]
			}]
	}]

});

//分页工具栏
var APCVendorPagingToolbar = new Ext.PagingToolbar({
	store:APCVendorGridDs,
	pageSize:30,
	displayInfo:true,
	displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条'
});

//表格
APCVendorGrid = new Ext.grid.EditorGridPanel({
	store:APCVendorGridDs,
	cm:APCVendorGridCm,
	title:'供应项目明细',
	trackMouseOver:true,
	clicksToEdit:0,
	region:'center',
	height:690,
	stripeRows:true,
	plugins:[Win,RecPurMark],
    sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	bbar:APCVendorPagingToolbar,
   	listeners:{
		'rowdblclick':function(){
			editAPCVendor.handler();
		}
	}
});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,APCVendorGrid],
		renderTo:'mainPanel'
	});
	Query()
});