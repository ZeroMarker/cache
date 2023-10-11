//页面Event
function InitviewScreenEvent(obj){	
	
	// 检查删除按钮是否允许删除，若否则隐藏该按钮
	if(!chkDelBtnIsAble("DHCMA.IMP.BT.IMPReasonDic")){
		$("#btnDelete").hide();	
	}else{
		$("#btnDelete").show();	
	}
	//按钮初始化
	$('#winProEdit').dialog({
		title: '重点患者特因字典维护',
		iconCls:'icon-w-paper',
		closed: true,
		modal: true,
		isTopZindex:false,//true,
		buttons:[{
			text:'保存',
			handler:function(){
				obj.btnSave_click();
				//$HUI.dialog('#winProEdit').close();
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#winProEdit').close();
			}
		}]
	});
	
	obj.LoadEvent = function(args){ 
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
		$('#btnEdit').on('click', function(){
			var rd=obj.gridReasonDic.getSelected();
			obj.layer(rd);
		});
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
     }
    //双击编辑事件
	obj.gridReasonDic_onDbselect = function(rd){
		obj.layer(rd);
	}
	//选择
	obj.gridReasonDic_onSelect = function (){
		var rowData = obj.gridReasonDic.getSelected();
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID="";
		if (rowData["BTID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridReasonDic.clearSelections();
		} else {
			obj.RecRowID = rowData["BTID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	//保存产品定义
	obj.btnSave_click = function(){
		var errinfo = "";
		var Code = $('#txtCode').val();
		var Desc = $('#txtDesc').val();
		var IsActive = $('#IsActive').checkbox('getValue');
		//IsActive = (IsActive==true? 1: 0);
		if (!Code) {
			errinfo = errinfo + "特因代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "特因描述为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info',function(fn){
				
				//obj.layer();
				$('#txtCode').val(Code);
				$('#txtDesc').val(Desc);
				$('#IsActive').checkbox('setValue',IsActive);
				//$HUI.dialog('#winProEdit').open();
			});
			return;
		}
		IsActive = (IsActive==true? 1: 0);
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + IsActive;
		
		var flg = $m({
			ClassName:"DHCMA.IMP.BT.IMPReasonDic",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:CHR_1
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
			} else if(parseInt(flg) == -2){
				$.messager.alert("错误提示", "数据重复!" , 'info');
			}else{
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#winProEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID = flg;
			obj.gridReasonDic.reload() ;//刷新当前页
		}
	}
	//删除产品定义
	obj.btnDelete_click = function(){
		if (obj.RecRowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		
		$.messager.confirm("删除", "删除后对应所有病种数据清空，确定删除？", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.IMP.BT.IMPReasonDic",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);
				if(flg=0){alert("删除成功啦")}
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridReasonDic.reload() ;//刷新当前页
				}
			} 
		});
	}
    //配置窗体-初始化
	obj.layer= function(rd){

		if(rd){
			obj.RecRowID=rd["BTID"];
			var Code = rd["ReasCode"];
			var Desc = rd["ReasDesc"];
			var IsActive = rd["BTIsActive"];
			IsActive = (IsActive=='是'? true: false);
			$('#txtCode').val(Code);
			$('#txtDesc').val(Desc);
			$('#IsActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID = "";
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#IsActive').checkbox('setValue',false);
		}
		$HUI.dialog('#winProEdit').open();
	}
}
