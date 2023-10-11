//页面Event
function InitProEditWinEvent(obj){	
	
	//按钮初始化
	$('#winProEdit').dialog({
		title: '产品线定义',
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
			var rd=obj.gridProduct.getSelected()
			obj.layer(rd);
		});
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
     }
    //双击编辑事件
	obj.gridProduct_onDbselect = function(rd){
		obj.layer(rd);
	}
	//选择
	obj.gridProduct_onSelect = function (){
		var rowData = obj.gridProduct.getSelected();
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID="";
		if (rowData["ProID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridProduct.clearSelections();
		} else {
			obj.RecRowID = rowData["ProID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	//保存产品定义
	obj.btnSave_click = function(){
		var errinfo = "";
		var Code = $('#txtProCode').val();
		var Desc = $('#txtProDesc').val();
		var Version = $('#txtVersion').val();
		var IconCls = $('#txtIconCls').val();
		var IndNo = $('#txtIndNo').val();
		var IsActive = $("#chkIsActive").checkbox('getValue');
		IsActive = (IsActive==true ? 1 : 0);
		var Resume = $('#txtResume').val();
		
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + Version;
		inputStr = inputStr + CHR_1 + IconCls;
		inputStr = inputStr + CHR_1 + IndNo;
		inputStr = inputStr + CHR_1 + IsActive;
		inputStr = inputStr + CHR_1 + Resume;
		var flg = $m({
			ClassName:"DHCMA.Util.BT.Product",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:CHR_1
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
			} else if(parseInt(flg) == -2){
				$.messager.alert("错误提示", "数据重复!" , 'info');
			}else{
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#winProEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID = flg;
			obj.gridProduct.reload() ;//刷新当前页
		}
	}
	//删除产品定义
	obj.btnDelete_click = function(){
		if (obj.RecRowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.Util.BT.Product",
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
					obj.gridProduct.reload() ;//刷新当前页
				}
			} 
		});
	}
    //配置窗体-初始化
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID=rd["ProID"];
			var ProCode = rd["ProCode"];
			var ProDesc = rd["ProDesc"];
			var Version = rd["ProVersion"];
			var IconCls = rd["ProIconCls"];
			var IndNo = rd["ProIndNo"];
			var IsActive = rd["IsActive"];
			var Resume = rd["ProResume"];
			
			$('#txtProCode').val(ProCode);
			$('#txtProDesc').val(ProDesc);
			$('#txtVersion').val(Version);
			$('#txtIconCls').val(IconCls);
			$('#txtIndNo').val(IndNo);
			$('#chkIsActive').checkbox('setValue',(IsActive=='1' ? true : false));
			$('#txtResume').val(Resume);
		}else{
			obj.RecRowID = "";
			$('#txtProCode').val('');
			$('#txtProDesc').val('');
			$('#txtVersion').val('');
			$('#txtIconCls').val('');
			$('#txtIndNo').val('');
			$('#chkIsActive').checkbox('setValue',false);
			$('#txtResume').val('');
		}
		$HUI.dialog('#winProEdit').open();
	}
}
