function InitWinEvent(obj) {
	obj.LoadEvent = function(){
		$('#btnQuery').on("click", function(){
			obj.btnQuery_click(); 
		});
	}
	obj.btnQuery_click=function(RepID,LocID){
		if (obj.CheckReport() != true) return; //数据校验
			var status=Common_RadioLabel('status')
			if(status=="非暴发"){status=2}
			if(status=="暴发"){status=1}
			var IsActive =$("#ActRep").checkbox('getValue')
			IsActive = (IsActive==true? 1: 0);
			if(IsActive==1){status=1}
			$('#gridReport').datagrid('load',{
			   ClassName:'DHCHAI.IRS.CCWarningRepSrv',
		       QueryName:'QryFindRepByLoc',
		       aLocID:$("#cboLocation").combobox('getValue'),
		       aStatus:status,
		       IsActive:IsActive,
		       aDateFrom:$("#DateFrom").datebox('getValue'),
		       aDateTo:$("#DateTo").datebox('getValue')
			});
		}
	obj.OperRepReport_Click=function(RepID,LocID){
		var Item = $m({
			ClassName:"DHCHAI.IR.CCWarningRep",
			MethodName:"GetWarnItemById",
			aId:RepID
		},false);
		var url='../csp/dhcma.hai.ir.ccwarningrep.csp?LocID=' + LocID+'&ReportID='+RepID;
		websys_showModal({
			url:url,
			title:'医院感染暴发报告:'+Item,
			iconCls:'icon-w-epr',
			width:1250,
			height:'84%',
			closable:true,
		});	
	}
	obj.OpenLocPatients=function(LocID,WarnDate,CCWarnItem,WarnItem){
		var ArrWarnItem=WarnItem.split(":")
		var WarnItem=ArrWarnItem[1]
		$('#LocPatientsInfo').datagrid('load',{
			ClassName:"DHCHAI.IRS.NewCCWaringSrv",
			QueryName:"QryWarnPatList",
			aLocID:LocID,
			aWarnDate:WarnDate,
			aWarnItems:CCWarnItem,
			aSelItem:WarnItem
		});
		$('#winEdit_three').show();
		obj.SetDiaglog_three();
		}
		
	obj.bf = function(LocID,qryWarnDate,selItems,qryWarnItems){
		var selItems=selItems.split(":")[1]
		$.messager.confirm("提示", selItems+"已散发处置，是否需要报卡", function (r) {
			if (r) {				
				var url='../csp/dhcma.hai.ir.ccwarningrep.csp?LocID=' + LocID+'&ReportID='+""+'&qryDate='+qryWarnDate+'&selItems='+selItems+'&WarnItems='+qryWarnItems;;
				websys_showModal({
					url:url,
					title:'医院感染暴发报告:'+selItems,
					iconCls:'icon-w-epr',
					width:1250,
					height:'84%',
					onBeforeClose:function(){ //关闭窗口时调用查询方法实现状态更新
						obj.btnQuery_click()
					}
				});	
			} 
		});	
	}
			
	obj.fbf = function(LocID,qryWarnDate,selItems,qryWarnItems){
		var selItems=selItems.split(":")[1]
		$.messager.confirm("提示", selItems+"已报卡，是否需要散发处置", function (r) {
		if (r) {		
			var InputStr = "";
			InputStr += "^" + LocID;
			InputStr += "^" + selItems;
			InputStr += "^" + qryWarnDate;
			InputStr += "^" + "2"; 
			InputStr += "^" + "";      // 处置日期
			InputStr += "^" + "";      // 处置时间
			InputStr += "^" + $.LOGON.USERID; // 处置人
			InputStr += "^" + "";     // 处置意见
			InputStr += "^" + "";     // 报告ID
			InputStr += "^#" + qryWarnItems;	//查询条件
			var retval = $m({
					ClassName:"DHCHAI.IR.CCWarningAct",
					MethodName:"Update",
					aInput:InputStr,
					aSeparate:"^"
				},false);
			if (parseInt(retval)>0){
				$.messager.popover({msg: '【散发】处置成功！',type:'success',timeout: 1000});
			} else {
				$.messager.popover({msg: '【散发】处置失败！',type:'error',timeout: 1000});
			}
			obj.btnQuery_click()
		}
	});		
	}
			
	obj.sc = function(xID){
		$.messager.confirm("提示", "是否删除选中数据?", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CCWarningAct",
					MethodName:"DeleteById",
					aId:xID
				},false);	
				if (parseInt(flg) < 0) {
					$.messager.alert('删除失败!','info');
					return;
				}else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.btnQuery_click()
				}
			} 
		});
		}
	obj.CheckReport = function(){
		var errStr = "";					
		if ($("#DateFrom").datebox('getValue')=="") {
			errStr += "请选择开始时间!<br>";		
		}
		if ($("#DateTo").datebox('getValue')=="") {
			errStr += "请选择结束时间!<br>";	
		}
		if(errStr != "") {
			$.messager.alert("提示", errStr, 'error');
			return false;
		}
		return true;
	}
}

