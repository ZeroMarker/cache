viewFun = function(viewrowid)
{
	var rowObj = itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1)
	{
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�鿴����Ŀ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		ViewRowid = rowObj[0].get("rowid"); 
		Title=rowObj[0].get("Title"); 
		SubUser=rowObj[0].get("SubUser");

		Index1score= rowObj[0].get("Index1Score");
		Index2score= rowObj[0].get("Index2Score"); 
		Index3score= rowObj[0].get("Index3Score"); 
		Index4score= rowObj[0].get("Index4Score"); 
		Index5score= rowObj[0].get("Index5Score"); 
		Index6score= rowObj[0].get("Index6Score"); 
		Index7score= rowObj[0].get("Index7Score"); 
		Index8score= rowObj[0].get("Index8Score"); 
		Index9score= rowObj[0].get("Index9Score"); 
		Index10score= rowObj[0].get("Index10Score"); 
		Index11score= rowObj[0].get("Index11Score"); 
		Index12score= rowObj[0].get("Index12Score"); 
	    /* Indexscores1=parseFloat(Index1score)+parseFloat(Index2score)+parseFloat(Index3score);
	    Indexscores2=parseFloat(Index4score)+parseFloat(Index5score)+parseFloat(Index6score);
	    Indexscores3=parseFloat(Index7score)+parseFloat(Index8score)+parseFloat(Index9score);
	    Indexscores4=parseFloat(Index10score)+parseFloat(Index11score)+parseFloat(Index12score);
	    Indexscore=parseFloat(Index1score)+parseFloat(Index2score)+parseFloat(Index3score)+parseFloat(Index4score)+parseFloat(Index5score)+parseFloat(Index6score)+parseFloat(Index7score)+parseFloat(Index8score)+parseFloat(Index9score)+parseFloat(Index10score)+parseFloat(Index11score)+parseFloat(Index12score) */
		
		Indexscores1=parseFloat(Index1score)+parseFloat(Index4score)+parseFloat(Index7score)+parseFloat(Index10score);
	    Indexscores2=parseFloat(Index2score)+parseFloat(Index5score)+parseFloat(Index8score)+parseFloat(Index11score);
	    Indexscores3=parseFloat(Index3score)+parseFloat(Index6score)+parseFloat(Index9score)+parseFloat(Index12score);
	    Indexscore=parseFloat(Indexscores1)+parseFloat(Indexscores2)+parseFloat(Indexscores3)
	
	
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
	anchor: '95%'
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
	anchor: '95%'
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
	anchor: '95%'
});

	///////////////////////С�Ƶ÷�//////////////////////////////
var ss1coreField = new Ext.form.TextField({
	id:'ss1coreField',
	width:180,
	fieldLabel: 'С�Ƶ÷�',
	allowBlank: false,
	disabled:true,
	editable:false,
	name:'ss1coreField',
	value:Indexscores1, //Ĭ��ֵ
	emptyText:'С�Ƶ÷�...',
	anchor: '95%'
});

	///////////////////////С�Ƶ÷�//////////////////////////////
var ss2coreField = new Ext.form.TextField({
	id:'ss2coreField',
	width:180,
	fieldLabel: 'С�Ƶ÷�',
	allowBlank: false,
	disabled:true,
	editable:false,
	name:'ss2coreField',
	value:Indexscores2, //Ĭ��ֵ
	emptyText:'С�Ƶ÷�...',
	anchor: '95%'
});

	///////////////////////С�Ƶ÷�//////////////////////////////
var ss3coreField = new Ext.form.TextField({
	id:'ss3coreField',
	width:180,
	fieldLabel: 'С�Ƶ÷�',
	allowBlank: false,
	disabled:true,
	editable:false,
	name:'ss3coreField',
	value:Indexscores3, //Ĭ��ֵ
	emptyText:'С�Ƶ÷�...',
	anchor: '95%'
});

	///////////////////////С�Ƶ÷�//////////////////////////////
