/**
  *author��chuyali
  *Date:2015-11-24
  *����������Ϣά��-���
 */
//button:���ڻ�ȡbutton��һЩ��Ϣ��status������ȷ������˻���ȡ����ˣ�userid�������
var doauditall = function(button,status,userid){
	var userID=session['LOGON.USERID'];
	year=yearField2.getValue();
	type = periodTypeField2.getValue();
	period = periodField2.getValue();
	var pattern=/^\d{4}$/;
	
	if(pattern.test(year)==false){
		
		Ext.Msg.show({title:'ע��',msg:'��ݸ�ʽ��������λ��Ч����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
		return false;
	}else{
	
	Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ'+button.getText()+'���е�������?',function(btn){
		if(btn=="yes"){
			//�������
			 Ext.MessageBox.show({  
                    msg : '�����У����Ժ�...',    
                    width : 300,  
                    wait : true,  
                    progress : true,  
                    closable : true,  
                    waitConfig : {  
                        interval : 1500  
                    },  
                    icon : Ext.Msg.INFO  
                });  

			
			//ȷ�����
			Ext.Ajax.request({
				url:itemGridUrl + '?action=auditall&year='+year+'&period='+period+'&type='+type+'&userid='+userid+'&status='+status,
				waitMsg : button.getText()+'��...',
				success:function(result, request) {
					Ext.MessageBox.hide();
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Ext.Msg.show({
							title : 'ע��',
							//msg : '�����ɹ�!<br/>�˴�'+button.getText()+'��<span style="color:red">'+jsonData.info+'</span>����¼',
							msg:button.getText()+'�ɹ���',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFO
						});
						dosearch(start,limit,"","","");
					} else {
						Ext.Msg.show({
							title : '����',
							msg : 'û��Ҫ'+button.getText()+'�ļ�¼',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
					}
				},
				failure: function(result, request) {
					Ext.Msg.show({
						title : '����',
						msg : '������������!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
				}
			});	
		}
	});
	}
};

