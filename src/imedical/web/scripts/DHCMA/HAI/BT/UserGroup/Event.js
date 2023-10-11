//页面Event
function InitWinEvent(obj){
	//事件初始化
	obj.LoadEvent = function(args){
		obj.gridDicTypeLoad();
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		$('#btnAddT').on('click', function(){
			obj.InitDialogT();
		});
		$('#btnEdit').on('click', function(){
			var rd=obj.gridDicType.getSelected()
			obj.InitDialog(rd);
		});
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		$('#btnDeleteT').on('click', function(){
			obj.btnDelete_clickT();
		});
		$('#winBtnEdit').on('click', function(){
			obj.Save();
		});
		$('#winBtnClose').on('click', function(){
			$HUI.dialog('#winEdit').close();
		});
		$('#winBtnEditT').on('click', function(){
			obj.SaveT();
		});
		$('#winBtnCloseT').on('click', function(){
			$HUI.dialog('#winEditT').close();
		});
		$('#searchboxT').searchbox({ 
			searcher:function(value,name){
				searchText($("#gridDicTypeT"),value);
			}	
		});
     }
    //双击编辑
	obj.gridDicType_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//选择
	obj.gridDicType_onSelect = function (){
		var rowData = obj.gridDicType.getSelected();

		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridDicType.clearSelections();
			$("#btnAddT").linkbutton("disable");
			$("#btnDeleteT").linkbutton("disable");
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");			
			$("#btnAddT").linkbutton("enable");
			$("#btnDeleteT").linkbutton("disable");
		}
		obj.gridDicTypeLoadT();
	}

	//核心方法-更新
	obj.Save = function(){
		
		var errinfo = "";
		var Code = $('#txtCode').val();
		var Desc = $('#txtDesc').val();
		var MainUrl = $('#txtMainUrl').val();
	
		if (!Code) {
			errinfo = errinfo + "角色代码不允许为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "角色名称不允许为空!<br>";
		}
		if (!MainUrl) {
			errinfo = errinfo + "首页地址不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return ;
		}
		var InputStr=obj.RecRowID;
		InputStr += "^" + Code;
		InputStr += "^" + Desc;
		InputStr += "^" + "首页";
		InputStr += "^" + MainUrl;
		
		var flg = $m({
			ClassName:"DHCHAI.BT.UserGroup",
			MethodName:"Update",
			aInputStr:InputStr,
		},false);
		
		if (parseInt(flg)> 0) {
			obj.RecRowID = flg;
			obj.gridDicTypeLoad();	//刷新当前页
			$HUI.dialog('#winEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		}else if(parseInt(flg) == '-2'){
			$.messager.alert("错误提示", "代码重复!" , 'info');
		}else if(parseInt(flg) == '-3'){
			$.messager.alert("错误提示", "描述重复!" , 'info');
		}else{
			$.messager.alert("错误提示", "修改失败!Error=" + flg, 'info');
		}
	}
	//核心方法-删除
	obj.btnDelete_click = function(){
		if (obj.RecRowID==""){
			$.messager.alert("提示", "请选中数据,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "确认是否删除?", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.BT.UserGroup",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);
				
				if (flg == '0') {
					obj.RecRowID = "";
					obj.gridDicTypeLoad();	//刷新当前页
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
				} else {
					if (parseInt(flg)=='-777') {
						$.messager.alert("提示","-777：当前无删除权限，请启用删除权限后再删除记录!",'info');
					}else {
						$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					}
				}
			} 
		});
	}
	obj.gridDicTypeLoad=function(){
		originalData["gridDicType"]="";
		$cm({
			ClassName:"DHCHAI.BTS.UserMenuSrv",
			QueryName:"QryUserGroup",
			page:1,
			rows:9999
		},function(rs){
			$('#gridDicType').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);	
		});
	}
	obj.gridDicTypeLoadT=function(){
		originalData["gridDicTypeT"]="";
		
		$cm({
			ClassName:"DHCHAI.BTS.UserMenuSrv",
			QueryName:"QryUserMenuByGroup",
			aUserGrpID:obj.RecRowID,
			page:1,
			rows:9999
		},function(rs){
			$('#gridDicTypeT').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);	
		});
	}
    //窗体-初始化
	obj.InitDialog= function(rd){
		if(rd){
			$('#txtCode').val(rd["BTCode"]).validatebox("validate");
			$('#txtDesc').val(rd["BTDesc"]).validatebox("validate");
			$('#txtMainUrl').val(rd["BTMainUrl"]).validatebox("validate");
			
			obj.RecRowID=rd["ID"];
		}else{
			$('#txtCode').val('').validatebox("validate");
			$('#txtDesc').val('').validatebox("validate");
			$('#txtMainUrl').val('').validatebox("validate");
			
			obj.RecRowID = "";
		}
		$("#winEdit").show()
		$('#winEdit').dialog({
			title: '用户角色编辑',
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:true
		});
	}
	//窗体-初始化
	obj.InitDialogT= function(rd){		
		$('#cboMenu').combobox('setValue','');
		
		$("#winEditT").show()
		$('#winEditT').dialog({
			title: '角色菜单编辑',
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:true
		});
	}
	//核心方法-更新
	obj.SaveT = function(){
		
		var errinfo = "";
		var MenuDr = $("#cboMenu").combobox("getValue");
	
		if (!MenuDr) {
			errinfo = errinfo + "角色菜单不允许为空!<br>";
		}
		
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return ;
		}
		var InputStr="";   //只支持新增-删除
		InputStr += "^" + obj.RecRowID;
		InputStr += "^" + MenuDr;
		
		var flg = $m({
			ClassName:"DHCHAI.BT.UserMenu",
			MethodName:"Update",
			aInputStr:InputStr,
		},false);
		
		if (parseInt(flg)> 0) {
			obj.gridDicTypeLoadT();	//刷新当前页
			$HUI.dialog('#winEditT').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		}else if(parseInt(flg) == '-2'){
			$.messager.alert("错误提示", "菜单重复!" , 'info');
		}else{
			$.messager.alert("错误提示", "更新失败!Error=" + flg, 'info');
		}
	}
	//选择
	obj.gridDicTypeT_onSelect = function (){
		var rowData = obj.gridDicTypeT.getSelected();

		if (rowData["ID"] == obj.RecRowIDT) {
			obj.RecRowIDT = "";
			obj.gridDicTypeT.clearSelections();
			$("#btnAddT").linkbutton("enable");
			$("#btnDeleteT").linkbutton("disable");
		} else {
			obj.RecRowIDT = rowData["ID"];			
			$("#btnAddT").linkbutton("disable");
			$("#btnDeleteT").linkbutton("enable");
		}
	}
	//核心方法-删除
	obj.btnDelete_clickT = function(){
		if (obj.RecRowIDT==""){
			$.messager.alert("提示", "请选中数据,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "确认是否删除?", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.BT.UserMenu",
					MethodName:"DeleteById",
					aId:obj.RecRowIDT
				},false);
				
				if (flg == '0') {
					obj.RecRowIDT = "";
					obj.gridDicTypeLoadT();	//刷新当前页
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
				} else {
					if (parseInt(flg)=='-777') {
						$.messager.alert("提示","-777：当前无删除权限，请启用删除权限后再删除记录!",'info');
					}else {
						$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					}
				}
			} 
		});
	}
}
