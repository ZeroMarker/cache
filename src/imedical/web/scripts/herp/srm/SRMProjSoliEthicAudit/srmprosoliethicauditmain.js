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

var projUrl='herp.srm.srmprosoliethicauditexe.csp';

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

 /////////////��Ŀ��Դ///////////////
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
			emptyText : '��ѡ����Ŀ��Դ...',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});

///////////////��Ŀ����///////////////////
var TitleField = new Ext.form.TextField({
				id: 'TitleField',
                width: 120,
                allowBlank: true,
                name: 'TitleField',
                fieldLabel: '��Ŀ����',
                blankText: '��Ŀ����'
                
            });
            
///////////////������/////////////
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
		

/////////////////��ѯ��ť//////////////

SeachButton
var SeachButton = new Ext.Toolbar.Button({
	text: '��ѯ',
	tooltip: '��ѯ',
	iconCls: 'search',
	handler: function(){
		var Startdate= StartDateField.getValue();
		var Enddate= EndDateField.getValue();
		/* if(Startdate!="")
		{
			Startdate.format("Y-m-d");
		};
		var Enddate= EndDateField.getValue()
		if(Enddate!="")
		{
			Enddate.format("Y-m-d");
		}; */
	
		var Year = YearCombo.getValue();
		var SubSource = SubSourceCombo.getValue();
		var Title = TitleField.getValue();
		var SubUser = userCombo.getValue();

		if ((groupdesc=="���й���ϵͳ(��Ϣ�޸�)")||(groupdesc=="���й���ϵͳ(��Ϣ��ѯ)"))
		{ 
			userdr="";
		}
		itemGrid.load({params:{start:0,limit:25,Startdate:Startdate,Enddate:Enddate,Year:Year,SubSource:SubSource,Title:Title,SubUser:SubUser,userdr:userdr}});	

	}
});
/*
//////////////////////////////////////////////
var queryPanel = new Ext.FormPanel({
	height : 130,
	region : 'north',
	frame : true,

	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<center><p style="font-weight:bold;font-size:100%">��Ŀ�����������</p></center>',
			columnWidth : 1,
			height : '32'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : '���:',
				columnWidth : .10
				},
				YearCombo,
				{
				xtype:'displayfield',
				value:'',
				columnWidth:.05
				},
				{
				xtype:'displayfield',
				value:'����ʱ��:',
				columnWidth:.085
				},
				StartDateField,
				{
				xtype:'displayfield',
				value:'',
				columnWidth:.02
				},
				{
				xtype:'displayfield',
				value:'��',
				columnWidth:.03
				},
				EndDateField,
				{
				xtype:'displayfield',
				value:'',
				columnWidth:.05
				},
				{
				xtype : 'displayfield',
				value : '������:',
				columnWidth : .07
				},
				userCombo]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : '��Ŀ����:',
				columnWidth : .07
				},
				TitleField,
				{
				xtype:'displayfield',
				value:'',
				columnWidth:.04
				},
				{
				xtype : 'displayfield',
				value : '��Ŀ��Դ:',
				columnWidth : .06
				},
				SubSourceCombo,
				{
				xtype:'displayfield',
				value:'',
				columnWidth:.04
				},
				{
				xtype:'displayfield',
				value:'',
				columnWidth:.05
				},
				{
				columnWidth:0.06,
				xtype:'button',
				text: '��ѯ',
				handler:function(b){SearchFun();},
				iconCls: 'find'
				}]
	}]
	
});
*/

var itemGrid = new dhc.herp.Grid({
			region : 'north',
			title: '��Ŀ����������˲�ѯ�б�',
			iconCls: 'list',
			height:300,
			layout:"fit",
			split : true,
			collapsible : true,
			containerScroll : true,
			url : projUrl,					
			fields : [
			 new Ext.grid.CheckboxSelectionModel({
				 //hidden:true,
				 editable:false
				 
				 }),
			{
						header:'ID',
						dataIndex:'prjrowid',
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
						width:220,
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
						width:180,
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
						width:120,
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
						dataIndex:'PreAuditDesc'
					},{   //
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
					}],
					tbar :['���',YearCombo,'-','ʱ��', StartDateField,'-','��',EndDateField,'-','������', userCombo, '-', '��Ŀ����',TitleField,'-','��Ŀ��Դ',SubSourceCombo,SeachButton]
		});


  itemGrid.btnDeleteHide(); //����ɾ����ť
  itemGrid.btnAddHide(); 	//������Ӱ�ť
  itemGrid.btnSaveHide(); 	//���ر��水ť
  itemGrid.load({params:{start:0, limit:12, userdr:userdr}});
 
 
 itemGrid.on('rowclick',function(grid,rowIndex,e){	
	row=rowIndex;
    var prjdr="";
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	prjdr=selectedRow[0].data['prjrowid'];
	//alert(Year);
	EthicResultGrid.load({params:{start:0, limit:25,prjrowid:prjdr}});	//,usercode:usercode
});

 /*
 // ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e)
{
	var records = itemGrid.getSelectionModel().getSelections();
	var IsEthic = records[0].get("IsEthic");
	var EthicChkResult = records[0].get("EthicChkResult");

	if(IsEthic=="��")
	{	
		if((EthicChkResult=='����ͨ��')||(EthicChkResult=='������ͨ��'))
		{
			submitProSoliInfoButton.enable();
			return;
		}
		else
		{
			submitProSoliInfoButton.disable();
			return;
		}		
	}
	else
	{
		return;
	}	
}); 
*/
downloadMainFun(itemGrid,'prjrowid','P011',9);
