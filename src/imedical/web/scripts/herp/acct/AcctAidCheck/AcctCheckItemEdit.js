edititemfun =function(){
	var rowObj=AcctCheckItemGrid.getSelectionModel().getSelections();
	var len=rowObj.length;
	if(len==""){
		Ext.Msg.show({
			title:'注意',
			msg:'请选择需要修改的数据！',
			buttons:Ext.Msg.OK,
			icon:Ext.MessageBox.WARNING	
			
		});
		return;
	}else{
		var rowid =rowObj[0].get("rowid");
		var AcctBookID =rowObj[0].get("AcctBookID");
		var AcctBookName =rowObj[0].get("BookName");
		var AcctCheckTypeID =rowObj[0].get("AcctCheckTypeID");
		var AcctCheckTypeName =rowObj[0].get("CheckTypeName");
		var CheckItemCode =rowObj[0].get("CheckItemCode");
		var CheckItemName =rowObj[0].get("CheckItemName");
		var IsValid =rowObj[0].get("IsValid");
		var StartDate =rowObj[0].get("StartDate");
		var EndDate =rowObj[0].get("EndDate");
	}
var AcctBookIDField = new Ext.form.TextField({
		id: 'StartYearField',
		fieldLabel: '单位账套编码',
		width:180,
		allowBlank: true,
		emptyText: '',
		anchor: '90%'
	});	
var AcctCheckTypeIDField = new Ext.form.TextField({
		id: 'StartYearField',
		fieldLabel: '核算类型编码',
		width:180,
		allowBlank: true,
		emptyText: '',
		anchor: '90%'
	});	
	
var AcctBookNameeditField = new Ext.form.TextField({
		id: 'AcctBookNameeditField',
		name: 'AcctBookNameeditField',
		fieldLabel: '单位账套名称',
		width:180,
		anchor: '90%',
		disabled:true
});
	AcctBookNameeditField.on('select',function(combo, record, index){
		AcctBookID = combo.getValue();
	});

//会计核算类别数据集
var CheckTypeeditProxy= new Ext.data.HttpProxy({
		url:CheckTypeUrl+'?action=CheckTypeList'	
});
var CheckTypeeditDs = new Ext.data.Store({
		proxy:CheckTypeeditProxy,
		reader:new Ext.data.JsonReader({
					root:'rows',
					totalProperty:'results'
		},['rowid','CheckTypeName']),
		remoteSort:true
});
	CheckTypeeditDs.load({
		params:{
			start:0,
			limit:25
		}
	});

var CheckTypeeditField = new Ext.form.ComboBox({
		id: 'CheckTypeField',
		name: 'CheckTypeField',
		fieldLabel: '会计核算类别',
		store: CheckTypeeditDs,
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
		emptyText:'',
		selectOnFocus:true,
		forceSelection:true,
		valueNotFoundText:rowObj[0].get("CheckTypeName"),
		editable:true
});
	CheckTypeeditField.on('select',function(combo, record, index){
		AcctCheckTypeID = combo.getValue();
	});
var CheckItemCodeField=new Ext.form.TextField({
		id: 'CheckItemCodeField',
		fieldLabel: '核算项目编码',
		width:180,
		allowBlank: false,
		emptyText: '必填...',
		valueNotFoundText:rowObj[0].get("CheckItemCode"),
		anchor: '90%',
		listeners : {
			specialKey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					if (CheckItemCodeField.getValue() != "") {
						CheckItemNameField.focus();
					} else {
						Handler = function() {
							CheckItemCodeField.focus();
						}
						Ext.Msg.show({
							title : '提示',
							msg : '核算项目编码不能为空! ',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING,
							fn : Handler
						});
					}
				}
			}
		}
});
var CheckItemNameField=new Ext.form.TextField({
		id: 'CheckItemNameField',
		fieldLabel: '核算项目名称',
		width:220,
		allowBlank: false,
		emptyText: '必填...',
		valueNotFoundText:rowObj[0].get("CheckItemName"),
		anchor: '90%',
		listeners : {
			specialKey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					if (CheckItemNameField.getValue() != "") {
						IsValidField.focus();
					} else {
						Handler = function() {
							CheckItemNameField.focus();
						}
						Ext.Msg.show({
							title : '提示',
							msg : '核算项目名称不能为空! ',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING,
							fn : Handler
						});
					}
				}
			}
		}
});

var IsValidStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['0','否'],['1','是']]
});

var IsValidField=new Ext.form.ComboBox({
		id: 'IsValidField',
		name: 'IsValidField',
		fieldLabel: '是否有效',
		width:180,
		listWidth : 220,
		selectOnFocus: true,
		allowBlank: true,
		store: IsValidStore,
		anchor: '60%',
		valueField: 'key',
		displayField: 'keyValue',
		triggerAction: 'all',
		mode: 'local', // 本地模式
		emptyText:'请选择...',
		minChars: 15,
		pageSize: 10,
		forceSelection:true,
		valueNotFoundText:rowObj[0].get("IsValid"),
		editable:false
});	
var StartDateField = new Ext.form.DateField({
		id: 'StartDateField',
		fieldLabel: '起始时间',
		width:180,
		// format:'Y-m-d',
		allowBlank: true,
		emptyText: '起始时间...',
		valueNotFoundText:rowObj[0].get("StartDate"),
		anchor: '60%'
	});	
