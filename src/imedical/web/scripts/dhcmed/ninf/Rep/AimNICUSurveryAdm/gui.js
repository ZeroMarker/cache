
function InitICUStrAdmSubWindow(SurveryDate,LocID){
	var obj = new Object();
	obj.ICUStrAdmSubGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.ICUStrAdmSubGridPanelStore = new Ext.data.GroupingStore({
		proxy: obj.ICUStrAdmSubGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowID'
		}, 
		[
			{name: 'RowID', mapping : 'RowID'}
			,{name: 'LocID', mapping : 'LocID'}
			,{name: 'LocDesc', mapping: 'LocDesc'}
			,{name: 'AISDate', mapping: 'AISDate'}
			,{name: 'IsNew', mapping: 'IsNew'}
			,{name: 'PatientID', mapping: 'PatientID'}
			,{name: 'Paadm', mapping: 'Paadm'}
			,{name: 'PatientName', mapping: 'PatientName'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'Age', mapping: 'Age'}
		])
		,sortInfo:{field: 'RowID', direction: "ASC"}
		,groupField:'IsNew'
	});
	obj.ICUStrAdmSubGridPanel = new Ext.grid.GridPanel({
		id : 'ICUStrAdmSubGridPanel'
		,store : obj.ICUStrAdmSubGridPanelStore
		,region : 'center'
		,buttonAlign : 'center'
		,columnLines : true
		,loadMask : true
		//,viewConfig : {forceFit:true}
		,frame : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header : '科室ID', width : 50, dataIndex : 'LocID', sortable: false, menuDisabled:true, align:'center' }
			,{header : '科室', width : 100, dataIndex : 'LocDesc', sortable: false, menuDisabled:true, align:'center' }
			//,{header : '日期', width : 60, dataIndex : 'AISDate', sortable: false, menuDisabled:true, align:'center' }
			,{header: '属性', width: 150, dataIndex: 'IsNew', sortable: true, menuDisabled:true, hidden:true, align: 'center'}
			,{header : 'PatientID', width : 80, dataIndex : 'PatientID', sortable: false, menuDisabled:true, align:'center' }
			,{header : 'Paadm', width : 60, dataIndex : 'Paadm', sortable: false, menuDisabled:true, align:'center' }
			,{header : '患者姓名', width : 60, dataIndex : 'PatientName', sortable: false, menuDisabled:true, align:'center' }
			,{header : '性别', width : 60, dataIndex : 'Sex', sortable: false, menuDisabled:true, align:'center' }
			,{header : '年龄', width : 60, dataIndex : 'Age', sortable: false, menuDisabled:true, align:'center' }
		]
		,view: new Ext.grid.GroupingView({
			forceFit:true,
			groupTextTpl: '{[values.rs[0].get("IsNew")]}：{[values.rs.length]}条记录'
			,groupByText:'依本列分组'
		})
	});
	obj.ICUStrAdmSubWindow = new Ext.Window({
		id : 'ICUStrAdmSubWindow'
		,collapsed : true
		,buttonAlign : 'center'
		,maximized : false
		,resizable : false
		,title : '就诊号列表'
		,layout : 'border'
		,height : 500
		,width : 800
		,modal: true
		,items:[
			obj.ICUStrAdmSubGridPanel
		]
	});
	obj.ICUStrAdmSubGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.NINFService.Rep.AimNICUSurveryAdm';
			param.QueryName = 'QryNICUAdmStr';
			param.Arg1 = SurveryDate;
			param.Arg2 = LocID;
			param.ArgCnt = 2;
	});
	InitICUStrAdmSubWindowEvent(obj);
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}

