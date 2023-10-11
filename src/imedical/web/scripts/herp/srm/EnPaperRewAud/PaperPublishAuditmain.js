var projUrl='herp.srm.SRMEnPaperRewAudexe.csp';
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
/**
Ext.Ajax.request({
						url:projUrl+'?action=GetUserID&userdr='+userdr,
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success=='NoOne!'){
								Ext.Msg.show({title:'错误',msg:'您没有权限审核！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
**/
///////////////////年/////////////////////////////  
var YearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


YearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetYear&str='+encodeURIComponent(Ext.getCmp('YearField').getRawValue()),method:'POST'});
});

var YearField = new Ext.form.ComboBox({
	id: 'YearField',
	fieldLabel: '年',
	width:120,
	listWidth : 260,
	allowBlank : true, 
	store:YearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	anchor: '95%',
	////emptyText:'请选择开始时间...',
	name: 'YearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

/////////////////开始时间///////////////////////
var StartDateField = new Ext.form.DateField({
			fieldLabel: '开始时间',
			width:120,
			allowBlank:false,
			//format:'Y-m-d',
			//columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});

/////////////////结束时间///////////////////////		
var EndDateField = new Ext.form.DateField({
			fieldLabel: '结束时间',
			width:120,
			allowBlank:false,
			//format:'Y-m-d',
			//columnWidth : .12,	
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});

/////////////////科室//////////////////

var DeptDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


DeptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetDept&str='+encodeURIComponent(Ext.getCmp('DeptField').getRawValue()),
	method:'POST'});
});

var DeptField = new Ext.form.ComboBox({
	id: 'DeptField',
	fieldLabel: '科室',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:DeptDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择科室...',
	name: 'DeptField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

/////////////////论文题目///////////////////
var PaperName = new Ext.form.TextField({
                width: 120,
                allowBlank: true,
                name: 'PaperName',
                fieldLabel: '论文题目',
                blankText: '请输入论文题目'
            });

/////////////////期刊名称///////////////////

var JournalNameDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


JournalNameDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetJournalDict&str='+encodeURIComponent(Ext.getCmp('JournalName').getRawValue()),method:'POST'});
});

var JournalName = new Ext.form.ComboBox({
	id: 'JournalName',
	fieldLabel: '期刊名称',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:JournalNameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择期刊名称...',
	name: 'JournalName',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});




/////////////////作者///////////////////
var FisAuthorDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


FisAuthorDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetAuthor&str='+encodeURIComponent(Ext.getCmp('FisAuthor').getRawValue()),
	method:'POST'});
});

var FisAuthorField = new Ext.form.ComboBox({
	id: 'FisAuthor',
	fieldLabel: '作者',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:FisAuthorDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择作者...',
	name: 'FisAuthor',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

/////////////////第一通讯作者///////////////////////////
var ComAuthorDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


ComAuthorDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetAuthor&str='+encodeURIComponent(Ext.getCmp('ComAuthor').getRawValue()),
	method:'POST'});
});

var ComAuthorField = new Ext.form.ComboBox({
	id: 'ComAuthor',
	fieldLabel: '第一通讯作者',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:ComAuthorDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择第一通讯作者...',
	name: 'ComAuthor',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

/////////////////审核结果///////////////////////////
var AuditStateStore = new Ext.data.SimpleStore({
	fields:['key','keyvalue'],
	data:[['1','等待审批'],['2','已通过'],['3','未通过']]
});

var AuditStateField = new Ext.form.ComboBox({
	id: 'AuditState',
	fieldLabel: '审核结果',
	width:120,
	listWidth : 120,
	allowBlank: true,
	store:AuditStateStore,
	valueField: 'key',
	displayField: 'keyvalue',
	triggerAction: 'all',
	//emptyText:'请选择审核结果...',
	mode : 'local',
	name: 'AuditState',
	minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});
///////////////////类型/////////////////////////////  
var TypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '科研'],['2', '教学']]
	});		
		
var TypeCombox = new Ext.form.ComboBox({
	                   id : 'TypeCombox',
		           fieldLabel : '类型',
	                   width : 120,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : TypeDs,
		           anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true
						  });	
