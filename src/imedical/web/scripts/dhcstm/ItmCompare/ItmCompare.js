// ����:���ʶ���ά��
// ��д����:2013-12-16	

//=========================���ʶ���=============================
var gUserId = session['LOGON.USERID'];	
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];

// ����
var StkGrpType=new Ext.ux.StkGrpComboBox({ 
	id : 'StkGrpType',
	name : 'StkGrpType',
	StkType:App_StkTypeCode,     //��ʶ��������
	LocId:gLocId,
	UserId:gUserId,
	anchor:'70%'
});
// ����inci
var Inci = new Ext.form.TextField({
	fieldLabel : 'Inci',
	id : 'Inci',
	name : 'Inci',
	anchor : '90%',
	valueNotFoundText : ''
});
// ��������
var InciDesc = new Ext.form.TextField({
	fieldLabel :'��������',
	id:'InciDesc',
	name:'InciDesc',
	anchor:'90%',
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var stktype = Ext.getCmp("StkGrpType").getValue();
				GetPhaOrderInfo2(field.getValue(), stktype);
			}
		}
	}
});
// HIS���ʴ���
var HisInciCode = new Ext.form.TextField({
	fieldLabel :'HIS���ʴ���',
	id:'HisInciCode',
	name:'HisInciCode',
	anchor:'90%'
});
//����ҩƷ���岢���ؽ��
function GetPhaOrderInfo2(item, group) {						
	if (item != null && item.length > 0) {
	    GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",
						getDrugList2);
	}
}	
// ���ط���
function getDrugList2(record) {
	if (record == null || record == "") {
		return;
	}
	var inciDr = record.get("InciDr");
	var inciCode=record.get("InciCode");
	var inciDesc=record.get("InciDesc");
	Ext.getCmp("Inci").setValue(inciDr);
	Ext.getCmp("InciDesc").setValue(inciDesc);
}
function GetPhaOrderInfo(item, group) {				
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",
				getDrugList);
	}
}

function getDrugList(record) {
	if (record == null || record == "") {
		return;
	}
	var cell = ItmCompareGrid.getSelectionModel().getSelectedCell();
	var row = cell[0];
	var rowData = ItmCompareGrid.getStore().getAt(row);
	var inciDr = record.get("InciDr");
	var inciCode=record.get("InciCode");
	var inciDesc=record.get("InciDesc");
	var spec=record.get("Spec");
	 rowData.set("InciId",inciDr);
	 rowData.set("InciCode",inciCode);
	 rowData.set("InciDesc",inciDesc);
	 rowData.set("Spec",spec);
	 var colindex=GetColIndex(ItmCompareGrid,"HisInciCode");
	ItmCompareGrid.startEditing(cell[0],colindex);
}
var findItmCompare = new Ext.Toolbar.Button({
	text:'��ѯ',
    tooltip:'��ѯ',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		Query()
	}
});

var addItmCompare = new Ext.Toolbar.Button({
    text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
    width : 70,
    height : 30,
    handler:function(){
	    ItmCompareGrid.store.removeAll();
        addNewRow();
    }
});
var SaveBT = new Ext.Toolbar.Button({
	id : "SaveBT",
	text : '����',
	tooltip : '�������',
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
		if(beforesave()==true){
			saveOrder();
		}
	}
});
//ɾ����ť
var DeleteDetail = new Ext.Toolbar.Button({
    text:'ɾ��һ��',
    tooltip:'ɾ��һ��',
    iconCls:'page_delete',
    width : 70,
    height : 30,
    handler:function(){
	    deleteDetail(); 
	}
})				
//����һ��
var AddDetail = new Ext.Toolbar.Button({
    text:'����һ��',
    tooltip:'����һ��',
    iconCls:'page_add',
    width : 70,
    height : 30,
    handler:function(){
	    addNewRow(); 
	}
})							
//ģ��
var nm = new Ext.grid.RowNumberer();
var ItmCompareGridCm = new Ext.grid.ColumnModel([nm,{
        header : "RowId",
		dataIndex : 'RowId',
		width : 120,
		align : 'left',
		sortable : true,
		hidden : true
	},{
		header : "InciId",
		dataIndex : 'InciId',
		width : 120,
		align : 'left',
		sortable : true,
		hidden : true
	},{
		header : "���ʴ���",
		dataIndex : 'InciCode',
		width : 150,
		align : 'left',
		sortable : true
	},{
        header:"��������",
        dataIndex:'InciDesc',
        width:250,
        align:'left',
        sortable:true,
        editor :new Ext.grid.GridEditor(new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var group = Ext.getCmp("StkGrpType").getValue();
						GetPhaOrderInfo(field.getValue(),group);					
					}
				}
			}
		}))
	},{
		header : "���",
		dataIndex : 'Spec',
		width : 150,
		align : 'left',
		sortable : true
	},{
		header:'HIS���ʴ���',
	    dataIndex:'HisInciCode',
	    width:150,
	    align:'left',
	    sortable:true,
	    editor : new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					var cell = ItmCompareGrid.getSelectionModel().getSelectedCell();
					var colindex=GetColIndex(ItmCompareGrid,"HisInciDesc");
					ItmCompareGrid.startEditing(cell[0],colindex);
					}
				}
			}
		})   	     
	},{
		header:'HIs��������',
	    dataIndex:'HisInciDesc',
	    width:150,
	    align:'left',
	    sortable:true,
	    editor : new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					addNewRow()
					}
				}
			}
		})   
    }
]);
//��ʼ��Ĭ��������
ItmCompareGridCm.defaultSortable = true;
//����ǰ�ж�����
function beforesave(){
	var rowCount = ItmCompareGrid.getStore().getCount();
	for (var i = 0; i < rowCount - 1; i++) {
		for (var j = i + 1; j < rowCount; j++) {
			var item_i = ItmCompareGridDs.getAt(i).get("InciId");
			var item_j = ItmCompareGridDs.getAt(j).get("InciId");
			var item_m = ItmCompareGridDs.getAt(i).get("HisInciCode");
			var item_n = ItmCompareGridDs.getAt(j).get("HisInciCode");
			if (item_i != "" && item_j != ""&& item_i == item_j) {
				changeBgColor(i, "yellow");
				changeBgColor(j, "yellow");
				Msg.info("warning", "����ά���ظ�������������!");
				return false;
			}
			if (item_m != "" && item_n != ""&& item_m == item_n) {
				changeBgColor(i, "yellow");
				changeBgColor(j, "yellow");
				Msg.info("warning", "HIS����ά���ظ�������������!");
				return false;
			}
		}
	}
	return true;
}
		// �任����ɫ
