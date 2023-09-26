function InitViewScreenEvent(obj)
{
	obj._DHCANCInquiry=ExtTool.StaticServerObject('web.DHCANCInquiry');
	obj._DHCANOPStat=ExtTool.StaticServerObject('web.DHCANOPStat');
	obj.selectObj = null;
	
	obj.LoadEvent = function(args)
	{
	};
	obj.comInquiry_select = function()
	{
		var anciId = obj.comInquiry.getValue();
		obj.anciId = anciId;
		var index = obj.comInquiryStore.indexOfId(anciId);
		var record = obj.comInquiryStore.getAt(index);
		obj.resultPanel.setTitle("手术查询结果:"+record.get('ANCIDesc'));
		obj.anciId = anciId;
		obj.historySeq = "";
		ClearInquiryItemPanel();
		if(record.get('ANCIDataType')!="S")
		{
			obj.inquiryItemContainerPanel.show();
			obj.inquiryHistoryDataPanel.hide();
			obj.InquiryItemGridStore.load({});
		}
		else
		{
			obj.inquiryItemContainerPanel.hide();
			obj.inquiryHistoryDataPanel.show();
			obj.HistoryDataGridStore.load({});
		}
		obj.retGridPanelStore.removeAll();
		obj.retGridHeaderStore.load({});
		obj.retSumTypeStore.load({});
		SetDefualtAppLoc();
	}
	function SetDefualtAppLoc()
	{
		var currentLocId = session['LOGON.CTLOCID'];
		if(currentLocId)
		{
			var record = obj.comAppLocStore.getById(currentLocId);
			if(record)
			{
				obj.itemComAppLoc.setValue(record.get('ctlocDesc'));
				obj.itemComAppLoc.readOnly=true;
			}
		}
	}
	obj.inquiryHistoryDataPanel_rowclick = function()
	{
		var selectobj=obj.inquiryHistoryDataPanel.getSelectionModel().getSelected();
		if(selectobj)
		{
			obj.historySeq = selectobj.get('historySeq');
			obj.RefreshInquiryResult();
			obj.ResetStartEndDate();
		}
	}

	obj.btnComplexSch_click=function(args)
	{
		obj.historySeq = "";
		var anciId = obj.comInquiry.getValue();
		obj.anciId = anciId;
		if(!Number(anciId))
		{
			alert("请选择查询策略后再点击查询!");
			return;
		}
		if(SaveInquiryItem(anciId)!="0")
		{
			alert("保存项目失败!");
			return;
		}
		obj.ifInquiry = 'Y';
		obj.RefreshInquiryResult();
		obj.ifInquiry = 'N';
		obj.historyDataPanelCheckCol.clearSelections();
	}
	obj.btnSaveHistoryData_click=function(args)
	{
		var anciId=obj.anciId;
		if(obj.retGridPanelStore.totalLength<=0 || obj.retGridPanelStore.getCount()<=0)
		{
			alert("当前没有需要保存的数据，请查询到有效数据后再保存!");
			return;
		}
		obj._DHCANOPStat.StoreHistoryData(anciId);
		alert("保存成功!");
		obj.HistoryDataGridStore.load({});
	}
	obj.btnRemoveHistoryData_click=function(args)
	{
		var selectobjs=obj.inquiryHistoryDataPanel.getSelectionModel().getSelections();
		if(selectobjs)
		{
			obj.inquiryHistoryDataPanel.stopEditing();
			var anciId="";
			var historySeqStr="";
			for(var i=0;i<selectobjs.length;i++)
			{
				anciId = selectobjs[i].get('anciId');
				if(selectobjs[i].get('historySeq')!="")
				{
					if(historySeqStr.length>0)historySeqStr=historySeqStr+"^";
					historySeqStr = historySeqStr+selectobjs[i].get('historySeq');
				}
			}
			var result=obj._DHCANOPStat.RemoveHistoryData(anciId,historySeqStr);
			if(Number(result)==0)
			{
				alert("删除历史数据成功!");
			}
			else
			{
				return;
			}
			for(var i=0;i<selectobjs.length;i++)
			{
				obj.HistoryDataGridStore.remove(selectobjs[i]);
			}
			obj.inquiryHistoryDataPanel.startEditing(0, 0);
		}
	}
	obj.InquiryItemGridStore_load = function()
	{
		obj.comRelateAnciiData = [];
		obj.InquiryItemGridStore.each(function(record){
			var anciiSub = Number(record.get("anciiSub"));
			var isSearch = Number(record.get("anciiIsSearch"));
			if(isSearch && anciiSub)
			{
				obj.comRelateAnciiData.push([anciiSub]);
			}
			var inquiryItemCode = record.get("anciiCode");
			var index = obj.ANCInquiryItemStore.find('code',inquiryItemCode);
			if(index>-1)record.set("multiDelimiter",obj.ANCInquiryItemStore.getAt(index).get("multiDelimiter"));
		});
		obj.comRelateAnciiStore.removeAll();
		obj.comRelateAnciiStore.loadData(obj.comRelateAnciiData);
		InitInquiryItemPanel();
	}
	function InitInquiryItemPanel()
	{
		obj.inquiryItemRelatePanel.add(new Ext.form.Label({html:'<span style=\'color:red;font-weight:bold;\'>ID</span>  <span style=\'font-weight:bold;\'>关联</span>'}));
		obj.inquiryItemPanel.add(new Ext.form.Label({html:'<p style=\'padding-left:20px;\'><span style=\'font-weight:bold;\'>查询项目</span></p>'}));
		obj.inquiryItemValuePanel.add(new Ext.form.Label({html:'<p style=\'padding-left:80px;\'><span style=\'font-weight:bold;\'>多选值</span></p>'}));
		obj.inquiryItemMinPanel.add(new Ext.form.Label({html:'<p style=\'padding-left:10px;\'><span style=\'font-weight:bold;\'>最小值</span></p>'}));
		obj.inquiryItemMaxPanel.add(new Ext.form.Label({html:'<p style=\'padding-left:10px;\'><span style=\'font-weight:bold;\'>最大值</span></p>'}));
		obj.inquiryDataFieldPanel.add(new Ext.form.Label({html:'<p style=\'padding-left:10px;\'><span style=\'font-weight:bold;\'>字段</span></p>'}));
		var count = obj.InquiryItemGridStore.getCount();
		var record = null;
		var anciiId = "";
		var multiDelimiter = "";
		var multiValue = "";
		for(var i=0;i<count;i++)
		{
			record = obj.InquiryItemGridStore.getAt(i);
			if(!record.get('anciiIsSearch')) continue;
			multiDelimiter = record.get('multiDelimiter');
			multiValue = record.get("anciiMultiple");
			if(multiDelimiter!="") multiValue = multiValue.replace(multiDelimiter,',');
			anciiId = record.get('anciiId');
			obj.inquiryItemRelatePanel.add(new Ext.form.ComboBox({
					id : 'comAnciiRelate_'+anciiId
					,store : obj.comRelateAnciiStore
					,minChars : 1
					,displayField : 'value'
					,fieldLabel : '<span style=\'color:red;\'>'+record.get('anciiSub')+'</span>'
					,valueField : 'value'
					,triggerAction : 'all'
					,value : record.get('anciiRelateAnciiSub')
					,anchor : '90%'
					,lazyRender : true
					//,typeAhead: true
					,forceSelection : false
					,selectOnFocus:true
					,resizable:false
					,mode : 'local'
					//,minListWidth : 30
					,listeners :{
						'focus':function(event){
							var anciiSub = Number(this.id.split("_")[1].split("||")[1]);
							if(anciiSub)
							{
								obj.comRelateAnciiStore.removeAll();
								obj.comRelateAnciiStore.loadData(obj.comRelateAnciiData);
								var index = obj.comRelateAnciiStore.find('value',anciiSub);
								if(index>-1)obj.comRelateAnciiStore.removeAt(index);
							}
						},
						'change':function(event){
							var itemRecord = obj.InquiryItemGridStore.getById(this.id.split("_")[1]);
							if(itemRecord) itemRecord.set("anciiRelateAnciiSub",this.getValue());
						}
					}
				})
			);
			obj.inquiryItemValuePanel.add(new Ext.ux.form.LovCombo({
					id : 'comAnciiMulti_'+anciiId
					,minChars : 1
					,displayField : 'desc'
					,store : obj.refCommonQueryStore
					,triggerAction : 'all'
					,fieldLabel : '等于'
					,hideTrigger:false
					,anchor : '90%'
					,valueField : 'value'
					,value : multiValue
					,mode: 'local'
					,pageSize : 50
					,minListWidth : 400
					,grow:false
					,lazyRender : true
					,hideOnSelect:false
				    ,autoHeight:true
				    ,queryInFields:true
				    ,selectOnFocus:false
					,autoClear:false
				    ,queryFields:['desc'] //这个数组是用来设定查询字段的.
					,renderer: function(value,metadata,record){
						var rv = value
						var rva = rv.split(new RegExp(this.separator+ ' *'));
						var va = [];
						var snapshot = obj.refCommonQueryStore.snapshot || obj.refCommonQueryStore.data;
						Ext.each(rva, function(v) {
							var ex=0;
							snapshot.each(function(r) {
								if(v == r.get(this.valueField)) {
								va.push(r.get(this.displayField));
								ex=1;
							  }
							  })
							  if(ex==0)
							  {
								va.push(v)
							  }
							 })
						va.join(this.separator);
						return va;
					}
					,listeners :{
						'focus':function(event){
							InitCommonQueryStore(this.id.split("_")[1],this);
						},
						'specialkey':function(event){
							if(window.event.keyCode==13)
							{
								InitCommonQueryStore(this.id.split("_")[1],this);
							}
						},
						'blur':function(event){
							var itemRecord = obj.InquiryItemGridStore.getById(this.id.split("_")[1]);
							var valueStr = this.getValue();
							var rawValueStr = this.getRawValue();
							var multiDelimiter = itemRecord.get('multiDelimiter');
							if(itemRecord) 
							{
								if(valueStr!="")
								{
									if(multiDelimiter!="")itemRecord.set("anciiMultiple",valueStr.replace(this.separator,multiDelimiter));
									else itemRecord.set("anciiMultiple",valueStr);
								}
								else
								{
									itemRecord.set("anciiMultiple",rawValueStr);
								}
							}
						}
					}
				})
			);
			obj.inquiryItemPanel.add(new Ext.form.TextField({
					id : 'txtInquiryItemDesc_'+anciiId
					,anchor : '95%'
					,readOnly : true
					,value : record.get('anciiDesc')
				})
			);
			obj.inquiryItemMinPanel.add(new Ext.form.NumberField({
					id : 'txtInquiryItemMin_'+anciiId
					,anchor : '95%'
					,fieldLabel : '≥'
					,enableKeyEvents:true
					,allowNegative:false
					,value : record.get('anciiMinQty')
					,decimalPrecision:0
					,minValue:0
					,maxLength:3
					,listeners:{
						'change':function(event){
							var itemRecord = obj.InquiryItemGridStore.getById(this.id.split("_")[1]);
							if(itemRecord) itemRecord.set("anciiMinQty",this.getValue());
						}
					}
                })
			);
			obj.inquiryItemMaxPanel.add(new Ext.form.NumberField({
					id : 'txtInquiryItemMax_'+anciiId
					,anchor : '95%'
					,fieldLabel : '≤'
					,enableKeyEvents:true
					,allowNegative:false
					,value : record.get('anciiMaxQty')
					,decimalPrecision:0
					,minValue:0
					,maxLength:3
					,listeners:{
						'change':function(event){
							var itemRecord = obj.InquiryItemGridStore.getById(this.id.split("_")[1]);
							if(itemRecord) itemRecord.set("anciiMaxQty",this.getValue());
						}
					}
                })
			);
			obj.inquiryDataFieldPanel.add(new Ext.form.ComboBox({
					id : 'comAnciiDataField_'+anciiId
					,minChars : 1
					,displayField : 'desc'
					,store : obj.inquiryDataFieldStore
			    	,triggerAction : 'all'
					,anchor : '95%'
					,valueField : 'code'
					,minListWidth : 100
					,mode: 'local'
					,lazyRender : true
					//,typeAhead: true
					,forceSelection : false
					,value : record.get('anciiDataField')
					,selectOnFocus:true
					,resizable:false 
					,listeners :{
						'change':function(event){
							var itemRecord = obj.InquiryItemGridStore.getById(this.id.split("_")[1]);
							if(itemRecord) itemRecord.set("anciiDataField",this.getValue());
						}
					}
				})
			);
		}
		obj.inquiryItemContainerPanel.doLayout(false);
	}
	function SaveInquiryItem(anciId)
	{
		var saveInquiryItemList="";
		var count=obj.InquiryItemGridStore.getCount();
		if(!count) return "0";
		var visitAnciiNodeData = [];
		var separator = String.fromCharCode(3);
		visitAnciiNodeData[0] = [];
		obj.loopAnciiSub = "";
		for(var i=0;i<count;i++)
		{
			var record=obj.InquiryItemGridStore.getAt(i);
			if(record.get("anciiRelateAnciiSub")!="")
			{
				visitAnciiNodeData[0][record.get("anciiSub")]=record.get("anciiRelateAnciiSub");
			}
			if(saveInquiryItemList.length>0)saveInquiryItemList=saveInquiryItemList+"^";
			saveInquiryItemList=saveInquiryItemList+anciId+separator+record.get("anciiId")+separator+record.get("anciiCode")+separator+record.get("anciiDesc")+separator+record.get("anciiType")+separator+(record.get("anciiIsSearch")?1:0)+separator+(record.get("anciiIsDisplay")?1:0)+separator;
			saveInquiryItemList=saveInquiryItemList+record.get("anciiDataField")+separator+(record.get("anciiIsSingle")?1:0)+separator+record.get("anciiMinQty")+separator+record.get("anciiMaxQty")+separator+record.get("anciiNote")+separator+record.get("anciiMultiple")+separator+record.get("anciiStartDateTime")+separator;
			saveInquiryItemList=saveInquiryItemList+record.get("anciiDurationHour")+separator+record.get("anciiOeoriNote")+separator+record.get("anciiFromTime")+separator+record.get("anciiToTime")+separator+record.get("anciiExactTime")+separator+record.get("anciiRefAncoId")+separator+record.get("anciiRefValue")+separator;
			saveInquiryItemList=saveInquiryItemList+record.get("anciiSeqNo")+separator+record.get("anciiLevel")+separator+record.get("anciiFromAncoId")+separator+record.get("anciiToAncoId")+separator+record.get("anciiSummaryType")+separator+record.get("anciiDurationInterval")+separator+record.get("anciiRelateAnciiSub")+separator;
			saveInquiryItemList=saveInquiryItemList+record.get("anciiColumnWidth")+separator+(record.get("anciiIsResultSearch")?1:0)+separator+record.get("anciiFromDate")+separator+record.get("anciiToDate");
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
	function ClearInquiryItemPanel()
	{
		obj.InquiryItemGridStore.removeAll();
		obj.inquiryItemPanel.removeAll(true);
		obj.inquiryItemValuePanel.removeAll(true);
		obj.inquiryItemRelatePanel.removeAll(true);
		obj.inquiryItemMinPanel.removeAll(true);
		obj.inquiryItemMaxPanel.removeAll(true);
		obj.inquiryDataFieldPanel.removeAll(true);
	}
	function InitCommonQueryStore(anciiId,comObj)
	{
		var itemRecord = obj.InquiryItemGridStore.getById(anciiId);
		if(itemRecord)
		{
			var inquiryItemCode = itemRecord.get("anciiCode");
			var index = obj.ANCInquiryItemStore.find('code',inquiryItemCode);
			var thisValue = comObj.getRawValue();
			if(index!=-1)
			{
				if(obj.ResetRefCommonStore(index,thisValue))
				{
					itemRecord.set("multiDelimiter",obj.ANCInquiryItemStore.getAt(index).get("multiDelimiter"));
					return true;
				}
				else return false;
			}
		}
	}
}