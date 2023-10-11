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

var projUrl='herp.srm.srmprosoliauditexe.csp';

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
			selectOnFocus : true
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
            
//////申请人
var userDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

userDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=applyerList'+'&str='+encodeURIComponent(Ext.getCmp('userCombo').getRawValue()), 
						method : 'POST'
					});
		});

var userCombo = new Ext.form.ComboBox({
            id:'userCombo',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
		
/////////////////审批结果///////////////////////////
var AuditStateStore = new Ext.data.SimpleStore({
	fields:['key','keyvalue'],
	data:[['1','等待审批'],['2','已通过'],['3','未通过']]
});

var AuditStateCombo = new Ext.form.ComboBox({
	id: 'AuditStateCombo',
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
	name: 'AuditStateCombo',
	minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});


////////////////专业审核人///////////////////
var ExpertDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
ExpertDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=applyerList'+'&str='+encodeURIComponent(Ext.getCmp('ExpertCombo').getRawValue()),
						method : 'POST'
					});
		});
var ExpertCombo = new Ext.form.ComboBox({
            id:'ExpertCombo',
			name:'ExpertCombo',
			fieldLabel : '专业审核人',
			width : 120,
			listWidth : 260,
			selectOnFocus : true,
			allowBlank : false,
			store : ExpertDs,
			//anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			//mode : 'local', // 本地模式
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
/* ////////////////伦理审核人--多选框///////////////////
var EthicExperttDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
EthicExperttDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=applyerList'+'&str='+encodeURIComponent(Ext.getCmp('EthicExpertCombo').getRawValue()),
						method : 'POST'
					});
		});
var str="";
var EthicExpertCombo = new Ext.form.MultiSelect({
            id:'EthicExpertCombo',
			name:'EthicExpertCombo',
			fieldLabel : '伦理审核人',
			width : 120,
			listWidth : 250,
			selectOnFocus : true,
			allowBlank : false,
			store : ExpertDs,
			//anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			//mode : 'local', // 本地模式
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			disabled : false,
			listeners:{"select":function(combo,record,index){ 
				if  (str="")
				{	
					str=EthicExpertCombo.getValue();
				}
				else 
				{
					str=str+EthicExpertCombo.getValue();
				}
				alert(str);
			}
			}
		});
EthicExperttDs.on('load', function ()   
    {  
            EthicExpertCombo.selectAll(); //全选  
    });   */
	
////////////////伦理审核人///////////////////
var EthicExperttDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
EthicExperttDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=applyerList'+'&str='+encodeURIComponent(Ext.getCmp('EthicExpertCombo').getRawValue()),
						method : 'POST'
					});
		});
var EthicExpertCombo = new Ext.form.ComboBox({
            id:'EthicExpertCombo',
			name:'EthicExpertCombo',
			fieldLabel : '伦理审核人',
			width : 120,
			listWidth : 260,
			selectOnFocus : true,
			allowBlank : false,
			store : ExpertDs,
			//anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			//mode : 'local', // 本地模式
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			disabled : false
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
    var SubUser = userCombo.getValue();
    var AuditStatus = AuditStateCombo.getValue();
    
    if ((groupdesc=="科研管理系统(信息修改)")||(groupdesc=="科研管理系统(信息查询)"))
	{ 
		userdr="";
	}
	itemGrid.load({params:{start:0,limit:25,Startdate:Startdate,Enddate:Enddate,Year:Year,SubSource:SubSource,Title:Title,SubUser:SubUser,AuditStatus:AuditStatus}});	
}

//////////////////////////////////////////////
var queryPanel = new Ext.FormPanel
({
	autoHeight : true,
	region : 'north',
	frame : true,
	title : '项目征集科研处审核查询',
	iconCls : 'search',	

	defaults : {
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
					value : '<p style="text-align:right;">申请人</p>',
					width : 60
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				userCombo,
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
				SubSourceCombo,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">审批结果</p>',
					width : 60
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				AuditStateCombo,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				}
			]
		}
	]	
});

var itemGrid = new dhc.herp.Grid({
			region : 'center',
			title: '项目征集科研处审核查询列表',
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
						id:'Year',
						header:'年度 ',
						width:80,
						editable:false,
						allowBlank:false,
						align:'left',
						dataIndex:'Year'
					},{
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
						width:100,
						editable:false,
						align:'left',
						dataIndex:'IsEthic'
					},{
							id:'upload',
							header: '上传',
							allowBlank: false,
							width:40,
							editable:false,
							hidden:true,
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
						width:80,
						align:'left',
						dataIndex:'SubUser'
					},{
						id:'SubDeptDr',
						header:'申请人科室',
						width:80,
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
						width:80,
						editable:false,
						align:'left',
						dataIndex:'SubDate'
					},{
						id:'PreAuditState',
						header:'预审状态',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'PreAuditState'
					},{
						id:'Expert',
						header:'专业审核人',
						width:150,
						dataIndex:'Expert'
						//type:ExpertCombo
					},{
						id:'PSGDataStatus',
						header:'专业审批状态',
						width:180,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'PSGDataStatus'
					},{
						id:'ExpertGradeInfo',
						header : '专业审核结果',
						width:100,
						hidden : false,
						editable:false,
						align:'center',
						dataIndex:'ExpertGradeInfo',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store)
						{ 
						    /* if(record.get('PSGDataStatus')=="已提交"){
								return '<span style="color:blue;cursor:hand"><BLINK id="check" onclick=viewFun();>'+value+'</BLINK></span>'+'<b> </b>';  
							}else{
								return '<span style="color:gray;cursor:hand"><BLINK id="check" >'+value+'</BLINK></span>'+'<b> </b>';  
							} */
							return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';	
						}	 
					},/* {
						id:'EthicExpert',
						header:'伦理审核人',
						width:150,
						dataIndex:'EthicExpert'
						//type:EthicExpertCombo
					}, */{
						id:'PSEADataStatus',
						header:'伦理审批状态',
						width:180,
						editable:false,
						align:'left',
						dataIndex:'PSEADataStatus',
						hidden:true
					},{
						id:'EthicChkResult',
						header:'伦理审核结果',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'EthicChkResult'/* ,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						} */
					},{
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
						width:100,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'OutEthicResult'
					},{
						id:'OutCheckResult',
						header:'查看院外审核结果',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'OutCheckResult',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						}
					},{
						id:'DataStatus',
						header:'提交状态',
						width:80,
						editable:false,
						align:'left',
						dataIndex:'DataStatus'
					},{
						id:'AuditStatus',
						header:'审批状态',
						width:80,
						editable:false,
						align:'left',
						dataIndex:'AuditStatus'
					},{
						id:'ChkDesc',
						header:'审批意见',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'ChkDesc'
					},{
						id:'IsAllot',
						header:'是否已分配',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'IsAllot'
					},{
						id:'EthicChkInfo',
						header:'伦理审批结果',
						width:100,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'EthicChkInfo'
					}]
		});

