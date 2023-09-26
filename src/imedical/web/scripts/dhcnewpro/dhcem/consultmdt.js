//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2018-01-22
// 描述:	   会诊申请单
//===========================================================================================
var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var CstID = "";         /// 会诊申请ID
var editSelRow = -1;
var isEditFlag = 0;     /// 页面是否可编辑
var LType = "CONSULT";  /// 会诊科室代码
var CsRType = "MDT";    /// 会诊类型  医生
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
/// 页面初始化函数
function initPageDefault(){
	InitPatEpisodeID();       /// 初始化加载病人就诊ID
	InitPageComponent(); 	  /// 初始化界面控件内容
	InitPageDataGrid();		  /// 初始化页面datagrid
	HidePageButton(5);		  /// 初始化界面按钮
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	
	PatientID = getParam("PatientID");
	EpisodeID = getParam("EpisodeID");
	if (EpisodeID == ""){
		$("#openemr").hide();
	}
}

/// 初始化界面控件内容
function InitPageComponent(){
	
	/// 默认平会诊
	$HUI.radio("input[name='CstEmFlag'][value='N']").setValue(true);

	/// 会诊类型
	var option = {
		panelHeight:"auto",
        onSelect:function(option){
	        if (option.text == "院际会诊"){
		    	//$('#CstLoc').combobox({disabled:false});
		    	//$('#CstHosp').combobox({disabled:false});
		    	$HUI.combobox("#CstLoc").enable();
		    	$HUI.combobox("#CstHosp").enable();
		    	isEditFlag = 1;		/// 行编辑标志
		    }else{
		    	$HUI.combobox("#CstHosp").disable();
		    	$HUI.combobox("#CstLoc").disable();
		    	isEditFlag = 0;		/// 行编辑标志
			}
	    },
	    onLoadSuccess: function () { //数据加载完毕事件
            var data = $('#CstType').combobox('getData');
             if (data.length > 0) {
                $("#CstType").combobox('select', data[0].value);
                $HUI.combobox("#CstType").disable();
            } 
        }
	};
	var url = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonCstType&HospID=" + LgHospID +"&LgUserID="+LgUserID;
	new ListCombobox("CstType",url,'',option).init();
	
	/// 医院
	var option = {
		panelHeight:"auto",
        onSelect:function(option){
	        if (option.text == "其他"){
		    	$("#CstUnit").attr("disabled", false);
		    }else{
		    	$("#CstUnit").val("").attr("disabled", true); 
			}
			
			$HUI.combobox("#CstLoc").setValue("");
			///设置级联指针
			var unitUrl = $URL+"?ClassName=web.DHCEMConsHosLoc&MethodName=JsonDicLoc&HospID="+option.value;
			$("#CstLoc").combobox('reload',unitUrl);
	    }
	};
	var url = $URL+"?ClassName=web.DHCEMConsDicItem&MethodName=jsonConsItem&mCode=HOS&HospID="+LgHospID;
	new ListCombobox("CstHosp",url,'',option).init();
	$HUI.combobox("#CstHosp").disable();  /// 医院不可用
	
	/// 科室
	var option = {
		panelHeight:"auto",
        onSelect:function(option){
	    }
	};
	var url = ""; //$URL+"?ClassName=web.DHCEMConsHosLoc&MethodName=JsonDicLoc&HospID="+LgHospID;
	new ListCombobox("CstLoc",url,'',option).init();
	$HUI.combobox("#CstLoc").disable();  /// 科室不可用
	
	/*
	/// 会诊病种
	var option = {
		panelHeight:"auto",
        onSelect:function(option){
	    }
	};
	var url = ""; //$URL+"?ClassName=web.DHCEMConsHosLoc&MethodName=JsonDicLoc&HospID="+LgHospID;
	new ListCombobox("CstDise",url,'',option).init();
	*/
}

/// 病人就诊信息
function GetPatBaseInfo(){
	
	runClassMethod("web.DHCEMConsultQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
			if (jsonObject.PatSex == "男"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/boy.png");
			}else{
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/girl.png");
			}
		})
	},'json',false)
}

