var PatientID="",showRstTable=""

//页面加载
var me = {
	VisitNumberReportDR:"",
	ConnectString:""	
}
$(function(){
	//取到病人的ID值
	GetPatId();
	//初始化界面
	initTable();
	//给界面绑定方法
	bindMethod();
	//初始化combobox
	ShowAdmList();
	
	
})


//显示就诊列表,初始化下拉框,通过病人列表
function ShowAdmList() { //ssss
    //这个方法是用来初始化combobox的
	 $.ajax({
		url:'dhcapp.broker.csp',
		data:{
			"ClassName":"web.DHCEMPatCheOutNew",
	        "MethodName":"getAdmList",
			//P0:PatientID    正确
			"PatientID":PatientID
		},
		type:"get",
		success:function(data) {
			//alert(data);
			var admArray = data.split("^");
			var cbArray= [{"id":"-1","text":"全部就诊"}];
			for (var i in admArray) {
				if (admArray[i].length > 10) {
					var id = admArray[i].split(",")[0];
					var name = admArray[i].replace(id+",","");
					cbArray.push({"id":id,"text":name});
				}
			}
			$("#diagnose_combobox").dhccSelect({
   				data:cbArray 
			});
			$('#diagnose_combobox').val(EpisodeID);
			$('#diagnose_combobox').trigger('change');
		} 
	 })
}



//报告结果查看
function ShowReportResult() {
	 
	 $('#ResultArr').dhccQuery(
	 {
		query:{
			ClassName:"web.DHCEMPatCheOutNew",
	   	 	MethodName:"QryTSInfo",
			ReportDR:me.VisitNumberReportDR
		}
	 })
	
};

//报告打印浏览
function printViewClick() {
	//var checkedRows =  $('#dgOrdItmList').datagrid("getChecked");
	var checkedRows = $('#sampleArr').dhccTableM('getSelections');
	var reportDRs = "";
	for (var i in checkedRows) {
		if (checkedRows[i].ResultStatus!= "3") {
			$.messager.alert('操作提示','报告'+checkedRows[i].OrdItemName+"未出报告，不能打印！");
			return;
		}
		if (reportDRs.length > 0)
			reportDRs = reportDRs+"^"+checkedRows[i].VisitNumberReportDR;
		else 
			reportDRs = checkedRows[i].VisitNumberReportDR
	}
	
	param="DOCTOR"
	connectString=me.ConnectString
	var UserParam=UserId + "^" + HospID
    if (reportDRs) objPrintPreview.PrintPreview(reportDRs, UserParam, param, connectString);  
}

//点击查询按钮
var findOrdItmList = function (){
	var AuthFlag = 0;
	if (document.getElementById("selectAuthedReport").checked) {
		AuthFlag = 1;
	}
	//alert(AuthFlag);
	var PrintFlag = "Y";
	if (document.getElementById("selectPrintReport").checked) {
		PrintFlag = "N";
	}
	//alert(PrintFlag);
	var ReadFlag = 0;
	if (document.getElementById("selectReadedCb").checked) {
		ReadFlag = 1;
	} 
	//alert(ReadFlag);
	var SttDate = $('#startDateText').val();
    var EndDate = $('#endDateText').val();   
    var admNo = $("#diagnose_combobox").val();
    if (admNo!="") {
	    EpisodeID = admNo;
    }
    
    
    //alert(EpisodeID+"^"+PatientID+"^"+EndDate+"^"+AuthFlag+"^"+UserId+"^"+ReadFlag+"^"+PrintFlag);
     $('#sampleArr').dhccQuery(
	 {
		query:{
			"ClassName":"web.DHCEMPatCheOutNew",
	        "MethodName":"OrderList",
			"EpisodeID":EpisodeID,
			"PatientID":PatientID,
			"FromDate":SttDate,
			"ToDate":EndDate,  //ToDate:"",
			"LocCode":"",  //LocCode:"",
			"AuthFlag":AuthFlag,  //AuthFlag:"",
			"AllTS":"",  //AllTS:"",
			"AdmDateFlag":"",  //AdmDateFlag:""
			"UserId":UserId, //登录用户ID
			"fReadFlag":ReadFlag,   //ReadFlag
			"fRegNo":"",	 //RegNo
			"fLocationDR":"",  //LocationDR
			"fWardDR":"",  //WardDR
			"fPrintFlag":PrintFlag  //PrintFlag
		}
	 })

}

