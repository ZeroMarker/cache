// 名称:供应商管理
// 编写日期:2012-05-14
//=========================供应商类别=============================
var currVendorRowId='';

var conditionCodeField = new Ext.form.TextField({
	id:'conditionCodeField',
	fieldLabel:$g('供应商代码'),
	allowBlank:true,
	//width:180,
	listWidth:180,
	//emptyText:'供应商代码...',
	anchor:'90%',
	selectOnFocus:true
});
	
var conditionNameField = new Ext.form.TextField({
	id:'conditionNameField',
	fieldLabel:$g('供应商名称'),
	allowBlank:true,
	//width:150,
	listWidth:150,
	//emptyText:'供应商名称...',
	anchor:'90%',
	selectOnFocus:true
});

var conditionStateStore = new Ext.data.SimpleStore({
	fields:['key', 'keyValue'],
	data:[["A",$g('使用')], ["S",$g('停用')], ["",$g('全部')]]
});

var conditionStateField = new Ext.form.ComboBox({
	id:'conditionStateField',
	fieldLabel:$g('使用状态'),
	anchor:'90%',
	//width:230,
	listWidth:230,
	allowBlank:true,
	store:conditionStateStore,
	value:'', // 默认值"全部查询"
	valueField:'key',
	displayField:'keyValue',
	//emptyText:'使用状态...',
	triggerAction:'all',
	emptyText:'',
	minChars:1,
	pageSize:10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true	,
	mode:'local'
});
	
//配置数据源
var APCVendorGridUrl = 'dhcst.apcvendoraction.csp';
var APCVendorGridProxy= new Ext.data.HttpProxy({url:APCVendorGridUrl+'?actiontype=query',method:'POST'});
var APCVendorGridDs = new Ext.data.Store({
	proxy:APCVendorGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results',
        pageSize:35
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Name'},
		{name:'Tel'},
		{name:'Category'},
		{name:'CategoryId'},
		{name:'CtrlAcct'},
		{name:'CrAvail'},
		{name:'LstPoDate'},
		{name:'Fax'},
		{name:'President'},
		{name:'Status'}
	]),
    remoteSort:false
});

//模型
var APCVendorGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:$g("代码"),
        dataIndex:'Code',
        width:80,
        align:'left',
        sortable:true
    },{
        header:$g("名称"),
        dataIndex:'Name',
        width:400,
        align:'left',
        sortable:true
    },{
        header:$g("电话"),
        dataIndex:'Tel',
        width:120,
        align:'left',
        sortable:false
    },{
        header:$g("分类"),
        dataIndex:'Category',
        width:400,
        align:'left',
        sortable:false
    },{
        header:$g("账户"),
        dataIndex:'CtrlAcct',
        width:200,
        align:'left',
        sortable:false
    },{
        header:$g("注册资金"),
        dataIndex:'CrAvail',
        width:200,
        align:'left',
        sortable:false
    },{
        header:$g("合同截止日期"),
        dataIndex:'LstPoDate',
        width:150,
        align:'left',
        sortable:true
    },{
        header:$g("传真"),
        dataIndex:'Fax',
        width:200,
        align:'left',
        sortable:false
    },{
        header:$g("法人身份证"),
        dataIndex:'President',
        width:150,
        align:'left',
        sortable:true
    },{
        header:$g("使用标志"),
        dataIndex:'Status',
        width:200,
        align:'left',
        sortable:false,
		renderer : function(v, p, record){
			if(v=="A")
				return $g("使用");
			if(v=="S")
				return $g("停用");
		}
    }
]);

//初始化默认排序功能
APCVendorGridCm.defaultSortable = true;

var findAPCVendor = new Ext.Toolbar.Button({
	text:$g('查询'),
    tooltip:$g('查询'),
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		var conditionCode = Ext.getCmp('conditionCodeField').getValue();
		var conditionName=Ext.getCmp('conditionNameField').getValue();
		var conditionState=Ext.getCmp('conditionStateField').getValue();
		APCVendorGridDs.load({params:{start:0,limit:APCVendorPagingToolbar.pageSize,sort:'RowId',dir:'DESC',conditionCode:conditionCode,conditionName:conditionName,conditionState:conditionState}});
	}
});

