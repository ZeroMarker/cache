// ����:��Ʊ��¼
// ��д����:2013-5-16
//��д��:�쳬
var UserId = session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];


var locField = new Ext.ux.LocComboBox({
	id:'locField',
	fieldLabel:'����',
	name:'locField',
	anchor:'90%'
});
var ordlocField = new Ext.ux.LocComboBox({
	id:'ordlocField',
	fieldLabel:'ҽ�����տ���',
	name:'ordlocField',
	anchor:'90%',
	defaultLoc:{}
});

var startDateField = new Ext.ux.DateField({
	id:'startDateField',
	listWidth:100,
    allowBlank:false,
	fieldLabel:'��ʼ����',
	
	value:new Date()
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
	//width:100,
	listWidth:100,
    allowBlank:false,
	fieldLabel:'��������',
	
	value:new Date()
});
var vendor = new Ext.ux.VendorComboBox({
	fieldLabel : '��Ӧ��',
	id : 'vendor',
	name : 'vendor',
	anchor : '90%',
	emptyText : '��Ӧ��...'
});

var regno = new Ext.form.TextField({
	fieldLabel : '�ǼǺ�',
	id : 'regno',
	name : 'regno',
	anchor : '90%',
	enableKeyEvents:true,
	listeners:{
		'keydown':function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER) {
				var regno=field.getValue();
				Ext.Ajax.request({
					url: 'dhcstm.matordstataction.csp?actiontype=Getpainfo&regno='+regno,
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							var value = jsonData.info;
							var arr = value.split("^");
							//������Ϣ
							field.setValue(arr[0]);
							Ext.getCmp('regnodetail').setValue(arr.slice(1));
						}
					},
					scope: this
				});
			}
		},
		'blur':function(field){
			if(field.getValue()==""){
				Ext.getCmp('regnodetail').setValue("");
			}
		}
	}
});
var regnodetail = new Ext.form.TextField({
	fieldLabel : '�ǼǺ���Ϣ',
	id : 'regnodetail',
	name : 'regnodetail',
	disabled:true,
	anchor : '90%'
});

var invono = new Ext.form.Checkbox({
	id: 'invono',
	hideLabel : true,
	boxLabel : '�޷�Ʊ��',
	anchor:'100%',
	checked:true,
	allowBlank:true
});
var paied = new Ext.form.Checkbox({
	id: 'paied',
	hideLabel : true,
	boxLabel : '������',
	anchor:'100%',
	allowBlank:true
});
var byorddate = new Ext.form.Checkbox({
	id: 'byorddate',
	hideLabel : true,
	boxLabel : '����ҽ������',
	anchor:'100%',
	allowBlank:true
});

var findInputInvNo = new Ext.Toolbar.Button({
	text:'��ѯ',
    tooltip:'��ѯ',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		InputInvNoGrid.removeAll();
		InputInvNoGrid.load();
	}
});
function paramsFn() {
	var startDate = Ext.getCmp('startDateField').getValue();
		if((startDate!="")&&(startDate!=null)){
			startDate = startDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error","��ѡ����ʼ����!");
			return false;
		}
		var endDate = Ext.getCmp('endDateField').getValue();
		if((endDate!="")&&(endDate!=null)){
			endDate = endDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error","��ѡ���ֹ����!");
			return false;
		}
		var locId = Ext.getCmp('ordlocField').getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error","��ѡ��ҽ�����տ���!");
			return false;
		}
		var vendor = Ext.getCmp('vendor').getValue();
		var regno = Ext.getCmp('regno').getValue();
		var invono = (Ext.getCmp('invono').getValue()==true?'1':'0');
		var paied = (Ext.getCmp('paied').getValue()==true?'1':'0');
		var byorddate = (Ext.getCmp('byorddate').getValue()==true?'1':'0');
		var strPar = startDate+"^"+endDate+"^"+locId+"^"+regno+"^"+invono+"^"+paied+"^"+byorddate+"^"+vendor;
	    return {
		'strPar': strPar
	};
	}
var updateInputInvNo = new Ext.Toolbar.Button({
	text:'���淢Ʊ��Ϣ',
    tooltip:'���淢Ʊ��Ϣ',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(InputInvNoGrid.activeEditor != null){
			InputInvNoGrid.activeEditor.completeEdit();
		} 
		var ListDetail="";
		var rowCount = InputInvNoGrid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				var rowData = InputInvNoGrid.getStore().getAt(i);	
				//���������ݷ����仯ʱִ����������
				if(rowData.data.newRecord || rowData.dirty){					
					var orirowid=rowData.get("orirowid");
					var ingri = rowData.get("ingri");
					var invno =rowData.get("invno")
					var invdate =Ext.util.Format.date(rowData.get("invdate"),ARG_DATEFORMAT);
					var invamt =rowData.get("invamt")
					var IngriModify = rowData.get('IngriModify')
					var str = orirowid + "^" + ingri + "^"	+ invno + "^" + invdate + "^"+ invamt
							+ "^" + IngriModify;
					if(ListDetail==""){
						ListDetail=str;
					}
					else{
						ListDetail=ListDetail+RowDelim+str;
					}
				}
			}
			if(ListDetail==""){
				Msg.info("error", "û����Ҫ���������!");
				return false;
			}
			var url = "dhcstm.inputinvnoaction.csp?actiontype=Save";
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						params:{ListDetail:ListDetail},
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// ˢ�½���
								findInputInvNo.handler()
								Msg.info("success", "����ɹ�!");
								// 7.��ʾ��ⵥ����

							} else {
								var ret=jsonData.info;
								if(ret==-1){
									Msg.info("error", "��ֵ��Ϣ����ʧ��!");
								}else {
									Msg.info("error", "�����ϸ����ʧ�ܣ�");
								}
								
							}
						},
						scope : this
					});
			
	}
});
// ���水ť
var copybutton = new Ext.Button({
		text: '���Ʒ�Ʊ��Ϣ',
		width: 70,
		height: 30,
		iconCls: 'page_save',
		handler: function () {
			try {
				var row = InputInvNoGrid.getSelectionModel().getSelectedCell()[0];
				var INVno = InputInvNoGrid.getAt(row - 1).get('invno');
				var INVdate = InputInvNoGrid.getAt(row - 1).get('invdate');
				InputInvNoGrid.getAt(row).set("invno", INVno);
				InputInvNoGrid.getAt(row).set("invdate", INVdate);
				var col = GetColIndex(InputInvNoGrid, 'invno');
				if (row + 1 < InputInvNoGrid.getCount()) {
					InputInvNoGrid.startEditing(row + 1, col);
				}
			} catch (e) {}
		}
	});

var clearInputInvNo = new Ext.Toolbar.Button({
	text:'���',
    tooltip:'���',
    iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		Ext.getCmp('regno').setValue("");
		Ext.getCmp('vendor').setValue("");
		Ext.getCmp('regnodetail').setValue('');
		Ext.getCmp('ordlocField').setValue("");
		Ext.getCmp('invono').setValue(true);
		Ext.getCmp('paied').setValue(false);
		Ext.getCmp('byorddate').setValue(false);
		Ext.getCmp('startDateField').setValue(new Date());
		Ext.getCmp('endDateField').setValue(new Date());
		
		InputInvNoGrid.removeAll();
	}
});

var formPanel = new Ext.ux.FormPanel({
	title:'��Ʊ�Ų�¼',
    tbar:[findInputInvNo,'-',updateInputInvNo,'-',clearInputInvNo,'-',copybutton],
	items : [{
		xtype : 'fieldset',
		title : '����ѡ��',
		layout : 'column',	
		style : 'padding:5px 0px 0px 5px',
		defaults : {border:false,xtype:'fieldset'},
		items : [{
				columnWidth : .2,
				items : [startDateField,endDateField]
			}, {
				columnWidth : .25,
				labelWidth : 100,
				items : [vendor,ordlocField]
			}, {
				columnWidth : .22,
				items : [regno,regnodetail]
			}, {
				columnWidth : .18,
				labelWidth : 100,
				items : [invono,byorddate]
			}, {
				columnWidth : .15,
				items : [paied]
		}]
	}]
});

var InputInvNoGrid="";
//��������Դ
var InputInvNoGridUrl = 'dhcstm.inputinvnoaction.csp';

