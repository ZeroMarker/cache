/**
 * dhcant.kss.main.js ����ҩ��������
 * 
 * Copyright (c) 2016-2017 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2016-07-24
 * 
 */
$(function(){
	//��ʼ�������ʾ״̬
	$.DHCAnt.initKSSConfig(KSSConfig);
	$.DHCAnt.doBaseInfo(KSSConfig);
	$.DHCAnt.initConfigLayout(KSSConfig);
	
	$.DHCAnt.drawMainInerface();
	$.DHCAnt.extendFunction();
	
	//������ȡ��
	$("#i-btn-submit").on('click', function(){
		//$(this).linkbutton("disable");
		
		var useaimMainObj={},applyMainObj={},consultMainObj={};
		useaimMainObj.SKSS3IND = KSSConfig.SKSS3IND;
		useaimMainObj.SUSEDRUGTIME = KSSConfig.SUSEDRUGTIME;
		useaimMainObj.SBJ = KSSConfig.SBJ;
		useaimMainObj.OrderPoisonCode = PARAMObj.OrderPoisonCode;
		useaimMainObj.needApply = 0;
		useaimMainObj.needConsult = 0;
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
		var resultStr = $.InvokeMethod("DHCAnt.KSS.MainBusiness","DBsave", saveType, newOrder, finallyUseAimInfo);
		var resultArr = resultStr.split("^");
		
		if (resultArr[0] == 1) {
			alert("����ɹ���");
			closeSubWin(1,resultArr[1],resultArr[2],useaimMainObj,applyMainObj);
		} else {
			alert("����ʧ�ܣ�");
		};
		return false;
	});
	
	$("#i-btn-cancel").on('click', function(){
		closeSubWin(0);
		return false;
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
	
});
 