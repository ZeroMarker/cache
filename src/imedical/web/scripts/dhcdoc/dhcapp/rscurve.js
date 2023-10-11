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
                                //�������ֵ���͵�
                                if (rowData["ResultFormat"] != "N") {
                                    //���datagrid����
                                    GridDate.push(v);
                                } else {
                                    xAxisArr.push(v.split(' ')[0]); //ͼ����ʾ��x��
                                }
                            }
                        });
                        var lineData = new Array();
                        var max = '';
                        var min = '';
                        $.each(rowData, function (i, v) {
                            if (i.indexOf("Col") >= 0) {
                                //�ж��Ƿ�Ϊ��ֵ�͵�(N)
                                if (rowData["ResultFormat"] != "N") {
                                    //������ֵ���͵ı����ʾ
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
                        //����������
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
                                { field: 'Date', title: 'ʱ��', width: 100, align: "center" },
                                { field: 'Result', title: '���', width: 300, align: "center" },
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