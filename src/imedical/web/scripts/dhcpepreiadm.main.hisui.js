 
//����    dhcpepreiadm.main.hisui.js
//����    ����ԤԼ
//��������  
//������  yp

var gUserId=session['LOGON.USERID'];
var myCombAry=new Array(); 

var editIndex=undefined;
var NowRow="";
/*
$.extend($.fn.datagrid.methods, {
            editCell: function(jq,param){
                return jq.each(function(){
                    var opts = $(this).datagrid('options');
                    var fields = $(this).datagrid('getColumnFields',true).concat($(this).datagrid('getColumnFields'));
                    for(var i=0; i<fields.length; i++){
                        var col = $(this).datagrid('getColumnOption', fields[i]);
                        col.editor1 = col.editor;
                        if (fields[i] != param.field){
                            col.editor = null;
                        }
                    }
                    $(this).datagrid('beginEdit', param.index);
                    for(var i=0; i<fields.length; i++){
                        var col = $(this).datagrid('getColumnOption', fields[i]);
                        col.editor = col.editor1;
                    }
                });
            }
});
*/

$.extend($.fn.validatebox.defaults.rules, {
        mobile : {// ��֤�ֻ�����
        validator : function(value) {
            return /^(13|15|17|18)\d{9}$/i.test(value);
        },
            message : '�ֻ������ʽ����ȷ'
        }
        })
var openSetWin = function(SetId){
    
    $HUI.window("#SetWin",{
        title:"��Ŀ��Ϣ�б�",
        minimizable:false,
        collapsible:false,
        modal:true,
        width:600,
        height:400
    });
    
    var QryLisObj = $HUI.datagrid("#QrySetWin",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCPE.Query.PreItemList",
            QueryName:"QueryPreItemList",
            AdmId:SetId,
            AdmType:"Ord"

        },
        columns:[[
            {field:'ItemDesc',width:'220',title:'��Ŀ����'},
            {field:'ItemSetDesc',width:'240',title:'�ײ�'},
            {field:'TAccountAmount',width:'100',title:'Ӧ�ս��',align:'right'}
        ]],
        pagination:true,
        displayMsg:"",
        pageSize:20,
        fit:true
    
        })
    
    
};
function DeleteItemFromSet(value)
{
    var OrdItemID=value.split("^")[0];
    var ItemStat=value.split("^")[1];
    var AdmID=OrdItemID.split("||");
    var ordEntId=value.split("^")[2];
    
    AdmID=AdmID[0];
    OrdSetID=""
    if(ItemStat!=1)
    {
        $.messager.alert("��ʾ","��Ŀ״̬������ɾ��!","info");
        return false;
        
    }
    
    var flag=tkMakeServerCall("web.DHCPE.PreItemList","IDeleteItem",AdmID,AdmType,OrdItemID,OrdSetID,"0"); 
    flag=flag.split("^")[0];
    if (flag==1)
    {
        $.messager.alert("��ʾ","�Ѿ��շѲ���ɾ��!","info");
        return false;
    }
    if (flag==2)
    {
        $.messager.alert("��ʾ","�Ѿ��ܼ���˲���ɾ��!","info");
        return false;
    }
    if (flag==3)
    {
        $.messager.alert("��ʾ","��Ŀ��ִ�в���ɾ��!","info");
        return false;
    }
    if (flag==6)
    {
        $.messager.alert("��ʾ","�ѷ�ҩ����ɾ��!","info");
        return false;
    }
    if (flag==7)
    {
        $.messager.alert("��ʾ","ɾ���ײ�����Ŀʣ���ײ��ܼ���Ҫ������!","info");
        return false;
    }
    if (flag==8)
    {
        $.messager.alert("��ʾ","�����ڷ�����ɾ�������ײ�����Ŀ,��ѡ����Ա����!","info");
        return false;
    }
    $("#QrySetWin").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:ordEntId,AdmType:AdmType+"Ord"}); 
    
    
    
    $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:$("#PIADM_RowId").val(),AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""}); 
        var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetOrdAmountHISUI",$("#PIADM_RowId").val(),AdmType);
        var myDiv=document.getElementById("TotalFee");
        myDiv.innerText=TotalAmount;
        
    
}

var UpdateSetWin = function(value)
{
        
    var ordItemId=value.split("^")[0];
        
    var ordEntId=value.split("^")[1];
    
    $HUI.window("#SetWin",{
        title:"�ײ���Ŀ��Ϣ�б�",
        minimizable:false,
        collapsible:false,
        modal:true,
        width:980,
        height:600
    });
    
    var QryLisObj = $HUI.datagrid("#QrySetWin",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCPE.Query.PreItemList",
            QueryName:"QueryPreItemList",
            AdmId:ordEntId,
            AdmType:AdmType+"Ord"

        },
        columns:[[
        
            {field:'TItemId',title:'����',
                formatter:function(value,row,index){
                    return "<a href='#' onclick='DeleteItemFromSet(\""+row.RowId+"^"+row.TItemStat+"^"+ordEntId+"\")'>\
                    <img style='padding-left:7px;' title='ɾ����Ŀ' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>\
                    </a>";
                }},
            
            {field:'ItemDesc',width:'200',title:'��Ŀ����'},
            {field:'ItemSetDesc',width:'200',title:'�ײ�'},
            {field:'TAccountAmount',width:'100',title:'Ӧ�ս��',align:'right'},
            {field:'TSpecName',width:'140',title:'����'},
            {field:'TAddUser',width:'140',title:'����Ա'},
            {field:'TPreOrAdd',width:'140',title:'��Ŀ���'},
            {field:'TRecLocDesc',width:'140',title:'���տ���'}
        ]],
        pagination:true,
        displayMsg:"",
        pageSize:20,
        fit:true
    
        })
    
    
};




var openOccuWin = function(PreIADM){
    
    $HUI.window("#OccuWin",{
        title:"Σ������",
        collapsible:false,
        minimizable:false,
        maximizable:false,
        modal:true,
        width:600,
        height:400
    });
    
    var QryLisObj = $HUI.datagrid("#QryOccuWin",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCPE.OccupationalDisease",
            QueryName:"SerchEndangerItem",
            PreIADM:PreIADM

        },
        fitColumns:true,
        toolbar:[{
            iconCls:'icon-save',
            text:'����',
            handler: function(){
                var selectrow = $("#QryOccuWin").datagrid("getChecked");//��ȡ�������飬��������
    
                for(var i=0;i<selectrow.length;i++){
                    if(selectrow[i].SetsFlag=="Y")
                    {
                        var ItemID=""
                        var SetsID=selectrow[i].ArcimID
                        
                    }
                    else
                    {
                        var ItemID=selectrow[i].ArcimID
                        var SetsID=""
                        
                    }
                    
                    var UserID=session['LOGON.USERID'];
                    var flag=tkMakeServerCall("web.DHCPE.PreItemList","IInsertItem",PreIADM, "PERSON",PreOrAdd,ItemID, SetsID,UserID); 
                    
                    
                    
                    
                    if (flag=="Notice"){
                        $.messager.alert("��ʾ","�����,���˼�����ȡ�����!"+(i+1),"info");
                        return false;
                    }
                    if (flag!="") {
                        $.messager.alert("��ʾ","�������:"+flag,"info");
                        return false;
                    }
                    $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:PreIADM,AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""}); 
                    $('#OccuWin').window('close'); 
                    
                }
                
            }
        }],
        checkOnSelect:true,
        selectOnCheck:true,
        columns:[[
            {field:'NeedFlag',checkbox:true},
            {field:'ItemFlag',hidden:true},
            {field:'SetsFlag',hidden:true},
            {field:'ArcimID',hidden:true},
            {field:'ArcimCode',title:'��Ŀ����'},
            {field:'ArcimDesc',title:'��Ŀ����'},
            {field:'EndangerDesc',title:'��ӦΣ������'}
            
        ]],
        pagination:true,
        displayMsg:"",
        pageSize:20,
        fit:true,
        onLoadSuccess: function (data) {
            if (data) {
                $.each(data.rows, function (index, rowdata) {
                    if (rowdata.NeedFlag == "Y") {
                        $('#QryOccuWin').datagrid('checkRow', index);
                        //$("input[type='checkbox']")[i + 2].disabled = true;
                    } else {
                        $('#QryOccuWin').datagrid('uncheckRow', index);
                    }
                });
            }
        }
    
    });
};


