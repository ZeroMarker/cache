var g_PasswordChange = 0;
var delClick = function(){
	$.ajaxRunServerMethod({ClassName:"dhc.sync.web.User", MethodName:"Del",RowId:$("#RowId").val()},function(data){
		if (data==0){
			$.messager.alert('成功',"删除成功!");
			$("#Clear").click();
			$("#Find").click();
		}else{
			$.messager.alert('失败',data.split("^")[1]);
		}
	})
}
var changePasswordFlag = function(){
	g_PasswordChange = 1;
}
// disableItems(["Code","Password","Mnemonics","Number","Secgroup","InvalidDate"]);
var disableItems = function(arr){
	for (var i =0 ;i<arr.length; i++){
		$("#"+arr[i]).prop("disabled",true)
	}
};
var enableItems = function(arr){
	for (var i =0 ;i<arr.length; i++){
		$("#"+arr[i]).prop("disabled",false)
	}
};
var NameKeyup = function(event){
	if(event.keyCode==13){
		var name = $("#Name").val();		
		$.ajaxRunServerMethod({ClassName:"dhc.sync.web.User",MethodName:"GetInitInfoByName",name:name},function(data){
			if (data){
				if ("string" == typeof data ){
					var rowData = $.parseJSON(data);
					g_PasswordChange = 0 ;
					$('#Code').val(rowData["UserCode"]);
					g_PasswordChange = 1;
					$('#Password').val(rowData["UserPassword"]),
					$('#Mnemonics').val(rowData["UserMnemonics"]);
					//$('#Ename').val(rowData["UserEname"]);
					//$('#Fname').val(rowData["UserFname"]);
					$('#Number').val(rowData["UserNumber"]);
					$('#Secgroup').combogrid("setValue",rowData["UserSecgroup"]);
					$("#InvalidDate").datebox("setValue",rowData["UserInvalidDate"]);
				}	
			}
		})
	}
};
var ENameKeyup = function (event){
	if(event.keyCode==13){
		$("#Fname").focus();
	}
};
var FNameKeyup = function (event){
	if(event.keyCode==13){
		$("#Email").val($("#Ename").val()+"."+$("#Fname").val()+"@chcruikang.com");
		$("#Email").focus();
		
	}
};
$(function(){
	$.ajaxRunServerQuery({ClassName:"dhc.sync.web.System",QueryName:"Find",Code:"",Active:"Y"},
		function(data,textStatus){
			if(""!==data){
				var sysData = [];
				for(var i=0; i<data.total;i++){
					sysData[i]={id:data.rows[i].SysCode,text:data.rows[i].SysCode};
				}
				$('#SysCode').combotree({
					delay: 1000,
					panelWidth:350,
					mode: 'local',
					multiple:true,
					data:[{
						"text":"子系统",
						"id":"ALL",
						"state":"open",
						"children":sysData
					}]
				});
				$('#ImportData').click(function(){
					var arr = $('#SysCode').combotree("getValues");
					if (arr && arr.length>0){
						$.messager.confirm('提示',"你确定从"+arr[0]+"系统中导入用户信息?",function(r){  
						    if (r){
								var over = 0;
							   if ($("#overCB").prop("checked")){
									over = 1;
							   } 
						       $.ajaxRunServerMethod({ClassName:"dhc.sync.web.User", MethodName:"ImportData",over:over,SysCode:arr[0]},
									function(data){
										if (parseInt(data)>=0){
											$.messager.alert('成功',"成功导入 "+data+" 条用户数据!");
											$("#Clear").click();
											$("#Find").click();
										}else{
											$.messager.alert('失败',data.split("^")[1]);
										}
									})
						    }  
						});  
					}else{
						$.messager.alert('提示',"请选择系统代码");
					}
				});
				$('#ExportData').click(function(){
					var arr = $('#SysCode').combotree("getValues");
					if (arr && arr.length>0){
						$.messager.confirm('提示',"你确定批量把用户信息导入到:"+arr[0]+"系统中?",function(r){  
						    if (r){  
						       $.ajaxRunServerMethod({ClassName:"dhc.sync.web.User", MethodName:"ExportData",over:0,SysCode:arr[0]},
									function(data){
										if (parseInt(data)>0){
											$.messager.alert('成功',"导出"+data+" 条数据到 "+arr[0]+"系统中!");
											$("#Clear").click();
											$("#Find").click();
										}else{
											$.messager.alert('失败',data.split("^")[1]);
										}
									})
						    }  
						});  
					}else{
						$.messager.alert('提示',"请选择系统代码");
					}
				});
			}
		}
	);
	$("#Name").bind({"keyup":NameKeyup});
	$("#Ename").bind({"keyup":ENameKeyup});
	$("#Fname").bind({"keyup":FNameKeyup});
	$('#Deptcode').combogrid({
		delay: 1000,
		panelWidth:350,
		mode: 'remote',
		queryParams:{ClassName: 'dhc.sync.web.Loc',QueryName: 'Find'},
		url: 'jquery.easyui.querydatatrans.csp',
		onBeforeLoad:function(param){
			param = $.extend(param,{Code:param.q});
			return true;
		},
		idField: 'LocCode',
		textField: 'LocName',
		columns: [[{field:'LocCode',title:'代码',align:'right',width:100},
		{field:'LocName',title:'名称',align:'right',width:200},
		{field:'LocLevel',title:'LocLevel',align:'right',width:100},
		{field:'LocRowId',title:'LocRowId',align:'right',width:100},
		{field:'LocSuper',title:'LocSuper',align:'right',width:100},{field:'LocState',title:'LocState',align:'right',width:100},{field:'LocIsLast',title:'LocIsLast',align:'right',width:100},{field:'LocType',title:'LocType',align:'right',width:100},{field:'LocDGroup',title:'LocDGroup',align:'right',width:100},{field:'LocClassify',title:'LocClassify',align:'right',width:100},{field:'LocAddress',title:'LocAddress',align:'right',width:100},{field:'LocPhone',title:'LocPhone',align:'right',width:100},{field:'LocMnemonics',title:'LocMnemonics',align:'right',width:100},{field:'LocStartDate',title:'LocStartDate',align:'right',width:100},{field:'LocEndDate',title:'LocEndDate',align:'right',width:100},{field:'LocStorey',title:'LocStorey',align:'right',width:100},{field:'LocCatalogue',title:'LocCatalogue',align:'right',width:100},{field:'LocDept',title:'LocDept',align:'right',width:100},{field:'LocSysCode',title:'LocSysCode',align:'right',width:100}]]
	});
	
	$('#HealthType').combogrid({
		delay: 1000,
		panelWidth:350,
		mode: 'remote',
		queryParams:{ClassName: 'web.CTCarPrvTp',QueryName: 'LookUp'},
		url: 'jquery.easyui.querydatatrans.csp',
		idField: 'Code',
		textField: 'Description',
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param.q});
			return true;
		},
		columns: [[{field:'Description',title:'Description',align:'right',width:100},{field:'HIDDEN',title:'HIDDEN',align:'right',width:100,hidden:true},{field:'Code',title:'Code',align:'right',width:100}]]
	});
	$('#Secgroup').combogrid({
		delay: 1000,
		panelWidth:350,
		mode: 'remote',
		queryParams:{ClassName: 'web.SSGroup',QueryName: 'LookUp'},
		url: 'jquery.easyui.querydatatrans.csp',
		idField: 'Code',
		textField: 'Description',
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param.q});
			return true;
		},
		columns: [[{field:'Description',title:'Description',align:'right',width:100},{field:'HIDDEN',title:'HIDDEN',align:'right',width:100,hidden:true},{field:'Code',title:'Code',align:'right',width:100}]]
	});
	$('#Type').combogrid({
		delay: 1000,
		panelWidth:350,
		mode: 'remote',
		queryParams:{ClassName: 'dhc.sync.web.UserType',QueryName: 'Find'},
		url: 'jquery.easyui.querydatatrans.csp',
		idField: 'TypeCode',
		textField: 'TypeName',
		columns: [[{field:'TypeRowId',title:'TypeRowId',align:'right',width:100,hidden:true},{field:'TypeCode',title:'TypeCode',align:'right',width:100},{field:'TypeName',title:'TypeName',align:'right',width:100},{field:'TypeActive',title:'TypeActive',align:'right',width:100}]]
	});
	$('#Dleader').combogrid({
		delay: 1000,
		panelWidth:350,
		mode: 'remote',
		queryParams:{ClassName: 'dhc.sync.web.User',QueryName: 'Find'},
		url: 'jquery.easyui.querydatatrans.csp',
		idField: 'UserCode',
		textField: 'UserName',
		columns: [[{field:'UserRowId',title:'UserRowId',align:'right',width:100},{field:'UserCode',title:'UserCode',align:'right',width:100},{field:'UserName',title:'UserName',align:'right',width:100}]]
	});
	$("#Password").bind({"change":changePasswordFlag,"blur":changePasswordFlag});
	var getFormJson = function(){
		var State=1;
		if ($('#State').prop("checked")==true){
			State = 1;
		}else{
			State = 2;
		}
		var ISDrugRight = "Y";
		if ($("#ISDrugRight").prop("checked") != true){
			ISDrugRight = "N"
		}
		var IsExpert = "Y";
		if ($("#IsExpert").prop("checked") != true){
			IsExpert = "N"
		}
		var password = $('#Password').val();
		if (password!="" && password.length!==32){ //加过密不再加
			password = hex_md5(dhc_cacheEncrypt(password));
		}
		var json = {
			RowId: $('#RowId').val(),
			Code: $('#Code').val(),
			Name: $('#Name').val(),
			Password:password,
			PasswordChange : g_PasswordChange,
			Mnemonics: $('#Mnemonics').val(),
			Deptcode: $('#Deptcode').combogrid("getValue"),
			Ename: $('#Ename').val(),
			Fname : $('#Fname').val(),
			Number : $('#Number').val(),
			HealthType: $('#HealthType').combogrid("getValue"),
			Secgroup : $('#Secgroup').combogrid("getValue"),
			Email : $('#Email').val(),
			Certificate : $('#Certificate').val(),
			Landline : $('#Landline').val(),
			Type : $('#Type').combogrid("getValue"),
			ISDrugRight : ISDrugRight,
			Position : $("#Position").val(),
			Company : $("#Company").val(),
			InvalidDate : $("#InvalidDate").datebox("getValue"),
			EegDate : $("#EegDate").datebox("getValue"),
			State : State,
			IsExpert : IsExpert,
			Dleader : $("#Dleader").combogrid("getValue"),
			SysCode:$('#SysCode').combotree('getValues').join(",")
		}
		return json;
	}
	$('#Find').click(function(){
		var q = $.extend({ ClassName:"dhc.sync.web.User", QueryName:"Find"},getFormJson());
		$('#tdhc_sync_data_User').datagrid('load',q);
	}).linkbutton({iconCls: 'icon-search'});
	
	$('#Save').click(function(){
		var q = $.extend({ClassName:"dhc.sync.web.User", MethodName:"Save"},getFormJson());
		$.ajaxRunServerMethod(q,function(data){
			if (parseInt(data)>=0){
				$.messager.alert('成功',"保存成功!");
				$("#Clear").click();
				$("#Find").click();
			}else{
				$.messager.alert('失败',data.split("^")[1]);
			}
		})
	}); //.linkbutton({iconCls: 'icon-add'});
	$('#Clear').click(function(){
			enableItems(["Name","Code","Password","Mnemonics","Number","Secgroup","InvalidDate"]);
			$('#RowId').val("");
			$('#Code').val("");
			$('#Name').val("");
			$('#Password').val("");
			$('#Mnemonics').val("");
			$('#Deptcode').combogrid("setValue","");
			$('#Ename').val("");
			$('#Fname').val("");
			$('#Number').val("");
			$('#HealthType').combogrid("setValue","");
			$('#Secgroup').combogrid("setValue","");
			$('#Email').val("");
			$('#Certificate').val("");
			$('#Landline').val("");
			$('#Type').combogrid("setValue","");
			$("#ISDrugRight").prop("checked",false);
			$("#Position").val("");
			$("#Company").val("");
			$("#InvalidDate").datebox("setValue","");
			$("#EegDate").datebox("setValue","");
			$("#IsExpert").prop("checked",false);
			$("#State").prop("checked",true);
			$("#Dleader").combogrid("setValue","");
			$('#SysCode').combotree('setValues',"");
			g_PasswordChange = 0;
			$("#Del").unbind("click",delClick).linkbutton('disable');
	});
	$("#tdhc_sync_data_User").datagrid("options").onClickRow = function(index,rowData){
		if (index>-1){
			g_PasswordChange = 0 ;
			disableItems(["Name","Code","Password","Mnemonics","Number","Secgroup","InvalidDate"]);
			$('#RowId').val(rowData["UserRowId"]);
			$('#Code').val(rowData["UserCode"]);
			$('#Name').val(rowData["UserName"]);
			$('#Password').val("******"),
			$('#Mnemonics').val(rowData["UserMnemonics"]);
			$('#Deptcode').combogrid("setValue",rowData["UserDeptcode"]);
			$('#Ename').val(rowData["UserEname"]);
			$('#Fname').val(rowData["UserFname"]);
			$('#Number').val(rowData["UserNumber"]);
			$('#HealthType').combogrid("setValue",rowData["UserHealthType"]);
			$('#Secgroup').combogrid("setValue",rowData["UserSecgroup"]);
			$('#Email').val(rowData["UserEmail"]);
			$('#Certificate').val(rowData["UserCertificate"]);
			$('#Landline').val(rowData["UserLandline"]);
			$('#Type').combogrid("setValue",rowData["UserType"]);
			$("#ISDrugRight").prop("checked",true);
			$("#Position").val(rowData["UserPosition"]);
			$("#Company").val(rowData["UserCompany"]);
			$("#InvalidDate").datebox("setValue",rowData["UserInvalidDate"]);
			$("#EegDate").datebox("setValue",rowData["UserEegDate"]);
			var State=rowData["UserState"];
			if (State=="有效"){
				State = true;
			}else{
				State = false;
			}
			var IsExpert=rowData["UserIsExpert"];
			if (IsExpert=="是"){
				IsExpert = true;
			}else{
				IsExpert = false;
			}
			var ISDrugRight=rowData["UserISDrugRight"];
			if (ISDrugRight=="Y"){
				ISDrugRight = true;
			}else{
				ISDrugRight = false;
			}
			$("#IsExpert").prop("checked",IsExpert);
			$("#State").prop("checked",State);
			$("#Dleader").combogrid("setValue",rowData["UserDleader"]);
			$('#SysCode').combotree('setValues',rowData["UserSysCode"].split(","));
			$('#ISDrugRight').prop("checked",ISDrugRight);
			$("#Del").bind("click",delClick).linkbutton('enable');
		}
	};
	var docHeight = $(document.body).height();
	var formHeight = 500;
	var listHeight = (docHeight-formHeight)<350?350:(docHeight-formHeight);
	$("#tdhc_sync_data_User").datagrid("resize",{height:listHeight});
	$("#Del").linkbutton('disable').linkbutton({iconCls: 'icon-remove'});
	$('#State').prop("checked",true);
})