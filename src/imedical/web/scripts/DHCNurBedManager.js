var btnQuery = new Ext.Button({
	id: 'btnQuery',
	fieldLabel: ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		,
	width: 60,
	iconCls: 'icon-find',
	text: '查询',
	margins: {
		top: 0,
		right: 0,
		bottom: 0,
		left: 100
	}

});
var gridCurwardbedStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
	url: ExtToolSetting.RunQueryPageURL
}));
var gridCurwardbedStore = new Ext.data.Store({
	id: 'gridCurwardbedStore',
	proxy: gridCurwardbedStoreProxy,
	reader: new Ext.data.JsonReader({
		root: 'record',
		totalProperty: 'total',
		idProperty: 'IPAppID'
	}, [{
		name: 'BedId',
		mapping: 'BedId'
	}, {
		name: 'BedCode',
		mapping: 'BedCode'
	}, {
		name: 'BedStatus',
		mapping: 'BedStatus'
	}, {
		name: 'Bedlatertime',
		mapping: 'Bedlatertime'
	}, {
		name: 'operaUser',
		mapping: 'operaUser'
	}, {
		name: 'Appchangebed',
		mapping: 'Appchangebed'
	}, {
		name: 'BedBill',
		mapping: 'BedBill'
	}, {
		name: 'PatName',
		mapping: 'PatName'
	}, {
		name: 'PatSex',
		mapping: 'PatSex'
	}, {
		name: 'PatAge',
		mapping: 'PatAge'
	}, {
		name: 'BedOwn',
		mapping: 'BedOwn'
	}, {
		name: 'RegNo',
		mapping: 'RegNo'
	}, {
		name: 'EpisodeID',
		mapping: 'EpisodeID'
	}, {
		name: 'IPDate',
		mapping: 'IPDate'
	}, {
		name: 'Patward',
		mapping: 'Patward'
	}, {
		name: 'WardID',
		mapping: 'WardID'
	}])
});
var gridCurwardbed = new Ext.grid.GridPanel({
	id: 'gridCurwardbed',
	store: gridCurwardbedStore,
	region: 'center',
	layout: 'fit',
	buttonAlign: 'center',
	autoFill: true,
	loadMask: {
		msg: '正在读取数据,请稍后...'
	} //一个 Ext.LoadMask 配置，或者为true以便在加载时遮罩grid。 默认为 false .
	//,plugins: obj.expCtrlDetail //一个对象或者一个对象数组，为组件提供特殊的功能。 对一个合法的插件唯一的要求是它含有一个init()方法， 能接收一个Ext.Component型的参数。当组件被创建时，如果有可用的插件，组件将会调用每个插件的init方法，并将自身的引用作为方法参数传递给它。然后，每个插件就可以调用方法或者响应组件上的事件，就像需要的那样提供自己的功能。 
	,
	columns: [
		/*new Ext.grid.RowNumberer({header:"床号"	,width:60})*/
		{
			header: '床位id',
			width: 30,
			dataIndex: 'BedId',
			sortable: true
		}, {
			header: '床位号',
			width: 100,
			dataIndex: 'BedCode',
			sortable: true
		}, {
			header: '病人姓名',
			width: 100,
			dataIndex: 'PatName',
			sortable: true
		}, {
			header: '床位状态',
			width: 100,
			dataIndex: 'BedStatus',
			sortable: true
		}, {
			header: '预空时间',
			width: 100,
			dataIndex: 'Bedlatertime',
			sortable: true
		} //床位计划空的时间
		, {
			header: '操作人',
			width: 100,
			dataIndex: 'operaUser',
			sortable: true
		} //操作人
		, {
			header: '申请床位',
			width: 100,
			dataIndex: 'ApplyBed',
			sortable: true
		}, {
			header: '申请状态',
			width: 100,
			dataIndex: 'ApplyStatus',
			sortable: true
		}, {
			header: '申请人员',
			width: 100,
			dataIndex: 'ApplyUser',
			sortable: true
		}, {
			header: '审核状态',
			width: 100,
			dataIndex: 'AuditStatus',
			sortable: true
		}, {
			header: '审核人员',
			width: 100,
			dataIndex: 'AuditUser',
			sortable: true
		}, {
			header: '床位费用',
			width: 100,
			dataIndex: 'BedBill',
			sortable: true
		}, {
			header: '患者',
			width: 100,
			dataIndex: 'PatName',
			sortable: true
		}, {
			header: '性别',
			width: 100,
			dataIndex: 'PatSex',
			sortable: true
		}, {
			header: '年龄',
			width: 100,
			dataIndex: 'PatAge',
			sortable: true
		}, {
			header: '床位归属',
			width: 100,
			dataIndex: 'BedOwn',
			sortable: true
		}, {
			header: '登记号',
			width: 100,
			dataIndex: 'RegNo',
			sortable: true
		}, {
			header: '就诊号',
			width: 100,
			dataIndex: 'EpisodeID',
			sortable: true
		}, {
			header: '入院日期',
			width: 100,
			dataIndex: 'IPDate',
			sortable: true
		}, {
			header: '病区',
			width: 100,
			dataIndex: 'Patward',
			sortable: true
		}, {
			header: '病区id',
			width: 30,
			dataIndex: 'WardID',
			sortable: true
		}
	],
	bbar: new Ext.PagingToolbar({
		pageSize: 1000,
		store: gridCurwardbedStore,
		displayInfo: false,
		emptyMsg: '没有记录',
		layout: 'column'
	})
});
var ConditionPanel = new Ext.form.FormPanel({
	id: 'ConditionPanel',
	buttonAlign: 'center',
	labelAlign: 'center',
	labelWidth: 60,
	bodyBorder: 'padding:0 0 0 0',
	layout: 'column',
	region: 'north',
	frame: true,
	height: 40,
	items: [

		{
			buttonAlign: 'center',
			columnWidth: .2,
			layout: 'form',
			items: [btnQuery]
		}
	]
});
var pnScreen = new Ext.Panel({
	id: 'pnScreen',
	buttonAlign: 'center',
	frame: true,
	layout: 'border',
	items: [

		ConditionPanel,
		gridCurwardbed
	]
});

function Search_onclick() {
	var CTWardID = session['LOGON.CTLOCID'];
	var Onlybed = "";
	//alert(CTWardID)
	Ext.Ajax.request({
		url: 'DHCNurBedManagerequest.csp',
		params: {
			action: 'GetCurWardbed',
			CTWardID: CTWardID,
			Onlybed: Onlybed
		},
		success: function(result, request) {
			//var gridCurwardbedStore=Ext.getCmp('gridCurwardbedStore') ;
			gridCurwardbedStore.removeAll();
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.CurWardBedList != '') {

				var CurWardBedListArr = jsonData.CurWardBedList.split("!");
				//alert(CurWardBedListArr)
				for (var i = 0; i < CurWardBedListArr.length; i++) {
					//{name: 'checked', mapping : 'checked'}

					var BedId = CurWardBedListArr[i].split("^")[0];
					//alert(CurWardBedListArr[i])
					var BedCode = CurWardBedListArr[i].split("^")[1];
					var BedStatus = CurWardBedListArr[i].split("^")[2];
					var Bedlatertime = CurWardBedListArr[i].split("^")[3];
					var operaUser = CurWardBedListArr[i].split("^")[4];
					var ApplyBed = CurWardBedListArr[i].split("^")[19];
					var ApplyStatus = CurWardBedListArr[i].split("^")[5];


					var ApplyUser = CurWardBedListArr[i].split("^")[6];
					var AuditStatus = CurWardBedListArr[i].split("^")[7];
					var AuditUser = CurWardBedListArr[i].split("^")[8];

					var BedBill = CurWardBedListArr[i].split("^")[9];
					var PatName = CurWardBedListArr[i].split("^")[10];
					var PatSex = CurWardBedListArr[i].split("^")[11];
					var PatAge = CurWardBedListArr[i].split("^")[12];
					var BedOwn = CurWardBedListArr[i].split("^")[13];
					var RegNo = CurWardBedListArr[i].split("^")[14];
					var EpisodeID = CurWardBedListArr[i].split("^")[15];
					var IPDate = CurWardBedListArr[i].split("^")[16];
					var Patward = CurWardBedListArr[i].split("^")[17];
					var WardID = CurWardBedListArr[i].split("^")[18];

					var record = new Object();
					/*
						
					BedId,BedCode,BedStatus,Bedlatertime,operaUser,ApplyStatus,ApplyUser,AuditStatus,AuditUser,BedBill,PatName,PatSex,PatAge,BedOwn,RegNo,EpisodeID,IPDate,Patward,WardID
					*/
					record.BedId = BedId;
					record.BedCode = BedCode;
					record.BedStatus = BedStatus;
					record.Bedlatertime = Bedlatertime;
					record.operaUser = operaUser;
					record.ApplyBed = ApplyBed;
					record.ApplyStatus = ApplyStatus;
					record.ApplyUser = ApplyUser;
					record.AuditStatus = AuditStatus;
					record.AuditUser = AuditUser;
					record.BedBill = BedBill;
					record.PatName = PatName;
					record.PatSex = PatSex;
					record.PatAge = PatAge;
					record.BedOwn = BedOwn;
					record.RegNo = RegNo;
					record.EpisodeID = EpisodeID;
					record.IPDate = IPDate;
					record.Patward = Patward;
					record.WardID = WardID;
					var records = new Ext.data.Record(record);
					gridCurwardbedStore.add(records);
				}
			}
		},
		scope: this
	});

}


