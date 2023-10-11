var usercode = session['LOGON.USERCODE'];
var projUrl = 'herp.srm.srmidentifyauditexe.csp';

var SearchUrl = 'herp.srm.srmidentifyapplyexe.csp';

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
	url:SearchUrl+'?action=GetUser&str='+encodeURIComponent(Ext.getCmp('ParticipantField').getRawValue()),
	method:'POST'});
});

var ParticipantField = new Ext.form.ComboBox({
	id: 'ParticipantField',
	fieldLabel: '参与人员',
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
                fieldLabel: '项目名称',
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
	url:SearchUrl+'?action=GetUint&str='+encodeURIComponent(Ext.getCmp('IdentifyUnitField').getRawValue()),
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
			// emptytext : '',
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
	  var startdate= StartDateField.getValue();
	  var enddate= EndDateField.getValue()
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
    var  Type = TypeCombox.getValue();
	
	itemGrid.load({params:{start:0,limit:25,startdate:startdate,enddate:enddate,Title:Title,Participant:Participant,IdentifyLevel:IdentifyLevel,IdentifyUnit:IdentifyUnit,usercode:usercode,Type:Type}});
	
}

//////////////////////////////////////////////
var queryPanel = new Ext.FormPanel({
	region : 'north',
	frame : true,
	autoHeight : true,
	iconCls : 'search',	
	title : '科研鉴定审核查询',
	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [ {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">类型</p>',
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
				}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">参与人</p>',
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
			title: '科研鉴定审核查询列表',
			iconCls: 'list',
			url : projUrl,			
			fields : [
			 new Ext.grid.CheckboxSelectionModel({editable:false}),
			{
						header:'ID',
						dataIndex:'rowid',
						align:'center',
						hidden:true
					},{
						id:'Type',
						header:'类型 ',
						width:40,
						editable:false,
						allowBlank:false,
						align:'left',
						dataIndex:'Type'
					}, {
						id:'YearName',
						header:'年度 ',
						width:60,
						editable:false,
						allowBlank:false,
						align:'left',
						dataIndex:'YearName'
					}, {
						id:'Name',
						header:'项目名称',
						width:180,
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
						header:'参与人员位次信息',
						width:100,
						editable:false,
						align:'left',
						hidden:false,
						dataIndex:'ParticipantInfo',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
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
						id:'DataStatus',
						header:'提交状态',
						//xtype:'numbercolumn',
						width : 80,
						editable:false,
						hidden:'true',
						align:'center',
						dataIndex:'DataStatus'

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
						id:'ResAudit',
						header:'审核状态',
						width:80,
						editable:false,
						align:'left',
						dataIndex:'ResAudit'

					},{
						id:'ResDesc',
						header:'审核说明',
						width:120,
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
						id:'Remark',
						header:'备注',
						width:100,
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

					}]
		});


var AuditButton = new Ext.Toolbar.Button({
	text: '通过',  
	iconCls: 'pencil',
    handler:function(){
	//定义并初始化行对象
	var checker = session['LOGON.USERCODE'];
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	for(var j= 0; j< len; j++){
	     //alert(rowObj[j].get("RewardAmount"))
	   if(rowObj[j].get("ResAudit")!='等待审批')
	 {
		      Ext.Msg.show({title:'注意',msg:'数据已审核',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		       return;
	 }
	}
	function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    Ext.Ajax.request({
						url:projUrl+'?action=audit&&rowid='+rowObj[i].get("rowid")+'&usercode='+checker,
						waitMsg:'审核中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},   
						success: function(result, request){			
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0, limit:12,usercode:checker}});								
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
		Ext.MessageBox.confirm('提示','确实要审核所选记录吗?审核后不能修改',handler);
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
						if(rowObj[j].get("ResAudit")!='等待审批')
	       {
		      Ext.Msg.show({title:'注意',msg:'数据已审核',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		       return;
	       }else
						{noauditfun();}
					}
					
					
			   }
});

	itemGrid.addButton('-');
	itemGrid.addButton(AuditButton);
	itemGrid.addButton('-');
	itemGrid.addButton(NoAuditButton);

  itemGrid.btnResetHide(); 	//隐藏重置按钮
  itemGrid.btnDeleteHide(); //隐藏删除按钮
  itemGrid.btnPrintHide(); 	//隐藏打印按钮
  itemGrid.btnAddHide(); 	//隐藏添加按钮
  itemGrid.btnSaveHide(); 	//隐藏保存按钮
  itemGrid.load({params:{start:0, limit:12, usercode:usercode}});
 
 // 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//作者排名
	if (columnIndex ==6) {
		var records = itemGrid.getSelectionModel().getSelections();
		var authorinfo = records[0].get("ParticipantDRs");
		var title = records[0].get("Name");
		AuthorInfoList(title,authorinfo);
	}
}); 

//uploadMainFun(itemGrid,'rowid','P005',24);
downloadMainFun(itemGrid,'rowid','P008',7);