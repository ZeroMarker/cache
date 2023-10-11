
//����	DHCPEPublicSetting.hisui.js
//����	����������
//����	2021.02.19
//������  xy
$(function(){
		
	InitCombobox();
	
	InitPublicSettingGrid();
   
    //����
	$("#BSave").click(function() {	
		BSave_click();		
        });
     
      
    SetDefault()
   
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
	
	//����ҽ��
	var str=$("#InvDefaulltFee").combogrid("getValue");
	if (($("#InvDefaulltFee").combogrid('getValue')==undefined)||($("#InvDefaulltFee").combogrid('getText')=="")){var str="";}
	if(str!="")
	{
		if (($("#InvDefaulltFee").combogrid('getValue'))==($("#InvDefaulltFee").combogrid('getText')))  {
			$.messager.alert("��ʾ","����ѡ����ȷ!","info");
			return false;
		}	
	}
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"InvDefaulltFee",str);
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"Group'sOEArcItemId",str);
	
	//������ҽ��
	var str=$("#RoundingFee").combogrid("getValue");
	if (($("#RoundingFee").combogrid('getValue')==undefined)||($("#RoundingFee").combogrid('getText')=="")){var str="";}
	if(str!="")
	{
		if (($("#RoundingFee").combogrid('getValue'))==($("#RoundingFee").combogrid('getText')))  {
			$.messager.alert("��ʾ","������ѡ����ȷ!","info");
			return false;
		}	
	}
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"RoundingFee",str);
	
	
	//���ų���
	var str=$("#HPNo").val();
	if(isNaN(str)){
		$.messager.alert("��ʾ","���ų��ȱ���������!","info");
		return false;
	}
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"HPNo",str);
	
	//����վ��
	var str=$("#StationId_Lab").combobox("getValue");
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"StationId_Lab",str);
	
	//���վ��
	var RisStation=$("#StationId_Ris").combobox("getValues");
	var str=RisStation.join("^");
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"StationId_Ris",str);
	
	//ҩƷվ��
	var str=$("#StationId_Medical").combobox("getValue");
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"StationId_Medical",str);
	
	//����վ��
	var str=$("#StationId_Other").combobox("getValue");
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"StationId_Other",str);
	
	//���������ռ�
	var str=$("#LABDATA").val();
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"LABDATA",str);
	
	//���������ռ�
	var str=$("#MEDDATA").val();
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"MEDDATA",str);
	
	//���������ռ�
	var str=$("#PisNameSpace").combobox('getValue');
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"PisNameSpace",str);
	
	//����Ȩ�ް�ȫ��
	var str=$("#SuperGroup").combobox('getValue');
	if (($("#SuperGroup").combobox('getValue')==undefined)||($("#SuperGroup").combobox('getText')=="")){var str="";}
	if(str=="")
	{
		$.messager.alert("��ʾ","������ȫ��ѡ����ȷ!","info");
		return false;	
	}
	if(str!="")
	{	
		if (($("#SuperGroup").combobox('getValue'))==($("#SuperGroup").combobox('getText')))  {
			$.messager.alert("��ʾ","������ȫ��ѡ����ȷ!","info");
			return false;
		}
		
	}
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"SuperGroup",str);
	
	//ҽ������ȡ��д
	var str=$("#ItemAbridgeFlag").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"ItemAbridgeFlag",str);
	
	//���ü���ӿ�
	var str=$("#LisInterface").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"LisInterface",str);
	
	//�����°����
	var str=$("#LisNewVersion").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"LisNewVersion",str);
	
	//�����°没��ӿ�
	var str=$("#SendPisInterface").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"SendPisInterface",str);
	
	//�����ʾ��Ƽ��ײ�
	var str=$("#IfRecommendItem").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"RecommendItem",str);
	
	//�������뷽ʽ
	var str=$("#SendPisFBWay").combobox('getValue');
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"SendPisFBWay",str);

	//��ҽ����ʽ
	var str=$("#OrderInterfaceType").combobox('getValue');
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"OrderInterfaceType",str);
	
	//��ͬ�շ�ģʽ
	var str=$("#CashierSystem").combobox('getValue');
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"CashierSystem",str);
	
	//�Զ��ύ��
	var str=$("#AutoAuditUser").combobox("getValue");
	if (($("#AutoAuditUser").combobox('getValue')==undefined)||($("#AutoAuditUser").combobox('getText')=="")){var str="";}
	if(str=="")
	{
			$.messager.alert("��ʾ","�ύ��ѡ����ȷ!","info");
			return false;
	}
	if(str!="")
	{
		if (($("#AutoAuditUser").combobox('getValue'))==($("#AutoAuditUser").combobox('getText')))  {
			$.messager.alert("��ʾ","�ύ��ѡ����ȷ!","info");
			return false;
		}	
	}
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"AutoAuditUser",str);
	
	//Ĭ�����ҽ��
	var str=$("#PhyExamDrId").combogrid("getValue");
	if (($("#PhyExamDrId").combogrid('getValue')==undefined)||($("#PhyExamDrId").combogrid('getText')=="")){var str="";}
	if(str!="")
	{
		if (($("#PhyExamDrId").combogrid('getValue'))==($("#PhyExamDrId").combogrid('getText')))  {
			$.messager.alert("��ʾ","Ĭ��ҽ��ѡ����ȷ!","info");
			return false;
		}
		
	}
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"PhyExamDrId",str);
	
	
	//�°������뵥
	var str=$("#OrderInterface").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"OrderInterface",str);
	
	//����
	var str=$("#MainDoctorGroup").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"MainDoctorGroup",str);
	
	//ȡ����첻ɾ��δ��
	var str=$("#CancelPEType").switchbox("getValue");
	if(str) str="1"
	else str="0"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"CancelPEType",str);
	
	
	//�����Ƿ��Ժ��
	var str=$("#MHospital").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"MHospital",str);
	
	//���ýкŽӿ�
	var str=$("#CallVoice").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"CallVoice",str);
	
	//����ƽ̨�ӿ�
	var str=$("#SendOrder").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"SendOrder",str);
	

	//�����ҼƷ�
	var str=$("#IsFeeLocFlag").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"IsFeeLocFlag",str);
	
	//��쿨�����ʹ��
	var str=$("#IsCardLocFlag").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"IsCardLocFlag",str);
	
	//����ԤԼ
	var str=$("#IfNetPre").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"NetPreLoc",str);
	
	
	//����ԤԼ�Զ��Ǽ�
	var str=$("#IfNetRegister").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"AutoNetRegister",str);
	
	//����ȡ��ԤԼ��¼
	var str=$("#IfNetCancelPE").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"NetCancelPE",str);
	
	/*
	//ҽ��Ԥ��
	var str=$("#PreOrder").switchbox("getValue");
	if(str) str="1"
	else str="0"  
	*/
	str="0"
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"PreOrder",str);
	
	//�ش����
	var str=$("#TransResult").combobox("getValue");
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"TransResult",str);
	
	var str=$("#PosAdvice").switchbox("getValue");
    if(str) str="1"
    else str="0"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"PosAdvice",str);
    
	$.messager.alert("��ʾ","���óɹ�!","success");
	
	$("#PublicSettingGrid").datagrid('load',{
			ClassName:"web.DHCPE.HISUICommon",
			QueryName:"FindPublicSettingNew",
			HospID:session['LOGON.HOSPID']
		});	
}
function InitPublicSettingGrid()
{
	
	$HUI.datagrid("#PublicSettingGrid",{
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
			QueryName:"FindPublicSettingNew",
			HospID:session['LOGON.HOSPID']
		},
		columns:[[
		{field:'Loc',title:'Loc'},
		{field:'LocDesc',title:'����'},
		{field:'InvDefaulltFee',title:'����ҽ��'},
		{field:'RoundingFee',title:'������ҽ��'},
		{field:'LabStation',title:'����վ��'},
		{field:'RisStationStr',title:'���վ��'},
		{field:'MedicalStation',title:'ҩƷվ��'},
		{field:'OtherStation',title:'����վ��'},
		{field:'HPNo',title:'���ų���'},
		{field:'LABDATA',title:'���������ռ�'},
		{field:'MEDDATA',title:'���������ռ�'},
		{field:'PisNameSpace',title:'���������ռ�'},
		{field:'SuperGroup',title:'����Ȩ�ް�ȫ��'},
		{field:'ItemAbridgeFlag',title:'ҽ������ȡ��д'},
		{field:'LisInterface',title:'���ü���ӿ�'},
		{field:'LisNewVersion',title:'�����°����'},
		{field:'SendPisInterface',title:'�����°没��ӿ�'},
		{field:'IfRecommendItem',title:'�����ʾ��Ƽ��ײ�'},
		{field:'SendPisFBWay',title:'�������뷽ʽ'},
		{field:'OrderInterfaceType',title:'��ҽ����ʽ'},
		{field:'CashierSystem',title:'��ͬ�շ�ģʽ'},
		{field:'AutoAuditUser',title:'�Զ��ύ��'},
		{field:'PhyExamDr',title:'Ĭ�����ҽ��'},
		{field:'OrderInterface',title:'�°������뵥'},
		{field:'MainDoctorGroup',title:'����'},
		{field:'CancelPEType',title:'ȡ����첻ɾ��δ��'},
		{field:'MHospital',title:'�����Ƿ��Ժ��'},
		{field:'SendOrder',title:'����ƽ̨�ӿ�'},
		{field:'CallVoice',title:'���ýкŽӿ�'},
		{field:'IsFeeLocFlag',title:'�����ҼƷ�'},
		{field:'IsCardLocFlag',title:'��쿨�����ʹ��'},
		{field:'NetPreLoc',title:'����ԤԼ'},
		{field:'AutoNetRegister',title:'����ԤԼ�Զ��Ǽ�'},
		{field:'NetCancelPE',title:'����ȡ��ԤԼ��¼'},
		{field:'TransResult',title:'�ش����'},
		//{field:'PreOrder',title:'ҽ��Ԥ��'},
        {field:'PosAdvice',title:'������ȡ����'}
		
		
		]],
		onSelect: function (rowIndex, rowData) {
			   
			var loc=rowData.Loc;
			var LocDesc=rowData.LocDesc;
			$('#NowLoc').combogrid('grid').datagrid('reload',{'q':LocDesc});
			setValueById("NowLoc",loc)
			SetPublicDataByLoc(loc)	
				
					
		}
		
			
	})

}
function SetPublicDataByLoc(loc)
{
	
	
	//����ҽ��
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"InvDefaulltFee");
	$('#InvDefaulltFee').combogrid('grid').datagrid('reload',{'q':"���"});
	$("#InvDefaulltFee").combogrid("setValue",ret);
	
	//������ҽ��
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"RoundingFee");
	$('#RoundingFee').combogrid('grid').datagrid('reload',{'q':"���"});
	$("#RoundingFee").combogrid('setValue',ret);
	
	//����
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"HPNo");
	if(ret!=""){var ret=ret.split("^")[1];}
	$("#HPNo").val(ret);
	
	//����վ��
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"StationId_Lab");
	$("#StationId_Lab").combobox("setValue",ret);
	
	//���վ��
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"StationId_Ris");
	var str=ret.split("^")
	var retarray=new Array();
	for(var i=0;i<str.length;i++)
	{
		retarray.push(str[i]);
		var checkid="StationId_Ris"+str[i];
		$("#"+checkid).attr("checked",true);
	}
	$("#StationId_Ris").combobox("setValues",retarray);
	
	//ҩƷվ��
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"StationId_Medical");
	$("#StationId_Medical").combobox("setValue",ret);
	
	//����վ��
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"StationId_Other");
	$("#StationId_Other").combobox("setValue",ret);
	
	//���������ռ�
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"LABDATA");
	$("#LABDATA").val(ret);
	
	//���������ռ�
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"MEDDATA");
	$("#MEDDATA").val(ret);
	
	//���������ռ�
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"PisNameSpace");
	$("#PisNameSpace").combobox("setValue",ret);
	
	//����Ȩ�ް�ȫ��
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"SuperGroup");
	$("#SuperGroup").combobox("setValue",ret);
	
	//ҽ������ȡ��д
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"ItemAbridgeFlag");
	if(ret=="Y")	$("#ItemAbridgeFlag").switchbox("setValue",true);
	else	$("#ItemAbridgeFlag").switchbox("setValue",false);
	
	//���ü���ӿ�
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"LisInterface");
	if(ret=="Y")	$("#LisInterface").switchbox("setValue",true);
	else	$("#LisInterface").switchbox("setValue",false);
	
	//�����°����
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"LisNewVersion");
	if(ret=="Y")	$("#LisNewVersion").switchbox("setValue",true);
	else	$("#LisNewVersion").switchbox("setValue",false)
	
	//�����°没��ӿ�
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"SendPisInterface");
	if(ret=="Y")	$("#SendPisInterface").switchbox("setValue",true);
	else	$("#SendPisInterface").switchbox("setValue",false);
	
	//�����ʾ��Ƽ��ײ�
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"RecommendItem");
	if(ret=="Y")	$("#IfRecommendItem").switchbox("setValue",true);
	else	$("#IfRecommendItem").switchbox("setValue",false);
	
	//�������뷽ʽ
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"SendPisFBWay");
	$("#SendPisFBWay").combobox("setValue",ret);
	
	//��ҽ����ʽ
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"OrderInterfaceType");
	$("#OrderInterfaceType").combobox("setValue",ret);
	
	//��ͬ�շ�ģʽ
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"CashierSystem");
	$("#CashierSystem").combobox("setValue",ret);
	
	//�Զ��ύ��
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"AutoAuditUser");
	$("#AutoAuditUser").combobox("setValue",ret);
	
	//Ĭ�����ҽ��
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"PhyExamDrId");
	$('#PhyExamDrId').combogrid('grid').datagrid('reload',{'q':ret.split("^")[1]});
	setValueById("PhyExamDrId",ret.split("^")[0])
	

	//�°������뵥
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"OrderInterface");
	if(ret=="Y")	$("#OrderInterface").switchbox("setValue",true);
	else	$("#OrderInterface").switchbox("setValue",false)
	
	
	//����
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"MainDoctorGroup");
	if(ret=="Y")	$("#MainDoctorGroup").switchbox("setValue",true);
	else	$("#MainDoctorGroup").switchbox("setValue",false)
	
	//ȡ����첻ɾ��δ��
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"CancelPEType");
	if(ret=="1")	$("#CancelPEType").switchbox("setValue",true);
	else	$("#CancelPEType").switchbox("setValue",false)

	//�����Ƿ��Ժ��
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"MHospital");
	if(ret=="Y") $("#MHospital").switchbox("setValue",true);
	else	$("#MHospital").switchbox("setValue",false)
	
	//���ýкŽӿ�
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"CallVoice");
	if(ret=="Y")	$("#CallVoice").switchbox("setValue",true);
	else	$("#CallVoice").switchbox("setValue",false)
	
	//����ƽ̨�ӿ�
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"SendOrder");
	if(ret=="Y")	$("#SendOrder").switchbox("setValue",true);
	else	$("#SendOrder").switchbox("setValue",false)
	
	//�����ҼƷ�
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"IsFeeLocFlag");
	if(ret=="Y") $("#IsFeeLocFlag").switchbox("setValue",true);
	else	$("#IsFeeLocFlag").switchbox("setValue",false);
	
	//��쿨�����ʹ��
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"IsCardLocFlag");
	if(ret=="Y") $("#IsCardLocFlag").switchbox("setValue",true);
	else	$("#IsCardLocFlag").switchbox("setValue",false);
	
	//����ԤԼ
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"NetPreLoc");
	if(ret=="Y")	$("#IfNetPre").switchbox("setValue",true);
	else	$("#IfNetPre").switchbox("setValue",false);
	
	//����ԤԼ�Զ��Ǽ�
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"AutoNetRegister");
	if(ret=="Y")	$("#IfNetRegister").switchbox("setValue",true);
	else	$("#IfNetRegister").switchbox("setValue",false);
	
	//����ȡ��ԤԼ��¼
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"NetCancelPE");
	if(ret=="Y")	$("#IfNetCancelPE").switchbox("setValue",true);
	else	$("#IfNetCancelPE").switchbox("setValue",false);
	
	//�ش����
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"TransResult");
	$("#TransResult").combobox("setValue",ret);	
	
	/*
	//ҽ��Ԥ��
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"PreOrder");
	if(ret=="1")	$("#PreOrder").switchbox("setValue",true);
	else	$("#PreOrder").switchbox("setValue",false);
	*/

	 //��������
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"PosAdvice");
    if(ret=="1")    $("#PosAdvice").switchbox("setValue",true);
    else    $("#PosAdvice").switchbox("setValue",false);
}

