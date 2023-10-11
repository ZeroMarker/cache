//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2018-08-15
// 描述:	   护士会诊审核
//===========================================================================================

var CstID = "";         /// 会诊申请ID
var editSelRow = -1;
var isEditFlag = 0;     /// 页面是否可编辑
var CstOutFlag = "N";   /// 院际会诊标志
var CsNoType = "";      /// 会诊单据类型 医生/护士/MDT
var LType = "CONSULTWARD";  /// 会诊科室代码
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID

var ItemTypeArr = [{"value":"N","text":'待审'}, {"value":"Y","text":'已审'}];
var del = String.fromCharCode(2);

/// 页面初始化函数
function initPageDefault(){

	/// 初始化加载病人就诊ID
	InitPatEpisodeID();

	/// 初始化病人基本信息
	InitPatInfoPanel();
	
	/// 初始化页面基础配置
	InitPageBaseSet();
	
	/// 初始化加载病人列表
	InitPatList();
	
}

/// 初始化页面基础配置 bianshuai 2019-09-18
function InitPageBaseSet(){

	/// 医务管理
	if (LgGroupID == "68"){
		$("#audit").linkbutton('disable');   /// 审核
		$("#reback").linkbutton('disable');  /// 驳回
	}
	
	/// 医务管理/护士长
	if (((LgGroupID != "68")&(CsNoType == ""))||((LgGroupID == "25")&(CsNoType == "Nur"))){
		$HUI.combobox("#CstRLoc").setValue(LgLocID);   /// 请会诊科室 默认登录科室 bianshuai 2019-09-16
		$HUI.combobox("#CstRLoc").disable();
	}
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	
	CsNoType = getParam("CsType");  /// 会诊单据类型
	if (CsNoType == "Nur"){
		LType = "CONSULTWARD";      /// 会诊科室代码
	}
}

/// 初始化病人基本信息
function InitPatInfoPanel(){
	
	/// 开始日期
	$HUI.datebox("#StartDate").setValue(GetCurSystemDate(-1));
	/// 结束日期
	$HUI.datebox("#EndDate").setValue(GetCurSystemDate(0));
	
	/// 会诊日期
	$('#CstNDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date(new Date()-24*60*60*1000);
			return date>now;
		}
	});
	
	/// 请会诊科室
	$HUI.combobox("#CstRLoc",{
		url:$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+LgHospID,
		valueField:'value',
		textField:'text',
		mode:'remote',
		onSelect:function(option){
	        //QryEmPatList();
	    }	
	})
	
	/// 会诊类型
	$HUI.combobox("#CstType",{
		url:$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonCstType&HospID=" + LgHospID +"&LgUserID="+LgUserID,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        //QryEmPatList();
	    }	
	})
	
	/// 审核状态
	$HUI.combobox("#AuditFlag",{
		url:'',
		data : ItemTypeArr,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        //QryEmPatList();
	    }	
	})
	$HUI.combobox("#AuditFlag").setValue("N");
	
	/// 登记号
	$("#PatNo").bind('keypress',PatNo_KeyPress);
	
}

