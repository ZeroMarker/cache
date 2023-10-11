//页面Event
function InitEmrRepAdmWinEvent(obj){	
	
	 //屏幕宽高
    var Width  = window.screen.availWidth-20;
    var winHeight = window.screen.availHeight;
    if (winHeight>1000) {
	    var Height = winHeight-200;
    }else if (winHeight>800) {
	     var Height = winHeight-160;
    }else {
	     var Height = winHeight-120;
    }
	
	//弹出加载层
	function loadingWindow() {
		var left = ($(window).outerWidth(true) - 190) / 2; 
		var top = ($(window).height() - 35) / 2; 
		var height = $(window).height() * 2; 
 		$("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: height }).appendTo("#divMain"); 
 		$("<div class=\"datagrid-mask-msg\"></div>").html("正在加载,请稍候...").appendTo("#divMain").css({ display: "block", left: left, top: top }); 
	} 

	//取消加载层  
	function disLoadWindow() {
	    $(".datagrid-mask").remove();
	    $(".datagrid-mask-msg").remove();
	}

	obj.LoadEvent = function(){
		loadingWindow();
		window.setTimeout(function () { 
			obj.LoadReportData();
			disLoadWindow(); 
		}, 100); 
 	}
	
	//加载报告数据
	obj.LoadReportData = function() {
		if (IsExistReport==0) {    //不存在报告
			$("#divCenter").empty();//清空区域内容
			htmlStr='<div class="no-report" id ="no-report"></div>'
			$("#divCenter").append(htmlStr);
		} else{
			
			for (var indRepType = 0; indRepType < obj.RepTypeList.length; indRepType++) {
				var objRepType = obj.RepTypeList[indRepType];
				//传染病
				if ((objRepType.TypeCate == 'EPD')&&(objRepType.TypeCode == '2')) {
					obj.LoadEPDData();
					obj.LoadILIData();
					obj.LoadHIVData();
					obj.LoadRefData();
					obj.LoadNCPData();
				}
				//医院感染管理V4.0
				if ((objRepType.TypeCate == 'HAI')&&(objRepType.TypeCode == '1')) {
					obj.LoadHAIData();
					obj.LoadMBRData();
					obj.LoadOPSData();
				}
				//死亡证
				if ((objRepType.TypeCate == 'DTH')&&(objRepType.TypeCode == '2')) {
					 obj.LoadDTHData();
				}
				//食源性疾病
				if ((objRepType.TypeCate == 'FBD')&&(objRepType.TypeCode == '1')) {
					obj.LoadFBDData();
					obj.LoadSusAbData();	  //疑似食源性报卡
				}
				//严重精神疾患报告
				if (objRepType.TypeCate == 'SMD') {
					obj.LoadSMDData();
				}
				//慢病报告
				if (objRepType.TypeCate == 'CD') {
					obj.LoadCDData();
				}
				//加载特殊患者
				if (objRepType.TypeCate == 'SPE') {
					obj.LoadSPEData();
				}
				//加载罕见病
				if (objRepType.TypeCate == 'RDS') {
					obj.LoadRDSData();
				}
			}
		}
	}
	
	//传染病
   	obj.OpenEPDReport = function(atype,aRepID){
	    var t=new Date();
		t=t.getTime();
		var strUrl="";
		var width=1340;	
		var title="传染病报告"
		if(atype=="ili"){
			title="流感样病例登记"
			strUrl = "./dhcma.epd.reportili.csp?1=1" + "&PatientID=" + PatientID + "&EpisodeID=" + EpisodeID + "&ReportID=" + aRepID+ "&EmrOpen=1&t=" + t;
			
		}else if(atype=="referral"){
			var strInfo=$m({                
				ClassName:"DHCMed.EPD.ReferralRep",
				MethodName:"GetInfoByEPD",
				aEpisodeID:EpisodeID,
			},false);
			if(strInfo==""){
				$.messager.alert("错误",'请先填写"肺结核"传染病报告!');
				return
			}
			width=870;
			
			title="肺结核转诊单"
			strUrl = "./dhcma.epd.referral.csp?1=1" + "&PatientID=" + PatientID + "&EpisodeID=" + EpisodeID + "&ReportID=" + aRepID+ "&EmrOpen=1&t=" + t;	
		}else if(atype=="hiv"){
			var EPDRepInfo = $m({                  
				ClassName:"DHCMed.EPD.CaseFollow",
				MethodName:"GetEPDInfoByAdm",
				aEpisodeID:EpisodeID,
				aReportID:""
			},false);
			if (!EPDRepInfo){
				$.messager.alert("错误",'请先填写"HIV"传染病报告!');
				return
			}
			title="HIV个案随访登记表"
			strUrl = "./dhcma.epd.hivfollow.csp?1=1" + "&PatientID=" + PatientID + "&EpisodeID=" + EpisodeID + "&ReportID=" + aRepID+ "&EmrOpen=1&t=" + t;
		}else{
			strUrl = "./dhcma.epd.report.csp?1=1" + "&PatientID=" + PatientID + "&EpisodeID=" + EpisodeID + "&ReportID=" + aRepID+ "&EmrOpen=1&t=" + t;
		}
	    websys_showModal({
			url:strUrl,
			title:title,
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:(atype!="referral"?width:"880px"),    //限定肺结核转诊单的大小
			height:(atype!="referral"?Height:"430px")
		});
	}
	
	//NCP
    obj.OpenNCPReport = function(aRepID){
	    var t=new Date();
		t=t.getTime();
		
		var flg = $m({
			ClassName:"DHCMed.EPDService.NCPInvestigationSrv",
			MethodName:"GetEpdID",
			aEpisodeID:EpisodeID
		},false);
		
		if (!flg) {
			$.messager.alert("提示", "患者没有有效的新冠肺炎相关传染病报告，请先填写传染病报告!",'info');
			return;
        }
		
	    var strUrl = "./dhcma.epd.ncp.investigation.csp?1=1&EpisodeID="+EpisodeID+"&CTLocID="+session['LOGON.CTLOCID']+"&ReportID=" + aRepID+ "&EmrOpen=1&t=" + t;
	    websys_showModal({
			url:strUrl,
			title:'新冠肺炎个案调查',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1320,
			height:Height
		});
	}
	
		
	//医院感染管理V4.0
	obj.OpenHAIReport = function(aRepID){
		var t=new Date();
		t=t.getTime();
		var Type = 1;
		if (HAIEpisodeDr=="") {
			$.messager.alert("提示","该患者可能非办理入院登记的患者，请查证后再填报!", 'info');
			return false;
		} else {
			var IsActive  = $m({
				ClassName:"DHCHAI.DP.PAAdm",
				MethodName:"GetVisIsActive",
				aEpisodeID:HAIEpisodeDr
			},false);
			if (IsActive!="1") {
				$.messager.alert("提示","预住院、退院、未曾分配床位等患者不允许填报院感报告，请查证后再填报!", 'info');
				return false;
			}
		}
		var NewBabyFlg  = $m({
			ClassName:"DHCHAI.DP.PAAdm",
			MethodName:"GetNewBabyById",
			id:HAIEpisodeDr
		},false);
	
		if (NewBabyFlg=="1"){
			Type = 2;
		}		
		
		if (Type == '1') {
			var strTitle = '医院感染报告';
			var strUrl="dhcma.hai.ir.inf.report.csp?1=1&Paadm=" + EpisodeID + "&ReportID="+ aRepID+ "&EmrOpen=1&t=" + t;
		}else if(Type == '2') {
			var strTitle = '新生儿医院感染报告';
			var strUrl="dhcma.hai.ir.inf.nreport.csp?1=1&Paadm=" + EpisodeID + "&ReportID="+ aRepID+ "&EmrOpen=1&t=" + t;	   
		}	
		websys_showModal({
			url:strUrl,
			title:strTitle,
			iconCls:'icon-w-epr',  
	        originWindow:window,	        
			width:1320,
			height:Height
		});
	}
	
	//多重耐药菌调查（医院感染管理V4.0）
	obj.OpenMBRReport = function(aRepID,aLabRepID){
		var t=new Date();
		t=t.getTime();
		var Type = 1;
		if (HAIEpisodeDr=="") {
			$.messager.alert("提示","该患者可能非办理入院登记的患者，请查证后再填报!", 'info');
			return false;
		} else {
			var IsActive  = $m({
				ClassName:"DHCHAI.DP.PAAdm",
				MethodName:"GetVisIsActive",
				aEpisodeID:HAIEpisodeDr
			},false);
			if (IsActive!="1") {
				$.messager.alert("提示","预住院、退院、未曾分配床位等患者不允许填报院感报告，请查证后再填报!", 'info');
				return false;
			}
		}
	
		var strUrl="dhcma.hai.ir.mrb.ctlreport.csp?1=1&EpisodeID=" + HAIEpisodeDr + "&ReportID="+ aRepID + "&LabRepID="+ aLabRepID +"&EmrOpen=1&t=" + t;
		
		websys_showModal({
			url:strUrl,
			title:'多耐细菌报告',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1320,
			height:Height
		});
	}


	//手术切口调查（医院感染管理V4.0）
	obj.OpenOPSReport = function(aReportID,aOPSID,aOperAnaesID){
		var t=new Date();
		t=t.getTime();
		var Type = 1;
		if (HAIEpisodeDr=="") {
			$.messager.alert("提示","该患者可能非办理入院登记的患者，请查证后再填报!", 'info');
			return false;
		} else {
			var IsActive  = $m({
				ClassName:"DHCHAI.DP.PAAdm",
				MethodName:"GetVisIsActive",
				aEpisodeID:HAIEpisodeDr
			},false);
			if (IsActive!="1") {
				$.messager.alert("提示","预住院、退院、未曾分配床位等患者不允许填报院感报告，请查证后再填报!", 'info');
				return false;
			}
		}
	
		var url = "dhcma.hai.ir.opr.report.csp?Admin=0"+ '&OpsID=' + aOPSID+ '&ReportID=' + aReportID +'&OperAnaesID='+aOperAnaesID+ '&EpisodeID=' + HAIEpisodeDr +"&EmrOpen=1&t=" + t;
		websys_showModal({
            url: url,
            title: '手术切口调查表',
            iconCls: 'icon-w-epr',
			width:1320,
			height:Height
        });
	}
	
	//死亡证
    obj.OpenDTHReport = function(aRepID){
	    var t=new Date();
		t=t.getTime();
		if (aRepID == ''){
			var flg = $m({
				ClassName:"DHCMed.DTHService.ReportSrv",
				MethodName:"CheckDthRepByAdm",
				aEpisodeID:EpisodeID
			},false);
			if (flg*1==1){
				$.messager.alert("提示","当前患者居民死亡医学证明（推断）书已填报,不允许重复填报!", 'info');
				return;
			}
		}
	    var strUrl = "./dhcma.dth.report.csp?1=1&EpisodeID="+EpisodeID+"&CTLocID="+session['LOGON.CTLOCID']+"&ReportID=" + aRepID + "&EmrOpen=1&t=" + t;
	    websys_showModal({
			url:strUrl,
			title:'居民死亡医学证明（推断）书',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1320,
			height:Height
		});
	}
	
	//精神疾病
    obj.OpenSMDReport = function(aRepID,aTypeCode){
	    var t=new Date();
		t=t.getTime();
	    var strUrl = "./dhcma.smd.report.csp?1=1&ReportID=" + aRepID + "&LocFlag=0" +"&ReportType=" + aTypeCode+ "&EpisodeID=" + EpisodeID + "&EmrOpen=1&t=" + t;
	    websys_showModal({
			url:strUrl,
			title:'精神疾病报告',
			iconCls:'icon-w-epr',  
	        originWindow:window,	        
			width:1320,
			height:Height
		});
	}
	
	//食源性疾病
	obj.OpenFBDReport = function(aTypeCode,aRepID){
	    var t=new Date();
		t=t.getTime();
		if(aTypeCode== 'FBD'){
			var strTitle = '食源性疾病报卡';
			var strUrl = "./dhcma.fbd.report.csp?1=1" + "&PatientID=" + PatientID + "&EpisodeID=" + EpisodeID + "&ReportID=" + aRepID+ "&LocFlag=0"+ "&EmrOpen=1&t=" + t;
	    }else if(aTypeCode== 'SUS'){
			var strTitle = '疑似食源性疾病报卡';
			 var strUrl = "./dhcma.fbd.SusAbRep.csp?1=1" + "&PatientID=" + PatientID + "&EpisodeID=" + EpisodeID + "&ReportID=" + aRepID+ "&LocFlag=0"+ "&EmrOpen=1&t=" + t;
	    }
	    websys_showModal({
			url:strUrl,
			title:strTitle,
			iconCls:'icon-w-epr',  
	        originWindow:window,	        
			width:1320,
			height:Height
		});
	}

	//特殊患者
	obj.OpenEditSPE = function(aSpeID){
		var t=new Date();
		t=t.getTime();

		var strUrl = "./dhcma.spe.spemark.csp?1=1" + "&SpeID=" + aSpeID + "&EpisodeID=" + EpisodeID + "&OperTpCode=1&EmrOpen=1&t=" + t;
		    websys_showModal({
			url:strUrl,
			title:'标记特殊患者',
			iconCls:'icon-w-star', 
			width:400,
			height:505 
		});
	
	}
	//特殊患者消息列表	
	obj.OpenSpeNewsWin = function(aSpeID){
		var t=new Date();
		t=t.getTime();
		var strUrl = "./dhcma.spe.spenews.csp?1=1" + "&SpeID=" + aSpeID + "&OperTpCode=1&EmrOpen=1&t=" + t;					   
		websys_showModal({    //websys_showModal支持多层弹出后修改为该方法
			url:strUrl,
			title:'消息列表',
			iconCls:'icon-w-msg',  
			width:850,
			height:400
		});
	}
	
	
	//慢病
    obj.OpenCDReport = function(aTypeCode,aRepID){
	    var t=new Date();
		t=t.getTime();
		if(aTypeCode== 'ZLK'){
			var strTitle = '肿瘤报告卡';
			var strUrl= "./dhcma.cd.reportzlk.csp?1=1&ReportID=" + aRepID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&EmrOpen=1&t=" + t;	
		}else if(aTypeCode== 'XNXG'){
			var strTitle = '心脑血管事件报告卡';
			var strUrl= "./dhcma.cd.reportxnxg.csp?1=1&ReportID=" + aRepID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&EmrOpen=1&t=" + t;
		}else if(aTypeCode== 'SHK'){
			var strTitle = '意外伤害监测报告卡';
			var strUrl= "./dhcma.cd.reportshk.csp?1=1&ReportID=" + aRepID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&EmrOpen=1&t=" + t;
		}else if(aTypeCode== 'NYZD'){
			var strTitle = '农药中毒报告卡';
			var strUrl= "./dhcma.cd.reportnyzd.csp?1=1&ReportID=" + aRepID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&EmrOpen=1&t=" + t;
		}else if(aTypeCode== 'GWZS'){
			var strTitle = '高温中暑报告卡';
			var strUrl= "./dhcma.cd.reportgwzs.csp?1=1&ReportID=" + aRepID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&EmrOpen=1&t=" + t;
		}else if(aTypeCode== 'TNB'){
			var strTitle = '糖尿病报告卡';
			var strUrl= "./dhcma.cd.reporttnb.csp?1=1&ReportID=" + aRepID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&EmrOpen=1&t=" + t;
		}else if(aTypeCode== 'YSZYB'){
			var strTitle = '疑似职业病报告卡';
			var strUrl= "./dhcma.cd.reportyszyb.csp?1=1&ReportID=" + aRepID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&EmrOpen=1&t=" + t;
		}else if(aTypeCode== 'FZYCO'){
			var strTitle = '非职业CO中毒报告卡';
			var strUrl= "./dhcma.cd.reportfzyco.csp?1=1&ReportID=" + aRepID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&EmrOpen=1&t=" + t;
		}else if(aTypeCode== 'MBBK'){
			var strTitle = '慢性病报病卡';
			var strUrl= "./dhcma.cd.reportmbbk.csp?1=1&ReportID=" + aRepID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&EmrOpen=1&t=" + t;
		}else if(aTypeCode== 'CSQX'){
			var strTitle = '出生缺陷儿报告卡';
			var strUrl= "./dhcma.cd.reportcsqx.csp?1=1&ReportID=" + aRepID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&EmrOpen=1&t="  + t;
		}
	    websys_showModal({
			url:strUrl,
			title:strTitle,
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1320,
			height:Height
		});
	}
	
	//罕见病登记
	obj.OpenRDSReport = function(aReportID){
		var strUrl = "./dhcma.rd.report.csp?1=1&PatientID="+ PatientID + "&EpisodeID="+ EpisodeID +"&ReportID="+ aReportID+"&EmrOpen=1";
		websys_showModal({
			url:strUrl,
			title:'罕见病登记报告',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1320,
			height:Height
		});
	}
	// 罕见病登记-随访报卡
	obj.OpenRDSFollowReport = function(aReportID){
		var strUrl = "./dhcma.rd.followreport.csp?1=1&PatientID="+ PatientID + "&EpisodeID="+ EpisodeID +"&ReportID="+ aReportID + "&aFrom=PH"+"&EmrOpen=1";
		websys_showModal({
			url		: strUrl,
			title	: '罕见病随访报告',
			iconCls	: 'icon-w-epr',  
			width	: 1320,
			height	: Height
			
		});
	}
	
	//慢阻肺上报
	obj.OpenCOPReport = function(aReportID) {
		var strUrl = "./dhcma.cop.ir.report.csp?1=1&EpisodeID="+ EpisodeID +"&ReportID="+ aReportID+"&EmrOpen=1";
		websys_showModal({
			url		: strUrl,
			title	: '慢阻肺报告',
			iconCls	: 'icon-w-epr',  
			width	: 1320,
			height	: Height
		});
	}
}