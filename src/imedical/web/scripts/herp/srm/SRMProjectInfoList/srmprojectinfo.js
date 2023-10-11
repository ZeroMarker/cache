var userdr = session['LOGON.USERCODE'];  
var projUrl = 'herp.srm.srmprojectinfoexe.csp';
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
// ������ʼʱ��ؼ�
	var ProSField = new Ext.form.DateField({
		id : 'ProSField',
		//format : 'Y-m-d',
		width : 120,
		//allowBlank : false,
		emptyText : ''
	});
	var ProEField = new Ext.form.DateField({
		id : 'ProEField',
		//format : 'Y-m-d',
		width : 120,
		emptyText : ''
		
	});
////////////////��������/////////////////
var deptDs = new Ext.data.Store({
			autoLoad:true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'Name'])
		});

deptDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=deptList&str='+encodeURIComponent(Ext.getCmp('DeptCombo').getRawValue()), 
                        method:'POST'
					});
		});

var DeptCombo = new Ext.form.ComboBox({
			id: 'DeptCombo',
			fieldLabel : '��������',
			store : deptDs,
			displayField : 'Name',
			valueField : 'rowid',
			typeAhead : true,
			name: 'DeptCombo',
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 220,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});


//////////////////������Դ//////////////////////  
var sourceDs = new Ext.data.Store({
			autoLoad:true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'Name'])
		});

sourceDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=sourceList&str='+encodeURIComponent(Ext.getCmp('SourceCombo').getRawValue()),
						method : 'POST'
					});
		});

var SourceCombo = new Ext.form.ComboBox({
			id: 'SourceCombo',
			fieldLabel : '������Դ ',
			store : sourceDs,
			displayField : 'Name',
			valueField : 'rowid',
			typeAhead : true,
			name: 'SourceCombo',
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 110,
			listWidth : 220,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
	
		
/////////////////���⸺����/////////////////		
var userDs = new Ext.data.Store({
			autoLoad:true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'Name'])
		});

userDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=userList&str='+encodeURIComponent(Ext.getCmp('SourceCombo').getRawValue()),
						method : 'POST'
					});
		});
var HeadCombo = new Ext.form.ComboBox({
			id: 'HeadCombo',
			fieldLabel : '���⸺���� ',
			store : userDs,
			displayField : 'Name',
			valueField : 'rowid',
			typeAhead : true,
			name: 'HeadCombo',
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 220,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
///////////////////��������/////////////
var NameText = new Ext.form.TextField({
			id: 'NameField',
			fieldLabel: '��������',
			emptyText: '',
			name: 'NameField',
			anchor:'95%'
			
		});

/////////////////// ��ѯ��ť//////////// 
function srmProjectInfoList(){
	    var StartDate= ProSField.getValue();
	    if (StartDate!=="")
	    {
	       //StartDate=StartDate.format ('Y-m-d');
	    }
	    //alert(startdate);
	    var EndDate = ProEField.getValue();
	    if (EndDate!=="")
	    {
	       //EndDate=EndDate.format ('Y-m-d');
	    }
	    //alert(enddate);
	    var DeptDr  = DeptCombo.getValue();
	    var SubSource = SourceCombo.getValue(); 
	    var Head = HeadCombo.getValue();
	    var Name = NameText.getValue();
		itemGrid.load({
		    params:{
		    start:0,
		    limit:25,
		    StartDate:StartDate,
		    EndDate:EndDate,
		    DeptDr:DeptDr,
		    SubSource:SubSource,
		    Head:Head,
		    Name:Name,
		    userdr:userdr
		   }
	  });
  }


var queryPanel = new Ext.FormPanel({
			height:150,
			region:'north',
			frame:true,
			defaults: {bodyStyle:'padding:5px'},
				items:[{
				xtype: 'panel',
				layout:"column",
				items: [
					{   
						xtype:'displayfield',
						value:'<center><p style="font-weight:bold;font-size:150%">��Ŀ�м���ϲ�ѯ</p></center>',
						columnWidth:1,
						height:'50'
					}]
			    },{
			    columnWidth:1,
			    xtype: 'panel',
				layout:"column",
				items: [
					{
						xtype:'displayfield',
						value:'����ʱ��:',
						columnWidth:.08
					},
					ProSField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.01
					},
					{
						xtype:'displayfield',
						value:' ��',
						columnWidth:.04
					},
					ProEField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.1
					},{
						xtype:'displayfield',
						value:'����:',
						columnWidth:.053
					},
					DeptCombo,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.08
					},{
						xtype:'displayfield',
						value:'������Դ:',
						columnWidth:.08
					},
					SourceCombo
					]
			    },{
				xtype: 'panel',
				layout:"column",
				items: [
					{
						xtype:'displayfield',
						value:'���⸺����:',
						columnWidth:.08
					},
					HeadCombo,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.08
					},
					{
						xtype:'displayfield',
						value:'��������:',
						columnWidth:.08
					},
					NameText,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.2
					},{
						columnWidth:0.05,
						xtype:'button',
						text: '��ѯ',
						handler:function(b){
							srmProjectInfoList();
						},
						iconCls: 'find'
					}		
				]
			}
			]
		});