//初始化Table
function initTable(){
	//时间的输入框
	$('#startDate').dhccDate();
	$('#endDate').dhccDate();
	$('#endDate').setDate(new Date().Format("yyyy-MM-dd"));
	//标本列表,左侧Table
	var columns=[ 
        	{ field: 'chkReportList', checkbox: true },
        	//{ field: 'ID', title: 'ID'},
            { field: 'LabEpisode', title: '检验号',align:'center'},
            { field: 'OrdItemName', title: '医嘱名称',align:'center',width:300},
            { field: 'ResultStatus', title: '结果状态',formatter: ResultIconPrompt},
            { field: 'PrintFlag', title: '打印',
        	formatter: function (value, rowData, rowIndex) {
                          if(value=="Y")
                          {
	                          return '<span class="" title="已打印">&nbsp&nbsp&nbsp&nbsp&nbsp</span>';
                          }
                          else if(value=="N")
                          {
	                          return '';
                          }
                      }
          	},
            { field: 'ReadFlag', title: '阅读',
            formatter: function(value, rowData, rowIndex){
	          	if (rowData.ResultStatus != "3")
	          		return "";
	        	if (value == "1") {
		        	return "<span class='' color='red' title='已阅读')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp已阅读</span>";
	        	}
	        	else {
		        	return "<span class='' color='red' title='未阅读')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp未阅读</span>";
	        	}   	
	        } 
	        },
            { field: 'AuthDateTime', title: '报告日期'},
            { field: 'RecDateTime', title: '接收日期'},
            { field: 'SpecDateTime', title: '采集日期'},
            { field: 'ReqDateTime', title: '申请日期'},
            { field: 'WarnComm', title: '危机提示'},
            { field: 'TSMemo', title: '标本提示'},
            { field: 'ViewResultChart', title: '历史'},
            { field: 'PreReport', title: '预报告'}
            //{ field: 'VisitNumberReportDR', title: 'VisitNumberReportDR'},
            //{ field: 'OEOrdItemID', title: 'OEOrdItemID'}
            ];
	//alert(EpisodeID);
	//标本列表
	//alert(EpisodeID+":"+PatientID);

	$('#sampleArr').dhccTable({
	    height:435,
	    pageSize:10,
	    pageList:[10,15,20],
        url:"dhcapp.broker.csp",
        columns:columns,
        singleSelect:true,
        queryParam: {
	        ClassName:"web.DHCEMPatCheOutNew",
	        MethodName:"OrderList", 
			EpisodeID:EpisodeID,
			PatientID:PatientID,
			FromDate:"", 
			ToDate:"",  //ToDate:"", 
			LocCode:"",  //LocCode:"", 
			AuthFlag:"",  //AuthFlag:"", 
			AllTS:"",  //AllTS:"", 
			AdmDateFlag:"",  //AdmDateFlag:""
			UserId:UserId, //登录用户ID
			fReadFlag:"",   //ReadFlag
			fRegNo:"",	 //RegNo
			fLocationDR:"",  //LocationDR
			fWardDR:"",  //WardDR
			fPrintFlag:""  //PrintFlag
		},
		
        onLoadSuccess:function(data){
	       $('#ResultArr').dhccTableM("removeAll");  //清除表格数据
	    }
		
	})
	
	
	//报告结果，右边Table
	var  colums = [[
              { field: 'TestCodeDR', title: '项目id'},
              { field: 'Synonym', title: '缩写'},
              { field: 'TestCodeName', title: '项目名称'},
              { field: 'Result', title: '结果',
	              cellStyle: function (value, row, index, field) {
		            var colStyle={"color":"black"};
		            if(value!="") {
		             if (!isNaN(value)) {   ///数字类型
	                    if (row.AbFlag == "L") { colStyle = {"color":"blue"}};
	                    if (row.AbFlag == "H") { colStyle = {"color":"red"}};
	                    if (row.AbFlag == "PL") { colStyle = {"background-color":"red","color":"blue"} };
	                    if (row.AbFlag == "PH") { colStyle = {"background-color":"red","color":"#ffee00"} };
	                    if (row.AbFlag == "UL") { colStyle = {"background-color":"red","color":"blue"}};
	                    if (row.AbFlag == "UH") { colStyle = {"background-color":"red","color":"#ffee00"} };
		             }
		            } 
	                return {
				   		css: colStyle
				 	};
                },formatter: function (value, rowData, rowIndex) {
                          if(rowData.ResultFormat=="M")
                          {
	                          return '<a href="#" onClick="ShowMicReport(\''+rowData.TestCodeDR+'\');">'+value+'</a>';
                          }
                          else
                          {
	                          return value;
                          }
                      }
	              
               },
 	          { field: 'ExtraRes', title: '结果提示'},
              { field: 'AbFlag', title: '异常提示',
                  cellStyle: function (value, row, index) {
		             var colStyle={"color":"black"};
		             if (value) {  
	                    if (value.trim() == "L") { colStyle = {"color":"blue"}};
	                    if (value.trim() == "H") { colStyle = {"color":"red"}};
	                    if (value.trim() == "PL") { colStyle = {"background-color":"red","color":"blue"} };
	                    if (value.trim() == "PH") { colStyle = {"background-color":"red","color":"#ffee00"} };
	                    if (value.trim() == "UL") { colStyle = {"background-color":"red","color":"blue"}};
	                    if (value.trim() == "UH") { colStyle = {"background-color":"red","color":"#ffee00"} };
		             }
	                return {
				   		css: colStyle
				 	};
                  }
                },
              { field: 'Units', title: '单位'},
              { field: 'RefRanges', title: '参考范围'},
              { field: 'PreResult', title: '前次结果',formatter:HistoryIconPrompt,
               	    cellStyle: function (value, row, index) {
	  
                       var colStyle={"color":"black"};
                        if (value != "") {
                            if (!isNaN(value)) {   ///数字类型
                                if (row.PreAbFlag == "L") { colStyle = {"color":"blue"}};
	                    		if (row.PreAbFlag == "H") { colStyle = {"color":"red"}};
	                   			if (row.PreAbFlag == "PL") { colStyle = {"background-color":"red","color":"blue"} };
	                    		if (row.PreAbFlag == "PH") { colStyle = {"background-color":"red","color":"#ffee00"} };
	                    		if (row.PreAbFlag == "UL") { colStyle = {"background-color":"red","color":"blue"}};
	                   			if (row.PreAbFlag == "UH") { colStyle = {"background-color":"red","color":"#ffee00"} };                 
                            }
                        
                        }
                        return {
				   			css: colStyle
				 		};
                    }
              }, 
              { field: 'PreAbFlag', title: '前次异常提示',hidden: true},
              //{ field: 'ResClass', title: '危急提示',hidden:true},
              { field: 'ClinicalSignifyS', title: '临床意义'}
            ]];
	
	
	//报告结果
	$('#ResultArr').dhccTable({
        height:433,
        url:'dhcapp.broker.csp',
        columns: colums,
        singleSelect: true,
		queryParam: { 
			ClassName:"web.DHCEMPatCheOutNew",
	        MethodName:"QryTSInfo",
			ReportDR:me.VisitNumberReportDR 			
		}
    });
    
    
    ///获取报告打印数据库连接
	var ID="1";
	runClassMethod("DHCLIS.DHCOrderList","GetConnectString",{"ID":ID},
		function (rtn){
			if (rtn != "") {
				me.ConnectString=rtn;
			}
		},"text"
	)
}

