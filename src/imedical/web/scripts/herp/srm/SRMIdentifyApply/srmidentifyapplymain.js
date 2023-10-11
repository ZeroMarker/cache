var usercode = session['LOGON.USERCODE'];


var groupdesc = session['LOGON.GROUPDESC'];
if (groupdesc=="科研管理系统(信息修改)")
{ var usercode=""
	}
if (groupdesc=="科研管理系统(信息查询)")
{ var usercode=""
	}
	
var projUrl='herp.srm.srmidentifyapplyexe.csp';

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
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true
});		
/////////////////鉴定开始日期///////////////////////
var StartDateField = new Ext.form.DateField({
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
/////////////////鉴定结束日期///////////////////////
var EndDateField = new Ext.form.DateField({
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

/////////////////参与人///////////////////
var ParticipantDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


ParticipantDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetUser&str='+encodeURIComponent(Ext.getCmp('ParticipantField').getRawValue()),
	method:'POST'});
});

var ParticipantField = new Ext.form.ComboBox({
	id: 'ParticipantField',
	fieldLabel: '参与人',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:ParticipantDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	// emptyText:'请选择参与人...',
	name: 'Patentees',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


/////////////////名称///////////////////
var NameField = new Ext.form.TextField({
                width: 120,
                allowBlank: true,
                name: 'NameField',
                fieldLabel: '名称',
                blankText: '请输入名称.....'
            });


/////////////////鉴定单位///////////////////////////
var IdentifyUnitDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


IdentifyUnitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetUint&str='+encodeURIComponent(Ext.getCmp('IdentifyUnitField').getRawValue()),
	method:'POST'});
});

var IdentifyUnitField = new Ext.form.ComboBox({
	id: 'IdentifyUnitField',
	fieldLabel: '鉴定单位',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:IdentifyUnitDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	// emptyText:'请选择鉴定单位...',
	name: 'Inventorss',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
///////////////////鉴定级别
var IdentifyLevelStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '国际先进'], ['2', '国际领先'], ['3', '国内先进'], ['4', '国内领先']]
		});
var IdentifyLevelField = new Ext.form.ComboBox({
			fieldLabel : '鉴定级别',
			width : 120,
			listWidth : 120,
			selectOnFocus : true,
			allowBlank : true,
			store : IdentifyLevelStore,
			anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			// emptyText : '',
			mode : 'local', // 本地模式
			editable : true,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
/////////////////查询按钮响应函数//////////////
function SearchFun()
{			
	  var startdate= StartDateField.getRawValue();
	  var enddate= EndDateField.getRawValue()
	  if(startdate!=""){
			//startdate.format("Y-m-d");
		};
	  if(enddate!=""){
			//enddate.format("Y-m-d");
		};
	var Title  = NameField.getValue();
    var Participant = ParticipantField.getValue();
    var IdentifyLevel = IdentifyLevelField.getValue();
    var IdentifyUnit = IdentifyUnitField.getValue();
    var Type = TypeCombox.getValue();
	
	itemGrid.load({params:{start:0,limit:25,startdate:startdate,enddate:enddate,Title:Title,Participant:Participant,IdentifyLevel:IdentifyLevel,IdentifyUnit:IdentifyUnit,usercode:usercode,Type:Type}});
	
}

//////////////////////////////////////////////
var queryPanel = new Ext.FormPanel({
	autoHeight : true,
	region : 'north',
	frame : true,
	iconCls : 'search',	
	title : '科研鉴定申请查询',
	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">类型</p>',
				//columnWidth : .08
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},TypeCombox,{
				xtype:'displayfield',
				value:'',
				width:10
				},{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">项目名称</p>',
				//columnWidth : .08
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},NameField,{
				xtype:'displayfield',
				value:'',
				width:10
				},{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">鉴定日期</p>',
				//columnWidth : .08
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},StartDateField,{
				xtype:'displayfield',
				value:'',
				width:10
				},{
				xtype:'displayfield',
				value:'<p style="text-align:center;">至</p>',
				width:20
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},EndDateField,{
				xtype:'displayfield',
				value:'',
				width:30
				},{
				//columnWidth:0.06,
				width:30,
				xtype:'button',
				text: '查询',
				handler:function(b){SearchFun();},
				iconCls: 'search'
				}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">参与人</p>',
				//columnWidth : .08
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},ParticipantField,{
				xtype:'displayfield',
				value:'',
				width:10
				},{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">鉴定单位</p>',
				//columnWidth : .08
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},IdentifyUnitField,
				{
				xtype:'displayfield',
				value:'',
				width:10
				},{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">鉴定级别</p>',
				//columnWidth : .08
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},IdentifyLevelField]
	}]
	
});

