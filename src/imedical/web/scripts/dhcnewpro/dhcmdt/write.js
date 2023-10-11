//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2018-01-22
// 描述:	   会诊申请单
//===========================================================================================
var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var mradm = "";			/// 就诊诊断ID
var PatType="";		    /// 就诊类型
var CstID = "";         /// 会诊申请ID
var CstItmID = "";      /// 会诊申请字表ID
var editSelRow = -1;
var editGrpRow = -1;
var editExpRow = -1;
var isEditFlag = 0;     /// 页面是否可编辑
var LType = "CONSULT";  /// 会诊科室代码
var CsRType = "DOC";    /// 会诊类型  医生
var CstOutFlag = "";    /// 院际会诊标志
var CstMorFlag ="";     /// 多科会诊标志
var TakOrdMsg = "";     /// 验证病人是否允许开医嘱
var TakCstMsg = "";     /// 验证医生是否有开会诊权限
var isOpiEditFlag = 0;  /// 会诊结论是可编辑
var IsPerAccFlag = 0;   /// 是否允许接受申请单
var CsStatCode = "";    /// 申请单当前状态
var seeCstType="";      /// 查看模式
var CarPrvID = "";      /// 资源号别
var RBResID=""			/// 资源表ID
var AppSclID = "";      /// 资源字表ID
var LODOP="";
var isValFlag = "Y";
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
var del = String.fromCharCode(2);
var PageWidth=""
/// 页面初始化函数
function initPageDefault(){
	getWidth()
	InitPatEpisodeID();       /// 初始化加载病人就诊ID
	InitAutoLine();
	InitPageComponent(); 	  /// 初始化界面控件内容
	InitPageDataGrid();		  /// 初始化页面datagrid
	InitLocGrpGrid();	      /// 初始化页面datagrid
	InitOuterExpGrid();	      /// 初始化页面datagrid
	HidePageButton(5);	      /// 初始化界面按钮
	multi_Language();         /// 多语言支持
	InitMoreScreen(); ///多屏幕方法
	TakOrdMsg = GetPatNotTakOrdMsg();
	if (TakOrdMsg != ""){
		$.messager.alert("提示",TakOrdMsg,"warning");
		return;	
	}
}

function InitAutoLine(){
	var conLayWidth=$("#contentLayout").width();
	if(parseInt(conLayWidth)<850){
		$(".autoNewLine").show();	
	}else{
		$(".autoNewLine").hide();	
	}
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){

	PatientID = getParam("PatientID");   /// 病人ID
	EpisodeID = getParam("EpisodeID");   /// 就诊ID
	mradm = getParam("mradm");           /// 就诊诊断ID
	CstID = getParam("ID");              /// 会诊ID
	seeCstType = getParam("seeCstType"); /// 会诊查看模式
	isValFlag = getParam("isValFlag");   /// 是否验证
	LODOP = "" //getLodop();
	if(seeCstType==1) return;
	if (EpisodeID == ""){
		$("#openemr").hide();
	}
	if ((EpisodeID != "")&(CstID == "")&(isValFlag == "N")){
		InitPatNotTakOrdMsg(1);    /// 验证病人是否允许开医嘱
		//InitPatHasMdtCons();
	}
}

function replaceMdtPurpose(){
	var mdtPurpose = $("#mdtPurpose").val();
	mdtPurpose = mdtPurpose.replace("1","诊断");
	mdtPurpose = mdtPurpose.replace("2","治疗");
	mdtPurpose = mdtPurpose.replace("3","其他");
	$("#mdtPurpose").val(mdtPurpose);
	return;
}

function InitPatHasMdtCons(){
	runClassMethod("web.DHCMDTCom","TipHasMdtCons",{"EpisodeID":EpisodeID},function(ret){
		if (ret != ""){
			$.messager.alert("提示","<div style='line-height:18px;letter-spacing:1px;margin:3px;'>"+ ret +"</div>","warning");
		}
	},'text',false)
}

/// 初始化界面控件内容
function InitPageComponent(){
	
	/// 疑难病种
	var option = {
		panelHeight:"auto",
		blurValidValue:true,
        onSelect:function(option){
	        ClrDisGrpRel();  /// 清空病种组关联内容
			GetCareProvByGrp(option.value); /// 根据疑难病种取关联号别
			/// 病种是否关联费用
			if (isTakOrder(option.value) != 1){
				$.messager.alert("提示","该病种未关联收费项，不能开立该类型申请!","warning");
				$HUI.combobox("#mdtDisGrp").setValue(""); 
			}

	    },
	    onShowPanel: function () { //数据加载完毕事件
			///设置级联指针
			//var unitUrl = $URL+"?ClassName=web.DHCMDTGroup&MethodName=jsonGroup";
			var unitUrl = $URL+"?ClassName=web.DHCMDTGroup&MethodName=jsonGroup&LgParams="+LgParam+"&MWToken="+websys_getMWToken();
			
			$("#mdtDisGrp").combobox('reload',unitUrl);
        }
	};
	
	var url = "";
	new ListCombobox("mdtDisGrp",url,'',option).init();
	
	/// 登记号
	$("#PatNo").bind('keypress',PatNo_KeyPre);
	
	$('#contentLayout').layout('panel', 'center').panel({
		onResize: function () {InitAutoLine()},
	});
}

/// 清空病种组关联内容
function ClrDisGrpRel(){
	
	$("#mdtPreDate").val("");  /// 预约日期
	$("#mdtPreTime").val("");  /// 预约时间
	$("#mdtPreTimeRange").val("");  /// 会诊时段
	$("#mdtMakResID").val("");  /// 资源ID
	$("#LocGrpList").datagrid("load",{total:0,rows:[]});               /// 会诊科室
	$("#dgCstDetList").datagrid("reload"); /// 院内科室
}

/// 病人就诊信息
function GetPatBaseInfo(){
	
	runClassMethod("web.DHCMDTConsultQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		if (jsonObject != ""){
			 $("#PatName").val(jsonObject.PatName); /// 姓名
			 $("#PatSex").val(jsonObject.PatSex);   /// 性别
			 $("#PatAge").val(jsonObject.PatAge);   /// 年龄
			 $("#PatNo").val(jsonObject.PatNo);     /// 登记号   
			 $("#PatBed").val(jsonObject.PatBed);   /// 床号
			 $("#PatBill").val(jsonObject.PatBill); /// 费别
			 $("#PatDiagDesc").val(formatHtmlToValue(jsonObject.PatDiagDescAll)); /// 诊断
			 PatType = jsonObject.PatType;
		}
	},'json',false)
}

/// 取登录信息
function LoadPageWriEl(){

	runClassMethod("web.DHCMDTConsultQuery","TakCsPatInfo",{"EpisodeID":EpisodeID, "LgLocID":LgLocID, "LgUserID":LgUserID},function(jsonObject){
		
		if (jsonObject != null){
			$('#mdtRLoc').val(jsonObject.LocDesc);  /// 申请科室
			$('#mdtRUser').val(jsonObject.LgUser);  /// 申请医师
			$('#mdtAddr').val(jsonObject.LocAddr);  /// 科室地址
			$('#mdtTimes').val(jsonObject.mdtTimes);  /// 会诊次数
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
	
	
	var HosTypeArr = [{"value":"I","text":'组内'}, {"value":"O","text":'院内'}];
	//设置其为可编辑
	var HosEditor={
		type: 'combobox',     //设置编辑格式
		options: {
			data: HosTypeArr,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'HosID'});
				$(ed.target).val(option.value);  //设置value
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'HosType'});
				$(ed.target).combobox('setValue', option.text);  //设置Desc
				
				/// 清空职称
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'LocDesc'});
				$(ed.target).combobox('setValue', "");
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				$(ed.target).val("");
				
				///清空医生
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val("");
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
				///清空科室
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				$(ed.target).val("");
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', "");
				
			}
		}
	}
	
	// 职称编辑格
	var PrvTpEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonPrvTp"+"&MWToken="+websys_getMWToken(),
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			//panelHeight:"auto",  //设置容器高度自动增长
			blurValidValue:true,
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				if ($(ed.target).val() == ""){
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
					$(ed.target).combobox('setValue', "");
					$.messager.alert("提示","请先确定专家科室！","warning");
					return;
				}
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', option.text);

				///设置级联指针
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val();
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
			},
			onChange:function(newValue, oldValue){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				if (newValue == ""){
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
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
			url: $URL +"?ClassName=web.DHCMDTCom&MethodName=JsonLoc&HospID"+session['LOGON.HOSPID']+"&MWToken="+websys_getMWToken(),
			blurValidValue:true,
			onSelect:function(option) {
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				$(ed.target).val(option.value);
				
				/// 联系方式
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'TelPhone'});
				$(ed.target).val(GetLocTelPhone(option.value));
				
				///清空医生
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val("");
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
				/// 清空职称
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				$(ed.target).val("");
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', "");
				
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var DisGrpID = $HUI.combobox("#mdtDisGrp").getValue(); /// 疑难病种
				/// 组内
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'HosID'});
				var HosID = $(ed.target).val();
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'LocDesc'});
				var unitUrl = "";
				if (HosID == "I"){
					
					var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonGrpLoc&DisGrpID="+DisGrpID+"&MWToken="+websys_getMWToken();
				}else{
					
					var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLoc&HospID="+LgHospID+"&MWToken="+websys_getMWToken();
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
			enterNullValueClear:false,
			blurValidValue:true,
			mode:'remote',
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val(option.value);
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', option.text);
				
				
				/// 联系方式
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'TelPhone'});
				$(ed.target).val(GetCareProvPhone(option.value));
				
				$m({
					ClassName:"web.DHCMDTCom",
					MethodName:"GetPrvTpIDByCareProvID",
					CareProvID:option.value
				},function(txtData){
					var ctpcpCtInfo = txtData;
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
					$(ed.target).combobox('setValue', ctpcpCtInfo.split("^")[1]);
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
					$(ed.target).val(ctpcpCtInfo.split("^")[0]);
				});
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
			    
			    var DisGrpID = $HUI.combobox("#mdtDisGrp").getValue(); /// 疑难病种
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'HosID'});
				var HosID = $(ed.target).val();
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				var LocID = $(ed.target).val();
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				var PrvTpID = $(ed.target).val();
				///设置级联指针
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				var GrpID = HosID=="I"?DisGrpID:"";
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocCareProv&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&DisGrpID="+ GrpID+"&MWToken="+websys_getMWToken();
				$(ed.target).combobox('reload',unitUrl);
			
			},
			onChange:function(newValue, oldValue){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				if (newValue == ""){
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
					$(ed.target).val();
				}
			}
		}
	}
	
	var hideFlag=""
	if(CstID!=""){
		hideFlag="true"
		}
	///  定义columns
	var columns=[[
		{field:'HosID',title:'HosID',width:100,editor:texteditor,align:'left',hidden:true},
		{field:'HosType',title:'院内院外',width:110,editor:HosEditor,align:'left',hidden:true},
		{field:'LocID',title:'科室ID',width:100,editor:texteditor,align:'left',hidden:true},
		{field:'LocDesc',title:'科室',width:200,editor:LocEditor,align:'left'},
		{field:'UserID',title:'医生ID',width:110,editor:texteditor,align:'left',hidden:true},
		{field:'UserName',title:'医生',width:120,editor:DocEditor,align:'left',styler: slUserName},
		{field:'TelPhone',title:'联系方式',width:100,editor:texteditor,align:'left'},
		{field:'PrvTpID',title:'职称ID',width:100,editor:texteditor,align:'left',hidden:true},
		{field:'PrvTp',title:'职称',width:160,editor:PrvTpEditor,align:'left',hidden:false},
		{field:'operation',title:"操作",width:100,align:'left',formatter:SetCellUrl,hidden:hideFlag}  
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
			
			if ((editGrpRow != -1)||(editGrpRow == 0)) { 
                $("#LocGrpList").datagrid('endEdit', editGrpRow); 
            }
            
            if ((editExpRow != -1)||(editExpRow == 0)) { 
                $("#OuterExpList").datagrid('endEdit', editExpRow); 
            }
            
            if ((editSelRow != -1)||(editSelRow == 0)) { 
                $("#dgCstDetList").datagrid('endEdit', editSelRow); 
            }
            $("#dgCstDetList").datagrid('beginEdit', rowIndex); 
            
            /// 联系方式
			var ed=$("#dgCstDetList").datagrid('getEditor',{index:rowIndex,field:'TelPhone'});
			$(ed.target).attr("disabled", true);
			
            editSelRow = rowIndex;
        }
	};
	/// 就诊类型
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&CstID=&Type=O"+"&MWToken="+websys_getMWToken();
	new ListComponent('dgCstDetList', columns, uniturl, option).Init();
}

