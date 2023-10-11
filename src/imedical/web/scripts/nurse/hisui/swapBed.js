$(function() {
	initMainDoc();
	initMainNurse();
	initEvent();
})
function initEvent(){
	$("#BSave").click(SaveClick);
	$("#BCancel").click(CancelClick);
}
function initMainDoc(){
	var patientObj=websys_showModal('options').patientObj;
	/*var patCurrLocID=$.cm({
		ClassName:"Nur.NIS.Service.Base.Patient",
		MethodName:"GetCurrLocID",
		EpisodeID:ServerObj.EpisodeID
	},false)*/
	$.cm({
		ClassName:"Nur.NIS.Service.Base.Ward",
		MethodName:"GetMainDoctors",
		locID:patientObj.curPatient.currLocID
	},function(docData){
		$('#fromMainDoc').combobox({
			multiple:ServerObj.MainDocMulti=="Y"?true:false,
			rowStyle:ServerObj.MainDocMulti=="Y"?"checkbox":"",
			disabled:false,
			blurValidValue:true,
			selectOnNavigation:true,
			valueField:'ID',
			textField:'name',
			data:docData,
			filter: function(q, row){
				var pyjp = getPinyin(row["name"]).toLowerCase();
				return (row["name"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(pyjp.toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},
			onLoadSuccess:function(){
				var frommMainDocIdArr=ServerObj.curMainDoctorID.toString().split(",");
				var toMainDocIdArr=ServerObj.targetMainDocID.toString().split(",");
				if (ServerObj.MainDocMulti=="Y"){
					if (frommMainDocIdArr.length ==0){
						$('#fromMainDoc').combobox("setValues","");
					}else{
						$('#fromMainDoc').combobox("setValues",frommMainDocIdArr);
					}
				}else{
					$('#fromMainDoc').combobox("setValue",frommMainDocIdArr[0]);
				}
			},
			onSelect:function(rec){
				if (ServerObj.MainDocMulti=="Y"){
					var selValArr=$('#fromMainDoc').combobox("getValues");
					if (selValArr.length>=3){
						$('#fromMainDoc').combobox("setValues",selValArr.slice(1,3))
					}
				}
			}
	    });
	})
	$.cm({
		ClassName:"Nur.NIS.Service.Base.Ward",
		MethodName:"GetMainDoctors",
		locID:patientObj.patient.currLocID
	},function(docData){
		$('#toMainDoc').combobox({
			multiple:ServerObj.MainDocMulti=="Y"?true:false,
			rowStyle:ServerObj.MainDocMulti=="Y"?"checkbox":"",
			disabled:false,
			blurValidValue:true,
			selectOnNavigation:true,
			valueField:'ID',
			textField:'name',
			data:docData,
			filter: function(q, row){
				var pyjp = getPinyin(row["name"]).toLowerCase();
				return (row["name"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(pyjp.toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},
			onLoadSuccess:function(){
				var frommMainDocIdArr=ServerObj.curMainDoctorID.toString().split(",");
				var toMainDocIdArr=ServerObj.targetMainDocID.toString().split(",");
				if (ServerObj.MainDocMulti=="Y"){
					if (toMainDocIdArr.length ==0){
						$('#toMainDoc').combobox("setValues","");
					}else{
						$('#toMainDoc').combobox("setValues",toMainDocIdArr);
					}
				}else{
					$('#toMainDoc').combobox("setValue",toMainDocIdArr[0]);
				}
			},
			onSelect:function(rec){
				if (ServerObj.MainDocMulti=="Y"){
					var selValArr=$('#toMainDoc').combobox("getValues");
					if (selValArr.length>=3){
						$('#toMainDoc').combobox("setValues",selValArr.slice(1,3))
					}
				}
			}
	    });
	})
}
function initMainNurse(){
	var patCurrWardID=$.cm({
		ClassName:"Nur.NIS.Service.Base.Patient",
		MethodName:"GetCurrWardID",
		EpisodeID:ServerObj.EpisodeID
	},false)
	$.cm({
		ClassName:"Nur.NIS.Service.Base.Ward",
		MethodName:"GetMainNursesByWardID",
		wardID:patCurrWardID
	},function(docData){
		$('#fromMainNurse,#toMainNurse').combobox({
			multiple:ServerObj.MainNurseMulti=="Y"?true:false,
			rowStyle:ServerObj.MainNurseMulti=="Y"?"checkbox":"",
			disabled:false,
			blurValidValue:true,
			selectOnNavigation:true,
			valueField:'ID',
			textField:'name',
			data:docData,
			filter: function(q, row){
				var pyjp = getPinyin(row["name"]).toLowerCase();
				return (row["name"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(pyjp.toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},
			onLoadSuccess:function(){
				var fromMainNurIdArr=ServerObj.curMainNurseID.toString().split(",");
				var toMainNurIdArr=ServerObj.targetMainNurID.toString().split(",");
				if (ServerObj.MainNurseMulti=="Y"){
					if (fromMainNurIdArr.length ==0){
						$('#fromMainNurse').combobox("setValues","");
					}else{
						$('#fromMainNurse').combobox("setValues",fromMainNurIdArr);
					}
					if (toMainNurIdArr.length ==0){
						$('#toMainNurse').combobox("setValues","");
					}else{
						$('#toMainNurse').combobox("setValues",toMainNurIdArr);
					}
				}else{
					$('#fromMainNurse').combobox("setValue",fromMainNurIdArr[0]);
					$('#toMainNurse').combobox("setValue",toMainNurIdArr[0]);
				}
			},
			onSelect:function(rec){
				if (ServerObj.MainNurseMulti=="Y"){
					var selValArr=$('#fromMainNurse').combobox("getValues");
					if (selValArr.length>=3){
						$('#fromMainNurse').combobox("setValues",selValArr.slice(1,3))
					}
					var selValArr=$('#toMainNurse').combobox("getValues");
					if (selValArr.length>=3){
						$('#toMainNurse').combobox("setValues",selValArr.slice(1,3))
					}
				}
			}
	    });
	})
}
function SaveClick(){
	var mainDocID=$("#fromMainDoc").combobox("getValues").join(",");
	if ((ServerObj.MainDocRequired=="Y")&&(mainDocID=="")){
		$.messager.popover({msg:'请在下拉框中选择主管医生',type:'error'});
		$('#fromMainDoc').next('span').find('input').focus();
		return false;
	}
	var targetDoctorID=$("#toMainDoc").combobox("getValues").join(",");
	if ((ServerObj.MainDocRequired=="Y")&&(targetDoctorID=="")){
		$.messager.popover({msg:'请在下拉框中选择主管医生',type:'error'});
		$('#toMainDoc').next('span').find('input').focus();
		return false;
	}
	var mainNurseID=$("#fromMainNurse").combobox("getValues").join(",");
	if ((ServerObj.MainNurseRequired=="Y")&&(mainNurseID=="")){
		$.messager.popover({msg:'请在下拉框中选择主管护士',type:'error'});
		$('#fromMainNurse').next('span').find('input').focus();
		return false;
	}
	var targetMainNurID=$("#toMainNurse").combobox("getValues").join(",");
	if ((ServerObj.MainNurseRequired=="Y")&&(targetMainNurID=="")){
		$.messager.popover({msg:'请在下拉框中选择主管护士',type:'error'});
		$('#toMainNurse').next('span').find('input').focus();
		return false;
	}
	var rtn={
		mainDocID:mainDocID,
        mainNurseID:mainNurseID,
        targetDoctorID:targetDoctorID,
        targetMainNurID:targetMainNurID,
		result:true,
	}
	websys_showModal('options').CallBackFunc(rtn);
}
function CancelClick(){
	websys_showModal('options').CallBackFunc({result:false});
}