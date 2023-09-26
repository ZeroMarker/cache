function InitViewScreenEvent(obj)
{
	//20151013+dyl+标准版修改
	var _DHCANCOrc=ExtTool.StaticServerObject('web.DHCANCOrc');
	obj.LoadEvent = function(args) 
	{
	};
    var SelectedRowID = 0;
	var preRowID=0;
	
	obj.retGridPanel_rowclick = function()
	{
	  var rc ="";
	  rc =obj.retGridPanel.getSelectionModel().getSelected();
	  var linenum=obj.retGridPanel.getSelectionModel().lastActive;
	  if (rc)
	  {
		SelectedRowID=rc.get("tOperId");
	    if(preRowID!=SelectedRowID)
	    {   
	    	var AnCoplStr="";
			var BodssStr="";
			var ancOPCStr="";
			var OperPositionStr="";
		    obj.RowId.setValue(rc.get("tOperId"));
		    obj.ancORCCode.setValue(rc.get("tOperCode"));
		     obj.ancORCCode.disable();
		    obj.ancORCDesc.setValue(rc.get("tOperDesc")); 
		    obj.ancORCDesc.disable();
		    //obj.AnCoplDr.setValue(rc.get("tAncoplId"));20160830+dyl
		     //obj.AnCoplDr.setRawValue(rc.get("tAncoplDesc"));
		    obj.opType.setValue(rc.get("tOpTypeCode"));
		    obj.opType.setRawValue(rc.get("tOpType"));
		    obj.BodssDr.setValue(rc.get("tBodsId"));
		    obj.ancOPCModelDr.setValue(rc.get("tBldtpId"));
		    obj.OperPositionModelDr.setValue(rc.get("tOperPositionId"));
		   	obj.OperCategModelDr.setValue(rc.get("tOperCategId"));
		    preRowID=SelectedRowID;
	    }
	    else
	    {
		  
		    obj.ancORCCode.setValue("");
		    obj.ancORCCode.enable();
		  	obj.ancORCDesc.setValue("");
		  	obj.ancORCDesc.enable();
		    obj.RowId.setValue("");
		    //obj.AnCoplDr.setValue("");20160830+dyl
		    obj.BodssDr.setValue("");
		    obj.ancOPCModelDr.setValue("");
		    obj.OperPositionModelDr.setValue("");
		    obj.opType.setValue("");	//手术类型
		    obj.OperCategModelDr.setValue("");	//手术分类
		    obj.retGridPanel.getSelectionModel().deselectRow(linenum);
		    SelectedRowID = 0;
		    preRowID=0;
		    
		}
	  }
	};
	//增加
	obj.addbutton_click = function()
	{
		///var opaId=obj.opaId.getValue();
        //var Rowid=obj.RowId.getValue();
        //手术名称
        var ancORCDesc=obj.ancORCDesc.getValue();
        if(ancORCDesc=="")
        {
	        Ext.Msg.alert("提示","描述为空");
	        return;
        }
        //手术代码
        var ancORCCode=obj.ancORCCode.getValue();
         if(ancORCCode=="")
        {
	        Ext.Msg.alert("提示","代码为空");
	        return;
        }
        //手术规模已停用+20160830+dyl
        //var AnCoplDr=obj.AnCoplDr.getValue();
        //alert(AnCoplDr);
        //手术部位
        var BodssDr=obj.BodssDr.getValue();
         //alert(BodssDr);
         //切刀类型
        var ancOPCModelDr=obj.ancOPCModelDr.getValue();
         //alert(ancOPCModelDr);
         //手术部位
        var OperPositionModelDr=obj.OperPositionModelDr.getValue();
         //alert(OperPositionModelDr);
         //手术规模已停用+20160830+dyl:AnCoplDr
         var dhcOrcOperStr=""+"^"+ancOPCModelDr+"^"+BodssDr+"^"+OperPositionModelDr
         //alert(dhcOrcOperStr);
         //手术分类：
         var OperCateDr=obj.OperCategModelDr.getValue();
         //手术类型
         var opType=obj.opType.getValue();
		var ret =_DHCANCOrc.AddDHCOrcOperation(ancORCDesc,ancORCCode,dhcOrcOperStr,OperCateDr,opType);
	
		//alert(ret);
		if(ret<0)
		{
		  Ext.Msg.alert("提示","增加失败！");	
		}
		else
		{
		  	Ext.Msg.alert("提示","增加成功！",function(){
	  	  	obj.RowId.setValue("");
	  	  	obj.ancORCCode.setValue("");
	  	  	obj.ancORCDesc.setValue("");
	  	  	//obj.AnCoplDr.setValue("");	//20160830+dyl
	  	  	obj.BodssDr.setValue("");
	  	  	obj.opType.setValue("");
	  	  	obj.ancOPCModelDr.setValue("");
	  	  	obj.OperPositionModelDr.setValue("");
	  	  	obj.OperCategModelDr.setValue("");
	  	  	obj.retGridPanelStore.removeAll();
	  	  	obj.retGridPanelStore.load({
		  	   params : {
				start:0
				,limit:200
			}
		  	  	}); 
		 	});
	     }
	 };

	
	//修改
	obj.updatebutton_click = function()
	{
		///var opaId=obj.opaId.getValue();
        var Rowid=obj.RowId.getValue();
        if(Rowid=="")
        {
	         Ext.Msg.alert("提示","请选择一条记录");
	        return;
        }
        //手术代码
        var ancORCCode=obj.ancORCCode.getValue();
        
        //手术规模已停用+20160830+dyl
       // var AnCoplDr=obj.AnCoplDr.getValue();
        //alert(AnCoplDr);
        //手术部位
        var BodssDr=obj.BodssDr.getValue();
         //alert(BodssDr);
         //切刀类型
        var ancOPCModelDr=obj.ancOPCModelDr.getValue();
         //alert(ancOPCModelDr);
         //手术部位
        var OperPositionModelDr=obj.OperPositionModelDr.getValue();
         //alert(OperPositionModelDr);
         //var dhcOrcOperStr=AnCoplDr+"^"+ancOPCModelDr+"^"+BodssDr+"^"+OperPositionModelDr
         //手术规模已停用+20160830+dyl
         var dhcOrcOperStr=""+"^"+ancOPCModelDr+"^"+BodssDr+"^"+OperPositionModelDr
         //
         //alert(dhcOrcOperStr);
         //手术分类：
         var OperCateDr=obj.OperCategModelDr.getValue();
         //手术类型
         var opType=obj.opType.getValue();
         //alert(opType)
		var ret =_DHCANCOrc.SaveDHCOrcOperation(Rowid,dhcOrcOperStr,OperCateDr,opType);
	
		//alert(ret);
		if(ret<0)
		{
		  Ext.Msg.alert("提示","更新失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
	  	  	 //var linenum=obj.retGridPanel.getSelectionModel().lastActive;
	  	  	 //obj.retGridPanel.getSelectionModel().deselectRow(linenum);
	  	  	obj.RowId.setValue("");
	  	  	obj.ancORCCode.setValue("");
	  	  	obj.ancORCDesc.setValue("");
	  	  	obj.ancORCCode.enable();	//20160830
	  	  	obj.ancORCDesc.enable();
	  	  	//obj.AnCoplDr.setValue("");20160830+dyl
	  	  	obj.BodssDr.setValue("");
	  	  	obj.opType.setValue("");
	  	  	obj.ancOPCModelDr.setValue("");
	  	  	obj.OperPositionModelDr.setValue("");
	  	  	obj.OperCategModelDr.setValue("");
	  	  	obj.retGridPanelStore.removeAll();
	  	  	obj.retGridPanelStore.load({
		  	   params : {
				start:0
				,limit:200
			}
		  	  	}); 
		 	});
	     }
	 };


	
	obj.deletebutton_click = function()
	{
      var Rowid=obj.RowId.getValue();
	  if(Rowid=="")
	  {
	    Ext.Msg.alert("提示","请选择一条要删除的记录！");
	    return;
	  }
	  Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCANCOrc.DeleteDHCOrcOperation(Rowid);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
	  	  	obj.RowId.setValue("");
	  	  	obj.ancORCCode.setValue("");
	  	  	obj.ancORCDesc.setValue("");
	  	  	obj.ancORCCode.enable();	//20160830
	  	  	obj.ancORCDesc.enable();
	  	  	//obj.AnCoplDr.setValue("");20160830+dyl
	  	  	obj.BodssDr.setValue("");
	  	  	obj.ancOPCModelDr.setValue("");
	  	  	obj.OperPositionModelDr.setValue("");
	  	  	obj.OperCategModelDr.setValue("");
	  	  	obj.retGridPanelStore.removeAll();
	  	  	obj.retGridPanelStore.load({
		  	   params : {
				start:0
				,limit:200
			}
		  	  	}); 	  	
	  	  	});
	  	}
	  );
	};
   obj.findbutton_click = function(){
   obj.retGridPanelStore.load({
	   params : {
				start:0
				,limit:200
			}

	   });
   obj.RowId.setValue("");
   obj.ancORCCode.setValue("");
   obj.ancORCDesc.setValue("");
   };	
}
