/**
 * ipb.depcfg.hui.js 住院证科室维护
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 */
 
//页面全局变量
var PageLogicObj = {
	m_DepCombox : "",
	m_InDepLen: "",
	m_selectLen: "",
	m_SelectId: "",	//所选择的门诊科室
	m_DefaultId: "" //所选择的默认科室
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
	
	//页面元素初始化
	PageHandle();
})


function Init(){
	//初始化医院
	var hospComp = GenHospComp("Doc_OPAdm_CanCreatBook");
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		$("#mzul").html("")
		$("#jzul").html("")
		$("#jzul-set").html("")
		InitLoc();
	}
	InitLoc();
}
function InitLoc(){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	PageLogicObj.m_DepCombox = $HUI.combobox("#i-loc", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=GetLocByType&TypeList=O^E&HospId="+HospID+"&ResultSetType=array",
		valueField:'rowid',
		textField:'Desc',
		mode: "local",
		filter: function(q, row){
			var ops = $(this).combobox('options');  
			var mCode = false;
			if (row.ContactName) {
				mCode = row.ContactName.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[ops.textField].indexOf(q) >= 0;
			return mCode||mValue;  
		}
	});
	$.m({
			ClassName:"web.DHCDocIPBookNew",
			MethodName:"GetLocByType",
			TypeList:"O^E",
			HospId:HospID
		},function (responseText){
			var dataArr = responseText.split("!");
			for(var i=0; i< dataArr.length; i++) {
				var curRecord = dataArr[i].split("^");
				$("#mzul").append("<li value="+curRecord[1]+">"+curRecord[0]+"</li>");
			}
			
			$("#mzul>li").on('click', function(){
				var id = $(this).attr("value");
				$(this).addClass('active');
				$("#i-select").checkbox("uncheck");
				PageLogicObj.m_SelectId = id;
				PageLogicObj.m_DefaultId = "";	//每次选择清空默认
				var cfgLoc = tkMakeServerCall("web.DHCDocIPBookNew","GetIPBookLocConfig", id);
				var defaultLoc = tkMakeServerCall("DHCDoc.DHCDocConfig.CommonFunction","GetDefaultIPBookLoc", id);
				if (cfgLoc != "" ) {
					PageLogicObj.m_selectLen = cfgLoc.split("^").length;
					cfgLoc = "^" + cfgLoc + "^";
				} else {
					PageLogicObj.m_selectLen = 0;
					$("#jzul-set>li").each(function () {
						if ($(this).text() == "默认") {
							$(this).text("设置为默认").removeClass("default");
						}
					});
				}
				$("#jzul>li").each(function () {
					var curCid = $(this).attr("value");
					cid = "^" + curCid + "^";
					if (cfgLoc.indexOf(cid) >= 0) {
						if (!$(this).hasClass('active')) {
							$(this).addClass('active');
						}
						if (cid == ("^" + defaultLoc + "^")) {
							$(this).addClass('selected');
							PageLogicObj.m_DefaultId = defaultLoc;
							$("#i-" + curCid).html("默认");
							$("#i-" + curCid).addClass("default");
						} else {
							$(this).removeClass('selected');
							$("#i-" + curCid).html("设置为默认");
							$("#i-" + curCid).removeClass("default");
						}
					} else {
						$(this).removeClass('active');
						$(this).removeClass('selected');
						if ($("#i-" + curCid).text() == "默认") {
							$("#i-" + curCid).text("设置为默认").removeClass("default");
						}
					}
				});
				//alert(PageLogicObj.m_InDepLen + ": " + PageLogicObj.m_selectLen) ;
				if ((PageLogicObj.m_InDepLen == PageLogicObj.m_selectLen)) {
					$("#i-select").checkbox("check");
				}

				$("#mzul>li").each(function () {
					var cid = $(this).attr("value");
					if (cid!=id) {
						$(this).removeClass('active');
					}
				});
				$("#jzul-set>li").unbind("click");
				$("#jzul-set>li").on('click', function(){
					var cidV = $(this).attr("id");
					cid = cidV.split("-")[1];
					var inLoc = cid;
					var isDefault = $(this).hasClass("default");
					var LocName = $("#in-" + cid).text();
					var Msg = "您确认<span style='color:blue; font-size:16px;'>设置为默认</span>【" + LocName + "】为默认么？";
					var action = "edit";
					if (isDefault) {
						Msg = "您确认<span style='color:red; font-size:16px;'>取消</span>【" + LocName + "】默认么？";
						action = "cancel";
					}
					$.messager.confirm('提示',Msg,function(r){
						if (r){
							var opLoc = PageLogicObj.m_SelectId;
							if (action == "cancel") {
								inLoc = "";
							}
							var rtn = tkMakeServerCall("DHCDoc.DHCDocConfig.CommonFunction","SetDefaultIPBookLoc", opLoc, inLoc);
							if (rtn == 0) {
								$.messager.alert("提示", "设置为默认成功！", 'info');
								if (action == "cancel") {
									$("#in-" + cid).removeClass('selected');
									$("#i-" + cid).text("设置为默认");
									$("#i-" + cid).removeClass("default");
									PageLogicObj.m_DefaultId = "";
								} else {
									if (PageLogicObj.m_DefaultId !="" ) {
										$("#in-" + PageLogicObj.m_DefaultId).removeClass("selected");
										$("#i-"+ PageLogicObj.m_DefaultId).removeClass("default");
										$("#i-"+ PageLogicObj.m_DefaultId).text("设置为默认");
									}
									$("#in-" + cid).addClass("selected");
									$("#in-" + cid).addClass("active");
									$("#i-"+ cid).addClass("default");
									$("#i-"+ cid).text("默认");
									PageLogicObj.m_DefaultId = cid;
								}
							} else {
								$.messager.alert("提示", "设置为默认失败！", 'info');
								return;
							}
						}   
					});  
				});

			});
		})
	// $("#jzul").append("<li><input id='i-select' type='checkbox' /></li>");
	// $("#jzul-set").append("<li>" + "222"+"</li>");
	// $("#i-select").checkbox({

	// });
	$.m({
			ClassName:"web.DHCDocIPBookNew",
			MethodName:"GetLocByType",
			TypeList:"I",
			HospId:HospID
		},function (responseText){
			var dataArr = responseText.split("!");
			PageLogicObj.m_InDepLen = dataArr.length;
			for(var i=0; i< dataArr.length; i++) {
				var curRecord = dataArr[i].split("^");
				$("#jzul").append("<li id='in-"+ curRecord[1] + "' value="+curRecord[1]+">" + curRecord[0]+"</li>");
				$("#jzul-set").append("<li id=i-"+curRecord[1]+">" + "设置为默认"+"</li>");
			}
			
			$("#jzul>li").on('click', function(){
				//var id = $(this).attr("value");
				if ($(this).hasClass('active')) {
					$(this).removeClass('active');
				} else {
					$(this).addClass('active');
				}
			});
		})
}
function InitEvent(){
	$("#i-save").click(function(){saveCfg()});
	$("#i-find").click(function(){findCfg()});
	$("#i-select").checkbox({
		onChecked: function () {
			var defaultLoc = tkMakeServerCall("DHCDoc.DHCDocConfig.CommonFunction","GetDefaultIPBookLoc", PageLogicObj.m_SelectId);
			$("#jzul>li").each(function () {
				if (!$(this).hasClass('active')) {
					$(this).addClass('active');
				}
				var curCid = $(this).attr("value");
				
				if (curCid == defaultLoc) {
					PageLogicObj.m_DefaultId = defaultLoc;
					$(this).addClass('selected');
					$("#i-" + curCid).html("默认");
					$("#i-" + curCid).addClass("default");
				} else {
					$(this).removeClass('selected');
					$("#i-" + curCid).html("设置为默认");
					$("#i-" + curCid).removeClass("default");
				}

			});
		},
		onUnchecked: function () {
			$("#jzul>li").each(function () {
				if ($(this).hasClass('active')) {
					$(this).removeClass('active');
					$(this).removeClass('selected');
				}
			});
			$("#jzul-set>li").each(function () {
				if ($(this).hasClass('default')) {
					$(this).removeClass('default');
				}
				if ($(this).text() == "默认") {
					$(this).text("设置为默认");
				}
			});
		}
	});
	

	//$(document.body).bind("keydown",BodykeydownHandler)
}

