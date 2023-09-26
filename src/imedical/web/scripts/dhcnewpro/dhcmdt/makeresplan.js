//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-07-10
// 描述:	      mdt会诊安排
//===========================================================================================
var EpisodeID = "";     /// 病人就诊ID
var CstID = "";         /// 会诊ID
var DisGrpID = "";      /// 疑难病种ID
var mdtID = "";         /// 会诊申请ID
var mdtMakResID = "";   /// 预约资源ID
var editSelRow = -1;
var editGrpRow = -1;
var LType = "CONSULT";  /// 会诊科室代码
var isEditFlag = 0;     /// 页面是否可编辑
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
var del = String.fromCharCode(2);

/// 页面初始化函数
function initPageDefault(){
	
	/// 初始化页面参数
	InitPatEpisodeID();
	
	/// 初始化专家组列表
	InitbmDetList();
	
	InitLocGrpGrid();
	
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	
	DisGrpID = getParam("DisGrpID");    /// 疑难病种ID
	EpisodeID = getParam("EpisodeID");  /// 就诊ID
	mdtID = getParam("ID");             /// 会诊单据类型
	mdtMakResID = getParam("mdtMakResID");  /// 预约资源ID
	if (mdtID != ""){
		var Link = "dhcmdt.makeresources.csp?ID="+ mdtID +"&mdtMakResID="+mdtMakResID +"&DisGrpID="+ DisGrpID +"&EpisodeID="+ EpisodeID;
		$("#mdtFrame").attr("src",Link);
	}
}

// 添加科室
function AddLocWin(){
    
   if (TakGrpLocModel == 1){
	   	/// 插入空行
		if (isEditFlag == 1) return;
    	var rowObj={PrvTpID:'', PrvTp:'', LocID:'', LocDesc:'', UserID:'', UserName:'', TelPhone:''};
		$("#LocGrpList").datagrid('appendRow',rowObj);
   }else{
	   var Link = "dhcmdt.makresloc.csp?DisGrpID="+DisGrpID;
	   mdtPopWin1(2, Link); /// 弹出MDT会诊处理窗口
   }
}

/// 弹出MDT会诊处理窗口
function mdtPopWin1(WidthFlag, Link){
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		iconCls:'icon-paper',
		closed:"true"
	};
	$("#mdtFrames").attr("src",Link);
	if(WidthFlag == 2){
		new WindowUX('会诊专家组', 'mdtWin', 880, 420, option).Init();
	}
}

/// 清空
function Clear(FlagCode){
	
	if (FlagCode == "G"){
		/// 组内科室
		$("#LocGrpList").datagrid("reload",{"QueFlg":'','ID':''});
	}else{
		/// 院内科室
		$("#bmDetList").datagrid("reload",{"QueFlg":'','ID':''});
		
	}
}

