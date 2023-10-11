// ����:���������
// ��д����:2012-05-23

//=========================���������=============================
var conditionCodeField = new Ext.form.TextField({
	id:'conditionCodeField',
	fieldLabel:$g('����'),
	allowBlank:true,
	width:180,
	listWidth:180,
	emptyText:$g('����...'),
	anchor:'90%',
	selectOnFocus:true
});
	
var conditionDescField = new Ext.form.TextField({
	id:'conditionDescField',
	fieldLabel:$g('����'),
	allowBlank:true,
	width:150,
	listWidth:150,
	emptyText:$g('����...'),
	anchor:'90%',
	selectOnFocus:true
});
	
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
		Type:'G'
	});
					
	StkLocGrpGridDs.add(NewRecord);
	StkLocGrpGrid.startEditing(StkLocGrpGridDs.getCount() - 1, 1);
}


var StkLocGrpGrid="";
//��������Դ
var StkLocGrpGridUrl = 'dhcst.StkLocGrpaction.csp';
var StkLocGrpGridProxy= new Ext.data.HttpProxy({url:StkLocGrpGridUrl+'?actiontype=query',method:'POST'});
var StkLocGrpGridDs = new Ext.data.Store({
	proxy:StkLocGrpGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results',
        pageSize:35
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'},
		{name:'Type'}
	]),
    remoteSort:false,
    pruneModifiedRecords:true
});

//ģ��
var StkLocGrpGridCm = new Ext.grid.ColumnModel([
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
						StkLocGrpGrid.startEditing(StkLocGrpGridDs.getCount() - 1, 2);
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
						addNewRow();
					}
				}
			}
        })
    }
]);

//��ʼ��Ĭ��������
StkLocGrpGridCm.defaultSortable = true;

var findStkLocGrp = new Ext.Toolbar.Button({
	text:$g('��ѯ'),
    tooltip:$g('��ѯ'),
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
			Query();
	}
});

var addStkLocGrp = new Ext.Toolbar.Button({
	text:$g('�½�'),
    tooltip:$g('�½�'),
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveStkLocGrp = new Ext.Toolbar.Button({
	text:$g('����'),
    tooltip:$g('����'),
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//��ȡ���е��¼�¼ 
		var mr=StkLocGrpGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var code = mr[i].data["Code"].trim();
			var desc = mr[i].data["Desc"].trim();
			var rowNum = StkLocGrpGridDs.indexOf(mr[i])+1;
			if (code==""){
				Msg.info("warning", $g("��")+rowNum+$g("�д���Ϊ��!"));
				return;
			}
			if (desc==""){
				Msg.info("warning", $g("��")+rowNum+$g("������Ϊ��!"));
				return;
			}
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
			Msg.info("warning", $g("û���޸Ļ����������!"));
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),$g("���������Ժ�..."));
			Ext.Ajax.request({
				url: StkLocGrpGridUrl+'?actiontype=save',
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
						Query();
					}else{
						var date=jsonData.info
						if(date==-5){
							Msg.info("warning", $g("�����ظ�!"));}
						else if(date==-6){
							Msg.info("warning", $g("�����ظ�!" ));}
						else {
							Msg.info("error", $g("����ʧ�ܣ�" ));
						}
						//Query();
					}
				},
				scope: this
			});
		}
    }
});


var deleteStkLocGrp = new Ext.Toolbar.Button({
	text:$g('ɾ��'),
    tooltip:$g('ɾ��'),
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = StkLocGrpGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", $g("��ѡ������!"));
			return false;
		}else{
			var record = StkLocGrpGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm($g('��ʾ'),$g('ȷ��Ҫɾ��ѡ������?'),
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),$g("���������Ժ�..."));
							Ext.Ajax.request({
								url:StkLocGrpGridUrl+'?actiontype=delete&rowid='+RowId,
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
										StkLocGrpGridDs.remove(record);
										StkLocGrpGrid.getView().refresh();
										StkLocGrpGridDs.reload();
									}else{
										if(jsonData.info==-2){
											Msg.info("warning", $g("���������ڿ���������Ϣ��ʹ�ã�����ɾ��!"));
										}else{
											Msg.info("error", $g("ɾ��ʧ��!"));
										}
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				StkLocGrpGridDs.remove(record);
				StkLocGrpGrid.getView().refresh();
			}
		}
    }
});

var formPanel = new Ext.form.FormPanel({
	labelWidth : 60,
	autoScroll:true,
	labelAlign : 'right',
	frame : true,
	autoHeight:true,
	//bodyStyle : 'padding:5px;',
    tbar:[findStkLocGrp,'-',addStkLocGrp,'-',saveStkLocGrp,'-',deleteStkLocGrp],
	items : [{
		xtype : 'fieldset',
		title : $g('��ѯ����'),
		style:DHCSTFormStyle.FrmPaddingV,
			layout : 'column',
			items : [{
				columnWidth : .33,
				xtype : 'fieldset',
				border:false,
				items : [conditionCodeField]
			}, {
				columnWidth : .33,
				xtype : 'fieldset',
				border:false,
				items : [conditionDescField]
			}]
		}]
});

//��ҳ������
var StkLocGrpPagingToolbar = new Ext.PagingToolbar({
    store:StkLocGrpGridDs,
	pageSize:35,
    displayInfo:true,
    displayMsg:$g('�� {0} ���� {1}�� ��һ�� {2} ��'),
    emptyMsg:$g("û�м�¼"),
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B[A.sort]='RowId';
		B[A.dir]='desc';
		B['conditionCode']=Ext.getCmp('conditionCodeField').getValue();
		B['conditionDesc']=Ext.getCmp('conditionDescField').getValue();
		B['conditionType']=conditionType;
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
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
	clicksToEdit:1,
	layout:'fit'
});
function Query()
{
		var conditionCode = Ext.getCmp('conditionCodeField').getValue();
		var conditionDesc = Ext.getCmp('conditionDescField').getValue();
		var conditionType = "G";
		StkLocGrpGridDs.load({params:{start:0,limit:StkLocGrpPagingToolbar.pageSize,sort:'RowId',dir:'asc',conditionCode:conditionCode,conditionDesc:conditionDesc,conditionType:conditionType}});
}

var HospPanel = InitHospCombo('DHC_StkLocGroup',function(combo, record, index){
	HospId = this.value; 
	Ext.getCmp('conditionCodeField').setValue('');
	Ext.getCmp('conditionDescField').setValue('');
	Query();
});
//=========================���������=============================

//===========ģ����ҳ��===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		id:"panel",
		title:$g('�����鶨��'),
		layout:'fit',
		activeTab:0,
		region:'north',
		height:DHCSTFormStyle.FrmHeight(1),
		items:[formPanel]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		fit:true,
		//items:[HospPanel,panel,StkLocGrpGrid],
		items:[
			{
				region:'north',
				height:'50px',
				items:[HospPanel,panel]
			},StkLocGrpGrid
		],
		renderTo:'mainPanel'
	});
});
Query();
//===========ģ����ҳ��===============================================