/// 取登录信息
function GetLgContent(){

	runClassMethod("web.DHCEMConsultQuery","GetLgContent",{"LgLocID":LgLocID, "LgUserID":LgUserID},function(jsonObject){
		
		if (jsonObject != null){
			$('#CstRLoc').val(jsonObject.LocDesc);  /// 申请科室
			$('#CstRDoc').val(jsonObject.LgUser);   /// 申请医师
		}
	},'json',false)
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
	
	// 科室编辑格
	var LocEditor={
		type: 'combobox',//设置编辑格式
		options:{
			valueField: "value", 
			textField: "text",
			url: LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+LgHospID,
			onSelect:function(option) {
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				$(ed.target).val(option.value);
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				///设置级联指针
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'MarDesc'});
				var unitUrl=LINK_CSP+"?ClassName=web.DHCEMConsLocItem&MethodName=JsonSubMar&LocID="+ option.value;
				$(ed.target).combobox('reload',unitUrl);
				
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
	
	// 亚专业编辑格
	var MarEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			editable:false,
			onSelect:function(option){
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'MarID'});
				$(ed.target).val(option.value);
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'MarDesc'});
				$(ed.target).combobox('setValue', option.text);
				GetMarIndDiv(option.value); 	/// 取科室亚专业指征
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
		{field:'LocID',title:'科室ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'LocDesc',title:'科室',width:260,editor:LocEditor,align:'center'},
		{field:'MarID',title:'亚专业ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'MarDesc',title:'亚专业',width:200,editor:MarEditor,align:'center'},
		{field:'UserID',title:'医生ID',width:110,editor:texteditor,align:'center',hidden:true},
		{field:'UserName',title:'医生',width:120,editor:DocEditor,align:'center'},
		{field:'TelPhone',title:'联系方式',width:130,editor:texteditor,align:'center'},
		{field:'operation',title:"操作",width:100,align:'center',formatter:SetCellUrl}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		fitColumn:true,
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

            editSelRow = rowIndex;
        },
	    onLoadSuccess: function (data) { //数据加载完毕事件
            $("a[name='AddRow']").not("#"+(data.rows.length - 1)).hide();
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
	
	if (isEditFlag == 1) return;
	/// 行对象
    var rowObj={LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:''};
	
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
	
	GetMarIndDiv(""); 	/// 取科室亚专业指征
}

/// 插入空行
function insRow(){
	
	if (isEditFlag == 1) return;
    var rowObj={LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:''};
	$("#dgCstDetList").datagrid('appendRow',rowObj);
}

/// 发送病理申请
function SaveCstNo(){
    
    if ((editSelRow != -1)||(editSelRow == 0)) { 
        $("#dgCstDetList").datagrid('endEdit', editSelRow); 
    }
    
    var CstType = $HUI.combobox("#CstType").getValue();
	if (CstType == "") {
		$.messager.alert("提示:","会诊类型不能为空！");
		return;
	}
	
	var CstTrePro = $("#ConsTrePro").val();  		/// 简要病历
	if (CstTrePro == ""){
		$.messager.alert("提示:","病情摘要不能为空！");
		return;
	}
	var CstPurpose = $("#ConsPurpose").val();  	/// 会诊目的
	if (CstPurpose == ""){
		$.messager.alert("提示:","会诊理由及要求不能为空！");
		return;
	}
	
	var CsRUserID = session['LOGON.USERID'];  		/// 申请科室
	var CsRLocID = session['LOGON.CTLOCID'];  		/// 申请人
	
	var CstEmFlag = $("input[name='CstEmFlag']:checked").val();   /// 加急标识
	if (typeof CstEmFlag == "undefined"){
		CstEmFlag = "N";
	}

	var CstTypeID = $HUI.combobox("#CstType").getValue(); 	      /// 会诊类型
	var CstType = $HUI.combobox("#CstType").getText(); 	          /// 会诊类型
	var CstHospID = $HUI.combobox("#CstHosp").getValue(); 	      /// 外院
	var CstUnit = $HUI.combobox("#CstHosp").getText(); 	          /// 外院名称
	var CstDate = ""; //$HUI.datebox("#CstDate").getValue();      /// 会诊日期
	var CstTime = ""; //$HUI.timespinner("#CstTime").getValue();  /// 会诊时间
	
	var CstOutFlag = "N";                /// 是否外院
	if ($("#CstUnit").val() != ""){
		CstUnit = $("#CstUnit").val();   /// 外院名称
	}
	if (CstUnit != ""){ CstOutFlag = "Y"; }
	//var CstLoc = $("#CstLoc").val();     /// 外院科室
	var CstLoc = $HUI.combobox("#CstLoc").getText(); 	          /// 外院科室
	var CstUser = $("#CstUser").val();   /// 联系人
	var CstTele = $("#CstTele").val();   /// 联系电话
	var CstNote = "";  				     /// 备注
	var CstAddr = $("#CstAddr").val();   /// 会诊地点
	
	var mListData = EpisodeID +"^"+ CsRUserID +"^"+ CsRLocID +"^"+ CstTrePro +"^"+ CstPurpose +"^"+ CstTypeID +"^"+ CstAddr +"^"+ CsRType;
		mListData += "^"+ CstDate +"^"+ CstTime +"^"+ CstEmFlag +"^"+ CstOutFlag +"^"+ CstUnit +"^"+ CstLoc +"^"+ CstNote +"^"+ CstUser +"^"+ CstTele +"^"+ "";

	/// 会诊科室
	var ConsDetArr=[];
	var rowData = $('#dgCstDetList').datagrid('getRows');
	$.each(rowData, function(index, item){
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ "" +"^"+ item.MarID  ;
		    ConsDetArr.push(TmpData);
		}
	})

	if ((ConsDetArr.length == 1)&(CstType.indexOf("多科") != "-1")){
		$.messager.alert("提示:","会诊类型为多科会诊，至少选择两个及两个以上科室！");
		return;	
	}
	if ((ConsDetArr.length >= 2)&(CstType.indexOf("单科") != "-1")){
		$.messager.alert("提示:","会诊类型为单科会诊，不能选择多个科室！");
		return;	
	}
	
	var ConsDetList = ConsDetArr.join("@");
	if ((ConsDetList == "")&(CstOutFlag == "N")){
		$.messager.alert("提示:","会诊科室不能为空！");
		return;	
	}

	/// 亚专业指征
	var MarIndArr = [];
	$('input[name="MarInd"]:checked').each(function(){
		MarIndArr.push(this.value);
	})
	var MarIndList = MarIndArr.join("@");

	///             主信息  +"&"+  会诊科室  +"&"+  亚专业指征
	var mListData = mListData +"&"+ ConsDetList +"&"+ MarIndList;

	/// 保存
	runClassMethod("web.DHCEMConsult","Insert",{"CstID":CstID, "mListData":mListData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请保存失败，失败原因:"+jsonString);
		}else{
			CstID = jsonString;
			$.messager.alert("提示:","保存成功！");
		}
	},'',false)
}
/*
/// 发送
function SendCstNo(){

	runClassMethod("web.DHCEMConsult","SendCstNo",{"CstID": CstID, "UserID":session['LOGON.USERID']},function(jsonString){
		if (jsonString == -1){
			$.messager.alert("提示:","申请单已发送，不能再次发送！");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请发送失败，失败原因:"+jsonString);
		}else{
			$.messager.alert("提示:","发送成功！");
		}
	},'',false)
}
*/

/// 病历查看
function LoadPatientRecord(){
	
	var frm = dhcsys_getmenuform();
	if (frm) {
		PatientID = frm.PatientID.value;
		EpisodeID = frm.EpisodeID.value;
		mradm = frm.mradm.value;
	}
	
	var link = "emr.interface.browse.category.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID'];
	$("#newWinFrame").attr("src",link);
}


/// 加载会诊申请主信息内容
function GetCstNoObj(){

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
	$("#CstUser").val(itemobj.CstUser);   		    /// 联系人
	$("#CstTele").val(itemobj.CstPhone);   		    /// 联系电话
	$("#CstRLoc").val(itemobj.CstRLoc);   		    /// 申请科室
	$("#CstRDoc").val(itemobj.CstRUser);   		    /// 申请医师
	$("#ConsOpinion").val(itemobj.CstOpinion);      /// 会诊意见 

	/// 加急
	$HUI.radio("input[name='CstEmFlag'][value='"+ itemobj.CstEmFlag +"']").setValue(true);
	$HUI.combobox("#CstType").setValue(itemobj.CstTypeID);     /// 会诊类型
	$HUI.combobox("#CstType").setValue(itemobj.CstType);       /// 会诊类型
	
	if(itemobj.CstUnit != ""){
		$HUI.combobox("#CstHosp").setText(itemobj.CstUnit);    /// 外院
	}else{
		$HUI.combobox("#CstHosp").setText("");                 /// 外院
		$("#CstUnit").val(itemobj.CstUnit);                    /// 外院名称
	}
	if(itemobj.CstDocName != ""){
		$HUI.combobox("#CstLoc").setText(itemobj.CstDocName);  /// 外院科室
	}else{
		$HUI.combobox("#CstLoc").setText("");                  /// 外院科室
	}
	//$HUI.datebox("#CstDate").setValue(itemobj.CstNDate);      /// 会诊日期
	//$HUI.timespinner("#CstTime").setValue(itemobj.CstNTime);  /// 会诊时间
		
	$HUI.datebox("#ConsDate").setValue(itemobj.SysDate);      /// 系统日期
	$HUI.timespinner("#ConsTime").setValue(itemobj.SysTime);  /// 系统时间
	
	CsUserID = itemobj.CsUserID;  /// 会诊人员
	EpisodeID = itemobj.EpisodeID;
	
}

