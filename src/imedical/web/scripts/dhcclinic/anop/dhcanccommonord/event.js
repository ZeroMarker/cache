
function InitViewScreenEvent(obj)
{ 
	obj.intCurrRowIndex = -1;
	var _DHCANCCommonOrd=ExtTool.StaticServerObject('web.DHCANCCommonOrd');
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
	obj.ANCOViewCatDr_select =function()
	{
		addCompValToList(obj.ANCOViewCatDr,obj.listANCOViewCatDr);
	}
	obj.listANCOViewCatDr_dblClick=function()
	{
	    delListEl(obj.listANCOViewCatDr);
	}
	obj.ANCOTemplateSubAncoDr_select=function()
	{
		addCompValToList(obj.ANCOTemplateSubAncoDr,obj.listTempSubAncoDr);
	}
	obj.listTempSubAncoDr_dblClick=function()
	{
		delListEl(obj.listTempSubAncoDr);
	}
	obj.btnSch_click = function()
	{
		obj.retGridPanelStore.removeAll();
		obj.retGridPanelStore.load({});
			
			ClearReItemData(obj);
};
	
	obj.btnDel_click = function()
	{	
		var ANCORowId=obj.ANCORowId.getValue();
		if(ANCORowId=="")
		{
			ExtTool.alert("提示","请选择一条记录!");
			return;
		}
		var ret=_DHCANCCommonOrd.DeleteCommonOrd('','',ANCORowId);
		if(ret==0) 
		{
			ExtTool.alert("提示","删除成功!");
			ClearReItemData(obj);
			obj.retGridPanelStore.reload();
		}
		else ExtTool.alert("提示","删除失败!");	
	};
	
	obj.btnUpd_click = function()
	{
		var ANCORowId=obj.ANCORowId.getValue();
		if(ANCORowId=="")
		{
			ExtTool.alert("提示","请选择一条记录!");
			return;
		};
		if(!CheckData())
   		{
	    	return ;
		}
		var ANCOCode=obj.ANCOCode.getValue();
		var ANCODesc=obj.ANCODesc.getValue();
		var ANCOType=obj.ANCOType.getValue();
		var ANCOArcimDr=obj.ANCOArcimDr.getValue();	
		var ANCOViewCatDr="";
		var objListStore=new Ext.data.Store;
		objListStore=obj.listANCOViewCatDr.getStore();
		for (var i=0;i<objListStore.getCount();i++)
		{
			CatId=objListStore.getAt(i).get('listId');
			if(ANCOViewCatDr=="")
			{
				ANCOViewCatDr=CatId;
			}
			else
			{
				ANCOViewCatDr=ANCOViewCatDr+"|"+CatId;
			}
		}
		var ANCOUomDr=obj.ANCOUomDr.getValue();
		var ANCOIconDr=obj.ANCOIconDr.getValue();
		var ANCOColor="";
	    //if(obj.ANCOColor.getColor()!="none transparent scroll repeat 0% 0%") ANCOColor=obj.ANCOColor.getColor().split("#")[1];
		//20160913+dyl-------20170814 YuanLin
		var curColorRGB=obj.ANCOColor.getColor(); 
		var IfExit=curColorRGB.indexOf('rgb');
		var IfExitPX=curColorRGB.indexOf('px');
		if(IfExit!=-1)
		{
			var curColorStr1=curColorRGB.split("(");
			var curColorStr2=curColorStr1[1].split(")");
			var curColorStr3=curColorStr2[0].split(",");
			var redNum=curColorStr3[0];
			var greenNum=curColorStr3[1];
			var blueNum=curColorStr3[2]
			ANCOColor=toHexString(redNum,greenNum,blueNum);
		}
		else
		{
			if(IfExitPX!=-1)
			{
				var curColorRGB=curColorRGB.replace("px","");
				var k=(curColorRGB+'').length,s='';
				for(var i=0; i<6-k; i++)
				{
					s+='0';
				}
				var ANCOColor=s+curColorRGB;
			}
			else
			{
				var ANCOColor=curColorRGB;
			}
		}
		
		var ANCOAnApply="Y";
		var ANCOIcuApply="N";
		var ANCOOptions=obj.ANCOOptions.getValue();
		var ANCOICUCIOIDr=obj.ANCOICUCIOIDr.getValue();
		var ANCOMultiValueDesc=obj.ANCOMultiValueDesc.getValue();
		var ANCOSortNo=obj.ANCOSortNo.getValue();
		var ANCOArcosDr=obj.ANCOArcosDr.getValue();
		var ANCODataType=obj.ANCODataType.getValue();
		//var ANCOIsContinue=obj.ANCOIsContinue.getValue();
		//var ANCOAnMethodDr=obj.ANCOAnMethodDr.getValue();
		var ANCOMax=obj.ANCOMax.getValue();
		var ANCOMin=obj.ANCOMin.getValue();
		var ANCOImpossibleMax=obj.ANCOImpossibleMax.getValue();
		var ANCOImpossibleMin=obj.ANCOImpossibleMin.getValue();
		var ANCOMainAncoDr=obj.ANCOMainAncoDr.getValue();
		var ANCODataField=obj.ANCODataField.getValue();
		var ANCODataFormat=obj.ANCODataFormat.getValue(); 
		//var ANCOFormat=obj.ANCOFormat.getValue(); 
		var ANCOFormatField=obj.ANCOFormatField.getValue();
		var ANCOTemplateAncoDr=obj.ANCOTemplateAncoDr.getValue(); 
		var ANCOTemplateSubAncoDr="";
		var objListStore=new Ext.data.Store;
		objListStore=obj.listTempSubAncoDr.getStore();
		for (var i=0;i<objListStore.getCount();i++)
		{
			SubId=objListStore.getAt(i).get('listId');
			if(ANCOTemplateSubAncoDr=="")
			{
				ANCOTemplateSubAncoDr=SubId;
			}
			else
			{
				ANCOTemplateSubAncoDr=ANCOTemplateSubAncoDr+"|"+SubId;
			}
		}		

		var ANCOStr=ANCOCode+"^"+ANCODesc+"^"+ANCOType+"^"+ANCOArcimDr+"^"+ANCOViewCatDr+"^"+ANCOUomDr+"^"+ANCOIconDr+"^"+ANCOColor+"^"+ANCOAnApply+"^"+ANCOIcuApply+"^"+ANCOOptions+"^"+ANCOICUCIOIDr+"^"+ANCOMultiValueDesc+"^"+ANCOSortNo+"^"+ANCOArcosDr+"^"+ANCODataType+"^"+ANCOMax+"^"+ANCOMin+"^"+ANCOImpossibleMax+"^"+ANCOImpossibleMin+"^"+ANCOMainAncoDr+"^"+ANCODataField+"^"+ANCODataFormat+"^"+ANCOFormatField+"^"+ANCOTemplateAncoDr+"^"+ANCOTemplateSubAncoDr
		//alert(ANCOStr)
		var ret=_DHCANCCommonOrd.UpdateCommonOrd('','',ANCORowId,ANCOStr);
		//alert(ret)
		if(ret==0) 
		{
			ExtTool.alert("提示","更新成功");
			ClearReItemData(obj);
			//obj.retGridPanelStore.removeAll();
            obj.retGridPanelStore.reload();
		}
		else ExtTool.alert("提示","更新失败!");
	};
	
	obj.btnAdd_click = function()
	{
		if(!CheckData())
   		{
	    	return ;
		}
		var ANCOCode=obj.ANCOCode.getValue();
		var ANCODesc=obj.ANCODesc.getValue();
		var ANCOType=obj.ANCOType.getValue();
		var ANCOArcimDr=obj.ANCOArcimDr.getValue();	
		var ANCOViewCatDr="";
		var objListStore=new Ext.data.Store;
		objListStore=obj.listANCOViewCatDr.getStore();
		for (var i=0;i<objListStore.getCount();i++)
		{
			CatId=objListStore.getAt(i).get('listId');
			if(ANCOViewCatDr=="")
			{
				ANCOViewCatDr=CatId;
			}
			else
			{
				ANCOViewCatDr=ANCOViewCatDr+"|"+CatId;
			}
		}
		var ANCOUomDr=obj.ANCOUomDr.getValue();
		var ANCOIconDr=obj.ANCOIconDr.getValue();
		var ANCOColor="";
	    if(obj.ANCOColor.getColor()!="none transparent scroll repeat 0% 0%") ANCOColor=obj.ANCOColor.getColor().split("#")[1];
		var ANCOAnApply="Y";
		var ANCOIcuApply="N";
		var ANCOOptions=obj.ANCOOptions.getValue();
		var ANCOICUCIOIDr=obj.ANCOICUCIOIDr.getValue();
		var ANCOMultiValueDesc=obj.ANCOMultiValueDesc.getValue();
		var ANCOSortNo=obj.ANCOSortNo.getValue();
		var ANCOArcosDr=obj.ANCOArcosDr.getValue();
		var ANCODataType=obj.ANCODataType.getValue();
		var ANCOIsContinue=obj.ANCOIsContinue.getValue();
		var ANCOAnMethodDr=obj.ANCOAnMethodDr.getValue();
		var ANCOMax=obj.ANCOMax.getValue();
		var ANCOMin=obj.ANCOMin.getValue();
		var ANCOImpossibleMax=obj.ANCOImpossibleMax.getValue();
		var ANCOImpossibleMin=obj.ANCOImpossibleMin.getValue();
		var ANCOMainAncoDr=obj.ANCOMainAncoDr.getValue();
		var ANCODataField=obj.ANCODataField.getValue();
		var ANCODataFormat=obj.ANCODataFormat.getValue(); 
		var ANCOFormatField=obj.ANCOFormatField.getValue();
		var ANCOTemplateAncoDr=obj.ANCOTemplateAncoDr.getValue(); 
		var ANCOTemplateSubAncoDr="";
		var objListStore=new Ext.data.Store;
		objListStore=obj.listTempSubAncoDr.getStore();
		for (var i=0;i<objListStore.getCount();i++)
		{
			SubId=objListStore.getAt(i).get('listId');
			if(ANCOTemplateSubAncoDr=="")
			{
				ANCOTemplateSubAncoDr=SubId;
			}
			else
			{
				ANCOTemplateSubAncoDr=ANCOTemplateSubAncoDr+"|"+SubId;
			}
		}	
		var ANCOStr=ANCOCode+"^"+ANCODesc+"^"+ANCOType+"^"+ANCOArcimDr+"^"+ANCOViewCatDr+"^"+ANCOUomDr+"^"+ANCOIconDr+"^"+ANCOColor+"^"+ANCOAnApply+"^"+ANCOIcuApply+"^"+ANCOOptions+"^"+ANCOICUCIOIDr+"^"+ANCOMultiValueDesc+"^"+ANCOSortNo+"^"+ANCOArcosDr+"^"+ANCODataType+"^"+ANCOIsContinue+"^"+ANCOAnMethodDr+"^"+ANCOMax+"^"+ANCOMin+"^"+ANCOImpossibleMax+"^"+ANCOImpossibleMin+"^"+ANCOMainAncoDr+"^"+ANCODataField+"^"+ANCODataFormat+"^"+ANCOFormatField+"^"+ANCOTemplateAncoDr+"^"+ANCOTemplateSubAncoDr
		//alert(ANCOStr)
		var ret=_DHCANCCommonOrd.AddCommonOrd('','',ANCOStr);
		if(ret==0) 
		{
			ExtTool.alert("提示","添加成功");
			ClearReItemData(obj);
			obj.retGridPanelStore.reload();
			
		}
		else ExtTool.alert("提示","添加失败!");		
	};
	
	var SelectedRowID =0;
    var preRowID=0;
	obj.retGridPanel_rowclick=function() //点击后获取数据
	{
		
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		var linenum=obj.retGridPanel.getSelectionModel().lastActive;
		if (selectObj)
	    {	
		    SelectedRowID=selectObj.get("rowid");
		    if(preRowID!=SelectedRowID)
		    {
				obj.ANCORowId.setValue(selectObj.get("rowid"));
				obj.ANCOCode.setValue(selectObj.get("ComID"));
				obj.ANCODesc.setValue(selectObj.get("ComDes"));
				obj.ANCOColor.setColor(selectObj.get("tColorDesc"));
				obj.ANCOOptions.setValue(selectObj.get("tOptions"));
				obj.ANCOArcimDr.setValue(selectObj.get("ComItmID"));
				obj.ANCOArcimDr.setRawValue(selectObj.get("ComItm"));
				obj.ANCOType.setValue(selectObj.get("ComCatID"));
				obj.ANCOType.setRawValue(selectObj.get("ComCat"));
				obj.ANCODataType.setValue(selectObj.get("ancoDataType")); 
				obj.ANCODataType.setRawValue(selectObj.get("tAncoDataTypeDesc")); 
				obj.ANCOIconDr.setValue(selectObj.get("tIconRowId"));
				obj.ANCOIconDr.setRawValue(selectObj.get("tIconDesc"));
				obj.ANCOUomDr.setValue(selectObj.get("tUomRowId"));
				obj.ANCOUomDr.setRawValue(selectObj.get("tUomDesc"));
				obj.ANCOMultiValueDesc.setValue(selectObj.get("tAncoMultiValueDesc"));
				obj.ANCOSortNo.setValue(selectObj.get("tAncoSortNo"));
				obj.ANCOArcosDr.setValue(selectObj.get("arcosId"));
				obj.ANCOArcosDr.setRawValue(selectObj.get("tArcos"));
				obj.ANCOViewCatDr.setValue(selectObj.get("tANCEViewCatId"));
				obj.ANCOViewCatDr.setRawValue(selectObj.get("tANCEViewCat"));
				var ViewCatIdlist=(selectObj.get("tANCEViewCatId")).split("|");
				var ViewCatDesclist=(selectObj.get("tANCEViewCat")).split(";")
				objListStore=obj.listANCOViewCatDr.getStore(); 
				objListStore.removeAll();
		    	for(i=0;i<ViewCatIdlist.length;i++)
		    	{
			    ViewCatId=ViewCatIdlist[i];
			    ViewCatDesc=ViewCatDesclist[i];
			    addToList(ViewCatId,ViewCatDesc,obj.listANCOViewCatDr);
		   		}
		   	    obj.ANCOMax.setValue(selectObj.get("tAncoMax"));
		   		obj.ANCOMin.setValue(selectObj.get("tAncoMin"));
		   		obj.ANCOImpossibleMax.setValue(selectObj.get("tANCOImpossibleMax"));
		   		obj.ANCOImpossibleMin.setValue(selectObj.get("tANCOImpossibleMin"));
		   		obj.ANCOICUCIOIDr.setValue(selectObj.get("tItmId"));
		   		obj.ANCOICUCIOIDr.setRawValue(selectObj.get("tItmDesc"));
		   		obj.ANCODataFormat.setValue(selectObj.get("tANCODataFormat"));
		   		obj.ANCODataField.setValue(selectObj.get("tANCODataField"));
		   		//obj.ANCODataField.setRawValue(selectObj.get("tANCODataFieldDesc"));
		   		obj.ANCOMainAncoDr.setValue(selectObj.get("tANCOMainAncoDr"));
		   		obj.ANCOMainAncoDr.setRawValue(selectObj.get("tANCOMainAncoDesc"));
		   		obj.ANCOFormatField.setValue(selectObj.get("tANCOFormatField"));
		   		obj.ANCOTemplateAncoDr.setValue(selectObj.get("tANCOTemplateAncoDrID"));
		   		obj.ANCOTemplateAncoDr.setRawValue(selectObj.get("tANCOTemplateAncoDr"));
		   		obj.ANCOTemplateSubAncoDr.setValue(selectObj.get("ANCOTemplateSubAncoDrID"));
		   		obj.ANCOTemplateSubAncoDr.setRawValue(selectObj.get("tANCOTemplateSubAncoDr"));
				var TemplateSubIdlist=(selectObj.get("ANCOTemplateSubAncoDrID")).split("|");
				var TemplateSubDesclist=(selectObj.get("tANCOTemplateSubAncoDr")).split(";")
				objListStore=obj.listTempSubAncoDr.getStore(); 
				objListStore.removeAll();
		    	for(i=0;i<TemplateSubIdlist.length;i++)
		    	{
				    TemplateSubId=TemplateSubIdlist[i];
				    TemplateSubDesc=TemplateSubDesclist[i];
				    addToList(TemplateSubId,TemplateSubDesc,obj.listTempSubAncoDr);
		   		}	   
		   		preRowID=SelectedRowID;
		   	}
		   	else
		   	{
			    obj.ANCORowId.setValue("");
				obj.ANCOCode.setValue("");
				obj.ANCODesc.setValue("");
				obj.ANCOColor.setColor("");
				obj.ANCOOptions.setValue("");
				obj.ANCOArcimDr.setValue("");
				obj.ANCOType.setValue("");
				obj.ANCOArcosDr.setValue("");
				obj.ANCODataType.setValue(""); 
				obj.ANCOIconDr.setValue("");
				obj.ANCOUomDr.setValue("");
				obj.ANCOMultiValueDesc.setValue("");
				obj.ANCOSortNo.setValue("");
				obj.ANCOArcosDr.setValue("");			
				obj.ANCOViewCatDr.setValue("");
				objListStore=obj.listANCOViewCatDr.getStore(); 
				objListStore.removeAll();
				obj.ANCOMax.setValue("");
				obj.ANCOMin.setValue("");
				obj.ANCOImpossibleMax.setValue("");
				obj.ANCOImpossibleMin.setValue("");
				obj.ANCOICUCIOIDr.setValue("");
				obj.ANCODataFormat.setValue("");
				obj.ANCODataField.setValue("");
				obj.ANCOMainAncoDr.setValue("");
				obj.ANCOFormatField.setValue("");
		        obj.ANCOTemplateAncoDr.setValue("");
		        obj.ANCOTemplateSubAncoDr.setValue("");
		        obj.listTempSubAncoDr.getStore().removeAll();
		        obj.retGridPanel.getSelectionModel().deselectRow(linenum);
				SelectedRowID =0;
			    preRowID=0;
			   	}
		  	}
	};
function CheckData()
{		
		var ANCOCode=obj.ANCOCode.getValue();
		var ANCODesc=obj.ANCODesc.getValue();
		var ANCOArcimDr=obj.ANCOArcimDr.getValue();
	 	var ANCOMax=obj.ANCOMax.getValue();
		var ANCOMin=obj.ANCOMin.getValue();
		var ANCOImpossibleMax=obj.ANCOImpossibleMax.getValue();
		var ANCOImpossibleMin=obj.ANCOImpossibleMin.getValue();
     	if(ANCOCode=="")
     	{
	     	alert("代码为空！");
	     	obj.ANCOCode.focus();
	     	return false;	     	
     	}
     	if(ANCODesc=="")
     	{
	     	alert("名称为空！");
	     	obj.ANCODesc.focus();
	     	return false;	
	    }
	    /*if(ANCOArcimDr=="")
	    {
		    alert("医嘱不能为空！");
		    obj.ANCOArcimDr.focus();
	     	return false;	
		}*/
     	if(ANCOMax!="")
    	{
	    	if(!(/^(-?\d+)(\.\d+)?$/.test(ANCOMax)))  
       		{
	   	 		alert("请输入数字!")
				ANCOMax="";
				obj.ANCOMax.focus();
	   			return false;
	   		}
     	}
   		if(ANCOMin!="")
    	{
	    	if(!(/^(-?\d+)(\.\d+)?$/.test(ANCOMin)))  
       		{
	   	 		alert("请输入数字!")
				ANCOMin="";
				obj.ANCOMin.focus();
	   			return false;
	   		}
     	}
     	if(ANCOImpossibleMax!="")
    	{
	    	if(!(/^(-?\d+)(\.\d+)?$/.test(ANCOImpossibleMax)))  
       		{
	   	 		alert("请输入数字!")
				ANCOImpossibleMax="";
				obj.ANCOImpossibleMax.focus();
	   			return false;
	   		}
     	}
     	if(ANCOImpossibleMin!="")
    	{
	    	if(!(/^(-?\d+)(\.\d+)?$/.test(ANCOImpossibleMin))) 
       		{
	   	 		alert("请输入数字!")
				ANCOImpossibleMin="";
				obj.ANCOImpossibleMin.focus();
	   			return false;
	   		}
     	}
		if(ANCOImpossibleMin!=""&&ANCOImpossibleMax!="")
		{
			if((+ANCOImpossibleMax)<(+ANCOImpossibleMin))
			{
				alert("极度值大不能小于极度值小请重新输入!");
				ANCOImpossibleMin="";
				ANCOImpossibleMax="";
				obj.ANCOImpossibleMax.focus();
				return false;
			}

		}	
		if(ANCOMax!=""&&ANCOMin!="")
		{
			if(+ANCOMax<+ANCOMin)
			{
				alert("最大值不能小于最小值请重新输入!");
				ANCOMax="";
				ANCOMin="";
				obj.ANCOMax.foucs();
				return false;
			}

		}
		
	return true;
};
//20160913+dyl
function toHexString(r,g,b) 
{
 	return ("00000" + (r << 16 | g << 8 | b).toString(16)).slice(-6);
}

function ClearReItemData(obj)
{
	//obj.retGridPanelStore.load({});
	
	obj.ANCORowId.setValue("");
	obj.ANCOCode.setValue("");
	obj.ANCODesc.setValue("");
	obj.ANCOColor.setColor("");
	obj.ANCOOptions.setValue("");
	obj.ANCOType.setValue("");
	obj.ANCOArcimDr.setValue("");
	obj.ANCOArcosDr.setValue("");
	obj.ANCODataType.setValue(""); 
	obj.ANCOIconDr.setValue("");
	obj.ANCOUomDr.setValue("");
	obj.ANCOMultiValueDesc.setValue("");
	obj.ANCOSortNo.setValue("");
	obj.ANCOArcosDr.setValue("");	
	obj.ANCOViewCatDr.setValue("");
	obj.listANCOViewCatDr.getStore().removeAll();
	obj.ANCOMax.setValue("");
	obj.ANCOMin.setValue("");
	obj.ANCOImpossibleMax.setValue("");
	obj.ANCOImpossibleMin.setValue("");
	obj.ANCOICUCIOIDr.setValue("");
	obj.ANCODataFormat.setValue("");
	obj.ANCODataField.setValue("");
	obj.ANCOMainAncoDr.setValue("");
	obj.ANCOFormatField.setValue("");
	obj.ANCOTemplateAncoDr.setValue("");
	obj.ANCOTemplateSubAncoDr.setValue("");
	obj.listTempSubAncoDr.getStore().removeAll();
}
}