
//����         DHCPEPreAuditList.hisui.js
//����         ����hisui
//��������   2019.11.6
//�޸�����   2022.12.24
//������     xy

$(function(){
    
    InitCombobox();
    
    InitPreAuditListGrid();
    
    SetButtonDisabl("","","");  
    
    //���úϲ�
     $("#BMerge").click(function() { 
        BMerge_click(); 
    });

     //����
    $("#BUpdate").click(function() {    
        BUpdate_click();        
        });  
     
     //���
    $("#BAudit").click(function() { 
        BAudit_click();         
       });
       
    //���֧�� 
    $("#BAsCharged").click(function() { 
        BAsCharged_click();     
        });
    
    //���
     $("#BSplit").click(function() {    
        BSplit_click();         
       });
    
    //�������
     $("#BUnAsCharged").click(function() {  
        BUnAsCharged_click();       
        });  
     
    //�Ż���ʽ
    $("#privilegeMode").combobox({
       onSelect:function(){
            PrivilegeMode_change();
    }
    });
    
    
     
    
})



function GetSelectedIds() {


    var ids = ""
    var selectrow = $("#PreAuditListTab").datagrid("getSelections");//��ȡ�������飬��������
    for (var i = 0; i < selectrow.length; i++) {
        if (ids == "") {
            ids = selectrow[i].TRowId
        } else {
            ids = ids + "," + selectrow[i].TRowId
        }

    }


    return ids;
}


//���úϲ�
function BMerge_click(){

    var PreAuditStr=GetSelectedIds(); //��ȡ���ϲ�����˼�¼�Ĵ�
    if(PreAuditStr.split(",").length<2){
         $.messager.alert("��ʾ", "��ѡ����ϲ��ķ��ü�¼!", "info");
         return false;
    }
    //alert(PreAuditStr)
    var ret=tkMakeServerCall("web.DHCPE.ItemFeeList","MergeAudit",PreAuditStr);
    if(ret=="0"){
         $.messager.popover({msg: '�ϲ����ü�¼�ɹ���',type:'success',timeout: 1000}); 
    }else{
        $.messager.alert("��ʾ",ret,"info");
    }
    
    $('#PreAuditListTab').datagrid('load', {
            ClassName:"web.DHCPE.PreAudit",
            QueryName:"SerchPreAudit",
            ADMType:ADMType,
            CRMADM:CRMADM,
            GIADM:GIADM
        
        });
}

function BSplit_click()
{
    var PreStatus="",DepartName="",PreAuditID="",SplitAmt="";
    
    var SplitAmt=getValueById("SplitAmt");
    if(SplitAmt==""){
        $.messager.alert("��ʾ","�������ֽ��","info");
        return false;
    }

    var FactAmount=$("#FactAmount").val();
    if(+SplitAmt<=0){
            $.messager.alert("��ʾ","��ֽ��Ӧ����0","info");
            return false;
    }
    if(+SplitAmt>=+FactAmount){
        $.messager.alert("��ʾ","��ֽ��ӦС�����ս��","info");
        return false;
    }
    
    
    var PreAuditID=$("#RowID").val();
    
    var ret=tkMakeServerCall("web.DHCPE.PreAuditEx","SplitAudit",PreAuditID,ADMType,CRMADM,PreStatus,DepartName+"^"+SplitAmt);
    
    var Arr=ret.split("^");
    if (Arr[0]!="0"){
        $.messager.alert("��ʾ","���ʧ��:"+Arr[1],"error");
        return false;
    }else{
    
        $("#RowID").val("");
        $('#PreAuditListTab').datagrid('load', {
            ClassName:"web.DHCPE.PreAudit",
            QueryName:"SerchPreAudit",
            CRMADM:CRMADM,
            ADMType:ADMType,
            GIADM:GIADM,
        
        });
    }
    
}

//���
function BAudit_click()
{
    var Type="CancelAudited";
    if($.trim($("#BAudit").text())=="���"){  
        Type="Audited";
        }
    
    AuditUpdate(Type,"");
}


//����
function BUpdate_click()
{
    var PrivilegeMode=$("#privilegeMode").combobox('getValue');
    var selected = $('#PreAuditListTab').datagrid('getSelected');
    
    if(selected.TNoDiscount=="Y"){
        if ((PrivilegeMode=="OR")||(PrivilegeMode=="OS")){
            $.messager.confirm("ȷ��", "ȷ��Ҫ�Բ����۵���Ŀ���д��۲�����", function(r){
            if (r){
                BUpdateCommon_click();
                    
            }
        }); 
    }else{
        BUpdateCommon_click();
    }
  }else{
      BUpdateCommon_click();
  }
    
    
    
}

