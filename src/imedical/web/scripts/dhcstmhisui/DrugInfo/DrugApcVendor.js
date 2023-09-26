// 名称:供应商管理
// 编写日期:2012-05-14

//创建编辑窗口(弹出)
//rowid :供应商rowid
var gVendorPara = [];
var APCVendorGridUrl = 'dhcstm.apcvendoraction.csp';
var win;
var PbVendor ='';
function CreateEditWin(Vendor){
	PbVendor = Vendor;
	setVendorParam();
	if(win){
		win.show();
		return;
	}

	//供应商代码
	var codeField = new Ext.form.TextField({
		id:'codeField',
		fieldLabel:'<font color=red>*供应商代码</font>',
		allowBlank:false,
		anchor:'90%',
		selectOnFocus:true,
		disabled:true,
		listeners:
		{
			'change':function(x,n,o){
				if (getVendorParamValue('CodeAlphaUp')=='1')		{
					var s=n;
					x.setValue(s.toUpperCase()) ;
				}	
			}
		}
	});
	
	//供应商名称
	var nameField = new Ext.form.TextField({
		id:'nameField',
		fieldLabel:'<font color=red>*供应商名称</font>',
		allowBlank:false,
		anchor:'90%',
		selectOnFocus:true,
		disabled:true,
		listeners:
		{
			'change':function(x,n,o){
				if (getVendorParamValue('NameAlphaUp')=='1')		{
					var s=n;
					x.setValue(s.toUpperCase()) ;
				}	
			}
		}
	});
	
	//供应商简称
	var abbrevField = new Ext.form.TextField({
		id:'abbrevField',
		fieldLabel:'供应商简称',
		//autoWidth:true,
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});	

	///上级供应商
	var parField = new Ext.ux.VendorComboBox({
		id:'parField',
		fieldLabel:'上一级供应商',
		anchor:'90%',
		width:143,
		listWidth:250,
		allowBlank:true,
		disabled:true,
		//store:GetParVendorsStore,
		//valueField:'RowId',
		//displayField:'Description',
		triggerAction:'all',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:true,
		editable:true,
		listeners:{
			'beforeselect':function(c,rec,index)
			{
				if (rec.get('Description')==Ext.getCmp('nameField').getValue())
				{
					Msg.info("error","与当前供应商相同，不允许!");
					return false;
				}
			}
		}
	});
	
	//业务员姓名
	var bussPersonField = new Ext.form.TextField({
		id:'bussPersonField',
		fieldLabel:'姓名',
		allowBlank:true,
		anchor:'95%',
		disabled:true,
		selectOnFocus:true
	});
	//业务员证书有效期
	var validDate = new Ext.ux.DateField({ 
		id:'validDate',
		fieldLabel:'证书有效期',
		allowBlank:true,
		anchor:'95%',
		disabled:true
	});
	
	//业务员电话
	var phoneField = new Ext.form.TextField({ 
		id:'phoneField',
		fieldLabel:'电话',
		anchor:'95%',
		disabled:true,
		allowBlank:true
	});
	
	//业务员身份证
	var salesIDField = new Ext.form.TextField({ 
		id:'salesIDField',
		anchor:'95%',
		fieldLabel:'身份证',
		disabled:true,
		allowBlank:true
	});
	//业务员邮箱
	var emailField = new Ext.form.TextField({ 
		id:'emailField',
		anchor:'95%',
		fieldLabel:'邮箱',
		disabled:true,
		allowBlank:true
	});
	
	//业务员配送电话(配送手机号)
	var salesCarrTelField = new Ext.form.TextField({ 
		id:'salesCarrTelField',
		anchor:'95%',
		disabled:true,
		fieldLabel:'配送手机号',
		allowBlank:true
	});	
	
	
	//供应商代码
	var addressField = new Ext.form.TextField({
		id:'addressField',
		fieldLabel:'供应商地址',
		allowBlank:true,
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//供应商电话
	var telField = new Ext.form.TextField({
		id:'telField',
		fieldLabel:'供应商电话',
		allowBlank:true,
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//分类
	var categoryField = new Ext.form.ComboBox({
		id:'categoryField',
		fieldLabel:'分类',
		anchor:'90%',
		allowBlank:true,
		store:GetVendorCatStore,
		valueField:'RowId',
		displayField:'Description',
		triggerAction:'all',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:true,
		disabled:true,
		editable:true
	});
	
	//账户
	var ctrlAcctField = new Ext.form.NumberField({
		id:'ctrlAcctField',
		fieldLabel:'账户',
		allowBlank:true,
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//开户银行
	var bankField = new Ext.form.TextField({
		id:'bankField',
		fieldLabel:'开户银行',
		allowBlank:true,
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//注册资金
	var crAvailField = new Ext.form.NumberField({
		id:'crAvailField',
		fieldLabel:'注册资金',
		allowBlank:true,
		allowNegative:false,
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//采购金额
	var feeField = new Ext.form.NumberField({
		id:'feeField',
		fieldLabel:'采购金额',
		allowBlank:true,
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//合同截止日期
	var lstPoDate = new Ext.ux.DateField({
		id:'lstPoDate',
		fieldLabel:'最后业务日期',
		allowBlank:true,
		disabled:true,
		disabled:true
	});
	
	//传真
	var faxField = new Ext.form.TextField({
		id:'faxField',
		fieldLabel:'传真',
		allowBlank:true,
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//法人
	var corporationField = new Ext.form.TextField({
		id:'corporationField',
		fieldLabel:'法人(联系人)',
		allowBlank:true,
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//法人身份证
	var presidentField = new Ext.form.TextField({
		id:'presidentField',
		fieldLabel:'法人身份证',
		allowBlank:true,
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//法人联系电话
	var presidentTelField = new Ext.form.TextField({
		id:'presidentTelField',
		fieldLabel:'法人联系电话',
		allowBlank:true,
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});	
	
	//状态
	var stateStore = new Ext.data.SimpleStore({
		fields:['key', 'keyValue'],
		data:[["A",'使用'], ["S",'停用']]
	});
	
	var stateField = new Ext.form.ComboBox({
		id:'stateField',
		fieldLabel:'使用状态',
		allowBlank:true,
		store:stateStore,
		value:'A', // 默认值"使用"
		valueField:'key',
		displayField:'keyValue',
		triggerAction:'all',
		anchor:'90%',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:true,
		editable:true,
		disabled:true,
		mode:'local'
	});
	
	//限制供应
	var limitSupplyField = new Ext.form.Checkbox({
		id: 'limitSupplyField',
		fieldLabel:'限制供应',
		disabled:true,
		allowBlank: true
	});

	var SmsField = new Ext.form.Checkbox({
		id: 'SmsField',
		fieldLabel:'短信通知',
		disabled:true,
		allowBlank: true
	});

	var PurchPlatField = new Ext.form.Checkbox({
		id: 'PurchPlatField',
		fieldLabel:'平台通知',
		disabled:true,
		allowBlank: true
	});
	
	//工商执照
	var comLicField = new Ext.form.TextField({
		id:'comLicField',
		fieldLabel:'工商执照',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	
	//工商执照有效期
	var comLicValidDate = new Ext.ux.DateField({ 
		id:'comLicValidDate',
		fieldLabel:'有效期',
		allowBlank:true,
		disabled:true
	});
	//税务执照
	var taxLicField = new Ext.form.TextField({
		id:'taxLicField',
		fieldLabel:'税务执照',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});	
	
	//税务执照有效期
	var taxLicValidDate = new Ext.ux.DateField({ 
		id:'taxLicValidDate',
		fieldLabel:'有效期',
		allowBlank:true,
		disabled:true 
	});
	
	//机构代码
	var orgCodeField = new Ext.form.TextField({
		id:'orgCodeField',
		fieldLabel:'机构代码',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	
	//机构代码有效期
	var orgCodeValidDate = new Ext.ux.DateField({ 
		id:'orgCodeValidDate',
		fieldLabel:'有效期',
		allowBlank:true,
		disabled:true
	});
	
	//药品经营许可证
	var drugBusLicField = new Ext.form.TextField({
		id:'drugBusLicField',
		fieldLabel:'药品经营许可证',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	//药品经营许可证有效期
	var drugBusLicValidDate = new Ext.ux.DateField({ 
		id:'drugBusLicValidDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		disabled:true        
	});
	
	//器械经营许可证
	var insBusLicField = new Ext.form.TextField({
		id:'insBusLicField',
		fieldLabel:'器械经营许可证',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	//器械经营许可证有效期
	var insBusLicValidDate = new Ext.ux.DateField({ 
		id:'insBusLicValidDate',
		fieldLabel:'有效期',  
		allowBlank:true,  
		disabled:true       
	});

	//器械生产许可证
	var insProLicField = new Ext.form.TextField({
		id:'insProLicField',
		fieldLabel:'器械生产许可证',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	//器械生产许可证有效期
	var insProLicValidDate = new Ext.ux.DateField({ 
		id:'insProLicValidDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		disabled:true
	});
	
	//质量承诺书
	var qualityCommField = new Ext.form.TextField({
		id:'qualityCommField',
		fieldLabel:'质量承诺书',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	//质量承诺书有效期
	var qualityCommValidDate = new Ext.ux.DateField({ 
		id:'qualityCommValidDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		disabled:true       
	});
	
	//代理授权书
	var agentAuthField = new Ext.form.TextField({
		id:'agentAuthField',
		fieldLabel:'代理授权书',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	//代理授权书有效期
	var agentAuthValidDate = new Ext.ux.DateField({ 
		id:'agentAuthValidDate',
		fieldLabel:'有效期',  
		allowBlank:true, 
		disabled:true        
	});
	
	//售后服务承诺书
	var saleServCommField = new Ext.form.TextField({
		id:'saleServCommField',
		fieldLabel:'售后服务承诺书',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	
	//法人委托书
	var legalCommField = new Ext.form.TextField({
		id:'legalCommField',
		fieldLabel:'法人委托书',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	//药品生产许可证
	var drugProLicField = new Ext.form.TextField({
		id:'drugProLicField',
		fieldLabel:'药品生产许可证',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	//药品生产许可证有效期
	var drugProLicValidDate = new Ext.ux.DateField({
		id:'drugProLicValidDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		disabled:true
	});
	
	//药品注册批件
	var drugRegLicField = new Ext.form.TextField({
		id:'drugRegLicField',
		fieldLabel:'药品注册批件',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	//药品注册批件有效期
	var drugRegLicValidDate = new Ext.ux.DateField({ 
		id:'drugRegLicValidDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		disabled:true    
	});
	
	//GSP认证
	var gspLicField = new Ext.form.TextField({
		id:'gspLicField',
		fieldLabel:'GSP认证',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	//GSP认证有效期
	var gspLicValidDate = new Ext.ux.DateField({ 
		id:'gspLicValidDate',
		fieldLabel:'有效期',  
		allowBlank:true, 
		disabled:true      
	});
	 
	//器械注册证
	var insRegLicField = new Ext.form.TextField({
		id:'insRegLicField',
		fieldLabel:'器械注册证',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	//器械注册证有效期
	var insRegLicValidDate = new Ext.ux.DateField({ 
		id:'insRegLicValidDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		disabled:true
	});
	
	//进口注册登记表
	var inletRegLicField = new Ext.form.TextField({
		id:'inletRegLicField',
		fieldLabel:'进口注册登记表',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	//进口注册登记表有效期
	var inletRegLicValidDate = new Ext.ux.DateField({ 
		id:'inletRegLicValidDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		disabled:true   
	});
	
	//进口注册证
	var inletRLicField = new Ext.form.TextField({
		id:'inletRLicField',
		fieldLabel:'进口注册证',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	//进口注册证有效期
	var inletRLicValidDate = new Ext.ux.DateField({ 
		id:'inletRLicValidDate',
		fieldLabel:'有效期',
		allowBlank:true,
		disabled:true
	});

	// 关闭按钮
	var closeBT = new Ext.Toolbar.Button({
		text : '关闭',
		tooltip : '关闭界面',
		iconCls : 'page_delete',
		//height:30,
		//width:70,
		handler : function() {
			win.close();
		}
	});
	
	//初始化面板
	var vendorPanel = new Ext.form.FormPanel({
		labelWidth : 80,
		labelAlign : 'right',
		frame : true,
		autoScroll : true,
		bodyStyle : 'padding:5px;',
		items : [{
				xtype : 'fieldset',
				title : '基本信息',
				autoHeight : true,
				items : [{
					layout : 'column',
					items : [
						{columnWidth:.35,layout:'form',items:[codeField]},
						{columnWidth:.55,layout:'form',items:[nameField]},
						{columnWidth:.1,layout:'form',items:[closeBT]}						
					]
				},{
					layout : 'column',
					items : [{columnWidth:.35,layout:'form',items:[categoryField]},
						{columnWidth:.45,layout:'form',items:[parField]}			
					]
				},{
					layout : 'column',
					items : [
						{columnWidth:.35,layout:'form',items:[corporationField]},
						{columnWidth:.35,layout:'form',items:[presidentField]},
						{columnWidth:.3,layout:'form',items:[presidentTelField]}						
					]
				},{
					layout : 'column',
					items : [
						{columnWidth:.35,layout:'form',items:[ctrlAcctField]},
						{columnWidth:.35,layout:'form',items:[bankField]},
						{columnWidth:.3,layout:'form',items:[crAvailField]}
					]
				},{
					layout : 'column',
					items : [
						{columnWidth:.35,layout:'form',items:[lstPoDate]},
						{columnWidth:.65,layout:'form',items:[addressField]}
					]
				},{
					layout : 'column',
					items : [
						{columnWidth:.35,layout:'form',items:[telField]}, 
						{columnWidth:.35,layout:'form',items:[faxField]}, 
						{columnWidth:.3,layout:'form',items:[limitSupplyField]}
					]
				},{
					layout : 'column',
					items : [
						{columnWidth:.35,layout:'form',items:[feeField]},
						{columnWidth:.2,layout:'form',items:[stateField]},
						{columnWidth:.35,layout:'form',items:[abbrevField]}
					]
				},{
					layout : 'column',
					items : [
						
						{columnWidth:.15,layout:'form',items:[SmsField]},
						{columnWidth:.15,layout:'form',items:[PurchPlatField]}
						
					]
				}]
			},{
				xtype : 'fieldset',
				title : '资质信息',
				autoHeight : true,
				items : [{
					layout:'column',
					items : [
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [comLicField,comLicValidDate]}]},
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [taxLicField,taxLicValidDate]}]}   //,taxLicButton,taxLicButtonTP
					]
				},{
					layout : 'column',
					items : [
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [orgCodeField,orgCodeValidDate]}]},
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [drugBusLicField,drugBusLicValidDate]}]} //,drugBusLicButton,drugBusLicButtonTP
							]
				},{
					layout:'column',
					items : [
					    {columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [insBusLicField,insBusLicValidDate]}]},
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [insProLicField,insProLicValidDate]}]}
							]
				},{
					layout : 'column',
					items : [
 						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [qualityCommField,qualityCommValidDate]}]},
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [agentAuthField,agentAuthValidDate]}]}
							]
				},{
					layout:'column',
					items : [
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [drugRegLicField,drugRegLicValidDate]}]},
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [drugProLicField,drugProLicValidDate]}]}
						]
				},{
					layout : 'column',
					items : [
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [gspLicField,gspLicValidDate]}]},
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [insRegLicField,insRegLicValidDate]}]}					
					]
				},{
					layout:'column',
					items : [
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [inletRegLicField,inletRegLicValidDate]}]},
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [inletRLicField,inletRLicValidDate]}]}
					]
				},{
					layout : 'column',
					items : [
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [saleServCommField]}]},
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [legalCommField]}]}
					]
				},{
					autoHeight : true,
					xtype:'fieldset',
					title : '业务员授权书信息',
					items : [{
						layout : 'column',
						items : [
							{columnWidth:.25,layout:'form',items:[bussPersonField]},
							{columnWidth:.25,layout:'form',items:[validDate]},
							{columnWidth:.4,layout:'form',items:[phoneField]},
							{columnWidth:.3,layout:'form',items:[salesIDField]},
							{columnWidth:.3,layout:'form',items:[emailField]},
							{columnWidth:.4,layout:'form',items:[salesCarrTelField]}
						]
					}]
				}]
			}]
	});

	//初始化窗口
	win = new Ext.Window({
		title:'供应商信息',
		width:1000,
		height:600,
		layout:'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'right',
		items:vendorPanel,
		closeAction:'hide',
		listeners:{
			'show':function(){
				if (PbVendor!=''){
					SetVendorInfo(PbVendor);
				}
			},
			'close' : function(p){
				win=null;
			}
		}
	});


		win.show();
	//显示供应商信息
	function SetVendorInfo(rowid){
		Ext.Ajax.request({
			url: APCVendorGridUrl+'?actiontype=queryByRowId&rowid='+rowid,
			failure: function(result, request) {
				Msg.info('error','失败！');
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				//vendorPanel.getForm().setValues(jsonData);
				if (jsonData.success=='true') {
					var value = jsonData.info;
					var arr = value.split("^");
					//基础信息
					Ext.getCmp('codeField').setValue(arr[0]);
					Ext.getCmp('nameField').setValue(arr[1]);
					Ext.getCmp('categoryField').setValue(arr[10]);
					Ext.getCmp('categoryField').setRawValue(arr[11]);
					Ext.getCmp('corporationField').setValue(arr[7]);
					Ext.getCmp('presidentField').setValue(arr[8]);
					Ext.getCmp('ctrlAcctField').setValue(arr[4]);
					Ext.getCmp('bankField').setValue(arr[3]);
					Ext.getCmp('crAvailField').setValue(arr[12]);
					Ext.getCmp('lstPoDate').setValue(arr[13]);
					Ext.getCmp('addressField').setValue(arr[14]);
					Ext.getCmp('telField').setValue(arr[2]);
					Ext.getCmp('faxField').setValue(arr[6]);
					Ext.getCmp('limitSupplyField').setValue(arr[15]=="Y"?true:false);
					Ext.getCmp('feeField').setValue(arr[5]);
					Ext.getCmp('stateField').setValue(arr[9]);
					Ext.getCmp('stateField').setRawValue(arr[9]=="A"?"使用":"停用");
					//资质信息
					Ext.getCmp('comLicField').setValue(arr[16]);
					Ext.getCmp('taxLicField').setValue(arr[38]);
					Ext.getCmp('orgCodeField').setValue(arr[33]);
					Ext.getCmp('drugBusLicField').setValue(arr[19]);
					Ext.getCmp('comLicValidDate').setValue(arr[17]);
					Ext.getCmp('taxLicValidDate').setValue(arr[39]);
					Ext.getCmp('orgCodeValidDate').setValue(arr[34]);
					Ext.getCmp('drugBusLicValidDate').setValue(arr[20]);
					Ext.getCmp('insBusLicField').setValue(arr[29]);
					Ext.getCmp('insProLicField').setValue(arr[31]);
					Ext.getCmp('qualityCommField').setValue(arr[43]);
					Ext.getCmp('agentAuthField').setValue(arr[18]);
					Ext.getCmp('insBusLicValidDate').setValue(arr[30]);
					Ext.getCmp('insProLicValidDate').setValue(arr[32]);
					Ext.getCmp('qualityCommValidDate').setValue(arr[44]);
					Ext.getCmp('agentAuthValidDate').setValue(arr[45]);
					Ext.getCmp('saleServCommField').setValue(arr[35]);
					Ext.getCmp('drugProLicField').setValue(arr[36]);
					Ext.getCmp('drugRegLicField').setValue(arr[40]);
					Ext.getCmp('gspLicField').setValue(arr[21]);
					Ext.getCmp('legalCommField').setValue(arr[42]);
					Ext.getCmp('drugProLicValidDate').setValue(arr[37]);
					Ext.getCmp('drugRegLicValidDate').setValue(arr[41]);
					Ext.getCmp('gspLicValidDate').setValue(arr[22]);
					Ext.getCmp('insRegLicField').setValue(arr[27]);
					Ext.getCmp('inletRegLicField').setValue(arr[25]);
					Ext.getCmp('inletRLicField').setValue(arr[23]);
					Ext.getCmp('insRegLicValidDate').setValue(arr[28]);
					Ext.getCmp('inletRegLicValidDate').setValue(arr[26]);
					Ext.getCmp('inletRLicValidDate').setValue(arr[24]);
					//业务员授权信息
					Ext.getCmp('bussPersonField').setValue(arr[46]);
					Ext.getCmp('validDate').setValue(arr[47]);
					Ext.getCmp('phoneField').setValue(arr[48]);	
					Ext.getCmp('salesIDField').setValue(arr[49]);
					
					addComboData(Ext.getCmp("parField").getStore(),arr[50],arr[51]);
					Ext.getCmp("parField").setValue(arr[50]);
					Ext.getCmp("abbrevField").setValue(arr[52]);
					Ext.getCmp('presidentTelField').setValue(arr[53]);   //法人电话									
					Ext.getCmp('emailField').setValue(arr[54]);   //邮箱
					Ext.getCmp('salesCarrTelField').setValue(arr[55]); 
					Ext.getCmp('SmsField').setValue(arr[56]=="Y"?true:false);
					Ext.getCmp('PurchPlatField').setValue(arr[57]=="Y"?true:false);
					
				}
			},
			scope: this
		});
	}

	//取得供应商串
	function  getVendorDataStr()
	{
		//基础信息
		//供应商代码
		var code = codeField.getValue();
		//供应商名称
		var name = nameField.getValue();
		
		if(code.trim()==""){
			Msg.info("warning","供应商代码为空!");
			return;
		}
		
		if(name.trim()==""){
			Msg.info("warning","供应商名称为空!");
			return;
		}
		
		//简称
		var abbrev=abbrevField.getValue();
		
		//上一级供应商
		var parVendor=parField.getValue();
		
		//供应商分类
		var categoryId = categoryField.getValue();
		//法人(联系人 )
		var corporation = corporationField.getValue();
		//法人身份证
		var president = presidentField.getValue();
		
		var presidentTel=presidentTelField.getValue();
		//账户
		var ctrlAcct = ctrlAcctField.getValue();
		//开户行
		var bankName = bankField.getValue();
		//注册资金
		var crAvail = crAvailField.getValue();
		if((crAvail!="" && crAvail<1)||crAvail===0){
			Msg.info("warning","注册资金最少为1元!");
			return;
		}
		//合同截止日期
		var lstPoDate = Ext.getCmp('lstPoDate').getValue();
		if((lstPoDate!="")&&(lstPoDate!=null)){
			lstPoDate = lstPoDate.format(ARG_DATEFORMAT);
		}
		//地址
		var address = addressField.getValue();
		//供应商电话
		var tel = telField.getValue();
		//供应商传真
		var fax = faxField.getValue();
		//限制供应
		var isLimitSupply = (limitSupplyField.getValue()==true)?'Y':'N';
		//采购金额
		var fee = feeField.getValue();
		//使用状态
		var state = stateField.getValue();
		
		//资质信息
		//工商执照
		var comLic = comLicField.getValue();
		//工商执照有效期
		var comLicValidDate = Ext.getCmp('comLicValidDate').getValue();
		if((comLicValidDate!="")&&(comLicValidDate!=null)){
			comLicValidDate = comLicValidDate.format(ARG_DATEFORMAT);
		}
		//税务执照
		var taxLic = taxLicField.getValue();
		//税务执照有效期
		var taxLicValidDate = Ext.getCmp('taxLicValidDate').getValue();
		if((taxLicValidDate!="")&&(taxLicValidDate!=null)){
			taxLicValidDate = taxLicValidDate.format(ARG_DATEFORMAT);
		}
		//机构代码
		var orgCode = orgCodeField.getValue();
		//税务执照有效期
		var orgCodeValidDate = Ext.getCmp('orgCodeValidDate').getValue();
		if((orgCodeValidDate!="")&&(orgCodeValidDate!=null)){
			orgCodeValidDate = orgCodeValidDate.format(ARG_DATEFORMAT);
		}
		//药品经营许可证
		var drugBusLic = drugBusLicField.getValue();
		//药品经营许可证有效期
		var drugBusLicValidDate = Ext.getCmp('drugBusLicValidDate').getValue();
		if((drugBusLicValidDate!="")&&(drugBusLicValidDate!=null)){
			drugBusLicValidDate = drugBusLicValidDate.format(ARG_DATEFORMAT);
		}
		
		
		//器械经营许可证
		var insBusLic = insBusLicField.getValue();
		//器械经营许可证有效期
		var insBusLicValidDate = Ext.getCmp('insBusLicValidDate').getValue();
		if((insBusLicValidDate!="")&&(insBusLicValidDate!=null)){
			insBusLicValidDate = insBusLicValidDate.format(ARG_DATEFORMAT);
		}
		//器械生产许可证
		var insProLic = insProLicField.getValue();
		//器械生产许可证有效期
		var insProLicValidDate = Ext.getCmp('insProLicValidDate').getValue();
		if((insProLicValidDate!="")&&(insProLicValidDate!=null)){
			insProLicValidDate = insProLicValidDate.format(ARG_DATEFORMAT);
		}
		//质量承诺书
		var qualityComm = qualityCommField.getValue();
		//质量承诺书有效期
		var qualityCommValidDate = Ext.getCmp('qualityCommValidDate').getValue();
		if((qualityCommValidDate!="")&&(qualityCommValidDate!=null)){
			qualityCommValidDate = qualityCommValidDate.format(ARG_DATEFORMAT);
		}
		//代理授权书
		var agentAuth = agentAuthField.getValue();
		//代理授权书有效期
		var agentAuthValidDate = Ext.getCmp('agentAuthValidDate').getValue();
		if((agentAuthValidDate!="")&&(agentAuthValidDate!=null)){
			agentAuthValidDate = agentAuthValidDate.format(ARG_DATEFORMAT);
		}
		
		
		//售后服务承诺书
		var saleServComm = saleServCommField.getValue();
		//法人委托书
		var legalComm = legalCommField.getValue();
		//药品生产许可证
		var drugProLic = drugProLicField.getValue();
		//药品生产许可证有效期
		var drugProLicValidDate = Ext.getCmp('drugProLicValidDate').getValue();
		if((drugProLicValidDate!="")&&(drugProLicValidDate!=null)){
			drugProLicValidDate = drugProLicValidDate.format(ARG_DATEFORMAT);
		}
		//药品注册批件
		var drugRegLic = drugRegLicField.getValue();
		//药品注册批件有效期
		var drugRegLicValidDate = Ext.getCmp('drugRegLicValidDate').getValue();
		if((drugRegLicValidDate!="")&&(drugRegLicValidDate!=null)){
			drugRegLicValidDate = drugRegLicValidDate.format(ARG_DATEFORMAT);
		}
		//GSP认证
		var gspLic = gspLicField.getValue();
		//GSP认证有效期
		var gspLicValidDate = Ext.getCmp('gspLicValidDate').getValue();
		if((gspLicValidDate!="")&&(gspLicValidDate!=null)){
			gspLicValidDate = gspLicValidDate.format(ARG_DATEFORMAT);
		}
		
		
		//器械注册证
		var insRegLic = insRegLicField.getValue();
		//器械注册证有效期
		var insRegLicValidDate = Ext.getCmp('insRegLicValidDate').getValue();
		if((insRegLicValidDate!="")&&(insRegLicValidDate!=null)){
			insRegLicValidDate = insRegLicValidDate.format(ARG_DATEFORMAT);
		}
		//进口注册登记表
		var inletRegLic = inletRegLicField.getValue();
		//进口注册登记表有效期
		var inletRegLicValidDate = Ext.getCmp('inletRegLicValidDate').getValue();
		if((inletRegLicValidDate!="")&&(inletRegLicValidDate!=null)){
			inletRegLicValidDate = inletRegLicValidDate.format(ARG_DATEFORMAT);
		}
		//进口注册证
		var inletRLic = inletRLicField.getValue();
		//进口注册证
		var inletRLicValidDate = Ext.getCmp('inletRLicValidDate').getValue();
		if((inletRLicValidDate!="")&&(inletRLicValidDate!=null)){
			inletRLicValidDate = inletRLicValidDate.format(ARG_DATEFORMAT);
		}
		
		
		//业务员授权信息
		//业务员姓名
		var bussPerson = bussPersonField.getValue();
		//证书有效期
		var validDate = Ext.getCmp('validDate').getValue();
		if((validDate!="")&&(validDate!=null)){
			validDate = validDate.format(ARG_DATEFORMAT);
		}
		//业务员电话
		var phone = phoneField.getValue();		
		//业务员身份证
		var salseID=salesIDField.getValue();
		var email=emailField.getValue();
		//
		var salesCarrTel=salesCarrTelField.getValue();	
		var Sms = (SmsField.getValue()==true)?'Y':'N';
		var PurchPlat = (PurchPlatField.getValue()==true)?'Y':'N';
		/*
		供应商代码^名称^电话^开户行^账户^采购限额^传真^法人^法人id^使用标志^分类id^注册资金^合同截止日期^地址^限制供应标志^工商执照^工商执照效期^代理授权书^药品经营许可证^药品经营许可证有效期
		^Gsp认证^Gsp认证有效期^进口注册证^进口注册证有效期^进口注册登记表^进口注册登记表有效期^器械注册证^器械注册证有效期^器械经营许可证^器械经营许可证有效期^器械生产许可证^器械生产许可证有效期
		^组织机构代码^组织机构有效期^售后服务承诺书^药品生产许可证^药品生产许可证有效期^税务登记^税务登记有效期^药品注册批件^药品注册批件有效期^法人委托书^质量承诺书^质量承诺书有效期^代理授权书有效期^业务员姓名^业务员授权书有效期^业务员电话^业务员身份证^法人联系电话
		*/
		
		//拼data字符串
		var data=code+"^"+name+"^"+tel+"^"+bankName+"^"+ctrlAcct+"^"+fee+"^"+fax+"^"+corporation+"^"+president+"^"+state+"^"+categoryId+"^"+crAvail+"^"+lstPoDate+"^"+address+"^"+isLimitSupply
		+"^"+comLic+"^"+comLicValidDate+"^"+agentAuth+"^"+drugBusLic+"^"+drugBusLicValidDate
		+"^"+gspLic+"^"+gspLicValidDate+"^"+inletRLic+"^"+inletRLicValidDate+"^"+inletRegLic+"^"+inletRegLicValidDate
		+"^"+insRegLic+"^"+insRegLicValidDate+"^"+insBusLic+"^"+insBusLicValidDate+"^"+insProLic+"^"+insProLicValidDate
		+"^"+orgCode+"^"+orgCodeValidDate+"^"+saleServComm+"^"+drugProLic+"^"+drugProLicValidDate+"^"+taxLic+"^"+taxLicValidDate
		+"^"+drugRegLic+"^"+drugRegLicValidDate+"^"+legalComm+"^"+qualityComm+"^"+qualityCommValidDate
		+"^"+agentAuthValidDate+"^"+bussPerson+"^"+validDate+"^"+phone+"^"+salseID+"^"+parVendor+"^"+abbrev+"^"+presidentTel+"^"+email+"^"+salesCarrTel+"^"+Sms+"^"+PurchPlat;
		
		return data;
	}
}

function setVendorParam()
{

	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var locId=session['LOGON.CTLOCID'];
	var hospId=session['LOGON.HOSPID'];
	
	var url='dhcstm.apcvendoraction.csp?actiontype=GetVendorParamP&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId+'&HospId='+hospId;
	var response=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(response);

	if (jsonData.length<0) return ;
	gVendorPara.length=jsonData.length ;
	for (var i=0;i<jsonData.length;i++)
	{
		var ss=jsonData[i];
		gVendorPara[ss.APCode]=ss.APValue ;
	}
}
function getVendorParamValue(apcode)
{
	return gVendorPara[apcode]
}

