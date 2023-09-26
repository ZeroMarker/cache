// ����:�����������
// ��д����:2012-05-10

//=========================��������=================================
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
		Type:''
	});
					
	OpTypeGridDs.add(NewRecord);
	OpTypeGrid.startEditing(OpTypeGridDs.getCount() - 1, 1);
}

var OpTypeStore = new Ext.data.SimpleStore({
	fields:['key', 'keyValue'],
	data:[["O",'����'], ["I",'���']]
});
	
var OpTypeGrid="";
//��������Դ
var OpTypeGridUrl = 'dhcstm.optypeaction.csp';
var OpTypeGridProxy= new Ext.data.HttpProxy({url:OpTypeGridUrl+'?actiontype=selectAll',method:'GET'});
var OpTypeGridDs = new Ext.data.Store({
	proxy:OpTypeGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'},
		{name:'Type'}
	]),
    remoteSort:true
});



//ģ��
var OpTypeGridCm = new Ext.grid.ColumnModel([
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
						OpTypeGrid.startEditing(OpTypeGridDs.getCount() - 1, 2);
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
						OpTypeGrid.startEditing(OpTypeGridDs.getCount() - 1, 3);
					}
				}
			}
        })
    },{
        header:"���",
        dataIndex:'Type',
        width:200,
        align:'left',
        sortable:true,
		renderer:function(v, p, record){
			if(v=="O")
				return "����";
			if(v=="I")
				return "���";
		},
		editor: new Ext.form.ComboBox({
			id:'opTypeField',
			width:216,
			listWidth:216,
			allowBlank:true,
			store:OpTypeStore,
			value:'O', // Ĭ��ֵ"����"
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
OpTypeGridCm.defaultSortable = true;

var addOpType = new Ext.Toolbar.Button({
	text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveOpType = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//��ȡ���е��¼�¼ 
		var mr=OpTypeGridDs.getModifiedRecords();
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
			//Ext.Msg.show({title:'����',msg:'û���޸Ļ����������!'});
			//Ext.MsgTip.msg('��Ϣ����', '��Ϣ����',true);//Ĭ��5����Զ�����
			Msg.info("error", "û���޸Ļ����������!");
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
			Ext.Ajax.request({
				url: OpTypeGridUrl+'?actiontype=save',
				params: {data:data},
				failure: function(result, request) {
					 mask.hide();
					//Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					Msg.info("error", "������������!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						//Ext.Msg.show({title:'ע��',msg:'����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						Msg.info("success", "����ɹ�!");
						OpTypeGridDs.load();
					}else{
						//Ext.Msg.show({title:'����',msg:jsonData.info+" ����ʧ��",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						Msg.info("error", "����ʧ��!" +jsonData.info);
						OpTypeGridDs.load();
					}
				},
				scope: this
			});
		}
    }
});

var deleteOpType = new Ext.Toolbar.Button({
	text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = OpTypeGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			//Ext.Msg.show({title:'��ʾ',msg:'��ѡ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			Msg.info("error", "��ѡ������!");
			return false;
		}else{
			var record = OpTypeGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
							Ext.Ajax.request({
								url:OpTypeGridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:'ɾ����...',
								failure: function(result, request) {
									 mask.hide();
									//Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									Msg.info("error", "������������!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									 mask.hide();
									if (jsonData.success=='true') {
										//Ext.Msg.show({title:'��ʾ',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										Msg.info("success", "ɾ���ɹ�!");
										OpTypeGridDs.load();
									}else{
										//Ext.Msg.show({title:'��ʾ',msg:'ɾ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										Msg.info("error", "ɾ��ʧ��!");
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				//Ext.Msg.show({title:'��ʾ',msg:'�����д�,û��RowId!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				Msg.info("error", "�����д�,û��RowId!");
			}
		}
    }
});

//���
OpTypeGrid = new Ext.grid.EditorGridPanel({
	store:OpTypeGridDs,
	cm:OpTypeGridCm,
	trackMouseOver:true,
	height:690,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
    tbar:[addOpType,'-',saveOpType,'-',deleteOpType]
});

OpTypeGridDs.load();
//=========================��������=================================

//===========ģ����ҳ��===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var OpTypePanel = new Ext.Panel({
		title:'�����ά��',
		activeTab: 0,
		region:'center',
		items:[OpTypeGrid]                                 
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout: 'border',
		items:[OpTypePanel],
		renderTo: 'mainPanel'
	});
});
//===========ģ����ҳ��===============================================