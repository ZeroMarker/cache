
var HospID=session['LOGON.HOSPID']; 
var UserId = session['LOGON.USERID'];

//页面加载
var me = {
	VisitNumberReportDR:"",
	ConnectString:""
}
var aIcon0Str=getIconHtmlI("鉴","white","blue");
var aIcon1Str=getIconHtmlI("预","white","blue");
$(function() {
    pageInit();
    
});

function pageInit() {
	ShowOrdItmListsGrid(EpisodeID,PatientID,Search);
	
//	var curDate = GetCurentDate();
//	$('#dt_FindSttDate').datebox('setValue', curDate);
//    $('#dt_FindEndDate').datebox('setValue', curDate);
	ShowAdmList(PatientID);


	//操作就查询
	$('#dt_FindSttDate').datebox({
		onSelect:function(date){
			findOrdItmList();
		}
	});
	//操作就查询
	$('#dt_FindEndDate').datebox({
		onSelect:function(date){
			findOrdItmList();
		}
	});
	//操作就查询
	$('#cb_admList').combobox({
		onSelect:function(date){
			findOrdItmList();
		}
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

	
	//获取报告打印数据库连接
	var ID="1";
	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCOrderList",MethodName:"GetConnectString",ID:ID},
	function(rtn){
		if (rtn != "") {
			me.ConnectString=rtn;
		}
	});	
}   ///pageInit


var findOrdItmList = function (){
	var AuthFlag = 0;
	if (document.getElementById("selectAuthedReport").checked) {
		AuthFlag = 1;
	}
	var PrintFlag = "Y";
	if (document.getElementById("selectPrintReport").checked) {
		PrintFlag = "N";
	}
	var ReadFlag = 0;
	if (document.getElementById("selectReadedCb").checked) {
		ReadFlag = 1;
	} 
	var SttDate = $('#dt_FindSttDate').datebox('getValue');
    var EndDate = $('#dt_FindEndDate').datebox('getValue');
    var admNo = $('#cb_admList').combobox("getValue");
    if (admNo.length > 0) {
	    EpisodeID = admNo;
    }
	$('#dgOrdItmList').datagrid("load",{ 
		ClassName:"DHCLIS.DHCOrderList",
		QueryName:"QueryOrderList",
		FunModul:"JSON",
		P0:EpisodeID, 
		P1:PatientID, 
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
	});
}

//打开报告置成已读
var SetReadedFlag = function(){
	var selectedRow = $("#dgOrdItmList").datagrid("getSelected")
	if (selectedRow.length==0) return;
	var OrderID = selectedRow["OEOrdItemID"]
	var VisitNumberReportDR = selectedRow["VisitNumberReportDR"]
	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCReportControl",MethodName:"AddViewLog",UserId:UserId,VisitNumberReportDRs:VisitNumberReportDR,HospID:HospID,OrderIDs:OrderID},
	   function(rtn){
		   if (rtn == "1") {
			   $.messager.show({
					title:'提示消息',
					msg:'阅读成功!',
					timeout:5000,
					showType:'slide'
				});
				$('#dgOrdItmList').datagrid("reload");
		   }
		}
	);
	//AddViewLog(USERID,EpisodeID,PatientID,OrderID)
}

