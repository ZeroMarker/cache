/// Creator:      lvxin
/// CreatDate:    2014.06.25
/// Description:  执行相关
///	getSelectOrders()
///	getSelectOrderExecs()
/*
	撤销原因 Array
*/
var cancelReason = eval(tkMakeServerCall("Nur.NurseExcute", "getCancelReaasonArray"));
var seeType=eval(tkMakeServerCall("Nur.NurseExcute", "getSeeType"));
	/*
	创建执行窗口
	ifDoubleSign (bool)  是否是否双签 
*/

function createWindow(ifDoubleSign,ifNosignature) {
	if (Ext.getCmp("signWindow")) {
		Ext.getCmp("signWindow").close();
	}
	var window = new Ext.Window({
		bodyStyle: "padding:20px;",
		width: 300,
		height: 425,
		id: "signWindow",
		resizable: false,
		layout: "form",
		items: [{
			id: "cancelReason",
			xtype: "combo",
			width: 125,
			fieldLabel: "原因",
			labelStyle: "font-size:18px",
			triggerAction: 'all',
			store: cancelReason
		},{
			id: "seeType",
			xtype: "combo",
			width: 125,
			fieldLabel: "处理类别",
			labelStyle: "font-size:18px",
			triggerAction: 'all',
			store: seeType
		},{
			id: "note",
			xtype: "field",
			width: 125,
			fieldLabel: "备注",
			labelStyle: "font-size:18px"
		}, {
			id: "psNum",
			xtype: "textfield",
			fieldLabel: "皮试批号",
			labelStyle: "font-size:18px"
		}, {
			id: "date",
			xtype: "datefield",
			fieldLabel: "日期",
			width: 125,
			labelStyle: "font-size:18px",
			format:'d/m/Y',
			value: new Date().format('Y-m-d')
		}, {
			id: "time",
			xtype: "timefield",
			fieldLabel: "时间",
			width: 125,
			format: 'G:i',
			value: new Date().format("G:i"),
			labelStyle: "font-size:18px"
		}, {
			id: "userName",
			xtype: "textfield",
			fieldLabel: "工号",
			value:session['LOGON.USERCODE'],
			labelStyle: "font-size:18px",
			listeners: {
				'render': {
					fn: function(c) {
						c.getEl().on('keydown', function() {
							if (event.keyCode == 13) {
								window.getComponent("password").focus();
							}
						});
					}
				}
			}
		}, {
			id: "password",
			xtype: "textfield",
			fieldLabel: "密码",
			inputType : 'password',
			labelStyle: "font-size:18px",
			listeners: {
				'render': {
					fn: function(c) {
						c.getEl().on('keydown', function() {
							if (event.keyCode == 13) {
								if (!ifDoubleSign) {
									window.buttons[0].fireEvent("click");
								} else {
									window.getComponent("userNameTow").focus();
								}
							}
						});
					}
				}
			}

		}, {
			id: "userNameTow",
			xtype: "textfield",
			fieldLabel: "工号2",
			labelStyle: "font-size:18px",
			listeners: {
				'render': {
					fn: function(c) {
						c.getEl().on('keydown', function() {
							if (event.keyCode == 13) {
								window.getComponent("passwordTow").focus();
							}
						});
					}
				}
			}
		}, {
			id: "passwordTow",
			xtype: "textfield",
			fieldLabel: "密码2",
			inputType : 'password',
			labelStyle: "font-size:18px",
			listeners: {
				'render': {
					fn: function(c) {
						c.getEl().on('keydown', function() {
							if (event.keyCode == 13) {
								window.buttons[0].fireEvent("click");
							}
						});
					}
				}
			}

		}],
		buttons: [{
			id: "execButton",
			xtype: "button",
			text: "执行"
		}, {
			id: "cancelButton",
			xtype: "button",
			text: "取消",
			handler: function() {
				window.close()
			}
		}]
	})
	var cancelReasonCombobox = window.getComponent("cancelReason");
	//cancelReasonCombobox.setValue(cancelReason[0][0]);
	var seeTypeCombobox = window.getComponent("seeType");
	seeTypeCombobox.setValue(seeType[0][0]);
	if (!ifDoubleSign) {
		window.remove("userNameTow");
		window.remove("passwordTow");
	}
         if (ifNosignature)
	{
	 window.remove("userName");
	 window.remove("password");
	 window.remove("userNameTow");
	 window.remove("passwordTow");
	}
	return window
}
/*
	用户验证
*/
function passwordConfirm(window) {
	//var userId=session['LOGON.USERID'];
	var ctLocId = session['LOGON.CTLOCID']
        var object = createConfirmObject();
	if (!window.getComponent("userName")) 
	{
	
	return object;
	}
	var userName = window.getComponent("userName").getValue();
	var password = window.getComponent("password").getValue();
	//var object = createConfirmObject();
	if (window.getComponent("userNameTow")) {
		var userName2 = window.getComponent("userNameTow").getValue();
	} else {
		var userName2 = "";
	}
	if (window.getComponent("passwordTow")) {
		var password2 = window.getComponent("passwordTow").getValue();
	} else {
		var password2 = "";
	}
	if (userName == "" && userName2 == "") {
		alert("护士工号不能都为空!")
		object.status = -1;
		return object;
	} else {
		if ((userName != "" && password == "")) {
			alert("护士1密码为空!")
			object.status = -1;
			return object;
		}
		if ((userName2 != "" && password2 == "")) {
			alert("护士2密码为空!")
			object.status = -1;
			return object;
		}
	}
	//w ##class(web.DHCLCNUREXCUTE).ConfirmPassWord("","")
	var confirmUserStr = tkMakeServerCall("Nur.NurseExcute", "passwordConfirm", userName, password, userName2, password2, ctLocId);

	
	if (confirmUserStr.indexOf("0^") == -1) {
		alert(confirmUserStr)
		object.status = -1;
		return object;
	} else {
		userId = confirmUserStr.split("^")[1];
		userId2 = confirmUserStr.split("^")[2];
		if(window.getComponent("cancelReason")!=undefined){
			object.cancelReason = window.getComponent("cancelReason").getValue();
		}
		if(window.getComponent("seeType")!=undefined){
			object.seeType = window.getComponent("seeType").getValue();
		}
		if(window.getComponent("note")!=undefined){
			object.note = window.getComponent("note").getValue();
		}
		if(window.getComponent("psNum")!=undefined){
			object.psNum = window.getComponent("psNum").getValue();
		}
		if(window.getComponent("date")!=undefined){
			object.date = window.getComponent("date").getRawValue();
		}
		if(window.getComponent("time")!=undefined){
			object.time = window.getComponent("time").getRawValue();
		}
		object.userId1 = userId;
		object.userId2 = userId2;
		object.status = 0;
		return object;
	}
}

