//页面Event
function InitCRuleRBAbWinEvent(obj){
	//检索框
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridCRuleRBAb"),value);
		}	
	});
	//编辑窗体
	obj.SetDiaglog=function(){
		$('#layer').dialog({
			title: '影像学筛查编辑',
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
			title: '检查项目编辑',
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
	
	//按钮初始化
    obj.LoadEvent = function(args){ 
    	obj.gridCRuleRBAbLoad();
		obj.gridCRuleRBCodeLoad();
		//新增
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
    	//修改
		$('#btnEdit').on('click', function(){
			var rd=obj.gridCRuleRBAb.getSelected();
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
			var rd2=obj.gridCRuleRBCode.getSelected();
			obj.layer_two(rd2);	
		});
		//删除
		$('#btnDelete_one').on('click', function(){
			obj.btnDelete2_click();
		});
		$("#btnAdd_one").linkbutton("disable");
		$("#btnEdit_one").linkbutton("disable");
		$("#btnDelete_one").linkbutton("disable");
    }
     //双击编辑事件
	obj.gridCRuleRBAb_onDbselect = function(rd){
		obj.layer(rd);
	}
	
	//选择
	obj.gridCRuleRBAb_onSelect = function (){
		var rowData = obj.gridCRuleRBAb.getSelected();
		
		var Parref  = (rowData ? rowData["ID"] : '');
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$("#btnAdd_one").linkbutton("disable");
			obj.gridCRuleRBAb.clearSelections(); 
			$('#gridCRuleRBCode').datagrid('loadData',{total:0,rows:[]});
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
			$("#btnAdd_one").linkbutton("enable");
			obj.gridCRuleRBCodeLoad(Parref);
		}
	} 
	//双击编辑事件
	obj.gridCRuleRBCode_onDbselect = function(rd2){
		obj.layer_two(rd2);
	}
	//选择
	obj.gridCRuleRBCode_onSelect = function (){
		var rowData2 = obj.gridCRuleRBCode.getSelected();
		var rowId = (rowData2 != null) ? rowData2["ID"] : '';
		if (rowId == obj.RecRowID2) {
			$("#btnAdd_one").linkbutton("enable");
			$("#btnEdit_one").linkbutton("disable");
			$("#btnDelete_one").linkbutton("disable");
			obj.gridCRuleRBCode.clearSelections();
		} else {
			$("#btnAdd_one").linkbutton("disable");
			$("#btnEdit_one").linkbutton("enable");
			$("#btnDelete_one").linkbutton("enable");
		}
			obj.RecRowID2 = rowId;
	}
	
	//影像学筛查标准窗体-保存
	obj.btnSave_click = function(){
		var errinfo = "";
		var RBCode = $('#txtRBCode').val();
		var RBPos = $('#txtRBPos').val();
		var RBNote = $('#txtRBNote').val();
		var RBCFlag = $("#chkRBCFlag").checkbox('getValue')? '1':'0';
		
		
		if (!RBCode) {
			errinfo = errinfo + "检查项目不允许为空!<br>";
		}	
		if (!RBPos) {
			errinfo = errinfo + "检查部位不允许为空!<br>";
		}	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var InputStr = obj.RecRowID;
		InputStr += "^" + RBCode;      // 检查项目
		InputStr += "^" + RBPos;       // 检查部位
		InputStr += "^" + RBNote;      // 说明
		InputStr += "^" + RBCFlag;     // 筛查标志
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleRBAb",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)=='-100'){
				$.messager.alert("错误提示" , '检查项目重复，保存失败!');
			}else{
				$.messager.alert("错误提示" , '保存失败!');
			}
		}else {
			$HUI.dialog('#layer').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID = flg
			obj.gridCRuleRBAbLoad(); //刷新当前页
		}
	}
	//保存分类
	obj.btnSave2_click = function(){
		var errinfo = "";
		var RBCodeDr = $('#cboRBCodeDr').combobox('getValue');
		var CRulerd = obj.gridCRuleRBAb.getSelected();
		var Parref  = (CRulerd ? CRulerd["ID"] : '');
		var ID 		= obj.RecRowID2
		if (ID.indexOf("||")>-1) {
			var SubID=ID.split('||')[1];
		} else {
			var SubID='';
		}
		
		var InputStr = Parref;		        // 父表ID
		InputStr += "^" + SubID;            // 子表ID
		InputStr += "^" + RBCodeDr;         // 检验项目
		InputStr += "^" + '';               // 更新日期
		InputStr += "^" + '';               // 更新时间
		InputStr += "^" + $.LOGON.USERID;   // 更新人
		
		if (!RBCodeDr) {
			errinfo = errinfo + "检查项目不允许为空!<br>";
		}	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleRBCode",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)== '-2') {
				$.messager.alert("错误提示" , '检查项目重复!');
			}else{
				$.messager.alert("错误提示" , '保存失败!');
			}
			
		}else {
			$HUI.dialog('#layer_two').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID2 = flg
			obj.gridCRuleRBCodeLoad(Parref); //刷新当前页
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
					ClassName:"DHCHAI.IR.CRuleRBAb",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridCRuleRBAbLoad();  //刷新当前页
				}
			} 
		});
	}//删除分类 
	obj.btnDelete2_click = function(){
		var CRulerd = obj.gridCRuleRBAb.getSelected();
		var Parref  = (CRulerd ? CRulerd["ID"] : '');
		if (obj.RecRowID2==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CRuleRBCode",
					MethodName:"DeleteById",
					aId:obj.RecRowID2
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID2 = "";
					obj.gridCRuleRBCodeLoad(Parref);  //刷新当前页
				}
			} 
		});
	}
	//配置窗体-初始化
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID = rd["ID"];
			var RBCode = rd["RBCode"];
			var RBPos = rd["RBPos"];
			var RBNote = rd["RBNote"];
			
			$('#txtRBCode').val(RBCode);
			$('#txtRBPos').val(RBPos);
			$('#txtRBNote').val(RBNote);
			$("#chkRBCFlag").checkbox('setValue',(rd["RBCFlag"]=="1"? true: false));
		}else{
			obj.RecRowID = "";
			$('#txtRBCode').val('');
			$('#txtRBPos').val('');
			$('#txtRBNote').val('');
			$('#chkRBCFlag').checkbox('setValue',false);
			
		}
		$('#layer').show();
		obj.SetDiaglog();
		
	}
	//配置窗体-初始化
	obj.layer_two= function(rd){
		if(rd){
			obj.RecRowID2 = rd["ID"];
			//var RBDesc = rd["RBCodeDesc"];
			var RBCodeDr = rd["RBCodeDr"];
			$('#cboRBCodeDr').combobox('setValue',RBCodeDr);
		}else{
			obj.RecRowID2 = "";
			$('#cboRBCodeDr').combobox('setValue','');
			
		}
		$('#layer_two').show();
		obj.SetDiaglog2();
		
	}
	obj.gridCRuleRBCodeLoad = function(aRuleID){
		$("#gridCRuleRBCode").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CRuleRBCodeSrv",
			QueryName:"QryCRuleRBCodeByID",	
			aRBAbID:aRuleID,	
	    	page:1,
			rows:999
		},function(rs){
			$('#gridCRuleRBCode').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
		obj.RecRowID2 = "";
		$("#btnAdd_one").linkbutton("enable");
		$("#btnEdit_one").linkbutton("disable");
		$("#btnDelete_one").linkbutton("disable");
    }
	obj.gridCRuleRBAbLoad = function(){
		originalData["gridCRuleRBAb"]="";
		$("#gridCRuleRBAb").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CRuleRBAbSrv",
			QueryName:"QryCRuleRBAb",		
	    	page:1,
			rows:999
		},function(rs){
			$('#gridCRuleRBAb').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}