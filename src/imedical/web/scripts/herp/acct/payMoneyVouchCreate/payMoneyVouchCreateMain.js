var yearmonth = new Ext.form.DateField({
		fieldLabel: '起始年月',
		name: 'yearmonth',
		width: 110,
		//value: (new Date()).getFullYear() + "" + "01",
		plugins: 'monthPickerPlugin',
		format: 'Y-m',
		editable: false
	
	});
	var VouchCreateButton = new Ext.Toolbar.Button({
	text: '生成临时凭证',    
    id:'VouchCreateButton', 
    iconCls:'option',
	handler:function(){
		var yearm=yearmonth.getRawValue();
		if (yearm=="")
			{
			Ext.Msg.show({title:'注意',msg:'请选择年月!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
						waitMsg:'生成凭证中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'生成凭证!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								mainGrid.load({params:{start:0, limit:25}});
								
							}else{
								Ext.Msg.show({title:'错误',msg:'生成凭证失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
			else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要生成零时凭证吗?',handler);
	}
});


var FindButton = new Ext.Toolbar.Button({
	id:'Findbutton',
	text: '查询',
	tooltip: '查询',
	iconCls: 'find',
	handler: function(){
	   	var yearm=yearmonth.getRawValue().split("-");
	   	var year=yearm[0];
	   	var month=yearm[1];
		
		mainGrid.load({params:{start:0,limit:25,year:year,month:month}});
	}
});


var mainGrid = new dhc.herp.Grid({
        title: '物资供应商应付款凭证生成',
        width: 400,
        region: 'center',
        url: 'herp.acct.acctPayMoneyVouchCreateexe.csp',
		atLoad : true,
		
		
		//tbar:[AuditDataButton/*,'-',VoucherCreateButton*/],
        tbar:['年月：',yearmonth,'-',FindButton,'-',VouchCreateButton],
		fields: [new Ext.grid.CheckboxSelectionModel({editable:false}),
		{

		     id:'rowid',
		     header: '物资付款数据采集表ID',
		     
		     width:100,
		     align:'right',
		     editable:false,
		     hidden:true,
		     dataIndex: 'rowid'
		}, {
		     id:'PayBillNo',
		     header: '付款单编码',
		     
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
		     header: '所属年月',
		     
		     width:80,
		     editable:false,
		     hidden:false,
			 //sortable:true,
		     dataIndex: 'PayMonth'
		}, {
		     id:'SupplierCode',
		     header: '供应商编码',
		     allowBlank: false,
		     align:'left',		  
		     width:80,
		     editable:false,	     
		     dataIndex: 'SupplierCode'
		     
		
		}, {
		     id:'SupplierName',
		     header: '供应商名称',
		    
		     align:'left',
		     width:180,
		     editable:false,
		     dataIndex: 'SupplierName'
		}, {
		     id:'BankName',
		     header: '供应商银行名称',
		    
		     align:'left',
		     width:100,
		     editable:false,
		     dataIndex: 'BankName'
		}, {
		     id:'BankNo',
		     header: '供应商银行账号',
		    
		     align:'left',
		     width:160,
		     editable:false,
		     dataIndex: 'BankNo'
		}, {
		     id:'PayableSum',
		     header: '应付金额',
		    
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'PayableSum',
		     hidden:true
		},{
		     id:'ActualCurSum',
		     header: '实付本币',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'ActualCurSum'
		}, {
		     id:'MakeBillDate',
		     header: '制单时间',
		     allowBlank: true,
		     align:'left',
		     width:90,
		     editable:false,
		     dataIndex: 'MakeBillDate'
		}, {
		     id:'MakeBillPerson',
		     header: '制单人员',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'MakeBillPerson'
		}, {
		     id:'IsCheck',
		     header: '是否审核',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'IsCheck',
		     hidden:true
		},{
		     id:'payMoneyUse',
		     header: '用途',
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