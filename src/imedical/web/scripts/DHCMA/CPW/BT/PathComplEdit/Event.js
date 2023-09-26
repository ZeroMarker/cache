//页面Event
function InitPathComplListWinEvent(obj){
	//弹窗初始化
	$('#winPathComplEdit').dialog({
		title: '合并症维护',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
	});

	$('#winPathComplExtEdit').dialog({
		title: '合并症扩展项维护',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:false,//true,
		
	});
     obj.LoadEvent = function(args){ 
     	//保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#winPathComplEdit').close();
     	});
		//添加
     	$('#btnAdd').on('click', function(){
			
			obj.layer1();
     	});
		//编辑
		$('#btnEdit').on('click', function(){
	     	var rd=obj.gridPathCompl.getSelected();
			obj.layer1(rd);		
     	});
		//删除
		$('#btnDelete').on('click', function(){
	     	obj.btnDelete_click();
     	});
		//保存子类
		$('#btnSubSave').on('click', function(){
	     	obj.btnSaveSub_click();
     	});
		//关闭子类
		$('#btnSubClose').on('click', function(){
	     	$HUI.dialog('#winPathComplExtEdit').close();
     	});
		//删除子类
     	$('#btnSubDelete').on('click', function(){
			if(!obj.RecRowID1) return;
	     	obj.btnDeleteSub_click();
     	});
		//编辑子类
     	$('#btnSubEdit').on('click', function(){
			if(!obj.RecRowID1) return;
	     	var rd=obj.gridPathComplExt.getSelected();
			obj.layer2(rd);	
			
     	});
		//添加子类
     	$('#btnSubAdd').on('click', function(){
			if(!obj.RecRowID1) return;
			obj.layer2();
			
     	});
     	//obj.PathComplExtLoad();
     }