Ext.onReady(function() {
	new Ext.Viewport({
		id: 'viewScreen',
		frame: true,
		layout: 'fit',
		items: [
			pnScreen

		]
	});
	Ext.get('btnQuery').on("click", Search_onclick);
	Search_onclick();
})

var contextmenu = new Ext.menu.Menu({
		id: 'theContextMenu',
		items: [{
			text: '置出院时间',
			id: 'SetPatOuttime',
			handler: SetPatOuttime
		}, {
			text: '撤销置空',
			id: 'CancelSetPatOuttime',
			handler: CancelSetPatOuttime
		}, {
			text: '换床申请',
			id: 'ChangeBedApp',
			handler: ChangeBedApp
		}]
	})
	//grid=Ext.getCmp("gridResult");
gridCurwardbed.on("rowcontextmenu", function(grid1, rowIndex, e) {
	e.preventDefault();
	grid1.getSelectionModel().selectRow(rowIndex);
	contextmenu.showAt(e.getXY());
});

function SetPatOuttime() {

	var linenum = gridCurwardbed.getSelectionModel().lastActive; //获取行号
	var objresult = gridCurwardbed.store.data.items[linenum].data;
	var win = new Ext.Window({
		title: '置出院时间',
		layout: 'form',
		width: 350,
		height: 300,
		modal: true,
		labelAlign: 'right',
		items: [{
			xtype: 'datefield',
			fieldLabel: '日期',
			id: 'setdate',
			width: 160,
			format: 'Y-m-d',
			value: new Date().add(Date.DAY, +1),
			name: 'date'
		}, {
			xtype: 'field',
			fieldLabel: '床号',
			width: 160,
			value: objresult.BedCode,
			disabled: true
		}, {
			xtype: 'field',
			fieldLabel: '当前日期',
			width: 160,
			format: 'Y-m-d',
			value: new Date().toLocaleDateString(),
			disabled: true
		}, {
			xtype: 'button',
			id: 'AuthorizeBedlist',
			buttonAlign: 'center',
			text: '确认',
			height: 30,
			width: 80,
			style: 'margin:50 121', ////gg 这种方式调位置,没想到其他法子 
			handler: function(t, e) {
				//var ret=tkMakeServerCall("Nur.DHCBedManager","Setbedempty",objresult.BedId,setdate.value);
				var Userid = session['LOGON.USERID'];
				var Status = "V";
				var ret = tkMakeServerCall("Nur.DHCBedEmptyflag", "Save", objresult.BedId, setdate.value, Userid, Status);
				//alert(setdate.value)
				if (ret == "0") {
					alert("置空成功")
					Search_onclick();
				} else {
					alert(ret)
					return;
				}
				win.close();
				return;
			}
		}]
	})
	win.show();


}



