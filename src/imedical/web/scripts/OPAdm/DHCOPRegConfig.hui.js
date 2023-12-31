var PageLogicObj={
	m_DayTimeReglesDataGrid:"",
    m_AuthFlag:tkMakeServerCall("DHCDoc.Interface.Inside.InvokeAuth","GetSwitch")        //权力系统启用
};
$(function(){
	//初始化医院
	var hospComp = GenHospComp("Doc_OPAdm_BaseConfig");
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		//挂号服务组
		LoadServiceGroup();
		LoadFeeCatList();
		//科室排序
		InitSortType();
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		//页面元素初始化
		PageHandle();
		Init();
		InitCache();
	}
	//事件初始化
	InitEvent();
});
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function PageHandle()
{
	//费用子类初始化
	LoadFeeCatList()
	//医嘱检索初始化
	LoadOrderList()
	//挂号服务组
	LoadServiceGroup()
	//医保实时结算初始化
	LoadInsuBill()
	//科室排序
	InitSortType();
}

function LoadFeeCatList()
{
	var GridData=$.cm({ 
		ClassName:"web.DHCOPRegConfig", 
		QueryName:"GetBillSubStr",
		HospRowId:$HUI.combogrid('#_HospList').getValue(),
		rows:99999 
	},false)
	//挂号费子类
	var cbox = $HUI.combobox("#RegFeeBillSub", {
			valueField: 'ARCSGRowId',
			textField: 'ARCSGDesc', 
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				q=q.toUpperCase();
				return (row["ARCSGDesc"].toUpperCase().indexOf(q) >= 0);
			},onChange:function(newValue,OldValue){
				if (newValue==""){
					$("#RegFeeBillSub").combobox('select',"");
				}
			}
	 });
	 //诊查费子类
	 var cbox = $HUI.combobox("#CheckFeeBillSub", {
			valueField: 'ARCSGRowId',
			textField: 'ARCSGDesc', 
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				q=q.toUpperCase();
				return (row["ARCSGDesc"].toUpperCase().indexOf(q) >= 0);
			},onChange:function(newValue,OldValue){
				if (newValue==""){
					$("#CheckFeeBillSub").combobox('select',"");
				}
			}
	 });
	 //预约费子类
	 var cbox = $HUI.combobox("#AppFeeBillSub", {
			valueField: 'ARCSGRowId',
			textField: 'ARCSGDesc', 
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				q=q.toUpperCase();
				return (row["ARCSGDesc"].toUpperCase().indexOf(q) >= 0);
			},onChange:function(newValue,OldValue){
				if (newValue==""){
					$("#AppFeeBillSub").combobox('select',"");
				}
			}
	 });
	 //假日费子类
	 var cbox = $HUI.combobox("#HoliFeeBillSub", {
			valueField: 'ARCSGRowId',
			textField: 'ARCSGDesc', 
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				q=q.toUpperCase();
				return (row["ARCSGDesc"].toUpperCase().indexOf(q) >= 0);
			},onChange:function(newValue,OldValue){
				if (newValue==""){
					$("#HoliFeeBillSub").combobox('select',"");
				}
			}
	 });
	 //复诊费子类
	 var cbox = $HUI.combobox("#ReCheckFeeBillSub", {
			valueField: 'ARCSGRowId',
			textField: 'ARCSGDesc', 
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				q=q.toUpperCase();
				return (row["ARCSGDesc"].toUpperCase().indexOf(q) >= 0);
			},onChange:function(newValue,OldValue){
				if (newValue==""){
					$("#ReCheckFeeBillSub").combobox('select',"");
				}
			}
	 });
	 
	 var cbox = $HUI.combobox("#TimeRangeInclude", {
			valueField: 'ID',
			textField: 'Text', 
			editable:false,
			data:[{"ID":"1","Text":"仅包含当前时间段"},{"ID":"2","Text":"包含当前及以后时间段"}] ,
			filter: function(q, row){
			},onChange:function(newValue,OldValue){
			}
	 });
}

function LoadOrderList()
{
	var RegServiceGroup= $m({
	    ClassName : "web.DHCOPRegConfig",
	    MethodName : "GetSpecConfigNode",
	    NodeName : "RegServiceGroup",
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	},false);
	//病历本医嘱
	$("#order").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'ID',
        textField:'Desc',
        columns:[[  
            {field:'ID',title:'ID'},
			{field:'Desc',title:'名称',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        isCombo:true,
        //minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCBL.BaseReg.BaseDataQuery',QueryName: 'SeviceQueryAll'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        var RegServiceGroup=$("#RBCServiceGroup").combobox("getValue");
	        param = $.extend(param,{RegServiceGroupRowId : RegServiceGroup,HospID:$HUI.combogrid('#_HospList').getValue()});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
				if (rec!=undefined){
					$("#getorderid").val(rec["ID"])
					$("#order").blur();
				}
			});
		}
    });
	//需账单卡费医嘱
	$("#NeedBillCardFeeOrder").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'orderid',
        textField:'order',
        columns:[[  
            {field:'orderid',title:'ID'},
			{field:'order',title:'名称',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        isCombo:true,
        //minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCOEOrdItemQuery',QueryName: 'orderlookup'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        param = $.extend(param,{desc:desc,HospID:$HUI.combogrid('#_HospList').getValue()});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
				if (rec!=undefined){
					$("#NeedBillCardFeeOrderID").val(rec["orderid"])
					$("#NeedBillCardFeeOrder").blur();
				}
			});
		}
    });
    //免费医嘱
	$("#FreeOrder").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'orderid',
        textField:'order',
        columns:[[  
            {field:'orderid',title:'ID'},
			{field:'order',title:'名称',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        isCombo:true,
        //minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCOEOrdItemQuery',QueryName: 'orderlookup'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        param = $.extend(param,{desc:desc,HospID:$HUI.combogrid('#_HospList').getValue()});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
				if (rec!=undefined){
					$("#FreeOrderID").val(rec["orderid"])
					$("#FreeOrder").blur();
				}
			});
		}
    });
}

