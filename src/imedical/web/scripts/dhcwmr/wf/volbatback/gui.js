function VBB_InitVolumeSelect(storeParam,gridId){
	var obj = new Object();
	obj.MrTypeID = storeParam.Arg2;  //病案类型
	obj.SysOpera = 'RC';  //病案回收对应系统操作
	obj.ParrefGridId = gridId;
	
	obj.VBB_chkSelectAll = Common_Checkbox("VBB_chkSelectAll","全选");
	
	obj.VBB_btnSave = new Ext.Button({
		id : 'VBB_btnSave'
		,iconCls : 'icon-update'
		,width: 60
		,text : '确认回收'
	});
	obj.VBB_btnCancel = new Ext.Button({
		id : 'VBB_btnCancel'
		,iconCls : 'icon-close'
		,width: 60
		,text : '关闭'
	});
	
	obj.VBB_GridVolumeSelectStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.VBB_GridVolumeSelectStore = new Ext.data.Store({
		proxy: obj.VBB_GridVolumeSelectStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'VolID'
		},[
			{name: 'IsChecked', mapping : 'IsChecked'}
			,{name: 'VolID', mapping : 'VolID'}
			,{name: 'EpisodeID', mapping : 'EpisodeID'}
			,{name: 'PatientID', mapping : 'PatientID'}
			,{name: 'MrNo', mapping : 'MrNo'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'PapmiNo', mapping: 'PapmiNo'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'Age', mapping: 'Age'}
			,{name: 'AdmLocDesc', mapping: 'AdmLocDesc'}
			,{name: 'AdmWardDesc', mapping: 'AdmWardDesc'}
			,{name: 'AdmDate', mapping: 'AdmDate'}
			,{name: 'DischDate', mapping: 'DischDate'}
			,{name: 'BackDate', mapping: 'BackDate'}
			,{name: 'StepDesc', mapping: 'StepDesc'}
			,{name: 'StatusDesc', mapping: 'StatusDesc'}
			,{name: 'BackDays', mapping: 'BackDays'}
		])
	});
	obj.VBB_GridVolumeSelect = new Ext.grid.GridPanel({
		id : 'VBB_GridVolumeSelect'
		,store : obj.VBB_GridVolumeSelectStore
		,columnLines : true
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,region : 'center'
		,height : 310
		,loadMask : true
		,tbar : [
			'-',obj.VBB_chkSelectAll,"全选",'-',obj.VBB_btnSave,'-',obj.VBB_btnCancel,'-'
		]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '标记', width: 50, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IsChecked = rd.get("IsChecked");
					if (IsChecked == '1') {
						return "<IMG src='../scripts/dhcwmr/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhcwmr/img/unchecked.gif'>";
					}
				}
			}
			,{header: '姓名', width: 80, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '病案号', width: 80, dataIndex: 'MrNo', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '性别', width: 50, dataIndex: 'Sex', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '年龄', width: 50, dataIndex: 'Age', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '当前状态', width: 60, dataIndex: 'StatusDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '科室', width: 150, dataIndex: 'AdmLocDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '病区', width: 150, dataIndex: 'AdmWardDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '出院日期', width: 80, dataIndex: 'DischDate', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true,
			getRowClass: function(record, index) {
				if (record.get('IsChecked') == '1') {
					return 'x-grid-record-red';
				} else{
					return '';
				}
			}
		}
    });
	
	obj.VBB_WinVolumeSelect = new Ext.Window({
		id : 'VBB_WinVolumeSelect'
		,height : 600
		,width : 800
		,modal : true
		,title : '批量回收病案'
		,closable : false
		,layout : 'border'
		,buttonAlign : 'center'
		,items:[
			obj.VBB_GridVolumeSelect
		]
	});
	
	obj.VBB_GridVolumeSelectStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.VolDischQry';
		param.QueryName = 'QryVolumeList';
		param.Arg1 = storeParam.Arg1;  //HospitalIDs
		param.Arg2 = storeParam.Arg2;  //MrTypeID
		param.Arg3 = storeParam.Arg3;  //DateFrom
		param.Arg4 = storeParam.Arg4;  //DateTo
		param.Arg5 = storeParam.Arg5;  //LocGroup
		param.Arg6 = storeParam.Arg6;  //LocID
		param.Arg7 = storeParam.Arg7;  //BackDays
		param.ArgCnt = storeParam.ArgCnt;
	});
	
	VBB_InitVolumeSelectEvent(obj);
	obj.VBB_LoadEvent(arguments);
	return obj;
}

