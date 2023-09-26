
function InitViewScreenEvent(obj)
{
	obj.LoadEvent = function(args)
	{
		
	}
	obj.addbutton_click=function()
	{   
	    
		var _DHCANOPReport = ExtTool.StaticServerObject("web.DHCANOPReport");
		var code=obj.code.getValue()
		var name=obj.name.getValue()
		var statType=obj.statType.getRawValue(); 
		var operStat=obj.operStat.getRawValue();
		var statTypeID=obj.statType.getValue();
		var operStatID=obj.operStat.getValue();
		alert(code);
		alert(name);
		alert(statType);
		alert(operStat);
		alert(statTypeID);
		alert(operStatID);
		var ret = _DHCANOPReport.TypeAdd(code,statTypeID,name,statType,operStat,operStatID);
        if(ret!="0")
		{
			ExtTool.alert("提示",ret);
			return;
		}
		else
		{   
			Ext.Msg.alert("提示","增加成功！",function(){
			 obj.code.setValue("");
			 obj.name.setValue("");
			 obj.statType.setValue("");
			 obj.operStat.setValue("");
			 obj.statTypeID.setValue("");
			 obj.retGridPanelStore.load({});  
			//parent.retGridPanelStore.removeAll();
			//parent.retGridPanelStore.load({});
			})
		}
	};
	obj.updatebutton_click = function()
	{
		var _DHCANOPReport = ExtTool.StaticServerObject("web.DHCANOPReport");
		var code=obj.code.getValue()
		var name=obj.name.getValue()
		var statType=obj.statType.getRawValue(); 
		var operStat=obj.operStat.getRawValue();
		var ststatCode=obj.statType.getValue();
		var operStatID=obj.operStat.getValue();
		alert(code);
		alert(name);
		alert(statType);
		alert(operStat);
		alert(ststatCode);
		alert(operStatID);
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
	    {   
			var oldCode=selectObj.get('tcode');
			obj.code.setValue(oldCode);
			var statTypeID=selectObj.get('tstatTypeID');
			obj.statTypeID.setValue(statTypeID);
        }
        
		var ret = _DHCANOPReport.TypeUpdate(oldCode,code,statTypeID,ststatCode,name,statType,operStat,operStatID);
        if(ret!=0)
		{
			ExtTool.alert("提示",ret);
			return;
		}
		else
		{
			obj.retGridPanelStore.removeAll();
			obj.retGridPanelStore.load({});
		}
	};
	obj.deletebutton_click = function()
	{
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
		{
			    var code=selectObj.get('tcode');
			    var statTypeID=selectObj.get('tstatTypeID');
			    
			ExtTool.confirm('选择框','确定删除?',function(btn){
				if(btn=="no") return;
				var _DHCANOPReport = ExtTool.StaticServerObject("web.DHCANOPReport");
				//alert(selectObj.get("tmpcomLocId"));
				alert(statTypeID);
				alert(code);
				var ret = _DHCANOPReport.TypeDel(statTypeID,code);
				if(ret=='0')
				{
					ExtTool.alert("信息","删除成功!");
					obj.retGridPanelStore.removeAll();
			    	obj.retGridPanelStore.load({});
					return;
				}
		 		if(ret!='0')
		 		{
		 			ExtTool.alert("提示",ret);
		 			return;	
		 		}
			});
		}
		else
	 	{
	 		ExtTool.alert("提示","请先选中一行！");
	 		return;
	 	}
	 	
	};
	
	/////////////////////////////////
	
	obj.schbuttonList_click=function()
	{   
	    obj.retGridPanelListStore.removeAll();
		obj.retGridPanelListStore.load({});
	};


	
	
	obj.retGridPanel_rowclick=function() //点击后获取数据
	{
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
	    {   
			var code=selectObj.get('tcode');
			obj.code.setValue(code);
			var name=selectObj.get('tname');
			obj.name.setValue(name);
			var statType=selectObj.get('tstatType');
			obj.statType.setValue(statType);
			var operStat=selectObj.get('toperStat');
			obj.operStat.setValue(operStat);
			var statTypeID=selectObj.get('tstatTypeID');
			obj.statTypeID.setValue(statTypeID);
			obj.retGridPanelListStore.load({});
		}
	}
	
}



