
var userdr = session['LOGON.USERCODE'];

var groupdesc = session['LOGON.GROUPDESC'];
if (groupdesc=="科研管理系统(信息修改)")
{  userdr=""
	}
if (groupdesc=="科研管理系统(信息查询)")
{  userdr=""
	}

var projUrl = 'herp.srm.SRMEnPaperPubRegexe.csp';

// 定义起始时间控件
	var startDate = new Ext.form.DateField({
		  id:'startDate',
		  fieldLabel: '开始日期',
			width:120,
			//format:'Y-m-d',
			//columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
	});
	var endDate = new Ext.form.DateField({
		  id:'endDate',
		  fieldLabel: '结束日期',
			width:120,
			//format:'Y-m-d',
			//columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
	});
/////////////////开始时间////////////////////////////
var StartdDateField = new Ext.form.DateField({
		id : 'StartdDateField',
		//format : 'Y-m-d',
		fieldLabel:'开始日期',
		width : 120,
		editable:true
		//emptyText : '请选择开始日期...'
	});

/////////////////结束时间////////////////////////////
var EnddDateField = new Ext.form.DateField({
		id : 'EnddDateField',
		//format : 'Y-m-d',
		fieldLabel:'结束日期',
		width : 120,
		editable:true
		//emptyText : '请选择结束日期...'
	});
//md.formatDate(searchContractDate.getValue())


/////////////////科室////////////////////////
var DeptDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


DeptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetDept&str='+encodeURIComponent(Ext.getCmp('DeptField').getRawValue()),method:'POST'});
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
	forceSelection:true,
	editable:true
});


/////////////////论文题目
var PaperName = new Ext.form.TextField({
                width: 120,
                allowBlank: true,
                name: 'PaperName',
                fieldLabel: '论文题目',
                blankText: '请输入论文题目'
            });


/////////////////期刊名称
var PeriodiNamDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

PeriodiNamDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetJournalDict&str='+encodeURIComponent(Ext.getCmp('PeriodiNam').getRawValue()),method:'POST'});
});

var PeriodiNam = new Ext.form.ComboBox({
	id: 'PeriodiNam',
	fieldLabel: '期刊名称',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:PeriodiNamDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择期刊名称...',
	name: 'PeriodiNam',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});

/////////////////第一作者
var FisAuthorDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

FisAuthorDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetAuthor&str='+encodeURIComponent(Ext.getCmp('FisAuthor').getRawValue()),method:'POST'});
});

var FisAuthorField = new Ext.form.ComboBox({
	id: 'FisAuthor',
	fieldLabel: '第一作者',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:FisAuthorDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择第一作者...',
	name: 'FisAuthor',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});

/////////////////通讯作者
var ComAuthorDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


ComAuthorDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetAuthor&str='+encodeURIComponent(Ext.getCmp('ComAuthor').getRawValue()),method:'POST'});
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

	var startTime= startDate.getRawValue();
	if (startTime!=="")
    {
       //startTime=startTime.format ('Y-m-d');
    }
	var endTime  = endDate.getRawValue();
	if (endTime!=="")
    {
       //endTime=endTime.format ('Y-m-d');
    }
        var Dept      = DeptField.getValue();
        var PaperNames= PaperName.getValue();
        var PeriodiNams= PeriodiNam.getRawValue();  
        var FisAuthor = FisAuthorField.getValue();
        var ComAuthor = ComAuthorField.getValue();
		    var type = TypeCombox.getValue();
		     

		    if ((groupdesc=="科研管理系统(信息修改)")||(groupdesc=="科研管理系统(信息查询)"))
      {  userdr=""
	    }
	

        var data = startTime+"|"+endTime+"|"+Dept+"|"+PaperNames+"|"+PeriodiNams+"|"+FisAuthor+"|"+ComAuthor+"|"+userdr+"|"+type;

        itemGrid.load({params:{data:data,sortField:'',sortDir:'',start:0,limit:25}});      
}

//////////////////////////////////////////////
var queryPanel = new Ext.FormPanel({
	title: '论文报销与奖励申请信息查询',iconCls: 'search',
	autoHeight : true,
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
					width : 30			
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
					value : '<p style="text-align:right;">论文题目</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				PaperName,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
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
				startDate,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:center;">至</p>',
					width : 90			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				endDate,
				{
					xtype : 'displayfield',
					value : '',
					width : 30
				},
				{
					width : 30,
					xtype:'button',
					text: '查询',
					handler:function(b){SearchFun();},
					iconCls : 'search'
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
					width : 30			
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
					value : '<p style="text-align:right;">期刊名称</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				PeriodiNam,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">第一作者</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				FisAuthorField,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">第一通讯作者</p>',
					width : 90			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				ComAuthorField
			
				]
	}]
	
});

