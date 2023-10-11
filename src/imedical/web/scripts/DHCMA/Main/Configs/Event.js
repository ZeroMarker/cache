function InitDictWinEvent(obj){
	//异常弹窗
	$("#winInit").dialog({
		title:"编辑",
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text:'保存',
			handler:function(){
				obj.btnSave_click();
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#winInit').close();
			}
		}]
		
	});
	//选择
	obj.gridItems_onSelect = function (){
		var rowData = obj.gridItems.getSelected();
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID="";
		if (rowData["myid"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDel").linkbutton("disable");
			obj.gridItems.clearSelections();
		} else {
			obj.RecRowID = rowData["myid"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDel").linkbutton("enable");
		}
	}
	//event加载
	obj.LoadEvent=function(args){
		$("#btnAdd").on("click",obj.btnAdd_click) 
		$("#btnDel").on("click",obj.btnDel_click) 
		$("#btnEdit").on("click",obj.btnEdit_click) 
	}
	obj.gridMdlDef_onSelect = function (){
		var rowData = obj.gridMdlDef.getSelected();
		obj.ProCode = rowData["ProCode"];
		obj.gridItemsLoad();
	}
	//右键添加类型
	obj.btnAdd_click=function(){
		obj.layInit("");
	}
	//右键编辑类型
	obj.btnEdit_click=function(){
		var rd = obj.gridItems.getSelected();
		if (rd==null){
			$.messager.alert("提示", "选中数据记录,再点击编辑!", 'info');
			return;
		}
		obj.layInit(rd);
		//打开弹窗		
	}
	//双击表单
	obj.gridItems_onDbselect=function(rowData){
		obj.layInit(rowData);
	};
	obj.btnDel_click = function(){
		var rowData = obj.gridItems.getSelected();
		if (rowData==null){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		else{
			obj.RecRowID = rowData["myid"];
			$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
				if (r) {				
					var flg = $m({
						ClassName:"DHCMed.SS.Config",
						MethodName:"DeleteById",
						Id:obj.RecRowID
					},false);
				
					if (parseInt(flg) < 0) {
						if (parseInt(flg)=='-777') {
							$.messager.alert("错误提示","-777：当前无删除权限，请启用删除权限后再删除记录!",'info');
						}else {
							$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
						}
						return;
					} else {
						$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
						obj.RecRowID = "";
						obj.gridItems.reload() ;//刷新当前页
					}
				} 
			});
		}
	}
	//字典项目保存事件
	obj.btnSave_click=function(){
		var separete="^";
		var Code=$("#txtCode").val();
		var desc=$("#txtDesc").val();
		if(Code=="") {
			$.messager.alert("提示","代码不能为空！");
			return;
		}
		if(desc=="") {
			$.messager.alert("提示","描述不能为空！");
			return;
		}	
		var val=$("#txtVal").val();
		var valDesc=$("#txtValueDesc").val();
		var product=$.trim($("#cboPro").combobox("getValue"));
		if(product=="") {
			$.messager.alert("提示","所属产品不能为空！");
			return;
		}
		var hospital=$.trim($("#cboHosp").combobox("getValue"));
		var Resume=$("#txtResume").val();
		var separete = String.fromCharCode(1);
		var separete="^";
		var tmp = obj.RecRowID+separete;
		tmp += Code+ separete;
		tmp += desc + separete;
		tmp += val + separete;
		tmp += valDesc + separete;
		tmp += product + separete;	
		tmp +=hospital +  separete;
		tmp += Resume + separete;
		var ret =$m({
			ClassName:'DHCMed.SS.Config',
			MethodName:'Update',
			InStr:tmp,
			separete:separete				
		},false) //dicPersistent.Update(tmp,separete);		
		if (parseInt(ret) <= 0) {
			if (parseInt(ret) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
			} else if(parseInt(ret) == -1){
				$.messager.alert("错误提示", "代码重复!" , 'info');
			} else if(parseInt(ret) == -2){
				$.messager.alert("错误提示", "数据重复!" , 'info');
			}else{
				$.messager.alert("错误提示", "更新数据错误!Error=" + ret, 'info');
			}
		}else {
			$HUI.dialog('#winInit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID = ret;
			obj.gridItems.reload() ;//刷新当前页
		}
	};



	//只要一个弹窗 
	obj.layInit=function(rd){
		if(rd){
			obj.RecRowID=rd["myid"];
			var Keys = rd["Keys"];
			var Description = rd["Description"];
			var Val= rd["Val"];
			var ValueDesc = rd["ValueDesc"];
			var ProID = rd["ProID"];
			var HospID = rd["HospID"];
			var Resume = rd["Resume"];

			$("#txtCode").val(Keys );
			$("#txtDesc").val(Description);
			$("#txtVal").val(Val);	
			$("#txtValueDesc").val(ValueDesc);
			$("#cboPro").combobox("setValue",ProID);
			$("#cboHosp").combobox("setValue",HospID);
			$("#txtResume").val(Resume);
		}else{
			obj.RecRowID = "";
			$("#txtCode").val("");
			$("#txtDesc").val("");
			$("#txtVal").val("");	
			$("#txtValueDesc").val("");
			$("#cboPro").combobox("setValue","");
			$("#cboHosp").combobox("setValue","");
			$("#txtResume").val("");
		}
		$HUI.dialog('#winInit').open();
	}
	obj.gridItemsLoad = function () {
		var ProCode = "";
		if (obj.ProCode) {
			ProCode =obj.ProCode;
		}
		if(ProCode=="HAI"){
			ProCode="NINF"
			}
		obj.gridItems.load({
			ClassName:"DHCMed.SSService.ConfigSrv",
			QueryName:"QryConfig",
			aProCode:ProCode
		});	
	}
}