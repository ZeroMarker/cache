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
		  //项目
	    obj.form1.setValue(rc.get("tItemDesc"));
	    //控制类型
	    obj.form2.setValue(rc.get("ctrType"));
	    obj.form2.setRawValue(rc.get("tCtrType"));
	    //代码
	    obj.form3.setValue(rc.get("tItemCode"));
	    //项目种类
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
			ExtTool.alert("提示","项目名称不可为空");
			return;
			}
		if((itemCode=="")) 
		{
			ExtTool.alert("提示","项目代码不可为空");
			return;
			}
		if((itemType=="")) 
		{
			ExtTool.alert("提示","项目种类不可为空");
			return;
			}
		if((ctrType=="")) 
		{
			ExtTool.alert("提示","控制类型不可为空");
			return;
			}
		var ret=_DHCANCOPItemCheck.InsertItemCheck(itemCode,itemDesc,ctrType,itemType);
		
		if(ret=='0')
		{
			ExtTool.alert("提示","插入失败");
			}
		if(ret=='1')
		{
			ExtTool.alert("提示","插入成功");
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
			ExtTool.alert("提示","请选择一条记录");
			return;
		}  
	    var itemType=_DHCANCOPItemCheck.GetItemType(obj.form4.getRawValue());
		var ret=_DHCANCOPItemCheck.DeleteItemCheck(itemType,rowId);
		
		if(ret=='0')
		{
			ExtTool.alert("提示","删除失败");
			}
		if(ret=='1')
		{
			ExtTool.alert("提示","删除成功");
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
	  else{ExtTool.alert("提示","请选择一条记录");
			return;}  
		var itemCode=obj.form3.getValue();                 
		var itemDesc=obj.form1.getValue();       
		var ctrType=obj.form2.getValue();  
		var itemType=_DHCANCOPItemCheck.GetItemType(obj.form4.getRawValue()); 
		var ret=_DHCANCOPItemCheck.UpdateItemCheck(itemCode, itemDesc, ctrType, itemType, rowId,oldStr);
		
		if(ret=='0')
		{
			ExtTool.alert("提示","更新失败");
			}
		if(ret=='1')
		{
			ExtTool.alert("提示","更新成功");
			obj.form3.setValue("");                 
		obj.form1.setValue("");       
		obj.form2.setValue("");
		obj.form4.setValue("");  
		    obj.retGridPanelStore.removeAll();
		    obj.retGridPanelStore.reload({});
	    }
	}
}