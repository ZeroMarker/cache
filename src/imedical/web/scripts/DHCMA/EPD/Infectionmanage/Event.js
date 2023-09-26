//页面Event
function InitviewScreenEvent(obj) {
	obj.LoadEvent = function(args){ 
		//查询
		$('#btnQuery').on('click', function(){	
			obj.InfectionLoad();
		});
		//保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		
		//添加按钮
		$('#btnAdd').on('click', function(){
	     	obj.btnAdd_click();
     	});
		//删除按钮
		$('#btnDel').on('click', function(){
	     	obj.btnDel_click();
     	});
    }
	//弹出框中删除按钮
	obj.btnDel_click = function(){
		var RowData1 = $("#gridAlias").datagrid('getSelected');
		if(!RowData1){
			$.messager.alert("提示","请选择一行进行再删除!","info");
			return;
		}
		if(!RowData1.RowID){
			$.messager.alert("提示","当前行尚未保存无需删除!","info");
			return;
		}	

		$.messager.confirm('选择框','确定删除此记录?',function(r){
			if (r){
				var flg = $cm({
					ClassName:"DHCMed.EPD.InfectionAlias",
					MethodName:"Delete",
					ID:RowData1.RowID
				},false);
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示", "删除失败!Error=" + flg, 'info');
					return;
				}else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.gridAliasLoad(obj.RecRowID);//刷新当前页
				}
			}
		});	
	};
	//添加别名
	obj.btnAdd_click = function(){
		if (endEditing()){
			$('#gridAlias').datagrid('appendRow',{
				index: 1,   // 索引从0开始
			});
			obj.editIndex = $('#gridAlias').datagrid('getRows').length-1;
			$('#gridAlias').datagrid('selectRow', obj.editIndex).datagrid('beginEdit', obj.editIndex);
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
	//保存别名 
	obj.saveToSrv = function(){
		if (endEditing()){
			$('#gridAlias').datagrid('acceptChanges');      //保存之前结束编辑操作
		}
		var rows = $('#gridAlias').datagrid('getRows');	
		if (!obj.RecRowID){
			$.messager.alert("发生错误", "无法获取传染病字典ID", 'info');
			return 		
		}
	
		for(var i = 0; i < rows.length; i ++)
		{
			var RowData = rows[i];
			var aAlias = "";
			var aIsKeyWord = "";
			var aIsKeyWordDesc = "";
			var RowID = RowData.RowID;
			var RowIndex2 = "";
			if(RowID!=null){                                //保存旧行
				RowIndex2 = RowID.split("||")[1];
				aAlias = RowData.Alias;
				aIsKeyWord = RowData.IsKeyWord;
				aIsKeyWordDesc = RowData.IsKeyWordDesc;
			}else{                                          //保存新行
				aAlias = RowData.Alias;
				aIsKeyWord = RowData.IsKeyWord;
				aIsKeyWordDesc = RowData.IsKeyWordDesc;
			}
			
			if(typeof(aIsKeyWord) == "undefined"){
				$.messager.alert("错误提示", "第"+(i+1)+"行数据类型为空", 'info');
				return;
			}
			if((typeof(aAlias) == "undefined")||(!aAlias)){
				$.messager.alert("错误提示", "第"+(i+1)+"行数据别名为空", 'info');
				return;	
			}
			var inputStr = obj.RecRowID;
			inputStr = inputStr + "^" + "";
			inputStr = inputStr + "^" + RowIndex2;
			inputStr = inputStr + "^" + aAlias;
			inputStr = inputStr + "^" + aIsKeyWord;
			
			var flg = $m({
				ClassName:"DHCMed.EPD.InfectionAlias",
				MethodName:"Update",
				Instring:inputStr,
				Delimiter:"^"
			},false);
		}
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == -100) {
				$.messager.alert("错误提示", "数据重复!",'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!", 'info');
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
		$('#txtICD').val('');
		$('#txtName').val('');
		$('#cboKind').combobox('setValue','');
		$('#cboLevel').combobox('setValue','');
		$('#cboAppendix').combobox('setValue','');
		$('#txtTimeLimit').val('');
		$('#txtResume').val('');
		$('#chkWork').checkbox('setValue',false);
		$('#chkMulti').checkbox('setValue',false);
	}
	

	obj.OpenAlias = function(RowId){
		obj.RecRowID=RowId;
		$('#AliasLog').dialog("open");
		obj.gridAliasLoad(RowId);
	}
	obj.gridAliasLoad = function(RowId){	
		$cm ({
			ClassName:"DHCMed.EPDService.InfectionSrv",
			QueryName:"QryAliasByRowID",		
			Parref: RowId
		},function(rs){
			obj.RecRowID=RowId;
			$('#gridAlias').datagrid('loadData', rs);				
		});
    }
	function endEditing(){
		if (obj.editIndex == undefined){
			return true;
		}
		if ($('#gridAlias').datagrid('validateRow', obj.editIndex)){
			var ed = $('#gridAlias').datagrid('getEditor', {index:obj.editIndex,field:'IsKeyWord'});
			if (ed==null){ return true;}
			var IsKeyWordDesc = $(ed.target).combobox('getText');
			$('#gridAlias').datagrid('getRows')[obj.editIndex]['IsKeyWordDesc'] = IsKeyWordDesc;
			
			$('#gridAlias').datagrid('endEdit', obj.editIndex);
			obj.editIndex = undefined;
			return true;
		} else {
			return false;
		}
	}
	//双击修改
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
	//单击一行将数据填入表单中
	obj.gridInfType_onSelect = function (rowData){
		if (rowData["RowID"] == obj.RecRowID) {
			obj.gridInfection.clearSelections();
			obj.ClearFormItem1();
			obj.RecRowID="";
		}else {
			obj.RecRowID = rowData["RowID"];
			$cm({                  
				ClassName:"DHCMed.EPD.Infection",
				MethodName:"GetObjById",
				id:rowData["RowID"]
			},function(rd) {						
				$('#txtICD').val(rd["MIFICD"]);
				$('#txtName').val(rd["MIFDisease"]);
				$('#cboKind').combobox('setValue',rd["MIFKind"]);
				$('#cboLevel').combobox('setValue',rd["MIFRank"]);
				$('#cboAppendix').combobox('setValue',rd["MIFAppendix"]);
				$('#chkMulti').checkbox('setValue',(rd["MIFMulti"]=='Y'? true: false));
				$('#txtTimeLimit').val(rd["MIFTimeLimit"]);
				$('#txtResume').val(rd["MIFResume"]);
				$('#chkWork').checkbox('setValue',(rd["MIFIsActive"]=='Y'? true: false));
			});
		}
	}
	
	//保存  
	obj.btnSave_click = function(){
	   	var errinfo = "";
		var ICD = $('#txtICD').val();
		var txtName = $('#txtName').val();
		var cboKind = $('#cboKind').combobox('getValue');
		var cboLevel = $('#cboLevel').combobox('getValue');
		var cboAppendix = $('#cboAppendix').combobox('getValue');
		var chkMulti = $('#chkMulti').checkbox('getValue');         //多次患病

		if(chkMulti){
			chkMulti='Y';
		}else{
			chkMulti='N';
		}
		var chkDependent ='Y';                                         //客观诊断
		var txtTimeLimit = $('#txtTimeLimit').val();
		var txtResume = $('#txtResume').val();
		var txtMinAge = "";
		var txtMaxAge = "";
		var chkWork = $('#chkWork').checkbox('getValue');
		if(chkWork){
			chkWork='Y';
		}else{
			chkWork='N';
		}
		if (!ICD) {
			errinfo = errinfo + "ICD为空!<br>";
		}
		if (!txtName) {
			errinfo = errinfo + "传染病名称为空!<br>";
		}
		if (!cboKind) {
			errinfo = errinfo + "传染病类别为空!<br>";
		}
		if (!cboLevel) {
			errinfo = errinfo + "传染病级别为空!<br>";
		}
	
		if (chkMulti=="Y"&!txtTimeLimit) {
			errinfo = errinfo + "可多次患病的疾病重复报告时限不能为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + ICD;
		inputStr = inputStr + CHR_1 + txtName;
		inputStr = inputStr + CHR_1 + cboKind;
		inputStr = inputStr + CHR_1 + cboLevel;
		inputStr = inputStr + CHR_1 + cboAppendix;
		inputStr = inputStr + CHR_1 + chkMulti;
		inputStr = inputStr + CHR_1 + chkDependent;
		inputStr = inputStr + CHR_1 + txtTimeLimit;
		inputStr = inputStr + CHR_1 + txtResume;
		inputStr = inputStr + CHR_1 + txtMinAge;
		inputStr = inputStr + CHR_1 + txtMaxAge;
		inputStr = inputStr + CHR_1 + chkWork;
	
		var flg = $m({
			ClassName:"DHCMed.EPD.Infection",
			MethodName:"Update",
			Instring:inputStr,
			Delimiter:CHR_1
		},false);
	
		if (parseInt(flg) <= 0) {
			$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			return;
		}else {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.ClearFormItem1();
			obj.RecRowID="";
			obj.gridInfection.reload();//刷新当前页
		}
	}
	//初始化-别名弹出框
	obj.AliasLog = $('#AliasLog').dialog({
		title: '传染病字典维护-别名',
		iconCls:'icon-w-edit',
		width: 600,
		height: 400,
		modal: true,
		isTopZindex:true,
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
				$('#AliasLog').dialog("close");
			}
		}],
		onBeforeOpen:function(){
			obj.editIndex=undefined;
		}
	});
	//查询
	obj.InfectionLoad = function(){
		var Multi =  $("#chkMulti").checkbox('getValue')? 'Y':''; 
		var Work =  $("#chkWork").checkbox('getValue')? 'Y':'';            
		obj.gridInfection.load({
			ClassName:"DHCMed.EPDService.InfectionSrv",
			QueryName:"QryIFList",	
			aICD:$('#txtICD').val(),                                   //ICD
			aName:$('#txtName').val(),                                 //传染病名称
			aKind:$('#cboKind').combobox('getValue'),                  //传染病类别
			aRank:$('#cboLevel').combobox('getValue'),                 //传染病级别
			aAppendixID:$('#cboAppendix').combobox('getValue'),         //附卡类型
			aTimeLimit:$('#txtTimeLimit').val(),
			aMulti:Multi,					                           //多次患病
			aWork:Work					                               //是否有效
	    });	
    }
	
}
