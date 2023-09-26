//===================�ύ Fun=====================================//
function submitHandler(){
	Ext.MessageBox.confirm('��ʾ','ȷʵҪ�ύ������?',function(btn) {
		if(btn == 'yes'){
			var year = yearField.getRawValue();
			var frequency=periodTypeField.getValue();	
			var acuttypeitem = periodField.getValue();
			var deptDr = deptField.getValue();
			var DschemDr = DeptSchemField.getValue();
			
			//�ύ��������
			var rowObj = editGrid.getSelectionModel().getSelections();
			
			var len = rowObj.length;
			if(len > 0){
				//�����ύ
				for(var i = 0; i < len; i++){ 	
					var rowid = rowObj[i].get("YRowid");
					var estDesc = encodeURIComponent(rowObj[i].get("URDContent"));
					var submitState = rowObj[i].get("UDRsubmitState");
					Ext.Ajax.request({
						url:'dhc.pa.selffillandreportexe.csp?action=submit&UDRDrowid='+rowObj[i].get("YRowid")+'&UDRDestDesc='+estDesc+'&UDRDfBDesc='+'&year='+year+'&acuttypeitem='+acuttypeitem+'&deptDr='+deptDr+'&DschemDr='+DschemDr+'&userId='+userId,
						waitMsg:'�ύ��...',
						failure: function(result, request) {
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') { 
								Ext.MessageBox.alert('��ʾ', '�ύ���');
								search();
						}else{
							Ext.MessageBox.alert('��ʾ', '�ύʧ��');
						}
					},
					scope: this
					});
				} 
			}
		}
	});
}