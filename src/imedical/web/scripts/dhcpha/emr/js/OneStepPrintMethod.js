﻿/*
集中打印
01.	检查报告    
02.	检验报告
03.	医嘱单
04.	体温单
05.	住院证
06.	护理病历
07.	病历文书
71. 病历文书新版
08.	麻醉记录
09.	病理
10.	电生理（原心电图）
51.	护理病历（检验）
*/

function printSelectedItem(arrCategory, arrCategoryDetail) {
    //debugger;
    if (arrCategory.length < 1) return;

    var arrCount = arrCategory.length;
    for (var i = 0; i < arrCount; i++) {
        var categoryID = arrCategory[i];
        var categoryDetail = arrCategoryDetail[i];
        var para = {EpisodeID: episodeID, PatientID: patientID, CategoryDetail: categoryDetail };
		
        if (categoryID == "CG01") {
            print01(para);
        }
        else if (categoryID == "CG02") {
            print02(para);
        }
        else if (categoryID == "CG03") {
            print03(para);
        }
        else if (categoryID == "CG04") {
            print04(para);
        }
        else if (categoryID == "CG05") {
            print05(para);
        }
        else if (categoryID == "CG06") {
            print06(para);
        }
        else if (categoryID == "CG07") {
	    print07(para);
        }
	    else if (categoryID == "CG71") {
	    print71(para);
        }
        else if (categoryID == "CG08") {
            print08(para);
        }
        else if (categoryID == "CG09") {
            print09(para);
        }
        else if (categoryID == "CG10") {
			var count = categoryDetail.split("!").length;
			var str= new Array();
			str = categoryDetail.split("!");
			for (var i=0;i<count;i++){
				var categoryDetail = str[i];
				var para = {EpisodeID: episodeID, PatientID: patientID, CategoryDetail: categoryDetail };
            	print10(para);
			}
        }
		else if (categoryID == "CG51") {
            print51(para);
        }
		//增加图片扫描节点打印，扫描节点detailInfo中的形式为PS^图片1路径^图片2路径^图片3路径...   --add by yang 2012-9-21
		else if (categoryID == "PS"){
			printScan(categoryDetail);
		} 
		addPrintRecord(categoryID,episodeID,patientID,patName,categoryDetail,userID,ctlocid); 
    }
}

//01.	检查报告
function print01(para) {
    //alert("检查报告,episodeID: "+episodeID+" patientID: "+patientID);
    try{
		//websys_createWindow('DHCRISReport.Print.csp?EpisodeID='+episodeID,'RIS',"top=10000,left=10000,width=0,height=0");
		window.showModalDialog("dhcrisreport.print.csp",para,"dialogHeight:10000px;dialogLeft:10000px;dialogTop:0px;dialogWidth:0px;dialogHide:no;");
	}catch(e){
		alert(e.message)
	}
}

//02.	检验报告
function print02(para) {
  //alert("检验报告,episodeID: "+episodeID+" patientID: "+patientID);
    try{
        window.showModalDialog("dhclabprintresultemr.csp",para,"dialogHeight:800px;dialogLeft:600px;dialogTop:0px;dialogWidth:0px;dialogHide:no;");
    }catch(e){
        alert(e.message)
    }

}

//03.	医嘱单
function print03(para) {
    //alert("医嘱单,episodeID: "+episodeID+" patientID: "+patientID);
    try{
        window.showModalDialog("DHCNurseIPCommOrdPrint.csp",para,"dialogHeight:10000px;dialogLeft:10000px;dialogTop:0px;dialogWidth:0px;dialogHide:no;");
    }catch(e){
        alert(e.message)
    }
}

//04.	体温单
function print04(para) {
    /*/alert("体温单,episodeID: "+episodeID+" patientID: "+patientID);
	var TempPre;
	var frm = document.forms["fEPRMENU"];
	
  	TempPre= new ActiveXObject("Temp.ClsTemp");//TestAx.CLSMAIN
  	TempPre.quit();
  	TempPre.Adm = episodeID;
  	TempPre.ConnectString ="cn_iptcp:172.26.201.11[1972]:WEBSRC";
  	TempPre.patname = ""
  	TempPre.bedcode = ""
  	TempPre.Show();*/
  	//alert("体温单,episodeID: "+episodeID+" patientID: "+patientID);
      try{
	//ZYZ_Print(episodeID);
	//websys_createWindow('DHCDocIPBookNew.Print.csp?EpisodeID='+episodeID,'DocIPBook',"top=10000,left=10000,width=0,height=0");
        window.showModalDialog("DHCNurseIPTemperatureCOMM.csp",para,"dialogHeight:10000px;dialogLeft:10000px;dialogTop:0px;dialogWidth:0px;dialogHide:no;");
    }catch(e){
        alert(e.message)
    }
}

