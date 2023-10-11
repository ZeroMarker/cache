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
var LType = "CONSULTWARD";  /// 会诊科室代码
var CsRType = "NUR";    /// 会诊类型  医生
var CstOutFlag = "";    /// 院际会诊标志
var CstMorFlag ="";     /// 多科会诊标志
var CstEmFlag = "";     /// 急会诊标志 hxy 2021-03-31
var TakOrdMsg = "";     /// 验证病人是否允许开医嘱
var TakCstMsg = "";     /// 验证医生是否有开会诊权限
var isOpiEditFlag = 0;  /// 会诊结论是可编辑
var isEvaShowFlag = 0;  /// 会诊评价是否显示
var IsPerAccFlag = 0;   /// 是否允许接受申请单
var CsStatCode = "";    /// 申请单当前状态
var seeCstType="";      ///查看模式
var IsWFCompFlag="";    /// 工作流审核标志
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
	if ((EpisodeID != "")&&(seeCstType!="1")){ //hxy 2020-08-05 查看模式不需此验证
		InitPatNotTakOrdMsg(1);    /// 验证病人是否允许开医嘱
		//InitPatNotTakCst(1);     /// 验证病人是否有会诊类型
	}
}

/// 初始化界面控件内容
function InitPageComponent(){
	
	/// 默认平会诊
	//$HUI.radio("input[name='CstEmFlag'][value='N']").setValue(true);
	$HUI.radio("input[name='CstEmFlag'][label='平会诊']").setValue(true);

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

		    	isEditFlag = 0;		/// 行编辑标志
			}
			$("#dgCstDetList").datagrid("reload");      /// 会诊科室
	    },
	    onShowPanel: function () { //数据加载完毕事件
			$("#CstType").combobox('reload',unitUrl);
        },
        onLoadSuccess:function(data){
	        if((seeCstType==2)&&(data.length==0)){ //hxy 2021-12-16 st
		        $.messager.alert("提示","您无申请权限！","warning");
				return;
		    }//ed
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
	        if (option.text.indexOf("其他") != "-1"){
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
	
	/// 会诊日期控制 hxy 2021-03-10
	$('#CstDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			var now = new Date(now.getFullYear(), now.getMonth(), now.getDate());
			return date>=now;
		}
	});
	/// 会诊日期
	$HUI.datebox("#CstDate").setValue(GetCurSystemDate(0));
	
	/// 会诊时间
	if(ReqTimeFill==1){ //hxy 2021-02-19
		$HUI.datebox("#CstDate").enable(); //hxy 2021-03-10
		$HUI.timespinner("#CstTime").enable();
	}
	
	/// 会诊到达日期控制 hxy 2021-04-01
	$('#CstArrDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			var now = new Date(now.getFullYear(), now.getMonth(), now.getDate());
			return date<=now;
		}
	});
	
	/// 请会诊评价
	var option = {
		panelHeight:"auto",
		blurValidValue:true,
        onSelect:function(option){
	        if (option.text.indexOf("其他") != "-1"){
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
	        if (option.text.indexOf("其他") != "-1"){
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
	
	/// 专科小组
	var option = {
		///panelHeight:"auto",
		blurValidValue:true,
		url:$URL+"?ClassName=web.DHCEMConsultGroup&MethodName=JsonConsGroup&HospID="+LgHospID+"&Type=NUR", //hxy 2021-06-21
        onSelect:function(option){
	        if(GrpAllowUpd!=1){isEditFlag = 1}; //hxy 2020-09-25 isEditFlag = 1;  /// 行编辑标志
			$("#dgCstDetList").datagrid("load",{"GrpID":option.value,"LgParams":LgParam});      /// 会诊科室
	    },
		onShowPanel:function(){
			
		},
		onChange:function(newValue, oldValue){
			if (newValue == ""){
				isEditFlag = 0;  /// 行编辑标志
				$("#dgCstDetList").datagrid("load",{"GrpID":""});      /// 会诊科室
			}
		}
	};
	var url = "";
	new ListCombobox("CstGrp",url,'',option).init();
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
			if($("#CstAddr").val()==""){//hxy 2022-03-21 st
				if(AuditDefPlace.split(",")[0]==1){
					if(AuditDefPlace.indexOf("1,")>-1){
						$("#CstAddr").val(jsonObject.LocDesc+AuditDefPlace.replace("1,",""));
					}else{
						$("#CstAddr").val(jsonObject.LocDesc);
					}
				}
			}//ed
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
			url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonPrvTp&Type="+CsRType,
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
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'}); //hxy 2021-05-10 st
				var LocID = $(ed.target).val();
				if(LocID!=""){
					var PrvTpID = option.value;
					var Datas=serverCall("web.DHCEMConsultCom","JsonLocCareProv",{ProvType:'NURSE',LocID:LocID,PrvTpID:PrvTpID,LgUserID:LgUserID});
					if(Datas=="[]"){
						$.messager.alert("提示","当前类型无护士,请选择其他类型！");
						var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
						$(ed.target).val("");
						var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTp'});
						$(ed.target).combobox('setValue',"");
					} 
				}//ed
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
			//url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+LgHospID,
			url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocList&LType="+LType+"&LocID="+LgLocID+"&HospID="+LgHospID,
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
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'}); //hxy 2021-05-10 st
				var PrvTpID = $(ed.target).val();
				if(PrvTpID!=""){
					var LocID = option.value;
					var Datas=serverCall("web.DHCEMConsultCom","JsonLocCareProv",{ProvType:'NURSE',LocID:LocID,PrvTpID:PrvTpID,LgUserID:LgUserID});
					if(Datas=="[]"){
						$.messager.alert("提示","当前类型无护士,请选择其他类型！");
						var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
						$(ed.target).val("");
						var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTp'});
						$(ed.target).combobox('setValue',"");
					} 
				}//ed
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
				GetMarIndDiv(option.value); 	/// 取科室亚专业指征
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
				var unitUrl=$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocCareProv&ProvType=NURSE&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&LgUserID="+ LgUserID;
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
		{field:'LocID',title:'科室ID',width:100,editor:texteditor,align:'center',hidden:true}, //2021-05-10 位置前移
		{field:'LocDesc',title:'科室',width:290,editor:LocEditor,align:'center'}, //2021-05-10 位置前移
		{field:'PrvTpID',title:'职称ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'PrvTp',title:'类型',width:160,editor:PrvTpEditor,align:'center'}, //hxy 2021-02-20 职称->类型
		//{field:'LocID',title:'科室ID',width:100,editor:texteditor,align:'center',hidden:true},
		//{field:'LocDesc',title:'科室',width:290,editor:LocEditor,align:'center'},
		{field:'MarID',title:'亚专业ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'MarDesc',title:'亚专业',width:200,editor:MarEditor,align:'center',hidden:true},
		{field:'UserID',title:'护士ID',width:110,editor:texteditor,align:'center',hidden:true},
		{field:'UserName',title:'护士',width:120,editor:DocEditor,align:'center'},
		{field:'TelPhone',title:'联系方式',width:130,editor:texteditor,align:'center'},
		{field:'operation',title:"操作",width:100,align:'center',formatter:SetCellUrl}
	]];
	
	///  定义datagrid
	var option = {
		border:true, //hxy 2023-02-07 st
		bodyCls:'panel-header-gray', //ed
		//showHeader:false,
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		fit : false,
	    onClickRow: function (rowIndex, rowData) { //hxy 2021-03-08 onDblClickRow->onClickRow
			
			if(!isCanUpdConsLoc()) return;
			
			var CstType = $HUI.combobox("#CstType").getText(); 	          /// 会诊类型
			if (((CstType.indexOf("单科") != "-1")&(rowIndex != 0))||(CstType == ""))return;
			
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
        }
	};
	/// 就诊类型
	var uniturl = $URL+"?ClassName=web.DHCEMConsultQuery&MethodName=JsonQryConsult&CstID="+"";
	new ListComponent('dgCstDetList', columns, uniturl, option).Init();
}

/// 链接
function SetCellUrl(value, rowData, rowIndex){	
	if(HISUIStyleCode=="lite"){ //hxy 2023-02-06
		var html = '<a href="javascript:void(0)" class="icon-add" style="color:#000;" onclick="insRow()"></a>';
	    html +='<a href="javascript:void(0)" class="icon-cancel" style="color:#000;" onclick="delRow('+ rowIndex +')"></a>';
	    return html;
	}else{
	var html = "<a href='javascript:void(0)' onclick='delRow("+ rowIndex +")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/></a>";
	html += "<a href='javascript:void(0)' onclick='insRow()'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' border=0/></a>";
	return html;
	}
}

/// 删除行
function delRow(rowIndex){
	
	if(!isCanUpdConsLoc()) return;
	
	/// 行对象
    var rowObj={PrvTpID:'', PrvTp:'', LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:''};
	
	/// 当前行数大于4,则删除，否则清空
	if(rowIndex=="-1"){
		$.messager.alert("提示","请先选择行！");
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
	
	if(!isCanUpdConsLoc()) return;
	
	var CstType = $HUI.combobox("#CstType").getText(); 	          /// 会诊类型
	if ((CstType.indexOf("单科") != "-1")||(CstType == "")) return;
			
    var rowObj={PrvTpID:'', PrvTp:'', LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:''};
	$("#dgCstDetList").datagrid('appendRow',rowObj);
}

/// 发送病理申请
function SaveCstNo(SendFlag){ //hxy 2021-04-12 add SendFlag
    
    if ((editSelRow != -1)||(editSelRow == 0)) { 
        $("#dgCstDetList").datagrid('endEdit', editSelRow); 
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
	
	/*if ((CstID=="")&&(SendFlag=="Send")){
		$.messager.alert("提示","请保存会诊申请后，再发送！","warning");
		return;
	}*/
	
    var CstType = $HUI.combobox("#CstType").getValue();
	if (CstType == "") {
		$.messager.alert("提示","会诊类型不能为空！","warning");
		return;
	}
	
	var CstTrePro = $("#ConsTrePro").val();     /// 简要病历
	if (CstTrePro.replace(/\s/g,'') == ""){
		$.messager.alert("提示","病情摘要不能为空！","warning");
		return;
	}
	CstTrePro = $_TrsSymbolToTxt(CstTrePro);        /// 处理特殊符号
	
	var CstPurpose = $("#ConsPurpose").val();  	/// 会诊目的
	if (CstPurpose.replace(/\s/g,'') == ""){
		$.messager.alert("提示","会诊理由及要求不能为空！","warning");
		return;
	}
	CstPurpose = $_TrsSymbolToTxt(CstPurpose);      /// 处理特殊符号
	if(PrintModel!=1){ //hxy 2021-05-12 xml打印时，控制病情摘要、会诊理由及要求行数和
		var CstTreProLen=CstTrePro.split("\n").length;
		var CstPurposeLen=CstPurpose.split("\n").length;
		if((CstTreProLen+CstPurposeLen)>19){
			$.messager.alert("提示","当前配置为单页打印，请简述 病情摘要、会诊理由及要求，减少行数！","warning");
			return;
		}
	}
	
	var CsRUserID = session['LOGON.USERID'];  		/// 申请科室
	var CsRLocID = session['LOGON.CTLOCID'];  		/// 申请人
	
	var CstEmFlag = $("input[name='CstEmFlag']:checked").val();   /// 加急标识
	if (typeof CstEmFlag == "undefined"){
		CstEmFlag = "N";
	}
	var CsPropID = $("input[name='CstEmFlag']:checked").attr("id"); /// 会诊性质
	if (typeof CsPropID == "undefined"){
		$.messager.alert("提示","保存会诊申请前，请先选择会诊性质！","warning");
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
		$.messager.alert("提示","未选择院际会诊医院！","warning");
		return;	
	}
	//var CstLoc = $("#CstLoc").val();     /// 外院科室
	var CstLoc = $HUI.combobox("#CstLoc").getText(); 	          /// 外院科室
	var CstUser = $("#CstUser").val();   /// 联系人
	var CstTele = $("#CstTele").val();   /// 联系电话
	if (!$("#CstTele").validatebox('isValid')){
		$.messager.alert("提示","联系电话验证失败，请重新录入！","warning");
		return;
	}
	var CstNote = "";  				     /// 备注
	var CstAddr = $("#CstAddr").val();   /// 会诊地点
	var MoreFlag = CstType.indexOf("多科") != "-1"?"Y":"N";  /// 是否多科
	
//	var mListData = EpisodeID +"^"+ CsRUserID +"^"+ CsRLocID +"^"+ CstTrePro +"^"+ CstPurpose +"^"+ CstTypeID +"^"+ CstAddr +"^"+ CsRType;
//		mListData += "^"+ CstDate +"^"+ CstTime +"^"+ CstEmFlag +"^"+ CstOutFlag +"^"+ CstUnit +"^"+ CstLoc +"^"+ CstNote +"^"+ CstUser +"^"+ CstTele +"^"+ "" +"^"+ MoreFlag;

	/// 会诊科室
	var ConsDetArr=[],HasRepetDoc=false,DocList="^";;
	var rowData = $('#dgCstDetList').datagrid('getRows');
	$.each(rowData, function(index, item){
		if(trim(item.LocDesc) != ""){
			if((DocList.indexOf("^"+item.UserID+"^")!=-1)&&(trim(item.UserID) != "")){
				HasRepetDoc=true;
			}
			DocList=DocList+item.UserID+"^";
			
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^"+ item.MarID +"^"+ item.LocGrpID;
		    ConsDetArr.push(TmpData);
		}
	})
	
	if(HasRepetDoc){
		$.messager.alert("提示","存在同一人员多条记录，请确认！","warning");
		return;
	}

	if ((ConsDetArr.length == 1)&(CstType.indexOf("多科") != "-1")){
		$.messager.alert("提示","会诊类型为多科会诊，至少选择两个及两个以上科室！","warning");
		return;	
	}
	if ((ConsDetArr.length >= 2)&(CstType.indexOf("单科") != "-1")){
		$.messager.alert("提示","会诊类型为单科会诊，不能选择多个科室！","warning");
		return;	
	}
	if (ConsDetArr.length >= 2){ MoreFlag = "Y";}  /// 科室数量大于2,默认为多科
	
	var ConsDetList = ConsDetArr.join("@");
	if ((ConsDetList == "")&(CstOutFlag == "N")){
		$.messager.alert("提示","会诊科室不能为空！","warning");
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
			if(jsonString==-20){
				$.messager.alert("提示","会诊时间不应早于当前时间！","warning");
				return;
			}else{
			$.messager.alert("提示","会诊申请保存失败，失败原因:"+jsonString,"warning");
			}
		}else{
			CstID = jsonString;
			if(SendFlag=="Send"){ //hxy 2021-04-12
				SendCstNo();
			}else{ //ed
			$.messager.alert("提示","保存成功！","info");
			if (window.parent.QryConsList != undefined){  ///刷新左侧列表 hxy 2021-05-25
				window.parent.QryConsList("R");
			}
			$(".tip").text("(已保存)");
			}
		}
	},'',false)
}
/*
/// 发送
function SendCstNo(){

	runClassMethod("web.DHCEMConsult","SendCstNo",{"CstID": CstID, "UserID":session['LOGON.USERID']},function(jsonString){
		if (jsonString == -1){
			$.messager.alert("提示","申请单已发送，不能再次发送！");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示","会诊申请发送失败，失败原因:"+jsonString);
		}else{
			$.messager.alert("提示","发送成功！");
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
	if ('undefined'!==typeof websys_getMWToken){ //hxy 2023-02-11 Token改造
		link += "&MWToken="+websys_getMWToken();
	}
	$("#newWinFrame").attr("src",link);
}


/// 加载会诊申请主信息内容
function GetCstNoObj(){
	if(CstItmID=="")return;
	var Param=""; //hxy 2021-03-16 st
	if(parent.$("button:contains('"+$g("申请列表")+"')").hasClass("btn-blue-select")){ 
		Param="Y";
	}
	runClassMethod("web.DHCEMConsultQuery","JsGetCstNoObj",{"ItmID":CstItmID,"Param":Param},function(jsonString){ //ed add ,"Param":Param

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			InsCstNoObj(jsonObjArr);
		}
	},'json',false)
}

/// 设置会诊申请单内容
function InsCstNoObj(itemobj){
	if(itemobj.CstStatus!=""){
		/// 会诊日期控制
		$('#CstDate').datebox().datebox('calendar').calendar({
			validator: function(date){
				return date;
			}
		});
	}else{
		/// 会诊日期控制
		$('#CstDate').datebox().datebox('calendar').calendar({
			validator: function(date){
				var now = new Date();
				var now = new Date(now.getFullYear(), now.getMonth(), now.getDate());
				return date>=now;
			}
		});
	}
	$("#ConsTrePro").val($_TrsTxtToSymbol(itemobj.CstTrePro));  		/// 简要病历
	$("#ConsPurpose").val($_TrsTxtToSymbol(itemobj.CstPurpose));  	/// 会诊目的 
	$("#CstUser").val(itemobj.CstUser);   		    /// 联系人
	$("#CstTele").val(itemobj.CstPhone);   		    /// 联系电话
	$("#CstRLoc").val(itemobj.CstRLoc);   		    /// 申请科室
	$("#CstRDoc").val(itemobj.CstRUser);   		    /// 申请医师
	$("#CstAddr").val(itemobj.CstNPlace);           /// 会诊地点
	var CstOpinion = "";
	if (itemobj.CstOpinion != ""){
		CstOpinion = itemobj.CstOpinion.replace(new RegExp("<br>","g"),"\r\n")
	}
	$("#ConsOpinion").val($_TrsTxtToSymbol(CstOpinion));      /// 会诊意见

	/// 加急
	if (itemobj.CsPropID != ""){
		$HUI.radio("input[name='CstEmFlag'][id='"+ itemobj.CsPropID +"']").setValue(true);
	}
	$HUI.combobox("#CstType").setValue(itemobj.CstTypeID);   /// 会诊类型
	$HUI.combobox("#CstType").setText(itemobj.CstType);      /// 会诊类型
	
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
	$HUI.datebox("#CstDate").setValue(itemobj.CstNDate);      /// 会诊日期
	$HUI.timespinner("#CstTime").setValue(itemobj.CstNTime);  /// 会诊时间
		
	$HUI.datebox("#ConsDate").setValue(itemobj.SysDate);      /// 系统日期
	$HUI.timespinner("#ConsTime").setValue(itemobj.SysTime);  /// 系统时间
	
	$HUI.datebox("#CstArrDate").setValue(itemobj.ArrDate);      /// 到达日期 hxy 2021-03-31
	$HUI.timespinner("#CstArrTime").setValue(itemobj.ArrTime);  /// 到达时间 hxy 2021-03-31
	
	CsUserID = itemobj.CsUserID;            /// 会诊人员
	EpisodeID = itemobj.EpisodeID;			/// 就诊ID
	CstOutFlag = itemobj.CstOutFlag; 		/// 外院会诊标志
	CstMorFlag = itemobj.CstMorFlag; 		/// 多科会诊标志
	isOpiEditFlag = itemobj.isOpiEditFlag;  /// 会诊结论是可编辑
	IsPerAccFlag = itemobj.IsPerAccFlag;    /// 是否允许接受申请单
	CsStatCode = itemobj.CstStatus;         /// 申请单当前状态
	CstEmFlag = itemobj.CstEmFlag;          /// 急会诊标志 hxy 2021-03-31
	IsWFCompFlag=itemobj.IsWFCompFlag;      /// 工作流审核标志 hxy 2021-06-10
	if (CsStatCode == ""){
		$(".tip").text("(已保存)");
		if(ReqTimeFill==1){ //hxy 2021-02-19
			$HUI.timespinner("#CstTime").enable();
			$HUI.datebox("#CstDate").enable(); //hxy 2021-03-10
		}
		$("#CstAddr").attr("disabled", false); //hxy 2022-03-21
	}else{
		$(".tip").text("");
		$HUI.timespinner("#CstTime").disable(); //hxy 2021-02-19
		$HUI.datebox("#CstDate").disable(); //hxy 2021-03-10
		$("#CstAddr").attr("disabled", true); //hxy 2022-03-21
	}
	
	if (itemobj.CsEvaRFlag != ""){
		$HUI.radio("input[name='CstEvaRFlag'][value='"+ itemobj.CsEvaRFlag +"']").setValue(true);
		if (itemobj.CsEvaRID != ""){
			$HUI.combobox("#CstEvaR").setText(itemobj.CsEvaRDesc);   /// 请会诊评价
		}else{
			$HUI.combobox("#CstEvaR").setText("其他");               /// 会诊评价
			$("#CstEvaRDesc").val($_TrsTxtToSymbol(itemobj.CsEvaRDesc));  /// 请会诊评价
		}
//		$HUI.radio("input[name='CstEvaRFlag']").disable();
//		$("#CstEvaRDesc").attr("disabled",true);    /// 会诊评价
//		$HUI.combobox("#CstEvaR").disable();        /// 会诊评价
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
			$HUI.combobox("#CstEva").setText("其他");             /// 会诊评价
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

	if (itemobj.CstGrpID != ""){
		$HUI.combobox("#CstGrp").setValue(itemobj.CstGrpID);     /// 专科小组
	}else{
		$HUI.combobox("#CstGrp").setValue("");     /// 专科小组	
	}
	
}

/// 发送
function SendCstNo(){

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
		$.messager.alert("提示","病人没有诊断,请先录入！","warning");
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
	
	runClassMethod("web.DHCEMConsult","SendCstNo",{"CstID": CstID, "LgParam":LgParam},function(jsonString){
		var errMsg=jsonString.split("^").length>1?jsonString.split("^")[1]:jsonString;
		jsonString=jsonString.split("^")[0];
		if (jsonString == -1){
			$.messager.alert("提示","申请单已发送，不能再次发送！","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("提示","会诊配置申请需要插入费用医嘱但费用医嘱未配置！","warning");
			return;
		}
		if (jsonString == -12){
			$.messager.alert("提示","医嘱插入失败！返回值:"+errMsg,"warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示","会诊申请发送失败，失败原因:"+errMsg,"warning");
		}else{
			CstID = jsonString;
			GetCstNoObj(); //hxy 2021-02-20
			CsStatCode="发送";
			isShowPageButton(CstID);     /// 动态设置页面显示的按钮内容
			$.messager.alert("提示","发送成功！","info");
			///发送成功后如果配置了自动打印 & 会诊未完成可以打印会诊记录单 hxy 2021-05-17
			if((SendAutoPri==1)&&(ConsNoCompCanPrt!=1)){
				PrintCstHtml();
			}
			if (window.parent.reLoadMainPanel != undefined){
				if(CstItmID!=""){ //hxy 2021-01-14 st 处理界面右侧状态不能对应变化
					window.parent.reLoadMainPanel(CstItmID);
				}else{
				window.parent.reLoadMainPanel(CstID);
				} //ed
			}
			$(".tip").text("");
		}
	},'',false)
}

/// 取消
function CanCstNo(){
	
	if (CstID == ""){
		$.messager.alert("提示","请先选择会诊申请，再进行此操作！","warning");
		return;
	}
	
	IsInsOrd = serverCall("web.DHCEMConsult", "SendIsInsOrd", {CstID:CstID,HospID:LgHospID,Type:"R"}); //hxy 2021-06-15
	/// 验证病人是否允许开医嘱
	if ((IsInsOrd=="1")&&(TakOrdMsg != "")){ //if (TakOrdMsg != ""){
		$.messager.alert("提示",TakOrdMsg.replace("再开申请","取消"),"warning");
		return;	
	}
	
	$.messager.confirm('确认对话框','您确定要取消当前会诊申请吗？', function(r){
		if (r){
			runClassMethod("web.DHCEMConsult","InvCanCstNo",{"CstID":CstID, "UserID":session['LOGON.USERID']},function(jsonObject){

				if (jsonObject.ErrCode == -1){
					$.messager.alert("提示","申请单当前状态，不允许进行取消操作！","warning");
					return;
				}
				if (jsonObject.ErrCode < 0){
					$.messager.alert("提示","会诊申请取消失败，失败原因:"+jsonObject.ErrMsg,"warning");
				}else{
					$.messager.alert("提示","取消成功！","info",function(){
						window.location.reload();
					});
					window.parent.reLoadMainPanel(CstItmID);
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
			$.messager.alert("提示","申请单当前状态，不允许进行确认操作！","warning");
			return;
		}*/
		if (jsonString.split("^")[0] == -1){
			$.messager.alert("提示","申请单当前状态，不允许进行确认操作"+jsonString.split("^")[1]+"!","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("提示","需会诊医师会诊评价后再确认!","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示","会诊申请确认失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示","确认成功！","info");
			GetCstNoObj();
			isShowPageButton(CstID);
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)
}

/// 接收
function AcceptCstNo2(Params){

	runClassMethod("web.DHCEMConsult","AcceptCstNo",{"ItmID": CstItmID, "UserID":session['LOGON.USERID'], "Params":Params},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示","申请单非待接收状态，不允许进行接收操作！","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("提示","会诊时间不能早于申请时间！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示","会诊申请接收失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示","接收成功！","info");
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
		var errMsg=jsonString.split("^").length>1?jsonString.split("^")[1]:jsonString;
		jsonString=jsonString.split("^")[0];
		if (jsonString == -1){
			$.messager.alert("提示","申请单非待接收状态，不允许进行接收操作！","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("提示","会诊时间不能早于申请时间！","warning");
			return;
		}
		if (jsonString == -4){
			$.messager.alert("提示","职称限制，不允许进行接收操作!","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示","会诊申请接收失败，失败原因:"+errMsg,"warning");
		}else{
			$.messager.alert("提示","接收成功！","info");
			GetCstNoObj();  	          /// 加载会诊申请
			isShowPageButton(CstID);      /// 动态设置页面显示的按钮内容
			window.parent.reLoadMainPanel(CstItmID);
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
		var errMsg=jsonString.split("^").length>1?jsonString.split("^")[1]:jsonString;
		jsonString=jsonString.split("^")[0];
		if (jsonString == -1){
			$.messager.alert("提示","申请单非待接收状态，不允许进行取消接收操作！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示","会诊申请取消接收失败，失败原因:"+errMsg,"warning");
		}else{
			$.messager.alert("提示","取消成功！","info");
			GetCstNoObj();  	          /// 加载会诊申请
			isShowPageButton(CstID);      /// 动态设置页面显示的按钮内容
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
		var errMsg=jsonString.split("^").length>1?jsonString.split("^")[1]:jsonString;
		jsonString=jsonString.split("^")[0];
		if (jsonString == -1){
			$.messager.alert("提示","申请单当前所在状态，不允许进行拒绝操作！","warning");
			return;
		}
		
		if (jsonString == -2){
			$.messager.alert("提示","申请单已经审核，不允许进行拒绝操作！","warning");
			return;
		}
		if (jsonString == -3){
			$.messager.alert("提示","申请单涉及多科室会诊，不允许拒绝操作！","warning");
			return;
		}
		
		
		if (jsonString < 0){
			$.messager.alert("提示","会诊申请拒绝失败，失败原因:"+errMsg,"warning");
		}else{
			$.messager.alert("提示","拒绝成功！","info");
			GetCstNoObj();  	         /// 加载会诊申请
			isShowPageButton(CstID);     /// 动态设置页面显示的按钮内容
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// 到达
function AriCstNo(){
	if ((CstMorFlag == "Y")&&(parent.$("button:contains('"+$g("申请列表")+"')").hasClass("btn-blue-select"))){ //多科+申请人时
		var lnk ="dhcem.consultarr.csp?CstID="+ CstID +"&LgParam="+LgParam+"&ModArrTime="+ModArrTime;
		websys_showModal({
			url:lnk,
			title:$g("到达日期时间"),
			iconCls:"icon-w-paper",
			width:520,
			height:320,
			onClose: function() {
				GetCstNoObj();
				window.parent.reLoadMainPanel(CstItmID);
			}
		});
		return;
	}else{
		/// 多科会诊填写标识 //hxy 2021-03-30 st
		/*var ItmID = "";
		if (((MulWriFlag == 1)&(CstMorFlag == "Y"))||(parent.$("button:contains('"+$g("申请列表")+"')").hasClass("btn-blue-select"))){ ItmID = ""; }
		else{ ItmID = CstItmID; }*/

		var ArrDate = $HUI.datebox("#CstArrDate").getValue();
		var ArrTime = $HUI.timespinner("#CstArrTime").getValue(); 
		
		//runClassMethod("web.DHCEMConsult","AriCstNo",{"ItmID": CstItmID, "UserID":session['LOGON.USERID']},function(jsonString){ //hxy 2021-03-30 st
		runClassMethod("web.DHCEMConsult","AriCstNo",{"CstID": CstID, "ItmID": CstItmID, "LgParam":LgParam,"ArrDate":ArrDate,"ArrTime":ArrTime},function(jsonString){ //ed
		
			if (jsonString == -1){
				$.messager.alert("提示","申请单当前状态，不允许进行到达操作！","warning");
				return;
			}
			if (jsonString == -2){ //hxy 2021-05-07 st
				$.messager.alert("提示","到达时间不能大于当前时间！","warning");
				return;
			}
			if (jsonString == -3){
				$.messager.alert("提示","到达时间不应早于发送时间！","warning");
				return;
			}//ed
			if (jsonString == -4){
				$.messager.alert("提示","到达时间不应晚于完成时间！","warning");
				return;
			}
			if (jsonString < 0){
				$.messager.alert("提示","会诊申请到达失败，失败原因:"+jsonString,"warning");
			}else{
				$.messager.alert("提示","到达成功！","info");
				GetCstNoObj(); /// 加载会诊申请 hxy 2021-04-01 为了更新到达时间
				window.parent.reLoadMainPanel(CstItmID);
			}
		},'',false)
	}
}

/// 会诊意见
function SaveCstOpi(){
	
	if (CsUserID != session['LOGON.USERID']){
		$.messager.alert("提示","您非当前会诊人员，不能进行此操作！","warning");
		return;
	}
	
	var ConsOpinion = $("#ConsOpinion").val();
	if (ConsOpinion.replace(/\s/g,'') == ""){
		$.messager.alert("提示","请填写会诊结论！","warning");
		return;
	}
	ConsOpinion = $_TrsSymbolToTxt(ConsOpinion); /// 处理特殊符号
	
	runClassMethod("web.DHCEMConsult","SaveCstOpi",{"ItmID": CstItmID, "UserID":session['LOGON.USERID'], "CstOpinion":ConsOpinion},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示","申请单当前状态，不允许进行完成操作！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示","保存失败！","warning");
		}else{
			$.messager.alert("提示","保存成功！","info");
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// 完成
function CompCstNo(){
	var IsUserAcc= ConsUseStatusCode.indexOf("^30^");   ///是否启用了保存状态
	
	if ((IsUserAcc!=-1)&(GetIsOperFlag("30") != "1")&(GetIsOperFlag("51") != "1")&(GetIsOperFlag("40") != "1")){ //hxy 2021-03-30 add 40
		$.messager.alert("提示","申请单当前状态，不允许进行完成操作！","warning");
		return;
	}
	if ((IsUserAcc==-1)&(GetIsOperFlag("20") != "1")&(GetIsOperFlag("21") != "1")&(GetIsOperFlag("51") != "1")&(GetIsOperFlag("40") != "1")){ //hxy 2021-03-30 add 40
		$.messager.alert("提示","申请单当前状态，不允许进行完成操作！","warning");
		return;
	}
	
	var ConsOpinion = $("#ConsOpinion").val();
	if (ConsOpinion.replace(/\s/g,'') == ""){
		$.messager.alert("提示","请填写会诊结论！","warning");
		return;
	}
	ConsOpinion = $_TrsSymbolToTxt(ConsOpinion); /// 处理特殊符号
	
	/// 外院和多科申请人填写会诊结论
	/// var Fn = ((CstOutFlag == "Y")||(CstMorFlag == "Y"))?"CompCstMas":"CompCstNo";
	/// 多科会诊填写标识
	var ItmID = "";
	if ((MulWriFlag == 1)&(CstMorFlag == "Y")){ ItmID = ""; }
	else{ ItmID = CstItmID; }
	runClassMethod("web.DHCEMConsult","CompCstMas",{"CstID": CstID, "ItmID": ItmID, "LgParam":LgParam, "CstOpinion":ConsOpinion},function(jsonString){
		var errMsg=jsonString.split("^").length>1?jsonString.split("^")[1]:jsonString;
		jsonString=jsonString.split("^")[0];
		if (jsonString == -1){
			$.messager.alert("提示","申请单当前状态，不允许进行完成操作！","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("提示","会诊时间不能早于申请时间！","warning");
			return;
		}
		if (jsonString == -200){
			$.messager.alert("提示","会诊配置完成需要插入费用医嘱但费用医嘱未配置！","warning");
			return;
		}
		if (jsonString == -13){
			$.messager.alert("提示","医嘱插入失败！返回值："+errMsg,"warning");
			return;
		}
		
		if (jsonString < 0){
			$.messager.alert("提示","会诊申请完成失败，失败原因:"+errMsg,"warning");
		}else{
			$.messager.alert("提示","完成成功！","info");
			GetCstNoObj();  	            /// 加载会诊申请
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
	
	runClassMethod("web.DHCEMConsult","RevCompCstMas",{"CstID": CstID, "ItmID": ItmID, "UserID":session['LOGON.USERID']},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示","申请单当前状态，不允许取消完成操作！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示","会诊申请取消完成失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示","取消成功！","info");
            GetCstNoObj();  	          /// 加载会诊申请
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
		$.messager.alert("提示","您非当前会诊人员，不能进行此操作！","warning");
		return;
	}
	var ConsOpinion = $("#ConsOpinion").val();
	if (ConsOpinion == ""){
		$.messager.alert("提示","请填写会诊结论！","warning");
		return;
	}
	ConsOpinion = $_TrsSymbolToTxt(ConsOpinion); /// 处理特殊符号
	
	runClassMethod("web.DHCEMConsult","CompCstNo",{"ItmID": CstItmID, "LgParam":LgParam, "CstOpinion":ConsOpinion, "Params":Params},function(jsonString){
		
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
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// 请会诊评价
function EvaRCstNo(){
	
	if (GetIsOperFlag("60") != "1"){
		$.messager.alert("提示","申请单当前状态，不允许进行评价操作！","warning");
		return;
	}
	var CstEvaRFlag = $("input[name='CstEvaRFlag']:checked").val();   /// 会诊评价满意度标识
	if (typeof CstEvaRFlag == "undefined"){
		$.messager.alert("提示","请先选择评价满意度！","warning");
		return;
	}
	
	var CstEvaID = $HUI.combobox("#CstEvaR").getValue(); 	      /// 会诊评价
	var CstEvaDesc = $HUI.combobox("#CstEvaR").getText(); 	      /// 会诊评价
	if (CstEvaDesc == ""){
		$.messager.alert("提示","请选择评价内容！","warning");
		return;
	}

	if (CstEvaDesc.indexOf("其他") != "-1"){
		var CstEvaDesc = $("#CstEvaRDesc").val();
		if (CstEvaDesc.replace(/\s/g,'') == ""){
			$.messager.alert("提示","请先填写评价补充内容！","warning");
			return;
		}	
	}
	CstEvaDesc = $_TrsSymbolToTxt(CstEvaDesc); /// 处理特殊符号
	
	var CsEvaParam = CstEvaRFlag +"^"+ CstEvaDesc;
	
	runClassMethod("web.DHCEMConsult","EvaRCstNo",{"CstID": CstID, "LgParam":LgParam, "CsEvaParam":CsEvaParam},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示","申请单当前状态，不允许进行评价操作！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示","会诊申请评价失败，失败原因:"+jsonString,"warning");
		}
		if (jsonString == 0){
			$.messager.alert("提示","评价成功！","info");
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)		
}

/// 会诊评价
function EvaCstNo(){
	
	if (GetIsOperFlag("50") != "1"){
		$.messager.alert("提示","申请单当前状态，不允许进行评价操作！","warning","warning");
		return;
	}
	var CstEvaFlag = $("input[name='CstEvaFlag']:checked").val();   /// 会诊评价满意度标识
	if (typeof CstEvaFlag == "undefined"){
		$.messager.alert("提示","请先选择评价满意度！","warning");
		return;
	}
	
	var CstEvaID = $HUI.combobox("#CstEva").getValue(); 	      /// 会诊评价
	var CstEvaDesc = $HUI.combobox("#CstEva").getText(); 	      /// 会诊评价
	if (CstEvaDesc == ""){
		$.messager.alert("提示","请选择评价内容！","warning");
		return;
	}
	
	if (CstEvaDesc.indexOf("其他") != "-1"){
		CstEvaDesc = $("#CstEvaDesc").val();
		if (CstEvaDesc.replace(/\s/g,'') == ""){
			$.messager.alert("提示","请先填写评价补充内容！","warning");
			return;
		}	
	}
	CstEvaDesc = $_TrsSymbolToTxt(CstEvaDesc); /// 处理特殊符号
	
	var CsEvaParam = CstEvaFlag +"^"+ CstEvaDesc;
	
	runClassMethod("web.DHCEMConsult","EvaCstNo",{"ItmID": CstItmID, "UserID":LgUserID, "CsEvaParam":CsEvaParam},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示","申请单当前状态，不允许进行评价操作！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示","会诊申请评价失败，失败原因:"+jsonString,"warning");
		}
		if (jsonString == 0){
			$.messager.alert("提示","评价成功！","info");
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
	if ('undefined'!==typeof websys_getMWToken){ //hxy 2023-02-11 Token改造
		link += "&MWToken="+websys_getMWToken();
	}
	window.open(link,"_blank","height=600, width=1100, top=30, left=100,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
}

/// 打印
function PrintCst(){
	
	if (CstID == ""){
		$.messager.alert("提示","请发送会诊申请后，再打印！","warning");
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
			$.messager.alert("提示","更新会诊打印状态失败，失败原因:"+jsonString,"warning");
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
		InitPatNotTakOrdMsg(0);    /// 验证病人是否允许开医嘱
	}
	$("#dgCstDetList").datagrid("load",{"CstID":arCstID});      /// 会诊科室
	
	if(seeCstType){ 
		$("#OpBtns").hide();
		$(".p-content").css({"top":25});
	}
}

/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {

	if (CstID != ""){
		LoadReqFrame(CstID, CstItmID);    /// 加载病理申请
	}else{
		GetLgContent();  /// 取登录信息
	}
}

/// 开启授权
function OpenAuthorize(){

	if (CstID == ""){
		$.messager.alert("提示","请保存会诊后，再开启授权！","warning");
		return;
	}
	
	if (document.body.clientWidth > 1000){
		$("#TabMain").attr("src","dhcem.consultemraut.csp?EpisodeID="+ EpisodeID +"&CstID="+ CstID);
		/// 新建会诊授权窗口
		newCreateConsultWin();	
	}else{
		var lnk ="dhcem.consultemraut.csp?EpisodeID="+ EpisodeID +"&CstID="+ CstID;
		if ('undefined'!==typeof websys_getMWToken){ //hxy 2023-02-11 Token改造
			lnk += "&MWToken="+websys_getMWToken();
		}
		window.open(lnk, 'newWin', 'height=550, width=1000, top=200, left=200, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
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

	var Link="dhcem.patemrque.csp?&EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&targetName=Attitude"+"&TextValue=&Flag="+flag; //+obj.text;
	window.parent.commonShowWin({
		url: Link,
		title: "引用",
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
	
	if (flag == 21){
		if ($("#ConsTrePro").val() == ""){
			$("#ConsTrePro").val(innertTexts);  		/// 简要病历
		}else{
			$("#ConsTrePro").val($("#ConsTrePro").val()  +"\r\n"+ innertTexts);  		/// 简要病历
		}
	}else if(flag == 23){ //hxy 2021-01-13 st
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
	
	HideAndShowButton(BTFlag);  ///界面通过本人发送、本人接收显示按钮

	HideOrShowBySet();          ///按照配置显示界面
	
	DisAndEnabBtn();
	
	HideOrShowByProp();         ///急会诊平会诊性质 hxy 2021-03-31
	
	ArrTimeDisOrEnByBtn();      ///到达按钮不可用时，到达日期时间不可编辑 hxy 2021-04-02

}

function HideOrShowByProp(){
	if((ArrJustForE==1)&&(CstEmFlag!="Y")){
		$("#bt_arr").hide();	 ///到达
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
	$HUI.linkbutton("#bt_arr").enable(); //hxy 2021-03-30
	
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
		$HUI.linkbutton("#bt_arr").disable(); //hxy 2021-03-30
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
		$HUI.linkbutton("#bt_arr").disable(); //hxy 2021-03-30
		isEditFlag = 1;	         /// 行编辑标志
	}
	
	if((CsStatCode=="发送")||(CsStatCode=="审核")||(CsStatCode.indexOf("审核")!=-1)){
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
			//$HUI.linkbutton("#bt_arr").disable(); //hxy 2021-03-30 2021-06-10 注释
		}
		if(IsWFCompFlag!="Y"){
			$HUI.linkbutton("#bt_arr").disable(); //hxy 2021-06-10 工作流审核完成
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
		$HUI.linkbutton("#bt_arr").disable(); //hxy 2021-03-30
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
	}
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
		}
		if((CsStatCode=="会诊评价")&(ConsUseStatusCode.indexOf("^60^")!=-1)){  
			$HUI.linkbutton("#bt_reva").disable();
		}
	}

	
}

function HideAndShowButton(BTFlag){
	/// 请会诊  申请未发送
	if (BTFlag == 1){
		$("#bt_acc").hide();   /// 接收
		$("#bt_ref").hide();   /// 拒绝
		$("#bt_arr").hide();   /// 到达
		$("#bt_com").hide();   /// 完成
		$("#bt_ceva").hide();  /// 评价
		$("#bt_ord").hide();   /// 医嘱录入
		$("#bt_sure").hide();  /// 确认
		$("#bt_reva").hide();  /// 评价
		$("#bt_TempLoc").hide();   /// 科室模板
		$("#bt_TempUser").hide();  /// 个人模板
		$("#bt_TempQue").hide();   /// 选择模板
		$("#bt_log").hide();   /// 会诊日志
		$("#bt_revacc").hide();/// 取消接收
		$("#bt_revcom").hide();/// 取消完成
		
		$("#bt_save").show();  /// 保存
		$("#bt_remove").show(); ///删除
		$("#bt_send").show();  /// 发送
		$("#bt_can").show();   /// 取消
		$("#bt_openemr").hide();   /// 开启授权
		$("#bt_colseemr").hide();  /// 关闭授权
		$("#Opinion").show();  /// 会诊意见
		$("#QueEmr").show();   /// 引用
		$("#QueEmr2").hide();   /// 引用 hxy 2021-01-13 st
		$("#QueEmr3").show();   /// 引用 ed
		$("#ConsEvaR").hide(); /// 请会诊评价 //hxy 2021-04-09
		PageEditFlag(1);	   /// 页面编辑
		isEditFlag = 0;	       /// 行编辑标志
		if (CstOutFlag == "Y") isEditFlag = 1;
	}
	/// 请会诊  申请已发送
	if (BTFlag == 2){
		$("#bt_save").hide();  /// 保存
		$("#bt_remove").hide(); ///删除
		$("#bt_send").hide();  /// 发送
		$("#bt_acc").hide();   /// 接收
		$("#bt_ref").hide();   /// 拒绝
		$("#bt_arr").show();   /// 到达 //hxy 2021-03-31 hide->show
		$("#bt_com").hide();   /// 完成
		$("#bt_ceva").hide();  /// 评价
		$("#bt_ord").hide();   /// 医嘱录入
		$("#bt_openemr").hide();   /// 开启授权
		$("#bt_colseemr").hide();  /// 关闭授权
		$("#bt_TempLoc").hide();   /// 科室模板
		$("#bt_TempUser").hide();  /// 个人模板
		$("#bt_TempQue").hide();   /// 选择模板
		$("#ConsEva").hide();  	   /// 会诊评价
		$("#bt_can").show();   /// 取消
		$("#QueEmr").hide();   /// 引用
		$("#QueEmr2").hide();  /// 引用 hxy 2021-01-13 st
		$("#QueEmr3").hide();  /// 引用 ed
		$("#bt_log").show();   /// 会诊日志
		$("#bt_revacc").hide();/// 取消接收
		$("#bt_revcom").hide();/// 取消完成
		if(seeCstType!=2){
			$("#bt_reva").show();  /// 评价
			$("#bt_sure").show();  /// 确认
			$("#ConsEvaR").show(); /// 请会诊评价
			$("#Opinion").show();  /// 会诊意见
		}
		PageEditFlag(2);	   /// 页面编辑
		isEditFlag = 1;	       /// 行编辑标志
	}

	/// 会诊显示
	if (BTFlag == 3){
		$("#bt_save").hide();  /// 保存
		$("#bt_remove").hide(); ///删除
		$("#bt_send").hide();  /// 发送
		$("#bt_can").hide();   /// 取消
		$("#bt_sure").hide();  /// 确认
		$("#bt_reva").hide();  /// 评价
		$("#bt_ref").hide();   /// 拒绝
		$("#ConsEvaR").hide(); /// 请会诊评价
		$("#bt_openemr").hide();   /// 开启授权
		$("#bt_colseemr").hide();  /// 关闭授权
		
		$("#bt_acc").show();   /// 接收
		$("#bt_ref").show();   /// 拒绝
		$("#bt_arr").show();   /// 到达
		$("#bt_com").show();   /// 完成
		$("#bt_ceva").show();  /// 评价
		$("#bt_ord").show();   /// 医嘱录入
		$("#Opinion").show();  /// 会诊意见
		$("#QueEmr").hide();   /// 引用
		$("#QueEmr2").show ();  /// 引用 hxy 2021-01-13 st
		$("#QueEmr3").hide();   /// 引用 ed
		$("#bt_TempLoc").show();   /// 科室模板
		$("#bt_TempUser").show();  /// 个人模板
		$("#bt_TempQue").show();   /// 选择模板
		$("#ConsEva").show();  	   /// 会诊评价
		$("#bt_log").show();   /// 会诊日志
		if ((CsStatCode == "接收")||(CsStatCode == "取消完成")){
			$("#bt_revacc").show();/// 取消接收
		}else{
			$("#bt_revacc").hide();/// 取消接收
		}
		if ((CsStatCode == "发送")||(CsStatCode == "审核")||(CsStatCode=="护理部审核")||(CsStatCode == "取消接收")){
			$("#bt_ref").show();/// 拒绝接收
			$("#bt_acc").show();/// 接收
		}else{
			$("#bt_ref").hide();/// 拒绝接收
			$("#bt_acc").hide();/// 接收
		}
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
		$("#bt_remove").hide(); ///删除
		$("#bt_send").hide();  /// 发送
		$("#bt_can").hide();   /// 取消
		$("#bt_sure").hide();  /// 确认
		$("#bt_reva").hide();  /// 评价
		$("#bt_com").hide();   /// 完成
		$("#bt_ceva").hide();  /// 评价
		$("#bt_acc").hide();   /// 接收
		$("#bt_ref").hide();   /// 拒绝
		$("#bt_arr").hide();   /// 到达
		$("#bt_ord").hide();   /// 医嘱录入
		$("#bt_openemr").hide();   /// 开启授权
		$("#bt_colseemr").hide();  /// 关闭授权
		$("#Opinion").show();  /// 会诊意见
		$("#QueEmr").hide();   /// 引用
		$("#QueEmr2").hide();  /// 引用 hxy 2021-01-13 st
		$("#QueEmr3").hide();  /// 引用 ed
		$("#bt_TempLoc").hide();   /// 科室模板
		$("#bt_TempUser").hide();  /// 个人模板
		$("#bt_TempQue").hide();   /// 选择模板
		$("#ConsEvaR").hide();     /// 请会诊评价
		$("#ConsEva").hide();  	   /// 会诊评价
		$("#bt_log").hide();   /// 会诊日志
		$("#bt_revacc").hide();/// 取消接收
		$("#bt_revcom").hide();/// 取消完成
		PageEditFlag(0);	   /// 页面编辑
		isEditFlag = 1;	       /// 行编辑标志
	}
	/// 页面默认显示
	if (BTFlag == 5){
		$("#bt_can").hide();   /// 取消
		$("#bt_sure").hide();  /// 确认
		$("#bt_reva").hide();  /// 评价
		$("#bt_com").hide();   /// 完成
		$("#bt_ceva").hide();  /// 评价
		$("#bt_acc").hide();   /// 接收
		$("#bt_ref").hide();   /// 拒绝
		$("#bt_arr").hide();   /// 到达
		$("#bt_ord").hide();   /// 医嘱录入
		$("#Opinion").hide();  /// 会诊意见
		$("#bt_openemr").hide();   /// 开启授权
		$("#bt_colseemr").hide();  /// 关闭授权
		$("#bt_TempLoc").hide();   /// 科室模板
		$("#bt_TempUser").hide();  /// 个人模板
		$("#bt_TempQue").hide();   /// 选择模板
		$("#ConsEvaR").hide(); /// 请会诊评价
		$("#ConsEva").hide();  /// 会诊评价
		$("#bt_log").hide();   /// 会诊日志
		$("#bt_revacc").hide();/// 取消接收
		$("#bt_revcom").hide();/// 取消完成
	}
	
	/// 请院际会诊  申请已发送
	if ((CstOutFlag == "Y")&(BTFlag == 2)&(IsPerAccFlag == 0)){
		$("#bt_acc").show();   /// 接收
		//$("#bt_ref").show();   /// 拒绝
		//$("#bt_arr").show();   /// 到达
		$("#bt_com").show();   /// 完成
		$("#bt_ceva").hide();  /// 评价
		$("#ConsEva").hide();  /// 会诊评价
	}
	
	/// 会诊评价
	if (isEvaShowFlag == 1){
		$("#ConsEvaR").show(); /// 请会诊评价
		$("#ConsEva").show();  /// 会诊评价
	}
		/// 系统配置是否需要会诊评价
	if (WriEvaCsFlag == "0"){
		$("#bt_ceva").hide();  /// 评价
		$("#ConsEva").hide();  /// 会诊评价
	}
	
	/// 多科会诊  请会诊显示
	if ((MulWriFlag == 1)&(CstMorFlag == "Y")&(BTFlag == 2)){

		$("#bt_ref").hide();   /// 拒绝
		$("#bt_ceva").hide();  /// 评价
		$("#ConsEva").hide();  /// 会诊评价
		
		if (IsPerAccFlag == 0){
			$("#bt_acc").show();   /// 接收
			$("#bt_arr").show();   /// 到达 //hxy hxy 2021-03-30 注释放开
			$("#bt_com").show();   /// 完成
			$("#ConsEvaR").show(); /// 请会诊评价
			if ((CsStatCode == "接收")||(CsStatCode == "取消完成")){
				$("#bt_revacc").show();/// 取消接收
			}else{
				$("#bt_revacc").hide();/// 取消接收
			}
			if (CsStatCode == "完成"){
				$("#bt_revcom").show();/// 取消完成
			}else{
				$("#bt_revcom").hide();/// 取消完成
			}
	    }
	}
	
	/// 多科会诊  会诊显示
	if ((MulWriFlag == 1)&(CstMorFlag == "Y")&(BTFlag == 3)){
		$("#bt_ref").hide();   /// 拒绝
		$("#bt_ceva").hide();  /// 评价
		$("#ConsEva").hide();  /// 会诊评价
		
		$("#bt_acc").hide();   /// 接收
		//$("#bt_arr").show();   /// 到达
		$("#bt_com").hide();   /// 完成
		$("#bt_revacc").hide();/// 取消接收
		$("#bt_revcom").hide();/// 取消完成
		$("#bt_arr").hide();   /// 到达 hxy 2021-03-31
	}
	
	if (BTFlag == 4){
		$HUI.combobox("#HospArea").enable(); 	  /// 院区
	}
	
	/// 会诊子表ID为空时，不显示会诊日志按钮
	if (CstItmID == ""){
		$("#bt_log").hide();   /// 会诊日志
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
	
	///到达按钮 hxy 2021-03-30
	if(ConsUseStatusCode.indexOf("^40^")==-1){
		$("#bt_arr").hide();	 ///到达
	}
	
	///完成按钮
	if(ConsUseStatusCode.indexOf("^50^")==-1){
		$("#bt_precom").hide();	 ///预完成
		$("#bt_com").hide();	 ///完成
		$("#bt_revcom").hide();	 ///取消完成
	}
	
	///会诊评价
	if(ConsUseStatusCode.indexOf("^55^")==-1){
		$("#bt_ceva").hide();   ///会诊评价
		$("#ConsEva").hide();	 	///评价内容
	}
	
	
	///确认
	if(ConsUseStatusCode.indexOf("^60^")==-1){
		$("#bt_sure").hide();   ///确认
	}
	
	///评价
	if(ConsUseStatusCode.indexOf("^70^")==-1){
		$("#bt_reva").hide();   ///评价
		$("#ConsEvaR").hide;	 ///评价内容
	}
	return;
}


/// 接受
function SaveAcceptCstNo(){

	var consDate = $HUI.datebox("#ConsDate").getValue();      /// 会诊日期
	var consTime = $HUI.timespinner("#ConsTime").getValue();  /// 会诊时间
	var Params = consDate +"^"+ consTime;
	runClassMethod("web.DHCEMConsult","SaveAccCstNo",{"ItmID": CstItmID, "UserID":session['LOGON.USERID'], "Params":Params},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示","申请单非待接收状态，不允许进行接收操作！","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("提示","会诊时间不能早于申请时间！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示","会诊申请接收失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示","接收成功！","info");
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
	
	if (EpisodeID == ""){
		$.messager.alert("提示","请选择会诊记录后重试！","warning");
		return;
	}
	var lnk="emr.record.browse.patient.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID;//hxy 2023-02-11 Token改造
	if ('undefined'!==typeof websys_getMWToken){
		lnk += "&MWToken="+websys_getMWToken();
	}
	window.open(lnk, 'newWin', 'height='+ (window.screen.availHeight-5) +', width='+ (window.screen.availWidth-5) +', top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// 历次会诊
function PatHisCst(){
	
	if (EpisodeID == ""){
		$.messager.alert("提示","请选择会诊记录后重试！","warning");
		return;
	}
	var lnk="dhcem.consultpathis.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&CsType=Nur";//hxy 2023-02-11 Token改造
	if ('undefined'!==typeof websys_getMWToken){
		lnk += "&MWToken="+websys_getMWToken();
	}
	window.open(lnk, 'newWin', 'height='+ (window.screen.availHeight-200) +', width='+ (window.screen.availWidth-200) +', top=50, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
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
		$HUI.combobox("#CstType").enable(); //hxy 2021-04-09 注释放开 护士会诊-会诊处理-已保存未发送的申请单，不能修改会诊类型；
		$HUI.combobox("#CstGrp").enable(); 	      /// 专科小组
	}else{
		//$("#ConsTrePro").attr("disabled",true);   /// 简要病历
		$("#ConsTrePro").prop("readonly",true);
		//$("#ConsPurpose").attr("disabled",true);  /// 会诊目的
		$("#ConsPurpose").prop("readonly",true);
		$("#CstUser").attr("disabled", true);       /// 联系人
		$("#CstTele").attr("disabled", true);		/// 联系电话
		$HUI.radio("input[name='CstEmFlag']").disable();
		$HUI.combobox("#CstType").disable();        /// 会诊类型
		$HUI.combobox("#CstGrp").disable();         /// 专科小组
	}
	if ((Flag != 0)&(CstOutFlag != "Y")&((isOpiEditFlag != "Y"))){
		$("#ConsOpinion").prop("readonly",true);  /// 会诊结论
	}else{
		$("#ConsOpinion").prop("readonly",false);   /// 会诊结论
		if(isOpiEditFlag != "Y"){ //hxy 2021-03-04 接收状态可用时,发送状态的会诊不应能填写会诊结论(接收会丢失结论)；
			$("#ConsOpinion").prop("readonly",true);   /// 会诊结论
		}
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
	
	TakOrdMsg = GetPatNotTakOrdMsg();
	if ((TakOrdMsg != "")&(TipFlag == 1)){
		$.messager.alert("提示",TakOrdMsg,"warning");
		return;	
	}
}

/// 验证病人是否允许开医嘱
function PatNotTakOrdMsg(TipFlag){
	
	TakOrdMsg = GetPatNotTakOrdMsg();
	if ((TakOrdMsg != "")&(TipFlag == 1)){
		$.messager.alert("提示",TakOrdMsg,"warning");
		return false;	
	}
	return true;
}

/// 验证病人是否允许开医嘱
function GetPatNotTakOrdMsg(){

	var NotTakOrdMsg = "";
	/// 验证病人是否允许开医嘱
	runClassMethod("web.DHCEMConsultCom","GetPatNotTakOrdMsg",{"LgGroupID":LgGroupID,"LgUserID":LgUserID,"LgLocID":LgLocID,"EpisodeID":EpisodeID},function(jsonString){ //hxy 2020-08-05 原：web.DHCAPPExaReport

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
		$.messager.alert("提示","没有待保存数据！","warning");
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
		border:true,
		closed:"true"
	};
	new WindowUX('选择', 'symwin', '260', '130', option).Init();
}

/// 保存主诉科室模板   qiaoqingao  2018/08/20
function saveSymLoc(){
	
	var ConsOpinion=$("#ConsOpinion").val();  // 信息
	var Params=ConsOpinion+"^"+session['LOGON.CTLOCID']+"^"
	
	runClassMethod("web.DHCEMConsult","SaveCOT",{"Params":Params},function(jsonString){
		if (jsonString==0){
			$.messager.alert("提示","保存成功！","info");
		}if (jsonString=="-1"){
			$.messager.alert("提示","数据已存在！","warning");
		}
	},'',false)
}

/// 保存主诉科室模板   qiaoqingao  2018/08/20
function saveSymUser(){
	
	var ConsOpinion=$("#ConsOpinion").val();  // 信息
	var Params=ConsOpinion+"^^"+session['LOGON.USERID']

	runClassMethod("web.DHCEMConsult","SaveCOT",{"Params":Params},function(jsonString){
		if (jsonString==0){
			$.messager.alert("提示","保存成功！","info");
		}if (jsonString=="-1"){
			$.messager.alert("提示","数据已存在！","warning");
		}
	},'',false)
}

///保存检查目的模板    qiaoqingao  2018/08/20
function showmodel(flag){
		
	if($('#winonline').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="winonline"></div>');
	$('#winonline').window({
		title:'模板列表',
		collapsible:true,
		border:false,
		closed:"true",
		width:800,
		height:500
	});
	var link="dhcem.consultcottemp.csp"; //hxy 2023-02-11 Token改造 st
	if ('undefined'!==typeof websys_getMWToken){
		link += "&MWToken="+websys_getMWToken();
	}
	var cot = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src='+link+'></iframe>'; //ed
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
	
	if((CsStatCode=="")||(CsStatCode=="发送")||(CsStatCode.indexOf("审核")!=-1)||(CsStatCode=="驳回")||(CsStatCode=="拒绝")||(CsStatCode=="接收")||(CsStatCode=="取消接收")||(CsStatCode=="到达")||(CsStatCode=="取消完成")){
		if(ConsNoCompCanPrt==1){
			$.messager.alert("提示","会诊未完成,不能打印！","warning");
			return;
		}
	}
	
	var cstType=$("#CstType").combobox("getText");
	
	if((CstMorFlag=="Y")&&(parent.$("button:contains('"+$g("申请列表")+"')").hasClass("btn-blue-select"))){ //hxy 2021-03-16 st
		CstItmID="";
	} //ed
	
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
		var lnk="dhcem.printconsone.csp?CstItmIDs="+txtData+"&CsType=Nur"+"&LgHospID="+LgHospID;//hxy 2023-02-11 Token改造 st
		if ('undefined'!==typeof websys_getMWToken){
			lnk += "&MWToken="+websys_getMWToken();
		}
		window.open(lnk); //hxy 2021-03-17 add LgHospID //ed
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

/// 弹出诊断窗口
function DiagPopWin(){
	
	var lnk = "diagnosentry.v8.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm;
	//window.open(lnk,"_blank","top=100,left=100,width=700,height=350,menubar=yes,scrollbars=no,toolbar=no,status=no");
	window.showModalDialog(lnk, "_blank", "dialogHeight: " + (top.screen.height - 100) + "px; dialogWidth: " + (top.screen.width - 100) + "px");
}

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
		$.messager.alert("提示","会诊性质为空，请在基础配置中维护！","warning");
		return;
	}
	var itemhtmlArr = [];
	for (var j=0; j<itmArr.length; j++){
		var EmFlag = itmArr[j].itmDesc.indexOf("急") != -1?"Y":"N";
		itemhtmlArr.push("<input id='"+ itmArr[j].itmID +"' class='hisui-radio' type='radio' label='"+ itmArr[j].itmDesc +"' value='"+ EmFlag +"' name='CstEmFlag'>");
	}
    $("#itemProp").html(itemhtmlArr.join(""));
    $HUI.radio("#itemProp input.hisui-radio",{});
}

/// 护理病历
function nuremr_click(){
	
	if (EpisodeID == ""){
		$.messager.alert("提示","请先选择病人！","warning");
		return;
	}
	
	/// 新版
	var link = "nur.hisui.nursingrecords.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm +"&WardID=";
	if ('undefined'!==typeof websys_getMWToken){ //hxy 2023-02-11 Token改造
		link += "&MWToken="+websys_getMWToken();
	}
	window.open(link, 'newWin', 'height='+ (window.screen.availHeight-100) +', width='+ (window.screen.availWidth-100) +', top=50, left=50, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');

}


function RemoveCstNo(){
	if (CstID == ""){
		$.messager.alert("提示","请先选择会诊申请，再进行此操作！","warning");
		return;
	}
	
	$.messager.confirm('确认对话框','您确定要删除当前会诊申请吗？', function(r){
		if (r){
			runClassMethod("web.DHCEMConsult","RemoveCstNo",{"CstID":CstID},function(jsonObject){

				if (jsonObject.ErrCode == -1){
					$.messager.alert("提示","申请单当前状态，不允许进行取消操作！","warning");
					return;
				}
				if (jsonObject.ErrCode < 0){
					$.messager.alert("提示","会诊申请删除失败，失败原因:"+jsonObject.ErrMsg,"warning");
				}else{
					$.messager.alert("提示","删除成功！","info",function(){
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

///是否允许修改会诊科室
function isCanUpdConsLoc(){
	var ret=true;
	var grpID =$HUI.combobox("#CstGrp").getValue();
	if((grpID!="")&&(GrpAllowUpd!=1)) ret=false;
	if (isEditFlag==1) ret=false;
	return ret;
}

///hxy 2021-04-02 到达按钮不可用时，到达日期时间不可编辑
function ArrTimeDisOrEnByBtn(){
	/// 会诊到达时间 hxy 2021-04-01 st
	var RListFlag="N"; //申请列表标志
	if(parent.$("button:contains('"+$g("申请列表")+"')").hasClass("btn-blue-select"))RListFlag="Y";
	if(((ModArrTime==3)||((ModArrTime==1)&&(RListFlag=="Y"))||((ModArrTime==2)&&(RListFlag=="N")))&&((!$('#bt_arr').linkbutton('options').disabled)&&$("#bt_arr").is(":visible"))){
		$HUI.datebox("#CstArrDate").enable(); 
		$HUI.timespinner("#CstArrTime").enable();
	}else{
		$HUI.datebox("#CstArrDate").disable(); 
		$HUI.timespinner("#CstArrTime").disable();
	} //ed
}

window.onload = onload_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
