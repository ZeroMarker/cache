//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-10-31
// 描述:	   急诊医生交班本JS
//===========================================================================================

var BsID = "";          /// 交班ID
var EmType = "Doc";     /// 交班类型
var Pid = "";           /// 进程ID
var CompFlag = "";      /// 完成标志
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var ItemTypeArr = [{"value":"早班","text":'早班'}, {"value":"中班","text":'中班'}, {"value":"夜班","text":'夜班'}];

/// 页面初始化函数
function initPageDefault(){
	
	InitDetList();     /// 初始化列表
	InitParams();      /// 初始华参数
	InitComponents();  /// 初始化界面组件
	InitShiftsItem();  /// 加载Table列表
}

/// 初始化页面参数
function InitParams(){
	
	
}

/// 初始化界面组件
function InitComponents(){
	
	/// 交班日期
	$HUI.datebox("#WrDate").setValue(GetCurSystemDate(0));
	
	/// 医生分组
	var uniturl = $URL+"?ClassName=web.DHCEMPatCheckLevCom&MethodName=jsonCTMedUnit&LocID="+ LgLocID;
	$HUI.combobox("#MedGrp",{
		url:uniturl,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			
	    }	
	})
	
	/// 班次
	var uniturl = $URL+"?ClassName=web.DHCEMTimeInterval&MethodName=jsonTimeInterval&HospID="+ LgHospID +"&Module=Doc";
	$HUI.combobox("#Schedule",{
		url:uniturl,
		//data : ItemTypeArr,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			
	    }	
	})
	
	/// 病区
	var uniturl = $URL+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonWard&HospID="+LgHospID;
	$HUI.combobox("#Ward",{
		url:uniturl,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			
	    }	
	})
		
	/// 清空
	clearPages();
}

