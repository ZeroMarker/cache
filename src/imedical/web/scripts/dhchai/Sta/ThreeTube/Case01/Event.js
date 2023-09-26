function InitCtlResultWinEvent(obj){
	CheckSpecificKey();
	// ��ʼ��Ȩ��
	obj.AdminPower  = '0';
	if (typeof tDHCMedMenuOper != 'undefined')
	{
		if (typeof tDHCMedMenuOper['Admin'] != 'undefined')
		{
			obj.AdminPower  = tDHCMedMenuOper['Admin'];
		}
	}
	
	//��ֵ��ʼֵ
    $("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("#cboHospital");  //��Ⱦ������	

	$("#cboHospital option:selected").next().attr("selected", true)
	$("#cboHospital").select2();
	//��select2��ֵchange�¼�
	$("#cboHospital").on("select2:select", function (e) { 
		//���ѡ�е�ҽԺ
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		$("#cboInfLocation").data("param",id+"^^I|E^E^1");
		$.form.SelectRender("cboInfLocation");  //��Ⱦ������	
	});
		
	$("#cboInfLocation").data("param",$.form.GetValue("cboHospital")+"^^I|E^W^1");
	$.form.SelectRender("cboInfLocation");
	$.form.SelectRender("cboRepType");
	var myChart = echarts.init(document.getElementById('Case01'),'theme');
	var option1 = {
		title : {
			text: '��е��ظ�Ⱦͳ��',
			x:'left'
		},
		tooltip: {
			trigger: 'axis',
		},
		toolbox: {
			"show": true
		},
		legend: {
			data:['ʹ������','��Ⱦ��','��Ⱦ����'],
			selected: {
				'��Ⱦ����': false
			}
		},
		xAxis: [
			{
				type: 'category',
				data: [],
				axisLabel: {
							margin:12,
							rotate:45,
							interval:0,
							// ʹ�ú���ģ�壬���������ֱ�Ϊ�̶���ֵ����Ŀ�����̶ȵ�����
							formatter: function (value, index) {
								//�����ǩ���������к�ʡ��
								if(value.length>7){
									return value.substr(0,8)+'\n'+value.substr(8,15);
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
				name: 'ʹ������',
				splitLine: {
					show: false
				},
				axisLabel: {
					formatter: '{value} '
				}
			},
			{
				type: 'value',
				name: '��Ⱦ��(��)',
				splitLine: {
					show: false
				},
				axisLabel: {
					formatter: '{value} ��'
				}
			}
		],
		series: [
			 {
				name:'ʹ������',
				type:'bar',
				data:[],
				barMaxWidth:50,
				label: {
					show:true,
					formatter:"{c}"
				}
			},
			{
				name:'��Ⱦ��',
				type:'line',
				yAxisIndex: 1,
				data:[],
				label: {
					show:true,
					formatter:"{c}��"
				}
			},
			{
				name:'��Ⱦ����',
				type:'bar',
				yAxisIndex: 1,
				data:[],
				label: {
					show:true,
					formatter:"{c}"
				}
			}
		   
		]
	};
	// ʹ�ø�ָ�����������������ʾͼ��
	myChart.setOption(option1);
	
	obj.level="level-M";
	obj.season="";
	obj.year=$.form.GetValue("DateFrom").substr(0,4)
	$("#year").text($.form.GetValue("DateFrom").substr(0,4)+"��")
	$(".sta-level .btn").on('click', function(){
		$(".sta-level .btn").css('background-color','#DEDEDE');
		$(".sta-level .btn").css('color','#000000');
		$("#"+this.id).css("background-color","#40A2DE");
		$("#"+this.id).css("color","#FFFFFF");
		$(".sta-year .btn").css("background-color","#DEDEDE");
		$(".sta-year .btn").css("color","#000000");
		$(".sta-season .btn").css('background-color','#DEDEDE');
		$(".sta-season .btn").css('color','#000000');
		if(this.id=="level-Y"){
			$(".sta-year .btn").css("background-color","#40A2DE");
			$(".sta-year .btn").css("color","#FFFFFF");
		}
		obj.level=this.id;
	});
	$(".sta-season .btn").on('click', function(){
		$(".sta-year .btn").css("background-color","#DEDEDE");
		$(".sta-year .btn").css("color","#000000");
		$(".sta-level .btn").css('background-color','#DEDEDE');
		$(".sta-level .btn").css('color','#000000');
		$("#level-S").css("background-color","#40A2DE");
		$("#level-S").css("color","#FFFFFF");
		$(".sta-season .btn").css('background-color','#DEDEDE');
		$(".sta-season .btn").css('color','#000000');
		$("#"+this.id).css("background-color","#40A2DE");
		$("#"+this.id).css("color","#FFFFFF");
		obj.season=this.id;
		obj.level="level-S";
	});
	$(".sta-year li").on('click', function(){
		var year=$("#"+this.id+" a").text();
		$("#year").text(year+"��");
		obj.year=year;
	});
	/****************/
    //��ѯ��ť
    $("#btnQuery").on('click', function(){
		var LocID=$.form.GetValue("cboInfLocation")
		var MonthFrom=$.form.GetValue("DateFrom")
		var MonthTo=$.form.GetValue("DateTo")
		var RepType=$.form.GetValue("cboRepType")
		var HAICase=""
		var TubeCount=""
		
		switch(RepType)
		{
			case "1":
				HAICase="INFUC";
				TubeCount="CountUC";
				break;
			case "2":
				HAICase="INFVAP";
				TubeCount="CountVAP";
				break;
			case "3":
				HAICase="INFPICC";
				TubeCount="CountPICC";
				break;
		}
		
		var dataInput = "";
		if(obj.level=="level-M"){
			var ErrorStr = "";
			if (MonthFrom=="") {
				ErrorStr += '��ѡ��ʼ����!<br/>';
			}
			if (MonthTo == "") {
				ErrorStr += '��ѡ���������!<br/>';
			}
			if (MonthFrom > MonthTo) {
				ErrorStr += '��ʼ���ڲ��ܴ��ڽ�������!<br/>';
			}
			if (ErrorStr != '') {
					layer.msg(ErrorStr,{icon: 0});
					return;
			}
			dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + 'QryECResultByTime' + "&Arg1=" + LocID + "&Arg2=" + MonthFrom + "&Arg3=" + MonthTo+ "&Arg4=" + HAICase + "&Arg5=" + TubeCount + "&ArgCnt=" + 5;
		}else if(obj.level=="level-S"){
			switch(obj.season)
			{
				case "season-1":
					MonthFrom=obj.year+"-01";
					MonthTo=obj.year+"-03";
					break;
				case "season-2":
					MonthFrom=obj.year+"-04";
					MonthTo=obj.year+"-06";
					break;
				case "season-3":
					MonthFrom=obj.year+"-07";
					MonthTo=obj.year+"-09";
					break;
				case "season-4":
					MonthFrom=obj.year+"-10";
					MonthTo=obj.year+"-12";
					break;
				default:
					layer.msg('��ѡ�񼾶�!',{icon: 2});
			}
			dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + 'QryECResultByLoc' + "&Arg1=" + LocID + "&Arg2=" + MonthFrom + "&Arg3=" + MonthTo+ "&Arg4=" + HAICase + "&Arg5=" + TubeCount + "&ArgCnt=" + 5;
		}else if(obj.level=="level-Y"){
			MonthFrom=obj.year+"-01";
			MonthTo=obj.year+"-12";
			dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + 'QryECResultByLoc' + "&Arg1=" + LocID + "&Arg2=" + MonthFrom + "&Arg3=" + MonthTo+ "&Arg4=" + HAICase + "&Arg5=" + TubeCount + "&ArgCnt=" + 5;
		}
		
		var LocDesc=$.form.GetText("cboInfLocation")
		if(LocID=="") LocDesc="���п���"
		var textCon=LocDesc+"��"+MonthFrom+"��"+MonthTo
		$("#condition").text(textCon);
		$.ajax({
			url: "./dhchai.query.csp",
			type: "post",
			timeout: 30000, //30�볬ʱ
			async: true,   //�첽
			beforeSend: function() {
				myChart.showLoading();
			},
			data: dataInput,
			success: function(data, textStatus){
				myChart.hideLoading();    //���ؼ��ض���
				var retval = (new Function("return " + data))();
				obj.echartLocInfRatio(retval);
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				alert("��" + tkclass + ":" + tkQuery + "ִ�д���,Status:" + textStatus + ",Error:" + errorThrown);
				myChart.hideLoading();    //���ؼ��ض���
			}
		});
		
	});
	
	obj.arrTimeG=""
	obj.echartLocInfRatio = function(runQuery){
		if (!runQuery) {
			layer.alert("��ѯʧ�ܣ������ѯ������",{icon: 2});
			return  false;
		}
		var arrTime = new Array();
		var arrInfRatio = new Array();
		var arrInfCount = new Array();
		var arrDateCount = new Array();
		obj.arrTimeG=arrTime
		var arrRecord = runQuery.record;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrTime.push(rd["ECTime"]);
			arrInfCount.push(rd["Value1"]);
			arrDateCount.push(rd["Value2"]);
			arrInfRatio.push(parseFloat(rd["Ratio"]*10).toFixed(2));
		}
		myChart.setOption({        //��������ͼ��
			xAxis: {
				data: arrTime
			},
			series: [{
				data:arrDateCount
			},{
				data:arrInfRatio
			},{
				data:arrInfCount
			}]
		});
		
   }
   
	myChart.on('click', function (params) {
		if (params.value>0){
			if (params.seriesType=="line"){
				if (params.seriesIndex==1){
					var LocID=$.form.GetValue("cboInfLocation");
					var Month=obj.arrTimeG[params.dataIndex];
					var RepType=$.form.GetValue("cboRepType");
					var strHtml="";
					var dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + 'QryInfPatList' + "&Arg1=" + LocID + "&Arg2=" + Month + "&Arg3=" + RepType + "&ArgCnt=" + 3;
					$.ajax({
						url: "./dhchai.query.csp",
						type: "post",
						timeout: 30000, //30�볬ʱ
						async: true,   //�첽
						data: dataInput,
						success: function(data, textStatus){
							var retval = (new Function("return " + data))();
							var arrRecord = retval.record;
							for (var indRd = 0; indRd < arrRecord.length; indRd++){
								var rd = arrRecord[indRd];
								strHtml=strHtml+"<tr><td>"+rd["ind"]+"</td>"
								strHtml=strHtml+"<td>"+rd["PatMrNo"]+"</td>"
								strHtml=strHtml+"<td>"+rd["PatName"]+"</td>"
								strHtml=strHtml+"<td>"+rd["PatSex"]+"</td>"
								strHtml=strHtml+"<td>"+rd["InfPosDescs"]+"</td>"
								strHtml=strHtml+"<td>"+rd["InfLocDesc"]+"</td>"
								strHtml=strHtml+"<td>"+rd["IRInfDate"]+"</td>"
								strHtml=strHtml+"<td>"+rd["StatusDesc"]+"</td></tr>"
							}
							$("#tableInfList tbody").html(strHtml)
							layer.open({
								type: 1,
								zIndex: 99999,
								skin: 'btn-all-blue',
								area: ['80%','60%'],
								title:'',
								fixed: false, //���̶�
								content: $('#tableInfList'),
								success: function(layero, index){
								
								},
							});
						},
						error: function(XMLHttpRequest, textStatus, errorThrown){
							alert("ִ�д���,Status:" + textStatus + ",Error:" + errorThrown);
						}
					});
				}
			}
		}
	});
   
}

