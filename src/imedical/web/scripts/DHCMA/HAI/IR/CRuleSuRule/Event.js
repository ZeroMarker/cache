//页面Event
function InitSuRuleWinEvent(obj){
	
	obj.LoadEvent = function(args){ 
		 //保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#SuItemEdit').close();
     	});
		
	    //添加
		$('#btnAdd').on('click', function(){
			obj.InitSuItemDialog();
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd = obj.gridSuItem.getSelected();
			obj.InitSuItemDialog(rd);
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});	
		
		//保存
		$('#btnSave_R').on('click', function(){
	     	obj.btnSaveSuRule_click();
     	});
		//关闭
		$('#btnClose_R').on('click', function(){
	     	$HUI.dialog('#SuRuleEdit').close();
     	});
		
	    //添加
		$('#btnAdd_R').on('click', function(){
			obj.InitSuRuleDialog();
		});
		//编辑
		$('#btnEdit_R').on('click', function(){
			var rd = obj.gridSuRule.getSelected();
			obj.InitSuRuleDialog(rd);
		});
		//删除
		$('#btnDelete_R').on('click', function(){
			obj.btnDeleteSuRule_click();
		});	
		
		
		//保存
		$('#btnSave_E').on('click', function(){
	     	obj.btnSaveSuRuleExp_click();
     	});
		//关闭
		$('#btnClose_E').on('click', function(){
	     	$HUI.dialog('#SuRuleExpEdit').close();
     	});
		
	    //添加
		$('#btnAdd_E').on('click', function(){
			obj.InitSuRuleExpDialog();
		});
		//编辑
		$('#btnEdit_E').on('click', function(){
			var rd = obj.gridSuRuleExp.getSelected();
			obj.InitSuRuleExpDialog(rd);
		});
		//删除
		$('#btnDelete_E').on('click', function(){
			obj.btnDeleteSuRuleExp_click();
		});	
	}
	
	//****************************疑似筛查规则项目**********************↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
	//窗体初始化
	obj.SuItemEdit =function() {
		 $('#SuItemEdit').dialog({
			title:'疑似筛查规则项目',
			iconCls:'icon-w-edit',
			modal: true,
			isTopZindex:true
		});
	}
	//保存
	obj.btnSave_click = function(){
		var errinfo = "";
		var Category    = $.trim($('#txtCategory').val());
		var ItemDesc    = $.trim($('#txtItemDesc').val());
		var ItemDesc2   = $.trim($('#txtItemDesc2').val());
		var InputDicTab = $.trim($('#txtInputDicTab').val());
		var InputMaxTab = $('#chkInputMaxTab').checkbox('getValue')? '1':'0';
		var InputMinTab = $('#chkInputMinTab').checkbox('getValue')? '1':'0';
		var InputDayTab = $('#chkInputDayTab').checkbox('getValue')? '1':'0';
		var InputCntTab = $('#chkInputCntTab').checkbox('getValue')? '1':'0';
		var InputNote   = $.trim($('#txtInputNote').val());
		
		if (!Category) {
			errinfo = errinfo + "项目分类不允许为空!<br>";
		}
		if (!ItemDesc) {
			errinfo = errinfo + "项目名称不允许为空!<br>";
		}	
		
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
			
		var inputStr = obj.ItemRowID;	
		inputStr = inputStr + "^" + ItemDesc;
		inputStr = inputStr + "^" + ItemDesc2;
		inputStr = inputStr + "^" + Category;
		inputStr = inputStr + "^" + InputDicTab;	
		inputStr = inputStr + "^" + InputMaxTab;
		inputStr = inputStr + "^" + InputMinTab;
		inputStr = inputStr + "^" + InputDayTab;
		inputStr = inputStr + "^" + InputCntTab;
		inputStr = inputStr + "^" + InputNote;
		
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleInfSuItem",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:"^"
		},false);
	
		if (parseInt(flg) <= 0) {	
			$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			return;		
		}else {
			$HUI.dialog('#SuItemEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.ItemRowID = "";
			obj.gridSuItem.reload() ;//刷新当前页
		}
	}
	//删除 
	obj.btnDelete_click = function(){
		if (!obj.ItemRowID ){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CRuleInfSuItem",
					MethodName:"DeleteById",
					aId:obj.ItemRowID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.ItemRowID = "";
					obj.gridSuItem.reload() ;//刷新当前页
				}
			} 
		});
	}
	
	//单击选中事件
	obj.gridSuItem_onSelect = function (){
		var rowData = obj.gridSuItem.getSelected();
		if (rowData["ItemID"] == obj.ItemRowID) {
			obj.ItemRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");		
			obj.gridSuItem.clearSelections();  //清除选中行
		} else {
			obj.ItemRowID = rowData["ItemID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}	
	
    //双击弹出编辑事件
	obj.gridSuItem_onDbselect = function(rd){
		obj.InitSuItemDialog(rd);
	}
	
	//窗口初始化
	obj.InitSuItemDialog = function(rd){
		if(rd){
			obj.ItemRowID   = rd["ItemID"];
			var Category    = rd["Category"];
			var ItemDesc    = rd["ItemDesc"];
			var ItemDesc2   = rd["ItemDesc2"];
			var InputDicTab = rd["InputDicTab"];
			var InputMaxTab = rd["InputMaxTab"];;
			var InputMinTab = rd["InputMinTab"];;
			var InputDayTab = rd["InputDayTab"];;
			var InputCntTab = rd["InputCntTab"];;
			var InputNote   = rd["InputNote"];
		 
			$('#txtCategory').val(Category);
			$('#txtItemDesc').val(ItemDesc);
			$('#txtItemDesc2').val(ItemDesc2);
			$('#txtInputDicTab').val(InputDicTab);
			$('#chkInputMaxTab').checkbox('setValue',(InputMaxTab==1 ? true:false));
			$('#chkInputMinTab').checkbox('setValue',(InputMinTab==1 ? true:false));
			$('#chkInputDayTab').checkbox('setValue',(InputDayTab==1 ? true:false));
			$('#chkInputCntTab').checkbox('setValue',(InputCntTab==1 ? true:false));
			$('#txtInputNote').val(InputNote);
		}else{
			$('#txtCategory').val('');
			$('#txtItemDesc').val('');
			$('#txtItemDesc2').val('');
			$('#txtInputDicTab').val('');
			$('#chkInputMaxTab').checkbox('setValue','');
			$('#chkInputMinTab').checkbox('setValue','');
			$('#chkInputDayTab').checkbox('setValue','');
			$('#chkInputCntTab').checkbox('setValue','');
			$('#txtInputNote').val('');
		}
		
		$('#SuItemEdit').show();
		obj.SuItemEdit();
	}
	//****************************疑似筛查规则项目**********************↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
	
	
	//****************************感染疑似筛查规则**********************↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
	//窗体初始化
	obj.SuRuleEdit =function() {
		 $('#SuRuleEdit').dialog({
			title:'感染疑似筛查规则',
			iconCls:'icon-w-edit',
			modal: true,
			isTopZindex:true
		});
	}
	
	//保存
	obj.btnSaveSuRule_click = function(){
		var errinfo = "";
		var RuleNo    = $.trim($('#txtRuleNo').val());
		var RuleType    = $.trim($('#txtRuleType').val());
		var RuleNote   = $.trim($('#txtRuleNote').val());
		var ItmScreenDr = $('#cboItmScreen').combobox('getValue');
		var SuPosDr = $('#cboSuPos').combobox('getValue');
		var IsActive = $('#chkIsActive').checkbox('getValue')? '1':'0';
	    var Threshold = $('#txtThreshold').val();
	    
		if (!RuleNo) {
			errinfo = errinfo + "规则编号不允许为空!<br>";
		}else {
			var RuleDate = RuleNo.substr(0,4)+"-"+RuleNo.substr(4,2)+"-"+RuleNo.substr(6,2);
			if ((RuleNo.length!=11)||(isNaN(RuleNo))||(isNaN(Date.parse(RuleDate)))||(parseInt(RuleNo.substr(8,3))<1)) {		
				errinfo = errinfo + "规则编号格式不正确!<br>";
			}
		}
		
		if (!RuleType) {
			errinfo = errinfo + "规则定义不允许为空!<br>";
		}	
		if (!RuleNote) {
			errinfo = errinfo + "规则说明不允许为空!<br>";
		}
		if (!ItmScreenDr) {
			errinfo = errinfo + "疑似筛查项目不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
			
		var inputStr = obj.RuleRowID;	
		inputStr = inputStr + "^" + RuleNo;
		inputStr = inputStr + "^" + ItmScreenDr;
		inputStr = inputStr + "^" + SuPosDr;
		inputStr = inputStr + "^" + RuleType;	
		inputStr = inputStr + "^" + RuleNote;
		inputStr = inputStr + "^" + IsActive;
		inputStr = inputStr + "^" + '';
		inputStr = inputStr + "^" + '';
		inputStr = inputStr + "^" + '';
		inputStr = inputStr + "^" + Threshold;
		
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleInfSuRule",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:"^"
		},false);
	
		if (parseInt(flg) <= 0) {	
		    if (parseInt(flg)=='-2') {
				$.messager.alert("错误提示", "规则编号重复！", 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
			return;		
		}else {
			$HUI.dialog('#SuRuleEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RuleRowID = "";
			obj.gridSuRule.reload() ;//刷新当前页
		}
	}
	//删除 
	obj.btnDeleteSuRule_click = function(){
		if (!obj.RuleRowID ){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CRuleInfSuRule",
					MethodName:"DeleteById",
					aId:obj.RuleRowID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RuleRowID = "";
					obj.gridSuRule.reload() ;//刷新当前页
				}
			} 
		});
	}
	
	//单击选中事件
	obj.gridSuRule_onSelect = function (){
		var rowData = obj.gridSuRule.getSelected();
		if (rowData["RuleID"] == obj.RuleRowID) {
			obj.RuleRowID="";			
			$("#btnAdd_R").linkbutton("enable");
			$("#btnEdit_R").linkbutton("disable");
			$("#btnDelete_R").linkbutton("disable");		
			obj.gridSuRule.clearSelections();  //清除选中行
			$("#btnAdd_E").linkbutton("disable");
		} else {	
			obj.RuleRowID = rowData["RuleID"];	
			$("#btnAdd_R").linkbutton("disable");
			$("#btnEdit_R").linkbutton("enable");
			$("#btnDelete_R").linkbutton("enable");
			$("#btnAdd_E").linkbutton("enable");
		}
		obj.gridSuRuleExpLoad(obj.RuleRowID);
	}	
	
    //双击弹出编辑事件
	obj.gridSuRule_onDbselect = function(rd){
		obj.InitSuRuleDialog(rd);
	}
	
	//窗口初始化
	obj.InitSuRuleDialog = function(rd){
		if(rd){
			obj.RuleRowID   = rd["RuleID"];
			var RuleNo    	= rd["RuleNo"];
			var RuleType    = rd["RuleType"];
			var RuleNote   	= rd["RuleNote"];	
			var ItmScreenID = rd["ItmScreenID"];
			var InfPosID 	= rd["InfPosID"];
			var IsActive 	= rd["IsActive"];
			var Threshold 	= rd["Threshold"];

			$('#txtRuleNo').val(RuleNo);
			$('#txtRuleType').val(RuleType);
			$('#txtRuleNote').val(RuleNote);
			$('#cboItmScreen').combobox('setValue',ItmScreenID);
			$('#cboSuPos').combobox('setValue',InfPosID);
			$('#chkIsActive').checkbox('setValue',(IsActive==1 ? true:false));
			$('#txtThreshold').val(Threshold);
		
		}else{
			$('#txtRuleNo').val('');
			$('#txtRuleType').val('');
			$('#txtRuleNote').val('');
			$('#cboItmScreen').combobox('clear');
			$('#cboSuPos').combobox('clear');
			$('#chkIsActive').checkbox('setValue','');
			$('#txtThreshold').val('');
		}
		$('#SuRuleEdit').show();
		obj.SuRuleEdit();
	}
	//****************************感染疑似筛查规则**********************↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
	
	//****************************疑似筛查规则表达式**********************↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
	
	obj.gridSuRuleExpLoad =function(aRuleID) {
		obj.gridSuRuleExp.load ({
			ClassName:"DHCHAI.IRS.CRuleSuRuleSrv",
			QueryName:"QrySuRuleExp",
			aRuleID:aRuleID
		})
	}
	//窗体初始化
	obj.SuRuleExpEdit =function() {
		
		 $('#SuRuleExpEdit').dialog({
			title:'疑似筛查规则表达式',
			iconCls:'icon-w-edit',
			modal: true,
			isTopZindex:true
		});
	}
	//保存
	obj.btnSaveSuRuleExp_click = function(){
		var errinfo = "";
		var ItemDesc	= $('#cboItemDesc').combobox('getValue');
		var InputDicSet = $('#txtInputDicSet').val();
		var InputMaxSet = $('#txtInputMaxSet').val();
		var InputMinSet = $('#txtInputMinSet').val();
		var InputDaySet = $('#txtInputDaySet').val();
		var InputCntSet = $('#txtInputCntSet').val();
		var InputNote   = $.trim($('#txtNote').val());
        var Weight      = $('#txtWeight').val();
		var InputSttDay = $('#txtInputSttDay').val();
		//字符转换
		InputDicSet = InputDicSet.replace(/，/, '#').replace(/、/, '#').replace(/,/, '#');
		
		if (!ItemDesc) {
			errinfo = errinfo + "项目名称不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var SubID = (obj.ExpRowID ? obj.ExpRowID.split("||")[1] :'');
		var inputStr = obj.RuleID;	
		inputStr = inputStr + "^" + SubID;
		inputStr = inputStr + "^" + ItemDesc;
		inputStr = inputStr + "^" + InputDicSet;
		inputStr = inputStr + "^" + InputMaxSet;	
		inputStr = inputStr + "^" + InputMinSet;
		inputStr = inputStr + "^" + InputDaySet;
		inputStr = inputStr + "^" + InputCntSet;
		inputStr = inputStr + "^" + InputNote;
		inputStr = inputStr + "^" + Weight;
		inputStr = inputStr + "^" + InputSttDay;
	
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleInfSuRuleExp",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:"^"
		},false);
	
		if (parseInt(flg) <= 0) {	
			$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			return;		
		}else {
			$HUI.dialog('#SuRuleExpEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.ExpRowID = "";
			obj.gridSuRuleExp.reload() ;//刷新当前页
		}
	}
	//删除 
	obj.btnDeleteSuRuleExp_click = function(){
		if (!obj.ExpRowID ){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CRuleInfSuRuleExp",
					MethodName:"DeleteById",
					aId:obj.ExpRowID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.ExpRowID = "";
					obj.gridSuRuleExp.reload() ;//刷新当前页
				}
			} 
		});
	}
	
	//单击选中事件
	obj.gridSuRuleExp_onSelect = function (){
		var rowData = obj.gridSuRuleExp.getSelected();
		if (rowData["ID"] == obj.ExpRowID) {
			obj.ExpRowID="";
			$("#btnAdd_E").linkbutton("enable");
			$("#btnEdit_E").linkbutton("disable");
			$("#btnDelete_E").linkbutton("disable");		
			obj.gridSuRuleExp.clearSelections();  //清除选中行
		} else {
			obj.ExpRowID = rowData["ID"];
			$("#btnAdd_E").linkbutton("disable");
			$("#btnEdit_E").linkbutton("enable");
			$("#btnDelete_E").linkbutton("enable");
		}
	}	
	
    //双击弹出编辑事件
	obj.gridSuRuleExp_onDbselect = function(rd){
		obj.InitSuRuleExpDialog(rd);
	}
	
	//窗口初始化
	obj.InitSuRuleExpDialog = function(rd){
		if(rd){
			obj.ExpRowID    = rd["ID"];
			var ItemDesc    = rd["ItemDesc"];
			var InputDicSet = rd["InputDicSet"];
			var InputMaxSet = rd["InputMaxSet"];
			var InputMinSet = rd["InputMinSet"];
			var InputDaySet = rd["InputDaySet"];
			var InputCntSet = rd["InputCntSet"];
			var InputNote 	= rd["InputNote"]
			var Weight      = rd["Weight"];	
			var InputSttDay = rd["InputSttDay"];	
			$('#tr-ItemCate').css('display','none');
			
			obj.ItemCate="";	
			obj.LoadItemDesc();
			$('#cboItemDesc').combobox('setValue',ItemDesc);
			
			obj.ItemDicTab = $m({
				ClassName:"DHCHAI.IRS.CRuleSuRuleSrv",
				MethodName:"GetDicTabDesc",
				aItemDesc:ItemDesc
			},false);
			if (obj.ItemDicTab) {
				$('#tr-ItemDicSet').css('display','');
				$('#txtInputDicSet').attr("readOnly", true);
				obj.LoadItemDic(obj.ItemDicTab);
				if (InputDicSet) {
					var arrInputDic = InputDicSet.split("#");   //转化为数组
					$('#cboInputDicSet').combobox('setValues',arrInputDic);
				}
			}else {
				$('#tr-ItemDicSet').css('display','none');
				$('#txtInputDicSet').attr("readOnly", false);
			}
		
			$('#txtInputDicSet').val(InputDicSet);
			$('#txtInputMaxSet').val(InputMaxSet);
			$('#txtInputMinSet').val(InputMinSet);
			$('#txtInputDaySet').val(InputDaySet);
			$('#txtInputCntSet').val(InputCntSet);
			$('#txtNote').val(InputNote);
			$('#txtWeight').val(Weight);
			$('#txtInputSttDay').val(InputSttDay);
		}else{
			$('#tr-ItemCate').css('display','');
			$('#cboItemCate').combobox('clear');
			$('#cboItemDesc').combobox('clear');
			$('#txtInputDicSet').val('');
			$('#txtInputMaxSet').val('');
			$('#txtInputMinSet').val('');
			$('#txtInputDaySet').val('');
			$('#txtInputCntSet').val('');
			$('#txtNote').val('');
			$('#txtWeight').val('');
			$('#txtInputSttDay').val('');
		}
		$('#SuRuleExpEdit').show();
		obj.SuRuleExpEdit();
	}
	
	//****************************疑似筛查规则表达式**********************↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
	
	//****************************快捷菜单**********************↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
	$('#btnScreen').on('click', function(){
		OpenMenu('DHCHAIBaseIR-CCItmScreen','疑似筛查项目','dhcma.hai.ir.ccitmscreen.csp');
	});
	$('#btnLab').on('click', function(){
		OpenMenu('DHCHAIBaseIR-CRuleTestSrv','常规检验规则','dhcma.hai.ir.cruletestsrv.csp');
	});
	$('#btnSuPos').on('click', function(){
		OpenMenu('DHCHAIBase-InfSuPos','疑似诊断','dhcma.hai.bt.infsupos.csp');
	});
	$('#btnKeyWord').on('click', function(){
		OpenMenu('DHCHAIRME-ThemeWords','主题词库','dhcma.hai.rme.themewords.csp');
	});
	$('#btnOneWord').on('click', function(){
		OpenMenu('DHCHAIRME-ThemeWordsMap','主题词映射','dhcma.hai.thwordsmapcheck.csp');
	});
	// 菜单跳转
	function OpenMenu(menuCode,menuDesc,menuUrl) {
		var strUrl = '../csp/'+menuUrl+'?+&1=1';
		//主菜单
		var data = [{
			"menuId": "",
			"menuCode": menuCode,
			"menuDesc": menuDesc,
			"menuResource": menuUrl,
			"menuOrder": "1",
			"menuIcon": "icon"
		}];
		if( typeof window.parent.showNavTab === 'function' ){   //bootstrap 版本
			window.parent.showNavTab(data[0]['menuCode'], data[0]['menuDesc'], data[0]['menuResource'], data[0]['menuCode'], data[0]['menuIcon'], false);
		}else{ //HISUI 版本
			window.parent.addTab({
				url:menuUrl,
				title:menuDesc
			});
		}
	}
	
	//****************************快捷菜单**********************↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
}
