
//名称	DHCPEReportSetting.hisui.js
//功能	体检报告配置
//创建	2021.02.22
//创建人  xy
$(function(){
		
	InitCombobox();
	
	InitReportSettingGrid();
   
    //保存
	$("#BSave").click(function() {	
		BSave_click();		
        });
       
   
})
function BSave_click()
{
	//科室
	var NowLoc=$("#NowLoc").combogrid("getValue");
	if (($("#NowLoc").combogrid('getValue')==undefined)||($("#NowLoc").combogrid('getText')=="")){var NowLoc="";}
	if(NowLoc=="") 
	{
		$.messager.alert("提示","请选择需要设置的科室!","info");
		return;
	}
	if(NowLoc!="")
	{
		if (($("#NowLoc").combogrid('getValue'))==($("#NowLoc").combogrid('getText')))  {
			$.messager.alert("提示","科室选择不正确!","info");
			return false;
		}
		
	}
	
	//检查报告上传ftp
	var str=$("#PhotoFTP").val();
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"PhotoFTP",str);
	
	//体检报告ftp
	var str=$("#ReportFTP").val();
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"ReportFTP",str);
	
	
	//网上查看报告
	var str=$("#NetReport").switchbox("getValue");
	if(str) {str="Y",NetReport="Y";}
	else {str="N",NetReport="N"; }
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"NetReport",str);
	
	//体检报告格式
	 var str=getValueById("NewVerReport")
	if(str=="Word") { NewVerReport="Y";}
	else {NewVerReport="N";}
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"NewVerReport",str);
	 
	 if((NewVerReport=="Y")&&(NetReport=="N")){
	    $.messager.alert("提示","新版报告启用，网上查看报告必须启用!","info");
	    return false;
	    }
	    
	 //报告代码
	 var str=$("#ReportCode").val();
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"ReportCode",str);
	
	//复查打印报告
	var str=$("#MainReportPrint").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"MainReportPrint",str);
	
	//合并标本号打印化验
	var str=$("#LisReportMerge").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"LisReportMerge",str);
	
	//显示建议结论符号
	var str=$("#ShowEDDiagnosisSign").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"ShowEDDiagnosisSign",str);
	
	$.messager.alert("提示","设置成功!","success");
	
	$("#ReportSettingGrid").datagrid('load',{
			ClassName:"web.DHCPE.HISUICommon",
			QueryName:"FindReportSetting",
			HospID:session['LOGON.HOSPID']
			
		});
		
	BClear_click();
}

//清屏
function BClear_click(){

	$("#ReportCode,#PhotoFTP,#ReportFTP").val("");
	$(".hisui-combobox").combobox("setValue","");
	$(".hisui-combogrid").combogrid("setValue","");
	$(".hisui-switchbox").switchbox("setValue",true);
	
}

function SetReportDataByLoc(loc)
{
	
	//体检报告ftp
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"ReportFTP");
	$("#ReportFTP").val(ret)
	
	
	//检查报告上传ftp
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"PhotoFTP");
	$("#PhotoFTP").val(ret)
	
	//体检报告格式
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"NewVerReport");
	$("#NewVerReport").val(ret)
	
	//报告代码
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"ReportCode");
	$("#ReportCode").val(ret)
	
	//复查打印报告
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"MainReportPrint");
	if(ret=="Y")	$("#MainReportPrint").switchbox("setValue",true);
	else	$("#MainReportPrint").switchbox("setValue",false);
	
	//网上查看报告
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"NetReport");
	if(ret=="Y")	$("#NetReport").switchbox("setValue",true);
	else	$("#NetReport").switchbox("setValue",false)

	//合并标本号打印化验
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"LisReportMerge");
	if(ret=="Y")	$("#LisReportMerge").switchbox("setValue",true);
	else	$("#LisReportMerge").switchbox("setValue",false)
	
	//显示建议结论符号
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"ShowEDDiagnosisSign");
	if(ret=="Y")	$("#ShowEDDiagnosisSign").switchbox("setValue",true);
	else	$("#ShowEDDiagnosisSign").switchbox("setValue",false)
}
function InitReportSettingGrid()
{
	
		$HUI.datagrid("#ReportSettingGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.HISUICommon",
			QueryName:"FindReportSetting",
			HospID:session['LOGON.HOSPID']
		},
		columns:[[
		{field:'Loc',title:'Loc'},
		{field:'LocDesc',title:'科室'},
		{field:'PhotoFTP',title:'检查报告上传ftp'},
		{field:'ReportFTP',title:'体检报告ftp'},
		{field:'NetReport',title:'网上查看报告'},
		{field:'NewVerReport',title:'体检报告格式'},
		{field:'ReportCode',title:'报告代码'},
		{field:'MainReportPrint',title:'复查打印报告'},
		{field:'LisReportMerge',title:'合并标本号打印化验'},
		{field:'ShowEDDiagnosisSign',title:'显示建议结论符号'}

		]],
		onSelect: function (rowIndex, rowData) {
			   
			var loc=rowData.Loc;
			var LocDesc=rowData.LocDesc;
			$('#NowLoc').combogrid('grid').datagrid('reload',{'q':LocDesc});
			setValueById("NowLoc",loc)
			SetReportDataByLoc(loc)	
				
					
		}
		
			
	})
	
}

function InitCombobox()
{
	
	//科室
	var NowLocObj = $HUI.combogrid("#NowLoc",{
		panelWidth:300,
		url:$URL+"?ClassName=web.DHCPE.Public.SettingEdit&QueryName=Querytest",
		mode:'remote',
		delay:200,
		idField:'CTLOCID',
		textField:'Desc',
		onBeforeLoad:function(param){
			param.ctlocdesc = param.q;
			param.hospId = session['LOGON.HOSPID'];
		},
		
		columns:[[
			{field:'CTLOCID',hidden:true},
			{field:'CTLOCCODE',title:'科室编码',width:100},
			{field:'Desc',title:'科室名称',width:200}
			
			
			
		]]
	});
}