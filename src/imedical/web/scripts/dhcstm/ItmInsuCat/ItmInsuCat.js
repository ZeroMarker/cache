// ����:ҽ��������
// ��д����:2012-06-4

//=========================ҽ�����=============================
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
			name : 'SelfPayRate',
			type : 'double'
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
		SelfPayRate:'',
		DateFrom:'',
		DateTo:''
	});
					
	ItmInsuCatGridDs.add(NewRecord);
	ItmInsuCatGrid.startEditing(ItmInsuCatGridDs.getCount() - 1, 1);
}
	
var ItmInsuCatGrid="";
//��������Դ
var ItmInsuCatGridUrl = 'dhcstm.itminsucataction.csp';
var ItmInsuCatGridProxy= new Ext.data.HttpProxy({url:ItmInsuCatGridUrl+'?actiontype=query',method:'GET'});
var ItmInsuCatGridDs = new Ext.data.Store({
	proxy:ItmInsuCatGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results',
        pageSize:35
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'},
		{name:'SelfPayRate'},
		{name:'DateFrom',type:'date',dateFormat:DateFormat},
		{name:'DateTo',type:'date',dateFormat:DateFormat}
	]),
    remoteSort:false
});

//ģ��
var ItmInsuCatGridCm = new Ext.grid.ColumnModel([
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
						ItmInsuCatGrid.startEditing(ItmInsuCatGridDs.getCount() - 1, 2);
					}
				}
			}
        })
    },{
        header:"����",
        dataIndex:'Desc',
        width:200,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'descField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						ItmInsuCatGrid.startEditing(ItmInsuCatGridDs.getCount() - 1, 3);
					}
				}
			}
        })
    },{
        header:"�Ը���",
        dataIndex:'SelfPayRate',
        width:200,
        align:'left',
        sortable:true,
		editor: new Ext.form.NumberField({
			id:'selfField',
            allowBlank:false,
			decimalPrecision:4,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						ItmInsuCatGrid.startEditing(ItmInsuCatGridDs.getCount() - 1, 4);
					}
				}
			}
        })
    },{
        header:"��ʼ����",
        dataIndex:'DateFrom',
        width:200,
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
						ItmInsuCatGrid.startEditing(ItmInsuCatGridDs.getCount() - 1, 5);
					}
				}
			}
        })
    },{
        header:"��ֹ����",
        dataIndex:'DateTo',
        width:200,
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
ItmInsuCatGridCm.defaultSortable = true;
var addItmInsuCat = new Ext.Toolbar.Button({
	text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		// �ж��Ƿ��Ѿ��������
		var rowCount=ItmInsuCatGrid.getStore().getCount();
		if(rowCount>0){
		 var rowData=ItmInsuCatGridDs.data.items[rowCount-1]
			var data=rowData.get("RowId");
			if(data==null || data.length<=0){
				Msg.info("warning","�Ѵ����½���!");
				ItmInsuCatGrid.startEditing(ItmInsuCatGridDs.getCount()-1,1)
				return;
				
				}
			
			}
		
		addNewRow();
	}
});

var saveItmInsuCat = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//��ȡ���е��¼�¼ 
		var mr=ItmInsuCatGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var rowId = mr[i].data["RowId"];
			var code = mr[i].data["Code"].trim();
			var desc = mr[i].data["Desc"].trim();
			var self = mr[i].data["SelfPayRate"];
			var dateFrom = mr[i].data["DateFrom"];
			var dateTo = mr[i].data["DateTo"];
			if((dateFrom!="")&&(dateFrom!=null)){
				dateFrom = dateFrom.format(ARG_DATEFORMAT);
			}
			if((dateTo!="")&&(dateTo!=null)){
				dateTo = dateTo.format(ARG_DATEFORMAT);
			}
			if((code!="")&&(desc!="")){
				var dataRow = rowId+"^"+code+"^"+desc+"^"+self+"^"+dateFrom+"^"+dateTo;
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
				url: ItmInsuCatGridUrl+'?actiontype=save',
				params:{data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error", "������������!");
					ItmInsuCatGridDs.commitChanges();
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", "����ɹ�!");
						ItmInsuCatGridDs.load();
					}else{
						if(jsonData.info==-1){
							Msg.info("error", "�����ظ�!");
						}else if(jsonData.info==-2){
							Msg.info("error", "�����ظ�!");
						}else{
							Msg.info("error", "����ʧ��!");
						}
						ItmInsuCatGridDs.load();
					}
					ItmInsuCatGridDs.commitChanges();
				},
				scope: this
			});
		}
    }
});


var deleteItmInsuCat = new Ext.Toolbar.Button({
	text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = ItmInsuCatGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", "��ѡ������!");
			return false;
		}else{
			var record = ItmInsuCatGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
							Ext.Ajax.request({
								url:ItmInsuCatGridUrl+'?actiontype=delete&rowid='+RowId,
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
										ItmInsuCatGridDs.load();
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
ItmInsuCatGrid = new Ext.grid.EditorGridPanel({
	store:ItmInsuCatGridDs,
	cm:ItmInsuCatGridCm,
	trackMouseOver:true,
	region:'center',
	height:690,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	//tbar:[addItmInsuCat,'-',saveItmInsuCat,'-',deleteItmInsuCat],
	clicksToEdit:1
});

ItmInsuCatGridDs.load();
//=========================ҽ�����=============================

//===========ģ����ҳ��===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:'ҽ�����',
		activeTab:0,
		region:'center',
		tbar:[addItmInsuCat,'-',saveItmInsuCat],	//,'-',deleteItmInsuCat
		items:[ItmInsuCatGrid]                                 
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[panel],
		renderTo:'mainPanel'
	});
});
//===========ģ����ҳ��===============================================