var CAEquipDR=getElementValue("CAEquipDR")
var ReadOnly=getElementValue("ReadOnly")
var Hasflag=getElementValue("Hasflag")
var Columns=getCurColumnsInfo('EM.G.ChangeAccount','','','')
var editFlag="undefined";
$(function(){
    initDocument();
    $(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
    var obj=document.getElementById("Banner");
    if (obj){$("#Banner").attr("src",'dhceq.plat.banner.csp?&EquipDR='+CAEquipDR)}
    initUserInfo();
    initMessage(""); //获取所有业务消息
    initLookUp();
    defindTitleStyle(); 
    setRequiredElements("CAChangeFee^CAChangeReason^CAChangeDate^CAChangedOriginalFee^CATotalDepreFee^CAChangedNetFee"); //必填项
    initButton();
    initEvent();
    initButtonWidth();
    /*
    if (Hasflag=="")
    {
        $("#ChangeAccountList").hide()
        var width=$("#Banner").width()
        //$("#ChangeAccountEdit").css("width",width)
        $("#ChangeAccountEdit").css("margin-right","1350px")
    }
    else
    {
        initDateGrid();
    }
    */
    initDateGrid();
    
    initFundDateGrid()
    initCAAffixDescS()
    
    setEnabled();
    
    setElement("CAChangeDate",GetCurrentDate()); 
    //是否显示维修单据
    var CheckFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","401008");
    if(CheckFlag=="0")
    {
        hiddenObj("cCAHold4_Desc",1);
        hiddenObj("CAHold4_Desc",1);
    }
}

function initEvent()
{
    $('input#CAChangeFee').on('keyup',function(){
        ChangeFee_Changed();
    })
    $('input#CAHold2').on('keyup',function(){
        ChangeDepreTotalFee_Changed();
    })
    /*
    if (jQuery("#BCAPrint").length>0)
    {
        jQuery("#BCAPrint").linkbutton({iconCls: 'icon-w-print'});
        jQuery("#BCAPrint").on("click", BCAPrint_Clicked);
        jQuery("#BCAPrint").linkbutton({text:'调帐单打印'});
    }
    if (jQuery("#BAffixISPrint").length>0)
    {
        jQuery("#BAffixISPrint").linkbutton({iconCls: 'icon-w-print'});
        jQuery("#BAffixISPrint").on("click", BAffixISPrint_Click);
        jQuery("#BAffixISPrint").linkbutton({text:'附件入库单'});
    }
    if (jQuery("#BAffixSMPrint").length>0)
    {
        jQuery("#BAffixSMPrint").linkbutton({iconCls: 'icon-w-print'});
        jQuery("#BAffixSMPrint").on("click", BAffixSMPrint_Click);
        jQuery("#BAffixSMPrint").linkbutton({text:'附件出库单'});
    }
    */
    if (jQuery("#BAppendFile").length>0)    //#BPicture
    {
        jQuery("#BAppendFile").linkbutton({iconCls: 'icon-w-paper'});
        jQuery("#BAppendFile").on("click", BAppendFile_Clicked);
        jQuery("#BAppendFile").linkbutton({text:'电子资料'});
    }
}

function ChangeFee_Changed()
{
    var CAChangeFee=getElementValue("CAChangeFee");
    if (CAChangeFee=="")
    {
        alertShow("调整价值不能为空!");
        return
    }
    // MZY0154	3248638		2023-03-03
    if (isNaN(CAChangeFee)&&(getElementValue("CAChangeFee")!="-"))
    {
        alertShow("调整价值不符合要求!");
        return
    }
    if (CAChangeFee>0)
    {
        setElement("CAAddFlag",1); 
    }
    else if (CAChangeFee<0)
    {
        setElement("CAAddFlag",0); 
    }
    else 
    {
        
    }
    var EQOriginalFee=getElementValue("EQOriginalFee");
    if (EQOriginalFee=="")
    {
        alertShow("调前原值不能为空");
        return
    }
    else
    {
        setElement("CAOriginalFee",EQOriginalFee); 
    }
    var EQNetFee=getElementValue("EQNetFee");
    if (EQNetFee=="")
    {
        alertShow("调前净值不能为空");
        return
    }
    else
    {
        setElement("CANetFee",EQNetFee); 
    }
    var EQDepreTotalFee=getElementValue("EQDepreTotalFee");
    if (EQDepreTotalFee=="")
    {
        alertShow("调前累积折旧不能为空");
        return
    }
    else
    {
        setElement("CAPreTotalDepreFee",EQDepreTotalFee); 
    }
    
    var tmpCAChangedOriginalFee=parseFloat(EQOriginalFee)+parseFloat(CAChangeFee)
    if (tmpCAChangedOriginalFee<0)
    {
        alertShow("变动后原值异常,调整为0.");
        tmpCAChangedOriginalFee=0;
    }
    setElement("CAChangedOriginalFee",tmpCAChangedOriginalFee.toFixed(2)); 
    
    var tmpCAChangedNetFee=parseFloat(EQNetFee)+parseFloat(CAChangeFee);
    if (tmpCAChangedNetFee<0)
    {
        alertShow("变动后净值异常,调整为0.");
        tmpCAChangedNetFee=0;
    }
    
    var RemainFeeRate=getElementValue("RemainFeeRate");
    if (RemainFeeRate>0)
    {
        var CAChangedNetRemainFee=(tmpCAChangedOriginalFee*RemainFeeRate/100).toFixed(2)
        if (tmpCAChangedNetFee<CAChangedNetRemainFee)
        {
            alertShow("调后净值不能小于净残值.");
            return
        }
        else
        {
            setElement("CAChangedNetRemainFee",CAChangedNetRemainFee); 
        }
    }
    
    setElement("CAChangedNetFee",tmpCAChangedNetFee.toFixed(2)); 
    
    var tmpDepreTotalValue=tmpCAChangedOriginalFee-tmpCAChangedNetFee;
    if (tmpDepreTotalValue<0)
    {
        alertShow("变动后累计折旧异常,调整为0.");
        tmpDepreTotalValue=0;
    }
    setElement("CATotalDepreFee",tmpDepreTotalValue.toFixed(2)); 
}

function ChangeDepreTotalFee_Changed()
{
    var CAHold2=getElementValue("CAHold2");
    if (CAHold2=="")
    {
        alertShow("调整累计折旧不能为空!");
        return
    }
    if (isNaN(CAHold2))
    {
        alertShow("调整累计折旧不符合要求!");
        return
    }
    
    var CAPreTotalDepreFee=getElementValue("CAPreTotalDepreFee");
    if (CAPreTotalDepreFee=="")
    {
        alertShow("调前累计折旧不能为空");
        return
    }
    var CAChangedOriginalFee=getElementValue("CAChangedOriginalFee");
    if (CAChangedOriginalFee=="")
    {
        alertShow("调后原值不能为空");
        return
    }
    // 变动前累计折旧=变动前原值-变动前净值
    // 变动后累计折旧=变动前累计折旧+变动的累计折旧
    var tmpTotalDepreFeeValue=parseFloat(CAPreTotalDepreFee)+parseFloat(CAHold2);
    if (tmpTotalDepreFeeValue<0)
    {
        alertShow("变动后累计折旧值异常,调整为0.");
        tmpTotalDepreFeeValue=0;
    }
    setElement("CATotalDepreFee",tmpTotalDepreFeeValue.toFixed(2)); 
    
    // 变动后净值=变动后原值-变动后累计折旧
    var tmpChangedNetFeeValue=parseFloat(CAChangedOriginalFee)-tmpTotalDepreFeeValue;
    if (tmpChangedNetFeeValue<0)
    {
        alertShow("变动后净值异常,调整为0.");
        tmpChangedNetFeeValue=0;
    }
    
    var RemainFeeRate=getElementValue("RemainFeeRate");
    if (RemainFeeRate>0)
    {
        var CAChangedNetRemainFee=(CAChangedOriginalFee*RemainFeeRate/100).toFixed(2)
        if (tmpChangedNetFeeValue<CAChangedNetRemainFee)
        {
            alertShow("调后净值不能小于净残值.");
            return
        }
        else
        {
            setElement("CAChangedNetRemainFee",CAChangedNetRemainFee); 
        }
    }
    setElement("CAChangedNetFee",tmpChangedNetFeeValue.toFixed(2)); 
}
function initDateGrid()
{
    $HUI.datagrid("#tDHCEQChangeAccount",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCEQ.EM.BUSChangeAccount",
            QueryName:"GetChangeAccount",
            EquipDR:CAEquipDR
        },
        singleSelect:true,
        fit:true,
        border:false,
        rownumbers: true,  //如果为true，则显示一个行号列。
        columns:Columns,
        onClickRow:function(rowIndex,rowData){onClickRow(rowIndex,rowData);}
    });
}

