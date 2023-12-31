///名称:	dhcpenewdiagnosis.conclusion.hisui.js	
///描述:	HISUI改造 总检初审/总检信息/检查结论
///编写者：	jinlei	
///编写日期: 2020/2/21
///产品组：	体检

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
				{field:'TDesc', title:'处理意见'}
			]],
			collapsible:true, //收起表格的内容
			border:false,
			lines:false,
			striped:true, // 条纹化
			rownumbers:true,
			fit:true,
			fitColumns:true,
			animate:true,
			pagination:true,
			pageSize:15,
			pageList:[15,30,50],
			singleSelect:true,
			onClickRow: function (rowIndex, rowData) {  // 选择行事件
				var ov = $("#Suggestions").val();
				$("#Suggestions").val(ov + rowData.TDesc);
			},
			onLoadSuccess:function(data) {
				
			}
		}
    });
}

//保存
function BSave_click(){
	if (GSID=="") {$.messager.alert("提示","还未初审提交","info");return false;}
	var 
	Conclusion=$("#Conclusion").combobox('getValue'),
	DiagnosticCriteria=$("#DiagnosticCriteria").combobox('getValue'),
	Suggestions=$("#Suggestions").val(),
	TestResult=$("#TestResult").val(),
	Clinical=$("#Clinical").val(),
	OccupationalHistory=$("#OccupationalHistory").val();
	
	if (Conclusion==""){
		$.messager.alert("提示","结论不能为空","info");
		return false;
	}
	var 
	Str=Conclusion+"^"+DiagnosticCriteria+"^"+Suggestions+"^"+TestResult+"^"+Clinical+"^"+OccupationalHistory;
	$.m({ ClassName:"web.DHCPE.GeneralSummarizeEx", MethodName:"Save",GSID:GSID,Str:Str},
		function(ReturnValue){
			var ret=ReturnValue.split("^");
			if (ret[0]=="-1") {$.messager.alert("提示","更新失败","info");}
			else {$.messager.alert("提示","更新成功","info"); }
		})
}

function InitCombobox()
{	
	var iVIP=$("#VIPLevel").val(); 
	// 职业病结论分类
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
	
	// 诊断标准
	var DCObj = $HUI.combobox("#DiagnosticCriteria",{
		url:$URL+"?ClassName=web.DHCPE.DiagnosticCriteria&QueryName=SearchDiagnosticCriteria&ResultSetType=array",
		valueField:'TID',
		textField:'TDesc'
	})	
}