/// 链接
function SetCellUrl(value, rowData, rowIndex){	
	if(HISUIStyleCode==="lite"){ // 2023-01-04
		var html = '<a href="javascript:void(0)" class="icon-cancel" style="color:#000;" onclick="delRow(\''+ rowIndex +'\',\''+ "dgCstDetList" +'\')"></a>';
	    //html +='<a href="javascript:void(0)" class="icon-add" style="color:#000;" onclick="insRow()"></a>';
	}else{
		var html = '<a href="javascript:void(0)" onclick="delRow(\''+ rowIndex +'\',\''+ "dgCstDetList" +'\')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png" border=0/></a>';
	    //html += '<a href="javascript:void(0)" onclick="insRow()"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/add.png" border=0/></a>';
	}

	
	//var html = '<a href="#" class="hisui-linkbutton" data-options="iconCls:\''+a+'\',plain:true" onclick="delRow(\''+ rowIndex +'\',\''+ "dgCstDetList" +'\')">添加</a>'

	//var html = '<a href="#" onclick="delRow(\''+ rowIndex +'\',\''+ "dgCstDetList" +'\')"><img src="../scripts/dhcnewpro/images/cancel.png" border=0/></a>';
	    //html += "<a href='#' onclick='insRow()'><img src='../scripts/dhcnewpro/images/edit_add.png' border=0/></a>";
	return html;
}

/// 删除行
function delRow(rowIndex, id){
	
	if (isEditFlag == 1) return;
	/// 行对象
    var rowObj={PrvTpID:'', PrvTp:'', HosID:'', HosType:'', LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:''};
	
	/// 当前行数大于4,则删除，否则清空
	if(rowIndex=="-1"){
		$.messager.alert("提示","请先选择行！");
		return;
	}
	
	var rows = $('#'+ id).datagrid('getRows');
	if(rows.length>2){
		 $('#'+ id).datagrid('deleteRow',rowIndex);
		 var rows=$('#'+ id).datagrid('getRows');
		 $('#'+ id).datagrid('loadData',rows);
	}else{
		$('#'+ id).datagrid('updateRow',{index:rowIndex, row:rowObj});
	}
	
	// 删除后,重新排序
	//$('#dgCstDetList').datagrid('sort', {sortName: 'No',sortOrder: 'desc'});
}

/// 插入空行
function insRow(){
	
	if (isEditFlag == 1) return;
			
    var rowObj={PrvTpID:'', PrvTp:'', HosID:'O', HosType:'院内', LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:''};
	$("#dgCstDetList").datagrid('appendRow',rowObj);
}

/// 保存mdt申请
function mdtSave(){

	if (PatientID == ""){
		$.messager.alert("提示","请录入患者信息后重试！","warning");
		return;
	}
	
	var InHosEpisID = GetPatInHosEpisID(); /// 患者是否正在住院ID
	if ((InHosEpisID != "")&(PatType != "I")&(HasCenter == 0)){
		$.messager.confirm('确认对话框','患者当前正在住院，是否将费用计入住院费用中?(点击确认按钮按住院收费，点击取消按钮按门诊收费)', function(r){
			if (r){
				mSave(InHosEpisID);
			}else{
				mSave(EpisodeID);
			}
		});
	}else{
		mSave(EpisodeID);
	}
}

/// 保存mdt申请
function mSave(TmpEpisodeID){
    
    /// 全院科室列表 结束编辑
    if ((editSelRow != -1)||(editSelRow == 0)) { 
        $("#dgCstDetList").datagrid('endEdit', editSelRow); 
    }
    
    /// 组内科室列表 结束编辑
    if ((editGrpRow != -1)||(editGrpRow == 0)) { 
        $("#LocGrpList").datagrid('endEdit', editGrpRow); 
    }
    
    /// 外院专家列表 结束编辑
    if ((editExpRow != -1)||(editExpRow == 0)) { 
        $("#OuterExpList").datagrid('endEdit', editExpRow); 
    }
    
    /// 验证病人是否允许开医嘱
	TakOrdMsg = GetPatNotTakOrdMsg();
	if (TakOrdMsg != ""){
		$.messager.alert("提示",TakOrdMsg,"warning");
		return;	
	}
	
	/// 验证医生是否有开会诊权限
	if (TakCstMsg != ""){
		$.messager.alert("提示",TakCstMsg,"warning");
		return;	
	}
	
    var mdtDisGrp = $HUI.combobox("#mdtDisGrp").getValue();
	if (mdtDisGrp == "") {
		$.messager.alert("提示","疑难病种不能为空！","warning");
		return;
	}
	
	var mdtTrePro = $("#mdtTrePro").val();     /// 简要病历
	if (mdtTrePro.replace(/\s/g,'') == ""){
		$.messager.alert("提示","病情摘要不能为空！","warning");
		return;
	}
	mdtTrePro = $_TrsSymbolToTxt(mdtTrePro);        /// 处理特殊符号
	
	var mdtPurpose = $("#mdtPurpose").val();  	    /// 会诊目的
	if (mdtPurpose.replace(/\s/g,'') == ""){
		$.messager.alert("提示","会诊目的不能为空！","warning");
		return;
	}
	
	mdtPurpose = $_TrsSymbolToTxt(mdtPurpose);      /// 处理特殊符号
	if (RBResID == ""){
		$.messager.alert("提示","病种号别不能为空！","warning");
		return;	
	}

	//var mdtTime = $("#mdtPreTime").val();  /// 会诊时间
	var AppSclID = $("#mdtMakResID").val();  /// 出诊表ID
	if((HasCenter == 0)&(AppSclID == "")){
		$.messager.alert("提示","预约信息不能为空！","warning");
		return;	
	}
	var mdtPreData = $("#mdtPreDate").val(); /// 预约日期
	var mdtPreTime = $("#mdtPreTime").val(); /// 预约时间
	var mdtUser = $("#mdtUser").val();   /// 联系人
	var mdtTele = $("#mdtTele").val();   /// 联系电话
	var mdtNote = "";  				     /// 备注
	var mdtAddr = $("#mdtAddr").val();   /// 会诊地点
	var mdtTimes = $("#mdtTimes").val(); /// 第几次会诊
	
	/// 会诊科室
	var LocArr = [];
	var ConsDetArr=[];
	var TmpCarePrv = ""; /// 专家
	var CarePrvArr = [];
	var rowData = $('#LocGrpList').datagrid('getRows');
	$.each(rowData, function(index, item){
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^"+ item.MarID;
		    ConsDetArr.push(TmpData);
		    if ($.inArray(item.LocID +"^"+ item.UserID,LocArr) == -1){
				LocArr.push(item.LocID +"^"+ item.UserID);
			}
			/// 人员重复检查
			if ($.inArray(item.UserID, CarePrvArr) != -1){
				TmpCarePrv = item.UserName;
			}
			CarePrvArr.push(item.UserID);
		}
	})
	
	
	var IsNeedValidLocNumber=(SendNoNeedLoc!=1)||(HasCenter=="0")
	
	if ((LocArr.length-AtLeastNumber)<0){
		if(IsNeedValidLocNumber){
			$.messager.alert("提示","会诊专家组成员不允许少于"+AtLeastNumber+"人！","warning");
			return;	
		}
	}
	
	var rowData = $('#dgCstDetList').datagrid('getRows');
	$.each(rowData, function(index, item){
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^"+ item.MarID;
		    ConsDetArr.push(TmpData);
		    if ($.inArray(item.LocID +"^"+ item.UserID,LocArr) == -1){
				LocArr.push(item.LocID +"^"+ item.UserID);
			}
			/// 人员重复检查
			if ($.inArray(item.UserID, CarePrvArr) != -1){
				TmpCarePrv = item.UserName;
			}
			CarePrvArr.push(item.UserID);
		}
	})
	if (TmpCarePrv != ""){
		$.messager.alert("提示","会诊专家："+ TmpCarePrv +"，重复添加！","warning");
		return;	
	}
	
	var ConsDetList = ConsDetArr.join("@");
	if (ConsDetList == ""){
		///不需安排或者配置必须有会诊专家
		if(IsNeedValidLocNumber){
			$.messager.alert("提示","会诊科室不能为空！","warning");
			return;	
		}
	}
	
	/// 外院专家
	var repExpArr = [];
	var LocExpArr = [];
	var OuterExpList = "";
	var rowData = $('#OuterExpList').datagrid('getRows');
	
	if(!$("#OuterExpList").datagrid('validateRow', editExpRow)){
		$.messager.alert("提示","外院专家需维护必填数据【医生】!","warning");
		return;	
	}
	$.each(rowData, function(index, item){
		if(trim(item.LocDesc) != ""){
			var TmpData = item.UserID +"^"+ item.UserName +"^"+ item.LocID +"^"+ item.PrvTpID +"^"+ item.TelPhone;
			LocExpArr.push(TmpData);
		    if ($.inArray(item.UserID, repExpArr) == -1){
				repExpArr.push(item.UserID);
			}else{
				TmpCarePrv = item.UserName;
			}
		}
	})
	if (TmpCarePrv != ""){
		$.messager.alert("提示","会诊专家："+ TmpCarePrv +"，重复添加！","warning");
		return;	
	}
	OuterExpList = LocExpArr.join("@");
	
	var mListData = TmpEpisodeID +"^"+ LgUserID +"^"+ LgLocID +"^"+ mdtTrePro +"^"+ mdtPurpose +"^"+ mdtAddr;  //1-6
		mListData += "^"+ mdtPreData +"^"+ mdtPreTime +"^"+ mdtUser +"^"+ mdtTele +"^"+ mdtDisGrp +"^"+ RBResID; //7-12
		mListData += "^"+ AppSclID +"^"+ mdtTimes +"^"+ PatientID;

	///             主信息  +"&"+  会诊科室  +$c(2)+  外院专家
	var mListData = mListData +del+ ConsDetList +del+ OuterExpList;

	/// 保存
	runClassMethod("web.DHCMDTConsult","Insert",{"CstID":CstID, "mListData":mListData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示","会诊申请保存失败，失败原因:"+jsonString,"warning");
		}else{
			CstID = jsonString;
			$(".tip").text("(已保存)");
			$.messager.alert("提示","保存成功！","info",function(){
				$.messager.confirm("提示","是否发送申请单?",function(e){
					if(e){
						mdtSend();
					}
				});
			});
		}
	},'',false)
}