//元素参数重新获取值
function getParam(ID)
{
    if (ID=="vEQRowID"){return getElementValue("CAEquipDR")}
}

function setSelectValue(elementID,rowData)
{
    if(elementID=="CAHold4_Desc") 
    {
        setElement("CAHold4_Desc",rowData.TRequestNo)
        setElement("CAHold4",rowData.TRowID)
    }
}

function setEnabled()
{
    var CARowID=getElementValue("CARowID");
    var CAStatus=getElementValue("CAStatus");
    if (CARowID=="")
    {
        disableElement("BSave",false);
        disableElement("BCancel",true);
        disableElement("BDelete",true);
        disableElement("BAudit",true);
        disableElement("BClear",true);
        
        disableElement("BPicture",true);
        disableElement("BAppendFile",true);
        
        $('#menubtn-prt').menubutton('disable');
        $('#menubtn-prt').attr("disabled",true).css({ "backgroundColor": "#bbbbbb" });
        hiddenObj("BAffixISPrint",1);
        hiddenObj("BAffixSMPrint",1);
        //disableElement("BCAPrint",true);
        //disableElement("BAffixISPrint",true);
        //disableElement("BAffixSMPrint",true);
    }
    else
    {
        if (CAStatus==0)
        {
            disableElement("BCancel",false);
            disableElement("BDelete",false);
            disableElement("BAudit",false);
            disableElement("BSave",false);
            
            disableElement("BPicture",false);
            disableElement("BAppendFile",false);
            
            $('#menubtn-prt').menubutton('disable');
            $('#menubtn-prt').attr("disabled",true).css({ "backgroundColor": "#bbbbbb" });
            var CAAffixCount=getElementValue("CAAffixCount");
            if (CAAffixCount==0)
            {
                hiddenObj("BAffixISPrint",1);
                hiddenObj("BAffixSMPrint",1);
            }
            //disableElement("BCAPrint",true);
            //disableElement("BAffixISPrint",true);
            //disableElement("BAffixSMPrint",true);
        }
        else if (CAStatus==2)
        {
            disableElement("BSave",true);
            disableElement("BDelete",true);
            disableElement("BAudit",true);
            
            disableElement("BPicture",true);
            disableElement("BAppendFile",true);
            disableElement("BAppendFile",true);
            
            //var obj=$('#menubtn-prt')
            $('#menubtn-prt').menubutton('enable');
            $('#menubtn-prt').attr("disabled",false).css({ "backgroundColor": "#40A2DE" });
            var CAAffixCount=getElementValue("CAAffixCount");
            if (CAAffixCount==0)
            {
                hiddenObj("BAffixISPrint",1);
                hiddenObj("BAffixSMPrint",1);
            }
            //disableElement("BCAPrint",false);
            //disableElement("BAffixISPrint",false);
            //disableElement("BAffixSMPrint",false);
        }
    }
    
    var ReadOnly=getElementValue("ReadOnly");
    if (ReadOnly==1)
    {
        disableElement("BSave",true);
        disableElement("BDelete",true);
        disableElement("BAudit",true);
        disableElement("BCAPrint",true);
        
        disableElement("BPicture",true);
        disableElement("BAppendFile",true);
        disableElement("BAffixISPrint",true);
        disableElement("BAffixSMPrint",true);
    }
}
function onClickRow(rowIndex,rowData)
{
    var SelectedRow=rowData.TRowID
    var CARowID=getElementValue("CARowID");
    if (SelectedRow==CARowID)
    {
        setElement("CAAddFlag",0); 
        setElement("CARowID",""); 
        //setElement("CAEquipDR","");          		// MZY0154	3248600		2023-03-03
        setElement("CAChangeFee",""); 
        setElement("CAChangedOriginalFee",""); 
		setElement("CAPreTotalDepreFee",""); 		// MZY0154	3248420		2023-03-03  调前累计折旧
        setElement("CAChangedNetFee",""); 
        setElement("CATotalDepreFee",""); 
        setElement("CAChangeItem",""); 
        setElement("CAChangeReasonDR",""); 
        setElement("CAChangeReason",""); 
        setElement("CAChangeDate",GetCurrentDate()); 
        setElement("CARemark",""); 
        setElement("CAStatus",""); 
        setElement("CAAddUserDR",""); 
        setElement("CAAddDate",""); 
        setElement("CAAddTime",""); 
        setElement("CAUpdateUserDR",""); 
        setElement("CAUpdateDate",""); 
        setElement("CAUpdateTime",""); 
        setElement("CASubmitUserDR",""); 
        setElement("CASubmitDate",""); 
        setElement("CASubmitTime",""); 
        setElement("CAAuditUserDR",""); 
        setElement("CAAuditDate",""); 
        setElement("CAAuditTime",""); 
        setElement("CAOriginalFee",""); 
        setElement("CANetFee",""); 
        setElement("CANetRemainFee","");
        setElement("CAChangedNetRemainFee",""); 
        setElement("CAStoreLocDR",""); 
        setElement("CAUseLocDR",""); 
        setElement("CAEquipTypeDR",""); 
        setElement("CAStatCatDR",""); 
        setElement("CAHold1",""); 
        setElement("CAHold2",""); 
        setElement("CAHold3",""); 
        setElement("CAHold4",""); 
        setElement("CAHold4_Desc",""); 
        setElement("CAHold5",""); 
        
        setElement("EQUseLocDR",getElementValue("EQUseLocDR")); 
        setElement("EQOriginalFee",getElementValue("EQOriginalFee")); 
        setElement("EQNetFee",getElementValue("EQNetFee")); 
        setElement("EQNetRemainFee",getElementValue("EQNetRemainFee")); 
        setElement("EQEquipTypeDR",getElementValue("EQEquipTypeDR")); 
        setElement("EQStoreLocDR",getElementValue("EQStoreLocDR")); 
        setElement("EQStatCatDR",getElementValue("EQStatCatDR"));
		$("#tDHCEQChangeAccount").datagrid("unselectRow", rowIndex);	// MZY0153	3248037,3248059		2023-02-20
    }
    else
    {
        jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSChangeAccount","GetOneChangeAccount",SelectedRow)
        jsonData=jQuery.parseJSON(jsonData);
        if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
        setElementByJson(jsonData.Data);
    }
    initFundDateGrid()
    initCAAffixDescS()
    var CAAffixIDS=getElementValue("CAAffixIDS");
    if (CAAffixIDS!="")
    {
        var arr=CAAffixIDS.split(",");
        $('#CAAffixDescS').combogrid('setValues', arr);
    }
    
    setEnabled()
}