function LoadServiceGroup()
{
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$.cm({ 
		ClassName:"web.DHCOPRegConfig", 
		QueryName:"GetRBCServiceGroup",
		HospID:HospID,
		rows:99999 
	},function(GridData){
		//挂号服务组
		var cbox = $HUI.combobox("#RBCServiceGroup", {
				valueField: 'SGRowId',
				textField: 'SGDesc', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					q=q.toUpperCase();
					return (row["SGDesc"].toUpperCase().indexOf(q) >= 0);
				},onChange:function(newValue,OldValue){
					if (newValue==""){
						$("#RBCServiceGroup").combobox('select',"");
					}
				}
		 });
	})
}

function LoadInsuBill()
{
	$.cm({ 
		ClassName:"web.DHCOPRegConfig", 
		QueryName:"GetEnableInsuBillStr",
		rows:99999 
	},function(GridData){
		//启用医保实时结算
		var cbox = $HUI.combobox("#EnableInsuBill", {
				valueField: 'InsuBillId',
				textField: 'InsuBillDesc', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					q=q.toUpperCase();
					return (row["InsuBillDesc"].toUpperCase().indexOf(q) >= 0);
				},onChange:function(newValue,OldValue){
					if (newValue==""){
						$("#EnableInsuBill").combobox('select',"");
					}
				}
		 });
	})
}

function Init()
{
    LoadAuthHtml();
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$.cm({
		ClassName:"web.DHCOPRegConfig",
		MethodName:"GetDHCOPRegConfigInfo",
		dataType:"text",
		HospID:HospID,
	},function(rtnStr){
		var rtnArr=rtnStr.split(String.fromCharCode(1))
		//初始化文本项目
		//$("#AppQtyDefault").val(rtnArr[0]);
		//$("#AppStartNoDefault").val(rtnArr[1]);
		//$("#AdmTimeRangeCount").val(rtnArr[2]);
		//$("#AppBreakLimit").val(rtnArr[3]);
		$("#AppDaysLimit").val(rtnArr[4]);
		$("#SchedulePeriod").val(rtnArr[5]);
		$("#RegStartTime").timespinner('setValue',rtnArr[6]);
		$("#AppStartTime").timespinner('setValue',rtnArr[7]);
		$("#AddStartTime").timespinner('setValue',rtnArr[8]);
		$("#CommonCardNo").val(rtnArr[9]);
		$("#DayRegCountLimit").val(rtnArr[10]);
		$("#DaySameLocRegCountLimit").val(rtnArr[11]);
		$("#DaySameDocRegCountLimit").val(rtnArr[12]);
		$("#DaySameTimeRegLimit").val(rtnArr[35]);
		$("#TempCardRegCountLimit").val(rtnArr[38]);
		var MRArcimInfo=rtnArr[13]
		var NeedBillCardFeeOrderInfo=rtnArr[14]
		var FreeOrderInfo=rtnArr[15]
		//初始化挂号相关医嘱信息
		if (MRArcimInfo!=""){
			$("#getorderid").val(MRArcimInfo.split("@")[0])
			$("#order").val(MRArcimInfo.split("@")[1])
		}else{
			$("#getorderid").val("")
			$("#order").val("")
		}
		if (NeedBillCardFeeOrderInfo!=""){
			$("#NeedBillCardFeeOrderID").val(NeedBillCardFeeOrderInfo.split("@")[0])
			$("#NeedBillCardFeeOrder").val(NeedBillCardFeeOrderInfo.split("@")[1])
		}else{
			$("#NeedBillCardFeeOrderID").val("")
			$("#NeedBillCardFeeOrder").val("")
		}
		if (FreeOrderInfo!=""){
			$("#FreeOrderID").val(FreeOrderInfo.split("@")[0])
			$("#FreeOrder").val(FreeOrderInfo.split("@")[1])
		}else{
			$("#FreeOrderID").val("")
			$("#FreeOrder").val("")
		}
		setTimeout(function() { 
        	//初始化子类设置
			$("#RegFeeBillSub").combobox("setValue",rtnArr[16]);
			$("#CheckFeeBillSub").combobox("setValue",rtnArr[17]);
			$("#AppFeeBillSub").combobox("setValue",rtnArr[18]);
			$("#HoliFeeBillSub").combobox("setValue",rtnArr[19]);
			$("#ReCheckFeeBillSub").combobox("setValue",rtnArr[20]);
			$("#RBCServiceGroup").combobox("setValue",rtnArr[21]);
			$("#EnableInsuBill").combobox("setValue",rtnArr[22]);
        });
		//初始化勾选项目
		if (rtnArr[23]==1){
			$("#IFScreenStart").switchbox('setValue',true);
		}else{
			$("#IFScreenStart").switchbox('setValue',false);
		}
		
		if (rtnArr[24]==1){
			$("#IFTeleAppStart").switchbox('setValue',true);
		}else{
			$("#IFTeleAppStart").switchbox('setValue',false);
		}
		
		if (rtnArr[25]==1){
			$("#NotNullRealAmount").switchbox('setValue',true);
		}else{
			$("#NotNullRealAmount").switchbox('setValue',false);
		}
		
		if (rtnArr[26]==1){
			$("#ReturnNotAllowReg").switchbox('setValue',true);
		}else{
			$("#ReturnNotAllowReg").switchbox('setValue',false);
		}
		
		if (rtnArr[27]==1){
			$("#ReturnNotAllowAdd").switchbox('setValue',true);
		}else{
			$("#ReturnNotAllowAdd").switchbox('setValue',false);
		}
		
		if (rtnArr[28]==1){
			$("#AppReturnNotAllowRegAdd").switchbox('setValue',true);
		}else{
			$("#AppReturnNotAllowRegAdd").switchbox('setValue',false);
		}
		
		if (rtnArr[29]==1){
			$("#NotNeedNotFeeBill").switchbox('setValue',true);
		}else{
			$("#NotNeedNotFeeBill").switchbox('setValue',false);
		}
		
		/*if (rtnArr[30]==1){
			$("#RegTreeQuery").switchbox('setValue',true);
		}else{
			$("#RegTreeQuery").switchbox('setValue',false);
		}*/
		
		if (rtnArr[31]==1){
			$("#HolidayNotCreateSche").switchbox('setValue',true);
		}else{
			$("#HolidayNotCreateSche").switchbox('setValue',false);
		}
		
		if (rtnArr[32]==1){
			$("#AdvanceAppAdm").switchbox('setValue',true);
		}else{
			$("#AdvanceAppAdm").switchbox('setValue',false);
		}
		
		if (rtnArr[33]==1){
			$("#IsHideExaBor").switchbox('setValue',true);
		}else{
			$("#IsHideExaBor").switchbox('setValue',false);
		}
	
		if (rtnArr[34]==1){
			$("#MedifyPatTypeSynAdmRea").switchbox('setValue',true);
		}else{
			$("#MedifyPatTypeSynAdmRea").switchbox('setValue',false);
		}
		if (rtnArr[36]==1){
			$("#OPRegListDefault").switchbox('setValue',true);
		}else{
			$("#OPRegListDefault").switchbox('setValue',false);
		}
		if (rtnArr[37]==1){
			$("#AllowOpenAllRoms").switchbox('setValue',true);
		}else{
			$("#AllowOpenAllRoms").switchbox('setValue',false);
		}
		if (rtnArr[39]==1){
			$("#CancelRegNeedINVPrt").switchbox('setValue',true);
		}else{
			$("#CancelRegNeedINVPrt").switchbox('setValue',false);
		}
		if (rtnArr[40]==1){
			$("#QryScheduleByClinicGroup").switchbox('setValue',true);
		}else{
			$("#QryScheduleByClinicGroup").switchbox('setValue',false);
		}
		if (rtnArr[41]==1){
			$("#OPReturnReason").switchbox('setValue',true);
		}else{
			$("#OPReturnReason").switchbox('setValue',false);
		}
		if (rtnArr[42]==1){
			$("#AllocInsuBill").switchbox('setValue',true);
		}else{
			$("#AllocInsuBill").switchbox('setValue',false);
		}
		$("#TimeRangeInclude").combobox("setValue",rtnArr[43]);
		if (rtnArr[44]==1){
			$("#DocOPRegistBill").switchbox('setValue',true);
		}else{
			$("#DocOPRegistBill").switchbox('setValue',false);
		}
		if (rtnArr[45]==1){
			$("#InPatNotAllowOPRegist").switchbox('setValue',true);
		}else{
			$("#InPatNotAllowOPRegist").switchbox('setValue',false);
		}
		if (rtnArr[46]==1){
			$("#DocOPRegistInsu").switchbox('setValue',true);
		}else{
			$("#DocOPRegistInsu").switchbox('setValue',false);
		}
		if (rtnArr[47]==1){
			$("#OPRegistShowTimeRange").switchbox('setValue',true);
		}else{
			$("#OPRegistShowTimeRange").switchbox('setValue',false);
		}
		if (rtnArr[48]==1){
			$("#SeqNoOverRangeTime").switchbox('setValue',true);
		}else{
			$("#SeqNoOverRangeTime").switchbox('setValue',false);
		}
		if (rtnArr[49]==1){
			$("#SeqNoOverRangeTimeAdd").switchbox('setValue',true);
		}else{
			$("#SeqNoOverRangeTimeAdd").switchbox('setValue',false);
		}
		if (rtnArr[50]==1){
			$("#ResoduSeqNoAnyTime").switchbox('setValue',true);
		}else{
			$("#ResoduSeqNoAnyTime").switchbox('setValue',false);
		}
	});
}

