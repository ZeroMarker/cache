//页面Event
function InitNIBaseWinEvent(obj){
    obj.LoadEvent = function(args){
	    //添加
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
	    //保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
     	//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#winNIBase').close();
     	});
     	//修改
		$('#btnEdit').on('click', function(){
			var rd=obj.gridNurItemBase.getSelected()
			obj.layer(rd);	
		});
     	//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		}); 
    }

    //双击护理事件
	obj.gridNurItemBase_onDbselect = function(rd){
		obj.layer(rd);
	}
    //单击诊疗事件
	obj.gridNurItemBase_onSelect = function (){
		var rowData = obj.gridNurItemBase.getSelected();
		if (rowData["BTID"] == obj.NIBaseID) {
			$("#btnAdd").linkbutton("enable"); 
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.NIBaseID="";
			obj.gridNurItemBase.clearSelections();
		}
		else {
			obj.NIBaseID = rowData["BTID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	//保存诊疗
	obj.btnSave_click = function(){
		var errinfo = "";
		var Desc = $('#Desc').val();
		var NURCode = $('#NURCode').combobox('getValue');
		var IsActive = $("#IsActive").checkbox('getValue')? '1':'0';
		 if (!Desc){
		    var errinfo = errinfo +  "请填写护理描述!<br>";
		}
		var IsCheck = $m({
			ClassName:"DHCMA.CPW.KB.NurItemBase",
			MethodName:"CheckKBDesc",
			aDesc:Desc,
			aID:obj.NIBaseID
		},false);
	  	if(IsCheck>=1) {
	  		errinfo = errinfo + "描述与列表中现有项目重复，请检查修改!<br>";
	  	}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var inputStr = obj.NIBaseID;
		inputStr = inputStr + "^" + Desc;
		inputStr = inputStr + "^" + "";
		inputStr = inputStr + "^" + NURCode;
		inputStr = inputStr + "^" + "";
		inputStr = inputStr + "^" + "";
		inputStr = inputStr + "^" + IsActive;
		inputStr = inputStr + "^" + "";
		inputStr = inputStr + "^" + "";
		inputStr = inputStr + "^" + session['DHCMA.USERID'];
		var TRet=$m({
			ClassName :"DHCMA.CPW.KB.NurItemBase",
			MethodName:"Update",
			aInputStr :inputStr,
			aSeparete:"^"
		},false)
		if (parseInt(TRet)>0) {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			$HUI.dialog('#winNIBase').close()
			obj.gridNurItemBase.reload();
		}else{
			$.messager.alert("错误提示", "更新数据错误!Error=" + TRet, 'info');
		}
	}
	//删除诊疗
	obj.btnDelete_click = function(){
		if (obj.NIBaseID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.CPW.KB.NurItemBase",
					MethodName:"DeleteById",
					aId:obj.NIBaseID
				},false);
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');					
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.NIBaseID = ""
					obj.gridNurItemBase.reload() ;//刷新当前页
				}
			} 
		});
	}
	//配置窗体-初始化
	obj.layer= function(rd){
		if(rd){
			obj.NIBaseID = rd["BTID"];
			var Desc = rd["BTDesc"];
			var IsActive = rd["BTIsActive"];
			IsActive = (IsActive=="是"? true: false)
			var NURCode = rd["BTNURCode"];
			$('#Desc').val(Desc);
			$('#NURCode').combobox('setValue',NURCode);
			$('#IsActive').checkbox('setValue',IsActive);
		}else{
			obj.NIBaseID = "";
			$('#Desc').val('');
			$('#NURCode').combobox('setValue','');
			$('#IsActive').checkbox('setValue',false);
		}
		//var left=$("#btnEdit").offset().left+5;
		//$HUI.dialog('#winNIBase').open().window("move",{left:left});
		$HUI.dialog('#winNIBase').open();
	}

}