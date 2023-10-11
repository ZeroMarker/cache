//页面Event
function InitAssModelWinEvent(obj){	
    
	obj.LoadEvent = function(args){ 
	    //保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#AssModelEdit').close();
     	});
		
	    //添加
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd = obj.gridAssModel.getSelected();
			obj.InitDialog(rd);
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});	
	}
	
	//窗体初始化
	obj.AssModelEdit =function() {
		 $('#AssModelEdit').dialog({
			title:'评估模型',
			iconCls:'icon-w-edit',
			modal: true,
			isTopZindex:true
		});
	}
	
	//保存
	obj.btnSave_click = function(){
		var errinfo = "";
		var AMCode = $.trim($('#txtCode').val());
		var AMDesc = $.trim($('#txtDesc').val());
		var AdmStatus = Common_RadioValue('radAdmStatus');
		var ClassName = $.trim($('#txtClassName').val());
		var AMNode = $.trim($('#txtNote').val());
		var SttDate = $('#dtSttDate').datebox('getValue');
		var EndDate = $('#dtEndDate').datebox('getValue');
		var IsActive = $('#chkIsActive').checkbox('getValue')? '1':'0';
		var arrSuRule = $('#cboSuRule').combobox('getValues');
		var SuRule="";
		if (arrSuRule) {
			SuRule = arrSuRule.toString();
		}
		if (!AMCode) {
			errinfo = errinfo + "评估模型代码不允许为空!<br>";
		}
		if (!AMDesc) {
			errinfo = errinfo + "评估模型定义不允许为空!<br>";
		}	
		if (!AdmStatus){
			errinfo = errinfo + "选择就诊状态!<br>";
		}
		if (!ClassName){
			errinfo = errinfo + "类方法不允许为空!<br>";
		}
		if (!SttDate){
			errinfo = errinfo + "开始日期不允许为空!<br>";
		}
		if (!EndDate){
			errinfo = errinfo + "结束日期不允许为空!<br>";
		}
		if (Common_CompareDate(SttDate,Common_GetDate(new Date()))>0){
			errinfo = errinfo + "开始日期不能晚于当前日期!<br>";
		}
		if (Common_CompareDate(SttDate,EndDate)>0){
			errinfo = errinfo + "开始日期不能晚于结束日期!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + AMCode;
		inputStr = inputStr + CHR_1 + AMDesc;	
		inputStr = inputStr + CHR_1 + IsActive;
		inputStr = inputStr + CHR_1 + AdmStatus;	
		inputStr = inputStr + CHR_1 + SttDate;
		inputStr = inputStr + CHR_1 + EndDate;
		inputStr = inputStr + CHR_1 + ClassName;
		inputStr = inputStr + CHR_1 + AMNode;
		inputStr = inputStr + CHR_1 + SuRule;
		inputStr = inputStr + CHR_1 + 1;
		
		var flg = $m({
			ClassName:"DHCHAI.AM.AssessModel",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:CHR_1
		},false);
	
		if (parseInt(flg) <= 0) {
			if(parseInt(flg) == -2){
				$.messager.alert("错误提示", "代码重复!" , 'info');
				return;
			}else{
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
				return;
			}
		}else {
			$HUI.dialog('#AssModelEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.gridAssModel.reload() ;//刷新当前页
		}
	}
	//删除 
	obj.btnDelete_click = function(){
		if (!obj.RecRowID ){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.AM.AssessModel",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridAssModel.reload() ;//刷新当前页
				}
			} 
		});
	}
	
	//单击选中事件
	obj.gridAssModel_onSelect = function (){
		var rowData = obj.gridAssModel.getSelected();
	
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			
			obj.gridAssModel.clearSelections();  //清除选中行
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}	
	
    //双击弹出编辑事件
	obj.gridAssModel_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	
	//窗口初始化
	obj.InitDialog = function(rd){
		if(rd){
			obj.RecRowID = rd["ID"];
			var Code = rd["AMCode"];
			var Desc = rd["AMDesc"];
			var ClassName = rd["ClassName"];
			var AdmStatus = rd["AdmStatus"];
			var SttDate = rd["SttDate"];
			var EndDate = rd["EndDate"];
			var Note = rd["Note"];
			var IsActive = rd["IsActive"];
		    var SuRuleIDs = rd["SuRuleIDs"];
			var arrSuRule="";
			if (SuRuleIDs) {
				arrSuRule=SuRuleIDs.split(",");
			}
			$('#txtCode').val(Code);
			$('#txtDesc').val(Desc);
			if (AdmStatus) {
				$HUI.radio("#radAdmStatus-"+AdmStatus).setValue(true);     // 就诊状态
			}
			$('#txtClassName').val(ClassName);
			$('#cboSuRule').combobox('setValues',arrSuRule);
			$('#txtNote').val(Note);
			$('#dtSttDate').datebox('setValue',SttDate);
			$('#dtEndDate').datebox('setValue',EndDate);
			$('#chkIsActive').checkbox('setValue',(IsActive==1 ? true:false));
	
		}else{
			obj.RecRowID = "";
			$('#txtCode').val('');
			$('#txtDesc').val('');	
			$('#cboSuRule').combobox('clear');
			$HUI.radio('#radAdmStatus').uncheck();
			$('#txtNote').val('');
			$('#dtSttDate').datebox('clear');
			$('#dtEndDate').datebox('clear');
			$('#chkIsActive').checkbox('setValue','');
		}
		$('#AssModelEdit').show();
		obj.AssModelEdit();
	}
	
	$('#btnSuRule').on('click', function(){
		OpenMenu('DHCHAIBaseIR-CRuleSuRule','疑似筛查规则','dhcma.hai.ir.crulesurule.csp');
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
}