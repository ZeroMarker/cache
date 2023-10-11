//页面Event
function InitHandHyQryWinEvent(obj) {
   obj.LoadEvent = function(args){
	    $('#girdHandHyQry').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0

		//查询按钮
		$("#btnQuery").on('click',function(){
			obj.ReLoadData();
		});
	}
	
	//重新加载表格数据
	obj.ShowHandHyReg = function(RegID,ObsLocID,ObsDate,ObsPage,ObsMethod,ObsUser){
		var strUrl = './dhcma.hai.ir.handhy.reg.csp?RegID='+RegID+'&ObsLocID='+ObsLocID+'&ObsDate='+ObsDate+'&ObsPage='+ObsPage+'&ObsMethod='+ObsMethod+'&ObsUser='+ObsUser;
		websys_showModal({
			url:strUrl,
			title:'手卫生依从调查',
			iconCls:'icon-w-epr',  
			width:'95%',
			height:'95%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				obj.ReLoadData();
			} 
		});
	}
	//重新加载表格数据
	obj.ReLoadData = function(){
		var HospIDs	    = $('#cboHospital').combobox('getValue');
		var DateFrom	= $('#DateFrom').datebox('getValue');
		var DateTo		= $('#DateTo').datebox('getValue');
		var Loc 		= $("#cboLoc").combobox('getValue');
		var Method 		= $("#cboMethod").combobox('getValue');
		
		if (DateFrom==""){
			$.messager.alert("提示","请选择开始日期！", 'info');
			return;
		}
		if (DateTo==""){
			$.messager.alert("提示","请选择结束日期！", 'info');
			return;
		}
		if(Common_CompareDate(DateFrom,DateTo)==1){
			$.messager.alert("提示","开始日期不能大于结束日期！", 'info');
			return;
		}
		if(Common_CompareDate(DateFrom,Common_GetDate(new Date()))==1){
			$.messager.alert("提示","开始日期不能大于当前日期！", 'info');
			return;
		}
		
		$("#girdHandHyQry").datagrid("loading");
		$cm ({
			ClassName:"DHCHAI.IRS.HandHyRegSrv",
			QueryName:"HandHyRegQry",
			ResultSetType:"array",
			aHospIDs:HospIDs,
			aLocID:Loc,
			aDateFrom:DateFrom,
			aDateTo:DateTo,
			aMethod:Method,
			page:1,
			rows:99999
		},function(rs){
			$('#girdHandHyQry').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
		
	};
}