function initFundDateGrid()
{
    var SourceID=getElementValue("CARowID");
    var CAChangeFee=getElementValue("CAChangeFee");
    var CAHold2=getElementValue("CAHold2"); //changeDepreTotalFee
    var TmpSourceID=getElementValue("TmpSourceID")
    if (SourceID=="") SourceID=TmpSourceID
    var FundsColumns=getCurColumnsInfo('EM.G.Funds.GetFunds','','','')
    $HUI.datagrid("#tDHCEQFunds",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCEQ.EM.BUSFunds",
            QueryName:"GetFunds",
            FromType:7,
            FromID:SourceID,
            FundsAmount:CAChangeFee,
            DataChangeFlag:"",        //czf 2020-10-29
        },
        fit:true,
        rownumbers: true,  //如果为true，则显示一个行号列。
        singleSelect:true,
        fitColumns:true,   //add by lmm 2020-06-02
        columns:FundsColumns,
        toolbar:[{
            iconCls:'icon-add',
            text:'新增',
            id:'add',
            handler:function(){insertRow();}
        },
        {
            iconCls:'icon-no',
            text:'删除',
            id:'delete',
            handler:function(){DeleteData();}
        }],
        singleSelect:true,
        loadMsg: '正在加载信息...',
        //Modify by zx 20200302 BUG ZX0079
        onClickRow: function (rowIndex, rowData) {//双击选择行编辑
            //Modify by zx 20200302 BUG ZX0079
            //if (rowIndex==0) return; //第一行不做编辑
            if (rowData.TFundsTypeDR==getElementValue("SelfFundsID"))
            {
                messageShow('alert','error','错误提示','默认资金来源,不可编辑.');
                return;
            }
            if (editFlag!="undefined")
            {
                $('#tDHCEQFunds').datagrid('endEdit', editFlag);
                editFlag="undefined"
            }
            else
            {
                $('#tDHCEQFunds').datagrid('beginEdit', rowIndex);
                editFlag =rowIndex;
                bindGridEvent();  //编辑行监听响应
            }
        },
        onSelect:function(index,row){
            //modified by ZY0286 处理选择行的问题
            if (editFlag!="undefined")
            {
            $('#tDHCEQFunds').datagrid('endEdit', editFlag);
            editFlag="undefined"
            }
            selectRow = index;
        },
        onLoadSuccess:function(){
            //Modify by zx 2020-03-09 Bug ZX0079 核算项目不可用
            if(getElementValue("FinaceItemUseFlag")=="0")
            {
                $('#tDHCEQFunds').datagrid('hideColumn', 'TFinaceItem');
                $('#tDHCEQFunds').datagrid('hideColumn', 'TFunctionCat');
            }
            //Modify by zx 2020-03-09 Bug ZX0079 是否单项资金来源
            if(getElementValue("FundsSingleFlag")=="0")
            {
                $('div.datagrid-toolbar').eq(0).hide();
            }
        }
    });
}

