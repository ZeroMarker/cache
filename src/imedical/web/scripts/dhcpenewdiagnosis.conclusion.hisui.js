///����: 	
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
			if (ret[0]=="-1") {$.messager.alert("��ʾ","����ʧ��","info");window.location.reload();}
			else {$.messager.alert("��ʾ","���³ɹ�","info"); window.location.reload();}
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
		textField:'TDesc'
	})
	
	// ��ϱ�׼
	var DCObj = $HUI.combobox("#DiagnosticCriteria",{
		url:$URL+"?ClassName=web.DHCPE.DiagnosticCriteria&QueryName=SearchDiagnosticCriteria&ResultSetType=array",
		valueField:'TID',
		textField:'TDesc'
	})	
}
