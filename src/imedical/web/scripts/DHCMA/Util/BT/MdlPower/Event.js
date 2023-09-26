//页面Event
function InitMdlPowerListWinEvent(obj){
	obj.LoadEvent = function(args){
		//保存按钮操作
		$('#btnClear').on('click', function(){
			obj.btnClear_click();
		});
		
		//加载安全组列表
		obj.gridSSGroupLoad();
	}
	
	obj.btnClear_click = function(){
		$.messager.confirm("确认", "是否清空所有模块操作授权?", function (r) {			
			if (r) {
				var rows = $('#treegridMdlPower').treegrid('getCheckedNodes','checked');
				$.each(rows,function(ind,row){
					if (row["MdlRoleID"]){
						obj.UpdateMdlPower(row,false);
					}
				})
			}
		});
	}
	
	obj.gridSSGroup_onSelect = function(){
		var rowData = obj.gridSSGroup.getSelected();
		if (rowData["OID"] == obj.SSGroupID) {
			obj.SSGroupID = "";
			obj.gridSSGroup.clearSelections();
		} else {
			obj.SSGroupID = rowData["OID"];
		}
		obj.treegridMdlPowerLoad();
	}
	
	obj.UpdateMdlPower = function(row,checked){
		var MdlID = row["MdlID"];
		var MdlRoleID = row["MdlRoleID"];
		var IsActive=(checked ? 1 : 0);
		var inputStr = obj.SSGroupID + "^" + MdlID + "^" + MdlRoleID + "^" + IsActive + "^" + session['DHCMA.USERID'];
		var flg = $m({
			ClassName:"DHCMA.Util.BTS.MdlPowerSrv",
			MethodName:"UpdateMdlPower",
			aInputStr:inputStr
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "请选择安全组!" , 'info');  //未选择安全组，返回0
			}else{
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		} else {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.treegridMdlPowerLoad();
		}
	}
	
	obj.gridSSGroupLoad = function(){
		$cm({
			ClassName:"DHCMA.Util.EPS.SSGroupSrv",
			QueryName:"QrySSGrpInfo",
			aAlias:obj.SSGroupAlias,	
			ResultSetType:"array",	
			page:1,
			rows:999    //可选项，获取多少条数据，默认50
		},function(rows){
			$('#gridSSGroup').datagrid('loadData', rows);
		});
	}
	obj.treegridMdlPowerLoad = function(){
	    $cm({
			ClassName:"DHCMA.Util.BTS.MdlPowerSrv",
			QueryName:"QryMdlPower",
			aSSGrpID:obj.SSGroupID,
			aProductDr:"",	
			ResultSetType:"array",	
			page:1,
			rows:999    //可选项，获取多少条数据，默认50
		},function(rows){
			obj.treegridMdlPower.loadData({"rows":rows});
		});
	}
}