var itemGrid = new dhc.herp.Grid({
		    region : 'center',
		    url: projUrl,
		    atLoad : true, // �Ƿ��Զ�ˢ��
			fields : [{
						header : '������Ϣ��ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
						id : 'Dept',
						header : '����',
						editable:false,
						align:'center',
						width : 80,
						dataIndex : 'Dept'
					},{
						id : 'Name',
						header : '��������',
						align:'center',
						width : 120,
						editable:false,
						dataIndex : 'Name'

					},{
						id : 'Head',
						header : '��Ŀ������',
						align:'center',
						editable:false,
						width : 120,
						dataIndex : 'Head'

					}, {
						id : 'Participants',
						header : '����μ���Ա',
						align:'center',
						editable:false,
						width : 120,
						dataIndex : 'Participants'
					}, {
						id : 'SubSource',
						header : '������Դ',
						align:'center',
						editable:false,
						width : 120,
						dataIndex : 'SubSource'
					},{
						id : 'RelyUnit',
						header : '�������е�λ',
						align:'center',
						width : 220,
						editable:false,
						dataIndex : 'RelyUnit'
					}, {
						id : 'AppFunds',
						header : '���뾭��(��Ԫ)',
						align:'center',
						width : 120,
						editable : false,
						dataIndex : 'AppFunds'
						
					},{
						id : 'GraFunds',
						header : '��׼����',
						align:'center',
						width : 120,
						editable:false,
						dataIndex : 'GraFunds'

					},{
						id : 'SubNo',
						header : '������',
						align:'center',
						width : 120,
						editable:false,
						dataIndex : 'SubNo'

					},{
						id : 'IssuedDate',
						header : '�����´�ʱ��',
						align:'center',
						width : 120,
						editable:false,
						dataIndex : 'IssuedDate'

					},{
						id : 'StartDate',
						header : '��ʼʱ��',
						align:'center',
						width : 120,
						editable:false,
						dataIndex : 'StartDate'

					},{
						id : 'EndDate',
						header : '��ֹʱ��',
						align:'center',
						width : 120,
						editable:false,
						dataIndex : 'EndDate'

					},{
						id : 'Remark',
						header : '��ע',
						align:'center',
						width : 150,
						editable:false,
						dataIndex : 'Remark'

					}]					
		});

  itemGrid.btnResetHide(); 	//�������ð�ť
  itemGrid.btnDeleteHide(); //����ɾ����ť
  itemGrid.btnPrintHide(); 	//���ش�ӡ��ť
  itemGrid.btnAddHide(); 	//�������ð�ť
  itemGrid.btnSaveHide(); 	//�������ð�ť
  itemGrid.load({params:{start:0, limit:12, userdr:userdr}});

