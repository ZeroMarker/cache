//页面Event
function InitMdlRoleListWinEvent(obj){	
	
	//按钮初始化-parent
	$('#winMdlDef').dialog({
		title: '产品模块定义',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
	});
	//按钮初始化-sub
	$('#winMdlRole').dialog({
		title: '模块角色定义',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
	});
	
	obj.LoadEvent = function(args){ 
		//保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		$('#btnSubSave').on('click', function(){
	     	obj.btnSubSave_click();
     	});
		//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#winMdlDef').close();
     	});
		$('#btnSubClose').on('click', function(){
	     	$HUI.dialog('#winMdlRole').close();
     	});
		//添加
		$('#btnAdd').on('click', function(){
			obj.layer1();
		});
		$('#btnSubAdd').on('click', function(){
			obj.layer2();
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd=obj.gridMdlDef.getSelected()
			obj.layer1(rd);	
		});
		$('#btnSubEdit').on('click', function(){
			var rd=obj.gridMdlRole.getSelected()
			obj.layer2(rd);	
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		}); 
		$('#btnSubDelete').on('click', function(){
			obj.btnSubDelete_click();
		}); 
     }
    //双击编辑事件-parent
	obj.gridMdlDef_onDbselect = function(rd){
		obj.layer1(rd);
	}
	//双击编辑事件-sub
	obj.gridMdlRole_onDbselect = function(rd){
		if($("#btnEdit").hasClass("l-btn-disabled")){
		$.messager.alert("错误提示", "请先选择左表中的数据" , 'info');			
		return;
		}
		if(!obj.RecRowID1) return;
		
		obj.layer2(rd);
	}
	//选择-parent
	obj.gridMdlDef_onSelect = function (){
		var rowData = obj.gridMdlDef.getSelected();
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID="";
		if (rowData["BTID"] == obj.RecRowID1) {
			obj.RecRowID1="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$("#btnSubAdd").linkbutton("disable");
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
			obj.gridMdlDef.clearSelections();
		}
		else {
			obj.RecRowID1 = rowData["BTID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
			obj.gridMdlRoleLoad();
		}
	}	
	//选择-sub
	obj.gridMdlRole_onSelect = function (){
		var rowData = obj.gridMdlRole.getSelected();
		if($("#btnEdit").hasClass("l-btn-disabled")) return;
		if(!obj.RecRowID1)return;
		if($("#btnSubEdit").hasClass("l-btn-disabled")) obj.RecRowID2="";
		if (rowData["ExtID"] == obj.RecRowID2) {
			obj.RecRowID2="";
			$("#btnSubAdd").linkbutton("enable");
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
			obj.gridMdlRole.clearSelections();
		}
		else {
			obj.RecRowID2 = rowData["ExtID"];
			$("#btnSubAdd").linkbutton("disable");
			$("#btnSubEdit").linkbutton("enable");
			$("#btnSubDelete").linkbutton("enable");	
		}
	}	
	//保存分类-parent
	obj.btnSave_click = function(){
		var errinfo = "";
		var Code = $('#txtCode').val();
		var Desc = $('#txtDesc').val();
		var ProductID =$('#cboTypeDr').combobox('getValue');
	
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}	
		if (!ProductID){
			errinfo = errinfo + "产品线为空!<br>";
		}
		var IsCheck = $m({
			ClassName:"DHCMA.Util.BTS.MdlDefSrv",
			MethodName:"CheckPTCode",
			aCode:Code,
			aID:obj.RecRowID1
		},false);
	  	if(IsCheck>=1) {
	  		errinfo = errinfo + "代码与列表中现有项目重复，请检查修改!<br>";
	  	}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID1;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;	
		inputStr = inputStr + CHR_1 + ProductID;
		var flg = $m({
			ClassName:"DHCMA.Util.BT.MdlDef",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:CHR_1
		},false);
		//alert(flg)
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
				//注意code 与产品的匹配
			} else if(parseInt(flg) == -2){
				$.messager.alert("错误提示", "数据重复!" , 'info');
			}else{
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#winMdlDef').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID1 = flg
			obj.gridMdlDef.reload() ;//刷新当前页
		}
	}
	//保存分类-sub
	obj.btnSubSave_click = function(){
		var errinfo = "";
		var Code = $('#txtSubCode').val();
		var Desc = $('#txtSubDesc').val();
	
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}	
		
		/*var IsCheck = $m({
			ClassName:"DHCMA.Util.BTS.MdlDefSrv",
			MethodName:"CheckPTCode",
			aCode:Code,
			aID:obj.RecRowID
		},false);
	  	if(IsCheck>=1) {
	  		errinfo = errinfo + "代码与列表中现有项目重复，请检查修改!<br>";
	  	}*/
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = "";
		if(obj.RecRowID2){
		var str=obj.RecRowID2.split('||');
			inputStr = str[0] + CHR_1 + str[1] 
		}else{
			inputStr = obj.RecRowID1 + CHR_1 + "" 
		}
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;	
		var flg = $m({
			ClassName:"DHCMA.Util.BT.MdlRole",
			MethodName:"Update",
			aInStr:inputStr,
			aSeparete:CHR_1
		},false);
		//alert(flg)
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
			} else if(parseInt(flg) == -2){
				$.messager.alert("错误提示", "数据重复!" , 'info');
			}else{
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#winMdlRole').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID2 = flg
			obj.gridMdlRole.reload() ;//刷新当前页
		}
	}
	//删除分类 -parent
	obj.btnDelete_click = function(){
		if (obj.RecRowID1==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.Util.BT.MdlDef",
					MethodName:"DeleteById",
					aId:obj.RecRowID1
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
					obj.gridMdlDef.reload() ;//刷新当前页
				}
			} 
		});
	}
	//删除分类 -sub
	obj.btnSubDelete_click = function(){
		var rowData = obj.gridMdlRole.getSelected();
		var rowDataID =rowData["SubID"];
		if ((obj.RecRowID1=="")||(rowDataID=="")){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.Util.BT.MdlRole",
					MethodName:"DeleteById",
					aId:obj.RecRowID1+"||"+rowDataID
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
					obj.gridMdlRole.reload() ;//刷新当前页
				}
			} 
		});
	}
    //配置窗体-初始化
	obj.layer1= function(rd){
		
		if(rd){
			obj.RecRowID1 = rd["BTID"];
			var Code = rd["BTCode"];
			var Desc = rd["BTDesc"];
			var BTTypeID = rd["BTTypeID"];
			
			$('#txtCode').val(Code);
			$('#txtDesc').val(Desc);
			$('#cboTypeDr').combobox('setValue',BTTypeID);
		}else{
			obj.RecRowID1 = "";
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#cboTypeDr').combobox('setValue','');
			
			
		}
		$HUI.dialog('#winMdlDef').open();
	}
	obj.layer2= function(rd){
		
		if(!obj.RecRowID1){
			//若（obj.RecRowID1 为空）父表未被选中，则子表不进行操作
			$.messager.alert("错误提示","请先选定模块",'info');
			return;
		}
		if(rd){
			obj.RecRowID2 = rd["ExtID"];
			var Code = rd["BTCode"];
			var Desc = rd["BTDesc"];
			
			$('#txtSubCode').val(Code);
			$('#txtSubDesc').val(Desc);
		}else{
			obj.RecRowID2 = "";
			$('#txtSubCode').val('');
			$('#txtSubDesc').val('');
		}
		$HUI.dialog('#winMdlRole').open();
	}
	//加载角色表
	obj.gridMdlRoleLoad = function () {
		var ParRef = "";
		if (obj.RecRowID1) {
			ParRef =obj.RecRowID1;
		}
		obj.gridMdlRole.load({
			ClassName:"DHCMA.Util.BTS.MdlRoleSrv",
			QueryName:"QryMdlRole",
			aParRef:ParRef
		});	
	}
	
}
