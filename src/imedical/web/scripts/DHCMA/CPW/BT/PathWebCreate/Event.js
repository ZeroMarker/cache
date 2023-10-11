//页面Event
function InitHISUIWinEvent(obj){
	$('#winAddPathMast').dialog({
		title: '新增路径',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
	});
	$('#winStep').dialog({
		title: '阶段维护',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		width:320,
		isTopZindex:true,
	});
	$('#winEpItem').dialog({
		title: '项目维护',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		onBeforeClose:function(){ 
			$('#EpItemGrid').datagrid('loadData', { total: 0, rows: [] });
			obj.InitPathInfo();
		}
	});
	$('#winEpYZItem').dialog({
		title: '医嘱维护',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		onBeforeClose:function(){ 
			$('#YZEpItemGrid').datagrid('loadData', { total: 0, rows: [] });
			obj.InitPathInfo();
		}
	});
	//事件绑定
	obj.LoadEvents = function(arguments){
		$("#btnComplete").on('click',function(){
			$.messager.confirm("完成", "完成操作不可修改，确定完成表单?", function (r) {
			if(r){
				var flg = $m({
					ClassName:"DHCMA.CPW.BT.PathWebCreate",
					MethodName:"ComPleteForm",
					aPathFormDr:obj.PathFormID
					},false);
				if (parseInt(flg) > 0) {
					$.messager.popover({msg: '表单完成成功！',type:'success',timeout: 1000});
					$("#workD").hide();
					$("#workS").show();
					obj.PathFormID=""
					obj.pathWebList.reload();
					//obj.InitPathInfo();
				}else{
					$.messager.alert("错误提示", "表单完成错误!Error=" + flg, 'info');
					return
				}
			}
			})
		});
		$("#btnDel").on('click',function(){
			$.messager.confirm("删除", "删除操作不可恢复，确定删除表单?", function (r) {
			if(r){
				var flg = $m({
					ClassName:"DHCMA.CPW.BT.PathWebCreate",
					MethodName:"DeleteById",
					aId:obj.PathWebID
					},false);
				if (parseInt(flg) == 0) {
					$.messager.popover({msg: '表单删除成功！',type:'success',timeout: 1000});
					$("#workD").hide();
					$("#workS").show();
					obj.PathWebID=""
					obj.pathWebList.reload();
				}else{
					$.messager.alert("错误提示", "表单删除错误!Error=" + flg, 'info');
					return
				}
			}
			})
		});
		//新增路径
		$("#btnAddMast").on('click',function(){
			$("#cboKbTmp").lookup("enable");
			obj.MastID=""
			$HUI.dialog('#winAddPathMast').open();
		});
		//关闭路径窗口
		$("#btnCloseMast").on('click',function(){
			obj.ClearpathWeb();
			$HUI.dialog('#winAddPathMast').close();
		});
		//新增病种
		$("#addEntity").on('click',function(){
			if (obj.entityflag){
				$('#cboEntity').combobox('clear'); 
				$('#cboEntity').combobox('disable'); 
				$("#addEntity").attr("title","自选病种")
				$("#addEntity").attr("class","icon-unuse")
			}else{
				$('#cboEntity').combobox('enable'); 
				$("#addEntity").attr("title","新增病种")
				$("#addEntity").attr("class","icon-add")
			}
			obj.entityflag=!obj.entityflag
			$(".entity").toggle();
			
		});
		//保存路径
		$("#btnSaveMast").on('click',function(){
			obj.btnSaveMast_click();
		});
		//保存阶段
		$('#btnSaveStep').on('click', function(){
			var Description=$('#btnSaveStep').linkbutton('options').text;
			if (Description.indexOf("保存新阶段")>-1){
				obj.btnCopyStep_click();
			}else{
	     		obj.btnSaveStep_click();
			}
     	});
     	//关闭阶段
     	$('#btnCloseStep').on('click', function(){
	     	obj.ClearStepm();
	     	$HUI.dialog('#winStep').close();
     	});
     	//保存项目
		$('#btnSaveEpItem').on('click', function(){
	     	obj.btnSaveEpItem_click();
     	});
     	//关闭项目
     	$('#btnCloseEpItem').on('click', function(){
	     	obj.ClearEpItem();
	     	$HUI.dialog('#winEpItem').close();
     	});
     	//关闭项目
     	$('#btnEditCloseEpItem').on('click', function(){
	     	obj.ClearEditEpItem();
	     	$HUI.dialog('#winEpItem').close();
     	});
     	//保存医嘱项目
		$('#btnSaveEpYZItem').on('click', function(){
	     	obj.btnSaveEpYZItem_click();
     	});
     	//关闭医嘱项目
     	$('#btnCloseEpYZItem').on('click', function(){
	     	obj.ClearEpYZItem();
	     	$HUI.dialog('#winEpYZItem').close();
     	});
     	//关闭医嘱项目
     	$('#btnEditCloseEpYZItem').on('click', function(){
	     	obj.ClearEditEpYZItem();
	     	$HUI.dialog('#winEpYZItem').close();
     	});
     	
     	//添加
     	$('#btnAddEp').on('click', function(){
			obj.addNewEpItem();
     	});
     	//添加
     	$('#btnAddYZEp').on('click', function(){
			obj.addNewYZEpItem();
     	});
     	//保存
		$('#btnSaveEp').on('click', function(){
	     	obj.btnSaveEp_click();
     	});
     	//保存
		$('#btnSaveYZEp').on('click', function(){
	     	obj.btnSaveEpYZ_click();
     	});
     	//删除
		$('#btnDeleteEp').on('click', function(){
	     	obj.DelEpItem();
     	});
     	//删除
		$('#btnDeleteYZEp').on('click', function(){
	     	obj.DelEpItem();
     	});
	};	
	//保存新路径
	obj.btnSaveMast_click = function(){
		var errinfo = "";
		var Code = $('#txtCode').val();
		var Desc = $('#txtDesc').val();
		var BTType=$('#cboType').combobox('getValue');
		var Entity = $('#cboEntity').combobox('getValue');
		var EntityCode = $('#txtEntityCode').val();
		var EntityDesc = $('#txtEntityDesc').val();
		var EntityType=$('#cboEntityType').combobox('getValue');
		//var ComEntity=$('#cboComEntity').combobox('getValue');
		//var ComEntityCode=$('#txtComEntityCode').val();
		//var ComEntityDesc=$('#txtComEntityDesc').val();
		var IOType=$('#cboIOType').combobox('getValue');
		var IsOper = $("#IsOper").checkbox('getValue')? '1':'0';
		var IsActive = $("#IsActive").checkbox('getValue')? '1':'0';
		var IsCompl = $("#IsCompl").checkbox('getValue')? '1':'0';
		var PBID=$('#txtKbTmp').val();
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}	
		if (!IOType) {
			errinfo = errinfo + "就诊类型为空!<br>";
		}
		if (!BTType) {
			errinfo = errinfo + "路径类型为空!<br>";
		}
		
		if (obj.MastID==""){
			var IsCheck = $m({
				ClassName:"DHCMA.CPW.BT.PathMast",
				MethodName:"CheckPTCode",
				aCode:Code
			},false);
		  	if(IsCheck>="1") {
		  		errinfo = errinfo + "代码与现有项目重复，请检查修改!<br>";
		  	} 
		}
	  	if ((EntityDesc=="")&&(EntityCode!="")){
			errinfo = errinfo + "新增病种代码不能为空!<br>";
		} 
		if ((EntityDesc!="")&&(EntityCode=="")){
			errinfo = errinfo + "新增病种代码不能为空!<br>";
		}	
	  	if (EntityCode!=""){
		  	var IsCheck = $m({
				ClassName:"DHCMA.CPW.BT.PathEntity",
				MethodName:"CheckPTCode",
				aCode:EntityCode
				},false);
			if (EntityDesc==""){
					errinfo = errinfo + "新增病种描述不能为空!<br>";
				}
		  	if(IsCheck>=1) {
		  		errinfo = errinfo + "病种代码与列表中现有项目重复，请检查修改!<br>";
		  	}
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		if (obj.MastID==""){
			var inputStr = "";
			inputStr = inputStr + "^" + Code;
			inputStr = inputStr + "^" + Desc;
			inputStr = inputStr + "^" + BTType;
			inputStr = inputStr + "^" + Entity;
			inputStr = inputStr + "^" + EntityCode;
			inputStr = inputStr + "^" + EntityDesc;
			inputStr = inputStr + "^" + EntityType;
			inputStr = inputStr + "^" + IsCompl;
			//inputStr = inputStr + "^" + ComEntity;
			//inputStr = inputStr + "^" + ComEntityCode;
			//inputStr = inputStr + "^" + ComEntityDesc;
			inputStr = inputStr + "^" + IOType;
			inputStr = inputStr + "^" + IsOper;
			inputStr = inputStr + "^" + IsActive;
			inputStr = inputStr + "^" + session['DHCMA.USERID']
			inputStr = inputStr + "^" + session['LOGON.CTLOCID'];
			inputStr = inputStr + "^" + PBID;
			inputStr = inputStr + "^" + session['LOGON.HOSPID']
			var flg = $m({
				ClassName:"DHCMA.CPW.BTS.PathWebCreateSrv",
				MethodName:"SavePathMast",
				aInputStr:inputStr,
				aSeparete:"^"
			},false);
		}else{
			var inputStr = obj.MastID;
			inputStr = inputStr + "^" + Code;
			inputStr = inputStr + "^" + Desc;
			inputStr = inputStr + "^" + BTType;
			inputStr = inputStr + "^" + Entity;
			inputStr = inputStr + "^" + "";
			inputStr = inputStr + "^" + "";
			inputStr = inputStr + "^" + IsActive;
			inputStr = inputStr + "^" + "";
			inputStr = inputStr + "^" + "";
			inputStr = inputStr + "^" + session['DHCMA.USERID']
			inputStr = inputStr + "^" + IOType;
			inputStr = inputStr + "^" + ""
			inputStr = inputStr + "^" + IsOper;
			inputStr = inputStr + "^" + "";
			inputStr = inputStr + "^" + IsCompl;
			var flg = $m({
				ClassName:"DHCMA.CPW.BT.PathMast",
				MethodName:"Update",
				aInputStr:inputStr,
				aSeparete:"^"
			},false);	
		}
		
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == "-1") {
				$.messager.alert("错误提示", "保存病种失败!" , 'info');
			}else if (parseInt(flg) == "-2") {
				$.messager.alert("错误提示", "保存合病种失败!" , 'info');
			}else if (parseInt(flg) == "-3") {
				$.messager.alert("错误提示", "保存路径失败!" , 'info');
			}else if (parseInt(flg) == "-4") {
				$.messager.alert("错误提示", "保存表单失败!" , 'info');
			}else if (parseInt(flg) == "-5") {
				$.messager.alert("错误提示", "保存web记录失败!" , 'info');
			}else if (parseInt(flg) == "-6") {
				$.messager.alert("错误提示", "同步国家表单失败!" , 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#winAddPathMast').close();
			obj.ClearpathWeb();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.pathWebList.reload();//刷新当前页
			$('#txtKbTmp').val("");
		}
	}
	
	//路径信息
	obj.pathWebList_onSelect = function (){
		$("#workS").hide();
		$("#workD").show();
		var rowData = obj.pathWebList.getSelected();
		$("#btnEditMast").linkbutton("enable");
		$('#WCPWCode').text(rowData.BTCode);
		$('#WCPWDesc').text(rowData.BTDesc);
		$('#WCPWType').text(rowData.BTTypeDesc);
		$('#WCPWType').text(rowData.BTTypeDesc);
		$('#WCPWEntity').text(rowData.BTEntityDesc);
		$('#WCPWComEntity').text(rowData.IsComplDesc);
		if (rowData.BTAdmType){
			$('#WCPWAdmType').text((rowData.BTAdmType=="I")?"住院":"门诊");
		}else{
			$('#WCPWAdmType').text("");
		}
		$('#WCPWOper').text(rowData.IsOperDesc);
		$('#WCPWUser').text(rowData.BTCreUserDesc);
		$('#WCPWLoc').text(rowData.BTCreLocDesc);
		$('#WCPWDTime').text(rowData.CreDate+" "+rowData.CreTime);
		obj.PathFormID=rowData.BTFormID
		obj.PathWebID=rowData.BTID
		obj.InitPathInfo();
	}
	//新增阶段
	obj.AddStep = function(){
		obj.FormEpID=""
		$('#btnSaveStep').linkbutton({text:'保存'});
		$('#txtStepDesc').val('');
		$('#txtStepOthDesc').val('');
		$('#txtStepDays').val('');
		$('#StepIsKey').checkbox('setValue',false);
		$('#StepIsOperDay').checkbox('setValue',false);
		$HUI.dialog('#winStep').open();
	}
	//保存阶段
	obj.btnSaveStep_click= function(){
		var errinfo = "";
		var StepDesc = $('#txtStepDesc').val();
		var StepOthDesc = $('#txtStepOthDesc').val();
		var StepDays = $('#txtStepDays').val();
		var StepIsKey = $("#StepIsKey").checkbox('getValue')? '1':'0';
		var StepIsOperDay = $("#StepIsOperDay").checkbox('getValue')? '1':'0';
		if (!StepDesc) {
			errinfo = errinfo + "描述为空!<br>";
		}
		if (!StepOthDesc) {
			errinfo = errinfo + "别名为空!<br>";
		}
		if (!StepDays) {
			errinfo = errinfo + "天数为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var inputStr = obj.PathFormID;
		inputStr = inputStr + "^" + obj.FormEpID;
		inputStr = inputStr + "^" + StepDesc;
		inputStr = inputStr + "^" + StepOthDesc;
		inputStr = inputStr + "^" + StepDays;
		inputStr = inputStr + "^" + StepIsKey;
		inputStr = inputStr + "^" + StepIsOperDay;
		inputStr = inputStr + "^" + session['DHCMA.USERID'];
		var flag = $m({
			ClassName:"DHCMA.CPW.BTS.PathWebCreateSrv",
			MethodName:"UpdateFromEp",
			"aInputStr":inputStr,
			"aSeparete":"^"
		},false);
		if (parseInt(flag) > 0) {
			$HUI.dialog('#winStep').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.ClearStepm();
			obj.InitPathInfo()
		}else{
			$.messager.alert("错误提示", "保存数据错误!Error=" + flag, 'info');
			return
		}
	}
	//右移
	obj.RightMove = function(EpID){
		var flag = $m({
			ClassName:"DHCMA.CPW.BTS.PathWebCreateSrv",
			MethodName:"RightMove",
			"aEpID":EpID
		},false);
		if (parseInt(flag) > 0) {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.InitPathInfo()
		}else if(parseInt(flag) == -777) {
			$.messager.alert("错误提示", "该阶段已是末尾阶段", 'info');
			return
		}else{
			$.messager.alert("错误提示", "保存数据错误!Error=" + flag, 'info');
			return
		}
	}
	//左移
	obj.LeftMove = function(EpID){
		var flag = $m({
			ClassName:"DHCMA.CPW.BTS.PathWebCreateSrv",
			MethodName:"LeftMove",
			"aEpID":EpID
		},false);
		if (parseInt(flag) > 0) {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.InitPathInfo()
		}else if(parseInt(flag) == -777) {
			$.messager.alert("错误提示", "该阶段已是开始阶段", 'info');
			return
		}else{
			$.messager.alert("错误提示", "保存数据错误!Error=" + flag, 'info');
			return
		}
	}
	//修改阶段信息
	obj.EditStep = function(EpID){
		$('#btnSaveStep').linkbutton({text:'保存'});
		$cm({
			ClassName:"DHCMA.CPW.BT.PathFormEp",
			MethodName:"GetObjById",
			aId:EpID
		},function(rs){
			if (rs){
				obj.FormEpID=rs["ID"]
				var Desc = rs["EpDesc"];
				var Desc2 = rs["EpDesc2"];
				var Days = rs["EpDays"];
				var IsKeyStep = rs["EpIsKeyStep"];
				IsKeyStep = (IsKeyStep=="1"? true: false);
				var IsOperDay = rs["EpIsOperDay"];
				IsOperDay = (IsOperDay=="1"? true: false);
				$('#txtStepDesc').val(Desc);
				$('#txtStepOthDesc').val(Desc2);
				$('#txtStepDays').val(Days);
				$('#StepIsKey').checkbox('setValue',IsKeyStep);
				$('#StepIsOperDay').checkbox('setValue',IsOperDay);
			}
			$HUI.dialog('#winStep').open();
		})
	}
	obj.CopyStep = function(EpID){
		obj.FormEpID=EpID
		$('#btnSaveStep').linkbutton({text:'保存新阶段'});
		$HUI.dialog('#winStep').open();
	}
	//复制阶段
	obj.btnCopyStep_click= function(){
		var errinfo = "";
		var StepDesc = $('#txtStepDesc').val();
		var StepOthDesc = $('#txtStepOthDesc').val();
		var StepDays = $('#txtStepDays').val();
		var StepIsKey = $("#StepIsKey").checkbox('getValue')? '1':'0';
		var StepIsOperDay = $("#StepIsOperDay").checkbox('getValue')? '1':'0';
		if (!StepDesc) {
			errinfo = errinfo + "描述为空!<br>";
		}
		if (!StepOthDesc) {
			errinfo = errinfo + "别名为空!<br>";
		}
		if (!StepDays) {
			errinfo = errinfo + "天数为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var inputStr = obj.PathFormID;
		inputStr = inputStr + "^" + "";
		inputStr = inputStr + "^" + StepDesc;
		inputStr = inputStr + "^" + StepOthDesc;
		inputStr = inputStr + "^" + StepDays;
		inputStr = inputStr + "^" + StepIsKey;
		inputStr = inputStr + "^" + StepIsOperDay;
		inputStr = inputStr + "^" + session['DHCMA.USERID'];
		inputStr = inputStr + "^" + obj.FormEpID;
		var flag = $m({
			ClassName:"DHCMA.CPW.BTS.PathWebCreateSrv",
			MethodName:"CopyFormStepAsNew",
			"aInputStr":inputStr,
			"aSeparete":"^"
		},false);
		if (parseInt(flag) > 0) {
			$HUI.dialog('#winStep').close();
			obj.ClearStepm();
			$.messager.popover({msg: '复制成功！',type:'success',timeout: 1000});
			obj.InitPathInfo();
		}else{
			$.messager.alert("错误提示", "复制数据错误!Error=" + flag, 'info');
			return
		}
	}
	//删除阶段
	obj.DelStep = function(EpID){
		$.messager.confirm("删除", "删除操作不可恢复，确定删除选中记录?", function (r) {
			if(r){
				flg = $m({
					ClassName:"DHCMA.CPW.BT.PathFormEp",
					MethodName:"DeleteById",
					aId:EpID
				},false);
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					return false;
				}else{
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.InitPathInfo() ;//刷新当前页	
				}
			}
		})
	}
	
	//保存项目
	obj.btnSaveEp_click= function(){
		var Editrows=$('#EpItemGrid').datagrid('getSelections')
		for (var i=0;i<Editrows.length;i++) {
			var rowIndex=$('#EpItemGrid').datagrid('getRowIndex',Editrows[i])
			$('#EpItemGrid').datagrid('endEdit',rowIndex)
		}
		var FormEp = $('#cboFromEp').combobox('getValues');
		if (Editrows.length==0){
			$.messager.popover({msg: '没有需要保存的内容！',type:'success',timeout: 1000});	
			obj.EpItemGrid.reload()
			return;
		}
		var Err="";
		for (var i=0;i<Editrows.length;i++) {
			var rec=Editrows[i]
			if(!rec.BTEpItemDesc){
				continue	
			}
			var InputStr=FormEp
			InputStr+="^"+rec.RowID
			InputStr+="^"+rec.BTEpItemDesc
			InputStr+="^"+obj.ItemCat
			InputStr+="^"+rec.BTEpTips
			InputStr+="^"+rec.BTItemIsOption
			InputStr+="^"+ session['DHCMA.USERID'];
			var flg = $m({
					ClassName:"DHCMA.CPW.BTS.PathWebCreateSrv",
					MethodName:"UpdateFromEpItem",
					aInputStr:InputStr
				},false);
			 if(flg<=0) {
				Err=Err+"数据保存错误.<br>";
			}
		}
		if (Err!="") {				
			$.messager.alert("错误提示", Err, 'info');
			return
		}else if(flg>0){
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000})	
		}	
		obj.EpItemGrid.reload()
	}
	//保存医嘱项目
	obj.btnSaveEpYZ_click= function(){
		var Editrows=$('#YZEpItemGrid').datagrid('getSelections')
		for (var i=0;i<Editrows.length;i++) {
			var rowIndex=$('#YZEpItemGrid').datagrid('getRowIndex',Editrows[i])
			$('#YZEpItemGrid').datagrid('endEdit',rowIndex)
		}
		var FormEp = $('#cboFromYZEp').combobox('getValues');
		if (Editrows.length==0){
			$.messager.popover({msg: '没有需要保存的内容！',type:'success',timeout: 1000});	
			obj.YZEpItemGrid.reload()
			return;
		}
		var Err="";
		for (var i=0;i<Editrows.length;i++) {
			var rec=Editrows[i]
			if(!rec.BTEpItemDesc){
				continue	
			}
			var InputStr=FormEp
			InputStr+="^"+rec.RowID
			InputStr+="^"+rec.BTEpItemDesc
			InputStr+="^"+rec.BTItemCat
			InputStr+="^"+rec.BTEpTips
			InputStr+="^"+rec.BTItemIsOption
			InputStr+="^"+ session['DHCMA.USERID'];
			console.log(InputStr)
			var flg = $m({
					ClassName:"DHCMA.CPW.BTS.PathWebCreateSrv",
					MethodName:"UpdateFromEpItem",
					aInputStr:InputStr
				},false);
			if (flg<=0) {
				Err=Err+"数据保存错误.<br>";
			}
		}
		if (Err!="") {				
			$.messager.alert("错误提示", Err, 'info');
			return;
		}else if(flg>0){
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000})	
		}	
		obj.YZEpItemGrid.reload();
	}
	
	//项目上移
	obj.TopMove = function(EpID,ItemCat){
		if (ItemCat=="A"){
			var Item="ZL"+EpID
		}else if(ItemCat=="C"){
			var Item="HL"+EpID
		}else{
			var Item="YZ"+EpID
		}
		obj.FormEpItemID=$("input[name='"+Item+"']:checked").val()
		if (!obj.FormEpItemID){
			$.messager.alert("错误提示", "请先选择项目", 'info');
			return
		}
		if ($("input[name='"+Item+"']:checked"))
		var flag = $m({
			ClassName:"DHCMA.CPW.BTS.PathWebCreateSrv",
			MethodName:"TopMove",
			"aEpItemID":obj.FormEpItemID
		},false);
		if (parseInt(flag) > 0) {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.InitPathInfo()
		}else if(parseInt(flag) == -777) {
			$.messager.alert("错误提示", "该阶段已是第一位", 'info');
			return
		}else{
			$.messager.alert("错误提示", "保存数据错误!Error=" + flag, 'info');
			return
		}
	}
	//项目下移
	obj.UnderMove = function(EpID,ItemCat){
		if (ItemCat=="A"){
			var Item="ZL"+EpID
		}else if(ItemCat=="C"){
			var Item="HL"+EpID
		}else{
			var Item="YZ"+EpID
		}
		obj.FormEpItemID=$("input[name='"+Item+"']:checked").val()
		if (!obj.FormEpItemID){
			$.messager.alert("错误提示", "请先选择项目", 'info');
			return
		}
		var flag = $m({
			ClassName:"DHCMA.CPW.BTS.PathWebCreateSrv",
			MethodName:"UnderMove",
			"aEpItemID":obj.FormEpItemID
		},false);
		if (parseInt(flag) > 0) {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.InitPathInfo();
		}else if(parseInt(flag) == -777) {
			$.messager.alert("错误提示", "该阶段已是最后位", 'info');
			return
		}else{
			$.messager.alert("错误提示", "保存数据错误!Error=" + flag, 'info');
			return
		}
	}
	obj.DelteEpItem = function(EpID,ItemCat){
		if (obj.ItemCat=="A"){
				var Item="ZL"+EpID
			}else if(ItemCat=="C"){
				var Item="HL"+EpID
			}else{
				var Item="YZ"+EpID
			}
		obj.FormEpItemID=$("input[name='"+Item+"']:checked").val()
		if (!obj.FormEpItemID){
			$.messager.alert("错误提示", "请先选择删除项目", 'info');
			return
		}
		$.messager.confirm("删除", "删除操作不可恢复，确定删除选中记录?", function (r) {
			if(r){
				flg = $m({
					ClassName:"DHCMA.CPW.BT.PathFormItem",
					MethodName:"DeleteById",
					aId:obj.FormEpItemID
				},false);
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					return false;
				}else{
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.InitPathInfo() ;//刷新当前页	
				}
			}
		})
	}
	obj.DelEpItem = function(){
		if (obj.ItemCat=="B"){
			var Editrows=$('#YZEpItemGrid').datagrid('getSelections');
		}else{
			var Editrows=$('#EpItemGrid').datagrid('getSelections');
		}
		$.messager.confirm("删除", "删除操作不可恢复，确定删除选中记录?", function (r) {
			for (var i=0;i<Editrows.length;i++) {
				var row=Editrows[i];
				if (row.RowID) {
					if (r) {			
						var flg = $m({
							ClassName:"DHCMA.CPW.BT.PathFormItem",
							MethodName:"DeleteById",
							aId:row.RowID
						},false)
						if (parseInt(flg) < 0) {
							$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
							return false;
						}else{
							$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
							if (obj.ItemCat=="B"){
								obj.YZEpItemGrid.reload();
							}else{
								obj.EpItemGrid.reload();
							}
						} 
					}
				}
			}
		})
	}
	//展示维护数据
	obj.ShowEpItem = function(EpID,ItemCat){
		obj.FormEpID=EpID
		//obj.FormEpItemID=""
		obj.ItemCat=ItemCat
		if (ItemCat=="B"){
			obj.ShowFromYZEp(obj.PathFormID);
			//url=$URL+"?ClassName=DHCMA.CPW.KBS.OrdItemBaseSrv&QueryName=QryOIBase&ResultSetType=array";
			$('#cboFromYZEp').combobox('setValue',obj.FormEpID);
			obj.YZEpItemGrid = $HUI.datagrid("#YZEpItemGrid",{
				fit:true,
				singleSelect: false,
				autoRowHeight: false,
				striped:true,
				rownumbers:true, 
				loadMsg:'数据加载中...',
			    url:$URL,
			    nowrap:false,
			    queryParams:{
			    	ClassName:"DHCMA.CPW.BTS.PathWebCreateSrv",
					QueryName:"QryPathItem",
					aID:EpID,
					aItemCat:ItemCat
		    	},
				columns:[[
					//{field:'checked',checkbox:'true',align:'left',width:30,auto:false},
					{field:'BTItemCat',title:'医嘱类型',width:'100',
						formatter:function(v,r){
							if (v=="B01"){
								return "长期医嘱"
							}else{
								return "临时医嘱"
							}					
						},
						editor:{
			                type:'combobox',
							options:{
								valueField:'id',
								textField:'text',
								selectOnNavigation:true,
								panelHeight:"auto",
								editable:false,
								data:[
									{id:'B01',text:'长期医嘱'},
									{id:'B02',text:'临时医嘱'}
								]
							}
					}
					},
					{field:'BTEpItemDesc',title:'项目信息',width:'380',
						editor:{
								type:'text'
						}
					},
					{field:'BTEpTips',title:'执行提示',width:'200',
						editor:{
								type:'text'
						}
					},
					{field:'BTItemIsOption',title:'是否必选',width:'80',
						formatter:function(v,r){
							if (v==0){
								return "否"
							}else{
								return "是"
							}					
						},
						editor:{
			                type:'combobox',
							options:{
								valueField:'id',
								textField:'text',
								selectOnNavigation:true,
								panelHeight:"auto",
								editable:false,
								data:[
									{id:'1',text:'是'},
									{id:'0',text:'否'}
								]
							}
					}
					}
				]]
				,onClickRow:function(index,rowData){
					if((index!=editIndex)&&(editIndex!="null")){
						$('#YZEpItemGrid').datagrid('endEdit',editIndex);
						var row = $('#YZEpItemGrid').datagrid('getRows')[editIndex]
						$('#YZEpItemGrid').datagrid('refreshRow',editIndex);
					}
					$('#YZEpItemGrid').datagrid('selectRow', index).datagrid('beginEdit', index);
					$("#btnSaveYZEp").linkbutton('enable');
					$("#btnDeleteYZEp").linkbutton('enable');
					$('#cboYZEpItem').combobox('enable');
					editIndex=index;
				},
				onLoadSuccess:function(data){
					$("#btnSaveYZEp").linkbutton('disable');
					$("#btnDeleteYZEp").linkbutton('disable');
					$('#cboYZEpItem').combobox('clear');
					$('#cboYZEpItem').combobox('disable');
					editIndex="null"
					if (typeof HISUIStyleCode !== 'undefined'){
						if (HISUIStyleCode=="lite"){
							$(".datagrid-wrap").attr("style","border-color:#E2E2E2")
						}
					}
				}
			});
			$HUI.dialog('#winEpYZItem').open();
		}else{
			obj.EpItem(ItemCat)
			obj.ShowFromEp(obj.PathFormID);
			$('#cboFromEp').combobox('setValue',obj.FormEpID);
			obj.EpItemGrid = $HUI.datagrid("#EpItemGrid",{
				fit:true,
				singleSelect: false,
				autoRowHeight: false,
				striped:true,
				rownumbers:true, 
				loadMsg:'数据加载中...',
			    url:$URL,
			    nowrap:false,
			    queryParams:{
			    	ClassName:"DHCMA.CPW.BTS.PathWebCreateSrv",
					QueryName:"QryPathItem",
					aID:EpID,
					aItemCat:ItemCat
		    	},
				columns:[[
					//{field:'checked',checkbox:'true',align:'left',width:30,auto:false},
					{field:'BTEpItemDesc',title:'项目信息',width:'360',
						editor:{
								type:'text'
						}
					},
					{field:'BTEpTips',title:'执行提示',width:'250',
						editor:{
								type:'text'
						}
					},
					{field:'BTItemIsOption',title:'是否必选',width:'80',
						formatter:function(v,r){
							if (v==0){
								return "否"
							}else{
								return "是"
							}					
						},
						editor:{
			                type:'combobox',
							options:{
								valueField:'id',
								textField:'text',
								selectOnNavigation:true,
								panelHeight:"auto",
								editable:false,
								data:[
									{id:'1',text:'是'},
									{id:'0',text:'否'}
								]
							}
					}
					}
				]]
				,onClickRow:function(index,rowData){
					if((index!=editIndex)&&(editIndex!="null")){
						$('#EpItemGrid').datagrid('endEdit',editIndex)
						var row = $('#EpItemGrid').datagrid('getRows')[editIndex]
						$('#EpItemGrid').datagrid('refreshRow',editIndex);
					}
					$('#EpItemGrid').datagrid('selectRow', index).datagrid('beginEdit', index);
					$("#btnSaveEp").linkbutton('enable');
					$("#btnDeleteEp").linkbutton('enable');
					editIndex=index;
					$('#cboEpItem').combobox('enable');
				},
				onLoadSuccess:function(data){
					$("#btnSaveEp").linkbutton('disable');
					$("#btnDeleteEp").linkbutton('disable');
					$('#cboEpItem').combobox('clear');
					$('#cboEpItem').combobox('disable');
					editIndex="null"
					if (typeof HISUIStyleCode !== 'undefined'){
						if (HISUIStyleCode=="lite"){
							$(".datagrid-wrap").attr("style","border-color:#E2E2E2")
						}
					}
				}
			});
			$HUI.dialog('#winEpItem').open();
		}
	}
	obj.addNewEpItem=function(){
		$('#EpItemGrid').datagrid('appendRow',{RowID:'',KBEpItem:'',BTEpItemDesc:'',BTEpTips:'',BTItemIsOption:'1'});
		$('#EpItemGrid').datagrid('endEdit',editIndex)
		editIndex = $('#EpItemGrid').datagrid('getRows').length - 1;
    	$('#EpItemGrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
    	$("#btnSaveEp").linkbutton('enable');
		$("#btnDeleteEp").linkbutton('enable');
		$('#cboEpItem').combobox('enable');
	}
	obj.addNewYZEpItem=function(){
		$('#YZEpItemGrid').datagrid('appendRow',{RowID:'',BTItemCat:'B01',KBEpItem:'',BTEpItemDesc:'',BTEpTips:'',BTItemIsOption:'1'});
		$('#YZEpItemGrid').datagrid('endEdit',editIndex)
		editIndex = $('#YZEpItemGrid').datagrid('getRows').length - 1;
    	$('#YZEpItemGrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
    	$("#btnSaveYZEp").linkbutton('enable');
		$("#btnDeleteYZEp").linkbutton('enable');
		$('#cboYZEpItem').combobox('enable');
	}
	
	
	obj.ClearpathWeb= function(){
		$('#cboKbTmp').lookup('setText',''); 
		$('#txtCode').val('');
		$('#txtDesc').val('');
		$('#cboType').combobox('setValue',''); 
		$('#cboEntity').combobox('setValue',''); 
		$('#txtEntityCode').val('');
		$('#txtEntityDesc').val('');
		$('#cboEntityType').combobox('setValue',''); 
		//$('#cboComEntity').combobox('setValue',''); 
		//$('#txtComEntityCode').val('');
		//$('#txtComEntityDesc').val('');
		$('#cboIOType').combobox('setValue',''); 
		$('#IsOper').checkbox('setValue',false); 
		$('#IsActive').checkbox('setValue',true); 
	}
	obj.ClearStepm = function(){
		$('#txtStepDesc').val('');
		$('#txtStepOthDesc').val('');
		$('#txtStepDays').val('');
		$('#StepIsKey').checkbox('setValue',false);  
		$('#StepIsOperDay').checkbox('setValue',false);
	}
}


