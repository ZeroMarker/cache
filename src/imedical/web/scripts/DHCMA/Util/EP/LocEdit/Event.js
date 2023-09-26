//页面Event
function InitHISUIWinEvent(obj){
	// 初始化模态框
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
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#winProEdit').close();
			}
		}]
	});

	obj.LoadEvents = function(arguments){
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
	obj.dictList_onSelect = function (){
		var rowData = obj.dictList.getSelected();
		if($("#editIcon").hasClass("l-btn-disabled")) obj.RecRowID="";
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#editIcon").linkbutton("disable");
			$("#delIcon").linkbutton("disable");
			obj.dictList.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#editIcon").linkbutton("enable");
			$("#delIcon").linkbutton("enable");
		}
	}
	//CheckSpecificKey();
	//提交后台保存
	obj.btnSave_click=function()
	{
		var errinfo = '';
		var OID = $("#OID").val();
		//$.form.GetValue("txtDicCode")
		var BTCode = $("#txtCode").val();
		var BTDesc = $("#txtDesc").val();
		var BTDesc2 = $("#txtDesc2").val();
		var Type  = $("#txtType").combobox('getValue');
		var HospDr  = obj.txtHospDr.getValues();
		var RangeID   = $("#RangeID").val();
		var IsActive = $("#chkIsActive").checkbox('getValue');
		IsActive = (IsActive==true ? 1 : 0);
		var AdmType  = $("#txtAdmType").combobox('getValue');
		if (!BTCode) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!BTDesc) {
			errinfo = errinfo + "名称为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var InputStr = obj.RecRowID
		InputStr += CHR_1 + OID;
		InputStr += CHR_1 + BTCode;
		InputStr += CHR_1 + BTDesc;
		InputStr += CHR_1 + BTDesc2;
		InputStr += CHR_1 + Type;
		InputStr += CHR_1 + HospDr
		InputStr += CHR_1 + RangeID;
		InputStr += CHR_1 + IsActive;
		InputStr += CHR_1 + session['LOGON.USERID'];
		InputStr += CHR_1 + AdmType
		var flg = $m({
			ClassName:"DHCMA.Util.EPx.Location",
			MethodName:"Update",
			aInputStr:InputStr,
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
					ClassName:"DHCMA.Util.EPx.Location",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);
				if(flg=0){alert("删除成功啦")}
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
			obj.RecRowID=rd["ID"];
			var OID = rd["OID"];
			var Code = rd["Code"];
			var Desc = rd["Desc"];
			var Desc2 = rd["Desc2"];
			var TypeDesc = rd["TypeDesc"];
			var RangeID = rd["RangeID"];
			var IsActive = rd["IsActive"];
			var AdmType = rd["AdmType"]
			obj.txtAdmType.setValue(AdmType);
			
			$("#OID").val(OID);				
			$("#txtDesc").val(Desc);
			$("#txtCode").val(Code);
			$("#txtDesc2").val(Desc2);
			$("#RangeID").val(RangeID);
			$('#chkIsActive').checkbox('setValue',(IsActive=='1' ? true : false));
			// 所属医院和科室类型的特殊处理方式
			var HospIDs=rd["HospID"].split(",")
			obj.txtHospDr.setValues(HospIDs);
			// 处理科室类型中其他选项无value特殊情况
			if(rd["Type"] == '') {
				obj.txtType.setValues(["其他"]);
			}else {
				obj.txtType.setValues(rd["Type"]);
			}
		}else{
			obj.RecRowID = "";
			$("#OID").val('');				
			$("#txtDesc").val('');
			$("#txtCode").val('');
			$("#txtDesc2").val('');
			$("#RangeID").val('');
			$('#chkIsActive').checkbox('setValue',false);
			// 所属医院和科室类型的特殊处理方式
			obj.txtHospDr.setValues();
			obj.txtType.setValues();
			obj.txtAdmType.setValue();
		}
		$HUI.dialog('#winProEdit').open();
	};
}

