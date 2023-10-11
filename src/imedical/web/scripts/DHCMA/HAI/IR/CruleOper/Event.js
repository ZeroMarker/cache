//页面Event
function InitCRuleOperWinEvent(obj){
	//检索框
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridCRuleOper"),value);
		}	
	});
	var p = $('#gridCRuleOper').datagrid('getPager');
	    if (p){
	        $(p).pagination({ //设置分页功能栏
	           //分页功能可以通过Pagination的事件调用后台分页功能来实现
	        	onRefresh:function(){
					obj.gridCRuleOperKeysLoad("");  //刷新当前页
					$("#btnAdd_one").linkbutton("disable");
					$("#btnEdit_one").linkbutton("disable");
					$("#btnDelete_one").linkbutton("disable");
	        	}
	 
	        });
	    }
	//编辑窗体
	obj.SetDiaglog=function(){
		$('#layer').dialog({
			title: '手术信息编辑',
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
			title: '关键词编辑',
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
		$("#btnAdd_one").linkbutton("disable");
		$("#btnEdit_one").linkbutton("disable");
		$("#btnDelete_one").linkbutton("disable");
    	obj.gridCRuleOperLoad();
		obj.gridCRuleOperKeysLoad();
		//新增
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
    	//修改
		$('#btnEdit').on('click', function(){
			var rd=obj.gridCRuleOper.getSelected();
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
			var rd2=obj.gridCRuleOperKeys.getSelected();
			obj.layer_two(rd2);	
		});
		//删除
		$('#btnDelete_one').on('click', function(){
			obj.btnDelete2_click();
		});
    }
    //双击编辑事件
	obj.gridCRuleOper_onDbselect = function(rd){
		obj.layer(rd);
	}
	
	//选择
	obj.gridCRuleOper_onSelect = function (){
		var rowData = obj.gridCRuleOper.getSelected();
		var Parref  = (rowData ? rowData["ID"] : '');
		
		
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			obj.gridCRuleOperKeysLoad("");
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridCRuleOper.clearSelections();
			$("#btnAdd_one").linkbutton("disable");
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
			$("#btnAdd_one").linkbutton("enable");
			obj.gridCRuleOperKeysLoad(Parref);
		}
	} //双击编辑事件
	obj.gridCRuleOperKeys_onDbselect = function(rd2){
		obj.layer_two(rd2);
	}
	//选择
	obj.gridCRuleOperKeys_onSelect = function (){
		var rowData2 = obj.gridCRuleOperKeys.getSelected();
		if($("#btnEdit_one").hasClass("l-btn-disabled")) obj.RecRowID2="";
		var rowId  = (rowData2 ? rowData2["ID"] : '');
		if (rowId == obj.RecRowID2) {
			obj.RecRowID2="";
			$("#btnAdd_one").linkbutton("enable");
			$("#btnEdit_one").linkbutton("disable");
			$("#btnDelete_one").linkbutton("disable");
			obj.gridCRuleOperKeys.clearSelections();
		} else {
			$("#btnAdd_one").linkbutton("disable");
			$("#btnEdit_one").linkbutton("enable");
			$("#btnDelete_one").linkbutton("enable");
		}
		obj.RecRowID2 = rowId;
	}
	//保存
	obj.btnSave_click = function(){
		var errinfo = "";
		var Type = $('#cboType').combobox('getValue');
		var LocDr = $('#cboLocation').combobox('getValue');
		var OperIncDr = $('#cboOperInc').combobox('getValue');
		var OperDxDr = '';
		var OperDesc = $('#txtOperDesc').val();
		var IsActive = $("#chkActive").checkbox('getValue')? '1':'0';
		
		
		if (!LocDr) {
			errinfo = errinfo + "科室不允许为空!<br>";
		}	
		if ((!OperIncDr)&&(!OperDxDr)&&(!OperDesc)) {
			errinfo = errinfo + "切口类型、手术名称不允许同时为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var InputStr = obj.RecRowID;
		InputStr += "^" + Type;
		InputStr += "^" + LocDr;
		InputStr += "^" + OperIncDr;
		InputStr += "^" + OperDxDr;
		InputStr += "^" + OperDesc;
		InputStr += "^" + IsActive;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERDESC;
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleOper",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)=='-100'){
				$.messager.alert("错误提示" , '手术名称重复!');
			}else{
				$.messager.alert("错误提示" , '保存失败!');
			}
			
		}else {
			$HUI.dialog('#layer').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID = flg
			obj.gridCRuleOperLoad(); //刷新当前页
		}
	}
	//保存分类
	obj.btnSave2_click = function(){
		var errinfo = "";
		var InWord = $('#txtInWord').val();
		var ExWords = $('#txtExWords').val();
		var CRulerd = obj.gridCRuleOper.getSelected();
		var Parref  = (CRulerd ? CRulerd["ID"] : '');
		
		if ((InWord.indexOf(" ") >= 0) || (InWord == '')) {
			errinfo = errinfo + "关键词(包含)不允许为空!<br>";
		}	
		if ((ExWords.indexOf(" ") >= 0) || (ExWords == '')) {
			errinfo = errinfo + "关键词(排除)不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var InputStr = obj.RecRowID2;
		InputStr += "^" + Parref;
		InputStr += "^" + InWord;
		InputStr += "^" + ExWords;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERDESC;
		
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleOperKeys",
			MethodName:"Update",
			InStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)=='-100'){
				$.messager.alert("错误提示" , '标准手术+关键词重复!');
			}else{
			}
			
		}else {
			$HUI.dialog('#layer_two').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID2 = flg
			obj.gridCRuleOperKeysLoad(Parref); //刷新当前页
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
					ClassName:"DHCHAI.IR.CRuleOper",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridCRuleOperLoad();  //刷新当前页
					obj.gridCRuleOperKeysLoad("");
					$("#btnAdd_one").linkbutton("disable");
				}
			} 
		});
	}//删除分类 
	obj.btnDelete2_click = function(){
		var CRulerd = obj.gridCRuleOper.getSelected();
		var Parref  = (CRulerd ? CRulerd["ID"] : '');
		if (obj.RecRowID2==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CRuleOperKeys",
					MethodName:"DeleteById",
					Id:obj.RecRowID2
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID2 = "";
					obj.gridCRuleOperKeysLoad(Parref);  //刷新当前页
					$("#btnAdd_one").linkbutton("enable");
					$("#btnEdit_one").linkbutton("disable");
					$("#btnDelete_one").linkbutton("disable");
				}
			} 
		});
	}
	//配置窗体-初始化
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID = rd["ID"];
			var Type = rd["Type"];
			var LocDesc = rd["LocDesc"];
			var LocID = rd["LocID"];
			var Operation = rd["Operation"];
			var IncID = rd["IncID"];
			var IncDesc = rd["IncDesc"];
			var IsActive = rd["IsActive"];
			
			$('#cboType').combobox('setValue',Type);
			$('#cboLocation').combobox('setValue',LocID);
			$('#cboLocation').combobox('setText',LocDesc);
			$('#txtOperDesc').val(Operation);
			$('#cboOperInc').combobox('setValue',IncID);
			$('#cboOperInc').combobox('setText',IncDesc);
			$('#chkActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID = "";
			$('#cboType').combobox('setValue','');
			$('#cboLocation').combobox('setValue','');
			$('#txtOperDesc').val('');
			$('#cboOperInc').combobox('setValue','');
			$('#chkActive').checkbox('setValue',false);
			
		}
		$('#layer').show();
		obj.SetDiaglog();
		
	}
	//配置窗体-初始化
	obj.layer_two= function(rd){
		if(rd){
			obj.RecRowID2 = rd["ID"];
			var InWord = rd["InWord"];
			var ExWords = rd["ExWords"];
			
			$('#txtInWord').val(InWord);
			$('#txtExWords').val(ExWords);
		}else{
			obj.RecRowID2 = "";
			$('#txtInWord').val('');
			$('#txtExWords').val('');
			
		}
		$('#layer_two').show();
		obj.SetDiaglog2();
		
	}
	obj.gridCRuleOperKeysLoad = function(aRuleID){
		$("#gridCRuleOperKeys").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CRuleOperSrv",
			QueryName:"QryCRuleOperKeys",	
			aOperID:aRuleID,	
	    	page:1,
			rows:999
		},function(rs){
			$('#gridCRuleOperKeys').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
		obj.RecRowID2 = "";
		$("#btnAdd_one").linkbutton("enable");
		$("#btnEdit_one").linkbutton("disable");
		$("#btnDelete_one").linkbutton("disable");
    }
	obj.gridCRuleOperLoad = function(){
		originalData["gridCRuleOper"]="";
		$cm ({
		    ClassName:"DHCHAI.IRS.CRuleOperSrv",
			QueryName:"QryCRuleOper",		
	    	page:1,
			rows:999
		},function(rs){
			$('#gridCRuleOper').datagrid('loadData', rs);					
		});
    }
}