/////////////////查询按钮响应函数//////////////
function SearchFun()
{
	var StartDate= StartDateField.getRawValue();
	var EndDate  = EndDateField.getRawValue();
    var Dept      = DeptField.getValue();
    var PaperNames= PaperName.getValue();
    var JournalNames= JournalName.getRawValue();
    var FisAuthor = FisAuthorField.getValue();
    var ComAuthor = ComAuthorField.getValue();
	var AuditState = AuditStateField.getValue();
	var type = TypeCombox.getValue();
    JournalNames=JournalNames.trim();
    var Year = YearField.getValue();
    itemGrid.load({params:{start:0,limit:25,sortField:'',sortDir:'',
	StartDate:StartDate,EndDate:EndDate,Dept:Dept,PaperNames:PaperNames,
	JournalNames:JournalNames,FisAuthor:FisAuthor,ComAuthor:ComAuthor,
	AuditState:AuditState,userdr:userdr,Type:type,Year:Year}});
	
}

//////////////////////////////////////////////
var queryPanel = new Ext.FormPanel({
	autoHeight : true,
	title : '论文报销与奖励审核信息查询',
	iconCls : 'search',	
	region : 'north',
	frame : true,

	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">类型</p>',
					width : 60			
				},	
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				TypeCombox,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">年度</p>',
					width : 30			
				},	
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				YearField,
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">论文题目</p>',
					width : 80			
				},	
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				PaperName,
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">期刊名称</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				JournalName,
				{
					xtype : 'displayfield',
					value : '',
					width : 30
				},
				{
					xtype : 'button',
					text : '查询',
					handler : function(b){SearchFun();},
					iconCls : 'search',
					width : 30
				}
				
				]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">科室</p>',
					width : 60			
				},	
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				DeptField,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">作者</p>',
					width : 30			
				},	
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				FisAuthorField,
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">第一通讯作者</p>',
					width : 80			
				},	
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				ComAuthorField,
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">审核结果</p>',
					width : 60			
				},	
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				AuditStateField
	
				]
	},{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
		
		
		
		
		
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">申请日期</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				StartDateField,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:center;">至</p>',
					width : 30			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				EndDateField,
				{
					xtype : 'displayfield',
					value : '',
					width : 30
				}]
	}]
	
});