var openNameWin = function(desc){
    
    var NameWinObj=$HUI.window("#NameWin",{
        title:"��Ϣ�б�",
        collapsible:false,
        modal:true,
        minimizable:false,
        maximizable:false,
        width:800,
        height:400
    });
    
    var QryLisObj = $HUI.datagrid("#QryNameWin",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCPE.PreIBaseInfo",
            QueryName:"SearchPreIBaseInfo",
            PatName:desc

        },
        columns:[[
            {field:'PIBI_RowId',hidden:true},
            {field:'PIBI_PAPMINo',width:'100',title:'�ǼǺ�'},
            {field:'PIBI_Name',width:'80',title:'����'},
            {field:'PIBI_Sex_DR_Name',width:'60',title:'�Ա�'},
            {field:'PIBI_DOB',width:'100',title:'��������'},
            {field:'PIBI_Married_DR_Name',width:'70',title:'����״��'},
            {field:'PIBI_MobilePhone',width:'110',title:'�绰����'},
            {field:'PIBI_IDCard',width:'150',title:'���֤��'}
            
        ]],
        onDblClickRow:function(rowIndex,rowData){
            var pibi=rowData.PIBI_PAPMINo;
            $('#PAPMINo').val(pibi);
            RegNoOnChange();
            NameWinObj.close();
        },
        pagination:true,
        displayMsg:"",
        pageSize:20,
        fit:true
    
        })
    
    
};
var init = function(){
    
        $(window).bind('beforeunload', function(){ 
        
           if(AdmType=="TEAM"){var gteam=PreAdmId;}
           if(AdmType=="PERSON"){var gteam=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetGTeamByIADM",PreAdmId);}
            window.opener.$("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:gteam,RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
        });
        
        LoadCard();
        
        if(!AdmType) AdmType="PERSON"
        if(!PreOrAdd) PreOrAdd="PRE"
        
        
        var Status=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetPIADMStatus",PreAdmId,AdmType);
        if((AdmType!="PERSON")||((Status!="PREREG")&&(Status!="PREREGED")&&(Status!=""))){
                
                $("#BRegister").hide();
        }
        
        $('#ZYBTab').tabs('disableTab',"������Ϣ");
        $('#ZYBTab').tabs('disableTab',"ְҵʷ");
        $('#ZYBTab').tabs('disableTab',"��ʷ");
        $('#ZYBTab').tabs('disableTab',"ְҵ��ʷ");
        $('#ZYBTab').tabs('select',"�����Ŀ");
        
        $('#ZYBTabItem').tabs('disableTab',"������Ϣ");
        $('#ZYBTabItem').tabs('disableTab',"ְҵʷ");
        $('#ZYBTabItem').tabs('disableTab',"��ʷ");
        $('#ZYBTabItem').tabs('disableTab',"ְҵ��ʷ");
        $('#ZYBTabItem').tabs('select',"�����Ŀ");
        $('#BEndanger').linkbutton('disable');
        
        var myobj=document.getElementById("ReadRegInfo");
        if (myobj)
        { 
        myobj.onclick=ReadRegInfo_OnClick;       
        }
        
        var obj=document.getElementById('ReadCard');
        if (obj) obj.onclick=ReadCardClickHandler;
        
        $("#PAPMINo").val(PAPMINo);
        $("#AdmType").val(AdmType);
        
        
        $("#BSaveAmount").click(function() {
            
            BSaveAmount_click();    
            
        });
        
        $("#BPreDate").click(function() {
            
            BPreDate_click();   
            
        });
        
        $("#PAPMINo").change(function(){
            //RegNoOnChange();
        });
        
        $("#PAPMINo").keydown(function(e) {
            
            if(e.keyCode==13){
                RegNoOnChange();
            }
            
        });
        
        $("#OpenCharge").checkbox({
        
        
            onCheckChange:function(e,value){
            
                OpenCharge_change(value);
            
        }
        });       
        
        $("#IFeeAsCharged").checkbox({
        
            onCheckChange:function(e,value){
                IFeeAsCharged_change(value)
                            
            }
        });
    
        $("#Age").change(function(){
            
            AgeOnChange();
        });
        
    
        
        $("#CardNo").change(function(){
            //CardNoOnChange();
        });
        
        /*
        $("#CardNo").keydown(function(e) {
            
            if(e.keyCode==13){
                CardNoOnChange();
            }
            
        });
        */
        
        $("#IDCard").change(function(){
            //IDCardOnChange();
        });
        
        /*
        $("#IDCard").keydown(function(e) {
            
            if(e.keyCode==13){
                IDCardOnChange();
            }
            
        });
        */
        
        $("#BPhoto").click(function() {
            
            BPhoto_click(); 
            
        });
        $("#Update").click(function() {
            
            Save(); 
            
        });
        $("#ConfirmOrdItem").click(function() {
            
            ConfirmOrdItem_Click(); 
            
        });
        
        
        // Σ������
        $("#BEndanger").click(function() {
            BEndanger_Click();
            
        });
        // ������Ϣ
        $("#JBSave").click(function() {
            JBSave();
        });
        $("#JBNext").click(function() {
            JBNext();
        });
        // ְҵʷ
        $("#ZYSave").click(function() {
            ZYSave();
        });
        $("#ZYDelete").click(function() {
            ZYDelete();
        });
        $("#ZYCancel").click(function() {
            ZYCancel();
        });
        $("#ZYNext").click(function() {
            ZYNext();
        });
        // ��ʷ
        $("#BSSave").click(function() {
            BSSave();
        });
        $("#BSNext").click(function() {
            BSNext();
        });
        // ְҵ��ʷ
        $("#ZYBSave").click(function() {
            ZYBSave();
        });
        $("#ZYBDelete").click(function() {
            ZYBDelete();
        });
        $("#ZYBCancel").click(function() {
            ZYBCancel();
        });
        $("#ZYBNext").click(function() {
            ZYBNext();
        });
        

        $("#BRegister").click(function() {
            
            Register(); 
            
        });
        
        
        
        $("#BClear").click(function() {
            
            Clear_click();
            
        });

         //ɾ����Ŀ
        $("#DeleteOrdItem").click(function() {
            DeleteOrdItem_Click(); 
        });

        //���������ĸͬ�������������Ŀ
        $('#Set').on/*bind*/("input propertychange", function () {
                    SetBFind_click();
                });

        $('#Item').on/*bind*/("input propertychange", function () {
            
                    RisBFind_click();
                });

        $('#LisItem').on/*bind*/("input propertychange", function () {
                    LisBFind_click();
                });


        $("#SetBFind").click(function() {
            SetBFind_click();   
        });
        

        $("#Set").keydown(function(e) {
            
            if(e.keyCode==13){
                SetBFind_click();
                }
        });
        
        $("#Name").keydown(function(e) {
            
            if(e.keyCode==13){
                Name_keydown();
                }
        });
        $("#RisBFind").click(function() {
            RisBFind_click();
            
        });
        
        $("#Item").keydown(function(e) {
            
            if(e.keyCode==13){
                RisBFind_click();
                }
        });
        
        
        $("#LisBFind").click(function() {
            LisBFind_click();
            
        });
        
        $("#LisItem").keydown(function(e) {
            
            if(e.keyCode==13){
                LisBFind_click();
                }
        });
        
        $("#OtherBFind").click(function() {
            OtherBFind_click();
            
        });
        
        $("#OtherItem").keydown(function(e) {
            
            if(e.keyCode==13){
                OtherBFind_click();
                }
        });
        
        
        $("#MedicalBFind").click(function() {
            MedicalBFind_click();
            
        });
        
        $("#MedicalItem").keydown(function(e) {
            
            if(e.keyCode==13){
                MedicalBFind_click();
                }
        });
        
        $("#LisTab").tabs({
            toolPosition:"right",
            border:1,
            tools:[{
            iconCls:'icon-arrow-left',
            handler:function(){
                $('#TPanel').layout('collapse','west');
                 $('#PreItemList').datagrid({
                    fitColumns:true
                });
            }
            }]
        });
        
        $('#LisTab').tabs({
            border:1,
            onSelect:function(title){
                $("#QryOtherItm").datagrid('resize'); 
                $("#QryMedicalItm").datagrid('resize'); 
            }
        });
        
        $('#ItemLisTab').tabs({
            border:1,
            onSelect:function(title){
                $("#QryOtherItm").datagrid('resize'); 
                $("#QryMedicalItm").datagrid('resize'); 
            }
        });
        
        var AlcolHisObj = $HUI.combobox("#AlcolHis", {
            valueField:'id',
            textField:'text',
            selectOnNavigation:false,
            panelHeight:"auto",
            editable:false,
            data:[{id:'������',text:'������'},{id:'ż����',text:'ż����'},{id:'����',text:'������'}],
            onSelect: function(record) {
                if (record.id == "������") {
                    $('#AlcolNo').numberbox("setValue","");
                    $('#AlcolNo').attr("disabled",true);
                    $('#Alcol').numberbox("setValue","");
                    $('#Alcol').attr("disabled",true);
                } else {
                    $('#AlcolNo').attr("disabled",false);
                    $('#Alcol').attr("disabled",false);
                }
            }
        });
        
        var SmokeHisObj = $HUI.combobox("#SmokeHis", {
            valueField:'id',
            textField:'text',
            selectOnNavigation:false,
            panelHeight:"auto",
            editable:false,
            data:[{id:'������',text:'������'},{id:'ż����',text:'ż����'},{id:'����',text:'������'}],
            onSelect:function(record){
                if (record.id == "������") {
                    $('#SmokeNo').numberbox("setValue","");
                    $('#SmokeNo').attr("disabled",true);
                    $('#SmokeAge').numberbox("setValue","");
                    $('#SmokeAge').attr("disabled",true);
                } else {
                    $('#SmokeNo').attr("disabled",false);
                    $('#SmokeAge').attr("disabled",false);
                }
            }
        });
        
        
        var HarmInfoObj = $HUI.combotree("#HarmInfo",{
            url:$URL+"?ClassName=web.DHCPE.HISUICommon&MethodName=GetHarmInfo&ResultSetType=array",
            checkbox:true,
            multiple:true,
            onlyLeafCheck:true
            
        });
        
        var ZYHistoryObj = $HUI.datagrid("#ZYHistory", {
            url:$URL,
            queryParams:{
                ClassName:"web.DHCPE.OccupationalDisease",
                QueryName:"FindOccuHistory",
                PreIADM:""
            },
            pagination:true,
            displayMsg:"",
            pageSize:20,
            fit:true,
            fitColumns:true,
            columns:[[
                {field:'TStartDate',width:'100',title:'��ʼ����'},
                {field:'TEndDate',width:'100',title:'��������'},
                {field:'TWorkPlace',width:'250',title:'������λ'},
                {field:'TWorkDepartment',width:'150',title:'����'},
                {field:'TWorkShop',width:'100',title:'����'},
                {field:'TWorkTeam',width:'100',title:'����'},
                {field:'TWorkType',width:'150',title:'����'},
                {field:'TDailyWorkHours',width:'120',title:'ÿ�չ�ʱ��'},
                {field:'THarmfulFactor',width:'200',title:'�Ӵ�Σ��'},
                {field:'TProtectiveMeasure',width:'100',title:'������ʩ'},
                {field:'TWorkTypeID',hidden:true,title:'����id'},
                {field:'TProtectiveMeasureID',hidden:true,title:'����id'}
            ]],
            onClickRow:function(rowIndex,rowData) {
                setValueById("StartDate",rowData.TStartDate);
                setValueById("EndDate",rowData.TEndDate);
                setValueById("WorkPlace",rowData.TWorkPlace);
                setValueById("WorkDepartment",rowData.TWorkDepartment);
                setValueById("WorkShop",rowData.TWorkShop);
                setValueById("ZYTypeofwork",rowData.TWorkTypeID);
                setValueById("DailyWorkHours",rowData.TDailyWorkHours);
                setValueById("HarmfulFactor",rowData.THarmfulFactor);
                setValueById("ProtectiveMeasure",rowData.TProtectiveMeasureID);
                setValueById("WorkTeam",rowData.TWorkTeam);
            }
        });
        
        var ZYBHistoryObj = $HUI.datagrid("#ZYBHistory",{
            url:$URL,
            queryParams:{
                ClassName:"web.DHCPE.OccupationalDisease",
                QueryName:"FindOccuDiseaseHistory",
                PreIADM:""
            },
            pagination:true,
            displayMsg:"",
            pageSize:20,
            fit:true,
            fitColumns:true,
            columns:[[
                {field:'TDiseaseDesc',width:'200',title:'����'},
                {field:'TDiagnosisDate',width:'100',title:'�������'},
                {field:'TDiagnosisPlace',width:'250',title:'��ϵ�λ'},
                {field:'TProcess',width:'300',title:'���ƾ���'},
                {field:'TReturn',width:'200',title:'��ת'}
                //{field:'TIsRecovery',width:'200',title:'�Ƿ�Ȭ��'}
            ]],
            onClickRow: function(rowIndex, rowData) {
                setValueById("DiseaseDesc",rowData.TDiseaseDesc);
                setValueById("DiagnosisDate",rowData.TDiagnosisDate);
                setValueById("DiagnosisPlace",rowData.TDiagnosisPlace);
                setValueById("Process",rowData.TProcess);
                setValueById("Return",rowData.TReturn);
            }
        });
        
        
        var QrySetObj = $HUI.datagrid("#QrySet",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCPE.HandlerOrdSetsEx",
            QueryName:"queryOrdSet",
            Set:"",
            Type:"ItemSet",
            AdmId:PreAdmId

        },
        onDblClickRow:function(rowIndex,rowData) {
            var RowIdStr=$("#PIADM_RowId").val()
            
            if(RowIdStr=="") {
                $.messager.alert("��ʾ","����ԤԼ��","info");
                return false;
            }
            var AdmIdStr=RowIdStr.split("^");
            var Rows=AdmIdStr.length;
            for(i=0;i<Rows;i++) {   
                var RowId=AdmIdStr[i];
                var SetId=rowData.OrderSetId;
                $("#Set").select();
                var GAAuditedFlag=tkMakeServerCall("web.DHCPE.ResultEdit","GeneralAdviceAudited",RowId,"CRM");
                if(GAAuditedFlag=="1") {
                    $.messager.alert("��ʾ","�ܼ콨���Ѿ����,���ܼ�������","info");
                    return false;
                }
            
                var IsAddItemFlagStr=tkMakeServerCall("web.DHCPE.HISUICommon","IsRecPaper",RowId,session['LOGON.CTLOCID']);
                var IsRecPaperFlag=IsAddItemFlagStr.split("^")[0];
                var IsAddItemFlag=IsAddItemFlagStr.split("^")[1];
                if((IsAddItemFlag!="Y")&&(IsRecPaperFlag=="1")){
                    $.messager.alert("��ʾ","�Ѿ��ձ�,���ܼ���","info");
                    return false;
                }             
        
                var SetSexFlag=tkMakeServerCall("web.DHCPE.PreItemList","IsSetSex",RowId,AdmType,SetId);
                var SetSexCanFlag=SetSexFlag.split("^")
            
                if(SetSexCanFlag[0]=="1"){
                    $.messager.alert("��ʾ",SetSexCanFlag[1],"info");
                    return false;
                }
                
                var IsExistStopItem=tkMakeServerCall("web.DHCPE.PreItemList","IsExistARCSets",SetId);
                if (IsExistStopItem!="") {
                    //�ж��ײ��ǲ��ǰ����Ѿ�ֹͣ��ҽ���������Ѿ�ֹͣ��ҽ��������ԤԼ����Ҫ�޸��ײͺ����ԤԼ
                    $.messager.alert("��ʾ","������ֹͣҽ���"+IsExistStopItem+", ��Ҫ���ײ�����ͣҽ����ɾ���󷽿�ԤԼ","info");
                    return false;
                }
                
                var isetid=tkMakeServerCall("web.DHCPE.PreItemList","IsExistItems",RowId,AdmType,SetId);
                /*
                if("1"==isetid) {
            
                    $.messager.alert("��ʾ","������������ײ�,���ܼ������","info");
                    return false;
                }
                */
            var RepeatFlag=0;
             var RepeatFlag=tkMakeServerCall("web.DHCPE.PreItemList","IsRepeatItem",RowId,SetId,AdmType)

                //if("1"==isetid) {
                    //$.messager.confirm("������ʾ", "������������ײͣ��Ƿ�������ӣ���������ӣ����Ѵ�����ͬ��Ŀ�����ײͻ��Զ���֣�", 
                if("1"==RepeatFlag) {
                    $.messager.confirm("������ʾ", "�ײ������ظ�����Ŀ���Ƿ��ײ��ж������Ŀ�Զ�ɾ��,�Ե������ʽ���ӣ�", 

                        function (data) {
                            if (data) {
                                var UserId=session['LOGON.USERID'];
                                $.cm({
                                    ClassName:"web.DHCPE.PreItemList",
                                    MethodName:"HISUIIInsertItem",
                                    "AdmId":RowId,
                                    "AdmType":AdmType,
                                    "PreOrAdd":PreOrAdd,
                                    "ArcItemId":"",
                                    "ArcItemSetId":SetId,
                                    "UpdateUserId":UserId,
                                    "RepeatFlag":1
                                }, function(jsonData) {
                                    if(jsonData.ret=="") {
                                        $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:$("#PIADM_RowId").val(),AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""}); 
                                        var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetOrdAmountHISUI",RowId,AdmType);
                                        var GZAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",RowId,AdmType);
                                        var myDiv=document.getElementById("TotalFee");
                                        myDiv.innerText=TotalAmount;
                                        var ConfirmInfo=tkMakeServerCall("web.DHCPE.PreItemList","GetItemName",$("#PIADM_RowId").val(),AdmType);
                                        var myDiv=document.getElementById("ConfirmInfo");
                                        myDiv.innerText=ConfirmInfo;
                                
                                    } else {
                                        $.messager.alert("��ʾ",jsonData.ret,"info");
                                    }
                                });

                            }else{
                                    var UserId=session['LOGON.USERID'];
                                $.cm({
                                    ClassName:"web.DHCPE.PreItemList",
                                    MethodName:"HISUIIInsertItem",
                                    "AdmId":RowId,
                                    "AdmType":AdmType,
                                    "PreOrAdd":PreOrAdd,
                                    "ArcItemId":"",
                                    "ArcItemSetId":SetId,
                                    "UpdateUserId":UserId,
                                    "RepeatFlag":0
                                }, function(jsonData) {
                                    if(jsonData.ret=="") {
                                        $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:$("#PIADM_RowId").val(),AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""}); 
                                        var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetOrdAmountHISUI",RowId,AdmType);
                                        var GZAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",RowId,AdmType);
                                        var myDiv=document.getElementById("TotalFee");
                                        myDiv.innerText=TotalAmount;
                                        var ConfirmInfo=tkMakeServerCall("web.DHCPE.PreItemList","GetItemName",$("#PIADM_RowId").val(),AdmType);
                                        var myDiv=document.getElementById("ConfirmInfo");
                                        myDiv.innerText=ConfirmInfo;
                                
                                    } else {
                                        $.messager.alert("��ʾ",jsonData.ret,"info");
                                    }
                                });
                            }
                        }
                    );
                    
                } else {
                    var UserId=session['LOGON.USERID'];
                    $.cm({
                        ClassName:"web.DHCPE.PreItemList",
                        MethodName:"HISUIIInsertItem",
                        "AdmId":RowId,
                        "AdmType":AdmType,
                        "PreOrAdd":PreOrAdd,
                        "ArcItemId":"",
                        "ArcItemSetId":SetId,
                        "UpdateUserId":UserId,
                        "RepeatFlag":1
                    }, function(jsonData) {
                        if(jsonData.ret=="") {
                            $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:$("#PIADM_RowId").val(),AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""}); 
                            var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetOrdAmountHISUI",RowId,AdmType);
                            var GZAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",RowId,AdmType);
                            var myDiv=document.getElementById("TotalFee");
                            myDiv.innerText=TotalAmount;
                            var ConfirmInfo=tkMakeServerCall("web.DHCPE.PreItemList","GetItemName",$("#PIADM_RowId").val(),AdmType);
                            var myDiv=document.getElementById("ConfirmInfo");
                            myDiv.innerText=ConfirmInfo;
                    
                        } else {
                            $.messager.alert("��ʾ",jsonData.ret,"info");
                        }
                    });
                }
            }
            
        },
        fitColumns:true,
        columns:[[
            {field:'OrderSetId',title:'Ԥ��',
                formatter:function(value,row,index){
                    return "<a href='#' onclick='openSetWin(\""+value+"\")'>\
                    <img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/eye.png' border=0/>\
                    </a>";
                }},
            {field:'OrderSetDesc',title:'����',width:100},
            {field:'OrderSetPrice',title:'���',align:'right'}
        ]],
        pagination:true,
        pageSize:20,
        displayMsg:"",
        fit:true
    
        })
        
        var QryRisObj = $HUI.datagrid("#QryRisItm",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCPE.StationOrder",
            QueryName:"StationOrderList",
            Type:"Item",
            TargetFrame:"PreItemList"

        },
        onDblClickRow:function(rowIndex,rowData){
            
            var RowIdStr=$("#PIADM_RowId").val()
            
            if(RowIdStr=="")
            {
                $.messager.alert("��ʾ","����ԤԼ��","info");
                return false;
            }
            
        var AdmIdStr=RowIdStr.split("^");
        var Rows=AdmIdStr.length;
        for(i=0;i<Rows;i++)
        {   
            var RowId=AdmIdStr[i]
            var ItemId=rowData.STORD_ARCIM_DR;
            $("#Item").select();
            
            var GAAuditedFlag=tkMakeServerCall("web.DHCPE.ResultEdit","GeneralAdviceAudited",RowId,"CRM");
            if(GAAuditedFlag=="1") {
                $.messager.alert("��ʾ","�ܼ콨���Ѿ����,���ܼ�������","info");
                return false;
            }
            
            var IsAddItemFlagStr=tkMakeServerCall("web.DHCPE.HISUICommon","IsRecPaper",RowId,session['LOGON.CTLOCID']);
            var IsRecPaperFlag=IsAddItemFlagStr.split("^")[0];
            var IsAddItemFlag=IsAddItemFlagStr.split("^")[1];
             if((IsAddItemFlag!="Y")&&(IsRecPaperFlag=="1")){
                 $.messager.alert("��ʾ","�Ѿ��ձ�,���ܼ���","info");
                  return false;
             }             
        
            var IsAddPhc=tkMakeServerCall("web.DHCPE.PreItemList","IsAddPhcItem",RowId,AdmType,ItemId,PreOrAdd);
            
            if(IsAddPhc=="1") {
                 if("PERSON"==gAdmType){
                    $.messager.alert("��ʾ","���˲������ҩ","info");
                    return false;
                  }
                 if("TEAM"==gAdmType){
                    $.messager.alert("��ʾ","���鲻�����ҩ","info");
                    return false;
                  }
            }
            
            var flagret=tkMakeServerCall("web.DHCPE.PreItemList","IsExistItem",RowId,AdmType,ItemId);
            var flagArr=flagret.split("^");
            var flag=flagArr[0];
            
            if ("1"==flag) 
            {
        
                if (flagArr[1]=="1")
                {
                    
                    $.messager.confirm("������ʾ", "��Ŀ�Ѵ���,�Ƿ�������?", function (data) {
                    if (data) {
            var UserId=session['LOGON.USERID'];
            $.cm({
            ClassName:"web.DHCPE.PreItemList",
            MethodName:"HISUIIInsertItem",
            "AdmId":RowId,
            "AdmType":AdmType,
            "PreOrAdd":PreOrAdd,
            "ArcItemId":ItemId,
            "ArcItemSetId":"",
            "UpdateUserId":UserId
            },function(jsonData){
                if(jsonData.ret=="")
                {
                    $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:$("#PIADM_RowId").val(),AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""}); 
                    var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetOrdAmountHISUI",RowId,AdmType);
                    var GZAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",RowId,AdmType);
                    var myDiv=document.getElementById("TotalFee");
                    myDiv.innerText=TotalAmount;
                    var ConfirmInfo=tkMakeServerCall("web.DHCPE.PreItemList","GetItemName",$("#PIADM_RowId").val(),AdmType);
                    var myDiv=document.getElementById("ConfirmInfo");
                    myDiv.innerText=ConfirmInfo;
                }
        
            
            });
                    }
                    else {
                        return false;
                    }
                    });
                    
                }else
                {
                    $.messager.alert("��ʾ","��Ŀ�Ѵ���,����������.","info");
                    return false;
                }
            }
            else if("2"==flag)
            {
                $.messager.alert("��ʾ","��Ŀ�еĻ�����Ŀ,��������Ŀ���ظ�,�Ƿ�������?","info")
                return false;
            }
            if (flagArr[1]=="1")
            {return false;}
            var ItemFlag;
            ItemFlag=tkMakeServerCall("web.DHCPE.PreItemList","ItemCanPreInfo",RowId,AdmType,ItemId)
            
            var ItemCanFlag=ItemFlag.split(",")
            
            if (ItemCanFlag[0]==-1)
            {  
                var ItemCanStr=""
                for(i=1;i<ItemCanFlag.length;i++){
                    if(ItemCanStr=="") {var ItemCanStr=ItemCanFlag[i];}
                    else {var ItemCanStr=ItemCanStr+","+ItemCanFlag[i];}
                }
                
                $.messager.confirm("������ʾ",ItemCanStr,function (data) {
                    if (data) {
            var UserId=session['LOGON.USERID'];
            $.cm({
            ClassName:"web.DHCPE.PreItemList",
            MethodName:"HISUIIInsertItem",
            "AdmId":RowId,
            "AdmType":AdmType,
            "PreOrAdd":PreOrAdd,
            "ArcItemId":ItemId,
            "ArcItemSetId":"",
            "UpdateUserId":UserId
            },function(jsonData){
                if(jsonData.ret=="")
                {
                    $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:$("#PIADM_RowId").val(),AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""}); 
                    var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetOrdAmountHISUI",RowId,AdmType);
                    var GZAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",RowId,AdmType);
                    var myDiv=document.getElementById("TotalFee");
                    myDiv.innerText=TotalAmount;
                    var ConfirmInfo=tkMakeServerCall("web.DHCPE.PreItemList","GetItemName",$("#PIADM_RowId").val(),AdmType);
                    var myDiv=document.getElementById("ConfirmInfo");
                    myDiv.innerText=ConfirmInfo;
                    
                    
                    
                }
                else
                {
                    $.messager.alert("��ʾ",jsonData.ret,"info"); 
                }
            
            });
                    }
                    else {
                        return false;
                    }
                    });
                 
            }
            if (ItemCanFlag[0]==-1)
            {return false;}
        
            var UserId=session['LOGON.USERID'];
            $.cm({
            ClassName:"web.DHCPE.PreItemList",
            MethodName:"HISUIIInsertItem",
            "AdmId":RowId,
            "AdmType":AdmType,
            "PreOrAdd":PreOrAdd,
            "ArcItemId":ItemId,
            "ArcItemSetId":"",
            "UpdateUserId":UserId
            },function(jsonData){
                if(jsonData.ret=="")
                {
                    $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:$("#PIADM_RowId").val(),AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""}); 
                    var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetOrdAmountHISUI",RowId,AdmType);
                    var GZAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",RowId,AdmType);
                    var myDiv=document.getElementById("TotalFee");
                    myDiv.innerText=TotalAmount;
                    var ConfirmInfo=tkMakeServerCall("web.DHCPE.PreItemList","GetItemName",RowId,AdmType);
                    var myDiv=document.getElementById("ConfirmInfo");
                    myDiv.innerText=ConfirmInfo;
                }
                else
                {
                    $.messager.alert("��ʾ",jsonData.ret,"info"); 
                }
            
            });
        }
            
            
        },
        fitColumns:true,
        columns:[[
            {field:'STORD_ARCIM_DR',title:'����',
            formatter:function(value,row,index){
                    return "<a href='#' onclick='AddItem(\""+value+"\")'>\
                    <img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' border=0/>\
                    </a>";
                }},
            {field:'STORD_ARCIM_Code',title:'����'},
            {field:'STORD_ARCIM_Desc',title:'����'},
            {field:'STORD_ARCIM_Price',title:'�۸�',align:'right'},
            {field:'TLocDesc',title:'վ��'}
        ]],
        pagination:true,
        pageSize:20,
        displayMsg:"",
        fit:true
    
        })
        
        
        var QryLisObj = $HUI.datagrid("#QryLisItm",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCPE.StationOrder",
            QueryName:"StationOrderList",
            Type:"Lab",
            TargetFrame:"PreItemList"

        },
        onDblClickRow:function(rowIndex,rowData){
            
            var RowIdStr=$("#PIADM_RowId").val()
            
            if(RowIdStr=="")
            {
                $.messager.alert("��ʾ","����ԤԼ��","info");
                return false;
            }
            
        var AdmIdStr=RowIdStr.split("^");
        var Rows=AdmIdStr.length;
        for(i=0;i<Rows;i++)
        {   
            var RowId=AdmIdStr[i]
            var ItemId=rowData.STORD_ARCIM_DR;
            $("#LisItem").select();
            
            
            
            var GAAuditedFlag=tkMakeServerCall("web.DHCPE.ResultEdit","GeneralAdviceAudited",RowId,"CRM");
            if(GAAuditedFlag=="1") {
                $.messager.alert("��ʾ","�ܼ콨���Ѿ����,���ܼ�������","info");
                return false;
            }
            
            
            var IsAddItemFlagStr=tkMakeServerCall("web.DHCPE.HISUICommon","IsRecPaper",RowId,session['LOGON.CTLOCID']);
            var IsRecPaperFlag=IsAddItemFlagStr.split("^")[0];
            var IsAddItemFlag=IsAddItemFlagStr.split("^")[1];
             if((IsAddItemFlag!="Y")&&(IsRecPaperFlag=="1")){
                 $.messager.alert("��ʾ","�Ѿ��ձ�,���ܼ���","info");
                  return false;
             }             
        
            var IsAddPhc=tkMakeServerCall("web.DHCPE.PreItemList","IsAddPhcItem",RowId,AdmType,ItemId,PreOrAdd);
            
            if(IsAddPhc=="1") {
                 if("PERSON"==AdmType){
                    $.messager.alert("��ʾ","���˲������ҩ","info");
                    return false;
                  }
                 if("TEAM"==AdmType){
                    $.messager.alert("��ʾ","���鲻�����ҩ","info");
                    return false;
                  }
            }
            
            var flagret=tkMakeServerCall("web.DHCPE.PreItemList","IsExistItem",RowId,AdmType,ItemId);
            var flagArr=flagret.split("^");
            var flag=flagArr[0];

            if ("1"==flag) 
            {
        
                if (flagArr[1]=="1")
                {
                    
                    $.messager.confirm("������ʾ", "��Ŀ�Ѵ���,�Ƿ�������?", function (data) {
                    if (data) {
            var UserId=session['LOGON.USERID'];
            $.cm({
            ClassName:"web.DHCPE.PreItemList",
            MethodName:"HISUIIInsertItem",
            "AdmId":RowId,
            "AdmType":AdmType,
            "PreOrAdd":PreOrAdd,
            "ArcItemId":ItemId,
            "ArcItemSetId":"",
            "UpdateUserId":UserId
            },function(jsonData){
                if(jsonData.ret=="")
                {
                    $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:$("#PIADM_RowId").val(),AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""}); 
                    var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetOrdAmountHISUI",RowId,AdmType);
                    var GZAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",RowId,AdmType);
                    var myDiv=document.getElementById("TotalFee");
                    myDiv.innerText=TotalAmount;
                    var ConfirmInfo=tkMakeServerCall("web.DHCPE.PreItemList","GetItemName",RowId,AdmType);
                    var myDiv=document.getElementById("ConfirmInfo");
                    myDiv.innerText=ConfirmInfo;
                }
        
            
            });
                    }
                    else {
                        return false;
                    }
                    });
                    
                }else
                {
                    $.messager.alert("��ʾ","��Ŀ�Ѵ���,����������.","info");
                    return false;
                }
            }
            else if("2"==flag)
            {
                $.messager.alert("��ʾ","��Ŀ�еĻ�����Ŀ,��������Ŀ���ظ�,�Ƿ�������?","info")
                return false;
            }
            if (flagArr[1]=="1")
            {return false;}
            var ItemFlag;
            ItemFlag=tkMakeServerCall("web.DHCPE.PreItemList","ItemCanPreInfo",RowId,AdmType,ItemId)
            
            var ItemCanFlag=ItemFlag.split(",")
            if (ItemCanFlag[0]==-1)
            {
                
                $.messager.confirm("������ʾ",ItemCanFlag[1], function (data) {
                    if (data) {
            var UserId=session['LOGON.USERID'];
            $.cm({
            ClassName:"web.DHCPE.PreItemList",
            MethodName:"HISUIIInsertItem",
            "AdmId":RowId,
            "AdmType":AdmType,
            "PreOrAdd":PreOrAdd,
            "ArcItemId":ItemId,
            "ArcItemSetId":"",
            "UpdateUserId":UserId
            },function(jsonData){
                if(jsonData.ret=="")
                {
                    $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:$("#PIADM_RowId").val(),AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""}); 
                    var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetOrdAmountHISUI",RowId,AdmType);
                    var GZAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",RowId,AdmType);
                    var myDiv=document.getElementById("TotalFee");
                    myDiv.innerText=TotalAmount;
                    var ConfirmInfo=tkMakeServerCall("web.DHCPE.PreItemList","GetItemName",RowId,AdmType);
                    var myDiv=document.getElementById("ConfirmInfo");
                    myDiv.innerText=ConfirmInfo;
                }
        
            
            });
                    }
                    else {
                        return false;
                    }
                    });
                 
            }
            if (ItemCanFlag[0]==-1)
            {return false;}
            var UserId=session['LOGON.USERID'];
            $.cm({
            ClassName:"web.DHCPE.PreItemList",
            MethodName:"HISUIIInsertItem",
            "AdmId":RowId,
            "AdmType":AdmType,
            "PreOrAdd":PreOrAdd,
            "ArcItemId":ItemId,
            "ArcItemSetId":"",
            "UpdateUserId":UserId
            },function(jsonData){
                
                if(jsonData.ret=="")
                {
                    $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:$("#PIADM_RowId").val(),AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""}); 
                    var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetOrdAmountHISUI",RowId,AdmType);
                    var GZAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",RowId,AdmType);
                    var myDiv=document.getElementById("TotalFee");
                    
                    myDiv.innerText=TotalAmount;
                    var ConfirmInfo=tkMakeServerCall("web.DHCPE.PreItemList","GetItemName",RowId,AdmType);
                    var myDiv=document.getElementById("ConfirmInfo");
                    myDiv.innerText=ConfirmInfo;
                }
                else
                {
                    $.messager.alert("��ʾ",jsonData.ret,"info"); 
                }
            
            });
            
        }
            
        },
        fitColumns:true,
        columns:[[
            {field:'STORD_ARCIM_DR',title:'����',
            formatter:function(value,row,index){
                    return "<a href='#' onclick='AddItem(\""+value+"\")'>\
                    <img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' border=0/>\
                    </a>";
                }},
            {field:'STORD_ARCIM_Code',title:'����'},
            {field:'STORD_ARCIM_Desc',title:'����'},
            {field:'STORD_ARCIM_Price',title:'�۸�',align:'right'},
            {field:'TLocDesc',title:'վ��'}
        ]],
        pagination:true,
        displayMsg:"",
        pageSize:20,
        fit:true
    
        })
        
        
        var QryOtherObj = $HUI.datagrid("#QryOtherItm",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCPE.StationOrder",
            QueryName:"StationOrderList",
            Type:"Other",
            TargetFrame:"PreItemList"

        },
        onDblClickRow:function(rowIndex,rowData){
            
            var RowIdStr=$("#PIADM_RowId").val()
            
            if(RowIdStr=="")
            {
                $.messager.alert("��ʾ","����ԤԼ��","info");
                return false;
            }
            
        var AdmIdStr=RowIdStr.split("^");
        var Rows=AdmIdStr.length;
        for(i=0;i<Rows;i++)
        {   
            var RowId=AdmIdStr[i]
            var ItemId=rowData.STORD_ARCIM_DR;
            $("#OtherItem").select();
            
            
            var GAAuditedFlag=tkMakeServerCall("web.DHCPE.ResultEdit","GeneralAdviceAudited",RowId,"CRM");
            if(GAAuditedFlag=="1") {
                $.messager.alert("��ʾ","�ܼ콨���Ѿ����,���ܼ�������","info");
                return false;
            }
            
            var IsAddItemFlagStr=tkMakeServerCall("web.DHCPE.HISUICommon","IsRecPaper",RowId,session['LOGON.CTLOCID']);
            var IsRecPaperFlag=IsAddItemFlagStr.split("^")[0];
            var IsAddItemFlag=IsAddItemFlagStr.split("^")[1];
             if((IsAddItemFlag!="Y")&&(IsRecPaperFlag=="1")){
                 $.messager.alert("��ʾ","�Ѿ��ձ�,���ܼ���","info");
                  return false;
             }             
        
            var IsAddPhc=tkMakeServerCall("web.DHCPE.PreItemList","IsAddPhcItem",RowId,AdmType,ItemId,PreOrAdd);
            if(IsAddPhc=="1") {
                 if("PERSON"==AdmType){
                    $.messager.alert("��ʾ","���˲������ҩ","info");
                    return false;
                  }
                 if("TEAM"==AdmType){
                    $.messager.alert("��ʾ","���鲻�����ҩ","info");
                    return false;
                  }
            }
            
            
            var flagret=tkMakeServerCall("web.DHCPE.PreItemList","IsExistItem",RowId,AdmType,ItemId);
            var flagArr=flagret.split("^");
            var flag=flagArr[0];

            if ("1"==flag) 
            {
        
                if (flagArr[1]=="1")
                {
                    
                    $.messager.confirm("������ʾ", "��Ŀ�Ѵ���,�Ƿ�������?", function (data) {
                    if (data) {
            var UserId=session['LOGON.USERID'];
            $.cm({
            ClassName:"web.DHCPE.PreItemList",
            MethodName:"HISUIIInsertItem",
            "AdmId":RowId,
            "AdmType":AdmType,
            "PreOrAdd":PreOrAdd,
            "ArcItemId":ItemId,
            "ArcItemSetId":"",
            "UpdateUserId":UserId
            },function(jsonData){
                if(jsonData.ret=="")
                {
                    $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:$("#PIADM_RowId").val(),AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""}); 
                    var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetOrdAmountHISUI",RowId,AdmType);
                    var GZAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",RowId,AdmType);
                    var myDiv=document.getElementById("TotalFee");
                    myDiv.innerText=TotalAmount;
                    var ConfirmInfo=tkMakeServerCall("web.DHCPE.PreItemList","GetItemName",RowId,AdmType);
                    var myDiv=document.getElementById("ConfirmInfo");
                    myDiv.innerText=ConfirmInfo;
                }
        
            
            });
                    }
                    else {
                        return false;
                    }
                    });
                    
                }else
                {
                    $.messager.alert("��ʾ","��Ŀ�Ѵ���,����������.","info");
                    return false;
                }
            }
            else if("2"==flag)
            {
                $.messager.alert("��ʾ","��Ŀ�еĻ�����Ŀ,��������Ŀ���ظ�,�Ƿ�������?","info")
                return false;
            }
            if (flagArr[1]=="1")
            {return false;}
            var ItemFlag;
            ItemFlag=tkMakeServerCall("web.DHCPE.PreItemList","ItemCanPreInfo",RowId,AdmType,ItemId)
            
            var ItemCanFlag=ItemFlag.split(",")
            if (ItemCanFlag[0]==-1)
            {
                
                $.messager.confirm("������ʾ",ItemCanFlag[1], function (data) {
                    if (data) {
            var UserId=session['LOGON.USERID'];
            $.cm({
            ClassName:"web.DHCPE.PreItemList",
            MethodName:"HISUIIInsertItem",
            "AdmId":RowId,
            "AdmType":AdmType,
            "PreOrAdd":PreOrAdd,
            "ArcItemId":ItemId,
            "ArcItemSetId":"",
            "UpdateUserId":UserId
            },function(jsonData){
                if(jsonData.ret=="")
                {
                    $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:$("#PIADM_RowId").val(),AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""}); 
                    var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetOrdAmountHISUI",RowId,AdmType);
                    var GZAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",RowId,AdmType);
                    var myDiv=document.getElementById("TotalFee");
                    myDiv.innerText=TotalAmount;
                    var ConfirmInfo=tkMakeServerCall("web.DHCPE.PreItemList","GetItemName",RowId,AdmType);
                    var myDiv=document.getElementById("ConfirmInfo");
                    myDiv.innerText=ConfirmInfo;
                }
        
            
            });
                    }
                    else {
                        return false;
                    }
                    });
                 
            }
            if (ItemCanFlag[0]==-1)
            {return false;}
            var UserId=session['LOGON.USERID'];
            $.cm({
            ClassName:"web.DHCPE.PreItemList",
            MethodName:"HISUIIInsertItem",
            "AdmId":RowId,
            "AdmType":AdmType,
            "PreOrAdd":PreOrAdd,
            "ArcItemId":ItemId,
            "ArcItemSetId":"",
            "UpdateUserId":UserId
            },function(jsonData){
                
                if(jsonData.ret=="")
                {
                    $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:$("#PIADM_RowId").val(),AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""}); 
                    var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetOrdAmountHISUI",RowId,AdmType);
                    var GZAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",RowId,AdmType);
                    var myDiv=document.getElementById("TotalFee");
                    myDiv.innerText=TotalAmount;
                    var ConfirmInfo=tkMakeServerCall("web.DHCPE.PreItemList","GetItemName",RowId,AdmType);
                    var myDiv=document.getElementById("ConfirmInfo");
                    myDiv.innerText=ConfirmInfo;
                    
                }
                else
                {
                    $.messager.alert("��ʾ",jsonData.ret,"info"); 
                }
            
            });
            
            
        }   
            
        },
        fitColumns:true,
        columns:[[
            {field:'STORD_ARCIM_DR',title:'����',
            formatter:function(value,row,index){
                    return "<a href='#' onclick='AddItem(\""+value+"\")'>\
                    <img src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' border=0/>\
                    </a>";
                }},
            {field:'STORD_ARCIM_Code',title:'����'},
            {field:'STORD_ARCIM_Desc',title:'����'},
            {field:'STORD_ARCIM_Price',title:'�۸�',align:'right'},
            {field:'TLocDesc',title:'վ��'}
        ]],
        pagination:true,
        displayMsg:"",
        pageSize:20,
        fit:true
    
        })
        
        
        
        var QryMedicalObj = $HUI.datagrid("#QryMedicalItm",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCPE.StationOrder",
            QueryName:"StationOrderList",
            Type:"Medical",
            TargetFrame:"PreItemList"

        },
        onDblClickRow:function(rowIndex,rowData){
            
            var RowIdStr=$("#PIADM_RowId").val()
            
            if(RowIdStr=="")
            {
                $.messager.alert("��ʾ","����ԤԼ��","info");
                return false;
            }
            
        var AdmIdStr=RowIdStr.split("^");
        var Rows=AdmIdStr.length;
        for(i=0;i<Rows;i++)
        {   
            var RowId=AdmIdStr[i]
            var ItemId=rowData.STORD_ARCIM_DR;
            
            var GAAuditedFlag=tkMakeServerCall("web.DHCPE.ResultEdit","GeneralAdviceAudited",RowId,"CRM");
            if(GAAuditedFlag=="1") {
                $.messager.alert("��ʾ","�ܼ콨���Ѿ����,���ܼ�������","info");
                return false;
            }
            
            
            var IsAddItemFlagStr=tkMakeServerCall("web.DHCPE.HISUICommon","IsRecPaper",RowId,session['LOGON.CTLOCID']);
            var IsRecPaperFlag=IsAddItemFlagStr.split("^")[0];
            var IsAddItemFlag=IsAddItemFlagStr.split("^")[1];
             if((IsAddItemFlag!="Y")&&(IsRecPaperFlag=="1")){
                 $.messager.alert("��ʾ","�Ѿ��ձ�,���ܼ���","info");
                  return false;
             }             
        
            var IsAddPhc=tkMakeServerCall("web.DHCPE.PreItemList","IsAddPhcItem",RowId,AdmType,ItemId,PreOrAdd);
            if(IsAddPhc=="1") {
                 if("PERSON"==AdmType){
                    $.messager.alert("��ʾ","���˲������ҩ","info");
                    return false;
                  }
                 if("TEAM"==AdmType){
                    $.messager.alert("��ʾ","���鲻�����ҩ","info");
                    return false;
                  }
            }
            
            
            var flagret=tkMakeServerCall("web.DHCPE.PreItemList","IsExistItem",RowId,AdmType,ItemId);
            var flagArr=flagret.split("^");
            var flag=flagArr[0];

            if ("1"==flag) 
            {
        
                if (flagArr[1]=="1")
                {
                    
                    $.messager.confirm("������ʾ", "��Ŀ�Ѵ���,�Ƿ�������?", function (data) {
                    if (data) {
            var UserId=session['LOGON.USERID'];
            $.cm({
            ClassName:"web.DHCPE.PreItemList",
            MethodName:"HISUIIInsertItem",
            "AdmId":RowId,
            "AdmType":AdmType,
            "PreOrAdd":PreOrAdd,
            "ArcItemId":ItemId,
            "ArcItemSetId":"",
            "UpdateUserId":UserId
            },function(jsonData){
                if(jsonData.ret=="")
                {
                    $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:$("#PIADM_RowId").val(),AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""}); 
                    var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetOrdAmountHISUI",RowId,AdmType);
                    var GZAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",RowId,AdmType);
                    var myDiv=document.getElementById("TotalFee");
                    myDiv.innerText=TotalAmount;
                    var ConfirmInfo=tkMakeServerCall("web.DHCPE.PreItemList","GetItemName",RowId,AdmType);
                    var myDiv=document.getElementById("ConfirmInfo");
                    myDiv.innerText=ConfirmInfo;
                }
        
            
            });
                    }
                    else {
                        return false;
                    }
                    });
                    
                }else
                {
                    $.messager.alert("��ʾ","��Ŀ�Ѵ���,����������.","info");
                    return false;
                }
            }
            else if("2"==flag)
            {
                $.messager.alert("��ʾ","��Ŀ�еĻ�����Ŀ,��������Ŀ���ظ�,�Ƿ�������?","info")
                return false;
            }
            if (flagArr[1]=="1")
            {return false;}
            var ItemFlag;
            ItemFlag=tkMakeServerCall("web.DHCPE.PreItemList","ItemCanPreInfo",RowId,AdmType,ItemId)
            
            var ItemCanFlag=ItemFlag.split(",")
            if (ItemCanFlag[0]==-1)
            {
                
                $.messager.confirm("������ʾ",ItemCanFlag[1], function (data) {
                    if (data) {
            var UserId=session['LOGON.USERID'];
            $.cm({
            ClassName:"web.DHCPE.PreItemList",
            MethodName:"HISUIIInsertItem",
            "AdmId":RowId,
            "AdmType":AdmType,
            "PreOrAdd":PreOrAdd,
            "ArcItemId":ItemId,
            "ArcItemSetId":"",
            "UpdateUserId":UserId
            },function(jsonData){
                if(jsonData.ret=="")
                {
                    $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:$("#PIADM_RowId").val(),AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""}); 
                    var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetOrdAmountHISUI",RowId,AdmType);
                    var GZAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",RowId,AdmType);
                    var myDiv=document.getElementById("TotalFee");
                    myDiv.innerText=TotalAmount;
                    var ConfirmInfo=tkMakeServerCall("web.DHCPE.PreItemList","GetItemName",RowId,AdmType);
                    var myDiv=document.getElementById("ConfirmInfo");
                    myDiv.innerText=ConfirmInfo;
                }
        
            
            });
                    }
                    else {
                        return false;
                    }
                    });
                 
            }
            if (ItemCanFlag[0]==-1)
            {return false;}
            var UserId=session['LOGON.USERID'];
            $.cm({
            ClassName:"web.DHCPE.PreItemList",
            MethodName:"HISUIIInsertItem",
            "AdmId":RowId,
            "AdmType":AdmType,
            "PreOrAdd":PreOrAdd,
            "ArcItemId":ItemId,
            "ArcItemSetId":"",
            "UpdateUserId":UserId
            },function(jsonData){
                
                if(jsonData.ret=="")
                {
                    $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:$("#PIADM_RowId").val(),AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""}); 
                    var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetOrdAmountHISUI",RowId,AdmType);
                    var GZAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",RowId,AdmType);
                    var myDiv=document.getElementById("TotalFee");
                    myDiv.innerText=TotalAmount;
                    var ConfirmInfo=tkMakeServerCall("web.DHCPE.PreItemList","GetItemName",RowId,AdmType);
                    var myDiv=document.getElementById("ConfirmInfo");
                    myDiv.innerText=ConfirmInfo;
                }
        
                else
                {
                    $.messager.alert("��ʾ",jsonData.ret,"info"); 
                }
            });
            
        }
            
        },
        fitColumns:true,
        columns:[[
            {field:'STORD_ARCIM_DR',title:'����',
            formatter:function(value,row,index){
                    return "<a href='#' onclick='AddItem(\""+value+"\")'>\
                    <img src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' border=0/>\
                    </a>";
                }},
            {field:'STORD_ARCIM_Code',title:'����'},
            {field:'STORD_ARCIM_Desc',title:'����'},
            {field:'STORD_ARCIM_Price',title:'�۸�',align:'right'},
            {field:'TLocDesc',title:'վ��'}
        ]],
        pagination:true,
        displayMsg:"",
        pageSize:20,
        fit:true
    
        })
        
        var PreItemListObj = $HUI.datagrid("#PreItemList",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCPE.Query.PreItemList",
            QueryName:"QueryPreItemList",
            AdmId:"",
            AdmType:AdmType,
            PreOrAdd:PreOrAdd,
            AddType:"Item",
            SelectType:"ItemSet",
            ShowFlag:"",
            Control:""

        },
        fitColumns:true,
        singleSelect: false,
        checkOnSelect:true,
        selectOnCheck:true,
        onDblClickRow: onDblClickRow,
        
        onLoadSuccess:function(data){
            
            editIndex = undefined;
            if(PreAdmId)
            {
                var rows = $("#PreItemList").datagrid("getRows");
            
                $("#PreItemList").datagrid("scrollTo",rows.length-1);
            }
            
        },

        onAfterEdit:function(rowIndex,rowData,changes){
            
            
            var OrdItemDR=rowData.RowId
            var ItemType=rowData.TItemType
            var ItemFeeType=rowData.TItemFeeType
            var Qty=rowData.TQty
            var OrderEntDR=rowData.OrderEntId
            var TItemStat=rowData.TItemStat
            
            if(TItemStat==1)
            {
                var Strings=OrdItemDR+","+AdmType+","+ItemType+","+ItemFeeType+","+Qty+","+OrderEntDR
                var Flag=tkMakeServerCall("web.DHCPE.PreItemList","UpdateItemFeeType",Strings);
                if (Flag!=0)
                {   
                    $.messager.alert("��ʾ",Flag,"info"); 
                }
                
            }
            var Flag=tkMakeServerCall("web.DHCPE.PreItemList","UpdateRecLoc",rowData.TRecLoc,rowData.RowId,AdmType);
            if (Flag!=0)
            {
                //alert(Flag);
            
            }
            
            var Flag=tkMakeServerCall("web.DHCPE.PreItemList","UpdateSpecName",rowData.TSpecCode+"^"+rowData.TSpecName,rowData.RowId,AdmType);
            if (Flag!=0)
            {
                //alert(Flag);
            
            }
            
            var CanChange=rowData.TModifiedFlag
            var Data=rowData.PrivilegeModeID
            var MedicalFlag=rowData.TIsMedical
            if ((CanChange=="1")||((Data=="OP")||(MedicalFlag=="1")))
            {
                var FactAmount=rowData.TFactAmount
                var AccountAmount=rowData.TAccountAmount
                var Strings=OrdItemDR+","+FactAmount+","+Qty+","+AccountAmount
                var Flag=tkMakeServerCall("web.DHCPE.PreItemList","UpdateOPAmount",Strings,AdmType);
                if (Flag!=0)
                {   
                    //alert(Flag)
                }
                
            }
            
            
            
            var IADM=getValueById("PIADM_RowId")
            
            //$("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:IADM,AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""});    
            var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetOrdAmountHISUI",IADM,AdmType);
            var GZAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",IADM,AdmType);
            
            var myDiv=document.getElementById("TotalFee");
            myDiv.innerText=TotalAmount;
            
        },

        columns:[[
            {field:'select',checkbox:true},
            {field:'IsBreakable',title:'����',
            formatter:function(value,row,index){
                    
                    if(row.ItemSetDesc!=""){
                    return "<a href='#' onclick='DeleteItemSet(\""+row.RowId+"^"+row.OrderEntId+"\")'>\
                    <img style='padding-left:7px;' title='ɾ����Ŀ���ײ�' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>\
                    </a><a href='#' onclick='UpdateSetWin(\""+row.RowId+"^"+row.OrderEntId+"\")'>\
                    <img style='padding-left:7px;padding-right:10px' title='ɾ���ײ���ĵ���' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cut.png' border=0/>\
                    </a>";
                    }else{
                        return "<a href='#' onclick='DeleteItemSet(\""+row.RowId+"^"+row.OrderEntId+"\")'>\
                        <img style='padding-left:7px;' title='ɾ����Ŀ���ײ�' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>\
                       </a>";
                    }
            }},
            {field:'RowId',hidden:true},
            {field:'OrderEntId',hidden:true},
            {field:'ItemId',hidden:true},
            {field:'ItemSetId',hidden:true},
            {field:'TItemType',hidden:true},
            {field:'TItemStat',hidden:true},
            {field:'TAccountAmount',hidden:true},
            {field:'TModifiedFlag',hidden:true},
            {field:'PrivilegeModeID',hidden:true},
            {field:'TIsMedical',hidden:true},
            {field:'ItemDesc',title:'��Ŀ����'},
            {field:'ItemSetDesc',title:'�ײ�'},
            {field:'TAddOrdItem',title:'�ѱ�'},
            {field:'TFactAmount',title:'�Żݽ��',align:'right',editor:{type:'numberbox',options:{min:0,precision:2}}},
            {field:'TPreOrAdd',title:'��Ŀ���'},
            {field:'TQty',title:'����',editor:{type:'numberbox'}},
            {field:'TUint',title:'��λ'},
            {field:'PrivilegeMode',title:'�Żݷ�ʽ'},
            {field:'TPersonAmount',title:'�Ը�',align:'right'},
            {field:'TRecLoc',title:'���տ���',
                formatter:function(value,row){
                    return row.TRecLocDesc;
                },
                editor:{
                    type:'combobox',
                    options:{
                        valueField:'RecLocRID',
                        textField:'RecLocDesc',
                        method:'get',
                        url:$URL+"?ClassName=web.DHCOPItemMast&QueryName=AIMRecLoc&ResultSetType=array",
                        onBeforeLoad:function(param){
                            var DefaultPAADM=tkMakeServerCall("web.DHCPE.HISUICommon","GetDefaultPAADM");
                            
                            var row=$('#PreItemList').datagrid('getRows')[NowRow]
                            
                            param.ARCIMRID=row.ItemId
                            param.PAADMRowID=DefaultPAADM
                            
                            }
                        
                    }
                }
            },
            {field:'TSpecCode',title:'����',
                formatter:function(value,row){
                    return row.TSpecName;
                },
                editor:{
                    type:'combobox',
                    options:{
                        valueField:'TSpecCode',
                        textField:'TSpceName',
                        method:'get',
                        url:$URL+"?ClassName=web.DHCPE.BarPrint&QueryName=SerchSpecName&ResultSetType=array",
                        onBeforeLoad:function(param){
                            
                            var row=$('#PreItemList').datagrid('getRows')[NowRow]
                            
                            param.ItemID=row.ItemId
                            
                            },
                        onSelect:function(record){
                            var row=$('#PreItemList').datagrid('getRows')[NowRow];
                            row.TSpecName=record.TSpceName
                                
                        }   
                        
                    }
                }
            },
            
            
            
            {field:'TAddUser',title:'����Ա'},
            {field:'TTotalAmount',title:'��Ӧ��',align:'right'},
            {field:'TTotalFactAmount',title:'�ܷ���',align:'right'},
            {field:'BChangeFee',title:'�����Է�ת��(����)',align:'center',
                formatter:function(value,row,index){
                    return tkMakeServerCall("web.DHCPE.PreItemListEx","OutChangeFeeButtonHISUI",row.RowId);
                }},
            {field:'TItemFeeType',title:'�������',
                formatter:function(value,row){
                    return row.TItemFeeTypeDesc;
                },
                editor:{
                    type:'combobox',
                    options:{
                        valueField:'id',
                        textField:'desc',
                        method:'get',
                        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatFeeType&ResultSetType=array"
                        
                    }
                }
            }
            
            
        ]],
        pagination:true,
        displayMsg:"",
        pageSize:20,
        fit:true
    
        });
        
        
        
    
    
    function endEditing(){
            
            if (editIndex == undefined){return true}
            
            if ($('#PreItemList').datagrid('validateRow', editIndex)){
                
                
                
                
                
                
                
                
                var ed = $('#PreItemList').datagrid('getEditor',{index:editIndex,field:'TItemFeeType'});
                
                var name = $(ed.target).combobox('getText');
                
                $('#PreItemList').datagrid('getRows')[editIndex]['TItemFeeTypeDesc'] = name;
                
                $('#PreItemList').datagrid('endEdit',editIndex);
                editIndex = undefined;
                return true;
            } else {
                return false;
            }
    }
    function onDblClickRow(index,value){
     
        NowRow=index;
        if (editIndex!=index) {
            if (endEditing()){
                $('#PreItemList').datagrid('selectRow',index).datagrid('beginEdit',index);
                
                
                
                var dd = $('#PreItemList').datagrid('getEditor', { index: index, field: 'TFactAmount' });
                var PrivilegeModeID = $('#PreItemList').datagrid('getRows')[index]['PrivilegeModeID'] 
                var ModifiedFlag = $('#PreItemList').datagrid('getRows')[index]['TModifiedFlag'] 
                if((PrivilegeModeID=="��Ŀ�Ż�")||(ModifiedFlag==1)) $(dd.target).numberbox('enable');
                else $(dd.target).numberbox('disable');
                
                
                var tt = $('#PreItemList').datagrid('getEditor', { index: index, field: 'TQty' });
                var IsMedical = $('#PreItemList').datagrid('getRows')[index]['TIsMedical'] 
                
               // if(IsMedical==1) $(dd.target).numberbox('enable');
               // else $(tt.target).numberbox('disable');
               if(IsMedical==1){
                if((PrivilegeModeID=="��Ŀ�Ż�")||(ModifiedFlag==1)) {
	                $(dd.target).numberbox('enable');
	                $(tt.target).numberbox('enable');
	               }
	            if((PrivilegeModeID!="��Ŀ�Ż�")&&(ModifiedFlag!=1)) {
	                $(dd.target).numberbox('disable');
	                $(tt.target).numberbox('enable');
	               }
                }
	            else{
		           		
      					$(tt.target).numberbox('disable');
	             }
                
  
                
                //$('#PreItemList').datagrid('selectRow',index).datagrid('editCell',{index:index,field:field});
                editIndex = index;
                
            } else {
                $('#PreItemList').datagrid('selectRow',editIndex);
            }
        }
     
    }
        
        
