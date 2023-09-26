// ����:�б꼶��ά������
// ��д����:2012-06-4

//=========================�б꼶��ά��=============================
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
			name : 'DateFrom',
			type : 'string'
		}, {
			name : 'DateTo',
			type : 'string'
		}
	]);
					
	var NewRecord = new record({
		RowId:'',
		Code:'',
		Desc:'',
		DateFrom:'',
		DateTo:''
	});
					
	ItmPBLevelGridDs.add(NewRecord);
	ItmPBLevelGrid.startEditing(ItmPBLevelGridDs.getCount() - 1, 1);
}
	
var ItmPBLevelGrid="";
//��������Դ
var ItmPBLevelGridUrl = 'dhcstm.itmpblevelaction.csp';
var ItmPBLevelGridProxy= new Ext.data.HttpProxy({url:ItmPBLevelGridUrl+'?actiontype=query',method:'GET'});
var ItmPBLevelGridDs = new Ext.data.Store({
	proxy:ItmPBLevelGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results',
        pageSize:35
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'},
		{name:'DateFrom',type:'date',dateFormat:DateFormat},
		{name:'DateTo',type:'date',dateFormat:DateFormat}
	]),
    remoteSort:false
});

//ģ��
var ItmPBLevelGridCm = new Ext.grid.ColumnModel([
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
						ItmPBLevelGrid.startEditing(ItmPBLevelGridDs.getCount() - 1, 2);
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
						ItmPBLevelGrid.startEditing(ItmPBLevelGridDs.getCount() - 1, 3);
					}
				}
			}
        })
    },{
        header:"��ʼ����",
        dataIndex:'DateFrom',
        width:180,
        align:'left',
        sortable:true,
		renderer:Ext.util.Format.dateRenderer(DateFormat),
		editor:new Ext.ux.DateField({
			id:'dateFromField',
            allowBlank:false,
			anchor:'90%',
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						ItmPBLevelGrid.startEditing(ItmPBLevelGridDs.getCount() - 1, 4);
					}
				}
			}
        })
    },{
        header:"��ֹ����",
        dataIndex:'DateTo',
        width:180,
        align:'left',
        sortable:true,
		renderer:Ext.util.Format.dateRenderer(DateFormat),
		editor:new Ext.ux.DateField({
			id:'dateToField',
            allowBlank:false,
			anchor:'90%',
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
ItmPBLevelGridCm.defaultSortable = true;
var addItmPBLevel = new Ext.Toolbar.Button({
	text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		// �ж��Ƿ��Ѿ��������
		var rowCount=ItmPBLevelGrid.getStore().getCount();
		if(rowCount>0){
			var rowData=ItmPBLevelGridDs.data.items[rowCount-1];
			var data=rowData.get("RowId");
			if(data==null || data.length<=0){
				Msg.info("Warning","�Ѿ������½���!");
				ItmPBLevelGrid.startEditing(ItmPBLevelGridDs.getCount()-1,1);
				return ;
				}
			}
		addNewRow();
	}
});

var saveItmPBLevel = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//��ȡ���е��¼�¼ 
		var mr=ItmPBLevelGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var rowId = mr[i].data["RowId"];
			var code = mr[i].data["Code"].trim();
			var desc = mr[i].data["Desc"].trim();
			var dateFrom = mr[i].data["DateFrom"];
			var dateTo = mr[i].data["DateTo"];
			if((dateFrom!="")&&(dateFrom!=null)){
				dateFrom = dateFrom.format(ARG_DATEFORMAT);
			}
			if((dateTo!="")&&(dateTo!=null)){
				dateTo = dateTo.format(ARG_DATEFORMAT);
			}
			if((code!="")&&(desc!="")){
				var dataRow = rowId+"^"+code+"^"+desc+"^"+dateFrom+"^"+dateTo;
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
				url: ItmPBLevelGridUrl+'?actiontype=save',
				params:{data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error", "������������!");
					ItmPBLevelGridDs.commitChanges();
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", "����ɹ�!");
						ItmPBLevelGridDs.load();
					}else{
						ItmPBLevelGridDs.load();
						if(jsonData.info==-1){
							Msg.info("error", "�����ظ�!");
						}else if(jsonData.info==-2){
							Msg.info("error", "�����ظ�!");
						}else{
							Msg.info("error", "����ʧ��!");
						}
					}
					ItmPBLevelGridDs.commitChanges();
				},
				scope: this
			});
		}
    }
});


var deleteItmPBLevel = new Ext.Toolbar.Button({
	text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = ItmPBLevelGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", "��ѡ������!");
			return false;
		}else{
			var record = ItmPBLevelGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
							Ext.Ajax.request({
								url:ItmPBLevelGridUrl+'?actiontype=delete&rowid='+RowId,
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
										ItmPBLevelGridDs.load();
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
ItmPBLevelGrid = new Ext.grid.EditorGridPanel({
	store:ItmPBLevelGridDs,
	cm:ItmPBLevelGridCm,
	trackMouseOver:true,
	region:'center',
	height:690,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[addItmPBLevel,'-',saveItmPBLevel],	//,'-',deleteItmPBLevel
	clicksToEdit:1
});

ItmPBLevelGridDs.load();
//=========================�б꼶��ά��=============================

//===========ģ����ҳ��=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:'�б꼶��',
		activeTab:0,
		region:'center',
		layout:'fit',
		items:[ItmPBLevelGrid]                                 
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[panel],
		renderTo:'mainPanel'
	});
});
//===========ģ����ҳ��=============================================