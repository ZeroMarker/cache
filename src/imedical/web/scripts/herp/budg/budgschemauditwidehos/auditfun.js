auditFun = function() {
		var UserID = session['LOGON.USERID'];	
		var username = session['LOGON.USERNAME'];

			var CheckResultField = new Ext.form.ComboBox({									

			
				fieldLabel: '�������',
				width:500,
				anchor: '100%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', 'ͨ��'], ['0', '��ͨ��']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : '1',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : 'ѡ��...',
				selectOnFocus:'true'
			});	
			
			
	// ���ı���
	var textArea = new Ext.form.TextArea({
				id : 'textArea',
				width : 500,
                height:90,
				anchor: '100%',
				fieldLabel : '�������',
				//readOnly : true,
				//disabled : true,
				allowBlank :true,
				selectOnFocus:'true',
				emptyText : '����д�����������'
			});

	// ����˵�����ı���
	var viewFieldSet = new Ext.form.FieldSet({
				title : '',
				height : 110,
                region:'south',
				labelSeparator : '��',
				items : textArea
			});
	var checkFieldSet = new Ext.form.FieldSet({
				title : '',
				height : 70,
				labelSeparator : '��',
				items : CheckResultField
			});

			var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '1.0',
							bodyStyle:'padding:5px 5px 0',
							border: false
						},            
						items: [
							{
								xtype: 'fieldset',
								autoHeight: true,
								items: [
									checkFieldSet,	
									viewFieldSet
								]
							}]
					}
				]			
			
			var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 80,
				//layout: 'form',
				frame: true,
				items: colItems
			});
	
			addButton = new Ext.Toolbar.Button({
				text:'ȷ��'
			});

			addHandler = function(){
      			
      		var bsarchkresult = CheckResultField.getValue();    		
      		var bsardesc = textArea.getValue();
	    	
	    	var selectidDetail=itemDetail.getStore().getModifiedRecords();
    	    var len=selectidDetail.length;
    	    if(len>1){
    	    for(i=0;i<len;i++){
    	    	var selectedid = selectidDetail[i].get("rowid");
    	    	var selectedplanvalue = selectidDetail[i].get("bfplanvalue");
    	    	
    	    	var uur3 = BudgSchemAuditWideHosDetailUrl+'?action=save&&rowid='+ selectedid+'&planvalue='+selectedplanvalue;
    	    	itemDetail.saveurl(uur3);
    	    	}
    	   }
    	   var rowIndex = itemMain.getSelectionModel().lastActive;//����ѡ�е��к�
        
      		var selectedRow = itemMain.getSelectionModel().getSelections();
      		var bsmId=selectedRow[0].data['rowid'];
      		var schemAuditDR=selectedRow[0].data['schemAuditDR'];
    	    var bsmDr=selectedRow[0].data['bsmcode'];
    	    var curstep=selectedRow[0].data['bsachkstep'];
    	    var uur2 = BudgSchemAuditWideHosDetailUrl+'?action=check&&schemAuditDR='+ schemAuditDR+'&bsarchkresult='+bsarchkresult+'&bsardesc='+encodeURI(bsardesc)+'&UserID='+UserID;
    	    itemDetail.saveurl(uur2);
 			checkButton.disable();
		 	saveButton.disable();
    	    addwin.close();
    	    itemDetail.load({params:{start:0, limit:25,Code:bsmDr}})
    	    itemMain.load(({params:{start:0, limit:25}}));
			var d = new Ext.util.DelayedTask(function(){  
            	itemMain.getSelectionModel().selectRow(rowIndex);
           	});  
            d.delay(1000); 
			itemMain.getSelectionModel().selectRow(rowIndex)	
		}
			
			addButton.addListener('click',addHandler,false);
			cancelButton = new Ext.Toolbar.Button({
				text:'ȡ��'
			});
			cancelHandler = function(){
				addwin.close();
			}
			cancelButton.addListener('click',cancelHandler,false);
			addwin = new Ext.Window({
				title: '����',
				width: 500,
				height: 300,
				//autoHeight: true,
				layout: 'fit',
				plain:true,
				modal:true,
				bodyStyle:'padding:5px;',
				buttonAlign:'center',
				items: formPanel,
				buttons: [
					addButton,
					cancelButton
				]
			});		
			addwin.show();
}