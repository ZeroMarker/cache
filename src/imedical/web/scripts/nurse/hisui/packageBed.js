var preSelPat="";
var packagebedParaObj=websys_showModal('options').packagebedParaObj;
$(function() {
	initData();
	initEvent();
})
function initEvent(){
	$("#BSave").click(SaveClick);
	$("#BCancel").click(CancelClick);
}
function initData(){
	$("#sttDate").datebox("disable").datebox('setValue', formatDate(new Date()));
	sttDateChange();
	/*var packagebedParaObj={
		bedNo:"3||3",
		bedUnAvailableConfigArr:[
			{isDefault:"Y",isAllowEditStTime:"Y",unAvailableDesc:"消毒",unAvailableId:"33"},
			{isDefault:"Y",isAllowEditStTime:"N",unAvailableDesc:"包床",unAvailableId:"1"},
			{isDefault:"Y",isAllowEditStTime:"N",unAvailableDesc:"锁定",unAvailableId:"34"}
		],
		defUnAvailableId:1,
		emptyBedList:[{ID:"3||3",code:"03"},{ID:"3||9",code:"09"}],
		patientList:[{episodeID:1708,name:"马亭(演示)"},{episodeID:39,name:"倒霉急诊患者"}],
		reasonList:[
			{reason:"消毒",ID:"33"},
			{reason:"包床",ID:"1"},
			{reason:"锁定",ID:"34"}
		]
	}*/
	//packagebedParaObj.bedNo
	//包床患者
	$HUI.combobox("#occupyBedPat", {
		valueField: 'episodeID',
		textField: 'name', 
		editable:true,
		data: packagebedParaObj.patientList,
		onSelect:function(rec){
			if (rec) preSelPat=rec.episodeID;
		}
	});
	//床位代码
	$HUI.combobox("#emptyBedCombo", {
		valueField: 'ID',
		textField: 'code', 
		editable:false,
		data:packagebedParaObj.emptyBedList,
		onLoadSuccess:function(){
			if (ServerObj.EpisodeID) {
				$("#emptyBedCombo").combobox("disable");
			}
			$("#emptyBedCombo").combobox("select",packagebedParaObj.bedNo);
		}
	});
	//不可用原因
	$HUI.combobox("#reasonCombo", {
		valueField: 'ID',
		textField: 'reason', 
		editable:true,
		data: packagebedParaObj.reasonList,
		onLoadSuccess:function(){
			var defUnAvailableId=packagebedParaObj.defUnAvailableId;
			if (defUnAvailableId ==""){
				for (var i=0;i<packagebedParaObj.bedUnAvailableConfigArr.length;i++){
					var isDefault=packagebedParaObj.bedUnAvailableConfigArr[i].isDefault;
					if (isDefault=="Y"){
						defUnAvailableId=packagebedParaObj.bedUnAvailableConfigArr[i].unAvailableId;
					}
				}
				defUnAvailableId=defUnAvailableId?defUnAvailableId:packagebedParaObj.bedUnAvailableConfigArr[0].unAvailableId;
			}
			$("#reasonCombo").combobox("select",defUnAvailableId);
		},
		onSelect:function(rec){
			var unAvailableId=rec.unAvailableId;
			var index=$.hisui.indexOfArray(packagebedParaObj.bedUnAvailableConfigArr,"unAvailableId",rec.ID);
			if (index>=0){
				var isAllowEditStTime=packagebedParaObj.bedUnAvailableConfigArr[index].isAllowEditStTime;
				if (isAllowEditStTime=="Y"){
					$("#sttDate").datebox("enable");
				}else{
					$("#sttDate").datebox("disable").datebox('setValue', formatDate(new Date()));
					sttDateChange();
				}
				var unAvailableDesc=packagebedParaObj.bedUnAvailableConfigArr[index].unAvailableDesc;
				if ((unAvailableDesc.indexOf($g("包床"))>=0)||(unAvailableDesc.indexOf($g("包间"))>=0)||(unAvailableDesc.indexOf($g("包房"))>=0)) {
					if (!ServerObj.EpisodeID) $("#occupyBedPat").combobox("enable");
					else $("#occupyBedPat").combobox("disable");
					$("label[for=occupyBedPat]").addClass("clsRequired");
					$("#occupyBedPat").combobox("select",ServerObj.EpisodeID?ServerObj.EpisodeID:preSelPat);
				}else{
					$("#occupyBedPat").combobox("select","").combobox("disable");
					$("label[for=occupyBedPat]").removeClass("clsRequired");
				}
			}
		}
	});
	var timeObj=getServerTime(1,dtseparator=='-'?3:4);
	$("#sttTime").timespinner("setValue",timeObj.time);
}
function SaveClick(){
	var episodeID=getValueById("occupyBedPat");
	if (episodeID) {
		if ($.hisui.indexOfArray(packagebedParaObj.patientList,"episodeID",episodeID)<0){
			$.messager.popover({msg:'请在下拉框中选择包床患者！',type:'error'});
			$('#occupyBedPat').next('span').find('input').focus();
			return false;
		}
	}
	var bedID=getValueById("emptyBedCombo");
	if (bedID){
		if ($.hisui.indexOfArray(packagebedParaObj.emptyBedList,"ID",bedID)<0){
			$.messager.popover({msg:'请选择操作床位！',type:'error'});
			$('#emptyBedCombo').next('span').find('input').focus();
			return false;
		}
	}
    var reason=getValueById("reasonCombo");
	if ($.hisui.indexOfArray(packagebedParaObj.bedUnAvailableConfigArr,"unAvailableId",reason)<0){
		$.messager.popover({msg:'请在下拉框中选择不可用原因！',type:'error'});
		$('#reasonCombo').next('span').find('input').focus();
		return false;
	}
	var reasonDesc=$("#reasonCombo").combobox("getText");
	if ((reasonDesc.indexOf("包床")>=0)&&(!episodeID)) {
		$.messager.popover({msg:'请在下拉框中选择包床患者！',type:'error'});
		$('#occupyBedPat').next('span').find('input').focus();
		return false;
	}
	if (((reasonDesc.indexOf("包间")>=0)||(reasonDesc.indexOf("包房")>=0))&&(!episodeID)) {
		$.messager.popover({msg:'请在下拉框中选择包房/包间患者！',type:'error'});
		$('#occupyBedPat').next('span').find('input').focus();
		return false;
	}
    var startDate=getValueById("sttDate");
    if (!startDate) {
	    $.messager.popover({msg:'请选择开始日期',type:'error'});
		$('#sttDate').next('span').find('input').focus();
		return false;
	}
    var startTime=getValueById("sttTime");
    if (!startTime) {
	    $.messager.popover({msg:'请选择开始时间',type:'error'});
		$('#sttTime').focus();
		return false;
	}
    var endDate=getValueById("endDate");
    var endTime=getValueById("endTime");
	if ((endDate)&&(endTime)&&(startDate==endDate)&&(compareTime(startTime,endTime)>0)) {
		$.messager.popover({msg:'结束时间不能早于开始时间!',type:'error'});
		$('#endTime').focus();
		return false;
	}
	var rtn={
	  episodeID:episodeID,
      bedID:bedID,
      reason:reason,
      startDate:startDate,
      startTime:startTime,
      endDate:endDate,
      endTime:endTime,
	  result:true
	}
	websys_showModal('options').CallBackFunc(rtn);
}

function CancelClick(){
	websys_showModal('options').CallBackFunc({result:false});
}
function sttDateChange(){
	var startDate=getValueById("sttDate");
	if (!startDate) {
		setEndDateMin(null);
	}else{
		setEndDateMin(startDate);
	}
}
function endDateChange(){
	var startDate=getValueById("sttDate");
	var endDate=getValueById("endDate");
	if (!endDate) {
		$("#endTime").timespinner({min:null});
	}else{
		if (compareDate(endDate,startDate)>0) {
			$("#endTime").timespinner({min:null});
		}else{
			var startTime=getValueById("sttTime");
			if (startTime) {
				$("#endTime").timespinner({min:startTime});
			}else{
				$("#endTime").timespinner({min:null});
			}
		}
	}
}
function setEndDateMin(minDate){
	$("#endDate").datebox({minDate:minDate});
}