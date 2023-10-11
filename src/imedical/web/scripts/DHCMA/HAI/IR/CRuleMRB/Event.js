//页面Event
function InitDictionaryWinEvent(obj){
	//检索框
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridCRuleMRB"),value);
		}	
	});
	var p = $('#gridCRuleMRB').datagrid('getPager');
	if (p){
		$(p).pagination({ //设置分页功能栏
			//分页功能可以通过Pagination的事件调用后台分页功能来实现
	        onRefresh:function(){
				obj.RecRowID=""
		       	obj.gridCRuleMRBLoad();
				obj.gridMRBBactLoad('');
				$("#btnAdd_one").linkbutton("disable");
				$("#btnEdit_one").linkbutton("disable");
				$("#btnDelete_one").linkbutton("disable");
				$("#btnAdd_two").linkbutton("disable");
				$("#btnEdit_two").linkbutton("disable");
				$("#btnDelete_two").linkbutton("disable");
				$("#btnAdd_three").linkbutton("disable");
				$("#btnEdit_three").linkbutton("disable");
				$("#btnDelete_three").linkbutton("disable");
				$("#btnAdd_four").linkbutton("disable")
				$("#btnEdit_four").linkbutton("disable");
				$("#btnDelete_four").linkbutton("disable");
	        }
		});
	}
	//编辑窗体
	obj.SetDiaglog=function(){
		$('#layer').dialog({
			title: '多重耐药菌分类编辑',
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
			title: '细菌编辑',
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
			title: '抗生素编辑',
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
			title: '关键词编辑',
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
			title: '隔离医嘱编辑',
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
    	obj.gridCRuleMRBLoad();
		obj.gridMRBBactLoad('');
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
			var rd=obj.gridCRuleMRB.getSelected();
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
			var rd2=obj.gridMRBBact.getSelected();
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
			var rd2=obj.gridMRBAnti.getSelected();
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
			var rd2=obj.gridMRBKeys.getSelected();
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
			var rd2=obj.gridIsolate.getSelected();
			obj.layer_five(rd2);	
		});
		//删除
		$('#btnDelete_four').on('click', function(){
			obj.btnDelete5_click();
		});
    }
    
    //双击编辑事件
	obj.gridCRuleMRB_onDbselect = function(rd){
		obj.layer(rd);
	}
	
	//选择
	obj.gridCRuleMRB_onSelect = function (){
		var rowData = obj.gridCRuleMRB.getSelected();
		var Parref  = (rowData ? rowData["ID"] : '');
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			obj.gridMRBBactLoad("");
			obj.gridMRBAntiLoad("");   
			obj.gridMRBKeysLoad("");   
			obj.gridIsolateLoad("");  
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridCRuleMRB.clearSelections();
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
		
			obj.gridMRBBactLoad(Parref); 
			obj.gridMRBAntiLoad(Parref);   
			obj.gridMRBKeysLoad(Parref);   
			obj.gridIsolateLoad(Parref);  
		}
	} 
	//双击编辑事件送检标本
	obj.gridMRBBact_onDbselect = function(rd){
		obj.layer_two(rd);
	}
	//选择送检标本
	obj.gridMRBBact_onSelect = function (){
		var rowData = obj.gridMRBBact.getSelected();
		if($("#btnEdit_one").hasClass("l-btn-disabled")) obj.RecRowID1="";
		var rowId = (rowData != null) ? rowData["ID"] : '';
		
		if (rowId == obj.RecRowID1) {
			$("#btnAdd_one").linkbutton("enable");
			$("#btnEdit_one").linkbutton("disable");
			$("#btnDelete_one").linkbutton("disable");
			obj.gridMRBBact.clearSelections();
		} else {
			$("#btnAdd_one").linkbutton("disable");
			$("#btnEdit_one").linkbutton("enable");
			$("#btnDelete_one").linkbutton("enable");
		}
		obj.RecRowID1 = rowId;
	}
	//双击编辑事件检验项目
	obj.gridMRBAnti_onDbselect = function(rd){
		obj.layer_three(rd);
	}
	//选择检验项目
	obj.gridMRBAnti_onSelect = function (){
		var rowData = obj.gridMRBAnti.getSelected();
		if($("#btnEdit_two").hasClass("l-btn-disabled")) obj.RecRowID2="";
		var rowId = (rowData != null) ? rowData["ID"] : '';
		
		if (rowId == obj.RecRowID2) {
			$("#btnAdd_two").linkbutton("enable");
			$("#btnEdit_two").linkbutton("disable");
			$("#btnDelete_two").linkbutton("disable");
			obj.gridMRBAnti.clearSelections();
		} else {
			$("#btnAdd_two").linkbutton("disable");
			$("#btnEdit_two").linkbutton("enable");
			$("#btnDelete_two").linkbutton("enable");
		}
		obj.RecRowID2 = rowId;
	}
	//双击编辑事件检验结果
	obj.gridMRBKeys_onDbselect = function(rd){
		obj.layer_four(rd);
	}
	//选择检验结果
	obj.gridMRBKeys_onSelect = function (){
		var rowData = obj.gridMRBKeys.getSelected();
		if($("#btnEdit_three").hasClass("l-btn-disabled")) obj.RecRowID3="";
		var rowId = (rowData != null) ? rowData["ID"] : '';
		
		if (rowId == obj.RecRowID3) {
			$("#btnAdd_three").linkbutton("enable");
			$("#btnEdit_three").linkbutton("disable");
			$("#btnDelete_three").linkbutton("disable");
			obj.gridMRBKeys.clearSelections();
		} else {
			$("#btnAdd_three").linkbutton("disable");
			$("#btnEdit_three").linkbutton("enable");
			$("#btnDelete_three").linkbutton("enable");
		}
		obj.RecRowID3 = rowId;
	}
	//双击编辑事件异常标志
	obj.gridIsolate_onDbselect = function(rd){
		obj.layer_five(rd);
	}
	//选择异常标志
	obj.gridIsolate_onSelect = function (){
		var rowData = obj.gridIsolate.getSelected();
		if($("#btnEdit_four").hasClass("l-btn-disabled")) obj.RecRowID4="";
		var rowId = (rowData != null) ? rowData["ID"] : '';
		
		if (rowId == obj.RecRowID4) {
			$("#btnAdd_four").linkbutton("enable");
			$("#btnEdit_four").linkbutton("disable");
			$("#btnDelete_four").linkbutton("disable");
			obj.gridIsolate.clearSelections();
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
		var BTCode = $('#txtBTCode').val();
		var BTDesc = $('#txtBTDesc').val();
		var MRBCatDr = $('#cboMRBCat').combobox('getValue');
		var IsActive = $('#chkIsActive').checkbox('getValue')? '1':'0';
		var ActUser     = $.LOGON.USERID;
		var IsRuleCheck = $('#chkIsRuleCheck').checkbox('getValue')? '1':'0';
		var IsAntiCheck= $('#chkIsAntiCheck').checkbox('getValue')? '1':'0';
		var AnitCatCnt = $('#txtAnitCatCnt').val();
		var AnitCatCnt2 = $('#txtAnitCatCnt2').val();
		var IsKeyCheck = $("#chkIsKeyCheck").checkbox('getValue')? '1':'0';
		var Note =$('#txtNote').val();
		var IsIRstCheck = $("#chkIsIRstCheck").checkbox('getValue')? '1':'0';
		var IsResKeyCheck = $("#chkIsResKeyCheck").checkbox('getValue')? '1':'0';
		
		if (!BTCode) {
			errinfo = errinfo + "代码不允许为空!<br>";
		}	
		if (!BTDesc) {
			errinfo = errinfo + "名称不允许为空!<br>";
		}	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var InputStr = obj.RecRowID;
		InputStr += "^" + BTCode;
		InputStr += "^" + BTDesc;
		InputStr += "^" + MRBCatDr;
		InputStr += "^" + IsActive;
		InputStr += "^" + IsRuleCheck;
		InputStr += "^" + IsAntiCheck
		InputStr += "^" + AnitCatCnt;
		InputStr += "^" + AnitCatCnt2;
		InputStr += "^" + IsKeyCheck;
		InputStr += "^" +'';
		InputStr += "^" +'';
		InputStr += "^" + ActUser;
		InputStr += "^" + Note;
		InputStr += "^" + IsIRstCheck;
		InputStr += "^" + IsResKeyCheck;
		
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleMRB",
			MethodName:"Update",
			InStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if(parseInt(flg)=='-2'){
				$.messager.alert("错误提示" , '代码重复!');
			}else{
				$.messager.alert("错误提示" , '保存失败');
			} 
		}else {
			$HUI.dialog('#layer').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			if (obj.RecRowID == flg) {  //修改
				obj.RecRowID = "";			
				obj.gridMRBBactLoad("");
				obj.gridMRBAntiLoad("");   
				obj.gridMRBKeysLoad("");   
				obj.gridIsolateLoad("");
				$("#btnAdd_one").linkbutton("disable");
				$("#btnAdd_two").linkbutton("disable");
				$("#btnAdd_three").linkbutton("disable");
				$("#btnAdd_four").linkbutton("disable");
			}			
			obj.gridCRuleMRBLoad(); //刷新当前页
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
					ClassName:"DHCHAI.IR.CRuleMRB",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridCRuleMRBLoad();  //刷新当前页
					$("#btnAdd_one").linkbutton("disable");
					$("#btnAdd_two").linkbutton("disable");
					$("#btnAdd_three").linkbutton("disable");
					$("#btnAdd_four").linkbutton("disable");
					obj.gridMRBBactLoad("");
					obj.gridMRBAntiLoad("");
					obj.gridMRBKeysLoad("");
					obj.gridIsolateLoad("");
				}
			} 
		});
	}
	//配置窗体-初始化
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID = rd["ID"];
			var BTCode = rd["BTCode"];
			var BTDesc = rd["BTDesc"];
			//var BTCatDesc = rd["BTCatDesc"];
			var BTCatDr = rd["BTCatDr"];
			var BTIsActive = rd["BTIsActive"];
			BTIsActive = (BTIsActive=="1"? true: false)
			var IsRuleCheck = rd["IsRuleCheck"];
			IsRuleCheck = (IsRuleCheck=="1"? true: false)
			var IsAntiCheck = rd["IsAntiCheck"];
			IsAntiCheck = (IsAntiCheck=="1"? true: false)
			var AnitCatCnt = rd["AnitCatCnt"];
			var AnitCatCnt2 = rd["AnitCatCnt2"];
			var IsKeyCheck = rd["IsKeyCheck"];
			IsKeyCheck = (IsKeyCheck=="1"? true: false)
			var Note  = rd["RuleNote"];
			var IsIRstCheck= rd["IsIRstCheck"];
			var IsResKeyCheck= rd["IsResKeyCheck"];
			IsIRstCheck = (IsIRstCheck=="1"? true: false);
			IsResKeyCheck = (IsResKeyCheck=="1"? true: false);
			
			$('#txtBTCode').val(BTCode);
			$('#txtBTDesc').val(BTDesc);
			$('#cboMRBCat').combobox('setValue',BTCatDr);
			$('#chkIsActive').checkbox('setValue',BTIsActive);
			$('#chkIsRuleCheck').checkbox('setValue',IsRuleCheck);
			$('#chkIsAntiCheck').checkbox('setValue',IsAntiCheck);
			$('#txtAnitCatCnt').val(AnitCatCnt);
			$('#txtAnitCatCnt2').val(AnitCatCnt2);
			$('#chkIsKeyCheck').checkbox('setValue',IsKeyCheck);
			$('#chkIsIRstCheck').checkbox('setValue',IsIRstCheck);
			$('#chkIsResKeyCheck').checkbox('setValue',IsResKeyCheck);
			$('#txtNote').val(Note);
		}else{
			obj.RecRowID = "";
			
			$('#txtBTCode').val('');
			$('#txtBTDesc').val('');
			$('#cboMRBCat').combobox('setValue','');
			$('#chkIsActive').checkbox('setValue',false);
			$('#chkIsRuleCheck').checkbox('setValue',false);
			$('#chkIsAntiCheck').checkbox('setValue',false);
			$('#txtAnitCatCnt').val('');
			$('#txtAnitCatCnt2').val('');
			$('#chkIsKeyCheck').checkbox('setValue',false);
			$('#chkIsIRstCheck').checkbox('setValue',false);
			$('#chkIsResKeyCheck').checkbox('setValue',false);
			$('#txtNote').val('');
		}
		$('#layer').show();
		obj.SetDiaglog();
	}
	obj.gridCRuleMRBLoad = function(){
		originalData["gridCRuleMRB"]="";
		//$("#gridCRuleMRB").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CRuleMRBSrv",
			QueryName:"QryCRuleMRB",		
	    	page:1,
			rows:999
		},function(rs){
			$('#gridCRuleMRB').datagrid('loadData', rs);			
		});
    }
    //保存细菌名称
    obj.btnSave2_click = function(){
		var errinfo = "";
		var BactDr = $('#cboBact').combobox('getValue');
		var Parref = obj.gridCRuleMRB.getSelected();
		var ParrefID=Parref["ID"];
		//var ID  = obj.gridMRBBact.getSelected();
		var SubID      = (obj.RecRowID1 ?obj.RecRowID1.split("||")[1] : ''); 
		
		var InputStr = ParrefID;
		InputStr += "^" + SubID;
		InputStr += "^" + BactDr;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERID;
		
		if (!BactDr) {
			errinfo = errinfo + "细菌不允许为空!<br>";
		}	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleMRBBact",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)=='-2') {
				$.messager.alert("错误提示" , '细菌名称重复!');
			} else{
				$.messager.alert("错误提示" , '保存失败!');
			}
		}else {
			$HUI.dialog('#layer_two').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID1 = flg;
			obj.gridMRBBactLoad(ParrefID); //刷新当前页
		}
	}
	//保存抗生素
    obj.btnSave3_click = function(){
		var errinfo = "";
		var AntiCatDr = $('#cboLabAntiCat').combobox('getValue');
		var AntiDr = $('#cboLabAnti').combobox('getValue');
	    var ActUserDr  = $.LOGON.USERID;
		var Parref = obj.gridCRuleMRB.getSelected();
		var ParrefID  = (Parref ? Parref["ID"] : '');
		//var ID  = obj.gridMRBAnti.getSelected();
		var SubID      = (obj.RecRowID2 ?obj.RecRowID2.split("||")[1] : ''); 
		if ((AntiCatDr==0)&&(AntiDr !="")) {
			var AntiCatInfo = $m({
				ClassName:"DHCHAI.DPS.LabAntiSrv",
				MethodName:"GetCatByAnti",
				aAntiID:AntiDr
			},false);
			AntiCatDr = (AntiCatInfo ? AntiCatInfo.split("^")[0] : '');
		}
		
		var InputStr = ParrefID;
		InputStr += "^" + SubID;
		InputStr += "^" + AntiCatDr;
		InputStr += "^" + AntiDr;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + ActUserDr;
		if (AntiCatDr == "") {
			errinfo = errinfo + "抗生素分类不能为空!<br>";
		}
		if ((AntiCatDr == '')&&(AntiDr!="")) {
			errinfo = errinfo + "抗生素没有关联的分类!<br>";
		}
		if ((AntiCatDr == "0")&&(AntiDr =='')) {
			errinfo = errinfo + "抗生素分类为全部,抗生素不允许为空!<br>";
		}	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleMRBAnti",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)=='-2') {
				$.messager.alert("错误提示" , '已存在该抗生素分类及其抗生素，请勿重复新增!');
			} else{
				$.messager.alert("错误提示" , '保存失败!');
			}
		}else {
			$HUI.dialog('#layer_three').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID2 = flg;
			obj.gridMRBAntiLoad(ParrefID); //刷新当前页
		}
	}
	//保存关键词
    obj.btnSave4_click = function(){
		var errinfo = "";
		var KeyWord = $('#txtKeyWord').val();
	    var ActUserDr  = $.LOGON.USERID;
		var Parref = obj.gridCRuleMRB.getSelected();
		var ParrefID  = (Parref ? Parref["ID"] : '');
		//var ID  = obj.gridMRBKeys.getSelected();
		var SubID      = (obj.RecRowID3 ?obj.RecRowID3.split("||")[1] : ''); 
		
		var InputStr = ParrefID;
		InputStr += "^" + SubID;
		InputStr += "^" + KeyWord;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + ActUserDr;
		
		if (!KeyWord) {
			errinfo = errinfo + "关键词不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}	
		
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleMRBKeys",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)=='-2') {
				$.messager.alert("错误提示" , '关键词重复!');
			} else{
				$.messager.alert("错误提示" , '保存失败!');
			}
		}else {
			$HUI.dialog('#layer_four').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID3 = flg;
			obj.gridMRBKeysLoad(ParrefID); //刷新当前页
		}
	}
	//保存异常标志
    obj.btnSave5_click = function(){
		var errinfo = "";
		var OEOrdDr = $('#cboOEOrd').combobox('getValue');
	    var ActUserDr  = $.LOGON.USERID;
		var Parref = obj.gridCRuleMRB.getSelected();
		var ParrefID  = (Parref ? Parref["ID"] : '');
		//var ID  = obj.gridIsolate.getSelected();
		var SubID      = (obj.RecRowID4 ?obj.RecRowID4.split("||")[1] : ''); 
		
		var InputStr = ParrefID;
		InputStr += "^" + SubID;
		InputStr += "^" + OEOrdDr;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + ActUserDr;
		
		if (!OEOrdDr) {
			errinfo = errinfo + "隔离医嘱不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}	
		
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleMRBOEOrd",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)=='-2') {
				$.messager.alert("错误提示" , '隔离医嘱名称重复!');
			} else{
				$.messager.alert("错误提示" , '保存失败!');
			}
		}else {
			$HUI.dialog('#layer_five').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID4 = flg;
			obj.gridIsolateLoad(ParrefID); //刷新当前页
		}
	}
	//删除细菌
	obj.btnDelete2_click = function(){
		var rowData = obj.gridCRuleMRB.getSelected();
		var Parref  = (rowData ? rowData["ID"] : '');
		var CRulerd = obj.gridMRBBact.getSelected();
		var selectedID  = (CRulerd ? CRulerd["ID"] : '');
		if (selectedID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CRuleMRBBact",
					MethodName:"DeleteById",
					aId:selectedID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID1 = "";
					obj.gridMRBBactLoad(Parref); //刷新当前页
					$("#btnAdd_one").linkbutton("enable");
					$("#btnEdit_one").linkbutton("disable");
					$("#btnDelete_one").linkbutton("disable");
				}
			} 
		});
	}
	//删除抗生素
	obj.btnDelete3_click = function(){
		var rowData = obj.gridCRuleMRB.getSelected();
		var Parref  = (rowData ? rowData["ID"] : '');
		var CRulerd = obj.gridMRBAnti.getSelected();
		var selectedID  = (CRulerd ? CRulerd["ID"] : '');
		if (selectedID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CRuleMRBAnti",
					MethodName:"DeleteById",
					aId:selectedID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID2 = "";
					obj.gridMRBAntiLoad(Parref);  //刷新当前页
					$("#btnAdd_two").linkbutton("enable");
					$("#btnEdit_two").linkbutton("disable");
					$("#btnDelete_two").linkbutton("disable");
				}
			} 
		});
	}
	//删除关键字
	obj.btnDelete4_click = function(){
		var rowData = obj.gridCRuleMRB.getSelected();
		var Parref  = (rowData ? rowData["ID"] : '');
		var CRulerd = obj.gridMRBKeys.getSelected();
		var selectedID  = (CRulerd ? CRulerd["ID"] : '');
		if (selectedID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CRuleMRBKeys",
					MethodName:"DeleteById",
					aId:selectedID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID3 = "";
					obj.gridMRBKeysLoad(Parref);  //刷新当前页
					$("#btnAdd_three").linkbutton("enable");
					$("#btnEdit_three").linkbutton("disable");
					$("#btnDelete_three").linkbutton("disable");
				}
			} 
		});
	}
	//删除异常标志
	obj.btnDelete5_click = function(){
		var rowData = obj.gridCRuleMRB.getSelected();
		var Parref  = (rowData ? rowData["ID"] : '');
		var CRulerd = obj.gridIsolate.getSelected();
		var selectedID  = (CRulerd ? CRulerd["ID"] : '');
		if (selectedID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CRuleMRBOEOrd",
					MethodName:"DeleteById",
					aId:selectedID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID4 = "";
					obj.gridIsolateLoad(Parref);  //刷新当前页
					$("#btnAdd_four").linkbutton("enable");
					$("#btnEdit_four").linkbutton("disable");
					$("#btnDelete_four").linkbutton("disable");
				}
			} 
		});
	}
	//配置窗体-细菌初始化
	obj.layer_two= function(rd){
		if(rd){
			obj.RecRowID1 = rd["ID"];
			//var BacDesc = rd["BactDesc"];
			var BactID = rd["BactID"];
			
			$('#cboBact').combobox('setValue',BactID);
		}else{
			obj.RecRowID1 = "";
			$('#cboBact').combobox('setValue','');
			
		}
		$('#layer_two').show();
		obj.SetDiaglog2();
		
	}
	//配置窗体-抗生素初始化
	obj.layer_three= function(rd){
		if(rd){
			obj.RecRowID2 = rd["ID"];
			//var AntiCat = rd["AntiCatDesc"];
			var AntiCatDr = rd["AntiCatDr"];
			var AntiID = rd["AntiID"];
			
			$('#cboLabAntiCat').combobox('setValue',AntiCatDr);
			$('#cboLabAnti').combobox('setValue',AntiID);
		}else{
				obj.RecRowID2 = "";
			$('#cboLabAntiCat').combobox('setValue','');
			$('#cboLabAnti').combobox('setValue','');
		}
		$('#layer_three').show();
		obj.SetDiaglog3();
		
	}
	//配置窗体-关键词初始化
	obj.layer_four= function(rd){
		if(rd){
			obj.RecRowID3 = rd["ID"];
			var KeyWord = rd["KeyWord"];
			
			$('#txtKeyWord').val(KeyWord);
		}else{
				obj.RecRowID3 = "";
			$('#txtKeyWord').val('');
			
		}
		$('#layer_four').show();
		obj.SetDiaglog4();
	}
	//配置窗体-隔离医嘱初始化
	obj.layer_five= function(rd){
		if(rd){
			obj.RecRowID4 = rd["ID"];
			//var BTOrdDesc = rd["BTOrdDesc"];
			var BTOrdID = rd["BTOrdID"];
			$('#cboOEOrd').combobox('setValue',BTOrdID);
		}else{
				obj.RecRowID4 = "";
				$('#cboOEOrd').combobox('setValue','');
		}
		$('#layer_five').show();
		obj.SetDiaglog5();
	}
	obj.gridMRBBactLoad = function(aRuleID){
		$("#gridMRBBact").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CRuleMRBSrv",
			QueryName:"QryMRBBactByMRBID",	
			aMRBID:aRuleID,	
	    	page:1,
			rows:999
		},function(rs){
			$('#gridMRBBact').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
	obj.gridMRBAntiLoad = function(aRuleID){
		$("#gridMRBAnti").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CRuleMRBSrv",
			QueryName:"QryMRBAntiByMRBID",	
			aMRBID:aRuleID,	
	    	page:1,
			rows:999
		},function(rs){
			$('#gridMRBAnti').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
	obj.gridMRBKeysLoad = function(aRuleID){
		$("#gridMRBKeys").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CRuleMRBSrv",
			QueryName:"QryMRBKeysByMRBID",	
			aMRBID:aRuleID,	
	    	page:1,
			rows:999
		},function(rs){
			$('#gridMRBKeys').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
	obj.gridIsolateLoad = function(aRuleID){
		$("#gridIsolate").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CRuleMRBSrv",
			QueryName:"QryMRBOEOrdByMRBID",	
			aMRBID:aRuleID,	
	    	page:1,
			rows:999
		},function(rs){
			$('#gridIsolate').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}