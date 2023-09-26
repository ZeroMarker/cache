// ����:���������
// ��д����:2012-05-23

//=========================���������=============================
var conditionCodeField = new Ext.form.TextField({
	id:'conditionCodeField',
	fieldLabel:'����',
	allowBlank:true,
	emptyText:'����...',
	anchor:'90%',
	selectOnFocus:true
});
	
var conditionDescField = new Ext.form.TextField({
	id:'conditionDescField',
	fieldLabel:'����',
	allowBlank:true,
	emptyText:'����...',
	anchor:'90%',
	selectOnFocus:true
});
	
function addNewRow() {
	var record = Ext.data.Record.create([
		{
			name : 'RowId',
			type : 'int'
		}, {
			name : 'Code',
			type : 'string'
		}, {
			name : 'Desc',
			type : 'string'
		}
	]);
					
	var NewRecord = new record({
		RowId:'',
		Code:'',
		Desc:''
	});
					
	StkLocGrpGridDs.add(NewRecord);
	StkLocGrpGrid.startEditing(StkLocGrpGridDs.getCount() - 1, 1);
}


var StkLocGrpGrid="";
//��������Դ
var StkLocGrpGridUrl = 'dhcstm.stklocgrpaction.csp';
var StkLocGrpGridProxy= new Ext.data.HttpProxy({url:StkLocGrpGridUrl+'?actiontype=query',method:'POST'});
var StkLocGrpGridDs = new Ext.data.Store({
	proxy:StkLocGrpGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results'
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'}
	]),
    remoteSort:false,
    pruneModifiedRecords:true
});

//ģ��
var StkLocGrpGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"����",
        dataIndex:'Code',
        width:180,
        align:'left',
		editor: new Ext.form.TextField({
			id:'codeField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						StkLocGrpGrid.startEditing(StkLocGrpGridDs.getCount() - 1, 2);
					}
				}
			}
        })
    },{
        header:"����",
        dataIndex:'Desc',
        width:300,
        align:'left',
		editor: new Ext.form.TextField({
			id:'descField',
            allowBlank:false,
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

//��ʼ��Ĭ��������
StkLocGrpGridCm.defaultSortable = true;

var findStkLocGrp = new Ext.Toolbar.Button({
	text:'��ѯ',
    tooltip:'��ѯ',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		var conditionCode = Ext.getCmp('conditionCodeField').getValue();
		var conditionDesc = Ext.getCmp('conditionDescField').getValue();
		StkLocGrpGridDs.setBaseParam('conditionCode',conditionCode)
		StkLocGrpGridDs.setBaseParam('conditionDesc',conditionDesc)
		StkLocGrpGridDs.load({params:{start:0,limit:StkLocGrpPagingToolbar.pageSize,sort:'RowId',dir:'desc'}});
	}
});

var addStkLocGrp = new Ext.Toolbar.Button({
	text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveStkLocGrp = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(StkLocGrpGrid.activeEditor!=null){
			StkLocGrpGrid.activeEditor.completeEdit();
		}
		//��ȡ���е��¼�¼ 
		var mr=StkLocGrpGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var code = mr[i].data["Code"].trim();
			var desc = mr[i].data["Desc"].trim();
			if((code!="")&&(desc!="")){
				var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc;
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
		}
		
		if(data==""){
			Msg.info("error", "û���޸Ļ����������!");
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
			Ext.Ajax.request({
				url: StkLocGrpGridUrl+'?actiontype=save',
				params: {data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error", "������������!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", "����ɹ�!");
						StkLocGrpGridDs.reload();
					}else{
						var date=jsonData.info
						if(date==-5){
						Msg.info("error", "�����ظ�!");}
						else if(date==-6){
						Msg.info("error", "�����ظ�!" );}
						else{
						Msg.info("error", "����ʧ�ܣ�" );}
						StkLocGrpGridDs.reload();
					}
				},
				scope: this
			});
		}
    }
});


var deleteStkLocGrp = new Ext.Toolbar.Button({
	text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = StkLocGrpGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", "��ѡ������!");
			return false;
		}else{
			var record = StkLocGrpGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
							Ext.Ajax.request({
								url:StkLocGrpGridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:'ɾ����...',
								failure: function(result, request) {
									 mask.hide();
									Msg.info("error", "������������!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									 mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success", "ɾ���ɹ�!");
										StkLocGrpGridDs.load({params:{start:0,limit:StkLocGrpPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionDesc:Ext.getCmp('conditionDescField').getValue(),conditionType:""}});
									}else{
										if(jsonData.info==-1){
											Msg.info("error", "�����������ʶ�����ʹ�ù�������ɾ��!");
										}else{
											Msg.info("error", "ɾ��ʧ��!");
										}
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				Msg.info("error", "�����д�,û��RowId!");
			}
		}
    }
});

var formPanel = new Ext.form.FormPanel({
	title:'�����鶨��',
	labelwidth : 30,
	labelAlign : 'right',
	region:'north',
	height:140,
	frame : true,
	bodyStyle : 'padding:5px;',
    tbar:[findStkLocGrp,'-',addStkLocGrp,'-',saveStkLocGrp],	//,'-',deleteStkLocGrp
	items : [{
		items : [{
			xtype : 'fieldset',
			title : '��ѯ����',
			items : [{
				layout : 'column',
				items : [{
					columnWidth : .3,
					layout : 'form',
					items : [conditionCodeField]
				}, {
					columnWidth : .3,
					layout : 'form',
					items : [conditionDescField]
				}]
			}]
		}]
	}]
});

//��ҳ������
var StkLocGrpPagingToolbar = new Ext.PagingToolbar({
    store:StkLocGrpGridDs,
	pageSize:35,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼"
});

//���
StkLocGrpGrid = new Ext.grid.EditorGridPanel({
	store:StkLocGrpGridDs,
	cm:StkLocGrpGridCm,
	trackMouseOver:true,
	region:'center',
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	bbar:StkLocGrpPagingToolbar,
	clicksToEdit:1
});

//=========================���������=============================

//===========ģ����ҳ��===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,StkLocGrpGrid],
		renderTo:'mainPanel'
	});
	findStkLocGrp.handler();
});
//===========ģ����ҳ��===============================================