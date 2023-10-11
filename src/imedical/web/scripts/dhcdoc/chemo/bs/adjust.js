/**
 * adjust.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-07-15
 * 
 * 
 */
$(function() {
	Init();
	InitEvent();
	//PageHandle();
})


function Init(){
	InitCombox();
	InitData();
}

function InitData() {
	if (ServerObj.VSData!="") {
		var VSArr = ServerObj.VSData.split("^");
		$("#Height").val(VSArr[0]);
		$("#Weight").val(VSArr[1]);
		$("#BSA").val(VSArr[2]);
		$("#GFR").val(VSArr[3]);
		$("#SC").val(VSArr[4]);
		$("#BSAUnitSTD").val(VSArr[5]);
		PLObject.m_Formula.setValue(VSArr[6]);
		$("#IBW").val(VSArr[7]);
		
		var BSA = ParseNumber(VSArr[2]),
			BSAUnitSTD = ParseNumber(VSArr[5]),
			GFR = ParseNumber(VSArr[3]);
			
		if (VSArr[6]=="BSA") {
			if ((BSA=="")||(BSAUnitSTD=="")||(BSAUnitSTD==0)) {
				return false;
			}
			var STDDose = BSAUnitSTD*BSA;
			var FinalDose= Math.ceil(STDDose);
			var BSAUnit = (FinalDose/BSA).toFixed(4)
			$("#STDDose").val(STDDose);
			$("#AdjDose").val(STDDose);
			$("#FinalDose").val(FinalDose);
			$("#BSAUnit").val(BSAUnit);
			
		} else if (VSArr[6]=="GFR") {
			$("#Target").text("Target AUC")
			$(".dose").text("")
			if ((GFR=="")||(BSAUnitSTD=="")) {
				return false;
			}
			var STDDose = CalcGFRDose(BSAUnitSTD, GFR)
			var FinalDose = Math.ceil(STDDose);
			var BSAUnit = CalcAUC(FinalDose,GFR)
			
			$("#STDDose").val(STDDose);
			$("#AdjDose").val(STDDose);
			$("#FinalDose").val(FinalDose);
			$("#BSAUnit").val(BSAUnit);
			
		} else {
			$(".dose").text("mg/kg")
		}
	}	
}

function InitCombox () {
	PLObject.m_Formula = $HUI.combobox("#Formula", {
		url:$URL+"?ClassName=DHCDoc.Chemo.COM.Qry&QueryName=QryFormula&ResultSetType=array",
		valueField:'id',
		textField:'text',
		disabled:true,
		blurValidValue:true
	});
}

function BSACal(BSAUnitSTD,BSA,percent) {
	if (BSAUnitSTD!="") {
		var STDDose = BSAUnitSTD*BSA;
		var AdjDose = ((percent*BSAUnitSTD*BSA)/100).toFixed(2);
		$("#STDDose").val(STDDose);
		$("#AdjDose").val(AdjDose);
		var FinalDose = Math.floor(AdjDose * 10) / 10;
		var BSAUnit = (FinalDose/BSA).toFixed(4);
		$("#FinalDose").val(FinalDose);
		$("#BSAUnit").val(BSAUnit);
	} else {
		$("#STDDose").val("");
		$("#AdjDose").val("");
	}
			
}

function GRFCal(BSAUnitSTD,GFR,percent) {
	if (BSAUnitSTD!="") { 
		var STDDose = CalcGFRDose(BSAUnitSTD, GFR)
		var AdjDose = CalcGFRDose(BSAUnitSTD, GFR,percent/100)
		//var FinalDose = Math.ceil(STDDose);
		var FinalDose = Math.floor(AdjDose * 10) / 10;
		var BSAUnit = CalcAUC(FinalDose,GFR)
		
		$("#STDDose").val(STDDose);
		$("#AdjDose").val(AdjDose);
		$("#FinalDose").val(FinalDose);
		$("#BSAUnit").val(BSAUnit);
	} else {
		$("#STDDose").val("");
		$("#AdjDose").val("");
		
	}	
}

function WGTCal(BSAUnitSTD,Weight) {
	if (BSAUnitSTD!="") { 
		var FinalDose = Weight*BSAUnitSTD
		var BSAUnit = BSAUnitSTD
		$("#FinalDose").val(FinalDose);
		$("#BSAUnit").val(BSAUnit);
	} else {
		$("#FinalDose").val("");
		$("#BSAUnit").val("");	
	}	
}