function PageHandle(){
	//
}

function findCfg () {
	var findValue = PageLogicObj.m_DepCombox.getValue()||"";
	
	$("#mzul>li").each(function () {
		var hasHClass = $(this).hasClass('hidden');
		var hasAClass = $(this).hasClass('active');
		var cid = $(this).attr("value");
		if (findValue == "") {
			if(hasHClass) {
				$(this).removeClass('hidden');
			}
			if(hasAClass) {
				$(this).removeClass('active');
			}
		} else {
			if (cid!=findValue) {
				if (!hasHClass) {
					$(this).addClass('hidden');
					if(hasAClass) {
						$(this).removeClass('active');
					}
				}
			} else {
				if (hasHClass) {
					$(this).removeClass('hidden');
				}
				if(hasAClass) {
					$(this).removeClass('active');
				}
			}
		}
	})
	$("#jzul>li").each(function () {
		var cid = $(this).attr("value");
		var hasAClass = $(this).hasClass('active');
		if (hasAClass) {
			$(this).removeClass('active');
			$(this).removeClass('selected');
		}
	});
	$("#i-select").checkbox("uncheck");
	$("#jzul-set>li").unbind("click");
	$("#jzul-set>li").each(function () {
		$(this).removeClass("default");
		$(this).text("设置为默认");
	})
				
}
function saveCfg() {
	//获取住院科室
	var ipLoc = "",opLocArr = [];
	$("#jzul>li.active").each(function () {
		if (ipLoc == "") {
			ipLoc = $(this).attr("value");
		} else {
			ipLoc = ipLoc + "^" + $(this).attr("value");
		}
	})
	$("#mzul>li.active").each(function () {
		opLocArr.push($(this).attr("value"));
	})
	if (opLocArr.length == 0) {
		$.messager.alert("提示", "未选中有效得门诊科室！", 'info');
		return false;
	}
	if (ipLoc == ""){
		$.messager.confirm("提示", "您未选中住院科室是否继续,继续将清空门诊已选权限！", function (r) {
			if (r) {
				for (var i=0; i< opLocArr.length; i++) {
					var opLoc = opLocArr[i];
					var rtn = tkMakeServerCall("web.DHCDocIPBookNew","SetIPBookLocConfig", opLoc, ipLoc);
				}
				$.messager.alert("提示", "保存成功！", 'info');
				//alert("成功保存门诊科室权限:"+num+"条")
			} else {
				return false;
			}
		})
	} else {
		for (var i=0; i< opLocArr.length; i++) {
			var opLoc = opLocArr[i];
			var rtn = tkMakeServerCall("web.DHCDocIPBookNew","SetIPBookLocConfig", opLoc, ipLoc);
		}
		$.messager.alert("提示", "保存成功！", 'info');
	}
	
}

function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	//浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }   
}


