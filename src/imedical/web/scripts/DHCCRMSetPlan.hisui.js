//����    DHCCRMSetPlan.hisui.js
//����    ��üƻ� HISUI
//����    2020-11-23
//������  yupeng
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
        }, false); //ͬ������ȡϵͳ�������ڸ�ʽ
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
            if(title=="����")
            {
                InitOPatientTabDataGrid();
                BFind();
                
            }
            if(title=="��Ժ")
            {
                InitIPatientTabDataGrid();
                BFind();
                
            }
            if(title=="��Ժ")
            {
                InitCPatientTabDataGrid();
    
                BFind();
            }
            if(title=="��������")
            {
                InitEIPatientTabDataGrid();
                BFind();
                
            }
            if(title=="���������")
            {
                InitEOPatientTabDataGrid();
    
                BFind();
            }
        }
        
    });
    $('#TypeTab').tabs('select',"��Ժ");
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
                if (checked) {//��ǰΪѡ�в���  
                    $(this).tree("check", parentNode.target);
                } else {
                    $(this).tree("uncheck", parentNode.target);
                }
            }
        }
    });
        
        
})
//�ƻ��б�
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
        displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������"
        singleSelect: true,
        selectOnCheck: true,
        queryParams:{
            ClassName:"web.DHCCRM.SetPlan",
            QueryName:"SearchFUPlan"
        },
        columns:[[
            {field:'FUPPAADM',title:'ID',width:50},
            {field:'PAPMINO',title:'�ǼǺ�',width:100},
            {field:'PAPMIName',title:'����',width:100},
            {field:'FUPSubject',title:'�������',width:200}, 
            {field:'FUPFUDate',title:'�������',width:100},
            {field:'EndDate',title:'��������',width:100}, 
            {field:'FUPFUUserDR',title:'�����',width:100}
                    
        ]],
        onSelect: function (rowIndex, rowData) {
          
                    
        }
        
            
    })
    
    
}

function RegNoOnChange()
{  
    BFind();
}

