var userdr = session['LOGON.USERCODE'];
var groupdesc = session['LOGON.GROUPDESC'];

if (groupdesc=="���й���ϵͳ(��Ϣ�޸�)")
{ 
	userdr="";
}
if (groupdesc=="���й���ϵͳ(��Ϣ��ѯ)")
{ 
	userdr="";
}

var projUrl='herp.srm.srmprosoliauditexe.csp';

Date.dayNames = ["��", "һ", "��", "��", "��", "��", "��"];  
    Date.monthNames=["1��","2��","3��","4��","5��","6��","7��","8��","9��","10��","11��","12��"];  
    if (Ext.DatePicker) {  
        Ext.apply(Ext.DatePicker.prototype, {  
            todayText: "����",  
            minText: "��������С����֮ǰ",  
            maxText: "�������������֮��",  
            disabledDaysText: "",  
            disabledDatesText: "",  
            monthNames: Date.monthNames,  
            dayNames: Date.dayNames,  
            nextText: '���� (Control+Right)',  
            prevText: '���� (Control+Left)',  
            monthYearText: 'ѡ��һ���� (Control+Up/Down ���ı���)',  
            todayTip: "{0} (Spacebar)",  
            okText: "ȷ��",  
            cancelText: "ȡ��" 
        });  
 }  
/////////////////����ʱ��///////////////////////
var StartDateField = new Ext.form.DateField({
			fieldLabel: '��������',
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
			fieldLabel: '��������',
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
/////////////////���///////////////////////
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
	fieldLabel: '���',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:YearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ�����...',
	name: 'YearCombo',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

/////////////////��Ŀ��Դ///////////////////
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
	fieldLabel: '��Ŀ��Դ',
	width:120,
	listWidth : 250,
	allowBlank: true,
	store:SubSourceDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ����Ŀ��Դ...',
	name: 'SubSourceCombo',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
*/
 ///��Ŀ��Դ
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
			fieldLabel : '��Ŀ��Դ',
			store : SubSourceDs,
			displayField : 'Name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			//emptyText : '��ѡ����Ŀ��Դ...',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});

/////////////////��Ŀ����///////////////////
var TitleField = new Ext.form.TextField({
				id: 'TitleField',
                width: 120,
                allowBlank: true,
                name: 'TitleField',
                fieldLabel: '��Ŀ����',
                blankText: '��Ŀ����'
                
            });
            
//////������
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
		
/////////////////�������///////////////////////////
var AuditStateStore = new Ext.data.SimpleStore({
	fields:['key','keyvalue'],
	data:[['1','�ȴ�����'],['2','��ͨ��'],['3','δͨ��']]
});

var AuditStateCombo = new Ext.form.ComboBox({
	id: 'AuditStateCombo',
	fieldLabel: '��˽��',
	width:120,
	listWidth : 120,
	allowBlank: true,
	store:AuditStateStore,
	valueField: 'key',
	displayField: 'keyvalue',
	triggerAction: 'all',
	//emptyText:'��ѡ����˽��...',
	mode : 'local',
	name: 'AuditStateCombo',
	minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});


////////////////רҵ�����///////////////////
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
			fieldLabel : 'רҵ�����',
			width : 120,
			listWidth : 260,
			selectOnFocus : true,
			allowBlank : false,
			store : ExpertDs,
			//anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			//mode : 'local', // ����ģʽ
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
/* ////////////////���������--��ѡ��///////////////////
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
			fieldLabel : '���������',
			width : 120,
			listWidth : 250,
			selectOnFocus : true,
			allowBlank : false,
			store : ExpertDs,
			//anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			//mode : 'local', // ����ģʽ
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
            EthicExpertCombo.selectAll(); //ȫѡ  
    });   */
	
////////////////���������///////////////////
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
			fieldLabel : '���������',
			width : 120,
			listWidth : 260,
			selectOnFocus : true,
			allowBlank : false,
			store : ExpertDs,
			//anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			//mode : 'local', // ����ģʽ
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			disabled : false
		});

/////////////////��ѯ��ť��Ӧ����//////////////
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
    
    if ((groupdesc=="���й���ϵͳ(��Ϣ�޸�)")||(groupdesc=="���й���ϵͳ(��Ϣ��ѯ)"))
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
	title : '��Ŀ�������д���˲�ѯ',
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
					value : '<p style="text-align:right;">���</p>',
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
					value : '<p style="text-align:right;">������</p>',
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
					value : '<p style="text-align:right;">��������</p>',
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
					value : '<p style="text-align:center;">��</p>',
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
					text : '��ѯ',
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
					value : '<p style="text-align:right;">��Ŀ����</p>',
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
					value : '<p style="text-align:right;">��Ŀ��Դ</p>',
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
					value : '<p style="text-align:right;">�������</p>',
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
			title: '��Ŀ�������д���˲�ѯ�б�',
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
						header:'��� ',
						width:80,
						editable:false,
						allowBlank:false,
						align:'left',
						dataIndex:'Year'
					},{
						id:'Title',
						header:'��Ŀ����',
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
						header:'��Ŀ��Դ',
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
						header:'�Ƿ��������',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'IsEthic'
					},{
							id:'upload',
							header: '�ϴ�',
							allowBlank: false,
							width:40,
							editable:false,
							hidden:true,
							dataIndex: 'upload',
							renderer : function(v, p, r){			
							return '<span style="color:blue"><u>�ϴ�</u></span>';
							}
					},{
							id:'download',
							header: '����',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>����</u></span>';
					    } 
					},{
						id:'SubUser',
						header:'������',
						editable:false,
						width:80,
						align:'left',
						dataIndex:'SubUser'
					},{
						id:'SubDeptDr',
						header:'�����˿���',
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
						header:'����ʱ��',
						width:80,
						editable:false,
						align:'left',
						dataIndex:'SubDate'
					},{
						id:'PreAuditState',
						header:'Ԥ��״̬',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'PreAuditState'
					},{
						id:'Expert',
						header:'רҵ�����',
						width:150,
						dataIndex:'Expert'
						//type:ExpertCombo
					},{
						id:'PSGDataStatus',
						header:'רҵ����״̬',
						width:180,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'PSGDataStatus'
					},{
						id:'ExpertGradeInfo',
						header : 'רҵ��˽��',
						width:100,
						hidden : false,
						editable:false,
						align:'center',
						dataIndex:'ExpertGradeInfo',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store)
						{ 
						    /* if(record.get('PSGDataStatus')=="���ύ"){
								return '<span style="color:blue;cursor:hand"><BLINK id="check" onclick=viewFun();>'+value+'</BLINK></span>'+'<b> </b>';  
							}else{
								return '<span style="color:gray;cursor:hand"><BLINK id="check" >'+value+'</BLINK></span>'+'<b> </b>';  
							} */
							return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';	
						}	 
					},/* {
						id:'EthicExpert',
						header:'���������',
						width:150,
						dataIndex:'EthicExpert'
						//type:EthicExpertCombo
					}, */{
						id:'PSEADataStatus',
						header:'��������״̬',
						width:180,
						editable:false,
						align:'left',
						dataIndex:'PSEADataStatus',
						hidden:true
					},{
						id:'EthicChkResult',
						header:'������˽��',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'EthicChkResult'/* ,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						} */
					},{
						id:'OutExpertResult',
						header:'Ժ��ר����˽��',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'OutExpertResult'
					},{
						id:'OutEthicResult',
						header:'Ժ��������˽��',
						width:100,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'OutEthicResult'
					},{
						id:'OutCheckResult',
						header:'�鿴Ժ����˽��',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'OutCheckResult',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						}
					},{
						id:'DataStatus',
						header:'�ύ״̬',
						width:80,
						editable:false,
						align:'left',
						dataIndex:'DataStatus'
					},{
						id:'AuditStatus',
						header:'����״̬',
						width:80,
						editable:false,
						align:'left',
						dataIndex:'AuditStatus'
					},{
						id:'ChkDesc',
						header:'�������',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'ChkDesc'
					},{
						id:'IsAllot',
						header:'�Ƿ��ѷ���',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'IsAllot'
					},{
						id:'EthicChkInfo',
						header:'�����������',
						width:100,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'EthicChkInfo'
					}]
		});

