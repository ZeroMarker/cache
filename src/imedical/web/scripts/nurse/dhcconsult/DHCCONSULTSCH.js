/**
 * @author Administrator
 */
var locdata = new Array();
var condata = new Array();
var person = new Array();

function BodyLoadHandler() {
	setsize("mygridpl", "gform", "mygrid");
	/*
	 * var mydate=new Date(); var stdate=Ext.getCmp("StDate"); var
	 * enddate=Ext.getCmp("endDate"); stdate.setValue(mydate.getDate());
	 * enddate.setValue(mydate.getDate()+3);
	 */
	// debugger;
	var grid = Ext.getCmp('mygrid');
	grid.on('click', gridclick);
	grid.on('dblclick', griddblclick);

	var tobar = grid.getTopToolbar();
	tobar.addItem({
		xtype: 'datefield',
		//format: 'Y-m-d',
		id: 'mygridstdate',
		value: (diffDate(new Date(), 0))
	}, {
		xtype: 'datefield',
		//format: 'Y-m-d',
		id: 'mygridenddate',
		value: (diffDate(new Date(), 1))
	}, "-", {
		xtype: 'checkbox',
		id: 'ExecFlag',
		checked: false,
		boxLabel: '已执行',
		handler: function(checkbox, checked) {
			if (checked) {
				Ext.getCmp("AllFlag").setValue(0);
			}
		}
	}, {
		xtype: 'checkbox',
		id: 'AllFlag',
		checked: false,
		boxLabel: '全部',
		handler: function(checkbox, checked) {
			if (checked) {
				Ext.getCmp("ExecFlag").setValue(0);
			}
		}
	}, "-");
	tobar.addButton({
		className: 'new-topic-button',
		text: "查询",
		icon: '../images/uiimages/search.png',
		handler: FindAdmConsult,
		id: 'mygridSch'
	});
	tobar.addItem('-');
	tobar.addButton({
		// className: 'new-topic-button',
		text: "执行",
		icon: '../images/uiimages/blue_arrow.png',
		handler: ChgConStatus2,
		id: 'butExcute'
	});
	tobar.addItem('-');
	tobar.addButton({
		// className: 'new-topic-button',
		text: "撤销执行",
		icon: '../images/uiimages/undo.png',
		handler: CancelConStatus,
		id: 'butCancel'
	});
	tobar.addItem('-');
	tobar.addButton({
		// className: 'new-topic-button',
		text: "打印",
		icon: '../images/uiimages/print.png',
		handler: printNurRec,
		id: 'butPrint'
	});
	tobar.addItem('-');
	tobar.addButton({
		// className: 'new-topic-button',
		text: "医嘱录入",
		icon: '../images/uiimages/register.png',
		handler: FindOrdEntry,
		id: 'rMenuOrd'
	});
	//grid.addListener('rowcontextmenu', rightClickFn);
	//grid.addListener('rowclick', rowClickFn);
	// tobar.render(grid.tbar);
	tobar.doLayout();
	var but = Ext.getCmp("mygridbut2");
	// but.on('click',ModConsult);
	but.hide();
	var but = Ext.getCmp("mygridbut1");
	// but.on('click',ModConsult);
	but.hide();
	
	FindAdmConsult();
	//Ext.getCmp("rMenuOrd").hide();
	grid.getBottomToolbar().hide();
	var cm=grid.getColumnModel();
	var needToHiddenColumns=["EpisodeId","RowID","ConDepID"];
	needToHiddenColumns.forEach(function(columnCode){
		var columnId=cm.findColumnIndex(columnCode);
		if(columnId!==-1){
			cm.setHidden(columnId,true); 
		}
	});
	window.onresize=function(){
		window.location.reload();
	};
}

