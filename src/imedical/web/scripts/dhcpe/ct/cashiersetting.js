
//����     dhcpe/ct/cashiersetting.js
//����    ����շ�����
//����    2021.08.15
//������  yupeng
var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
        
    GetLocComp(SessionStr)    
        
    InitCombobox();
    
    InitCashierSettingGrid();
   
    //����
    $("#BSave").click(function() {  
        BSave_click();      
     });
     
   //���������б�change
	$("#LocList").combobox({
       onSelect:function(){  
	        LocList_change();	
		}
	})  
   
})



function LocList_change(){
	
	var LocID=session['LOGON.CTLOCID'];
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; };
	var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
		
	/*****************ҽ���ѱ�ȫ�����¼���(combobox)*****************/
	$('#AdmReason').combobox('setValue','');
	var AdmReasonUrl=$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=SearchAdmReason&ResultSetType=array&hospId="+hospId;
	$('#AdmReason').combobox('reload',AdmReasonUrl);
	/*****************ҽ���ѱ�ȫ�����¼���(combobox)*****************/
	
	 $("#CashierSettingGrid").datagrid('load',{
            ClassName:"web.DHCPE.HISUICommon",
            QueryName:"FindCashierSetting",
            HospID:hospId,
            LocID:LocID
        }); 

	$("#InvMaxListCount,#InvCol").val("");
    $("#AdmReason,#DHCScanCode,#ExtPayMode,#InvDefaultPayMode,#CardMode,#CashierMode,#RoundManager").combobox("setValue","");
    $(".hisui-switchbox").switchbox("setValue",true);		
}


