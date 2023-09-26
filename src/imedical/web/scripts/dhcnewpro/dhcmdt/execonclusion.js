//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-04-24
// 描述:	   执行mdt申请单
//===========================================================================================
var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var mradm = "";			/// 就诊诊断ID
var CstID = "";         /// 会诊申请ID
var editSelRow = -1;
var isEditFlag = 1;     /// 页面是否可编辑
var LType = "CONSULT";  /// 会诊科室代码
var WriType = "";       /// 操作类型
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID']; /// 安全组ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID;
var cancelFlag="N";

/// 页面初始化函数
function initPageDefault(){
	InitPatEpisodeID();       /// 初始化加载病人就诊ID
	InitPageComponent(); 	  /// 初始化界面控件内容
	InitPageDataGrid();		  /// 初始化页面datagrid
	InitLocGrpGrid();
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){

	PatientID = getParam("PatientID");   /// 病人ID
	EpisodeID = getParam("EpisodeID");   /// 就诊ID
	CstID = getParam("ID");   			 /// 会诊ID
	mradm = getParam("mradm");           /// 就诊诊断ID
	WriType = getParam("WriType");       /// 操作类型
	showModel = getParam("showModel");

	if(showModel==3){
		$("#mdtTrePro").attr("disabled", true);
		$("#mdtDiscuss").attr("disabled", true);
		$("#mdtPurpose").attr("disabled", true);
		$("#mdtOpinion").attr("disabled", true);
		$("#bt_cancel").hide();
		$("#bt_send").hide();
		$("#bt_sign").hide();
		$("#bt_save").hide();
	}
	/// 评估
	if (WriType == "P"){
		$("#mdtTrePro").attr("disabled", true);   /// 病情摘要
		$("#mdtDiscuss").attr("disabled", false); /// 会诊讨论
		$("#mdtPurpose").attr("disabled", true);  /// 会诊目的
		$("#mdtOpinion").attr("disabled", true);  /// 会诊意见	
	}
	/// 执行
	if (WriType == "E"){
		$("#mdtTrePro").attr("disabled", true);   /// 病情摘要
		$("#mdtDiscuss").attr("disabled", true);  /// 会诊讨论
		$("#mdtPurpose").attr("disabled", true);  /// 会诊目的
		$("#mdtOpinion").attr("disabled", false); /// 会诊意见
	}
	/// 是否可编辑
	if(showModel == 3){
		$("#bt_grpaddloc").hide();
		$("#bt_grpcencel").hide();	
	}

}

/// 初始化界面控件内容
function InitPageComponent(){

	runClassMethod("web.DHCMDTConsultQuery","JsGetMdtObj",{"ID":CstID},function(jsonString){
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			InsCstNoObj(jsonObjArr);
		}
	})
}

/// 设置会诊申请单内容
function InsCstNoObj(itemobj){
	
	$("#patName").val(itemobj.PatName);
	$("#patSex").val(itemobj.PatSex);
	$("#patAge").val(itemobj.PatAge);
	$("#patNo").val(itemobj.PatNo);
	$("#medicalNo").val(itemobj.MedicalNo);
	$("#patTelH").val(itemobj.PatTelH);
	$("#mdtDiag").val(itemobj.PatDiagDesc); /// 初步诊断
	
	$("#mdtTrePro").val($_TrsTxtToSymbol(itemobj.mdtTrePro));  		/// 简要病历
	$("#mdtPurpose").val($_TrsTxtToSymbol(itemobj.mdtPurpose));  	/// 会诊目的 
	//$("#mdtRUser").val(itemobj.CstRUser);   		/// 申请医师
	$("#mdtAddr").val(itemobj.CstNPlace);           /// 会诊地点
	$("#mdtDiscuss").val(itemobj.DisProcess);	    /// 会诊讨论
	$("#mdtSuppsnote").val(itemobj.suppnotes);	    /// 会诊讨论
	var TreMeasures = "";
	if (itemobj.TreMeasures != ""){
		TreMeasures = itemobj.TreMeasures.replace(new RegExp("<br>","g"),"\r\n")
	}
	$("#mdtOpinion").val($_TrsTxtToSymbol(TreMeasures));       /// 会诊意见
	$HUI.combobox("#mdtDisGrp").setValue(itemobj.DisGrpID);    /// 疑难病种
	$HUI.combobox("#mdtDisGrp").setText(itemobj.DisGroup);     /// 疑难病种
	//$("#mdtCarPrv").val(itemobj.PrvDesc);                      /// 资源号别
	$HUI.datebox("#CstDate").setValue(itemobj.CstNDate);   /// 会诊时间
	
	EpisodeID = itemobj.EpisodeID;			/// 就诊ID
	isOpiEditFlag = itemobj.isOpiEditFlag;  /// 会诊结论是可编辑
	IsPerAccFlag = itemobj.IsPerAccFlag;    /// 是否允许接受申请单
	CsStatCode = itemobj.CstStatus;         /// 申请单当前状态
	PatType = itemobj.PatType;              /// 就诊类型			
}

/// 页面DataGrid初始定义已选列表
function InitPageDataGrid(){
	
	/// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	var HosTypeArr = [{"value":"I","text":'本院'}, {"value":"O","text":'外院'}];
	//设置其为可编辑
	var HosEditor={
		type: 'combobox',     //设置编辑格式
		options: {
			data: HosTypeArr,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'HosID'});
				$(ed.target).val(option.value);  //设置value
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'HosType'});
				$(ed.target).combobox('setValue', option.text);  //设置Desc
			}
		}
	}
	
	// 职称编辑格
	var PrvTpEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonPrvTp",
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			//panelHeight:"auto",  //设置容器高度自动增长
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTp'});
				$(ed.target).combobox('setValue', option.text);
				
				///设置级联指针
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserID'});
				$(ed.target).val("");
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', "");
			},
			onChange:function(newValue, oldValue){
				if (newValue == ""){
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
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
			url: '',
			blurValidValue:true,
			onSelect:function(option) {
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				$(ed.target).val(option.value);

				///设置级联指针
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
				/// 联系方式
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'TelPhone'});
				$(ed.target).val(GetLocTelPhone(option.value));
			},
			onShowPanel:function(){
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
				var unitUrl = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocList&LType="+LType+"&LocID="+LgLocID+"&HospID="+LgHospID;
				$(ed.target).combobox('reload',unitUrl);
			}		   
		}
	}
	
	// 亚专业编辑格
	var MarEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'MarID'});
				$(ed.target).val(option.value);
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'MarDesc'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				var LocID = $(ed.target).val();
				///设置级联指针
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'MarDesc'});
				var unitUrl=$URL+"?ClassName=web.DHCEMConsLocItem&MethodName=JsonSubMar&LocID="+ LocID;
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
			onSelect:function(option){
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserID'});
				$(ed.target).val(option.value);
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', option.text);
				
				/// 联系方式
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'TelPhone'});
				$(ed.target).val(GetCareProvPhone(option.value));
				
				$m({
					ClassName:"web.DHCEMConsultCom",
					MethodName:"GetPrvTpIDByCareProvID",
					CareProvID:option.value
				},function(txtData){
					var ctpcpCtInfo = txtData;
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTp'});
					$(ed.target).combobox('setValue', ctpcpCtInfo.split("^")[1]);
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
					$(ed.target).val(ctpcpCtInfo.split("^")[0]);
				});
			},
			onShowPanel:function(){
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				var LocID = $(ed.target).val();
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
				var PrvTpID = $(ed.target).val();
				///设置级联指针
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				var unitUrl=$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocCareProv&ProvType=DOCTOR&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&LgUserID="+ LgUserID;
				$(ed.target).combobox('reload',unitUrl);
			},
			onChange:function(newValue, oldValue){
				if (newValue == ""){
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserID'});
					$(ed.target).val("");
				}
			}
		}
	}
	
	///  定义columns
	var columns=[[
		{field:'itmID',title:'itmID',width:100,hidden:true},
		{field:'HosID',title:'HosID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'HosType',title:'院内院外',width:110,editor:HosEditor,align:'center',hidden:true},
		{field:'LocID',title:'科室ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'LocDesc',title:'科室',width:200,editor:LocEditor,align:'center'},
		{field:'UserID',title:'医生ID',width:110,editor:texteditor,align:'center',hidden:true},
		{field:'UserName',title:'医生',width:120,editor:DocEditor,align:'center'},
		{field:'PrvTpID',title:'职称ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'PrvTp',title:'职称',width:160,editor:PrvTpEditor,align:'center',hidden:false},
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		fitColumns:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		fit : false,
	    onDblClickRow: function (rowIndex, rowData) {
			
			if (isEditFlag == 1) return;
			
            if ((editSelRow != -1)||(editSelRow == 0)) { 
                $("#dgCstDetList").datagrid('endEdit', editSelRow); 
            }
            $("#dgCstDetList").datagrid('beginEdit', rowIndex); 
            
            /// 联系方式
			var ed=$("#dgCstDetList").datagrid('getEditor',{index:rowIndex,field:'TelPhone'});
			$(ed.target).attr("disabled", true);
			
            editSelRow = rowIndex;
        },
	    onLoadSuccess: function (data) { //数据加载完毕事件

        }
	};
	/// 就诊类型
	//var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+CstID;
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+CstID+"&Type=O";
	new ListComponent('dgCstDetList', columns, uniturl, option).Init();
}

/// 链接
function SetCellUrl(value, rowData, rowIndex){	
	var html = "<a href='#' onclick='delRow("+ rowIndex +")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
	    html += "<a href='#' onclick='insRow()'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_add.png' border=0/></a>";
	return html;
}

/// 删除行
function delRow(rowIndex){
	
	if (isEditFlag == 1) return;
	/// 行对象
    var rowObj={PrvTpID:'', PrvTp:'', HosID:'', HosType:'', LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:''};
	
	/// 当前行数大于4,则删除，否则清空
	if(rowIndex=="-1"){
		$.messager.alert("提示:","请先选择行！");
		return;
	}
	
	var rows = $('#dgCstDetList').datagrid('getRows');
	if(rows.length>2){
		 $('#dgCstDetList').datagrid('deleteRow',rowIndex);
	}else{
		$('#dgCstDetList').datagrid('updateRow',{index:rowIndex, row:rowObj});
	}
	
	// 删除后,重新排序
	//$('#dgCstDetList').datagrid('sort', {sortName: 'No',sortOrder: 'desc'});
}

/// 插入空行
function insRow(){
	
	if (isEditFlag == 1) return;
			
    var rowObj={PrvTpID:'', PrvTp:'', HosID:'I', HosType:'本院', LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:''};
	$("#dgCstDetList").datagrid('appendRow',rowObj);
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

		//if (jsonString != ""){
			TelPhone = jsonString;
		//}
	},'',false)
	return TelPhone
}

/// 完成
/**function mdtCompCs(){
	if (WriType == "E"){
		$.messager.confirm("提示","您确认要完成吗?申请执行完成后内容不可修改！",function(r){
			if(r){
				mdtSend();
			}
		});
	}else{
		mdtSend();  /// 保存 
	}

}*/

/// 暂存
function mdtSave(){
	
	mdtSend("S");
	
	
}

/// 完成
function mdtCompCs(){
	
	mdtSend("");
	
	
}
/// 保存
function mdtSend(OperFlag){
	
	var mdtTrePro = $("#mdtTrePro").val();				///病情摘要 
	var mdtPurpose = $("#mdtPurpose").val();			///会诊目的 
	var mdtOpinion = $("#mdtOpinion").val();			///会诊意见
	var mdtDiscuss = $("#mdtDiscuss").val();			///会诊讨论
	var mdtSuppsnote = $("#mdtSuppsnote").val();
	
	if ((WriType != "P")&(mdtOpinion.replace(/\s/g,'') == "")){
		$.messager.alert("提示:","请填写会诊意见！","warning");
		return;
	}
	
	mdtOpinion = $_TrsSymbolToTxt(mdtOpinion); /// 处理特殊符号
	
	/// 会诊科室
	var ConsDetArr=[];
	var rowData = $('#dgCstDetList').datagrid('getRows');
	$.each(rowData, function(index, item){
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID;
		    ConsDetArr.push(TmpData);
		}
	})
	var ConsDetList = ConsDetArr.join("@");
	
	var mListData = mdtTrePro +"^"+ mdtPurpose +"^"+ mdtOpinion +"^"+ mdtDiscuss +"^"+mdtSuppsnote+"^"+ConsDetList;
	
	runClassMethod("web.DHCMDTConsult","CompCstNo",{"CstID": CstID, "WriType":(OperFlag == "S"?"S":WriType), "LgParam":LgParam, "mListData":mListData},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单当前状态，不允许进行"+ (WriType == "P"?"评估":"执行") +"操作！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","保存失败！","warning");
		}else{
			if (OperFlag == "S"){
				$.messager.alert("提示:","保存成功！","info");
			}else{
				//$.messager.alert("提示:","保存成功！","info");
				window.parent.reLoadMainPanel(EpisodeID);
			}
		}
			
		
	},'',false)	
	
	
}

/// 取消
function mdtCancel(){
	
	window.parent.$("#mdtPopAccWin").window("close");
}

/// 签名
function mdtSignCs(){
	
	if (CstID == ""){
		$.messager.alert("提示:","mdt会诊申请ID不能为空！","warning");
		return;
	}
	InvDigSign(CstID); /// 调用数字签名
}

/// 自动设置图片展示区分布
function onresize_handler(){

	var Width = document.body.offsetWidth;
	//var Height = document.body.scrollHeight;
	var Height = window.screen.availHeight;
	$(".container").height(Height - 280);
	$(".p-content").height(Height - 280);
}

/// 清空
function Clear(FlagCode){
	
	if (FlagCode == "G"){
		/// 组内科室
		//$("#GrpLocArr").html('<span style="margin-top:40px;margin-left:300px;">请选择会诊专家组！</span>');
		$("#LocGrpList").datagrid("reload",{GrpID:''});
	}else{
		/// 院内科室
		$("#dgCstDetList").datagrid("reload",{GrpID:''});
		//$("#dgCstDetList").datagrid('loadData',{total:0,rows:[]});
	}
}

/// 链接
function SetLocCellUrl(value, rowData, rowIndex){	
	var html = '<a href="#" onclick="delRow(\''+ rowIndex +'\',\''+ "LocGrpList" +'\')"><img src="../scripts/dhcnewpro/images/edit_remove.png" border=0/></a>';
	    //html += "<a href='#' onclick='insRow()'><img src='../scripts/dhcnewpro/images/edit_add.png' border=0/></a>";
	return html;
}

/// 初始化科室组列表
function InitLocGrpGrid(){
	
	///  定义columns
	var hideFlags=""
	if(CstID!=""){
	hideFlags="true"
		}
	var columns=[[
		{field:'LocID',title:'科室ID',width:100,align:'center',hidden:true},
		{field:'LocDesc',title:'科室',width:200,align:'center'},
		{field:'UserID',title:'医生ID',width:110,align:'center',hidden:true},
		{field:'UserName',title:'医生',width:120,align:'center'},
		{field:'PrvTpID',title:'职称ID',width:100,align:'center',hidden:true},
		{field:'PrvTp',title:'职称',width:160,align:'center',hidden:false},
		{field:'operation',title:"操作",width:100,align:'center',formatter:SetLocCellUrl,hidden:hideFlags}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		fitColumns:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		fit : false,
	    onDblClickRow: function (rowIndex, rowData) {
        }
	};
	/// 就诊类型
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+CstID+"&Type=I";
	new ListComponent('LocGrpList', columns, uniturl, option).Init();
}


/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {
	
	/// 自动分布
	onresize_handler();
}
window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })