var cboWardStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
	url: ExtToolSetting.RunQueryPageURL
}));
var cboWardStore = new Ext.data.Store({
	proxy: cboWardStoreProxy,
	reader: new Ext.data.JsonReader({
		root: 'record',
		totalProperty: 'total',
		idProperty: 'CTLocID'
	}, [{
		name: 'checked',
		mapping: 'checked'
	}, {
		name: 'CTLocID',
		mapping: 'CTLocID'
	}, {
		name: 'CTLocCode',
		mapping: 'CTLocCode'
	}, {
		name: 'CTLocDesc',
		mapping: 'CTLocDesc'
	}])
});
var cboWard = new Ext.form.ComboBox({
	id: 'cboWard',
	width: 100,
	minChars: 1 //在自动完成和typeAhead 激活之前，用户必须输入的最少字符数
		,
	selectOnFocus: true //true 将会在获得焦点时理解选中表单项中所有存在的文本。 仅当editable = true 时应用(默认为false)。 
		,
	forceSelection: true //true 将会限定选择的值是列表中的值之一， false将会允许用户向表单项中设置任意值 (默认为false) 
		,
	store: cboWardStore,
	displayField: 'CTLocDesc',
	fieldLabel: '病区',
	editable: true //false将阻止用户直接向表单项中输入文本，表单项将仅仅响应 在触发按钮上进行鼠标点击然后设置值。(默认为true)。 
		,
	triggerAction: 'all' //当触发器被点击时需要执行的操作。
		,
	anchor: '100%',
	valueField: 'CTLocID'
});
///查询日期
var Searchdata = new Ext.form.DateField({
	xtype: 'datefield',
	fieldLabel: '日期',
	id: 'Searchdata',
	width: 50,
	format: 'Y-m-d',
	value: new Date(),
	name: 'date',
	anchor: '100%'
});


var btnQuery = new Ext.Button({
	id: 'btnQuery',
	fieldLabel: ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		,
	width: 90,
	iconCls: 'icon-find',
	text: '查询',
	margins: {
		top: 0,
		right: 0,
		bottom: 0,
		left: 100
	}

});
var btnAudit = new Ext.Button({
	id: 'btnAudit',
	fieldLabel: ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		,
	width: 90,
	text: '审核',
	margins: {
		top: 0,
		right: 0,
		bottom: 0,
		left: 100
	}

});
var btnRefuse = new Ext.Button({
	id: 'btnRefuse',
	fieldLabel: ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		,
	width: 90,
	text: '拒绝',
	margins: {
		top: 0,
		right: 0,
		bottom: 0,
		left: 100
	}

});
var comboData = [
	['V', '未审'],
	['E', '已审'],
	['F', '已完成'],
	['R', '已拒绝']
];
var Searchstore = new Ext.data.SimpleStore({
	fields: ['disvalue', 'distext'],
	data: comboData
});
//查询条件 
var Searchflag = new Ext.form.ComboBox({
	xtype: "combo",
	id: "Searchflag",
	width: 100,
	fieldLabel: "状态",
	mode: "local", //直接定义写成local
	triggerAction: 'all', //加载所有项
	editable: false,
	emptyText: "",
	store: Searchstore,
	displayField: 'distext', //
	valueField: 'disvalue',
	anchor: '100%'
});
///不用 了
var UnAudit = new Ext.form.Radio({
	boxLabel: '未审',
	xtype: 'radiogroup',
	name: 'rad',
	id: 'UnAudit',
	checked: true,
	value: '2',
	width: '100'
});
///不用了 ，用combobox
var Audit = new Ext.form.Radio({

	boxLabel: '已审',
	xtype: 'radiogroup',
	name: 'rad',
	id: 'Audit',
	value: '2',
	width: '100'

});
var gridbedauditStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
	url: ExtToolSetting.RunQueryPageURL
}));
var gridbedauditStore = new Ext.data.Store({
	id: 'gridbedauditStore',
	proxy: gridbedauditStoreProxy,
	reader: new Ext.data.JsonReader({
		root: 'record',
		totalProperty: 'total',
		idProperty: 'IPAppID'
	}, [

		{
			name: 'PatName',
			mapping: 'PatName'
		}, {
			name: 'ApplyBed',
			mapping: 'ApplyBed'
		}, {
			name: 'CurrentBed',
			mapping: 'CurrentBed'
		}, {
			name: 'ApplyType',
			mapping: 'ApplyType'
		}, {
			name: 'AppUser',
			mapping: 'AppUser'
		}, {
			name: 'Appdate',
			mapping: 'Appdate'
		}, {
			name: 'Apptime',
			mapping: 'Apptime'
		}, {
			name: 'AuditStatus',
			mapping: 'AuditStatus'
		}, {
			name: 'OldLoc',
			mapping: 'OldLoc'
		}, {
			name: 'PatSex',
			mapping: 'PatSex'
		}, {
			name: 'PatAge',
			mapping: 'PatAge'
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
		}, {
			name: 'Appid',
			mapping: 'Appid'
		}
	])
});

