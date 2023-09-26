var PatientID=""

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
		url:'DHCJOEQueryToJsqon.csp',
		data:{
			ClassName:"web.patcheckout",
			QueryName:"getAdmList",
			FunModul:"MTHD",
			//P0:PatientID    正确
			P0:PatientID
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
			//$("#diagnose_combobox").val("-1");	
		} 
	 })
}



//报告结果查看
function ShowReportResult(VisitNumberReportDR) {
	 //alert(VisitNumberReportDR);   OK
	 if (VisitNumberReportDR == "") {
		 //为NULL 的时候加载空数据
		 ShowReportResult("0");
	 }
	 $('#ResultArr').dhccQuery(
	 {query:{
		ClassName:"LIS.WS.BLL.DHCRPVisitNumberReportResult",
		QueryName:"QryTSInfo",
		FunModul:"JSON",
		P0:VisitNumberReportDR}
	 })

};

//报告打印浏览
function printViewClick() {
	var checkedRows =  $('#dgOrdItmList').datagrid("getChecked");
	var reportDRs = "";
	for (var i in checkedRows) {
		if (checkedRows[i]["ResultStatus"] != "3") {
			$.messager.alert('操作提示','报告'+checkedRows[i]["OrdItemName"]+"未出报告，不能打印！");
			return;
		}
		if (reportDRs.length > 0)
			reportDRs = reportDRs+"^"+checkedRows[i]["VisitNumberReportDR"];
		else 
			reportDRs = checkedRows[i]["VisitNumberReportDR"]
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
    //alert(EpisodeID);
    //alert(admNo);
    //alert(admNo);
    if (admNo.length > 0) {
	    EpisodeID = admNo;
    }
    
     $('#sampleArr').dhccQuery(
	 {query:{
		ClassName:"DHCLIS.DHCOrderList",
		QueryName:"QueryOrderList",
		FunModul:"JSON",
		P0:EpisodeID, 
		P1:PatientID,   
		//P1:12,     正确
		P2:SttDate,
		P3:EndDate,  //ToDate:"", 
		P4:"",  //LocCode:"", 
		P5:AuthFlag,  //AuthFlag:"", 
		P6:"",  //AllTS:"", 
		P7:"",  //AdmDateFlag:""
		P8:UserId,
		P9:	ReadFlag,
		P10:"",	 //RegNo
		P11:"",  //LocationDR
		P12:"",  //WardDR
		P13:PrintFlag
		}
	 })
}

//初始化Table
function initTable(){
	//时间的输入框
	$('#startDate').dhccDate();
	$('#endDate').dhccDate();
	
	var columns=[ 
        	{ field: 'chkReportList', checkbox: true },
            { field: 'LabEpisode', title: '检验号',width: 90},
            { field: 'OrdItemName', title: '医嘱名称',width: 90},
            { field: 'ResultStatus', title: '结果状态',width: 90,formatter: ResultIconPrompt},
            { field: 'PrintFlag', title: '打印',width: 90,
        	formatter: function (value, rowData, rowIndex) {
                          if(value=="Y")
                          {
	                          return '已打印';
                          }
                          else if(value=="N")
                          {
	                          return '未打印';
                          }
                      }
          	},
            { field: 'ReadFlag', title: '阅读',width: 90,
            formatter: function(value, rowData, rowIndex){
	          	if (rowData.ResultStatus != "3") //审核状态
	          		return "";
	        	if (value == "1") {
		        	return "<span>已阅读</span>";
	        	}
	        	else {
		        	return "<span>未阅读</span>";
	        	}  	
	        } 
	        },
            { field: 'AuthDateTime', title: '报告日期',width: 90},
            { field: 'RecDateTime', title: '接收日期',width: 90},
            { field: 'SpecDateTime', title: '采集日期',width: 90},
            { field: 'ReqDateTime', title: '申请日期',width: 90},
            { field: 'WarnComm', title: '危机提示',width: 90},
            { field: 'TSMemo', title: '标本提示',width: 90},
            { field: 'ViewResultChart', title: '历史',width: 90},
            { field: 'PreReport', title: '预报告',width: 90},
            { field: 'VisitNumberReportDR', title: 'VisitNumberReportDR',width: 90},
            { field: 'OEOrdItemID', title: 'OEOrdItemID',width: 90}
            ];
	//标本列表
	//alert(EpisodeID+":"+PatientID);
	$('#sampleArr').dhccTable({
	    //height:$(window).height()-300,
	    //sidePagination:'side',
	    height:460,
	    pageSize:15,
	    pageList:[50,100],
        url:"DHCJOEQueryToJsqon.csp",  
        //url:"DHCJOEQueryToJsqon.csp",  
        pagination:false,
        columns:columns,
        //singleSelect:true,
        queryParams: { 
			ClassName:"web.patcheckout",
			QueryName:"QueryOrderList",
			FunModul:"JSON",
			P0:"-1",
			P1:PatientID, 
			P2:"", 
			P3:"",  //ToDate:"", 
			P4:"",  //LocCode:"", 
			P5:"",  //AuthFlag:"", 
			P6:"",  //AllTS:"", 
			P7:"",  //AdmDateFlag:""
			P8:UserId,  //登录用户ID
			P8:"",
			P9:"",   //ReadFlag
			P10:"",	 //RegNo
			P11:"",  //LocationDR
			P12:"",  //WardDR
			P13:""  //PrintFlag
		},
		
        onLoadSuccess:function(data){
	       ShowReportResult("0"); 
	    }
		
	})
	
	
	var  colums = [[
              //{ field: 'TestCodeDR', title: '项目id'},
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
	                          return '<a href="#" onClick="ShowMicReport(\''+VisitNumberReportDR+'\',\''+rowData.TestCodeDR+'\');">'+value+'</a>';
                          }
                          else
                          {
	                          return value;
                          }
                      }
	              
               },
 	          { field: 'ExtraRes', title: '结果提示'},
              { field: 'AbFlag', title: '异常提示',
	              cellStyle: function (value, row, index, field) {
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
              { field: 'PreResult', title: '前次结果',      //formatter:HistoryIconPrompt,
                cellStyle: function (value, row, index, field) {
                        var colStyle = "";
                        if (value != "") {
                            if (!isNaN(value)) {   ///数字类型
                                if (row.PreAbFlag == "L") { colStyle = {"color":"blue"}};
	                    		if (row.PreAbFlag == "H") { colStyle = {"color":"red"}};
	                   			if (row.PreAbFlag == "PL") { colStyle = {"background-color":"red","color":"blue"} };
	                    		if (row.PreAbFlag == "PH") { colStyle = {"background-color":"red","color":"#ffee00"} };
	                    		if (row.PreAbFlag == "UL") { colStyle = {"background-color":"red","color":"blue"}};
	                   			if (row.PreAbFlag == "UH") { colStyle = {"background-color":"red","color":"#ffee00"} };                 
                            }
                        return {
				   			css: colStyle
				 		};
                        }
                    }
              },
              { field: 'PreAbFlag', title: '前次异常提示',hidden: true},
              //{ field: 'ResClass', title: '危急提示',hidden:true},
              { field: 'ClinicalSignifyS', title: '临床意义'}
            ]];
	
	
	//报告结果
	$('#ResultArr').dhccTable({
        url:'jquery.easyui.dhclabclassjson.csp',
        height:460,
        pagination:false,
		queryParams: { 
			ClassName:"LIS.WS.BLL.DHCRPVisitNumberReportResult",
			QueryName:"QryTSInfo",
			FunModul:"JSON",
			//P0:VisitNumberReportDR
			P0:""  //初始话值给空
		},
        method: 'get',
        pagination:true,
        singleSelect: true,
        columns: colums
    });
}



