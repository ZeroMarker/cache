////�ύƾ֤
submitFun = function(){ 

        var selectedRow = itemGrid.getSelectionModel().getSelections();
		var IsCancel=selectedRow[0].get("IsCancel");
        var len = selectedRow.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�ύ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		//var VouchNo=selectedRow[0].get("VouchNo")
		var VouchID="";
		var VouchIDs="";
		for(var j=0;j<len;j++){
					// selectedRow[j].get("VouchState")!="��˲�ͨ��"&&
			if(selectedRow[j].get("IsCancel")!="��"&&selectedRow[j].get("VouchState")!="�ύ"&&selectedRow[j].get("VouchState")!="���ͨ��"&&selectedRow[j].get("VouchState")!="����"&&selectedRow[j].get("VouchState")!="����")
			{	
				var VouchNum=selectedRow[j].get("VouchID");
				if(VouchIDs.indexOf(VouchNum)==-1){		
					if(VouchIDs ==""){
						VouchIDs=VouchNum;
					}else{
						VouchIDs=VouchIDs+","+VouchNum;
					} 
				}
			}
		}
		if(VouchIDs==""){
			Ext.Msg.show({title:'ע��',msg:'ƾ֤���ύ�������ϣ������ظ��ύ! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		}else{
			var str = VouchIDs;
			var arr = new Array();
			arr = str.split(",");
			function handler(id){
				if(id=="yes"){
					for(var i=0;arr.length >= i;i++){
						var VouchID = arr[i].substring(0);
						Ext.Ajax.request({
							url:projUrl+'?action=submit&&rowid='+VouchID+'&userid='+userid,
							waitMsg:'�ύ��...',
							failure: function(result, request){
								Ext.Msg.show({title:'����',msg:'������������! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){					
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true'){
									Ext.Msg.show({title:'ע��',msg:'<br>ƾ֤�ύ�ɹ�! </br><br>����ƾ֤�����ύ! </br><br>���ȷ��,����ʹ��! </br>',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									// alert("ϵͳ���Զ�Ϊ����������ƾ֤��Ԥ�ύ,����ȷ������ʹ�ã�");
									var tbarnum = itemGrid.getBottomToolbar();  
									tbarnum.doLoad(tbarnum.cursor);
								}else{
										var str=jsonData.info;
										var arr = new Array();
										arr = str.split("^");
										var IsBalance = arr[0].substring(0);
										var VouchNo = arr[2].substring(0);
										if(IsBalance == "NoData"){
											var AcctSubjID=arr[1].substring(0);
											function  GetSubjName() {
												Ext.Ajax.request({
													url: projUrl+'?action=GetSubjName&AcctSubjID='+AcctSubjID+'&userid='+userid,method:'POST',
													failure : function(result, request) {
														Ext.Msg.show({title : '����',msg : '������������!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
														return;
													},
													success : function(result, request) {
														var Data = Ext.util.JSON.decode(result.responseText);
														if (Data.success == 'true') {   
															var AcctSubjName=Data.info;	
															Ext.Msg.show({title:'ע��',msg:'ƾ֤��'+VouchNo+'��'+AcctSubjName+'</br>��û¼�븨�������ݣ������ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
															return;
														}
													},
												scope : this
												});
											}      
											GetSubjName(); 	
										}else{											
											var VouchRow = arr[1].substring(0);										
											Ext.Msg.show({title:'ע��',msg:'<br>ƾ֤�� '+VouchNo+' �ĵ�'+VouchRow+'����¼�е�</br><br>���ܽ�����¼�ܽ�һ��,�����ύ! </br>',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
											return;
										}
								}
							},
							scope: this
						});
					}
				}else{
					return;
				}
			}
			Ext.MessageBox.confirm('��ʾ','ȷʵҪ�ύ�ü�¼��? ',handler);
		}		
};



/////����ƾ֤
copyFun=function(){
		var selectedRow = itemGrid.getSelectionModel().getSelections();
        var len = selectedRow.length;
		
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ���Ƶ�ƾ֤! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else if(len > 1){
			Ext.Msg.show({title:'ע��',msg:'ֻ��ѡ��һ����Ҫ���Ƶ�ƾ֤! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		if(selectedRow[0].get("IsCancel")=="��")
		{
			      Ext.Msg.show({title:'ע��',msg:'����������,���ܸ���! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		} 
		var VouchNo=selectedRow[0].get("VouchNo");
        function handler(id){
			if(id=="yes"){
				Ext.Ajax.request({
					url:projUrl+'?action=copy&&rowid='+selectedRow[0].get("VouchID")+'&userid='+userid,
					waitMsg:'�ύ��...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'ע��',msg:'�������! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							//itemGrid.store.load({params:{start:0, limit:25,userid:userid}});
							var tbarnum = itemGrid.getBottomToolbar();  
									tbarnum.doLoad(tbarnum.cursor);
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
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ����'+VouchNo+'ƾ֤��? ',handler);
}



/////����ƾ֤
cacelFun = function () {
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	var len = selectedRow.length;
	if (len < 1) {
		Ext.Msg.show({
			title: 'ע��',
			msg: '��ѡ����Ҫ���ϵ�����! ',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return;
	}
	var VouchID = "";
	var VouchIDs = "";

	for (var j = 0; j < len; j++) {
		if (selectedRow[0].get("IsCancel") != "��" &&
			selectedRow[j].get("VouchState") != "���ͨ��" &&
			selectedRow[j].get("VouchState") != "����" &&
			selectedRow[j].get("VouchState") != "����") {
		
			var VouchNo = selectedRow[j].get("VouchID");
			
			// ���������Լ���ƾ֤,�����ύ���ǿ������ϵ�
			if (VouchIDs.indexOf(VouchNo) == -1) {
				if (VouchIDs == "") {
					VouchIDs = VouchNo;
				} else {
					VouchIDs = VouchIDs + "," + VouchNo;
				}
			}

		}
	}
	if (VouchIDs == "") {
		Ext.Msg.show({
			title: 'ע��',
			msg: 'ƾ֤�����������ύ״̬�����������ϣ���������! ',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.INFO
		});
	} else {
		var str = VouchIDs;
		var arr = new Array();
		arr = str.split(",");

		function handler(id) {
			if (id == "yes") {
				for (var i = 0; arr.length >= i; i++) {
					var VouchID = arr[i].substring(0);
					//alert(VouchID)
					Ext.Ajax.request({
						url: projUrl + '?action=cacel&&rowid=' + VouchID + '&userid=' + userid,
						waitMsg: '������...',
						failure: function (result, request) {
							Ext.Msg.show({
								title: '����',
								msg: '������������! ',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR
							});
						},
						success: function (result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
									title: 'ע��',
									msg: '�������! ',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.INFO
								});
								//itemGrid.store.load({params:{start:0, limit:25,userid:userid}});
								var tbarnum = itemGrid.getBottomToolbar();
								tbarnum.doLoad(tbarnum.cursor);
							} else {
								Ext.Msg.show({
									title: '����',
									msg: jsonData.info,
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.ERROR
								});
							}
						},
						scope: this
					});
				}
			} else {
				return;
			}

		}
		Ext.MessageBox.confirm('��ʾ', 'ȷʵҪ���ϴ�ƾ֤��? ', handler);
	}

}

/////����ƾ֤
destroyFun=function(){
		var selectedRow = itemGrid.getSelectionModel().getSelections();
        var len = selectedRow.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ������ƾ֤! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else if(len > 1){
			Ext.Msg.show({title:'ע��',msg:'ֻ��ѡ��һ����Ҫ������ƾ֤! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		if(selectedRow[0].get("IsDestroy")=="��")
		{
			      Ext.Msg.show({title:'ע��',msg:'�����ѳ����������ٳ���! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		} 
		if(selectedRow[0].get("IsCancel")=="��")
		{
			      Ext.Msg.show({title:'ע��',msg:'����������,���ܳ���! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		} 
		var VouchNo=selectedRow[0].get("VouchNo");
        function handler(id){
			if(id=="yes"){
				Ext.Ajax.request({
					url:projUrl+'?action=destroy&&rowid='+selectedRow[0].get("VouchID")+'&userid='+userid,
					waitMsg:'�ύ��...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'ע��',msg:'�������! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							//itemGrid.store.load({params:{start:0, limit:25,userid:userid}});
							var tbarnum = itemGrid.getBottomToolbar();  
							tbarnum.doLoad(tbarnum.cursor);
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
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ����'+VouchNo+'ƾ֤��? ',handler);
}
