﻿/*
集中打印
01.	检查报告    
02.	检验报告
03.	医嘱单
04.	体温单
05.	住院证
06.	护理病历
07.	病历文书
08.	麻醉记录
09.	病理
10.	心电图
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
            print03(para );
        }
        else if (categoryID == "CG04") {
            print04(para );
        }
        else if (categoryID == "CG05") {
            print05(para );
        }
        else if (categoryID == "CG06") {
            print06(para );
        }
        else if (categoryID == "CG07") {
            print07(para );
        }
        else if (categoryID == "CG08") {
            print08(para );
        }
        else if (categoryID == "CG09") {
            print09(para );
        }
        else if (categoryID == "CG10") {
            print10(para);
        }
        
    }
}

//01.	检查报告
function print01(para) {
		//alert("检查报告,episodeID: "+episodeID+" patientID: "+patientID);
		try{
			window.showModalDialog("DHCRISReport.Print.csp",para,"dialogHeight:10000px;dialogLeft:10000px;dialogTop:0px;dialogWidth:0px;dialogHide:no;");	
		}catch(e){
			alert(e.message)
		}
}

//02.	检验报告
function print02(para) {
	//alert("检验报告,episodeID: "+episodeID+" patientID: "+patientID);
   try{
			window.showModalDialog("DHCLISReport.Print.csp",para,"dialogHeight:10000px;dialogLeft:10000px;dialogTop:0px;dialogWidth:0px;dialogHide:no;");	
		}catch(e){
	    alert("检验报告,episodeID: "+episodeID+" patientID: "+patientID);
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
    //alert("体温单,episodeID: "+episodeID+" patientID: "+patientID);
    try{
        window.showModalDialog("DHCNurseIPTemperatureCOMM.csp",para,"dialogHeight:10000px;dialogLeft:10000px;dialogTop:0px;dialogWidth:0px;dialogHide:no;");
    }catch(e){
        alert(e.message)
    }    
}

//05.	住院证
function print05(para) {
    //alert("住院证,episodeID: "+episodeID+" patientID: "+patientID);
    try{
        window.showModalDialog("DHCDocIPBookNew.Print.csp",para,"dialogHeight:10000px;dialogLeft:10000px;dialogTop:0px;dialogWidth:0px;dialogHide:no;");
    }catch(e){
        alert(e.message)
    }
}

//06.	护理病历
function print06(para) {
    alert("护理病历,episodeID: "+episodeID+" patientID: "+patientID);
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

//08.	麻醉记录
function print08(para) {
    alert("麻醉记录,episodeID: "+episodeID+" patientID: "+patientID);
}

//09.	病理
function print09(para) {
    //alert("病理,episodeID: "+episodeID+" patientID: "+patientID);
    try{
			      window.showModalDialog("DHCPISReport.Print.csp",para,"dialogHeight:10000px;dialogLeft:10000px;dialogTop:0px;dialogWidth:0px;dialogHide:no;");		
		}catch(e){
					alert(e.message)
				}
		}

//10.	心电图
function print10() {
    alert("心电图,episodeID: "+episodeID+" patientID: "+patientID);
}