///鼠标点击事件
	//选择合并症
	obj.gridPathCompl_onSelect = function (){
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID1="";
		var rowData = obj.gridPathCompl.getSelected();
		
		if (rowData["BTID"] == obj.RecRowID1) {
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$("#btnSubAdd").linkbutton("disable");
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
			obj.RecRowID1="";
			obj.gridPathCompl.clearSelections();  //清除选中行
		} else {
			obj.RecRowID1 = rowData["BTID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
			obj.PathComplExtLoad();  //加载子分类
		}
	} 
	//双击编辑事件 父表
	obj.gridPathCompl_onDbselect = function(rd){
		obj.layer1(rd);
	}
	//选择子分类
    obj.gridPathComplExt_onSelect = function (){
		if($("#btnEdit").hasClass("l-btn-disabled")) return;
		if(!obj.RecRowID1) return;
		if($("#btnSubEdit").hasClass("l-btn-disabled")) obj.RecRowID2="";
	    var rowData = obj.gridPathComplExt.getSelected();
	    if (rowData["ExtID"] == obj.RecRowID2) {
			$("#btnSubAdd").linkbutton("enable");
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
			obj.RecRowID2="";
			obj.gridPathComplExt.clearSelections();  //清除选中行
		} else {
			obj.RecRowID2 = rowData["ExtID"];
			$("#btnSubAdd").linkbutton("disable");
			$("#btnSubEdit").linkbutton("enable");
			$("#btnSubDelete").linkbutton("enable");
		}
    }
	//双击编辑事件 子表
	obj.gridPathComplExt_onDbSelect = function(rd){
		if($("#btnEdit").hasClass("l-btn-disabled")) {
			$.messager.alert("错误提示", "请先选择左表中的数据" , 'info');
			return;
		}
		if(!obj.RecRowID1) return;
		obj.layer2(rd);
	}
///	表的操作
	//保存 父表
	obj.btnSave_click = function(){
		var errinfo = "";
		var myDate = new Date();
		var Code = $('#txtCode').val();
		var Desc = $('#txtDesc').val();
		var IsActive = $("#chkIsActive").checkbox('getValue')? '1':'0';
		var BTActDate ='';
		var BTActTime='';
		var BTActUserID="";
		if(session['DHCMA.USERID']) BTActUserID=session['DHCMA.USERID'];
		
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}	
		var IsCheck = $m({
			ClassName:"DHCMA.CPW.BT.PathCompl",
			MethodName:"CheckPTCode",
			aCode:Code,
			aID:obj.RecRowID1
		},false);
	  	if(IsCheck>=1) {
	  		errinfo = errinfo + "代码与列表中现有项目重复，请检查修改!<br>";
	  	}
	  	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID1;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + IsActive;
		inputStr = inputStr + CHR_1 + BTActDate;
		inputStr = inputStr + CHR_1 + BTActTime;
		inputStr = inputStr + CHR_1 + BTActUserID;
		
		var flg = $m({
			ClassName:"DHCMA.CPW.BT.PathCompl",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:CHR_1
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#winPathComplEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID1=flg	
			obj.gridPathCompl.reload() ;//刷新当前页
		}
	}
	//删除 父表 
	obj.btnDelete_click = function(){
		var rowID = obj.gridPathCompl.getSelected()["BTID"];
		if (rowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.CPW.BT.PathCompl",
					MethodName:"DeleteById",
					aId:rowID
				},false);
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID1 = "";
					obj.gridPathComplExt.reload() ;//刷新当前页
					obj.gridPathCompl.reload() ;//刷新当前页
				}
			} 
		});
	}
	
	//保存 子表
	obj.btnSaveSub_click =  function(){
		var errinfo = "";
		var inputStr= ""		
		var Desc = $('#txtExtDesc').val();
		
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}
		//检查代码是否重复
		var IsCheck=$m({
			ClassName:"DHCMA.CPW.BT.PathComplExt",
			MethodName:"CheckBTSDesc",
			aDesc:Desc,
			aSubID:obj.RecRowID2
		},false);
	  	if(IsCheck==1)
	  	{
	  		errinfo = errinfo + "代码与列表中现有项目重复，请检查修改!<br>";
	  	}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		if(obj.RecRowID2){
		var str=obj.RecRowID2.split('||');
			inputStr = str[0] + CHR_1 + str[1] 
		}else{
			inputStr = obj.RecRowID1 + CHR_1 + "" 
		}
		inputStr = inputStr + CHR_1 + Desc;
		
		var flg = $m({
			ClassName:"DHCMA.CPW.BT.PathComplExt",
			MethodName:"Update",
			aInStr:inputStr,
			aSeparete:CHR_1
		},false);
		if (parseInt(flg) <= 0) {
			
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
			
		}else {
			$HUI.dialog('#winPathComplExtEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID2 =flg
			obj.gridPathComplExt.reload() ;//刷新当前页
		}
	}
	//删除 子表
	obj.btnDeleteSub_click = function(){
		var rowDataID = obj.gridPathComplExt.getSelected()["BTSID"];
		if ((obj.RecRowID1=="")||(rowDataID=="")){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
			if (r) {				
				 var flg = $m({
					ClassName:"DHCMA.CPW.BT.PathComplExt",
					MethodName:"DeleteById",
					aId:obj.RecRowID1+"||"+rowDataID
				},false);	 
				
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID2 = "";
					obj.gridPathComplExt.reload() ;//刷新当前页	
				}
			}
		});

	}
    //由父表ID加载子表
	obj.PathComplExtLoad = function () {
		var ParRef = "";
		if (obj.RecRowID1) {
			ParRef =obj.RecRowID1;
		}
		obj.gridPathComplExt.load({
			ClassName:"DHCMA.CPW.BTS.PathComplExtSrv",
			QueryName:"QryPathComplExt",
			aParRef:ParRef
		});
	}
	//配置窗体-初始化
	obj.layer1= function(rd){
		if(rd){
			obj.RecRowID1=rd["BTID"];
			var Code = rd["BTCode"];
			var Desc = rd["BTDesc"];
			var BTIsActiveDesc = rd["BTIsActiveDesc"];
			BTIsActiveDesc = (BTIsActiveDesc=="是"? true: false)
			$('#txtCode').val(Code);
			$('#txtDesc').val(Desc);
			$('#chkIsActive').checkbox('setValue',BTIsActiveDesc);
		}else{
			obj.RecRowID1="";
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#chkIsActive').checkbox('setValue',false);
		}
		$HUI.dialog('#winPathComplEdit').open();
	}
	
///配置窗体-初始化
	obj.layer2= function(rd){
		if(rd){
			obj.RecRowID2 =rd["ExtID"];
			var ExtDesc = rd["ExtDesc"];	
			$('#txtExtDesc').val(ExtDesc);
		}else{
			obj.RecRowID2="";
			$('#txtExtDesc').val('');
		}
		$HUI.dialog('#winPathComplExtEdit').open();
	}		
	
}