//医嘱明细列表
function ShowOrdItmListsGrid(EpisodeID,PatientID,Search) {
    $('#dgOrdItmList').datagrid({
		url:'jquery.easyui.dhclabclassjson.csp',
		method: 'get',
		queryParams: { 
			ClassName:"DHCLIS.DHCOrderList",
			QueryName:"QueryOrderList",
			FunModul:"JSON",
			P0:EpisodeID, 
			P1:PatientID, 
			P2:"", 
			P3:"",  //ToDate:"", 
			P4:"",  //LocCode:"", 
			P5:"",  //AuthFlag:"", 
			P6:"",  //AllTS:"", 
			P7:"",  //AdmDateFlag:""
			P8:UserId,
			P9:"",   //ReadFlag
			P10:"",	 //RegNo
			P11:"",  //LocationDR
			P12:"",  //WardDR
			P13:""  //PrintFlag
		},		
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		pageList: [20, 50, 100, 200],
		striped:true,
		nowrap: true, 
		border: false,
		sortName: 'AuthDateTime',
		sortOrder: 'dasc',
		collapsible: true,
		singleSelect:true,
		selectOnCheck: false,
        checkOnSelect: false,
		fit:true, 
        columns: [[
          { field: 'chkReportList', checkbox: true },
          { field: 'LabEpisode', title: '检验号', width: 90, sortable: false, align: 'center' },
          { field: 'OrdItemName', title: '医嘱名称', width: 260, sortable: false, align: 'left' },
		  { field: 'Order', title: '', width: 25, sortable: true, align: 'center',formatter:MCIconPrompt},
          //{ field: 'OrdSpecimen', title: '标本名称', width: 100, sortable: false, align: 'left' },
          { field: 'ResultStatus', title: '结果状态', width:90, sortable: false, align: 'center', formatter: ResultIconPrompt },
          { field: 'Trance', title: '追踪', width:30, sortable: false, align: 'center', formatter: function (value, rowData, rowIndex) {
                  retStr = "<a href='#' title='标本追踪'  onclick='ShowReportTrace(\""+rowData.LabEpisode+"\",\""+rowData.VisitNumberReportDR+"\")'><span class='icon-track' title='标本追踪')>&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>"
				  return retStr;
              }
          },
          { field: 'PrintFlag', title: '打印', width: 30, sortable: false, align: 'left',
          	formatter: function (value, rowData, rowIndex) {
                  if(value=="Y")
                  {
                      return '<a href="#" title="打印记录"  onclick="ShowPrintHistory(\''+rowData.VisitNumberReportDR+'\')"><span class="icon-ok" title="已打印">&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>';
                  }
                  else if(value=="N")
                  {
                      return '<a href="#" title="打印记录"  onclick="ShowPrintHistory(\''+rowData.VisitNumberReportDR+'\')"><span class="icon-undo" title="本人未打印">&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>';
                  }
              }
          },
          //{ field: 'TSResultAnomaly', title: '异常结果', width: 60, sortable: false, align: 'center'
           //, styler: function (value, rowData, rowIndex) {
			//	if (rowData.TSResultAnomaly == "1") { return 'color:red;'; }
			//}
		  //},
          { field: 'ReadFlag', title: '阅读', width: 30, sortable: false, align: 'center',
          	formatter: function(value, rowData, rowIndex){
	          	if (rowData.ResultStatus != "3")
	          		return "";
	        	if (value == "1") {
		        	return '<a href="#" title="阅读记录"  onclick="ShowReadLog(\''+rowData.VisitNumberReportDR+"\')\"><span class='icon-book_open' color='red' title='已阅读')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>";
	        	}
	        	else {
		        	return '<a href="#" title="阅读记录"  onclick="ShowReadLog(\''+rowData.VisitNumberReportDR+"\')\"><span class='icon-book_go' color='red' title='未阅读')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>";
	        	}  	
	        } 
          },
		  { field: 'StatusDesc', title: '状态', width: 60, sortable: false, align: 'center',
			  styler: function(value,row,index){
					if (value == "登记" || value == "初审" || value == "审核"){
						return 'color:#0000ff;';
					}
					if (value == "核实") {
						return 'color:#7400ff;';
					}
					if (value == "取消" || value == "作废"){
						return 'color:#ff0000;';
					}
					if (value == "复查") {
						return 'color:#fb00ff;';
					}
					return 'color:#000000;';
				}
		   },
          { field: 'AuthDateTime', title: '报告日期', width: 130, sortable: false, align: 'center' },
          { field: 'RecDateTime', title: '接收日期', width: 130, sortable: true, align: 'center' },
          { field: 'SpecDateTime', title: '采集日期', width: 130, sortable: false, align: 'center' },
          { field: 'ReqDateTime', title: '申请日期', width: 130, sortable: false, align: 'center' },
          { field: 'WarnComm', title: '危急提示', width: 150, sortable: false, align: 'left' },
          { field: 'TSMemo', title: '标本提示', width: 150, sortable: false, align: 'left' },
           { field: 'ReceiveNotes', title: '标本备注', width: 150, sortable: false, align: 'left' },
          { field: 'MajorConclusion', title: '报告评价', width: 150, sortable: false, align: 'left' },
          { field: 'ViewResultChart', title: '历史', width: 60, sortable: false, align: 'center' },
         // { field: 'PreReport', title: '预报告', width: 60, sortable: false, align: 'center' },
          { field: 'VisitNumberReportDR', title: 'VisitNumberReportDR', width: 60, sortable: false, align: 'center' },
          { field: 'OEOrdItemID', title: 'OEOrdItemID', width: 60, sortable: false, align: 'center' }
        ]],
        onLoadSuccess: function (data) {
            ShowReportResult("");
        },
         rowStyler: function (index, rowData) {
            ///结果标记
//            if (rowData.ReportAbFlag == "1" && rowData.ReportStatus == "3") {
//                console.info(rowData.TestSetStatus);
//                return "color:red;";
//            }
        },
        onSelect:function(rowIndex, rowData) {
	        me.VisitNumberReportDR = rowData["VisitNumberReportDR"];
	         if ((rowData["ResultStatus"] == 3) && (rowData["ReadFlag"] != 1) && (NoReaded!=1)) {
		        $("#div_ReportResultEast").panel("setTitle","报告结果&nbsp&nbsp<a href='#' class='' id='btn_confirmReaded' onclick='SetReadedFlag()'>阅读确认</a>");
		        $("#btn_confirmReaded").linkbutton({});
		        $("#btn_reportTrace").linkbutton({
			    	iconCls: 'icon-track',
        			plain: true
			    });
	        }
	        else {
		        $("#div_ReportResultEast").panel("setTitle","报告结果");
		        $("#btn_reportTrace").linkbutton({
			    	iconCls: 'icon-track',
        			plain: true
			     });
	        }
	        if (rowData["ResultStatus"].length > 0 && rowData["VisitNumberReportDR"].length > 0 && rowData["ResultStatus"] == 3) {
		        ShowReportResult(rowData["VisitNumberReportDR"]);
	        }
	        else {
		        $('#dg_ReportResult').datagrid("loadData",[]);
	        }
        }
    });
}; //ShowOrdItmListsGrid

