//页面Event
function InitSuspTestCodeWinEvent(obj){	
    
	obj.LoadEvent = function(args){ 
	    /*********************传染病疑似检验项目*******************/
	    //保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#TestCodeEdit').close();
     	});
		
	    //添加
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd = obj.girdTestCode.getSelected();
			obj.InitDialog(rd);
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});	
		$('#searchbox').searchbox({ 
			searcher:function(value,name){ 
				obj.girdTestCode.load({
					ClassName:'DHCMed.EPDService.SuspTestCodeSrv',
					QueryName:'QryTestCodeByDesc',
					aDesc:value
				});
			}	
		});	
		/*********************传染病疑似检验项目*******************/
		 
		/************************检验项目**************************/
		//保存
		$('#btnExtSave').on('click', function(){
	     	obj.btnExtSave_click();
     	});
		//关闭
		$('#btnExtClose').on('click', function(){
	     	$HUI.dialog('#TestCodeExtEdit').close();
     	});
		//添加
		$('#btnExtAdd').on('click', function(){
			obj.InitExtDialog();
		});
		//编辑
		$('#btnExtEdit').on('click', function(){
			var rd = obj.girdTestCodeExt.getSelected();
			obj.InitExtDialog(rd);
		});
		//删除
		$('#btnExtDelete').on('click', function(){
			obj.btnExtDelete_click();
		});	
		/************************检验项目**************************/
		$('#girdTestCode').datagrid('getPager').pagination({
        	onRefresh:function (pageNumber, pageSize) {
                obj.RecRowID2 = "";
				$("#btnExtAdd").linkbutton("disable");
				$("#btnExtEdit").linkbutton("disable");
				$("#btnExtDelete").linkbutton("disable");
                datagrid.datagrid("unselectAll");//取消勾选当前页中的所有行，解决刷新前全选，刷新后全选框没有取消问题
                datagrid.datagrid("options").queryParams={};//清空查询所携带的参数，也可自己手动添加参数，参数类型为对象
             }
		});
	}
	
	//窗体初始化
	obj.TestCodeEdit = $('#TestCodeEdit').dialog({
		title:'传染病疑似检验项目维护',
		iconCls:'icon-w-edit',
		closed: true,
		modal: true,
		isTopZindex:true
	});
	
	//窗体初始化
	obj.TestCodeExtEdit = $('#TestCodeExtEdit').dialog({
		title:'检验项目维护',
		iconCls:'icon-w-edit',
		closed: true,
		modal: true,
		isTopZindex:true
	});
	
	/*********************传染病疑似检验项目*******************/
	//保存
	obj.btnSave_click = function(){
		var errinfo = "";
		var Code = $.trim($('#txtCode').val());
		var Desc = $.trim($('#txtDesc').val());
	    var Note = $.trim($('#txtNote').val());
		
		if (!Code) {
			errinfo = errinfo + "项目代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "项目名称为空!<br>";
		}	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID1;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;	
		inputStr = inputStr + CHR_1 + Note;
	
		var flg = $m({
			ClassName:"DHCMed.EPD.SuspTestCode",
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
			$HUI.dialog('#TestCodeEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.girdTestCode.reload() ;//刷新当前页
		}
	}
	//删除 
	obj.btnDelete_click = function(){
		if (obj.RecRowID1 == ""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMed.EPD.SuspTestCode",
					MethodName:"DeleteById",
					aId:obj.RecRowID1
				},false);

				if (parseInt(flg) < 0) {
					if (parseInt(flg)=='-777') {
						$.messager.alert("错误提示","-777：当前无删除权限，请启用删除权限后再删除记录!",'info');
					}else {
						$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
					}
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID1 = "";
					obj.girdTestCode.reload() ;//刷新当前页
					obj.girdTestCodeExt.reload() ;//刷新当前页
				}
			} 
		});
	}
	
	//单击选中事件
	obj.girdTestCode_onSelect = function (){
		var rowData = obj.girdTestCode.getSelected();
		if (rowData["ID"] == obj.RecRowID1) {
			obj.RecRowID1="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");		
			obj.girdTestCode.clearSelections();  //清除选中行
		} else {
			obj.RecRowID1 = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}	
	
    //双击弹出编辑事件
	obj.girdTestCode_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	
	//窗口初始化
	obj.InitDialog = function(rd){
		if(rd){
			$('#txtCode').validatebox({required:false});																						 
			$('#txtDesc').validatebox({required:false});																					 
			obj.RecRowID1 = rd["ID"];
			var Code = rd["BTCode"];
			var Desc = rd["BTDesc"];
			var Note = rd["BTNote"];
			
			$('#txtCode').val(Code);
			$('#txtDesc').val(Desc);
			$('#txtNote').val(Note);
			$('#txtCode').attr('disabled','disabled'); //检验项目不允许修改
	
		}else{
			obj.RecRowID1 = "";
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#txtNote').val('');
			$('#txtCode').removeAttr('disabled','disabled'); //检验项目不允许修改
		}
		$HUI.dialog('#TestCodeEdit').open();
	}
	/*********************传染病疑似检验项目*******************/
	
	/************************检验项目**************************/
	//保存
	obj.btnExtSave_click = function(){
		var errinfo = "";
		var TestCode = $('#cbgTestCode').lookup('getValue');
		var TestDesc = $('#cbgTestCode').lookup('getText');
		var SpecCode = $('#cbgSpecimen').lookup('getValue');
		var SpecDesc = $('#cbgSpecimen').lookup('getText');
	    var ResultType = $('#cboResultType').combobox('getValue');
		var ResultUnit = $('#txtResultUnit').val();
		var ValueMax = $('#txtValueMax').val();
		var ValueMin = $('#txtValueMin').val();
		var Values = $('#txtValues').val();	
		var IsActive = $('#chkIsActive').checkbox('getValue')? '1':'0';
		var UserID  = session['LOGON.USERID'];
		var UserName  = session['LOGON.USERNAME'];
	    var PatSex = $('#cboPatSex').combobox('getValue');
		
		if (!TestCode) {
			errinfo = errinfo + "检验项目为空!<br>";
		}
		if (!ResultType) {
			errinfo = errinfo + "结果类型为空!<br>";
		}	
        if ((ResultType=="N")&&((ValueMax=="")&&(ValueMin==""))){
            errinfo = errinfo + "结果类型为数值时，最大值最小值不能同时为空!<br>";
        }
		 if (((ValueMax!="")&&(ValueMin!=""))&&(eval(ValueMax)<eval(ValueMin))){		
            errinfo = errinfo + "最大值应该不小于最小值!<br>";
        }
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID1;
		inputStr = inputStr + CHR_1 + obj.RecRowID2;
		inputStr = inputStr + CHR_1 + TestCode;    
		inputStr = inputStr + CHR_1 + TestDesc;
		inputStr = inputStr + CHR_1 + ((!SpecCode)? '':SpecCode);      
		inputStr = inputStr + CHR_1 + ((!SpecDesc)? '':SpecDesc);    
		inputStr = inputStr + CHR_1 + ResultType;  
		inputStr = inputStr + CHR_1 + ResultUnit;  
		inputStr = inputStr + CHR_1 + ValueMax;
		inputStr = inputStr + CHR_1 + ValueMin;
		inputStr = inputStr + CHR_1 + Values;  
		inputStr = inputStr + CHR_1 + IsActive;    
		inputStr = inputStr + CHR_1 + '';     
		inputStr = inputStr + CHR_1 + '';     
		inputStr = inputStr + CHR_1 + UserName;   
		inputStr = inputStr + CHR_1 + PatSex;    
	  
		var flg = $m({
			ClassName:"DHCMed.EPD.SuspTestCodeExt",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:CHR_1
		},false);
		
		if (parseInt(flg) <= 0) {
			$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			return;
		}else {
			$HUI.dialog('#TestCodeExtEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.girdTestCodeExt.reload() ;//刷新当前页
		}
	}
	
	//删除 
	obj.btnExtDelete_click = function(){
		if ((obj.RecRowID1!="")&&(obj.RecRowID2!="")){
			$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
				if (r) {				
					var flg = $m({
						ClassName:"DHCMed.EPD.SuspTestCodeExt",
						MethodName:"DeleteById",
						aId:obj.RecRowID1+"||"+obj.RecRowID2
					},false);

					if (parseInt(flg) < 0) {
						$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
					} else {
						$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
						obj.RecRowID2 = "";
						obj.girdTestCodeExt.reload() ;//刷新当前页
					}
				} 
			});
		} else {
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
	}
	
	//单击选中事件
	obj.girdTestCodeExt_onSelect = function (){
		var rowData = obj.girdTestCodeExt.getSelected();
	
		if (rowData["SubID"] == obj.RecRowID2) {
			obj.RecRowID2="";
			$("#btnExtAdd").linkbutton("enable");
			$("#btnExtEdit").linkbutton("disable");
			$("#btnExtDelete").linkbutton("disable");
			
			obj.girdTestCodeExt.clearSelections();  //清除选中行
		} else {
			obj.RecRowID2 = rowData["SubID"];
			$("#btnExtAdd").linkbutton("disable");
			$("#btnExtEdit").linkbutton("enable");
			$("#btnExtDelete").linkbutton("enable");
		}
	}	
	
    //双击弹出编辑事件
	obj.girdTestCodeExt_onDbselect = function(rd){
		obj.InitExtDialog(rd);
	}
	
	//窗口初始化
	obj.InitExtDialog = function(rd){
		if(rd){
			obj.RecRowID2 = rd["SubID"];
			//var TSDr = rd["TSDr"];
			//var TestSet = rd["TestSet"];
			var TestCode = rd["TestCode"];
			var TestDesc = rd["TestDesc"];
			var SpecCode = rd["SpecCode"];
			var SpecDesc = rd["SpecDesc"];
			var ResultType = rd["ResultType"];
			var ResultUnit = rd["ResultUnit"];
			var ValueMax = rd["CompValueMax"];
			var ValueMin = rd["CompValueMin"];
			var Values = rd["CompValues"];
			var IsActive = rd["IsActive"];
			var PatSex = rd["PatSex"];
			var PatSexDesc = rd["PatSexDesc"];
		
		    $('#cbgTestSet').lookup('setValue',"");
			$('#cbgTestSet').lookup('setText',"");
		    $('#cbgTestCode').lookup('setValue',TestCode);
			$('#cbgTestCode').lookup('setText',TestDesc);
		    $('#cbgSpecimen').lookup('setValue',SpecCode);
		    $('#cbgSpecimen').lookup('setText',SpecDesc);
	        $('#cboResultType').combobox('setValue',ResultType).validatebox({required:true});
		    $('#txtResultUnit').val(ResultUnit);
		    $('#txtValueMax').val(ValueMax);
		    $('#txtValueMin').val(ValueMin);
		    $('#txtValues').val(Values);	
		    $('#chkIsActive').checkbox('setValue',(IsActive==1? true : false));	
	        $('#cboPatSex').combobox('setValue',PatSex);
	        $('#cboPatSex').combobox('setText',PatSexDesc);
		}else{
			obj.RecRowID2 = "";
			$('#cbgTestSet').lookup('clear');
			$('#cbgTestCode').lookup('clear');
		    $('#cbgSpecimen').lookup('clear');
	        $('#cboResultType').combobox('setValue',"")
	        //$('#cboResultType').combobox('clear')
			$('#cboResultType').validatebox({required:true});
		    $('#txtResultUnit').val('');
		    $('#txtValueMax').val('');
		    $('#txtValueMin').val('');
		    $('#txtValues').val('');	
		    $('#chkIsActive').checkbox('setValue','');
	        $('#cboPatSex').combobox('setValue','');
		}
		$HUI.dialog('#TestCodeExtEdit').open();
	}
	/************************检验项目**************************/
		 
}