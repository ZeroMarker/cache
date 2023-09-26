var PatientID="",showRstTable=""

//页面加载
var me = {
	VisitNumberReportDR:"",
	ConnectString:""	
}

//qqa 调用检验接口获取但因路径
var webIP= serverCall("DHCLIS.DHCOrderList","getDllWebIP");

$(function(){
	
	
	//取到病人的ID值
	GetPatId(); 
	
	//初始化Time控件
	initTmeControl();
	
	//初始化界面
	initTable();
	
	//给界面绑定方法
	bindMethod();
	
	//初始化combobox
	initCombobox();
	
	resTable();
	
})



function initCombobox(){
	//就诊下拉框初始化
	ShowAdmList();
	
	//showCheckName
	ShowCheckName();
	
	//医嘱名称下拉框
	ShowItemName();
	}




function initTmeControl(){
	//时间的输入框
	$('#StartDate').dhccDate();
	$('#EndDate').dhccDate();
	//$('#EndDate').setDate(new Date().Format("yyyy-MM-dd"));
}



//就诊列表
function ShowAdmList() { 
	
	 $("#diagAdm").dhccSelect({
		url:LINK_CSP+"?ClassName=web.DHCEMPatCheOutNew&MethodName=getAdmList&PatientID="+PatientID+"&StartDate="+$('#StartDate input').val()+"&EndDate="+$('#EndDate input').val()
		 })
}


function ShowCheckName(){
	$('#CheckName').dhccSelect({
		url:LINK_CSP+"?ClassName=web.DHCEMPatCheOutNew&MethodName=getCheckName" 
		})
	}


function ShowItemName(){
	$('#ItemName').dhccSelect({
		url:LINK_CSP+"?ClassName=web.DHCEMPatCheOutNew&MethodName=getItemName" 
		})
	}



//报告结果查看
function ShowReportResult() { 
	 $('#cspCheckRarr').dhccQuery(
	 {
		query:{
			offset : 0,
	        limit : "1000",
			ReportDR:me.VisitNumberReportDR
		}
	 })

};


//报告打印浏览
function printViewClick() {
	var checkedRows = $('#cspCheckSamArr').dhccTableM('getSelections');
	if(checkedRows==""){
		dhccBox.alert("没有选中数据！","NoData");
		return ;
		}
	var reportDRs = "";
	for (var i in checkedRows) {
		if (checkedRows[i].ResultStatus!= "3") {
			dhccBox.alert('报告'+checkedRows[i].OrdItemName+"未出报告，不能进行打印预览！");
			return;
		}
		if (reportDRs.length > 0)
			reportDRs = reportDRs+"^"+checkedRows[i].VisitNumberReportDR;
		else 
			reportDRs = checkedRows[i].VisitNumberReportDR
	}
	param="DOCTOR"
	connectString=me.ConnectString
	var UserParam=UserId + "^" + HospID;
	
	var printFlag = "0";
    var rowids = reportDRs;
    var userCode = UserParam;
    var paramList = param;
    var connectString = me.ConnectString;
    var printType = "PrintPreview";
    var clsName = "HIS.DHCReportPrint";
    var funName = "QueryPrintData";
	var Param = printFlag + "@" + connectString + "@" + reportDRs + "@" + UserParam + "@" + printType + "@" + paramList;
	PrintCommon(Param);
}

