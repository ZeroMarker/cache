//������Ⱥ���
settvalue = function(cycleDr,schemDr,deptDr){
	
	if((cycleDr=="")||(cycleDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	
	if((schemDr=="")||(schemDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�񷽰�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
			
			Ext.Ajax.request({
				url: 'dhc.pa.kpitargetsetexe.csp?action=settvalue&schemDr='+schemDr+'&deptDr='+deptDr+'&cycleDr='+cycleDr,
				waitMsg:'������...',
				failure: function(result, request){
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						//win.close();
						Ext.Msg.show({title:'ע��',msg:'Ŀ�굼��ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,width:250});
						//finddept();
					}else{
						
							Ext.Msg.show({title:'����',msg:'����ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
						
					}
				},
				scope: this
			});
		}
			
	