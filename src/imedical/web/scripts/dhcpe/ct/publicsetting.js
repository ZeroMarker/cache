
//名称    dhcpe/ct/publicsetting.js
//功能    体检基础配置
//创建    2021.08.15
//创建人  yupeng

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
    
    GetLocComp(SessionStr)    
        
    InitCombobox();
    
    InitPublicSettingGrid();
   
    //保存
    $("#BSave").click(function() {  
        BSave_click();      
        });
     
   //科室下拉列表change
    $("#LocList").combobox({
       onSelect:function(){  
            LocList_change();
            
        }
    })
      
    SetDefault();
   
})


function LocList_change(){
    
            var LocID=session['LOGON.CTLOCID']
            var LocListID=$("#LocList").combobox('getValue');
            if(LocListID!=""){var LocID=LocListID; }
            var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
          
            /*****************安全组重新加载(combobox)*****************/
            $('#SuperGroup').combobox('setValue','');
            var SuperGroupUrl=$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindFeeTypeSuperGroup&ResultSetType=array&hospId="+hospId;
            $('#SuperGroup').combobox('reload',SuperGroupUrl);
            /*****************安全组重新加载(combobox)*****************/

            /*****************检验站点重新加载(combobox)*****************/
            $('#StationId_Lab').combobox('setValue','');
            var LabStationUrl=$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindStationBase&ResultSetType=array&LocID="+LocID;
            $('#StationId_Lab').combobox('reload',LabStationUrl);
            /*****************检验站点重新加载(combobox)*****************/

            /*****************检查站点重新加载(combobox)*****************/
            $('#StationId_Ris').combobox('setValue','');
            var RisStationUrl=$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindStationBase&ResultSetType=array&LocID="+LocID;
            $('#StationId_Ris').combobox('reload',RisStationUrl);
            /*****************检查站点重新加载(combobox)*****************/

            /*****************药品站点重新加载(combobox)*****************/
            $('#StationId_Medical').combobox('setValue','');
            var MedicalStationUrl=$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindStationBase&ResultSetType=array&LocID="+LocID;
            $('#StationId_Medical').combobox('reload',MedicalStationUrl);
            /*****************药品站点重新加载(combobox)*****************/

            /*****************其他站点重新加载(combobox)*****************/
            $('#StationId_Other').combobox('setValue','');
            var OtherStationUrl=$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindStationBase&ResultSetType=array&LocID="+LocID;
            $('#StationId_Other').combobox('reload',OtherStationUrl);
            /*****************其他站点重新加载(combobox)*****************/
        
            /*****************体检费医嘱重新加载(combogrid)*****************/
            $('#InvDefaulltFee').combogrid('setValue','');
            $HUI.combogrid("#InvDefaulltFee",{
                onBeforeLoad:function(param){
                    param.Desc = param.q;
                    param.Type="B";
                    param.LocID=LocID;
                    param.hospId = hospId;

                }
            });
            
           $('#InvDefaulltFee').combogrid('grid').datagrid('reload'); 
           /*****************体检费医嘱重新加载(combogrid)*****************/
           
            /*****************凑整费医嘱重新加载(combogrid)*****************/
			$('#RoundingFee').combogrid('setValue','');
            $HUI.combogrid("#RoundingFee",{
                onBeforeLoad:function(param){
                    param.Desc = param.q;
                    param.Type="B";
                    param.LocID=LocID;
                    param.hospId=hospId;

                }
            });
            
           $('#RoundingFee').combogrid('grid').datagrid('reload'); 
           /*****************凑整费医嘱重新加载(combogrid)*****************/
        
            /*****************自动提交人重新加载(comboobox)*****************/
			$('#AutoAuditUser').combobox('setValue','');
            $HUI.combobox("#AutoAuditUser",{
                onBeforeLoad:function(param){
                    param.desc = param.q;
                    param.Type="B";
                    param.LocID=LocID;
                    param.hospId = hospId; 

                }
            });
            
           //$('#AutoAuditUser').combogrid('grid').datagrid('reload'); 
            var AutoAuditUserUrl=$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindUser&ResultSetType=array";
            $('#AutoAuditUser').combobox('reload',AutoAuditUserUrl);
           /*****************自动提交人重新加载(comboobox)*****************/
           
            /*****************默认体检医生重新加载(combogrid)*****************/
			$('#PhyExamDrId').combogrid('setValue','');
            $HUI.combogrid("#PhyExamDrId",{
                onBeforeLoad:function(param){
                        param.DocCode = param.q;
                        param.Type="B";
                        param.LocID=LocID;
                        param.hospId = hospId;

                }
            });
            
           $('#PhyExamDrId').combogrid('grid').datagrid('reload'); 
           /*****************默认体检医生重新加载(combogrid)*****************/
           
		   //知识库版本设置
		   $("#KBHospTagsCode").val('');
           
           $("#PublicSettingGrid").datagrid('load', {
                ClassName:"web.DHCPE.HISUICommon",
                QueryName:"FindPublicSettingNew",
                LocID:LocID,
                HospID:hospId
        
            });
            
            SetDefault();
}


