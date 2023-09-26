/**
 * @Title:指标定义
 * @Author: 汪凯-DHCWL
 * @Description:指标定义配置界面
 * @Created on 2018-01-10
 */
var grpBodyHeight = getViewportOffset().y;   // 获取屏幕高度
var deleteKey = 0;
var KPIGridObj = "";
var CHAGE_KPI_CODE = "";



 /*--指标数据检索--*/
 function freshKPIRuleTableFun(kpiInforList){
	var kpiCode,kpiName,kpiMea,kpiExeCode,dataNode,kpiCreator,kpiDimCodes,kpiDesc,kpiType,kpiSection,kpiValueType,kpiRemark
	kpiInforArr = kpiInforList.split("@");
	kpiCode = kpiInforArr[0];
	kpiName = kpiInforArr[1];
	kpiMea = kpiInforArr[2];
	kpiExeCode = kpiInforArr[3];
	dataNode = kpiInforArr[4];
	kpiCreator = kpiInforArr[5];
	kpiDimCodes = kpiInforArr[6];
	kpiType = kpiInforArr[7];
	kpiRemark = kpiInforArr[8];
	$("#KPIGrid").datagrid('load',{ClassName:"web.DHCWL.V1.KPI.KPIFunction",QueryName:"GetKPIListQuery",kpiCode:kpiCode, kpiName:kpiName, kpiExcode:kpiExeCode, createUser:kpiCreator, dataNode:dataNode, dimType:kpiDimCodes, category:kpiType,nodeMark:kpiRemark,filterMea:kpiMea});  //重新加载指标信息
}

 
var init = function(){
	
	/*--指标维度维护表格--*/
	var kpiDimGridObj=$HUI.datagrid("#kpiDimGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.KPI.KPIFunction",  //调用方法或query的路径
			QueryName:"GetKPIDimQuery"  //调用query名
		},
		pagination:false,
		pageSize:15,
		pageList:[5,10,20,50,100],
		fitColumns:true,
		onClickCell:function(rowIndex, field, value){  //响应行选中事件
			var rows = $("#kpiDimGrid").datagrid("getRows");
			if (rows){
				for (var i=0;i < rows.length;i++){
					$('#kpiDimGrid').datagrid('endEdit', i);
				}
			}
			if (field == "MKPIDimDeli") {
				$('#kpiDimGrid').datagrid('beginEdit', rowIndex);
			}
		},
		toolbar:[{
			iconCls:'icon-batch-cfg',
			text:'配置指标维度',
			handler:function(){
				$("#kpiDimDig").show();
				var kpiDimObj = $HUI.dialog("#kpiDimDig",{
					resizable:true,
					modal:true,
					iconCls:'icon-w-config'
				});
				$("#searchText").searchbox("setValue","");
				//$("#dimRoleSelectObj").datagrid('load');
				kpiDimSelectorObj.load({ClassName:'web.DHCWL.V1.KPI.KPIFunction',QueryName:'GetAllDimRoleQuery',filterCode:''});
				$("#selectedKPIDimObj").datagrid("loadData",[]);
				var rows = $("#kpiDimGrid").datagrid("getRows");
				for(var i = 0;i<rows.length;i++){
					$("#selectedKPIDimObj").datagrid("insertRow",{
						row:{
							MKPIDimCode:rows[i].MKPIDimCode,
							MKPIDimDimDr:rows[i].MKPIDimDimDr,
							KDT_Code:rows[i].KDT_Code,
							KDT_Name:rows[i].KDT_Name
						}
					});
				}
				
			}
		},{
			iconCls:'icon-arrow-top',
			handler:function() {
				moveup("kpiDimGrid");  //调用util文件中的方法，移动表格数据
				var rows = $("#kpiDimGrid").datagrid("getRows");  //指标维度移动后，刷新其排序值
				if (rows) {
					for (var i = 0;i < rows.length;i++) {
						rows[i]["MKPIDimOrder"] = (i+1);
						$("#kpiDimGrid").datagrid("refreshRow",i); 
					}
				}
			}
		},{
			iconCls:'icon-arrow-bottom',
			handler:function() {
				movedown("kpiDimGrid");  //解析同上
				var rows = $("#kpiDimGrid").datagrid("getRows");
				if (rows) {
					for (var i = 0;i < rows.length;i++) {
						rows[i]["MKPIDimOrder"] = (i+1);
						$("#kpiDimGrid").datagrid("refreshRow",i); 
					}
				}
			}
		}]
	});
	
	
	/*--指标维度选取表格--*/
	var kpiDimSelectorObj=$HUI.datagrid("#dimRoleSelectObj",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.KPI.KPIFunction",
			QueryName:"GetAllDimRoleQuery",
		},
		pagination:true,
		//striped:true,
		pageSize:10,
		pageList:[5,10,15,20,25,50],
		fitColumns:true,
		toolbar:"#usertb"
		
	});
	
	/*--去掉上面表格分页的文字--*/
	var pagObj=$("#dimRoleSelectObj").datagrid("getPager");
	$(pagObj).pagination({
		displayMsg:""
	});
	
	/*--已选指标维度表格--*/
	var kpiDimSelectoredObj=$HUI.datagrid("#selectedKPIDimObj",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.KPI.KPIFunction",
			QueryName:"GetSelectedKPIDimQuery"
		},
		pagination:true,
		//striped:true,
		pageSize:50,
		pageList:[50,100],
		fitColumns:true,
		toolbar:[{
			iconCls:'icon-save',
			text:"保存",
			handler:function(){
				$("#kpiDimGrid").datagrid("loadData",[]);
				var rows = $("#selectedKPIDimObj").datagrid("getRows");
				var code,name,dimCode,dimName,order;
				for(var i=0;i<rows.length;i++) {
					code = rows[i].MKPIDimCode;
					name = rows[i].MKPIDimDimDr;
					dimCode = rows[i].KDT_Code;
					dimName = rows[i].KDT_Name;
					order = i+1;
					$("#kpiDimGrid").datagrid("insertRow",{
						row:{
							ID:"",
							MKPIDimCode:code,
							MKPIDimDimDr:name,
							KDT_Name:dimName,
							KDT_Code:dimCode,
							MKPIDimOrder:order,
							MKPIDimDeli:','
						}
					});
				}
				$("#kpiDimDig").dialog('close');
			}
		},{
			iconCls:'icon-arrow-top',
			text:'上移',
			handler:function() {
				moveup("selectedKPIDimObj");
			}
		},{
			iconCls:'icon-arrow-bottom',
			text:'下移',
			handler:function() {
				movedown("selectedKPIDimObj");
			}
		}]
	});
	/*--去掉上面表格分页的文字--*/
	var pagObj=$("#selectedKPIDimObj").datagrid("getPager");
	$(pagObj).pagination({
		displayMsg:""
	});
	
	var kpiTaskExeCode = $HUI.datagrid("#exeCodeListGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.KPI.KPIFunction",
			QueryName:"GetExeCodeListQuery",
			secCode:""
		},
		//striped:true,
		fitColumns:true,
		onClickRow:function(rowIndex,rowData) {
			var selExeCode=rowData.exeCodeWrite
			if (selExeCode != ""){
				var row = $("#kpiTaskGrid").datagrid("getSelected");
				row["DTaskExcuteCode"] = selExeCode;
				var index = $("#kpiTaskGrid").datagrid("getRowIndex",row);
				$("#kpiTaskGrid").datagrid("refreshRow",index);
				$("#exeCodeList").dialog("close");
			}
			
		}
	})
	
	var flagList = [
            {flagValue:'是',flagName:'是'},
            {flagValue:'否',flagName:'否'}
       ];
	
	/*--指标任务维护表格--*/
	var kpiTaskGridObj=$HUI.datagrid("#kpiTaskGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.KPI.KPIFunction",  //调用方法或query的路径
			QueryName:"GetKPITaskQuery"  //调用query名
		},
		columns:[[{field:'ID',title:'任务区间ID',width:100,hidden:true},
		 	{field:'SecCode',title:'任务区间编码',width:100},
		 	{field:'SecName',title:'任务区间名称',width:125},
		 	{field:'DTaskExcuteCode',title:'任务执行代码',width:270,formatter:function(value,row,index){
		 		return "<p style='color:#0000EB'>"+value+"</p>";
		 	}},
		 	{field:'DTaskExcuteCodeTip',title:'执行时执行代码',width:135,hidden:true},
			{field:'DTaskActiveFlag',title:'是否激活',width:80,align:'center',editor:{type:'checkbox',options:{on:'是',off:'否'}}}	//{field:'DTaskActiveFlag',title:'是否激活',width:80,editor:{type:'combobox',options:{valueField:'flagValue',textField:'flagName',data:flagList,required:true}}}
		 ]],
		onClickCell:function(rowIndex, field, value){  //响应行选中事件
			var rows = $("#kpiTaskGrid").datagrid("getRows");
			if (rows){
				for (var i=0;i < rows.length;i++){
					$('#kpiTaskGrid').datagrid('endEdit', i);
				}
			}
			if (field == "DTaskActiveFlag") {
				$('#kpiTaskGrid').datagrid('beginEdit', rowIndex);
			}
			if (field == "DTaskExcuteCode") {
				$("#exeCodeList").show();
				var exeCodeObj = $HUI.dialog("#exeCodeList",{
					iconCls:'icon-w-list',
					resizable:true,
					modal:true
				});
				kpiTaskExeCode.load({ClassName:'web.DHCWL.V1.KPI.KPIFunction',QueryName:'GetExeCodeListQuery',secCode:rows[rowIndex].SecCode});
			}
		},
		fitColumns:true,
		toolbar:[{
			iconCls:'icon-add',
			text:'新增区间任务',
			handler:function(){
				var rows = $("#kpiTaskGrid").datagrid("getRows");
				var taskCodes = "",i;
				for (i = 0;i < rows.length;i++){
					if (!taskCodes){
						taskCodes=rows[i].SecCode;
					}else{
						taskCodes=taskCodes+","+rows[i].SecCode;
					}
				}
				var row = $("#KPIGrid").datagrid("getSelected");
				var rowID=""
				if (row) {
					rowID = row.ID;
				}
				$.cm({
					ClassName:'web.DHCWL.V1.KPI.KPIFunction',
					MethodName:'GetNextKPITask',
					kpiCode:rowID,
					existCode:taskCodes
				},function(jsonData){
					if (jsonData.sc != "ok") {
						$.messager.alert("提示",jsonData.sc);
					}else {
						if (jsonData.flag == "Y"){
							flag = "是";
						}
						if (jsonData.flag == "N"){
							flag = "否";
						}
						$("#kpiTaskGrid").datagrid("insertRow",{
							row:{
								SecCode:jsonData.code,
								SecName:jsonData.desc,
								DTaskExcuteCode:jsonData.exeCode,
								DTaskActiveFlag:flag
							}
						});
						//alert(jsonData.code+","+jsonData.desc+","+jsonData.exeCode+","+jsonData.flag);
					}
				});
			}
		},"-",{
			iconCls:'icon-remove',
			text:'顺序删除',
			handler:function() {
				var rows = $("#kpiTaskGrid").datagrid("getRows");
				if (!rows) {
					return;
				}
				var secCodes = "";
				for (var i=0;i<rows.length;i++) {
					if (secCodes == ""){
						secCodes = rows[i].SecCode
					}else {
						secCodes = secCodes + ","+rows[i].SecCode
					}
				}
				$.cm({
					ClassName:'web.DHCWL.V1.KPI.KPIFunction',
					MethodName:'GetDeleteTaskCode',
					taskCodes:secCodes
					},function(jsonData){
						if (jsonData.sc != "ok") {
							$.messager.alert("提示",jsonData.sc);
						}else {
							var rows=$("#kpiTaskGrid").datagrid("getRows");
							for (var i = 0;i <= (rows.length - 1);i++){
								if (rows[i].SecCode == jsonData.secCode) {
									var index = $("#kpiTaskGrid").datagrid("getRowIndex",rows[i])
									$("#kpiTaskGrid").datagrid("deleteRow",index);
									return;
								}
							}
						}
					});
			}
		},"-",{
			iconCls:'icon-ok',
			text:'激活全部',
			handler:function() {
				var rows = $("#kpiTaskGrid").datagrid("getRows");
				for (var i = 0;i<rows.length;i++) {
					if (rows[i]["DTaskActiveFlag"] != "是") {
						rows[i]["DTaskActiveFlag"]="是";
						$('#kpiTaskGrid').datagrid('refreshRow', i);
					}  
				}
			}
		}]
	});
	
	/*--指标表格数据--*/
	var KPIGridObj = $HUI.datagrid("#KPIGrid",{
		url:$URL,   //URL固定写法
		queryParams:{
			ClassName:"web.DHCWL.V1.KPI.KPIFunction",  //调用方法或query的路径
			QueryName:"GetKPIListQuery"  //调用query名
		},
		pagination:true,  //分页可用
		fitColumns:true,
		pageSize:15,  //当前页每页条数
	    pageList:[5,10,15,20,50,100],  //每页可以选中的显示条数
		toolbar:"#kpiConfigToolbar"/*[{
			text:'新增',
			iconCls:'icon-add',
			handler:function(e){
				//$("#kpiCode").attr("disabled",false);
				clearAllKPIInfor();
				$('#KPIGrid').datagrid('insertRow',{
					index: 0,
					row: {
						ID: '',
						kpiCode: '',
						kpiName: ''
					}
				});
				$("#KPIGrid").datagrid('selectRow',0);
			}
		},{
			text:'删除',
			iconCls:'icon-cancel',
			handler:function(e){
				
				if(deleteKey == 0){
					var passWord = getPassWord() + 10;
					$.messager.prompt("提示", "为保障系统安全,请先输入密码验证:", function (r) {
						if (r) {
							
							if (r == passWord){
								//deleteTaskDetail();
								$.messager.popover({msg: '验证成功,请再次操作~',type:'success',timeout: 1000});
								deleteKey = 1;
							}else{
								myMsg("密码输入有误~");
								return;
							}
						} else {
							//alert("点击了【取消】或输入为空");
							//return;
							$.messager.popover({msg: '请输入有效密码！',type:'info',timeout: 2000,showType: 'show'});
						}
					});
				}else{
					$.messager.confirm("提示", "删除后将不能恢复,确认删除??", function (r) {
						if (r) {
							
							$.messager.confirm("提示", "删除指标时，会删除【勾选】的指标及指标的所有指标维度、模块与报表中数据集的配置，确定要删除？", function (r) {
								if (r) {
									var rowData = $("#KPIGrid").datagrid("getSelected");
									if (!rowData){
										myMsg("请先选择一条修改的指标");
										return;
									}
									var kpiID = rowData.ID;
									if (!kpiID){
										myMsg("获取指标失败");
										return;
									}
									$m({
										ClassName:'web.DHCWL.V1.KPI.KPIFunction',
										MethodName:'DeleteKPI',
										ids:kpiID
									},function(e){
										myMsg(e);
										KPIGridObj.reload();  //重新加载指标信息
										clearAllKPIInfor();
									})
									
								} 
							});
							
						}
					});
				}
				
				
			}
		}]*/,
		onSelect:function(rowIndex,rowData){  //响应行选中事件
			if (rowIndex>-1){
				loadKPIMea();
				clearAllKPIInfor();
				
				if (rowData.kpiCode != ""){
					$("#kpiCode").attr("disabled",true);
				}else{
					$("#kpiCode").attr("disabled",false);
				}
				
				$("#kpiCode").val(rowData.kpiCode);
				$("#kpiName").val(rowData.kpiName);
				var meaIDs = rowData.meaID;
				if(meaIDs){
					var meaArr = meaIDs.split(",");
					$('#kpiMeasure').combogrid('setValues', meaArr);
				}
				//$("#kpiMeasure").val(rowData.measure);
				$("#exeCode").val(rowData.kpiExcode);
				$("#dataNode").val(rowData.dataNode);
				$("#creator").val(rowData.createUser);
				$("#kpiUpdate").datebox('setValue', rowData.updateDate);
				$("#kpiDesc").val(rowData.kpiDesc);
				$("#kpiType").combobox('setValue',rowData.category);
				$("#kpiSection").combobox('setValue',rowData.section);
				$("#kpiValueType").combobox('setValue',rowData.getValueType);
				$("#kpiRemark").val(rowData.nodeMark);
				
				
				if (rowData.MKPIGlobalFlag == "N") {
					$HUI.checkbox("#kpiGlobal").setValue(false);
				} else {
					$HUI.checkbox("#kpiGlobal").setValue(true);
				}
				
				kpiDimGridObj.load({ClassName:"web.DHCWL.V1.KPI.KPIFunction",QueryName:"GetKPIDimQuery",kpiID:rowData.ID});  //重新加载指标维度
				
				$("#calRule").val("");   //清空计算指标信息
				$("#sumDim").val("");
				$("#kpiTaskGrid").datagrid('loadData',{total:0,rows:[]}); //清空指标任务表格
				
				if (rowData.getValueType == "计算指标"){
					$('#kpinforTab').tabs('enableTab', "计算指标配置");
					$('#kpinforTab').tabs('disableTab', "指标任务");
					getcalKPIExp(rowData.ID);
				}else{
					$('#kpinforTab').tabs('disableTab', "计算指标配置");
					$('#kpinforTab').tabs('enableTab', "指标任务");
					kpiTaskGridObj.load({ClassName:"web.DHCWL.V1.KPI.KPIFunction",QueryName:"GetKPITaskQuery",kpiId:rowData.ID});  //重新加载指标任务
				}
			}
		},
		
		onLoadSuccess:function(data){
			if (CHAGE_KPI_CODE != ""){
				var rows,len,kpiCode,chageFlag = 0;
				rows = data.rows;
				len = rows.length;
				for (var i = 0;i < len;i++){   //遍历加载的当前页，如果找到需改指标就选中
					if (rows[i].kpiCode == CHAGE_KPI_CODE){
						$("#KPIGrid").datagrid('selectRow',i);
						CHAGE_KPI_CODE = "";
						chageFlag = 1;
						break;
					}
				}
				if(chageFlag != 1){
					clearAllKPIInfor();
				}
			}
		}
	})
	
	
	/*--如果是计算指标获取计算指标规则和汇总维度--*/
	function getcalKPIExp(kpiID){
		$.m({
			ClassName:'web.DHCWL.V1.KPI.KPIFunction',
			MethodName:'GetCalKPIConfig',
			kpiID:kpiID
		},function(txtData){
			var calKPIConfig,calKPIRule,calKPISumDim
			calKPIConfig = txtData.split("|");
			calKPIRule = calKPIConfig[0];
			calKPISumDim = calKPIConfig[1];
			$("#calRule").val(calKPIRule);
			$("#sumDim").val(calKPISumDim);
		});
	}
	/*--指标类型下拉框数据获取--*/
	var kpiTypeObj = $HUI.combobox("#kpiType",{
		url:$URL+"?ClassName=web.DHCWL.V1.KPI.KPIFunction&QueryName=GetKPITypeQuery&ResultSetType=array",
		valueField:'typeCode',
		textField:'typeName'
	});
	
	/*--指标区间下拉框数据获取--*/
	var kpiTypeObj = $HUI.combobox("#kpiSection",{
		url:$URL+"?ClassName=web.DHCWL.V1.KPI.KPIFunction&QueryName=GetKPISectionQuery&ResultSetType=array",
		valueField:'secCode',
		textField:'secName'
	});
	
	loadKPIMea();
	
	/*--清屏--*/
	$("#clearAllButton").click(function(){
		clearAllKPIInfor();
	})
	
	/*--指标查询查询--*/
	/*$("#kpiSearchButton").click(function(){
		
		var kpiCode,kpiName,kpiMea,kpiExeCode,dataNode,kpiGlobal,kpiCreator,kpiUpdate,kpiDesc,kpiType,kpiSection,kpiValueType,kpiRemark;
		kpiCode = $("#kpiCode").val();
		kpiName = $("#kpiName").val();
		kpiMea = $('#kpiMeasure').combogrid('getText');
		kpiExeCode = $("#exeCode").val();
		dataNode = $("#dataNode").val();
		kpiCreator = $("#creator").val();
		kpiUpdate = $("#kpiUpdate").datebox("getValue");
		kpiUpdate = "";
		kpiDesc = $("#kpiDesc").val();
		kpiType = $("#kpiType").combobox("getText");
		kpiSection = $("#kpiSection").combobox("getText");
		kpiValueType = $("#kpiValueType").combobox("getValue");
		if(kpiValueType == "普通指标"){
			kpiValueType = 1;
		}
		if (kpiValueType == "计算指标"){
			kpiValueType = 2;
		}
		//--获取指标维度表格维度编码信息
		var rows = $("#kpiDimGrid").datagrid("getRows");
		var kpiDimCodes=""
		for (var i = rows.length-1;i >= 0;i--) {
			//alert(rows[i].ID);
			if (kpiDimCodes == ""){
				kpiDimCodes = rows[i].MKPIDimDimDr;
			}else{
				kpiDimCodes = kpiDimCodes+","+rows[i].MKPIDimDimDr;
			}
		}
		KPIGridObj.load({ClassName:"web.DHCWL.V1.KPI.KPIFunction",QueryName:"GetKPIListQuery",kpiCode:kpiCode, kpiName:kpiName, kpiDesc:kpiDesc, kpiExcode:kpiExeCode, createUser:kpiCreator, filterMea:kpiMea, dataNode:dataNode, getValueType:kpiValueType, dimType:kpiDimCodes, category:kpiType, section:kpiSection});  //重新加载指标信息
	})*/
	
	
	/*--指标信息保存--*/
	$("#saveKPIInfor").click(function(){
		if (!$("#kpiCode").validatebox("isValid")){
			myMsg("编码只能是数字和字母的组合");
			return;
		}
		var row = $("#KPIGrid").datagrid('getSelected');
		if (!row){
			myMsg("请先选择需要保存的指标");
			return;
		}
		var preKpiCode = row.kpiCode;
		var _operType = "";
		if (preKpiCode == ""){
			_operType = "add";
		}else{
			_operType = "mod";
		}
		var rows = $("#kpiTaskGrid").datagrid("getRows");
		if (rows){
			for (var i=0;i < rows.length;i++){
				$('#kpiTaskGrid').datagrid('endEdit', i);
			}
		}
		//指标基本信息获取
		var kpiCode,kpiName,kpiMea,kpiExeCode,dataNode,kpiGlobal,kpiCreator,kpiUpdate,kpiDesc,kpiType,kpiSection,kpiValueType,kpiRemark;
		kpiCode = $("#kpiCode").val();
		kpiName = $("#kpiName").val();
		if((kpiCode == "")||(kpiName == "")){
			myMsg("指标编码和指标名称为必填项,请检查输入");
			return;
		}
		kpiExeCode = $("#exeCode").val();
		dataNode = $("#dataNode").val();
		kpiCreator = $("#creator").val();
		kpiUpdate = $("#kpiUpdate").datebox("getValues");
		kpiDesc = $("#kpiDesc").val();
		kpiType = $("#kpiType").combobox("getText");
		kpiSection = $("#kpiSection").combobox("getText");
		kpiValueType = $("#kpiValueType").combobox("getValue");
		kpiRemark = $("#kpiRemark").val();
		kpiGlobal = $HUI.checkbox("#kpiGlobal").getValue();
		if (kpiGlobal){
			kpiGlobal = "Y";
		}else{
			kpiGlobal = "N";
		}
		
		var meaGrid,meaRow,meaLen,meaIDs = "";
		meaGrid = $('#kpiMeasure').combogrid('grid');	
		meaRow = meaGrid.datagrid('getSelections');
		meaLen = meaRow.length;
		for (var i = 0;i < meaLen;i++){
			if (meaIDs == ""){
				meaIDs = meaRow[i].ID;
			}else{
				meaIDs = meaIDs + "||" + meaRow[i].ID;
			}
		}
		
		if ((kpiRemark.indexOf("@") != -1) || (kpiDesc.indexOf("@") != -1) || (kpiName.indexOf("@") != -1)) {
			myMsg("提示","符号@已被占用,请不要使用");
			return;
		}
		var baseInfor = kpiCode+"@"+kpiName+"@"+kpiMea+"@"+kpiExeCode+"@"+dataNode+"@"+kpiGlobal+"@"+kpiCreator+"@"+kpiUpdate+"@"+kpiDesc+"@"+kpiType+"@"+kpiSection+"@"+kpiValueType+"@"+kpiRemark;
		
		//指标基础维度获取
		var kpiDimInfor = "";errorFlag = "",deliValue = "";
		var rows = $("#kpiDimGrid").datagrid("getRows");
		if (rows) {
			for (var i = 0;i < rows.length;i++) {
				deliValue = rows[i].MKPIDimDeli;
				if (deliValue.indexOf("@") != -1){
					myMsg("符号@已被占用,请不要使用");
					return;
				}
				if (kpiDimInfor == "") {
					kpiDimInfor = rows[i].MKPIDimCode + "||" + rows[i].MKPIDimOrder + "||" + rows[i].MKPIDimDeli;
				} else {
					kpiDimInfor = kpiDimInfor + "@" +  rows[i].MKPIDimCode + "||" + rows[i].MKPIDimOrder + "||" + rows[i].MKPIDimDeli;
				}
			}
		}
		//alert(kpiDimInfor);
		//指标任务获取
		var kpiTaskInfor = "" , calExp = "" , calRule , sumDim;
		if ((kpiValueType == 2)||(kpiValueType == "计算指标")){
			calRule = $("#calRule").val();
			sumDim = $("#sumDim").val();
			calExp = calRule + "|" + sumDim;
		}else{
			var rows = $("#kpiTaskGrid").datagrid("getRows"),infor = "";
			if (rows) {
				var activeFlag = "";
				for (var i = 0;i < rows.length;i++){
					activeFlag = rows[i].DTaskActiveFlag;
					if (activeFlag != "Y"){
						activeFlag = (activeFlag == "是" ? "Y" : "N");
					}
					infor = rows[i].SecCode + "||" + rows[i].DTaskExcuteCode + "||" + activeFlag;
					if (kpiTaskInfor == ""){
						kpiTaskInfor = infor;
					}else {
						kpiTaskInfor = kpiTaskInfor + "@" +infor;
					}
				}
			}
		}
		
		$.m({
			ClassName : "web.DHCWL.V1.KPI.KPIFunction",
			MethodName : "SaveKPI",
			baseInfor : baseInfor,
			dimInfors : kpiDimInfor,
			taskInfors : kpiTaskInfor,
			calExp : calExp,
			meaInfor : meaIDs,
			operType : _operType
		},function(data){
			if (data == "ok") {
				data = "操作成功";
				myMsg(data);
				CHAGE_KPI_CODE = kpiCode;
				KPIGridObj.reload();  //重新加载指标信息
				//clearAllKPIInfor();
			}else {
				myMsg(data);
			}
		});
	})
	
	/*--根据选中指标和文本框填入的指标编码--*/
	function getKPISaveTip(preCode,curCode){
		if ((preCode != "")&&(preCode != curCode)){
			return "将复制指标" + preCode + "生成一条新指标,是否确定？"
		}
		
	}
	
	/*--维度角色查询--*/
	$("#searchText").searchbox({
		searcher:function(value,name){
			kpiDimSelectorObj.load({ClassName:'web.DHCWL.V1.KPI.KPIFunction',QueryName:'GetAllDimRoleQuery',filterCode:value});
		}
	});
	
	/*--图片提示--*/
	var rightTipObj=$HUI.tooltip('#moveup',{
		content:'<span>移入</span>',
		position:'bottom'
	})
	var leftTipObj=$HUI.tooltip('#movedown',{
		content:'<span">移出</span>',
		position:'bottom'
	})
	/*--点击移入移出后的反应--*/
	$("#moveup").click(function(){
		var dimRoleObj = $("#dimRoleSelectObj").datagrid("getSelected");
		if (!dimRoleObj){
			return;
		}
		var code,name,dimCode,dimName;
		code = dimRoleObj.dimRoleCode;
		name = dimRoleObj.dimRoleName;
		dimCode = dimRoleObj.dimCode;
		dimName = dimRoleObj.dimName;
		var selectedRows = $("#selectedKPIDimObj").datagrid("getRows");
		var selectedLen = selectedRows.length;
		if (selectedLen > 0){
			for (var i = 0;i < selectedLen; i++){
				if (code == selectedRows[i].MKPIDimCode){
					myMsg("已存在,请重新选择");
					return;
				}
			}
		}
		/*--var index = $("#dimRoleSelectObj").datagrid("getRowIndex",dimRoleObj);
		$("#dimRoleSelectObj").datagrid("deleteRow",index);--*/
		$("#selectedKPIDimObj").datagrid("insertRow",{
			row:{
				MKPIDimCode : code,
				MKPIDimDimDr : name,
				KDT_Code : dimCode,
				KDT_Name : dimName
			}
		});
	});
	
	/*--移出指标维度--*/
	$("#movedown").click(function(){
		var row = $("#selectedKPIDimObj").datagrid("getSelected");
		if(!row) {
			return;
		}
		var index = $("#selectedKPIDimObj").datagrid("getRowIndex",row);
		$("#selectedKPIDimObj").datagrid("deleteRow",index);
	});
	function initPopover(){
		var settings = {
			trigger:'click',
			title:'',
			content:'<p>This is webui popover demo.</p><p>just enjoy it and have fun !</p>',
			width:350,						
			multi:true,						
			closeable:false,
			style:'',
			padding:true
		};
		var kpiRuleSettings = {
			width : 760,
			height:163,
			placement:'auto-bottom',
			closeable:false,
			padding:false,
			type:'iframe',
			url:'dhcwlredirect.csp?url=dhcwl/v1/kpi/kpi/configsimplekpisearch.csp'
		}
		$('#kpiRuleShowImage').webuiPopover('destroy').webuiPopover($.extend({},settings,kpiRuleSettings));
	}
	initPopover();
	
	$("#kpiRuleShowImage").click(function(e){
		$('#kpiSearchKPIInfor').searchbox('setValue', '');
	})
	 /*--指标数据检索--*/
	 $('#kpiSearchKPIInfor').searchbox({
		searcher:function(value,name){
			KPIGridObj.load({ClassName:"web.DHCWL.V1.KPI.KPIFunction",QueryName:"GetKPIListQuery",filterValue:value});  //重新加载指标信息
		}
	});
	$("#kpiUpdate").datebox('setValue',myformatter());
};
$(init);

/*--指标新增--*/
$("#kpiAddButton").click(function(e){
	var date = myformatter();
	$('#KPIGrid').datagrid('insertRow',{
		index: 0,
		row: {
			ID: '',
			kpiCode: '',
			kpiName: '',
			updateDate:date,
			section:"日",
			getValueType:'普通指标'
		}
	});
	$("#KPIGrid").datagrid('selectRow',0);
	clearAllKPIInfor();
})
/*--指标删除--*/
$("#kpiDeleteButton").click(function(e){
	if(deleteKey == 0){
		var passWord = getPassWord() + 10;
		$.messager.prompt("提示", "为保障系统安全,请先输入密码验证:", function (r) {
			if (r) {
				
				if (r == passWord){
					//deleteTaskDetail();
					$.messager.popover({msg: '验证成功,请再次操作~',type:'success',timeout: 1000});
					deleteKey = 1;
				}else{
					myMsg("密码输入有误~");
					return;
				}
			} else {
				if (r != undefined){
					$.messager.popover({msg: '请输入有效密码！',type:'info',timeout: 2000,showType: 'show'});
				}
			}
		});
	}else{
		$.messager.confirm("提示", "删除后将不能恢复,确认删除??", function (r) {
			if (r) {
				
				$.messager.confirm("提示", "删除指标时，会删除【勾选】的指标及指标的所有指标维度、模块与报表中数据集的配置，确定要删除？", function (r) {
					if (r) {
						var rowData = $("#KPIGrid").datagrid("getSelected");
						if (!rowData){
							myMsg("请先选择一条修改的指标");
							return;
						}
						var kpiID = rowData.ID;
						if (!kpiID){
							myMsg("获取指标失败");
							return;
						}
						$m({
							ClassName:'web.DHCWL.V1.KPI.KPIFunction',
							MethodName:'DeleteKPI',
							ids:kpiID
						},function(e){
							myMsg(e);
							//KPIGridObj.reload();  //重新加载指标信息
							$("#KPIGrid").datagrid("reload");
							clearAllKPIInfor();
						})
					} 
				});
				
			}
		});
	}
})

/*--加载度量下拉框--*/
function loadKPIMea()
{
	/*--指标度量下拉框数据加载--*/
	var measureObj = $HUI.combogrid("#kpiMeasure",{
		url:$URL+"?ClassName=web.DHCWL.V1.StandCfg.MeasureCfg" + "&QueryName=GetMeasure",
		mode:'remote',
		delay:200,
		multiple:true,
		idField:'ID',
		textField:'value',
		onBeforeLoad:function(param){
			param.filterValue = param.q;
		},
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'name',title:'编码',width:100},
			{field:'value',title:'名称',width:80},
			{field:'statDate',title:'统计口径',width:100},
			{field:'statItem',title:'统计项',width:100}
		]],
		fitColumns:true
	});
}


/*--指标取数下拉框的监听时间--*/
function valueTypeHandler(rec){
	var value = rec.value;
	$('#kpinforTab').tabs('select', "指标维度");
	if (value == 1){
		$('#kpinforTab').tabs('disableTab', "计算指标配置");
		$('#kpinforTab').tabs('enableTab', "指标任务");
	}else{
		$('#kpinforTab').tabs('disableTab', "指标任务");
		$('#kpinforTab').tabs('enableTab', "计算指标配置");
	}
}

/*--清屏--*/
function clearAllKPIInfor(){
	$("#kpiCode").val("");
	$("#kpiName").val("");
	$('#kpiMeasure').combogrid('setValue', '');
	$("#exeCode").val("");
	$("#dataNode").val("");
	$HUI.checkbox("#kpiGlobal").setValue(true);
	$("#creator").val("");
	$("#kpiUpdate").datebox('setValue',myformatter());
	$("#kpiDesc").val("");
	$("#kpiType").combobox('setValue',"");
	$("#kpiSection").combobox('setValue',"D");
	$("#kpiValueType").combobox('setValue',"1");
	$("#kpiRemark").val("");
	$("#calRule").val("");
	$("#sumDim").val("");
	$('#kpinforTab').tabs('disableTab', "计算指标配置");
	$('#kpinforTab').tabs('enableTab', "指标任务");
	
	//--清除指标维度表格信息
	var rows = $("#kpiDimGrid").datagrid('getRows');
	for(var i=rows.length-1;i>=0;i--){
		$("#kpiDimGrid").datagrid('deleteRow',i);
	}
	
	//--清空指标任务表格信息
	var rows=$("#kpiTaskGrid").datagrid('getRows');
	for(var i=rows.length-1;i>=0;i--){
		$("#kpiTaskGrid").datagrid('deleteRow',i);
	}
	$('#kpinforTab').tabs('select', "指标维度");
}

/*--获取当前时间--*/
function myformatter(){
	var date = new Date();  
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}

$(function(){ 
　　$("#kpinforTab").tabs({ 
　　　　height:$("#kpinforTab").parent().height() 
　　}); 
}); 
