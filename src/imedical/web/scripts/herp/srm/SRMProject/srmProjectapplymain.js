
var userdr = session['LOGON.USERID'];
var username = session['LOGON.USERCODE'];	   

var projUrl = 'herp.srm.srmprojectsapplyexe.csp';

// ������ʼʱ��ؼ�
	var PSField = new Ext.form.DateField({
		id : 'PSField',
		//format : 'Y-m-d',
		width : 120,
		//allowBlank : false,
		emptyText : ''
	});

	var PEField = new Ext.form.DateField({
		id : 'PEField',
		//format : 'Y-m-d',
		width : 120,
		//allowBlank : false,
		emptyText : ''
	});
	
 ///��������
var deptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
deptDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=deptList', 
                        method:'POST'
					});
		});

var deptCombo = new Ext.form.ComboBox({
			fieldLabel : '��������',
			store : deptDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});

 ///������Դ
var SubSourceDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
SubSourceDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=sourceList', 
                        method:'POST'
					});
		});

var SubSourceCombo = new Ext.form.ComboBox({
			fieldLabel : '������Դ',
			store : SubSourceDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});

///////////////////�����������
var ChkResultStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '�ȴ�����'], ['1', 'ͨ��'], ['2', '��ͨ��']]
		});
var ChkResultField = new Ext.form.ComboBox({
			fieldLabel : '�����������',
			width : 120,
			listWidth : 120,
			selectOnFocus : true,
			allowBlank : false,
			store : ChkResultStore,
			anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});

//////���⸺����
var userDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

userDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=applyerList',
						method : 'POST'
					});
		});

var userCombo = new Ext.form.ComboBox({
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
		
// ////////////��������
var titleText = new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});
		

/////////////////// ��ѯ��ť 
function srmFundApply(){
		var startdate= PSField.getValue();
	    if (startdate!=="")
	    {
	       //startdate=startdate.format ('Y-m-d');
	    }
	    var enddate= PEField.getValue();
	    if (enddate!=="")
	    {
	       //enddate=enddate.format ('Y-m-d');
	    }
	    var dept  = deptCombo.getValue();
	    var SubSource= SubSourceCombo.getValue();
	    var ResAudit  = ChkResultField.getValue();
	    var HeadDr= userCombo.getValue();
	    var PName = titleText.getValue();     
		itemGrid.load({
		    params:{
		    start:0,
		    limit:25,   
		    ApplyStart: startdate,
		    Applyend: enddate,
		    deptdr: dept,
		    SubSource: SubSource,
		    ResAudit: ResAudit,
		    HeadDr: HeadDr,
		    PName: PName   
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
						value:'<center><p style="font-weight:bold;font-size:150%">��Ŀ�������</p></center>',
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
						columnWidth:.1
					},
					PSField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.06
					},{
						xtype:'displayfield',
						value:'��',
						columnWidth:.07
					},
					PEField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.1
					},{
						xtype:'displayfield',
						value:'����:',
						columnWidth:.08
					},
					deptCombo,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.05
					},{
						xtype:'displayfield',
						value:'������Դ:',
						columnWidth:.1
					},
					SubSourceCombo
					]
			    },{
				xtype: 'panel',
				layout:"column",
				items: [
					{
						xtype:'displayfield',
						value:'���״̬:',
						columnWidth:.09
					},
					ChkResultField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.02
					},
					{
						xtype:'displayfield',
						value:'���⸺����:',
						columnWidth:.09
					},
					userCombo,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.05
					},
					{
						xtype:'displayfield',
						value:'��������:',
						columnWidth:.1
					},
					titleText,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.05
					},
					{
						columnWidth:0.05,
						xtype:'button',
						text: '��ѯ',
						handler:function(b){
							srmFundApply();
						},
						iconCls: 'add'
					}		
				]
			}
			]
		});

