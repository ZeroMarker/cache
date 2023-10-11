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

var projUrl='herp.srm.srmpatentcertificateapplyexe.csp';

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

/////////////////专利院内证明申请日期///////////////////////
var StartDateField = new Ext.form.DateField({
			fieldLabel: '申请日期',
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
/////////////////专利名称///////////////////
var PatentName = new Ext.form.TextField({
                width: 120,
                allowBlank: true,
                name: 'PatentName',
                fieldLabel: '专利名称',
                blankText: '专利名称'
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
    var Name = PatentName.getValue();
    var PatentType = ufPatentTypeField.getValue();
    if ((groupdesc=="科研管理系统(信息修改)")||(groupdesc=="科研管理系统(信息查询)"))
	{ 
		userdr="";
	}
	
	itemGrid.load({params:{start:0,limit:25,startdate:startdate,enddate:enddate,DeptDr:DeptDr,Patentee:Patentee,Name:Name,PatentType:PatentType,userdr:userdr}});
	
}

//////////////////////////////////////////////
var queryPanel = new Ext.FormPanel({
	autoHeight : true,
	title : '专利院内证明申请信息查询',
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
				/* {
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
				}, */
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
					width : 20			
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
				ufPatentTypeField
				]
	}]
	
});

var itemGrid = new dhc.herp.Grid({
	title: '专利院内证明申请信息查询列表',
			iconCls: 'list',
			region : 'center',
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

					},{
						id:'DeptDr',
						header:'所属科室',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'DeptDr'
					},{
						id:'PatentTypeList',
						header:'专利类别',
						width:100,
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

					},{
						id:'InventorsID',
						header:'发明人IDs',
						width:100,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'InventorsID'
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
							id:'upload',
							header: '专利请求书',
							allowBlank: false,
							width:80,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){			
							return '<span style="color:blue"><u>上传</u></span>';
							}
					},{
							id:'upload2',
							header: '权利要求书',
							allowBlank: false,
							width:80,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){			
							return '<span style="color:blue"><u>上传</u></span>';
							}
					}
					,{
							id:'upload3',
							header: '说明书',
							allowBlank: false,
							width:60,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){			
							return '<span style="color:blue"><u>上传</u></span>';
							}
					},{
							id:'upload4',
							header: '说明书附图',
							allowBlank: false,
							width:80,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){			
							return '<span style="color:blue"><u>上传</u></span>';
							}
					},{
							id:'upload5',
							header: '说明书摘要',
							allowBlank: false,
							width:80,
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
							id:'IsApproved',
							header: '是否获批',
							allowBlank: false,
							width:60,
							editable:false,
							dataIndex: 'IsApproved'
					},{
							id:'ApprovedDate',
							header: '获批日期',
							allowBlank: false,
							width:80,
							editable:false,
							dataIndex: 'ApprovedDate'
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
						id:'AppDate',
						header:'专利申请日期',
						//xtype:'numbercolumn',
						width : 120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'AppDate'

					},{
						id:'SubUser',
						header:'申请人',
						editable:false,
						width:60,
						align:'left',
						dataIndex:'SubUser'
					},{
						id:'SubDept',
						header:'申请人科室',
						editable:false,
						width:120,
						align:'left',
						dataIndex:'SubDept',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					},{
						id:'SubDate',
						header:'专利登记日期',
						editable:false,
						width:80,
						align:'left',
						dataIndex:'SubDate'
					},{
						id:'Phone',
						header:'手机',
						editable:false,
						width:120,
						align:'left',
						hidden:true,
						dataIndex:'Phone'
					},{
						id:'Email',
						header:'邮箱',
						editable:false,
						width:120,
						hidden:true,
						align:'left',
						dataIndex:'Email'
					},{
						id:'PatenteeDR',
						header:'专利权人ID',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'PatenteeDR'

					},{
						id:'PatentType',
						header:'专利类别ID',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'PatentType'
					},{
						id:'Year',
						header:'年度ID',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'Year'
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
				var inventorsids = rowObj[0].get("InventorsID");		
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
    if (columnIndex ==6) {
		PatentDetail(itemGrid);
	}
	if (columnIndex == 9) {
		var records = itemGrid.getSelectionModel().getSelections();
		var authorinfo = records[0].get("InventorsID");
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
uploadMainFun(itemGrid,'rowid','SRMpatentapply001',10);
uploadMainFun(itemGrid,'rowid','SRMpatentapply002',11);
uploadMainFun(itemGrid,'rowid','SRMpatentapply003',12);
uploadMainFun(itemGrid,'rowid','SRMpatentapply004',13);
uploadMainFun(itemGrid,'rowid','SRMpatentapply005',14);
downloadMainFun(itemGrid,'rowid','SRMpatentapply001,SRMpatentapply002,SRMpatentapply003,SRMpatentapply004,SRMpatentapply005',15);
