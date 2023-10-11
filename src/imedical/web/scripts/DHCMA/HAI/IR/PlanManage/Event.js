//页面Event
function InitWinEvent(obj){
	//事件初始化
	obj.LoadEvent = function(args){
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		$('#btnEdit').on('click', function(){
			var rd=obj.gridPlanManage.getSelected()
			obj.InitDialog(rd);
		});
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		
		$('#winBtnEdit').on('click', function(){
			obj.Save();
		});
		$('#winBtnClose').on('click', function(){
			$HUI.dialog('#winEdit').close();
		});
     }
    //双击编辑
	obj.gridPlanManage_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//选择
	obj.gridPlanManage_onSelect = function (){
		var rowData = obj.gridPlanManage.getSelected();

		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridPlanManage.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}

	//核心方法-更新
	obj.Save = function(ID){
		
		var errinfo = "";
		
		var PlanName = $('#txtPlanName').val();
		var PlanTypeDr = $('#cboPlanType').combobox("getValue");
		var Keys = $('#txtKeys').val();
		var Content = $("#txtContent").val().replace(/\n/g,"&hc");
		var chkActive = $("#chkActive").checkbox('getValue');
		chkActive = (chkActive==true? 1 : 0);
	
		if (!PlanName) {
			errinfo = errinfo + "预案名不允许为空!<br>";
		}
		if (!PlanTypeDr) {
			errinfo = errinfo + "预案类型不允许为空!<br>";
		}
		Keys = Keys.replace(/\ +/g,"");        // 去除空格
		Keys = Keys.replace(/[\r\n]/g,"");     // 去除换行符
		if (!Keys) {
			errinfo = errinfo + "关键词不允许为空!<br>";
		}
		Content = Content.replace(/\ +/g,"");    // 去除空格
		//Content = Content.replace(/[\r\n]/g,""); // 去除换行符
		if (!Content) {
			errinfo = errinfo + "内容不允许为空!<br>";
		}
		if (errinfo) {
			
			$.messager.alert("错误提示", errinfo, 'info');
			return ;
		}
		var InputStr = obj.RecRowID;
		InputStr += "^" + PlanName;
		InputStr += "^" + PlanTypeDr;
		InputStr += "^" + Keys;
		InputStr += "^" + Content;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + $.LOGON.USERID;
		InputStr += "^" + chkActive;
		
		var flg = $m({
			ClassName:"DHCHAI.IR.PlanManage",
			MethodName:"Update",
			aInputStr:InputStr
		},false);
		if (parseInt(flg)> 0) {
			obj.RecRowID = "";
			obj.gridPlanManage.reload() ;//刷新当前页
			$HUI.dialog('#winEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		}else if(parseInt(flg) == '-2'){
			$.messager.alert("错误提示", "代码重复!" , 'info');
		}else{
			$.messager.alert("错误提示", "新增失败!Error=" + flg, 'info');
		}
	}
	//核心方法-删除
	obj.btnDelete_click = function(){
		if (obj.RecRowID==""){
			$.messager.alert("提示", "请选中数据,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "确认是否删除?", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.PlanManage",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);
				
				if (flg == '0') {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridPlanManage.reload() ;//刷新当前页
					
				} else {
					if (parseInt(flg)=='-777') {
						$.messager.alert("提示","-777：当前无删除权限，请启用删除权限后再删除记录!",'info');
					}else {
						$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					}
				}
			} 
		});
	}

    //窗体-初始化
	obj.InitDialog= function(rd){
		if(rd){	
			$('#txtPlanName').val(rd["IRPlanName"]).validatebox("validate");
			$('#txtKeys').val(rd["IRKeys"]).validatebox("validate");
			$('#txtContent').val(rd["IRContent"].replace(/&hc/g,"\n")).validatebox("validate");
			$('#cboPlanType').combobox('setValue',rd["PlanTypeDr"]).validatebox("validate");
			$('#cboPlanType').combobox('setText',rd["PlanTypeDesc"]);
			$('#chkActive').checkbox('setValue',(rd["IRIsActive"]=='1' ? true : false));
			
			obj.RecRowID=rd["ID"];
		}else{
			$('#txtPlanName').val('').validatebox("validate");
			$('#txtKeys').val('').validatebox("validate");
			$('#txtContent').val('').validatebox("validate");
			$('#cboPlanType').combobox('setValue','').validatebox("validate");
			$('#chkActive').checkbox('setValue',"");

			obj.RecRowID = "";
		}
		$('#winEdit').show();
		$('#winEdit').dialog({
			title: 'SOP预案编辑',
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:true,
		});
		
	}
}
