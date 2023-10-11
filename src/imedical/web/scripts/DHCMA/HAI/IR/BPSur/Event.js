 //页面Event
function InitBPSurWinEvent(obj){
    obj.LoadEvent = function(args){
	    obj.gridEvObjectLoad();
	    //加载日期框
	    obj.CSSDateType=$m({
			ClassName:"DHCHAI.BT.Config",
			MethodName:"GetValByCode",
			aCode:"CSSDateType"
		},false);
	    if(obj.CSSDateType==1){
			$('.DivCssDate_2').hide();
		}
		else{
			$('.DivCssDate_1').hide();
		}
	    //保存
	    $('#btnSave').on('click', function(){
		    obj.btnSave_click();
		});
		//添加
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rowData=obj.gridEvObject.getSelected();
			obj.InitDialog(rowData);
		});
		$('#search').searchbox({ 
			searcher:function(value,name){
				searchText($("#gridEvObject"),value);
			}	
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
    }
    //刷新表格
    obj.gridEvObjectLoad=function(){
	   	var Ret =$cm({
			ClassName:"DHCHAI.IRS.BPSurveyExecSrv",
			QueryName:"QueryByCode",
			page:1,
			rows:9999
		},function(rs){
			$('#gridEvObject').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);	
		});
	}
    //选择
    obj.gridEvObject_onSelect = function (){
	    var rowData = obj.gridEvObject.getSelected();
	    if (rowData["ID"] == obj.RecRowID){
		    $("#btnAdd").linkbutton("enable");
		    $("#btnEdit").linkbutton("disable");
		    $("#btnDelete").linkbutton("disable");
		    obj.RecRowID="";
		    obj.gridEvObject.clearSelections();
		}else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	
	//双击编辑事件
	obj.gridEvObject_onDbselect = function(rowData){
		obj.InitDialog(rowData);
	}
	
	//保存
	obj.btnSave_click = function(){
		var errinfo  = "";
		
		if(obj.CSSDateType==1){
			var SESurvDate = $("#SESurvDate").datebox('getValue');
			var SESurvSttDate = SESurvDate;
			var SESurvEndDate = SESurvDate;
			if (!SESurvDate) {
				errinfo = errinfo + "调查日期为空!<br>";
			}
		}
		else{
			var SESurvSttDate = $("#SESurvSttDate").datebox('getValue');
			var SESurvEndDate = $("#SESurvEndDate").datebox('getValue');
			if (!SESurvSttDate) {
				errinfo = errinfo + "开始日期为空!<br>";
			}
			if (!SESurvEndDate) {
				errinfo = errinfo + "结束日期为空!<br>";
			}
			if (SESurvSttDate>SESurvEndDate) {
				errinfo = errinfo + "开始日期应小于或等于结束日期！<br>";
			}	
		}
		var HospID = $('#cboHospital').combobox('getValues');
		var HospID = HospID.join();		
		if (!HospID) {
			errinfo = errinfo + "请选择医院!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		if (SESurvEndDate==""){
			SESurvEndDate=SESurvSttDate;
		}
		var InputStr = obj.RecRowID;
		InputStr += "^" + HospID;
		InputStr += "^" + "";
		InputStr += "^" + SESurvSttDate;
		InputStr += "^" + SESurvEndDate;
		InputStr += "^" + $.LOGON.USERID;
		InputStr += "^" + ""
		
		var flg = $m({
			ClassName:"DHCHAI.IR.BPSurveyExec",
			MethodName:"Update",
			InStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0){
			if (parseInt(flg) == 0){
				$.messager.alert("错误提示", "参数错误!" , 'info');
			}else if(parseInt(flg) == -2){
				$.messager.alert("错误提示", "数据重复!" , 'info');
			}else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else{
			$HUI.dialog('#winProEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.gridEvObjectLoad();	//刷新当前页
		}
	}
	
	//删除
	obj.btnDelete_click = function(){
		var rowDataID = obj.gridEvObject.getSelected()["ID"];
		if (rowDataID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r){
			if(r){
				var flg = $m({
					ClassName:"DHCHAI.IR.BPSurveyExec",
					MethodName:"DeleteById",
					aId:rowDataID
				},false);
				if(parseInt(flg) < 0){
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
				}else{
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = ""
					obj.gridEvObjectLoad();	//刷新当前页
				}
			}
		});
	}
	//窗体
	obj.SetDiaglog=function (){
		$('#winProEdit').dialog({
			title: '血透个案调查定义编辑',
			iconCls:'icon-w-paper',
			//closed: true,
			modal: true,
			isTopZindex:false,//true,
			buttons:[{
				text:'保存',
				handler:function(){
					obj.btnSave_click();
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog('#winProEdit').close();
				}
			}]
		});
	}
	//配置窗体-初始化
	obj.InitDialog = function(rowData){
		if(rowData){
			obj.RecRowID=rowData["ID"];
			var SESurvSttDate = rowData["SESurvSttDate"];
			var SESurvEndDate = rowData["SESurvEndDate"];
			var HospDesc = rowData["HospDesc"];
			var HospIDs = rowData["HospID"];
			if(obj.CSSDateType==1){
				$('#SESurvDate').datebox('setValue',SESurvSttDate);
			}
			else{
				$('#SESurvSttDate').datebox('setValue',SESurvSttDate);
				$('#SESurvEndDate').datebox('setValue',SESurvEndDate);
			}
			for(var i=0;i<HospIDs.split("|").length;i++){
				var HospID=HospIDs.split("|")[i];
				
				$('#cboHospital').combobox('select', HospID);
			}
		}else{
			obj.RecRowID="";
			$('#SESurvDate').datebox('setValue',"");
			$('#SESurvSttDate').datebox('setValue',"");
			$('#SESurvEndDate').datebox('setValue',"");
			$('#cboHospital').combobox('setValue',"");
		}
		$('#winProEdit').show();
		obj.SetDiaglog();
	}
}