
//���� DHCPENewGSSDetailHISUI.js
//���� �ܼ콨��
//���� 
//������


var UserId=session['LOGON.USERID']
$("#GSID").val(GSID);
var editIndex=undefined;

document.body.onload = BodyLoadHandler;
function BodyLoadHandler()
{

    var obj=document.getElementById("OK");
    if(obj) obj.onclick=SaveGSSDetail;
    var obj=document.getElementById("Cancel");
    if(obj) obj.onclick=Close;
            
}

function GSSDetailKeyDown()
{
    return ;
    if(window.event.keyCode != 32) return;
    var curtr = document.getElementById("GSSDetail");
    var o = document.createElement("<span style='width:20px; background-color:white;margin:0px;padding:0px;'></span>");
    curtr.appendChild(o);
    window.event.returnValue = false; 
}
function setTextSelected(inputDom, startIndex, endIndex)
 {
    if (CurisIE()=="-1"){
        if (inputDom.setSelectionRange)
        {  
            inputDom.setSelectionRange(startIndex, endIndex);  
        }
    }
    else if (inputDom.createTextRange) //IE 
    {
         var range = inputDom.createTextRange();  
        range.collapse(true);  
        range.moveStart('character', startIndex);  
        range.moveEnd('character', endIndex - startIndex-1);  
        range.select();
     }  
       inputDom.focus();  
}
//�ж��Ƿ���IE�����  
function CurisIE()  
{  
    var userAgent = navigator.userAgent; //ȡ���������userAgent�ַ��� 
    var isOpera = userAgent.indexOf("Opera") > -1
    var cisIE = userAgent.indexOf("compatible") > -1  && userAgent.indexOf("MSIE") > -1 && !isOpera; //�ж��Ƿ�IE�����  
    if(cisIE)  
    {  
        return "1";  
    }  
    else  
    {  
        if (userAgent.indexOf("rv:11.0") > -1) return "1";  //ie11
        return "-1";  
    }  
}

function setTareaAutoHeight(e) {
    //e.style.height = e.scrollHeight + "px";
    if (e.scrollHeight<32){
        e.style.height=32+"px";
    }else{
        e.style.height = e.scrollHeight + "px";
    }
    websys_setfocus('OK');
}
function SaveGSSDetail()
{
    
    var obj,encmeth,GSID,GSSDetail;
    
    var obj=document.getElementById("UpdateGSSDetail");
    if (obj) var encmeth=obj.value;
    obj=document.getElementById("GSID");
    if (obj) GSID=obj.value;
    obj=document.getElementById("GSSDetail");
    if (obj) GSSDetail=obj.value;
    
    var GSSYGDetail="";
    obj=document.getElementById("YGGSSDetail");
    if (obj) GSSYGDetail=obj.value;
    
    var CheckResult=tkMakeServerCall("web.DHCPE.TransResult","CheckMain",GSID,"Y")
    //debugger; // SaveGSSDetail2 
    if(CheckResult.split("^")[0]==1){
        $.messager.alert("��ʾ", CheckResult.split("^")[1]+"�뷵�������ܼ�", "info");
        //Close();
        return false;
        }
    
    //var ret=cspRunServerMethod(encmeth,GSID,GSSDetail);
    var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","UpdateGSSDetail",GSID,GSSDetail,GSSYGDetail);
    
    if(ret.split("^")[0]!=-1)
    {
        var Old=tkMakeServerCall("web.DHCPE.ModifyRecord","GetInfo",GSID,"GSSDetail")
        
        var Info=tkMakeServerCall("web.DHCPE.ModifyRecord","Save",GSID,"GSSDetail",Old,GSSDetail,UserId)
    }
    $("#CloseFlag").val(ret);
    parent.$('#GSSDetailWin').window('close');  

    
    //ˢ�»����б�
    var ExpStrOne=ExpStr.split("^");
     parent. parent.$("#CanDiagnosisList").datagrid('load',{
            ClassName:"web.DHCPE.ResultNew",
            QueryName:"FindDiagnosisPatInfo",
            MainDoctor:MainDoctor,
            RegNo:ExpStrOne[0],
            BDate:ExpStrOne[3],
            EDate:ExpStrOne[4],
            VIP:ExpStrOne[5],
            PatName:ExpStrOne[1],
            Group:ExpStrOne[2],
            MainDoctor:MainDoctor,
            GenStatus:ExpStrOne[6],
            HospID:session['LOGON.HOSPID'],
            OtherPAADM:ExpStrOne[7]
         }); 

    return false;
    
    
}
function Close()
{
    $("#CloseFlag").val("0");
    parent.$('#GSSDetailWin').window('close'); 
    return false;
}
function DeleteGSIllness(GSIll)
{
    
    $.messager.confirm("ɾ��", "ȷ��Ҫɾ����?", function (r) {
                if (r) {
                    InString=GSIll+"^^^"+UserId+"^"
                
                var flag=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","UpdateGSIllness",InString,2);
                if (flag.split("^")[0]!="-1")
                {
                    $("#GSIllness").datagrid("load",{ClassName:"web.DHCPE.ResultDiagnosisNew",QueryName:"FindGSIllness",GSID:GSID}); 
                    editIndex=undefined;
                }
                else
                {
                    $.messager.alert("��ʾ", flag.split("^")[1], "info");
                    $("#GSIllness").datagrid("load",{ClassName:"web.DHCPE.ResultDiagnosisNew",QueryName:"FindGSIllness",GSID:GSID}); 
                    editIndex=undefined;
                }
                } else {
                    return false;
                }
            });
                
}