/// 病历查看
function LoadPatientRecord(){
	
	var frm = dhcsys_getmenuform();
	if (frm) {
		PatientID = frm.PatientID.value;
		EpisodeID = frm.EpisodeID.value;
		mradm = frm.mradm.value;
	}
	
	var link = "emr.interface.browse.category.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID']+"&MWToken="+websys_getMWToken();
	$("#newWinFrame").attr("src",link);
}


/// 加载会诊申请主信息内容
function GetCstNoObj(){

	runClassMethod("web.DHCMDTConsultQuery","JsGetMdtObj",{"ID":CstID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			InsCstNoObj(jsonObjArr);
		}
	},'json',false)
}

/// 设置会诊申请单内容
function InsCstNoObj(itemobj){ 
          
    $("#PatName").val(itemobj.PatName)
    $("#PatSex").val(itemobj.PatSex)
    $("#PatAge").val(itemobj.PatAge)
    $("#PatNo").val(itemobj.PatNo)
    $("#PatBed").val(itemobj.PatBed)
    $("#PatBill").val(itemobj.PatBill)
    $("#PatDiagDesc").val(itemobj.PatDiagDesc)
	$("#mdtTrePro").val($_TrsTxtToSymbol(itemobj.mdtTrePro));  		/// 简要病历
	$("#mdtPurpose").val($_TrsTxtToSymbol(itemobj.mdtPurpose));  	/// 会诊目的 
	$("#mdtUser").val(itemobj.CstUser);   		    /// 联系人
	$("#mdtTele").val(itemobj.CstPhone);   		    /// 联系电话
	$("#mdtRLoc").val(itemobj.CstRLoc);   		    /// 申请科室
	$("#mdtRUser").val(itemobj.CstRUser);   		/// 申请医师
	$("#mdtAddr").val(itemobj.CstNPlace);           /// 会诊地点
	var TreMeasures = "";
	if ((itemobj.TreMeasures != "")&(typeof itemobj.TreMeasures != "undefined")){
		TreMeasures = itemobj.TreMeasures.replace(new RegExp("<br>","g"),"\r\n")
	}
	$("#mdtOpinion").val($_TrsTxtToSymbol(TreMeasures));       /// 会诊意见
	$HUI.combobox("#mdtDisGrp").setValue(itemobj.DisGrpID);    /// 疑难病种
	$HUI.combobox("#mdtDisGrp").setText(itemobj.DisGroup);     /// 疑难病种
	$("#mdtCarPrv").val(itemobj.PrvDesc);                      /// 资源号别
	$("#mdtPreDate").val(itemobj.PreDate);
	$("#mdtPreTimeRange").val(itemobj.PreTimeRange);
	$("#mdtTimes").val(itemobj.MCTimes);
	//$HUI.timespinner("#CstTime").setValue(itemobj.CstNTime);   /// 会诊时间
	
	
	EpisodeID = itemobj.EpisodeID;			/// 就诊ID
	isOpiEditFlag = itemobj.isOpiEditFlag;  /// 会诊结论是可编辑
	IsPerAccFlag = itemobj.IsPerAccFlag;    /// 是否允许接受申请单
	CsStatCode = itemobj.CstStatus;         /// 申请单当前状态
	PatType = itemobj.PatType;              /// 就诊类型
	RBResID = itemobj.RBResID;              /// 就诊类型
	if (CsStatCode == ""){
		$(".tip").text("(已保存)");
	}else{
		$(".tip").text("");
	}
}

/// 发送mdt申请
function mdtSend(){
	
	if (CstID == ""){
		$.messager.alert("提示","请先保存申请单！","warning");
		return;
	}
	
	/// 验证病人是否允许开医嘱
	TakOrdMsg = GetPatNotTakOrdMsg();
	if (TakOrdMsg != ""){
		$.messager.alert("提示",TakOrdMsg,"warning");
		return;	
	}
	/// 验证医生是否有开会诊权限
	if (TakCstMsg != ""){
		$.messager.alert("提示",TakCstMsg,"warning");
		return;	
	}
	
	/// 诊断判断
	if (GetMRDiagnoseCount() == 0){
		$.messager.alert("提示","病人没有诊断,请先录入！","warning",function(){DiagPopWin()});
		return;	
	}
	
	/// 医疗结算判断
	if (GetIsMidDischarged() == 1){
		$.messager.alert("提示","此病人已做医疗结算,不允许医生再开医嘱！","warning");
		return;	
	}
	
	if (CstID == ""){
		$.messager.alert("提示","请保存会诊申请后，再发送！","warning");
		return;
	}
	
	/// 发送MDT申请时，超过指定时间点时，提醒医生
	if ((HasCenter == 1)&(isPermitTakMdt() == 1)){
		//$.messager.alert("提示","<div style='line-height:18px;letter-spacing:1px;margin:3px;'>MDT中心16:00后无法办理预约手续。请告知患者预约时间为工作日：8:30-11:30，13:30-16:00已开具的会诊申请三个工作日内有效未在规定时间内办理预约手续,会诊申请将自动作废！<div>", "warning");
		if (sendTipMsg != ""){
			$.messager.alert("提示",sendTipMsg, "warning");
			//return;
		}
	}
	
	runClassMethod("web.DHCMDTConsult","SendCstNo",{"CstID": CstID, "LgParam":LgParam,"IpAddress":""},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示","申请单已发送，不能再次发送！","warning");
			return;
		}
		if (jsonString < 0){
			if(jsonString==-12){
				$.messager.alert("提示","会诊申请发送失败，失败原因病人已经具有当日此号别，不允许再次预约！","warning");		
			}
			$.messager.alert("提示","会诊申请发送失败，失败原因:"+jsonString,"warning");
		}else{
			CstID = jsonString;
			isShowPageButton();     /// 动态设置页面显示的按钮内容
			$.messager.alert("提示","发送成功！","info");
			if (window.parent.reLoadMainPanel != undefined){
				window.parent.reLoadMainPanel(CstID);
			}
			/// 发送成功后如果配置了需要自动授权电子病历查看
			if(DefOpenAcc == 1){
				InsEmrAutMasAll();
			}
			$(".tip").text("");
			InvAutoPrint();  /// 发送后调用自动打印函数
		}
	},'',false)
}

