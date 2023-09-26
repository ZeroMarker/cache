var objLeftPanel = null;

function LeftMaintainPane() {
    var obj = new Object();
	obj.gridOrderResultStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
					url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridOrderResultStore = new Ext.data.Store({
				proxy: obj.gridOrderResultStoreProxy,
				reader: new Ext.data.JsonReader({
					root: 'record',
					totalProperty: 'total',
					idProperty: 'Index'
				}, 
				[
					{name: 'checked', mapping : 'checked'}
					,{name: 'StepItem', mapping: 'StepItem'}
					,{name: 'ArcimID', mapping: 'ArcimID'}
					,{name: 'ArcimDesc', mapping: 'ArcimDesc'}
					,{name: 'IsComplete', mapping: 'IsComplete'}
					,{name: 'IsNumberCorrect', mapping: 'IsNumberCorrect'}
					,{name: 'Index', mapping: 'Index'}
					,{name: 'Qty', mapping: 'Qty'}
					,{name: 'StepItemID', mapping: 'StepItemID'}
				])
	});
	obj.gridOrderResultCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 35 });
	obj.gridOrderResult = new Ext.grid.GridPanel({
		id : 'gridOrderResult'
		,plugins : obj.gridOrderResultCheckCol
		,store : obj.gridOrderResultStore
		,buttonAlign : 'center'
		,title: 'ҽ�����'
		,tbar : [
			{
				text:"��������¼" ,
				icon : "../images/websys/report.gif",
				handler:function()
				{
					var objRec = ExtTool.GetGridSelectedData(obj.gridOrderResult);
					if(objRec == null)
					{
						ExtTool.alert("��ʾ", "��ѡ��һ�����ҽ����Ŀ!");
						return;							
					}
					var stepItemID = objRec.get("StepItemID");
					var pathID = document.getElementById("PathWayID").value;
					var objVarEdit = new InitwinCpwVarEdit(null, pathID, stepItemID);
					objVarEdit.winCpwVarEdit.show();
				}
			}
		]
		,columns: [
			new Ext.grid.RowNumberer()
			,obj.gridOrderResultCheckCol
			,{header: '��Ŀ', width: 180, dataIndex: 'StepItem', sortable: true}
			,{header: 'ҽ������', width: 220, dataIndex: 'ArcimDesc', sortable: true}
			,{header: '����', width: 80, dataIndex:'Qry', sortable: true}
			,{header: '��ʱ���', width: 80, dataIndex: 'IsComplete', sortable: true, 
					renderer: function(value)
					{
						if(value == 0)
							return "<img src='../images/websys/delete.gif' alt='δ���'/>";
						else
							return "<img src='../images/webemr/authorise.gif' alt='���'/>";
					}
				}
			,{header: '��������', width: 80, dataIndex: 'IsNumberCorrect', sortable: true,
					renderer : function(value)
					{
						var strRet = "";
						switch(value)
						{
							case "more":
								strRet = "<img src='../images/webemr/ArrearsWarning.gif' alt='̫����'/>";
								break;
							case "less":
								strRet = "<img src='../images/webemr/ArrearsFull.gif' alt='̫����'/>";
								break;
							case "not complete":
								strRet = "<img src='../images/websys/delete.gif' alt='δ���'/>";
								break;
							case "ok":
								strRet = "<img src='../images/webemr/authorise.gif' alt='���'/>";
								break;									
							default:
								strRet = "<B>" + value + "</B>";
								break;
						}
						return strRet;
					}
			}
		]
		,viewConfig : {
			forceFit : true
		}
	});
	
	obj.gridVarListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.gridVarListStore = new Ext.data.Store({
		proxy: obj.gridVarListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'CPWVDate', mapping: 'CPWVDate'}
			,{name: 'CPWVTime', mapping: 'CPWVTime'}
			,{name: 'CPWVCategory', mapping: 'CPWVCategory'}
			,{name: 'CPWVReason', mapping: 'CPWVReason'}
			,{name: 'CPWVEpisode', mapping: 'CPWVEpisode'}
			,{name: 'CPWVEpStep', mapping: 'CPWVEpStep'}
			,{name: 'CPWVNote', mapping: 'CPWVNote'}
			,{name: 'CPWVUser', mapping: 'CPWVUser'}
		])
	});
	obj.gridVarListCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridVarList = new Ext.grid.GridPanel({
		id : 'gridVarList'
		,store : obj.gridVarListStore
		,buttonAlign : 'center'
		,region : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '��¼����', width: 100, dataIndex: 'CPWVDate', sortable: true}
			,{header: '��¼ʱ��', width: 100, dataIndex: 'CPWVTime', sortable: true}
			,{header: '���', width: 100, dataIndex: 'CPWVCategory', sortable: true}
			,{header: 'ԭ��', width: 100, dataIndex: 'CPWVReason', sortable: true}
			,{header: '�׶�', width: 100, dataIndex: 'CPWVEpisode', sortable: true}
			,{header: '����', width: 100, dataIndex: 'CPWVEpStep', sortable: true}
			,{header: '��ע˵��', width: 100, dataIndex: 'CPWVNote', sortable: true}
			,{header: '��¼��', width: 100, dataIndex: 'CPWVUser', sortable: true}
		]
		,viewConfig : {
			forceFit : true
		}
	});
	obj.pnVar = new Ext.Panel({
		id : 'pnVar'
		,title : '�����¼'		
		,layout : 'border'
		,items:[
			//obj.pnVarCondition,
			obj.gridVarList
		]
	});
	//-------------------------�����¼ End---------------------------
  
	//-------------------------ҽ����Ϣ Start---------------------------
  	obj.cboInPathDayStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboInPathDayStore = new Ext.data.Store({
		proxy: obj.cboInPathDayStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.cboInPathDay = new Ext.form.ComboBox({
		id : 'cboInPathDay'
		,store : obj.cboInPathDayStore
		,minChars : 1
		,displayField : 'Desc'
		,fieldLabel : '�뾶����'
		,valueField : 'ID'
		,triggerAction : 'all'
});
	obj.pnOrderListCondition = new Ext.Panel({
		id : 'pnOrderListCondition'
		,buttonAlign : 'center'
		,region : 'north'
		,layout : 'form'
		,height : 30
		,items:[
			obj.cboInPathDay
		]
	});
	obj.gridOrderStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.gridOrderStore = new Ext.data.Store({
		proxy: obj.gridOrderStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'OrderItemID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'OrderItemID', mapping: 'OrderItemID'}
			,{name: 'ArcimID', mapping: 'ArcimID'}
			,{name: 'OrderType', mapping: 'OrderType'}
			,{name: 'ArcimDesc', mapping: 'ArcimDesc'}
			,{name: 'Number', mapping: 'Number'}
			,{name: 'Unit', mapping: 'Unit'}
			,{name: 'OrderStatus', mapping: 'OrderStatus'}
			,{name: 'ExecTime', mapping: 'ExecTime'}
		])
	});
	obj.gridOrderCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridOrder = new Ext.grid.GridPanel({
		id : 'gridOrder'
		,store : obj.gridOrderStore
		,buttonAlign : 'center'
		,region : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: 'ҽ������', width: 80, dataIndex: 'OrderType', sortable: true}
			,{header: 'ҽ������', width: 130, dataIndex: 'ArcimDesc', sortable: true}
			,{header: '����', width: 60, dataIndex: 'Number', sortable: true}
			,{header: '��λ', width: 60, dataIndex: 'Unit', sortable: true}
			,{header: '״̬', width: 60, dataIndex: 'OrderStatus', sortable: true}
			,{header: 'ִ��ʱ��', width: 100, dataIndex: 'ExecTime', sortable: true}
		]
		,viewConfig : {
			forceFit : true
		}
	});
	obj.pnOrderList = new Ext.Panel({
		id : 'pnOrderList'
		,title : 'ҽ����Ϣ'
		,buttonAlign : 'center'
		,frame : true
		,layout : 'border'
		,items:[
			obj.pnOrderListCondition
			,obj.gridOrder
		]
	});
	
	obj.cboInPathDayStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCPW.MR.CtrModulePatSummary';
		param.QueryName = 'QueryCPDays';
		param.Arg1 = document.getElementById("PathWayID").value;
		param.ArgCnt = 1;
	});
	//-------------------------ҽ����Ϣ End---------------------------
	
	

	
    obj.tabStepItem = new Ext.TabPanel({
		id : "tabStep"
		, region: "center"
		, activeTab: 0
		, items:
		[
			obj.gridOrderResult,
			obj.pnVar,
			obj.pnOrderList
		]
    })
    
	obj.pn = new Ext.Panel({
	    width: "25%"
	    ,autoScroll : true
		, title : "�ٴ�·�����"
        , region: "west"
        , layout: "border"
        , items:
        [
            //obj.objContentTree,
            obj.tabStepItem
        ]
	});
        
	objLeftPanel = obj;
	
	
	
	obj.DisplayVarianceList = function()
	{
		var objParam = new Object();
		objParam.ClassName = 'web.DHCCPW.MR.CtrVarianceQry';
		objParam.QueryName = 'QueryByStepID';
		objParam.Arg1 = document.getElementById("PathWayID").value;
		objParam.Arg2 = ""; //Modified By LiYang 2011-04-05  ��Ϊȡ������������Ҫֱ����ʾ���б����¼
		objParam.ArgCnt = 2;
		obj.gridVarListStore.load({
				params : objParam
		});
	}
	
	obj.cboInPathDay.on("select", 
		function()
		{
				var objParam = new Object();
				objParam.ClassName = 'web.DHCCPW.MR.CtrOrderQry';
				objParam.QueryName = 'QueryOrderItemByDate';
				objParam.Arg1 = document.getElementById("PathWayID").value;
				objParam.Arg2 = obj.cboInPathDay.getValue();
				objParam.Arg3 = obj.cboInPathDay.getValue();
				objParam.ArgCnt = 3;
				obj.gridOrderStore.load(
					{
						params : objParam
					}
				);			
		}
	);
	
	//Modified By LiYang 2011-04-05 ֱ����ʾ��ά��ؽ����
	var objParam = new Object();
	objParam.ClassName = 'web.DHCCPW.MR.CtrControlDetail';
	objParam.QueryName = 'QryCPWCtlOrderDetail';
	objParam.Arg1 = document.getElementById("Adm").value;
	objParam.Arg2 = document.getElementById("PathWayID").value;
	objParam.ArgCnt = 2;
	obj.gridOrderResultStore.load(
		{
			params : objParam
		}
	);
	//ֱ����ʾ�����¼�б�
	obj.DisplayVarianceList();
	
	return obj.pn;
}