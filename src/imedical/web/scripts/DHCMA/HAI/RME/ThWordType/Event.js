//页面Event
function InitThWordTypeWinEvent(obj){
	//事件初始化
	obj.LoadEvent = function(args){
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		$('#btnEdit').on('click', function(){
			var rd=obj.gridThWordType.getSelected()
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
    //双击编辑
	obj.gridThWordType_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//选择
	obj.gridThWordType_onSelect = function (){
		var rowData = obj.gridThWordType.getSelected();

		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridThWordType.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	
	//核心方法-更新
	obj.Save = function(){
		
		var errinfo = "";
		
		var Code = $("#txtCode").val();
		var Desc = $("#txtDesc").val();
		var ThemeTypeDr = $("#cboThemeType").combobox("getValue");
	
		if (!Code) {
			errinfo = errinfo + "代码不允许为空!<br>";
		}
	
		if (!Desc) {
			errinfo = errinfo + "名称不允许为空!<br>";
		}
	
		if (!ThemeTypeDr) {
			errinfo = errinfo + "主题类型不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var InputStr = obj.RecRowID;
		InputStr += "^" + Code;
		InputStr += "^" + Desc;
		InputStr += "^" + ThemeTypeDr;
	
		var flg = $m({
			ClassName:"DHCHAI.RME.ThWordType",
			MethodName:"Update",
			aInputStr:InputStr
		},false);
		if (parseInt(flg)> 0) {
			obj.RecRowID="";
			obj.gridThWordType.reload() ;//刷新当前页
			$HUI.dialog('#winEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		}else if(parseInt(flg) == '-100'){
			$.messager.alert("错误提示", "唯一性重复!!" , 'info');
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
					ClassName:"DHCHAI.RME.ThWordType",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);
				
				if (flg == '0') {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridThWordType.reload(); //刷新当前页
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
		
			$("#txtCode").val(rd["Code"]).validatebox("validate");
			$("#txtDesc").val(rd["Desc"]).validatebox("validate");
			$("#cboThemeType").combobox("setValue",rd["ThemeTypeID"]);
			$("#cboThemeType").combobox("setText",rd["ThemeTypeDesc"]);
			
			obj.RecRowID=rd["ID"];
		}else{
			$("#txtCode").val('').validatebox("validate");
			$("#txtDesc").val('').validatebox("validate");
			$("#cboThemeType").combobox("setValue",'');
			
			obj.RecRowID = "";
		}
		
		$('#winEdit').show();
		$('#winEdit').dialog({
			title: '主题词分类编辑',
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:true
		});
	}
}