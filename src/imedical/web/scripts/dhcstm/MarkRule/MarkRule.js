// 名称:定价规则
// 编写日期:2012-06-5
var mrId = "";

var SDCommStore = new Ext.data.JsonStore({
	url : 'dhcstm.drugutil.csp?actiontype=StkDecimal',
	totalProperty : "results",
	root : 'rows',
	fields : ['Description', 'RowId']
});

var SDComm = new Ext.form.ComboBox({
	fieldLabel : '小数规则',
	id : 'SDComm',
	name : 'SDComm',
	anchor : '90%',
	width : 120,
	store : SDCommStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : '小数规则...',
	selectOnFocus : true,
	forceSelection : true,
	listWidth : 200,
	valueNotFoundText : '',
	listeners:{
		specialKey:function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 10);			
			}
		}
	}
});

var MTCommStore = new Ext.data.JsonStore({
	url : 'dhcstm.drugutil.csp?actiontype=MarkType',
	totalProperty : "results",
	root : 'rows',
	fields : ['Description', 'RowId']
});

var MTComm = new Ext.form.ComboBox({
	fieldLabel : '定价类型',
	id : 'MTComm',
	name : 'MTComm',
	anchor : '90%',
	width : 120,
	store : MTCommStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : '定价类型...',
	selectOnFocus : true,
	forceSelection : true,
	listWidth : 200,
	valueNotFoundText : '',
	listeners:{
		specialKey:function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 12);			
			}
		}
	}
});

var UFlag = new Ext.grid.CheckColumn({
	header:'是否使用',
	dataIndex:'UseFlag',
	width:100,
	sortable:true
});

var MarkRuleGrid="";
//配置数据源
var MarkRuleGridUrl = 'dhcstm.markruleaction.csp';
var MarkRuleGridProxy= new Ext.data.HttpProxy({url:MarkRuleGridUrl+'?actiontype=selectAll',method:'GET'});
var MarkRuleGridDs = new Ext.data.Store({
	pruneModifiedRecords : true,
	proxy:MarkRuleGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows'
	}, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'},
		{name:'MinRp'},
		{name:'MaxRp'},
		{name:'Margin'},
		{name:'MPrice'},
		{name:'MaxMargin'},
		{name:'MaxMPrice'},
		{name:'SdDr'},
		{name:'SdDesc'},
		{name:'MtDr'},
		{name:'MtDesc'},
		{name:'UseFlag'},
		{name:'Remark'}
	]),
	pruneModifiedRecords:true,
	remoteSort:false
});

