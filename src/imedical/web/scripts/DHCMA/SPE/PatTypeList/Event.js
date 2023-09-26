//页面Event
function InitPatTypeListWinEvent(obj){	
    
     obj.LoadEvent = function(args){ 
     	
     	$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
     	$('#btnDelete').on('click', function(){
	     	obj.btnDelete_click();
     	});
     	$('#btnSaveSub').on('click', function(){
	     	obj.btnSaveSub_click();
     	});
     	$('#btnDeleteSub').on('click', function(){
	     	obj.btnDeleteSub_click();
     	});
     	obj.PatTypeSubLoad();
    
     }
     
     //清空
	obj.ClearFormItem1 = function() {
		$('#PTCode').val('');
		$('#PTDesc').val('');
		$('#PTIsActive').checkbox('setValue',false);
		$('#PTResume').val('');
		
	}
	obj.ClearFormItem2 = function() {
		$('#PTSCode').val('');
		$('#PTSDesc').val('');
		$('#PTSIcon').val('');
		$('#PTSResume').val('');	
		$('#PTSAutoMark').checkbox('setValue',false);
	    $('#PTSAutoCheck').checkbox('setValue',false);
	    $('#PTSAutoClose').checkbox('setValue',false);
	    $('#PTSIsActive').checkbox('setValue',false);		
	}
	
	//保存分类
	obj.btnSave_click = function(){
		
		var errinfo = "";
		var Code = $('#PTCode').val();
		var Desc = $('#PTDesc').val();
		var IsActive = $("#PTIsActive").checkbox('getValue')? '1':'0';
		var Resume = $('#PTResume').val();
	
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}
		
		var IsCheck = $m({
			ClassName:"DHCMed.SPE.PatType",
			MethodName:"CheckPTCode",
			aCode:Code,
			aID:obj.RecRowID1
		},false);
	
	  	if(IsCheck==1) {
	  		errinfo = errinfo + "代码与列表中现有项目重复，请检查修改!<br>";
	  	}
	  	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var inputStr = obj.RecRowID1;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + IsActive;
		inputStr = inputStr + CHR_1 + Resume;
	
		var flg = $m({
			ClassName:"DHCMed.SPE.PatType",
			MethodName:"Update",
			InStr:inputStr,
			separete:CHR_1
		},false);
		
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == -100) {
				$.messager.alert("错误提示", "数据重复!Error=" + flg, 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
			return;
		}else {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.ClearFormItem1();
			obj.RecRowID1="";
			obj.gridPatType.reload() ;//刷新当前页
		}

	}
	
	//删除分类 
	obj.btnDelete_click = function(){
		if (obj.RecRowID1!=""){
			$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
				if (r) {				
					var flg = $m({
						ClassName:"DHCMed.SPE.PatType",
						MethodName:"DeleteById",
						Id:obj.RecRowID1
					},false);
					
					if (parseInt(flg) < 0) {
						$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
					} else {
						obj.RecRowID1="";
						$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
						obj.ClearFormItem2();
						obj.gridPatTypeSub.reload() ;//刷新当前页
						obj.ClearFormItem1();
						obj.gridPatType.reload() ;//刷新当前页
					}
				} 
			});
		} else {
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
		}
	}
	
	//保存子类
	obj.btnSaveSub_click =  function(){
		
		var errinfo = "";
		var Code =  $('#PTSCode').val();
		var Desc = $('#PTSDesc').val();
		var Icon = $('#PTSIcon').val();
		var AutoMark =  $("#PTSAutoMark").checkbox('getValue')? '1':'0';
		var AutoCheck =  $("#PTSAutoCheck").checkbox('getValue')? '1':'0';
		//var AutoClose =  $("#PTSAutoClose").checkbox('getValue')? '1':'0';	// 此处暂时不考虑自动关闭的情况，全部默认都关闭 自动关闭 功能
		var AutoClose = 0;
		var IsActive =  $("#PTSIsActive").checkbox('getValue')? '1':'0';
		var Resume =$('#PTSResume').val();
		
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}
		if (!Icon) {
			errinfo = errinfo + "图标定义为空!<br>";
		}
		//检查代码是否重复
		var SubID = obj.RecRowID1 + "||" + obj.RecRowID2;
		var IsCheck=$m({
			ClassName:"DHCMed.SPE.PatTypeSub",
			MethodName:"CheckPTSCode",
			aCode:Code,
			aSubID:SubID
		},false);
		
	  	if(IsCheck==1)
	  	{
	  		errinfo = errinfo + "代码与列表中现有项目重复，请检查修改!<br>";
	  	}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var inputStr = obj.RecRowID1;
		inputStr = inputStr + CHR_1 + obj.RecRowID2;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + Icon;
		inputStr = inputStr + CHR_1 + AutoMark;
		inputStr = inputStr + CHR_1 + AutoCheck;
		inputStr = inputStr + CHR_1 + AutoClose;
		inputStr = inputStr + CHR_1 + IsActive;
		inputStr = inputStr + CHR_1 + Resume;
	   
		var flg = $m({
			ClassName:"DHCMed.SPEService.PatTypeSub",
			MethodName:"SaveRec",
			aInput:inputStr,
			aSeparate:CHR_1
		},false);
	
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == -100) {
				$.messager.alert("错误提示", "数据重复!Error=" + flg, 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
			return;
		}else {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.ClearFormItem2();
			obj.RecRowID2="";
			obj.gridPatTypeSub.reload() ;//刷新当前页
		}
		
	}
	//删除子分类
	obj.btnDeleteSub_click = function(){
		
		if ((obj.RecRowID1!="")&&(obj.RecRowID2!="")){
			$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
				if (r) {
					var flg = $m({
						ClassName:"DHCMed.SPE.PatTypeSub",
						MethodName:"DeleteById",
						Id:obj.RecRowID1+"||"+obj.RecRowID2
					},false);
					if (parseInt(flg) < 0) {
						$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
					} else {
						obj.RecRowID2="";
						$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
						obj.ClearFormItem2();
						obj.gridPatTypeSub.reload() ;//刷新当前页
					}
				}
			});
		} else {
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
		}
	}
	
	
	obj.gridPatType_onSelect = function (){
		var rowData = obj.gridPatType.getSelected();
		
		if (rowData["PTID"] == obj.RecRowID1) {
			obj.ClearFormItem1();
			obj.RecRowID1="";
			obj.gridPatType.clearSelections();  //清除选中行
		} else {
			obj.RecRowID1 = rowData["PTID"];
			
			var PTCode = rowData["PTCode"];
			var PTDesc = rowData["PTDesc"] ;
			var IsActive = rowData["PTIsActiveDesc"];
			IsActive = (IsActive=="是"? true: false)
			var PTResume = rowData["PTResume"];
		
			$('#PTCode').val(PTCode);
			$('#PTDesc').val(PTDesc);
			$('#PTIsActive').checkbox('setValue',IsActive);
			$('#PTResume').val(PTResume);
				
			obj.PatTypeSubLoad();  //加载特殊患者子分类
			obj.ClearFormItem2();  //清空特殊患者子分类
		}
	}
	
    obj.gridPatTypeSub_onSelect = function (){
	    var rowData = obj.gridPatTypeSub.getSelected();
	    if (rowData["PTSID"] == obj.RecRowID2) {
			obj.ClearFormItem2();
			obj.RecRowID2="";
			obj.gridPatTypeSub.clearSelections();  //清除选中行
		} else {
			obj.RecRowID2 = rowData["PTSID"];
		
		    var PTSCode =  rowData["PTSCode"];
		    var PTSDesc =  rowData["PTSDesc"];
		    var PTSIcon =  rowData["PTSIcon"];
		    var PTSAutoMark =  rowData["PTSAutoMarkDesc"];
		    var PTSAutoCheck =  rowData["PTSAutoCheckDesc"];
		    var PTSAutoClose =  rowData["PTSAutoCloseDesc"];
		    var PTSIsActive =  rowData["PTSIsActiveDesc"] ;
		    var PTSResume =  rowData["PTSResume"];
		  
		    PTSAutoMark = (PTSAutoMark=="是"? true: false)
		    PTSAutoCheck = (PTSAutoCheck=="是"? true: false)
		    PTSAutoClose = (PTSAutoClose=="是"? true: false)
		    PTSIsActive = (PTSIsActive=="是"? true: false)
		    
		    $('#PTSCode').val(PTSCode);
			$('#PTSDesc').val(PTSDesc);
			$('#PTSIcon').val(PTSIcon);
			$('#PTSResume').val(PTSResume);	
			$('#PTSAutoMark').checkbox('setValue',PTSAutoMark);
		    $('#PTSAutoCheck').checkbox('setValue',PTSAutoCheck);
		    $('#PTSAutoClose').checkbox('setValue',PTSAutoClose);
		    $('#PTSIsActive').checkbox('setValue',PTSIsActive);
		}
    }
	
	obj.PatTypeSubLoad = function () {
		var ParRef = '';
		var rowData = obj.gridPatType.getSelected();
	
		if ((rowData) && (rowData.PTID)) {
			ParRef = rowData.PTID;
		}
		
		obj.gridPatTypeSub.load({
			ClassName:"DHCMed.SPEService.PatTypeSub",
			QueryName:"QryPatTypeSub",
			ParRef:ParRef
		});
	}
	
}