/// 页面DataGrid初始定义已选列表
function InitPatList(){
	
	///  定义columns
	var columns=[[
		{field:'PatNo',title:'登记号',width:100},
		{field:'PatName',title:'姓名',width:100},
		{field:'PatSex',title:'性别',width:60,align:'center'},
		{field:'PatAge',title:'年龄',width:60,align:'center'},
		{field:'PatLoc',title:'就诊科室',width:120},
		{field:'PatWard',title:'病区',width:150},
		{field:'PatBed',title:'床号',width:60,align:'center'}, 
		{field:'AuditFlag',title:'审核状态',width:80,align:'center'},
		{field:'PatDiag',title:'诊断',width:140},
		{field:'CstType',title:'会诊类型',width:100,align:'center'},
		{field:'CstRLoc',title:'请会诊科室',width:120},
		{field:'CstRUser',title:'请会诊医师',width:100,align:'center'},
		{field:'CstRTime',title:'申请时间',width:160,align:'center'},
		{field:'CstTrePro',title:'简要病历',width:400,formatter:SetCellField},
		{field:'CstPurpose',title:'会诊理由及要求',width:400,formatter:SetCellField},
		{field:'CstUnit',title:'会诊医院',width:100},
		{field:'CstLocArr',title:'会诊科室',width:220},
		{field:'CstPrvArr',title:'会诊医师',width:220},
		{field:'AccpTime',title:'接收时间',width:160,align:'center'},
		{field:'CompTime',title:'完成时间',width:160,align:'center'},
		{field:'CstStatus',title:'会诊状态',width:80,align:'center',formatter:
			function (value, row, index){
				if (value == "驳回"){return '<font style="color:red;font-weight:bold;">'+value+'</font>'}
				else {return '<font style="color:green;font-weight:bold;">'+value+'</font>'}
			}
		},
		{field:'CstNPlace',title:'会诊地点',width:200},
		{field:'PrintFlag',title:'打印',width:80,align:'center',formatter:
			function (value, row, index){
				if (value == "Y"){return '<font style="color:green;font-weight:bold;">已打印</font>'}
				else {return '<font style="color:red;font-weight:bold;">未打印</font>'}
			}
		},
		{field:'EpisodeID',title:'EpisodeID',width:100,align:'center'},
		{field:'CstID',title:'CstID',width:100}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onLoadSuccess:function(data){
			/*
			var rows = $("#bmDetList").datagrid('getRows');		   
			if (rows.length == 0) return;
			var rowData = $('#bmDetList').datagrid('getData').rows[0];
			var TmpCstID = rowData.CstID;
			var mergerows = 0;
			for (var i=1;i<rows.length;i++){
				mergerows = mergerows + 1;
				if (TmpCstID != rows[i].CstID){
				    MergeCells(i,mergerows);  /// 合并指定单元格
				    mergerows=0;
				    TmpCstID = rows[i].CstID;
				}
			}
			if(i == rows.length){
				mergerows = mergerows + 1;
				 MergeCells(i,mergerows);  /// 合并指定单元格
			}
			*/
			/// 修改列名
			if (CsNoType == "Nur"){
				$("#bmDetList").datagrid("setColumnTitle",{field:'CstRUser',text:'请会诊护士'});
				$("#bmDetList").datagrid("setColumnTitle",{field:'CstPrvArr',text:'会诊护士'});
			}
			BindTips(); /// 绑定提示消息
		},
		onDblClickRow: function (rowIndex, rowData) {
			WriteMdt(rowData.EpisodeID, rowData.CstID);
        },
        rowStyler:function(rowIndex, rowData){
	        if (rowData.CstStatus == "上级审核"){
				return 'background-color:#00FFFF;';
			}
			if (rowData.AuditFlag == "已审"){
				return 'background-color:pink;';
			}
		}
	};
	var RLocID = $HUI.combobox("#CstRLoc").getValue();   /// 请会诊科室 
	var param = "^^"+ RLocID +"^^^N^"+CsNoType +"^"+ LgGroupID +"^"+ LgUserID +"^"+ LgLocID +"^"+ "GRP";
	var uniturl = $URL+"?ClassName=web.DHCEMConsultQuery&MethodName=JsGetConsAudit&Params="+param;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// 处理特殊字符
function SetCellField(value, rowData, rowIndex){
	return $_TrsTxtToSymbol(value);
}

/// 合并指定单元格
function MergeCells(i, mergerows){
	
	var Fields = ["PatNo","PatName","CstID","PatSex","PatAge","PatLoc","PatWard","PatBed","PatDiag","CstType","CstRLoc","CstRUser","CstRTime","CstTrePro","CstPurpose","CstUnit"];
	for (var m = 0; m < Fields.length; m++){
		$('#bmDetList').datagrid('mergeCells',{
	       index:(i - mergerows),
	       field:Fields[m],
	       rowspan:mergerows
	    });
	}
}

/// 登记号
function PatNo_KeyPress(e){

	if(e.keyCode == 13){
		var PatNo = $("#PatNo").val();
		if (!PatNo.replace(/[\d]/gi,"")&(PatNo != "")){
			///  登记号补0
			$("#PatNo").val(GetWholePatNo(PatNo));
		}
		QryPatList();  /// 查询
	}
}

/// 查询
function QryPatList(){
	
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// 开始日期
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// 结束日期
	var PatNo = $("#PatNo").val();    /// 登记号
	var RLocID = $HUI.combobox("#CstRLoc").getValue();     /// 请会诊科室
	if (typeof RLocID == "undefined") RLocID = "";
	var CstType = $HUI.combobox("#CstType").getValue();    /// 会诊类型
	if (typeof CstType == "undefined") CstType = "";
	var AuditFlag = $HUI.combobox("#AuditFlag").getValue();/// 审核状态
	if (typeof AuditFlag == "undefined") AuditFlag = "";
	
	var params = StartDate +"^"+ EndDate +"^"+ RLocID +"^"+ PatNo +"^"+ CstType +"^"+ AuditFlag +"^"+ CsNoType +"^"+ LgGroupID +"^"+ LgUserID +"^"+ LgLocID +"^"+ "GRP";
	$("#bmDetList").datagrid("load",{"Params":params}); 
}

/// 填写MDT申请
function WriteMdt(EpisodeID, CstID){

	var Link = "dhcem.consultwrite.csp?EpisodeID="+EpisodeID +"&CstID="+CstID +"&CstItmID="+CstID;
	OpenMdtConsWin();
	if (CsNoType == "Nur"){
		Link = "dhcem.consultnur.csp?EpisodeID="+EpisodeID +"&CstID="+CstID +"&CstItmID="+CstID;
	}
	if ('undefined'!==typeof websys_getMWToken){ //hxy 2023-02-11 Token改造
		Link += "&MWToken="+websys_getMWToken();
	}
	$("#newWinFrame").attr("src",Link);
}

/// 打印
function PrintCst(){
	
	var rowsData = $("#bmDetList").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		PrintCst_AUD(rowsData.CstID);
		InsCsMasPrintFlag(rowsData.CstID);  /// 修改会诊打印标志
	}
}

function PrintCstHtml(){
	
	var rowsData = $("#bmDetList").datagrid('getSelected'); 
	if(!rowsData){
		$.messager.alert("提示","未选择打印数据！");
		return;	
	}
	InsCsMasPrintFlag(rowsData.CstID);  /// 修改会诊打印标志

	$m({
		ClassName:"web.DHCEMConsultCom",
		MethodName:"GetCstItmIDs",
		CstID:rowsData.CstID
	},function(txtData){
		var Link="dhcem.printconsone.csp?CstID="+rowsData.CstID+"&CstItmID="+"";
		if ('undefined'!==typeof websys_getMWToken){ //hxy 2023-02-11 Token改造
			Link += "&MWToken="+websys_getMWToken();
		}
		if(txtData=="")	window.open(Link);
		if(txtData!=""){
			var CstItmArr = txtData.split("^");
			for(var i=0;i<CstItmArr.length;i++){
				var Link="dhcem.printconsone.csp?CstID="+rowsData.CstID+"&CstItmID="+CstItmArr[i];
				if ('undefined'!==typeof websys_getMWToken){ //hxy 2023-02-11 Token改造
					Link += "&MWToken="+websys_getMWToken();
				}
				window.open(Link);
			}
		}
	});
	
	return;
}

/// 拒绝
function RefuseCst(){
	
	var rowsData = $("#bmDetList").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		if (rowsData.AuditFlag == "已审"){
			$.messager.alert('提示',"当前会诊记录已经审核，不能驳回!","error");
			return;
		}
		if (rowsData.CstStatus == "驳回"){
			$.messager.alert('提示',"当前会诊记录已经驳回，不能再次驳回!","error");
			return;
		}
		$("#TmpCstID").val(rowsData.CstID); /// 暂存驳回会诊ID
	    $("#CstRefReason").val("");         /// 驳回会诊原因
		RefuseCstWin(); /// 初始化驳回意见窗口
		//InsCsRefAudit(rowsData.CstID);
	}else{
		$.messager.alert("提示:","请先选中待处理行！","warning");
	}
}