//显示就诊列表
function ShowAdmList(PatientID) {
	$('#cb_admList').combobox({
		valueField:'id',    
    	textField:'name',
    	multiple:false,
    	separator:"/",    
        columns:[[    
        {field:'id',title:'id',width:60,hidden:true},
//        { field: 'ck', checkbox: true },    
        {field:'name',title:'Name',width:185}
    	]]  ,
        onLoadSuccess: function (data) {
          $('#cb_admList').combobox("setValue",EpisodeID);
        },
         rowStyler: function (index, rowData) {
            ///结果标记
//            if (rowData.ReportAbFlag == "1" && rowData.ReportStatus == "3") {
//                console.info(rowData.TestSetStatus);
//                return "color:red;";
//            }
        }
    });
	 $.ajax({
		url:'jquery.easyui.dhclabclassjson.csp',
		data:{
			ClassName:"DHCLIS.DHCOrderList",
			QueryName:"getAdmList",
			FunModul:"MTHD",
			P0:PatientID
		},
		type:"get",
		success:function(data) {
			var admArray = data.split("^");
			var cbArray= [{"id":"-1","name":"全部就诊"}];
			for (var i in admArray) {
				if (admArray[i].length > 10) {
					var id = admArray[i].split(",")[0];
					var name = admArray[i].replace(id+",","");
					cbArray.push({"id":id,"name":name});
				}
			}
			$('#cb_admList').combobox("loadData",cbArray)
		} 
	 })
	 
}

//结果图标显示
function ResultIconPrompt(value, rowData, rowIndex) {
	///(1登记，2初审，3审核，4复查，5取消审核，6作废，O其他)
	var retStr="";
    if (value == "3") {
	    var paramList=rowData.VisitNumberReportDR;
	    if (rowData.TSResultAnomaly == "3") {
        	retStr = "<a style='text-decoration:none;color:#FF83FA;' href='javascript:void(ReportView(\"" + paramList + "\"))';><span class='icon-absurb' color='red' title='荒诞结果')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>报告结果</a>";
	    }
	    if (rowData.TSResultAnomaly == "2") {
        	retStr = "<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(\"" + paramList + "\"))';><span class='icon-panic' color='red' title='危急值结果')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>报告结果</a>";
	    }
	    if (rowData.TSResultAnomaly == "1") {
        	retStr = "<a style='text-decoration:none;color:#FF7F00;' href='javascript:void(ReportView(\"" + paramList + "\"))';><span class='icon-abnormal' color='red' title='异常结果')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>报告结果</a>";
	    }
	    if (rowData.TSResultAnomaly == "0") {
        	retStr = "<a style='text-decoration:none;color:blue' href='javascript:void(ReportView(\"" + paramList + "\"))';><span class='icon-normal' color='red' title='报告结果')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>报告结果</a>";
		}
		
    }
    //retStr += "<a href='#' title='标本追踪'  onclick='ShowReportTrace(\""+rowData.LabEpisode+"\")'><span class='icon-track' title='标本追踪')>&nbsp&nbsp&nbsp</span></a>"
	if(rowData.HasBic=="1")
	{
		retStr="<span style='color:red;'>菌</span>"+retStr;
	}
	return retStr;
}

//鉴定过程图标显示
function MCIconPrompt(value, rowData, rowIndex) {
	var mcStr="";
	if(rowData.HasMC=="1"&&rowData.VisitNumberReportDR!="")
	{
	    mcStr+="<a style='text-decoration:none;color:red;' href='javascript:void(ReportMCView(" + rowData.VisitNumberReportDR + "))';>"+aIcon0Str+"</a>";
	}
	if(rowData.HasMid=="1"&&rowData.VisitNumberReportDR!="")
	{
	    mcStr+="<a style='text-decoration:none;color:red;' href='javascript:void(ReportMIDView(" + rowData.VisitNumberReportDR + "))';>"+aIcon1Str+"</a>";
	}
    return mcStr;
}

function ShowReportTrace(LabEpisode,ReportDR) {
	
	var width = document.body.clientWidth - 200;
	var height = 350;
	if (LabEpisode== undefined || LabEpisode == "") {
		var selectedRow = $("#dgOrdItmList").datagrid("getSelected")
		if (selectedRow.length==0) return;
		 LabEpisode = selectedRow["LabEpisode"];
	}
	$("#win_ReportTrace").window({
		modal:true,
		title:'标本追踪',
		//closable:false,
		collapsible:false,
		iconCls:'icon-message',
		width:width,
		height:height,
		content:'<iframe src="jquery.easyui.dhclabreporttrace.csp?LabNo='+LabEpisode+'&ReportDR='+ReportDR+'" scrolling="no" frameborder="0" style="width:100%;height:100%;"></iframe>'
		//top: xy.top+20,
		//left: xy.left-width+100
	});
	return false;
}

