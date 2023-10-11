//手卫生统计图(Event)
function InitHand01WinEvent(obj) {
	//院区点击事件
    $HUI.combobox('#cboHospital', {
        onSelect: function (data) {
           obj.cboInfLocation = Common_ComboToLoc("cboInfLocation", data.ID, "", "", "");   
        }
    });
	//统计类型点击事件
	 $HUI.combobox('#cboSumType', {
        onSelect: function (data) {
           if(data.ID=="QryOpp1"){		//启用依从率+正确率筛选
	           $("#minRadio1").removeAttr("disabled");
	           $("#maxRadio1").removeAttr("disabled");
	           $("#minRadio2").removeAttr("disabled");
	           $("#maxRadio2").removeAttr("disabled");
	       }
	       else{						//禁用依从率+正确率筛选
		       $("#minRadio1").attr("disabled", true);
		       $("#maxRadio1").attr("disabled", true);
		       $("#minRadio2").attr("disabled", true);
		       $("#maxRadio2").attr("disabled", true);
		       $("#minRadio1").val('');
	           $("#maxRadio1").val('');
	           $("#minRadio2").val('');
	           $("#maxRadio2").val('');
		   }
        }
    });
    $('#chkStatunit').radio({
        onChecked: function (e, value) {
	        $("#minRadio1").attr("disabled", true);
	       	$("#maxRadio1").attr("disabled", true);
	       	$("#minRadio2").attr("disabled", true);
	       	$("#maxRadio2").attr("disabled", true);
	       	$("#minRadio1").val('');
           	$("#maxRadio1").val('');
           	$("#minRadio2").val('');
           	$("#maxRadio2").val('');
        },
        onUnchecked: function (e, value) {
			$("#minRadio1").removeAttr("disabled");
	        $("#maxRadio1").removeAttr("disabled");
	        $("#minRadio2").removeAttr("disabled");
	        $("#maxRadio2").removeAttr("disabled");
		}
	});
    
	//查询事件
	$('#btnQuery').on('click', function () {
        var HospitalID = $('#cboHospital').combobox('getValue');    //院区
        var DateType = $('#cboDateType').combobox('getValue');      //日期类型
        var MonthFrom = $('#dtDateFrom').datebox('getValue');       //开始日期
        var MonthTo = $('#dtDateTo').datebox('getValue');           //结束日期
        var LocID = $('#cboInfLocation').combobox('getValue');      //调查病区
        if (!LocID) LocID = "";
        var SumType= $('#cboSumType').combobox('getValue'); 		//统计类型
        
        var minRadio1 = $('#minRadio1').val();                      //依从率-开始
        var maxRadio1 = $('#maxRadio1').val();                      //依从率-结束            
        var minRadio2 = $('#minRadio2').val();                      //正确率-开始
        var maxRadio2 = $('#maxRadio2').val();                      //正确率-结束

        var IsAll = $('#chkStatunit').radio('getValue') ? '1' : '0';	//是否按月份统计

        if (MonthFrom == "") {
            $.messager.alert("提示", "开始日期不能为空!", 'info');
            return;
        }
        else if (MonthTo == "") {
            $.messager.alert("提示", "结束日期不能为空!", 'info');
            return;
        }
        else if (Common_CompareDate(MonthFrom + "-01", MonthTo + "-01") == 1) {
            $.messager.alert("提示", "开始日期不能大于当前日期!", 'info');
            return;
        }
        switch(SumType){
            case "QryOpp1":
                if ((LocID != "") || (IsAll == 1)) {
					$cm({
						ClassName:"DHCHAI.STAS.HandHySrv",
						QueryName:"QryHDForCharts",
						aHospIDs:HospitalID, 
						aDateFrom:MonthFrom, 
						aDateTo:MonthTo, 
						aLocID:LocID, 
						aType:'', 
						aOpport:'',
						page: 1,
						rows: 999
					},function(rs){
						obj.echartLocInfRatio(rs);
					});
                } else {
					$cm({
						ClassName:"DHCHAI.STAS.HandHySrv",
						QueryName:"QryHDForChartsH",
						aHospIDs:HospitalID, 
						aDateFrom:MonthFrom, 
						aDateTo:MonthTo, 
						aLocID:'', 
						aType:'', 
						aOpport:'',
						page: 1,
						rows: 999
					},function(rs){
						obj.echartLocInfRatio2(rs, "LOC");
					});
                }
                break;
            case "QryOpp2":
             
				$cm({
					ClassName:"DHCHAI.STAS.HandHySrv",
					QueryName:"QryHDForChartsT",
					aHospIDs:HospitalID, 
					aDateFrom:MonthFrom, 
					aDateTo:MonthTo, 
					aLocID:LocID, 
					aOpport:'',
					page: 1,
					rows: 999
				},function(rs){
					obj.echartLocInfRatio2(rs, "TYPE");
				});
				
                break;
            case "QryOpp3":
				$cm({
					ClassName:"DHCHAI.STAS.HandHySrv",
					QueryName:"QryHDForChartsO",
					aHospIDs:HospitalID, 
					aDateFrom:MonthFrom, 
					aDateTo:MonthTo, 
					aLocID:LocID, 
					aType:'',
					page: 1,
					rows: 999
				},function(rs){
					obj.echartLocInfRatio2(rs, "OPP");
				});
                break;
        }
        
    })
	//生成数据点击
	$('#btnSync').on('click', function () {
        var MonthFrom = $('#dtDateFrom').datebox('getValue');       //开始日期
        var MonthTo = $('#dtDateTo').datebox('getValue');           //结束日期
        $.messager.confirm("提示", '确定生成' + MonthFrom + '至' + MonthTo + '的数据?', function (r) {
            if (r) {
                var Ret = $m({          //当前页(默认最后一页)
                    ClassName: "DHCHAI.STAS.HandHySrv",
                    MethodName: "SyncData",
                    aFromDate: MonthFrom,
                    aToDate: MonthTo
                }, false)

                if (Ret=="OK") {
                    $.messager.alert("提示", "生成数据成功!", 'info');
                } else {
                    $.messager.alert("提示", "生成数据失败!", 'info');
                }
            }
            else {
                return;
            }
        });
    })
    //刷新图->月份
    obj.echartLocInfRatio = function (runQuery) {
        if (!runQuery) alert(1);
        $('#gridHandHyReg').datagrid('loadData', { total: 0, rows: [] });   //情况表格数据
        var arrTime = new Array();
        var arrInfRatio1 = new Array();
        var arrInfRatio2 = new Array();
        var arrRecord = runQuery.rows;
        for (var indRd = 0; indRd < arrRecord.length; indRd++) {
            var rd = arrRecord[indRd];
            arrTime.push(rd["ECTime"]);
            arrInfRatio1.push(rd["Radio1"]);
            arrInfRatio2.push(rd["Radio2"]);
			//更新表格
            obj.gridHandHyReg.appendRow({ 
                CatDesc: rd["ECTime"],
                Value1: rd["Value1"],
                Value2: rd["Value2"],
                Value3: rd["Value3"],
                Radio1: rd["Radio1"] + "%",  //增加一个字段用于判断输入的手术名称是否标准手术
                Radio2: rd["Radio2"] + "%",
                ECPatCount: rd["ECPatCount"]
            })
        }
		//更新图
        myChart.setOption({
            xAxis: [{
                data: arrTime
            }],
            series: [{
                type: 'line',
                data: arrInfRatio1
            }, {
                type: 'line',
                data: arrInfRatio2
            }]
        });
    }
    //刷新图->名称
    obj.echartLocInfRatio2 = function (runQuery, Desc) {
        if (!runQuery) layer.alert("获取数据失败！");
        $('#gridHandHyReg').datagrid('loadData', { total: 0, rows: [] });   //情况表格数据
        if (Desc == "LOC") {
            var minRadio1 = $('#minRadio1').val();
            var maxRadio1 = $('#maxRadio1').val();
            var minRadio2 = $('#minRadio2').val();
            var maxRadio2 = $('#maxRadio2').val();

            if (minRadio1 == "") minRadio1 = 0;
            if (maxRadio1 == "") maxRadio1 = 100;
            if (minRadio2 == "") minRadio2 = 0;
            if (maxRadio2 == "") maxRadio2 = 100;

            minRadio1 = parseFloat(minRadio1);
            maxRadio1 = parseFloat(maxRadio1);
            minRadio2 = parseFloat(minRadio2);
            maxRadio2 = parseFloat(maxRadio2);
        }
        var arrCat = new Array();
        var arrInfRatio1 = new Array();
        var arrInfRatio2 = new Array();
        var arrRecord = runQuery.rows;
        if (Desc == "LOC") arrRecord.sort(compare("Radio1"));		//按依从率排序
        for (var indRd = 0; indRd < arrRecord.length; indRd++) {
            var rd = arrRecord[indRd];
            if (Desc == "LOC") {
                if ((parseFloat(rd["Radio1"]) < minRadio1) || (parseFloat(rd["Radio1"]) > maxRadio1)) continue;
                if ((parseFloat(rd["Radio2"]) < minRadio2) || (parseFloat(rd["Radio2"]) > maxRadio2)) continue;
                /* if(($.form.GetValue("minRadio1")=="")&&($.form.GetValue("maxRadio1")=="")){
					if(rd["Radio1"]>70) continue;	//默认查询依从率低于70%的科室
				} */
            }
            arrCat.push(rd["CatDesc"]);
            arrInfRatio1.push(rd["Radio1"]);
            arrInfRatio2.push(rd["Radio2"]);
			if (Desc != "OPP"){
				$("#gridHandHyReg").datagrid('showColumn','ECPatCount');
			//刷新表格
            obj.gridHandHyReg.appendRow({  
                CatDesc: rd["CatDesc"],
                Value1: rd["Value1"],
                Value2: rd["Value2"],
                Value3: rd["Value3"],
                Radio1: rd["Radio1"] + "%",  //增加一个字段用于判断输入的手术名称是否标准手术
                Radio2: rd["Radio2"] + "%",
                ECPatCount: rd["ECPatCount"]
            })
			}else{
				$("#gridHandHyReg").datagrid('hideColumn','ECPatCount');
				//刷新表格
	            obj.gridHandHyReg.appendRow({  
	                CatDesc: rd["CatDesc"],
	                Value1: rd["Value1"],
	                Value2: rd["Value2"],
	                Value3: rd["Value3"],
	                Radio1: rd["Radio1"] + "%",  //增加一个字段用于判断输入的手术名称是否标准手术
	                Radio2: rd["Radio2"] + "%"
	                
	            })
			}
			
        }
        //刷新图
        myChart.setOption({
            xAxis: [{
                data: arrCat
            }],
            series: [{
                type: 'bar',
                data: arrInfRatio1
            }, {
                type: 'bar',
                data: arrInfRatio2
            }]
        });
    }
    //排序函数
    var compare = function (prop) {
        return function (obj1, obj2) {
            var val1 = obj1[prop];
            var val2 = obj2[prop];
            if (!isNaN(Number(val1)) && !isNaN(Number(val2))) {
                val1 = Number(val1);
                val2 = Number(val2);
            }
            if (val1 < val2) {
                return -1;
            } else if (val1 > val2) {
                return 1;
            } else {
                return 0;
            }
        }
    }
    
    //EChart框架
    //手卫生统计图显示
    var myChart = echarts.init(document.getElementById('EchartDiv'), 'theme');
    option = {
        title: {
            text: '手卫生统计图',
            x: 'left'
        },
        tooltip: {
            trigger: 'axis',
        },
        toolbox: {
            "show": true
        },
        toolbox: {
            right: "25px",
            feature: {
                dataView: { show: false, readOnly: false },
                magicType: { show: true, type: ['line', 'bar'] },
                restore: { show: true },
                saveAsImage: { show: true }
            }
        },
        legend: {
            data: ['依从率', '正确率']
        },
        xAxis: [
			{
			    type: 'category',
			    axisLabel: {
			        margin: 8,
			        rotate: 45,
			        interval: 0,
			        // 使用函数模板，函数参数分别为刻度数值（类目），刻度的索引
			        formatter: function (value, index) {
			            //处理标签，过长折行和省略
			            if (value.length > 6 && value.length < 11) {
			                return value.substr(0, 5) + '\n' + value.substr(5, 5);
			            } else if (value.length > 10) {
			                return value.substr(0, 6) + '\n' + value.substr(6, 4) + "...";
			            } else {
			                return value;
			            }
			        }
			    }
			}
        ],
        yAxis: [
			{
			    type: 'value',
			    name: '依从率(%)',
			    axisLabel: {
			        formatter: '{value}% '
			    }
			},
			{
			    type: 'value',
			    name: '正确率(%)',
			    axisLabel: {
			        formatter: '{value}% '
			    }
			}
        ],
        series: [
			 {
			     name: '依从率',
			     type: 'bar',
			     label: {
			         show: true,
			         formatter: "{c}%"
			     }
			 },
			{
			    name: '正确率',
			    type: 'bar',
			    yAxisIndex: 1,
			    label: {
			        show: true,
			        formatter: "{c}%"
			    }
			}

        ]
    };
    // 使用刚指定的配置项和数据显示图表。
    myChart.setOption(option);
}


