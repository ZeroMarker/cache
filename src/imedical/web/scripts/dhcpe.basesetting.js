
//dhcpe.basesetting.js
var init = function(){
    /*
    var str=$("#NewVerReport").switchbox("getValue");
    if(str){$("#ReportCode").attr('disabled',true);}
    else{$("#ReportCode").attr('disabled',false);}

     var str=$("#NewVerReport").switchbox("getValue");
    if(str){$("#NetReport").switchbox("setValue",true);}
    
    $('#NewVerReport').on('switch-change', function (e, data) {
                if(data.value){
                $("#NetReport").switchbox("setValue",true)
                    }
                
        });
    */
  /*
        var str=$("#SendPisFBWay").combobox("getValue");
    if(str=="F"){$("#PrintPISTiaomaNew").switchbox("setValue",true);}
*/

    var str=$("#NewVerReport").combobox("getValue");
    if(str=="Word"){$("#ReportCode").attr('disabled',true);}
    else{$("#ReportCode").attr('disabled',false);}

     var str=$("#NewVerReport").combobox("getValue");
    if(str=="Word"){$("#NetReport").switchbox("setValue",true);}
    
    $("#NewVerReport").combobox({
            onSelect:function(){
                if($("#NewVerReport").combobox("getValue")=="Word") {
                    $("#NetReport").switchbox("setValue",true);
                    $("#ReportCode").attr('disabled',true); 
                }else{
                    $("#ReportCode").attr('disabled',false);
                }
        }
        }); 
  



    var str=$("#InvListFlag").switchbox("getValue");
    if(str){$("#InvCol").attr('disabled',true);
                    $("#InvMaxListCount").attr('disabled',true);}
    else{$("#InvCol").attr('disabled',false);
                    $("#InvMaxListCount").attr('disabled',false);}
    
    $('#InvListFlag').on('switch-change', function (e, data) {
                if(data.value){
                    $("#InvCol").attr('disabled',false);
                    $("#InvMaxListCount").attr('disabled',false);
                    
                    }
                else{
                    
                    $("#InvCol").attr('disabled',true);
                    $("#InvMaxListCount").attr('disabled',true);
                    
                    }
        });
    
    var LocSettingObj = $HUI.datagrid("#LocSetting",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCPE.HISUICommon",
            QueryName:"FindBaseSetting"

        },
        onClickRow:function(rowIndex,rowData){
            var loc=rowData.Loc
            $('#NowLoc').combogrid('grid').datagrid('reload',{'q':"体检"});
            setValueById("NowLoc",loc)
            SetByLoc(loc)
            /*var str=$("#NewVerReport").switchbox("getValue");
            if(str){$("#ReportCode").attr('disabled',true);}
            else{$("#ReportCode").attr('disabled',false);}
            */
            var str=$("#NewVerReport").combobox("getValue");
            if(str=="Word"){$("#ReportCode").attr('disabled',true);}
            else{$("#ReportCode").attr('disabled',false);}


            
        },
        
        columns:[[
            {field:'Loc',title:'Loc'},
            {field:'LocDesc',title:'科室'},
            {field:'AutoArrived',title:'自动到达'},
            {field:'AutoAuditUserID',title:'自动提交人ID',hidden:true},
            {field:'AutoAuditUser',title:'自动提交人'},
            {field:'CashierSystem',title:'视同收费模式'},
            {field:'PhyExamDrId',title:'默认体检医生ID'},
            {field:'PhyExamDr',title:'默认体检医生'},
            {field:'OrderInterfaceType',title:'插医嘱方式'},
            {field:'DefPrintType',title:'预约打印选项'},
            {field:'CallVoice',title:'叫号接口'},
            {field:'CancelPEType',title:'取消体检不删除未检'},
            {field:'AllowCharge',title:'团体允许收费'},
            {field:'MainDoctorGroup',title:'复审功能'},
            {field:'IsAddItem',title:'收表后允许加项'},
            {field:'NewVerReport',title:'体检报告格式'},
            {field:'ReportCode',title:'报告代码'},
            {field:'HPNo',title:'体检号'},
            {field:'NetReport',title:'网上看报告'},
            {field:'SendOrder',title:'平台接口'},
            {field:'AllowPrint',title:'未付费允许打印'},
            {field:'IsPGetReportPT',title:'收表后是否打印取报告凭条'},
            {field:'IfPrintMinusInv',title:'是否打印负票'},
            {field:'IfNetPre',title:'网上预约'},
            {field:'IfNetRegister',title:'网上登记'},
            {field:'IfNetCancelPE',title:' 网上取消记录'},
            {field:'IfPreSurvey',title:'预约填写问卷 '},
            {field:'IfRecommendItem',title:'根据问卷推荐套餐'},
            {field:'TransResult',title:'回传结果'},
            {field:'IsFeeLocFlag',title:'按科室计费'},
            {field:'CollectSpecOne',title:'单个采集标本'},
            {field:'IsCardLocFlag',title:'体检卡跨科室使用'},
            {field:'OrderInterface',title:'新版检查申请单',styler: function(value,row,index){
                
                    return 'border-right:0;';
                }
            }
        ]],
        pagination:true,
        displayMsg:"",
        pageSize:20,
        fit:false
    
    })
    
    //设置医生界面^打印条码是否自动到达^到达界面读卡自动到达^打印指引单
    var AutoArrived = $HUI.combobox("#AutoArrived",{
        valueField:'id',textField:'text',multiple:true,selectOnNavigation:false,panelHeight:"auto",editable:false,
        rowStyle:'checkbox',
        data:[
            {id:'1',text:'医生界面'},{id:'2',text:'打印条码'},{id:'4',text:'打印指引'}
        ]
        /*
        formatter:function(row){  
            var opts;
            if(row.selected==true){
                
                opts = "<input type='checkbox' checked='checked' id='AutoArrived"+row.id+"' value='"+row.id+"'>"+row.text;
            }else{
                opts = "<input type='checkbox' id='AutoArrived"+row.id+"' value='"+row.id+"'>"+row.text;
            }
            return opts;
        },
        onSelect:function(rec) {
            var objr =  document.getElementById("AutoArrived"+rec.id);
            $(objr).prop('checked',true);
        },onUnselect:function(rec){
            var objr =  document.getElementById("AutoArrived"+rec.id);
            $(objr).prop('checked',false);
        }
        */
    });
    
    
    
    var DefPrintType = $HUI.combobox("#DefPrintType",{
        valueField:'id',textField:'text',multiple:true,selectOnNavigation:false,panelHeight:"auto",editable:false,
        rowStyle:'checkbox',
        data:[
            {id:'1',text:'个人信息条码'},{id:'2',text:'指引单'},{id:'3',text:'化验条码'}
            ,{id:'4',text:'检查条码'}
        ]
        /*
        formatter:function(row){  
            var opts;
            if(row.selected==true){
                
                opts = "<input type='checkbox' checked='checked' id='DefPrintType"+row.id+"' value='"+row.id+"'>"+row.text;
            }else{
                opts = "<input type='checkbox' id='DefPrintType"+row.id+"' value='"+row.id+"'>"+row.text;
            }
            return opts;
        },
        onSelect:function(rec) {
            var objr =  document.getElementById("DefPrintType"+rec.id);
            $(objr).prop('checked',true);
        },onUnselect:function(rec){
            var objr =  document.getElementById("DefPrintType"+rec.id);
            $(objr).prop('checked',false);
        }
        */
    });
    /*
    /// 团体报告中是统计诊断还是疾病   以及打印的建议是疾病的建议还是诊断的建议  维护诊断时是否需要关联疾病
    var GRDiagnosisType = $HUI.combobox("#GRDiagnosisType",{
        valueField:'id',textField:'text',multiple:true,selectOnNavigation:false,panelHeight:"auto",editable:false,
        data:[
            {id:'1',text:'团体报告'},{id:'2',text:'打印建议'},{id:'3',text:'维护诊断'}
        ],
        formatter:function(row){  
            var opts;
            if(row.selected==true){
                opts = "<input type='checkbox' checked='checked' id='GRDiagnosisType"+row.id+"' value='"+row.id+"'>"+row.text;
            }else{
                opts = "<input type='checkbox' id='GRDiagnosisType"+row.id+"' value='"+row.id+"'>"+row.text;
            }
            return opts;
        },
        onSelect:function(rec) {
            var objr =  document.getElementById("GRDiagnosisType"+rec.id);
            $(objr).prop('checked',true);
        },onUnselect:function(rec){
            var objr =  document.getElementById("GRDiagnosisType"+rec.id);
            $(objr).prop('checked',false);
        }
    });
    */
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
    
    var FeeTypeSuperGroupObj = $HUI.combobox("#FeeTypeSuperGroup",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindFeeTypeSuperGroup&ResultSetType=array",
        valueField:'id',
        textField:'desc',
        onBeforeLoad:function(param){
            param.hospId = session['LOGON.HOSPID'];
        }

        });
        
        
    var SuperGroupObj = $HUI.combobox("#SuperGroup",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindFeeTypeSuperGroup&ResultSetType=array",
        valueField:'id',
        textField:'desc',
        onBeforeLoad:function(param){
            param.hospId = session['LOGON.HOSPID'];
        }

        }); 
    
    var LabStationObj = $HUI.combobox("#StationId_Lab",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationBase&ResultSetType=array",
        valueField:'id',
        textField:'desc'
        });
    
    var MedicalStationObj = $HUI.combobox("#StationId_Medical",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStation&ResultSetType=array",
        valueField:'id',
        textField:'desc'
        });
        
    var OtherStationObj = $HUI.combobox("#StationId_Other",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStation&ResultSetType=array",
        valueField:'id',
        textField:'desc'
        });
    
    
    
    
    var AllowAddItemObj = $HUI.combobox("#AllowAddItem",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStation&ResultSetType=array",
        valueField:'id',
        textField:'desc',multiple:true,selectOnNavigation:false,panelHeight:"auto",editable:false,
        formatter:function(row){  
            var opts;
            if(row.selected==true){
                opts = "<input type='checkbox' checked='checked' id='aai"+row.id+"' value='"+row.id+"'>"+row.desc;
            }else{
                opts = "<input type='checkbox' id='aai"+row.id+"' value='"+row.id+"'>"+row.desc;
            }
            return opts;
        },
        onSelect:function(rec) {
            var objr =  document.getElementById("aai"+rec.id);
            $(objr).prop('checked',true);
        },onUnselect:function(rec){
            var objr =  document.getElementById("aai"+rec.id);
            $(objr).prop('checked',false);
        }
    });
    
    
    var SendRisApplicationObj = $HUI.combobox("#SendRisApplication",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStation&ResultSetType=array",
        valueField:'id',
        textField:'desc',multiple:true,selectOnNavigation:false,panelHeight:"auto",editable:false,
        formatter:function(row){  
            var opts;
            if(row.selected==true){
                opts = "<input type='checkbox' checked='checked' id='sra"+row.id+"' value='"+row.id+"'>"+row.desc;
            }else{
                opts = "<input type='checkbox' id='sra"+row.id+"' value='"+row.id+"'>"+row.desc;
            }
            return opts;
        },
        onSelect:function(rec) {
            var objr =  document.getElementById("sra"+rec.id);
            $(objr).prop('checked',true);
        },onUnselect:function(rec){
            var objr =  document.getElementById("sra"+rec.id);
            $(objr).prop('checked',false);
        }
    });
    
    
    var StationIdRisObj = $HUI.combobox("#StationId_Ris",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStation&ResultSetType=array",
        valueField:'id',
        rowStyle:'checkbox',
        textField:'desc',multiple:true,selectOnNavigation:false,panelHeight:300,editable:false
    });

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

    var CashierModeObj = $HUI.combobox("#CashierMode",{
        url:$URL+"?ClassName=web.DHCPE.Public.SettingCashierEdit&QueryName=SearchPayMode&ResultSetType=array",
        valueField:'TPayModeID',
        rowStyle:'checkbox',
        textField:'TPayMode',multiple:true,selectOnNavigation:false,panelHeight:300,editable:false
    });
    var CardModeObj = $HUI.combobox("#CardMode",{
        url:$URL+"?ClassName=web.DHCPE.Public.SettingCashierEdit&QueryName=SearchPayMode&ResultSetType=array",
        valueField:'TPayModeID',
        rowStyle:'checkbox',
        textField:'TPayMode',multiple:true,selectOnNavigation:false,panelHeight:300,editable:false
    });
    var RefundModeObj = $HUI.combobox("#RefundMode",{
        url:$URL+"?ClassName=web.DHCPE.Public.SettingCashierEdit&QueryName=SearchPayMode&ResultSetType=array",
        valueField:'TPayModeID',
        rowStyle:'checkbox',
        textField:'TPayMode',multiple:true,selectOnNavigation:false,panelHeight:300,editable:false
    });
    
    var ExtPayModeObj = $HUI.combobox("#ExtPayMode",{
        url:$URL+"?ClassName=web.DHCPE.Public.SettingCashierEdit&QueryName=SearchPayMode&ResultSetType=array",
        valueField:'TPayModeCode',
        rowStyle:'checkbox',
        textField:'TPayMode',multiple:true,selectOnNavigation:false,panelHeight:300,editable:false
    });
    var ExtPayModeObj = $HUI.combobox("#DHCScanCode",{
        url:$URL+"?ClassName=web.DHCPE.Public.SettingCashierEdit&QueryName=SearchPayMode&ResultSetType=array",
        valueField:'TPayModeCode',
        rowStyle:'checkbox',
        textField:'TPayMode',multiple:true,selectOnNavigation:false,panelHeight:300,editable:false
    });
    /// 团体报告中是统计诊断还是疾病   以及打印的建议是疾病的建议还是诊断的建议  维护诊断时是否需要关联疾病
    var GRDiagnosisType = $HUI.combobox("#GRDiagnosisType",{
        valueField:'id',textField:'text',multiple:true,selectOnNavigation:false,panelHeight:"auto",editable:false,
        rowStyle:'checkbox',
        data:[
            {id:'1',text:'团体报告'},{id:'2',text:'打印建议'},{id:'3',text:'维护诊断'}
        ]
    });
    
    /*
    var StationIdRisObj = $HUI.combobox("#StationId_Ris",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStation&ResultSetType=array",
        valueField:'id',
        textField:'desc',multiple:true,selectOnNavigation:false,panelHeight:"auto",editable:false,
        formatter:function(row){  
            var opts;
            if(row.selected==true){
                opts = "<input type='checkbox' checked='checked' id='StationId_Ris"+row.id+"' value='"+row.id+"'>"+row.desc;
            }else{
                opts = "<input type='checkbox' id='StationId_Ris"+row.id+"' value='"+row.id+"'>"+row.desc;
            }
            return opts;
        },
        onSelect:function(rec) {
            var objr =  document.getElementById("StationId_Ris"+rec.id);
            $(objr).prop('checked',true);
        },onUnselect:function(rec){
            var objr =  document.getElementById("StationId_Ris"+rec.id);
            $(objr).prop('checked',false);
        }
    });
    */
    var CardTypeObj = $HUI.combobox("#CardType",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindCardType&ResultSetType=array",
        valueField:'id',
        textField:'cardtype'
    });
    
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
    
    
    var InvDefaultPayModeObj = $HUI.combobox("#InvDefaultPayMode",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPayMode&ResultSetType=array",
        valueField:'id',
        textField:'text'
    });
    
    var CanChangePayModesObj = $HUI.combobox("#CanChangePayModes",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPayMode&ResultSetType=array",
        valueField:'id',
        textField:'text',multiple:true,selectOnNavigation:false,panelHeight:"auto",editable:false,
        formatter:function(row){  
            var opts;
            if(row.selected==true){
                opts = "<input type='checkbox' checked='checked' id='CanChangePayModes"+row.id+"' value='"+row.id+"'>"+row.text;
            }else{
                opts = "<input type='checkbox' id='CanChangePayModes"+row.id+"' value='"+row.id+"'>"+row.text;
            }
            return opts;
        },
        onSelect:function(rec) {
            var objr =  document.getElementById("CanChangePayModes"+rec.id);
            $(objr).prop('checked',true);
        },onUnselect:function(rec){
            var objr =  document.getElementById("CanChangePayModes"+rec.id);
            $(objr).prop('checked',false);
        }
    });
    $("#BaseSave").click(function() {
            
            BaseSave(); 
            
    });
    $("#LocSave").click(function() {
            
            LocSave();
            
    });
    
    
    
    SetDefault();
}

