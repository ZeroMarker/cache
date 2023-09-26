

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
         //objWinEdit.winhidden.setValue("");   //fix IE11 �������� ������½����������޷���ȡδ����� null ���õ����ԡ�setValue����
	};
	
	obj.btnDelete_click = function()
	{
		var objGrid = Ext.getCmp("GridPanel");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if (arrRec.length>0){
				Ext.MessageBox.confirm('ɾ��', '�Ƿ�ɾ��ѡ��������?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							var RowID = objRec.get("myid");
							var flg = ExtTool.RunServerMethod("DHCMed.SS.Config","DeleteById",RowID);
							if (parseInt(flg) < 0) {
								ExtTool.alert("������ʾ","ɾ�����ݴ���!Error=" + flg);
							} else {
								objGrid.getStore().remove(objRec);
								//fix bug 113645 �ɹ�ɾ����¼�󣬼�¼����δ�Զ�ˢ��
								obj.GridPanelStore.load({});
							}
						}
					}
				});
			} else {
				ExtTool.alert("��ʾ","��ѡ�����ݼ�¼,�ٵ��ɾ��!");
			}
		}
	}
	
	obj.btnEdit_click = function()
	{
		obj.ConfigEdit();
	};
	
	/*
	*������༭
	*/
	obj.ConfigEdit = function() {
		var selectObj = obj.GridPanel.getSelectionModel().getSelected();
		if (selectObj){
			var objWinEdit = new InitWinEdit(selectObj);
			objWinEdit.Keys.setDisabled(true);
			objWinEdit.WinEdit.show();
		}
		else{
			ExtTool.alert("��ʾ","����ѡ��һ��!");
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
  			//��ͨ��FormPanel.getForm().loadRecord()����Ϊ����Form����ֵ
  			//ǰ����form�ϵ�field��������record�е�����һ��
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
			//	objWinEdit.ProName.setValue(Str2[4]); //����id		  
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
			ExtTool.alert("��ʾ","������Ϊ��!");
			return;			
		}
		if(obj.Val.getValue()=="")
		{
			ExtTool.alert("��ʾ","ֵ����Ϊ��!");
			return;
		}
		if(obj.Description.getValue()=="")
		{
			ExtTool.alert("��ʾ","��������Ϊ��!");
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
	  		ExtTool.alert("��ʾ","��(Keys)�ظ�,��������д��");
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
				ExtTool.alert("��ʾ","����ʧ�ܣ�");
				return;
			}
			else{
				ExtTool.alert("��ʾ","����ɹ���");
				
				//obj.btnExit_click();
				obj.WinEdit.close();
				//parent.GridPanelStore.removeAll();
				parent.GridPanelStore.load({params : {start:0,limit:1000}});
			}
		}
		catch(err)
		{
			//ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			//ExtTool.alert("��ʾ", "�Ѿ����ڸü���ҽԺ��");
			ExtTool.alert("��ʾ", err.description,Ext.MessageBox.ERROR);
		}
	};
	obj.btnCancel_click = function()
	{
		//var parentWin=objWinEdit.parentWin;
		obj.WinEdit.close();
		parent.GridPanelStore.load({
		//Modified By LiYang 2012-03-14 ȥ����ҳ����
		//params : {start:0,limit:1000}
		});
		//parentWin.GridPanelStore.load();
		//objControlArry['Viewport1'].GridPanelStore.load();
	
	};

	
}