function BSaveAmount_click()
{
    endEditing();
    
    var rows = $("#PreItemList").datagrid("getRows"); 
    
    for(var i=0;i<rows.length;i++){
            
            var OrdItemDR=rows[i].RowId
            var ItemType=rows[i].TItemType
            var ItemFeeType=rows[i].TItemFeeType
            var Qty=rows[i].TQty
            var OrderEntDR=rows[i].OrderEntId
            var TItemStat=rows[i].TItemStat
            
            if(TItemStat==1)
            {
                var Strings=OrdItemDR+","+AdmType+","+ItemType+","+ItemFeeType+","+Qty+","+OrderEntDR;
                var Flag=tkMakeServerCall("web.DHCPE.PreItemList","UpdateItemFeeType",Strings);
            
            }
            
            var Flag=tkMakeServerCall("web.DHCPE.PreItemList","UpdateRecLoc",rows[i].TRecLoc,rows[i].RowId,AdmType);
            
            
            var Flag=tkMakeServerCall("web.DHCPE.PreItemList","UpdateSpecName",rows[i].TSpecCode+"^"+rows[i].TSpecName,rows[i].RowId,AdmType);
            
            
            var CanChange=rows[i].TModifiedFlag
            var Data=rows[i].PrivilegeModeID
            var MedicalFlag=rows[i].TIsMedical
            
            if ((CanChange=="1")||((Data=="OP")||(MedicalFlag=="1")))
            {
                var FactAmount=rows[i].TFactAmount
                var AccountAmount=rows[i].TAccountAmount
                var Strings=OrdItemDR+","+FactAmount+","+Qty+","+AccountAmount
                
                var Flag=tkMakeServerCall("web.DHCPE.PreItemList","UpdateOPAmount",Strings,AdmType);
                
                
            }
    
        
    }
    
            var IADM=getValueById("PIADM_RowId")
            
            $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:IADM,AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""});  
            var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetOrdAmountHISUI",IADM,AdmType);
            var GZAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",IADM,AdmType);
            
            var myDiv=document.getElementById("TotalFee");
            myDiv.innerText=TotalAmount;
}
        
        
        
        var PGADM_DR_NameObj = $HUI.combogrid("#PGADM_DR_Name",{
        panelWidth:490,
        url:$URL+"?ClassName=web.DHCPE.PreGADM&QueryName=SearchPreGADMShort",
        mode:'remote',
        delay:200,
        idField:'Hidden',
        textField:'Name',
        onBeforeLoad:function(param){
            param.Code = param.q;
        },
        onChange:function()
        {
            PGTeam_DR_NameObj.clear();
            if($("#PIADM_RowId").val()!="")
            {
                $.messager.alert("��ʾ","ԤԼ��ı�������Ϣ��Ҫ����֮������ԤԼ��","info");
                Clear_click();
            }
        },
        columns:[[
            {field:'Hidden',hidden:true},
            {field:'Name',title:'��������',width:110},
            {field:'Code',title:'����',width:80},
            {field:'Begin',title:'��ʼ����',width:100},
            {field:'End',title:'��ֹ����',width:100},
            {field:'DelayDate',title:'״̬',width:50}
            
            
        ]]
        });
        
        
        
        var PGTeam_DR_NameObj = $HUI.combogrid("#PGTeam_DR_Name",{
        panelWidth:300,
        url:$URL+"?ClassName=web.DHCPE.PreGTeam&QueryName=SearchGTeam",
        mode:'remote',
        delay:200,
        idField:'PGT_RowId',
        textField:'PGT_Desc',
        onBeforeLoad:function(param){
            
            var PreGId=$("#PGADM_DR_Name").combogrid("getValue");
            param.ParRef = PreGId;
        },
        onChange:function()
        {
            if($("#PIADM_RowId").val()!="")
            {
                $.messager.alert("��ʾ","ԤԼ��ı������Ϣ��Ҫ����֮������ԤԼ��","info");
                Clear_click();
            }
        },
        onShowPanel:function()
        {
            $('#PGTeam_DR_Name').combogrid('grid').datagrid('reload');
        },
        columns:[[
            {field:'PGT_RowId',hidden:true},
            {field:'PGT_ParRef_Name',title:'��������',width:140},
            {field:'PGT_Desc',title:'��������',width:100}
        ]]
        });
        
        
        var CategoryObj = $HUI.combobox("#Category",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindCategory&ResultSetType=array",
        valueField:'id',
        textField:'Category'
        })
        
        var IndustryObj = $HUI.combobox("#Industry",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindIndustry&ResultSetType=array",
        valueField:'id',
        textField:'Industry'
        })
        
        
        var TypeofworkObj = $HUI.combobox("#Typeofwork",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindTypeofwork&ResultSetType=array",
        valueField:'id',
        textField:'Typeofwork'
        })
        
        var ZYTypeofworkObj = $HUI.combobox("#ZYTypeofwork",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindTypeofwork&ResultSetType=array",
        valueField:'id',
        textField:'Typeofwork'
        })
        
        
        var ProtectiveMeasureObj = $HUI.combobox("#ProtectiveMeasure",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindProtectiveMeasure&ResultSetType=array",
        valueField:'id',
        textField:'ProtectiveMeasure'
        })
        
        
        
        
        
        var SexObj = $HUI.combobox("#PAPMICardType_DR_Name",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPAPMICardType&ResultSetType=array",
        valueField:'id',
        textField:'type'
        })
        
        var PatFeeObj = $HUI.combobox("#PatFeeType_DR_Name",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatFeeType&ResultSetType=array",
        valueField:'id',
        textField:'desc'
        })
        
        
        var RoomPlaceObj = $HUI.combobox("#RoomPlace",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindRoomPlace&ResultSetType=array",
        valueField:'id',
        textField:'desc',
        mode:'remote',
        
        onBeforeLoad:function(param){
            var VIP=$("#VIPLevel").combobox("getValue");
            param.VIPLevel = VIP;
            param.GIType = "I";
        }
        })
        
        var SexObj = $HUI.combobox("#Sex_DR_Name",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindSex&ResultSetType=array",
        valueField:'id',
        textField:'sex'
        })
        
        var VIPObj = $HUI.combobox("#VIPLevel",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
        valueField:'id',
        textField:'desc',
        onSelect:function(record){
            
            VIPLevelOnChange(record.id);
        }
        })
        
        var MarriedObj = $HUI.combobox("#Married_DR_Name",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindMarried&ResultSetType=array",
        valueField:'id',
        textField:'married'
        })
        
        var StationObj = $HUI.combobox("#StationID",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStation&ResultSetType=array",
        valueField:'id',
        textField:'desc',
        onSelect:function(record){
            
            $("#QryRisItm").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Item",TargetFrame:"PreItemList",Item:$("#Item").val(),StationID:record.id}); 
        }
        });
        
        $('#DOB').datebox({
            
            onChange: function(date){
                
                var Bob=$('#DOB').datebox('getValue');
                
        

                var AgeDesc=GetAgeNew(Bob,"");
                $('#Age').val(AgeDesc);
            },
            onSelect: function(date){
                
                var Bob=$('#DOB').datebox('getValue');
                var AgeDesc=GetAgeNew(Bob,"");
                $('#Age').val(AgeDesc);
            }
        });
        /*
        $("#ZYBTabItem").tabs({
            toolPosition:"left",
            tools:[{
            iconCls:'icon-arrow-bottom',
            handler:function(){
                $('#TPanel').layout('collapse','south');
            }
            }]
        });
        */
        /*
        $("#ZYBTab").tabs({
            toolPosition:"left",
            tools:[{
            iconCls:'icon-arrow-left',
            handler:function(){
                $('#TPanel').layout('collapse','west');
            }
            },
            {
            iconCls:'icon-arrow-right',
            handler:function(){
                $('#TPanel').layout('expand','west');
            }
            }]
        });
        */


$("#ZYBTabItem").tabs({
    border:1,
    onSelect: function(title, index) {
        if (title == '������Ϣ') {
            var RowId=$("#PIADM_RowId").val();
            if (RowId == "") {
                return false;
            }
            var Data = tkMakeServerCall("web.DHCPE.DHCPEOccuBaseEx","GetDataNew",RowId);
            if (Data == "") return;
            var Datas = Data.split("^");
            
            setValueById("Industry",Datas[5]);
            setValueById("Typeofwork",Datas[6]);
            setValueById("WorkNo",Datas[2]);
            setValueById("AllWorkYear",Datas[3]);
            setValueById("AllWorkMonth",Datas[9]);
            setValueById("HarmWorkYear",Datas[4]);
            setValueById("HarmWorkMonth",Datas[10]);
            setValueById("Category",Datas[1]);
            var HarmInfo=Datas[7].split(",");
            $("#HarmInfo").combotree("setValues",HarmInfo);
        }
        if (title == '��ʷ') {
            var RowId = $("#PIADM_RowId").val();
            if (RowId == "") {
                return false;
            }
            var Data = tkMakeServerCall("web.DHCPE.OccupationalDisease","GetHisData",RowId);

            if (Data == "����Ϣ") {return false;}
            var Datas = Data.split("^");
            setValueById("DHis",Datas[0]);
            setValueById("DHome",Datas[1]);
            
            setValueById("NowChild",Datas[2]);
            setValueById("Abortion",Datas[3]);
            setValueById("Prematurebirth",Datas[4]);
            setValueById("DeadBirth",Datas[5]);
            setValueById("AbnormalFetal",Datas[6]);
            
            setValueById("SmokeHis",Datas[7]);
            if (Datas[7] == "������") {
                $('#SmokeNo').attr("disabled",true);
                $('#SmokeAge').attr("disabled",true);
            }
            setValueById("SmokeNo",Datas[8]);
            setValueById("SmokeAge",Datas[9]);
            
            setValueById("AlcolHis",Datas[10]);
            if (Datas[10] == "������") {
                $('#AlcolNo').attr("disabled",true);
                $('#Alcol').attr("disabled",true);
            }
            setValueById("AlcolNo",Datas[11]);
            setValueById("Alcol",Datas[12]);
            
            setValueById("FirstMenstrual",Datas[13]);
            setValueById("Period",Datas[14]);
            setValueById("Cycle",Datas[15]);
            setValueById("MenoParseAge",Datas[16]);
            
            setValueById("WeddingDate",Datas[17]);
            setValueById("SpouseHarm",Datas[18]);
            setValueById("SpouseHealth",Datas[19]);

            return true;
        }
    }
});

$("#ZYBTab").tabs({
            border:1,
    onSelect: function(title, index) {
        if(title=='������Ϣ') {
            var RowId=$("#PIADM_RowId").val();
            if(RowId=="") {
                return false;
            }
            var Data=tkMakeServerCall("web.DHCPE.DHCPEOccuBaseEx","GetData",RowId);
            if (Data=="") return;
            
            var Datas=Data.split("^");
            setValueById("Category",Datas[3]);
            setValueById("WorkNo",Datas[2]);
            setValueById("AllWorkYear",Datas[6].split("Y")[0]);
            setValueById("AllWorkMonth",Datas[6].split("Y")[1]);
            setValueById("HarmWorkYear",Datas[0].split("Y")[0]);
            setValueById("HarmWorkMonth",Datas[0].split("Y")[1]);
            setValueById("Industry",Datas[1]);
            setValueById("Typeofwork",Datas[7]);
            var HarmInfo=Datas[9].split(",");
            $("#HarmInfo").combotree("setValues",HarmInfo);
        }
        if(title=='��ʷ') {
            var RowId=$("#PIADM_RowId").val();
            if(RowId=="") {
                return false;
            }
            var Data=tkMakeServerCall("web.DHCPE.OccupationalDisease","GetHisData",RowId);

            if (Data=="����Ϣ") {return false;}
            var Datas=Data.split("^");
            setValueById("DHis",Datas[0]);
            setValueById("DHome",Datas[1]);
            
            setValueById("NowChild",Datas[2]);
            setValueById("Abortion",Datas[3]);
            setValueById("Prematurebirth",Datas[4]);
            setValueById("DeadBirth",Datas[5]);
            setValueById("AbnormalFetal",Datas[6]);
            
            setValueById("SmokeHis",Datas[7]);
            if (Datas[7] == "������") {
                $('#SmokeNo').attr("disabled",false);
                $('#SmokeAge').attr("disabled",false);
            }
            setValueById("SmokeNo",Datas[8]);
            setValueById("SmokeAge",Datas[9]);
            
            setValueById("AlcolHis",Datas[10]);
            if (Datas[10] == "������") {
                $('#AlcolNo').attr("disabled",false);
                $('#Alcol').attr("disabled",false);
            }
            setValueById("AlcolNo",Datas[11]);
            setValueById("Alcol",Datas[12]);
            
            setValueById("FirstMenstrual",Datas[13]);
            setValueById("Period",Datas[14]);
            setValueById("Cycle",Datas[15]);
            setValueById("MenoParseAge",Datas[16]);
            
            setValueById("WeddingDate",Datas[17]);
            setValueById("SpouseHarm",Datas[18]);
            setValueById("SpouseHealth",Datas[19]);

            return true;
        }
    }
});

        
        $("#BSetDefaultVIP").click(function() {
            
            BSetDefaultVIP_click(); 
            
        });
        
        $("#PIADM_RowId").val(PreAdmId);
        
        var PIADMRowId=$("#PIADM_RowId").val()
        window.onload=function(){ 
        if(PIADMRowId)
        {
            var iPIADMRowId=PreAdmId.split("^")[0]
            $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:iPIADMRowId,AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""}); 
            var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetOrdAmountHISUI",iPIADMRowId,AdmType);
            var GZAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",iPIADMRowId,AdmType);
            var myDiv=document.getElementById("TotalFee");
            myDiv.innerText=TotalAmount;
            var ConfirmInfo=tkMakeServerCall("web.DHCPE.PreItemList","GetItemName",iPIADMRowId,AdmType);
            var myDiv=document.getElementById("ConfirmInfo");
            myDiv.innerText=ConfirmInfo;
            if(VIPLevel=="ְҵ��")
            {
                $('#ZYBTabItem').tabs('enableTab',"������Ϣ");
                $('#ZYBTabItem').tabs('enableTab',"ְҵʷ");
                $('#ZYBTabItem').tabs('enableTab',"��ʷ");
                $('#ZYBTabItem').tabs('enableTab',"ְҵ��ʷ");
                $('#ZYBTabItem').tabs('select',"�����Ŀ");
                $("#ZYHistory").datagrid('load',{ClassName:"web.DHCPE.OccupationalDisease",QueryName:"FindOccuHistory",PreIADM:iPIADMRowId}); 
                $("#ZYBHistory").datagrid('load',{ClassName:"web.DHCPE.OccupationalDisease",QueryName:"FindOccuDiseaseHistory",PreIADM:iPIADMRowId}); 
                $('#BEndanger').linkbutton('enable');
            }
            
        var PreGADM=tkMakeServerCall("web.DHCPE.HISUICommon","GetGADMByIADM",iPIADMRowId);
        if((AdmType=="PERSON")&&(PreGADM=="") ){    
            $("#IFeeAsCharged").checkbox("disable");    
        }
        
        
                $("#QrySet").datagrid('load',{ClassName:"web.DHCPE.HandlerOrdSetsEx",QueryName:"queryOrdSet",Set:$("#Set").val(),Type:"ItemSet",AdmId:iPIADMRowId}); 
                
                $("#QryRisItm").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Item",TargetFrame:"PreItemList",Item:$("#Item").val(),PreIADMID:iPIADMRowId,StationID:$("#StationID").combobox("getValue")}); 
    

                $("#QryLisItm").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Lab",TargetFrame:"PreItemList",Item:$("#LisItem").val(),PreIADMID:iPIADMRowId}); 
    

                $("#QryOtherItm").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Other",TargetFrame:"PreItemList",Item:$("#OtherItem").val(),PreIADMID:iPIADMRowId}); 
    

                $("#QryMedicalItm").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Medical",TargetFrame:"PreItemList",Item:$("#MedicalItem").val(),PreIADMID:iPIADMRowId}); 
                
        
        
        
        }
            
         }    
        SetDefault();
        InitPicture();
        
        $(document).ready(function(){
        if(PIADMRowId)
        {
            var iPIADMRowId=PreAdmId.split("^")[0]
            $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:iPIADMRowId,AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""}); 
        }
        })
        
        
    };
function SetDefault()
{
    var VIPNV="";
    var jsonData=$.cm({
    ClassName:"web.DHCPE.HISUICommon",
    MethodName:"GetVIP"
    },false);
        
    VIPNV=jsonData;
        
    $('#VIPLevel').combobox('setValue',jsonData);

    
    var jsonData=$.cm({
    ClassName:"web.DHCPE.HISUICommon",
    MethodName:"GetDefault"
    },false);
    
        var SexNV=jsonData.ret;
        SexNV=SexNV.split("^");
        $('#Sex_DR_Name').combobox('setValue',SexNV[1]);
        $('#PAPMICardType_DR_Name').combobox('setValue',SexNV[4]);
        
    
    
    
    var DefaultRoomPlace=tkMakeServerCall("web.DHCPE.RoomManagerEx","GetDefaultRoomPlace",VIPNV,"I");
    
    $('#RoomPlace').combobox('setValue',DefaultRoomPlace);
    $('#RoomPlace').combobox('reload');
    var OpenCharge=tkMakeServerCall("web.DHCPE.HISUICommon","GetOpenCharge");
    setValueById("OpenCharge",OpenCharge);

    
    var curr_time = new Date();
    
    function myformatter(date){  
    var y = date.getFullYear();  
    var m = date.getMonth()+1;  
    var d = date.getDate();  
    return (d<10?('0'+d):d)+'/'+(m<10?('0'+m):m)+'/'+y;  
    }  
    //$('#PEDateBegin').datebox('setValue', myformatter(curr_time));
    var today = getDefStDate(0);
    $('#PEDateBegin').datebox('setValue',today);

    $("#DietFlag").checkbox('setValue',true);
    
}
function trim(s) {
    if (""==s) { return ""; }
    var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
    return (m == null) ? "" : m[1];
}

//��֤�绰���ƶ��绰
function CheckTelOrMobile(telephone,Name,Type){
    if (isMoveTel(telephone)) return true;
    if (telephone.indexOf('-')>=0){
        $.messager.alert("��ʾ",Type+"�̶��绰���ȴ���,�̶��绰���ų���Ϊ��3����4��λ,�̶��绰���볤��Ϊ��7����8��λ,�������ӷ���-������,���ʵ!","info",function(){
            $("#"+Name).focus();
        });
        return false;
    }else{
        if(telephone.length!=11){
            $.messager.alert("��ʾ",Type+"��ϵ�绰�绰����ӦΪ��11��λ,���ʵ!","info",function(){
                $("#"+Name).focus();
            });
            return false;
        }else{
            $.messager.alert("��ʾ",Type+"�����ڸúŶε��ֻ���,���ʵ!","info",function(){
                $("#"+Name).focus();
            });
            return false;
        }
    }
    return true;
}
/* 
��;����������Ƿ���ȷ�ĵ绰���ֻ��� 
���룺 �绰��
value���ַ��� 
���أ� ���ͨ����֤����true,���򷵻�false 
*/  
function isMoveTel(telephone){
    
    var teleReg1 = /^((0\d{2,3})-)(\d{7,8})$/;
    var teleReg2 = /^((0\d{2,3}))(\d{7,8})$/; 
    var mobileReg =/^1[3|4|5|6|7|8|9][0-9]{9}$/;
    if (!teleReg1.test(telephone)&& !teleReg2.test(telephone) && !mobileReg.test(telephone)){ 
        return false; 
    }else{ 
        return true; 
    } 

}
function SaveIBIInfo()
{
    
    var iRowId=$("#PIBI_RowId").val();
    var iPAPMINo=$("#PAPMINo").val();
    var iName=$("#Name").val();
    if (iName==""){
        $.messager.alert("��ʾ","��������Ϊ��!","info",function(){
            var valbox = $HUI.validatebox("#Name", {
            required: true,
        });
            $("#Name").focus();
        });
        return false;
    }
    var iSex_DR=$("#Sex_DR_Name").combobox('getValue');
    if (iSex_DR==""){
        $.messager.alert("��ʾ","�Ա���Ϊ��!","info",function(){
            var valbox =  $HUI.combobox("#Sex_DR_Name", {
            required: true,
        });
            $("#Sex_DR_Name").focus();
        });
        return false;
    }
    
    /*
    var NameHasValue=$("#Name").validatebox('isValid');
    
    if(!NameHasValue)
    {
        $.messager.alert("��ʾ","��������Ϊ��","info");
        return
    }
    
    var MobilePhoneHasValue=$("#MobilePhone").validatebox('isValid');
    if(!MobilePhoneHasValue)
    {
        $.messager.alert("��ʾ","�ƶ��绰����ȷ","info");
        return
    }
    */
    var iMobilePhone=$("#MobilePhone").val();
    
    if (iMobilePhone==""){
        $.messager.alert("��ʾ","�ƶ��绰����Ϊ��!","info",function(){
            var valbox = $HUI.validatebox("#MobilePhone", {
            required: true,
        });
            $("#MobilePhone").focus();
        });
        return false;
    }else{
        
        if (!CheckTelOrMobile(iMobilePhone,"MobilePhone","")) return false;
    }
    

    
    var iTel1=$("#Tel1").val();
    iTel1=trim(iTel1);
    if (iTel1!=""){
        if (!CheckTelOrMobile(iTel1,"Tel1","")) return false;
        
    }

    var iMobilePhone=$("#MobilePhone").val();
    if(iTel1=="") {
        //$("#Tel1").val(iMobilePhone);
        //var iTel1=$("#Tel1").val();
        }
    var iTel2="";

    
    
    var iDOB=$("#DOB").datebox('getValue');
    if(iDOB==""){
            $.messager.alert("��ʾ","�������ڲ���Ϊ��!","info",function(){
            var valbox = $HUI.datebox("#DOB", {
            required: true,
        });
            $("#DOB").focus();
        });
        
        return false

    }

    //var iPatType_DR="1";
    var iPatType_DR=tkMakeServerCall("web.DHCPE.DHCPECommon","GetPatType",iPAPMINo);
    var iIDCard=$("#IDCard").val();
    //if (!isIdCardNo(iIDCard)) return;
        var iPAPMICardType=$("#PAPMICardType_DR_Name").combobox('getText');
        if((iPAPMICardType.indexOf("���֤")!="-1")&&(iIDCard!="")){       
        var myIsID=isIdCardNo(iIDCard);
                if (!myIsID){
                    $("#IDCard").focus();
                    return false;
                }
                var IDNoInfoStr=GetInfoFromIDCard(iIDCard)
                var IDBirthday=IDNoInfoStr[2] 
                if (iDOB!=IDBirthday){
                    $.messager.alert("��ʾ","�������������֤��Ϣ����!","info",function(){
                        $("#Birth").focus();
                    });
                    return false;
                }
                var IDSex=IDNoInfoStr[3]
                var mySex=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSexDescByID",iSex_DR)
                //alert(mySex+"^"+IDSex)
                if(mySex!=IDSex){
                    $.messager.alert("��ʾ","���֤��:"+iIDCard+"��Ӧ���Ա��ǡ�"+IDSex+"��,��ѡ����ȷ���Ա�!","info",function(){
                        $('#Sex').next('span').find('input').focus();
                    });
                    return false;
                }
    }

    var iVocation="";
    var iPosition=$("#Position").val();
    var iCompany="";
    var iPostalcode="";
    var iAddress=$("#Address").val();
    var iNation="";
    var iEmail="";
    var iMarriedDR=$("#Married_DR_Name").combobox('getValue');
    var iBloodDR="";
    var iUpdateDate="";
    var iUpdateUserDR=session['LOGON.USERID'];
    var iHPNo="";
    var iHCPDR="";
    var iHCADR="";
    var iCardNo=getValueById("CardNo");
    var myCardTypeDR="";
    var CardTypeStr=$HUI.combobox("#CardType").getValue();
    if(CardTypeStr!="") myCardTypeDR=CardTypeStr.split("^")[0];
    
    if (iCardNo!="") iCardNo=iCardNo+"$"+myCardTypeDR;
    
    var iVIPLevel=$("#VIPLevel").combobox('getValue');
    var iMedicareCode="";
    var FIBIUpdateModel="NoGen";
    var iPAPMICardType=$("#PAPMICardType_DR_Name").combobox('getValue');

    if(iRowId!=""){
        var BaseInfoStr=tkMakeServerCall("web.DHCPE.PreIADM","GetPreIBaseInfo",iRowId);
        var BaseInfo=BaseInfoStr.split("^");
        var iVocation=BaseInfo[9];
        var iCompany=BaseInfo[11];
        var iPostalcode=BaseInfo[12];
        var iNation=BaseInfo[14];
        var iEmail=BaseInfo[15];
        var iBloodDR=BaseInfo[17];
    }
    
    /*
    if (iPAPMINo!="")
    {
        var HisName=tkMakeServerCall("web.DHCPE.PreIBIUpdate","GetHisNameByRegNo",iPAPMINo);
        
        if (iName!=HisName)
        {
            $.messager.alert("��ʾ","������Ϣ��his��һ��!","info");
            return false;
            
        }
        
    }*/
    var Instring=   trim(iRowId)            //PIBI      1 
                +"^"+trim(iPAPMINo)         //�ǼǺ�    2
                +"^"+trim(iName)            //����        3
                +"^"+trim(iSex_DR)          //�Ա�        4
                +"^"+trim(iDOB)             //����        5
                +"^"+trim(iPatType_DR)      //��������  6
                +"^"+trim(iTel1)            //�绰����1 7
                +"^"+trim(iTel2)            //�绰����2 8
                +"^"+trim(iMobilePhone)     //�ƶ��绰  9
                +"^"+trim(iIDCard)          //���֤��  10
                +"^"+trim(iVocation)        //ְҵ        11
                +"^"+trim(iPosition)        //ְλ        12
                +"^"+trim(iCompany)         //��˾        13
                +"^"+trim(iPostalcode)      //�ʱ�        14
                +"^"+trim(iAddress)         //��ϵ��ַ  15
                +"^"+trim(iNation)          //����        16
                +"^"+trim(iEmail)           //�����ʼ�  17
                +"^"+trim(iMarriedDR)       //����״��  18
                +"^"+trim(iBloodDR)         //Ѫ��        19
                +"^"+trim(iUpdateDate)      //����        20
                +"^"+trim(iUpdateUserDR)    //������   21
                +"^"+trim(iHPNo)            //����
                +"^"+trim(iHCPDR)
                +"^"+trim(iHCADR)
                +"^"+trim(iCardNo)          //����
                +"^"+trim(iVIPLevel)        //VIP�ȼ�
                +"^"+trim(iMedicareCode)
                +"^"+trim(iPAPMICardType)   //֤������
                +";"+FIBIUpdateModel
    
    
    var jsonData=$.cm({
    ClassName:"web.DHCPE.PreIBIUpdate",
    MethodName:"HISUISave",
    "itmjs":"",
    "itmjsex":"",
    "InString":Instring
    
    },false);
    
    
    if (iRowId!=""){
        return true;
    }
        
    flag=jsonData.code;
    iRowId=jsonData.rowid;
    iRegNo=jsonData.regno;
    
    if (flag=='0') {
        
        $("#PIBI_RowId").val(iRowId);
        $("#PAPMINo").val(iRegNo);
        
        return true;
    }
    return false;
    
    
    
}

function JBNext() {
    $('#ZYBTab').tabs('select','ְҵʷ');
    $('#ZYBTabItem').tabs('select','ְҵʷ');
}
function ZYNext() {
    $('#ZYBTab').tabs('select','��ʷ');
    $('#ZYBTabItem').tabs('select','��ʷ');
}
function ZYBNext() {
    $('#ZYBTab').tabs('select',"�����Ŀ");
    $('#ZYBTabItem').tabs('select',"�����Ŀ");
}
function BSNext() {
    $('#ZYBTab').tabs('select','ְҵ��ʷ');
    $('#ZYBTabItem').tabs('select','ְҵ��ʷ');
}

function ZYCancel() {
    $("#ZYform").form("clear");
    $("#ZYHistory").datagrid('clearSelections');
}
function ZYBCancel() {
    $("#ZYBform").form("clear");
    $("#ZYBHistory").datagrid('clearSelections');
}

function ZYDelete() {
    var RowId = $("#PIADM_RowId").val();
    if (RowId == "") {
        $.messager.alert("��ʾ","����ԤԼ��","info");
        return false;
    }
    var row = $('#ZYHistory').datagrid('getSelected');
    if (row) {
    } else {
        $.messager.alert("��ʾ","δѡ����Ҫɾ���ļ�¼��","info");
        return;
    }
    $.messager.confirm("ɾ��", "ȷ��Ҫɾ����¼��?", function (r) {
        if (r) {
            var iPreIADM = getValueById("PIADM_RowId");
            
            var oldinfo = tkMakeServerCall("web.DHCPE.OccupationalDisease","GetOccuHistory",iPreIADM);
            var oldinfostr = oldinfo.split("$")
            
            var row = $('#ZYHistory').datagrid('getSelected');
            
            if (row) {
                var CurrentSel = $('#ZYHistory').datagrid('getRowIndex',row) + 1;
                oldinfostr[CurrentSel-1] = "";
                var NowInfo = oldinfostr.join("$");
            } else {

                $.messager.alert("��ʾ","δѡ����Ҫɾ���ļ�¼��","info");
                return;
            }
            
            var info = tkMakeServerCall("web.DHCPE.OccupationalDisease","SaveOccuHistory",iPreIADM,NowInfo);
            var infoData = info.split("^");
            
            if (infoData[0] <= 0) {
                $.messager.alert("��ʾ",info,"info");
                return;
            } else {
                $("#ZYHistory").datagrid('load',{ClassName:"web.DHCPE.OccupationalDisease",QueryName:"FindOccuHistory",PreIADM:iPreIADM});
                ZYCancel();
            }
        } else {
            return;
        }
    });
}