function LocSave()
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
    
    
    var AutoArrived=$("#AutoArrived").combobox("getValues");
    var strarray=["N","N","N","N"]
    for(var i=0;i<AutoArrived.length;i++)
    {
        if(AutoArrived[i]=="1") strarray.splice(0,1,"Y")
        if(AutoArrived[i]=="2") strarray.splice(1,1,"Y")
        if(AutoArrived[i]=="3") strarray.splice(2,1,"Y")
        if(AutoArrived[i]=="4") strarray.splice(3,1,"Y")
    }
    var str=strarray.join("^");
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"AutoArrived",str);
    
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
    
    
    
    var str=$("#NetReport").switchbox("getValue");
    if(str) {str="Y",NetReport="Y";}
    else {str="N",NetReport="N"; }

    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"NetReport",str);
    /*
    var str=$("#NewVerReport").switchbox("getValue");
    if(str) { str="Y",NewVerReport="Y";}
    else {str="N",NewVerReport="N";}
  */
     var str=getValueById("NewVerReport")
    if(str=="Word") { NewVerReport="Y";}
    else {NewVerReport="N";}

    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"NewVerReport",str);
     
     if((NewVerReport=="Y")&&(NetReport=="N")){
        $.messager.alert("提示","新版报告启用，网上查看报告必须启用!","info");
        return false;
        }


    var str=$("#CallVoice").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"CallVoice",str);
    
    
    var str=$("#SendOrder").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"SendOrder",str);
    
    
    var str=$("#CancelPEType").switchbox("getValue");
    if(str) str="1"
    else str="0"   
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"CancelPEType",str);
    
    
    
    
    
    var str=getValueById("CashierSystem")
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"CashierSystem",str);
    
    
    var str=$("#AllowCharge").switchbox("getValue");
    if(str) str="1"
    else str="0"   
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"AllowCharge",str);
    
    var str=$("#AllowPrint").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"AllowPrint",str);
    
    
    
    var str=$("#MainDoctorGroup").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"MainDoctorGroup",str);
    
    var str=$("#IsAddItem").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"IsAddItem",str);

    var str=$("#IsPGetReportPT").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"IsPGetReportPT",str);

    var str=$("#IfPrintMinusInv").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"IfPrintMinusInv",str);

    var str=$("#OrderInterface").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"OrderInterface",str);
    
    
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
    
    
    var str=getValueById("ReportCode")
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"ReportCode",str);
    
    
    var str=getValueById("OrderInterfaceType")
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"OrderInterfaceType",str);
    
    var str=getValueById("HPNo")
    if(isNaN(str)){
        $.messager.alert("提示","体检号长度必须是数字!","info");
            return false;
    }

    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"HPNo",str);
    
    
    
    var str=$("#IfNetPre").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"NetPreLoc",str);
    
    var str=$("#IfNetRegister").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"AutoNetRegister",str);
    
    var str=$("#IfNetCancelPE").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"NetCancelPE",str);
    
    var str=$("#IfPreSurvey").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"PreSurvey",str);
    
    var str=$("#IfRecommendItem").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"RecommendItem",str);
    
    
    var DefPrintType=$("#DefPrintType").combobox("getValues");
    var strarray=["N","N","N","N"]
    for(var i=0;i<DefPrintType.length;i++)
    {
        if(DefPrintType[i]=="1")    strarray.splice(0,1,"Y")
        if(DefPrintType[i]=="2")    strarray.splice(1,1,"Y")
        if(DefPrintType[i]=="3")    strarray.splice(2,1,"Y")
        if(DefPrintType[i]=="4")    strarray.splice(3,1,"Y")
    }
    var str=strarray.join("^");
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"DefPrintType",str);
    
    var str=getValueById("TransResult")
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"TransResult",str);
    
    var str=$("#IsFeeLocFlag").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"IsFeeLocFlag",str);
    
    
    var str=$("#CollectSpecOne").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"CollectSpecOne",str);
    
    
    
    var str=$("#IsCardLocFlag").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"IsCardLocFlag",str);
    

    
    $("#LocSetting").datagrid('load',{ClassName:"web.DHCPE.HISUICommon",QueryName:"FindBaseSetting"}); 


    
    
    
    
    $.messager.alert("提示","当前科室设置成功!","success");
    
    
}