function griddblclick() {
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;

	if (len < 1) {
		// Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons:
		// Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	} else {
		myId = rowObj[0].get("RowID");
		EpisodeID = rowObj[0].get("EpisodeId");
		/*
		 * for (i = 0; i < top.frames.length; i++) { alert(top.frames[i].name); }
		 */
		// var frm = top.frames[0].document.forms["fEPRMENU"];
		var win = top.frames['eprmenu'];
		if (win) {
			var frm = win.document.forms['fEPRMENU'];
		} else {
			var frm = top.document.forms['fEPRMENU'];
		}
		//frm.EpisodeID.value = EpisodeID;
		//frm.EpisodeID.value = EpisodeID;
		ModConsult();
	}
}

function rightClickFn(client, rowIndex, e) {
	e.preventDefault();
	grid = client;
	CurrRowIndex = rowIndex;
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len < 1) {
		//rightClick.showAt(e.getXY());
		alert("请选中一条记录!");
		return;
	} else {
		myId = rowObj[0].get("RowID");
		var rtn = cspRunServerMethod(GetOrdEntry, myId);
		alert("rtn:" + rtn);
		if (rtn == 0) {
			rightClick.showAt(e.getXY());
		} else {
			rightClickWithOrd.showAt(e.getXY());
		}
	}

}

function FindOrdEntry() {
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len < 1) {
		return;
	} else {
		myId = rowObj[0].get("RowID");
		var rtn = cspRunServerMethod(GetOrdEntry, myId);
		if (rtn == 0) {
			alert("申请医生未授权!");
			return;
		} else {

			EpisodeID = rowObj[0].get("EpisodeId");
			var PatientID = tkMakeServerCall("User.DHCConsultation", "getPatientID", EpisodeID)
			var lnk = "oeorder.entrysinglelogon.csp?EpisodeID=" + EpisodeID + "&ChartBookID=6&PatientID=" + PatientID;
			window.open(lnk, "chartbook", "toolbar=no,directories=no,height=700,width=1200,top=5,left=5");

		}
	}
}

function gridclick() {
	var grid = Ext.getCmp("mygrid");

	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;

	if (len < 1) {
		// Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons:
		// Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	} else {
		myId = rowObj[0].get("RowID");
		EpisodeID = rowObj[0].get("EpisodeId");
		/*
		 * for (i = 0; i < top.frames.length; i++) { alert(top.frames[i].name); }
		 */
		// var frm = top.frames[0].document.forms["fEPRMENU"];
		var win = top.frames['eprmenu'];
		if (win) {
			var frm = win.document.forms['fEPRMENU'];
		} else {
			var frm = top.document.forms['fEPRMENU'];
		}
		//frm.EpisodeID.value = EpisodeID;
	}
}

function FindAdmConsult() {
	condata = new Array();
	var stdate = Ext.getCmp("mygridstdate");
	var enddate = Ext.getCmp("mygridenddate");
	var GetListConsult = document.getElementById("GetListConsult");
	var ExecFlag = Ext.getCmp("ExecFlag").getValue();
	var AllFlag = Ext.getCmp("AllFlag").getValue();
	if (AllFlag == true) ExecFlag = "";
	cspRunServerMethod(GetListConsult.value, stdate.value, enddate.value, session['LOGON.CTLOCID'], "", "", "", ExecFlag, "addconsult","",consultId);

	var grid = Ext.getCmp("mygrid");
	// debugger;
	grid.store.loadData(condata);
}
var myId = "";

