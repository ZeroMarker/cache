//页面加载
var me = {
	VisitNumberReportDR:""
}

$(function() {
    pageInit();
});

function pageInit() {
	//科室
	$('#cmb_Location').combogrid({    
	    panelWidth:210,    
	    idField:'RowID',    
	    textField:'CName',    
	    url:'jquery.easyui.dhclabclassjson.csp',    
	    queryParams: {
			ClassName:"DHCLIS.DHCBTQuery",
			QueryName:"QueryLocation",
			FunModul:"JSON",
			rows:150,
			P0:session['LOGON.HOSPID']
		},
	    columns:[[    
	        {field:'CName',title:'科室名称',width:190}  
	    ]],
	    onSelect:function(index,row) {
		    $.ajax({
			    url:'jquery.easyui.dhclabclassjson.csp',
				data:{
					ClassName:"DHCLIS.DHCBTQuery",
					QueryName:"QueryWard",
					FunModul:"JSON",
					P0:row.RowID
				},
				type:"get",
				dataType:"json",
				success:function(data) {
					$('#cmb_Ward').combobox("loadData",data["rows"]);
				}
		    })
		}    
	});
	//病区
	$('#cmb_Ward').combobox({    
	    panelWidth:150,    
	    valueField:'RowID',    
	    textField:'CName'
	});
	//医生数据
	$('#cmb_Doctor').combogrid({    
	    panelWidth:210,    
	    idField:'RowID',    
	    textField:'CName',
	    url:'jquery.easyui.dhclabclassjson.csp',
		queryParams:{
			ClassName:"DHCLIS.DHCBTQuery",
			QueryName:"QueryDoctor",
			FunModul:"JSON"
		},
		type:"get", 
	    columns:[[    
	        {field:'CName',title:'医生',width:190}  
	    ]]  
	});
	var thisDate = GetCurentDate();
	$('#dt_FindSttDate').datebox('setValue',thisDate);
	$('#dt_FindEndDate').datebox('setValue',thisDate);
	
	$('#text_RegNo').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findOrdItmList();
        }
    });
    
    ShowPanicReportList();
    findOrdItmList();
}   ///pageInit


var findOrdItmList = function (){
	var AuthFlag = 0;
	var SttDate = $('#dt_FindSttDate').datebox('getValue');
    var EndDate = $('#dt_FindEndDate').datebox('getValue');
    var LocationDR = $("#cmb_Location").combogrid('getValue');
    var WardDR = $("#cmb_Ward").combobox('getValue');
//    var RegNo = $("#text_RegNo").val();
//	if (document.getElementById("selectAuthedReport").checked) {
//		AuthFlag = 1;
//	}
//	if (!document.getElementById("selectIsNeedDate").checked && RegNo.length) {
//		SttDate="";
//		EndDate="";
//	}
	var DoctorDR = $("#cmb_Doctor").combogrid('getValue');
//    if (RegNo.length>0 && RegNo.length < 10) {
//	     var i=0;
//		 i=10-RegNo.length;
//		 var pre=""
//		 for (var j=0;j<i;j++) {
//			 pre=pre+"0";
//		 }
//		 RegNo=pre+RegNo;
//		 $("#text_RegNo").val(RegNo);
//    }
	$('#dgPanicReportList').datagrid("load",{ 
		ClassName:"DHCLIS.DHCLISPanicReport",
		QueryName:"QueryPanicReport",
		FunModul:"JSON",
		P0:LocationDR, 
		P1:WardDR, 
		P2:SttDate,
		P3:EndDate,   
		P4:session['LOGON.HOSPID'],  
		P5:DoctorDR, 
		P6:"",  
		P7:"", 
		P8:""
	});
}

