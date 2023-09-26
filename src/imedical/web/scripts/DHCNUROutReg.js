/**
 * @author Administrator
 */
function gethead()
{
	var GetHead=document.getElementById('GetHead');
	var ret=cspRunServerMethod(GetHead.value,EpisodeID);
	var hh=ret.split("^");
	return hh[0];
	//debugger;
}
function BodyLoadHandler() {
	setsize("mygridpl", "gform", "mygrid");
	Find();
	var grid = Ext.getCmp("mygrid");
	grid.setTitle(gethead());
	var but = Ext.getCmp("mygridbut1");
	but.on('click', AddOut);
	var but = Ext.getCmp("mygridbut2");
	but.on('click', ModOut);
	var tobar = grid.getTopToolbar();
	tobar.addButton({
				// className: 'new-topic-button',
				text : "删除",
				handler : DeleteOut,
				id : 'butCancel'
			});
	tobar.doLayout();
}
var REC = new Array();
var reasondata = new Array();
var person = new Array();
var myId = "";
function Find() {
	REC = new Array();
	var mygrid = Ext.getCmp("mygrid");
	var parr=EpisodeID;
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCTHREEEX:LeaveGetinfo", "parr$" + parr, "AddRec");
	mygrid.store.loadData(REC);
}
function ModOut() {
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len < 1) {
		// Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons:
		// Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	} else {
		myId = rowObj[0].get("rowid");
	}
	var arr = new Array();
	// 录入界面
	var a = cspRunServerMethod(pdata1, "", "DHCNUROUTREGW", EpisodeID, "");
	arr = eval(a);
	var window = new Ext.Window({
				title : '会诊',
				width : 420,
				height : 270,
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
								ModSave(window);
							}
						}, {
							text : '取消',
							handler : function() {
								window.close();
							}
						}]
	});
	var GetReason = document.getElementById('GetReason');
	reasondata = new Array();
	cspRunServerMethod(GetReason.value, 'addreasondata');
	var objreason = Ext.getCmp("reason");
	objreason.store.loadData(reasondata);
	var objnurse = Ext.getCmp("nurse");
	getlistdata("NURSE",EpisodeID,objnurse);
	var objnursern = Ext.getCmp("nursern");
	objnursern.store.loadData(person);
	person = new Array();
	var objdrapprove = Ext.getCmp("drapprove");
	getlistdata("DOCTOR",EpisodeID,objdrapprove);
	var GetLeaveSingle = document.getElementById('GetLeaveSingle');
	var ret = cspRunServerMethod(GetLeaveSingle.value, myId);
	var arr = ret.split("^");
	var godate = Ext.getCmp("godate");
	var gotime = Ext.getCmp("gotime");
	var nurse = Ext.getCmp("nurse");
	var edatern = Ext.getCmp("edatern");
	var etimern = Ext.getCmp("etimern");
	var objreason = Ext.getCmp("reason");
	var drapprove = Ext.getCmp("drapprove");
	var adatern = Ext.getCmp("adatern");
	var atimern = Ext.getCmp("atimern");
	var nursern = Ext.getCmp("nursern");
	godate.value = arr[0];
	gotime.value = arr[1];
	nurse.value = arr[2];
	edatern.value = arr[3];
	etimern.value = arr[4];
	objreason.value = arr[5];
	drapprove.value = arr[6];
	adatern.value = arr[7];
	atimern.value = arr[8];
	nursern.value = arr[9];
	window.show();
}

function AddOut() {
	myId = "";
	var arr = new Array();
	// 录入界面
	var a = cspRunServerMethod(pdata1, "", "DHCNUROUTREGW", EpisodeID, "");
	//alert(a);
	arr = eval(a);
	var window = new Ext.Window({
				title : '外出登记',
				width : 420,
				height : 270,
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
								AddSave(window);
							}
						}, {
							text : '取消',
							handler : function() {
								window.close();
							}
						}]
			});
	var mydate = new Date();
	var godate = Ext.getCmp("godate");
	godate.setValue(diffDate(mydate, 0));
	var gotime = Ext.getCmp("gotime");
	gotime.setValue(mydate.getHours() + ":" + mydate.getMinutes());
	var GetReason = document.getElementById('GetReason');
	reasondata = new Array();
	cspRunServerMethod(GetReason.value, 'addreasondata');
	var objreason = Ext.getCmp("reason");
	objreason.store.loadData(reasondata);
	var objnurse = Ext.getCmp("nurse");
	getlistdata("NURSE",EpisodeID,objnurse);
	var objnursern = Ext.getCmp("nursern");
	objnursern.store.loadData(person);
	person = new Array();
	var objdrapprove = Ext.getCmp("drapprove");
	getlistdata("DOCTOR",EpisodeID,objdrapprove);
	window.show();
}
function addreasondata(a, b) {
	reasondata.push({
				id : a,
				desc : b
			});
}
function getlistdata(typ,adm, cmb) {
	var GetDepPerson = document.getElementById('GetDepPerson');
	// debugger;
	var ret = cspRunServerMethod(GetDepPerson.value, typ, adm);
	if (ret != "") {
		var aa = ret.split('^');
		for (i = 0; i < aa.length; i++) {
			if (aa[i] == "")
				continue;
			var it = aa[i].split('|');
			addperson(it[1], it[0]);
		}
		// debugger;
		cmb.store.loadData(person);
	}
}
function addperson(a, b) {
	person.push({
				desc : a,
				id : b
			});
}

