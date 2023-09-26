//===================提交 Fun=====================================//
function submitHandler(){
	Ext.MessageBox.confirm('提示','确实要提交数据吗?',function(btn) {
		if(btn == 'yes'){
			var year = yearField.getRawValue();
			var frequency=periodTypeField.getValue();	
			var acuttypeitem = periodField.getValue();
			var deptDr = deptField.getValue();
			var DschemDr = DeptSchemField.getValue();
			
			//提交保存数据
			var rowObj = editGrid.getSelectionModel().getSelections();
			
			var len = rowObj.length;
			if(len > 0){
				//批量提交
				for(var i = 0; i < len; i++){ 	
					var rowid = rowObj[i].get("YRowid");
					var estDesc = encodeURIComponent(rowObj[i].get("URDContent"));
					var submitState = rowObj[i].get("UDRsubmitState");
					Ext.Ajax.request({
						url:'dhc.pa.selffillandreportexe.csp?action=submit&UDRDrowid='+rowObj[i].get("YRowid")+'&UDRDestDesc='+estDesc+'&UDRDfBDesc='+'&year='+year+'&acuttypeitem='+acuttypeitem+'&deptDr='+deptDr+'&DschemDr='+DschemDr+'&userId='+userId,
						waitMsg:'提交中...',
						failure: function(result, request) {
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') { 
								Ext.MessageBox.alert('提示', '提交完成');
								search();
						}else{
							Ext.MessageBox.alert('提示', '提交失败');
						}
					},
					scope: this
					});
				} 
			}
		}
	});
}