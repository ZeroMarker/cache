//页面Event
function InitThemeWordsEvent(obj){
	//事件初始化
	obj.LoadEvent = function(args){
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		$('#btnEdit').on('click', function(){
			var rd=obj.gridThemeWords.getSelected()
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
	obj.gridThemeWords_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//选择
	obj.gridThemeWords_onSelect = function (){
		var rowData = obj.gridThemeWords.getSelected();

		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridThemeWords.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	
	//核心方法-更新
	obj.Save = function(){
		
		var errinfo = "";
		                                                                
		var ThemeTypeDr = $("#cboThemeType").combobox("getValue");
		var KeyWord     = $("#txtKeyWord").val(); 
		var WordTypeDr  = $("#cboWordType").combobox("getValue");    		                                                                            
		var LimitWords  = $("#txtLimitWord").val();
		var Context     = $("#txtContext").val(); 
		var IsActive    = $("#chkActive").checkbox('getValue')? '1':'0';
		var WordAttr    = $("#cboWordAttr").combobox("getValue");
		
		if (!ThemeTypeDr) {
			errinfo = errinfo + "主题类型不允许为空!<br>";
		}
	
		if (!KeyWord) {
			errinfo = errinfo + "主题关键词不允许为空!<br>";
		}
		if (!WordTypeDr) {
			errinfo = errinfo + "词组分类不允许为空!<br>";
		}
		if (!Context) {
			errinfo = errinfo + "主题词语境不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return "-99";
		}
		
		var InputStr = obj.RecRowID;
		InputStr += "^" + ThemeTypeDr; // 主题类型DR
		InputStr += "^" + KeyWord;     // 主题关键词
		InputStr += "^" + LimitWords;  // 关联属性
		InputStr += "^" + WordTypeDr;  // 关键词分类DR
		InputStr += "^" + Context;     // 主题词语境
		InputStr += "^" + IsActive;    // 是否有效
		InputStr += "^" + "";          // 处置日期
		InputStr += "^" + "";          // 处置时间
		InputStr += "^" + $.LOGON.USERDESC; // 处置人姓名
		InputStr += "^" + WordAttr;
		
		var flg = $m({
			ClassName:"DHCHAI.RME.ThemeWords",
			MethodName:"Update",
			aInputStr:InputStr
		},false);
		if (parseInt(flg)> 0) {
			obj.RecRowID="";
			obj.gridThemeWords.reload() ;//刷新当前页
			$HUI.dialog('#winEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		}else if(parseInt(flg) == '-100'){
			$.messager.alert("错误提示", "关键词+关联属性必须唯一!!" , 'info');
		}else{
			$.messager.alert("错误提示", "保存失败!Error=" + flg, 'info');
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
					ClassName:"DHCHAI.RME.ThemeWords",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);
				
				if (flg == '0') {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridThemeWords.reload(); //刷新当前页
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
			$('#cboThemeType').combobox('setValue',rd["ThemeTypeDr"]);
			$('#txtKeyWord').val(rd["KeyWord"]);
			$('#cboWordType').combobox('setValue',rd["WordTypeDr"]);
			$('#txtLimitWord').val(rd["LimitWord"]);
			$('#txtContext').val(rd["Context"]);
			$('#chkActive').checkbox('setValue',rd["IsActive"]== 1);
			$("#cboWordAttr").combobox("setValue",rd["WordAttr"])
	 
			obj.RecRowID=rd["ID"];
		}else{
			$('#cboThemeType').combobox('setValue','');
			$('#txtKeyWord').val('');
			$('#cboWordType').combobox('setValue','');
			$('#txtLimitWord').val('');
			$('#txtContext').val('');
			$('#chkActive').checkbox('setValue',false);
			$("#cboWordAttr").combobox('clear');
			obj.RecRowID = "";
		}
		
		$('#winEdit').show();
		$('#winEdit').dialog({
			title: '主题词库编辑',
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:true
		});
	}
	
}