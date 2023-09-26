// ����:�˲�����ά��
// ��д����:2013-05-16	
//Creater:wangguohua
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
					
	BookCatGridDs.add(NewRecord);
	BookCatGrid.startEditing(BookCatGridDs.getCount() - 1, 1);
}

var BookCatGrid="";
//��������Դ
var BookCatGridUrl = 'dhcstm.bookcataction.csp';
var BookCatGridProxy= new Ext.data.HttpProxy({url:BookCatGridUrl+'?actiontype=query',method:'GET'});
var BookCatGridDs = new Ext.data.Store({
	proxy:BookCatGridProxy,
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
//Grid��ģ��
var BookCatGridCm = new Ext.grid.ColumnModel([
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
						 BookCatGrid.startEditing(BookCatGridDs.getCount() - 1, 2);
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
BookCatGridCm.defaultSortable = true;

//�½�
var addBookCat = new Ext.Toolbar.Button({
	text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

//����
var saveBookCat = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//��ȡ���е��¼�¼ 
		var mr=BookCatGridDs.getModifiedRecords();
		var data="";
		var rowDelim=xRowDelim();
		for(var i=0;i<mr.length;i++){
		
			var code = mr[i].data["Code"].trim();
			var desc = mr[i].data["Desc"].trim();
			if((code!="")&&(desc!="")){
				var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc;
				if(data==""){
					data = dataRow;
				}else{
					data = data + rowDelim + dataRow;
				}
			}
			
		}

		if(data==""){
			Msg.info("error", "û���޸Ļ����������!");
			return false;
		}else{
			Ext.Ajax.request({
				url: BookCatGridUrl+'?actiontype=save',
				params:{data:data},
				failure: function(result, request) {
					Msg.info("error", "������������!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success", "����ɹ�!");
						BookCatGridDs.load();
					}else{
						var date=jsonData.info
						if(date==-5){
						Msg.info("error", "�����ظ�!");}
						else if(date==-6){
						Msg.info("error", "�����ظ�!" );}
						else{
						Msg.info("error", "����ʧ��!");
						}
						BookCatGridDs.load();
					}
				},
				scope: this
			});
		}
    }
});

//ɾ��
var deleteBookCat = new Ext.Toolbar.Button({
	text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = BookCatGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", "��ѡ������!");
			return false;
		}else{
			var record = BookCatGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
					function(btn) {
						if(btn == 'yes'){
							Ext.Ajax.request({
								url:BookCatGridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:'ɾ����...',
								failure: function(result, request) {
									Msg.info("error", "������������!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true') {
										Msg.info("success", "ɾ���ɹ�!");
										BookCatGridDs.load();
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

//�����
BookCatGrid = new Ext.grid.EditorGridPanel({
	store:BookCatGridDs,
	cm:BookCatGridCm,
	trackMouseOver:true,
	region:'center',
	height:690,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[addBookCat,'-',saveBookCat],	//,'-',deleteBookCat
	clicksToEdit:1
});

BookCatGridDs.load();

//ģ����ҳ��
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:'�˲�����ά��',
		activeTab:0,
		region:'center',
		items:[BookCatGrid]                                 
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[panel],
		renderTo:'mainPanel'
	});
});