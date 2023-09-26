var HvMapArcUrl = 'dhcstm.hvmaparcaction.csp';
var HvFlagStore = new Ext.data.SimpleStore({
	fields : ['RowId', 'Description'],
	data : [['Y', '是'], ['N', '否']]
});
var HvFlag = new Ext.form.ComboBox({
		fieldLabel : '高值标志',
		id : 'HvFlag',
		name : 'HvFlag',
		width : 100,
		store : HvFlagStore,
		triggerAction : 'all',
		mode : 'local',
		valueField : 'RowId',
		displayField : 'Description',
		anchor:'90%',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		forceSelection : true,
		minChars : 1,
		editable : true,
		valueNotFoundText : ''
	});
var ARCItemCat = new Ext.ux.ComboBox({
	StkType:'M',
	fieldLabel : '医嘱子类',
	id : 'ARCItemCat',
	name : 'ARCItemCat',
	anchor : '90%',
	width : 120,
	store : ArcItemCatStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	selectOnFocus : true,
	forceSelection : true,
	listWidth : 200,
	valueNotFoundText : '',
	filterName : 'Desc'
});
var ARCBillSub = new Ext.ux.ComboBox({
	fieldLabel : '费用子类',
	id : 'ARCBillSub',
	anchor : '90%',
	store : ArcBillSubStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName : 'Desc',
	allowBlank : false
});
var SubTypeFee = new Ext.ux.ComboBox({
	fieldLabel:'子分类',
	id : 'SubTypeFee',
	name : 'SubTypeFee',
	store : TarSubCateStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'Desc'
});
var InSubTypeFee = new Ext.ux.ComboBox({
	fieldLabel:'住院子分类',
	id : 'InSubTypeFee',
	name : 'InSubTypeFee',
	store : TarInpatCateStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'Desc'
});
var OutSubTypeFee = new Ext.ux.ComboBox({
	fieldLabel :'门诊子分类' ,
	id : 'OutSubTypeFee',
	name : 'OutSubTypeFee',
	store : TarOutpatCateStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName : 'Desc'
});
var AccSubTypeFee = new Ext.ux.ComboBox({
	fieldLabel :'核算子分类',
	id : 'AccSubTypeFee',
	name : 'AccSubTypeFee',
	store : TarEMCCateStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName : 'Desc'
});
var MedSubTypeFee = new Ext.ux.ComboBox({
	fieldLabel :'病历首页分类',
	id : 'MedSubTypeFee',
	name : 'MedSubTypeFee',
	store : TarMRCateStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName : 'Desc'
});
var NewMedSubTypeFee = new Ext.ux.ComboBox({
	fieldLabel :'新病历首页分类',
	id : 'NewMedSubTypeFee',
	name : 'NewMedSubTypeFee',
	store : TarNewMRCateStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName : 'Desc'
});
var AccountSubTypeFee = new Ext.ux.ComboBox({
	fieldLabel :'会计子分类',
	id : 'AccountSubTypeFee',
	name : 'AccountSubTypeFee',
	store : TarAcctCateStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName : 'Desc'
});
var HvMapArcProxy= new Ext.data.HttpProxy({url:HvMapArcUrl+'?actiontype=Query',method:'GET'});
var HvMapArcDs = new Ext.data.Store({
	pruneModifiedRecords : true,
	proxy:HvMapArcProxy,
	reader:new Ext.data.JsonReader({
		root:'rows'
	}, [
		{name:'HMARowId'},
		{name:'HvRowId'},
		{name:'HvDescription'},
		{name:'ArRowId'},
		{name:'ArDescription'},
		{name:'BiRowId'},
		{name:'BiDescription'},
		{name:'SubTRowId'},
		{name:'SubTDescription'},
		{name:'InSubTRowId'},
		{name:'InSubTDescription'},
		{name:'OutSubTRowId'},
		{name:'OutSubTDescription'},
		{name:'ASubTRowId'},
		{name:'ASubTDescription'},
		{name:'MedRowId'},
		{name:'MedDescription'},
		{name:'NewMedRowId'},
		{name:'NewMedDescription'},
		{name:'ASTRowId'},
		{name:'ASTDescription'}
	]),
	remoteSort:false
});

