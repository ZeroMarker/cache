doInterfaceFun=function(){

		var year=yearField2.getValue();
		var type = periodTypeField2.getValue();
		var period = periodField2.getValue();
		
		var pattern=/^\d{4}$/;
		if(pattern.test(year)==false){
			Ext.Msg.show({title:'注意',msg:'年份格式请输入四位有效数字!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
			return;}
		if(year==""){
			Ext.Msg.show({title:'提示',msg:'年份不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
			return;
		}else if(type==""){
			Ext.Msg.show({title:'提示',msg:'期间类型不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
			return;
		}else if(period==""){
			Ext.Msg.show({title:'提示',msg:'期间不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
			return;
		}
		
		var myMask = new Ext.LoadMask(Ext.getBody(),{msg:"正在导入，请稍后......"});
		myMask.show();
		var urlStr = '../csp/dhc.qm.qualityinfomanagementexe.csp?action=interfaceImp&year='+year+'&type='+type+'&period='+period;
		Ext.Ajax.request({
			url : urlStr,
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				myMask.hide();
				if (jsonData.success=='true'){				
					Ext.Msg.show({title:'注意',msg:'导入成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
				}
				
			},
			failure: function(result, request){		
				myMask.hide();
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				
			}		
			
		});
		
	
	};