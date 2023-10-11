/**
 * common.js
 * 
 * Copyright (c) 2020-2090 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-09-03
 * 
 */
 
var PLObject = GlobalObj = PageLogicObj = {}

function GetSession(type) {
	var mRtn="",
		type = type||"USER";
	
	if (type == "USER") {
		mRtn = session['LOGON.USERID'];
	} else if (type == "DEP") {
		mRtn = session['LOGON.CTLOCID'];
	} else if (type == "HOSP") {
		mRtn = session['LOGON.HOSPID'];
	} else if (type == "WARD") {
		mRtn = session['LOGON.WARDID'];
	} else if (type == "GROUP") {
		mRtn = session['LOGON.GROUPID'];
	} else if (type == "LANG") {
		mRtn = session['LOGON.LANGID'];
	} else if (type =="ALL") {
		mRtn = session['LOGON.USERID'];
	    mRtn += "^" + session['LOGON.GROUPID'];
	    mRtn += "^" + session['LOGON.CTLOCID'];
	    mRtn += "^" + session['LOGON.HOSPID'];
	    mRtn += "^" + session['LOGON.WARDID'];
	    mRtn += "^" + session['LOGON.LANGID'];
	}
    
    return mRtn;
}

function debug(printVal,printDesc) {
	printDesc=printDesc||"";
	var mode=1
	if (mode==1) {
		if (printDesc!="") {
			var datatype= typeof printVal
			if (datatype=="object") {
				console.log("%c "+printDesc+": ",'color:red;font-size:16px')
				console.log(printVal)
				//console.table(printVal)
			} else {
				console.log(printDesc + ": " + printVal)
			}
			
		} else {
			console.log(printVal)
		}
	} else {
		//todo...	
	}
}

function showMask(id,msg){
	//$("<div class=\"datagrid-mask\"></div>").css({display:"block",width:"100%",height:$(window).height()}).appendTo("body"); 
    //$("<div class=\"datagrid-mask-msg\"></div>").html("正在处理，请稍候。。。").appendTo("body").css({display:"block",left:($(document.body).outerWidth(true) - 190) / 2,top:($(window).height() - 45) / 2});
    if (msg!="") {
		msg="<label style='color:#509DE1;'>"+msg+"</lable>" ;  
	}
    $("<div class=\"datagrid-mask\"></div>").css({display:"block",width:$(id).width(),height:$(id).height()}).appendTo(id); 
    $("<div class=\"datagrid-mask-msg\"></div>").html(msg).appendTo(id).css({display:"block",left:($(id).outerWidth(true)-100) / 2,top:($(id).height() - 45) / 2}); 
}
function hideMask(){
    $(".datagrid-mask").hide();
    $(".datagrid-mask-msg").hide();
}

function SetToInput(selector) {
	$(selector).next().remove();
	$(selector).css('display','').attr("class","textbox");	
}

function SetToCombox(selector) {
	$(selector).css('display','none');	
	$('.combo-arrow').css('display','inline-block');
}
function SwitchComboInput (selector, type) {
	if (type === "combox") {
		$(selector).css('display','none');
		$(selector).simplecombobox({
			onBeforeLoad: function(param){
				param.ClassName="DHCAnt.QRY.Config.RAQ";
				param.QueryName="QryCommonType";
				param.ModuleName="combobox";
				param.Arg1= arg1;
				param.Arg2= "";
				param.ArgCnt=2;
			}
		});
		
		$('.combo-arrow').css('display','');
		if (browserType == "Chrome") {
			$(selector).next().children("input:first-child").css('width', '135');
		}
	} else {
		$(selector).next().remove();
		$(selector).css('display','');
	}
};

function StopButtonEvent(ids) {
	if (ids=="") return false;
	var idsArr = ids.split(",");
	for (var i=0; i<idsArr.length; i++) {
		var opt = $(idsArr[i]).linkbutton('options');
		opt.stopAllEventOnDisabled=true;
	}
}
 