function endEditing(){
            if (editIndex == undefined){return true}
            if ($('#GSIllness').datagrid('validateRow', editIndex)){
                
                $('#GSIllness').datagrid('endEdit', editIndex);
                
                editIndex = undefined;
                return true;
            } else {
                return false;
            }
}

function IllnessClickRow(index){
        if (editIndex!=index) {
            if (endEditing()){
                $('#GSIllness').datagrid('selectRow',index).datagrid('beginEdit',index);
                editIndex = index;
            } else {
                $('#GSIllness').datagrid('selectRow',editIndex);
            }
        }
}



function InitCombobox()
{
    
    //�������
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


    //�����
    var fupersonObj = $HUI.combobox("#fuperson",{
        url:$URL+"?ClassName=web.DHCCRM.GetBaseInfo&QueryName=FindUser&ResultSetType=array",
        valueField:'id',
        textField:'name',
        mode:'remote',
        onBeforeLoad: function (param) {
            param.desc = param.q;
            
        }
    });

  //��������
    var IllnessStandardObj = $HUI.combobox("#IllnessStandard",{
        url:$URL+"?ClassName=web.DHCPE.CT.IllnessStandard&QueryName=GetIllByAlias&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
        valueField:'HIDDEN',
        textField:'Detail'
    })
        

        
}


//���ɼƻ�
function CreatePlan()
{
    
    var PAADM=tkMakeServerCall("web.DHCPE.ResultDiagnosis","GetPAADMBySSId",GSID);
    if(PAADM==""){
        $.messager.alert("��ʾ","����IDΪ��","info");
        return false; 
    }
    var fuperson=$("#fuperson").combobox('getValue');
    
    var fusbDate=$("#fusbDate").datebox('getValue');
    
    var fusubject=$("#fusubject").combotree('getValues');
    if(fusubject==""){
        $.messager.alert("��ʾ","��ѡ���������!","info");
        return false; 
    }
    var fusubjectstr=fusubject.join("^");

    var fudays=$("#fudays").val();
    var funums=$("#funums").val();
    
   
    var flag=tkMakeServerCall("web.DHCCRM.SetPlan","SetPlanHISUI",PAADM,fusubjectstr,fuperson,fusbDate,"","","",fudays,funums);
    if(flag==0){
            BFunClaer();
            $.messager.popover({msg: '���ɳɹ���',type:'success',timeout: 1000});       
            
        }else{
            $.messager.alert('������ʾ',"����ʧ��:"+flag,"error");
        }

}

//��ջط���Ϣ
function BFunClaer()
{
    $("#fuperson").combobox('setValue',"");
    $("#fusbDate").datebox('setValue',"");
    $("#fusubject").combotree('setValue',"");
    $("#fudays").val("");
    $("#funums").val("");
}

