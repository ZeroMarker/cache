/**
  *author：chuyali
  *Date:2015-11-24
  *质量管理信息维护-审核
 */
//button:用于获取button的一些信息，status：用来确定是审核还是取消审核，userid：审核人
var doauditall = function(button,status,userid){
	var userID=session['LOGON.USERID'];
	year=yearField2.getValue();
	type = periodTypeField2.getValue();
	period = periodField2.getValue();
	var pattern=/^\d{4}$/;
	
	if(pattern.test(year)==false){
		
		Ext.Msg.show({title:'注意',msg:'年份格式请输入四位有效数字!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
		return false;
	}else{
	
	Ext.MessageBox.confirm('提示', '确定要'+button.getText()+'所有的数据吗?',function(btn){
		if(btn=="yes"){
			//保存进度
			 Ext.MessageBox.show({  
                    msg : '保存中，请稍后...',    
                    width : 300,  
                    wait : true,  
                    progress : true,  
                    closable : true,  
                    waitConfig : {  
                        interval : 1500  
                    },  
                    icon : Ext.Msg.INFO  
                });  

			
			//确定审核
			Ext.Ajax.request({
				url:itemGridUrl + '?action=auditall&year='+year+'&period='+period+'&type='+type+'&userid='+userid+'&status='+status,
				waitMsg : button.getText()+'中...',
				success:function(result, request) {
					Ext.MessageBox.hide();
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Ext.Msg.show({
							title : '注意',
							//msg : '操作成功!<br/>此次'+button.getText()+'了<span style="color:red">'+jsonData.info+'</span>条记录',
							msg:button.getText()+'成功！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFO
						});
						dosearch(start,limit,"","","");
					} else {
						Ext.Msg.show({
							title : '错误',
							msg : '没有要'+button.getText()+'的记录',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
					}
				},
				failure: function(result, request) {
					Ext.Msg.show({
						title : '错误',
						msg : '请检查网络连接!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
				}
			});	
		}
	});
	}
};

