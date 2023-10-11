
//名称	DHCPEPreSetting.hisui.js
//功能	体检前台配置
//创建	2021.02.20
//创建人  xy
$(function(){
		
	InitCombobox();
	
	InitPreSettingGrid();
   
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
	
	
	//可修改费别安全组
	var str=$("#FeeTypeSuperGroup").combobox('getValue')
	if (($("#FeeTypeSuperGroup").combobox('getValue')==undefined)||($("#FeeTypeSuperGroup").combobox('getText')=="")){var str="";}
	if(str=="")
	{
			$.messager.alert("提示","修改费别安全组选择不正确!","info");
			return false;	
	}
	if(str!="")
	{	
		if (($("#FeeTypeSuperGroup").combobox('getValue'))==($("#FeeTypeSuperGroup").combobox('getText')))  {
			$.messager.alert("提示","修改费别安全组选择不正确!","info");
			return false;
		}	
	}
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"FeeTypeSuperGroup",str);

	//需要自动到达
	var AutoArrived=$("#AutoArrived").combobox("getValues");
	var strarray=["N","N","N","N"]
	for(var i=0;i<AutoArrived.length;i++)
	{
		if(AutoArrived[i]=="1")	strarray.splice(0,1,"Y")
		if(AutoArrived[i]=="2")	strarray.splice(1,1,"Y")
		if(AutoArrived[i]=="3")	strarray.splice(2,1,"Y")
		if(AutoArrived[i]=="4")	strarray.splice(3,1,"Y")
	}
	var str=strarray.join("^");
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"AutoArrived",str);
	
	//预约打印选项
	var DefPrintType=$("#DefPrintType").combobox("getValues");
	var strarray=["N","N","N","N"]
	for(var i=0;i<DefPrintType.length;i++)
	{
		if(DefPrintType[i]=="1")	strarray.splice(0,1,"Y")
		if(DefPrintType[i]=="2")	strarray.splice(1,1,"Y")
		if(DefPrintType[i]=="3")	strarray.splice(2,1,"Y")
		if(DefPrintType[i]=="4")	strarray.splice(3,1,"Y")
	}
	var str=strarray.join("^");
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"DefPrintType",str);
	
	
	//未付费允许打印
	var str=$("#AllowPrint").switchbox("getValue");
	if(str) str="Y";
	else str="N";  
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"AllowPrint",str);
	
	//导检单打印已执行项目
	var str=$("#IsPrintEItem").switchbox("getValue");
	if(str) str="Y";
	else str="N";   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"IsPrintEItem",str);
	
	//收表后是否打印取报告凭条
	var str=$("#IsPGetReportPT").switchbox("getValue");
	if(str) str="Y";
	else str="N" ;  
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"IsPGetReportPT",str);
	
	//收表后允许加项
	var str=$("#IsAddItem").switchbox("getValue");
	if(str) str="Y";
	else str="N";  
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"IsAddItem",str);
	
	//体检建卡
	var str=$("#CardRelate").switchbox("getValue");
	if(str) str="Yes";
	else str="No";  	
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"CardRelate",str);
	
	//体检建卡类型
	var str=$("#CardType").combobox("getValue");
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"CardType",str); 
	
	//预约时填写调查问卷
	var str=$("#IfPreSurvey").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"PreSurvey",str);
	
	//单个采集标本
	var str=$("#CollectSpecOne").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"CollectSpecOne",str);
	


	$.messager.alert("提示","设置成功!","success");
	
	$("#PreSettingGrid").datagrid('load',{
			ClassName:"web.DHCPE.HISUICommon",
			QueryName:"FindPreSettingNew",
			HospID:session['LOGON.HOSPID']
		});	

		BClear_click();	
}

//清屏
function BClear_click(){
	
	$(".hisui-combobox").combobox("setValue","");
	$(".hisui-combogrid").combogrid("setValue","");
	$(".hisui-switchbox").switchbox("setValue",true);
	
}

