function InitCtlResultWinEvent(obj){
	CheckSpecificKey();
	// 初始化权限
	obj.AdminPower  = '0';
	if (typeof tDHCMedMenuOper != 'undefined')
	{
		if (typeof tDHCMedMenuOper['Admin'] != 'undefined')
		{
			obj.AdminPower  = tDHCMedMenuOper['Admin'];
		}
	}
	
	//赋值初始值
    $("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("#cboHospital");  //渲染下拉框	
	setTimeout(function() {
		$("#cboInfLocation").data("param",$.form.GetValue("cboHospital")+"^^I^W^1");
		$.form.SelectRender("cboInfLocation");
	},800);
	$.form.SelectRender("cboRepType");	
	$("#cboHospital option:selected").next().attr("selected", true)
	$("#cboHospital").select2();
	//给select2赋值change事件
	$("#cboHospital").on("select2:select", function (e) { 
		//获得选中的医院
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		$("#cboInfLocation").data("param",id+"^^I^W^1");
		$.form.SelectRender("cboInfLocation");  //渲染下拉框	
	});	
	$("#chkAll").on("change",function (e) {
		if ($.form.GetValue("chkAll")==1) {
			$.form.SetValue("cboInfLocation","","")
        	$("#cboInfLocation").attr('disabled','disabled');
			$(".Radio input").attr('disabled','disabled');
			$(".Radio input").css('cursor','not-allowed');
		} else {
			$("#cboInfLocation").removeAttr('disabled');
			$(".Radio input").removeAttr('disabled');
			$(".Radio input").css('cursor','auto');
		}
	});
	obj.QryOpption="QryOpp1";
	$(".QryOpption").on("click",function (e) {
		$(".QryOpption").css("background-color","#FFFFFF");
		$(".QryOpption").css("color","#000000");
		$("#"+this.id).css("background-color","#40A2DE");
		$("#"+this.id).css("color","#FFFFFF");
		obj.QryOpption=this.id;
		if (obj.QryOpption!="QryOpp1") {
			$(".Radio input").attr('disabled','disabled');
			$(".Radio input").css('cursor','not-allowed');
		} else {
			$(".Radio input").removeAttr('disabled');
			$(".Radio input").css('cursor','auto');
		}
		btnQuery_click();
	})
	$("#btnSync").on("click",function (e) {
		//$('#img-Loading').css('display','block');
		var MonthFrom=$.form.GetValue("DateFrom");
		var MonthTo=$.form.GetValue("DateTo");
		layer.confirm('确定生成'+ MonthFrom + '至' + MonthTo +'的数据？',{
			btn: ['确认','取消'],
			btnAlign: 'c'
		}, function(index){
			layer.close(index);
			var ret=$.Tool.RunServerMethod("DHCHAI.STAS.HandHySrv","SyncData",MonthFrom,MonthTo);
			if(ret=="OK"){
				$('#img-Loading').css('display','none');
				layer.msg('生成数据成功!',{icon: 1});
			}
		});
	});
	/****************/
	var myChart = echarts.init(document.getElementById('Case01'),'theme');
		
	option1 = {
		title : {
			text: '手卫生统计图',
			x:'left'
		},
		tooltip: {
			trigger: 'axis',
		},
		toolbox: {
			"show": true
		},
		legend: {
			data:['依从率','正确率']
		},
		xAxis: [
			{
				type: 'category',
				axisLabel: {
					margin:8,
					rotate:45,
					interval:0,
					// 使用函数模板，函数参数分别为刻度数值（类目），刻度的索引
					formatter: function (value, index) {
						//处理标签，过长折行和省略
						if(value.length>6 && value.length<11){
							return value.substr(0,5)+'\n'+value.substr(5,5);
						}else if(value.length>10){
							return value.substr(0,6)+'\n'+value.substr(6,4)+"...";
						}else{
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
				name:'依从率',
				type:'bar',
				label: {
					show:true,
					formatter:"{c}%"
				}
			},
			{
				name:'正确率',
				type:'bar',
				yAxisIndex: 1,
				label: {
					show:true,
					formatter:"{c}%"
				}
			}
		   
		]
	};
	// 使用刚指定的配置项和数据显示图表。
	myChart.setOption(option1);
	
	/****************/
    //查询按钮
    $("#btnQuery").on('click', btnQuery_click)
	function btnQuery_click(){
		var HospitalID=$.form.GetValue("cboHospital")
		var LocID=$.form.GetValue("cboInfLocation")
		var MonthFrom=$.form.GetValue("DateFrom")
		var MonthTo=$.form.GetValue("DateTo")
		var IsAll=$.form.GetValue("chkAll")
		
		var ErrorStr = "";
		if ((MonthFrom == "")||(MonthTo == "")) {
			if (MonthFrom=="") {
				ErrorStr += '请选择开始日期!<br/>';
			}
			if (MonthTo == "") {
				ErrorStr += '请选择结束日期!<br/>';
			}
		} else if(MonthFrom!=MonthTo){             //过滤a等于b的情况 1200397
			if ($.form.CompareDate(MonthFrom + '-01', MonthTo + '-01') > 0) {	//a是否大于等于b，异常-1，是1，否0
					ErrorStr += '开始日期不能大于结束日期!<br/>';
			}
		}
		if (ErrorStr != '') {
				layer.msg(ErrorStr,{icon: 0});
				return;
		}
		
		switch(obj.QryOpption)
		{
			case "QryOpp1" :
				if ((LocID!="")||(IsAll==1)) {
					$("#thead-First b").text("月份")
					var dataInput = "ClassName=" + 'DHCHAI.STAS.HandHySrv' + "&QueryName=" + 'QryHDForCharts' + "&Arg1=" + HospitalID + "&Arg2=" + MonthFrom + "&Arg3=" + MonthTo + "&Arg4=" + LocID +"&ArgCnt=" + 4;
					$.ajax({
						url: "./dhchai.query.csp",
						type: "post",
						timeout: 30000, //30秒超时
						async: true,   //异步
						data: dataInput,
						success: function(data, textStatus){
							var retval = (new Function("return " + data))();
							obj.echartLocInfRatio(retval);
						},
						error: function(XMLHttpRequest, textStatus, errorThrown){
							alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
						}
					});
				} else {
					$("#thead-First b").text("科室");
					var dataInput = "ClassName=" + 'DHCHAI.STAS.HandHySrv' + "&QueryName=" + 'QryHDForChartsH' + "&Arg1=" + HospitalID + "&Arg2=" + MonthFrom + "&Arg3=" + MonthTo + "&ArgCnt=" + 3;
					$.ajax({
						url: "./dhchai.query.csp",
						type: "post",
						timeout: 30000, //30秒超时
						async: true,   //异步
						data: dataInput,
						success: function(data, textStatus){
							var retval = (new Function("return " + data))();
							obj.echartLocInfRatio2(retval,"LOC");
						},
						error: function(XMLHttpRequest, textStatus, errorThrown){
							alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
						}
					});
				}
				break;
			case "QryOpp2" :
				$("#thead-First b").text("职业");
				var dataInput = "ClassName=" + 'DHCHAI.STAS.HandHySrv' + "&QueryName=" + 'QryHDForChartsT' + "&Arg1=" + HospitalID + "&Arg2=" + MonthFrom + "&Arg3=" + MonthTo + "&Arg4=" + LocID + "&ArgCnt=" + 4;
				$.ajax({
					url: "./dhchai.query.csp",
					type: "post",
					timeout: 30000, //30秒超时
					async: true,   //异步
					data: dataInput,
					success: function(data, textStatus){
						var retval = (new Function("return " + data))();
						obj.echartLocInfRatio2(retval,"TYPE");
					},
					error: function(XMLHttpRequest, textStatus, errorThrown){
						alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
					}
				});
				break;
			case "QryOpp3" :
				$("#thead-First b").text("指征");
				var dataInput = "ClassName=" + 'DHCHAI.STAS.HandHySrv' + "&QueryName=" + 'QryHDForChartsO' + "&Arg1=" + HospitalID + "&Arg2=" + MonthFrom + "&Arg3=" + MonthTo + "&Arg4=" + LocID + "&ArgCnt=" + 4;
				$.ajax({
					url: "./dhchai.query.csp",
					type: "post",
					timeout: 30000, //30秒超时
					async: true,   //异步
					data: dataInput,
					success: function(data, textStatus){
						var retval = (new Function("return " + data))();
						obj.echartLocInfRatio2(retval,"OPP");
					},
					error: function(XMLHttpRequest, textStatus, errorThrown){
						alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
					}
				});
				break;
		}
	};
   
   
   obj.echartLocInfRatio = function(runQuery){
	   if (!runQuery) alert(1);
		var arrTime = new Array();
		var arrInfRatio1 = new Array();
		var arrInfRatio2 = new Array();
		var arrRecord = runQuery.record;
		var strHtml="";
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrTime.push(rd["ECTime"]);
			arrInfRatio1.push(rd["Radio1"]);
			arrInfRatio2.push(rd["Radio2"]);
			
			strHtml=strHtml+"<tr><td>"+rd["ECTime"]+"</td>"
			strHtml=strHtml+"<td>"+rd["Value1"]+"</td>"
			strHtml=strHtml+"<td>"+rd["Value2"]+"</td>"
			strHtml=strHtml+"<td>"+rd["Value3"]+"</td>"
			strHtml=strHtml+"<td>"+rd["Radio1"]+"%</td>"
			strHtml=strHtml+"<td>"+rd["Radio2"]+"%</td>"
			strHtml=strHtml+"<td>"+rd["ECPatCount"]+"</td></tr>"
		}
		$("#gridHandHyReg tbody").html(strHtml)
		
		myChart.setOption({
			xAxis: [{
				data: arrTime
			}],
			series: [{
				type:'line',
				data:arrInfRatio1
			},{
				type:'line',
				data:arrInfRatio2
			}]
		});
   }
   
   obj.echartLocInfRatio2 = function(runQuery,Desc){
	   if (!runQuery) layer.alert("获取数据失败！");
	   if (Desc=="LOC") {
			var minRadio1=$.form.GetValue("minRadio1");	//依从率
			var maxRadio1=$.form.GetValue("maxRadio1");
			var minRadio2=$.form.GetValue("minRadio2");	//正确率
			var maxRadio2=$.form.GetValue("maxRadio2");
			
			if (minRadio1=="") minRadio1=0;
			if (maxRadio1=="") maxRadio1=100;
			if (minRadio2=="") minRadio2=0;
			if (maxRadio2=="") maxRadio2=100;
			
			minRadio1=parseFloat(minRadio1);
			maxRadio1=parseFloat(maxRadio1);
			minRadio2=parseFloat(minRadio2);
			maxRadio2=parseFloat(maxRadio2);
	   }
		var arrCat = new Array();
		var arrInfRatio1 = new Array();
		var arrInfRatio2 = new Array();
		var arrRecord = runQuery.record;
		
		if (Desc=="LOC") arrRecord.sort(compare("Radio1"));		//按依从率排序
		var strHtml="";
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			if (Desc=="LOC") {
				if((parseFloat(rd["Radio1"])<minRadio1)||(parseFloat(rd["Radio1"])>maxRadio1)) continue;
				if((parseFloat(rd["Radio2"])<minRadio2)||(parseFloat(rd["Radio2"])>maxRadio2)) continue;
				/* if(($.form.GetValue("minRadio1")=="")&&($.form.GetValue("maxRadio1")=="")){
					if(rd["Radio1"]>70) continue;	//默认查询依从率低于70%的科室
				} */
			}
			arrCat.push(rd["CatDesc"]);
			arrInfRatio1.push(rd["Radio1"]);
			arrInfRatio2.push(rd["Radio2"]);
			
			strHtml=strHtml+"<tr><td>"+rd["CatDesc"]+"</td>"
			strHtml=strHtml+"<td>"+rd["Value1"]+"</td>"
			strHtml=strHtml+"<td>"+rd["Value2"]+"</td>"
			strHtml=strHtml+"<td>"+rd["Value3"]+"</td>"
			strHtml=strHtml+"<td>"+rd["Radio1"]+"%</td>"
			strHtml=strHtml+"<td>"+rd["Radio2"]+"%</td>"
			strHtml=strHtml+"<td>"+rd["ECPatCount"]+"</td></tr>"
		}
		$("#gridHandHyReg tbody").html(strHtml);
		
		myChart.setOption({
			xAxis: [{
				data: arrCat
			}],
			series: [{
				type:'bar',
				data:arrInfRatio1
			},{
				type:'bar',
				data:arrInfRatio2
			}]
		});
   } 
}
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

