//页面Event
function InitHISUIWinEvent(obj){
	//CheckSpecificKey();
	//提交后台保存
	obj.savePathLocToSrv=function()
	{		
		var userID = session['DHCMA.USERID'];
		var PDLocID = $('#cboLocDr').combobox('getValue');
		if(PDLocID=="")
		{
			$.messager.alert("提示","请选择添加路径的科室！");
			return false;
		}
		var row = $('#pathList').datagrid('getSelected');
		var pathDr = "";
		if (row){
			if(row.BTAdmType==""){
				$.messager.alert("提示","路径就诊类型为空，请维护路径就诊类型！");
				return false;
			}
			pathDr = row.BTID;
		}
		else
		{
			$.messager.alert("提示","请选择路径列表的路径！");
			return false;
		}
		var InputStr = "^"+PDLocID+"^"+pathDr+"^1^^^"+userID;
		var data = $.cm({ClassName:"DHCMA.CPW.BT.PathLoc",MethodName:"Update",
				"aInputStr":InputStr,
				"aSeparete":"^"
			},false);
		if(parseInt(data)<0){
			if(parseInt(data)==-2)
			{
				$.messager.alert("失败","添加失败，科室已经存在该路径！");
			}
			else
			{
				$.messager.alert("失败","添加失败，住院科室无法关联门诊路径或门诊科室无法关联住院径！");
			}			
			return false;
		}else{			
			return true;
		}
		return true;
	};
	//提交后台保存
	obj.deletePathLocToSrv=function()
	{		
		
		var row = $('#pathLocList').datagrid('getSelected');
		var objID = "";
		if (row){
			objID = row.BTID;
		}
		else
		{
			$.messager.alert("提示","请选择要移除的科室路径！");
			return false;
		}
		
		var data = $.cm({ClassName:"DHCMA.CPW.BT.PathLoc",MethodName:"DeleteById",
				"aId":objID
			},false);
		if(parseInt(data)<0){
			
			$.messager.alert("提示","保存失败！");	
			return false;
		}else{			
			return true;
		}
		return true;
	};
	//事件绑定
	obj.LoadEvents = function(arguments){
		$("#btnAddR").hover(function(){$("#btnAddL").css("background-color","#378ec4");},function(){$("#btnAddL").css("background-color","");});
		$("#btnAddL,#btnAddR").on('click',function(){
			var rst = obj.savePathLocToSrv();
			if(rst)
			{
				obj.pathLocList.load({
					ClassName:"DHCMA.CPW.BTS.PathLocSrv",
					QueryName:"QryPathByLoc",
					aLocDr:$('#cboLocDr').combobox('getValue')
				});	
			}
		});
		$("#btnDel").on('click',function(){
			
			var rst = obj.deletePathLocToSrv();
			if(rst)
			{
				obj.pathLocList.load({
					ClassName:"DHCMA.CPW.BTS.PathLocSrv",
					QueryName:"QryPathByLoc",
					aLocDr:$('#cboLocDr').combobox('getValue')
				});	
			}
		});
		$("#txtDesc").keydown(function() {//给输入框绑定按键事件 
			if(event.keyCode == "13") {//判断如果按下的是回车键则执行下面的代码 
				obj.pathList.load({
					ClassName:"DHCMA.CPW.BTS.PathLocSrv",
					QueryName:"QryPathMast",
					aTypeDr:Common_GetValue("cboTypeDr"),
					aKeyWord:$("#txtDesc").val()
				});
			} 
		});		
		$("#cboLocDr").combobox({
			onChange: function (newValue,oldValue) {
				obj.pathLocList.load({
					ClassName:"DHCMA.CPW.BTS.PathLocSrv",
					QueryName:"QryPathByLoc",
					aLocDr:newValue
				});
			}
		});
		$("body").layout();
		//$("#layoutId").layout("resize");
		//$.parser.parse($('#dictDlg').parent());
		$.parser.parse($("body"));
		//$("body").layout('collapse','west');
	};	
}


