var gUserId = session['LOGON.USERID'];	

var Vendor = new Ext.ux.UsrVendorComboBox({
	fieldLabel : '供应商',
	id : 'Vendor',
	name : 'Vendor',
	anchor : '30%',
	userId :gUserId,
	emptyText : '供应商...'
});



var findAPCVendor = new Ext.Toolbar.Button({
	text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		var rowid = Ext.getCmp('Vendor').getValue();
		SetVendorInfo(rowid);
	}
});

// 清空按钮
var RefreshBT = new Ext.Toolbar.Button({
	text : '清空',
	tooltip : '点击清空',
	iconCls : 'page_clearscreen',
	width : 70,
	Height : 30,
	handler : function() {
		clearData();
	}
});

		
		 //清空方法
		 
function clearData() {
	Ext.getCmp("Vendor").setValue('');
	rowid="";
	
	//基础信息
	Ext.getCmp('codeField').setValue('');
	Ext.getCmp('nameField').setValue('');
	Ext.getCmp('categoryField').setValue('');
	Ext.getCmp('categoryField').setRawValue('');
	Ext.getCmp('corporationField').setValue('');
	Ext.getCmp('presidentField').setValue('');
	Ext.getCmp('ctrlAcctField').setValue('');
	Ext.getCmp('bankField').setValue('');
	Ext.getCmp('crAvailField').setValue('');
	Ext.getCmp('lstPoDate').setValue('');
	Ext.getCmp('addressField').setValue('');
	Ext.getCmp('telField').setValue('');
	Ext.getCmp('faxField').setValue('');
	Ext.getCmp('limitSupplyField').setValue(false);
	Ext.getCmp('feeField').setValue('');
	Ext.getCmp('stateField').setValue('');
	Ext.getCmp('stateField').setRawValue("停用");
	//资质信息
	Ext.getCmp('comLicField').setValue('');
	Ext.getCmp('taxLicField').setValue('');
	Ext.getCmp('orgCodeField').setValue('');
	Ext.getCmp('drugBusLicField').setValue('');
	Ext.getCmp('comLicValidDate').setValue('');
	Ext.getCmp('taxLicValidDate').setValue('');
	Ext.getCmp('orgCodeValidDate').setValue('');
	Ext.getCmp('drugBusLicValidDate').setValue('');
	Ext.getCmp('insBusLicField').setValue('');
	Ext.getCmp('insProLicField').setValue('');
	Ext.getCmp('qualityCommField').setValue('');
	Ext.getCmp('agentAuthField').setValue('');
	Ext.getCmp('insBusLicValidDate').setValue('');
	Ext.getCmp('insProLicValidDate').setValue('');
	Ext.getCmp('qualityCommValidDate').setValue('');
	Ext.getCmp('agentAuthValidDate').setValue('');
	Ext.getCmp('saleServCommField').setValue('');
	Ext.getCmp('drugProLicField').setValue('');
	Ext.getCmp('drugRegLicField').setValue('');
	Ext.getCmp('gspLicField').setValue('');
	Ext.getCmp('legalCommField').setValue('');
	Ext.getCmp('drugProLicValidDate').setValue('');
	Ext.getCmp('drugRegLicValidDate').setValue('');
	Ext.getCmp('gspLicValidDate').setValue('');
	Ext.getCmp('insRegLicField').setValue('');
	Ext.getCmp('inletRegLicField').setValue('');
	Ext.getCmp('inletRLicField').setValue('');
	Ext.getCmp('insRegLicValidDate').setValue('');
	Ext.getCmp('inletRegLicValidDate').setValue('');
	Ext.getCmp('inletRLicValidDate').setValue('');
	//业务员授权信息
	Ext.getCmp('bussPersonField').setValue('');
	Ext.getCmp('validDate').setValue('');
	Ext.getCmp('phoneField').setValue('');			
	
}

