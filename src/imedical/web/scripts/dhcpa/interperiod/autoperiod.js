/**�����ڼ�
author��cyl  2017-2-20
locSetField �ӿ���  periodType �ڼ�����
**/

autoPeriod=function(locSetFieldValue,periodType,periodMsg,ds,pagingToolbar){
	var msg="ȷ��Ҫ����"+periodMsg+"�ڼ䣿";
	Ext.MessageBox.confirm('��ʾ',msg,function(flag){
		if(flag=="yes"){
			var data=locSetFieldValue;
			
			Ext.Ajax.request({
				url: '../csp/dhc.pa.interperiodexe.csp?action=autoPeriod&data='+data+'&periodType='+periodType,
				waitMsg:'������...',
				failure: function(result, request){
					
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'��ʾ',msg:'���ɳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						ds.load({params:{start:0,limit:pagingToolbar.pageSize,locSetDr:locSetFieldValue}});
					}else{
						if(jsonData.info=='isExist'){
							
							Ext.Msg.show({title:'��ʾ',msg:'���ڼ��¼�Ѿ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
						
					}
				},
				scope: this
			});
		}
		
	});
}