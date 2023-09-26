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

//传染病提示/强制报卡接口方法
function CheckDisease(MRDiagnosRowid){
	var obj=document.getElementById('EpisodeID');
	if (obj){var EpisodeID=obj.value};
	var obj=document.getElementById('PatientID');
	if (obj){var PatientID=obj.value};
	if (EpisodeID=='') return;
	CheckDiseaseNew(MRDiagnosRowid,EpisodeID,PatientID)
	
}

function CheckDiseaseNew(MRDiagnosRowid,EpisodeID,PatientID)
{
	//如果是8.2以下版本，可能用此写法
	var icdInfo=tkMakeServerCall("DHCMed.EPDService.Service","CheckDiagnosToEpd",EpisodeID,MRDiagnosRowid);

	if (icdInfo){
		var tmpList=icdInfo.split("^");
		if (tmpList.length>=1){
			if (tmpList[0]=='0'){
				//提示报卡
				$.messager.confirm("提示",tmpList[2], function (r) {
				if (r){
						var strUrl = "./dhcma.epd.report.csp?" + 
						"PatientID=" + PatientID +
						"&EpisodeID=" + EpisodeID +
						"&IFRowID=" + tmpList[1] +
						"&DiagnosID=" + MRDiagnosRowid +
						"&LocFlag=0" ;
						websys_showModal({
							url:strUrl,
							title:'传染病报告',
							iconCls:'icon-w-epr',  
					        originWindow:window,
					        closable:false,
							width:1340, 
							height:Height
						}); 
					}
				});
			}else if (tmpList[0]=='1'){
				//强制报卡
				$.messager.alert("提示", tmpList[2], 'info',function() {
					var strUrl = "./dhcma.epd.report.csp?" + 
						"PatientID=" + PatientID +
						"&EpisodeID=" + EpisodeID +
						"&IFRowID=" + tmpList[1] +
						"&LocFlag=0";
					websys_showModal({
						url:strUrl,
						modal:true,
						title:'传染病报告',
						iconCls:'icon-w-epr', 
						closable:false,						
						width:1340,
						height:Height, 
						onBeforeClose:function(){
							var RepFlag = top.$('#flag').val();		
							//传染病保存失败,删除传染病
							if (RepFlag !=1 ) {
								DeleteMRDiagnos(MRDiagnosRowid);
							}
						} 
					}); 
				});
			    
			}else if (tmpList[0]=='2'){
				//提示报卡
				$.messager.alert("提示", tmpList[2], 'info');
				return;
			}
		}
	}
}
//临床路径4.0准入提示接口方法
function ShowCPW(EpisodeID,PAAdmType)
{
	if (EpisodeID==''||PAAdmType=='') return;
	if (PAAdmType=="O") {
		ShowOPCPW(EpisodeID);
	}else{	
		ShowIPCPW(EpisodeID);
	}
}
//临床路径4.0住院路径
function ShowIPCPW(EpisodeID) 
{
	if (EpisodeID=='') return;
	$m({
		ClassName:"DHCMA.CPW.CPS.InterfaceSrv",
		MethodName:"GetCPWList",
		aEpisodeID:EpisodeID
	},function(CPWStr){
		if(CPWStr=="") return;
		var strUrl = "./dhcma.cpw.io.show.csp?1=1" + "&EpisodeID=" + EpisodeID + "&CPWStr=" + CPWStr;
		 websys_showModal({
			url:strUrl,
			title:'临床路径入径提示',
			iconCls:'icon-w-import',  
			closable:false,
			//onBeforeClose:function(){alert('close')},
			//dataRow:{EpisodeID:EpisodeID},   //？
			originWindow:window,
			width:900,
			height:500
		});
	})
}