//�����б�
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
        displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������"
        checkOnSelect: true,
        selectOnCheck: true,
        toolbar: [],
        queryParams:{
            ClassName:"web.DHCCRM.SetPlan",
            QueryName:"SearchMRBaseO"
        },
        columns:[[
            {field:'mradm',title:'ID',checkbox:true},
            {field:'mtype',title:'����'},
            {field:'mrmrid',title:'��������'},
            {field:'mRegno',title:'�ǼǺ�'},
            {field:'mrname',title:'����'},
            {field:'mrgender',title:'�Ա�'}, 
            {field:'mrage',title:'����'},
            {field:'mrtel',title:'�绰'}, 
            {field:'mrcardid',title:'���֤��'}, 
            {field:'mradmdate',title:'��������'}, 
            {field:'mrdisdate',title:'ҽ��'},
            {field:'mrdisroom',title:'����'},
            {field:'mrdisdiagname',title:'�������'}
                    
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
//��Ժ�б�
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
        displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������"
        checkOnSelect: true,
        selectOnCheck: true,
        toolbar: [],
        queryParams:{
            ClassName:"web.DHCCRM.SetPlan",
            QueryName:"SearchMRBase"
        },
        columns:[[
            {field:'mradm',title:'ID',checkbox:true},
            {field:'mtype',title:'����'},
            {field:'mrmrid',title:'סԺ��'},
            {field:'mRegno',title:'�ǼǺ�'},
            {field:'mrname',title:'����'},
            {field:'mrgender',title:'�Ա�'}, 
            {field:'mrage',title:'����'},
            {field:'mrtel',title:'�绰'}, 
            {field:'mrcardid',title:'���֤��'}, 
            {field:'mradmdate',title:'��Ժ����'}, 
            {field:'mrdisdate',title:'��Ժ����'}, 
            {field:'docname',title:'����ҽʦ'},
            {field:'LocDesc',title:'��Ժ����'},
            {field:'mrdisroom',title:'��Ժ����(����)'},
            {field:'mrdisdiagname',title:'��Ժ���'},
            {field:'mraddress',title:'��ϵ��ַ'}
                    
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

//��Ժ�б�
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
        displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������"
        checkOnSelect: true,
        selectOnCheck: true,
        toolbar: [],
        queryParams:{
            ClassName:"web.DHCCRM.SetPlan",
            QueryName:"SearchMRBaseI"
        },
        columns:[[
            {field:'mradm',title:'ID',checkbox:true},
            {field:'mtype',title:'����'},
            {field:'mrmrid',title:'סԺ��'},
            {field:'mRegno',title:'�ǼǺ�'},
            {field:'mrname',title:'����'},
            {field:'mrgender',title:'�Ա�'}, 
            {field:'mrage',title:'����'},
            {field:'mrtel',title:'�绰'}, 
            {field:'mrcardid',title:'���֤��'}, 
            {field:'mradmdate',title:'��Ժ����'}, 
            {field:'docname',title:'����ҽʦ'},
            {field:'mrdisroom',title:'����'}, 
            {field:'mrdisdate',title:'����'}, 
            {field:'mrdisdiagname',title:'��λ'},
            {field:'mraddress',title:'��ϵ��ַ'}
                    
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

//���������б�
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
        displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������"
        checkOnSelect: true,
        selectOnCheck: true,
        toolbar: [],
        queryParams:{
            ClassName:"web.DHCCRM.SetPlan",
            QueryName:"SearchMRBaseEI"
        },
        columns:[[
            {field:'mradm',title:'ID',checkbox:true},
            {field:'mtype',title:'����'},
            {field:'mrmrid',title:'סԺ��'},
            {field:'mRegno',title:'�ǼǺ�'},
            {field:'mrname',title:'����'},
            {field:'mrgender',title:'�Ա�'}, 
            {field:'mrage',title:'����'},
            {field:'mrtel',title:'�绰'}, 
            {field:'mrcardid',title:'���֤��'}, 
            {field:'mradmdate',title:'��Ժ����'}, 
            {field:'mrdisdate',title:'��Ժ����'},
            {field:'mrdisroom',title:'��Ժ����'},
            {field:'mrdisdiagname',title:'��λ'}, 
            {field:'docname',title:'����ҽ��'}, 
            {field:'mraddress',title:'��ϵ��ַ'}
                    
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

//����������б�
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
        displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������"
        checkOnSelect: true,
        selectOnCheck: true,
        toolbar: [],
        queryParams:{
            ClassName:"web.DHCCRM.SetPlan",
            QueryName:"SearchMRBaseEO"
        },
        columns:[[
            {field:'mradm',title:'ID',checkbox:true},
            {field:'mtype',title:'����'},
            {field:'mrmrid',title:'��������'},
            {field:'mRegno',title:'�ǼǺ�'},
            {field:'mrname',title:'����'},
            {field:'mrgender',title:'�Ա�'}, 
            {field:'mrage',title:'����'},
            {field:'mrtel',title:'�绰'}, 
            {field:'mrcardid',title:'���֤��'},
            {field:'mradmdate',title:'��������'}, 
            {field:'mrdisdate',title:'ҽ��'},
            {field:'mrdisroom',title:'����'},
            {field:'mrdisdiagname',title:'�������'}
                    
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

//���ɼƻ�
function CreatePlan()
{
    var PAADMStr = "";
    var setab=$('#TypeTab').tabs('getSelected');
    
    var setabid=setab.panel('options').id;
    if(setabid=="OPatient")
    {
    var rows = $("#OPatientTab").datagrid("getChecked");//��ȡ�������飬��������
    if(rows.length==0){
        $.messager.alert("��ʾ","��ѡ���˼�¼!","info");
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
    var rows = $("#CPatientTab").datagrid("getChecked");//��ȡ�������飬��������
    if(rows.length==0){
        $.messager.alert("��ʾ","��ѡ���˼�¼!","info");
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
    var rows = $("#IPatientTab").datagrid("getChecked");//��ȡ�������飬��������
    if(rows.length==0){
        $.messager.alert("��ʾ","��ѡ���˼�¼!","info");
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
    var rows = $("#EOPatientTab").datagrid("getChecked");//��ȡ�������飬��������
    if(rows.length==0){
        $.messager.alert("��ʾ","��ѡ���˼�¼!","info");
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
    var rows = $("#EIPatientTab").datagrid("getChecked");//��ȡ�������飬��������
    if(rows.length==0){
        $.messager.alert("��ʾ","��ѡ���˼�¼!","info");
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
        $.messager.alert("��ʾ","��ѡ���������!","info");
        return false; 
    }
    var fusubjectstr=fusubject.join("^");
    var fudays=getValueById("fudays");
    var funums=getValueById("funums");
    
    var flag=tkMakeServerCall("web.DHCCRM.SetPlan","SetPlanHISUI",PAADMStr,fusubjectstr,fuperson,fusbDate,setabid,fusbEndDate,"",fudays,funums);
    if(flag==0){
            $.messager.popover({msg: '���ɳɹ���',type:'success',timeout: 1000});
            $("#FUPlanTab").datagrid('load',{
                ClassName:"web.DHCCRM.SetPlan",
                QueryName:"SearchFUPlan",
                BeginDate:fusbDate,
                EndDate:fusbEndDate
            }); 
            
        }else{
            $.messager.alert('������ʾ',"����ʧ��:"+flag,"error");
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