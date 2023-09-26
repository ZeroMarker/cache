/// DHCPEIllnessStatistic.IllnessStatisticList.js
/// 创建时间		2007.01.05
/// 创建人			xuwm
/// 主要功能		显示团体的列表-疾病汇总
/// 对应表		
/// 最后修改时间
/// 最后修改人	
function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("BShowImage");
	if (obj){ obj.onclick=ShowImage_click; }
	
	obj=document.getElementById("btnImport");
	if (obj){ obj.onclick=Import_click; }
		
	iniForm();
}

function iniForm() {

}
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
/*
function ShowImage() {
	mywin=window.open('chart1.htm')
    	
	if (mywin){
 		excall = function(){
	 		var Llabel,Lvalue;
	 		
			var table = document.getElementById("tDHCPEIllnessStatistic_DiagnosisList");
			//alert(table.rows.length);
			for(var iLLoop=1;iLLoop<table.rows.length-1;iLLoop++){
				var SelRowObj=document.getElementById('TPatName'+'z'+iLLoop);
				if (SelRowObj && ""==trim(SelRowObj.innerText)) {
					var obj=document.getElementById("TDiagnoseConclus"+'z'+iLLoop);
					if (obj) { Llabel=obj.innerText }
					var obj=document.getElementById("TDiagnosisCount"+'z'+iLLoop);
					if (obj) { Lvalue=obj.value }
					alert(Llabel+':  :'+Lvalue)
					//if (''!=Lvalue) {
						mywin.addChartValue(Lvalue, Llabel, true);
						//Llabel='';
						//Lvalue='';
					//}
				}
			}
			iLLoop=table.rows.length-1;
			var SelRowObj=document.getElementById('TPatName'+'z'+iLLoop);
			if (SelRowObj && ""==trim(SelRowObj.innerText)) {
				var obj=document.getElementById("TDiagnoseConclus"+'z'+iLLoop);
				if (obj) { Llabel=obj.innerText }
				var obj=document.getElementById("TDiagnosisCount"+'z'+iLLoop);
				if (obj) { Lvalue=obj.value }
				alert(Llabel+' a '+Lvalue)
					//if (''!=Lvalue) {
						mywin.addChartValue(Lvalue, Llabel, false);
						//Llabel='';
						//Lvalue='';
					//}
			}	   	
 		}
	
	}

}

*/

function Import_click() {
	var obj;
	
	var SaveFilePath='';

	obj=document.getElementById("ImportSavePath")
	if (obj && ""!=obj.value) { SaveFilePath=obj.value; }
	IllnessCollectImport(SaveFilePath); // DHCPEIllnessCollectImport.js

}

function ShowImage_click() {
	var lnk='dhcpediagnosisstatistic.chart.csp';
	var wwidth=630;
	var wheight=440; 
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes'
			+',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	mywin=window.open(lnk,"_blank",nwin)	

	if (mywin){
 		excall = function(){
	 		var Llabel,Lvalue;
	 		
			for(var iLLoop=0;iLLoop<DSlabel.length-1;iLLoop++){
					Llabel=DSlabel[iLLoop];
					Lvalue=DSvalue[iLLoop];
					//alert(Llabel+":  :"+Lvalue);
					mywin.addChartValue(Lvalue, Llabel, true);
			}
			iLLoop=DSlabel.length-1;
			Llabel=DSlabel[iLLoop];
			Lvalue=DSvalue[iLLoop];
			//alert(Llabel+":  :"+Lvalue);
			mywin.addChartValue(Lvalue, Llabel, false);	
 		}
	}
}

document.body.onload = BodyLoadHandler;