function bindMethod(){
	// 选中一行触发的方法
	$('#sampleArr').on('click-row.bs.table', function (e, row, $element) {
	      ShowReportResult(row.VisitNumberReportDR);
	      $('#ResultArr').dhccTable('reload');
	});
	
	//查找按钮的绑定事件
	$('#selBtn').on('click',findOrdItmList);	 //sss
	$('#priRepBtn').on('click',printOutClick);
	$('#priViewBtn').on('click',develop)
	
	
	/*$('#UserTradeSeatBt').on('select2:select', function (evt) {
		var SeatNumberObj =  document.getElementsByName("SeatNumber")[0];
		SeatNumberObj.value = this.value ;
	}); */
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
function ShowMicReport(VisitNumberReportDR,TestCodeDR) {
	var width = document.body.clientWidth - 130;
	var height = document.body.clientHeight - 10;
	$("#win_ReportResultView").window({
		modal:true,
		title:'微生物报告',
		//closable:false,
		collapsible:false,
		iconCls:'icon-message',
		width:width,
		height:height,
		content:'<iframe src="http://172.21.21.78/iMedicalLIS/facade/ui/frmMicReporstPrint.aspx?reportDRs='+VisitNumberReportDR+'&TestCodeDR='+TestCodeDR+'" scrolling="yes" frameborder="0" style="width:100%;height:100%;"></iframe>'
		//top: xy.top+20,
		//left: xy.left-width+100
	});
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
    }
    return a.join("");
}


//结果图标显示
function ResultIconPrompt(value, rowData, rowIndex) {
	///(1登记，2初审，3审核，4复查，5取消审核，6作废，O其他)
    if (value == "3") {
	    var paramList=rowData.VisitNumberReportDR;
	    //alert(paramList);
	    if (rowData.TSResultAnomaly == "3") {
        	return "<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(" + paramList + "))';>报告结果</a>";
	    }
	    if (rowData.TSResultAnomaly == "2") {
        	return "<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(" + paramList + "))';>报告结果</a>";
	    }
	    if (rowData.TSResultAnomaly == "1") {
        	return "<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(" + paramList + "))';>报告结果</a>";
	    }
	    if (rowData.TSResultAnomaly == "0") {
        	return "<a style='text-decoration:none;' href='javascript:void(ReportView(" + paramList + "))';>报告结果</a>";
		}
    }
}


//报告浏览
function ReportView(VisitNumberReportDR) {
	//alert(VisitNumberReportDR);
	option={
		title:'阅读确认',
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
	//alert($('#sampleArr').dhccTable(''));
	/*
	alert();
	*/
	/*var checkedRows =  $('#dgOrdItmList').datagrid("getChecked");
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
    //var str="/imedicallis/facade/ui/frmRepostPrint.aspx?reportDRs="+reportDRs;
    //window.open(str,'_blank','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=700,left=0,top=0')
           
	//var a = $("<a href='/imedicallis/facade/ui/frmRepostPrint.aspx?reportDRs="+reportDRs +"'target='_blank'></a>").get(0);  
    // var e = document.createEvent('MouseEvents');  
    // e.initEvent('click', true, true);  
    // a.dispatchEvent(e);  
	*/
}



//同过登记号获取病人的ID
function  GetPatId(){
	if(RegNo==""){
		PatientID="";	
	}else if(RegNo.length<10){
		for(i=RegNo.length;i<10;i++){
			RegNo="0"+RegNo
		}	
	}
	//alert(RegNo);
	PatientID=MyRunClassMethod("web.patcheckout","GetPatIdByNo",{"RegNo":RegNo})
	//alert(PatientID);
}//GetPatId end
	


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