/// 链接
function SetLocCellUrls(value, rowData, rowIndex){	
	var html = '<a href="javascript:void(0)" onclick="delRow(\''+ rowIndex +'\',\''+ "LocGrpList" +'\')"><img src="../scripts/dhcnewpro/images/cancel.png" border=0/></a>';    
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
	var columns=[[
		{field:'LocID',title:'科室ID',width:100,align:'center',hidden:true,editor:texteditor},
		{field:'LocDesc',title:'科室',width:200,align:'center',editor:LocEditor},
		{field:'UserID',title:'医生ID',width:110,align:'center',hidden:true,editor:texteditor},
		{field:'UserName',title:'医生',width:120,align:'center',editor:DocEditor},
		{field:'TelPhone',title:'联系方式',width:130,align:'center',hidden:true,editor:texteditor},
		{field:'PrvTpID',title:'职称ID',width:100,align:'center',hidden:true,editor:texteditor},
		{field:'PrvTp',title:'职称',width:160,align:'center',hidden:false,editor:PrvTpEditor},
		{field:'operation',title:"操作",width:70,align:'center',formatter:SetLocCellUrls}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		fitColumns:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		fit : true,
	    onDblClickRow: function (rowIndex, rowData) {
		  	
		  	if (isEditFlag == 1) return;
			
			if ((editSelRow != -1)||(editSelRow == 0)) { 
                $("#bmDetList").datagrid('endEdit', editSelRow); 
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
	
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+mdtID+"&Type=I";
	new ListComponent('LocGrpList', columns, uniturl, option).Init();
}

/// 页面DataGrid初始定义已选列表
function InitbmDetList(){
	
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
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'HosID'});
				$(ed.target).val(option.value);  //设置value
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'HosType'});
				$(ed.target).combobox('setValue', option.text);  //设置Desc
				
				///清空科室
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
				$(ed.target).combobox('setValue', "");
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				$(ed.target).val("");
				
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'UserID'});
				$(ed.target).val("");
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
				
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
				$(ed.target).val("");
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTp'});
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
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTp'});
				$(ed.target).combobox('setValue', option.text);
				
				///设置级联指针
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'UserID'});
				$(ed.target).val("");
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', "");
			},
			onChange:function(newValue, oldValue){
				if (newValue == ""){
					var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
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
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				$(ed.target).val(option.value);
                
                var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
				$(ed.target).val("");
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTp'});
				$(ed.target).combobox('setValue', "");
                
				///设置级联指针
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
			},
			onShowPanel:function(){
				
				//var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocList&LType="+LType+"&LocID="+LgLocID+"&HospID="+LgHospID;
				/// 组内
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'HosID'});
				var HosID = $(ed.target).val();
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
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
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'MarID'});
				$(ed.target).val(option.value);
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'MarDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				var LocID = $(ed.target).val();
				GetMarIndDiv(option.value, LocID); 	/// 取科室亚专业指征
			},
			onShowPanel:function(){
				
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				var LocID = $(ed.target).val();
				///设置级联指针
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'MarDesc'});
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonSubMar&LocID="+ LocID;
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
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'UserID'});
				$(ed.target).val(option.value);
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', option.text);
				
				$m({
					ClassName:"web.DHCMDTCom",
					MethodName:"GetPrvTpIDByCareProvID",
					CareProvID:option.value
				},function(txtData){
					var ctpcpCtInfo = txtData;
					var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTp'});
					$(ed.target).combobox('setValue', ctpcpCtInfo.split("^")[1]);
					var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
					$(ed.target).val(ctpcpCtInfo.split("^")[0]);
				});
			},
			onShowPanel:function(){
				///设置级联指针
				//var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocCareProv&ProvType=DOCTOR&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&LgUserID="+ LgUserID;
			    /// 组内
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'HosID'});
				var HosID = $(ed.target).val();
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				var LocID = $(ed.target).val();
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
				var PrvTpID = $(ed.target).val();
				///设置级联指针
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				//var GrpID = HosID="I"?DisGrpID:"";
				var GrpID="";
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocCareProv&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&DisGrpID="+ GrpID;
				$(ed.target).combobox('reload',unitUrl);
			
			},
			onChange:function(newValue, oldValue){
				if (newValue == ""){
					var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'UserID'});
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
		{field:'operation',title:"操作",width:70,align:'center',formatter:SetCellUrl}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		fitColumns:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		fit : true,
	    onDblClickRow: function (rowIndex, rowData) {
			
            if ((editSelRow != -1)||(editSelRow == 0)) { 
                $("#bmDetList").datagrid('endEdit', editSelRow); 
            }
            
            if ((editGrpRow != -1)||(editGrpRow == 0)) { 
                $("#LocGrpList").datagrid('endEdit', editGrpRow); 
            }
            
            $("#bmDetList").datagrid('beginEdit', rowIndex); 
			
            editSelRow = rowIndex;
        }
	};
	/// 就诊类型
	
	//var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&mdtID=&Type=O";
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+mdtID+"&Type=O";
	
	new ListComponent('bmDetList', columns, uniturl, option).Init();
}

/// 链接
function SetCellUrl(value, rowData, rowIndex){	
	var html = '<a href="javascript:void(0)" onclick="delRow(\''+ rowIndex +'\',\''+ "bmDetList" +'\')"><img src="../scripts/dhcnewpro/images/cancel.png" border=0/></a>';
	return html;
}

 /// 删除行