// 另存按钮
var SaveAsBT = new Ext.Toolbar.Button({
	text : $g('另存'),
	tooltip : $g('另存为Excel'),
	iconCls : 'page_excel',
	width : 70,
	height : 30,
	handler : function() {
		ExportAllToExcel(APCVendorGrid);
	}
});
//创建编辑窗口(弹出)
//rowid :供应商rowid
function CreateEditWin(rowid)
{	
	//供应商代码
	var codeField = new Ext.form.TextField({
		id:'codeField',
		fieldLabel:'<font color=red>*'+$g('供应商代码')+'</font>',
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
		fieldLabel:'<font color=red>*'+$g('供应商名称')+'</font>',
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
		fieldLabel:$g('业务员姓名'),
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
		fieldLabel:$g('供应商地址'),
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
		fieldLabel:$g('供应商电话'),
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
		fieldLabel:$g('分类'),
		anchor:'90%',
		//width:143,
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
	var ctrlAcctField = new Ext.form.TextField({
		id:'ctrlAcctField',
		fieldLabel:$g('账户'),
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
		fieldLabel:$g('开户银行'),
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'开户银行...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//注册资金
	var crAvailField = new Ext.form.TextField({
		id:'crAvailField',
		fieldLabel:$g('注册资金'),
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
		fieldLabel:$g('采购金额'),
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
		fieldLabel:$g('合同截止日期'),  
		allowBlank:true,
		width:143,
		listWidth:143   
		//emptyText:'合同截止日期 ...'
	});
	
	//业务员证书有效期
	var validDate = new Ext.ux.DateField({ 
		id:'validDate',
		fieldLabel:$g('证书有效期'),  
		allowBlank:true,
		width:184,
		listWidth:184      
		//emptyText:'证书有效期 ...'
	});
	
	//业务员电话
	var phoneField = new Ext.form.TextField({ 
		id:'phoneField',
		fieldLabel:$g('业务员电话'),  
		allowBlank:true,
		width:184,
		listWidth:184      
		//emptyText:'业务员电话 ...'
	});
	
	//传真
	var faxField = new Ext.form.TextField({
		id:'faxField',
		fieldLabel:$g('传真'),
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
		fieldLabel:$g('法人(联系人)'),
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
		fieldLabel:$g('法人身份证'),
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
		data:[["A",$g('使用')], ["S",$g('停用')]]
	});
	
	var stateField = new Ext.form.ComboBox({
		id:'stateField',
		fieldLabel: '<font color=red>*'+$g('使用状态')+'</font>',
		anchor:'90%',
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
		fieldLabel:$g('限制供应'),
		allowBlank: true
	});
	
	//工商执照
	var comLicField = new Ext.form.TextField({
		id:'comLicField',
		fieldLabel:$g('工商执照'),
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
		fieldLabel:$g('有效期'),  
		allowBlank:true,
		width:100,
		listWidth:100        
		//emptyText:'有效期 ...'
	});
	//税务执照
	var taxLicField = new Ext.form.TextField({
		id:'taxLicField',
		fieldLabel:$g('税务执照'),
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
		fieldLabel:$g('有效期'),  
		allowBlank:true,
		width:100,
		listWidth:100        
		//emptyText:'有效期 ...'
	});
	
	//机构代码
	var orgCodeField = new Ext.form.TextField({
		id:'orgCodeField',
		fieldLabel:$g('机构代码'),
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
		fieldLabel:$g('有效期'),  
		allowBlank:true,
		width:100,
		listWidth:100        
		//emptyText:'有效期 ...'
	});
	
	//药品经营许可证
	var drugBusLicField = new Ext.form.TextField({
		id:'drugBusLicField',
		fieldLabel:$g('药品经营许可证'),
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
		fieldLabel:$g('有效期'),  
		allowBlank:true,
		width:100,
		listWidth:100        
		//emptyText:'有效期 ...'
	});
	
	//器械经营许可证
	var insBusLicField = new Ext.form.TextField({
		id:'insBusLicField',
		fieldLabel:$g('器械经营许可证'),
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
		fieldLabel:$g('有效期'),  
		allowBlank:true,
		width:100,
		listWidth:100      
		//emptyText:'有效期 ...'
	});

	//器械生产许可证
	var insProLicField = new Ext.form.TextField({
		id:'insProLicField',
		fieldLabel:$g('器械生产许可证'),
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
		fieldLabel:$g('有效期'),  
		allowBlank:true,
		width:100,
		listWidth:100      
		//emptyText:'有效期 ...'
	});
	
	//质量承诺书
	var qualityCommField = new Ext.form.TextField({
		id:'qualityCommField',
		fieldLabel:$g('质量承诺书'),
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
		fieldLabel:$g('有效期'),  
		allowBlank:true,
		width:100,
		listWidth:100        
		//emptyText:'有效期 ...'
	});
	
	//代理授权书
	var agentAuthField = new Ext.form.TextField({
		id:'agentAuthField',
		fieldLabel:$g('代理授权书'),
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
		fieldLabel:$g('有效期'),  
		allowBlank:true,
		width:100,
		listWidth:100       
		//emptyText:'有效期 ...'
	});
	
	//售后服务承诺书
	var saleServCommField = new Ext.form.TextField({
		id:'saleServCommField',
		fieldLabel:$g('售后服务承诺书'),
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
		fieldLabel:$g('法人委托书'),
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
		fieldLabel:$g('药品生产许可证'),
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
		fieldLabel:$g('有效期'),  
		allowBlank:true,
		width:100,
		listWidth:100       
		//emptyText:'有效期 ...'
	});
	
	//药品注册批件
	var drugRegLicField = new Ext.form.TextField({
		id:'drugRegLicField',
		fieldLabel:$g('药品注册批件'),
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
		fieldLabel:$g('有效期'),  
		allowBlank:true,
		width:100,
		listWidth:100       
		//emptyText:'有效期 ...'
	});
	
	//GSP认证
	var gspLicField = new Ext.form.TextField({
		id:'gspLicField',
		fieldLabel:$g('GSP认证'),
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
		fieldLabel:$g('有效期'),  
		allowBlank:true,
		width:100,
		listWidth:100       
		//emptyText:'有效期 ...'
	});
	 
	//器械注册证
	var insRegLicField = new Ext.form.TextField({
		id:'insRegLicField',
		fieldLabel:$g('器械注册证'),
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
		fieldLabel:$g('有效期'),  
		allowBlank:true,
		width:100,
		listWidth:100       
		//emptyText:'有效期 ...'
	});
	
	//进口注册登记表
	var inletRegLicField = new Ext.form.TextField({
		id:'inletRegLicField',
		fieldLabel:$g('进口注册登记表'),
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
		fieldLabel:$g('有效期'),  
		allowBlank:true,
		width:100,
		listWidth:100        
		//emptyText:'有效期 ...'
	});
	
	//进口注册证
	var inletRLicField = new Ext.form.TextField({
		id:'inletRLicField',
		fieldLabel:$g('进口注册证'),
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
		fieldLabel:$g('有效期'),  
		allowBlank:true,
		width:100,
		listWidth:100       
		//emptyText:'有效期 ...'
	});
	
	//别名
	var VendorAlias = new Ext.form.TextField({
		id : 'VendorAlias',
		fieldLabel : $g('助记码'),
		anchor : '90%',
		maxLength : 20
	});
	
	var Universal = new Ext.form.Checkbox({
		id: 'Universal',
		fieldLabel:$g('通用标志'),
		checked:false,
		allowBlank: true,
		hidden:true
	});
	
	//初始化添加按钮
	var okButton = new Ext.Toolbar.Button({
		text:$g('保存'),
		iconCls:'page_save',
		handler:function()
		{	
			var ss=getVendorDataStr();
			if (typeof(ss)=='undefined' || ss==""){return;}
			
			if (rowid!='') {
				ss=rowid+'^'+ss;
				UpdVendorInfo(ss);  //执行更新}
			} else {
				InsVendorInfo(ss);  //执行插入
			}
		}
	});
	
	//初始化取消按钮
	var cancelButton = new Ext.Toolbar.Button({
		text:$g('关闭'),
		iconCls:'page_close',
		handler:function()
		{
			//alert(Ext.getCmp('codeField').getValue());
			if (window){
				window.close();		
			}
		}
	});
	/*
	var clearButton = new Ext.Toolbar.Button({
		text:'清空',
		handler:function()
		{
			
		
			
		}		
	})*/
	
	//初始化面板
	var vendorPanel = new Ext.form.FormPanel({
		labelWidth : 100,
		labelAlign : 'right',
		frame : true,
		autoScroll : true,
		bodyStyle : 'padding:5px;',
		items : [{
			autoHeight : true,
			items : [{
				xtype : 'fieldset',
				title : $g('基本信息'),
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
						{columnWidth:.35,layout:'form',items:[VendorAlias]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[feeField]},
						{columnWidth:.35,layout:'form',items:[stateField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[limitSupplyField]},
						{columnWidth:.35,layout:'form',items:[Universal]}
					]
				}]
			},{
				xtype : 'fieldset',
				title : $g('资质信息'),
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
					autoHeight : true,
					xtype:'fieldset',
					title : $g('业务员授权书信息'),
					items : [{
						layout : 'column',
						height:25,
						items : [
							{columnWidth:.3,layout:'form',items:[bussPersonField]},
							{columnWidth:.34,layout:'form',items:[validDate]},
							{columnWidth:.34,layout:'form',items:[phoneField]}
						]
					}]
				}]
			}]
		}]
	});
		

	

	//初始化窗口
	var window = new Ext.Window({
		title:$g('供应商信息编辑'),
		width:document.body.clientWidth*0.9,
		height:document.body.clientHeight*0.9,
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
	
	window.show();
	
	//显示供应商信息
	function SetVendorInfo(rowid)
	{
		Ext.Ajax.request({
			url: APCVendorGridUrl+'?actiontype=queryByRowId&rowid='+rowid,
			failure: function(result, request) {
				Msg.info('error',$g('失败！'));
			},
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
					Ext.getCmp('stateField').setRawValue(arr[9]=="A"?$g("使用"):$g("停用"));
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
					Ext.getCmp('VendorAlias').setValue(arr[49]);	
					Ext.getCmp('Universal').setValue(arr[50]=="Y"?true:false);				
				}
			}
			,
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
			Msg.info("warning",$g("供应商代码为空!"));
			//Ext.Msg.show({title:'提示',msg:'供应商代码为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(name.trim()==""){
			Msg.info("warning",$g("供应商名称为空!"));
			//Ext.Msg.show({title:'提示',msg:'供应商名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		//供应商分类
		var categoryId = categoryField.getValue();
		//法人(联系人 )
		var corporation = corporationField.getValue();
		//法人身份证
		var president = presidentField.getValue();
		//账户
		var ctrlAcct = ctrlAcctField.getValue();
		//开户行
		var bankName = bankField.getValue();
		//注册资金
		var crAvail = crAvailField.getValue();
		if (crAvail!="" && isNaN(crAvail)){
			Msg.info("warning",$g("注册资金请输入纯数字!"));
			return;
		}
		/*
		if((crAvail!="" && crAvail<1)||crAvail==0){
			Msg.info("warning","注册资金最少为1元!");
			return;
		}
		*/
		//合同截止日期
		var lstPoDate = Ext.getCmp('lstPoDate').getValue();
		if((lstPoDate!="")&&(lstPoDate!=null)){
			lstPoDate = lstPoDate.format(App_StkDateFormat);
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
		if(state==""){
			Msg.info("warning",$g("请选择使用状态!"));
			return;
		};
	
		//资质信息
		//工商执照
		var comLic = comLicField.getValue();
		//工商执照有效期
		var comLicValidDate = Ext.getCmp('comLicValidDate').getValue();
		if((comLicValidDate!="")&&(comLicValidDate!=null)){
			comLicValidDate = comLicValidDate.format(App_StkDateFormat);
		}
		//税务执照
		var taxLic = taxLicField.getValue();
		//税务执照有效期
		var taxLicValidDate = Ext.getCmp('taxLicValidDate').getValue();
		if((taxLicValidDate!="")&&(taxLicValidDate!=null)){
			taxLicValidDate = taxLicValidDate.format(App_StkDateFormat);
		}
		//机构代码
		var orgCode = orgCodeField.getValue();
		//税务执照有效期
		var orgCodeValidDate = Ext.getCmp('orgCodeValidDate').getValue();
		if((orgCodeValidDate!="")&&(orgCodeValidDate!=null)){
			orgCodeValidDate = orgCodeValidDate.format(App_StkDateFormat);
		}
		//药品经营许可证
		var drugBusLic = drugBusLicField.getValue();
		//药品经营许可证有效期
		var drugBusLicValidDate = Ext.getCmp('drugBusLicValidDate').getValue();
		if((drugBusLicValidDate!="")&&(drugBusLicValidDate!=null)){
			drugBusLicValidDate = drugBusLicValidDate.format(App_StkDateFormat);
		}
		
		
		//器械经营许可证
		var insBusLic = insBusLicField.getValue();
		//器械经营许可证有效期
		var insBusLicValidDate = Ext.getCmp('insBusLicValidDate').getValue();
		if((insBusLicValidDate!="")&&(insBusLicValidDate!=null)){
			insBusLicValidDate = insBusLicValidDate.format(App_StkDateFormat);
		}
		//器械生产许可证
		var insProLic = insProLicField.getValue();
		//器械生产许可证有效期
		var insProLicValidDate = Ext.getCmp('insProLicValidDate').getValue();
		if((insProLicValidDate!="")&&(insProLicValidDate!=null)){
			insProLicValidDate = insProLicValidDate.format(App_StkDateFormat);
		}
		//质量承诺书
		var qualityComm = qualityCommField.getValue();
		//质量承诺书有效期
		var qualityCommValidDate = Ext.getCmp('qualityCommValidDate').getValue();
		if((qualityCommValidDate!="")&&(qualityCommValidDate!=null)){
			qualityCommValidDate = qualityCommValidDate.format(App_StkDateFormat);
		}
		//代理授权书
		var agentAuth = agentAuthField.getValue();
		//代理授权书有效期
		var agentAuthValidDate = Ext.getCmp('agentAuthValidDate').getValue();
		if((agentAuthValidDate!="")&&(agentAuthValidDate!=null)){
			agentAuthValidDate = agentAuthValidDate.format(App_StkDateFormat);
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
			drugProLicValidDate = drugProLicValidDate.format(App_StkDateFormat);
		}
		//药品注册批件
		var drugRegLic = drugRegLicField.getValue();
		//药品注册批件有效期
		var drugRegLicValidDate = Ext.getCmp('drugRegLicValidDate').getValue();
		if((drugRegLicValidDate!="")&&(drugRegLicValidDate!=null)){
			drugRegLicValidDate = drugRegLicValidDate.format(App_StkDateFormat);
		}
		//GSP认证
		var gspLic = gspLicField.getValue();
		//GSP认证有效期
		var gspLicValidDate = Ext.getCmp('gspLicValidDate').getValue();
		if((gspLicValidDate!="")&&(gspLicValidDate!=null)){
			gspLicValidDate = gspLicValidDate.format(App_StkDateFormat);
		}
		
		
		//器械注册证
		var insRegLic = insRegLicField.getValue();
		//器械注册证有效期
		var insRegLicValidDate = Ext.getCmp('insRegLicValidDate').getValue();
		if((insRegLicValidDate!="")&&(insRegLicValidDate!=null)){
			insRegLicValidDate = insRegLicValidDate.format(App_StkDateFormat);
		}
		//进口注册登记表
		var inletRegLic = inletRegLicField.getValue();
		//进口注册登记表有效期
		var inletRegLicValidDate = Ext.getCmp('inletRegLicValidDate').getValue();
		if((inletRegLicValidDate!="")&&(inletRegLicValidDate!=null)){
			inletRegLicValidDate = inletRegLicValidDate.format(App_StkDateFormat);
		}
		//进口注册证
		var inletRLic = inletRLicField.getValue();
		//进口注册证
		var inletRLicValidDate = Ext.getCmp('inletRLicValidDate').getValue();
		if((inletRLicValidDate!="")&&(inletRLicValidDate!=null)){
			inletRLicValidDate = inletRLicValidDate.format(App_StkDateFormat);
		}
		
		
		//业务员授权信息
		//业务员姓名
		var bussPerson = bussPersonField.getValue();
		//证书有效期
		var validDate = Ext.getCmp('validDate').getValue();
		if((validDate!="")&&(validDate!=null)){
			validDate = validDate.format(App_StkDateFormat);
		}
		//业务员电话
		var phone = phoneField.getValue();		
		// 助记码
		var vendorAlias=Ext.getCmp('VendorAlias').getValue();
		// 通用标志
		// var universalFlag=(Universal.getValue()==true)?'Y':'N';  //通用标志不使用 2021-01-06 yangsj
		var universalFlag="N"
		/*
		供应商代码^名称^电话^开户行^账户^采购限额^传真^法人^法人id^使用标志^分类id^注册资金^合同截止日期^地址^限制供应标志^工商执照^工商执照效期^代理授权书^药品经营许可证^药品经营许可证有效期
		^Gsp认证^Gsp认证有效期^进口注册证^进口注册证有效期^进口注册登记表^进口注册登记表有效期^器械注册证^器械注册证有效期^器械经营许可证^器械经营许可证有效期^器械生产许可证^器械生产许可证有效期
		^组织机构代码^组织机构有效期^售后服务承诺书^药品生产许可证^药品生产许可证有效期^税务登记^税务登记有效期^药品注册批件^药品注册批件有效期^法人委托书^质量承诺书^质量承诺书有效期^代理授权书有效期^业务员姓名^业务员授权书有效期^业务员电话
		*/
		
		//拼data字符串
		var data=code+"^"+name+"^"+tel+"^"+bankName+"^"+ctrlAcct+"^"+fee+"^"+fax+"^"+corporation+"^"+president+"^"+state+"^"+categoryId+"^"+crAvail+"^"+lstPoDate+"^"+address+"^"+isLimitSupply
		+"^"+comLic+"^"+comLicValidDate+"^"+agentAuth+"^"+drugBusLic+"^"+drugBusLicValidDate
		+"^"+gspLic+"^"+gspLicValidDate+"^"+inletRLic+"^"+inletRLicValidDate+"^"+inletRegLic+"^"+inletRegLicValidDate
		+"^"+insRegLic+"^"+insRegLicValidDate+"^"+insBusLic+"^"+insBusLicValidDate+"^"+insProLic+"^"+insProLicValidDate
		+"^"+orgCode+"^"+orgCodeValidDate+"^"+saleServComm+"^"+drugProLic+"^"+drugProLicValidDate+"^"+taxLic+"^"+taxLicValidDate
		+"^"+drugRegLic+"^"+drugRegLicValidDate+"^"+legalComm+"^"+qualityComm+"^"+qualityCommValidDate
		+"^"+agentAuthValidDate+"^"+bussPerson+"^"+validDate+"^"+phone+"^"+vendorAlias+"^"+universalFlag;
		return data;
	}
	
	//插入供应商
	function InsVendorInfo(data)
	{
		var retstr=tkMakeServerCall("web.DHCST.APCVendor","CheckVendorBeforeInsert",data,HospId)
		var retflag=retstr.split("^")[0];
		var retmsg=retstr.split("^")[1];
		if(retflag==-1)
		{
			Msg.info("error",retmsg);
			return;
		}
		else if((retflag>0)||(retflag==-2))
		{
			Msg.info("error",$g("已存在相同的代码或者名称"));
			/*  通过标志已不使用 2021-02-04 yangsj
			if(confirm($g("已存在相同的代码或者名称,是否放弃本次新增记录?"))==false)  return ;
			var updflag=0;
			if(retflag>0) updflag=1;
			var ret=tkMakeServerCall("web.DHCST.APCVendor","UpdateUniversal",retmsg,updflag,HospId)
			if(ret!=0)
			{
				Msg.info("error",$g("更新通用标志失败,错误代码:")+ret);
			}
			else
			{
				Msg.info("success", $g("保存成功!"));
				window.close();
				APCVendorGridDs.load({params:{start:0,limit:APCVendorPagingToolbar.pageSize,sort:'RowId',dir:'DESC',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionName:Ext.getCmp('conditionNameField').getValue(),conditionState:Ext.getCmp('conditionStateField').getValue()}});
			}
			*/
			return;
		}
		Ext.Ajax.request({
			url: APCVendorGridUrl+'?actiontype=insert&data='+encodeURI(data),
			method:'post',
			waitMsg:$g('处理中...'),
			failure: function(result, request) {
				Msg.info("error",$g("请检查网络连接!"));
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					var newRowid = jsonData.info;
				
					Msg.info("success", $g("保存成功!"));
					window.close();
					APCVendorGridDs.load({params:{start:0,limit:APCVendorPagingToolbar.pageSize,sort:'RowId',dir:'DESC',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionName:Ext.getCmp('conditionNameField').getValue(),conditionState:Ext.getCmp('conditionStateField').getValue()}});
				}else{
					if(jsonData.info==-1){
						Msg.info("error",$g("名称和代码重复!"));
					}else if(jsonData.info==-2){
						Msg.info("error",$g("代码重复!"));
					}else if(jsonData.info==-3){
						Msg.info("error",$g("名称重复!"));
					}else if(jsonData.info==-6){
						Msg.info("error",$g("此代码已存在于物资系统,已置成通用!"));
					}else if(jsonData.info==-7){
						Msg.info("error",$g("此名称已存在于物资系统,已置成通用!"));
					}else{
						Msg.info("error", $g("保存失败!"));
					}
				}
			},
			scope: this
		});	
	}
	//更新供应商
	function UpdVendorInfo(data)
	{
		var retstr=tkMakeServerCall("web.DHCST.APCVendor","CheckVendorBeforeUpdate",data,HospId)
		var retflag=retstr.split("^")[0];
		var retmsg=retstr.split("^")[1];
		if(retflag=="-1")
		{
			Msg.info("error",retmsg);
			return;
		}
		else if((retflag=="-2")||(retflag>0))
		{
			if(confirm($g("已存在相同的代码或者名称,是否作废本次修改记录,激活原有记录?"))==false)  return ;
			var updflag=0;
			if(retflag>0) updflag=1;
			var ret=tkMakeServerCall("web.DHCST.APCVendor","UpdateVendor",data,retmsg,updflag,HospId);
			var flag=ret.split("^")[0];
			var msg=ret.split("^")[1];
			if(flag!=0)
			{
				Msg.info("error",$g("更新失败,错误信息:")+msg);
			}
			else
			{
				Msg.info("success",$g( "更新成功!"));
				APCVendorGridDs.load({params:{start:APCVendorPagingToolbar.cursor,limit:APCVendorPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionName:Ext.getCmp('conditionNameField').getValue(),conditionState:Ext.getCmp('conditionStateField').getValue()}});
				window.close();			
			}
			return;
		}
		
		Ext.Ajax.request({
			url:APCVendorGridUrl+'?actiontype=update',
			params:{data:data},
			waitMsg:$g('更新中...'),
			failure:function(result, request) {
				Msg.info("error",$g("请检查网络连接!"));
			},
			success:function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if(jsonData.success=='true'){
					Msg.info("success",$g("更新成功!"));
					APCVendorGridDs.load({params:{start:APCVendorPagingToolbar.cursor,limit:APCVendorPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionName:Ext.getCmp('conditionNameField').getValue(),conditionState:Ext.getCmp('conditionStateField').getValue()}});
					window.close();
				}else{
					if (jsonData.info==-1) {
						Msg.info("error",$g("名称和代码重复!"));
					} else if (jsonData.info==-2){
						Msg.info("error",$g("代码重复!"));
					} else if (jsonData.info==-3){
						Msg.info("error",$g("名称重复!"));
					} else{
						Msg.info("error",$g("保存失败!"));
					}
				}
			},
			scope: this
		});	
	}	
	
}

var addAPCVendor = new Ext.Toolbar.Button({
	text:$g('新建'),
    tooltip:$g('新建'),
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
	
		CreateEditWin('');
	}
});


