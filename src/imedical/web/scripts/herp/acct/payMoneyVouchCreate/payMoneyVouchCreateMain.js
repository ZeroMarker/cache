var yearmonth = new Ext.form.DateField({
		fieldLabel: '��ʼ����',
		name: 'yearmonth',
		width: 110,
		//value: (new Date()).getFullYear() + "" + "01",
		plugins: 'monthPickerPlugin',
		format: 'Y-m',
		editable: false
	
	});
	var VouchCreateButton = new Ext.Toolbar.Button({
	text: '������ʱƾ֤',    
    id:'VouchCreateButton', 
    iconCls:'option',
	handler:function(){
		var yearm=yearmonth.getRawValue();
		if (yearm=="")
			{
			Ext.Msg.show({title:'ע��',msg:'��ѡ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			var yearh=yearm.split("-");
			var year=yearh[0];
			var month=yearh[1];
		    var username = session['LOGON.USERNAME'];
		function handler(id){
			if(id=="yes"){
			var yearm=yearmonth.getRawValue();
			
					Ext.Ajax.request({
						url:'herp.acct.acctPayMoneyVouchCreateexe.csp?action=VouchCreate&year='+year+'&month='+month+'&username='+username,
						waitMsg:'����ƾ֤��...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'����ƾ֤!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								mainGrid.load({params:{start:0, limit:25}});
								
							}else{
								Ext.Msg.show({title:'����',msg:'����ƾ֤ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
			else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ������ʱƾ֤��?',handler);
	}
});


var FindButton = new Ext.Toolbar.Button({
	id:'Findbutton',
	text: '��ѯ',
	tooltip: '��ѯ',
	iconCls: 'find',
	handler: function(){
	   	var yearm=yearmonth.getRawValue().split("-");
	   	var year=yearm[0];
	   	var month=yearm[1];
		
		mainGrid.load({params:{start:0,limit:25,year:year,month:month}});
	}
});


var mainGrid = new dhc.herp.Grid({
        title: '���ʹ�Ӧ��Ӧ����ƾ֤����',
        width: 400,
        region: 'center',
        url: 'herp.acct.acctPayMoneyVouchCreateexe.csp',
		atLoad : true,
		
		
		//tbar:[AuditDataButton/*,'-',VoucherCreateButton*/],
        tbar:['���£�',yearmonth,'-',FindButton,'-',VouchCreateButton],
		fields: [new Ext.grid.CheckboxSelectionModel({editable:false}),
		{

		     id:'rowid',
		     header: '���ʸ������ݲɼ���ID',
		     
		     width:100,
		     align:'right',
		     editable:false,
		     hidden:true,
		     dataIndex: 'rowid'
		}, {
		     id:'PayBillNo',
		     header: '�������',
		     
		     width:100,
		     editable:false,
		     hidden:false,
			 //sortable:true,
		     dataIndex: 'PayBillNo',
		     renderer : function(value,cellmeta, record,rowIndex, columnIndex, store)
						{ 
							return '<span style="color:blue;cursor:hand;">'+value+'</span>';
						}
		},{
		     id:'PayMonth',
		     header: '��������',
		     
		     width:80,
		     editable:false,
		     hidden:false,
			 //sortable:true,
		     dataIndex: 'PayMonth'
		}, {
		     id:'SupplierCode',
		     header: '��Ӧ�̱���',
		     allowBlank: false,
		     align:'left',		  
		     width:80,
		     editable:false,	     
		     dataIndex: 'SupplierCode'
		     
		
		}, {
		     id:'SupplierName',
		     header: '��Ӧ������',
		    
		     align:'left',
		     width:180,
		     editable:false,
		     dataIndex: 'SupplierName'
		}, {
		     id:'BankName',
		     header: '��Ӧ����������',
		    
		     align:'left',
		     width:100,
		     editable:false,
		     dataIndex: 'BankName'
		}, {
		     id:'BankNo',
		     header: '��Ӧ�������˺�',
		    
		     align:'left',
		     width:160,
		     editable:false,
		     dataIndex: 'BankNo'
		}, {
		     id:'PayableSum',
		     header: 'Ӧ�����',
		    
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'PayableSum',
		     hidden:true
		},{
		     id:'ActualCurSum',
		     header: 'ʵ������',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'ActualCurSum'
		}, {
		     id:'MakeBillDate',
		     header: '�Ƶ�ʱ��',
		     allowBlank: true,
		     align:'left',
		     width:90,
		     editable:false,
		     dataIndex: 'MakeBillDate'
		}, {
		     id:'MakeBillPerson',
		     header: '�Ƶ���Ա',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'MakeBillPerson'
		}, {
		     id:'IsCheck',
		     header: '�Ƿ����',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'IsCheck',
		     hidden:true
		},{
		     id:'payMoneyUse',
		     header: '��;',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'payMoneyUse',
		     hidden:false
		}]
    
    });
    
mainGrid.btnAddHide();
mainGrid.btnSaveHide();
mainGrid.btnDeleteHide();
mainGrid.btnPrintHide();
mainGrid.btnResetHide();