function InitEvent()
{
	$("#Update").click(SaveClickHandle);
	$("#BtnForceCancelReg").click(ForceCancelRegHandle);
	$("#DepExpand").click(DepExpandHandle);
	$("#DayTimeRegless").click(DayTimeReglessHandle);
	$("#BSaveCongfid").click(BSaveCongfidHandle);
	$("#PowerConfig").click(PowerConfigHandle);
	$("#LocSortConfig").click(LocSortConfigClick);
	$("#RegArcimConfig").click(RegArcimConfigHandle);
	$("#SaveConfig").click(SaveConfigClick);
	$("#SaveRegSort").click(SaveRegSortClick);
	$('#BBlackType').click(BBlackTypeConfig);
	$('#ReSortQueueNo').click(ReSortQueueNoConfigHandle);
	$('#SaveResortQueueNoConfig').click(SaveReSortQueueNoConfig);
}

function SaveClickHandle()
{
	var mystr=BuildStr();
	if (mystr=="")return
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if (HospID==""){ HospID=session['LOGON.HOSPID'];}
	$.cm({
		ClassName:"web.DHCOPRegConfig",
		MethodName:"SaveConfigHosp",
		dataType:"text",
		Coninfo:mystr,
		HospID:HospID,
	},function(rtn){
		if (rtn=="0"){
			$.messager.alert("提示","保存成功");
		}else{
			$.messager.alert("提示","保存失败");
		}
	});
}

