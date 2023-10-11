var userdr = session['LOGON.USERCODE'];

var groupdesc = session['LOGON.GROUPDESC'];
if (groupdesc=="科研管理系统(信息修改)")
{ 
	userdr="";
}
if (groupdesc=="科研管理系统(信息查询)")
{ 
	userdr="";
}

var projUrl='herp.srm.srmpatentrewardapplyexe.csp';

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
/////////////////授权日期///////////////////////
var StartDateField = new Ext.form.DateField({
			fieldLabel: '授权日期',
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
var EndDateField = new Ext.form.DateField({
			fieldLabel: '授权日期',
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
/////////////////科室///////////////////////
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


/////////////////专利权人///////////////////
var PatenteeDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


PatenteeDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetPatentee&str='+encodeURIComponent(Ext.getCmp('Patentees').getRawValue()),
	method:'POST'});
});

var PatenteeField = new Ext.form.ComboBox({
	id: 'Patentees',
	fieldLabel: '专利权人',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:PatenteeDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择专利权人...',
	name: 'Patentees',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


/////////////////专利号///////////////////
var PatentNumber = new Ext.form.TextField({
                width: 120,
                allowBlank: true,
                name: 'PatentNumber',
                fieldLabel: '专利号',
                blankText: '专利号'
            });
/////////////////专利名称///////////////////
var PatentName = new Ext.form.TextField({
                width: 120,
                allowBlank: true,
                name: 'PatentName',
                fieldLabel: '专利名称',
                blankText: '专利名称'
            });


/////////////////专利发明人///////////////////////////
var InventorsDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


InventorsDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetInventors&str='+encodeURIComponent(Ext.getCmp('Inventorss').getRawValue()),
	method:'POST'});
});

var InventorsField = new Ext.form.ComboBox({
	id: 'Inventorss',
	fieldLabel: '专利发明人',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:InventorsDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择专利发明人...',
	name: 'Inventorss',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
/////////////////////专利类别/////////////////////////////					
var ufPatentTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '发明专利'], ['2', '实用新型专利'], ['3', '外观设计专利']]
	});
	var ufPatentTypeField = new Ext.form.ComboBox({
	    id : 'ufPatentTypeField',
		fieldLabel : '专利类别',
		width : 120,
		listWidth : 120,
		store : ufPatentTypeDs,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // 本地模式
		triggerAction: 'all',
		//emptyText:'请选择...',
		selectOnFocus:true,
		forceSelection : true
	});	
/////////////////查询按钮响应函数//////////////
function SearchFun()
{			
	  var startdate= StartDateField.getRawValue()
		if(startdate!=""){
			//startdate.format("Y-m-d");
		};
	  var enddate= EndDateField.getRawValue()
		if(enddate!=""){
			//enddate.format("Y-m-d");
		};
	  var DeptDr  = DeptField.getValue();
    var Patentee = PatenteeField.getValue();
    var PatentNum = PatentNumber.getValue();
    var Name = PatentName.getValue();
    var Inventors = InventorsField.getValue();
    var PatentType = ufPatentTypeField.getValue();
    if ((groupdesc=="科研管理系统(信息修改)")||(groupdesc=="科研管理系统(信息查询)"))
	{ 
		userdr="";
	}
	itemGrid.load({params:{start:0,limit:25,startdate:startdate,enddate:enddate,DeptDr:DeptDr,Patentee:Patentee,PatentNum:PatentNum,Name:Name,Inventors:Inventors,userdr:userdr,PatentType:PatentType}});
	
}

//////////////////////////////////////////////
var queryPanel = new Ext.FormPanel({
	autoHeight : true,
	region : 'north',
	frame : true,
	title : '专利奖励申请信息查询',
	iconCls : 'search',
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
					value : '<p style="text-align:right;">专利权人</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				PatenteeField,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">授权日期</p>',
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
					width : 70			
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
					value : '<p style="text-align:right;">专利号</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},	
				PatentNumber,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">专利名称</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				PatentName,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},				
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">专利类型</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				ufPatentTypeField,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">专利发明人</p>',
					width : 70			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				InventorsField
				]
	}]
	
});

