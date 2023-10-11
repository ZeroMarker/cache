/**
 * @author Administrator
 */
 
function BodyLoadHandler() {
	setsize("mygridpl", "gform", "mygrid");
	var grid = Ext.getCmp("mygrid");
	var len = grid.getColumnModel().getColumnCount();
		for(var i = 0 ;i < len;i++){
			if(grid.getColumnModel().getDataIndex(i) == 'EpisodeId'){
				grid.getColumnModel().setHidden(i,true);
			}
			if(grid.getColumnModel().getDataIndex(i) == 'RowID'){
				grid.getColumnModel().setHidden(i,true);
			}
			if(grid.getColumnModel().getDataIndex(i) == 'ConDepID'){
				grid.getColumnModel().setHidden(i,true);
			}
			if(grid.getColumnModel().getDataIndex(i) == 'ConDocID'){
				grid.getColumnModel().setHidden(i,true);
			}
		}
	var but = Ext.getCmp("mygridbut1");
	but.on('click', huizhen);
	but.setIcon('../images/uiimages/edit_add.png');
	var but = Ext.getCmp("mygridbut2");
	but.on('click', ModConsult);
	but.setIcon('../images/uiimages/editstatu.png');
	var grid = Ext.getCmp('mygrid');
	grid.on('click', gridclick);
	grid.on('dblclick', griddblclick);

	var tobar = grid.getTopToolbar();
	tobar.addButton({
		// className: 'new-topic-button',
		text: "撤销",
		icon: '../images/uiimages/undo.png',
		handler: CancelConStatus,
		id: 'butCancel'
	});
	tobar.addItem("-", {
		xtype: 'datefield',
		//format: 'Y-m-d',
		id: 'mygridstdate',
		value: (diffDate(new Date(), -2))
	}, {
		xtype: 'datefield',
		//format: 'Y-m-d',
		id: 'mygridenddate',
		value: (diffDate(new Date(), 0))
	}, "-", {
		xtype: 'checkbox',
		id: 'AllFlag',
		checked: false,
		boxLabel: '全科'
	},
	stateCombo,
	"-");
	tobar.addButton({
		text: "查询",
		icon: '../images/uiimages/search.png',
		handler: FindAdmConsult,
		id: 'butFind'
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

		text: "开启授权",
		icon: '../images/uiimages/permission.png',
		handler: OpenAuthorization,
		id: 'butOpenAuthorization'
	});
	tobar.addItem('-');
	tobar.addButton({

		text: "关闭授权",
		icon: '../images/uiimages/un_permission.png',
		handler: CloseAuthorization,
		id: 'butCloseAuthorization'
	});
	tobar.addItem('-');
	tobar.addButton({

		text: "开启医嘱录入",
		icon: '../images/uiimages/patient_green.png',
		handler: OpenOrdEntry,
		id: 'butOpenOrdEntry'
	});
	tobar.addItem('-');
	tobar.addButton({

		text: "关闭医嘱录入",
		icon: '../images/uiimages/patient_red.png',
		handler: CloseOrdEntry,
		id: 'butCloseOrdEntry'
	});
	tobar.doLayout();
	FindAdmConsult();
	var obj = Ext.getCmp("AllFlag");
	obj.on('check', setcheck);
	//Ext.getCmp("butOpenOrdEntry").hide();
	//Ext.getCmp("butCloseOrdEntry").hide();
	grid.getBottomToolbar().hide()
	Ext.getCmp("mygridstdate").setDisabled(true)
	Ext.getCmp("mygridenddate").setDisabled(true)
	grid.setTitle("会诊申请")
	
	window.onresize=function(){
		window.location.reload();
	}
}
var stateCombo = new Ext.form.ComboBox({
    typeAhead: true,
    triggerAction: 'all',
    lazyRender:true,
    mode: 'local',
	emptyText:'状态',
	width:60,
    store: new Ext.data.ArrayStore({
        id: 0,
        fields: [
            'stateCode',
            'stateDesc'
        ],
        data: [['V', '申请'], ['E', '执行'], ['C', '撤销'], ['W', '待审'], ['R', '拒绝']]
    }),
    valueField: 'stateCode',
    displayField: 'stateDesc'
});
var form;
var locdata = new Array();
var condata = new Array();

function setcheck() {
	var checkval = Ext.getCmp("AllFlag").getValue();
	if (checkval) {
		Ext.getCmp("mygridstdate").setDisabled(false)
		Ext.getCmp("mygridenddate").setDisabled(false)
		FindAdmConsult();
	} else {
		Ext.getCmp("mygridstdate").setDisabled(true)
		Ext.getCmp("mygridenddate").setDisabled(true)
		FindAdmConsult();
	}

}

function FindAdmConsult() {
	condata = new Array();
	var stdate = Ext.getCmp("mygridstdate");
	var enddate = Ext.getCmp("mygridenddate");
	var AllFlag = Ext.getCmp("AllFlag").getValue();
	var ExecFlag =stateCombo.getValue();
	//alert("stdate="+stdate.value+" enddate="+enddate.value+" AllFlag="+AllFlag);
	var ret1 = tkMakeServerCall('User.DHCConsultDepItm', 'GetConfig');
	var ifOpenMoreLocAudit = ret1.split("^")[2];
	if(ifOpenMoreLocAudit=="Y"){
		cspRunServerMethod(GetConsultApply, EpisodeID + "^" + stdate.value + "^" + enddate.value + "^" + AllFlag + "^" + session['LOGON.CTLOCID']+"^"+ExecFlag, "addconsult");
	}else{
		cspRunServerMethod(GetConsult, EpisodeID + "^" + stdate.value + "^" + enddate.value + "^" + AllFlag + "^" + session['LOGON.CTLOCID']+"^"+ExecFlag, "addconsult");
	}
	
	var grid = Ext.getCmp("mygrid");
	//grid.width = document.body.offsetWidth;
	grid.store.loadData(condata);
}
var myId = "";

