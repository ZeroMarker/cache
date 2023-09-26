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
var ItmInsuCatGridUrl = 'dhcst.itminsucataction.csp';
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
		{name:'DateFrom',type:'date',dateFormat:App_StkDateFormat},
		{name:'DateTo',type:'date',dateFormat:App_StkDateFormat}
	]),
    remoteSort:false,
    pruneModifiedRecords:true
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
            allowBlank:true,
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
		renderer:Ext.util.Format.dateRenderer(App_StkDateFormat),
		editor:new Ext.ux.DateField({
			id:'dateFromField',
            allowBlank:false,
			format:App_StkDateFormat,
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
		renderer:Ext.util.Format.dateRenderer(App_StkDateFormat),
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
ItmInsuCatGridCm.defaultSortable = true;
var addItmInsuCat = new Ext.Toolbar.Button({
	text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
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
			var rowNum = ItmInsuCatGridDs.indexOf(mr[i])+1;
			var rowId = mr[i].data["RowId"];
			var code = mr[i].data["Code"].trim();
			var desc = mr[i].data["Desc"].trim();
			var self = mr[i].data["SelfPayRate"];
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
			if ((dateToB!="")&&(dateFromB!="")&&(dateToB<dateFromB)){
				Msg.info("warning", "��"+rowNum+"����ʼ���ڴ��ڽ�ֹ����!");
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
				var dataRow = rowId+"^"+code+"^"+desc+"^"+self+"^"+dateFrom+"^"+dateTo;
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
							Msg.info("warning", "�����ظ�!");
						}else if(jsonData.info==-2){
							Msg.info("warning", "�����ظ�!");
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
			Msg.info("warning", "��ѡ������!");
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
										ItmInsuCatGridDs.remove(record);
										ItmInsuCatGrid.getView().refresh();
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
				ItmInsuCatGridDs.remove(record);
				ItmInsuCatGrid.getView().refresh();
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
	tbar:[addItmInsuCat,'-',saveItmInsuCat,'-',deleteItmInsuCat],
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
		items:[ItmInsuCatGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[panel],
		renderTo:'mainPanel'
	});
});
//===========ģ����ҳ��===============================================