var itemGrid = new dhc.herp.Grid({
			region : 'center',
			title: '专利奖励审核信息查询列表',
			iconCls: 'list',
			url : projUrl,					
			fields : [
			 new Ext.grid.CheckboxSelectionModel({
				 hidden:true,
				 editable:false
				 
				 }),
			{
						header:'ID',
						dataIndex:'rowid',
						align:'center',
						hidden:true
					},{
						id:'YearDr',
						header:'年度 ',
						width:60,
						editable:false,
						allowBlank:false,
						align:'left',
						dataIndex:'YearDr'

					}, {
						id:'CertificateNo',
						header:'证书号',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'CertificateNo'

					},{
						id:'PatentType',
						header:'专利类别',
						width:100,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'PatentType'
					},{
						id:'PatentTypeList',
						header:'专利类别',
						width:120,
						editable:false,
						align:'left',
						dataIndex:'PatentTypeList'
					},{
						id:'Name',
						header:'专利名称',
						width:180,
						editable:false,
						align:'left',
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
						dataIndex:'Name'
					}, {
						id:'Patentee',
						header:'专利权人',
						width:120,
						editable:false,
						align:'left',
						dataIndex:'Patentee',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					}, {
							id:'upload',
							header: '附件',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){			
							return '<span style="color:blue"><u>上传</u></span>';
							}
					},{
							id:'download',
							header: '下载',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>下载</u></span>';
					    } 
					},{
						id:'DataStatus',
						header:'数据状态',
						editable:false,
						width:60,
						align:'left',
						dataIndex:'DataStatus'
					},{
						id:'ChkResult',
						header:'审核状态',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'ChkResult'
					},{
						id:'Desc',
						header:'审核意见',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'Desc'
					},{
						id:'Inventors',
						header:'发明人IDs',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'Inventors'
					},{
						id:'InventorInfos',
						header:'发明人',
						width:80,
						editable:false,
						align:'left',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						},
						dataIndex:'InventorInfos'
					},{
						id:'PatentNum',
						header:'专利号',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'PatentNum'

					},{
						id:'AppDate',
						header:'专利申请日期',
						//xtype:'numbercolumn',
						width : 120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'AppDate'

					},{
						id:'AnnDate',
						header:'授权公告日期',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'AnnDate'

					},{
						id:'AnnUnit',
						header:'公布单位',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'AnnUnit'

					},{
						id:'AnnUnitList',
						header:'公布单位',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'AnnUnitList'

					},{
						id:'CompleteUnit',
						header:'我院单位位次',
						//xtype:'numbercolumn',
						width : 120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'CompleteUnit'

					},{
						id:'VCAmount',
						header:'申请报销(元)',
						editable:false,
						width:100,
						align:'right',
						dataIndex:'VCAmount',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
					},{
						id:'unitMoney',
						header:'货币单位',
						editable:false,
						width:60,
						align:'left',
						dataIndex:'unitMoney'
					},{
						id:'REAmount',
						header:'实际报销(元)',
						editable:false,
						width:100,
						align:'right',
						dataIndex:'REAmount',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
					},{
						id:'InvoiceCode',
						header:'报销编码',
						editable:false,
						width:120,
						align:'left',
						hidden:true,
						dataIndex:'InvoiceCode'
					},{
						id:'InvoiceNo',
						header:'报销号',
						editable:false,
						width:120,
						align:'left',
						hidden:true,
						dataIndex:'InvoiceNo'
					},{
						id : 'RewardAmount',
						header : '奖励(元)',
						width : 80,
						editable:false,
						allowblank:false,
						align:'right',
						renderer : function(val,cellmeta, record,rowIndex, columnIndex, store) { 
						
						val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
			 
						var sf = record.data['RewardAmount']
						if (sf !== "") {
							return '<span style="color:red;cursor:hand;">'+val+'</span>';
						}},
						dataIndex : 'RewardAmount'
					},{
						id:'SubUser',
						header:'申请人',
						editable:false,
						width:60,
						align:'left',
						dataIndex:'SubUser'
					},{
						id:'DeptDr',
						header:'申请人科室',
						editable:false,
						width:120,
						align:'left',
						dataIndex:'DeptDr',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					},{
						id:'SubDate',
						header:'申请时间',
						editable:false,
						width:80,
						align:'left',
						dataIndex:'SubDate'
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
					}]
		});


