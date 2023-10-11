$(function() { 
	function initUI() {
		initEvent();
		findAllPatPainScores();
		if(episodeID!="") initSummery(episodeID)
	}
	function initEvent() {
		$("#search").on("click",findAllPatPainScores)
		$('#regNoInput').bind('keydown', function (e) {
            var regNO = $('#regNoInput').val();
            if (e.keyCode == 13 && regNO != "") {
                var regNoComplete = completeRegNo(regNO);
                $('#regNoInput').val(regNoComplete);
                findAllPatPainScores()
            }
        });
	}
    function completeRegNo(regNo) {
        var regNoNum = $cm({
            ClassName: "Nur.CommonInterface.SystemConfig",
            MethodName: "getRegNoNum"
        }, false);
        if (regNo.length < regNoNum) {
            for (var i = (regNoNum - regNo.length - 1); i >= 0; i--) {
                regNo = "0" + regNo;
            }
        }
        return regNo;
    }
    function findAllPatPainScores() {
        var scorerange=$('#scorerange').checkbox("getValue")
        var dischargeDate= $('#dischargeDate').datebox("getValue");
        var regNO = $('#regNoInput').val();
        $('#wardPatPainGrid').datagrid({
            url: $URL,
            queryParams: {
                ClassName: 'Nur.PatPainCharts',
                QueryName: 'FindWardPainScore',
                wardId: session['LOGON.WARDID'],
                scoreRange:scorerange,
                DischargeDate:dischargeDate,
                RegNo:regNO,
            },
            columns:[[
                // {field: 'IsCheck', title: '选择', checkbox: true, align: 'center'},
                {field:'bedCode',title:'床号', width:80 ,editor: 'validatebox'},
                {field:'patName',title:'姓名', width:100 ,editor: 'validatebox'},
                {field:'regNo',title:'登记号', width:120 ,editor: 'validatebox'},
                {field:'score',title:'评分', width:60,editor: 'validatebox', 
                    styler: function(value,row,index){
                        if (value >=7){
                            return 'background-color:#FF3030';
                        }
                        if (value >=4&&value <=6){
                            return 'background-color:#FFFF00';
                        }
                        if (value <=3){
                            return 'background-color:#7FFF00';
                        }
                    }
                },
                {field:'recTime',title:'评分时间', width:160,editor: 'validatebox'},
                {field:'admdate',title:'入院日期', width:180 ,editor: 'validatebox'},
                {field:'dischdate',title:'出院日期', width:180 ,editor: 'validatebox'},
                {field:'admId',title:'AdmId', width:0,editor: 'validatebox'}
            ]],
            nowrap: false,
            toolbar: '#grid_toolbar',
            rownumbers: true,
            singleSelect: true,
            pagination: true,
            pageSize: 50,
            pageList: [50,100],
            onLoadSuccess: function (data) {
                if (episodeID) {
                    data.rows.map(function (d,i) {
                        if (d.admId==episodeID) {
                            $('#wardPatPainGrid').datagrid("selectRow", i);
                        }
                    })
                }
            },
            onClickRow: PatPainClickRow,
        });
    }
    function initSummery(episodeID){
        var bedCode=tkMakeServerCall("Nur.NIS.Service.Base.Patient","GetBedCode",episodeID);
        var patName=tkMakeServerCall("Nur.PatPainCharts","getPatName",episodeID);
        var regNo=tkMakeServerCall("Nur.NIS.Service.Base.Patient","GetRegNo",episodeID);
        // $("#paindeitalpanel").panel('setTitle', "疼痛评分明细---床号:"+bedCode+" 姓名:"+patName+" 登记号:"+regNo);
		$("#paindeitalpanel").panel('setTitle', $g("疼痛评分明细")+"---"+$g("床号")+":"+bedCode+" "+$g("姓名")+":"+patName+" "+$g("登记号")+":"+regNo);
        var painEchart=echarts.init(document.getElementById("echartbox"))
        $cm({
            ClassName:"Nur.PatPainCharts",
            MethodName:"GetPatPainScoreDetail",
            admId:episodeID
        },function (jsonData) {
            if(!jsonData) return;
            console.log(jsonData)
            var chartOption={
                title:{
                    //top:5,
                    //left:55,
                    //text:"疼痛评分",
                    //subtext:"床号:"+rowData.bedCode+" 姓名:"+rowData.patName+" 登记号:"+rowData.regNo
                },
                xAxis:{
                    name:$g("评分时间"),
                    data:jsonData.dates
                },
                yAxis:{
                    name:$g("疼痛评分"),
                    max:10,
                    min:0,
                    type:'value',
                    splitNumber:10
                },
                //legend:{},
                tooltip:{},
                series:[{
                    //name:rowData.patName+" 疼痛评分",
                    symbolSize: 10,
                        symbol: 'circle',
                    type:"line",
                    data:jsonData.scores,
                    itemStyle:{ 
                        normal:{ 
                            color:function(params){ 
                                if (params.value >=7){
                                    return '#FF3030';
                                }
                                if (params.value >=4&&params.value <=6){
                                    return '#FFFF00';
                                }
                                if (params.value <=3){
                                    return '#7FFF00';
                                }
                            } 
                        } 
                    }
    //					,
    //					markLine : {   //添加警戒线
    //	                    symbol:"none",               //去掉警戒线最后面的箭头
    //	                    name:"警戒线",
    //	                    silent:true,
    //	                    label:{
    //	                        position:"start",         //将警示值放在哪个位置，三个值“start”,"middle","end"  开始  中点 结束
    //	                        formatter: "警戒线(" +4+ ")",
    //	                        color:"red",
    //	                        fontSize:14
    //	                    },
    //	                    data : [{
    //	                        silent:true,             //鼠标悬停事件  true没有，false有
    //	                        lineStyle:{               //警戒线的样式  ，虚实  颜色
    //	                            type:"solid",
    //	                            color:"red"
    //	                        },
    //	                        name: '警戒线',
    //	                        yAxis: 4
    //	                    },
    //	                    {
    //	                        silent:true,             //鼠标悬停事件  true没有，false有
    //	                        lineStyle:{               //警戒线的样式  ，虚实  颜色
    //	                            type:"solid",
    //	                            color:"red"
    //	                        },
    //	                        name: '警戒线',
    //	                        yAxis: 7
    //	                    }]
    //	                }
                }]
            };
            painEchart.setOption(chartOption);
        });
    }
	function PatPainClickRow(rowIndex, rowData) {
        if (episodeID==rowData.admId) {
            episodeID="";
            $("#paindeitalpanel").panel('setTitle', $g("疼痛评分明细"));
            rowData={}
            $('#wardPatPainGrid').datagrid("unselectRow", rowIndex);
        } else {
            episodeID=rowData.admId;
            $("#paindeitalpanel").panel('setTitle', $g("疼痛评分明细")+"---"+$g("床号")+":"+rowData.bedCode+" "+$g("姓名")+":"+rowData.patName+" "+$g("登记号")+":"+rowData.regNo);
        }
		var painEchart=echarts.init(document.getElementById("echartbox"))
		$cm({
			ClassName:"Nur.PatPainCharts",
			MethodName:"GetPatPainScoreDetail",
			admId:episodeID
		},function (jsonData) {
			if(!jsonData) return;
	        var chartOption={
				title:{
					//top:5,
					//left:55,
					//text:"疼痛评分",
					//subtext:"床号:"+rowData.bedCode+" 姓名:"+rowData.patName+" 登记号:"+rowData.regNo
				},
				xAxis:{
					name:$g("评分时间"),
					data:jsonData.dates
				},
				yAxis:{
					name:$g("疼痛评分"),
					max:10,
					min:0,
					type:'value',
					splitNumber:10
				},
				//legend:{},
				tooltip:{},
				series:[{
					//name:rowData.patName+" 疼痛评分",
					symbolSize: 10,
					 symbol: 'circle',
					type:"line",
					data:jsonData.scores,
					itemStyle:{ 
						normal:{ 
							color:function(params){ 
								if (params.value >=7){
									return '#FF3030';
								}
								if (params.value >=4&&params.value <=6){
									return '#FFFF00';
								}
								if (params.value <=3){
									return '#7FFF00';
								}
							} 
						} 
					}
//					,
//					markLine : {   //添加警戒线
//	                    symbol:"none",               //去掉警戒线最后面的箭头
//	                    name:$g("警戒线"),
//	                    silent:true,
//	                    label:{
//	                        position:"start",         //将警示值放在哪个位置，三个值“start”,"middle","end"  开始  中点 结束
//	                        formatter: "警戒线(" +4+ ")",
//	                        color:"red",
//	                        fontSize:14
//	                    },
//	                    data : [{
//	                        silent:true,             //鼠标悬停事件  true没有，false有
//	                        lineStyle:{               //警戒线的样式  ，虚实  颜色
//	                            type:"solid",
//	                            color:"red"
//	                        },
//	                        name: $g('警戒线'),
//	                        yAxis: 4
//	                    },
//	                    {
//	                        silent:true,             //鼠标悬停事件  true没有，false有
//	                        lineStyle:{               //警戒线的样式  ，虚实  颜色
//	                            type:"solid",
//	                            color:"red"
//	                        },
//	                        name: $g('警戒线'),
//	                        yAxis: 7
//	                    }]
//	                }
				}]
			};
			painEchart.setOption(chartOption);
	    });
	}
	initUI();
});