//报告浏览
function ReportView(VisitNumberReportDR) {
    //showwin("#win_ReportResultView", "检验报告", "http://172.21.21.92/iMedicalLIS/sample/form/frmRequest.aspx?OEOrdItemID=" + OEOrdItemID, 900, 570, true);
	//return false;
	var width = document.body.clientWidth - 200;
	var height = document.body.clientHeight - 50;
	$("#win_ReportResultView").window({
		modal:true,
		title:'检验报告',
		//closable:false,
		collapsible:false,
		iconCls:'icon-message',
		width:width,
		height:height,
		content:'<iframe src="jquery.easyui.dhclabreport.csp?VisitNumberReportDR='+VisitNumberReportDR+'" scrolling="no" frameborder="0" style="width:100%;height:100%;"></iframe>'
		//top: xy.top+20,
		//left: xy.left-width+100
	});
	return false;
	
}

//报告鉴定过程浏览
function ReportMCView(VisitNumberReportDR) {
	var width = document.body.clientWidth - 200;
	var height = document.body.clientHeight - 50;
	$("#win_ReportMCView").window({
		modal:true,
		title:'鉴定过程查看',
		//closable:false,
		collapsible:false,
		iconCls:'icon-message',
		width:width,
		height:height,
		content:'<iframe src="jquery.easyui.dhcMCProcess.csp?VisitNumberReportDR='+VisitNumberReportDR+'" scrolling="no" frameborder="0" style="width:100%;height:100%;"></iframe>'
	});
	return false;
	
}

//报告中间报告浏览
function ReportMIDView(VisitNumberReportDR) {
	var width = document.body.clientWidth - 200;
	var height = document.body.clientHeight - 50;
	$("#win_ReportMCView").window({
		modal:true,
		title:'预报告查看',
		//closable:false,
		collapsible:false,
		iconCls:'icon-message',
		width:width,
		height:height,
		content:'<iframe src="jquery.easyui.dhclabmidreport.csp?VisitNumberReportDR='+VisitNumberReportDR+'" scrolling="no" frameborder="0" style="width:100%;height:100%;"></iframe>'
	});
	return false;
	
}

//窗口id ，标题，请求页面，宽 ，高
function showwin(winid, title, url, mywidth, myheight, draggable) {//修改和添加的弹出框
    var _content = '<iframe id="FRMdetail"  frameborder="0"  src=' + url + ' style="width:100%;height:100%;" ></iframe>';
    $(winid).dialog({
        width: mywidth,
        height: myheight,
        modal: true,
        content: _content,
        title: title,
        draggable: draggable,
        resizable: true,
        shadow: true,
        minimizable: false
        //onClose: function () { winClose(winid); }  ///liuzf 用于回调主窗体函数处理功能
    });
}

