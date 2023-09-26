//页面Event
function InitQueryWinEvent(obj){	
    
    obj.LoadEvent = function(args){ 
	    //保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#DicEdit').close();
     	});
		
	    //添加
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd = obj.gridDiagPos.getSelected();
			obj.InitDialog(rd);
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});	
	}

	//窗体初始化
	obj.DicEdit = $('#DicEdit').dialog({
		title:'诊断部位维护',
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
		var PosFlag = $('#chkPosFlag').checkbox('getValue')? '1':'0';
		var IsActive = $('#chkIsActive').checkbox('getValue')? '1':'0';
		
		if (!Code) {
			errinfo = errinfo + "诊断代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "诊断部位为空!<br>";
		}
		if ((Code.length!=3)&&(PosFlag==1)) {
			errinfo = errinfo + "诊断代码编码为3位,请按正确编码方式填写!" 
		}
        if (PosFlag!=1) {   //维护诊断亚部位，先判断诊断部位是否存在
		    if (Code.indexOf(".")<1) {
				errinfo = errinfo + "(亚部位)诊断代码编码格式不正确,请按正确编码方式填写!" 
			}else {
				var PosCode = Code.split(".")[0];
				var flg = $m({
					ClassName:"DHCMed.CD.CRDiagnosPos",
					MethodName:"CheckCode",
					aCode:PosCode
				},false);
	
				if ((flg<1)&&(!obj.RecRowID)) {
					errinfo = errinfo + "诊断部位不存在,请先维护诊断部位!" 
				}
			}
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;	
		inputStr = inputStr + CHR_1 + PosFlag;
		inputStr = inputStr + CHR_1 + IsActive;
		inputStr = inputStr + CHR_1 + Resume;
		
		var flg = $m({
			ClassName:"DHCMed.CD.CRDiagnosPos",
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
			$HUI.dialog('#DicEdit').close();
			obj.gridDiagPos.reload() ;//刷新当前页
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 2000});
		}
	}
	//删除 
	obj.btnDelete_click = function(){
		if (obj.RecRowID == ""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMed.CD.CRDiagnosPos",
					MethodName:"DeleteById",
					aID:obj.RecRowID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridDiagPos.reload() ;//刷新当前页
				}
			} 
		});
	}
	
	//单击选中事件
	obj.gridDiagPos_onSelect = function (){
		var rowData = obj.gridDiagPos.getSelected();
	
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			
			obj.gridDiagPos.clearSelections();  //清除选中行
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}	
	
    //双击弹出编辑事件
	obj.gridDiagPos_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	
	//窗口初始化
	obj.InitDialog = function(rd){
		if(rd){
			obj.RecRowID = rd["ID"];
			var Code = rd["CRCode"];
			var Desc = rd["CRDesc"];
			var Resume = rd["Resume"];
			var PosFlag = rd["PosFlag"];
			var IsActive = rd["IsActive"];
		
			$('#txtCode').val(Code).validatebox("validate");
			$('#txtDesc').val(Desc).validatebox("validate");
			$('#txtResume').val(Resume);
			$('#chkPosFlag').checkbox('setValue',(PosFlag==1 ? true:false));
			$('#chkIsActive').checkbox('setValue',(IsActive==1 ? true:false));
	
		}else{
			obj.RecRowID = "";
			$('#txtCode').val('').validatebox("validate");
			$('#txtDesc').val('').validatebox("validate");
			$('#txtResume').val('');
			$('#chkPosFlag').checkbox('setValue','');
			$('#chkIsActive').checkbox('setValue','');
		}
		$HUI.dialog('#DicEdit').open();
	}
}