function initCAAffixDescS()
{
    var CAEquipDR=getElementValue("CAEquipDR")
    var CARowID=getElementValue("CARowID")
    var CAAffixIDS=getElementValue("CAAffixIDS")
    $HUI.combogrid('#CAAffixDescS',{   
        url:$URL, 
        queryParams:{
            ClassName:"web.DHCEQ.EM.BUSChangeAccount",
            QueryName:"ChangeAccountAffix",
            EquipDR:CAEquipDR,
            ChangeAccountDR:CARowID,
            CAAffixIDS:CAAffixIDS
        },
        idField:'TRowID',
        textField:'TName',
        multiple: true,
        rowStyle:'checkbox', //显示成勾选行形式
        selectOnNavigation:false,
        fitColumns:true,
        fit:true,
        border:'true',
        columns:[[
            {field:'check',checkbox:true},
            {field:'TRowID',title:'全选'},
            {field:'TName',title:'名称'},
            {field:'TProvider',title:'供应商'},
            {field:'TOtherInfo',title:'其他信息'}
        ]]
    });
}
function BSave_Clicked()
{
    if (checkMustItemNull("")) return
    var CAChangedOriginalFee=getElementValue("CAChangedOriginalFee");
    if (CAChangedOriginalFee<0)
    {
        alertShow("调账后原值小于0,请正确输入调账价值!")
        return
    }
    var CAChangedNetFee=getElementValue("CAChangedNetFee");
    if (CAChangedNetFee<0)
    {
        alertShow("调账后净值小于0,请正确输入调账价值!")
        return
    }
    
    var RemainFeeRate=getElementValue("RemainFeeRate");
    if (RemainFeeRate>0)
    {
        var CAChangedNetRemainFee=(CAChangedOriginalFee*RemainFeeRate/100).toFixed(2)
        if (CAChangedNetFee<CAChangedNetRemainFee)
        {
            alertShow("调后净值不能小于净残值.");
            return
        }
        else
        {
            setElement("CAChangedNetRemainFee",CAChangedNetRemainFee); 
        }
    }
    
    setElement("CAUseLocDR",getElementValue("EQUseLocDR")); 
    setElement("CAOriginalFee",getElementValue("EQOriginalFee")); 
    setElement("CANetFee",getElementValue("EQNetFee")); 
    setElement("CANetRemainFee",getElementValue("EQNetRemainFee")); 
    setElement("CAEquipTypeDR",getElementValue("EQEquipTypeDR")); 
    setElement("CAStoreLocDR",getElementValue("EQStoreLocDR")); 
    setElement("CAStatCatDR",getElementValue("EQStatCatDR"));
    
    setElement("CAAffixIDS",$("#CAAffixDescS").combogrid("getValues"));
    var CAChangeFee=getElementValue("CAChangeFee");
    var CAAddFlag=getElementValue("CAAddFlag");
    var CAAffixIDS=getElementValue("CAAffixIDS");
    var AddChangeDR=getElementValue("AddChangeDR");
    if (CAAddFlag==true)
    {
        if (CAChangeFee<0)
        {
            alertShow("增值调账时调账金额应大于0!")
            return
        }
    }
    else
    {
        if (CAChangeFee>0)
        {
            alertShow("减值调账时调账金额应为负数!")
            return
        }
    }
    //检测金额是否正确?及一致
    var Amount=0;
    var rows = $('#tDHCEQFunds').datagrid('getRows');
    var RowCount=rows.length;
    var val=""
    for (var i=0;i<RowCount;i++)
    {
        $('#tDHCEQFunds').datagrid('endEdit',i);
        var CurFee=rows[i].TFee;
        var Desc=rows[i].TFundsType;
        Amount=Amount+CurFee*1
        var CurFundsFee=rows[i].TCurFundsFee;
        var CurDepreTotalFee=rows[i].TCurDepreTotalFee;
        if ((isNaN(CurFundsFee))||(CurFundsFee<0))
        {
            messageShow('alert','error','提示','第'+(i+1)+'行变动后资金来源金额不能小于0!');
            return
        }
        if ((isNaN(CurDepreTotalFee))||(CurDepreTotalFee<0))
        {
            messageShow('alert','error','提示','第'+(i+1)+'变动后累计折旧不能小于0!');
            return
        }
        if ((CurDepreTotalFee*1)>(CurFundsFee*1))
        {
            messageShow('alert','error','提示','第'+(i+1)+'变动后累计折旧不能大于变动后资金来源!');
            return
        }
        //Modify by zx 2020-03-03 Bug ZX0079 资金来源,核算项目,功能分类唯一性判断
        var CurFinaceItemDR=rows[i].TFinaceItemDR;
        if (CurFinaceItemDR=="") CurFinaceItemDR=getElementValue("SelfFinaceItemID");
        var CurFunctionCatDR=rows[i].TFunctionCatDR;
        if (CurFunctionCatDR=="") CurFunctionCatDR=getElementValue("SelfFunctionCatID");
        var rows = $('#tDHCEQFunds').datagrid('getRows');
        for(var j=0;j<rows.length;j++){
            if((i!=j)&&(rows[i].TFundsTypeDR==rows[j].TFundsTypeDR)&&(CurFinaceItemDR==rows[j].TFinaceItemDR)&&(CurFunctionCatDR==rows[j].TFunctionCatDR))
            {
                messageShow('alert','error','提示','第'+(i+1)+'行与明细中第'+(j+1)+'行重复!');
                return;
            }
        }
        var val=val+rows[i].TRowID;
        val=val+"^"+rows[i].TFundsTypeDR;
        val=val+"^"+rows[i].TFee;
        val=val+"^"+rows[i].TOldRowDR;
        val=val+"^"+rows[i].THold1;
        val=val+"^"+rows[i].TPreDepreTotalFee;
        val=val+"^"+rows[i].TFinaceItemDR;
        val=val+"^"+rows[i].TFunctionCatDR;
        val=val+"^"+rows[i].TNo;
        val=val+"^"+"";  //课题待处理
        val=val+"^"+rows[i].TDepreTotal;
        val=val+"^"+rows[i].TPreFundsFee;
        val=val+"||"
    }
    var CARowID=getElementValue("CARowID");
    if (CARowID!="")
    {
        var CAChangeFee=getElementValue("CAChangeFee");
        Amount=Amount.toFixed(2);
        if (Number(Amount)!=Number(CAChangeFee))
        {
            alertShow("各项资金来源合计不等于总金额!");
            return;
        }    
    }
    
    var data=getInputList();
    data=JSON.stringify(data);
    var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSChangeAccount","SaveData",data,"0",val);
    jsonData=JSON.parse(jsonData)
    if (jsonData.SQLCODE==0)
    {
        var ReadOnly=getElementValue("ReadOnly");
        var val="&RowID="+CAEquipDR+"&WaitAD="+ReadOnly+"&ReadOnly="
        url="dhceq.em.changeaccount.csp?"+val
        if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
        window.location.href= url;
    }
    else
    {
        alertShow("错误信息:"+jsonData.Data);
        //messageShow('popover','error','错误',"错误信息:"+jsonData.Data);
        return
    }
}

function BDelete_Clicked()
{
    var CARowID=getElementValue("CARowID");
    if (CARowID=="")
    {
        alertShow("请选择要操作的记录!")
        return
    }
    messageShow("confirm","info","提示","是否确定删除当前调账单?","",function(){
                var CARowID=getElementValue("CARowID");
                var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSChangeAccount","SaveData",CARowID,"1");
                jsonData=JSON.parse(jsonData)
                if (jsonData.SQLCODE==0)
                {
                    var ReadOnly=getElementValue("ReadOnly");
                    var val="&RowID="+CAEquipDR+"&WaitAD="+ReadOnly+"&ReadOnly="
                    url="dhceq.em.changeaccount.csp?"+val
                    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
						url += "&MWToken="+websys_getMWToken()
					}
                    window.location.href= url;
                }
                else
                {
                    alertShow("错误信息:"+jsonData.Data);
                    //messageShow('popover','error','错误',"错误信息:"+jsonData.Data);
                    return
                }
        },"");
}
function BAudit_Clicked()
{
    var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSAccountPeriod","IsCurPeriod");
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE==0)
    {
        messageShow("confirm","info","提示","当前操作会内容会统计入会计周期:"+RtnObj.Data+"中<br>请确定是否要继续执行操作?","",AuditData,function(){return},"确定","取消");
    }
    else
    {
        AuditData();
    }
}

function AuditData()
{
    var CARowID=getElementValue("CARowID");
    if (CARowID=="")
    {
        alertShow("请选择要操作的记录!")
        return
    }
    //检测自有资金参数是否设置
    if (getElementValue("SelfFundsID")=="")
    {
        alertShow("自有资金参数未设置!");
        return;
    }
    var CAChangedOriginalFee=getElementValue("CAChangedOriginalFee");
    if (CAChangedOriginalFee<0)
    {
        alertShow("调账后原值小于0,请正确输入调账价值!")
        return
    }
    //判断调账金额是否与关联附件总金额相等 2010-03-15 党军 DJ0041 Begin
    var CAChangeFee=getElementValue("CAChangeFee");
    var CAAffixCount=getElementValue("CAAffixCount");
    var CAAffixFee=getElementValue("CAAffixFee");
    //有附件
    if (CAAffixCount>0)
    {
        if (CAChangeFee==0)
        {
            alertShow("调账金额为0,不能关联附件!");
            return;
        }
        else
        {
			// MZY0154	3248420		2023-03-03
            if (CAChangeFee!=parseFloat(CAAffixFee))
            {
                alertShow("调账金额与关联附件总金额不相等,不能审核!");
                return;   
            }
            else
            {
                GetAudit(CARowID);
            }
        }
    }
    else//无附件
    {
        if (CAChangeFee!=0)
        {
            messageShow("confirm","info","提示","本次调账未关联附件,是否继续?","",function(){
                GetAudit(CARowID);
            },function(){
                return;
            });
        }
        else
        {
            GetAudit(CARowID);
        }
    }
}

function GetAudit(CARowID)
{
    var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSChangeAccount","AuditData",CARowID);
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE==0)
    {
        websys_showModal("options").mth();  //modify by lmm 2019-02-20
        var ReadOnly=getElementValue("ReadOnly");
        var val="&RowID="+CAEquipDR+"&WaitAD="+ReadOnly+"&ReadOnly="
        url="dhceq.em.changeaccount.csp?"+val
        if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
        window.location.href= url;
    }
    else
    {
        alertShow("错误信息:"+jsonData.Data);
        return
    }
}


// 插入新行
function insertRow()
{
    if(editFlag>="0"){
        $("#tDHCEQFunds").datagrid('endEdit', editFlag);//结束编辑,传入之前编辑的行
    }
    var rows = $("#tDHCEQFunds").datagrid('getRows');
    var lastIndex=rows.length-1
    var newIndex=rows.length
    var useLocID = "";
    var quantity = "";
    var fundsTypeDR="";
    if(rows.length>0) 
    {
        fundsTypeDR = (typeof rows[lastIndex].TFundsTypeDR == 'undefined') ? "" : rows[lastIndex].TFundsTypeDR;
    }

    if ((fundsTypeDR=="")&&(rows.length>0))
    {
        messageShow('alert','error','错误提示','第'+newIndex+'行资金来源为空!请先填写数据.');
    }
    else
    {
        //Modify by zx 20200302 BUG ZX0079 默认值处理,避免未定义
        $("#tDHCEQFunds").datagrid('insertRow', {index:newIndex,row:{"TFee":"0.00","TDepreTotal":"0.00","TPreFundsFee":"0.00","TCurFundsFee":"0.00","TPreDepreTotalFee":"0.00","TCurDepreTotalFee":"0.00",
            "TRowID":"","TOldRowDR":"","THold1":"","TFinaceItemDR":"","TFunctionCatDR":"","TNo":""}});
        editFlag=0;
    }
}

function DeleteData()
{
    var rows = $('#tDHCEQFunds').datagrid('getSelections'); //选中要删除的行
    if(rows.length<=0){
        jQuery.messager.alert("提示","无要删除的项");
        return;
    }
    if(selectRow=="undefined")
    {
        jQuery.messager.alert('提示','请选择要删除的项','warning');
        return;
    }
    //提示是否删除
    jQuery.messager.confirm("提示", "您确定要删除这行数据吗？", function (res) {
        if (res)
        {
            $('#tDHCEQFunds').datagrid('deleteRow', selectRow);
            selectRow = "undefined";
        }
    });
}
function getFinaceItem(index,data)
{
    var rowData = $('#tDHCEQFunds').datagrid('getSelected');
    rowData.TFinaceItemDR=data.TRowID;
    var finaceItemEdt = $('#tDHCEQFunds').datagrid('getEditor', {index:editFlag,field:'TFinaceItem'});
    $(finaceItemEdt.target).combogrid("setValue",data.TName);
    $('#tDHCEQFunds').datagrid('endEdit',editFlag);
    $('#tDHCEQFunds').datagrid('beginEdit',editFlag);
}
///modified by ZY0213
function clearFinaceItem()
{
    var rowData = $('#tDHCEQFunds').datagrid('getSelected');
    rowData.TFinaceItemDR="";;
    $('#tDHCEQFunds').datagrid('endEdit',editFlag);
    $('#tDHCEQFunds').datagrid('beginEdit',editFlag);
}


function getFunctionCat(index,data)
{
    var rowData = $('#tDHCEQFunds').datagrid('getSelected');
    rowData.TFunctionCatDR=data.TRowID;
    var functionCatEdt = $('#tDHCEQFunds').datagrid('getEditor', {index:editFlag,field:'TFunctionCat'});
    $(functionCatEdt.target).combogrid("setValue",data.TName);
    $('#tDHCEQFunds').datagrid('endEdit',editFlag);
    $('#tDHCEQFunds').datagrid('beginEdit',editFlag);
}

///modified by ZY0213
function clearFunctionCat()
{
    var rowData = $('#tDHCEQFunds').datagrid('getSelected');
    rowData.TFunctionCatDR="";
    $('#tDHCEQFunds').datagrid('endEdit',editFlag);
    $('#tDHCEQFunds').datagrid('beginEdit',editFlag);
}
function getFundsType(index,data)
{
    //Modify by zx 20200302 BUG ZX0079
    //if (data.TRowID==getElementValue("SelfFundsID"))
    //{
    //    messageShow('alert','error','错误提示',data.TName+'不能存在多条!');
    //    return;
    // }
    // else
    //{
        var rowData = $('#tDHCEQFunds').datagrid('getSelected');
        rowData.TFundsTypeDR=data.TRowID;
        var fundsTypeEdt = $('#tDHCEQFunds').datagrid('getEditor', {index:editFlag,field:'TFundsType'});
        $(fundsTypeEdt.target).combogrid("setValue",data.TName);
        $('#tDHCEQFunds').datagrid('endEdit',editFlag);
        //Modify By zx 2020-03-02 BUG ZX0079 点击开启监听费用变化
        //$('#tDHCEQFunds').datagrid('beginEdit',editFlag);
    //}
}

