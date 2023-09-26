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
	text: '��ѯ',
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
		msg: '���ڶ�ȡ����,���Ժ�...'
	} //һ�� Ext.LoadMask ���ã�����Ϊtrue�Ա��ڼ���ʱ����grid�� Ĭ��Ϊ false .
	//,plugins: obj.expCtrlDetail //һ���������һ���������飬Ϊ����ṩ����Ĺ��ܡ� ��һ���Ϸ��Ĳ��Ψһ��Ҫ����������һ��init()������ �ܽ���һ��Ext.Component�͵Ĳ����������������ʱ������п��õĲ��������������ÿ�������init���������������������Ϊ�����������ݸ�����Ȼ��ÿ������Ϳ��Ե��÷���������Ӧ����ϵ��¼���������Ҫ�������ṩ�Լ��Ĺ��ܡ� 
	,
	columns: [
		/*new Ext.grid.RowNumberer({header:"����"	,width:60})*/
		{
			header: '��λid',
			width: 30,
			dataIndex: 'BedId',
			sortable: true
		}, {
			header: '��λ��',
			width: 100,
			dataIndex: 'BedCode',
			sortable: true
		}, {
			header: '��������',
			width: 100,
			dataIndex: 'PatName',
			sortable: true
		}, {
			header: '��λ״̬',
			width: 100,
			dataIndex: 'BedStatus',
			sortable: true
		}, {
			header: 'Ԥ��ʱ��',
			width: 100,
			dataIndex: 'Bedlatertime',
			sortable: true
		} //��λ�ƻ��յ�ʱ��
		, {
			header: '������',
			width: 100,
			dataIndex: 'operaUser',
			sortable: true
		} //������
		, {
			header: '���봲λ',
			width: 100,
			dataIndex: 'ApplyBed',
			sortable: true
		}, {
			header: '����״̬',
			width: 100,
			dataIndex: 'ApplyStatus',
			sortable: true
		}, {
			header: '������Ա',
			width: 100,
			dataIndex: 'ApplyUser',
			sortable: true
		}, {
			header: '���״̬',
			width: 100,
			dataIndex: 'AuditStatus',
			sortable: true
		}, {
			header: '�����Ա',
			width: 100,
			dataIndex: 'AuditUser',
			sortable: true
		}, {
			header: '��λ����',
			width: 100,
			dataIndex: 'BedBill',
			sortable: true
		}, {
			header: '����',
			width: 100,
			dataIndex: 'PatName',
			sortable: true
		}, {
			header: '�Ա�',
			width: 100,
			dataIndex: 'PatSex',
			sortable: true
		}, {
			header: '����',
			width: 100,
			dataIndex: 'PatAge',
			sortable: true
		}, {
			header: '��λ����',
			width: 100,
			dataIndex: 'BedOwn',
			sortable: true
		}, {
			header: '�ǼǺ�',
			width: 100,
			dataIndex: 'RegNo',
			sortable: true
		}, {
			header: '�����',
			width: 100,
			dataIndex: 'EpisodeID',
			sortable: true
		}, {
			header: '��Ժ����',
			width: 100,
			dataIndex: 'IPDate',
			sortable: true
		}, {
			header: '����',
			width: 100,
			dataIndex: 'Patward',
			sortable: true
		}, {
			header: '����id',
			width: 30,
			dataIndex: 'WardID',
			sortable: true
		}
	],
	bbar: new Ext.PagingToolbar({
		pageSize: 1000,
		store: gridCurwardbedStore,
		displayInfo: false,
		emptyMsg: 'û�м�¼',
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
			text: '�ó�Ժʱ��',
			id: 'SetPatOuttime',
			handler: SetPatOuttime
		}, {
			text: '�����ÿ�',
			id: 'CancelSetPatOuttime',
			handler: CancelSetPatOuttime
		}, {
			text: '��������',
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

	var linenum = gridCurwardbed.getSelectionModel().lastActive; //��ȡ�к�
	var objresult = gridCurwardbed.store.data.items[linenum].data;
	var win = new Ext.Window({
		title: '�ó�Ժʱ��',
		layout: 'form',
		width: 350,
		height: 300,
		modal: true,
		labelAlign: 'right',
		items: [{
			xtype: 'datefield',
			fieldLabel: '����',
			id: 'setdate',
			width: 160,
			format: 'Y-m-d',
			value: new Date().add(Date.DAY, +1),
			name: 'date'
		}, {
			xtype: 'field',
			fieldLabel: '����',
			width: 160,
			value: objresult.BedCode,
			disabled: true
		}, {
			xtype: 'field',
			fieldLabel: '��ǰ����',
			width: 160,
			format: 'Y-m-d',
			value: new Date().toLocaleDateString(),
			disabled: true
		}, {
			xtype: 'button',
			id: 'AuthorizeBedlist',
			buttonAlign: 'center',
			text: 'ȷ��',
			height: 30,
			width: 80,
			style: 'margin:50 121', ////gg ���ַ�ʽ��λ��,û�뵽�������� 
			handler: function(t, e) {
				//var ret=tkMakeServerCall("Nur.DHCBedManager","Setbedempty",objresult.BedId,setdate.value);
				var Userid = session['LOGON.USERID'];
				var Status = "V";
				var ret = tkMakeServerCall("Nur.DHCBedEmptyflag", "Save", objresult.BedId, setdate.value, Userid, Status);
				//alert(setdate.value)
				if (ret == "0") {
					alert("�ÿճɹ�")
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
		alert("��ֱ�ӷ��䴲λ��������")
		return
	}

	//�����ҽ����
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
		fieldLabel: '����',
		editable: true,
		triggerAction: 'all',
		anchor: '60%',
		valueField: 'BedRowid'


	});
	//����
	ResultBedStoreStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'Nur.DHCBedManager';
		param.QueryName = 'GetApplyedBed';
		param.Arg1 = ctloc;
		param.Arg2 = ResultBed.getRawValue();
		param.ArgCnt = 2;
	});
	var linenum = gridCurwardbed.getSelectionModel().lastActive; //��ȡ�к�
	var objresult = gridCurwardbed.store.data.items[linenum].data;
	var ApplyType = tkMakeServerCall("Nur.DHCBedManager", "GetAdmTransLocBed", objresult.EpisodeID); //�������� ����������

	var ApplyType = "M"; //д����
	var ApplyStatus = "V";

	var win = new Ext.Window({
		title: '��������',
		layout: 'form',
		width: 350,
		height: 300,
		modal: true,
		labelAlign: 'right',
		items: [{
				xtype: 'field',
				fieldLabel: '��ǰ����',
				width: 160,
				value: objresult.BedCode,
				disabled: true
			}, {
				xtype: 'field',
				fieldLabel: '����',
				width: 160,
				value: objresult.PatName,
				disabled: true
			},
			ResultBed, {
				xtype: 'button',
				id: 'ChangeApp',
				buttonAlign: 'center',
				text: 'ȷ��',
				height: 30,
				width: 80,
				style: 'margin:50 121', ////gg ���ַ�ʽ��λ��,û�뵽�������� 
				handler: function(t, e) {
					var TransBedId = Ext.getCmp("ResultBed").value;
					if (TransBedId == undefined) {
						alert("��ѡ�񴲺�");
						win.close();
						return;
					}
					//var ret=tkMakeServerCall("User.DHCBedChangeApp","Save","",objresult.EpisodeID,"0");
					var ret = tkMakeServerCall("Nur.DHCBedApplyChange", "Save", TransBedId, objresult.EpisodeID, ApplyUser, ApplyStatus, ApplyType);
					//alert(setdate.value)
					if (ret == "0") {
						alert("����ɹ�")
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
	var linenum = gridCurwardbed.getSelectionModel().lastActive; //��ȡ�к�
	var objresult = gridCurwardbed.store.data.items[linenum].data;
	//alert(objresult.BedId)
	var Userid = session['LOGON.USERID'];
	var Status = "C";
	var ret = tkMakeServerCall("Nur.DHCBedEmptyflag", "Save", objresult.BedId, "", Userid, Status);
	if (ret == "0") {
		alert("�ɹ�")
		Search_onclick();
	} else {
		alert(ret)
		return;
	}
}