var createConfirmObject = function() {
	var object = {
		userId1: session['LOGON.USERID'],
		userId2: "",
		cancelReason: "",
		seeType:"",
		note:"",
		psNum: "",
		date: "",
		time: "",
		status: 0
	};
	return object;
}

var verify = function(handle, queryType, operationType, singleVerify,ifNosignature) {
	var ifDoubleVerify = false;
	if (singleVerify == "N") {
		ifDoubleVerify = true;
	}
	var window = createWindow(ifDoubleVerify,ifNosignature);
	/*
		移除不需要的控件
	*/
	layoutChange(window,operationType);
	// window.remove("cancelReason");
	// window.remove("psNum");
	window.buttons[0].on("click", function() {
		var object = passwordConfirm(window)
		if (object.status != -1) {

			var ret=handle(queryType, operationType, object)
			if(ret==0){
				window.close();
			}
			
		}
	});
       if (ifcanContinue(operationType)) return;
	window.show();
}


//根据操作类型改变布局
var layoutChange = function(window,operationType) {
	var operationTypeCode=tkMakeServerCall("Nur.NurseOperationType", "getTypeCode",operationType);
	do{
		//打印
		if(operationTypeCode=="Print"){
			window.remove("seeType");
			window.remove("note");
			window.remove("cancelReason");
			window.remove("psNum");
			window.remove("date");
			window.remove("time");
			break;
		};
		//皮试阳性
		if(operationTypeCode=="SkinAllergy"){
			window.remove("seeType");
			window.remove("note");
			window.remove("cancelReason");
			break;
		};
		//皮试阴性
		if(operationTypeCode=="SkinNormal"){
			window.remove("seeType");
			window.remove("note");
			window.remove("cancelReason");
			break;
		};
		//执行医嘱
		if(operationTypeCode=="Excute"){
			window.remove("seeType");
			window.remove("psNum");
			window.remove("note");
                        window.remove("cancelReason");
			break;
		};
		//处理医嘱
		if(operationTypeCode=="SeeOrder"){
			window.remove("cancelReason");
			window.remove("psNum");
			break;
		};
		//撤销处理
		if(operationTypeCode=="CancelSeeOrder"){
			window.remove("seeType");
			window.remove("cancelReason");
			window.remove("psNum");
			window.remove("date");
			window.remove("time");
			break;
		};
		//撤销执行
		if(operationTypeCode=="CancelExcute"){
			window.remove("seeType");
			window.remove("psNum");
			window.remove("date");
			window.remove("time");
			break;
		};
		break;
	}while(true)
}
var Func = new Array();
/*
	处理新医嘱

*/
Func["seeOrder"] = function(queryTypeCode, operationType, object) {
	var oeoriIdArray = getSelectOrders();
	var succussIdArray = [];
	var error;
	if(oeoriIdArray.length==0){
		Ext.Msg.alert("提示信息", "请选择医嘱");
		return 1;
	}
	for (var i = 0; i < oeoriIdArray.length; i++) {
		var oeoriId = oeoriIdArray[i];
		var ret = tkMakeServerCall("Nur.NurseExcute", "SeeOrder", oeoriId
			, object.userId1
			,object.seeType
			,object.note
			,object.date
			,object.time);
		if (ret == "0") {
			succussIdArray[succussIdArray.length] = oeoriId
		}else{
			error=ret;
		}
	}
	saveOperationRecord(succussIdArray,queryTypeCode, operationType, object, "处理医嘱",error);
	Ext.getCmp("orderGrid").getStore().reload();
	return 0;

}

