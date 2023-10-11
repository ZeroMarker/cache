//页面Event
function InitLabBactCatWinEvent(obj){
	//按钮初始化
	obj.LoadEvent = function(args){ 
		$('#gridLabBactCat').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		obj.gridLabBactCatLoad();
		$('#gridLabBactType').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		obj.gridLabBactTypeLoad();
		//新增-分类
		$('#btnAdd_one').on('click', function(){
			obj.InitDialog();
		});
		//编辑-分类
		$('#btnEdit_one').on('click', function(){
			var rd=obj.gridLabBactCat.getSelected();
			obj.InitDialog(rd);
		});
		//删除-分类
		$('#btnDelete_one').on('click', function(){
			obj.btnDelete_click();
		});
		//搜索-分类
		$('#search_one').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridLabBactCat"),value);
			}	
		});
		//新增-类型
		$('#btnAdd_two').on('click', function(){
			obj.InitDialog_two();
		});
		//编辑-类型
		$('#btnEdit_two').on('click', function(){
			var rd=obj.gridLabBactType.getSelected();
			obj.InitDialog_two(rd);
		});
		//删除-类型
		$('#btnDelete_two').on('click', function(){
			obj.btnDeleteTwo_click();
		});
		//搜索-类型
		$('#btnsearch_two').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridLabBactType"),value);
			}	
		});
  }
   //双击编辑事件
	obj.gridLabBactCat_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	obj.gridLabBactType_onDbselect = function(rd){
		obj.InitDialog_two(rd);
	}
	//选择
	obj.gridLabBactCat_onSelect = function (){
		var rowData = obj.gridLabBactCat.getSelected();
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd_one").linkbutton("enable");
			$("#btnEdit_one").linkbutton("disable");
			$("#btnDelete_one").linkbutton("disable");
			obj.gridLabBactCat.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd_one").linkbutton("disable");
			$("#btnEdit_one").linkbutton("enable");
			$("#btnDelete_one").linkbutton("enable");
		}
	}
	obj.gridLabBactType_onSelect = function (){
		var rowData2 = obj.gridLabBactType.getSelected();
		if (rowData2["ID"] == obj.RecRowID2) {
			obj.RecRowID2="";
			$("#btnAdd_two").linkbutton("enable");
			$("#btnEdit_two").linkbutton("disable");
			$("#btnDelete_two").linkbutton("disable");
			obj.gridLabBactType.clearSelections();
		} else {
			obj.RecRowID2 = rowData2["ID"];
			$("#btnAdd_two").linkbutton("disable");
			$("#btnEdit_two").linkbutton("enable");
			$("#btnDelete_two").linkbutton("enable");
		}
	}
	
	//保存
	obj.btnSave_click = function(){
		var errinfo = "";
		var BCCode = $('#txtBCCode').val();
		var BCDesc = $('#txtBCDesc').val();
		if (!BCCode) {
			errinfo = errinfo + "细菌分类代码不允许为空!<br>";
		}
		if (!BCDesc) {
			errinfo = errinfo + "细菌分类名称不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var inputStr = obj.RecRowID;
		inputStr = inputStr + '^' + BCCode;
		inputStr = inputStr + '^' + BCDesc;
		var flg = $m({
			ClassName:"DHCHAI.DP.LabBactCat",
			MethodName:"Update",
			InStr:inputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == '-100') {
				$.messager.alert("错误提示", "细菌分类代码不允许修改!" , 'info');
				return;
			}else{
				$.messager.alert("错误提示", "保存失败" , 'info');
				return;
				}
		}else {
			$HUI.dialog('#winEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID = flg;
			originalData["gridLabBactCat"]=""; 
			obj.gridLabBactCatLoad();//刷新当前页
		}
	}
	
	obj.btnSaveTwo_click = function(){
		var errinfo = "";
		var BCCode2 = $('#txtBCCode2').val();
		var BCDesc2 = $('#txtBCDesc2').val();
		if (!BCCode2) {
			errinfo = errinfo + "细菌类型代码不允许为空!<br>";
		}
		if (!BCDesc2) {
			errinfo = errinfo + "细菌类型名称不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var inputStr = obj.RecRowID2;
		inputStr = inputStr + '^' + BCCode2;
		inputStr = inputStr + '^' + BCDesc2;
		var flg = $m({
			ClassName:"DHCHAI.DP.LabBactType",
			MethodName:"Update",
			InStr:inputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == '-100') {
				$.messager.alert("错误提示", "细菌类型代码不允许修改!" , 'info');
				return;
			}else{
				$.messager.alert("错误提示", "保存失败" , 'info');
				return;
				}
		}else {
			$HUI.dialog('#winEdit_two').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID2 = flg;
			originalData["gridLabBactType"]=""; 
			obj.gridLabBactTypeLoad();//刷新当前页
		}
	}
	//删除
	obj.btnDelete_click = function(){
		if (obj.RecRowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.DP.LabBactCat",
					MethodName:"DeleteById",
					Id:obj.RecRowID
				},false);
				if (parseInt(flg) < 0) {
					if (parseInt(flg)=='-777') {
						$.messager.alert('错误提示','当前无删除权限，请启用删除权限后再删除记录!','info');
						return;
					}else {
						$.messager.alert('删除失败!','info');
						return;
					}				
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					originalData["gridLabBactCat"]=""; 
					obj.gridLabBactCatLoad();//刷新当前页
				}
			} 
		});
	}
	obj.btnDeleteTwo_click = function(){
		if (obj.RecRowID2==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.DP.LabBactType",
					MethodName:"DeleteById",
					Id:obj.RecRowID2
				},false);
				if (parseInt(flg) < 0) {
					if (parseInt(flg)=='-777') {
						$.messager.alert('错误提示','当前无删除权限，请启用删除权限后再删除记录!','info');
						return;
					}else {
						$.messager.alert('删除失败!','info');
						return;
					}				
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID2 = "";
					originalData["gridLabBactType"]=""; 
					obj.gridLabBactTypeLoad();//刷新当前页
				}
			} 
		});
	}
	//窗体
	obj.SetWinEdit=function (){
		$('#winEdit').dialog({
			title: '细菌分类编辑',
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:false,//true,
			buttons:[{
				text:'保存',
				handler:function(){
					obj.btnSave_click();
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog('#winEdit').close();
				}
			}]
		});
	}
	//窗体2
	obj.SetWinEdit_two=function (){
		$('#winEdit_two').dialog({
			title: '细菌类型编辑',
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:false,//true,
			buttons:[{
				text:'保存',
				handler:function(){
					obj.btnSaveTwo_click();
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog('#winEdit_two').close();
				}
			}]
		});
	}
	//配置窗体-初始化
	obj.InitDialog= function(rd){
		if(rd){
			obj.RecRowID=rd["ID"];
			var BCCode = rd["BCCode"];
			var BCDesc = rd["BCDesc"];
			$('#txtBCCode').val(BCCode);
			$('#txtBCDesc').val(BCDesc);
		}else{
			obj.RecRowID = "";
			$('#txtBCCode').val('');
			$('#txtBCDesc').val('');
		}
		$('#winEdit').show();
		obj.SetWinEdit();
		
	}
	obj.InitDialog_two= function(rd){
		if(rd){
			obj.RecRowID2=rd["ID"];
			var BCCode = rd["BCCode"];
			var BCDesc = rd["BCDesc"];
			$('#txtBCCode2').val(BCCode);
			$('#txtBCDesc2').val(BCDesc);
		}else{
			obj.RecRowID2 = "";
			$('#txtBCCode2').val('');
			$('#txtBCDesc2').val('');
		}
		$('#winEdit_two').show();
		obj.SetWinEdit_two();
	}
	obj.gridLabBactCatLoad = function(){
		//$("#gridLabAntiCat").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.DPS.LabBactSrv",
			QueryName:"QryLabBactCat",		
	    	page:1,
			rows:99999
		},function(rs){
			$('#gridLabBactCat').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
    obj.gridLabBactTypeLoad = function(){
		//$("#gridLabAntiCat").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.DPS.LabBactSrv",
			QueryName:"QryLabBactType",		
	    	page:1,
			rows:99999
		},function(rs){
			$('#gridLabBactType').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}
