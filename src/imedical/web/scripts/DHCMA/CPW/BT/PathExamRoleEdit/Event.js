//页面Event
function InitExamRoleEvent(obj){
	//弹窗初始化
	$('#winPathExamRole').dialog({
		title: '发布审核角色维护',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
	});
	
	/*
	// 检查删除按钮是否允许删除，若否则隐藏该按钮
	if(!chkDelBtnIsAble("DHCMA.CPW.BT.PathExamRole")){
		$("#btnDelete").hide();	
	}else{
		$("#btnDelete").show();	
	}*/
	
    obj.LoadEvent = function(args){ 
     	//保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#winPathExamRole').close();
     	});
		//添加
     	$('#btnAdd').on('click', function(){
			obj.layer();
     	});
		//编辑
		$('#btnEdit').on('click', function(){
	     	var rd=obj.gridPathExamRole.getSelected();
			obj.layer(rd);		
     	});
		//删除
		$('#btnDelete').on('click', function(){
	     	obj.btnDelete_click();
     	});
     	
     }

	//选择审核角色
	obj.gridPathExamRole_onSelect = function (){
		var rowData = obj.gridPathExamRole.getSelected();
		if (rowData["OID"] == obj.RecRowID) {
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.RecRowID="";
			obj.gridPathExamRole.clearSelections();  //清除选中行
		} else {
			obj.RecRowID = rowData["OID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	} 
	//双击编辑事件 父表
	obj.gridPathExamRole_onDbselect = function(rd){
		obj.layer(rd);
	}
	
	//保存
	obj.btnSave_click = function(){
		var errinfo = "";
		var Code = $('#txtCode').val();
		var Desc = $('#txtDesc').val();
		var RoleType = $('#cboRoleType').combobox('getValue');
		var RoleValue = $('#cboRoleValue').combobox('getValue');
		var Priority = $('#txtPriority').val();
		var HospID = $("#cboSSHosp").combobox('getValue');
		if (HospID=="") HospID=session['DHCMA.HOSPID'];	
		
		var IsActive = $("#chkIsActive").checkbox('getValue')? '1':'0';
		
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}
		if (!RoleType) {
			errinfo = errinfo + "角色类型为空!<br>";
		}
		if (!RoleValue) {
			errinfo = errinfo + "角色对象为空!<br>";
		}
		if (!Priority) {
			errinfo = errinfo + "优先级为空!<br>";
		}
		
		var IsCheck = $m({
			ClassName:"DHCMA.CPW.BT.PathExamRole",
			MethodName:"CheckPTCode",
			aCode:Code,
			aID:obj.RecRowID
		},false);
	  	if(IsCheck>=1) {
	  		errinfo = errinfo + "代码与列表中现有项目重复，请检查修改!<br>";
	  	}
	  	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + RoleValue;
		inputStr = inputStr + CHR_1 + RoleType;
		inputStr = inputStr + CHR_1 + IsActive;
		inputStr = inputStr + CHR_1 + Priority;
		inputStr = inputStr + CHR_1 + HospID;
		
		var flg = $m({
			ClassName:"DHCMA.CPW.BT.PathExamRole",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:CHR_1,
			aHospID: $("#cboSSHosp").combobox('getValue')
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#winPathExamRole').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.gridPathExamRole.reload() ;//刷新当前页
			obj.RecRowID = "";
		}
	}
	//删除
	obj.btnDelete_click = function(){
		var rowID = obj.gridPathExamRole.getSelected()["xID"];
		debugger
		if (rowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.CPW.BT.PathExamRole",
					MethodName:"DeleteById",
					aId:rowID,
					aHospID: $("#cboSSHosp").combobox('getValue')
				},false);
				if (parseInt(flg) < 0) {
					if (parseInt(flg)==-777) {
						$.messager.alert("错误提示","系统参数配置不允许删除！", 'info');
					} else {
						$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
					}
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridPathExamRole.reload() ;//刷新当前页
				}
			} 
		});
	}
	
	//配置窗体-初始化
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID=rd["xID"];
			var Code = rd["Code"];
			var Desc = rd["Desc"];
			var RoleType = rd["TypeCode"];
			var RoleValue = rd["Value"];
			var Priority = rd["Priority"];
			var IsActive =(rd["IsActive"]=="是"? true: false);

			$('#txtCode').val(Code);
			$('#txtDesc').val(Desc);
			$('#cboRoleType').combobox('select',RoleType);
			$('#cboRoleValue').combobox('select',RoleValue);
			$('#txtPriority').val(Priority);
			$('#chkIsActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID="";
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#txtRoleType').combobox('clear');
			$('#cboRoleValue').combobox('clear');
			$('#txtPriority').val('');
			$('#chkIsActive').checkbox('setValue',false);
		}
		$HUI.dialog('#winPathExamRole').open();
	}
}