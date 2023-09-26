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
			//Updata By NiuCaicai 2011-07-20 FixBug:120 ʵʩ����--�ٴ�·�����-סԺ����-����ռ�ٷֱ�����ʱ����ȷ
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
			,{header: '��Ŀ', width: 120, dataIndex: 'FeeType', sortable: true}
			,{header: '����', width: 80, dataIndex: 'Number', sortable: true}
			,{header: '�ٷֱ�', width: 80, dataIndex: 'Percent', sortable: true}
		]});
	obj.chartFee = {
						
            store: obj.chartStore,
            region : "center",
            xtype: 'piechart',
            dataField: 'Number',
            categoryField: 'FeeType',
            title : '���ù���ͼ',
            //extra styles get applied to the chart defaults
            extraStyle:
            {
                legend:
                {
                    //display: 'bottom',
					//Update By NiuCaicai 2011-8-3 FixBug:118   ʵʩ����--�ٴ�·�����-סԺ����-ͳ��ͼ�·�ͼ��˵����ʾ����ȫ
					display: 'right',
                    padding: 5,
                    font:
                    {
                        family: 'Tahoma',
                        size: 12
                    }
                },
				//Add By NiuCaicai 2011-8-3 FixBug:118   ʵʩ����--�ٴ�·�����-סԺ����-ͳ��ͼ�·�ͼ��˵����ʾ����ȫ
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
	//�¼��������
  obj.LoadEvent(arguments);
  return obj;
}

