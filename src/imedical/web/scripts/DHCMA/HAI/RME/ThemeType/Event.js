//页面Event
function InitThemeTypeWinEvent(obj){
	//事件初始化
	obj.LoadEvent = function(args){
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		$('#btnEdit').on('click', function(){
			var rd=obj.gridThemeType.getSelected()
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
	obj.gridThemeType_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//选择
	obj.gridThemeType_onSelect = function (){
		var rowData = obj.gridThemeType.getSelected();

		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridThemeType.clearSelections();
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
		var VersionDr = $("#cboVersion").combobox("getValue");
        var IsActive = $("#chkActive").checkbox('getValue')? '1':'0';
		
		if (!Code) {
			errinfo = errinfo + "代码不允许为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称不允许为空!<br>";
		}
		if (!VersionDr) {
			errinfo = errinfo + "词库版本不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var InputStr = obj.RecRowID;
		InputStr += "^" + Code;       // 主题分类代码
		InputStr += "^" + Desc;       // 主题分类名称
		InputStr += "^" + VersionDr;  // 词库版本ID 
		InputStr += "^" + IsActive;   // 是否有效
		InputStr += "^" + "";         // 处置日期
		InputStr += "^" + "";         // 处置时间
		InputStr += "^" + $.LOGON.USERDESC; // 处置人姓名
		
		var flg = $m({
			ClassName:"DHCHAI.RME.ThemeType",
			MethodName:"Update",
			aInputStr:InputStr
		},false);
		if (parseInt(flg)> 0) {
			obj.RecRowID="";
			obj.gridThemeType.reload() ;//刷新当前页
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
					ClassName:"DHCHAI.RME.ThemeType",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);
				
				if (flg == '0') {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridThemeType.reload(); //刷新当前页
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
			
			$('#txtCode').val(rd["Code"]).validatebox("validate");
			$('#txtDesc').val(rd["Desc"]).validatebox("validate");
			$('#cboVersion').combobox('setValue',rd["VerID"]);
			$('#cboVersion').combobox('setText',rd["VerDesc"]);

			$('#chkActive').checkbox('setValue',rd["IsActive"]== 1);
			
			obj.RecRowID=rd["ID"];
		}else{
			$('#txtCode').val('').validatebox("validate");
			$('#txtDesc').val('').validatebox("validate");
			$('#cboVersion').combobox('setValue','');
			$('#chkActive').checkbox('setValue',false);
			
			obj.RecRowID = "";
		}
		
		$('#winEdit').show();
		$('#winEdit').dialog({
			title: '主题分类编辑',
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:true
		});
		
	}
}