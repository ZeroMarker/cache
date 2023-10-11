//页面Event
function InitCRuleTestSrvWinEvent(obj){
	//检索框
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridCRuleTsAb"),value);
		}	
	});
	var p = $('#gridCRuleTsAb').datagrid('getPager');
	    if (p){
	        $(p).pagination({ //设置分页功能栏
	           //分页功能可以通过Pagination的事件调用后台分页功能来实现
	        	onRefresh:function(){
		        	obj.RecRowID=""
		        	obj.gridCRuleTSSpecLoad();
					obj.gridCRuleTSCodeLoad();
					obj.gridCRuleTSResultLoad();
					obj.gridCRuleTsAbRstFlagLoad();
					$("#btnAdd_one").linkbutton("disable");
					$("#btnEdit_one").linkbutton("disable");
					$("#btnDelete_one").linkbutton("disable");
					$("#btnAdd_two").linkbutton("disable");
					$("#btnEdit_two").linkbutton("disable");
					$("#btnDelete_two").linkbutton("disable");
					$("#btnAdd_three").linkbutton("disable");
					$("#btnEdit_three").linkbutton("disable");
					$("#btnDelete_three").linkbutton("disable");
					$("#btnAdd_four").linkbutton("disable");
					$("#btnEdit_four").linkbutton("disable");
					$("#btnDelete_four").linkbutton("disable");
	        	}
	 
	        });
	    }
	//编辑窗体
	obj.SetDiaglog=function(){
		$('#layer').dialog({
			title: '常规检验项目维护编辑',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:false,
			buttons:[{
				text:'保存',
				handler:function(){
					obj.btnSave_click();
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog('#layer').close();
				}
			}]
		});
	}
	//编辑窗体2
	obj.SetDiaglog2=function(){
		$('#layer_two').dialog({
			title: '标本编辑',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:false,
			buttons:[{
				text:'保存',
				handler:function(){
					obj.btnSave2_click();
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog('#layer_two').close();
				}
			}]
		});
	}
	//编辑窗体3
	obj.SetDiaglog3=function(){
		$('#layer_three').dialog({
			title: '检验项目编辑',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:false,
			buttons:[{
				text:'保存',
				handler:function(){
					obj.btnSave3_click();
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog('#layer_three').close();
				}
			}]
		});
	}
	//编辑窗体4
	obj.SetDiaglog4=function(){
		$('#layer_four').dialog({
			title: '检验结果编辑',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:false,
			buttons:[{
				text:'保存',
				handler:function(){
					obj.btnSave4_click();
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog('#layer_four').close();
				}
			}]
		});
	}
	//编辑窗体5
	obj.SetDiaglog5=function(){
		$('#layer_five').dialog({
			title: '异常标志编辑',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:false,
			buttons:[{
				text:'保存',
				handler:function(){
					obj.btnSave5_click();
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog('#layer_five').close();
				}
			}]
		});
	}
	//按钮初始化
    obj.LoadEvent = function(args){ 
    	obj.gridCRuleTsAbLoad();
		obj.gridCRuleTSSpecLoad('');
		$("#btnAdd_one").linkbutton("disable");
		$("#btnEdit_one").linkbutton("disable");
		$("#btnDelete_one").linkbutton("disable");
		$("#btnAdd_two").linkbutton("disable");
		$("#btnEdit_two").linkbutton("disable");
		$("#btnDelete_two").linkbutton("disable");
		$("#btnAdd_three").linkbutton("disable");
		$("#btnEdit_three").linkbutton("disable");
		$("#btnDelete_three").linkbutton("disable");
		$("#btnAdd_four").linkbutton("disable");
		$("#btnEdit_four").linkbutton("disable");
		$("#btnDelete_four").linkbutton("disable");
		//新增
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
    	//修改
		$('#btnEdit').on('click', function(){
			var rd=obj.gridCRuleTsAb.getSelected();
			obj.layer(rd);	
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		//新增
		$('#btnAdd_one').on('click', function(){
			obj.layer_two();
		});
    	//修改
		$('#btnEdit_one').on('click', function(){
			var rd2=obj.gridCRuleTSSpec.getSelected();
			obj.layer_two(rd2);	
		});
		//删除
		$('#btnDelete_one').on('click', function(){
			obj.btnDelete2_click();
		});
		//新增
		$('#btnAdd_two').on('click', function(){
			obj.layer_three();
		});
    	//修改
		$('#btnEdit_two').on('click', function(){
			var rd2=obj.gridCRuleTSCode.getSelected();
			obj.layer_three(rd2);	
		});
		//删除
		$('#btnDelete_two').on('click', function(){
			obj.btnDelete3_click();
		});
		//新增
		$('#btnAdd_three').on('click', function(){
			obj.layer_four();
		});
    	//修改
		$('#btnEdit_three').on('click', function(){
			var rd2=obj.gridCRuleTSResult.getSelected();
			obj.layer_four(rd2);	
		});
		//删除
		$('#btnDelete_three').on('click', function(){
			obj.btnDelete4_click();
		});
		//新增
		$('#btnAdd_four').on('click', function(){
			obj.layer_five();
		});
    	//修改
		$('#btnEdit_four').on('click', function(){
			var rd2=obj.gridCRuleTsAbRstFlag.getSelected();
			obj.layer_five(rd2);	
		});
		//删除
		$('#btnDelete_four').on('click', function(){
			obj.btnDelete5_click();
		});
    }
   
    //双击编辑事件
	obj.gridCRuleTsAb_onDbselect = function(rd){
		obj.layer(rd);
	}
	
	//选择
	obj.gridCRuleTsAb_onSelect = function (){
		var rowData = obj.gridCRuleTsAb.getSelected();
		var Parref  = (rowData ? rowData["ID"] : '');
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			obj.gridCRuleTSSpecLoad(""); 
			obj.gridCRuleTSCodeLoad("");   
			obj.gridCRuleTSResultLoad("");   
			obj.gridCRuleTsAbRstFlagLoad("");  
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridCRuleTsAb.clearSelections();
			$("#btnAdd_one").linkbutton("disable");
			$("#btnAdd_two").linkbutton("disable");
			$("#btnAdd_three").linkbutton("disable");
			$("#btnAdd_four").linkbutton("disable");
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
			$("#btnAdd_one").linkbutton("enable");
			$("#btnAdd_two").linkbutton("enable");
			$("#btnAdd_three").linkbutton("enable");
			$("#btnAdd_four").linkbutton("enable");
			obj.gridCRuleTSSpecLoad(Parref); 
			obj.gridCRuleTSCodeLoad(Parref);   
			obj.gridCRuleTSResultLoad(Parref);   
			obj.gridCRuleTsAbRstFlagLoad(Parref);  
		}
		
	} 
	//双击编辑事件送检标本
	obj.gridCRuleTSSpec_onDbselect = function(rd){
		obj.layer_two(rd);
	}
	//选择送检标本
	obj.gridCRuleTSSpec_onSelect = function (){
		var rowData = obj.gridCRuleTSSpec.getSelected();
		if($("#btnEdit_one").hasClass("l-btn-disabled")) obj.RecRowID1="";
		var rowId = (rowData != null) ? rowData["ID"] : '';
		
		if (rowId == obj.RecRowID1) {
			$("#btnAdd_one").linkbutton("enable");
			$("#btnEdit_one").linkbutton("disable");
			$("#btnDelete_one").linkbutton("disable");
			obj.gridCRuleTSSpec.clearSelections();
		} else {
			$("#btnAdd_one").linkbutton("disable");
			$("#btnEdit_one").linkbutton("enable");
			$("#btnDelete_one").linkbutton("enable");
		}
		obj.RecRowID1 = rowId;
	}
	//双击编辑事件检验项目
	obj.gridCRuleTSCode_onDbselect = function(rd){
		obj.layer_three(rd);
	}
	//选择检验项目
	obj.gridCRuleTSCode_onSelect = function (){
		var rowData = obj.gridCRuleTSCode.getSelected();
		if($("#btnEdit_two").hasClass("l-btn-disabled")) obj.RecRowID2="";
		var rowId = (rowData != null) ? rowData["ID"] : '';
		
		if (rowId == obj.RecRowID2) {
			$("#btnAdd_two").linkbutton("enable");
			$("#btnEdit_two").linkbutton("disable");
			$("#btnDelete_two").linkbutton("disable");
			obj.gridCRuleTSCode.clearSelections();
		} else {
			$("#btnAdd_two").linkbutton("disable");
			$("#btnEdit_two").linkbutton("enable");
			$("#btnDelete_two").linkbutton("enable");
		}
		obj.RecRowID2 = rowId;
	}
	//双击编辑事件检验结果
	obj.gridCRuleTSResult_onDbselect = function(rd){
		obj.layer_four(rd);
	}
	//选择检验结果
	obj.gridCRuleTSResult_onSelect = function (){
		var rowData = obj.gridCRuleTSResult.getSelected();
		if($("#btnEdit_three").hasClass("l-btn-disabled")) obj.RecRowID3="";
		var rowId = (rowData != null) ? rowData["ID"] : '';
		
		if (rowId == obj.RecRowID3) {
			$("#btnAdd_three").linkbutton("enable");
			$("#btnEdit_three").linkbutton("disable");
			$("#btnDelete_three").linkbutton("disable");
			obj.gridCRuleTSResult.clearSelections();
		} else {
			$("#btnAdd_three").linkbutton("disable");
			$("#btnEdit_three").linkbutton("enable");
			$("#btnDelete_three").linkbutton("enable");
		}
		obj.RecRowID3 = rowId;
	}
	//双击编辑事件异常标志
	obj.gridCRuleTsAbRstFlag_onDbselect = function(rd){
		obj.layer_five(rd);
	}
	//选择异常标志
	obj.gridCRuleTsAbRstFlag_onSelect = function (){
		var rowData = obj.gridCRuleTsAbRstFlag.getSelected();
		if($("#btnEdit_four").hasClass("l-btn-disabled")) obj.RecRowID4="";
		var rowId = (rowData != null) ? rowData["ID"] : '';
		
		if (rowId == obj.RecRowID4) {
			$("#btnAdd_four").linkbutton("enable");
			$("#btnEdit_four").linkbutton("disable");
			$("#btnDelete_four").linkbutton("disable");
			obj.gridCRuleTsAbRstFlag.clearSelections();
		} else {
			$("#btnAdd_four").linkbutton("disable");
			$("#btnEdit_four").linkbutton("enable");
			$("#btnDelete_four").linkbutton("enable");
		}
		obj.RecRowID4 = rowId;
	}
	//保存
	obj.btnSave_click = function(){
		var errinfo = "";
		var TestSet = $('#cboTestSet').combobox('getValue');
		var TestCode = $('#txtTestCode').val();
		var IsActive = $('#chkIsActive').checkbox('getValue')? '1':'0';
		var TSPFlag = $('#chkTSPFlag').checkbox('getValue')? '1':'0';
		var TRFFlag = $('#chkTRFFlag').checkbox('getValue')? '1':'0';
		var TRFlag= $('#chkTRFlag').checkbox('getValue')? '1':'0';
		var TRVMaxFlag = $("#chkTRMaxFlg").checkbox('getValue')? '1':'0';
		var MaxValM = $('#txtMaxValM').val();
		var MaxValF = $('#txtMaxValF').val();
		var TRVMinFlag = $("#chkTRMinFlg").checkbox('getValue')? '1':'0';
		var MinValM = $('#txtMinValM').val();
		var MinValF = $('#txtMinValF').val();
		
		
		if (!TestSet) {
			errinfo = errinfo + "常规检验不允许为空!<br>";
		}	
		if (!TestCode) {
			errinfo = errinfo + "检验项目不允许为空!<br>";
		}	
		if (parseInt(MaxValM)  < parseInt(MinValM)) {
		    errinfo = errinfo + "上限值(男)不能低于下限值(男)";
		}
		if (parseInt(MaxValF)  < parseInt(MinValF)  ) {
		     errinfo = errinfo + "上限值(女)不能低于下限值(女)";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var InputStr = obj.RecRowID;
		InputStr += "^" + TestSet;
		InputStr += "^" + TestCode;
		InputStr += "^" + IsActive;  
		InputStr += "^" + TSPFlag; 
		InputStr += "^" + TRFFlag; 
		InputStr += "^" + TRFlag;  
		InputStr += "^" + TRVMaxFlag;
		InputStr += "^" + MaxValM; 
		InputStr += "^" + MaxValF; 
		InputStr += "^" + TRVMinFlag;
		InputStr += "^" + MinValM; 
		InputStr += "^" + MinValF; 
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleTestAb",
			MethodName:"Update",
			InStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if(parseInt(flg)=='-2'){
				$.messager.alert("错误提示" , '检验医嘱、检验项目重复!');
			}else{
				$.messager.alert("错误提示" , '保存失败');
			} 
		}else {
			$HUI.dialog('#layer').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			if (obj.RecRowID == flg) {  //修改
				obj.RecRowID = "";			
				obj.gridCRuleTSSpecLoad("");
				obj.gridCRuleTSCodeLoad("");   
				obj.gridCRuleTSResultLoad("");   
				obj.gridCRuleTsAbRstFlagLoad("");
				$("#btnAdd_one").linkbutton("disable");
				$("#btnAdd_two").linkbutton("disable");
				$("#btnAdd_three").linkbutton("disable");
				$("#btnAdd_four").linkbutton("disable");
			}			
			obj.gridCRuleTsAbLoad(); //刷新当前页
		}
	}
	//删除常规检验项目
	obj.btnDelete_click = function(){
		if (obj.RecRowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CRuleTestAb",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridCRuleTsAbLoad();  //刷新当前页
					obj.gridCRuleTSSpecLoad("");
					obj.gridCRuleTSCodeLoad("");   
					obj.gridCRuleTSResultLoad("");   
					obj.gridCRuleTsAbRstFlagLoad("");
					$("#btnAdd_one").linkbutton("disable");
					$("#btnAdd_two").linkbutton("disable");
					$("#btnAdd_three").linkbutton("disable");
					$("#btnAdd_four").linkbutton("disable");
				}
			} 
		});
	}
	//配置窗体-初始化
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID = rd["ID"];
			var TestSet = rd["TestSet"];
			var TestCode = rd["TestCode"];
			var IsActive = rd["IsActive"];
			IsActive = (IsActive=="1"? true: false)
			var TSPFlag = rd["TSPFlag"];
			TSPFlag = (TSPFlag=="1"? true: false)
			var TRFFlag = rd["TRFFlag"];
			TRFFlag = (TRFFlag=="1"? true: false)
			var TRFlag = rd["TRFlag"];
			TRFlag = (TRFlag=="1"? true: false)
			var TRVMaxFlag = rd["TRVMaxFlag"];
			TRVMaxFlag = (TRVMaxFlag=="1"? true: false)
			var MaxValM = rd["MaxValM"];
			var MaxValF = rd["MaxValF"];
			var TRVMinFlag = rd["TRVMinFlag"];
			var MinValM = rd["MinValM"];
			var MinValF = rd["MinValF"];
			
			$('#cboTestSet').combobox('setValue',TestSet);
			$('#txtTestCode').val(TestCode);
			$('#chkIsActive').checkbox('setValue',IsActive);
			$('#chkTSPFlag').checkbox('setValue',TSPFlag);
			$('#chkTRFFlag').checkbox('setValue',TRFFlag);
			$('#chkTRFlag').checkbox('setValue',TRFlag);
			$('#chkTRMaxFlg').checkbox('setValue',TRVMaxFlag);
			$('#txtMaxValM').val(MaxValM);
			$('#txtMaxValF').val(MaxValF);
			$('#chkTRMinFlg').checkbox('setValue',TRVMinFlag);
			$('#txtMinValM').val(MinValM);
			$('#txtMinValF').val(MinValF);
		}else{
			obj.RecRowID = "";
			$('#cboTestSet').combobox('clear');
			$('#txtTestCode').val('');
			$('#chkIsActive').checkbox('setValue',false);
			$('#chkTSPFlag').checkbox('setValue',false);
			$('#chkTRFFlag').checkbox('setValue',false);
			$('#chkTRFlag').checkbox('setValue',false);
			$('#chkTRMaxFlg').checkbox('setValue',false);
			$('#txtMaxValM').val('');
			$('#txtMaxValF').val('');
			$('#chkTRMinFlg').checkbox('setValue',false);
			$('#txtMinValM').val('');
			$('#txtMinValF').val('');
			
		}
		$('#layer').show();
		obj.SetDiaglog();
	}
	obj.gridCRuleTsAbLoad = function(){
		//$("#gridCRuleTsAb").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CRuleTestSrv",
			QueryName:"QryCRuleTestAb",		
	    	page:1,
			rows:999
		},function(rs){
			$('#gridCRuleTsAb').datagrid('loadData', rs);					
		});
    }
    //保存送检标本
    obj.btnSave2_click = function(){
		var errinfo = "";
		var SpecDescDr = $('#cboTestSpec').combobox('getValue');
	    var ActUserDr  = $.LOGON.USERID;
		//var Parref = obj.gridCRuleTsAb.getSelected();
		var ParrefID=obj.RecRowID;
		//var ID  = obj.gridCRuleTSSpec.getSelected();
		var SubID      = (obj.RecRowID1 ?obj.RecRowID1.split("||")[1] : ''); 
		
		var InputStr = ParrefID;
		InputStr += "^" + SubID;
		InputStr += "^" + SpecDescDr;
		InputStr += "^" + ''; 
		InputStr += "^" + '';
		InputStr += "^" + ActUserDr;
		
		if (!SpecDescDr) {
			errinfo = errinfo + "标本不允许为空!<br>";
		}	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleTestSpec",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)=='-2') {
				$.messager.alert("错误提示" , '该标本已关联项目,不允许再关联其他项目');
			} else{
				$.messager.alert("错误提示" , '保存失败!');
			}
		}else {
			$HUI.dialog('#layer_two').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID1 = flg;
			obj.gridCRuleTSSpecLoad(ParrefID); //刷新当前页
		}
	}
	//保存检验项目
    obj.btnSave3_click = function(){
		var errinfo = "";
		var TestCodeDr = $('#cboTestCode').combobox('getValue');
	    var ActUserDr  = $.LOGON.USERID;
		var Parref = obj.gridCRuleTsAb.getSelected();
		var ParrefID  = (Parref ? Parref["ID"] : '');
		//var ID  = obj.gridCRuleTSCode.getSelected();
		var SubID      = (obj.RecRowID2 ?obj.RecRowID2.split("||")[1] : ''); 
		
		var InputStr = ParrefID;
		InputStr += "^" + SubID;
		InputStr += "^" + TestCodeDr;
		InputStr += "^" + ''; 
		InputStr += "^" + '';
		InputStr += "^" + ActUserDr;
		
		if (!TestCodeDr) {
			errinfo = errinfo + "检验项目不允许为空!<br>";
		}	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleTestCode",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)=='-2') {
				$.messager.alert("错误提示" , '该检验项目已关联检验,不允许再关联其他检验');
			} else{
				$.messager.alert("错误提示" , '保存失败!');
			}
		}else {
			$HUI.dialog('#layer_three').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID2 = flg;
			obj.gridCRuleTSCodeLoad(ParrefID); //刷新当前页
		}
	}
	//保存检验结果
    obj.btnSave4_click = function(){
		var errinfo = "";
		var TestResultDr = $('#cboTestResult').combobox('getValue');
	    var ActUserDr  = $.LOGON.USERID;
		var Parref = obj.gridCRuleTsAb.getSelected();
		var ParrefID  = (Parref ? Parref["ID"] : '');
		//var ID  = obj.gridCRuleTSResult.getSelected();
		var SubID      = (obj.RecRowID3 ?obj.RecRowID3.split("||")[1] : ''); 
		
		var InputStr = ParrefID;
		InputStr += "^" + SubID;
		InputStr += "^" + TestResultDr;
		InputStr += "^" + ''; 
		InputStr += "^" + '';
		InputStr += "^" + ActUserDr;
		
		if (!TestResultDr) {
			errinfo = errinfo + "检验结果不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}	
		
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleTestResult",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)=='-2') {
				$.messager.alert("错误提示" , '该检验结果已关联项目,不允许再关联其他项目');
			} else{
				$.messager.alert("错误提示" , '保存失败!');
			}
		}else {
			$HUI.dialog('#layer_four').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID3 = flg;
			obj.gridCRuleTSResultLoad(ParrefID); //刷新当前页
		}
	}
	//保存异常标志
    obj.btnSave5_click = function(){
		var errinfo = "";
		var RstFlagDr = $('#cboRstFlag').combobox('getValue');
	    var ActUserDr  = $.LOGON.USERID;
		var Parref = obj.gridCRuleTsAb.getSelected();
		var ParrefID  = (Parref ? Parref["ID"] : '');
		//var ID  = obj.gridCRuleTsAbRstFlag.getSelected();
		var SubID      = (obj.RecRowID4 ?obj.RecRowID4.split("||")[1] : ''); 
		
		var InputStr = ParrefID;
		InputStr += "^" + SubID;
		InputStr += "^" + RstFlagDr;
		InputStr += "^" + ''; 
		InputStr += "^" + '';
		InputStr += "^" + ActUserDr;
		
		if (!RstFlagDr) {
			errinfo = errinfo + "异常标志不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}	
		
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleTestAbFlag",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)=='-2') {
				$.messager.alert("错误提示" , '该异常标志已关联项目,不允许再关联其他项目');
			} else{
				$.messager.alert("错误提示" , '保存失败!');
			}
		}else {
			$HUI.dialog('#layer_five').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID4 = flg;
			obj.gridCRuleTsAbRstFlagLoad(ParrefID); //刷新当前页
		}
	}
	//删除标本
	obj.btnDelete2_click = function(){
		var rowData = obj.gridCRuleTsAb.getSelected();
		var Parref  = (rowData ? rowData["ID"] : '');
		var CRulerd = obj.gridCRuleTSSpec.getSelected();
		var selectedID  = (CRulerd ? CRulerd["ID"] : '');
		if (selectedID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CRuleTestSpec",
					MethodName:"DeleteById",
					aId:selectedID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID1 = "";
					obj.gridCRuleTSSpecLoad(Parref); //刷新当前页
					$("#btnAdd_one").linkbutton("enable");
					$("#btnEdit_one").linkbutton("disable");
					$("#btnDelete_one").linkbutton("disable");
				}
			} 
		});
	}
	//删除检验项目
	obj.btnDelete3_click = function(){
		var rowData = obj.gridCRuleTsAb.getSelected();
		var Parref  = (rowData ? rowData["ID"] : '');
		var CRulerd = obj.gridCRuleTSCode.getSelected();
		var selectedID  = (CRulerd ? CRulerd["ID"] : '');
		if (selectedID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CRuleTestCode",
					MethodName:"DeleteById",
					aId:selectedID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID2 = "";
					obj.gridCRuleTSCodeLoad(Parref);  //刷新当前页
					$("#btnAdd_two").linkbutton("enable");
					$("#btnEdit_two").linkbutton("disable");
					$("#btnDelete_two").linkbutton("disable");
				}
			} 
		});
	}
	//删除送检结果
	obj.btnDelete4_click = function(){
		var rowData = obj.gridCRuleTsAb.getSelected();
		var Parref  = (rowData ? rowData["ID"] : '');
		var CRulerd = obj.gridCRuleTSResult.getSelected();
		var selectedID  = (CRulerd ? CRulerd["ID"] : '');
		if (selectedID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CRuleTestResult",
					MethodName:"DeleteById",
					aId:selectedID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID3 = "";
					obj.gridCRuleTSResultLoad(Parref);  //刷新当前页
					$("#btnAdd_three").linkbutton("enable");
					$("#btnEdit_three").linkbutton("disable");
					$("#btnDelete_three").linkbutton("disable");
				}
			} 
		});
	}
	//删除异常标志
	obj.btnDelete5_click = function(){
		var rowData = obj.gridCRuleTsAb.getSelected();
		var Parref  = (rowData ? rowData["ID"] : '');
		var CRulerd = obj.gridCRuleTsAbRstFlag.getSelected();
		var selectedID  = (CRulerd ? CRulerd["ID"] : '');
		if (selectedID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CRuleTestAbFlag",
					MethodName:"DeleteById",
					aId:selectedID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID4 = "";
					obj.gridCRuleTsAbRstFlagLoad(Parref);  //刷新当前页
					$("#btnAdd_four").linkbutton("enable");
					$("#btnEdit_four").linkbutton("disable");
					$("#btnDelete_four").linkbutton("disable");
				}
			} 
		});
	}
	//配置窗体-标本初始化
	obj.layer_two= function(rd){
		if(rd){
			obj.RecRowID1 = rd["ID"];
			//var TSSpec = rd["TSSpec"];
			var TSSpecID = rd["TSSpecID"];
			
			$('#cboTestSpec').combobox('setValue',TSSpecID);
		}else{
			obj.RecRowID1 = "";
			$('#cboTestSpec').combobox('setValue','');
			
		}
		$('#layer_two').show();
		obj.SetDiaglog2();
		
	}
	//配置窗体-项目初始化
	obj.layer_three= function(rd){
		if(rd){
			obj.RecRowID2 = rd["ID"];
			var TCMDesc = rd["TCMDesc"];
			var TCMID = rd["TCMID"];
			
			$('#cboTestCode').combobox('setValue',TCMID);
		}else{
			obj.RecRowID2 = "";
			$('#cboTestCode').combobox('setValue','');
		}
		$('#layer_three').show();
		obj.SetDiaglog3();
		
	}
	//配置窗体-标本结果初始化
	obj.layer_four= function(rd){
		 var TSrd =  obj.gridCRuleTSCode.getSelected();
		if(rd){
			obj.RecRowID3 = rd["ID"];
			var TCMapAbID=rd["TCMapAbID"];
			//var TestCode = rd["TestCode"];
			var TestID=rd["TestID"];
			//var TestResult = rd["TestResult"];
			
			$('#cboTestCode1').combobox('setValue',TCMapAbID);
			$('#cboTestResult').combobox('setValue',TestID);
		}else{
			obj.RecRowID3 = "";
			if (TSrd) {
				//var TCMCode= TSrd["TCMCode"];
				var TCMID= TSrd["TCMID"];
				$('#cboTestCode1').combobox('setValue',TCMID);
			}else{
				var TCMID = obj.gridCRuleTSCode.getData()['rows'].length>0 ? obj.gridCRuleTSCode.getData()['rows'][0]["TCMID"] : '';
				$('#cboTestCode1').combobox('setValue',TCMID);
				$('#cboTestResult').combobox('setValue','');
			}
			
		}
		$('#layer_four').show();
		obj.SetDiaglog4();
	}
	//配置窗体-标本异常初始化
	obj.layer_five= function(rd){
		var TSrd =  obj.gridCRuleTSCode.getSelected();
		if(rd){
			obj.RecRowID4 = rd["ID"];
			var TCMapAbID=rd["TCMapAbID"];
			//var TestCode = rd["TestCode"];
			//var TSRstFlag = rd["TSRstFlag"];
			var TSRstID = rd["TSRstID"];
			
			$('#cboTestCode2').combobox('setValue',TCMapAbID);
			$('#cboRstFlag').combobox('setValue',TSRstID);
		}else{
			obj.RecRowID4 = "";
			if (TSrd) {
				//var TCMCode= TSrd["TCMCode"];
				var TCMID= TSrd["TCMID"];
				$('#cboTestCode2').combobox('setValue',TCMID);
			}else{
				var TCMID = obj.gridCRuleTSCode.getData()['rows'].length>0 ? obj.gridCRuleTSCode.getData()['rows'][0]["TCMID"] : '';
				$('#cboTestCode2').combobox('setValue',TCMID);
				$('#cboRstFlag').combobox('setValue','');
			}
		}
		$('#layer_five').show();
		obj.SetDiaglog5();
	}
	
	obj.gridCRuleTSSpecLoad = function(aRuleID){
		$("#gridCRuleTSSpec").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CRuleTestSrv",
			QueryName:"QryTSSpecByTsAb",	
			aTsAbID:aRuleID,	
	    	page:1,
			rows:999
		},function(rs){
			$('#gridCRuleTSSpec').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
		obj.gridCRuleTSSpec_onSelect();
    }
	obj.gridCRuleTSCodeLoad = function(aRuleID){
		$("#gridCRuleTSCode").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CRuleTestSrv",
			QueryName:"QryTSCodeByTsAb",	
			aTsAbID:aRuleID,	
	    	page:1,
			rows:999
		},function(rs){
			$('#gridCRuleTSCode').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
			//加载检验结果下拉框
			var cboTestCode1Data = []
			for (var i=0; i<rs.rows.length; i++) {
				cboTestCode1Data.push({TCMID: rs.rows[i].TCMID, TCMCode: rs.rows[i].TCMCode + " " + rs.rows[i].TCMDesc});
			}
			$('#cboTestCode1').combobox('loadData', cboTestCode1Data);
			$('#cboTestCode2').combobox('loadData', cboTestCode1Data);
		});
		obj.gridCRuleTSCode_onSelect();
    }
	obj.gridCRuleTSResultLoad = function(aRuleID){
		originalData["gridCRuleTSResult"]="";
		$("#gridCRuleTSResult").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CRuleTestSrv",
			QueryName:"QryTSResultByTsAb",	
			aTsAbID:aRuleID,	
	    	page:1,
			rows:999
		},function(rs){
			$('#gridCRuleTSResult').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
		obj.gridCRuleTSResult_onSelect();
    }
	obj.gridCRuleTsAbRstFlagLoad = function(aRuleID){
		originalData["gridCRuleTsAbRstFlag"]="";
		$("#gridCRuleTsAbRstFlag").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CRuleTestSrv",
			QueryName:"QryTSAbFlagByTsAb",	
			aTsAbID:aRuleID,	
	    	page:1,
			rows:999
		},function(rs){
			$('#gridCRuleTsAbRstFlag').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
		obj.gridCRuleTsAbRstFlag_onSelect();
    }
	
}