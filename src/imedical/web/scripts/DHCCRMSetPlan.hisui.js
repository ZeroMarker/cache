//名称    DHCCRMSetPlan.hisui.js
//功能    随访计划 HISUI
//创建    2020-11-23
//创建人  yupeng
function getDefStDate(space) {
    if (isNaN(space)) {
        space = -30;
    }
    var dateObj = new Date();
    dateObj.setDate(dateObj.getDate() + space);
    var myYear = dateObj.getFullYear();
    var myMonth = (dateObj.getMonth() + 1) < 10 ? "0" + (dateObj.getMonth() + 1) : (dateObj.getMonth() + 1);
    var myDay = (dateObj.getDate()) < 10 ? "0" + (dateObj.getDate()) : (dateObj.getDate());
    var dateStr = "";
    var sysDateFormat = $.m({
            ClassName: "websys.Conversions",
            MethodName: "DateFormat"
        }, false); //同步调用取系统配置日期格式
    if (sysDateFormat == 1) {
        dateStr = myMonth + '/' + myDay + '/' + myYear;
    } else if (sysDateFormat == 3) {
        dateStr = myYear + '-' + myMonth + '-' + myDay;
    } else {
        dateStr = myDay + '/' + myMonth + '/' + myYear;
    }

    return dateStr;
}

$(function(){
    
 
    var today = getDefStDate(0);
    //$('#BeginDate').datebox('setValue',today); 
    //$('#EndDate').datebox('setValue',today);         
    
    $('#TypeTab').tabs({
    
        onSelect:function(title,index){
            if(title=="门诊")
            {
                InitOPatientTabDataGrid();
                BFind();
                
            }
            if(title=="在院")
            {
                InitIPatientTabDataGrid();
                BFind();
                
            }
            if(title=="出院")
            {
                InitCPatientTabDataGrid();
    
                BFind();
            }
            if(title=="急诊留观")
            {
                InitEIPatientTabDataGrid();
                BFind();
                
            }
            if(title=="急诊非留观")
            {
                InitEOPatientTabDataGrid();
    
                BFind();
            }
        }
        
    });
    $('#TypeTab').tabs('select',"出院");
    //InitOPatientTabDataGrid();
    //InitCPatientTabDataGrid();
    //InitIPatientTabDataGrid();
    //InitEIPatientTabDataGrid();
    //InitEOPatientTabDataGrid();
    
    InitFUPlanTabDataGrid();
    
    $("#CreatePlan").click(function() {
            
            CreatePlan(); 
            
    });
    
    $("#QueryPlan").click(function() {
            
            QueryPlan(); 
            
    });
    
    $("#BFind").click(function() {
            
            BFind(); 
            
    });
    
    $("#RegNo").keydown(function(e) {
            
            if(e.keyCode==13){
                RegNoOnChange();
            }
            
        });
    
    var PatSexObj = $HUI.combobox("#PatSex",{
        url:$URL+"?ClassName=web.DHCCRM.GetBaseInfo&QueryName=FindSex&ResultSetType=array",
        valueField:'id',
        textField:'sex',
        onBeforeLoad: function (param) {
            
        }
    });
    
    var HospitalObj = $HUI.combobox("#Hospital",{
        url:$URL+"?ClassName=web.DHCCRM.GetBaseInfo&QueryName=FindHospital&ResultSetType=array",
        valueField:'id',
        textField:'desc',
        onBeforeLoad: function (param) {
            
        }
    });
    var fupersonObj = $HUI.combobox("#fuperson",{
        url:$URL+"?ClassName=web.DHCCRM.GetBaseInfo&QueryName=FindUser&ResultSetType=array",
        valueField:'id',
        textField:'name',
        mode:'remote',
        onBeforeLoad: function (param) {
            param.desc = param.q;
            
        }
    });
    var PatLocObj = $HUI.combobox("#PatLoc",{
        url:$URL+"?ClassName=web.DHCCRM.GetBaseInfo&QueryName=SearchCTLoc&ResultSetType=array",
        valueField:'CTLOC_RowId',
        textField:'CTLOC_Desc',
        mode:'remote',
        onBeforeLoad: function (param) {
            param.Desc = param.q;
            
        }
    });
    
    var DiagnosisObj = $HUI.combobox("#Diagnosis",{
        url:$URL+"?ClassName=web.DHCCRM.GetBaseInfo&QueryName=FindICD&ResultSetType=array",
        valueField:'id',
        textField:'name',
        mode:'remote',
        onBeforeLoad: function (param) {
            param.ICDDesc = param.q;
            
        }
    });
    
   var fusubjectObj = $HUI.combotree("#fusubject",{
        url:$URL+"?ClassName=web.DHCCRM.CRMBaseSet&MethodName=SearchFUSubject&subject=&showFlag=Parent&ResultSetType=array",
        checkbox:true,
        multiple:true,
        panelHeight:300,
        onCheck:function(node, checked){
            var parentNode = $(this).tree("getParent", node.target);  
            if (parentNode) {
                if (checked) {//当前为选中操作  
                    $(this).tree("check", parentNode.target);
                } else {
                    $(this).tree("uncheck", parentNode.target);
                }
            }
        }
    });
        
        
})
//计划列表
function InitFUPlanTabDataGrid()
{
    $HUI.datagrid("#FUPlanTab",{
        url : $URL,
        fit : true,
        border : false,
        fitColumns:true,
        rownumbers : true,
        pagination : true,  
        pageSize: 20,
        pageList : [20,100,200],
        displayMsg:"",//隐藏分页下面的文字"显示几页到几页,共多少条数据"
        singleSelect: true,
        selectOnCheck: true,
        queryParams:{
            ClassName:"web.DHCCRM.SetPlan",
            QueryName:"SearchFUPlan"
        },
        columns:[[
            {field:'FUPPAADM',title:'ID',width:50},
            {field:'PAPMINO',title:'登记号',width:100},
            {field:'PAPMIName',title:'姓名',width:100},
            {field:'FUPSubject',title:'随访主题',width:200}, 
            {field:'FUPFUDate',title:'随访日期',width:100},
            {field:'EndDate',title:'结束日期',width:100}, 
            {field:'FUPFUUserDR',title:'随访人',width:100}
                    
        ]],
        onSelect: function (rowIndex, rowData) {
          
                    
        }
        
            
    })
    
    
}