function BaseSave()
{
    var str=$("#ItemAbridgeFlag").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","ItemAbridgeFlag",str);
    
    
    var str=getValueById("CardType")
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","CardType",str); 
    
    var str=getValueById("InvCol")
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","InvCol",str);
    
    var str=$("#CardRelate").switchbox("getValue");
    if(str) str="Yes"
    else str="No"   
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","CardRelate",str);
    
    var str=$("#InvDefaulltFee").combogrid("getValue");
    
    if (($("#InvDefaulltFee").combogrid('getValue')==undefined)||($("#InvDefaulltFee").combogrid('getText')=="")){var str="";}
    
    if(str!="")
    {
        
        if (($("#InvDefaulltFee").combogrid('getValue'))==($("#InvDefaulltFee").combogrid('getText')))  {
            $.messager.alert("提示","体检费选择不正确!","info");
            return false;
        }
        
    }
    
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","InvDefaulltFee",str);
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","Group'sOEArcItemId",str);
    
    var str=getValueById("InvMaxListCount")
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","InvMaxListCount",str);
    
    
    var str=$("#InvListFlag").switchbox("getValue");
    if(str) str="1"
    else str="0"   
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","InvListFlag",str);
    
    
    
    var str=$("#RoundingFee").combogrid("getValue");
    
    if (($("#RoundingFee").combogrid('getValue')==undefined)||($("#RoundingFee").combogrid('getText')=="")){var str="";}
    
    if(str!="")
    {
        
        if (($("#RoundingFee").combogrid('getValue'))==($("#RoundingFee").combogrid('getText')))  {
            $.messager.alert("提示","凑整费选择不正确!","info");
            return false;
        }
        
    }
    
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","RoundingFee",str);
    
    var str=getValueById("ReportFTP")
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","ReportFTP",str);
    
    
    var str=$("#LisInterface").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","LisInterface",str);
    
    
    var str=getValueById("RoundManager")
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","RoundManager",str);
    
    
    var str=getValueById("PhotoFTP")
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","PhotoFTP",str);
    
    var str=$("#LisNewVersion").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","LisNewVersion",str);
    
    var str=getValueById("SuperGroup")
    
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
    
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","SuperGroup",str);
    
    
    var str=getValueById("LABDATA")
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","LABDATA",str);
    
    
    var str=getValueById("MEDDATA")
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","MEDDATA",str);
    
    var str=$("#LisReportMerge").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","LisReportMerge",str);
    
    var str=getValueById("FeeTypeSuperGroup")
    
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
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","FeeTypeSuperGroup",str);
    
    /*
    var str=$("#InsertOPInv").switchbox("getValue");
    if(str) str="Y"
    else str="N" 
    */
    var str="N"
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","InsertOPInv",str);
    
    var str=getValueById("StationId_Lab")
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","StationId_Lab",str);
    /*
    var str=$("#IsPrintBarNurseXML").switchbox("getValue");
    if(str) str="Y"
    else str="N"
    */
    var str="N"
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","IsPrintBarNurseXML",str);
    
    var str=$("#IsPrintEItem").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","IsPrintEItem",str);
    
    
    var str=$("#MainReportPrint").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","MainReportPrint",str);
    
    
    
    var AutoArrived=$("#StationId_Ris").combobox("getValues");
    
    var str=AutoArrived.join("^");
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","StationId_Ris",str);
    
    
    var str=$("#ShowEDDiagnosisSign").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","ShowEDDiagnosisSign",str);
    
    /*
    var str=$("#SendPisApplication").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","SendPisApplication",str);
    */

    var str=getValueById("StationId_Medical")
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","StationId_Medical",str);
    
    var str=$("#SendPisInterface").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","SendPisInterface",str);
    
    /*
    var str=$("#PrintPISTiaomaNew").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    
    var SendPisFBWay=$("#SendPisFBWay").combobox("getValue");
    if((SendPisFBWay=="F")&&(str=="N")){
        $.messager.alert("提示","病理申请方式为前台时，需启用新版病理条码","info");
        return false;
        
    }


    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","PrintPISTiaomaNew",str);
    */

    var str=getValueById("StationId_Other")
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","StationId_Other",str);
    
    
    var str=$("#InvPrintCatInfo").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","InvPrintCatInfo",str);
    
    var str=getValueById("InvDefaultPayMode")
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","InvDefaultPayMode",str);
    
    
    var str=getValueById("SendPisFBWay")
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","SendPisFBWay",str);
    
    /*
    var GRDiagnosisType=$("#GRDiagnosisType").combobox("getValues");
    var strarray=["N","N","N"]
    for(var i=0;i<GRDiagnosisType.length;i++)
    {
        if(GRDiagnosisType[i]=="1") strarray.splice(0,1,"Y")
        if(GRDiagnosisType[i]=="2") strarray.splice(1,1,"Y")
        if(GRDiagnosisType[i]=="3") strarray.splice(2,1,"Y")
    }
    var str=strarray.join("^");
    
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","GRDiagnosisType",str);
    */
    var AdmReason=$("#AdmReason").combobox("getValues");
    var str=AdmReason.join("^");
    tkMakeServerCall("web.DHCPE.HISUICommon","SetAdmReason",str);

    
    var CashierMode=$("#CashierMode").combobox("getValues");
    
    var str=CashierMode.join("^");
    tkMakeServerCall("web.DHCPE.HISUICommon","SetCashierPayMode",str);
    
    
    var ExtPayMode=$("#ExtPayMode").combobox("getValues");
    if(ExtPayMode!=""){
        var str=ExtPayMode.join("^");
        tkMakeServerCall("web.DHCPE.HISUICommon","SetExtPayMode",str);  
    }

    var str=$("#MHospital").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingAllLoc","MHospital",str);


    var ExtPayMode=$("#DHCScanCode").combobox("getValues");
    if(ExtPayMode!=""){
        var str=ExtPayMode.join("^");
        tkMakeServerCall("web.DHCPE.HISUICommon","SetDHCScanCode",str); 
    }
    
    var CardMode=$("#CardMode").combobox("getValues");
    
    var str=CardMode.join("^");
    tkMakeServerCall("web.DHCPE.HISUICommon","SetCardPayMode",str);
    
    var RefundMode=$("#RefundMode").combobox("getValues");
    
    var str=RefundMode.join("^");
    tkMakeServerCall("web.DHCPE.HISUICommon","SetRefundPayMode",str);

     var str=$("#PisNameSpace").combobox('getValue');
    tkMakeServerCall("web.DHCPE.HISUICommon","SetPisNameSpace",str);

    
    $.messager.alert("提示","设置成功!","success");
}

