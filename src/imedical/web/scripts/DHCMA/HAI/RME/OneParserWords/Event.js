//页面Event
function InitOneParserWordsWinEvent(obj){
	//检索框
	$('#searchBox').searchbox({ 
		searcher:function(value,name){
			obj.gridOneWords.load({
				ClassName : "DHCHAI.RMES.OneWordsSrv",
				QueryName : "QryOneWords",
				aVersionDr: $("#cboVerSearch").combobox("getValue"),
				aAlias:$.trim(value)
			})
		}	
	});
	$('#searchBox_two').searchbox({ 
		searcher:function(value,name){
			obj.gridParserWords.load({
				ClassName : "DHCHAI.RMES.ParserWordsSrv",
				QueryName : "QryParserWords",
				aVersionDr: $("#cboVerSearch").combobox("getValue"),
				aOneWordDr:obj.RecRowID,
				aAlias:$.trim(value)
			})
		}	
	});
	//事件初始化
	obj.LoadEvent = function(args){
		//归一词
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		$('#btnEdit').on('click', function(){
			var rd=obj.gridOneWords.getSelected()
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
		// 语义词
		$('#btnAdd_two').on('click', function(){
			obj.InitDialog_two();
		});
		$('#btnEdit_two').on('click', function(){
			var rd=obj.gridParserWords.getSelected()
			obj.InitDialog_two(rd);
		});
		$('#btnDelete_two').on('click', function(){
			obj.btnDelete_two_click();
		});

		$('#winBtnEdit_two').on('click', function(){
			obj.Save_two();
		});
		$('#winBtnClose_two').on('click', function(){
			$HUI.dialog('#winEdit_two').close();
		});
     }
	 // *********************归一词Event*************************
	//双击编辑
	obj.gridOneWords_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//选择
	obj.gridOneWords_onSelect = function (){
		var rowData = obj.gridOneWords.getSelected();

		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridOneWords.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
		obj.gridParserWords.load({
			ClassName : "DHCHAI.RMES.ParserWordsSrv",
			QueryName : "QryParserWords",
			aVersionDr: $("#cboVerSearch").combobox("getValue"),
			aOneWordDr:obj.RecRowID
		})
	}
	
	//核心方法-更新
	obj.Save = function(){
		var errinfo=""
		
		var VersionDr  = $("#cboVersion").combobox("getValue");
		var OneWord    = $("#txtOneWord").val();   		                                                                            
	    var CatDr = $("#cboCat").combobox("getValue");
		
		if (!VersionDr) {
			errinfo = errinfo + "词库版本不允许为空!<br>";
		}
		if (!OneWord) {
			errinfo = errinfo + "归一词不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var InputStr = obj.RecRowID;
		InputStr += "^" + VersionDr;  // 词库版本
		InputStr += "^" + OneWord;    // 归一词
		InputStr += "^" + CatDr;
		InputStr += "^" + "";         // 处置日期
		InputStr += "^" + "";         // 处置时间
		InputStr += "^" + $.LOGON.USERDESC; // 处置人姓名
		
		var flg = $m({
			ClassName:"DHCHAI.RME.OneWords",
			MethodName:"Update",
			aInputStr:InputStr
		},false);
		if (parseInt(flg)> 0) {
			obj.RecRowID="";
			obj.gridOneWords.reload();	//刷新当前页
			$HUI.dialog('#winEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		}else if(parseInt(flg) == '-100'){
			$.messager.alert("错误提示", "归一词重复!" , 'info');
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
					ClassName:"DHCHAI.RME.OneWords",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);
				
				if (flg == '0') {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridOneWords.reload(); //刷新当前页
					obj.gridParserWords.load({
						ClassName : "DHCHAI.RMES.ParserWordsSrv",
						QueryName : "QryParserWords",
						aVersionDr: $("#cboVerSearch").combobox("getValue"),
						aOneWordDr:''
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
			
			$('#txtOneWord').val(rd["OneWord"]).validatebox("validate");
			$('#cboVersion').combobox('setValue',rd["VerID"]);
			$('#cboVersion').combobox('setText',rd["VerDesc"]);
			$('#cboCat').combobox('setValue',rd["CatID"]);
			$('#cboCat').combobox('setText',rd["CatDesc"]);
			
			$("#winBtnSave").show();
			$("#winBtnAdd").hide();
			
			obj.RecRowID=rd["ID"];
		}else{
			$('#txtOneWord').val('').validatebox("validate");
			
			//$('#cboVersion').combobox('setValue','');
			var VersionID=$('#cboVerSearch').combobox('getValue');
			var VersionDesc=$('#cboVerSearch').combobox('getText');
			$('#cboVersion').combobox('setValue',VersionID);
			$('#cboVersion').combobox('setText',VersionDesc);
			
			$('#cboCat').combobox('setValue','');
			
			$("#winBtnSave").hide();
			$("#winBtnAdd").show();
			
			obj.RecRowID = "";
		}
		
		$('#winEdit').show();
		$('#winEdit').dialog({
			title: '归一词编辑',
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:true
		});
	}
	//**********************语义词Event****************************
	obj.gridParserWords_onSelect=function(){
		var rowData = obj.gridParserWords.getSelected();

		if (rowData["ID"] == obj.RecRowID_two) {
			obj.RecRowID_two="";
			$("#btnAdd_two").linkbutton("enable");
			$("#btnEdit_two").linkbutton("disable");
			$("#btnDelete_two").linkbutton("disable");
			obj.gridParserWords.clearSelections();
		} else {
			obj.RecRowID_two = rowData["ID"];
			$("#btnAdd_two").linkbutton("disable");
			$("#btnEdit_two").linkbutton("enable");
			$("#btnDelete_two").linkbutton("enable");
		}	
	}
	obj.gridParserWords_onDbselect = function(rd){
		obj.InitDialog_two(rd);
	}
	  //窗体-初始化
	obj.InitDialog_two= function(rd){
		if(rd){
			$('#txtKeyWord').val(rd["KeyWord"]).validatebox("validate");
			$('#txtLimitWords').val(rd["LimitWord"]);
			$('#txtContext').val(rd["Context"]);
			$('#cboVersion_two').combobox('setValue',rd["VerID"]);
			$('#cboVersion_two').combobox('setText',rd["VerDesc"]);
			$('#chkCheck').checkbox('setValue',rd["IsCheck"]== 1);
			$('#chkActive').checkbox('setValue',rd["IsActive"]== 1);
			
			$("#winBtnSave_two").show();
			$("#winBtnAdd_two").hide();
			
			obj.RecRowID_two=rd["ID"];
		}else{
			$('#txtKeyWord').val('').validatebox("validate");
			$('#txtLimitWords').val('');
			$('#txtContext').val('');
			
			var VersionID=$('#cboVerSearch').combobox('getValue');
			var VersionDesc=$('#cboVerSearch').combobox('getText');
			$('#cboVersion_two').combobox('setValue',VersionID);
			$('#cboVersion_two').combobox('setText',VersionDesc);
			
			$('#chkCheck').checkbox('setValue',false);
			$('#chkActive').checkbox('setValue',true);
			
			$("#winBtnSave_two").hide();
			$("#winBtnAdd_two").show();
			
			obj.RecRowID_two = "";
		}
		
		$('#winEdit_two').show();
		$('#winEdit_two').dialog({
			title: '语义词编辑',
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:true
		});
	}
	
	//核心方法-更新
	obj.Save_two = function(){
		var errinfo="";
		var OneWdsDr = obj.RecRowID; // 归一词ID
       
		var KeyWord    = $('#txtKeyWord').val();
		var LimitWords = $('#txtLimitWords').val();
		var Context    = $('#txtContext').val();
        var VerDr      = $('#cboVersion_two').combobox('getValue');
        var IsCheck    = $("#chkCheck").checkbox('getValue')? '1':'0';	
		var IsActive   = $("#chkActive").checkbox('getValue')? '1':'0';	
		
		if (!VerDr) {
			errinfo = errinfo + "词库版本不允许为空!<br>";
		}	
		if (!KeyWord) {
			errinfo = errinfo + "语义词不允许为空!<br>";
		}	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var InputStr = obj.RecRowID_two;
		InputStr += "^" + VerDr;
		InputStr += "^" + KeyWord;
		InputStr += "^" + LimitWords;
		InputStr += "^" + Context;	
		InputStr += "^" + OneWdsDr;
		InputStr += "^" + IsCheck;
		InputStr += "^" + IsActive;
		InputStr += "^" + ''; 
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERDESC;

		var flg = $m({
			ClassName:"DHCHAI.RME.ParserWords",
			MethodName:"Update",
			aInputStr:InputStr
		},false);
		if (parseInt(flg)> 0) {
			obj.RecRowID_two = "";
			obj.gridParserWords.reload();	//刷新当前页
			$HUI.dialog('#winEdit_two').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		}else if(parseInt(flg) == '-100'){
			$.messager.alert("错误提示", "语义词+词库版+归一词本不允许重复!" , 'info');
		}else{
			$.messager.alert("错误提示", "保存失败!Error=" + flg, 'info');
		}
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
					ClassName:"DHCHAI.RME.ParserWords",
					MethodName:"DeleteById",
					aId:obj.RecRowID_two
				},false);
				
				if (flg == '0') {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID_two = "";
					obj.gridParserWords.reload(); //刷新当前页
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