function changeBgColor(row, color) {
	ItmCompareGrid.getView().getRow(row).style.backgroundColor = color;
}

function addNewRow() {
	// �ж��Ƿ��Ѿ��������
	var rowCount = ItmCompareGrid.getStore().getCount();
	if (rowCount > 0) {
		var rowData = ItmCompareGridDs.data.items[rowCount - 1];
		var data = rowData.get("InciId");	
		if (data == null || data.length <= 0) {
		var inciIndex=GetColIndex(ItmCompareGrid,"InciCode");			
		ItmCompareGrid.startEditing(ItmCompareGridDs.getCount() - 1, inciIndex);
		return;
		}
	}
	
	var record = Ext.data.Record.create([{
            name : 'RowId',
            type : 'int'
        },{
            name : 'InciId',
            type : 'string'
        },{
            name : 'InciCode',
            type : 'string'
        },{
	        name : 'InciDesc',
	        type : 'string'
	    },{
	        name : 'Spec',
	        type : 'string'
	    },{
            name : 'HisInciCode',
            type : 'string'
        },{
            name : 'HisInciDesc',
            type : 'string'
        }
    ]);
    var NewRecord = new record({
	    RowId:'',
	    InciId:'',
        InciCode:'',
        InciDesc:'',
        Spec:'',
        HisInciCode:'',
        HisInciDesc:''       
    });
                    
    ItmCompareGridDs.add(NewRecord);
    var inciIndex=GetColIndex(ItmCompareGrid,"InciDesc");
    ItmCompareGrid.startEditing(ItmCompareGridDs.getCount()-1, inciIndex);
}

// ����·��
var DetailUrl ='dhcstm.itmcompareaction.csp?actiontype=Query';
// ͨ��AJAX��ʽ���ú�̨����
var proxy = new Ext.data.HttpProxy({
			url : DetailUrl,
			method : "POST"
	});
		
// ָ���в���
var fields = ["RowId", "InciId", "InciCode","InciDesc","HisInciCode","HisInciDesc","Spec"];
		
// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "RowId",
		fields : fields
});
// ���ݼ�
var ItmCompareGridDs = new Ext.data.Store({
		proxy : proxy,
		reader : reader
});	 
			
