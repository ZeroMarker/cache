//页面Event
function InitOEAntiCatWinEvent(obj){
	//检索框
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridOEAntiCat"),value);
		}	
	});	
	
	obj.LoadEvent = function(args){
		obj.gridOEAntiCatLoad();
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
	 	});
		$('#btnClose').on('click', function(){
		    $HUI.dialog('#OEAntiCatEdit').close();
	    });
		$("#btnAdd").on('click', function(){
			obj.layer_rd = '';
			obj.Layer();
		});
		$("#btnEdit").on('click', function(){
			var rowData = obj.gridOEAntiCat.getSelected();
			obj.layer_rd=rowData;
			obj.Layer(rowData);
		});	
		//删除		
		$('#btnDelete').click(function () {
			var rowData = obj.gridOEAntiCat.getSelected();
			var rowDataID =rowData["ID"];
			$.messager.confirm("删除", "确定删除选中数据记录?", function (r) {				
				if (r) {				
					var flg = $m({
						ClassName:"DHCHAI.DP.OEAntiCat",
						MethodName:"DeleteById",
						Id:rowDataID
					},false);
					if (parseInt(flg)<0){
						if (parseInt(flg)=='-777') {
							$.messager.alert("提示","-777：当前无删除权限，请启用删除权限后再删除记录!",'info');
						}else {
							$.messager.alert("提示","删除失败!",'info');
						}
						return;
					} else {
						$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
						obj.RecRowID = "";
						obj.gridOEAntiCatLoad() ;//刷新当前页
					}
				} 
			});		
		});
	}
	
	//窗体初始化
	obj.OEAntiCatEdit =function() {
		$('#OEAntiCatEdit').dialog({
			title: '抗菌药物分类编辑',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:true
		});
	},

	//保存
	obj.btnSave_click = function(){
		var errinfo="";
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		var BTCode = $('#txtBTCode').val();
		var BTDesc = $('#txtBTDesc').val();
		if (!BTCode) {
			errinfo = errinfo + "分类代码不允许为空!<br>";
		}
		if (!BTDesc) {
			errinfo = errinfo + "分类名称不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}	
		var inputStr = ID;
		inputStr = inputStr + "^" + BTCode;
		inputStr = inputStr + "^" + BTDesc;
		var flg = $m({
			ClassName:"DHCHAI.DP.OEAntiCat",
			MethodName:"Update",
			InStr:inputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("失败提示", "保存失败!返回码=" + flg, 'info');
			} else if (parseInt(flg) == '-100') {
				$.messager.alert("失败提示", "代码重复!" , 'info');
			} else {
				$.messager.alert("失败提示", "保存失败!返回码=" + flg, 'info');
			}
		} else {
			$HUI.dialog('#OEAntiCatEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.gridOEAntiCatLoad();//刷新当前页
		}
	}

	//单击选中事件
	obj.gridOEAntiCat_onSelect = function (){
		var rowData = obj.gridOEAntiCat.getSelected();
		if (rowData["ID"] == obj.RecRowID) {
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.RecRowID="";
			obj.gridOEAntiCat.clearSelections();
		}else{
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}	
	}
		
	//双击编辑事件
	obj.gridOEAntiCat_onDbselect = function(rd){
		obj.layer_rd=rd;
		obj.Layer(rd);
	}

	//编辑窗体-初始化
	obj.Layer = function(rd){
		if (rd){
			var txtCode = rd["BTCode"];
			var txtDesc = rd["BTDesc"];
			$('#txtBTCode').val(txtCode);
			$('#txtBTDesc').val(txtDesc);
			$("#txtBTCode,#txtBTDesc").validatebox({required:true});
		}else {
			obj.RecRowID="";
			$('#txtBTCode').val("");
			$('#txtBTDesc').val("");
			$("#txtBTCode,#txtBTDesc").validatebox({required:true});
		}
		$('#OEAntiCatEdit').show();
		obj.OEAntiCatEdit();
	}
	
	obj.gridOEAntiCatLoad = function(){
		$("#gridOEAntiCat").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.DPS.OEAntiCatSrv",
			QueryName:"QryOEAntiCat",		
	    	page:1,
			rows:9999
		},function(rs){
			$('#gridOEAntiCat').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}