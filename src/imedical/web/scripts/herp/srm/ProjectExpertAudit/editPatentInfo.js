// JavaScript Document
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
var rawValue = "";
editFun = function(prjrowid) {
	//alert(InventorsIDs);
	//alert(prjrowid);
	
	var rowObj = itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	//alert(rowObj[0].get("remark"));
	if(len < 1)
	{
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ���ֵ���Ŀ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		myRowid = rowObj[0].get("rowid"); 
		Title=rowObj[0].get("Title"); 
		SubUser=rowObj[0].get("SubUser");
			//alert(myRowid);
		Index1score= rowObj[0].get("Index1score"); 
		Index2score= rowObj[0].get("Index2score"); 
		Index3score= rowObj[0].get("Index3score"); 
		Index4score= rowObj[0].get("Index4score"); 
		Index5score= rowObj[0].get("Index5score"); 
		Index6score= rowObj[0].get("Index6score"); 
		Index7score= rowObj[0].get("Index7score"); 
		Index8score= rowObj[0].get("Index8score"); 
		Index9score= rowObj[0].get("Index9score"); 
		Index10score= rowObj[0].get("Index10score"); 
		Index11score= rowObj[0].get("Index11score"); 
		Index12score= rowObj[0].get("Index12score"); 
	    Indexscores1=parseFloat(Index1score)+parseFloat(Index4score)+parseFloat(Index7score)+parseFloat(Index10score);
	    Indexscores2=parseFloat(Index2score)+parseFloat(Index5score)+parseFloat(Index8score)+parseFloat(Index11score);
	    Indexscores3=parseFloat(Index3score)+parseFloat(Index6score)+parseFloat(Index9score)+parseFloat(Index12score);
	    Indexscores4=parseFloat(Index10score)+parseFloat(Index11score)+parseFloat(Index12score);
	    Indexscore=parseFloat(Index1score)+parseFloat(Index2score)+parseFloat(Index3score)+parseFloat(Index4score)+parseFloat(Index5score)+parseFloat(Index6score)+parseFloat(Index7score)+parseFloat(Index8score)+parseFloat(Index9score)+parseFloat(Index10score)+parseFloat(Index11score)+parseFloat(Index12score)
	}

	///////////////////////��Ŀ����//////////////////////////////
var eNameField = new Ext.form.TextField({
	id:'Title',
	width:180,
	disabled:true,
	fieldLabel: '��Ŀ����',
	allowBlank: false,
	editable:false,
	name:'Title',
	emptyText:'��Ŀ����...',
	anchor: '95%',
	labelSeparator:''
});
	///////////////////////������//////////////////////////////
var SubUserField = new Ext.form.TextField({
	id:'SubUser',
	width:180,
	fieldLabel: '������',
	allowBlank: false,
	editable:false,
	disabled:true,
	name:'SubUser',
	emptyText:'������...',
	anchor: '95%',
	labelSeparator:''
});
///////////////////////��ע//////////////////////////////
var descField = new Ext.form.TextField({
	id:'descField',
	width:180,
	fieldLabel: 'ע����Ӧ��Ŀ���Ƽ���������������д�ã���ר������˶Ժ��֣���������ֱ�����Ϊ60�֣���ר�Ҹ��ݸ����ָ��������ϼƵ÷֡�',
	allowBlank: false,
	editable:false,
	name:'descField',
	value:'', //Ĭ��ֵ
	emptyText:'',
	anchor: '95%'
});
	///////////////////////�ϼƵ÷�//////////////////////////////
var sscoreField = new Ext.form.TextField({
	id:'sscoreField',
	width:180,
	fieldLabel: '�ϼƵ÷�',
	allowBlank: false,
	editable:false,
	disabled:true,
	name:'sscoreField',
	value:Indexscore, //Ĭ��ֵ
	emptyText:'�ϼƵ÷�...',
	anchor: '95%',
	labelSeparator:''
});

	///////////////////////С�Ƶ÷�//////////////////////////////
var ss1coreField = new Ext.form.TextField({
	id:'ss1coreField',
	width:130,
	fieldLabel: 'С�Ƶ÷�',
	allowBlank: false,
	disabled:true,
	editable:false,
	name:'ss1coreField',
	value:Indexscores1, //Ĭ��ֵ
	emptyText:'С�Ƶ÷�...',
	labelSeparator:''
	//anchor: '95%'
});

	///////////////////////С�Ƶ÷�//////////////////////////////
var ss2coreField = new Ext.form.TextField({
	id:'ss2coreField',
	width:130,
	fieldLabel: 'С�Ƶ÷�',
	allowBlank: false,
	disabled:true,
	editable:false,
	name:'ss2coreField',
	value:Indexscores2, //Ĭ��ֵ
	emptyText:'С�Ƶ÷�...',
	labelSeparator:''
	//anchor: '95%'
});

	///////////////////////С�Ƶ÷�//////////////////////////////
var ss3coreField = new Ext.form.TextField({
	id:'ss3coreField',
	width:130,
	fieldLabel: 'С�Ƶ÷�',
	allowBlank: false,
	disabled:true,
	editable:false,
	name:'ss3coreField',
	value:Indexscores3, //Ĭ��ֵ
	emptyText:'С�Ƶ÷�...'
	//anchor: '95%'
});

	///////////////////////С�Ƶ÷�//////////////////////////////
var ss4coreField = new Ext.form.TextField({
	id:'ss4coreField',
	width:130,
	fieldLabel: 'С�Ƶ÷�',
	allowBlank: false,
	disabled:true,
	editable:false,
	name:'ss4coreField',
	value:Indexscores4, //Ĭ��ֵ
	emptyText:'С�Ƶ÷�...',
	labelSeparator:''
	//anchor: '95%'
});
var Index1scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0��'],['1', '1��'], ['2', '2��'],['3', '3��'],['4', '4��'],['5', '5��']]
				});
