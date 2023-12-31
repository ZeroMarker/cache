//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2018-08-15
// 描述:	   会诊申请查询
//===========================================================================================

var CstID = "";         /// 会诊申请ID
var editSelRow = -1;
var isEditFlag = 0;     /// 页面是否可编辑
var CstOutFlag = "N";   /// 院际会诊标志
var CsNoType = "";      /// 会诊单据类型 医生/护士/MDT
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'];  /// 安全组ID
var LgParams = LgGroupID +"^"+ LgLocID +"^"+ LgUserID;
var WriGrpFlag="";
var ItemTypeArr = [{"value":"N","text":$g('待审')}, {"value":"Y","text":$g('已审')}];
var del = String.fromCharCode(2);

/// 页面初始化函数
function initPageDefault(){
	
	/// 初始化加载病人就诊ID
	InitPatEpisodeID();
	
	///
	InitPage();
	
	/// 初始化加载病人列表
	InitPatList();
	
	/// 初始化病人基本信息
	InitPatInfoPanel();
	
}

function InitPage(){
	if(CsNoType=="Nur"){
		$("#consSendDoc").html("申请"+TypeDesc+"：");	
	}
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	
	CsNoType = getParam("CsType");  /// 会诊单据类型
	
	TypeDesc=CsNoType=="Nur"?"护士":"医生";
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
		{field:'CstID',title:'CstID',width:100,hidden:true},
		{field:'PatNo',title:'登记号',width:100},
		{field:'PatName',title:'姓名',width:100},
		{field:'PatSex',title:'性别',width:60,align:'left'},
		{field:'PatAge',title:'年龄',width:60,align:'left'},
		{field:'PatLoc',title:'就诊科室',width:120},
		{field:'PatWard',title:'病区',width:150},
		{field:'PatBed',title:'床号',width:60,align:'left'}, 
		{field:'PatDiag',title:'诊断',width:140},
		{field:'CstType',title:'会诊类型',width:100,align:'left'},
		{field:'CstEmFlag',title:'性质',width:60,align:'center',formatter:
			function (value, row, index){
				if (value == "Y"){return '<font style="color:red;font-weight:bold;">加急</font>'}
			}
		},
		{field:'CstRLoc',title:'请会诊科室',width:120},
		{field:'CstRUser',title:'请会诊'+TypeDesc,width:100,align:'left'},
		{field:'CstRTime',title:'申请时间',width:160,align:'left'},
		{field:'CstTrePro',title:'简要病历',width:400,formatter:SetCellField},
		{field:'CstPurpose',title:'会诊理由及要求',width:400,formatter:SetCellField},
		{field:'CstUnit',title:'会诊医院',width:100},
		{field:'CstLocArr',title:'会诊科室',width:220},
		{field:'CstPrvArr',title:'会诊'+TypeDesc,width:220},
		{field:'AccpTime',title:'接收时间',width:160,align:'left'},
		{field:'CompTime',title:'完成时间',width:160,align:'left'},
		{field:'CstStatus',title:'会诊状态',width:80,align:'left',formatter:
			function (value, row, index){
				if (value == "驳回"){return '<font style="color:red;font-weight:bold;">'+value+'</font>'}
				else {return '<font style="color:green;font-weight:bold;">'+value+'</font>'}
			}
		},
		{field:'CstNPlace',title:'会诊地点',width:200},
		{field:'PrintFlag',title:'打印',width:80,align:'left',formatter:
			function (value, row, index){
				if (value == "Y"){return '<font style="color:green;font-weight:bold;">已打印</font>'}
				else {return '<font style="color:red;font-weight:bold;">未打印</font>'}
			}
		},
		{field:'AuditFlag',title:'审核状态',width:110,align:'left'},
		{field:'EpisodeID',title:'EpisodeID',width:100,align:'left'}
	]];
	
	///  定义datagrid
	var option = {
		border:true, //hxy 2020-04-29
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
			if (rowData.AuditFlag == "已审"){
				return 'background-color:pink;';
			}
		}
	};
	/// 就诊类型
	var param = "^^^^^N^"+CsNoType +"^"+ LgUserID +"^"+ WriGrpFlag +"^"+ LgGroupID +"^"+ LgLocID +"^"+LgHospID;
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
	var RLocID = $HUI.combobox("#CstRLoc").getValue();   /// 请会诊科室
	if (typeof RLocID == "undefined") RLocID = "";
	var CstType = $HUI.combobox("#CstType").getValue();  /// 会诊类型
	if (typeof CstType == "undefined") CstType = "";
	var AuditFlag = $HUI.combobox("#AuditFlag").getValue();/// 审核状态
	if (typeof AuditFlag == "undefined") AuditFlag = "";
	
	var params = StartDate +"^"+ EndDate +"^"+ RLocID +"^"+ PatNo +"^"+ CstType +"^"+ AuditFlag +"^"+ CsNoType +"^"+ LgUserID +"^"+ WriGrpFlag +"^"+ LgGroupID +"^"+ LgLocID +"^"+LgHospID;
	$("#bmDetList").datagrid("load",{"Params":params}); 
}