function ZYBDelete() {
    var row = $('#ZYBHistory').datagrid('getSelected');
    if(row) {
    } else {
        $.messager.alert("��ʾ","δѡ����Ҫɾ���ļ�¼��","info");
        return;
    }
    $.messager.confirm("ɾ��", "ȷ��Ҫɾ����¼��?", function (r) {
        if (r) {
            var iPreIADM = getValueById("PIADM_RowId");

            var oldinfo = tkMakeServerCall("web.DHCPE.OccupationalDisease","GetOccuDiseaseHistory",iPreIADM);
            var oldinfostr = oldinfo.split("$")
            
            var row = $('#ZYBHistory').datagrid('getSelected');
            if(row) {
                var CurrentSel = $('#ZYBHistory').datagrid('getRowIndex',row) + 1;
                oldinfostr[CurrentSel-1] = "";
                var NowInfo = oldinfostr.join("$");
            } else {
                $.messager.alert("��ʾ","δѡ����Ҫɾ���ļ�¼��","info");
                return;
            }
            
            var info = tkMakeServerCall("web.DHCPE.OccupationalDisease","SaveOccuDiseaseHistory",iPreIADM,NowInfo);
            var infoData = info.split("^");
            
            if (infoData[0] <= 0) {
                $.messager.alert("��ʾ",info,"info");
                return;
            } else {
                $("#ZYBHistory").datagrid('load',{ClassName:"web.DHCPE.OccupationalDisease",QueryName:"FindOccuDiseaseHistory",PreIADM:iPreIADM}); 
                ZYBCancel();
            }
        } else {
            return;
        }
    }); 
}

function ZYBSave() {
    var iDiseaseDesc = "", iDiagnosisDate = "", iDiagnosisPlace = "", iiProcess = "", iReturn = "", iIsRecovery = "", iPreIADM = "";
    
    var iDiseaseDesc = getValueById("DiseaseDesc");  // ����
    if (iDiseaseDesc == "") {
        $.messager.alert("��ʾ","��������Ϊ�գ�","info");
        return;
    }
    
    var iDiagnosisDate = getValueById("DiagnosisDate");  // �������
    if (iDiagnosisDate == "") {
        $.messager.alert("��ʾ","������ڲ���Ϊ�գ�","info");
        return;
    }
    
    var ret = tkMakeServerCall("web.DHCPE.OccupationalDisease","DateOverNow",iDiagnosisDate);
    if (ret == 1) {
        $.messager.alert("��ʾ","������ڲ��ܴ��ڵ�ǰ����!","info");
        return;
    }
    
    var iDiagnosisPlace = getValueById("DiagnosisPlace");  // ��ϵ�λ
    var iProcess = getValueById("Process");  // ���ƾ���
    var iReturn = getValueById("Return");  // ��ת
    
    //var iIsRecovery = getValueById("IsRecovery");
    //if (iIsRecovery) { iIsRecovery = "1"; }
    //else { iIsRecovery = "0"; }
    
    var iPreIADM = getValueById("PIADM_RowId");
    
    var Instring = trim(iDiseaseDesc)
                 + "^" + trim(iDiagnosisDate)
                 + "^" + trim(iDiagnosisPlace)
                 + "^" + trim(iProcess)
                 + "^" + trim(iReturn)
                 ; 
    var oldinfo = tkMakeServerCall("web.DHCPE.OccupationalDisease","GetOccuDiseaseHistory",iPreIADM);
    var oldinfostr = oldinfo.split("$");
    
    var row = $('#ZYBHistory').datagrid('getSelected');
    if (row) {
        var CurrentSel = $('#ZYBHistory').datagrid('getRowIndex',row) + 1;
        oldinfostr[CurrentSel-1] = Instring;
        var NowInfo=oldinfostr.join("$");
    } else {
        var NowInfo = oldinfo + "$" + Instring;
    }
    
    var info = tkMakeServerCall("web.DHCPE.OccupationalDisease","SaveOccuDiseaseHistory",iPreIADM,NowInfo);
    var infoData = info.split("^");
    
    if (infoData[0] <= 0) {
        $.messager.alert("��ʾ",info,"info");
        return;
    } else {
        $("#ZYBHistory").datagrid('load',{ClassName:"web.DHCPE.OccupationalDisease",QueryName:"FindOccuDiseaseHistory",PreIADM:iPreIADM});
        ZYBCancel();
    }
}

function ZYSave() {
    var RowId = $("#PIADM_RowId").val();
    if (RowId == "") {
        $.messager.alert("��ʾ","����ԤԼ��","info");
        return false;
    }
    
    var iStartDate = "",iEndDate = "", iWorkPlace = "", iWorkDepartment = "", iWorkTeam = "", iWorkType = "";
    var iWorkShop = "", iHarmfulFactor = "", iDailyWorkHours = "", iProtectiveMeasure = "", iPreIADM = "";
    
    var iStartDate = getValueById("StartDate");
    var iStartDate=tkMakeServerCall("web.DHCPE.OccupationalDisease","DateChangeNum",iStartDate);
    if(iStartDate==""){
        $.messager.alert("��ʾ","��ʼ���ڲ���Ϊ��!","info");
        return;
    }
    var iEndDate=getValueById("EndDate");
    var iEndDate=tkMakeServerCall("web.DHCPE.OccupationalDisease","DateChangeNum",iEndDate);
    
    if((iStartDate > iEndDate)&&(iEndDate!="")) {
        $.messager.alert("��ʾ","��ʼ���ڲ��ܴ��ڽ�������!","info");
        return;
    }

    var iWorkPlace = getValueById("WorkPlace");
    var iWorkDepartment = getValueById("WorkDepartment");
    var iWorkShop = getValueById("WorkShop");
    var iWorkTeam = getValueById("WorkTeam");
    var iWorkType = getValueById("ZYTypeofwork");
    var iDailyWorkHours = getValueById("DailyWorkHours");
    var iHarmfulFactor = getValueById("HarmfulFactor");
    var iProtectiveMeasure = getValueById("ProtectiveMeasure");
    
    var iPreIADM = getValueById("PIADM_RowId");
    
    var Instring = trim(iStartDate)
                 + "^" + trim(iEndDate)
                 + "^" + trim(iWorkPlace)
                 + "^" + trim(iWorkDepartment)
                 + "^" + trim(iWorkShop)
                 + "^" + trim(iWorkTeam)
                 + "^" + trim(iWorkType)
                 + "^" + trim(iDailyWorkHours)
                 + "^" + trim(iHarmfulFactor)
                 + "^" + trim(iProtectiveMeasure) 
                 ; 
    if (Instring == "^^^^^^^^^") {
        $.messager.alert("��ʾ","ְҵʷ��Ϣ����ȫ�ǿգ�","info");
        return;
    }
    var oldinfo = tkMakeServerCall("web.DHCPE.OccupationalDisease","GetOccuHistory",iPreIADM);
    var oldinfostr = oldinfo.split("$");
    
    var row = $('#ZYHistory').datagrid('getSelected');
    if(row) {
        var CurrentSel=$('#ZYHistory').datagrid('getRowIndex',row)+1;
        oldinfostr[CurrentSel-1]=Instring;
        var NowInfo=oldinfostr.join("$");
    } else {
        var NowInfo = oldinfo + "$" + Instring;
    }
    
    var info = tkMakeServerCall("web.DHCPE.OccupationalDisease","SaveOccuHistory",iPreIADM,NowInfo);
    var infoData = info.split("^");
    
    if (infoData[0] <= 0) {
        $.messager.alert("��ʾ",info,"info");
        return;
    } else {
        $("#ZYHistory").datagrid('load',{ClassName:"web.DHCPE.OccupationalDisease",QueryName:"FindOccuHistory",PreIADM:iPreIADM});
        ZYCancel();
    }
}

function BSSave() {
    var DHis = getValueById("DHis");
    var DHome = getValueById("DHome");
    
    var SmokeHis = getValueById("SmokeHis");
    var SmokeNo = getValueById("SmokeNo");
    var SmokeAge = getValueById("SmokeAge");
    var AlcolHis = getValueById("AlcolHis");
    var AlcolNo = getValueById("AlcolNo");
    var Alcol = getValueById("Alcol");
    
    var FirstMenstrual = getValueById("FirstMenstrual");
    var Period = getValueById("Period");
    var Cycle = getValueById("Cycle");
    var MenoParseAge = getValueById("MenoParseAge");
    
    var NowChild = getValueById("NowChild");
    var Abortion = getValueById("Abortion");
    var Prematurebirth = getValueById("Prematurebirth");
    var DeadBirth = getValueById("DeadBirth");
    var AbnormalFetal = getValueById("AbnormalFetal");
    
    var WeddingDate = getValueById("WeddingDate");
    var WeddingDate=tkMakeServerCall("web.DHCPE.OccupationalDisease","DateChangeNum",WeddingDate);
    
    var SpouseHarm = getValueById("SpouseHarm");
    var SpouseHealth = getValueById("SpouseHealth");
    
    var iPreIADM = getValueById("PIADM_RowId");
    
    var Instring1 = trim(SmokeHis) + "^" + trim(SmokeNo) + "^" + trim(SmokeAge);
    var info1 = tkMakeServerCall("web.DHCPE.OccupationalDisease","GetListDataByData",Instring1);
    
    var Instring2 = trim(AlcolHis) + "^" + trim(AlcolNo) + "^" + trim(Alcol);
    var info2 = tkMakeServerCall("web.DHCPE.OccupationalDisease","GetListDataByData",Instring2);
    
    
    var Instring3 = trim(FirstMenstrual) + "^" + trim(Period) + "^" + trim(Cycle) + "^" + trim(MenoParseAge);
    var info3 = tkMakeServerCall("web.DHCPE.OccupationalDisease","GetListDataByData",Instring3);
    
    var Instring4 = trim(NowChild) + "^" + trim(Abortion) + "^" + trim(Prematurebirth) + "^" + trim(DeadBirth) + "^" + trim(AbnormalFetal);
    var info4 = tkMakeServerCall("web.DHCPE.OccupationalDisease","GetListDataByData",Instring4);
    
    var Instring5 = trim(WeddingDate) + "^" + trim(SpouseHarm) + "^" + trim(SpouseHealth);
    var info5 = tkMakeServerCall("web.DHCPE.OccupationalDisease","GetListDataByData",Instring5);
    
    var Instring = trim(DHis)
                 + "^" + trim(DHome)
                 + "^" + trim(info1)
                 + "^" + trim(info2)
                 + "^" + trim(info3)
                 + "^" + trim(info4)
                 + "^" + trim(info5)
                 ;
                 
    var info = tkMakeServerCall("web.DHCPE.OccupationalDisease","SaveDiseaseHistory",iPreIADM,Instring);
    var infoData = info.split("^");
    
    if (infoData[0] <= 0) {
        $.messager.alert("��ʾ",info,"info");
        return;
    } else {
        $.messager.alert("��ʾ","���³ɹ�","success");
    }
}

function JBSave() {
    var Strings = "";
    var PreIADM = getValueById("PIADM_RowId");
    if (PreIADM == "") {
        $.messager.alert("��ʾ","����ԤԼ��","info");
        return false;
    }
    
    var AllWorkYear = getValueById("AllWorkYear");  // �ܹ���
    var AllWorkMonth = getValueById("AllWorkMonth");
    if (AllWorkYear == "" && AllWorkMonth == "") {
        $.messager.alert("��ʾ","�������ܹ��䣬��������0��","info");
        return;
    }
    
    var HarmWorkYear = getValueById("HarmWorkYear");  // �Ӻ�����
    var HarmWorkMonth = getValueById("HarmWorkMonth");
    if (HarmWorkYear == "" && HarmWorkMonth == "") {
        $.messager.alert("��ʾ","������Ӻ����䣬��������0��","info");
        return;
    }
    
    var Category = getValueById("Category");  // �������
    if (Category == "") {
        $.messager.alert("��ʾ","��ѡ�������࣡","info");
        return;
    }
    
    var OccuId = $("#HarmInfo").combotree("getValues");
    if (OccuId == "") {
        $.messager.alert("��ʾ","��ѡ��Ӻ����أ�","info");
        return;
    }
    
    var WorkNo = getValueById("WorkNo");  // ����
    
    var Industry = getValueById("Industry");  // ��ҵ
    
    var Typeofwork = getValueById("Typeofwork");  // ����
    
    var Strings = PreIADM + "^" + Industry + "^" + Typeofwork + "^" + WorkNo + "^" + AllWorkYear + "^" + AllWorkMonth
                + "^" + HarmWorkYear + "^" + HarmWorkMonth + "^" + Category;
    
    var InsertFlag = tkMakeServerCall("web.DHCPE.DHCPEOccuBaseEx","InsertNew",Strings);
    
    var OccuStr = OccuId.join("^");
    
    tkMakeServerCall("web.DHCPE.OccupationalDisease","SaveOccu",PreIADM,OccuStr);
    
    if (InsertFlag == 0) {
        $.messager.alert("��ʾ","���³ɹ�","success");
    } else {
        $.messager.alert("��ʾ",InsertFlag,"info");
    }
}

function BEndanger_Click() {
    var PreAdmId = getValueById("PIADM_RowId");
    openOccuWin(PreAdmId);
}

function ConfirmOrdItem_Click()
{
    
    var AdmIdStr=PreAdmId.split("^");
    var Rows=AdmIdStr.length;
    for(i=0;i<Rows;i++)
    { 
        var AdmId=AdmIdStr[i]
        if (AdmType=="PERSON")
        {
            var flag=tkMakeServerCall("web.DHCPE.TransAdmInfo","ConfirmAddOrdItem",AdmId,gUserId)
        }
        else if(AdmType=="TEAM")
        {
            var flag=tkMakeServerCall("web.DHCPE.TransAdmInfo","ConfirmAddOrdItemGT",AdmId,gUserId)
        }
    }
    
    
    var val=tkMakeServerCall("web.DHCPE.PreItemList","GetConfirmInfoStatus",AdmId,AdmType)
    if(val==""){
            $.messager.alert("��ʾ","����Ҫȷ�ϼ���!","info");
            return false;
           }
    
    if ((flag=="")||(flag==0)){
        
        $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:AdmId,AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""});     
        var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetOrdAmountHISUI",AdmId,AdmType);
        var GZAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",AdmId,AdmType);
        var myDiv=document.getElementById("TotalFee");
        myDiv.innerText=TotalAmount;
        
        var ConfirmInfo=tkMakeServerCall("web.DHCPE.PreItemList","GetItemName",AdmId,AdmType);
        var myDiv=document.getElementById("ConfirmInfo");
        myDiv.innerText=ConfirmInfo;
        
        $.messager.alert("��ʾ","ȷ�ϳɹ�!","success");
        var IFAsCharged="N"
        var IFeeAsCharged=$("#IFeeAsCharged").checkbox('getValue');
        if(IFeeAsCharged){var IFAsCharged="Y"}
        else{var IFAsCharged="N"}
        if ((AdmType=="PERSON")&&(IFAsCharged!="Y")){
            
            OpenChargePanel();
        }
        
    }else{
        $.messager.alert("��ʾ","ȷ�ϼ����쳣!","info");
        
    }
    
    return false;
    
}

function CopyItem(PreIADMID)
{
    var CurID=getValueById("PIADM_RowId");
    
    if (PreIADMID=="") return false;
    if (PreIADMID==CurID) return false;
     
    var rows = $("#PreItemList").datagrid("getRows");
    for(var i=0;i<rows.length;i++)
    {
        var ItemID=rows[i].ItemId
        var SetsID=rows[i].ItemSetId
        if ((ItemID=="")&&(SetsID=="")) continue;
        //�����ײ�ʱ�������Ĭ��vip�ȼ��󶨵��ײͣ����ظ�����
        var OrdSet=tkMakeServerCall("web.DHCPE.PreIADM","IsExistDefaultOrdSet",CurID);
        if((OrdSet==SetsID)&&(OrdSet!=""))continue;
        
        var flag=tkMakeServerCall("web.DHCPE.PreItemList","IInsertItem",CurID,AdmType,PreOrAdd,ItemID,SetsID,gUserId);
        
    } 
    var flag=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","CopyOrdSet",PreIADMID,CurID);
}


///��ע��ҽ�ƿ�дУ����
function WrtCard(){
    //var myPAPMINo=$("#PAPMINo").val();
    var myPAPMINo="";
    var mySecrityNo=$.cm({
        ClassName:"web.UDHCAccCardManage",
        MethodName:"GetCardCheckNo",
        dataType:"text",
        PAPMINo:myPAPMINo
    },false);
    
    if (mySecrityNo!=""){
        var myCardNo=$("#CardNo").val();
        //alert("myCardNo:"+myCardNo+"mySecrityNo:"+mySecrityNo)
        //var rtn=DHCACC_WrtMagCard("23", myCardNo, mySecrityNo, "");
        var rtn=DHCACC_WrtMagCard("3","",mySecrityNo,myEquipDR);
        //alert("rtn:"+rtn)
        if (rtn!="0"){
            return "-1^"
        }
    }else{
        return "-1^";
    }
    return "0^"+mySecrityNo
}


