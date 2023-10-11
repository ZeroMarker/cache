/// 护士修改分级窗体
showNurWin = function(EmPCLvID){
	
	/*
	if ($("#newNurWin").is(":visible")){
		return;
	}  //窗体处在打开状态,退出
	*/

	/// 分级变更原因
	var url = LINK_CSP+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonEmDocUpdReson&HospID="+LgHospID+"&Type=Nur";
	var option = {
		panelHeight:"auto",
		blurValidValue:true,
		onSelect:function(record){
	        //setEmRecLevel();
	        }
		}
	new ListCombobox("EmNurRea",url,'',option).init(); 
	
	/// 护士修改分级窗口
	var option = {
		iconCls:'icon-w-paper', //hxy 2022-07-29
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		closed:"true"
	};
	
	new WindowUX('护士修改分级', 'newNurWin', '400', '150', option).Init();
}