//这个方法不会用  
Ext.override(Ext.grid.CheckboxSelectionModel, {
	handleMouseDown: function(g, rowIndex, e) {
		if (e.button !== 0 || this.isLocked()) {
			return;
		}
		var view = this.grid.getView();
		if (e.shiftKey && !this.singleSelect && this.last !== false) {
			var last = this.last;
			this.selectRange(last, rowIndex, e.ctrlKey);
			this.last = last; // reset the last     
			view.focusRow(rowIndex);
		} else {
			var isSelected = this.isSelected(rowIndex);
			if (isSelected) {
				this.deselectRow(rowIndex);
			} else if (!isSelected || this.getCount() > 1) {
				this.selectRow(rowIndex, true);
				view.focusRow(rowIndex);
			}
		}
	}
});
var sm = new Ext.grid.CheckboxSelectionModel();

var gridbedaudit = new Ext.grid.GridPanel({
	id: 'gridbedaudit',
	store: gridbedauditStore,
	selModel: new Ext.grid.CheckboxSelectionModel(),
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
		//new Ext.grid.RowNumberer(),
		sm, {
			header: '病人姓名',
			width: 100,
			dataIndex: 'PatName',
			sortable: true
		}, {
			header: '申请床位',
			width: 100,
			dataIndex: 'ApplyBed',
			sortable: true
		}, {
			header: '当前床位',
			width: 100,
			dataIndex: 'CurrentBed',
			sortable: true
		}, {
			header: '申请类型',
			width: 100,
			dataIndex: 'ApplyType',
			sortable: true
		}, {
			header: '申请人员',
			width: 100,
			dataIndex: 'AppUser',
			sortable: true
		}, {
			header: '申请日期',
			width: 100,
			dataIndex: 'Appdate',
			sortable: true
		}, {
			header: '申请时间',
			width: 100,
			dataIndex: 'Apptime',
			sortable: true
		}, {
			header: '审核状态',
			width: 100,
			dataIndex: 'AuditStatus',
			sortable: true
		}, {
			header: '上一病区',
			width: 100,
			dataIndex: 'OldLoc',
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
			width: 100,
			dataIndex: 'WardID',
			sortable: true
		}, {
			header: 'id',
			width: 100,
			dataIndex: 'Appid',
			sortable: true
		}
	],
	bbar: new Ext.PagingToolbar({
		pageSize: 1000,
		store: gridbedauditStore,
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
			items: [Searchdata]
		}, {
			buttonAlign: 'center',
			columnWidth: .2,
			layout: 'form',
			items: [cboWard]
		}, {
			buttonAlign: 'center',
			columnWidth: .15,
			layout: 'form',
			items: [Searchflag]
		}
		/*,
		{buttonAlign : 'center',
		columnWidth : .1,
		layout : 'column',
		items : [UnAudit]
		}
		*/
		, {
			buttonAlign: 'center',
			columnWidth: .15,
			layout: 'form',
			items: [btnQuery]
		}, {
			buttonAlign: 'center',
			columnWidth: .15,
			layout: 'form',
			items: [btnAudit]
		}, {
			buttonAlign: 'center',
			columnWidth: .15,
			layout: 'form',
			items: [btnRefuse]
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
		gridbedaudit
	]
});

cboWardStoreProxy.on('beforeload', function(objProxy, param) {
	param.ClassName = 'Nur.DHCBedManager';
	param.QueryName = 'QryCTLoc';
	param.Arg1 = cboWard.getRawValue();
	param.Arg2 = 'W';
	param.Arg3 = "";
	param.Arg4 = "";
	param.ArgCnt = 4;
});

function Search_onclick() {

	var CTWardID = cboWard.getValue();
	Ext.Ajax.request({
		url: 'DHCNurBedManagerequest.csp',

		params: {
			action: 'GetAppPat',
			Searchdata: Searchdata.getValue(),
			CTWardID: CTWardID,
			UnAudit: Searchflag.getValue()
		},
		success: function(result, request) {
			gridbedauditStore.removeAll();
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.PatList != '') {

				var PatListArr = jsonData.PatList.split("!");
				//alert(PatListArr)
				for (var i = 0; i < PatListArr.length; i++) {
					//{name: 'checked', mapping : 'checked'}
					/*
						{name: 'PatName', mapping: 'PatName'}
			,{name: 'ApplyBed', mapping: 'ApplyBed'}
			,{name: 'CurrentBed', mapping: 'CurrentBed'}
			,{name: 'ApplyType', mapping: 'ApplyType'}
			,{name: 'AppUser', mapping: 'AppUser'}
			,{name: 'Appdate', mapping: 'Appdate'}
			,{name: 'Apptime', mapping: 'Apptime'}
			,{name: 'AuditStatus', mapping: 'AuditStatus'}
			,{name: 'OldLoc', mapping: 'OldLoc'}
			,{name: 'PatSex', mapping: 'PatSex'}
			,{name: 'PatAge', mapping: 'PatAge'}
			,{name: 'RegNo', mapping: 'RegNo'}
			,{name: 'EpisodeID', mapping: 'EpisodeID'}
			,{name: 'IPDate', mapping: 'IPDate'}
			,{name: 'Patward', mapping: 'Patward'}
			,{name: 'WardID', mapping: 'WardID'}
			,{name: 'Appid', mapping: 'Appid'}
						*/
					var PatName = PatListArr[i].split("^")[0];
					var ApplyBed = PatListArr[i].split("^")[1];
					var CurrentBed = PatListArr[i].split("^")[2];
					var ApplyType = PatListArr[i].split("^")[3];
					var AppUser = PatListArr[i].split("^")[4];
					var Appdate = PatListArr[i].split("^")[5];

					var Apptime = PatListArr[i].split("^")[6];
					var AuditStatus = PatListArr[i].split("^")[7];
					var OldLoc = PatListArr[i].split("^")[8];
					var PatSex = PatListArr[i].split("^")[9];
					var PatAge = PatListArr[i].split("^")[10];
					var RegNo = PatListArr[i].split("^")[11];
					var EpisodeID = PatListArr[i].split("^")[12];
					var IPDate = PatListArr[i].split("^")[13];
					var Patward = PatListArr[i].split("^")[14];
					var WardID = PatListArr[i].split("^")[15];
					var Appid = PatListArr[i].split("^")[16];
					var record = new Object();

					record.PatName = PatName;
					record.ApplyBed = ApplyBed;
					record.CurrentBed = CurrentBed;
					record.ApplyType = ApplyType;
					record.AppUser = AppUser;
					record.Appdate = Appdate;
					record.Apptime = Apptime;
					record.AuditStatus = AuditStatus;
					record.OldLoc = OldLoc;
					record.PatSex = PatSex;
					record.PatAge = PatAge;
					record.RegNo = RegNo;
					record.EpisodeID = EpisodeID;
					record.IPDate = IPDate;
					record.Patward = Patward;
					record.WardID = WardID;
					record.Appid = Appid;
					var records = new Ext.data.Record(record);
					gridbedauditStore.add(records);
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
		Ext.getCmp('Searchflag').setValue('V');
		Ext.get('btnQuery').on("click", Search_onclick);
		Ext.get('btnAudit').on("click", Audit_onclick);
		Ext.get('btnRefuse').on("click", Refuse_onclick);
		Search_onclick();
	})
	/*
	var contextmenu =new Ext.menu.Menu({
	        id: 'theContextMenu',
	        items: [
			
			{
	            text: '转科换床申请',
				id:'ChangeBedApp',
	            handler:ChangeBedApp
	        }
			]
	    })
		*/
	//grid=Ext.getCmp("gridResult");
gridbedaudit.on("rowcontextmenu", function(grid1, rowIndex, e) {
	e.preventDefault();
	grid1.getSelectionModel().selectRow(rowIndex);
	contextmenu.showAt(e.getXY());
});

function ChangeBedApp() {
	var linenum = gridbedaudit.getSelectionModel().lastActive; //获取行号
	var objresult = gridbedaudit.store.data.items[linenum].data;
	var win = new Ext.Window({
		title: '转科/换床申请',
		layout: 'form',
		width: 350,
		height: 300,
		modal: true,
		labelAlign: 'right',
		items: [{
			xtype: 'field',
			fieldLabel: '床号',
			width: 160,
			value: objresult.BedCode,
			disabled: true
		}, {
			xtype: 'field',
			fieldLabel: '患者',
			width: 160,
			value: objresult.PatName,
			disabled: true
		}, {
			xtype: 'button',
			id: 'ChangeApp',
			buttonAlign: 'center',
			text: '确认',
			height: 30,
			width: 80,
			style: 'margin:50 121', ////gg 这种方式调位置,没想到其他法子 
			handler: function(t, e) {
				var ret = tkMakeServerCall("User.DHCBedChangeApp", "Save", "", objresult.EpisodeID, "0");
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
		}]
	})
	win.show();
}

function Audit_onclick() {
	var AuditUser = session['LOGON.USERID'];
	var AuditStatus = "E";
	var rows = Ext.getCmp('gridbedaudit').getSelectionModel().getSelections(); //获取所有选中行，
	var str = "";
	for (var i = 0; i < rows.length; i++) {
		if (str == "") {
			str = rows[i].get("Appid");
		} else {
			str = str + ',' + rows[i].get("Appid");
		}
	}
	var ret = tkMakeServerCall("Nur.DHCBedApplyChange", "Audit", str, AuditStatus, AuditUser);
	if (ret == "0") {
		alert("审核成功")
		Search_onclick();
	} else {
		alert(ret)
		return;
	}
	/*
	var linenum=gridbedaudit.getSelectionModel().lastActive; //获取行号
	var objresult=gridbedaudit.store.data.items[linenum].data;
	var ret=tkMakeServerCall("User.DHCBedChangeApp","Audit",objresult.Appid);
	if (ret=="0")
	{
	alert("审核成功")
	Search_onclick()
	}
	*/
}

function Refuse_onclick() {
	var RefuseUser = session['LOGON.USERID'];
	var RefuseStatus = "R";
	var rows = Ext.getCmp('gridbedaudit').getSelectionModel().getSelections(); //获取所有选中行，
	var str = "";
	for (var i = 0; i < rows.length; i++) {
		if (str == "") {
			str = rows[i].get("Appid");
		} else {
			str = str + ',' + rows[i].get("Appid");
		}
	}
	var ret = tkMakeServerCall("Nur.DHCBedApplyChange", "Refuse", str, RefuseStatus, RefuseUser);
	if (ret == "0") {
		alert("成功")
		Search_onclick();
	} else {
		alert(ret)
		return;
	}
}
////combobox选择时调用查询
Searchflag.on('select', CallSearchclick);

function CallSearchclick(combo, record, index) {
	Search_onclick()
}