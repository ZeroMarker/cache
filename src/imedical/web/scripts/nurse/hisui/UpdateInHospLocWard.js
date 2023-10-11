$(function() {
	//初始化科室列表
	initLocList();
	setSaveBtnStatus();
})
function initLocList(){
	$.cm({
		ClassName:"Nur.NIS.Service.Base.Loc",
		QueryName:"GetLocsExceptAdmLoc",
		locDesc:"",
		locType:"E",
		episodeID:ServerObj.episodeID,
		transType:"",
		hospId:session['LOGON.HOSPID'],
		rows:99999
	},function(data){
		$("#locList").combobox({
			valueField:"ID",
			textField:"desc",
			data:data.rows,
			filter:function(q, row){
				return (row["desc"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["searchCode"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},
			onSelect:function(rec){
				if (rec){
					var limitFlag = rec.ageSexLimitFlag;
			        if (limitFlag == "Y") {
				        $.messager.popover({ msg: "所选择的科室有性别/年龄限制!", type:'error' });	
				        
				        return false;
			        }
					locChange();
				}
			},
			onChange:function(newValue, oldValue){
				if (!newValue){
					setSaveBtnStatus();
				}
			}
		});
	})
	onRadioChange();
}
function onRadioChange(e,value){
	setTimeout(function(){
		var chk=$("input[name='updateType']:checked");
		 var type=chk[0].value;
		 if (type=="Loc"){
			 $("label[for=locList]").addClass("clsRequired");
			 $("#locList").combobox("enable");
			 $("#wardList").combobox("setValue","").combobox("setText","").combobox("disable");
	     }else{
		     $("label[for=locList]").removeClass("clsRequired");
		     $("#locList").combobox("setValue","").combobox("setText","").combobox("disable");
		     $("#wardList").combobox("enable");
		     getUpdateLocLinkWardByAdm();
		 }
	})
}
function locChange(){
	var locId=getlocId();
	if (locId){
		$("#wardList").combobox("setValue","").combobox("setText","").combobox("enable");
		getLocLinkWards(locId);
	}else{
		getUpdateLocLinkWardByAdm();
	}
}
function getLocLinkWards(locId){
	$.cm({
		ClassName:"Nur.NIS.Service.Base.Loc",
		MethodName:"GetTransLocLinkWards",
		locID:locId,
		currWardID:ServerObj.wardID,
		exceptFlag:"Y",
		episodeID:ServerObj.episodeID,
	},function(data){
		$("#wardList").combobox({
			valueField:"wardID",
			textField:"wardDesc",
			data:data,
			filter:function(q, row){
				return (row["wardDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["searchCode"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},
			onSelect:function(rec){
				if (rec){
					var limitFlag = rec.ageSexLimitFlag;
			        if (limitFlag == "Y") {
				        $.messager.popover({ msg: "所选择的病区有性别/年龄限制!", type:'error' });	
				        return false;
			        }
			        setSaveBtnStatus();
				}
			},
			onLoadSuccess:function(){
				var data=$("#wardList").combobox("getData");
				if (data.length === 1 && data[0].ageSexLimitFlag === "N") {
					$("#wardList").combobox("select",data[0].wardID);
				}
			},
			onChange:function(newValue, oldValue){
				if (!newValue){
					setSaveBtnStatus();
				}
			}
		});
	})
}
function getUpdateLocLinkWardByAdm(){
	$.cm({
		ClassName:"Nur.NIS.Service.Base.Loc",
		QueryName:"GetTransLocLinkWardsByAdmQuery",
		keyWord:"",
		Adm:ServerObj.episodeID,
		currWardID:ServerObj.wardID,
		exceptFlag:"Y",
		hospId:session['LOGON.HOSPID'],
		rows:99999
	},function(data){
		$("#wardList").combobox({
			valueField:"wardID",
			textField:"desc",
			data:data.rows,
			filter:function(q, row){
				return (row["desc"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["searchCode"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},
			onSelect:function(rec){
				if (rec){
					var limitFlag = rec.ageSexLimitFlag;
			        if (limitFlag == "Y") {
				        $.messager.popover({ msg: "所选择的病区有性别/年龄限制!", type:'error' });	
				        return false;
			        }
			        setSaveBtnStatus();
				}
			},
			onLoadSuccess:function(){
				var data=$("#wardList").combobox("getData");
				if (data.length === 1 && data[0].ageSexLimitFlag === "N") {
					$("#wardList").combobox("select",data[0].wardID);
				}
			},
			onChange:function(newValue, oldValue){
				if (!newValue){
					setSaveBtnStatus();
				}
			}
		});
	})
}
function setSaveBtnStatus(){
	$("#save").hide();
	var locId=$("#locList").combobox("getValue");
	var wardId=$("#wardList").combobox("getValue");
	var chk=$("input[name='updateType']:checked");
	var type=chk[0].value;
	if (type=="Loc"){
		if ((locId)&&(wardId)) {
			$("#save").show();
		}
    }else{
	    if (wardId) {
			$("#save").show();
		}
	}
}
function saveBtn(){
	var chk=$("input[name='updateType']:checked");
    var type=chk[0].value;
	var locId=getlocId();
	if ((!locId)&&(type=="Loc")){
		$.messager.popover({ msg: "请从下拉框中选择科室！", type:'error' });	
		return false;
	}
	var wardId=getWardId();
	if (!wardId){
		$.messager.popover({ msg: "请从下拉框中选择科室！", type:'error' });	
		return false;
	}
	websys_showModal("options").CallBackFunc({result:true,locId:locId,wardId:wardId});
	
	/*if (type=="Loc"){
		$.m({
			ClassName:"Nur.NIS.Service.Transaction",
			MethodName:"updateInHospitalLocWard",
			admId:ServerObj.episodeID,
			locId:locId,
			wardId:wardId,
			userId:session['LOGON.HOSPID']
		},function(rtn){
			if (rtn!=0){
				$.messager.popover({ msg: rtn, type:'error' });	
				return false;
			}
			closeBtn();
		})
	}else{
		$.m({
			ClassName:"Nur.NIS.Service.Transaction",
			MethodName:"updateInHospitalWard",
			admId:ServerObj.episodeID,
			wardId:wardId,
			userId:session['LOGON.HOSPID']
		},function(rtn){
			if (rtn!=0){
				$.messager.popover({ msg: rtn, type:'error' });	
				return false;
			}
			closeBtn();
		})
	}*/
}
function closeBtn(){
	websys_showModal("options").CallBackFunc({result:false});
}
function getWardId(){
	var wardId=$("#wardList").combobox("getValue");
	if ($.hisui.indexOfArray($("#wardList").combobox("getData"),"wardID",wardId)<0) {
		wardId="";
	}
	return wardId;
}
function getlocId(){
	var locId=$("#locList").combobox("getValue");;
	if ($.hisui.indexOfArray($("#locList").combobox("getData"),"ID",locId)<0) {
		locId="";
	}
	return locId;
}