function BuildStr(){
	var myary=new Array();
	
	myary[0]=DHCWebD_GetObjValue("Hospital");
	if (myary[0]!=""){myary[0]="Hospital"+"!"+myary[0];}
	myary[1]=DHCWebD_GetObjValue("AutoBregno");
	if (myary[1]==true){
		myary[1]=1;
	}else{
		myary[1]=0;
	}
	
	var RegFeeBillSub="",CheckFeeBillSub="",AppFeeBillSub="",HoliFeeBillSub="",ReCheckFeeBillSub="",RegServiceGroupRowId="";
	var OldManFree="";
	var RegFeeBillSub=$("#RegFeeBillSub").combobox("getValue");
	var RegFeeBillSubText=$("#RegFeeBillSub").combobox("getText");
	var CheckFeeBillSub=$("#CheckFeeBillSub").combobox("getValue");
	var CheckFeeBillSubText=$("#CheckFeeBillSub").combobox("getText");
	
	if ((RegFeeBillSub=='undefined')||(RegFeeBillSub=="")||(RegFeeBillSubText=="")){
		$.messager.alert("警告","挂号费子类不能为空！");
		return ""
	}
	if ((CheckFeeBillSub=='undefined')||(CheckFeeBillSub=="")||(CheckFeeBillSubText=="")){
		$.messager.alert("警告","诊查费子类不能为空！");
		return ""
	}
	
	var AppFeeBillSub=$("#AppFeeBillSub").combobox("getValue");
	var HoliFeeBillSub=$("#HoliFeeBillSub").combobox("getValue");
	var ReCheckFeeBillSub=$("#ReCheckFeeBillSub").combobox("getValue");
	//老年人免费
	//var OldManFree=combo_OldManFree.getSelectedValue();
	
	myary[1]="AutoBregno"+"!"+myary[1];
	myary[2]="AppReturnTime"+"!"+DHCWebD_GetObjValue("AppReturnTime");
	myary[3]="AppDaysLimit"+"!"+DHCWebD_GetObjValue("AppDaysLimit");
	myary[4]="DayAppCountLimit"+"!"+DHCWebD_GetObjValue("DayAppCountLimit");
	myary[5]="AppQtyDefault"+"!"+"" //DHCWebD_GetObjValue("AppQtyDefault");
	myary[6]="AppStartNoDefault"+"!"+"" //DHCWebD_GetObjValue("AppStartNoDefault");
	myary[7]="AdmTimeRangeCount"+"!"+"" //DHCWebD_GetObjValue("AdmTimeRangeCount");
	myary[8]="SchedulePeriod"+"!"+DHCWebD_GetObjValue("SchedulePeriod");
	myary[9]="AppBreakLimit"+"!"+"" //DHCWebD_GetObjValue("AppBreakLimit");
	myary[10]="RegFeeBillSub"+"!"+RegFeeBillSub;
	myary[11]="CheckFeeBillSub"+"!"+CheckFeeBillSub;
	myary[12]="AppFeeBillSub"+"!"+AppFeeBillSub;
	myary[13]="HoliFeeBillSub"+"!"+HoliFeeBillSub;
	myary[14]="AppStartTime"+"!"+$("#AppStartTime").timespinner('getValue'); //DHCWebD_GetObjValue("AppStartTime");
	myary[15]="RegStartTime"+"!"+$("#RegStartTime").timespinner('getValue'); //DHCWebD_GetObjValue("RegStartTime");
	myary[16]="AddStartTime"+"!"+$("#AddStartTime").timespinner('getValue'); //DHCWebD_GetObjValue("AddStartTime");
	myary[17]="DayRegCountLimit"+"!"+DHCWebD_GetObjValue("DayRegCountLimit");
	myary[18]="DaySameDocRegCountLimit"+"!"+DHCWebD_GetObjValue("DaySameDocRegCountLimit");
	myary[19]="CommonCardNo"+"!"+DHCWebD_GetObjValue("CommonCardNo");
	
	var val=$("#IFScreenStart").switchbox("getValue")
	myary[20]=(val?'1':'0')	
	myary[20]="IFScreenStart"+"!"+myary[20];
	
	var val=$("#IFTeleAppStart").switchbox("getValue")
	myary[21]=(val?'1':'0')
	myary[21]="IFTeleAppStart"+"!"+myary[21];
	//病历本医嘱
	if (DHCWebD_GetObjValue("order")==""){$("#getorderid").val("")};
	myary[22]="MRArcimId"+"!"+DHCWebD_GetObjValue("getorderid")+'@'+DHCWebD_GetObjValue("order");
	myary[23]="OldManFree"+"!"+OldManFree;
	myary[24]="ReCheckFeeBillSub"+"!"+ReCheckFeeBillSub;
	//需账单卡费医嘱
	if (DHCWebD_GetObjValue("NeedBillCardFeeOrder")==""){$("#NeedBillCardFeeOrderID").val("")}
	myary[25]="NeedBillCardFeeOrder"+"!"+DHCWebD_GetObjValue("NeedBillCardFeeOrderID")+'@'+DHCWebD_GetObjValue("NeedBillCardFeeOrder");
	//免费医嘱
	if ($("#FreeOrder").lookup('getText')=="") {$("#FreeOrderID").val('');}
	if (DHCWebD_GetObjValue("FreeOrder")==""){$("#FreeOrderID").val('')}
	myary[26]="FreeOrder"+"!"+$("#FreeOrderID").val()+'@'+DHCWebD_GetObjValue("FreeOrder");
	myary[27]="ReturnNotAllowReg"+"!"+(eval($("#ReturnNotAllowReg").switchbox("getValue"))==true?1:0);
	myary[28]="ReturnNotAllowAdd"+"!"+(eval($("#ReturnNotAllowAdd").switchbox("getValue"))==true?1:0);
	myary[29]="NotNullRealAmount"+"!"+(eval($("#NotNullRealAmount").switchbox("getValue"))==true?1:0);
	myary[30]="NotNeedNotFeeBill"+"!"+(eval($("#NotNeedNotFeeBill").switchbox("getValue"))==true?1:0);
	myary[31]="HolidayNotCreateSche"+"!"+(eval($("#HolidayNotCreateSche").switchbox("getValue"))==true?1:0);
	myary[32]="MedifyPatTypeSynAdmRea"+"!"+(eval($("#MedifyPatTypeSynAdmRea").switchbox("getValue"))==true?1:0);
	//增加门诊挂号树状查询 20130425
	myary[33]="RegTreeQuery"+"!"+"" //(eval($("#RegTreeQuery").switchbox("getValue"))==true?1:0);
	//提前取预约号
	myary[34]="AdvanceAppAdm"+"!"+(eval($("#AdvanceAppAdm").switchbox("getValue"))==true?1:0);
	//每人每天挂相同科室限额
	myary[35]="DaySameLocRegCountLimit"+"!"+DHCWebD_GetObjValue("DaySameLocRegCountLimit");
	//是否启用挂号医保实时结算
	var EnableInsuBill=0;
	var EnableInsuBill=$("#EnableInsuBill").combobox("getValue");
	myary[36]="EnableInsuBill"+"!"+EnableInsuBill;
	myary[37]="AppReturnNotAllowRegAdd"+"!"+(eval($("#AppReturnNotAllowRegAdd").switchbox("getValue"))==true?1:0);
	
	var RegServiceGroupRowId=$("#RBCServiceGroup").combobox("getValue");
	var RegServiceGroupText=$("#RBCServiceGroup").combobox("getText");
	if ((RegServiceGroupRowId=='undefined')||(RegServiceGroupRowId=="")||(RegServiceGroupText=="")){
		$.messager.alert("警告","挂号服务组不能为空！");
		return ""
	}
	myary[38]="RegServiceGroup"+"!"+RegServiceGroupRowId;
	//排班模板与医生坐诊信息调整医生科室检索按科室分类(默认按诊区)
	myary[39]="IsHideExaBor"+"!"+(eval($("#IsHideExaBor").switchbox("getValue"))==true?1:0);
	///同一时段同一个科室同一号别限额
	myary[40]="DaySameTimeRegLimit"+"!"+DHCWebD_GetObjValue("DaySameTimeRegLimit");
	///挂号界面右侧号别展示默认列表模式
	myary[41]="OPRegListDefault"+"!"+(eval($("#OPRegListDefault").switchbox("getValue"))==true?1:0);
	/// 排班诊室允许跨诊区 
	myary[42]="AllowOpenAllRoms"+"!"+(eval($("#AllowOpenAllRoms").switchbox("getValue"))==true?1:0);
	/// 临时卡能挂号有效天数
	myary[43]="TempCardRegCountLimit"+"!"+$("#TempCardRegCountLimit").val();
	myary[44]="CancelRegNeedINVPrt"+"!"+(eval($("#CancelRegNeedINVPrt").switchbox("getValue"))==true?1:0);
	myary[45]="QryScheduleByClinicGroup"+"!"+(eval($("#QryScheduleByClinicGroup").switchbox("getValue"))==true?1:0);
	myary[46]="OPReturnReason"+"!"+(eval($("#OPReturnReason").switchbox("getValue"))==true?1:0);
	myary[47]="AllocInsuBill"+"!"+(eval($("#AllocInsuBill").switchbox("getValue"))==true?1:0);
	var TimeRangeInclude=$("#TimeRangeInclude").combobox("getValue");
	myary[48]="TimeRangeInclude"+"!"+TimeRangeInclude;
	myary[49]="DocOPRegistBill"+"!"+(eval($("#DocOPRegistBill").switchbox("getValue"))==true?1:0);
	myary[50]="InPatNotAllowOPRegist"+"!"+(eval($("#InPatNotAllowOPRegist").switchbox("getValue"))==true?1:0);
	myary[51]="DocOPRegistInsu"+"!"+(eval($("#DocOPRegistInsu").switchbox("getValue"))==true?1:0);
	myary[52]="OPRegistShowTimeRange"+"!"+(eval($("#OPRegistShowTimeRange").switchbox("getValue"))==true?1:0);
	myary[53]="SeqNoOverRangeTime"+"!"+(eval($("#SeqNoOverRangeTime").switchbox("getValue"))==true?1:0);
	myary[54]="SeqNoOverRangeTimeAdd"+"!"+(eval($("#SeqNoOverRangeTimeAdd").switchbox("getValue"))==true?1:0);
	myary[55]="ResoduSeqNoAnyTime"+"!"+(eval($("#ResoduSeqNoAnyTime").switchbox("getValue"))==true?1:0);
	var myInfo=myary.join("^");
	return myInfo;
}