function bindGridEvent()
{
    if (editFlag == undefined){return true}
    try
    {
        var objGrid = $("#tDHCEQFunds");        // 表格对象
        var feeEdt = objGrid.datagrid('getEditor', {index:editFlag,field:'TFee'});            // 数量
        /*  CZF 2021-06-03
        // MZY0070  1756530     2021-02-20
        var OtherDepreTotal=0
        var UnitDepreFee=0;     //单位折旧额
        if (getElementValue("FromType")==7)
        {
            UnitDepreFee=tkMakeServerCall("web.DHCEQFunds","getUnitDepreFee",getElementValue("FromID"));
        }
        */
        // 数量  绑定 离开事件 
        $(feeEdt.target).bind("blur",function(){
            var OtherFunds=0
            var CurRow=0
            var rows = objGrid.datagrid('getRows');
            var RowCount=rows.length;
            for (var i=0; i<RowCount;i++)
            {
                //Modify By zx 2020-02-19 BUG ZX0075
                if (rows[i].TFundsTypeDR!=getElementValue("SelfFundsID"))
                {
                    if(i==editFlag)
                    {
                        var CurFee=$(feeEdt.target).val();
                        /*  CZF 2021-06-03
                        // MZY0070  1756530     2021-02-20
                        var CurDepreTotal=UnitDepreFee*(CurFee*1);
                        var DepreTotalEdt = objGrid.datagrid('getEditor', {index:i,field:'TDepreTotal'}); 
                        $(DepreTotalEdt.target).val(CurDepreTotal.toFixed(2));
                        rows[i].TCurDepreTotalFee=(+rows[i].TCurDepreTotalFee+CurDepreTotal).toFixed(2);
                        OtherDepreTotal=OtherDepreTotal+CurDepreTotal.toFixed(2);
                        */
                    }
                    else
                    {
                        var CurFee=rows[i].TFee;
                    }
                    OtherFunds=OtherFunds+CurFee*1;
                }
                else
                {
                    CurRow=i
                }
            }
            var Fee=getElementValue("CAChangeFee")-OtherFunds;
            rows[CurRow].TFee=Fee;
            /*  CZF 2021-06-03
            // MZY0070  1756530     2021-02-20
            rows[CurRow].TDepreTotal=0-OtherDepreTotal;     //变动累计折旧
            rows[CurRow].TCurDepreTotalFee=rows[CurRow].TCurDepreTotalFee-OtherDepreTotal;  //变动后累计折旧
            */
            objGrid.datagrid('refreshRow', CurRow); 
            $('#tDHCEQFunds').datagrid('endEdit',editFlag);
            RefreshTable();
        });
        var depreTotalEdt = objGrid.datagrid('getEditor', {index:editFlag,field:'TDepreTotal'});
        $(depreTotalEdt.target).bind("blur",function(){
            var OtherDepreTotal=0
            var CurRow=0
            var rows = objGrid.datagrid('getRows');
            var RowCount=rows.length;
            for (var i=0; i<RowCount;i++)
            {
                //Modify By zx 2020-02-19 BUG ZX0075
                if (rows[i].TFundsTypeDR!=getElementValue("SelfFundsID"))
                {
                    if(i==editFlag)
                    {
                        var TDepreTotal=$(depreTotalEdt.target).val();
                    }
                    else
                    {
                        var TDepreTotal=rows[i].TDepreTotal;
                    }
                    OtherDepreTotal=OtherDepreTotal+TDepreTotal*1;
                }
                else
                {
                    CurRow=i;
                }
            }
            var TDepreTotal=getElementValue("CAHold2")-OtherDepreTotal;
            rows[CurRow].TDepreTotal=TDepreTotal;
            objGrid.datagrid('refreshRow', CurRow); 
            $('#tDHCEQFunds').datagrid('endEdit',editFlag);
            RefreshTable();
        });
    }
    catch(e)
    {
        alertShow(e);
    }
}
function RefreshTable()
{
    var rows = $('#tDHCEQFunds').datagrid('getRows');
    var RowCount=rows.length;
    for (var i=0; i<RowCount;i++)
    {
        var CurFee=rows[i].TFee;
        var DepreTotal=rows[i].TDepreTotal;
        var PreFundsFee=rows[i].TPreFundsFee;
        var PreDepreTotalFee=rows[i].TPreDepreTotalFee;
        //modified by ZY0218 2020-04-10
        var CurFundsFee=(CurFee*1)+(PreFundsFee*1);
        var CurDepreTotalFee=(DepreTotal*1)+(PreDepreTotalFee*1);
        /*
        //Modify By zx 2020-02-19 BUG ZX0075
        if (rows[i].TFundsTypeDR!=getElementValue("SelfFundsID"))
        {
            var CurFundsFee=(CurFee*1)+(PreFundsFee*1);
            var CurDepreTotalFee=(DepreTotal*1)+(PreDepreTotalFee*1);
        }
        else
        {
            var CurFundsFee=CurFee*1;
            var CurDepreTotalFee=DepreTotal*1;
        }
        */
        rows[i].TCurFundsFee=CurFundsFee.toFixed(2);
        rows[i].TCurDepreTotalFee=CurDepreTotalFee.toFixed(2);
        $('#tDHCEQFunds').datagrid('refreshRow', i);
    }
}

//Add By QW20210629 BUG:QW0129 文件上传
function BAppendFile_Clicked()
{
    var result=getElementValue("CARowID")
    if (result=="") return;
    
    var Status=getElementValue("CAStatus");
    var str='dhceq.plat.appendfile.csp?&CurrentSourceType=51&CurrentSourceID='+result+'&Status=0&ReadOnly=';
    showWindow(str,"电子资料","","","icon-w-paper","modal","","","large");
}
//Add By QW20210629 BUG:QW0129 图片上传
function BPicture_Clicked()
{
    var ReadOnly=getElementValue("ReadOnly");
    var result=getElementValue("CARowID")
    if (result=="") return;
    
    var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=51&CurrentSourceID='+result+'&Status=&ReadOnly='+ReadOnly;
    showWindow(str,"图片信息","","","icon-w-paper","modal","","","middle"); //modify by lmm 2020-06-04 UI
}

///以下为打印相关代码

// modified by sjh 2019-12-03 BUG00018
// modify by wl 2019-12-17 WL0030
function BCAPrint_Clicked()
{
    var CARowID=getElementValue("CARowID")
    var PrintFlag = getElementValue("PrintFlag");    //打印方式标志位 excel：0  润乾:1   
    var PreviewRptFlag = getElementValue("PreviewRptFlag"); //润乾预览标志 不预览 :0  预览 :1
    var HOSPDESC = getElementValue("HospitalDesc");
    var filename = ""
    //Excel打印方式
    if(PrintFlag==0)  
    {
        BPrintExcleCA();
    }
    //润乾打印
    else if(PrintFlag==1)
    {
        if(PreviewRptFlag==0)
        { 
            fileName="{DHCEQChangeAccountPrint.raq(RowID="+CARowID
            +";HOSPDESC="+HOSPDESC
            +";USERNAME="+curUserName
            +";PrintFlag=1"
            +")}";  
            DHCCPM_RQDirectPrint(fileName);     
        }else if(PreviewRptFlag==1)
        { 
            fileName="DHCEQChangeAccountPrint.raq&RowID="+CARowID
            +"&HOSPDESC="+HOSPDESC
            +"&USERNAME="+curUserName      
            DHCCPM_RQPrint(fileName);   
        }
    }               
}

// modified by sjh 2019-12-03 BUG00018
function BPrintExcleCA_Clicked()
{
    var CARowID=getElementValue("CARowID");
    if (CARowID=="") return;
    var ReturnList=tkMakeServerCall("web.DHCEQChangeAccount","GetOneChangeAccount",CARowID);
    ReturnList=ReturnList.replace(/\\n/g,"\n");
    var lista=ReturnList.split("^");
    
    var gbldata=tkMakeServerCall("web.DHCEQChangeAccount","GetChangeAccountByID","","",CARowID);
    gbldata=gbldata.replace(/\\n/g,"\n");   ///Modified by JDL 2012-3-21 JDL0125
    var list=gbldata.split("^");
    //messageShow("","","",gbldata)
    var Listall=list[0];
    rows=list[1];
    
    var TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP","GetPath");
    var xlApp,xlsheet,xlBook;
    var Template=TemplatePath+"DHCEQChangeAccount.xls";
    xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Template);
    xlsheet = xlBook.ActiveSheet;
    try 
    {
        xlsheet.cells.replace("[Hospital]",getElementValue("HospitalDesc"))
        xlsheet.cells(3,3)=CARowID;     //调账单号
        xlsheet.cells(3,7)=ChangeDateFormat(lista[2]);  //变动日期
        
        xlsheet.cells(4,3)=lista[0];    //设备编号
        xlsheet.cells(4,5)=lista[1];    //设备名称
        xlsheet.cells(4,7)=GetShortName(lista[5],"-");  //科室
        xlsheet.cells(5,3)=lista[8];    //出厂编号
        xlsheet.cells(5,5)=lista[6];    //机型
        xlsheet.cells(5,7)=lista[7];    //单位
        xlsheet.cells(6,3)=list[1];     //调整金额
        xlsheet.cells(6,5)=lista[3];    //调前原值
        xlsheet.cells(6,7)=parseFloat(list[3])-parseFloat(list[1]); //调前净值
        
        xlsheet.cells(7,5)=lista[4];    //调后原值
        xlsheet.cells(7,7)=list[3];     //调后净值
        xlsheet.cells(8,3)=list[7];     //调整原因
        xlsheet.cells(9,3)=list[5];     //调整项目
        xlsheet.cells(10,3)=list[9];    //备注
        
        xlsheet.cells(11,3)=username;   //制单人
        xlsheet.cells(11,7)=GetCurrentDate();  //打印日期
        
        var obj = new ActiveXObject("PaperSet.GetPrintInfo");
        var size=obj.GetPaperInfo("DHCEQInStock");
        if (0!=size)
        {
            xlsheet.PageSetup.PaperSize = size;
        }
        //var savepath=GetFileName();
        //xlBook.SaveAs(savepath);
        xlBook.printout();
        //xlApp.Visible=true;
        //xlsheet.PrintPreview();
        xlBook.Close (savechanges=false);
        xlsheet.Quit;
        xlsheet=null;
        xlApp=null;
    } 
    catch(e)
    {
        messageShow("","","",e.message);
    }
}