//打开报告置成已读
var SetReadedFlag = function(){
	var UserId = session['LOGON.USERID'];
	var selectedRow = $("#dgPanicReportList").datagrid("getSelected")
	if (selectedRow.length==0) return;
	var OrderID = selectedRow["OEOrdItemID"]
	var EpisodeID = selectedRow["LabEpisode"]
	$.ajaxRunServerMethod({ClassName:"web.DHCLabReportControl",MethodName:"AddViewLog",UserId:UserId,EpisodeID:EpisodeID,PatientID:PatientID,OrderID:OrderID},
	   function(rtn){
		   if (rtn == "1") {
			   $.messager.show({
					title:'提示消息',
					msg:'阅读成功!',
					timeout:2000,
					showType:'slide'
				});
				$('#dgPanicReportList').datagrid("reload");
		   }
		}
	);
	//AddViewLog(USERID,EpisodeID,PatientID,OrderID)
}

//显示危急报告
function ShowPanicReportList() {
    $('#dgPanicReportList').datagrid({	
    	url:'jquery.easyui.dhclabclassjson.csp',
		method: 'get',
		queryParams: { 
			ClassName:"DHCLIS.DHCLISPanicReport",
			QueryName:"QueryPanicReport",
			FunModul:"JSON",
			P0:"", 
			P1:"", 
			P2:"",
			P3:"",   
			P4:"",  
			P5:"", 
			P6:"",  
			P7:"", 
			P8:""
		},		
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		pageList: [20, 50, 100, 200],
		striped:true,
		nowrap: false, 
		border: true,
		collapsible: true,
		singleSelect:true,
		selectOnCheck: false,
        checkOnSelect: false,
		fit:true, 
        columns: [[
          { field: 'TestSetName', title: '医嘱名称', width: 180, sortable: true, align: 'left' },
          { field: 'SurName', title: '病人姓名', width: 60, sortable: true, align: 'center' },
          { field: 'SpecimenName', title: '标本', width: 80, sortable: true, align: 'left' },
          { field: 'AuthDateTime', title: '报告时间', width: 120, sortable: true, align: 'center' },
          { field: 'MajorConclusion', title: '危机提示', width: 150, sortable: true, align: 'left' },
          { field: 'DoctorName', title: '申请医生', width: 60, sortable: true, align: 'center' },
          { field: 'LocationName', title: '申请科室', width: 100, sortable: true, align: 'left' },
          { field: 'VisitNumberReportDR', title: '报告', width:90, sortable: true, align: 'center', formatter: ResultIconPrompt 
         
          },
          { field: 'RegNo', title: '登记号', width: 100, sortable: true, align: 'center'}
 
        ]]
    });
}; //ShowOrdItmListsGrid