////////////////���䰴ť//////////////////////////
var allotProSoliInfoButton  = new Ext.Toolbar.Button
({
		text: '����',        
		iconCls: 'pencil',
		handler: function()
		{
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length; 
			if(len < 1)
			{
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				var state = rowObj[0].get("AuditStatus");	
				var isallot = rowObj[0].get("IsAllot");	
				if(((isallot==0)&(state == "�ȴ�����"))||(groupdesc=="���й���ϵͳ(��Ϣ�޸�)"))
				{
					allotFun();
				}				
				else {Ext.Msg.show({title:'����',msg:'�ѷ���ר����ˣ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}
			}
		}
});

////////////////���д�����Ԥ��ť//////////////////////////
var PreAuditButton  = new Ext.Toolbar.Button
({
		text: 'Ԥ��',        
		iconCls: 'pencil',
		id: 'PreAuditButton',
		handler: function()
		{		
			var rowObj=itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if(len < 1)
			{			
				Ext.Msg.show({title:'ע��',msg:'��ѡ����ҪԤ�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			for(var j= 0; j < len; j++)
			{
				if(rowObj[j].get("PreAuditState")=='Ԥ��-���ͨ��')
				{		
					Ext.Msg.show({title:'ע��',msg:'Ԥ�������ͨ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				else
				{
					preauditfun();
				}
			}
		}
});

////////////////ͨ����ť//////////////////////////
var auditProSoliInfoButton  = new Ext.Toolbar.Button
({
		text: 'ͨ��',        
		iconCls: 'pencil',
		id: 'auditProSoliInfoButton',
		handler: function()
		{		
		
		
			var rowObj=itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if(len < 1)
			{			
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			for(var j= 0; j < len; j++)
			{
				if(rowObj[j].get("AuditStatus")!='�ȴ�����')
				{		
					Ext.Msg.show({title:'ע��',msg:'���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
							waitMsg:'�����...',
							failure: function(result, request){Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});},
							success: function(result, request)
							{
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true')
								{
									Ext.Msg.show({title:'ע��',msg:'��˳ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0,limit:25}});							
								}
								else
								{								
									Ext.Msg.show({title:'����',msg:'���ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
			Ext.MessageBox.confirm('��ʾ','ȷʵҪ��˸�����¼��?',handler);
		}
	
});

////////////////��ͨ����ť//////////////////////////
var noauditProSoliInfoButton = new Ext.Toolbar.Button
({	
		text : '��ͨ��',
		iconCls: 'pencil',
		id: 'noauditProSoliInfoButton',
		handler : function()
		{			
			var rowObj=itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if(len < 1)
			{			
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			for(var j= 0; j < len; j++)
			{
				if(rowObj[j].get("AuditStatus")!='�ȴ�����')
				{		
					Ext.Msg.show({title:'ע��',msg:'���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				else
				{
					noauditprosoliinfofun();
				}
			}
		}
});

////////////�鿴רҵ��˽����ť////////////
var ViewProSoliInfoButton  = new Ext.Toolbar.Button
({
		text: '�鿴רҵ��˽��',        
		iconCls: 'option',
		handler: function()
		{
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length; 
			if(len < 1)
			{
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�鿴����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				var viewrowid = rowObj[0].get("rowid");		
				viewFun(viewrowid);			
			}
		}
});
////////////���Ժ����˽��////////////
var AddOutExpertChkButton  = new Ext.Toolbar.Button
({
		text: '���Ժ����˽��',        
		iconCls: 'option',
		handler: function()
		{
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length; 
			if(len < 1)
			{
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�鿴����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				var viewrowid = rowObj[0].get("rowid");		
				AddOutExpertChk(viewrowid);			
			}
		}
});

 itemGrid.btnResetHide(); 	//�������ð�ť
  itemGrid.btnDeleteHide(); //����ɾ����ť
  itemGrid.btnPrintHide(); 	//���ش�ӡ��ť
  itemGrid.btnAddHide(); 	//������Ӱ�ť
  itemGrid.btnSaveHide(); 	//���ر��水ť
 
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
  
 // ����gird�ĵ�Ԫ���¼�
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
	if(IsEthic=="��")
	{
		//Ext.getCmp('EthicExpertCombo').enable();
		PreAuditButton.enable();
		if((PSGDataStatus!='���ύ')||(PSEADataStatus!='���ύ'))
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
		if(PSGDataStatus!='���ύ')
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
 
if (groupdesc=="���й���ϵͳ(��Ϣ�޸�)")
{
	
}
if (groupdesc=="���й���ϵͳ(��Ϣ��ѯ)")
{

}




uploadMainFun(itemGrid,'rowid','P011',7);
downloadMainFun(itemGrid,'rowid','P011',8);