function Save()
{
    
    var VIPLevel=$("#VIPLevel").combobox('getText');
    if(VIPLevel=="ְҵ��")
    {
        $('#ZYBTab').tabs('enableTab',"������Ϣ");
        $('#ZYBTab').tabs('enableTab',"ְҵʷ");
        $('#ZYBTab').tabs('enableTab',"��ʷ");
        $('#ZYBTab').tabs('enableTab',"ְҵ��ʷ");
        $('#ZYBTab').tabs('select',"������Ϣ");
        
        $('#BEndanger').linkbutton('enable');
    }
    else
    {
        
        $('#ZYBTab').tabs('disableTab',"������Ϣ");
        $('#ZYBTab').tabs('disableTab',"ְҵʷ");
        $('#ZYBTab').tabs('disableTab',"��ʷ");
        $('#ZYBTab').tabs('disableTab',"ְҵ��ʷ");
        $('#ZYBTab').tabs('select',"�����Ŀ");
        
        $('#BEndanger').linkbutton('disable');
    }
    var iPAPMINo=$("#PAPMINo").val();
    
    if(iPAPMINo!=""){
            var iPAPMINo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iPAPMINo);
         var flag=tkMakeServerCall("web.DHCPE.PreIADM","JudgeIGByRegNo",iPAPMINo);
        if(flag=="G"){
            $.messager.alert("��ʾ","������Ա,�������������Ϣά���������",'info');
            return false;
        }
    }
    var DataStr="";
    var iPIADMRowId=$("#PIADM_RowId").val();
    DataStr=iPIADMRowId;
    var OldPIADMRowId=getValueById("Old_RowId");
    var flag=SaveIBIInfo();
    var iCardNo=$("#CardNo").val();
    var myCardTypeDR="";
    var CardTypeStr=$HUI.combobox("#CardType").getValue();
    if(CardTypeStr!="") myCardTypeDR=CardTypeStr.split("^")[0];
    if (iCardNo!="") iCardNo=iCardNo+"$"+myCardTypeDR;
    if((OverWriteFlag=="Y")&&(CardPAPMINo=="")){ 
            var myrtn=WrtCard(); //ע��ҽ�ƿ�дУ����
            //alert("myrtn:"+myrtn)
            var SecurityNo= myrtn.split("^")[1]; //У����
            //alert("iCardNo:"+iCardNo+",SecurityNo:"+SecurityNo)
            //���¿���DHC_CardRefУ�����ֶ�CF_SecurityNO
            var ret=tkMakeServerCall("web.DHCPE.PreIBIUpdate","UpdateCardSecurityNo",iCardNo,SecurityNo)
            //alert("ret:"+ret)
        }

    if (!flag) return false;
    
    var PIBIID=$("#PIBI_RowId").val();
    
    DataStr=DataStr+"^"+PIBIID;
    
    
    
    var GADMID="";
    GADMID=$("#PGADM_DR_Name").combogrid("getValue");
    if (($("#PGADM_DR_Name").combogrid('getValue')==undefined)||($("#PGADM_DR_Name").combogrid('getText')=="")){var GADMID="";}
    DataStr=DataStr+"^"+GADMID;

    var GTeamID="";
    GTeamID=$("#PGTeam_DR_Name").combogrid("getValue");
    if (($("#PGTeam_DR_Name").combogrid('getValue')==undefined)||($("#PGTeam_DR_Name").combogrid('getText')=="")){var GTeamID="";}
    DataStr=DataStr+"^"+GTeamID;

    var iPEDateBegin=$("#PEDateBegin").datebox('getValue');
    var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat");
     if (dtformat=="YMD"){
          var PEDateBeginYear=iPEDateBegin.split("-")[0];
      }
      if (dtformat=="DMY"){
         var PEDateBeginYear=iPEDateBegin.split("/")[2];
      }
      
    if(PEDateBeginYear<1840){
        $.messager.alert('��ʾ','������ڲ���С��1840��!',"info"); 
        return false;
    }

    DataStr=DataStr+"^"+iPEDateBegin;
    
    var iDOB=$("#DOB").datebox('getValue');
    
     if (dtformat=="YMD"){
          var DOBYear=iDOB.split("-")[0];
      }
      if (dtformat=="DMY"){
         var DOBYear=iDOB.split("/")[2];
      }
      
    if(DOBYear<1840){
        $.messager.alert('��ʾ','�������ڲ���С��1840��!',"info"); 
        return false;
    }
    
    var iiDOB=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",iDOB)
    var mydate = new Date();
    var CurMonth=mydate.getMonth()+1;
    if((CurMonth<=9)&&(CurMonth>=0)){var CurMonth="0"+CurMonth;}
    var CurDate=mydate.getFullYear()+"-"+CurMonth+"-"+ mydate.getDate(); 
    var CurDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",CurDate)
    if(iiDOB>CurDate) {
        $.messager.alert("��ʾ","�������ڴ��ڵ�ǰ����.","info");
                    return false;
    }
   
    var iiPEDateBegin=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",iPEDateBegin)
    if(iiDOB>iiPEDateBegin) {
        $.messager.alert("��ʾ","�������ڴ����������.","info");
                    return false;
    }

    var iPEDateEnd=iPEDateBegin;
    DataStr=DataStr+"^"+iPEDateEnd;
    var iPETime=getValueById("PETime");
    DataStr=DataStr+"^"+iPETime;
    var iPEDeskClerk_DR="";
    DataStr=DataStr+"^"+iPEDeskClerk_DR;
    var iPIADM_Status="PREREG";
    DataStr=DataStr+"^"+iPIADM_Status;
    var iAsCharged="N";
    var LocID=session['LOGON.CTLOCID'];
    var iAsCharged=tkMakeServerCall("web.DHCPE.DHCPECommon","GetCashierSystem",LocID)
    if((iAsCharged=="1")||(iAsCharged=="3")) {var iAsCharged="Y";}
    else{var iAsCharged="N";}
    DataStr=DataStr+"^"+iAsCharged;
    var iAddOrdItem="N";
    DataStr=DataStr+"^"+iAddOrdItem;
    var iAddOrdItemLimit="N";
    DataStr=DataStr+"^"+iAddOrdItemLimit;
    var iAddOrdItemAmount="";
    DataStr=DataStr+"^"+iAddOrdItemAmount;
    var iAddPhcItem="N";
    DataStr=DataStr+"^"+iAddPhcItem;
    var iAddPhcItemLimit="N";
    DataStr=DataStr+"^"+iAddPhcItemLimit;
    var iAddPhcItemAmount="";
    DataStr=DataStr+"^"+iAddPhcItemAmount;
    //var iIReportSend="DC";
    var iIReportSend="IS";
    DataStr=DataStr+"^"+iIReportSend;
    var iDisChargedMode="ID";
    DataStr=DataStr+"^"+iDisChargedMode;
    var iVIPLevel=$("#VIPLevel").combobox('getValue');
    if(iVIPLevel==""){
        $.messager.alert("��ʾ","VIP�ȼ�����Ϊ��.","info");
        return false;
    }
    DataStr=DataStr+"^"+iVIPLevel;
    var iDelayDate="";
    DataStr=DataStr+"^"+iDelayDate;
    var iRemark="";
    DataStr=DataStr+"^"+iRemark;
    var iSales_DR="";
    DataStr=DataStr+"^"+iSales_DR;
    var iType="";
    DataStr=DataStr+"^"+iType;
    var iGetReportDate="";
    DataStr=DataStr+"^"+iGetReportDate;
    var iGetReportTime="";
    DataStr=DataStr+"^"+iGetReportTime;
    var iPayType="";
    DataStr=DataStr+"^"+iPayType;
    var iPercent="";
    DataStr=DataStr+"^"+iPercent;
    var iDietFlag=0;
    var DietFlag=$("#DietFlag").checkbox('getValue');
    if(DietFlag) iDietFlag=1; 
    DataStr=DataStr+"^"+iDietFlag;
    var iGiftFlag=0;
    var GiftFlag=$("#GiftFlag").checkbox('getValue');
    if(GiftFlag) iGiftFlag=1; 
    DataStr=DataStr+"^"+iGiftFlag;
    var iInsureUnit="";
    DataStr=DataStr+"^"+iInsureUnit;
    var iPatType_DR_Name="";
    DataStr=DataStr+"^"+iPatType_DR_Name;
    var iCheckRoom="";
    DataStr=DataStr+"^"+iCheckRoom;
    var Position="";
    Position=$("#Position").val();
    DataStr=DataStr+"^"+Position;
    var iPatFeeType_DR_Name="";
    DataStr=DataStr+"^"+iPatFeeType_DR_Name;
    var iReCheckFlag="N";
    var ReCheckFlag=$("#ReCheckFlag").checkbox('getValue');
    if(ReCheckFlag) iReCheckFlag="Y";
    DataStr=DataStr+"^"+iReCheckFlag;
    var iRoomPlace=$('#RoomPlace').combobox('getValue');
    var DefaultRoomPlace=tkMakeServerCall("web.DHCPE.RoomManagerEx","GetDefaultRoomPlace",iVIPLevel,"I");
    if ((iRoomPlace=="")&&(DefaultRoomPlace!="")) {
        $.messager.alert("��ʾ","����λ�ò���Ϊ��!","info");
        return false;
    }
    
    DataStr=DataStr+"^"+iRoomPlace;
    //var NetPreID="";
    var PhotoInfo=""
    var PhotoInfo=$("#imgPic").val();
    
    DataStr=DataStr+"^"+PhotoInfo;
    
    var DataStr=DataStr+"$$"+NetPreID;
    
    var LocID=session["LOGON.CTLOCID"];
    
    var flag=tkMakeServerCall("web.DHCPE.NetPre.GetPreInfo","IsCanPreForHis",iPEDateBegin,LocID,iVIPLevel,"I",iPETime,PIBIID);
    
    var Arr=flag.split("^");
    
    if (Arr[0]=="0"){
    
        $.messager.confirm("��ʾ", Arr[1], function (r) {
            if (r) {
                if (GADMID=="")
                {
                    var jsonData=$.cm({
                    ClassName:"web.DHCPE.PreIADM",
                    MethodName:"HISUISave",
                    "itmjs":"",
                    "itmjsex":"",
                    "InString":DataStr
                
                    },false);
                    var flag=jsonData.ret;
                
                }
                else 
                {
                    if(GTeamID==""){
                        $.messager.alert("��ʾ","��ѡ�����","info");
                        return false;
                        }

                    var flag=tkMakeServerCall("web.DHCPE.PreIADM","InsertIADMInGTeam",PIBIID,GADMID,GTeamID,Position);
                        
                }
            
            
        
            
                var Rets=flag.split("^");
                flag=Rets[0];
                if (""==iPIADMRowId) { 
                    iPIADMRowId=Rets[1];
                    if (flag=='0') {
                
                        $("#PIADM_RowId").val(Rets[1]);
                        $("#Old_RowId").val(Rets[1]);
                    }
            
                }
            
            
                if ('0'==flag) {
                     $.messager.alert("��ʾ","ԤԼ�ɹ�","success")
                    if (""==iPIADMRowId) {
                        
                    }else {
                        //��д�����ʾ�   add by wangguoying 
                        if(SurveyFlag=="Y")
                        {
                            openSurveyWin(iPIADMRowId);
                        }

                        //CopyItem(OldPIADMRowId);
                        $("#jbinfo").form("clear");
                        $("#ZYform").form("clear");
                        $("#DHistory").form("clear");
                        $("#ZYBform").form("clear");
                        $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:iPIADMRowId,AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""}); 
                        var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetOrdAmountHISUI",iPIADMRowId,AdmType);
                        var GZAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",iPIADMRowId,AdmType);
                        var myDiv=document.getElementById("TotalFee");
                        myDiv.innerText=TotalAmount;
                        //var ConfirmInfo=tkMakeServerCall("web.DHCPE.PreItemList","GetItemName",iPIADMRowId,AdmType);
                        //var myDiv=document.getElementById("ConfirmInfo");
                        //myDiv.innerText=ConfirmInfo;
                        
                        $("#QrySet").datagrid('load',{ClassName:"web.DHCPE.HandlerOrdSetsEx",QueryName:"queryOrdSet",Set:$("#Set").val(),Type:"ItemSet",AdmId:iPIADMRowId}); 
                        $("#QryRisItm").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Item",TargetFrame:"PreItemList",Item:$("#Item").val(),PreIADMID:iPIADMRowId,StationID:$("#StationID").combobox("getValue")}); 
            

                        $("#QryLisItm").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Lab",TargetFrame:"PreItemList",Item:$("#LisItem").val(),PreIADMID:iPIADMRowId}); 
            

                        $("#QryOtherItm").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Other",TargetFrame:"PreItemList",Item:$("#OtherItem").val(),PreIADMID:iPIADMRowId}); 
            

                        $("#QryMedicalItm").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Medical",TargetFrame:"PreItemList",Item:$("#MedicalItem").val(),PreIADMID:iPIADMRowId}); 
                        
                        $("#ZYHistory").datagrid('load',{ClassName:"web.DHCPE.OccupationalDisease",QueryName:"FindOccuHistory",PreIADM:iPIADMRowId}); 
                        $("#ZYBHistory").datagrid('load',{ClassName:"web.DHCPE.OccupationalDisease",QueryName:"FindOccuDiseaseHistory",PreIADM:iPIADMRowId}); 
            
                         }
                }else if ('Err 02'==flag) {
                    $.messager.alert("��ʾ","�˿ͻ��ѵǼ�","info")
                    return false; 
                }
                else if ('Err 05'==flag) {
                    $.messager.alert("��ʾ","��¼�Ѳ��ǵǼ�״̬,�����޸�","info")
                    return false; 
                } else if ('-105'==flag) {
                    $.messager.alert("��ʾ","���ݸ�ʽ����,������ֹ","info")
                    return false;

                }else if ('Err 09'==flag) {
                    $.messager.alert("��ʾ","���´��� �����:"+Rets[1],"info")
                    return false; 
                }else if ('Err 07'==flag) {
                    $.messager.alert("��ʾ","���´���:�������������Ѵ���","info")
                    return false; 
                }else {
                    $.messager.alert("��ʾ","���´��� �����:"+flag,"info")
                    return false;
                }

                return true;
            } else {
                return false;
            }
        });
    }
    else
    {
        
        if (GADMID=="")
        {
            var jsonData=$.cm({
            ClassName:"web.DHCPE.PreIADM",
            MethodName:"HISUISave",
            "itmjs":"",
            "itmjsex":"",
            "InString":DataStr
        
            },false);
            var flag=jsonData.ret;
    
        }
        else 
        {
            if(GTeamID==""){
                $.messager.alert("��ʾ","��ѡ�����","info");
                return false;
                }

            var flag=tkMakeServerCall("web.DHCPE.PreIADM","InsertIADMInGTeam",PIBIID,GADMID,GTeamID,Position);
                
        }
        
        
    
        
        var Rets=flag.split("^");
        flag=Rets[0];
        if (""==iPIADMRowId) { 
            iPIADMRowId=Rets[1];
            if (flag=='0') {
        
                $("#PIADM_RowId").val(Rets[1]);
                $("#Old_RowId").val(Rets[1]);
            }
    
        }
        
        
        if ('0'==flag) {
             $.messager.alert("��ʾ","ԤԼ�ɹ�","success")
            if (""==iPIADMRowId) {
                
            }else {
                //��д�����ʾ�   add by wangguoying 
                if(SurveyFlag=="Y")
                {
                    openSurveyWin(iPIADMRowId);
                }

                //CopyItem(OldPIADMRowId);
                $("#jbinfo").form("clear");
                $("#ZYform").form("clear");
                $("#DHistory").form("clear");
                $("#ZYBform").form("clear");
                $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:iPIADMRowId,AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""}); 
                var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetOrdAmountHISUI",iPIADMRowId,AdmType);
                var GZAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",iPIADMRowId,AdmType);
                var myDiv=document.getElementById("TotalFee");
                myDiv.innerText=TotalAmount;
                //var ConfirmInfo=tkMakeServerCall("web.DHCPE.PreItemList","GetItemName",iPIADMRowId,AdmType);
                //var myDiv=document.getElementById("ConfirmInfo");
                //myDiv.innerText=ConfirmInfo;
                
                $("#QrySet").datagrid('load',{ClassName:"web.DHCPE.HandlerOrdSetsEx",QueryName:"queryOrdSet",Set:$("#Set").val(),Type:"ItemSet",AdmId:iPIADMRowId}); 
                $("#QryRisItm").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Item",TargetFrame:"PreItemList",Item:$("#Item").val(),PreIADMID:iPIADMRowId,StationID:$("#StationID").combobox("getValue")}); 
    

                $("#QryLisItm").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Lab",TargetFrame:"PreItemList",Item:$("#LisItem").val(),PreIADMID:iPIADMRowId}); 
    

                $("#QryOtherItm").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Other",TargetFrame:"PreItemList",Item:$("#OtherItem").val(),PreIADMID:iPIADMRowId}); 
    

                $("#QryMedicalItm").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Medical",TargetFrame:"PreItemList",Item:$("#MedicalItem").val(),PreIADMID:iPIADMRowId}); 
                
                $("#ZYHistory").datagrid('load',{ClassName:"web.DHCPE.OccupationalDisease",QueryName:"FindOccuHistory",PreIADM:iPIADMRowId}); 
                $("#ZYBHistory").datagrid('load',{ClassName:"web.DHCPE.OccupationalDisease",QueryName:"FindOccuDiseaseHistory",PreIADM:iPIADMRowId}); 
    
                 }
        }else if ('Err 02'==flag) {
            $.messager.alert("��ʾ","�˿ͻ��ѵǼ�","info")
            return false; 
        }
        else if ('Err 05'==flag) {
            $.messager.alert("��ʾ","��¼�Ѳ��ǵǼ�״̬,�����޸�","info")
            return false; 
        } else if ('-105'==flag) {
            $.messager.alert("��ʾ","���ݸ�ʽ����,������ֹ","info")
            return false;

        }else if ('Err 09'==flag) {
            $.messager.alert("��ʾ","���´��� �����:"+Rets[1],"info")
            return false; 
        }else if ('Err 07'==flag) {
            $.messager.alert("��ʾ","���´���:�������������Ѵ���","info")
            return false; 
        }else {
            $.messager.alert("��ʾ","���´��� �����:"+flag,"info")
            return false;
        }

        return true;
        
    }
    
    
    
    
    
    
    
    
    
    
    
}
function RegNoMask(RegNo)
{
    if (RegNo=="") return RegNo;
    var RegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",RegNo);
    return RegNo;
}

function SetPatient_Sel(value) 
{
    
    var Data=value.split(";");
    
    var IsShowAlert=Data[2];
    if ("Y"==IsShowAlert) {
        
        $.messager.confirm("ȷ��", "�ͻ�����ԤԼ���Ƿ��ٴ�ԤԼ��", function(data){  
        if (data) {
        }
        else{
                Clear_click();
            
            }
        }
            
        );
    
    }   
    
    
    if ((Data[0].split("^")[0]!=0)||(Data[1].split("^")[0]!=0))
    {
    var PreIBaseInfoData=Data[0];
    
    
    if (""!=PreIBaseInfoData)
    {   
        SetPreIBaseInfo(PreIBaseInfoData);
    }
    else
    {    
        var HisInfo=Data[1];
        SetHisInfo(HisInfo)
    }
    }
    
}

function SetPreIBaseInfo(value)
{

    var Data=value.split("^");
    
    var iLLoop=0;   
    var iRowId=Data[iLLoop];
    $("#PIBI_RowId").val(iRowId);
    iLLoop=iLLoop+1;
    $("#PAPMINo").val(Data[iLLoop]);
    iLLoop=iLLoop+1;
    InitPicture();
    var iName=Data[iLLoop];
    if(iName=="δ�ҵ���¼")
    {
        //$.messager.alert("��ʾ","δ�ҵ���¼!","info");
        Clear_click()
        return ;
    }

    $("#Name").val(Data[iLLoop]);
    if(($("#Name").val())!=""){
        
        var valbox = $HUI.validatebox("#Name", {
            required: false,
        });
        
    }
    iLLoop=iLLoop+1;
    $("#Sex_DR_Name").combobox('setValue',Data[iLLoop]);
    iLLoop=iLLoop+2;
    $("#DOB").datebox('setValue',Data[iLLoop]);
    iLLoop=iLLoop+3;
    $("#Tel1").val(Data[iLLoop]);
    iLLoop=iLLoop+2;
    $("#MobilePhone").val(Data[iLLoop]);
    if(($("#MobilePhone").val())!=""){
        
        var valbox = $HUI.validatebox("#MobilePhone", {
            required: false,
        });
        
    }
    iLLoop=iLLoop+1;
    $("#IDCard").val(Data[iLLoop]);
    iLLoop=iLLoop+2;
    $("#Position").val(Data[iLLoop]);
    iLLoop=iLLoop+3;
    $("#Address").val(Data[iLLoop]);
    iLLoop=iLLoop+3;
    $("#Married_DR_Name").combobox('setValue',Data[iLLoop]);
    iLLoop=iLLoop+8;
    $("#Age").val(Data[iLLoop].split("Y")[0]);
    iLLoop=iLLoop+5;
    $("#CardNo").val(Data[iLLoop]);
    iLLoop=iLLoop+1;
    $("#VIPLevel").combobox('setValue',Data[iLLoop]);
    iLLoop=iLLoop+2;
    
    $("#PAPMICardType_DR_Name").combobox('setValue',Data[iLLoop]);

    VIPLevelOnChange();
}
function SetHisInfo(value)
{
    var Data=value.split("^");
    var iLLoop=1;
    $("#PAPMINo").val(Data[iLLoop]);
    iLLoop=iLLoop+1;
    $("#Name").val(Data[iLLoop]);
    if(($("#Name").val())!=""){
        
        var valbox = $HUI.validatebox("#Name", {
            required: false,
        });
        
    }
    iLLoop=iLLoop+1;
    $("#Sex_DR_Name").combobox('setValue',Data[iLLoop]);
    iLLoop=iLLoop+2;
    $("#DOB").datebox('setValue',Data[iLLoop]);
    iLLoop=iLLoop+3;
    $("#Tel1").val(Data[iLLoop]);
    iLLoop=iLLoop+2;
    $("#MobilePhone").val(Data[iLLoop]);
    if(($("#MobilePhone").val())!=""){
        
        var valbox = $HUI.validatebox("#MobilePhone", {
            required: false,
        });
        
    }
    iLLoop=iLLoop+1;
    $("#IDCard").val(Data[iLLoop]);
    iLLoop=iLLoop+2;
    $("#Position").val(Data[iLLoop]);
    iLLoop=iLLoop+3;
    $("#Address").val(Data[iLLoop]);
    iLLoop=iLLoop+3;
    $("#Married_DR_Name").combobox('setValue',Data[iLLoop]);
    iLLoop=iLLoop+8;
    $("#Age").val(Data[iLLoop].split("Y")[0]);
    iLLoop=iLLoop+5;
    $("#CardNo").val(Data[iLLoop]);
    iLLoop=iLLoop+1;
    $("#VIPLevel").combobox('setValue',Data[iLLoop]);
    iLLoop=iLLoop+2;
    
    $("#PAPMICardType_DR_Name").combobox('setValue',Data[iLLoop]);
}
function OpenChargePanel()
{
    var RowId=$("#PIADM_RowId").val();
    var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",RowId,AdmType);
        
    
    var ZFTotalAmount=TotalAmount.split("�Է�:");
    
    var OpenCharge=$("#OpenCharge").checkbox('getValue');
        
    if(OpenCharge)
    {
        if (AdmType=="TEAM") return false;
        var GIADM=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetIADMbyPreIADM",RowId);
        if (GIADM=="") return false;
        var ZFUPTotalAmount=tkMakeServerCall("web.DHCPE.PreIADM","IsZFItemUPFee",RowId);
        
        //if(ZFTotalAmount[1]>0){
        if(ZFUPTotalAmount>0){  
        
        var lnk='dhcpeprecashier.hisui.csp?ADMType=I&GIADM='+GIADM;
        
        
        var wwidth=1250;
        var wheight=650;
    
    
        var xposition = (screen.width - wwidth) / 2;
        var yposition = ((screen.height - wheight) / 2)-10;
        var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
            +'height='+600+',width='+screen.width+',left='+xposition+',top='+yposition
            ;
    
    
    
        $HUI.window("#CashierWin",{
        title:"����շ�",
        modal:true,
        minimizable:false,
        maximizable:false,
        collapsible:false,
        width:1400,
        height:750,
        content:'<iframe src="dhcpeprecashier.hisui.csp?ADMType=I&GIADM='+GIADM+'" width="100%" height="99%" frameborder="0"></iframe>'
        });
        
        }
    }
}
function Register()
{
    var RowId=$("#PIADM_RowId").val();
    
    if(!RowId)
    {
        $.messager.alert("��ʾ","����ԤԼ��","info")
        return;
        
        
    }
    var AdmIdStr=RowId.split("^");
    var Rows=AdmIdStr.length;
    for(i=0;i<Rows;i++)
    { 
        var AdmId=AdmIdStr[i]
        var ret=tkMakeServerCall("web.DHCPE.DHCPEIAdm","UpdateIADMInfo",AdmId,"2")
    }

    //var ret=tkMakeServerCall("web.DHCPE.DHCPEIAdm","UpdateIADMInfo",RowId,"2");
    
    if(ret==0)
    {
        $.messager.alert("��ʾ","�Ǽǳɹ���","success",function (){
            
        //var myDiv=document.getElementById("ConfirmInfo");
        //myDiv.innerText="";
        
        var NoRefresh=$("#NoRefresh").checkbox('getValue');
        
        if((!NoRefresh)&&(PreItemList==0))
        {
            
            $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:"",AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""}); 
            
        }
        
        
        if(PreItemList==1)
        {
            $("#BRegister").hide();
        }
        
        $("#QrySet").datagrid('load',{ClassName:"web.DHCPE.HandlerOrdSetsEx",QueryName:"queryOrdSet",Set:$("#Set").val(),Type:"ItemSet"}); 
    

        $("#QryRisItm").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Item",TargetFrame:"PreItemList",Item:$("#Item").val(),StationID:$("#StationID").combobox("getValue")}); 
    

        $("#QryLisItm").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Lab",TargetFrame:"PreItemList",Item:$("#LisItem").val()}); 
    

        $("#QryOtherItm").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Other",TargetFrame:"PreItemList",Item:$("#OtherItem").val()}); 
    

        $("#QryMedicalItm").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Medical",TargetFrame:"PreItemList",Item:$("#MedicalItem").val()}); 
    
        $("#ZYBHistory").datagrid('load',{ClassName:"web.DHCPE.OccupationalDisease",QueryName:"FindOccuDiseaseHistory",PreIADM:""}); 
        
        $("#ZYHistory").datagrid('load',{ClassName:"web.DHCPE.OccupationalDisease",QueryName:"FindOccuHistory",PreIADM:""}); 

       
        var OpenCharge=$("#OpenCharge").checkbox('getValue');
        
        if(OpenCharge)
        {
            OpenChargePanel();
        }
        
        Clear_click();
        for(i=0;i<Rows;i++)
        { 
         var AdmId=AdmIdStr[i]
        
         PrintAllAppForHISUI(AdmId,"CRM"); 
        
        }
            
    
            
        } );
        
        

    }
    else {
        if(ret=="NoItem"){var ret="û��ԤԼ��Ŀ,���ܵǼ�!"}
        $.messager.alert("��ʾ",ret,"info");
        }
    
}
function InitPicture()
{
    
    var PAPMINo=""; 
    PAPMINo=$("#PAPMINo").val();
    var jsonData=$.cm({
    ClassName:"web.DHCPE.PreIADM",
    MethodName:"HISUIGetPatientID",
    "PAPMINo":PAPMINo
    
    },false);
    var PatientID=jsonData.PatientID;
    
    PEShowPicByPatientID(PatientID,"imgPic")  //DHCPECommon.js
    
    
  
}
function SetBFind_click()
{
    //alert(PreAdmId)
    $("#QrySet").datagrid('load',{ClassName:"web.DHCPE.HandlerOrdSetsEx",QueryName:"queryOrdSet",Set:$("#Set").val(),Type:"ItemSet",AdmId:$("#PIADM_RowId").val()}); 
    
}

function RisBFind_click()
{
    $("#QryRisItm").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Item",TargetFrame:"PreItemList",Item:$("#Item").val(),StationID:$("#StationID").combobox("getValue")}); 
    
}
function LisBFind_click()
{
    $("#QryLisItm").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Lab",TargetFrame:"PreItemList",Item:$("#LisItem").val()}); 
    
}


function OtherBFind_click()
{
    $("#QryOtherItm").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Other",TargetFrame:"PreItemList",Item:$("#OtherItem").val()}); 
    
}


function MedicalBFind_click()
{
    $("#QryMedicalItm").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Medical",TargetFrame:"PreItemList",Item:$("#MedicalItem").val()}); 
    
}
function DisableBtn(id,disabled){
    if (disabled){
        $HUI.linkbutton("#"+id).disable();
    }else{
        $HUI.linkbutton("#"+id).enable();
    }
}

var OverWriteFlag=""
function CardTypeKeydownHandler(){
    var SelValue=$HUI.combobox("#CardType").getValue();
    if (SelValue==""){return;}
    var myary=SelValue.split("^");
    var myCardTypeDR=myary[0];
     OverWriteFlag=myary[23];
    if (myCardTypeDR==""){return;}
    
    if (myary[16]=="Handle"){;
        $("#CardNo").attr("disabled",false);
        DisableBtn("ReadCard",true);
        $("#CardNo").focus();
    }else{
        $("#CardNo").attr("disabled",true);
        $("#CardNo").val("")
        
        DisableBtn("ReadCard",false);
        $("#ReadCard").focus();
        
        m_CCMRowID=GetCardEqRowIdA();
        
        var myobj=document.getElementById("CardNo");
        
        if (myobj){myobj.readOnly = false;} 
        
        var obj=document.getElementById("ReadCard");
        if (obj){
            obj.disabled = false;
        }
        DHCWeb_setfocus("ReadCard");
    }
}
/*
function BClear()
{
    Age  Name  PAPMINo
    
    Married_DR_Name
    $(".hisui-combobox").combobox('setValue',"");
    
}*/

function GetCardEqRowIdA(){
    var CardEqRowId="";
    
    var CardTypeValue=$HUI.combobox("#CardType").getValue();
    
    if (CardTypeValue!=""){
        var CardTypeArr=CardTypeValue.split("^")
        CardEqRowId=CardTypeArr[14];
    }
    return CardEqRowId;
}
function GetCardTypeRowId(){
    var CardTypeRowId="";
    var CardTypeValue=$HUI.combobox("#CardType").getValue();
    if (CardTypeValue!=""){
        var CardTypeArr=CardTypeValue.split("^")
        CardTypeRowId=CardTypeArr[0];
    }
    return CardTypeRowId;
}
function GetCardNoLength(){
    var CardNoLength="";
    var CardTypeValue=$HUI.combobox("#CardType").getValue();
    if (CardTypeValue!=""){
        var CardTypeArr=CardTypeValue.split("^");
        CardNoLength=CardTypeArr[17];
    }
    return CardNoLength;
}

function FormatCardNo(){
    var CardNo=DHCC_GetElementData("CardNo");
    if (CardNo!='') {
        var CardNoLength=GetCardNoLength();
        if ((CardNo.length<CardNoLength)&&(CardNoLength!=0)) {
            for (var i=(CardNoLength-CardNo.length-1); i>=0; i--) {
                CardNo="0"+CardNo;
            }
        }
    }
    return CardNo;
}