var Index1scoreField = new Ext.form.ComboBox({
					fieldLabel : 'Ŀ����ȷ��',
					width : 130,
					listWidth : 130,
					selectOnFocus : true,
					store : Index1scoreStore,
					//anchor : '90%',
					value:Index1score, //Ĭ��ֵ
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // ����ģʽ
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					labelSeparator:''
				});
var Index2scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0��'],['1', '1��'], ['2', '2��'],['3', '3��'],['4', '4��'],['5', '5��']]
				});
var Index2scoreField = new Ext.form.ComboBox({
					fieldLabel : '�������ճ̶�',
					width : 130,
					listWidth :130,
					selectOnFocus : true,
					store : Index2scoreStore,
					//anchor : '90%',
					value:Index2score, //Ĭ��ֵ
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // ����ģʽ
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					labelSeparator:''
				});
var Index3scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0��'],['1', '1��'], ['2', '2��'],['3', '3��'],['4', '4��'],['5', '5��']]
				});
var Index3scoreField = new Ext.form.ComboBox({
					fieldLabel : '��ƿ�ѧ��',
					width : 130,
					listWidth : 130,
					selectOnFocus : true,
					store : Index3scoreStore,
					//anchor : '90%',
					value:Index3score, //Ĭ��ֵ
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // ����ģʽ
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					labelSeparator:''
				});
var Index4scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0��'],['1', '1��'], ['2', '2��'],['3', '3��'],['4', '4��'],['5', '5��']]
				});
var Index4scoreField = new Ext.form.ComboBox({
					fieldLabel : '���ⴴ����',
					width :130,
					listWidth : 130,
					selectOnFocus : true,
					store : Index4scoreStore,
					//anchor : '90%',
					value:Index4score, //Ĭ��ֵ
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // ����ģʽ
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					labelSeparator:''
				});
var Index5scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0��'],['1', '1��'], ['2', '2��'],['3', '3��'],['4', '4��'],['5', '5��']]
				});
var Index5scoreField = new Ext.form.ComboBox({
					fieldLabel : '���ۿ�����',
					width : 130,
					listWidth : 130,
					selectOnFocus : true,
					store : Index5scoreStore,
					//anchor : '90%',
					value:Index5score, //Ĭ��ֵ
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // ����ģʽ
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					labelSeparator:''
				});
var Index6scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0��'],['1', '1��'], ['2', '2��'],['3', '3��'],['4', '4��'],['5', '5��']]
				});
var Index6scoreField = new Ext.form.ComboBox({
					fieldLabel : '����������',
					width : 130,
					listWidth : 130,
					selectOnFocus : true,
					store : Index6scoreStore,
					//anchor : '90%',
					value:Index6score, //Ĭ��ֵ
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // ����ģʽ
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					labelSeparator:''
				});
