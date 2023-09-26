/**
 * @Title:院区配置
 * @Author: 汪凯-DHCWL
 * @Description:院区配置维护界面
 * @Created on 2018-01-10
 */
var init = function(){
	$(function(){
		$("#kpiTaskTableRow").hide();
		$("#calTaskRow").hide();
	});
	$("#chageTaskAndDim").click(function(e){
		var value=$("#kpiValueType").combobox("getValue");
		if(e.target.innerText=="下一步"){
			$("#chageTaskAndDim .l-btn-text")[0].innerText="上一步";
			if ((value == "2")||(value == "计算指标")){
				$("#kpiDimTableRow").hide();
				$("#calTaskRow").show();
				$("#kpiTaskTableRow").hide();
			}else{
				//$("#kpiDimGridDiv").hide();
				//$("#calKPIConfigDiv").hide();
				//$("#kpiTaskGridDiv").show();
				$("#kpiDimTableRow").hide();
				$("#kpiTaskTableRow").show();
				$("#calTaskRow").hide();
				$("#kpiTaskGrid").datagrid("resize");
			}
		}else{
			$("#chageTaskAndDim .l-btn-text")[0].innerText="下一步";
			//$("#kpiDimGridDiv").show();
			//$("#kpiTaskGridDiv").hide();
			//$("#calKPIConfigDiv").hide();
			$("#kpiDimTableRow").show();
			$("#kpiTaskTableRow").hide();
			$("#calTaskRow").hide();
			$("#kpiDimGrid").datagrid("resize");
			
		}
	});
	
	/*--指标维度维护表格--*/
	var kpiDimGridObj=$HUI.datagrid("#kpiDimGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.KPI.KPIFunction",  //调用方法或query的路径
			QueryName:"GetKPIDimQuery"  //调用query名
		},
		/*columns:[[
			{field:'ID',title:'任务区间ID',width:80,hidden:true},
			{field:'MKPIDimCode',title:'指标维度编码',width:140},
			{field:'MKPIDimDimDr',title:'指标维度描述',width:150},
			{field:'KDT_Code',title:'关联维度编码',width:150,hidden:true},
			{field:'KDT_Name',title:'关联维度名称',width:150},
			{field:'MKPIDimOrder',title:'顺序',width:60},
			{field:'MKPIDimDeli',title:'分隔符',width:60},
		]],*/
		pagination:false,
		//striped:true,
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
			iconCls:'icon-reset',
			text:'配置指标维度',
			handler:function(){
				$("#kpiDimDig").show();
				var kpiDimObj = $HUI.dialog("#kpiDimDig",{
					resizable:true,
					modal:true,
					iconCls:'icon-w-config'
				});
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
				//kpiDimSelectoredObj.load({ClassName:'web.DHCWL.V1.KPI.KPIFunction',QueryName:'GetKPIDimQuery',kpiID:rowID});
				
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
			iconCls:'icon-add',
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
		}/*,'-',{
			iconCls:'icon-cancel',
			text:'还原',
			handler:function(){
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
		}*/,{
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
			
			//alert(selExeCode);
		}
	})
	
	var flagList = [
            {flagValue:'Y',flagName:'Y'},
            {flagValue:'N',flagName:'N'}
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
		 	{field:'DTaskActiveFlag',title:'是否激活',width:80,editor:{type:'combobox',options:{valueField:'flagValue',textField:'flagName',data:flagList,required:true}}}
		 ]],
		//pagination:false,
		//striped:true,
		//pageSize:15,
		//pageList:[5,10,20,50,100],
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
					resizable:true,
					mode:true
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
						$("#kpiTaskGrid").datagrid("insertRow",{
							row:{
								SecCode:jsonData.code,
								SecName:jsonData.desc,
								DTaskExcuteCode:jsonData.exeCode,
								DTaskActiveFlag:jsonData.flag
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
					if (rows[i]["DTaskActiveFlag"] != "Y") {
						rows[i]["DTaskActiveFlag"]="Y";
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
		//striped:true,  //表格斑马线状态
		fitColumns:true,
		pageSize:15,  //当前页每页条数
	    pageList:[5,10,15,20,50,100],  //每页可以选中的显示条数
		onSelect:function(rowIndex,rowData){  //响应行选中事件
			if (rowIndex>-1){
				$("#kpiCode").val(rowData.kpiCode);
				$("#kpiName").val(rowData.kpiName);
				$("#kpiMeasure").val(rowData.measure);
				$("#exeCode").val(rowData.kpiExcode);
				$("#dataNode").val(rowData.dataNode);
				$("#creator").val(rowData.createUser);
				$("#kpiUpdate").datebox('setValue', rowData.updateDate);
				$("#kpiDesc").val(rowData.kpiDesc);
				$("#kpiType").combobox('setValue',rowData.category);
				$("#kpiSection").combobox('setValue',rowData.section);
				$("#kpiValueType").combobox('setValue',rowData.getValueType);
				$("#kpiRemark").val(rowData.nodeMark);
				if($("#chageTaskAndDim .l-btn-text")[0].innerText == "上一步"){
					$("#chageTaskAndDim .l-btn-text")[0].innerText="下一步";  //默认显示维度界面
					/*$("#kpiDimGridDiv").show();
					$("#kpiTaskGridDiv").hide();
					$("#calKPIConfigDiv").hide();*/
					$("#kpiDimTableRow").show();
					$("#kpiTaskTableRow").hide();
					$("#calTaskRow").hide();
				}
				
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
					getcalKPIExp(rowData.ID);
				}else{
					kpiTaskGridObj.load({ClassName:"web.DHCWL.V1.KPI.KPIFunction",QueryName:"GetKPITaskQuery",kpiId:rowData.ID});  //重新加载指标任务
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
	
	/*--清屏--*/
	$("#clearAllButton").click(function(){
		//--清除表单信息
		$("#kpiCode").val("");
		$("#kpiName").val("");
		$("#kpiMeasure").val("");
		$("#exeCode").val("");
		$("#dataNode").val("");
		$HUI.checkbox("#kpiGlobal").setValue(false);
		$("#creator").val("");
		$("#kpiUpdate").datebox('setValue', "");
		$("#kpiDesc").val("");
		$("#kpiType").combobox('setValue',"");
		$("#kpiSection").combobox('setValue',"");
		$("#kpiValueType").combobox('setValue',"");
		$("#kpiRemark").val("");
		$("#calRule").val("");
		$("#sumDim").val("");
		
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
	})
	
	/*--指标查询查询--*/
	$("#kpiSearchButton").click(function(){
		
		//--获取表单元素值
		var kpiCode,kpiName,kpiMea,kpiExeCode,dataNode,kpiGlobal,kpiCreator,kpiUpdate,kpiDesc,kpiType,kpiSection,kpiValueType,kpiRemark
		kpiCode = $("#kpiCode").val();
		kpiName = $("#kpiName").val();
		kpiMea = $("#kpiMeasure").val();
		kpiExeCode = $("#exeCode").val();
		dataNode = $("#dataNode").val();
		kpiCreator = $("#creator").val();
		kpiUpdate = $("#kpiUpdate").datebox("getValue");
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
		//alert(kpiType);
		//return;
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
		KPIGridObj.load({ClassName:"web.DHCWL.V1.KPI.KPIFunction",QueryName:"GetKPIListQuery",kpiCode:kpiCode, kpiName:kpiName, kpiDesc:kpiDesc, kpiExcode:kpiExeCode, createUser:kpiCreator, updateDate:kpiUpdate, dataNode:dataNode, getValueType:kpiValueType, dimType:kpiDimCodes, category:kpiType, section:kpiSection});  //重新加载指标信息
		//alert(kpiDimCodes);
		//alert(kpiCode+"@"+kpiName+"@"+kpiMea+"@"+kpiExeCode+"@"+dataNode+"@"+kpiGlobal+"@"+kpiCreator+"@"+kpiUpdate+"@"+kpiDesc+"@"+kpiType+"@"+kpiSection+"@"+kpiValueType+"@"+kpiRemark);
	})
	
	
	/*--指标信息保存--*/
	$("#saveKPIInfor").click(function(){
		//指标基本信息获取
		var kpiCode,kpiName,kpiMea,kpiExeCode,dataNode,kpiGlobal,kpiCreator,kpiUpdate,kpiDesc,kpiType,kpiSection,kpiValueType,kpiRemark
		kpiCode = $("#kpiCode").val();
		kpiName = $("#kpiName").val();
		kpiMea = $("#kpiMeasure").val();
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
		if ((kpiRemark.indexOf("@") != -1) || (kpiDesc.indexOf("@") != -1) || (kpiName.indexOf("@") != -1)) {
			$.messager.alert("提示","符号@已被占用,请不要使用");
			return;
		}
		var baseInfor = kpiCode+"@"+kpiName+"@"+kpiMea+"@"+kpiExeCode+"@"+dataNode+"@"+kpiGlobal+"@"+kpiCreator+"@"+kpiUpdate+"@"+kpiDesc+"@"+kpiType+"@"+kpiSection+"@"+kpiValueType+"@"+kpiRemark;
		
		//指标基础维度获取
		var kpiDimInfor = "";
		var rows = $("#kpiDimGrid").datagrid("getRows");
		if (rows) {
			for (var i = 0;i < rows.length;i++) {
				if (kpiDimInfor == "") {
					kpiDimInfor = rows[i].MKPIDimCode + "||" + rows[i].MKPIDimOrder + "||" + rows[i].MKPIDimDeli
				} else {
					kpiDimInfor = kpiDimInfor + "@" +  rows[i].MKPIDimCode + "||" + rows[i].MKPIDimOrder + "||" + rows[i].MKPIDimDeli
				}
			}
		}
		//alert(kpiDimInfor);
		//指标任务获取
		var kpiTaskInfor = "" , calExp = "" , calRule , sumDim;
		if (kpiValueType == 2){
			calRule = $("#calRule").val();
			sumDim = $("#sumDim").val();
			calExp = calRule + "|" + sumDim;
		}else{
			var rows = $("#kpiTaskGrid").datagrid("getRows"),infor = "";
			if (rows) {
				for (var i = 0;i < rows.length;i++){
					infor = rows[i].SecCode + "||" + rows[i].DTaskExcuteCode + "||" + rows[i].DTaskActiveFlag
					if (kpiTaskInfor == ""){
						kpiTaskInfor = infor
					}else {
						kpiTaskInfor = kpiTaskInfor + "@" +infor
					}
				}
			}
		}
		//alert(kpiTaskInfor);
		
		$.m({
			ClassName : "web.DHCWL.V1.KPI.KPIFunction",
			MethodName : "SaveKPI",
			baseInfor : baseInfor,
			dimInfors : kpiDimInfor,
			taskInfors : kpiTaskInfor,
			calExp : calExp
		},function(data){
			if (data == "ok") {
				data = "操作成功";
				$.messager.alert("提示",data);
				KPIGridObj.load({ClassName:"web.DHCWL.V1.KPI.KPIFunction",QueryName:"GetKPIListQuery"});  //重新加载指标信息
			}else {
				$.messager.alert("提示",data);
			}
		});
	})
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
	
};
$(init);


/*--指标取数下拉框的监听时间--*/
function valueTypeHandler(rec){
	if($("#chageTaskAndDim .l-btn-text")[0].innerText == "上一步"){
		$("#chageTaskAndDim .l-btn-text")[0].innerText="下一步";  //默认显示维度界面
		$("#kpiDimTableRow").show();
		$("#kpiTaskTableRow").hide();
		$("#calTaskRow").hide();
	}
}