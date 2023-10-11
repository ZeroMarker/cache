//页面Event
function InitPathVariatListWinEvent(obj){	
	//按钮初始化
	$('#winPathVariatEdit').dialog({
		title: '变异字典维护',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		
	});	
	// 检查删除按钮是否允许删除，否则隐藏该按钮
	if(!chkDelBtnIsAble("DHCMA.CPW.BT.PathVariat")){
		$("#btnDelete").hide();	
	}else{
		$("#btnDelete").show();	
	}
	
     //按钮点击触发
	obj.LoadEvent = function(args){ 
		//保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#winPathVariatEdit').close();
     	});
		//添加
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd=obj.gridPathVariat.getSelected()
			obj.layer(rd);	
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		//管控数据医院授权点击事件				add by yankai20210803
		$('#btnAuthHosp').on('click',function(){
			Common_WinToAuthHosp(obj.RecRowID,"DHCMA_CPW_BT.PathVariat","gridAuthHosp","winAuthHosp");	
		}) 
	}
	//双击编辑事件
	obj.gridPathVariat_onDbselect = function(rd){
		obj.layer(rd);
	}
	//单击事件
	obj.gridPathVariat_onSelect = function (){
		var rowData = obj.gridPathVariat.getSelected();
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID="";
		
		if (rowData["BTID"] == obj.RecRowID) {
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$("#btnAuthHosp").linkbutton("disable");
			obj.RecRowID="";
			obj.gridPathVariat.clearSelections();
		}
		else {
			obj.RecRowID = rowData["BTID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
			$("#btnAuthHosp").linkbutton("enable");
		}
	}	
	//保存分类
	obj.btnSave_click = function(){
		var errinfo = "";
		var myDate = new Date();
		var Code = $('#txtCode').val();
		var Desc = $('#txtDesc').val();
		var BTCatDr =$('#cboCatDr').combobox('getValue');
		var BTTypeDr=$('#cboTypeDr').combobox('getValue');
		var BTIsExactly = $("#chkIsExactly").checkbox('getValue')? '1':'0';
		var IsActive = $("#chkIsActive").checkbox('getValue')? '1':'0';
		var BTActDate ='';
		var BTActTime='';
		var BTActUserID="";
		var BTAdmType=$('#cboAdmType').combobox('getValue');
		if(session['DHCMA.USERID']) BTActUserID=session['DHCMA.USERID'];	
		
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}	
		if(!BTCatDr){
			errinfo = errinfo + "变异原因分类为空!<br>";
		}
		if (!BTTypeDr) {
			errinfo = errinfo + "变异原因类型为空!<br>";
		}	
		if (!BTAdmType) {
			errinfo = errinfo + "就诊类型为空！<br>"	
		}
		var IsCheck = $m({
			ClassName:"DHCMA.CPW.BT.PathVariat",
			MethodName:"CheckPTCode",
			aCode:Code,
			aID:obj.RecRowID
		},false);
	  	if(IsCheck>=1) {
	  		errinfo = errinfo + "代码与列表中现有项目重复，请检查修改!<br>";
	  	}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + BTCatDr		
		inputStr = inputStr + CHR_1 + BTTypeDr;
		inputStr = inputStr + CHR_1 + BTIsExactly;
		inputStr = inputStr + CHR_1 + IsActive;
		inputStr = inputStr + CHR_1 + BTActDate;
		inputStr = inputStr + CHR_1 + BTActTime;
		inputStr = inputStr + CHR_1 + BTActUserID;
		inputStr = inputStr + CHR_1 + BTAdmType;
		
		var flg = $m({
			ClassName:"DHCMA.CPW.BT.PathVariat",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:CHR_1,
			aHospID: $("#cboSSHosp").combobox('getValue')
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
			}else if (parseInt(flg) == -2) {
				$.messager.alert("错误提示", "数据重复!" , 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#winPathVariatEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID =flg	
			obj.gridPathVariat.reload() ;//刷新当前页
		}

	}
	
	//删除分类 
	obj.btnDelete_click = function(){
		if (obj.RecRowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.CPW.BT.PathVariat",
					MethodName:"DeleteById",
					aId:obj.RecRowID,
					aHospID: $("#cboSSHosp").combobox('getValue')
				},false);
				if (parseInt(flg) < 0) {
					if (parseInt(flg)==-777) {
						$.messager.alert("错误提示","系统参数配置不允许删除！", 'info');
					} else {
						$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
					}
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = ""
					obj.gridPathVariat.reload() ;//刷新当前页
				}
			} 
		});
	}
	//配置窗体-初始化
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID = rd["BTID"];
			var Code = rd["BTCode"];
			var Desc = rd["BTDesc"];
			var BTTypeID = rd["BTTypeID"];
			var BTCatID  =rd["BTCatID"]
			var BTAdmType = rd["BTAdmType"]
			var BTIsExactly = rd["BTIsExactly"];
			BTIsExactly = (BTIsExactly=="正"? true: false)
			var BTIsActive = rd["BTIsActive"];
			BTIsActive = (BTIsActive=="是"? true: false)
			$('#txtCode').val(Code);
			$('#txtDesc').val(Desc);
			$('#cboCatDr').combobox('setValue',BTCatID);
			$('#cboTypeDr').combobox('setValue',BTTypeID);
			$('#cboAdmType').combobox('setValue',BTAdmType);
			$('#chkIsExactly').checkbox('setValue',BTIsExactly);
			$('#chkIsActive').checkbox('setValue',BTIsActive);
		}else{
			obj.RecRowID = "";
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#cboCatDr').combobox('setValue','');
			$('#cboTypeDr').combobox('setValue','');
			$('#chkIsExactly').checkbox('setValue',false);
			$('#chkIsActive').checkbox('setValue',false);
			$('#cboAdmType').combobox('setValue','')
		}
		$HUI.dialog('#winPathVariatEdit').open();
	}	
}
