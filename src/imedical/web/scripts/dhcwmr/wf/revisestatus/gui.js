var objScreen = new Object();
function InitReviseStatus(){
    var obj = objScreen;
	
	obj.btnRevise = new Ext.Button({
		id : 'btnRevise'
		,icon: '../scripts/dhcwmr/img/update.gif'
		,text : '<span style="font-weight:bold;color:#457294;font-size:14;">修正</span>'
		,width : 90
	});
	obj.btnClose = new Ext.Button({
		id : 'btnClose'
		,icon: '../scripts/dhcwmr/img/remove.png'
		,text : '<span style="font-weight:bold;color:#457294;font-size:14;">关闭</span>'
		,width : 80
	});
	
	obj.VolStatusGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.VolStatusGridStore = new Ext.data.Store({
		proxy: obj.VolStatusGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'StatusID'
		},[
			{name: 'StatusID', mapping : 'StatusID'}
			,{name: 'ItemID', mapping : 'ItemID'}
			,{name: 'ItemDesc', mapping : 'ItemDesc'}
			,{name: 'UserID', mapping : 'UserID'}
			,{name: 'UserDesc', mapping : 'UserDesc'}
			,{name: 'ActDate', mapping : 'ActDate'}
			,{name: 'ActTime', mapping : 'ActTime'}
			,{name: 'ToUserID', mapping : 'ToUserID'}
			,{name: 'ToUserDesc', mapping : 'ToUserDesc'}
			,{name: 'BatchNumber', mapping : 'BatchNumber'}
			,{name: 'UpdoOpera', mapping : 'UpdoOpera'}
			,{name: 'UpdoOperaDesc', mapping : 'UpdoOperaDesc'}
			,{name: 'UpdoDate', mapping : 'UpdoDate'}
			,{name: 'UpdoTime', mapping : 'UpdoTime'}
			,{name: 'UpdoUserID', mapping : 'UpdoUserID'}
			,{name: 'UpdoUserDesc', mapping : 'UpdoUserDesc'}
			,{name: 'UpdoReason', mapping : 'UpdoReason'}
			,{name: 'Resume', mapping : 'Resume'}
			,{name: 'RequestID', mapping : 'RequestID'}
			,{name: 'ReqBatchNumber', mapping : 'ReqBatchNumber'}
			,{name: 'LnkOperaID', mapping : 'LnkOperaID'}
		])
	});
	obj.VolStatusGrid = new Ext.grid.GridPanel({
		id : 'VolStatusGrid'
		,store : obj.VolStatusGridStore
		,columnLines : true
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,region : 'center'
		,height : 310
		,loadMask : true
		,tbar : [{id:'msgVolStatusGrid',text:'修正病案卷状态',style:'font-weight:bold;font-size:16px;',xtype:'label'},
		'-',obj.btnRevise,'-',obj.btnClose,'-']
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '状态', width: 80, dataIndex: 'ItemDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '操作人', width: 60, dataIndex: 'UserDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '操作日期', width: 80, dataIndex: 'ActDate', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '操作时间', width: 60, dataIndex: 'ActTime', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '接收人<br>签名', width: 60, dataIndex: 'ToUserDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '操作批次', width: 80, dataIndex: 'BatchNumber', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '修订<br>状态', width: 40, dataIndex: 'UpdoOperaDesc', sortable: false, menuDisabled:true, align : 'center'}
			/* update by zf 20150403 先去掉病案状态回置操作
			,{header: '修正<br>操作', width: 40, dataIndex: '', sortable: false, menuDisabled:true, align: 'center'
				,renderer : function(v, m, rd, r, c, s){
					var StatusID = rd.get("StatusID");
					var UpdoOpera = rd.get("UpdoOpera");
					var ItemDesc = rd.get("ItemDesc");
					if (ItemDesc == '初始状态') return '';
					if (UpdoOpera == 'B') {
						return "<a href='#' onclick='objScreen.ReviseUpdateStatus(\"" + StatusID + "\",\"\");'>撤销</a>";
					} else if (UpdoOpera == '') {
						return "<a href='#' onclick='objScreen.ReviseUpdateStatus(\"" + StatusID + "\",\"B\");'>回置</a>";
					} else {
						return "";
					}
				}
			}*/
			,{header: '修订人', width: 80, dataIndex: 'UpdoUserDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '修订日期', width: 80, dataIndex: 'UpdoDate', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '修订时间', width: 50, dataIndex: 'UpdoTime', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '修订原因', width: 80, dataIndex: 'UpdoReason', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
    });
	
    obj.MainViewPort=new Ext.Viewport({
        id:'MainViewPortId'
        ,layout : 'fit'
		,items:[
			obj.VolStatusGrid
		]
    });
	
	obj.VolStatusGridStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.VolStatusQry';
		param.QueryName = 'QryStatusList';
		param.Arg1 = VolumeID;
		param.ArgCnt = 1;
	});
	
	InitReviseStatusEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}