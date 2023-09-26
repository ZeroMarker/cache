function InitViewScreenEvent(obj)
{
	var _DHCANOPStat=ExtTool.StaticServerObject('web.DHCANOPStat');
	
	obj.LoadEvent = function(args)
	{
		var url=location.search;
	    if(url.indexOf("?")!=-1) {         
			var str = url.substr(1);
			strs = str.split("&");        
			for(var i=0;i<strs.length;i++)         
			{               
				obj[strs[i].split("=")[0]]=unescape(strs[i].split("=")[1]);         
			}
			document.title=obj["title"];
			obj.retGridHeaderStore.load({});
	    }
	};
	obj.retGridHeaderStore_load=function(args)
	{
		ReConfigGridStore();
		obj.retGridPanelStore.load({});
	}
	obj.retGridPanelStore_load=function(args)
	{
		ShowAllAnOpListTable();
	}
	function ReConfigGridStore()
	{
		var readerArray = new Array();
		var count = obj.retGridHeaderStore.getCount();
		var headerCode="",headerDesc="";
		if(count<1)
		{
			alert("未配置显示项目,请先配置好显示项目再查询");
		}
		readerArray[0]={name: 'checked', mapping : 'checked'};
		readerArray[1]={name: 'displayId', mapping : 'displayId'};
		readerArray[2]={name: 'rowId', mapping : 'rowId'};
		var cols=0;
		for(var i=0;i<count;i++)
		{
			var record=obj.retGridHeaderStore.getAt(i);
			cols++;
			readerArray[2+cols]={name: record.get('code'), mapping : record.get('code')};
		}
		
		obj.retGridPanelStore.reader = new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'displayId'
			},
			readerArray
		);
		var newGridPanelStore = new Ext.data.Store({
			proxy: obj.retGridPanelStoreProxy,
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'displayId'
				},
				readerArray
			)
		});
		obj.retGridPanelStore.fields = newGridPanelStore.fields;
	}
	function ShowAllAnOpListTable()
	{
		var ifInIE = IsIEAgent();
		var cols=obj.retGridHeaderStore.getCount();//数据行数
		var theaderStr="";
		for(var i=0;i<cols;i++)
		{
			var colName = obj.retGridHeaderStore.getAt(i).get("desc");
			theaderStr=theaderStr+GenerateElement(colName,"td","");
		}
		theaderStr=GenerateElement(theaderStr,"tr","");
		theaderStr=GenerateElement(theaderStr,"thead","");
		var bodyStr="";

		theaderStr=theaderStr+GenerateElement("","tbody","anoplist");
		document.body.innerHTML = document.body.innerHTML+GenerateElement(theaderStr,"table","anoplisttb");
		
		var count=obj.retGridPanelStore.getCount();//数据行数
		for (var i=0;i<count;i++)
		{
			var trowStr="";
			var record=obj.retGridPanelStore.getAt(i);
			for(var j=0;j<cols;j++)
			{
				var colCode = obj.retGridHeaderStore.getAt(j).get("code");
				var cellValue = record.get(colCode);
				if(obj["showZero"] && cellValue=="") cellValue="0";
				trowStr = trowStr+ GenerateElement(cellValue,"td","");
			}
			trowStr=GenerateElement(trowStr,"tr","");
			//if(ifInIE) bodyStr = bodyStr + trowStr;
			//else 
			AddElement(trowStr,"anoplist");
		}
		
		//if(ifInIE) AddElement(GenerateElement(theaderStr+bodyStr,"table","anoplisttb"),document.body);
	}
	function AddElement(element,objContainerId){
		try
		{
			Ext.DomHelper.append(objContainerId,element);
		}
		catch(ex)
		{
		}
	}
	function GenerateElement(eleValue,eleType,eleId){
		if(eleId!="") return "<"+eleType+" id=\""+eleId+"\">"+eleValue+"</"+eleType+">";
		return "<"+eleType+">"+eleValue+"</"+eleType+">";
	}
	function IsIEAgent()
	{
		var userAgent = window.navigator.userAgent.toLowerCase(); 
		return /(msie)\D+(\d[\d.]*)/.test(userAgent);
	}
}