function ChgConStatus2() {
	condata = new Array();
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var ChangeStatus = document.getElementById("ChangeStatus");

	if (len < 1) {
		// Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons:
		// Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	} else {
		myId = rowObj[0].get("RowID");
		EpisodeID = rowObj[0].get("EpisodeId");
		var ConDepID = rowObj[0].get("ConDepID");
		var Contyp = rowObj[0].get("Contyp");	
		//alert("ConDepID=" + ConDepID)
		var ret = tkMakeServerCall('User.DHCConsultDepItm', 'GetConfig');
		var ifOpenMoreLocAuditExec = ret.split("^")[3];
		if(ifOpenMoreLocAuditExec=="Y"&&Contyp=="多科"){
			//tobar.remove("butExcute");
			alert("无法执行：多科会诊由审核部门执行！！");
			return ;
		}
		
		var ab = "E"
		var we = "Y"
			// alert(myId+"^"+ab+"^"+we+"^"+session['LOGON.USERID']+"^"+EpisodeID)
			// alert("@@@@@"+ChgConStatus)
		var ee = cspRunServerMethod(ChangeStatus.value, myId, ab, we, session['LOGON.USERID'], EpisodeID, ConDepID);
		// var
		// ee=cspRunServerMethod(ChgConStatus,myId,ab,we,ConDepID,EpisodeID);
		if ((ee != "") && (ee != 0)) alert(ee);
	}

	// debugger;
	// grid.store.loadData(condata);
	FindAdmConsult();
}

