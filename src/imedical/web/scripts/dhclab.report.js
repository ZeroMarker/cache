//页面加载

$(function() {
	var MajorConclusion="";
    pageInit();
});
//记录是否展示病人更多信息
var showMoreInfoOpen=0;
function pageInit() {
	ShowLabInformation(VisitNumberReportDR);
	loadReportGrid(VisitNumberReportDR);
	
	
	if (ReadFlag==1){
		$('#btn_confirmReaded').hide();
	}
}   ///pageInit


function loadReportGrid(VisitNumberReportDR) {
	$('#ReportContent').datagrid({
        url:'jquery.easyui.dhclabclassjson.csp',
		queryParams: { 
			ClassName:"LIS.WS.BLL.DHCRPVisitNumberReportResult",
			QueryName:"QryTSInfo",
			FunModul:"JSON",
			P0:VisitNumberReportDR
		},
        method: 'get',
        fitColumns: true,  //列少设为true,列多设为false
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
                            
                            if (rowData.AbFlag == "L") { colStyle = 'color:blue;' };
                            if (rowData.AbFlag == "H") { colStyle = 'color:red;' };
                            if (rowData.AbFlag == "PL") { colStyle = 'background-color:red;color:blue;' };
                            if (rowData.AbFlag == "PH") { colStyle = 'background-color:red;color:#ffee00;' };
                            if (rowData.AbFlag == "UL") { colStyle = 'background-color:red;color:blue;' };
                            if (rowData.AbFlag == "UH") { colStyle = 'background-color:red;color:#ffee00;' };
                            
                        return colStyle;
                        }
                    }
               },
              { field: 'ExtraRes', title: '结果提示', width: 90, align:'left' },
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
                    },
                    formatter: function(value, rowData, rowIndex){
	          			if (rowData.MultipleResistant=="1")
	          			{
	          				return '<span style="font-weight:bold;color:red;font-size:14px;">【多耐】</span>';
	        			}  	
	        			return value;
	       			 } 

              },
              { field: 'Units', title: '单位', width: 90, sortable: true, align: 'left' },
              { field: 'RefRanges', title: '参考范围', width: 100, sortable: true, align: 'center' },
              { field: 'HelpDisInfo', title: '辅助诊断', width: 100, sortable: true, align: 'center',
              	formatter: function(value,row,index){
					if (value.length > 0){
						return '<a class="popover1" data-toggle="popover" data-title="'+row["TestCodeName"]+'['+row["Result"]+']--辅助诊断" data-content="'+value+'" >聚焦显示</a>';
					}
				}
              },
              
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
              { field: 'MachineParameterDesc', title: '检验仪器', width: 90, align: 'center' },
             { field: 'TestMethodName', title: '检测方法', width: 80, align: 'center' },
              { field: 'ClinicalSignifyS', title: '临床意义', width: 150, sortable: true, align: 'center'}
            ]],
        onLoadSuccess: function (data) {
            $('#ReportContent').datagrid('clearSelections');
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
						        htmlStr+="<table style='font-size:12px;padding-top:10;width:880;text-align:center'>";
						        htmlStr+="<tr><td colspan='10'><span style='color:red;font-weight:bold'>"+TSNames[retData["rows"][0]["VisitNumberReportResultDR"]]
						        if(ClonyNum[retData["rows"][0]["VisitNumberReportResultDR"]] != undefined && ClonyNum[retData["rows"][0]["VisitNumberReportResultDR"]].length > 0)
						        	htmlStr+="</span>----<span style='font-weight:bold'>菌落计数：</span>"+ClonyNum[retData["rows"][0]["VisitNumberReportResultDR"]];
						        	if(ClonyForms[retData["rows"][0]["VisitNumberReportResultDR"]] != undefined && ClonyForms[retData["rows"][0]["VisitNumberReportResultDR"]].length > 0)
						        htmlStr+="</span>----<span style='font-weight:bold'>菌落形态：</span>"+ClonyForms[retData["rows"][0]["VisitNumberReportResultDR"]];
						        htmlStr+="</td></tr>";
						        if(ResNoes[retData["rows"][0]["VisitNumberReportResultDR"]] != undefined && ResNoes[retData["rows"][0]["VisitNumberReportResultDR"]].length > 0)
						        	htmlStr+="<tr><td colspan='10'><span style='font-weight:bold'>备注：</span>"+ResNoes[retData["rows"][0]["VisitNumberReportResultDR"]]+"</td></tr>";
								htmlStr+="<tr style='font-weight:bold'>";
								htmlStr+="<td>抗生素名称</td>";
								htmlStr+="<td>缩写</td>";
								htmlStr+="<td>KB(mm)</td>";
								htmlStr+="<td>MIC(ug/ml)</td>";
								htmlStr+="<td>结果</td>";
								htmlStr+="<td> </td>";
								htmlStr+="<td>抗生素名称</td>";
								htmlStr+="<td>缩写</td>";
								htmlStr+="<td>KB(mm)</td>";
								htmlStr+="<td>MIC(ug/ml)</td>";
								htmlStr+="<td>结果</td>";
								htmlStr+="</tr>";
								var kb=""
								var mic=""
								for(var index=0;index<retData["rows"].length;index = index+2) {
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
										if (retData["rows"][index+1] != undefined) {
											htmlStr+="<td> </td>";
											htmlStr+="<td>"+retData["rows"][index+1]["AntibioticsName"]+"</td>";
											htmlStr+="<td>"+retData["rows"][index+1]["SName"]+"</td>";
											if (retData["rows"][index+1]["SenMethod"] == "1") {
												kb=retData["rows"][index+1]["SenValue"];
												mic="&nbsp"
											} else {
												mic=retData["rows"][index+1]["SenValue"];
												kc="&nbsp";
											}
											htmlStr+="<td>"+kb+"</td>";
											htmlStr+="<td>"+mic+"</td>";
											htmlStr+="<td>"+retData["rows"][index+1]["SensitivityName"]+"</td>";
										}
										htmlStr+="</tr>";
								 }
								 htmlStr+="</table>";
						         $('#ReportContent').prev().children(".datagrid-body").append(htmlStr);
					         }
				         }
		            })
	            }
            }
            if (MajorConclusion.length > 0) {
	            
             var TSMemostring ='<table style="width:100%"><tr><td style="width:75px"><b>报告评价：</b></td> <td> <div style="border:1px solid #000">'+MajorConclusion+'</div> </td></tr></table>';
	         $('#ReportContent').prev().children(".datagrid-body").append(TSMemostring); 
            }
            $(".popover1").webuiPopover({trigger:'hover'});
        }
        
    });
};


