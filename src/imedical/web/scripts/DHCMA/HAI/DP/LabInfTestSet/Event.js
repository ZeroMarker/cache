//页面Event
function InitLabInfTestSetWinEvent(obj){
	//检索框
	$('#searchBox').searchbox({ 
		searcher:function(value,name){
			obj.gridLabInfTestSet.load({
				ClassName : "DHCHAI.DPS.LabInfTestSetSrv",
				QueryName : "QryByType",
				aType: "",
				aAlias:$.trim(value)
			})
		}	
	});
	$('#searchBox_two').searchbox({ 
		searcher:function(value,name){
			obj.gridLabInfTestSetExt.load({
				ClassName : "DHCHAI.DPS.LabInfTestSetSrv",
				QueryName : "QryTestSetExt",
				aTestSetID:obj.RecRowID,
				aAlias:$.trim(value)
			})
		}	
	});
	//事件初始化
	obj.LoadEvent = function(args){
		//检验医嘱定义
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		$('#btnEdit').on('click', function(){
			var rd=obj.gridLabInfTestSet.getSelected();
			obj.InitDialog(rd);
		});
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		
		$('#winBtnAdd').on('click', function(){
			obj.btnAdd_click();
		});
		$('#winBtnSave').on('click', function(){
			obj.btnSave_click();
		});
		$('#winBtnClose').on('click', function(){
			$HUI.dialog('#winEdit').close();
		});
		// 语义词
		$('#btnAdd_two').on('click', function(){
			obj.InitDialog_two();
		});
		$('#btnEdit_two').on('click', function(){
			var rd=obj.gridLabInfTestSetExt.getSelected()
			obj.InitDialog_two(rd);
		});
		$('#btnDelete_two').on('click', function(){
			obj.btnDelete_two_click();
		});
		
		$('#winBtnAdd_two').on('click', function(){
			obj.btnAdd_two_click();
		});
		$('#winBtnSave_two').on('click', function(){
			obj.btnSave_two_click();
		});
		$('#winBtnClose_two').on('click', function(){
			$HUI.dialog('#winEdit_two').close();
		});
     }
	 // *********************归一词Event*************************
	//双击编辑
	obj.gridLabInfTestSet_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//检验医嘱定义选择
	obj.gridLabInfTestSet_onSelect = function (){
		var rowData = obj.gridLabInfTestSet.getSelected();

		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridLabInfTestSet.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
		obj.gridLabInfTestSetExt.load({
			ClassName : "DHCHAI.DPS.LabInfTestSetSrv",
			QueryName : "QryTestSetExt",
			aTestSetID: obj.RecRowID
		})
	}
	//新增
	obj.btnAdd_click=function(){
		obj.RecRowID=""
		var flg=obj.Save();
		
		if(flg == '-99'){
			return;
		}
		
		if (parseInt(flg)> 0) {
			obj.gridLabInfTestSet.reload();	//刷新当前页
			$.messager.popover({msg: '新增成功！',type:'success',timeout: 1000});
		}else if(parseInt(flg) == '-2'){
			$.messager.alert("错误提示", "代码重复!" , 'info');
		}else{
			$.messager.alert("错误提示", "新增失败!Error=" + flg, 'info');
		}
	}
	//修改
	obj.btnSave_click=function(){
		var flg=obj.Save();
		if(flg == '-99'){
			return;
		}
		if (parseInt(flg)> 0) {
			obj.RecRowID = flg;
			obj.gridLabInfTestSet.reload();		//刷新当前页
			$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});
		}else if(parseInt(flg) == '-2'){
			$.messager.alert("错误提示", "代码重复!" , 'info');
		}else{
			$.messager.alert("错误提示", "修改失败!Error=" + flg, 'info');
		}
	}
	//核心方法-检验医嘱定义更新
	obj.Save = function(){
		var errinfo="";
		var Code      = $("#txtCode").val();
		var Desc      = $("#txtDesc").val();   		                                                                            
	    var TypeCode  = $("#cboType").combobox("getValue");
		var IsActive  = $("#chkActive").checkbox('getValue')? '1':'0';
		if (!TypeCode) {
			errinfo = errinfo + "业务类型不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return "-99";
		}
		var InputStr = obj.RecRowID;
		InputStr += "^" + Code;  
		InputStr += "^" + Desc; 
		InputStr += "^" + TypeCode;
		InputStr += "^" + IsActive; 
		
		var flg = $m({
			ClassName:"DHCHAI.DP.LabInfTestSet",
			MethodName:"Update",
			aInputStr:InputStr
		},false);
		return flg
	}
	//核心方法-检验医嘱定义删除
	obj.btnDelete_click = function(){
		if (obj.RecRowID==""){
			$.messager.alert("提示", "请选中数据,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "确认是否删除?", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.DP.LabInfTestSet",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);
				
				if (flg == '0') {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridLabInfTestSet.reload(); //刷新当前页
					obj.gridLabInfTestSetExt.load({
						ClassName : "DHCHAI.DPS.LabInfTestSetSrv",
						QueryName : "QryTestSetExt",
						aTestSetID: obj.RecRowID
					})
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
			
			$('#txtCode').val(rd["Code"]);
			$('#txtDesc').val(rd["Desc"]);
			$('#cboType').combobox('setValue',rd["LabTypeCode"]);
			$('#cboType').combobox('setText',rd["LabType"]);
			$('#chkActive').checkbox('setValue',rd["IsActive"]== 1);
			
			$("#winBtnSave").show();
			$("#winBtnAdd").hide();
			
			obj.RecRowID=rd["ID"];
		}else{
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#cboType').combobox('setValue','');
			$('#chkActive').checkbox('setValue',true);
			
			$("#winBtnSave").hide();
			$("#winBtnAdd").show();
			
			obj.RecRowID = "";
		}
		
		$('#winEdit').show();
		$('#winEdit').dialog({
			title: '检验医嘱定义编辑',
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:true
		});
	}
	//**********************语义词Event****************************
	obj.gridLabInfTestSetExt_onSelect=function(){
		var rowData = obj.gridLabInfTestSetExt.getSelected();

		if (rowData["ID"] == obj.RecRowID_two) {
			obj.RecRowID_two="";
			$("#btnAdd_two").linkbutton("enable");
			$("#btnEdit_two").linkbutton("disable");
			$("#btnDelete_two").linkbutton("disable");
			obj.gridLabInfTestSetExt.clearSelections();
		} else {
			obj.RecRowID_two = rowData["ID"];
			$("#btnAdd_two").linkbutton("disable");
			$("#btnEdit_two").linkbutton("enable");
			$("#btnDelete_two").linkbutton("enable");
		}	
	}
	obj.gridLabInfTestSetExt_onDbselect = function(rd){
		obj.InitDialog_two(rd);
	}
	  //窗体-初始化
	obj.InitDialog_two= function(rd){
		if(rd){
			$('#txtExtCode').val(rd["ExtCode"]);
			$("#winBtnSave_two").show();
			$("#winBtnAdd_two").hide();
			
			obj.RecRowID_two=rd["ID"];
		}else{
			$('#txtExtCode').val('');
			$("#winBtnSave_two").hide();
			$("#winBtnAdd_two").show();
			
			obj.RecRowID_two = "";
		}
		
		$('#winEdit_two').show();
		$('#winEdit_two').dialog({
			title: '检验外部码编辑',
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:true
		});
	}
	obj.btnAdd_two_click=function(){
		if (obj.RecRowID==""){
			return;
		}
		obj.RecRowID_two=""
		var flg=obj.Save_two();
		
		if(flg == '-99'){
			return;
		}
		
		if (parseInt(flg)> 0) {
			obj.gridLabInfTestSetExt.reload();	//刷新当前页
			$.messager.popover({msg: '新增成功！',type:'success',timeout: 1000});
		}else if(parseInt(flg) == '-2'){
			$.messager.alert("错误提示", "外部码重复!" , 'info');
		}else{
			$.messager.alert("错误提示", "新增失败!Error=" + flg, 'info');
		}
	}

	obj.btnSave_two_click=function(){
		if (obj.RecRowID==""){
			return;
		}
		var flg=obj.Save_two();
		if(flg == '-99'){
			return;
		}
		if (parseInt(flg)> 0) {
			obj.RecRowID_two = flg;
			obj.gridLabInfTestSetExt.reload();		//刷新当前页
			$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});
		}else if(parseInt(flg) == '-2'){
			$.messager.alert("错误提示", "外部码重复!" , 'info');
		}else{
			$.messager.alert("错误提示", "修改失败!Error=" + flg, 'info');
		}
	}
	//核心方法-更新
	obj.Save_two = function(){
		var errinfo="";
		var TestDr = obj.RecRowID; // 归一词ID
       
		var txtExtCode = $('#txtExtCode').val();
		
		if (!txtExtCode) {
			errinfo = errinfo + "检验外部码不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return '-99';
		}
		var subDr="";
		if (obj.RecRowID_two!=""){
			subDr=obj.RecRowID_two.split("||")[1];
		}
		var InputStr = TestDr;
		InputStr += "^" + subDr;
		InputStr += "^" + txtExtCode;
		InputStr += "^" + ''; 
		InputStr += "^" + '';
		InputStr += "^" + "||"+$.LOGON.USERDESC;
		
		var flg = $m({
			ClassName:"DHCHAI.DP.LabInfTestSetExt",
			MethodName:"Update",
			aInputStr:InputStr
		},false);
		return flg
	}
	obj.btnDelete_two_click = function(){
		if (obj.RecRowID==""){
			return;
		}
		if (obj.RecRowID_two==""){
			$.messager.alert("提示", "请选中数据,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "确认是否删除?", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.DP.LabInfTestSetExt",
					MethodName:"DeleteById",
					aId:obj.RecRowID_two
				},false);
				
				if (flg == '0') {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID_two = "";
					obj.gridLabInfTestSetExt.reload(); //刷新当前页
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
}