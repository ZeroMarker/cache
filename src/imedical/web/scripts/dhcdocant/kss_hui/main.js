/**
 * main.js ����ҩ��������
 * 
 * Copyright (c) 2016-2020 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2016-07-24
 * 
 */
 if (websys_isIE==true) {
     var script = document.createElement('script');
     script.type = 'text/javaScript';
     script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird �ļ���ַ
     document.getElementsByTagName('head')[0].appendChild(script);
}
$(function(){
	//��ʼ�������ʾ״̬
	$.DHCAnt.initKSSConfig(KSSConfig);
	$.DHCAnt.doBaseInfo(KSSConfig);
	$.DHCAnt.initConfigLayout(KSSConfig);
	
	$.DHCAnt.drawMainInerface();
	$.DHCAnt.extendFunction();
	$.DHCAnt.doUI();
	
	function downShadow() {
		//��ȡ#middle��λ��
		var startPos = $("#main").offset().top;
		$.event.add(window, "scroll", function () {
			var p = $(window).scrollTop();
			$("#top").css('box-shadow', ((p) > startPos) ? '0 0 5px #888' : '0 0 0 #888');
		});
	}
	downShadow();
	//������ȡ��
	$("#i-btn-submit").on('click', function(){
		//$(this).linkbutton("disable");
		
		//��������
		var useaimMainObj={},applyMainObj={},consultMainObj={};
		useaimMainObj.SKSS3IND = KSSConfig.SKSS3IND;
		useaimMainObj.SUSEDRUGTIME = KSSConfig.SUSEDRUGTIME;
		useaimMainObj.SBJ = KSSConfig.SBJ;
		useaimMainObj.OrderPoisonCode = PARAMObj.OrderPoisonCode;
		useaimMainObj.needApply = 0;
		useaimMainObj.needConsult = 0;

		//��չ����: 2019-01-28
		var extendOBJ = {
			blContent:""	//������Ҫ
		};
		
		//���ػ���Ŀ��Ϣ
		var ModePrjInfo = "";
		if (KSSConfig.LOCALMODEL == 2) {
			ModePrjInfo = GetModePrjInfo();
		}
		
		//��ȡ��Ϣ
		$.DHCAnt.getUseAim(useaimMainObj);			//��ȡʹ��Ŀ��
		$.DHCAnt.getZBacterium(useaimMainObj);		//��ȡ��ԭѧ���
		if (KSSConfig.SUSEDRUGTIME) {			
			$.DHCAnt.getDrugTime(useaimMainObj); 	//��ȡ��ҩʱ�����
		};
		if(!$.DHCAnt.validateUseAim(useaimMainObj)) return false;	//��֤
		
		//��һ����������û�л�ȡ
		if (PARAMObj.ShowTabStr.indexOf("Apply") >= 0) {
			useaimMainObj.needApply = 1;
			$.DHCAnt.getApplyInfo(applyMainObj);	//��ȡ������Ϣ
			if(!$.DHCAnt.validateApplyInfo(applyMainObj)) return false;			//��֤Խ���Ƿ���дԭ��
		};
		
		//��ȡ������Ϣ
		if (PARAMObj.ShowTabStr.indexOf("Consult") >= 0) {
			useaimMainObj.needConsult = 1;
			if ((!KSSConfig.DEFAULTCONDEP)||(!KSSConfig.DEFAULTCONDOC)) {
				consultMainObj.DEFAULTCONDEP = 0;
				consultMainObj.DEFAULTCONDOC = "";
				if (!KSSConfig.CONDEPNUM) {
					consultMainObj.CONDEPNUM  = 1;
				} else {
					consultMainObj.CONDEPNUM = KSSConfig.CONDEPNUM;	//������Ҹ���
				}
				$.DHCAnt.getConsultInfo(consultMainObj);
				if(!$.DHCAnt.validateConsultInfo(consultMainObj)) return false;	//��֤�Ƿ���д������Һ�ҽ��
			} else {
				consultMainObj.DEFAULTCONDEP = KSSConfig.DEFAULTCONDEP;
				consultMainObj.DEFAULTCONDOC = KSSConfig.DEFAULTCONDOC;
			}
		};
		
		//���������
		//������Ϣ��admId^ssid^arcim^ʹ��Ŀ��^��ҩָ��^��Ⱦ��λ^��ҩʱ��^�Ƿ��ͼ�^ҩ����¼^������¼
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
		
		//�ؿ�ҩָ��
		if (($.trim(useaimMainObj.SKSS3IND) == "1") && (PARAMObj.OrderPoisonCode == "KSS3")) {
			dataOrder.push("Kss3Indication");
			kss3IndicationInfo = useaimMainObj.kss3Indication;
			finallyUseAimArray["Kss3Indication"] = kss3IndicationInfo;
		};
		
		//�²���
		if ($.trim(useaimMainObj.SBJ) == "1") {
			dataOrder.push("Zbj");
			zbjInfo = useaimMainObj.zBj;
			finallyUseAimArray["Zbj"] = zbjInfo;
		};
		
		//��ҩʱ�����
		if ($.trim(useaimMainObj.SUSEDRUGTIME) == "1") {
			dataOrder.push("UsedrugTime");
			usedrugTimeInfo = useaimMainObj.pretime + sperator + useaimMainObj.extensionreason;
			finallyUseAimArray["UsedrugTime"] = usedrugTimeInfo;
		}
		
		//����
		//��ȡ������Ϣ: 
		if ($.trim(useaimMainObj.needApply) == "1") {
			dataOrder.push("Apply");
			saveType = "apply";
			if (!applyMainObj.emreason) {	//����undefined
				applyMainObj.emreason = "";
			};
			applyInfo = applyMainObj.isEm + sperator + applyMainObj.emreason + sperator + session['LOGON.CTLOCID'] + sperator + KSSConfig.processType + sperator + KSSConfig.processInfo + sperator + KSSConfig.lastAuditUser ;
			finallyUseAimArray["Apply"] = applyInfo;
		};
		
		//������Ϣ
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
		//ʵ�ֶ�̬����ƴ��
		for (var k = 0; k < dataOrder.length; k++ ) {
			if (!finallyUseAimInfo) {
				finallyUseAimInfo = finallyUseAimArray[dataOrder[k]];
			} else {
				finallyUseAimInfo = finallyUseAimInfo + "!" + finallyUseAimArray[dataOrder[k]];
			};
		};
		*/
		
		//��̬����ƴ��
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
			//alert("����ɹ���");
			$.messager.alert('��ʾ','����ɹ���','info',function () {
				closeSubWin(1,resultArr[1],resultArr[2],useaimMainObj,applyMainObj);
			});
		} else {
			alert("����ʧ�ܣ�");
			$.messager.alert('��ʾ','����ʧ�ܣ�','info');
		};
		return false;
	});
	
	$("#i-btn-cancel").on('click', function(){
		closeSubWin(0);
		return false;
	});
	
	//����
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
			title:'��������',
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
								//console.log(own)	//<option value="1">��ҩƬ��</option>
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
			$.messager.alert("��ʾ","Error: " + Err.description);
		}	
		return myxmlstr;
	}
});
 