var CardPAPMINo="";
var myEquipDR="";
function ReadCardClickHandler(){
    var SelValue=$HUI.combobox("#CardType").getValue();
    if (SelValue==""){return;}
    var myary=SelValue.split("^");
    var myCardTypeDR=myary[0];
    if (myCardTypeDR==""){return;}
    
    var myary=SelValue.split("^");
     myEquipDR=myary[14];
    
    var rtn = DHCACC_GetAccInfoHISUI(myCardTypeDR, myEquipDR);
    
    
    
    var ReturnArr=rtn.split("^");
    
    if (ReturnArr[0]=="-200")
    {
         var cardvalue=rtn.split("^")[1];
        //$('#CardNo').val(cardvalue);
         return false;
    }
    CardPAPMINo=ReturnArr[5];
    $('#PAPMINo').val(ReturnArr[5]);
    RegNoOnChange();
    $('#CardNo').val(ReturnArr[1]);
    
    
    
}
function DHCACC_GetAccInfoHISUI(CardTypeDR, EquipDR)
{
    
    //var myrtn =DHCACC_ReadMagCard(EquipDR);
    
    var myrtn =DHCACC_ReadMagCard(EquipDR,"R", "23");
    
    var rtn=0;
    var myLeftM=0;
    var myAccRowID="";
    var myPAPMI="";
    var myPAPMNo=""
    var myCardNo="";
    var myCheckNo="";
    var myGetCardTypeDR="";
    var mySCTTip="";
    var myary=myrtn.split("^");
    var encmeth="";
    if (myary[0]==0){
        rtn=myary[0];
        myCardNo=myary[1];
        myCheckNo=myary[2];
    
            var myExpStr=""+String.fromCharCode(2)+CardTypeDR;
            var myrtn=tkMakeServerCall("web.UDHCAccManageCLSIF","getaccinfofromcardno",myCardNo,myCheckNo, myExpStr);
            
            var myary=myrtn.split("^");
            if(myary[0]==0)
            {
            rtn=myary[0];
            
            
            var myAccRowID=myary[1];
            var myLeftM=myary[3];
            var myPAPMI=myary[7];
            var myPAPMNo=myary[8];
            var myAccType=myary[10];
            var myAccGrpLeftM=myary[17]
            if (myary.length>12){
                myGetCardTypeDR=myary[12];
            }
            if (myary.length>13){
                mySCTTip = myary[13];
            }
            }
        
    }else{
        rtn=myary[0];
        
    }
    return rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo+"^"+myAccType+"^"+myAccRowID+"^"+myGetCardTypeDR+"^"+mySCTTip+"^"+myAccGrpLeftM;
}


function RegNoOnChange()
{               
                NetPreID="";
                $("#PIBI_RowId").val("");
                $("#PIADM_RowId").val("");
                var iPAPMINo=$("#PAPMINo").val();   
                if(iPAPMINo!="")
                {
                    iPAPMINo = RegNoMask(iPAPMINo); 
                    var flag=tkMakeServerCall("web.DHCPE.PreIADM","JudgeIGByRegNo",iPAPMINo)
                    if(flag=="G"){
                        $.messager.popover({msg: "�õǼǺ��������壬��������ԤԼ�������", type: "info"});
    
                        return false;
                    }
                    iPAPMINo="^"+iPAPMINo+"^";
                }
                
                var SelValue=$HUI.combobox("#CardType").getValue();
                if (SelValue==""){return;}
                var myary=SelValue.split("^");
                var myCardTypeDR=myary[0];
                if (myCardTypeDR==""){return;}
                var jsonData=$.cm({
                ClassName:"web.DHCPE.PreIADM",
                MethodName:"HISUIDocListBroker",
                "itmjs":"",
                "itmjsex":"",
                "InString":iPAPMINo,
                "CardType":myCardTypeDR,
                "HospID":session['LOGON.HOSPID']
                },false);
                
                var Data=jsonData.ret;
                
                SetPatient_Sel(Data);
    
    
}


$("#CardNo").keydown(function(e) {
if(e.keyCode==13){
        
    var ClearFlag=0
    var CardNo="",SelectCardTypeRowID="";
    var CardNo=$("#CardNo").val();
    if (CardNo=="") return;
    if (ClearFlag=="1") eval(Clear_click());
    $("#CardNo").val(CardNo)
    
    var SelValue=$HUI.combobox("#CardType").getValue();
    if (SelValue==""){return;}
    var myary=SelValue.split("^");
    var myCardTypeDR=myary[0];
    if (myCardTypeDR==""){return;}
    SelectCardTypeRowID=myCardTypeDR;
    CardNo=CardNo+"$"+SelectCardTypeRowID;
    var RegNo=tkMakeServerCall("web.DHCPE.PreIBIUpdate","GetRelate",CardNo,"C");
    if (RegNo=="") {
        $.messager.alert("��ʾ","δ�ҵ���¼!","info");
        Clear_click();
        return;
    }
    $("#PAPMINo").val(RegNo);
    eval(RegNoOnChange());
    
            }
            
});



function CardNoOnChange()
{
    
    CardNoChangeAppHISUI("PAPMINo","CardNo","RegNoOnChange()","Clear_click()","0");
    
}

function CardNoChangeAppHISUI(RegNoElement,CardElement,AppFunction,AppFunctionClear,ClearFlag)
{
    
    var obj;
    var CardNo="",SelectCardTypeRowID="";
    obj=document.getElementById(CardElement);
    if (obj) CardNo=obj.value;
    if (CardNo=="") return;
    if (ClearFlag=="1") eval(AppFunctionClear);
    obj.value=CardNo;
    
    var SelValue=$HUI.combobox("#CardType").getValue();
    if (SelValue==""){return;}
    var myary=SelValue.split("^");
    var myCardTypeDR=myary[0];
    if (myCardTypeDR==""){return;}
    SelectCardTypeRowID=myCardTypeDR;
    
    CardNo=CardNo+"$"+SelectCardTypeRowID;
    
    RegNo=tkMakeServerCall("web.DHCPE.PreIBIUpdate","GetRelate",CardNo,"C");
    
    if (RegNo=="") {
        $.messager.alert("��ʾ","δ�ҵ���¼!","info");
        Clear_click();
        return;
    }

    obj=document.getElementById(RegNoElement);
    if (obj)
    {
        obj.value=RegNo;
        eval(AppFunction);
    }
}


function Clear_click()
{
    $("#preiadmform").form("clear");
    var valbox = $HUI.validatebox("#Name", {
            required: false,
        });
    var valbox = $HUI.datebox("#DOB", {
            required: false,
        });
    var valbox = $HUI.combobox("#Sex_DR_Name", {
            required: false,
        });
     var valbox = $HUI.validatebox("#MobilePhone", {
            required: false,
        });

    $("#jbinfo").form("clear");
    $("#ZYBform").form("clear");
    $("#DHistory").form("clear");
    $("#ZYform").form("clear");

    var src="../images/uiimages/patdefault.png"
     PEShowPicBySrc(src,"imgPic");
    var myDiv=document.getElementById("TotalFee");
    myDiv.innerText="0Ԫ";
    LoadCard(); 
    SetDefault();
    
    var CopyFlag=$("#NoRefresh").checkbox('getValue');
    if(!CopyFlag){
        $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:$("#PIADM_RowId").val(),AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""});
        $("#Old_RowId").val("");
    }
    
}

function LoadCard()
{
    var HospID=session['LOGON.HOSPID'];
    $.m({
            ClassName:"web.UDHCOPOtherLB",
            MethodName:"ReadCardTypeDefineListBroker",
            JSFunName:"GetCardTypeToHUIJson",
            ListName:"",
            SessionStr:"^^^^"+HospID
        },function(val){
            
            var ComboJson=JSON.parse(val); 
            
            $HUI.combobox('#CardType',{
                data:ComboJson,
                valueField:'id',    
                textField:'text',
            onSelect:function(record){
                CardTypeKeydownHandler();
            }
        });
        CardTypeKeydownHandler();
        });
    
    
}

function AddItem(arcitem)
{

        var RowIdStr=$("#PIADM_RowId").val()
        //alert(RowIdStr)   
        if(RowIdStr=="")
            {
                $.messager.alert("��ʾ","����ԤԼ��","info");
                return false;
            }
            
        var AdmIdStr=RowIdStr.split("^");
        var Rows=AdmIdStr.length;
        
        for(i=0;i<Rows;i++)
        {   
            var RowId=AdmIdStr[i]
            var ItemId=arcitem;

            var GAAuditedFlag=tkMakeServerCall("web.DHCPE.ResultEdit","GeneralAdviceAudited",RowId,"CRM");
            if(GAAuditedFlag=="1") {
                $.messager.alert("��ʾ","�ܼ콨���Ѿ����,���ܼ�������","info");
                return false;
            }
            
             var IsAddItemFlagStr=tkMakeServerCall("web.DHCPE.HISUICommon","IsRecPaper",RowId,session['LOGON.CTLOCID']);
            var IsRecPaperFlag=IsAddItemFlagStr.split("^")[0];
            var IsAddItemFlag=IsAddItemFlagStr.split("^")[1];
             if((IsAddItemFlag!="Y")&&(IsRecPaperFlag=="1")){
                 $.messager.alert("��ʾ","�Ѿ��ձ�,���ܼ���","info");
                  return false;
             }

            var IsAddPhc=tkMakeServerCall("web.DHCPE.PreItemList","IsAddPhcItem",RowId,AdmType,ItemId,PreOrAdd);
            if(IsAddPhc=="1") {
                 if("PERSON"==AdmType){
                    $.messager.alert("��ʾ","���˲������ҩ","info");
                    return false;
                  }
                 if("TEAM"==AdmType){
                    $.messager.alert("��ʾ","���鲻�����ҩ","info");
                    return false;
                  }
            }
            
            
            var flagret=tkMakeServerCall("web.DHCPE.PreItemList","IsExistItem",RowId,AdmType,ItemId);
            var flagArr=flagret.split("^");
            var flag=flagArr[0];
           
           
            if ("1"==flag) 
            {
                
            
                if (flagArr[1]=="1")
                {
                    
                    $.messager.confirm("������ʾ", "��Ŀ�Ѵ���,�Ƿ�������?", function (data) {
                    if (data) {
            var UserId=session['LOGON.USERID'];
            $.cm({
            ClassName:"web.DHCPE.PreItemList",
            MethodName:"HISUIIInsertItem",
            "AdmId":RowId,
            "AdmType":AdmType,
            "PreOrAdd":PreOrAdd,
            "ArcItemId":ItemId,
            "ArcItemSetId":"",
            "UpdateUserId":UserId
            },function(jsonData){
                if(jsonData.ret=="")
                {
                    $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:$("#PIADM_RowId").val(),AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""}); 
                    var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetOrdAmountHISUI",RowId,AdmType);
                    var GZAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",RowId,AdmType);
                    var myDiv=document.getElementById("TotalFee");
                    myDiv.innerText=TotalAmount;
                    var ConfirmInfo=tkMakeServerCall("web.DHCPE.PreItemList","GetItemName",RowId,AdmType);
                    var myDiv=document.getElementById("ConfirmInfo");
                    myDiv.innerText=ConfirmInfo;
                }
                else
                {
                    
                    $.messager.alert("��ʾ",jsonData.ret,"info");
                }
            
            });
                    }
                    else {
                        return false;
                    }
                    });
                    
                }else
                {
                    $.messager.alert("��ʾ","��Ŀ�Ѵ���,����������.","info");
                    return false;
                }
            }
            else if("2"==flag)
            {
                $.messager.alert("��ʾ","��Ŀ�еĻ�����Ŀ,��������Ŀ���ظ�,�Ƿ�������?","info"    )
                return false;
            }
            
            if (flagArr[1]=="1")
            {return false;}
            
            
            var ItemFlag;
            ItemFlag=tkMakeServerCall("web.DHCPE.PreItemList","ItemCanPreInfo",RowId,AdmType,ItemId)
         
            var ItemCanFlag=ItemFlag.split(",")
            
            if (ItemCanFlag[0]==-1)
            {    
                var ItemCanStr=""
                for(i=1;i<ItemCanFlag.length;i++){
                    if(ItemCanStr=="") {var ItemCanStr=ItemCanFlag[i];}
                    else {var ItemCanStr=ItemCanStr+","+ItemCanFlag[i];}
                }
        
                $.messager.confirm("������ʾ",ItemCanStr,function (data) {
                    if (data) {
            var UserId=session['LOGON.USERID'];
            $.cm({
            ClassName:"web.DHCPE.PreItemList",
            MethodName:"HISUIIInsertItem",
            "AdmId":RowId,
            "AdmType":AdmType,
            "PreOrAdd":PreOrAdd,
            "ArcItemId":ItemId,
            "ArcItemSetId":"",
            "UpdateUserId":UserId
            },function(jsonData){
                if(jsonData.ret=="")
                {
                    $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:$("#PIADM_RowId").val(),AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""}); 
                    var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetOrdAmountHISUI",RowId,AdmType);
                    var GZAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",RowId,AdmType);
                    var myDiv=document.getElementById("TotalFee");
                    myDiv.innerText=TotalAmount;
                    var ConfirmInfo=tkMakeServerCall("web.DHCPE.PreItemList","GetItemName",RowId,AdmType);
                    var myDiv=document.getElementById("ConfirmInfo");
                    myDiv.innerText=ConfirmInfo;
                }
                else
                {
                    
                    $.messager.alert("��ʾ",jsonData.ret,"info");
                }
            
            });
                    }
                    else {
                        return false;
                    }
                    });
                 
            }
            
            if (ItemCanFlag[0]==-1)
            {return false;}
            
            var UserId=session['LOGON.USERID'];
            $.cm({
            ClassName:"web.DHCPE.PreItemList",
            MethodName:"HISUIIInsertItem",
            "AdmId":RowId,
            "AdmType":AdmType,
            "PreOrAdd":PreOrAdd,
            "ArcItemId":ItemId,
            "ArcItemSetId":"",
            "UpdateUserId":UserId
            },function(jsonData){
                
                if(jsonData.ret=="")
                {
                    
                   
                    $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:$("#PIADM_RowId").val(),AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""}); 
                    
                    var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetOrdAmountHISUI",RowId,AdmType);
                    var GZAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",RowId,AdmType);
                    var myDiv=document.getElementById("TotalFee");
                    
                    myDiv.innerText=TotalAmount;
                    var ConfirmInfo=tkMakeServerCall("web.DHCPE.PreItemList","GetItemName",RowId,AdmType);
                    var myDiv=document.getElementById("ConfirmInfo");
                    myDiv.innerText=ConfirmInfo;
                    
                }
                else
                {
                    
                
                    
                    $.messager.alert("��ʾ",jsonData.ret,"info");
                }
                
            });
        }
}

//ɾ����Ŀ
function DeleteOrdItem_Click()
{
    var rows = $("#PreItemList").datagrid("getChecked");//��ȡ�������飬��������
    if(rows.length==0){
        $.messager.alert("��ʾ","��ѡ���ɾ������Ŀ���ײ�","info");
        return false; 
    }

    for(var i=0;i<rows.length;i++){
        var ItemID=rows[i].RowId;
        var SetsID=rows[i].OrderEntId;
        //alert(ItemID+"^"+SetsID)
        DeleteItemSet(ItemID+"^"+SetsID);
    }
}

function DeleteItemSet(value)
{
        
        var ordItemId=value.split("^")[0];
        
        var ordEntId=value.split("^")[1];
        
        var OrderType="ORDERITEM";
        var AddAmountFlag="0";
        if (ordEntId!="")  OrderType="ORDERENT";
        
        
        if (OrderType=="ORDERITEM") {ordEntId=""};
        if (OrderType=="ORDERENT") {ordItemId=""};
        
        
        var gAdmType=AdmType;
        var AddAmountFlag=0;
        var gAdmId=$("#PIADM_RowId").val();
        
        var AdmIdStr=gAdmId.split("^");

        var Rows=AdmIdStr.length;
        for(i=0;i<Rows;i++)
        { 
        var AdmId=AdmIdStr[i]
        
        
        if (gAdmType=="PERSON"){
               
            if (ordItemId!="")
            {
                var ordItemIdNew=tkMakeServerCall("web.DHCPE.PreItemList","GetARCIMbyOEOrd",AdmId,ordItemId,"Item");
                
                var ordEntIdNew="";
            }
            if (ordEntId!="")
            {
                var ordEntIdNew=tkMakeServerCall("web.DHCPE.PreItemList","GetARCIMbyOEOrd",AdmId,ordEntId,"Ent");
                
                var ordItemIdNew="";
            }
        }
        else 
        {    
            ordItemIdNew=ordItemId;
            ordEntIdNew=ordEntId;
        }
        if((ordItemIdNew=="")&&(ordEntIdNew=="")){return false;}
        var flag=tkMakeServerCall("web.DHCPE.PreItemList","IDeleteItem",AdmId,gAdmType,ordItemIdNew,ordEntIdNew,AddAmountFlag)
        if(flag!="") {  
            var fflag="";
            var fflag=flag.split("^")[0];
            if(fflag=="1"){var fflag="����Ŀ�ѽ���!";}
            if(fflag=="2"){alert("�Ѿ��ܼ���˲���ɾ��")}
            if(fflag=="3"){var fflag="����Ŀ��ִ��!";}
            if(fflag=="4"){alert("�����и��˴���ִ�й�����Ŀ")}
            if(fflag=="6"){alert("�ѷ�ҩ����ɾ��")}
            $.messager.alert("��ʾ",fflag,"info");
            return false;
        }
    
        $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:$("#PIADM_RowId").val(),AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""}); 
        var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetOrdAmountHISUI",AdmId,AdmType);
        var GZAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",AdmId,AdmType);
        var myDiv=document.getElementById("TotalFee");
        myDiv.innerText=TotalAmount;
        var ConfirmInfo=tkMakeServerCall("web.DHCPE.PreItemList","GetItemName",$("#PIADM_RowId").val(),AdmType);
        var myDiv=document.getElementById("ConfirmInfo");
        if (myDiv){myDiv.innerText=ConfirmInfo;}

        }
}
/*
function ReadRegInfo_OnClick()
  { 
    
    var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
    var rtn=tkMakeServerCall("DHCDoc.Interface.Inside.Service","GetIECreat")
    var myHCTypeDR=rtn.split("^")[0];
    

    var myInfo=DHCWCOM_PersonInfoRead(myHCTypeDR);
    

    var myary=myInfo.split("^");
    
    if(myary=="0")
    {
        $.messager.alert("��ʾ","����ʧ�ܻ���û�ж�������","info");
        return false;
    }
    
    if (myary[0]=="0")
    { 
      
      SetPatInfoByXML(myary[1]); 
      
      var mySexobj=document.getElementById("Sex");
      if (mySexobj){$("#Sex_DR_Name").combobox('setValue',mySexobj.value);}
      var myBirobj=document.getElementById("Birth");
        if(myBirobj){
        var mybirth=myBirobj.value;
          if (dtformat=="YMD"){
             if (mybirth.length==10){
            var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(5,7)+"-"+mybirth.substring(8,10)
            }else{
            var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8) 
            }
        }
        if (dtformat=="DMY"){
            if (mybirth.length==10){
                var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(5,7)+"-"+mybirth.substring(8,10)
            }else{
                var mybirth=mybirth.substring(6,8)+"/"+mybirth.substring(4,6)+"/"+mybirth.substring(0,4)
            }
        }
      }
    if (myBirobj){$("#DOB").datebox('setValue',myBirobj.value);}
     
      var mycredobj=document.getElementById("CredNo");
      var myidobj=document.getElementById('IDCard');
        if ((mycredobj)&&(myidobj)){
            myidobj.value=mycredobj.value;
            
        }   
     }
     
    
    var photoobj=document.getElementById("PhotoInfo");
    if ((photoobj)&&(photoobj.value!="")){
        
        var src="data:image/png;base64,"+photoobj.value;
        document.getElementById("imgPic").innerHTML='<img SRC=data:image/png;base64,'+photoobj.value+' BORDER="0" width=120 height=140>'
    }
    else{
        var src='c://'+mycredobj.value+".bmp";
        var NoExistSrc="../images/uiimages/patdefault.png"; // //û�б�����Ƭʱ��ʾ��ͼƬ
        document.getElementById("imgPic").innerHTML='<img SRC='+src+' BORDER="0" width=120 height=140 onerror=this.src="'+NoExistSrc+'">'
    
    
    }
    
    IDCardOnChange();

   }
   
function SetPatInfoByXML(XMLStr)
{
    XMLStr = "<?xml version='1.0' encoding='gb2312'?>" + XMLStr
    var xmlDoc=DHCDOM_CreateXMLDOMNew(XMLStr);
    if (!xmlDoc) return;
    
    //var xmlDoc=DHCDOM_CreateXMLDOM();
    //xmlDoc.async = false;
    //xmlDoc.loadXML(XMLStr);
    
    //if(xmlDoc.parseError.errorCode != 0) 
    //{    
        //$.messager.alert("��ʾ",xmlDoc.parseError.reason,"info");
        //return; 
    //}
    
    var nodes = xmlDoc.documentElement.childNodes;
    if (nodes.length<=0){return;}
    for (var i = 0; i < nodes.length; i++) {

        
        //var myItemName=nodes(i).nodeName;
        //var myItemValue= nodes(i).text;
        
        var myItemName = getNodeName(nodes,i);
        
        var myItemValue = getNodeValue(nodes,i);
        if(myItemName=="Name") $("#Name").val(myItemValue);
        if(myItemName=="Address") $("#Address").val(myItemValue);
      
      
        
        
        if (myCombAry[myItemName]){
            myCombAry[myItemName].setComboValue(myItemValue);

        }else{
            DHCWebD_SetObjValueXMLTrans(myItemName, myItemValue);
        }
    }
    delete(xmlDoc);
}
*/
function ReadRegInfo_OnClick()
  { 
    
    var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
    var rtn=tkMakeServerCall("DHCDoc.Interface.Inside.Service","GetIECreat")
    var myHCTypeDR=rtn.split("^")[0];
    
    var myInfo=DHCWCOM_PersonInfoRead(myHCTypeDR);

    var myary=myInfo.split("^");
    
    if(myary=="0")
    {
        $.messager.alert("��ʾ","����ʧ�ܻ���û�ж�������","info");
        return false;
    }
    
    if (myary[0]=="0")
    { 
      
      SetPatInfoByXML(myary[1]); 
      
      var PhotoInfo=$("#PhotoInfo").val();
      if (PhotoInfo!=""){
        
        var src="data:image/png;base64,"+PhotoInfo;
        document.getElementById("imgPic").innerHTML='<img SRC=data:image/png;base64,'+PhotoInfo+' BORDER="0" width=120 height=140>'
     }
     else{
        var src='c://'+$("#IDCard").val()+".bmp"
        var NoExistSrc="../images/uiimages/patdefault.png"; // //û�б�����Ƭʱ��ʾ��ͼƬ
        document.getElementById("imgPic").innerHTML='<img SRC='+src+' BORDER="0" width=120 height=140 onerror=this.src="'+NoExistSrc+'">'
        }
     }
     
    
    IDCardOnChange();

   }
function SetPatInfoByXML(XMLStr)
{
    XMLStr = "<?xml version='1.0' encoding='gb2312'?>" + XMLStr
    var xmlDoc=DHCDOM_CreateXMLDOMNew(XMLStr);
    if (!xmlDoc) return;
    
  
    var nodes = xmlDoc.documentElement.childNodes;
    if (nodes.length<=0){return;}
    for (var i = 0; i < nodes.length; i++) {

        var myItemName = getNodeName(nodes,i);
        
        var myItemValue = getNodeValue(nodes,i);
    
        //����
        if(myItemName=="Name") {$("#Name").val(myItemValue);}
        //��ַ
        if(myItemName=="Address") {$("#Address").val(myItemValue);}
        //�Ա�
        if(myItemName=="Sex") $("#Sex_DR_Name").combobox('setValue',myItemValue);
        
       
       //��������
       if(myItemName=="Birth") 
        {
            var mybirth=myItemValue;
        if(mybirth!=""){
          if (dtformat=="YMD"){
             if (mybirth.length==10){
            var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(5,7)+"-"+mybirth.substring(8,10)
            }else{
            var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8) 
            }
        }
        if (dtformat=="DMY"){
            if (mybirth.length==10){
                var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(5,7)+"-"+mybirth.substring(8,10)
            }else{
                var mybirth=mybirth.substring(6,8)+"/"+mybirth.substring(4,6)+"/"+mybirth.substring(0,4)
            }
        }
         }
            $("#DOB").val(mybirth);
        }
        
    //���֤��
     if(myItemName=="CredNo") {$("#IDCard").val(myItemValue);}
    
    //��Ƭ
     if(myItemName=="PhotoInfo") {$("#PhotoInfo").val(myItemValue);}
      
        
        
        if (myCombAry[myItemName]){
            myCombAry[myItemName].setComboValue(myItemValue);

        }else{
           // DHCWebD_SetObjValueXMLTrans(myItemName, myItemValue); //��װ�Ĺȸ��������֧��
        }
    }
    delete(xmlDoc);
}