/////////////////奖励时间///////////////////////
var RewardDateField = new Ext.form.DateField({
	        id: 'RewardDateField',
			fieldLabel: '奖励时间',
			width:120,
			allowBlank:false,
			//format:'Y-m-d',
			//columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});


////////////////////报销比例/////////////////////////////

var RatioStore = new Ext.data.SimpleStore({
	fields:['key','keyvalue'],
	data:[['0','0'],['0.3','30%'],['0.7','70%'],['1','100%']]
});

var RatioField = new Ext.form.ComboBox({
	id: 'RatioField',
	fieldLabel: '报销比例',
	width:120,
	//anchor: '95%',
	listWidth : 120,
	allowBlank: true,
	store:RatioStore,
	valueField: 'key',
	displayField: 'keyvalue',
	value:'R',
	triggerAction: 'all',
	//emptyText:'请选择报销比例...',
	mode : 'local',
	name: 'RatioField',
	minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});


//////////////////////////////////////////////

var itemGrid = new dhc.herp.Grid({
			region : 'center',
			title: '论文报销与奖励审核信息列表',
			iconCls: 'list',
			url : projUrl,
			sortInfo: {
             field: 'Title',
             direction: "ASC"
            },
            remoteSort: true, //服务器端排序		
			/* listeners:{
	        'cellclick' : function(grid, rowIndex, columnIndex, e) {
	               var record = grid.getStore().getAt(rowIndex);
	               //if (((record.get('CheckState') != '等待审批') &&(columnIndex == 30))||((record.get('IsReward') != '未奖励') &&(columnIndex == 32))||((record.get('IsReward') != '未奖励') &&(columnIndex == 33))) {  
	                if ((record.get('CheckState') != '等待审批') &&(columnIndex == 30)) {      
	                      Ext.Msg.show({title:'注意',msg:'已审核,不能修改!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
	                      return false;
	               }else{
	                      return true;
	               }
	        }},    */   
	        		
			fields : [
			 new Ext.grid.CheckboxSelectionModel({editable:false}),
			{
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
						id : 'Type',
						header : '类型',
						width : 40,
						editable:false,
						//hidden:true,
						dataIndex : 'Type'
					},{
						id : 'RecordType',
						header : '被收录数据库',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'RecordType'
					},{
						id : 'JourLevel',
						header : '期刊级别',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'JourLevel'
					},{
						id : 'JName',
						header : ' 期刊名称',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'JName'
					},{
						id : 'PaperType',
						header : '论文类别 ',
						width : 120,
						editable:false,
						hidden:true,
						allowBlank : false,                
						dataIndex : 'PaperType'
					},{
						id : 'Title',
						header : '论文题目',
						width : 180,
						editable:false,
						sortable:true,
						allowBlank : false, 
						/*						
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						},
						*/
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+data+'</span>';;
						},						
						dataIndex : 'Title'
					},{
						id : 'CompleteUnit',
						header : '我院单位位次',
						width : 80,
						editable:false,
						allowBlank : false,
						dataIndex : 'CompleteUnit'
					},{
						id : 'RegInfo',
						header : ' 年卷期页',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'RegInfo'
					},{
						id : 'PubYear',
						header : '年',
						//xtype:'numbercolumn',
						width : 120,
						editable : false,
						align:'right',
						hidden:true,
						dataIndex : 'PubYear'
					},{
						id : 'Roll',
						header : '卷',
						//xtype:'numbercolumn',
						width : 120,
						editable : false,
						align:'right',
						hidden:true,
						dataIndex : 'Roll'
					},{
						id : 'Period',
						header : '期',
						//xtype:'numbercolumn',
						width : 120,
						editable : false,
						align:'right',
						hidden:true,
						dataIndex : 'Period'
					},{
						id : 'StartPage',
						header : '起始页',
						//xtype:'numbercolumn',
						hidden:true,
						width : 120,
						editable : false,
						align:'right',
						dataIndex : 'StartPage'
					},{
						id : 'EndPage',
						header : '结束页',
						//xtype:'numbercolumn',
						hidden:true,
						width : 120,
						editable : false,
						align:'right',
						dataIndex : 'EndPage'
					},{
						id : 'FristAuthor',
						header : ' 第一作者',
						//xtype:'numbercolumn',
						width : 80,
						editable : false,
						sortable:true,
						align:'left',
						dataIndex : 'FristAuthor'
					}, {
						id : 'FristAuthorRange',
						header : '第一作者排名',
						//xtype:'numbercolumn',
						width : 120,
						editable : false,
						align:'right',
						hidden:true,
						dataIndex : 'FristAuthorRange'
					},{
						id : 'FristAuthorDept',
						header : ' 第一作者科室',
						//xtype:'numbercolumn',
						width : 120,
						editable : false,
						align:'right',
						hidden:true,
						dataIndex : 'FristAuthorDept'
					}, {
						id : 'FristAuthorComp',
						header : '第一作者单位',
						width : 120,
						align:'right',
						editable:false,
						hidden:true,
						dataIndex : 'FristAuthorComp'
					},{
						id : 'CorrAuthor',
						header : '第一通讯作者',
						editable:false,
						width : 80,
						dataIndex : 'CorrAuthor'
					},{
						id : 'CorrAuthorRange',
						header : '通讯作者排名',
						editable:false,
						width : 120,
						align:'right',
						hidden:true,
						dataIndex : 'CorrAuthorRange'
					},{
						id : 'CorrAuthorDept',
						header : '第一通讯作科室',
						editable:false,
						width : 120,
						align:'right',
						hidden:true,
						dataIndex : 'CorrAuthorDept'
					},{
						id : 'CorrAuthorComp',
						header : '通讯作者单位',
						editable:false,
						width : 120,
						hidden:true,
						align:'right',
						dataIndex : 'CorrAuthorComp'
					},{
						id : 'AllAuthorInfo',
						header : '论文作者',
						editable:false,
						width : 60,
						hidden:false,
						
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						},
						
						
						dataIndex : 'AllAuthorInfo'
					},{
						id : 'AllCorrAuthorInfo',
						header : '论文通讯作者',
						editable:false,
						width : 80,
						hidden:false,
						
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						},
						
						
						dataIndex : 'AllCorrAuthorInfo'
					},{
						id : 'IF',
						header : '影响因子',
						hidden:false,
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'IF'
					},{
						id : 'InvoiceCode',
						header : '发票代码 ',
						width : 120,
						editable:false,
						hidden:true,
						allowBlank : false,                
						dataIndex : 'InvoiceCode'
					},{
						id : 'InvoiceNo',
						header : '发票号码 ',
						width : 120,
						editable:false,
						hidden:true,
						allowBlank : false,                
						dataIndex : 'InvoiceNo'
					},{
						id : 'PageCharge',
						header : '版面费(元)',
						editable:false,
						width : 100,
						align:'right',
						sortable:true,	
						dataIndex : 'PageCharge',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
					},{
						id : 'UnitMoney',
						header : '货币单位',
						editable:false,
						width : 60,
						dataIndex : 'UnitMoney'
					},{
						id : 'Ratio',
						header : '报销比例',
						editable:true,
						//hidden:true,
						width : 80,
						align:'right',
						dataIndex : 'Ratio',
						type:RatioField
					},{
						id : 'REAmount',
						header : '报销版面费(元)',
						editable:false,
						width : 100,
						align:'right',
						dataIndex : 'REAmount',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
					},{
						id : 'RewardAmount',
						header : '奖励金额(元)',
						editable:true,
						width : 100,
						align:'right',
						dataIndex : 'RewardAmount',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
					},{
						id : 'RewardDate',
						header : '奖励时间',
						editable:true,
						width : 80,
						dataIndex : 'RewardDate',
						type:RewardDateField,
						renderer : function(v, p, r, i) {			
						if (v instanceof Date) {
							return new Date(v).format("Y-m-d");
						} else {return v;}
			          }
			         },{
						id : 'IsReward',
						header : '是否奖励',
						editable:false,
						hidden:true,
						//format:'Y-m-d',
						width : 60,
						dataIndex : 'IsReward'
					},{
						id : 'SubUser',
						header : '申请人',
						editable:false,
						width : 60,
						dataIndex : 'SubUser'
					},{
						id : 'DeptName',
						header : '申请人科室',
						editable:false,
						width : 120,
						dataIndex : 'DeptName',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					},{
						id : 'SubDate',
						header : '申请时间',
						hidden:false,
						editable:false,
						width : 80,
						dataIndex : 'SubDate'
					},{
						id : 'DataStatus',
						header : '提交状态',
						editable:false,
						hidden:true,
						width : 120,
						dataIndex : 'DataStatus'
					},{
						id : 'Chercker',
						header : '审批人',
						editable:false,
						width : 60,
						dataIndex : 'Chercker'
					},{
						id : 'CheckDept',
						header : '审批人科室',
						editable:false,
						hidden:true,
						width : 120,
						dataIndex : 'CheckDept'
					},{
						id : 'CheckDate',
						header : '审批时间',
						editable:false,
						width : 80,
						dataIndex : 'CheckDate'
					},{
						id : 'CheckState',
						header : '审批状态',
						editable:false,
						hidden:true,
						width : 120,
						dataIndex : 'CheckState'  
					},{
						id : 'CheckProcDesc',
						header : '审批结果',
						editable:false,
						width : 100,
						dataIndex : 'CheckProcDesc'  
					},{
						id : 'Desc',
						header : '审批意见',
						editable:false,
						width : 100,
						dataIndex : 'Desc'
					},{
						id : 'AuthorsInfo',
						header : '作者排名',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'AuthorsInfo'
					},{
						id : 'CorrAuthorsInfo',
						header : '通讯作者排名',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'CorrAuthorsInfo'
					},{
							id:'download',
							header: '原文',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>下载</u></span>';
					    } 
					},{
							id:'download1',
							header: '收录证明',
							allowBlank: false,
							width:60,
							editable:false,
							dataIndex: 'download',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>下载</u></span>';
					    } 
					},{
							id:'ESICited',
							header: '是否ESI高被引',
							allowBlank: false,
							width:40,
							editable:false,
							hidden:true,
							dataIndex: 'ESICited'
					},{
							id:'IsLastStep',
							header: '是否最后审批步骤',
							allowBlank: false,
							width:40,
							editable:false,
							hidden:true,
							dataIndex: 'IsLastStep'
					}]
		});

