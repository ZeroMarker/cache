if (websys_isIE==true) {
     var script = document.createElement('script');
     script.type = 'text/javaScript';
     script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird 文件地址
     document.getElementsByTagName('head')[0].appendChild(script);
}
$(document).ready(function(){
	Init();
	workList_AssListObj.CureAssessmentDataGridLoad();
})

function Init(){
	workList_AssListObj.InitCureAssessmentDataGrid();	
}