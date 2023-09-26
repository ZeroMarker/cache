 function InitViewScreenEvent(obj)
{
	var _DHCICUCInquiryConfig=ExtTool.StaticServerObject('web.DHCICUCInquiryConfig');
	
	obj.LoadEvent = function(args)
	{
		obj.ICUCIUpdateDate.disable();
		obj.ICUCIUpdateTime.disable();
		obj.ICUCIUpdateUserDr.disable();	//user取当前登录用户
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
	          obj.ICUCICode.setValue(rc.get("TICUCICode"));
	          obj.ICUCIDesc.setValue(rc.get("TICUCIDesc"));
	          obj.ICUCICtlocDr.setValue(rc.get("TICUCICtlocDr"));
	          obj.ICUCICtlocDr.setRawValue(rc.get("TICUCICtloc"));
	          
	          obj.ICUCIStatus.setValue(rc.get("TICUCIStatusCode"));
	          obj.ICUCISearchLevel.setValue(rc.get("TICUCISearchLevel"));
	          obj.ICUCIIcuaCount.setValue(rc.get("TICUCIIcuaCount"));
	          obj.ICUCIResultCount.setValue(rc.get("TICUCIResultCount"));
	          
	          obj.ICUCIType.setValue(rc.get("TICUCIType"));
	          obj.ICUCIUpdateUserDr.setValue(rc.get("TICUCIUpdateUserDr"));
	          obj.ICUCIUpdateDate.setValue(rc.get("TICUCIUpdateDate"));
	          obj.ICUCIUpdateTime.setValue(rc.get("TICUCIUpdateTime"));	//20160913+dyl
	          obj.ICUCIDataType.setValue(rc.get("TICUCIDataType"));
	          //
	          ClearInquiryitem();
	          preRowID=SelectedRowID;
	          //ExtTool.AddComboItem(obj.ICUCIStatus,rc.get("TICUCIStatus"),rc.get("TICUCIStatusCode")); 
	          //ExtTool.AddComboItem(obj.ICUCICtlocDr,rc.get("TICUCICtloc"),rc.get("TICUCICtlocDr"));			  
		  }
		  else
		  {
			  obj.Rowid.setValue("");
			  obj.ICUCIIRowid.setValue("")
	          obj.ICUCICode.setValue("");
	          obj.ICUCIDesc.setValue("");
	          obj.ICUCICtlocDr.setValue("");
	          obj.ICUCIStatus.setValue("");
	          obj.ICUCISearchLevel.setValue("");
	          obj.ICUCIIcuaCount.setValue("");
	          obj.ICUCIResultCount.setValue("");
	          
	          obj.ICUCIType.setValue("");
	          obj.ICUCIUpdateUserDr.setValue("");
	          obj.ICUCIUpdateDate.setValue("");
	          obj.ICUCIUpdateTime.setValue("");	//20160913+dyl
	          obj.ICUCIDataType.setValue("");
	          
	          SelectedRowID = 0;
		      preRowID=0;
		      	
		  } 
	          obj.retGridPanelitemStoreProxy.on('beforeload', function(objProxy, param){
		         param.ClassName = 'web.DHCICUCInquiryConfig';
		         param.QueryName = 'FindInquiryitem';
		         param.Arg1=obj.Rowid.getValue();
		         param.ArgCnt = 1;
	          });
	          obj.retGridPanelitemStore.removeAll();
	          obj.retGridPanelitemStore.load({}); 
	  }
	};
	
	obj.findbutton_click = function()
	{
		 SelectedRowID = 0;
		 preRowID=0;
		obj.retGridPanelStore.removeAll();
		obj.retGridPanelStore.load({});
		obj.Rowid.setValue("");
		//20160830+dyl
		obj.ICUCICode.setValue("");
		obj.ICUCIDesc.setValue("");
		obj.ICUCICtlocDr.setValue("");
		obj.ICUCIStatus.setValue("");
	    obj.ICUCISearchLevel.setValue("");
	    obj.ICUCIIcuaCount.setValue("");
	    obj.ICUCIResultCount.setValue("");   
	    obj.ICUCIType.setValue("");
	    obj.ICUCIUpdateUserDr.setValue("");
	    obj.ICUCIUpdateDate.setValue("");
	    obj.ICUCIUpdateTime.setValue("");
	    obj.ICUCIDataType.setValue("");
		obj.ICUCIIRowid.setValue("");
		ClearInquiryitem();
		obj.retGridPanelitemStore.removeAll();
		obj.retGridPanelitemStore.load({});
	}
	obj.addbutton_click = function()
	{
		var ICUCICtlocDrFlag=false;
		if(obj.ICUCICode.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");	
			return;
		}
		if(obj.ICUCIDesc.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");	
			return;
		}
		if(obj.ICUCICtlocDr.getValue()=="")
		{
			ExtTool.alert("提示","科室不能为空!");	
			return;
		}
		
		var ICUCICode=obj.ICUCICode.getValue();
		var ICUCIDesc=obj.ICUCIDesc.getValue(); 
		var ICUCICtlocDr=obj.ICUCICtlocDr.getValue();  
		var ICUCIStatus=obj.ICUCIStatus.getValue(); 
		var ICUCISearchLevel=obj.ICUCISearchLevel.getValue(); 
		var ICUCIIcuaCount=obj.ICUCIIcuaCount.getValue(); 
		var ICUCIResultCount=obj.ICUCIResultCount.getValue(); 
		var ICUCIType=obj.ICUCIType.getRawValue();	//20160830+dyl     
		var ICUCIUpdateUserDr=session['LOGON.USERID'];
		//var ICUCIUpdateDate=obj.ICUCIUpdateDate.getValue();
		//var ICUCIUpdateTime=obj.ICUCIUpdateTime.getValue();
		var ICUCIDataType=obj.ICUCIDataType.getValue();
		//---20190109 YuanLin 下拉框只能选择不允许手写
		var ICUCICtlocDrNum=obj.ICUCICtlocDrstore.data.items.length;
		var ICUCICtlocDrItems=obj.ICUCICtlocDrstore.data.items;
		if(ICUCICtlocDr!="")
		{
			if(ICUCICtlocDrNum!=0)
			{
				for (var i = 0; i < ICUCICtlocDrNum; i++)
				{
					if (ICUCICtlocDr == ICUCICtlocDrItems[i].data.oprLocId)
					{
						ICUCICtlocDrFlag = true;
						break;
					}
				}
				if(!ICUCICtlocDrFlag)
				{
					ExtTool.alert("提示","科室请从下拉框选择!");
					return ;
				}
			}
			if(ICUCICtlocDrNum==0)
			{
				ExtTool.alert("提示","科室请从下拉框选择!");
				return ;
			}
		}
		else
		{
			var ICUCICtlocDrRaw=obj.ICUCICtlocDr.getRawValue();
			if(ICUCICtlocDrRaw!="")
			{
				ExtTool.alert("提示","科室请从下拉框选择!");
				return ;
			}
		}
		var ret=_DHCICUCInquiryConfig.InsertICUCInquiry(ICUCICode,ICUCIDesc,ICUCICtlocDr,ICUCIStatus,ICUCISearchLevel,ICUCIIcuaCount,ICUCIResultCount,"",ICUCIType,ICUCIUpdateUserDr,"","",ICUCIDataType);
		
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","添加失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","添加成功!",function(){
	  	  	//obj.Rowid.setValue("");
	  	  	obj.ICUCICode.setValue("");
	  	  	obj.ICUCIDesc.setValue("");
	  	  	obj.ICUCICtlocDr.setValue("");
	  	  	obj.ICUCIType.setValue("");	//20160902+dyl+添加后清空选择框
	  	  	obj.ICUCIStatus.setValue("");
	  	  	obj.ICUCISearchLevel.setValue("");
	  	  	obj.ICUCIIcuaCount.setValue("");
	  	  	obj.ICUCIResultCount.setValue("");
	  	  	//20160902+dyl
	  	  		obj.ICUCIType.setValue("");
	          obj.ICUCIUpdateUserDr.setValue("");
	          obj.ICUCIUpdateDate.setValue("");
	          obj.ICUCIUpdateTime.setValue("");
	          obj.ICUCIDataType.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};
	
	obj.updatebutton_click = function()
	{
		var ICUCICtlocDrFlag=false;
		if(obj.Rowid.getValue()=="")
		{
			ExtTool.alert("提示","请选择一条数据!");	
			return;
		}	

		if(obj.ICUCICode.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");	
			return;
		}
		if(obj.ICUCIDesc.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");	
			return;
		}
		if(obj.ICUCICtlocDr.getValue()=="")
		{
			ExtTool.alert("提示","科室不能为空!");	
			return;
		}			
		
		var Rowid=obj.Rowid.getValue();
		var ICUCICode=obj.ICUCICode.getValue();
		var ICUCIDesc=obj.ICUCIDesc.getValue(); 
		var ICUCICtlocDr=obj.ICUCICtlocDr.getValue();  
		var ICUCIStatus=obj.ICUCIStatus.getValue(); 
		var ICUCISearchLevel=obj.ICUCISearchLevel.getValue(); 
		var ICUCIIcuaCount=obj.ICUCIIcuaCount.getValue(); 
		var ICUCIResultCount=obj.ICUCIResultCount.getValue(); 
		  
		//var ICUCIType=obj.ICUCIType.getValue();
		var ICUCIType=obj.ICUCIType.getRawValue();	//20160830+dyl
		//var ICUCIUpdateUserDr=obj.ICUCIUpdateUserDr.getValue();
		var ICUCIUpdateUserDr=session['LOGON.USERID'];
		//var ICUCIUpdateDate=obj.ICUCIUpdateDate.getValue();
		//var ICUCIUpdateTime=obj.ICUCIUpdateTime.getValue();
        var ICUCIDataType=obj.ICUCIDataType.getValue();
        //---20190109 YuanLin 下拉框只能选择不允许手写
		var ICUCICtlocDrNum=obj.ICUCICtlocDrstore.data.items.length;
		var ICUCICtlocDrItems=obj.ICUCICtlocDrstore.data.items;
		if(ICUCICtlocDr!="")
		{
			if(ICUCICtlocDrNum!=0)
			{
				for (var i = 0; i < ICUCICtlocDrNum; i++)
				{
					if (ICUCICtlocDr == ICUCICtlocDrItems[i].data.oprLocId)
					{
						ICUCICtlocDrFlag = true;
						break;
					}
				}
				if(!ICUCICtlocDrFlag)
				{
				//	ExtTool.alert("提示","科室请从下拉框选择!");
					//return ;
				}
			}
			if(ICUCICtlocDrNum==0)
			{
				//ExtTool.alert("提示","科室请从下拉框选择!");
				//return ;
			}
		}
		else
		{
			var ICUCICtlocDrRaw=obj.ICUCICtlocDr.getRawValue();
			if(ICUCICtlocDrRaw!="")
			{
				//ExtTool.alert("提示","科室请从下拉框选择!");
				//return ;
			}
		}
		var ret=_DHCICUCInquiryConfig.UpdateICUCInquiry(Rowid,ICUCICode,ICUCIDesc,ICUCICtlocDr,ICUCIStatus,ICUCISearchLevel,ICUCIIcuaCount,ICUCIResultCount,ICUCIType,ICUCIUpdateUserDr,"","",ICUCIDataType);
	
		if(ret!='0')
		{
		  Ext.Msg.alert("提示","更新失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
	  	  	//obj.Rowid.setValue("");
	  	  	obj.ICUCICode.setValue("");
	  	  	obj.ICUCIDesc.setValue("");
	  	  	obj.ICUCICtlocDr.setValue("");
	  	  	obj.ICUCIStatus.setValue("");
	  	  	obj.ICUCIType.setValue("");	//20160902+dyl+添加后清空选择框
	  	  	obj.ICUCISearchLevel.setValue("");
	  	  	obj.ICUCIIcuaCount.setValue("");
	  	  	obj.ICUCIResultCount.setValue("");
	  	  	////20160902+dyl
	  	  	obj.ICUCIType.setValue("");
	          obj.ICUCIUpdateUserDr.setValue("");
	          obj.ICUCIUpdateDate.setValue("");
	          obj.ICUCIUpdateTime.setValue("");
	          obj.ICUCIDataType.setValue("");
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
	  var ret=_DHCICUCInquiryConfig.Justislink(RID);
	  if (ret>0)
	  {
		  Ext.Msg.alert("提示","有关联数据,不能删除!");
		  return;
	  }
	  Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCICUCInquiryConfig.DeleteICUCInquiry(RID);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.ICUCICode.setValue("");
	  	  	obj.ICUCIDesc.setValue("");
	  	  	obj.ICUCICtlocDr.setValue("");
	  	  	obj.ICUCIType.setValue("");	//20160902+dyl+添加后清空选择框
	  	  	obj.ICUCIStatus.setValue("");
	  	  	obj.ICUCISearchLevel.setValue("");
	  	  	obj.ICUCIIcuaCount.setValue("");
	  	  	obj.ICUCIResultCount.setValue("");
	  	  	////20160902+dyl
	  	  	 	obj.ICUCIType.setValue("");
	          obj.ICUCIUpdateUserDr.setValue("");
	          obj.ICUCIUpdateDate.setValue("");
	          obj.ICUCIDataType.setValue("");
	          obj.ICUCIUpdateTime.setValue("");
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
			    obj.ICUCIIRowid.setValue(rc.get("TRowid"));
			    obj.ICUCIICode.setValue(rc.get("TICUCIICode"));
			    obj.ICUCIICode.setRawValue(rc.get("TICUCIICodeDesc"));//20160913+dyl
			    			    
			    obj.ICUCIIDesc.setValue(rc.get("TICUCIIDesc"));
			    obj.ICUCIIType.setValue(rc.get("TICUCIIType"));
			     obj.ICUCIIType.setRawValue(rc.get("TICUCIITypeD"));
			    obj.ICUCIIIsSearch.setValue(rc.get("TICUCIIIsSearch"));
			    
			    obj.ICUCIIIsSearch.setValue(rc.get("TICUCIIIsSearch"));
			    //20160913+dyl
			    if(rc.get("TICUCIIIsSearch")==1)
			    {
					obj.ICUCIIIsSearch.setRawValue("是");
			    }
			    else
			    {
				    obj.ICUCIIIsSearch.setRawValue("否");
			    }

			    
			    obj.ICUCIIIsDisplay.setValue(rc.get("TICUCIIIsDisplay"));
			    obj.ICUCIIDataField.setValue(rc.get("TICUCIIDataField"));
			    obj.ICUCIIIsSingle.setValue(rc.get("TICUCIIIsSingle"));
			    obj.ICUCIIMinQty.setValue(rc.get("TICUCIIMinQty"));
			    obj.ICUCIIMaxQty.setValue(rc.get("TICUCIIMaxQty"));
			    obj.ICUCIINote.setValue(rc.get("TICUCIINote"));
			    obj.ICUCIIMultiple.setValue(rc.get("TICUCIIMultiple"));
			    obj.ICUCIIStartDateTime.setValue(rc.get("TICUCIIStartDateTime"));
			    obj.ICUCIIDurationHour.setValue(rc.get("TICUCIIDurationHour"));
			    obj.ICUCIIOeoriNote.setValue(rc.get("TICUCIIOeoriNote"));
			    obj.ICUCIIFromTime.setValue(rc.get("TICUCIIFromTime"));
			    obj.ICUCIIToTime.setValue(rc.get("TICUCIIToTime"));
			    obj.ICUCIIExactTime.setValue(rc.get("TICUCIIExactTime"));
			    //obj.ICUCIIRefIcuriId.setValue(rc.get("TICUCIIRefIcuriDesc"));
			    obj.ICUCIIRefIcuriId.setValue(rc.get("TICUCIIRefIcuriId"));
			    obj.ICUCIIRefIcuriId.setRawValue(rc.get("TICUCIIRefIcuriDesc"));
			    obj.ICUCIIRefValue.setValue(rc.get("TICUCIIRefValue"));
			    obj.ICUCIISeqNo.setValue(rc.get("TICUCIISeqNo"));
			    obj.ICUCIILevel.setValue(rc.get("TICUCIILevel"));
			    
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
	    var ICUCIIRefIcuriIdFlag=false;
	    if(obj.Rowid.getValue()=="")
	    {
		   	ExtTool.alert("提示","父表ID不能为空!");	
			return; 
	    }
	    if(obj.ICUCIICode.getValue()=="")
	    {
		   	ExtTool.alert("提示","代码不能为空!");	
			return; 
	    }
	    if(obj.ICUCIIDesc.getValue()=="")
	    {
		   	ExtTool.alert("提示","描述不能为空!");	
			return; 
	    }
	    if(obj.ICUCIISeqNo.getValue()=="")
	    {
		   	ExtTool.alert("提示","排序号不能为空!");	
			return; 
	    }	
	     
	    var Rowid=obj.Rowid.getValue();	 
	    var ICUCIICode=obj.ICUCIICode.getValue();
	    var ICUCIIDesc=obj.ICUCIIDesc.getValue();
	    var ICUCIIType=obj.ICUCIIType.getValue();
	    var ICUCIIIsSearch=obj.ICUCIIIsSearch.getValue();
	    var ICUCIIIsDisplay=obj.ICUCIIIsDisplay.getValue();
	    var ICUCIIDataField=obj.ICUCIIDataField.getValue();
	    var ICUCIIIsSingle=obj.ICUCIIIsSingle.getValue();
	    var ICUCIIMinQty=obj.ICUCIIMinQty.getValue();
	    var ICUCIIMaxQty=obj.ICUCIIMaxQty.getValue();
	    if((ICUCIIMaxQty!="")&&(ICUCIIMinQty!=""))
	    {
		     if(ICUCIIMaxQty>ICUCIIMinQty)
		    {
		    }
		    else
		    {
			    ExtTool.alert("提示","最大值小于或等于最小值");	
			    return;
		    }
	    }
	    var ICUCIINote=obj.ICUCIINote.getValue();
	    var ICUCIIMultiple=obj.ICUCIIMultiple.getValue();
	    var ICUCIIStartDateTime=obj.ICUCIIStartDateTime.getValue();
	    var ICUCIIDurationHour=obj.ICUCIIDurationHour.getValue();
	    if (isNaN(ICUCIIDurationHour))
	    {
		    ExtTool.alert("提示","持续时间只能填写数字!");	
		    return ;
		} 
	    var ICUCIIOeoriNote=obj.ICUCIIOeoriNote.getValue();
	    var ICUCIIFromTime=obj.ICUCIIFromTime.getValue();
	    var ICUCIIToTime=obj.ICUCIIToTime.getValue();
	    var ICUCIIExactTime=obj.ICUCIIExactTime.getValue();
	    var ICUCIIRefIcuriId=obj.ICUCIIRefIcuriId.getValue();
	    var ICUCIIRefValue=obj.ICUCIIRefValue.getValue();
	    var ICUCIISeqNo=obj.ICUCIISeqNo.getValue();
	    var ICUCIILevel=obj.ICUCIILevel.getValue(); 
	    //---20190109 YuanLin 下拉框只能选择不允许手写
		var ICUCIIRefIcuriIdNum=obj.ICUCIIRefIcuriIdstore.data.items.length;
		var ICUCIIRefIcuriIdItems=obj.ICUCIIRefIcuriIdstore.data.items;
		if(ICUCIIRefIcuriId!="")
		{
			if(ICUCIIRefIcuriIdNum!=0)
			{
				for (var i = 0; i < ICUCIIRefIcuriIdNum; i++)
				{
					if (ICUCIIRefIcuriId == ICUCIIRefIcuriIdItems[i].data.tRowId)
					{
						ICUCIIRefIcuriIdFlag = true;
						break;
					}
				}
				if(!ICUCIIRefIcuriIdFlag)
				{
					ExtTool.alert("提示","基准常用医嘱请从下拉框选择!");
					return ;
				}
			}
			if(ICUCIIRefIcuriIdNum==0)
			{
				ExtTool.alert("提示","基准常用医嘱请从下拉框选择!");
				return ;
			}
		}
		else
		{
			var ICUCIIRefIcuriIdRaw=obj.ICUCIIRefIcuriId.getRawValue();
			if(ICUCIIRefIcuriIdRaw!="")
			{
				ExtTool.alert("提示","基准常用医嘱请从下拉框选择!");
				return ;
			}
		} 
	    var ret=_DHCICUCInquiryConfig.InsertInquiryitem(Rowid,ICUCIICode,ICUCIIDesc,ICUCIIType,ICUCIIIsSearch,ICUCIIIsDisplay,ICUCIIDataField,ICUCIIIsSingle,ICUCIIMinQty,ICUCIIMaxQty,ICUCIINote,ICUCIIMultiple,ICUCIIStartDateTime,ICUCIIDurationHour,ICUCIIOeoriNote,ICUCIIFromTime,ICUCIIToTime,ICUCIIExactTime,ICUCIIRefIcuriId,ICUCIIRefValue,ICUCIISeqNo,ICUCIILevel)
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","添加失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","添加成功!",function(){
            ClearInquiryitem();
             obj.retGridPanelitemStore.removeAll();
	  	  	obj.retGridPanelitemStore.load({});  	  	
	  	  	});
		}
    }
 
     obj.updateitembtn_click=function()
    {
	    var ICUCIIRefIcuriIdFlag=false;
	    if(obj.Rowid.getValue()=="")
	    {
		   	ExtTool.alert("提示","父表ID不能为空!");	
			return; 
	    }
	    if(obj.ICUCIIRowid.getValue()=="")
	    {
		   	ExtTool.alert("提示","ID不能为空!");	
			return; 
	    }
	    if(obj.ICUCIICode.getValue()=="")
	    {
		   	ExtTool.alert("提示","代码不能为空!");	
			return; 
	    }
	    if(obj.ICUCIIDesc.getValue()=="")
	    {
		   	ExtTool.alert("提示","描述不能为空!");	
			return; 
	    }
	    if(obj.ICUCIISeqNo.getValue()=="")
	    {
		   	ExtTool.alert("提示","排序号不能为空!");	
			return; 
	    }	
	     
	    var Rowid=obj.Rowid.getValue();	 
	    var ICUCIIRowid=obj.ICUCIIRowid.getValue();
	    var ICUCIICode=obj.ICUCIICode.getValue();
	    var ICUCIIDesc=obj.ICUCIIDesc.getValue();
	    var ICUCIIType=obj.ICUCIIType.getValue();
	    var ICUCIIIsSearch=obj.ICUCIIIsSearch.getValue();
	    var ICUCIIIsDisplay=obj.ICUCIIIsDisplay.getValue();
	    var ICUCIIDataField=obj.ICUCIIDataField.getValue();
	    var ICUCIIIsSingle=obj.ICUCIIIsSingle.getValue();
	    var ICUCIIMinQty=obj.ICUCIIMinQty.getValue();
	    var ICUCIIMaxQty=obj.ICUCIIMaxQty.getValue();
	    if((ICUCIIMaxQty!="")&&(ICUCIIMinQty!=""))
	    {
		     if(ICUCIIMaxQty>ICUCIIMinQty)
		    {
		    }
		    else
		    {
			    ExtTool.alert("提示","最大值小于或等于最小值");	
			    return;
		    }
	    }
	    var ICUCIINote=obj.ICUCIINote.getValue();
	    var ICUCIIMultiple=obj.ICUCIIMultiple.getValue();
	    var ICUCIIStartDateTime=obj.ICUCIIStartDateTime.getValue();
	    var ICUCIIDurationHour=obj.ICUCIIDurationHour.getValue();
	    if (isNaN(ICUCIIDurationHour))
	    {
		    ExtTool.alert("提示","持续时间只能填写数字!");	
		    return ;
		}
	    var ICUCIIOeoriNote=obj.ICUCIIOeoriNote.getValue();
	    var ICUCIIFromTime=obj.ICUCIIFromTime.getValue();
	    var ICUCIIToTime=obj.ICUCIIToTime.getValue();
	    var ICUCIIExactTime=obj.ICUCIIExactTime.getValue();
	    var ICUCIIRefIcuriId=obj.ICUCIIRefIcuriId.getValue();
	    var ICUCIIRefValue=obj.ICUCIIRefValue.getValue();
	    var ICUCIISeqNo=obj.ICUCIISeqNo.getValue();
	    var ICUCIILevel=obj.ICUCIILevel.getValue();
	    //---20190109 YuanLin 下拉框只能选择不允许手写
		var ICUCIIRefIcuriIdNum=obj.ICUCIIRefIcuriIdstore.data.items.length;
		var ICUCIIRefIcuriIdItems=obj.ICUCIIRefIcuriIdstore.data.items;
		if(ICUCIIRefIcuriId!="")
		{
			if(ICUCIIRefIcuriIdNum!=0)
			{
				for (var i = 0; i < ICUCIIRefIcuriIdNum; i++)
				{
					if (ICUCIIRefIcuriId == ICUCIIRefIcuriIdItems[i].data.tRowId)
					{
						ICUCIIRefIcuriIdFlag = true;
						break;
					}
				}
				if(!ICUCIIRefIcuriIdFlag)
				{
					ExtTool.alert("提示","基准常用医嘱请从下拉框选择!");
					return ;
				}
			}
			if(ICUCIIRefIcuriIdNum==0)
			{
				ExtTool.alert("提示","基准常用医嘱请从下拉框选择!");
				return ;
			}
		}
		else
		{
			var ICUCIIRefIcuriIdRaw=obj.ICUCIIRefIcuriId.getRawValue();
			if(ICUCIIRefIcuriIdRaw!="")
			{
				ExtTool.alert("提示","基准常用医嘱请从下拉框选择!");
				return ;
			}
		} 
	    var ret=_DHCICUCInquiryConfig.UpdateInquiryitem(Rowid,ICUCIIRowid,ICUCIICode,ICUCIIDesc,ICUCIIType,ICUCIIIsSearch,ICUCIIIsDisplay,ICUCIIDataField,ICUCIIIsSingle,ICUCIIMinQty,ICUCIIMaxQty,ICUCIINote,ICUCIIMultiple,ICUCIIStartDateTime,ICUCIIDurationHour,ICUCIIOeoriNote,ICUCIIFromTime,ICUCIIToTime,ICUCIIExactTime,ICUCIIRefIcuriId,ICUCIIRefValue,ICUCIISeqNo,ICUCIILevel)
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","更新失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","更新成功!",function(){
            ClearInquiryitem();
             obj.retGridPanelitemStore.removeAll();
	  	  	obj.retGridPanelitemStore.load({});  	  	
	  	  	});
		}
    }
	obj.deleteitembtn_click = function()
	{
	  var RID=obj.ICUCIIRowid.getValue();
	  
	  if(RID=="")
	  {
	    Ext.Msg.alert("提示","请选择一条要删除的记录！");
	    return;
	  }
	  Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCICUCInquiryConfig.DeleteInquiryitem(RID);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
		  	obj.ICUCIIRowid.setValue("");
            ClearInquiryitem();
            obj.retGridPanelitemStore.removeAll();
	  	  	obj.retGridPanelitemStore.load({}); 
		  	});

	  	}
	  );
	};       
    function ClearInquiryitem()
    {
	   
	    obj.ICUCIICode.setValue("");
	    //obj.ICUCIICodeDesc.setValue("");
	    obj.ICUCIIDesc.setValue("");
	    obj.ICUCIIType.setValue("");
	    obj.ICUCIIIsSearch.setValue("");
	    obj.ICUCIIIsDisplay.setValue("");
	    obj.ICUCIIDataField.setValue("");
	    obj.ICUCIIIsSingle.setValue("");
	    obj.ICUCIIMinQty.setValue("");
	    obj.ICUCIIMaxQty.setValue("");
	    obj.ICUCIINote.setValue("");
	    obj.ICUCIIMultiple.setValue("");
	    obj.ICUCIIStartDateTime.setValue("");
	    obj.ICUCIIDurationHour.setValue("");
	    obj.ICUCIIOeoriNote.setValue("");
	    obj.ICUCIIFromTime.setValue("");
	    obj.ICUCIIToTime.setValue("");
	    obj.ICUCIIExactTime.setValue("");
	    obj.ICUCIIRefIcuriId.setValue("");
	    obj.ICUCIIRefValue.setValue("");
	    obj.ICUCIISeqNo.setValue("");
	    obj.ICUCIILevel.setValue("");		    
    }
}