function SetByLoc(loc)
{
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
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"ReportCode");
    setValueById("ReportCode",ret)
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"AutoAuditUser");
    setValueById("AutoAuditUser",ret)
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"CashierSystem");
    setValueById("CashierSystem",ret)
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"PhyExamDrId");
    $('#PhyExamDrId').combogrid('grid').datagrid('reload',{'q':ret.split("^")[1]});
    setValueById("PhyExamDrId",ret.split("^")[0])
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"OrderInterfaceType");
    setValueById("OrderInterfaceType",ret)
    

    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"CallVoice");
    if(ret=="Y")    $("#CallVoice").switchbox("setValue",true);
    else    $("#CallVoice").switchbox("setValue",false)
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"CancelPEType");
    if(ret=="1")    $("#CancelPEType").switchbox("setValue",true);
    else    $("#CancelPEType").switchbox("setValue",false)
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"AllowCharge");
    if(ret=="1")    $("#AllowCharge").switchbox("setValue",true);
    else    $("#AllowCharge").switchbox("setValue",false);
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"MainDoctorGroup");
    if(ret=="Y")    $("#MainDoctorGroup").switchbox("setValue",true);
    else    $("#MainDoctorGroup").switchbox("setValue",false)
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"IsAddItem");
    if(ret=="Y") $("#IsAddItem").switchbox("setValue",true);
    else    $("#IsAddItem").switchbox("setValue",false)
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"IsPGetReportPT");
    if(ret=="Y") $("#IsPGetReportPT").switchbox("setValue",true);
    else    $("#IsPGetReportPT").switchbox("setValue",false)

    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"IfPrintMinusInv");
    if(ret=="Y") $("#IfPrintMinusInv").switchbox("setValue",true);
    else    $("#IfPrintMinusInv").switchbox("setValue",false)

    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"HPNo");
    if(ret!=""){var ret=ret.split("^")[1];}
    setValueById("HPNo",ret)
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"NetReport");
    if(ret=="Y")    $("#NetReport").switchbox("setValue",true);
    else    $("#NetReport").switchbox("setValue",false)

    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"NewVerReport");
    /*if(ret=="Y") $("#NewVerReport").switchbox("setValue",true);
    else    $("#NewVerReport").switchbox("setValue",false)*/
    setValueById("NewVerReport",ret)


    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"SendOrder");
    if(ret=="Y")    $("#SendOrder").switchbox("setValue",true);
    else    $("#SendOrder").switchbox("setValue",false)
    
    
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"AllowPrint");
    if(ret=="Y")    $("#AllowPrint").switchbox("setValue",true);
    else    $("#AllowPrint").switchbox("setValue",false)
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"OrderInterface");
    if(ret=="Y")    $("#OrderInterface").switchbox("setValue",true);
    else    $("#OrderInterface").switchbox("setValue",false)
    
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"NetPreLoc");
    if(ret=="Y")    $("#IfNetPre").switchbox("setValue",true);
    else    $("#IfNetPre").switchbox("setValue",false);
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"AutoNetRegister");
    if(ret=="Y")    $("#IfNetRegister").switchbox("setValue",true);
    else    $("#IfNetRegister").switchbox("setValue",false);
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"NetCancelPE");
    if(ret=="Y")    $("#IfNetCancelPE").switchbox("setValue",true);
    else    $("#IfNetCancelPE").switchbox("setValue",false);
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"PreSurvey");
    if(ret=="Y")    $("#IfPreSurvey").switchbox("setValue",true);
    else    $("#IfPreSurvey").switchbox("setValue",false);
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"RecommendItem");
    if(ret=="Y")    $("#IfRecommendItem").switchbox("setValue",true);
    else    $("#IfRecommendItem").switchbox("setValue",false);
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"TransResult");
    setValueById("TransResult",ret)
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"IsFeeLocFlag");
    if(ret=="Y") $("#IsFeeLocFlag").switchbox("setValue",true);
    else    $("#IsFeeLocFlag").switchbox("setValue",false);
    
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"CollectSpecOne");
    if(ret=="Y") $("#CollectSpecOne").switchbox("setValue",true);
    else    $("#CollectSpecOne").switchbox("setValue",false);
    
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"IsCardLocFlag");
    if(ret=="Y") $("#IsCardLocFlag").switchbox("setValue",true);
    else    $("#IsCardLocFlag").switchbox("setValue",false);

}