////"rowid^YearName^Name^ParticipantInfo^IdentifyLevel^IdentifyUnit^IdentifyDate^CompleteUnit^SubUser^SubDate^DataStatus^ResAudit^Auditor^AuditDate^Remark^YearDR^ParticipantDRs^IdentifyUnitDR^SubUserDR^AuditorDR"
var itemGrid = new dhc.herp.Grid({
			region : 'center',
			title: '科研鉴定申请查询列表',
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
						id:'Type',
						header:'类型',
						width:40,
						editable:false,
						allowBlank:false,
						align:'left',
						dataIndex:'Type'
					},{
						id:'YearName',
						header:'年度 ',
						width:60,
						editable:false,
						allowBlank:false,
						align:'left',
						dataIndex:'YearName'
					},{
						id:'Name',
						header:'项目名称',
						width:150,
						editable:false,
						align:'left',
						dataIndex:'Name',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					},{
						id:'ParticipantInfo',
						header:'参与人位次信息',
						width:100,
						editable:false,
						align:'left',
						hidden:false,
						dataIndex:'ParticipantInfo',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						}
					},{
							id:'upload',
							header: '鉴定证书',
							allowBlank: false,
							width:60,
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
					    } },{
						id:'DataStatus',
						header:'提交状态',
						//xtype:'numbercolumn',
						width : 60,
						editable:false,
						align:'left',
						dataIndex:'DataStatus'

					},{
						id:'ResAudit',
						header:'审核状态',
						width:80,
						editable:false,
						align:'left',
						dataIndex:'ResAudit'

					},{
						id:'ResDesc',
						header:'审核说明',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'ResDesc',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					},{
						id:'IdentifyLevel',
						header:'鉴定级别',
						width:60,
						editable:false,
						align:'left',
						dataIndex:'IdentifyLevel'
					},{
						id:'IdentifyUnit',
						header:'鉴定单位',
						width:180,
						editable:false,
						align:'left',
						dataIndex:'IdentifyUnit',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					}, {
						id:'IdentifyDate',
						header:'鉴定日期',
						width:80,
						editable:false,
						align:'left',
						dataIndex:'IdentifyDate'
					}, {
						id:'CompleteUnit',
						header:'我院单位位次',
						width:100,
						editable:false,
						align:'center',
						hidden:true,
						dataIndex:'CompleteUnit'
					},{
						id:'SubUser',
						header:'申请人',
						width:60,
						editable:false,
						align:'left',
						dataIndex:'SubUser'
					},{
						id:'SubDate',
						header:'申请时间',
						width:80,
						editable:false,
						align:'left',
						dataIndex:'SubDate'

					},{
						id:'Auditor',
						header:'审核人',
						width:60,
						editable:false,
						align:'left',
						dataIndex:'Auditor'

					},{
						id:'AuditDate',
						header:'审核时间',
						width:80,
						editable:false,
						align:'left',
						hidden:false,
						dataIndex:'AuditDate'

					},{
						id:'Remark',
						header:'备注',
						width:120,
						editable:false,
						align:'left',
						dataIndex:'Remark',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					},{
						id:'ParticipantDRs',
						header:'参与人IDs',
						width:120,
						editable:false,
						align:'center',
						hidden:'true',
						dataIndex:'ParticipantDRs'

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
					}
				]
		});


///////////////////添加按钮///////////////////////
var addPatentInfoButton = new Ext.Toolbar.Button({
		text: '新增',    
    	iconCls:'edit_add',
		handler: function(){addFun();}
});

/////////////////修改按钮/////////////////////////
var editPatentInfoButton  = new Ext.Toolbar.Button({
		text: '修改',        
		iconCls:'pencil',
		handler: function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length; 
			if(len < 1)
			{
				Ext.Msg.show({title:'提示',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				var state = rowObj[0].get("DataStatus");	
				var participantids = rowObj[0].get("ParticipantDRs");		
				if((state == "未提交")||(groupdesc=="科研管理系统(信息修改)" ) ){editFun(participantids);}				
				else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可再修改！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}
			}
});

////////////////删除按钮//////////////////////////
var delPatentInfoButton  = new Ext.Toolbar.Button({
		text: '删除',        
		iconCls:'edit_remove',
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
		iconCls:'pencil',
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
  itemGrid.load({params:{start:0, limit:12, usercode:usercode}});
  
 // 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//作者排名
	if (columnIndex == 6) {
		var records = itemGrid.getSelectionModel().getSelections();
		var authorinfo = records[0].get("ParticipantDRs");
		var title = records[0].get("Name");
		AuthorInfoList(title,authorinfo);
	}
	/**
	if (columnIndex == 19) {
		var records = itemGrid.getSelectionModel().getSelections();
		var state = records[0].get("DataStatus");
		//alert(state);
		if (state=="已提交"){Ext.Msg.show({title:'警告',msg:'数据已提交，不可再上传附件！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}
		else{uploadMainFun(itemGrid,'rowid','P008',19);}
	}**/
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
	 editPatentInfoButton.disable();//设置为不可用
	  delPatentInfoButton.disable();//设置为不可用
	  subPatentInfoButton.disable();//设置为不可用
}

uploadMainFun(itemGrid,'rowid','P008',7);
downloadMainFun(itemGrid,'rowid','P008',8);
