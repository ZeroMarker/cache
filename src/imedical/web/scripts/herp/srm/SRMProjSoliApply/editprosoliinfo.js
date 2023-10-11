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

editFun = function() {
	var rowObj = itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1)
	{
		Ext.Msg.show({title:'提示',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		var editRowid = rowObj[0].get("rowid"); 
	}

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

var editYearCombo = new Ext.form.ComboBox({
	id: 'editYearCombo',
	fieldLabel: '年度',
	width:200,
	listWidth : 260,
	allowBlank: false,
	store:YearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择年度...',
	name: 'editYearCombo',
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

var editSubSourceCombo = new Ext.form.ComboBox({
			id:'editSubSourceCombo',
			fieldLabel : '项目来源',
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

/////////////////项目名称///////////////////
var editTitleField = new Ext.form.TextField({
				id: 'editTitleField',
                width: 200,
                allowBlank: false,
                name: 'editTitleField',
                fieldLabel: '项目名称',
                blankText: '项目名称',
				labelSeparator:''
            });
            
//伦理审核
var IsEthicStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '是'], ['0', '否']]
		});
var editIsEthicComboBox = new Ext.form.ComboBox({
			id : 'editIsEthicComboBox',
			fieldLabel : '是否伦理审核',
			width : 200,
			listWidth : 200,
			selectOnFocus : true,
			//allowBlank : false,
			store : IsEthicStore,
			//anchor : '90%',
			//value:'0', //默认值
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
  	title: '修改项目征集信息',
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
    	text: '保存', 
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
      			Ext.Msg.show({title:'错误',msg:'年度为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(editSubSource=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'项目来源为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(editTitle=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'项目名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(editIsEthic=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'是否伦理审核为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {				
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	    if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:25}});
									editWindow.close();
								}
								else
								{
									var message = "";
									message = jsonData.info;
									if(jsonData.info=='RepYearTitSub') message='输入的项目征集信息已经存在!';	
											
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
};
