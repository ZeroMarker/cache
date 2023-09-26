function InitViewScreenEvent(obj)
{
	obj._DHCANCInquiry=ExtTool.StaticServerObject('web.DHCANCInquiry');
	obj._DHCANOPStat=ExtTool.StaticServerObject('web.DHCANOPStat');
	obj.currentGridColumn = -1;
	obj.displayId = -1;
	obj.selectObj = null;
	obj.searchLevelList = new Array();
	
	obj.LoadEvent = function(args)
	{
	};
	obj.btnSaveInquiry_click = function(args)
	{
		if(!CheckInquiryData()) return;
		var userId=session['LOGON.USERID'];
		var ctlocId=session['LOGON.CTLOCID'];
		var ANCICode=obj.txtInquiryCode.getValue();
		var ANCIDesc=obj.txtInquiryDesc.getValue();
		var ANCICtlocDr=obj.comInquiryLoc.getValue();
		var ANCIStatus="";
		var ANCIType=obj.comANCIType.getValue();
		var ANCISearchLevel="";
		var ANCIDataType=obj.comANCIDataType.getValue();
		var ANCIDateTimeType="R";
		var ANCIIsActive=obj.chkInquiryIsActive.getValue();
		var anciId = obj.comInquiry.getValue();
		var saveRet = 0;
		if(anciId!="")
		{
			saveRet = obj._DHCANCInquiry.UpdateANCInquiry(anciId,ANCICode, ANCIDesc, ctlocId,ANCIStatus,ANCIType, ANCISearchLevel, 0, 0,1,ANCIDataType,ANCIDateTimeType,userId,ANCIIsActive?"1":"0",ANCICtlocDr);
		}
		else
		{
			saveRet = obj._DHCANCInquiry.InsertANCInquiry(ANCICode, ANCIDesc, ctlocId,ANCIStatus,ANCIType, ANCISearchLevel, 0, 0,1,ANCIDataType,ANCIDateTimeType,userId,ANCIIsActive?"1":"0",ANCICtlocDr);
		}
		if(Number(saveRet)<=0)
		{
			alert("保存失败，错误:"+saveRet);
			return;
		}
		else
		{
			obj.comInquiryStore.load({});
			obj.anciId = Number(saveRet);
			anciId = obj.anciId;
			var saveItemRet = SaveInquiryItem(obj.anciId);
			if(saveItemRet!="0")
			{
				alert("保存策略项目失败!")
			}
			else
			{
				alert("保存成功!");
				obj.comInquiry.setValue(obj.anciId);
				obj.retGridHeaderStore.load({});
				obj.InquiryItemGridStore.load({});
				obj._DHCANOPStat.SetIfStartStoreTimeLine(obj.anciId,obj.chkStartStoreTimeLine.getValue()?"1":"0");
			}
		}
	};

	function CheckInquiryData()
	{
		if(obj.txtInquiryCode.getValue()=="")
		{
			alert("策略代码不能为空!");
			obj.txtInquiryCode.focus();
			return false;
		}
		if(obj.txtInquiryDesc.getValue()=="")
		{
			alert("策略名称不能为空!");
			obj.txtInquiryDesc.focus();
			return false;
		}
		if(obj.comANCIType.getValue()=="")
		{
			alert("策略权限类型不能为空!");
			obj.comANCIType.focus();
			return false;
		}
		if(obj.comANCIDataType.getValue()=="")
		{
			alert("策略查询类型不能为空!");
			obj.comANCIDataType.focus();
			return false;
		}
		return true;
	}

	function SaveInquiryItem(anciId)
	{
		var saveInquiryItemList="";
		var count=obj.InquiryItemGridStore.getCount();
		var visitAnciiNodeData = [];
		var separator = String.fromCharCode(3);
		var message=new Array();
		obj.searchLevelList = new Array();
		visitAnciiNodeData[0] = [];
		obj.loopAnciiSub = "";
		for(var i=0;i<count;i++)
		{
			var record=obj.InquiryItemGridStore.getAt(i);
			if(!CheckInquiryItem(record,message))
			{
				alert("第"+(i+1)+"项:"+message[0]);
				obj.InquiryItemGridPanel.getView().getRow(i).title=message[0];
				obj.InquiryItemGridPanel.getView().getRow(i).style.backgroundColor="#ffe0e0";
				obj.InquiryItemGridPanel.getView().getCell(i,Number(message[1])).style.backgroundColor="#ff0000";
				return "-100";
			}
			if(record.get("anciiRelateAnciiSub")!="")
			{
				visitAnciiNodeData[0][record.get("anciiSub")]=record.get("anciiRelateAnciiSub");
			}
			if(saveInquiryItemList.length>0)saveInquiryItemList=saveInquiryItemList+"^";
			saveInquiryItemList=saveInquiryItemList+anciId+separator+record.get("anciiId")+separator+record.get("anciiCode")+separator+record.get("anciiDesc")+separator+record.get("anciiType")+separator+(record.get("anciiIsSearch")?1:0)+separator+(record.get("anciiIsDisplay")?1:0)+separator;
			saveInquiryItemList=saveInquiryItemList+record.get("anciiDataField")+separator+(record.get("anciiIsSingle")?1:0)+separator+record.get("anciiMinQty")+separator+record.get("anciiMaxQty")+separator+record.get("anciiNote")+separator+record.get("anciiMultiple")+separator+record.get("anciiStartDateTime")+separator;
			saveInquiryItemList=saveInquiryItemList+record.get("anciiDurationHour")+separator+record.get("anciiOeoriNote")+separator+record.get("anciiFromTime")+separator+record.get("anciiToTime")+separator+record.get("anciiExactTime")+separator+record.get("anciiRefAncoId")+separator+record.get("anciiRefValue")+separator;
			saveInquiryItemList=saveInquiryItemList+record.get("anciiSeqNo")+separator+record.get("anciiLevel")+separator+record.get("anciiFromAncoId")+separator+record.get("anciiToAncoId")+separator+record.get("anciiSummaryType")+separator+record.get("anciiDurationInterval")+separator+record.get("anciiRelateAnciiSub")+separator;
			saveInquiryItemList=saveInquiryItemList+record.get("anciiColumnWidth")+separator+(record.get("anciiIsResultSearch")?1:0)+separator+record.get("anciiFromDate")+separator+record.get("anciiToDate")+separator+(record.get("anciiIsNegative")?1:0);
		}
		if(CheckAnciiRelateLoop(visitAnciiNodeData))
		{
			alert("ID为"+obj.loopAnciiSub+"项目关联配置错误，不能存在回路，请重新配置!");
			obj.InquiryItemGridStore.getById(anciId+"||"+obj.loopAnciiSub).set("anciiRelateAnciiSub","");
			return "-11";
		}
		var saveItemRet="0";
		if(saveInquiryItemList.length>0) saveItemRet=obj._DHCANCInquiry.SaveInquiryItems(saveInquiryItemList);
		return saveItemRet;
	}
	function CheckInquiryItem(record,message)
	{
		if(!record.get("anciiCode"))
		{
			message[0]="策略项目代码不能为空!";
			message[1]=obj.InquiryItemGridCM.findColumnIndex("anciiCode");
			return false;
		}
		if(!record.get("anciiDesc"))
		{
			message[0]="策略项目名称不能为空!";
			message[1]=obj.InquiryItemGridCM.findColumnIndex("anciiDesc");
			return false;
		}
		if(record.get("anciiIsSearch") || record.get("anciiIsResultSearch"))
		{
			if(obj.searchLevelList.indexOf(Number(record.get("anciiLevel")))>=0)
			{
				message[0]="策略项目条件项筛选层不能重复!";
				message[1]=obj.InquiryItemGridCM.findColumnIndex("anciiLevel");
				return false;
			}
			else
			{
				obj.searchLevelList.push(Number(record.get("anciiLevel")));
			}
		}

		return true;
	}
	obj.loopAnciiSub = "";
	function CheckLineLoop(visitAnciiNodeData,start)
	{
		visitAnciiNodeData[1][start] = true;
		if(!visitAnciiNodeData[0][start]) return false;
		else if(visitAnciiNodeData[1][visitAnciiNodeData,visitAnciiNodeData[0][start]]) 
		{
			obj.loopAnciiSub = start;
			return true;
		}
		return CheckLineLoop(visitAnciiNodeData,visitAnciiNodeData[0][start]);
	}
	function CheckAnciiRelateLoop(visitAnciiNodeData)
	{
		for(var i in visitAnciiNodeData[0])
		{
			if(visitAnciiNodeData[0].hasOwnProperty(i) && i!='prototype'){
				visitAnciiNodeData[1]=[];
				if(CheckLineLoop(visitAnciiNodeData,i)) return true;
			}
		}
		return false;
	}
	obj.comInquiry_select = function()
	{
		var anciId = obj.comInquiry.getValue();
		obj.anciId = anciId;
		var index = obj.comInquiryStore.indexOfId(anciId);
		var record = obj.comInquiryStore.getAt(index);
		obj.txtInquiryCode.setValue(record.get('ANCICode'));
		obj.txtInquiryDesc.setValue(record.get('ANCIDesc'));
		obj.comANCIType.setValue(record.get('ANCIType'));
		obj.comANCIDataType.setValue(record.get('ANCIDataType'));
		obj.comInquiryLoc.setValue(record.get('ANCICtlocDr'));
		obj.comInquiryLoc.setRawValue(record.get('ANCICtloc'));
		obj.resultPanel.setTitle("手术查询结果:"+record.get('ANCIDesc'));
		obj.retGridPanelStore.removeAll();
		obj.InquiryItemGridStore.load({});
		obj.retSumTypeStore.load({});
		obj.retGridHeaderStore.load({});
		var ifStartStoreTimeLine = record.get('IfStartStoreTimeLine');
		if(Number(ifStartStoreTimeLine))
		{
			obj.chkStartStoreTimeLine.setValue(true);
		}
		else
		{
			obj.chkStartStoreTimeLine.setValue(false);
		}
		var isActive = record.get('ANCIIsActive');
		if(Number(isActive))
		{
			obj.chkInquiryIsActive.setValue(true);
		}
		else
		{
			obj.chkInquiryIsActive.setValue(false);
		}
	}
	obj.comInquiry_blur = function()
	{
		var rawValue = obj.comInquiry.getRawValue();
		if(rawValue=="" && obj.anciId)
		{
			obj.ClearSelectInquiry();
		}
	}

	obj.ClearSelectInquiry = function()
	{
		obj.comInquiry.clearValue();
		obj.anciId = "";
		obj.txtInquiryCode.setValue("");
		obj.txtInquiryDesc.setValue("");
		obj.comANCIType.setValue("");
		obj.comANCIDataType.setValue("");
		obj.comInquiryLoc.setValue("");
		obj.comInquiryLoc.setRawValue("");
		obj.resultPanel.setTitle("手术查询结果");
		obj.retGridPanelStore.removeAll();
		obj.InquiryItemGridStore.removeAll();
		obj.retSumTypeStore.removeAll();
		obj.retGridHeaderStore.removeAll();
	}
	
	obj.ANCInquiryItemStore_load=function(args)
	{
		obj.ANCInquiryItemStore.each(function(record){
			var type=record.get("type");
			if(type)
			{
				if(!obj.InquiryTypeItem[type])obj.InquiryTypeItem[type]=new Array();
				obj.InquiryTypeItem[type].push(record);
			}
			else
			{
				if(!obj.InquiryEmptyTypeItem)obj.InquiryEmptyTypeItem=new Array();
				obj.InquiryEmptyTypeItem.push(record);
			}
		});
	}
	obj.InquiryItemGridStore_load=function(args)
	{
		obj.comRelateAnciiData = [];
		obj.InquiryItemGridStore.each(function(record){
			var anciiSub = Number(record.get("anciiSub"));
			var isSearch = Number(record.get("anciiIsSearch"));
			if(isSearch && anciiSub)
			{
				obj.comRelateAnciiData.push([anciiSub]);
			}
		});
		obj.comRelateAnciiStore.removeAll();
		obj.comRelateAnciiStore.loadData(obj.comRelateAnciiData);
	}
	
	obj.btnComplexSch_click=function(args)
	{
		obj.ifInquiry = 'Y';
		obj.RefreshInquiryResult();
		obj.ifInquiry = 'N';
	}

	obj.InquiryItemGridPanel_rowclick=function(ev)
	{
		obj.selectObj = obj.retGridPanel.getSelectionModel().getSelected();
	}
	obj.InquiryItemGridPanel_beforeedit=function(ev)
	{
		if(ev.field=="anciiMultipleDesc")
		{
			obj.SetAllInquiryItem("");
			if(!ev.record.get("anciiIsSearch") && !ev.record.get("anciiIsSingle"))
			{
				var index = obj.InquiryItemGridStore.indexOf(ev.record);
				var isSearchColInd = obj.InquiryItemGridCM.findColumnIndex("anciiIsSearch");
				var isSingleColInd = obj.InquiryItemGridCM.findColumnIndex("anciiIsSingle");
				var multipleDescColInd = obj.InquiryItemGridCM.findColumnIndex("anciiMultipleDesc");
				if(index>=0)
				{
					obj.InquiryItemGridPanel.getView().getRow(index).title="勾选条件项或返回单条数据后才能选择多选值!";
					obj.InquiryItemGridPanel.getView().getCell(index,Number(isSearchColInd)).style.backgroundColor="#ffe0e0";
					obj.InquiryItemGridPanel.getView().getCell(index,Number(isSingleColInd)).style.backgroundColor="#ffe0e0";
					obj.InquiryItemGridPanel.getView().getCell(index,Number(multipleDescColInd)).style.backgroundColor="#ffe0e0";
				}
				return false;
			}
			var inquiryItemCode = ev.record.get("anciiCode");
			var index = obj.ANCInquiryItemStore.find('code',inquiryItemCode);
			var thisValue = ev.record.get("anciiMultiple");
			if(ev.field=="anciiMultipleDesc") thisValue = ev.record.get("anciiMultiple");
			if(index!=-1)
			{
				if(obj.ResetRefCommonStore(index,thisValue))
				{
					var comQueryInd = obj.refCommonQueryStore.find('value',ev.record.get("anciiMultiple"));
					if(comQueryInd!=-1)ev.record.set("refValueDesc",obj.refCommonQueryStore.getAt(comQueryInd).get("desc"));
					ev.record.set("multiDelimiter",obj.ANCInquiryItemStore.getAt(index).get("multiDelimiter"));
					return true;
				}
				else
				{
					var index = obj.InquiryItemGridStore.indexOf(ev.record);
					var multipleDescColInd = obj.InquiryItemGridCM.findColumnIndex("anciiMultipleDesc");
					if(index>=0)
					{
						obj.InquiryItemGridPanel.getView().getRow(index).title="未配置多选值选项，请在多选值处手工填写!";
						obj.InquiryItemGridPanel.getView().getCell(index,Number(multipleDescColInd)).style.backgroundColor="#ffe0e0";
					}
					return false;
				}
			}
		}
		else if(ev.field=="anciiDesc")
		{
			var anciiType = ev.record.get("anciiType");
			obj.SetAllInquiryItem(anciiType);
			return true;
		}
		else if(ev.field=="anciiRelateAnciiSub")
		{
			if(!ev.record.get("anciiIsSearch")&&!ev.record.get("anciiIsResultSearch")) return false;
			var anciiSub = Number(ev.record.get("anciiSub"));
			if(anciiSub)
			{
				obj.comRelateAnciiStore.removeAll();
				obj.comRelateAnciiStore.loadData(obj.comRelateAnciiData);
				var index = obj.comRelateAnciiStore.find('value',anciiSub);
				if(index>-1)obj.comRelateAnciiStore.removeAt(index);
				return true;
			}
			else
			{
				alert("配置项目未保存，请先保存后在设置关联关系!");
				return false;
			}
		}
	}
	obj.InquiryItemGridPanel_validateedit=function(ev)
	{
		if(ev.field == "anciiFromDate" || ev.field == "anciiToDate")
		{
			if(ev.value)
			{
				var date = new Date(ev.value);
				ev.value=date.getFullYear()+"-"+(date.getMonth()<9?"0":"")+(date.getMonth()+1)+"-"+(date.getDate()<9?"0":"")+date.getDate();
			}
		}
		else if(ev.field == "anciiType")
		{
			if(ev.value)
			{
				var anciiCode=ev.record.get("anciiCode");
				var index = obj.ANCInquiryItemStore.find('code',anciiCode);
				if(index>=0)
				{
					var selectANCIItem=obj.ANCInquiryItemStore.getAt(index);
					var anciiType=selectANCIItem.get("type");
					if(anciiType!=ev.value)
					{
						ev.record.set("anciiDesc","");
						ev.record.set("anciiCode","");
					}
				}
			}
		}
		else if(ev.field == "anciiDesc")
		{
			if(ev.value)
			{
				var anciiDesc=ev.value;
				var anciiCode=ev.record.get("anciiCode");
				var index = obj.ANCInquiryItemStore.find('desc',new RegExp("^"+anciiDesc.replace("(","\\(").replace(")","\\)")+"$"));
				if(index==-1) index = obj.ANCInquiryItemStore.find('code',anciiCode);
				if(index>=0)
				{
					var selectANCIItem=obj.ANCInquiryItemStore.getAt(index);
					ev.record.set("anciiCode",selectANCIItem.get("code"));
					ev.record.set("anciiType",selectANCIItem.get("type"));
				}
			}
		}
		else if(ev.field == "anciiMultipleDesc")
		{
			if(ev.value)
			{
				var multiDelimiter = ev.record.get("multiDelimiter");
				if (!multiDelimiter) multiDelimiter='|';
				ev.record.set("anciiMultiple",multiDelimiter==""?ev.value:ev.value.replace(/,/g,multiDelimiter));
			}
		}
	}
	obj.InquiryItemGridPanel_afteredit=function(ev)
	{
		if(!ev.record.get("anciiSeqNo")) ev.record.set("anciiSeqNo",obj.InquiryItemGridStore.getCount());
		if(!ev.record.get("anciiLevel")) ev.record.set("anciiLevel",1);
	}

	obj.btnAddInquiryItem_click = function(args)
	{
		var record = new obj.InquiryItemRecord({ 
			anciiId:''
			,anciiSub:''
			,anciiRelateAnciiSub:''
			,anciiCode:''
			,anciiDesc:''
			,anciiType:''
			,anciiRefValue:''
			,anciiRefAncoId:''
			,anciiRefAncoDesc:''
			,anciiDataField:''
			,anciiOeoriNote:''
			,anciiFromTime:''
			,anciiToTime:''
			,anciiExactTime:''
			,anciiIsSearch:''
			,anciiIsDisplay:''
			,anciiIsSingle:''
			,anciiMinQty:''
			,anciiMaxQty:''
			,anciiNote:''
			,anciiMultiple:''
			,anciiStartDateTime:''
			,anciiDurationHour:''
			,anciiSeqNo:obj.InquiryItemGridStore.getCount()+1
			,anciiLevel:obj.InquiryItemGridStore.getCount()+1
			,anciiFromAncoId:''
			,anciiToAncoId:''
			,anciiSummaryType:''
			,anciiDurationInterval:''
			,multiDelimiter:''
			,anciiColumnWidth:''
			,anciiIsResultSearch:''
			,anciiFromDate:''
			,anciiToDate:''
			,anciiIsNegative:''
		}); 
		obj.InquiryItemGridPanel.stopEditing(); 
		obj.InquiryItemGridStore.add(record); 
		obj.InquiryItemGridPanel.startEditing(0, 0); 
	}
	obj.btnDeleteInquiryItem_click=function(ev)
	{
		var selectobj=obj.InquiryItemGridPanel.getSelectionModel().getSelected();
		if(selectobj)
		{
			obj.InquiryItemGridPanel.stopEditing();
			if(selectobj.get('anciiId')!="")
			{
				var result=obj._DHCANCInquiry.DeleteInquiryitem(selectobj.get('anciiId'));
				if(Number(result)==0)
				{
					alert("删除成功!");
					obj.retGridHeaderStore.load({});
				}
			}
			obj.InquiryItemGridStore.remove(selectobj); 
			obj.InquiryItemGridPanel.startEditing(0, 0);
		}
	}
	
	obj.SetAllInquiryItem = function(anciiType)
	{
		obj.ANCInquiryItemStore.removeAll();
		obj.ANCInquiryItemStore.totalLength = 0;
		if(anciiType && obj.InquiryTypeItem[anciiType])
		{
			obj.ANCInquiryItemStore.add(obj.InquiryTypeItem[anciiType]);
			obj.ANCInquiryItemStore.totalLength += obj.InquiryTypeItem[anciiType].length;
		}
		else
		{
			for(var type in obj.InquiryTypeItem)
			{
				obj.ANCInquiryItemStore.add(obj.InquiryTypeItem[type]);
				obj.ANCInquiryItemStore.totalLength += obj.InquiryTypeItem[type].length;
			}
			obj.ANCInquiryItemStore.add(obj.InquiryEmptyTypeItem);
			obj.ANCInquiryItemStore.totalLength += obj.InquiryEmptyTypeItem.length;
		}
	}

}