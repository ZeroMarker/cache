
//����	DHCPEReportSetting.hisui.js
//����	��챨������
//����	2021.02.22
//������  xy
$(function(){
		
	InitCombobox();
	
	InitReportSettingGrid();
   
    //����
	$("#BSave").click(function() {	
		BSave_click();		
        });
       
   
})
function BSave_click()
{
	//����
	var NowLoc=$("#NowLoc").combogrid("getValue");
	if (($("#NowLoc").combogrid('getValue')==undefined)||($("#NowLoc").combogrid('getText')=="")){var NowLoc="";}
	if(NowLoc=="") 
	{
		$.messager.alert("��ʾ","��ѡ����Ҫ���õĿ���!","info");
		return;
	}
	if(NowLoc!="")
	{
		if (($("#NowLoc").combogrid('getValue'))==($("#NowLoc").combogrid('getText')))  {
			$.messager.alert("��ʾ","����ѡ����ȷ!","info");
			return false;
		}
		
	}
	
	//��鱨���ϴ�ftp
	var str=$("#PhotoFTP").val();
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"PhotoFTP",str);
	
	//��챨��ftp
	var str=$("#ReportFTP").val();
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"ReportFTP",str);
	
	
	//���ϲ鿴����
	var str=$("#NetReport").switchbox("getValue");
	if(str) {str="Y",NetReport="Y";}
	else {str="N",NetReport="N"; }
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"NetReport",str);
	
	//��챨���ʽ
	 var str=getValueById("NewVerReport")
	if(str=="Word") { NewVerReport="Y";}
	else {NewVerReport="N";}
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"NewVerReport",str);
	 
	 if((NewVerReport=="Y")&&(NetReport=="N")){
	    $.messager.alert("��ʾ","�°汨�����ã����ϲ鿴�����������!","info");
	    return false;
	    }
	    
	 //�������
	 var str=$("#ReportCode").val();
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"ReportCode",str);
	
	//�����ӡ����
	var str=$("#MainReportPrint").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"MainReportPrint",str);
	
	//�ϲ��걾�Ŵ�ӡ����
	var str=$("#LisReportMerge").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"LisReportMerge",str);
	
	//��ʾ������۷���
	var str=$("#ShowEDDiagnosisSign").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"ShowEDDiagnosisSign",str);
	
	$.messager.alert("��ʾ","���óɹ�!","success");
	
	$("#ReportSettingGrid").datagrid('load',{
			ClassName:"web.DHCPE.HISUICommon",
			QueryName:"FindReportSetting",
			HospID:session['LOGON.HOSPID']
			
		});
		
	BClear_click();
}

//����
function BClear_click(){

	$("#ReportCode,#PhotoFTP,#ReportFTP").val("");
	$(".hisui-combobox").combobox("setValue","");
	$(".hisui-combogrid").combogrid("setValue","");
	$(".hisui-switchbox").switchbox("setValue",true);
	
}

function SetReportDataByLoc(loc)
{
	
	//��챨��ftp
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"ReportFTP");
	$("#ReportFTP").val(ret)
	
	
	//��鱨���ϴ�ftp
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"PhotoFTP");
	$("#PhotoFTP").val(ret)
	
	//��챨���ʽ
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"NewVerReport");
	$("#NewVerReport").val(ret)
	
	//�������
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"ReportCode");
	$("#ReportCode").val(ret)
	
	//�����ӡ����
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"MainReportPrint");
	if(ret=="Y")	$("#MainReportPrint").switchbox("setValue",true);
	else	$("#MainReportPrint").switchbox("setValue",false);
	
	//���ϲ鿴����
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"NetReport");
	if(ret=="Y")	$("#NetReport").switchbox("setValue",true);
	else	$("#NetReport").switchbox("setValue",false)

	//�ϲ��걾�Ŵ�ӡ����
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"LisReportMerge");
	if(ret=="Y")	$("#LisReportMerge").switchbox("setValue",true);
	else	$("#LisReportMerge").switchbox("setValue",false)
	
	//��ʾ������۷���
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
		{field:'LocDesc',title:'����'},
		{field:'PhotoFTP',title:'��鱨���ϴ�ftp'},
		{field:'ReportFTP',title:'��챨��ftp'},
		{field:'NetReport',title:'���ϲ鿴����'},
		{field:'NewVerReport',title:'��챨���ʽ'},
		{field:'ReportCode',title:'�������'},
		{field:'MainReportPrint',title:'�����ӡ����'},
		{field:'LisReportMerge',title:'�ϲ��걾�Ŵ�ӡ����'},
		{field:'ShowEDDiagnosisSign',title:'��ʾ������۷���'}

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
	
	//����
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
			{field:'CTLOCCODE',title:'���ұ���',width:100},
			{field:'Desc',title:'��������',width:200}
			
			
			
		]]
	});
}