function ForceCancelRegHandle()
{
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var src="dhcopforcecancelreg.hui.csp?HospID="+HospID;
    src=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(src):src;
	var $code ="<iframe width='100%' height='99%' scrolling='no' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("dhcopregconfig","强制退号安全组设置", '800', '500',"icon-w-add","",$code,"");
}

function DepExpandHandle()
{
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var HospDesc=$HUI.combogrid('#_HospList').getText();
	var src="dhcopregdepexpand.hui.csp?HospID="+HospID;
    src=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(src):src;
	var $code ="<iframe width='100%' height='99%' scrolling='no' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("dhcopregconfig","科室扩展设置:  "+HospDesc, '800', '500',"icon-w-add","",$code,"");
}

function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    }
    });
}
function destroyDialog(id){
   $("body").remove("#"+id); //移除存在的Dialog
   $("#"+id).dialog('destroy');
}
function DayTimeReglessHandle(){
	$("#Alite-dialog").dialog("open");
	PageLogicObj.m_DayTimeReglesDataGrid=DayTimeReglesDataGrid();
	threechecklistDataDataGridLoad()
}
function DayTimeReglesDataGrid(){
	var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {DayTimeRegAddClickHandle();}
    }, {
        text: '删除',
        iconCls: 'icon-remove',
        handler: function() {DayTimeRegDelClickHandle();}
    }];
	var Columns=[[ 
		{field:'Rowid',hidden:true,title:'Rowid'},
		{field:'TimeRange',title:'时段',width:100},
		{field:'LocDesc',title:'科室',width:100},
		{field:'DocDesc',title:'号别',width:100}
    ]]
	var DayTimeReglessTabDataGrid=$("#DayTimeReglessTab").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,50,100],
		idField:'Tid',
		columns :Columns,
		toolbar:toobar,
		onBeforeLoad:function(data){
			$("#DayTimeReglessTab").datagrid('uncheckAll');
		}
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}); 
	return DayTimeReglessTabDataGrid;
}