var editAPCVendor = new Ext.Toolbar.Button({
	text:$g('编辑'),
    tooltip:$g('编辑'),
    iconCls:'page_edit',
	width : 70,
	height : 30,
	handler:function(){
		
		var rowObj = APCVendorGrid.getSelectionModel().getSelections(); 
		var len = rowObj.length;
		if(len < 1){
			Msg.info("error",$g("请选择数据!"));
			return false;
		}else{
			var rowid = rowObj[0].get('RowId');
		
			
		CreateEditWin(rowid);
		//窗口显示
		}
    }
});

var HospWinButton = GenHospWinButton("APC_Vendor");
//绑定点击事件
HospWinButton.on("click" , function(){
	var rowObj = APCVendorGrid.getSelectionModel().getSelections(); 
	if (rowObj.length===0){
		Msg.info("warning",$g("请选择数据!"));
		return;	
	}
	var rowID=rowObj[0].get("RowId")||'';
	if (rowID===''){
		Msg.info("warning",$g("请先保存数据!"));
		return;	
	}
    GenHospWin("APC_Vendor",rowID,function(){APCVendorGridDs.reload();}).show()   
});

var HospPanel = InitHospCombo('APC_Vendor',function(combo, record, index){
	HospId = this.value; 
	APCVendorGridDs.reload();
});