/*
	撤销处理医嘱
*/
Func["cancelSeeOrder"] = function(queryTypeCode, operationType, object) {
	var oeoriIdArray = getSelectOrders();
	var succussIdArray = [];
	var error;
	if(oeoriIdArray.length==0){
		Ext.Msg.alert("提示信息", "请选择医嘱");
		return 1;
	}
	for (var i = 0; i < oeoriIdArray.length; i++) {
		var oeoriId = oeoriIdArray[i];
		var ret = tkMakeServerCall("Nur.NurseExcute", "UnSeeOrder", oeoriId, object.userId1);
		if (ret == "0") {
			succussIdArray[succussIdArray.length] = oeoriId
		}else{
			error=ret;
		}
	}
	saveOperationRecord(succussIdArray, queryTypeCode, operationType, object,"撤销处理医嘱",error);
	Ext.getCmp("orderGrid").getStore().reload();
	return 0;
}
/*
	执行医嘱
*/
Func["excuteOrder"] = function(queryTypeCode, operationType, object) {
	var oeoreIdArray = getSelectOrderExecs();
	var succussIdArray = [];
	var error;
	if(oeoreIdArray.length==0){
		Ext.Msg.alert("提示信息", "请选择医嘱执行记录");
		return 1;
	}
	for (var i = 0; i < oeoreIdArray.length; i++) {
		var disposeStatCode = oeoreIdArray[i]["disposeStatCode"];
		if (disposeStatCode=="Exec") error="医嘱执行记录已执行";
		var oeoreId = oeoreIdArray[i]["oeoreId"];
		if (disposeStatCode == "Discontinue") {

			var ret = tkMakeServerCall("Nur.NurseExcute", "SetDisconOrder", oeoreId, object.userId1);
			if (ret == "0") {
				succussIdArray[succussIdArray.length] = oeoreId
			}
		} else if ((disposeStatCode == "Immediate") || (disposeStatCode == "LongNew") || (disposeStatCode == "Temp") || (disposeStatCode == "TempTest") || (disposeStatCode == "Needless") || (disposeStatCode == "SkinTest") || (disposeStatCode == "SkinTestNorm") || (disposeStatCode == "PreDiscon") || (disposeStatCode == "LongUnnew")) {
			var ret = tkMakeServerCall("Nur.NurseExcute", "UpdateOrdGroup",
				"N",
				oeoreId,
				"F",
				object.userId1,
				session['LOGON.CTLOCID'],
				queryTypeCode,
				object.date,
				object.time,
				object.cancelReason);
			if (ret == "0") {
				succussIdArray[succussIdArray.length] = oeoreId
			}else{
				error=ret;
			}

		}
	}
	saveOperationRecord(succussIdArray, queryTypeCode, operationType, object,"执行医嘱",error);
	Ext.getCmp("orderGrid").getStore().reload();
	return 0;



}
/*
	撤销执行医嘱
*/
Func["cancelExcuteOrder"] = function(queryTypeCode, operationType, object) {
	var oeoreIdArray = getSelectOrderExecs();
	var succussIdArray = [];
	var error;
	if(oeoreIdArray.length==0){
		Ext.Msg.alert("提示信息", "请选择医嘱执行记录");
		return 1;
	}
	for (var i = 0; i < oeoreIdArray.length; i++) {
		var disposeStatCode = oeoreIdArray[i]["disposeStatCode"];
		var oeoreId = oeoreIdArray[i]["oeoreId"];
		if ((disposeStatCode != "LackOfFee") && (disposeStatCode != "Immediate") && (disposeStatCode != "LongNew") && (disposeStatCode != "Temp") && (disposeStatCode != "TempTest") && (disposeStatCode != "Discontinue") && (disposeStatCode != "Needless") && (disposeStatCode != "SkinTest") && (disposeStatCode != "SkinTestNorm") && (disposeStatCode != "PreDiscon") && (disposeStatCode != "LongUnnew")) {
			var oeoreId = oeoreIdArray[i]["oeoreId"];
			if (disposeStatCode == "Exec") {
				var ret = tkMakeServerCall("Nur.NurseExcute", "UpdateOrdGroup",
					"N",
					oeoreId,
					"C",
					object.userId1,
					session['LOGON.CTLOCID'],
					queryTypeCode,
					object.date,
					object.time,
					object.cancelReason);
				if (ret == "0") {
					succussIdArray[succussIdArray.length] = oeoreId
				}else{
					error=ret;
				}
			}
		}
	}
	saveOperationRecord(succussIdArray, queryTypeCode, operationType, object,"撤销执行医嘱",error);
	Ext.getCmp("orderGrid").getStore().reload();
	return 0;

}
/*
	皮试阳性
*/
Func["skinTestAllergy"] = function(queryTypeCode, operationType, object) {
	var oeoreIdArray = getSelectOrderExecs();
	var succussIdArray = [];
	var error;
	if(oeoreIdArray.length==0){
		Ext.Msg.alert("提示信息", "请选择医嘱执行记录");
		return 1;
	}
	for (var i = 0; i < oeoreIdArray.length; i++) {
		var oeoreId = oeoreIdArray[i]["oeoreId"];
		var ret = tkMakeServerCall("Nur.NurseExcute", "SetSkinTestResult",
			oeoreId,
			object.userId1,
			"Y",
			object.psNum,
			"F",
			session['LOGON.CTLOCID'],
			queryTypeCode,
			object.date,
			object.time,
			object.cancelReason);
		if (ret == "0") {
			succussIdArray[succussIdArray.length] = oeoreId
		}else{
			error=ret;
		}
	};
	saveOperationRecord(succussIdArray, queryTypeCode, operationType, object,"皮试阳性",error);
	Ext.getCmp("orderGrid").getStore().reload();
	return 0;

}
/*
	皮试阴性
*/
Func["skinTestNormal"] = function(queryTypeCode, operationType, object) {
	var oeoreIdArray = getSelectOrderExecs();
	var succussIdArray = [];
	var error;
	if(oeoreIdArray.length==0){
		Ext.Msg.alert("提示信息", "请选择医嘱执行记录");
		return 1;
	}
	for (var i = 0; i < oeoreIdArray.length; i++) {
		var oeoreId = oeoreIdArray[i]["oeoreId"];
		var ret = tkMakeServerCall("Nur.NurseExcute", "SetSkinTestResult",
			oeoreId,
			object.userId1,
			"N",
			object.psNum,
			"F",
			session['LOGON.CTLOCID'],
			queryTypeCode,
			object.date,
			object.time,
			object.cancelReason);
		if (ret == "0") {
			succussIdArray[succussIdArray.length] = oeoreId
		}else{
			error=ret
		}
	};
	saveOperationRecord(succussIdArray, queryTypeCode, operationType, object,"皮试阴性",error);
	Ext.getCmp("orderGrid").getStore().reload();
	return 0;
}

