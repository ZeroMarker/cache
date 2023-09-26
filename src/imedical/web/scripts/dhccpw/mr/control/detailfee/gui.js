function InitviewScreen(AdmID){
	var obj = new Object();
	obj.gridResultStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.gridResultStore = new Ext.data.Store({
		proxy: obj.gridResultStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'FeeType'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'FeeType', mapping: 'FeeType'}
			,{name: 'Number', mapping: 'Number', type: 'float'}
			//Updata By NiuCaicai 2011-07-20 FixBug:120 实施管理--临床路径监控-住院费用-按所占百分比排序时不正确
			,{name: 'Percent' ,sortType: Ext.data.SortTypes.asFloat , mapping: 'Percent'}
		])
	});
	
	obj.chartStore = new Ext.data.Store({
		proxy: obj.gridResultStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'FeeType'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'FeeType', mapping: 'FeeType'}
			,{name: 'Number', mapping: 'Number', type: 'float'}
			,{name: 'Percent', mapping: 'Percent'}
		])
	});	
	
	obj.gridResultCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridResult = new Ext.grid.GridPanel({
		id : 'gridResult'
		,region : "west"
		,width : 300
		//,height : 500
		,store : obj.gridResultStore
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '项目', width: 120, dataIndex: 'FeeType', sortable: true}
			,{header: '费用', width: 80, dataIndex: 'Number', sortable: true}
			,{header: '百分比', width: 80, dataIndex: 'Percent', sortable: true}
		]});
	obj.chartFee = {
						
            store: obj.chartStore,
            region : "center",
            xtype: 'piechart',
            dataField: 'Number',
            categoryField: 'FeeType',
            title : '费用构成图',
            //extra styles get applied to the chart defaults
            extraStyle:
            {
                legend:
                {
                    //display: 'bottom',
					//Update By NiuCaicai 2011-8-3 FixBug:118   实施管理--临床路径监控-住院费用-统计图下方图例说明显示不完全
					display: 'right',
                    padding: 5,
                    font:
                    {
                        family: 'Tahoma',
                        size: 12
                    }
                },
				//Add By NiuCaicai 2011-8-3 FixBug:118   实施管理--临床路径监控-住院费用-统计图下方图例说明显示不完全
				border:
				{
					color:'ffffff',
					size:65
				}
            }
        };
	obj.pnScreen = new Ext.Panel({
		id : 'pnScreen'
		,buttonAlign : 'center'
		,frame : true
		,layout : 'border'
		,items:[
			obj.gridResult,
			obj.chartFee
		]
	});
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'fit'
		,items:[
			obj.pnScreen
		]
	});
	obj.gridResultStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.CtrModuleFeeControl';
			param.QueryName = 'QueryFee';
			param.Arg1 = AdmID;
			param.ArgCnt = 1;
	});
	obj.gridResultStore.load({});
	obj.chartStore.load({});
	InitviewScreenEvent(obj);
	//事件处理代码
  obj.LoadEvent(arguments);
  return obj;
}

