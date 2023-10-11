var userdr = session['LOGON.USERCODE'];    
var projUrl = 'herp.srm.auditPrjReimbursemenexe.csp';

var YearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

YearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=yearList&str='+encodeURIComponent(Ext.getCmp('yearCombo').getRawValue()),
	method:'POST'});
});

var yearCombo = new Ext.form.ComboBox({
	id: 'yearCombo',
	fieldLabel: '�������',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:YearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ�����...',
	name: 'yearCombo',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''

});
		
// ////////////��������
var titleText = new Ext.form.TextField({
	width : 120,
	selectOnFocus : true,
	labelSeparator:''

});


//////////////�������///////////////
var ChkResultStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '�ȴ�����'], ['2', 'ͨ��'], ['3', '��ͨ��']]
		});
var ChkResultField = new Ext.form.ComboBox({
			fieldLabel : '�������',
			width : 120,
			listWidth : 120,
			selectOnFocus : true,
			allowBlank : true,
			store : ChkResultStore,
			anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : true,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			labelSeparator:''

         });

///////////��ѯ��ť////////////// 
function srmFundApply(){

	    var PName = titleText.getValue();
		var ChkResult = ChkResultField.getValue();
		var Year = yearCombo.getValue();
		itemGrid.load({
		    params:{
		    start:0,
		    limit:25,   
		    PName: PName,
			userdr:userdr,
			Year:Year,
			ChkResult:ChkResult
		 }
	  });
  }


var queryPanel = new Ext.FormPanel({
	title : '��Ŀ���ѱ�����˲�ѯ',
			iconCls : 'search',
			autoHeight : true,
			region:'north',
			frame:true,
			defaults: {bodyStyle:'padding:5px'},
				items:[{
				xtype: 'panel',
				layout:"column",
				items: [
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
					yearCombo,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},					
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
					titleText,
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
					ChkResultField,
					{
						xtype : 'displayfield',
						value : '',
						width : 30
					},
					{
						width : 30,
						xtype:'button',
						text: '��ѯ',
						handler:function(b){
							srmFundApply();
						},
						iconCls: 'search'
					}		
				]
			}
			]
		});

var itemGrid = new dhc.herp.Grid({
		    region : 'center',
		    title: '��Ŀ���ѱ�����˲�ѯ�б�',
			iconCls: 'list',
		    url: projUrl,
			fields : [
			      new Ext.grid.CheckboxSelectionModel({editable:false}),
			        {
				        id:'RowID',
						header : '��Ŀ��������ID',
						dataIndex : 'RowID',
						hidden : true
					},
					{
						id : 'year',
						header : '�������',
						width : 60,
						//editable:false,
						editable:false,
						dataIndex : 'year'
					},
					{
						id : 'code',
						header : '��������',
						width : 120,
						//editable:false,
						editable:false,
						dataIndex : 'code'
					},{
						id : 'name',
						header : '��Ŀ����',
						width : 180,
						editable:false,
						dataIndex : 'name',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					},
					{
						id : 'deptname',
						header : '��������',
						width : 120,
						//editable:false,
						editable:false,
						dataIndex : 'deptname',renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					},{
						id : 'user',
						header : '������',
						width : 60,
						//editable:false,
						editable:false,
						dataIndex : 'user'
					},{
       					id:'applydesc',
        				header: '����˵��',
        				width:100,
						//tip:true,
						editable:false,
        				dataIndex: 'applydesc'

					},{
       					id:'Actmoney',
        				header: '�������(Ԫ)',
        				width:100,
        				align:'right',
						//tip:true,
						editable:false,
        				dataIndex: 'Actmoney',
        				renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
    				},{
       					id:'budgco',
        				header: 'Ԥ�����(Ԫ)',
        				width:100,
        				align:'right',
						//tip:true,
						editable:false,
        				dataIndex: 'budgco',
        				renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
    				},{
						id : 'ChkResult',
						header : '�������',
						editable:false,
						width : 150,
						hidden : true,
						dataIndex : 'ChkResult'
					},{
						id : 'midcheckState',
						header : '���״̬',
						width : 180,
						editable:false,
						dataIndex : 'midcheckState'
					},{
						id : 'Desc',
						header : '�������',
						width : 180,
						editable:false,
						//hidden:true,
						dataIndex : 'Desc'
					},{
						id : 'CheckName',
						header : '�����',
						width : 60,
						//hidden : true,
						editable:false,
						dataIndex : 'CheckName'
					},{
						id : 'CheckDate',
						header : '���ʱ��',
						width : 80,
						editable:false,
						//hidden : true,
						dataIndex : 'CheckDate'
					}]					
		});
		
var AuditButton  = new Ext.Toolbar.Button({
		text: 'ͨ��',  
        id:'auditButton', 
        iconCls: 'pencil',
        handler:function(){
		//���岢��ʼ���ж���
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		var checker = session['LOGON.USERCODE'];
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
        for(var j= 0; j < len; j++){
		 if(rowObj[j].get("ChkResult")!='�ȴ�����')
		    
		 {
			      Ext.Msg.show({title:'ע��',msg:'���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){		
					    Ext.Ajax.request({
						url:'herp.srm.auditPrjReimbursemenexe.csp?action=audit&RowID='+rowObj[i].get("RowID")+'&checker='+checker,
						waitMsg:'�����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'��˳ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0, limit:25,userdr:userdr}});
								
							}else{
								Ext.Msg.show({title:'����',msg:'���ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ��˸�����¼��?',handler);
    }
});


  var NoAuditButton = new Ext.Toolbar.Button({
					text : '��ͨ��',
					iconCls: 'pencil',
					handler : function() {
						var rowObj=itemGrid.getSelectionModel().getSelections();
						var len = rowObj.length;
						if(len < 1){
							Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						}
						for(var j= 0; j < len; j++){
							 if(rowObj[j].get("ChkResult")!='�ȴ�����')
							 {
								      Ext.Msg.show({title:'ע��',msg:'���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
								       return;
							 }
						}
						noauditfun();
				   }
  });
  
  itemGrid.addButton('-');
  itemGrid.addButton(AuditButton);
  itemGrid.addButton('-');
  itemGrid.addButton(NoAuditButton);

  itemGrid.btnResetHide(); 	//�������ð�ť
  itemGrid.btnDeleteHide(); //����ɾ����ť
  itemGrid.btnPrintHide(); 	//���ش�ӡ��ť
  itemGrid.btnAddHide(); 	//�������ð�ť
  itemGrid.btnSaveHide(); 	//�������ð�ť
  itemGrid.load({params:{start:0, limit:12, userdr:userdr}});


//downloadMainFun(itemGrid,'rowid','P001',24);