function bindMethod(){
	// 选中一行触发的方法
	$('#sampleArr').on('click-row.bs.table', function (e, row, $element) {
		me.VisitNumberReportDR = row.VisitNumberReportDR;
		ShowReportResult();     //右侧表格加载
	});
	
	//查找按钮的绑定事件
	$('#selBtn').on('click',findOrdItmList);	 //sss
	$('#priRepBtn').on('click',printOutClick);
	$('#priViewBtn').on('click',printViewClick)

	$('#diagnose_combobox').on('select2:select', function (evt) {
		findOrdItmList();	
	}); 
	//操作就查询
	$("#selectAuthedReport").change(function () {
         findOrdItmList();
    });
    //操作就查询
    $("#selectPrintReport").change(function () {
         findOrdItmList();
    });
    //操作就查询
    $("#selectReadedCb").change(function () {
         findOrdItmList();
    });	
}
		
//微生物报告浏览
function ShowMicReport(TestCodeDR) {
	
	option={
		title:'微生物报告',
		type: 2,
		shadeClose: true,
		shade: 0.8,
		area: ['950px','500px'],
		content: "http://172.21.21.78/iMedicalLIS/facade/ui/frmMicReporstPrint.aspx?reportDRs="+me.VisitNumberReportDR+"&TestCodeDR="+TestCodeDR
	}
	window.parent.layer.open(option);
	return false;
}
	
///历史结果图标
function HistoryIconPrompt(value, rowData, rowIndex) {
    var a = [];
    if (value != "" && rowData.TestCodeName != "备注") {
        if (rowData.ResultFormat == "N")
       		a.push(value + "&nbsp;<a style='text-decoration:none;' href=\"javascript:void(ShowHistoryResult('",  me.VisitNumberReportDR,"','",rowData.TestCodeDR, "'));\"><span class='icon-chart_curve' title='结果曲线图'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;");
       	else 
       		a.push(value);
    }else{
       		a.push(value + "&nbsp;<a style='text-decoration:none;' href=\"javascript:void(ShowHistoryResult('",  me.VisitNumberReportDR,"','",rowData.TestCodeDR, "'));\"><span class='' title='结果曲线图'>&nbsp;&nbsp;&nbsp;&nbsp;历次结果</span></a>&nbsp;");
	    }
    return a.join("");
}


//结果图标显示
function ResultIconPrompt(value, rowData, rowIndex) {
	///(1登记，2初审，3审核，4复查，5取消审核，6作废，O其他)
	  event.stopPropagation();
      if (value == "3") {
	    var paramList=rowData.VisitNumberReportDR;
	    if (rowData.TSResultAnomaly == "3") {
        	return "<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(" + paramList + "))';><span class='' color='red' title='荒诞结果')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>报告结果</a>";
	    }
	    if (rowData.TSResultAnomaly == "2") {
        	return "<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(" + paramList + "))';><span class='' color='red' title='危机值结果')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>报告结果</a>";
	    }
	    if (rowData.TSResultAnomaly == "1") {
        	return "<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(" + paramList + "))';><span class='' color='red' title='异常结果')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>报告结果</a>";
	    }
	    if (rowData.TSResultAnomaly == "0") {
        	return "<a style='text-decoration:none;' href='javascript:void(ReportView(" + paramList + "))';><span class='' color='red' title='报告结果')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>报告结果</a>";
		}
    }
   
	    
    
}


//报告浏览
function ReportView(VisitNumberReportDR) {
	
	//alert(VisitNumberReportDR);
	option={
		title:'报告结果',
  		type: 2,
  		shadeClose: true,
  		shade: 0.8,
  		area: ['950px','500px'],
  		content: 'jquery.easyui.dhclabreport.csp?VisitNumberReportDR='+VisitNumberReportDR
	}
	window.parent.layer.open(option);
	return false;
}


