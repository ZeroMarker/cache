/**
 * @description 
 * @name nur.hisui.nurseplanexport.js
 */ 
var GV = {
    _CALSSNAME: "Nur.NIS.Service.NursingPlan.NursePlanExport",
    episodeID: "",
};
var init = function () {
	InitHospList();	
    initPageDom();
    initBindEvent();
    
}
$(init)
function initPageDom() {
	initCondition();	
    initStatistics();	
}
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_Question");
	hospComp.jdata.options.onSelect = function(e,t){
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
	}
}
function initBindEvent() {
	$('#findBtn').bind('click', initStatistics); 
	// 导出 Export
	$("#Export").click(function(){
		// 借助插件-datagrid-export.js 实现导出excel功能
		var hospdesc=$HUI.combogrid('#_HospList').getText();
		var type=$("#FindType").combobox("getValue");
		if (type=="Question"){
			$('#NursePlanGrid').datagrid('toExcel',hospdesc+'护理问题.xls')
		}else if (type=="QLGoal"){
			$('#NursePlanGrid').datagrid('toExcel',hospdesc+'护理问题对目标.xls')
		}else if (type=="QLIntervention"){
			$('#NursePlanGrid').datagrid('toExcel',hospdesc+'护理问题对措施.xls')
		}else if (type=="QlAssess"){
			$('#NursePlanGrid').datagrid('toExcel',hospdesc+'护理问题对评估.xls')
		}
	});
}
function initCondition() {
	var defaultValue = "Question"
    $('#FindType').combobox({
	    mode:'remote',
        url: $URL + '?1=1&ClassName=' + GV._CALSSNAME + '&QueryName=NurseFindType&desc=&ResultSetType=array',
        valueField: 'TypeCode',
        textField: 'TypeDesc',
        multiple:false,
        rowStyle:'checkbox', //显示成勾选行形式
        value:defaultValue,
        onLoadSuccess: function () {	       
	    }
    })
}
function initStatistics() {
	var JsonCol = "";
	var type=$("#FindType").combobox("getValue")	
	JsonCol = tkMakeServerCall(
	  "Nur.NIS.Service.NursingPlan.NursePlanExport",
	  "getNurPlanExportCol",
	  type
	);
	var ColOBJECT = $.parseJSON(JsonCol);
	var defaultPageSize = 25;
    var defaultPageList = [25, 50, 100, 200, 500];
    $('#NursePlanGrid').datagrid({
        url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.NursePlanExport&MethodName=getNursePlanExportData",
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		pageSize: defaultPageSize,
		pageList: defaultPageList,
        columns:ColOBJECT,
		//idField: 'QuelocID',
		singleSelect:true,
		remoteSort: false,
		onBeforeLoad:function(param){
			var type=$("#FindType").combobox("getValue")
			param = $.extend(param,{
				type:type,
				hospId:$HUI.combogrid('#_HospList').getValue(),
			});
		},
		onLoadSuccess:function(data){
			if (type=="QlAssess"){
				$("#NursePlanGrid").datagrid("getColumnOption", "questionDescs").formatter=function(questionIds,row,index){
					if ((row.questionDescs)&&(row.questionDescs.length>0)){
						return row.questionDescs.join(",");
					}else{						
						return $.parseJSON(row.questionDescs).join("");
					}
				}
				
			}
		}
    });			

}