//模型
var MarkRuleGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:"代码",
		dataIndex:'Code',
		width:80,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({
			id:'codeField',
			allowBlank:false,
			selectOnFocus:true,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 2);
					}
				}
			}
		})
	},{
		header:"名称",
		dataIndex:'Desc',
		width:80,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({
			id:'descField',
			selectOnFocus:true,
			allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 3);
					}
				}
			}
		})
	},{
		header:"规则下限",
		dataIndex:'MinRp',
		width:80,
		align:'right',
		sortable:true,
		editor: new Ext.form.NumberField({
			id:'minRpField',
			selectOnFocus:true,
			decimalPrecision:4,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 4);
					}
				}
			}
		})
	},{
		header:"规则上限",
		dataIndex:'MaxRp',
		width:80,
		align:'right',
		sortable:true,
		editor: new Ext.form.NumberField({
			id:'maxRpField',
			selectOnFocus:true,
			decimalPrecision:4,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 5);
					}
				}
			}
		})
	},{
		header:"加成率",
		dataIndex:'Margin',
		width:80,
		align:'right',
		sortable:true,
		editor: new Ext.form.NumberField({
			id:'marginField',
			selectOnFocus:true,
			decimalPrecision:4,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 6);
					}
				}
			}
		})
	},{
		header:"加成额",
		dataIndex:'MPrice',
		width:80,
		align:'right',
		sortable:true,
		editor: new Ext.form.NumberField({
			id:'mPriceField',
			selectOnFocus:true,
			decimalPrecision:4,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 7);
					}
				}
			}
		})
	},{
		header:"最高加成比",
		dataIndex:'MaxMargin',
		width:80,
		align:'right',
		sortable:true,
		editor: new Ext.form.NumberField({
			id:'maxMarginField',
			selectOnFocus:true,
			decimalPrecision:4,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 8);
					}
				}
			}
		})
	},{
		header:"最高加成额",
		dataIndex:'MaxMPrice',
		width:80,
		align:'right',
		sortable:true,
		editor: new Ext.form.NumberField({
			id:'maxMPriceField',
			selectOnFocus:true,
			decimalPrecision:4,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 9);
					}
				}
			}
		})
	},{
		header:"小数规则",
		//dataIndex:'SdDesc',
		dataIndex:'SdDr',
		width:80,
		align:'left',
		sortable:true,
		renderer : Ext.util.Format.comboRenderer2(SDComm,"SdDr","SdDesc"),
		editor:new Ext.grid.GridEditor(SDComm)
	},{
		header:"定价类型",
		//dataIndex:'MtDesc',
		dataIndex:'MtDr',
		width:80,
		align:'left',
		sortable:true,
		renderer : Ext.util.Format.comboRenderer2(MTComm,"MtDr","MtDesc"),
		editor:new Ext.grid.GridEditor(MTComm)
	},UFlag,{
		header:"备注",
		dataIndex:'Remark',
		width:100,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({
			id:'remarkField',
			selectOnFocus:true,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						addNewRow();
					}
				}
			}
		})
	}
]);

//初始化默认排序功能
MarkRuleGridCm.defaultSortable = true;

