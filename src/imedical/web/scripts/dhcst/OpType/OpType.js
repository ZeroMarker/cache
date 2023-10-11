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
		}, {
			name : 'Default',
			type : 'string'
		}
	]);
					
	var NewRecord = new record({
		RowId:'',
		Code:'',
		Desc:'',
		Type:'',
		Default:''
	});
					
	OpTypeGridDs.add(NewRecord);
	OpTypeGrid.startEditing(OpTypeGridDs.getCount() - 1, 1);
}

var OpTypeStore = new Ext.data.SimpleStore({
	fields:['key', 'keyValue'],
	data:[["O",$g('����')], ["I",$g('���')]]
});
	
var OpTypeGrid="";
//��������Դ
var OpTypeGridUrl = 'dhcst.optypeaction.csp';
var OpTypeGridProxy= new Ext.data.HttpProxy({url:OpTypeGridUrl+'?actiontype=selectAll',method:'GET'});
var OpTypeGridDs = new Ext.data.Store({
	proxy:OpTypeGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'},
		{name:'Type'},
		{name:'Default'}
	]),
	pruneModifiedRecords:true,
    remoteSort:false
});

var DefaultField = new Ext.grid.CheckColumn({
	header:$g('�Ƿ�Ĭ��'),
	dataIndex:'Default',
	width:100,
	sortable:true
});

//ģ��
var OpTypeGridCm = new Ext.grid.ColumnModel([
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
						OpTypeGrid.startEditing(OpTypeGridDs.getCount() - 1, 2);
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
						OpTypeGrid.startEditing(OpTypeGridDs.getCount() - 1, 3);
					}
				}
			}
        })
    },{
        header:$g("���"),
        dataIndex:'Type',
        width:200,
        align:'left',
        sortable:true,
		renderer:function(v, p, record){
			if(v=="O")
				return $g("����");
			if(v=="I")
				return $g("���");
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
    },DefaultField
]);

//��ʼ��Ĭ��������
OpTypeGridCm.defaultSortable = true;

var addOpType = new Ext.Toolbar.Button({
	text:$g('�½�'),
    tooltip:$g('�½�'),
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveOpType = new Ext.Toolbar.Button({
	text:$g('����'),
    tooltip:$g('����'),
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
			var type = mr[i].data["Type"].trim();
			var defaultflag=mr[i].data["Default"];
			var rowNum = OpTypeGridDs.indexOf(mr[i])+1;
			if (code==""){
				Msg.info("warning", $g("��")+rowNum+$g("�д���Ϊ��!"));
				return;
			}
			if (desc==""){
				Msg.info("warning", $g("��")+rowNum+$g("������Ϊ��!"));
				return;
			}
			if (type==""){
				Msg.info("warning", $g("��")+rowNum+$g("�����Ϊ��!"));
				return;
			}	
			if((code!="")&&(desc!="")&&(type!="")){
				var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc+"^"+type+"^"+defaultflag;
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
				url: OpTypeGridUrl+'?actiontype=save',
				params: {data:data},
				failure: function(result, request) {
					mask.hide();
					Msg.info("error", $g("������������!"));
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", $g("����ɹ�!"));
						OpTypeGridDs.load();
					}else{
						Msg.info("error", $g("����ʧ��!") +jsonData.info);
						OpTypeGridDs.load();
					}
				},
				scope: this
			});
		}
    }
});

var deleteOpType = new Ext.Toolbar.Button({
	text:$g('ɾ��'),
    tooltip:$g('ɾ��'),
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = OpTypeGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning", $g("��ѡ������!"));
			return false;
		}else{
			var record = OpTypeGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm($g('��ʾ'),$g('ȷ��Ҫɾ��ѡ������?'),
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),$g("���������Ժ�..."));
							Ext.Ajax.request({
								url:OpTypeGridUrl+'?actiontype=delete&rowid='+RowId,
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
										OpTypeGridDs.remove(record);
										OpTypeGrid.getView().refresh();
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
				OpTypeGridDs.remove(record);
				OpTypeGrid.getView().refresh();
			}
		}
    }
});

//���
OpTypeGrid = new Ext.grid.EditorGridPanel({
	store:OpTypeGridDs,
	cm:OpTypeGridCm,
	trackMouseOver:true,
	height:770,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	plugins:[DefaultField],
    tbar:[addOpType,'-',saveOpType,'-',deleteOpType],
	clicksToEdit:1
});

OpTypeGridDs.load();

var HospPanel = InitHospCombo('DHC_OperateType',function(combo, record, index){
	HospId = this.value; 
	OpTypeGridDs.reload();
});

//=========================��������=================================

//===========ģ����ҳ��===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var OpTypePanel = new Ext.Panel({
		title:$g('�����ά��'),
		activeTab: 0,
		region:'center',
		items:[OpTypeGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items:[HospPanel, OpTypePanel],
		renderTo: 'mainPanel'
	});
});
//===========ģ����ҳ��===============================================