//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2018-11-24
// 描述:	   急诊床旁交班
//===========================================================================================

var BsID = "";      /// 交班ID
var EmType = "";    /// 交班类型
var Pid = "";       /// 进程ID
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var ItemGrpArr = [{"value":"早班","text":'早班'}, {"value":"中班","text":'中班'}, {"value":"夜班","text":'夜班'}];;
var ItemTypeArr = [{"value":"早班","text":'早班'}, {"value":"中班","text":'中班'}, {"value":"夜班","text":'夜班'}];;
var EpisodeID=""
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
	$HUI.datebox("#WrDate").setValue(GetCurSystemDate(0));
	
	/// 交班人员
	$("#CarePrv").val(session['LOGON.USERNAME']);
	
	/// 医生分组
	var uniturl = $URL+"?ClassName=web.DHCEMPatCheckLevCom&MethodName=jsonCTMedUnit&LocID="+ session['LOGON.CTLOCID'];
	$HUI.combobox("#MedGrp",{
		url:uniturl,
		data : ItemGrpArr,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	    }	
	})
	
	/// 交班类型
	EmType = getParam("EmType");
	if (EmType == "Nur"){
		$HUI.combobox("#MedGrp").disable();
	}
	
	/// 班次
	$HUI.combobox("#Schedule",{
		url:'',
		data : ItemTypeArr,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	    }	
	})
	
	/// 病区
	//var uniturl = $URL+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonWard&HospID="+LgHospID;
	var uniturl = $URL+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonWard&HospID="+LgHospID;
	$HUI.combobox("#Ward",{
		url:uniturl,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	    }	
	})
	
}

/// 病人就诊信息
function GetPatBaseInfo(EpisodeID){
	runClassMethod("web.DHCEMConsultQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
			if (jsonObject.PatSex == "男"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/boy.png");
			}else if (jsonObject.PatSex == "女"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/girl.png");
			}else{
				$("#PatPhoto").attr("src","../images/unman.png");
			}
		})
	},'json',false)
}

/// 页面DataGrid初始定义已选列表
function InitPatList(){
	
	///  定义columns
	var columns=[[
		{field:'BsItmID',title:'BsItmID',width:100,hidden:true},
		{field:'Edit',title:'编辑',width:100,align:'center',formatter:
			function (value, row, index){
				if (row.BsItmID == ""){
					return "";
				}else{
					return '<a href="#" onclick="WriBedShiftWin('+ index +')">编辑</a>';
				}
			}
		},
		{field:'PatBed',title:'床号',width:60,align:'center'},
		{field:'PatName',title:'姓名',width:100},
		{field:'PatNo',title:'登记号',width:100},
		{field:'PatAge',title:'年龄',width:60,align:'center'},
		{field:'PatSex',title:'性别',width:50,align:'center'},
		{field:'PAAdmDate',title:'就诊日期',width:100,align:'center'},
		{field:'PAAdmTime',title:'就诊时间',width:100,align:'center'},
		//{field: 'CurrAmt',title: '余额',hidden:true,width:75,align:'center',
		// 	 styler: function(value,row,index){
		// 	   	 if(row.CurrAmt<500){
	 	//		    return 'background-color:red;color:white';
		// 	   	 }
	 	//    }
		// },
		{field:'PatDiag',title:'诊断',width:320},
		//{field:'BsVitalSign',title:'生命体征',width:320},
		{field:'BsContents',title:'交班内容',width:320},
		//{field:'WaitToHos',title:'待入院科室',width:300},
		//{field:'BsMedHis',title:'病史',width:320},
		{field:'BsTreatMet',title:'治疗方式',width:320},
		//{field:'BsCotNumber',title:'联系方式',width:120},
		{field:'BsNotes',title:'备注',width:320},
		{field:'EpisodeID',title:'EpisodeID',width:100,align:'center'}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		toolbar:"#toolbar",
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		nowrap : false,
		onLoadSuccess:function(data){
			if (typeof data.Pid != "undefined"){
				Pid = data.Pid;
			}
		},
        rowStyler:function(rowIndex, rowData){
			if (rowData.AuditFlag == "已审"){
				return 'background-color:pink;';
			}
		}
	};
	/// 就诊类型
	var param = "";
	var uniturl = $URL+"?ClassName=web.DHCEMBedSideShift&MethodName=GetEmPatList&Params="+param;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
	
}

/// 查询
function QryPatList(){
	
	var MedGrpID = $HUI.combobox("#MedGrp").getValue(); /// 医疗组
	if ((MedGrpID == "")&(EmType == "Doc")){
		$.messager.alert("提示:","请选择医疗小组！","warning");
		return;
	}
	
	var WardID = $HUI.combobox("#Ward").getValue();     /// 留观区
	if (WardID == ""){
		$.messager.alert("提示:","请选择留观病区！","warning");
		return;
	}
	
	var Schedule=$HUI.combobox("#Schedule").getValue();  /// 交班班次
	if (Schedule == ""){
		$.messager.alert("提示:","交班班次不能为空！","warning");
		return;
	}
	
	var params = "^" + WardID +"^"+ MedGrpID +"^"+ Pid;
	$("#bmDetList").datagrid("load",{"Params":params}); 
}

/// 打印
function PrintCst(){
	
	var rowsData = $("#bmDetList").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		PrintCst_AUD(rowsData.CstID);
		InsCsMasPrintFlag(rowsData.CstID);  /// 修改会诊打印标志
	}
}