function threechecklistDataDataGridLoad(){
	$.q({
	    ClassName : "web.DHCOPRegConfig",
	    QueryName : "FindTimeLocDoc",
	    HospRowId : $HUI.combogrid('#_HospList').getValue(),
	    Pagerows:PageLogicObj.m_DayTimeReglesDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_DayTimeReglesDataGrid.datagrid('uncheckAll').datagrid('loadData',GridData);
	}); 
}
function DayTimeRegAddClickHandle(){
	$("#Aliteadd-dialog").dialog("open");
	initDayTimeReg();
	$("#MarkList").combobox('select','');
	$("#MarkList").combobox('loadData',[{}])
}

function DayTimeRegDelClickHandle(){
	var SelectedRow = PageLogicObj.m_DayTimeReglesDataGrid.datagrid('getSelected');
	if (SelectedRow==null){
		$.messager.alert("提示","请选择一行","info");
		return false;
	}
	$.cm({
		ClassName:"web.DHCOPRegConfig",
		MethodName:"DeleteTimeLocDoc",
		RowID:SelectedRow.Rowid,
		dataType:"text",
	},function(data){
		if (data==0){
			$.messager.popover({msg: '删除成功！',type:'success'});
			threechecklistDataDataGridLoad();
		}
	})
}

function BSaveCongfidHandle(){
	var TimeRangeID=$('#TimeRangeList').combobox('getValue');
	if (TimeRangeID==undefined) TimeRangeID="";
	if(TimeRangeID==""){
		$.messager.alert("提示","时段不能为空!","info");
	    return false;
	}
	var LocID=$('#LocList').combobox('getValue');
	if (LocID==undefined) LocID="";
	if(LocID==""){
		$.messager.alert("提示","科室不能为空!","info");
	    return false;
	}
	var MarkID=$('#MarkList').combobox('getValue');
	if (MarkID==undefined) MarkID="";
	if(MarkID==""){
		$.messager.alert("提示","号别不能为空!","info");
	    return false;
	}
	$.cm({
		ClassName:"web.DHCOPRegConfig",
		MethodName:"InsertTimeLocDoc",
		TimeRangeID:TimeRangeID,
		LocID:LocID,
		MarkID:MarkID,
		dataType:"text",
	},function(data){
		if (data==0){
			$.messager.popover({msg: '增加成功！',type:'success'});
			$("#Aliteadd-dialog").dialog("close");
			threechecklistDataDataGridLoad();
		}else if(data=="repeat"){
			$.messager.alert("提示","增加失败！记录重复！");
		}
	})
}

function initDayTimeReg(){
	LoadTImeRange();
	LoadLoc();
}

function LoadTImeRange(){
	$.q({
		ClassName:"web.DHCRBResSession",
		QueryName:"LookUpTimeRangeNew",
		HospID:$HUI.combogrid('#_HospList').getValue()
	},function(Data){
		var cbox = $HUI.combobox("#TimeRangeList", {
				valueField: 'RowId',
				textField: 'Desc', 
				editable:true,
				data: Data['rows'],
				filter: function(q, row){
					if (q=="") return true; 
					q=q.toUpperCase();
					if ((row["Code"].toUpperCase().indexOf(q)>=0)||(row["Alias"].toUpperCase().indexOf(q)>=0)||(row["Desc"].toUpperCase().indexOf(q)>=0)) return true;
				},
				onSelect:function(rec){
				},
				onChange:function(newValue,oldValue){
				}
		 });
	});
}

function LoadLoc(){
	$.q({
		ClassName:"web.DHCRBResSession",
		QueryName:"FindLoc",
		Loc:"",
		UserID:session['LOGON.USERID'],
		HospitalDr:$HUI.combogrid('#_HospList').getValue(),rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#LocList", {
				valueField: 'Hidden',
				textField: 'Desc', 
				editable:true,
				data: Data['rows'],
				filter: function(q, row){
					if (q=="") return true; 
					q=q.toUpperCase();
					if ((row["Code"].toUpperCase().indexOf(q)>=0)||(row["Alias"].toUpperCase().indexOf(q)>=0)||(row["Desc"].toUpperCase().indexOf(q)>=0)) return true;
				},
				onSelect:function(rec){
					if (rec){
						LoadDoc(rec['Hidden']);
					}
				},
				onChange:function(newValue,oldValue){
					if (newValue==""){
						$("#MarkList").combobox('select','');
						$("#MarkList").combobox('loadData',[{}])
					}
				}
		 });
	});
}

function LoadDoc(DepRowId){
	$.q({
		ClassName:"web.DHCRBResSession",
		QueryName:"FindResDoc",
		DepID:DepRowId,
		HospID:$HUI.combogrid('#_HospList').getValue(),rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#MarkList", {
				valueField: 'Hidden1',
				textField: 'Desc', 
				editable:true,
				data: Data['rows'],
				filter: function(q, row){
					if (q=="") return true; 
					q=q.toUpperCase();
					if ((row["Code"].toUpperCase().indexOf(q)>=0)||(row["Hidden2"].toUpperCase().indexOf(q)>=0)||(row["Desc"].toUpperCase().indexOf(q)>=0)) return true;
				},
				onSelect:function(){
				}
		 });
	});
}
function PowerConfigHandle(){
	var HospId=$HUI.combogrid('#_HospList').getValue()
	websys_showModal({
		url:"opadm.powerconfig.hui.csp?HospId="+HospId,
		title:'挂号/排班授权管理',
		width:'95%',height:'95%',
	});
}