function InitEvent () {
	
	$HUI.numberspinner("#Percent",{
		onChange:function () {
			var percent = $(this).val();
			var BSAUnitSTD = $.trim($("#BSAUnitSTD").val());
			var BSA = $.trim($("#BSA").val());
			var AdjDose = ((percent*BSAUnitSTD*BSA)/100).toFixed(2);
			$("#AdjDose").val(AdjDose);
			//重新计算
			var Formula = PLObject.m_Formula.getValue()||"";
			if (Formula=="BSA") {
				BSACal(BSAUnitSTD,BSA,percent)
				
			} else if(Formula=="GFR") {
				var GFR = ParseNumber($.trim($("#GFR").val()));
				GRFCal(BSAUnitSTD,GFR,percent)
			} else {
				//var Weight = ParseNumber($.trim($("#Weight").val()));
				//WGTCal(BSAUnitSTD,Weight)
			}
		}	
	})
	
	$("#FinalDose").keyup (function () {
		var Formula = PLObject.m_Formula.getValue()||"";
		if (Formula == "") {
			$.messager.alert("提示","请先选择公式！","warning");
			return false;
		}
		
		var FinalDose = ParseNumber($(this).val());
		var GFR = ParseNumber($.trim($("#GFR").val()));
		var percent = ParseNumber($.trim($("#Percent").val()));
		var BSA = ParseNumber($.trim($("#BSA").val()));
		var Weight = ParseNumber($.trim($("#Weight").val()));
		
		if (FinalDose=="") {
			$("#BSAUnit").val("");
		}
		
		var isOK = CheckValue(Formula)
		if (!isOK) {
			return false;
		}
		
		if (Formula == "BSA") {
			if (FinalDose!="") {
				var BSAUnit = (FinalDose/BSA).toFixed(4);
				$("#BSAUnit").val(BSAUnit);
			} else {
				$("#BSAUnit").val("");
			}
		} else if (Formula == "GFR") {
			if (FinalDose!="") {
				var BSAUnit = CalcAUC(FinalDose,GFR)
				$("#BSAUnit").val(BSAUnit);
			} else {
				$("#BSAUnit").val("");
			}
		} else if (Formula == "WGT") {
			if (FinalDose!="") {
				var BSAUnit = (FinalDose/Weight).toFixed(4);
				$("#BSAUnit").val(BSAUnit);
			} else {
				$("#BSAUnit").val("");
			}
		} else {
			
		}
		
	})
	
	$("#BSAUnitSTD").keyup (function () {
		var Formula = PLObject.m_Formula.getValue()||"";
		if (Formula == "") {
			$.messager.alert("提示","请先选择公式！","warning");
			return false;
		}
		var BSAUnitSTD = $(this).val();
		var percent = ParseNumber($.trim($("#Percent").val()));
		var BSA = ParseNumber($.trim($("#BSA").val()));
		var GFR = ParseNumber($.trim($("#GFR").val()));
		var Weight = ParseNumber($.trim($("#Weight").val()));
		
		if (BSAUnitSTD=="") {
			$("#STDDose").val("");
			$("#AdjDose").val("");
			return false;
		}
		BSAUnitSTD = ParseNumber(BSAUnitSTD);
		var isOK = CheckValue(Formula)
		if (!isOK) {
			return false;
		}
		
		if (Formula == "BSA") {
			BSACal(BSAUnitSTD,BSA,percent)
			
		} else if (Formula == "GFR") {
			GRFCal(BSAUnitSTD,GFR,percent)
			
		} else if(Formula == "WGT"){
			WGTCal(BSAUnitSTD,Weight)
			
		} else {
			
		}
		
	})
	
	$("#Save").click(Save_Handler)
}
function PageHandle() {

}

function CheckValue(Formula) {
	var BSAUnitSTD = ParseNumber($("#BSAUnitSTD").val());
	var percent = ParseNumber($.trim($("#Percent").val()));
	var BSA = ParseNumber($.trim($("#BSA").val()));
	var GFR = ParseNumber($.trim($("#GFR").val()));
	var Weight = ParseNumber($.trim($("#Weight").val()));
	if (Formula == "BSA") {
		if (BSA=="") {
			$.messager.alert("提示","清输入正确的BSA！","warning")
			return false;
		} else if (BSAUnitSTD == "") {
			$.messager.alert("提示","清输入正确的目标值！","warning",function () {
				$("#BSAUnitSTD").focus();	
			})
			return false;
		} else {
			
		}
	} else if (Formula == "GFR") {
		if (GFR=="") {
			$.messager.alert("提示","清输入正确的GFR！","warning")
			return false;
		} else if (BSAUnitSTD == "") {
			$.messager.alert("提示","清输入正确的目标值！","warning",function () {
				$("#BSAUnitSTD").focus();
			})
			return false;
		} else {
			
		}
	} else if(Formula == "WGT"){
		if (Weight=="") {
			$.messager.alert("提示","清输入正确的体重！","warning")
			return false;
		} else if (BSAUnitSTD == "") {
			$.messager.alert("提示","清输入正确的目标值！","warning",function () {
				$("#BSAUnitSTD").focus();	
			})
			return false;
		} else {
			
		}
	}
		
	return true;
}

function Save_Handler () {
	var ADJAry = [];
	var ID = "";
	var Item = ServerObj.PGIId;
	var Percent = $.trim($("#Percent").val());
	var BSA = $.trim($("#BSA").val());
	var GFR = $.trim($("#GFR").val());
	var SC = $.trim($("#SC").val());
	var Height = $.trim($("#Height").val());
	var Weight = $.trim($("#Weight").val());
	var Formula = PLObject.m_Formula.getValue();
	var BSAUnitSTD = $.trim($("#BSAUnitSTD").val());
	var BSAUnit = $.trim($("#BSAUnit").val());
	var FinalDose = $.trim($("#FinalDose").val());
	var Arcim = ServerObj.ArcimDR;
	var User = session['LOGON.USERID'];
	var Loc = session['LOGON.CTLOCID'];
	var Reason = $.trim($("#Reason").val());
	var IBW =  $.trim($("#IBW").val());
	if (Reason == "") {
		$.messager.alert("提示", "请填写调整原因！", "info");
		return false;
	}
	ADJAry.push(ID,Item,Percent,BSA,GFR,SC,Height,Weight,Formula,BSAUnitSTD,BSAUnit,FinalDose,Arcim,User,Loc,Reason,IBW)
	
	$cm({
			ClassName: "DHCDoc.Chemo.BS.Ext.ItemAdj",
			MethodName: "Save",
			ADJAry: ADJAry
		},function(result){
			if (result >= 0) {
				//$.messager.alert("提示", "保存成功！", "info", function () {
				websys_showModal("hide");
				websys_showModal('options').CallBackFunc(BSAUnit,FinalDose);
				websys_showModal("close");	
				//})
			} else {
				$.messager.alert("提示", "保存失败：" + result , "info");
				return false;
			}
	});
}


