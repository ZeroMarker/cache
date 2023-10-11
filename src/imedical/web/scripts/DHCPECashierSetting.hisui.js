
//名称	DHCPECashierSetting.hisui.js
//功能	体检收费配置
//创建	2021.02.20
//创建人  xy
$(function(){
		
	InitCombobox();
	
	InitCashierSettingGrid();
   
    //保存
	$("#BSave").click(function() {	
		BSave_click();		
        });
     
     
   
})

function SetCashierDataByLoc(loc)
{
	//体检收费支付方式
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetCashierPayModeNew",loc);
    var str=ret.split("^")
    $("#CashierMode").combobox("setValues",str);
    
    //体检卡支付方式
     var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetCardPayModeNew",loc);
    var str=ret.split("^")
    $("#CardMode").combobox("setValues",str);
    
    //体检退费支付方式
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetRefundPayModeNew",loc);
    var str=ret.split("^")
    $("#RefundMode").combobox("setValues",str);
    
    //默认支付方式
     var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"InvDefaultPayMode");
    $("#InvDefaultPayMode").combobox("setValue",ret);
    
    //第三方支付方式
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetExtPayModeNew",loc);
    if(ret!=""){
        var str=ret.split("^")
        $("#ExtPayMode").combobox("setValues",str);
    } 

	//东华互联网支付
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetDHCScanCodeNew",loc);
    if(ret!=""){
        var str=ret.split("^")
        $("#DHCScanCode").combobox("setValues",str);
    }
    
	//医保费别
 	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetAdmReasonNew",loc);
    var str=ret.split("^")
    $("#AdmReason").combobox("setValues",str);

	//发票打印明细
 	 var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"InvListFlag");
    if(ret=="1")    $("#InvListFlag").switchbox("setValue",true);
    else    $("#InvListFlag").switchbox("setValue",false)
    
    
    //发票明细数
     var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"InvMaxListCount");
    $("#InvMaxListCount").val(ret);
    
    
    //打印费用类别
     var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"InvPrintCatInfo");
    if(ret=="Y")    $("#InvPrintCatInfo").switchbox("setValue",true);
    else    $("#InvPrintCatInfo").switchbox("setValue",false);
    
    //发票打印列数
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"InvCol");
    $("#InvCol").val(ret);
    
    //退费打印负票
     var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"IfPrintMinusInv");
    if(ret=="Y") $("#IfPrintMinusInv").switchbox("setValue",true);
    else    $("#IfPrintMinusInv").switchbox("setValue",false)
    
    //团体允许收费功能
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"AllowCharge");
	if(ret=="1")	$("#AllowCharge").switchbox("setValue",true);
	else	$("#AllowCharge").switchbox("setValue",false);
	
    //自动分币误差
     var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"RoundManager");
     $("#RoundManager").combobox("setValue",ret);
     
     //体检卡设置密码
     var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"IsCardPassWord");
    if(ret=="Y") $("#IsCardPassWord").switchbox("setValue",true);
    else    $("#IsCardPassWord").switchbox("setValue",false)
}
function BSave_click()
{
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
    
    //体检收费支付方式
    var CashierMode=$("#CashierMode").combobox("getValues");
    var str=CashierMode.join("^");
    tkMakeServerCall("web.DHCPE.HISUICommon","SetCashierPayModeNew",str,NowLoc);
    
    
    //体检卡支付方式
    var CardMode=$("#CardMode").combobox("getValues");
    var str=CardMode.join("^");
    tkMakeServerCall("web.DHCPE.HISUICommon","SetCardPayModeNew",str,NowLoc);
    
    //体检退费支付方式
    var RefundMode=$("#RefundMode").combobox("getValues");
    var str=RefundMode.join("^");
    tkMakeServerCall("web.DHCPE.HISUICommon","SetRefundPayModeNew",str,NowLoc);
    
    //默认支付方式
    var str=$("#InvDefaultPayMode").combobox("getValue");
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"InvDefaultPayMode",str);
    
    //第三方支付方式
    var ExtPayMode=$("#ExtPayMode").combobox("getValues");
    var str=ExtPayMode.join("^");
    tkMakeServerCall("web.DHCPE.HISUICommon","SetExtPayModeNew",str,NowLoc);  
    
    //东华互联网支付
    var ExtPayMode=$("#DHCScanCode").combobox("getValues");
    var str=ExtPayMode.join("^");
    tkMakeServerCall("web.DHCPE.HISUICommon","SetDHCScanCodeNew",str,NowLoc); 
 
    
    //医保费别
     var AdmReason=$("#AdmReason").combobox("getValues");
    var str=AdmReason.join("^");
    tkMakeServerCall("web.DHCPE.HISUICommon","SetAdmReasonNew",str,NowLoc);

	//发票打印明细
     var str=$("#InvListFlag").switchbox("getValue");
    if(str) str="1"
    else str="0"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"InvListFlag",str);
    
    //发票明细数
     var str=$("#InvMaxListCount").val();
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"InvMaxListCount",str);
    
    //发票打印列数
     var str=$("#InvCol").val();
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"InvCol",str);
    
    //打印费用类别
     var str=$("#InvPrintCatInfo").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"InvPrintCatInfo",str);
    
    //团体允许收费功能
     var str=$("#AllowCharge").switchbox("getValue");
    if(str) str="1"
    else str="0"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"AllowCharge",str);
    
    //退费打印负票
      $("#IfPrintMinusInv").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"IfPrintMinusInv",str);
    
    //自动分币误差
     var str=$("#RoundManager").combobox("getValue");
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"RoundManager",str);
    
    //体检卡设置密码
    var str=$("#IsCardPassWord").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"IsCardPassWord",str);
    
    $.messager.alert("提示","设置成功!","success");
	
	$("#CashierSettingGrid").datagrid('load',{
			ClassName:"web.DHCPE.HISUICommon",
			QueryName:"FindCashierSetting",
			HospID:session['LOGON.HOSPID']
		});
		
		BClear_click();
}

//清屏
function BClear_click(){
	$("#InvMaxListCount,#InvCol").val("");
	$(".hisui-combobox").combobox("setValue","");
	$(".hisui-switchbox").switchbox("setValue",true);
	$(".hisui-combogrid").combogrid("setValue","");
		
}


function InitCashierSettingGrid()
{
	
	$HUI.datagrid("#CashierSettingGrid",{
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
			QueryName:"FindCashierSetting",
			HospID:session['LOGON.HOSPID']
		},
		columns:[[
		
		{field:'Loc',title:'Loc'},
		{field:'LocDesc',title:'科室'},
		{field:'CashierMode',title:'体检收费支付方式'},
		{field:'CardMode',title:'体检卡支付方式'},
		{field:'RefundMode',title:'体检退费支付方式'},
		{field:'InvDefaultPayMode',title:'默认支付方式'},
		{field:'ExtPayMode',title:'第三方支付方式'},
		{field:'DHCScanCode',title:'东华互联网支付'},
		{field:'AdmReason',title:'医保费别'},
		{field:'InvListFlag',title:'发票打印明细'},
		{field:'InvMaxListCount',title:'发票明细数'},
		{field:'InvCol',title:'发票打印列数'},
		{field:'InvPrintCatInfo',title:'打印费用类别'},
		{field:'AllowCharge',title:'团体允许收费功能'},
		{field:'IfPrintMinusInv',title:'退费打印负票'},
		{field:'RoundManager',title:'自动分币误差'},
		{field:'IsCardPassWord',title:'体检卡设置密码'}
		
		]],
		onSelect: function (rowIndex, rowData) {
			   
			var loc=rowData.Loc;
			var LocDesc=rowData.LocDesc;
			$('#NowLoc').combogrid('grid').datagrid('reload',{'q':LocDesc});
			setValueById("NowLoc",loc)
			SetCashierDataByLoc(loc)	
				
					
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
	
	//体检收费支付方式
	var CashierModeObj = $HUI.combobox("#CashierMode",{
		url:$URL+"?ClassName=web.DHCPE.Public.SettingCashierEdit&QueryName=SearchPayMode&ResultSetType=array",
		valueField:'TPayModeID',
		rowStyle:'checkbox',
		textField:'TPayMode',multiple:true,selectOnNavigation:false,panelHeight:300,editable:false
	});
	
	//体检卡支付方式
	var CardModeObj = $HUI.combobox("#CardMode",{
		url:$URL+"?ClassName=web.DHCPE.Public.SettingCashierEdit&QueryName=SearchPayMode&ResultSetType=array",
		valueField:'TPayModeID',
		rowStyle:'checkbox',
		textField:'TPayMode',multiple:true,selectOnNavigation:false,panelHeight:300,editable:false
	});
	
	//退费支付方式
	var RefundModeObj = $HUI.combobox("#RefundMode",{
		url:$URL+"?ClassName=web.DHCPE.Public.SettingCashierEdit&QueryName=SearchPayMode&ResultSetType=array",
		valueField:'TPayModeID',
		rowStyle:'checkbox',
		textField:'TPayMode',multiple:true,selectOnNavigation:false,panelHeight:300,editable:false
	});
	
	
	//默认支付方式
	var InvDefaultPayModeObj = $HUI.combobox("#InvDefaultPayMode",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPayMode&ResultSetType=array",
		valueField:'id',
		textField:'text'
	});
	
	//第三方支付方式
	var ExtPayModeObj = $HUI.combobox("#ExtPayMode",{
		url:$URL+"?ClassName=web.DHCPE.Public.SettingCashierEdit&QueryName=SearchPayMode&ResultSetType=array",
		valueField:'TPayModeCode',
		rowStyle:'checkbox',
		textField:'TPayMode',multiple:true,selectOnNavigation:false,panelHeight:300,editable:false
	});
	
	//东华互联网支付
	var ScanPayModeObj = $HUI.combobox("#DHCScanCode",{
		url:$URL+"?ClassName=web.DHCPE.Public.SettingCashierEdit&QueryName=SearchPayMode&ResultSetType=array",
		valueField:'TPayModeCode',
		rowStyle:'checkbox',
		textField:'TPayMode',multiple:true,selectOnNavigation:false,panelHeight:300,editable:false
	});
	
	//医保费别
	var AdmReasonObj = $HUI.combobox("#AdmReason",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=SearchAdmReason&ResultSetType=array",
		valueField:'TID',
		rowStyle:'checkbox',
		textField:'TDesc',
		multiple:true,
		selectOnNavigation:false,
		panelHeight:300,
		editable:false,
		onBeforeLoad:function(param){
			param.hospId = session['LOGON.HOSPID'];
		}


	});
	
}