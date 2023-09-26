//页面Event
function InitViewportEvent(obj){	
    
	obj.LoadEvent = function(args){ 
	
		//保存
		$('#btnSave').on('click', function(){
			obj.btnSave_click();
		});
	}
    
	obj.clearFormData = function()
	{
		obj.currGridRowId = "";
		$('#txtCode').val('');
		$('#txtDesc').val('');
		$('#txtExtraUnit').val('');
		$('#cboExtraType').combobox('clear');
		$('#chkIsActive').checkbox('setValue',false);
		$('#txtResume').val('');
	}
	
	obj.btnSave_click = function() {
		var inputStr = "", errorStr = "", separete = "^";
		var ID = "", SDCode = "", SDDesc = "", SDExtraType = "", SDExtraUnit = "", SDIsActive = "", SDResume = "";
		if (obj.currGridRowId) { ID = obj.currGridRowId; }
		
		SDCode = $('#txtCode').val();
		SDDesc =  $('#txtDesc').val();
		SDExtraType = $('#cboExtraType').combobox('getValue'); 
		SDExtraUnit = $('#txtExtraUnit').val(); 
		SDIsActive =  $("#chkIsActive").checkbox('getValue')? '1':'0'; 
		SDResume = $('#txtResume').val();
		if (SDCode=="") { errorStr = errorStr + "代码不能为空!" }
		if ((SDCode!="")&&((SDCode.length)%3 !=0)) { errorStr = errorStr + "代码编码不符合规范,请按正确编码方式填写!" }
		if (SDDesc=="") { errorStr = errorStr + "描述不能为空!" }
		if(!$.trim(SDExtraType)){errorStr = errorStr + "请选择值类型!"}
		
		var flgCode = $m({
			ClassName:"DHCMed.FBD.SignDic",
			MethodName:"CheckCode",
			aCode:SDCode
		},false);
		
		if (flgCode>0 && ID=="") {
			errorStr = errorStr + "代码重复!"; 
		}
		if (errorStr!="") { 
			$.messager.alert("提示", errorStr, 'info');
			return; 
		}
		inputStr = ID + separete;
		inputStr = inputStr + SDCode + separete;
		inputStr = inputStr + SDDesc + separete;
		inputStr = inputStr + SDExtraType + separete;
		inputStr = inputStr + SDExtraUnit + separete;
		inputStr = inputStr + SDIsActive + separete;
		inputStr = inputStr + SDResume;
		try {
			var ret = $m({
				ClassName:"DHCMed.FBD.SignDic",
				MethodName:"Update",
				aInputStr:inputStr,
				aSeparete:separete
			},false);
			if (ret<=0) {
				$.messager.alert("提示", "保存失败!", 'info');
				return;
			} else {
				setTimeout($.messager.popover({msg: '保存成功！',type:'success',timeout: 1000}),3000);
				obj.gridSignDic.reload();
				obj.clearFormData();
			}
		} catch(err) {
			$.messager.alert("Error", err.description, 'error');
		}
	}
	
	obj.gridSignDic_onSelect = function() {
		var rowData = obj.gridSignDic.getSelected();
	
		if (obj.currGridRowId &&rowData["ID"] == obj.currGridRowId) {
			obj.clearFormData();
			obj.gridSignDic.clearSelections();  //清除选中行
		} else {
			obj.currGridRowId = rowData["ID"];
			$('#txtCode').val(rowData["Code"]);
			$('#txtDesc').val(rowData["Desc"]);
			$('#txtExtraUnit').val(rowData["ExtraUnit"]);
			$('#cboExtraType').combobox('setValue',rowData["ExtraTypeID"]);
			$('#cboExtraType').combobox('setText',rowData["ExtraTypeDesc"]);
			$('#chkIsActive').checkbox('setValue',(rowData["IsActive"]==1 ? true: false));
			$('#txtResume').val(rowData["Resume"]);
		}
	}		
	obj.gridSignDicLoad = function(){	
		obj.gridSignDic.load({
		    ClassName:"DHCMed.FBDService.SignDicSrv",
			QueryName:"QrySignDic"
	    });
    }
	
}