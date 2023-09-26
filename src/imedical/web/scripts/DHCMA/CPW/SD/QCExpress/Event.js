//页面Event
function InitWinEvent(obj){
	obj.RecRowID=""
    obj.LoadEvent = function(args){ 
    
		//添加
     	$('#btnAdd').on('click', function(){
			obj.btnSave_click()
     	});
		//编辑
		$('#btnEdit').on('click', function(){
			obj.btnSave_click()			
     	});
		//删除
		$('#btnDelete').on('click', function(){
	     	obj.btnDelete_click();
     	});
     	
			$('#ExpType').keywords('select','GetValue');
     }
	obj.gridQCExpress_onSelect = function (rd){
		if (rd["BTID"] == obj.RecRowID) {
			obj.clearForm();
		} else {	
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
			obj.initFormByRec(rd);
		}
	}
	//保存分类
	obj.btnSave_click = function(flg){
		var errinfo = "";
		var Code = $('#BTCode').val();
		var Desc = $('#BTDesc').val();
		var Type = $('#BTType').combobox('getValue');
		var IsActive = $('#BTIsActive').checkbox('getValue');
		IsActive = (IsActive==true? 1: 0);
		var Express = $('#BTExpress').val();
		var ExpressParam = $('#BTExpressParam').val();
		var ExpressTxt = $('#BTExpressTxt').val();
		var Level = $('#BTLevel').combobox('getValue');
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
		inputStr = inputStr + String.fromCharCode(1) + Code;
		inputStr = inputStr + String.fromCharCode(1) + Desc;
		inputStr = inputStr + String.fromCharCode(1) + Type;
		inputStr = inputStr + String.fromCharCode(1) + IsActive;
		inputStr = inputStr + String.fromCharCode(1) + Express;
		inputStr = inputStr + String.fromCharCode(1) + ExpressParam;
		inputStr = inputStr + String.fromCharCode(1) + ExpressTxt;
		inputStr = inputStr + String.fromCharCode(1) + Level;
		var flg = $m({
			ClassName:"DHCMA.CPW.SD.QCExpress",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:String.fromCharCode(1)
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.clearForm();
			obj.gridQCExpress.reload() ;//刷新当前页
		}
	}
	//删除分类 
	obj.btnDelete_click = function(){
		var rowData = obj.gridQCExpress.getSelected();
		var rowID=rowData["BTID"]
		if (rowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.CPW.SD.QCExpress",
					MethodName:"DeleteById",
					aId:rowID
				},false);
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');	
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.clearForm();
					obj.gridQCExpress.reload() ;//刷新当前页	
				}
			} 
		});
	}
	
obj.clearForm=function() {
		obj.RecRowID="";
		$("#btnAdd").linkbutton("enable");
		$("#btnEdit").linkbutton("disable");
		$("#btnDelete").linkbutton("disable");
		obj.gridQCExpress.clearSelections();
		$("#BTCode").val('');
		$("#BTDesc").val('');
		$("#BTType").combobox('setValue','');
		$("#BTIsActive").checkbox('setValue',false);
		$("#BTExpress").val('');
		$("#BTExpressParam").val('');
		$("#BTExpressTxt").val('');
		$("#BTLevel").combobox('setValue','');
	}
obj.initFormByRec=function(rd) {
		obj.RecRowID = rd["BTID"];
		$("#BTCode").val(rd["BTCode"])
		$("#BTDesc").val(rd["BTDesc"])
		$('#BTType').combobox('setValue', rd["BTTypeID"]);
		$("#BTIsActive").checkbox('setValue',rd["BTIsActive"]=="是"?true:false);
		$("#BTExpress").val(rd["BTExpress"])
		$("#BTExpressTxt").val(rd["BTExpressTxt"])
		$("#BTExpressParam").val(rd["BTExpressParam"])
		$('#BTLevel').combobox('setValue', rd["BTLevel"]);
	}
}