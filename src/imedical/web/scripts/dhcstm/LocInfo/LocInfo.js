// ����:������չ��Ϣ
// ��д����:2012-05-23

//=========================������չ��Ϣ=============================
var conditionCodeField = new Ext.form.TextField({
    id:'conditionCode',
    fieldLabel:'����',
    allowBlank:true,
    listWidth:180,
    emptyText:'����...',
    anchor:'90%',
    selectOnFocus:true
});

var conditionDescField = new Ext.form.TextField({
    id:'conditionDesc',
    fieldLabel:'����',
    allowBlank:true,
    listWidth:150,
    emptyText:'����...',
    anchor:'90%',
    selectOnFocus:true
});

var LocInfoTypeStore = new Ext.data.SimpleStore({
    fields:['key', 'keyValue'],
    data:[["R",'ҩ��'], ["I",'סԺҩ��'], ["O",'����ҩ��'], ["A",'��е����'], ["G",'����ҩ��'], ["E",'����']]
});

var conditionTypeField = new Ext.form.ComboBox({
    id:'conditionTypeField',
    fieldLabel:'�ⷿ���',
    anchor:'90%',
    listWidth:222,
    allowBlank:true,
    store:LocInfoTypeStore,
    value:'', // Ĭ��ֵ"ȫ����ѯ"
    valueField:'key',
    displayField:'keyValue',
    emptyText:'�������...',
    triggerAction:'all',
    minChars:1,
    selectOnFocus:true,
    forceSelection:true,
    editable:true,
    mode:'local'
});

var conditionLocGField = new Ext.ux.ComboBox({
    id:'conditionLocG',
    fieldLabel:'������',
    anchor:'90%',
    listWidth:222,
    allowBlank:true,
    store:StkLocGrpStore,
    valueField:'RowId',
    displayField:'Description',
    emptyText:'������...',
    filterName:'str'
});

var conditionItemGField = new Ext.ux.ComboBox({
    id:'conditionItemG',
    anchor:'90%',
    fieldLabel:'��Ŀ��',
    listWidth:220,
    allowBlank:true,
    store:StkItemGrpStore,
    valueField:'RowId',
    displayField:'Description',
    emptyText:'��Ŀ��...',
    filterName:'str'
});

var conditionMainLocField=new Ext.ux.LocComboBox({
    id:'conditionMainLoc',
    anchor:'90%',
    fieldLabel:'֧�����',
    emptyText:'֧�����...',
	defaultLoc:''
});

//����״̬
var ActiveFlag = new Ext.form.RadioGroup({
			id:'active',
			columns:3,
			anchor : '90%',
			width : 300,
			items:[
				{boxLabel:'ȫ��',name:'ActiveFlag',id:'ActiveFlag_All',inputValue:'A',checked:true},
				{boxLabel:'����',name:'ActiveFlag',id:'ActiveFlag_Yes',inputValue:'Y'},
				{boxLabel:'δ����',name:'ActiveFlag',id:'ActiveFlag_No',inputValue:'N'}
			]
		});
/*
var stateStore = new Ext.data.SimpleStore({
		fields: ['key', 'keyValue'],
		data: [["A",'ȫ��'], ["N",'δ����'], ["Y",'����']]
	});
var activeField = new Ext.form.ComboBox({
		id: 'active',
		fieldLabel: '����״̬',
		allowBlank: true,
		store: stateStore,
		value: 'A', // Ĭ��ֵ"����"
		valueField:'key',
		displayField:'keyValue',
		triggerAction:'all',
		anchor: '50%',
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true,
		editable: true,
		mode: 'local'
	});

var ReqAllItmField = new Ext.form.Checkbox({
	id : 'ReqAllItm',
	anchor:'90%',
	hideLabel : true,
	boxLabel : '�����������Ŀ',
	allowBlank:false,
	checked:false
	});
*/
//������Ŀ���ʶ
var ReqAllItmFlag = new Ext.form.RadioGroup({
			id:'ReqAllItm',
			columns:3,
			anchor : '90%',
			width : 300,
			items:[
				{boxLabel:'ȫ��',name:'ReqAllItmFlag',id:'ReqAllItmFlag_All',inputValue:'',checked:true},
				{boxLabel:'���������������Ŀ',name:'ReqAllItmFlag',id:'ReqAllItmFlag_Yes',inputValue:'Y'},
				{boxLabel:'�����������������Ŀ',name:'ReqAllItmFlag',id:'ReqAllItmFlag_No',inputValue:'N'}
			]
		});

