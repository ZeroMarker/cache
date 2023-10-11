function InitS100gnbacWinEvent(obj){
obj.LoadEvent = function(args){
		$('#ReportFrame').css('display', 'block');
		setTimeout(function(){
			obj.LoadRep();
		},50);

		//图的点击事件
		$('#btnSearchChart').on('click',function(e,value){
			$('#EchartDiv').css('display', 'block');
			$('#ReportFrame').css('display', 'none');
			$('#EchartDiv').removeClass("no-result");
			obj.myChart = echarts.init(document.getElementById('EchartDiv'),'theme');
			obj.ShowEChaert1();
		});
		
		//表的点击事件
		$('#btnSearchTable').on('click',function(e,value){
			$('#ReportFrame').css('display','block');
			$('#EchartDiv').css('display', 'none');
			obj.LoadRep();
		});
   	}
	
   	obj.LoadRep = function(){
		var aHospID 	= $('#cboHospital').combobox('getValues').join('|');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aLocType 	= Common_CheckboxValue('chkStatunit');
		var aQrycon 	= $('#cboQryCon').combobox('getValue');
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');	
		ReportFrame = document.getElementById("ReportFrame");
		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		if ((aStatDimens=="")){
			$.messager.alert("提示","请选择展示维度！", 'info');
			return;
		}
		
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S100GNBac.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aLocType='+aLocType+'&aQryCon='+aQrycon+'&aStatDimens='+aStatDimens+'&aLocIDs='+aLocIDs+'&aPath='+cspPath;		
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		} 
	}
    obj.echartLocInfRatio = function(runQuery){
		if (!runQuery) return;
		arrRecord 		= runQuery.record;
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');	
		
		var arrBacDesc = new Array();		//病原体名称
		var arrBacCnt  = new Array();   	//病原体数量
		 
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			var DimensKey=rd["DimensKey"];
			
			if(aLocIDs==""){					
				if(DimensKey!=arrRecord[0].DimensKey)continue;		//科室不为空取第一条记录
			}
			else{
				if(DimensKey!="ALL")continue;						//取全部科室汇总记录
			}
			//加载'病原体名称'
			arrBacDesc.push(rd["BacDesc"]);		
			//加载'病原体数量'
			arrBacCnt.push(rd["BacCnt"]);
			
			if(arrBacDesc.length==0){
				$('#EchartDiv').addClass('no-result');
			}
		}
		// 使用刚指定的配置项和数据显示图表。
		option = {
	    	title : {
			text: '革兰氏阴性细菌构成比统计图',
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
				data:arrBacDesc
			},
			series : [{
				name: '病原体名称',
				type: 'pie',
				radius : '55%',
				center: ['50%', '60%'],
				data:(function(){
					var arr=[];
				  	for (var i = 0; i < arrBacDesc.length; i++) {	
 						arr.push({"value": arrBacCnt[i],"name":arrBacDesc[i]});
					}
					return arr;  
				})(),
			}]
		};
		obj.myChart.setOption(option,true);
	}
   	obj.ShowEChaert1 = function(){
		obj.myChart.clear()
		//革兰氏阴性细菌构成比图表
		var aHospID 	= $('#cboHospital').combobox('getValues').join('|');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aLocType 	= Common_CheckboxValue('chkStatunit');
		var aQrycon 	= $('#cboQryCon').combobox('getValue');
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');	
		/*
		var dataInput 	= "ClassName=" + 'DHCHAI.STATV2.S100GNBac' + "&QueryName=" + 'QryPathogeny' + "&Arg1=" + aHospID + "&Arg2=" + aDateFrom + "&Arg3=" + aDateTo +"&Arg4="+aLocType+"&Arg5="+aQrycon+"&Arg6="+aStatDimens+"&Arg7="+aLocIDs+"&ArgCnt=" + 7;
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
				if(data=='{record:[],total : 0}'){
					$('#EchartDiv').addClass('no-result');
				}
				obj.echartLocInfRatio(retval);
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				var tkclass="DHCHAI.STATV2.S100GNBac";
				var tkQuery="QryPathogeny";
				alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
				obj.myChart.hideLoading();    //隐藏加载动画
			}
		});*/
		obj.myChart.showLoading();
		$cm({
			ClassName:'DHCHAI.STATV2.S100GNBac',
			QueryName:'QryPathogeny',
			aHospIDs:aHospID,
			aDateFrom:aDateFrom,
			aDateTo:aDateTo,
			aLocType:aLocType,
			aQryCon:aQrycon,
			aStatDimens:aStatDimens,
			aLocIDs:aLocIDs,
			page:1,
			rows:999
		},function(rs){
			obj.myChart.hideLoading();    //隐藏加载动画
			obj.echartLocInfRatio(rs);
		})
	}
}