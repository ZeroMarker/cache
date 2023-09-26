// ����:�����������ι���
// ��д����:2012-06-4

//=========================������������=============================
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
					
	ItmQLGridDs.add(NewRecord);
	ItmQLGrid.startEditing(ItmQLGridDs.getCount() - 1, 1);
}
	
var ItmQLGrid="";
//��������Դ
var ItmQLGridUrl = 'dhcst.itmqualitylevelaction.csp';
var ItmQLGridProxy= new Ext.data.HttpProxy({url:ItmQLGridUrl+'?actiontype=query',method:'GET'});
var ItmQLGridDs = new Ext.data.Store({
	proxy:ItmQLGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results',
        pageSize:35
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'},
		{name:'DateFrom',type:'date',dateFormat:App_StkDateFormat},
		{name:'DateTo',type:'date',dateFormat:App_StkDateFormat}
	]),
    remoteSort:false,
    pruneModifiedRecords:true
});

//ģ��
var ItmQLGridCm = new Ext.grid.ColumnModel([
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
						ItmQLGrid.startEditing(ItmQLGridDs.getCount() - 1, 2);
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
						ItmQLGrid.startEditing(ItmQLGridDs.getCount() - 1, 3);
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
		renderer:Ext.util.Format.dateRenderer(App_StkDateFormat),
		editor:new Ext.ux.DateField({
			id:'dateFromField',
            allowBlank:false,
			format:App_StkDateFormat,
			anchor:'90%',
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						ItmQLGrid.startEditing(ItmQLGridDs.getCount() - 1, 4);
					}
				}
			}
        })
    },{
        header:"��ֹ����",
        dataIndex:'DateTo',
        width:180,
        align:'left',
		renderer:Ext.util.Format.dateRenderer(App_StkDateFormat),
        sortable:true,
		editor:new Ext.ux.DateField({
			id:'dateToField',
            allowBlank:false,
			format:App_StkDateFormat,
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
ItmQLGridCm.defaultSortable = true;
var addItmQL = new Ext.Toolbar.Button({
	text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveItmQL = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//��ȡ���е��¼�¼ 
		var mr=ItmQLGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var rowId = mr[i].data["RowId"];
			var code = mr[i].data["Code"].trim();
			var desc = mr[i].data["Desc"].trim();
			var dateFrom = mr[i].data["DateFrom"];
			var dateTo = mr[i].data["DateTo"];
			var dateFromB,dateToB;
			if((dateFrom!="")&&(dateFrom!=null)){
				dateFromB=dateFrom.format('Y-m-d');
				dateFrom = dateFrom.format(App_StkDateFormat);
			}
			if((dateTo!="")&&(dateTo!=null)){
				dateToB = dateTo.format('Y-m-d')
				dateTo = dateTo.format(App_StkDateFormat);
			}
			var rowNum = ItmQLGridDs.indexOf(mr[i])+1;
			if ((dateToB!="")&&(dateFromB!="")&&(dateToB<dateFromB)){
				Msg.info("warning", "��"+rowNum+"��ʼ���ڴ��ڽ�ֹ����!");
				return;
			}
			if (code==""){
				Msg.info("warning", "��"+rowNum+"�д���Ϊ��!");
				return;
			}
			if (desc==""){
				Msg.info("warning", "��"+rowNum+"������Ϊ��!");
				return;
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
			Msg.info("warning", "û���޸Ļ����������!");
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
			Ext.Ajax.request({
				url: ItmQLGridUrl+'?actiontype=save',
				params:{data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error", "������������!");
					ItmQLGridDs.commitChanges();
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", "����ɹ�!");
						ItmQLGridDs.load();
					}else{
						if(jsonData.info==-1){
							Msg.info("warning", "�����ظ�!");
						}else if(jsonData.info==-2){
							Msg.info("warning", "�����ظ�!");
						}else{
							Msg.info("error", "����ʧ��!");
						}
					}
					ItmQLGridDs.commitChanges();
					ItmQLGridDs.reload();
				},
				scope: this
			});
		}
    }
});


var deleteItmQL = new Ext.Toolbar.Button({
	text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = ItmQLGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", "��ѡ������!");
			return false;
		}else{
			var record = ItmQLGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
							Ext.Ajax.request({
								url:ItmQLGridUrl+'?actiontype=delete&rowid='+RowId,
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
										ItmQLGridDs.remove(record);
										ItmQLGrid.getView().refresh();
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
				ItmQLGridDs.remove(record);
				ItmQLGrid.getView().refresh();
			}
		}
    }
});

//���
ItmQLGrid = new Ext.grid.EditorGridPanel({
	store:ItmQLGridDs,
	cm:ItmQLGridCm,
	trackMouseOver:true,
	region:'center',
	height:770,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[addItmQL,'-',saveItmQL,'-',deleteItmQL],
	clicksToEdit:1
});

ItmQLGridDs.load();
//=========================������������=============================

//===========ģ����ҳ��===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:'������������',
		activeTab:0,
		region:'center',
		items:[ItmQLGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[panel],
		renderTo:'mainPanel'
	});
});
//===========ģ����ҳ��===============================================