/// 交班内容窗口 bianshuai 2018-11-23
function WriBedShiftWin(index){
	
	var rowData = $('#bmDetList').datagrid('getRows');
	EpisodeID=rowData[index].EpisodeID   //就诊ID
	PatientID=rowData[index].PatientID;  //病人ID
	GetPatBaseInfo(EpisodeID)            //获取病人基本信息
	var option = {
		modal : true,
		title : "交班内容",
		collapsible : false,
		minimizable : false,
		maximizable : false,
		width : (window.screen.availWidth-300), 
		height : 580, ///(window.screen.availHeight-230),
		iconCls:'icon-w-paper',
		buttons:[{
			text:'保存',
			iconCls:'icon-w-save',
			handler:function(){
				saveBedShift(rowData[index].BsItmID)
				}
		},{
			text:'取消',
			iconCls:'icon-w-close',
			handler:function(){
				$('#BedShiftWin').dialog('close');
			}
		}]
	};
	
	$HUI.dialog('#BedShiftWin', $.extend({},option));
	$('#BedShiftWin').dialog('open');
	InitShiftPanel(rowData[index]);  /// 初始化加班内容Panel
}

/// 初始化加班内容Panel
function InitShiftPanel(row){
	
	$('#BsPatDiag').val(row.PatDiag);        /// 病人诊断
	$('#BsVitalSign').val(row.BsVitalSign);  /// 生命体征
	$('#BsContents').val(row.BsContents);    /// 交班内容
	$('#BsNotes').val(row.BsNotes);          /// 备注
	$('#BsMedHis').val(row.BsMedHis);        /// 病史
	$('#BsTreatMet').val(row.BsTreatMet);    /// 治疗方式
	$('#BsCotNumber').val(row.BsCotNumber);  /// 联系方式
	
}

/// 保存交班数据
function InsBedMas(){

	var MedGrpID = $HUI.combobox("#MedGrp").getValue(); /// 医疗小组
	if ((MedGrpID == "")&(EmType == "Doc")){
		$.messager.alert("提示:","请选择医疗小组！","warning");
		return;
	}
	var WardID=$HUI.combobox("#Ward").getValue();      /// 交班病区
	if (WardID == ""){
		$.messager.alert("提示:","留观区不能为空！","warning");
		return;
	}
	var Schedule=$HUI.combobox("#Schedule").getValue();  /// 交班班次
	if (Schedule == ""){
		$.messager.alert("提示:","班次不能为空！","warning");
		return;
	}
	var WrDate=$HUI.datebox("#WrDate").getValue();       /// 交班日期
	
	var rowData = $('#bmDetList').datagrid('getRows');
	if ((typeof rowData == "undefined")||(rowData == "")){
		//alert(rowData)
		$.messager.alert("提示:","没有待保存病人信息！","warning");
		return;
	}
	
	///             交班日期  +"^"+  留观区  +"^"+  班次  +"^"+  交班类型  +"^"+  交班人员  +"^"+  医生分组
	var mListData = WrDate +"^"+ WardID +"^"+ Schedule +"^"+ EmType +"^"+ LgUserID +"^"+ MedGrpID;

	/// 保存
	runClassMethod("web.DHCEMBedSideShift","Insert",{"BsID":BsID, "mListData":mListData, "Pid":Pid},function(jsonString){
		if (jsonString < 0){
		   if(jsonString == "-1"){
			   $.messager.alert("提示:","该班次已有记录，请到<font style='color:red;font-weight:bold;'>已保存查询</font>里面查询！","warning");
	       }else{
			   $.messager.alert("提示:","交班主信息保存失败，失败原因:"+jsonString,"warning");
		   }
		}else{
			GetEmShift(jsonString);  /// 获取交班信息
			$.messager.alert("提示:","保存成功！","warning");
		}
	},'',false)
}

/// 保存交班数据
function saveBedShift(BsItmID){

	var BsPatDiag=$('#BsPatDiag').val();  /// 病人诊断
//	if (BsPatDiag == ""){
//		$.messager.alert("提示:","病人诊断不能为空！");
//		return;
//	}

	var BsVitalSign=$('#BsVitalSign').val();  /// 生命体征
//	if (BsVitalSign == ""){
//		$.messager.alert("提示:","生命体征不能为空！");
//		return;
//	}
	var BsContents=$('#BsContents').val();  /// 交班内容
	if (BsContents == ""){
		$.messager.alert("提示:","交班内容不能为空！");
		return;
	}
	
	var BsNotes = $('#BsNotes').val();  /// 备注
	
	var BsMedHis=$('#BsMedHis').val();  /// 病史内容
//	if (BsMedHis == ""){
//		$.messager.alert("提示:","病史不能为空！");
//		return;
//	}
	
	var BsTreatMet=$('#BsTreatMet').val();  /// 治疗方式
	if (BsTreatMet == ""){
		$.messager.alert("提示:","治疗方式不能为空！");
		return;
	}
	
	var BsCotNumber=$('#BsCotNumber').val();  /// 联系方式
//	if (BsCotNumber == ""){
//		$.messager.alert("提示:","联系方式不能为空！");
//		return;
//	}
//		
	
	///             病人诊断  +"^"+  生命体征  +"^"+  交班内容  +"^"+  备注   +"^"+  病史 +"^"+  治疗方式  +"^"+ 联系方式
	var mListData = BsPatDiag +"^"+ BsVitalSign +"^"+ BsContents +"^"+ BsNotes+"^"+BsMedHis+"^"+BsTreatMet+"^"+BsCotNumber;

	/// 保存
	runClassMethod("web.DHCEMBedSideShift","UpdBedItem",{"BsItmID":BsItmID, "mListData":mListData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示:","交班内容保存失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示:","保存成功！","warning");
			$('#BedShiftWin').dialog('close');  /// 关闭交班内容窗口
			$("#bmDetList").datagrid("reload");
		}
	},'',false)
}

/// 加载交班信息
function GetEmShift(InBsID){
	BsID = InBsID;
	GetEmShiftObj(BsID);  /// 初始化加载加班主信息
	$("#bmDetList").datagrid("load",{"Params":BsID});
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

/// 引用生命体征
function OpenSign(){
	var url="dhcem.patemrque.csp?&EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&targetName=Attitude"+"&TextValue="; //+obj.text;
	var result = window.showModalDialog(url,"_blank",'dialogTop:0;dialogWidth:'+(window.screen.availWidth-200)+'px;DialogHeight='+(window.screen.availHeight-200)+'px;dialogTop=100px;center=1'); 
	try{
		if (result){
			if ($("#BsVitalSign").val() == ""){
				$("#BsVitalSign").val(result.innertTexts);  		/// 生命体征
			}else{
				$("#BsVitalSign").val($("#BsVitalSign").val()  +"\r\n"+ result.innertTexts);  		/// 生命体征
			}
			
		}
	}catch(ex){}
}

//引用治疗
function OpenTreatMet(){
	var url="dhcem.patemrque.csp?&EpisodeID="+EpisodeID+"&targetName=Attitude"+"&TextValue="; //+obj.text;
	var result = window.showModalDialog(url,"_blank",'dialogTop:0;dialogWidth:'+(window.screen.availWidth-200)+'px;DialogHeight='+(window.screen.availHeight-200)+'px;dialogTop=100px;center=1'); 
	try{
		if (result){
			if ($("#BsTreatMet").val() == ""){
				$("#BsTreatMet").val(result.innertTexts);  		/// 治疗
			}else{
				$("#BsTreatMet").val($("#BsTreatMet").val()  +"\r\n"+ result.innertTexts);  		/// 治疗
			}
			
		}
	}catch(ex){}
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
	
	$("#find").linkbutton('disable');  /// 查询按钮
	$("#save").linkbutton('disable');  /// 保存按钮
}

/// 清空页面元素内容
function ClrPagesEl(){
	
	BsID = "";      /// 交班ID
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
	$("#bmDetList").datagrid("loadData", { total: 0, rows: [] });
	
	$("#find").linkbutton('enable');  /// 查询按钮
	$("#save").linkbutton('enable');  /// 保存按钮
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

/// 删除交班记录
function DelShifts(){

	if (BsID == ""){
		$.messager.alert("提示:","请先选中一次交班记录后，重试！");
		return;
	}
	$.messager.confirm('确认对话框','确定要删除当前交班记录吗！', function(r){
		if (r){
			runClassMethod("web.DHCEMBedSideShift","DelBedSideShift",{"BsID":BsID},function(jsonString){

				if (jsonString < 0){
					$.messager.alert("提示:","删除交班记录失败，失败原因:"+jsonString,"warning");
				}else{
					$.messager.alert("提示:","删除成功！");
					ClrPagesEl(); /// 清空界面内容
				}
			},'',false)
		}
	});
}

/// 交班列表窗口
function ShowBedLisWin(){
	
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		closed:"true",
		iconCls:'icon-w-paper'
	};
	new WindowUX('交班列表窗口', 'BedLisWin', (window.screen.availWidth-100), (window.screen.availHeight-150), option).Init();
	$("#LisFrame").attr("src","dhcem.bedsideshiftquery.csp?EmType="+EmType);
}

/// 关闭交班列表窗口
function CloseBedListWin(){
	
	$("#BedLisWin").window('close');
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

window.onbeforeunload = onbeforeunload_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
