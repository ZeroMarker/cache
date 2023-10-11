//页面Event
function InitInfSubWinEvent(obj){
	obj.LoadEvent = function(args){
		obj.gridInfSubLoad();
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
	 	});
	 	
		$('#btnClose').on('click', function(){
		    $HUI.dialog('#InfSubEdit').close();
	    });
	    
		$("#btnAdd").on('click', function(){
			obj.layer_rd = '';
			obj.Layer();
		});
		
		$("#btnEdit").on('click', function(){
			var rowData = obj.gridInfSub.getSelected();
			obj.layer_rd=rowData;
			obj.Layer(rowData);
		});
		
		//删除
		$('#btnDelete').click(function () {
			var rowData = obj.gridInfSub.getSelected();
			var rowDataID =rowData["ID"];
			$.messager.confirm("删除", "确定删除选中数据记录?", function (r) {				
				if (r) {				
					var flg = $m({
						ClassName:"DHCHAI.BT.InfSub",
						MethodName:"DeleteById",
						aId:rowDataID
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
						obj.gridInfSubLoad() ;
					}
				} 
			});		
		});
	}
	
	//窗体初始化
	obj.InfSubEdit =function() {
		$('#InfSubEdit').dialog({
		title: '感染诊断分类编辑',
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
		var PFCode = $('#txtCode').val();
		var PFDesc = $('#txtDesc').val();
		var IsActive = $('#chkIsActive').checkbox('getValue');
		var PFIsActive = (IsActive==1 ? '1':'0');
		if (!PFCode) {
			errinfo = errinfo + "分类代码不允许为空!<br>";
		}
		if (!PFDesc) {
			errinfo = errinfo + "分类名称不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}	
		var inputStr = ID;
		inputStr = inputStr + "^" + PFCode;
		inputStr = inputStr + "^" + PFDesc;
		inputStr = inputStr + "^" + PFIsActive;
		
		var flg = $m({
			ClassName:"DHCHAI.BT.InfSub",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("失败提示", "更新数据失败!返回码=" + flg, 'info');
			} else if (parseInt(flg) == -2) {
				$.messager.alert("失败提示", "代码重复!" , 'info');
			} else {
				$.messager.alert("失败提示", "更新数据失败!返回码=" + flg, 'info');
			}
		} else {
			$HUI.dialog('#InfSubEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.gridInfSubLoad();
		}
	}

	//单击选中事件：选择易感因素
	obj.gridInfSub_onSelect = function (){
		var rowData = obj.gridInfSub.getSelected();
		if (rowData["ID"] == obj.RecRowID) {
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.RecRowID="";
			obj.gridInfSub.clearSelections();
		}else{
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}	
	}
	//双击编辑事件
	obj.gridInfSub_onDbselect = function(rd){
		obj.layer_rd=rd;
		obj.Layer(rd);
	}	
	
	//易感因素编辑窗体-初始化
	obj.Layer = function(rd){
		if (rd){
			var txtCode = rd["Code"];
			var txtDesc = rd["Desc"];
			var BTIsActive = rd["IsActive"];
			BTIsActive = (BTIsActive=="是"? true: false);
			$('#txtCode').val(txtCode);
			$('#txtDesc').val(txtDesc);
			$('#chkIsActive').checkbox('setValue',BTIsActive);
			$("#txtCode,#txtDesc").validatebox({required:true});
		}else {
			obj.RecRowID="";
			$('#txtCode').val("");
			$('#txtDesc').val("");
			$('#chkIsActive').checkbox('setValue',"");
			$("#txtCode,#txtDesc").validatebox({required:true});
		}
		$('#InfSubEdit').show();
		obj.InfSubEdit();
	}
	
	obj.gridInfSubLoad = function(){
		$("#gridInfSub").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.BTS.InfSubSrv",
			QueryName:"QryInfSub",		
	    	page:1,
			rows:200
		},function(rs){
			$('#gridInfSub').datagrid('loadData', rs);					
		});
    }
}