var AuditButton  = new Ext.Toolbar.Button({
		text: '报销审核通过',  
        id:'auditButton', 
        iconCls: 'pencil',
        handler:function(){
			
		//定义并初始化行对象
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		var checker = session['LOGON.USERCODE'];
		var CheckDesc= rowObj[0].get("CheckDesc")
		
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		for(var j= 0; j < len; j++){
		 if(rowObj[j].get("CheckState")!="等待审批")
		 {
			      Ext.Msg.show({title:'注意',msg:'数据已审核',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					
					
					  var Ratio=rowObj[i].get("Ratio");
					  var tmpIsLastStep=rowObj[i].get("IsLastStep");
					   
					  //if((Ratio=="")&&(rowObj[i].get("CheckProcDesc").indexOf("科研处主任")>-1))   科研处主任审核时确定报销比例
					  if((Ratio=="")&&(tmpIsLastStep=="Y"))
					  {
						Ext.Msg.show({title:'注意',msg:'请选择报销比例',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					  }
							
					    Ext.Ajax.request({
						url:projUrl+'?action=audit&rowid='+rowObj[i].get("rowid")+'&checker='+checker+'&Ratio='+Ratio,
						waitMsg:'审核中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0,limit:12,userdr:userdr}});
								
							}else{
								Ext.Msg.show({title:'错误',msg:'审核失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要审核该条记录吗?',handler);
    }
});


  var NoAuditButton = new Ext.Toolbar.Button({
					text : '不通过',
					iconCls: 'pencil',
					handler : function() {
						var rowObj=itemGrid.getSelectionModel().getSelections();
						var len = rowObj.length;
						if(len < 1){
							Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						}
						for(var j= 0; j < len; j++){
							 if(rowObj[j].get("CheckState")!="等待审批")
							 {
								      Ext.Msg.show({title:'注意',msg:'数据已审核',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
								       return;
							 }
						}
						noauditfun();
				   }
  });
  
  var RewardAuditButton  = new Ext.Toolbar.Button({
		text: '奖励审核',  
        id:'RewardAuditButton', 
        iconCls: 'pencil',
        handler:function(){
			
		//定义并初始化行对象
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		var checker = session['LOGON.USERCODE'];

		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		
		
     for(var j= 0; j < len; j++){
	     
	      var RewardState= rowObj[j].get("IsReward")
		   if(rowObj[j].get("IsReward")=="已奖励")
		   { 
			      Ext.Msg.show({title:'注意',msg:'数据已奖励！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		    }
		    
		    var RewardAmount = rowObj[j].get("RewardAmount")   
		 	  if(rowObj[j].get("RewardAmount")==""){
			     Ext.Msg.show({title:'注意',msg:'请填写奖励金额!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			     return;
		    }
		    
		   var aaa=rowObj[j].get("CheckProcDesc");
		  
		    if((aaa.indexOf("等待审批")>0)||(aaa.indexOf("不通过")>0))
		  {
			     Ext.Msg.show({title:'注意',msg:'数据未审核不能发放奖励!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			     return;
		    }
		    
		      var RewardDate=rowObj[j].get("RewardDate");
				 if(RewardDate=="")
				 {
								     Ext.Msg.show({title:'注意',msg:'请选择奖励时间',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
								     return;
				 }
					 
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					  var RewardAmount = rowObj[i].get("RewardAmount")   
					     var RewardDate=rowObj[i].get("RewardDate");
					
					      if(rowObj[i].isModified("RewardDate")){
						 
						  var RewardDate=RewardDate.format('Y-m-d');
						  
						  } 
					  Ext.Ajax.request({
						url:projUrl+'?action=rewardaudit&&rowid='+rowObj[i].get("rowid")+'&RewardAmount='+RewardAmount+'&checker='+checker+'&RewardDate='+RewardDate,
						waitMsg:'审核中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0,limit:12,userdr:userdr}});
								
							}else{
								Ext.Msg.show({title:'错误',msg:'审核失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要审核该条记录吗?',handler);
    }
});

  itemGrid.addButton('-');
  itemGrid.addButton(AuditButton);
  itemGrid.addButton('-');
  itemGrid.addButton(NoAuditButton);  
  itemGrid.addButton('-');
  itemGrid.addButton(RewardAuditButton);
  
  itemGrid.btnResetHide(); 	//隐藏重置按钮
  itemGrid.btnDeleteHide(); //隐藏删除按钮
  itemGrid.btnPrintHide(); 	//隐藏打印按钮
  itemGrid.btnAddHide(); 	//隐藏添加按钮
  itemGrid.btnSaveHide(); 	//隐藏保存按钮
 
  itemGrid.load({params:{start:0, limit:25, userdr:userdr}});
  
  
  // 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	
	//  论文题目
	if (columnIndex == 8) {
		PaperDetail(itemGrid);
	}
	//作者排名
	if (columnIndex == 24) {
		var records = itemGrid.getSelectionModel().getSelections();
		var authorinfo = records[0].get("AuthorsInfo");
		var corrauthorinfo = records[0].get("CorrAuthorsInfo");
		var title = records[0].get("Title");
		//alert(authorinfo);
		AuthorInfoList(title,authorinfo);
	}
	//通讯作者排名
	if (columnIndex == 25) {
		var records = itemGrid.getSelectionModel().getSelections();
		var corrauthorinfo = records[0].get("CorrAuthorsInfo");
		var title = records[0].get("Title");
		//alert(authorinfo);
		CorrAuthorInfoList(title,corrauthorinfo);
	}
	
	
	
	var records = itemGrid.getSelectionModel().getSelections();
	var state = records[0].get("CheckState");
	
	if(state!="通过")
	{
	  RewardAuditButton.disable();//设置为不可用
	  return;
	}else{
	   RewardAuditButton.enable();//设置为可用
	  return;
	}
	
});

//uploadMainFun(itemGrid,'rowid','P001',22);
//downloadMainFun(itemGrid,'rowid','P002',46);
downloadMainFun(itemGrid,'rowid','P00201',48);
downloadMainFun(itemGrid,'rowid','P00202',49);