function InitViewScreenEvent(obj)
{
	var _DHCANCOPItemCheck=ExtTool.StaticServerObject('web.DHCANCOPItemCheck');
	{
		//alert(0)
	};
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected(); 
	  if (rc){
		  //��Ŀ
	    obj.form1.setValue(rc.get("tItemDesc"));
	    //��������
	    obj.form2.setValue(rc.get("ctrType"));
	    obj.form2.setRawValue(rc.get("tCtrType"));
	    //����
	    obj.form3.setValue(rc.get("tItemCode"));
	    //��Ŀ����
	    obj.form4.setValue(rc.get("tItemType"));
	    
	  }
	};
	obj.addbutton_click=function()
	{
		var itemCode=obj.form3.getValue();                 
		var itemDesc=obj.form1.getValue();       
		var ctrType=obj.form2.getValue();  
		var itemType=_DHCANCOPItemCheck.GetItemType(obj.form4.getRawValue()); 
		if((itemDesc=="")) 
		{
			ExtTool.alert("��ʾ","��Ŀ���Ʋ���Ϊ��");
			return;
			}
		if((itemCode=="")) 
		{
			ExtTool.alert("��ʾ","��Ŀ���벻��Ϊ��");
			return;
			}
		if((itemType=="")) 
		{
			ExtTool.alert("��ʾ","��Ŀ���಻��Ϊ��");
			return;
			}
		if((ctrType=="")) 
		{
			ExtTool.alert("��ʾ","�������Ͳ���Ϊ��");
			return;
			}
		var ret=_DHCANCOPItemCheck.InsertItemCheck(itemCode,itemDesc,ctrType,itemType);
		
		if(ret=='0')
		{
			ExtTool.alert("��ʾ","����ʧ��");
			}
		if(ret=='1')
		{
			ExtTool.alert("��ʾ","����ɹ�");
			obj.form3.setValue("");                 
		obj.form1.setValue("");       
		obj.form2.setValue("");  
		obj.form4.setValue("");
		    obj.retGridPanelStore.removeAll();
		    obj.retGridPanelStore.reload({});
	    }
	}
	obj.deletebutton_click=function()
	{
       var rowId=""
		var rc = obj.retGridPanel.getSelectionModel().getSelected(); 
	  if (rc){
	    var rowId=rc.get("ID");
	    
	  } 
	  else
		{
			ExtTool.alert("��ʾ","��ѡ��һ����¼");
			return;
		}  
	    var itemType=_DHCANCOPItemCheck.GetItemType(obj.form4.getRawValue());
		var ret=_DHCANCOPItemCheck.DeleteItemCheck(itemType,rowId);
		
		if(ret=='0')
		{
			ExtTool.alert("��ʾ","ɾ��ʧ��");
			}
		if(ret=='1')
		{
			ExtTool.alert("��ʾ","ɾ���ɹ�");
			obj.form3.setValue("");                 
		obj.form1.setValue("");       
		obj.form2.setValue("");  
		obj.form4.setValue("");
		    obj.retGridPanelStore.removeAll();
		    obj.retGridPanelStore.reload({});
	    }
	}
	obj.updatabutton_click=function()
	{
		var rowId=""
		var rc = obj.retGridPanel.getSelectionModel().getSelected(); 
	  if (rc)
	  {
		  //20160914+dyl
		  var rowId=rc.get("ID");
		  var oldCode=rc.get("tItemCode");
		  var oldDesc=rc.get("tItemDesc");
		  var oldType=rc.get("tTypeCode");
		  var oldCtroType=rc.get("tCtrType");
		  var oldStr=oldCode+"^"+oldDesc+"^"+oldCtroType+"^"+oldType
	  } 
	  else{ExtTool.alert("��ʾ","��ѡ��һ����¼");
			return;}  
		var itemCode=obj.form3.getValue();                 
		var itemDesc=obj.form1.getValue();       
		var ctrType=obj.form2.getValue();  
		var itemType=_DHCANCOPItemCheck.GetItemType(obj.form4.getRawValue()); 
		var ret=_DHCANCOPItemCheck.UpdateItemCheck(itemCode, itemDesc, ctrType, itemType, rowId,oldStr);
		
		if(ret=='0')
		{
			ExtTool.alert("��ʾ","����ʧ��");
			}
		if(ret=='1')
		{
			ExtTool.alert("��ʾ","���³ɹ�");
			obj.form3.setValue("");                 
		obj.form1.setValue("");       
		obj.form2.setValue("");
		obj.form4.setValue("");  
		    obj.retGridPanelStore.removeAll();
		    obj.retGridPanelStore.reload({});
	    }
	}
}