//报告打印
function printOutClick() {
	var checkedRows =  $('#dgOrdItmList').datagrid("getChecked");
	var reportDRs = "";
	var rowIndexArray = [];
	for (var i in checkedRows) {
		if (checkedRows[i]["ResultStatus"] != "3"&&checkedRows[i]["HasMid"] != "1") {
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
	if (rowIndexArray.length == 0) {
		$.messager.alert('操作提示','请勾选要打印的报告！');
		return;
	}
	
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
	var UserParam=UserId + "^" + HospID;
	
	var printFlag = "0";
    var rowids = reportDRs;
    var userCode = UserParam;
    var paramList = param;
    var connectString = me.ConnectString;
    var printType = "PrintOut";
    var clsName = "HIS.DHCReportPrint";
    var funName = "QueryPrintData";
	var Param = printFlag + "@" + "" + "@" + reportDRs + "@" + UserParam + "@" + printType + "@" + paramList;
	HISBasePrint(Param);
	
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
	
	return;
	
	//旧的打印方式
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
	try
	{
    	if (reportDRs) objPrintPreview.PrintOut(reportDRs, UserParam, param, connectString);  
	}
	catch(e)
	{
		var printFlag = "0";       ///0:打印所有报告 1:循环打印每一份报告
        var printType = "PrintPreview";    ///PrintOut:打印  PrintPreview打印预览
        var paramList = "LIS";               ///1:报告处理打印 2:自助打印 3:医生打印
		var Param = printFlag + "@" + connectString + "@" + reportDRs + "@" + UserParam + "@" + printType + "@" + paramList
		HISBasePrint(Param);
	}
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
	
}

//报告打印浏览
function printViewClick() {
	var checkedRows =  $('#dgOrdItmList').datagrid("getChecked");
	var reportDRs = "";
	if (checkedRows.length == 0) {
		$.messager.alert('操作提示','请勾选要打印的报告！');
		return;
	}
	for (var i in checkedRows) {
		if (checkedRows[i]["ResultStatus"] != "3"&&checkedRows[i]["HasMid"] != "1") {
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
	var UserParam=UserId + "^" + HospID;
	
	var printFlag = "0";
    var rowids = reportDRs;
    var userCode = UserParam;
    var paramList = param;
    var connectString = me.ConnectString;
    var printType = "PrintPreview";
    var clsName = "HIS.DHCReportPrint";
    var funName = "QueryPrintData";
	var Param = printFlag + "@" + "" + "@" + reportDRs + "@" + UserParam + "@" + printType + "@" + paramList;
	HISBasePrint(Param);
	return;
	
	//下面为旧的打印方式
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
	try
	{
    	if (reportDRs) objPrintPreview.PrintPreview(reportDRs, UserParam, param, connectString);
	} 
	catch(e)
	{
		var printFlag = "0";       ///0:打印所有报告 1:循环打印每一份报告
        var printType = "PrintPreview";    ///PrintOut:打印  PrintPreview打印预览
        var paramList = "LIS";               ///1:报告处理打印 2:自助打印 3:医生打印
		var Param = printFlag + "@" + connectString + "@" + reportDRs + "@" + UserParam + "@" + printType + "@" + paramList
		LISBasePrint(Param);
	}

}

//集中打印
function printCentralClick() {
	var admNo = $('#cb_admList').combobox("getValue");
	param="DOCTOR"
	connectString=me.ConnectString
	var UserParam=UserId + "^" + HospID
	var printFlag = "0";       ///0:打印所有报告 1:循环打印每一份报告
    var printType = "PrintPreviewOld";    ///PrintOut:打印  PrintPreview打印预览
    var paramList = "LIS";               ///1:报告处理打印 2:自助打印 3:医生打印
    var clsName = "HIS.DHCCentralPrint";
    var funName = "QueryPrintData";
	var Param = printFlag + "@" + connectString + "@" + admNo + "@" + UserParam + "@" + printType + "@" + paramList +"@"+clsName+"@"+funName;
		
	PrintCommon(Param);
	return;
	
	//下面为旧的打印方式	
	try
	{
    	if (admNo) objPrintPreview.PrintOut(admNo, UserParam, param, connectString,"HIS.DHCCentralPrint","QueryPrintData");  
	}	
	catch(e)
	{
		var printFlag = "0";       ///0:打印所有报告 1:循环打印每一份报告
        var printType = "PrintPreview";    ///PrintOut:打印  PrintPreview打印预览
        var paramList = "LIS";               ///1:报告处理打印 2:自助打印 3:医生打印
		var Param = printFlag + "@" + connectString + "@" + admNo + "@" + UserParam + "@" + printType + "@" + paramList
		HISBasePrint(Param);
	}
}

//浏览全部
function ViewAllReportClick()
{
	var reportDRs = "";
	param="DOCTOR"
	connectString=me.ConnectString
	var UserParam=UserId + "^" + HospID
	try
	{
    	objPrintPreview.ViewAll(reportDRs, UserCode, param, connectString); 
	}
	catch(e)
	{
		//0:打印所有报告 1:循环打印每一份报告
    	var printFlag = "0";       
    	var rowids = "" ;
    	//打印用户 
		var userCode = UserID;
    	//1:报告处理打印 2:自助打印 3:医生打印
    	var paramList = "OTH";              
    	//PrintOut:打印  PrintPreview打印预览,ReportView报告浏览
    	var printType = "ReportView";
    	var Param = printFlag +"@" + WebServicAddress +"@" + rowids +"@" + userCode +"@" + printType +"@" + paramList
		LISBasePrint(Param);
	}
}


//报告结果查看
function ShowReportResult(VisitNumberReportDR) {
	 if (VisitNumberReportDR == "") {
		 $("#div_ReportResultEast").panel("setTitle","报告结果");
	 }
	$('#dg_ReportResult').datagrid({
        url:'jquery.easyui.dhclabclassjson.csp',
		queryParams: { 
		    //不依赖检验基础数据请调用"LIS.WS.BLL.DHCQryTestItemsForViewRep"
			ClassName:"LIS.WS.BLL.DHCRPVisitNumberReportResult",
			QueryName:"QryTSInfo",
			FunModul:"JSON",
			P0:VisitNumberReportDR
		},
        method: 'get',
        fitColumns: false,  //列少设为true,列多设为false
        fit:true,
        collapsible: true,
        rownumbers: true,
        pagination: false,
        pagePosition: 'bottom',
        pageSize: 10,
        pageList: [10, 20, 50, 100, 200],
        singleSelect: true,
        selectOnCheck: false,
        checkOnSelect: false,
        nowwarp: false,  //折行
        border: false,
        remoteSort: false,
        columns: [[
              { field: 'TestCodeDR', title: '项目id', width: 150,  hidden:true, align: 'left' },
              { field: 'Synonym', title: '缩写', width: 50, sortable: false, align: 'center' },
              { field: 'TestCodeName', title: '项目名称', width: 140,  align: 'left' },
              { field: 'Result', title: '结果', width: 130, align: 'center'
              ,styler: function (value, rowData, rowIndex) {
                        var colStyle = "color:#000000";
                        if (value != "") {
                            //if (!isNaN(value)) {   ///数字类型
                                if (rowData.AbFlag == "L") { colStyle = 'color:blue;' };
                                if (rowData.AbFlag == "H") { colStyle = 'color:red;' };
                                 if (rowData.AbFlag == "A") { colStyle = 'color:red;' };
                                if (rowData.AbFlag == "PL") { colStyle = 'background-color:red;color:blue;' };
                                if (rowData.AbFlag == "PH") { colStyle = 'background-color:red;color:#ffee00;' };
                                if (rowData.AbFlag == "UL") { colStyle = 'background-color:red;color:blue;' };
                                if (rowData.AbFlag == "UH") { colStyle = 'background-color:red;color:#ffee00;' };
                           // }
                        return colStyle;
                        }
                    }
               },
 	           { field: 'ExtraRes', title: '结果提示', width: 60, align:'left' },
              { field: 'AbFlag', title: '异常提示', width: 50, sortable: false, align: 'center',
                  styler: function(value, rowData, rowIndex) {
                        var colStyle = "color:#000000";
                        if (value != "") {
                            ///数字类型
                            if (value == "L") { colStyle = 'color:blue;' };
                            if (value == "H") { colStyle = 'color:red;' };
                            if (value == "A") { colStyle = 'color:red;' };
                            if (value == "PL") { colStyle = 'background-color:red;color:blue;' };
                            if (value == "PH") { colStyle = 'background-color:red;color:#ffee00;' };
                            if (value == "UL") { colStyle = 'background-color:red;color:blue;' };
                            if (value == "UH") { colStyle = 'background-color:red;color:#ffee00;' };
                            return colStyle;
                            }
                    },
                    formatter: function(value, rowData, rowIndex){
	          			if (rowData.MultipleResistant=="1")
	          			{
	          				return '<span style="font-weight:bold;color:red;font-size:14px;">【多耐】</span>';
	        			}  	
	        			return value;
	       			 } 
              },
              { field: 'Units', title: '单位', width: 90, sortable: false, align: 'left' },
              { field: 'RefRanges', title: '参考范围', width: 100, sortable: false, align: 'center' },
              { field: 'PreResult', title: '前次结果', width: 100, sortable: false, align: 'center',formatter:HistoryIconPrompt,
                styler: function (value, rowData, rowIndex) {
                        var colStyle = "color:#000000";
                        if (value != "") {
                            if (!isNaN(value)) {   ///数字类型
                                if (rowData.PreAbFlag == "L") { colStyle = 'color:blue;' };
                                if (rowData.PreAbFlag == "H") { colStyle = 'color:red;' };
                                if (rowData.PreAbFlag == "PL") { colStyle = 'background-color:red;color:blue;' };
                                if (rowData.PreAbFlag == "PH") { colStyle = 'background-color:red;color:#ffee00;' };
                                if (rowData.PreAbFlag == "UL") { colStyle = 'background-color:red;color:blue;' };
                                if (rowData.PreAbFlag == "UH") { colStyle = 'background-color:red;color:#ffee00;' };
                            }
                        return colStyle;
                        }
                    }
              },
              { field: 'PreAbFlag', title: '前次异常提示', width: 90, sortable: false,hidden: true, align: 'center'},
              { field: 'ResClass', title: '危急提示', width: 90, hidden:true,sortable: false, align: 'center',
                styler: function (value, rowData, rowIndex) {

                }
              },
             { field: 'MachineParameterDesc', title: '检验仪器', width: 90, align: 'center' },
             { field: 'TestMethodName', title: '检测方法', width: 80, align: 'center' },
              { field: 'ClinicalSignifyS', title: '临床意义', width: 150, sortable: false, align: 'center'}
            ]],
        onLoadSuccess: function (data) {
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
			             async: false,
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
						        htmlStr+="<table style='font-size:12px;padding-top:10;width:430'>";
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
											kb="&nbsp";
										}
										htmlStr+="<td>"+kb+"</td>";
										htmlStr+="<td>"+mic+"</td>";
										htmlStr+="<td>"+retData["rows"][index]["SensitivityName"]+"</td>";
										htmlStr+="</tr>";
								 }
								 htmlStr+="</table>";
						         $('#dg_ReportResult').prev().children(".datagrid-body").append(htmlStr);
						         
					         }
				         }
		            })
		            //查询耐药机制结果
		            $.ajax({
			             url:'jquery.easyui.dhclabclassjson.csp',
			             async: false,
						 data: { 
							 ClassName:"LIS.WS.BLL.DHCRPMicNumberReport",
							 QueryName:"QryReportResultRst",
							 FunModul:"JSON",
							 P0:data[i]["ReportResultDR"]
						 },
				         success: function (retData) {
					         var htmlStr="";
					         retData = jQuery.parseJSON(retData)
					         if(retData["rows"] != undefined && retData["rows"].length >0){
						        htmlStr+="<table style='font-size:12px;padding-top:10;width:430'>";
						        htmlStr+="<tr><td><b>耐药机制</b></td></tr>";
								for(var index=0;index<retData["rows"].length;index++) {
									  htmlStr+="<tr>";
									  	htmlStr+="<td>"+retData["rows"][index]["ResistanceItemName"]+"</td>";
										var resItem=jQuery.parseJSON(retData["rows"][index]["ResItem"]);
										var result=retData["rows"][index]["Result"];
										if(resItem.length>0)
										{
											for(var i=0;i<resItem.length;i++)
											{
												if(resItem[i].id==result)
												{
													result=resItem[i].text;
													break;
												}
											}
										}
										htmlStr+="<td>"+result+"</td>";
									  htmlStr+="</tr>";
								 }
								 htmlStr+="</table>";
						         $('#dg_ReportResult').prev().children(".datagrid-body").append(htmlStr);
					         }
				         }
		            })
	            }  
	            if(data[i]["ExpertRule"] != undefined &&data[i]["ExpertRule"]!=""){
	           		var ExpertRulestring ='<table style="width:100%"><tr><td style="width:75px"><b>专家规则：</b></td> <td> <div style="border:1px solid #000">'+data[i]["ExpertRule"]+'</div> </td></tr></table>';
	            	$('#dg_ReportResult').prev().children(".datagrid-body").append(ExpertRulestring); 
	        	}
            }
            var selectedRow=$('#dgOrdItmList').datagrid('getSelected');
            if (selectedRow==null) return;
            if(selectedRow.MajorConclusion != undefined &&selectedRow.MajorConclusion.length>0){
	           var TSMemostring ='<table style="width:100%"><tr><td style="width:75px"><b>报告评价：</b></td> <td> <div style="border:1px solid #000">'+selectedRow.MajorConclusion+'</div> </td></tr></table>';
	            $('#dg_ReportResult').prev().children(".datagrid-body").append(TSMemostring); 
	        }
        },
        onDblClickRow: function (rowIndex, rowData) {
            CheckAdmData();
        }
    });
};
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
	    if (rowData["ResultFormat"] == "N")
       		a.push(value + "&nbsp;<a style='text-decoration:none;' href=\"javascript:void(ShowHistoryResult('"+rowData.ReportDR +"','"+rowData.TestCodeDR+ "'));\"><span class='icon-chart_curve' title='结果曲线图'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;");
       	else 
       		a.push(value);
    }
    return a.join("");
}

/////结果曲线图
function ShowHistoryResult(VisitNumberReportDR,TestCodeDR) {
    $('#win_ResultCharts').window('open');
    $('#h_ResultCharts').text("结果曲线图");
    var t = $(this);

    $.ajax({
        url:'jquery.easyui.dhclabclassjson.csp',
		data: { 
			ClassName:"LIS.WS.BLL.DHCRPVisitNumberReportResult",
			QueryName:"GetHistoryResultMTHD",
			FunModul:"MTHD",
			P0:VisitNumberReportDR,
			P1:TestCodeDR
		},
        success: function (data) {
             data = jQuery.parseJSON(data)
             if (typeof (data) != "undefined") {
                        var rowData = data.rows[0];
                        var row = data.dataHead[0];
                        var xAxisArr = new Array();
                        var GridDate = new Array();
                        var GridResult = new Array();
                        $.each(row, function (i, v) {
                            if (i.indexOf("Col") >= 0) {
                                //如果非数值类型的
                                if (rowData["ResultFormat"] != "N") {
                                    //组合datagrid数据
                                    GridDate.push(v);
                                } else {
                                    xAxisArr.push(v.split(' ')[0]); //图形显示的x轴
                                }
                            }
                        });
                        var lineData = new Array();
                        var max = '';
                        var min = '';
                        $.each(rowData, function (i, v) {
                            if (i.indexOf("Col") >= 0) {
                                //判断是否为数值型的(N)
                                if (rowData["ResultFormat"] != "N") {
                                    //不是数值类型的表格显示
                                    GridResult.push(v);
                                } else {
                                    lineData.push(parseFloat(v));
                                }
                            }
                            if (i == 'RefRanges1') {
                                max = parseFloat(v.split('-')[1]);
                                min = parseFloat(v.split('-')[0]);
                            }
                        });
                        //载入表格数据
                        if (rowData["ResultFormat"] != "N") {
                            var DatagridData = new Array();
                            for (var i = 0; i < GridDate.length; i++) {
                                var row = {};
                                row["Date"] = GridDate[i];
                                row["Result"] = GridResult[i];
                                DatagridData.push(row);
                            }
                            $("#div_ResultCharts").html("<table id='dg_historyResultList'></table>");
                            $("#dg_historyResultList").datagrid({
                                fit: true,
                                fitColumns: true,
                                columns: [[
                                { field: 'Date', title: '时间', width: 100, align: "center" },
                                { field: 'Result', title: '结果', width: 300, align: "center" },
                            ]]
                            });
                            $("#dg_historyResultList").datagrid("loadData", DatagridData)
                            return;
                        }
                        if ($("#dg_historyResultList").length > 0) {
                            $("#dg_historyResultList").remove();
                        }
                        var unit = rowData.Units;
                        var legenData = [rowData.TestCodeName];
                        if (lineData.length == 0) return;
                        lineCharts('div_ResultCharts', rowData.TestCodeName, unit, xAxisArr, lineData, legenData, max, min, 3, rowData["ResultFormat"]);
            }
        }
    });
}

