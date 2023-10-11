//页面Event
function InitDeleteControlWinEvent(obj){	
    
	obj.LoadEvent = function(args){ 
	    //保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#DeleteControlEdit').close();
     	});
		
	    //添加
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd = obj.gridDeleteControl.getSelected();
			obj.InitDialog(rd);
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});	
	}
	
	$('#txtSearch').searchbox({ 
		searcher:function(value,name){ 
			obj.gridDeleteControl.load({
				ClassName:'DHCMA.Util.BTS.DeleteControlSrv',
				QueryName:'QryDeleteControl',
				aKeyWords:value
			});
		}
	});
	
	
	//窗体初始化
	obj.DeleteControlEdit =function() {
		 $('#DeleteControlEdit').dialog({
			title:'基础字典删除控制权限',
			iconCls:'icon-w-edit',
			modal: true,
			isTopZindex:true
		});
	}
	
	//保存
	obj.btnSave_click = function(){
		var errinfo = "";
		var Product   = $('#cboProduct').combobox('getValue');
		var TableCode = $.trim($('#txtCode').val());
		var TableDesc = $.trim($('#txtDesc').val());
		var AllowDel  = $('#chkAllowDel').checkbox('getValue')? '1':'0';
		if (!Product) {
			errinfo = errinfo + "产品不允许为空!<br>";
		}
		
		if (!TableCode) {
			errinfo = errinfo + "代码不允许为空!<br>";
		}
		if (!TableDesc) {
			errinfo = errinfo + "描述不允许为空!<br>";
		}	
		
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Product;
		inputStr = inputStr + CHR_1 + TableCode;
		inputStr = inputStr + CHR_1 + TableDesc;
		inputStr = inputStr + CHR_1 + AllowDel;
	
		var flg = $m({
			ClassName:"DHCMA.Util.BT.DeleteControl",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:CHR_1
		},false);
        
		if (parseInt(flg) <= 0) {
			if(parseInt(flg) == -2){
				$.messager.alert("错误提示", "代码重复!" , 'info');
				return;
			}else{
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
				return;
			}
		}else {
			$HUI.dialog('#DeleteControlEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.gridDeleteControl.reload() ;//刷新当前页
		}
	}
	//删除 
	obj.btnDelete_click = function(){
		if (!obj.RecRowID ){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.Util.BT.DeleteControl",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridDeleteControl.reload() ;//刷新当前页
				}
			} 
		});
	}
	
	//单击选中事件
	obj.gridDeleteControl_onSelect = function (){
		var rowData = obj.gridDeleteControl.getSelected();
	
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			
			obj.gridDeleteControl.clearSelections();  //清除选中行
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}	
	
    //双击弹出编辑事件
	obj.gridDeleteControl_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	
	//窗口初始化
	obj.InitDialog = function(rd){
		if(rd){
			obj.RecRowID = rd["ID"];
			var ProCode = rd["ProCode"];
			var ProDesc = rd["ProDesc"];
			var Code = rd["TableCode"];
			var Desc = rd["TableDesc"];	
			var AllowDel = rd["AllowDel"];
			$('#cboProduct').combobox('setValue',ProCode);
			$('#cboProduct').combobox('setText',ProDesc);				
			$('#txtCode').val(Code);
			$('#txtDesc').val(Desc);
			$('#chkAllowDel').checkbox('setValue',(AllowDel==1 ? true:false));
		}else{
			obj.RecRowID = "";
			$('#cboProduct').combobox('clear');
			$('#txtCode').val('');
			$('#txtDesc').val('');	
			$('#chkAllowDel').checkbox('setValue','');
		}
		$('#DeleteControlEdit').show();
		obj.DeleteControlEdit();
	}
}