// ����:�ɹ���˼���ά��
// ��д����:2014-03-17


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
		}, {
			name : 'MaxAmt',
			type : 'float'
		}
	]);
					
	var NewRecord = new record({
		RowId:'',
		Code:'',
		Desc:'',
		MaxAmt:''
	});
					
	DHCPlanStatusGridDs.add(NewRecord);
	DHCPlanStatusGrid.startEditing(DHCPlanStatusGridDs.getCount() - 1, 1);
}
var DHCPlanStatusGrid=""
//��������Դ
var DHCPlanStatusGridUrl = 'dhcstm.dhcplanstatusaction.csp';
var DHCPlanStatusGridProxy= new Ext.data.HttpProxy({url:DHCPlanStatusGridUrl+'?actiontype=query',method:'GET'});
var DHCPlanStatusGridDs = new Ext.data.Store({
	proxy:DHCPlanStatusGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results'
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'},
		{name:'MaxAmt'}
	]),
    remoteSort:false,
    pruneModifiedRecords:true
});

//ģ��
var DHCPlanStatusGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"����",
        dataIndex:'Code',
        width:150,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'codeField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						DHCPlanStatusGrid.startEditing(DHCPlanStatusGridDs.getCount() - 1, 2);
					}
				}
			}
        })
    },{
        header:"����",
        dataIndex:'Desc',
        width:150,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'descField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						DHCPlanStatusGrid.startEditing(DHCPlanStatusGridDs.getCount() - 1, 3)
						//addNewRow();
					}
				}
			}
        })
    },{
	    header:"�����˽��",
	    dataIndex:'MaxAmt',
	    width:150,
	    align:'right',
	    sortable:true,
	    decimalPrecision:4,
		editor: new Ext.form.NumberField({
			id:'MaxAmtField',
            //allowBlank:false,
            selectOnFocus:true,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						//MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 4);	
						addNewRow();		
					}
				}
			}
        })
	    }
]);

//��ʼ��Ĭ��������
DHCPlanStatusGridCm.defaultSortable = true;

var addDHCPlanStatus = new Ext.Toolbar.Button({
	text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveDHCPlanStatus = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		save()
	}
});

function save(){
	if(DHCPlanStatusGrid.activeEditor != null){
			DHCPlanStatusGrid.activeEditor.completeEdit();
		} 
	//��ȡ���е��¼�¼
	var mr=DHCPlanStatusGridDs.getModifiedRecords();
	var data="";
		for(var i=0;i<mr.length;i++){
			var code = mr[i].data["Code"].trim();
			var desc = mr[i].data["Desc"].trim();
			if((code!="")&&(desc!="")){
				var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc+"^"+mr[i].data["MaxAmt"];
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
			Ext.Ajax.request({
				url: DHCPlanStatusGridUrl+'?actiontype=save',
				params:{data:data},
				failure: function(result, request) {
					Msg.info("error", "������������!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success", "����ɹ�!");
						DHCPlanStatusGridDs.load();
					}else{
						if(jsonData.info==-5){
							Msg.info("error", "�����ظ�!");
							}else if(jsonData.info==-6){
							Msg.info("error", "�����ظ�!");
							}else{
						          Msg.info("error", "����ʧ��!");
							     }
						DHCPlanStatusGridDs.load();
					}
				},
				scope: this
			});
		}	
	}
var deleteDHCPlanStatus = new Ext.Toolbar.Button({
	text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		Delete()
	}
});	
function Delete(){
	var cell = DHCPlanStatusGrid.getSelectionModel().getSelectedCell();
	if(cell==null){
			Msg.info("error", "��ѡ������!");
			return false;
		}else{
			var record = DHCPlanStatusGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
					function(btn) {
						if(btn == 'yes'){
							Ext.Ajax.request({
								url:DHCPlanStatusGridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:'ɾ����...',
								failure: function(result, request) {
									Msg.info("error", "������������!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true') {
										Msg.info("success", "ɾ���ɹ�!");
										DHCPlanStatusGridDs.load();
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
				DHCPlanStatusGridDs.remove(record);
				DHCPlanStatusGrid.getView().refresh();
			}
		}
	}		
//���
DHCPlanStatusGrid = new Ext.grid.EditorGridPanel({
	store:DHCPlanStatusGridDs,
	cm:DHCPlanStatusGridCm,
	trackMouseOver:true,
	region:'center',
	height:690,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[addDHCPlanStatus,'-',saveDHCPlanStatus],		//,'-',deleteDHCPlanStatus
	clicksToEdit:1
});

DHCPlanStatusGridDs.load()
//===========ģ����ҳ��===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:'�ɹ���˼���',
		activeTab:0,
		region:'center',
		items:[DHCPlanStatusGrid]                                 
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[panel],
		renderTo:'mainPanel'
	});
});
//===========ģ����ҳ��===============================================