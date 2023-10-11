/**
 * @author Administrator
 */
var form;
var locdata = new Array();
var condata = new Array();
var arr = new Array();
// 会诊列表
var a = cspRunServerMethod(pdata1, "", "DHCCONSULTLIST", EpisodeID, "");
arr = eval(a);
Ext.onReady(function() {
			new Ext.form.FormPanel({
						height : 800,
						width : 1250,
						autoScroll : true,
						layout : 'absolute',
						items : arr,
						renderTo : Ext.getBody()
					});

			FindAdmConsult();
			var grid = Ext.getCmp("mygrid");
			var but = Ext.getCmp("but1");
			but.on('click', huizhen);
			var but = Ext.getCmp("but2");
			but.on('click', ModConsult);
		});

function FindAdmConsult() {
	condata = new Array();
	cspRunServerMethod(GetConsult, EpisodeID, "addconsult");
	var grid = Ext.getCmp("mygrid");
	grid.width = document.body.offsetWidth;
	grid.store.loadData(condata);
}
var myId = "";
function ModConsult() {
	var grid = Ext.getCmp("mygrid");

	var rowObj = grid.getSelections();
	var len = rowObj.length;

	if (len < 1) {
		// Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons:
		// Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	} else {

		myId = rowObj[0].get("RowID");
	}
	var arr = new Array();
	// 录入界面
	var a = cspRunServerMethod(pdata1, "", "DHCCONSULTPAT", EpisodeID, "");
	arr = eval(a);
	var window = new Ext.Window({
				title : '会诊',
				width : 850,
				height : 650,
				autoScroll : true,
				layout : 'absolute',
				// plain: true,
				// modal: true,
				// bodyStyle: 'padding:5px;',
				// /buttonAlign: 'center',
				items : arr,
				buttons : [{
							text : '保存',
							handler : function() {
								Save();
								window.close();
							}
						}, {
							text : '取消',
							handler : function() {
								window.close();
							}
						}, {
							text : '打印',
							handler : function() {
								printconsult(myId);
							}
						}]
			});
	var dep = Ext.getCmp("ConsultDep");
	if (dep != null) {
		cspRunServerMethod(getloc, 'addloc');
		dep.store.loadData(locdata);
	}
	var ret = cspRunServerMethod(getSingleConsult, myId);
	var arr = ret.split("^");
	var dep = Ext.getCmp("ConsultDep");
	var appdate = Ext.getCmp("AppDate");
	var apptime = Ext.getCmp("AppTime");
	var typ = Ext.getCmp("ConType");
	var inout = Ext.getCmp("InOut");
	var destin = Ext.getCmp("ConDestination");
	var atti = Ext.getCmp("Attitude");
	dep.value = arr[5];
	appdate.value = arr[0];
	apptime.value = arr[1];
	typ.value = arr[4];
	atti.value = arr[2];
	destin.value = arr[3];
	inout.value = arr[7];
	window.show();

}
function printconsult(myid) {
	PrintComm.SetConnectStr("CN_IPTCP:172.21.21.2[1972]:dhc-app");
	// 会诊print
	PrintComm.ItmName = "PrnReportver411itm41fold4NOD";
	// debugger;
	PrintComm.ID = "";
	PrintComm.MultID = "";
	PrintComm.MthArr = "web.DHCConsult:getConsultInfo&id:" + myid;
	// debugger;
	PrintComm.PrintOut();
}
function huizhen() {
	myId = "";
	var arr = new Array();
	// 录入界面
	var a = cspRunServerMethod(pdata1, "", "DHCCONSULTPAT", EpisodeID, "");
	// alert(a);
	arr = eval(a);
	var window = new Ext.Window({
				title : '会诊',
				width : 750,
				height : 650,
				autoScroll : true,
				layout : 'absolute',
				// plain: true,
				// modal: true,
				// bodyStyle: 'padding:5px;',
				// /buttonAlign: 'center',
				items : arr,
				buttons : [{
							text : '保存',
							handler : function() {
								Save();
								window.close();
							}
						}, {
							text : '取消',
							handler : function() {
								window.close();
							}
						}]
			});
	var mydate = new Date();
	var appdate = Ext.getCmp("AppDate");
	appdate.setValue(mydate.getDate());
	var apptime = Ext.getCmp("AppTime");
	apptime.setValue(mydate.getHours() + ":" + mydate.getMinutes());
	var dep = Ext.getCmp("ConsultDep");
	if (dep != null) {
		cspRunServerMethod(getloc, 'addloc');
		dep.store.loadData(locdata);
	}
	window.show();
}
function addloc(a, b) {
	locdata.push({
				id : a,
				desc : b
			});
}
function addconsult(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p) {
	condata.push({
				ConDep : a,
				ConDoc : b,
				Status : c,
				BedCode : d,
				PatDep : e,
				InOut : f,
				Diag : g,
				Destination : h,
				PatName : i,
				AppTime : j,
				AppDate : k,
				ConDate : l,
				ConTime : m,
				EpisodeId : n,
				RowID : o,
				Contyp : p
			});
}

function Save() {
	var ret = "";
	var dep = Ext.getCmp("ConsultDep").value;
	var appdate = Ext.getCmp("AppDate").value;
	var apptime = Ext.getCmp("AppTime").value;
	var typ = Ext.getCmp("ConType").value;
	var inout = Ext.getCmp("InOut").value;
	var destin = Ext.getCmp("ConDestination").getRawValue();
	var atti = Ext.getCmp("Attitude").getRawValue();
	ret = ret + "ConsultDep|" + dep + "^";
	ret = ret + "AppDate|" + appdate + "^";
	ret = ret + "AppTime|" + apptime + "^";
	ret = ret + "ConType|" + typ + "^";
	ret = ret + "InOut|" + inout + "^";
	ret = ret + "ConDestination|" + destin + "^";
	ret = ret + "EpisdeID|" + EpisodeID + "^";
	ret = ret + "Status|V^";
	ret = ret + "AppDep|" + session['LOGON.CTLOCID'] + "^";
	ret = ret + "AppDoc|" + session['LOGON.USERID'] + "^";
	ret = ret + "id|" + myId;
	cspRunServerMethod(SaveCon, ret);
	FindAdmConsult();
	// alert(ret);

}