// modified by sjh 2019-12-03 BUG00018
// modify by wl 2019-12-17 WL0030
function BAffixISPrint_Click()
{
    var CARowID=getElementValue("CARowID")
    var PrintFlag = getElementValue("PrintFlag");    //打印方式标志位 excel：0  润乾:1   
    var PreviewRptFlag = getElementValue("PreviewRptFlag"); //润乾预览标志 不预览 :0  预览 :1
    var HOSPDESC = getElementValue("HospitalDesc");
    var filename = ""
    //Excel打印方式
    if(PrintFlag==0)  
    {
        BPrintExcleCA();
    }
    //润乾打印
    else if(PrintFlag==1)
    {
        if(PreviewRptFlag==0)
        { 
            fileName="{DHCEQCAAffixInstockPrint.raq(RowID="+CARowID
            +";HOSPDESC="+HOSPDESC
            +";USERNAME="+curUserName
            +")}";  
            DHCCPM_RQDirectPrint(fileName);     
        }
        else if(PreviewRptFlag==1)
        { 
            fileName="DHCEQCAAffixInstockPrint.raq&RowID="+CARowID
            +"&HOSPDESC="+HOSPDESC
            +"&USERNAME="+curUserName   
            DHCCPM_RQPrint(fileName);   
        }
    }   
}
// modify by wl 2019-12-17 WL0030
// modified by sjh 2019-12-03 BUG00018
function BAffixSMPrint_Click()
{
    var CARowID=getElementValue("RowID")
    var PrintFlag = getElementValue("PrintFlag");    //打印方式标志位 excel：0  润乾:1   
    var PreviewRptFlag = getElementValue("PreviewRptFlag"); //润乾预览标志 不预览 :0  预览 :1
    var HOSPDESC = getElementValue("HospitalDesc");
    var filename = ""
    //Excel打印方式
    if(PrintFlag==0)  
    {
        BPrintExcleCA();
    }
    //润乾打印
    else if(PrintFlag==1)
    {
        if(PreviewRptFlag==0)
        { 
            fileName="{DHCEQCAAffixSMPrint.raq(RowID="+CARowID
            +";HOSPDESC="+HOSPDESC
            +";USERNAME="+curUserName
            +")}";  
            DHCCPM_RQDirectPrint(fileName);     
        }
        else if(PreviewRptFlag==1)
        { 
            fileName="DHCEQCAAffixSMPrint.raq&RowID="+CARowID
            +"&HOSPDESC="+HOSPDESC
            +"&USERNAME="+curUserName      
            DHCCPM_RQPrint(fileName);   
        }
    }
}

// modified by sjh 2019-12-03 BUG00018
function BPrintAffixISExcel_Click()
{
    var CARowID=getElementValue("RowID")
    if (CARowID=="") return;
    var ReturnList=tkMakeServerCall("web.DHCEQChangeAccount","GetOneChangeAccount",CARowID);
    ReturnList=ReturnList.replace(/\\n/g,"\n");
    var lista=ReturnList.split("^");
    var gbldata=tkMakeServerCall("web.DHCEQChangeAccount","GetList",CARowID);
    var list=gbldata.split("_");
    var Listall=list[0];
    rows=list[1];
    var PageRows=6;
    var Pages=parseInt(rows / PageRows); //总页数?1  3为每页固定行数
    var ModRows=rows%PageRows; //最后一页行数
    if (ModRows==0) {Pages=Pages-1;}
    var TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP","GetPath");
    try 
    {
        var xlApp,xlsheet,xlBook;
        var Template=TemplatePath+"DHCEQCAAffixInStock.xls";
        xlApp = new ActiveXObject("Excel.Application");
        for (var i=0;i<=Pages;i++)
        {
            xlBook = xlApp.Workbooks.Add(Template);
            xlsheet = xlBook.ActiveSheet;
            //医院名称替换 Add By DJ 2011-07-14
            xlsheet.cells.replace("[Hospital]",getElementValue("HospitalDesc"))
            xlsheet.cells(2,1)="单  据  号:"+CARowID;
            xlsheet.cells(2,5)=ChangeDateFormat(lista[2]);  //Mozy0073  2011-12-08
            xlsheet.cells(3,1)="主设备编号:"+lista[0];
            xlsheet.cells(3,5)=lista[1];
            xlsheet.cells(11,2)=lista[3];
            xlsheet.cells(11,6)=lista[4];
            var OnePageRow=PageRows;
            if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
            for (var j=1;j<=OnePageRow;j++)
            {
                var Lists=Listall.split(":");
                var Listl=Lists[i*PageRows+j];
                var List=Listl.split("^");
                var Row=4+j;
                xlsheet.cells(Row,1)=List[0];//名称
                xlsheet.cells(Row,2)=List[1];//规格
                xlsheet.cells(Row,3)=List[2];//单价
                xlsheet.cells(Row,4)=List[3];//数量
                xlsheet.cells(Row,5)=List[4];//金额
                xlsheet.cells(Row,6)=List[5];//备注
            }
            xlsheet.cells(12,6)="页码:"+(i+1)+"/"+(Pages+1);
            var obj = new ActiveXObject("PaperSet.GetPrintInfo");
            var size=obj.GetPaperInfo("DHCEQInStock");
            if (0!=size)
            {
                xlsheet.PageSetup.PaperSize = size;
            }
            else
            {
                alertShow("No Find PaperSet DHCEQInStock");
                return
            }
            //var savepath=GetFileName();
            //xlBook.SaveAs(savepath);
            xlBook.printout();
            xlBook.Close (savechanges=false);
            xlsheet.Quit;
            xlsheet=null;
        }
        xlApp=null;
    } 
    catch(e)
    {
        messageShow("","","",e.message);
    }
    
}