var addMarkRule = new Ext.Toolbar.Button({
	text:'新建',
	tooltip:'新建',
	iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

function addNewRow() {
	var NewRecord = CreateRecordInstance(MarkRuleGridDs.fields);
	MarkRuleGridDs.add(NewRecord);
	MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 1);
}

var saveMarkRule = new Ext.Toolbar.Button({
	text:'保存',
	tooltip:'保存',
	iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(CheckDataBeforeSave()!=false){
			//获取所有的新记录 
			var mr=MarkRuleGridDs.getModifiedRecords();
			var data="";
			var rows="";
			for(var i=0;i<mr.length;i++){
				var rowid = mr[i].data["RowId"].trim();
				var code = mr[i].data["Code"].trim();
				var desc = mr[i].data["Desc"].trim();
				var minRp = mr[i].data["MinRp"];
				var maxRp = mr[i].data["MaxRp"];
				
				var margin = mr[i].data["Margin"];			//加成率
				var mPrice = mr[i].data["MPrice"];			//加成额
				var maxMargin = mr[i].data["MaxMargin"];	//最高加成率
				var maxMPrice = mr[i].data["MaxMPrice"];	//最高加成额	
				var sd = mr[i].data["SdDr"].trim();
				var mt = mr[i].data["MtDr"].trim();
				var rows=MarkRuleGridDs.indexOf(mr[i])+1;
				if(parseFloat(minRp)>parseFloat(maxRp) && parseFloat(maxRp)!=0){
					Msg.info("warning",'第'+rows+'行规则上限不能小于规则下限！'); 
					return;
				}
				if(margin!=""&&maxMargin!=""&&maxMargin!=0&&parseFloat(margin)>parseFloat(maxMargin)){
					Msg.info("warning",'第'+rows+'行加成率不能大于最高加成率！');
					return;
				}
				if(mPrice!=""&&maxMPrice!=""&&maxMPrice!=0&&parseFloat(mPrice)>parseFloat(maxMPrice)){
					Msg.info("warning",'第'+rows+'行加成额不能大于最高加成额！');
					return;
				}
				if(code==""||desc==""){
					Msg.info("warning",'第'+rows+'行代码和名称不能为空！');
					return;
				}
				if(sd==""||mt==""){
					Msg.info("warning",'第'+rows+'行小数规则和定价类型不能为空！');
					return;
				}
				var remark = mr[i].data["Remark"].trim();
				var useFlag = mr[i].data["UseFlag"];
				var dataRow = rowid+"^"+code+"^"+desc+"^"+maxRp+"^"+minRp
						+"^"+margin+"^"+mt+"^"+remark+"^"+useFlag+"^"+maxMPrice
						+"^"+maxMargin+"^"+mPrice+"^"+sd;
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
			
			if(data!=""){
				var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
				Ext.Ajax.request({
					url: MarkRuleGridUrl+'?actiontype=save',
					params: {data:data},
					failure: function(result, request) {
						mask.hide();
						Msg.info("error","请检查网络连接!");
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						mask.hide();
						if (jsonData.success=='true') {
							Msg.info("success","保存成功!");
							MarkRuleGridDs.reload();
						}else{
							Msg.info("error","保存失败,"+jsonData.info);
						}
					},
					scope: this
				});
			}
		}
	}
});

// 变换行颜色
function changeBgColor(row, color) {
	MarkRuleGrid.getView().getRow(row).style.backgroundColor = color;
}

function CheckDataBeforeSave(){
	//=====判断代码和名称是否重复输入===
	var rowCount = MarkRuleGrid.getStore().getCount();
	for (i=0;i<rowCount-1;i++){
		for(j=i+1;j<rowCount;j++){
			var item_i=MarkRuleGridDs.getAt(i).get("Code");
			var item_j=MarkRuleGridDs.getAt(j).get("Code");
			var item_di=MarkRuleGridDs.getAt(i).get("Desc");
			var item_dj=MarkRuleGridDs.getAt(j).get("Desc");
			if(item_i!=""&&item_j!=""&&item_i==item_j){
				changeBgColor(i, "yellow");
				changeBgColor(j, "yellow");
				Msg.info("warning","代码输入重复!");
				return false;
			}
			if(item_di!=""&&item_dj!=""&&item_di==item_dj){
				changeBgColor(i, "yellow");
				changeBgColor(j, "yellow");
				Msg.info("warning","名称输入重复!");
				return false;
			}
		}
	}
}

var deleteMarkRule = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = MarkRuleGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error","请选择数据!");
			return false;
		}else{
			var record = MarkRuleGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			//alert(RowId);
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
							Ext.Ajax.request({
								url:MarkRuleGridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:'删除中...',
								failure: function(result, request) {
									 mask.hide();
									Msg.info("error","请检查网络连接!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									 mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success","删除成功!");
										MarkRuleGridDs.load();
									}else{
										Msg.info("error","删除失败!");
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				//Msg.info("error","数据有错!");
				var rowInd=cell[0];
				if (rowInd>=0) MarkRuleGrid.getStore().removeAt(rowInd);
			}
		}
	}
});

//表格
MarkRuleGrid = new Ext.grid.EditorGridPanel({
	title : '定价规则',
	store:MarkRuleGridDs,
	cm:MarkRuleGridCm,
	trackMouseOver:true,
	height:350,
	stripeRows:true,
	plugins:UFlag,
	clicksToEdit:1,
	region:'north',
	sm:new Ext.grid.CellSelectionModel({
		listeners:{
			cellselect : function(sm,rowIndex,colIndex){
				var selectedRow = MarkRuleGridDs.data.items[rowIndex];
				mrId = selectedRow.data['RowId'];
				if(mrId==""){
					MarkRuleAddGridDs.removeAll();
					return;
				}
				MarkRuleAddGridDs.load({params:{parref:mrId}});
			}
		}
	}),
	loadMask:true,
	tbar:[addMarkRule,'-',saveMarkRule,'-',deleteMarkRule],
	bbar:[{
			xtype:'label',
			text:'售价=进价*(1+加成率)+加成额; 规则上下限:计算售价所依据的进价区间范围; 最高加成比:有别于加成率,指最高加成比例; 上限、加成额、最高加成比、最高加成额为0表示不限制.'
		}
	]
});