function SetDefault()
{
	var loc="999999"

	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"LABDATA");
	setValueById("LABDATA",ret)
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"MEDDATA");
	setValueById("MEDDATA",ret)
	
	
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
	

	//��ȫ��
	var SuperGroupObj = $HUI.combobox("#SuperGroup",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindFeeTypeSuperGroup&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		onBeforeLoad:function(param){
			param.hospId = session['LOGON.HOSPID'];
		}

		});	
		
	//����ҽ��		
	var InvDefaultFeeObj = $HUI.combogrid("#InvDefaulltFee",{
		panelWidth:340,
		url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=ArcItmmastList",
		mode:'remote',
		delay:200,
		idField:'STORD_ARCIM_DR',
		textField:'STORD_ARCIM_Desc',
		onBeforeLoad:function(param){
			param.Desc = param.q;
			param.Type="B";
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];

		},
		columns:[[
			{field:'STORD_ARCIM_DR',hidden:true},
			{field:'STORD_ARCIM_Code',title:'ҽ������',width:100},
			{field:'STORD_ARCIM_Desc',title:'ҽ������',width:240}
			
			
			
		]]
	});
	
	//������ҽ��
	var RoundingFeeObj = $HUI.combogrid("#RoundingFee",{
		panelWidth:340,
		url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=ArcItmmastList",
		mode:'remote',
		delay:200,
		idField:'STORD_ARCIM_DR',
		textField:'STORD_ARCIM_Desc',
		onBeforeLoad:function(param){
			param.Desc = param.q;
			param.Type="B";
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];

		},
		columns:[[
			{field:'STORD_ARCIM_DR',hidden:true},
			{field:'STORD_ARCIM_Code',title:'ҽ������',width:100},
			{field:'STORD_ARCIM_Desc',title:'ҽ������',width:240}
			
			
			
		]]
	});
	
	
	//����վ��
	var LabStationObj = $HUI.combobox("#StationId_Lab",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationBase&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		});
	//���վ��
	var StationIdRisObj = $HUI.combobox("#StationId_Ris",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStation&ResultSetType=array",
		valueField:'id',
		rowStyle:'checkbox',
		textField:'desc',multiple:true,selectOnNavigation:false,panelHeight:300,editable:false
	});

	
	//ҩƷվ��
	var MedicalStationObj = $HUI.combobox("#StationId_Medical",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStation&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		});
	//����վ��	
	var OtherStationObj = $HUI.combobox("#StationId_Other",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStation&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		});
	
	//�Զ��ύ��
	var AutoAuditUserObj = $HUI.combobox("#AutoAuditUser",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindUser&ResultSetType=array",
		valueField:'id',
		textField:'name',
		onBeforeLoad: function (param) {
			param.desc = param.q;
			param.Type="B";
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];
			
		}
	});
	
	//Ĭ�����ҽ��
	var PhyExamDrIdObj = $HUI.combogrid("#PhyExamDrId",{
		panelWidth:300,
		url:$URL+"?ClassName=web.DHCPE.Public.SettingEdit&QueryName=QueryDoctorID",
		mode:'remote',
		delay:200,
		idField:'DocRowID',
		textField:'DocName',
		onBeforeLoad:function(param){
			param.DocCode = param.q;
			param.Type="B";
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];

		},
		columns:[[
			{field:'DocRowID',hidden:true},
			{field:'DocCode',title:'����',width:100},
			{field:'DocName',title:'����',width:200}
			
		]]
		});
	
}