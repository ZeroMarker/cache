// ����:����ԭ�����
// ��д����:2013-12-26

//=========================����ԭ��=============================	
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
					
	IncReasonForScrapGridDs.add(NewRecord);
	IncReasonForScrapGrid.startEditing(IncReasonForScrapGridDs.getCount() - 1, 1);
}
	
var IncReasonForScrapGrid="";
//��������Դ
var IncReasonForScrapGridUrl = 'dhcst.increasonforscrapaction.csp';
var IncReasonForScrapGridProxy= new Ext.data.HttpProxy({url:IncReasonForScrapGridUrl+'?actiontype=query',method:'GET'});
var IncReasonForScrapGridDs = new Ext.data.Store({
	proxy:IncReasonForScrapGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results',
        pageSize:35
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'}
	]),
    remoteSort:false,
    pruneModifiedRecords:true
});

//ģ��
var IncReasonForScrapGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"����",
        dataIndex:'Code',
        width:180,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'codeField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						IncReasonForScrapGrid.startEditing(IncReasonForScrapGridDs.getCount() - 1, 2);
					}
				}
			}
        })
    },{
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
IncReasonForScrapGridCm.defaultSortable = true;

var addIncReasonForScrap = new Ext.Toolbar.Button({
	text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveIncReasonForScrap = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//��ȡ���е��¼�¼ 
		var mr=IncReasonForScrapGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var code = mr[i].data["Code"].trim();
			var desc = mr[i].data["Desc"].trim();
			var rowNum = IncReasonForScrapGridDs.indexOf(mr[i])+1;
			if (code==""){
				Msg.info("warning", "��"+rowNum+"�д���Ϊ��!");
				return;
			}
			if (desc==""){
				Msg.info("warning", "��"+rowNum+"������Ϊ��!");
				return;
			}
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
			Msg.info("warning", "û���޸Ļ�����������!");
			return false;
		}else{
			Ext.Ajax.request({
				url: IncReasonForScrapGridUrl+'?actiontype=save',
				params:{data:data},
				failure: function(result, request) {
					Msg.info("error", "������������!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success", "����ɹ�!");
						IncReasonForScrapGridDs.load();
					}else{
						if(jsonData.info==-1){
							Msg.info("warning", "�����ظ�!");
						}else if(jsonData.info==-2){
							Msg.info("warning", "�����ظ�!");
						}else{
							Msg.info("error", "����ʧ��!");
						}
						IncReasonForScrapGridDs.load();
					}
				},
				scope: this
			});
		}
    }
});


var deleteIncReasonForScrap = new Ext.Toolbar.Button({
	text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = IncReasonForScrapGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", "��ѡ������!");
			return false;
		}else{
			var record = IncReasonForScrapGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
					function(btn) {
						if(btn == 'yes'){
							Ext.Ajax.request({
								url:IncReasonForScrapGridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:'ɾ����...',
								failure: function(result, request) {
									Msg.info("error", "������������!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true') {
										IncReasonForScrapGridDs.remove(record);
										IncReasonForScrapGrid.getView().refresh();
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
				IncReasonForScrapGridDs.remove(record);
				IncReasonForScrapGrid.getView().refresh();
			}
		}
    }
});

//����
IncReasonForScrapGrid = new Ext.grid.EditorGridPanel({
	store:IncReasonForScrapGridDs,
	cm:IncReasonForScrapGridCm,
	trackMouseOver:true,
	region:'center',
	height:770,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[addIncReasonForScrap,'-',saveIncReasonForScrap,'-',deleteIncReasonForScrap],
	clicksToEdit:1
});

IncReasonForScrapGridDs.load();

var HospPanel = InitHospCombo('DHC_IncReasonForStockScrap',function(combo, record, index){
	HospId = this.value; 
	IncReasonForScrapGridDs.reload();
});
//=========================����ԭ��=============================

//===========ģ����ҳ��===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:'����ԭ��',
		activeTab:0,
		region:'center',
		items:[IncReasonForScrapGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[HospPanel, panel],
		renderTo:'mainPanel'
	});
});
//===========ģ����ҳ��===============================================