//模型
var HvMapArcCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:"HMARowId",
		dataIndex:'HMARowId',
		hidden : true,
		width:80
	},{
		header:"高值标志",
		dataIndex:'HvRowId',
		width:180,
		align:'left',
		sortable:true,
		renderer : Ext.util.Format.comboRenderer2(HvFlag,"HvRowId","HvDescription"),
		editor:new Ext.grid.GridEditor(HvFlag)
	},{
		header:"医嘱子类",
		dataIndex:'ArRowId',
		width:180,
		align:'left',
		sortable:true,
		renderer : Ext.util.Format.comboRenderer2(ARCItemCat,"ArRowId","ArDescription"),
		editor:new Ext.grid.GridEditor(ARCItemCat)
	},{
		header:"费用子类",
		dataIndex:'BiRowId',
		width:180,
		align:'left',
		sortable:true,
		renderer : Ext.util.Format.comboRenderer2(ARCBillSub,"BiRowId","BiDescription"),
		editor:new Ext.grid.GridEditor(ARCBillSub)
	},{
		header:"子分类",
		dataIndex:'SubTRowId',
		width:180,
		align:'left',
		sortable:true,
		renderer : Ext.util.Format.comboRenderer2(SubTypeFee,"SubTRowId","SubTDescription"),
		editor:new Ext.grid.GridEditor(SubTypeFee)
	},{
		header:"住院子分类",
		dataIndex:'InSubTRowId',
		width:180,
		align:'left',
		sortable:true,
		renderer : Ext.util.Format.comboRenderer2(InSubTypeFee,"InSubTRowId","InSubTDescription"),
		editor:new Ext.grid.GridEditor(InSubTypeFee)
	},{
		header:"门诊子分类",
		dataIndex:'OutSubTRowId',
		width:180,
		align:'left',
		sortable:true,
		renderer : Ext.util.Format.comboRenderer2(OutSubTypeFee,"OutSubTRowId","OutSubTDescription"),
		editor:new Ext.grid.GridEditor(OutSubTypeFee)
	},{
		header:"核算子分类",
		dataIndex:'ASubTRowId',
		width:180,
		align:'left',
		sortable:true,
		renderer : Ext.util.Format.comboRenderer2(AccSubTypeFee,"ASubTRowId","ASubTDescription"),
		editor:new Ext.grid.GridEditor(AccSubTypeFee)
	},{
		header:"病历首页分类",
		dataIndex:'MedRowId',
		width:180,
		align:'left',
		sortable:true,
		renderer : Ext.util.Format.comboRenderer2(MedSubTypeFee,"MedRowId","MedDescription"),
		editor:new Ext.grid.GridEditor(MedSubTypeFee)
	},{
		header:"新病历首页分类",
		dataIndex:'NewMedRowId',
		width:180,
		align:'left',
		sortable:true,
		renderer : Ext.util.Format.comboRenderer2(NewMedSubTypeFee,"NewMedRowId","NewMedDescription"),
		editor:new Ext.grid.GridEditor(NewMedSubTypeFee)
	},{
		header:"会计子分类",
		dataIndex:'ASTRowId',
		width:180,
		align:'left',
		sortable:true,
		renderer : Ext.util.Format.comboRenderer2(AccountSubTypeFee,"ASTRowId","ASTDescription"),
		editor:new Ext.grid.GridEditor(AccountSubTypeFee)
	}
]);

//初始化默认排序功能
HvMapArcCm.defaultSortable = true;

var addMarkRule = new Ext.ux.Button({
	text:'新建',
	tooltip:'新建',
	iconCls:'page_add',
	handler:function(){
		addNewRow();
	}
});

function addNewRow() {
	var NewRecord = CreateRecordInstance(HvMapArcDs.fields);
	HvMapArcDs.add(NewRecord);
	HvMapArcGrid.startEditing(HvMapArcDs.getCount() - 1, 2);
}

var saveMarkRule = new Ext.Toolbar.Button({
	text:'保存',
	tooltip:'保存',
	iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
			//获取所有的新记录 
			if(HvMapArcGrid.activeEditor!=null){HvMapArcGrid.activeEditor.completeEdit();}
			var mr=HvMapArcDs.getModifiedRecords();
			var data="";
			for(var i=0;i<mr.length;i++){
				var HMARowId = mr[i].data["HMARowId"];
				var HvRowId = mr[i].data["HvRowId"];
				var ArRowId = mr[i].data["ArRowId"];
				var BiRowId = mr[i].data["BiRowId"];
				var SubTRowId = mr[i].data["SubTRowId"];
				var InSubTRowId = mr[i].data["InSubTRowId"];
				var OutSubTRowId = mr[i].data["OutSubTRowId"];
				var ASubTRowId = mr[i].data["ASubTRowId"];
				var MedRowId = mr[i].data["MedRowId"];
				var NewMedRowId = mr[i].data["NewMedRowId"];
				var ASTRowId = mr[i].data["ASTRowId"];
				var row=HvMapArcDs.indexOf(mr[i])+1;
				if(HvRowId==""||ArRowId==""||BiRowId==""){
					Msg.info("warning",'第'+row+'行不能有空！');
					return;
				}
				var dataRow = HMARowId+"^"+HvRowId+"^"+ArRowId+"^"+BiRowId+"^"+
				SubTRowId+"^"+InSubTRowId+"^"+OutSubTRowId+"^"+ASubTRowId+"^"+MedRowId+"^"+NewMedRowId+"^"+
				ASTRowId
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
			if(data!=""){
				var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
				Ext.Ajax.request({
					url: HvMapArcUrl+'?actiontype=save',
					params: {ListDetail:data},
					failure: function(result, request) {
						mask.hide();
						Msg.info("error","请检查网络连接!");
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						mask.hide();
						if (jsonData.success=='true') {
							Msg.info("success","保存成功!");
							HvMapArcDs.reload();
						}else{
							Msg.info("error","保存失败,"+jsonData.info);
						}
					},
					scope: this
				});
			}
	}
});

var deleteMarkRule = new Ext.ux.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'page_delete',
	handler:function(){
		var cell = HvMapArcGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error","请选择数据!");
			return false;
		}else{
			var record = HvMapArcGrid.getStore().getAt(cell[0]);
			var RowId = record.get("HMARowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
							Ext.Ajax.request({
								url:HvMapArcUrl+'?actiontype=delete&RowId='+RowId,
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
										HvMapArcDs.load();
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
				var rowInd=cell[0];
				if (rowInd>=0) HvMapArcGrid.getStore().removeAt(rowInd);
			}
		}
	}
});

//表格
HvMapArcGrid = new Ext.grid.EditorGridPanel({
	title : '高值标志 医嘱分类 费用分类 收费项目分类 关联',
	store:HvMapArcDs,
	cm:HvMapArcCm,
	trackMouseOver:true,
	stripeRows:true,
	clicksToEdit:1,
	sm:new Ext.grid.CellSelectionModel({
	}),
	loadMask:true,
	tbar:[addMarkRule,'-',saveMarkRule,'-',deleteMarkRule]
});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'fit',
		items:[HvMapArcGrid]
	});
	HvMapArcDs.load();
});