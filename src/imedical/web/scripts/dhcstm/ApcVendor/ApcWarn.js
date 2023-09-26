// 名称:供应商资质报警
// 编写日期:2013-05-10
//ApcWarn.js

var currVendorRowId='';
var gUserId = session['LOGON.USERID'];
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];

var defaultWarnMonths=3;
// 合同起始日期
var StartDate = new Ext.ux.DateField({
			fieldLabel : '合同起始日期',
			id : 'StartDate',
			name : 'StartDate',
			anchor : '90%',
			width : 100,
			value : new Date().add(Date.MONTH,-1),
			hidden:true
		});

// 截止日期
var EndDate = new Ext.ux.DateField({
			fieldLabel : '合同截止日期',
			id : 'EndDate',
			name : 'EndDate',
			anchor : '90%',
			value : new Date(),
			hidden:true
		});
// 资质截止日期
var ZEndDate = new Ext.ux.DateField({
			fieldLabel : '资质报警截止日期',
			id : 'ZEndDate',
			name : 'ZEndDate',
			value : new Date()
		});


var Months=new Ext.form.ComboBox({
		id:'Months',
		fieldLabel:'资质报警月数',
		anchor : '90%',
		 triggerAction: 'all',
		mode: 'local',
		editable:false,
		store:new Ext.data.ArrayStore({
	        id: 0,
	        fields: [
	            'Months',
	            'MonthDesc'
	        ],
	        data: [[1,'1月'],[2,'2月'],[3,'3月'],[4,'4月'],
						[5,'5月'],[6,'6月'],[7,'7月'],[8,'8月'],[9,'9月'],[10,'10月'],[11,'11月'],[12,'12月']]
		}),
	    valueField: 'Months',
    	displayField: 'MonthDesc',
		listeners:{
			'select':function(c){
				setMonthNum(c.getValue());
			}
		}
	
	});		
	
		
var findAPCVendor = new Ext.Toolbar.Button({
	text:'查询',
	tooltip:'查询',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		Query()
	}
});

//查看资质图片
var findpicAPCVendor = new Ext.Toolbar.Button({
	text:'查看资质图片',
	tooltip:'查看资质图片',
	iconCls:'page_edit',
	width : 70,
	height : 30,
	handler:function(){
		var rowObj = APCVendorWarnGrid.getSelectionModel().getSelections(); 
		var len = rowObj.length;
		if(len < 1){
			Msg.info("error","请选择供应商!");
			return false;
		}else{
			currVendorRowId = rowObj[0].get('apcdr');
			var PicUrl = 'dhcstm.apcvendoraction.csp?actiontype=GetPic';
			// 通过AJAX方式调用后台数据
			var proxy = new Ext.data.HttpProxy({
						url : PicUrl,
						method : "POST"
					});
			// 指定列参数
			var fields = ["rowid","venid","vendesc","picsrc","type"];
			// 支持分页显示的读取方式
			var reader = new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : "results",
						id : "rowid",
						fields : fields
					});
			// 数据集
			var PicStore = new Ext.data.Store({
						proxy : proxy,
						reader : reader
					});
			ShowwarnPicWindow(PicStore);
		}
	}
});

//模型
var nm = new Ext.grid.RowNumberer();
var APCVendorWarnGridCm = new Ext.grid.ColumnModel([nm,{
		header : "apcdr",
		dataIndex : 'apcdr',
		width : 160,
		align : 'left',
		sortable : true,
		hidden : true
	},{
		header : "供应商代码",
		dataIndex : 'ApcvmCode',
		width : 160,
		align : 'left',
		sortable : true
	},{
		header : "供应商名称",
		dataIndex : 'ApcvmName',
		width : 280,
		align : 'left',
		sortable : true
	},{
		header : "合同截止日期",
		dataIndex : 'LstPoDate',
		width : 180,
		align : 'left',
		sortable : true
	},{
		header : "库存项",
		dataIndex : 'IncItm',
		width : 180,
		align : 'left',
		sortable : true,
		hidden:true
	},{	
		header : "物资名称",
		dataIndex : 'MDesc',
		width : 280,
		align : 'left',
		sortable : true
	},{
		header : "厂商",
		dataIndex : 'PhManf',
		width : 280,
		align : 'left',
		sortable : true
	}
]);

//初始化默认排序功能
APCVendorWarnGridCm.defaultSortable = true;

// 访问路径
var DetailUrl =DictUrl+
	'apcwarnaction.csp?actiontype=Query';
// 通过AJAX方式调用后台数据
var proxy = new Ext.data.HttpProxy({
			url : DetailUrl,
			method : "POST"
		});

// 指定列参数{name:'LstPoDate',type:'date',dateFormat:DateFormat}
var fields = ["apcdr", "ApcvmCode", "ApcvmName","LstPoDate","IncItm","MDesc","PhManf","slist"];

// 支持分页显示的读取方式
var reader = new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			id : "slist",
			fields : fields
		});
// 数据集
var APCVendorWarnGridDs = new Ext.data.Store({
			proxy : proxy,
			reader : reader
		});

//查询函数
function Query(){
	var StartDate=Ext.getCmp("StartDate").getValue();
	if(StartDate==""){
		Msg.info("warning","起始日期不可为空!");
		return;
	}else{
		StartDate = StartDate.format(ARG_DATEFORMAT).toString();
	}
	var EndDate=Ext.getCmp("EndDate").getValue();
	if(EndDate==""){
		Msg.info("warning","截止日期不可为空!");
		return;
	}else{
		EndDate = EndDate.format(ARG_DATEFORMAT).toString();
	}	
	if(StartDate > EndDate){
		Msg.info("warning", "开始日期大于截止日期!");
		return;
	}
	var ZEndDate=Ext.getCmp("ZEndDate").getValue();
	if(ZEndDate==""){
		Msg.info("warning","资质截止日期不可为空!");
		return;
	}else{
		ZEndDate = ZEndDate.format(ARG_DATEFORMAT).toString();
	}
	List=StartDate+"^"+EndDate+"^"+ZEndDate;
	APCVendorWarnGridDs.setBaseParam('List',List);
	APCVendorWarnGridDs.load({
		params:{start:0,limit:APCVendorPagingToolbar.pageSize},
		callback : function(r,options,success){
			if(!success){
				Msg.info("error","查询有误,请查看日志!");
			}
		}
	});
}

//弹出窗口
var editAPCVendor = new Ext.Toolbar.Button({
	text:'编辑',
	tooltip:'编辑',
	iconCls:'page_edit',
	width : 70,
	height : 30,
	handler:function(){
		//alert(33)
		var rowObj = APCVendorWarnGrid.getSelectionModel().getSelections(); 
		var len = rowObj.length;
		if(len < 1){
			Msg.info("error","请选择数据!");
			return false;
		}else{
			var rowid = rowObj[0].get('apcdr');
			//窗口显示
			CreateEditWin(rowid);
		}
	}
});

function CreateEditWin(rowid){
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
		anchor:'90%'  
		//emptyText:'合同截止日期 ...'
	});
	
	//业务员证书有效期
	var validDate = new Ext.ux.DateField({ 
		id:'validDate',
		fieldLabel:'证书有效期',  
		allowBlank:true   
		//emptyText:'证书有效期 ...'
	});
	
	//业务员电话
	var phoneField = new Ext.form.TextField({ 
		id:'phoneField',
		fieldLabel:'业务员电话',  
		allowBlank:true,
		anchor : '90%'   
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
		anchor : '90%',
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
		//emptyText:'有效期 ...'
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
		//emptyText:'有效期 ...'
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
		//emptyText:'有效期 ...'
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
		//emptyText:'有效期 ...'
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
		//emptyText:'有效期 ...'
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
		//emptyText:'有效期 ...'
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
		//emptyText:'有效期 ...'
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
		//emptyText:'有效期 ...'
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
		//emptyText:'有效期 ...'
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
		anchor : '90%'
	});
	
	//进口注册登记表
	var inletRegLicField = new Ext.form.TextField({
		id:'inletRegLicField',
		fieldLabel:'进口注册登记表',
		allowBlank:true,
		//emptyText:'进口注册登记表...',
		anchor:'90%',
		selectOnFocus:true
	});

	//进口注册登记表有效期
	var inletRegLicValidDate = new Ext.ux.DateField({
		id:'inletRegLicValidDate',
		fieldLabel:'有效期',
		allowBlank:true
	});
	
	//进口注册证
	var inletRLicField = new Ext.form.TextField({
		id:'inletRLicField',
		fieldLabel:'进口注册证',
		allowBlank:true,
		//emptyText:'进口注册证...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//进口注册证有效期
	var inletRLicValidDate = new Ext.ux.DateField({
		id:'inletRLicValidDate',
		fieldLabel:'有效期',
		allowBlank:true,
		anchor : '90%'
		//emptyText:'有效期 ...'
	});

	//初始化面板
	var vendorPanel = new Ext.form.FormPanel({
		labelAlign : 'right',
		frame : true,
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
	var window = new Ext.Window({
		title:'供应商信息',
		width:900,
		height:550,
		minWidth:700,
		minHeight:550,
		layout:'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'right',
		items:vendorPanel,
		listeners:{
			'show':function(){
				if (rowid!='') {SetVendorInfo(rowid);}
			}
		}
	});
	
	window.show();
	
	//显示供应商信息
	function SetVendorInfo(rowid){
		var APCVendorGridUrl='dhcstm.apcvendoraction.csp';
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
				}
			},
			scope: this
		});
	}}
//弹出窗口
var formPanel = new Ext.ux.FormPanel({
	title:'供应商资质报警',
	tbar:[findAPCVendor,'-',findpicAPCVendor],
	items : [{
		xtype : 'fieldset',
		title : '查询条件',
		layout : 'column',
		style : 'padding:5px 0px 0px 5px',
		defaults:{border:false,xtype:'fieldset'},
		items : [{
				columnWidth : .01,
				items : [StartDate]
			},{
				columnWidth : .01,
				items : [EndDate]
			},{
				columnWidth : .25,
				labelWidth:100,
				items : [Months]
			},{
				columnWidth : .4,
				labelWidth:150,
				items : [ZEndDate]
			}]
	}]
});

//分页工具栏
var APCVendorPagingToolbar = new Ext.PagingToolbar({
	store:APCVendorWarnGridDs,
	pageSize:PageSize,
	displayInfo:true
});

//表格
APCVendorWarnGrid = new Ext.grid.EditorGridPanel({
	store:APCVendorWarnGridDs,
	cm:APCVendorWarnGridCm,
	title:'资质不符合条件供应商列表',
	trackMouseOver:true,
	clicksToEdit:0,
	region:'center',
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
	//sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	bbar:APCVendorPagingToolbar,
	listeners:{
		'rowdblclick':function(){
			editAPCVendor.handler();
		}
	}
});

function setMonthNum(m)
{
	 var today=new Date();
	 var dd=today.add(Date.MONTH, m);
	 Ext.getCmp('ZEndDate').setValue(dd);
}
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,APCVendorWarnGrid],
		renderTo:'mainPanel',
	    listeners:{
			'afterrender':function(){
				Ext.getCmp('Months').setValue(defaultWarnMonths);	
				setMonthNum(defaultWarnMonths);
			}
		}
	});
	

});