function RegNoOnChange()
{  
    BFind();
}

//门诊列表
function InitOPatientTabDataGrid()
{
    
    $HUI.datagrid("#OPatientTab",{
        url : $URL,
        fit : true,
        border : false,
        fitColumns:true,
        rownumbers : true,
        pagination : true,  
        pageSize: 20,
        pageList : [20,100,200],
        displayMsg:"",//隐藏分页下面的文字"显示几页到几页,共多少条数据"
        checkOnSelect: true,
        selectOnCheck: true,
        toolbar: [],
        queryParams:{
            ClassName:"web.DHCCRM.SetPlan",
            QueryName:"SearchMRBaseO"
        },
        columns:[[
            {field:'mradm',title:'ID',checkbox:true},
            {field:'mtype',title:'类型'},
            {field:'mrmrid',title:'就诊类型'},
            {field:'mRegno',title:'登记号'},
            {field:'mrname',title:'姓名'},
            {field:'mrgender',title:'性别'}, 
            {field:'mrage',title:'年龄'},
            {field:'mrtel',title:'电话'}, 
            {field:'mrcardid',title:'身份证号'}, 
            {field:'mradmdate',title:'就诊日期'}, 
            {field:'mrdisdate',title:'医生'},
            {field:'mrdisroom',title:'科室'},
            {field:'mrdisdiagname',title:'初步诊断'}
                    
        ]],
        onSelect: function (rowIndex, rowData) {
            var paadm=rowData.mradm
            var frm = parent.parent.parent.document.forms['fEPRMENU'];
            var frmEpisodeID = frm.EpisodeID;
            frmEpisodeID.value = paadm;
            var frmPatientID = frm.PatientID;
            frmPatientID.value = "";
                    
        }
        
            
    })

}
//出院列表
function InitCPatientTabDataGrid()
{
    
    $HUI.datagrid("#CPatientTab",{
        url : $URL,
        fit : true,
        border : false,
        fitColumns:true,
        rownumbers : true,
        pagination : true,  
        pageSize: 20,
        pageList : [20,100,200],
        displayMsg:"",//隐藏分页下面的文字"显示几页到几页,共多少条数据"
        checkOnSelect: true,
        selectOnCheck: true,
        toolbar: [],
        queryParams:{
            ClassName:"web.DHCCRM.SetPlan",
            QueryName:"SearchMRBase"
        },
        columns:[[
            {field:'mradm',title:'ID',checkbox:true},
            {field:'mtype',title:'类型'},
            {field:'mrmrid',title:'住院号'},
            {field:'mRegno',title:'登记号'},
            {field:'mrname',title:'姓名'},
            {field:'mrgender',title:'性别'}, 
            {field:'mrage',title:'年龄'},
            {field:'mrtel',title:'电话'}, 
            {field:'mrcardid',title:'身份证号'}, 
            {field:'mradmdate',title:'入院日期'}, 
            {field:'mrdisdate',title:'出院日期'}, 
            {field:'docname',title:'主治医师'},
            {field:'LocDesc',title:'出院科室'},
            {field:'mrdisroom',title:'出院病房(天数)'},
            {field:'mrdisdiagname',title:'出院诊断'},
            {field:'mraddress',title:'联系地址'}
                    
        ]],
        onSelect: function (rowIndex, rowData) {
           var paadm=rowData.mradm
            var frm = parent.parent.parent.document.forms['fEPRMENU'];
            var frmEpisodeID = frm.EpisodeID;
            frmEpisodeID.value = paadm;
            var frmPatientID = frm.PatientID;
            frmPatientID.value = "";
                    
        }
        
            
    })

}

