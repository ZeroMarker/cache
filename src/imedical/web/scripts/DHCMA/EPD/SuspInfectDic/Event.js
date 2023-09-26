//页面Event
function InitSuspInfectDicWinEvent(obj){	
    
	obj.LoadEvent = function(args){ 
	    //保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#InfectDicEdit').close();
     	});
		
	    //添加
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd = obj.gridInfectDic.getSelected();
			obj.InitDialog(rd);
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});	
		$('#searchbox').searchbox({ 
			searcher:function(value,name){ 
				obj.gridInfectDic.load({
					ClassName:'DHCMed.EPDService.SuspInfectDicSrv',
					QueryName:'QryInfectByDesc',
					aDesc:value
				});
			}	
		});
	}
	
	//窗体初始化
	obj.InfectDicEdit = $('#InfectDicEdit').dialog({
		title:'疑似诊断维护',
		iconCls:'icon-w-edit',
		closed: true,
		modal: true,
		isTopZindex:true
	});
	
	//保存
	obj.btnSave_click = function(){
		var errinfo = "";
		var Code = $.trim($('#txtCode').val());
		var Desc = $.trim($('#txtDesc').val());
		var InfectID = $.trim($('#cboInfect').combobox('getValue'));
		var KindID = $.trim($('#cboKind').combobox('getValue'));
		var IndNo = $.trim($('#txtIndNo').val());
		var IsActive = $('#chkIsActive').checkbox('getValue')? '1':'0';
		var UserID  = session['LOGON.USERID'];
		var UserName  = session['LOGON.USERNAME'];
		
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}	
		if (!KindID){
			errinfo = errinfo + "传染病类别为空!<br>";
		}
		
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;	
		inputStr = inputStr + CHR_1 + InfectID;
		inputStr = inputStr + CHR_1 + KindID;	
		inputStr = inputStr + CHR_1 + IndNo;
		inputStr = inputStr + CHR_1 + IsActive;
		inputStr = inputStr + CHR_1 + '';
		inputStr = inputStr + CHR_1 + '';
		inputStr = inputStr + CHR_1 + UserName;
		
		var flg = $m({
			ClassName:"DHCMed.EPD.SuspInfectDic",
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
			$HUI.dialog('#InfectDicEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.gridInfectDic.reload() ;//刷新当前页
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
					ClassName:"DHCMed.EPD.SuspInfectDic",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridInfectDic.reload() ;//刷新当前页
				}
			} 
		});
	}
	
	//单击选中事件
	obj.gridInfectDic_onSelect = function (){
		var rowData = obj.gridInfectDic.getSelected();
	
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			
			obj.gridInfectDic.clearSelections();  //清除选中行
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}	
	
    //双击弹出编辑事件
	obj.gridInfectDic_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	
	//窗口初始化
	obj.InitDialog = function(rd){
		if(rd){
			obj.RecRowID = rd["ID"];
			var Code = rd["BTCode"];
			var Desc = rd["BTDesc"];
			var InfectID = rd["InfectID"];
			var Infection = rd["Infection"];
			var KindID = rd["KindID"];
			var Kind = rd["BTKind"];
			var IndNo = rd["BTIndNo"];
			var IsActive = rd["IsActive"];
			$('#txtCode').val(Code).validatebox("validate");
			$('#txtDesc').val(Desc).validatebox("validate");
			$('#cboInfect').combobox('setValue',InfectID);
			$('#cboInfect').combobox('setText',Infection);
			$('#cboKind').combobox('setValue',KindID);
			$('#cboKind').combobox('setText',Kind);
			$('#txtIndNo').val(IndNo);
			$('#chkIsActive').checkbox('setValue',(IsActive==1 ? true:false));
	
		}else{
			obj.RecRowID = "";
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#cboInfect').combobox('clear');
			$('#cboKind').combobox('clear');
			$('#txtIndNo').val('');
			$('#chkIsActive').checkbox('setValue','');
		}
		$HUI.dialog('#InfectDicEdit').open();
	}
}