
function InitViewScreenEvent(obj)
{ 
	obj.intCurrRowIndex = -1;
	var _DHCICUCRecordItem=ExtTool.StaticServerObject('web.DHCICUCRecordItem');
	obj.LoadEvent = function(args)
	{
	};

	function addToList(valStrId,valStrDes,objList)
	{
	    
		var objListStore=new Ext.data.Store;
		objListStore=objList.getStore();
	    var rec1= new (objListStore.recordType)();
		var length=objListStore.getCount();
		/*if (length>0)
		{
		     for(i=0;i<length;i++)
		     {
			      listId=objListStore.getAt(i).get('listId');
			      if (valStrId==listId) 
			      {
				      alert("显示分类重复!");
				      return;
			      }
		     }
		}*/
	    rec1.set('listDesc',valStrDes);
		rec1.set('listId',valStrId);
	    objListStore.addSorted(rec1);
		objList.bindStore(objListStore);
	}

	function addCompValToList(objCom,objList)
	{
	    var valStrDes=objCom.getRawValue();
		var valStrId=objCom.getValue();
		//addToList(valStrId,valStrDes,objList);
		//objCom.setRawValue('');
		var objListStore=new Ext.data.Store;
		objListStore=objList.getStore();
	    var rec1= new (objListStore.recordType)();
		var length=objListStore.getCount();
		if (length>0)
		{
		     for(i=0;i<length;i++)
		     {
			      listId=objListStore.getAt(i).get('listId');
			      if (valStrId==listId) 
			      {
				      alert("选择重复!");
				      return;
			      }
		     }
		}
	    rec1.set('listDesc',valStrDes);
		rec1.set('listId',valStrId);
	    objListStore.addSorted(rec1);
		objList.bindStore(objListStore);
	}
	
	function delListEl(objList)
	{
		var sel = objList.getSelectedRecords();
		var objListStore=new Ext.data.Store;
		objListStore=objList.getStore();
		objListStore.remove(sel);
		objList.bindStore(objListStore);
	}	
	obj.ICUCRIViewCatDr_select =function()
	{
		addCompValToList(obj.ICUCRIViewCatDr,obj.listICUCRIViewCatDr);
	}
	obj.listICUCRIViewCatDr_dblClick=function()
	{
	    delListEl(obj.listICUCRIViewCatDr);
	}
	obj.ICUCRITemplateSubICUCRIDr_select=function()
	{
		addCompValToList(obj.ICUCRITemplateSubICUCRIDr,obj.listTempSubICUCRDr);
	}
	obj.listTempSubICUCRDr_dblClick=function()
	{
		delListEl(obj.listTempSubICUCRDr);
	}
	obj.btnSch_click = function()
	{
		obj.retGridPanelStore.removeAll();
		obj.retGridPanelStore.load({
			params : {
				start:0
				,limit:20
			}
		}); 
		//ClearReItemData(obj);
	};
	obj.btnActive_click= function()
	{
		var ICUCRIRowId=obj.ICUCRIRowId.getValue();
		if(ICUCRIRowId=="")
		{
			ExtTool.alert("提示","ID为空!");
			return;
		}
		var ret=_DHCICUCRecordItem.ActiveDHCICUCRItem(ICUCRIRowId);
		if(ret==0) 
		{
			ExtTool.alert("提示","激活成功!");
			ClearReItemData(obj);
			obj.retGridPanelStore.load({
				params : {
					start:0
					,limit:20
				}});
		}
		else ExtTool.alert("提示","激活失败!"+ret);	
	};
	obj.btnDel_click = function()
	{	
		var ICUCRIRowId=obj.ICUCRIRowId.getValue();
		if(ICUCRIRowId=="")
		{
			ExtTool.alert("提示","ID为空!");
			return;
		}
		var ret=_DHCICUCRecordItem.DeleteDHCICUCRItem(ICUCRIRowId);
		if(ret==0) 
		{
			ExtTool.alert("提示","删除成功!");
			ClearReItemData(obj);
			obj.retGridPanelStore.load({
				params : {
					start:0
					,limit:20
				}});
		}
		else ExtTool.alert("提示","删除失败!");	
	};
	//

	//
	obj.btnUpd_click = function()
	{	
		var ICUCRIRowId=obj.ICUCRIRowId.getValue();
		if(ICUCRIRowId=="")
		{
			ExtTool.alert("提示","ID为空!");
			return;
		};
		if(!CheckData())
   		{
	    	return ;
		}
		var ICUCRICode=obj.ICUCRICode.getValue();
		var ICUCRIDesc=obj.ICUCRIDesc.getValue();
		var ICUCRIType=obj.ICUCRIType.getValue();
		var ICUCRIArcimDr=obj.ICUCRIArcimDr.getValue();	
		if((obj.ICUCRIArcimDr.getValue()==obj.ICUCRIArcimDr.getRawValue())&&(obj.ICUCRIArcimDr.getValue())!="")
		{
			alert("请从下拉列表里选择医嘱")
			return;
			}
				if((obj.ICUCRIICUCIOIDr.getValue()==obj.ICUCRIICUCIOIDr.getRawValue())&&(obj.ICUCRIICUCIOIDr.getValue())!="")
		{
			alert("请从下拉列表里选择汇总项")
			return;
			}
			if((obj.ICUCRITemplateICUCRIDr.getValue()==obj.ICUCRITemplateICUCRIDr.getRawValue())&&(obj.ICUCRITemplateICUCRIDr.getValue())!="")
		{
			alert("请从下拉列表里选择模板")
			return;
			}
				if((obj.ICUCRIMainICUCRIDr.getValue()==obj.ICUCRIMainICUCRIDr.getRawValue())&&(obj.ICUCRIMainICUCRIDr.getValue())!="")
		{
			alert("请从下拉列表里选择主项")
			return;
			}	
			
			if((obj.ICUCRIIconDr.getValue()==obj.ICUCRIIconDr.getRawValue())&&(obj.ICUCRIIconDr.getValue())!="")
		{
			alert("请从下拉列表里选择图例")
			return;
			}
			
			
				if((obj.ICUCRIUomDr.getValue()==obj.ICUCRIUomDr.getRawValue())&&(obj.ICUCRIUomDr.getValue())!="")
		{
			alert("请从下拉列表里选择单位")
			return;
			}	
			
			
			if((obj.ICUCRIArcosDr.getValue()==obj.ICUCRIArcosDr.getRawValue())&&(obj.ICUCRIArcosDr.getValue())!="")
		{
			alert("请从下拉列表里选择医嘱套")
			return;
			}
		var ICUCRIUomDr=obj.ICUCRIUomDr.getValue();
		var ICUCRIIconDr=obj.ICUCRIIconDr.getValue();
		//var ICUCRIColor=obj.ICUCRIColor.getValue();
		//var ICUColor=obj.ICUColor.getColor();
		//20160912+dyl-------
		var ICUColor="";
		var curColorRGB=obj.ICUColor.getColor();
		if(curColorRGB!="")
		{
			var curColorStr1=curColorRGB.split("(");
			if(curColorStr1.length>1)
			{
				var curColorStr2=curColorStr1[1].split(")");
				var curColorStr3=curColorStr2[0].split(",");
				var redNum=curColorStr3[0];
				var greenNum=curColorStr3[1];
				var blueNum=curColorStr3[2];
			}
			else
			{
				var redNum=0;
				var greenNum=0;
				var blueNum=0;
			}
			ICUColor=toHexString(redNum,greenNum,blueNum);
		}
		//-----------
	    //if(obj.ICUColor.getColor()!="none transparent scroll repeat 0% 0%") ICUColor=obj.ICUColor.getColor().split("#")[1];
		var ICUCRIAnApply=obj.ICUCRIAnApply.getValue();
		var ICUCRIIcuApply=obj.ICUCRIIcuApply.getValue();
		var ICUCRIOptions=obj.ICUCRIOptions.getValue();
		var ICUCRIICUCIOIDr=obj.ICUCRIICUCIOIDr.getValue();
		
		var ICUCRIMultiValueDesc=obj.ICUCRIMultiValueDesc.getValue();
		var ICUCRISortNo=obj.ICUCRISortNo.getValue();
		var ICUCRIArcosDr=obj.ICUCRIArcosDr.getValue();
		var ICUCRIDataType=obj.ICUCRIDataType.getValue();
		var ICUCRIIsContinue=obj.ICUCRIIsContinue.getValue();
		var ICUCRIAnMethodDr=obj.ICUCRIAnMethodDr.getValue();
		var ICUCRIMax=obj.ICUCRIMax.getValue();
		var ICUCRIMin=obj.ICUCRIMin.getValue();
		var ICUCRIImpossibleMax=obj.ICUCRIImpossibleMax.getValue();
		var ICUCRIImpossibleMin=obj.ICUCRIImpossibleMin.getValue();
		var ICUCRIMainICUCRIDr=obj.ICUCRIMainICUCRIDr.getValue();
		var ICUCRIDataField=obj.ICUCRIDataField.getValue();
		var ICUCRIDataFormat=obj.ICUCRIDataFormat.getValue(); 
		var ICUCRIFormat=obj.ICUCRIFormat.getValue();
		var ICUCRIFormatField=obj.ICUCRIFormatField.getValue();
		var ICUCRITemplateICUCRIDr=obj.ICUCRITemplateICUCRIDr.getValue(); 
		
		//var ICUCRITemplateSubICUCRIDr=obj.ICUCRITemplateSubICUCRIDr.getValue();	
		var TemplateSubstr=""
		var objListStore=new Ext.data.Store;
		objListStore=obj.listTempSubICUCRDr.getStore();
		for(var i=0;i<objListStore.getCount();i++)
		{
			TemplateSubId=objListStore.getAt(i).get('listId');
			if (TemplateSubstr=="")
			{
				TemplateSubstr=TemplateSubId;
			}
			else
			{
				TemplateSubstr=TemplateSubstr+"|"+TemplateSubId;
			}
			
		}
		var ICUCRISumFormat=obj.ICUCRISumFormat.getValue();
		var ICUCRISumFormatField=obj.ICUCRISumFormatField.getValue();
		var ICUCRIViewCatDr="";
		var objListStore=new Ext.data.Store;
		objListStore=obj.listICUCRIViewCatDr.getStore();
		for (var i=0;i<objListStore.getCount();i++)
		{
			CatId=objListStore.getAt(i).get('listId');
			if(ICUCRIViewCatDr=="")
			{
				ICUCRIViewCatDr=CatId;
			}
			else
			{
				ICUCRIViewCatDr=ICUCRIViewCatDr+"|"+CatId;
			}
		}
		//alert(ICUCRIRowId+","+ICUCRICode+","+ICUCRIDesc+","+ICUCRIType+","+ICUCRIArcimDr+","+ICUCRIViewCatDr+","+ICUCRIUomDr+","+ICUCRIIconDr+","+ICUColor+","+ICUCRIAnApply+","+ICUCRIIcuApply+","+ICUCRIOptions+","+ICUCRIICUCIOIDr+","+ICUCRIMultiValueDesc+","+ICUCRISortNo+","+ICUCRIArcosDr+","+ICUCRIDataType+","+ICUCRIIsContinue+","+ICUCRIAnMethodDr+","+ICUCRIMax+","+ICUCRIMin+","+ICUCRIImpossibleMax+","+ICUCRIImpossibleMin+","+ICUCRIMainICUCRIDr+","+ICUCRIDataField+","+ICUCRIDataFormat+","+ICUCRIFormat+","+ICUCRIFormatField+","+ICUCRITemplateICUCRIDr+","+TemplateSubstr+","+ICUCRISumFormat+","+ICUCRISumFormatField)
		var ret=_DHCICUCRecordItem.UpdateDHCICUCRItem(ICUCRIRowId,ICUCRICode,ICUCRIDesc,ICUCRIType,ICUCRIArcimDr,ICUCRIViewCatDr,ICUCRIUomDr,ICUCRIIconDr,ICUColor,ICUCRIAnApply,ICUCRIIcuApply,ICUCRIOptions,ICUCRIICUCIOIDr,ICUCRIMultiValueDesc,ICUCRISortNo,ICUCRIArcosDr,ICUCRIDataType,ICUCRIIsContinue,ICUCRIAnMethodDr,ICUCRIMax,ICUCRIMin,ICUCRIImpossibleMax,ICUCRIImpossibleMin,ICUCRIMainICUCRIDr,ICUCRIDataField,ICUCRIDataFormat,ICUCRIFormat,ICUCRIFormatField,ICUCRITemplateICUCRIDr,TemplateSubstr,ICUCRISumFormat,ICUCRISumFormatField);
		//alert(ret)
		if(ret==0) 
		{
			ExtTool.alert("提示","更新成功");
			ClearReItemData(obj);
            obj.retGridPanelStore.load({
				params : {
					start:0
					,limit:20
				}});
		}
		else ExtTool.alert("提示","更新失败!");
		};
	
	obj.btnAdd_click = function()
	{
		if(!CheckData())
   		{
	    	return ;
		}
		if((obj.ICUCRIArcimDr.getValue()==obj.ICUCRIArcimDr.getRawValue())&&(obj.ICUCRIArcimDr.getValue())!="")
		{
			alert("请从下拉列表里选择医嘱")
			return;
			}
				if((obj.ICUCRIICUCIOIDr.getValue()==obj.ICUCRIICUCIOIDr.getRawValue())&&(obj.ICUCRIICUCIOIDr.getValue())!="")
		{
			alert("请从下拉列表里选择汇总项")
			return;
			}
			if((obj.ICUCRITemplateICUCRIDr.getValue()==obj.ICUCRITemplateICUCRIDr.getRawValue())&&(obj.ICUCRITemplateICUCRIDr.getValue())!="")
		{
			alert("请从下拉列表里选择模板")
			return;
			}
				if((obj.ICUCRIMainICUCRIDr.getValue()==obj.ICUCRIMainICUCRIDr.getRawValue())&&(obj.ICUCRIMainICUCRIDr.getValue())!="")
		{
			alert("请从下拉列表里选择主项")
			return;
			}	
			
			if((obj.ICUCRIIconDr.getValue()==obj.ICUCRIIconDr.getRawValue())&&(obj.ICUCRIIconDr.getValue())!="")
		{
			alert("请从下拉列表里选择图例")
			return;
			}
			
			
				if((obj.ICUCRIUomDr.getValue()==obj.ICUCRIUomDr.getRawValue())&&(obj.ICUCRIUomDr.getValue())!="")
		{
			alert("请从下拉列表里选择单位")
			return;
			}	
			
			
			if((obj.ICUCRIArcosDr.getValue()==obj.ICUCRIArcosDr.getRawValue())&&(obj.ICUCRIArcosDr.getValue())!="")
		{
			alert("请从下拉列表里选择医嘱套")
			return;
			}
		var ICUCRICode=obj.ICUCRICode.getValue();
		var ICUCRIDesc=obj.ICUCRIDesc.getValue();
		var ICUCRIType=obj.ICUCRIType.getValue();
		var ICUCRIArcimDr=obj.ICUCRIArcimDr.getValue();
		var ICUCRIUomDr=obj.ICUCRIUomDr.getValue();
		var ICUCRIIconDr=obj.ICUCRIIconDr.getValue();
		//var ICUCRIColor=obj.ICUCRIColor.getValue();
		//var ICUColor="";
	   // if(obj.ICUColor.getColor()!="none transparent scroll repeat 0% 0%") ICUColor=obj.ICUColor.getColor().split("#")[1];
				//20160912+dyl-------
		var ICUColor="";
		var curColorRGB=obj.ICUColor.getColor();
		if(curColorRGB!="")
		{
			var curColorStr1=curColorRGB.split("(");
			if(curColorStr1.length>1)
			{
				var curColorStr2=curColorStr1[1].split(")");
				var curColorStr3=curColorStr2[0].split(",");
				var redNum=curColorStr3[0];
				var greenNum=curColorStr3[1];
				var blueNum=curColorStr3[2];
			}
			else
			{
				var redNum=0;
				var greenNum=0;
				var blueNum=0;
			}
			ICUColor=toHexString(redNum,greenNum,blueNum);
		}
		//-----------

		var ICUCRIAnApply=obj.ICUCRIAnApply.getValue();
		var ICUCRIIcuApply=obj.ICUCRIIcuApply.getValue();
		var ICUCRIOptions=obj.ICUCRIOptions.getValue();
		var ICUCRIICUCIOIDr=obj.ICUCRIICUCIOIDr.getValue();
		var ICUCRIMultiValueDesc=obj.ICUCRIMultiValueDesc.getValue();
		var ICUCRISortNo=obj.ICUCRISortNo.getValue();
		var ICUCRIArcosDr=obj.ICUCRIArcosDr.getValue();
		var ICUCRIDataType=obj.ICUCRIDataType.getValue();
		var ICUCRIIsContinue=obj.ICUCRIIsContinue.getValue();
		var ICUCRIAnMethodDr=obj.ICUCRIAnMethodDr.getValue();
		var ICUCRIMax=obj.ICUCRIMax.getValue();
		var ICUCRIMin=obj.ICUCRIMin.getValue();
		var ICUCRIImpossibleMax=obj.ICUCRIImpossibleMax.getValue();
		var ICUCRIImpossibleMin=obj.ICUCRIImpossibleMin.getValue();
		var ICUCRIMainICUCRIDr=obj.ICUCRIMainICUCRIDr.getValue();
		var ICUCRIDataField=obj.ICUCRIDataField.getValue();
		var ICUCRIDataFormat=obj.ICUCRIDataFormat.getValue(); 
		var ICUCRIFormat=obj.ICUCRIFormat.getValue();
		var ICUCRIFormatField=obj.ICUCRIFormatField.getValue();
		var ICUCRITemplateICUCRIDr=obj.ICUCRITemplateICUCRIDr.getValue(); 
		//var ICUCRITemplateSubICUCRIDr=obj.ICUCRITemplateSubICUCRIDr.getValue();
		var TemplateSubstr=""
		var objListStore=new Ext.data.Store;
		objListStore=obj.listTempSubICUCRDr.getStore(); 
		for(var i=0;i<objListStore.getCount();i++)
		{
			TemplateSubId=objListStore.getAt(i).get('listId');
			if (TemplateSubstr=="")
			{
				TemplateSubstr=TemplateSubId;
			}
			else
			{
				TemplateSubstr=TemplateSubstr+"|"+TemplateSubId;
			}
			
		}
		//alert(TemplateSubstr)
		var ICUCRISumFormat=obj.ICUCRISumFormat.getValue();
		var ICUCRISumFormatField=obj.ICUCRISumFormatField.getValue(); 
		var ICUCRIViewCatDr="";
		var objListStore=new Ext.data.Store;
		objListStore=obj.listICUCRIViewCatDr.getStore();
		for (var i=0;i<objListStore.getCount();i++)
		{
			CatId=objListStore.getAt(i).get('listId');
			if(ICUCRIViewCatDr=="")
			{
				ICUCRIViewCatDr=CatId;
			}
			else
			{
				ICUCRIViewCatDr=ICUCRIViewCatDr+"|"+CatId;
			}
		}
		var ret=_DHCICUCRecordItem.InsertDHCICUCRItem(ICUCRICode,ICUCRIDesc,ICUCRIType,ICUCRIArcimDr,ICUCRIViewCatDr,ICUCRIUomDr,ICUCRIIconDr,ICUColor,ICUCRIAnApply,ICUCRIIcuApply,ICUCRIOptions,ICUCRIICUCIOIDr,ICUCRIMultiValueDesc,ICUCRISortNo,ICUCRIArcosDr,ICUCRIDataType,ICUCRIIsContinue,ICUCRIAnMethodDr,ICUCRIMax,ICUCRIMin,ICUCRIImpossibleMax,ICUCRIImpossibleMin,ICUCRIMainICUCRIDr,ICUCRIDataField,ICUCRIDataFormat,ICUCRIFormat,ICUCRIFormatField,ICUCRITemplateICUCRIDr,TemplateSubstr,ICUCRISumFormat,ICUCRISumFormatField);
		if(ret==0) 
		{
			ExtTool.alert("提示","添加成功");
			ClearReItemData(obj);
			obj.retGridPanelStore.load({
				params : {
					start:0
					,limit:20
				}});
		}
		else ExtTool.alert("提示","添加失败!"+ret);		
	};
	
	var SelectedRowID ="";
    var preRowID="";
	obj.retGridPanel_rowclick=function() //点击后获取数据
	{
		
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
	    {	
	    SelectedRowID=selectObj.get("tRowId");
	    if(preRowID!=SelectedRowID)
	    {
			obj.ICUCRIRowId.setValue(selectObj.get("tRowId"));
			obj.ICUCRICode.setValue(selectObj.get("tICUCRICode"));
			obj.ICUCRIDesc.setValue(selectObj.get("tICUCRIDesc"));
			obj.ICUColor.setColor(selectObj.get("tICUCRIColor"));
			obj.ICUCRIOptions.setValue(selectObj.get("tICUCRIOptions"));
			obj.ICUCRIArcimDr.setValue(selectObj.get("tICUCRIArcimDr"));
			obj.ICUCRIArcimDr.setRawValue(selectObj.get("tICUCRIArcim"));
			
			obj.ICUCRIArcosDr.setValue(selectObj.get("tICUCRIArcosDr"));
			obj.ICUCRIType.setValue(selectObj.get("tICUCRIType")); 
			obj.ICUCRIType.setRawValue(selectObj.get("tICUCRITypeDesc")); 
			
			//alert(selectObj.get("tICUCRIType"))
			obj.ICUCRIIconDr.setValue(selectObj.get("tICUCRIIconDr"));
			obj.ICUCRIUomDr.setValue(selectObj.get("tICUCRIUomDr"));
			obj.ICUCRIMultiValueDesc.setValue(selectObj.get("tICUCRIMultiValueDesc"));
			obj.ICUCRIICUCIOIDr.setValue(selectObj.get("tICUCRIICUCIOIDr"));
			obj.ICUCRISortNo.setValue(selectObj.get("tICUCRISortNo"));
			obj.ICUCRIICUCIOIDr.setRawValue(selectObj.get("tICUCRIICUCIOI"));
			obj.ICUCRIDataType.setValue(selectObj.get("tICUCRIDataType"));
			obj.ICUCRIDataType.setRawValue(selectObj.get("tICUCRIDataTypeDesc"));
			obj.ICUCRIMax.setValue(selectObj.get("tICUCRIMax"));
			obj.ICUCRIMin.setValue(selectObj.get("tICUCRIMin"));
			obj.ICUCRIImpossibleMax.setValue(selectObj.get("tICUCRIImpossibleMax"));
			obj.ICUCRIImpossibleMin.setValue(selectObj.get("tICUCRIImpossibleMin"));
			obj.ICUCRISumFormat.setValue(selectObj.get("tICUCRISumFormat"));
			obj.ICUCRISumFormatField.setValue(selectObj.get("tICUCRISumFormatField"));
			obj.ICUCRIFormatField.setValue(selectObj.get("tICUCRIFormatField"));
			obj.ICUCRIFormat.setValue(selectObj.get("tICUCRIFormat"));
			obj.ICUCRIDataFormat.setValue(selectObj.get("tICUCRIDataFormat"));
			obj.ICUCRIDataField.setValue(selectObj.get("tICUCRIDataField"));
			obj.ICUCRITemplateICUCRIDr.setValue(selectObj.get("tICUCRITemplateICUCRIDr"));
			//alert(selectObj.get("tICUCRITemplateSubICUCRIDr"))
			//alert(selectObj.get("tICUCRITemplateSubICUCRI"))
            var TempSubIdlist=(selectObj.get("tICUCRITemplateSubICUCRIDr")).split("|");
	        var TempSubDesclist=(selectObj.get("tICUCRITemplateSubICUCRI")).split(";");
		    objListSubStore=obj.listTempSubICUCRDr.getStore(); 
		    objListSubStore.removeAll()
		    //alert(objListSubStore.getCount())
	        for(i=0;i<TempSubIdlist.length;i++)
	        {
		        TempSubId=TempSubIdlist[i];
		        TempSubDesc=TempSubDesclist[i];
		        addToList(TempSubId,TempSubDesc,obj.listTempSubICUCRDr);
	        }
			obj.ICUCRIMainICUCRIDr.setValue(selectObj.get("tICUCRIMainICUCRIDr"));
			obj.ICUCRIMainICUCRIDr.setRawValue(selectObj.get("tICUCRIMainICUCRI"));
			
			obj.ICUCRIAnMethodDr.setValue(selectObj.get("tICUCRIAnMethodDr"));
			obj.ICUCRIColor.setValue(selectObj.get("tICUCRIColor"));
			obj.ICUCRIViewCatDr.setValue(selectObj.get("tICUCRIViewCat"));
			var ViewCatIdlist=(selectObj.get("tICUCRIViewCatDr")).split("|");
			var ViewCatDesclist=(selectObj.get("tICUCRIViewCat")).split(";")
			objListStore=obj.listICUCRIViewCatDr.getStore(); 
			objListStore.removeAll();
	    	for(i=0;i<ViewCatIdlist.length;i++)
	    	{
		    ViewCatId=ViewCatIdlist[i];
		    ViewCatDesc=ViewCatDesclist[i];
		    addToList(ViewCatId,ViewCatDesc,obj.listICUCRIViewCatDr);
	   		}
	   		 preRowID=SelectedRowID;
	   		}
	   	else
	   	{
		    obj.ICUCRIRowId.setValue("");
			obj.ICUCRICode.setValue("");
			obj.ICUCRIDesc.setValue("");
			obj.ICUColor.setColor("");
			obj.ICUCRIOptions.setValue("");
			obj.ICUCRIArcimDr.setValue("");
			obj.ICUCRIArcosDr.setValue("");
			obj.ICUCRIType.setValue(""); 
			//alert(selectObj.get("tICUCRIType"))
			obj.ICUCRIIconDr.setValue("");
			obj.ICUCRIUomDr.setValue("");
			obj.ICUCRIMultiValueDesc.setValue("");
			obj.ICUCRIICUCIOIDr.setValue("");
			obj.ICUCRISortNo.setValue("");
			obj.ICUCRIICUCIOIDr.setValue("");
			obj.ICUCRIDataType.setValue("");
			obj.ICUCRIMax.setValue("");
			obj.ICUCRIMin.setValue("");
			obj.ICUCRIImpossibleMax.setValue("");
			obj.ICUCRIImpossibleMin.setValue("");
			obj.ICUCRISumFormat.setValue("");
			obj.ICUCRISumFormatField.setValue("");
			obj.ICUCRIFormatField.setValue("");
			obj.ICUCRIFormat.setValue("");
			obj.ICUCRIDataFormat.setValue("");
			obj.ICUCRIDataField.setValue("");
			obj.ICUCRITemplateICUCRIDr.setValue("");
			obj.ICUCRIMainICUCRIDr.setValue("");
			obj.ICUCRIAnMethodDr.setValue("");
			obj.ICUCRIColor.setValue("");
			obj.ICUCRITemplateSubICUCRIDr.setValue("");
			objListSubStore=obj.listTempSubICUCRDr.getStore(); 
			objListSubStore.removeAll();			
			obj.ICUCRIViewCatDr.setValue("");
			objListStore=obj.listICUCRIViewCatDr.getStore(); 
			objListStore.removeAll();
			SelectedRowID ="";
		    preRowID="";
		   	}
	  	}
	};
function CheckData()
{		
		var ICUCRICode=obj.ICUCRICode.getValue();
		var ICUCRIDesc=obj.ICUCRIDesc.getValue();
		var ICUCRIArcimDr=obj.ICUCRIArcimDr.getValue();
	 	var ICUCRIMax=obj.ICUCRIMax.getValue();
		var ICUCRIMin=obj.ICUCRIMin.getValue();
		var ICUCRIImpossibleMax=obj.ICUCRIImpossibleMax.getValue();
		var ICUCRIImpossibleMin=obj.ICUCRIImpossibleMin.getValue();
     	if((ICUCRICode=="")||(ICUCRIDesc==""))
     	{
	     	alert("代码或名称为空！");
	     	obj.ICUCRICode.focus();
	     	return false;	
	    }
	    /*if(ICUCRIArcimDr=="")
	    {
		    alert("医嘱不能为空！");
		    obj.ICUCRIArcimDr.focus();
	     	return false;	
		}*/
     	if(ICUCRIMax!="")
    	{
	    	if(!(/^(-?\d+)(\.\d+)?$/.test(ICUCRIMax)))  
       		{
	   	 		alert("请输入数字!")
				ICUCRIMax="";
				obj.ICUCRIMax.focus();
	   			return false;
	   		}
     	}
   		if(ICUCRIMin!="")
    	{
	    	if(!(/^(-?\d+)(\.\d+)?$/.test(ICUCRIMin)))  
       		{
	   	 		alert("请输入数字!")
				ICUCRIMin="";
				obj.ICUCRIMin.focus();
	   			return false;
	   		}
     	}
     	if(ICUCRIImpossibleMax!="")
    	{
	    	if(!(/^(-?\d+)(\.\d+)?$/.test(ICUCRIImpossibleMax)))  
       		{
	   	 		alert("请输入数字!")
				ICUCRIImpossibleMax="";
				obj.ICUCRIImpossibleMax.focus();
	   			return false;
	   		}
     	}
     	if(ICUCRIImpossibleMin!="")
    	{
	    	if(!(/^(-?\d+)(\.\d+)?$/.test(ICUCRIImpossibleMin))) 
       		{
	   	 		alert("请输入数字!")
				ICUCRIImpossibleMin="";
				obj.ICUCRIImpossibleMin.focus();
	   			return false;
	   		}
     	}
		if(ICUCRIImpossibleMin!=""&&ICUCRIImpossibleMax!="")
		{
			if((+ICUCRIImpossibleMax)<(+ICUCRIImpossibleMin))
			{
				alert("极度值大不能小于极度值小请重新输入!");
				ICUCRIImpossibleMin="";
				ICUCRIImpossibleMax="";
				obj.ICUCRIImpossibleMax.focus();
				return false;
			}

		}	
		if(ICUCRIMax!=""&&ICUCRIMin!="")
		{
			if(+ICUCRIMax<+ICUCRIMin)
			{
				alert("最大值不能小于最小值请重新输入!");
				ICUCRIMax="";
				ICUCRIMin="";
				obj.ICUCRIMax.foucs();
				return false;
			}

		}
		
	return true;
};
//20160912+dyl
function toHexString(r,g,b) 
{
 	return ("00000" + (r << 16 | g << 8 | b).toString(16)).slice(-6);
}
function ClearReItemData(obj)
{
		//obj.retGridPanelStore.load({});
		obj.ICUCRIRowId.setValue("");
		obj.ICUCRICode.setValue("");
		obj.ICUCRIDesc.setValue("");
		obj.ICUColor.setColor("");
		obj.ICUCRIOptions.setValue("");
		obj.ICUCRIArcimDr.setValue(""); 
		obj.ICUCRIType.setValue(""); 
		obj.ICUCRIViewCatDr.setValue("");
		obj.ICUCRIIconDr.setValue("");
		obj.ICUCRIUomDr.setValue("");
		obj.ICUCRIMultiValueDesc.setValue("");
		obj.ICUCRIICUCIOIDr.setValue("");
		obj.ICUCRISortNo.setValue("");
		obj.ICUCRIICUCIOIDr.setValue("");
		obj.ICUCRIDataType.setValue("");
		obj.ICUCRIMax.setValue("");
		obj.ICUCRIMin.setValue("");
		obj.ICUCRIImpossibleMax.setValue("");
		obj.ICUCRIImpossibleMin.setValue("");
		obj.ICUCRISumFormat.setValue("");
		obj.ICUCRISumFormatField.setValue("");
		obj.ICUCRIFormatField.setValue("");
		obj.ICUCRIFormat.setValue("");
		obj.ICUCRIDataFormat.setValue("");
		obj.ICUCRIDataField.setValue("");
		obj.ICUCRIArcosDr.setValue("");		//20160912+dyl
		obj.ICUCRITemplateICUCRIDr.setValue("");
		obj.ICUCRITemplateSubICUCRIDr.setValue("");
		obj.listTempSubICUCRDr.getStore().removeAll();		
		obj.ICUCRIMainICUCRIDr.setValue("");
		obj.listICUCRIViewCatDr.getStore().removeAll();
}

}




