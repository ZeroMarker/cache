//页面Event
function InitviewScreenEvent(obj) {
	obj.LoadEvent = function(args){ 
		//保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		
		//添加按钮
		$('#btnAdd').on('click', function(){
	     	obj.btnAdd_click();
     	});
		//添加ICD按钮
		$('#btnAdd_two').on('click', function(){
	     	obj.btnAdd_two_click();
     	});
		//删除按钮
		$('#btnDel').on('click', function(){
	     	obj.btnDel_click();
     	});
		//删除ICD按钮
		$('#btnDel_two').on('click', function(){
	     	obj.btnDel_two_click();
     	});
		//状态选择事件
		$HUI.combobox("#cboProduct", {
			onSelect:function(){
				obj.QueryLoad();
			}
		});
    }

	obj.openHandler_two = function(RowId){
		obj.RecRowID=RowId;
		$('#ICDLog').dialog("open");
		obj.gridICDLoad(RowId);
	}
	
	obj.gridICDLoad = function(RowId){	
		$cm ({
			ClassName:"DHCMed.SSService.DiseaseSrv",
			QueryName:"QryDiseaseICD",		
			aDiseaseID:RowId
		},function(rs){
			obj.RecRowID=RowId;
			$('#gridICD').datagrid('loadData', rs);				
		});
    }

	//ICD弹出框中删除按钮
	obj.btnDel_two_click = function(){
		var RowData2 = $("#gridICD").datagrid('getSelected');
		if(!RowData2){
			$.messager.alert("提示","请选择一行进行再删除!","info");
			return;
		}
		if(!RowData2.ID){
			$.messager.alert("提示","当前行尚未保存无需删除!","info");
			return;
		}	
		$.messager.confirm('选择框','确定删除此记录?',function(r){
			if (r){
				var flg = $cm({
					ClassName:"DHCMed.SS.DiseaseICD",
					MethodName:"DeleteById",
					aId:RowData2.ID
				},false);
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示", "删除数据错误!Error=" + flg,"info");
					return;
				}else {
					$.messager.alert("提示","删除成功!", 'info');
					obj.gridICDLoad(obj.RecRowID);//刷新当前页
				}
			}
		});	
	};
	//别名弹出框中删除按钮
	obj.btnDel_click = function(){
		var RowData1 = $("#gridAlias").datagrid('getSelected');
		if(!RowData1){
			$.messager.alert("提示","请选择一行进行再删除!","info");
			return;
		}
		if(!RowData1.ID){
			$.messager.alert("提示","当前行尚未保存无需删除!","info");
			return;
		}	

		$.messager.confirm('选择框','确定删除此记录?',function(r){
			if (r) {
				var flg = $cm({
					ClassName:"DHCMed.SS.DiseaseAlias",
					MethodName:"DeleteById",
					aId:RowData1.ID
				},false);
				if (parseInt(flg) < 0) {
					if (parseInt(flg) == -100) {
						$.messager.alert("错误提示", "数据重复!Error=" + flg, 'info');
					} else {
						$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
					}
					return;
				}else {
					$.messager.alert("提示","删除成功!","info");
					obj.gridAliasLoad(obj.RecRowID);//刷新当前页
				}
			}
		});	
	};
	//别名弹出框添加方法
	obj.btnAdd_click = function(){		
		if (endEditing()){
			$('#gridAlias').datagrid('appendRow',{
				index: 1,   // 索引从0开始
			});
			obj.editIndex = $('#gridAlias').datagrid('getRows').length-1;
			$('#gridAlias').datagrid('selectRow', obj.editIndex).datagrid('beginEdit', obj.editIndex);
		}
		
	}
	//ICD弹出框添加方法
	obj.btnAdd_two_click = function(){		
		if (endEditing_two()){
			$('#gridICD').datagrid('appendRow',{
				index: 1,   // 索引从0开始
			});
			obj.editIndex = $('#gridICD').datagrid('getRows').length-1;
			$('#gridICD').datagrid('selectRow', obj.editIndex).datagrid('beginEdit', obj.editIndex);
		}
		
	}
	//前台保存数据
	$.extend($.fn.datagrid.methods, {
		editCell: function(jq,param){
			return jq.each(function(){
				var opts = $(this).datagrid('options');
				var fields = $(this).datagrid('getColumnFields',true).concat($(this).datagrid('getColumnFields'));
				for(var i=0; i<fields.length; i++){
					var col = $(this).datagrid('getColumnOption', fields[i]);
					col.editor1 = col.editor;
					if (fields[i] != param.field){
						col.editor = null;
					}
				}
				$(this).datagrid('beginEdit', param.index);
				for(var i=0; i<fields.length; i++){
					var col = $(this).datagrid('getColumnOption', fields[i]);
					col.editor = col.editor1;
				}
			});
		}
	});
	//ICD弹出框保存方法 
	obj.saveToSrv_two = function(){
		if (endEditing_two()){
			$('#gridICD').datagrid('acceptChanges');      //保存之前结束编辑操作
		}
		var rows = $('#gridICD').datagrid('getRows');
		for(var i = 0; i < rows.length; i ++)
		{
			var RowData = rows[i];
			var aAlias = "";
			var RowID = RowData.ID;
			var RowIndex2 = "";
			if(RowID!=null){                                //保存旧行
				RowIndex2 = RowID.split("||")[1];
				aICD = RowData.IDICD10;
				aDesc = RowData.IDICDDesc;
				aExWords = RowData.IDExWords;
			}else{                                        //保存新行
				aICD = RowData.IDICD10;
				aDesc = RowData.IDICDDesc;
				aExWords = RowData.IDExWords;
			}
			debugger
			if((typeof(aICD) == "undefined")||(!aICD)){
				$.messager.alert("错误提示", "第"+(i+1)+"行数据ICD10为空", 'info');
				return;	
			}
			if((typeof(aDesc) == "undefined")||(!aDesc)){
				$.messager.alert("错误提示", "第"+(i+1)+"行数据疾病名称为空", 'info');
				return;	
			}
			var inputStr = obj.RecRowID;
			inputStr = inputStr + "^" + RowIndex2;
			inputStr = inputStr + "^" + aICD;
			inputStr = inputStr + "^" + aDesc;
			inputStr = inputStr + "^" + aExWords;
			var flg = $m({
				ClassName:"DHCMed.SS.DiseaseICD",
				MethodName:"Update",
				aInputStr:inputStr,
				aSeparate:"^"
			},false);
		}
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == -100) {
				$.messager.alert("错误提示", "数据重复!Error=" + flg, 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
			return;
		}else {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.ClearFormItem1();
			obj.gridICDLoad(obj.RecRowID);//刷新当前页
		}
	}
	//别名弹出框保存方法 
	obj.saveToSrv = function(){
		if (endEditing()){
			$('#gridAlias').datagrid('acceptChanges');      //保存之前结束编辑操作
		}
		if (!obj.RecRowID){
			$.messager.alert("发生错误", "无法获取疾病字典ID", 'info');
			return 		
		}
		var rows = $('#gridAlias').datagrid('getRows');
		for(var i = 0; i < rows.length; i ++)
		{
			var RowData = rows[i];
			var aAlias = "";
			var RowID = RowData.ID;
			var RowIndex2 = "";
			if(RowID!=null){                                //保存旧行
				RowIndex2 = RowID.split("||")[1];
				aAlias = RowData.IDAlias;
			}else{                                          //保存新行
				var newData = $("#gridAlias").datagrid('getSelected');
				aAlias = newData["IDAlias"];
			}
			if (aAlias == "") {
				$.messager.alert("错误提示", "别名必填项为空", 'info');
				return;
			}
			var inputStr = obj.RecRowID;
			inputStr = inputStr + "^" + RowIndex2;
			inputStr = inputStr + "^" + aAlias;
			var flg = $m({
				ClassName:"DHCMed.SS.DiseaseAlias",
				MethodName:"Update",
				aInputStr:inputStr,
				aSeparate:"^"
			},false);
		}
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == -100) {
				$.messager.alert("错误提示", "数据重复!Error=" + flg, 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
			return;
		}else {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.ClearFormItem1();
			obj.gridAliasLoad(obj.RecRowID);//刷新当前页
		}
	}
	//清空
	obj.ClearFormItem1 = function() {
		$('#txtDiseaseCode').val('');
		$('#txtDiseaseDesc').val('');
		$('#cboCateg').combobox('setValue','');
		$('#txtDiseaseICD').val('');
		$('#txtDiseaseResume').val('');
		$('#chkIsActive').checkbox('setValue',true);
	}
	
	obj.openHandler = function(RowId){
		obj.RecRowID=RowId;
		$('#AliasLog').dialog("open");
		obj.gridAliasLoad(RowId);
	}
	
	obj.gridAliasLoad = function(RowId){	
		$cm ({
			ClassName:"DHCMed.SSService.DiseaseSrv",
			QueryName:"QryDiseaseAlias",		
			aDiseaseID:RowId
		},function(rs){
			obj.RecRowID=RowId;
			$('#gridAlias').datagrid('loadData', rs);				
		});
    }

	function endEditing_two(){
		if (obj.editIndex == undefined){
			return true;
		}
		if ($('#gridICD').datagrid('validateRow', obj.editIndex)){
			$('#gridICD').datagrid('endEdit', obj.editIndex);
			obj.editIndex = undefined;
			return true;
		} else {
			return false;
		}
	}
	function endEditing(){
		if (obj.editIndex == undefined){
			return true;
		}
		if ($('#gridAlias').datagrid('validateRow', obj.editIndex)){
			$('#gridAlias').datagrid('endEdit', obj.editIndex);
			obj.editIndex = undefined;
			return true;
		} else {
			return false;
		}
	}
	//别名双击修改
	obj.editHandler = function(index){
		if (obj.editIndex!=index) {
			if (endEditing()){	
				$('#gridAlias').datagrid('selectRow', index).datagrid('beginEdit',index);
				obj.editIndex = index;
			} else {
				$('#gridAlias').datagrid('selectRow', obj.editIndex);
			}
		}
	}
	//ICD双击修改
	obj.editHandler_two = function(index){
		if (obj.editIndex!=index) {
			if (endEditing_two()){	
				$('#gridICD').datagrid('selectRow', index).datagrid('beginEdit',index);
				obj.editIndex = index;
			} else {
				$('#gridICD').datagrid('selectRow', obj.editIndex);
			}
		}
	}
	//单击一行将数据填入表单中
	obj.gridDisease_onSelect = function (rowData){
		if (rowData["ID"] == obj.RecRowID) {
			obj.gridDisease.clearSelections();
			obj.ClearFormItem1();
			obj.RecRowID="";
		}
		else {
			obj.RecRowID = rowData["ID"];
			var IDCode = rowData["IDCode"];
			var IDDesc = rowData["IDDesc"];
			var ICD = rowData["ICD10"];
			var Cate = rowData["CateID"];
			var IsActive = rowData["IsActiveDesc"];
			IsActive = (IsActive=="是"? true: false);
			var Resume = rowData["Resume"];
			$('#txtDiseaseCode').val(IDCode);
			$('#txtDiseaseDesc').val(IDDesc);
			$('#txtDiseaseICD').val(ICD);
			$('#txtDiseaseResume').val(Resume);
			$('#cboCateg').combobox('setValue',Cate);
			$('#chkIsActive').checkbox('setValue',IsActive);
		}
	}
	//保存  
	obj.btnSave_click = function(){
		var gridDisease = $("#gridDisease").datagrid('getSelected');
		var inputStr = "";
		var DiseaseId = "";
		if(gridDisease!=null){
			var DiseaseId = gridDisease.ID;
			inputStr =inputStr + DiseaseId;
		}else{
			inputStr =inputStr ;
		}
		var errinfo = "";
		var DiseaseCode = $('#txtDiseaseCode').val();
		var DiseaseDesc = $('#txtDiseaseDesc').val();
		var DiseaseICD = $('#txtDiseaseICD').val();
		var ProductId = $('#cboProduct').combobox('getValue');
		var CateId = $('#cboCateg').combobox('getValue');
		var Resume = $('#txtDiseaseResume').val();
		var IsActive = $('#chkIsActive').checkbox('getValue');
		if(IsActive){
			IsActive='1';
		}else{
			IsActive='0';
		}
		if (!DiseaseCode) {
			errinfo = errinfo + "疾病代码为空!<br>";
		}
		if (!DiseaseDesc) {
			errinfo = errinfo + "疾病描述为空!<br>";
		}
		if (!ProductId) {
			errinfo = errinfo + "请选择产品!<br>";
		}
		if (!CateId) {
			errinfo = errinfo + "请选择分类!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		inputStr = inputStr + '^' + DiseaseCode;
		inputStr = inputStr + '^' + DiseaseDesc;
		inputStr = inputStr + '^' + DiseaseICD;
		inputStr = inputStr + '^' + CateId;
		inputStr = inputStr + '^' + ProductId;
		inputStr = inputStr + '^' + IsActive;
		inputStr = inputStr + '^' + Resume;
		var flg = $m({
			ClassName:"DHCMed.SS.Disease",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparate:'^'
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == -100) {
				$.messager.alert("错误提示", "数据重复!Error=" + flg, 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
			return;
		}else {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID="";
			obj.ClearFormItem1();
			obj.gridDisease.reload();//刷新当前页
		}
	}
	//初始化-别名弹出框
	obj.AliasLog = $('#AliasLog').dialog({
		title: '疾病字典维护-别名',
		iconCls:'icon-w-edit',
		width: 600,
		height: 400,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text:'保存',
			handler:function(){
				obj.saveToSrv();
			}
		},{
			text:'关闭',
			handler:function(){
				$('#AliasLog').window("close");
			}
		}],
		onBeforeOpen:function(){
			obj.editIndex=undefined;
		}
	});
	//初始化-ICD弹出框
	obj.ICDLog = $('#ICDLog').dialog({
		title: '疾病字典维护-ICD',
		iconCls:'icon-w-edit',
		width: 600,
		height: 400,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text:'保存',
			handler:function(){
				obj.saveToSrv_two();
			}
		},{
			text:'关闭',
			handler:function(){
				$('#ICDLog').window("close");
			}
		}],
		onBeforeOpen:function(){
			obj.editIndex=undefined;
		}
	});
	//查询
	obj.QueryLoad = function(){	
		var ProductId = $('#cboProduct').combobox('getValue');
		var objPro = obj.objById(ProductId);
		var DisType = '';
		objPro = JSON.parse(objPro);        //变成json串
		obj.ClearFormItem1();
		if (objPro) 
		{ 
			DisType1 = objPro.ProCode;	
			DisType2 = objPro.ProCode+'DiseaseType';			
		}
		//产品分类联动
		obj.cboCateg = $HUI.combobox('#cboCateg', {              
			url: $URL,
			editable: true,
			mode: 'remote',
			valueField: 'myid',
			textField: 'Description',
			onBeforeLoad: function (param) {
				param.ClassName = 'DHCMed.SSService.DictionarySrv';
				param.QueryName = 'QryDictionary';
				param.aType = DisType2;
				param.aIsActive = 1;
				param.ResultSetType = 'array';
			}
		});
		obj.gridDisease.load({
			ClassName:"DHCMed.SSService.DiseaseSrv",
			QueryName:"QryDisease",	
			aProductCode:DisType1,
			aIsActive:""		//产品
			//aCateID:$('#cboCateg').combobox('getValue')                                   //分类
	    });	
    }
	
}