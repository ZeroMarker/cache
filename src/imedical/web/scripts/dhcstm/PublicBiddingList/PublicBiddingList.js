// 名称:招标轮次维护
// 编写日期:2017-08-10
// 姓名:zhangxiao

var Url="dhcstm.publicbiddinglistaction.csp"
//招标轮次维护
function addNewRow(){
	var DefaValue = {ActiveFlag:'Y'};
	var NewRecord = CreateRecordInstance(PublicBiddingListGrids.fields, DefaValue);
	PublicBiddingListGrids.add(NewRecord);
	var col = GetColIndex(PublicBiddingListGrid, 'Code');
	PublicBiddingListGrid.startEditing(PublicBiddingListGrids.getCount()-1, col);
}
//配置数据源
var Proxy=new Ext.data.HttpProxy({url:Url+'?actiontype=Query',method:'GET'});
var PublicBiddingListGrids=new Ext.data.Store({
    proxy:Proxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
        totalProperty:'results',
        pagesize:300
    },[
     {name:'RowId'},
     {name:'Code'},
     {name:'Desc'},
     {name:'Date',type:'date',dateFormat:DateFormat},
     {name:'Tenderee'},
     {name:'StartDate',type:'date',dateFormat:DateFormat},
     {name:'EndDate',type:'date',dateFormat:DateFormat},
     {name:'Level'},'LevelId',
     {name:'Remark'},
     {name:'ActiveFlag'}
    ]),
    remoteSort:true,
    pruneModifiedRecords:true
})
var ActiveFlag=new Ext.grid.CheckColumn({
	header:'激活',
	dataIndex:'ActiveFlag',
	width:60,
	sortable:true
});

var PBLevel = new Ext.ux.ComboBox({
	store : INFOPBLevelStore,
	listeners : {
		specialKey:function(field,e){
			 if(e.getKey()==Ext.EventObject.ENTER){
				var cell=PublicBiddingListGrid.getSelectionModel().getSelectedCell();
				var record=PublicBiddingListGrid.getStore().getAt(cell[0]);
				var colIndex=GetColIndex(PublicBiddingListGrid, 'Remark');
			 	PublicBiddingListGrid.startEditing(cell[0], colIndex);
			}
		}
	}
});