function BUpdateCommon_click()
{
    var InfoStr=""
    var Rebate=$("#Rebate").val();
    var PrivilegeMode=$("#privilegeMode").combobox('getValue');
    var AccountAmount=$("#AccountAmount").val();
    var yikoujia=$("#SaleAmount").val();
     if (PrivilegeMode=="OS"){
        
        if (yikoujia=="") {
            
            $.messager.alert("��ʾ","���۽���Ϊ��","info");
            return false;
        }
        if (yikoujia<=0) {
            
            $.messager.alert("��ʾ","���۽��Ӧ����0","info");
            return false;
        }
        if((yikoujia.indexOf(".")!="-1")&&(yikoujia.toString().split(".")[1].length>2))
        {
            $.messager.alert("��ʾ","���۽��С������ܳ�����λ","info");
            return false;
        }

        
        var Rebate=(yikoujia/AccountAmount)*100
        Rebate= Rebate.toFixed(4)
    
        }
        else{
            $("#SaleAmount").val("");
            }

    InfoStr=InfoStr+"^"+Rebate;
    InfoStr=InfoStr+"^"+$("#SaleAmount").val();
    FactAmount=$("#FactAmount").val();
    InfoStr=InfoStr+"^"+FactAmount;
    InfoStr=InfoStr+"^"+$("#Remark").val();
    InfoStr=InfoStr+"^"+PrivilegeMode;
    if (PrivilegeMode=="OR")
    {
        if (Rebate=="")
        {
            $.messager.alert("��ʾ","�ۿ��ʲ���Ϊ��","info");
            websys_setfocus('FactAmount');
            return;
        }
        if(Rebate>100)
        {
            $.messager.alert("��ʾ","�ۿ��ʲ��ܴ���100","info");
            return;
        }
        if(Rebate<0)
        {
            $.messager.alert("��ʾ","�ۿ��ʲ���С��0","info");
            return;
        }

    var userId=session['LOGON.USERID'];
    //var ReturnStr=tkMakeServerCall("web.DHCPE.ChargeLimit","DFLimit",userId)
    //var DFLimit=ReturnStr;

    var LocID=session['LOGON.CTLOCID'];
    ////�Żݴ���^ȡ��/��ͬ�շ�^������ģʽ^����ۿ�
    var OPflagStr=tkMakeServerCall("web.DHCPE.CT.ChargeLimit","GetOPChargeLimitInfo",userId,LocID);
    var OPflagOne=OPflagStr.split("^");
    var DFLimit=OPflagOne[3]; //����ۿ���(��Ժ��)

    if (DFLimit==0){
        $.messager.alert("��ʾ","û�д���Ȩ��","info");
         return;
        }
    if(+DFLimit>+Rebate){
       $.messager.alert("��ʾ","Ȩ�޲���,�����ۿ�Ȩ��Ϊ:"+DFLimit+"%","info");
        return;
        }
    }
    if (PrivilegeMode=="TP")
    {
        if (FactAmount=="")
        {
            $.messager.alert("��ʾ","���ս���Ϊ��","info");
            websys_setfocus('FactAmount');
            return;
        }
    }
    
    AuditUpdate("Update",InfoStr);
    
}

function AuditUpdate(Type,DataStr)
{
    var RowID=$("#RowID").val();
    if (RowID=="") {
        $.messager.alert("��ʾ","����ѡ���¼","info");
        return;
        }
    var Flag=tkMakeServerCall("web.DHCPE.PreAudit","UpdatePreAudit",Type,RowID,DataStr)
    if (Flag!=0){
        $.messager.alert("��ʾ","����ʧ��"+Flag,"error");
        return;
    }else{
        $.messager.alert("��ʾ","���³ɹ�","success");
        $("#RowID").val("");
        $('#PreAuditListTab').datagrid('load', {
            ClassName:"web.DHCPE.PreAudit",
            QueryName:"SerchPreAudit",
            CRMADM:CRMADM,
            ADMType:ADMType,
            GIADM:GIADM,
        
        });
    }
    
    
    
}

