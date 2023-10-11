function InitS041MRBInfWinEvent(obj){
   	obj.LoadEvent = function(args){
		$('#ReportFrame').css('display', 'block');
		setTimeout(function(){
			obj.LoadRep();
		},50);

		//图的点击事件
		$('#btnSearchChart').on('click',function(e,value){
			$("#comboNum").css("display","block");
			$('#EchartDiv').css('display', 'block');
			$('#ReportFrame').css('display', 'none');
			obj.myChart = echarts.init(document.getElementById('EchartDiv'),'theme');
			obj.ShowEChaert1();
		});
		
		//表的点击事件
		$('#btnSearchTable').on('click',function(e,value){
			$("#comboNum").css("display","none");
			$('#ReportFrame').css('display', 'block');
			$('#EchartDiv').css('display', 'none');
			obj.LoadRep();
		});

   	}
	
   	obj.LoadRep = function(){
		var aHospID 	= $('#cboHospital').combobox('getValue');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aStaType 	= Common_CheckboxValue('chkStatunit');
		var aQrycon 	= $('#cboQryCon').combobox('getValue');
		ReportFrame = document.getElementById("ReportFrame");
		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S041MRBInf.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aStaType='+aStaType+'&aQryCon='+aQrycon;	
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		} 
		
	}
    obj.echartLocInfRatio = function(runQuery){
	    var aHospID 	= $('#cboHospital').combobox('getValue');
	    var QryCon="-H-";	//默认统计医院
	    if (aHospID.indexOf('|')>-1) QryCon="-A-";	//多院区时统计全院
		if (!runQuery) return;
		var M1Pat="";
		var M2Pat="";
		var M3Pat="";
		var M4Pat="";
		var M5Pat="";
		var M6Pat="";
		var M7Pat="";
		var M8Pat="";
		var M9Pat="";
		arrRecord 		= runQuery.rows;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			if ((rd["DimensKey"].indexOf(QryCon)>-1)) {
				 M1Pat=rd["M1Pat"];
				 M2Pat=rd["M2Pat"];
				 M3Pat=rd["M3Pat"];
				 M4Pat=rd["M4Pat"];
				 M5Pat=rd["M5Pat"];
				 M6Pat=rd["M6Pat"];
				 M7Pat=rd["M7Pat"];
				 M8Pat=rd["M8Pat"];
				 M9Pat=rd["M9Pat"];	
			}
		}
		// 使用刚指定的配置项和数据显示图表。
		option = {
			    title : {
			        text: '全院多重耐药菌感染人数统计图',
			        textStyle:{
						fontSize:28
					},
			        x:'center'
			    },
			    tooltip : {
			        trigger: 'item',
			        formatter: "{a} <br/>{b} : {c} ({d}%)"
			    },
				toolbox: {
					feature: {
						dataView: {show: false, readOnly: false},
						magicType: {show: false, type: ['line', 'bar']},
						restore: {show: true},
						saveAsImage: {show: true}
					}
				},
			    legend: {
			        orient: 'vertical',
			        left: 'left',
			        data:["耐甲氧西林的金黄色葡萄球菌","耐万古霉素的粪肠球菌","耐万古霉素的屎肠球菌","耐三、四代头孢菌素的大肠埃希菌","耐三、四代头孢菌素的肺炎克雷伯菌","耐碳青霉烯类的大肠埃希菌","耐碳青霉烯类的肺炎克雷伯菌","耐碳青霉烯类的鲍曼不动杆菌","耐碳青霉烯类的铜绿假单胞菌"]
			    },
			    series : [
			        {
			            name: '多耐名称',
			            type: 'pie',
			            radius : '55%',
			            center: ['50%', '60%'],
			            data: [
			            	{"value": M1Pat,"name":"耐甲氧西林的金黄色葡萄球菌"},
			            	{"value": M2Pat,"name":"耐万古霉素的粪肠球菌"},
			            	{"value": M3Pat,"name":"耐万古霉素的屎肠球菌"},
			            	{"value": M4Pat,"name":"耐三、四代头孢菌素的大肠埃希菌"},
			            	{"value": M5Pat,"name":"耐三、四代头孢菌素的肺炎克雷伯菌"},
			            	{"value": M6Pat,"name":"耐碳青霉烯类的大肠埃希菌"},
			            	{"value": M7Pat,"name":"耐碳青霉烯类的肺炎克雷伯菌"},
			            	{"value": M8Pat,"name":"耐碳青霉烯类的鲍曼不动杆菌"},
			            	{"value": M9Pat,"name":"耐碳青霉烯类的铜绿假单胞菌"},
			            	],
			        }
			    ]
			};
		obj.myChart.setOption(option,true);
	}
   	obj.ShowEChaert1 = function(){
		obj.myChart.clear()
		 //当月科室感染率图表
		var aHospID = $('#cboHospital').combobox('getValue');
		var aDateFrom = $('#dtDateFrom').datebox('getValue');
		var aDateTo= $('#dtDateTo').datebox('getValue');
		var aLocType = Common_CheckboxValue('chkStatunit');
		var aQryCon = $('#cboQryCon').combobox('getText');
		if(aQryCon=="显示全部病区(科室)"){
			var aQryCon = 1;
		}else{
			var aQryCon = 2;	
		}
		/*var dataInput = "ClassName=" + 'DHCHAI.STATV2.S041MRBInf' + "&QueryName=" + 'QryMRBInf' + "&Arg1=" + aHospID + "&Arg2=" + aDateFrom + "&Arg3=" + aDateTo +"&Arg4="+aLocType+"&Arg5="+aQryCon+"&ArgCnt=" + 5;

		$.ajax({
			url: "./dhchai.query.csp",
			type: "post",
			timeout: 60000, //60秒超时
			async: true,   //异步
			beforeSend:function(){
				obj.myChart.showLoading();	
			},
			data: dataInput,
			success: function(data, textStatus){
				obj.myChart.hideLoading();    //隐藏加载动画
				var retval = (new Function("return " + data))();
				obj.echartLocInfRatio(retval);
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				var tkclass="DHCHAI.STATV2.S041MRBInf";
				var tkQuery="QryMRBInf";
				alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
				obj.myChart.hideLoading();    //隐藏加载动画
			}
		});*/
		obj.myChart.showLoading();
		$cm({
			ClassName:'DHCHAI.STATV2.S041MRBInf',
			QueryName:'QryMRBInf',
			aHospIDs:aHospID,
			aDateFrom:aDateFrom,
			aDateTo:aDateTo,
			aStaType:aLocType,
			aQryCon:aQryCon,
			page:1,
			rows:999
		},function(rs){
			obj.myChart.hideLoading();    //隐藏加载动画
			obj.echartLocInfRatio(rs);
		})
	}
	
}