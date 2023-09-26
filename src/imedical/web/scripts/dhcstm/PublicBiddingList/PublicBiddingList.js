// ����:�б��ִ�ά��
// ��д����:2017-08-10
// ����:zhangxiao

var Url="dhcstm.publicbiddinglistaction.csp"
//�б��ִ�ά��
function addNewRow(){
	var DefaValue = {ActiveFlag:'Y'};
	var NewRecord = CreateRecordInstance(PublicBiddingListGrids.fields, DefaValue);
	PublicBiddingListGrids.add(NewRecord);
	var col = GetColIndex(PublicBiddingListGrid, 'Code');
	PublicBiddingListGrid.startEditing(PublicBiddingListGrids.getCount()-1, col);
}
//��������Դ
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
	header:'����',
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
	    header:'�б����',
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
		 header:'�б�����',
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
	     header:'�б�����',
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
		 header:'�����������',
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
	     header:'��ʼ����',
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
	     header:'��������',
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
		header:'�б꼶��',
		dataIndex:'LevelId',
		width:100,
		aligh:'left',
		sortable:true,
		editable : true,
		editor : new Ext.grid.GridEditor(PBLevel),
		renderer : Ext.util.Format.comboRenderer2(PBLevel,"LevelId","Level")
     },{
		 header:'��ע',
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
//��ʼ��Ĭ��������
PublicBiddingListGridCm.defaultSortable=true

var AddBT=new Ext.Toolbar.Button({
	text:'�½�',
	tooltip:'�½�',
	iconCls:'page_add',
	width:70,
    height:30,
    handler:function(){
      addNewRow()
    }
})

var SaveBT=new Ext.Toolbar.Button({
    text:'����',
    tooltip:'����',
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
		//���������ݷ����仯ʱִ����������
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
			Msg.info('warning', '�б꼶�𲻿�Ϊ��!');
			return;
		}
		var Remark=rowData.get("Remark");
		var ActiveFlag=rowData.get("ActiveFlag");
		if((StartDate!="")&(EndDate!="")){
			if (EndDate<StartDate) {
				Msg.info("warning", "��ֹ���ڲ���С�ڿ�ʼ����,����ʧ��!");
				return;
			}
		}
		if (Code==""){
			Msg.info("warning","���벻��Ϊ��!");
			return;
		}
		if (Desc==""){
			Msg.info("warning","���Ʋ���Ϊ��!");
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
		Msg.info("error","û���޸Ļ����������!");
		return false;
	}else{
		var url = Url+"?actiontype=Save";
		var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			params:{ListDetail:ListDetail},
			waitMsg : '������...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
							.decode(result.responseText);
				mask.hide();		
				if (jsonData.success == 'true') {
					Msg.info("success", "����ɹ�!");
					PublicBiddingListGrids.reload();
				}else{
					var ret=jsonData.info;
					if (ret=="-10"){
						Msg.info("error", "�����ظ���");
					}else if (ret=="-11"){
						Msg.info("error", "�����ظ���");
					}else{
						Msg.info("error", "���治�ɹ���"+ret);
					}
				}
			},
			scope : this
		});
	}
}

var DeleteBT=new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
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
		Msg.info("error","��ѡ������!");
		return false;
	}
	
	var record=PublicBiddingListGrid.getStore().getAt(cell[0]);
	var RowId=record.get("RowId")
	if (RowId!=""){
		Msg.info('error', '�ѱ������ݲ���ɾ��,�ɿ����޸�"������"!');
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
	text : '��ѯ',
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
					Msg.info('error', '��ѯ����!');
				}
			}
		});
	}
});

var BLDesc = new Ext.form.TextField({
	id : 'BLDesc',
	fieldLabel: '����'
});
var HisListTab = new Ext.ux.FormPanel({
	labelWidth : 80,
	title:'�б��ִ�ά��',
	bodyStyle : 'padding:5px 0px 0px 0px;',
	tbar : [SearchBT, '-', SaveBT],
	items:[{
		xtype:'fieldset',
		title:'��ѯ����',
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
