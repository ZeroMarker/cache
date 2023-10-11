//页面Event
function InitBactAntiIntWinEvent(obj){	
    
	obj.LoadEvent = function(args){ 
	    //保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#BactAntiIntEdit').close();
     	});
		
	    //添加
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd = obj.gridBactAntiInt.getSelected();
			obj.InitDialog(rd);
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});	
		//检索框
		$('#searchbox').searchbox({ 
			searcher:function(value,name){ 
				obj.gridBactAntiInt.load({
					ClassName:'DHCHAI.DPS.LabBactAntiIntSrv',
					QueryName:'QryBactAntiInt',
					aKeyDesc:value
				});
			}	
		});	
	}
	
	//窗体初始化
	obj.BactAntiIntEdit =function() {
		 $('#BactAntiIntEdit').dialog({
			title:'细菌天然耐药字典',
			iconCls:'icon-w-edit',
			modal: true,
			isTopZindex:true
		});
	}
	
	//保存
	obj.btnSave_click = function(){
		var errinfo = "";
		var BactDesc = $.trim($('#cboBact').lookup('getText'));
		var BactDr = obj.BacteriaID;
		var AntDesc = $.trim($('#cboAnti').lookup('getText'));
		var AntDr = obj.AntibioticID;
		
		var IsActive = $("#chkIsActive").checkbox('getValue');
		IsActive = (IsActive==true? 1 : 0);
		var Note = $('#txtNote').val();
			
		if (!BactDesc) {
			errinfo = errinfo + "细菌不允许为空!<br>";
		}
		if (!AntDesc) {
			errinfo = errinfo + "抗生素不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}	
		var inputStr = obj.RecRowID;
		inputStr = inputStr + "^" + BactDesc;
		inputStr = inputStr + "^" + BactDr;
		inputStr = inputStr + "^" + AntDesc;
		inputStr = inputStr + "^" + AntDr;
		inputStr = inputStr + "^" + IsActive;
		inputStr = inputStr + "^" + Note;
		
		var flg = $m({
			ClassName:"DHCHAI.DP.LabBactAntiInt",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:"^"
		},false);
	   
		if (parseInt(flg) <= 0) {
			if(parseInt(flg) == -2){
				$.messager.alert("错误提示", "数据重复!" , 'info');
				return;
			}else{
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
				return;
			}
		}else {
			$HUI.dialog('#BactAntiIntEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.gridBactAntiInt.reload() ;//刷新当前页
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
					ClassName:"DHCHAI.DP.LabBactAntiInt",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);

				if (parseInt(flg) < 0) {
					if (parseInt(flg)=='-777') {
						$.messager.alert("提示","-777：当前无删除权限，请启用删除权限后再删除记录!",'info');
					    return;
					}else {
						$.messager.alert("提示","删除失败!",'info');
						return;
					}
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridBactAntiInt.reload() ;//刷新当前页
				}
			} 
		});
	}
	
	//单击选中事件
	obj.gridBactAntiInt_onSelect = function (){
		var rowData = obj.gridBactAntiInt.getSelected();
	
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			
			obj.gridBactAntiInt.clearSelections();  //清除选中行
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}	
	
    //双击弹出编辑事件
	obj.gridBactAntiInt_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	
	//窗口初始化
	obj.InitDialog = function(rd){
		if(rd){
			obj.RecRowID = rd["ID"];
			var BactDesc = rd["BactDesc"];
			var BactDr = rd["BactDr"];
			var AntDesc = rd["AntDesc"];
			var AntDr = rd["AntDr"];
			var IsActive = rd["IsActive"];
			var Note = rd["Note"];			
	
			$('#cboBact').lookup('setText',BactDesc);
			obj.BacteriaID =BactDr;
			$('#cboAnti').lookup('setText',AntDesc);
			obj.AntibioticID=AntDr;
			$('#chkIsActive').checkbox('setValue',(IsActive=='1' ? true : false));
			$('#txtNote').val(Note);
		}else{
			obj.RecRowID = "";	
			$('#cboBact').lookup('setText','');
			obj.BacteriaID ='';
			$('#cboAnti').lookup('setText','');
			obj.AntibioticID='';
			$('#chkIsActive').checkbox('setValue', false);
			$('#txtNote').val('');
		}
		$('#BactAntiIntEdit').show();
		obj.BactAntiIntEdit();
	}
}