var NetPreID="";
var NetSetsID="";
function IDCardOnChange()
{
    
    var IDCard=$("#IDCard").val();
    var iPAPMICardType=$("#PAPMICardType_DR_Name").combobox('getText');
    if(iPAPMICardType.indexOf("���֤")!="-1") {
        var RegNo=tkMakeServerCall("web.DHCPE.PreIBaseInfo","GetRegNoByIDCard",IDCard);
        if (RegNo==""){
            //SetDefault();
            
            if($("#PAPMINo").val()!="")
            {
                $.messager.alert("��ʾ","���������ͻ���Ϣ�����潫����գ�","info"); 
                Clear_click();
                
            }
            
            if(IDCard!=""){ 
                var ret=isIdCardNo(IDCard);
                if(ret==true){
                    GetInfoByIdCard(IDCard)
                    $("#IDCard").val(IDCard);
                }
            }
            
            FindPreInfoByIDCard(IDCard);
            return false;
        }
        
        $("#PAPMINo").val(RegNo)
        RegNoOnChange();

        FindPreInfoByIDCard(IDCard);
    }
    return false;

}

$("#IDCard").keydown(function(e) { 
    if(e.keyCode==13){
            
        var IDCard=$("#IDCard").val();
        var iPAPMICardType=$("#PAPMICardType_DR_Name").combobox('getText');
        if(iPAPMICardType.indexOf("���֤")!="-1") {
        var RegNo=tkMakeServerCall("web.DHCPE.PreIBaseInfo","GetRegNoByIDCard",IDCard);
        if (RegNo==""){
            //SetDefault();
            if($("#PAPMINo").val()!="")
            {
                $.messager.alert("��ʾ","���������ͻ���Ϣ�����潫����գ�","info"); 
                Clear_click(); 
            }
            
            if(IDCard!=""){ 
                var ret=isIdCardNo(IDCard);
                if(ret==true){
                    GetInfoByIdCard(IDCard)
                    $("#IDCard").val(IDCard);
                }
            }
            
            FindPreInfoByIDCard(IDCard);
            return false;
        }
    
             $("#PAPMINo").val(RegNo)
            RegNoOnChange();
        
        FindPreInfoByIDCard(IDCard);
    }
    return false;
            }
            
  });



function GetInfoByIdCard(num)
{
    
    if (num=="") return true;
    var len = num.length;
    var re; 
    var ShortNum=num.substr(0,num.length-1)
    var ShortNum=ShortNum+"1"
    if (len == 15) re = new RegExp(/^(\d{6})()?(\d{2})(\d{2})(\d{2})(\d{2})$/);
    else if (len == 18) re = new RegExp(/^(\d{6})()?(\d{4})(\d{2})(\d{2})(\d{3})(\d)$/);
    var a = (ShortNum).match(re);
    
    if (a != null)
    {
        
    if (len==15)
        {
            var D = new Date("19"+a[3]+"/"+a[4]+"/"+a[5]);
            var B = D.getFullYear()==a[3]&&(D.getMonth()+1)==a[4]&&D.getDate()==a[5];
        }
        else
        {
            var D = new Date(a[3]+"/"+a[4]+"/"+a[5]);
            var B = D.getFullYear()==a[3]&&(D.getMonth()+1)==a[4]&&D.getDate()==a[5];
        }
        var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
        if (dtformat=="YMD"){
            var mybirth=a[3]+"-"+a[4]+"-"+a[5];
        }else if (dtformat=="DMY"){
            var mybirth=a[5]+"/"+a[4]+"/"+a[3];
        }
       
        //var obj=document.getElementById("DOB");
        //if(obj){obj.value=mybirth;}
       $("#DOB").datebox('setValue',mybirth)
        var Dateinit=new Date           
        var Yearinit=Dateinit.getFullYear();
        var Year=Yearinit-a[3]
        
        var myAge=tkMakeServerCall("web.DHCDocCommon","GetAgeDescNew",mybirth,"")

        //DHCWebD_SetObjValueA("Age",myAge);
        $("#Age").val(myAge)
        if (len==15)
        {
            var SexFlag=num.substr(14,1);
        }
        else
        {
            var SexFlag=num.substr(16,1);
        }
        var SexNV=""
        var JsonData=$.cm({
        ClassName:"web.DHCPE.HISUICommon",
        MethodName:"GetDefault"
        },false);
        
        var SexNV=JsonData.ret;
        
        SexNV=SexNV.split("^");
        
        
        if (SexFlag%2==1)
        {
            $("#Sex_DR_Name").combobox('setValue',SexNV[2]);
            
        }
        else
        {
            $("#Sex_DR_Name").combobox('setValue',SexNV[3]);
            
        }
        
    }
    return true;
}
function FindPreInfoByIDCard(IDCard)
{
    var LocID=session['LOGON.CTLOCID'];
    var ID="";
    var obj=document.getElementById("ID");
    if (obj) ID=obj.value;
    if (ID!="") return false;
    var Info=tkMakeServerCall("web.DHCPE.NetPre.GetPreInfo","GetInfo",IDCard,LocID);

    if (Info=="") return false;
    var Arr=Info.split("^");
    NetPreID=Arr[0];
    NetSetsID=Arr[1];
    var PreDate=Arr[2];
    if(PreDate!=""){
        $('#PEDateBegin').val(PreDate);
    }
    
    var obj=document.getElementById("Name");
    if (obj&&obj.value=="") obj.value=Arr[3];
    var obj=document.getElementById("Sex_DR_Name");
    if (obj) obj.value=Arr[4];
    $("#VIPLevel").combobox('setValue',Arr[5]);
    VIPLevelOnChange();
    var obj=document.getElementById("PETime");
    if (obj) obj.value=Arr[6];
    var obj=document.getElementById("MobilePhone");
    if (obj&&obj.value=="") obj.value=Arr[7];
    var obj=document.getElementById("Tel1");
    //if (obj&&obj.value=="") obj.value=Arr[7];
    if (obj&&obj.value=="") obj.value="";
    var obj=document.getElementById("PAPMINo");
    if (obj&&obj.value==""){
        obj.value=Arr[8];
    }
}
/*
function isIdCardNo(num) {
    
    if (num=="") return true;
    var ShortNum=num.substr(0,num.length-1)
    if (isNaN(ShortNum))
    {
        alert("����Ĳ�������?");
        return false;
    }
    var len = num.length;
    var re;
    if (len == 15) re = new RegExp(/^(\d{6})()?(\d{2})(\d{2})(\d{2})(\d{2})$/);
    else if (len == 18) re = new RegExp(/^(\d{6})()?(\d{4})(\d{2})(\d{2})(\d{3})(\d)$/);
    else {alert("���֤�����������λ������?");
    websys_setfocus("IDCard");
    return false;}
    var ShortNum=ShortNum+"1"
    var a = (ShortNum).match(re);
    
    if (a != null)
    {
        if (len==15)
        {
            var D = new Date("19"+a[3]+"/"+a[4]+"/"+a[5]);
            var B = D.getFullYear()==a[3]&&(D.getMonth()+1)==a[4]&&D.getDate()==a[5];
        }
        else
        {
            var D = new Date(a[3]+"/"+a[4]+"/"+a[5]);
            var B = D.getFullYear()==a[3]&&(D.getMonth()+1)==a[4]&&D.getDate()==a[5];
        }
        if (!B)
        {
            alert("��������֤�� "+ a[0] +" ��������ڲ���?");
            websys_setfocus("IDCard");
            return false;
        }
        
        var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
        if (dtformat=="YMD"){
            var mybirth=a[3]+"-"+a[4]+"-"+a[5];
        }else if (dtformat=="DMY"){
            var mybirth=a[5]+"/"+a[4]+"/"+a[3];
        }
        
        $("#DOB").datebox('setValue',mybirth);
        
        var Dateinit=new Date;  
        var Yearinit=Dateinit.getFullYear();
        var Year=Yearinit-a[3]
        
        var myAge=tkMakeServerCall("web.DHCDocCommon","GetAgeDescNew",mybirth,"")
        
        DHCWebD_SetObjValueA("Age",myAge);

        if (len==15)
        {
            var SexFlag=num.substr(14,1);
        }
        else
        {
            var SexFlag=num.substr(16,1);
        }
        
        var JsonData=$.cm({
        ClassName:"web.DHCPE.HISUICommon",
        MethodName:"GetDefault"
        },false);
        
        var SexNV=JsonData.ret;
        
        SexNV=SexNV.split("^");
        
        
        if (SexFlag%2==1)
        {
            
            $('#Sex_DR_Name').combobox('setValue',SexNV[2]);
        }
        else
        {
            
            $('#Sex_DR_Name').combobox('setValue',SexNV[3]);
        }
        
    }
    return true;
}
*/
function isIdCardNo(pId){
    pId=pId.toLowerCase();
    var arrVerifyCode = [1,0,"x",9,8,7,6,5,4,3,2]; 
    var Wi = [7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2]; 
    var Checker = [1,9,8,7,6,5,4,3,2,1,1]; 
    if(pId.length != 15 && pId.length != 18){
         $.messager.alert("��ʾ","���֤�Ź���15λ��18λ","info"); 
        return false;
    }
    var Ai=pId.length==18?pId.substring(0,17):pId.slice(0,6)+"19"+pId.slice(6,15); 
    
    if (!/^\d+$/.test(Ai))
    {
         $.messager.alert("��ʾ","���֤�����һλ�����Ϊ����","info");
        return false;
    }
    var yyyy=Ai.slice(6,10), mm=Ai.slice(10,12)-1, dd=Ai.slice(12,14);
    var d=new Date(yyyy,mm,dd) , now=new Date(); 
    var year=d.getFullYear() , mon=d.getMonth() , day=d.getDate();
    if (year!=yyyy||mon!=mm||day!=dd||d>now||year<1901){
        $.messager.alert("��ʾ","���֤�������","info");
        return false;
    }
    for(var i=0,ret=0;i<17;i++) ret+=Ai.charAt(i)*Wi[i]; 
    Ai+=arrVerifyCode[ret%=11];
    
    if (pId.length == 18){
        if(!validId18(pId)){
             $.messager.alert("��ʾ","���֤��������,����!","info");
            return false;
        }
    }
    if (pId.length == 15){
        if(!validId15(pId)){
             $.messager.alert("��ʾ","���֤��������,����!","info");
            return false;
        }
    }
    return true;
}

function GetInfoFromIDCard(pId){
     
    var pId=Get18IdFromCardNo(pId)
    if (pId==""){
            return ["0","","","","","",""];
        }
    
    var id=String(pId);
    if (id.length==18){
        var sex=id.slice(14,17)%2?"��":"Ů";
            
        var prov="";
        
        var myMM=(id.slice(10,12)).toString();
        var myDD=id.slice(12,14).toString();
        var myYY=id.slice(6,10).toString();
      }else{
        var prov="";
        var sex=id.slice(14,15)%2?"��":"Ů";
        var myMM=(id.slice(8,10)).toString();
        var myDD=id.slice(10,12).toString();
        var myYY=id.slice(6,8).toString();
            if(parseInt(myYY)<10) {
                myYY = '20'+myYY;
            }else{
                myYY = '19'+myYY;
            } 
        
      }
    var myMM=myMM.length==1?("0"+myMM):myMM;
    var myDD=myDD.length==1?("0"+myDD):myDD;
    var sysDateFormat=tkMakeServerCall('websys.Conversions','DateFormat');
    if (sysDateFormat=="3"){
        var birthday=myYY+"-"+ myMM +"-"+myDD;
    }
    if (sysDateFormat=="4"){
        var birthday=myDD+"/"+ myMM +"/"+myYY;
    }
    var myAge=DHCWeb_GetAgeFromBirthDayA(birthday);
    
    return ["1",prov,birthday,sex, myAge];
}

function Get18IdFromCardNo(pId){
    
    pId=pId.toLowerCase();
    
    var arrVerifyCode = [1,0,"x",9,8,7,6,5,4,3,2]; 
    var Wi = [7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2]; 
    var Checker = [1,9,8,7,6,5,4,3,2,1,1]; 

    if(pId.length != 15 && pId.length != 18){
        alert("���֤�Ź��� 15λ��18λ"); 
        return "";
    }
    if (pId.length == 18){
        if(!validId18(pId)){
            alert("���֤��������,����!");
            return "";
        }
    }
    if (pId.length == 15){
        if(!validId15(pId)){
            alert("���֤��������,����!");
            return "";
        }
    }
    var Ai=pId.length==18?pId.substring(0,17):pId.slice(0,6)+"19"+pId.slice(6,15); 
    
    if (!/^\d+$/.test(Ai))
    {
        alert("���֤�����һλ�����Ϊ����");
        return "";
    }
    var yyyy=Ai.slice(6,10), mm=Ai.slice(10,12)-1, dd=Ai.slice(12,14);
    var d=new Date(yyyy,mm,dd) , now=new Date(); 
    var year=d.getFullYear() , mon=d.getMonth() , day=d.getDate();
    if (year!=yyyy||mon!=mm||day!=dd||d>now||year<1901){
        alert( "���֤�������");
        return "";
    }
    
    
    for(var i=0,ret=0;i<17;i++) ret+=Ai.charAt(i)*Wi[i]; 
    Ai+=arrVerifyCode[ret%=11];
    
    return Ai;
}

function BSetDefaultVIP_click()
{
    
   var VIP=$("#VIPLevel").combobox('getValue');
   var ret=tkMakeServerCall("web.DHCPE.VIPLevel","SetDefaultVIP",session['LOGON.USERID'],VIP);
   if(ret==0) {
        $.messager.alert("��ʾ","���óɹ�","success");
        var DefaultVIP=tkMakeServerCall("web.DHCPE.HISUICommon","GetDefaultVIP",session['LOGON.USERID']);
        $("#DefaultVIP").html(DefaultVIP);

   }
   else{$.messager.alert("��ʾ","����ʧ��","error");}
   
}

function VIPLevelOnChange()
{
    
    var obj=document.getElementById("VIPLevel");
    if (obj){
        var VIPLevel=$("#VIPLevel").combobox('getValue');
        
        if (VIPLevel=="") return false;
        var PatType=tkMakeServerCall("web.DHCPE.VIPLevel","GetPatFeeType",VIPLevel)
        if (PatType!=""){
            var obj=document.getElementById("PatFeeType_DR_Name");
            if (obj) $('#PatFeeType_DR_Name').combobox('setValue',PatType);
        }
        var DefaultRoomPlace=tkMakeServerCall("web.DHCPE.RoomManagerEx","GetDefaultRoomPlace",VIPLevel,"I");
        var obj=document.getElementById("RoomPlace");
        if (obj) { $('#RoomPlace').combobox('setValue',DefaultRoomPlace);}
        
        $('#RoomPlace').combobox('reload');
        
        
    }
    
}

function OpenCharge_change(value)
{
    var Flag=0
    if (value) Flag=1;
    
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","SetOpenCharge",Flag); 
    
}

function IFeeAsCharged_change(value)
{
    
    var AsCharged="N";
    if (value) AsCharged="Y";
    var ret=tkMakeServerCall("web.DHCPE.PreItemListEx","SetIFeeAsCharged",PreAdmId,AsCharged); 
    if (ret!=""){
        $.messager.alert("��ʾ",ret,"info");
        if(ret=="���岻���������ԷѼ���")
        {
            $("#IFeeAsCharged").checkbox("disable");
            if(value) {
                $("#IFeeAsCharged").checkbox('setValue',false);
                }
            
        }
        
    }
}

function AgeOnChange()
{
    
    var iAge=$('#Age').val();

    if (iAge=="") return false;
    if (!(isNaN(iAge)))
    {
        var iDOB=$('#DOB').combobox('getValue');
        if (iAge=="") {iAge=0}
        //if (iDOB!="") return;
        
        iAge=parseInt(iAge)
        var D   =   new   Date();
        var Year=D.getFullYear();
        var Year=Year-iAge;  
        
        var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
        if (dtformat=="YMD"){
            var newDOB=Year+"-01"+"-01";
        }else if (dtformat=="DMY"){
            var newDOB="01"+"/"+"01"+"/"+Year;
        }   
     
        $('#DOB').datebox('setValue',newDOB);
       

    }
    
}

function Name_keydown()
{
    var iName="";
    var obj=document.getElementById('Name');
    if (obj && ""!=obj.value) { iName = obj.value; }
    else { return false; }
    var info=tkMakeServerCall("web.DHCPE.PreIBaseInfo","GetPersonInfo",iName);
    if (info==0) return;
    
    openNameWin(iName);
}
var picType=".jpg"
var PicFilePath="D:\\"
/*
function BPhoto_click()
{   
    var PAPMINo ="" 
    PAPMINo=getValueById('PAPMINo')
    
    //����Ϊjpg�ļ�
    
    var PatientID=tkMakeServerCall("web.DHCPE.PreIADM","GetPatientID",PAPMINo);
    
    
    if(PatientID==""){
        $.messager.alert("��ʾ","������ϢID����Ϊ�ա�","info");
        return;
    }

    var PicHeight=300;
    var Picwidth=200;
    PEPhoto.FileName=PicFilePath+PAPMINo+picType; //����ͼƬ�����ư�����׺
    if (PhotoFtpInfo==""){
        PEPhoto.FTPFlag="0" //�Ƿ��ϴ���ftp������  0
    }else{
        var FTPArr=PhotoFtpInfo.split("^");
        PEPhoto.DBFlag = "0" //�Ƿ񱣴浽���ݿ�  0  1
        PEPhoto.FTPFlag = "1" //�Ƿ񱣴浽FTP  0  1
        PEPhoto.AppName = FTPArr[4]+"/" //ftpĿ¼
        PEPhoto.FTPString = FTPArr[0]+"^"+FTPArr[1]+"^"+FTPArr[2]+"^"+FTPArr[3] //FTP������
        PicHeight=FTPArr[5];
        Picwidth=FTPArr[6];
    }
    PEPhoto.PicWidth=Picwidth;
    PEPhoto.PicHeight=PicHeight;
    PEPhoto.PatientID=PatientID //PA_PatMas���ID
    PEPhoto.ShowWin()
    InitPicture()
}
*/
function BPhoto_click()
{   
   var PAPMINo ="" 
    PAPMINo=getValueById('PAPMINo')
    
    //����Ϊjpg�ļ�
    var PatientID=tkMakeServerCall("web.DHCPE.PreIADM","GetPatientID",PAPMINo);

    if(PatientID==""){
        $.messager.alert("��ʾ","������ϢID����Ϊ�ա�","info");
        return;
    }
    
    var userAgent = navigator.userAgent;
    var isChrome =  navigator.userAgent.indexOf('Chrome') > -1
    if(isChrome){
        
    var PicHeight=300;
    var Picwidth=200;
    PEPhoto.FileName=PicFilePath+PAPMINo+picType; //����ͼƬ�����ư�����׺
    if (PhotoFtpInfo==""){
        PEPhoto.FTPFlag="0" //�Ƿ��ϴ���ftp������  0
    }else{
        var FTPArr=PhotoFtpInfo.split("^");
        PEPhoto.DBFlag = "0" //�Ƿ񱣴浽���ݿ�  0  1
        PEPhoto.FTPFlag = "1" //�Ƿ񱣴浽FTP  0  1
        PEPhoto.AppName = FTPArr[4]+"/" //ftpĿ¼
        PEPhoto.FTPString = FTPArr[0]+"^"+FTPArr[1]+"^"+FTPArr[2]+"^"+FTPArr[3] //FTP������
        PicHeight=FTPArr[5];
        Picwidth=FTPArr[6];
    }
    PEPhoto.PicWidth=Picwidth;
    PEPhoto.PicHeight=PicHeight;
    PEPhoto.PatientID=PatientID //PA_PatMas���ID
    PEPhoto.ShowWin()
    InitPicture()    
        
    /*    
    $HUI.window("#PhotoWin",{
        title:"�������",
        iconCls:"icon-w-stamp",
        collapsible:false,
        minimizable:false,
        maximizable:false,
        closable:true,
        resizable:false,
        modal:true,
        width:800,
        height:600,
        content:'<iframe src="dhcpephotochrome.csp?RegNo='+PAPMINo+'" width="100%" height="100%" frameborder="0"></iframe>'
    });
    */
    }
    
    
    else
    {
    $HUI.window("#PhotoWin",{
        title:"�������",
        iconCls:"icon-w-stamp",
        collapsible:false,
        minimizable:false,
        maximizable:false,
        closable:true,
        resizable:false,
        modal:true,
        width:800,
        height:600,
        content:'<iframe src="dhcpephoto.csp?RegNo='+PAPMINo+'" width="100%" height="100%" frameborder="0"></iframe>'
    });
    }
    //$('#PhotoWin').window('close');
    //var lnk="dhcpephoto.csp?RegNo="+PAPMINo;
    //var ret=window.showModalDialog(lnk, "", "dialogwidth:800px;dialogheight:600px;center:1"); 
    //InitPicture()
}
function ChangeFeeTypeFuction()
{
    var eSrc = window.event.srcElement;
    var IADM=getValueById("PIADM_RowId")
    var GADM=tkMakeServerCall("web.DHCPE.HISUICommon","GetGADMByIADM",IADM);

    if((AdmType=="PERSON")&&(GADM=="")){
        $.messager.alert("��ʾ","����������Ա,�����������","info");
        return false;
    }

    var ret=tkMakeServerCall("web.DHCPE.PreItemListEx","ChangeFeeType",eSrc.id);
    if (ret=="0"){
        $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:IADM,AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""});  
        var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetOrdAmountHISUI",IADM,AdmType);
        var GZAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",IADM,AdmType);
        var myDiv=document.getElementById("TotalFee");
        myDiv.innerText=TotalAmount;
        return false;
    }
    $.messager.alert("��ʾ","ת��ʧ��:"+ret,"info");
    
    return false; 
}

/**
 * �򿪵����ʾ���
 * @param    {[String]}    iPIADMRowId [ԤԼID]
 * @Author   wangguoying
 * @DateTime 2019-04-10
 */
function openSurveyWin(iPIADMRowId)
{
    $HUI.window("#SurveyWin",{
        title:"�����ʾ�",
        iconCls:"icon-write-order",
        collapsible:false,
        minimizable:false,
        maximizable:false,
        closable:true,
        resizable:false,
        modal:true,
        width:900,
        height:600,
        content:'<iframe src="dhchm.questiondetailset.csp?PreIADM='+iPIADMRowId+'" width="100%" height="100%" frameborder="0"></iframe>'
    });
}

/**
 * ��д������ʾ�֮��ִ��
 * @Author   wangguoying
 * @DateTime 2019-04-10
 */
var afterSurvey=function(iPIADMRowId){
    if(RecommendFlag=="Y"){
        openRecommendWin(iPIADMRowId);
    }else{
        //$.messager.alert("��ʾ","ԤԼ�ɹ�!","success");
    }
    
}

/**
 * ���Ƽ��ײʹ���
 * @param    {[String]}    iPIADMRowId [ԤԼID]
 * @Author   wangguoying
 * @DateTime 2019-04-10
 */
function openRecommendWin(iPIADMRowId)
{
    $HUI.window("#RecommendWin",{
        title:"�Ƽ��ײ�",
        iconCls:"icon-book",
        collapsible:false,
        minimizable:false,
        maximizable:false,
        resizable:false,
        closable:false,
        modal:true,
        width:600,
        height:400,
        content:'<iframe src="dhchm.recommenditem.csp?PreIADM='+iPIADMRowId+'" width="100%" height="100%" frameborder="0"></iframe>'
    });
}


/**
 * �Ƽ��ײ�֮��ִ��
 * @Author   wangguoying
 * @DateTime 2019-04-12
 */
var afterRecommend=function(ret,iPIADMRowId){
    if(ret!=""){
        var UserID=session['LOGON.USERID'];
        var InsertRet=tkMakeServerCall("web.DHCPE.PreItemList","IInsertItem",iPIADMRowId,AdmType,PreOrAdd,"",ret,UserID)
        if(InsertRet!=""){
            $.messager.alert("����","�����Ƽ��ײ�ʧ�ܣ�"+InsertRet,"error");
        }else{
            $("#PreItemList").datagrid("reload");
        }
    }else{
        //$.messager.alert("��ʾ","ԤԼ�ɹ�,����ѡ��Ŀ","success");
    }
    
}

function BPreDate_click()
{
    
    var ExpStr=$("#Sex_DR_Name").combobox('getValue')+"^"+$("#VIPLevel").combobox('getValue')+"^"+$("#PGADM_DR_Name").combogrid("getValue");
    $HUI.window("#PreDateWin",{
        title:"ԤԼʱ��",
        iconCls:"icon-book",
        collapsible:false,
        minimizable:false,
        maximizable:false,
        resizable:false,
        modal:true,
        width:1000,
        height:700,
        content:'<iframe src="dhcpepredate.hisui.csp?PreIADMID='+getValueById("PIADM_RowId")+'&ExpStr='+ExpStr+'" width="100%" height="98%" frameborder="0"></iframe>'
    });
    
    
}
function SetBeginDate(date,time)
{
    setValueById("PETime",time)
    $("#PEDateBegin").datebox('setValue',date)
    
}
$(init);