function CancelConStatus() {
	// alert(1);
	condata = new Array();
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var ChangeStatus = document.getElementById("ChangeStatus");

	if (len < 1) {
		// Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons:
		// Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	} else {
		myId = rowObj[0].get("RowID");
		EpisodeID = rowObj[0].get("EpisodeId");
		var ConDepID = rowObj[0].get("ConDepID");
		var Contyp = rowObj[0].get("Contyp");	
		//alert("ConDepID=" + ConDepID)
		var ret = tkMakeServerCall('User.DHCConsultDepItm', 'GetConfig');
		var ifOpenMoreLocAuditExec = ret.split("^")[3];
		if(ifOpenMoreLocAuditExec=="Y"&&Contyp=="多科"){
			//tobar.remove("butExcute");
			alert("多科会诊由审核部门执行，您无法撤销！！");
			return ;
		}
		var ab = "CE"
		var we = "N"
		var ee = cspRunServerMethod(ChangeStatus.value, myId, ab, we, session['LOGON.USERID'], EpisodeID, ConDepID);
		if ((ee != "") && (ee != 0)) alert(ee);
	}
	// debugger;
	// grid.store.loadData(condata);
	FindAdmConsult();
}
var docgradedata = new Array();
function adddocgrade(a, b) {
	docgradedata.push({
		id: a,
		desc: b
	});
}
function ModConsult() {
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var myRowId;
	if (len < 1) {
		// Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons:
		// Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	} else {
		myId = rowObj[0].get("RowID");
		myRowId = myId;
		EpisodeID = rowObj[0].get("EpisodeId");
		Status = rowObj[0].get("Status");
	}
	var arr = new Array();
	// 录入界面
	var a = cspRunServerMethod(pdata1, "", "DHCCONSULTPAT", EpisodeID, "");
	arr = eval(a);
	var window = new Ext.Window({
		title: '会诊',
		width: 700,
		height: 650,
		autoScroll: true,
		layout: 'absolute',
		// plain: true,
		// modal: true,
		// bodyStyle: 'padding:5px;',
		// /buttonAlign: 'center',
		items: arr,
		buttons: [{
			text: '中草药处方查询',
			icon:'../images/uiimages/search.png',
			handler: function() {
				PrescriptQuery();
			}
		}, {
			text: '保存',
			icon:'../images/uiimages/filesave.png',
			handler: function() {
				Save(window, myRowId);
				//window.close();
			}
		}, {
			text: '取消',
			icon:'../images/uiimages/cancel.png',
			handler: function() {
				window.close();
			}
		}, {
			text: '打印',
			icon:'../images/uiimages/print.png',
			handler: function() {
				printconsult(myRowId);
			}
		}]
	});
	var dep = Ext.getCmp("ConsultDep");
	if (dep != null) {
		cspRunServerMethod(getloc, 'addloc');
		dep.store.loadData(locdata);
		//dep.on('change', updatefindperson);
	}
	var ret1 = cspRunServerMethod(GetPatinfo, EpisodeID);
	var tt = ret1.split('^');
	var patid = Ext.getCmp("PatId");
	patid.setValue(getValueByCode(tt[16]));
	var ret = cspRunServerMethod(getSingleConsult, myRowId);
	var arr = ret.split("^");
	var dep = Ext.getCmp("ConsultDep");
	var appdate = Ext.getCmp("AppDate");
	var apptime = Ext.getCmp("AppTime");
	var typ = Ext.getCmp("ConType");
	var inout = Ext.getCmp("InOut");
	var patid = Ext.getCmp("PatId");
	var destin = Ext.getCmp("ConDestination");
	var atti = Ext.getCmp("Attitude");
	var cmbdoc = Ext.getCmp("ConsultDoc");
	cmbdoc.disable();
	var PatDoc = Ext.getCmp("PatDoc");
	var ConsultDate = Ext.getCmp("ConsultDate");
	ConsultDate.disable();
	var ConsultTime = Ext.getCmp("ConsultTime");
	ConsultTime.disable();

	var applytsy = Ext.getCmp("applytsy");
	//applytsy.disable();
	var attitudetsy = Ext.getCmp("attitudetsy");
	var RequestConDoc = Ext.getCmp("RequestConDoc");
	var DocGrade = Ext.getCmp("DocGrade");
	if (DocGrade) {	
	tkMakeServerCall("web.DHCConsult","getDocGrade","adddocgrade","DOCTOR");
		//cspRunServerMethod(getloc1, "adddocgrade","DOCTOR");
				DocGrade.store.loadData(docgradedata);
	}
	dep.value = arr[5];
	if (arr[5] != "") {
		getlistdata(arr[5], cmbdoc);
		getlistdata(arr[5], RequestConDoc);
	}
	//cmbdoc.on('specialkey', cmbkey);
	//if (cmbdoc) getlistdata("", cmbdoc);
	//if (RequestConDoc) getlistdata("", RequestConDoc);
	appdate.value = arr[0];
	apptime.value = arr[1];
	typ.value = arr[4];
	var attitudeArr = arr[2].split("@");
	var attitudeValue = "";
	for (var i = 0; i < attitudeArr.length; i++) {
		attitudeValue = attitudeValue + attitudeArr[i] + "\n";
	}
	atti.value = attitudeValue;
	destin.value = arr[3];
	inout.value = arr[7];
	if (arr[6] != "") {
		cmbdoc.value = arr[6];
	} else {
		cmbdoc.value = LogConDocId;
	}
	PatDoc.value = arr[8];
	if (arr[9] != "") {
		ConsultDate.value = arr[9];
	} else {
		ConsultDate.value = new Date();
	}
	if (arr[10] != "") {
		ConsultTime.value = arr[10];
	} else {
		ConsultTime.value = new Date().dateFormat('H:i');
	}
	RequestConDoc.value = arr[11];
	applytsy.value = arr[13];
	patid.value = arr[15].split("@")[1];
	DocGrade.value = arr[12];

	attitudetsy.value = arr[14];
	if (Status == "执行") {
		attitudetsy.disable();
	}
	// cmb.on('specialkey',cmbkey);
	window.show();
}

function getValueByCode(tempStr) {
	var retStr = tempStr;
	var strArr = tempStr.split("@");
	if (strArr.length > 1) {
		retStr = strArr[1];
	}
	return retStr;
}

function cmbkey(field, e) {
	if (e.getKey() == Ext.EventObject.ENTER) {
		var pp = field.lastQuery;
		getlistdata("", field);
		// alert(ret);
	}
}
var person = new Array();

function getlistdata(p, cmb) {
	var GetPerson = document.getElementById('GetPerson');
	// debugger;
	var ret = cspRunServerMethod(GetPerson.value, p);
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
		desc: a,
		id: b
	});
}

function addloc(a, b) {
	locdata.push({
		id: a,
		desc: b
	});
}

