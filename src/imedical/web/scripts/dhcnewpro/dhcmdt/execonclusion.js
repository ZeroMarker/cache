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
var LgUserCode = session['LOGON.USERCODE'];
var LgUserName = session['LOGON.USERNAME']
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID;
var YnTableOk=false,ZnTableOk=false;
var cancelFlag="N";

/// 页面初始化函数
function initPageDefault(){
	InitPatEpisodeID();       /// 初始化加载病人就诊ID
	//LoadMoreScr();
	//SeletOrdTab();
	InitPageComponent(); 	  /// 初始化界面控件内容
	InitPageDataGrid();		  /// 初始化页面datagrid
	InitLocGrpGrid();
	InitOuterExpGrid();
	SetMdtDiscuss();
	InitRoomEvent();
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){

	PatientID = getParam("PatientID");   /// 病人ID
	EpisodeID = getParam("EpisodeID");   /// 就诊ID
	CstID = getParam("ID");   			 /// 会诊ID
	mradm = getParam("mradm");           /// 就诊诊断ID
	WriType = getParam("WriType");       /// 操作类型
	showModel = getParam("showModel");
	bizCode = "onMDTChat";
	bizId = CstID;
	
	IsOpenMoreScreen=0  //标库都是写死的
	if(IsOpenMoreScreen){
		MWScreens=top.MWScreens
	
	}else{
		$("#bt_openVc").hide();
		}
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
		if(CONSDISRUL==1){
			$("#mdtDiscuss").attr("disabled", true);  /// 会诊讨论
		}else{
			$("#mdtDiscuss").attr("disabled", false);  /// 会诊讨论
		}
		$("#mdtPurpose").attr("disabled", true);  /// 会诊目的
		$("#mdtOpinion").attr("disabled", false); /// 会诊意见
	}
	/// 是否可编辑
	if(showModel == 3){
		$("#bt_grpaddloc").hide();
		$("#bt_grpcencel").hide();	
	}
	
	var RetData=$.cm({ 
		ClassName:"web.DHCMDTMatReview",
		MethodName:"GetPageData",
		MdtID:CstID,
		LgParams:LgParam,
		dataType:"text"
	}, false);
	var RetDataArr=RetData.split("^");
	///联络人
	IsContact=RetDataArr[1];
	ConsSatatus=RetDataArr[0];
	IsConsExperts=RetDataArr[2];
	CstStatusCode=RetDataArr[4];
	IsHideEdit=((CstStatusCode==80)||(CONSDISRUL!=1))
	IsHideSign=((CstStatusCode!=80)||(CAFLAG!=1))
}

///开启会议监听
function InitRoomEvent(){
	AddMonitor();
	SendInRoom();	
}

/// 初始化界面控件内容
function InitPageComponent(){
	
	if((MDCONTACTSFLAG=="1")&&(IsContact!="Y")){
		//$("#bt_cancel").linkbutton('disable');	
		$("#bt_send").linkbutton('disable');
		$("#bt_save").linkbutton('disable');
		if(showModel!=="3"){		///查看模式
			$.messager.alert("提示:","非会诊联络人,无法进行完成操作!");
		}
	}

	if(CONSDISRUL==1){
		$("#mdtDiscuss").attr("placeholder","会诊专家列表会诊讨论列,点击逐个专家填写!");
	}

	runClassMethod("web.DHCMDTConsultQuery","JsGetMdtObj",{"ID":CstID},function(jsonString){
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			InsCstNoObj(jsonObjArr);
		}
	})
}

function InitMdtDiscussTemp(){
	
	if(CONSDISRUL==1) return;
	
	if((!YnTableOk)||(!ZnTableOk)) return;
	
	var mdtDisc =$("#mdtDiscuss").val();
	var locGrpListData=$("#LocGrpList").datagrid("getData").rows;
	var dgCstDetListData=$("#dgCstDetList").datagrid("getData").rows;
	
	
	if(mdtDisc==""){
		for (i in locGrpListData){
			if(locGrpListData[i].UserName=="") continue;
			mdtDisc=mdtDisc+locGrpListData[i].LocDesc+locGrpListData[i].UserName+":"+"\r\n\n";
		}
		for (i in dgCstDetListData){
			if(dgCstDetListData[i].UserName=="") continue;
			mdtDisc=mdtDisc+dgCstDetListData[i].LocDesc+dgCstDetListData[i].UserName+":"+"\r\n\n";
		}
		$("#mdtDiscuss").val(mdtDisc);
	}
	return;
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
	//$("#mdtDiscuss").val(itemobj.DisProcess);	    /// 会诊讨论
	$("#mdtSuppsnote").val(itemobj.suppnotes);	    /// 会诊讨论
	$HUI.radio("input[name='mdtTumorFlag'][value='"+ itemobj.TumStage +"']").setValue(true); /// 肿瘤状态
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
			url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonPrvTp"+"&MWToken="+websys_getMWToken(),
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
				var unitUrl = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocList&LType="+LType+"&LocID="+LgLocID+"&HospID="+LgHospID+"&MWToken="+websys_getMWToken();
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
				var unitUrl=$URL+"?ClassName=web.DHCEMConsLocItem&MethodName=JsonSubMar&LocID="+ LocID+"&MWToken="+websys_getMWToken();
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
				var unitUrl=$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocCareProv&ProvType=DOCTOR&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&LgUserID="+ LgUserID+"&MWToken="+websys_getMWToken();
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
		{field:'HosID',title:'HosID',width:100,editor:texteditor,align:'left',hidden:true},
		{field:'HosType',title:'院内院外',width:110,editor:HosEditor,align:'left',hidden:true},
		{field:'LocID',title:'科室ID',width:100,editor:texteditor,align:'left',hidden:true},
		{field:'LocDesc',title:'科室',width:200,editor:LocEditor,align:'left'},
		{field:'UserID',title:'医生ID',width:110,editor:texteditor,align:'left',hidden:true},
		{field:'UserName',title:'医生',width:120,editor:DocEditor,align:'left'},
		{field:'PrvTpID',title:'职称ID',width:100,editor:texteditor,align:'left',hidden:true},
		{field:'PrvTp',title:'职称',width:160,editor:PrvTpEditor,align:'left',hidden:false},
		{field:'CASign',title:"CA签名",width:80,align:'left',formatter:SetCASignCellUrl,hidden:IsHideSign},
		{field:'EditAndView',title:"会诊讨论",width:80,align:'left',formatter:SetEditViewCellUrl,hidden:IsHideEdit}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		fitColumns:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		fit : false,
		border:true,
		bodyCls:'panel-header-gray',
		headerCls:'panel-header-gray',
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
			YnTableOk=true;
			InitMdtDiscussTemp();
        }
	};
	/// 就诊类型
	//var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+CstID;
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+CstID+"&Type=O"+"&MWToken="+websys_getMWToken();
	new ListComponent('dgCstDetList', columns, uniturl, option).Init();
}


//MDT专家会诊讨论
function SetEditViewCellUrl(value, rowData, rowIndex){
	var ItmID=rowData.itmID;
	var UserID=rowData.UserID;
	var CsUserID=rowData.CsUserID;
	var LocID=rowData.LocID;
	if(ItmID=="") {return;}
	//if(CsUserID!=LgUserID) {return;} ///自己点击自己的意见
	
	var Text=rowData.HasOpinion=="1"?"<span style='color:#000;'>修改</span>":"填写";
	var Html="";
	if((MDCONTACTSFLAG=="1")&&(IsContact!="Y")){
		Html="<a href='#' style='color:#b7b7b7;'>"+Text+"</a>";
	}else{
		Html="<a href='#' onclick=\"showEditWin('"+ItmID+"','"+UserID+"','"+LocID+"','')\">"+Text+"</a>";	
	}
	return Html;
	
	/*
	var itmCodes = "80";	
	if (GetIsTakOperFlag(rowData.ID, itmCodes)=="1"){	///已经完成,未签名可以修改
		if(LgLocID==LocID){   //会诊医生
			return "<a href='#' onclick=\"showEditWin('"+ItmID+"','"+UserID+"','"+LocID+"')\">意见填写</a>";
		}
	}
	*/
	return "";
}


//专家是否已经签过名了
function IsgetsignmdtSIGNID(ItmID)
{  
    var IsCASign = "";
	runClassMethod("web.DHCMDTSignVerify","IsgetsignmdtSIGNID",{"mdtID":ItmID},function(jsonString){
		IsCASign = jsonString;     
	},'',false)
	return IsCASign;
	
}


/// 会诊讨论
function showEditWin(ItmID,UserID,LocID,IsCaSign){
		
	//专家是否已经签过名了
	var IsCASign=IsgetsignmdtSIGNID(ItmID)
	if(IsCASign==1){
		$.messager.alert("提示", "会诊专家已经签名,不能修改会诊讨论内容！","warning")	
	    return;
	}
	
	var Link = "dhcmdt.consopinion.csp?ItmID="+ItmID+"&CsStatCode="+CsStatCode+"&UserID="+UserID+"&LocID="+LocID +"&CstID="+CstID+"&IsCaSign="+IsCaSign;
	commonShowWin({
		url: Link,
		title: "会诊讨论",
		width: 820,
		height: 490
	})	
}

/// 当前用户权限
function GetIsPerFlag(CstID){

	var IsPerFlag = ""; /// 是否允许修改
	runClassMethod("web.DHCMDTFolUpVis","GetIsPerFlag",{"CstID":CstID,"LgParam":LgParam},function(jsonString){
		if (jsonString != ""){
			IsPerFlag = jsonString;
		}
	},'',false)
	return IsPerFlag
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
	
	///暂存
	if (OperFlag=="S"){
		if((!mdtOpinion.replace(/\s/g,''))&&(!mdtDiscuss.replace(/\s/g,''))){
			$.messager.alert("提示:","请填写会诊讨论和意见！","warning");
			return;
		}
	}
	
	if(!OperFlag){
		if(!mdtOpinion.replace(/\s/g,'')){
			$.messager.alert("提示:","请填写会诊意见！","warning");
			return;	
		}
	}
	
	var InWriType = (OperFlag == "S"?"S":WriType);
	
	mdtOpinion = $_TrsSymbolToTxt(mdtOpinion); /// 处理特殊符号
	
	/// 会诊科室
	var ConsDetArr=[];
	/*
	var rowData = $('#dgCstDetList').datagrid('getRows');
	$.each(rowData, function(index, item){
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID;
		    ConsDetArr.push(TmpData);
		}
	})
	*/
	var ConsDetList = ConsDetArr.join("@");
	
	var mdtTumorFlag = $("input[name='mdtTumorFlag']:checked").val();   /// 肿瘤状态
	if (typeof CstEvaRFlag == "undefined"){mdtTumorFlag == ""}
	
	var mListData = mdtTrePro +"^"+ mdtPurpose +"^"+ mdtOpinion +"^"+ mdtDiscuss +"^"+mdtSuppsnote+"^"+ConsDetList+"^"+mdtTumorFlag;
	
	runClassMethod("web.DHCMDTConsult","CompCstNo",{"CstID": CstID, "WriType":InWriType, "LgParam":LgParam, "mListData":mListData},function(jsonString){
		
		if(jsonString==0){
			if (OperFlag == "S"){
				$.messager.alert("提示:","保存成功！","info");
			}else{
				CompCstNoFun(CstID);
			}	
		}else{
			$.messager.alert("提示:","失败,信息:"+jsonString,"info");			
		}
	},'',false)	
}

function CompCstNoFun(){
	var RetData=$.cm({ 
		ClassName:"web.DHCMDTConsultQuery",
		MethodName:"OpenEmrData",
		CstID:CstID,
		dataType:"text"
	}, false);
	var RetDataArr=RetData.split("^");
	var EpisodeID=RetDataArr[0];
	var InstanceID=RetDataArr[1];

	if(COMPISOPEEMR==1){
		///&DisplayType=&NavShowType=&RecordShowType=
		var url="emr.interface.ip.mdtconsult.csp?EpisodeID="+EpisodeID+"&InstanceID="+InstanceID+
				"&FromCode="+CstID+"&CTlocID="+LgLocID+"&UserID="+LgUserID+"&ShowNav=N"+"&MWToken="+websys_getMWToken();
		window.open(url,"_blank","height="+(window.screen.availHeight-80)+"px,width="+window.screen.availWidth-100+"px, top=30, left=100,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
	}
	window.parent.reLoadMainPanel(EpisodeID);	
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
	$(".container").height(Height - 250);
	$(".p-content").height(Height - 250);
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

function ReloadTable(){
	$("#LocGrpList").datagrid("reload");
	$("#dgCstDetList").datagrid("reload");
	$("#OuterExpList").datagrid("reload");
	SetMdtDiscuss();
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
		{field:'LocID',title:'科室ID',width:100,align:'left',hidden:true},
		{field:'LocDesc',title:'科室',width:200,align:'left'},
		{field:'UserID',title:'医生ID',width:110,align:'left',hidden:true},
		{field:'UserName',title:'医生',width:120,align:'left'},
		{field:'PrvTpID',title:'职称ID',width:100,align:'left',hidden:true},
		{field:'PrvTp',title:'职称',width:160,align:'left',hidden:false},
		{field:'CASign',title:"CA签名",width:80,align:'left',formatter:SetCASignCellUrl,hidden:IsHideSign},
		{field:'EditAndView',title:"会诊讨论",width:80,align:'left',formatter:SetEditViewCellUrl,hidden:IsHideEdit},
		{field:'operation',title:"操作",width:100,align:'left',formatter:SetLocCellUrl,hidden:hideFlags}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		fitColumns:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		fit : false,
		border:true,
		bodyCls:'panel-header-gray',
		headerCls:'panel-header-gray',
	    onDblClickRow: function (rowIndex, rowData) {
        
        },
        onLoadSuccess: function (data) { //数据加载完毕事件
			ZnTableOk=true;
			InitMdtDiscussTemp();
        }
	};
	/// 就诊类型
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+CstID+"&Type=I"+"&MWToken="+websys_getMWToken();
	new ListComponent('LocGrpList', columns, uniturl, option).Init();
}



/// 初始化外院专家列表
function InitOuterExpGrid(){
	
	var columns=[[
		{field:'LocID',title:'科室ID',width:100,align:'left',hidden:true},
		{field:'LocDesc',title:'科室',width:200,align:'left'},
		{field:'UserID',title:'医生ID',width:110,align:'left',hidden:true},
		{field:'UserName',title:'医生',width:120,align:'left'},
		{field:'TelPhone',title:'联系方式',width:100,align:'left'},
		{field:'PrvTpID',title:'职称ID',width:100,align:'left',hidden:true},
		{field:'PrvTp',title:'职称',width:160,align:'left',hidden:false},
		{field:'EditAndView',title:"会诊讨论",width:80,align:'left',formatter:SetEditViewCellUrl,hidden:IsHideEdit}
	]];
	
	///  定义datagrid
	var option = {
		fitColumns:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		fit : false,
		border:true,
		bodyCls:'panel-header-gray',
		headerCls:'panel-header-gray',
	    onClickRow: function (rowIndex, rowData) {  
        }
	};
	/// 就诊类型
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+CstID+"&Type=E"+"&MWToken="+websys_getMWToken();
	new ListComponent('OuterExpList', columns, uniturl, option).Init();
}

function SetMdtDiscuss(){
	$.cm({ 
		ClassName:"web.DHCMDTConsultQuery",
		MethodName:"GetMdtDiscuss",
		MdtID:CstID,
		Type:CONSDISRUL,
		dataType:"text"
	},function(retData){
		retData=retData.replace(new RegExp('<br>',"g"),'\n')
		$("#mdtDiscuss").val(retData);
	});
}

function SetCASignCellUrl(value, rowData, rowIndex){
	var ItmID=rowData.itmID
	var UserID=rowData.UserID
	var LocID=rowData.LocID
	if(ItmID=="") {return;}
	
	if(rowData.CaImage!=""){
		return '<img onclick=\'showEditWin("'+ItmID+'","'+UserID+'","'+LocID+'","1")\' style="height: 30px;width: 100%;" src="data:image/jpg;base64,'+rowData.CaImage+'"/>'
	}
	
	if((rowData.LocID==LgLocID)&&(rowData.CsUserID==LgUserID)){
		return "<a href='#' onclick=\"showEditWin('"+ItmID+"','"+UserID+"','"+LocID+"','1')\">签名</a>";	
	}
	return "";
}

/// 是否允许操作
function GetIsTakOperFlagNew(CstID, ToStCode){
	var Ret=$.cm({ 
		ClassName:"web.DHCMDTConsult",
		MethodName:"ValidStatus",
		ID:CstID,ToStatusIdCode:ToStCode,
		dataType:"text"
	}, false);
	return Ret;
}


function AddMonitor(){
	websys_on(bizCode+bizId,function(data){ /*进入房间后才能监听房间消息*/
		console.log(data);
		if (data.eventType=='join'){
			console.log(data.fromUser +"加入->"+data.toUser+"房间号");
		}else if (data.eventType=='leave'){
			console.log(data.username +"离开->"+data.toUser+"房间号");
		}else{
			console.log("收到->房间号："+data.extend.opt.usercode+":"+data.usercode+":"+data.toUser+", 文本内容："+data.extend.opt.content);
			
			if(data.extend.opt.ParCode==="ConsTalk"){
				jumpDiscuss(data.extend.opt.CstID);
			}else{
				saveMdtOp(data.extend.opt.usercode,data.extend.opt.content);
			}
		}
	});	
	
	window.onunload = function(){
		//websys_leaveChatRoom(bizCode,bizId);
	};
}

function mdtOpenVc(){
	var Obj={
		PatientID:PatientID,
		EpisodeID:EpisodeID,
		ID:CstID
	}
	//websys_emit("onMdtOpenVideo",Obj); ///开启视频会议
	//var url=window.location.origin+"/imedical/web/csp/dhcmdt.videocall.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&ID="+CstID;
	var url="https://ai.imedway.cn/trtc?u="+LgUserID+"&r="+CstID+"&auto=1";
	chromeOpen(url);
	
	$.messager.confirm("提示","是否推送会议链接给所有会诊专家?",function(r){
		if(r){
			sendVcUrl(CstID);
		}
	});
	return;		
}


function chromeOpen(urlParam){
	
	exec('"C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe" "'+urlParam+'"');
	exec('"C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe" "'+urlParam+'"');
	exec('"C:\\Users\\sun_h\\AppData\\Local\\Google\\Chrome\\Application\\chrome.exe" "'+urlParam+'"');
	
	return;
	
	if(!IsOpenMoreScreen){
		websys_showModal({
			url:urlParam,
			title:"多学科视频",
			iconCls:"icon-w-paper",
			width:$(window).width()-200,
			height:$(window).height()-200,
			onClose: function() {	
			}
		});	
	}
	
	
	///没有副屏幕
	/*
	if(MWScreens.screens.length==1) {
		exec('"C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe" "'+urlParam+'"');
		var ex = "ScreenMax"
		setTimeout(function(){
			CMgr.moveWindow("",0,0,MWScreens.screens[0].WorkingArea.Width,MWScreens.screens[0].WorkingArea.Height,ex);
		},500);	
		return;
	}
	*/
	
	var scPos=2; ///第?副屏
	MWScreens.length==2?scPos=1:""; ///第一副屏,没有第二副屏
	
	var scWidthPos=MWScreens.screens[0].Bounds.Width+1;
	scPos==2?(scWidthPos=scWidthPos+MWScreens.screens[1].Bounds.Width):"";
	var scWidth=MWScreens.screens[scPos].WorkingArea.Width;
	var scHeight=MWScreens.screens[scPos].WorkingArea.Height;

	exec('"C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe" "'+urlParam+'"');
	var ex = "ScreenMax"
	setTimeout(function(){
		CMgr.moveWindow("",scWidthPos,0,scWidth,scHeight,ex);
	},500);	
}

function sendVcUrl(){
	$.cm({ 
		ClassName:"web.DHCMDTConsult",
		MethodName:"SendVcUrl",
		MdtID:CstID,
		LgParams:LgParam,
		dataType:"text"
	},function(ret){
		$.messager.alert("提示:","消息推送完成!");
		return;
	});	
}

function SendInRoom(){
	websys_emit(bizCode,{type:"cross-device",bizId:bizId,content:LgUserCode+"("+LgUserName+")进入了"+bizId+"房间",mdt:""});	
}

function jumpDiscuss(CstID){
	var url="dhcmdt.consdiscuss.csp?CstID="+CstID; ///
	var _opWin=window.open("",bizCode+bizId+"Win");
	if(_opWin) _opWin.close();
	window.location.href=url;
}

function openTemp(){
	var url="dhcmdt.constemp.csp?mark=O"
	//window.open(url,"_blank","height="+(window.screen.availHeight-80)+"px,width="+window.screen.availWidth-100+"px, top=30, left=100,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
	window.open(url,"_blank","height=600px,width=1100px, top=200, left=300,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
}

function tempValue(mark,value){
	var mdtOpinion=$('#mdtOpinion').val();
	var mdtOpinion=mdtOpinion+(mdtOpinion==''?'':'\n')+value;
	$('#mdtOpinion').val(mdtOpinion);
	return;
}

function saveMdtOp(userCode,mdtOpinion){
	
	$.cm({ 
		ClassName:"web.DHCMDTConsult",
		MethodName:"UpdConItmOpionUserCode",
		MdtID:CstID,
		UserCode:userCode,
		MdtOpinion:mdtOpinion,
		dataType:"text"
	},function(ret){
		if (ret < 0){
			$.messager.alert("提示:","保存失败！","warning");
		}else{
			ReloadTable()
		}
		return;
	});		
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