function SetCashierDataByLoc(loc)
{
    //����շ�֧����ʽ
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetCashierPayModeNew",loc);
    var str=ret.split("^")
    $("#CashierMode").combobox("setValues",str);
    
    //��쿨֧����ʽ
     var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetCardPayModeNew",loc);
    var str=ret.split("^")
    $("#CardMode").combobox("setValues",str);
    
    /*
    //����˷�֧����ʽ
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetRefundPayModeNew",loc);
    var str=ret.split("^")
    $("#RefundMode").combobox("setValues",str);
    */
    //Ĭ��֧����ʽ
     var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"InvDefaultPayMode");
    $("#InvDefaultPayMode").combobox("setValue",ret);
    
    //������֧����ʽ
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetExtPayModeNew",loc);
    if(ret!=""){
        var str=ret.split("^")
        $("#ExtPayMode").combobox("setValues",str);
    } 

    //����������֧��
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetDHCScanCodeNew",loc);
    if(ret!=""){
        var str=ret.split("^")
        $("#DHCScanCode").combobox("setValues",str);
    }
    
    //ҽ���ѱ�
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetAdmReasonNew",loc);
    var str=ret.split("^")
    $("#AdmReason").combobox("setValues",str);

    //��Ʊ��ӡ��ϸ
     var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"InvListFlag");
    if(ret=="1")    $("#InvListFlag").switchbox("setValue",true);
    else    $("#InvListFlag").switchbox("setValue",false)
    
    
    //��Ʊ��ϸ��
     var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"InvMaxListCount");
    $("#InvMaxListCount").val(ret);
    
    
    //��ӡ�������
     var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"InvPrintCatInfo");
    if(ret=="Y")    $("#InvPrintCatInfo").switchbox("setValue",true);
    else    $("#InvPrintCatInfo").switchbox("setValue",false);
    
    //��Ʊ��ӡ����
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"InvCol");
    $("#InvCol").val(ret);
    
    //�˷Ѵ�ӡ��Ʊ
     var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"IfPrintMinusInv");
    if(ret=="Y") $("#IfPrintMinusInv").switchbox("setValue",true);
    else    $("#IfPrintMinusInv").switchbox("setValue",false)
    
    //���������շѹ���
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"AllowCharge");
    if(ret=="1")    $("#AllowCharge").switchbox("setValue",true);
    else    $("#AllowCharge").switchbox("setValue",false);
    
    //�Զ��ֱ����
     var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"RoundManager");
     $("#RoundManager").combobox("setValue",ret);
     
     //��쿨��������
     var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"IsCardPassWord");
    if(ret=="Y") $("#IsCardPassWord").switchbox("setValue",true);
    else    $("#IsCardPassWord").switchbox("setValue",false)
}
function BSave_click()
{
   //����
    var NowLoc=$("#LocList").combobox('getValue')
    if (($("#LocList").combobox('getValue')==undefined)||($("#LocList").combobox('getText')=="")){var NowLoc="";}
    if(NowLoc=="") 
    {
        $.messager.alert("��ʾ","��ѡ����Ҫ���õĿ���!","info");
        return;
    }
    
    if(NowLoc!="")
    {
        if (($("#LocList").combobox('getValue'))==($("#LocList").combobox('getText')))  {
            $.messager.alert("��ʾ","����ѡ����ȷ!","info");
            return false;
        }
        
    }
    
    //����շ�֧����ʽ
    var CashierMode=$("#CashierMode").combobox("getValues");
    var str=CashierMode.join("^");
    tkMakeServerCall("web.DHCPE.HISUICommon","SetCashierPayModeNew",str,NowLoc);
    
    
    //��쿨֧����ʽ
    var CardMode=$("#CardMode").combobox("getValues");
    var str=CardMode.join("^");
    tkMakeServerCall("web.DHCPE.HISUICommon","SetCardPayModeNew",str,NowLoc);
    
    /*
    //����˷�֧����ʽ
    var RefundMode=$("#RefundMode").combobox("getValues");
    var str=RefundMode.join("^");
    tkMakeServerCall("web.DHCPE.HISUICommon","SetRefundPayModeNew",str,NowLoc);
    */
    
    //Ĭ��֧����ʽ
    var str=$("#InvDefaultPayMode").combobox("getValue");
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"InvDefaultPayMode",str);
    
    //������֧����ʽ
    var ExtPayMode=$("#ExtPayMode").combobox("getValues");
    var str=ExtPayMode.join("^");
    tkMakeServerCall("web.DHCPE.HISUICommon","SetExtPayModeNew",str,NowLoc);  
    
    //����������֧��
    var ExtPayMode=$("#DHCScanCode").combobox("getValues");
    var str=ExtPayMode.join("^");
    tkMakeServerCall("web.DHCPE.HISUICommon","SetDHCScanCodeNew",str,NowLoc); 
 
    
    //ҽ���ѱ�
     var AdmReason=$("#AdmReason").combobox("getValues");
    var str=AdmReason.join("^");
    tkMakeServerCall("web.DHCPE.HISUICommon","SetAdmReasonNew",str,NowLoc);

    //��Ʊ��ӡ��ϸ
     var str=$("#InvListFlag").switchbox("getValue");
    if(str) str="1"
    else str="0"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"InvListFlag",str);
    
    //��Ʊ��ϸ��
     var str=$("#InvMaxListCount").val();
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"InvMaxListCount",str);
    
    //��Ʊ��ӡ����
     var str=$("#InvCol").val();
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"InvCol",str);
    
    //��ӡ�������
     var str=$("#InvPrintCatInfo").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"InvPrintCatInfo",str);
    
    //���������շѹ���
     var str=$("#AllowCharge").switchbox("getValue");
    if(str) str="1"
    else str="0"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"AllowCharge",str);
    
    //�˷Ѵ�ӡ��Ʊ
    var str=$("#IfPrintMinusInv").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"IfPrintMinusInv",str);
    
    //�Զ��ֱ����
     var str=$("#RoundManager").combobox("getValue");
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"RoundManager",str);
    
    //��쿨��������
    var str=$("#IsCardPassWord").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"IsCardPassWord",str);
    
    $.messager.alert("��ʾ","���óɹ�!","success");
    
	 var LocID=$("#LocList").combobox('getValue');
	 var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
	 
    $("#CashierSettingGrid").datagrid('load',{
            ClassName:"web.DHCPE.HISUICommon",
            QueryName:"FindCashierSetting",
            HospID:hospId,
            LocID:LocID
        });
        
        BClear_click();
}

//����
function BClear_click(){
    $("#InvMaxListCount,#InvCol").val("");
    $(".hisui-combobox").combobox("setValue","");
    $(".hisui-switchbox").switchbox("setValue",true);
    $(".hisui-combogrid").combogrid("setValue","");
        
}


function InitCashierSettingGrid()
{
    
     var LocID=session['LOGON.CTLOCID'];
	 var LocListID=$("#LocList").combobox('getValue');
	 if(LocListID!=""){var LocID=LocListID; };
	 var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
	 
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
            HospID:hospId,
            LocID:LocID
        },
        columns:[[
        
        {field:'Loc',title:'Loc'},
        {field:'LocDesc',title:'����'},
        {field:'CashierMode',title:'����շ�֧����ʽ'},
        {field:'CardMode',title:'��쿨֧����ʽ'},
        //{field:'RefundMode',title:'����˷�֧����ʽ'},
        {field:'InvDefaultPayMode',title:'Ĭ��֧����ʽ'},
        {field:'ExtPayMode',title:'������֧����ʽ'},
        {field:'DHCScanCode',title:'����������֧��'},
        {field:'AdmReason',title:'ҽ���ѱ�'},
        {field:'InvListFlag',title:'��Ʊ��ӡ��ϸ'},
        {field:'InvMaxListCount',title:'��Ʊ��ϸ��'},
        {field:'InvCol',title:'��Ʊ��ӡ����'},
        {field:'InvPrintCatInfo',title:'��ӡ�������'},
        {field:'AllowCharge',title:'���������շѹ���'},
        {field:'IfPrintMinusInv',title:'�˷Ѵ�ӡ��Ʊ'},
        {field:'RoundManager',title:'�Զ��ֱ����'},
        {field:'IsCardPassWord',title:'��쿨��������'}
        
        ]],
        onSelect: function (rowIndex, rowData) {
               
            var loc=rowData.Loc;
            var LocDesc=rowData.LocDesc;
            //$('#NowLoc').combogrid('grid').datagrid('reload',{'q':LocDesc});
            setValueById("LocList",loc)
            SetCashierDataByLoc(loc)    
                
                    
        }
        
            
    })
}
function InitCombobox()
{
    
     var LocID=session['LOGON.CTLOCID'];
	 var LocListID=$("#LocList").combobox('getValue');
	 if(LocListID!=""){var LocID=LocListID; };
	 var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
	 
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
            param.hospId = hospId;
        },
        
        columns:[[
            {field:'CTLOCID',hidden:true},
            {field:'CTLOCCODE',title:'���ұ���',width:100},
            {field:'Desc',title:'��������',width:200}
            
            
            
        ]]
    });
    
    //����շ�֧����ʽ
    var CashierModeObj = $HUI.combobox("#CashierMode",{
        url:$URL+"?ClassName=web.DHCPE.Public.SettingCashierEdit&QueryName=SearchPayMode&ResultSetType=array",
        valueField:'TPayModeID',
        rowStyle:'checkbox',
        textField:'TPayMode',
        multiple:true,
        selectOnNavigation:false,
        panelHeight:300,
        editable:false
    });
    
    //��쿨֧����ʽ
    var CardModeObj = $HUI.combobox("#CardMode",{
        url:$URL+"?ClassName=web.DHCPE.Public.SettingCashierEdit&QueryName=SearchPayMode&ResultSetType=array",
        valueField:'TPayModeID',
        rowStyle:'checkbox',
        textField:'TPayMode',
        multiple:true,
        selectOnNavigation:false,
        panelHeight:300,
        editable:false
    });
    
    /*
    //�˷�֧����ʽ
    var RefundModeObj = $HUI.combobox("#RefundMode",{
        url:$URL+"?ClassName=web.DHCPE.Public.SettingCashierEdit&QueryName=SearchPayMode&ResultSetType=array",
        valueField:'TPayModeID',
        rowStyle:'checkbox',
        textField:'TPayMode',
        multiple:true,
        selectOnNavigation:false,
        panelHeight:300,
        editable:false
    });
    */
    
    //Ĭ��֧����ʽ
    var InvDefaultPayModeObj = $HUI.combobox("#InvDefaultPayMode",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPayMode&ResultSetType=array",
        valueField:'id',
        textField:'text'
    });
    
    //������֧����ʽ
    var ExtPayModeObj = $HUI.combobox("#ExtPayMode",{
        url:$URL+"?ClassName=web.DHCPE.Public.SettingCashierEdit&QueryName=SearchPayMode&ResultSetType=array",
        valueField:'TPayModeCode',
        rowStyle:'checkbox',
        textField:'TPayMode',
        multiple:true,
        selectOnNavigation:false,
        panelHeight:300,
        editable:false
    });
    
    //����������֧��
    var ScanPayModeObj = $HUI.combobox("#DHCScanCode",{
        url:$URL+"?ClassName=web.DHCPE.Public.SettingCashierEdit&QueryName=SearchPayMode&ResultSetType=array",
        valueField:'TPayModeCode',
        rowStyle:'checkbox',
        textField:'TPayMode',
        multiple:true,
        selectOnNavigation:false,
        panelHeight:300,
        editable:false
    });
    
    //ҽ���ѱ�
    var AdmReasonObj = $HUI.combobox("#AdmReason",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=SearchAdmReason&ResultSetType=array&hospId="+hospId,
        valueField:'TID',
        rowStyle:'checkbox',
        textField:'TDesc',
        multiple:true,
        selectOnNavigation:false,
        panelHeight:300,

    });
    
}