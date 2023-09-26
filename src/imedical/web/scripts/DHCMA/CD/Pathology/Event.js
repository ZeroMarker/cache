//页面Event
function InitQueryWinEvent(obj){	
    
	obj.LoadEvent = function(args){ 
	    //保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#PathologyEdit').close();
     	});
		
	    //添加
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd = obj.gridPathology.getSelected();
			obj.InitDialog(rd);
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});	
	}
	
	//窗体初始化
	obj.PathologyEdit = $('#PathologyEdit').dialog({
		title:'病理类型维护',
		iconCls:'icon-w-edit',
		closed: true,
		modal: true,
		isTopZindex:true
	});
	
	//保存
	obj.btnSave_click = function(){
		var errinfo = "";
		var Code = $.trim($('#txtCode').val());
		var Desc = $.trim($('#txtDesc').val());
		var Resume = $.trim($('#txtResume').val());
		var IsActive = $('#chkIsActive').checkbox('getValue')? '1':'0';
		
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "描述为空!<br>";
		}	
	 
		var flgCode = $m({
			ClassName:"DHCMed.CD.CRPathology",
			MethodName:"CheckCode",
			aCode:Code
		},false);
		
		if (flgCode>0 && obj.RecRowID=="") {
			errinfo = errinfo + "代码重复!"; 
		}
		
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;	
		inputStr = inputStr + CHR_1 + IsActive;
		inputStr = inputStr + CHR_1 + Resume;
		
		var flg = $m({
			ClassName:"DHCMed.CD.CRPathology",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:CHR_1
		},false);
	
		if (parseInt(flg) <= 0) {
			if(parseInt(flg) == -2){
				$.messager.alert("错误提示", "代码重复!" , 'info');
				return;
			}else{
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
				return;
			}
		}else {
			$HUI.dialog('#PathologyEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.gridPathology.reload() ;//刷新当前页
		}
	}
	//删除 
	obj.btnDelete_click = function(){
		if (!obj.RecRowID ){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMed.CD.CRPathology",
					MethodName:"DeleteById",
					aID:obj.RecRowID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridPathology.reload() ;//刷新当前页
				}
			} 
		});
	}
	
	//单击选中事件
	obj.gridPathology_onSelect = function (){
		var rowData = obj.gridPathology.getSelected();
	
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			
			obj.gridPathology.clearSelections();  //清除选中行
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}	
	
    //双击弹出编辑事件
	obj.gridPathology_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	
	//窗口初始化
	obj.InitDialog = function(rd){
		if(rd){
			obj.RecRowID = rd["ID"];
			var Code = rd["CRCode"];
			var Desc = rd["CRDesc"];
			var Resume = rd["Resume"];
			var IsActive = rd["IsActive"];
			$('#txtCode').val(Code).validatebox("validate");
			$('#txtDesc').val(Desc).validatebox("validate");
			$('#txtResume').val(Resume);
			$('#chkIsActive').checkbox('setValue',(IsActive==1 ? true:false));
	
		}else{
			obj.RecRowID = "";
			$('#txtCode').val('').validatebox("validate");
			$('#txtDesc').val('').validatebox("validate");
			$('#txtResume').val('');
			$('#chkIsActive').checkbox('setValue','');
		}
		$HUI.dialog('#PathologyEdit').open();
	}
}