//点击查询按钮
var findOrdItmList = function (){
	
	var AuthFlag = "0";
	if ($("#printRadio:checked").val()=="on") {
		AuthFlag = 1;
	}
	//alert(AuthFlag);
	var PrintFlag = "Y";
	if ($("#issueRadio:checked").val()=="on") {
		PrintFlag = "N";
	}

	var ReadFlag = "0";
	if ($("#readRadio:checked").val()=="on") {
		ReadFlag = 1;
	} 

	var SttDate = $('#StartDate input').val();
    var EndDate = $('#EndDate input').val(); 
    var admNo = $("#diagAdm").val();
    if ((admNo!="")&(admNo!=null)) {
	    EpisodeID = admNo;  //按照就诊ID 查找
    }else{
	    EpisodeID="-1"		//查询所有
    }
    ShowAdmList();     //QQA 2016-11-10 重新加载就诊科室select2
    
    var Param=""
    Param = EpisodeID+"^"+PatientID+"^"+SttDate+"^"+EndDate+"^"+""+"^"+AuthFlag
    Param=Param+"^"+""+"^"+""+"^"+UserId+"^"+ReadFlag+"^"+""+"^"+""+"^"+""
    Param=Param+"^"+PrintFlag
	$('#cspCheckRarr').dhccTableM("removeAll");  //清除表格数据	
    $('#SelDrugRs').remove();                    //清除table
     $('#cspCheckSamArr').dhccQuery(
	 {
		query:{
			offset : 0,
	        limit : "1000",
			Params:Param
		}
	 })
	
}

//初始化Table
function initTable(){
	//标本列表,左侧Table
	var columns=[ 
        	{ title:'选择', checkbox: true },
            { field: 'LabEpisode', title: '检验号',align:'center'},
            { field: 'OrdItemName', title: '医嘱名称',align:'center',width:300},
            { field: 'ResultStatus', title: '结果状态',align: 'center',formatter: ResultIconPrompt},
            { field: 'PrintFlag', title: '打印',align: 'center',formatter: printFormatter},
            { field: 'ReadFlag', title: '阅读',align: 'center',formatter:readFormatter},
            { field: 'Trance', title: '追踪', width:30, sortable: false, align: 'center', formatter: function (value, rowData, rowIndex) {
                  retStr = "<a href='#' title='标本追踪'  onclick='ShowReportTrace(\""+rowData.LabEpisode+"\")'><img style='width:25px' src='../scripts/dhcnewpro/images/track.png'/></span></a>"
				  	return retStr;
              	  }
          	},
          	{ field: 'StatusDesc', title: '状态',align: 'center',
			  cellStyle: function(value,row,index){
					if (value == "登记" || value == "初审" || value == "审核"){
						return {css: {"background-color":"color:#0000ff;"}}
					}
					if (value == "核实") {
						return {css: {"background-color":"color:#7400ff;"}}
					}
					if (value == "取消" || value == "作废"){
						return {css: {"background-color":"color:#ff0000;"}}
					}
					if (value == "复查") {
						return {css: {"background-color":"color:#fb00ff;"}}
					}
					return {css: {"background-color":"color:#000000;"}}
				}
		   },
            { field: 'AuthDateTime',align: 'center', title: '报告日期'},
            { field: 'RecDateTime',align: 'center', title: '接收日期'},
            { field: 'SpecDateTime',align: 'center', title: '采集日期'},
            { field: 'ReqDateTime',align: 'center', title: '申请日期'},
            { field: 'WarnComm', align: 'center',title: '危急提示'},
            { field: 'MajorConclusion', align: 'center',title: '报告评价'},
            { field: 'TSMemo', align: 'center',title: '标本提示'},
            { field: 'ViewResultChart', align: 'center',title: '历史'},
            { field: 'PreReport', align: 'center',title: '预报告'}
     		]; 
	//标本列表
	$('#cspCheckSamArr').dhccTable({
	    height:$(window).height()-125,
	    pagination:false,
        url:"dhcapp.broker.csp?ClassName=web.DHCEMPatCheck&MethodName=JsonQryOrdList",
        columns:columns,
        singleSelect:true,
        queryParam: {
	        offset : 0,
	        limit : "1000",
			Params:"-1^"+PatientID+"^^^^^^^"+UserId+"^^^^^"
		},
      onClickRow:function (row, $element) {
		me.VisitNumberReportDR = row.VisitNumberReportDR;
		if ((row.ResultStatus == 3) && (row.ReadFlag != 1) ) {
	        $("#readBookBtn").show();
        }else {
	        $("#readBookBtn").hide();
        }
        
        if (row.ResultStatus.length > 0 && row.VisitNumberReportDR.length > 0 && row.ResultStatus == 3) {
	        $("#cspCheckSamArr").dhccTableM("uncheckAll");
	        //$("#cspCheckSamArr").dhccTableM('check',$element.attr("data-index"));   //影响左侧表格选中  qqa 2017-09-28
	        ShowReportResult();     //右侧表格加载
        }else{
	        $('#cspCheckRarr').dhccTableM("removeAll");  //清除表格数据
			$('#SelDrugRs').remove();
	    }
	}
      
	})

	//报告结果，右边Table
	var  columns = [
          //{field :"TestCodeDR",align:'center',title:'项目ID'},
          { field: 'Synonym',align: 'center', title: '缩写'},
          { field: 'TestCodeName',align: 'center', title: '项目名称'},
          { field: 'Result',align: 'center', title: '结果',
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
          { field: 'ExtraRes',align: 'center', title: '结果提示'},
          { field: 'AbFlag',align: 'center', title: '异常提示',
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
          { field: 'Units',align: 'center', title: '单位'},
          { field: 'RefRanges',align: 'center', title: '参考范围'},
          { field: 'PreResult',align: 'center', title: '前次结果',formatter:HistoryIconPrompt,
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
          { field: 'PreAbFlag', align: 'center',title: '前次异常提示',hidden: true}
          //{ field: 'ResClass', title: '危急提示',hidden:true},
          //{ field: 'ClinicalSignifyS',align: 'center', title: '临床意义'}
        ];

	//报告结果
	$('#cspCheckRarr').dhccTable({
        height:$(window).height()-125,
        url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheck&MethodName=JsonQryTSInfo',
        columns: columns,
        pagination:false,
        singleSelect: true,
		queryParam: { 
			offset : 0,
	        limit : "1000",
			ReportDR:"" 			
		},
		onLoadSuccess:function (data){
			if(data.rows.length>0){
				if(!$('#SelDrugRs').html()){    //不需要重复添加
					SelDrugRs(data);	
				}
			}
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
	
	
	//查找按钮的绑定事件
	$('#selBtn').on('click',findOrdItmList);	 //sss
	$('#prnBtn').on('click',printOutClick);
	$('#exeBtn').on('click',printViewClick)
	$('#readBookBtn').on('click',SetReadedFlag);
	$('#diagAdm').on('select2:select', function (evt) {
		findOrdItmList();	
	}); 
	
	//操作就查询
	//$("#selectAuthedReport").change(function () {
    //     findOrdItmList();
    //});
    //操作就查询
    //$("#selectPrintReport").change(function () {
    //    findOrdItmList();
    //});
    //操作就查询
    //$("#selectReadedCb").change(function () {
	  
    //     findOrdItmList();
    //});	
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
	    if (rowData["ResultFormat"] == "N")
       		a.push(value + "&nbsp;<a style='text-decoration:none;' href=\"javascript:void(ShowHistoryResult('",  me.VisitNumberReportDR,"','",rowData.TestCodeDR, "'));\"><span class='icon-chart_curve' title='结果曲线图'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;");
       	else 
       		a.push(value);
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
        	return "<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(" + paramList + "))';><img style='width:25px' src='../scripts/dhcnewpro/images/absurd.png'/></span>报告结果</a>";
	    }
	    if (rowData.TSResultAnomaly == "2") {
        	return "<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(" + paramList + "))';><img style='width:25px' src='../scripts/dhcnewpro/images/crisis.png'/></span>报告结果</a>";
	    }
	    if (rowData.TSResultAnomaly == "1") {
        	return "<a style='text-decoration:none;color:orange;' href='javascript:void(ReportView(" + paramList + "))';><img style='width:25px' src='../scripts/dhcnewpro/images/abnormal.png'/></span>报告结果</a>";
	    }
	    if (rowData.TSResultAnomaly == "0") {
        	return "<a style='text-decoration:none;' href='javascript:void(ReportView(" + paramList + "))';><span class='' color='red' title='报告结果')></span>报告结果</a>";
		}
    }   
}

function printFormatter(value, rowData, rowIndex){
	  if(value=="Y")
	  {
	      return '<span class="" title="已打印">已打印</span>';
	  }
	  else if(value=="N")
	  {
	      return '';
	  }
}

function readFormatter(value, rowData, rowIndex){
	if (rowData.ResultStatus != "3") return "";
	if (value == "1") {
    	return "<span class='' color='red' title='已阅读')>已阅读</span>";
	}
	else {
    	return "<span class='' color='red' title='未阅读')>未阅读</span>";
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
  		content: 'jquery.easyui.dhclabreport.csp?VisitNumberReportDR='+VisitNumberReportDR,
  		end:function(){
	  		findOrdItmList();
	  	}
	}
	window.parent.layer.open(option);
	return false;
}


//打开报告置成已读,点击确认阅读
var SetReadedFlag = function(){
	var selectedRow=$("#cspCheckSamArr").dhccTableM("getSelections");
	if (selectedRow.length==0) return;
	var OrderID = selectedRow[0].OEOrdItemID
	var VisitNumberReportDR = selectedRow[0].VisitNumberReportDR;
	runClassMethod("DHCLIS.DHCReportControl","AddViewLog",
		{'UserId':UserId,'VisitNumberReportDRs':VisitNumberReportDR,'HospID':HospID,'OrderIDs':OrderID},
	   function(rtn){
		   if (rtn == "1") {
			  dhccBox.alert("阅读成功！","patientcheck1");
		   }
		   findOrdItmList();
		   $("#readBookBtn").hide();
		},"text",false
	);
}


//报告打印
function printOutClick() {
	var checkedRows=$("#cspCheckSamArr").dhccTableM("getSelections");
	if(checkedRows==""){
		dhccBox.alert("没有选中数据！","NoData");
		return ;
		}
	var reportDRs = "";
	for (var i in checkedRows) {
		if (checkedRows[i].ResultStatus != "3") {
			dhccBox.alert('报告'+checkedRows[i].OrdItemName+"未出报告，不能打印！","wcbg");
			return ;
		}
		if (reportDRs.length > 0) {
			reportDRs = reportDRs+"^"+checkedRows[i].VisitNumberReportDR;
		}
		else 
			reportDRs = checkedRows[i].VisitNumberReportDR;
	}

	param="DOCTOR"
	connectString=me.ConnectString
	var UserParam=UserId + "^" + HospID;
	
	var printFlag = "0";
    var rowids = reportDRs;
    var userCode = UserParam;
    var paramList = param;
    var paramList = "DOCTOR";
    var connectString = me.ConnectString;
    var printType = "PrintOut";
    var clsName = "HIS.DHCReportPrint";
    var funName = "QueryPrintData";
	var Param = printFlag + "@" + connectString + "@" + reportDRs + "@" + UserParam + "@" + printType + "@" + paramList;
	PrintCommon(Param);

    //更新打印标识
	findOrdItmList();    
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
  		area: ['600px','500px'],
  		content: 'dhcem.rscurve.csp?VisitNumberReportDR='+VisitNumberReportDR+'&TestCodeDR='+TestCodeDR
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
function resTable(){
	var rtime = new Date();
    var timeout = false;
    var delta = 200;
    $(window).resize(function() {
        rtime = new Date();
        if (timeout === false) {
            timeout = true;
            setTimeout(resizeend, delta);
        }
    });


    function resizeend() {
        if (new Date() - rtime < delta) {
            setTimeout(resizeend, delta);
        } else {
            timeout = false;
            $('#cspCheckRarr').dhccTableM("resetWidth");
        }
    }
	
}

function ShowReportTrace(LabEpisode) {
	
	if (LabEpisode== undefined || LabEpisode == "") return false;
	option={
		title:'标本追踪',
  		type: 2,
  		shadeClose: true,
  		shade: 0.8,
  		area: ['800px','500px'],
  		content: 'jquery.easyui.dhclabreporttrace.csp?LabNo='+LabEpisode
	}
	window.parent.layer.open(option);
	return false;
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

function SelDrugRs(data){
	var data=data["rows"];
	var TSNames={};
	//菌落计数
	var ClonyNum={};
	//菌落形态
	var ClonyForms={};
	//备注
	var ResNoes={};
	for(var i=0;i<data.length;i++) {
    if(data[i]["ResultFormat"] == "M" && data[i]["Result"].length > 0) {
        TSNames[data[i]["ReportResultDR"]] = data[i]["Result"];
        ClonyForms[data[i]["ReportResultDR"]]=data[i]["ClonyForm"];
        ClonyNum[data[i]["ReportResultDR"]]=data[i]["ClonyNum"];
        ResNoes[data[i]["ReportResultDR"]]=data[i]["ResNoes"];

        //查询药敏结果
        $.ajax({
             url:'jquery.easyui.dhclabclassjson.csp',
			 data: { 
				 ClassName:"LIS.WS.BLL.DHCRPMicNumberReport",
				 QueryName:"QryReportResultSen",
				 FunModul:"JSON",
				 P0:data[i]["ReportResultDR"]
			 },
	         success: function (retData) {
		          var htmlStr="";
		         retData = jQuery.parseJSON(retData)
		    
		         if(retData["rows"] != undefined && retData["rows"].length >0){
			        htmlStr+="<table id='SelDrugRs' style='font-size:12px;padding-top:10;width:430'>";
			        htmlStr+="<tr><td colspan='5'><span style='color:red;font-weight:bold'>"+TSNames[retData["rows"][0]["VisitNumberReportResultDR"]]
			        if(ClonyNum[retData["rows"][0]["VisitNumberReportResultDR"]] != undefined && ClonyNum[retData["rows"][0]["VisitNumberReportResultDR"]].length > 0)
			        	htmlStr+="</span>----<span style='font-weight:bold'>菌落计数：</span>"+ClonyNum[retData["rows"][0]["VisitNumberReportResultDR"]];
			        	if(ClonyForms[retData["rows"][0]["VisitNumberReportResultDR"]] != undefined && ClonyForms[retData["rows"][0]["VisitNumberReportResultDR"]].length > 0)
			        htmlStr+="</span>----<span style='font-weight:bold'>菌落形态：</span>"+ClonyForms[retData["rows"][0]["VisitNumberReportResultDR"]];
			        htmlStr+="</td></tr>";
			        if(ResNoes[retData["rows"][0]["VisitNumberReportResultDR"]] != undefined && ResNoes[retData["rows"][0]["VisitNumberReportResultDR"]].length > 0)
			        	htmlStr+="<tr><td colspan='5'><span style='font-weight:bold'>备注：</span>"+ResNoes[retData["rows"][0]["VisitNumberReportResultDR"]]+"</td></tr>";
					htmlStr+="<tr style='font-weight:bold'>";
					htmlStr+="<td>抗生素名称</td>";
					htmlStr+="<td>缩写</td>";
					htmlStr+="<td>KB(mm)</td>";
					htmlStr+="<td>MIC(ug/ml)</td>";
					htmlStr+="<td>结果</td>";
					htmlStr+="</tr>";
					var kb=""
					var mic=""
					for(var index=0;index<retData["rows"].length;index++) {
						  htmlStr+="<tr>";
						  htmlStr+="<td>"+retData["rows"][index]["AntibioticsName"]+"</td>";
							htmlStr+="<td>"+retData["rows"][index]["SName"]+"</td>";

							if (retData["rows"][index]["SenMethod"] == "1") {
								kb=retData["rows"][index]["SenValue"];
								mic="&nbsp"
							} else {
								mic=retData["rows"][index]["SenValue"];
								kc="&nbsp";
							}
							htmlStr+="<td>"+kb+"</td>";
							htmlStr+="<td>"+mic+"</td>";
							htmlStr+="<td>"+retData["rows"][index]["SensitivityName"]+"</td>";
							htmlStr+="</tr>";
					 }
					 htmlStr+="</table>";
			        $('#cspCheckRarr').parents('.fixed-table-body').append(htmlStr);
		         }
	         }
		  })
    	}
	}
	
}



function PrintCommon(Param) {
	var printUrl="http://"+ webIP +"/imedicallis/lisprint/print2HIS/ResultPrintForHis.application?Param="+Param;
	document.location.href=printUrl;
}