var MarkRuleAddGrid="";
//配置数据源
var MarkRuleAddGridProxy= new Ext.data.HttpProxy({url:MarkRuleGridUrl+'?actiontype=selectChild',method:'GET'});
var MarkRuleAddGridDs = new Ext.data.Store({
	proxy:MarkRuleAddGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows'
	}, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'},
		{name:'MinRp'},
		{name:'MaxRp'},
		{name:'Margin'},
		{name:'UseFlag'},
		{name:'Remark'}
	]),
	pruneModifiedRecords : true,
	remoteSort:false
});

var UseFlag = new Ext.grid.CheckColumn({
	header:'是否使用',
	dataIndex:'UseFlag',
	width:100,
	sortable:true
});

//模型
var MarkRuleAddGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:"代码",
		dataIndex:'Code',
		width:80,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({
			id:'codeField1',
			allowBlank:false,
			selectOnFocus:true,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						MarkRuleAddGrid.startEditing(MarkRuleAddGridDs.getCount() - 1, 2);
					}
				}
			}
		})
	},{
		header:"名称",
		dataIndex:'Desc',
		width:80,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({
			id:'descField1',
			allowBlank:false,
			selectOnFocus:true,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						MarkRuleAddGrid.startEditing(MarkRuleAddGridDs.getCount() - 1, 3);
					}
				}
			}
		})
	},{
		header:"下限",
		dataIndex:'MinRp',
		width:80,
		align:'right',
		sortable:true,
		editor: new Ext.form.NumberField({
			id:'minRpField1',
			selectOnFocus:true,
			decimalPrecision:4,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						MarkRuleAddGrid.startEditing(MarkRuleAddGridDs.getCount() - 1, 4);
					}
				}
			}
		})
	},{
		header:"上限",
		dataIndex:'MaxRp',
		width:80,
		align:'right',
		sortable:true,
		editor: new Ext.form.NumberField({
			id:'maxRpField1',
			selectOnFocus:true,
			decimalPrecision:4,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						MarkRuleAddGrid.startEditing(MarkRuleAddGridDs.getCount() - 1, 5);
					}
				}
			}
		})
	},{
		header:"加成率",
		dataIndex:'Margin',
		width:80,
		align:'right',
		sortable:true,
		editor: new Ext.form.NumberField({
			id:'marginField1',
			selectOnFocus:true,
			decimalPrecision:4,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						MarkRuleAddGrid.startEditing(MarkRuleAddGridDs.getCount() - 1, 6);
					}
				}
			}
		})
	},{
		header:"备注",
		dataIndex:'Remark',
		width:80,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({
			id:'remarkField1',
			selectOnFocus:true,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						addRow();
					}
				}
			}
		})
	},UseFlag
]);

//初始化默认排序功能
MarkRuleGridCm.defaultSortable = true;

var addMarkRuleAdd = new Ext.Toolbar.Button({
	text:'新建',
	tooltip:'新建',
	iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		if(mrId==""){
			Msg.info("warning","请先选择定价规则!");
			return;
		}
		addRow();
	}
});

function addRow() {
	var NewRec = CreateRecordInstance(MarkRuleAddGridDs.fields);
	MarkRuleAddGridDs.add(NewRec);
	MarkRuleAddGrid.startEditing(MarkRuleAddGridDs.getCount() - 1, 1);
}