function ChangeBedApp() {
	var ctloc = session['LOGON.CTLOCID'];
	var ApplyUser = session['LOGON.USERID'];
	var Hosid = session['LOGON.HOSPID'];
	var ret = tkMakeServerCall("Nur.DHCBedManager", "IfCanTransBed", Hosid, ctloc);
	if (ret === "0") {
		alert("请直接分配床位不用申请")
		return
	}

	//弹框的医嘱项
	var ResultBedStoreStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url: ExtToolSetting.RunQueryPageURL
	}));
	var ResultBedStore = new Ext.data.Store({
		proxy: ResultBedStoreStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'BedRowid'
		}, [{
			name: 'BedCode',
			mapping: 'BedCode'
		}, {
			name: 'BedRowid',
			mapping: 'BedRowid'
		}])
	});
	var ResultBed = new Ext.form.ComboBox({
		id: 'ResultBed',
		width: 160,
		store: ResultBedStore,
		minChars: 1,
		displayField: 'BedCode',
		fieldLabel: '床号',
		editable: true,
		triggerAction: 'all',
		anchor: '60%',
		valueField: 'BedRowid'


	});
	//弹框
	ResultBedStoreStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'Nur.DHCBedManager';
		param.QueryName = 'GetApplyedBed';
		param.Arg1 = ctloc;
		param.Arg2 = ResultBed.getRawValue();
		param.ArgCnt = 2;
	});
	var linenum = gridCurwardbed.getSelectionModel().lastActive; //获取行号
	var objresult = gridCurwardbed.store.data.items[linenum].data;
	var ApplyType = tkMakeServerCall("Nur.DHCBedManager", "GetAdmTransLocBed", objresult.EpisodeID); //申请类型 方法有问题

	var ApplyType = "M"; //写死的
	var ApplyStatus = "V";

	var win = new Ext.Window({
		title: '换床申请',
		layout: 'form',
		width: 350,
		height: 300,
		modal: true,
		labelAlign: 'right',
		items: [{
				xtype: 'field',
				fieldLabel: '当前床号',
				width: 160,
				value: objresult.BedCode,
				disabled: true
			}, {
				xtype: 'field',
				fieldLabel: '患者',
				width: 160,
				value: objresult.PatName,
				disabled: true
			},
			ResultBed, {
				xtype: 'button',
				id: 'ChangeApp',
				buttonAlign: 'center',
				text: '确认',
				height: 30,
				width: 80,
				style: 'margin:50 121', ////gg 这种方式调位置,没想到其他法子 
				handler: function(t, e) {
					var TransBedId = Ext.getCmp("ResultBed").value;
					if (TransBedId == undefined) {
						alert("请选择床号");
						win.close();
						return;
					}
					//var ret=tkMakeServerCall("User.DHCBedChangeApp","Save","",objresult.EpisodeID,"0");
					var ret = tkMakeServerCall("Nur.DHCBedApplyChange", "Save", TransBedId, objresult.EpisodeID, ApplyUser, ApplyStatus, ApplyType);
					//alert(setdate.value)
					if (ret == "0") {
						alert("申请成功")
						Search_onclick();
					} else {
						alert(ret)
						return;
					}
					win.close();
					return;
				}
			}
		]
	})
	win.show();
}

function CancelSetPatOuttime() {
	var linenum = gridCurwardbed.getSelectionModel().lastActive; //获取行号
	var objresult = gridCurwardbed.store.data.items[linenum].data;
	//alert(objresult.BedId)
	var Userid = session['LOGON.USERID'];
	var Status = "C";
	var ret = tkMakeServerCall("Nur.DHCBedEmptyflag", "Save", objresult.BedId, "", Userid, Status);
	if (ret == "0") {
		alert("成功")
		Search_onclick();
	} else {
		alert(ret)
		return;
	}
}