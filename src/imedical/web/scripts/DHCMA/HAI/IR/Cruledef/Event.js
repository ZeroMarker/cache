//页面Event
function InitCRuleDefWinEvent(obj){
	//检索框
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridCRuleDef"),value);
		}	
	});
	//编辑窗体
	obj.SetDiaglog=function(){
		$('#layer').dialog({
			title: '感染诊断标准编辑',
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
			title: '感染诊断标准编辑',
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
    	obj.gridCRuleDefLoad();
		//新增
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
    	//修改
		$('#btnEdit').on('click', function(){
			var rd=obj.gridCRuleDef.getSelected();
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
			var rd2=obj.gridCRuleDefExt.getSelected();
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
	obj.gridCRuleDef_onDbselect = function(rd){
		obj.layer(rd);
	}
	
	//选择
	obj.gridCRuleDef_onSelect = function (){
		var rowData = obj.gridCRuleDef.getSelected();
		var Parref  = (rowData ? rowData["ID"] : '');
		
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridCRuleDef.clearSelections();
			obj.gridCRuleDefExtLoad("");
			$("#btnAdd_one").linkbutton("disable");
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
			obj.gridCRuleDefExtLoad(Parref);
		}
	} //双击编辑事件
	obj.gridCRuleDefExt_onDbselect = function(rd2){
		if (obj.RecRowID==""){
			$("#btnAdd_one").linkbutton("disable");
			$("#btnEdit_one").linkbutton("disable");
			$("#btnDelete_one").linkbutton("disable");
			obj.gridCRuleDefExt.clearSelections();
			return;
		}
		obj.layer_two(rd2);
	}
	//选择
	obj.gridCRuleDefExt_onSelect = function (){
		if (obj.RecRowID==""){
			$("#btnAdd_one").linkbutton("disable");
			$("#btnEdit_one").linkbutton("disable");
			$("#btnDelete_one").linkbutton("disable");
			obj.gridCRuleDefExt.clearSelections();
			return;
		}
		var rowData2 = obj.gridCRuleDefExt.getSelected();
		if (rowData2["ID"] == obj.RecRowID2) {
			obj.RecRowID2="";
			$("#btnAdd_one").linkbutton("enable");
			$("#btnEdit_one").linkbutton("disable");
			$("#btnDelete_one").linkbutton("disable");
			obj.gridCRuleDefExt.clearSelections();
		} else {
			obj.RecRowID2 = rowData2["ID"];
			$("#btnAdd_one").linkbutton("disable");
			$("#btnEdit_one").linkbutton("enable");
			$("#btnDelete_one").linkbutton("enable");
		}
	}
	//保存
	obj.btnSave_click = function(){
		var errinfo = "";
		var PosDr = $('#cboInfPos').combobox('getValue');
		var Title = $('#txtTitle').val();
		var Note = $('#txtNote').val();
		var IndNo = $('#txtIndNo').val();
		var MaxAge = $('#txtMaxAge').val();
		var MinAge = $('#txtMinAge').val();
		var IsActive = $("#chkActive").checkbox('getValue')? '1':'0';
		var ActUserDr = $.LOGON.USERID;
		
		
		if (!PosDr) {
			errinfo = errinfo + "感染诊断描述不允许为空!<br>";
		}	
		if (!Title) {
			errinfo = errinfo + "标准定义不允许为空!<br>";
		}	
		if (!Note) {
			errinfo = errinfo + "标准解读不允许为空!<br>";
		}
		if ((MaxAge !="")&&(MinAge!="")&&(parseInt(MaxAge)>parseInt(MinAge))) {
			errinfo = errinfo + "年龄下限不能大于年龄上限!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var InputStr = obj.RecRowID;
		InputStr += "^" + PosDr;
		InputStr += "^" + Title;
		InputStr += "^" + Note;
		InputStr += "^" + IndNo;
		InputStr += "^" + IsActive;
		InputStr += "^" + MaxAge;
		InputStr += "^" + MinAge;
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleDef",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			$.messager.alert("错误提示" , '感染诊断描述重复!');
			
		}else {
			$HUI.dialog('#layer').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID = "";
			obj.gridCRuleDefLoad(); //刷新当前页
		}
	}
	//保存分类
	obj.btnSave2_click = function(){
		var errinfo = "";
		var Title = $('#txtExtTitle').val();
		var Note = $('#txtExtNote').val();
		var TypeDr = $('#cboDiagType').combobox('getValue');
		var IndNo = $('#txtExtIndNo').val();
		var IsActive = $("#chkExtActive").checkbox('getValue')? '1':'0';
		var CRulerd = obj.gridCRuleDef.getSelected();
		var Parref  = (CRulerd ? CRulerd["ID"] : '');
		var SubId="";
		if(obj.RecRowID2!=""){
			SubId=obj.RecRowID2.split("||")[1];
		}
		
		var InputStr = Parref;
		InputStr += "^" + SubId;
		InputStr += "^" + Title;
		InputStr += "^" + Note;
		InputStr += "^" + TypeDr;
		InputStr += "^" + IndNo;
		InputStr += "^" + IsActive;
		
		if (!Title) {
			errinfo = errinfo + "诊断定义不允许为空!<br>";
		}	
		if (!Note) {
			errinfo = errinfo + "诊断解读不允许为空!<br>";
		}	
		if (!TypeDr) {
			errinfo = errinfo + "诊断类型不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleDefExt",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			$.messager.alert("错误提示" , '感染诊断描述重复!');
			
		}else {
			$HUI.dialog('#layer_two').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID2 = "";
			obj.gridCRuleDefExtLoad(Parref); //刷新当前页
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
					ClassName:"DHCHAI.IR.CRuleDef",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridCRuleDefLoad();  //刷新当前页
					obj.gridCRuleDefExtLoad("");  //刷新当前页
				}
			} 
		});
	}//删除分类 
	obj.btnDelete2_click = function(){
		var CRulerd = obj.gridCRuleDef.getSelected();
		var Parref  = (CRulerd ? CRulerd["ID"] : '');
		if (obj.RecRowID2==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CRuleDefExt",
					MethodName:"DeleteById",
					aId:obj.RecRowID2
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID2 = "";
					obj.gridCRuleDefExtLoad(Parref);  //刷新当前页
				}
			} 
		});
	}
	//配置窗体-初始化
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID = rd["ID"];
			//var InfPosDesc = rd["InfPosDesc"];
			var InfPosID = rd["InfPosID"];
			var Title = rd["Title"];
			var Note = rd["Note"];
			var IndNo = rd["IndNo"];
			var MaxAge = rd["MaxAge"];
			var MinAge = rd["MinAge"];
			var IsActive = rd["IsActive"];
			IsActive = (IsActive=="1"? true: false)
			
			$('#cboInfPos').combobox('setValue',InfPosID);
			$('#txtTitle').val(Title);
			$('#txtNote').val(Note);
			$('#txtIndNo').val(IndNo);
			$('#txtMaxAge').val(MaxAge);
			$('#txtMinAge').val(MinAge);
			$('#chkActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID = "";
			$('#cboInfPos').combobox('setValue','');
			$('#txtTitle').val('');
			$('#txtNote').val('');
			$('#txtIndNo').val('');
			$('#txtMaxAge').val('');
			$('#txtMinAge').val('');
			$('#chkActive').checkbox('setValue',false);
			
		}
		$('#layer').show();
		obj.SetDiaglog();
		
	}
	//配置窗体-初始化
	obj.layer_two= function(rd){
		if(rd){
			obj.RecRowID2 = rd["ID"];
			var Title = rd["Title"];
			var Note = rd["Note"];
			//var TypeDesc = rd["TypeDesc"];
			var TypeID = rd["TypeID"];
			var IndNo = rd["IndNo"];
			var IsActive = rd["IsActive"];
			IsActive = (IsActive=="1"? true: false)
			
			$('#txtExtTitle').val(Title);
			$('#txtExtNote').val(Note);
			$('#cboDiagType').combobox('setValue',TypeID);
			$('#txtExtIndNo').val(IndNo);
			$('#chkExtActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID2 = "";
			$('#txtExtTitle').val('');
			$('#txtExtNote').val('');
			$('#cboDiagType').combobox('setValue','');
			$('#txtExtIndNo').val('');
			$('#chkExtActive').checkbox('setValue',false);
			
		}
		$('#layer_two').show();
		obj.SetDiaglog2();
		
	}
	obj.gridCRuleDefExtLoad = function(aRuleID){
		$("#gridCRuleDefExt").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CCRuleDefSrv",
			QueryName:"QryCRuleDefExt",	
			aRuleDefID:aRuleID,	
	    	page:1,
			rows:999
		},function(rs){
			$('#gridCRuleDefExt').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
	obj.gridCRuleDefLoad = function(){
		originalData["gridCRuleDef"]="";
		$("#gridCRuleDef").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CCRuleDefSrv",
			QueryName:"QryCRuleDef",		
	    	page:1,
			rows:999
		},function(rs){
			$('#gridCRuleDef').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}