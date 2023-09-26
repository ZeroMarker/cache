// DHCPEItemExecutionStatus.hisui.js
// by zhongricheng

$(function() {
	InitCombobox();
	
	$("#BSearch").click(function() {  // ������ѯ
		BSearch_click();
    });
    
    $("#BClear").click(function() {  // ������ѯ
		BClear_click();
    });
});

function InitCombobox() {
	// �Ա�
	$HUI.combobox("#Sex", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'',text:'����'},
			{id:'1',text:'��'},
			{id:'2',text:'Ů'}
		]
	});
	
	// վ��
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
	
	// �ܼ�״̬
	$HUI.combobox("#AuditStatus", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'',text:'����'},
			{id:'NA',text:'δ�ܼ�'},
			{id:'A',text:'���ܼ�'}
		]
	});
	
	// ��Ŀ
	$HUI.combobox("#ItemID", {
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationOrder&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		//editable:false,
		defaultFilter:4
	});
	
	// VIP�ȼ�
	$HUI.combobox("#VIPLevel", {
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		//editable:false,
		onSelect:function(record){
		}
	});
	
	// ����
	$HUI.combobox("#PERoom", {
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindRoomPlace&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		//editable:false,
		onSelect:function(record){
		}
	});
	
	// ���״̬
	$HUI.combobox("#ChcekStatus", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'',text:'����'},
			{id:'NC',text:'ȫ��δ��'},
			{id:'PC',text:'�����Ѽ�'},
			{id:'AC',text:'ȫ���Ѽ�'}//,
			//{id:'RC',text:'л�����'}
		]
	});
	
	// ��Ŀ״̬
	$HUI.combobox("#ItemStatus", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'',text:'����'},
			{id:'V',text:'��ʵ'},
			{id:'E',text:'ִ��'},
			{id:'R',text:'л�����'}
		]
	});
	
	// ��ѯ����
	$HUI.combobox("#ShowType", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'PAADM',text:'����Ա��ѯ',selected:true},
			{id:'ITEM',text:'����Ŀ��ѯ'}
		]
	});
}

// ��ѯ
function BSearch_click(){
	var BeginDate = "", EndDate = "", Sex = "", VIPLevel = "", Station = "", PERoom = "", AuditStatus = "", ChcekStatus = "", ItemID = "", ItemStatus = "", CurLoc = "";
	var BeginDate = $("#BeginDate").datebox('getValue');
	/*if (BeginDate == "") {
		$.messager.alert("��ʾ","�����뿪ʼ���ڣ�");
		//$.messager.popover({msg:"�����뿪ʼ���ڣ�", type:"alert", timeout: 3000, showType:"slide"});
		return false;
	}*/
	
	var EndDate = $("#EndDate").datebox('getValue');
	/*if (EndDate == "") {
		$.messager.alert("��ʾ","������������ڣ�");
		//$.messager.popover({msg:"������������ڣ�", type:"alert", timeout: 3000, showType:"slide"});
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