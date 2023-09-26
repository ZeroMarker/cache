//页面Event
function InitNotInPathQueryWinEvent(obj){	
    
	obj.LoadEvent = function(args){ 
		//查询
		$('#btnQuery').on('click', function(){
			obj.NotInPathQueryLoad();
		});
		
		//科室选择事件
		$HUI.combobox("#cboLoc", {
			onSelect:function(){
				obj.NotInPathQueryLoad();
			}
		});
	}
  
	obj.NotInPathQueryLoad = function(){
		var DateFrom = $('#DateFrom').datebox('getValue');
		var DateTo = $('#DateTo').datebox('getValue');
		if ((DateFrom == '')||(DateTo == '')) {
			$.messager.alert("提示","开始日期、结束日期不允许为空!",'info');
			return;
		}
		if (Common_CompareDate(DateFrom,DateTo)>0) {
			$.messager.alert("提示","开始日期不能大于结束日期!",'info');
			return;
		}
		var LocID=Common_GetValue('cboLoc');
		if(tDHCMedMenuOper['admin']<1) LocID=session['DHCMA.CTLOCID'].split("!!")[0];
		obj.GridNotInPathQuery.load({
			ClassName:"DHCMA.CPW.OPCPS.ApplySrv",
			QueryName:"QryNotInPathInfo",	
			aDateFrom: Common_GetValue('DateFrom'), 
			aDateTo:Common_GetValue('DateTo'), 
			aHospID:Common_GetValue('cboSSHosp'),
			aLocID:LocID			
	    });	
    }
}