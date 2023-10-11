///����:	dhcpenewdiagnosis.conclusion.hisui.js	
///����:	HISUI���� �ܼ����/�ܼ���Ϣ/������
///��д�ߣ�	jinlei	
///��д����: 2020/2/21
///��Ʒ�飺	���

$(function(){

	InitCombobox();

	$("#BSave").click(function() {	
		BSave_click();		
        }); 
		
    SetDefault();	
})

function SetDefault()
{
	$.m({ ClassName:"web.DHCPE.GeneralSummarizeEx", MethodName:"GetGSExInfo",GSID:GSID},
		function(ReturnValue){
			if (ReturnValue=="") return false;
			var 
			Info=ReturnValue.split("^");
			$("#Conclusion").combobox('setValue',Info[0]),
			$("#DiagnosticCriteria").combobox('setValue',Info[2]),
			$("#Suggestions").val(Info[3]),
			$("#TestResult").val(Info[4]),
			$("#Clinical").val(Info[5]),
			$("#OccupationalHistory").val(Info[6]);

		}
	);
	
	$("#Suggestions").comboinput({
        title: "",
        panelHeight: 150,
        comboType: "datagrid",
        panelEvent: "focus",
        comboParams: {
			url:$URL,
			queryParams:{
				/*
				ClassName:"web.DHCPE.HandlingOpinions",
				QueryName:"QueryHO",
				Conclusion:$("#Conclusion").combobox('getValue'),
				OMEType:"",
				Active:"Y"
				*/
				ClassName:"web.DHCPE.CT.HandlingOpinions",
				QueryName:"SearchEffHandOpts",
				Conclusion:$("#Conclusion").combobox('getValue'),
				OMEType:"",
				Active:"Y",
				LocID:session['LOGON.CTLOCID'],

			},
			columns:[[
				{field:'TID', title:'TID', hidden:true},
				{field:'TDesc', title:'�������'}
			]],
			collapsible:true, //�����������
			border:false,
			lines:false,
			striped:true, // ���ƻ�
			rownumbers:true,
			fit:true,
			fitColumns:true,
			animate:true,
			pagination:true,
			pageSize:15,
			pageList:[15,30,50],
			singleSelect:true,
			onClickRow: function (rowIndex, rowData) {  // ѡ�����¼�
				var ov = $("#Suggestions").val();
				$("#Suggestions").val(ov + rowData.TDesc);
			},
			onLoadSuccess:function(data) {
				
			}
		}
    });
}

//����
function BSave_click(){
	if (GSID=="") {$.messager.alert("��ʾ","��δ�����ύ","info");return false;}
	var 
	Conclusion=$("#Conclusion").combobox('getValue'),
	DiagnosticCriteria=$("#DiagnosticCriteria").combobox('getValue'),
	Suggestions=$("#Suggestions").val(),
	TestResult=$("#TestResult").val(),
	Clinical=$("#Clinical").val(),
	OccupationalHistory=$("#OccupationalHistory").val();
	
	if (Conclusion==""){
		$.messager.alert("��ʾ","���۲���Ϊ��","info");
		return false;
	}
	var 
	Str=Conclusion+"^"+DiagnosticCriteria+"^"+Suggestions+"^"+TestResult+"^"+Clinical+"^"+OccupationalHistory;
	$.m({ ClassName:"web.DHCPE.GeneralSummarizeEx", MethodName:"Save",GSID:GSID,Str:Str},
		function(ReturnValue){
			var ret=ReturnValue.split("^");
			if (ret[0]=="-1") {$.messager.alert("��ʾ","����ʧ��","info");}
			else {$.messager.alert("��ʾ","���³ɹ�","info"); }
		})
}

function InitCombobox()
{	
	var iVIP=$("#VIPLevel").val(); 
	// ְҵ�����۷���
	var ConclusionObj = $HUI.combobox("#Conclusion",{
		url:$URL+"?ClassName=web.DHCPE.Conclusion&QueryName=FindConclusion&Active=Y&VIPLevel="+iVIP+"&ResultSetType=array",
		//url:$URL+"?ClassName=web.DHCPE.Conclusion&QueryName=FindConclusion&ResultSetType=array",
		valueField:'TRowId',
		textField:'TDesc',
		onSelect:function(record) {
			$("#Suggestions").comboinput("load", {
				queryParams:{
					ClassName:"web.DHCPE.CT.HandlingOpinions",
					QueryName:"SearchEffHandOpts",
					Conclusion:$("#Conclusion").combobox('getValue'),
					OMEType:"",
					Active:"Y",
					LocID:session['LOGON.CTLOCID']
				}
			});
		}
	})
	
	// ��ϱ�׼
	var DCObj = $HUI.combobox("#DiagnosticCriteria",{
		url:$URL+"?ClassName=web.DHCPE.DiagnosticCriteria&QueryName=SearchDiagnosticCriteria&ResultSetType=array",
		valueField:'TID',
		textField:'TDesc'
	})	
}