////////////////分配按钮//////////////////////////
var allotProSoliInfoButton  = new Ext.Toolbar.Button
({
		text: '分配',        
		iconCls: 'pencil',
		handler: function()
		{
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length; 
			if(len < 1)
			{
				Ext.Msg.show({title:'提示',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				var state = rowObj[0].get("AuditStatus");	
				var isallot = rowObj[0].get("IsAllot");	
				if(((isallot==0)&(state == "等待审批"))||(groupdesc=="科研管理系统(信息修改)"))
				{
					allotFun();
				}				
				else {Ext.Msg.show({title:'警告',msg:'已分配专家审核！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}
			}
		}
});

////////////////科研处主任预审按钮//////////////////////////
var PreAuditButton  = new Ext.Toolbar.Button
({
		text: '预审',        
		iconCls: 'pencil',
		id: 'PreAuditButton',
		handler: function()
		{		
			var rowObj=itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if(len < 1)
			{			
				Ext.Msg.show({title:'注意',msg:'请选择需要预审的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			for(var j= 0; j < len; j++)
			{
				if(rowObj[j].get("PreAuditState")=='预审-审核通过')
				{		
					Ext.Msg.show({title:'注意',msg:'预审已审核通过',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				else
				{
					preauditfun();
				}
			}
		}
});

////////////////通过按钮//////////////////////////
var auditProSoliInfoButton  = new Ext.Toolbar.Button
({
		text: '通过',        
		iconCls: 'pencil',
		id: 'auditProSoliInfoButton',
		handler: function()
		{		
		
		
			var rowObj=itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if(len < 1)
			{			
				Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			for(var j= 0; j < len; j++)
			{
				if(rowObj[j].get("AuditStatus")!='等待审批')
				{		
					Ext.Msg.show({title:'注意',msg:'数据已审核',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
			}
			function handler(id)
			{
				if(id=="yes")
				{								
					for(var i = 0; i < len; i++)
					{
				    	Ext.Ajax.request
				    	({ 	
				    		url:projUrl+'?action=audit&&rowid='+rowObj[i].get("rowid"),
							waitMsg:'审核中...',
							failure: function(result, request){Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});},
							success: function(result, request)
							{
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true')
								{
									Ext.Msg.show({title:'注意',msg:'审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0,limit:25}});							
								}
								else
								{								
									Ext.Msg.show({title:'错误',msg:'审核失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
					}
				}
				else
				{
					return;
				}
			}
			Ext.MessageBox.confirm('提示','确实要审核该条记录吗?',handler);
		}
	
});

////////////////不通过按钮//////////////////////////
var noauditProSoliInfoButton = new Ext.Toolbar.Button
({	
		text : '不通过',
		iconCls: 'pencil',
		id: 'noauditProSoliInfoButton',
		handler : function()
		{			
			var rowObj=itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if(len < 1)
			{			
				Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			for(var j= 0; j < len; j++)
			{
				if(rowObj[j].get("AuditStatus")!='等待审批')
				{		
					Ext.Msg.show({title:'注意',msg:'数据已审核',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				else
				{
					noauditprosoliinfofun();
				}
			}
		}
});

////////////查看专业审核结果按钮////////////
var ViewProSoliInfoButton  = new Ext.Toolbar.Button
({
		text: '查看专业审核结果',        
		iconCls: 'option',
		handler: function()
		{
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length; 
			if(len < 1)
			{
				Ext.Msg.show({title:'提示',msg:'请选择需要查看的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				var viewrowid = rowObj[0].get("rowid");		
				viewFun(viewrowid);			
			}
		}
});
////////////添加院外审核结果////////////
var AddOutExpertChkButton  = new Ext.Toolbar.Button
({
		text: '添加院外审核结果',        
		iconCls: 'option',
		handler: function()
		{
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length; 
			if(len < 1)
			{
				Ext.Msg.show({title:'提示',msg:'请选择需要查看的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				var viewrowid = rowObj[0].get("rowid");		
				AddOutExpertChk(viewrowid);			
			}
		}
});

 itemGrid.btnResetHide(); 	//隐藏重置按钮
  itemGrid.btnDeleteHide(); //隐藏删除按钮
  itemGrid.btnPrintHide(); 	//隐藏打印按钮
  itemGrid.btnAddHide(); 	//隐藏添加按钮
  itemGrid.btnSaveHide(); 	//隐藏保存按钮
 
 var usercode1=session['LOGON.USERCODE'];
if(usercode1!="demo"){
  
  itemGrid.addButton('-');
  itemGrid.addButton(allotProSoliInfoButton);
  itemGrid.addButton('-');
  itemGrid.addButton(auditProSoliInfoButton);
  itemGrid.addButton('-');
  itemGrid.addButton(noauditProSoliInfoButton);
}
else{
  itemGrid.addButton('-');
  itemGrid.addButton(PreAuditButton); 
  
  itemGrid.addButton('-');
  itemGrid.addButton(allotProSoliInfoButton);
  itemGrid.addButton('-');
  itemGrid.addButton(auditProSoliInfoButton);
  itemGrid.addButton('-');
  itemGrid.addButton(noauditProSoliInfoButton);
  }


 
  itemGrid.load({params:{start:0, limit:12}});
  
 // 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e)
{
	var records = itemGrid.getSelectionModel().getSelections();
	var IsEthic = records[0].get("IsEthic");
	var rowid = records[0].get("rowid");
	var title = records[0].get("Title");
	var subuser = records[0].get("SubUser");
	
	var PSGDataStatus = records[0].get("PSGDataStatus");
	var PSEADataStatus = records[0].get("PSEADataStatus");
	
    var IsAllot = records[0].get("IsAllot");
    var EthicChkInfo = records[0].get("EthicChkInfo");

	if (IsAllot!=1)
	{
		auditProSoliInfoButton.disable();
		noauditProSoliInfoButton.disable();
		//return;
	}
	else 
	{
		auditProSoliInfoButton.enable();
		noauditProSoliInfoButton.enable();
		//return;
	}
	if(IsEthic=="是")
	{
		//Ext.getCmp('EthicExpertCombo').enable();
		PreAuditButton.enable();
		if((PSGDataStatus!='已提交')||(PSEADataStatus!='已提交'))
		{
			auditProSoliInfoButton.disable();
			noauditProSoliInfoButton.disable();
			//return;
		}
		else
		{
			auditProSoliInfoButton.enable();
			noauditProSoliInfoButton.enable();
			/* if(EthicChkInfo==3)
			{
				auditProSoliInfoButton.disable();
			} */
			//return;
		}		
	} 
	else
	{
		//Ext.getCmp('EthicExpertCombo').disable();
		PreAuditButton.disable();
		if(PSGDataStatus!='已提交')
		{
			auditProSoliInfoButton.disable();
			noauditProSoliInfoButton.disable();
			//return;
		}
		else
		{		
			auditProSoliInfoButton.enable();
			noauditProSoliInfoButton.enable();
			if(EthicChkInfo==3)
			{
				auditProSoliInfoButton.disable();
			}
			//return;
		}
	}
	if(columnIndex==15){
		ExpertAuditList(rowid,title,subuser)
	}
	/* if(columnIndex==17){
		EthicAuditList(rowid,title,subuser)
	} */
	 if(columnIndex==20){
		AddOutExpertChk(rowid);
	} 
}); 
 
if (groupdesc=="科研管理系统(信息修改)")
{
	
}
if (groupdesc=="科研管理系统(信息查询)")
{

}




uploadMainFun(itemGrid,'rowid','P011',7);
downloadMainFun(itemGrid,'rowid','P011',8);
