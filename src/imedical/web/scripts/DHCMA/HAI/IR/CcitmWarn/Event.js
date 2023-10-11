//页面Event
function InitCCItmWarnWinEvent(obj){
	//检索框
	$('#btnsearch').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridCCItmWarn"),value);
		}	
	});	
	//编辑窗体
	obj.SetDiaglog=function(){
		$('#layer').dialog({
			title: '暴发预警项目编辑',
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
	//按钮初始化
    obj.LoadEvent = function(args){ 
   		obj.gridCCItmWarnLoad();
		//添加
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd=obj.gridCCItmWarn.getSelected()
			obj.layer(rd);	
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		}); 
   	}
   	//双击编辑事件
	obj.gridCCItmWarn_onDbselect = function(rd){
		obj.layer(rd);
	}
	//选择
	obj.gridCCItmWarn_onSelect = function (){
		var rowData = obj.gridCCItmWarn.getSelected();
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID="";
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			
			obj.gridCCItmWarn.clearSelections();
		}
		else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	//保存分类
	obj.btnSave_click = function(){
		var errinfo = "";
		var Desc = $('#txtDesc').val();
		var Desc2 = $('#txtDesc2').val();
		var KeyWords = $('#txtKeyWords').val();
		var IndNo = $('#txtIndNo').val();
		var Arg1 = $('#txtArg1').val();
		var Arg2 = $('#txtArg2').val();
		var Arg3 = $('#txtArg3').val();
		var Arg4 = $('#txtArg4').val();
		var Arg5 = $('#txtArg5').val();
		var IsActive = $("#chkActive").checkbox('getValue')? '1':'0';
		var ActUserDr = $.LOGON.USERID;
		var Desc 	= Desc.trim();
		var Desc2 	= Desc2.trim();
		
		
		if (!Desc) {
			errinfo = errinfo + "暴发预警项目名称不允许为空!<br>";
		}	
		if (!Desc2) {
			errinfo = errinfo + "暴发预警项目名称2不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var InputStr = obj.RecRowID;
		InputStr += "^" + Desc;
		InputStr += "^" + Desc2;
		InputStr += "^" + KeyWords;
		InputStr += "^" + IndNo;
		InputStr += "^" + Arg1;
		InputStr += "^" + Arg2;
		InputStr += "^" + Arg3;
		InputStr += "^" + Arg4;
		InputStr += "^" + Arg5;
		InputStr += "^" + IsActive;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + ActUserDr;
		var flg = $m({
			ClassName:"DHCHAI.IR.CCItmWarn",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if(parseInt(flg) == -2){
				$.messager.alert("代码重复!" , 'info');
			}else{
				$.messager.alert("错误提示", "保存失败!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#layer').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID = flg
			obj.gridCCItmWarnLoad(); //刷新当前页
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
					ClassName:"DHCHAI.IR.CCItmWarn",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);

				if (parseInt(flg) < 0) {
					if (parseInt(flg)=='-777') {
						$.messager.alert("错误提示","-777：当前无删除权限，请启用删除权限后再删除记录!",'info');
					}else {
						$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					}
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridCCItmWarnLoad();  //刷新当前页
				}
			} 
		});
	}
	//配置窗体-初始化
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID = rd["ID"];
			var Desc = rd["Desc"];
			var Desc2 = rd["Desc2"];
			var KeyWords = rd["KeyWords"];
			var IndNo = rd["IndNo"];
			var Arg1 = rd["Arg1"];
			var Arg2 = rd["Arg2"];
			var Arg3 = rd["Arg3"];
			var Arg4 = rd["Arg4"];
			var Arg5 = rd["Arg5"];
			var IsActive = rd["IsActive"];
			IsActive = (IsActive=="1"? true: false)
			
			$('#txtDesc').val(Desc);
			$('#txtDesc2').val(Desc2);
			$('#txtKeyWords').val(KeyWords);
			$('#txtIndNo').val(IndNo);
			$('#txtArg1').val(Arg1);
			$('#txtArg2').val(Arg2);
			$('#txtArg3').val(Arg3);
			$('#txtArg4').val(Arg4);
			$('#txtArg5').val(Arg5);
			$('#chkActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID = "";
			$('#txtDesc').val('');
			$('#txtDesc2').val('');
			$('#txtKeyWords').val('');
			$('#txtArg1').val('');
			$('#txtArg2').val('');
			$('#txtArg3').val('');
			$('#txtArg4').val('');
			$('#txtArg5').val('');
			$('#txtIndNo').val('');
			$('#chkActive').checkbox('setValue',false);
			
		}
		$('#layer').show();
		obj.SetDiaglog();
		
	}
	obj.gridCCItmWarnLoad = function(){
		originalData["gridCCItmWarn"]="";
		$("#gridCCItmWarn").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CCItmWarnSrv",
			QueryName:"QryWarnSrv",		
	    	page:1,
			rows:999
		},function(rs){
			$('#gridCCItmWarn').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}