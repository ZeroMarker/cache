doInterfaceFun=function(){

		var year=yearField2.getValue();
		var type = periodTypeField2.getValue();
		var period = periodField2.getValue();
		
		var pattern=/^\d{4}$/;
		if(pattern.test(year)==false){
			Ext.Msg.show({title:'ע��',msg:'��ݸ�ʽ��������λ��Ч����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
			return;}
		if(year==""){
			Ext.Msg.show({title:'��ʾ',msg:'��ݲ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
			return;
		}else if(type==""){
			Ext.Msg.show({title:'��ʾ',msg:'�ڼ����Ͳ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
			return;
		}else if(period==""){
			Ext.Msg.show({title:'��ʾ',msg:'�ڼ䲻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
			return;
		}
		
		var myMask = new Ext.LoadMask(Ext.getBody(),{msg:"���ڵ��룬���Ժ�......"});
		myMask.show();
		var urlStr = '../csp/dhc.qm.qualityinfomanagementexe.csp?action=interfaceImp&year='+year+'&type='+type+'&period='+period;
		Ext.Ajax.request({
			url : urlStr,
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				myMask.hide();
				if (jsonData.success=='true'){				
					Ext.Msg.show({title:'ע��',msg:'����ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
				}
				
			},
			failure: function(result, request){		
				myMask.hide();
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				
			}		
			
		});
		
	
	};