function ModConsult() {	
	var dish = cspRunServerMethod(GetDish, EpisodeID);
	if (dish == 1) {
		alert("已做医疗结算!");
		return;
	}	
	var grid = Ext.getCmp("mygrid");	
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var Status = rowObj[0].get("Status");
	if (Status == "拒绝") {
		alert("被拒绝的会诊拒绝修改,请新建会诊申请!");
		return;
	}
	if (len < 1) {
		// Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons:
		// Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	} else {
		myId = rowObj[0].get("RowID");
		myRowId = myId; ////防止弹出新窗口后又点击了其他会诊
	}

	var arr = new Array();
	// 录入界面
	var a = cspRunServerMethod(pdata1, "", "DHCCONSULTPAT", EpisodeID, "");
	arr = eval(a);
	if (Status == "执行") {
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
				text: '取消',
				icon:'../images/uiimages/cancel.png',
				handler: function() {
					window.close();
				}
			}, {
				text: '打印',
				icon:'../images/uiimages/print.png',
				handler: function() {
					printconsult(myId,Status);
				}
			}]
		});

	} else {
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
				id:'modSave',
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
					printconsult(myRowId,Status);
				}
			}]
		});
	}

	var ret1 = cspRunServerMethod(GetPatinfo, EpisodeID);
	var tt = ret1.split('^');
	var patid = Ext.getCmp("PatId");
	patid.setValue(getValueByCode(tt[16]));
	var dep = Ext.getCmp("ConsultDep");
	if (dep != null) {
		cspRunServerMethod(getloc, 'addloc');
		dep.store.loadData(locdata);
		dep.on('change', updatefindperson);
	}
	var ret ="";
	if(Status=="待审"){
		ret = cspRunServerMethod(getSingleConsultApply, myId);
		var dep = Ext.getCmp("ConsultDep");
		var modSave = Ext.getCmp("modSave");
		modSave.hide();
		dep.disable();
	}else{
		ret = cspRunServerMethod(getSingleConsult, myId);
	}	
	//console.log(ret);
	var arr = ret.split("^");
	var dep = Ext.getCmp("ConsultDep");
	var appdate = Ext.getCmp("AppDate");
	var apptime = Ext.getCmp("AppTime");
	var typ = Ext.getCmp("ConType");
	var patid = Ext.getCmp("PatId");
	var inout = Ext.getCmp("InOut");
	var diag = Ext.getCmp("Diag");
	diag.disable();

	diag.setValue(getValueByCode(tt[8]));
	var destin = Ext.getCmp("ConDestination");
	var atti = Ext.getCmp("Attitude");
	var cmbdoc = Ext.getCmp("ConsultDoc");
	var PatDoc = Ext.getCmp("PatDoc");
	var ConsultDate = Ext.getCmp("ConsultDate");
	var ConsultTime = Ext.getCmp("ConsultTime");
	var RequestConDoc = Ext.getCmp("RequestConDoc");
	var DocGrade = Ext.getCmp("DocGrade");
	if (DocGrade) {	
		cspRunServerMethod(getloc1, "adddocgrade","DOCTOR");
				DocGrade.store.loadData(docgradedata);
		DocGrade.on('select',function(){
			var cmbLocValue = Ext.getCmp("ConsultDep").getValue();
			RequestConDoc.setValue("");
			if(cmbLocValue=="") cmbLocValue=arr[5];
			selectdocid = DocGrade.value;
			if(selectdocid=="") selectdocid=arr[12];
			findpersonByGrade(cmbLocValue,selectdocid, "", "");
		});
	}
	
	var applytsy = Ext.getCmp("applytsy");
	//applytsy.disable();
	var attitudetsy = Ext.getCmp("attitudetsy");
	dep.value = arr[5];
	if (arr[5] != "") {
		//person = new Array();
		//getlistdata(arr[5], cmbdoc);
		//person = new Array();
		//getlistdata(arr[5], RequestConDoc);
		findpersonByGrade(arr[5],arr[12], "", "");
	}
	//cmbdoc.on('specialkey', cmbkey);
	//RequestConDoc.on('specialkey', cmbkey);
	//if (cmbdoc) getlistdata("", cmbdoc);
	//if (RequestConDoc) getlistdata("", RequestConDoc);
	appdate.value = arr[0];
	apptime.value = arr[1];
	typ.value = arr[4];
		if (typ.value == "M") {
			Ext.getCmp("MoreLoc_1").setValue("on");
		} else {
			Ext.getCmp("MoreLoc_1").setValue("none");
		}
	var attitudeArr = arr[2].split("@");
	var attitudeValue = "";
	for (var i = 0; i < attitudeArr.length; i++) {
		attitudeValue = attitudeValue + attitudeArr[i] + "\n";
	}
	atti.value = attitudeValue;
	destin.value = arr[3];
	inout.value = arr[7];
	patid.value = arr[15].split("@")[1];
	cmbdoc.value = arr[16];	
	cmbdoc.disable();
	//cmbdoc.setRawValue(arr[16]);
	PatDoc.value = arr[8];
	ConsultDate.value = arr[9];
	ConsultTime.value = arr[10];
	RequestConDoc.value = arr[11];
	DocGrade.value = arr[12];
	applytsy.value = arr[13];
	attitudetsy.value = arr[14];
	if (Status == "执行") {
		destin.disable();
	}
	var objapplytsy = Ext.getCmp("applytsy");
	objapplytsy.disable();
	var objattitudetsy = Ext.getCmp("attitudetsy");
	objattitudetsy.disable();
	window.show();
}