//05.	住院证
function print05(para) {
    //alert("住院证,episodeID: "+episodeID+" patientID: "+patientID);
    try{
	//ZYZ_Print(episodeID);
	//websys_createWindow('DHCDocIPBookNew.Print.csp?EpisodeID='+episodeID,'DocIPBook',"top=10000,left=10000,width=0,height=0");
        window.showModalDialog("DHCDocIPBookNew.Print.csp",para,"dialogHeight:10000px;dialogLeft:10000px;dialogTop:0px;dialogWidth:0px;dialogHide:no;");
    }catch(e){
        alert(e.message)
    }
}

//06.	护理病历
function print06(para) {
    //alert("护理病历,episodeID: "+episodeID+" patientID: "+patientID);
	try{
        window.showModalDialog("dhcnuremrprint.csp",para,"dialogHeight:10000px;dialogLeft:10000px;dialogTop:0px;dialogWidth:0px;dialogHide:no;");
    }catch(e){
        alert(e.message)
    }
}

//07.	病历文书
function print07(para) {
    try {
        if (para.CategoryDetail == "") return; 
        window.showModalDialog("dhc.epr.onestepprintepr.csp",para,"dialogHeight:300px;dialogLeft:200px;dialogTop:200px;dialogWidth:500px;center:no;dialogHide:no;edge:sunken;help:yes;resizable:no;scroll:no;status:no;unadorned:no;");
    } catch (e) {
        alert(e.message);
    }    
}

//07.	病历文书新版
function print71(para) {
    try {
        if (para.CategoryDetail == "") return; 
        var categoryDetailArray = new Array();
        categoryDetailArray = para.CategoryDetail.split("!");
        
        for (var i = 0; i < categoryDetailArray.length; i++) {
	        para.CategoryDetail = categoryDetailArray[i];
        	window.showModalDialog("emr.interface.print.csp?EpisodeID=" + para.EpisodeID + "&PatientID=" + para.PatientID + "&CatalogID=" + para.CategoryDetail,para,"dialogHeight:300px;dialogLeft:200px;dialogTop:200px;dialogWidth:500px;center:no;dialogHide:no;edge:sunken;help:yes;resizable:no;scroll:no;status:no;unadorned:no;");		
        }
    } catch (e) {
        alert(e.message);
    }    
}

//08.	麻醉记录
function print08(para) {
    alert("麻醉记录,episodeID: "+episodeID+" patientID: "+patientID);
}

//09.	病理
function print09(para) {
    //alert("病理,episodeID: "+episodeID+" patientID: "+patientID);
	try{
		//websys_createWindow('DHCPISReport.Print.csp?EpisodeID='+episodeID,'TRAK_hidden');
		window.showModalDialog("dhcpisreport.print.csp",para,"dialogHeight:300px;dialogLeft:200px;dialogTop:200px;dialogWidth:500px;dialogHide:no;");		
	}catch(e){
		alert(e.message)
	}
}

//10.	电生理
function print10(para){
    try{
		window.showModalDialog("EKGAkeyPrint.EPROneStepPrint.csp",para,"dialogHeight:300px;dialogLeft:200px;dialogTop:200px;dialogWidth:500px;dialogHide:no;");		
	}catch(e){
		alert(e.message)
	}
}



//打印扫描
//增加图片扫描节点打印，扫描节点detailInfo中的形式为PS^图片1路径^图片2路径^图片3路径...   --add by yang 2012-9-21
function printScan(para){
	try{
		window.showModalDialog("dhc.epr.onestepprintscan.csp",para,"dialogHeight:300px;dialogLeft:200px;dialogTop:200px;dialogWidth:500px;center:no;dialogHide:no;edge:sunken;help:yes;resizable:no;scroll:no;status:no;unadorned:no;");
	}catch(e){
		alert(e.message);
	}
}

//51.	护理病历(检验)
function print51(para) {
    alert("护理病历(检验)),episodeID: "+episodeID+" patientID: "+patientID);
/*		
try{
        window.showModalDialog("dhcnuremrprint.csp",para,"dialogHeight:10000px;dialogLeft:10000px;dialogTop:0px;dialogWidth:0px;dialogHide:no;");
    }catch(e){
        alert(e.message);
    }
*/
}

function addPrintRecord(categoryID,episodeID,patientID,patName,categoryDetail,userID,ctlocid){
	//ajax 打印完写打印记录
	Ext.Ajax.request({
		url: '../web.eprajax.onestepprint.cls',
		timeout: 5000,
		params: {
			Action: "addprintrecord",
			CategoryID: categoryID,
			CategoryDetail: categoryDetail,
			EpisodeID: episodeID,
			PatientID: patientID,
			PatName: patName,
			UserID: userID,
			CTLocID:ctlocid
		},
		success: function(response, opts){
			if (response.responseText != "-1") {
				//成功，递归打印下一个选中打印项，并刷新打印项表格显示页码信息
			}
			else{
				Ext.MessageBox.alert("提示", response.responseText);
			}
		},
		failure: function(response, opts){
			Ext.MessageBox.alert("提示", response.responseText);
		}
	});
}

