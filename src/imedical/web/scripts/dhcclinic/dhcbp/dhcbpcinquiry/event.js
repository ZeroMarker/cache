 function InitViewScreenEvent(obj)
{
	var _DHCBPCInquiry=ExtTool.StaticServerObject('web.DHCBPCInquiry');
	
	obj.LoadEvent = function(args)
	{
	};
	var SelectedRowID = 0;
	var preRowID=0;	 
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){
		  SelectedRowID=rc.get("TRowid");
		  if(preRowID!=SelectedRowID)
		  {
			  obj.Rowid.setValue(rc.get("TRowid"));
	          obj.BPCICode.setValue(rc.get("TBPCICode"));
	          obj.BPCIDesc.setValue(rc.get("TBPCIDesc"));
	          obj.BPCICtlocDr.setValue(rc.get("TBPCICtlocDr"));
	          obj.BPCIStatus.setValue(rc.get("TBPCIStatusCode"));
	          obj.BPCISearchLevel.setValue(rc.get("TBPCISearchLevel"));
	          obj.BPCIBPaCount.setValue(rc.get("TBPCIBpaCount"));
	          obj.BPCIResultCount.setValue(rc.get("TBPCIResultCount"));
	          
	          obj.BPCIType.setValue(rc.get("TBPCIType"));
	          obj.BPCIUpdateUserDr.setValue(rc.get("TBPCIUpdateUserDr"));
	          obj.BPCIUpdateDate.setValue(rc.get("TBPCIUpdateDate"));
	          obj.BPCIDataType.setValue(rc.get("TBPCIDataType"));
	          preRowID=SelectedRowID;
	          //ExtTool.AddComboItem(obj.BPCIStatus,rc.get("TBPCIStatus"),rc.get("TBPCIStatusCode")); 
	          //ExtTool.AddComboItem(obj.BPCICtlocDr,rc.get("TBPCICtloc"),rc.get("TBPCICtlocDr"));			  
		  }
		  else
		  {
			  obj.Rowid.setValue("");
			  obj.BPCIIRowid.setValue("")
	          obj.BPCICode.setValue("");
	          obj.BPCIDesc.setValue("");
	          obj.BPCICtlocDr.setValue("");
	          obj.BPCIStatus.setValue("");
	          obj.BPCISearchLevel.setValue("");
	          obj.BPCIBPaCount.setValue("");
	          obj.BPCIResultCount.setValue("");
	          obj.BPCIType.setValue("");
	          obj.BPCIUpdateUserDr.setValue("");
	          obj.BPCIUpdateDate.setValue("");
	          obj.BPCIDataType.setValue("");
	          
	          SelectedRowID = 0;
		      preRowID=0;
		      	
		  } 
	          obj.retGridPanelitemStoreProxy.on('beforeload', function(objProxy, param){
		         param.ClassName = 'web.DHCBPCInquiry';
		         param.QueryName = 'FindInquiryitem';
		         param.Arg1=obj.Rowid.getValue();
		         param.ArgCnt = 1;
	          });	
	          obj.retGridPanelitemStore.load({}); 
	  }
	};
	
	obj.addbutton_click = function()
	{		
		if(obj.BPCICode.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");	
			return;
		}
		if(obj.BPCIDesc.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");	
			return;
		}
		if(obj.BPCICtlocDr.getValue()=="")
		{
			ExtTool.alert("提示","科室不能为空!");	
			return;
		}
		
		var BPCICode=obj.BPCICode.getValue();
		var BPCIDesc=obj.BPCIDesc.getValue(); 
		var BPCICtlocDr=obj.BPCICtlocDr.getValue();  
		var BPCIStatus=obj.BPCIStatus.getValue(); 
		var BPCISearchLevel=obj.BPCISearchLevel.getValue(); 
		var BPCIBPaCount=obj.BPCIBPaCount.getValue(); 
		var BPCIResultCount=obj.BPCIResultCount.getValue(); 
		var BPCIType=obj.BPCIType.getValue();
		if(BPCIType!=""){
			var BPCITypeArray=BPCIType.split("");
			BPCIType=BPCITypeArray[0];
		}
		var BPCIUpdateUserDr=obj.BPCIUpdateUserDr.getValue();
		var BPCIUpdateDate=obj.BPCIUpdateDate.getValue();
		var BPCIUpdateTime=obj.BPCIUpdateTime.getValue();
		var BPCIDataType=obj.BPCIDataType.getValue();

		var ret=_DHCBPCInquiry.InsertBPCInquiry(BPCICode,BPCIDesc,BPCICtlocDr,BPCIStatus,BPCISearchLevel,BPCIBPaCount,BPCIResultCount,BPCIType,BPCIUpdateUserDr,BPCIUpdateDate,BPCIUpdateTime,BPCIDataType);
		//alert(ret)
		if(ret<='0') 
		{ 
		     Ext.Msg.alert("提示","添加失败!"+ret);
		}
		else 
		{
			Ext.Msg.alert("提示","添加成功!",function(){
	  	  	//obj.Rowid.setValue("");
	  	  	obj.BPCICode.setValue("");
	  	  	obj.BPCIDesc.setValue("");
	  	  	obj.BPCICtlocDr.setValue("");
	  	  	obj.BPCIStatus.setValue("");
	  	  	obj.BPCISearchLevel.setValue("");
	  	  	obj.BPCIBPaCount.setValue("");
	  	  	obj.BPCIResultCount.setValue("");
	  	  	obj.BPCIDataType.setValue("");
	  	  	obj.retGridPanelStore.reload({});  	  	
	  	  	});
		}
	};
	
	obj.updatebutton_click = function()
	{
		if(obj.Rowid.getValue()=="")
		{
			ExtTool.alert("提示","请选择一条数据!");	
			return;
		}	

		if(obj.BPCICode.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");	
			return;
		}
		if(obj.BPCIDesc.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");	
			return;
		}
		if(obj.BPCICtlocDr.getValue()=="")
		{
			ExtTool.alert("提示","科室不能为空!");	
			return;
		}			
		
		var Rowid=obj.Rowid.getValue();
		var BPCICode=obj.BPCICode.getValue();
		var BPCIDesc=obj.BPCIDesc.getValue(); 
		var BPCICtlocDr=obj.BPCICtlocDr.getValue();  
		var BPCIStatus=obj.BPCIStatus.getValue(); 
		var BPCISearchLevel=obj.BPCISearchLevel.getValue(); 
		var BPCIBPaCount=obj.BPCIBPaCount.getValue(); 
		var BPCIResultCount=obj.BPCIResultCount.getValue(); 
		  
		var BPCIType=obj.BPCIType.getValue();
		if(BPCIType!=""){
			var BPCITypeArray=BPCIType.split("");
			BPCIType=BPCITypeArray[0];
		}
		var BPCIUpdateUserDr=obj.BPCIUpdateUserDr.getValue();
		var BPCIUpdateDate=obj.BPCIUpdateDate.getValue();
		var BPCIUpdateTime=obj.BPCIUpdateTime.getValue();
        var BPCIDataType=obj.BPCIDataType.getValue();
        
		var ret=_DHCBPCInquiry.UpdateBPCInquiry(Rowid,BPCICode,BPCIDesc,BPCICtlocDr,BPCIStatus,BPCISearchLevel,BPCIBPaCount,BPCIResultCount,BPCIType,BPCIUpdateUserDr,BPCIUpdateDate,BPCIUpdateTime,BPCIDataType);
	
		if(ret!='0')
		{
		  Ext.Msg.alert("提示","更新失败！"+ret);	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.BPCICode.setValue("");
	  	  	obj.BPCIDesc.setValue("");
	  	  	obj.BPCICtlocDr.setValue("");
	  	  	obj.BPCIStatus.setValue("");
	  	  	obj.BPCISearchLevel.setValue("");
	  	  	obj.BPCIBPaCount.setValue("");
	  	  	obj.BPCIResultCount.setValue("");
	  	  	obj.BPCIDataType.setValue("");
	  	  	obj.retGridPanelStore.load({}); 
		  	});
	     }
	 };
	 
	obj.deletebutton_click = function()
	{
	  var RID=obj.Rowid.getValue();
	  if(RID=="")
	  {
	    Ext.Msg.alert("提示","请选择一条要删除的记录！");
	    return;
	  }
	  var ret=_DHCBPCInquiry.Justislink(RID);
	  if (ret>0)
	  {
		  Ext.Msg.alert("提示","有关联数据,不能删除!");
		  return;
	  }
	  Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCBPCInquiry.DeleteBPCInquiry(RID);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
	  	  	//obj.Rowid.setValue("");
	  	  	obj.BPCICode.setValue("");
	  	  	obj.BPCIDesc.setValue("");
	  	  	obj.BPCICtlocDr.setValue("");
	  	  	obj.BPCIStatus.setValue("");
	  	  	obj.BPCISearchLevel.setValue("");
	  	  	obj.BPCIBPaCount.setValue("");
	  	  	obj.BPCIResultCount.setValue("");
	  	  	obj.retGridPanelStore.load({}); 
		  	});
	  	}
	  );
	};
	
    obj.retGridPanelitem_rowclick=function()
    {
	    var rc = obj.retGridPanelitem.getSelectionModel().getSelected();
	    if (rc){
		    SelectedRowID=rc.get("TRowid");
		    if(preRowID!=SelectedRowID)
		    {
			    obj.BPCIIRowid.setValue(rc.get("TRowid"));
			    obj.BPCIICode.setValue(rc.get("TBPCIICode"));
			    obj.BPCIIDesc.setValue(rc.get("TBPCIIDesc"));
			    obj.BPCIIType.setValue(rc.get("TBPCIIType"));
			    obj.BPCIIIsSearch.setValue(rc.get("TBPCIIIsSearch"));
			    obj.BPCIIIsDisplay.setValue(rc.get("TBPCIIIsDisplay"));
			    obj.BPCIIDataField.setValue(rc.get("TBPCIIDataField"));
			    obj.BPCIIIsSingle.setValue(rc.get("TBPCIIIsSingle"));
			    obj.BPCIIMinQty.setValue(rc.get("TBPCIIMinQty"));
			    obj.BPCIIMaxQty.setValue(rc.get("TBPCIIMaxQty"));
			    obj.BPCIINote.setValue(rc.get("TBPCIINote"));
			    obj.BPCIIMultiple.setValue(rc.get("TBPCIIMultiple"));
			    obj.BPCIIStartDateTime.setValue(rc.get("TBPCIIStartDateTime"));
			    obj.BPCIIDurationHour.setValue(rc.get("TBPCIIDurationHour"));
			    obj.BPCIIOeoriNote.setValue(rc.get("TBPCIIOeoriNote"));
			    obj.BPCIIFromTime.setValue(rc.get("TBPCIIFromTime"));
			    obj.BPCIIToTime.setValue(rc.get("TBPCIIToTime"));
			    obj.BPCIIExactTime.setValue(rc.get("TBPCIIExactTime"));
			    obj.BPCIIRefBPriId.setValue(rc.get("TBPCIIRefIcuriDesc"));
			    obj.BPCIIRefValue.setValue(rc.get("TBPCIIRefValue"));
			    obj.BPCIISeqNo.setValue(rc.get("TBPCIISeqNo"));
			    obj.BPCIILevel.setValue(rc.get("TBPCIILevel"));
			    
			    preRowID=SelectedRowID;
		    }
		    else
		    {
                ClearInquiryitem();			    
			    SelectedRowID = 0;
		        preRowID=0;
		    }
	    }   
	
    }
    obj.additembtn_click=function()
    {
	    if(obj.Rowid.getValue()=="")
	    {
		   	ExtTool.alert("提示","父表ID不能为空!");	
			return; 
	    }
	    if(obj.BPCIICode.getValue()=="")
	    {
		   	ExtTool.alert("提示","代码不能为空!");	
			return; 
	    }
	    if(obj.BPCIIDesc.getValue()=="")
	    {
		   	ExtTool.alert("提示","描述不能为空!");	
			return; 
	    }
	    if(obj.BPCIISeqNo.getValue()=="")
	    {
		   	ExtTool.alert("提示","排序号不能为空!");	
			return; 
	    }	
	     
	    var Rowid=obj.Rowid.getValue();	 
	    var BPCIICode=obj.BPCIICode.getValue();
	    var BPCIIDesc=obj.BPCIIDesc.getValue();
	    var BPCIIType=obj.BPCIIType.getValue();
	    var BPCIIIsSearch=obj.BPCIIIsSearch.getValue();
	    var BPCIIIsDisplay=obj.BPCIIIsDisplay.getValue();
	    var BPCIIDataField=obj.BPCIIDataField.getValue();
	    var BPCIIIsSingle=obj.BPCIIIsSingle.getValue();
	    var BPCIIMinQty=obj.BPCIIMinQty.getValue();
	    var BPCIIMaxQty=obj.BPCIIMaxQty.getValue();
	    var BPCIINote=obj.BPCIINote.getValue();
	    var BPCIIMultiple=obj.BPCIIMultiple.getValue();
	    var BPCIIStartDateTime=obj.BPCIIStartDateTime.getValue();
	    var BPCIIDurationHour=obj.BPCIIDurationHour.getValue();
	    var BPCIIOeoriNote=obj.BPCIIOeoriNote.getValue();
	    var BPCIIFromTime=obj.BPCIIFromTime.getValue();
	    var BPCIIToTime=obj.BPCIIToTime.getValue();
	    var BPCIIExactTime=obj.BPCIIExactTime.getValue();
	    var BPCIIRefBPriId=obj.BPCIIRefBPriId.getValue();
	    var BPCIIRefValue=obj.BPCIIRefValue.getValue();
	    var BPCIISeqNo=obj.BPCIISeqNo.getValue();
	    var BPCIILevel=obj.BPCIILevel.getValue();
	    
	    var ret=_DHCBPCInquiry.InsertInquiryitem(Rowid,BPCIICode,BPCIIDesc,BPCIIType,BPCIIIsSearch,BPCIIIsDisplay,BPCIIDataField,BPCIIIsSingle,BPCIIMinQty,BPCIIMaxQty,BPCIINote,BPCIIMultiple,BPCIIStartDateTime,BPCIIDurationHour,BPCIIOeoriNote,BPCIIFromTime,BPCIIToTime,BPCIIExactTime,BPCIIRefBPriId,BPCIIRefValue,BPCIISeqNo,BPCIILevel)
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","添加失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","添加成功!",function(){
            ClearInquiryitem();
	  	  	obj.retGridPanelitemStore.load({});  	  	
	  	  	});
		}
    }
 
     obj.updateitembtn_click=function()
    {
	    if(obj.Rowid.getValue()=="")
	    {
		   	ExtTool.alert("提示","父表ID不能为空!");	
			return; 
	    }
	    //alert(obj.BPCIIRowid.getValue())
	    if(obj.BPCIIRowid.getValue()=="")
	    {
		   	ExtTool.alert("提示","ID不能为空!");	
			return; 
	    }
	    if(obj.BPCIICode.getValue()=="")
	    {
		   	ExtTool.alert("提示","代码不能为空!");	
			return; 
	    }
	    if(obj.BPCIIDesc.getValue()=="")
	    {
		   	ExtTool.alert("提示","描述不能为空!");	
			return; 
	    }
	    if(obj.BPCIISeqNo.getValue()=="")
	    {
		   	ExtTool.alert("提示","排序号不能为空!");	
			return; 
	    }	
	     
	    var Rowid=obj.Rowid.getValue();	 
	    var BPCIIRowid=obj.BPCIIRowid.getValue();
	    var BPCIICode=obj.BPCIICode.getValue();
	    var BPCIIDesc=obj.BPCIIDesc.getValue();
	    var BPCIIType=obj.BPCIIType.getValue();
	    var BPCIIIsSearch=obj.BPCIIIsSearch.getValue();
	    var BPCIIIsDisplay=obj.BPCIIIsDisplay.getValue();
	    var BPCIIDataField=obj.BPCIIDataField.getValue();
	    var BPCIIIsSingle=obj.BPCIIIsSingle.getValue();
	    var BPCIIMinQty=obj.BPCIIMinQty.getValue();
	    var BPCIIMaxQty=obj.BPCIIMaxQty.getValue();
	    var BPCIINote=obj.BPCIINote.getValue();
	    var BPCIIMultiple=obj.BPCIIMultiple.getValue();
	    var BPCIIStartDateTime=obj.BPCIIStartDateTime.getValue();
	    var BPCIIDurationHour=obj.BPCIIDurationHour.getValue();
	    var BPCIIOeoriNote=obj.BPCIIOeoriNote.getValue();
	    var BPCIIFromTime=obj.BPCIIFromTime.getValue();
	    var BPCIIToTime=obj.BPCIIToTime.getValue();
	    var BPCIIExactTime=obj.BPCIIExactTime.getValue();
	    var BPCIIRefBPriId=obj.BPCIIRefBPriId.getValue();
	    var BPCIIRefValue=obj.BPCIIRefValue.getValue();
	    var BPCIISeqNo=obj.BPCIISeqNo.getValue();
	    var BPCIILevel=obj.BPCIILevel.getValue();
	    
	    var ret=_DHCBPCInquiry.UpdateInquiryitem(Rowid,BPCIIRowid,BPCIICode,BPCIIDesc,BPCIIType,BPCIIIsSearch,BPCIIIsDisplay,BPCIIDataField,BPCIIIsSingle,BPCIIMinQty,BPCIIMaxQty,BPCIINote,BPCIIMultiple,BPCIIStartDateTime,BPCIIDurationHour,BPCIIOeoriNote,BPCIIFromTime,BPCIIToTime,BPCIIExactTime,BPCIIRefBPriId,BPCIIRefValue,BPCIISeqNo,BPCIILevel)
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","更新失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","更新成功!",function(){
            ClearInquiryitem();
	  	  	obj.retGridPanelitemStore.load({});  	  	
	  	  	});
		}
    }
	obj.deleteitembtn_click = function()
	{
	  var RID=obj.BPCIIRowid.getValue();
	  
	  if(RID=="")
	  {
	    Ext.Msg.alert("提示","请选择一条要删除的记录！");
	    return;
	  }
	  Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCBPCInquiry.DeleteInquiryitem(RID);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
            ClearInquiryitem();
	  	  	obj.retGridPanelitemStore.load({}); 
		  	});

	  	}
	  );
	};       
    function ClearInquiryitem()
    {
	    obj.BPCIICode.setValue("");
	    obj.BPCIIDesc.setValue("");
	    obj.BPCIIType.setValue("");
	    obj.BPCIIIsSearch.setValue("");
	    obj.BPCIIIsDisplay.setValue("");
	    obj.BPCIIDataField.setValue("");
	    obj.BPCIIIsSingle.setValue("");
	    obj.BPCIIMinQty.setValue("");
	    obj.BPCIIMaxQty.setValue("");
	    obj.BPCIINote.setValue("");
	    obj.BPCIIMultiple.setValue("");
	    obj.BPCIIStartDateTime.setValue("");
	    obj.BPCIIDurationHour.setValue("");
	    obj.BPCIIOeoriNote.setValue("");
	    obj.BPCIIFromTime.setValue("");
	    obj.BPCIIToTime.setValue("");
	    obj.BPCIIExactTime.setValue("");
	    obj.BPCIIRefBPriId.setValue("");
	    obj.BPCIIRefValue.setValue("");
	    obj.BPCIISeqNo.setValue("");
	    obj.BPCIILevel.setValue("");		    
    }
}