function BSave_click()
{
    //科室
    var NowLoc=$("#LocList").combobox('getValue')
    if (($("#LocList").combobox('getValue')==undefined)||($("#LocList").combobox('getText')=="")){var NowLoc="";}
    if(NowLoc=="") 
    {
        $.messager.alert("提示","请选择需要设置的科室!","info");
        return;
    }
    
    if(NowLoc!="")
    {
        if (($("#LocList").combobox('getValue'))==($("#LocList").combobox('getText')))  {
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
    
	/*
    //体检卡跨科室使用
    var str=$("#IsCardLocFlag").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"IsCardLocFlag",str);
    */
    //体检卡跨科室使用
    var IsCardLoc=$("#IsCardLocFlag").combobox("getValues");
    var str=IsCardLoc.join("^");
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
  

     //医嘱预开
    /*
    var str=$("#PreOrder").switchbox("getValue");
    if(str) str="1"
    else str="0"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"PreOrder",str);
    */
    
   //回访
    var str=$("#ReturnVisit").switchbox("getValue");
    if(str) str="1"
    else str="0"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"ReturnVisit",str);
    
    //疾病项目
    var str=$("#IllItem").switchbox("getValue");
    if(str) str="1"
    else str="0"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"IllItem",str);


    
    //接收科室可跨院区
    var str=$("#RecLocHospital").switchbox("getValue");
    if(str) str="1"
    else str="0"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"RecLocHospital",str);
    
    //回传结果
    var str=$("#TransResult").combobox("getValue");
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"TransResult",str);
    
    //阳征提取建议
    var str=$("#PosAdvice").switchbox("getValue");
    if(str) str="1"
    else str="0"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"PosAdvice",str);
    
    //知识库版本代码(只存科室组默认科室)
    var str=$("#KBHospTagsCode").val();
	var LGLocID=tkMakeServerCall("web.DHCPE.CT.LocGrpConfig","GetLGLocIDByLoc",NowLoc);
	if (LGLocID){
		tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",LGLocID,"KBHospTagsCode",str);
	}
    
	//分诊
    var str=$("#ConsultingRoom").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"ConsultingRoom",str);

    $.messager.alert("提示","设置成功!","success");
    
    var LocID=session['LOGON.CTLOCID']
    var LocListID=$("#LocList").combobox('getValue');
    if(LocListID!=""){var LocID=LocListID; }
    var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
    
    $("#PublicSettingGrid").datagrid('load',{
            ClassName:"web.DHCPE.HISUICommon",
            QueryName:"FindPublicSettingNew",
            HospID:hospId,
            LocID:LocID
        }); 
			
   //导入检验细项
    var str=$("#ThirdPartyLIS").combobox('getValue');
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"ThirdPartyLIS",str);


}
function InitPublicSettingGrid()
{
    var LocID=session['LOGON.CTLOCID']
    var LocListID=$("#LocList").combobox('getValue');
    if(LocListID!=""){var LocID=LocListID; }
    var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
    
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
            HospID:hospId,
            LocID:LocID
        },
        columns:[[
        {field:'Loc',title:'Loc'},
        {field:'LocDesc',title:'科室'},
        {field:'InvDefaulltFee',title:'体检费医嘱'},
        {field:'InvDefaulltFeeAbr',title:'体检费医嘱缩写',hidden:true},
        {field:'RoundingFee',title:'凑整费医嘱'},
        {field:'RoundingFeeAbr',title:'凑整费医嘱缩写',hidden:true},
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
        {field:'PosAdvice',title:'阳征提取建议'},
        {field:'ReturnVisit',title:'体检回访'},
        {field:'RecLocHospital',title:'接收科室可跨院区'},
        {field:'KBHospTagsCode',title:'知识库版本代码'},
		{field:'ThirdPartyLIS',title:'导入检验细项'},
		{field:'TIllItem',title:'疾病项目'},
		{field:'ConsultingRoom',title:'分诊'},
        ]],
        onSelect: function (rowIndex, rowData) {
               
            var loc=rowData.Loc;
            var InvDefaulltFee=rowData.InvDefaulltFee;
            var LocDesc=rowData.LocDesc;
            //$('#NowLoc').combogrid('grid').datagrid('reload',{'q':LocDesc});
            setValueById("LocList",loc)
            SetPublicDataByLoc(rowData) 
                
                    
        }
        
            
    })

}
function SetPublicDataByLoc(rowData)
{
     var loc=rowData.Loc;
     var InvDefaulltFee=rowData.InvDefaulltFeeAbr;
     var RoundingFee=rowData.RoundingFeeAbr;
     var LocDesc=rowData.LocDesc;
    
    //体检费医嘱
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"InvDefaulltFee");
    $('#InvDefaulltFee').combogrid('grid').datagrid('reload',{'q':InvDefaulltFee});
    $("#InvDefaulltFee").combogrid("setValue",ret);
    
    //凑整费医嘱
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"RoundingFee");
    $('#RoundingFee').combogrid('grid').datagrid('reload',{'q':RoundingFee});
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
    if(ret=="Y")    $("#ItemAbridgeFlag").switchbox("setValue",true);
    else    $("#ItemAbridgeFlag").switchbox("setValue",false);
    
    //启用检验接口
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"LisInterface");
    if(ret=="Y")    $("#LisInterface").switchbox("setValue",true);
    else    $("#LisInterface").switchbox("setValue",false);
    
    //启用新版检验
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"LisNewVersion");
    if(ret=="Y")    $("#LisNewVersion").switchbox("setValue",true);
    else    $("#LisNewVersion").switchbox("setValue",false)
    
    //启用新版病理接口
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"SendPisInterface");
    if(ret=="Y")    $("#SendPisInterface").switchbox("setValue",true);
    else    $("#SendPisInterface").switchbox("setValue",false);
    
    //根据问卷推荐套餐
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"RecommendItem");
    if(ret=="Y")    $("#IfRecommendItem").switchbox("setValue",true);
    else    $("#IfRecommendItem").switchbox("setValue",false);
    
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
    if(ret=="Y")    $("#OrderInterface").switchbox("setValue",true);
    else    $("#OrderInterface").switchbox("setValue",false)
    
    
    //复审
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"MainDoctorGroup");
    if(ret=="Y")    $("#MainDoctorGroup").switchbox("setValue",true);
    else    $("#MainDoctorGroup").switchbox("setValue",false)
    
    //取消体检不删除未检
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"CancelPEType");
    if(ret=="1")    $("#CancelPEType").switchbox("setValue",true);
    else    $("#CancelPEType").switchbox("setValue",false)

    //年龄是否多院区
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"MHospital");
    if(ret=="Y") $("#MHospital").switchbox("setValue",true);
    else    $("#MHospital").switchbox("setValue",false)
    
    //启用叫号接口
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"CallVoice");
    if(ret=="Y")    $("#CallVoice").switchbox("setValue",true);
    else    $("#CallVoice").switchbox("setValue",false)
    
    //启用平台接口
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"SendOrder");
    if(ret=="Y")    $("#SendOrder").switchbox("setValue",true);
    else    $("#SendOrder").switchbox("setValue",false)
    
    //按科室计费
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"IsFeeLocFlag");
    if(ret=="Y") $("#IsFeeLocFlag").switchbox("setValue",true);
    else    $("#IsFeeLocFlag").switchbox("setValue",false);
    
    //体检卡跨科室使用
	/*
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"IsCardLocFlag");
    if(ret=="Y") $("#IsCardLocFlag").switchbox("setValue",true);
    else    $("#IsCardLocFlag").switchbox("setValue",false);
    */
    //体检卡跨科室使用
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"IsCardLocFlag");
    var str=ret.split("^")
    var retarray=new Array();
    for(var i=0;i<str.length;i++)
    {
        retarray.push(str[i]);
        var checkid="IsCardLocFlag"+str[i];
        $("#"+checkid).attr("checked",true);
    }
    $("#IsCardLocFlag").combobox("setValues",retarray);
    
    
    //网上预约
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"NetPreLoc");
    if(ret=="Y")    $("#IfNetPre").switchbox("setValue",true);
    else    $("#IfNetPre").switchbox("setValue",false);
    
    //网上预约自动登记
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"AutoNetRegister");
    if(ret=="Y")    $("#IfNetRegister").switchbox("setValue",true);
    else    $("#IfNetRegister").switchbox("setValue",false);
    
    //网上取消预约记录
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"NetCancelPE");
    if(ret=="Y")    $("#IfNetCancelPE").switchbox("setValue",true);
    else    $("#IfNetCancelPE").switchbox("setValue",false);
    
    //回传结果
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"TransResult");
    $("#TransResult").combobox("setValue",ret); 
    
   

     /*
    //医嘱预开
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"PreOrder");
    if(ret=="1")    $("#PreOrder").switchbox("setValue",true);
    else    $("#PreOrder").switchbox("setValue",false);
    */
    
    //回访
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"ReturnVisit");
    if(ret=="1") $("#ReturnVisit").switchbox("setValue",true);
    else    $("#ReturnVisit").switchbox("setValue",false);
    
    // 疾病项目
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"IllItem");
    if(ret=="1") $("#IllItem").switchbox("setValue",true);
    else    $("#IllItem").switchbox("setValue",false);
    

     //阳征建议
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"PosAdvice");
    if(ret=="1")    $("#PosAdvice").switchbox("setValue",true);
    else    $("#PosAdvice").switchbox("setValue",false);
    
    
     //接收科室可跨院区
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"RecLocHospital");
    if(ret=="1")    $("#RecLocHospital").switchbox("setValue",true);
    else    $("#RecLocHospital").switchbox("setValue",false);
    
    //知识库版本代码
	var LGLocID=tkMakeServerCall("web.DHCPE.CT.LocGrpConfig","GetLGLocIDByLoc",loc);
	if (LGLocID){
		var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",LGLocID,"KBHospTagsCode");
		$("#KBHospTagsCode").val(ret);
	} else {
		$("#KBHospTagsCode").val('');
	}

	//导入检验细项
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"ThirdPartyLIS");
    $("#ThirdPartyLIS").combobox("setValue",ret); 
    

	 //分诊
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"ConsultingRoom");
    if(ret=="Y")    $("#ConsultingRoom").switchbox("setValue",true);
    else    $("#ConsultingRoom").switchbox("setValue",false);

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
    
     var LocID=session['LOGON.CTLOCID']
     var LocListID=$("#LocList").combobox('getValue');
     if(LocListID!=""){var LocID=LocListID; }
     var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
      
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
            param.hospId = hospId;
        },
        
        columns:[[
            {field:'CTLOCID',hidden:true},
            {field:'CTLOCCODE',title:'科室编码',width:100},
            {field:'Desc',title:'科室名称',width:200}
            
            
            
        ]]
    });
    


    //安全组
    var SuperGroupObj = $HUI.combobox("#SuperGroup",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindFeeTypeSuperGroup&ResultSetType=array&hospId="+hospId,
        valueField:'id',
        textField:'desc',
       
        }); 
     
        
    //体检费医嘱     
    var InvDefaultFeeObj = $HUI.combogrid("#InvDefaulltFee",{
        panelWidth:470,
        url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=ArcItmmastListNew",
        mode:'remote',
        delay:200,
        pagination : true, 
        pageSize: 20,
        pageList : [20,50,100],
        idField:'STORD_ARCIM_DR',
        textField:'STORD_ARCIM_Desc',
        onBeforeLoad:function(param){
            param.Desc = param.q;
            param.Type="B";
            param.LocID=LocID;
            param.hospId = hospId;

        },
        columns:[[
            {field:'STORD_ARCIM_DR',hidden:true},
            {field:'STORD_ARCIM_Code',title:'医嘱编码',width:100},
            {field:'STORD_ARCIM_Desc',title:'医嘱名称',width:240}
            
            
            
        ]]
    });
    
    
    //凑整费医嘱
    var RoundingFeeObj = $HUI.combogrid("#RoundingFee",{
        panelWidth:470,
        url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=ArcItmmastListNew",
        mode:'remote',
        delay:200,
        pagination : true, 
        pageSize: 20,
        pageList : [20,50,100],
        idField:'STORD_ARCIM_DR',
        textField:'STORD_ARCIM_Desc',
        onBeforeLoad:function(param){
            param.Desc = param.q;
            param.Type="B";
            param.LocID=LocID;
            param.hospId=hospId;

        },
        columns:[[
            {field:'STORD_ARCIM_DR',hidden:true},
            {field:'STORD_ARCIM_Code',title:'医嘱编码',width:100},
            {field:'STORD_ARCIM_Desc',title:'医嘱名称',width:240}
            
            
            
        ]]
    });
    

    //检验站点
    var LabStationObj = $HUI.combobox("#StationId_Lab",{
        url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindStationBase&ResultSetType=array&LocID="+LocID,
        valueField:'id',
        textField:'desc'
        });
        
    //检查站点
    var StationIdRisObj = $HUI.combobox("#StationId_Ris",{
        url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindStationBase&ResultSetType=array&LocID="+LocID,
        valueField:'id',
        rowStyle:'checkbox',
        textField:'desc',multiple:true,selectOnNavigation:false,panelHeight:300,editable:false
    });

    
    //药品站点
    var MedicalStationObj = $HUI.combobox("#StationId_Medical",{
        url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindStationBase&ResultSetType=array&LocID="+LocID,
        valueField:'id',
        textField:'desc'
        });
        
    //其他站点  
    var OtherStationObj = $HUI.combobox("#StationId_Other",{
        url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindStationBase&ResultSetType=array&LocID="+LocID,
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
            param.LocID=LocID;
            param.hospId = hospId;
            
        }
    });
    
    //默认体检医生
    var PhyExamDrIdObj = $HUI.combogrid("#PhyExamDrId",{
        panelWidth:420,
        url:$URL+"?ClassName=web.DHCPE.Public.SettingEdit&QueryName=QueryDoctorID",
        mode:'remote',
        delay:200,
        pagination : true, 
        pageSize: 20,
        pageList : [20,50,100],
        idField:'DocRowID',
        textField:'DocName',
        onBeforeLoad:function(param){
            param.DocCode = param.q;
            param.Type="B";
            param.LocID=LocID;
            param.hospId = hospId;

        },
        columns:[[
            {field:'DocRowID',hidden:true},
            {field:'DocCode',title:'工号',width:100},
            {field:'DocName',title:'姓名',width:200}
            
        ]]
        });

    //体检卡跨科室使用
    var IsCardLocObj = $HUI.combobox("#IsCardLocFlag",{
        url:$URL+"?ClassName=web.DHCPE.CT.DHCPEMappingLoc&QueryName=GetLocDataForCombo&ResultSetType=array&SessionStr="+SessionStr,
        valueField:'LocRowId',
        rowStyle:'checkbox',
        textField:'LocDesc',multiple:true,selectOnNavigation:false,panelHeight:300,editable:false
    });
    
}