function LocSortConfigClick() {
	SetDefConfig("RegistLocSort","RegistSort")
	//SetDefConfig("OutsideLocSort","OutsideSort")
	SetDefConfig("SessionTypeSort","SessionTypeSort")
	SetDefCheckbox("SessionTypeSortCheck","SessionTypeSortCheck")
	SetDefCheckbox("LastQueueNoSortCheck","LastQueueNoSortCheck")
	$("#LocSortWin").dialog("open")
}

function RegArcimConfigHandle(){
	var HospId=$HUI.combogrid('#_HospList').getValue()
	websys_showModal({
		url:"opadm.regarcimconfigconfig.hui.csp?HospId="+HospId,
		title:'挂号附加医嘱设置',
		width:'95%',height:'95%',
	});
}

function SetDefConfig(Node1, TypeId) {
	var HospId=$HUI.combogrid('#_HospList').getValue()
	$.cm({
		ClassName:"web.DHCOPRegConfig",
		MethodName:"GetSpecConfigNode",
		NodeName:Node1,
		HospId:HospId,
		dataType:"text"
	},function(rtn) {
		if ($.hisui.indexOfArray($("#"+TypeId).combobox('getData'),"SortType",rtn) >=0) {
			$("#"+TypeId).combobox("setText",rtn);
		}else{
			$("#"+TypeId).combobox("setText","");
		}
	})
	
}
function SetDefCheckbox(Node1, TypeId) {
	var HospId=$HUI.combogrid('#_HospList').getValue()
	$.cm({
		ClassName:"web.DHCOPRegConfig",
		MethodName:"GetSpecConfigNode",
		NodeName:Node1,
		HospId:HospId,
		dataType:"text"
	},function(rtn) {
		$("#"+TypeId).checkbox('setValue',rtn=="1"?true:false);
	})
	
}
var SortTypeData="";
var SortSessionTypeData=""
function InitSortType() {
	$.q({
		ClassName:"web.DHCBL.BDP.BDPSort",
		QueryName:"GetDataForCmb1",
		rowid:"",desc:"",
		tableName:"User.CTLoc",hospid:$HUI.combogrid('#_HospList').getValue(),
		dataType:"json"
	},function(Data){
		SortTypeData=Data.rows;
		$("#RegistSort,#MarkDocSort").combobox({
			textField:"SortType",
			valueField:"ID",
			data:Data.rows,
			OnChange:function(newValue,OldValue){
				if (!newValue) {
					$(this).combobox('setValue',"");
				}
			}
		})
	})
	$.q({
		ClassName:"web.DHCBL.BDP.BDPSort",
		QueryName:"GetDataForCmb1",
		rowid:"",desc:"",
		tableName:"User.RBCSessionType",hospid:$HUI.combogrid('#_HospList').getValue(),
		dataType:"json"
	},function(Data){
		SortSessionTypeData=Data.rows;
		$("#SessionTypeSort").combobox({
			textField:"SortType",
			valueField:"ID",
			data:Data.rows,
			OnChange:function(newValue,OldValue){
				if (!newValue) {
					$(this).combobox('setValue',"");
				}
			}
		})
	})
}
function SaveConfigClick() {
	var RegistSort=$("#RegistSort").combobox("getText");
	if (($.hisui.indexOfArray(SortTypeData,"SortType",RegistSort)<0)&&(RegistSort!="")) {
		$.messager.alert("提示","请选择挂号处科室列表排序！","info",function(){
			$("#RegistSort").next('span').find('input').focus();
		});
		return false;
	}
	/*var OutsideSort=$("#OutsideSort").combobox("getText");
	if (($.hisui.indexOfArray(SortTypeData,"SortType",OutsideSort)<0)&&(OutsideSort!="")) {
		$.messager.alert("提示","请选择对外接口科室列表排序！","info",function(){
			$("#OutsideSort").next('span').find('input').focus();
		});
		return false;
	}*/
	var SortConfig="RegistLocSort"+"!"+RegistSort //+"^"+"OutsideLocSort"+"!"+OutsideSort
	SaveConfig(SortConfig)
	
	$.messager.show({title:"提示",msg:"保存成功"});
	//$("#LocSortWin").dialog("close")
}
function SaveConfig(SortConfig,NodeFlag) {
	var HospId=$HUI.combogrid('#_HospList').getValue()
    var NodeFlag=NodeFlag||"";
    if ((PageLogicObj.m_AuthFlag==1)&&(NodeFlag=="ReSortQueueNo")){
        var Rtn=$.cm({
            ClassName:"DHCDoc.Interface.Inside.InvokeAuth",
            MethodName:"InvokeReSortQueueNoAuth",
            Coninfo:SortConfig,
            HospID:HospId,
            dataType:"text"
        },false)
        var Arr=Rtn.split("^");
        $.messager.alert("提示",Arr[1],"info");
        LoadAuthHtml();
    }else{
        $.cm({
            ClassName:"web.DHCOPRegConfig",
            MethodName:"SaveConfigHosp",
            Coninfo:SortConfig,
            HospID:HospId
        },false)
    }	
}
function SaveRegSortClick(){
	var SessionTypeSortCheck=$("#SessionTypeSortCheck").checkbox('getValue')?"1":"0";
	var SessionTypeSort=$("#SessionTypeSort").combobox("getText");
	if (($.hisui.indexOfArray(SortSessionTypeData,"SortType",SessionTypeSort)<0)&&(SessionTypeSort!="")&&(SessionTypeSortCheck=="1")) {
		$.messager.alert("提示","请选择挂号职称列表排序！","info",function(){
			$("#SessionTypeSort").next('span').find('input').focus();
		});
		return false;
	}
	if ((SessionTypeSort=="")&&(SessionTypeSortCheck=="1")){
		$.messager.alert("提示","请选择挂号职称列表排序！","info",function(){
			$("#SessionTypeSort").next('span').find('input').focus();
		});
		return false;
		}
	var LastQueueNoSortCheck=$("#LastQueueNoSortCheck").checkbox('getValue')?"1":"0";
	var SortConfig="SessionTypeSortCheck"+"!"+SessionTypeSortCheck+"^"+"SessionTypeSort"+"!"+SessionTypeSort+"^"+"LastQueueNoSortCheck"+"!"+LastQueueNoSortCheck
	SaveConfig(SortConfig)
	
	$.messager.show({title:"提示",msg:"保存成功"});
	}
