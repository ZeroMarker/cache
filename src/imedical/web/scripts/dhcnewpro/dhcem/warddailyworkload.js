//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2018-11-16
// 描述:	   急诊病区日工作量统计
//===========================================================================================

var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var ItemTypeArr = [{"value":$g("早班"),"text":$g('早班')}, {"value":$g("中班"),"text":$g('中班')}, {"value":$g("夜班"),"text":$g('夜班')}];;

/// 页面初始化函数
function initPageDefault(){
	
	/// 初始化信息列表
	InitMain();
	
	/// 初始化病人基本信息
	InitPatInfoPanel();
	
	/// 初始化Table列表
	InitWorkLoadItem();
}

/// 初始化病人基本信息
function InitPatInfoPanel(){
	
	/// 开始日期
	$HUI.datebox("#StartDate").setValue(GetCurSystemDate(-1));
	
	/// 结束日期
	$HUI.datebox("#EndDate").setValue(GetCurSystemDate(0));
	
	/// 班次
	var uniturl = $URL+"?ClassName=web.DHCEMTimeInterval&MethodName=jsonTimeInterval&HospID="+ LgHospID +"&Module=Nur";
	$HUI.combobox("#Schedule",{
		url:uniturl,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	    }	
	})
	
	/// 病区
	var uniturl = $URL+"?ClassName=web.DHCEMPatCheckLevCom&MethodName=jsonGetEmLoc&HospID="+LgHospID;
	$HUI.combobox("#Ward",{
		url:uniturl,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	    }	
	})
		
	/// 病区
	$HUI.combobox("#InWard",{
		url:uniturl,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	    }	
	})
	
	/// 监听文本框键盘数据
	$("#itemList").on("keyup","input[name='item']",function(){
		$(this).val($(this).val().replace(/[^\d]/g,""));
	})
	
		
	/// 业务日期
	$('#WrDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});

}

/// 提取表格列内容
function InitMain(){
	
	// 获取显示数据
	runClassMethod("web.DHCEMTriageDailyWordLoad","JsGetTriColumns",{"mCode":"WWL", "HospID":session['LOGON.HOSPID']},function(jsonString){

		if (jsonString != null){
			InitMainList(jsonString)
		}
	},'json',false)
}

/// 页面DataGrid初始定义已选列表
function InitMainList(columns){
	
	///  定义columns
	var fcolumns=[[
		{field:'ID',title:'ID',width:100,align:'center'},
		{field:'CreateDate',title:'记录日期',width:100,align:'center'},
		{field:'CreateTime',title:'记录时间',width:100,align:'center'},
		{field:'CrBusDate',title:'业务日期',width:100,align:'center'},
		{field:'Schedule',title:'班次',width:100,align:'center'},
		{field:'CrLocID',title:'急诊单元ID',width:100,align:'center',hidden:true},
		{field:'CrLoc',title:'急诊单元',width:180,align:'center'},
		{field:'CreateUser',title:'填报人',width:100,align:'center'}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		frozenColumns:fcolumns,
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onLoadSuccess:function(data){
			//$("#bmDetList").datagrid("loadData",{"total":1,"rows":[{}]})

		},
		onDblClickRow: function (rowIndex, rowData) {
			WriteMdt(rowData.EpisodeID, rowData.CstID);
        },
        rowStyler:function(rowIndex, rowData){
			if (rowData.AuditFlag == "已审"){
				return 'background-color:pink;';
			}
		}
	};
	/// 就诊类型
	var param = "^^"+ LgHospID +"^WWL";
	var uniturl = $URL+"?ClassName=web.DHCEMTriageDailyWordLoad&MethodName=JsGetTriWorkLoadList&Params="+param;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// 加载Table列表
function InitWorkLoadItem(){
	
	/// 初始化检查方法区域
	//$("#itemList").html('<tr style="height:0;"><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	// 获取显示数据
	runClassMethod("web.DHCEMTriageDailyWordLoad","JsGetTriColumns",{"mCode":"WWL", "HospID":session['LOGON.HOSPID']},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				InitCheckItemRegion(jsonObjArr[i]);
			}
		}
	},'json',false)
}

