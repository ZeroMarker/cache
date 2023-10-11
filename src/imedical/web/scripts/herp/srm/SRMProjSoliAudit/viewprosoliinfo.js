viewFun = function(viewrowid)
{
	var rowObj = itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1)
	{
		Ext.Msg.show({title:'提示',msg:'请选择需要查看的项目!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
///////////////////////项目名称//////////////////////////////
var eNameField = new Ext.form.TextField({
	id:'Title',
	width:180,
	disabled:true,
	fieldLabel: '项目名称',
	allowBlank: false,
	editable:false,
	name:'Title',
	emptyText:'项目名称...',
	anchor: '95%'
});
	///////////////////////申请人//////////////////////////////
var SubUserField = new Ext.form.TextField({
	id:'SubUser',
	width:180,
	fieldLabel: '申请人',
	allowBlank: false,
	editable:false,
	disabled:true,
	name:'SubUser',
	emptyText:'申请人...',
	anchor: '95%'
});
///////////////////////备注//////////////////////////////
var descField = new Ext.form.TextField({
	id:'descField',
	width:180,
	fieldLabel: '注：相应项目名称及负责人姓名已填写好，请专家认真核对后打分；本评审给分表满分为60分，请专家根据各项考核指标给出最后合计得分。',
	allowBlank: false,
	editable:false,
	name:'descField',
	value:'', //默认值
	emptyText:'',
	anchor: '95%'
});
	///////////////////////合计得分//////////////////////////////
var sscoreField = new Ext.form.TextField({
	id:'sscoreField',
	width:180,
	fieldLabel: '合计得分',
	allowBlank: false,
	editable:false,
	disabled:true,
	name:'sscoreField',
	value:Indexscore, //默认值
	emptyText:'合计得分...',
	anchor: '95%'
});

	///////////////////////小计得分//////////////////////////////
var ss1coreField = new Ext.form.TextField({
	id:'ss1coreField',
	width:180,
	fieldLabel: '小计得分',
	allowBlank: false,
	disabled:true,
	editable:false,
	name:'ss1coreField',
	value:Indexscores1, //默认值
	emptyText:'小计得分...',
	anchor: '95%'
});

	///////////////////////小计得分//////////////////////////////
var ss2coreField = new Ext.form.TextField({
	id:'ss2coreField',
	width:180,
	fieldLabel: '小计得分',
	allowBlank: false,
	disabled:true,
	editable:false,
	name:'ss2coreField',
	value:Indexscores2, //默认值
	emptyText:'小计得分...',
	anchor: '95%'
});

	///////////////////////小计得分//////////////////////////////
var ss3coreField = new Ext.form.TextField({
	id:'ss3coreField',
	width:180,
	fieldLabel: '小计得分',
	allowBlank: false,
	disabled:true,
	editable:false,
	name:'ss3coreField',
	value:Indexscores3, //默认值
	emptyText:'小计得分...',
	anchor: '95%'
});

	///////////////////////小计得分//////////////////////////////
/* var ss4coreField = new Ext.form.TextField({
	id:'ss4coreField',
	width:180,
	fieldLabel: '小计得分',
	allowBlank: false,
	disabled:true,
	editable:false,
	name:'ss4coreField',
	value:Indexscores4, //默认值
	emptyText:'小计得分...',
	anchor: '95%'
}); */
var Index1scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0分'],['1', '1分'], ['2', '2分'],['3', '3分'],['4', '4分'],['5', '5分']]
				});
var Index1scoreField = new Ext.form.ComboBox({
					fieldLabel : '目的明确性',
					width : 130,
					listWidth : 130,
					selectOnFocus : true,
					store : Index1scoreStore,
					//anchor : '90%',
					value:Index1score, //默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true
				});
var Index2scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0分'],['1', '1分'], ['2', '2分'],['3', '3分'],['4', '4分'],['5', '5分']]
				});
var Index2scoreField = new Ext.form.ComboBox({
					fieldLabel : '文献掌握程度',
					width : 130,
					listWidth :130,
					selectOnFocus : true,
					store : Index2scoreStore,
					//anchor : '90%',
					value:Index2score, //默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true
				});