function BBlackTypeConfig()
{
	var HospId=$HUI.combogrid('#_HospList').getValue()
	websys_showModal({
		url:"dhcblacklist.type.hui.csp?HospId="+HospId,
		title:'黑名单类型设置',
		width:'60%',height:'60%',
	});
}
function ReSortQueueNoConfigHandle(){
	InitReSortQueueNoConfig()
	$("#ReSortQueueNo-dialog").dialog("open")
	}
function InitReSortQueueNoConfig(){
	SetDefRiodeBox("BeforeDateCancelApp")
	SetDefRiodeBox("BeforeDateReturn")
	SetDefRiodeBox("DateUnSplitCancelApp")
	SetDefRiodeBox("DateUnSplitReturn")
	SetDefRiodeBox("DateSplitBeforeCancelApp")
	SetDefRiodeBox("DateSplitBeforeReturn")
	SetDefRiodeBox("DateSplitAfterCancelApp")
	SetDefRiodeBox("DateSplitAfterReturn")
	}
function SetDefRiodeBox(Node1) {
	var HospId=$HUI.combogrid('#_HospList').getValue()
	$.cm({
		ClassName:"web.DHCOPRegConfig",
		MethodName:"GetSpecConfigNode",
		NodeName:Node1,
		HospId:HospId,
		dataType:"text"
	},function(rtn) {
		if (rtn!=0){
			 $HUI.radio("#"+Node1+rtn).setValue(true);
		}else{
			$HUI.radio("#"+Node1+"1").setValue(true);	
		}
	})
}
function SaveReSortQueueNoConfig(){
	var BeforeDateCancelApp=$("input[name='BeforeDateCancelApp']:checked").val();
	var BeforeDateReturn=$("input[name='BeforeDateReturn']:checked").val();
	var DateUnSplitCancelApp=$("input[name='DateUnSplitCancelApp']:checked").val();
	var DateUnSplitReturn=$("input[name='DateUnSplitReturn']:checked").val();
	var DateSplitBeforeCancelApp=$("input[name='DateSplitBeforeCancelApp']:checked").val();
	var DateSplitBeforeReturn=$("input[name='DateSplitBeforeReturn']:checked").val();
	var DateSplitAfterCancelApp=$("input[name='DateSplitAfterCancelApp']:checked").val();
	var DateSplitAfterReturn=$("input[name='DateSplitAfterReturn']:checked").val();
	var SortConfig="BeforeDateCancelApp"+"!"+BeforeDateCancelApp+"^"+"BeforeDateReturn"+"!"+BeforeDateReturn+"^"+"DateUnSplitCancelApp"+"!"+DateUnSplitCancelApp;
	SortConfig=SortConfig+"^"+"DateUnSplitReturn"+"!"+DateUnSplitReturn+"^"+"DateSplitBeforeCancelApp"+"!"+DateSplitBeforeCancelApp
	SortConfig=SortConfig+"^"+"DateSplitBeforeReturn"+"!"+DateSplitBeforeReturn+"^"+"DateSplitAfterCancelApp"+"!"+DateSplitAfterCancelApp
	SortConfig=SortConfig+"^"+"DateSplitAfterReturn"+"!"+DateSplitAfterReturn
	SaveConfig(SortConfig,"ReSortQueueNo")
	$.messager.show({title:"提示",msg:"保存成功"});
}

function DocOPRegistChangeHandler(event,data){
	var Obj=event.target;
	var value=data.value
	var ID=Obj.id;
	if ((ID=="DocOPRegistBill")&&(value===false)){
		$("#DocOPRegistInsu").switchbox('setValue',false);
	}else if((ID=="DocOPRegistInsu")&&(value===true)){
		$("#DocOPRegistBill").switchbox('setValue',true);
	}
}
function DocOPRegistInsuChangeHandler(){
	
}
function SeqNoOverRangeChangeHandler(event,data){
	var Obj=event.target;
	var value=data.value
	var ID=Obj.id;
	if ((ID=="SeqNoOverRangeTime")&&(value==true)){
		$("#SeqNoOverRangeTimeAdd").switchbox('setValue',false);
	}else if((ID=="SeqNoOverRangeTimeAdd")&&(value==true)){
		$("#SeqNoOverRangeTime").switchbox('setValue',false);
	}
}

function LoadAuthHtml() {
    $m({
        ClassName: "BSP.SYS.SRV.AuthItemApply",
        MethodName: "GetStatusHtml",
        AuthCode: "HIS-DOC-REG-RESORTQUEUENO"
    }, function (rtn) {
        if (rtn != "") {
            $(rtn).insertAfter('#SaveResortQueueNoConfig');
            $(rtn).insertAfter('#ReSortQueueNo');
        }
    })
    return;
}
