//����	DHCPEIllnessStatistic.hisui.js
//����	����ͳ��
//����	2020.12.11
//������  ln

var ScreenWidth = $(window).width();
var ScreenHeight = $(window).height();

var First = "Y";

$(function() {
	InitCombobox();
	InitData();
	
	$("#BFind").click(function() {  // ������ѯ
		BFind_click();
    });
	
	$("#CommonIllness").checkbox({

        onCheckChange:function(e,value){
		    SearchIllDesc(); 
	        
        }
    }); 
	
});

function InitCombobox() {
	
	//�Ա�
	var SexDRObj = $HUI.combobox("#SexDR",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindSex&ResultSetType=array",
		valueField:'id',
		textField:'sex',
		panelHeight:'130',
	});
	
	//����
	var MarriedDRObj = $HUI.combobox("#MarriedDR",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindMarried&ResultSetType=array",
		valueField:'id',
		textField:'married',
		panelHeight:'130',
	});
	
	// ��ͬ
	$HUI.combobox("#ContractID", {
		url:$URL+"?ClassName=web.DHCPE.Contract&QueryName=SerchContract&ResultSetType=array",
		valueField:"TID",
		textField:"TName",
		panelHeight:"auto",
		allowNull:true,
		editable:true,
		onSelect:function(record){
			var GBIDesc = $("#GBIDesc").val();
			$("#Groups").datagrid("load", {ClassName:"web.DHCPE.Report.GroupCollect",QueryName:"GADMList",GBIDesc:GBIDesc,ContractID:record.TID});
		},
		onChange:function(newValue, oldValue) {
			if (newValue =="" || newValue == undefined || newValue == "undefined" || newValue == null || newValue =="null" || newValue == "NULL") {
				$("#ContractID").combobox("setValue", "");
				var GBIDesc = $("#GBIDesc").val();
				$("#Groups").datagrid("load", {ClassName:"web.DHCPE.Report.GroupCollect",QueryName:"GADMList",GBIDesc:GBIDesc,ContractID:""});
			} 
		}
		
	});
}

function InitData() {
	InitIllnessData();
	InitGroupsListData();
}

// �����б�
function InitGroupsListData() {
	$HUI.datagrid("#Groups", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.Report.GroupCollect",
			QueryName:"GADMList",
			GBIDesc:"",
			ContractID:""
		},
		collapsible: true, //�����������
		lines:true,
		striped:true, // ���ƻ�
		rownumbers:true,
		border:false,
		fit:true,
		fitColumns:true,
		animate:true,
		//pagination:true,   // ���α�� ���ܷ�ҳ
		//pageSize:25,
		//pageList:[10,25,50,100],	
		singleSelect: false,
		checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: true,
		columns:[[
			{field:'TGRowId', title:'TGRowId', hidden:true},
			{field:'TGDesc', title:'TGDesc', hidden:true},
			{field:'TAdmDate', title:'TAdmDate', hidden:true},
			
			{field:'GroupsID', title:'ѡ��', align:'center', checkbox:true},
			{field:'GroupsDesc', title:'��������', width:8, formatter: function(value, rowData, rowIndex) {
				var title="";
				if (rowData.TGRowId == ("ALLI")) {
					title="ȫ������"
				} else if (rowData.TGRowId == ("ALLG")) {
					title="ȫ������"
				} else {
					title="�������ڣ�" + rowData.TAdmDate
				}
				return "<a id='GroupsDesc_" + rowData.TGRowId + "' href='#' title='"
						+ title
						+ "' class='hisui-tooltip' data-options='position:\"right\",showDelay:50' style='text-decoration: none;color: black;'>"
						+ rowData.TGDesc + "</a>";
				}
			}
		]],	
		onClickRow: function (rowIndex, rowData) {  // ѡ�����¼�
		},
		onDblClickRow: function (rowIndex, rowData) {  // ˫�����¼�
		},
		onLoadSuccess:function(data){
		}
	});
}

// �����б�
function InitIllnessData() {
	$HUI.datagrid("#IllDescs", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.HISUICommon",
			QueryName:"FindIllness",
			CommonIllness:"N",
			Desc:""
		},
		collapsible: true, //�����������
		lines:true,
		striped:true, // ���ƻ�
		rownumbers:true,
		border:false,
		fit:true,
		fitColumns:true,
		animate:true,
		//pagination:true,   // ���α�� ���ܷ�ҳ
		//pageSize:25,
		//pageList:[10,25,50,100],	
		singleSelect: false,
		checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: true,
		columns:[[
			{field:'id', title:'RowId', hidden:true},
			{field:'Code', title:'Code', hidden:true},
            {field:'desc', title:'desc', hidden:true},
			
			{field:'IllnessID', title:'ѡ��', align:'center', checkbox:true},
			{field:'IllnessDesc', title:'��������', width:16, formatter: function(value, rowData, rowIndex) {
                var title = "���룺" + rowData.Code;				
				return "<a id='IllnessDesc_" + rowData.id + "' href='#' title='"	
                        + title				
						+ "' class='hisui-tooltip' data-options='position:\"right\",showDelay:50' style='text-decoration: none;color: black;'>"
						+ rowData.desc + "</a>";
				}
			}
			
		]],	
		onClickRow: function (rowIndex, rowData) {  // ѡ�����¼�
		},
		onDblClickRow: function (rowIndex, rowData) {  // ˫�����¼�
		},
		onLoadSuccess:function(data){
		}
	});
}

// ����ͳ��
function BFind_click(){
	var BeginDate = "", EndDate = "", SexDR = "", MarriedDR="";
	var BeginDate = $("#BeginDate").datebox('getValue');
	var EndDate = $("#EndDate").datebox('getValue');
	
	//var AgeRange = $("#AgeFrom").val() + "-" + $("#AgeTo").val();
	var SexDR = $("#SexDR").combobox('getValue');
	if (SexDR==undefined) {var SexDR="";}
	var MarriedDR = $("#MarriedDR").combobox('getValue');
	if (MarriedDR==undefined) {var MarriedDR="";}
	
	var GADMList = "";  // ����ID DHC_PE_GADM  $ �ָ�
	var GroupsRows = $("#Groups").datagrid("getChecked");  //��ȡ�������飬��������
	for(var i = 0; i < GroupsRows.length; i++) {
		if (GADMList == "") GADMList = GroupsRows[i].TGRowId;
		else GADMList = GADMList + "^" + GroupsRows[i].TGRowId;
	}
	
	var IllnessList = "";   // ����   $ �ָ�
	var IllnessRows = $("#IllDescs").datagrid("getChecked");  //��ȡ�������飬��������
	for(var i = 0; i < IllnessRows.length; i++) {
		if (IllnessList == "") IllnessList = IllnessRows[i].id;
		else IllnessList = IllnessList + "^" + IllnessRows[i].id;
	}	
	if (IllnessList == "") {
		$.messager.alert("��ʾ", "��ѡ�񼲲��ٲ�ѯ��", "info"); 
		// $.messager.popover({msg:"��ѡ�������ٲ�ѯ��", type:"alert", timeout: 3000, showType:"slide"});
		return false;
	}
	
    var ret=tkMakeServerCall("web.DHCPE.Statistic.IllnessStatistic","SetTempIllnessGlobal",BeginDate, EndDate, MarriedDR, SexDR, IllnessList, GADMList,session['LOGON.CTLOCID'],session['LOGON.USERID'])
	var src="&BeginDate="+BeginDate+"&EndDate="+EndDate+"&USERID="+session['LOGON.USERID'];
	
	$("#ReportFile").attr("src", "dhccpmrunqianreport.csp?reportName=DHCPEIllnessStatistic.raq" + src);
	
}

// �����ѯ
function SearchGBIDesc() {
	var ContractID = $("#ContractID").combobox("getValue");
	var GBIDesc = $("#GBIDesc").val();
	
	$("#Groups").datagrid("load", {ClassName:"web.DHCPE.Report.GroupCollect",QueryName:"GADMList",GBIDesc:GBIDesc,ContractID:ContractID});
}

// ������ѯ
function SearchIllDesc() {
	var IllDesc = $("#IllDesc").val();
	var iCommonIllness="N";
	var CommonIllness=$("#CommonIllness").checkbox('getValue');
	if (CommonIllness) {iCommonIllness="Y";} 
	$("#IllDescs").datagrid("load", {ClassName:"web.DHCPE.HISUICommon",QueryName:"FindIllness",Desc:IllDesc,CommonIllness:iCommonIllness});
}
