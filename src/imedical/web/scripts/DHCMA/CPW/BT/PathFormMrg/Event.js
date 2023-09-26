//页面Event
function InitHISUIWinEvent(obj){
	//CheckSpecificKey();
	//取表单对象
	$cm({
		ClassName:"DHCMA.CPW.BT.PathForm",
		MethodName:"GetObjById",
		aId:PathFormID
	},function(jsonData){		
		console.dir(jsonData); 
		$("#pathMastID").val(jsonData.FormPathDr);
		//重新加载datagrid的数据  
		obj.admitList.load({
			ClassName:"DHCMA.CPW.BTS.PathAdmitSrv",
			QueryName:"QryPathAdmit",
			aBTPathDr:$("#pathMastID").val() 
		}); 
		$("#txtFormCost").val(jsonData.FormCost);
		$("#txtFormDays").val(jsonData.FormDays);
		$("#txtFormApply").val(jsonData.FormApply);
		if(jsonData.FormPathDr!="")
		{
			var mastData = $cm({ClassName:"DHCMA.CPW.BT.PathMast",MethodName:"GetObjById",aId:jsonData.FormPathDr},false);
			$("#txtPathCode").val(mastData.BTCode);
			$("#txtPathDesc").val(mastData.BTDesc);
			if(mastData.BTIsActive=="1"){
				$("#txtIsActiveDesc").val("是");
			}
			else{
				$("#txtIsActiveDesc").val("否");
			}
			//专科类型
			if(mastData.BTTypeDr!="")
			{
				var typeData = $cm({ClassName:"DHCMA.CPW.BT.PathType",MethodName:"GetObjById",aId:mastData.BTTypeDr},false);
				$("#txtPathType").val(typeData.BTDesc);
			}
		}
	});
	//提交后台保存
	obj.saveToSrv=function()
	{
		var ID = obj.modifyAfterRow.ID;
		//$.form.GetValue("txtDicCode")
		var BTPathDr = obj.modifyAfterRow.BTPathDr;
		var BTTypeDr = obj.modifyAfterRow.BTTypeDr;
		var BTICD10  =obj.modifyAfterRow.BTICD10;
		var BTICDKeys   = obj.modifyAfterRow.BTICDKeys;
		var BTOperICD = obj.modifyAfterRow.BTOperICD;
		var BTOperKeys = obj.modifyAfterRow.BTOperKeys;
		var BTIsICDAcc = obj.modifyAfterRow.BTIsICDAcc;
		var BTIsOperAcc = obj.modifyAfterRow.BTIsOperAcc;
		var BTIsActive = obj.modifyAfterRow.BTIsActive;
		
		BTIsICDAcc = (BTIsICDAcc =="是"?"1":"0");
		BTIsOperAcc = (BTIsOperAcc =="是"?"1":"0");
		BTIsActive = (BTIsActive =="是"?"1":"0");
		if(BTTypeDr=="")
		{
			$.messager.alert("提示","诊断类型不可以为空！");
			return false;
		}
		
		var InputStr = ID;
		InputStr += "^" + BTPathDr;
		InputStr += "^" + BTTypeDr;
		InputStr += "^" + BTICD10;
		InputStr += "^" + BTICDKeys;
		InputStr += "^" + BTOperICD;
		InputStr += "^" + BTOperKeys;
		InputStr += "^" + BTIsICDAcc;
		InputStr += "^" + BTIsOperAcc;
		InputStr += "^" + BTIsActive;
		InputStr += "^";
		InputStr += "^";
		InputStr += "^" + session['DHCMA.USERID'];
		//同步调用
		var data = $.cm({ClassName:"DHCMA.CPW.BT.PathAdmit",MethodName:"Update",
				"aInputStr":InputStr,
				"aSeparete":"^"
			},false);
		if(parseInt(data)<0){
			$.messager.alert("提示","失败！");
			return false;
		}else{			
			$('#admitList').datagrid('getRows')[obj.editIndex]['ID'] = data;
			$('#admitList').datagrid('refreshRow',obj.editIndex);
			$.messager.alert("提示","成功。", 'info');			
		}
		return true;
	};
	//提交后台保存
	obj.saveVerToSrv=function()
	{
		var userID = session['DHCMA.USERID'];
		var pathDr = $("#pathMastID").val();
		var FormCost = $("#txtFormCost").val();
		var FormDays = $("#txtFormDays").val();
		var FormApply = $("#txtFormApply").val();		
		
		var InputStr = PathFormID+"^"+pathDr+"^"+FormCost+"^"+FormDays+"^"+FormApply+"^^1^^^"+userID+"^^0^^^^";
		var data = $.cm({ClassName:"DHCMA.CPW.BT.PathForm",MethodName:"Update",
				"aInputStr":InputStr,
				"aSeparete":"^"
			},false);
		if(parseInt(data)<0){
			$.messager.alert("提示","失败！");
		}else{			
			//
			obj.Win_close();
		}
	};
	//删除按钮处理事件
	obj.delHandler= function(){
		if(obj.editIndex ==null){return;}
		if (obj.modifyBeforeRow.ID == null) { return; }
		
		if (obj.modifyBeforeRow.ID){			
			$.messager.confirm("确认","确定删除?",function(r){
				if(r){					
					$.cm({ClassName:'DHCMA.CPW.BT.PathAdmit',MethodName:'DeleteById','aId':obj.modifyBeforeRow.ID},function(data){
						//debugger;
						if(parseInt(data)<0){
							$.messager.alert("提示","失败！");  //data.msg
						}else{							
							//重新加载datagrid的数据  
							obj.admitList.load({
								ClassName:"DHCMA.CPW.BTS.PathAdmitSrv",
								QueryName:"QryPathAdmit",
								aBTPathDr:$("#pathMastID").val() 
							}); 
							obj.editIndex = null;
						}
					});
				}
			});
		}
	};
	obj.endEditing=function(){
		if (obj.editIndex == undefined){return true}
		if ($('#admitList').datagrid('validateRow', obj.editIndex)){	
			//列表中下拉框实现，修改后把回写
			var ed = $('#admitList').datagrid('getEditor', {index:obj.editIndex,field:'BTTypeDr'});
			var BTTypeDrDesc = $(ed.target).combobox('getText');
			$('#admitList').datagrid('getRows')[obj.editIndex]['BTTypeDrDesc'] = BTTypeDrDesc;
			$('#admitList').datagrid('endEdit', obj.editIndex);
			//保存后台数据
			obj.modifyAfterRow = $('#admitList').datagrid('getRows')[obj.editIndex];
			obj.saveToSrv();						
			obj.editIndex = null;
			return true;
		} else {
			return false;
		}
	};
	obj.Win_close = function(){
		//刷新父页面
		//var opt = websys_showModal("options");
		//opt.originWindow.$('#List').datagrid('reload');	
	    
	    //parent.$('#WinModalEasyUI').window('close');
		if(top.$ && top.$("#WinModalEasyUI").length>0) top.$("#WinModalEasyUI").window("close");
	}
	//事件绑定
	obj.LoadEvents = function(arguments){
		$("#addIcon").on('click',function(){
			// 添加一行
			if (obj.endEditing()) {
				//$("#dg").datagrid("appendRow");
				$("#admitList").datagrid("appendRow", {
					ID:"",
					BTPathDr: $("#pathMastID").val(),
					BTTypeDr: "",
					BTTypeDrDesc: "",
					BTICD10: "",
					BTICDKeys: "",
					BTOperICD:"",
					BTOperKeys:"",
					BTIsICDAcc:"否",
					BTIsOperAcc:"否",
					BTIsActive:"是"
				});
				obj.editIndex = $("#admitList").datagrid("getRows").length - 1;
				$("#admitList").datagrid("selectRow", obj.editIndex).datagrid("beginEdit", obj.editIndex);
			}
		});
		$("#editIcon").on('click',function(){
			obj.endEditing();
		});	
		$("#delIcon").on('click',function(){			
			obj.delHandler();
		});	
		$("#btnClose").on('click',function(){			
			if(top.$ && top.$("#WinModalEasyUI").length>0) top.$("#WinModalEasyUI").window("close");
		});	
		$("#btnSave").on('click',function(){
			obj.saveVerToSrv();
			
		});	
		//默认选择第一条科室
		//$('#ulEpMX li:first-child').click();
		$("body").layout();
		//$("#layoutId").layout("resize");
		//$.parser.parse($('#dictDlg').parent());
		$.parser.parse($("body"));
		//$("body").layout('collapse','west');
	};
}

