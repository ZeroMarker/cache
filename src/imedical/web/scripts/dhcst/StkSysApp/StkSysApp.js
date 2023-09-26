// ����:Ӧ��ϵͳ����
// ��д����:2012-05-10

//=========================Ӧ��ϵͳ����=================================
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
			name : 'Type',
			type : 'string'
		}
	]);
					
	var NewRecord = new record({
		RowId:'',
		Code:'',
		Desc:'',
		Type:'B'
	});
					
	StkSysAppGridDs.add(NewRecord);
	StkSysAppGrid.startEditing(StkSysAppGridDs.getCount() - 1, 1);
}

var StkSysAppStore = new Ext.data.SimpleStore({
	fields:['key', 'keyValue'],
	data:[["B",'ҵ��'], ["Q",'��ѯ'], ["S",'ͳ��'], ["M",'ά��']]
});
	
var StkSysAppGrid="";
//��������Դ
var StkSysAppGridUrl = 'dhcst.stksysappaction.csp';
var StkSysAppGridProxy= new Ext.data.HttpProxy({url:StkSysAppGridUrl+'?actiontype=selectAll',method:'GET'});
var StkSysAppGridDs = new Ext.data.Store({
	proxy:StkSysAppGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'},
		{name:'Type'}
	]),
	pruneModifiedRecords:true,
    remoteSort:false
});



//ģ��
var StkSysAppGridCm = new Ext.grid.ColumnModel([
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
						var cell=StkSysAppGrid.getSelectionModel().getSelectedCell();
						StkSysAppGrid.startEditing(cell[0], 2);
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
						var cell=StkSysAppGrid.getSelectionModel().getSelectedCell();
						StkSysAppGrid.startEditing(cell[0], 3);
					}
				}
			}
        })
    },{
        header:"ģ�����",
        dataIndex:'Type',
        width:200,
        align:'left',
        sortable:true,
		renderer:function(v, p, record){
			if(v=="B")
				return "ҵ��";
			if(v=="Q")
				return "��ѯ";
			if(v=="S")
				return "ͳ��";
			if(v=="M")
				return "ά��";
		},
		editor: new Ext.form.ComboBox({
			id:'StkSysAppField',
			width:216,
			listWidth:216,
			allowBlank:true,
			store:StkSysAppStore,
			value:'B', // Ĭ��ֵ"ҵ��"
			valueField:'key',
			displayField:'keyValue',
			emptyText:'',
			triggerAction:'all',
			emptyText:'',
			minChars:1,
			pageSize:200,
			mode:'local',
			selectOnFocus:true,
			forceSelection:true,
			editable:true,
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
StkSysAppGridCm.defaultSortable = true;

var addStkSysApp = new Ext.Toolbar.Button({
	text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveStkSysApp = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//��ȡ���е��¼�¼ 
		if(StkSysAppGrid.activeEditor != null){
			StkSysAppGrid.activeEditor.completeEdit();
		} 
		var mr=StkSysAppGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var code = mr[i].data["Code"].trim();
			var desc = mr[i].data["Desc"].trim();
			if((code!="")&&(desc!="")){
				var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc+"^"+mr[i].data["Type"].trim();
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
				url: StkSysAppGridUrl+'?actiontype=save',
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
						StkSysAppGridDs.load();
					}else{
						if(jsonData.info==-1){
							Msg.info("error", "�����ظ�!");
						}else if(jsonData.info==-2){
							Msg.info("error", "�����ظ�!");
						}else{
							Msg.info("error", "����ʧ��!" +jsonData.info);
						}
					}
				},
				scope: this
			});
		}
    }
});

var deleteStkSysApp = new Ext.Toolbar.Button({
	text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = StkSysAppGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", "��ѡ������!");
			return false;
		}else{
			var record = StkSysAppGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
							Ext.Ajax.request({
								url:StkSysAppGridUrl+'?actiontype=delete&rowid='+RowId,
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
										StkSysAppGridDs.load();
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
StkSysAppGrid = new Ext.grid.EditorGridPanel({
	store:StkSysAppGridDs,
	cm:StkSysAppGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
    tbar:[addStkSysApp,'-',saveStkSysApp,'-',deleteStkSysApp],
	clicksToEdit:1
});

StkSysAppGridDs.load();
//=========================Ӧ��ϵͳ����=================================

//===========ģ����ҳ��===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var StkSysAppPanel = new Ext.Panel({
		title:'Ӧ��ϵͳ����',
		activeTab: 0,
		region:'center',
		layout:'fit',
		items:[StkSysAppGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items:[StkSysAppPanel],
		renderTo: 'mainPanel'
	});
});
//===========ģ����ҳ��===============================================