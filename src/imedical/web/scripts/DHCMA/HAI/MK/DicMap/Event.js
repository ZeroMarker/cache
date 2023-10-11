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
	
	$("#cboCat").combobox({
		onSelect:function(record){
										 	 
		},
		onChange:function(newval,oldval){
			obj.aCategory = newval;
			obj.gridDicTypeLoad();
		}	 	
	})

	//核心方法-更新
	obj.Save = function(){
		//$("#cboHospital").combobox('getValue');
		var errinfo = "";
		var Category = $("#cboCategory").combobox('getValue');
		
		var SrcObjectID = $('#txtSrcObjectID').val();
		var SrcDescription = $('#txtSrcDescription').val();
		
		var Target = $('#txtTarget').val();
		var TargetDesc = $('#txtTargetDesc').val();
		
		var ResumeText = $('#txtResumeText').val();
		
	
		if (!Category) {
			errinfo = errinfo + "字典类型不允许为空!<br>";
		}
		if (!SrcObjectID) {
			errinfo = errinfo + "唯一键值不允许为空!<br>";
		}
		if (!SrcDescription) {
			errinfo = errinfo + "键值描述不允许为空!<br>";
		}
		if (!Target) {
			errinfo = errinfo + "标准值不允许为空!<br>";
		}
		if (!TargetDesc) {
			errinfo = errinfo + "标准描述不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return ;
		}
		var InputStr=obj.RecRowID;
		InputStr += "^" + Category;
		InputStr += "^" + SrcObjectID;
		InputStr += "^" + SrcDescription;
		InputStr += "^" + Target;
		InputStr += "^" + TargetDesc;
		InputStr += "^" + ResumeText;
		
		var flg = $m({
			ClassName:"DHCHAI.MK.BTMapData",
			MethodName:"Update",
			aInput:InputStr,
		},false);
		
		if (parseInt(flg)> 0) {
			obj.RecRowID = flg;
			obj.gridDicTypeLoad();	//刷新当前页
			$HUI.dialog('#winEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		}else if(parseInt(flg) == '-2'){
			$.messager.alert("错误提示", "同类型的唯一键值重复!" , 'info');
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
					ClassName:"DHCHAI.MK.BTMapData",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);
				
				if (flg == '1') {
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
			ClassName:"DHCHAI.MK.BTMappingSrv",
			QueryName:"QryByCategoryNew",
			aCategory:obj.aCategory,
			aSrcValue:"",
			aSrcDesc:"",
			aTargetValue:"",
			aTargetDesc:"",
			page:1,
			rows:9999
		},function(rs){
			$('#gridDicType').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);	
		});
	}
    //窗体-初始化
	obj.InitDialog= function(rd){
		if(rd){
			$('#txtSrcObjectID').val(rd["SrcObjectID"]).validatebox("validate");
			$('#txtSrcDescription').val(rd["SrcDescription"]).validatebox("validate");
			$('#txtTarget').val(rd["Target"]).validatebox("validate");
			$('#txtTargetDesc').val(rd["TargetDesc"]).validatebox("validate");
			$('#txtResumeText').val(rd["ResumeText"]).validatebox("validate");
			$("#cboCategory").combobox('setValue',rd["Category"]);
			obj.RecRowID=rd["ID"];
		}else{
			$('#txtSrcObjectID').val("").validatebox("validate");
			$('#txtSrcDescription').val("").validatebox("validate");
			$('#txtTarget').val("").validatebox("validate");
			$('#txtTargetDesc').val("").validatebox("validate");
			$('#txtResumeText').val("").validatebox("validate");
			$("#cboCategory").combobox('setValue',"");
			obj.RecRowID = "";
		}
		$("#winEdit").show()
		$('#winEdit').dialog({
			title: '民科字典对照编辑',
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:true
		});
	}
}
