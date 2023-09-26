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
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
var del = String.fromCharCode(2);
/// 页面初始化函数
function initPageDefault(){
	InitPatEpisodeID();       /// 初始化加载病人就诊ID
	InitPageComponent(); 	  /// 初始化界面控件内容
	InitPageDataGrid();		  /// 初始化页面datagrid
	InitLocGrpGrid();	      /// 初始化页面datagrid
	if (EpisodeID == ""){
		HidePageButton(4);	  /// 初始化界面按钮
	}else{
		HidePageButton(5);	  /// 初始化界面按钮
	}
	multi_Language();         /// 多语言支持
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){

	PatientID = getParam("PatientID");   /// 病人ID
	EpisodeID = getParam("EpisodeID");   /// 就诊ID
	mradm = getParam("mradm");           /// 就诊诊断ID
	CstID = getParam("ID");              /// 会诊ID
	seeCstType = getParam("seeCstType"); /// 会诊查看模式
	LODOP = "" //getLodop();
	if(seeCstType==1) return;
	if (EpisodeID == ""){
		$("#openemr").hide();
	}
	if ((EpisodeID != "")&(CstID == "")){
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

	    },
	    onShowPanel: function () { //数据加载完毕事件
			///设置级联指针
			//var unitUrl = $URL+"?ClassName=web.DHCMDTGroup&MethodName=jsonGroup";
			var unitUrl = $URL+"?ClassName=web.DHCMDTGroup&MethodName=jsonGroup&LgParams="+LgParam;
			
			$("#mdtDisGrp").combobox('reload',unitUrl);
        }
	};
	
	var url = "";
	new ListCombobox("mdtDisGrp",url,'',option).init();
	
	/// 登记号
	$("#PatNo").bind('keypress',PatNo_KeyPre);
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
			 $("#PatDiagDesc").val(jsonObject.PatDiagDesc); /// 诊断
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
			url: $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonPrvTp",
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
			url: $URL +"?ClassName=web.DHCMDTCom&MethodName=JsonLoc&HospID"+session['LOGON.HOSPID'],
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
					
					var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonGrpLoc&DisGrpID="+DisGrpID;
				}else{
					
					var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLoc&HospID="+LgHospID;
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
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocCareProv&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&DisGrpID="+ GrpID;
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
		{field:'HosID',title:'HosID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'HosType',title:'院内院外',width:110,editor:HosEditor,align:'center',hidden:true},
		{field:'LocID',title:'科室ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'LocDesc',title:'科室',width:200,editor:LocEditor,align:'center'},
		{field:'UserID',title:'医生ID',width:110,editor:texteditor,align:'center',hidden:true},
		{field:'UserName',title:'医生',width:120,editor:DocEditor,align:'center'},
		{field:'TelPhone',title:'联系方式',width:100,editor:texteditor,align:'center'},
		{field:'PrvTpID',title:'职称ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'PrvTp',title:'职称',width:160,editor:PrvTpEditor,align:'center',hidden:false},
		{field:'operation',title:"操作",width:100,align:'center',formatter:SetCellUrl,hidden:hideFlag}  
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
			
			if ((editGrpRow != -1)||(editGrpRow == 0)) { 
                $("#LocGrpList").datagrid('endEdit', editGrpRow); 
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
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&CstID=&Type=O";
	new ListComponent('dgCstDetList', columns, uniturl, option).Init();
}

/// 链接
function SetCellUrl(value, rowData, rowIndex){	
	var html = '<a href="#" onclick="delRow(\''+ rowIndex +'\',\''+ "dgCstDetList" +'\')"><img src="../scripts/dhcnewpro/images/cancel.png" border=0/></a>';
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
	
	GetMarIndDiv("", ""); 	/// 取科室亚专业指征
}

/// 插入空行
function insRow(){
	
	if (isEditFlag == 1) return;
			
    var rowObj={PrvTpID:'', PrvTp:'', HosID:'O', HosType:'院内', LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:''};
	$("#dgCstDetList").datagrid('appendRow',rowObj);
}

/// 保存mdt申请
function mdtSave(){

	var InHosEpisID = GetPatInHosEpisID(); /// 患者是否正在住院ID
	if ((InHosEpisID != "")&(PatType != "I")){
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
	if ((memControlFlag == 1)&(LocArr.length < 3)){
		$.messager.alert("提示","会诊专家组成员不允许少于3人！","warning");
		return;	
	}
	if (TmpCarePrv != ""){
		$.messager.alert("提示","会诊专家："+ TmpCarePrv +"，重复添加！","warning");
		return;	
	}
	
	var ConsDetList = ConsDetArr.join("@");
	if (ConsDetList == ""){
		$.messager.alert("提示","会诊科室不能为空！","warning");
		return;	
	}
	
	var mListData = TmpEpisodeID +"^"+ LgUserID +"^"+ LgLocID +"^"+ mdtTrePro +"^"+ mdtPurpose +"^"+ mdtAddr;  //1-6
		mListData += "^"+ mdtPreData +"^"+ mdtPreTime +"^"+ mdtUser +"^"+ mdtTele +"^"+ mdtDisGrp +"^"+ RBResID; //7-12
		mListData += "^"+ AppSclID +"^"+ mdtTimes +"^"+ PatientID;

	///             主信息  +"&"+  会诊科室
	var mListData = mListData +del+ ConsDetList;

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
	
	var link = "emr.interface.browse.category.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID'];
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
			$(".tip").text("");
			InvAutoPrint();  /// 发送后调用自动打印函数
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
	var link = "dhcem.consultpupwin.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm;
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
	GetConsMarIndDiv();	        /// 取会诊科室亚专业指征
	isShowPageButton();         /// 动态设置页面显示的按钮内容
	if (EpisodeID != ""){
		InitPatNotTakOrdMsg(0); /// 验证病人是否允许开申请
	}
	$("#dgCstDetList").datagrid("load",{"ID":CstID});      /// 会诊科室
	$("#LocGrpList").datagrid("load",{"ID":CstID});      /// 会诊科室
	if(seeCstType){ 
		$("#OpBtns").hide();
		$(".p-content").css({"top":25});
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

	if (document.body.clientWidth > 1000){
		$("#TabMain").attr("src","dhcem.consultemraut.csp?EpisodeID="+ EpisodeID +"&CstID="+ CstID);
		/// 新建会诊授权窗口
		newCreateConsultWin();	
	}else{
		var lnk ="dhcem.consultemraut.csp?EpisodeID="+ EpisodeID +"&CstID="+ CstID;
		window.open(lnk, 'newWin', 'height=550, width=1000, top=200, left=200, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
	}
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

	var Link = "dhcem.patemrque.csp?EpisodeID="+EpisodeID+"&PatientID="+PatientID;
//	if (!isIE()){
	window.parent.commonShowWin({
		url: Link,
		title: "引用",
		width: 1280,
		height: 600
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
		$("#bt_com").hide();   /// 完成
		$("#bt_ceva").hide();  /// 评价
		$("#bt_ord").hide();   /// 医嘱录入
		$("#bt_log").hide();   /// 会诊日志
		$("#bt_revcom").hide();/// 取消完成
		
		$("#bt_save").show();  /// 保存
		$("#bt_send").show();  /// 发送
		$("#bt_can").show();   /// 取消
		$("#bt_openemr").show();   /// 开启授权
		//$("#Opinion").show();   /// 会诊意见
		$("#QueEmr").show();    /// 引用
		$("#TakTemp").show();   /// 选择模板
		$("#SaveTemp").show();  /// 保存模板
		$("#bt_order").hide();  /// 医嘱录入
		$("#bt_patemr").hide(); /// 查看病历
		$("#bt_grpaddloc").show(); /// 组内科室添加
		$("#bt_grpcencel").show(); /// 组内科室清空
		$("#bt_addloc").show();    /// 院内科室添加
		$("#bt_cencel").show();    /// 院内科室清空
		PageEditFlag(1);	    /// 页面编辑
		isEditFlag = 0;	        /// 行编辑标志
		if (CstOutFlag == "Y") isEditFlag = 1;
	}
	/// 请会诊  申请已发送
	if (BTFlag == 2){
		$("#bt_save").hide();  /// 保存
		$("#bt_send").hide();  /// 发送
		$("#bt_com").show();   /// 完成
		$("#bt_ord").hide();   /// 医嘱录入
		$("#bt_openemr").show();   /// 开启授权
		$("#bt_order").hide();     /// 医嘱录入
		$("#bt_patemr").hide();    /// 查看病历

		$("#bt_can").show();   /// 取消
		//$("#Opinion").show();  /// 会诊意见
		$("#QueEmr").hide();   /// 引用
		$("#TakTemp").hide();  /// 选择模板
		$("#SaveTemp").hide(); /// 保存模板
		$("#bt_log").show();   /// 会诊日志
		$("#bt_revcom").hide();/// 取消完成
		$("#bt_grpaddloc").hide(); /// 组内科室添加
		$("#bt_grpcencel").hide(); /// 组内科室清空
		$("#bt_addloc").hide();    /// 院内科室添加
		$("#bt_cencel").hide();    /// 院内科室清空
		PageEditFlag(2);	   /// 页面编辑
		isEditFlag = 1;	       /// 行编辑标志
	}

	/// 会诊显示
	if (BTFlag == 3){
		$("#bt_save").hide();  /// 保存
		$("#bt_send").hide();  /// 发送
		$("#bt_can").hide();   /// 取消
		$("#bt_openemr").hide();   /// 开启授权
		$("#bt_ord").hide();   /// 医嘱录入
		$("#QueEmr").hide();   /// 引用
		$("#TakTemp").hide();  /// 选择模板
		$("#SaveTemp").hide(); /// 保存模板
		$("#bt_com").hide();   /// 完成
		//$("#Opinion").show();  /// 会诊意见
		$("#bt_log").show();       /// 会诊日志
		$("#bt_patemr").show();    /// 查看病历
		$("#bt_grpaddloc").hide(); /// 组内科室添加
		$("#bt_grpcencel").hide(); /// 组内科室清空
		$("#bt_addloc").hide();    /// 院内科室添加
		$("#bt_cencel").hide();    /// 院内科室清空
		if (CsStatCode == "完成"){
			$("#bt_revcom").show();/// 取消完成
		}else{
			$("#bt_revcom").hide();/// 取消完成
		}
		PageEditFlag(0);	   /// 页面编辑
		isEditFlag = 1;	       /// 行编辑标志
	}
	/// 其他人显示
	if (BTFlag == 4){
		$("#bt_save").hide();  /// 保存
		$("#bt_send").hide();  /// 发送
		$("#bt_can").hide();   /// 取消
		$("#bt_com").hide();   /// 完成
		$("#bt_ord").hide();   /// 医嘱录入
		$("#bt_patemr").hide();    /// 查看病历
		$("#bt_openemr").hide();   /// 开启授权
		//$("#Opinion").show();  /// 会诊意见
		$("#QueEmr").hide();   /// 引用
		$("#TakTemp").hide();  /// 选择模板
		$("#SaveTemp").hide(); /// 保存模板
		$("#bt_log").hide();   /// 会诊日志
		$("#bt_revcom").hide();/// 取消完成
		$("#bt_order").hide(); /// 医嘱录入
		$("#bt_grpaddloc").hide(); /// 组内科室添加
		$("#bt_grpcencel").hide(); /// 组内科室清空
		$("#bt_addloc").hide();    /// 院内科室添加
		$("#bt_cencel").hide();    /// 院内科室清空
		PageEditFlag(0);	   /// 页面编辑
		isEditFlag = 1;	       /// 行编辑标志
	}
	/// 页面默认显示
	if (BTFlag == 5){
		$("#bt_can").hide();   /// 取消
		$("#bt_com").hide();   /// 完成
		$("#bt_ord").hide();   /// 医嘱录入
		$("#bt_patemr").hide();    /// 查看病历
		//$("#Opinion").hide();      /// 会诊意见
		$("#bt_openemr").hide();   /// 开启授权
		$("#bt_log").hide();   /// 会诊日志
		$("#bt_revcom").hide();/// 取消完成
		$("#bt_order").hide(); /// 医嘱录入
	}
	
	//$("#Opinion").show();

	/// 会诊子表ID为空时，不显示会诊日志按钮
	if (CstItmID == ""){
		$("#bt_log").hide();   /// 会诊日志
	}
}

/// 取科室亚专业指征
function GetMarIndDiv(MarID, LocID){
	
	$("#itemList").html("");
	var rowData = $('#dgCstDetList').datagrid('getRows');
	for (var i=0; i<rowData.length; i++){
		if (typeof rowData[i].MarID != "undefined"){
			InsMarIndDiv(rowData[i].MarID, rowData[i].LocID);  /// 加载会诊指征
		}
	}
	if (MarID != ""){
		InsMarIndDiv(MarID, LocID);  /// 加载会诊指征
	}
	/// 会诊指征
	if ($("#itemList").html() == ""){
		$("#MarIndDiv ").hide();
	}else{
		$("#MarIndDiv ").show();
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
	
	var lnk ="emr.interface.browse.category.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID']+"&Action="+'externalapp';
	window.open(lnk, 'newWin', 'height='+ (window.screen.availHeight-200) +', width='+ (window.screen.availWidth-200) +', top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// 历次会诊
function PatHisCst(){
	
	if (EpisodeID == ""){
		$.messager.alert("提示","请选择会诊记录后重试！","warning");
		return;
	}
	window.open("dhcmdt.consultpathis.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID, 'newWin', 'height='+ (window.screen.availHeight-200) +', width='+ (window.screen.availWidth-100) +', top=50, left=50, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
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

	if (Flag != 0){
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

/// mdt会诊打印
function Print(){
	
	if (CstID == ""){
		$.messager.alert("提示","请发送会诊申请后，再打印！","warning");
		return;
	}
	
	window.open("dhcmdt.printconsmdt.csp?CstID="+CstID);
	
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
	
	var lnk = "diagnosentry.v8.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm;
	//window.showModalDialog(lnk, "_blank", "dialogHeight: " + (top.screen.height - 100) + "px; dialogWidth: " + (top.screen.width - 100) + "px");
	window.open(lnk, 'newWin', 'height='+ (window.screen.availHeight-200) +', width='+ (window.screen.availWidth-200) +', top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// 弹出医嘱录入窗口
function OpenCsOrderWin(){
	
	if (EpisodeID == ""){
		$.messager.alert("提示","请选择会诊记录后重试！","warning");
		return;
	}
	var lnk = "dhcem.consultorder.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm;
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
			var Link = "dhcmdt.makeresources.csp?DisGrpID="+mdtDisGrp +"&EpisodeID="+ EpisodeID;
			mdtPopWin(1, Link); /// 弹出MDT会诊处理窗口
		});
	}else{
		var Link = "dhcmdt.makeresources.csp?DisGrpID="+mdtDisGrp +"&EpisodeID="+ EpisodeID;
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
	
	var Link = "dhcmdt.template.csp?DisGrpID="+mdtDisGrp;
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
	var mListData= "" +"^"+ mdtCode +"^"+ mdtPurpose +"^M^"+mdtDisGrp;
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
		var Link = "dhcmdt.makresloc.csp?DisGrpID="+mdtDisGrp;
		mdtPopWin(2, Link); /// 弹出MDT会诊处理窗口
	}
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
	}
}

/// 链接
function SetLocCellUrl(value, rowData, rowIndex){	
	var html = '<a href="#" onclick="delRow(\''+ rowIndex +'\',\''+ "LocGrpList" +'\')"><img src="../scripts/dhcnewpro/images/cancel.png" border=0/></a>';
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
			url: $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonPrvTp",
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
			url: $URL +"?ClassName=web.DHCMDTCom&MethodName=JsonLoc&HospID"+session['LOGON.HOSPID'],
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
				var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonGrpLoc&DisGrpID="+DisGrpID;
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
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocCareProv&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&DisGrpID="+ DisGrpID;
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
		{field:'LocID',title:'科室ID',width:100,align:'center',hidden:true,editor:texteditor},
		{field:'LocDesc',title:'科室',width:200,align:'center',editor:LocEditor},
		{field:'UserID',title:'医生ID',width:110,align:'center',hidden:true,editor:texteditor},
		{field:'UserName',title:'医生',width:120,align:'center',editor:DocEditor},
		{field:'TelPhone',title:'联系方式',width:100,align:'center',editor:texteditor},
		{field:'PrvTpID',title:'职称ID',width:100,align:'center',hidden:true,editor:texteditor},
		{field:'PrvTp',title:'职称',width:160,align:'center',hidden:false,editor:PrvTpEditor},
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
			
			if (isEditFlag == 1) return;
			
			if ((editSelRow != -1)||(editSelRow == 0)) { 
                $("#dgCstDetList").datagrid('endEdit', editSelRow); 
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
	/// 就诊类型
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&CstID=&Type=I";
	new ListComponent('LocGrpList', columns, uniturl, option).Init();
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

	var Width = document.body.offsetWidth;
	//var Height = document.body.scrollHeight;
	var Height = window.screen.availHeight;
	$(".p-content").width(Width - 40);
	if (Height > 800){
		$(".p-content").height(Height - 242);
	}else{
		$(".p-content").height(Height - 282);
	}
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

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })