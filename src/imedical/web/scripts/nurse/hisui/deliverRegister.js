/*
 * author pengjunfu 2018-10-16
 * 分娩登记
 */


$(function() {
var BaseInfoLayOutInit = function() {
};
var BaseInfoInitValue = function() {
	var info = tkMakeServerCall("web.DHCNurIpComm", "NurPatInfo", EpisodeID);
	$("#PatInfo").val(info.split("^")[0]);
	var currentStatus=tkMakeServerCall("Nur.IP.Delivery", "getCurrentDeliveryStatus", EpisodeID);
	var ifNewBaby = tkMakeServerCall("web.DHCDischargeHistory", "ifNewBaby", EpisodeID);
	if (String(ifNewBaby) === "1") {
		$("#CancelRegisteBtn").css("display","none");
		$("#FinishBtn").css("display","none");
		$("#RegisteBtn").css("display","none");
		$.messager.alert("提示", "新生儿无法分娩登记", 'info');
	}
	//控制按钮显示
	if((currentStatus=="")||(currentStatus=="W")||(currentStatus=="C")){
		$("#CancelRegisteBtn").css("display","none");
		$("#FinishBtn").css("display","none");
	}else if(currentStatus=="L"){
		$("#RegisteBtn").css("display","none");
	}
	var currentStatusDesc="";
	switch(currentStatus)
	{
		case "W":
		currentStatusDesc=$g("分娩完成")
		break;
		case "C":
		currentStatusDesc=$g("取消登记")
		break;
		case "L":
		currentStatusDesc=$g("待产")
		break;
		default:
	}
	$("#CurrentStauts").val(currentStatusDesc);
	$("#RegisteBtn").bind("click", function() {
		var deliveryRoomID=$HUI.combobox('#DeliveryRoom').getValue()?$HUI.combobox('#DeliveryRoom').getValue():"";
		Register(EpisodeID,deliveryRoomID,session['LOGON.CTLOCID'],session['LOGON.USERID'])
	});
	$("#CancelRegisteBtn").bind("click", function() {
		updateDeliveryStatus(EpisodeID,"C",session['LOGON.USERID']);
	});
	$("#FinishBtn").bind("click", function() {
		updateDeliveryStatus(EpisodeID,"W",session['LOGON.USERID']);
	});
	
	
	var lastDeliveryRoomID = tkMakeServerCall("Nur.IP.Delivery", "getLastDeliveryRoom", session['LOGON.CTLOCID']);
	//初始化产房combox
	$HUI.combobox('#DeliveryRoom', {
		valueField: 'ID',
		textField: 'desc',
		url: $URL + '?ClassName=Nur.IP.Delivery&MethodName=getLoc&LocID='+lastDeliveryRoomID+"&HospID="+ session['LOGON.HOSPID'],
		onSelect: function(record) {},
		filter: function (q, row) {
			var opts = $(this).combobox('options');
			var text = row[opts.textField];
			var pyjp = getPinyin(text).toLowerCase();
			if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
				return true;
			}
			return false;
	  }
	});
	

};

var Register=function(EpisodeID,deliveryRoomID,locID,userID){
	var ret = tkMakeServerCall("Nur.IP.Delivery","register",EpisodeID,deliveryRoomID,locID,userID);
	if (ret != "0") {
		$.messager.alert("提示", ret, 'info');
	} else {
		$.messager.alert("提示", "操作成功!", 'info');
		Refresh()
	}
};

var updateDeliveryStatus=function(EpisodeID,status,userID){
	var ret = tkMakeServerCall("Nur.IP.Delivery","updateDeliveryStatus",EpisodeID,status,userID);
	if (ret != "0") {
		$.messager.alert("提示", ret, 'info');
	} else {
		$.messager.alert("提示", "操作成功!", 'info');
		Refresh()
	}
};

var Refresh=function(){
	if(window.opener){
			//window.opener.location.reload();
			if(window.opener.parent.window.frames['TRAK_main']){
				window.opener.parent.window.frames['TRAK_main'].location.reload();
			}else{
				window.opener.location.reload();
			}
			window.close();
		}else{
			var lnk = "epr.default.csp";
			window.location = lnk;
		}
}

	BaseInfoLayOutInit();
	BaseInfoInitValue()

});