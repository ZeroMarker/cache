/////////////////////�޸Ĺ���/////////////////////
Date.dayNames = ["��", "һ", "��", "��", "��", "��", "��"];  
    Date.monthNames=["1��","2��","3��","4��","5��","6��","7��","8��","9��","10��","11��","12��"];  
    if (Ext.DatePicker) {  
        Ext.apply(Ext.DatePicker.prototype, {  
            todayText: "����",  
            minText: "��������С����֮ǰ",  
            maxText: "�������������֮��",  
            disabledDaysText: "",  
            disabledDatesText: "",  
            monthNames: Date.monthNames,  
            dayNames: Date.dayNames,  
            nextText: '���� (Control+Right)',  
            prevText: '���� (Control+Left)',  
            monthYearText: 'ѡ��һ���� (Control+Up/Down ���ı���)',  
            todayTip: "{0} (Spacebar)",  
            okText: "ȷ��",  
            cancelText: "ȡ��" 
        });  
} 

editFun = function() {
	var rowObj = itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1)
	{
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		var editRowid = rowObj[0].get("rowid"); 
	}

/////////////////���///////////////////////
var YearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

YearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=yearList&str='+encodeURIComponent(Ext.getCmp('YearCombo').getRawValue()),
	method:'POST'});
});

var editYearCombo = new Ext.form.ComboBox({
	id: 'editYearCombo',
	fieldLabel: '���',
	width:200,
	listWidth : 260,
	allowBlank: false,
	store:YearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ�����...',
	name: 'editYearCombo',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});

 ///��Ŀ��Դ
var SubSourceDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'Name'])
		});
		
SubSourceDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=sourceList&str='+encodeURIComponent(Ext.getCmp('SubSourceCombo').getRawValue()), 
                        method:'POST'
					});
		});

var editSubSourceCombo = new Ext.form.ComboBox({
			id:'editSubSourceCombo',
			fieldLabel : '��Ŀ��Դ',
			store : SubSourceDs,
			displayField : 'Name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			allowBlank : false,
			triggerAction : 'all',
			emptyText : '',
			width : 200,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:''
		});

/////////////////��Ŀ����///////////////////
var editTitleField = new Ext.form.TextField({
				id: 'editTitleField',
                width: 200,
                allowBlank: false,
                name: 'editTitleField',
                fieldLabel: '��Ŀ����',
                blankText: '��Ŀ����',
				labelSeparator:''
            });
            
//�������
var IsEthicStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '��'], ['0', '��']]
		});
var editIsEthicComboBox = new Ext.form.ComboBox({
			id : 'editIsEthicComboBox',
			fieldLabel : '�Ƿ��������',
			width : 200,
			listWidth : 200,
			selectOnFocus : true,
			//allowBlank : false,
			store : IsEthicStore,
			//anchor : '90%',
			//value:'0', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			labelSeparator:''
					 });
	

var colItems =	[{
			layout: 'column',
			border: false,
			defaults:
			{
				columnWidth: '.9',
				bodyStyle:'padding:5px 5px 0',
				border: false
			},            
			items: 
			[{
					xtype: 'fieldset',
					autoHeight: true,
					items: 
					[{
						xtype : 'displayfield',
						value : '',
						columnWidth : .05
					 },
			           editYearCombo,
			         /* {
						xtype : 'displayfield',
						value : '',
						columnWidth : .05
					 }, */
					   editSubSourceCombo,
					 /* {
						xtype : 'displayfield',
						value : '',
						columnWidth : .05
					 }, */
					   editTitleField, 
					 /* {
						xtype : 'displayfield',
						value : '',
						columnWidth : .05
					 },  */
					   editIsEthicComboBox
					]
			  }
			 ]	 
			}]
				
	// create form panel
  var editFormPanel = new Ext.form.FormPanel({
    labelWidth: 95,
	labelAlign:'right',
	  frame: true,
    items: colItems
	});
	
	editFormPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			editYearCombo.setValue(rowObj[0].get("YearDR"));
			editYearCombo.setRawValue(rowObj[0].get("Year"));
			editSubSourceCombo.setValue(rowObj[0].get("SubSourceDR"));
			editSubSourceCombo.setRawValue(rowObj[0].get("SubSource"));
			editTitleField.setValue(rowObj[0].get("Title"));
			editIsEthicComboBox.setValue(rowObj[0].get("IsEthicDR"));
			editIsEthicComboBox.setRawValue(rowObj[0].get("IsEthic"));
		});

  // define window and show it in desktop

  var editWindow = new Ext.Window({
  	title: '�޸���Ŀ������Ϣ',
	iconCls: 'pencil',
    width: 400,
    height:280,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: editFormPanel,
    buttons: [{
    	text: '����', 
		iconCls: 'save', 
        handler: function() {
      		var editYear = editYearCombo.getValue();
      		var editSubSource = editSubSourceCombo.getValue();
      		var editTitle = editTitleField.getValue();
      		var editIsEthic = editIsEthicComboBox.getValue();
 
			
			editYear = editYear.trim();
			editSubSource =editSubSource.trim();
			editTitle =editTitle.trim();
     		editIsEthic = editIsEthic.trim();		
	  
      		if(editYear=="")
      		{
      			Ext.Msg.show({title:'����',msg:'���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(editSubSource=="")
      		{
      			Ext.Msg.show({title:'����',msg:'��Ŀ��ԴΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(editTitle=="")
      		{
      			Ext.Msg.show({title:'����',msg:'��Ŀ����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(editIsEthic=="")
      		{
      			Ext.Msg.show({title:'����',msg:'�Ƿ��������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
    	
      		/* var year = rowObj[0].get("Year");
      		var subsource = rowObj[0].get("SubSource");
      		var title = rowObj[0].get("Title");
			var isethic = rowObj[0].get("IsEthic");
      		
  
			    if(editYear==year){editYear=""};
			    if(editSubSource==subsource){editSubSource=""};	
			    if(editTitle==title){editTitle=""};	
			    if(editIsEthic==isethic){editIsEthic=""};	 */
			 
        	if (editFormPanel.form.isValid()) {
						Ext.Ajax.request({
							url:  projUrl+'?action=edit&rowid='+editRowid+'&Year='+encodeURIComponent(editYear)+'&Title='+encodeURIComponent(editTitle)+'&IsEthic='+encodeURIComponent(editIsEthic)+'&SubSource='+encodeURIComponent(editSubSource),
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {				
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	    if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:25}});
									editWindow.close();
								}
								else
								{
									var message = "";
									message = jsonData.info;
									if(jsonData.info=='RepYearTitSub') message='�������Ŀ������Ϣ�Ѿ�����!';	
											
								  Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
        	}
        	else{
						Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ���󱣴档',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}             
	    	}
    	},
    	{
			text: '�ر�',
			iconCls : 'cancel',
        handler: function(){editWindow.close();}
      }]
    });
    editWindow.show();
};