var Index3scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0分'],['1', '1分'], ['2', '2分'],['3', '3分'],['4', '4分'],['5', '5分']]
				});
var Index3scoreField = new Ext.form.ComboBox({
					fieldLabel : '设计科学性',
					width : 130,
					listWidth : 130,
					selectOnFocus : true,
					store : Index3scoreStore,
					//anchor : '90%',
					value:Index3score, //默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true
				});
var Index4scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0分'],['1', '1分'], ['2', '2分'],['3', '3分'],['4', '4分'],['5', '5分']]
				});
var Index4scoreField = new Ext.form.ComboBox({
					fieldLabel : '课题创新性',
					width :130,
					listWidth : 130,
					selectOnFocus : true,
					store : Index4scoreStore,
					//anchor : '90%',
					value:Index4score, //默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true
				});
var Index5scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0分'],['1', '1分'], ['2', '2分'],['3', '3分'],['4', '4分'],['5', '5分']]
				});
var Index5scoreField = new Ext.form.ComboBox({
					fieldLabel : '理论可行性',
					width : 130,
					listWidth : 130,
					selectOnFocus : true,
					store : Index5scoreStore,
					//anchor : '90%',
					value:Index5score, //默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true
				});
var Index6scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0分'],['1', '1分'], ['2', '2分'],['3', '3分'],['4', '4分'],['5', '5分']]
				});
var Index6scoreField = new Ext.form.ComboBox({
					fieldLabel : '技术可行性',
					width : 130,
					listWidth : 130,
					selectOnFocus : true,
					store : Index6scoreStore,
					//anchor : '90%',
					value:Index6score, //默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true
				});
var Index7scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0分'],['1', '1分'], ['2', '2分'],['3', '3分'],['4', '4分'],['5', '5分']]
				});
var Index7scoreField = new Ext.form.ComboBox({
					fieldLabel : '人员可行性',
					width : 130,
					listWidth : 130,
					selectOnFocus : true,
					store : Index7scoreStore,
					//anchor : '90%',
					value:Index7score, //默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true
				});
var Index8scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0分'],['1', '1分'], ['2', '2分'],['3', '3分'],['4', '4分'],['5', '5分']]
				});
var Index8scoreField = new Ext.form.ComboBox({
					fieldLabel : '外部条件可行性',
					width : 130,
					listWidth : 130,
					selectOnFocus : true,
					store : Index8scoreStore,
					//anchor : '90%',
					value:Index8score, //默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true
				});
var Index9scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0分'],['1', '1分'], ['2', '2分'],['3', '3分'],['4', '4分'],['5', '5分']]
				});
var Index9scoreField = new Ext.form.ComboBox({
					fieldLabel : '预算合理性',
					width : 130,
					listWidth : 130,
					selectOnFocus : true,
					store : Index9scoreStore,
					//anchor : '90%',
					value:Index9score, //默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true
				});
var Index10scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0分'],['1', '1分'], ['2', '2分'],['3', '3分'],['4', '4分'],['5', '5分']]
				});
var Index10scoreField = new Ext.form.ComboBox({
					fieldLabel : '课题逻辑清晰度',
					width :130,
					listWidth :130,
					selectOnFocus : true,
					store : Index10scoreStore,
					//anchor : '90%',
					value:Index10score, //默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true
				});
var Index11scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0分'],['1', '1分'], ['2', '2分'],['3', '3分'],['4', '4分'],['5', '5分']]
				});
var Index11scoreField = new Ext.form.ComboBox({
					fieldLabel : '课题完成预期',
					width : 130,
					listWidth : 130,
					selectOnFocus : true,
					store : Index11scoreStore,
					//anchor : '90%',
					value:Index11score, //默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true
				});
var Index12scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0分'],['1', '1分'], ['2', '2分'],['3', '3分'],['4', '4分'],['5', '5分']]
				});
