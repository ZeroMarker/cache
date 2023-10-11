//页面Event
function InitviewScreenEvent(obj){	
	
	//按钮初始化
	$('#winProEdit').dialog({
		title: '重点患者分类维护',
		iconCls:'icon-w-paper',
		closed: true,
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
				$HUI.dialog('#winProEdit').close();
			}
		}]
	});
	// 检查删除按钮是否允许删除，若否则隐藏该按钮
	if(!chkDelBtnIsAble("DHCMA.IMP.BT.IMPCategory")){
		$("#btnDelete").hide();	
	}else{
		$("#btnDelete").show();	
	}
	obj.LoadEvent = function(args){ 
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
		$('#btnEdit').on('click', function(){
			var rd=obj.gridCategory.getSelected();
			obj.layer(rd);
		});
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
     }
    //双击编辑事件
	obj.gridCategory_onDbselect = function(rd){
		obj.layer(rd);
	}
	//选择
	obj.gridCategory_onSelect = function (){
		var rowData = obj.gridCategory.getSelected();
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID="";
		if (rowData["BTID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridCategory.clearSelections();
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
		var Flag = $('#txtFlag').val();
		var IsActive = $('#IsActive').checkbox('getValue');
		var IsEnd = $('#IsEnd').checkbox('getValue');
		var IsOper = $('#IsOper').checkbox('getValue');
		var IsManMark = $('#IsManMark').checkbox('getValue');
		var IsReMark = $('#IsReMark').checkbox('getValue');
		//IsActive = (IsActive==true? 1: 0);
		if (!Code) {
			errinfo = errinfo + "重点患者分类代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "重点患者分类描述为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info',function(fn){
				
				//obj.layer();
				$('#txtCode').val(Code);
				$('#txtDesc').val(Desc);
				$('#txtFlag').val(Flag);
				$('#IsActive').checkbox('setValue',IsActive);
				//$HUI.dialog('#winProEdit').open();
			});
			return;
		}
		IsActive = (IsActive==true? 1: 0);
		IsEnd 	 = (IsEnd==true? 1: 0);
		IsOper   = (IsOper==true? 1: 0);
		IsManMark= (IsManMark==true? 1: 0);
		IsReMark = (IsReMark==true? 1: 0);
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + Flag;
		inputStr = inputStr + CHR_1 + IsActive;
		inputStr = inputStr + CHR_1 + IsEnd;
		inputStr = inputStr + CHR_1 + IsOper;
		inputStr = inputStr + CHR_1 + IsManMark;
		inputStr = inputStr + CHR_1 + IsReMark;
		debugger;
		var flg = $m({
			ClassName:"DHCMA.IMP.BT.IMPCategory",
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
			obj.gridCategory.reload() ;//刷新当前页
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
					ClassName:"DHCMA.IMP.BT.IMPCategory",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);
				if(flg=0){alert("删除成功啦")}
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridCategory.reload() ;//刷新当前页
				}
			} 
		});
	}
    //配置窗体-初始化
	obj.layer= function(rd){

		if(rd){
			obj.RecRowID=rd["BTID"];
			var Code = rd["CateCode"];
			var Desc = rd["CateDesc"];
			var Flag = rd["CateFlag"];
			var IsActive = rd["BTIsActive"];
			IsActive = (IsActive=='是'? true: false);
			var IsEnd = rd["BTIsEnd"];
			IsEnd = (IsEnd=='是'? true: false);
			var IsOper = rd["BTIsOper"];
			IsOper = (IsOper=='是'? true: false);
			var IsManMark = rd["BTIsManMark"];
			IsManMark = (IsManMark=='是'? true: false);
			var IsReMark = rd["BTIsReMark"];
			IsReMark = (IsReMark=='是'? true: false);
			$('#txtCode').val(Code);
			$('#txtDesc').val(Desc);
			$('#txtFlag').val(Flag);
			$('#IsActive').checkbox('setValue',IsActive);
			$('#IsEnd').checkbox('setValue',IsEnd);
			$('#IsOper').checkbox('setValue',IsOper);
			$('#IsManMark').checkbox('setValue',IsManMark);
			$('#IsReMark').checkbox('setValue',IsReMark);
		}else{
			obj.RecRowID = "";
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#txtFlag').val('');
			$('#IsActive').checkbox('setValue',false);
			$('#IsEnd').checkbox('setValue',false);
			$('#IsOper').checkbox('setValue',false);
			$('#IsManMark').checkbox('setValue',false);
			$('#IsReMark').checkbox('setValue',false);
		}
		$HUI.dialog('#winProEdit').open();
	}
}