function addconsult(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v) {
	condata.push({
		ConDep: a,
		ConDoc: b,
		Status: c,
		BedCode: d,
		PatDep: e,
		InOut: f,
		Diag: g,
		Destination: h,
		PatName: i,
		AppTime: j,
		AppDate: k,
		ConDate: l,
		ConTime: m,
		EpisodeId: n,
		RowID: o,
		Contyp: p,
		ConDepID: q,
		RequestConDoc: r,
		RegNo: s,
		Bah: t,
		EncryptLevel: u,
		PatLevel: v
	});
}


function Save(window, myRowId) {
	var ret = "";
	var dep = Ext.getCmp("ConsultDep").value;
	var doc = Ext.getCmp("ConsultDoc").value;
	var ConsultDate = Ext.getCmp("ConsultDate").value;
	var ConsultTime = Ext.getCmp("ConsultTime").getValue();
	ConsultTime = DBC2SBC(ConsultTime);
	var typ = Ext.getCmp("ConType").value;
	var inout = Ext.getCmp("InOut").value;
	var atti = Ext.getCmp("Attitude").getRawValue();
	var attitudetsy = Ext.getCmp("attitudetsy").value;
	var applytsy = Ext.getCmp("applytsy").value;
	if ((applytsy != "") & (attitudetsy == "")) {
		Ext.Msg.alert('提示', "请选择'医生意见'再保存!");
		return;
	}
	if (ConsultDate == "") {
		Ext.Msg.alert('提示', "请选择'会诊日期'!");
		return;
	}
	if (ConsultTime == "") {
		Ext.Msg.alert('提示', "请填写'会诊时间'!");
		return;
	}
	var DocGrade = Ext.getCmp("DocGrade").value;
	if (DocGrade == "") {
		Ext.Msg.alert('提示', "请选择'医师级别'!");
		return;
	}
	ret = ret + "Attitude|" + atti + "^";
	// ret=ret+"Status|E^";
	ret = ret + "ConsultDoc|" + doc + "^";
	ret = ret + "id|" + myRowId + "^";
	ret = ret + "ConsultDate|" + ConsultDate + "^" + "ConsultTime|" + ConsultTime + "^";
	ret = ret + "DocGrade|" + DocGrade + "^";
	ret = ret + "attitudetsy|" + attitudetsy;
	//alert(ret)
	ret = cspRunServerMethod(SaveCon, ret);
	if (ret != 0) {
		alert(ret)
		return;
	}
	window.close();
	FindAdmConsult();
	// alert(ret);
}

