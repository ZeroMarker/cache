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

//保存前进行多个诊断的报卡提示检查
function CheckReportBeforeInsert(DiagItemStr,callBackDocFun){
	var objAdm = document.getElementById('EpisodeID');
	if (objAdm) var EpisodeID = objAdm.value;
	var objPat = document.getElementById('PatientID');
	if (objPat) var PatientID = objPat.value;
	if (EpisodeID=='') return;
	var arrDiagItemStr = DiagItemStr.split(String.fromCharCode(1));
	var len = arrDiagItemStr.length;
	new Promise(function(resolve,reject){
		(function loop(i){
			new Promise(function(resolve,reject){
				var tmpItemStr = arrDiagItemStr[i].split("^");
				if (tmpItemStr[0]!="") {  //已经保存的不做检查  没办法退出？？
					var DiagType =tmpItemStr[2];;
					var ICDDxID = tmpItemStr[10];;
					var DiagNote = tmpItemStr[1].split("#")[0];
					resolve(true);			
				} else { 
					var DiagType = tmpItemStr[3];
					var ICDDxID = tmpItemStr[2];
					var DiagNote = tmpItemStr[1].split("#")[0];
				}
				CheckReport(EpisodeID,PatientID,DiagType,ICDDxID,DiagNote,resolve);
				
				//检查罕见病
				var RDSDiagInfo = '^'+ ICDDxID +'^'+ DiagNote;
				var RDSDiagStatus = (tmpItemStr[5] == '3') ? '确诊' : '疑诊';
				//showRDS(EpisodeID,RDSDiagInfo,RDSDiagStatus);
				
			}).then(function(ret){
				if (!ret) {
					resolve(false);
				}else{
					i++;
					if (i<len){
						loop(i)
					}
					else{
						resolve(true);
					}
				}
			})
		})(0)			
	}).then(function(ret){
		 if(ret) callBackDocFun(DiagItemStr);
		 else callBackDocFun(false);
	})
}

//对单个诊断进行报卡提示检查(传染病、慢病、食源性疾病、精神疾病等)
function CheckReport(EpisodeID,PatientID,DiagType,ICDDxID,DiagNote,callBackFun){
	var p_Array = [];
	
	//传染病
	var p_EPD = CheckReportEPD(EpisodeID,PatientID,DiagType,ICDDxID,DiagNote);
	p_Array.push(p_EPD);

	//食源性疾病
	var p_FBD = CheckReportFBD(EpisodeID,PatientID,DiagType,ICDDxID,DiagNote);
	p_Array.push(p_FBD);
		
	//慢病
	var p_CD = CheckReportCD(EpisodeID,PatientID,DiagType,ICDDxID,DiagNote);
	p_Array.push(p_CD);

	//精神疾病
	var p_SMD = CheckReportSMD(EpisodeID,PatientID,DiagType,ICDDxID,DiagNote);
	p_Array.push(p_SMD);
	
	//Promise.all方式实现
	Promise.all(p_Array).then(function(results){
		callBackFun(true);
	},function(err){
		callBackFun(false);	
	})
}