// modified by sjh 2019-12-03 BUG00018
function BPrintAffixSMExcel_Click()
{
    var CARowID=getElementValue("RowID")
    if (CARowID=="") return;
    var ReturnList=tkMakeServerCall("web.DHCEQChangeAccount","GetOneChangeAccount",CARowID);
    ReturnList=ReturnList.replace(/\\n/g,"\n");
    var lista=ReturnList.split("^");
    var gbldata=tkMakeServerCall("web.DHCEQChangeAccount","GetList",CARowID);
    var list=gbldata.split("_");
    var Listall=list[0];
    rows=list[1];
    var PageRows=6;
    var Pages=parseInt(rows / PageRows); //总页数?1  3为每页固定行数
    var ModRows=rows%PageRows; //最后一页行数
    if (ModRows==0) {Pages=Pages-1;}
    
    var TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP","GetPath");
    try 
    {
        var xlApp,xlsheet,xlBook;
        var Template=TemplatePath+"DHCEQCAAffixStoreMove.xls";
        xlApp = new ActiveXObject("Excel.Application");
        for (var i=0;i<=Pages;i++)
        {
            xlBook = xlApp.Workbooks.Add(Template);
            xlsheet = xlBook.ActiveSheet;
            //医院名称替换 Add By DJ 2011-07-14
            xlsheet.cells.replace("[Hospital]",getElementValue("HospitalDesc"))
            xlsheet.cells(2,1)="单  据  号:"+CARowID;
            xlsheet.cells(2,3)=ChangeDateFormat(lista[2]);  //Mozy0073  2011-12-08
            xlsheet.cells(2,6)=GetShortName(lista[5],"-");
            xlsheet.cells(3,1)="主设备编号:"+lista[0];
            xlsheet.cells(3,5)=lista[1];
            var OnePageRow=PageRows;
            if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
            for (var j=1;j<=OnePageRow;j++)
            {
                var Lists=Listall.split(":");
                var Listl=Lists[i*PageRows+j];
                var List=Listl.split("^");
                var Row=4+j;
                xlsheet.cells(Row,1)=List[0];//名称
                xlsheet.cells(Row,2)=List[1];//规格
                xlsheet.cells(Row,3)=List[2];//单价
                xlsheet.cells(Row,4)=List[3];//数量
                xlsheet.cells(Row,5)=List[4];//金额
                xlsheet.cells(Row,6)=List[5];//备注
            }
            xlsheet.cells(12,6)="页码:"+(i+1)+"/"+(Pages+1);
            var obj = new ActiveXObject("PaperSet.GetPrintInfo");
            var size=obj.GetPaperInfo("DHCEQInStock");
            if (0!=size)
            {
                xlsheet.PageSetup.PaperSize = size;
            }
            else
            {
                alertShow("No Find PaperSet DHCEQInStock");
                return
            }
            //var savepath=GetFileName();
            //xlBook.SaveAs(savepath);
            xlBook.printout();
            xlBook.Close (savechanges=false);
            xlsheet.Quit;
            xlsheet=null;
        }
        xlApp=null;
    } 
    catch(e)
    {
        messageShow("","","",e.message);
    }   
}



//201702-04 Mozy
/// 南方医院请领报销单格式的调账单
function BPrintNew_Clicked()
{
    var RowID=getElementValue("RowID");
    if (RowID=="") return;
    var ReturnList=tkMakeServerCall("web.DHCEQChangeAccount","GetOneChangeAccount",CARowID);
    ReturnList=ReturnList.replace(/\\n/g,"\n");
    var lista=ReturnList.split("^");
    //messageShow("","","",ReturnList)
    
    var gbldata=tkMakeServerCall("web.DHCEQChangeAccount","GetList",CARowID);
    //messageShow("","","",RowID+":"+gbldata);
    var list=gbldata.split(getElementValue("SplitNumCode"));
    var Listall=list[0];
    rows=list[1];
    
    var PageRows=17;
    var ModRows=rows%PageRows;
    var Pages=parseInt(rows / PageRows);
    if (ModRows==0) {Pages=Pages-1;}
    var TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP","GetPath");
    try
    {
        var xlApp,xlsheet,xlBook;
        var Template=TemplatePath+"DHCEQPayRequestList.xls";
        if (curLocID=571) Template=TemplatePath+"DHCEQPayRequestListQCK.xls";   //设备器材科仓库
        xlApp = new ActiveXObject("Excel.Application");
        for (var i=0;i<=Pages;i++)
        {
            xlBook = xlApp.Workbooks.Add(Template);
            xlsheet = xlBook.ActiveSheet;
            var sort=33;
            
            //医院名称替换
            xlsheet.cells.replace("[Hospital]",getElementValue("HospitalDesc"));
            //xlsheet.cells(3,1)=xlsheet.cells(3,1)+lista[sort+1];  //供应商
            xlsheet.cells(3,4)=xlsheet.cells(3,4)+ChangeDateFormat(lista[2]);  //报销日期
            xlsheet.cells(3,8)=RowID;    //付款单号
            //xlsheet.cells(25,1)=xlsheet.cells(25,1)+GetShortName(lista[sort+0],"-");  //制表单位
            xlsheet.cells(25,4)=xlsheet.cells(25,4)+username;
            xlsheet.cells(25,8)=ChangeDateFormat(GetCurrentDate());
            xlsheet.cells(25,10)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页";
            
            var OnePageRow=PageRows;
            if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
            var Row=5;
            for (var j=1;j<=OnePageRow;j++)
            {
                var Lists=Listall.split(getElementValue("SplitRowCode"));
                var Listl=Lists[i*PageRows+j];
                var List=Listl.split("^");
                //messageShow("","","",Listl)
                // TAffix_"^"_TModel_"^"_TPrice_"^"_TNum_"^"_TAmount_"^"_TRemark_"^"_TUnit_"^"_Provider
                if (j==1) xlsheet.cells(3,1)=xlsheet.cells(3,1)+List[7];  //供应商
                xlsheet.cells(Row,1)=j; //序号
                xlsheet.cells(Row,2)=lista[5];//设备科室
                xlsheet.cells(Row,3)=List[0];//附件名称
                xlsheet.cells(Row,4)=List[1];//机型
                xlsheet.cells(Row,5)=List[6];//单位
                xlsheet.cells(Row,6)=List[3];//数量
                xlsheet.cells(Row,7)=List[2];//原值
                xlsheet.cells(Row,8)=List[4];//付款金额
                xlsheet.cells(Row,9)=lista[9];//经费来源
                xlsheet.cells(Row,10)=lista[10];//存放地点
                
                Row=Row+1;
            }
            xlsheet.cells(22,1)="合计(大写):"+list[3];
            xlsheet.cells(22,7)="￥:"+list[2];
            xlApp.Visible=true;
            xlsheet.PrintPreview();
            //xlsheet.printout;     //打印输出
            //xlBook.SaveAs("D:\\InStock"+i+".xls");
            xlBook.Close (savechanges=false);
            xlsheet.Quit;
            xlsheet=null;
        }
        xlApp=null;
    } 
    catch(e)
    {
        messageShow("","","",e.message);
    }
}