function DBC2SBC(str) {
	var result = '';
	if ((str) && (str.length)) {
		for (var i = 0; i < str.length; i++) {
			var code = str.charCodeAt(i);
			if (code >= 65281 && code <= 65373) {
				result += String.fromCharCode(str.charCodeAt(i) - 65248);
			} else {
				if (code == 12288) {
					result += String.fromCharCode(str.charCodeAt(i) - 12288 + 32);
				} else {
					result += str.charAt(i);
				}
			}
		}
	} else {
		result = str;
	}
	return result;
}
function printNurRec() {
	var stdate = Ext.getCmp("mygridstdate");
	var enddate = Ext.getCmp("mygridenddate");
	var GetListConsult = document.getElementById("GetListConsult");
	var ExecFlag = Ext.getCmp("ExecFlag").getValue();
	var AllFlag = Ext.getCmp("AllFlag").getValue();
	if (AllFlag == true) ExecFlag = "";
	var mygrid=Ext.getCmp("mygrid");
	var colsum=mygrid.store.getCount();
	if(colsum==0)
	{
		alert("请先查询出数据再打印！")
		return;
	}
	var store = mygrid.getStore();
	var Adm=EpisodeID;
	if(Adm=="")
	{
		Adm=store.getAt(0).get("EpisodeId");
	}
	var EmrCode="DHCCONSULTSCH";
	var hospital=tkMakeServerCall("web.DHCConsult","gethospital",session['LOGON.CTLOCID'])
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","RHeadCaption",EmrCode,hospital);
	
	var LHeadCaption = "科室: " + LogLoc + "     时间段: " + stdate.value + " 至 " + enddate.value;
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","LHeadCaption",EmrCode,LHeadCaption);
	var prncode="DHCCONSULTSCHPRNMOULD";
	
	var parr = stdate.value + "!" + enddate.value + "!" + session['LOGON.CTLOCID'] + "!" + ExecFlag+ "!" + session['LOGON.USERID']
	var WebUrl=WebIp+"/dthealth/web/DWR.DoctorRound.cls";
	var EmrType=2;  //1:混合单 2：记录单 3：评估单
	
	var link=WebIp+"/dhcmg/PrintComm/PrintCommPic.application?method=PrintOut&EpisodeID="+Adm+"&EmrCode="+EmrCode+"&EmrType="+EmrType+"&ItmName="+prncode+"&Parrm="+parr+"&PrnLoc="+session['LOGON.CTLOCID']+"&PrnBed="+"&LabHead="+"&curhead="+"&WebUrl="+WebUrl;
	//alert(link)
	window.location.href=link;
}
function printNurRecold() {
	var stdate = Ext.getCmp("mygridstdate");
	var enddate = Ext.getCmp("mygridenddate");
	var GetListConsult = document.getElementById("GetListConsult");
	var ExecFlag = Ext.getCmp("ExecFlag").getValue();
	var AllFlag = Ext.getCmp("AllFlag").getValue();
	if (AllFlag == true) ExecFlag = "";
	var hospital=tkMakeServerCall("web.DHCConsult","gethospital",session['LOGON.CTLOCID'])
	PrintCommPic.RHeadCaption = hospital;
	//alert(hospital)
	//PrintCommPic.RHeadCaption = tm[1];
	PrintCommPic.LHeadCaption = "科室: " + LogLoc + "     时间段: " + stdate.value + " 至 " + enddate.value;
	//PrintCommPic.LFootCaption = tm[2];
	PrintCommPic.SetPreView("1");
	PrintCommPic.stPage = 0;
	PrintCommPic.stRow = 0;
	PrintCommPic.previewPrint = "0"; //是否弹出设置界面
	PrintCommPic.stprintpos = 0;
	//alert(WebIp)
	PrintCommPic.SetConnectStr(CacheDB);
	PrintCommPic.WebUrl = WebIp + "/dthealth/web/DWR.DoctorRound.cls";
	PrintCommPic.ItmName = "DHCCONSULTSCHPRNMOULD";//"DHCCONSULTLISTPRNMOULD";//
	PrintCommPic.ID = "";
	PrintCommPic.MultID = "";
	PrintCommPic.MthArr = "";
	var parr = stdate.value + "!" + enddate.value + "!" + session['LOGON.CTLOCID'] + "!" + ExecFlag+ "!" + session['LOGON.USERID']
	PrintCommPic.SetParrm(parr);
	PrintCommPic.PrintOut();
}

function printconsultold(myid) {
	PrintCommPic.SetConnectStr(CacheDB);
	// 会诊print
	PrintCommPic.ItmName = "DHCConsultPrn";
	// debugger;
	PrintCommPic.WebUrl = WebIp + "/dthealth/web/DWR.DoctorRound.cls";
	PrintCommPic.ID = "";
	PrintCommPic.MultID = "";
	PrintCommPic.MthArr = "web.DHCConsult:getConsultInfo&id:" + myid;
	// debugger;
	PrintCommPic.PrintOut();
	//ExcuteConsult();
}
function printconsult(myid,Status) {
	
	var hospital=tkMakeServerCall("web.DHCConsult","gethospital",session['LOGON.CTLOCID'])
	var ItmName="DHCConsultPrn";
	var MthArr="";
	if(Status=="待审"){
		MthArr = "web.DHCConsult:getConsultInfoApply$id:" + myid;
	}
	else{
		MthArr = "web.DHCConsult:getConsultInfo$id:" + myid;
	}
	var EmrCode="DHCCONSULTPAT";
	var WebUrl=WebIp+"/dthealth/web/DWR.DoctorRound.cls";
	var EmrType=5;
	var link=WebIp+"/dhcmg/PrintComm/PrintCommPic.application?method=PrintOut&EpisodeID="+EpisodeID+"&EmrCode="+EmrCode+"&EmrType="+EmrType+"&ItmName="+ItmName+"&MthArr="+MthArr+"&RHead="+hospital+"&WebUrl="+WebUrl;
	
	window.location.href=link;
}
function ExcuteConsult() {
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len > 0) {
		var ConStatus = rowObj[0].get("Status");
		if (ConStatus == "申请") ChgConStatus2();
	}
}

function PrescriptQuery() {
	var EpisodeID = "";
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len > 0) {
		EpisodeID = rowObj[0].get("EpisodeId");
	}
	if (EpisodeID == "") {
		Ext.Msg.alert('提示', "请先选择一条会诊记录!");
		return;
	}
	var mradm = ""; //document.getElementById('mradm').value;
	var Days = 15;
	var PatientID = tkMakeServerCall("User.DHCConsultation", "getPatientID", EpisodeID)
	var presurl = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCPrescriptQueryCM&EpisodeID=" + EpisodeID + "&Days=" + Days + "&mradm=" + mradm + "&loc=" +"&PatientID="+PatientID;// session['LOGON.CTLOCID']
	var window = new Ext.Window({
		title: '中草药处方查询',
		width: 900,
		height: 450,
		autoScroll: true,
		layout: 'absolute',
		plain: true,
		frame: true,
		modal: true,
		//bodyStyle: 'padding:5px;',
		//buttonAlign: 'center',
		//items: ''
		html: '<iframe id ="southTab" name="ddd" style="width:100%; height:100%" src=' + presurl + ' ></iframe>',
		buttonAlign: 'center',
		buttons: [{
			text: '复制到会诊意见',
			icon:'../images/uiimages/copy1.png',
			handler: function() {
				CopyToAttitude(EpisodeID);
				window.close();
			}
		}]
	});
	window.show();
}

function CopyToAttitude(EpisodeID) {
	var copystr = "";
	var parentwin = Ext.get("southTab").dom.contentWindow;
	var objtbl = parentwin.document.getElementById("tUDHCPrescriptQueryCM");
	var rows = objtbl.rows.length;
	for (var i = 1; i < rows; i++) {
		copystr = "中草药处方:\n";
		var selectcheck = parentwin.document.getElementById('selectz' + i);
		if (selectcheck.checked == true) {
			var prescnoprint = parentwin.document.getElementById('prescnoz' + i);
			var presc = prescnoprint.value;
			var obj = cspRunServerMethod(getinfo, EpisodeID, presc);
			var str1 = obj.split("^");
			var DurationDesc = str1[10];
			var UseMethod = str1[11];
			var PHCINDesc = str1[22];
			var info1 = str1[14];
			//alert("用药副数"+DurationDesc+",频率"+PHCINDesc+",医嘱"+info1);
			var str2 = info1.split("|");
			for (var k = 0; k < str2.length - 1; k++) {
				var cy1 = str2[k].split("%");
				copystr = copystr + "  " + cy1[0];
				if ((k != str2.length - 2) && ((k + 1) % 4 == 0)) copystr = copystr + "\n";
			}
			copystr = copystr + "\n  用药副数 " + DurationDesc + "   频率 " + PHCINDesc + " 用法 "+UseMethod;
				//alert(copystr);
			var atti = Ext.getCmp("Attitude");
			var attivalue = atti.getRawValue();
			if (attivalue != "") copystr = "\n" + copystr;
			atti.setValue(attivalue + copystr);
		}
	}
}