function delRow(rowIndex, id){
	
	if (isEditFlag == 1) return;
	/// 行对象
    var rowObj={PrvTpID:'', PrvTp:'', HosID:'', HosType:'', LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:''};
	
	/// 当前行数大于4,则删除，否则清空
	if(rowIndex=="-1"){
		$.messager.alert("提示:","请先选择行！");
		return;
	}
	
	var rows = $('#'+ id).datagrid('getRows');
	if(rows.length>2){
		 $('#'+ id).datagrid('deleteRow',rowIndex);
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
	 $("#bmDetList").datagrid('appendRow',rowObj);
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

/// 预约时间
function TakPreTime(){

	//if (!frames[0].GetPatMakRes()) return;
	if (!document.getElementById('mdtFrame').contentWindow.GetPatMakRes()) return;
	InsMdtCsMakRes(); /// 修改会诊资源
}

/// 关闭弹出窗口
function TakClsWin(){

	window.parent.$("#mdtWin").window("close");        /// 关闭弹出窗口
	window.parent.$("#bmDetList").datagrid("reload");
}

/// 修改会诊资源
function InsMdtCsMakRes(){

    /// 全院科室列表 结束编辑
    if ((editSelRow != -1)||(editSelRow == 0)) { 
        $("#bmDetList").datagrid('endEdit', editSelRow); 
    }
    
    /// 组内科室列表 结束编辑
    if ((editGrpRow != -1)||(editGrpRow == 0)) { 
        $("#LocGrpList").datagrid('endEdit', editGrpRow); 
    }

	var mdtPreData = $("#mdtPreDate").val();       /// 预约日期
	var mdtPreTime = $("#mdtPreTime").val();       /// 预约时间
	var mdtMakResID = $("#mdtMakResID").val();     /// 出诊表ID
	   
	/// 会诊科室
	var ConsDetArr=[];
	var TmpCarePrv = ""; /// 专家
	var CarePrvArr = [];
	var LocArr = [];
	/// 组内
	var rowData = $('#LocGrpList').datagrid('getRows');
	for (var m = 0; m < rowData.length; m++){
		var item = rowData[m];
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^"+ item.MarID;
		    ConsDetArr.push(TmpData);
		    if ($.inArray(item.LocID +"^"+ item.UserID,LocArr) == -1){
				LocArr.push(item.LocID);
			}
			/// 人员重复检查
			if ($.inArray(item.UserID, CarePrvArr) != -1){
				TmpCarePrv = item.UserName;
			}
			CarePrvArr.push(item.UserID);
		}
	}
	
	/// 院内
    if ((editSelRow != -1)||(editSelRow == 0)) { 
        $("#bmDetList").datagrid('endEdit', editSelRow); 
    }
	var rowData = $('#bmDetList').datagrid('getRows');
	for (var n = 0; n < rowData.length; n++){
		var item = rowData[n];
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^"+ item.MarID;
		    ConsDetArr.push(TmpData);
		    if ($.inArray(item.LocID +"^"+ item.UserID,LocArr) == -1){
				LocArr.push(item.LocID);
			}
			/// 人员重复检查
			if ($.inArray(item.UserID, CarePrvArr) != -1){
				TmpCarePrv = item.UserName;
			}
			CarePrvArr.push(item.UserID);
		}
	}
	
	if ((memControlFlag == 1)&(LocArr.length < 3)){
		$.messager.alert("提示:","会诊专家组成员不允许少于3人！","warning");
		return;	
	}
	
	if (TmpCarePrv != ""){
		$.messager.alert("提示:","会诊专家："+ TmpCarePrv +"，重复添加！","warning");
		return;	
	}
	/// 科室
	var makLocParams = ConsDetArr.join("@");
	if (makLocParams == ""){
		$.messager.alert("提示:","会诊科室不能为空！","warning");
		return;	
	}
	
	/// 资源信息
	var makResParams = mdtPreData +"^"+ mdtPreTime +"^"+ mdtMakResID;

	/// 保存
	runClassMethod("web.DHCMDTConsult","InsMakRes",{"CstID":mdtID, "LgParams":LgParam, "makResParams":makResParams, "makLocParams":makLocParams},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单非待安排状态，不允许进行安排操作！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","保存失败，失败原因:"+jsonString,"warning");
		}else{
			//$.messager.alert("提示:","保存成功！","warning");
			//$('#bmDetList').datagrid('reload');
			TakClsWin(); /// 关闭弹出窗口
		}
	},'',false)
}



/// JQuery 初始化页面
$(function(){ initPageDefault(); })