var Index12scoreField = new Ext.form.ComboBox({
					fieldLabel : '前期工作基础',
					width : 130,
					listWidth : 130,
					selectOnFocus : true,
					store : Index12scoreStore,
					//anchor : '90%',
					value:Index12score, //默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
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
         title:'注：相应项目名称及负责人姓名已填写好，请专家认真核对后打分；本评审给分表满分为60分，请专家根据各项考核指标给出最后合计得分。'
         
           
           }]
		}
	]		
/*
	///////////////////////项目名称//////////////////////////////
var TitleField = new Ext.form.TextField({
	id:'Title',
	width:180,
	fieldLabel: '项目名称',
	allowBlank: false,
	editable:true,
	name:'Title',
	emptyText:'项目名称...',
	anchor: '95%',
	disabled : true
});
	///////////////////////申请人//////////////////////////////
var SubUserField = new Ext.form.TextField({
	id:'SubUser',
	width:180,
	fieldLabel: '申请人',
	allowBlank: false,
	editable:true,
	name:'SubUser',
	emptyText:'申请人...',
	anchor: '95%',
	disabled : true
});

	///////////////////////合计得分//////////////////////////////
var sscoreField = new Ext.form.TextField({
	id:'sscoreField',
	width:180,
	fieldLabel: '合计得分',
	allowBlank: false,
	editable:false,
	name:'sscoreField',
	value:Indexscore, //默认值
	emptyText:'合计得分...',
	anchor: '95%',
	disabled : true
});

	///////////////////////小计得分//////////////////////////////
var ss1coreField = new Ext.form.TextField({
	id:'ss1coreField',
	width:180,
	fieldLabel: '小计得分',
	allowBlank: false,
	editable:false,
	name:'ss1coreField',
	value:Indexscores1, //默认值
	emptyText:'小计得分...',
	anchor: '95%',
	disabled : true
});

	///////////////////////小计得分//////////////////////////////
var ss2coreField = new Ext.form.TextField({
	id:'ss2coreField',
	width:180,
	fieldLabel: '小计得分',
	allowBlank: false,
	editable:false,
	name:'ss2coreField',
	value:Indexscores2, //默认值
	emptyText:'小计得分...',
	anchor: '95%',
	disabled : true
});

	///////////////////////小计得分//////////////////////////////
var ss3coreField = new Ext.form.TextField({
	id:'ss3coreField',
	width:180,
	fieldLabel: '小计得分',
	allowBlank: false,
	editable:false,
	name:'ss3coreField',
	value:Indexscores3, //默认值
	emptyText:'小计得分...',
	anchor: '95%',
	disabled : true
});

	///////////////////////小计得分//////////////////////////////
var ss4coreField = new Ext.form.TextField({
	id:'ss4coreField',
	width:180,
	fieldLabel: '小计得分',
	allowBlank: false,
	editable:false,
	name:'ss4coreField',
	value:Indexscores4, //默认值
	emptyText:'小计得分...',
	anchor: '95%',
	disabled : true
});
var Index1scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0分'],['1', '1分'], ['2', '2分'],['3', '3分'],['4', '4分'],['5', '5分']]
				});
var Index1scoreField = new Ext.form.ComboBox({
					fieldLabel : '目的明确性',
					width : 85,
					listWidth : 85,
					selectOnFocus : true,
					store : Index1scoreStore,
					//anchor : '90%',
					value:Index1score, //默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					disabled : true
				});
var Index2scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0分'],['1', '1分'], ['2', '2分'],['3', '3分'],['4', '4分'],['5', '5分']]
				});
var Index2scoreField = new Ext.form.ComboBox({
					fieldLabel : '文献掌握程度',
					width : 85,
					listWidth : 85,
					selectOnFocus : true,
					store : Index2scoreStore,
					//anchor : '90%',
					value:Index2score, //默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					disabled : true
				});
var Index3scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0分'],['1', '1分'], ['2', '2分'],['3', '3分'],['4', '4分'],['5', '5分']]
				});
var Index3scoreField = new Ext.form.ComboBox({
					fieldLabel : '设计科学性',
					width : 85,
					listWidth : 85,
					selectOnFocus : true,
					store : Index3scoreStore,
					//anchor : '90%',
					value:Index3score, //默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					disabled : true
				});
var Index4scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0分'],['1', '1分'], ['2', '2分'],['3', '3分'],['4', '4分'],['5', '5分']]
				});
var Index4scoreField = new Ext.form.ComboBox({
					fieldLabel : '课题创新性',
					width : 85,
					listWidth : 85,
					selectOnFocus : true,
					store : Index4scoreStore,
					//anchor : '90%',
					value:Index4score, //默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					disabled : true
				});
var Index5scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0分'],['1', '1分'], ['2', '2分'],['3', '3分'],['4', '4分'],['5', '5分']]
				});
var Index5scoreField = new Ext.form.ComboBox({
					fieldLabel : '理论可行性',
					width : 85,
					listWidth : 85,
					selectOnFocus : true,
					store : Index5scoreStore,
					//anchor : '90%',
					value:Index5score, //默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					disabled : true
				});
var Index6scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0分'],['1', '1分'], ['2', '2分'],['3', '3分'],['4', '4分'],['5', '5分']]
				});
var Index6scoreField = new Ext.form.ComboBox({
					fieldLabel : '技术可行性',
					width : 85,
					listWidth : 85,
					selectOnFocus : true,
					store : Index6scoreStore,
					//anchor : '90%',
					value:Index6score, //默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					disabled : true
				});
var Index7scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0分'],['1', '1分'], ['2', '2分'],['3', '3分'],['4', '4分'],['5', '5分']]
				});
var Index7scoreField = new Ext.form.ComboBox({
					fieldLabel : '人员可行性',
					width : 85,
					listWidth : 85,
					selectOnFocus : true,
					store : Index7scoreStore,
					//anchor : '90%',
					value:Index7score, //默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					disabled : true
				});
var Index8scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0分'],['1', '1分'], ['2', '2分'],['3', '3分'],['4', '4分'],['5', '5分']]
				});
var Index8scoreField = new Ext.form.ComboBox({
					fieldLabel : '外部条件可行性',
					width : 85,
					listWidth : 85,
					selectOnFocus : true,
					store : Index8scoreStore,
					//anchor : '90%',
					value:Index8score, //默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					disabled : true
				});
var Index9scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0分'],['1', '1分'], ['2', '2分'],['3', '3分'],['4', '4分'],['5', '5分']]
				});
var Index9scoreField = new Ext.form.ComboBox({
					fieldLabel : '预算合理性',
					width : 85,
					listWidth : 85,
					selectOnFocus : true,
					store : Index9scoreStore,
					//anchor : '90%',
					value:Index9score, //默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					disabled : true
				});
var Index10scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0分'],['1', '1分'], ['2', '2分'],['3', '3分'],['4', '4分'],['5', '5分']]
				});
var Index10scoreField = new Ext.form.ComboBox({
					fieldLabel : '课题逻辑清晰度',
					width : 85,
					listWidth : 85,
					selectOnFocus : true,
					store : Index10scoreStore,
					//anchor : '90%',
					value:Index10score, //默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					disabled : true
				});
var Index11scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0分'],['1', '1分'], ['2', '2分'],['3', '3分'],['4', '4分'],['5', '5分']]
				});
var Index11scoreField = new Ext.form.ComboBox({
					fieldLabel : '课题完成预期',
					width : 85,
					listWidth : 85,
					selectOnFocus : true,
					store : Index11scoreStore,
					//anchor : '90%',
					value:Index11score, //默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					disabled : true
				});
var Index12scoreStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '0分'],['1', '1分'], ['2', '2分'],['3', '3分'],['4', '4分'],['5', '5分']]
				});
var Index12scoreField = new Ext.form.ComboBox({
					fieldLabel : '前期工作基础',
					width : 85,
					listWidth : 85,
					selectOnFocus : true,
					store : Index12scoreStore,
					//anchor : '90%',
					value:Index12score, //默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
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
			 value:"注：相应项目名称及负责人姓名已填写好，请专家认真核对后打分；本评审给分表满分为60分，请专家根据各项考核指标给出最后合计得分。",
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
  		title: '课题评审给分表',
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
