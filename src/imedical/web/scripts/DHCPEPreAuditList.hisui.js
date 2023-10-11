
//名称         DHCPEPreAuditList.hisui.js
//功能         费用hisui
//创建日期   2019.11.6
//修改日期   2022.12.24
//创建人     xy

$(function(){
    
    InitCombobox();
    
    InitPreAuditListGrid();
    
    SetButtonDisabl("","","");  
    
    //费用合并
     $("#BMerge").click(function() { 
        BMerge_click(); 
    });

     //更新
    $("#BUpdate").click(function() {    
        BUpdate_click();        
        });  
     
     //审核
    $("#BAudit").click(function() { 
        BAudit_click();         
       });
       
    //定额卡支付 
    $("#BAsCharged").click(function() { 
        BAsCharged_click();     
        });
    
    //拆分
     $("#BSplit").click(function() {    
        BSplit_click();         
       });
    
    //撤销定额卡
     $("#BUnAsCharged").click(function() {  
        BUnAsCharged_click();       
        });  
     
    //优惠形式
    $("#privilegeMode").combobox({
       onSelect:function(){
            PrivilegeMode_change();
    }
    });
    
    
     
    
})



function GetSelectedIds() {


    var ids = ""
    var selectrow = $("#PreAuditListTab").datagrid("getSelections");//获取的是数组，多行数据
    for (var i = 0; i < selectrow.length; i++) {
        if (ids == "") {
            ids = selectrow[i].TRowId
        } else {
            ids = ids + "," + selectrow[i].TRowId
        }

    }


    return ids;
}


//费用合并
function BMerge_click(){

    var PreAuditStr=GetSelectedIds(); //获取待合并的审核记录的串
    if(PreAuditStr.split(",").length<2){
         $.messager.alert("提示", "请选择待合并的费用记录!", "info");
         return false;
    }
    //alert(PreAuditStr)
    var ret=tkMakeServerCall("web.DHCPE.ItemFeeList","MergeAudit",PreAuditStr);
    if(ret=="0"){
         $.messager.popover({msg: '合并费用记录成功！',type:'success',timeout: 1000}); 
    }else{
        $.messager.alert("提示",ret,"info");
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
        $.messager.alert("提示","请输入拆分金额","info");
        return false;
    }

    var FactAmount=$("#FactAmount").val();
    if(+SplitAmt<=0){
            $.messager.alert("提示","拆分金额应大于0","info");
            return false;
    }
    if(+SplitAmt>=+FactAmount){
        $.messager.alert("提示","拆分金额应小于最终金额","info");
        return false;
    }
    
    
    var PreAuditID=$("#RowID").val();
    
    var ret=tkMakeServerCall("web.DHCPE.PreAuditEx","SplitAudit",PreAuditID,ADMType,CRMADM,PreStatus,DepartName+"^"+SplitAmt);
    
    var Arr=ret.split("^");
    if (Arr[0]!="0"){
        $.messager.alert("提示","拆分失败:"+Arr[1],"error");
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

//审核
function BAudit_click()
{
    var Type="CancelAudited";
    if($.trim($("#BAudit").text())=="审核"){  
        Type="Audited";
        }
    
    AuditUpdate(Type,"");
}


//更新
function BUpdate_click()
{
    var PrivilegeMode=$("#privilegeMode").combobox('getValue');
    var selected = $('#PreAuditListTab').datagrid('getSelected');
    
    if(selected.TNoDiscount=="Y"){
        if ((PrivilegeMode=="OR")||(PrivilegeMode=="OS")){
            $.messager.confirm("确认", "确定要对不打折的项目进行打折操作吗？", function(r){
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
            
            $.messager.alert("提示","销售金额不能为空","info");
            return false;
        }
        if (yikoujia<=0) {
            
            $.messager.alert("提示","销售金额应大于0","info");
            return false;
        }
        if((yikoujia.indexOf(".")!="-1")&&(yikoujia.toString().split(".")[1].length>2))
        {
            $.messager.alert("提示","销售金额小数点后不能超过两位","info");
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
            $.messager.alert("提示","折扣率不能为空","info");
            websys_setfocus('FactAmount');
            return;
        }
        if(Rebate>100)
        {
            $.messager.alert("提示","折扣率不能大于100","info");
            return;
        }
        if(Rebate<0)
        {
            $.messager.alert("提示","折扣率不能小于0","info");
            return;
        }

    var userId=session['LOGON.USERID'];
    //var ReturnStr=tkMakeServerCall("web.DHCPE.ChargeLimit","DFLimit",userId)
    //var DFLimit=ReturnStr;

    var LocID=session['LOGON.CTLOCID'];
    ////优惠打折^取消/视同收费^凑整费模式^最大折扣
    var OPflagStr=tkMakeServerCall("web.DHCPE.CT.ChargeLimit","GetOPChargeLimitInfo",userId,LocID);
    var OPflagOne=OPflagStr.split("^");
    var DFLimit=OPflagOne[3]; //最大折扣率(多院区)

    if (DFLimit==0){
        $.messager.alert("提示","没有打折权限","info");
         return;
        }
    if(+DFLimit>+Rebate){
       $.messager.alert("提示","权限不足,您的折扣权限为:"+DFLimit+"%","info");
        return;
        }
    }
    if (PrivilegeMode=="TP")
    {
        if (FactAmount=="")
        {
            $.messager.alert("提示","最终金额不能为空","info");
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
        $.messager.alert("提示","请先选择记录","info");
        return;
        }
    var Flag=tkMakeServerCall("web.DHCPE.PreAudit","UpdatePreAudit",Type,RowID,DataStr)
    if (Flag!=0){
        $.messager.alert("提示","更新失败"+Flag,"error");
        return;
    }else{
        $.messager.alert("提示","更新成功","success");
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
        $.messager.alert("提示","请先选择审核记录","info");
        return false;
    }
    
    var ChargedType=$("#ChargedType").combobox('getValue');
    var ChargedRemark=$("#ChargedRemark").val();    
    var RowID=RowID+"^"+ChargedType+"^"+ChargedRemark;
    var ret=tkMakeServerCall("web.DHCPE.PreAudit","AsCharged",RowID,userId)
    
    var Arr=ret.split("^");
    if (Arr[0]=="-1"){
        $.messager.alert("提示",Arr[1],"info");
        return false;
    }else{
        $.messager.alert("提示","更新成功","success");
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
        $.messager.alert("提示","请先选择审核记录","info");
        return false;
    }
    
    var ret=tkMakeServerCall("web.DHCPE.PreAudit","UnAsCharged",RowID,userId)
    
    var Arr=ret.split("^");
    if (Arr[0]=="-1"){
        $.messager.alert("提示",Arr[1],"info");
        return false;
    }else{
        $.messager.alert("提示","更新成功","success");
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
    //优惠打折^取消/视同收费^凑整费模式^最大折扣^定额卡支付
    var OPflagStr=tkMakeServerCall("web.DHCPE.CT.ChargeLimit","GetOPChargeLimitInfo",userId,LocID);
    var OPflagOne=OPflagStr.split("^");
    var SetASCharged=OPflagOne[4]; //定额卡支付
    if(SetASCharged=="Y"){
        $("#BAsCharged").linkbutton('enable');
        $("#BUnAsCharged").linkbutton('enable');    
        $("#ChargedType").combobox('enable');       
    }else{
        $("#BAsCharged").linkbutton('disable'); 
        $("#BUnAsCharged").linkbutton('disable');
        $("#ChargedType").combobox('disable');      
    }
    

    $("#BAudit").linkbutton({text:'审核'})
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
            $("#BAudit").linkbutton({text:'取消审核'})
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

//项目明细(弹窗)
function ItemDetail_click(AuditID)
{/*
    var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEFeeList"
            +"&PreAudits="+AuditID;
    websys_lu(lnk,false,'iconCls=icon-w-edit,width=600,height=480,hisui=true,title=项目明细')
    */
$("#ItemDetailWin").show();
    
    $HUI.window("#ItemDetailWin",{
        title:"项目明细",
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
            {field:'ItemName',width:'180',title:'项目名称'},
            {field:'FactAmount',width:'90',title:'最终金额',align:'right'},
            {field:'FeeTypeDesc',width:'50',title:'类别'},
            {field:'OrdStatusDesc',width:'60',title:'状态'},
            {field:'PatName',width:'100',title:'姓名'}
            
        ]]              
        
        })
}


function SplitItem_click(AuditID)
{
   var link="dhcpesplitaudit.hiui.csp" + '?AuditID=' + AuditID + '&SplitType' +""+ '&GIADM=' +GIADM+'&ADMType='+ADMType+ '&CRMADM='+CRMADM;
    
    $HUI.window("#NewWin", {
        title: "拆分信息",
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
        checkOnSelect: true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
        selectOnCheck: true,
        queryParams:{
            ClassName:"web.DHCPE.PreAudit",
            QueryName:"SerchPreAudit",
            CRMADM:CRMADM,
            ADMType:ADMType,
            GIADM:GIADM,
            
        },
        
        columns:[[
            {title:'选择',field: 'Select',width: 60,checkbox:true},
            {field:'TRowId',width:120,title:'审核记录ID'},
            {field:'TRebate',width:120,title:'折扣率'},
            {field:'TAccountAmount',width:120,title:'应收金额',align:'right'},
            {field:'TDiscountedAmount',width:120,title:'折后金额',align:'right'},
            {field:'TFactAmount',width:120,title:'最终金额',align:'right'},
            {field:'TAuditedStatus',width:90,title:'审核状态'},
            {field:'TChargedStatus',width:90,title:'收费状态'},
            {field:'TPrivilegeMode',width:100,title:'优惠形式'},
            {field:'TNoDiscount',width:100,title:'项目不打折',align:'center',
                formatter: function (value, rec, rowIndex) {
                    if(value=="Y"){
                        return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
                    }else{
                        return '<input type="checkbox" value="" disabled/>';
                    }
                        
                }
            },
            {field:'TType',width:50,title:'类型'},
            {field:'ItemDetail',title:'项目明细',width:80,align:'center',
                formatter:function(value,rowData,rowIndex){
                    if(rowData.TRowId!=""){
                        return "<span style='cursor:pointer;padding:0 10px 0px 0px' class='icon-paper' title='项目明细' onclick='ItemDetail_click("+rowData.TRowId+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
                    }
                }},
            {field:'SplitItem',title:'拆分',width:50,align:'center',
                formatter:function(value,rowData,rowIndex){
                    if(rowData.TRowId!=""){
                        return "<span style='cursor:pointer;padding:0 10px 0px 0px' class='icon-transfer' title='拆分' onclick='SplitItem_click("+rowData.TRowId+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
                    }
                }},
            {field:'TAsCharged',width:90,title:'定额卡支付'},
            {field:'TTeamName',width:190,title:'分组名称'},
            {field:'TRemark',width:100,title:'备注'},
            
        ]],
        onSelect: function (rowIndex, rowData) {
            
             $("#RowID").val(rowData.TRowId);
             fillData(rowData.TRowId);
             if(rowData.TAccountAmount=="0.00"){
                 $("#privilegeMode").combobox("disable"); 
             }else{
                  $("#privilegeMode").combobox("enable"); 
             }

            
        if((rowData.TRemark.indexOf("定额拆分")>-1)||(rowData.TChargedStatus.indexOf("已收费")>-1)||(rowData.TChargedStatus.indexOf("预结算")>-1)){
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
                    //遍历datagrid的行            
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
///根据表结构生成一个数组
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
    //优惠形式
    var privilegeModeObj = $HUI.combobox("#privilegeMode",{
        valueField:'id',
        textField:'text',
        panelHeight:'140',
        data:[
            {id:'NP',text:$g('无优惠')},
            {id:'OR',text:$g('折扣')},
            {id:'OP',text:$g('项目优惠')},
            {id:'OS',text:$g('销售金额')},
           
        ]

    });
    //支付类型
    var ChargedTypeObj = $HUI.combobox("#ChargedType",{
        valueField:'id',
        textField:'text',
        panelHeight:'70',
        data:[
            {id:'1',text:$g('定额卡')},
            {id:'4',text:$g('其他')},
           
        ]

    });
    
    //类型
    var TypeObj = $HUI.combobox("#Type",{
        valueField:'id',
        textField:'text',
        panelHeight:'70',
        data:[
            {id:'PRE',text:$g('预约')},
            {id:'ADD',text:$g('加项')},
           
        ]

    });
    
    
    
    
}