var PublicBiddingListGridCm=new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(),
    {
	    header:'RowId',
	    dataIndex:'RowId',
	    width:80,
	    aligh:'left',
	    sortable:true, 
	    hidden : true
	 },{
	    header:'招标代码',
	    dataIndex:'Code',
	    width:180,
	    aligh:'left',
	    sortable:true,
	    editor:new Ext.form.TextField({
		    id:'codeField',
		    allowBlank:false,
			listeners:{
				specialKey:function(field,e){
					if(e.getKey()==Ext.EventObject.ENTER){
						var colIndex = GetColIndex(PublicBiddingListGrid, 'Desc');
						PublicBiddingListGrid.startEditing(PublicBiddingListGrids.getCount()-1,colIndex);
					}
				}
			}
		})
	 },{
		 header:'招标名称',
		 dataIndex:'Desc',
		 width:200,
		 aligh:'left',
		 sortable:true,
		 editor:new Ext.form.TextField({
			 id:'descField',
			 allowBlank:false,
			 listeners:{
				specialKey:function(field,e){
					if(e.getKey()==Ext.EventObject.ENTER){
						var colIndex = GetColIndex(PublicBiddingListGrid, 'Date');
						PublicBiddingListGrid.startEditing(PublicBiddingListGrids.getCount()-1,colIndex);
					}
				}
			}
		})
     },{
	     header:'招标日期',
	     dataIndex:'Date',
	     width:100,
	     alingh:'left',
	     sortable : true,
	     renderer : Ext.util.Format.dateRenderer(DateFormat),
	     editor : new Ext.ux.DateField({
				selectOnFocus : true,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var cell = PublicBiddingListGrid.getSelectionModel().getSelectedCell();
							var record = PublicBiddingListGrid.getStore().getAt(cell[0]);
							var colIndex = GetColIndex(PublicBiddingListGrid, 'Tenderee');
							PublicBiddingListGrid.startEditing(cell[0], colIndex);
						}
					}
				}
			})
	},{
		 header:'代理机构名称',
		 dataIndex:'Tenderee',
		 width:100,
		 aligh:'left',
		 sortable:true,
		 editor:new Ext.form.TextField({
			 id:'Tenderee',
			 allowBlank:true,
			 listeners:{
				 specialKey:function(field,e){
					 if(e.getKey()==Ext.EventObject.ENTER){
						 var cell=PublicBiddingListGrid.getSelectionModel().getSelectedCell();
						 var record=PublicBiddingListGrid.getStore().getAt(cell[0]);
						 var colIndex=GetColIndex(PublicBiddingListGrid,'StartDate')
						 PublicBiddingListGrid.startEditing(cell[0],colIndex)
					 	 
						 }
					 }
				 }
			 })
		 
     },{
	     header:'开始日期',
	     dataIndex:'StartDate',
	     width:100,
	     alingh:'left',
	     sortable : true,
	     renderer : Ext.util.Format.dateRenderer(DateFormat),
	     editor : new Ext.ux.DateField({
				selectOnFocus : true,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var cell = PublicBiddingListGrid.getSelectionModel().getSelectedCell();
							var record = PublicBiddingListGrid.getStore().getAt(cell[0]);
							var colIndex = GetColIndex(PublicBiddingListGrid, 'EndDate');
							PublicBiddingListGrid.startEditing(cell[0], colIndex);
						}
					}
				}
			})
	},{
	     header:'结束日期',
	     dataIndex:'EndDate',
	     width:100,
	     alingh:'left',
	     sortable : true,
	     renderer : Ext.util.Format.dateRenderer(DateFormat),
	     editor : new Ext.ux.DateField({
				selectOnFocus : true,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var cell = PublicBiddingListGrid.getSelectionModel().getSelectedCell();
							var record = PublicBiddingListGrid.getStore().getAt(cell[0]);
							var colIndex = GetColIndex(PublicBiddingListGrid, 'LevelId');
							PublicBiddingListGrid.startEditing(cell[0], colIndex);
						}
					}
				}
			})
	},{
		header:'招标级别',
		dataIndex:'LevelId',
		width:100,
		aligh:'left',
		sortable:true,
		editable : true,
		editor : new Ext.grid.GridEditor(PBLevel),
		renderer : Ext.util.Format.comboRenderer2(PBLevel,"LevelId","Level")
     },{
		 header:'备注',
		 dataIndex:'Remark',
		 width:100,
		 aligh:'left',
		 sortable:true,
		 editor:new Ext.form.TextField({
			 id:'Remark',
			 allowBlank:true,
			 listeners:{
				 specialKey:function(field,e){
					 if(e.getKey()==Ext.EventObject.ENTER){
						 addNewRow()
					 }
				 }
			 }
		 })
     },ActiveFlag          

])
//初始化默认排序功能
PublicBiddingListGridCm.defaultSortable=true

var AddBT=new Ext.Toolbar.Button({
	text:'新建',
	tooltip:'新建',
	iconCls:'page_add',
	width:70,
    height:30,
    handler:function(){
      addNewRow()
    }
})