var Index7scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0��'],['1', '1��'], ['2', '2��'],['3', '3��'],['4', '4��'],['5', '5��']]
				});
var Index7scoreField = new Ext.form.ComboBox({
					fieldLabel : '��Ա������',
					width : 130,
					listWidth : 130,
					selectOnFocus : true,
					store : Index7scoreStore,
					//anchor : '90%',
					value:Index7score, //Ĭ��ֵ
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // ����ģʽ
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					labelSeparator:''
				});
var Index8scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0��'],['1', '1��'], ['2', '2��'],['3', '3��'],['4', '4��'],['5', '5��']]
				});
var Index8scoreField = new Ext.form.ComboBox({
					fieldLabel : '�ⲿ����������',
					width : 130,
					listWidth : 130,
					selectOnFocus : true,
					store : Index8scoreStore,
					//anchor : '90%',
					value:Index8score, //Ĭ��ֵ
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // ����ģʽ
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					labelSeparator:''
				});
var Index9scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0��'],['1', '1��'], ['2', '2��'],['3', '3��'],['4', '4��'],['5', '5��']]
				});
var Index9scoreField = new Ext.form.ComboBox({
					fieldLabel : 'Ԥ�������',
					width : 130,
					listWidth : 130,
					selectOnFocus : true,
					store : Index9scoreStore,
					//anchor : '90%',
					value:Index9score, //Ĭ��ֵ
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // ����ģʽ
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					labelSeparator:''
				});
var Index10scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0��'],['1', '1��'], ['2', '2��'],['3', '3��'],['4', '4��'],['5', '5��']]
				});
var Index10scoreField = new Ext.form.ComboBox({
					fieldLabel : '�����߼�������',
					width :130,
					listWidth :130,
					selectOnFocus : true,
					store : Index10scoreStore,
					//anchor : '90%',
					value:Index10score, //Ĭ��ֵ
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // ����ģʽ
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					labelSeparator:''
				});
var Index11scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0��'],['1', '1��'], ['2', '2��'],['3', '3��'],['4', '4��'],['5', '5��']]
				});
var Index11scoreField = new Ext.form.ComboBox({
					fieldLabel : '�������Ԥ��',
					width : 130,
					listWidth : 130,
					selectOnFocus : true,
					store : Index11scoreStore,
					//anchor : '90%',
					value:Index11score, //Ĭ��ֵ
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // ����ģʽ
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					labelSeparator:''
				});
var Index12scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0��'],['1', '1��'], ['2', '2��'],['3', '3��'],['4', '4��'],['5', '5��']]
				});
var Index12scoreField = new Ext.form.ComboBox({
					fieldLabel : 'ǰ�ڹ�������',
					width : 130,
					listWidth : 130,
					selectOnFocus : true,
					store : Index12scoreStore,
					//anchor : '90%',
					value:Index12score, //Ĭ��ֵ
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // ����ģʽ
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					labelSeparator:''
				});				
