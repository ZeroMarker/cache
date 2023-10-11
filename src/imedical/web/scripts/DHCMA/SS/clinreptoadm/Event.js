//页面Event
function InitClinRepToAdmWinEvent(obj){	
    //屏幕宽高
    var Width  = window.screen.availWidth-20;
    var winHeight = window.screen.availHeight;
    if (winHeight>1000) {
	    var Height = winHeight-200;
    }else if (winHeight>800) {
	     var Height = winHeight-160;
    }else {
	     var Height = winHeight-80;
    }
    var strSSTitle =$g('手术切口调查表');
    var strDNBGTitle =$g('多耐细菌报告');
	var strCD9Title = $g("新冠病毒感染个案调查");
	var strESurTitle = $g("流行病学调查表");
	var SusRepTitle =  $g('疑似食源性疾病报卡');
	var HCVRefTitle=$g("丙肝转介通知单");
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


    //var Height = window.screen.availHeight-80;
	obj.LoadEvent = function(){
	  	loadingWindow();
		window.setTimeout(function () { 
			obj.LoadReportData();
			disLoadWindow(); 
		}, 100); 

		$('#btnRepEPD_ili').on('click', function(){
			obj.OpenEPDReport('ili','');
     	});
		$('#btnRepEPD_referral').on('click', function(){
			obj.OpenEPDReport('referral','');
     	});
     	$('#btnRepEPD_hiv').on('click', function(){
			obj.OpenEPDReport('hiv','');
     	});
		$('#btnRepEPD_epd').on('click', function(){
			obj.OpenEPDReport('epd','');
     	});
		$('#btnRepEPD_hcvref').on('click', function(){
			obj.OpenEPDReport('hcvreferral','');
     	});
     	$('#btnRepEPD_esur').on('click', function(){
	     	obj.OpenESurRep('');
     	});
     	//新增丙肝个案调查表
     	$('#btnRepEPD_hcv').on('click', function(){
	     	obj.OpenHcvRep('');
     	});
        $('#btnRepEPD_ncp').on('click', function(){
	     	obj.OpenNCPReport('');
     	});
     	$('#btnRepHAIO').on('click', function(){
	     	obj.OpenHAIReport('');
     	});
     	$('#btnRepHAI').on('click', function(){
	     	obj.OpenHAIReport('');
     	});
     	$('#btnScreen').on('click', function(){
	     	obj.PatScreenInfo(HAIEpisodeDr);
     	});
		
		$('#btnMBRRep').on('click', function(){   //多重耐药细菌调查报告
	     	obj.OpenMBRReport('');
     	});
     	
     	$('#btnOPSRep').on('click', function(){   //手术切口调查报告
	     	obj.OpenOPSReport('','','');
     	});
     	$('#btnRepDTH').on('click', function(){
	     	obj.OpenDTHReport('');
     	});
     	$('#btnRepFBD_1').on('click', function(){
	     	obj.OpenFBDReport('FBD','');
     	});
     	$('#btnRepFBD_2').on('click', function(){
	     	obj.OpenFBDReport('SUS','');
     	});
     	 
     
     	
     	$('#btnRepCD_ZLK').on('click', function(){
	     	obj.OpenCDReport('ZLK','');
     	});
     	$('#btnRepCD_XNXG').on('click', function(){
	     	obj.OpenCDReport('XNXG','');
     	});
     	$('#btnRepCD_GWZS').on('click', function(){
	     	obj.OpenCDReport('GWZS','');
     	});
     	$('#btnRepCD_SHK').on('click', function(){
	     	obj.OpenCDReport('SHK','');
     	});
     	$('#btnRepCD_NYZD').on('click', function(){
	     	obj.OpenCDReport('NYZD','');
     	});
     	$('#btnRepCD_TNB').on('click', function(){
	     	obj.OpenCDReport('TNB','');
     	});
     	$('#btnRepCD_YSZYB').on('click', function(){
	     	obj.OpenCDReport('YSZYB','');
     	});
     	$('#btnRepCD_FZYCO').on('click', function(){
	     	obj.OpenCDReport('FZYCO','');
     	});
     	$('#btnRepCD_MBBK').on('click', function(){
	     	obj.OpenCDReport('MBBK','');
     	});
     	$('#btnRepCD_CSQX').on('click', function(){
	     	obj.OpenCDReport('CSQX','');
     	});
		$('#btnRepCD_ETSH').on('click', function(){
	     	obj.OpenCDReport('ETSH','');
     	});
		$('#btnRepCD_GXY').on('click', function(){
	     	obj.OpenCDReport('GXY','');
     	});
     	$('#btnRepSMD_O').on('click', function(){
	     	obj.OpenSMDReport('',1);
     	});
     	$('#btnRepSMD_I').on('click', function(){
	     	obj.OpenSMDReport('',3);
     	});
        $('#btnRepSMD_Disch').on('click', function(){
	     	obj.OpenSMDReport('',4);
     	});
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
					obj.LoadHCVData();
					obj.LoadHCVRefData();
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
				
				//加载罕见病
				if (objRepType.TypeCate == 'RDS') {
					obj.LoadRDSData();
				}
			}
		}
	}
	
	//传染病
    /*obj.OpenEPDReport = function(aRepID){
	    var t=new Date();
		t=t.getTime();

	    var strUrl = "./dhcma.epd.report.csp?1=1" + "&PatientID=" + PatientID + "&EpisodeID=" + EpisodeID + "&ReportID=" + aRepID+ "&t=" + t;
	    websys_showModal({
			url:strUrl,
			title:'传染病报告',
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:false,
			width:1340,
			height:Height,
			dataRow:{RowID:aRepID},  
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
		});
	}*/
	obj.OpenEPDReport = function(atype,aRepID){
	    var t=new Date();
		t=t.getTime();
		var strUrl="";
		var width=1340;	
		var title=$g("传染病报告");
		if(atype=="ili"){
			title=$g("流感样病例登记");
			strUrl = "./dhcma.epd.reportili.csp?1=1" + "&PatientID=" + PatientID + "&EpisodeID=" + EpisodeID + "&ReportID=" + aRepID+ "&t=" + t;
			
		}else if(atype=="referral"){
			var strInfo=$m({                
				ClassName:"DHCMed.EPD.ReferralRep",
				MethodName:"GetInfoByEPD",
				aEpisodeID:EpisodeID,
			},false);
			if(strInfo==""){
				$.messager.alert("错误",'请先填写"肺结核"传染病报告!','info');
				return
			}
			title=$g("肺结核转诊单");
			strUrl = "./dhcma.epd.referral.csp?1=1" + "&PatientID=" + PatientID + "&EpisodeID=" + EpisodeID + "&ReportID=" + aRepID+ "&t=" + t;	
		}else if(atype=="hiv"){
			var EPDRepInfo = $m({                  
				ClassName:"DHCMed.EPD.CaseFollow",
				MethodName:"GetEPDInfoByAdm",
				aEpisodeID:EpisodeID,
				aReportID:""
			},false);
			if (!EPDRepInfo){
				$.messager.alert("错误",'请先填写"HIV"传染病报告!','info');
				return
			}
			title=$g("HIV个案随访登记表");
			strUrl = "./dhcma.epd.hivfollow.csp?1=1" + "&PatientID=" + PatientID + "&EpisodeID=" + EpisodeID + "&ReportID=" + aRepID+ "&t=" + t;	
		}else if(atype=="hcvreferral"){
			var HCVRefRepInfo = $m({                  
				ClassName:"DHCMed.EPD.HCVReferral",
				MethodName:"GetInfoByEPD",
				aEpisodeID:EpisodeID
			},false);
			if (!HCVRefRepInfo){
				$.messager.alert("错误",'请先填写"丙型病毒性肝炎"传染病报告!','info');
				return
			}
			Height = "480px;"
			title=HCVRefTitle;
			strUrl = "./dhcma.epd.hcvreferral.csp?1=1" + "&PatientID=" + PatientID + "&EpisodeID=" + EpisodeID + "&ReportID=" + aRepID+ "&LocFlag=" + 0;	
		}else{
			Height = "624px"
			strUrl = "./dhcma.epd.report.csp?1=1" + "&PatientID=" + PatientID + "&EpisodeID=" + EpisodeID + "&ReportID=" + aRepID+ "&t=" + t;
		}
	    websys_showModal({
			url:strUrl,
			title:title,
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:false,
			width:(atype!="referral"?width:"880px"),    //限定肺结核转诊单的大小
			height:(atype!="referral"?Height:"464px"),
			dataRow:{RowID:aRepID},  
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
		});
	}
	/* 流行病学调查表 */
	obj.OpenESurRep = function(aRepID){
		var t=new Date();
		t=t.getTime();
		var strUrl = "./dhcma.epd.esurreg.csp?1=1" + "&PatientID=" + PatientID + "&EpisodeID=" + EpisodeID + "&ReportID=" + aRepID+ "&LocFlag=0"+ "&t=" + t;
	    websys_showModal({
			url:strUrl,
			title:strESurTitle,
			iconCls:'icon-w-epr',
			closable:true,  
			width:1360,
			height:Height,
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
		});
	}
	/* 新诊断报告丙肝病例个案调查表 */
	obj.OpenHcvRep = function(aRepID){
		var t=new Date();
		t=t.getTime();
		var repTitle = $g("新诊断报告丙肝病例个案调查表");
		var strUrl = "./dhcma.epd.hcvreg.csp?1=1" + "&PatientID=" + PatientID + "&EpisodeID=" + EpisodeID + "&ReportID=" + aRepID+ "&LocFlag=0"+ "&t=" + t;
	    websys_showModal({
			url:strUrl,
			title:repTitle,
			iconCls:'icon-w-epr',
			closable:true,  
			width:1360,
			height:Height,
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
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
			$.messager.alert($g("提示"), $g("患者没有有效的新冠病毒感染相关传染病报告，请先填写传染病报告!"),'info');
			return;
        }
	    var strUrl = "./dhcma.epd.ncp.investigation.csp?1=1&EpisodeID="+EpisodeID+"&CTLocID="+session['LOGON.CTLOCID']+"&ReportID=" + aRepID + "&t=" + t;
	    websys_showModal({
			url:strUrl,
			title:strCD9Title,
			iconCls:'icon-w-epr',
			closable:false,  
			width:1320,
			height:Height,
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
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
		
		var strTitle = $g('医院感染报告');
		var strUrl="dhcma.hai.ir.inf.report.csp?1=1&Paadm=" + EpisodeID + "&ReportID="+ aRepID +"&t=" + t;
		
		websys_showModal({
			url:strUrl,
			title:strTitle,
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:false,
			width:1320,
			height:Height,
			dataRow:{ReportID:aRepID},  
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
		});
	}
	
	
	//疑似病例筛查（医院感染管理V4.0）
	obj.PatScreenInfo = function(aHAIEpisodeDr) {
		var t=new Date();
		t=t.getTime();
		var strTitle=$g('疑似病例筛查');
		var strUrl = "./dhcma.hai.ir.patscreening.csp?1=1&EpisodeDr=" + aHAIEpisodeDr+"&Paadm=" + EpisodeID+"&LocFlag=1&t=" + t;	
		websys_showModal({
			url:strUrl,
			title:strTitle,
			iconCls:'icon-w-paper',  
	        originWindow:window,
			width:'95%',
			height:'95%',
			onBeforeClose:function(){}  //若无词句,IE下打开一份报告关闭后，摘要无法关闭
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
	
		var strUrl="dhcma.hai.ir.mrb.ctlreport.csp?1=1&EpisodeID=" + HAIEpisodeDr + "&ReportID="+ aRepID + "&LabRepID="+ aLabRepID +"&t=" + t;
		strDNBGTitle =$g('多耐细菌报告');
		websys_showModal({
			url:strUrl,
			title:strDNBGTitle,
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:false,
			width:1320,
			height:Height,
			dataRow:{ReportID:aRepID},  
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
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
		strSSTitle =$g('手术切口调查表');
		var url = "dhcma.hai.ir.opr.report.csp?Admin=0"+ '&OpsID=' + aOPSID+ '&ReportID=' + aReportID +'&OperAnaesID='+aOperAnaesID+ '&EpisodeID=' + HAIEpisodeDr+ "&5=5";
		websys_showModal({
            url: url,
            title: strSSTitle,
            iconCls: 'icon-w-epr',
            closable: false,
            width: 1320,
            height: '95%',
            onBeforeClose: function () {
                window.location.reload();  //刷新当前界面
            }
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
	    var strUrl = "./dhcma.dth.report.csp?1=1&EpisodeID="+EpisodeID+"&CTLocID="+session['LOGON.CTLOCID']+"&ReportID=" + aRepID + "&t=" + t;;
	    websys_showModal({
			url:strUrl,
			title:$g("居民死亡医学证明（推断）书"),
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:false,
			width:1320,
			height:Height,
			dataRow:{RowID:aRepID},  
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
		});
	}
	
	//精神疾病
    obj.OpenSMDReport = function(aRepID,aTypeCode){
	    var t=new Date();
		t=t.getTime();
	    var strUrl = "./dhcma.smd.report.csp?1=1&ReportID=" + aRepID + "&LocFlag=0" +"&ReportType=" + aTypeCode+ "&EpisodeID=" + EpisodeID + "&t=" + t;
	    websys_showModal({
			url:strUrl,
			title:'精神疾病报告',
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:false,
			width:1320,
			height:Height,
			dataRow:{RowID:aRepID},  
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
		});
	}
	
	//食源性疾病
	obj.OpenFBDReport = function(aTypeCode,aRepID){
	    var t=new Date();
		t=t.getTime();
		if(aTypeCode== 'FBD'){
			var strTitle = $g('食源性疾病报卡');
			var strUrl = "./dhcma.fbd.report.csp?1=1" + "&PatientID=" + PatientID + "&EpisodeID=" + EpisodeID + "&ReportID=" + aRepID+ "&LocFlag=0" + "&t=" + t;
	    }else if(aTypeCode== 'SUS'){
			var strTitle = SusRepTitle;
			 var strUrl = "./dhcma.fbd.SusAbRep.csp?1=1" + "&PatientID=" + PatientID + "&EpisodeID=" + EpisodeID + "&ReportID=" + aRepID+ "&LocFlag=0" + "&t=" + t;
	    }
	    websys_showModal({
			url:strUrl,
			title:strTitle,
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:false,
			width:1320,
			height:Height,
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
		});
	}


	
	//慢病
    obj.OpenCDReport = function(aTypeCode,aRepID){
	    var t=new Date();
		t=t.getTime();
		var ZLReportTitle =$g('肿瘤报告卡');
		var XNXGReportTitle =$g('心脑血管事件报告卡');
		var SHKReportTitle =$g('意外伤害监测报告卡');
		var NYZDReportTitle =$g('农药中毒报告卡');
		var GWZSReportTitle =$g('高温中暑报告卡');
		var TNBReportTitle =$g('糖尿病报告卡');
		var YSZYBReportTitle =$g('疑似职业病报告卡');
		var FZYCOReportTitle =$g('非职业CO中毒报告卡');
		var MBBKReportTitle =$g('慢性病报告卡');
		var CSQXReportTitle =$g('出生缺陷儿报告卡');
		var ETSHReportTitle =$g('儿童伤害监测报告卡');
		var GXYReportTitle =$g('高血压报告卡');
		if(aTypeCode== 'ZLK'){
			var strTitle = ZLReportTitle;
			var strUrl= "./dhcma.cd.reportzlk.csp?1=1&ReportID=" + aRepID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&t=" + t;		
		}else if(aTypeCode== 'XNXG'){
			var strTitle = XNXGReportTitle;
			var strUrl= "./dhcma.cd.reportxnxg.csp?1=1&ReportID=" + aRepID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&t=" + t;
		}else if(aTypeCode== 'SHK'){
			var strTitle = SHKReportTitle;
			var strUrl= "./dhcma.cd.reportshk.csp?1=1&ReportID=" + aRepID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&t=" + t;
		}else if(aTypeCode== 'NYZD'){
			var strTitle = NYZDReportTitle;
			var strUrl= "./dhcma.cd.reportnyzd.csp?1=1&ReportID=" + aRepID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&t=" + t;
		}else if(aTypeCode== 'GWZS'){
			var strTitle = GWZSReportTitle;
			var strUrl= "./dhcma.cd.reportgwzs.csp?1=1&ReportID=" + aRepID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&t=" + t;
		}else if(aTypeCode== 'TNB'){
			var strTitle = TNBReportTitle;
			var strUrl= "./dhcma.cd.reporttnb.csp?1=1&ReportID=" + aRepID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&t=" + t;
		}else if(aTypeCode== 'YSZYB'){
			var strTitle = YSZYBReportTitle;
			var strUrl= "./dhcma.cd.reportyszyb.csp?1=1&ReportID=" + aRepID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&t=" + t;
		}else if(aTypeCode== 'FZYCO'){
			var strTitle = FZYCOReportTitle;
			var strUrl= "./dhcma.cd.reportfzyco.csp?1=1&ReportID=" + aRepID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&t=" + t;
		}else if(aTypeCode== 'MBBK'){
			var strTitle = MBBKReportTitle;
			var strUrl= "./dhcma.cd.reportmbbk.csp?1=1&ReportID=" + aRepID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&t=" + t;
		}else if(aTypeCode== 'CSQX'){
			var strTitle = CSQXReportTitle;
			var strUrl= "./dhcma.cd.reportcsqx.csp?1=1&ReportID=" + aRepID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&t=" + t;
		}else if(aTypeCode== 'ETSH'){
			var strTitle = ETSHReportTitle ;
			var strUrl= "./dhcma.cd.reportetsh.csp?1=1&ReportID=" + aRepID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&t=" + t;
		}else if(aTypeCode== 'GXY'){
			var strTitle = GXYReportTitle;
			var Height	 = "670px";
			var strUrl= "./dhcma.cd.reportgxy.csp?1=1&ReportID=" + aRepID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&t=" + t;
		}
		var Width  = window.screen.availWidth-20;
		var winHeight = window.screen.availHeight;
		if (winHeight>1000) {
			var Height = winHeight-200;
		}else if (winHeight>800) {
			 var Height = winHeight-160;
		}else {
			 var Height = winHeight-80;
		}
	    websys_showModal({
			url:strUrl,
			title:strTitle,
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:false,
			width:1320,
			height:Height,
			dataRow:{ReportID:aRepID},  
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
		});
	}
}