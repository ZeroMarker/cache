function InitS430cssantuseWinEvent(obj){
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
		var SurNumID 	= $('#cboSurNum').combobox('getValue');	
		var aLocType 	= Common_CheckboxValue('chkStatunit');
		//var aQryCon= $('#cboQryCon').combobox('getValue');
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs = $('#cboLoc').combobox('getValues').join(',');	
		ReportFrame = document.getElementById("ReportFrame");
	
		p_URL = Append_Url('dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S430CssAntUse.raq&aSurNumID='+SurNumID +'&aStaType='+aLocType);	
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		} 
		
	}
	obj.option1 = function(HospAntUseZL,HospAntUseYF,HospAntUseZLYF,HospAntUseWZZ,HospAntUseQT,HospAntUseDL,HospAntUseEL,HospAntUseSL,HospAntUseESIL,HospAntUseSLYS){
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
			        data: ['治疗用药人数','预防用药人数','治疗+预防用药人数','一联人数','二联人数','三联人数','四联及以上人数']
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
			                {value:HospAntUseZLYF, name:'治疗+预防用药人数'}
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
			                {value:HospAntUseSLYS, name:'四联及以上人数'}
			            ]
			        },
			    ]
			};
		return option;
	}
    obj.echartLocInfRatio = function(runQuery){
		if (!runQuery) return;
		var arrRecord = runQuery.rows;
		RemoveArr(arrRecord);
		var HospAntUseZL=0;
		var HospAntUseYF=0;
		var HospAntUseZLYF=0;
		var HospAntUseWZZ=0;
		var HospAntUseQT=0;
		var HospAntUseDL=0;
		var HospAntUseEL=0;
		var HospAntUseSL=0;
		var HospAntUseESIL=0;
		var HospAntUseSLYS=0;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			
			HospAntUseZL 	+= parseInt(rd["HospAntUseZL"]);		//治疗用药人数
			HospAntUseYF 	+= parseInt(rd["HospAntUseYF"]);		//预防用药人数
			HospAntUseZLYF 	+= parseInt(rd["HospAntUseZLYF"]);		//治疗+预防用药人数
			HospAntUseWZZ 	+= parseInt(rd["HospAntUseWZZ"]);		//无指征用药人数
			HospAntUseQT 	+= parseInt(rd["HospAntUseQT"]);		//其他用药人数
			HospAntUseDL	+= parseInt(rd["HospAntUseDL"]);		//单联人数
			HospAntUseEL	+= parseInt(rd["HospAntUseEL"]);		//二联人数
			HospAntUseSL	+= parseInt(rd["HospAntUseSL"]);		//三联人数
			HospAntUseESIL	+= parseInt(rd["HospAntUseESIL"]);		//四联人数
			HospAntUseSLYS	+= parseInt(rd["HospAntUseESIL"]);		//四联及以上人数
			
		}
		
		// 使用刚指定的配置项和数据显示图表。
		obj.myChart.setOption(obj.option1(HospAntUseZL,HospAntUseYF,HospAntUseZLYF,HospAntUseWZZ,HospAntUseQT,HospAntUseDL,HospAntUseEL,HospAntUseSL,HospAntUseESIL,HospAntUseSLYS),true);
	}
   	obj.ShowEChaert1 = function(){
		obj.myChart.clear()
		var SurNumID 	= $('#cboSurNum').combobox('getValue');	
		var aLocType 	= Common_CheckboxValue('chkStatunit');
	
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs = $('#cboLoc').combobox('getValues').join(',');	

		obj.myChart.showLoading();	
		var className="DHCHAI.STATV2.S430CssAntUse";
		var queryName="CssQryAntUse";
		$cm({
		    ClassName: className,
		    QueryName: queryName,
		    aSurNumID: SurNumID,
		    aStaType: aLocType,
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