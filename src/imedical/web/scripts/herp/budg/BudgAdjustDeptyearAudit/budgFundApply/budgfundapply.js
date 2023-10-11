var userdr = session['LOGON.USERID'];

var projUrl = 'herp.budg.budgfundapplyexe.csp';
////////////��������//////////////////////
var yearmonDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['yearmonth', 'yearmonth'])
		});

yearmonDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=yearmonthlist',
						method : 'POST'
					});
		});

var yearmonField = new Ext.form.ComboBox({
			fieldLabel : '��������',
			store : yearmonDs,
			displayField : 'yearmonth',
			valueField : 'yearmonth',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '��ѡ������...',
			width : 100,
			listWidth : 220,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
		
/////////////////��Ӱ�ť////////////////////////////
var addButton = new Ext.Toolbar.Button({
	text: '���',
    tooltip:'���',        
    iconCls:'add',
	handler:function(){
	AddFun(itemGrid);			//�������뵥�ݹ������
	}
	
});

var modificationButton = new Ext.Toolbar.Button({
	text: '�޸�',
    tooltip:'�޸�',        
    iconCls:'add',
	handler:function(){	
		EditFun(itemGrid);		//�������뵥�ݹ������
	}
	
});


/////////////////����////////////////////////////
function accessoryFun()
{
	var selectedRow = itemGrid.getSelectionModel().getSelections();
		
	var BillState=selectedRow[0].data['BillState'];
	var rowid = selectedRow[0].data['rowid'];
	
	if((BillState=="�ύ")||(BillState=="���"))
	{
		Ext.Msg.show({
						title : 'ע��',
						msg : '�����������ύ  �����ϴ�����!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
		//alert("����Ԥ������");			
		/////////////////����Ԥ������////////////////////////			
		return;
	}
	
	var fileName = new Ext.form.TextField({
			xtype: 'textfield',
            fieldLabel: '�ļ���',
            name: 'userfile',
            inputType: 'file',
            allowBlank: false,
            blankText: '�ļ�����Ϊ��.',
            anchor: '90%'  // anchor width by percentage

		});
	
	var form = new Ext.form.FormPanel({
        baseCls: 'x-plain',
        labelWidth: 80,
        //url:'upload.php',
        fileUpload:true,
        defaultType: 'textfield',

        items: [ fileName ]
    });
    
    var upLaodButton = new Ext.Toolbar.Button({
		text: '�ϴ�',
        handler: function() {
              if(form.form.isValid()){
                   Ext.MessageBox.show({
                       title: '���Ե�',
                       msg: '�ϴ���...',
                       progressText: '',
                       width:300,
                       progress:true,
                       closable:false,
                        animEl: 'loding'
                       });
                       
               var filename = "\""+fileName.getValue()+"\"";
					
               form.getForm().submit({
	                url:projUrl + '?action=upload'+'&rowid'+rowid+'&filename'+filename, 
	                method:'POST', 
	                //params:rowid,filename,
                    success: function(form, action){
                        Ext.Msg.alert(filename+'�ϴ��ɹ�',action.result.msg);
                        win.hide();  
                        },    
                    failure: function(){
	                    Ext.Msg.alert('����', '�ļ�'+filename+'�ϴ�ʧ��.');    
                       }
                    })               
                }
           }
	})
        
    var win = new Ext.Window({
        title: '�ϴ�����',
        width: 400,
        height:200,
        minWidth: 300,
        minHeight: 100,
        layout: 'fit',
        plain:true,
        bodyStyle:'padding:5px;',
        buttonAlign:'center',
        items: form,

        buttons: [upLaodButton,
        {
            text: 'ȡ���ϴ�',
            handler:function(){win.hide();}
        }]
    });
    win.show();
}

/////////////////�ύ��ť////////////////////////////
function submitFun()
{
	var records = itemGrid.getSelectionModel().getSelections();
		
	var BillState=records[0].get("BillState");
	if((BillState=="�ύ")||(BillState=="���"))
	{
		Ext.Msg.show({
						title : 'ע��',
						msg : '�����������ύ  �����ٴ��ύ!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
	}

	Ext.MessageBox.confirm('��ʾ', '�ύ�������ֻ�ܳ��� �����ٱ༭  ��ȷ���Ƿ��ύ', function(btn){
		if(btn=='yes')
		{	
			var rowid=records[0].get("rowid");	
			//alert(rowid);
	
			Ext.Ajax.request({
						url : projUrl + '?action=submit&rowid='+rowid,
						waitMsg : '�ύ��...',
						failure : function(result, request) {
								Ext.Msg.show({
											title : '����',
											msg : '������������!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
											});
								},
						success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
										Ext.MessageBox.alert('��ʾ','�ύ���');
										itemGrid.load({params:{start:0,limit:25}});
								} else {
										var message = "SQLErr: "+ jsonData.info;
										Ext.Msg.show({
													title : '����',
													msg : message,
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR
													});
										}
								},
										scope : this
							});
					
			
			}
		
		
		})

}

/////////////////ɾ��//////////////
function deleteFun()
{
	
	var records = itemGrid.getSelectionModel().getSelections();
		
	var BillState=records[0].get("BillState");
	if((BillState=="�ύ")||(BillState=="���"))
	{
		Ext.Msg.show({
						title : 'ע��',
						msg : '���ύ�����ݲ���ɾ��!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
	}
	
	Ext.MessageBox.confirm('��ʾ', '��ȷ���Ƿ�ɾ��', function(btn){
		if(btn=='yes')
		{	
			var sig=0;
			Ext.MessageBox.confirm('��ʾ', '�Ƿ���ɾ����ϸ����Ϣ', function(btn){
				if (btn=='yes')
				{
				   sig=1;	 //  ����Ƿ���ɾ����ϸ��
				}			
			
			//alert(sig);
			var rowid=records[0].get("rowid");	
			//alert(rowid);	
			Ext.Ajax.request({
						url : projUrl + '?action=delete&rowid='+rowid+'&sig='+sig,
						waitMsg : 'ɾ����...',
						failure : function(result, request) {
								Ext.Msg.show({
											title : '����',
											msg : '������������!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
											});
								},
						success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
										Ext.MessageBox.alert('��ʾ','ɾ�����');
										itemGrid.load({params:{start:0,limit:25}});
								} else {
										var message = "SQLErr: "+ jsonData.info;
										Ext.Msg.show({
													title : '����',
													msg : message,
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR
													});
										}
								},
										scope : this
							});
					
				})
			}
		
		
		})	

}

/////////////////����////////////////////////////
function revocationFun()
{
	var records = itemGrid.getSelectionModel().getSelections();
	
	var sOver=records[0].get("sOver");
	if(sOver=="���")
	{
		Ext.Msg.show({
						title : 'ע��',
						msg : '���������ѽ���  ���ܳ���!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
	}
	
	var BillState=records[0].get("BillState");
	if(BillState=="�½�")
	{
		Ext.Msg.show({
						title : 'ע��',
						msg : '��������δ�ύ  ���賷��!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
	}
	else if(BillState=="����")
	{
		Ext.Msg.show({
						title : 'ע��',
						msg : '�������ѳ���  �����ٴγ���!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
	}
	
	Ext.MessageBox.confirm('��ʾ', '��ȷ���Ƿ���', function(btn){
		if(btn=='yes')
		{	
			var rowid=records[0].get("rowid");	
			//alert(rowid);	
			Ext.Ajax.request({
						url : projUrl + '?action=revocation&rowid='+rowid+'&userdr='+userdr,
						waitMsg : '������...',
						failure : function(result, request) {
								Ext.Msg.show({
											title : '����',
											msg : '������������!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
											});
								},
						success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
										Ext.MessageBox.alert('��ʾ','�������');
										itemGrid.load({params:{start:0,limit:25}});
								} else {
										var message = "SQLErr: "+ jsonData.info;
										Ext.Msg.show({
													title : '����',
													msg : message,
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR
													});
										}
								},
										scope : this
							});
					
			
			}
		
		
		})

}

/////////////////��ѯ��ť��Ӧ����//////////////
function budgFundApply()
{
	var yearmonth=yearmonField.getValue();
	
	itemGrid.load({params:{start:0,limit:25,yearmonth:yearmonth}});
	
}

//////////////////////////////////////////////
var queryPanel = new Ext.FormPanel({
	height : 90,
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
			value : '<center><p style="font-weight:bold;font-size:120%">������</p></center>',
			columnWidth : 1,
			height : '32'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
					xtype : 'displayfield',
					value : '��������:',
					columnWidth : .05
				}, yearmonField,
				{
				xtype:'displayfield',
				value:'',
				columnWidth:.05
				},{
				columnWidth:0.05,
				xtype:'button',
				text: '��ѯ',
				handler:function(b){budgFundApply();},
				iconCls: 'add'
				}]
	}]
	
});

var itemGrid = new dhc.herp.Grid({
			region : 'center',
			url : 'herp.budg.budgfundapplyexe.csp',		
			listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                var record = grid.getStore().getAt(rowIndex);
		                  // �����������õ�Ԫ�����༭�Ƿ���� 
		                 if ((record.get('ChkStep') =="�ύ")&& (columnIndex == 2)) {
		                      return false;
		                 } else {return true;}
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
						// Ԥ����Ŀ��ʽ�༭
						if ((record.get('ChkStep') =="�ύ") && (columnIndex == 2)) {						
							return false;
						} else {
							return true;
						}
					}
            },
			fields : [{
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					},{
						header : 'ѡ��',
						width:180,
						hidden : false,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store)
						{ 
							return '<span style="color:blue;cursor:hand"><BLINK id="submit"     onclick=submitFun();>      �ύ  </BLINK></span>'+'<b> </b>'
							   	  +'<span style="color:blue;cursor:hand"><BLINK id="revocation" onclick=revocationFun();>  ����  </BLINK></span>'+'<b> </b>'
							   	  +'<span style="color:blue;cursor:hand"><BLINK id="delete"     onclick=deleteFun();>       ɾ��  </BLINK></span>'+'<b> </b>' 
							   	  +'<span style="color:blue;cursor:hand"><BLINK id="accessory" 	onclick=accessoryFun();>   ����  </BLINK></span>'+'<b> </b>' 
							   	  +'<span style="color:blue;cursor:hand"><u id="revocation"     onclick=EditFun(itemGrid);>�޸�  </u></span>';  
						}
					},{
						id : 'YearMonth',
						header : '����',
						width : 50,
						editable:false,
						dataIndex : 'YearMonth'
					}, {
						id : 'BillCode',
						header : '���뵥��',
						width : 120,
						editable:false,
						allowBlank : false,
						dataIndex : 'BillCode'

					},{
						id : 'dName',
						header : '�������',
						editable:false,
						width : 120,
						dataIndex : 'dName'
					},{
						id : 'uName',
						header : '������',
						width : 100,
						editable:false,
						dataIndex : 'uName'

					}, {
						id : 'ReqPay',
						header : '������',
						//xtype:'numbercolumn',
						width : 120,
						editable : false,
						align:'right',
						dataIndex : 'ReqPay'
					}, {
						id : 'ReqPayRes',
						header : '�������',
						//xtype:'numbercolumn',
						width : 120,
						editable : false,
						align:'right',
						dataIndex : 'ReqPayRes'
					},{
						id : 'BillDate',
						header : '����ʱ��',
						width : 80,
						editable : false,
						dataIndex : 'BillDate'
					},{
						id : 'BillState',
						header : '����״̬',
						width : 60,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['BillState']
						if (sf == "�½�") {
							return '<span style="color:blue;cursor:hand"><u>'+value+'</u></span>';
						} else {
							return '<span style="color:gray;cursor:hand"><u>'+value+'</u></span>';
						}},
						dataIndex : 'BillState'

					},{
						id : 'Desc',
						header : '�ʽ�����˵��',
						width : 200,
						editable:false,
						dataIndex : 'Desc'

					},{
						id : 'BudgBal',
						header : '���������',
						//xtype:'numbercolumn',
						width : 120,
						editable:false,
						align:'right',
						dataIndex : 'BudgBal'

					},{
						id : 'budgcotrol',
						header : 'Ԥ�����',
						width : 60,
						editable:false,
						hidden:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['budgcotrol']
						if (sf == "����Ԥ��") {
							return '<span style="color:red;cursor:hand;">'+value+'</span>';
						} else {
							return '<span style="color:black;cursor:hand">'+value+'</span>';
						}},
						dataIndex : 'budgcotrol'

					},{
						id : 'sOver',
						header : '���״̬',
						width : 80,
						editable:false,
						dataIndex : 'sOver',
						hidden:true
					},{
						id : 'deptID',
						header : '�������ID',
						editable:false,
						width : 60,
						hidden:true,
						dataIndex : 'deptID'
					},{
						id : 'CheckDR',
						header : '����������',
						editable:false,
						width : 100,
						dataIndex : 'CheckDR'
					},{
						id : 'Checkid',
						header : '������ID',
						editable:false,
						width : 100,
						hidden:true,
						dataIndex : 'Checkid'
					}, {
						id : 'audname',
						header : '��ڿ���',
						editable:false,
						width : 120,
						dataIndex : 'audname',
						hidden:false
					}, {
						id : 'audeprdr',
						header : '��ڿ���dr',
						editable:false,
						width : 120,
						dataIndex : 'audeprdr',
						hidden:true
					}],
					xtype : 'grid',
					loadMask : true,
					tbar : [addButton] 

		});

    itemGrid.btnAddHide();     //�������Ӱ�ť
   	itemGrid.btnSaveHide();    //���ر��水ť
    itemGrid.btnResetHide();   //�������ð�ť
    itemGrid.btnDeleteHide();  //����ɾ����ť
    itemGrid.btnPrintHide();   //���ش�ӡ��ť

itemGrid.load({params:{start:0, limit:12, userdr:userdr}});


// ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {

	//  ����״̬
	if (columnIndex == 10) {
		var records = itemGrid.getSelectionModel().getSelections();
		var FundBillDR   = records[0].get("rowid");
		var BillCode  		 = records[0].get("BillCode");
		var dName		 = records[0].get("dName");
		stateFun(FundBillDR,BillCode,dName);
	}
		
});


