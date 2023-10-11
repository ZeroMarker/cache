//页面Event
function InitWinEvent(obj){
	obj.RecRowID="",obj.ItemID=""
	$('#winIMPRules').dialog({
		title: '重点患者判断规则维护',
		iconCls:"icon-w-edit",
		closed: true,
		modal: true,
		isTopZindex:true
		
	});	
	// 检查删除按钮是否允许删除，若否则隐藏该按钮
	if(!chkDelBtnIsAble("DHCMA.IMP.BT.IMPCateRule")){
		$("#btnDelete").hide();	
	}else{
		$("#btnDelete").show();	
	}
    obj.LoadEvent = function(args){ 
     	
		//添加
     	$('#btnAdd').on('click', function(){
			obj.layer()
     	});
     	
		//编辑
		$('#btnEdit').on('click', function(){
			var rd=obj.gridIMPRules.getSelected()
			if (rd) {
				obj.layer(rd);
			}
			else {
				$.messager.alert("提示", "请选中行，再行修改！", 'info');
				return;
			}		
     	});
		//删除
		$('#btnDelete').on('click', function(){
	     	obj.btnDelete_click();
     	});
     	
     	//保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#winIMPRules').close();
     	});
     	
     }
    $('#ItemKey').searchbox({
	    searcher:function(value,name){
	    	obj.gridIMPRules.load({
					ClassName:"DHCMA.IMP.BTS.IMPCateRulesSrv",
					QueryName:"QryIMPCateRules",
					aParRef:obj.ParrefID,
					aKey:value		
					});
	    },
	    prompt:'请输入规则代码/规则描述'
	});	
	obj.gridIMPCategory_onSelect = function (rd){
		if (rd["BTID"] == obj.ParrefID) {
			obj.ParrefID=""
			obj.IMPRulesID="";
			obj.gridIMPCategory.clearSelections();
			obj.gridIMPRules.loadData([]);
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			
		} else {	
		debugger;
			obj.ParrefID=rd["BTID"]
			obj.gridIMPRules.load({
				    ClassName:"DHCMA.IMP.BTS.IMPCateRulesSrv",
					QueryName:"QryIMPCateRules"	,
					aParRef:obj.ParrefID	
			}
			) ;
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$('#ItemKey').searchbox('setValue','');
		}
	}
	obj.gridIMPRules_onDbselect= function (rd){
		obj.layer(rd);
	}
	obj.gridIMPRules_onSelect= function (rd){
		if(rd["BTID"] == obj.IMPRulesID){
			obj.IMPRulesID="";
			obj.gridIMPRules.clearSelections();
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}else{
			obj.IMPRulesID=rd["BTID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	//保存分类
	obj.btnSave_click = function(flg){
		var errinfo = "";
		var Code = $('#txtCode').val();
		var Desc = $('#txtDesc').val();
		var Express = $('#txtExpress').val();
		var RuleType = $('#RuleType').combobox('getValue');
		//var LinkedReason = $('#LinkedReason').combobox('getValue');
		var IsActive = $('#IsActive').checkbox('getValue');
		IsActive = (IsActive==true? 1: 0);
		if (!Code) {
			errinfo = errinfo + "规则代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "规则描述为空!<br>";
		}	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var inputStr=obj.ParrefID
		if (obj.RecRowID.indexOf('||') >= 0){
			var arr = obj.RecRowID.split('||')
			var ChildSub = arr[1]
		}else{
			var ChildSub = ""
		}
		if (obj.ParrefID=="") {
			$.messager.alert("错误提示", "重点患者分类ID为空，请先选择重点患者分类！", 'info');
			return;
		}
		debugger;
		inputStr = inputStr + CHR_1 + ChildSub;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + Express;
		inputStr = inputStr + CHR_1 + RuleType;
		//inputStr = inputStr + CHR_1 + LinkedReason;
		inputStr = inputStr + CHR_1 + IsActive;
		
		var flg = $m({
			ClassName:"DHCMA.IMP.BT.IMPCateRules",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:CHR_1
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.IMPRulesID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$HUI.dialog('#winIMPRules').close();
			obj.gridIMPRules.reload() ;//刷新当前页
		}
	}
	//删除分类 
	obj.btnDelete_click = function(){
		var rowData = obj.gridIMPRules.getSelected();
		var rowID=rowData["BTID"]
		if (rowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.IMP.BT.IMPCateRules",
					MethodName:"DeleteById",
					aId:rowID
				},false);
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');	
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					
					obj.gridIMPRules.reload() ;//刷新当前页	
				}
			} 
		});
	}
	
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID = rd["BTID"];
			$('#txtCode').val(rd["RuleCode"]);
			$('#txtDesc').val(rd["RuleDesc"]);
			$('#txtExpress').val(rd["RuleExpress"]);
			$('#RuleType').combobox('setValue', rd["RuleTypeDr"]);
			//$('#LinkedReason').combobox('setValue', rd["LinkedReasonDr"]);
			$("#IsActive").checkbox('setValue',rd["BTIsActive"]=="是"?true:false)
		}else{
			obj.RecRowID="";
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#txtExpress').val('');
			$('#RuleType').combobox('setValue','');
			//$('#LinkedReason').combobox('setValue','');
			$("#IsActive").checkbox('uncheck');
		}
		$HUI.dialog('#winIMPRules').open();
	}

}