function InsEmrAutMasAll(){
	
	var params = EpisodeID+"^"+CstID+"^"+LgUserID+"^72^1";
	
	runClassMethod("web.DHCMDTConsult","InsEmrAutMasAll",{"Params":params},function(jsonString){
		if (jsonString == 0){
			$.messager.alert("提示:","自动开启病历授权72小时查看权限！","warning");
			return;
		}
		
		if (jsonString == -2){
			$.messager.alert("提示:","开启授权失败，失败原因:当前病人此次就诊没有病历，请核实！如需授权请手动授权！","warning");
			return;
		}
		
		if (jsonString < 0){
			$.messager.alert("提示:","自动开启授权失败，如需授权请手动授权！失败原因:"+jsonString,"warning");
			return;
		}
		
	},'',false)	
}

/// 取消
function CanCstNo(){
	
	if (CstID == ""){
		$.messager.alert("提示","请先选择会诊申请，再进行此操作！","warning");
		return;
	}
	
	/// 验证病人是否允许开医嘱
	if (TakOrdMsg != ""){
		$.messager.alert("提示",TakOrdMsg.replace("再开申请","取消"),"warning");
		return;	
	}
	
	$.messager.confirm('确认对话框','您确定要取消当前会诊申请吗？', function(r){
		if (r){
			runClassMethod("web.DHCMDTConsult","CancelMdtCons",{"CstID":CstID, "LgParam":LgParam},function(jsonString){
				if (jsonString < 0){
					if(jsonString==-2) {
						$.messager.alert("提示","已经取号不允许撤销");
					}else if(jsonString==-1){
						$.messager.alert("提示","当前状态非发送状态不允许撤销");
					}else{
						$.messager.alert("提示","撤销会诊失败，失败原因:"+jsonString);
					}
				}else{
					$.messager.alert("提示","取消成功！","info");
					window.parent.reLoadMainPanel(CstItmID);
				}
			},'text',false)
		}
	});
	
}