///显示打印记录
function ShowPrintHistory(ReportDR) {
	if(ReportDR=="") return;
	if(ReportDR.split(",").length > 1) ReportDR = ReportDR.split(",")[0];
	 $("#win_PrintHistory").window('open');
     $("#dg_PrintHistory").datagrid({
        url: "jquery.easyui.dhclabclassjson.csp",
        queryParams: { 
			ClassName:"LIS.WS.BLL.DHCRPVisitNumberReportPrint",
			QueryName:"QryReportPintHistoryList",
			FunModul:"JSON",
			P0:ReportDR
		},
        fit: true,
        rownumbers: true,
        columns: [[
	        {
	            field: 'PrintDT', title: '打印时间', width: 150, align: 'left',
	            formatter: function (value, row, index) {
	                return row["PrintDate"] + "&nbsp;&nbsp;" + row["PrintTime"];
	            }
	        },
	        { field: 'PrintedUserName', title: '打印者', width: 100, align: 'center' },
	        {
	            field: 'ModuleID', title: '打印类型', width: 100, align: 'center',
	            formatter: function (value, row, index) {
	                if (value == "LIS") {
	                    return "检验科打印";
	                }
	                if (value == "DOCTOR") {
	                    return "医生打印";
	                }
	            }
	        }
        ]]
    });
}

