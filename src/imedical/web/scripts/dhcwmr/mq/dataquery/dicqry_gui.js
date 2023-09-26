function InitDicQry(){
	var obj = new Object();
	obj.className = arguments[0];
	obj.qryName = arguments[1];
	obj.displayCode = arguments[2];
	obj.displayDesc = arguments[3];
	obj.Args = arguments[4];
	obj.IsLoadAll= arguments[5];
	obj.ChooseValue= arguments[6];
	obj.txtAlias = Common_TextField("txtAlias","¼ìË÷¹Ø¼ü×Ö<font color='red'>*</font>");

	obj.gridItemDicStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridItemDicStore = new Ext.data.Store({
		proxy: obj.gridItemDicStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Code'
		},[
			{name: 'Code', mapping : obj.displayCode}
			,{name: 'Desc', mapping : obj.displayDesc}
		])
	});
	
	obj.gridItemDic = new Ext.grid.GridPanel({
		id : 'gridItemDic'
		,store : obj.gridItemDicStore
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '´úÂë', width: 40, dataIndex: 'Code', sortable: false, menuDisabled:true, align : 'center'}
			,{header: 'ÃèÊö', width: 70, dataIndex: 'Desc', sortable: false, menuDisabled:true, align : 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
    });

	obj.WinDicQry = new Ext.Window({
		id : 'WinDicQry'
		,height : 300
		,width : 400
		,modal : true
		,title : '×Öµä¼ìË÷'
		,closable : true
		,layout : 'border'
		,buttonAlign : 'center'
		,items:[
			{
				layout:'form'
				,region:'north'
				,height:35
				,frame:true
				,labelWidth : 60
				,items:[obj.txtAlias]
			}
			,obj.gridItemDic
		]
	});
	
	obj.gridItemDicStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = obj.className;
		param.QueryName = obj.qryName;
		var arrArg = obj.Args.split('^');
		var ArgCnt = arrArg.length;
		for (var n=0;n<ArgCnt ;n++ ){
			if (arrArg[n]=='txtAlias')
				var evl = 'param.Arg'+(n+1)+'=Common_GetValue("txtAlias");';
			else
				var evl = 'param.Arg'+(n+1)+'="'+arrArg[n]+'";';
			eval(evl);
		}
		param.ArgCnt = ArgCnt;
	});

	InitDicQryEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}