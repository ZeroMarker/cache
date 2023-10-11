// ����:�˻�ԭ�����
// ��д����:2012-05-22

//=========================�˻�ԭ��=============================	
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
					
	IncReasonForRetGridDs.add(NewRecord);
	IncReasonForRetGrid.startEditing(IncReasonForRetGridDs.getCount() - 1, 1);
}
	
var IncReasonForRetGrid="";
//��������Դ
var IncReasonForRetGridUrl = 'dhcst.increasonforretaction.csp';
var IncReasonForRetGridProxy= new Ext.data.HttpProxy({url:IncReasonForRetGridUrl+'?actiontype=query',method:'GET'});
var IncReasonForRetGridDs = new Ext.data.Store({
	proxy:IncReasonForRetGridProxy,
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
var IncReasonForRetGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:$g("����"),
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
						IncReasonForRetGrid.startEditing(IncReasonForRetGridDs.getCount() - 1, 2);
					}
				}
			}
        })
    },{
        header:$g("����"),
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
IncReasonForRetGridCm.defaultSortable = true;

var addIncReasonForRet = new Ext.Toolbar.Button({
	text:$g('�½�'),
    tooltip:$g('�½�'),
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveIncReasonForRet = new Ext.Toolbar.Button({
	text:$g('����'),
    tooltip:$g('����'),
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//��ȡ���е��¼�¼ 
		var mr=IncReasonForRetGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var code = mr[i].data["Code"].trim();
			var desc = mr[i].data["Desc"].trim();
			var rowNum = IncReasonForRetGridDs.indexOf(mr[i])+1;
			if (code==""){
				Msg.info("warning", $g("��")+rowNum+$g("�д���Ϊ��!"));
				return;
			}
			if (desc==""){
				Msg.info("warning", $g("��")+rowNum+$g("������Ϊ��!"));
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
			Msg.info("warning", $g("û���޸Ļ����������!"));
			return false;
		}else{
			Ext.Ajax.request({
				url: IncReasonForRetGridUrl+'?actiontype=save',
				params:{data:data},
				failure: function(result, request) {
					Msg.info("error", $g("������������!"));
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success", $g("����ɹ�!"));
						IncReasonForRetGridDs.load();
					}else{
						Msg.info("warning", jsonData.info);
						IncReasonForRetGridDs.load();
					}
				},
				scope: this
			});
		}
    }
});


var deleteIncReasonForRet = new Ext.Toolbar.Button({
	text:$g('ɾ��'),
    tooltip:$g('ɾ��'),
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = IncReasonForRetGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning", $g("��ѡ������!"));
			return false;
		}else{
			var record = IncReasonForRetGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm($g('��ʾ'),$g('ȷ��Ҫɾ��ѡ������?'),
					function(btn) {
						if(btn == 'yes'){
							Ext.Ajax.request({
								url:IncReasonForRetGridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:$g('ɾ����...'),
								failure: function(result, request) {
									Msg.info("error", $g("������������!"));
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true') {
										Msg.info("success", $g("ɾ���ɹ�!"));
										IncReasonForRetGridDs.remove(record);
										IncReasonForRetGrid.getView().refresh();
									}else{
										Msg.info("error", $g("ɾ��ʧ��!"));
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				IncReasonForRetGridDs.remove(record);
				IncReasonForRetGrid.getView().refresh();
			}
		}
    }
});

//���
IncReasonForRetGrid = new Ext.grid.EditorGridPanel({
	store:IncReasonForRetGridDs,
	cm:IncReasonForRetGridCm,
	trackMouseOver:true,
	region:'center',
	height:770,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[addIncReasonForRet,'-',saveIncReasonForRet,'-',deleteIncReasonForRet],
	clicksToEdit:1
});

IncReasonForRetGridDs.load();

var HospPanel = InitHospCombo('INC_ReasonForReturn',function(combo, record, index){
	HospId = this.value; 
	IncReasonForRetGridDs.reload();
});

//=========================�˻�ԭ��=============================


//===========ģ����ҳ��===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:$g('�˻�ԭ��'),
		activeTab:0,
		region:'center',
		items:[IncReasonForRetGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[HospPanel,panel],
		renderTo:'mainPanel'
	});
});
//===========ģ����ҳ��===============================================