//检查传染病
function CheckReportEPD(EpisodeID,PatientID,DiagType,ICDDxID,DiagNote){
	return new Promise(function(resolve,reject){	
		var EPDInfo=tkMakeServerCall("DHCMed.EPDService.Service","CheckDiagToEpd",EpisodeID,DiagType,ICDDxID,DiagNote);
		if (EPDInfo){
			var EPDInfoArr=EPDInfo.split(String.fromCharCode(1));
			for (var i=0; i<EPDInfoArr.length; i++) {
				var EPDItem=EPDInfoArr[i];
				var tmpList=EPDItem.split("^");
				//提示报卡
				if (tmpList[0]=='0'){
					$.messager.defaults.ok = "立即上报";
					$.messager.defaults.cancel = "无需上报";
					$.messager.confirm("提示",tmpList[2], function (r) {
						if (r){
							var strUrl = "./dhcma.epd.report.csp?" + "PatientID=" + PatientID +"&EpisodeID=" + EpisodeID +"&IFRowID=" + tmpList[1] +"&LocFlag=0" ;
							websys_showModal({
								url:strUrl,
								title:'传染病报告',
								iconCls:'icon-w-epr',  
								originWindow:window,
								closable:false,
								width:1340, 
								height:Height, 
								onClose:function(){
									$.messager.defaults.ok = "确定";
									$.messager.defaults.cancel = "取消";	
									resolve(true);							
								} 
							}); 
						}else{
							$.messager.defaults.ok = "确定";
							$.messager.defaults.cancel = "取消";	
							resolve(true);
						}
					});
				}else if (tmpList[0]=='1'){
					$.messager.defaults.ok = "立即上报";
					$.messager.defaults.cancel = "无需上报";
					//强制报卡
					$.messager.alert("提示", tmpList[2], 'info',function() {
						var strUrl = "./dhcma.epd.report.csp?" + "PatientID=" + PatientID +"&EpisodeID=" + EpisodeID +"&IFRowID=" + tmpList[1] +"&LocFlag=0";
						websys_showModal({
							url:strUrl,
							modal:true,
							title:'传染病报告',
							iconCls:'icon-w-epr', 
							closable:false,						
							width:1340,
							height:Height, 
							onBeforeClose:function(){
								var top = websys_getTop();
								var RepFlag = top.$('#flag').val();	
								$.messager.defaults.ok = "确定";
								$.messager.defaults.cancel = "取消";									
								if (RepFlag==1 ) {//传染病保存
									resolve(true);
								}else {
									reject(false);
								}									
							}
						}); 
					})
				}else{
					resolve(true);
				}
			}
		}else{
			resolve(true);
		}
	})
}

//检查食源性疾病
function CheckReportFBD(EpisodeID,PatientID,DiagType,ICDDxID,DiagNote){
	return new Promise(function(resolve,reject){
		var FBDInfo=tkMakeServerCall("DHCMed.FBDService.Service","CheckDiagnosToFBDNew",EpisodeID,DiagType,ICDDxID,DiagNote);
		if (FBDInfo){
			var tmpList=FBDInfo.split("^");
			if (tmpList.length>=1){
				$.messager.confirm("提示",tmpList[2], function (r) {
					if (r){
						var strUrl = "./dhcma.fbd.report.csp?1=1" + "&PatientID=" + PatientID + "&EpisodeID=" + EpisodeID + "&DiseaseID=" +tmpList[1] + "&LocFlag=0";
						websys_showModal({
							url:strUrl,
							title:'食源性疾病报告',
							iconCls:'icon-w-epr',  
							originWindow:window,
							closable:false,
							width:1320,
							height:Height, 
							onBeforeClose:function(){
								resolve(true);								
							} 
						})
					}else{
						resolve(true);	
					}				
				})
			}else{
				resolve(true);
			}
		}else{
			resolve(true);
		}
	})
}

//检查慢病
function CheckReportCD(EpisodeID,PatientID,DiagType,ICDDxID,DiagNote){
	return new Promise(function(resolve,reject){
		var CDInfo=tkMakeServerCall("DHCMed.CDService.Service","CheckDiagnosToCD",EpisodeID,DiagType,ICDDxID,DiagNote);
		if (CDInfo){
			var tmpList=CDInfo.split("^");
			var TypeCode=tmpList[2].toLowerCase();
			var TypeDesc=tmpList[3];
			if (tmpList[0]=='0'){
				//提示报卡
				$.messager.confirm("提示",tmpList[4], function (r) {
					if (r){
						var strUrl = "dhcma.cd.report"+TypeCode+".csp?1=1&ReportID="+""+"&EpisodeID="+EpisodeID+"&PatientID="+PatientID + "&LocFlag=0"+"&DiagnosDr="+tmpList[1]+"&ICDDxID="+ICDDxID;
						websys_showModal({
							url:strUrl,
							title:TypeDesc+'报告卡',
							iconCls:'icon-w-epr',  
					        originWindow:window,
					        closable:false,
							width:1320, 
							height:Height, 
							onClose:function(){
								resolve(true);							
							} 
						}); 
					}else{
						resolve(true);
					}
				});
			}else if (tmpList[0]=='1'){
				//强制报卡
				$.messager.alert("提示", tmpList[4], 'info',function() {
					var strUrl = "dhcma.cd.report"+TypeCode+".csp?1=1"+ "&PatientID=" + PatientID + "&EpisodeID=" + EpisodeID + "&LocFlag=0"+"&DiagnosDr="+tmpList[1]+"&ICDDxID="+ICDDxID;
					websys_showModal({
						url:strUrl,
						modal:true,
						title:TypeDesc+'报告卡',
						iconCls:'icon-w-epr', 
						closable:false,						
						width:1320,
						height:Height, 
						onBeforeClose:function(){
							var top = websys_getTop();
							var RepFlag = top.$('#flag').val();										
							if (RepFlag==1 ) {//慢性非传染性疾病保存
								resolve(true);
							}else {
								reject(false);
							}									
						}
					}); 
				})
			}else{
				resolve(true);
			}
		}else{
			resolve(true);
		}
	})
}