function BAsCharged_click()
{
    //if($("#BAsCharged").linkbutton('options').disabled==true){return;}
    var userId="",RowID="",obj,encmeth="",ChargedType="",ChargedRemark="";
    var userId=session['LOGON.USERID'];
    var RowID=$("#RowID").val();
    if (RowID=="") {
        $.messager.alert("��ʾ","����ѡ����˼�¼","info");
        return false;
    }
    
    var ChargedType=$("#ChargedType").combobox('getValue');
    var ChargedRemark=$("#ChargedRemark").val();    
    var RowID=RowID+"^"+ChargedType+"^"+ChargedRemark;
    var ret=tkMakeServerCall("web.DHCPE.PreAudit","AsCharged",RowID,userId)
    
    var Arr=ret.split("^");
    if (Arr[0]=="-1"){
        $.messager.alert("��ʾ",Arr[1],"info");
        return false;
    }else{
        $.messager.alert("��ʾ","���³ɹ�","success");
        $("#RowID").val("");
        $('#PreAuditListTab').datagrid('load', {
            ClassName:"web.DHCPE.PreAudit",
            QueryName:"SerchPreAudit",
            CRMADM:CRMADM,
            ADMType:ADMType,
            GIADM:GIADM,
        
        });
        
    }
    
}
function BUnAsCharged_click()
{

    var userId=session['LOGON.USERID'];
    var RowID=$("#RowID").val();
    if (RowID=="") {
        $.messager.alert("��ʾ","����ѡ����˼�¼","info");
        return false;
    }
    
    var ret=tkMakeServerCall("web.DHCPE.PreAudit","UnAsCharged",RowID,userId)
    
    var Arr=ret.split("^");
    if (Arr[0]=="-1"){
        $.messager.alert("��ʾ",Arr[1],"info");
        return false;
    }else{
        $.messager.alert("��ʾ","���³ɹ�","success");
        $("#RowID").val("");
            $('#PreAuditListTab').datagrid('load', {
            ClassName:"web.DHCPE.PreAudit",
            QueryName:"SerchPreAudit",
            CRMADM:CRMADM,
            ADMType:ADMType,
            GIADM:GIADM,
        
        });
    }
}
function SetButtonDisabl(RowID,Audit,Charged,AsCharged,AccountAmount)
{
    //alert(Audit+"^"+Charged)
    var userId=session['LOGON.USERID'];
    var LocID=session['LOGON.CTLOCID'];
    //�Żݴ���^ȡ��/��ͬ�շ�^������ģʽ^����ۿ�^���֧��
    var OPflagStr=tkMakeServerCall("web.DHCPE.CT.ChargeLimit","GetOPChargeLimitInfo",userId,LocID);
    var OPflagOne=OPflagStr.split("^");
    var SetASCharged=OPflagOne[4]; //���֧��
    if(SetASCharged=="Y"){
        $("#BAsCharged").linkbutton('enable');
        $("#BUnAsCharged").linkbutton('enable');    
        $("#ChargedType").combobox('enable');       
    }else{
        $("#BAsCharged").linkbutton('disable'); 
        $("#BUnAsCharged").linkbutton('disable');
        $("#ChargedType").combobox('disable');      
    }
    

    $("#BAudit").linkbutton({text:'���'})
    $("#SaleAmount").attr('disabled',true);
    $("#Rebate").attr('disabled',true);
    if (RowID=="")
    {
        $("#BUpdate").linkbutton('disable');
        $("#BAudit").linkbutton('disable');
        $("#BAsCharged").linkbutton('disable');
        $("#BUnAsCharged").linkbutton('disable');
        $("#BSplit").linkbutton('disable');
        return;
    }
    else
    {   
    
        if (Charged=="CHARGED")
        {
            $("#BUpdate").linkbutton('disable');
            $("#BAudit").linkbutton('disable');
            $("#BAsCharged").linkbutton('disable');
            $("#BSplit").linkbutton('disable');
            if((AsCharged=="Y")&&(SetASCharged=="Y")){
                $("#BUnAsCharged").linkbutton('enable');
            }else{
                $("#BUnAsCharged").linkbutton('disable');
            }
            return;
        }
        
        if (Audit=="Audited")
        {
            $("#BAudit").linkbutton({text:'ȡ�����'})
            $("#BSplit").css({"width":"115px"});
            $("#BUpdate").css({"width":"115px"});
            $("#BAudit").css({"width":"115px"});
            $("#BUpdate").linkbutton('disable');
            $("#BAudit").linkbutton('enable');
            $("#BAsCharged").linkbutton('disable');
            $("#BUnAsCharged").linkbutton('disable');
            $("#BSplit").linkbutton('disable');
            return;
        }
        
        $("#BUpdate").css({"width":"88px"});
        $("#BSplit").css({"width":"88px"});
        $("#BAudit").css({"width":"88px"});
        $("#BUpdate").linkbutton('enable');
        $("#BAudit").linkbutton('enable');
        if(SetASCharged=="Y"){
            $("#BAsCharged").linkbutton('enable');
        }
        $("#BSplit").linkbutton('enable');
        $("#BUnAsCharged").linkbutton('disable');
        if(AccountAmount<0){
            $("#BAsCharged").linkbutton('disable');
        }
    
    }
    
    
}

function PrivilegeMode_change()
{
    var PrivilegeMode=$("#privilegeMode").combobox('getValue');
    
    $("#SaleAmount").attr('disabled',true);
    $("#Rebate").attr('disabled',true);
    
    if(PrivilegeMode=="OS")
    {
        $("#SaleAmount").attr('disabled',false);
    }
    else
    {
        $("#SaleAmount").attr('disabled',true);
        $("#SaleAmount").val("")
        
    }
    if (PrivilegeMode=="OR")
    {
        $("#Rebate").attr('disabled',false);
    }
    else
    {
        $("#Rebate").attr('disabled',true);
        $("#Rebate").val("");
    }
    $("#FactAmount").attr('disabled',true);
    if (PrivilegeMode=="TP")
    {
        $("#FactAmount").attr('disabled',false);
    }
    else
    {
        $("#FactAmount").attr('disabled',true);
        $("#FactAmount").val();
    }
}

//��Ŀ��ϸ(����)
function ItemDetail_click(AuditID)
{/*
    var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEFeeList"
            +"&PreAudits="+AuditID;
    websys_lu(lnk,false,'iconCls=icon-w-edit,width=600,height=480,hisui=true,title=��Ŀ��ϸ')
    */
$("#ItemDetailWin").show();
    
    $HUI.window("#ItemDetailWin",{
        title:"��Ŀ��ϸ",
        iconCls:'icon-w-list',
        minimizable:false,
        maximizable:false,
        collapsible:false,
        modal:true,
        width:550,
        height:390
    });
    
    var ConfirmObj = $HUI.datagrid("#ItemDetailGrid",{
        url:$URL,
        fit : true,
        border : false,
        striped : false,
        fitColumns : false,
        autoRowHeight : false,
        rownumbers:true,
        pagination : true, 
        pageSize: 20,
        pageList : [20,100,200],
        queryParams:{
            ClassName:"web.DHCPE.ItemFeeList",
            QueryName:"FindItemFeeList",
            PreAudits:AuditID,
        },
        
        columns:[[
            {field:'ItemName',width:'180',title:'��Ŀ����'},
            {field:'FactAmount',width:'90',title:'���ս��',align:'right'},
            {field:'FeeTypeDesc',width:'50',title:'���'},
            {field:'OrdStatusDesc',width:'60',title:'״̬'},
            {field:'PatName',width:'100',title:'����'}
            
        ]]              
        
        })
}


function SplitItem_click(AuditID)
{
   var link="dhcpesplitaudit.hiui.csp" + '?AuditID=' + AuditID + '&SplitType' +""+ '&GIADM=' +GIADM+'&ADMType='+ADMType+ '&CRMADM='+CRMADM;
    
    $HUI.window("#NewWin", {
        title: "�����Ϣ",
        iconCls: "icon-w-list",
        collapsible: false,
        minimizable: false,
        maximizable: false,
        modal: true,
        width: 1380,
        height: 690,
        content: '<iframe src="' + PEURLAddToken(link) +'" width="100%" height="100%" frameborder="0"></iframe>'
    });
    
}

function InitPreAuditListGrid()
{
    $HUI.datagrid("#PreAuditListTab",{
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
        singleSelect:false,
        checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
        selectOnCheck: true,
        queryParams:{
            ClassName:"web.DHCPE.PreAudit",
            QueryName:"SerchPreAudit",
            CRMADM:CRMADM,
            ADMType:ADMType,
            GIADM:GIADM,
            
        },
        
        columns:[[
            {title:'ѡ��',field: 'Select',width: 60,checkbox:true},
            {field:'TRowId',width:120,title:'��˼�¼ID'},
            {field:'TRebate',width:120,title:'�ۿ���'},
            {field:'TAccountAmount',width:120,title:'Ӧ�ս��',align:'right'},
            {field:'TDiscountedAmount',width:120,title:'�ۺ���',align:'right'},
            {field:'TFactAmount',width:120,title:'���ս��',align:'right'},
            {field:'TAuditedStatus',width:90,title:'���״̬'},
            {field:'TChargedStatus',width:90,title:'�շ�״̬'},
            {field:'TPrivilegeMode',width:100,title:'�Ż���ʽ'},
            {field:'TNoDiscount',width:100,title:'��Ŀ������',align:'center',
                formatter: function (value, rec, rowIndex) {
                    if(value=="Y"){
                        return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
                    }else{
                        return '<input type="checkbox" value="" disabled/>';
                    }
                        
                }
            },
            {field:'TType',width:50,title:'����'},
            {field:'ItemDetail',title:'��Ŀ��ϸ',width:80,align:'center',
                formatter:function(value,rowData,rowIndex){
                    if(rowData.TRowId!=""){
                        return "<span style='cursor:pointer;padding:0 10px 0px 0px' class='icon-paper' title='��Ŀ��ϸ' onclick='ItemDetail_click("+rowData.TRowId+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
                    }
                }},
            {field:'SplitItem',title:'���',width:50,align:'center',
                formatter:function(value,rowData,rowIndex){
                    if(rowData.TRowId!=""){
                        return "<span style='cursor:pointer;padding:0 10px 0px 0px' class='icon-transfer' title='���' onclick='SplitItem_click("+rowData.TRowId+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
                    }
                }},
            {field:'TAsCharged',width:90,title:'���֧��'},
            {field:'TTeamName',width:190,title:'��������'},
            {field:'TRemark',width:100,title:'��ע'},
            
        ]],
        onSelect: function (rowIndex, rowData) {
            
             $("#RowID").val(rowData.TRowId);
             fillData(rowData.TRowId);
             if(rowData.TAccountAmount=="0.00"){
                 $("#privilegeMode").combobox("disable"); 
             }else{
                  $("#privilegeMode").combobox("enable"); 
             }

            
        if((rowData.TRemark.indexOf("������")>-1)||(rowData.TChargedStatus.indexOf("���շ�")>-1)||(rowData.TChargedStatus.indexOf("Ԥ����")>-1)){
                $("#BSplit").linkbutton('disable');
             }else{ 
                $("#BSplit").linkbutton('enable');
            }
                        
        },
        onLoadSuccess: function (rowData) {
            /*
            $("#PreAuditListTab").datagrid('unselectAll'); 
            var objtbl = $("#PreAuditListTab").datagrid('getRows');
            if (rowData) { 
                    //����datagrid����            
                $.each(rowData.rows, function (index) {
                    $(".datagrid-row[datagrid-row-index="+index+"] input[type='checkbox']").attr('disabled','disabled');
                
                });
            }   
            */
    
        },
        
            
    })
}

function fillData(RowID)
{
    if (RowID!="")
    {
        var Data=tkMakeServerCall("web.DHCPE.PreAudit","GetOneInfo",RowID)
        Data=RowID+"^"+Data;
    }
    else
    {
        Data="^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^";
    }
    fill(Data);
}
///���ݱ�ṹ����һ������
function fill(Data)
{
    
    var Data=Data.split("^");
    $("#Rebate").val(Data[5]);
    $("#AccountAmount").val(Data[6]);
    $("#DiscountedAmount").val(Data[7]);
    $("#SaleAmount").val(Data[8]);
    $("#FactAmount").val(Data[9]);
    $("#privilegeMode").combobox("setValue",Data[19]);
    if((Data[8]>0)&&(Data[19]=="OR")) {$("#privilegeMode").combobox("setValue","OS");}
    $("#Type").combobox("setValue",Data[20]);
    $("#ChargedType").combobox("setValue",Data[26]);
    $("#ChargedRemark").val(Data[27]);
    $("#Remark").val(Data[18]);
    
    SetButtonDisabl(Data[0],Data[10],Data[14],Data[28],Data[6]);
}

function InitCombobox()
{
    //�Ż���ʽ
    var privilegeModeObj = $HUI.combobox("#privilegeMode",{
        valueField:'id',
        textField:'text',
        panelHeight:'140',
        data:[
            {id:'NP',text:$g('���Ż�')},
            {id:'OR',text:$g('�ۿ�')},
            {id:'OP',text:$g('��Ŀ�Ż�')},
            {id:'OS',text:$g('���۽��')},
           
        ]

    });
    //֧������
    var ChargedTypeObj = $HUI.combobox("#ChargedType",{
        valueField:'id',
        textField:'text',
        panelHeight:'70',
        data:[
            {id:'1',text:$g('���')},
            {id:'4',text:$g('����')},
           
        ]

    });
    
    //����
    var TypeObj = $HUI.combobox("#Type",{
        valueField:'id',
        textField:'text',
        panelHeight:'70',
        data:[
            {id:'PRE',text:$g('ԤԼ')},
            {id:'ADD',text:$g('����')},
           
        ]

    });
    
    
    
    
}