/* var ss4coreField = new Ext.form.TextField({
	id:'ss4coreField',
	width:180,
	fieldLabel: 'С�Ƶ÷�',
	allowBlank: false,
	disabled:true,
	editable:false,
	name:'ss4coreField',
	value:Indexscores4, //Ĭ��ֵ
	emptyText:'С�Ƶ÷�...',
	anchor: '95%'
}); */
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
					forceSelection : true
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
					forceSelection : true
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
					forceSelection : true
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
					forceSelection : true
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
					forceSelection : true
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
					forceSelection : true
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
					forceSelection : true
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
					forceSelection : true
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
					forceSelection : true
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
					forceSelection : true
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
					forceSelection : true
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
					forceSelection : true
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
		   
					   SubUserField	
					   
					]	 
				}]
				},{  
            //layout:'column', 	
			items: [
				{
					xtype: 'fieldset',
					width:735, 
					labelWidth:90,
					bodyStyle: 'border-width:1px 1px 1px 1px',	
					//autoHeight: true,
					items: [
						{
							xtype : 'displayfield',
							value : '',
							columnWidth : .8,
							bodyStyle:'padding:0 5px  0'
						},
								   
					  
					   sscoreField
					   
					   
					]	 
				}]
				},{  
            layout:'column', 	
			items: [
				{
					xtype: 'fieldset',
					labelWidth:90, 
                    //bodyStyle: 'border-width:1px 1px 0 1px',					
					columnWidth : .325,
					
					items: [
						{
							xtype : 'displayfield',
							value : '',
							width:25,
							
							bodyStyle:'padding:0 5px  0'
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
					xtype: 'fieldset',
					//labelWidth:90, 
                    //bodyStyle: 'border-width:1px 1px 0 1px',					
					columnWidth : .01
				}, {
					xtype: 'fieldset',
					
					labelWidth:90, 
					columnWidth : .325,
					bodyStyle: 'border-width:1px 1px 0 0',	
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
					xtype: 'fieldset',
					//labelWidth:90, 
                    //bodyStyle: 'border-width:1px 1px 0 1px',					
					columnWidth : .01
				}, {
					xtype: 'fieldset',
					
					labelWidth:90, 
					columnWidth : .325,
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
				 }]},{  
         xtype:'fieldset',  
         //autoHeight:true, 
		width:735,
         title:'ע����Ӧ��Ŀ���Ƽ���������������д�ã���ר������˶Ժ��֣���������ֱ�����Ϊ60�֣���ר�Ҹ��ݸ����ָ��������ϼƵ÷֡�'
         
           
           }]
		}
	]		