//在院列表
function InitIPatientTabDataGrid()
{
    
    $HUI.datagrid("#IPatientTab",{
        url : $URL,
        fit : true,
        border : false,
        fitColumns:true,
        rownumbers : true,
        pagination : true,  
        pageSize: 20,
        pageList : [20,100,200],
        displayMsg:"",//隐藏分页下面的文字"显示几页到几页,共多少条数据"
        checkOnSelect: true,
        selectOnCheck: true,
        toolbar: [],
        queryParams:{
            ClassName:"web.DHCCRM.SetPlan",
            QueryName:"SearchMRBaseI"
        },
        columns:[[
            {field:'mradm',title:'ID',checkbox:true},
            {field:'mtype',title:'类型'},
            {field:'mrmrid',title:'住院号'},
            {field:'mRegno',title:'登记号'},
            {field:'mrname',title:'姓名'},
            {field:'mrgender',title:'性别'}, 
            {field:'mrage',title:'年龄'},
            {field:'mrtel',title:'电话'}, 
            {field:'mrcardid',title:'身份证号'}, 
            {field:'mradmdate',title:'入院日期'}, 
            {field:'docname',title:'主治医师'},
            {field:'mrdisroom',title:'科室'}, 
            {field:'mrdisdate',title:'病区'}, 
            {field:'mrdisdiagname',title:'床位'},
            {field:'mraddress',title:'联系地址'}
                    
        ]],
        onSelect: function (rowIndex, rowData) {
           var paadm=rowData.mradm
            var frm = parent.parent.parent.document.forms['fEPRMENU'];
            var frmEpisodeID = frm.EpisodeID;
            frmEpisodeID.value = paadm;
            var frmPatientID = frm.PatientID;
            frmPatientID.value = "";
                    
        }
        
            
    })

}

