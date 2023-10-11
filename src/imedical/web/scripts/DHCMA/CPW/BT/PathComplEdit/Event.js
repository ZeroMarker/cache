//页面Event
function InitPathComplListWinEvent(obj){
	//弹窗初始化
	$('#winPathComplEdit').dialog({
		title: '合并症病种维护',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
	});
	
	// 检查删除按钮是否允许删除，若否则隐藏该按钮
	if(!chkDelBtnIsAble("DHCMA.CPW.BT.PathCompl")){
		$("#btnDelete").hide();	
	}else{
		$("#btnDelete").show();	
	}
	
    obj.LoadEvent = function(args){ 
     	//保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#winPathComplEdit').close();
     	});
		//添加
     	$('#btnAdd').on('click', function(){
			obj.layer();
     	});
		//编辑
		$('#btnEdit').on('click', function(){
	     	var rd=obj.gridPathCompl.getSelected();
			obj.layer(rd);		
     	});
		//删除
		$('#btnDelete').on('click', function(){
	     	obj.btnDelete_click();
     	});
     	
     }

	//选择合并症
	obj.gridPathCompl_onSelect = function (){
		var rowData = obj.gridPathCompl.getSelected();
		if (rowData["BTID"] == obj.RecRowID) {
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.RecRowID="";
			obj.gridPathCompl.clearSelections();  //清除选中行
		} else {
			obj.RecRowID = rowData["BTID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	} 
	//双击编辑事件 父表
	obj.gridPathCompl_onDbselect = function(rd){
		obj.layer(rd);
	}
	
	//保存
	obj.btnSave_click = function(){
		var errinfo = "";
		var myDate = new Date();
		var Code = $('#txtCode').val();
		var Desc = $('#txtDesc').val();
		var IsActive = $("#chkIsActive").checkbox('getValue')? '1':'0';
		var BTActDate ='';
		var BTActTime='';
		var BTActUserID="";
		if(session['DHCMA.USERID']) BTActUserID=session['DHCMA.USERID'];
		
		if (!Code) {
			errinfo = errinfo + $g("代码为空!<br>");
		}
		if (!Desc) {
			errinfo = errinfo + $g("名称为空!<br>");
		}	
		var IsCheck = $m({
			ClassName:"DHCMA.CPW.BT.PathCompl",
			MethodName:"CheckPTCode",
			aCode:Code,
			aID:obj.RecRowID
		},false);
	  	if(IsCheck>=1) {
	  		errinfo = errinfo + $g("代码与列表中现有项目重复，请检查修改!<br>");
	  	}
	  	
		if (errinfo) {
			$.messager.alert($g("错误提示"), errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + IsActive;
		inputStr = inputStr + CHR_1 + BTActDate;
		inputStr = inputStr + CHR_1 + BTActTime;
		inputStr = inputStr + CHR_1 + BTActUserID;
		
		var flg = $m({
			ClassName:"DHCMA.CPW.BT.PathCompl",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:CHR_1,
			aHospID: $("#cboSSHosp").combobox('getValue')
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert($g("错误提示"), $g("参数错误!") , 'info');
			} else {
				$.messager.alert($g("错误提示"), $g("更新数据错误!Error=") + flg, 'info');
			}
		}else {
			$HUI.dialog('#winPathComplEdit').close();
			$.messager.popover({msg: $g('保存成功！'),type:'success',timeout: 1000});
			obj.gridPathCompl.reload() ;//刷新当前页
			obj.RecRowID = "";
		}
	}
	//删除
	obj.btnDelete_click = function(){
		var rowID = obj.gridPathCompl.getSelected()["BTID"];
		if (rowID==""){
			$.messager.alert($g("提示"), $g("选中数据记录,再点击删除!"), 'info');
			return;
		}
		$.messager.confirm($g("删除"), $g("是否删除选中数据记录?"), function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.CPW.BT.PathCompl",
					MethodName:"DeleteById",
					aId:rowID,
					aHospID: $("#cboSSHosp").combobox('getValue')
				},false);
				if (parseInt(flg) < 0) {
					if (parseInt(flg)==-777) {
						$.messager.alert($g("错误提示"),$g("系统参数配置不允许删除！"), 'info');
					} else {
						$.messager.alert($g("错误提示"),$g("删除数据错误!Error=") + flg, 'info');
					}
				} else {
					$.messager.popover({msg: $g('删除成功！'),type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridPathCompl.reload() ;//刷新当前页
				}
			} 
		});
	}
	
	//配置窗体-初始化
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID=rd["BTID"];
			var Code = rd["BTCode"];
			var Desc = rd["BTDesc"];
			var BTIsActiveDesc = rd["BTIsActiveDesc"];
			BTIsActiveDesc = (BTIsActiveDesc==$g("是")? true: false)
			$('#txtCode').val(Code);
			$('#txtDesc').val(Desc);
			$('#chkIsActive').checkbox('setValue',BTIsActiveDesc);
		}else{
			obj.RecRowID="";
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#chkIsActive').checkbox('setValue',false);
		}
		$HUI.dialog('#winPathComplEdit').open();
	}
}