// JavaScript Document
/////////////////////修改功能/////////////////////
Date.dayNames = ["日", "一", "二", "三", "四", "五", "六"];  
    Date.monthNames=["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"];  
    if (Ext.DatePicker) {  
        Ext.apply(Ext.DatePicker.prototype, {  
            todayText: "今天",  
            minText: "日期在最小日期之前",  
            maxText: "日期在最大日期之后",  
            disabledDaysText: "",  
            disabledDatesText: "",  
            monthNames: Date.monthNames,  
            dayNames: Date.dayNames,  
            nextText: '下月 (Control+Right)',  
            prevText: '上月 (Control+Left)',  
            monthYearText: '选择一个月 (Control+Up/Down 来改变年)',  
            todayTip: "{0} (Spacebar)",  
            okText: "确定",  
            cancelText: "取消" 
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
		Ext.Msg.show({title:'提示',msg:'请选择需要评分的项目!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
	anchor: '95%',
	labelSeparator:''
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
	anchor: '95%',
	labelSeparator:''
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
	anchor: '95%',
	labelSeparator:''
});

	///////////////////////小计得分//////////////////////////////
var ss1coreField = new Ext.form.TextField({
	id:'ss1coreField',
	width:130,
	fieldLabel: '小计得分',
	allowBlank: false,
	disabled:true,
	editable:false,
	name:'ss1coreField',
	value:Indexscores1, //默认值
	emptyText:'小计得分...',
	labelSeparator:''
	//anchor: '95%'
});

	///////////////////////小计得分//////////////////////////////
var ss2coreField = new Ext.form.TextField({
	id:'ss2coreField',
	width:130,
	fieldLabel: '小计得分',
	allowBlank: false,
	disabled:true,
	editable:false,
	name:'ss2coreField',
	value:Indexscores2, //默认值
	emptyText:'小计得分...',
	labelSeparator:''
	//anchor: '95%'
});

	///////////////////////小计得分//////////////////////////////
var ss3coreField = new Ext.form.TextField({
	id:'ss3coreField',
	width:130,
	fieldLabel: '小计得分',
	allowBlank: false,
	disabled:true,
	editable:false,
	name:'ss3coreField',
	value:Indexscores3, //默认值
	emptyText:'小计得分...'
	//anchor: '95%'
});

	///////////////////////小计得分//////////////////////////////
var ss4coreField = new Ext.form.TextField({
	id:'ss4coreField',
	width:130,
	fieldLabel: '小计得分',
	allowBlank: false,
	disabled:true,
	editable:false,
	name:'ss4coreField',
	value:Indexscores4, //默认值
	emptyText:'小计得分...',
	labelSeparator:''
	//anchor: '95%'
});
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
					forceSelection : true,
					labelSeparator:''
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
					forceSelection : true,
					labelSeparator:''
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
					forceSelection : true,
					labelSeparator:''
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
					forceSelection : true,
					labelSeparator:''
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
					forceSelection : true,
					labelSeparator:''
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
					forceSelection : true,
					labelSeparator:''
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
					forceSelection : true,
					labelSeparator:''
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
					forceSelection : true,
					labelSeparator:''
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
					forceSelection : true,
					labelSeparator:''
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
					forceSelection : true,
					labelSeparator:''
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
					forceSelection : true,
					labelSeparator:''
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
         title:'注：相应项目名称及负责人姓名已填写好，请专家认真核对后打分；本评审给分表满分为60分，请专家根据各项考核指标给出最后合计得分。'
         
           
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
  	title: '课题评审给分表',
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
    	text: '保存',
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
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {				
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'评分成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:25}});
									editWindow.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info!=0) message='信息修改有误!';
								  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
        	}
        	else{
						Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后保存。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}             
	    	}
    	},
    	{
			text: '关闭',
			iconCls : 'cancel',
        handler: function(){editWindow.close();}
      }]
    });
    editWindow.show();
}