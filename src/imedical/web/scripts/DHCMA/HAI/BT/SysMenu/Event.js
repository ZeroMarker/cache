//页面Event
function InitWinEvent(obj){
	//事件初始化
	obj.LoadEvent = function(args){
		obj.gridDicTypeLoad();
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		$('#btnEdit').on('click', function(){
			var rd=obj.gridDicType.getSelected()
			obj.InitDialog(rd);
		});
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		
		$('#winBtnEdit').on('click', function(){
			obj.Save();
		});
		$('#winBtnClose').on('click', function(){
			$HUI.dialog('#winEdit').close();
		});
		$('#searchbox').searchbox({ 
			searcher:function(value,name){
				searchText($("#gridDicType"),value);
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
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}

	//核心方法-更新
	obj.Save = function(){
		
		var errinfo = "";
		var Code = $('#txtCode').val();
		var Desc = $('#txtDesc').val();
		var MenuUrl =$('#txtUrl').val();
		var MenuIdx =$('#txtIdx').val();
		var TypeDr = $("#cboType").combobox("getValue");
	
		if (!Code) {
			errinfo = errinfo + "菜单编码不允许为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "菜单名称不允许为空!<br>";
		}
		if (!MenuUrl) {
			errinfo = errinfo + "菜单地址不允许为空!<br>";
		}
		if (!MenuIdx) {
			errinfo = errinfo + "菜单顺序不允许为空!<br>";
		}
		if (!TypeDr) {
			errinfo = errinfo + "菜单分类不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return ;
		}
		var InputStr=obj.RecRowID;
		InputStr += "^" + TypeDr;
		InputStr += "^" + Code;
		InputStr += "^" + Desc;
		InputStr += "^" + MenuUrl;
		InputStr += "^" + "";  //备注
		InputStr += "^" + MenuIdx;  //顺序
		
		var flg = $m({
			ClassName:"DHCHAI.BT.SysMenu",
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
					ClassName:"DHCHAI.BT.SysMenu",
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
			QueryName:"QrySysMenu",
			page:1,
			rows:9999
		},function(rs){
			$('#gridDicType').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);	
		});
	}
    //窗体-初始化
	obj.InitDialog= function(rd){
		if(rd){
			$('#txtCode').val(rd["BTCode"]).validatebox("validate");
			$('#txtDesc').val(rd["BTDesc"]).validatebox("validate");
			$('#txtUrl').val(rd["MenuUrl"]).validatebox("validate");
			$('#txtIdx').val(rd["IndNo"]).validatebox("validate");
			$('#cboType').combobox('setValue',rd["TypeID"]);
			$('#cboType').combobox('setText',rd["TypeDesc"]);
			obj.RecRowID=rd["ID"];
		}else{
			$('#txtCode').val('').validatebox("validate");
			$('#txtDesc').val('').validatebox("validate");
			$('#txtUrl').val('').validatebox("validate");
			$('#txtIdx').val('').validatebox("validate");
			$('#cboType').combobox('setValue','');	
			$('#cboHosp').combobox('setValue','');
			obj.RecRowID = "";
		}
		$("#winEdit").show()
		$('#winEdit').dialog({
			title: '功能菜单编辑',
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:true
		});
	}
}
