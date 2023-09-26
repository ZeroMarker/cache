

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
			ExtTool.alert("��ʾ","��ѡ��Ҫ�༭��һ��!");
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
  	 				ExtTool.alert("��ʾ","��ѡ��Ҫɾ����һ��!");
					return;	
  						}
    ExtTool.confirm('ѡ���','ȷ��ɾ��?',function(btn){
       		if(btn=="no") 
       			return;
  	try{
  	var objSubDic= ExtTool.StaticServerObject("DHCMed.CC.SubjectDic");
	var dleId = objSubDic.DeleteById(rowid);
	if(dleId<0) {
					ExtTool.alert("��ʾ","ɾ��ʧ�ܣ�");
					return;
						}
				else{
					        ExtTool.alert("��ʾ","ɾ���ɹ���");
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
					ExtTool.alert("��ʾ","���벻��Ϊ�գ�");
					return;
					}
			 if(obj.SDDesc.getValue()=="") {
					ExtTool.alert("��ʾ","��������Ϊ�գ�");
					return;
						}
			 if(obj.SDInPut.getValue()=="") {
					ExtTool.alert("��ʾ","�����������Ϊ�գ�");
					return;
						}
			 if(obj.SDOutPut.getValue()=="") {
					ExtTool.alert("��ʾ","�����������Ϊ�գ�");
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
							ExtTool.alert("��ʾ","����ʧ�ܣ�");
							return;
						}
						else{
							ExtTool.alert("��ʾ","����ɹ���");
					 
							var parent=objControlArry['Viewport1'];
							obj.WinEdit.close();
							parent.GridPanelStore.removeAll();
							parent.GridPanelStore.load();
					
		                }
				}catch(err){
						//ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
						ExtTool.alert("��ʾ", "�Ѿ����ڸô��룡");
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