function OpenAuthorization() {
	condata = new Array();
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var ChangeStatus = document.getElementById("ChangeStatus");
	if (len < 1) {
		//Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	} else {
		var Contyp = rowObj[0].get("Contyp");
		if(Contyp=="多科"){
			Ext.Msg.show({
			title: '注意',
			msg: '多科会诊不开启病历授权!',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
			});
			return;
		}
		myId = rowObj[0].get("RowID");
		EpisodeID = rowObj[0].get("EpisodeId");
		var ConsdocID = rowObj[0].get("ConDocID"); //RequestConDocID
		ConsdocID = tkMakeServerCall("User.DHCConsultation", "getRequestDocId", myId)
		var ConslocID = rowObj[0].get("ConDepID"); //ConsultDep

		ConsultType = "I"
		var tmpConsultType = rowObj[0].get("InOut");
		if (tmpConsultType == "院外") {
			ConsultType = "O";
		}
		//alert("ConsultType="+ConsultType)
		//var ab="C"
		//var we="N"
		//var ee=cspRunServerMethod(ChangeStatus.value,myId,ab,we,session['LOGON.USERID'],EpisodeID);
		//if (ee!="") alert(ee);
		//var window = new Ext.Window
		//window.show();
		//var link="epr.newfw.actionauthorize.csp?"+"&EpisodeID="+EpisodeID+"&ConsultID="+myId+"&ConsdocID="+ConsdocID+"&ConsultType="+"院内";
		//window.open (link,'test','height=650,width=450,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no') 
		//epr.newfw.actionauthorize.csp 页面参数：   EpisodeID（患者就诊ID）ConsultID（会诊申请ID）ConsdocID（会诊医生ID）ConsultType （会诊类型：院内或院外）

		//alert(rowObj[0].get("RequestConDoc"));
		//alert(rowObj[0].get("ConDep"));
		var win = new Ext.Window({
			id: 'authorizeWin',
			layout: 'fit', //自动适应Window大小 
			width: 500,
			height: 500,
			title: '会诊病历授权',
			//animCollapse:true,
			//closeAction:'hide',
			animateTarget: 'btnAuthorize',
			//collapsible: true,
			//maximizable:false,
			raggable: true, //不可拖动
			modal: true, //遮挡后面的页面
			resizable: true, //重置窗口大小
			//items:fromPanel
			html: '<iframe id="frmAuthorize" style="width:100%; height:100%" src="epr.newfw.actionauthorize.csp?EpisodeID=' + EpisodeID + '&ConsultID=' + myId + '&ConsdocID=' + ConsdocID + '&ConslocID=' + ConslocID + '&AppointType=1&ConsultType=' + ConsultType + '"></iframe>'
		});
		win.show(this);
	}

	////debugger;
	//FindAdmConsult();
}

function CloseAuthorization() {

	condata = new Array();
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len < 1) {
		//Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	} else {
		myId = rowObj[0].get("RowID");
		EpisodeID = rowObj[0].get("EpisodeId");
		var ee = tkMakeServerCall("EPRservice.browser.BOConsultation", "FinishConsultation", myId);
		if (ee != "1") alert(ee);
		//##Class(EPRservice.browser.BOConsultation).FinishConsultation(AConsultID)

	}

	//FindAdmConsult();
}

function OpenOrdEntry() {
	condata = new Array();
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;

	if (len < 1) {
		Ext.Msg.show({
			title: '注意',
			msg: '请先选择一条会诊数据!',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return;
	} else {
		var Contyp = rowObj[0].get("Contyp");
		var Status = rowObj[0].get("Status");
		if((Contyp=="多科")&&(Status=="待审")){
			Ext.Msg.show({
			title: '注意',
			msg: '待审状态的多科会诊不能开启医嘱授权，审核后再操作!!!',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
			});
			return;
		}
		myId = rowObj[0].get("RowID");
		EpisodeID = rowObj[0].get("EpisodeId");
		var rtn = cspRunServerMethod(OpenOrd, myId);
		if (rtn != 0) alert(rtn);
		else {
			alert("开启成功");
		}
	}
}

function CloseOrdEntry() {
	condata = new Array();
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;

	if (len < 1) {
		Ext.Msg.show({
			title: '注意',
			msg: '请先选择一条会诊数据!',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return;
	} else {
		myId = rowObj[0].get("RowID");
		EpisodeID = rowObj[0].get("EpisodeId");
		var rtn = cspRunServerMethod(CloseOrd, myId);
		if (rtn != 0) alert(rtn);
		else {
			alert("关闭成功");
		}
	}
}

function getValueByCode(tempStr) {
	var retStr = tempStr;
	var strArr = tempStr.split("@");
	if (strArr.length > 1) {
		retStr = strArr[1];
	}
	return retStr;
}

function printconsultold(myid,Status) {
	PrintComm.SetConnectStr(CacheDB);
	PrintComm.WebUrl = WebIp + "/dthealth/web/DWR.DoctorRound.cls";
	var hospital=tkMakeServerCall("web.DHCConsult","gethospital",session['LOGON.CTLOCID'])
	PrintComm.RHeadCaption = hospital;
	PrintComm.ItmName = "DHCConsultPrn";
	///PrintComm.LHeadCaption="22"
	// debugger;
	PrintComm.ID = "";
	PrintComm.MultID = "";
	if(Status=="待审"){
		PrintComm.MthArr = "web.DHCConsult:getConsultInfoApply&id:" + myid;
	}
	else{
		PrintComm.MthArr = "web.DHCConsult:getConsultInfo&id:" + myid;
	}
	
	// debugger;
	PrintComm.PrintOut();
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
	var WebUrl=WebIp+"/dthealth/web/DWR.DoctorRound.cls";
	var EmrType=5;
	var link=WebIp+"/dhcmg/PrintComm/PrintCommPic.application?method=PrintOut&EpisodeID="+EpisodeID+"&EmrCode="+EmrCode+"&EmrType="+EmrType+"&ItmName="+ItmName+"&MthArr="+MthArr+"&RHead="+hospital+"&WebUrl="+WebUrl;
	window.location.href=link;
}
function clearperson(name) {
	person = new Array();
	var cmb = Ext.getCmp(name);
	cmb.store.loadData(person);
}

function huizhen() {
	myId = "";
	var arr = new Array();
	// 录入界面

	var ifCanCreateConsult = tkMakeServerCall("User.DHCConsultation", "ifCanCreateConsult", EpisodeID)
	if (ifCanCreateConsult != 0) {
		alert(ifCanCreateConsult)
		return;
	}
	var dish = cspRunServerMethod(GetDish, EpisodeID);
	if (dish == 1) {
		alert("已做医疗结算,不能会诊申请!");
		return;
	}
	var a = cspRunServerMethod(pdata1, "", "DHCCONSULTPAT", EpisodeID, "", "");
	//alert(a);
	arr = eval(a);
	var store = new Ext.data.JsonStore({
		data: [],
		fields: ['desc', 'id']
	});
	var combo = {
		name: 'MultiLoc',
		id: 'MultiLoc',
		tabIndex: '0',
		x: 484,
		y: 61,
		height: 21,
		width: 152,
		xtype: 'combo',
		store: store,
		displayField: 'desc',
		valueField: 'id',
		allowBlank: true,
		triggerAction: 'all',
		tpl: '<tpl for="."><div class="x-combo-list-item"><span><input type="checkbox" {[values.check?"checked":""]}  value="{[values.id]}" /></span><span >{desc}</span></div></tpl>',
		emptyText: '请选择',
		selectOnFocus: true,
		//applyTo:'local-descs',
		mode: 'local',
		onSelect: function(record, index) {
			if (this.fireEvent('beforeselect', this, record, index)) {
				record.set('check', !record.get('check'));
				var str = []; //页面显示的值
				var strvalue = []; //传入后台的值
				this.store.each(function(rc) {
					if (rc.get('check')) {
						str.push(rc.get('desc'));
						strvalue.push(rc.get('id'));
					}
				});
				this.setValue(str.join());
				this.value = strvalue.join();
				this.valueId = strvalue.join();
				var typObj = Ext.getCmp("ConType");
				var MoreLocObj = Ext.getCmp("MoreLoc_1");
				if (strvalue.length > 1) {
					if (typObj) {
						typObj.setValue("M");
					}
					if (MoreLocObj) {
						MoreLocObj.setValue("on");
					}
				} else {
					if (typObj) {
						typObj.setValue("C");
					}
					if (MoreLocObj) {
						MoreLocObj.setValue("none");
					}
				}

				//this.collapse();
				this.fireEvent('select', this, record, index);
				//findperson(record.get('id'), record, index);
				if (this.valueId == '') {
					clearperson('RequestConDoc');
				}
				//if (this.valueId==null||this.valueId==''||this.valueId.split(",").length>1)
				//{
				//clearperson('RequestConDoc');
				//}
			}
		},
		value: '',
		valueId: ''
	};
	for (var i = 0; i < arr.length; i++) {
		if (arr[i].name == 'ConsultDep') {
			arr[i] = combo;
		}
	}
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
			text: '保存',
			icon:'../images/uiimages/filesave.png',
			handler: function() {
				Save(window, "");
				//window.close();
			}
		}, {
			text: '取消',
			icon:'../images/uiimages/cancel.png',
			handler: function() {
				window.close();
			}
		}]
	});
	//window.show();
	//return;
	var ret1 = cspRunServerMethod(GetPatinfo, EpisodeID);
	var tt = ret1.split('^');
	var patid = Ext.getCmp("PatId");
	patid.setValue(getValueByCode(tt[9]));
	var mydate = new Date();
	var appdate = Ext.getCmp("AppDate");
	appdate.disable();
	appdate.setValue(diffDate(mydate, 0));
	var apptime = Ext.getCmp("AppTime");
	apptime.disable();
	var cmbdoc = Ext.getCmp("ConsultDate");
	cmbdoc.disable();
	var diag = Ext.getCmp("Diag");
	diag.disable();

	diag.setValue(getValueByCode(tt[8]));
	var ConsultTime = Ext.getCmp("ConsultTime");
	ConsultTime.disable();
	var condoc = Ext.getCmp("ConsultDoc");
	condoc.disable();
	var atti = Ext.getCmp("Attitude");
	atti.disable();
	var time = mydate.getMinutes();
	if (time < 10) {
		time = "0" + time;
	}
	apptime.setValue(mydate.getHours() + ":" + time);
	var PatDoc = Ext.getCmp("PatDoc");
	PatDoc.setValue(session['LOGON.USERNAME']);
	var dep = Ext.getCmp("ConsultDep");
	if (dep != null) {
		cspRunServerMethod(getloc, 'addloc');
		dep.store.loadData(locdata);
		dep.on('select', findperson);
	}
	var MultLoc = Ext.getCmp("MultiLoc");
	MultLoc.on('beforequery',function (e) {
				// 在文本框内输入拼音时，根据store内code进行过滤，在下拉列表中只显示拼音匹配的选项
				var combo = e.combo;
				var me = this;
				if (!e.forceAll) {
					var input = e.query;
					var regExp = new RegExp("^" + input + ".*", "i");
					combo.store.filterBy(function (record, id) {
						var text = getPinyin(record.get('desc'));
						return regExp.test(text) | regExp.test(record.data[me.displayField]);
					});
					combo.expand();
					combo.select(0, true);// 将光标默认指向下拉列表的第一项，这样在取到合适的选项时，通过上下方向键和回车就可以选中需要的结果
					return false;
				}
			});
	var inout = Ext.getCmp("InOut");
	inout.on('select',function(){
		var HosId = session['LOGON.HOSPID'];
		locdata = new Array();		
		cspRunServerMethod(getloc, "addloc",HosId,inout.value);
		MultLoc.store.loadData(locdata);
		
	});
	if (MultLoc) {
		var HosId = session['LOGON.HOSPID'];		
		cspRunServerMethod(getloc, "addloc",HosId,inout.value);
				MultLoc.store.loadData(locdata);
	}
	var MoreLoc = Ext.getCmp("MoreLoc_1");
	MoreLoc.disable()
	var typ = Ext.getCmp("ConType");
	typ.on('change', function() {
		var typ = this.getValue();
		if (typ == "M") {
			Ext.getCmp("MoreLoc_1").setValue("on");
		} else {
			Ext.getCmp("MoreLoc_1").setValue("none");
		}
	}, typ);
	MoreLoc.on('check', function() {
		if (this.checked) {
			Ext.getCmp("ConType").setValue("M");
		} else {
			Ext.getCmp("ConType").setValue("C");
		}
	}, MoreLoc);
	var DocGrade = Ext.getCmp("DocGrade")
	if (DocGrade) {	
		cspRunServerMethod(getloc1, "adddocgrade","DOCTOR");
				DocGrade.store.loadData(docgradedata);
	}
	DocGrade.on('select', findgardedoc);
	var cmb = Ext.getCmp("ConsultDoc");
	cmb.on('specialkey', cmbkey);
	var cmb = Ext.getCmp("RequestConDoc");
	cmb.on('select', selectdoc);
	cmb.on('specialkey', cmbkey);
	var objapplytsy = Ext.getCmp("applytsy");
	objapplytsy.disable();
	var objattitudetsy = Ext.getCmp("attitudetsy");
	objattitudetsy.disable();
	//debugger;
	window.show();
}

function selectdoc(obj, record, index) {
	var selectdocid = obj.value
		//alert(admdoc)
	if (selectdocid == admdoc) {
		Ext.Msg.show({
			title: '注意',
			msg: '不能选择病人主管医生!',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		Ext.getCmp("RequestConDoc").setValue("");
		//obj.value="";
	}
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

function findperson(loc, record, index) {
	//alert(combo.value+"^"+record+"^"+index);
	person = new Array();
	var cmb = Ext.getCmp("RequestConDoc");
	cmb.store.loadData(person);
	if (loc != "") getlistdata(loc, cmb);
}

function findperson1(combo, record, index) {
	//alert(combo.value+"^"+record+"^"+index);
	person = new Array();
	var cmb = Ext.getCmp("RequestConDoc");
	cmb.store.loadData(person);
	if (combo.value != "") getlistdata(combo.value, cmb);
}

function updatefindperson(field, newValue, oldValue) {
	//alert(field.value+","+newValue+","+oldValue);
	person = new Array();
	var cmb = Ext.getCmp("RequestConDoc");
	cmb.setValue("");
	cmb.store.loadData(person);
	if (newValue != "") getlistdata(newValue, cmb);
	var cmbdoc = Ext.getCmp("ConsultDoc");
	cmbdoc.setValue("");
	cmbdoc.store.loadData(person);
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
var docgradedata = new Array();
function adddocgrade(a, b) {
	docgradedata.push({
		id: a,
		desc: b
	});
}

function addconsult(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, r, s, t, u, v, w, x) {
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
		RequestConDoc: r,
		RegNo: s,
		Bah: t,
		EncryptLevel: u,
		PatLevel: v,
		ConDocID: w,
		ConDepID: x
	});
}
///需要审核时，保存审核申请方法
///appdate, apptime,typ：会诊类型：M多科会诊,Diag：诊断
///isemer:急诊标志locArr:会诊科室数组
function SaveAudit(appdate, apptime,typ,inout,Diag,destin,isemer,locArr) {

	var ret = "",
	dep = ""
	
	if (typ != "M") {
		Ext.Msg.alert("非多科会诊")
		return;
	}
	
	if (inout == undefined||inout==""||inout==null) {
		Ext.Msg.alert('提示', "请选择'院内院外'!");
		return;
	}

	//var destin = destin; ///病情摘要
	var despurpose = destin;///会诊目的
	if ((destin == "") || (despurpose == "")) {
		alert("病情摘要和会诊目的为必填项")
		return;
	}

	if (typ == "M") {
		var MoreConPlace = "";//Ext.getCmp("ConPlace").getRawValue(); ///多科会诊地点
		var MoreConTime = "";//Ext.getCmp("ConTime").getRawValue(); ///多科会诊时间
	} else {
		var MoreConPlace = "";
		var MoreConTime = "";
	}
	
	for (var r = 0; r < locArr.length; r++) {
		//会诊科室id
		var RItmLoc = locArr[r]; //要求会诊子科室
		var gg = RItmLoc;//gridResult.getStore().getAt(r).get('ConsultLocID'); 
		if (dep == "") {
			dep = gg + "#" + RItmLoc;
		} else {
			dep = dep + "!" + gg + "#" + RItmLoc;
		}
	}
	var dep = "ConsultDep|" + dep + "^";

	//*************************************************
	var emergen = "";
	//var isemer = Ext.getCmp("emergency").getValue();
	if (isemer == true) {
		emergen = "E"
	} else {
		emergen = ""
	}
	ret = ret + "AppDate|" + appdate + "^";
	ret = ret + "AppTime|" + apptime + "^";
	ret = ret + "ConType|" + typ + "^";
	ret = ret + "InOut|" + inout + "^";
	ret = ret + "ConDestination|" + destin + "^";
	ret = ret + "ConDestinationtwo|" + despurpose + "^";
	ret = ret + "Diag|" + Diag + "^";
	ret = ret + "EpisdeID|" + EpisodeID + "^";
	ret = ret + "Status|W^";
	ret = ret + "AppDep|" + session['LOGON.CTLOCID'] + "^";
	ret = ret + "AppDoc|" + session['LOGON.USERID'] + "^";
	ret = ret + "Diag|" + Diag + "^";
	ret = ret + "EmergenCon|" + emergen + "^";
	ret = ret + "MoreConPlace|" + MoreConPlace + "^"; //地点
	ret = ret + "MoreConTime|" + MoreConTime + "^"; //时间
	ret = ret + dep;

	if (typ == "M") {
		var result = tkMakeServerCall("User.DHCConSultationNew", "Save", ret);
		var resultArr = result.split("^");
		if (resultArr[0] == "0") {
			alert("发送成功")
			//alert(resultArr[1])
			window.returnValue = "M" + resultArr[1]; ; ///+resultArr[1];
			window.close();
			FindAdmConsult();
		}
	} 
}

///新建会诊申请
function Save(window, myId) {
	var ret = "";
	var depObj = Ext.getCmp("ConsultDep");
	if (depObj) {
		var dep = depObj.value;
	} else {
		var dep = "";
	}
	var appdate = Ext.getCmp("AppDate").value;
	var apptime = Ext.getCmp("AppTime").getValue();
	var strtime = apptime.trim();
	/*	 
	     if(strtime.length!=0){    
	         var reg = /^(\d{1,2}):(\d{1,2})$/;     
	         var r = strtime.match(reg);     
			 //alert(r[1])
	         if(r==null) 
			 {
				 alert('对不起，您输入的时间格式不正确!'); //请将“日期”改成你需要验证的属性名称!   
				 return;
			 }		
	         var mm=r[1];
	         var ss=r[2];		 
	         if ((mm>="24")||(mm<0)||(ss>=60)||(ss<0))
			 {
				 alert('对不起，您输入的时间格式不正确!'); //请将“日期”改成你需要验证的属性名称!   
				 return;
			 }
	    }  
	*/
	var typ = Ext.getCmp("ConType").value;
	var inout = Ext.getCmp("InOut").value;
	var multlocObj = Ext.getCmp("MultiLoc");
	if (apptime == "24:00") {

	}
	if (multlocObj) {
		var multLoc = multlocObj.valueId;
		var locArr = multLoc.split(",");
		if (locArr.length == 2) {
			//alert("多科会诊请选择3个或3个以上科室！");
			//return;
		}
	} else {
		var locArr = new Array();
		locArr.push(dep);
		var multLoc = dep;
	}
	var diagObj = Ext.getCmp("Diag");
	if (diagObj) {
		var diag = diagObj.getValue();
		if (diag == '' || diag == null) {
			Ext.Msg.alert('提示', "病人没有诊断，请先下诊断!");
			return;
		}
	}
	if (inout == "") {
		Ext.Msg.alert('提示', "请选择'院内院外'!");
		return;
	}
	if ((inout == "I") && (multLoc == "")) {
		Ext.Msg.alert('提示', "请选择'会诊科室'!");
		return;
	}
	if (multLoc == null || multLoc == '') {
		Ext.Msg.alert('提示', "不允许手输科室,请通过下拉框选择'会诊科室'!");
		return;
	}

	var destin = Ext.getCmp("ConDestination").getRawValue();
	var atti = Ext.getCmp("Attitude").getRawValue();
	var RequestConDoc = Ext.getCmp("RequestConDoc").value;
	var DocGrade = Ext.getCmp("DocGrade").value;
	if (DocGrade == "" && locArr.length == 1) {
		Ext.Msg.alert('提示', "请选择'医师级别'!");
		return;
	}
	var MoreLoc = "N";
	var objMoreLoc = Ext.getCmp("MoreLoc_1");
	if (objMoreLoc.checked == true) MoreLoc = "Y";
	if (locArr.length > 1) {
		MoreLoc = "Y";
		typ = "M";
	}
	//添加多科会诊审核20161226
	var openMoreLocAuit = false;
	var retOenMoreLocAuit =  tkMakeServerCall("User.DHCConsultDepItm", "GetConfig");//cspRunServerMethod(GetAuditValue);
	var ifOpenMorcLocAudit = retOenMoreLocAuit.split("^")[2];
	if(ifOpenMorcLocAudit=="Y"){
		openMoreLocAuit = true;
	}
	if(openMoreLocAuit == true&&objMoreLoc.checked == true){
		SaveAudit(appdate, apptime,typ,inout,diag,destin,false,locArr);
	}else{
		var consultGroupId = tkMakeServerCall("User.DHCConsultation", "createConsultGroupId")

	var consultIdArr = [];
	if (locArr.length > 1) {
		Ext.getCmp("RequestConDoc").clearValue();
		RequestConDoc = ""
	}
	for (var i = 0; i < locArr.length; i++) {
		dep = locArr[i];
		ret = ""
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
		ret = ret + "id|" + myId + "^";
		ret = ret + "RequestConDoc|" + RequestConDoc + "^";
		ret = ret + "DocGrade|" + DocGrade + "^";
		ret = ret + "MoreLoc|" + MoreLoc + "^";
		ret = ret + "consultGroupId|" + consultGroupId;
		var consultId = cspRunServerMethod(SaveCon, ret);
		if(isNaN(consultId)){
			alert(consultId);
			return;
		}
		consultIdArr.push(consultId);
		if (myId == "") {
			var parr = dep + "^" + session['LOGON.CTLOCID'] + "^" + EpisodeID;
			//alert(parr);
			//SendSMS(parr);
		}

		}
		window.close();
		FindAdmConsult();
	}
	/*if(confirm("是否打印会诊申请单?")){
	for (var i=0;i<consultIdArr.length;i++){
	var consultId=consultIdArr[i];
	printconsult(consultId);
	}
	}*/
	//window.close();
	//FindAdmConsult();
	//alert(ret);
}

function SendSMS(parr) {
	var ret = cspRunServerMethod(SendMessage, parr);
	var retArr = ret.split("@");
	var DepPhone = retArr[0];
	var DepPhoneArr = DepPhone.split("^");
	//SMS.openComm();
	//alert(ret);
	for (var i = 0; i < DepPhoneArr.length; i++) {
		if (DepPhoneArr[i] == "") continue;
		var RetStr = cspRunServerMethod(Sendsms, DepPhoneArr[i], retArr[1], retArr[2], retArr[3]);
		if (RetStr != 0) {
			alert(RetStr);
		}
		//var RetStr=SMS.sendSms(DepPhoneArr[i],retArr[1],retArr[2],retArr[3]);
		//var a=cspRunServerMethod(SaveJounal, DepPhoneArr[i],retArr[1],retArr[2],retArr[3],RetStr);
	}
	//SMS.closeComm();
}

function Save0318(window) {
	var ret = "";
	var dep = Ext.getCmp("ConsultDep").value;
	var appdate = Ext.getCmp("AppDate").value;
	var apptime = Ext.getCmp("AppTime").getValue();
	var typ = Ext.getCmp("ConType").value;
	var inout = Ext.getCmp("InOut").value;
	if (inout == "") {
		Ext.Msg.alert('提示', "请选择'院内院外'!");
		return;
	}
	if ((inout == "I") && (dep == "")) {
		Ext.Msg.alert('提示', "请选择'会诊科室'!");
		return;
	}
	if (isNaN(dep)) {
		Ext.Msg.alert('提示', "不允许手输科室,请通过下拉框选择'会诊科室'!");
		return;
	}
	var destin = Ext.getCmp("ConDestination").getRawValue();
	var atti = Ext.getCmp("Attitude").getRawValue();
	var RequestConDoc = Ext.getCmp("RequestConDoc").value;
	var DocGrade = Ext.getCmp("DocGrade").value;
	if (DocGrade == "") {
		Ext.Msg.alert('提示', "请选择'医师级别'!");
		return;
	}
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
	ret = ret + "id|" + myId + "^";
	ret = ret + "RequestConDoc|" + RequestConDoc + "^";
	ret = ret + "DocGrade|" + DocGrade;
	cspRunServerMethod(SaveCon, ret);
	window.close();
	FindAdmConsult();
	//alert(ret);
}

function CancelConStatus() {
	var dish = cspRunServerMethod(GetDish, EpisodeID);
	if (dish == 1) {
		alert("已做医疗结算,不能撤销会诊!");
		return;
	}	
	condata = new Array();
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	console.log(rowObj[0]);
	var Status = rowObj[0].get("Status");
	var Contyp = rowObj[0].get("Contyp");
	if (Status == "申请"&&Contyp=="多科") {
		alert("已经通过审核的多科会诊不允许撤销!");
		return;
	}
	var ChangeStatus = document.getElementById("ChangeStatus");
	if (len < 1) {
		// Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons:
		// Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	} else {
		myId = rowObj[0].get("RowID");
		EpisodeID = rowObj[0].get("EpisodeId");
		var ab = "C"
		var we = "N"
		var condepId = rowObj[0].get("ConDepID");
		var ee = cspRunServerMethod(ChangeStatus.value, myId, ab, we, session['LOGON.USERID'], EpisodeID,condepId);
		if (ee != 0) {
			alert(ee);
		}
	}
	//debugger;
	// grid.store.loadData(condata);
	FindAdmConsult();
}
function printNurRec() {
	var stdate = Ext.getCmp("mygridstdate");
	var enddate = Ext.getCmp("mygridenddate");
	var AllFlag = Ext.getCmp("AllFlag").getValue();
	var hospital=tkMakeServerCall("web.DHCConsult","gethospital",session['LOGON.CTLOCID'])
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","RHeadCaption",EmrCode,hospital);
	var LHeadCaption = "科室: " + LogLoc + "     时间段: " + stdate.value + " 至 " + enddate.value;
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","LHeadCaption",EmrCode,LHeadCaption);
	var prncode="DHCCONSULTLISTPRNMOULD";
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
	var parr = EpisodeID + "!" + stdate.value + "!" + enddate.value + "!" + AllFlag + "!" + session['LOGON.CTLOCID'];
	var WebUrl=WebIp+"/dthealth/web/DWR.DoctorRound.cls";
	var EmrType=2;  //1:混合单 2：记录单 3：评估单
	
	var link=WebIp+"/dhcmg/PrintComm/PrintCommPic.application?method=PrintOut&EpisodeID="+Adm+"&EmrCode="+EmrCode+"&EmrType="+EmrType+"&ItmName="+prncode+"&Parrm="+parr+"&PrnLoc="+session['LOGON.CTLOCID']+"&PrnBed="+"&LabHead="+"&curhead="+"&WebUrl="+WebUrl;
	//alert(link)
	window.location.href=link;
}
function printNurRecold() {
	var stdate = Ext.getCmp("mygridstdate");
	var enddate = Ext.getCmp("mygridenddate");
	var AllFlag = Ext.getCmp("AllFlag").getValue();
	var hospital=tkMakeServerCall("web.DHCConsult","gethospital",session['LOGON.CTLOCID'])
	PrintComm.RHeadCaption = hospital;
	PrintComm.LHeadCaption = "科室: " + LogLoc + "     时间段: " + stdate.value + " 至 " + enddate.value;
	//PrintComm.LFootCaption = tm[2];
	PrintComm.SetPreView("1");
	PrintComm.stPage = 0;
	PrintComm.stRow = 0;
	PrintComm.previewPrint = "0"; //是否弹出设置界面
	PrintComm.stprintpos = 0;
	PrintComm.SetConnectStr(CacheDB);
	PrintComm.WebUrl = WebIp + "/dthealth/web/DWR.DoctorRound.cls";
	PrintComm.ItmName = "DHCCONSULTLISTPRNMOULD";//"DHCCONSULTLISTPRNMOULD"
	PrintComm.ID = "";
	PrintComm.MultID = "";
	PrintComm.MthArr = "";
	//alert("EpisodeID="+EpisodeID+" stdate="+stdate.value+" enddate="+enddate.value+" AllFlag="+AllFlag);
	//var parr=EpisodeID+"!"+stdate+"!"+stim+"!"+edate+"!"+etim+"!DHCNURXH1!"+CurrHeadDr;
	var parr = EpisodeID + "!" + stdate.value + "!" + enddate.value + "!" + AllFlag + "!" + session['LOGON.CTLOCID'];
	PrintComm.SetParrm(parr);
	PrintComm.PrintOut();
}

function gridclick() {
	var grid = Ext.getCmp("mygrid");

	var rowObj = grid.getSelectionModel().getSelections();

	var len = rowObj.length;

	if (len < 1) {
		//Ext.Msg.alert('提示', "请先选择一条诊断记录!"); 
		return;
	} else {
		myId = rowObj[0].get("RowID");
		EpisodeID = rowObj[0].get("EpisodeId");
	}
}



function findgardedoc(obj, record, index){
	var selectdocid = obj.value
	//alert(selectdocid);
	clearperson('RequestConDoc');
	var cmbLoc = Ext.getCmp("MultiLoc");
	cmbLocValue = cmbLoc.getValue();
	findpersonByGrade(cmbLocValue,selectdocid, record, index);
}
function findpersonByGrade(loc, docgrade, record, index) {
	//alert(loc+"^"+docgrade+"^"+record+"^"+index);
	person = new Array();
	var cmb = Ext.getCmp("RequestConDoc");
	cmb.store.loadData(person);
	if ((loc != "") && (docgrade != "")) {
		var GetPerson = document.getElementById('GetPerson');
		// debugger;
		var ret = cspRunServerMethod(GetPerson.value, loc, docgrade);
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

}

