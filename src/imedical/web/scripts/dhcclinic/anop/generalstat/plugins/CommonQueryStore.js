function InitCommonQueryStore(obj)
{
	obj.refCommonQueryStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.refCommonQueryStore = new Ext.data.Store({
		proxy: obj.refCommonQueryStoreProxy,
		autoLoad : true,
		reader:new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'value'
			},
			[
				{name: 'checked', mapping : 'checked'}
				,{name: 'value', mapping : 'value'}
				,{name: 'desc', mapping: 'desc'}
			]
		)
	});
	obj.rowParam = new Object();
	obj.refCommonQueryStoreProxy.on('beforeload',function(objProxy, param){
		for(var i in obj.rowParam)
		{
			param[i]=obj.rowParam[i];
		}
	});

	obj.ResetRefCommonStore = function(index,thisValue)
	{
		var result=false;
		try
		{
			var record=obj.ANCInquiryItemStore.getAt(index);
			obj.refCommonQueryStore.removeAll();
			if(record.get("valueOption"))
			{
				obj.refCommonQueryStore.reader = new Ext.data.JsonReader({
					root: 'record',
					totalProperty: 'total',
					idProperty: 'value'
					},
					[
						{name: 'checked', mapping : 'checked'}
						,{name: 'value', mapping : 'value'}
						,{name: 'desc', mapping: 'desc'}
					]
				);
				RefreshJsonStore(obj.refCommonQueryStore,record.get("valueOption"));
				result = true;
			}
			else if(record.get("query"))
			{
				var displayField=record.get("displayField");
				var valueField=record.get("valueField");
				var queryStr=record.get("query");
				SetStoreReaderField(displayField,valueField);
				SetQuery(queryStr,thisValue);
				obj.refCommonQueryStore.load({
					params : {
						start:0
						,limit:obj.pageSize
					}
				});
				result = true;
			}
		}
		catch(ex)
		{
			alert("参考值选项数据配置错误,请重新配置此项");
			obj.refCommonQueryStore.removeAll();
			return false;
		}
		return result;
	}

	function SetStoreReaderField(displayfield,valuefield)
	{
		var readerArray = new Array();
		readerArray[0]={name: 'checked', mapping : 'checked'};
		readerArray[1]={name: 'desc', mapping : displayfield};
		readerArray[2]={name: 'value', mapping : valuefield};
		obj.refCommonQueryStore.reader = new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: valuefield
			},
			readerArray
		);
	}
	function SetQuery(query_json_str,thisValue)
	{
		var query_json=eval("("+query_json_str+")");
		var args=new Array();
		var fieldvalue,classname,queryname;
		for(var field in query_json)
		{
			if(query_json.hasOwnProperty(field) && field!='prototype')
			{
                fieldvalue = query_json[field];
				switch(field)
				{
					case "ClassName":
						classname=fieldvalue;
					break;
					case "QueryName":
						queryname=fieldvalue;
					break;
					case "Args":
						args=fieldvalue;
					break;
					default:
					break;
				}
            }
		}
		SetQueryParam(classname,queryname,args,thisValue);
	}

	function SetQueryParam(ClassName,QueryName,Args,thisValue)
	{
		obj.rowParam.ClassName=ClassName;
		obj.rowParam.QueryName=QueryName;
		for(var i=0;i<Args.length;i++)
		{
			obj.rowParam["Arg"+(i+1)]=Args[i];
			if(Args[i]=="this") obj.rowParam["Arg"+(i+1)]=thisValue;
		}
		obj.rowParam.ArgCnt=Args.length;
	}

	function RefreshJsonStore(jsonstore,data_json_str)
	{
		var data_json=eval('('+data_json_str+')');
		jsonstore.removeAll();
		jsonstore.loadData(data_json,true);
	}

}