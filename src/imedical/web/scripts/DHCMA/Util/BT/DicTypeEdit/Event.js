//页面Event
function InitDicTypeListWinEvent(obj){	
	
	//按钮初始化
	$('#winDicTypeEdit').dialog({
		title: '字典类型维护',
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
		//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#winDicTypeEdit').close();
     	});
		//添加
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd=obj.gridDicType.getSelected()
			obj.layer(rd);	
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		}); 
     }
    //双击编辑事件
	obj.gridDicType_onDbselect = function(rd){
		obj.layer(rd);
	}
	//选择
	obj.gridDicType_onSelect = function (){
		var rowData = obj.gridDicType.getSelected();
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID="";
		if (rowData["BTID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			
			obj.gridDicType.clearSelections();
		}
		else {
			obj.RecRowID = rowData["BTID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}	
	//保存分类
	obj.btnSave_click = function(){
		var errinfo = "";
		var Code = $('#txtCode').val();
		var Desc = $('#txtDesc').val();
		var ProductID =$('#cboTypeDr').combobox('getValue');
		Code=$.trim(Code)
		Desc=$.trim(Desc)
		
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}	
		if (!ProductID){
			errinfo = errinfo + "所属产品为空!<br>";
		}
		var IsCheck = $m({
			ClassName:"DHCMA.Util.BTS.DicTypeSrv",
			MethodName:"CheckPTCode",
			aCode:Code,
			aID:obj.RecRowID
		},false);
	  	if(IsCheck>=1) {
	  		errinfo = errinfo + "代码与列表中现有项目重复，请检查修改!<br>";
	  	}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;	
		inputStr = inputStr + CHR_1 + ProductID;
		var flg = $m({
			ClassName:"DHCMA.Util.BT.DicType",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:CHR_1
		},false);
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
			$HUI.dialog('#winDicTypeEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID = flg
			obj.gridDicType.reload() ;//刷新当前页
		}
	}
	//删除分类 
	obj.btnDelete_click = function(){
		if (obj.RecRowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.Util.BT.DicType",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridDicType.reload() ;//刷新当前页
				}
			} 
		});
	}
    //配置窗体-初始化
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID = rd["BTID"];
			var Code = rd["BTCode"];
			var Desc = rd["BTDesc"];
			var BTTypeID = rd["BTTypeID"];
			
			$('#txtCode').val(Code);
			$('#txtDesc').val(Desc);
			$('#cboTypeDr').combobox('setValue',BTTypeID);
		}else{
			obj.RecRowID = "";
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#cboTypeDr').combobox('setValue','');
			
			var cbolist = $('#cboTypeDr').combobox("getData");
			for (var itemIndex in cbolist) {
				var item = cbolist[itemIndex];
				if (item.ProCode == ProductCode) {
					$('#cboTypeDr').combobox("select", item.ProID);
				}
			}
		}
		$HUI.dialog('#winDicTypeEdit').open();
	}
	
}