function iniForm(){
    
    var LocID=session['LOGON.CTLOCID'];
    
    //���طã��������ÿ����Ƿ�ɲ�����
    var flag=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",LocID,"ReturnVisit");
    
    if(flag=="0"){
        $("#CreatePlan").linkbutton('disable');
        $("#fuperson").combobox('disable');
        $("#fusubject").combotree('disable');
        $("#fusbDate").datebox('disable');
        $("#fudays").numberbox('disable',true);
        $("#funums").numberbox('disable',true);     
    }else{
        $("#CreatePlan").linkbutton('enable');
        $("#fuperson").combobox('enable');
        $("#fusubject").combotree('enable');
        $("#fusbDate").datebox('enable');
        $("#fudays").numberbox('enable',true);
        $("#funums").numberbox('enable',true);      
        
    }
        
    
}
var init = function(){
    
    
    InitCombobox();
    
    //���ɼƻ�
    $("#CreatePlan").click(function() {
        CreatePlan(); 
    });

    iniForm();
    
    var GSIllnessObj = $HUI.datagrid("#GSIllness",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCPE.ResultDiagnosisNew",
            QueryName:"FindGSIllness",
            GSID:GSID

        },
        fitColumns:true,
        singleSelect:false,
        checkOnSelect:true,
        selectOnCheck:true,
        rownumbers:true,
        onClickRow: IllnessClickRow,
        toolbar:[{
            iconCls:'icon-add',
            text:'����',
            handler: function(){
                
                
                if(editIndex != undefined)
                {
                    $.messager.alert("��ʾ","����δ��������ݣ������޸�!","info");    
                    return false;
                    
                }
                else
                {
                $('#GSIllness').datagrid('insertRow',{
                    index: 0,
                    row: {
                        GSIll:'',
                        GSIllnessID:'',
                        GSIType:''
                        }
                });
                IllnessClickRow(0);
                }
                
                
                
            }
        },{
            iconCls:'icon-write-order',
            text:'�޸�',
            handler: function(){
                
                endEditing();
                
            }
        },{
            iconCls:'icon-cancel',
            text:'ɾ��',
            handler: function(){
            
                var rows = $("#GSIllness").datagrid("getChecked");//��ȡ�������飬��������
                if(rows.length==0)
                {
                     $.messager.alert("��ʾ","��ѡ����ɾ���ļ���!","info");    
                     return false;
                 
                 }
                $.messager.confirm("ɾ��", "ȷ��Ҫɾ����?", function (r) {
                if (r) {
                    var flag="";    
            
            
                 for(var i=0;i<rows.length;i++){
                 
                    var GSIID=rows[i].GSIll;
                
                    if(GSIID=="")
                    {
                        $.messager.alert("��ʾ","��ѡ����ɾ���ļ�����!","info");    
                        return false;
                    }
                    var InString=GSIID+"^^^"+UserId+"^"
                
                    flag=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","UpdateGSIllness",InString,2);
                

                 
                 
             }
             if (flag.split("^")[0]!="-1")
                {
                    $("#GSIllness").datagrid("load",{ClassName:"web.DHCPE.ResultDiagnosisNew",QueryName:"FindGSIllness",GSID:GSID}); 
                    editIndex=undefined;
                }   
            else
            {
                
                $.messager.alert("��ʾ", flag.split("^")[1], "info");
                $("#GSIllness").datagrid("load",{ClassName:"web.DHCPE.ResultDiagnosisNew",QueryName:"FindGSIllness",GSID:GSID}); 
                editIndex=undefined;
            }
                
            
                } else {
                    return false;
                }
            })
        }
        }
        ],
        columns:[[
            {field:'select',checkbox:true},
            {field:'operate',title:'����',
            formatter:function(value,row,index){
                return "<span style='cursor:pointer;padding:0 0px 0px 7px' class='icon-cancel' title='ɾ������' onclick='DeleteGSIllness("+row.GSIll+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";  
                return "<a href='#' onclick='DeleteGSIllness(\""+row.GSIll+"\")'>\
                        <img style='padding-left:7px;' title="+$g('ɾ������')+" src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>\
                       </a>";
                    
            }},
            {field:'GSIll',hidden:true},
            {field:'GSIllnessID',title:'��������',width:150,
                    formatter:function(value,row){
                        return row.IllnessDesc;
                    },
                    editor:{
                    type:'combobox',
                    options:{
                        valueField:'HIDDEN',
                        textField:'Detail',
                        method:'get',
                        url:$URL+"?ClassName=web.DHCPE.CT.IllnessStandard&QueryName=GetIllByAlias&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
                        onBeforeLoad:function(param){
                            
                            
                            }
                        
                    }
                }
            }
            
            
        ]],
        onAfterEdit:function(rowIndex,rowData,changes){
            
            
            var RowID=rowData.GSIll
            var IllID=rowData.GSIllnessID
            if(IllID=="")
            {
                $.messager.alert("��ʾ","��������Ϊ�գ�","info");
                $("#GSIllness").datagrid("load",{ClassName:"web.DHCPE.ResultDiagnosisNew",QueryName:"FindGSIllness",GSID:GSID}); 
                editIndex=undefined;
                return false;
                
            }
            var GSIType=rowData.GSIType
            if (GSIType=="") GSIType="D"
            
            var InString=RowID+"^"+IllID+"^"+GSID+"^"+UserId+"^"+GSIType;
            
            var flag=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","UpdateGSIllness",InString,0);
            if (flag.split("^")[0]!="-1")
            {
                $("#GSIllness").datagrid("load",{ClassName:"web.DHCPE.ResultDiagnosisNew",QueryName:"FindGSIllness",GSID:GSID}); 
            
            }
            else
            {
                $.messager.alert("��ʾ", flag.split("^")[1], "info");
                $("#GSIllness").datagrid("load",{ClassName:"web.DHCPE.ResultDiagnosisNew",QueryName:"FindGSIllness",GSID:GSID}); 
                editIndex=undefined;
                
            }
            editIndex=undefined;
            
        },
        onSelect: function (rowIndex, rowData) {
            setValueById("GSIID",rowData.GSIll)
        },
        onLoadSuccess: function () {
            $(".datagrid-header-inner").removeClass();
            editIndex=undefined;
        }
        
        });
    
    
}

$(init);