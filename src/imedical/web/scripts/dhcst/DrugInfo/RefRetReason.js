//=====================UI=======================
var RefUrl = 'dhcst.druginfomaintainaction.csp';
///��������Դ
var RefDetailGridProxy= new Ext.data.HttpProxy({url:RefUrl+'?actiontype=GetRefRetReason',method:'POST'});
var RefDetailGridDs = new Ext.data.Store({
	proxy:RefDetailGridProxy,
    reader:new Ext.data.JsonReader({
		totalProperty:'results',
        root:'rows'
    }, [
		{name:'RowID'},
		{name:'Code'},
		{name:'Desc'}
	]),
	pruneModifiedRecords:true,
    remoteSort:false
});

///������ҩComboBox
var RefCombStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
				url : RefUrl+'?actiontype=GetRefRetReaComb&Desc='
			}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['RowID','Desc'])
});

var nm=new Ext.grid.RowNumberer();
var DetailCm=new Ext.grid.ColumnModel([nm,
	{
		header:'RowID',
		dataIndex:'RowID',
		width:100,
		sortable:true//,
		//hidden:true
	},{
		header:'����',
		dataIndex:'Code',
		width:100,
		sortable:true,
		editor: new Ext.form.TextField({
			id:'codeField',
	        allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						DetailGrid.startEditing(RefDetailGridDs.getCount() - 1, 3);
					}
				}
			}
	    })
	},{
		header:'����',
		dataIndex:'Desc',
		width:300,
		sortable:false,
		editor: new Ext.form.TextField({
			id:'descField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						AddNewRow();
					}
				}
			}
        })
	}
]);

//����
var CodeField = new Ext.form.TextField({
	id:'CodeField',
	fieldLabel:'����',
	allowBlank:true,
	anchor:'90%',
	selectOnFocus:true
});

//����
var DescField = new Ext.form.TextField({
	id:'DescField',
	fieldLabel:'����',
	allowBlank:true,
	anchor:'90%',
	selectOnFocus:true
});

var PagingToolBar1=new Ext.PagingToolbar({
	id:'PagingToolBar1',
	store:RefDetailGridDs,
	displayInfo:true,
	pageSize:'30',
	displayMsg:"�� {0} ���� {1}�� ��һ�� {2} ��",
	emptyMsg:"û������",
	firstText:'��һҳ',
	lastText:'���һҳ',
	prevText:'��һҳ',
	refreshText:'ˢ��',
	nextText:'��һҳ'		
});

//ԭ��
var RefReasonCmb = new Ext.ux.ComboBox({
	fieldLabel : 'ԭ��',
	id : 'RefReasonCmb',
	name : 'RefReasonCmb',
	store : RefCombStore,
	valueField : 'RowID',
	displayField : 'Desc',
	anchor:'90%',
	filterName : 'Desc'
});


var AddRefBT = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		AddNewRow();
	}
});

var SaveRefBT = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		SaveRow();
	}
});

var DelRefBT = new Ext.Toolbar.Button({
	text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		DelRow();
	}
}); 

var DetailGrid=new Ext.grid.EditorGridPanel({
	id:'DetailGrid',
	height : 200,
	region:'center',
	store:RefDetailGridDs,
	loadMask:true,
	cm:DetailCm,
	sm:new Ext.grid.CellSelectionModel({}),
	takeMouseOver:true,
	clicksToEdit:1,
	bbar:PagingToolBar1,
	tbar:[AddRefBT,'-',SaveRefBT,'-',DelRefBT]
});

var UpdRefBT = new Ext.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		UpdStkRefReason();
	}
});

var refRetBT=new Ext.Button({
	text : 'ά��',
	id : 'refRetBT',
	width : 30,
	handler : function() {
		if (drugRowid==""){
			Msg.info("warning","��ѡ����Ҫά���ܾ���ҩԭ��Ŀ���");
			return;
		}
		CreateEditWin(drugRowid);
	}
})

var refRetTF=new Ext.form.TextField({
	fieldLabel : '�ܾ���ҩԭ��',
	id : 'refRetTF',
	name : 'refRetTF',
	//readOnly : true,
	disabled:true,
	anchor : '90%',
	width : 370,
	valueNotFoundText : ''
})

var RefWin="";
var CacelRefBT = new Ext.Button({
	text:'�ر�',
    tooltip:'�ر�',
    iconCls:'page_close',
    width : 70,
	height : 30,
	handler:function(){
		RefWin.hide();
	}
});

//��ʼ�����
var RefReaPanel = new Ext.form.FormPanel({
	labelWidth : 40,
	labelAlign : 'right',
	frame : true,
	autoScroll : true,
	defaults:{style:'padding:0px,0px,0px,0px',border:true},
	items : [{
		autoHeight : true,
		items : [{
			xtype : 'fieldset',
			title : '�ֵ�ά��',
			autoHeight : true,
			items : [{
				layout : 'column',
				height:200,
				items : [DetailGrid]
			}]
		},{
			xtype : 'fieldset',
			title : 'ԭ��ά��',
			buttons:[UpdRefBT,CacelRefBT],
			autoHeight : true,
			items : [{
				layout:'column',
				height:25,
				defaults:{border:false},
				items : [					
					{columnWidth:.35,layout:'form',items:[CodeField]},
					{columnWidth:.65,layout:'form',items:[DescField]}
				]
			},{
				layout:'column',
				height:25,
				defaults:{border:false},
				items : [					
					{columnWidth:.9,layout:'form',items:[RefReasonCmb]}
				]
			}]
		}]
	}]
})



	
function CreateEditWin(rowid)
{
	//��ʼ������
	RefWin = new Ext.Window({
		title:'������ҩԭ��ά��',
		width:600,
		height:450,
		layout:'fit',
		buttonAlign:'center',
		items:RefReaPanel,
		closeAction: 'hide',
		listeners:{
			'show':function(){
				RefDetailGridDs.load({params:{start:0,limit:PagingToolBar1.pageSize}});
				RefCombStore.load({params:{start:0,limit:PagingToolBar1.pageSize}});
				InitForm(rowid);
			}
		}
	});
	RefWin.show(); 
}

//=====================UI=======================
///����
function AddNewRow()
{
	var record = Ext.data.Record.create([
		{
			name : 'RowID',
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
		RowID:'',
		Code:'',
		Desc:''
	});
		
	RefDetailGridDs.add(NewRecord);
	DetailGrid.startEditing(RefDetailGridDs.getCount() - 1, 2);
}

///����
function SaveRow()
{
	//��ȡ���е��¼�¼ 
	var mr=RefDetailGridDs.getModifiedRecords();
	var ListDate="";
	for(var i=0;i<mr.length;i++){ 
		var code = mr[i].data["Code"].trim();
		var desc = mr[i].data["Desc"].trim();
		if((code!="")&&(desc!="")){
			var dataRow = mr[i].data["RowID"]+"^"+code+"^"+desc;
			if(ListDate==""){
				ListDate = dataRow;
			}else{
				ListDate = ListDate+"#"+dataRow;
			}
		}
	}

	if(ListDate==""){
		Msg.info("error","û���޸Ļ����������!");
		return false;
	}else{
		var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
			url: RefUrl+'?actiontype=SaveRefReason',
			params:{ListDate:ListDate},
			failure: function(result, request) {
				 mask.hide();
				Msg.info("error","������������!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				 mask.hide();
				if (jsonData.success=='true') {
					Msg.info("success","����ɹ�!");
					RefDetailGridDs.load({params:{start:0,limit:PagingToolBar1.pageSize}});
				}else{
					if(jsonData.info==-1){
						Msg.info("error","�����ظ�!");
					}else if(jsonData.info==-2){
						Msg.info("error","�����ظ�!");
					}else{
						Msg.info("error","����ʧ��"+jsonData);
					}
					RefDetailGridDs.load({params:{start:0,limit:PagingToolBar1.pageSize}});
				}
			},
			scope: this
		});
	}
}

///ɾ��
function DelRow()
{
	var cell = DetailGrid.getSelectionModel().getSelectedCell();
	if(cell==null){
		Msg.info("error","��ѡ������!");
		return false;
	}else{
		var record = DetailGrid.getStore().getAt(cell[0]);
		var RowId = record.get("RowID");
		if(RowId!=""){
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
				function(btn) {
					if(btn == 'yes'){
						var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
						Ext.Ajax.request({
							url:RefUrl+'?actiontype=DelRefReason&RowID='+RowId,
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								 mask.hide();
								Msg.info("error","������������!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								 mask.hide();
								if (jsonData.success=='true') {
									Msg.info("success","ɾ���ɹ�!");
									RefDetailGridDs.load({params:{start:0,limit:PagingToolBar1.pageSize}});
								}else{
									Msg.info("error","ɾ��ʧ��!");
								}
							},
							scope: this
						});
					}
				}
			)
		}else{
			Msg.info("error","�����д�!");
		}
	}
}

///����ҩƷ�ܾ�ԭ��
function UpdStkRefReason()
{
	var InciCode=Ext.getCmp('CodeField').getValue();
	var RefReaDr=Ext.getCmp('RefReasonCmb').getValue();
	var RefReason=Ext.getCmp('RefReasonCmb').getRawValue();

	if(RefReaDr==null){
		Msg.info("error","��ѡ��Ҫ���µ�ԭ��!");
		return false;
	}else{
		var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
			url:RefUrl+'?actiontype=UpdDrgRefReason&InciCode='+InciCode+'&RefReaDr='+RefReaDr,
			waitMsg:'������...',
			failure: function(result, request) {
				mask.hide();
				Msg.info("error","������������!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				 mask.hide();
				if (jsonData.success=='true') {
					Msg.info("success","���³ɹ�!");
					Ext.getCmp('refRetTF').setValue(RefReason);
				}else{
					Msg.info("error","����ʧ��!");
				}
			},
			scope: this
		});

		}
}

function InitForm(rowid)
{       
       
	var url = RefUrl+'?actiontype=GetRefReason&IncRowid='+rowid;					
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '��ѯ��...',
		success : function(result, request) {
			var s = result.responseText;
			var jsonData = Ext.util.JSON.decode(s);
			if (jsonData.success == 'true') {
				var list = jsonData.info.split("^");
				Ext.getCmp('CodeField').setValue(list[0]); //����
				Ext.getCmp('DescField').setValue(list[1]); //����
				Ext.getCmp('RefReasonCmb').setValue(list[2]); //ԭ��
				///���ò��ɱ༭
				Ext.getCmp('CodeField').setDisabled(true);
				Ext.getCmp('DescField').setDisabled(true);		
			} 
		},
		scope : this
	});
}