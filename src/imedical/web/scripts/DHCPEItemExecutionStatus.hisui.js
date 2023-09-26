// DHCPEItemExecutionStatus.hisui.js
// by zhongricheng

$(function() {
	InitCombobox();
	
	$("#BSearch").click(function() {  // 体征查询
		BSearch_click();
    });
    
    $("#BClear").click(function() {  // 体征查询
		BClear_click();
    });
});

function InitCombobox() {
	// 性别
	$HUI.combobox("#Sex", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'',text:'不限'},
			{id:'1',text:'男'},
			{id:'2',text:'女'}
		]
	});
	
	// 站点
	$HUI.combobox("#Station", {
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationByType&Type=NLX&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		//editable:false,
		onSelect:function(record) {
			var StationId = record.id;
			var url = $URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationOrder&ResultSetType=array&Station=" + StationId;
			$("#ItemID").combobox('reload',url);
		},
		onChange:function(newValue, oldValue) {
			var ItemID = $("#ItemID").combobox('getValue');
			var Flag=tkMakeServerCall("web.DHCPE.HISUICommon","GetStationFlag",newValue,ItemID);
			if (Flag==0) {
			    $("#ItemID").combobox('setValue',"");
			}
			/*if (newValue == "" || newValue == "undefined" || newValue == undefined) {
				var url = $URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationOrder&ResultSetType=array&Station=";
				$("#ItemID").combobox('reload',url);				
			}*/
		}
	});
	
	// 总检状态
	$HUI.combobox("#AuditStatus", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'',text:'不限'},
			{id:'NA',text:'未总检'},
			{id:'A',text:'已总检'}
		]
	});
	
	// 项目
	$HUI.combobox("#ItemID", {
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationOrder&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		//editable:false,
		defaultFilter:4
	});
	
	// VIP等级
	$HUI.combobox("#VIPLevel", {
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		//editable:false,
		onSelect:function(record){
		}
	});
	
	// 诊室
	$HUI.combobox("#PERoom", {
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindRoomPlace&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		//editable:false,
		onSelect:function(record){
		}
	});
	
	// 检查状态
	$HUI.combobox("#ChcekStatus", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'',text:'不限'},
			{id:'NC',text:'全部未检'},
			{id:'PC',text:'部分已检'},
			{id:'AC',text:'全部已检'}//,
			//{id:'RC',text:'谢绝检查'}
		]
	});
	
	// 项目状态
	$HUI.combobox("#ItemStatus", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'',text:'不限'},
			{id:'V',text:'核实'},
			{id:'E',text:'执行'},
			{id:'R',text:'谢绝检查'}
		]
	});
	
	// 查询类型
	$HUI.combobox("#ShowType", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'PAADM',text:'按人员查询',selected:true},
			{id:'ITEM',text:'按项目查询'}
		]
	});
}

// 查询
function BSearch_click(){
	var BeginDate = "", EndDate = "", Sex = "", VIPLevel = "", Station = "", PERoom = "", AuditStatus = "", ChcekStatus = "", ItemID = "", ItemStatus = "", CurLoc = "";
	var BeginDate = $("#BeginDate").datebox('getValue');
	/*if (BeginDate == "") {
		$.messager.alert("提示","请输入开始日期！");
		//$.messager.popover({msg:"请输入开始日期！", type:"alert", timeout: 3000, showType:"slide"});
		return false;
	}*/
	
	var EndDate = $("#EndDate").datebox('getValue');
	/*if (EndDate == "") {
		$.messager.alert("提示","请输入结束日期！");
		//$.messager.popover({msg:"请输入结束日期！", type:"alert", timeout: 3000, showType:"slide"});
		return false;
	}*/
	
	var Sex = $("#Sex").combobox('getValue');
	
	var VIPLevel = $("#VIPLevel").combobox('getValue');
	if (VIPLevel == "undefined" || VIPLevel == undefined) VIPLevel = "";
	
	var Station = $("#Station").combobox('getValue');
	if (Station == "undefined" || Station == undefined) Station = "";
	
	var PERoom = $("#PERoom").combobox('getValue');
	if (PERoom == "undefined" || PERoom == undefined) PERoom = "";
	
	var AuditStatus = $("#AuditStatus").combobox('getValue');
	var ChcekStatus = $("#ChcekStatus").combobox('getValue');
	
	var ItemID = $("#ItemID").combobox('getValue');
	if (ItemID == "undefined" || ItemID == undefined) ItemID = "";
	
	var ItemStatus = $("#ItemStatus").combobox('getValue');
	
	var ShowType = $("#ShowType").combobox('getValue');
	
	var CurLoc = session["LOGON.CTLOCID"];
	
	var src = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&Sex=" + Sex
			+ "&VIPLevel=" + VIPLevel
			+ "&Station=" + Station
			+ "&PERoom=" + PERoom
			+ "&AuditStatus=" + AuditStatus
			+ "&ChcekStatus=" + ChcekStatus
			+ "&ItemID=" + ItemID
			+ "&ItemStatus=" + ItemStatus
			+ "&ShowType=" + ShowType
			+ "&CurLoc=" + CurLoc
			;
	
	if (ShowType == "PAADM") {
		$("#ReportFile").attr("src", "dhccpmrunqianreport.csp?reportName=DHCPEItemExecutionStatus.raq" + src);
	} else if (ShowType == "ITEM") {
		$("#ReportFile").attr("src", "dhccpmrunqianreport.csp?reportName=DHCPEItemExecutionStatusForItem.raq" + src);
	}
}

function BClear_click(){
	$("#BeginDate").datebox('setValue',"");
	$("#EndDate").datebox('setValue',"");
	$(".hisui-combobox").combobox('setValue',"");

	$("#ShowType").combobox('setValue',"PAADM");
	InitCombobox();
	BSearch_click();
}