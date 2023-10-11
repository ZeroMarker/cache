addtypefun=function(){

//单位账套数据集
/* var AcctBookNameProxy= new Ext.data.HttpProxy({
		url:CheckTypeUrl+'?action=AcctBookList'+'&AcctBookID='+acctbookid
});
var AcctBookNameDs = new Ext.data.Store({
		proxy:AcctBookNameProxy,
		reader:new Ext.data.JsonReader({
					root:'rows',
					totalProperty:'results'
		},['rowid','BookName']),
		remoteSort:true
});
	AcctBookNameDs.load({
		params:{
			start:0,
			limit:25
		}
	}); */



var AcctBookNameField = new Ext.form.TextField({
		id: 'AcctBookNameField',
		name: 'AcctBookNameField',
		fieldLabel: '单位账套名称',
		width:180,
		anchor: '90%',
		allowBlank : false,  
		disabled:true
});

Ext.Ajax.request({
		url:CheckTypeUrl+'?action=AcctBookList'+'&AcctBookID='+acctbookid,
		method:'GET',
		success:function(response){
			var respText=Ext.decode(response.responseText);
			var str=respText.info;
			Ext.getCmp('AcctBookNameField').setValue(str);
		}
});

//会计核算类别数据集
var CheckTypeProxy= new Ext.data.HttpProxy({
		url:CheckTypeUrl+'?action=CheckTypeList'	//+'&AcctBookID='+acctbookid
});
var CheckTypeDs = new Ext.data.Store({
		proxy:CheckTypeProxy,
		reader:new Ext.data.JsonReader({
					root:'rows',
					totalProperty:'results'
		},['rowid','CheckTypeName']),
		remoteSort:true
});
	CheckTypeDs.load({
		params:{
			start:0,
			limit:25
		}
	});

var CheckTypeField = new Ext.form.ComboBox({
		id: 'CheckTypeField',
		name: 'CheckTypeField',
		fieldLabel: '会计核算类别',
		store: CheckTypeDs,
		displayField: 'CheckTypeName',
		valueField: 'rowid',
		width:180,
		listWidth : 220,
		anchor: '90%',
		start:0,
		limit:100,
		pageSize : 10,
		minChars : 1,
		triggerAction : 'all',  
		allowBlank : false,  
		emptyText:'必选...',
		selectOnFocus:true,
		forceSelection:true,	//必须选择列表中的值
		editable:true
});

var isValidStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['0','否'],['1','是']]
});

var isValidField=new Ext.form.ComboBox({
		id: 'isValidField',
		name: 'isValidField',
		fieldLabel: '是否有效',
		width:180,
		listWidth : 220,
		selectOnFocus: true,
		allowBlank: true,
		store: isValidStore,
		anchor: '90%',
		valueField: 'key',
		displayField: 'keyValue',
		triggerAction: 'all',
		mode: 'local', // 本地模式
		emptyText:'请选择...',
		minChars: 15,
		pageSize: 10,
		forceSelection:true,
		editable:true
});	
var StartYearMonthField = new Ext.form.DateField({
		id: 'StartYearMonthField',
		fieldLabel: '启用年月',
		width:180,
		format:'Y-m',
		value:new Date(),	
		plugins : 'monthPickerPlugin',
		allowBlank: false,
		// emptyText:new Date(),
		anchor: '90%'
	});	
/* var StartMonthField = new Ext.form.TextField({
		id: 'StartMonthField',
		fieldLabel: '启用月',
		width:180,
		allowBlank: false,
		emptyText: '如：09。必填...',
		anchor: '90%'
	});	 */
var EndYearMonthField = new Ext.form.DateField({
		id: 'EndYearMonthField',
		fieldLabel: '停用年月',
		width:180,
		allowBlank: true,
		format:'Y-m',
		plugins : 'monthPickerPlugin',
		emptyText: '停用年月...',
		anchor: '90%'
	});	
/* var EndMonthField = new Ext.form.TextField({
		id: 'EndMonthField',
		fieldLabel: '停用月',
		width:180,
		allowBlank: true,
		emptyText: '停用月...',
		anchor: '90%'
	});	 */

var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 100,
		labelAlign:'right',
		lineHeight:25,
		items: [
			AcctBookNameField,
			CheckTypeField,
			// isValidField,
			StartYearMonthField
			// EndYearMonthField
		]
});
var addwindow= new Ext.Window({
		title: '核算类型添加',
		width: 350,
		height:220,
		minWidth: 300,
		minHeight: 220,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:20px 10px 0 10px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			text: '保存',
			iconCls:'save',
			handler: function(){
				var bookid=acctbookid;	//实际取的是BookName对应的ID
				var checktypeid=CheckTypeField.getValue();//实际取的是CheckTypeName对应的ID
				// var isvalid=isValidField.getValue();
				var startyearmonth=StartYearMonthField.getRawValue();
				// var yearmonth=startyearmonth.split("-");
				var startyear=startyearmonth.substring(0,4);//yearmonth[0];
				var startmonth=startyearmonth.substring(5,7);
				// var endyearmonth=EndYearMonthField.getRawValue();
				// var endyear=endyearmonth.split("-",1);	
				// var endmonth=endyearmonth.split("-",2);
				// alert(startyear+"^"+startmonth);
				if((checktypeid=="")||(startyear=="")||(startmonth=="")){
					Ext.Msg.show({
						title:'错误',
						msg:'会计核算类别或启用年月不能为空！',
						buttons: Ext.Msg.OK,
						icon:Ext.MessageBox.ERROR
						});
						return;
					}
				var newdata='&AcctBookID='+bookid+'&AcctCheckTypeID='+checktypeid
					+'&StartYear='+startyear+'&StartMonth='+startmonth;		//+'&IsValid='+isvalid+'&EndYear='+endyear+'&EndMonth='+endmonth;
				
				Ext.Ajax.request({
					url: CheckTypeUrl+'?action=TypeBookadd'+newdata,
					failure: function(result, request) {
							Ext.Msg.show({
								title:'错误',
								msg:'请检查网络连接!',
								buttons: Ext.Msg.OK,
								icon:Ext.MessageBox.ERROR
								});
					},
					success: function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({
									title:'注意',
									msg:'添加成功!',
									buttons: Ext.Msg.OK,
									icon:Ext.MessageBox.INFO
									});
						  		CheckTypeBookDs.load({
									params:{
										start:0, 
										limit:25 
										}
									});
								}else {
									var message = jsonData.info;
									Ext.Msg.show({
									title : '错误',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
									});
								}
					},
					scope: this
				});
			//	addwindow.close();
      		
				}
			},
		{
			text: '取消',
			iconCls:'back',
			handler: function(){
				addwindow.close();
				}
		}]
    
	});
    addwindow.show();	
			
};
