/**
 * comdate.js
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
	InitCheck();
}

function InitEvent () {
	$("#Save").click(Save_Handler);
	$("#D1-2").checkbox({
		onChecked: function () {
			$("#D1,#D2").checkbox("check");
		},
		onUnchecked: function () {
			$("#D1,#D2").checkbox("uncheck");
		}
	})
	$("#D1-3").checkbox({
		onChecked: function () {
			$("#D1,#D2,#D3").checkbox("check");
		},
		onUnchecked: function () {
			$("#D1,#D2,#D3").checkbox("uncheck");
		}
	})
	$("#D1-4").checkbox({
		onChecked: function () {
			$("#D1,#D2,#D3,#D4").checkbox("check");
		},
		onUnchecked: function () {
			$("#D1,#D2,#D3,#D4").checkbox("uncheck");
		}
	})
	$("#D1-5").checkbox({
		onChecked: function () {
			$("#D1,#D2,#D3,#D4,#D5").checkbox("check");
		},
		onUnchecked: function () {
			$("#D1,#D2,#D3,#D4,#D5").checkbox("uncheck");
		}
	})
	$("#D1-7").checkbox({
		onChecked: function () {
			$("#D1,#D2,#D3,#D4,#D5,#D6,#D7").checkbox("check");
		},
		onUnchecked: function () {
			$("#D1,#D2,#D3,#D4,#D5,#D6,#D7").checkbox("uncheck");
		}
	})
	$("#D1-8").checkbox({
		onChecked: function () {
			$("#D1,#D8").checkbox("check");
		},
		onUnchecked: function () {
			$("#D1,#D8").checkbox("uncheck");
		}
	})
	$("#ALL").checkbox({
		onChecked: function () {
			$("#D1,#D2,#D3,#D4,#D5,#D6,#D7,#D8").checkbox("check");
		},
		onUnchecked: function () {
			$("#D1,#D2,#D3,#D4,#D5,#D6,#D7,#D8").checkbox("uncheck");
		}
	})
}

function PageHandle() {

}

function InitCheck() {
	if (ServerObj.ChemoDays != "") {
		var ChemoArr = ServerObj.ChemoDays.split(",");
		for (var i=0; i<ChemoArr.length; i++) {
			var cid = ChemoArr[i];
			PLObject[cid]="";
			$("#"+cid).checkbox("check");
		}	
		
		debug(PLObject,"PLObject");
	}
}

function Save_Handler () {
	
	
	var mArr = [];
	$("#i-table input[type='checkbox']:checked").each(function(index,element){
		var val = $(element).val();
		mArr.push(val);
	}); 
	var mRtn = mArr.join(",");
	
	parent.ComDateCallBack(mRtn,ServerObj.OrderMasterSeqNo);
	parent.destroyDialog("ComDate_Modal");
	/*
	websys_showModal("hide");
	websys_showModal('options').CallBackFunc(mRtn);
	websys_showModal("close");
	*/
}