var saveMarkRuleAdd = new Ext.Toolbar.Button({
	text:'保存',
	tooltip:'保存',
	iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(CheckDataBeforeSave2()!=false){
			//获取所有的新记录 
			var mr=MarkRuleAddGridDs.getModifiedRecords();
			var data="";
			var row="";
			for(var i=0;i<mr.length;i++){
				var rowid = mr[i].data["RowId"].trim();
				var code = mr[i].data["Code"].trim();
				var desc = mr[i].data["Desc"].trim();
				var minRp = mr[i].data["MinRp"];
				var maxRp = mr[i].data["MaxRp"];
				var margin = mr[i].data["Margin"];
				var remark = mr[i].data["Remark"].trim();
				var useFlag = mr[i].data["UseFlag"];
				row=MarkRuleAddGridDs.indexOf(mr[i])+1;
				if(code==""){
					Msg.info('warning', '第'+row+'行代码不能为空！'); 
					break;
				}else if(desc==""){
					Msg.info('warning', '第'+row+'行名称不能为空！'); 
					break;
				}else if(parseFloat(minRp)>parseFloat(maxRp) && maxRp!==0){
					Msg.info('warning', '第'+row+'行下限不能高于上限！'); 
					break;
				}
				
				var dataRow = rowid+"^"+mrId+"^"+code+"^"+desc+"^"+maxRp+"^"+minRp+"^"+margin+"^"+remark+"^"+useFlag;
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
			
			if(data!=""){
				var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
				Ext.Ajax.request({
					url: MarkRuleGridUrl+'?actiontype=saveChild',
					params: {data:data},
					failure: function(result, request) {
						 mask.hide();
						Msg.info("error","请检查网络连接!");
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						 mask.hide();
						if (jsonData.success=='true') {
							Msg.info("success","保存成功!");
							MarkRuleAddGridDs.load({params:{parref:mrId}});
						}else{
							Msg.info("error","保存失败!");
						}
					},
					scope: this
				});
			}
		}
	}
});

function CheckDataBeforeSave2(){
	if(mrId==""){
		return false;
	}
	//=====判断代码和名称是否重复输入===
	var rowCount = MarkRuleAddGrid.getStore().getCount();
	for (i=0;i<rowCount-1;i++){
		for(j=i+1;j<rowCount;j++){
			var item_i=MarkRuleAddGridDs.getAt(i).get("Code");
			var item_j=MarkRuleAddGridDs.getAt(j).get("Code");
			var item_di=MarkRuleAddGridDs.getAt(i).get("Desc");
			var item_dj=MarkRuleAddGridDs.getAt(j).get("Desc");
			if(item_i!=""&&item_j!=""&&item_i==item_j){
				changeBgColor(i, "yellow");
				changeBgColor(j, "yellow");
				Msg.info("warning","代码输入重复!!!!");
				return false;
			}
			if(item_di!=""&&item_dj!=""&&item_di==item_dj){
				changeBgColor(i, "yellow");
				changeBgColor(j, "yellow");
				Msg.info("warning","名称输入重复!!!!");
				return false;
			}
		}
	}
}

var deleteMarkRuleAdd = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = MarkRuleAddGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error","请选择数据!");
			return false;
		}else{
			var record = MarkRuleAddGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
							Ext.Ajax.request({
								url:MarkRuleGridUrl+'?actiontype=deleteChild&rowid='+RowId,
								waitMsg:'删除中...',
								failure: function(result, request) {
									 mask.hide();
									Msg.info("error","请检查网络连接!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									 mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success","删除成功!");
										MarkRuleAddGridDs.load({params:{parref:mrId}});
									}else{
										Msg.info("error","删除失败!");
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				//Msg.info("error","数据有错!");
				var rowInd=cell[0];
				if (rowInd>=0) MarkRuleAddGrid.getStore().removeAt(rowInd);
				
			}
		}
	}
});

//表格
MarkRuleAddGrid = new Ext.grid.EditorGridPanel({
	id : 'MarkRuleAddGrid',
	title : '阶梯加成',
	store:MarkRuleAddGridDs,
	cm:MarkRuleAddGridCm,
	trackMouseOver:true,
	height:350,
	stripeRows:true,
	plugins:UseFlag,
	region:'center',
	clicksToEdit:0,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[addMarkRuleAdd,'-',saveMarkRuleAdd,'-',deleteMarkRuleAdd],
	bbar:[{
			xtype:'label',
			text:'售价=进价*(1+加成率); 规则上下限:计算售价所依据的进价区间范围; 上限为0表示不限制.'
		}
	],
	clicksToEdit:1
});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[MarkRuleGrid,MarkRuleAddGrid],
		renderTo:'mainPanel'
	});
	MarkRuleGridDs.load();
});