///显示阅读记录
function ShowReadLog(ReportDR) {
	if(ReportDR=="") return;
	if(ReportDR.split(",").length > 1) ReportDR = ReportDR.split(",")[0];
	$("#win_ReadLog").window('open');
     $("#dg_ReadLog").datagrid({
        url: "jquery.easyui.dhclabclassjson.csp",
        queryParams: { 
			ClassName:"LIS.WS.BLL.RPVisitNumberReportReadQuery",
			QueryName:"QryReadRecord",
			FunModul:"JSON",
			P0:ReportDR
		},
        fit: true,
        rownumbers: true,
        columns: [[
	        {
	            field: 'PrintDT', title: '阅读时间', width: 150, align: 'left',
	            formatter: function (value, row, index) {
	                return row["ReadDate"] + "&nbsp;&nbsp;" + row["ReadTime"];
	            }
	        },
	        { field: 'ReadDoctorName', title: '阅读者', width: 100, align: 'center' },
        ]]
    });
}


//获取当前时间
function GetCurentDate() {
    var now = new Date();

    var year = now.getFullYear();       //年
    var month = now.getMonth() + 1;     //月
    var day = now.getDate();            //日

    var hh = now.getHours();            //时
    var mm = now.getMinutes();          //分

    var clock = year + "-";

    if (month < 10)
        clock += "0";

    clock += month + "-";

    if (day < 10)
        clock += "0";

    clock += day;

    return (clock);
}
var zPrintIframeIndex=0;
//检验基础打印,调插件的统一入口
function LISBasePrint(para) {
   if (localStorage["iMedicalLISPrintExtendFlag"] == "3") {
      var iframeName = "zPrintIframe" + zPrintIframeIndex;
      zPrintIframeIndex++;
      //添加一个弹窗依托的div，作为弹出消息框
      $(document.body).append('<iframe id="' + iframeName + '" src="' + "iMedicalLIS://" + para + '" style="display:none;"><iframe>');
      setTimeout(function () {
        $("#" + iframeName).remove();
      }, 2500);
   }
   else {
      var win = window.open("iMedicalLIS://" + para, "打印等待", "height=750,width=650,top=10,left=10,titlebar =no,toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no, status=no,alwaysLowered=no");
      if(localStorage["iMedicalLISPrintExtendFlag"]==""||isNaN(localStorage["iMedicalLISPrintExtendFlag"]))
      {
      	//调用标识
      	localStorage["iMedicalLISPrintExtendFlag"] = "1";
      }
      else
      {
	    //调用标识
      	localStorage["iMedicalLISPrintExtendFlag"] = parseInt(localStorage["iMedicalLISPrintExtendFlag"])+1;
      }
   }
}

//新的打印方式
function PrintCommon(Param) {
	
	//var Param = printFlag + "@" + connectString + "@" + reportDRs + "@" + UserParam + "@" + printType + "@" + paramList;
	var printUrl="http://"+ webIP +"/imedicallis/lisprint/print2HIS/ResultPrintForHis.application?Param="+Param;
	document.location.href=printUrl;
	
}


//Desc图标文字
function getIconHtmlI(Desc, Color, BackGroundColor) {
    if (Color == undefined || Color.length == 0 || Color == null) Color = '#FFF';
    if (BackGroundColor == undefined || BackGroundColor.length == 0 || BackGroundColor == null) BackGroundColor = '#fd5454';
    var retHtml = '<div style=" background-color:' + BackGroundColor + ';display:inline-block;border-radius:4px;width:16px;height:16px;text-align:center" ';
    retHtml += '><span style="color:' + Color + ';font-size:10px;text-align:center">' + Desc + '</span></div>';
    return retHtml;
}