/// 页面DataGrid初始定义已选列表
function InitDetList(){
	
	///  定义columns
	var columns=[[
		{field:'WriFlag',title:'状态',width:75,align:'center',formatter:SetCellWriFlag},
		{field:'PatBed',title:'床号',width:70},
		{field:'Type',title:'类型',width:80,styler:setCellType},
		{field:'PatLoc',title:'科室',width:100},
		{field:'Oper',title:'操作',width:100,align:'center',formatter:SetCellUrl},
		//{field:'PatLev',title:'当前级别',width:90,align:'center',formatter:setCellLevLabel},
		{field:'PatNo',title:'登记号',width:120},
		{field:'ObsTime',title:'滞留时间',width:90},
		{field:'PatName',title:'姓名',width:90},
		{field:'PatSex',title:'性别',width:50},
		{field:'PatAge',title:'年龄',width:90},
		{field:'WaitToHos',title:'拟入院科室',width:220},
		//{field:'mainDoc',title:'主管医生',width:120,align:'center'},
		{field:'PatDiag',title:'诊断',width:220},
		{field:'BsBackground',title:'背景',width:320},
		{field:'BsAssessment',title:'评估',width:320},
		{field:'BsSuggest',title:'建议',width:320},
		{field:'BsItmID',title:'BsItmID',width:80}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		pageSize : [60],
		pageList : [60,90],
		onLoadSuccess:function(data){
			if (typeof data.Pid != "undefined"){
				Pid = data.Pid;
			}		
		},
		onDblClickRow: function (rowIndex, rowData) {

        }
	};
	/// 就诊类型
	var param = "";
	var uniturl = $URL+"?ClassName=web.DHCEMBedSideShift&MethodName=GetEmPatList&Params="+param;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// 链接
function SetCellUrl(value, rowData, rowIndex){
	
	var html = "";
	if (rowData.CompFlag != "Y"){
		html = "<a href='#' onclick='wri("+ rowIndex +")' title='编辑' style='margin:0px 5px;'><img src='../scripts/dhcnewpro/dhcem/images/write_order.png' border=0/></a>";
	    html += "<a href='#' onclick='del("+ rowIndex +")' title='删除' style='margin:0px 5px;'><img src='../scripts/dhcnewpro/dhcem/images/cancel.png' border=0/></a>";
	}
	html += "<a href='#' onclick='log("+ rowData.EpisodeID +")' title='日志' style='margin:0px 5px;'><img src='../scripts/dhcnewpro/dhcem/images/eye.png' border=0/></a>";
	return html;
}

/// 分级
function setCellLevLabel(value, rowData, rowIndex){
	
	var fontColor = "";
	if ((value == "1级")||(value == "2级")){ fontColor = "#F16E57";}
	if (value == "3级"){ fontColor = "#FFB746";}
	if (value == "4级"){ fontColor = "#2AB66A";}
	return "<font color='" + fontColor + "'>"+value+"</font>";
}

/// 类型
function setCellType(value, row, index){
	
	if (value == "红区"){
		return 'background-color:#F16E57;color:white';
	}else if (value == "黄区"){
		return 'background-color:#FFB746;color:white';
	}else if (value == "绿区"){
		return 'background-color:#2AB66A;color:white';
	}else if (value == "蓝色"){
		return 'background-color:#449be2;color:white';
	}else{
		return '';
	}
}

/// 类型
function SetCellWriFlag(value, rowData, rowIndex){
	
	var html = "<span style='display:block;width:45px;background:#7dba56;padding:3px 6px;color:#fff;border-radius: 4px 4px 4px 4px;'>"+ (value == "Y"?"已填":"未填")+"</span>";
	return html;
}

/// 加载交班信息
function GetEmShift(InBsID){
	
	BsID = InBsID;
	GetEmShiftObj(BsID);  /// 初始化加载加班主信息
	GetEmLinkItem(BsID);  /// 初始化关联项目
	$("#bmDetList").datagrid("load",{"Params":BsID +"^"+ Pid});
}

/// 刷新病人列表
function refresh(){
	$("#bmDetList").datagrid("reload");
}

/// 获取交班信息
function GetEmShiftObj(BsID){
	
	runClassMethod("web.DHCEMBedSideShift","JsGetEmShiftObj",{"BsID":BsID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			InsEmShiftObj(jsonObjArr);
		}
	},'json',false)
}

/// 设置交班信息
function InsEmShiftObj(itemobj){
	
	/// 医生分组
	$HUI.combobox("#MedGrp").setValue(itemobj.MedGrpID);
	$HUI.combobox("#MedGrp").disable();
    /// 交班病区
	$HUI.combobox("#Ward").setValue(itemobj.WardID);
	$HUI.combobox("#Ward").disable();
    /// 交班班次
	$HUI.combobox("#Schedule").setValue(itemobj.Schedule);
	$HUI.combobox("#Schedule").disable();
    /// 交班日期
	$HUI.datebox("#WrDate").setValue(itemobj.WrDate);
	/// 交班人员
	$("#CarePrv").val(itemobj.UserName);
	$("#PassWord").val("");
	/// 接班人员
	$("#RecUser").val(itemobj.RecUser);
	$("#bt_find").linkbutton('disable');  /// 查询按钮
	if (itemobj.CompFlag == "Y"){
		$("#bt_del").linkbutton('disable');   /// 删除按钮
		$("#bt_sure").linkbutton('disable');  /// 确认按钮
		$("#bt_add").linkbutton('disable');   /// 新增按钮
	}else{
		$("#bt_del").linkbutton('enable');   /// 删除按钮
		$("#bt_sure").linkbutton('enable');  /// 确认按钮
		$("#bt_add").linkbutton('enable');   /// 新增按钮	
	}
	CompFlag = itemobj.CompFlag;
}

/// 初始化关联项目
function GetEmLinkItem(BsID){
	
	$("input[name='item']").val("");     /// 清空交班分项
	runClassMethod("web.DHCEMBedSideShift","JsGetLnkItemObj",{ "BsID":BsID },function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				if ($("#"+jsonObjArr[i].itmID)){
					$("#"+jsonObjArr[i].itmID).val(jsonObjArr[i].itmVal);
				}
			}
		}
	},'json',false)
}