var LocInfoTypeField = new Ext.form.ComboBox({
    id:'LocInfoType',
    fieldLabel:'�ⷿ���',
    anchor:'90%',
    listWidth:210,
    allowBlank:true,
    store:LocInfoTypeStore,
    value:'', // Ĭ��ֵ"ȫ����ѯ"
    valueField:'key',
    displayField:'keyValue',
    emptyText:'�������...',
    triggerAction:'all',
    emptyText:'',
    minChars:1,
    selectOnFocus:true,
    forceSelection:true,
    editable:true,
    mode:'local'
});

var SlgG = new Ext.ux.ComboBox({
    id:'SlgG',
    fieldLabel:'������',
    anchor:'90%',
    listWidth:220,
    allowBlank:true,
    store:StkLocGrpStore,
    valueField:'RowId',
    displayField:'Description',
    emptyText:'������...',
    filterName:'str'
});

var LigG = new Ext.ux.ComboBox({
    fieldLabel : '��Ŀ��',
    id : 'LigG',
    name : 'LigG',
    anchor : '90%',
    width : 120,
    store : StkItemGrpStore,
    valueField : 'RowId',
    displayField : 'Description',
    emptyText : '��Ŀ��...'
});

var MainLocCb = new Ext.ux.LocComboBox({
    id:'MainLoc',
    anchor:'90%',
    fieldLabel:'֧�����',
    emptyText:'֧�����...',
	defaultLoc:''
});

var PrintModeStore = new Ext.data.SimpleStore({
	fields:['RowId', 'Description'],
	data : [['MM', 'MM'], ['MO', 'MO'], ['MR', 'MR'], ['MF', 'MF']]
});
var PrintModeField = new Ext.form.ComboBox({
    fieldLabel : '��ӡģʽ',
    store : PrintModeStore,
    valueField : 'RowId',
    displayField : 'Description',
    emptyText : '��ӡģʽ...',
    triggerAction : 'all',
    selectOnFocus : true,
    forceSelection : true,
    mode : 'local'
});
//�Զ��±���־
var AutoMonFlag= new Ext.form.RadioGroup({
			id:'AutoMonFlag',
			columns:3,
			anchor : '90%',
			width : 300,
			items:[
				{boxLabel:'ȫ��',name:'AutoMonFlag',id:'AutoMonFlag_All',inputValue:'',checked:true},
				{boxLabel:'�Զ������±�',name:'AutoMonFlag',id:'AutoMonFlag_Yes',inputValue:'Y'},
				{boxLabel:'���Զ������±�',name:'AutoMonFlag',id:'AutoMonFlag_No',inputValue:'N'}
			]
		});
/*
var AutoMonFlagField = new Ext.form.Checkbox({
    id: 'AutoMonFlag',
    anchor:'90%',
	hideLabel : true,
	boxLabel : '�Զ��±���־',
    allowBlank:false,
    checked:false
});
*/
var LocInfoGrid="";
//��������Դ
var LocInfoGridUrl = 'dhcstm.locinfoaction.csp';
var LocInfoGridProxy= new Ext.data.HttpProxy({url:LocInfoGridUrl+'?actiontype=query',method:'POST'});
var LocInfoGridDs = new Ext.data.Store({
    proxy:LocInfoGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
        totalProperty:'results'
    }, [
        {name:'Rowid'},
        {name:'Code'},
        {name:'Desc'},
        {name:'LigId'},
        {name:'LigDesc'},
        {name:'SlgId'},
        {name:'SlgDesc'},
        {name:'Type'},
        {name:'MainLoc'},
        {name:'MainLocDesc'},
        {name:'Active'},
        {name:'ReqAllItm'},
        {name:'ReportSeq'},
		{name:'AutoMonFlag'},
		{name:'ReqLimitAmt'},
		{name:'ReqAmt'},
	'PrintMode'
    ]),
    remoteSort:true,
    pruneModifiedRecords:true
});

var ActiveF = new Ext.grid.CheckColumn({
    header:'�����ʶ',
    dataIndex:'Active',
    anchor:'90%',
    sortable:true
});

var ReqAllItmF = new Ext.grid.CheckColumn({
	header:'������Ŀ���ʶ',
	dataIndex: 'ReqAllItm',
	anchor : '90%',
	sortable:true,
	width : 120
	});
var AutoMonF = new Ext.grid.CheckColumn({
    header:'�Զ��±���־',
    dataIndex:'AutoMonFlag',
    anchor:'90%',
    sortable:true
});

//ģ��
var sm=new Ext.grid.CheckboxSelectionModel({});
var LocInfoGridCm = new Ext.grid.ColumnModel([
     new Ext.grid.RowNumberer(),sm,
     {
        header:"����",
        dataIndex:'Code',
        width:150,
        align:'left',
        sortable:true
    },{
        header:"����",
        dataIndex:'Desc',
        width:300,
        align:'left',
        sortable:true
    },{
        header:"������",
        dataIndex:'SlgId',
        width:150,
        align:'left',
        sortable:true,
        editor:new Ext.grid.GridEditor(SlgG),
        renderer : Ext.util.Format.comboRenderer2(SlgG,"SlgId","SlgDesc")
    },{
        header:"��Ŀ��",
        dataIndex:'LigId',
        width:150,
        align:'left',
        sortable:true,
        editor:new Ext.grid.GridEditor(LigG),
        renderer : Ext.util.Format.comboRenderer2(LigG,"LigId","LigDesc")
    },{
        header:"�ⷿ���",
        dataIndex:'Type',
        width:150,
        align:'left',
        sortable:true,
        renderer: Ext.util.Format.comboRenderer(LocInfoTypeField),
        editor: new Ext.grid.GridEditor(LocInfoTypeField)
    },{
    	header:"֧�����",
        dataIndex:'MainLoc',
        width:150,
        align:'left',
        sortable:true,
        editor:new Ext.grid.GridEditor(MainLocCb),
        renderer:Ext.util.Format.comboRenderer2(MainLocCb,"MainLoc","MainLocDesc")
    },
    ActiveF,ReqAllItmF,
    {
        header:"����˳��",
        dataIndex:'ReportSeq',
        width:80,
        align:'left',
        sortable:true,
        editor : new Ext.grid.GridEditor(new Ext.form.TextField({}))
    },{
		header : '��ӡģʽ',
		dataIndex : 'PrintMode',
		width : 100,
		align : 'left',
		editor : new Ext.grid.GridEditor(PrintModeField),
		renderer : Ext.util.Format.comboRenderer(PrintModeField)
	},AutoMonF,{
		header:"�����޶�",
        dataIndex:'ReqLimitAmt',
        width:100,
        align:'right',
        editor: new Ext.grid.GridEditor(new Ext.form.NumberField({}))
	},{
		header:"�������",
        dataIndex:'ReqAmt',
        width:100,
        align:'right'
	}
]);
//��ʼ��Ĭ��������
LocInfoGridCm.defaultSortable = true;

var clearLocInfo = new Ext.Toolbar.Button({
    text:'���',
    tooltip:'���',
    iconCls:'page_clearscreen',
    width : 70,
    height : 30,
    handler:function(){
        Ext.getCmp('conditionCode').setValue("");
        Ext.getCmp('conditionDesc').setValue("");
        Ext.getCmp('conditionTypeField').setValue("");
        Ext.getCmp('conditionLocG').setValue("");
        Ext.getCmp('conditionLocG').setRawValue("");
        Ext.getCmp('conditionItemG').setValue("");
        Ext.getCmp('conditionItemG').setRawValue("");
        Ext.getCmp('conditionMainLoc').setValue("");
        Ext.getCmp('ActiveFlag_All').setValue(true);
        Ext.getCmp('ReqAllItmFlag_All').setValue(true);
		Ext.getCmp('AutoMonFlag_All').setValue(true);
        LocInfoGrid.getStore().removeAll();
        LocInfoGrid.getView().refresh();
    }
});

var findLocInfo = new Ext.Toolbar.Button({
    text:'��ѯ',
    tooltip:'��ѯ',
    iconCls:'page_find',
    width : 70,
    height : 30,
    handler:function(){
    	var code=Ext.getCmp('conditionCode').getValue();
    	var desc=Ext.getCmp('conditionDesc').getValue();
    	var LocG=Ext.getCmp('conditionLocG').getValue();
    	var ItemG=Ext.getCmp('conditionItemG').getValue();
    	var type=Ext.getCmp('conditionTypeField').getValue();
    	var mainLoc=Ext.getCmp('conditionMainLoc').getValue();
    	var activeFlag=Ext.getCmp('active').getValue().getGroupValue();
    	//var ReqAllItmFlag=Ext.getCmp('ReqAllItm').getValue()==true?'Y':'N';
    	var ReqAllItmFlag=Ext.getCmp('ReqAllItm').getValue().getGroupValue();
		//var AutoMonFlag=Ext.getCmp('AutoMonFlag').getValue()==true?'Y':'N';
		var AutoMonFlag=Ext.getCmp('AutoMonFlag').getValue().getGroupValue();
    	var filterStr=code+"^"+desc+"^"+LocG+"^"+ItemG+"^"+type+"^"+activeFlag+"^"+mainLoc+"^"+ReqAllItmFlag+"^"+AutoMonFlag;
    	LocInfoGridDs.setBaseParam("sort",'Rowid');
    	LocInfoGridDs.setBaseParam("dir",'desc');
    	LocInfoGridDs.setBaseParam("filterStr",filterStr);
        LocInfoGridDs.load({params:{start:0,limit:LocInfoPagingToolbar.pageSize}});
    }
});

var setFrLocButton=new Ext.Toolbar.Button({
	text:'���ò�������',
	width:70,
	height:30,
	iconCls : 'page_gear',
	handler:function()
	{
		var sm=LocInfoGrid.getSelectionModel();		
		var rec=sm.getSelected();
		if(rec==null){
			Msg.info("warning","��ѡ����ң�");
			return;
		}
		var loc=rec.get('Rowid');
		if (loc=='') return;
		var locDesc=rec.get('Desc');
		setTransferFrLoc(loc,locDesc);		
	}
});
var setLocClaGrpButton=new Ext.Toolbar.Button({
	text:'���ÿ�����Ŀ����',
	width:70,
	height:30,
	iconCls:'page_gear',
	handler:function()
	{
		var sm=LocInfoGrid.getSelectionModel();
		var rec=sm.getSelected();
		if(rec==null){
			Msg.info("warning","��ѡ����ң�")
			return;
		}
		var loc=rec.get('Rowid');
		if(loc==''){ 
			Msg.info("warning","��ѡ����ң�")
			return;
		   }
		var locDesc=rec.get('Desc');
		setLocClaGrp(loc,locDesc);
	}
});
var setFrLocButton1=new Ext.Toolbar.Button({
	text:'���ù�Ӧ�ֿ�(����)',
	width:70,
	height:30,
	iconCls : 'page_gear',
	handler:function()
	{
		var sm=LocInfoGrid.getSelectionModel();		
		var rec=sm.getSelected();
		if(rec==null){
			Msg.info("warning","��ѡ����ң�")
			return;
		}
		var loc=rec.get('Rowid');
		if (loc=='') return;
		var locDesc=rec.get('Desc');
		setTransStkCatferFrLoc(loc,locDesc);		
	}
});
var saveLocInfo = new Ext.Toolbar.Button({
    text:'����',
    tooltip:'����',
    iconCls:'page_save',
    width : 70,
    height : 30,
    handler:function(){
		if(LocInfoGrid.activeEditor != null){
			LocInfoGrid.activeEditor.completeEdit();
		} 
        //��ȡ���е��¼�¼ 
        var mr=LocInfoGridDs.getModifiedRecords();
        var data="";
        for(var i=0;i<mr.length;i++){
            var LlgId = mr[i].data["LigId"];
            var SlgId = mr[i].data["SlgId"];
            var PrintMode = mr[i].data['PrintMode'];
            var dataRow = mr[i].data["Rowid"]+"^"+LlgId+"^"+SlgId+"^"+mr[i].data["Type"]+"^"+mr[i].data["Active"]
            	+"^"+mr[i].data['MainLoc']+"^"+mr[i].data['ReqAllItm']+"^"+mr[i].data['ReportSeq']+"^"+PrintMode
				+"^"+mr[i].data["AutoMonFlag"]+"^"+mr[i].data['ReqLimitAmt'];
            if(data==""){
                data = dataRow;
            }else{
                data = data+xRowDelim()+dataRow;
            }
        }
        if(data==""){
            Msg.info("error", "û���޸Ļ����������!");
            return false;
        }else{
            var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
            Ext.Ajax.request({
                url: LocInfoGridUrl+'?actiontype=save',
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
                        LocInfoGridDs.commitChanges();
						LocInfoGridDs.reload();
                    }else{
                        Msg.info("error", "����ʧ��!" +jsonData.info);
                    }
                },
                scope: this
            });
        }
    }
});
var SendLocInfoBT = new Ext.Toolbar.Button({
			id : "SendLocInfoBT",
			text : '���Ϳ�����Ϣ��ƽ̨',
			width : 70,
			height : 30,
			iconCls : 'page_gear',
			handler : function() {
				    var rowDataArr=LocInfoGrid.getSelectionModel().getSelections();
					if (Ext.isEmpty(rowDataArr)) {
						Msg.info("warning", "��ѡ����Ҫ���͵Ŀ�����Ϣ!");
						return;
					}
					var LocIdStr="";
					for (var i=0;i<rowDataArr.length;i++){
						var rowData=rowDataArr[i];
						var LocRowId = rowData.get("Rowid");
						if (LocIdStr==""){
							LocIdStr=LocRowId;
						}else{
							LocIdStr=LocIdStr+"^"+LocRowId;
						}
					}
					if (Ext.isEmpty(LocIdStr)) {
						Msg.info("warning", "��ѡ����Ҫ���͵Ŀ�����Ϣ!");
						return;
					}
					SendLocInfo(LocIdStr);
			}
});
function SendLocInfo(LocIdStr){
	 	var url = LocInfoGridUrl+"?actiontype=SendLocInfo";
        var loadMask=ShowLoadMask(Ext.getBody(),"������Ϣ��...");
        Ext.Ajax.request({
                    url : url,
                    method : 'POST',
                    params:{LocIdStr:LocIdStr},
                    waitMsg : '������...',
                    success : function(result, request) {
                        var jsonData = Ext.util.JSON.decode(result.responseText);
                        if (jsonData.success == 'true') {
                            Msg.info("success", "���ͳɹ�!");
                            findLocInfo.handler();
                        } else {
                            var ret=jsonData.info;
                            Msg.info("error", jsonData.info);
                            findLocInfo.handler();
                        }
                    },
                    scope : this
                });
        loadMask.hide();
}
var formPanel = new Ext.ux.FormPanel({
    title:'������չ��Ϣ',
    tbar:[findLocInfo,'-',saveLocInfo,'-',clearLocInfo,'-',setFrLocButton,'-',setFrLocButton1,'-',setLocClaGrpButton,'-',SendLocInfoBT],
    items : [{
		xtype : 'fieldset',
		title : '��ѯ����',
		layout : 'column',	
		style : 'padding:5px 0px 0px 5px',
		defaults:{border:false,xtype:'fieldset'},
		items : [{
				columnWidth : .28,
				items : [conditionCodeField,conditionLocGField,conditionMainLocField]
			}, {
				columnWidth : .28,
				items : [conditionDescField,conditionItemGField,conditionTypeField]
			}, {
				columnWidth : .42,
				items : [ActiveFlag,ReqAllItmFlag,AutoMonFlag]
		}]
    }]
});

//��ҳ������
var LocInfoPagingToolbar = new Ext.PagingToolbar({
    store:LocInfoGridDs,
    pageSize:PageSize,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼"
});

//���
LocInfoGrid = new Ext.grid.EditorGridPanel({
	id:'LocInfoGrid',
    store:LocInfoGridDs,
    cm:LocInfoGridCm,
    trackMouseOver:true,
    region:'center',
    stripeRows:true,
    sm: sm,
    plugins: [ActiveF,ReqAllItmF,AutoMonF],    
    loadMask:true,
    bbar:LocInfoPagingToolbar,
    clicksToEdit:2
});

//=========================������չ��Ϣ=============================

//===========ģ����ҳ��=============================================
Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;    
    var mainPanel = new Ext.ux.Viewport({
        layout:'border',
        items:[formPanel,LocInfoGrid]
    });
});
//===========ģ����ҳ��=============================================