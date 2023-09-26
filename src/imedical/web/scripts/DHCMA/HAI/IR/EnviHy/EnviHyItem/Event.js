//页面Event
function InitEnviHyItemWinEvent(obj){
	
	$('#winEvItem').dialog({
		title: '环境卫生监测项目维护',
		iconCls:"icon-w-paper",
		headerCls:'panel-header-gray',
		closed: true,
		modal: true,
		isTopZindex:true	
	});	
	obj.LoadEvent = function(args){
		//保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
     	//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#winEvItem').close();
     	});
     	//添加
     	$('#btnAdd').on('click', function(){
			obj.layer1();
     	});
     	//编辑
		$('#btnEdit').on('click', function(){
	     	var rd=obj.gridEvItem.getSelected()
			obj.layer1(rd);	
     	});
     	//删除
		$('#btnDelete').on('click', function(){
	     	obj.btnDelete_click();
     	});
	}
	//选择监测项目
	obj.gridEvItem_onSelect = function(){
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID1="";
		var rowData = obj.gridEvItem.getSelected();
		if (rowData["ID"] == obj.RecRowID1) {
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$("#btnSubAdd").linkbutton("disable");
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
			obj.RecRowID1="";
			obj.gridEvItem.clearSelections();  //清除选中行
		} else {
			obj.RecRowID1 = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
			obj.EvItemObjLoad();  //加载对象	
		}
	}	
	
	//双击编辑事件 父表
	obj.gridEvItem_onDbselect = function(rd){
		obj.layer1(rd);	
	}
	
	//保存父表
	obj.btnSave_click = function(){
		var errinfo = "";
		var ItemDesc = $('#txtItemDesc').val();
		var SpecimenTypeDesc = $('#cboSpecimenType').combobox('getText');
		var Norm = $('#txtNorm').val();
		var NormMax = $('#txtNormMax').val();
		var NormMin = $('#txtNormMin').val();
		var SpecimenNum = $('#txtSpecimenNum').val();
		var CenterNum = $('#txtCenterNum').val();
		var SurroundNum = $('#txtSurroundNum').val();
		var ForMula = $('#txtForMula').val();
		var Freq = $('#txtFreq').val();
		var Uom = $('#txtUom').val();
		var IsActive = $('#chkActive').checkbox('getValue');
		IsActive = (IsActive==true? 1: 0);
		var ItemTypeDesc = $('#cboItemType').combobox('getText');
		var EnvironmentCateDesc = $('#cboEnvironmentCate').combobox('getText');
		//新增字段
		var IsObjNull = $('#txtEHIsObjNull').checkbox('getValue');
		IsObjNull = (IsObjNull==true? 1: 0);
		var IsSpecNum = $('#txtEHIsSpecNum').checkbox('getValue');
		IsSpecNum = (IsSpecNum==true? 1: 0);
		var EHEnterTypeDesc = $('#txtEHEnterTypeDr').combobox('getText');
		var ReferToNum=$('#txtReferToNum').val();
		var HospID=$('#cboHospital').combobox('getValue');
		
		if (!ItemTypeDesc) {
			errinfo = errinfo + "项目分类不允许为空!<br>";
		}
		if (!ItemDesc) {
			errinfo = errinfo + "项目名称不允许为空!<br>";
		}
		if (!SpecimenTypeDesc) {
			errinfo = errinfo + "标本类型不允许为空!<br>";
		}
		if (!Norm) {
			errinfo = errinfo + "检测标准不允许为空!<br>";
		}
		if (!NormMax) {
			errinfo = errinfo + "菌落数正常上限不允许为空!<br>";
		}
		if (!NormMin) {
			errinfo = errinfo + "菌落数正常下限不允许为空!<br>";
		}
		if (!SpecimenNum) {
			errinfo = errinfo + "标本个数不允许为空!<br>";
		}
		if (!CenterNum) {
			errinfo = errinfo + "中心个数不允许为空!<br>";
		}
		if (!SurroundNum) {
			errinfo = errinfo + "周边个数不允许为空!<br>";
		}
		if (parseInt(CenterNum)>parseInt(SpecimenNum)) {
			errinfo = errinfo + "中心个数不允许大于标本个数!<br>";
		}
		if (parseInt(SurroundNum)>parseInt(SpecimenNum)) {
			errinfo = errinfo + "周边个数不允许大于标本个数!<br>";
		}
		if (parseInt(ReferToNum)>parseInt(SpecimenNum)) {
			errinfo = errinfo + "参照点个数不允许大于标本个数!<br>";
		}
		if ((parseInt(ReferToNum)+parseInt(CenterNum)+parseInt(SurroundNum))>parseInt(SpecimenNum)) {
			errinfo = errinfo + "参照点个数、中心个数、周边个数总数不允许大于标本个数!<br>";
		}
		if (!ReferToNum) {
			errinfo = errinfo + "参照点个数不允许为空!<br>";
		}
		if (!EHEnterTypeDesc) {
			errinfo = errinfo + "录入方式不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID1;
		inputStr = inputStr + CHR_1 + ItemDesc;
		inputStr = inputStr + CHR_1 + SpecimenTypeDesc;
		inputStr = inputStr + CHR_1 + Norm;
		inputStr = inputStr + CHR_1 + NormMax;
		inputStr = inputStr + CHR_1 + NormMin;
		inputStr = inputStr + CHR_1 + SpecimenNum;
		inputStr = inputStr + CHR_1 + CenterNum;
		inputStr = inputStr + CHR_1 + SurroundNum;
		inputStr = inputStr + CHR_1 + ForMula;
		inputStr = inputStr + CHR_1 + Freq;
		inputStr = inputStr + CHR_1 + Uom;
		inputStr = inputStr + CHR_1 + IsActive;
		inputStr = inputStr + CHR_1 + ItemTypeDesc;
		inputStr = inputStr + CHR_1 + EnvironmentCateDesc;
		inputStr = inputStr + CHR_1 + ReferToNum;
		inputStr = inputStr + CHR_1 + IsObjNull;
		inputStr = inputStr + CHR_1 + IsSpecNum;
		inputStr = inputStr + CHR_1 + EHEnterTypeDesc;
		inputStr = inputStr + CHR_1 + HospID;
		inputStr = inputStr + CHR_1 + $.LOGON.USERID;
		var flg = $m({
			ClassName:"DHCHAI.IR.EnviHyItem",
			MethodName:"Update",
			InStr:inputStr,
			aSeparete:CHR_1
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID1='';
			obj.gridEvItem.reload() ;//刷新当前页
			obj.EvItemObjLoad();//刷新对象
			$HUI.dialog('#winEvItem').close();
		}
	}
	
	//删除父表
	obj.btnDelete_click = function(){
		var rowData = obj.gridEvItem.getSelected();
		var rowID=rowData["ID"]
		if (rowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.EnviHyItem",
					MethodName:"DeleteById",
					Id:rowID
				},false);
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');	
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID1="";
					obj.EvItemObjLoad();//刷新对象
					obj.gridEvItem.reload() ;//刷新当前页	
				}
			} 
		});
	}

	//加载对象
	obj.EvItemObjLoad = function(){
		var ShowAll=$('#showAll').checkbox('getValue') ? 1:0;
		var ParRef = "";
		if (obj.RecRowID1) {
			ParRef =obj.RecRowID1;
		}
		obj.gridEvItemObj.load({
			ClassName:"DHCHAI.IRS.EnviHyItemSrv",
			QueryName:"QryEvObjsByItem",
			aParRef:ParRef,
			aShowAll:ShowAll
		});	
	}
	
	//配置窗体-初始化（父表）
	obj.layer1= function(rd){
		if(rd){
			obj.RecRowID1=rd["ID"];
			var ItemTypeID = rd["ItemTypeID"];
			var ItemTypeDesc = rd["ItemTypeDesc"];
			var ItemDesc = rd["ItemDesc"];
			var SpecimenTypeID = rd["SpecimenTypeID"];
			var SpecimenTypeDesc = rd["SpecimenTypeDesc"];			
			var Norm = rd["Norm"];
			var NormMax = rd["NormMax"];
			var NormMin = rd["NormMin"];
			var SpecimenNum = rd["SpecimenNum"];
			var CenterNum = rd["CenterNum"];
			var SurroundNum = rd["SurroundNum"];
			var ForMula = rd["ForMula"];
			var Freq = rd["Freq"];
			var Uom = rd["Uom"];
			var EnvironmentCateID = rd["EnvironmentCateID"];
			var EnvironmentCateDesc = rd["EnvironmentCateDesc"];
			var IsActDesc = rd["IsActDesc"];
			IsActDesc = (IsActDesc=="是"? true: false);
			var IsObjNullDesc = rd["IsObjNullDesc"];
			IsObjNullDesc = (IsObjNullDesc=="是"? true: false);
			var IsSpecNumDesc = rd["IsSpecNumDesc"];
			IsSpecNumDesc = (IsSpecNumDesc=="是"? true: false);
			var EHEnterTypeID = rd["EHEnterTypeID"];
			var EHEnterTypeDesc = rd["EHEnterTypeDesc"];
			var ReferToNum = rd["ReferToNum"];
			var HospID = rd["HospID"];
			$('#cboItemType').combobox('setValue',ItemTypeID);
			$('#cboItemType').combobox('setText',ItemTypeDesc);
			$('#txtItemDesc').val(ItemDesc);
			$('#cboSpecimenType').combobox('setValue',SpecimenTypeID);
			$('#cboSpecimenType').combobox('setText',SpecimenTypeDesc);
			$('#txtNorm').val(Norm);
			$('#txtNormMax').val(NormMax);
			$('#txtNormMin').val(NormMin);
			$('#txtSpecimenNum').val(SpecimenNum);
			$('#txtCenterNum').val(CenterNum);
			$('#txtSurroundNum').val(SurroundNum);
			$('#txtForMula').val(ForMula);
			$('#txtFreq').val(Freq);
			$('#txtUom').val(Uom);
			$('#cboEnvironmentCate').combobox('setValue',EnvironmentCateID);
			$('#cboEnvironmentCate').combobox('setText',EnvironmentCateDesc);
		    $('#txtEHIsObjNull').checkbox('setValue',IsObjNullDesc);
			$('#txtEHIsSpecNum').checkbox('setValue',IsSpecNumDesc);
			$('#txtEHEnterTypeDr').combobox('setValue',EHEnterTypeID);
			$('#txtEHEnterTypeDr').combobox('setText',EHEnterTypeDesc);
			$('#txtReferToNum').val(ReferToNum);
			Common_SetValue('cboHospital',HospID);
		}else{
			obj.RecRowID1="";
			
			$('#cboItemType').combobox('clear');
			$('#txtItemDesc').val('');
			$('#cboSpecimenType').combobox('clear');
			$('#txtNorm').val('');
			$('#txtNormMax').val('');
			$('#txtNormMin').val('');
			$('#txtSpecimenNum').val('');
			$('#txtCenterNum').val('');
			$('#txtSurroundNum').val('');
			$('#txtForMula').val('');
			$('#txtFreq').val('');
			$('#txtUom').val('');
			$('#cboEnvironmentCate').combobox('setValue','');
			$('#txtEHIsObjNull').checkbox('setValue',false);
			$('#txtEHIsSpecNum').checkbox('setValue',false);
			$('#txtEHEnterTypeDr').combobox('clear');
			$('#txtReferToNum').val('');
			$('#cboHospital').combobox('clear');
		}
		$HUI.dialog('#winEvItem').open();
	}
	
	obj.showAllClick=function(){
		obj.EvItemObjLoad();
	}
}