/// 发送
function SendCstNo(){

	runClassMethod("web.DHCEMConsult","SendCstNo",{"CstID": CstID, "UserID":session['LOGON.USERID']},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单已发送，不能再次发送！");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请发送失败，失败原因:"+jsonString);
		}else{
			CstID = jsonString;
			isShowPageButton(CstID);     /// 动态设置页面显示的按钮内容
			$.messager.alert("提示:","发送成功！");
			if (window.parent.reLoadMainPanel != undefined){
				window.parent.reLoadMainPanel(CstID);
			}
		}
	},'',false)
}

/// 取消
function CanCstNo(){
	
	$.messager.confirm('确认对话框','您确定要取消当前会诊申请吗？', function(r){
		if (r){
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
	});
	
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
function AcceptCstNo2(Params){

	runClassMethod("web.DHCEMConsult","AcceptCstNo",{"ItmID": CstItmID, "UserID":session['LOGON.USERID'], "Params":Params},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单非待接收状态，不允许进行接收操作！");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("提示:","会诊时间不能早于申请时间！");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请接受失败，失败原因:"+jsonString);
		}else{
			$.messager.alert("提示:","接受成功！");
			GetCstNoObj();  	          /// 加载会诊申请
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
		if (jsonString == -2){
			$.messager.alert("提示:","会诊时间不能早于申请时间！");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请接受失败，失败原因:"+jsonString);
		}else{
			$.messager.alert("提示:","接受成功！");
			GetCstNoObj();  	          /// 加载会诊申请
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// 接受
function SaveAccCstNo(){

	var consDate = $HUI.datebox("#ConsDate").getValue();      /// 会诊日期
	var consTime = $HUI.timespinner("#ConsTime").getValue();  /// 会诊时间
	var Params = consDate +"^"+ consTime;
	AcceptCstNo2(Params)
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

/// 会诊意见
function SaveCstOpi(){
	
	if (CsUserID != session['LOGON.USERID']){
		$.messager.alert("提示:","您非当前会诊人员，不能进行此操作！");
		return;
	}
	
	var ConsOpinion = $("#ConsOpinion").val();
	if (ConsOpinion == ""){
		$.messager.alert("提示:","请填写会诊意见！");
		return;
	}
	
	runClassMethod("web.DHCEMConsult","SaveCstOpi",{"ItmID": CstItmID, "UserID":session['LOGON.USERID'], "CstOpinion":ConsOpinion},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单当前状态，不允许进行完成操作！");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","保存失败！");
		}else{
			$.messager.alert("提示:","保存成功！");
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
	
	runClassMethod("web.DHCEMConsult","CompCstNo",{"ItmID": CstItmID, "UserID":session['LOGON.USERID'], "CstOpinion":ConsOpinion},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单当前状态，不允许进行完成操作！");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("提示:","会诊时间不能早于申请时间！");
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请完成失败，失败原因:"+jsonString);
		}else{
			$.messager.alert("提示:","完成成功！");
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)		
}

/// 完成
function saveCompCstNo(){

	var consDate = $HUI.datebox("#ConsDate").getValue();      /// 会诊日期
	var consTime = $HUI.timespinner("#ConsTime").getValue();  /// 会诊时间
	var Params = consDate +"^"+ consTime;
	CompCstNo2(Params)
}
	
/// 完成
function CompCstNo2(Params){
	
	if (CsUserID != session['LOGON.USERID']){
		$.messager.alert("提示:","您非当前会诊人员，不能进行此操作！");
		return;
	}
	var ConsOpinion = $("#ConsOpinion").val();
	if (ConsOpinion == ""){
		$.messager.alert("提示:","请填写会诊意见！");
		return;
	}
	
	runClassMethod("web.DHCEMConsult","CompCstNo",{"ItmID": CstItmID, "UserID":session['LOGON.USERID'], "CstOpinion":ConsOpinion, "Params":Params},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单当前状态，不允许进行完成操作！");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("提示:","会诊时间不能早于申请时间！");
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
	
	if (CstItmID == ""){
		PrintCst_REQ(CstID);
	}else{
		PrintCst_REQ(CstItmID);
	}
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
	GetCstNoObj();  	          /// 加载会诊申请
	GetConsMarIndDiv(CstID);	  /// 取会诊科室亚专业指征
	isShowPageButton(arCstID);    /// 动态设置页面显示的按钮内容
	$("#dgCstDetList").datagrid("load",{"CstID":arCstID});      /// 会诊科室
}

/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {
	
	if (CstID != ""){
		LoadReqFrame(CstID, "");    /// 加载病理申请
	}
	
	GetLgContent();  /// 取登录信息
}

/// 开启授权
function OpenAuthorize(){

	if (CstID == ""){
		$.messager.alert("提示:","请保存会诊后，再开启授权！");
		return;
	}
	
	/// 新建会诊授权窗口
	newCreateConsultWin();
	
	var LinkUrl = GetConsAutUrl();
	if (LinkUrl != ""){
		$("#TabMain").attr("src", LinkUrl);
	}
}

/// 取会诊病历授权链接
function GetConsAutUrl(){
	
	var LinkUrl = "";
	runClassMethod("web.DHCEMConsultQuery","GetConsAutUrl",{"CstID":CstID},function(jsonString){

		if (jsonString != ""){
			LinkUrl = jsonString;
		}
	},'',false)
	return LinkUrl
}

/// 关闭授权
function ClsAuthorize(){
	
	runClassMethod("EPRservice.browser.BOConsultation","FinishConsultation",{"AConsultID":CstID},function(jsonString){

		if (jsonString != ""){
			$.messager.alert("提示:",jsonString);
		}
	},'',false)
}

/// 新建会诊授权窗口
function newCreateConsultWin(){
	var option = {
		};
	new WindowUX('会诊病历授权', 'newConWin', '500', '500', option).Init();

}

/// 会诊类型
function EmType_KeyPress(event,value){

	if (value){
		/// 院内院外
		$HUI.radio("input[name='CstUnit'][value='Y']").setValue(false);
		$HUI.radio("input[name='CstUnit'][value='N']").setValue(false);
	}
}

/// 院内院外
function EmUnit_KeyPress(event,value){

	if (value){
		/// 会诊类型
		$HUI.radio("input[name='CstType'][value='Y']").setValue(false);
		$HUI.radio("input[name='CstType'][value='N']").setValue(false);
	}
}

/// 引用
function OpenEmr(flag){

	var url="dhcem.consultpatemr.csp?&EpisodeID="+EpisodeID+"&targetName=Attitude"+"&TextValue="; //+obj.text;
	var result = window.showModalDialog(url,"_blank",'dialogTop:0;dialogWidth:'+(window.screen.availWidth-5)+'px;DialogHeight='+(window.screen.availHeight-5)+'px;center=1'); 
	try{
		if (result){
			if (flag == 1){
				if ($("#ConsTrePro").val() == ""){
					$("#ConsTrePro").val(result.innertTexts);  		/// 简要病历
				}else{
					$("#ConsTrePro").val($("#ConsTrePro").val()  +"\r\n"+ result.innertTexts);  		/// 简要病历
				}
			}else{
				if ($("#ConsOpinion").val() == ""){
					$("#ConsOpinion").val(result.innertTexts);  		/// 简要病历
				}else{
					$("#ConsOpinion").val($("#ConsOpinion").val()  +"\r\n"+ result.innertTexts);  		/// 简要病历
				}	
			}
		}
	}catch(ex){}
}

/// 动态设置页面显示的按钮内容
function isShowPageButton(CstID){

	runClassMethod("web.DHCEMConsultQuery","GetCstPageBtFlag",{"CstID":CstID, "LgUserID":session['LOGON.USERID'], "LgLocID":session['LOGON.CTLOCID']},function(jsonString){

		if (jsonString != ""){
			var BTFlag = jsonString;
			HidePageButton(BTFlag);
		}
	},'',false)
}

/// 隐藏按钮
function HidePageButton(BTFlag){

	/// 请会诊  申请未发送
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
		$("#bt_openemr").show();   /// 开启授权
		$("#bt_colseemr").show();  /// 关闭授权
		$("#Opinion").show();  /// 会诊意见
		PageEditFlag(1);	   /// 页面编辑
		isEditFlag = 0;	       /// 行编辑标志
	}
	/// 请会诊  申请已发送
	if (BTFlag == 2){
		$("#bt_save").hide();  /// 保存
		$("#bt_send").hide();  /// 发送
		$("#bt_acc").hide();   /// 接收
		$("#bt_ref").hide();   /// 拒绝
		$("#bt_arr").hide();   /// 到达
		$("#bt_com").hide();   /// 完成
		$("#bt_ord").hide();   /// 医嘱录入
		$("#bt_openemr").hide();   /// 开启授权
		$("#bt_colseemr").hide();  /// 关闭授权

		$("#bt_can").show();   /// 取消
		$("#bt_sure").show();  /// 确认
		$("#Opinion").show();  /// 会诊意见
		PageEditFlag(2);	   /// 页面编辑
		isEditFlag = 1;	       /// 行编辑标志
	}

	/// 会诊显示
	if (BTFlag == 3){
		$("#bt_save").hide();  /// 保存
		$("#bt_send").hide();  /// 发送
		$("#bt_can").hide();   /// 取消
		$("#bt_sure").hide();  /// 确认
		$("#bt_openemr").hide();   /// 开启授权
		$("#bt_colseemr").hide();  /// 关闭授权
		
		$("#bt_acc").show();   /// 接收
		$("#bt_ref").show();   /// 拒绝
		$("#bt_arr").show();   /// 到达
		$("#bt_com").show();   /// 完成
		$("#bt_ord").show();   /// 医嘱录入
		$("#Opinion").show();  /// 会诊意见
		PageEditFlag(0);	   /// 页面编辑
		isEditFlag = 1;	       /// 行编辑标志
	}
	/// 其他人显示
	if (BTFlag == 4){
		$("#bt_save").hide();  /// 保存
		$("#bt_send").hide();  /// 发送
		$("#bt_can").hide();   /// 取消
		$("#bt_sure").hide();  /// 确认
		$("#bt_com").hide();   /// 完成
		$("#bt_acc").hide();   /// 接收
		$("#bt_ref").hide();   /// 拒绝
		$("#bt_arr").hide();   /// 到达
		$("#bt_ord").hide();   /// 医嘱录入
		$("#bt_openemr").hide();   /// 开启授权
		$("#bt_colseemr").hide();  /// 关闭授权
		$("#Opinion").show();  /// 会诊意见
		PageEditFlag(0);	   /// 页面编辑
		isEditFlag = 1;	       /// 行编辑标志
	}
	/// 页面默认显示
	if (BTFlag == 5){
		//$("#bt_can").hide();   /// 取消
		//$("#bt_sure").hide();  /// 确认
		//$("#bt_com").hide();   /// 完成
		//$("#bt_acc").hide();   /// 接收
		$("#bt_ref").hide();   /// 拒绝
		$("#bt_arr").hide();   /// 到达
		$("#bt_ord").hide();   /// 医嘱录入
		$("#Opinion").hide();  /// 会诊意见
		$("#bt_openemr").hide();   /// 开启授权
		$("#bt_colseemr").hide();  /// 关闭授权
	}
}

/// 接受
function SaveAcceptCstNo(){

	var consDate = $HUI.datebox("#ConsDate").getValue();      /// 会诊日期
	var consTime = $HUI.timespinner("#ConsTime").getValue();  /// 会诊时间
	var Params = consDate +"^"+ consTime;
	runClassMethod("web.DHCEMConsult","SaveAccCstNo",{"ItmID": CstItmID, "UserID":session['LOGON.USERID'], "Params":Params},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单非待接收状态，不允许进行接收操作！");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("提示:","会诊时间不能早于申请时间！");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请接受失败，失败原因:"+jsonString);
		}else{
			$.messager.alert("提示:","接受成功！");
			GetCstNoObj();  	          /// 加载会诊申请
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// 取科室亚专业指征
function GetMarIndDiv(MarID){
	
	$("#itemList").html("");
	var rowData = $('#dgCstDetList').datagrid('getRows');
	for (var i=0; i<rowData.length; i++){
		if (typeof rowData[i].MarID != "undefined"){
			InsMarIndDiv(rowData[i].MarID);  /// 加载会诊指征
		}
	}
	if (MarID != ""){
		InsMarIndDiv(MarID);  /// 加载会诊指征
	}
	/// 会诊指征
	if ($("#itemList").html() == ""){
		$("#MarIndDiv ").hide();
	}else{
		$("#MarIndDiv ").show();
	}
}

/// 插入科室亚专业指征
function InsMarIndDiv(MarID){
	
	runClassMethod("web.DHCEMConsLocItem","JsonSubMarInd",{"MarID":MarID},function(jsonObject){

		if (jsonObject != ""){
			InsMarIndTable(jsonObject);
		}
	},'json',false)
}

/// 科室亚专业指征
function InsMarIndTable(itmArr){
	
	var itemhtmlArr = [];
	for (var j=1; j<=itmArr.length; j++){
		if($('input[name="MarInd"][value="'+ itmArr[j-1].value +'"]').length == 0){
			itemhtmlArr.push('<tr><td style="width:20px;"><input value="'+ itmArr[j-1].value +'" name="MarInd" type="checkbox" class="checkbox"></input></td><td>'+ itmArr[j-1].text +'</td></tr>');
		}
	}
    $("#itemList").append(itemhtmlArr.join(""));
}


/// 取会诊科室亚专业指征
function GetConsMarIndDiv(CstID){
	
	$("#itemList").html("");
	runClassMethod("web.DHCEMConsultQuery","GetJsonSubMarInd",{"CstID":CstID},function(jsonObject){
		if (jsonObject != ""){
			InsMarIndTable(jsonObject);
			$('input[name="MarInd"]').attr("checked",true).attr("disabled","disabled");
		}
	},'json',false)

	/// 会诊指征
	if ($("#itemList").html() == ""){
		$("#MarIndDiv ").hide();
	}else{
		$("#MarIndDiv ").show();
	}
}

/// 病人信息
function PatBaseWin(){
	
	window.open("emr.record.browse.patient.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID, 'newWin', 'height='+ (window.screen.availHeight-5) +', width='+ (window.screen.availWidth-5) +', top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// 历次会诊
function PatHisCst(){
	
	window.open("dhcem.consultquery.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID, 'newWin', 'height='+ (window.screen.availHeight-5) +', width='+ (window.screen.availWidth-5) +', top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// 设置界面编辑状态
function PageEditFlag(Flag){
	
	if (Flag == 1){
		$("#ConsTrePro").prop("readonly",false);  /// 简要病历
		$("#ConsPurpose").prop("readonly",false); /// 会诊目的
		$("#CstUser").attr("disabled", false);    /// 联系人
		$("#CstTele").attr("disabled", false);    /// 联系电话
		$HUI.radio("input[name='CstEmFlag']").disable(false);
		//$('#CstType').combobox({disabled:false}); /// 会诊类型
		$HUI.combobox("#CstType").enable();
	}else{
		//$("#ConsTrePro").attr("disabled",true);   /// 简要病历
		$("#ConsTrePro").prop("readonly",true);
		//$("#ConsPurpose").attr("disabled",true);  /// 会诊目的
		$("#ConsPurpose").prop("readonly",true);
		$("#CstUser").attr("disabled", true);       /// 联系人
		$("#CstTele").attr("disabled", true);		/// 联系电话
		$HUI.radio("input[name='CstEmFlag']").disable();
		$HUI.combobox("#CstType").disable();      /// 会诊类型
	}
	if (Flag != 0){
		$("#ConsOpinion").prop("readonly",true);  /// 会诊结论
	}
}
window.onload = onload_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })