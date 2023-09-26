//页面Event
function InitHISUIWinEvent(obj){
		$("#winProEdit").dialog({
			iconCls:'icon-w-paper',
			title:'分组编辑',
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
		$('#addIcon').on('click', function(){
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
	obj.dictList_onSelect = function (){
		var rowData = obj.dictList.getSelected();
		if($("#editIcon").hasClass("l-btn-disabled")) obj.RecRowID="";
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#addIcon").linkbutton("enable");
			$("#editIcon").linkbutton("disable");
			$("#delIcon").linkbutton("disable");
			obj.dictList.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
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
		var DicCode = $("#txtCode").val();
		var DicDesc = $("#txtDesc").val();
		
		if (!DicCode) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!DicDesc) {
			errinfo = errinfo + "名称为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var InputStr = obj.RecRowID
		InputStr += CHR_1 + DicCode;
		InputStr += CHR_1 + DicDesc;
		var flg = $m({
			ClassName:"DHCMA.Util.BT.HospGroup",
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
					ClassName:"DHCMA.Util.BT.HospGroup",
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
			var DicDesc = rd["Desc"];
			var DicCode = rd["Code"];
			
			$("#txtDesc").val(DicDesc);
			$("#txtCode").val(DicCode);
		}else{
			obj.RecRowID = "";
			$("#txtDesc").val('');
			$("#txtCode").val('');
		}
		$HUI.dialog('#winProEdit').open();
	}
}