var colItems =	[
		{
			
		
			items:[{  
            //layout:'column', 
			bodyStyle: 'border-width:0px 0px 0 0px',
 			items: [
				{
					width:735,  
                    //height:60,  
					labelWidth:90,
					xtype: 'fieldset',
					
					//autoHeight: true,
					items: [
						{
							xtype : 'displayfield',
							value : '',
							columnWidth : .8,
							bodyStyle:'padding:0 5px  0'
						},
								   
					  
					   eNameField,
					   sscoreField
					   //SubUserField	
					   
					]	 
				}]
				},{  
            layout:'column', 	
			items: [
				{
					xtype: 'fieldset',
					labelWidth:90, 
                    //bodyStyle: 'border-width:5px 0 0 0',					
					columnWidth : .332,
					height:187,
					items: [
						{
							xtype : 'displayfield',
							value : '',
							width:25,
							
							bodyStyle:'padding:0 5px 5px'
						},
								   
					  
					   Index1scoreField
					   ,
					   Index4scoreField,
					   Index7scoreField	
						,
		   
					   Index10scoreField,
					   ss1coreField	
					   
					]	 
				},{
					//xtype: 'fieldset',
					//labelWidth:90, 
                    //bodyStyle: 'border-width:1px 1px 0 1px',					
					//columnWidth : .01
					xtype : 'displayfield',
					value : '',
					width:10
					//bodyStyle:'padding:0 5px  0'
				}, {
					xtype: 'fieldset',
					
					labelWidth:90, 
					columnWidth : .331,
					bodyStyle: 'border-width:1px 1px 0 0',	
					height:187,
					items: [
						{
							xtype : 'displayfield',
							value : '',
							width:25,
							bodyStyle:'padding:0 5px  0'
						}
						
							,
					   Index2scoreField	
							,
					   Index5scoreField	
					   	,
					   Index8scoreField	
					   	,
					   Index11scoreField
						,
					   ss2coreField					   
					   	
					]
				 },{
					//xtype: 'displayField',
					//labelWidth:90, 
                    //bodyStyle: 'border-width:1px 1px 0 1px',					
					//columnWidth : .01
					
					xtype : 'displayfield',
					value : '',
					width:10
					//bodyStyle:'padding:0 5px  0'
					
				}, {
					xtype: 'fieldset',
					height:187,		
					labelWidth:90, 
					columnWidth : .331,
					bodyStyle: 'border-width:1px 1px 0 0',	
					items: [
						{
							xtype : 'displayfield',
							value : '',
							width:25,
							bodyStyle:'padding:0 5px  0'
						}
						
					  
					   	,
					   Index3scoreField
							,
					  
					   Index6scoreField	
					   	,
					   Index9scoreField	
					   	,
					   Index12scoreField,
					   ss3coreField	
					]
				 }]},
				
				 
				 {  
	
         xtype:'fieldset',
        
         //autoHeight:true, 
		width:735,
         title:'ע����Ӧ��Ŀ���Ƽ���������������д�ã���ר������˶Ժ��֣���������ֱ�����Ϊ60�֣���ר�Ҹ��ݸ����ָ��������ϼƵ÷֡�'
         
           
           }]
		}
	]		
	
	// create form panel
  var editFormPanel = new Ext.form.FormPanel({
    labelWidth: 80,
    //labelAlign: 'right',
	frame: true,
    items: colItems
	});
	
	editFormPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			//InventorsGrid.load();
		});

  // define window and show it in desktop
  var editWindow = new Ext.Window({
  	title: '����������ֱ�',
  	iconCls: 'updateinfo',
    width: 820,
    height:530,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:25px;',
    buttonAlign:'center',
    items: editFormPanel,
    buttons: [{
    	text: '����',
    	iconCls: 'save', 
      handler: function() {
      	// check form value
      		var Name = eNameField.getValue();
			var SubUser = SubUserField.getValue();
			
			var Index1score = Index1scoreField.getValue();
			var Index2score = Index2scoreField.getValue();
			var Index3score = Index3scoreField.getValue();
			var Index4score = Index4scoreField.getValue();
			var Index5score = Index5scoreField.getValue();
			var Index6score = Index6scoreField.getValue();
			var Index7score = Index7scoreField.getValue();
			var Index8score = Index8scoreField.getValue();
			var Index9score = Index9scoreField.getValue();
			var Index10score = Index10scoreField.getValue();
			var Index11score = Index11scoreField.getValue();
			var Index12score = Index12scoreField.getValue();
			
			
      		 
        	if (editFormPanel.form.isValid()) {
						Ext.Ajax.request({
							url:  'herp.srm.srmprojectexpertauditexe.csp?action=edit&rowid='+prjrowid+'&Index1score='+encodeURIComponent(Index1score)+'&Index2score='+encodeURIComponent(Index2score)+'&Index3score='+encodeURIComponent(Index3score)+'&Index4score='+encodeURIComponent(Index4score)+'&Index5score='+encodeURIComponent(Index5score)+'&Index6score='+encodeURIComponent(Index6score)+'&Index7score='+encodeURIComponent(Index7score)+'&Index8score='+encodeURIComponent(Index8score)+'&Index9score='+encodeURIComponent(Index9score)+'&Index10score='+encodeURIComponent(Index10score)+'&Index11score='+encodeURIComponent(Index11score)+'&Index12score='+encodeURIComponent(Index12score),
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {				
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'���ֳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:25}});
									editWindow.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info!=0) message='��Ϣ�޸�����!';
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
}