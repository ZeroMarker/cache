
 function  save() { 
 if(typename.getValue()==""){
	Ext.Msg.show({title:'注意',msg:'请选择坏账计提方式！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
	return;
 }
 else if(typename.getValue()==2)
 { 
	itemGrid.save();
 }
 else
 {
	 var value=Paramproportion.getValue()
	 // alert(value)
	 if(value>=1||value<0){
		Ext.Msg.show({title:'错误',msg:'请输入1以内的值！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); 
		return;
	 }else{
			Ext.Ajax.request({
					url: '../csp/herp.acct.acctbaddebtsexe.csp?action=update&value='+value+'&bookID='+bookID,method:'POST',
					
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'注意',msg:'保存成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					//itemGrid.load({params:{start:0, limit:25,SchemDR : curSchemeDr}});
						}
						else {
						var tmpMsg = "保存失败! ";
						Ext.Msg.show({title:'错误',msg:tmpMsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
				  	scope: this
			});
		}
	}
}

