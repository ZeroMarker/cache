//页面Event
function InitWinEvent(obj){
	obj.RecRowID="",obj.ItemID=""
	$('#winIMPKeyword').dialog({
		title: '重点患者关键词维护',
		iconCls:"icon-w-edit",
		closed: true,
		modal: true,
		isTopZindex:true
		
	});	
	
	// 检查删除按钮是否允许删除，若否则隐藏该按钮
	if(!chkDelBtnIsAble("DHCMA.IMP.BT.IMPCateKeys")){
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
			var rd=obj.gridIMPKeyword.getSelected()
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
	     	$HUI.dialog('#winIMPKeyword').close();
     	});
     	
     }
    $('#ItemKey').searchbox({
	    searcher:function(value,name){
	    	obj.gridIMPKeyword.load({
					ClassName:"DHCMA.IMP.BTS.IMPKeywordSrv",
					QueryName:"QryKeyWord",
					aCategoryID:obj.ParrefID,
					aKey:value		
					});
	    },
	    prompt:'请输入关键词代码/关键词描述'
	});	
	obj.gridIMPCategory_onSelect = function (rd){
		if (rd["BTID"] == obj.ParrefID) {
			obj.ParrefID="";
			obj.IMPKeywordID="";
			obj.gridIMPCategory.clearSelections();
			obj.gridIMPKeyword.loadData([]);
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		} else {	
			obj.ParrefID=rd["BTID"]
			obj.gridIMPKeyword.load({
				    ClassName:"DHCMA.IMP.BTS.IMPKeywordSrv",
					QueryName:"QryKeyWord"	,
					aCategoryID:obj.ParrefID	
			}
			) ;
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$('#ItemKey').searchbox('setValue','');
		}
	}
	obj.gridIMPKeyword_onDbselect= function (rd){
		obj.layer(rd);
	}
	obj.gridIMPKeyword_onSelect= function (rd){
		if(rd["BTID"] ==obj.IMPKeywordID){
			obj.IMPKeywordID="";
			obj.gridIMPKeyword.clearSelections();
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}else{
			obj.IMPKeywordID=rd["BTID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	//保存分类
	obj.btnSave_click = function(flg){
		var errinfo = "";
		var Keyword = $('#BTKeyword').combobox('getValue');
		var IsActive = $('#IsActive').checkbox('getValue');
		debugger;
		IsActive = (IsActive==true? 1: 0);
		if (!Keyword) {
			errinfo = errinfo + "重点患者关键词为空!<br>";
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
		
		inputStr = inputStr + CHR_1 + ChildSub;
		inputStr = inputStr + CHR_1 + Keyword;
		inputStr = inputStr + CHR_1 + IsActive;
		
		var flg = $m({
			ClassName:"DHCMA.IMP.BT.IMPCateKeys",
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
			obj.IMPKeywordID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$HUI.dialog('#winIMPKeyword').close();
			obj.gridIMPKeyword.reload() ;//刷新当前页
		}
	}
	//删除分类 
	obj.btnDelete_click = function(){
		var rowData = obj.gridIMPKeyword.getSelected();
		var rowID=rowData["BTID"]
		if (rowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.IMP.BT.IMPCateKeys",
					MethodName:"DeleteById",
					aId:rowID
				},false);
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');	
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					
					obj.gridIMPKeyword.reload() ;//刷新当前页	
				}
			} 
		});
	}
	
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID = rd["BTID"];
			$('#BTKeyword').combobox('setValue', rd["KeywordDr"]);	
			$("#IsActive").checkbox('setValue',rd["BTIsActive"]=="是"?true:false)
		}else{
			obj.RecRowID="";
			$("#BTKeyword").combobox('setValue','');
			$("#IsActive").checkbox('uncheck');
		}
		$HUI.dialog('#winIMPKeyword').open();
	}

}
