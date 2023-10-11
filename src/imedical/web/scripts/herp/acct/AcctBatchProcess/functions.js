////提交凭证
submitFun = function(){ 

        var selectedRow = itemGrid.getSelectionModel().getSelections();
		var IsCancel=selectedRow[0].get("IsCancel");
        var len = selectedRow.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要提交的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		//var VouchNo=selectedRow[0].get("VouchNo")
		var VouchID="";
		var VouchIDs="";
		for(var j=0;j<len;j++){
					// selectedRow[j].get("VouchState")!="审核不通过"&&
			if(selectedRow[j].get("IsCancel")!="是"&&selectedRow[j].get("VouchState")!="提交"&&selectedRow[j].get("VouchState")!="审核通过"&&selectedRow[j].get("VouchState")!="结账"&&selectedRow[j].get("VouchState")!="记账")
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
			Ext.Msg.show({title:'注意',msg:'凭证已提交或已作废，请勿重复提交! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
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
							waitMsg:'提交中...',
							failure: function(result, request){
								Ext.Msg.show({title:'错误',msg:'请检查网络连接! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){					
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true'){
									Ext.Msg.show({title:'注意',msg:'<br>凭证提交成功! </br><br>作废凭证不会提交! </br><br>点击确定,放心使用! </br>',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									// alert("系统已自动为您过滤作废凭证不预提交,请点击确定放心使用！");
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
														Ext.Msg.show({title : '错误',msg : '请检查网络连接!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
														return;
													},
													success : function(result, request) {
														var Data = Ext.util.JSON.decode(result.responseText);
														if (Data.success == 'true') {   
															var AcctSubjName=Data.info;	
															Ext.Msg.show({title:'注意',msg:'凭证号'+VouchNo+'的'+AcctSubjName+'</br>还没录入辅助账数据，不能提交！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
															return;
														}
													},
												scope : this
												});
											}      
											GetSubjName(); 	
										}else{											
											var VouchRow = arr[1].substring(0);										
											Ext.Msg.show({title:'注意',msg:'<br>凭证号 '+VouchNo+' 的第'+VouchRow+'条分录中的</br><br>的总金额与分录总金额不一致,不能提交! </br>',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
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
			Ext.MessageBox.confirm('提示','确实要提交该记录吗? ',handler);
		}		
};



/////复制凭证
copyFun=function(){
		var selectedRow = itemGrid.getSelectionModel().getSelections();
        var len = selectedRow.length;
		
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要复制的凭证! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else if(len > 1){
			Ext.Msg.show({title:'注意',msg:'只能选择一条需要复制的凭证! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		if(selectedRow[0].get("IsCancel")=="是")
		{
			      Ext.Msg.show({title:'注意',msg:'数据已作废,不能复制! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		} 
		var VouchNo=selectedRow[0].get("VouchNo");
        function handler(id){
			if(id=="yes"){
				Ext.Ajax.request({
					url:projUrl+'?action=copy&&rowid='+selectedRow[0].get("VouchID")+'&userid='+userid,
					waitMsg:'提交中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'复制完成! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							//itemGrid.store.load({params:{start:0, limit:25,userid:userid}});
							var tbarnum = itemGrid.getBottomToolbar();  
									tbarnum.doLoad(tbarnum.cursor);
						}else{
							Ext.Msg.show({title:'错误',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
			    });
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要复制'+VouchNo+'凭证吗? ',handler);
}



/////作废凭证
cacelFun = function () {
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	var len = selectedRow.length;
	if (len < 1) {
		Ext.Msg.show({
			title: '注意',
			msg: '请选择需要作废的数据! ',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return;
	}
	var VouchID = "";
	var VouchIDs = "";

	for (var j = 0; j < len; j++) {
		if (selectedRow[0].get("IsCancel") != "是" &&
			selectedRow[j].get("VouchState") != "审核通过" &&
			selectedRow[j].get("VouchState") != "结账" &&
			selectedRow[j].get("VouchState") != "记账") {
		
			var VouchNo = selectedRow[j].get("VouchID");
			
			// 可以作废自己的凭证,所以提交的是可以作废的
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
			title: '注意',
			msg: '凭证不是新增或提交状态，或者已作废，不能作废! ',
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
						waitMsg: '作废中...',
						failure: function (result, request) {
							Ext.Msg.show({
								title: '错误',
								msg: '请检查网络连接! ',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR
							});
						},
						success: function (result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
									title: '注意',
									msg: '作废完成! ',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.INFO
								});
								//itemGrid.store.load({params:{start:0, limit:25,userid:userid}});
								var tbarnum = itemGrid.getBottomToolbar();
								tbarnum.doLoad(tbarnum.cursor);
							} else {
								Ext.Msg.show({
									title: '错误',
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
		Ext.MessageBox.confirm('提示', '确实要作废此凭证吗? ', handler);
	}

}

/////冲销凭证
destroyFun=function(){
		var selectedRow = itemGrid.getSelectionModel().getSelections();
        var len = selectedRow.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要冲销的凭证! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else if(len > 1){
			Ext.Msg.show({title:'注意',msg:'只能选择一条需要冲销的凭证! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		if(selectedRow[0].get("IsDestroy")=="是")
		{
			      Ext.Msg.show({title:'注意',msg:'数据已冲销，不能再冲销! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		} 
		if(selectedRow[0].get("IsCancel")=="是")
		{
			      Ext.Msg.show({title:'注意',msg:'数据已作废,不能冲销! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		} 
		var VouchNo=selectedRow[0].get("VouchNo");
        function handler(id){
			if(id=="yes"){
				Ext.Ajax.request({
					url:projUrl+'?action=destroy&&rowid='+selectedRow[0].get("VouchID")+'&userid='+userid,
					waitMsg:'提交中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'冲销完成! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							//itemGrid.store.load({params:{start:0, limit:25,userid:userid}});
							var tbarnum = itemGrid.getBottomToolbar();  
							tbarnum.doLoad(tbarnum.cursor);
						}else{
							Ext.Msg.show({title:'错误',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
			    });
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要冲销'+VouchNo+'凭证吗? ',handler);
}
