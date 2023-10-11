function InitactualantuseWinEvent(obj){
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
		var aHospID = $('#cboHospital').combobox('getValues').join('|');
		var aDateFrom = $('#dtDateFrom').datebox('getValue');
		var aDateTo= aDateFrom
		var aStatunit = Common_CheckboxValue('chkStatunit');
		var Qrycon = $('#cboQryCon').combobox('getValue');
		var SubLocArr   = $('#cboLoc').combobox('getValues');
		var aLocIDs = SubLocArr.join();
		var aStatDimens = $('#cboShowType').combobox('getValue');
		ReportFrame = document.getElementById("ReportFrame");
		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		
		p_URL = Append_Url('dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S430NowAntUse.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aStaType='+aStatunit+"&aQryCon="+ Qrycon);	
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		} 
		
	}
	obj.option1 = function(HospAntUseZL,HospAntUseYF,HospAntUseDL,HospAntUseEL,HospAntUseSL,HospAntUseSLYS){

		var option = {
			    title : {
			        text: '抗菌药物使用情况汇总表',
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
			        data: ['治疗用药人数','预防用药人数','一联人数','二联人数','三联人数','四联人数','四联以上人数']
			    },
			    series : [
			        {
			            name: '全院抗菌药物使用情况',
			            type: 'pie',
			            radius : '50%',
			            center: ['25%', '50%'],
			            data:[
			                {value:HospAntUseZL, name:'治疗用药人数'},
			                {value:HospAntUseYF, name:'预防用药人数'},
			            ]
			        },{
				        name: '全院抗菌药物使用情况',
			            type: 'pie',
			            radius : '50%',
			            center: ['75%', '50%'],
			            data:[
			                {value:HospAntUseDL, name:'一联人数'},
			                {value:HospAntUseEL, name:'二联人数'},
			                {value:HospAntUseSL, name:'三联人数'},
			                {value:HospAntUseSLYS, name:'四联以上人数'}
			            ]
			        },
			    ]
			};
		return option;
	}
    obj.echartLocInfRatio = function(runQuery){
		if (!runQuery) return;
	
		arrRecord = runQuery.rows;
		RemoveArr(arrRecord);
		arrRecord = arrRecord.sort(function(x, y){    
			return parseInt(y.UseAntiCnt) - parseInt(x.UseAntiCnt)
		});
		var HospAntUseZL 	= 0;		//治疗用药人数
		var HospAntUseYF 	= 0;		//预防用药人数
		//var HospAntUseQT 	= 0;		//其他用药人数
		var HospAntUseDL	= 0;		//单用人数
		var HospAntUseEL	= 0;		//二联人数
		var HospAntUseSL	= 0;		//三联人数
		var HospAntUseSLYS	= 0;		//四联以上人数
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			 HospAntUseZL 	+= parseInt(rd["AntCureCount"]);		//治疗用药人数
			 HospAntUseYF 	+= parseInt(rd["AntPreCount"]);		//预防用药人数
			// HospAntUseQT 	+= parseInt(rd["HospAntUseQT"]);		//其他用药人数
			 HospAntUseDL	+= parseInt(rd["CombSingle"]);		//单用人数
			 HospAntUseEL	+= parseInt(rd["CombTwo"]);		//二联人数
			 HospAntUseSL	+= parseInt(rd["CombThree"]);		//三联人数
			 HospAntUseSLYS	+= parseInt(rd["CombFourAndMore"]);		//四联以上人数
			
		}
		
		// 使用刚指定的配置项和数据显示图表。
		obj.myChart.setOption(obj.option1(HospAntUseZL,HospAntUseYF,HospAntUseDL,HospAntUseEL,HospAntUseSL,HospAntUseSLYS),true);
	}
   	obj.ShowEChaert1 = function(){
		obj.myChart.clear()
		var HospID = $('#cboHospital').combobox('getValue');
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= DateFrom
		var Statunit = Common_CheckboxValue('chkStatunit');
		var Qrycon = $('#cboQryCon').combobox('getValue');
		var SubLocArr   = $('#cboLoc').combobox('getValues');
		var aLocIDs = SubLocArr.join();
		var aStatDimens = $('#cboShowType').combobox('getValue');

		obj.myChart.showLoading();	
		var className="DHCHAI.STATV2.S430SHCssAntUse";
		var queryName="QryAntUseTotal";
		$cm({
		    ClassName: className,
		    QueryName: queryName,
		    aHospIDs: HospID,
		    aDateFrom: DateFrom,
			aDateTo:DateTo,
			aStaType:Statunit,
			aQryCon:Qrycon,
			aStatDimens:aStatDimens,
			aLocIDs:aLocIDs,
			page:1,    //可选项，页码，默认1
			rows:999   //可选项，获取多少条数据，默认50
		},
		function(data){
			obj.myChart.hideLoading();    //隐藏加载动画
			obj.echartLocInfRatio(data);

		}
		,function(XMLHttpRequest, textStatus, errorThrown){
			alert("类" + className + ":" + queryName+ "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
			obj.myChart.hideLoading();    //隐藏加载动画
		});
	}
	
}