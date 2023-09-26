//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-04-19
// 描述:	   mdt会诊处理
//===========================================================================================
var mdtID = "";         /// 会诊申请ID
var editSelRow = -1;
var isEditFlag = 0;     /// 页面是否可编辑
var CstOutFlag = "N";   /// 院际会诊标志
var CsNoType = "";      /// 会诊单据类型 医生/护士/MDT
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var LODOP="";
var ItemTypeArr = [{"value":"N","text":$g("未收费")}, {"value":"Y","text":$g("已收费")}];
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
var del = String.fromCharCode(2);
var defaultCardTypeDr=""; /// 默认卡类型
var m_CCMRowID = "" ;
var m_CardNoLength = "";  /// 卡号长度
var selMdtMakResID = ""; /// 当前选中行资源ID

/// 页面初始化函数
function initPageDefault(){
	
	/// 初始化加载病人就诊ID
	InitPatEpisodeID();
	
	/// 初始化加载病人列表
	InitPatList();
	
	/// 初始化病人基本信息
	InitPatInfoPanel();
	
	/// 初始化默认卡类型
	initCardTypeCombobox();
	
	multi_Language();
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	
	CsNoType = getParam("CsType");  /// 会诊单据类型
}

/// 初始化病人基本信息
function InitPatInfoPanel(){
	
	/// 开始日期
	$HUI.datebox("#StartDate").setValue(GetCurSystemDate(-7));
	
	/// 结束日期
	$HUI.datebox("#EndDate").setValue(GetCurSystemDate(0));
	
	//卡类型
	$('#CardTypeDr').combobox({
		url:$URL+"?ClassName=web.DHCEMPatCheckLevCom&MethodName=CardTypeDefineListBroker",
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		onChange: function (n,o) {
			var CardTypeDefArr = n.split("^");
	        m_CardNoLength = CardTypeDefArr[17];   /// 卡号长度
			m_CCMRowID = CardTypeDefArr[14];
			$('#PatCardNo').val("");
	        if (CardTypeDefArr[16] == "Handle"){
		    	$('#PatCardNo').attr("readOnly",false);
		    }else{
				$('#PatCardNo').attr("readOnly",true);
			}

		}
	})
	
	/// 申请科室
	$HUI.combobox("#CstRLoc",{
		//url:$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonAllLoc&HospID="+LgHospID,
		url:$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonGrpLoc",
		valueField:'value',
		textField:'text',
		mode:'remote',
		onSelect:function(option){
	        //QryEmPatList();
	    }	
	})
	
	/// 会诊状态
	$HUI.combobox("#consStatus",{
		url:$URL+"?ClassName=web.DHCMDTCom&MethodName=GetListMdtStatus&HospID="+ LgHospID,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	      
	    }	
	})	
	
	/// 疑难病种
	$HUI.combobox("#mdtDisGrp",{
		url:$URL+"?ClassName=web.DHCMDTGroup&MethodName=jsonGroupAll&HospID="+LgHospID,
		valueField:'value',
		textField:'text',
		onSelect:function(option){

	    }	
	})
	/// 收费状态
	$HUI.combobox("#ChargeFlag",{
		url:'',
		data : ItemTypeArr,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	    }	
	})
	$HUI.combobox("#AuditFlag").setValue("N");
	
	/// 登记号
	$("#PatNo").bind('keypress',PatNo_KeyPress);
	
	///  卡号
	$('#PatCardNo').bind('keypress',PatCardNo_KeyPress);
	
}

/// 卡号回车
function PatCardNo_KeyPress(e){
	
	if(e.keyCode == 13){
		var CardNo = $("#PatCardNo").val();
		if (CardNo == ""){
			return;
		}
		var CardNoLen = CardNo.length;
		if ((CardNo == "")||(m_CardNoLength < CardNoLen)){
			$.messager.alert("提示:","卡号输入错误,请重新录入！");
			return;
		}

		/// 卡号不足位数时补0
		for (var k=1;k<=m_CardNoLength-CardNoLen;k++){
			CardNo="0"+CardNo;  
		}
		$("#PatCardNo").val(CardNo);

		///  根据卡号取登记号
		var EmPatNo = "";
		runClassMethod("web.DHCEMPatCheckLevCom","GetPmiNoFrCardNo",{"cardno":CardNo},function(jsonString){

			if (jsonString ==-1){
				$.messager.alert("提示:","当前卡无效,请重试！");
				return;

			}else{
				EmPatNo = jsonString;
			}
			
		},'text',false)
		if(EmPatNo == "") return;
		$("#PatNo").val(EmPatNo);		/// 登记号
		QryPatList();  /// 查询
	}
}

/// 页面DataGrid初始定义已选列表
function InitPatList(){
	///  定义columns
	var columns=[[
		{field:'DisGrpID',title:'DisGrpID',width:100,hidden:true},
		{field:'DisGroup',title:'疑难病种',width:140},
		{field:'PrvDesc',title:'号别',width:120},
		{field:'PreTime',title:'预约时间',width:180},
		{field:'PatName',title:'姓名',width:100},
		{field:'PatSex',title:'性别',width:60},
		{field:'PatAge',title:'年龄',width:60},
		{field:'PatNo',title:'病人ID',width:100},
		{field:'PayMony',title:'收费状态',width:80,formatter:
			function (value, row, index){
				if (value == "未收费"){return '<font style="color:red;font-weight:bold;">'+value+'</font>'}
				else {return '<font style="color:green;font-weight:bold;">'+value+'</font>'}
			}
		},
		{field:'CstStatus',title:'会诊状态',width:80,formatter:
			function (value, row, index){
				if (value == "撤销"){return '<font style="color:red;font-weight:bold;">'+value+'</font>'}
				else {return '<font style="color:green;font-weight:bold;">'+value+'</font>'}
			}
		},{field:'PrintFlag',title:'打印',width:80,align:'center',hidden:true,formatter:
			function (value, row, index){
				if (value.indexOf("Y")!=-1){return '<font style="color:green;font-weight:bold;">已打印</font>'}
				else {return '<font style="color:red;font-weight:bold;">未打印</font>'}
			}
		},{field:'PrintCons',title:'打印告知单',width:80,align:'center',formatter:
			function (value, row, index){
				
				if (row.PrintFlag.indexOf("Z")!=-1){return '<font style="color:green;font-weight:bold;">已打印</font>'}
				else {return '<font style="color:red;font-weight:bold;">未打印</font>'}
			}
		},
		{field:'PatLoc',title:'就诊科室',width:120},
		{field:'PatDiag',title:'诊断',width:140},
		{field:'CstRLoc',title:'申请会诊科室',width:120},
		{field:'CstRUser',title:'申请会诊医师',width:100},
		{field:'CstRTime',title:'申请时间',width:160},
		{field:'CstLocArr',title:'参加会诊科室',width:220},
		{field:'CstPrvArr',title:'参加会诊医师',width:220},
		{field:'MedicareNo',title:'病案号',width:120},
		{field:'PatTelH',title:'病人电话',width:150},
		{field:'CstTrePro',title:'简要病历',width:400,formatter:SetCellField},
		{field:'CstPurpose',title:'会诊理由及要求',width:400,formatter:SetCellField},
		{field:'CstNPlace',title:'会诊地点',width:200},
		{field:'ID',title:'ID',width:100},
		{field:'mdtMakResID',title:'mdtMakResID',width:100},
		{field:'EpisodeID',title:'EpisodeID',width:100,hidden:true},
		{field:'MakResDate',title:'预约日期',width:100,hidden:true},
		{field:'prtime',title:'当前日期',width:100,hidden:true},
		{field:'CstCUser',title:'完成医师',width:100},
		{field:'McNotes',title:'备注',width:100}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onLoadSuccess:function(data){
			BindTips(); /// 绑定提示消息
		},
		onDblClickRow: function (rowIndex, rowData) {
			WriteMdt(rowData.EpisodeID, rowData.ID);
        },
        rowStyler:function(rowIndex, rowData){
			if((rowData.CstStatus!="发送")&(rowData.CstStatus!="完成")&(rowData.prtime>rowData.MakResDate)&(rowData.PreTime!="")){
				return 'background-color:	#FFC0CB;';
			}
		}
	};
	/// 就诊类型
	var PatNo = $("#PatNo").val();
	var param = "^^^"+ PatNo +"^^^^^^^^"+ QryType;
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsGetMdtAudit&Params="+param;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// 处理特殊字符
function SetCellField(value, rowData, rowIndex){
	return $_TrsTxtToSymbol(value);
}

/// 登记号
function PatNo_KeyPress(e){

	if(e.keyCode == 13){
		var PatNo = $("#PatNo").val();
		if (!PatNo.replace(/[\d]/gi,"")&(PatNo != "")){
			///  登记号补0
			$("#PatNo").val(GetWholePatNo(PatNo));
		}
		QryPatList();  /// 查询
	}
}

/// 查询
function QryPatList(){
	
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// 开始日期
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// 结束日期
	//var PatNo = $("#PatNo").val();    /// 登记号
	var PatNo = $("#PatNo").val();
	var RLocID = $HUI.combobox("#CstRLoc").getValue()||"";       /// 请会诊科室
	var mdtDisGrp = $HUI.combobox("#mdtDisGrp").getValue()||"";  /// 疑难病种
	var ChargeFlag = $HUI.combobox("#ChargeFlag").getValue()||"";  /// 收费状态
	var consStatus = $HUI.combobox("#consStatus").getValue()||"";
	var params = StartDate +"^"+ EndDate +"^"+ RLocID +"^"+ PatNo +"^"+ mdtDisGrp +"^^^^^"+ChargeFlag+"^"+consStatus +"^"+ QryType;
	$("#bmDetList").datagrid("load",{"Params":params}); 
}

/// 填写MDT申请
function WriteMdt(EpisodeID, mdtID){

	var Link = "dhcmdt.write.csp?EpisodeID="+EpisodeID +"&ID="+mdtID+"&seeCstType=1";
	mdtPopWin(1, Link); /// 弹出MDT会诊处理窗口
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
	var mdtWinTitle = "";
	if (WidthFlag == 2) mdtWinTitle = $g("安排");
	if (WidthFlag == 3) mdtWinTitle = $g("签到");
	if (WidthFlag == 4) mdtWinTitle = $g("MDT会诊执行");
	if (WidthFlag == 5) mdtWinTitle = $g("修改资源");
	if (WidthFlag == 1){
		$("#mdtPopFrame").attr("src",Link);
		new WindowUX($g('MDT会诊查看'), 'mdtPopWin', 950, (window.screen.availHeight - 150), option).Init();
	}else if (WidthFlag == 5){
		$("#mdtResFrame").attr("src",Link);
		new WindowUX(mdtWinTitle, 'mdtResWin', 910, 460, option).Init();
	}else{
		$("#mdtFrame").attr("src",Link);
		new WindowUX(mdtWinTitle||$g('MDT修改医生'), 'mdtWin', 1400, 630, option).Init();
	}
}

/// 打印
function Print(){
	var rowData = $('#bmDetList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	
	if (GetIsOperFlag(rowData.ID, "10") == "1"){
		$.messager.alert('提示',"当前会诊已撤销，不能打印!","error");
		return;
	}
	
	var mCstID = rowData.ID;
	if(PrintWay==1){
	    window.open("dhcmdt.printconsmdtopin.csp?CstID="+mCstID);
	}else{
	    PrintCons(mCstID);  /// 打印会诊申请单	
	}
	
	$("#bmDetList").datagrid("reload");
	return;
}

/// 打印告知单
function printZQTYS(){
	
	var rowData = $('#bmDetList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	
	if (rowData.PayMony == "未收费"){
		$.messager.alert('提示',"当前会诊未收费，不能打印!","error");
		return;
	}
	
	if (GetIsOperFlag(rowData.ID, "10") == "1"){
		$.messager.alert('提示',"当前会诊已撤销，不能打印!","error");
		return;
	}
	
	var mCstID = rowData.ID;
	
	// printConsent(mCstID);
	PrintCst_REQ(mCstID,mdtDisGrp);  /// 打印会诊申请单
	InsCsMasPrintFlag(mCstID,"Z"); ///修改申请打印字段 
	/// sendMsgToPat(mCstID); /// 打印通知单时发送消息
	$("#bmDetList").datagrid("reload");
	return;
}


/// 拒绝会诊数据
function InsCsRefAuditNew(mdtID){
	
	var CstNote = "会诊审核不通过";
	/// 保存
	runClassMethod("web.DHCMDTConsult","InsCsRefAudit",{"mdtID":mdtID, "UserID":LgUserID, "CstNote":CstNote},function(jsonString){
		if (jsonString == -1){
			$.messager.alert("提示:","申请单非发送状态，不允许进行审核操作！","warning");
			return;
		}
		if (jsonString == 0){
			$.messager.alert("提示:","操作成功！","info");
			$("#bmDetList").datagrid("reload");
		}
	},'',false)
}

/// 拒绝会诊数据
function InsCsRefAudit(){
	
	var mdtID = $("#TmpID").val();          /// 驳回会诊ID
	var CstNote = $("#CstRefReason").val(); /// 驳回会诊原因
	CstNote = $_TrsSymbolToTxt(CstNote);    /// 处理特殊符号
	/// 保存
	runClassMethod("web.DHCMDTConsult","InsCsRefAudit",{"mdtID":mdtID, "UserID":LgUserID, "CstNote":CstNote},function(jsonString){
		if (jsonString == -1){
			$.messager.alert("提示:","申请单非发送状态，不允许进行驳回操作！","warning");
			return;
		}
		if (jsonString == 0){
			$.messager.alert("提示:","操作成功！","info");
			$('#newRefOpWin').dialog('close');  /// 关闭驳回窗口
			$("#bmDetList").datagrid("reload");
		}
	},'',false)
}

/// 弹出MDT会诊处理窗口
function mdtHandleWin(FlagCode){
	
	var rowData = $('#bmDetList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	
	if ((FlagCode != "P")&(FlagCode != "U")&(FlagCode != "R")&(rowData.PayMony == "未收费")){
		$.messager.alert('提示',"当前会诊未收费，不能进行此操作!","error");
		return;
	}
	
	if ((FlagCode == "P")&(GetIsOperFlag(rowData.ID, "20") != "1")){
		$.messager.alert("提示:","申请单当前状态，不允许进行"+ (FlagCode == "P"?"安排":"此") +"操作！","warning");
		return;
	}

	var itmCodes = (HasCenter == 1)?"30^40":"20^40"; /// 有无中心时，控制在何种状态下允许修改资源
	if ((FlagCode == "R")&(GetIsTakOperFlag(rowData.ID, itmCodes) != "1")){
		$.messager.alert("提示:","申请单当前状态，不允许进行此操作！","warning");
		return;
	}
	
	var itmCodes = (HasCenter == 1)?"30":"20"; /// 有无中心时，控制在何种状态下允许签到
	if ((FlagCode == "W")&(GetIsOperFlag(rowData.ID, itmCodes) != "1")){
		$.messager.alert("提示:","申请单当前状态，不允许进行此操作！","warning");
		return;
	}

	var Link = ""; WidthFlag = 0;
	if (FlagCode == "P"){
		WidthFlag = 2;
		Link = "dhcmdt.makeresplan.csp?ID="+rowData.ID +"&mdtMakResID="+rowData.mdtMakResID+"&DisGrpID="+ rowData.DisGrpID+"&EpisodeID="+ rowData.EpisodeID;
	}else if (FlagCode == "W"){
		WidthFlag = 3;
		Link = "dhcmdt.conssignin.csp?ID="+rowData.ID;
	}else if (FlagCode == "U"){
		Link = "dhcmdt.updconsdoc.csp?ID="+rowData.ID +"&DisGrpID="+ rowData.DisGrpID;
	}else if (FlagCode == "R"){
		selMdtMakResID = rowData.mdtMakResID; /// 资源ID
		Link = "dhcmdt.makeresources.csp?ID="+rowData.ID +"&mdtMakResID="+rowData.mdtMakResID+"&DisGrpID="+ rowData.DisGrpID +"&EpisodeID="+ rowData.EpisodeID;
		$("#mdtID").val(rowData.ID);  /// mdt 会诊ID
		WidthFlag = 5;
	}else{
		Link = "dhcmdt.execonclusion.csp?EpisodeID="+rowData.EpisodeID +"&ID="+rowData.ID;
		WidthFlag = 1;
	}

	mdtPopWin(WidthFlag, Link); /// 弹出MDT会诊处理窗口
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
	runClassMethod("web.DHCMDTCom","GetCurSysTime",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate
}

/// 检查项目绑定提示栏
function BindTips(){
	
	var html='<div id="tip" style="border-radius:3px; display:none; border:1px solid #000; padding:10px; margin:5px; position: absolute; background-color: #000;color:#FFF;"></div>';
	$('body').append(html);
	
	/// 鼠标离开
	$('td[field="CstTrePro"],td[field="CstPurpose"]').on({
		'mouseleave':function(){
			$("#tip").css({display : 'none'});
		}
	})
	/// 鼠标移动
	$('td[field="CstTrePro"],td[field="CstPurpose"]').on({
		'mousemove':function(){
			
			var tleft=(event.clientX + 10);
			if ($(this).text().length <= 20){
				return;
			}
			if ( window.screen.availWidth - tleft < 600){ tleft = tleft - 600;}
			/// tip 提示框位置和内容设定
			$("#tip").css({
				display : 'block',
				top : (event.clientY + 10) + 'px',   
				left : tleft + 'px',
				//right:10+'px',
				//bottom:5+'px',
				'z-index' : 9999,
				opacity: 0.8
			}).text($(this).text());
		}
	})
}

/// 发送
function mdtSend(){
	
	$.messager.alert('错误提示',"发送成功！","success");
}

/// 退号
function RetMakRes(){
	
	var rowData = $('#bmDetList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	
	$.messager.confirm('确认对话框','退号会释放此号别预约资源，并且停止会诊医嘱，您确定要进行此操作吗？', function(r){
		if (r){
			/// 保存
			runClassMethod("web.DHCMDTConsult","RetMakRes",{"CstID":rowData.ID, "LgParams":LgParam},function(jsonString){
				if (jsonString == -1){
					$.messager.alert("提示:","申请单当前状态，不允许进行退号操作！","warning");
					return;
				}
				if (jsonString == -2){
					$.messager.alert("提示:","已收费申请不允许撤销，请填写退费申请！","warning");
					return;
				}
				if (jsonString == -3){
					$.messager.alert("提示:","医嘱已执行，请护士先撤消执行！","warning");
					return;
				}
				if (jsonString < 0){
					$.messager.alert("提示:","退号失败！","warning");
					return;
				}
				if (jsonString == 0){
					$.messager.alert("提示:","退号成功！","info");
					$("#bmDetList").datagrid("reload");
				}
			},'',false)
		}
	});
}

/// 修改资源时间
function TakMakResDate(){
	
	//if (!frames[2].GetPatMakRes()) return;
	if (!document.getElementById('mdtResFrame').contentWindow.GetPatMakRes()) return;
	var mdtID = $("#mdtID").val();  /// mdt 会诊ID
	var mdtPreData = $("#mdtPreDate").val();       /// 预约日期
	var mdtPreTime = $("#mdtPreTime").val();       /// 预约时间
	var mdtMakResID = $("#mdtMakResID").val();     /// 出诊表ID
	if (mdtMakResID == selMdtMakResID){
		$.messager.alert("提示:","请先选择预约资源！","warning");
		return;
	}
	var makResParams = mdtPreData +"^"+ mdtPreTime +"^"+ mdtMakResID;     /// 出诊表ID
	$.messager.confirm('确认对话框','您确定要将会诊时间修改为：'+ mdtPreData +" "+ mdtPreTime +'吗？', function(r){
		if (r){
			runClassMethod("web.DHCMDTConsult","TakMakResDate",{"mdtID":mdtID, "LgParams":LgParam, "makResParams":makResParams},function(jsonString){
				if (jsonString == -1){
					$.messager.alert("提示:","申请单当前状态，不允许进行修改时间操作！","warning");
					return;
				}
				if (jsonString < 0){
					$.messager.alert("提示:","修改失败，失败原因："+ jsonString +"！","warning");
					return;
				}
				if (jsonString == 0){
					$.messager.alert("提示:","修改成功！","info");
					ClsWin(); /// 关闭窗口
					$("#bmDetList").datagrid("reload");
				}
			},'',false)
		}
	});
}

/// 是否允许操作
function GetIsOperFlag(CstID, stCode){

	var IsModFlag = ""; /// 是否允许修改
	runClassMethod("web.DHCMDTConsult","GetIsOperFlag",{"CstID":CstID, "stCode":stCode},function(jsonString){

		if (jsonString != ""){
			IsModFlag = jsonString;
		}
	},'',false)
	return IsModFlag
}

/// 是否允许操作
function GetIsTakOperFlag(CstID, stCodes){

	var IsModFlag = ""; /// 是否允许修改
	runClassMethod("web.DHCMDTConsult","GetIsTakOperFlag",{"CstID":CstID, "stCodes":stCodes},function(jsonString){

		if (jsonString != ""){
			IsModFlag = jsonString;
		}
	},'',false)
	return IsModFlag
}

/// 关闭窗口
function ClsWin(){
	
	$("#mdtResWin").window("close"); 
}

/// 打印通知单时发送消息
function sendMsgToPat(mCstID){
	runClassMethod("web.DHCMDTInterface","SendMsgProxy",{"ID":mCstID,"Type":"F"},function(jsonString){
	},'',false)
}

/// 初始化页面卡类型定义
function initCardTypeCombobox(){
	
	/// 获取默认卡类型
	runClassMethod("web.DHCEMPatCheckLevCom","GetDefaultCardType",{},function(jsonString){
		defaultCardTypeDr = jsonString;
		var CardTypeDefArr = defaultCardTypeDr.split("^");
        m_CardNoLength = CardTypeDefArr[17];   /// 卡号长度
        m_CCMRowID = CardTypeDefArr[14];
        if (CardTypeDefArr[16] == "Handle"){
	    	$('#PatCardNo').attr("readOnly",false);
	    }else{
			$('#PatCardNo').attr("readOnly",true);
		}
		$("#CardTypeDr").combobox("setValue",defaultCardTypeDr);
	},'',false)
}

/// 获取病人对应卡类型数据
function GetEmPatCardTypeDefine(CardTypeID){
    
	runClassMethod("web.DHCPUECommonData","GetEmPatCardTypeDefine",{"CardTypeID":CardTypeID},function(jsonString){
		
		if (jsonString != null){
			var CardTypeDefine = jsonString;
			var CardTypeDefArr = CardTypeDefine.split("^");
			if (CardTypeDefArr[16] == "Handle"){
				$('#PatCardNo').attr("readOnly",false);
			}else{
				$('#PatCardNo').attr("readOnly",true);
			}
			$("#CardTypeDr").combobox("setValue",CardTypeDefine);
		}
	},'text')
}

// 读卡 44638842
function readcard(){
	var CardTypeRowId=GetCardTypeRowId();
	var myoptval=$('#CardTypeDr').combobox('getValue');
	var myrtn=DHCACC_GetAccInfo(CardTypeRowId,myoptval);
	var myary=myrtn.split("^");
	var rtn=myary[0];
	AccAmount=myary[3];
	switch (rtn){
		case "0": //卡有效
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			var NewCardTypeRowId=myary[8];
			if (NewCardTypeRowId!=CardTypeRowId){
				GetEmPatCardTypeDefine(NewCardTypeRowId);	
			}
			clearSignRegWin()//清空
			$('#PatNo').val(PatientNo); //登记号
			$('#PatCardNo').val(CardNo); //卡号
			QryPatList();	
			break;
		case "-200": //卡无效
			clearSignRegWin()//清空
			$.messager.alert('提示：','此卡无效！');
			break;
		case "-201": //现金
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			var NewCardTypeRowId=myary[8];
			if (NewCardTypeRowId!=CardTypeRowId){
				GetEmPatCardTypeDefine(NewCardTypeRowId);		
			}
         	clearSignRegWin()//清空
			$('#PatNo').val(PatientNo); //登记号
			$('#PatCardNo').val(CardNo); //卡号
			break;
		default:
	}
}

//卡类型id
function GetCardTypeRowId(){
	var CardTypeRowId="";
	var CardTypeValue=$('#CardTypeDr').combobox('getValue');
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardTypeRowId=CardTypeArr[0];
	}
	return CardTypeRowId;
}

/// 清空
function clearSignRegWin(){
	
	$('#PatCardNo').val("");  //卡号
	$('#PatNo').val(""); //病人id	
}

/// 添加备注
function AddNotes(){
	
    var rowData = $('#bmDetList').datagrid('getSelected');
    if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	var linkUrl ="dhcmdt.addnotes.csp?ID="+rowData.ID+"&DisGrpID="+ rowData.DisGrpID+"&EpisodeID="+ rowData.EpisodeID;
	commonShowWin({
		url: linkUrl,
		title: $g("备注"),
		width: 700,
		height: 340
	})	
}

/// 修改专家
function modProWin(){
	
    var rowData = $('#bmDetList').datagrid('getSelected');
    if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	
	var itmCodes = (HasCenter == 1)?"30^40":"20^40"; /// 有无中心时，控制在何种状态下允许编辑
	if (GetIsTakOperFlag(rowData.ID, itmCodes) != "1"){
		$.messager.alert("提示:","申请单当前状态，不允许进行此操作！","warning");
		return;
	}
	
//	if ((GetIsOperFlag(rowData.ID, "30") != "1")&(GetIsOperFlag(rowData.ID, "40") != "1")){
//		$.messager.alert("提示:","申请单当前状态，不允许进行此操作！","warning");
//		return;
//	}
	
	var Link = "dhcmdt.updconsdoc.csp?ID="+rowData.ID +"&DisGrpID="+ rowData.DisGrpID;
	commonShowWin({
		url: Link,
		title: $g("修改专家"),
		width: 1200,
		height: 590
	})	
}

/// 多语言支持
function multi_Language(){
	
	$g("提示");
	$g("卡号输入错误,请重新录入！");
	$g("当前卡无效,请重试！");
	$g("请先选择一行记录!");
	$g("当前会诊已撤销，不能打印!");
	$g("当前会诊未收费，不能打印!");
	$g("申请单非发送状态，不允许进行审核操作！");
	$g("申请单非发送状态，不允许进行驳回操作！");
	$g("当前会诊未收费，不能进行此操作!");
	$g("申请单当前状态，不允许进行");
	$g("安排");
	$g("此");
	$g("操作！");
	$g("登记号输入错误！");
	$g("退号会释放此号别预约资源，并且停止会诊医嘱，您确定要进行此操作吗？");
	$g("申请单当前状态，不允许进行退号操作！");
	$g("请先选择预约资源！");
	$g("您确定要将会诊时间修改为：");
	$g("吗？");
	$g("确认对话框");
	$g("申请单当前状态，不允许进行修改时间操作！");
	$g("修改失败，失败原因：");
	$g("此卡无效！");
	$g("申请单当前状态，不允许进行此操作！");
	$g("操作成功！");
	$g("修改成功！");
	$g("退号成功！");
	$g("错误提示");
	$g("发送成功！");
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
