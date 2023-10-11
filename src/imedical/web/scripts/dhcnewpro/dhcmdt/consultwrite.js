//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2018-01-22
// 描述:	   会诊申请单
//===========================================================================================
var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var mradm = "";			/// 就诊诊断ID
var CstID = "";         /// 会诊申请ID
var CstItmID = "";      /// 会诊申请字表ID
var editSelRow = -1;
var isEditFlag = 0;     /// 页面是否可编辑
var LType = "CONSULT";  /// 会诊科室代码
var CsRType = "DOC";    /// 会诊类型  医生
var CsRType2="DOC^PHA"; /// 对医生会诊申请兼容药师处理
var CstOutFlag = "";    /// 院际会诊标志
var CstMorFlag ="";     /// 多科会诊标志
var TakOrdMsg = "";     /// 验证病人是否允许开医嘱
var TakCstMsg = "";     /// 验证医生是否有开会诊权限
var isOpiEditFlag = 0;  /// 会诊结论是可编辑
var isEvaShowFlag = 0;  /// 会诊评价是否显示
var IsPerAccFlag = 0;   /// 是否允许接收申请单
var CsStatCode = "";    /// 申请单当前状态
var seeCstType="";      /// 模式：1(查看模式),2(申请模式),3(处理模式)
var PatType = "";       /// 就诊类型
var IsAnti="N";
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
var del = String.fromCharCode(2);
/// 页面初始化函数
function initPageDefault(){
	InitPatEpisodeID();       /// 初始化加载病人就诊ID
	InitCsPropDiv();          /// 初始化会诊性质
	InitPageComponent(); 	  /// 初始化界面控件内容
	InitPageDataGrid();		  /// 初始化页面datagrid
	if (EpisodeID == ""){
		HidePageButton(4);	  /// 初始化界面按钮
	}else{
		HidePageButton(5);	  /// 初始化界面按钮
	}
	
	HideOrShowByModel();      /// 根据申请,处理,查看的模式不同初始化界面
}

function InitContentTop(){

	if(seeCstType != 1){
		var OpBtnsHeight=$("#OpBtns").height()+7;
		$("#p-content").css({"top":OpBtnsHeight});
	}else{
		$("#p-content").css({"top":10});
		isEditFlag = 1; /// 页面是否可编辑
	}
	return;
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){

	PatientID = getParam("PatientID");   /// 病人ID
	EpisodeID = getParam("EpisodeID");   /// 就诊ID
	mradm = getParam("mradm");           /// 就诊诊断ID
	CstID = getParam("CstID");           /// 会诊ID
	CstItmID = getParam("CstItmID");     /// 会诊子表ID
	seeCstType = getParam("seeCstType"); /// 会诊查看模式
	isEvaShowFlag = getParam("EvaFlag"); /// 会诊评价是否显示
	if (EpisodeID == ""){
		$("#openemr").hide();
	}
	if (EpisodeID != ""){
		InitPatNotTakOrdMsg(1);    /// 验证病人是否允许开医嘱
		//InitPatNotTakCst(1);     /// 验证病人是否有会诊类型
	}
}

/// 初始化界面控件内容
function InitPageComponent(){
	
	/// 默认平会诊
	//$HUI.radio("input[name='CstEmFlag'][value='N']").setValue(true);
	$HUI.radio("input[name='CstEmFlag'][label='"+$g("平会诊")+"']").setValue(true);
	
	///设置级联指针
	var unitUrl = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonCstType&HospID=" + LgHospID +"&LgUserID="+LgUserID +"&CsRType="+CsRType;
	
	/// 会诊类型
	var option = {
		url:unitUrl,
		panelHeight:"auto",
		blurValidValue:true,
        onSelect:function(option){
	        if (option.text == "院际会诊"){
		    	$HUI.combobox("#CstLoc").enable();
		    	$HUI.combobox("#CstHosp").enable();
		    	isEditFlag = 1;		/// 行编辑标志
		    }else{
			    $HUI.combobox("#CstHosp").setValue(""); /// 清空医院
		    	$HUI.combobox("#CstLoc").setValue("");  /// 清空科室
		    	$HUI.combobox("#CstHosp").disable();
		    	$HUI.combobox("#CstLoc").disable();
		    	$("#CstUnit").val("").attr("disabled", true);
		    	isEditFlag = 0;		/// 行编辑标志
			}
			
			$("#dgCstDetList").datagrid("load",{"CstID":""});      /// 会诊科室
			
			GetMarIndDiv("","");  /// 清空亚专业指征
	    },
	    onShowPanel: function () { //数据加载完毕事件
			$("#CstType").combobox('reload',unitUrl);
        },
        onLoadSuccess:function(data){
	        var data = $HUI.combobox("#CstType").getData();
	        var CstType = $HUI.combobox("#CstType").getValue();
	        if(data.length>0){
		        if(CstType==""){
			    	$HUI.combobox("#CstType").select(data[0].value);
		        }
		    }
	    }

	};
	var url = ""; //$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonCstType&HospID=" + LgHospID +"&LgUserID="+LgUserID;
	new ListCombobox("CstType",url,'',option).init();
	
	/// 医院
	var option = {
		panelHeight:"auto",
		blurValidValue:true,
        onSelect:function(option){
	        if (option.text.indexOf($g("其他")) != "-1"){
		    	$("#CstUnit").attr("disabled", false);
		    }else{
		    	$("#CstUnit").val("").attr("disabled", true); 
			}
			
			$HUI.combobox("#CstLoc").setValue("");
			///设置级联指针
			var unitUrl = $URL+"?ClassName=web.DHCEMConsHosLoc&MethodName=JsonDicLoc&HospID="+option.value;
			$("#CstLoc").combobox('reload',unitUrl);
	    },
		onShowPanel:function(){
			
			///设置级联指针
			var unitUrl = $URL+"?ClassName=web.DHCEMConsDicItem&MethodName=jsonConsItem&mCode=HOS&HospID="+LgHospID;
			$("#CstHosp").combobox('reload',unitUrl);
		}
	};
	var url = ""; //$URL+"?ClassName=web.DHCEMConsDicItem&MethodName=jsonConsItem&mCode=HOS&HospID="+LgHospID;
	new ListCombobox("CstHosp",url,'',option).init();
	$HUI.combobox("#CstHosp").disable();  /// 医院不可用
	
	/// 科室
	var option = {
		panelHeight:"auto",
		blurValidValue:true,
        onSelect:function(option){
	        
	    }
	};
	var url = ""; //$URL+"?ClassName=web.DHCEMConsHosLoc&MethodName=JsonDicLoc&HospID="+LgHospID;
	new ListCombobox("CstLoc",url,'',option).init();
	$HUI.combobox("#CstLoc").disable();  /// 科室不可用
	
	/// 会诊日期
	$HUI.datebox("#CstDate").setValue(GetCurSystemDate(0));
	
	/// 请会诊评价
	var option = {
		panelHeight:"auto",
		blurValidValue:true,
        onSelect:function(option){
	        if (option.text.indexOf($g("其他")) != "-1"){
		    	$("#CstEvaRDesc").attr("disabled", false);
		    }else{
		    	$("#CstEvaRDesc").val("").attr("disabled", true); 
			}
	    },
		onShowPanel:function(){
			
			///设置级联指针
			var unitUrl = $URL+"?ClassName=web.DHCEMConsDicItem&MethodName=jsonConsItem&mCode=EVA&HospID="+LgHospID;
			$("#CstEvaR").combobox('reload',unitUrl);
		}
	};
	var url = "";
	new ListCombobox("CstEvaR",url,'',option).init();
	
	/// 会诊评价
	var option = {
		panelHeight:"auto",
		blurValidValue:true,
        onSelect:function(option){
	        if (option.text.indexOf($g("其他")) != "-1"){
		    	$("#CstEvaDesc").attr("disabled", false);
		    }else{
		    	$("#CstEvaDesc").val("").attr("disabled", true); 
			}
	    },
		onShowPanel:function(){
			
			///设置级联指针
			var unitUrl = $URL+"?ClassName=web.DHCEMConsDicItem&MethodName=jsonConsItem&mCode=EVA&HospID="+LgHospID;
			$("#CstEva").combobox('reload',unitUrl);
		}
	};
	var url = "";
	new ListCombobox("CstEva",url,'',option).init();
	
	/// 院区
	var option = {
		panelHeight:"auto",
        onSelect:function(option){
	    },
		onShowPanel:function(){
			
			///设置级联指针
			//var unitUrl = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonHosp";
			//$("#HospArea").combobox('reload',unitUrl);
		}
	};
	var url = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonHosp";
	new ListCombobox("HospArea",url,'',option).init();
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
			$('#CstAddr').val(jsonObject.LocAddr);  /// 科室地址
			$HUI.combobox("#HospArea").setValue(jsonObject.HospID)
			$HUI.combobox("#HospArea").setText(jsonObject.HospDesc)
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
		
	// 职称编辑格
	var PrvTpEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonPrvTp&Type="+CsRType2,
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
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
					$(ed.target).combobox('setValue', "");
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserID'});
					$(ed.target).val("");
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'TelPhone'});
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
			//url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+LgHospID,
			url: '',
			blurValidValue:true,
			onSelect:function(option) {
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				$(ed.target).val(option.value);
				
//				///设置级联指针
//				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'MarDesc'});
//				var unitUrl=$URL+"?ClassName=web.DHCEMConsLocItem&MethodName=JsonSubMar&LocID="+ option.value;
//				$(ed.target).combobox('reload',unitUrl);
				
//				///设置级联指针
//				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
//				var unitUrl=$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocCareProv&LocID="+ option.value;
//				$(ed.target).combobox('reload',unitUrl);

				///设置级联指针
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'MarID'});
				$(ed.target).val("");
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'MarDesc'});
				$(ed.target).combobox('setValue', "");
				
				/// 联系方式
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'TelPhone'});
				$(ed.target).val(GetLocTelPhone(option.value));
			},
			onShowPanel:function(){
				
				var HospID = $HUI.combobox("#HospArea").getValue(); /// 院区
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
				var unitUrl = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocList&LType="+LType+"&LocID="+LgLocID+"&HospID="+HospID;
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
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				var LocID = $(ed.target).val();
				GetMarIndDiv(option.value, LocID); 	/// 取科室亚专业指征
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
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'TelPhone'});
					$(ed.target).val("");
				}
			}
		}
	}
	
	///  定义columns
	var columns=[[
		{field:'itmID',title:'itmID',width:100,editor:texteditor,hidden:true},
		{field:'PrvTpID',title:'职称ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'PrvTp',title:'职称',width:160,editor:PrvTpEditor,align:'center'},
		{field:'LocID',title:'科室ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'LocDesc',title:'科室',width:200,editor:LocEditor,align:'center'},
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
		fitColumns:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		fit : false,
	    onDblClickRow: function (rowIndex, rowData) {
			
			if ((isEditFlag == 1)||((rowData.itmID != "")&&(CsStatCode!=""))) return;
			
			var CstType = $HUI.combobox("#CstType").getText(); 	          /// 会诊类型
			if (((CstType.indexOf($g("单科")) != "-1")&(rowIndex != 0))||(CstType == ""))return;
			
            if ((editSelRow != -1)||(editSelRow == 0)) { 
                $("#dgCstDetList").datagrid('endEdit', editSelRow); 
            }
            $("#dgCstDetList").datagrid('beginEdit', rowIndex); 
            
            /// 联系方式
			var ed=$("#dgCstDetList").datagrid('getEditor',{index:rowIndex,field:'TelPhone'});
			$(ed.target).attr("disabled", true);
			
//			/// 医生   仅有金卡会诊才可指定医生
//			var ed=$("#dgCstDetList").datagrid('getEditor',{index:rowIndex,field:'UserName'});
//			if (CstType.indexOf("金卡") != "-1"){
//				$HUI.combobox(ed.target).enable();
//			}else{
//				$HUI.combobox(ed.target).setValue("");
//				$HUI.combobox(ed.target).disable();
//			}
				
            editSelRow = rowIndex;
        },
	    onLoadSuccess: function (data) { //数据加载完毕事件
            $("a[name='AddRow']").not("#"+(data.rows.length - 1)).hide();
             /// 是否启用会诊亚专业
            if (MarFlag != 1){
				$("#dgCstDetList").datagrid('hideColumn','MarDesc');
            }
        }
	};
	/// 就诊类型
	var uniturl = $URL+"?ClassName=web.DHCEMConsultQuery&MethodName=JsonQryConsult&CstID="+"";
	new ListComponent('dgCstDetList', columns, uniturl, option).Init();
}

/// 链接
function SetCellUrl(value, rowData, rowIndex){
	var itmID=rowData.itmID;
	var html = '<a href="#" onclick="delRow(\''+ itmID +'\',\''+ rowIndex +'\')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png" border=0/></a>';
	    html += '<a href="#" onclick="insRow()"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/add.png" border=0/></a>';
	return html;
}

/// 删除行
function delRow(itmID, rowIndex){
	
	if (isEditFlag == 1) return;
	
	/// 当前行数大于4,则删除，否则清空
	if(rowIndex=="-1"){
		$.messager.alert("提示:","请先选择行！");
		return;
	}
	
	if (itmID.indexOf("||") != "-1"){
		$.messager.confirm("删除", "您确定要删除此条会诊科室吗？", function (r) {
			if (r) {
				if (delCsItem(itmID)){
					$("#dgCstDetList").datagrid("reload");  /// 刷新
					
					if (window.parent.QryConsList != undefined){  ///刷新左侧列表
						window.parent.QryConsList("R");
					}
				}
			}
		});
	}else{
		delRowObj(rowIndex);  /// 删除行
	}
	
	// 删除后,重新排序
	//$('#dgCstDetList').datagrid('sort', {sortName: 'No',sortOrder: 'desc'});
	
	GetMarIndDiv("", ""); 	/// 取科室亚专业指征
}

/// 删除行
function delRowObj(rowIndex){
	
	/// 行对象
    var rowObj={PrvTpID:'', PrvTp:'', LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:'', itmID:''};

	var rows = $('#dgCstDetList').datagrid('getRows');
	if(rows.length>2){
		 $('#dgCstDetList').datagrid('deleteRow',rowIndex);
	}else{
		$('#dgCstDetList').datagrid('updateRow',{index:rowIndex, row:rowObj});
	}
}

/// 插入空行
function insRow(){
	
	if (isEditFlag == 1) return;
	var CstType = $HUI.combobox("#CstType").getText(); 	          /// 会诊类型
	
	if(!isCanAddLoc()) return;
			
    var rowObj={PrvTpID:'', PrvTp:'', LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:'', itmID:''};
	$("#dgCstDetList").datagrid('appendRow',rowObj);
}

function isCanAddLoc(){
	var ret=true;
	var CstType = $HUI.combobox("#CstType").getText(); 	 
	if ((CstType.indexOf($g("单科")) != "-1")||(CstType == "")) ret=false;
	if ((CstType.indexOf("院际") != "-1")||(CstType == "")) ret=false;	
	return ret;
}

/// 发送病理申请
function SaveCstNo(){
    
    if ((editSelRow != -1)||(editSelRow == 0)) { 
        $("#dgCstDetList").datagrid('endEdit', editSelRow); 
    }
    
    /// 验证病人是否允许开医嘱
	TakOrdMsg = GetPatNotTakOrdMsg();
	if (TakOrdMsg != ""){
		$.messager.alert("提示:",TakOrdMsg,"warning");
		return;	
	}
	
	/// 验证医生是否有开会诊权限
	if (TakCstMsg != ""){
		$.messager.alert("提示:",TakCstMsg,"warning");
		return;	
	}
	
    var CstType = $HUI.combobox("#CstType").getValue();
	if (CstType == "") {
		$.messager.alert("提示:","会诊类型不能为空！","warning");
		return;
	}
	
	var CstTrePro = $("#ConsTrePro").val();     /// 简要病历
	if (CstTrePro.replace(/\s/g,'') == ""){
		$.messager.alert("提示:","病情摘要不能为空！","warning");
		return;
	}
	CstTrePro = $_TrsSymbolToTxt(CstTrePro);        /// 处理特殊符号
	
	var CstPurpose = $("#ConsPurpose").val();  	/// 会诊目的
	if (CstPurpose.replace(/\s/g,'') == ""){
		$.messager.alert("提示:","会诊理由及要求不能为空！","warning");
		return;
	}
	CstPurpose = $_TrsSymbolToTxt(CstPurpose);      /// 处理特殊符号
	
	var CsRUserID = session['LOGON.USERID'];  		/// 申请科室
	var CsRLocID = session['LOGON.CTLOCID'];  		/// 申请人
	
	var CstEmFlag = $("input[name='CstEmFlag']:checked").val();   /// 加急标识
	if (typeof CstEmFlag == "undefined"){
		CstEmFlag = "N";
	}
	var CsPropID = $("input[name='CstEmFlag']:checked").attr("id"); /// 会诊性质
	if (typeof CsPropID == "undefined"){
		$.messager.alert("提示:","保存会诊申请前，请先选择会诊性质！","warning");
		return;
	}
	var CstTypeID = $HUI.combobox("#CstType").getValue(); 	      /// 会诊类型
	var CstType = $HUI.combobox("#CstType").getText(); 	          /// 会诊类型
	var CstHospID = $HUI.combobox("#CstHosp").getValue(); 	      /// 外院
	var CstUnit = $HUI.combobox("#CstHosp").getText(); 	          /// 外院名称
	var CstDate = $HUI.datebox("#CstDate").getValue();     		  /// 会诊日期
	var CstTime = $HUI.timespinner("#CstTime").getValue(); 		  /// 会诊时间
	
	var CstOutFlag = "N";                /// 是否外院
	if ($("#CstUnit").val() != ""){
		CstUnit = $("#CstUnit").val();   /// 外院名称
	}
	if (CstUnit != ""){ CstOutFlag = "Y"; }
	
	if ((CstType.indexOf("院际") != "-1")&(CstOutFlag == "N")){
		$.messager.alert("提示:","未选择院际会诊医院！","warning");
		return;	
	}
	//var CstLoc = $("#CstLoc").val();     /// 外院科室
	var CstLoc = $HUI.combobox("#CstLoc").getText(); 	          /// 外院科室
	var CstUser = $("#CstUser").val();   /// 联系人
	var CstTele = $("#CstTele").val();   /// 联系电话
	if (!$("#CstTele").validatebox('isValid')){
		$.messager.alert("提示:","联系电话验证失败，请重新录入！","warning");
		return;
	}
	var CstNote = "";  				     /// 备注
	var CstAddr = $("#CstAddr").val();   /// 会诊地点
	var MoreFlag = CstType.indexOf($g("多科")) != "-1"?"Y":"N";  /// 是否多科
	
//	var mListData = EpisodeID +"^"+ CsRUserID +"^"+ CsRLocID +"^"+ CstTrePro +"^"+ CstPurpose +"^"+ CstTypeID +"^"+ CstAddr +"^"+ CsRType;
//		mListData += "^"+ CstDate +"^"+ CstTime +"^"+ CstEmFlag +"^"+ CstOutFlag +"^"+ CstUnit +"^"+ CstLoc +"^"+ CstNote +"^"+ CstUser +"^"+ CstTele +"^"+ "" +"^"+ MoreFlag;

	/// 会诊科室
	var ConsDetArr=[],HasRepetDoc=false,DocList="^";
	var rowData = $('#dgCstDetList').datagrid('getRows');
	$.each(rowData, function(index, item){
		if(trim(item.LocDesc) != ""){
			
			if((DocList.indexOf("^"+item.UserID+"^")!=-1)&&(trim(item.UserID) != "")){
				HasRepetDoc=true;
			}
			DocList=DocList+item.UserID+"^";
			
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^"+ item.MarID  ;
		    ConsDetArr.push(TmpData);
		}
	})
	
	if(HasRepetDoc){
		$.messager.alert("提示:","存在同一人员多条记录，请确认！","warning");
		return;
	}

	if ((ConsDetArr.length == 1)&(CstType.indexOf("多科") != "-1")){
		$.messager.alert("提示:","会诊类型为多科会诊，至少选择两个及两个以上科室！","warning");
		return;	
	}
	if ((ConsDetArr.length >= 2)&(CstType.indexOf("单科") != "-1")){
		$.messager.alert("提示:","会诊类型为单科会诊，不能选择多个科室！","warning");
		return;	
	}
	if (ConsDetArr.length >= 2){ MoreFlag = "Y";}  /// 科室数量大于2,默认为多科
	
	var ConsDetList = ConsDetArr.join("@");
	if ((ConsDetList == "")&(CstOutFlag == "N")){
		$.messager.alert("提示:","会诊科室不能为空！","warning");
		return;	
	}

	/// 亚专业指征
	var MarIndArr = [];
	$('input[name="MarInd"]:checked').each(function(){
		MarIndArr.push(this.value);
	})
	var MarIndList = MarIndArr.join("@");
	
	var mListData = EpisodeID +"^"+ CsRUserID +"^"+ CsRLocID +"^"+ CstTrePro +"^"+ CstPurpose +"^"+ CstTypeID +"^"+ CstAddr +"^"+ CsRType;
		mListData += "^"+ CstDate +"^"+ CstTime +"^"+ CstEmFlag +"^"+ CstOutFlag +"^"+ CstUnit +"^"+ CstLoc +"^"+ CstNote +"^"+ CstUser +"^"+ CstTele +"^"+ "" +"^"+ MoreFlag +"^"+ CsPropID;

	///             主信息  +"&"+  会诊科室  +"&"+  亚专业指征
	var mListData = mListData +del+ ConsDetList +del+ MarIndList;

	/// 保存
	runClassMethod("web.DHCEMConsult","Insert",{"CstID":CstID, "mListData":mListData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请保存失败，失败原因:"+jsonString,"warning");
		}else{
			CstID = jsonString;
			$.messager.alert("提示:","保存成功！","info");
			$(".tip").text("("+$g("已保存")+")");
			$("#dgCstDetList").datagrid("load",{"CstID":CstID});      /// 会诊科室
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
	
	if(CstItmID==""){
		CstID==""?"":CstItmID=CstID+"||1";	
	}

	runClassMethod("web.DHCEMConsultQuery","JsGetCstNoObj",{"ItmID":CstItmID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			InsCstNoObj(jsonObjArr);
		}
	},'json',false)
}

/// 设置会诊申请单内容
function InsCstNoObj(itemobj){

	$("#ConsTrePro").val($_TrsTxtToSymbol(itemobj.CstTrePro));  		/// 简要病历
	$("#ConsPurpose").val($_TrsTxtToSymbol(itemobj.CstPurpose));  	/// 会诊目的 
	$("#CstUser").val(itemobj.CstUser);   		    /// 联系人
	$("#CstTele").val(itemobj.CstPhone);   		    /// 联系电话
	$("#CstRLoc").val(itemobj.CstRLoc);   		    /// 申请科室
	$("#CstRDoc").val(itemobj.CstRUser);   		    /// 申请医师
	$("#CstAddr").val(itemobj.CstNPlace);           /// 会诊地点
	$HUI.combobox("#HospArea").setValue(itemobj.CsHospID);   /// 院区
	var CstOpinion = "";
	if (itemobj.CstOpinion != ""){
		CstOpinion = itemobj.CstOpinion.replace(new RegExp("<br>","g"),"\r\n")
	}
	
	CstMorFlag = itemobj.CstMorFlag; 		/// 多科会诊标志
	CsStatCode = itemobj.CstStatus;         /// 申请单当前状态
	var IsNeedHideType=((MulWriFlag==0)&&(CstMorFlag=="Y"))||(CstMorFlag!="Y")
	var IsNoComp=(CsStatCode=="发送")||(CsStatCode=="接收")||(CsStatCode=="取消接收")||(CsStatCode=="取消完成")||(CsStatCode.indexOf("审核")!=-1);
	if(IsNeedHideType&IsNoComp&(NoCompHideOpin!=1)){
		$("#ConsOpinion").val("");
	}else{
		$("#ConsOpinion").val($_TrsTxtToSymbol(CstOpinion));      /// 会诊意见
	}
	/// 加急
	if (itemobj.CsPropID != ""){
		$HUI.radio("input[name='CstEmFlag'][id='"+ itemobj.CsPropID +"']").setValue(true);
	}
	$HUI.combobox("#CstType").setValue(itemobj.CstTypeID);   /// 会诊类型
	$HUI.combobox("#CstType").setText(itemobj.CstType);      /// 会诊类型
	
	if(itemobj.CstUnit != ""){
		if (itemobj.isExiHosFlag == 1){
			$HUI.combobox("#CstHosp").setText(itemobj.CstUnit);    /// 外院
		}else{
			$HUI.combobox("#CstHosp").setText($g("其他医院"));         /// 外院
			$("#CstUnit").val(itemobj.CstUnit);                    /// 外院名称
		}
	}else{
		$HUI.combobox("#CstHosp").setText("");                 /// 外院
		$("#CstUnit").val(itemobj.CstUnit);                    /// 外院名称
	}
	if(itemobj.CstDocName != ""){
		$HUI.combobox("#CstLoc").setText(itemobj.CstDocName);  /// 外院科室
	}else{
		$HUI.combobox("#CstLoc").setText("");                  /// 外院科室
	}
	$HUI.datebox("#CstDate").setValue(itemobj.CstNDate);      /// 会诊日期
	$HUI.timespinner("#CstTime").setValue(itemobj.CstNTime);  /// 会诊时间
		
	$HUI.datebox("#ConsDate").setValue(itemobj.SysDate);      /// 系统日期
	$HUI.timespinner("#ConsTime").setValue(itemobj.SysTime);  /// 系统时间
	$HUI.datebox("#CstCompDate").setValue(itemobj.CmpDate);      /// 完成日期
	$HUI.timespinner("#CstCompTime").setValue(itemobj.CmpTime);  /// 完成时间
	
	
	$HUI.radio("input[name='AntiRadio']").setValue(false);
	if (itemobj.AgreeFlag != ""){
		$HUI.radio("input[name='AntiRadio'][value='"+ itemobj.AgreeFlag +"']").setValue(true);
	}
	IsAnti = itemobj.CstEcType=="DOCA"?"Y":"N";  /// 抗菌药会诊类型
	
	CsUserID = itemobj.CsUserID;            /// 会诊人员
	EpisodeID = itemobj.EpisodeID;			/// 就诊ID
	PatientID = itemobj.PatientID;			/// 病人ID
	CstOutFlag = itemobj.CstOutFlag; 		/// 外院会诊标志
	CstMorFlag = itemobj.CstMorFlag; 		/// 多科会诊标志
	isOpiEditFlag = itemobj.isOpiEditFlag;  /// 会诊结论是可编辑
	IsPerAccFlag = itemobj.IsPerAccFlag;    /// 是否允许接收申请单
	CsStatCode = itemobj.CstStatus;         /// 申请单当前状态
	PatType = itemobj.PatType;              /// 就诊类型
	if (CsStatCode == ""){
		$(".tip").text("("+$g("已保存")+")");
	}else{
		$(".tip").text("");
	}
	
	if (itemobj.CsEvaRFlag != ""){
		
		$("#CstEvaRDesc").val("");
		
		$HUI.radio("input[name='CstEvaRFlag'][value='"+ itemobj.CsEvaRFlag +"']").setValue(true);
		if (itemobj.CsEvaRID != ""){
			$HUI.combobox("#CstEvaR").setText(itemobj.CsEvaRDesc);   /// 请会诊评价
		}else{
			$HUI.combobox("#CstEvaR").setText($g("其他"));               /// 会诊评价
			$("#CstEvaRDesc").val($_TrsTxtToSymbol(itemobj.CsEvaRDesc));  /// 请会诊评价
		}
	}else{
		$HUI.radio("input[name='CstEvaRFlag']").setValue(false);
		$HUI.combobox("#CstEvaR").setValue("");  /// 会诊评价
		$("#CstEvaRDesc").val("");   		     /// 请会诊评价
	}
	
	if (itemobj.CsEvaFlag != ""){
		$HUI.radio("input[name='CstEvaFlag'][value='"+ itemobj.CsEvaFlag +"']").setValue(true);
		if (itemobj.CsEvaID != ""){
			$HUI.combobox("#CstEva").setText(itemobj.CsEvaDesc);  /// 会诊评价
		}else{
			$HUI.combobox("#CstEva").setText($g("其他"));             /// 会诊评价
			$("#CstEvaDesc").val($_TrsTxtToSymbol(itemobj.CsEvaDesc)); /// 会诊评价
		}
//		$HUI.radio("input[name='CstEvaFlag']").disable();
//		$("#CstEvaDesc").attr("disabled",true);    /// 评价补充内容
//		$HUI.combobox("#CstEva").disable();        /// 会诊评价
	}else{
		$HUI.radio("input[name='CstEvaFlag']").setValue(false);
		$HUI.combobox("#CstEva").setValue("");     /// 会诊评价
		$("#CstEvaDesc").val("");   		       /// 请会诊评价	
	}
}

/// 发送
function SendCstNo(){
		
	/// 验证病人是否允许开医嘱
	TakOrdMsg = GetPatNotTakOrdMsg();
	if (TakOrdMsg != ""){
		$.messager.alert("提示:",TakOrdMsg,"warning");
		return;	
	}
	/// 验证医生是否有开会诊权限
	if (TakCstMsg != ""){
		$.messager.alert("提示:",TakCstMsg,"warning");
		return;	
	}
	
	/// 诊断判断
	if (GetMRDiagnoseCount() == 0){
		$.messager.alert("提示:","病人没有诊断,请先录入！","warning",function(){DiagPopWin()});
		return;	
	}
	
	/// 医疗结算判断
	if (GetIsMidDischarged() == 1){
		$.messager.alert("提示:","此病人已做医疗结算,不允许医生再开医嘱！","warning");
		return;	
	}
	
	if (CstID == ""){
		$.messager.alert("提示:","请保存会诊申请后，再发送！","warning");
		return;
	}
	
	///验证CA签名
	if (!isTakeDigSign()) return;
	
	runClassMethod("web.DHCEMConsult","SendCstNo",{"CstID": CstID, "LgParam":LgParam},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单已发送，不能再次发送！","warning");
			return;
		}
		if (jsonString == -12){
			$.messager.alert("提示:","会诊配置申请需要插入费用医嘱但费用医嘱未配置,或者医嘱插入失败！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请发送失败，失败原因:"+jsonString,"warning");
		}else{
			CstID = jsonString;
			isShowPageButton(CstID);     /// 动态设置页面显示的按钮内容
			$.messager.alert("提示:","发送成功！","info",function(){
				
				GetCstNoObj();
				
				///发送成功后如果配置了需要自动授权电子病历查看
				if(DefOpenAcc==1){
					InsEmrAutMasAll(1);
				}
				///发送成功后如果配置了需要自动授权医嘱 hxy 2021-01-18
				if(DefOpenAccOrd==1){
					InsEmrAutMasAll(2);
				}
			});
			ConsInsDigitalSign(CstID,"R","A");
			if (window.parent.reLoadMainPanel != undefined){
				if(CstItmID!=""){ //hxy 2021-01-13 st 处理界面右侧状态不能对应变化
					window.parent.reLoadMainPanel(CstItmID);
				}else{
				window.parent.reLoadMainPanel(CstID);
				} //ed
			}
			$(".tip").text("");
		}
	},'',false)
}

function InsEmrAutMasAll(Flag){
	var Hour=Number(DefOpenAccHour); //hxy 2021-01-15 st
	if((Hour==0)||(Hour==NaN)){
		Hour=72;
	} //ed
	var params = EpisodeID+"^"+CstID+"^"+LgUserID+"^"+Hour+"^"+Flag;
	var FlagDesc="病历";
	if(Flag==2)FlagDesc="医嘱";
	runClassMethod("web.DHCEMConsult","InsEmrAutMasAll",{"Params":params},function(jsonString){
		if (jsonString == 0){
			$.messager.alert("提示:","自动开启"+FlagDesc+"授权"+Hour+"小时查看权限！","warning");
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


///发送和取消CA签名调用
function ConsInsDigitalSign(CstID,ConsType,Type){
	if(CAInit!=1) return;
	runClassMethod("web.DHCEMConsultQuery","GetConsOrds",{"CstID":CstID, "ConsType":ConsType},function(ordItms){
		if(ordItms!=""){
			InsDigitalSign(ordItms,LgUserID,Type);	
		}
	},'text',false)
}

function RemoveCstNo(){
	if (CstID == ""){
		$.messager.alert("提示:","请先选择会诊申请，再进行此操作！","warning");
		return;
	}
	
	$.messager.confirm('确认对话框','您确定要删除当前会诊申请吗？', function(r){
		if (r){
			runClassMethod("web.DHCEMConsult","RemoveCstNo",{"CstID":CstID},function(jsonObject){

				if (jsonObject.ErrCode == -1){
					$.messager.alert("提示:","申请单当前状态，不允许进行取消操作！","warning");
					return;
				}
				if (jsonObject.ErrCode < 0){
					$.messager.alert("提示:","会诊申请删除失败，失败原因:"+jsonObject.ErrMsg,"warning");
				}else{
					$.messager.alert("提示:","删除成功！","info",function(){
						window.location.reload();
					});
					if(window.parent.reLoadMainPanel){
						window.parent.reLoadMainPanel("");	
					}
				}
			},'json',false)
		}
	});
}

/// 取消
function CanCstNo(){
	
	if (CstID == ""){
		$.messager.alert("提示:","请先选择会诊申请，再进行此操作！","warning");
		return;
	}
	
	/// 验证病人是否允许开医嘱
	if (TakOrdMsg != ""){
		$.messager.alert("提示:",TakOrdMsg.replace("再开申请","取消"),"warning");
		return;	
	}
	
	///验证CA签名
	if (!isTakeDigSign()) return;
	
	$.messager.confirm('确认对话框','您确定要取消当前会诊申请吗？', function(r){
		if (r){
			runClassMethod("web.DHCEMConsult","InvCanCstNo",{"CstID":CstID, "UserID":session['LOGON.USERID']},function(jsonObject){

				if (jsonObject.ErrCode == -1){
					$.messager.alert("提示:","申请单当前状态，不允许进行取消操作！","warning");
					return;
				}
				if (jsonObject.ErrCode < 0){
					$.messager.alert("提示:","会诊申请取消失败，失败原因:"+jsonObject.ErrMsg,"warning");
				}else{
					$.messager.alert("提示:","取消成功！","info",function(){
						if(seeCstType==2){
							window.location.reload();	///会诊申请界面取消申请的时候刷新界面					
						}	
					});
					ConsInsDigitalSign(CstID,"R","S");
					//GetCstNoObj();  	          /// 加载会诊申请 //hxy 2020-03-02 st
					//isShowPageButton(CstID);      /// 动态设置页面显示的按钮内容
					//window.parent.reLoadMainPanel(CstItmID);  
					window.location.reload(); 
					window.parent.reLoadMainPanel(""); //ed
				}
			},'json',false)
		}
	});
	
}

/// 确认
function SureCstNo(){
	
	/// 多科会诊填写标识
	var ItmID = "";
	if ((MulWriFlag == 1)&(CstMorFlag == "Y")){ ItmID = ""; }
	else{ ItmID = CstItmID; }
	
	runClassMethod("web.DHCEMConsult","SureCstMas",{"CstID": CstID, "ItmID":ItmID, "UserID":session['LOGON.USERID']},function(jsonString){
		
		/*if (jsonString == -1){ //hxy 2020-05-08 st
			$.messager.alert("提示:","申请单当前状态，不允许进行确认操作！","warning");
			return;
		}*/
		if (jsonString.split("^")[0] == -1){
			$.messager.alert("提示:","当前状态不允许进行确认操作！","warning");
			return;
		}//ed
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请确认失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示:","确认成功！","info");
			GetCstNoObj();  	          /// 加载会诊申请
			isShowPageButton(CstID);      /// 动态设置页面显示的按钮内容
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)
}

/// 取消确认
function CanSureCstNo(){
	runClassMethod("web.DHCEMConsult","CanSureCstMas",{"CstID": CstID, "UserID":session['LOGON.USERID']},function(jsonString){
		if (jsonString == -1){
			$.messager.alert("提示:","当前状态不允许进行取消确认操作！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊取消确认失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示:","取消确认成功！","info");
			GetCstNoObj();  	          /// 加载会诊申请
			isShowPageButton(CstID);      /// 动态设置页面显示的按钮内容
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)
}

/// 接收
function AcceptCstNo2(Params){

	runClassMethod("web.DHCEMConsult","AcceptCstNo",{"ItmID": CstItmID, "UserID":session['LOGON.USERID'], "Params":Params},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单非待接收状态，不允许进行接收操作！","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("提示:","会诊时间不能早于申请时间！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请接收失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示:","接收成功！","info");
			GetCstNoObj();  	          /// 加载会诊申请
			isShowPageButton(CstID);      /// 动态设置页面显示的按钮内容
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// 接收
function AcceptCstNo(){
	
	/// 外院和多科申请人填写会诊结论
	/// var Fn = ((CstOutFlag == "Y")||(CstMorFlag == "Y"))?"AcceptCstMas":"AcceptCstNo";
	/// 多科会诊填写标识
	var ItmID = "";
	if ((MulWriFlag == 1)&(CstMorFlag == "Y")){ ItmID = ""; }
	else{ ItmID = CstItmID; }

	runClassMethod("web.DHCEMConsult","AcceptCstMas",{"CstID": CstID, "ItmID": ItmID, "LgParam":LgParam},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单非待接收状态，不允许进行接收操作！","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("提示:","会诊时间不能早于申请时间！","warning");
			return;
		}
		if (jsonString == -3){
			$.messager.alert("提示:","会诊已被驳回，不能接收！","warning");
			return;
		}
		if (jsonString == -300){
			$.messager.alert("提示:","院际会诊尚未审核,不允许进行接收操作!","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请接收失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示:","接收成功！","info");
			GetCstNoObj();  	          /// 加载会诊申请
			isShowPageButton(CstID);      /// 动态设置页面显示的按钮内容
			window.parent.UpdMainPanel(CstItmID,$g("接收"));
		}
	},'',false)	
}

/// 撤销接收
function RevAccCstNo(){
	
	/// 外院和多科申请人填写会诊结论
	/// var Fn = ((CstOutFlag == "Y")||(CstMorFlag == "Y"))?"AcceptCstMas":"AcceptCstNo";
	/// 多科会诊填写标识
	var ItmID = "";
	if ((MulWriFlag == 1)&(CstMorFlag == "Y")){ ItmID = ""; }
	else{ ItmID = CstItmID; }

	runClassMethod("web.DHCEMConsult","RevAccCstMas",{"CstID": CstID, "ItmID": ItmID, "UserID":session['LOGON.USERID']},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单非待接收状态，不允许进行取消接收操作！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请取消接收失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示:","取消成功！","info");
			GetCstNoObj();  	          /// 加载会诊申请
			isShowPageButton(CstID);      /// 动态设置页面显示的按钮内容
			window.parent.UpdMainPanel(CstItmID,$g("取消接收"));
		}
	},'',false)	
}

/// 接收
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
			$.messager.alert("提示:","申请单当前所在状态，不允许进行拒绝操作！","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("提示:","申请单已经审核，不允许进行拒绝操作！","warning");
			return;
		}
		if (jsonString == -3){
			$.messager.alert("提示:","多科会诊不允许拒绝！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请拒绝失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示:","拒绝成功！","info");
			GetCstNoObj();  	         /// 加载会诊申请
			isShowPageButton(CstID);     /// 动态设置页面显示的按钮内容
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// 到达
function AriCstNo(){
	
	runClassMethod("web.DHCEMConsult","AriCstNo",{"ItmID": CstItmID, "UserID":session['LOGON.USERID']},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单当前状态，不允许进行到达操作！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请到达失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示:","到达成功！","info");
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// 会诊意见
function SaveCstOpi(){
	
	if (CsUserID != session['LOGON.USERID']){
		$.messager.alert("提示:","您非当前会诊人员，不能进行此操作！","warning");
		return;
	}
	
	var ConsOpinion = $("#ConsOpinion").val();
	if (ConsOpinion.replace(/\s/g,'') == ""){
		$.messager.alert("提示:","请填写会诊结论！","warning");
		return;
	}
	ConsOpinion = $_TrsSymbolToTxt(ConsOpinion); /// 处理特殊符号
	
	runClassMethod("web.DHCEMConsult","SaveCstOpi",{"ItmID": CstItmID, "UserID":session['LOGON.USERID'], "CstOpinion":ConsOpinion},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单当前状态，不允许进行完成操作！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","保存失败！","warning");
		}else{
			$.messager.alert("提示:","保存成功！","info");
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// 预完成
function PreCompCstNo(){
	var ConsOpinion = $("#ConsOpinion").val();
	
	ConsOpinion = $_TrsSymbolToTxt(ConsOpinion); /// 处理特殊符号
	if (ConsOpinion==""){
		$.messager.alert("提示:","请填写会诊结论！","warning");
		return;
	}
	
	runClassMethod("web.DHCEMConsult","PreCompCstMas",{"CstID":CstID,"ItmID": CstItmID,"CstOpinion":ConsOpinion,"LgParam":LgParam},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单当前状态，不允许进行预完成(暂存会诊意见)操作！","warning");
			return;
		}
		
		if (jsonString == -300){
			$.messager.alert("提示:","院际会诊尚未审核,不允许进行预完成(暂存会诊意见)操作!","warning");
			return;
		}
		
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请预完成失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示:","预完成(暂存会诊意见)成功！","info");
      		GetCstNoObj();  	          /// 加载会诊申请
			isShowPageButton(CstID);      /// 动态设置页面显示的按钮内容
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// 完成
function CompCstNo(){
	var IsUserAcc= ConsUseStatusCode.indexOf("^30^");   ///是否启用了保存状态
	
	if ((IsUserAcc!=-1)&(GetIsOperFlag("30") != "1")&(GetIsOperFlag("51") != "1")){
		$.messager.alert("提示:","申请单当前状态，不允许进行完成操作！","warning");
		return;
	}
	if ((IsUserAcc==-1)&(GetIsOperFlag("20") != "1")&(GetIsOperFlag("21") != "1")&(GetIsOperFlag("51") != "1")){
		$.messager.alert("提示:","申请单当前状态，不允许进行完成操作！","warning");
		return;
	}
	
	var AntiOpinion = $("input[name='AntiRadio']:checked").val(); ///是否同意使用抗生素药物 
	
	if((IsAnti=="Y")&((AntiOpinion=="")||(AntiOpinion==undefined))){
		$.messager.alert("提示","抗生素会诊必须填写是否同意用药!","warning");
		return false;
	}
	
	var ConsOpinion = $("#ConsOpinion").val();
	
	ConsOpinion = $_TrsSymbolToTxt(ConsOpinion); /// 处理特殊符号
	if ((ConsOpinion == "")&&(IsAnti!="Y")){
		$.messager.alert("提示:","请填写会诊结论！","warning");
		return;
	}
	var CmpDate = $HUI.datebox("#CstCompDate").getValue();
	var CmpTime = $HUI.timespinner("#CstCompTime").getValue();
	
	/// 外院和多科申请人填写会诊结论
	/// var Fn = ((CstOutFlag == "Y")||(CstMorFlag == "Y"))?"CompCstMas":"CompCstNo";
	/// 多科会诊填写标识
	var ItmID = "";
	if ((MulWriFlag == 1)&(CstMorFlag == "Y")){ ItmID = ""; }
	else{ ItmID = CstItmID; }
	
	var ParObj={
		"CstID": CstID, 
		"ItmID": ItmID, 
		"LgParam":LgParam, 
		"CstOpinion":ConsOpinion,
		"AntiOpinion":AntiOpinion,
		"CmpDate":CmpDate,
		"CmpTime":CmpTime
	}
	
	///验证CA签名
	if (!isTakeDigSign()) return;
	
	runClassMethod("web.DHCEMConsult","CompCstMas",ParObj,function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单当前状态，不允许进行完成操作！","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("提示:","会诊时间不能早于申请时间！","warning");
			return;
		}
		if (jsonString == -13){
			$.messager.alert("提示:","会诊配置完成需要插入费用医嘱但费用医嘱未配置,或者医嘱插入失败！","warning");
			return;
		}
		if (jsonString == -300){
			$.messager.alert("提示:","院际会诊尚未审核,不允许进行完成操作!","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请完成失败，失败原因:"+jsonString,"warning");
			return;
		}else{
			$.messager.alert("提示:","完成成功！","info");
			ConsInsDigitalSign(CstID,"C","A");
      		GetCstNoObj();  	          /// 加载会诊申请
			isShowPageButton(CstID);      /// 动态设置页面显示的按钮内容
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
	
	///验证CA签名
	if (!isTakeDigSign()) return;
	
	runClassMethod("web.DHCEMConsult","RevCompCstMas",{"CstID": CstID, "ItmID": ItmID, "UserID":session['LOGON.USERID']},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单当前状态，不允许取消完成操作！","warning");
			return;
		}
		if (jsonString < 0){
			if(jsonString==-101){
				$.messager.alert("提示:","完成时间不能早于发送时间！","warning");
				return;	
			}
			if(jsonString==-102){
				$.messager.alert("提示:","完成时间大于当前时间！","warning");
				return;	
			}
			if(jsonString==-2){
				$.messager.alert("提示:","抗生素药品已经使用，不允许撤销！","warning");
				return;	
			}
			$.messager.alert("提示:","会诊申请取消完成失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示:","取消成功！","info");
			ConsInsDigitalSign(CstID,"C","S");
      		GetCstNoObj();  	            /// 加载会诊申请
			isShowPageButton(CstID);      /// 动态设置页面显示的按钮内容
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
		$.messager.alert("提示:","您非当前会诊人员，不能进行此操作！","warning");
		return;
	}
	var ConsOpinion = $("#ConsOpinion").val();
	if (ConsOpinion == ""){
		$.messager.alert("提示:","请填写会诊结论！","warning");
		return;
	}
	ConsOpinion = $_TrsSymbolToTxt(ConsOpinion); /// 处理特殊符号
	
	runClassMethod("web.DHCEMConsult","CompCstNo",{"ItmID": CstItmID, "LgParam":LgParam, "CstOpinion":ConsOpinion, "Params":Params},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单当前状态，不允许进行完成操作！","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("提示:","会诊时间不能早于申请时间！","warning");
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请完成失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示:","完成成功！","info");
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// 请会诊评价
function EvaRCstNo(){
	
	var IsUserSure= ConsUseStatusCode.indexOf("^60^");   ///是否启用了保存状态
	
	if ((IsUserSure!=-1)&(GetIsOperFlag("60") != "1")&(GetIsOperFlag("79") != "1")){ //hxy 2021-01-08 add 79
		$.messager.alert("提示:","申请单当前状态，不允许进行评价操作！","warning");
		return;
	}
	if ((IsUserSure==-1)&(GetIsOperFlag("50") != "1")&(GetIsOperFlag("55") != "1")&(GetIsOperFlag("79") != "1")){ //hxy 2021-01-08 add 79
		$.messager.alert("提示:","申请单当前状态，不允许进行评价操作！","warning");
		return;
	}
	var CstEvaRFlag = $("input[name='CstEvaRFlag']:checked").val();   /// 会诊评价满意度标识
	if (typeof CstEvaRFlag == "undefined"){
		$.messager.alert("提示:","请先选择评价满意度！","warning");
		return;
	}
	
	var CstEvaID = $HUI.combobox("#CstEvaR").getValue(); 	      /// 会诊评价
	var CstEvaDesc = $HUI.combobox("#CstEvaR").getText(); 	      /// 会诊评价
	if (CstEvaDesc == ""){
		$.messager.alert("提示:","请选择评价内容！","warning");
		return;
	}

	if (CstEvaDesc.indexOf($g("其他")) != "-1"){
		var CstEvaDesc = $("#CstEvaRDesc").val();
		if (CstEvaDesc.replace(/\s/g,'') == ""){
			$.messager.alert("提示:","请先填写评价补充内容！","warning");
			return;
		}	
	}
	CstEvaDesc = $_TrsSymbolToTxt(CstEvaDesc); /// 处理特殊符号
	
	var CsEvaParam = CstEvaRFlag +"^"+ CstEvaDesc;
	
	runClassMethod("web.DHCEMConsult","EvaRCstNo",{"CstID": CstID, "LgParam":LgParam, "CsEvaParam":CsEvaParam},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单当前状态，不允许进行评价操作！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请评价失败，失败原因:"+jsonString,"warning");
		}
		if (jsonString == 0){
			$.messager.alert("提示:","评价成功！","info");
			GetCstNoObj();  	          /// 加载会诊申请
			isShowPageButton(CstID);      /// 动态设置页面显示的按钮内容
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)		
}

/// 请会诊评价-取消评价
function CanEvaRCstNo(){
	if(GetIsOperFlag("70") != "1"){
		$.messager.alert("提示:","申请单当前状态，不允许进行取消评价操作！","warning");
		return;
	}
		
	runClassMethod("web.DHCEMConsult","CanEvaRCstNo",{"CstID": CstID, "LgParam":LgParam},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单当前状态，不允许进行取消评价操作！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请取消评价失败，失败原因:"+jsonString,"warning");
		}
		if (jsonString == 0){
			$.messager.alert("提示:","取消评价成功！","info");
			GetCstNoObj();  	          /// 加载会诊申请
			isShowPageButton(CstID);      /// 动态设置页面显示的按钮内容
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)		
}

/// 会诊评价
function EvaCstNo(){
	
	if (GetIsOperFlag("50") != "1"){
		$.messager.alert("提示:","申请单当前状态，不允许进行评价操作！","warning","warning");
		return;
	}
	var CstEvaFlag = $("input[name='CstEvaFlag']:checked").val();   /// 会诊评价满意度标识
	if (typeof CstEvaFlag == "undefined"){
		$.messager.alert("提示:","请先选择评价满意度！","warning");
		return;
	}
	
	var CstEvaID = $HUI.combobox("#CstEva").getValue(); 	      /// 会诊评价
	var CstEvaDesc = $HUI.combobox("#CstEva").getText(); 	      /// 会诊评价
	if (CstEvaDesc == ""){
		$.messager.alert("提示:","请选择评价内容！","warning");
		return;
	}
	
	if (CstEvaDesc.indexOf($g("其他")) != "-1"){
		CstEvaDesc = $("#CstEvaDesc").val();
		if (CstEvaDesc.replace(/\s/g,'') == ""){
			$.messager.alert("提示:","请先填写评价补充内容！","warning");
			return;
		}	
	}
	CstEvaDesc = $_TrsSymbolToTxt(CstEvaDesc); /// 处理特殊符号
	
	var CsEvaParam = CstEvaFlag +"^"+ CstEvaDesc;
	
	runClassMethod("web.DHCEMConsult","EvaCstNo",{"ItmID": CstItmID, "UserID":LgUserID, "CsEvaParam":CsEvaParam},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单当前状态，不允许进行评价操作！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请评价失败，失败原因:"+jsonString,"warning");
		}
		if (jsonString == 0){
			$.messager.alert("提示:","评价成功！","info");
      		GetCstNoObj();  	          /// 加载会诊申请
			isShowPageButton(CstID);      /// 动态设置页面显示的按钮内容
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)		
}


/// 会诊评价-取消会诊评价
function CanEvaCstNo(){

	runClassMethod("web.DHCEMConsult","CanEvaCstNo",{"ItmID": CstItmID, "UserID":LgUserID},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单当前状态，不允许进行取消评价操作！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请取消评价失败，失败原因:"+jsonString,"warning");
		}
		if (jsonString == 0){
			$.messager.alert("提示:","取消评价成功！","info");
      		GetCstNoObj();  	          /// 加载会诊申请
			isShowPageButton(CstID);      /// 动态设置页面显示的按钮内容
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
	
	if (CstID == ""){
		$.messager.alert("提示:","请发送会诊申请后，再打印！","warning");
		return;
	}
	if (typeof CstItmID == "undefined"){
		PrintCst_REQ(CstID);
	}else{
		PrintCst_REQ(CstItmID);
	}
	
	InsCsMasPrintFlag();  /// 修改会诊打印标志
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

/// 修改会诊打印标志
function InsCsMasPrintFlag(){
	
	runClassMethod("web.DHCEMConsult","InsCsMasPrintFlag",{"CstID":CstID},function(jsonString){

		if (jsonString != 0){
			$.messager.alert("提示:","更新会诊打印状态失败，失败原因:"+jsonString,"warning");
		}
	},'',false)
}

/// 加载申请单内容
function LoadReqFrame(arCstID, arCstItmID){

	CstID = arCstID;
	CstItmID = arCstItmID;
	InitCsPropDiv();              /// 初始化会诊性质
	GetCstNoObj();  	          /// 加载会诊申请
	GetConsMarIndDiv(CstID);	  /// 取会诊科室亚专业指征
	isShowPageButton(arCstID);    /// 动态设置页面显示的按钮内容
	if (EpisodeID != ""){
		InitPatNotTakOrdMsg(0);   /// 验证病人是否允许开医嘱
	}
	$("#dgCstDetList").datagrid("load",{"CstID":arCstID});      /// 会诊科室
}

function HideOrShowByModel(){
	if(seeCstType==1){ 
		$("#OpBtns").hide();
		$(".p-content").css({"top":25});
	}else if(seeCstType==2){ 
		$("#CompAreaDiv").hide();   ///完成日期和完成时间
		$("#Opinion").hide();  ///会诊意见
		$("#bt_reva").hide();  
		$("#bt_sure").hide();
		$("#bt_revsure").hide(); //hxy 2021-01-07
		$("#bt_revreva").hide(); //hxy 2021-01-08
		$("#bt_can").hide();
	}else{ 
		var CmpDate = $HUI.datebox("#CstCompDate").getValue();   ///已经有完成时间的就不初始化默认时间
		$("#CompAreaDiv").show();
		if(UpdCompDateFlag==1){
			$HUI.datebox("#CstCompDate").enable();
			$HUI.timespinner("#CstCompTime").enable();
			
		}else{
			$HUI.datebox("#CstCompDate").disable();
			$HUI.timespinner("#CstCompTime").disable();
		}
	}
	return;	
}

/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {
	
	if (CstID != ""){
		LoadReqFrame(CstID, CstItmID);    /// 加载病理申请
	}else{
		if (EpisodeID!="") GetLgContent();  /// 取登录信息
	}
}

/// 开启授权
function OpenAuthorize(){

	if (CstID == ""){
		$.messager.alert("提示:","请保存会诊后，再开启授权！","warning");
		return;
	}

	var lnk ="dhcem.consultemraut.csp?EpisodeID="+ EpisodeID +"&CstID="+ CstID;

	websys_showModal({
		url:lnk,
		title:'授权',
		isTopZindex:true,
		width:screen.availWidth-150,height:screen.availHeight-150,
		onClose: function() {
			
		}
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
			$.messager.alert("提示:",jsonString,"warning");
		}
	},'',false)
}

/// 新建会诊授权窗口
function newCreateConsultWin(){
	var option = {
		};
	new WindowUX($g('病历授权'), 'newConWin', '1000', '600', option).Init();

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

	var Link="dhcem.patemrque.csp?&EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&targetName=Attitude"+"&TextValue=&Flag="+flag; //+obj.text;
	
	typeof window.parent.commonShowWin == "function"?OpenWinObj=window.parent:OpenWinObj=window;
	
	OpenWinObj.commonShowWin({
		url: Link,
		title: $g("引用"),
		width: 1280,
		height: 600
	})
//	//showModalDialog chrome 不能兼容,换成Open
//	//var result = window.showModalDialog(url,"_blank",'dialogTop:50;dialogWidth:1250px;DialogHeight=600px;center=1'); 
//	var result = window.open(url,"_blank",'dialogTop:50;dialogWidth:1250px;DialogHeight=600px;center=1'); 
//	return;
//	try{
//		if (result){
//			if (flag == 1){
//				if ($("#ConsTrePro").val() == ""){
//					$("#ConsTrePro").val(result.innertTexts);  		/// 简要病历
//				}else{
//					$("#ConsTrePro").val($("#ConsTrePro").val()  +"\r\n"+ result.innertTexts);  		/// 简要病历
//				}
//			}else{
//				if ($("#ConsOpinion").val() == ""){
//					$("#ConsOpinion").val(result.innertTexts);  		/// 简要病历
//				}else{
//					$("#ConsOpinion").val($("#ConsOpinion").val()  +"\r\n"+ result.innertTexts);  		/// 简要病历
//				}	
//			}
//		}
//	}catch(ex){}
}

function InsQuote(innertTexts,flag){
	
	if (flag == 1){
		if ($("#ConsTrePro").val() == ""){
			$("#ConsTrePro").val(innertTexts);  		/// 简要病历
		}else{
			$("#ConsTrePro").val($("#ConsTrePro").val()  +"\r\n"+ innertTexts);  		/// 简要病历
		}
	}else if(flag == 3){ //hxy 2021-01-12 st
		if ($("#ConsPurpose").val() == ""){
			$("#ConsPurpose").val(innertTexts);  		/// 会诊理由及要求
		}else{
			$("#ConsPurpose").val($("#ConsPurpose").val()  +"\r\n"+ innertTexts);  		/// 会诊理由及要求
		} //ed
	}else{
		if ($("#ConsOpinion").val() == ""){
			$("#ConsOpinion").val(innertTexts);  		/// 简要病历
		}else{
			$("#ConsOpinion").val($("#ConsOpinion").val()  +"\r\n"+ innertTexts);  		/// 简要病历
		}	
	}
	return;
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

	HideOrShowByModel();   		///从申请、处理、查看弹出进入界面显示和隐藏元素
	
	HideAndShowButton(BTFlag);  ///界面通过本人发送、本人接收显示按钮
	
	InitContentTop();     		///不同的按钮导致content的top值不同
	
	DisAndEnabBtn();  		    ///通过状态设置按钮是否去
	
	HideOrShowBySet();          ///按照配置显示界面
	
	HideByConsType();           ///单科多科等类型
}

function HideByConsType(){
	var CstType = $HUI.combobox("#CstType").getText(); 	          /// 会诊类型
	if(!isCanAddLoc()) {
		$("#bt_saveloc").hide(); /// 保存科室	
	}
}

function HideAndShowButton(BTFlag){
	//IsAnti: Is anti consult flog
	/// 请会诊  申请未发送
	if (BTFlag == 1){
		$("#bt_acc").hide();   /// 接收
		$("#bt_ref").hide();   /// 拒绝
		$("#bt_arr").hide();   /// 到达
		$("#bt_com").hide();   /// 完成
		$("#bt_precom").hide();
		$("#bt_ceva").hide();  /// 评价
		$("#bt_revceva").hide();  /// 取消会诊评价 //hxy 2021-01-09
		$("#bt_sure").hide();  /// 确认
		$("#bt_revsure").hide();  /// 取消确认 //hxy 2021-01-07
		$("#bt_reva").hide();  /// 评价
		$("#bt_revreva").hide();  /// 取消评价 //hxy 2021-01-08
		$("#bt_TempLoc").hide();   /// 科室模板
		$("#bt_TempUser").hide();  /// 个人模板
		$("#bt_TempQue").hide();   /// 选择模板
		$("#bt_TempSave").hide();  /// 保存模板
		$("#bt_log").hide();   /// 会诊日志
		$("#bt_revacc").hide();/// 取消接收
		$("#bt_revcom").hide();/// 取消完成
		$("#bt_save").show();  /// 保存
		$("#bt_remove").show(); ///删除
		$("#bt_send").show();  /// 发送
		$("#bt_can").show();   /// 取消
		$("#bt_openemr").show();   /// 开启授权
		$("#bt_colseemr").hide();  /// 关闭授权
		$("#Opinion").show();   /// 会诊意见
		$("#QueEmr").show();    /// 引用
		$("#QueEmr2").hide();   /// 引用
		$("#QueEmr3").show();   /// 引用 hxy 2021-01-12
		$("#bt_order").hide();  /// 医嘱录入
		$("#bt_patsee").hide();  /// 检查检验
		$("#bt_patemr").hide(); /// 查看病历
		$("#bt_saveloc").hide(); /// 保存科室
		$("#bt_can").hide();
		PageEditFlag(1);	    /// 页面编辑
		isEditFlag = 0;	        /// 行编辑标志
		if (CstOutFlag == "Y") isEditFlag = 1;
	}
	/// 请会诊  申请已发送
	if (BTFlag == 2){
		$("#bt_save").hide();  /// 保存
		$("#bt_remove").hide(); ///删除
		$("#bt_send").hide();  /// 发送
		$("#bt_acc").hide();   /// 接收
		$("#bt_ref").hide();   /// 拒绝
		$("#bt_arr").hide();   /// 到达
		$("#bt_com").hide();   /// 完成
		$("#bt_precom").hide();
		$("#bt_ceva").hide();  /// 评价
		$("#bt_revceva").hide();   /// 取消会诊评价 //hxy 2021-01-09
		$("#bt_colseemr").hide();  /// 关闭授权
		$("#bt_TempLoc").hide();   /// 科室模板
		$("#bt_TempUser").hide();  /// 个人模板
		$("#bt_TempQue").hide();   /// 选择模板
		$("#bt_TempSave").hide();  /// 保存模板
		$("#ConsEva").hide();  	   /// 会诊评价
		$("#bt_order").hide();     /// 医嘱录入
		$("#bt_patsee").hide();  /// 检查检验
		$("#bt_patemr").hide();    /// 查看病历
		$("#bt_openemr").show();   /// 开启授权
		$("#bt_can").show();   /// 取消
		if(seeCstType!=2){
			$("#Opinion").show();  /// 会诊意见
			$("#ConsEvaR").show(); /// 请会诊评价
		}
		
		$("#QueEmr").hide();   /// 引用
		$("#QueEmr2").hide();  /// 引用
		$("#QueEmr3").hide();   /// 引用 hxy 2021-01-12
		$("#bt_log").show();   /// 会诊日志
		$("#bt_revacc").hide();/// 取消接收
		$("#bt_revcom").hide();/// 取消完成
		if(seeCstType!=2){
			$("#bt_reva").show();  /// 评价
			$("#bt_sure").show();  /// 确认
			$("#bt_revsure").show();  /// 取消确认 //hxy 2021-01-07
			$("#bt_revreva").show();  /// 取消评价 //hxy 2021-01-08
		}
		if (ModCsFlag == 1){
			$("#bt_saveloc").show(); /// 保存科室
		}else{
			$("#bt_saveloc").hide(); /// 保存科室
		}
		PageEditFlag(2);	   /// 页面编辑
		isEditFlag = 1;	       /// 行编辑标志
		var CstType = $HUI.combobox("#CstType").getText(); 	 
		if ((ModCsFlag == 1)&&(CstType.indexOf("院际")==-1)) isEditFlag = 0;	 /// 行编辑标志
	}

	/// 会诊显示
	if (BTFlag == 3){
		$("#bt_save").hide();  /// 保存
		$("#bt_remove").hide(); ///删除
		$("#bt_send").hide();  /// 发送
		$("#bt_can").hide();   /// 取消
		$("#bt_sure").hide();  /// 确认
		$("#bt_revsure").hide();  /// 取消确认 //hxy 2021-01-07
		$("#bt_reva").hide();  /// 评价
		$("#bt_revreva").hide();  /// 取消评价 //hxy 2021-01-08
		$("#ConsEvaR").hide(); /// 请会诊评价
		$("#bt_openemr").hide();   /// 开启授权
		$("#bt_colseemr").hide();  /// 关闭授权
		$("#bt_saveloc").hide();   /// 保存科室
		
		$("#bt_acc").show();   /// 接收
		$("#bt_ref").show();   /// 拒绝
		$("#bt_revacc").show();/// 取消接收
		$("#bt_arr").show();   /// 到达
		$("#bt_com").show();   /// 完成
		$("#bt_revcom").show();/// 取消完成
		$("#bt_precom").show();
		$("#bt_ceva").show();  /// 评价
		$("#bt_revceva").show(); /// 取消会诊评价 //hxy 2021-01-09
		$("#bt_order").show();   /// 医嘱录入
		$("#bt_patsee").show();  /// 检查检验
		$("#bt_patemr").show(); /// 查看病历
		$("#Opinion").show();   /// 会诊意见
		$("#QueEmr").hide();    /// 引用
		$("#QueEmr2").show ();  /// 引用
		$("#QueEmr3").hide();   /// 引用 hxy 2021-01-12
		$("#bt_TempLoc").show();   /// 科室模板
		$("#bt_TempUser").show();  /// 个人模板
		$("#bt_TempQue").show();   /// 选择模板
		$("#bt_TempSave").show();  /// 保存模板
		$("#ConsEva").show();  	   /// 会诊评价
		$("#bt_log").show();       /// 会诊日志
		PageEditFlag(0);	   /// 页面编辑
		isEditFlag = 1;	       /// 行编辑标志
	}
	/// 其他人显示
	if (BTFlag == 4){
		$("#bt_save").hide();  /// 保存
		$("#bt_remove").hide(); ///删除
		$("#bt_send").hide();  /// 发送
		$("#bt_can").hide();   /// 取消
		$("#bt_sure").hide();  /// 确认
		$("#bt_revsure").hide();  /// 取消确认 //hxy 2021-01-07
		$("#bt_reva").hide();  /// 评价
		$("#bt_revreva").hide();  /// 取消评价 //hxy 2021-01-08
		$("#bt_com").hide();   /// 完成
		$("#bt_precom").hide();
		$("#bt_ceva").hide();  /// 评价
		$("#bt_revceva").hide();  /// 取消会诊评价 //hxy 2021-01-09
		$("#bt_acc").hide();   /// 接收
		$("#bt_ref").hide();   /// 拒绝
		$("#bt_arr").hide();   /// 到达
		$("#bt_patemr").hide();    /// 查看病历
		$("#bt_openemr").hide();   /// 开启授权
		$("#bt_colseemr").hide();  /// 关闭授权
		$("#Opinion").show();  /// 会诊意见
		$("#QueEmr").hide();   /// 引用
		$("#QueEmr2").hide();  /// 引用
		$("#QueEmr3").hide();   /// 引用 hxy 2021-01-12
		$("#bt_TempLoc").hide();   /// 科室模板
		$("#bt_TempUser").hide();  /// 个人模板
		$("#bt_TempQue").hide();   /// 选择模板
		$("#bt_TempSave").hide();  /// 保存模板
		$("#ConsEvaR").hide();     /// 请会诊评价
		$("#ConsEva").hide();  	   /// 会诊评价
		$("#bt_log").hide();   /// 会诊日志
		$("#bt_revacc").hide();/// 取消接收
		$("#bt_revcom").hide();/// 取消完成
		$("#bt_order").hide(); /// 医嘱录入
		$("#bt_patsee").hide();  /// 检查检验
		$("#bt_saveloc").hide(); /// 保存科室
		PageEditFlag(0);	   /// 页面编辑
		isEditFlag = 1;	       /// 行编辑标志
	}
	/// 页面默认显示
	if (BTFlag == 5){
		$("#bt_can").hide();   /// 取消
		$("#bt_sure").hide();  /// 确认
		$("#bt_revsure").hide();  /// 取消确认 //hxy 2021-01-07
		$("#bt_reva").hide();  /// 评价
		$("#bt_revreva").hide();  /// 取消评价 //hxy 2021-01-08
		$("#bt_com").hide();   /// 完成
		$("#bt_precom").hide();/// 预完成
		$("#bt_ceva").hide();  /// 评价
		$("#bt_revceva").hide();  /// 取消会诊评价 //hxy 2021-01-09
		$("#bt_acc").hide();   /// 接收
		$("#bt_ref").hide();   /// 拒绝
		$("#bt_arr").hide();   /// 到达
		$("#bt_patemr").hide();    /// 查看病历
		$("#Opinion").hide();      /// 会诊意见
		$("#QueEmr").show();   /// 引用
		$("#QueEmr2").hide();  /// 引用
		$("#QueEmr3").show();   /// 引用 hxy 2021-01-12
		$("#bt_openemr").hide();   /// 开启授权
		$("#bt_colseemr").hide();  /// 关闭授权
		$("#bt_TempLoc").hide();   /// 科室模板
		$("#bt_TempUser").hide();  /// 个人模板
		$("#bt_TempQue").hide();   /// 选择模板
		$("#bt_TempSave").hide();  /// 保存模板
		$("#ConsEvaR").hide(); /// 请会诊评价
		$("#ConsEva").hide();  /// 会诊评价
		$("#bt_log").hide();   /// 会诊日志
		$("#bt_revacc").hide();/// 取消接收
		$("#bt_revcom").hide();/// 取消完成
		$("#bt_order").hide(); /// 医嘱录入
		$("#bt_patsee").hide();  /// 检查检验
		$("#bt_saveloc").hide(); /// 保存科室
	}
	
	/// 请院际会诊  申请已发送
	if ((CstOutFlag == "Y")&(BTFlag == 2)&(IsPerAccFlag == 0)){
		$("#bt_acc").show();   /// 接收
		$("#bt_revacc").show();/// 取消接收
		$("#bt_com").show();   /// 完成
		$("#bt_precom").show();
		$("#bt_ceva").hide();  /// 评价
		$("#ConsEva").hide();  /// 会诊评价
		$("#bt_revceva").hide();  /// 取消会诊评价 //hxy 2021-01-09
		if(CsStatCode=="完成"){     
			$("#bt_revcom").show();    //状态为完成时显示取消完成按钮
		}
	}
	
	/// 会诊评价
	if (isEvaShowFlag == 1){
		$("#ConsEvaR").show(); /// 请会诊评价
		$("#ConsEva").show();  /// 会诊评价
	}
	
	/// 多科会诊  请会诊显示
	if ((MulWriFlag == 1)&(CstMorFlag == "Y")&(BTFlag == 2)){

		$("#bt_ref").hide();   /// 拒绝
		$("#bt_ceva").hide();  /// 评价
		$("#ConsEva").hide();  /// 会诊评价
		$("#bt_revceva").hide();  /// 取消会诊评价 //hxy 2021-01-09
		
		if (IsPerAccFlag == 0){
			$("#bt_acc").show();    /// 接收
			$("#bt_precom").show(); /// 预完成
			$("#bt_com").show();    /// 完成
			$("#ConsEvaR").show();  /// 请会诊评价
			$("#bt_revacc").show();
			$("#bt_revcom").show(); /// 取消完成
			$("#QueEmr2").show ();  /// 引用
	    }
	}
	
	/// 多科会诊  会诊显示
	if ((MulWriFlag == 1)&(CstMorFlag == "Y")&(BTFlag == 3)){
		$("#bt_ref").hide();   /// 拒绝
		$("#bt_ceva").hide();  /// 评价
		$("#ConsEva").hide();  /// 会诊评价
		$("#bt_revceva").hide();  /// 取消会诊评价 //hxy 2021-01-09
		$("#bt_acc").hide();   /// 接收
		$("#bt_precom").hide(); ///预完成
		$("#bt_com").hide();   /// 完成
		$("#bt_revacc").hide();/// 取消接收
		$("#bt_revcom").hide();/// 取消完成
	}
	
	if (BTFlag == 4){
		$HUI.combobox("#HospArea").enable(); 	  /// 院区
	}
	
	if(IsAnti=="Y"){
		$("#AntiDiv").show();
		if(DocaNeedOpin!=1){
			$("#Opinion").hide();
			$("#bt_precom").hide(); ///预完成
		}
		$("#bt_order").hide();   /// 医嘱录入
		//$("#bt_patsee").hide();  /// 检查检验
		$("#bt_saveloc").hide(); /// 保存科室
	}else{
		$("#AntiDiv").hide();
		if(seeCstType!=2){
			$("#Opinion").show();
			$("#bt_precom").show(); ///预完成
		}
	}
	
	
	/// 会诊子表ID为空时，不显示会诊日志按钮
	if (CstItmID == ""){
		$("#bt_log").hide();   /// 会诊日志
	}	
}

function DisAndEnabBtn(){
	
	$HUI.linkbutton("#bt_acc").enable();
	$HUI.linkbutton("#bt_ref").enable();
	$HUI.linkbutton("#bt_com").enable();
	$HUI.linkbutton("#bt_precom").enable();
	$HUI.linkbutton("#bt_ceva").enable();
	$HUI.linkbutton("#bt_can").enable();
	$HUI.linkbutton("#bt_openemr").enable();
	$HUI.linkbutton("#bt_revcom").enable();
	$HUI.linkbutton("#bt_revacc").enable();
	$HUI.linkbutton("#bt_reva").enable();
	$HUI.linkbutton("#bt_remove").enable();
	$HUI.linkbutton("#bt_save").enable();
	$HUI.linkbutton("#bt_sure").enable();
	$HUI.linkbutton("#bt_order").enable();
	$HUI.linkbutton("#bt_print").enable();
	$HUI.linkbutton("#bt_patemr").enable();
	$HUI.linkbutton("#bt_patsee").enable();
	$HUI.linkbutton("#bt_revsure").disable(); //hxy 2021-01-07
	$HUI.linkbutton("#bt_revreva").disable(); //hxy 2021-01-08
	$HUI.linkbutton("#bt_revceva").disable(); //hxy 2021-01-09
	
	if(CsStatCode=="取消"){
		$HUI.linkbutton("#bt_reva").disable();
		$HUI.linkbutton("#bt_can").disable();
		$HUI.linkbutton("#bt_sure").disable();
		$HUI.linkbutton("#bt_openemr").disable();
		$HUI.linkbutton("#bt_acc").disable();
		$HUI.linkbutton("#bt_revacc").disable();
		$HUI.linkbutton("#bt_ref").disable();
		$HUI.linkbutton("#bt_precom").disable();
		$HUI.linkbutton("#bt_com").disable();
		$HUI.linkbutton("#bt_revcom").disable();
		$HUI.linkbutton("#bt_ceva").disable();
		$HUI.linkbutton("#bt_order").disable();
		$HUI.linkbutton("#bt_print").disable();
		$HUI.linkbutton("#bt_patemr").disable();
		$HUI.linkbutton("#bt_patsee").disable();
		isEditFlag = 1;	         /// 行编辑标志
	}
	
	
	if((CsStatCode=="拒绝")||(CsStatCode=="驳回")){
		$HUI.linkbutton("#bt_reva").disable();
		$HUI.linkbutton("#bt_sure").disable();
		$HUI.linkbutton("#bt_openemr").disable();
		$HUI.linkbutton("#bt_acc").disable();
		$HUI.linkbutton("#bt_ref").disable();
		$HUI.linkbutton("#bt_precom").disable();
		$HUI.linkbutton("#bt_com").disable();
		$HUI.linkbutton("#bt_ceva").disable();
		$HUI.linkbutton("#bt_revacc").disable();
		$HUI.linkbutton("#bt_revcom").disable();
		$HUI.linkbutton("#bt_print").disable();
		$HUI.linkbutton("#bt_order").disable();
		$HUI.linkbutton("#bt_patemr").disable();
		$HUI.linkbutton("#bt_patsee").disable();
		isEditFlag = 1;	         /// 行编辑标志
	}
	
	if((CsStatCode=="发送")||(CsStatCode=="审核")){
		$HUI.linkbutton("#bt_sure").disable();
		$HUI.linkbutton("#bt_reva").disable();
		$HUI.linkbutton("#bt_ceva").disable();
		$HUI.linkbutton("#bt_revacc").disable();
		$HUI.linkbutton("#bt_revcom").disable();
		$HUI.linkbutton("#bt_remove").disable();
		$HUI.linkbutton("#bt_save").disable();	
		$HUI.linkbutton("#bt_sure").disable();
		if(ConsUseStatusCode.indexOf("^30^")!=-1){   ///接收状态启用
			$HUI.linkbutton("#bt_com").disable();
			$HUI.linkbutton("#bt_precom").disable();	
		}
	}
	
	if((CsStatCode=="接收")||(CsStatCode=="取消完成")){
		$HUI.linkbutton("#bt_ceva").disable();
		$HUI.linkbutton("#bt_ref").disable();
		$HUI.linkbutton("#bt_acc").disable();
		$HUI.linkbutton("#bt_revcom").disable();
		$HUI.linkbutton("#bt_can").disable();
		$HUI.linkbutton("#bt_sure").disable();
		$HUI.linkbutton("#bt_reva").disable();
//		if(CsStatCode=="取消完成"){
//			$HUI.linkbutton("#bt_revacc").disable();	
//		}
	}
	
	if(CsStatCode=="取消接收"){
		$HUI.linkbutton("#bt_com").disable();
		$HUI.linkbutton("#bt_precom").disable();
		$HUI.linkbutton("#bt_ceva").disable();
		$HUI.linkbutton("#bt_revacc").disable();
		$HUI.linkbutton("#bt_revcom").disable();
		$HUI.linkbutton("#bt_reva").disable();
		$HUI.linkbutton("#bt_sure").disable();
	}
	
	if(CsStatCode=="完成"){
		//$HUI.linkbutton("#bt_ceva").disable();
		$HUI.linkbutton("#bt_com").disable();
		$HUI.linkbutton("#bt_precom").disable();
		$HUI.linkbutton("#bt_ref").disable();
		$HUI.linkbutton("#bt_revacc").disable();
		$HUI.linkbutton("#bt_acc").disable();
		$HUI.linkbutton("#bt_can").disable();

		if(ConsUseStatusCode.indexOf("^60^")!=-1){   ///确认状态启用
			$HUI.linkbutton("#bt_reva").disable();
		}
		isEditFlag = 1;	         /// 行编辑标志
	}
	
	
	if(CsStatCode=="确认"){
		$HUI.linkbutton("#bt_com").disable();
		$HUI.linkbutton("#bt_precom").disable();
		$HUI.linkbutton("#bt_ref").disable();
		$HUI.linkbutton("#bt_revacc").disable();
		$HUI.linkbutton("#bt_acc").disable();
		$HUI.linkbutton("#bt_can").disable();
		$HUI.linkbutton("#bt_revcom").disable();
		$HUI.linkbutton("#bt_sure").disable();
		isEditFlag = 1;	         /// 行编辑标志
		$HUI.linkbutton("#bt_revsure").enable(); //hxy 2021-01-07 只有确认时可取消确认
	}
	if(CsStatCode=="取消确认"){ //hxy 2021-01-07 st
		$HUI.linkbutton("#bt_com").disable();
		$HUI.linkbutton("#bt_precom").disable();
		$HUI.linkbutton("#bt_ref").disable();
		$HUI.linkbutton("#bt_revacc").disable();
		$HUI.linkbutton("#bt_acc").disable();
		$HUI.linkbutton("#bt_can").disable();
		$HUI.linkbutton("#bt_reva").disable();
		$HUI.linkbutton("#bt_ceva").disable(); //
		isEditFlag = 1;	         /// 行编辑标志
	} //ed
	if(CsStatCode=="取消评价"){ //hxy 2021-01-08 st
		$HUI.linkbutton("#bt_com").disable();
		$HUI.linkbutton("#bt_precom").disable();
		$HUI.linkbutton("#bt_ref").disable();
		$HUI.linkbutton("#bt_revacc").disable();
		$HUI.linkbutton("#bt_acc").disable();
		$HUI.linkbutton("#bt_can").disable();
		$HUI.linkbutton("#bt_revcom").disable();
		$HUI.linkbutton("#bt_sure").disable();
		$HUI.linkbutton("#bt_revsure").enable(); //hxy 2021-01-08 取消评价时可取消确认
		$HUI.linkbutton("#bt_ceva").disable(); //
		isEditFlag = 1;	         /// 行编辑标志
	} //ed
	if(CsStatCode=="取消会诊评价"){ //hxy 2021-01-09 st
		$HUI.linkbutton("#bt_com").disable();
		$HUI.linkbutton("#bt_precom").disable();
		$HUI.linkbutton("#bt_ref").disable();
		$HUI.linkbutton("#bt_revacc").disable();
		$HUI.linkbutton("#bt_acc").disable();
		$HUI.linkbutton("#bt_can").disable();
		$HUI.linkbutton("#bt_revcom").disable();
		isEditFlag = 1;	         /// 行编辑标志
	} //ed
	if((CsStatCode=="评价")||(CsStatCode=="会诊评价")){
		$HUI.linkbutton("#bt_com").disable();
		$HUI.linkbutton("#bt_precom").disable();
		$HUI.linkbutton("#bt_ref").disable();
		$HUI.linkbutton("#bt_revacc").disable();
		$HUI.linkbutton("#bt_acc").disable();
		$HUI.linkbutton("#bt_can").disable();
		$HUI.linkbutton("#bt_revcom").disable();
		$HUI.linkbutton("#bt_ceva").disable();
		if(CsStatCode=="评价"){
			$HUI.linkbutton("#bt_sure").disable();
			$HUI.linkbutton("#bt_reva").disable();
			$HUI.linkbutton("#bt_revreva").enable(); //hxy 2021-01-08 只有评价时可取消评价
		}
		if((CsStatCode=="会诊评价")&(ConsUseStatusCode.indexOf("^60^")!=-1)){  
			$HUI.linkbutton("#bt_reva").disable();
			$HUI.linkbutton("#bt_revceva").enable(); //hxy 2021-01-09 只有会诊评价时可取消评价
		}
		
		isEditFlag = 1;	         /// 行编辑标志
	}

	//if("^"+$g("取消")+"^"+$g("拒绝")+"^"+$g("完成")+"^"+$g("确认")+"^"+$g("评价")+"^"+$g("会诊评价")+"^".indexOf("^"+CsStatCode+"^")!=-1){
	if(CsStatCode!="发送"){
		$("#bt_saveloc").hide(); /// 保存科室
		isEditFlag=1;
	}else{
		if(ModCsFlag == 1){
			$("#bt_saveloc").show(); /// 保存科室
		}else{
			$("#bt_saveloc").hide(); /// 保存科室
		}
	}
	
	if(seeCstType == 1){
		$("#bt_saveloc").hide();   /// 保存科室
	}
	
}

///走后台界面配置决定界面显示内容
function HideOrShowBySet(){
	
	///拒绝按钮
	if(ConsUseStatusCode.indexOf("^25^")==-1){
		$("#bt_ref").hide();	 ///拒绝接收
	}
	
	///接收
	if(ConsUseStatusCode.indexOf("^30^")==-1){
		$("#bt_acc").hide();     ///接收
		$("#bt_revacc").hide();	 ///取消接收
		$("#bt_ref").hide();	 ///拒绝接收
	}
	
	///取消接收
	if(ConsUseStatusCode.indexOf("^35^")==-1){
		$("#bt_revacc").hide();	 ///取消接收
	}
	
	///完成按钮
	if(ConsUseStatusCode.indexOf("^50^")==-1){
		$("#bt_precom").hide();	 ///预完成
		$("#bt_com").hide();	 ///完成
		$("#bt_revcom").hide();	 ///取消完成
	}
	
	///会诊评价
	if((ConsUseStatusCode.indexOf("^55^")==-1)||(WriEvaCsFlag==0)){//hxy 2020-07-09 原:if(ConsUseStatusCode.indexOf("^55^")==-1){
		$("#bt_ceva").hide();   ///会诊评价
		$("#ConsEva").hide();	 	///评价内容
		$("#bt_revceva").hide();	///取消会诊评价 //hxy 2021-01-08
	}
	
	
	///确认
	if(ConsUseStatusCode.indexOf("^60^")==-1){
		$("#bt_sure").hide();   ///确认
		$("#bt_revsure").hide();   ///取消确认 //hxy 2021-01-08
	}
	
	///评价
	if(ConsUseStatusCode.indexOf("^70^")==-1){
		$("#bt_reva").hide();   ///评价
		$("#ConsEvaR").hide;	 ///评价内容
		$("#bt_revreva").hide();   ///取消评价 //hxy 2021-01-08
	}
	return;
}

/// 接收
function SaveAcceptCstNo(){

	var consDate = $HUI.datebox("#ConsDate").getValue();      /// 会诊日期
	var consTime = $HUI.timespinner("#ConsTime").getValue();  /// 会诊时间
	var Params = consDate +"^"+ consTime;
	runClassMethod("web.DHCEMConsult","SaveAccCstNo",{"ItmID": CstItmID, "UserID":session['LOGON.USERID'], "Params":Params},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单非待接收状态，不允许进行接收操作！","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("提示:","会诊时间不能早于申请时间！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请接收失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示:","接收成功！","info");
			GetCstNoObj();  	          /// 加载会诊申请
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
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
	
	if (EpisodeID == ""){
		$.messager.alert("提示:","请选择会诊记录后重试！","warning");
		return;
	}
	
	if (GetTakOrdAutFlag(1) != 1){
		$.messager.alert("提示:","您无权限查看该病人病历内容！","warning");
		return;
	}
	
	/// 诊断判断
	if (GetMRDiagnoseCount() == 0){
		$.messager.alert("提示:","病人没有诊断,请先录入！","warning",function(){DiagPopWin()});
		return;	
	}
	
	var lnk ="emr.interface.browse.category.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID']+"&Action="+'externalapp';
	window.open(lnk, 'newWin', 'height='+ (window.screen.availHeight-200) +', width='+ (window.screen.availWidth-200) +', top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

function PatPacsAndLis(){
	if (EpisodeID == ""){
		$.messager.alert("提示:","请选择会诊记录后重试！","warning");
		return;
	}
	
	var lnk = "dhcem.consultsee.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm;
	websys_showModal({
		url:lnk,
		title:$g('检验检查查看'),
		width:screen.availWidth-150,height:screen.availHeight-150,
		onClose: function() {
			
		}
	});	
}

/// 历次会诊
function PatHisCst(){
	
	if (EpisodeID == ""){
		$.messager.alert("提示:","请选择会诊记录后重试！","warning");
		return;
	}
	window.open("dhcem.consultpathis.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID, 'newWin', 'height='+ (window.screen.availHeight-200) +', width='+ (window.screen.availWidth-200) +', top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// 设置界面编辑状态
function PageEditFlag(Flag){
	
	if (Flag == 1){
		$("#ConsTrePro").prop("readonly",false);  /// 简要病历
		$("#ConsPurpose").prop("readonly",false); /// 会诊目的
		$("#CstUser").attr("disabled", false);    /// 联系人
		$("#CstTele").attr("disabled", false);    /// 联系电话
		//$HUI.radio("input[name='CstEmFlag']").disable(false);
		$HUI.combobox("#CstType").disable(); 	  /// 会诊类型
		$HUI.radio("input[name='CstEmFlag']").enable();
		$HUI.combobox("#HospArea").enable(); 	  /// 院区
		//$HUI.combobox("#CstType").enable();
	}else{
		//$("#ConsTrePro").attr("disabled",true);   /// 简要病历
		$("#ConsTrePro").prop("readonly",true);
		//$("#ConsPurpose").attr("disabled",true);  /// 会诊目的
		$("#ConsPurpose").prop("readonly",true);
		$("#CstUser").attr("disabled", true);       /// 联系人
		$("#CstTele").attr("disabled", true);		/// 联系电话
		$HUI.radio("input[name='CstEmFlag']").disable();
		$HUI.combobox("#CstType").disable();        /// 会诊类型
		$HUI.combobox("#HospArea").disable(); 	    /// 院区
	}

	if ((Flag != 0)&(CstOutFlag != "Y")&(isOpiEditFlag != "Y")){
		$("#ConsOpinion").prop("readonly",true);   /// 会诊结论
	}else{
		$("#ConsOpinion").prop("readonly",false);  /// 会诊结论
	}
	
	/// 会诊评价
	if (isEvaShowFlag == 1){
		$HUI.radio("input[name='CstEvaFlag']").disable();
		$("#CstEvaDesc").attr("disabled",true);    /// 评价补充内容
		$HUI.combobox("#CstEva").disable();        /// 会诊评价

		$HUI.radio("input[name='CstEvaRFlag']").disable();
		$("#CstEvaRDesc").attr("disabled",true);    /// 会诊评价
		$HUI.combobox("#CstEvaR").disable();        /// 会诊评价
	}else{
		$("#CstEvaRDesc").attr("disabled",($("#CstEvaRDesc").val()==""?true:false));    /// 评价补充内容	
		$("#CstEvaDesc").attr("disabled",($("#CstEvaDesc").val()==""?true:false));      /// 评价补充内容	
	}
}

/// 验证病人是否允许开医嘱
function InitPatNotTakOrdMsg(TipFlag){
	
	///seeCstType==1:查看模式
	if(seeCstType==1) return "";
	
	TakOrdMsg = GetPatNotTakOrdMsg();
	if ((TakOrdMsg != "")&(TipFlag == 1)&&(NoAdmValidDaysLimit!=1)){
		$.messager.alert("提示:",TakOrdMsg,"warning");
		return;	
	}
}

/// 验证病人是否允许开医嘱
function GetPatNotTakOrdMsg(){

	var NotTakOrdMsg = "";
	/// 验证病人是否允许开医嘱
	runClassMethod("web.DHCEMConsultCom","GetPatNotTakOrdMsg",{"LgGroupID":LgGroupID,"LgUserID":LgUserID,"LgLocID":LgLocID,"EpisodeID":EpisodeID},function(jsonString){

		if (jsonString != ""){
			NotTakOrdMsg = jsonString;
		}
	},'',false)

	return NotTakOrdMsg;
}

///保存时弹出提示窗口  qiaoqingao  2018/08/20
function savesymmodel(){
	
	var patsymtom=$("#arPatSym").val();
	if ((patsymtom=="病人主诉！")||patsymtom==""){
		$.messager.alert("提示:","没有待保存数据！","warning");
		return;
	}
	createsymPointWin();    ///打开提示窗口
}

/// 提示窗口   qiaoqingao  2018/08/20
function createsymPointWin(){
		
	if($('symwin').is(":hidden")){ 
	   $('symwin').window('open');
		return;
		}           ///窗体处在打开状态,退出	
	/// 查询窗口
	var option = {
		collapsible:true,
		minimizable:false,
		border:true,
		closed:"true"
	};
	new WindowUX('选择', 'symwin', '260', '130', option).Init();
}

/// 保存主诉科室模板   qiaoqingao  2018/08/20
function saveSymLoc(){
	
	var ConsOpinion=$("#ConsOpinion").val();  // 信息
	if(ConsOpinion==""){
		$.messager.alert("提示:","会诊结论模板不能为空！","warning");
		return;	
	}
	var Params=ConsOpinion+"^"+session['LOGON.CTLOCID']+"^"
	
	runClassMethod("web.DHCEMConsult","SaveCOT",{"Params":Params},function(jsonString){
		if (jsonString==0){
			$.messager.alert("提示:","保存成功！","info");
		}if (jsonString=="-1"){
			$.messager.alert("提示:","数据已存在！","warning");
		}
	},'',false)
}

/// 保存主诉科室模板   qiaoqingao  2018/08/20
function saveSymUser(){
	
	var ConsOpinion=$("#ConsOpinion").val();  // 信息
	var Params=ConsOpinion+"^^"+session['LOGON.USERID']
	if(ConsOpinion==""){
		$.messager.alert("提示:","会诊意见模板不能为空！","warning");
		return;	
	}
	runClassMethod("web.DHCEMConsult","SaveCOT",{"Params":Params},function(jsonString){
		if (jsonString==0){
			$.messager.alert("提示:","保存成功！","info");
		}if (jsonString=="-1"){
			$.messager.alert("提示:","数据已存在！","warning");
		}
	},'',false)
}

///保存检查目的模板    qiaoqingao  2018/08/20
function showmodel(flag){
		
	if($('#winonline').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="winonline"></div>');
	$('#winonline').window({
		title:$g('模板列表'),
		collapsible:true,
		minimizable:false,
		border:false,
		closed:"true",
		width:800,
		height:500
	});
	
	var cot = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcem.consultcottemp.csp"></iframe>';
	$('#winonline').html(cot);
	$('#winonline').window('open');
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

/// 会诊打印HTML
function PrintCstHtml(){
	
	if(CstID==""){
		$.messager.alert("提示","当前未选择有效会诊,不能打印！","warning");
		return;
	}
	
	if(CsStatCode==""){ //hxy 2021-01-13
		$.messager.alert("提示","会诊未发送,不能打印！","warning");
		return;
	}
	
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
	
	var cstType=$("#CstType").combobox("getText");
	
	if(CstItmID!=""){
		PrintCstHtmlMethod(CstItmID);
		return;
	}
	
	$m({
		ClassName:"web.DHCEMConsultCom",
		MethodName:"GetCstItmIDs",
		CstID:CstID
	},function(txtData){
		PrintCstHtmlMethod(txtData);
	});
	
	return;
}

function PrintCstHtmlMethod(txtData){
	if(PrintModel==1){
		window.open("dhcem.printconsone.csp?CstItmIDs="+txtData);
		InsCsMasPrintFlag();  /// 修改会诊打印标志
	}else{
		var prtRet = PrintCstNew(txtData,LgHospID);
		if(prtRet){
			InsCsMasPrintFlag();  /// 修改会诊打印标志	
		}
	}	
}

/// 验证病人是否允许开会诊
function InitPatNotTakCst(TipFlag){
	
	TakCstMsg = GetPatNotTakCst();
	if ((TakCstMsg != "")&(TipFlag == 1)){
		$.messager.alert("提示:",TakCstMsg,"warning");
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
	//window.open(lnk,"_blank","top=100,left=100,width=700,height=350,menubar=yes,scrollbars=no,toolbar=no,status=no");
	websys_createWindow(lnk, "_blank", "height: " + (top.screen.height - 100) + "px,width: " + (top.screen.width - 100) + "px");
}

/// 弹出医嘱录入窗口
function OpenCsOrderWin(){
	
	if (EpisodeID == ""){
		$.messager.alert("提示:","请选择会诊记录后重试！","warning");
		return;
	}
	
	if (GetTakOrdAutFlag(2) != 1){
		$.messager.alert("提示:","您无权限给该病人下医嘱！","warning");
		return;
	}
	
	var lnk = "dhcem.consultorder.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm + "&FixedEpisodeID="+EpisodeID+"&CstItmID="+CstItmID;
	websys_showModal({
		url:lnk,
		maximizable:false,
		title:$g('医嘱录入'),
		width:screen.availWidth-150,height:screen.availHeight-150,
		onClose: function() {
			tkMakeServerCall("web.DHCDocMainOrderInterface","ChartItemChange");
		}
	});
}

/// 获取查看病历权限
function GetTakOrdAutFlag(TakType){
	
	var HasFlag = "";
	runClassMethod("web.DHCEMConsult","HasTakOrdAut",{"itmID":CstItmID,"TakType":TakType},function(jsonString){
		HasFlag = jsonString;
	},'',false)

	return HasFlag;
}

/// 页面流程按钮显示控制
function InitPageButton(){
	
	runClassMethod("web.DHCEMConsStatus","jsCsStatNode",{"HospID":""},function(jsObject){
		if (jsObject != null){
		}
	},'json',false)
}

/// 修改会诊科室列表
function InsCsLocItem(){
	
	if ((editSelRow != -1)||(editSelRow == 0)) { 
        $("#dgCstDetList").datagrid('endEdit', editSelRow); 
    }
    
	/// 会诊科室
	var CsLocArr=[];
	var rowData = $('#dgCstDetList').datagrid('getChanges');
	if (rowData.length == 0){
		$.messager.alert("提示:","没有待修改数据！","warning");
		return;	
	}
	$.each(rowData, function(index, item){
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^^^^"+ item.itmID;
		    CsLocArr.push(TmpData);
		}
	})
	
	if (isExistItem() == 1){
		$.messager.alert("提示:","存在一人多条记录，不能保存！","warning");
		return;		
	}
	
	var CstType = $HUI.combobox("#CstType").getText(); 	 /// 会诊类型
	if ((CsLocArr.length >= 2)&(CstType.indexOf("单科") != "-1")){
		$.messager.alert("提示:","会诊类型为单科会诊，不能选择多个科室！","warning");
		return;	
	}
	var mListData = CsLocArr.join("@");
	
	runClassMethod("web.DHCEMConsult","InsCsLocItem",{"CstID":CstID, "LgParam":LgParam, "mListData":mListData},function(jsonString){
		if (jsonString == 0){
			$.messager.alert("提示:","修改成功！","info");
			$("#dgCstDetList").datagrid("load",{"CstID":CstID});      /// 会诊科室
			if (window.parent.QryConsList != undefined){
				window.parent.QryConsList("R");
			}
		}
	},'',false)
}

/// 判断是否有重复项目
function isExistItem(){
	
	var isExistFlag = 0;
	var LocArr = [],UserArr=[];
	var rowData = $('#dgCstDetList').datagrid('getRows');
	/*
	for(var m=0; m<rowData.length; m++){
		if(trim(rowData[m].LocDesc) != ""){
		    if (LocArr.indexOf(rowData[m].LocID) != -1) {isExistFlag = 1;}
		    LocArr.push(rowData[m].LocID);
		}
	}
	*/
	
	for(var m=0; m<rowData.length; m++){
		if(trim(rowData[m].UserID) != ""){
		    if (UserArr.indexOf(rowData[m].UserID) != -1) {isExistFlag = 1;}
		    UserArr.push(rowData[m].UserID);
		}
	}
	
	return isExistFlag;
}

/// 删除会诊科室列表
function delCsItem(ItmID){
	
	var CstType = $HUI.combobox("#CstType").getText(); 	 /// 会诊类型
	var rows = $('#dgCstDetList').datagrid('getRows');
	var CsLocArr = [];
	for(var i=0; i<rows.length; i++){
		if (rows[i].LocID != ""){
			CsLocArr.push(rows[i].LocID);
		}
	}
	if ((CsLocArr.length <= 2)&(CstType.indexOf("多科") != "-1")){
		$.messager.alert("提示:","删除错误，会诊类型为多科会诊，至少应选择两个或两个以上科室！","warning");
		return false;	
	}
	if (CsLocArr.length <= 1){
		$.messager.alert("提示:","删除错误，会诊科室不能为空，至少需要选择一个科室！","warning");
		return false;	
	}
	
	var Flag = false;
	runClassMethod("web.DHCEMConsult","delCsItem",{"ItmID":ItmID, "LgUserID":LgUserID},function(jsonString){
		if (jsonString == 0){
			$.messager.alert("提示:","删除成功！","info");
			Flag = true;
		}
	},'',false)
	return Flag;
}

///界面关闭时如果未发送提示:浏览器兼容问题去掉
/*
window.onbeforeunload= function(e) { 
	var isSaveNoSend=false;
	var isSend = $("#bt_send").is(":hidden");  ///是否保存了未发送
	if((CstID!="")&&(!isSend)) isSaveNoSend=true;
	if((isSaveNoSend)&&(seeCstType==2)){
		var e= window.event||e;  
		e.returnValue=("注意!!申请单未发送,如需修改并继续发送需要去会诊处理界面,确定关闭界面吗？");
	}
}
*/

/// 会诊性质
function InitCsPropDiv(){
	
	runClassMethod("web.DHCEMConsultCom","JsonCstProp",{"CstID":CstID,"LgHospID":LgHospID},function(jsonObject){ //hxy 2020-05-29 add LgHospID

		if (jsonObject != null){
			InsCsPropTable(jsonObject);
		}
	},'json',false)
}

/// 会诊性质
function InsCsPropTable(itmArr){
	
	if (itmArr.length == 0){
		$.messager.alert("提示:","会诊性质为空，请在基础配置中维护！","warning");
		return;
	}
	var itemhtmlArr = [];
	for (var j=0; j<itmArr.length; j++){
		var EmFlag = itmArr[j].itmDesc.indexOf($g("急")) != -1?"Y":"N";
		itemhtmlArr.push("<input id='"+ itmArr[j].itmID +"' class='hisui-radio' type='radio' label='"+ itmArr[j].itmDesc +"' value='"+ EmFlag +"' name='CstEmFlag'>");
	}
    $("#itemProp").html(itemhtmlArr.join(""));
    $HUI.radio("#itemProp input.hisui-radio",{});
}



function openAppraisePageR(){
	var ID=CstID;
	var Code ="SHR";
	var Mode = "R";
	var Title = $g("申请医师评价");
	openAppraisePage(ID,Code,Mode,Title);
}

function openAppraisePageC(){
	var ID=CstItmID;
	var Code ="SHP";
	var Mode = "C";
	var Title = $g("会诊医师评价");
	openAppraisePage(ID,Code,Mode,Title);
}



///会诊医生评价申请
function openAppraisePage(ID,Code,Mode,Title){
	var ID=CstItmID;   
	var AppTableCode=Code ;
	var SaveMode=Mode;     ///方式,会诊还是申请   C会诊医师评价 R申请医生评价
	var AppTableTitle=Title;
	var lnk ="dhcem.consapptable.csp?ID="+ ID +"&AppTableCode="+AppTableCode+"&SaveMode="+SaveMode+"&AppTableTitle="+AppTableTitle;

	websys_showModal({
		url:lnk,
		title:AppTableTitle,
		width:550,
		height:500,
		onClose: function() {
			
		}
	});
	
}


window.onload = onload_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