//急诊留观列表
function InitEIPatientTabDataGrid()
{
    
    $HUI.datagrid("#EIPatientTab",{
        url : $URL,
        fit : true,
        border : false,
        fitColumns:true,
        rownumbers : true,
        pagination : true,  
        pageSize: 20,
        pageList : [20,100,200],
        displayMsg:"",//隐藏分页下面的文字"显示几页到几页,共多少条数据"
        checkOnSelect: true,
        selectOnCheck: true,
        toolbar: [],
        queryParams:{
            ClassName:"web.DHCCRM.SetPlan",
            QueryName:"SearchMRBaseEI"
        },
        columns:[[
            {field:'mradm',title:'ID',checkbox:true},
            {field:'mtype',title:'类型'},
            {field:'mrmrid',title:'住院号'},
            {field:'mRegno',title:'登记号'},
            {field:'mrname',title:'姓名'},
            {field:'mrgender',title:'性别'}, 
            {field:'mrage',title:'年龄'},
            {field:'mrtel',title:'电话'}, 
            {field:'mrcardid',title:'身份证号'}, 
            {field:'mradmdate',title:'入院日期'}, 
            {field:'mrdisdate',title:'入院科室'},
            {field:'mrdisroom',title:'出院科室'},
            {field:'mrdisdiagname',title:'床位'}, 
            {field:'docname',title:'主治医生'}, 
            {field:'mraddress',title:'联系地址'}
                    
        ]],
        onSelect: function (rowIndex, rowData) {
          var paadm=rowData.mradm
            var frm = parent.parent.parent.document.forms['fEPRMENU'];
            var frmEpisodeID = frm.EpisodeID;
            frmEpisodeID.value = paadm;
            var frmPatientID = frm.PatientID;
            frmPatientID.value = "";
                    
        }
        
            
    })

}

//急诊非留观列表
function InitEOPatientTabDataGrid()
{
    
    $HUI.datagrid("#EOPatientTab",{
        url : $URL,
        fit : true,
        border : false,
        fitColumns:true,
        rownumbers : true,
        pagination : true,  
        pageSize: 20,
        pageList : [20,100,200],
        displayMsg:"",//隐藏分页下面的文字"显示几页到几页,共多少条数据"
        checkOnSelect: true,
        selectOnCheck: true,
        toolbar: [],
        queryParams:{
            ClassName:"web.DHCCRM.SetPlan",
            QueryName:"SearchMRBaseEO"
        },
        columns:[[
            {field:'mradm',title:'ID',checkbox:true},
            {field:'mtype',title:'类型'},
            {field:'mrmrid',title:'就诊类型'},
            {field:'mRegno',title:'登记号'},
            {field:'mrname',title:'姓名'},
            {field:'mrgender',title:'性别'}, 
            {field:'mrage',title:'年龄'},
            {field:'mrtel',title:'电话'}, 
            {field:'mrcardid',title:'身份证号'},
            {field:'mradmdate',title:'就诊日期'}, 
            {field:'mrdisdate',title:'医生'},
            {field:'mrdisroom',title:'科室'},
            {field:'mrdisdiagname',title:'初步诊断'}
                    
        ]],
        onSelect: function (rowIndex, rowData) {
          var paadm=rowData.mradm
            var frm = parent.parent.parent.document.forms['fEPRMENU'];
            var frmEpisodeID = frm.EpisodeID;
            frmEpisodeID.value = paadm;
            var frmPatientID = frm.PatientID;
            frmPatientID.value = "";
                    
        }
        
            
    })

}

