$(function(){
	
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
		url:'jquery.easyui.dhclabclassjson.csp',
		data:{
			ClassName:"DHCLIS.DHCOrderList",
			QueryName:"getAdmList",
			FunModul:"MTHD",
			P0:1
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
				
		} 
	 })
}



//报告结果查看
function ShowReportResult(VisitNumberReportDR) {
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
    alert("11");
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
		//P1:PatientID, 
		P1:12,
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
            { field: 'LabEpisode', title: '检验号',width: 90, sortable: true, align: 'center'},
            { field: 'OrdItemName', title: '医嘱名称',width: 90, sortable: true, align: 'center'},
            { field: 'ResultStatus', title: '结果状态',width: 90, sortable: true, align: 'center'},
            { field: 'PrintFlag', title: '打印',width: 90, sortable: true, align: 'center',
        	formatter: function (value, rowData, rowIndex) {
                          if(value=="Y")
                          {
	                          return '<i class="fa fa-camera-retro fa-2x"></i>';
                          }
                          else if(value=="N")
                          {
	                          return '111';
                          }
                      }
          	},
            { field: 'ReadFlag', title: '阅读',width: 90, sortable: true, align: 'center',
            formatter: function(value, rowData, rowIndex){
	          	if (rowData.ResultStatus != "3")
	          		return "";
	        	if (value == "1") {
		        	return "<span>已阅读</span>";
	        	}
	        	else {
		        	return "<span>未阅读</span>";
	        	}  	
	        } 
	        },
            { field: 'AuthDateTime', title: '报告日期',width: 90, sortable: true, align: 'center'},
            { field: 'RecDateTime', title: '接收日期',width: 90, sortable: true, align: 'center'},
            { field: 'SpecDateTime', title: '采集日期',width: 90, sortable: true, align: 'center'},
            { field: 'ReqDateTime', title: '申请日期',width: 90, sortable: true, align: 'center'},
            { field: 'WarnComm', title: '危机提示',width: 90, sortable: true, align: 'center'},
            { field: 'TSMemo', title: '标本提示',width: 90, sortable: true, align: 'center'},
            { field: 'ViewResultChart', title: '历史',width: 90, sortable: true, align: 'center'},
            { field: 'PreReport', title: '预报告',width: 90, sortable: true, align: 'center'},
            { field: 'VisitNumberReportDR', title: 'VisitNumberReportDR',width: 90, sortable: true, align: 'center'},
            { field: 'OEOrdItemID', title: 'OEOrdItemID',width: 90, sortable: true, align: 'center'}
            ];

	//标本列表
	$('#sampleArr').dhccTable({
	    //height:$(window).height()-300,
	    //sidePagination:'side',
	    height:460,
	    pageSize:15,
	    pageList:[50,100],
        url:"jquery.easyui.dhclabclassjson.csp",
        columns:columns,
        singleSelect:true,
        queryParams: { 
			ClassName:"DHCLIS.DHCOrderList",
			QueryName:"QueryOrderList",
			FunModul:"JSON",
			//P0:EpisodeID, 
			//P1:PatientID, 
			P0:-1, 
			P1:12, 
			P2:"", 
			P3:"",  //ToDate:"", 
			P4:"",  //LocCode:"", 
			P5:"",  //AuthFlag:"", 
			P6:"",  //AllTS:"", 
			P7:"",  //AdmDateFlag:""
			P8:UserId,
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
              { field: 'TestCodeDR', title: '项目id',sortable: true, align: 'center' },
              { field: 'Synonym', title: '缩写',sortable: true, align: 'center'},
              { field: 'TestCodeName', title: '项目名称'},
              { field: 'Result', title: '结果',sortable: true, align: 'center',
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
 	          { field: 'ExtraRes', title: '结果提示',sortable: true, align: 'center'},
              { field: 'AbFlag', title: '异常提示',sortable: true, align: 'center',
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
              { field: 'Units', title: '单位',sortable: true, align: 'center'},
              { field: 'RefRanges', title: '参考范围',sortable: true, align: 'center'},
              { field: 'PreResult', title: '前次结果',sortable: true, align: 'center',      //formatter:HistoryIconPrompt,
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
              { field: 'PreAbFlag', title: '前次异常提示',sortable: true, align: 'center',hidden: true},
              { field: 'ResClass', title: '危急提示',hidden:true,sortable: true, align: 'center'},
              { field: 'ClinicalSignifyS', title: '临床意义',sortable: true, align: 'center'}
            ]];
	
	
	
	//报告结果
	$('#ResultArr').dhccTable({
        url:'jquery.easyui.dhclabclassjson.csp',
        height:460,
		queryParams: { 
			ClassName:"LIS.WS.BLL.DHCRPVisitNumberReportResult",
			QueryName:"QryTSInfo",
			FunModul:"JSON",
			//P0:VisitNumberReportDR
			P0:""
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
		  alert(row.VisitNumberReportDR);	
	      ShowReportResult(row.VisitNumberReportDR);
	      $('#ResultArr').dhccTable('reload');
	});
	
	//查找按钮的绑定事件
	$('#selBtn').on('click',findOrdItmList)	 //sss
	
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