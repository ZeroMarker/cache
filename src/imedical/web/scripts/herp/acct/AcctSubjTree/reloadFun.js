var userid = session['LOGON.USERID'];	
var projUrl='../csp/herp.acct.acctSubjTreeExe.csp';	


reloadFun = function() {
			//��������ʾ
			Ext.MessageBox.show({title:'ע��',
							msg:'����ͬ��������...',
							width:240,
							progress:true,
							closable:false
							});
			Ext.Ajax.request({
			url: '../csp/herp.acct.acctSubjTreeExe.csp?action=reload&acctbookid='+acctbookid,
			waitMsg:'������...',
			success: function(result, request){
			var jsonData = Ext.util.JSON.decode(result.responseText );
			
			var f=function(v){
				return function(){
					if(v==6){
						Ext.MessageBox.hide();
						if(jsonData.success=='true'){
						Ext.Msg.show({title:'ע��',msg:'����ͬ�����!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						// itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
						mainGrid.root.reload();
						}
					}else{
						Ext.MessageBox.updateProgress(v/5,'���ڸ�������...');
						
					}
				};	
			};
			//������ʱ
				for(var i=1;i<7;i++){
					setTimeout(f(i),i*800);
				}
			
			},
			scope: this
	});

		
}