///历史结果图标
function HistoryIconPrompt(value, rowData, rowIndex) {
    var a = [];
    if (value != "" && rowData.TestCodeName != "备注") {
        if (rowData["ResultFormat"] == "N")
       		a.push(value + "&nbsp;<a style='text-decoration:none;' href=\"javascript:void(ShowHistoryResult('"+rowData.ReportDR+"','"+rowData.TestCodeDR+"'));\"><span class='icon-chart_curve' title='结果曲线图'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;");
       	else 
       		a.push(value);
       }
    return a.join("");
}

///结果曲线图
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

//显示标本信息
function ShowLabInformation(ReportDR) {
    $.ajax({
        url:'jquery.easyui.dhclabclassjson.csp?ClassName=LIS.WS.BLL.DHCRPVisitNumberReportResult&QueryName=QryLabInformatin&FunModul=JSON&P0=' + ReportDR,
        success: function (data) {
	        data = jQuery.parseJSON(data).rows
	        var htmlStr= "";
            if (data.length > 0) {
	            htmlStr += "<div style='border-bottom: 1px solid #000;'>";
            	htmlStr += "<span style='font-size:27px;font-weight: bold; font-family: KaiTi;margin: 28px 22px 0 0;'>"+data[0].PatName+"</span>";
            	htmlStr += "<span style='font-size:16px;margin: 28px 22px 0 0;'>登记号： <span style='font-weight:bold;color: #0c32e8'>"+ data[0].RegNo +"</span></span>";
            	htmlStr += "<span style='font-size:16px;margin: 28px 22px 0 0;'>标本号：<span style='font-weight:bold;color: #0c32e8'>"+ data[0].Labno +"</span></span>";
            	
            	htmlStr += "<span style='font-size:14px;font-weight: bold;margin: 28px 22px 0 0;font-family: KaiTi;'>审核时间："+ data[0].AuthDate + " " + data[0].AuthTime +"</span>";
            	htmlStr += "<span style='font-size:14px;font-weight: bold;margin: 28px 22px 0 0;font-family: KaiTi;'>审核人："+ data[0].AuthUser+"</span>";
            	htmlStr += "<a class='easyui-linkbutton' id='bt_moreInfo' title='更多信息' href='javascript:void(0)'data-options=\"plain:true,iconCls:'icon-more'\" onclick='ShowMoreInfo();'>更多信息 </a>"
            	htmlStr += "</div>";
	            htmlStr += "<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\">";
	            htmlStr += "<tr>";
	            htmlStr += "<td>性别/年龄：<b>"+data[0].Species + "/" + data[0].Age + data[0].AgeUnit+"</b></td>"
	            htmlStr += "<td>申请科室：" + data[0].Location + "</td>"
	            htmlStr += "<td>申请医生：" + data[0].Doctor + "</td>"
	            htmlStr += "<td>流水号：<b>"+data[0].EpisodeNo+"</b></td>"
	            htmlStr += "<td>病案号：<b>" + data[0].RecordNo + "</b></td>"
	            htmlStr += "</tr>"
	            htmlStr += "<tr>";
	            htmlStr += "<td>标本/费用：<b>"+data[0].Specimen + "/" + '￥' + data[0].Price +"</b></td>"
	            htmlStr += "<td>申请病区：" + data[0].Ward + "</td>"
	            var DiagnoseRemark = data[0].Diagnose;
		        if (DiagnoseRemark.length > 15) {
		            DiagnoseRemark = "<a id='tip_MoreDiagnoseRemark' title='" + DiagnoseRemark + "'>" + DiagnoseRemark.substr(0, 15) + "&nbsp……</a>";
		        }
	            htmlStr += "<td>临床诊断：<b>" + DiagnoseRemark + "</b></td>"
	            htmlStr += "<td colspan='2'>样本备注：<b>" + data[0].Remark + "</b></td>"
	            htmlStr += "</tr>"
	            htmlStr += "<tr>";
	            htmlStr += "<td colspan='2'>采集信息："+ data[0].CollectDate + " " + data[0].CollectTime + " " + data[0].CollectUser+"</td>"
	            htmlStr += "<td colspan='3'>接收信息：" + data[0].AcceptDate + " " + data[0].AcceptTime + " " + data[0].AcceptUser + "</td>"
	            htmlStr += "</tr>"
	            htmlStr += "<tr>";
	            htmlStr += "<td colspan='2'>初审信息：" + data[0].EntryDate + " " + data[0].EntryTime + " " + data[0].EntryUser + "</td>"
	            htmlStr += "<td colspan='3'>审核信息：" + data[0].AuthDate + " " + data[0].AuthTime + " " + data[0].AuthUser+ "</td>"
	            htmlStr += "</tr>"
	            htmlStr += "</table>"
               $("#div_PatientInfo").html(htmlStr);
               $("#sp_TestSetInfo").html(data[0].TestSetDesc);
               $("#bt_moreInfo").linkbutton({
			        plain: true,
			        text: "",
			        iconCls: "icon-more"
			    });
               MajorConclusion=data[0].MajorConclusion;
              
            }
        }
    });
};