//ģ��
var InputInvNoGridCm = [
	 {
        header:"��Ӧ��",
        dataIndex:'vendor',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"���ʴ���",
        dataIndex:'code',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"��������",
        dataIndex:'desc',
        width:120,
        align:'left',
        sortable:true
    },{
        header:"��������",
        dataIndex:'barcode',
        width:120,
        align:'left',
        sortable:true
    },{
        header:"��Ʊ��",
        dataIndex:'invno',
        width:100,
        align:'left',
        sortable:true,
        editor: new Ext.form.TextField({
			id:'invnoField',
            //allowBlank:false,
            selectOnFocus:true,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = InputInvNoGrid.getSelectionModel().getSelectedCell();
						var col=GetColIndex(InputInvNoGrid,"invdate");
						InputInvNoGrid.startEditing(cell[0], col);
					}
				}
			}
        })
    },{
        header:"��Ʊ����",
        dataIndex:'invdate',
        width:80,
        align:'left',
        sortable:true,
        renderer:Ext.util.Format.dateRenderer(DateFormat),
		editor: new Ext.ux.DateField({
			id:'invdateField',
			
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = InputInvNoGrid.getSelectionModel().getSelectedCell();
						var col=GetColIndex(InputInvNoGrid,"invamt");
						InputInvNoGrid.startEditing(cell[0], col);
					}
				}
			}
        })
      },{
        header:"��Ʊ���",
        dataIndex:'invamt',
        width:100,
        align:'right',
        sortable:true,
        editor: new Ext.form.NumberField({
			id:'invamtField',
            //allowBlank:false,
            selectOnFocus:true,
            allowNegative:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = InputInvNoGrid.getSelectionModel().getSelectedCell();
						if(cell[0]+1<InputInvNoGrid.store.getCount()){
							var col=GetColIndex(InputInvNoGrid,"invno");
							InputInvNoGrid.startEditing(cell[0]+1, col);
						}
					}
				}
			}
        })
  },{
        header:"��ⵥ��",
        dataIndex:'ingno',
        width:150,
        align:'left',
        sortable:true
   },{
        header:"��¼����ӱ�Dr",
        dataIndex:'IngriModify',
        width:60,
        hidden:true
   },{
        header:"��¼��ⵥ��",
        dataIndex:'IngriModifyNo',
        width:150,
        align:'left',
        sortable:true
   },{
        header:"��������",
        dataIndex:'dateofmanu',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"ҽ������",
        dataIndex:'orddate',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"ҽ��ʱ��",
        dataIndex:'ordtime',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"����",
        dataIndex:'qty',
        width:40,
        align:'right',
        sortable:true
    },{
        header:"��λ",
        dataIndex:'uomdesc',
        width:40,
        align:'left'
    },{
        header:"����",
        dataIndex:'rp',
        width:50,
        align:'right',
        sortable:true
   },{
        header:"����",
        dataIndex:'ward',
        width:100,
        align:'left',
        sortable:true
     
   },{
        header:"����",
        dataIndex:'manf',
        width:100,
        align:'left',
        sortable:true
   },{
        header:"���ߵǼǺ�",
        dataIndex:'pano',
        width:100,
        align:'left',
        sortable:true
   },{
        header:"��������",
        dataIndex:'paname',
        width:60,
        align:'left',
        sortable:true
   },{
        header:"ҽ��",
        dataIndex:'doctor',
        width:60,
        align:'left',
        sortable:true
   },{
        header:"���տ���",
        dataIndex:'admloc',
        width:100,
        align:'left',
        sortable:true
	},{
        header:"�м��Id",
        dataIndex:'orirowid',
        width:100,
        align:'left',
        hidden:true,
        sortable:true
    },{
        header:"��ⵥid",
        dataIndex:'ingri',
        width:100,
        align:'left',
        hidden:true,
        sortable:true
    }
];
//��ʼ��Ĭ��������
InputInvNoGridCm.defaultSortable = true;
function cellSelectFn(sm, rowIndex, colIndex) {
}



var InputInvNoGrid = new Ext.dhcstm.EditorGridPanel({
		region: 'center',
		id: 'InputInvNoGrid',
		contentColumns: InputInvNoGridCm,
		smRowSelFn: cellSelectFn,
		singleSelect: false,
		selectFirst: false,
		actionUrl: InputInvNoGridUrl,
		queryAction: "find",
		paramsFn: paramsFn,
		paging: false, //2015-12
		showTBar : false
})
//===========ģ����ҳ��=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,InputInvNoGrid],
		renderTo:'mainPanel'
	});
});
//===========ģ����ҳ��=============================================