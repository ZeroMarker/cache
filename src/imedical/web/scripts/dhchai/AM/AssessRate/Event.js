//页面Event
function InitAssRateWinEvent(obj){	
    
	obj.LoadEvent = function(args){ 
		$('#btnQuery').on('click', function(){
	     	obj.btnQuery_click();
     	});
		
	   	$HUI.combogrid('#cbgModel',{
			onSelect:function(index, row){		
				var ModelID = row.ID;
				var AdmStatus = row.AdmStatus;
				if (AdmStatus) {
					$HUI.radio('#radAdmStatus-'+AdmStatus).setValue(true);
				}
				objSttDate = row.SttDate;
				objEndDate = row.EndDate;
						
				$('#dtDateFrom').datebox('setValue',objSttDate);
				$('#dtDateTo').datebox('setValue',objEndDate);
			
				obj.btnQuery_click();
			}
		});
	
	}
	
	//查询
	obj.btnQuery_click  = function(){
		var ModelID =$('#cbgModel').combogrid('getValue');
		var aDateFrom = $('#dtDateFrom').datebox('getValue');
		var	aDateTo = $('#dtDateTo').datebox('getValue');
		if (!ModelID) {
			$.messager.alert("提示", "选择评估模型", 'info');
			return;
		}
		var errinfo = "";
		if ((Common_CompareDate(objSttDate,aDateFrom)>0)||(Common_CompareDate(aDateTo,objEndDate)>0)){
			errinfo = errinfo + "开始日期、结束日期需在评估模型时段内!<br>";
		}
		if (Common_CompareDate(aDateFrom,aDateTo)>0){
			errinfo = errinfo + "开始日期不能晚于结束日期!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		obj.gridAssRate.load({
		    ClassName:'DHCHAI.AMS.AssessRateSrv',
			QueryName:'QryAssessRate',
			aModelDr:ModelID,
			aDateFrom:aDateFrom,
			aDateTo:aDateTo
	    });
	}
	
	//窗体初始化
	obj.OpenDtl = function(aType){
		if (aType==1) var title ='总人数明细数据';
		if (aType==2) var title ='感染人数明细数据';
		if (aType==3) var title ='漏筛人数明细数据';
		if (aType==3) var title ='自报人数明细数据';
		
		var ModelID =$('#cbgModel').combogrid('getValue');
		var aDateFrom = $('#dtDateFrom').datebox('getValue');
		var	aDateTo = $('#dtDateTo').datebox('getValue');
		
		$('#RateDtl').show();
		obj.gridRateDtl.load({
		    ClassName:'DHCHAI.AMS.AssessRateSrv',
			QueryName:'QryRateDtl',
			aModelDr:ModelID,
			aDateFrom:aDateFrom,
			aDateTo:aDateTo,
			aType:aType
	    });
	    
		$HUI.dialog('#RateDtl',{
			title:title,
			iconCls:'icon-w-paper',
			width: 1300,    
			height: 560, 
			modal: true,
			isTopZindex:true
		});
	}
	
	//摘要信息
	obj.OpenView = function(aEpisodeID){
		var t=new Date();
		t=t.getTime();
		var strUrl = "./dhchai.ir.view.main.csp?PaadmID=" + aEpisodeID + "&PageType=WinOpen&t=" + t;
		websys_showModal({
			url:strUrl,
			title:'医院感染集成视图',
			iconCls:'icon-w-paper',  
			width:'95%',
			height:'95%'
		});
	}
}