//确认阅读
function ConfirmReaded() {
	
	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCReportControl",MethodName:"AddViewLog",UserId:UserId,VisitNumberReportDRs:VisitNumberReportDR,HospID:HospID,OrderIDs:OrderID},
	   function(rtn){
		   if (rtn == "1") {
			   $.messager.show({
					title:'提示消息',
					msg:'阅读成功!',
					timeout:5000,
					showType:'slide'
				});
		   	   $('#btn_confirmReaded').hide();
		   	   websys_showModal("hide");
		   	   websys_showModal("options").CallBackFunc();
		   	   websys_showModal("close");
		   	   /*if (window.parent.document.getElementById("dgOrdItmList") == null) return;
		   	   var selectedRow=window.parent.$('#dgOrdItmList').datagrid("getSelected");
		   	   if(selectedRow!=null){
			   	    var index=window.parent.$('#dgOrdItmList').datagrid("getRowIndex",selectedRow);
			   	    window.parent.$('#dgOrdItmList').datagrid('updateRow',{
						index:index,
						row: {
							ReadFlag: '1'
						}
					});
                    window.parent.$('#btn_confirmReaded').hide();
					//affirmReadBtn
			   	}*/
		   }
		}
	);
}

///显示更多信息
function ShowMoreInfo() {
    if (showMoreInfoOpen == "0") {
        showMoreInfoOpen = "1";
        $('#div_PatientInfo').panel('resize', {
            height: 120
        });
        $('#ids').layout("resize");
    }
    else {
        showMoreInfoOpen = "0";
        $('#div_PatientInfo').panel('resize', {
            height: 35
        });
        $('#ids').layout("resize");
    }
}
