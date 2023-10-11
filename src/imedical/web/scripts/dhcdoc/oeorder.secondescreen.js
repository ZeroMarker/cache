$(document).ready(function(){
	//iframe赋值链接页面
	//frames['OrderInfo'].src = "dhc.orderdetailview.csp?ord="+ServerObj.OrderId+"&MWToken="+websys_getMWToken();
	frames['OrderView'].src = "dhc.orderview.csp?ord="+ServerObj.OrderId+"&MWToken="+websys_getMWToken();
	//frames['OrdView'].location.href = "dhc.orderview.csp?ord="+ServerObj.OrderId;	
	$("#CPanel").panel('close');   
	$("#APanel").panel('close');   
	if (ServerObj.DCARowId!=""){
		//治疗申请
		var src = "doccure.apply.update.hui.csp?DCARowId="+ServerObj.DCARowId+"&EpisodeID="+ServerObj.EpisodeID+"&MWToken="+websys_getMWToken();
		var frame='<iframe id="iOrderOther" name="iOrdOther" src='+src+' width="100%" min-height="500px" height="100%" frameborder="0"></iframe>'
		Initframe(frame,"治疗申请信息");
	}
	if (ServerObj.OrderType=="L"){
		//检验报告
		var frame='<table id="lisOrdDetailTable"></table>'
		Initframe(frame,"检验报告");
		LabReportObj.InitLabReportDataGrid();
	}else if (ServerObj.ExamPortUrl!=""){
		//检查报告
		var Src=ServerObj.ExamPortUrl+"&MWToken="+websys_getMWToken()
		var frame='<iframe id="iOrderOther" name="iOrdOther" src='+Src+' width="100%" min-height="500px" height="100%" frameborder="0"></iframe>'
		Initframe(frame,"检查报告");
		$("#CPanel").panel({height:"800",maximizable:true})		
	}else if (ServerObj.PisPortUrl!=""){
		//病理报告
		var Src=ServerObj.PisPortUrl+"&MWToken="+websys_getMWToken()
		var frame='<iframe id="iOrderOther" name="iOrdOther" src='+Src+' width="100%" min-height="500px" height="100%" frameborder="0"></iframe>'
		Initframe(frame,"病理报告");
		$("#CPanel").panel({maximizable:true})		
	}
	$("#mainPanel").layout('resize'); 
})

$(function(){

})

function Initframe(count,title){
	$("#CPanel").panel('open').panel("setTitle",title).panel("resize",{height: 600});
	$('#CPanel').empty().append(count);
	return;
}

