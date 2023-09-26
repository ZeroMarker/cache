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
	minChars: 1 //���Զ���ɺ�typeAhead ����֮ǰ���û���������������ַ���
		,
	selectOnFocus: true //true �����ڻ�ý���ʱ���ѡ�б��������д��ڵ��ı��� ����editable = true ʱӦ��(Ĭ��Ϊfalse)�� 
		,
	forceSelection: true //true �����޶�ѡ���ֵ���б��е�ֵ֮һ�� false���������û����������������ֵ (Ĭ��Ϊfalse) 
		,
	store: cboWardStore,
	displayField: 'CTLocDesc',
	fieldLabel: '����',
	editable: true //false����ֹ�û�ֱ��������������ı������������Ӧ �ڴ�����ť�Ͻ��������Ȼ������ֵ��(Ĭ��Ϊtrue)�� 
		,
	triggerAction: 'all' //�������������ʱ��Ҫִ�еĲ�����
		,
	anchor: '100%',
	valueField: 'CTLocID'
});
///��ѯ����
var Searchdata = new Ext.form.DateField({
	xtype: 'datefield',
	fieldLabel: '����',
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
	text: '��ѯ',
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
	text: '���',
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
	text: '�ܾ�',
	margins: {
		top: 0,
		right: 0,
		bottom: 0,
		left: 100
	}

});
var comboData = [
	['V', 'δ��'],
	['E', '����'],
	['F', '�����'],
	['R', '�Ѿܾ�']
];
var Searchstore = new Ext.data.SimpleStore({
	fields: ['disvalue', 'distext'],
	data: comboData
});
//��ѯ���� 
var Searchflag = new Ext.form.ComboBox({
	xtype: "combo",
	id: "Searchflag",
	width: 100,
	fieldLabel: "״̬",
	mode: "local", //ֱ�Ӷ���д��local
	triggerAction: 'all', //����������
	editable: false,
	emptyText: "",
	store: Searchstore,
	displayField: 'distext', //
	valueField: 'disvalue',
	anchor: '100%'
});
///���� ��
var UnAudit = new Ext.form.Radio({
	boxLabel: 'δ��',
	xtype: 'radiogroup',
	name: 'rad',
	id: 'UnAudit',
	checked: true,
	value: '2',
	width: '100'
});
///������ ����combobox
var Audit = new Ext.form.Radio({

	boxLabel: '����',
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

//�������������  
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
		msg: '���ڶ�ȡ����,���Ժ�...'
	} //һ�� Ext.LoadMask ���ã�����Ϊtrue�Ա��ڼ���ʱ����grid�� Ĭ��Ϊ false .
	//,plugins: obj.expCtrlDetail //һ���������һ���������飬Ϊ����ṩ����Ĺ��ܡ� ��һ���Ϸ��Ĳ��Ψһ��Ҫ����������һ��init()������ �ܽ���һ��Ext.Component�͵Ĳ����������������ʱ������п��õĲ��������������ÿ�������init���������������������Ϊ�����������ݸ�����Ȼ��ÿ������Ϳ��Ե��÷���������Ӧ����ϵ��¼���������Ҫ�������ṩ�Լ��Ĺ��ܡ� 
	,
	columns: [
		/*new Ext.grid.RowNumberer({header:"����"	,width:60})*/
		//new Ext.grid.RowNumberer(),
		sm, {
			header: '��������',
			width: 100,
			dataIndex: 'PatName',
			sortable: true
		}, {
			header: '���봲λ',
			width: 100,
			dataIndex: 'ApplyBed',
			sortable: true
		}, {
			header: '��ǰ��λ',
			width: 100,
			dataIndex: 'CurrentBed',
			sortable: true
		}, {
			header: '��������',
			width: 100,
			dataIndex: 'ApplyType',
			sortable: true
		}, {
			header: '������Ա',
			width: 100,
			dataIndex: 'AppUser',
			sortable: true
		}, {
			header: '��������',
			width: 100,
			dataIndex: 'Appdate',
			sortable: true
		}, {
			header: '����ʱ��',
			width: 100,
			dataIndex: 'Apptime',
			sortable: true
		}, {
			header: '���״̬',
			width: 100,
			dataIndex: 'AuditStatus',
			sortable: true
		}, {
			header: '��һ����',
			width: 100,
			dataIndex: 'OldLoc',
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
	            text: 'ת�ƻ�������',
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
	var linenum = gridbedaudit.getSelectionModel().lastActive; //��ȡ�к�
	var objresult = gridbedaudit.store.data.items[linenum].data;
	var win = new Ext.Window({
		title: 'ת��/��������',
		layout: 'form',
		width: 350,
		height: 300,
		modal: true,
		labelAlign: 'right',
		items: [{
			xtype: 'field',
			fieldLabel: '����',
			width: 160,
			value: objresult.BedCode,
			disabled: true
		}, {
			xtype: 'field',
			fieldLabel: '����',
			width: 160,
			value: objresult.PatName,
			disabled: true
		}, {
			xtype: 'button',
			id: 'ChangeApp',
			buttonAlign: 'center',
			text: 'ȷ��',
			height: 30,
			width: 80,
			style: 'margin:50 121', ////gg ���ַ�ʽ��λ��,û�뵽�������� 
			handler: function(t, e) {
				var ret = tkMakeServerCall("User.DHCBedChangeApp", "Save", "", objresult.EpisodeID, "0");
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
		}]
	})
	win.show();
}

function Audit_onclick() {
	var AuditUser = session['LOGON.USERID'];
	var AuditStatus = "E";
	var rows = Ext.getCmp('gridbedaudit').getSelectionModel().getSelections(); //��ȡ����ѡ���У�
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
		alert("��˳ɹ�")
		Search_onclick();
	} else {
		alert(ret)
		return;
	}
	/*
	var linenum=gridbedaudit.getSelectionModel().lastActive; //��ȡ�к�
	var objresult=gridbedaudit.store.data.items[linenum].data;
	var ret=tkMakeServerCall("User.DHCBedChangeApp","Audit",objresult.Appid);
	if (ret=="0")
	{
	alert("��˳ɹ�")
	Search_onclick()
	}
	*/
}

function Refuse_onclick() {
	var RefuseUser = session['LOGON.USERID'];
	var RefuseStatus = "R";
	var rows = Ext.getCmp('gridbedaudit').getSelectionModel().getSelections(); //��ȡ����ѡ���У�
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
		alert("�ɹ�")
		Search_onclick();
	} else {
		alert(ret)
		return;
	}
}
////comboboxѡ��ʱ���ò�ѯ
Searchflag.on('select', CallSearchclick);

function CallSearchclick(combo, record, index) {
	Search_onclick()
}