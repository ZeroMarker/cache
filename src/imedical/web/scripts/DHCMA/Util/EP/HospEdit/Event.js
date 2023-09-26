//页面Event
function InitHISUIWinEvent(obj){
		$("#winProEdit").dialog({
			iconCls:'icon-w-paper',
			title:'医院编辑',
			closed: true,
			isTopZindex:false,//true,
			resizable:true,
			modal:true,
			buttons:[{
				text:'保存',
				handler:function(){
					obj.btnSave_click();
					obj.saveToSrv();
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
		var errinfo = "";
		var OID = $("#OID").val();
		//$.form.GetValue("txtDicCode")
		var BTCode = $("#txtCode").val();
		var BTDesc = $("#txtDesc").val();
		var BTDesc2 = $("#txtDesc2").val();
		var GroupDesc  = $("#txtGroupDr").combobox('getValue');
		var RangeID   = $("#RangeID").val();
		var IsActive = $("#chkIsActive").checkbox('getValue');
		IsActive = (IsActive==true ? 1 : 0);
		
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
		InputStr += CHR_1 + GroupDesc;
		InputStr += CHR_1 + RangeID;
		InputStr += CHR_1 + IsActive;
		InputStr += CHR_1 + session['LOGON.USERID'];
		var flg = $m({
			ClassName:"DHCMA.Util.EPx.Hospital",
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
					ClassName:"DHCMA.Util.EPx.Hospital",
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
			var GroupDesc = rd["GroupDesc"];
			var RangeID = rd["RangeID"];
			var IsActive = rd["IsActive"];
			
			$("#OID").val(OID);
			$("#txtCode").val(Code);
			$("#txtDesc").val(Desc);	
			$("#txtDesc2").val(Desc2);
			$("#txtGroupDr").val(GroupDesc);
			$("#RangeID").val(RangeID);
			$('#chkIsActive').checkbox('setValue',(IsActive=='1' ? true : false));
		}else{
			obj.RecRowID = "";
			$("#OID").val('');
			$("#txtCode").val('');
			$("#txtDesc").val('');
			$("#txtDesc2").val('');
			$("#txtGroupDr").val('');
			$("#RangeID").val('');
			$('#chkIsActive').checkbox('setValue',false);
		}
		$HUI.dialog('#winProEdit').open();
	}
}