//生成计划
function CreatePlan()
{
    var PAADMStr = "";
    var setab=$('#TypeTab').tabs('getSelected');
    
    var setabid=setab.panel('options').id;
    if(setabid=="OPatient")
    {
    var rows = $("#OPatientTab").datagrid("getChecked");//获取的是数组，多行数据
    if(rows.length==0){
        $.messager.alert("提示","请选择病人记录!","info");
        return false; 
    }
    
    for(var i=0;i<rows.length;i++){
        var PAADMRowID=rows[i].mradm;
          if (PAADMStr == "")
             PAADMStr = PAADMRowID
           else {
             PAADMStr = PAADMStr + "^" + PAADMRowID
           }
    }
        
    }
    
    if(setabid=="CPatient")
    {
    var rows = $("#CPatientTab").datagrid("getChecked");//获取的是数组，多行数据
    if(rows.length==0){
        $.messager.alert("提示","请选择病人记录!","info");
        return false; 
    }
    
    for(var i=0;i<rows.length;i++){
        var PAADMRowID=rows[i].mradm;
          if (PAADMStr == "")
             PAADMStr = PAADMRowID
           else {
             PAADMStr = PAADMStr + "^" + PAADMRowID
           }
    }
        
    }
    
    if(setabid=="IPatient")
    {
    var rows = $("#IPatientTab").datagrid("getChecked");//获取的是数组，多行数据
    if(rows.length==0){
        $.messager.alert("提示","请选择病人记录!","info");
        return false; 
    }
    
    for(var i=0;i<rows.length;i++){
        var PAADMRowID=rows[i].mradm;
          if (PAADMStr == "")
             PAADMStr = PAADMRowID
           else {
             PAADMStr = PAADMStr + "^" + PAADMRowID
           }
    }
        
    }
    
    if(setabid=="EOPatient")
    {
    var rows = $("#EOPatientTab").datagrid("getChecked");//获取的是数组，多行数据
    if(rows.length==0){
        $.messager.alert("提示","请选择病人记录!","info");
        return false; 
    }
    
    for(var i=0;i<rows.length;i++){
        var PAADMRowID=rows[i].mradm;
          if (PAADMStr == "")
             PAADMStr = PAADMRowID
           else {
             PAADMStr = PAADMStr + "^" + PAADMRowID
           }
    }
        
    }
    
    if(setabid=="EIPatient")
    {
    var rows = $("#EIPatientTab").datagrid("getChecked");//获取的是数组，多行数据
    if(rows.length==0){
        $.messager.alert("提示","请选择病人记录!","info");
        return false; 
    }
    
    for(var i=0;i<rows.length;i++){
        var PAADMRowID=rows[i].mradm;
          if (PAADMStr == "")
             PAADMStr = PAADMRowID
           else {
             PAADMStr = PAADMStr + "^" + PAADMRowID
           }
    }
        
    }
    
    var fuperson=getValueById("fuperson");
    
    var fusbDate=$("#fusbDate").datebox('getValue');
    var fusbEndDate=$("#fusbEndDate").datebox('getValue');
    var fusubject=$("#fusubject").combotree('getValues');
    if(fusubject==""){
        $.messager.alert("提示","请选择随访主题!","info");
        return false; 
    }
    var fusubjectstr=fusubject.join("^");
    var fudays=getValueById("fudays");
    var funums=getValueById("funums");
    
    var flag=tkMakeServerCall("web.DHCCRM.SetPlan","SetPlanHISUI",PAADMStr,fusubjectstr,fuperson,fusbDate,setabid,fusbEndDate,"",fudays,funums);
    if(flag==0){
            $.messager.popover({msg: '生成成功！',type:'success',timeout: 1000});
            $("#FUPlanTab").datagrid('load',{
                ClassName:"web.DHCCRM.SetPlan",
                QueryName:"SearchFUPlan",
                BeginDate:fusbDate,
                EndDate:fusbEndDate
            }); 
            
        }else{
            $.messager.alert('操作提示',"生成失败:"+flag,"error");
        }
    BFind();
}

function QueryPlan()
{
    
    var fusbDate=$("#fusbDate").datebox('getValue');
    var fusbEndDate=$("#fusbEndDate").datebox('getValue');
    var fuperson=getValueById("fuperson");
    var fusubject=$("#fusubject").combotree('getValues');
    $("#FUPlanTab").datagrid('load',{
         ClassName:"web.DHCCRM.SetPlan",
         QueryName:"SearchFUPlan",
         BeginDate:fusbDate,
         EndDate:fusbEndDate,
         fuperson:fuperson+"^"+fusubject
     }); 
}

