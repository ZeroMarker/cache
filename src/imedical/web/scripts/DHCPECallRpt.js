/// DHCPECallRpt.js
/// 创建人		xwm
/// 创建时间		2006.05.22
/// 最后修改时间	
/// 最后修改人	
/// 完成			

function BodyLoadHandler() {

	var obj;
	
	obj=document.getElementById("BClose");
	if (obj) { obj.onclick=Close_click; }	
	
	obj=document.getElementById("PrintReport");
	if (obj) { 
		obj.onclick=PrintReport_click; 
		obj.disabled=true; 
	}

	var Ins=iniForm();
	if (Ins) { obj.disabled=false; }
	else{
		// 关闭窗口
		//Close_click();
	}

}

function trim(s) {
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

function iniForm(){

	var obj=document.getElementById("EpisodeID");
	if (obj) { var iEpisodeID=obj.value; }

	var Instring=trim(iEpisodeID)+"^";
	var Ins=document.getElementById('GetIReportInfor');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring)

	if ('Err 04'==flag) {
		//alert(("无效 Adm");
		alert(t['Err 04']);
		return false;
	}

	if ('Err 05'==flag) {
		//alert(("未找到体检人信息");
		alert(t['Err 05']);
		return false;
	}

	if ('Err 06'==flag) {
		//alert(("未找到报告信息");
		alert(t['Err 06']);
		return false;
	}

	if ('Err 07'==flag) {
		//alert(("无效报告状态");
		alert(t['Err 07']);
		return false;
	}

 	var Date=flag.split("^");

 	//报表 RowId
 	obj=document.getElementById("RowId");
	if (obj) { obj.value=Date[0]; }
	
	//患者姓名
	obj=document.getElementById("IADM_DR_Name");
	if (obj) { obj.value=Date[1]; }
	 	
	//单位
	obj=document.getElementById("GADM_DR_Name");
	if (obj) { obj.value=Date[2]; }
	 	
	//打印格式
	obj=document.getElementById("PrintFormat");
	if (obj) { obj.value=Date[3]; }

	//打印格式
	obj=document.getElementById("Status");
	if (obj) {
		obj.value=Date[4];
		if ('NA'==obj.value) {  
			//alert("报告未审核,不能报告");
			alert(t['Err 01']); 
			return false;
		}		
	}

	//打印格式
	obj=document.getElementById("StatusDesc");
	if (obj) { 
		obj.value=Date[5]; 

	}
	
	// 默认是预览报告
	obj=document.getElementById("cbIsPrintView");
	if (obj) { obj.checked=true; }
	return true;
}

function Close_click() {
	close();
}

function PrintReport_click() {

	var src=document.getElementById("PrintReport"); //window.event.sreElement;
	if ((src)&&(src.disabled)) { return; }
	//src.diabled=true;
	
	var IsPrintView=false;
	var ISPrintTitle=false;
	var iEpisodeID="";	 	
	var obj;
	var iReportName="";
	obj=document.getElementById("ReportNameBox");
	if (obj) { iReportName=obj.value; }
	
	obj=document.getElementById("EpisodeID");
	if (obj) { iEpisodeID=obj.value; }
	 	
	obj=document.getElementById("cbIsPrintView");
	if (obj.checked){ IsPrintView=true; }
	else{ IsPrintView=false; }
	
	obj=document.getElementById("cbPrintTitle");
	if (obj && obj.checked){ ISPrintTitle=true; }
	else{ ISPrintTitle=false; }  

	if (IsPrintView) {
		var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no'
				+',left=0'
				+',top=0'
				+',width='+window.screen.availWidth
				+',height='+window.screen.availHeight
				;
		var lnk=iReportName+"?PatientID="+iEpisodeID;
		open(lnk,"_blank",nwin);
		close();
		//Update_click();
	}
	else{
		var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no'
				+',left=0'
				+',top=0'
				+',width='+window.screen.availWidth
				+',height='+window.screen.availHeight
				;
		var lnk=iReportName+"?PatientID="+iEpisodeID;
		Update_click();
		open(lnk,"_blank",nwin);
		
		return;
		
		/*
		try {
			var ReportDll = new ActiveXObject("DHCPEReportPrintDll.CPrint");
			ReportDll.printreport(iEpisodeID,IsPrintView,1,ISPrintTitle);
			ReportDll=null;
		}
		catch (e) {
			alert(unescape(t['XLAYOUTERR']));
		}
		Update_click();
		*/
	}
	//close();

}

// *****************************************************
// 报告状态设置 设置为已打印
function Update_click(){

	var iReportID=""
	var iUserUpdateDR="", iDateUpdate="",iStatus="";
	var obj;	
	
	//灰化状态?退出
	var eSrc=window.event.srcElement;
	if (eSrc.disabled) { return false; }
	
	//报告编码	
	obj=document.getElementById("ReportID");
	if (obj) { iReportID=obj.value; }

	//用户编码	取网页上的(会话 session )用户编码 
	iUserUpdateDR=session['LOGON.USERID'];
  	
  	//取服务器时间
  	iDateUpdate="";
  	
	//obj=document.getElementById("Status");
	//if (obj) { iStatus=obj.value; }
	iStatus="P";	//设置为已打印

	var Instring=trim(iReportID)
					+"^"+iStatus
					+"^"+trim(iUserUpdateDR)
					+"^"+trim(iDateUpdate)
					;
	var Ins=document.getElementById('ClassBox');
	if (Ins) { var encmeth=Ins.value; } 
	else { var encmeth=''; };
	//alert(Instring);
	var flag=cspRunServerMethod(encmeth,'','',Instring);
	
	
 	if ('0'==flag) {}
	else{
		//alert("Insert error.ErrNo="+flag)
		alert(t['02']+flag);
	}
}

document.body.onload = BodyLoadHandler;

