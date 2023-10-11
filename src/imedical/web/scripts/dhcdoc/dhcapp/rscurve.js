$(function(){
	  var VisitNumberReportDR=$("#VisitNumberReportDR").val();
	  var TestCodeDR=$("#TestCodeDR").val();
	  $cm({
			ClassName:"web.DHCENS.STBLL.Method.PostReportInfo",
			MethodName:"GetHistoryResultMTHD",
			VisitNumberReportDR:$("#VisitNumberReportDR").val(),
			TestCodeDR:$("#TestCodeDR").val(),
			 SttDate:"", EndDate:"", P4:"", P5:"", P6:"", P7:"", P8:"", P9:"", P10:"", P11:"", 
			 P12:"", P13:"",
			RowCount:"",
		},function(jsonData){
			data = jsonData //jQuery.parseJSON(jsonData)
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
		});
	})