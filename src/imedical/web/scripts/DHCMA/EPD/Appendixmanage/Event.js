function InitviewScreenEvent(obj) {
	
	obj.LoadEvent = function(args){ 
		//添加传染病附卡项目
		$('#btnAdd').on('click', function(){
	     	obj.btnAdd_click();
     	});
     	//保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#AppendixEdit').close();
     	});
     	//添加
		$('#btnAddTwo').on('click', function(){
			obj.InitDialog();
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd = obj.gridAppendixCard.getSelected();
			obj.InitDialog(rd);
		});
    }
    
	//窗体初始化
	obj.AppendixEdit = $('#AppendixEdit').dialog({
		title:'传染病附卡维护',
		iconCls:'icon-w-edit',
		closed: true,
		modal: true,
		isTopZindex:true
	});
	// 传染病附卡保存
	obj.btnSave_click = function(){
		var errinfo = "";
		var Code 	= $.trim($('#txtCode').val());
		var Desc 	= $.trim($('#txtDesc').val());
		var Kind 	= $.trim($('#txtKind').val());
		var ActiveDate = $("#ActiveDate").datebox('getValue');
		var Resume 	= $.trim($('#txtResume').val());
		var IsActive = $('#chkIsActive').checkbox('getValue')? 'Y':'N';
		if (!Code) {
			errinfo = errinfo + "代码不能为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "描述不能为空!<br>";
		}	
		if (!Kind){
			errinfo = errinfo + "类别不能为空!<br>";
		}
		
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + "^" + Code;
		inputStr = inputStr + "^" + Desc;	
		inputStr = inputStr + "^" + IsActive;
		inputStr = inputStr + "^" + Kind;
		inputStr = inputStr + "^" + ActiveDate;
		inputStr = inputStr + "^" + Resume;
		console.log(inputStr);
		var flg = $m({
			ClassName:"DHCMed.EPD.AppendixCard",
			MethodName:"Update",
			arg:inputStr,
			separete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if(parseInt(flg) == -1){
				$.messager.alert("错误提示", "代码重复!" , 'info');
				return;
			}else{
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
				return;
			}
		}else {
			$HUI.dialog('#AppendixEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID="";
			$("#btnEdit").linkbutton("disable");
			obj.gridAppendixCard.reload() ;//刷新当前页
		}
	}
	//单击选中事件
	obj.gridAppendixCard_onSelect = function (){
		var rowData = obj.gridAppendixCard.getSelected();
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			obj.gridAppendixCard.clearSelections();  //清除选中行
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
		}
	}
	//窗口初始化
	obj.InitDialog = function(rd){
		if(rd){
			obj.RecRowID 	= rd["ID"];
			var Code 		= rd["Code"];
			var Desc 		= rd["Description"];
			var Type 		= rd["Type"];
			var FromDate 	= rd["FromDate"];
			var ResumeText  = rd["ResumeText"];
			var IsActive 	= rd["IsActive"];
			$('#txtCode').val(Code).validatebox("validate");
			$('#txtDesc').val(Desc).validatebox("validate");
			$('#txtKind').val(Desc).validatebox("validate");
			$('#ActiveDate').datebox('setValue',FromDate)
			$('#txtResume').val(ResumeText);
			$('#chkIsActive').checkbox('setValue',(IsActive=="是" ? true:false));
		}else{
			obj.RecRowID = "";
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#txtKind').val('');
			$('#ActiveDate').datebox('clear');
			$('#txtResume').val('');
			$('#chkIsActive').checkbox('setValue','');
		}
		$HUI.dialog('#AppendixEdit').open();
	}
	
	
	
	//初始化-传染病附卡项目弹出框
	obj.AppendixLog = $('#AppendixLog').dialog({
		title: '传染病附卡项目',
		iconCls:'icon-w-edit',
		width: 925,
		height: 500,
		closed: true,
		modal: true,
		buttons:[{
			text:'保存',
			iconCls:'icon-w-save',
			handler:function(){
				obj.saveToSrv();
			}
		},{
			text:'关闭',
			iconCls:'icon-w-close',
			handler:function(){
				obj.RecRowID = "";
				$('#AppendixLog').window("close");
			}
		}],
		onBeforeOpen:function(){
			obj.editIndex=undefined;
		}
	});
	obj.openHandler = function(RowData){
		obj.RecRowID = RowData["ID"];
		$('#AppendixLog').window("open");
		obj.gridAppendixItem =$HUI.datagrid("#gridAppendixItem",{
			title: "提示：本界面只维护附卡项目，如需在报告中显示项目，需对应维护HTML，辅助字典、是否必填项以HTML中控制为准",
			headerCls:'panel-header-gray',
			iconCls:'icon-tip',
			height:400,
			rownumbers: true, //如果为true, 则显示一个行号列
			url:$URL,
			singleSelect: true,
			queryParams:{
				ClassName:"DHCMed.EPDService.AppendixCardSrv",
				QueryName:"QryAppendixCartItem",
				AppendixCardID:RowData.ID,
				IsActive:''
			},
			columns:[[
				{field:'ID',title:'ID',hidden:true},				
				{field:'ItemCode',title:'项目代码',width:'150',
					editor:{
						type:'validatebox',
						options:{
							//required:true
						}
					}
				},
				{field:'Name',title:'项目名称',width:'260',
					editor:{
						type:'validatebox',
						options:{
							//required:true
						}
					}
				},
				{field:'HiddenValueDataType',title:'数据类型',width:'100',
					formatter:function(value,row){
							return row.DataType;
					},
					editor:{
						type:'combobox',
						options:{
							url: $URL,
							editable: true,
							valueField: 'Code',
							//required:true,
							textField:'Description',
							onBeforeLoad: function (param) {
								param.ClassName = 'DHCMed.SSService.DictionarySrv';
								param.QueryName = 'QryDictionary';
								param.aType = 'EPIDEMICAPPENDIXDATATYPE';
								param.aIsActive = '1';
								param.ResultSetType = 'array';
							}
						}
					}
				},
				{field:'HiddenValueDicName',title:'辅助字典',width:'150',
					formatter:function(value,row){
							return row.DicName;
					},
					editor:{
						type:'combobox',
						options:{
							url: $URL,
							editable: true,
							valueField: 'Code',
							textField:'Description',
							onBeforeLoad: function (param) {
								param.ClassName = 'DHCMed.SSService.DictionarySrv';
								param.QueryName = 'QrySSDictionary';
								param.type = 'SYS';
								param.ResultSetType = 'array';
							}
						}
					}
				},
				{field:'IsNecess',title:'是否必填项',align:'center',width:'90',
					formatter:function(value,row){
							if(value=="Y"){
								return "是"
								}
								else{
									return "否"
									}
					}
					,editor:{type:'icheckbox',options:{on:'Y',off:'N'}}},
					{field:'ItemActive',title:'是否有效',align:'center',width:'90',
					formatter:function(value,row){
							if(value=="Y"){
								return "是"
								}
								else{
									return "否"
									}
					}
					,editor:{type:'icheckbox',options:{on:'Y',off:'N'}}},
				{field:'ValExp',title:'默认值表达式',width:'100',editor:'text'}
			]],
			onDblClickRow:function(rindex,rowData1){
				obj.editHandler(rindex);
			}
		});
	}
	//添加传染病附卡项目
	obj.btnAdd_click = function(){
		if (endEditing()){
			/*$('#gridAppendixItem').datagrid('appendRow',{
				index: 1,   // 索引从0开始
			});
			obj.editIndex = $('#gridAppendixItem').datagrid('getRows').length-1;
			*/
			$('#gridAppendixItem').datagrid('insertRow',{ /*添加时如果没有正在编辑的行,则在datagrid的第一行插入一行*/
				index: 0,   // 索引从0开始
				row:{
					ID                  :'',
					ItemCode            :'',
					Name                :'',
					IsActive            :'',
					HiddenValueDataType :'',
					HiddenValueDicName  :'',
					IsNecess            :'',
					ItemActive          :'',
					ValExp              :'' 
				}
			});
		   	obj.editIndex =0;
			$('#gridAppendixItem').datagrid('selectRow', obj.editIndex).datagrid('beginEdit', obj.editIndex);
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
	//双击修改
	obj.editHandler = function(index){
		if (obj.editIndex!=index) {
			if (endEditing()){
				$('#gridAppendixItem').datagrid('selectRow', index).datagrid('beginEdit',index);
				obj.editIndex = index;
			} else {
				$('#gridAppendixItem').datagrid('selectRow', obj.editIndex);
			}
		}
	}
	
	//保存传染病附卡项目      当是否有效为否时，默认不显示
	obj.saveToSrv = function(){                  //当附卡选不中时，不能保存
		if (endEditing()){
			$('#gridAppendixItem').datagrid('acceptChanges');      //保存之前结束编辑操作
		}
		var rows = $('#gridAppendixItem').datagrid('getRows');
		
		var boolIsPassed = false;
		for(var i = 0; i <  rows.length; i ++) {
			boolIsPassed = obj.ValidateContents(rows[i]);
			if(boolIsPassed == false) {
				break;
			}
		}
		if (boolIsPassed) {
			for(var i = 0; i < rows.length; i ++){
				var RowData = rows[i];
				var ID ="";
				var HiddenValueDataType = "";
				var HiddenValueDicName = "";
				var flgID = RowData.hasOwnProperty("ID");  //判断json串中是否有ID这个字段
				var ItemCode ="";
				var IsActive = "";
				var IsNecess = "";
				var ItemActive = "";
				
				var Name = "";
				var ValExp = ""
				var inputStr = "";
				var errinfo=""
				if(flgID){     //保存旧行
					HiddenValueDataType = RowData.HiddenValueDataType;
					HiddenValueDicName = RowData.HiddenValueDicName;
					ItemCode = RowData.ItemCode
					IsActive = RowData.ItemActive
					ID = RowData.ID;
					IsNecess = RowData.IsNecess;
					Name = RowData.Name;
					ValExp = RowData.ValExp;
					ItemActive = RowData.ItemActive;
					
					
				}else{            //保存新行
					var newData = $("#gridAppendixItem").datagrid('getSelected');
					ID =  newData["ID"];
					HiddenValueDataType = newData["HiddenValueDataType"];
					HiddenValueDicName = newData["HiddenValueDicName"];
					ItemCode = newData["ItemCode"];
					IsActive = newData["ItemActive"];
					IsNecess = newData["IsNecess"];
					Name = newData["Name"];
					ValExp = newData["ValExp"];
				}
				inputStr = ID +"^";
				inputStr = inputStr + obj.RecRowID + "^";
				inputStr = inputStr + Name + "^";
				inputStr = inputStr + IsActive + "^";
				inputStr = inputStr + HiddenValueDataType + "^";
				inputStr = inputStr + HiddenValueDicName + "^";
				inputStr = inputStr + ValExp + "^";
				inputStr = inputStr + IsNecess + "^";
				inputStr = inputStr + ItemCode;
				
				var flg = $m({
					ClassName:"DHCMed.EPD.AppendixCardSub",
					MethodName:"Update",
					InString:inputStr,
					separete:"^"
				},false);
				
				if (parseInt(flg) <= 0) {
					$.messager.alert("错误提示", "保存失败!", 'info');
					return;
				}			
			}
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.gridAppendixItem.load();//刷新当前页
		}
	}
	
	obj.ValidateContents = function(Row) {   //数据校验
		if(!Row) return true;
		var ind = obj.gridAppendixItem.getRowIndex(Row);
		if($.trim(Row["ItemCode"]) == "") {
			$.messager.alert("提示", "第" + (ind + 1) + "行数据，请输入项目代码！", 'info');
			return false;
		}
		
		if($.trim(Row["Name"]) == "") {
			$.messager.alert("提示", "第" + (ind + 1) + "行数据，请输入项目名称！", 'info');
			return false;
		}
		if (Row["DataType"] == "") {
			$.messager.alert("提示", "第" + (ind + 1) + "行数据，请选择数据类型！",  'info');
			return false;			
		}
		if((Row["HiddenValueDataType"] == "4") && (Row["DicName"] == "")) {
			$.messager.alert("提示", "第" + (ind + 1) + "行数据，请选择辅助字典名称！", 'info');
			return false;
		}
		return true;
	}
	
	function endEditing(){
		if (obj.editIndex == undefined){
			return true;
		}
		if ($('#gridAppendixItem').datagrid('validateRow', obj.editIndex)){   //行编辑换行时调用
			/*
			var edItemCode = $('#gridAppendixItem').datagrid('getEditor', {index:obj.editIndex,field:'ItemCode'});
			var ItemCode = $(edItemCode.target).val();
			$('#gridAppendixItem').datagrid('getRows')[obj.editIndex]['ItemCode'] = ItemCode;	
			var edName = $('#gridAppendixItem').datagrid('getEditor', {index:obj.editIndex,field:'Name'});
			var Name = $(edName.target).val();
			$('#gridAppendixItem').datagrid('getRows')[obj.editIndex]['Name'] = Name;	
	        */
			var edDataType = $('#gridAppendixItem').datagrid('getEditor', {index:obj.editIndex,field:'HiddenValueDataType'});
			var DataType = $(edDataType.target).combobox('getText');
			$('#gridAppendixItem').datagrid('getRows')[obj.editIndex]['DataType'] = DataType;	
			var edDicName = $('#gridAppendixItem').datagrid('getEditor', {index:obj.editIndex,field:'HiddenValueDicName'});
			var DicName = $(edDicName.target).combobox('getText');
			$('#gridAppendixItem').datagrid('getRows')[obj.editIndex]['DicName'] = DicName;
			$('#gridAppendixItem').datagrid('endEdit', obj.editIndex);
			obj.editIndex = undefined;
			return true;
		} else {
			return false;
		}
	}
	//清空
	obj.ClearFormItem1 = function() {
		$('#txtCode').val('');
		$('#txtDesc').val('');
		$('#txtType').val('');
		$('#dtActiveDate').datebox('clear'), 
		$('#txtResume').val('');
		$('#chkWork').checkbox('setValue',false);
	}
}