function BFind()
{
    
    var CTLocID=session['LOGON.CTLOCID'];
    var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength",CTLocID);
    var RegNo= $("#RegNo").val();
    if (RegNo.length<RegNoLength && RegNo.length>0) { 
            RegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",RegNo,CTLocID);
            $("#RegNo").val(RegNo);
    }
    
    var PatName=getValueById("PatName");
    var PatSexID=getValueById("PatSex");
    var YuanQuID=getValueById("Hospital");
    var PatAgeFrom=getValueById("PatAgeL");
    var PatAgeTo=getValueById("PatAgeU");
    var BeginDate=getValueById("BeginDate");
    var EndDate=getValueById("EndDate");
    var LocID=getValueById("PatLoc");
    var ICD=getValueById("Diagnosis");
    var PatInDateL=getValueById("PatInDateL");
    var PatInDateU=getValueById("PatInDateU");
    var PatInDate=PatInDateL+"^"+PatInDateU;
    var PAADM="";
    var PatientType="";
    var FindCheck=$("#FindCheck").checkbox('getValue');
    
    var PatLocNum="";
    
    var setab=$('#TypeTab').tabs('getSelected');
    
    var setabid=setab.panel('options').id;
    if(setabid=="OPatient")
    {
        $("#OPatientTab").datagrid('load',{
                ClassName:"web.DHCCRM.SetPlan",
                QueryName:"SearchMRBaseO",
                BeginDate:BeginDate,
                EndDate:EndDate,
                LocID:LocID,
                ICD:ICD,
                RegNo:RegNo,
                PatName:PatName,
                PatSexID:PatSexID,
                PatAgeFrom:PatAgeFrom,
                PatAgeTo:PatAgeTo,
                PAADM:PAADM,
                PatientType:setabid,
                FindCheck:FindCheck,
                YuanQuID:YuanQuID,
                PatInDate:PatInDate,
                PatLocNum:PatLocNum
         }); 
        
    }
    if(setabid=="CPatient")
    {
        $("#CPatientTab").datagrid('load',{
                ClassName:"web.DHCCRM.SetPlan",
                QueryName:"SearchMRBase",
                BeginDate:BeginDate,
                EndDate:EndDate,
                LocID:LocID,
                ICD:ICD,
                RegNo:RegNo,
                PatName:PatName,
                PatSexID:PatSexID,
                PatAgeFrom:PatAgeFrom,
                PatAgeTo:PatAgeTo,
                PAADM:PAADM,
                PatientType:setabid,
                FindCheck:FindCheck,
                YuanQuID:YuanQuID,
                PatInDate:PatInDate,
                PatLocNum:PatLocNum
         }); 
        
    }
    if(setabid=="IPatient")
    {
        $("#IPatientTab").datagrid('load',{
                ClassName:"web.DHCCRM.SetPlan",
                QueryName:"SearchMRBaseI",
                BeginDate:BeginDate,
                EndDate:EndDate,
                LocID:LocID,
                ICD:ICD,
                RegNo:RegNo,
                PatName:PatName,
                PatSexID:PatSexID,
                PatAgeFrom:PatAgeFrom,
                PatAgeTo:PatAgeTo,
                PAADM:PAADM,
                PatientType:setabid,
                FindCheck:FindCheck,
                YuanQuID:YuanQuID,
                PatInDate:PatInDate,
                PatLocNum:PatLocNum
         }); 
        
    }
    if(setabid=="EOPatient")
    {
        $("#EOPatientTab").datagrid('load',{
                ClassName:"web.DHCCRM.SetPlan",
                QueryName:"SearchMRBaseEO",
                BeginDate:BeginDate,
                EndDate:EndDate,
                LocID:LocID,
                ICD:ICD,
                RegNo:RegNo,
                PatName:PatName,
                PatSexID:PatSexID,
                PatAgeFrom:PatAgeFrom,
                PatAgeTo:PatAgeTo,
                PAADM:PAADM,
                PatientType:setabid,
                FindCheck:FindCheck,
                YuanQuID:YuanQuID,
                PatInDate:PatInDate,
                PatLocNum:PatLocNum
         }); 
        
    }
    if(setabid=="EIPatient")
    {
        $("#EIPatientTab").datagrid('load',{
                ClassName:"web.DHCCRM.SetPlan",
                QueryName:"SearchMRBaseEI",
                BeginDate:BeginDate,
                EndDate:EndDate,
                LocID:LocID,
                ICD:ICD,
                RegNo:RegNo,
                PatName:PatName,
                PatSexID:PatSexID,
                PatAgeFrom:PatAgeFrom,
                PatAgeTo:PatAgeTo,
                PAADM:PAADM,
                PatientType:setabid,
                FindCheck:FindCheck,
                YuanQuID:YuanQuID,
                PatInDate:PatInDate,
                PatLocNum:PatLocNum
         }); 
        
    }
    
    
}