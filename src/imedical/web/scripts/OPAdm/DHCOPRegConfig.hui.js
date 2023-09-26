var PageLogicObj={
	m_DayTimeReglesDataGrid:""
};
$(function(){
	//��ʼ��ҽԺ
	var hospComp = GenHospComp("Doc_OPAdm_BaseConfig");
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		//�Һŷ�����
		LoadServiceGroup();
		LoadFeeCatList();
		//��������
		InitSortType();
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		//ҳ��Ԫ�س�ʼ��
		PageHandle();
		Init();
	}
	//�¼���ʼ��
	InitEvent();
});

function PageHandle()
{
	//���������ʼ��
	LoadFeeCatList()
	//ҽ��������ʼ��
	LoadOrderList()
	//�Һŷ�����
	LoadServiceGroup()
	//ҽ��ʵʱ�����ʼ��
	LoadInsuBill()
	//��������
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
	//�Һŷ�����
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
	 //��������
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
	 //ԤԼ������
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
	 //���շ�����
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
	 //���������
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
}

function LoadOrderList()
{
	//������ҽ��
	$("#order").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'orderid',
        textField:'order',
        columns:[[  
            {field:'orderid',title:'ID'},
			{field:'order',title:'����',width:350}
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
					$("#getorderid").val(rec["orderid"])
					$("#order").blur();
				}
			});
		}
    });
	//���˵�����ҽ��
	$("#NeedBillCardFeeOrder").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'orderid',
        textField:'order',
        columns:[[  
            {field:'orderid',title:'ID'},
			{field:'order',title:'����',width:350}
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
    //���ҽ��
	$("#FreeOrder").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'orderid',
        textField:'order',
        columns:[[  
            {field:'orderid',title:'ID'},
			{field:'order',title:'����',width:350}
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
		//�Һŷ�����
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
		//����ҽ��ʵʱ����
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
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$.cm({
		ClassName:"web.DHCOPRegConfig",
		MethodName:"GetDHCOPRegConfigInfo",
		dataType:"text",
		HospID:HospID,
	},function(rtnStr){
		var rtnArr=rtnStr.split(String.fromCharCode(1))
		//��ʼ���ı���Ŀ
		$("#AppQtyDefault").val(rtnArr[0]);
		$("#AppStartNoDefault").val(rtnArr[1]);
		$("#AdmTimeRangeCount").val(rtnArr[2]);
		$("#AppBreakLimit").val(rtnArr[3]);
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
		//��ʼ���Һ����ҽ����Ϣ
		if (MRArcimInfo!=""){
			$("#getorderid").val(MRArcimInfo.split("@")[0])
			$("#order").val(MRArcimInfo.split("@")[1])
		}
		if (NeedBillCardFeeOrderInfo!=""){
			$("#NeedBillCardFeeOrderID").val(NeedBillCardFeeOrderInfo.split("@")[0])
			$("#NeedBillCardFeeOrder").val(NeedBillCardFeeOrderInfo.split("@")[1])
		}
		if (FreeOrderInfo!=""){
			$("#FreeOrderID").val(FreeOrderInfo.split("@")[0])
			$("#FreeOrder").val(FreeOrderInfo.split("@")[1])
		}
		
		//��ʼ����������
		$("#RegFeeBillSub").combobox("setValue",rtnArr[16]);
		$("#CheckFeeBillSub").combobox("setValue",rtnArr[17]);
		$("#AppFeeBillSub").combobox("setValue",rtnArr[18]);
		$("#HoliFeeBillSub").combobox("setValue",rtnArr[19]);
		$("#ReCheckFeeBillSub").combobox("setValue",rtnArr[20]);
		$("#RBCServiceGroup").combobox("setValue",rtnArr[21]);
		$("#EnableInsuBill").combobox("setValue",rtnArr[22]);
		//��ʼ����ѡ��Ŀ
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
		
		if (rtnArr[30]==1){
			$("#RegTreeQuery").switchbox('setValue',true);
		}else{
			$("#RegTreeQuery").switchbox('setValue',false);
		}
		
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
	$("#SaveConfig").click(SaveConfigClick);
	$('#BBlackType').click(BBlackTypeConfig);
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
			$.messager.alert("��ʾ","����ɹ�");
		}else{
			$.messager.alert("��ʾ","����ʧ��");
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
		$.messager.alert("����","�Һŷ����಻��Ϊ�գ�");
		return ""
	}
	if ((CheckFeeBillSub=='undefined')||(CheckFeeBillSub=="")||(CheckFeeBillSubText=="")){
		$.messager.alert("����","�������಻��Ϊ�գ�");
		return ""
	}
	
	var AppFeeBillSub=$("#AppFeeBillSub").combobox("getValue");
	var HoliFeeBillSub=$("#HoliFeeBillSub").combobox("getValue");
	var ReCheckFeeBillSub=$("#ReCheckFeeBillSub").combobox("getValue");
	//���������
	//var OldManFree=combo_OldManFree.getSelectedValue();
	
	myary[1]="AutoBregno"+"!"+myary[1];
	myary[2]="AppReturnTime"+"!"+DHCWebD_GetObjValue("AppReturnTime");
	myary[3]="AppDaysLimit"+"!"+DHCWebD_GetObjValue("AppDaysLimit");
	myary[4]="DayAppCountLimit"+"!"+DHCWebD_GetObjValue("DayAppCountLimit");
	myary[5]="AppQtyDefault"+"!"+DHCWebD_GetObjValue("AppQtyDefault");
	myary[6]="AppStartNoDefault"+"!"+DHCWebD_GetObjValue("AppStartNoDefault");
	myary[7]="AdmTimeRangeCount"+"!"+DHCWebD_GetObjValue("AdmTimeRangeCount");
	myary[8]="SchedulePeriod"+"!"+DHCWebD_GetObjValue("SchedulePeriod");
	myary[9]="AppBreakLimit"+"!"+DHCWebD_GetObjValue("AppBreakLimit");
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
	//������ҽ��
	if (DHCWebD_GetObjValue("order")==""){$("#getorderid").val("")};
	myary[22]="MRArcimId"+"!"+DHCWebD_GetObjValue("getorderid")+'@'+DHCWebD_GetObjValue("order");
	myary[23]="OldManFree"+"!"+OldManFree;
	myary[24]="ReCheckFeeBillSub"+"!"+ReCheckFeeBillSub;
	//���˵�����ҽ��
	if (DHCWebD_GetObjValue("NeedBillCardFeeOrder")==""){$("#NeedBillCardFeeOrderID").val("")}
	myary[25]="NeedBillCardFeeOrder"+"!"+DHCWebD_GetObjValue("NeedBillCardFeeOrderID")+'@'+DHCWebD_GetObjValue("NeedBillCardFeeOrder");
	//���ҽ��
	if ($("#FreeOrder").lookup('getText')=="") {$("#FreeOrderID").val('');}
	if (DHCWebD_GetObjValue("FreeOrder")==""){$("#FreeOrderID").val('')}
	myary[26]="FreeOrder"+"!"+$("#FreeOrderID").val()+'@'+DHCWebD_GetObjValue("FreeOrder");
	myary[27]="ReturnNotAllowReg"+"!"+(eval($("#ReturnNotAllowReg").switchbox("getValue"))==true?1:0);
	myary[28]="ReturnNotAllowAdd"+"!"+(eval($("#ReturnNotAllowAdd").switchbox("getValue"))==true?1:0);
	myary[29]="NotNullRealAmount"+"!"+(eval($("#NotNullRealAmount").switchbox("getValue"))==true?1:0);
	myary[30]="NotNeedNotFeeBill"+"!"+(eval($("#NotNeedNotFeeBill").switchbox("getValue"))==true?1:0);
	myary[31]="HolidayNotCreateSche"+"!"+(eval($("#HolidayNotCreateSche").switchbox("getValue"))==true?1:0);
	myary[32]="MedifyPatTypeSynAdmRea"+"!"+(eval($("#MedifyPatTypeSynAdmRea").switchbox("getValue"))==true?1:0);
	//��������Һ���״��ѯ 20130425
	myary[33]="RegTreeQuery"+"!"+(eval($("#RegTreeQuery").switchbox("getValue"))==true?1:0);
	//��ǰȡԤԼ��
	myary[34]="AdvanceAppAdm"+"!"+(eval($("#AdvanceAppAdm").switchbox("getValue"))==true?1:0);
	//ÿ��ÿ�����ͬ�����޶�
	myary[35]="DaySameLocRegCountLimit"+"!"+DHCWebD_GetObjValue("DaySameLocRegCountLimit");
	//�Ƿ����ùҺ�ҽ��ʵʱ����
	var EnableInsuBill=0;
	var EnableInsuBill=$("#EnableInsuBill").combobox("getValue");
	myary[36]="EnableInsuBill"+"!"+EnableInsuBill;
	myary[37]="AppReturnNotAllowRegAdd"+"!"+(eval($("#AppReturnNotAllowRegAdd").switchbox("getValue"))==true?1:0);
	
	var RegServiceGroupRowId=$("#RBCServiceGroup").combobox("getValue");
	var RegServiceGroupText=$("#RBCServiceGroup").combobox("getText");
	if ((RegServiceGroupRowId=='undefined')||(RegServiceGroupRowId=="")||(RegServiceGroupText=="")){
		$.messager.alert("����","�Һŷ����鲻��Ϊ�գ�");
		return ""
	}
	myary[38]="RegServiceGroup"+"!"+RegServiceGroupRowId;
	//�Ű�ģ����ҽ��������Ϣ����ҽ�����Ҽ��������ҷ���(Ĭ�ϰ�����)
	myary[39]="IsHideExaBor"+"!"+(eval($("#IsHideExaBor").switchbox("getValue"))==true?1:0);
	///ͬһʱ��ͬһ������ͬһ�ű��޶�
	myary[40]="DaySameTimeRegLimit"+"!"+DHCWebD_GetObjValue("DaySameTimeRegLimit");
	///�ҺŽ����Ҳ�ű�չʾĬ���б�ģʽ
	myary[41]="OPRegListDefault"+"!"+(eval($("#OPRegListDefault").switchbox("getValue"))==true?1:0);
	/// �Ű�������������� 
	myary[42]="AllowOpenAllRoms"+"!"+(eval($("#AllowOpenAllRoms").switchbox("getValue"))==true?1:0);
	/// ��ʱ���ܹҺ���Ч����
	myary[43]="TempCardRegCountLimit"+"!"+$("#TempCardRegCountLimit").val();
	myary[44]="CancelRegNeedINVPrt"+"!"+(eval($("#CancelRegNeedINVPrt").switchbox("getValue"))==true?1:0);
	myary[45]="QryScheduleByClinicGroup"+"!"+(eval($("#QryScheduleByClinicGroup").switchbox("getValue"))==true?1:0);
	var myInfo=myary.join("^");
	return myInfo;
}

function ForceCancelRegHandle()
{
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var src="dhcopforcecancelreg.hui.csp?HospID="+HospID;
	var $code ="<iframe width='100%' height='99%' scrolling='no' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("dhcopregconfig","ǿ���˺Ű�ȫ������", '800', '500',"icon-w-add","",$code,"");
}

function DepExpandHandle()
{
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var HospDesc=$HUI.combogrid('#_HospList').getText();
	var src="dhcopregdepexpand.hui.csp?HospID="+HospID;
	var $code ="<iframe width='100%' height='99%' scrolling='no' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("dhcopregconfig","������չ����:  "+HospDesc, '800', '500',"icon-w-add","",$code,"");
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
function DayTimeReglessHandle(){
	$("#Alite-dialog").dialog("open");
	PageLogicObj.m_DayTimeReglesDataGrid=DayTimeReglesDataGrid();
	threechecklistDataDataGridLoad()
}
function DayTimeReglesDataGrid(){
	var toobar=[{
        text: '����',
        iconCls: 'icon-add',
        handler: function() {DayTimeRegAddClickHandle();}
    }, {
        text: 'ɾ��',
        iconCls: 'icon-remove',
        handler: function() {DayTimeRegDelClickHandle();}
    }];
	var Columns=[[ 
		{field:'Rowid',hidden:true,title:'Rowid'},
		{field:'TimeRange',title:'ʱ��',width:100},
		{field:'LocDesc',title:'����',width:100},
		{field:'DocDesc',title:'�ű�',width:100}
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
		onClickCell:function(rowIndex, field, value){
			},
		onCheck:function(index, row){
		},
		onUnselect:function(index, row){
		},
		onBeforeSelect:function(index, row){

		},onLoadSuccess:function(data){
		}
	}); 
	return DayTimeReglessTabDataGrid;
}

function threechecklistDataDataGridLoad(){
	$.q({
	    ClassName : "web.DHCOPRegConfig",
	    QueryName : "FindTimeLocDoc",
	    HospRowId : $HUI.combogrid('#_HospList').getValue(),
	    Pagerows:PageLogicObj.m_DayTimeReglesDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_DayTimeReglesDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
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
		$.messager.alert("��ʾ","��ѡ��һ��","info");
		return false;
	}
	$.cm({
		ClassName:"web.DHCOPRegConfig",
		MethodName:"DeleteTimeLocDoc",
		RowID:SelectedRow.Rowid,
		dataType:"text",
	},function(data){
		if (data==0){
			$.messager.alert("��ʾ","ɾ���ɹ�","info");
			threechecklistDataDataGridLoad();
		}
	})
}

function BSaveCongfidHandle(){
	var TimeRangeID=$('#TimeRangeList').combobox('getValue');
	if (TimeRangeID==undefined) TimeRangeID="";
	if(TimeRangeID==""){
		$.messager.alert("��ʾ","ʱ�β���Ϊ��!","info");
	    return false;
	}
	var LocID=$('#LocList').combobox('getValue');
	if (LocID==undefined) LocID="";
	if(LocID==""){
		$.messager.alert("��ʾ","���Ҳ���Ϊ��!","info");
	    return false;
	}
	var MarkID=$('#MarkList').combobox('getValue');
	if (MarkID==undefined) MarkID="";
	if(MarkID==""){
		$.messager.alert("��ʾ","�ű���Ϊ��!","info");
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
			$.messager.alert("��ʾ","���ӳɹ�","info");
			$("#Aliteadd-dialog").dialog("close");
			threechecklistDataDataGridLoad();
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
		HospID:$HUI.combogrid('#_HospList').getValue()
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
		title:'�Һ�/�Ű���Ȩ����',
		width:'95%',height:'95%',
	});
}

function LocSortConfigClick() {
	SetDefConfig("RegistLocSort","RegistSort")
	SetDefConfig("OutsideLocSort","OutsideSort")
	$("#LocSortWin").window("open")
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
		$("#"+TypeId).combobox("setText",rtn)
	})
	
}
var SortTypeData="";
function InitSortType() {
	$.q({
		ClassName:"web.DHCBL.BDP.BDPSort",
		QueryName:"GetDataForCmb1",
		rowid:"",desc:"",
		tableName:"User.CTLoc",hospid:$HUI.combogrid('#_HospList').getValue(),
		dataType:"json"
	},function(Data){
		SortTypeData=Data.rows;
		$("#RegistSort,#OutsideSort,#MarkDocSort").combobox({
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
		$.messager.alert("��ʾ","��ѡ��ҺŴ������б�����","info",function(){
			$("#RegistSort").next('span').find('input').focus();
		});
		return false;
	}
	var OutsideSort=$("#OutsideSort").combobox("getText");
	if (($.hisui.indexOfArray(SortTypeData,"SortType",OutsideSort)<0)&&(OutsideSort!="")) {
		$.messager.alert("��ʾ","��ѡ�����ӿڿ����б�����","info",function(){
			$("#OutsideSort").next('span').find('input').focus();
		});
		return false;
	}
	var SortConfig="RegistLocSort"+"!"+RegistSort+"^"+"OutsideLocSort"+"!"+OutsideSort
	SaveConfig(SortConfig)
	
	$.messager.show({title:"��ʾ",msg:"����ɹ�"});
	$("#LocSortWin").window("close")
}
function SaveConfig(SortConfig) {
	var HospId=$HUI.combogrid('#_HospList').getValue()
	$.cm({
		ClassName:"web.DHCOPRegConfig",
		MethodName:"SaveConfigHosp",
		Coninfo:SortConfig,
		HospID:HospId
	},false)
}
function BBlackTypeConfig()
{
	var HospId=$HUI.combogrid('#_HospList').getValue()
	websys_showModal({
		url:"dhcblacklist.type.hui.csp?HospId="+HospId,
		title:'��������������',
		width:'60%',height:'60%',
	});
}