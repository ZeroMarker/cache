//更新年度函数
settvalue = function(cycleDr,schemDr,deptDr){
	
	if((cycleDr=="")||(cycleDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	
	if((schemDr=="")||(schemDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
			
			Ext.Ajax.request({
				url: 'dhc.pa.kpitargetsetexe.csp?action=settvalue&schemDr='+schemDr+'&deptDr='+deptDr+'&cycleDr='+cycleDr,
				waitMsg:'保存中...',
				failure: function(result, request){
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						//win.close();
						Ext.Msg.show({title:'注意',msg:'目标导入成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,width:250});
						//finddept();
					}else{
						
							Ext.Msg.show({title:'错误',msg:'导入失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
						
					}
				},
				scope: this
			});
		}
			
	