/*
	///////////////////////��Ŀ����//////////////////////////////
var TitleField = new Ext.form.TextField({
	id:'Title',
	width:180,
	fieldLabel: '��Ŀ����',
	allowBlank: false,
	editable:true,
	name:'Title',
	emptyText:'��Ŀ����...',
	anchor: '95%',
	disabled : true
});
	///////////////////////������//////////////////////////////
var SubUserField = new Ext.form.TextField({
	id:'SubUser',
	width:180,
	fieldLabel: '������',
	allowBlank: false,
	editable:true,
	name:'SubUser',
	emptyText:'������...',
	anchor: '95%',
	disabled : true
});

	///////////////////////�ϼƵ÷�//////////////////////////////
var sscoreField = new Ext.form.TextField({
	id:'sscoreField',
	width:180,
	fieldLabel: '�ϼƵ÷�',
	allowBlank: false,
	editable:false,
	name:'sscoreField',
	value:Indexscore, //Ĭ��ֵ
	emptyText:'�ϼƵ÷�...',
	anchor: '95%',
	disabled : true
});

	///////////////////////С�Ƶ÷�//////////////////////////////
var ss1coreField = new Ext.form.TextField({
	id:'ss1coreField',
	width:180,
	fieldLabel: 'С�Ƶ÷�',
	allowBlank: false,
	editable:false,
	name:'ss1coreField',
	value:Indexscores1, //Ĭ��ֵ
	emptyText:'С�Ƶ÷�...',
	anchor: '95%',
	disabled : true
});

	///////////////////////С�Ƶ÷�//////////////////////////////
var ss2coreField = new Ext.form.TextField({
	id:'ss2coreField',
	width:180,
	fieldLabel: 'С�Ƶ÷�',
	allowBlank: false,
	editable:false,
	name:'ss2coreField',
	value:Indexscores2, //Ĭ��ֵ
	emptyText:'С�Ƶ÷�...',
	anchor: '95%',
	disabled : true
});

	///////////////////////С�Ƶ÷�//////////////////////////////
var ss3coreField = new Ext.form.TextField({
	id:'ss3coreField',
	width:180,
	fieldLabel: 'С�Ƶ÷�',
	allowBlank: false,
	editable:false,
	name:'ss3coreField',
	value:Indexscores3, //Ĭ��ֵ
	emptyText:'С�Ƶ÷�...',
	anchor: '95%',
	disabled : true
});

	///////////////////////С�Ƶ÷�//////////////////////////////
var ss4coreField = new Ext.form.TextField({
	id:'ss4coreField',
	width:180,
	fieldLabel: 'С�Ƶ÷�',
	allowBlank: false,
	editable:false,
	name:'ss4coreField',
	value:Indexscores4, //Ĭ��ֵ
	emptyText:'С�Ƶ÷�...',
	anchor: '95%',
	disabled : true
});
var Index1scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0��'],['1', '1��'], ['2', '2��'],['3', '3��'],['4', '4��'],['5', '5��']]
				});
var Index1scoreField = new Ext.form.ComboBox({
					fieldLabel : 'Ŀ����ȷ��',
					width : 85,
					listWidth : 85,
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
					disabled : true
				});
var Index2scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0��'],['1', '1��'], ['2', '2��'],['3', '3��'],['4', '4��'],['5', '5��']]
				});
var Index2scoreField = new Ext.form.ComboBox({
					fieldLabel : '�������ճ̶�',
					width : 85,
					listWidth : 85,
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
					disabled : true
				});
var Index3scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0��'],['1', '1��'], ['2', '2��'],['3', '3��'],['4', '4��'],['5', '5��']]
				});
var Index3scoreField = new Ext.form.ComboBox({
					fieldLabel : '��ƿ�ѧ��',
					width : 85,
					listWidth : 85,
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
					disabled : true
				});
var Index4scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0��'],['1', '1��'], ['2', '2��'],['3', '3��'],['4', '4��'],['5', '5��']]
				});
var Index4scoreField = new Ext.form.ComboBox({
					fieldLabel : '���ⴴ����',
					width : 85,
					listWidth : 85,
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
					disabled : true
				});
var Index5scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0��'],['1', '1��'], ['2', '2��'],['3', '3��'],['4', '4��'],['5', '5��']]
				});
var Index5scoreField = new Ext.form.ComboBox({
					fieldLabel : '���ۿ�����',
					width : 85,
					listWidth : 85,
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
					disabled : true
				});
var Index6scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0��'],['1', '1��'], ['2', '2��'],['3', '3��'],['4', '4��'],['5', '5��']]
				});
var Index6scoreField = new Ext.form.ComboBox({
					fieldLabel : '����������',
					width : 85,
					listWidth : 85,
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
					disabled : true
				});
var Index7scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0��'],['1', '1��'], ['2', '2��'],['3', '3��'],['4', '4��'],['5', '5��']]
				});
var Index7scoreField = new Ext.form.ComboBox({
					fieldLabel : '��Ա������',
					width : 85,
					listWidth : 85,
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
					disabled : true
				});
var Index8scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0��'],['1', '1��'], ['2', '2��'],['3', '3��'],['4', '4��'],['5', '5��']]
				});
var Index8scoreField = new Ext.form.ComboBox({
					fieldLabel : '�ⲿ����������',
					width : 85,
					listWidth : 85,
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
					disabled : true
				});
var Index9scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0��'],['1', '1��'], ['2', '2��'],['3', '3��'],['4', '4��'],['5', '5��']]
				});
var Index9scoreField = new Ext.form.ComboBox({
					fieldLabel : 'Ԥ�������',
					width : 85,
					listWidth : 85,
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
					disabled : true
				});
var Index10scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0��'],['1', '1��'], ['2', '2��'],['3', '3��'],['4', '4��'],['5', '5��']]
				});
var Index10scoreField = new Ext.form.ComboBox({
					fieldLabel : '�����߼�������',
					width : 85,
					listWidth : 85,
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
					disabled : true
				});
var Index11scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0��'],['1', '1��'], ['2', '2��'],['3', '3��'],['4', '4��'],['5', '5��']]
				});
var Index11scoreField = new Ext.form.ComboBox({
					fieldLabel : '�������Ԥ��',
					width : 85,
					listWidth : 85,
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
					disabled : true
				});
var Index12scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0��'],['1', '1��'], ['2', '2��'],['3', '3��'],['4', '4��'],['5', '5��']]
				});
var Index12scoreField = new Ext.form.ComboBox({
					fieldLabel : 'ǰ�ڹ�������',
					width : 85,
					listWidth : 85,
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
					disabled : true
				});				
var colItems =	[
		{
			
		
			items:[{  
            layout:'column', 	
			items: [
				{
					width:779,  
                    //height:60,  
					xtype: 'fieldset',
					//autoHeight: true,
					labelWidth : 90,
					items: [
						{
							xtype : 'displayfield',
							value : '',
							columnWidth : .8,
							bodyStyle:'padding:5px 5px 5px 5px'
						},
								   
					  
					   TitleField,
		   
					   SubUserField	
					   
					]	 
				}]
				},{  
            layout:'column', 	
			items: [
				{
					xtype: 'fieldset',
					labelWidth:90,  
					columnWidth : .27,

					
					items: [
						{
							xtype : 'displayfield',
							value : '',
							width:25,
							bodyStyle:'padding:5px 5px 5px'
						},
								   
					  
					   Index1scoreField
					   ,
					   Index4scoreField,
					   Index7scoreField	
						,
		   
					   Index10scoreField	
					   
					]	 
				}, {
					xtype: 'fieldset',
					
					labelWidth:90, 
					columnWidth : .27,
					items: [
						{
							xtype : 'displayfield',
							value : '',
							width:25,
							bodyStyle:'padding:5px 5px  5px'
						}
						
							,
					   Index2scoreField	
							,
					   Index5scoreField	
					   	,
					   Index8scoreField	
					   	,
					   Index11scoreField	
					   	
					]
				 }, {
					xtype: 'fieldset',
					
					labelWidth:90, 
					columnWidth : .27,
					items: [
						{
							xtype : 'displayfield',
							value : '',
							width:25,
							bodyStyle:'padding:5px 5px  5px'
						}
						
					  
					   	,
					   Index3scoreField
							,
					  
					   Index6scoreField	
					   	,
					   Index9scoreField	
					   	,
					   Index12scoreField	
					]
				 },{
					xtype: 'fieldset',
					
					labelWidth:60, 
					columnWidth : .19,
					items: [
						{
							//xtype : 'displayfield',
							value : '',
							width:25,
							bodyStyle:'padding:5px 5px  5px'
						}
					
					   	,
					   ss1coreField
							,
					  
					   ss2coreField	
					   	,
					   ss3coreField	
					   	,
					   ss4coreField	
					]
				 }]},{  
            layout:'column', 	
			items: [
				{
					xtype: 'fieldset',
					width:779, 
					//autoHeight: true,
					labelWidth : 90,
					items: [
						{
							xtype : 'displayfield',
							value : '',
							columnWidth : .8,
							bodyStyle:'padding:5px 5px  5px'
						},
								   
					  
					   sscoreField
					   
					   
					]	 
				}]
				},{  
         xtype:'fieldset',  
         //autoHeight:true,  
         title:'',
         width:759, 
         items:[{  
          width:600,  
          height:60,
          disabled : true,  
          xtype:'textarea', 
			 //style:'margin-left:100px',  
			 value:"ע����Ӧ��Ŀ���Ƽ���������������д�ã���ר������˶Ժ��֣���������ֱ�����Ϊ60�֣���ר�Ҹ��ݸ����ָ��������ϼƵ÷֡�",
          fieldLabel:''  
         }] 
           
        }
				 ]
		}
	]		
	*/
	// create form panel
  	var viewFormPanel = new Ext.form.FormPanel
  	({  	
   		labelWidth: 80,
		frame: true,
    	items: colItems
	});
	
	viewFormPanel.on('afterlayout', function(panel, layout)
	{
		this.getForm().loadRecord(rowObj[0]);
	});

  	// define window and show it in desktop
 	var viewWindow = new Ext.Window
 	({
  		title: '����������ֱ�',
    	width: 800,
    	height:500,
    	//layout: 'fit',
    	plain:true,
    	modal:true,
    	bodyStyle:'padding:5px;',
    	buttonAlign:'center',
    	items: viewFormPanel
    });
    viewWindow.show();
};