//报告打印
function printOutClick() {
	alert("报告打印");
	var checkedRows = $('#sampleArr').dhccTableM('getSelections');
	var reportDRs = "";
	var rowIndexArray = [];
	for (var i in checkedRows) {
		alert(i+":"+checkedRows[i].ResultStatus);
		if (checkedRows[i].ResultStatus != "3") {
			alert(checkedRows[i].OrdItemName);
			$.messager.alert('操作提示','报告'+checkedRows[i].OrdItemName+"未出报告，不能打印！");
			return;
		}
		alert("aaaa");
		if (reportDRs.length > 0) {
			reportDRs = reportDRs+"^"+checkedRows[i].VisitNumberReportDR;
		}
		else 
			reportDRs = checkedRows[i].VisitNumberReportDR;
		var rowIndex =  checkedRows[i].ID;
		rowIndexArray.push(rowIndex);
	}
	param="DOCTOR"
	connectString=me.ConnectString
	var UserParam=UserId + "^" + HospID
    if (reportDRs) objPrintPreview.PrintOut(reportDRs, UserParam, param, connectString);   //引入打印的dll
    //更新打印标识
    for (var i = 0; i < rowIndexArray.length; i++) {
		
		$('#sampleArr').dhccTableM('updateRow', {  
			    index: rowIndexArray[i],  
			    row: {  
			            PrintFlag:'Y'
			    }  
		    });  
		
		//$('#dgOrdItmList').datagrid('uncheckRow', rowIndexArray[i]);
    }
}

//报告打印
function printOutClick() {
	var checkedRows =  $('#dgOrdItmList').datagrid("getChecked");
	var reportDRs = "";
	var rowIndexArray = [];
	for (var i in checkedRows) {
		if (checkedRows[i]["ResultStatus"] != "3") {
			$.messager.alert('操作提示','报告'+checkedRows[i]["OrdItemName"]+"未出报告，不能打印！");
			return;
		}
		if (reportDRs.length > 0) {
			reportDRs = reportDRs+"^"+checkedRows[i]["VisitNumberReportDR"];
		}
		else 
			reportDRs = checkedRows[i]["VisitNumberReportDR"];
		var rowIndex  = $('#dgOrdItmList').datagrid("getRowIndex", checkedRows[i]);
		rowIndexArray.push(rowIndex);
	}
	
	param="DOCTOR"
	connectString=me.ConnectString
	var UserParam=UserId + "^" + HospID
    if (reportDRs) objPrintPreview.PrintOut(reportDRs, UserParam, param, connectString);  
    //更新打印标识
    for (var i = 0; i < rowIndexArray.length; i++) {
    	$('#dgOrdItmList').datagrid('updateRow',{
			index: rowIndexArray[i],
			row: {
				PrintFlag:'Y'
			}
		});
		$('#dgOrdItmList').datagrid('uncheckRow', rowIndexArray[i]);
    }
}

//同通过就诊ID获取病人的ID
function  GetPatId(){
	PatientID=MyRunClassMethod("web.DHCEMPatCheOutNew","GetPatIdByEpisodeID",{"EpisodeID":EpisodeID})
}//GetPatId end


/////结果曲线图
function ShowHistoryResult(VisitNumberReportDR,TestCodeDR) {
	option={
		title:'结果曲线图',
  		type: 2,
  		shadeClose: true,
  		shade: 0.8,
  		area: ['950px','500px'],
  		content: 'dhcem.cheouthistoryresult.csp?VisitNumberReportDR='+VisitNumberReportDR+'&TestCodeDR='+TestCodeDR
	}
	window.parent.layer.open(option);
	return false;
}
function hsrTable(){

	if(!showRstTable){
		hideTable();
		return;
	}
	if(showRstTable){
		showTable();
		return;
		}
		
}
function hideTable(){

	$('#sampleArrDiv').animate({
		width:"67%"
		},200);
	$('#ResultArrDivOne,#ResultArrDivTwo').animate({
		width:"3%"
	},200,function(){
		$('#ResultArrDiv').find(".bootstrap-table").hide();
	});
	showRstTable=1;
}

function showTable(){
	$('#sampleArrDiv,#ResultArrDivOne').animate({
		width:"49%"
		},200);
	$('#ResultArrDivTwo').animate({
		width:"100%"
	},200);
	$('#ResultArrDiv').find(".bootstrap-table").show();
	showRstTable="";
	}

//调用后台方法
//      
function MyRunClassMethod(ClassName,MethodName,Datas){
   Datas=Datas||{};
   var RtnStr = "";
   runClassMethod(ClassName,MethodName,
   Datas,
   function (data){
	  	RtnStr=data;
	  },
	"text",false
	);
	return RtnStr;
}

function develop (){
	alert("开发中");
	}