var SaveBT=new Ext.Toolbar.Button({
    text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
    width:70,
    height:30,
    handler:function(){
	    Save()
    }
});
function Save(){
	var ListDetail="";
	var rowCount=PublicBiddingListGrid.getStore().getCount();
	for(i=0;i<rowCount;i++){
		var rowData=PublicBiddingListGrids.getAt(i);
		//新增或数据发生变化时执行下述操作
		if(!(rowData.data.newRecord||rowData.dirty)){
			continue;
		}
		var RowId=rowData.get("RowId"); 
		var Code=rowData.get("Code");
		var Desc=rowData.get("Desc")
		var Date=Ext.util.Format.date(rowData.get("Date"),ARG_DATEFORMAT);
		var Tenderee=rowData.get("Tenderee")
		var StartDate=Ext.util.Format.date(rowData.get("StartDate"),ARG_DATEFORMAT);
		var EndDate=Ext.util.Format.date(rowData.get("EndDate"),ARG_DATEFORMAT);
		var LevelId=rowData.get("LevelId");
		if(Ext.isEmpty(LevelId)){
			Msg.info('warning', '招标级别不可为空!');
			return;
		}
		var Remark=rowData.get("Remark");
		var ActiveFlag=rowData.get("ActiveFlag");
		if((StartDate!="")&(EndDate!="")){
			if (EndDate<StartDate) {
				Msg.info("warning", "截止日期不能小于开始日期,保存失败!");
				return;
			}
		}
		if (Code==""){
			Msg.info("warning","代码不能为空!");
			return;
		}
		if (Desc==""){
			Msg.info("warning","名称不能为空!");
			return;
		}
		var str=RowId+"^"+Code+"^"+Desc+"^"+Date+"^"+Tenderee+"^"+StartDate+"^"+EndDate
			+"^"+LevelId+"^"+Remark+"^"+ActiveFlag;
		if(ListDetail==""){
			ListDetail=str;
		}else{
			ListDetail=ListDetail+xRowDelim()+str;
		}
	}
	
	if(ListDetail==""){
		Msg.info("error","没有修改或添加新数据!");
		return false;
	}else{
		var url = Url+"?actiontype=Save";
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
					Msg.info("success", "保存成功!");
					PublicBiddingListGrids.reload();
				}else{
					var ret=jsonData.info;
					if (ret=="-10"){
						Msg.info("error", "代码重复！");
					}else if (ret=="-11"){
						Msg.info("error", "名称重复！");
					}else{
						Msg.info("error", "保存不成功："+ret);
					}
				}
			},
			scope : this
		});
	}
}

var DeleteBT=new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'page_delete',
	width:70,
	height:30,
	handler:function(){
		deleteDetail();
	}
});

function deleteDetail(){
	var cell=PublicBiddingListGrid.getSelectionModel().getSelectedCell();
	if (cell==null){
		Msg.info("error","请选择数据!");
		return false;
	}
	
	var record=PublicBiddingListGrid.getStore().getAt(cell[0]);
	var RowId=record.get("RowId")
	if (RowId!=""){
		Msg.info('error', '已保存数据不可删除,可考虑修改"激活标记"!');
		return;
	}else{
		var rowInd=cell[0];
		if(rowInd>=0){
			PublicBiddingListGrid.getStore().removeAt(rowInd);
		}
	}
}

var BidPagingBar = new Ext.PagingToolbar({
	store: PublicBiddingListGrids,
	pageSize: 200,
	displayInfo: true
});

PublicBiddingListGrid = new Ext.grid.EditorGridPanel({
	region:'center',
	id:'PublicBiddingListGrid',
	store:PublicBiddingListGrids,
	cm:PublicBiddingListGridCm,
	trackMouseOver:true,
	plugins:[ActiveFlag],
	region:'center',
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMast:true,
	tbar:[AddBT,'-',DeleteBT],
	bbar: BidPagingBar,
	clicksToEdit:1
})

var SearchBT = new Ext.Button({
	text : '查询',
	height: 30,
	width: 70,
	iconCls : 'page_find',
	handler: function(){
		PublicBiddingListGrids.removeAll();
		var BLDesc = Ext.getCmp('BLDesc').getValue();
		var Params = BLDesc;
		PublicBiddingListGrids.setBaseParam('Params', Params);
		var PageSize = BidPagingBar.pageSize;
		PublicBiddingListGrids.load({
			params:{start:0, limit:PageSize},
			callback : function(r,options,success){
				if(!success){
					Msg.info('error', '查询有误!');
				}
			}
		});
	}
});

var BLDesc = new Ext.form.TextField({
	id : 'BLDesc',
	fieldLabel: '名称'
});
var HisListTab = new Ext.ux.FormPanel({
	labelWidth : 80,
	title:'招标轮次维护',
	bodyStyle : 'padding:5px 0px 0px 0px;',
	tbar : [SearchBT, '-', SaveBT],
	items:[{
		xtype:'fieldset',
		title:'查询条件',
		layout: 'column',
		style:'padding:5px 0px 0px 0px;',
		defaults: {xtype: 'fieldset', border:false},
		items : [
			{
				columnWidth: 0.25,
				items: [BLDesc]
			}
		]
	}]
});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
		
	var mainPanel=new Ext.ux.Viewport({
		layout:'border',
		items:[HisListTab, PublicBiddingListGrid],
		renderTo:'mainPanel'
	});
	SearchBT.handler();
});