function AddRec(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p) {
	REC.push({
				godate : a,
				gotime : b,
				nurse : c,
				edatern : d,
				etimern : e,
				reason : f,
				drapprove : g,
				adatern : h,
				atimern : i,
				nursern : j,
				rowid : k,
				chl : l,
				nur : m,
				rea : n,
				doc : o,
				turn : p
			});
}

function AddSave(window) {
	var ret = "";
	var godate = Ext.getCmp("godate").value;
	if (godate==""){
		Ext.Msg.alert('提示', "请选择'离开日期'!");
		return;
	}
	var gotime = Ext.getCmp("gotime").getValue();
	if (gotime==""){
		Ext.Msg.alert('提示', "请填写'离开时间'!");
		return;
	}
	var nurse = Ext.getCmp("nurse").value;
	var edatern = Ext.getCmp("edatern").value;
	var etimern = Ext.getCmp("etimern").getValue();
	var objreason = Ext.getCmp("reason").value;
	if (objreason==""){
		Ext.Msg.alert('提示', "请选择'批准理由'!");
		return;
	}
	var drapprove = Ext.getCmp("drapprove").value;
	var adatern = Ext.getCmp("adatern").value;
	var atimern = Ext.getCmp("atimern").getValue();
	var nursern = Ext.getCmp("nursern").value;
	var parr=godate+"!"+gotime+"!"+nurse+"!"+edatern+"!"+etimern+"!"+objreason+"!"+drapprove+"!"+adatern+"!"+atimern+"!"+nursern
	//alert(parr);
	var LeaveInsert = document.getElementById("LeaveInsert");
	if (LeaveInsert) {
		var ee = cspRunServerMethod(LeaveInsert.value, parr, EpisodeID,"");
		if (ee!=0) alert(ee);
	}
	window.close();
	Find();
	// alert(ret);
}
function ModSave(window) {
	var ret = "";
	var godate = Ext.getCmp("godate").value;
	if (godate==""){
		Ext.Msg.alert('提示', "请选择'离开日期'!");
		return;
	}
	var gotime = Ext.getCmp("gotime").getValue();
	if (gotime==""){
		Ext.Msg.alert('提示', "请填写'离开时间'!");
		return;
	}
	var nurse = Ext.getCmp("nurse").value;
	var edatern = Ext.getCmp("edatern").value;
	var etimern = Ext.getCmp("etimern").getValue();
	var objreason = Ext.getCmp("reason").value;
	if (objreason==""){
		Ext.Msg.alert('提示', "请选择'批准理由'!");
		return;
	}
	var drapprove = Ext.getCmp("drapprove").value;
	var adatern = Ext.getCmp("adatern").value;
	var atimern = Ext.getCmp("atimern").getValue();
	var nursern = Ext.getCmp("nursern").value;
	var parr=godate+"!"+gotime+"!"+nurse+"!"+edatern+"!"+etimern+"!"+objreason+"!"+drapprove+"!"+adatern+"!"+atimern+"!"+nursern
	//alert(parr);
	var LeaveUpdate = document.getElementById("LeaveUpdate");
	if (LeaveUpdate) {
		var ee = cspRunServerMethod(LeaveUpdate.value, myId, parr);
		if (ee!=0) alert(ee);
	}
	window.close();
	Find();
	// alert(ret);
}
function DeleteOut() {
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var LeaveDelete = document.getElementById("LeaveDelete");
	if (len < 1) {
		// Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons:
		// Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	} else {
		myId = rowObj[0].get("rowid");
		var ee = cspRunServerMethod(LeaveDelete.value, myId);
		if (ee!=0) alert(ee);
	}
	Find();
}