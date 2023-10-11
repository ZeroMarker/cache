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

var projUrl='herp.srm.srmprosoliapplyexe.csp';

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
/////////////////申请时间///////////////////////
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
/////////////////年度///////////////////////
var YearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

YearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=yearList&str='+encodeURIComponent(Ext.getCmp('YearCombo').getRawValue()),
	method:'POST'});
});

var YearCombo = new Ext.form.ComboBox({
	id: 'YearCombo',
	fieldLabel: '年度',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:YearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择年度...',
	name: 'YearCombo',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

/////////////////项目来源///////////////////
/*
var SubSourceDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

SubSourceDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=sourceList&str='+encodeURIComponent(Ext.getCmp('SubSourceCombo').getRawValue()),
	method:'POST'});
});

var SubSourceCombo = new Ext.form.ComboBox({
	id: 'SubSourceCombo',
	fieldLabel: '项目来源',
	width:120,
	listWidth : 250,
	allowBlank: true,
	store:SubSourceDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择项目来源...',
	name: 'SubSourceCombo',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
*/
 ///项目来源
var SubSourceDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'Name'])
		});
		
SubSourceDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=sourceList&str='+encodeURIComponent(Ext.getCmp('SubSourceCombo').getRawValue()), 
                        method:'POST'
					});
		});

var SubSourceCombo = new Ext.form.ComboBox({
			id:'SubSourceCombo',
			fieldLabel : '项目来源',
			store : SubSourceDs,
			displayField : 'Name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			//emptyText : '请选择项目来源...',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			renderer: function formatQtip(data,metadata)
			{
				var title = "";
				var tip = data;
				metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
				return data;
			}
		});

/////////////////项目名称///////////////////
var TitleField = new Ext.form.TextField({
				id: 'TitleField',
                width: 120,
                allowBlank: true,
                name: 'TitleField',
                fieldLabel: '项目名称',
                blankText: '项目名称'
                
            });

/////////////////查询按钮响应函数//////////////
function SearchFun()
{			
	var Startdate= StartDateField.getValue()
	if(Startdate!="")
	{
		//Startdate.format("Y-m-d");
	};
	var Enddate= EndDateField.getValue()
	if(Enddate!="")
	{
		//Enddate.format("Y-m-d");
	};
	
	var Year = YearCombo.getValue();
    var SubSource = SubSourceCombo.getValue();
    var Title = TitleField.getValue();

    if ((groupdesc=="科研管理系统(信息修改)")||(groupdesc=="科研管理系统(信息查询)"))
	{ 
		userdr="";
	}
	itemGrid.load({params:{start:0,limit:25,Startdate:Startdate,Enddate:Enddate,Year:Year,SubSource:SubSource,Title:Title,SubUser:userdr}});
}

//////////////////////////////////////////////
var queryPanel = new Ext.FormPanel
({
	autoHeight : true,
	region : 'north',
	frame : true,
	title : '项目征集申请信息查询',
	iconCls : 'search',	
	defaults : 
	{
		bodyStyle : 'padding:5px'
	},
	items : 
	[
		{
			columnWidth : 1,
			xtype : 'panel',
			layout : "column",
			items : 
			[
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">年度</p>',
					width : 60			
				},	
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				YearCombo,
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
		}, 
		{
			columnWidth : 1,
			xtype : 'panel',
			layout : "column",
			items : 
			[
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">项目名称</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},	
				TitleField,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">项目来源</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				SubSourceCombo
			]
		}	
	]	
});

