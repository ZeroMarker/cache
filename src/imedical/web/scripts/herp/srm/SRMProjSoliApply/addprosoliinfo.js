var userdr = session['LOGON.USERCODE'];

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
/////////////////��ӹ���/////////////////
addFun = function() {

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

var addYearCombo = new Ext.form.ComboBox({
	id: 'addYearCombo',
	fieldLabel: '���',
	width:200,
	listWidth : 260,
	allowBlank: true,
	store:YearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ�����...',
	name: 'addYearCombo',
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

var addSubSourceCombo = new Ext.form.ComboBox({
			id:'addSubSourceCombo',
			fieldLabel : '��Ŀ��Դ',
			store : SubSourceDs,
			displayField : 'Name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			//emptyText : '��ѡ����Ŀ��Դ...',
			width : 200,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:''
		});

/////////////////��Ŀ����///////////////////
var addTitleField = new Ext.form.TextField({
				id: 'addTitleField',
                width: 200,
                allowBlank: true,
                name: 'addTitleField',
                fieldLabel: '��Ŀ����',
                blankText: '��Ŀ����',
				labelSeparator:''
            });
            
//�������
var IsEthicStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '��'], ['0', '��']]
		});
var addIsEthicComboBox = new Ext.form.ComboBox({
			id : 'addIsEthicComboBox',
			fieldLabel : '�Ƿ��������',
			width : 200,
			listWidth : 200,
			selectOnFocus : true,
			//allowBlank : false,
			store : IsEthicStore,
			//anchor : '90%',
			value:'0', //Ĭ��ֵ
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
						columnWidth : .02
					 }, 
			           addYearCombo,
			        /*  {
						xtype : 'displayfield',
						value : '',
						columnWidth : .02
					 }, */
					   addSubSourceCombo,
					 /* {
						xtype : 'displayfield',
						value : '',
						columnWidth : .02
					 }, */
					   addTitleField, 
					 /* {
						xtype : 'displayfield',
						value : '',
						columnWidth : .02
					 },  */
					   addIsEthicComboBox
					]
			  }
			 ]	 
			}]
		
	// create form panel
  var addFormPanel = new Ext.form.FormPanel({
    labelWidth: 95,
	labelAlign:'right',
	frame: true,
    items: colItems
	});
    
  // define window and show it in desktop
  var allauthorinfo="";
  var addWindow = new Ext.Window({
  	title: '������Ŀ������Ϣ',
	iconCls: 'edit_add',
    width: 400,
    height:280,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: addFormPanel,
    buttons: [{
    	text: '����', 
		iconCls: 'save', 
      	handler: function() {
      		// check form value	
	   	var addYear=addYearCombo.getValue();
	  	var addSubSource=addSubSourceCombo.getValue();
	    var addTitle=addTitleField.getValue();
	    var addIsEthic=addIsEthicComboBox.getValue();
	   
        addYear = addYear.trim();
        addSubSource = addSubSource.trim();
        addTitle = addTitle.trim();
		addIsEthic = addIsEthic.trim();
      		
      		
      if(addYear=="")
      {
      	Ext.Msg.show({title:'����',msg:'���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      	return;
      };
      if(addSubSource=="")
      {
      	Ext.Msg.show({title:'����',msg:'��Ŀ��ԴΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      	return;
      };
      if(addTitle=="")
      {
      	Ext.Msg.show({title:'����',msg:'��Ŀ����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      	return;
      };
      if(addIsEthic=="")
      {
      	Ext.Msg.show({title:'����',msg:'��������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      	return;
      };
	
      
	  
	  
        	if (addFormPanel.form.isValid()) {
						Ext.Ajax.request({
							url: projUrl+'?action=add&Year='+encodeURIComponent(addYear)+'&Title='+encodeURIComponent(addTitle)+'&IsEthic='+encodeURIComponent(addIsEthic)+'&SubUser='+encodeURIComponent(userdr)+'&SubSource='+encodeURIComponent(addSubSource),
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								  itemGrid.load({params:{start:0, limit:25}});
									addWindow.close();
								}
							else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='RepYearTitSub') message='�������Ŀ������Ϣ�Ѿ�����!';		
								    Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
        	}
        	else{
						Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ�����ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}             
	    	}
    	},
    	{
				text: '�ر�',
				iconCls : 'cancel',
        handler: function(){addWindow.close();}
      }]
    });

    addWindow.show();
};