/// 填写MDT申请
function WriteMdt(EpisodeID, CstID){

	var Link = "dhcem.consultwrite.csp?EpisodeID="+EpisodeID +"&CstID="+CstID +"&CstItmID="+CstID+"&seeCstType=1";
	OpenMdtConsWin();
	if (CsNoType == "Nur"){
		Link = "dhcem.consultnur.csp?EpisodeID="+EpisodeID +"&CstID="+CstID +"&CstItmID="+CstID+"&seeCstType=1";
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
	
	var CsStatCode = rowsData.CstStatus;
	if(CsStatCode=="取消"){
		$.messager.alert("提示","申请单已经取消,不能打印！","warning");
		return;
	}
	
	if((CsStatCode=="发送")||(CsStatCode.indexOf("审核")!=-1)||(CsStatCode=="驳回")||(CsStatCode=="拒绝")||(CsStatCode=="接收")||(CsStatCode=="取消接收")||(CsStatCode=="到达")||(CsStatCode=="取消完成")){
		if(ConsNoCompCanPrt==1){
			$.messager.alert("提示","会诊未完成,不能打印！","warning");
			return;
		}
	}

	$m({
		ClassName:"web.DHCEMConsultCom",
		MethodName:"GetCstItmIDs",
		CstID:rowsData.CstID
	},function(txtData){
		if(PrintModel==1){
			var Link="dhcem.printconsone.csp?CstItmIDs="+txtData; //hxy 2023-02-11 Token改造 st
			if ('undefined'!==typeof websys_getMWToken){ 
				Link += "&MWToken="+websys_getMWToken();
			}
			window.open(Link); //ed
			InsCsMasPrintFlag(rowsData.CstID);  /// 修改会诊打印标志 //hxy 2020-03-24 add rowsData.CstID
		}else{
			var prtRet = PrintCstNew(txtData,LgHospID);
			if(prtRet){
				InsCsMasPrintFlag(rowsData.CstID);  /// 修改会诊打印标志 //hxy 2020-03-24 add rowsData.CstID
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
	runClassMethod("web.DHCEMConsult","InsCsRefAudit",{"CstID":CstID, "UserID":LgUserID, "CstNote":CstNote,"LgParams":LgParams},function(jsonString){ //hxy 2022-12-30 LgParams (为了调用平台接口时传入部门)
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
	var AuditFlag = $HUI.combobox("#AuditFlag").getValue();/// 审核状态
	if (AuditFlag == "Y"){
		$.messager.alert('提示',"当前会诊记录已经审核，不能再次审核!","error");
		return;
	}
	
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
	}else{
		CstOutFlag = "N";
		isEditFlag = 0;	
	}

	newCreateConsultWin(rowData.NextStCode);  /// 新建咨询窗口
	InitConsItem(rowData);  /// 页面DataGrid初始定义已选列表
	InitConsultDefault(rowData);  //初始化界面默认信息
}

/// 新建审核会诊窗口
function newCreateConsultWin(NextStCode){
	var option = {
			buttons:[{
				text:'保存',
				iconCls:'icon-save',
				handler:function(){
					saveConsultDetail(NextStCode);
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
			//url: LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID"+session['LOGON.HOSPID'],
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
			onShowPanel:function(){ //hxy 2021-06-21
				
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'LocGrpID'});
				var LocGrpID = $(ed.target).val(); 
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
				if(LocGrpID!=""){
					var unitUrl = $URL+"?ClassName=web.DHCEMConsultGroup&MethodName=JsonConsGroupItm&ECRowID="+LocGrpID; 
				}
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
					//$("tr[datagrid-row-index='"+ editSelRow +"'] td[field='PrvTp'] div").text(ctpcpCtInfo.split("^")[1]); //hxy 2021-03-23 st
					var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'PrvTp'});
					$(ed.target).combobox('setValue',ctpcpCtInfo.split("^")[1]); //ed
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
	
	// 职称编辑格 //hxy 2021-03-23 add
	var CType="DOC^PHA"; /// 对医生会诊申请兼容药师处理
	if(CsNoType=="Nur"){
		var CType = "NUR";
	}
	var PrvTpEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonPrvTp&Type="+CType+"&LgHospID="+LgHospID,
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			//panelHeight:"auto",  //设置容器高度自动增长
			blurValidValue:false, //hxy 2021-06-07 true->false 在会诊科室“类型”下拉列表展开的情况下点击科室记录，类型及护士文本框内容被清空
			onSelect:function(option){
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'PrvTp'});
				$(ed.target).combobox('setValue', option.text);
				
				///设置级联指针
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'UserID'});
				$(ed.target).val("");
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'LocID'}); //hxy 2021-05-25 st
				var LocID = $(ed.target).val();
				if(LocID!=""){
					var PrvTpID = option.value;
					var ProvType=CsNoType=="Nur"?"NURSE":"DOCTOR";
					var Datas=serverCall("web.DHCEMConsultCom","JsonLocCareProv",{ProvType:ProvType,LocID:LocID,PrvTpID:PrvTpID,LgUserID:LgUserID});
					if(Datas=="[]"){
						$.messager.alert("提示","当前类型无人员,请选择其他类型！");
						var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
						$(ed.target).val("");
						var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'PrvTp'});
						$(ed.target).combobox('setValue',"");
					} 
				}//ed
			},
			onChange:function(newValue, oldValue){
				if (newValue == ""){
					var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
					$(ed.target).val("");
					var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'UserName'});
					$(ed.target).combobox('setValue', "");
					var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'UserID'});
					$(ed.target).val("");
				}
			}
		}
	}
	
	var LocEditorCon={},hiddenVal=true; //hxy 2021-06-21 科室编辑和大科 只有当配置医师大科启用并且是医生会诊时，大科列才显示，科室才可编辑
	if((CsNoType!="Nur")&&(LeaderFlag=="1")){
		LocEditorCon=LocEditor;
		hiddenVal=false;
	}
	///  定义columns
	var columns=[[
		{field:'itmID',title:'itmID',width:100,editor:texteditor,hidden:true},
		{field:'LocGrpID',title:'大科ID',width:100,editor:texteditor,hidden:true}, //2021-06-17 add
		{field:'LocGrp',title:'大科',width:100,hidden:hiddenVal}, //2021-06-17 add
		{field:'LocID',title:'科室ID',width:100,editor:texteditor,hidden:true},  //
		{field:'LocDesc',title:'科室',width:280,editor:LocEditorCon}, // 2021-06-17 add ,editor:LocEditor
		{field:'PrvTpID',title:'职称ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'PrvTp',title:'类型',width:120,align:'center',editor:PrvTpEditor}, //hxy 2021-02-20 职称->类型 //2021-03-23 add ,editor:PrvTpEditor
		//{field:'LocID',title:'科室ID',width:100,editor:texteditor,hidden:true},
		//{field:'LocDesc',title:'科室',width:280},
		{field:'UserID',title:TypeDesc+'ID',width:100,editor:texteditor,hidden:true},
		{field:'UserName',title:TypeDesc,width:200,editor:DocEditor},
		{field:'TelPhone',title:'联系方式',width:130,editor:texteditor}//,
		//{field:'operation',title:"操作",width:110,align:'center',formatter:SetCellUrl}
	]];
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMConsultQuery&MethodName=JsonQryConsult&CstID="+rowData.CstID+"&LgParams=^^^"+LgUserID; //2021-06-17 add LgParams
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
	    onClickRow: function (rowIndex, rowData) { //hxy 2021-05-19 onDblClickRow-onClickRow
	        if((LeaderFlag=="1")&&(rowData.LeadEditFlag=="0"))return; //2021-06-21 大科启用且大科编辑标识为0时，返回
		    if((CsNoType=="Nur")&&(GrpAllowUpd!=1)&&(rowData.isGrpFlag==1)){//hxy 2021-05-28 配置选择专科小组后是否允许修改会诊科室为不允许时(!=1)，不可修改
		    	$.messager.alert("提示:","当前已选"+rowData.LocGrp+"，且未配置选择专科小组后允许修改，故不可修改！");
		    	return; 
		    }
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
			if(AudModPrvTp!=1){ //hxy 2021-03-23
				var ed=$("#dgConsItem").datagrid('getEditor',{index:rowIndex,field:'PrvTp'});
				$(ed.target).combobox('disable');
			}
        }
	});
}

