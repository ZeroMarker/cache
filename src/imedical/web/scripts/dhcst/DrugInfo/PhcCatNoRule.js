// ����:ҩѧ��������Զ����ɹ���
// ��д����:2014-08-18
//=========================����ȫ�ֱ���=================================
var StkSysCounteId = "";
//=========================����ȫ�ֱ���=================================
//=========================ҩѧ��������Զ����ɹ���===========================
HospStore.load();
    var Hosp = new Ext.form.ComboBox({
	fieldLabel : 'ҽԺ',
	id : 'Hosp',
	name : 'Hosp',
	anchor : '90%',
	width : 120,
	store : HospStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : 'ҽԺ...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 999,
	listWidth : 250,
	valueNotFoundText : '',
	listeners:{
		specialKey:function(field, e) {
			if(e.getKey() == Ext.EventObject.ENTER){
				//addRow();	
			}
		}
	}
});

var LocFlag = new Ext.grid.CheckColumn({
	header:'����',
	dataIndex:'Loc',
	sortable:true,
	width:80,
	renderer:function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(((v=="Y")||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
});





var StkSysCounteGrid="";
//��������Դ
var PhCatNoGridUrl = 'dhcst.phccatnoruleaction.csp';
var PhCatNoGridProxy= new Ext.data.HttpProxy({url:PhCatNoGridUrl+'?actiontype=GetNoRule',method:'GET'});
var PhCatNoGridDs = new Ext.data.Store({
	proxy:PhCatNoGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'RowId'},
		{name:'NoLevel'},
		{name:'NoLength'},
		{name:'NoStart'},
		{name:'Hospital'}
	]),
    remoteSort:false
});

//ģ��
var PhCatNoGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"����",
        dataIndex:'NoLevel',
        width:100,
        align:'left',
        sortable:true,
        editor: new Ext.form.NumberField({
			id:'NoLevelField',
            allowBlank:false
        })
    },{
        header:"��ų���",
        dataIndex:'NoLength',
        width:100,
        align:'left',
        sortable:true,
		editor: new Ext.form.NumberField({
			id:'lengthField',
            allowBlank:false
        })
    },{
        header:"��ʼ��ֵ",
        dataIndex:'NoStart',
        width:100,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'NoStartField'
        })
    },{
        header:"ҽԺ",
        dataIndex:'Hospital',
        width:200,
        align:'left',
        sortable:true,
        editor:new Ext.grid.GridEditor(Hosp),
		renderer:Ext.util.Format.comboRenderer(Hosp)
	 }
]);

//��ʼ��Ĭ��������
PhCatNoGridCm.defaultSortable = true;
function addNewRow() {
	var record = Ext.data.Record.create([
		{
			name : 'RowId',
			type : 'int'
		}, {
			name : 'NoLevel',
			type : 'string'
		}, {
			name : 'NoLength',
			type : 'string'
		}, {
			name : 'NoStart',
			type : 'string'
		}, {
			name : 'Hospital',
			type : 'string'
		}
	]);
					
	var NewRecord = new record({
		RowId:'',
		Code:'',
		Desc:'',
		Hospital:''
	});
					
	PhCatNoGridDs.add(NewRecord);
	PhCatNoGrid.startEditing(PhCatNoGridDs.getCount() - 1, 1);
   }

var saveCatNoRule = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//rowid^Ӧ�ó���id^ҽԺ��־^���ұ�־^�����־^����ǰ׺^��^��^��^��ų���
		//RowId^AppId^AppCode^AppDesc^Hosp^Loc^CatGrp^Prefix^Year^Month^Day^NoLength
		if(PhCatNoGrid.activeEditor != null){
			PhCatNoGrid.activeEditor.completeEdit();
		}
		//��ȡ���е��¼�¼ 
		var mr=PhCatNoGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){ 
			var rowId = mr[i].data["RowId"];
			var NoLevel = mr[i].data["NoLevel"];
			var NoLength = (mr[i].data["NoLength"]);
			var NoStart = (mr[i].data["NoStart"]);
			var Hospital = (mr[i].data["Hospital"]);
			
			
			var dataRow = rowId+"^"+NoLevel+"^"+NoLength+"^"+NoStart+"^"+Hospital;
			if(data==""){
				data = dataRow;
			}else{
				data = data+xRowDelim()+dataRow;
			}
		}
		if(data==""){
			Msg.info("error","û���޸Ļ����������!");
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
			Ext.Ajax.request({
				url: PhCatNoGridUrl+'?actiontype=save',
				params: {data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error","������������!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success","����ɹ�!");
						PhCatNoGridDs.load();
					}else{
						
							Msg.info("error","����ʧ��!");
						
					}
				},
				scope: this
			});
		}
    }
});
var NewBT = new Ext.Toolbar.Button({
			text : '�½�',
			tooltip : '����½�',
			//iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
				    addNewRow();
				
			}
     })

//���
PhCatNoGrid = new Ext.grid.EditorGridPanel({
	store:PhCatNoGridDs,
	cm:PhCatNoGridCm,
	trackMouseOver:true,
	height:665,
	stripeRows:true,
	//plugins:[HospFlag,LocFlag,CatGrpFlag,YearFlag,MonthFlag,DayFlag],
	clicksToEdit:0,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
    tbar:[NewBT,'-',saveCatNoRule],
	clicksToEdit:1
});

PhCatNoGridDs.load();
//=========================���ݺ��Զ����ɹ���===========================

//===========ģ����ҳ��=================================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var PhCatNoPanel = new Ext.Panel({
		title:'�������ɹ���',
		activeTab: 0,
		region:'center',
		layout:'fit',
		items:[PhCatNoGrid]                                 
	});
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[PhCatNoPanel],
		renderTo:'mainPanel'
	});
});
//===========ģ����ҳ��=================================================