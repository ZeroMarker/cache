//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2018-01-22
// 描述:	   会诊申请单
//===========================================================================================

var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var mradm = "";
var CstID = "";         /// 会诊申请ID
var CstItmID = "";      /// 会诊明细ID
var editSelRow = -1;
var isWriteFlag = "-1";
var seeCstType="false"; ///查看模式
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
/// 页面初始化函数
function initPageDefault(){

	InitPatEpisodeID();       /// 初始化加载病人就诊ID
	InitPatCstID();           /// 初始化会诊ID
	InitPageDataGrid();		  /// 初始化页面datagrid
	LoadDataGrid();
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	EpisodeID = getParam("EpisodeID");
	viewMode = getParam("EpisodeID");
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
	
	// 职称编辑格
	var PrvTpEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonPrvTp",
			valueField: "value", 
			textField: "text",
			editable:false,
			//panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTp'});
				$(ed.target).combobox('setValue', option.text);
			}
		}
	}
	
	// 科室编辑格
	var LocEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID"+session['LOGON.HOSPID'],
			valueField: "value", 
			textField: "text",
			mode:'remote',
			onSelect:function(option){
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				$(ed.target).val(option.value);
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				///设置级联指针
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				var unitUrl=LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocCareProv&LocID="+ option.value;
				$(ed.target).combobox('reload',unitUrl);
				
				/// 联系方式
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'TelPhone'});
				$(ed.target).val(GetLocTelPhone(option.value));
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
			onSelect:function(option){
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserID'});
				$(ed.target).val(option.value);
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', option.text);
				
				/// 联系方式
				var TelPhone = GetCareProvPhone(option.value);
				if (TelPhone != ""){
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'TelPhone'});
					$(ed.target).val(TelPhone);
				}
				
			}
		}
	}
	
	///  定义columns
	var columns=[[
		{field:'PrvTpID',title:'职称ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'PrvTp',title:'职称',width:120,editor:PrvTpEditor,align:'center'},
		{field:'LocID',title:'科室ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'LocDesc',title:'科室',width:260,editor:LocEditor,align:'center'},
		{field:'UserID',title:'医生ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'UserName',title:'医生',width:160,editor:DocEditor,align:'center'},
		{field:'TelPhone',title:'联系方式',width:130,editor:texteditor,align:'center'},
		{field:'operation',title:"操作",width:110,align:'center',
			formatter:SetCellUrl}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		onClickRow:function(rowIndex, rowData){

	    },
	    onDblClickRow: function (rowIndex, rowData) {

            if ((editSelRow != -1)||(editSelRow == 0)) { 
                $("#dgCstDetList").datagrid('endEdit', editSelRow); 
            } 
            $("#dgCstDetList").datagrid('beginEdit', rowIndex); 

            editSelRow = rowIndex; 
        }
	};
	/// 就诊类型
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMConsultQuery&MethodName=JsonQryConsult&CstID="+"";
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

	/// 行对象
    var rowObj={PrvTpID:'', PrvTp:'', LocID:'', LocDesc:'', UserID:'', UserName:''};
	
	/// 当前行数大于4,则删除，否则清空
	if(rowIndex=="-1"){
		$.messager.alert("提示:","请先选择行！");
		return;
	}
	
	var rows = $('#dgCstDetList').datagrid('getRows');
	if(rows.length>4){
		 $('#dgCstDetList').datagrid('deleteRow',rowIndex);
	}else{
		$('#dgCstDetList').datagrid('updateRow',{index:rowIndex, row:rowObj});
	}
	
	// 删除后,重新排序
	//$('#dgCstDetList').datagrid('sort', {sortName: 'No',sortOrder: 'desc'});
}

/// 插入空行
function insRow(){
	
	var rowObj={PrvTpID:'', PrvTp:'', LocID:'', LocDesc:'', UserID:'', UserName:''};
	$("#dgCstDetList").datagrid('appendRow',rowObj);
}

/// 发送病理申请
function SaveCstNo(){
    
    if ((editSelRow != -1)||(editSelRow == 0)) { 
        $("#dgCstDetList").datagrid('endEdit', editSelRow); 
    }
    
	var ConsTrePro = $("#ConsTrePro").val();  		/// 简要病历
	if (ConsPurpose == ""){
		$.messager.alert("提示:","本次会诊病人简要病历不能为空！");
		return;
	}
	var ConsPurpose = $("#ConsPurpose").val();  	/// 会诊目的
	if (ConsPurpose == ""){
		$.messager.alert("提示:","本次会诊目的不能为空！");
		return;
	}
	var ConsNote = $("#ConsNote").val();  			/// 备注
	
	var CsRUserID = session['LOGON.USERID'];  		/// 申请科室
	var CsRLocID = session['LOGON.CTLOCID'];  		/// 申请人
	
	var ConsEmFlag = $("input[name='CstType']:checked").val();    /// 会诊类型
	var ConsUnitFlag =  $("input[name='CstUnit']:checked").val(); /// 院内院外

	var CstDate = $HUI.datebox("#CstDate").getValue();      /// 会诊日期
	var CstTime = $HUI.timespinner("#CstTime").getValue();  /// 会诊时间
	
	var CstUnit = $("#CstUnit").val(); /// 外院名称
	var CstDoc = $("#CstDoc").val();   /// 外院医师
	var CstUser = $("#CstUser").val();   /// 联系人
	var CstTele = $("#CstTele").val();   /// 联系电话
	
	var ShareFlag = $HUI.checkbox("#ShareFlag").getValue()?"Y":"";  /// 是否共享
	
	var mListData = EpisodeID +"^"+ CsRUserID +"^"+ CsRLocID +"^"+ ConsTrePro +"^"+ ConsPurpose +"^"+ "" +"^"+ "" +"^"+ "";
		mListData += "^"+ CstDate +"^"+ CstTime +"^"+ ConsEmFlag +"^"+ ConsUnitFlag +"^"+ CstUnit +"^"+ CstDoc +"^"+ ConsNote +"^"+ CstUser +"^"+ CstTele +"^"+ ShareFlag;

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
	if (ConsDetList == ""){
		$.messager.alert("提示:","会诊科室不能为空！");
		return;	
	}
	
	///             主信息  +"&"+  会诊科室
	var mListData = mListData +"&"+ ConsDetList;

	/// 保存
	runClassMethod("web.DHCEMConsult","Insert",{"CstID":CstID, "mListData":mListData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请保存失败，失败原因:"+jsonString);
		}else{
			CstID = jsonString;
			LoadReqFrame(CstID)
			$.messager.alert("提示:","保存成功！");
			/// 调用父框架函数
		    window.parent.frames.reLoadEmPatList();
		}
	},'',false)
}

/// 加载会诊申请主信息内容
function GetCstNoObj(CstID){
	
	runClassMethod("web.DHCEMConsultQuery","JsGetCstNoObj",{"ItmID":CstItmID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			InsCstNoObj(jsonObjArr);
		}
	},'json',false)
}

/// 设置会诊申请单内容
function InsCstNoObj(itemobj){
	
	$("#ConsTrePro").val(itemobj.CstTrePro);  		/// 简要病历
	$("#ConsPurpose").val(itemobj.CstPurpose);  	/// 会诊目的
	$("#ConsNote").val(itemobj.CstRemark);  		/// 备注
	$("#CstUnit").val(itemobj.CstUnit);             /// 外院名称
	$("#CstDoc").val(itemobj.CstDocName);   	    /// 外院医师
	$("#CstUser").val(itemobj.CstUser);   		    /// 联系人
	$("#CstTele").val(itemobj.CstPhone);   		    /// 联系电话
	$("#CstRLoc").val(itemobj.CstRLoc);   		    /// 申请科室
	$("#CstRDoc").val(itemobj.CstUser);   		    /// 申请医师
	$("#ConsOpinion").val(itemobj.CstOpinion);      /// 会诊意见 
	/// 会诊类型
	$HUI.radio("input[name='CstType'][value='"+ itemobj.CstEmFlag +"']").setValue(true);
	/// 院内院外
	$HUI.radio("input[name='CstUnit'][value='"+ itemobj.CstOutFlag +"']").setValue(true);

	$HUI.datebox("#CstDate").setValue(itemobj.CstNDate);      /// 会诊日期
	$HUI.timespinner("#CstTime").setValue(itemobj.CstNTime);  /// 会诊时间
	
	$HUI.checkbox("#ShareFlag").setValue(itemobj.ShareFlag=="Y"?true:false); /// 是否共享
}

/// 发送
function SendCstNo(){

	runClassMethod("web.DHCEMConsult","SendCstNo",{"CstID": CstID,"LgParam":LgParam},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单已发送，不能再次发送！");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请发送失败，失败原因:"+jsonString);
		}else{
			CstID = jsonString;
			$.messager.alert("提示:","发送成功！");
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)
}

