var userdr = session['LOGON.USERCODE'];

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
/////////////////添加功能/////////////////
addFun = function() {

/////////////////年度///////////////////////
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
	fieldLabel: '年度',
	width:200,
	listWidth : 260,
	allowBlank: true,
	store:YearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择年度...',
	name: 'addYearCombo',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});

 ///项目来源
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
			fieldLabel : '项目来源',
			store : SubSourceDs,
			displayField : 'Name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			//emptyText : '请选择项目来源...',
			width : 200,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:''
		});

/////////////////项目名称///////////////////
var addTitleField = new Ext.form.TextField({
				id: 'addTitleField',
                width: 200,
                allowBlank: true,
                name: 'addTitleField',
                fieldLabel: '项目名称',
                blankText: '项目名称',
				labelSeparator:''
            });
            
//伦理审核
var IsEthicStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '是'], ['0', '否']]
		});
var addIsEthicComboBox = new Ext.form.ComboBox({
			id : 'addIsEthicComboBox',
			fieldLabel : '是否伦理审核',
			width : 200,
			listWidth : 200,
			selectOnFocus : true,
			//allowBlank : false,
			store : IsEthicStore,
			//anchor : '90%',
			value:'0', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
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
  	title: '新增项目征集信息',
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
    	text: '保存', 
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
      	Ext.Msg.show({title:'错误',msg:'年度为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      	return;
      };
      if(addSubSource=="")
      {
      	Ext.Msg.show({title:'错误',msg:'项目来源为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      	return;
      };
      if(addTitle=="")
      {
      	Ext.Msg.show({title:'错误',msg:'项目名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      	return;
      };
      if(addIsEthic=="")
      {
      	Ext.Msg.show({title:'错误',msg:'伦理审批为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      	return;
      };
	
      
	  
	  
        	if (addFormPanel.form.isValid()) {
						Ext.Ajax.request({
							url: projUrl+'?action=add&Year='+encodeURIComponent(addYear)+'&Title='+encodeURIComponent(addTitle)+'&IsEthic='+encodeURIComponent(addIsEthic)+'&SubUser='+encodeURIComponent(userdr)+'&SubSource='+encodeURIComponent(addSubSource),
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								  itemGrid.load({params:{start:0, limit:25}});
									addWindow.close();
								}
							else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='RepYearTitSub') message='输入的项目征集信息已经存在!';		
								    Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
        	}
        	else{
						Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}             
	    	}
    	},
    	{
				text: '关闭',
				iconCls : 'cancel',
        handler: function(){addWindow.close();}
      }]
    });

    addWindow.show();
};