//创建编辑窗口(弹出)
//rowid :供应商rowid


	
	
	//供应商代码
	var codeField = new Ext.form.TextField({
		id:'codeField',
		fieldLabel:'<font color=red>*供应商代码</font>',
		allowBlank:false,
		width:200,
		listWidth:200,
		//emptyText:'供应商代码...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//供应商名称
	var nameField = new Ext.form.TextField({
		id:'nameField',
		fieldLabel:'<font color=red>*供应商名称</font>',
		allowBlank:false,
		width:200,
		listWidth:200,
		//emptyText:'供应商名称...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//业务员姓名
	var bussPersonField = new Ext.form.TextField({
		id:'bussPersonField',
		fieldLabel:'业务员姓名',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'业务员姓名...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//供应商代码
	var addressField = new Ext.form.TextField({
		id:'addressField',
		fieldLabel:'供应商地址',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'供应商地址...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//供应商电话
	var telField = new Ext.form.TextField({
		id:'telField',
		fieldLabel:'供应商电话',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'供应商电话...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//分类
	var categoryField = new Ext.form.ComboBox({
		id:'categoryField',
		fieldLabel:'分类',
		width:143,
		listWidth:250,
		allowBlank:true,
		store:GetVendorCatStore,
		valueField:'RowId',
		displayField:'Description',
		//emptyText:'分类...',
		triggerAction:'all',
		//emptyText:'',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:true,
		editable:true
	});
	
	//账户
	var ctrlAcctField = new Ext.form.NumberField({
		id:'ctrlAcctField',
		fieldLabel:'账户',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'账户...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//开户银行
	var bankField = new Ext.form.TextField({
		id:'bankField',
		fieldLabel:'开户银行',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'开户银行...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//注册资金
	var crAvailField = new Ext.form.NumberField({
		id:'crAvailField',
		fieldLabel:'注册资金',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'注册资金...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//采购金额
	var feeField = new Ext.form.NumberField({
		id:'feeField',
		fieldLabel:'采购金额',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'采购金额...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//合同截止日期
	var lstPoDate = new Ext.ux.DateField({ 
		id:'lstPoDate',
		fieldLabel:'合同截止日期',  
		allowBlank:true,
		width:143,
		listWidth:143
	});
	
	//业务员证书有效期
	var validDate = new Ext.ux.DateField({ 
		id:'validDate',
		fieldLabel:'证书有效期',  
		allowBlank:true,
		width:184,
		listWidth:184
	});
	
	//业务员电话
	var phoneField = new Ext.form.TextField({ 
		id:'phoneField',
		fieldLabel:'业务员电话',  
		allowBlank:true,
		width:184,
		listWidth:184      
		//emptyText:'业务员电话 ...'
	});
	
	//传真
	var faxField = new Ext.form.TextField({
		id:'faxField',
		fieldLabel:'传真',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'传真...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//法人
	var corporationField = new Ext.form.TextField({
		id:'corporationField',
		fieldLabel:'法人(联系人)',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'法人(联系人)...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//法人身份证
	var presidentField = new Ext.form.TextField({
		id:'presidentField',
		fieldLabel:'法人身份证',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'法人身份证...',
		anchor:'90%',
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
		width:184,
		listWidth:184,
		allowBlank:true,
		store:stateStore,
		value:'A', // 默认值"使用"
		valueField:'key',
		displayField:'keyValue',
		//emptyText:'使用状态...',
		triggerAction:'all',
		//emptyText:'',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:true,
		editable:true,
		mode:'local'
	});
	
	//限制供应
	var limitSupplyField = new Ext.form.Checkbox({
		id: 'limitSupplyField',
		fieldLabel:'限制供应',
		allowBlank: true
	});
	
	//工商执照
	var comLicField = new Ext.form.TextField({
		id:'comLicField',
		fieldLabel:'工商执照',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'工商执照...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//工商执照有效期
	var comLicValidDate = new Ext.ux.DateField({ 
		id:'comLicValidDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		width:100,
		listWidth:100
	});
	//税务执照
	var taxLicField = new Ext.form.TextField({
		id:'taxLicField',
		fieldLabel:'税务执照',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'税务执照...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//税务执照有效期
	var taxLicValidDate = new Ext.ux.DateField({ 
		id:'taxLicValidDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		width:100,
		listWidth:100
	});
	
	//机构代码
	var orgCodeField = new Ext.form.TextField({
		id:'orgCodeField',
		fieldLabel:'机构代码',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'机构代码...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//机构代码有效期
	var orgCodeValidDate = new Ext.ux.DateField({ 
		id:'orgCodeValidDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		width:100,
		listWidth:100
	});
	
	//药品经营许可证
	var drugBusLicField = new Ext.form.TextField({
		id:'drugBusLicField',
		fieldLabel:'药品经营许可证',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'药品经营许可证...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//药品经营许可证有效期
	var drugBusLicValidDate = new Ext.ux.DateField({ 
		id:'drugBusLicValidDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		width:100,
		listWidth:100
	});
	
	//器械经营许可证
	var insBusLicField = new Ext.form.TextField({
		id:'insBusLicField',
		fieldLabel:'器械经营许可证',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'器械经营许可证...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//器械经营许可证有效期
	var insBusLicValidDate = new Ext.ux.DateField({ 
		id:'insBusLicValidDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		width:100,
		listWidth:100
	});

	//器械生产许可证
	var insProLicField = new Ext.form.TextField({
		id:'insProLicField',
		fieldLabel:'器械生产许可证',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'器械生产许可证...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//器械生产许可证有效期
	var insProLicValidDate = new Ext.ux.DateField({ 
		id:'insProLicValidDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		width:100,
		listWidth:100
	});
	
	//质量承诺书
	var qualityCommField = new Ext.form.TextField({
		id:'qualityCommField',
		fieldLabel:'质量承诺书',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'质量承诺书...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//质量承诺书有效期
	var qualityCommValidDate = new Ext.ux.DateField({ 
		id:'qualityCommValidDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		width:100,
		listWidth:100
	});
	
	//代理授权书
	var agentAuthField = new Ext.form.TextField({
		id:'agentAuthField',
		fieldLabel:'代理授权书',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'代理授权书...',
		anchor:'90%',
		selectOnFocus:true
	});

	//代理授权书有效期
	var agentAuthValidDate = new Ext.ux.DateField({ 
		id:'agentAuthValidDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		width:100,
		listWidth:100
	});
	
	//售后服务承诺书
	var saleServCommField = new Ext.form.TextField({
		id:'saleServCommField',
		fieldLabel:'售后服务承诺书',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'售后服务承诺书...',
		anchor:'90%',
		selectOnFocus:true
	});

	//法人委托书
	var legalCommField = new Ext.form.TextField({
		id:'legalCommField',
		fieldLabel:'法人委托书',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'法人委托书...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//药品生产许可证
	var drugProLicField = new Ext.form.TextField({
		id:'drugProLicField',
		fieldLabel:'药品生产许可证',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'药品生产许可证...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//药品生产许可证有效期
	var drugProLicValidDate = new Ext.ux.DateField({ 
		id:'drugProLicValidDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		width:100,
		listWidth:100
	});
	
	//药品注册批件
	var drugRegLicField = new Ext.form.TextField({
		id:'drugRegLicField',
		fieldLabel:'药品注册批件',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'药品注册批件...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//药品注册批件有效期
	var drugRegLicValidDate = new Ext.ux.DateField({ 
		id:'drugRegLicValidDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		width:100,
		listWidth:100
	});
	
	//GSP认证
	var gspLicField = new Ext.form.TextField({
		id:'gspLicField',
		fieldLabel:'GSP认证',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'GSP认证...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//GSP认证有效期
	var gspLicValidDate = new Ext.ux.DateField({ 
		id:'gspLicValidDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		width:100,
		listWidth:100
	});
	 
	//器械注册证
	var insRegLicField = new Ext.form.TextField({
		id:'insRegLicField',
		fieldLabel:'器械注册证',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'器械注册证...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//器械注册证有效期
	var insRegLicValidDate = new Ext.ux.DateField({ 
		id:'insRegLicValidDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		width:100,
		listWidth:100
	});
	
	//进口注册登记表
	var inletRegLicField = new Ext.form.TextField({
		id:'inletRegLicField',
		fieldLabel:'进口注册登记表',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'进口注册登记表...',
		anchor:'90%',
		selectOnFocus:true
	});

	//进口注册登记表有效期
	var inletRegLicValidDate = new Ext.ux.DateField({ 
		id:'inletRegLicValidDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		width:100,
		listWidth:100
	});
	
	//进口注册证
	var inletRLicField = new Ext.form.TextField({
		id:'inletRLicField',
		fieldLabel:'进口注册证',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'进口注册证...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//进口注册证有效期
	var inletRLicValidDate = new Ext.ux.DateField({ 
		id:'inletRLicValidDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		width:100,
		listWidth:100
	});

	
	
	//初始化面板
	var vendorPanel = new Ext.form.FormPanel({
		labelwidth : 30,
		labelAlign : 'right',
		frame : true,
		autoScroll : true,
		bodyStyle : 'padding:5px;',
		items : [{
			autoHeight : true,
			items : [{
				xtype : 'fieldset',
				title : '基本信息',
				autoHeight : true,
				items : [{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[codeField]},
						{columnWidth:.7,layout:'form',items:[nameField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[categoryField]},
						{columnWidth:.35,layout:'form',items:[corporationField]},
						{columnWidth:.35,layout:'form',items:[presidentField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[ctrlAcctField]},
						{columnWidth:.35,layout:'form',items:[bankField]},
						{columnWidth:.35,layout:'form',items:[crAvailField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[lstPoDate]},
						{columnWidth:.7,layout:'form',items:[addressField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[telField]}, 
						{columnWidth:.35,layout:'form',items:[faxField]}, 
						{columnWidth:.35,layout:'form',items:[limitSupplyField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[feeField]},
						{columnWidth:.35,layout:'form',items:[stateField]}
					]
				}]
			},{
				xtype : 'fieldset',
				title : '资质信息',
				autoHeight : true,
				items : [{
					layout:'column',
					height:25,
					items : [
						{columnWidth:.25,layout:'form',items:[comLicField]},
						{columnWidth:.25,layout:'form',items:[taxLicField]},
						{columnWidth:.25,layout:'form',items:[orgCodeField]},
						{columnWidth:.25,layout:'form',items:[drugBusLicField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.25,layout:'form',items:[comLicValidDate]},
						{columnWidth:.25,layout:'form',items:[taxLicValidDate]},
						{columnWidth:.25,layout:'form',items:[orgCodeValidDate]},
						{columnWidth:.25,layout:'form',items:[drugBusLicValidDate]}
					]
				},{
					layout:'column',
					height:25,
					items : [
						{columnWidth:.25,layout:'form',items:[insBusLicField]},
						{columnWidth:.25,layout:'form',items:[insProLicField]},
						{columnWidth:.25,layout:'form',items:[qualityCommField]},
						{columnWidth:.25,layout:'form',items:[agentAuthField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.25,layout:'form',items:[insBusLicValidDate]},
						{columnWidth:.25,layout:'form',items:[insProLicValidDate]},
						{columnWidth:.25,layout:'form',items:[qualityCommValidDate]},
						{columnWidth:.25,layout:'form',items:[agentAuthValidDate]}
					]
				},{
					layout:'column',
					height:25,
					items : [
						{columnWidth:.25,layout:'form',items:[saleServCommField]},
						{columnWidth:.25,layout:'form',items:[drugProLicField]},
						{columnWidth:.25,layout:'form',items:[drugRegLicField]},
						{columnWidth:.25,layout:'form',items:[gspLicField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.25,layout:'form',items:[legalCommField]},
						{columnWidth:.25,layout:'form',items:[drugProLicValidDate]},
						{columnWidth:.25,layout:'form',items:[drugRegLicValidDate]},
						{columnWidth:.25,layout:'form',items:[gspLicValidDate]}
					]
				},{
					layout:'column',
					height:25,
					items : [
						{columnWidth:.25,layout:'form',items:[insRegLicField]},
						{columnWidth:.25,layout:'form',items:[inletRegLicField]},
						{columnWidth:.25,layout:'form',items:[inletRLicField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.25,layout:'form',items:[insRegLicValidDate]},
						{columnWidth:.25,layout:'form',items:[inletRegLicValidDate]},
						{columnWidth:.25,layout:'form',items:[inletRLicValidDate]}
					]
				},{
					layout : 'column',
					autoHeight : true,
					xtype:'fieldset',
					title : '业务员授权书信息',
					items : [{
						layout : 'column',
						height:25,
						items : [
							{columnWidth:.3,layout:'form',items:[bussPersonField]},
							{columnWidth:.35,layout:'form',items:[validDate]},
							{columnWidth:.35,layout:'form',items:[phoneField]}
						]
					}]
				}]
			}]
		}]
	});
		

	

	//初始化窗口
	/*var window = new Ext.Window({
		title:'新建供应商',
		width:1000,
		height:612,
		minWidth:1000,
		minHeight:612,
		layout:'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'right',
		items:vendorPanel,
		buttons:[okButton,	cancelButton],
		listeners:{
			'show':function(){
				if (rowid!='')	{SetVendorInfo(rowid);}
			}
		}
	});
	
	window.show();*/
	
	//显示供应商信息
	function SetVendorInfo(rowid)
	{
		var APCVendorGridUrl = 'dhcstm.apcvendoraction.csp';
		Ext.Ajax.request({
			url: APCVendorGridUrl+'?actiontype=queryByRowId&rowid='+rowid,
			failure: function(result, request) {alert('失败！');},
			success: function(result, request) {
				//alert(result.responseText)
				var jsonData = Ext.util.JSON.decode( result.responseText );
				//alert(result.responseText);
				if (jsonData.success=='true') {
					var value = jsonData.info;
					//alert(value);
					var arr = value.split("^");
					//基础信息
					Ext.getCmp('codeField').setValue(arr[0]);
					Ext.getCmp('nameField').setValue(arr[1]);
					addComboData(GetVendorCatStore,arr[10],arr[11]);
					Ext.getCmp('categoryField').setValue(arr[10]);
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
				}
			}
			,
			scope: this
		});
		
	}



//===========模块主页面===========================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[{
	          region: 'north',
	          title:'供应商信息查询',
						labelAlign : 'right',
						frame : true,
				    tbar : [findAPCVendor,'-',RefreshBT],
	          height:100, // give north and south regions a height
	          layout: 'form', // specify layout manager for items
	          bodyStyle : 'padding:5px;',
	          items:[Vendor]
	        },{
	        	region: 'center',
	          title: '供应商信息',			               
	          layout: 'fit', // specify layout manager for items
	          items: [vendorPanel]
	        }],
		renderTo:'mainPanel'
	});
	
});
	
//===========模块主页面===========================================