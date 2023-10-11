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
                // {field: 'IsCheck', title: 'ѡ��', checkbox: true, align: 'center'},
                {field:'bedCode',title:'����', width:80 ,editor: 'validatebox'},
                {field:'patName',title:'����', width:100 ,editor: 'validatebox'},
                {field:'regNo',title:'�ǼǺ�', width:120 ,editor: 'validatebox'},
                {field:'score',title:'����', width:60,editor: 'validatebox', 
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
                {field:'recTime',title:'����ʱ��', width:160,editor: 'validatebox'},
                {field:'admdate',title:'��Ժ����', width:180 ,editor: 'validatebox'},
                {field:'dischdate',title:'��Ժ����', width:180 ,editor: 'validatebox'},
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
        // $("#paindeitalpanel").panel('setTitle', "��ʹ������ϸ---����:"+bedCode+" ����:"+patName+" �ǼǺ�:"+regNo);
		$("#paindeitalpanel").panel('setTitle', $g("��ʹ������ϸ")+"---"+$g("����")+":"+bedCode+" "+$g("����")+":"+patName+" "+$g("�ǼǺ�")+":"+regNo);
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
                    //text:"��ʹ����",
                    //subtext:"����:"+rowData.bedCode+" ����:"+rowData.patName+" �ǼǺ�:"+rowData.regNo
                },
                xAxis:{
                    name:$g("����ʱ��"),
                    data:jsonData.dates
                },
                yAxis:{
                    name:$g("��ʹ����"),
                    max:10,
                    min:0,
                    type:'value',
                    splitNumber:10
                },
                //legend:{},
                tooltip:{},
                series:[{
                    //name:rowData.patName+" ��ʹ����",
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
    //					markLine : {   //��Ӿ�����
    //	                    symbol:"none",               //ȥ�������������ļ�ͷ
    //	                    name:"������",
    //	                    silent:true,
    //	                    label:{
    //	                        position:"start",         //����ʾֵ�����ĸ�λ�ã�����ֵ��start��,"middle","end"  ��ʼ  �е� ����
    //	                        formatter: "������(" +4+ ")",
    //	                        color:"red",
    //	                        fontSize:14
    //	                    },
    //	                    data : [{
    //	                        silent:true,             //�����ͣ�¼�  trueû�У�false��
    //	                        lineStyle:{               //�����ߵ���ʽ  ����ʵ  ��ɫ
    //	                            type:"solid",
    //	                            color:"red"
    //	                        },
    //	                        name: '������',
    //	                        yAxis: 4
    //	                    },
    //	                    {
    //	                        silent:true,             //�����ͣ�¼�  trueû�У�false��
    //	                        lineStyle:{               //�����ߵ���ʽ  ����ʵ  ��ɫ
    //	                            type:"solid",
    //	                            color:"red"
    //	                        },
    //	                        name: '������',
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
            $("#paindeitalpanel").panel('setTitle', $g("��ʹ������ϸ"));
            rowData={}
            $('#wardPatPainGrid').datagrid("unselectRow", rowIndex);
        } else {
            episodeID=rowData.admId;
            $("#paindeitalpanel").panel('setTitle', $g("��ʹ������ϸ")+"---"+$g("����")+":"+rowData.bedCode+" "+$g("����")+":"+rowData.patName+" "+$g("�ǼǺ�")+":"+rowData.regNo);
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
					//text:"��ʹ����",
					//subtext:"����:"+rowData.bedCode+" ����:"+rowData.patName+" �ǼǺ�:"+rowData.regNo
				},
				xAxis:{
					name:$g("����ʱ��"),
					data:jsonData.dates
				},
				yAxis:{
					name:$g("��ʹ����"),
					max:10,
					min:0,
					type:'value',
					splitNumber:10
				},
				//legend:{},
				tooltip:{},
				series:[{
					//name:rowData.patName+" ��ʹ����",
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
//					markLine : {   //��Ӿ�����
//	                    symbol:"none",               //ȥ�������������ļ�ͷ
//	                    name:$g("������"),
//	                    silent:true,
//	                    label:{
//	                        position:"start",         //����ʾֵ�����ĸ�λ�ã�����ֵ��start��,"middle","end"  ��ʼ  �е� ����
//	                        formatter: "������(" +4+ ")",
//	                        color:"red",
//	                        fontSize:14
//	                    },
//	                    data : [{
//	                        silent:true,             //�����ͣ�¼�  trueû�У�false��
//	                        lineStyle:{               //�����ߵ���ʽ  ����ʵ  ��ɫ
//	                            type:"solid",
//	                            color:"red"
//	                        },
//	                        name: $g('������'),
//	                        yAxis: 4
//	                    },
//	                    {
//	                        silent:true,             //�����ͣ�¼�  trueû�У�false��
//	                        lineStyle:{               //�����ߵ���ʽ  ����ʵ  ��ɫ
//	                            type:"solid",
//	                            color:"red"
//	                        },
//	                        name: $g('������'),
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