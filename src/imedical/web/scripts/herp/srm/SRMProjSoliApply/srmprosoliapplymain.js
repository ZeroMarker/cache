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

var projUrl='herp.srm.srmprosoliapplyexe.csp';

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
			selectOnFocus : true,
			renderer: function formatQtip(data,metadata)
			{
				var title = "";
				var tip = data;
				metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
				return data;
			}
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

    if ((groupdesc=="���й���ϵͳ(��Ϣ�޸�)")||(groupdesc=="���й���ϵͳ(��Ϣ��ѯ)"))
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
	title : '��Ŀ����������Ϣ��ѯ',
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
				SubSourceCombo
			]
		}	
	]	
});

var itemGrid = new dhc.herp.Grid({
			region : 'center',
			title: '��Ŀ����������Ϣ��ѯ�б�',
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
						header:'��� ',
						width:80,
						editable:false,
						allowBlank:false,
						align:'left',
						dataIndex:'Year'
					}, {
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
						width:80,
						editable:false,
						align:'left',
						dataIndex:'IsEthic'
					},{
						id:'PreAuditState',
						header:'Ԥ��״̬',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'PreAuditState'
					},{
						id:'PreAuditDesc',
						header:'Ԥ�����',
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
						header:'�������״̬',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'EthicResult'
					},{
						id:'EthicAuditDesc',
						header:'����������',
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
						header:'רҵ������',
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
						header:'��Ŀ���������',
						width:120,
						editable:false,
						align:'left',
						dataIndex:'EthicExpert'

					}, */{
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
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'OutEthicResult'
					},{
						id:'OutCheckResult',
						header:'�鿴Ժ����˽��',
						width:120,
						editable:false,
						align:'left',
						dataIndex:'OutCheckResult',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						}
					}, {
							id:'upload',
							header: '�ϴ�',
							allowBlank: false,
							width:40,
							editable:false,
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
						width:120,
						align:'left',
						dataIndex:'SubUser'
					},{
						id:'SubDeptDr',
						header:'�����˿���',
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
						header:'����ʱ��',
						width:120,
						editable:false,
						align:'left',
						dataIndex:'SubDate'
					},{
						id:'DataStatus',
						header:'�ύ״̬',
						width:120,
						editable:false,
						align:'left',
						dataIndex:'DataStatus'
					},{
						id:'AuditStatus',
						header:'����״̬',
						width:120,
						editable:false,
						align:'left',
						dataIndex:'AuditStatus'
					},{
						id:'ChkDesc',
						header:'�������',
						width:120,
						editable:false,
						align:'left',
						dataIndex:'ChkDesc'
					},{
						id:'YearDR',
						header:'���ID',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'YearDR'
					},{
						id:'SubSourceDR',
						header:'��Ŀ��ԴID',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'SubSourceDR'
					},{
						id:'IsEthicDR',
						header:'�Ƿ��������ID',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'IsEthicDR'
					}]
		});


///////////////////��Ӱ�ť///////////////////////
var addProSoliInfoButton = new Ext.Toolbar.Button({
		text: '���',    
    	iconCls: 'edit_add',
		handler: function(){addFun();}
});

/////////////////�޸İ�ť/////////////////////////
var editProSoliInfoButton  = new Ext.Toolbar.Button({
		text: '�޸�',        
		iconCls: 'pencil',
		handler: function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length; 
			if(len < 1)
			{
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				var state = rowObj[0].get("DataStatus");		
				if((state == "δ�ύ")||(groupdesc=="���й���ϵͳ(��Ϣ�޸�)" ) ){editFun();}				
				else {Ext.Msg.show({title:'����',msg:'�������ύ���������޸ģ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}
			}
});

////////////////ɾ����ť//////////////////////////
var delProSoliInfoButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		iconCls: 'edit_remove',
		handler: function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if(len<1){
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫɾ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				for(var i = 0; i < len; i++){
				var state = rowObj[i].get("DataStatus");			
				if(state == "δ�ύ" ){delFun();}
				else {Ext.Msg.show({title:'����',msg:'�������ύ������ɾ����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}
});

///////////////�ύ��ť//////////////////////////
var subProSoliInfoButton = new Ext.Toolbar.Button({
		text:'�ύ',
		iconCls:'pencil',
		handler:function(){subFun();}	
});


/////////////////�ٴ��ύԤ��/////////////////////
var PresubmitButton = new Ext.Toolbar.Button({
		id:'submitButton',
		text: '�ٴ��ύԤ��',
        //tooltip:'�ύ',        
        iconCls: 'pencil',
		handler:function(){
		var rowObj = itemGrid.getSelectionModel().getSelections();
		
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�ٴ��ύԤ����ϵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			var prestate = rowObj[0].get("PreAuditState");   //��ȡԤ��״̬
			var datastatus = rowObj[0].get("DataStatus");    //��ȡ�ύ״̬
			if (datastatus!="���ύ"){
				Ext.Msg.show({title:'ע��',msg:'�����ύ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			if(prestate !="Ԥ��-���ͨ��"){
				var rowObj = itemGrid.getSelectionModel().getSelections();     // get the selected items
				var len = rowObj.length;
				if(len > 0)
				{  
					Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ�ύѡ������?�ύ�󲻿��޸ġ�����ɾ����', function(btn) 
					{
						if(btn == 'yes')
						{	
							if(rowObj[0].get("PreAuditDesc")!="Ԥ��-���ͨ��"){
								for(var i = 0; i < len; i++){     		
									Ext.Ajax.request({
										url: 'herp.srm.srmprosoliapplyexe.csp?action=presubmit&rowid='+rowObj[i].get("rowid"),
										waitMsg:'�ύ��...',
										failure: function(result, request) {
						            		Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
										success: function(result, request){
											var jsonData = Ext.util.JSON.decode( result.responseText );
											if (jsonData.success=='true') { 
												Ext.MessageBox.alert('��ʾ', '�ύ���');
												itemGrid.load({params:{start:0, limit:25}});
											}
											else {
												var message = "�ύʧ��";
												Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
											}
										},
										scope: this
									});
								}
							}else{
								Ext.Msg.show({title:'����',msg:'��ѡ���������Ԥ��ͨ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								//return;
							}
						}
					});	
				}
				else
				{
					Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�ύ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				}    
			}
			else {Ext.Msg.show({title:'����',msg:'��ѡ���������Ԥ��ͨ����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}				
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
  



  itemGrid.btnResetHide(); 	//�������ð�ť
  itemGrid.btnDeleteHide(); //����ɾ����ť
  itemGrid.btnPrintHide(); 	//���ش�ӡ��ť
  itemGrid.btnAddHide(); 	//������Ӱ�ť
  itemGrid.btnSaveHide(); 	//���ر��水ť
  itemGrid.load({params:{start:0, limit:12, SubUser:userdr}});
  
 // ����gird�ĵ�Ԫ���¼�
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
 
 if (groupdesc=="���й���ϵͳ(��Ϣ�޸�)")
{
	 addProSoliInfoButton.disable();//����Ϊ������
	 delProSoliInfoButton.disable();//����Ϊ������
	 subProSoliInfoButton.disable();//����Ϊ������	
}
if (groupdesc=="���й���ϵͳ(��Ϣ��ѯ)")
{
	 addProSoliInfoButton.disable();//����Ϊ������
	 editProSoliInfoButton.disable();
	 delProSoliInfoButton.disable();//����Ϊ������
	 subProSoliInfoButton.disable();//����Ϊ������	
}
uploadMainFun(itemGrid,'rowid','P011',15);
downloadMainFun(itemGrid,'rowid','P011',16);
