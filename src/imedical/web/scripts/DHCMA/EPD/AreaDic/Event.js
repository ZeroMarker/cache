//页面Event
function InitAreaDicWinEvent(obj){
	obj.LoadEvent = function(args){
		$("#btnAdd").on('click',function(){
			obj.initDialog();
		});
	}
	//双击触发
	obj.gridAreaDic_onDblClickRow = function(rowData){
		obj.initDialog(rowData);
	}	
	//初始化模态框
	obj.initDialog =function(){
		if(arguments.length>0){
			var rowData = arguments[0];
			$("#gridAreaDic").val(rowData["RowID"]); //container
			$("#txtCode").val(rowData["Code"]);
			$("#txtShortDesc").val(rowData["ShortDesc"]);
			$("#txtLongDescc").val(rowData["LongDesc"]);
			$("#chkActive").checkbox("setValue",rowData["IsActive"]==1?true:false);
		}else{
			$("#gridAreaDic").val("");
			$("#txtCode").val("");
			$("#txtShortDesc").val("");
			$("#txtLongDescc").val("");
			$("#chkActive").checkbox("setValue","");			
		}
		$HUI.dialog('#dialogAreaDic').open();
	}
	//保存
	obj.update = function(){
		var errInfo = "";
		var inputStr ="";
		//收集数据
		var ID=$("#gridAreaDic").val();
		var Code=$("#txtCode").val();
		var ShortDesc=$("#txtShortDesc").val();
		var LongDesc=$("#txtLongDescc").val();
		var IsActive = $("#chkActive").checkbox("getValue")?"1":"0";
		//判断数据 1.前台校验
			
		if(Code==""){
			errInfo=errInfo+"代码为空！<br>";
		}
		if(ShortDesc==""){
			errInfo=errInfo+"名称为空！<br>"
		}
		if(LongDesc==""){
			errInfo=errInfo+"全名为空！<br>"
		}
		if(errInfo!=""){
			$.messager.alert("错误提示",errInfo,'info');
			return
		}
		var patrn=/^\d{8}$/;
		if(!patrn.exec(Code)){
			errInfo = errInfo + "代码只能是8位数字,请重新填写!<br>";
		}
		if (errInfo) {
			$.messager.alert("错误提示", errInfo, 'info');
			return;
		}  
		//2.新增后台校验   
		if (!ID){
			var reCheck = $m({
				ClassName:"DHCMed.EPD.AreaDic",
				MethodName:"CheckCode",
				aCode:Code
			},false);
			if (reCheck==1) {
				$.messager.alert("错误提示", "代码已存在!", 'info');
				return;
			}
		}
		
		//处理数据 1.整理
		inputStr += ID;
		inputStr += "^" + Code;
		inputStr += "^" + ShortDesc;
		inputStr += "^" + LongDesc;
		inputStr += "^";
		inputStr += "^"+obj.ParentId;
		inputStr += "^";
		inputStr += "^";
		inputStr += "^" + IsActive;
		//2.保存
		
		var flg = $m({
			ClassName:"DHCMed.EPD.AreaDic",
			MethodName: "Update",
			InStr:inputStr
		},false);
		
		//3.根据保存结果处理
		if(parseInt(flg)<=0){
			if(parseInt(flg)=0)$.messager.alert("错误提示","参数错误!",'info');
			if(parseInt(flg)<0)$.messager.alert("错误提示","错误:"+flg,'info');
		}else{
			$HUI.dialog("#dialogAreaDic").close();
			$.messager.popover({msg:'保存成功',type:'success',timeout:1000});
			var param=$("#gridAreaDic").datagrid("options").queryParams;
			param.aParentID=obj.ParentId;
			$("#gridAreaDic").datagrid("reload");
		}	
	}
	

	//隐藏弹窗
	$("#dialogAreaDic").dialog({
		title:"省市县乡维护",
		iconCls:"icon-w-paper",
		modal:true,
		isTopZindex:true,
		buttons:[{
			text:'保存',
			handler:function(){
				obj.update();	
			}},{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#dialogAreaDic').close();
			}
		}]
	});
	
	
}
	
	