var itemGrid = new dhc.herp.Grid({
			region : 'center',
			title: '项目征集申请信息查询列表',
			iconCls: 'list',
			url : projUrl,				
			fields : [
			 new Ext.grid.CheckboxSelectionModel({
				 //hidden:true,
				 editable:false
				 
				 }),
			{
						header:'ID',
						dataIndex:'rowid',
						align:'center',
						hidden:true
					},{
						id:'Year',
						header:'年度 ',
						width:80,
						editable:false,
						allowBlank:false,
						align:'left',
						dataIndex:'Year'
					}, {
						id:'Title',
						header:'项目名称',
						width:180,
						editable:false,
						align:'left',
						dataIndex:'Title',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					},{
						id:'SubSource',
						header:'项目来源',
						width:120,
						editable:false,
						align:'left',
						dataIndex:'SubSource',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					},{
						id:'IsEthic',
						header:'是否伦理审核',
						width:80,
						editable:false,
						align:'left',
						dataIndex:'IsEthic'
					},{
						id:'PreAuditState',
						header:'预审状态',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'PreAuditState'
					},{
						id:'PreAuditDesc',
						header:'预审意见',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'PreAuditDesc',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					},{
						id:'EthicResult',
						header:'伦理审核状态',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'EthicResult'
					},{
						id:'EthicAuditDesc',
						header:'伦理审核意见',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'EthicAuditDesc',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					},{
						id:'Expert',
						header:'专业评审人',
						width:120,
						editable:false,
						align:'left',
						dataIndex:'Expert',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					}, /* {
						id:'EthicExpert',
						header:'项目伦理审核人',
						width:120,
						editable:false,
						align:'left',
						dataIndex:'EthicExpert'

					}, */{
						id:'OutExpertResult',
						header:'院外专家审核结果',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'OutExpertResult'
					},{
						id:'OutEthicResult',
						header:'院外伦理审核结果',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'OutEthicResult'
					},{
						id:'OutCheckResult',
						header:'查看院外审核结果',
						width:120,
						editable:false,
						align:'left',
						dataIndex:'OutCheckResult',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						}
					}, {
							id:'upload',
							header: '上传',
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
						id:'SubUser',
						header:'申请人',
						editable:false,
						width:120,
						align:'left',
						dataIndex:'SubUser'
					},{
						id:'SubDeptDr',
						header:'申请人科室',
						width:180,
						editable:false,
						align:'left',
						dataIndex:'SubDeptDr',
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
						width:120,
						editable:false,
						align:'left',
						dataIndex:'SubDate'
					},{
						id:'DataStatus',
						header:'提交状态',
						width:120,
						editable:false,
						align:'left',
						dataIndex:'DataStatus'
					},{
						id:'AuditStatus',
						header:'审批状态',
						width:120,
						editable:false,
						align:'left',
						dataIndex:'AuditStatus'
					},{
						id:'ChkDesc',
						header:'审批意见',
						width:120,
						editable:false,
						align:'left',
						dataIndex:'ChkDesc'
					},{
						id:'YearDR',
						header:'年度ID',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'YearDR'
					},{
						id:'SubSourceDR',
						header:'项目来源ID',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'SubSourceDR'
					},{
						id:'IsEthicDR',
						header:'是否伦理审核ID',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'IsEthicDR'
					}]
		});


///////////////////添加按钮///////////////////////
var addProSoliInfoButton = new Ext.Toolbar.Button({
		text: '添加',    
    	iconCls: 'edit_add',
		handler: function(){addFun();}
});

/////////////////修改按钮/////////////////////////
var editProSoliInfoButton  = new Ext.Toolbar.Button({
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
				if((state == "未提交")||(groupdesc=="科研管理系统(信息修改)" ) ){editFun();}				
				else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可再修改！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}
			}
});

