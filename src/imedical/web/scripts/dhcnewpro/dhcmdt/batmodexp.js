//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2020-04-08
// 描述:	   批量修改专家
//===========================================================================================
var editIndex = -1;   /// 编辑行
var isEditFlag = 0;     /// 页面是否可编辑
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
/// 页面初始化函数
function initPageDefault(){
	
	/// 初始化组件
	InitComponent();
	
	/// 初始化明细列表
	InitDetList();
	
	/// 初始化专家列表
	InitDocList();
	
	multi_Language();         /// 多语言支持
}

/// 初始化组件
function InitComponent(){
	
	/// 开始日期
	$HUI.datebox("#StartDate").setValue(GetCurSystemDate(-7));
	
	/// 结束日期
	$HUI.datebox("#EndDate").setValue(GetCurSystemDate(0));
	
	/// 疑难病种
	$HUI.combobox("#mdtDisGrp",{
		url:$URL+"?ClassName=web.DHCMDTGroup&MethodName=jsonGroupAll&HospID="+LgHospID,
		valueField:'value',
		textField:'text',
		onSelect:function(option){

	    }	
	})
}

/// 初始化明细列表
function InitDetList(){
	
	///  定义columns
	var columns=[[
		{field:'DisGrpID',title:'DisGrpID',width:100,hidden:true},
		{field:'DisGroup',title:'疑难病种',width:140},
		{field:'PreTime',title:'预约时间',width:180},
		{field:'PatName',title:'姓名',width:100},
		{field:'PatNo',title:'病人ID',width:100},
		{field:'PayMony',title:'收费状态',width:80,formatter:
			function (value, row, index){
				if (value == "未收费"){return '<font style="color:red;font-weight:bold;">'+value+'</font>'}
				else {return '<font style="color:green;font-weight:bold;">'+value+'</font>'}
			}
		},
		{field:'CstStatus',title:'会诊状态',width:80,formatter:
			function (value, row, index){
				if (value == "撤销"){return '<font style="color:red;font-weight:bold;">'+value+'</font>'}
				else {return '<font style="color:green;font-weight:bold;">'+value+'</font>'}
			}
		},
		{field:'PatLoc',title:'就诊科室',width:120},
		{field:'PatDiag',title:'诊断',width:140},
		{field:'CstRLoc',title:'申请科室',width:120},
		{field:'CstRUser',title:'申请医师',width:100},
		{field:'CstRTime',title:'申请时间',width:160},
		{field:'CstLocArr',title:'参加会诊科室',width:220},
		{field:'CstPrvArr',title:'参加会诊医师',width:220},
		{field:'CstPurpose',title:'会诊理由及要求',width:400},
		{field:'CstNPlace',title:'会诊地点',width:200},
		{field:'ID',title:'ID',width:100}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		rownumbers : true,
		singleSelect : false,
		pagination: true,
		onLoadSuccess:function(data){

		},
		onClickRow: function (rowIndex, rowData) {
			var rows = $("#bmDetList").datagrid('getSelections');
			var TmpArr = [];
			for(var i = 0; i < rows.length; i++){
				TmpArr.push(rows[i].ID);
			}
			$("#bmDocList").datagrid('reload',{mdtIDs:TmpArr.join("^")});
        }
	};
	/// 就诊类型
	var param = "^^^"+ LgHospID;
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsGetBatModExpQry&Params="+param;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// 初始化专家列表
function InitDocList(){
	
	/// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	// 职称编辑格
	var PrvTpEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonPrvTp",
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			blurValidValue:true,
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				if ($(ed.target).val() == ""){
					var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
					$(ed.target).combobox('setValue', "");
					$.messager.alert("提示","请先确定专家科室！","warning");
					return;
				}
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', option.text);

				///设置级联指针
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val();
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
			},
			onChange:function(newValue, oldValue){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				if (newValue == ""){
					var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
					$(ed.target).val("");
				}
			}
		}
	}
	
	// 科室编辑格
	var LocEditor={
		type: 'combobox',//设置编辑格式
		options:{
			valueField: "value", 
			textField: "text",
			mode:'remote',
			enterNullValueClear:false,
			url: $URL +"?ClassName=web.DHCMDTCom&MethodName=JsonLoc&HospID"+session['LOGON.HOSPID'],
			blurValidValue:true,
			onSelect:function(option) {
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				$(ed.target).val(option.value);
				
				///清空医生
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val("");
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
				/// 清空职称
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				$(ed.target).val("");
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', "");
				
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'LocDesc'});
				var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLoc&HospID="+LgHospID;
				$(ed.target).combobox('reload',unitUrl);
			}		   
		}
	}
		
	// 医师编辑格
	var DocEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			blurValidValue:true,
			mode:'remote',
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val(option.value);
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', option.text);

				$m({
					ClassName:"web.DHCMDTCom",
					MethodName:"GetPrvTpIDByCareProvID",
					CareProvID:option.value
				},function(txtData){
					var ctpcpCtInfo = txtData;
					var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
					$(ed.target).combobox('setValue', ctpcpCtInfo.split("^")[1]);
					var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
					$(ed.target).val(ctpcpCtInfo.split("^")[0]);
				});
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
			    
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				var LocID = $(ed.target).val();
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				var PrvTpID = $(ed.target).val();
				///设置级联指针
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocCareProv&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&DisGrpID=";
				$(ed.target).combobox('reload',unitUrl);
			
			},
			onChange:function(newValue, oldValue){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				if (newValue == ""){
					var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
					$(ed.target).val("");
				}
			}
		}
	}
	
	///  定义columns
     var columns=[[
		{field:'ID',title:'ID',width:100,align:'center',hidden:true},
		{field:'LocID',title:'科室ID',width:100,align:'center',hidden:true,editor:texteditor},
		{field:'LocDesc',title:'科室',width:280,editor:LocEditor},
		{field:'UserID',title:'医生ID',width:110,align:'center',hidden:true,editor:texteditor},
		{field:'UserName',title:'医生',width:120,align:'center',editor:DocEditor},
		{field:'PrvTpID',title:'职称ID',width:100,align:'center',hidden:true,editor:texteditor},
		{field:'PrvTp',title:'职称',width:160,align:'center',hidden:false,editor:PrvTpEditor}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		fit:true,
		fitColumns:false,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
	    onDblClickRow: function (rowIndex, rowData) {
			
			if (rowData.ID != "") return;
			if ((editIndex != -1)||(editIndex == 0)) { 
                $("#bmDocList").datagrid('endEdit', editIndex); 
            }
            
            $("#bmDocList").datagrid('beginEdit', rowIndex); 
			
            editIndex = rowIndex;          
        }
	};
	/// 就诊类型
	
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsGetBatModExpDet";
	new ListComponent('bmDocList', columns, uniturl, option).Init();
}

/// 删除操作
function delRow(){
	
	/// 结束编辑
	if ((editIndex != -1)||(editIndex == 0)) { 
        $("#bmDocList").datagrid('endEdit', editIndex); 
    }
    
	var rowData = $('#bmDocList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示','请先选择待删除！','warning');
		return;
	}
	var mCareProvID = rowData.UserID;
	
	/// 待处理会诊列表
	var rows = $("#bmDetList").datagrid('getSelections');
	var TmpArr = [];
	for(var i = 0; i < rows.length; i++){
		TmpArr.push(rows[i].ID);
	}
	var mdtIds = TmpArr.join("^"); /// 会诊ID列表 
	
	var IsPermitMsg = "";
	if (memControlFlag == 1) IsPermitMsg = GetIsPermitDel(mdtIds, mCareProvID); /// 是否允许删除
	if (IsPermitMsg != ""){
		$.messager.confirm('确认对话框','删除该专家后，患者'+ IsPermitMsg +'的会诊参与专家少于3人，是否继续！', function(r){
			if (r){
				delCareProv(mdtIds, mCareProvID);  /// 删除专家
			}
		});
	}else{
		delCareProv(mdtIds, mCareProvID);  /// 删除专家
	}
}

/// 删除专家
function delCareProv(mdtIds, mCareProvID){
	
	/// 保存
	runClassMethod("web.DHCMDTConsult","RevCsCareProv",{"mdtIds":mdtIds, "mCareProvID":mCareProvID},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示","删除失败，失败原因:"+jsonString,"warning");
		}else{
			$('#bmDocList').datagrid("reload");
		}
	},'',false)
}

/// 插入空行
function insRow(){
	
	if (isEditFlag == 1) return;
	
	var rows = $("#bmDetList").datagrid('getSelections');
	if (rows.length == 0){
		$.messager.alert("提示","请先选择待修改会诊记录！","warning");
		return;
	}
			
    var rowObj={ID:'', PrvTpID:'', PrvTp:'', LocID:'', LocDesc:'', UserID:'', UserName:'', TelPhone:''};
	$("#bmDocList").datagrid('appendRow',rowObj);
}

/// 保存行
function saveRow(){
	
	/// 结束编辑
	if ((editIndex != -1)||(editIndex == 0)) { 
        $("#bmDocList").datagrid('endEdit', editIndex); 
    }

	/// 人员重复检查
	var TmpCarePrv = ""; /// 专家
	var CarePrvArr = [];
	var rowData = $('#bmDocList').datagrid('getRows');
	for (var i = 0; i < rowData.length; i++){
		var item = rowData[i];
		if(trim(item.LocDesc) != ""){
			/// 人员重复检查
			if ($.inArray(item.UserID, CarePrvArr) != -1){
				TmpCarePrv = item.UserName;
			}
			CarePrvArr.push(item.UserID);
		}
	}
	if (TmpCarePrv != ""){
		$.messager.alert("提示:","会诊专家："+ TmpCarePrv +"，重复添加！","warning");
		return;	
	}
	
	var LocArr=[]; isEmptyFlag=0;
	var rowData = $('#bmDocList').datagrid('getChanges');
	for (var m = 0; m < rowData.length; m++){
		var item = rowData[m];
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^";
		    LocArr.push(TmpData);
		}
		if (item.UserID == "") isEmptyFlag = 1;
	}
	
	if (isEmptyFlag == 1){
		$.messager.alert("提示","专家不能为空！","warning");
		return;	
	}

	/// 科室
	var mLocParams = LocArr.join("@");
	if (mLocParams == ""){
		$.messager.alert("提示","未检查到待增加记录！","warning");
		return;	
	}
	
	/// 待处理会诊列表
	var rows = $("#bmDetList").datagrid('getSelections');
	var TmpArr = [];
	for(var i = 0; i < rows.length; i++){
		TmpArr.push(rows[i].ID);
	}
	var mdtIds = TmpArr.join("^"); /// 会诊ID列表 	

	/// 保存
	runClassMethod("web.DHCMDTConsult","InsLocParams",{"mdtIds":mdtIds, "mLocParams":mLocParams},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示","保存失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示","保存成功！","success",function(){
				$("#bmDocList").datagrid('reload');
			});
		}
	},'',false)
}

/// 查询
function find_click(){
	
	$("#bmDocList").datagrid('reload',{mdtIDs:""}); /// 清空
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// 开始日期
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// 结束日期
	var mDisGrpID = $HUI.combobox("#mdtDisGrp").getValue()||"";  /// 疑难病种
	var params = StartDate +"^"+ EndDate +"^"+ mDisGrpID +"^"+ LgHospID;
	$("#bmDetList").datagrid("load",{"Params":params});
}

/// 获取系统当前日期
function GetCurSystemDate(offset){
	
	var SysDate = "";
	runClassMethod("web.DHCMDTCom","GetCurSysTime",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate
}

/// 是否允许删除会诊专家
function GetIsPermitDel(mdtIds, mCareProvID){

	var IsPermitDel = "";
	/// 验证病人是否允许开医嘱
	runClassMethod("web.DHCMDTConsult","IsPermitDel",{"mdtIds":mdtIds, "mCareProvID":mCareProvID},function(jsonString){

		if (jsonString != ""){
			IsPermitDel = jsonString;
		}
	},'',false)

	return IsPermitDel;
}

/// 多语言支持
function multi_Language(){
	
	$g("提示");
	$g("请先选择一条待处理记录!");
	$g("请先确定专家科室！")
	$g("请先选择待删除！")
	$g("删除失败，失败原因:")
	$g("请先选择待修改会诊记录！")
	$g("专家不能为空！")
	$g("未检查到待增加记录！")
	$g("保存失败，失败原因:")
	$g("保存成功！")
	$g("确认对话框")
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })