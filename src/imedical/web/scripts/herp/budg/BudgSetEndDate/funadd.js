var projUrl = 'herp.budg.budgsetenddateexe.csp';
addFun = function(year,ChangeFlag,adjustNo,deptdr,date,Year,Deptdr,Enddate) {
	var myMask = new Ext.LoadMask(Ext.getBody(), {
        msg: '保存中…',
        removeMask: true //完成后移除
    });
	
	//myMask.show();
	
	Ext.Ajax.request({
		timeout : 300000,
		url: projUrl+'?action=update&year='+year+'&ChangeFlag='+ChangeFlag+'&adjustNo='+adjustNo+'&deptdr='+deptdr+'&enddate='+date,
		waitMsg:'保存中...',
		failure: function(result, request){
			myMask.hide();
	
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request){
			
			var jsonData = Ext.util.JSON.decode( result.responseText );			
			
			if (jsonData.info=='0'){
				myMask.hide();
							
				Ext.Msg.show({title:'注意',msg:'保存成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});								
				
				itemGrid.load({
							params : {
								start : 0,
								limit : 12,
								year:Year,
								ChangeFlag:ChangeFlag,
								adjustNo:adjustNo,
								deptdr:Deptdr
							}
				});
				
			}
			else
			{	
				var message="SQLCODE:"+jsonData.info;
				Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}
		},		
		scope: this
	});
}


