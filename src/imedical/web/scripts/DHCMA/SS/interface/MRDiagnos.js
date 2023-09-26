
//传染病提示/强制报卡接口方法
function CheckDisease(MRDiagnosRowid){
	var obj=document.getElementById('EpisodeID');
	if (obj){var EpisodeID=obj.value};
	var obj=document.getElementById('PatientID');
	if (obj){var PatientID=obj.value};
	if (EpisodeID=='') return;
	// modify by mxp 2018-02-23 根据传入诊断记录ID，判断是否需要上报传染病
	var icdInfo=tkMakeServerCall("DHCMed.EPDService.Service","CheckDiagnosToEpd",EpisodeID,MRDiagnosRowid);
	if (icdInfo){
		var tmpList=icdInfo.split("^");
		if (tmpList.length>=1){
			//alert(tmpList[0]);//测试
			if (tmpList[0]=='0'){
				//提示报卡
				var ret=window.confirm(tmpList[2]);
				if (ret){
					var strUrl = "./dhcmed.epd.report.csp?" + 
						"PatientID=" + PatientID +
						"&EpisodeID=" + EpisodeID +
						"&IFRowID=" + tmpList[1] +
						"&LocFlag=0";
					//window.open(strUrl, "_blank" ,"height=600,width=850,left=50,top=50,status=yes,toolbar=no,menubar=no,location=no");
					var retValue = window.showModalDialog(
							strUrl,
							"",
							"dialogHeight: 620px; dialogWidth: 1200px");
					if (!retValue){
						//传染病保存失败,删除传染病
						//CheckDisease();
						DeleteMRDiagnos(MRDiagnosRowid);
					}
				}
			}else if (tmpList[0]=='1'){
				//强制报卡
				alert(tmpList[2]);
				var strUrl = "./dhcmed.epd.report.csp?" + 
					"PatientID=" + PatientID +
					"&EpisodeID=" + EpisodeID +
					"&IFRowID=" + tmpList[1] +
					"&LocFlag=0";
				//window.open(strUrl, "_blank" ,"height=600,width=850,left=50,top=50,status=yes,toolbar=no,menubar=no,location=no");
				var retValue = window.showModalDialog(
						strUrl,
						"",
						"dialogHeight: 620px; dialogWidth: 1200px");
				if (!retValue){
					//传染病保存失败,删除传染病
					//CheckDisease();
					DeleteMRDiagnos(MRDiagnosRowid);
				}
			}else if (tmpList[0]=='2'){ //add by liuxuefeng 2011-10-17 提示报卡alert模式
				//提示报卡
				var ret=window.alert(tmpList[2]);
				return
			}
		}
	}
}

//门诊临床路径和住院临床路径（V4）新整合后接口
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
//临床路径4.0住院路径准入提示接口
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
//临床路径准入提示接口方法
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
	
	var CDInfo=tkMakeServerCall("DHCMed.SMDService.Service","IsDiagnoseNeedReport",strEpisodeID,"");
	if(CDInfo){
		var CDInfo=CDInfo.split("^");
		//var bool = window.confirm("您填写的“" + arryFields[13] + "”诊断需要上报“" + ret[2] + "病例报告卡”！\n是否上报?");
		if(CDInfo.length>=1){
			if(CDInfo[0]=='0')
			{
				alert(CDInfo[2])
				//var bool = window.confirm(CDInfo[2])
				var strURL = "dhcmed.smd.report.csp?1=1" +
					"&EpisodeID=" + strEpisodeID +
					"&PatientID=" + strPatientID +
					"&ReportID=" + "" +
					"&DiseaseID=" + CDInfo[1] +
					"&ReportType=" + "1";
				
				//window.alert("您填写的“" + arryFields[13] + "”诊断需要上报“" + ret[2] + "病例报告卡”！");
				var retValue = window.showModalDialog(strURL, null, "dialogHeight:1000px;dialogWidth:1000px;");	
				if(!retValue)
				{	//,删除精神疾病
					DeleteMRDiagnos(MRDiagnosRowid);
				}
			}
			if(CDInfo[0]=='1')
			{
				var bool = window.confirm("该病例已上报,您确认是否重复上报？");
				if(bool){
					var strURL = "dhcmed.smd.report.csp?1=1" +
					"&EpisodeID=" + strEpisodeID +
					"&PatientID=" + strPatientID +
					"&ReportID=" + "" +
					"&DiseaseID=" + CDInfo[1] +
					"&ReportType=" + "1";
				
					var retValue = window.showModalDialog(strURL, null, "dialogHeight:1000px;dialogWidth:1000px;");					
					if(!retValue)
					{	//,删除精神疾病
						DeleteMRDiagnos(MRDiagnosRowid);
					}
				}
			}
		}
	}
}