//���湩Ӧ��Ŀ��ϸ
function saveOrder(){
	var ListDetail="";
	var rowCount = ItmCompareGrid.getStore().getCount();
	for (var i = 0; i < rowCount; i++) {
		var rowData = ItmCompareGridDs.getAt(i);
		//���������ݷ����仯ʱִ����������
		if(rowData.data.newRecord || rowData.dirty){			
			var RowId=rowData.get("RowId"); 
			var InciId=rowData.get("InciId");
			var InciCode=rowData.get("InciCode");	
			var InciDesc=rowData.get("InciDesc");	
			var HisInciCode=rowData.get("HisInciCode");  
			var HisInciDesc=rowData.get("HisInciDesc");    
			if(InciId==""||InciCode==""||InciDesc==""||HisInciCode==""||HisInciDesc==""){
				Msg.info("error","��"+(i+1)+"�����ݲ�����!");return
			}	 
			var str= RowId + "^" + InciId+"^"+InciCode+"^"+InciDesc+"^"+HisInciCode+"^"+HisInciDesc
			if(ListDetail==""){
				ListDetail=str;
			}else{
				ListDetail=ListDetail+RowDelim+str;
			}
		}
	}               
	if(ListDetail==""){
		Msg.info("error","û���޸Ļ����������!");
		return false;
	}else{
		var url ="dhcstm.itmcompareaction.csp?actiontype=Save";
		var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			params:{ListDetail:ListDetail},
			waitMsg : '������...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				mask.hide();		
				if (jsonData.success == 'true') {
					// ˢ�½���
					Msg.info("success", "����ɹ�!");
					Query()
				}else{
					var ret=jsonData.info;
					if(ret==-1){
						Msg.info("error","������ͬ����!");
					}else if(ret==-2){
						Msg.info("error","������ͬHIS���ʴ���!");
					}else{
						Msg.info("error", "���治�ɹ���"+ret);
					}
				}
			},
			scope : this
		});
	}
}
           
//��ѯ����
function Query()
{	
	var Inci=""
	if(Ext.getCmp("InciDesc").getValue()!=""){
		var Inci=Ext.getCmp("Inci").getValue();
	}
	var stktype = Ext.getCmp("StkGrpType").getValue();
    var hisInciCode = Ext.getCmp("HisInciCode").getValue();
    ItmCompareGridDs.removeAll();
    ItmCompareGridDs.setBaseParam('Inci',Inci)
    ItmCompareGridDs.setBaseParam('stktype',stktype)
    ItmCompareGridDs.setBaseParam('gLocId',gLocId)
    ItmCompareGridDs.setBaseParam('gUserId',gUserId)
	ItmCompareGridDs.setBaseParam('hisInciCode',hisInciCode)
	ItmCompareGridDs.load({
		params:{start:0,limit:ItmComparePagingToolbar.pageSize}
	});
}
function deleteDetail()
{
	var cell = ItmCompareGrid.getSelectionModel().getSelectedCell();
	if(cell==null){
		Msg.info("error","��ѡ������!");
		return false;}
	else{ var record = ItmCompareGrid.getStore().getAt(cell[0]);
		var RowId = record.get("RowId");
		if (RowId!=""){
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
			function(btn){
				if(btn=="yes"){
					var url = "dhcstm.itmcompareaction.csp?actiontype=Delete&rowid="+RowId;
					var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
					Ext.Ajax.request({
						url:url,
						waitMsg:'ɾ����...',
						failure: function(result, request) {
							Msg.info("error","������������!");
							 mask.hide();
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							mask.hide();
							if (jsonData.success=='true') {
								Msg.info("success","ɾ���ɹ�!");
								Query()
							}
							else{
								Msg.info("error","ɾ��ʧ��!");
							}
						},
						scope: this
					});
					   
				}						   
			})
		}else{ 
			var rowInd=cell[0];      
			if (rowInd>=0) ItmCompareGrid.getStore().removeAt(rowInd);
		}
	}   
}
	      
var formPanel = new Ext.form.FormPanel({
	labelwidth : 30,
	autoScroll : true,
	labelAlign : 'right',
	frame : true,
	bodyStyle : 'padding:5px;',
    tbar:[findItmCompare,'-',addItmCompare,'-',SaveBT],
	items : [{
		xtype : 'fieldset',
		title : '��ѯ����',
		autoHeight : true,
		layout : 'column',			
		items : [{
				columnWidth : .33,
				layout : 'form',
				items : [StkGrpType]
			}, {
				columnWidth : .33,
				layout : 'form',
				items : [InciDesc]
			}, {
				columnWidth : .33,
				layout : 'form',
				items : [HisInciCode]
		}]
	}]

});

//��ҳ������
var ItmComparePagingToolbar = new Ext.PagingToolbar({
    store:ItmCompareGridDs,
	pageSize:30,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼"
});

//���
ItmCompareGrid = new Ext.grid.EditorGridPanel({
	store:ItmCompareGridDs,
	cm:ItmCompareGridCm,
	title:'���ʶ�����ϸ',
	trackMouseOver:true,
	clicksToEdit:0,
	region:'center',
	height:690,
	stripeRows:true,
    sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	tbar:{items:[AddDetail,'-',DeleteDetail]},
	bbar:ItmComparePagingToolbar
});
//==========================���ʶ���=============================

//===========ģ����ҳ��===========================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
   
	var panel = new Ext.Panel({
		title:'���ʶ���ά��',
		activeTab:0,
		region:'north',
		height:159,
		layout:'fit',
		items:[formPanel]                                 
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[panel,ItmCompareGrid],
		renderTo:'mainPanel'
	});
});
	
//===========ģ����ҳ��===========================================