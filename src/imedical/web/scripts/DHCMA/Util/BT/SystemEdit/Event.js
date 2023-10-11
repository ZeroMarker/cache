//页面Event
function InitSystemListWinEvent(obj){
    //初始化加载
	$('#winSystemEdit').dialog({
		title: 'HIS应用系统定义',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true
	});	
    obj.LoadEvent = function(args){ 
		//保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#winSystemEdit').close();
     	});
		//添加
     	$('#btnAdd').on('click', function(){
			obj.layer();
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd=obj.gridSystem.getSelected();
			obj.layer(rd);	
     	});
		//删除
     	$('#btnDelete').on('click', function(){
	     	obj.btnDelete_click();
		});
     }
	 
///鼠标点击事件
	//选择路径类型字典
	obj.gridSystem_onSelect = function (){
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID="";
		var rowData = obj.gridSystem.getSelected();
		
		if (rowData["SYSID"] == obj.RecRowID) {
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.RecRowID="";
			obj.gridSystem.clearSelections();  //清除选中行
		} else {
			obj.RecRowID=rowData["SYSID"]
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}	
	//双击编辑事件
	obj.gridSystem_onDbselect = function(rd){
		obj.layer(rd);
	}
///数据操作事件：保存、删除
	//保存分类
	obj.btnSave_click = function(){
		var errinfo = "";
		var Code = $('#txtCode').val();
		var Desc = $('#txtDesc').val();
		var ExCode = $('#txtExCode').val();
		var Note = $('#txtNote').val();
		
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}	
		var IsCheck = $m({
			ClassName:"DHCMA.Util.BTS.SYSTEMSrv",
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
		inputStr = inputStr + CHR_1 + ExCode;
		inputStr = inputStr + CHR_1 + Note;
		
		var flg = $m({
			ClassName:"DHCMA.Util.BT.SYSTEM",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:CHR_1
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
			}else if (parseInt(flg) == -2) {
				$.messager.alert("错误提示", "数据重复!" , 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#winSystemEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID = flg
			obj.gridSystem.reload() ;//刷新当前页
		}

	}
	//删除分类 
	obj.btnDelete_click = function(){
		var RowID=obj.gridSystem.getSelected()["SYSID"]
		if (RowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.Util.BT.SYSTEM",
					MethodName:"DeleteById",
					aId:RowID
				},false);
				if (parseInt(flg) < 0) {
					if (parseInt(flg)=='-777') {
						$.messager.alert("错误提示","-777：当前无删除权限，请启用删除权限后再删除记录!",'info');
					}else {
						$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
					}
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = ""
					obj.gridSystem.reload() ;//刷新当前页
				}
			} 
		});
	}
	
    //配置窗体-初始化
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID = rd["SYSID"];
			var Code = rd["SYSCode"];
			var Desc = rd["SYSDesc"];
			var ExCode = rd["SYSExCode"];
			var Note = rd["SYSNote"];
			$('#txtCode').val(Code);
			$('#txtDesc').val(Desc);	
			$('#txtExCode').val(ExCode);
			$('#txtNote').val(Note);			
		}else{
			obj.RecRowID = "";
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#txtExCode').val('');
			$('#txtNote').val('');			
		}
		$HUI.dialog('#winSystemEdit').open();
	}	
}