/// 拒绝
function RefCstNo(){
	
	runClassMethod("web.DHCEMConsult","RefCstNo",{"ItmID": CstItmID, "UserID":session['LOGON.USERID']},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示","申请单当前所在状态，不允许进行拒绝操作！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示","会诊申请拒绝失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示","拒绝成功！","info");
			GetCstNoObj();  	         /// 加载会诊申请
			isShowPageButton();          /// 动态设置页面显示的按钮内容
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// 会诊意见
function InsCstOpinion(){
	
	if (CsUserID != session['LOGON.USERID']){
		$.messager.alert("提示","您非当前会诊人员，不能进行此操作！","warning");
		return;
	}
	
	var mdtOpinion = $("#mdtOpinion").val();
	if (mdtOpinion.replace(/\s/g,'') == ""){
		$.messager.alert("提示","请填写会诊意见！","warning");
		return;
	}
	mdtOpinion = $_TrsSymbolToTxt(mdtOpinion); /// 处理特殊符号
	
	runClassMethod("web.DHCEMConsult","SaveCstOpi",{"ItmID": CstItmID, "UserID":session['LOGON.USERID'], "CstOpinion":mdtOpinion},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示","申请单当前状态，不允许进行完成操作！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示","修改失败！","warning");
		}else{
			$.messager.alert("提示","修改成功！","info");
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// 完成
function CompCstNo(){
	
	if ((GetIsOperFlag("30") != "1")&(GetIsOperFlag("51") != "1")){
		$.messager.alert("提示","申请单当前状态，不允许进行完成操作！","warning");
		return;
	}
	
	var AntiOpinion = $("input[name='AntiRadio']:checked").val(); ///是否同意使用抗生素药物 
	if((AntiOpinion=="")||(AntiOpinion==undefined)){
		$.messager.alert("提示","抗生素会诊必须填写是否同意用药!");
		return false;
	}
	
	var ConsOpinion = $("#ConsOpinion").val();
	if (ConsOpinion.replace(/\s/g,'') == ""){
		$.messager.alert("提示","请填写会诊意见！","warning");
		return;
	}
	ConsOpinion = $_TrsSymbolToTxt(ConsOpinion); /// 处理特殊符号
	
	/// 外院和多科申请人填写会诊结论
	/// var Fn = ((CstOutFlag == "Y")||(CstMorFlag == "Y"))?"CompCstMas":"CompCstNo";
	/// 多科会诊填写标识
	var ItmID = "";
	if ((MulWriFlag == 1)&(CstMorFlag == "Y")){ ItmID = ""; }
	else{ ItmID = CstItmID; }
	runClassMethod("web.DHCEMConsult","CompCstMas",{"CstID": CstID, "ItmID": ItmID, "LgParam":LgParam, "CstOpinion":ConsOpinion,"AntiOpinion":AntiOpinion},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示","申请单当前状态，不允许进行完成操作！","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("提示","会诊时间不能早于申请时间！","warning");
		}
		if (jsonString < 0){
			$.messager.alert("提示","会诊申请完成失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示","完成成功！","info");
      		GetCstNoObj();  	          /// 加载会诊申请
			isShowPageButton();           /// 动态设置页面显示的按钮内容
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)		
}

/// 撤销完成
function RevCompCstNo(){
	
	/// 外院和多科申请人填写会诊结论
	/// var Fn = ((CstOutFlag == "Y")||(CstMorFlag == "Y"))?"CompCstMas":"CompCstNo";
	/// 多科会诊填写标识
	var ItmID = "";
	if ((MulWriFlag == 1)&(CstMorFlag == "Y")){ ItmID = ""; }
	else{ ItmID = CstItmID; }
	
	runClassMethod("web.DHCEMConsult","RevCompCstMas",{"CstID": CstID, "ItmID": ItmID, "UserID":session['LOGON.USERID']},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示","申请单当前状态，不允许取消完成操作！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示","会诊申请取消完成失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示","取消成功！","info");
      		GetCstNoObj();  	    /// 加载会诊申请
			isShowPageButton();     /// 动态设置页面显示的按钮内容
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
	var link = "dhcem.consultpupwin.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&MWToken="+websys_getMWToken();
	window.open(link,"_blank","height=600, width=1100, top=30, left=100,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
}

/// 打印知情同意书
function PrintZQTYS(){
	
	if (CstID == ""){
		$.messager.alert("提示","请发送会诊申请后，再打印！","warning");
		return;
	}
	PrintConsent(CstID);
	return;
}

/// 打印诊间预约单
function PrintZJYYD(){
	
	if (CstID == ""){
		$.messager.alert("提示","请发送会诊申请后，再打印！","warning");
		return;
	}
	
	PrintMakeDoc(CstID);
	return;
}

/// 是否允许操作
function GetIsOperFlag(stCode){
	
	var IsModFlag = "";
	/// 多科会诊填写标识
	var ItmID = "";
	if ((MulWriFlag == 1)&(CstMorFlag == "Y")){ ItmID = CstID; }
	else{ ItmID = CstItmID; }
	runClassMethod("web.DHCEMConsult","GetIsOperFlag",{"CstID":ItmID, "stCode":stCode},function(jsonString){

		if (jsonString != ""){
			IsModFlag = jsonString;
		}
	},'',false)
	return IsModFlag
}

/// 取科室电话
function GetLocTelPhone(LocID){
	
	var TelPhone = "";
	runClassMethod("web.DHCMDTConsultQuery","GetLocTelPhone",{"LocID":LocID},function(jsonString){

		//if (jsonString != ""){
			TelPhone = jsonString;
		//}
	},'',false)
	return TelPhone
}

/// 取医生电话
function GetCareProvPhone(CareProvID){
	
	var TelPhone = "";
	runClassMethod("web.DHCMDTConsultQuery","GetCareProvPhone",{"CareProvID":CareProvID},function(jsonString){

		//if (jsonString != ""){
			TelPhone = jsonString;
		//}
	},'',false)
	return TelPhone
}

/// 修改会诊打印标志
function InsCsMasPrintFlag(mdtID,printFlag){
	runClassMethod("web.DHCMDTConsult","InsCsMasPrintFlag",{"CstID":mdtID,"PrintFlag":printFlag},function(jsonString){
		if (jsonString != 0){
			$.messager.alert("提示","更新会诊打印状态失败，失败原因:"+jsonString);
		}
	},'',false)
}

/// 加载申请单内容
function LoadReqFrame(){

	GetCstNoObj();  	        /// 加载会诊申请
	//GetConsMarIndDiv();	        /// 取会诊科室亚专业指征
	isShowPageButton();         /// 动态设置页面显示的按钮内容
	if (EpisodeID != ""){
		InitPatNotTakOrdMsg(0); /// 验证病人是否允许开申请
	}
	$("#dgCstDetList").datagrid("load",{"ID":CstID});    /// 会诊科室
	$("#LocGrpList").datagrid("load",{"ID":CstID});      /// 会诊科室
	$("#OuterExpList").datagrid("load",{"ID":CstID});    /// 外院专家
	if(seeCstType){ 
		$('#contentLayout').layout('hidden','north');
	}
}

/// 开启授权
function OpenAuthorize(){

	if (CstID == ""){
		$.messager.alert("提示","请保存会诊后，再开启授权！","warning");
		return;
	}
	
	var TakEmrAutMsg = isPopEmrAut();
	/// 验证病人是否允许会诊授权
	if (TakEmrAutMsg != ""){
		$.messager.alert("提示",TakEmrAutMsg,"warning");
		return;	
	}
	
	var Link ="dhcmdt.consultemraut.csp?EpisodeID="+ EpisodeID +"&CstID="+ CstID+"&MWToken="+websys_getMWToken();
	websys_showModal({
		url: Link,
		iconCls:"icon-w-paper",
		title: '授权',
		closed: true,
		onClose:function(){}
	});
}

/// 验证病人是否允许会诊授权
function isPopEmrAut(){
	
	var TakMsg = "";
	runClassMethod("web.DHCEMConsInterface","isPopEmrAut",{"EpisodeID":EpisodeID},function(jsonString){

		if (jsonString != ""){
			TakMsg = jsonString;
		}
	},'',false)
	return TakMsg
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
			$.messager.alert("提示",jsonString,"warning");
		}
	},'',false)
}

/// 新建会诊授权窗口
function newCreateConsultWin(){
	var option = {
		};
	new WindowUX('病历授权', 'newConWin', '1000', '600', option).Init();

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

	var Link = "dhcem.patemrque.csp?EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&MWToken="+websys_getMWToken();
	
	
//	if (!isIE()){
	window.parent.commonShowWin({
		url: Link,
		title: "引用",
		width: $(window.parent).width()-100,
		height: $(window.parent).height()-50
	})
//	}else{
//		var result = window.showModalDialog(Link,"_blank",'dialogWidth:1480px;DialogHeight=660px;center=1'); 
//		if (result){
//			if ($("#mdtTrePro").val() == ""){
//				$("#mdtTrePro").val(result.innertTexts);  		/// 简要病历
//			}else{
//				$("#mdtTrePro").val($("#mdtTrePro").val()  +"\r\n"+ result.innertTexts);  		/// 简要病历
//			}
//		}
//	}
}

/// 插入引用内容
function InsQuote(resQuote, flag){
	
	if ($("#mdtTrePro").val() == ""){
		$("#mdtTrePro").val(resQuote);   /// 简要病历
	}else{
		$("#mdtTrePro").val($("#mdtTrePro").val()  +"\r\n"+ resQuote);   /// 简要病历
	}
}

/// 动态设置页面显示的按钮内容
function isShowPageButton(){

	runClassMethod("web.DHCMDTConsultQuery","GetCstPageBtFlag",{"CstID":CstID, "LgUserID":session['LOGON.USERID'], "LgLocID":session['LOGON.CTLOCID']},function(jsonString){

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

		$("#bt_save").show();  /// 保存
		$("#bt_send").show();  /// 发送
		$("#bt_can").show();   /// 取消
		$("#bt_read").hide();  /// 读卡
		$("#QueEmr").show();    /// 引用
		$("#TakTemp").show();   /// 选择模板
		$("#SaveTemp").show();  /// 保存模板
		$("#bt_grpaddloc").show(); /// 组内科室添加
		$("#bt_grpcencel").show(); /// 组内科室清空
		$("#bt_addloc").show();    /// 院内科室添加
		$("#bt_cencel").show();    /// 院内科室清空
		$("#bt_openemr").show();   /// 开启授权
		$("#bt_expaddloc").show();    /// 院外科室添加
		$("#bt_expcancel").show();    /// 院外科室清空
		$("#bt_select").show();       /// 院外快速选择
		PageEditFlag(1);	    /// 页面编辑
		isEditFlag = 0;	        /// 行编辑标志
	}
	/// 请会诊  申请已发送
	if (BTFlag == 2){
		$("#bt_save").hide();  /// 保存
		$("#bt_send").hide();  /// 发送
		$("#bt_read").hide();  /// 读卡
		$("#bt_can").show();   /// 取消
		$("#QueEmr").hide();   /// 引用
		$("#TakTemp").hide();  /// 选择模板
		$("#SaveTemp").hide(); /// 保存模板
		$("#bt_revcom").hide();/// 取消完成
		$("#bt_grpaddloc").hide(); /// 组内科室添加
		$("#bt_grpcencel").hide(); /// 组内科室清空
		$("#bt_addloc").hide();    /// 院内科室添加
		$("#bt_cencel").hide();    /// 院内科室清空
		if (HasCenter == 0) {
			//$("#bt_print").show();   /// 知情同意书
			//$("#bt_printM").show();  /// 诊间预约单
		}
		$("#bt_colseemr").hide();  /// 关闭授权
		$("#bt_openemr").show();   /// 开启授权
		$("#bt_expaddloc").hide();    /// 院外科室添加
		$("#bt_expcancel").hide();    /// 院外科室清空
		$("#bt_select").hide();       /// 院外快速选择
		PageEditFlag(2);	   /// 页面编辑
		isEditFlag = 1;	       /// 行编辑标志
	}

	/// 会诊显示
	if (BTFlag == 3){
		$("#bt_save").hide();  /// 保存
		$("#bt_send").hide();  /// 发送
		$("#bt_can").hide();   /// 取消
		$("#bt_read").hide();  /// 读卡
		$("#QueEmr").hide();   /// 引用
		$("#TakTemp").hide();  /// 选择模板
		$("#SaveTemp").hide(); /// 保存模板
		$("#bt_grpaddloc").hide(); /// 组内科室添加
		$("#bt_grpcencel").hide(); /// 组内科室清空
		$("#bt_addloc").hide();    /// 院内科室添加
		$("#bt_cencel").hide();    /// 院内科室清空
		if (HasCenter == 0) {
			//$("#bt_print").hide();   /// 知情同意书
			//$("#bt_printM").hide();  /// 诊间预约单
		}
		$("#bt_openemr").hide();     /// 开启授权
		$("#bt_expaddloc").hide();   /// 院外科室添加
		$("#bt_expcancel").hide();   /// 院外科室清空
		$("#bt_select").hide();      /// 院外快速选择
		PageEditFlag(3);	   /// 页面编辑
		isEditFlag = 1;	       /// 行编辑标志
	}
	/// 其他人显示
	if (BTFlag == 4){
		$("#bt_save").hide();  /// 保存
		$("#bt_send").hide();  /// 发送
		$("#bt_can").hide();   /// 取消
		$("#bt_read").hide();  /// 读卡
		$("#QueEmr").hide();   /// 引用
		$("#TakTemp").hide();  /// 选择模板
		$("#SaveTemp").hide(); /// 保存模板
		$("#bt_grpaddloc").hide(); /// 组内科室添加
		$("#bt_grpcencel").hide(); /// 组内科室清空
		$("#bt_addloc").hide();    /// 院内科室添加
		$("#bt_cencel").hide();    /// 院内科室清空
		if (HasCenter == 0) {
			//$("#bt_print").hide();   /// 知情同意书
			//$("#bt_printM").hide();  /// 诊间预约单
		}
		$("#bt_openemr").hide();     /// 开启授权
		$("#bt_expaddloc").hide();   /// 院外科室添加
		$("#bt_expcancel").hide();   /// 院外科室清空
		$("#bt_select").hide();      /// 院外快速选择
		PageEditFlag(4);	   /// 页面编辑
		isEditFlag = 1;	       /// 行编辑标志
	}
	/// 页面默认显示
	if (BTFlag == 5){
		$("#bt_can").hide();   /// 取消
		$("#bt_openemr").hide();   /// 开启授权
		$("#bt_colseemr").hide();  /// 关闭授权
	}
	
	//$("#Opinion").show();

	/// 会诊子表ID为空时，不显示会诊日志按钮
	if (CstItmID == ""){
		$("#bt_log").hide();   /// 会诊日志
	}
	
	if (CsStatCode == "撤销"){
		//$("#bt_print").hide();   /// 知情同意书
		//$("#bt_printM").hide();  /// 诊间预约单
	}
}

/// 插入科室亚专业指征
function InsMarIndDiv(MarID, LocID){
	
	runClassMethod("web.DHCEMConsLocItem","JsonSubMarInd",{"MarID":MarID, "LocID":LocID},function(jsonObject){

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
function GetConsMarIndDiv(){
	
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
	
	if (EpisodeID == ""){
		$.messager.alert("提示","请选择会诊记录后重试！","warning");
		return;
	}
	
	if (GetEmrAutFlag() == ""){
		$.messager.alert("提示","您无权限查看该病人病历内容！","warning");
		return;
	}
	
	var lnk ="emr.interface.browse.category.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID']+"&Action="+'externalapp'+"&MWToken="+websys_getMWToken();
	window.open(lnk, 'newWin', 'height='+ (window.screen.availHeight-200) +', width='+ (window.screen.availWidth-200) +', top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// 历次会诊
function PatHisCst(){
	
	if (EpisodeID == ""){
		$.messager.alert("提示","请选择会诊记录后重试！","warning");
		return;
	}
	window.open("dhcmdt.consultpathis.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&MWToken="+websys_getMWToken(), 'newWin', 'height='+ (window.screen.availHeight-200) +', width='+ (window.screen.availWidth-100) +', top=50, left=50, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// 设置界面编辑状态
function PageEditFlag(Flag){
	
	if (Flag == 1){
		$("#ConsTrePro").prop("readonly",false);  /// 简要病历
		$("#ConsPurpose").prop("readonly",false); /// 会诊目的
		$("#CstUser").attr("disabled", false);    /// 联系人
		$("#CstTele").attr("disabled", false);    /// 联系电话
		$("#mdtTimes").attr("disabled", false);   /// 第几次会诊
		$HUI.combobox("#mdtDisGrp").disable(); 	  /// 疑难病种
		$("#app").linkbutton('enable');           /// 预约按钮
	}else{
		$("#ConsTrePro").prop("readonly",true);
		$("#ConsPurpose").prop("readonly",true);
		$("#CstUser").attr("disabled", true);       /// 联系人
		$("#CstTele").attr("disabled", true);		/// 联系电话
		$("#mdtTimes").attr("disabled", true);      /// 第几次会诊
		$HUI.combobox("#mdtDisGrp").disable(); 	    /// 疑难病种
		$("#app").linkbutton('disable');            /// 预约按钮
	    //$("#app").attr("disabled", true).css({"pointer-events":"none","background-color":"gray"});   /// 预约按钮
	}
	
	if ((Flag == 3)||(Flag == 4)){
		$("#OpBtns").hide();
		//$(".p-content").css({"top":25});
	}
	if (Flag != 3){
		$("#ConsOpinion").prop("readonly",true);   /// 会诊结论
	}else{
		$("#ConsOpinion").prop("readonly",false);  /// 会诊结论
	}
}

/// 验证病人是否允许开医嘱
function InitPatNotTakOrdMsg(TipFlag){
	
	TakOrdMsg = GetPatNotTakOrdMsg();
	if ((TakOrdMsg != "")&(TipFlag == 1)){
		$.messager.alert("提示",TakOrdMsg,"warning");
		return;	
	}
}

/// 验证病人是否允许开医嘱
function GetPatNotTakOrdMsg(){

	var NotTakOrdMsg = "";
	/// 验证病人是否允许开医嘱
	runClassMethod("web.DHCMDTCom","GetPatNotTakOrdMsg",{"LgGroupID":LgGroupID,"LgUserID":LgUserID,"LgLocID":LgLocID,"EpisodeID":EpisodeID},function(jsonString){

		if (jsonString != ""){
			NotTakOrdMsg = jsonString;
		}
	},'',false)

	return NotTakOrdMsg;
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

/// 打印
function Print(){
	if (CstID == ""){
		$.messager.alert("提示","请发送会诊申请后，再打印！","warning");
		return;
	}
	if(PrintWay==1){
	    window.open("dhcmdt.printconsmdtopin.csp?CstID="+CstID+"&MWToken="+websys_getMWToken());
	}else{
	    PrintCons(CstID);  /// 打印会诊申请单	
	}
	return;
}


/// 打印告知单
function printInfoSing(){
	
	if (CstID == ""){
		$.messager.alert("提示","请发送会诊申请后，再打印！","warning");
		return;
	}
	
	var MdtDisGrp=$HUI.combobox("#mdtDisGrp").getValue();
	PrintCst_REQ(CstID,MdtDisGrp);  /// 打印会诊申请单
	InsCsMasPrintFlag(CstID,"Z"); ///修改申请打印字段 
	return;
}

/// 打印之情同意书
function PrintInfoCons(){
	
	if (CstID == ""){
		$.messager.alert("提示","请发送会诊申请后，再打印！","warning");
		return;
	}
	PrintConsent(CstID);
	return;
}

/// 打印之情同意书
function PrintConfApp(){
	
	if (CstID == ""){
		$.messager.alert("提示","请发送会诊申请后，再打印！","warning");
		return;
	}
	
	PrintMakeDoc(CstID);
	return;
}

/// 验证病人是否允许开会诊
function InitPatNotTakCst(TipFlag){
	
	TakCstMsg = GetPatNotTakCst();
	if ((TakCstMsg != "")&(TipFlag == 1)){
		$.messager.alert("提示",TakCstMsg,"warning");
		return;	
	}
}

/// 取当前登陆人可操作的会诊类型
function GetPatNotTakCst(){
	
	var NotTakCstMsg = "";
	runClassMethod("web.DHCEMConsultCom","JsonCstType",{"HospID":LgHospID, "LgUserID":LgUserID},function(jsonObject){

		if (jsonObject != null){
			if (jsonObject.length == 0){
				NotTakCstMsg = "当前登陆人未分配会诊类型，请联系管理部门处理！";
			};
		}
	},'json',false)

	return NotTakCstMsg;
}

/// 获取病人的诊断记录数
function GetMRDiagnoseCount(){

	var Count = 0;
	/// 调用医生站的判断
	runClassMethod("web.DHCAPPExaReport","GetMRDCount",{"EpisodeID":EpisodeID},function(jsonString){
		
		if (jsonString != ""){
			Count = jsonString;
		}
	},'',false)

	return Count;
}

/// 获取医疗结算标志
function GetIsMidDischarged(){

	var MidDischargedFlag = 0;
	/// 调用医生站的判断
	runClassMethod("web.DHCAPPExaReport","GetIsMidDischarged",{"EpisodeID":EpisodeID},function(jsonString){
		
		if (jsonString != ""){
			MidDischargedFlag = jsonString;
		}
	},'',false)

	return MidDischargedFlag;
}

/// 查询患者是否正在住院
function GetPatInHosEpisID(){

	var InHospEpisID = "";
	runClassMethod("web.DHCMDTCom","PatInIPAdmID",{"PatientID":PatientID},function(jsonString){
		
		if (jsonString != ""){
			InHospEpisID = jsonString;
		}
	},'',false)

	return InHospEpisID;
}

/// 获取查看病历权限
function GetEmrAutFlag(){

	var EmrAutFlag = "";
	runClassMethod("web.DHCEMConsult","GetEmrAutID",{"itmID":CstItmID},function(jsonString){
		
		EmrAutFlag = jsonString;
	},'',false)

	return EmrAutFlag;
}

/// 弹出诊断窗口
function DiagPopWin(){
	
	var lnk = "diagnosentry.v8.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&MWToken="+websys_getMWToken();
	//window.showModalDialog(lnk, "_blank", "dialogHeight: " + (top.screen.height - 100) + "px; dialogWidth: " + (top.screen.width - 100) + "px");
	window.open(lnk, 'newWin', 'height='+ (window.screen.availHeight-200) +', width='+ (window.screen.availWidth-200) +', top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// 弹出医嘱录入窗口
function OpenCsOrderWin(){
	
	if (EpisodeID == ""){
		$.messager.alert("提示","请选择会诊记录后重试！","warning");
		return;
	}
	var lnk = "dhcem.consultorder.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&MWToken="+websys_getMWToken();
	websys_showModal({
		url:lnk,
		title:'医嘱录入',
		width:screen.availWidth-150,height:screen.availHeight-150,
		onClose: function() {
			tkMakeServerCall("web.DHCDocMainOrderInterface","ChartItemChange");
		}
	});
}

/// 根据疑难病种取关联号别
function GetCareProvByGrp(mID){

	runClassMethod("web.DHCMDTCareProv","GetCareProvByGrp",{"mID":mID},function(jsonObject){
		
		if (jsonObject != null){
			CarPrvID = jsonObject.PrvID;
			RBResID = jsonObject.RBResID;
			$('#mdtCarPrv').val(jsonObject.PrvDesc);  /// 资源号别
			$("#mdtAddr").val(jsonObject.Address);
		}
	},'json',false)
}

/// 显示排版窗口
function RsPrvWin(){
	
	var mdtDisGrp = $HUI.combobox("#mdtDisGrp").getValue();
	if (mdtDisGrp == "") {
		$.messager.alert("提示","疑难病种不能为空！","warning");
		return;
	}
	
	if (HasCenter == 1){
		parent.$.messager.alert("提示","会诊预约时间以疑难病会诊中心安排时间为主！","warning",function(){
			var Link = "dhcmdt.makeresources.csp?DisGrpID="+mdtDisGrp +"&EpisodeID="+ EpisodeID+"&MWToken="+websys_getMWToken();
			mdtPopWin(1, Link); /// 弹出MDT会诊处理窗口
		});
	}else{
		var Link = "dhcmdt.makeresources.csp?DisGrpID="+mdtDisGrp +"&EpisodeID="+ EpisodeID+"&MWToken="+websys_getMWToken();
		mdtPopWin(1, Link); /// 弹出MDT会诊处理窗口
	}
}

/// 弹出MDT会诊处理窗口
function mdtPopWin(WidthFlag, Link){
	
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		iconCls:'icon-w-paper',
		closed:"true"
	};
	$("#mdtFrame").attr("src",Link);
	if (WidthFlag == 1){
		$("#mdtFrame").height(380);
		$("#mdtWinTools").show();
		new WindowUX('排班资源', 'mdtWin', 880, 460, option).Init();
	}else if (WidthFlag == 2){
		$("#mdtFrame").height(480);
		$("#mdtWinTools").hide();
		new WindowUX('会诊专家组<span style="color:red">【会诊专家先后按拼音排序】</span>', 'mdtWin', 880, 520, option).Init();
	}else{
		$("#mdtWinTools").hide();
		$("#mdtFrame").height(380);
		new WindowUX('会诊目的模板', 'mdtWin', 880, 420, option).Init();
	}
}

/// 预约时间
function TakPreTime(){
	
	if (!frames[1].GetPatMakRes()) return;

	TakClsWin(); /// 关闭弹出窗口
}

/// 关闭弹出窗口
function TakClsWin(){

	$("#mdtWin").window("close");        /// 关闭弹出窗口
}

/// 发送MDT申请时，超过指定时间点时，提醒医生
function isPermitTakMdt(){

	var isPerTakMdtFlag = "";
	runClassMethod("web.DHCMDTConsultQuery","isPermitTakMdt",{"mParams":""},function(jsonString){
		
		isPerTakMdtFlag = jsonString;
	},'',false)

	return isPerTakMdtFlag;
}

/// 选择模板
function TakTemp(){
    var mdtDisGrp = $HUI.combobox("#mdtDisGrp").getValue();
    
	if (mdtDisGrp == "") {
		$.messager.alert("提示","疑难病种不能为空！","warning");
		return;
	}
	
	var Link = "dhcmdt.template.csp?DisGrpID="+mdtDisGrp+"&MWToken="+websys_getMWToken();
	mdtPopWin(0, Link); /// 弹出MDT会诊处理窗口
}

/// 保存模板
function SaveTemp(){
	
	var mdtPurpose = $("#mdtPurpose").val();   /// 会诊目的
	if (mdtPurpose.replace(/\s/g,'') == ""){
		$.messager.alert('提示','会诊目的不能为空！','warning');
		return;
	}
	var mdtDisGrp = $HUI.combobox("#mdtDisGrp").getValue();
	if (mdtDisGrp == "") {
		$.messager.alert("提示","疑难病种不能为空！","warning");
		return;
	}
	var mdtCode = mdtPurpose.substring(0, 6);
	var mListData= "" +"^"+ mdtCode +"^"+ mdtPurpose +"^M^"+mdtDisGrp +"^"+LgHospID;
	//保存数据
	runClassMethod("web.DHCMDTOpiTemp","save",{"mParam":mListData},function(jsonString){

		if (jsonString == 0){
			$.messager.alert('提示','保存成功！','warning');
		}else{
			$.messager.alert('提示','保存失败！','warning');
		}
	})
}

/// 添加科室
function AddLocWin(){
	
	var mdtDisGrp = $HUI.combobox("#mdtDisGrp").getValue();
	if (mdtDisGrp == "") {
		$.messager.alert("提示","疑难病种不能为空！","warning");
		return;
	}
	if (TakGrpLocModel == 1){
		/// 插入空行
		if (isEditFlag == 1) return;
    	var rowObj={PrvTpID:'', PrvTp:'', LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:''};
		$("#LocGrpList").datagrid('appendRow',rowObj);
	}else{
		var Link = "dhcmdt.makresloc.csp?DisGrpID="+ mdtDisGrp +"&Type=G"+"&MWToken="+websys_getMWToken();
		//mdtPopWin(2, Link); /// 弹出MDT会诊处理窗口
		window.parent.commonShowWin({
			url: Link,
			title: '会诊专家组',
			width: 880,
			height: 520
		})
	}
}

/// 清空
function Clear(FlagCode){
	
	if (FlagCode == "G"){
		/// 组内科室
		$("#LocGrpList").datagrid("reload",{GrpID:''});
	}
	if (FlagCode == "I"){
		/// 院内科室
		$("#dgCstDetList").datagrid("reload",{GrpID:''});
	}
	if (FlagCode == "O"){
		/// 外院专家
		$("#OuterExpList").datagrid("load",{GrpID:''}); 
	}
}

/// 链接
function SetLocCellUrl(value, rowData, rowIndex){	
	if(HISUIStyleCode==="lite"){ // 2023-01-04
		var html = '<a href="javascript:void(0)" class="icon-cancel" style="color:#000;" onclick="delRow(\''+ rowIndex +'\',\''+ "LocGrpList" +'\')"></a>';
	    //html +='<a href="javascript:void(0)" class="icon-add" style="color:#000;" onclick="insRow()"></a>';
	}else{
		var html = '<a href="javascript:void(0)" onclick="delRow(\''+ rowIndex +'\',\''+ "LocGrpList" +'\')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png" border=0/></a>';
	    //html += '<a href="javascript:void(0)" onclick="insRow()"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/add.png" border=0/></a>';
	}
	//var html = '<a href="#" onclick="delRow(\''+ rowIndex +'\',\''+ "LocGrpList" +'\')"><img src="../scripts/dhcnewpro/images/cancel.png" border=0/></a>';
	    //html += "<a href='#' onclick='insRow()'><img src='../scripts/dhcnewpro/images/edit_add.png' border=0/></a>";
	return html;
}

/// 初始化科室组列表
function InitLocGrpGrid(){
	
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
			url: $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonPrvTp"+"&MWToken="+websys_getMWToken(),
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			//panelHeight:"auto",  //设置容器高度自动增长
			blurValidValue:true,
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				if ($(ed.target).val() == ""){
					var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
					$(ed.target).combobox('setValue', "");
					$.messager.alert("提示","请先确定专家科室！","warning");
					return;
				}
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', option.text);

				///设置级联指针
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val();
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
			},
			onChange:function(newValue, oldValue){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				if (newValue == ""){
					var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
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
			url: $URL +"?ClassName=web.DHCMDTCom&MethodName=JsonLoc&HospID"+session['LOGON.HOSPID']+"&MWToken="+websys_getMWToken(),
			blurValidValue:true,
			onSelect:function(option) {
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				$(ed.target).val(option.value);
				
				/// 联系方式
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'TelPhone'});
				$(ed.target).val(GetLocTelPhone(option.value));
				
				///清空医生
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val("");
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
				/// 清空职称
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				$(ed.target).val("");
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', "");
				
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var DisGrpID = $HUI.combobox("#mdtDisGrp").getValue(); /// 疑难病种
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'LocDesc'});
				var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonGrpLoc&DisGrpID="+DisGrpID+"&MWToken="+websys_getMWToken();
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
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val(option.value);
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', option.text);
				
				/// 联系方式
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'TelPhone'});
				$(ed.target).val(GetCareProvPhone(option.value));
				
				$m({
					ClassName:"web.DHCMDTCom",
					MethodName:"GetPrvTpIDByCareProvID",
					CareProvID:option.value
				},function(txtData){
					var ctpcpCtInfo = txtData;
					var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
					$(ed.target).combobox('setValue', ctpcpCtInfo.split("^")[1]);
					var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
					$(ed.target).val(ctpcpCtInfo.split("^")[0]);
				});
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
			    
			    var DisGrpID = $HUI.combobox("#mdtDisGrp").getValue(); /// 疑难病种
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				var LocID = $(ed.target).val();
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				var PrvTpID = $(ed.target).val();
				///设置级联指针
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocCareProv&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&DisGrpID="+ DisGrpID+"&MWToken="+websys_getMWToken();
				$(ed.target).combobox('reload',unitUrl);
			
			},
			onChange:function(newValue, oldValue){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				if (newValue == ""){
					var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
					$(ed.target).val();
				}
			}
		}
	}
	
	///  定义columns
	var hideFlags=""
	if(CstID!=""){
		hideFlags="true"
	}
	var columns=[[
		{field:'LocID',title:'科室ID',width:20,align:'left',hidden:true,editor:texteditor},
		{field:'LocDesc',title:'科室',width:200,align:'left',editor:LocEditor},
		{field:'UserID',title:'医生ID',width:20,align:'left',hidden:true,editor:texteditor},
		{field:'UserName',title:'医生',width:120,align:'left',editor:DocEditor,styler: slUserName},
		{field:'TelPhone',title:'联系方式',width:100,align:'left',editor:texteditor},
		{field:'PrvTpID',title:'职称ID',width:20,align:'left',hidden:true,editor:texteditor},
		{field:'PrvTp',title:'职称',width:100,align:'left',hidden:false,editor:PrvTpEditor},
		{field:'operation',title:"操作",width:100,align:'left',formatter:SetLocCellUrl,hidden:hideFlags}
	]];
	
	///  定义datagrid
	var option = {
		border:true, //hxy 2023-02-07 st
		bodyCls:'panel-header-gray', //ed
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
                                    
            if ((editExpRow != -1)||(editExpRow == 0)) { 
                $("#OuterExpList").datagrid('endEdit', editExpRow); 
            }
            
            if ((editGrpRow != -1)||(editGrpRow == 0)) { 
                $("#LocGrpList").datagrid('endEdit', editGrpRow); 
            }
            $("#LocGrpList").datagrid('beginEdit', rowIndex); 
            
            /// 联系方式
			var ed=$("#LocGrpList").datagrid('getEditor',{index:rowIndex,field:'TelPhone'});
			$(ed.target).attr("disabled", true);
			
            editGrpRow = rowIndex;    
        }
	};
		var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&CstID=&Type=I"+"&MWToken="+websys_getMWToken();

//	$('#LocGrpList').datagrid({
//		url:uniturl,
//		option:option,
//		columns:columns
//		})
	
	/// 就诊类型
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&CstID=&Type=I"+"&MWToken="+websys_getMWToken();
	new ListComponent('LocGrpList', columns, uniturl, option).Init();
}

/// 初始化外院专家列表
function InitOuterExpGrid(){
	
	/// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	/// 编辑格必填
	var validEditor={
		type:'validatebox',
		options:{
			required:true
		}
	}
	
	
	/// 编辑格
	var numbereditor={
		type: 'numberbox',//设置编辑格式
		options: {
			//required: true //设置编辑规则属性
		}
	}
	
	// 职称编辑格
	var PrvTpEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonPrvTp"+"&MWToken="+websys_getMWToken(),
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			//panelHeight:"auto",  //设置容器高度自动增长
			blurValidValue:true,
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#OuterExpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#OuterExpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', option.text);
			},
			onChange:function(newValue, oldValue){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				if (newValue == ""){
					var ed=$("#OuterExpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
					$(ed.target).val("");
				}
			}
		}
	}
	
	/// 科室
	var LocEditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:$URL+"?ClassName=web.DHCMDTDicItem&MethodName=jsonParDicItem&mCode=OutLoc&HospID="+ LgHospID+"&MWToken="+websys_getMWToken(),
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				///设置类型值
				var ed=$("#OuterExpList").datagrid('getEditor',{index:modRowIndex,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#OuterExpList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				$(ed.target).val(option.value); 
			}
		}
	}
	
	///  定义columns
	var hideFlags=""
	if(CstID!=""){
		hideFlags="true"
	}
	var columns=[[
		{field:'LocID',title:'科室ID',width:100,align:'left',hidden:true,editor:texteditor},
		{field:'LocDesc',title:'科室',width:200,align:'left',editor:LocEditor},
		{field:'UserID',title:'医生ID',width:110,align:'left',hidden:true,editor:texteditor},
		{field:'UserName',title:'医生',width:120,align:'left',editor:validEditor,styler: slUserName,formatter:userNameFormat},
		{field:'TelPhone',title:'联系方式',width:100,align:'left',editor:numbereditor},
		{field:'PrvTpID',title:'职称ID',width:100,align:'left',hidden:true,editor:texteditor},
		{field:'PrvTp',title:'职称',width:160,align:'left',hidden:false,editor:PrvTpEditor},
		{field:'AssUser',title:'关联院内用户',width:100,align:'center',hidden:!hideFlags},
		{field:'operation',title:"操作",width:100,align:'left',formatter:SetExpCellUrl,hidden:hideFlags}
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
	    onClickRow: function (rowIndex, rowData) {
			
			if (isEditFlag == 1) return;
			
			if ((editGrpRow != -1)||(editGrpRow == 0)) { 
                $("#LocGrpList").datagrid('endEdit', editGrpRow); 
            }
            
            if ((editSelRow != -1)||(editSelRow == 0)) { 
                $("#dgCstDetList").datagrid('endEdit', editSelRow); 
            }
            
            if ((editExpRow != -1)||(editExpRow == 0)) { 
            	if($("#OuterExpList").datagrid('validateRow', editExpRow)){
	            	$("#OuterExpList").datagrid('endEdit', editExpRow); 	
	            }else{
		        	return;    
		        }
            }
            
            if (rowData.UserID != "") return;
            
            $("#OuterExpList").datagrid('beginEdit', rowIndex); 
			
            editExpRow = rowIndex;    
        }
	};
	/// 就诊类型
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&CstID=&Type=E"+"&MWToken="+websys_getMWToken();
	new ListComponent('OuterExpList', columns, uniturl, option).Init();
}
/// 链接
function SetExpCellUrl(value, rowData, rowIndex){	

	if(HISUIStyleCode==="lite"){ // 2023-01-04
		var html = '<a href="javascript:void(0)" class="icon-cancel" style="color:#000;" onclick="delRow(\''+ rowIndex +'\',\''+ "OuterExpList" +'\')"></a>';
	    //html +='<a href="javascript:void(0)" class="icon-add" style="color:#000;" onclick="insRow()"></a>';
	}else{
		var html = '<a href="javascript:void(0)" onclick="delRow(\''+ rowIndex +'\',\''+ "OuterExpList" +'\')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png" border=0/></a>';
	    //html += '<a href="javascript:void(0)" onclick="insRow()"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/add.png" border=0/></a>';
	}

	//var html = '<a href="#" onclick="delRow(\''+ rowIndex +'\',\''+ "OuterExpList" +'\')"><img src="../scripts/dhcnewpro/images/cancel.png" border=0/></a>';
	return html;
}

/// 插入空行
function insExpRow(){
	
	if (isEditFlag == 1) return;
			
    var rowObj={UserID:'', UserName:''};
	$("#OuterExpList").datagrid('appendRow',rowObj);
}

function mdtUpload(){
	if (CstID == ""){
		$.messager.alert("提示:","请发送会诊申请后，再上传！","warning");
		return;
	}
	var lnk = "dhcmdt.uploadify.csp?MdtCstID="+CstID+"&MWToken="+websys_getMWToken();
	commonShowWin({
		url: lnk,
		title: '上传查看文件',
		width:PageWidth,height:screen.availHeight-150,
	});
}

/// 发送后调用自动打印函数
function InvAutoPrint(){
	
	if (HasCenter == 1) return;
	if ((PatType != "I")&(LocAppPriFlag == 1)){
		PrintZJYYD();  /// 打印诊间预约单
	}
	if (TakArgPriFlag == 1){
		PrintZQTYS();  /// 打印知情同意书
	}
}
/// 读卡
function readCard(){
	
	Inv_ReadCardCom(GetPatLastEpi);  /// 读卡公共函数
}

/// 登记号
function PatNo_KeyPre(e){

	if(e.keyCode == 13){
		var PatNo = $("#PatNo").val();
		if (!PatNo.replace(/[\d]/gi,"")&(PatNo != "")){
			///  登记号补0
			$("#PatNo").val(GetWholePatNo(PatNo));
		}
		var PatNo = $("#PatNo").val();
		GetPatLastEpi({"PatNo": PatNo});  /// 取病人信息
	}
}

/// 取病人最后一次就诊信息
function GetPatLastEpi(PatObj){
	
	if ((PatObj.PatNo == "")||(typeof PatObj.PatNo == "undefined")) return;
	runClassMethod("web.DHCMDTConsultQuery","GetPatLastEpi",{"PatNo": PatObj.PatNo},function(jsonObject){
		
		if (!$.isEmptyObject(jsonObject)){
			PatientID = jsonObject.PatientID;   /// 病人ID
			EpisodeID = jsonObject.EpisodeID;   /// 就诊ID
			mradm = jsonObject.mradm;           /// 就诊诊断ID
//			LoadPageWriEl();  /// 取登录信息
//			GetPatEssInfo();  /// 取病人信息
			var frm = dhcsys_getmenuform();
			if (frm) {
				frm.PatientID.value = PatientID;
				frm.EpisodeID.value = EpisodeID;
				frm.mradm.value = mradm;
			}
			parent.Flag="Y";
			parent.initFrameSrc();   /// 刷新框架资源
			parent.getPatBaseInfo(); /// 病人就诊信息
			parent.refreshComboGrid(EpisodeID); /// 刷新 combogrid
		}else{
			$.messager.alert('提示',"登记号输入错误！","warning");
			return;
		}
	},'json',false)
}

/// 取病人信息
function GetPatEssInfo(){
	
	runClassMethod("web.DHCMDTConsultQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		
		 $("#PatName").val(jsonString.PatName); /// 姓名
		 $("#PatSex").val(jsonString.PatSex);	/// 性别
		 $("#PatAge").val(jsonString.PatAge);	/// 年龄
		 $("#PatNo").val(jsonString.PatNo);		/// 登记号
		 $("#PatBed").val(jsonString.PatBed);	/// 床号
		 $("#PatBill").val(jsonString.PatBill); /// 费别
		 $("#PatDiagDesc").val(jsonString.PatDiagDesc);/// 诊断
	},'json',false)
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
			$.messager.alert('提示',"登记号输入错误！");
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;

}

/// 病种是否关联费用
function isTakOrder(DisGrpID){

	var isTakOrderFlag = "";
	runClassMethod("web.DHCMDTConsultQuery","isTakOrder",{"DisGrpID":DisGrpID},function(jsonString){
		
		isTakOrderFlag = jsonString;
	},'',false)

	return isTakOrderFlag;
}

/// 外院专家快捷方式
function shortcut_selOuterExp(){
	
	var mdtDisGrp = $HUI.combobox("#mdtDisGrp").getValue();
	if (mdtDisGrp == "") {
		$.messager.alert("提示","疑难病种不能为空！","warning");
		return;
	}
	
	var Link = "dhcmdt.makresloc.csp?DisGrpID="+ mdtDisGrp +"&Type=E"+"&MWToken="+websys_getMWToken();
	window.parent.commonShowWin({
		url: Link,
		title: $g("外院专家快捷选择"),
		width: 900,
		height: 500
	})
}

/// 多语言支持
function multi_Language(){
	
	$g("提示");
	$g("没有权限发送MDT申请！")
	$g("请先确定专家科室！")
	$g("疑难病种不能为空！")
	$g("会诊目的不能为空！")
	$g("病情摘要不能为空！")
	$g("会诊预约时间以疑难病会诊中心安排时间为主！")
	$g("请选择会诊记录后重试！")
	$g("请发送会诊申请后，再打印！")
	$g("您无权限查看该病人病历内容！")
	$g("请保存会诊后，再开启授权！")
	$g("更新会诊打印状态失败，失败原因:")
	$g("会诊申请取消完成失败，失败原因:")
	$g("会诊申请完成失败，失败原因:")
	$g("撤销会诊失败，失败原因:")
	$g("会诊申请发送失败，失败原因:")
	$g("会诊申请保存失败，失败原因:")
	$g("会诊科室不能为空！")
	$g("会诊专家组成员不允许少于3人！")
	$g("已经取号不允许撤销")
	$g("当前状态非发送状态不允许撤销")
	$g("您确定要取消当前会诊申请吗？")
	$g("请先选择会诊申请，再进行此操作！")
	$g("会诊申请发送失败，失败原因病人已经具有当日此号别，不允许再次预约！")
	$g("申请单当前状态，不允许取消完成操作！")
	$g("会诊时间不能早于申请时间！")
	$g("请发送会诊申请后，再打印！")
	$g("申请单当前状态，不允许进行完成操作！")
	$g("请填写会诊意见！")
	$g("抗生素会诊必须填写是否同意用药!")
	$g("申请单当前状态，不允许进行完成操作！")
	$g("请填写会诊意见！")
	$g("您非当前会诊人员，不能进行此操作！")
	$g("申请单已发送，不能再次发送！")
	$g("请保存会诊申请后，再发送！")
	$g("此病人已做医疗结算,不允许医生再开医嘱！")
	$g("病人没有诊断,请先录入！")
	$g("是否发送申请单?")
	$g("预约信息不能为空！")
	$g("病种号别不能为空！")
	$g("患者当前正在住院，是否将费用计入住院费用中?(点击确认按钮按住院收费，点击取消按钮按门诊收费")
	$g("确认对话框")
	$g("请先选择行")
	$g("取消成功！")
	$g("保存失败！")
	$g("保存成功！")
	$g("完成成功！")
	$g("修改失败！")
	$g("修改成功！")
	$g("发送成功！")
}

/// 自动设置图片展示区分布
function onresize_handler(){

	setTimeout(function(){
		$HUI.datagrid("#dgCstDetList").resize();
		$HUI.datagrid("#LocGrpList").resize();
		$HUI.datagrid("#OuterExpList").resize();	
	},200)

	return;
	var Width = document.body.offsetWidth;
	var Height = window.screen.availHeight;
	$(".p-content").width(Width - 40);
	return;
}

/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {

	if (CstID != ""){
		LoadReqFrame();  /// 加载MDT申请单内容
	}else{
		LoadPageWriEl();  /// 取登录信息
		GetPatBaseInfo(); /// 病人就诊信息
	}
	
	/// 自动分布
	onresize_handler();
}

function formatHtmlToValue(text){
	text = text.replace(new RegExp('&nbsp;',"g"),' '); //text.replaceAll("&nbsp;"," ");
	text = text.replace(new RegExp('&nbsp',"g"),' '); //text.replaceAll("&nbsp"," ");
	return text;
}

function getWidth(){
	
	var width=$(".ph-title").css("width")
	var twidth = width.split("px")[0]-20
	PageWidth=twidth
	$(".dataWidth").css("width",twidth+"px")
	}
	
	
window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })


function InitMoreScreen(){
	if(!IsOpenMoreScreen) return;
	
	ListenRetValue();
}
function ListenRetValue(){
	websys_on("onMdtRefData",function(res){
		if(res.flag===''){
			var nowValue = $("#mdtTrePro").val();
			$("#mdtTrePro").val( nowValue+(nowValue?'\r\n':'')+res.text);
		}
	});
}

function slUserName(value,row,index){
	//console.log(row);
	if (row.IsContact === "Y"){
		return 'color:#00F;';
	}
}

function userNameFormat(value, rowData, rowIndex){
	return value;
}