/// 取消
function CanCstNo(){
	
	runClassMethod("web.DHCEMConsult","CanCstNo",{"CstID":CstID, "UserID":session['LOGON.USERID']},function(jsonString){

		if (jsonString == -1){
			$.messager.alert("提示:","申请单当前状态，不允许进行确认操作！");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请取消失败，失败原因:"+jsonString);
		}else{
			$.messager.alert("提示:","取消成功！");
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)
}

/// 确认
function SureCstNo(){
	
	runClassMethod("web.DHCEMConsult","SureCstNo",{"ItmID":CstItmID, "UserID":session['LOGON.USERID']},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单当前状态，不允许进行确认操作！");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请确认失败，失败原因:"+jsonString);
		}else{
			$.messager.alert("提示:","确认成功！");
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)
}

/// 接受
function AcceptCstNo(){

	runClassMethod("web.DHCEMConsult","AcceptCstNo",{"ItmID": CstItmID, "UserID":session['LOGON.USERID']},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单非待接收状态，不允许进行接收操作！");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请接受失败，失败原因:"+jsonString);
		}else{
			$.messager.alert("提示:","接受成功！");
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// 拒绝
function RefCstNo(){
	
	runClassMethod("web.DHCEMConsult","RefCstNo",{"ItmID": CstItmID, "UserID":session['LOGON.USERID']},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单当前所在状态，不允许进行拒绝操作！");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请拒绝失败，失败原因:"+jsonString);
		}else{
			$.messager.alert("提示:","拒绝成功！");
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// 到达
function AriCstNo(){
	
	runClassMethod("web.DHCEMConsult","AriCstNo",{"ItmID": CstItmID, "UserID":session['LOGON.USERID']},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单当前状态，不允许进行到达操作！");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请到达失败，失败原因:"+jsonString);
		}else{
			$.messager.alert("提示:","到达成功！");
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// 完成
function CompCstNo(){
	
	var ConsOpinion = $("#ConsOpinion").val();
	if (ConsOpinion == ""){
		$.messager.alert("提示:","请填写会诊意见！");
		return;
	}
	
	runClassMethod("web.DHCEMConsult","CompCstNo",{"ItmID": CstItmID, "LgParam":LgParam, "CstOpinion":ConsOpinion},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单当前状态，不允许进行完成操作！");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请完成失败，失败原因:"+jsonString);
		}else{
			$.messager.alert("提示:","完成成功！");
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// 会诊弹出窗体  用于医嘱录入和病历查看
function OpenPupWin(){
	
	var frm = dhcsys_getmenuform();
	if (frm) {
		PatientID = frm.PatientID.value;
		EpisodeID = frm.EpisodeID.value;
		mradm = frm.mradm.value;
	}
	var link = "dhcem.consultpupwin.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm;
	window.open(link,"_blank","height=600, width=1100, top=30, left=100,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
}

/// 打印
function PrintCst(){
	
	PrintCst_REQ(CstID);
}

/// 取科室电话
function GetLocTelPhone(LocID){
	
	var TelPhone = "";
	runClassMethod("web.DHCEMConsultQuery","GetLocTelPhone",{"LocID":LocID},function(jsonString){

		if (jsonString != ""){
			TelPhone = jsonString;
		}
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

/// 加载申请单内容
function LoadReqFrame(arCstID, arCstItmID){

	CstID = arCstID;
	CstItmID = arCstItmID;
	GetCstNoObj(arCstID);  	      /// 加载会诊申请
	isShowPageButton(arCstID);    /// 动态设置页面显示的按钮内容
	$("#dgCstDetList").datagrid("load",{"CstID":arCstID});      /// 会诊科室
}

/// 动态设置页面显示的按钮内容
function isShowPageButton(CstID){
	
	if(seeCstType){
		$("#OpBtns").hide();
		return;	
	}
	
	runClassMethod("web.DHCEMConsultQuery","GetCstPageBtFlag",{"CstID":CstID, "LgUserID":session['LOGON.USERID'], "LgLocID":session['LOGON.CTLOCID']},function(jsonString){

		if (jsonString != ""){
			var BTFlag = jsonString;
			HidePageButton(BTFlag);
		}
	},'',false)
}

/// 隐藏按钮
function HidePageButton(BTFlag){

	if (BTFlag == 1){
		$("#bt_acc").hide();   /// 接收
		$("#bt_ref").hide();   /// 拒绝
		$("#bt_arr").hide();   /// 到达
		$("#bt_com").hide();   /// 完成
		$("#bt_ord").hide();   /// 医嘱录入
		
		$("#bt_save").show();  /// 保存
		$("#bt_send").show();  /// 发送
		$("#bt_can").show();   /// 取消
		$("#bt_sure").show();  /// 确认
	}
	if (BTFlag == 2){
		$("#bt_save").hide();  /// 保存
		$("#bt_send").hide();  /// 发送
		$("#bt_can").hide();   /// 取消
		$("#bt_sure").hide();  /// 确认
		
		$("#bt_acc").show();   /// 接收
		$("#bt_ref").show();   /// 拒绝
		$("#bt_arr").show();   /// 到达
		$("#bt_com").show();   /// 完成
		$("#bt_ord").show();   /// 医嘱录入
	}
	if (BTFlag == 3){
		$("#bt_save").hide();  /// 保存
		$("#bt_send").hide();  /// 发送
		$("#bt_can").hide();   /// 取消
		$("#bt_sure").hide();  /// 确认
		$("#bt_com").hide();   /// 完成
		$("#bt_acc").hide();   /// 接收
		$("#bt_ref").hide();   /// 拒绝
		$("#bt_arr").hide();   /// 到达
		$("#bt_ord").hide();   /// 医嘱录入
	}
}

/// 加载申请单内容:新增单一界面显示内容：这种情况是只能提供查看(window.open时可调用)
function InitPatCstID(){
	CstID = getParam("arCstID");
	CstItmID = getParam("arCstItmID");
	if(CstID=="") return;       /// 为空不加载任何东西
	seeCstType=true;            /// 是否查看模式 
	GetCstNoObj(CstID);  	    /// 加载会诊申请
	isShowPageButton(CstID);    /// 动态设置页面显示的按钮内容
}

function LoadDataGrid(){
	if(seeCstType){
		$("#dgCstDetList").datagrid("load",{"CstID":CstID});      /// 会诊科室	
	}
}


/// JQuery 初始化页面
$(function(){ initPageDefault(); })