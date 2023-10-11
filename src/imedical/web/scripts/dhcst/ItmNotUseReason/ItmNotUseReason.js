// ����:��������ԭ�����
// ��д����:2012-06-4

//=========================��������ԭ��=============================
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
var ItmNotUseReasonGridUrl = 'dhcst.itmnotusereasonaction.csp';
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
    remoteSort:false,
    pruneModifiedRecords:true
});

//ģ��
var ItmNotUseReasonGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
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
ItmNotUseReasonGridCm.defaultSortable = true;
var addItmNotUseReason = new Ext.Toolbar.Button({
	text:$g('�½�'),
    tooltip:$g('�½�'),
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveItmNotUseReason = new Ext.Toolbar.Button({
	text:$g('����'),
    tooltip:$g('����'),
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
			var rowNum = ItmNotUseReasonGridDs.indexOf(mr[i])+1;
			if (desc==""){
				Msg.info("warning", $g("��")+rowNum+$g("������Ϊ��!"));
				return;
			}
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
			Msg.info("warning", $g("û���޸Ļ����������!"));
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),$g("���������Ժ�..."));
			Ext.Ajax.request({
				url: ItmNotUseReasonGridUrl+'?actiontype=save',
				params:{data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error", $g("������������!"));
					ItmNotUseReasonGridDs.commitChanges();
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success",$g( "����ɹ�!"));
					}else{
						if(jsonData.info==-2){
							Msg.info("warning", $g("�����ظ�!"));
						}else{
							Msg.info("warning", $g("����ʧ��!"));
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
	text:$g('ɾ��'),
    tooltip:$g('ɾ��'),
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = ItmNotUseReasonGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning", $g("��ѡ������!"));
			return false;
		}else{
			var record = ItmNotUseReasonGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm($g('��ʾ'),$g('ȷ��Ҫɾ��ѡ������?'),
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),$g("���������Ժ�..."));
							Ext.Ajax.request({
								url:ItmNotUseReasonGridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:$g('ɾ����...'),
								failure: function(result, request) {
									 mask.hide();
									Msg.info("error", $g("������������!"));
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									 mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success", $g("ɾ���ɹ�!"));
										ItmNotUseReasonGridDs.remove(record);
										ItmNotUseReasonGrid.getView().refresh();
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
				ItmNotUseReasonGridDs.remove(record);
				ItmNotUseReasonGrid.getView().refresh();
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
	height:770,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[addItmNotUseReason,'-',saveItmNotUseReason,'-',deleteItmNotUseReason],
	clicksToEdit:1
});

ItmNotUseReasonGridDs.load();

var HospPanel = InitHospCombo('DHC_ItmNotUseReason',function(combo, record, index){
	HospId = this.value; 
	ItmNotUseReasonGridDs.reload();
});

//=========================��������ԭ��=============================

//===========ģ����ҳ��=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:$g('��������ԭ��'),
		activeTab:0,
		region:'center',
		items:[ItmNotUseReasonGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[HospPanel, panel],
		renderTo:'mainPanel'
	});
});
//===========ģ����ҳ��=============================================