var EndDateField = new Ext.form.DateField({
		id: 'EndDateField',
		fieldLabel: '终止时间',
		width:180,
		// format:'Y-m-d',
		allowBlank: true,
		emptyText: '终止时间...',
		valueNotFoundText:rowObj[0].get("EndDate"),
		anchor: '60%'
	});	
/* var OrgItemIDField = new Ext.form.TextField({
		id: 'OrgItemIDField',
		fieldLabel: '原表ID',
		width:180,
		allowBlank: true,
		emptyText: '原表ID...',
		valueNotFoundText:rowObj[0].get("OrgItemID"),
		anchor: '90%'
	});	
var SpellCodeField = new Ext.form.TextField({
		id: 'SpellCodeField',
		fieldLabel: '拼音码',
		width:180,
		allowBlank: true,
		emptyText: '拼音码...',
		valueNotFoundText:rowObj[0].get("SpellCode"),
		anchor: '90%'
	});	
 */
var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 100,
		labelAlign:'right',
		items: [
			AcctBookNameeditField,
			CheckTypeeditField,
			CheckItemCodeField,
			CheckItemNameField,
			IsValidField,
			StartDateField,
			EndDateField
			// OrgItemIDField,
			// SpellCodeField
		]
});

//面板加载
  formPanel.on('afterlayout', function(panel, layout) {                                                                                           //
		this.getForm().loadRecord(rowObj[0]); 
			
		AcctBookNameeditField.setValue(rowObj[0].get("BookName"));
		CheckTypeeditField.setValue(rowObj[0].get("AcctCheckTypeName"));	
		CheckItemCodeField.setValue(rowObj[0].get("CheckItemCode"));
		CheckItemNameField.setValue(rowObj[0].get("CheckItemName"));	
		IsValidField.setValue(rowObj[0].get("IsValid"));
		StartDateField.setValue(rowObj[0].get("StartDate"));	
		EndDateField.setValue(rowObj[0].get("EndDate"));                                                                                              //
		// OrgItemIDField.setValue(rowObj[0].get("OrgItemID"));	
		// SpellCodeField.setValue(rowObj[0].get("SpellCode"));                                                                                              //
                                                                                                                    //
  });   
	
var editwindow= new Ext.Window({
		title: '会计核算项字典修改',
		width: 400,
		height:300,
		minWidth: 300,
		minHeight: 300,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:15px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			text: '保存',
			iconCls:'save',
			handler: function(){
				var rowid =rowObj[0].get("rowid");
				var booknameedit=parseInt(AcctBookID);//encodeURIComponent(AcctBookNameeditField.getValue());
				var checktypenameedit=parseInt(AcctCheckTypeID);	//encodeURIComponent(CheckTypeeditField.getValue());
				var checkitemcode=CheckItemCodeField.getValue();
				var checkitemname=encodeURIComponent(CheckItemNameField.getValue());
				var isvalid=encodeURIComponent(IsValidField.getValue());
				var startdate=StartDateField.getRawValue();
				var enddate=EndDateField.getRawValue();
				// alert(startdate+"^"+enddate);
				if(startdate.indexOf('/')!=-1){
					// 说明时间格式是：d/m/Y
					startdate= Date.parseDate(startdate,'j/n/Y').format('Y-m-d')
				}
				if(enddate.indexOf('/')!=-1){
					// 说明时间格式是：d/m/Y
					enddate= Date.parseDate(enddate,'j/n/Y').format('Y-m-d')
				}

				if((booknameedit=="")||(checktypenameedit=="")||(checkitemcode=="")||(checkitemname=="")){
					Ext.Msg.show({
						title:'错误',
						msg:'核算类型名称、核算项目编码和核算项目名称不能为空！',
						buttons: Ext.Msg.OK,
						icon:Ext.MessageBox.ERROR
						});
						return;
					}
				if(startdate!=""&&enddate!=""){
					if(startdate>enddate&&startdate!=enddate){
						Ext.Msg.show({
							title:'错误',
							msg:'起始时间不能大于终止时间！',
							buttons: Ext.Msg.OK,
							icon:Ext.MessageBox.ERROR
						});
						return;
					}
				}else{
					if(startdate=="") startdate=="";
					if(enddate=="") enddate=="";
				}
				
				var newdata='&rowid='+rowid+'&AcctBookID='+booknameedit+'&AcctCheckTypeID='+checktypenameedit+'&CheckItemCode='+checkitemcode+'&CheckItemName='+checkitemname
							+'&IsValid='+isvalid+'&StartDate='+startdate+'&EndDate='+enddate; //+'&OrgItemID='+orgitemid+'&SpellCode='+spellcode;
				
				Ext.Ajax.request({
					url: CheckTypeUrl+'?action=CheckItemedit'+newdata,
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
									msg:'修改成功!',
									buttons: Ext.Msg.OK,
									icon:Ext.MessageBox.INFO
									});
								var tbarnum = AcctCheckItemGrid.getBottomToolbar();  
									tbarnum.doLoad(tbarnum.cursor);
						  		/* CheckItemDs.load({
									params:{
										start:this.bar.cursor, 
										limit:25 
										}
									}); */
									editwindow.close();
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
				// editwindow.close();
      		
				}
			},
		{
			text: '取消',
			iconCls:'back',
			handler: function(){
				editwindow.close();
				}
		}]
    
	});
    editwindow.show();	
			
};