function saveOperationRecord(succussIdArray, queryTypeCode, operationType, object,msg,ret) {
	if (succussIdArray.length != 0) {
		tkMakeServerCall("Nur.NurseOperationRecord", "save",
			succussIdArray.join("^"),
			operationType,
			queryTypeCode,
			"",
			"",
			session['LOGON.CTLOCID'],
			object.userId1,
			object.userId2,
			session['startDate'],
			session['startTime'],
			session['endDate'],
			session['endTime'])
		Ext.Msg.alert("提示信息", msg + "成功")
	} else {
		if(ret&&(ret!="")){
			Ext.Msg.alert("提示信息", msg + "失败:"+ret)
		}else{
			Ext.Msg.alert("提示信息", msg + "失败")
		}
		
	}
}
/*
	关联标本
*/
var setPlacerNo = function(rowIndex) {
	var srcElement = window.event.srcElement;
	if (window.event.keyCode == 13) {
		var value = srcElement.value;
		var r=Ext.getCmp("orderGrid").getStore().getAt(rowIndex);
		var oeoriId = r.data["oeoriId"];
		var ret = tkMakeServerCall("web.DHCLCNUREXCUTE", "SetPlacerNo", session['LOGON.USERID'], oeoriId, value, "N");
		if (ret != "0") {
			Ext.Msg.alert("提示信息", ret)
		} else {
			Ext.Msg.alert("提示信息", "成功")
		}
		Ext.getCmp("orderGrid").getStore().reload();
	}
	

};

/*
	取医嘱
*/
var getSelectOrders = function() {
	orderArray = [];
	var store = Ext.getCmp("orderGrid").getStore();
	var selections = Ext.getCmp("orderGrid").getSelectionModel().getSelections();
	var length = selections.length;
	for (var i = 0; i < length; i++) {
		var record = selections[i];
		if (record.json["subOrder"] == 0) {
			orderArray[orderArray.length] = record.json["oeoriId"]
		}
	}
	return orderArray;
}

/*
	取执行记录
*/
var getSelectOrderExecs = function() {
	orderExecArray = [];
	var store = Ext.getCmp("orderGrid").getStore();
	for (var i = 0; i < store.getCount(); i++) {
		var record = store.getAt(i);
		for (var j = 0; j < record.json["execs"].length; j++) {
			var mainExec = record.json["execs"][j];
			var disposeStatCode = mainExec["disposeStatCode"];
			if ((mainExec["check"] == "1") && (record.json["subOrder"] == 0)) {
				//orderExecArray[orderExecArray.length] = mainExec["oeoreId"];
				orderExecArray[orderExecArray.length] = mainExec;
			}

		}
	}
	return orderExecArray;
}

var ifcanContinue=function(operationType){
    var operationTypeCode=tkMakeServerCall("Nur.NurseOperationType", "getTypeCode",operationType);
    var oeoreIdArray = getSelectOrderExecs();
    var oeoriIdArray = getSelectOrders();
	if((oeoreIdArray.length==0)&&(oeoriIdArray.length==0)&&(operationTypeCode!="Print")){  ///打印的不用判断是否勾选
		Ext.Msg.alert("提示信息", "请选择医嘱或者执行记录");
		return 1;
	    }
	if(operationTypeCode=="CancelSeeOrder"){
	 if (oeoriIdArray==""){
	   Ext.Msg.alert("提示信息", "请至少选择一条医嘱");
	   return 1;
	 }
	 var IfhaveSeeOrd=tkMakeServerCall("web.DHCLCNUREXCUTE", "GetSeeOrdInfo",oeoriIdArray[0].split("||")[0],oeoriIdArray[0].split("||")[1]);
     if (IfhaveSeeOrd=="^^"){
	  Ext.Msg.alert("提示信息", "医嘱未被处理,不能撤销处理");
	  return 1;
	   }
    }
}