function SetPreDataByLoc(loc)
{
	//可修改费别安全组
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"FeeTypeSuperGroup");
	$("#FeeTypeSuperGroup").combobox("setValue",ret)
	//需要自动到达
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"AutoArrived");
	var str=ret.split("^")
	var retarray=new Array();
	for(var i=0;i<str.length;i++)
	{
		if(str[i]=="Y")
		{ 
			retarray.push(i+1);
			var checkid="AutoArrived"+(i+1)
			$("#"+checkid).attr("checked",true);
		}
	}
	$("#AutoArrived").combobox("setValues",retarray);
	
	//预约打印选项
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"DefPrintType");
	var str=ret.split("^")
	var retarray=new Array();
	for(var i=0;i<str.length;i++)
	{
		if(str[i]=="Y")
		{ 
			retarray.push(i+1);
			var checkid="DefPrintType"+(i+1)
			$("#"+checkid).attr("checked",true);
		}
	}
	$("#DefPrintType").combobox("setValues",retarray);
	
	//导检单打印已执行项目
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"IsPrintEItem");
	if(ret=="Y")	$("#IsPrintEItem").switchbox("setValue",true);
	else	$("#IsPrintEItem").switchbox("setValue",false)
	
	//未付费允许打印
		var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"AllowPrint");
	if(ret=="Y")	$("#AllowPrint").switchbox("setValue",true);
	else	$("#AllowPrint").switchbox("setValue",false)
	
	//收表后是否打印取报告凭条
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"IsPGetReportPT");
	if(ret=="Y") $("#IsPGetReportPT").switchbox("setValue",true);
	else	$("#IsPGetReportPT").switchbox("setValue",false)

	//收表后允许加项
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"IsAddItem");
	if(ret=="Y") $("#IsAddItem").switchbox("setValue",true);
	else	$("#IsAddItem").switchbox("setValue",false)
	
	//体检建卡
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"CardRelate");
	if(ret=="Yes")	$("#CardRelate").switchbox("setValue",true);
	else	$("#CardRelate").switchbox("setValue",false);
	
	//体检建卡类型
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"CardType");
	$("#CardType").combobox("setValue",ret);
	
	//预约时填写调查问卷
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"PreSurvey");
	if(ret=="Y")	$("#IfPreSurvey").switchbox("setValue",true);
	else	$("#IfPreSurvey").switchbox("setValue",false);

	//单个采集标本
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"CollectSpecOne");
	if(ret=="Y") $("#CollectSpecOne").switchbox("setValue",true);
	else	$("#CollectSpecOne").switchbox("setValue",false);

	
}


function InitPreSettingGrid()
{
	$HUI.datagrid("#PreSettingGrid",{
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
			QueryName:"FindPreSettingNew",
			HospID:session['LOGON.HOSPID']

		},
		columns:[[
		{field:'Loc',title:'Loc'},
		{field:'LocDesc',title:'科室'},
		{field:'FeeTypeSuperGroup',title:'可修改费别安全组'},
		{field:'AutoArrived',title:'需要自动到达'},
		{field:'DefPrintType',title:'预约打印选项'},
		{field:'AllowPrint',title:'未付费允许打印'},
		{field:'IsPrintEItem',title:'导检单打印已执行项目'},
		{field:'IsAddItem',title:'收表后允许加项'},
		{field:'IsPGetReportPT',title:'收表后是否打印取报告凭条'},
		{field:'CardRelate',title:'体检建卡'},
		{field:'CardType',title:'体检建卡类型'},
		{field:'PreSurvey',title:'预约时填写调查问卷'},
		{field:'CollectSpecOne',title:'单个采集标本'}
		]],
		onSelect: function (rowIndex, rowData) {
			   
			var loc=rowData.Loc;
			var LocDesc=rowData.LocDesc;
			$('#NowLoc').combogrid('grid').datagrid('reload',{'q':LocDesc});
			setValueById("NowLoc",loc)
			SetPreDataByLoc(loc)	
				
					
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
	

	//可修改费别安全组
	var FeeTypeSuperGroupObj = $HUI.combobox("#FeeTypeSuperGroup",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindFeeTypeSuperGroup&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		onBeforeLoad:function(param){
			param.hospId = session['LOGON.HOSPID'];
		}

		});
		
		
	//需要自动到达
	//设置医生界面^打印条码是否自动到达^到达界面读卡自动到达^打印指引单
	var AutoArrived = $HUI.combobox("#AutoArrived",{
		valueField:'id',
		textField:'text',
		multiple:true,
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		rowStyle:'checkbox',
		data:[
			{id:'1',text:'医生界面'},
			{id:'2',text:'打印条码'},
			{id:'4',text:'打印指引'}
		]	
	});
	
	//预约打印选项
		var DefPrintType = $HUI.combobox("#DefPrintType",{
		valueField:'id',
		textField:'text',
		multiple:true,
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		rowStyle:'checkbox',
		data:[
			{id:'1',text:'个人信息条码'},
			{id:'2',text:'指引单'},
			{id:'3',text:'化验条码'},
			{id:'4',text:'检查条码'}
		]	
		
	});
	
	
	//体检建卡类型
	var CardTypeObj = $HUI.combobox("#CardType",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindCardType&ResultSetType=array",
		valueField:'id',
		textField:'cardtype'
	});
	
}