/// 清空页面元素内容
function clearPages(){
	
	BsID = "";      /// 交班ID
	CompFlag = "";  /// 完成标志
	/// 医生分组
	$HUI.combobox("#MedGrp").setValue("");
	$HUI.combobox("#MedGrp").enable();
    /// 交班病区
	$HUI.combobox("#Ward").setValue("");
	$HUI.combobox("#Ward").enable();
    /// 交班班次
	$HUI.combobox("#Schedule").setValue("");
	$HUI.combobox("#Schedule").enable();
    /// 交班日期
	$HUI.datebox("#WrDate").setValue(GetCurSystemDate(0));
	/// 交班人员
	$("#CarePrv").val(session['LOGON.USERNAME']);
	$("#PassWord").val("");
	/// 接班人员
	$("#RecUser").val("");
	$("#bmDetList").datagrid("loadData", { total: 0, rows: [] });
	
	$("#bt_find").linkbutton('enable');  /// 查询按钮
	$("#bt_del").linkbutton('enable');   /// 删除按钮
	$("#bt_sure").linkbutton('enable');  /// 确认按钮
	$("#bt_add").linkbutton('enable');   /// 新增按钮
	
	$("input[name='item']").val("");     /// 交班分项
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

/// 加载Table列表
function InitShiftsItem(){
	
	/// 初始化检查方法区域
	//$("#itemList").html('<tr style="height:0;"><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	// 获取显示数据
	runClassMethod("web.DHCEMDicItem","JsGetColumns",{"mCode":"BSD", "HospID":session['LOGON.HOSPID']},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				InitCheckItemRegion(jsonObjArr[i]);
			}
		}
	},'json',false)
}