//检查精神疾病
function CheckReportSMD(EpisodeID,PatientID,DiagType,ICDDxID,DiagNote){
	return new Promise(function(resolve,reject){	
		var SMDInfo=tkMakeServerCall("DHCMed.SMDService.Service","CheckDiagnosToSMD",EpisodeID,DiagType,ICDDxID,DiagNote);
		if (SMDInfo){
			var tmpList=SMDInfo.split("^");
			if (tmpList[0]=='0'){
				//提示报卡
				$.messager.confirm("提示",tmpList[2], function (r) {
					if (r){
						var strUrl = "dhcma.smd.report.csp?1=1"+ "&PatientID=" + PatientID + "&EpisodeID=" + EpisodeID +"&DiseaseID=" + tmpList[1] +"&ReportType=" + tmpList[3];
						websys_showModal({
							url:strUrl,
							title:'精神疾病报告',
							iconCls:'icon-w-epr',  
					        originWindow:window,
					        closable:false,
							width:1320, 
							height:Height, 
							onClose:function(){
								resolve(true);							
							} 
						}); 
					}else{
						resolve(true);
					}
				});
			}else if (tmpList[0]=='1'){
				//强制报卡
				$.messager.alert("提示", tmpList[2], 'info',function() {
					var strUrl = "dhcma.smd.report.csp?1=1"+ "&PatientID=" + PatientID + "&EpisodeID=" + EpisodeID +"&DiseaseID=" + tmpList[1] +"&ReportType=" + tmpList[3];
					websys_showModal({
						url:strUrl,
						modal:true,
						title:'精神疾病报告',
						iconCls:'icon-w-epr', 
						closable:false,						
						width:1320,
						height:Height, 
						onBeforeClose:function(){
							var top = websys_getTop();
							var RepFlag = top.$('#flag').val();										
							if (RepFlag==1 ) {//精神疾病保存
								resolve(true);
							}else {
								reject(false);
							}									
						}
					}); 
				})
			}else{
				resolve(true);
			}
		}else{
			resolve(true);
		}
	})

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
		var strUrl = "./dhcma.cpw.io.show.csp?1=1" + "&EpisodeID=" + EpisodeID + "&CPWStr=" + encodeURI(encodeURI(CPWStr));
		var strIPCPWTitle=$g('临床路径入径提示');
		 websys_showModal({
			url:strUrl,
			title:strIPCPWTitle,
			iconCls:'icon-w-import',  
			closable:false,
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
		var strUrl = "./dhcma.cpw.io.opshow.csp?1=1" + "&EpisodeID=" + EpisodeID + "&OPCPWStr=" + encodeURI(encodeURI(OPCPWStr));
		var strOPCPWTitle=$g('临床路径入径提示')
		 websys_showModal({
			url:strUrl,
			title:strOPCPWTitle,
			iconCls:'icon-w-import',  
			closable:false,
			originWindow:window,
			width:900,
			height:500
		});
	})
}