var formPanel = new Ext.form.FormPanel({
	labelWidth : 80,
	autoScroll:true,
	labelAlign : 'right',
	autoHeight:true,
	frame : true,
    tbar:[findAPCVendor,'-',addAPCVendor,'-',editAPCVendor,'-',SaveAsBT,'-',HospWinButton],
	items : [{
		xtype : 'fieldset',
		title : $g('查询条件'),
		layout : 'column',	
		style:DHCSTFormStyle.FrmPaddingV,
		defaults: {border:false}, 
		items : [{
				columnWidth : .33,
				xtype : 'fieldset',
				items : [conditionCodeField]
			}, {
				columnWidth : .33,
				xtype : 'fieldset',
				items : [conditionNameField]
			}, {
				columnWidth : .33,
				xtype : 'fieldset',
				items : [conditionStateField]
			}]
	}]

});

//分页工具栏
var APCVendorPagingToolbar = new Ext.PagingToolbar({
    store:APCVendorGridDs,
	pageSize:40,
    displayInfo:true,
    displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
    emptyMsg:$g("没有记录"),
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B[A.sort]='RowId';
		B[A.dir]='DESC';
		B['conditionCode']=Ext.getCmp('conditionCodeField').getValue();
		B['conditionName']=Ext.getCmp('conditionNameField').getValue();
		B['conditionState']=Ext.getCmp('conditionStateField').getValue();
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//表格
APCVendorGrid = new Ext.grid.EditorGridPanel({
	store:APCVendorGridDs,
	cm:APCVendorGridCm,
	title:$g('供应商明细'),
	trackMouseOver:true,
	region:'center',
	height:690,
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
	loadMask:true,
	bbar:APCVendorPagingToolbar,
	listeners:{
	'rowdblclick':function(){
	
		editAPCVendor.handler();}
	}
});

APCVendorGridDs.load({params:{start:0,limit:APCVendorPagingToolbar.pageSize,sort:'RowId',dir:'DESC',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionName:Ext.getCmp('conditionNameField').getValue(),conditionState:Ext.getCmp('conditionStateField').getValue()}});
//=========================供应商类别=============================



	
//===========模块主页面===========================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:$g('供应商维护'),
		activeTab:0,
		region:'north',
		height:DHCSTFormStyle.FrmHeight(1),
		layout:'fit',
		items:[formPanel]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[
			{
				region:'north',
				height:'500px',
				items:[HospPanel,panel]
			},APCVendorGrid
		],
		renderTo:'mainPanel'
	});
});
	
//===========模块主页面===========================================