/// 检查方法列表
function InitCheckItemRegion(itemArr){	

	/// 项目
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		
		itemhtmlArr.push('<td align="right" class="tb_td_bk">'+ itemArr[j-1].title +'</td><td><input id="'+ itemArr[j-1].field +'" name="item" class="hisui-validatebox" style="width:170px;"></input></td>');
		if (j % 4 == 0){
			itemhtmlstr = itemhtmlstr + '<tr class="tr">' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
	if ((j-1) % 4 != 0){
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

/// 查询
function QryTriWorkLoad(){
	
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// 开始日期
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// 结束日期
	var WardID = $HUI.combobox("#Ward").getValue();        /// 急诊单元
	var params = StartDate +"^"+ EndDate +"^"+ LgHospID + "^WWL" +"^"+ (WardID||"");
	$("#bmDetList").datagrid("load",{"Params":params});
}

/// 修改
function updTriWorkLoad(){
	
	var rowsData = $("#bmDetList").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		GetTriWorkInfo(rowsData);
		newTriWin($g("修改"));        /// 新建窗口
	}else{
		$.messager.alert("提示:","请先选中待处理行！","warning");
	}
}

/// 提取派车信息
function GetTriWorkInfo(rowsData){
	
	/// 填写日期
	$HUI.datebox("#WrDate").setValue(rowsData.CrBusDate);
	/// 班次
	$HUI.combobox("#Schedule").setValue(rowsData.Schedule);
	/// 急诊单元
	$HUI.combobox("#InWard").setValue(rowsData.CrLocID);
	/// 填报人
	$("#LgUser").text(rowsData.CreateUser);
	/// 记录ID
	$("#WLID").text(rowsData.ID);
	$("input[name='item']").each(function(){
		$(this).val(rowsData[this.id]||"");
	})
}

/// 新建急救车派车窗口
function newTriWorkLoad(){
	
//	var rowData = $('#bmDetList').datagrid('getSelected');
//	if (rowData == null){
//		$.messager.alert('提示',"请先选择一行记录!","error");
//		return;
//	}
	
	newTriWin($g("填报"));       /// 新建急救车派车窗口
	InitTriDefault();  /// 初始化界面默认信息
}

/// 新建窗口
function newTriWin(title){
	var option = {
			buttons:[{
				text:$g('保存'),
				iconCls:'icon-w-save',
				handler:function(){
					InsTriWorkLoad();
					}
			},{
				text:$g('取消'),
				iconCls:'icon-w-cancel',
				handler:function(){
					$('#newConWin').dialog('close');
				}
			}]
		};
	new DialogUX($g('急诊病区日工作量')+title, 'newConWin', '1200', '700', option).Init(); //hxy 2020-06-03 title

}

/// 初始化界面默认信息
function InitTriDefault(){

	/// 填写日期
	$HUI.datebox("#WrDate").setValue(GetCurSystemDate(0));
	$("input[name='item']").val("");
	$HUI.combobox("#Schedule").setValue(""); /// 班次
	$HUI.combobox("#InWard").setValue("");   /// 急诊单元
	$("#WLID").text("");		/// 记录ID
	$("#LgUser").text(session['LOGON.USERNAME']); /// 填报人
}

/// 保存急诊分诊区日工作量统计
function InsTriWorkLoad(){
	
    /// 工作量记录ID
	var WLID = $('#WLID').text();
	var items = $("input[name='item']"); /// 工作量分项
	
	var itemArr = [];
	for(var i=0; i<items.length; i++){
		if (items[i].value != ""){
			itemArr.push(items[i].id +"@"+ items[i].value);
		}
	}
	
	/// 填写日期
	var WrDate = $HUI.datebox("#WrDate").getValue();
	if (WrDate == ""){
		$.messager.alert("提示:","日期不能为空！","warning");
		return;
	}
	
	/// 班次
	var Schedule = $("#Schedule").combobox('getValue');
	if (Schedule == ""){
		$.messager.alert("提示:","班次不能为空！","warning");
		return;
	}

	/// 急诊单元
	var InWard = $("#InWard").combobox('getValue');
	if (InWard == ""){
		$.messager.alert("提示:","急诊单元不能为空！","warning");
		return;
	}
	
	/// 主信息
	var mListData = InWard +"^"+ LgUserID +"^"+ Schedule +"^"+ WrDate +"^"+ "WWL" +"^"+ itemArr.join("#");

	/// 保存
	runClassMethod("web.DHCEMTriageDailyWordLoad","Insert",{"WLID":WLID, "mListData":mListData},function(jsonString){

		if (jsonString == -1){
			$.messager.alert("提示:","保存失败，失败原因:该班次已生成，不允许重复生成！","warning");
		}else if (jsonString < 0){
			$.messager.alert("提示:","保存失败，失败原因:"+jsonString,"warning");
		}else{
			$('#newConWin').dialog('close');
			$.messager.alert("提示:","保存成功！","warning");
			$("#bmDetList").datagrid("reload");
		}
	},'',false)
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

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
