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
			{isDefault:"Y",isAllowEditStTime:"Y",unAvailableDesc:"����",unAvailableId:"33"},
			{isDefault:"Y",isAllowEditStTime:"N",unAvailableDesc:"����",unAvailableId:"1"},
			{isDefault:"Y",isAllowEditStTime:"N",unAvailableDesc:"����",unAvailableId:"34"}
		],
		defUnAvailableId:1,
		emptyBedList:[{ID:"3||3",code:"03"},{ID:"3||9",code:"09"}],
		patientList:[{episodeID:1708,name:"��ͤ(��ʾ)"},{episodeID:39,name:"��ù���ﻼ��"}],
		reasonList:[
			{reason:"����",ID:"33"},
			{reason:"����",ID:"1"},
			{reason:"����",ID:"34"}
		]
	}*/
	//packagebedParaObj.bedNo
	//��������
	$HUI.combobox("#occupyBedPat", {
		valueField: 'episodeID',
		textField: 'name', 
		editable:true,
		data: packagebedParaObj.patientList,
		onSelect:function(rec){
			if (rec) preSelPat=rec.episodeID;
		}
	});
	//��λ����
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
	//������ԭ��
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
				if ((unAvailableDesc.indexOf($g("����"))>=0)||(unAvailableDesc.indexOf($g("����"))>=0)||(unAvailableDesc.indexOf($g("����"))>=0)) {
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
			$.messager.popover({msg:'������������ѡ��������ߣ�',type:'error'});
			$('#occupyBedPat').next('span').find('input').focus();
			return false;
		}
	}
	var bedID=getValueById("emptyBedCombo");
	if (bedID){
		if ($.hisui.indexOfArray(packagebedParaObj.emptyBedList,"ID",bedID)<0){
			$.messager.popover({msg:'��ѡ�������λ��',type:'error'});
			$('#emptyBedCombo').next('span').find('input').focus();
			return false;
		}
	}
    var reason=getValueById("reasonCombo");
	if ($.hisui.indexOfArray(packagebedParaObj.bedUnAvailableConfigArr,"unAvailableId",reason)<0){
		$.messager.popover({msg:'������������ѡ�񲻿���ԭ��',type:'error'});
		$('#reasonCombo').next('span').find('input').focus();
		return false;
	}
	var reasonDesc=$("#reasonCombo").combobox("getText");
	if ((reasonDesc.indexOf("����")>=0)&&(!episodeID)) {
		$.messager.popover({msg:'������������ѡ��������ߣ�',type:'error'});
		$('#occupyBedPat').next('span').find('input').focus();
		return false;
	}
	if (((reasonDesc.indexOf("����")>=0)||(reasonDesc.indexOf("����")>=0))&&(!episodeID)) {
		$.messager.popover({msg:'������������ѡ�����/���仼�ߣ�',type:'error'});
		$('#occupyBedPat').next('span').find('input').focus();
		return false;
	}
    var startDate=getValueById("sttDate");
    if (!startDate) {
	    $.messager.popover({msg:'��ѡ��ʼ����',type:'error'});
		$('#sttDate').next('span').find('input').focus();
		return false;
	}
    var startTime=getValueById("sttTime");
    if (!startTime) {
	    $.messager.popover({msg:'��ѡ��ʼʱ��',type:'error'});
		$('#sttTime').focus();
		return false;
	}
    var endDate=getValueById("endDate");
    var endTime=getValueById("endTime");
	if ((endDate)&&(endTime)&&(startDate==endDate)&&(compareTime(startTime,endTime)>0)) {
		$.messager.popover({msg:'����ʱ�䲻�����ڿ�ʼʱ��!',type:'error'});
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