var itemGrid = new dhc.herp.Grid({
	title: '论文报销与奖励申请信息列表',iconCls: 'list',
			region : 'center',
			url : projUrl,	
			//atLoad:true,        
			 sortInfo: {
             field: 'Title',
             direction: "ASC"
             },
            remoteSort: true, //服务器端排序
			fields : [
			new Ext.grid.CheckboxSelectionModel(
			{    hidden : true,
				editable:false
				
				}
			
			),
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
						header : '期刊类型',
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
						header : '论文题目 ',
						sortable:true,
						width : 180,
						editable:false,
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
							return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+data+'</span>';
						},
						dataIndex : 'Title'
					},{
						id : 'CompleteUnit',
						header : '第几完成单位 ',
						width : 100,
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
						width : 60,
						editable : false,
						align:'left',
						dataIndex : 'FristAuthor'
					}, {
							id:'upload',
							header: '原文',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){			
							return '<span style="color:blue"><u>上传</u></span>';
							}
					}, {
							id:'upload1',
							header: '收录证明',
							allowBlank: false,
							width:60,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){			
							return '<span style="color:blue"><u>上传</u></span>';
							}
					},{
							id:'download',
							header: '附件',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							renderer : function(v, p, r){
								//alert(itemGrid1);
							return '<span style="color:blue"><u>下载</u></span>';
							//return '<span style="color:gray;cursor:hand">审核</span>';
					    } 
					},{
						id : 'DataStatus',
						header : '提交状态',
						editable:false,
						hidden:false,
						width : 60,
						dataIndex : 'DataStatus'
					},{
						id : 'CheckState',
						header : '审批状态',
						editable:false,
						width : 100,
						dataIndex : 'CheckState'
					},{
						id : 'Desc',
						header : '审批意见',
						editable:false,
						width : 100,
						dataIndex : 'Desc'
					},{
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
						editable:false,
						//hidden:true,
						width : 80,
						align:'right',
						dataIndex : 'Ratio'
					},{
						id : 'REAmount',
						header : '实报版面费(元)',
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
						editable:false,
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
						id : 'SubUser',
						header : '申请人',
						editable:false,
						width : 60,
						dataIndex : 'SubUser',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
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
					}, {
							id:'ESICited',
							header: '是否ESI高被引',
							allowBlank: false,
							width:40,
							editable:false,
							hidden:true,
							dataIndex: 'ESICited'
					},{
						id : 'AllAudit',
						header : '是否全部审批通过',
						width : 120,
						editable: false,
						hidden : true,
						dataIndex : 'AllAudit'
					},{
						id : 'PrjName',
						header : '科研基金资助',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'PrjName'

					},{
						header : '论文依托科研课题(院外)',
						dataIndex : 'OutPrjName',
						hidden : true
					},{
						header : '类型ID',
						dataIndex : 'TypeID',
						hidden : true
					},{
						header : '年ID',
						dataIndex : 'YearID',
						hidden : true
					},{
						header : '收录类别ID',
						dataIndex : 'RecordTypeID',
						hidden : true
					},{
						header : '期刊ID',
						dataIndex : 'JournalDR',
						hidden : true
					},{
						header : '期刊级别ID',
						dataIndex : 'JourLevelID',
						hidden : true
					},{
						header : '论文类别ID',
						dataIndex : 'PaperTypeID',
						hidden : true
					},{
						header : '我院单位位次ID',
						dataIndex : 'CompleteUnitID',
						hidden : true
					},{
						header : '货币单位ID',
						dataIndex : 'UnitMoneyID',
						hidden : true
					},{
						header : '依托单位ID',
						dataIndex : 'PrjDR',
						hidden : true
					}] 

		});
		
/////////////////添加按钮////////////////////////////
var addButton = new Ext.Toolbar.Button({
	text: '新增',
        //tooltip:'添加',        
        iconCls: 'edit_add',
	handler:function(){
	AddFun();			
	}
	
});

