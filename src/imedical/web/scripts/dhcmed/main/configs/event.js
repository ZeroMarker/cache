

function InitViewport1Event(obj) {
	obj.LoadEvent = function() {
		obj.GridPanel.on("rowdblclick", obj.GridPanel_rowdblclick, obj);
		obj.btnNew.on("click", obj.btnNew_click, obj);
		obj.btnEdit.on("click", obj.btnEdit_click, obj);
		obj.btnDelete.on("click", obj.btnDelete_click, obj);
		obj.GridPanelStore.load({});
	};
	
	obj.GridPanel_rowdblclick = function()
	{
		obj.ConfigEdit();
	};
	obj.btnNew_click = function()
	{
		 var objWinEdit = new InitWinEdit();
         objWinEdit.WinEdit.show();
         //ExtDeignerHelper.HandleResize(objWinEdit);
         //objWinEdit.winhidden.setValue("");   //fix IE11 兼容问题 点击【新建】，报错“无法获取未定义或 null 引用的属性“setValue””
	};
	
	obj.btnDelete_click = function()
	{
		var objGrid = Ext.getCmp("GridPanel");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if (arrRec.length>0){
				Ext.MessageBox.confirm('删除', '是否删除选中配置项?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							var RowID = objRec.get("myid");
							var flg = ExtTool.RunServerMethod("DHCMed.SS.Config","DeleteById",RowID);
							if (parseInt(flg) < 0) {
								ExtTool.alert("错误提示","删除数据错误!Error=" + flg);
							} else {
								objGrid.getStore().remove(objRec);
								//fix bug 113645 成功删除记录后，记录条数未自动刷新
								obj.GridPanelStore.load({});
							}
						}
					}
				});
			} else {
				ExtTool.alert("提示","请选中数据记录,再点击删除!");
			}
		}
	}
	
	obj.btnEdit_click = function()
	{
		obj.ConfigEdit();
	};
	
	/*
	*配置项编辑
	*/
	obj.ConfigEdit = function() {
		var selectObj = obj.GridPanel.getSelectionModel().getSelected();
		if (selectObj){
			var objWinEdit = new InitWinEdit(selectObj);
			objWinEdit.Keys.setDisabled(true);
			objWinEdit.WinEdit.show();
		}
		else{
			ExtTool.alert("提示","请先选中一行!");
		}		
	}
}
function InitWinEditEvent(obj) {
	
	var objConfig1 = ExtTool.StaticServerObject("DHCMed.SS.Config");
  	var objConfig2 = ExtTool.StaticServerObject("DHCMed.SSService.ConfigSrv");
  	var parent=objControlArry['Viewport1'];	
	obj.LoadEvent = function()
	{		
		var data = arguments[0][0];
  		if (data){
  			//可通过FormPanel.getForm().loadRecord()方法为整个Form加载值
  			//前提是form上的field的名字与record中的名字一致
  			obj.winfPanel.getForm().loadRecord(data);
  			var CHR_1=String.fromCharCode(1);
  			var configId = data.get("myid");
  			var ret2 = objConfig2.GetStringById(configId,CHR_1);
            var Str2=ret2.split(CHR_1);
		    ExtTool.AddComboItem(obj.ProName,Str2[8],Str2[5]);
		    ExtTool.AddComboItem(obj.HispsDescs,Str2[9],Str2[6]);
  			/*
  			var CHR_1=String.fromCharCode(1);
  			var configId = data.get("myid");
  			//var objConfig1 = ExtTool.StaticServerObject("DHCMed.SS.Config");
        	//var ret1 = objConfig1.GetStringById(configId,CHR_1);
        	var ret2 = objConfig2.GetStringById(configId,CHR_1);
            //var Str1=ret1.split(CHR_1);
            var Str2=ret2.split(CHR_1);
           
			//obj.rowid.setValue(Str[0]);
	        obj.winhidden.setValue(Str2[0]);
			obj.Keys.setValue(Str2[1]);
			obj.Keys.setReadOnly(true);
			obj.Keys.setDisabled(true);
			obj.Description1.setValue(Str2[2]);
			obj.Val.setValue(Str2[3]);
			obj.ValueDesc.setValue(Str2[4]);
		    
			//ExtTool.AddComboItem(objWinEdit.HispsDescs,"1yyyyy","1");
		    ExtTool.AddComboItem(obj.ProName,Str2[8],Str2[5]);
		    ExtTool.AddComboItem(obj.HispsDescs,Str2[9],Str2[6]);
			//	objWinEdit.ProName.setValue(Str2[4]); //设置id		  
			//	objWinEdit.HispsDescs.setValue(Str2[5]);			
			//objWinEdit.HispsDescs.setRowValue(Str2[5]);          
        	obj.Resume.setValue(Str2[7]);
        	*/
        }
		
		
		obj.ProName.on("expand", function(){
			obj.ProName.clearValue();
		});
		obj.HispsDescs.on("expand", function(){
			obj.HispsDescs.clearValue();
		});		
	};
	obj.btnSave_click = function()
	{
		var CHR_1=String.fromCharCode(1);
	        
		if(obj.Keys.getValue()=="")
		{
			ExtTool.alert("提示","键不能为空!");
			return;			
		}
		if(obj.Val.getValue()=="")
		{
			ExtTool.alert("提示","值不能为空!");
			return;
		}
		if(obj.Description.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");
			return;			
		}
		
		
        var CHR_1=String.fromCharCode(1);
        var separete=CHR_1;
		var configId=obj.myid.getValue();
	  if(configId=="")
	  {
	  	var IsCheck=objConfig2.CheckKey(obj.Keys.getValue(),obj.HispsDescs.getValue());
	  	if(IsCheck==1)
	  	{
	  		ExtTool.alert("提示","键(Keys)重复,请重新填写！");
				return;
	  	}
	  }
		var tmp = configId+ separete;
		tmp += obj.Keys.getValue()+ separete;
		tmp += obj.Description.getValue() + separete;
		tmp += obj.Val.getValue() + separete;
		tmp += obj.ValueDesc.getValue() + separete;
		tmp += obj.ProName.getValue() + separete;	
		tmp += obj.HispsDescs.getValue() + separete;
		
		tmp += obj.Resume.getValue() + separete;
		try
		{
			var NewID = objConfig1.Update(tmp,separete);
			if(NewID<0) {
				ExtTool.alert("提示","保存失败！");
				return;
			}
			else{
				ExtTool.alert("提示","保存成功！");
				
				//obj.btnExit_click();
				obj.WinEdit.close();
				//parent.GridPanelStore.removeAll();
				parent.GridPanelStore.load({params : {start:0,limit:1000}});
			}
		}
		catch(err)
		{
			//ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			//ExtTool.alert("提示", "已经存在该键和医院！");
			ExtTool.alert("提示", err.description,Ext.MessageBox.ERROR);
		}
	};
	obj.btnCancel_click = function()
	{
		//var parentWin=objWinEdit.parentWin;
		obj.WinEdit.close();
		parent.GridPanelStore.load({
		//Modified By LiYang 2012-03-14 去掉翻页功能
		//params : {start:0,limit:1000}
		});
		//parentWin.GridPanelStore.load();
		//objControlArry['Viewport1'].GridPanelStore.load();
	
	};

	
}

