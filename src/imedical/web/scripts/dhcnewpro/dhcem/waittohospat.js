//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2018-10-26
// 描述:	   急诊待入院管理
//===========================================================================================

var WtID = "";         /// 待入院管理ID
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var ItemTypeArr = [{"value":"N","text":$g('未会诊')}, {"value":"A","text":$g('同意')}, {"value":"W","text":$g('待定')}, {"value":"M","text":$g('多科会诊决定')}];;
var ResTypeArr = [{"value":"1","text":$g('有创')}, {"value":"2","text":$g('无创')}, {"value":"3","text":$g('鼻导管')}, {"value":"4","text":$g('无')}];;

/// 页面初始化函数
function initPageDefault(){
	
	/// 初始化加载病人列表
	InitPatList();
	
	/// 初始化病人基本信息
	InitPatInfoPanel();
}

/// 初始化病人基本信息
function InitPatInfoPanel(){
	
	/// 开始日期
	$HUI.datebox("#StartDate").setValue(GetCurSystemDate(-1));
	/// 结束日期
	$HUI.datebox("#EndDate").setValue(GetCurSystemDate(0));
	
	/// 登记科室
	$HUI.combobox("#RLoc",{
		url:$URL+"?ClassName=web.DHCEMWaitToHosPat&MethodName=JsonLoc&HospID="+LgHospID + "&Type=E",
		//url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocList&LType=EMLOC&LocID=&HospID="+LgHospID,
		valueField:'value',
		textField:'text',
		mode:'remote',
		onSelect:function(option){
	        //QryEmPatList();
	    }	
	})
	
	/// 病人状态
	$HUI.combobox("#WalkStatus",{
		url:$URL+"?ClassName=web.DHCEMVisitStat&MethodName=GetUserAccessStatAll",
		//url:$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonCstType&HospID=" + LgHospID +"&LgUserID="+LgUserID,
		valueField:'id',
		textField:'text',
		onSelect:function(option){
	        //QryEmPatList();
	    }	
	})
	
	/// 分诊级别
	$HUI.combobox("#aEmPcLv",{
		data:[
			{"value":"1","text":$g("Ⅰ级")},
			{"value":"2","text":$g("Ⅱ级")},
			{"value":"3","text":$g("Ⅲ级")},
			{"value":"4","text":$g("Ⅳa级")},
			{"value":"5","text":$g("Ⅳb级")} //hxy 2020-02-20
		],
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        //QryEmPatList();
	    }	
	})
	
	/// 删除理由
	$HUI.combobox("#DelReason",{
		url:$URL+"?ClassName=web.DHCEMConsDicItem&MethodName=jsonConsItem&mCode=WDR&HospID="+LgHospID,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        //QryEmPatList();
	    }	
	})
	
	//拟入院科室1
 	$HUI.combobox("#InLoc_1",{
		url:$URL+"?ClassName=web.DHCEMWaitToHosPat&MethodName=JsonLoc&HospID="+LgHospID+"&Type=I",
		valueField:'value',
		textField:'text',
		mode:'remote',
		onSelect:function(option){
	        jsonWard1(option.value)
	    },
		onShowPanel:function(){
        	$(this).combobox('reload');
        }	
	}) 
	
	//拟入院科室2
	$HUI.combobox("#InLoc_2",{
		url:$URL+"?ClassName=web.DHCEMWaitToHosPat&MethodName=JsonLoc&HospID="+LgHospID+"&Type=I",
		valueField:'value',
		textField:'text',
		mode:'remote',
		onSelect:function(option){
	       jsonWard2(option.value)
	    },
		onShowPanel:function(){
        	$(this).combobox('reload');
        }	
	})
	
	//拟入院科室3
	$HUI.combobox("#InLoc_3",{
		url:$URL+"?ClassName=web.DHCEMWaitToHosPat&MethodName=JsonLoc&HospID="+LgHospID+"&Type=I",
		valueField:'value',
		textField:'text',
		mode:'remote',
		onSelect:function(option){
	        jsonWard3(option.value)
	    },
		onShowPanel:function(){
        	$(this).combobox('reload');
        }	
	})
	
/* 	/// 拟入院科室
	var option = {
		//panelHeight:"auto",
        onSelect:function(option){	        
	    }
	};
	var url = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+LgHospID;
	for (var i=1; i<=11; i++){
		new ListCombobox("InLoc_"+i,url,"",option).init();
	}
	 */
	

	/// 会诊结果
	var option = {
		panelHeight:"auto",
        onSelect:function(option){
	    }
	};
	var url = "";
	for (var i=1; i<=11; i++){
		new ListCombobox("CsRes_"+i,url,ItemTypeArr,option).init();
	}
	
	/// 呼吸类型
	var optionRes = {
		panelHeight:"auto",
        onSelect:function(option){
	    }
	};
	var url = "";
	new ListCombobox("ResType",url,ResTypeArr,optionRes).init();
	
	

	/// 登记号
	$("#PatNo").bind('keypress',PatNo_KeyPress);
	$("#aPatNo").bind('keypress',PatNo_KeyPress_CD);
	var InLoc_1 = $HUI.combobox("#InLoc_1").getValue();
	var InLoc_2 = $HUI.combobox("#InLoc_2").getValue();
	var InLoc_3 = $HUI.combobox("#InLoc_3").getValue();
	jsonWard1(InLoc_1)
	jsonWard2(InLoc_2)
	jsonWard3(InLoc_3)
	
}
//获取病区1
function jsonWard1(LocID){
		
	$HUI.combobox("#InWard_1",{
		url:$URL+"?ClassName=web.DHCEMInComUseMethod&MethodName=JsonWard&LocID="+LocID,
		valueField:'value',
		textField:'text',	
	})
}


//获取病区2
function jsonWard2(LocID){	
	$HUI.combobox("#InWard_2",{
		url:$URL+"?ClassName=web.DHCEMInComUseMethod&MethodName=JsonWard&LocID="+LocID,
		valueField:'value',
		textField:'text',	
	})
}

//获取病区3
function jsonWard3(LocID){	
	$HUI.combobox("#InWard_3",{
		url:$URL+"?ClassName=web.DHCEMInComUseMethod&MethodName=JsonWard&LocID="+LocID,
		valueField:'value',
		textField:'text',	
	})
}

/// 页面DataGrid初始定义已选列表
function InitPatList(){
	
	///  定义columns
	var columns=[[
	    {field:"ck",checkbox:true,width:20}, 
		{field:'WtID',title:'WtID',width:100,hidden:true},
		{field:'EmNurLev',title:'初始分级',width:80,align:'center',formatter:setCellLevLabel},
		{field:'EmCurLev',title:'当前分级',width:80,align:'center',formatter:setCellLevLabel},
		{field:'PatWard',title:'病区',width:160},
		{field:'PatBed',title:'床号',width:60,align:'center'},
		{field:'PatName',title:'姓名',width:80,align:'center'},
		{field:'PatNo',title:'登记号',width:100,align:'center'},
		{field:'PatSex',title:'性别',width:50,align:'center'}, 
		{field:'PatAge',title:'年龄',width:60,align:'center'},
		{field:'LvDate',title:'来诊时间',width:140,align:'center'},
		{field:'StrTime',title:'就诊天数',width:80,align:'center'},
		{field:'PatDiag',title:'诊断',width:160},
		{field:'InLoc_1',title:'拟入院科室1',width:160},
		{field:'InWard_1',title:'拟入院病区1',width:160},
		{field:'CsRes_1',title:'会诊结果1',width:100,formatter:
			function (value, row, index){
//				if (value == "同意"){return '<font style="color:red;font-weight:bold;">'+value+'</font>'}
				if (value == "A"){return '<font style="color:red;font-weight:bold;">'+$g("同意")+'</font>'}
				else {
					if(value=="N"){
						value=$g("未会诊");
					}else if(value=="W"){
						value=$g("待定");
					}else if(value=="M"){
						value=$g("多科会诊决定");
					}
					return '<font style="color:green;font-weight:bold;">'+value+'</font>'
				}
			}
		},
		//{field:'PatWard',title:'病区',width:150},
		{field:'InLoc_2',title:'拟入院科室2',width:160},
		{field:'InWard_2',title:'拟入院病区2',width:160},
		{field:'CsRes_2',title:'会诊结果2',width:100,formatter:
			function (value, row, index){
//				if (value == "同意"){return '<font style="color:red;font-weight:bold;">'+value+'</font>'}
				if (value == "A"){return '<font style="color:red;font-weight:bold;">'+$g("同意")+'</font>'}
				else {
					if(value=="N"){
						value=$g("未会诊");
					}else if(value=="W"){
						value=$g("待定");
					}else if(value=="M"){
						value=$g("多科会诊决定");
					}
					return '<font style="color:green;font-weight:bold;">'+value+'</font>'
				}
			}
		},	
		{field:'InLoc_3',title:'拟入院科室3',width:160},
		{field:'InWard_3',title:'拟入院病区3',width:160},
		{field:'CsRes_3',title:'会诊结果3',width:100,formatter:
			function (value, row, index){
//				if (value == "同意"){return '<font style="color:red;font-weight:bold;">'+value+'</font>'}
				if (value == "A"){return '<font style="color:red;font-weight:bold;">'+$g("同意")+'</font>'}
				else {
					if(value=="N"){
						value=$g("未会诊");
					}else if(value=="W"){
						value=$g("待定");
					}else if(value=="M"){
						value=$g("多科会诊决定");
					}
					return '<font style="color:green;font-weight:bold;">'+value+'</font>'
				}
			}
		},
		{field:'ResType',title:'呼吸机',width:60,formatter:setResType},
		{field:'PatDoc',title:'医疗组长',width:100,align:'center'},
		{field:'PatLoc',title:'就诊科室',width:120,hidden:true},
		{field:'RLocDesc',title:'登记科室',width:120,hidden:false},
		{field:'RDate',title:'登记日期',width:100,align:'center'},
		{field:'RTime',title:'登记时间',width:80,align:'center'},
		{field:'AdmDays',title:'就诊天数',width:80,align:'center',hidden:true},
		{field:'PatStatus',title:'病人状态',width:100,align:'center',hidden:true},
		{field:'EpisodeID',title:'EpisodeID',width:100,align:'center'}
	]];
	
	///  定义datagrid
	var option = {
		//fitColumns:true,
		//showHeader:false,
		toolbar:"#toolbar",
		rownumbers : true,
		singleSelect:false,
		pagination: true,
		border:false,
		pageSize:200,  // 每页显示的记录条数
		pageList:[200,500],   // 可以设置每页记录条数的列表
		onLoadSuccess:function(data){

		},
		onDblClickRow: function (rowIndex, rowData) {
			//updWaitToHos();
        },
        rowStyler:function(rowIndex, rowData){
			if (rowData.AuditFlag == $g("已审")){
				return 'background-color:pink;';
			}
		}
	};
	/// 就诊类型
	var param = "^^^^^^^"+ LgHospID;
	var uniturl = $URL+"?ClassName=web.DHCEMWaitToHosPat&MethodName=JsGetWaitToHosPatList&Params="+param;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// 分级
function setCellLevLabel(value, rowData, rowIndex){
	var fontColor = "";
	if (value == "1级"){ fontColor = "#F16E57";} //hxy 2020-02-20 原：((value == "1级")||(value == "2级"))
	if (value == "2级"){ fontColor = "orange";} //hxy 2020-02-20 add
	if (value == "3级"){ fontColor = "#FFB746";}
	if ((value == "4级")||(value == "5级")){ fontColor = "#2AB66A";} ////hxy 2020-02-20 原：(value == "4级")
	value=setCellLabel(value) //hxy 2020-02-20
	return '<a href="javascript:void(0);" onclick="showEmPcLvWin('+ rowData.EpisodeID +')">'+ "<font color='" + fontColor + "'>"+value+"</font>" +'</a>';
	//return "<font color='" + fontColor + "'>"+value+"</font>";
}

/// 显示病人分诊信息
function showEmPcLvWin(EpisodeID){
	var linkurl="dhcem.emerpatientinfom.csp?EpisodeID="+EpisodeID;
	if ('undefined'!==typeof websys_getMWToken){
		linkurl += "&MWToken="+websys_getMWToken();
	}
	window.open(linkurl,"_blank","height=700,width=1200,top=100,left=100,resizable=yes");
}

/// 登记号
function PatNo_KeyPress_CD(e){
	
	if(e.keyCode == 13){
		var PatNo = $("#aPatNo").val();
		if (!PatNo.replace(/[\d]/gi,"")&(PatNo != "")){
			///  登记号补0
			var PatNo = GetWholePatNo(PatNo);
			$("#aPatNo").val(PatNo);
			QryWaitHosPat();  /// 查询
		}
	}
}

/// 登记号
function PatNo_KeyPress(e){
	
	if(e.keyCode == 13){
		var PatNo = $("#PatNo").val();
		InitWaitWinDefault();   /// 清空页面
		if (!PatNo.replace(/[\d]/gi,"")&(PatNo != "")){
			///  登记号补0
			var PatNo = GetWholePatNo(PatNo);
			$("#PatNo").val(PatNo);
			GetPatBaseInfo(PatNo);  /// 查询
		}
	}
}

/// 查询
function QryWaitHosPat(){
	
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// 开始日期
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// 结束日期
	var RLocID = $HUI.combobox("#RLoc").getValue();        /// 申请科室
	if (typeof RLocID == "undefined") RLocID = "";
	var aPatName = $("#aPatName").val();   /// 病人姓名
	var aPatNo = $("#aPatNo").val();       /// 登记号
	var aEmPcLv = $HUI.combobox("#aEmPcLv").getValue();    /// 当前级别
	if (typeof aEmPcLv == "undefined") aEmPcLv = "";
	var WalkStatus = $HUI.combobox("#WalkStatus").getValue(); /// 病人状态
	if (typeof WalkStatus == "undefined") WalkStatus = "";
	
	var params = StartDate +"^"+ EndDate +"^"+ RLocID +"^"+ aPatName +"^"+ aPatNo +"^"+ aEmPcLv +"^"+ WalkStatus+"^"+LgHospID; //hxy 2020-06-03 LgHospID
	$("#bmDetList").datagrid("load",{"Params":params}); 
	$("#bmDetList").datagrid("unselectAll");
}

/// 修改
function updWaitToHos(){
	
	var rowsData = $("#bmDetList").datagrid('getSelections'); //选中要删除的行

	if (rowsData.length != 1){
		$.messager.alert("提示:","修改操作,请只选择一行数据！");
		return;
	}

	if (rowsData != null) {
		GetWaitHosPatInfo(rowsData[0].WtID);
		$("#PatNo").attr("disabled",true)
		newWaitHosPatWin($g("修改"));        /// 新建窗口
	}else{
		$.messager.alert("提示:","请先选中待处理行！","warning");
	}
}

/// 提取待入院信息
function GetWaitHosPatInfo(WtID){
	
	runClassMethod("web.DHCEMWaitToHosPat","GetWaitHosPatInfo",{"WtID":WtID},function(jsonString){
		var jsonObject = jsonString;
		if (jsonObject != null){
			$('.textbox').each(function(){
				console.log($(this).hasClass("hisui-combobox"));
				$(this).val(jsonObject[this.id]);
			})
			$HUI.combobox("#InLoc_1").setValue(jsonObject["InLoc_1"]);   /// 拟入院科室
			$HUI.combobox("#CsRes_1").setValue(jsonObject["CsRes_1"]);   /// 会诊情况
			jsonWard1(jsonObject["InLoc_1"])                             /// 加载关联病区
			$HUI.combobox("#InWard_1").setValue(jsonObject["InWard_1"]); /// 拟入院病区
			$HUI.combobox("#InWard_1").setText(jsonObject["Ward_1"]);   /// 拟入院病区
			$HUI.combobox("#InLoc_2").setValue(jsonObject["InLoc_2"]);   /// 拟入院科室
			$HUI.combobox("#CsRes_2").setValue(jsonObject["CsRes_2"]);   /// 会诊情况
			jsonWard2(jsonObject["InLoc_2"])                             /// 加载关联病区
			$HUI.combobox("#InWard_2").setValue(jsonObject["InWard_2"]); /// 拟入院病区
			$HUI.combobox("#InWard_2").setText(jsonObject["Ward_2"]);    /// 拟入院病区
			$HUI.combobox("#InLoc_3").setValue(jsonObject["InLoc_3"]);   /// 拟入院科室
			$HUI.combobox("#CsRes_3").setValue(jsonObject["CsRes_3"]);   /// 会诊情况
			jsonWard3(jsonObject["InLoc_3"])                             /// 加载关联病区
			$HUI.combobox("#InWard_3").setValue(jsonObject["InWard_3"]); /// 拟入院病区
			$HUI.combobox("#InWard_3").setText(jsonObject["Ward_3"]);    /// 拟入院病区
			$HUI.combobox("#ResType").setValue(jsonObject["ResType"]);   /// 呼吸类型
		}
	},'json',false)
}

/// 删除
function delWaitToHos(){
	
	var mRemark = $HUI.combobox("#DelReason").getText();  /// 删除理由
	if (mRemark == "") {
		$.messager.alert("提示:","请先选择删除理由！","warning");
		return;
	}
	
	var rowsData = $("#bmDetList").datagrid('getSelections'); /// 选中要删除的行
	if (rowsData.length == 0){
		$.messager.alert("提示","请选择需要删除的记录!","warning");
		return;
	}
	
	$.messager.confirm('确认对话框',"你确定要删除吗？", function(r){
	    if (r){
		    for (var i=0; i<rowsData.length; i++){
				delWait(rowsData[i].WtID, mRemark);
		    }
			$("#bmDetList").datagrid("reload");
			$.messager.alert("提示:","删除成功！","info");
		}
	});
	
}

/// 删除
function delWait(WtID, mRemark){
	
	/// 保存
	runClassMethod("web.DHCEMWaitToHosPat","delWaitToHos",{"WtID":WtID, "mRemark":mRemark},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示:","删除失败，失败原因！"+jsonString,"warning");
			return;
		}
/* 		if (jsonString == 0){
			$.messager.alert("提示:","操作成功！","info");
			$("#bmDetList").datagrid("reload");
		} */
		
	},'',false)
}

/// 新建
function newWaitHosPat(){
	$("#PatNo").attr("disabled",false)
	newWaitHosPatWin($g("新建"));        /// 新建窗口
	InitWaitWinDefault();      /// 初始化界面默认信息
}

/// 新建窗口
function newWaitHosPatWin(titleDesc){
	var option = {
			iconCls:'icon-w-paper',
			buttons:[{
				text:$g('保存'),
				iconCls:'icon-w-save',
				handler:function(){
					saveWaitToHos();
				}
			},{
				text:$g('取消'),
				iconCls:'icon-w-cancel',
				handler:function(){
					$('#newConWin').dialog('close');
				}
			}]
		};
	new DialogUX(titleDesc, 'newConWin', '869', '477', option).Init();

}

/// 初始化界面默认信息
function InitWaitWinDefault(){

	$(".textbox").val("");
	
	$HUI.combobox("#ResType").setValue(""); /// 呼吸类型
	
	$HUI.combobox("#InLoc_1").setValue(""); /// 拟入院科室1
	$HUI.combobox("#InWard_1").setValue(""); /// 拟入院科室1
	$HUI.combobox("#CsRes_1").setValue(""); /// 会诊结果1
	$HUI.combobox("#InWard_1").disable();
	
	$HUI.combobox("#InLoc_2").setValue(""); /// 拟入院科室2
	$HUI.combobox("#InWard_2").setValue(""); /// 拟入院科室2
	$HUI.combobox("#CsRes_2").setValue(""); /// 会诊结果2
	$HUI.combobox("#InWard_2").disable();
	
	$HUI.combobox("#InLoc_3").setValue(""); /// 拟入院科室3
	$HUI.combobox("#InWard_3").setValue(""); /// 拟入院科室3
	$HUI.combobox("#CsRes_3").setValue(""); /// 会诊结果3
	$HUI.combobox("#InWard_3").disable();
}

/// 急诊待入院管理
function saveWaitToHos(){

    /// 待入院记录ID
	var WtID=$('#WtID').val();
    /// 就诊ID
	var EpisodeID=$('#EpisodeID').val();
	if (EpisodeID == ""){
		$.messager.alert("提示:","患者信息为空，不能保存！","warning");
		return;	
	}
	
	/// 待入院科室信息
	var WtLocArr=[];
	var InLoc_1 = $HUI.combobox("#InLoc_1").getValue();   /// 拟入院科室1
	var InWard_1 = $HUI.combobox("#InWard_1").getValue(); /// 拟入院病区1
	var CsRes_1 = $HUI.combobox("#CsRes_1").getValue();   /// 会诊结果1
	if ((InLoc_1 == "")||(InLoc_1 == undefined)){
		$.messager.alert("提示:","拟入院科室1不能为空！","warning");
		return;	
	}
	if ((CsRes_1 == "")||(CsRes_1 == undefined)){
		$.messager.alert("提示:","会诊结果1不能为空！","warning");
		return;	
	}

    WtLocArr.push(InLoc_1 +"^"+ CsRes_1+"^"+InWard_1);
    
	var InLoc_2 = $HUI.combobox("#InLoc_2").getValue();   /// 拟入院科室2
	var InWard_2 = $HUI.combobox("#InWard_2").getValue(); /// 拟入院病区2
	if(InLoc_2 == undefined){InLoc_2 = "";}
	var CsRes_2 = $HUI.combobox("#CsRes_2").getValue();   /// 会诊结果2
	if(CsRes_2 == undefined){CsRes_2 = "";}
	if ((CsRes_2 != "")&(CsRes_2 != undefined)&((InLoc_2||"") == "")){
		$.messager.alert("提示:","拟入院科室2不能为空！","warning");
		return;	
	}
	if((InLoc_2!="")&&(InLoc_1==InLoc_2)&&(InWard_1==InWard_2)){
		$.messager.alert("提示:","拟入院1与拟入院2科室和病区均相同！","warning");
		return;
	}
	WtLocArr.push(InLoc_2 +"^"+ CsRes_2+"^"+InWard_2);
	
	var InLoc_3 = $HUI.combobox("#InLoc_3").getValue();   /// 拟入院科室3
	var InWard_3 = $HUI.combobox("#InWard_3").getValue(); /// 拟入院病区3
	if(InLoc_3 == undefined){InLoc_3 = "";}
	var CsRes_3 = $HUI.combobox("#CsRes_3").getValue();   /// 会诊结果3
	if(CsRes_3 == undefined){CsRes_3 = "";}
	if ((CsRes_3 != "")&(CsRes_3 != undefined)&((InLoc_3||"") == "")){
		$.messager.alert("提示:","拟入院科室3不能为空！","warning");
		return;	
	}
	if((InLoc_3!="")&&(InLoc_2==InLoc_3)&&(InWard_2==InWard_3)){
		$.messager.alert("提示:","拟入院2与拟入院3科室和病区均相同！","warning");
		return;
	}
	if((InLoc_3!="")&&(InLoc_1==InLoc_3)&&(InWard_1==InWard_3)){
		$.messager.alert("提示:","拟入院1与拟入院3科室和病区均相同！","warning");
		return;
	}
	WtLocArr.push(InLoc_3 +"^"+ CsRes_3+"^"+InWard_3);
	
	var WtLocList = WtLocArr.join("@");
	if (WtLocArr.join("") == ""){
		$.messager.alert("提示:","拟入院科室不能为空！","warning");
		return;	
	}
	var ResType = $HUI.combobox("#ResType").getValue();   /// 呼吸类型

	///             主信息 # 拟入院科室列表
	var mListData = EpisodeID +"^"+ LgUserID +"^"+ LgLocID +"^"+ ResType+"^"+"#"+ WtLocList;

	/// 保存
	runClassMethod("web.DHCEMWaitToHosPat","Insert",{"WtID":WtID, "mListData":mListData},function(jsonString){

		if (jsonString < 0){
			$.messager.alert("提示:","保存失败，失败原因:"+jsonString,"warning");
		}else{
			$('#newConWin').dialog('close');
			$("#bmDetList").datagrid("reload");
		}
	},'',false)
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

/// 病人就诊信息
function GetPatBaseInfo(PatNo){

	runClassMethod("web.DHCEMWaitToHosPat","GetPatBaseInfo",{"PatientNo":PatNo,"LgHospID":LgHospID},function(jsonString){ //hxy 2020-06-02 LgHospID
		var jsonObject = jsonString;
		if (typeof jsonObject.ErrCode != "undefined"){
			$.messager.alert('错误提示',jsonObject.ErrMsg +"，请核实后重试！");
			return;	
		}
		if (JSON.stringify(jsonObject) != '{}'){
			$('.textbox').each(function(){
				$(this).val(formatHtmlToValue(jsonObject[this.id]));
			})
		}else{
			$.messager.alert('错误提示',"病人信息不存在或病人非留观病人，请核实后重试！");
			return;	
		}
	},'json',false)
}

/// 修改分级
function ModPatChkLev(){
	
	var rowsData = $("#bmDetList").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		var rows = $('#bmDetList').datagrid('getSelections');
		if(rows.length>1){
			$.messager.alert("提示:","请选择一条数据！","warning");
			return;
		}
		var linkurl="dhcem.empatchecklev.csp?EpisodeID="+rowsData.EpisodeID;
		if ('undefined'!==typeof websys_getMWToken){
			linkurl += "&MWToken="+websys_getMWToken();
		}
		window.open(linkurl,"","left=560px,top=140px,width=318px,height=550px"); 
		$("#bmDetList").datagrid("reload"); 
	}else{
		$.messager.alert("提示:","请先选中待处理行！","warning");
	}
}

///查询
function parentFlash(){
	QryWaitHosPat();	
}

/// 当前病人是否存在申请记录
function isExistWaitToHos(EpisodeID){
	
	var isFlag = "Y";
	runClassMethod("web.DHCEMWaitToHosPat","isExistWaitToHos",{"EpisodeID":EpisodeID},function(jsonString){
		if (jsonString < 0){
			isFlag = jsonString;
		}
	},'',false)
	return isFlag;
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })



/// 导出
function ExpWaitToHos(){	
	var datas = $('#bmDetList').datagrid("getData");
	exportData(datas.rows)
}

function exportData(datas){
	var Str = "(function test(x){"+
	"var xlApp = new ActiveXObject('Excel.Application');"+
	"var xlBook = xlApp.Workbooks.Add('');"+
	"var objSheet = xlBook.ActiveSheet;"+
	"objSheet.Cells(1,1).value='病区';"+	 //病区
	"objSheet.Cells(1,2).value='床位';"+        //床位
	"objSheet.Cells(1,3).value='姓名';"+        //姓名
	"objSheet.Cells(1,4).value='登记号';"+	     //登记号
	"objSheet.Cells(1,5).value='性别';"+ 	     //性别
	"objSheet.Cells(1,6).value='年龄';"+ 	     //年龄
	"objSheet.Cells(1,7).value='来诊时间';"+	 //来诊日期
	"objSheet.Cells(1,8).value='就诊天数';"+     //等待时间
	"objSheet.Cells(1,9).value='诊断';"+	     //诊断
	"objSheet.Cells(1,10).value='拟入院科室1';"+ //拟入院科室1
	"objSheet.Cells(1,11).value='会诊结果1';"+	 //会诊结果1
	"objSheet.Cells(1,12).value='拟入院病区1';"+  //拟入院病区1
	"objSheet.Cells(1,13).value='拟入院科室2';"+//拟入院科室2	
	"objSheet.Cells(1,14).value='会诊结果2';"+	 //会诊结果2
	"objSheet.Cells(1,15).value='拟入院病区2';"+ //拟入院病区2
	"objSheet.Cells(1,16).value='拟入院科室3';"+//拟入院科室3
	"objSheet.Cells(1,17).value='会诊结果3';"+	 //会诊结果3
	"objSheet.Cells(1,18).value='拟入院病区3';"+ //拟入院病区3
	"objSheet.Cells(1,19).value='呼吸机';"+	 //呼吸机	
	"objSheet.Cells(1,20).value='医疗组长';"+	 //医疗组长
	"objSheet.Cells(1,21).value='当前分级';"+	 //当前分级
	"objSheet.Cells(1,22).value='初始分级';";	 //初始分级
	//"objSheet.Cells(1,20).value='就诊科室';"+	 //就诊科室
	//"objSheet.Cells(1,21).value='登记日期';"+	 //登记日期	
	//"objSheet.Cells(1,22).value='登记时间';"+	 //登记时间
	//"objSheet.Cells(1,23).value='就诊天数';"+	 //就诊天数
	//"objSheet.Cells(1,24).value='病人状态';"+	 //病人状态	
	
	for (var i=0;i<datas.length;i++){
		var CsRes_1=setCsRes(datas[i].CsRes_1);
		var CsRes_2=setCsRes(datas[i].CsRes_2);
		var CsRes_3=setCsRes(datas[i].CsRes_3);
		var ResType=setResType(datas[i].ResType);
		Str=Str+"objSheet.Cells("+(i+2)+","+1+").value='"+datas[i].PatWard+"';"+ //病区
		"objSheet.Cells("+(i+2)+","+2+").value='"+datas[i].PatBed+"';"+     //床号
		"objSheet.Cells("+(i+2)+","+3+").value='"+datas[i].PatName+"';"+    //姓名
		"objSheet.Cells("+(i+2)+","+4+").value='"+datas[i].PatNo+"';"+	 //登记号
		"objSheet.Cells("+(i+2)+","+5+").value='"+datas[i].PatSex+"';"+     //性别
		"objSheet.Cells("+(i+2)+","+6+").value='"+datas[i].PatAge+"';"+	 //年龄
		"objSheet.Cells("+(i+2)+","+7+").value='"+datas[i].LvDate+"';"+	 //来诊时间
		"objSheet.Cells("+(i+2)+","+8+").value='"+datas[i].StrTime+"';"+	 //等待时间
		"objSheet.Cells("+(i+2)+","+9+").value='"+datas[i].PatDiag+"';"+	 //诊断
		"objSheet.Cells("+(i+2)+","+10+").value='"+datas[i].InLoc_1+"';"+	 //拟入院科室1	
		"objSheet.Cells("+(i+2)+","+11+").value='"+CsRes_1+"';"+	 //会诊结果1
		"objSheet.Cells("+(i+2)+","+12+").value='"+datas[i].InWard_1+"';"+	 //拟入院病区1		
		"objSheet.Cells("+(i+2)+","+13+").value='"+datas[i].InLoc_2+"';"+	 //拟入院科室2
		"objSheet.Cells("+(i+2)+","+14+").value='"+CsRes_2+"';"+	 //会诊结果2
		"objSheet.Cells("+(i+2)+","+15+").value='"+datas[i].InWard_2+"';"+	 //拟入院病区1		
		"objSheet.Cells("+(i+2)+","+16+").value='"+datas[i].InLoc_3+"';"+	 //拟入院科室3
		"objSheet.Cells("+(i+2)+","+17+").value='"+CsRes_3+"';"+	 //会诊结果3
		"objSheet.Cells("+(i+2)+","+18+").value='"+datas[i].InWard_3+"';"+	 //拟入院病区1		
		"objSheet.Cells("+(i+2)+","+19+").value='"+ResType+"';"+   //呼吸机	
		"objSheet.Cells("+(i+2)+","+20+").value='"+datas[i].PatDoc+"';"+	 //医疗组长
		"objSheet.Cells("+(i+2)+","+21+").value='"+datas[i].EmCurLev+"';"+	 //当前分级
		"objSheet.Cells("+(i+2)+","+22+").value='"+datas[i].EmNurLev+"';";	 //初始分级
		//objSheet.Cells(i+2,20).value=datas[i].PatLoc;	 //就诊科室
		//objSheet.Cells(i+2,21).value=datas[i].RDate;	 //登记日期
		//objSheet.Cells(i+2,22).value=datas[i].RTime;	 //登记时间
		//objSheet.Cells(i+2,23).value=datas[i].AdmDays;	 //就诊天数
		//objSheet.Cells(i+2,24).value=datas[i].PatStatus; //病人状态
	}
	
	var row1=1,row2=datas.length+1,c1=1,c2=22,setColWidth=false;
	for(var j=1;j<c2+1;j++){
		Str=Str+"objSheet.cells(1,"+j+").Font.Bold = true;"+
		"objSheet.cells(1,"+j+").Font.Size =11;"+
		"objSheet.cells(1,"+j+").HorizontalAlignment = -4108;"
		if((j>=10)&&(j<=18)){
			setColWidth=true;
		}
		j==1?setColWidth=true:"";
		setColWidth?Str=Str+"objSheet.cells(1,"+j+").ColumnWidth = 12;":"";	
	}
	
	Str=Str+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).LineStyle=1;"+ 
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).Weight=2;"+
	"xlApp.Visible=true;"+
	"xlApp=null;"+
	"xlBook=null;"+
	"objSheet=null;"+
    "return 1;}());";
    //以上为拼接Excel打印代码为字符串
    CmdShell.notReturn = 0;   //设置无结果调用，不阻塞调用
	var rtn = CmdShell.CurrentUserEvalJs(Str);   //通过中间件运行打印程序 
	return;	
}

function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).Weight=2

}

//hxy 2020-02-20
function setCellLabel(value){
	if(value=="1级"){value=$g("Ⅰ级");}
	if(value=="2级"){value=$g("Ⅱ级");}
	if(value=="3级"){value=$g("Ⅲ级");}
	if(value=="4级"){value=$g("Ⅳa级");}
	if(value=="5级"){value=$g("Ⅳb级");}
	return value;
}

//hxy 2023-01-17
function setResType(value){
	if(value=="1"){value=$g("有创");}
	if(value=="2"){value=$g("无创");}
	if(value=="3"){value=$g("鼻导管");}
	if(value=="4"){value=$g("无");}
	return value;
}

function setCsRes(value){
	if(value=="N"){
		value=$g("未会诊");
	}else if(value=="A"){
		value=$g("同意");
	}else if(value=="W"){
		value=$g("待定");
	}else if(value=="M"){
		value=$g("多科会诊决定");
	}
	return value;
}