/// 链接
function SetCellUrl(value, rowData, rowIndex){	
	var html = "<a href='#' onclick='delRow("+ rowIndex +","+rowData.isGrpFlag+")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/></a>";
	    //html += "<a href='#' onclick='insRow()'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_add.png' border=0/></a>";
	return html;
}

/// 删除行
function delRow(rowIndex,isGrpFlag){
	if((GrpAllowUpd!=1)&&(isGrpFlag==1))return; //hxy 2021-05-28 配置选择专科小组后是否允许修改会诊科室为不允许时(!=1)，不可修改
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
	if($("#ConsNPlace").val()==""){//hxy 2021-05-29 st
		if(AuditDefPlace.split(",")[0]==1){
			if(AuditDefPlace.indexOf("1,")>-1){
				$("#ConsNPlace").val(rowObj.CstRLoc+AuditDefPlace.replace("1,",""));
			}else{
				$("#ConsNPlace").val(rowObj.CstRLoc);
			}
		}
	}//ed
}

 /**
  * 保存会诊数据
  */
function saveConsultDetail(NextStCode){
	
	/// 结束行编辑状态
	if ((editSelRow != -1)||(editSelRow == "0")) { 
        $("#dgConsItem").datagrid('endEdit', editSelRow); 
    }
    
    /// 会诊ID
	var CstID=$('#CstID').val();
	
	/// 多科标志
	var MoreFlag =isMoreFlag(CstID);
	
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
	var PrvTpFlag=0; //hxy 2021-02-07 职称填写标志（0已填，1未）
	var ConsDetArr=[],HasRepetDoc=false,DocList="^";
	var isEmptyFlag = 0;
	var isEmptyLeadFlag=0; //大科住院总审核时，会诊人不能为空：是否为空标识
	var rowData = $('#dgConsItem').datagrid('getRows');
	$.each(rowData, function(index, item){
		if(trim(item.LocGrp) != ""){ //2021-06-21
			if ((item.UserID == "")&&(item.LeadEditFlag=="1")) isEmptyLeadFlag = 1; //hxy 2021-06-21
			if((DocList.indexOf("^"+item.UserID+"^")!=-1)&&(trim(item.UserID) != "")){
				HasRepetDoc=true;
			}
			DocList=DocList+item.UserID+"^";
			
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^"+item.MarID +"^"+ item.LocGrpID+"^"+ item.itmID;
		    ConsDetArr.push(TmpData);
		    if(item.PrvTpID=="")PrvTpFlag=1; //
		}else if(trim(item.LocDesc) != ""){
			if (item.UserID == "") isEmptyFlag = 1;
			if((DocList.indexOf("^"+item.UserID+"^")!=-1)&&(trim(item.UserID) != "")){
				HasRepetDoc=true;
			}
			DocList=DocList+item.UserID+"^";
			
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^"+item.MarID +"^"+ item.LocGrpID+"^"+ item.itmID;
		    ConsDetArr.push(TmpData);
		    if(item.PrvTpID=="")PrvTpFlag=1; //
		}
	})
	
	if((CsNoType!="Nur")&&(IsMustPrvTp==1)&&(PrvTpFlag==1)){
		$.messager.alert("提示","请选择类型！","warning");
		return;
	}
	
	if(HasRepetDoc){
		$.messager.alert("提示:","存在同一人员多条记录，请确认！","warning");
		return;
	}
	
	if(((AudNeedUser==1)||((MoreFlag=="1")&&(MulWriFlag==1)))&&(isEmptyFlag == 1)&&(LeaderFlag != 1)){ //hxy 2021-06-21 add &&(LeaderFlag != 1)
		$.messager.alert("提示:","会诊"+TypeDesc+"不能为空！","warning");
		return;
	}
	
	if((CsNoType!="Nur")&&(NextStCode=="75")&&(isEmptyLeadFlag == 1)){ //hxy 2021-06-21 对于医师大科住院总的审核，会诊人不能为空
		$.messager.alert("提示:","会诊"+TypeDesc+"不能为空！","warning");
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
	runClassMethod("web.DHCEMConsult","InsConsAudit",{"CstID":CstID, "LgParams":LgParams, "mListData":mListData},function(jsonString){
		var jsonArr = jsonString.split("^")
		if (jsonArr[0] == -1){
			$.messager.alert("提示:","申请单非发送状态，不允许进行审核操作！","warning");
			return;
		}
		if (jsonArr[0] < 0){
			$.messager.alert("提示:","会诊审核数据审核失败，失败原因:"+(jsonArr.length == 1?jsonArr[0]:jsonArr[1]),"warning");
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
	
	var html='<div id="tip" style="word-break:break-all;word-wrap:break-word;border-radius:3px; display:none; border:1px solid #000; padding:10px; margin:5px; position: absolute; background-color: #000;color:#FFF;"></div>';
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

/// 多科标志
function isMoreFlag(CstID){
	var isMoreFlag = "";
	runClassMethod("web.DHCEMConsultWorkFlow","isMoreFlag",{"CsID":CstID},function(jsonString){
		if (jsonString != null){
			isMoreFlag = jsonString;			
		}
	},'text',false)
	return isMoreFlag;
}

///取消审核
function cancelAudit(){
	var rowData = $('#bmDetList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	if (rowData.AuditFlag != "已审"){
		$.messager.alert('提示',"当前会诊记录非审核状态，不能取消审核!","error");
		return;
	}
	var CstID = rowData.CstID;
	/// 保存
	runClassMethod("web.DHCEMConsult","InsRevConsAudit",{"CstID":CstID, "LgParams":LgParams},function(jsonString){
		if (jsonString == -1){
			$.messager.alert("提示:","申请单当前所在状态，不允许进行取消审核操作！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊取消审核失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示:","取消审核成功！","warning");
			$("#bmDetList").datagrid("reload");
		}
	},'',false)
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })