//页面Event
function InitWinEvent(obj){
	//事件初始化
	obj.LoadEvent = function(args){
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		$('#btnEdit').on('click', function(){
			var rd=obj.gridSystemMap.getSelected()
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
	obj.gridSystemMap_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//选择
	obj.gridSystemMap_onSelect = function (){
		var rowData = obj.gridSystemMap.getSelected();

		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridSystemMap.clearSelections();
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
		var SysCode = $("#txtSysCode").val();
		var SysDesc = $("#txtSysDesc").val();
		var HISCode = $("#txtHISCode").val();
		var TypeDr = $("#cboType").combobox("getValue");
		var HospDr = $("#cboHosp").combobox("getValue");
       	var IsActive = $("#chkActive").checkbox('getValue');
		IsActive = (IsActive==true? 1 : 0);
		
		if (!SysCode) {
			errinfo = errinfo + "系统代码不允许为空!<br>";
		}
		if (!SysDesc) {
			errinfo = errinfo + "系统名称不允许为空!<br>";
		}
		if (!HISCode) {
			errinfo = errinfo + "HIS关联码不允许为空!<br>";
		}
		if (!TypeDr) {
			errinfo = errinfo + "系统分类不允许为空!<br>";
		}
		if (!HospDr) {
			errinfo = errinfo + "医院选择不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return "-100";
		}
		
		var InputStr = obj.RecRowID;
		InputStr += "^" + SysCode; // 子系统代码
		InputStr += "^" + SysDesc; // 子系统名称 
		InputStr += "^" + HISCode; // HIS关联码
		InputStr += "^" + TypeDr;  // 系统类型 
		InputStr += "^" + HospDr;  // 医院 
		InputStr += "^" + IsActive;
		InputStr += "^" + "";      // 处置日期
		InputStr += "^" + "";      // 处置时间
		InputStr += "^" + $.LOGON.USERID; // 处置人
		
		var flg = $m({
			ClassName:"DHCHAI.BT.SystemMap",
			MethodName:"Update",
			aInputStr:InputStr
		},false);
		if (parseInt(flg)> 0) {
			obj.RecRowID = "";
			obj.gridSystemMap.reload();		//刷新当前页
			$HUI.dialog('#winEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		}else if(parseInt(flg) == '-2'){
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
					ClassName:"DHCHAI.BT.SystemMap",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);
				
				if (flg == '0') {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridSystemMap.reload() ;//刷新当前页
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
			$('#txtSysCode').val(rd["Code"]).validatebox("validate");
			$('#txtSysDesc').val(rd["Desc"]);
			$('#txtHISCode').val(rd["HISCode"]);
			$('#cboType').combobox('setValue',rd["SysID"]);
			$('#cboType').combobox('setText',rd["SysDesc"]);
			$('#cboHosp').combobox('setValue',rd["HospID"]);
			$('#cboHosp').combobox('setText',rd["HospDesc"]);
			$('#chkActive').checkbox('setValue',(rd["IsActive"]=='1' ? true : false));
			
			obj.RecRowID=rd["ID"];
		}else{
			$('#txtSysCode').val('').validatebox("validate");
			$('#txtSysDesc').val('');
			$('#txtHISCode').val('');
			$('#cboType').combobox('setValue','');	
			$('#cboHosp').combobox('setValue','');
			$('#chkActive').checkbox('setValue','');
			
			obj.RecRowID = "";
		}
		$('#winEdit').show();
		$('#winEdit').dialog({
			title: '子系统定义维护编辑',
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:true
		});
		
	}
}
