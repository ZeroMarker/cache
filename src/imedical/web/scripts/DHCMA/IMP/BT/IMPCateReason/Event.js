//页面Event
function InitWinEvent(obj){
	obj.RecRowID="",obj.ItemID=""
	$('#winIMPReason').dialog({
		title: '重点患者特因维护',
		iconCls:"icon-w-edit",
		closed: true,
		modal: true,
		isTopZindex:true
		
	});	
	// 检查删除按钮是否允许删除，若否则隐藏该按钮
	if(!chkDelBtnIsAble("DHCMA.IMP.BT.IMPCateReson")){
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
			var rd=obj.gridIMPReason.getSelected()
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
	     	$HUI.dialog('#winIMPReason').close();
     	});
     	
     }
    $('#ItemKey').searchbox({
	    searcher:function(value,name){
	    	obj.gridIMPReason.load({
					ClassName:"DHCMA.IMP.BTS.IMPCateReasonSrv",
					QueryName:"QryIMPCateReason",
					aParRef:obj.ParrefID,
					aKey:value		
					});
	    },
	    prompt:'请输入特因代码/特因描述'
	});	
	obj.gridIMPCategory_onSelect = function (rd){
		if (rd["BTID"] == obj.ParrefID) {
			obj.ParrefID=""
			obj.ReasonID="";
			obj.gridIMPCategory.clearSelections();
			obj.gridIMPReason.loadData([]);
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			
		} else {	
			obj.ParrefID=rd["BTID"]
			debugger;
			obj.gridIMPReason.load({
				    ClassName:"DHCMA.IMP.BTS.IMPCateReasonSrv",
					QueryName:"QryIMPCateReason"	,
					aParRef:obj.ParrefID	
			}
			) ;
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$('#ItemKey').searchbox('setValue','');
		}
	}
	obj.gridIMPReason_onDbselect= function (rd){
		obj.layer(rd);
	}
	obj.gridIMPReason_onSelect= function (rd){
		if(rd['BTID']==obj.ReasonID){
			obj.ReasonID="";
			obj.gridIMPReason.clearSelections();
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}else{
			obj.ReasonID=rd['BTID'];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	//保存分类
	obj.btnSave_click = function(flg){
		var errinfo = "";
		var Reason = $('#BTReason').combobox('getValue');
		var IsActive = $('#IsActive').checkbox('getValue');
		debugger;
		IsActive = (IsActive==true? 1: 0);
		if (!Reason) {
			errinfo = errinfo + "重点患者特因为空!<br>";
		}	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var inputStr=obj.ParrefID
		if (obj.RecRowID == ""){
			var ChildSub = ""
		}else{
			var arr = obj.RecRowID.split('||')
			var ChildSub = arr[1]
		}
		if (obj.ParrefID=="") {
			$.messager.alert("错误提示", "重点患者分类ID为空，请先选择重点患者分类！", 'info');
			return;
		}
		
		inputStr = inputStr + "^" + ChildSub;
		inputStr = inputStr + "^" + Reason;
		inputStr = inputStr + "^" + IsActive;
		
		var flg = $m({
			ClassName:"DHCMA.IMP.BT.IMPCateReason",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			obj.ReasonID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			$HUI.dialog('#winIMPReason').close();
			obj.gridIMPReason.reload() ;//刷新当前页
		}
	}
	//删除分类 
	obj.btnDelete_click = function(){
		var rowData = obj.gridIMPReason.getSelected();
		var rowID=rowData["BTID"]
		if (rowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.IMP.BT.IMPCateReason",
					MethodName:"DeleteById",
					aId:rowID
				},false);
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');	
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					
					obj.gridIMPReason.reload() ;//刷新当前页	
				}
			} 
		});
	}
	
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID = rd["BTID"];
			$('#BTReason').combobox('setValue', rd["ID"]);	
			$("#IsActive").checkbox('setValue',rd["BTIsActive"]=="是"?true:false)
		}else{
			obj.RecRowID="";
			$("#BTReason").combobox('setValue','');
			$("#IsActive").checkbox('uncheck');
		}
		$HUI.dialog('#winIMPReason').open();
	}

}
