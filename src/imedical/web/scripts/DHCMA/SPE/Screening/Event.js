//页面Event
function InitviewScreenEvent(obj){	
	
	//按钮初始化
	$('#winProScreening').dialog({
		title: '重点病人筛查条件维护',
		iconCls:'icon-w-paper',
		closed: true,
		modal: true,
		isTopZindex:false,//true,
		buttons:[{
			text:'保存',
			handler:function(){
				obj.btnSave_click();
				$HUI.dialog('#winProScreening').close();
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#winProScreening').close();
			}
		}]
	});
	
	obj.LoadEvent = function(args){ 
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
		$('#btnEdit').on('click', function(){
			var rd=obj.gridScreening.getSelected();
			obj.layer(rd);
		});
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
     }
    //双击编辑事件
	obj.gridScreening_onDbselect = function(rd){
		obj.layer(rd);
	}
	//选择
	obj.gridScreening_onSelect = function (){
		var rowData = obj.gridScreening.getSelected();
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID="";
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridScreening.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
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
		var PatTypeDr = $('#txtPatType').combobox('getValue');
		var PatSubTypeDr = $('#txtPatSubType').combobox('getValue');
		var IsActive = $('#IsActive').checkbox('getValue');
		//IsActive = (IsActive==true? 1: 0);
		
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}
		if (!PatTypeDr) {
			errinfo = errinfo + "特殊患者分类为空!<br>";
		}
		if (!PatSubTypeDr) {
			errinfo = errinfo + "特殊患者子分类为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		IsActive = (IsActive==true? 1: 0);
		var PatType = PatTypeDr+"||"+PatSubTypeDr;
		var date = new Date();
		var ActDate = Common_GetDate(date);
		var ActTime = Common_GetTime(date);
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + PatType;
		inputStr = inputStr + CHR_1 + IsActive;
		inputStr = inputStr + CHR_1 + ActDate;
		inputStr = inputStr + CHR_1 + ActTime;
		inputStr = inputStr + CHR_1 + LogonUserID;
		var flg = $m({
			ClassName:"DHCMed.SPE.Screening",
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
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID = flg;
			obj.gridScreening.reload() ;//刷新当前页
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
					ClassName:"DHCMed.SPE.Screening",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);
				if(flg=0){alert("删除成功啦")}
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridScreening.reload() ;//刷新当前页
				}
			} 
		});
	}
    //配置窗体-初始化
	obj.layer= function(rd){

		if(rd){
			obj.RecRowID=rd["ID"];
			var Code = rd["Code"];
			var Desc = rd["Desc"];
			var PatTypeID = rd["PatTypeID"];
			var arr = PatTypeID.split("||");
			var PatTypeDr = arr[0];
			var PatTypeSubDr = arr[1];
			
			
			var TypeCode = rd["PatTypeCode"];
			var PatTypeDesc = rd["PatTypeDesc"];
			var IsActive = rd["ActiveDesc"];
			IsActive = (IsActive=='是'? true: false);
			
			$('#txtCode').val(Code);
			$('#txtDesc').val(Desc);
			$('#IsActive').checkbox('setValue',IsActive);
			debugger;
			$('#txtPatType').combobox('setValue',PatTypeDr);
			$('#txtPatSubType').combobox('setValue',PatTypeSubDr);
			$('#txtPatSubType').combobox('setText',PatTypeDesc);
		}else{
			obj.RecRowID = "";
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#IsActive').checkbox('setValue',false);
			$('#txtPatSubType').combobox('setValue','');
			$('#txtPatType').combobox('setValue','');
		}
		$HUI.dialog('#winProScreening').open();
	}
}
