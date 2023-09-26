// ����:���ʱ�׼����ά��
// ��д����:2019-04-10

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
					
	StandardNameGridDs.add(NewRecord);
	StandardNameGrid.startEditing(StandardNameGridDs.getCount() - 1, 1);
}


var StandardNameGrid="";
//��������Դ
var StandardNameGridUrl = 'dhcstm.standardnameaction.csp';
var StandardNameGridProxy= new Ext.data.HttpProxy({url:StandardNameGridUrl+'?actiontype=query',method:'POST'});
var StandardNameGridDs = new Ext.data.Store({
	proxy:StandardNameGridProxy,
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
var StandardNameGridCm = new Ext.grid.ColumnModel([
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
						StandardNameGrid.startEditing(StandardNameGridDs.getCount() - 1, 2);
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
StandardNameGridCm.defaultSortable = true;

var FindBT = new Ext.Toolbar.Button({
	text:'��ѯ',
    tooltip:'��ѯ',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		var conditionCode = Ext.getCmp('conditionCodeField').getValue();
		var conditionDesc = Ext.getCmp('conditionDescField').getValue();
		StandardNameGridDs.setBaseParam('conditionCode',conditionCode)
		StandardNameGridDs.setBaseParam('conditionDesc',conditionDesc)
		StandardNameGridDs.load({params:{start:0,limit:StandardNamePagingToolbar.pageSize}});
	}
});

var AddBT = new Ext.Toolbar.Button({
	text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var SaveBT = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(StandardNameGrid.activeEditor!=null){
			StandardNameGrid.activeEditor.completeEdit();
		}
		//��ȡ���е��¼�¼ 
		var mr=StandardNameGridDs.getModifiedRecords();
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
				url: StandardNameGridUrl+'?actiontype=save',
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
						StandardNameGridDs.reload();
					}else{
						var date=jsonData.info
						if(date==-5){
						Msg.info("error", "�����ظ�!");}
						else if(date==-6){
						Msg.info("error", "�����ظ�!" );}
						else{
						Msg.info("error", "����ʧ�ܣ�" );}
						StandardNameGridDs.reload();
					}
				},
				scope: this
			});
		}
    }
});


var DeleteBT = new Ext.Toolbar.Button({
	text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = StandardNameGrid.getSelectionModel().getSelectedCell();
		alert(cell)
		if(cell==null){
			Msg.info("error", "��ѡ������!");
			return false;
		}else{
			var record = StandardNameGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
							Ext.Ajax.request({
								url:StandardNameGridUrl+'?actiontype=delete&rowid='+RowId,
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
										StandardNameGridDs.load({params:{start:0,limit:StandardNamePagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionDesc:Ext.getCmp('conditionDescField').getValue(),conditionType:""}});
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
	title:'���ʱ�׼����ά��',
	labelwidth : 30,
	labelAlign : 'right',
	region:'north',
	height:150,
	frame : true,
	bodyStyle : 'padding:5px;',
    tbar:[FindBT,'-',AddBT,'-',SaveBT],	//,'-',DeleteBT
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
var StandardNamePagingToolbar = new Ext.PagingToolbar({
    store:StandardNameGridDs,
	pageSize:35,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼"
});

//���
StandardNameGrid = new Ext.grid.EditorGridPanel({
	store:StandardNameGridDs,
	cm:StandardNameGridCm,
	trackMouseOver:true,
	region:'center',
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	bbar:StandardNamePagingToolbar,
	clicksToEdit:1
});

//=========================���������=============================

//===========ģ����ҳ��===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,StandardNameGrid],
		renderTo:'mainPanel'
	});
	FindBT.handler();
});
//===========ģ����ҳ��===============================================