//临床路径4.0门诊准入提示接口方法
function ShowOPCPW(EpisodeID)
{
	if (EpisodeID=='') return;
	$m({
		ClassName:"DHCMA.CPW.OPCPS.InterfaceSrv",
		MethodName:"GetOPCPWList",
		aEpisodeID:EpisodeID,
		aType:1
	},function(OPCPWStr){
		if(OPCPWStr=="") return;
		var strUrl = "./dhcma.cpw.io.opshow.csp?1=1" + "&EpisodeID=" + EpisodeID + "&OPCPWStr=" + OPCPWStr;
		 websys_showModal({
			url:strUrl,
			title:'临床路径入径提示',
			iconCls:'icon-w-import',  
			closable:false,
			//onBeforeClose:function(){alert('close')},
			//dataRow:{EpisodeID:EpisodeID},   //？
			originWindow:window,
			width:900,
			height:500
		});
	})
}
/*
//临床路径4.0准入提示接口方法
function ShowCPW(MRCICDRowid,MRDiagnosRowid)
{
	var obj=document.getElementById('EpisodeID');
	if (obj){var EpisodeID=obj.value}
	if (EpisodeID=='') return;
	
	$m({
		ClassName:"DHCMA.CPW.CPS.InterfaceSrv",
		MethodName:"GetCPWList",
		aEpisodeID:EpisodeID
	},function(CPWStr){
		if(CPWStr=="") return;
		var strUrl = "./dhcma.cpw.io.show.csp?1=1" + "&EpisodeID=" + EpisodeID + "&CPWStr=" + CPWStr;
		 websys_showModal({
			url:strUrl,
			title:'临床路径入径提示',
			iconCls:'icon-w-import',  
			closable:false,
			//onBeforeClose:function(){alert('close')},
			//dataRow:{EpisodeID:EpisodeID},   //？
			originWindow:window,
			width:670,
			height:420
		});
	})
}
*/
////精神疾病准入提示接口方法
//在诊断录入界面增加此方法,在下诊断时调用
//此方法只处理最新一条诊断,判断是否是严重精神疾病
function CheckSMDReport(MRDiagnosRowid)
{
	var strEpisodeID = document.getElementById("EpisodeID").value;
	var strPatientID = document.getElementById("PatientID").value;
	//如果是8.2以下版本，可能用此写法
	var CDInfo=tkMakeServerCall("DHCMed.SMDService.Service","IsDiagnoseNeedReport",strEpisodeID,"");

	if(CDInfo){
		var CDInfo=CDInfo.split("^");
		if(CDInfo.length>=1){
			if(CDInfo[0]=='0') {
				$.messager.confirm("提示", CDInfo[2],function (r) {
					if (r){
						var strURL = "dhcma.smd.report.csp?1=1" +
						"&EpisodeID=" + strEpisodeID +
						"&PatientID=" + strPatientID +
						"&ReportID=" + "" +
						"&DiseaseID=" + CDInfo[1] +
						"&ReportType=" + "1";
						websys_showModal({
							url:strUrl,
							title:'精神疾病报告',
							iconCls:'icon-w-epr',  
					        originWindow:window,
					        closable:false,
							width:1320,
							height:Height,
							onBeforeClose:function(){
								var RepFlag = top.$('#flag').val();		
								//精神疾病保存失败,删除精神疾病
								if (RepFlag !=1 ) {
									DeleteMRDiagnos(MRDiagnosRowid);
								}
							} 
						}); 
					}
				});   
			}
			if(CDInfo[0]=='1')
			{
				$.messager.confirm("提示","该病例已上报,您确认是否重复上报？", function (r) {
					if (r){
						var strURL = "dhcma.smd.report.csp?1=1" +
						"&EpisodeID=" + strEpisodeID +
						"&PatientID=" + strPatientID +
						"&ReportID=" + "" +
						"&DiseaseID=" + CDInfo[1] +
						"&ReportType=" + "1";
						websys_showModal({
							url:strUrl,
							title:'精神疾病报告',
							iconCls:'icon-w-epr',  
					        originWindow:window,
							closable:false,
							width:1320,
							height:Height,
							onBeforeClose:function(){
								var RepFlag = top.$('#flag').val();		
								//精神疾病保存失败,删除精神疾病
								if (RepFlag !=1 ) {
									DeleteMRDiagnos(MRDiagnosRowid);
								}
							} 
						}); 
					}
				});
			}
		}
	}
}
function CheckCDReport(MRDiagnosRowid)
{
	var strEpisodeID = document.getElementById("EpisodeID").value;
	var strPatientID = document.getElementById("PatientID").value;
	var CDInfo=tkMakeServerCall("DHCMed.CDService.Service","CheckMRDiagnos","CD",MRDiagnosRowid);
	if (CDInfo=="") return;
	var tmpList=CDInfo.split("^");
	var RepType=tmpList[3];
	var url="";
	var CDReportIs=tkMakeServerCall("DHCMed.SS.Config","GetValueByKeyHosp","CheckCDReportIsNot");
	if (CDInfo){
		if (tmpList.length>=1){
			if ((tmpList[0]=='0')||(CDReportIs=="0")){
				$.messager.confirm("提示",tmpList[2], function (r) {
				if (r){
					switch(RepType)
						{
							case "肿瘤":
							var strUrl="dhcma.cd.reportzlk.csp?1=1&ReportID="+""+"&EpisodeID="+strEpisodeID+"&PatientID="+strPatientID+"&IFRowID=" + tmpList[1] + "&LocFlag=0";
							break;
							case "心脑血管":
							var strUrl="dhcma.cd.reportxnxg.csp?1=1&ReportID="+""+"&EpisodeID="+strEpisodeID+"&PatientID="+strPatientID+"&IFRowID=" + tmpList[1] + "&LocFlag=0"+"&DiagnosDr="+MRDiagnosRowid;
							break;
							case "糖尿病":
							var strUrl="dhcma.cd.reporttnb.csp?1=1&ReportID="+""+"&EpisodeID="+strEpisodeID+"&PatientID="+strPatientID+"&IFRowID=" + tmpList[1] + "&LocFlag=0";
							break;
							case "农药中毒":
							var strUrl="dhcma.cd.reportnyzd.csp?1=1&ReportID="+""+"&EpisodeID="+strEpisodeID+"&PatientID="+strPatientID+"&IFRowID=" + tmpList[1] + "&LocFlag=0";
							break;
							case "伤害":
							var strUrl="dhcma.cd.reportshk.csp?1=1&ReportID="+""+"&EpisodeID="+strEpisodeID+"&PatientID="+strPatientID+"&IFRowID=" + tmpList[1] + "&LocFlag=0";
							break;
							case "疑似职业病":
							var strUrl="dhcma.cd.reportyszyb.csp?1=1&ReportID="+""+"&EpisodeID="+strEpisodeID+"&PatientID="+strPatientID+"&IFRowID=" + tmpList[1] + "&LocFlag=0";
							break;
							case "高温中暑":
							var strUrl="dhcma.cd.reportgwzs.csp?1=1&ReportID="+""+"&EpisodeID="+strEpisodeID+"&PatientID="+strPatientID+"&IFRowID=" + tmpList[1] + "&LocFlag=0";
							break;
							case "一氧化碳中毒":
							var strUrl="dhcma.cd.reportfzyco.csp?1=1&ReportID="+""+"&EpisodeID="+strEpisodeID+"&PatientID="+strPatientID+"&IFRowID=" + tmpList[1] + "&LocFlag=0";
							break;
							case "慢病":
							var strUrl="dhcma.cd.reportmbbk.csp?1=1&ReportID="+""+"&EpisodeID="+strEpisodeID+"&PatientID="+strPatientID+"&IFRowID=" + tmpList[1] + "&LocFlag=0";
							break;								
							default:
							var strUrl="";
							break;
						}
					var retValue = websys_showModal({
							url:strUrl,
							title:'慢性疾病报告',
							iconCls:'icon-w-epr',  
					        originWindow:window,
					        closable:false,
							width:1320,
							height:Height
						});
					}
				});
			}else if ((tmpList[0]=='1')&&(CDReportIs=="1")){
					$.messager.alert("提示", tmpList[2], 'info',function() {
				
					switch(RepType)
						{
							case "肿瘤":
							var strUrl="dhcma.cd.reportzlk.csp?1=1&ReportID="+""+"&EpisodeID="+strEpisodeID+"&PatientID="+strPatientID+"&IFRowID=" + tmpList[1] + "&LocFlag=0";
							break;
							case "心脑血管":
							var strUrl="dhcma.cd.reportxnxg.csp?1=1&ReportID="+""+"&EpisodeID="+strEpisodeID+"&PatientID="+strPatientID+"&IFRowID=" + tmpList[1] + "&LocFlag=0";
							break;
							case "糖尿病":
							var strUrl="dhcma.cd.reporttnb.csp?1=1&ReportID="+""+"&EpisodeID="+strEpisodeID+"&PatientID="+strPatientID+"&IFRowID=" + tmpList[1] + "&LocFlag=0";
							break;
							case "农药中毒":
							var strUrl="dhcma.cd.reportnyzd.csp?1=1&ReportID="+""+"&EpisodeID="+strEpisodeID+"&PatientID="+strPatientID+"&IFRowID=" + tmpList[1] + "&LocFlag=0";
							break;
							case "伤害":
							var strUrl="dhcma.cd.reportshk.csp?1=1&ReportID="+""+"&EpisodeID="+strEpisodeID+"&PatientID="+strPatientID+"&IFRowID=" + tmpList[1] + "&LocFlag=0";
							break;
							case "疑似职业病":
							var strUrl="dhcma.cd.reportyszyb.csp?1=1&ReportID="+""+"&EpisodeID="+strEpisodeID+"&PatientID="+strPatientID+"&IFRowID=" + tmpList[1] + "&LocFlag=0";
							break;
							case "高温中暑":
							var strUrl="dhcma.cd.reportgwzs.csp?1=1&ReportID="+""+"&EpisodeID="+strEpisodeID+"&PatientID="+strPatientID+"&IFRowID=" + tmpList[1] + "&LocFlag=0";
							break;
							case "一氧化碳中毒":
							var strUrl="dhcma.cd.reportfzyco.csp?1=1&ReportID="+""+"&EpisodeID="+strEpisodeID+"&PatientID="+strPatientID+"&IFRowID=" + tmpList[1] + "&LocFlag=0";
							break;
							case "慢病":
							var strUrl="dhcma.cd.reportmbbk.csp?1=1&ReportID="+""+"&EpisodeID="+strEpisodeID+"&PatientID="+strPatientID+"&IFRowID=" + tmpList[1] + "&LocFlag=0";
							break;		
													
							default:
							var strUrl="";
							break;
						}
						websys_showModal({
							url:strUrl,
							title:'慢性疾病报告',
							iconCls:'icon-w-epr',  
					        originWindow:window,
					        closable:false,
							width:1320,
							height:Height,
							onBeforeClose:function(){
								var RepFlag = top.$('#flag').val();		
								if (RepFlag !=1 ) {
									DeleteMRDiagnos(MRDiagnosRowid);
								}
							} 
						});
					});
			}
		}
	}
}
//食源性疾病报告准入提示
function CheckFBDReport(MRDiagnosRowid)
{
	var obj=document.getElementById('EpisodeID');
	if (obj){var EpisodeID=obj.value}
	if (EpisodeID=='') return;
	var obj=document.getElementById('PatientID');
	if (obj){var PatientID=obj.value};
	//如果是8.2以下版本，可能用此写法	
	var icdInfo=tkMakeServerCall("DHCMed.FBDService.Service","CheckDiagnosToFBD",EpisodeID,MRDiagnosRowid);
	if (icdInfo){
		var tmpList=icdInfo.split("^");
		if (tmpList.length>=1){
			if ((tmpList[0]=='0')||(tmpList[0]=='1')) {
				//提示
				$.messager.confirm("提示",tmpList[2], function (r) {
					if (r){
						var strUrl = "./dhcma.fbd.report.csp?1=1" + "&PatientID=" + PatientID 
						           + "&EpisodeID=" + EpisodeID + "&DiseaseID=" +tmpList[1] + "&LocFlag=0" ;
					    websys_showModal({
							url:strUrl,
							title:'食源性疾病报告',
							iconCls:'icon-w-epr',  
					        originWindow:window,
					        closable:false,
							width:1320,
							height:Height
						});
		
					}
				});
			}
		}
	}
}
