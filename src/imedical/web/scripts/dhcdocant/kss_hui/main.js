/**
 * main.js 抗菌药物主界面
 * 
 * Copyright (c) 2016-2020 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2016-07-24
 * 
 */
 if (websys_isIE==true) {
     var script = document.createElement('script');
     script.type = 'text/javaScript';
     script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird 文件地址
     document.getElementsByTagName('head')[0].appendChild(script);
}
$(function(){
	//初始化组件显示状态
	$.DHCAnt.initKSSConfig(KSSConfig);
	$.DHCAnt.doBaseInfo(KSSConfig);
	$.DHCAnt.initConfigLayout(KSSConfig);
	
	$.DHCAnt.drawMainInerface();
	$.DHCAnt.extendFunction();
	$.DHCAnt.doUI();
	
	function downShadow() {
		//获取#middle的位置
		var startPos = $("#main").offset().top;
		$.event.add(window, "scroll", function () {
			var p = $(window).scrollTop();
			$("#top").css('box-shadow', ((p) > startPos) ? '0 0 5px #888' : '0 0 0 #888');
		});
	}
	downShadow();
	//保存与取消
	$("#i-btn-submit").on('click', function(){
		//$(this).linkbutton("disable");
		
		//基础参数
		var useaimMainObj={},applyMainObj={},consultMainObj={};
		useaimMainObj.SKSS3IND = KSSConfig.SKSS3IND;
		useaimMainObj.SUSEDRUGTIME = KSSConfig.SUSEDRUGTIME;
		useaimMainObj.SBJ = KSSConfig.SBJ;
		useaimMainObj.OrderPoisonCode = PARAMObj.OrderPoisonCode;
		useaimMainObj.needApply = 0;
		useaimMainObj.needConsult = 0;

		//扩展参数: 2019-01-28
		var extendOBJ = {
			blContent:""	//病例简要
		};
		
		//本地化项目信息
		var ModePrjInfo = "";
		if (KSSConfig.LOCALMODEL == 2) {
			ModePrjInfo = GetModePrjInfo();
		}
		
		//获取信息
		$.DHCAnt.getUseAim(useaimMainObj);			//获取使用目的
		$.DHCAnt.getZBacterium(useaimMainObj);		//获取病原学相关
		if (KSSConfig.SUSEDRUGTIME) {			
			$.DHCAnt.getDrugTime(useaimMainObj); 	//获取用药时间相关
		};
		if(!$.DHCAnt.validateUseAim(useaimMainObj)) return false;	//验证
		
		//差一个流程类型没有获取
		if (PARAMObj.ShowTabStr.indexOf("Apply") >= 0) {
			useaimMainObj.needApply = 1;
			$.DHCAnt.getApplyInfo(applyMainObj);	//获取申请信息
			if(!$.DHCAnt.validateApplyInfo(applyMainObj)) return false;			//验证越级是否填写原因
		};
		
		//获取会诊信息
		if (PARAMObj.ShowTabStr.indexOf("Consult") >= 0) {
			useaimMainObj.needConsult = 1;
			if ((!KSSConfig.DEFAULTCONDEP)||(!KSSConfig.DEFAULTCONDOC)) {
				consultMainObj.DEFAULTCONDEP = 0;
				consultMainObj.DEFAULTCONDOC = "";
				if (!KSSConfig.CONDEPNUM) {
					consultMainObj.CONDEPNUM  = 1;
				} else {
					consultMainObj.CONDEPNUM = KSSConfig.CONDEPNUM;	//会诊科室个数
				}
				$.DHCAnt.getConsultInfo(consultMainObj);
				if(!$.DHCAnt.validateConsultInfo(consultMainObj)) return false;	//验证是否填写会诊科室和医生
			} else {
				consultMainObj.DEFAULTCONDEP = KSSConfig.DEFAULTCONDEP;
				consultMainObj.DEFAULTCONDOC = KSSConfig.DEFAULTCONDOC;
			}
		};
		
		//保存与插入
		//基本信息：admId^ssid^arcim^使用目的^用药指征^感染部位^用药时机^是否送检^药敏记录^手术记录
		var sperator = "^", 
			dataOrder = [];
			newOrder = "BaseInfo,Kss3Indication,Zbj,UsedrugTime,Apply,Consult";
			kss3IndicationInfo = "",
			zbjInfo = "",
			usedrugTimeInfo = "",
			applyInfo = "",
			consultInfo = "",
			saveType = "base",
			finallyUseAimArray = [],
			finallyUseAimInfo = "";
		var baseInfo = PARAMObj.PAADMRowid + sperator + session['LOGON.USERID'] + sperator + PARAMObj.ArcimRowid + sperator
						+ useaimMainObj.useaim + sperator + useaimMainObj.usedrugIndication + sperator + useaimMainObj.infectionSite
						+ sperator + useaimMainObj.usedrugTime + sperator + useaimMainObj.isLab + sperator + useaimMainObj.sensitiveIds.join(',')
						+ sperator + useaimMainObj.operIds.join(',');
		finallyUseAimArray["BaseInfo"] = baseInfo;
		dataOrder.push("BaseInfo");
		
		//特抗药指征
		if (($.trim(useaimMainObj.SKSS3IND) == "1") && (PARAMObj.OrderPoisonCode == "KSS3")) {
			dataOrder.push("Kss3Indication");
			kss3IndicationInfo = useaimMainObj.kss3Indication;
			finallyUseAimArray["Kss3Indication"] = kss3IndicationInfo;
		};
		
		//致病菌
		if ($.trim(useaimMainObj.SBJ) == "1") {
			dataOrder.push("Zbj");
			zbjInfo = useaimMainObj.zBj;
			finallyUseAimArray["Zbj"] = zbjInfo;
		};
		
		//用药时间控制
		if ($.trim(useaimMainObj.SUSEDRUGTIME) == "1") {
			dataOrder.push("UsedrugTime");
			usedrugTimeInfo = useaimMainObj.pretime + sperator + useaimMainObj.extensionreason;
			finallyUseAimArray["UsedrugTime"] = usedrugTimeInfo;
		}
		
		//申请
		//获取申请信息: 
		if ($.trim(useaimMainObj.needApply) == "1") {
			dataOrder.push("Apply");
			saveType = "apply";
			if (!applyMainObj.emreason) {	//处理undefined
				applyMainObj.emreason = "";
			};
			applyInfo = applyMainObj.isEm + sperator + applyMainObj.emreason + sperator + session['LOGON.CTLOCID'] + sperator + KSSConfig.processType + sperator + KSSConfig.processInfo + sperator + KSSConfig.lastAuditUser ;
			finallyUseAimArray["Apply"] = applyInfo;
		};
		
		//会诊信息
		if ($.trim(useaimMainObj.needConsult) == "1") {
			dataOrder.push("Consult");
			saveType = "consult";
			extendOBJ.blContent = $("#i-blcontent").val();
			if ((!KSSConfig.DEFAULTCONDEP)||(!KSSConfig.DEFAULTCONDOC)) {
				consultInfo = consultMainObj.DEFAULTCONDEP + sperator + consultMainObj.CONDEPNUM + sperator;
				switch ($.trim(consultMainObj.CONDEPNUM)){
					case "3":
						consultInfo = consultInfo + consultMainObj.consultDep1 + sperator + consultMainObj.consultDoc1 + sperator 
									+ consultMainObj.consultDep2 + sperator + consultMainObj.consultDoc2 + sperator
									+ consultMainObj.consultDep3 + sperator + consultMainObj.consultDoc3 + sperator;
						break;
					case "2":
						consultInfo = consultInfo + consultMainObj.consultDep1 + sperator + consultMainObj.consultDoc1 + sperator 
									+ consultMainObj.consultDep2 + sperator + consultMainObj.consultDoc2 + sperator
									+ "" + sperator + "";
						break;
					default:
						consultInfo = consultInfo + consultMainObj.consultDep1 + sperator + consultMainObj.consultDoc1 + sperator 
									+ "" + sperator + "" + sperator
									+ "" + sperator + "";
				};
				consultInfo = consultInfo + sperator + consultMainObj.DEFAULTCONDOC;
				
			} else {
				consultInfo = consultMainObj.DEFAULTCONDEP + sperator + "1" + sperator + "" 
							+ sperator + "" + sperator + "" + sperator + "" + sperator 
							+ "" + sperator + "" + sperator + consultMainObj.DEFAULTCONDOC;
			};
			finallyUseAimArray["Consult"] = consultInfo;
		};
		
		/* 
		//实现动态参数拼接
		for (var k = 0; k < dataOrder.length; k++ ) {
			if (!finallyUseAimInfo) {
				finallyUseAimInfo = finallyUseAimArray[dataOrder[k]];
			} else {
				finallyUseAimInfo = finallyUseAimInfo + "!" + finallyUseAimArray[dataOrder[k]];
			};
		};
		*/
		
		//静态参数拼接
		var finallySeprator="!";
		finallyUseAimInfo = baseInfo + finallySeprator + kss3IndicationInfo + finallySeprator + zbjInfo
							+ finallySeprator + usedrugTimeInfo + finallySeprator + applyInfo + finallySeprator
							+ consultInfo;
		//alert(finallyUseAimInfo);
		//return false;
		//resultStr: 1,useaimId,applyId
		//replace(/[\-\_\,\!\|\~\`\(\)\#\$\%\^\&\*\{\}\:\;\"\L\<\>\?]/g, '');
		extendOBJ.blContent = extendOBJ.blContent.replace(/[\^]/g, '');
		var extendPara = extendOBJ.blContent;
		var resultStr = $.InvokeMethod("DHCAnt.KSS.MainBusiness","DBsave", saveType, newOrder, finallyUseAimInfo, extendPara, ModePrjInfo);
		var resultArr = resultStr.split("^");
		
		if (resultArr[0] == 1) {
			//alert("保存成功！");
			$.messager.alert('提示','保存成功！','info',function () {
				closeSubWin(1,resultArr[1],resultArr[2],useaimMainObj,applyMainObj);
			});
		} else {
			alert("保存失败！");
			$.messager.alert('提示','保存失败！','info');
		};
		return false;
	});
	
	$("#i-btn-cancel").on('click', function(){
		closeSubWin(0);
		return false;
	});
	
	//引用
	$("#i-quto").on("click", function () {
		//dhcem.consultpatemr.csp
		var url="dhcem.patemrque.csp?&EpisodeID="+PARAMObj.PAADMRowid+"&PatientID="+PARAMObj.PatientID+"&targetName=Attitude"+"&TextValue="; //+obj.text;
		window.parent.InsQuote = function (result) {
			websys_showModal("close");
			if (result){
				if ($("#i-blcontent").val() == ""){
					$("#i-blcontent").val(result);
				}else{
					$("#i-blcontent").val($("#i-blcontent").val()  +"\r\n"+ result);
				}
			}
		}
		websys_showModal({
			url:url,
			title:'病历引用',
			width:1300,height:600,
			CallBackFunc:function(result){
				websys_showModal("close");
				if (result){
					if ($("#i-blcontent").val() == ""){
						$("#i-blcontent").val(result.innertTexts);
					}else{
						$("#i-blcontent").val($("#i-blcontent").val()  +"\r\n"+ result.innertTexts);
					}
				}
			}
		});
		/*var result = window.showModalDialog(url,"_blank",'dialogTop:280;dialogWidth:1300px;DialogHeight=600px;center=1'); 
		try{
			if (result){
					if ($("#i-blcontent").val() == ""){
						$("#i-blcontent").val(result.innertTexts);
					}else{
						$("#i-blcontent").val($("#i-blcontent").val()  +"\r\n"+ result.innertTexts);
					}
			}
		}catch(ex){}*/
	});
	
	function closeSubWin(saveFlag,useaimId,applyId,useaimMainObj,applyMainObj){
		var finalMainRetrun="";
		if (saveFlag) {
			if ((useaimMainObj.needApply == 1) && (applyMainObj.isEm)) {
				finalMainRetrun = useaimId+"!"+applyId+"!"+"isEmergency";
			};
			if((!useaimMainObj.needApply)&&(!useaimMainObj.needConsult)){
				finalMainRetrun =useaimId+"!"+"!";
			};
		};
		$.DHCAnt.closeWin(finalMainRetrun);
	};
	
	function GetModePrjInfo(){
		var myxml = "";
		var myparseinfo = PARAMObj.ModePrjEntity;
		var myxml = GetEntityClassInfoToXML(myparseinfo)
		return myxml;
	}
	
	function GetEntityClassInfoToXML(ParseInfo) {
		var myxmlstr="";
		try{
			var myary=ParseInfo.split("^");
			var xmlobj=new XMLWriter();
			xmlobj.BeginNode(myary[0]);
			for(var myIdx=1;myIdx<myary.length;myIdx++){
				xmlobj.BeginNode(myary[myIdx]);
				var cid = myary[myIdx];
				var _$id=$("#"+myary[myIdx]);
				if (_$id.length==0){
					//todo
				} else {
					if (_$id.hasClass("hisui-combobox")){
						var myval=_$id.combobox("getValue");
					} else if(_$id.hasClass("hisui-checkbox")){
						var myval="0";
						if (_$id.checkbox('getValue')) myval="1";
					} else if (_$id.hasClass("multiple")) {
						var myval = "";
						var size = $("#" + cid + " option").size();
						if (size > 0) {
							$.each($("#" + cid + " option:selected"), function(i,own){
								//console.log(own)	//<option value="1">西药片剂</option>
								var cvalue = $(own).val();	
								var ctext = $(own).text();
								
								if (myval == "") myval = cvalue
								else myval = myval + "," + cvalue
							})
							//DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+CatIDStr
						}	   
						
					} else if (_$id.hasClass("radiogroup")) {
						var myval = _$id.find("input[type='radio']:checked").val();
					} else if (_$id.hasClass("checkboxgroup")) {
						//var myval = _$id.find("input[type='checkbox']:checked").val();
						var myval = _$id.find("input[type='checkbox']:checked").map(function(index,elem) {
							return $(elem).val();
						}).get().join(',');
					} else {
						var myval=_$id.val();
					}
				}
				xmlobj.WriteString(myval);
				xmlobj.EndNode();
			}
			xmlobj.Close();
			myxmlstr = xmlobj.ToString();
		}catch(Err){
			$.messager.alert("提示","Error: " + Err.description);
		}	
		return myxmlstr;
	}
});
 