function SetDefault()
{
    var loc="999999"
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"InvCol");
    setValueById("InvCol",ret)
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"LABDATA");
    setValueById("LABDATA",ret)
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"MEDDATA");
    setValueById("MEDDATA",ret)
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"ReportFTP");
    setValueById("ReportFTP",ret)
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"PhotoFTP");
    setValueById("PhotoFTP",ret)
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"ItemAbridgeFlag");
    if(ret=="Y")    $("#ItemAbridgeFlag").switchbox("setValue",true);
    else    $("#ItemAbridgeFlag").switchbox("setValue",false)
    
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"CardRelate");
    if(ret=="Yes")  $("#CardRelate").switchbox("setValue",true);
    else    $("#CardRelate").switchbox("setValue",false);
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"InvDefaultPayMode");
    setValueById("InvDefaultPayMode",ret)
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"InvMaxListCount");
    setValueById("InvMaxListCount",ret)
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"InvPrintCatInfo");
    if(ret=="Y")    $("#InvPrintCatInfo").switchbox("setValue",true);
    else    $("#InvPrintCatInfo").switchbox("setValue",false);
    
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"MainReportPrint");
    if(ret=="Y")    $("#MainReportPrint").switchbox("setValue",true);
    else    $("#MainReportPrint").switchbox("setValue",false);
    
    /*
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"SendPisApplication");
    if(ret=="Y")    $("#SendPisApplication").switchbox("setValue",true);
    else    $("#SendPisApplication").switchbox("setValue",false);
    */
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"SendPisInterface");
    if(ret=="Y")    $("#SendPisInterface").switchbox("setValue",true);
    else    $("#SendPisInterface").switchbox("setValue",false);
    
    /*
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"PrintPISTiaomaNew");
    if(ret=="Y")    $("#PrintPISTiaomaNew").switchbox("setValue",true);
    else    $("#PrintPISTiaomaNew").switchbox("setValue",false)
    */
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"ShowEDDiagnosisSign");
    if(ret=="Y")    $("#ShowEDDiagnosisSign").switchbox("setValue",true);
    else    $("#ShowEDDiagnosisSign").switchbox("setValue",false)
    /*
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"IsPrintBarNurseXML");
    if(ret=="Y")    $("#IsPrintBarNurseXML").switchbox("setValue",true);
    else    $("#IsPrintBarNurseXML").switchbox("setValue",false)
    */
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"IsPrintEItem");
    if(ret=="Y")    $("#IsPrintEItem").switchbox("setValue",true);
    else    $("#IsPrintEItem").switchbox("setValue",false)

    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"InsertOPInv");
    //if(ret=="Y")  $("#InsertOPInv").switchbox("setValue",true);
    //else  $("#InsertOPInv").switchbox("setValue",false)
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"LisInterface");
    if(ret=="Y")    $("#LisInterface").switchbox("setValue",true);
    else    $("#LisInterface").switchbox("setValue",false)
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"LisNewVersion");
    if(ret=="Y")    $("#LisNewVersion").switchbox("setValue",true);
    else    $("#LisNewVersion").switchbox("setValue",false)
    
    
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"StationId_Lab");
    setValueById("StationId_Lab",ret)
    
    
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
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"StationId_Medical");
    setValueById("StationId_Medical",ret)
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"StationId_Other");
    setValueById("StationId_Other",ret)
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"SuperGroup");
    setValueById("SuperGroup",ret)
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"CardType");
    setValueById("CardType",ret)
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"InvListFlag");
    if(ret=="1")    $("#InvListFlag").switchbox("setValue",true);
    else    $("#InvListFlag").switchbox("setValue",false)
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"LisReportMerge");
    if(ret=="Y")    $("#LisReportMerge").switchbox("setValue",true);
    else    $("#LisReportMerge").switchbox("setValue",false)
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"TarOCIsNew");
    if(ret=="Y")    $("#TarOCIsNew").switchbox("setValue",true);
    else    $("#TarOCIsNew").switchbox("setValue",false)
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"GRDiagnosisType");
    var str=ret.split("^")
    var retarray=new Array();
    for(var i=0;i<str.length;i++)
    {
        if(str[i]=="Y")
        { 
            retarray.push(i+1);
            var checkid="GRDiagnosisType"+(i+1)
            $("#"+checkid).attr("checked",true);
        }
    }
    $("#GRDiagnosisType").combobox("setValues",retarray);
    
    
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"CanChangePayModes");
    var str=ret.split(",")
    var retarray=new Array();
    for(var i=0;i<str.length;i++)
    {
        retarray.push(str[i]);
        var checkid="CanChangePayModes"+str[i];
        $("#"+checkid).attr("checked",true);
    }
    $("#CanChangePayModes").combobox("setValues",retarray);
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetAdmReason");
    var str=ret.split("^")
    $("#AdmReason").combobox("setValues",str);


    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetCashierPayMode");
    var str=ret.split("^")
    
    $("#CashierMode").combobox("setValues",str);
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetExtPayMode");
    if(ret!=""){
        var str=ret.split("^")
        $("#ExtPayMode").combobox("setValues",str);
    }

    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"MHospital");
    if(ret=="Y") $("#MHospital").switchbox("setValue",true);
    else    $("#MHospital").switchbox("setValue",false)


    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetDHCScanCode");
    if(ret!=""){
        var str=ret.split("^")
        $("#DHCScanCode").combobox("setValues",str);
    }
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetCardPayMode");
    var str=ret.split("^")
    
    $("#CardMode").combobox("setValues",str);
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetRefundPayMode");
    var str=ret.split("^")
    
    $("#RefundMode").combobox("setValues",str);
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"RoundManager");
    setValueById("RoundManager",ret)
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"InvDefaulltFee");
    $('#InvDefaulltFee').combogrid('grid').datagrid('reload',{'q':"体检"});
    $("#InvDefaulltFee").combogrid("setValue",ret);
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"RoundingFee");
    $('#RoundingFee').combogrid('grid').datagrid('reload',{'q':"体检"});
    $("#RoundingFee").combogrid('setValue',ret);
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"SendPisFBWay");
    setValueById("SendPisFBWay",ret)
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"FeeTypeSuperGroup");
    setValueById("FeeTypeSuperGroup",ret)

    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetPisNameSpace");
    $("#PisNameSpace").combobox('setValue',ret);

    
}
    
$(init);