/////////////////修改按钮//////////////////
var editButton = new Ext.Toolbar.Button({
	text: '修改',
        //tooltip:'修改',        
        iconCls: 'pencil',
	handler:function(){
		var rowObj = itemGrid.getSelectionModel().getSelections();
		if(rowObj.length<1){
		 Ext.Msg.show({title:'提示',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		 return;
		}
		var state = rowObj[0].get("DataStatus");
		var AuthorInfoID = rowObj[0].get("AuthorsInfo");
		var CorrAuthorInfoID = rowObj[0].get("CorrAuthorsInfo");
		
		
		
		if((state == "未提交")||(groupdesc=="科研管理系统(信息修改)" )){EditFun(AuthorInfoID,CorrAuthorInfoID);}
		else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可再修改！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}	
			
	}
	
});

////////////////删除按钮/////////////////////
var delButton = new Ext.Toolbar.Button({
	text:'删除',
	//tooltip:'删除',
	iconCls: 'edit_remove',
	handler:function(){
		var rowObj = itemGrid.getSelectionModel().getSelections();
		var state = rowObj[0].get("DataStatus");
		if(state == "未提交" ){delFun();}
		else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可再删除！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}	
	}	
});

/////////////////提交按钮/////////////////////
var submitButton = new Ext.Toolbar.Button({
		text: '提交',
        //tooltip:'提交',        
        iconCls: 'pencil',
		handler:function(){
		var rowObj = itemGrid.getSelectionModel().getSelections();
		
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'注意',msg:'请选择需要提交的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			
			//////////////////////////判断是否有附件上传记录///////////////////////////
				Ext.Ajax.request({
					url:'herp.srm.uploadexe.csp?action=GetUpLoadInfo&RecDr='+rowObj[0].get("rowid")+'&SysNo='+'P00201',
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'注意',msg:'请上传原文附件!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
						
							return;
						}
						
					},
					scope: this			
				  });
		///////////////////////////////////////
		
			var state = rowObj[0].get("DataStatus");
		if(state == "未提交"){submitFun();}
		else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可再提交！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}				
		}
	
});
  itemGrid.addButton('-');
  itemGrid.addButton(addButton);
  itemGrid.addButton('-');
  itemGrid.addButton(editButton);
  itemGrid.addButton('-');
  itemGrid.addButton(delButton);
  itemGrid.addButton('-');
  itemGrid.addButton(submitButton);
  //itemGrid.addButton('-');
  //itemGrid.addButton(upLaodButton);

  
    itemGrid.btnAddHide();     //隐藏增加按钮
    itemGrid.btnSaveHide();    //隐藏保存按钮
    itemGrid.btnResetHide();   //隐藏重置按钮
    itemGrid.btnDeleteHide();  //隐藏删除按钮
    itemGrid.btnPrintHide();   //隐藏打印按钮

/**
var data1 = "|||||||"+userdr+"|";

itemGrid.load({params:{data:data1,sortField:'',sortDir:'',start:0,limit:25}});     
**/
	var data = "|||||||"+userdr+"|";
if ((groupdesc=="科研管理系统(信息修改)")||(groupdesc=="科研管理系统(信息查询)"))
{ 
  userdr="";
  data="";
  //itemGrid.load({params:{data:data,sortField:'', sortDir:'',start:0,limit:25}});      
}
else{
  itemGrid.load({params:{data:data,sortField:'', sortDir:'',start:0,limit:25}});      
}

// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//  论文题目
	if (columnIndex == 8) {
		PaperDetail(itemGrid);
	}
	//作者排名
	if (columnIndex == 30) {
		var records = itemGrid.getSelectionModel().getSelections();
		var authorinfo = records[0].get("AuthorsInfo");
//		var corrauthorinfo = records[0].get("CorrAuthorsInfo");
//		authorinfo=authorinfo+','+corrauthorinfo;
    var title = records[0].get("Title");
		AuthorInfoList(title,authorinfo);
	}
	if (columnIndex == 31) {
		var records = itemGrid.getSelectionModel().getSelections();
		var corrauthorinfo = records[0].get("CorrAuthorsInfo");
		//alert(authorinfo);
		var title = records[0].get("Title");
		CorrAuthorInfoList(title,corrauthorinfo);
	}
	
		
	
});

if (groupdesc=="科研管理系统(信息修改)")
{
	 addButton.disable();//设置为不可用
	  delButton.disable();//设置为不可用
	  submitButton.disable();//设置为不可用
	  
	
	}
if (groupdesc=="科研管理系统(信息查询)")
{
	 addButton.disable();//设置为不可用
	 editButton.disable();
	 delButton.disable();//设置为不可用
	 submitButton.disable();//设置为不可用
	  
	
}
uploadMainFun(itemGrid,'rowid','P00201',17);//原文上传
uploadMainFun(itemGrid,'rowid','P00202',18);//收录证明上传
downloadMainFun(itemGrid,'rowid','P00201,P00202',19);//下载原文和收录证明