///////////////////添加按钮///////////////////////
var addPatentInfoButton = new Ext.Toolbar.Button({
		text: '新增',    
    	iconCls: 'edit_add',
		handler: function(){addFun();}
});

/////////////////修改按钮/////////////////////////
var editPatentInfoButton  = new Ext.Toolbar.Button({
		text: '修改',        
		iconCls: 'pencil',
		handler: function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length; 
			if(len < 1)
			{
				Ext.Msg.show({title:'提示',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				var state = rowObj[0].get("DataStatus");	
				var inventorsids = rowObj[0].get("Inventors");		
				if((state == "未提交")||(groupdesc=="科研管理系统(信息修改)" ) ){editFun(inventorsids);}				
				else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可再修改！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}
			}
});

////////////////删除按钮//////////////////////////
var delPatentInfoButton  = new Ext.Toolbar.Button({
		text: '删除',        
		iconCls: 'edit_remove',
		handler: function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if(len<1){
				Ext.Msg.show({title:'提示',msg:'请选择需要删除的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				for(var i = 0; i < len; i++){
				var state = rowObj[i].get("DataStatus");			
				if(state == "未提交" ){delFun();}
				else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可删除！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}
});

///////////////提交按钮//////////////////////////
var subPatentInfoButton = new Ext.Toolbar.Button({
		text:'提交',
		iconCls: 'pencil',
		handler:function(){subFun();}	
});


  itemGrid.addButton('-');
  itemGrid.addButton(addPatentInfoButton);
  itemGrid.addButton('-');
  itemGrid.addButton(editPatentInfoButton);
  itemGrid.addButton('-');
  itemGrid.addButton(delPatentInfoButton);
  itemGrid.addButton('-');
  itemGrid.addButton(subPatentInfoButton);



  itemGrid.btnResetHide(); 	//隐藏重置按钮
  itemGrid.btnDeleteHide(); //隐藏删除按钮
  itemGrid.btnPrintHide(); 	//隐藏打印按钮
  itemGrid.btnAddHide(); 	//隐藏添加按钮
  itemGrid.btnSaveHide(); 	//隐藏保存按钮
  itemGrid.load({params:{start:0, limit:12, userdr:userdr}});
  
 // 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
    if (columnIndex == 7) {
		PatentDetail(itemGrid);
	}
	//作者排名
	if (columnIndex == 15) {
		var records = itemGrid.getSelectionModel().getSelections();
		var authorinfo = records[0].get("Inventors");
		var title = records[0].get("Name");
		AuthorInfoList(title,authorinfo);
	}
}); 
 
 if (groupdesc=="科研管理系统(信息修改)")
{
	 addPatentInfoButton.disable();//设置为不可用
	  delPatentInfoButton.disable();//设置为不可用
	  subPatentInfoButton.disable();//设置为不可用
	  
	
	}
if (groupdesc=="科研管理系统(信息查询)")
{
	 addPatentInfoButton.disable();//设置为不可用
	 editPatentInfoButton.disable();
	  delPatentInfoButton.disable();//设置为不可用
	  subPatentInfoButton.disable();//设置为不可用
	  
	
	}
uploadMainFun(itemGrid,'rowid','P005',9);
downloadMainFun(itemGrid,'rowid','P005',10);