//结果图标显示
function ResultIconPrompt(value, rowData, rowIndex) {
	if (rowData.VisitNumberReportDR.length)
       	return "<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(" + rowData.VisitNumberReportDR + "))';><span class='icon-urgent' color='red' title='危机值结果')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>报告结果</a>";
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

//窗口id ，标题，请求页面，宽 ，高
function showwin(winid, title, url, mywidth, myheight, draggable) {//修改和添加的弹出框
	alert(url);
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
	for (var i in checkedRows) {
		if (checkedRows[i]["ResultStatus"] != "3") {
			$.messager.alert('操作提示','报告'+checkedRows[i]["OrdItemName"]+"未出报告，不能打印！");
			return;
		}
		if (reportDRs.length > 0)
			reportDRs = reportDRs+","+checkedRows[i]["VisitNumberReportDR"];
		else 
			reportDRs = checkedRows[i]["VisitNumberReportDR"]
	}
	reportDRs=2
	var a = $("<a href='/imedicallis/facade/ui/frmRepostPrint.aspx?reportDRs="+reportDRs +"'target='_blank'></a>").get(0);  
              
            var e = document.createEvent('MouseEvents');  
  
            e.initEvent('click', true, true);  
            a.dispatchEvent(e);  
	
}


//报告结果查看
function ShowReportResult(VisitNumberReportDR) {
	$('#dg_ReportResult').datagrid({
        url:'jquery.easyui.dhclabclassjson.csp',
		queryParams: { 
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
        selectOnCheck: true,
        checkOnSelect: false,
        nowwarp: false,  //折行
        border: true,
        remoteSort: false,
        columns: [[
              { field: 'TestCodeDR', title: '项目id', width: 150,  hidden:true, align: 'left' },
              { field: 'Synonym', title: '缩写', width: 50, sortable: true, align: 'center' },
              { field: 'TestCodeName', title: '项目名称', width: 150,  align: 'left' },
              { field: 'Result', title: '结果', width: 90, align: 'center'
              ,styler: function (value, rowData, rowIndex) {
                        var colStyle = "color:#000000";
                        if (value != "") {
                            if (!isNaN(value)) {   ///数字类型
                                if (rowData.AbFlag == "L") { colStyle = 'color:blue;' };
                                if (rowData.AbFlag == "H") { colStyle = 'color:red;' };
                                if (rowData.AbFlag == "PL") { colStyle = 'background-color:red;color:blue;' };
                                if (rowData.AbFlag == "PH") { colStyle = 'background-color:red;color:#ffee00;' };
                                if (rowData.AbFlag == "UL") { colStyle = 'background-color:red;color:blue;' };
                                if (rowData.AbFlag == "UH") { colStyle = 'background-color:red;color:#ffee00;' };
                            }
                        return colStyle;
                        }
                    }
               },
              { field: 'AbFlag', title: '异常提示', width: 60, sortable: true, align: 'center',
                  styler: function(value, rowData, rowIndex) {
                        var colStyle = "color:#000000";
                        if (value != "") {
                            ///数字类型
                            if (value == "L") { colStyle = 'color:blue;' };
                            if (value == "H") { colStyle = 'color:red;' };
                            if (value == "PL") { colStyle = 'background-color:red;color:blue;' };
                            if (value == "PH") { colStyle = 'background-color:red;color:#ffee00;' };
                            if (value == "UL") { colStyle = 'background-color:red;color:blue;' };
                            if (value == "UH") { colStyle = 'background-color:red;color:#ffee00;' };
                            return colStyle;
                            }
                    }
              },
              { field: 'Units', title: '单位', width: 90, sortable: true, align: 'left' },
              { field: 'RefRanges', title: '参考范围', width: 100, sortable: true, align: 'center' },
              { field: 'PreResult', title: '前次结果', width: 100, sortable: true, align: 'center',formatter:HistoryIconPrompt,
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
              { field: 'PreAbFlag', title: '前次异常提示', width: 90, sortable: true,hidden: true, align: 'center'},
              { field: 'ResClass', title: '危急提示', width: 90, hidden:true,sortable: true, align: 'center',
                styler: function (value, rowData, rowIndex) {

                }
              },
              { field: 'ClinicalSignifyS', title: '临床意义', width: 150, sortable: true, align: 'center'}
            ]],
//        onLoadSuccess: function (data) {
//            $('#ReportContent').datagrid('clearSelections');
//        },
        onDblClickRow: function (rowIndex, rowData) {
            CheckAdmData();
        }
    });
};

///历史结果图标
function HistoryIconPrompt(value, rowData, rowIndex) {
    var a = [];
    if (value != "" && rowData.TestCodeName != "备注") {
       a.push(value + "&nbsp;<a style='text-decoration:none;' href=\"javascript:void(ShowHistoryResult('",  me.VisitNumberReportDR,"','",rowData.TestCodeDR, "'));\"><span class='icon-chart_curve' title='结果曲线图'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;");
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
                $.each(row, function (i, v) {
                    if (i.indexOf("Col") >= 0)
                        xAxisArr.push(v.split(' ')[0]); //图形显示的x轴
                });
                var lineData = new Array();
                var max = '';
                var min = '';
                $.each(rowData, function (i, v) {
                    if (i.indexOf("Col") >= 0) {
                        lineData.push(parseFloat(v));
                    }
                    if (i == 'RefRanges1') {
                        max = parseFloat(v.split('-')[1]);
                        min = parseFloat(v.split('-')[0]);
                    }
                });
                var unit = rowData.Units;
                var legenData = [rowData.TestCodeName];
                lineCharts('div_ResultCharts', rowData.TestCodeName, unit, xAxisArr, lineData, legenData, max, min)
            }
        }
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