

function InitViewport1Event(obj) {
	obj.LoadEvent = function(){};
	obj.GridPanel_rowclick = function(){
		var rowIndex = arguments[1];
		var objRec = obj.GridPanelStore.getAt(rowIndex); 
		obj.rowid.setValue(objRec.get("myid"));
		//alert(obj.rowid.getValue());
	};
	
	obj.GridPanel_rowdblclick = function(){
		obj.btnEdit_click(); 
	};
	
	obj.btnNew_click = function(){
		var objWinEdit = new InitWinEdit(obj);
		objWinEdit.WinEdit.show();
		//ExtDeignerHelper.HandleResize(objWinEdit);
		objWinEdit.hidden1.setValue("");
	};
	
	obj.btnEdit_click = function(){
		var rowid=obj.rowid.getValue();
		if(rowid==""){
			ExtTool.alert("提示","请选择要编辑的一项!");
			return;	
		}
		var CHR_1=String.fromCharCode(1);
		
		var objDic = ExtTool.StaticServerObject("DHCMed.CC.SubjectDic");
		var ret1 = objDic.GetStringById(rowid,CHR_1);
		var Str1=ret1.split(CHR_1);
		var objWinEdit = new InitWinEdit(obj);
		objWinEdit.WinEdit.show();
		//ExtDeignerHelper.HandleResize(objWinEdit);
		
		objWinEdit.hidden1.setValue(Str1[0]);
		objWinEdit.SDCode.setValue(Str1[1]);
		objWinEdit.SDDesc.setValue(Str1[2]);
		objWinEdit.SDInPut.setValue(Str1[3]);
		objWinEdit.SDOutPut.setValue(Str1[4]);
		objWinEdit.SDMethodName.setValue(Str1[5]);
		objWinEdit.SDResume.setValue(Str1[6]);
	};
	obj.btnDelete_click = function()
	{
	 var rowid=obj.rowid.getValue();
   	 if(rowid=="") 
  	  			{
  	 				ExtTool.alert("提示","请选择要删除的一项!");
					return;	
  						}
    ExtTool.confirm('选择框','确定删除?',function(btn){
       		if(btn=="no") 
       			return;
  	try{
  	var objSubDic= ExtTool.StaticServerObject("DHCMed.CC.SubjectDic");
	var dleId = objSubDic.DeleteById(rowid);
	if(dleId<0) {
					ExtTool.alert("提示","删除失败！");
					return;
						}
				else{
					        ExtTool.alert("提示","删除成功！");
							obj.GridPanelStore.removeAll();
							obj.GridPanelStore.load();
					
		                }
				}catch(err)
					{
						ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
						}
					})
					};
	}

function InitWinEditEvent(obj) {
	obj.LoadEvent = function()
  {};
  obj.btnSave_click = function()
	{
		     var CHR_1=String.fromCharCode(1);
             var separete=CHR_1;
             if(obj.SDCode.getValue()=="") {
					ExtTool.alert("提示","代码不能为空！");
					return;
					}
			 if(obj.SDDesc.getValue()=="") {
					ExtTool.alert("提示","描述不能为空！");
					return;
						}
			 if(obj.SDInPut.getValue()=="") {
					ExtTool.alert("提示","输入参数不能为空！");
					return;
						}
			 if(obj.SDOutPut.getValue()=="") {
					ExtTool.alert("提示","输出参数不能为空！");
					return;
						}
				var dicId=obj.hidden1.getValue();
				var tmp = dicId+ separete;
				tmp += obj.SDCode.getValue()+ separete;
				tmp += obj.SDDesc.getValue() + separete;
				tmp += obj.SDInPut.getValue() + separete;
				tmp += obj.SDOutPut.getValue() + separete;
				tmp += obj.SDMethodName.getValue() + separete;
				tmp += obj.SDResume.getValue();
				
				try{    
						var objSubDic= ExtTool.StaticServerObject("DHCMed.CC.SubjectDic");
						var NewID = objSubDic.Update(tmp,separete);
			
						if(NewID<0) {
							ExtTool.alert("提示","保存失败！");
							return;
						}
						else{
							ExtTool.alert("提示","保存成功！");
					 
							var parent=objControlArry['Viewport1'];
							obj.WinEdit.close();
							parent.GridPanelStore.removeAll();
							parent.GridPanelStore.load();
					
		                }
				}catch(err){
						//ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
						ExtTool.alert("提示", "已经存在该代码！");
				}
	};
  obj.btnExit_click = function()
	{
            var parent=objControlArry['Viewport1'];	
			obj.WinEdit.close();
			parent.GridPanelStore.removeAll();
		 	parent.GridPanelStore.load();
	};
  
}