/// 交班项目列表
function InitCheckItemRegion(itemArr){	

	/// 项目
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		
		itemhtmlArr.push('<td align="right" class="tb_td_bk">'+ itemArr[j-1].title +'</td><td><input id="'+ itemArr[j-1].field +'" name="item" class="hisui-validatebox" style="width:60px;"></input></td>');
		if (j % 7 == 0){
			itemhtmlstr = itemhtmlstr + '<tr class="tr">' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
	if ((j-1) % 7 != 0){
		var fixhtml = "";
		var remainder = (j-1) % 4;
		if (remainder == 3){fixhtml = "<td></td><td></td>"}
		if (remainder == 2){fixhtml = "<td></td><td></td><td></td><td></td>"}
		if (remainder == 1){fixhtml = "<td></td><td></td><td></td><td></td><td></td><td></td>"}
		itemhtmlstr = itemhtmlstr + '<tr class="tr">' + itemhtmlArr.join("") + fixhtml + '</tr>';
		itemhtmlArr = [];
	}
	$("#itemList").append(itemhtmlstr)
	$.parser.parse($('#itemList'));  /// 重新解析
}

/// 生成交班记录
function takShift(){
	
	var WrDate = $HUI.datebox("#WrDate").getValue();       /// 交班日期
	
	var MedGrpID = $HUI.combobox("#MedGrp").getValue(); /// 医疗组
	if ((MedGrpID == "")&(EmType == "Doc")){
		//$.messager.alert("提示:","请选择医疗小组！","warning");
		//return;
	}
	
	var WardID = $HUI.combobox("#Ward").getValue();     /// 留观区
	if (WardID == ""){
		$.messager.alert("提示:","请选择留观病区！","warning");
		return;
	}
	
	var Schedule = $HUI.combobox("#Schedule").getValue();  /// 交班班次
	if (Schedule == ""){
		$.messager.alert("提示:","交班班次不能为空！","warning");
		return;
	}

	/// 医疗组 +"^"+ 留观区 +"^"+ 班次 +"^"+ 交班日期 +"^"+ 交班类型 +"^"+ 交班人员 +"^"+ 关联项类型 +"^"+ 医院ID
	var mParams = MedGrpID +"^"+ WardID +"^"+ Schedule +"^"+ WrDate +"^"+ EmType +"^"+ LgUserID +"^"+ "BSD" +"^"+ LgHospID;

	/// 保存
	runClassMethod("web.DHCEMBedSideShift","Insert",{"BsID":BsID, "mParams":mParams, "Pid":Pid},function(jsonString){
		if (jsonString < 0){
		   if(jsonString == "-1"){
			   $.messager.alert("提示:","该班次已有记录，请到<font style='color:red;font-weight:bold;'>交班日志</font>里面查询！","warning");
	       }else{
			   $.messager.alert("提示:","交班主信息保存失败，失败原因:"+jsonString,"warning");
		   }
		}else{
			GetEmShift(jsonString);  /// 获取交班信息
			$.messager.alert("提示:","生成交班成功！","warning");
		}
	},'',false)
}

/// 交班列表窗口
function OpenBedLisWin(){
	
	commonShowWin({
		url:"dhcem.bedsideshiftquery.csp?Type=T&EmType=Doc",
		title:"交班本查询"	
	})
}

/// 编辑
function wri(index){
	
	var rowDatas = $('#bmDetList').datagrid('getRows');
	var bsItemID = rowDatas[index].BsItmID;
//	if (bsItemID == ""){
//		$.messager.alert("提示:","请先选择需交班病人记录！","warning");
//		return;
//	}
	if (CompFlag == "Y"){
		$.messager.alert("提示:","当前交班已经确认，不能编辑！","warning");
		return;
	}
	var EpisodeID = rowDatas[index].EpisodeID; /// 就诊ID
	
	commonShowWin({
		url:"dhcem.wirtebedshift.csp?bsID="+ BsID +"&bsItemID="+ bsItemID +"&EpisodeID="+ EpisodeID +"&EmType=Doc" +"&Pid="+ Pid,
		title:"交班录入",
		width: (window.screen.availWidth - 20),
		height: (window.screen.availHeight - 150)
	})
}

/// 删除
function del(index){
	
	var rowDatas = $('#bmDetList').datagrid('getRows');
	var bsItemID = rowDatas[index].BsItmID;
	if (bsItemID == ""){
		$.messager.alert("提示:","当前病人未填写交班记录，无需删除！","warning");
		return;
	}
	if (CompFlag == "Y"){
		$.messager.alert("提示:","当前交班已经确认，不能删除！","warning");
		return;
	}
	
	$.messager.confirm("删除", "确定要删除此病人交班记录?", function (r) {
		if (r) {
			delBsPat(bsItemID);
		}
	});
}

/// 新增
function add(){

	if (BsID == ""){
		$.messager.alert("提示:","请先选择或生成交班记录！","warning");
		return;
	}
	
	commonShowWin({
		url:"dhcem.addpat.csp?BsID="+ BsID +"&Pid="+ Pid,
		title:"新增",
		width: 600,
		height: 270
	})
}

/// 删除
function delBsPat(bsItemID){
	
	runClassMethod("web.DHCEMBedSideShift","DelBsPat",{ "bsItemID":bsItemID },function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示:","删除失败！","warning");
		}else{
			$.messager.alert("提示:","删除成功！","warning");
			$("#bmDetList").datagrid("reload");
		}
	},'',false)
}

/// 查看日志
function log(EpisodeID){
	
	if (!hasLog(EpisodeID)) return;  /// 病人是否有交班日志 
	
	commonShowWin({
		url:"dhcem.pattimeaxis.csp?PatientID=&EpisodeID="+ EpisodeID +"&EmType=Doc",
		title:"历次交班信息",
		height: (window.screen.availHeight - 180)	
	})
}

/// 确认
function sure(){
	
	$.messager.confirm("确认", "确定要提交本次交班记录?确认之后不允许再进行修改！", function (r) {
		if (r) {
			sureBs();
		}
	});
}

/// 确认
function sureBs(){
	
	var rowDatas = $('#bmDetList').datagrid('getRows');
	if (rowDatas.length == 0){
		$.messager.alert("提示:","待交班病人不能为空！","warning");
		return;	
	}
	
	var RecUser = $("#RecUser").val();    /// 接班人
	if (RecUser == ""){
		$.messager.alert("提示:","接班人不能为空！","warning");
		return;
	}
	//if (!IsValAccUser(RecUser)) return;  /// 验证接班人是否填写正确
	
	if (!IsValPassWord()) return;        /// 验证密码
	
	var items = $("input[name='item']"); /// 交班分项
	var itemArr = [];
	for(var i=0; i<items.length; i++){
		if (items[i].value != ""){
			itemArr.push(items[i].id +"@"+ items[i].value);
		}
	}
	
	/// 主信息
	var mListData = RecUser +"^"+ itemArr.join("#");
	
	runClassMethod("web.DHCEMBedSideShift","InsBsSure",{ "BsID":BsID , "mListData":mListData},function(jsonString){

		if (jsonString == -1){
			$.messager.alert("提示:","交班记录为空或新增病人未填写交班记录，不能进行确认操作！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","确认失败！","warning");
		}else{
			$.messager.alert("提示:","确认成功！","warning");
			GetEmShift(BsID);  /// 获取交班信息
		}
	},'',false)
}

/// 签名验证
function IsValPassWord(){

	var PassWord = $("#PassWord").val(); /// 签名密码
	if (PassWord == ""){
		$.messager.alert("提示:","交班人签名密码不能为空！","warning");
		return false;
	}
	
	var userName = $("#CarePrv").val(); /// 交班人
	
	var success = false;
	runClassMethod("web.DHCEMBedSideShift","IsValPassWord",{"userName":userName, "passWord":PassWord},function(jsonString){

		if (jsonString == 0){
			success = true;
		}else{
			$.messager.alert("提示:",jsonString,"warning");
		}
	},'',false)
	return success;
}

/// 验证接班人是否填写正确
function IsValAccUser(userName){

	var success = false;
	runClassMethod("web.DHCEMBedSideShift","IsValAccUser",{"userName":userName},function(jsonString){

		if (jsonString != ""){
			success = true;
		}else{
			$.messager.alert("提示:","接班人填写错误！","warning");
		}
	},'',false)
	return success;
}

/// 删除交班记录
function delShifts(){

	if (BsID == ""){
		$.messager.alert("提示:","请先选中一次交班记录后，重试！");
		return;
	}
	$.messager.confirm('确认对话框','确定要删除当前交班记录吗！', function(r){
		if (r){
			runClassMethod("web.DHCEMBedSideShift","deleteBs",{"BsID":BsID},function(jsonString){

				if (jsonString < 0){
					$.messager.alert("提示:","删除交班记录失败，失败原因:"+jsonString,"warning");
				}else{
					$.messager.alert("提示:","删除成功！");
					clearPages(); /// 清空界面内容
				}
			},'',false)
		}
	});
}

/// 病人是否有交班日志 
function hasLog(EpisodeID){

	var hasFlag = false;
	runClassMethod("web.DHCEMBedSideShiftQuery","HasLog",{"EpisodeID":EpisodeID, "Type":EmType},function(jsonString){

		if (jsonString == 1){
			hasFlag = true;
		}else{
			$.messager.alert("提示:","该病人无交班日志！","warning");
		}
	},'',false)
	return hasFlag;
}

/// 删除临时global
function killTmpGlobal(){

	runClassMethod("web.DHCEMBedSideShift","killTmpGlobal",{"Pid":Pid},function(jsonString){
	},'',false)
}

/// 页面关闭之前调用
function onbeforeunload_handler() {
    killTmpGlobal();  /// 清除临时global
}

/// 自动设置页面布局
function onresize_handler(){
	
}

/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {

	
	/// 自动设置页面布局
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;
window.onbeforeunload = onbeforeunload_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })