//页面Event
function InitProEditWinEvent(obj){	
	
	//按钮初始化
	$('#winProEdit').dialog({
		title: '系统参数配置',
		iconCls:'icon-w-paper',
		closed: true,
		modal: true,
		isTopZindex:false,//true,
		buttons:[{
			text:'保存',
			handler:function(){
				obj.btnSave_click();
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#winProEdit').close();
			}
		}]
	});
	
	obj.LoadEvent = function(args){
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
		$('#btnEdit').on('click', function(){
			var rd=obj.gridConfig.getSelected()
			obj.layer(rd);
		});
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
     }
    //双击编辑事件
	obj.gridConfig_onDbselect = function(rd){
		obj.layer(rd);
	}
	//选择
	obj.gridConfig_onSelect = function (){
		var rowData = obj.gridConfig.getSelected();
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID="";
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridConfig.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	//保存
	obj.btnSave_click = function(){

		var errinfo = "";
		var ConfCode = $('#txtConfCode').val();
		var ConfDesc = $('#txtConfDesc').val();
		var Confvalue = $('#txtConfvalue').val();
		var ConfIsActive = $("#ConfIsActive").checkbox('getValue');
		var ConfComments = $('#txtComments').val();
		ConfIsActive = (ConfIsActive==true? 1 : 0);
		if (!ConfCode) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!ConfDesc) {
			errinfo = errinfo + "描述为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + '^' + ConfCode;
		inputStr = inputStr + '^' + ConfDesc;
		inputStr = inputStr + '^' + Confvalue;
		inputStr = inputStr + '^' + $("#cboSSHosp").combobox('getValue');
		inputStr = inputStr + '^' + $('#cboProduct').combobox('getValue');
		inputStr = inputStr + '^' + ConfIsActive;
		inputStr = inputStr + '^' + session['DHCMA.USERID'];
		inputStr = inputStr + '^' + ConfComments;
		var flg = $m({
			ClassName:"DHCMA.Util.BT.Config",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:'^'
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
			} else if(parseInt(flg) == -1){
				$.messager.alert("错误提示", "代码错误!" , 'info');
			} else if(parseInt(flg) == -2){
				$.messager.alert("错误提示", "数据重复!" , 'info');
			}else{
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#winProEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID = flg;
			obj.gridConfig.reload() ;//刷新当前页
		}
	}
	//删除
	obj.btnDelete_click = function(){
		if (obj.RecRowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.Util.BT.Config",
					MethodName:"DeleteById",
					aId:obj.RecRowID
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
					obj.RecRowID = "";
					obj.gridConfig.reload() ;//刷新当前页
				}
			} 
		});
	}
    //配置窗体-初始化
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID=rd["ID"];
			var ConfCode = rd["Code"];
			var ConfDesc = rd["Desc"];
			var Confvalue = rd["value"];
			var ConfIsActive = rd["IsActive"];
			var ProductID = rd["ProID"];
			var ConfComments = rd["Comments"];
			
			$('#txtConfCode').val(ConfCode);
			$('#txtConfDesc').val(ConfDesc);
			$('#txtConfvalue').val(Confvalue);
			$('#cboProduct').combobox('setValue',ProductID);
			$('#ConfIsActive').checkbox('setValue',(ConfIsActive=='是' ? true : false));
			$('#txtComments').val(ConfComments);
		}else{
			obj.RecRowID = "";
			$('#txtConfCode').val('');
			$('#txtConfDesc').val('');
			$('#txtConfvalue').val('');
			$('#txtComments').val('');
			$('#cboProduct').combobox('setValue','');
			
			var cbolist = $('#cboProduct').combobox("getData");
			for (var itemIndex in cbolist) {
				var item = cbolist[itemIndex];
				if (item.ProCode == ProductCode) {
					$('#cboProduct').combobox("select", item.ProID);
				}
			}
			$('#ConfIsActive').checkbox('setValue',false);
		}
		$HUI.dialog('#winProEdit').open();
	}
}
