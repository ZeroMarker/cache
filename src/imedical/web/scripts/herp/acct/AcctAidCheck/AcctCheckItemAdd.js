additemfun=function(){

//单位账套数据集
var selectedRow=AcctCheckTypeBookGrid.getSelectionModel().getSelections();
if(selectedRow[0]==undefined){
		Ext.Msg.show({
			title:'注意',
			msg:'请选择要添加的核算类型！',
			buttons: Ext.Msg.OK,
			icon:Ext.MessageBox.INFO
			});
	
}else{
var BookID=selectedRow[0].get("AcctBookID");
var BookName=selectedRow[0].get("BookName");
// alert(BookID+"+"+BookName);
var AcctBookNameField = new Ext.form.TextField({
		id: 'AcctBookNameField',
		name: 'AcctBookNameField',
		fieldLabel: '单位账套名称',
		displayField:BookID,
		value:BookName,
		width:180,
		anchor: '90%',
		triggerAction : 'all',  
		selectOnFocus:true,
		disabled:true
});


var TypeID=selectedRow[0].get("AcctCheckTypeID");
var TypeName=selectedRow[0].get("CheckTypeName");
var CheckTypeField = new Ext.form.ComboBox({
		id: 'CheckTypeField',
		name: 'CheckTypeField',
		fieldLabel: '会计核算类别',
		displayField: TypeID,
		value: TypeName,
		width:180,
		anchor: '90%',
		triggerAction : 'all',  
		selectOnFocus:true,
		disabled:true
});

var CheckItemCodeField=new Ext.form.TextField({
		id: 'CheckItemCodeField',
		fieldLabel: '核算项目编码',
		width:180,
		blankText:'请输入核算项目编码',
		allowBlank: false,
		emptyText: '必填项...',
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
		blankText:'请输入核算项目名称',
		allowBlank: false,
		emptyText: '必填项...',
		anchor: '90%',
		listeners : {
			specialKey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					if (CheckItemNameField.getValue() != "") {
						StartDateField.focus();
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
		anchor: '90%',
		valueField: 'key',
		displayField: 'keyValue',
		triggerAction: 'all',
		mode: 'local', // 本地模式
		emptyText:'请选择...',
		minChars: 15,
		pageSize: 10,
		forceSelection:true,
		editable:false
});	
var StartDateField = new Ext.form.DateField({
		id: 'StartDateField',
		fieldLabel: '起始时间',
		width:180,
		//format:'Y-m-d',
		value:new Date(),
		allowBlank: true,
		emptyText:'请选择...',
		anchor: '60%'
	});	
	
/*var EndDateField = new Ext.form.DateField({
		id: 'EndDateField',
		fieldLabel: '终止时间',
		width:180,
		format:'Y-m-d',
		allowBlank: true,
		emptyText: '终止时间...',
		anchor: '60%'
	});	

 var SpellCodeField = new Ext.form.TextField({
		id: 'SpellCodeField',
		fieldLabel: '拼音码',
		width:280,
		disabled:true,
		emptyText: '拼音码...',
		anchor: '90%'
	});	 */

var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 100,
		labelAlign:'right',
		items: [
			AcctBookNameField,
			CheckTypeField,
			CheckItemCodeField,
			CheckItemNameField,
			// IsValidField,
			StartDateField
			// EndDateField
			// SpellCodeField
		]
});
	
var addwindow= new Ext.Window({
		title: '核算类型添加',
		width: 400,
		height:260,
		minWidth: 300,
		minHeight: 250,
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
				var bookid=AcctBookNameField.displayField;	//acctbookid;	//实际取的是BookName对应的ID
				var checktypeid=CheckTypeField.displayField;	
				var checkitemcode=CheckItemCodeField.getValue();
				var checkitemname=encodeURIComponent(CheckItemNameField.getValue());
				// var isvalid=IsValidField.getValue();
				var startdate=StartDateField.getValue();
				if (startdate!="")  startdate=startdate.format(websys_DateFormat);
				// alert(startdate+"^"+enddate);
				if((bookid=="")||(checktypeid=="")||(checkitemcode=="")||(checkitemname=="")){
					Ext.Msg.show({
						title:'错误',
						msg:'核算项目编码或核算项目名称不能为空！',
						buttons: Ext.Msg.OK,
						icon:Ext.MessageBox.ERROR
						});
						return;
					}
				var newdata='&AcctBookID='+bookid+'&AcctCheckTypeID='+checktypeid+'&CheckItemCode='+checkitemcode+'&CheckItemName='+checkitemname
							+'&StartDate='+startdate;	//+'&EndDate='+enddate+'&IsValid='+isvalid;
				
				Ext.Ajax.request({
					url: CheckTypeUrl+'?action=CheckItemadd'+newdata,
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
						  		//刷新后停留在当前页
								var tbarnum = AcctCheckItemGrid.getBottomToolbar();  
									tbarnum.doLoad(tbarnum.cursor);
						  		/* CheckItemDs.load({
									params:{
										start:0, 
										limit:25 
										}
									}); */
									// addwindow.close();
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
				// addwindow.close();
      		
				}
			},{
				text: '取消',
				iconCls:'back',
				handler: function(){
					addwindow.close();
			}
		}]
    
	});
    addwindow.show();	
}			
};