var itemGrid = new dhc.herp.Grid({
		    //title: '������������',
		    region : 'center',
		    url: projUrl,
		    atLoad : true, // �Ƿ��Զ�ˢ��
			fields : [
			      new Ext.grid.CheckboxSelectionModel({editable:false}),
			       {
						header : '����ID',
						dataIndex : 'rowid',
						hidden : true
					},{
						id : 'Dept',
						header : '����',
						width : 120,
						editable:false,
						dataIndex : 'Dept'

					},{
						id : 'Name',
						header : '��������',
						editable:false,
						width : 150,
						dataIndex : 'Name'
					},{
						id : 'Head',
						header : '��Ŀ������',
						editable:false,
						width : 90,
						dataIndex : 'Head'

					}, {
						id : 'Sex',
						header : '�Ա�',
						editable:false,
						width : 60,
						dataIndex : 'Sex'
					},{
						id : 'BirthDay',
						header : '��������',
						width : 100,
						editable:false,
						dataIndex : 'BirthDay'
					}, {
						id : 'TName',
						header : '����ְ��',
						width : 100,
						editable : false,
						dataIndex : 'TName'
						
					},{
						id : 'Phone',
						header : '��ϵ�绰',
						width : 120,
						editable:false,
						dataIndex : 'Phone'

					},{
						id : 'EMail',
						header : '�����ַ',
						width : 150,
						editable:false,
						dataIndex : 'EMail'

					},{
						id : 'Participants',
						header : '����μ���Ա',
						width : 200,
						editable:false,
						dataIndex : 'Participants'

					},{
						id : 'PTName',
						header : '������Դ',
						width : 120,
						editable:false,
						dataIndex : 'PTName'

					},{
						id : 'RelyUnit',
						header : '�������е�λ',
						width : 200,
						editable:false,
						dataIndex : 'RelyUnit'

					},{
						id : 'AppFunds',
						header : '���뾭�ѣ���Ԫ��',
						width : 120,
						editable:false,
						dataIndex : 'AppFunds'

					},{
						id : 'StartDate',
						header : '��ʼʱ��',
						width :120,
						editable:false,
						dataIndex : 'StartDate'

					},{
						id : 'EndDate',
						header : '��ֹʱ��',
						width : 120,
						editable:false,
						dataIndex : 'EndDate'

					},{
						id : 'Remark',
						header : '��ע',
						width :180,
						editable:false,
						dataIndex : 'Remark'

					},{
						id : 'SubUser',
						header : '������',
						width : 100,
						editable:false,
						dataIndex : 'SubUser'

					},{
						id : 'SubDate',
						header : '����ʱ��',
						width : 100,
						editable:false,
						dataIndex : 'SubDate'

					},{
						id : 'DataStatuslist',
						header : '״̬',
						width : 60,
						editable:false,
						//hidden:true,
						dataIndex : 'DataStatuslist'

					},{
						id : 'ChkResult',
						header : '���п����״̬',
						editable:false,
						width : 120,
						
						hidden:true,
						dataIndex : 'ChkResult'
					},{
						id : 'ChkResultlist',
						header : '���п����״̬',
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['ChkResultlist']
						if (sf == "�ȴ����") {return '<span style="color:blue;cursor:hand">'+value+'</span>';} 
						if (sf == "���ͨ��") {return '<span style="color:red;cursor:hand">'+value+'</span>';} 
						if (sf == "��˲�ͨ��"){return '<span style="color:gray;cursor:hand">'+value+'</span>';}
						},
						width : 120,
						dataIndex : 'ChkResultlist'
					},{
						id : 'Desc',
						header : '���п��������',
						width : 120,
						editable:false,
						dataIndex : 'Desc'
					},{
						id : 'ProjStatus',
						header : '��Ŀ״̬',
						width : 60,
						editable:false,
						dataIndex : 'ProjStatus'
					}]					
		});



 
///////////////////��Ӱ�ť///////////////////////
var addPatentInfoButton = new Ext.Toolbar.Button({
		text: '���',
    	tooltip: '����µ�ר���ɹ�',        
    	iconCls: 'add',
		handler: function(){addFun();}
});

/////////////////�޸İ�ť/////////////////////////
var editPatentInfoButton  = new Ext.Toolbar.Button({
		text: '�޸�',        
		tooltip: '�޸�ѡ����ר���ɹ�',
		iconCls: 'remove',
		handler: function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length; 
			if(len < 1)
			{
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				var state = rowObj[0].get("DataStatus");	
				var InventorsIDs = rowObj[0].get("InventorsIDs");
				//alert(InventorsIDs);			
				if(state == "δ�ύ" ){editFun(InventorsIDs);}
				else {Ext.Msg.show({title:'����',msg:'�������ύ���������޸ģ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}
			}
});

////////////////ɾ����ť//////////////////////////
var delPatentInfoButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		tooltip: 'ɾ��ѡ����ר���ɹ�',
		iconCls: 'remove',
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
var subPatentInfoButton = new Ext.Toolbar.Button({
		text:'�ύ',
		tooltip:'�ύѡ����ר���ɹ�',
		iconCls:'add',
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



  itemGrid.btnResetHide(); 	//�������ð�ť
  itemGrid.btnDeleteHide(); //����ɾ����ť
  itemGrid.btnPrintHide(); 	//���ش�ӡ��ť
  itemGrid.btnAddHide(); 	//������Ӱ�ť
  itemGrid.btnSaveHide(); 	//���ر��水ť
  itemGrid.load({params:{start:0, limit:12, userdr:userdr}});
 


