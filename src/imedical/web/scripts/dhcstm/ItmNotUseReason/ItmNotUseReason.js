// ����:���������ԭ�����
// ��д����:2012-06-4

//=========================���������ԭ��=============================
function addNewRow() {
	var record = Ext.data.Record.create([
		{
			name : 'RowId',
			type : 'int'
		}, {
			name : 'Desc',
			type : 'string'
		}
	]);
					
	var NewRecord = new record({
		RowId:'',
		Desc:''
	});
					
	ItmNotUseReasonGridDs.add(NewRecord);
	ItmNotUseReasonGrid.startEditing(ItmNotUseReasonGridDs.getCount() - 1, 1);
}
	
var ItmNotUseReasonGrid="";
//��������Դ
var ItmNotUseReasonGridUrl = 'dhcstm.itmnotusereasonaction.csp';
var ItmNotUseReasonGridProxy= new Ext.data.HttpProxy({url:ItmNotUseReasonGridUrl+'?actiontype=query',method:'GET'});
var ItmNotUseReasonGridDs = new Ext.data.Store({
	proxy:ItmNotUseReasonGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results',
        pageSize:35
    }, [
		{name:'RowId'},
		{name:'Desc'}
	]),
    remoteSort:false
});

//ģ��
var ItmNotUseReasonGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"����",
        dataIndex:'Desc',
        width:300,
        align:'left',
        sortable:true,
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
ItmNotUseReasonGridCm.defaultSortable = true;
var addItmNotUseReason = new Ext.Toolbar.Button({
	text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		// �ж��Ƿ��Ѿ��������
		var rowCount=ItmNotUseReasonGrid.getStore().getCount()
		if(rowCount>0){
			var rowData=ItmNotUseReasonGridDs.data.items[rowCount-1]
			var data=rowData.get("RowId");
			if(data==null || data.length<=0){
				Msg.info("Warning","�Ѿ������½���!")
				ItmNotUseReasonGrid.startEditing(ItmNotUseReasonGridDs.getCount()-1,1);
				return;
				
				}
			}
		addNewRow();
	}
});

var saveItmNotUseReason = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//��ȡ���е��¼�¼ 
		var mr=ItmNotUseReasonGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var rowId = mr[i].data["RowId"];
			var desc = mr[i].data["Desc"].trim();
			if(desc!=""){
				var dataRow = rowId+"^"+desc;
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
				url: ItmNotUseReasonGridUrl+'?actiontype=save',
				params:{data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error", "������������!");
					ItmNotUseReasonGridDs.commitChanges();
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", "����ɹ�!");
					}else{
						if(jsonData.info==-2){
							Msg.info("error", "�����ظ�!");
						}else{
							Msg.info("error", "����ʧ��!");
						}
					}
					ItmNotUseReasonGridDs.commitChanges();
					ItmNotUseReasonGridDs.load();
				},
				scope: this
			});
		}
    }
});


var deleteItmNotUseReason = new Ext.Toolbar.Button({
	text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = ItmNotUseReasonGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", "��ѡ������!");
			return false;
		}else{
			var record = ItmNotUseReasonGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
							Ext.Ajax.request({
								url:ItmNotUseReasonGridUrl+'?actiontype=delete&rowid='+RowId,
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
										ItmNotUseReasonGridDs.load();
									}else{
										Msg.info("error", "ɾ��ʧ��!");
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

//���
ItmNotUseReasonGrid = new Ext.grid.EditorGridPanel({
	store:ItmNotUseReasonGridDs,
	cm:ItmNotUseReasonGridCm,
	trackMouseOver:true,
	region:'center',
	height:690,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[addItmNotUseReason,'-',saveItmNotUseReason],	//,'-',deleteItmNotUseReason
	clicksToEdit:1
});

ItmNotUseReasonGridDs.load();
//=========================���������ԭ��=============================

//===========ģ����ҳ��=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:'���������ԭ��',
		activeTab:0,
		region:'center',
		items:[ItmNotUseReasonGrid]                                 
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[panel],
		renderTo:'mainPanel'
	});
});
//===========ģ����ҳ��=============================================