////////////////删除按钮//////////////////////////
var delProSoliInfoButton  = new Ext.Toolbar.Button({
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
var subProSoliInfoButton = new Ext.Toolbar.Button({
		text:'提交',
		iconCls:'pencil',
		handler:function(){subFun();}	
});


/////////////////再次提交预审/////////////////////
var PresubmitButton = new Ext.Toolbar.Button({
		id:'submitButton',
		text: '再次提交预审',
        //tooltip:'提交',        
        iconCls: 'pencil',
		handler:function(){
		var rowObj = itemGrid.getSelectionModel().getSelections();
		
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'注意',msg:'请选择需要再次提交预审材料的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			var prestate = rowObj[0].get("PreAuditState");   //获取预审状态
			var datastatus = rowObj[0].get("DataStatus");    //获取提交状态
			if (datastatus!="已提交"){
				Ext.Msg.show({title:'注意',msg:'请先提交数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			if(prestate !="预审-审核通过"){
				var rowObj = itemGrid.getSelectionModel().getSelections();     // get the selected items
				var len = rowObj.length;
				if(len > 0)
				{  
					Ext.MessageBox.confirm('提示', '确定要提交选定的行?提交后不可修改、不可删除！', function(btn) 
					{
						if(btn == 'yes')
						{	
							if(rowObj[0].get("PreAuditDesc")!="预审-审核通过"){
								for(var i = 0; i < len; i++){     		
									Ext.Ajax.request({
										url: 'herp.srm.srmprosoliapplyexe.csp?action=presubmit&rowid='+rowObj[i].get("rowid"),
										waitMsg:'提交中...',
										failure: function(result, request) {
						            		Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
										success: function(result, request){
											var jsonData = Ext.util.JSON.decode( result.responseText );
											if (jsonData.success=='true') { 
												Ext.MessageBox.alert('提示', '提交完成');
												itemGrid.load({params:{start:0, limit:25}});
											}
											else {
												var message = "提交失败";
												Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
											}
										},
										scope: this
									});
								}
							}else{
								Ext.Msg.show({title:'错误',msg:'您选择的数据已预审通过!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								//return;
							}
						}
					});	
				}
				else
				{
					Ext.Msg.show({title:'提示',msg:'请选择需要提交的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				}    
			}
			else {Ext.Msg.show({title:'警告',msg:'您选择的数据已预审通过！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}				
		}
});

  itemGrid.addButton('-');
  itemGrid.addButton(addProSoliInfoButton);
  itemGrid.addButton('-');
  itemGrid.addButton(editProSoliInfoButton);
  itemGrid.addButton('-');
  itemGrid.addButton(delProSoliInfoButton);
  itemGrid.addButton('-');
  itemGrid.addButton(subProSoliInfoButton);
  itemGrid.addButton('-');
  itemGrid.addButton(PresubmitButton);
  



  itemGrid.btnResetHide(); 	//隐藏重置按钮
  itemGrid.btnDeleteHide(); //隐藏删除按钮
  itemGrid.btnPrintHide(); 	//隐藏打印按钮
  itemGrid.btnAddHide(); 	//隐藏添加按钮
  itemGrid.btnSaveHide(); 	//隐藏保存按钮
  itemGrid.load({params:{start:0, limit:12, SubUser:userdr}});
  
 // 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	var rowObj=itemGrid.getSelectionModel().getSelections();
	var rowid=rowObj[0].get("rowid");
	var OutExpertResult=rowObj[0].get("OutExpertResult");
	var EthicChkResult=rowObj[0].get("OutEthicResult");
	if(columnIndex==14)
	{
		OutExpertChk(rowid,OutExpertResult,EthicChkResult);
	}
}); 
 
 if (groupdesc=="科研管理系统(信息修改)")
{
	 addProSoliInfoButton.disable();//设置为不可用
	 delProSoliInfoButton.disable();//设置为不可用
	 subProSoliInfoButton.disable();//设置为不可用	
}
if (groupdesc=="科研管理系统(信息查询)")
{
	 addProSoliInfoButton.disable();//设置为不可用
	 editProSoliInfoButton.disable();
	 delProSoliInfoButton.disable();//设置为不可用
	 subProSoliInfoButton.disable();//设置为不可用	
}
uploadMainFun(itemGrid,'rowid','P011',15);
downloadMainFun(itemGrid,'rowid','P011',16);