/// 拒绝会诊数据
function InsCsRefAuditNew(CstID){
	
	var CstNote = "会诊审核不通过";
	/// 保存
	runClassMethod("web.DHCEMConsult","InsCsRefAudit",{"CstID":CstID, "UserID":LgUserID, "CstNote":CstNote},function(jsonString){
		if (jsonString == -1){
			$.messager.alert("提示:","申请单非发送状态，不允许进行审核操作！","warning");
			return;
		}
		if (jsonString == 0){
			$.messager.alert("提示:","操作成功！","info");
			$("#bmDetList").datagrid("reload");
		}
	},'',false)
}


/// 拒绝会诊数据
function InsCsRefAudit(){
	
	var CstID = $("#TmpCstID").val();       /// 驳回会诊ID
	var CstNote = $("#CstRefReason").val(); /// 驳回会诊原因
	CstNote = $_TrsSymbolToTxt(CstNote);    /// 处理特殊符号
	/// 保存
	runClassMethod("web.DHCEMConsult","InsCsRefAudit",{"CstID":CstID, "UserID":LgUserID, "CstNote":CstNote},function(jsonString){
		if (jsonString == -1){
			$.messager.alert("提示:","申请单非发送状态，不允许进行驳回操作！","warning");
			return;
		}
		if (jsonString == 0){
			$.messager.alert("提示:","操作成功！","info");
			$('#newRefOpWin').dialog('close');  /// 关闭驳回窗口
			$("#bmDetList").datagrid("reload");
		}
	},'',false)
}

/// 修改会诊打印标志
function InsCsMasPrintFlag(CstID){
	
	runClassMethod("web.DHCEMConsult","InsCsMasPrintFlag",{"CstID":CstID},function(jsonString){

		if (jsonString != 0){
			$.messager.alert("提示:","更新会诊打印状态失败，失败原因:"+jsonString);
		}else{
			$("#bmDetList").datagrid("reload");
		}
	},'',false)
}

/// 打卡MDT填写页面
function OpenMdtConsWin(){
	
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		closed:"true"
	};
	new WindowUX('会诊申请', 'MdtConsWin', '920', (window.screen.availHeight - 200), option).Init();
}

/// 新建审核会诊窗口
function newConsult(){
	
	var rowData = $('#bmDetList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	if (rowData.AuditFlag == "已审"){
		$.messager.alert('提示',"当前会诊记录已经审核，不能再次审核!","error");
		return;
	}
	if (rowData.CstStatus == "驳回"){
		$.messager.alert('提示',"当前会诊记录已经驳回，不能审核!","error");
		return;
	}
	if (rowData.CstOutFlag == "Y"){
		CstOutFlag = "Y";   /// 院际会诊标志
		isEditFlag = 1;     /// 页面是否可编辑
	}

	newCreateConsultWin();  /// 新建咨询窗口
	InitConsItem(rowData);  /// 页面DataGrid初始定义已选列表
	InitConsultDefault(rowData);  //初始化界面默认信息
}

/// 新建审核会诊窗口
function newCreateConsultWin(){
	var option = {
			buttons:[{
				text:'保存',
				iconCls:'icon-save',
				handler:function(){
					saveConsultDetail();
					}
			},{
				text:'取消',
				iconCls:'icon-cancel',
				handler:function(){
					$('#newConWin').dialog('close');
				}
			}]
		};
	new DialogUX('审核', 'newConWin', '910', '500', option).Init();

}

/// 页面DataGrid初始定义已选列表
function InitConsItem(rowData){
	
	/// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	// 科室编辑格
	var LocEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID"+session['LOGON.HOSPID'],
			valueField: "value", 
			textField: "text",
			//editable:false,
			//panelHeight:"auto",  //设置容器高度自动增长
			mode:'remote',
			enterNullValueClear:false,
			onSelect:function(option){
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				$(ed.target).val(option.value);
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
//				///设置级联指针
//				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'UserName'});
//				var unitUrl=LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocCareProv&LocID="+ option.value;
//				$(ed.target).combobox('reload',unitUrl);

				///设置级联指针
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
				/// 联系方式
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'TelPhone'});
				$(ed.target).val(GetLocTelPhone(option.value));
			},
			onShowPanel:function(){

				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'LocGrpID'});
				var LocGrpID = $(ed.target).val();
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'isGrpFlag'});
				var isGrpFlag = $(ed.target).val();
				if (isGrpFlag != 0){
					var unitUrl = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonConsGroupLoc&ID="+ LocGrpID;
				}else{
					var unitUrl = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocList&LType="+LType+"&LocID="+LgLocID+"&HospID="+LgHospID;
				}
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
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
			//editable:false,
			enterNullValueClear:false,
			onSelect:function(option){
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'UserID'});
				$(ed.target).val(option.value);
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', option.text);
				
				/// 联系方式
				var TelPhone = GetCareProvPhone(option.value);
				if (TelPhone != ""){
					var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'TelPhone'});
					$(ed.target).val(TelPhone);
				}
				
				$m({
					ClassName:"web.DHCEMConsultCom",
					MethodName:"GetPrvTpIDByCareProvID",
					CareProvID:option.value
				},function(txtData){
					var ctpcpCtInfo = txtData;
					/// 获取所有行内
					var rowsData = $('#dgConsItem').datagrid('getRows');
					rowsData[editSelRow].PrvTp = ctpcpCtInfo.split("^")[1];
					$("tr[datagrid-row-index='"+ editSelRow +"'] td[field='PrvTp'] div").text(ctpcpCtInfo.split("^")[1]);
					var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
					$(ed.target).val(ctpcpCtInfo.split("^")[0]);
				});
			},
			onShowPanel:function(){
				
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				var LocID = $(ed.target).val();
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
				var PrvTpID = $(ed.target).val();
				///设置级联指针
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				var unitUrl=$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocCareProv&ProvType="+ CsNoType +"&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&LgUserID="+ rowData.CstRUserID;
				$(ed.target).combobox('reload',unitUrl);
			}
		}
	}
	
	///  定义columns
	var columns=[[
		{field:'LocGrpID',title:'LocGrpID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'LocGrp',title:'专科小组',width:140,align:'center',hidden:true},
		{field:'itmID',title:'itmID',width:100,editor:texteditor,hidden:true},
		{field:'PrvTpID',title:'职称ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'PrvTp',title:'职称',width:120,align:'center'},
		{field:'LocID',title:'科室ID',width:100,editor:texteditor,hidden:true},
		{field:'LocDesc',title:'科室',width:300,editor:LocEditor},   //handong  2019-9-18 添加 editor:texteditor 
		{field:'UserID',title:'护士ID',width:100,editor:texteditor,hidden:true},
		{field:'UserName',title:'护士',width:200,editor:DocEditor},
		{field:'TelPhone',title:'联系方式',width:130,editor:texteditor},
	    {field:'isGrpFlag',title:'isGrpFlag',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'operation',title:"操作",width:110,align:'center',formatter:SetCellUrl}
	]];
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMConsultQuery&MethodName=JsonQryConsult&CstID="+rowData.CstID;
	//定义datagrid
	$('#dgConsItem').datagrid({
		showHeader:true,
		url:uniturl,
		border:false,
		columns:columns,
		remoteSort:false,
		rownumbers : true,
		singleSelect : true,
		pagination: false,
	    onDblClickRow: function (rowIndex, rowData) {
		    
			if (isEditFlag == 1) return;
			
			var CstType = $("#CsType").text(); 	          /// 会诊类型
			if ((CstType.indexOf("单科") != "-1")&(rowIndex != 0))return;
			
            if ((editSelRow != -1)||(editSelRow == 0)) { 
                $("#dgConsItem").datagrid('endEdit', editSelRow); 
            } 
            $("#dgConsItem").datagrid('beginEdit', rowIndex); 

            editSelRow = rowIndex; 
            
            /// 联系方式
			var ed=$("#dgConsItem").datagrid('getEditor',{index:rowIndex,field:'TelPhone'});
			$(ed.target).attr("disabled", true);
        }
	});
}

/// 链接
function SetCellUrl(value, rowData, rowIndex){	
	var html = "<a href='#' onclick='delRow("+ rowIndex +")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
	    //html += "<a href='#' onclick='insRow()'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_add.png' border=0/></a>";
	return html;
}

/// 删除行
function delRow(rowIndex){
	
	if (isEditFlag == 1) return;
	/// 行对象
    var rowObj={UserID:'', UserName:'', TelPhone:''};
	
	/// 当前行数大于4,则删除，否则清空
	if(rowIndex=="-1"){
		$.messager.alert("提示:","请先选择行！");
		return;
	}
	
	var rows = $('#dgConsItem').datagrid('getRows');
	if(rows.length>6){
		 $('#dgConsItem').datagrid('deleteRow',rowIndex);
	}else{
		$('#dgConsItem').datagrid('updateRow',{index:rowIndex, row:rowObj});
	}
	
	// 删除后,重新排序
	//$('#dgDetList').datagrid('sort', {sortName: 'No',sortOrder: 'desc'});
}

/// 插入空行
function insRow(){
	
	if (isEditFlag == 1) return;
	var rowObj={LocID:'', LocDesc:'', UserID:'', UserName:'', TelPhone:''};
	$("#dgConsItem").datagrid('appendRow',rowObj);
}

/// 初始化界面默认信息
function InitConsultDefault(rowObj){

	$("#CstID").val(rowObj.CstID); 		    /// 会诊ID
	$("#CsRLoc").text(rowObj.CstRLoc); 		/// 申请科室
	$("#CsRUser").text(rowObj.CstRUser); 	/// 申请人
	$("#CsRDate").text(rowObj.CstRTime); 	/// 申请时间
	$("#CsType").text(rowObj.CstType); 	    /// 会诊类别
	$("#CsUnit").text(rowObj.CstUnit); 		/// 院内院外
	$("#ConsNPlace").val(rowObj.CstNPlace); /// 会诊地点
	$HUI.datebox("#CstNDate").setValue(rowObj.CstNDate);      /// 会诊日期
	$HUI.timespinner("#CstNTime").setValue(rowObj.CstNTime);  /// 会诊时间
}

 /**
  * 保存会诊数据
  */
function saveConsultDetail(){
	
	/// 结束行编辑状态
	if ((editSelRow != -1)||(editSelRow == "0")) { 
        $("#dgConsItem").datagrid('endEdit', editSelRow); 
    }
    
    /// 会诊ID
	var CstID=$('#CstID').val();
	
    /// 会诊地点
	var consNPlace=$('#ConsNPlace').val();
	if (consNPlace.replace(/\^/g,'') == ""){
		$('#ConsNPlace').val("");
		$.messager.alert("提示:","会诊地点不能为空！","warning");
		return;
	}
	consNPlace = consNPlace.replace(/\^/g,'');
	
	/// 会诊时间
	var CstDate = $HUI.datebox("#CstNDate").getValue();      /// 会诊日期
	var CstTime = $HUI.timespinner("#CstNTime").getValue();  /// 会诊时间
	if ((CstDate == "")||(CstTime == "")){
		$.messager.alert("提示:","会诊时间不能为空！","warning");
		return;
	}
	///var tmpCstCTime = new Date((CstDate +" "+ CstTime).replace(/\-/g, "\/"));
	///var tmpCstRDate = new Date($("#CsRDate").text().replace(/\-/g, "\/"));
	var tmpCstCTime = CstDate +" "+ CstTime;
	var tmpCstRDate = $("#CsRDate").text();
 	if (isCompare(tmpCstCTime , tmpCstRDate) == 1){
		$.messager.alert("提示:","会诊时间不允许早于申请时间！","warning");
		return;
	}
	
	/// 会诊科室
	var ConsDetArr=[];
	var isEmptyFlag = 0;
	var rowData = $('#dgConsItem').datagrid('getRows');
	$.each(rowData, function(index, item){
		if((trim(item.LocDesc) != "")||(trim(item.LocGrpID) != "")){
			//if (item.UserID == "") isEmptyFlag = 1;
			if (item.LocID == "") isEmptyFlag = 1;
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^^"+ item.LocGrpID +"^"+ item.itmID +"^"+ item.LocGrpID;
		    ConsDetArr.push(TmpData);
		}
	})
	
	if ((GetCsLevCode(CstID) == 1)&(isEmptyFlag == 1)&(CsNoType == "Nur")){
		$.messager.alert("提示:","会诊科室不能为空！","warning");
		return;	
	}
	if ((isEmptyFlag == 1)&(CsNoType == "Doc")){
		$.messager.alert("提示:","会诊医生不能为空！","warning");
		return;	
	}
	var ConsDetList = ConsDetArr.join("@");
	if ((ConsDetArr.join("") == "")&(CstOutFlag =="N")){
		$.messager.alert("提示:","会诊科室不能为空！","warning");
		return;	
	}
	
	var CstType = $("#CsType").text();   /// 会诊类型
	if ((ConsDetArr.length == 1)&(CstType.indexOf("多科") != "-1")){
		$.messager.alert("提示:","会诊类型为多科会诊，至少选择两个及两个以上科室！","warning");
		return;	
	}
	
	///             主信息  +"&"+  会诊科室
	var mListData = consNPlace +"^"+ CstDate +"^"+ CstTime +"^"+ LgLocID +"^"+ LgUserID +del+ ConsDetList;

	/// 保存
	runClassMethod("web.DHCEMConsult","InsConsAudit",{"CstID":CstID, "UserID":LgUserID, "LgGroupID":LgGroupID, "LgLocID":LgLocID, "PageType":"GRP", "mListData":mListData},function(jsonString){
		if (jsonString == -1){
			$.messager.alert("提示:","申请单非发送状态，不允许进行审核操作！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊审核数据保存失败，失败原因:"+jsonString,"warning");
		}else{
			$('#newConWin').dialog('close');
			$.messager.alert("提示:","审核成功！","warning");
			$("#bmDetList").datagrid("reload");
		}
	},'',false)
}

/// 取科室电话
function GetLocTelPhone(LocID){
	
	var TelPhone = "";
	runClassMethod("web.DHCEMConsultQuery","GetLocTelPhone",{"LocID":LocID},function(jsonString){

		//if (jsonString != ""){
			TelPhone = jsonString;
		//}
	},'',false)
	return TelPhone
}

/// 取医生电话
function GetCareProvPhone(CareProvID){
	
	var TelPhone = "";
	runClassMethod("web.DHCEMConsultQuery","GetCareProvPhone",{"CareProvID":CareProvID},function(jsonString){

		if (jsonString != ""){
			TelPhone = jsonString;
		}
	},'',false)
	return TelPhone
}

///补0病人登记号
function GetWholePatNo(EmPatNo){

	///  判断登记号是否为空
	var EmPatNo=$.trim(EmPatNo);
	if (EmPatNo == ""){
		return;
	}
	
	///  登记号长度值
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatRegNoLen",{},function(jsonString){

		var patLen = jsonString;
		var plen = EmPatNo.length;
		if (EmPatNo.length > patLen){
			$.messager.alert('错误提示',"登记号输入错误！");
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;

}

/// 获取系统当前日期
function GetCurSystemDate(offset){
	
	var SysDate = "";
	runClassMethod("web.DHCEMConsultCom","GetCurSystemDate",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate
}

/// 检查项目绑定提示栏
function BindTips(){
	
	var html='<div id="tip" style="border-radius:3px; display:none; border:1px solid #000; padding:10px; margin:5px; position: absolute; background-color: #000;color:#FFF;"></div>';
	$('body').append(html);
	
	/// 鼠标离开
	$('td[field="CstTrePro"],td[field="CstPurpose"]').on({
		'mouseleave':function(){
			$("#tip").css({display : 'none'});
		}
	})
	/// 鼠标移动
	$('td[field="CstTrePro"],td[field="CstPurpose"]').on({
		'mousemove':function(){
			
			var tleft=(event.clientX + 10);
			if ($(this).text().length <= 20){
				return;
			}
			if ( window.screen.availWidth - tleft < 600){ tleft = tleft - 600;}
			/// tip 提示框位置和内容设定
			$("#tip").css({
				display : 'block',
				top : (event.clientY + 10) + 'px',   
				left : tleft + 'px',
				//right:10+'px',
				//bottom:5+'px',
				'z-index' : 9999,
				opacity: 0.8
			}).text($(this).text());
		}
	})
}

/// 新建驳回意见窗口
function RefuseCstWin(){
	
	var option = {
			iconCls:'icon-paper',
			buttons:[{
				text:'保存',
				iconCls:'icon-save',
				handler:function(){
					InsCsRefAudit();
					}
			},{
				text:'取消',
				iconCls:'icon-cancel',
				handler:function(){
					$('#newRefOpWin').dialog('close');
				}
			}]
		};
	new DialogUX('驳回意见窗口', 'newRefOpWin', '600', '300', option).Init();
}

/// 日期大小判断
function isCompare(FristTime, SecondTime){
	
	var isCompareFlag = 0;
	runClassMethod("web.DHCEMConsultCom","isCompare",{"FristTime":FristTime, "SecondTime":SecondTime},function(jsonString){

		if (jsonString != null){
			isCompareFlag = jsonString;			
		}
	},'',false)
	return isCompareFlag;
}

/// 会诊审核级别
function GetCsLevCode(CstID){
	
	var LevCode = "";
	runClassMethod("web.DHCEMConsult","GetCsLevCode",{"CstID":CstID, "LgUserID":LgUserID, "LgGroupID":LgGroupID, "LgLocID":LgLocID},function(jsonString){

		//if (jsonString != ""){
			LevCode = jsonString;
		//}
	},'',false)
	return LevCode
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })