//var LabLoc = new Ext.form.ComboBox({id:'LabLoc',width:100,store:new Ext.data.SimpleStore({data : [],fields: ['desc', 'id']}), 
//	displayField:'desc',valueField:'id',allowBlank: true,	mode:'local',	value:'',forceSelection : true,triggerAction:'all'});
var editFlag = true;
function BodyLoadHandler() {
	setsize("mygridpl", "gform", "mygrid");
	grid = Ext.getCmp('mygrid');
	grid.setTitle("标本出科");
	var len = grid.getColumnModel().getColumnCount();
		for(var i = 0 ;i < len;i++){
			if(grid.getColumnModel().getDataIndex(i) == 'CarryRowId'){
				grid.getColumnModel().setHidden(i,true);
			}
		}
	var but1 = Ext.getCmp("mygridbut1");
	but1.hide();
	//but1.on("click",addBill);
	var but = Ext.getCmp("mygridbut2");
	but.hide();
	grid.on('rowdblclick', findDetail);
	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	tobar.addItem("开始日期：", { xtype: 'datefield', id: 'mygridstdate', value: diffDate(new Date(), -1) },
		"-",
		"结束日期：", {
			xtype: 'datefield',
			id: 'mygridenddate',
			value: diffDate(new Date(), 1)
		}, "-", {
			xtype: 'button',
			width: "50",
			id:'findBtn',
			text: '查询',
			handler: find,
			icon: '../images/uiimages/search.png'
		}, "-", {
			xtype: 'button',
			width: "50",
			id:'addBillBtn',
			text: '建单',
			handler: addBill,
			icon: '../images/uiimages/edit_add.png'
		}, "-", {
			xtype: 'button',
			width: "50",
			id:'cancelBtn',
			text: '删除',
			handler: cancel,
			icon: '../images/uiimages/edit_remove.png'
		}, "-", {
			xtype: 'button',
			width: "50",
			text: '出库',
			id:'ExchangeBtn',
			handler: Exchange,
			icon: '../images/uiimages/update1.png'
		}, "-"
	);
	//tobar.addItem("标本号：",{xtype:'textfield',width:150,id:'SpecNoField',enableKeyEvents: true});
	//tobar.addButton({width:50,text: "建单",handler: addBill});
	//tobar.addButton({width:50,text: "查询",handler: find});
	tbar2 = new Ext.Toolbar({});
	tbar2.addItem({
		xtype: 'radiogroup', height: 20, width: 300, id: "labStatus", itemCls: 'x-check-group-alt', columns: 4, items: [
			{
				boxLabel: '建单',
				id: "Created",
				name: 'status',
				inputValue: "C",
				checked: true
			}, {
				boxLabel: '已交接',
				id: "Sent",
				name: 'status',
				inputValue: "S"
			}, {
				boxLabel: '部分处理',
				id: "Part",
				name: 'status',
				inputValue: "P"
			}, {
				boxLabel: '全部接收',
				id: "Recie",
				name: 'status',
				inputValue: "R"
			}
			]
	});

	//tbar2.addButton({width:80,text: "选行打印",handler: selectPrint});
	//tbar2.addButton({width:80,text: "全部打印",handler: printAll});               	
	tbar2.render(grid.tbar);
	tobar.doLayout();
	grid.store.on("beforeLoad", BeforeLoad);
	find();
	Ext.getCmp("Created").on('check', function () {
		if (Ext.getCmp("Created").getValue() == true) {
			editFlag = true;
			addBillCheckLisener();
			find();
		}

	})
	Ext.getCmp("Sent").on('check', function () {
		if (Ext.getCmp("Sent").getValue() == true) {
			editFlag = true;
			partCheckLisener();
			find();
		}
	})
	Ext.getCmp("Part").on('check', function () {
		if (Ext.getCmp("Part").getValue() == true) {
			editFlag = false;
			partCheckLisener();
			find();
		}
	})
	Ext.getCmp("Recie").on('check', function () {
		if (Ext.getCmp("Recie").getValue() == true) {
			editFlag = false;
			partCheckLisener();
			find();
		}
	})
	window.onresize=function(){
		window.location.reload();
	}
}
function partCheckLisener(){
	Ext.getCmp('addBillBtn').setDisabled(true);
	Ext.getCmp('cancelBtn').setDisabled(true);
	Ext.getCmp('ExchangeBtn').setDisabled(true);
}
function addBillCheckLisener(){
	Ext.getCmp('addBillBtn').setDisabled(false);
	Ext.getCmp('cancelBtn').setDisabled(false);
	Ext.getCmp('ExchangeBtn').setDisabled(false);
}
function BeforeLoad() {
	var StDate = Ext.getCmp("mygridstdate");
	var Enddate = Ext.getCmp("mygridenddate");
	var labstatus = Ext.getCmp("labStatus").getValue().getGroupValue();
	grid.store.baseParams.stdate = StDate.value;
	grid.store.baseParams.enddate = Enddate.value;
	grid.store.baseParams.locId = session['LOGON.CTLOCID'];
	grid.store.baseParams.status = labstatus;
}

function UpdateStatus() {
	var usercode = Ext.getCmp('UserCode').getValue();
	var pwd = Ext.getCmp('Pwd').getValue();
	var specno = Ext.getCmp('SpecNoField').getValue();
	var stat = "";
	if (Ext.getCmp("SpecStatus").getValue() == true)
		stat = "Y";
	else
		stat = "T";

	//alert(usercode+"^"+pwd+"^"+specno+"^"+stat);
	var ret = tkMakeServerCall("Nur.DHCNURSpecUpdateStatus", "UpdateStatus", usercode, pwd, specno, stat);
	if (ret != "0")
		alert(ret);
	else
		alert("更新成功！");
	find();
}

function find() {
	grid = Ext.getCmp('mygrid');
	grid.store.load({ params: { start: 0, limit: 10 } });
}

function selectPrint() {
	var list = [];
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len == 0) {
		alert("请选择一条记录！");
		return;
	}
	var CarryRowIdStr = "";
	for (var r = 0; r < len; r++) {
		var CarryRowId = rowObj[r].data["CarryRowId"];
		if (CarryRowIdStr == "") CarryRowIdStr = CarryRowId;
		else CarryRowIdStr = CarryRowIdStr + "^" + CarryRowId;
	}
	DHCCNursePrintComm.showOtherSingleSheet(CarryRowIdStr, "LabOutLoc", WebIp, "NurseOrder.xml")
}

function printAll() {
	var store = grid.store;
	if (store.getCount() == 0) {
		alert("没有记录可打印！");
		return;
	}
	var CarryRowIdStr = "";
	for (var i = 0; i < store.getCount(); i++) {
		var CarryRowId = store.getAt(i).data["CarryRowId"];
		if (CarryRowIdStr == "") CarryRowIdStr = CarryRowId;
		else CarryRowIdStr = CarryRowIdStr + "^" + CarryRowId;
	}

	DHCCNursePrintComm.showOtherSingleSheet(CarryRowIdStr, "LabOutLoc", WebIp, "NurseOrder.xml")
}

function findDetail() {
	var grid = Ext.getCmp("mygrid");
	var objRow = grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		return;
	}
	else {

		var Id = objRow[0].get("CarryRowId");
		var TransNo = objRow[0].get("CarryNo")
		var lnk = "DHCNurEmrComm.csp?" + "&EmrCode=DHCNURBG_LABOUTLOCDETAIL1&TransId=" + Id + "&TransNo=" + TransNo + "&editFlag=" + editFlag;
		//alert("%%%"+lnk)
		window.open(lnk, "DHCNURBG_LABOUTLOCDETAIL1", 'left=300,top=0,toolbar=no,location=no,directories=no,resizable=yes,width=1000,height=800');
	}
}
function addBill() {

	var ret = tkMakeServerCall("Nur.NurseCarry", "CreatTranNo", session['LOGON.USERCODE'], session['LOGON.CTLOCID']);
	ret = ret.split("^");
	var lnk = "DHCNurEmrComm.csp?" + "&EmrCode=DHCNURBG_LABOUTLOCDETAIL1&TransId=" + ret[1] + "&TransNo=" + ret[0] + "&editFlag=" + editFlag;
	//alert(lnk)
	window.open(lnk, "DHCNURBG_LABOUTLOCDETAIL1", 'left=300,top=0,toolbar=no,location=no,directories=no,resizable=yes,width=1000,height=800');
	find();
}
function cancel() {
	var grid = Ext.getCmp("mygrid");
	var objRow = grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		return;
	}
	else {
		Ext.Msg.confirm('系统提示','确定要删除吗？',
		  function(btn){
			if(btn=='yes'){
				var TransNo = objRow[0].get("CarryNo");
				var ret = tkMakeServerCall("Nur.NurseCarry", "DeleteTransNo", TransNo, session['LOGON.USERID']);
				ret = ret.split("@");
				if (ret[0] != "0") {
					alert(ret[1]);
				} else {
					find();
				}				
			}			
		 },this);		
	}
}
var win = "";
Ext.onReady(function () {
	var formPanel = new Ext.FormPanel({
		id: 'vali',
		labelWidth: 60, // label settings here cascade unless overridden
		frame: true,
		bodyStyle: 'padding:5px 5px 0',
		width: 300,
		defaults: { width: 150 },
		defaultType: 'textfield',
		items: [{ id: 'username', fieldLabel: '护工工号', name: 'username', allowBlank: false, blankText: '必填', value: '' },
		{ id: 'password', fieldLabel: '护工密码', name: 'password', value: '' },
		{ id: 'containerId', fieldLabel: '容器编号', name: 'containerId', value: '' }]
	})
	win = new Ext.Window({
		title: '护工确认',
		width: 300,
		autoHeight: 'true',
		resizable: false,
		modal: true,
		closeAction: 'hide',
		buttonAlign: 'center',
		items: formPanel,
		buttons: [{
			text: '确定', icon: '../images/uiimages/ok.png', handler: function () {
				var username = Ext.getCmp('username').getValue();
				var psword = Ext.getCmp('password').getValue();
				var containerId = Ext.getCmp('containerId').getValue();
				var userId = ""
				var retStr = tkMakeServerCall("web.DHCLCNUREXCUTE", "ConfirmPassWord", username, psword)
				if (retStr.split("^")[0] != 0) {
					alert("护工密码不对");
					return;
				} else {
					userId = retStr.split("^")[1];
				}
				if (username != "") {
					var ret = tkMakeServerCall("Nur.NurseCarry", "ExchangeTransNo", NurTransNo, containerId, userId, session['LOGON.USERID']);
					ret = ret.split("@");
					if (ret[0] != "0") {
						alert(ret[1]);
					} else {
						win.hide();
						find();
						return;
					}
				} else {
					alert("请输入护工工号！");
					return;
				}
			}
		},
		{
			text: '取消', icon: '../images/uiimages/cancel.png', handler: function () {
				Ext.getCmp('username').setValue("");
				Ext.getCmp('password').setValue("");
				Ext.getCmp('containerId').setValue("");
				win.hide();
			}
		},
		{
			text: '重置', icon: '../images/uiimages/reload.png', handler: function () {
				Ext.getCmp('username').setValue("");
				Ext.getCmp('password').setValue("");
				Ext.getCmp('containerId').setValue("");
			}
		}]
	})
})
var NurTransNo = ""
function Exchange() {
	var grid = Ext.getCmp("mygrid");
	var objRow = grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		return;
	}
	else {
		var carryArray=objRow.map(function(row){
			if(row.get("CarryCount")>0){
				return row.get("CarryNo");
			}
		});
		if(carryArray.length>0){
			NurTransNo=carryArray.join("^");
		}
		else {
			alert("无标本不可交单！");
			return;
		}
		/*NurTransNo = objRow[0].get("CarryNo");
		var CarryCount = objRow[0].get("CarryCount");
		if (CarryCount == 0) {
			alert("无标本不可交单！");
			return;
		}*/
		
		win.show();
		Ext.getCmp('username').focus(false, 100);
		return;
	}
}