var LabReportObj=(function(){
	function InitLabReportDataGrid(){
		var showType=0; //0/1:全部/异常
		var columns=[[
	    	{ field: 'Synonym',align: 'center', title: '缩写',width:45},
	        { field: 'TestCodeName',align: 'center', title: '项目名称',width:60},
	        { field: 'Result',align: 'center', title: '结果',styler:stylerResult,width:45},
			{ field: 'ExtraRes',align: 'center', title: '扩展结果'},
			{ field: 'AbFlag',align: 'center', title: '异常提示',width:45,styler: stylerAbFlag},
			{ field: 'HelpDisInfo',align: 'center', title: '辅助诊断',width:65,formatter: formatterHelpDisInfo},
			{ field: 'Units',align: 'center', title: '单位'},
			{ field: 'RefRanges',align: 'center', title: '参考范围',width:49},
			{ field: 'PreResult',align: 'center', title: '历次',width:35,formatter:HistoryIconPrompt,styler: stylerPreRs}, 
			{ field: 'PreAbFlag', align: 'center',title: '前次异常提示',hidden: true},
			{ field: 'ResNoes',align: 'center', title: '结果说明'}
	 	]]; 

	 	$HUI.datagrid('#lisOrdDetailTable',{
			url:LINK_CSP+"?ClassName=web.DHCAPPSeePatLis&MethodName=JsonQryTSInfo",
			queryParams:{
				ReportDR:ServerObj.VisitNumberReportId,
				showType:showType 
			},
			fit:true,
			rownumbers:false,
			columns:columns,
			fitColumns:true,
			nowrap:false,
			pageSize:10,  
			pageList:[10,15,20], 
		    pagination:false,
		    singleSelect:true,
			loadMsg: $g('正在加载信息...'),
			onLoadSuccess: function (data) {
		        LabReportObj.ShowDrugAllergy(data);   //显示药敏检验结果内容
	        }
		});	
	}
	function stylerResult(value, row, index){
		var colStyle="color:black";
	    if (value!="") {
	        if (!isNaN(value)) {
	            if (row.AbFlag == "L") { colStyle = "color:blue"};
	            if (row.AbFlag == "H") { colStyle = "color:red"};
	            if (row.AbFlag == "PL") { colStyle = "background-color:red;color:blue"};
	            if (row.AbFlag == "PH") { colStyle = "background-color:red;color:#ffee00"};
	            if (row.AbFlag == "UL") { colStyle = "background-color:red;color:blue"};
	            if (row.AbFlag == "UH") { colStyle = "background-color:red;color:#ffee00" };
	            if (row.AbFlag == "S") { colStyle = "background-color:red;color:#ffee00"};
	        }
	    } 
	    return colStyle;	
	}
	function stylerAbFlag(value, row, index) {
		 var colStyle="color:black";
		 if (value) {  
		    if (value.trim() == "L") { colStyle = "color:blue"};
		    if (value.trim() == "H") { colStyle = "color:red"};
		    if (value.trim() == "A") { colStyle = 'color:red;' };
		    if (value.trim() == "PL") { colStyle = "background-color:red;color:blue"};
		    if (value.trim() == "PH") { colStyle = "background-color:red;color:#ffee00"};
		    if (value.trim() == "UL") { colStyle = "background-color:red;color:blue"};
		    if (value.trim() == "UH") { colStyle = "background-color:red;color:#ffee00"};
		    if (value.trim() == "S") { colStyle = "background-color:red;color:#ffee00"};
		 }
		return colStyle;
	}
	function stylerPreRs(value, row, index) {
	    var colStyle="color:black";
	    if (value != "") {
	        if (!isNaN(value)) {  
	            if (row.PreAbFlag == "L") { colStyle = "color:blue"};
	    		if (row.PreAbFlag == "H") { colStyle = "color:red"};
	   			if (row.PreAbFlag == "PL") { colStyle = "background-color:red;color:blue" };
	    		if (row.PreAbFlag == "PH") { colStyle = "background-color:red;color:#ffee00" };
	    		if (row.PreAbFlag == "UL") { colStyle = "background-color:red;color:blue"};
	   			if (row.PreAbFlag == "UH") { colStyle = "background-color:red;color:#ffee00"};                 
	        }
	    
	    }
	    return colStyle;
	}
	function formatterHelpDisInfo(value, row, index){
		value = value.replace(/\!/g,"\n\n");
		value = value.replace(/\@/g,"\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
		value = value.replace(/\^/g,"\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
		var rs=""
		if(value!=""){
			rs=$g("辅助");
		}
		var btn = '<a href="#" id ="HelpDis'+row.TestCodeDR +'"title="'+value+'" class="hisui-tooltip" onmouseover="HelpDisInfoonmouse(\'' + row.TestCodeDR+ '\') " ">'+rs+'</a>';
		return btn;
	}
	///显示药敏检验内容
    function ShowDrugAllergy(data) {
        var data = data["rows"];
        var TSNames = {};
        //菌落计数
        var ClonyNum = {};
        //菌落形态
        var ClonyForms = {};
        //备注
        var ResNoes = {};
        for (var i = 0; i < data.length; i++) {
            var dataItm = data[i];
            if (dataItm["ResultFormat"] == "M" && dataItm["Result"].length > 0) {
                TSNames[dataItm["ReportResultDR"]] = dataItm["Result"];
                ClonyForms[dataItm["ReportResultDR"]] = dataItm["ClonyForm"];
                ClonyNum[dataItm["ReportResultDR"]] = dataItm["ClonyNum"];
                ResNoes[dataItm["ReportResultDR"]] = dataItm["ResNoes"];
                //查询药敏结果
                $.ajax({
                    url: 'jquery.easyui.dhclabclassjson.csp',
                    async: false,
                    data: {
                        ClassName: "web.DHCENS.STBLL.Method.PostReportInfo",
                        QueryName: "QryReportResultSen",
                        FunModul: "JSON",
                        P0: dataItm["ReportResultDR"]
                    },
                    success: function(retData) {
                        var htmlStr = "";
                        retData = jQuery.parseJSON(retData)
                        if (retData["rows"] != undefined && retData["rows"].length > 0) {
                            htmlStr += "<table style='font-size:12px;padding-top:10;width:430'>";
                            htmlStr += "<tr><td colspan='5'><span style='color:red;font-weight:bold'>" + TSNames[retData["rows"][0]["VisitNumberReportResultDR"]]
                            if (ClonyNum[retData["rows"][0]["VisitNumberReportResultDR"]] != undefined && ClonyNum[retData["rows"][0]["VisitNumberReportResultDR"]].length > 0)
                                htmlStr += "</span>----<span style='font-weight:bold'>" + $g("菌落计数：") + "</span>" + ClonyNum[retData["rows"][0]["VisitNumberReportResultDR"]];
                            if (ClonyForms[retData["rows"][0]["VisitNumberReportResultDR"]] != undefined && ClonyForms[retData["rows"][0]["VisitNumberReportResultDR"]].length > 0)
                                htmlStr += "</span>----<span style='font-weight:bold'>" + $g("菌落形态：") + "</span>" + ClonyForms[retData["rows"][0]["VisitNumberReportResultDR"]];
                            htmlStr += "</td></tr>";
                            if (ResNoes[retData["rows"][0]["VisitNumberReportResultDR"]] != undefined && ResNoes[retData["rows"][0]["VisitNumberReportResultDR"]].length > 0)
                                htmlStr += "<tr><td colspan='5'><span style='font-weight:bold'>" + $g("备注：") + "</span>" + ResNoes[retData["rows"][0]["VisitNumberReportResultDR"]] + "</td></tr>";
                            htmlStr += "<tr style='font-weight:bold'>";
                            htmlStr += "<td>" + $g("抗生素名称") + "</td>";
                            htmlStr += "<td>" + $g("缩写") + "</td>";
                            htmlStr += "<td>KB(mm)</td>";
                            htmlStr += "<td>MIC(ug/ml)</td>";
                            htmlStr += "<td>" + $g("结果") + "</td>";
                            htmlStr += "</tr>";
                            var kb = ""
                            var mic = ""
                            for (var index = 0; index < retData["rows"].length; index++) {
                                htmlStr += "<tr>";
                                htmlStr += "<td>" + retData["rows"][index]["AntibioticsName"] + "</td>";
                                htmlStr += "<td>" + retData["rows"][index]["SName"] + "</td>";

                                if (retData["rows"][index]["SenMethod"] == "KB") {
                                    kb = retData["rows"][index]["SenValue"];
                                    mic = "&nbsp"
                                } else {
                                    mic = retData["rows"][index]["SenValue"];
                                    kb = "&nbsp";
                                }
                                htmlStr += "<td>" + kb + "</td>";
                                htmlStr += "<td>" + mic + "</td>";
                                htmlStr += "<td>" + retData["rows"][index]["SensitivityName"] + "</td>";
                                htmlStr += "</tr>";
                            }
                            htmlStr += "</table>";
                            $('#lisOrdDetailTable').prev().children(".datagrid-body").append(htmlStr);

                        }
                    }
                })
                //查询耐药机制结果
                $.ajax({
                    url: 'jquery.easyui.dhclabclassjson.csp',
                    async: false,
                    data: {
                        ClassName: "LIS.WS.BLL.DHCRPMicNumberReport",
                        QueryName: "QryReportResultRst",
                        FunModul: "JSON",
                        P0: dataItm["ReportResultDR"]
                    },
                    success: function(retData) {
                        var htmlStr = "";
                        try {
                            retData = jQuery.parseJSON(retData)
                        } catch (e) {
                            return;
                        }
                        if (retData["rows"] != undefined && retData["rows"].length > 0) {
                            htmlStr += "<table style='font-size:12px;padding-top:10;width:430'>";
                            htmlStr += "<tr><td><b>" + $g("耐药机制") + "</b></td></tr>";
                            for (var index = 0; index < retData["rows"].length; index++) {
                                htmlStr += "<tr>";
                                htmlStr += "<td>" + retData["rows"][index]["ResistanceItemName"] + "</td>";
                                var resItem = jQuery.parseJSON(retData["rows"][index]["ResItem"]);
                                var result = retData["rows"][index]["Result"];
                                if (resItem.length > 0) {
                                    for (var i = 0; i < resItem.length; i++) {
                                        if (resItem[i].id == result) {
                                            result = resItem[i].text;
                                            break;
                                        }
                                    }
                                }
                                htmlStr += "<td>" + result + "</td>";
                                htmlStr += "</tr>";
                            }
                            htmlStr += "</table>";
                            $('#lisOrdDetailTable').prev().children(".datagrid-body").append(htmlStr);
                        }
                    }
                })
            }
        }
    }
	///历史结果图标
	function HistoryIconPrompt(value, rowData, rowIndex) {
	   var retHtml = "";
	   var iconHtml ="",inconUrl="../scripts/dhcnewpro/images/curve-chart1.png";
	   iconHtml = '<IMG align="top" style="width:16px;float:right;" SRC=\"'+inconUrl+'\" title="" border=0/>';
	   if (value != "" && rowData.TestCodeName != $g("备注")) {
		    if (rowData.ResultFormat == "N"){
	       		retHtml ="<a style='text-decoration:none;' href=\"javascript:void(LabReportObj.ShowHistoryResult('"+ServerObj.VisitNumberReportId+"','"+rowData.TestCodeDR+"'));\">"+value+iconHtml+"</a>";
		    }else{ 
	       		retHtml=value
		    }
	    }
	    return retHtml;
	}
	/////结果曲线图
	function ShowHistoryResult(VisitNumberReportDR,TestCodeDR) {
		window.open ('dhcapp.rscurve.csp?VisitNumberReportDR='+VisitNumberReportDR+'&TestCodeDR='+TestCodeDR, "newwindow", "height=450, width=650, toolbar =no,top=100,left=300,, menubar=no, scrollbars=no, resizable=no, location=no, status=no") ;
		return false;
	}
	
	return {
		"InitLabReportDataGrid":InitLabReportDataGrid,
		"ShowHistoryResult":ShowHistoryResult,
		"ShowDrugAllergy":ShowDrugAllergy
	}
	
})()

