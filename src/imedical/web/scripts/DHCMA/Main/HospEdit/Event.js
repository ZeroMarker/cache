//页面Event
function InitHISUIWinEvent(obj){
	
		$("#winProEdit").dialog({
			iconCls:'icon-w-paper',
			title:'字典编辑',
			closed: true,
			isTopZindex:false,//true,
			resizable:true,
			modal:true,
			buttons:[{
				text:'保存',
				handler:function(){
					obj.btnSave_click();
					//obj.saveToSrv();
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog('#winProEdit').close();
				}
			}]
		});
	obj.LoadEvents = function(arguments){
		$('#addIcon').on('click', function(){
			//alert("1")
			obj.layer();
		});
		$("#editIcon").on('click',function(){
			var rd = obj.dictList.getSelected();
			obj.layer(rd);
		});	
		$("#delIcon").on('click',function(){
			obj.btnDelete_click();
		});
	};	
	//双击编辑事件
	obj.gridProduct_onDbselect = function(rd){
		obj.layer(rd);
	}
	//选择
	obj.gridProduct_onSelect = function (){
		var rowData = obj.dictList.getSelected();
		if($("#editIcon").hasClass("l-btn-disabled")) obj.RecRowID="";
		if (rowData["SSHospID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#addIcon").linkbutton("enable");
			$("#editIcon").linkbutton("disable");
			$("#delIcon").linkbutton("disable");
			obj.dictList.clearSelections();
		} else {
			obj.RecRowID = rowData["SSHospID"];
			$("#addIcon").linkbutton("disable");
			$("#editIcon").linkbutton("enable");
			$("#delIcon").linkbutton("enable");
		}
	}
	//CheckSpecificKey();
	//提交后台保存
	obj.btnSave_click=function()
	{
		var errinfo = "";
		//$.form.GetValue("txtDicCode")
		var SSHospCode = $("#SSHospCode").val();
		var SSHospDesc = $("#SSHospDesc").val();
		var CTHospID = $("#cboCTHosp").combobox('getValue');
		var ProductID = $('#cboProduct').combobox('getValue');
		var IsActive = $("#chkIsActive").checkbox('getValue')? '1':'0';
		var Resume = $("#Resume").val();
		IsActive = (IsActive==true ? 1 : 0);
		
		if (!SSHospCode) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!SSHospDesc) {
			errinfo = errinfo + "名称为空!<br>";
		}
		/*
		if (!ProductID) {
			errinfo = errinfo + "产品为空!<br>";
		}
		*/
		if (!CTHospID) {
			errinfo = errinfo + "别名为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var InputStr = obj.RecRowID
		var CHR_1=String.fromCharCode(1);
		InputStr += "^" + SSHospCode;
		InputStr += "^" + SSHospDesc;
		InputStr += "^" + CTHospID;
		//InputStr += "^" + GroupDesc;
		InputStr += "^" + ProductID;
		InputStr += "^" + IsActive;
		InputStr += "^" + Resume;
		var flg = $m({
			ClassName:"DHCMed.SS.Hospital",
			MethodName:"Update",
			InStr:InputStr,
			separete:"^"
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
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID = flg;
			obj.dictList.reload() ;//刷新当前页
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
					ClassName:"DHCMed.SS.Hospital",
					MethodName:"DeleteById",
					Id:obj.RecRowID
				},false);
				//if(flg=0){alert("删除成功啦")}
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.dictList.reload() ;//刷新当前页
				}
			} 
		});
	}
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID=rd["SSHospID"];
			var SSHospCode = rd["SSHospCode"];
			var SSHospDesc = rd["SSHospDesc"];
			var CTHospID = rd["CTHospID"];
			var ProductID = rd["ProductID"];
			var IsActive = rd["IsActiveDesc"];
			var Resume = rd["Resume"];
			
			$("#SSHospCode").val(SSHospCode);
			$("#SSHospDesc").val(SSHospDesc);	
			$("#cboCTHosp").combobox('setValue',CTHospID);
			$("#cboProduct").combobox('setValue',ProductID);
			$('#chkIsActive').checkbox('setValue',(IsActive=='是' ? true : false));
			$("#Resume").val(Resume);
		}else{
			obj.RecRowID = "";
			$("#SSHospCode").val('');
			$("#SSHospDesc").val('');
			$("#cboCTHosp").combobox('setValue','');
			$("#cboProduct").combobox('setValue','');
			$('#chkIsActive').checkbox('setValue','');
			$("#Resume").val('');
		}
		$HUI.dialog('#winProEdit').open();
	}
}

