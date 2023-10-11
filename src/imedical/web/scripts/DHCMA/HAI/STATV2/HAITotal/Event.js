function InitHAITotalWinEvent(obj){	 
   	obj.LoadEvent = function(args){
		$('#ReportFrame').css('display', 'block');
		setTimeout(function(){
			obj.ShowReport();
		},50);
		//表的点击事件
		$('#btnSearchTable').on('click',function(e,value){
			$('#ReportFrame').css('display', 'block');
			$('#EchartDiv').css('display', 'none');
			
			obj.ShowReport();
		});
   	}
	//手卫生展开按钮
	$('#btnHMore').on('click', function(){ 	
		if ($(this).hasClass('expanded')){  //已经展开 隐藏
			$("#btnHMore")[0].innerText="展开";
			$(this).removeClass('expanded');
			$(this).append('<a class="layout-button-down"></a>');			
			$('#HSearchItem').css('display','none');
			$("#HandHy_div").css('height','30px');
		}else{
			$("#btnHMore")[0].innerText="隐藏";
			$(this).addClass('expanded');
			$(this).append('<a class="layout-button-up"></a>');			
			$('#HSearchItem').css('display','block');
			$("#HandHy_div").css('height','112px');
		}
	});
	//抗菌药展开按钮
	$('#btnAMore').on('click', function(){ 	
		if ($(this).hasClass('expanded')){  //已经展开 隐藏
			$("#btnAMore")[0].innerText="展开";
			$(this).removeClass('expanded');
			$(this).append('<a class="layout-button-down"></a>');			
			$('#ASearchItem').css('display','none');
			$("#Ant_div").css('height','30px');
		}else{
			$("#btnAMore")[0].innerText="隐藏";
			$(this).addClass('expanded');
			$(this).append('<a class="layout-button-up"></a>');			
			$('#ASearchItem').css('display','block');
			$("#Ant_div").css('height','173px');
		}
	});
   	obj.ShowReport = function() {
		var aHospID 	= $('#cboHospital').combobox('getValue');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		//手卫生
		var aMethod		= $('#cboMethod').datebox('getValue');
		var aObsType    = $('#cboObsType').datebox('getValue');
		//抗菌药
		var aSubDateType = $('#cboSubDateType').combobox('getValue');
		var aUseSubDateType = $('#useSubDateType').combobox('getValue');
		var aSubHourType = $('#cboSubHourType').combobox('getValue');
		
		var aLocType 	= Common_CheckboxValue('chkStatunit');
		var aQryCon 	= "2";	//$('#cboQryCon').combobox('getValue');
		var aStatDimens = "A";	//$('#cboShowType').combobox('getValue');
		var aLocIDs 	= "";	//$('#cboLoc').combobox('getValues').join(',');		
		
		ReportFrame = document.getElementById("ReportFrame");
		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.HAITotal.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo
				+'&aMethod='+ aMethod+'&aObsType='+aObsType
				+'&aSubDateType='+aSubDateType+'&aSubHourType='+aSubHourType+'&aUseSubDateType='+aUseSubDateType
				+'&aLocType='+aLocType+'&aQryCon='+aQryCon+'&aStatDimens='+aStatDimens+'&aLocIDs='+aLocIDs+'&aPath='+cspPath;		
		
		if ("undefined" !==typeof websys_getMWToken) {
			p_URL  += "&MWToken="+websys_getMWToken();
		}
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		} 
	}
}
