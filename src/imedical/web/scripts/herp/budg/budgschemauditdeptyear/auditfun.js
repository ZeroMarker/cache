auditFun = function() {
		var UserID = session['LOGON.USERID'];	
		var username = session['LOGON.USERNAME'];

			var CheckResultField = new Ext.form.ComboBox({									

			
				fieldLabel: '审批结果',
				width:500,
				anchor: '100%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '通过'], ['0', '不通过']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : '1',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});	
			
			
	// 多文本域
	var textArea = new Ext.form.TextArea({
				id : 'textArea',
				width : 500,
                height:90,
				anchor: '100%',
				fieldLabel : '审批意见',
				//readOnly : true,
				//disabled : true,
				allowBlank :true,
				selectOnFocus:'true',
				emptyText : '请填写审批意见……'
			});

	// 导入说明多文本域
	var viewFieldSet = new Ext.form.FieldSet({
				title : '',
				height : 110,
                region:'south',
				labelSeparator : '：',
				items : textArea
			});
	var checkFieldSet = new Ext.form.FieldSet({
				title : '',
				height : 70,
				labelSeparator : '：',
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
				text:'确定'
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
    	    	
    	    	var uur3 = BudgSchemAuditDeptYearDetailUrl+'?action=save&&rowid='+ selectedid+'&planvalue='+selectedplanvalue;
    	    	itemDetail.saveurl(uur3);
    	    	}
    	   }
    	   var rowIndex = itemMain.getSelectionModel().lastActive;//主表选中的行号
        
      		var selectedRow = itemMain.getSelectionModel().getSelections();
      		var bsmId=selectedRow[0].data['rowid'];
      		var schemAuditDR=selectedRow[0].data['schemAuditDR'];
    	    var bsmDr=selectedRow[0].data['bsmcode'];
    	    var curstep=selectedRow[0].data['bsachkstep'];
    	    var deptdr=selectedRow[0].data['bsaeditdeptdr'];
    	    var uur2 = BudgSchemAuditDeptYearDetailUrl+'?action=check&&schemAuditDR='+ schemAuditDR+'&bsarchkresult='+bsarchkresult+'&bsardesc='+encodeURIComponent(bsardesc)+'&UserID='+UserID;
    	    itemDetail.saveurl(uur2);
 
    	    addwin.close();
    	    
    	    var BITname=BITnameField.getValue();
			var BIDlevel=BIDlevelField.getValue();
			var BSDCode=bsdcodeField.getValue();
			var Year=yearField.getValue();
			var BSMname=BSMnameField.getValue();
			itemDetail.load(({params:{start:0, limit:25,DeptDR:deptdr,Year:Year,Code:bsmId,BITName:BITname,BIDLevel:BIDlevel,BSDCode:BSDCode}}));
			itemMain.load(({params:{start:0, limit:25,Year:Year,BSMName:BSMname,UserID:UserID}}));
			var d = new Ext.util.DelayedTask(function(){  
            	itemMain.getSelectionModel().selectRow(rowIndex);
           	});  
            d.delay(1000); 
			itemMain.getSelectionModel().selectRow(rowIndex)	
		}
			
			addButton.addListener('click',addHandler,false);
			cancelButton = new Ext.Toolbar.Button({
				text:'取消'
			});
			cancelHandler = function(){
				addwin.close();
			}
			cancelButton.addListener('click',cancelHandler,false);
			addwin = new Ext.Window({
				title: '审批',
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