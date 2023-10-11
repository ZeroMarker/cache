submitFun = function(){ 

        var selectedRow = itemGrid.getSelectionModel().getSelections();
        var len = selectedRow.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�ύ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		if(selectedRow[0].get("VouchState")=="��˲�ͨ��"||selectedRow[0].get("VouchState")=="�ύ"||selectedRow[0].get("VouchState")=="���ͨ��"||selectedRow[0].get("VouchState")=="����"||selectedRow[0].get("VouchState")=="����")
		{
			      Ext.Msg.show({title:'ע��',msg:'�������ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		}
        function handler(id){
			if(id=="yes"){
				Ext.Ajax.request({
					url:projUrl+'?action=submit&&rowid='+selectedRow[0].get("VouchID")+'&userid='+userid,
					waitMsg:'�ύ��...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},

					success: function(result, request){					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'ע��',msg:'�ύ�ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							itemGrid.load({params:{start:0, limit:12,userid:userid}});
							
						}else{
							Ext.Msg.show({title:'����',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
			    });
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ�ύ������¼��?',handler);

};



/////����ƾ֤
copyFun=function(){
		var selectedRow = itemGrid.getSelectionModel().getSelections();
        var len = selectedRow.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ������ƾ֤!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
 		
        function handler(id){
			if(id=="yes"){
				Ext.Ajax.request({
					url:projUrl+'?action=copy&&rowid='+selectedRow[0].get("VouchID")+'&userid='+userid,
					waitMsg:'�ύ��...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},

					success: function(result, request){					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'ע��',msg:'�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							itemGrid.load({params:{start:0, limit:12,userid:userid}});
							
						}else{
							Ext.Msg.show({title:'����',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
			    });
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ���ƴ�ƾ֤��?',handler);
	
}



/////����ƾ֤
cacelFun=function(){
	var selectedRow = itemGrid.getSelectionModel().getSelections();
        var len = selectedRow.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ���ϵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		if(selectedRow[0].get("VouchState")=="��˲�ͨ��"||selectedRow[0].get("VouchState")=="�ύ"||selectedRow[0].get("VouchState")=="���ͨ��"||selectedRow[0].get("VouchState")=="����"||selectedRow[0].get("VouchState")=="����"||selectedRow[0].get("IsCancel")=="��")
		{
			      Ext.Msg.show({title:'ע��',msg:'�������ύ,�������ϣ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		}
        function handler(id){
			if(id=="yes"){
				Ext.Ajax.request({
					url:projUrl+'?action=cacel&&rowid='+selectedRow[0].get("VouchID")+'&userid='+userid,
					waitMsg:'�ύ��...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},

					success: function(result, request){					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'ע��',msg:'�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							itemGrid.load({params:{start:0, limit:12,userid:userid}});
							
						}else{
							Ext.Msg.show({title:'����',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
			    });
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ���ϴ�ƾ֤��?',handler);
	
}

/////����ƾ֤
destroyFun=function(){
		var selectedRow = itemGrid.getSelectionModel().getSelections();
        var len = selectedRow.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ������ƾ֤!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		if(selectedRow[0].get("IsDestroy")=="��")
		{
			      Ext.Msg.show({title:'ע��',msg:'�����ѳ�����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		} 
		if(selectedRow[0].get("IsCancel")=="��")
		{
			      Ext.Msg.show({title:'ע��',msg:'���������ϣ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		} 
        function handler(id){
			if(id=="yes"){
				Ext.Ajax.request({
					url:projUrl+'?action=destroy&&rowid='+selectedRow[0].get("VouchID")+'&userid='+userid,
					waitMsg:'�ύ��...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},

					success: function(result, request){					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'ע��',msg:'�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							itemGrid.load({params:{start:0, limit:12,userid:userid}});
							
						}else{
							Ext.Msg.show({title:'����',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
			    });
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ������ƾ֤��?',handler);
	
}
