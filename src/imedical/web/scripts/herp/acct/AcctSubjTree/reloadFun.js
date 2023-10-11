var userid = session['LOGON.USERID'];	
var projUrl='../csp/herp.acct.acctSubjTreeExe.csp';	


reloadFun = function() {
			//进度条显示
			Ext.MessageBox.show({title:'注意',
							msg:'数据同步更新中...',
							width:240,
							progress:true,
							closable:false
							});
			Ext.Ajax.request({
			url: '../csp/herp.acct.acctSubjTreeExe.csp?action=reload&acctbookid='+acctbookid,
			waitMsg:'更新中...',
			success: function(result, request){
			var jsonData = Ext.util.JSON.decode(result.responseText );
			
			var f=function(v){
				return function(){
					if(v==6){
						Ext.MessageBox.hide();
						if(jsonData.success=='true'){
						Ext.Msg.show({title:'注意',msg:'数据同步完成!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						// itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
						mainGrid.root.reload();
						}
					}else{
						Ext.MessageBox.updateProgress(v/5,'正在更新数据...');
						
					}
				};	
			};
			//控制延时
				for(var i=1;i<7;i++){
					setTimeout(f(i),i*800);
				}
			
			},
			scope: this
	});

		
}


