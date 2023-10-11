//页面Event
function InitBactGenusWinEvent(obj){	
    
	obj.LoadEvent = function(args){ 
	    //保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#BactGenusEdit').close();
     	});
		
	    //添加
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd = obj.gridBactGenus.getSelected();
			obj.InitDialog(rd);
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});	
	}
	
	//窗体初始化
	obj.BactGenusEdit =function() {
		 $('#BactGenusEdit').dialog({
			title:'细菌菌属字典',
			iconCls:'icon-w-edit',
			modal: true,
			isTopZindex:true
		});
	}
	
	//保存
	obj.btnSave_click = function(){
		var errinfo = "";
		var BCCode = $.trim($('#txtCode').val());
		var BCDesc = $.trim($('#txtDesc').val());
		
		if (!BCCode) {
			errinfo = errinfo + "代码不允许为空!<br>";
		}
		if (!BCDesc) {
			errinfo = errinfo + "描述不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}	
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + BCCode;
		inputStr = inputStr + CHR_1 + BCDesc;
		
		var flg = $m({
			ClassName:"DHCHAI.DP.LabBactGenus",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:CHR_1
		},false);
		if (parseInt(flg) <= 0) {
			if(parseInt(flg) == -2){
				$.messager.alert("错误提示", "代码重复!" , 'info');
				return;
			}else{
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
				return;
			}
		}else {
			$HUI.dialog('#BactGenusEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.gridBactGenus.reload() ;//刷新当前页
		}
	}
	//删除 
	obj.btnDelete_click = function(){
		if (!obj.RecRowID ){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.DP.LabBactGenus",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);

				if (parseInt(flg) < 0) {
					if (parseInt(flg)=='-777') {
						$.messager.alert("提示","-777：当前无删除权限，请启用删除权限后再删除记录!",'info');
					    return;
					}else {
						$.messager.alert("提示","删除失败!",'info');
						return;
					}
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridBactGenus.reload() ;//刷新当前页
				}
			} 
		});
	}
	
	//单击选中事件
	obj.gridBactGenus_onSelect = function (){
		var rowData = obj.gridBactGenus.getSelected();
	
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			
			obj.gridBactGenus.clearSelections();  //清除选中行
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}	
	
    //双击弹出编辑事件
	obj.gridBactGenus_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	
	//窗口初始化
	obj.InitDialog = function(rd){
		if(rd){
			obj.RecRowID = rd["ID"];
			var Code = rd["BCCode"];
			var Desc = rd["BCDesc"];			
			$('#txtCode').val(Code);
			$('#txtDesc').val(Desc);
		}else{
			obj.RecRowID = "";
			$('#txtCode').val('');
			$('#txtDesc').val('');	
		}
		$('#BactGenusEdit').show();
		obj.BactGenusEdit();
	}
}