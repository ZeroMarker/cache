//页面Event
function InitVAESubItemEvent(obj){
	//检索框
	$('#searchBox').searchbox({ 
		searcher:function(value,name){
			obj.gridMonitSItem.load({
				ClassName : "DHCHAI.IRS.VAESubItemSrv",
				QueryName : "QueryMonitSItem",
				aAlias:$.trim(value)
			})
		}	
	});
	//事件初始化
	obj.LoadEvent = function(args){
		//归一词
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		$('#btnEdit').on('click', function(){
			var rd=obj.gridMonitSItem.getSelected();
			obj.InitDialog(rd);
		});
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		
		$('#winBtnEdit').on('click', function(){
			obj.Save();
		});
		$('#winBtnClose').on('click', function(){
			$HUI.dialog('#winEdit').close();
		});
     }
	 // *********************监测项目Event*************************
	//双击编辑
	obj.gridMonitSItem_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//选择
	obj.gridMonitSItem_onSelect = function (){
		var rowData = obj.gridMonitSItem.getSelected();

		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridMonitSItem.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	
	//核心方法-更新
	obj.Save = function(){
		var errinfo=""
		var VAItmCode = $("#txtVAItmCode").val();
		var VAItmDesc = $("#txtVAItmDesc").val();
		var VAResume  = $("#txtVAResume").val();
		var IsActive  = $("#chkVAIsActive").checkbox('getValue')? '1':'0';		                                                                            
	    
		if (!VAItmCode) {
			errinfo = errinfo + "项目代码不允许为空!<br>";
		}
		if (!VAItmDesc) {
			errinfo = errinfo + "项目名称不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var InputStr = obj.RecRowID;
		InputStr += "^" + VAItmCode;  
		InputStr += "^" + VAItmDesc; 
		InputStr += "^" + VAResume;
		InputStr += "^" + IsActive; 
		InputStr += "^" + "";         // 处置日期
		InputStr += "^" + "";         // 处置时间
		InputStr += "^" + $.LOGON.USERID; // 处置人
		
		var flg = $m({
			ClassName:"DHCHAI.IR.VAESubItem",
			MethodName:"Update",
			aInputStr:InputStr
		},false);
		if (parseInt(flg)> 0) {
			obj.RecRowID="";
			obj.gridMonitSItem.reload();	//刷新当前页
			$HUI.dialog('#winEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		}else if(parseInt(flg) == '-100'){
			$.messager.alert("错误提示", "代码重复!" , 'info');
		}else{
			$.messager.alert("错误提示", "保存失败!Error=" + flg, 'info');
		}
	}
	//核心方法-删除
	obj.btnDelete_click = function(){
		if (obj.RecRowID==""){
			$.messager.alert("提示", "请选中数据,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "确认是否删除?", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.VAESubItem",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);
				
				if (flg == '0') {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridMonitSItem.reload(); //刷新当前页
				} else {
					if (parseInt(flg)=='-777') {
						$.messager.alert("提示","-777：当前无删除权限，请启用删除权限后再删除记录!",'info');
					}else {
						$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					}
				}
			} 
		});
	}
    //窗体-初始化
	obj.InitDialog= function(rd){
		if(rd){
			$('#txtVAItmCode').val(rd["VASItmCode"]).validatebox("validate");
			$('#txtVAItmDesc').val(rd["VASItmDesc"]).validatebox("validate");
			$('#txtVAResume').val(rd["VASResume"]);
			$('#chkVAIsActive').checkbox('setValue',rd["VASIsActive"]== "是");
			
			$("#winBtnSave").show();
			$("#winBtnAdd").hide();
			
			obj.RecRowID=rd["ID"];
		}else{
			$('#txtVAItmCode').val("").validatebox("validate");
			$('#txtVAItmDesc').val("").validatebox("validate");
			$('#txtVAResume').val("");
			$('#chkVAIsActive').checkbox('setValue',true);
			
			$("#winBtnSave").hide();
			$("#winBtnAdd").show();
			
			obj.RecRowID = "";
		}
		
		$('#winEdit').show();
		$('#winEdit').dialog({
			title: '监测子项编辑',
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:true
		});
	}
}