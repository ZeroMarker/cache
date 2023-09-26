// ����:���������
// ��д����:2012-05-23

//=========================���������=============================
var FLocDesc = new Ext.ux.LocComboBox({
    id:'FLocDesc',
    anchor:'90%',
    fieldLabel:'��������',
    emptyText:'��ѡ��...',
	defaultLoc:''
});	 

var LocDesc = new Ext.ux.LocComboBox({
    id:'LocDesc',
    anchor:'90%',
    fieldLabel:'��������',
    emptyText:'��ѡ��...',
	defaultLoc:''
});	
var SCG = new Ext.ux.StkGrpComboBox ({
	fieldLabel : '����',
	id : 'SCG',
	name : 'SCG',
	anchor : '90%',
	StkType:App_StkTypeCode,
	emptyText : '����...'
});
var TransferFlagStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['MM', 'MM'], ['MO', 'MO'], ['MR', 'MR'], ['MF', 'MF']]
	});
	var TransferFlag = new Ext.form.ComboBox({
		fieldLabel : 'ͳ�Ʒ�ʽ',
		id : 'TransferFlag',
		name : 'TransferFlag',
		anchor : '90%',
		store : TransferFlagStore,
		valueField : 'RowId',
		displayField : 'Description',
		mode : 'local',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		listWidth : 150,
		forceSelection : true
	});
function addNewRow() {
	var record = Ext.data.Record.create([
		{
			name : 'RowId',
			type : 'int'
		}, {
			name : 'LocDescId',
			type : 'string'
		}, {
			name : 'GrpId',
			type : 'string'
		}, {
			name : 'PtMod',
			type : 'string'
		}
	]);
					
	var NewRecord = new record({
		RowId:'',
		LocDescId:'',
		GrpId:'',
		PtMod:''
	});
					
	StkLocGrpGridDs.add(NewRecord);
	StkLocGrpGrid.startEditing(StkLocGrpGridDs.getCount() - 1, 1);
}


var StkLocGrpGrid="";
//��������Դ
var StkLocGrpGridUrl = 'dhcstm.stklocgrpaction.csp';
var StkLocGrpGridProxy= new Ext.data.HttpProxy({url:StkLocGrpGridUrl+'?actiontype=QueryPtMod',method:'POST'});
var StkLocGrpGridDs = new Ext.data.Store({
	proxy:StkLocGrpGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results'
    }, [
		{name:'RowId'},
		{name:'LocDescId'},
		{name:'GrpId'},'GrpDesc',
		{name:'PtMod'},
		{name:'LocDesc'}
	]),
    remoteSort:false,
    pruneModifiedRecords:true
});

//ģ��
var StkLocGrpGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header : "��������",
        dataIndex : 'LocDescId',
        width : 110,
        align : 'left',
        sortable : true,
        editor : new Ext.grid.GridEditor(LocDesc),
        renderer :Ext.util.Format.comboRenderer2(LocDesc,"LocDescId","LocDesc") 
    },{
         header:"����",
        dataIndex:'GrpId',
        width:180,
        align:'left',
        sortable:true,
		renderer : Ext.util.Format.comboRenderer2(SCG,'GrpId','GrpDesc'),
		editor:new Ext.grid.GridEditor(SCG)
    },{
         header:"��ӡ����",
        dataIndex:'PtMod',
        width:180,
        align:'left',
        sortable:true,
		renderer : Ext.util.Format.comboRenderer(TransferFlag),
		editor:new Ext.grid.GridEditor(TransferFlag)
    }
]);

//��ʼ��Ĭ��������
StkLocGrpGridCm.defaultSortable = true;

var findStkLocGrp = new Ext.Toolbar.Button({
	text:'��ѯ',
    tooltip:'��ѯ',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		var LocId = Ext.getCmp('FLocDesc').getValue();
		//var conditionDesc = Ext.getCmp('conditionDescField').getValue();
		//StkLocGrpGridDs.setBaseParam('conditionCode',conditionCode)
		
		StkLocGrpGridDs.setBaseParam('LocId',LocId)
		StkLocGrpGridDs.load({params:{start:0,limit:StkLocGrpPagingToolbar.pageSize,sort:'RowId',dir:'desc'}});
	}
});

var addStkLocGrp = new Ext.Toolbar.Button({
	text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveStkLocGrp = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(StkLocGrpGrid.activeEditor!=null){
			StkLocGrpGrid.activeEditor.completeEdit();
		}
		//��ȡ���е��¼�¼ 
		var mr=StkLocGrpGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var LocId = mr[i].data["LocDescId"].trim();
			var ScgId = mr[i].data["GrpId"].trim();
			var Mod = mr[i].data["PtMod"].trim();
			var RowId = mr[i].data["RowId"].trim();
			if((LocId!="")&&(ScgId!="")&&(Mod!="")){
				var dataRow = LocId+"^"+ScgId+"^"+Mod+"^"+RowId
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
				url: StkLocGrpGridUrl+'?actiontype=SavePtMod',
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
						findStkLocGrp.handler();
						//StkLocGrpGridDs.reload();
					}else{
						
						Msg.info("error", "����ʧ�ܣ�" );}
	
				},
				scope: this
			});
		}
    }
});


var deleteStkLocGrp = new Ext.Toolbar.Button({
	text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
	}
});

var formPanel = new Ext.form.FormPanel({
	title:'��ӡ����',
	labelwidth : 30,
	labelAlign : 'right',
	region:'north',
	height:140,
	frame : true,
	bodyStyle : 'padding:5px;',
    tbar:[findStkLocGrp,'-',addStkLocGrp,'-',saveStkLocGrp],	//,'-',deleteStkLocGrp
	items : [{
		items : [{
			xtype : 'fieldset',
			title : '��ѯ����',
			items : [{
				layout : 'column',
				items : [{
					columnWidth : .3,
					layout : 'form',
					items : [FLocDesc]
				}, {
					columnWidth : .3,
					layout : 'form',
					items : []
				}]
			}]
		}]
	}]
});

//��ҳ������
var StkLocGrpPagingToolbar = new Ext.PagingToolbar({
    store:StkLocGrpGridDs,
	pageSize:35,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼"
});

//���
StkLocGrpGrid = new Ext.grid.EditorGridPanel({
	store:StkLocGrpGridDs,
	cm:StkLocGrpGridCm,
	trackMouseOver:true,
	region:'center',
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	bbar:StkLocGrpPagingToolbar,
	clicksToEdit:1
});

//=========================���������=============================

//===========ģ����ҳ��===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,StkLocGrpGrid],
		renderTo:'mainPanel'
	});
	findStkLocGrp.handler();
});
//===========ģ����ҳ��===============================================