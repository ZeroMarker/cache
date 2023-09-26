//页面Event
function InitSymptomWinEvent(obj){	
    
	obj.LoadEvent = function(args){ 
		//查询
		$('#btnQuery').on('click', function(){
			obj.gridMentalLoad();
		});
		//更新
		$('#btnUpdate').on('click', function(){
			obj.btnUpdate_click();
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		
	}
    
	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		$('#txtCode').val('');
		$('#txtDesc').val('');
		$('#cboMsCate').combobox('clear');
		$('#IsActive').checkbox('setValue',false);
		$('#txtResume').val('');
	}
	
	obj.btnUpdate_click = function() {
		var errinfo = "";
		var Code 	  = $('#txtCode').val();
		var Desc 	  = $('#txtDesc').val();
		var cboMsCate = $('#cboMsCate').combobox('getValue');
		var IsActive  = $("#IsActive").checkbox('getValue')? '1':'0';
		var Resume    = $('#txtResume').val();
		
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}
		if (!cboMsCate) {
			errinfo = errinfo + "症状类型为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示",errinfo);
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + cboMsCate;
		inputStr = inputStr + CHR_1 + IsActive ;
		inputStr = inputStr + CHR_1 + Resume;
		var flg = $m({
			ClassName:"DHCMed.SMD.Symptom",
			MethodName:"Update",
			aInputStr:inputStr, 
			aSeparete:CHR_1
		},false);

		if (parseInt(flg) <= 0) {
			if (parseInt(flg) ==-2)
			{ 
				$.messager.alert("错误提示","代码重复!", 'error');
				return;
			}else{
				$.messager.alert("错误提示","更新数据错误!Error=" + flg, 'error');
				return;
			}
		} else {
			$.messager.popover({msg: '更新成功！',type:'success',timeout: 1000});
			obj.ClearFormItem();
			obj.gridMental.reload() ;//刷新当前页
		}
	}
	
	obj.btnDelete_click = function() {	
		var rowData = obj.gridMental.getSelected();
		var index = obj.gridMental.getRowIndex(rowData);  //获取当前选中行的行号(从0开始)
		if (index=="-1"){$.messager.alert("错误提示","请选择要删除的数据", 'error');}
		if (rowData["RowID"] !=""){
			$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
				if (r) {				
					var flg = $m({
						ClassName:"DHCMed.SMD.Symptom",
						MethodName:"DeleteById",
						aID:rowData["RowID"]
					},false);
					
					if (parseInt(flg) < 0) {
						$.messager.alert("错误提示","删除第" + (index+1) + "行数据错误!Error=" + flg, 'error');
					} else {
						$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
						obj.ClearFormItem();
						obj.gridMental.reload() ;//刷新当前页
					}
				} 
			});
		} else {
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
		}
	}
	obj.gridMental_onSelect = function() {
		var rowData = obj.gridMental.getSelected();
		
		if (rowData["RowID"] == obj.RecRowID) {
			obj.ClearFormItem();
			obj.gridMental.clearSelections();  //清除选中行
		} else {
			obj.RecRowID = rowData["RowID"];
			$('#txtCode').val(rowData["Code"]);
			$('#txtDesc').val(rowData["Desc"]);
			$('#cboMsCate').combobox('setValue',rowData["CateID"]);
			$('#cboMsCate').combobox('setText',rowData["CateDesc"]);
			$('#IsActive').checkbox('setValue',(rowData["IsActive"]=="是" ? true: false));
			$('#txtResume').val(rowData["Resume"]);
		}
	}		
	obj.gridMentalLoad = function(){	
		obj.gridMental.load({
		     ClassName:"DHCMed.SMD.Symptom",
			QueryName:"QryMentalSym",
			aCode: $('#txtCode').val(),
			aDesc:$('#txtDesc').val(), 
			aCateID: $('#cboMsCate').combobox('getValue')
	    });
    }
	
}