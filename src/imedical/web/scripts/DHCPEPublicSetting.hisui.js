
//名称	DHCPEPublicSetting.hisui.js
//功能	体检基础配置
//创建	2021.02.19
//创建人  xy
$(function(){
		
	InitCombobox();
	
	InitPublicSettingGrid();
   
    //保存
	$("#BSave").click(function() {	
		BSave_click();		
        });
     
      
    SetDefault()
   
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
	
	//体检费医嘱
	var str=$("#InvDefaulltFee").combogrid("getValue");
	if (($("#InvDefaulltFee").combogrid('getValue')==undefined)||($("#InvDefaulltFee").combogrid('getText')=="")){var str="";}
	if(str!="")
	{
		if (($("#InvDefaulltFee").combogrid('getValue'))==($("#InvDefaulltFee").combogrid('getText')))  {
			$.messager.alert("提示","体检费选择不正确!","info");
			return false;
		}	
	}
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"InvDefaulltFee",str);
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"Group'sOEArcItemId",str);
	
	//凑整费医嘱
	var str=$("#RoundingFee").combogrid("getValue");
	if (($("#RoundingFee").combogrid('getValue')==undefined)||($("#RoundingFee").combogrid('getText')=="")){var str="";}
	if(str!="")
	{
		if (($("#RoundingFee").combogrid('getValue'))==($("#RoundingFee").combogrid('getText')))  {
			$.messager.alert("提示","凑整费选择不正确!","info");
			return false;
		}	
	}
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"RoundingFee",str);
	
	
	//体检号长度
	var str=$("#HPNo").val();
	if(isNaN(str)){
		$.messager.alert("提示","体检号长度必须是数字!","info");
		return false;
	}
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"HPNo",str);
	
	//检验站点
	var str=$("#StationId_Lab").combobox("getValue");
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"StationId_Lab",str);
	
	//检查站点
	var RisStation=$("#StationId_Ris").combobox("getValues");
	var str=RisStation.join("^");
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"StationId_Ris",str);
	
	//药品站点
	var str=$("#StationId_Medical").combobox("getValue");
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"StationId_Medical",str);
	
	//其他站点
	var str=$("#StationId_Other").combobox("getValue");
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"StationId_Other",str);
	
	//检验命名空间
	var str=$("#LABDATA").val();
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"LABDATA",str);
	
	//数据命名空间
	var str=$("#MEDDATA").val();
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"MEDDATA",str);
	
	//病理命名空间
	var str=$("#PisNameSpace").combobox('getValue');
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"PisNameSpace",str);
	
	//超级权限安全组
	var str=$("#SuperGroup").combobox('getValue');
	if (($("#SuperGroup").combobox('getValue')==undefined)||($("#SuperGroup").combobox('getText')=="")){var str="";}
	if(str=="")
	{
		$.messager.alert("提示","超级安全组选择不正确!","info");
		return false;	
	}
	if(str!="")
	{	
		if (($("#SuperGroup").combobox('getValue'))==($("#SuperGroup").combobox('getText')))  {
			$.messager.alert("提示","超级安全组选择不正确!","info");
			return false;
		}
		
	}
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"SuperGroup",str);
	
	//医嘱描述取缩写
	var str=$("#ItemAbridgeFlag").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"ItemAbridgeFlag",str);
	
	//启用检验接口
	var str=$("#LisInterface").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"LisInterface",str);
	
	//启用新版检验
	var str=$("#LisNewVersion").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"LisNewVersion",str);
	
	//启用新版病理接口
	var str=$("#SendPisInterface").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"SendPisInterface",str);
	
	//根据问卷推荐套餐
	var str=$("#IfRecommendItem").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"RecommendItem",str);
	
	//病理申请方式
	var str=$("#SendPisFBWay").combobox('getValue');
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"SendPisFBWay",str);

	//插医嘱方式
	var str=$("#OrderInterfaceType").combobox('getValue');
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"OrderInterfaceType",str);
	
	//视同收费模式
	var str=$("#CashierSystem").combobox('getValue');
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"CashierSystem",str);
	
	//自动提交人
	var str=$("#AutoAuditUser").combobox("getValue");
	if (($("#AutoAuditUser").combobox('getValue')==undefined)||($("#AutoAuditUser").combobox('getText')=="")){var str="";}
	if(str=="")
	{
			$.messager.alert("提示","提交人选择不正确!","info");
			return false;
	}
	if(str!="")
	{
		if (($("#AutoAuditUser").combobox('getValue'))==($("#AutoAuditUser").combobox('getText')))  {
			$.messager.alert("提示","提交人选择不正确!","info");
			return false;
		}	
	}
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"AutoAuditUser",str);
	
	//默认体检医生
	var str=$("#PhyExamDrId").combogrid("getValue");
	if (($("#PhyExamDrId").combogrid('getValue')==undefined)||($("#PhyExamDrId").combogrid('getText')=="")){var str="";}
	if(str!="")
	{
		if (($("#PhyExamDrId").combogrid('getValue'))==($("#PhyExamDrId").combogrid('getText')))  {
			$.messager.alert("提示","默认医生选择不正确!","info");
			return false;
		}
		
	}
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"PhyExamDrId",str);
	
	
	//新版检查申请单
	var str=$("#OrderInterface").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"OrderInterface",str);
	
	//复审
	var str=$("#MainDoctorGroup").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"MainDoctorGroup",str);
	
	//取消体检不删除未检
	var str=$("#CancelPEType").switchbox("getValue");
	if(str) str="1"
	else str="0"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"CancelPEType",str);
	
	
	//年龄是否多院区
	var str=$("#MHospital").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"MHospital",str);
	
	//启用叫号接口
	var str=$("#CallVoice").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"CallVoice",str);
	
	//启用平台接口
	var str=$("#SendOrder").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"SendOrder",str);
	

	//按科室计费
	var str=$("#IsFeeLocFlag").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"IsFeeLocFlag",str);
	
	//体检卡跨科室使用
	var str=$("#IsCardLocFlag").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"IsCardLocFlag",str);
	
	//网上预约
	var str=$("#IfNetPre").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"NetPreLoc",str);
	
	
	//网上预约自动登记
	var str=$("#IfNetRegister").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"AutoNetRegister",str);
	
	//网上取消预约记录
	var str=$("#IfNetCancelPE").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"NetCancelPE",str);
	
	/*
	//医嘱预开
	var str=$("#PreOrder").switchbox("getValue");
	if(str) str="1"
	else str="0"  
	*/
	str="0"
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"PreOrder",str);
	
	//回传结果
	var str=$("#TransResult").combobox("getValue");
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"TransResult",str);
	
	var str=$("#PosAdvice").switchbox("getValue");
    if(str) str="1"
    else str="0"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"PosAdvice",str);
    
	$.messager.alert("提示","设置成功!","success");
	
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
		{field:'LocDesc',title:'科室'},
		{field:'InvDefaulltFee',title:'体检费医嘱'},
		{field:'RoundingFee',title:'凑整费医嘱'},
		{field:'LabStation',title:'检验站点'},
		{field:'RisStationStr',title:'检查站点'},
		{field:'MedicalStation',title:'药品站点'},
		{field:'OtherStation',title:'其他站点'},
		{field:'HPNo',title:'体检号长度'},
		{field:'LABDATA',title:'检验命名空间'},
		{field:'MEDDATA',title:'数据命名空间'},
		{field:'PisNameSpace',title:'病理命名空间'},
		{field:'SuperGroup',title:'超级权限安全组'},
		{field:'ItemAbridgeFlag',title:'医嘱描述取缩写'},
		{field:'LisInterface',title:'启用检验接口'},
		{field:'LisNewVersion',title:'启用新版检验'},
		{field:'SendPisInterface',title:'启用新版病理接口'},
		{field:'IfRecommendItem',title:'根据问卷推荐套餐'},
		{field:'SendPisFBWay',title:'病理申请方式'},
		{field:'OrderInterfaceType',title:'插医嘱方式'},
		{field:'CashierSystem',title:'视同收费模式'},
		{field:'AutoAuditUser',title:'自动提交人'},
		{field:'PhyExamDr',title:'默认体检医生'},
		{field:'OrderInterface',title:'新版检查申请单'},
		{field:'MainDoctorGroup',title:'复审'},
		{field:'CancelPEType',title:'取消体检不删除未检'},
		{field:'MHospital',title:'年龄是否多院区'},
		{field:'SendOrder',title:'启用平台接口'},
		{field:'CallVoice',title:'启用叫号接口'},
		{field:'IsFeeLocFlag',title:'按科室计费'},
		{field:'IsCardLocFlag',title:'体检卡跨科室使用'},
		{field:'NetPreLoc',title:'网上预约'},
		{field:'AutoNetRegister',title:'网上预约自动登记'},
		{field:'NetCancelPE',title:'网上取消预约记录'},
		{field:'TransResult',title:'回传结果'},
		//{field:'PreOrder',title:'医嘱预开'},
        {field:'PosAdvice',title:'阳征提取建议'}
		
		
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
	
	
	//体检费医嘱
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"InvDefaulltFee");
	$('#InvDefaulltFee').combogrid('grid').datagrid('reload',{'q':"体检"});
	$("#InvDefaulltFee").combogrid("setValue",ret);
	
	//凑整费医嘱
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"RoundingFee");
	$('#RoundingFee').combogrid('grid').datagrid('reload',{'q':"体检"});
	$("#RoundingFee").combogrid('setValue',ret);
	
	//体检号
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"HPNo");
	if(ret!=""){var ret=ret.split("^")[1];}
	$("#HPNo").val(ret);
	
	//检验站点
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"StationId_Lab");
	$("#StationId_Lab").combobox("setValue",ret);
	
	//检查站点
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
	
	//药品站点
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"StationId_Medical");
	$("#StationId_Medical").combobox("setValue",ret);
	
	//其他站点
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"StationId_Other");
	$("#StationId_Other").combobox("setValue",ret);
	
	//检验命名空间
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"LABDATA");
	$("#LABDATA").val(ret);
	
	//数据命名空间
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"MEDDATA");
	$("#MEDDATA").val(ret);
	
	//病理命名空间
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"PisNameSpace");
	$("#PisNameSpace").combobox("setValue",ret);
	
	//超级权限安全组
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"SuperGroup");
	$("#SuperGroup").combobox("setValue",ret);
	
	//医嘱描述取缩写
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"ItemAbridgeFlag");
	if(ret=="Y")	$("#ItemAbridgeFlag").switchbox("setValue",true);
	else	$("#ItemAbridgeFlag").switchbox("setValue",false);
	
	//启用检验接口
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"LisInterface");
	if(ret=="Y")	$("#LisInterface").switchbox("setValue",true);
	else	$("#LisInterface").switchbox("setValue",false);
	
	//启用新版检验
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"LisNewVersion");
	if(ret=="Y")	$("#LisNewVersion").switchbox("setValue",true);
	else	$("#LisNewVersion").switchbox("setValue",false)
	
	//启用新版病理接口
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"SendPisInterface");
	if(ret=="Y")	$("#SendPisInterface").switchbox("setValue",true);
	else	$("#SendPisInterface").switchbox("setValue",false);
	
	//根据问卷推荐套餐
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"RecommendItem");
	if(ret=="Y")	$("#IfRecommendItem").switchbox("setValue",true);
	else	$("#IfRecommendItem").switchbox("setValue",false);
	
	//病理申请方式
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"SendPisFBWay");
	$("#SendPisFBWay").combobox("setValue",ret);
	
	//插医嘱方式
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"OrderInterfaceType");
	$("#OrderInterfaceType").combobox("setValue",ret);
	
	//视同收费模式
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"CashierSystem");
	$("#CashierSystem").combobox("setValue",ret);
	
	//自动提交人
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"AutoAuditUser");
	$("#AutoAuditUser").combobox("setValue",ret);
	
	//默认体检医生
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"PhyExamDrId");
	$('#PhyExamDrId').combogrid('grid').datagrid('reload',{'q':ret.split("^")[1]});
	setValueById("PhyExamDrId",ret.split("^")[0])
	

	//新版检查申请单
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"OrderInterface");
	if(ret=="Y")	$("#OrderInterface").switchbox("setValue",true);
	else	$("#OrderInterface").switchbox("setValue",false)
	
	
	//复审
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"MainDoctorGroup");
	if(ret=="Y")	$("#MainDoctorGroup").switchbox("setValue",true);
	else	$("#MainDoctorGroup").switchbox("setValue",false)
	
	//取消体检不删除未检
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"CancelPEType");
	if(ret=="1")	$("#CancelPEType").switchbox("setValue",true);
	else	$("#CancelPEType").switchbox("setValue",false)

	//年龄是否多院区
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"MHospital");
	if(ret=="Y") $("#MHospital").switchbox("setValue",true);
	else	$("#MHospital").switchbox("setValue",false)
	
	//启用叫号接口
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"CallVoice");
	if(ret=="Y")	$("#CallVoice").switchbox("setValue",true);
	else	$("#CallVoice").switchbox("setValue",false)
	
	//启用平台接口
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"SendOrder");
	if(ret=="Y")	$("#SendOrder").switchbox("setValue",true);
	else	$("#SendOrder").switchbox("setValue",false)
	
	//按科室计费
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"IsFeeLocFlag");
	if(ret=="Y") $("#IsFeeLocFlag").switchbox("setValue",true);
	else	$("#IsFeeLocFlag").switchbox("setValue",false);
	
	//体检卡跨科室使用
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"IsCardLocFlag");
	if(ret=="Y") $("#IsCardLocFlag").switchbox("setValue",true);
	else	$("#IsCardLocFlag").switchbox("setValue",false);
	
	//网上预约
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"NetPreLoc");
	if(ret=="Y")	$("#IfNetPre").switchbox("setValue",true);
	else	$("#IfNetPre").switchbox("setValue",false);
	
	//网上预约自动登记
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"AutoNetRegister");
	if(ret=="Y")	$("#IfNetRegister").switchbox("setValue",true);
	else	$("#IfNetRegister").switchbox("setValue",false);
	
	//网上取消预约记录
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"NetCancelPE");
	if(ret=="Y")	$("#IfNetCancelPE").switchbox("setValue",true);
	else	$("#IfNetCancelPE").switchbox("setValue",false);
	
	//回传结果
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"TransResult");
	$("#TransResult").combobox("setValue",ret);	
	
	/*
	//医嘱预开
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"PreOrder");
	if(ret=="1")	$("#PreOrder").switchbox("setValue",true);
	else	$("#PreOrder").switchbox("setValue",false);
	*/

	 //阳征建议
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
	

	//安全组
	var SuperGroupObj = $HUI.combobox("#SuperGroup",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindFeeTypeSuperGroup&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		onBeforeLoad:function(param){
			param.hospId = session['LOGON.HOSPID'];
		}

		});	
		
	//体检费医嘱		
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
			{field:'STORD_ARCIM_Code',title:'医嘱编码',width:100},
			{field:'STORD_ARCIM_Desc',title:'医嘱名称',width:240}
			
			
			
		]]
	});
	
	//凑整费医嘱
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
			{field:'STORD_ARCIM_Code',title:'医嘱编码',width:100},
			{field:'STORD_ARCIM_Desc',title:'医嘱名称',width:240}
			
			
			
		]]
	});
	
	
	//检验站点
	var LabStationObj = $HUI.combobox("#StationId_Lab",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationBase&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		});
	//检查站点
	var StationIdRisObj = $HUI.combobox("#StationId_Ris",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStation&ResultSetType=array",
		valueField:'id',
		rowStyle:'checkbox',
		textField:'desc',multiple:true,selectOnNavigation:false,panelHeight:300,editable:false
	});

	
	//药品站点
	var MedicalStationObj = $HUI.combobox("#StationId_Medical",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStation&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		});
	//其他站点	
	var OtherStationObj = $HUI.combobox("#StationId_Other",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStation&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		});
	
	//自动提交人
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
	
	//默认体检医生
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
			{field:'DocCode',title:'工号',width:100},
			{field:'DocName',title:'姓名',width:200}
			
		]]
		});
	
}