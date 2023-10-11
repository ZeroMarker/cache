//����    DHCCRMFURecord.hisui.js
//����    ��ü�¼ HISUI
//����    2020-11-26
//������  yupeng

var RTime=0;
var qtask="";

var LCeditIndex=undefined;

function LCClickRow(index){
    
        LCendEditing();
        if (LCeditIndex!=index) {
            if (LCendEditing()){
                $('#LinkConfigTab').datagrid('selectRow',index).datagrid('beginEdit',index);
                LCeditIndex = index;
            } else {
                $('#LinkConfigTab').datagrid('selectRow',LCeditIndex);
            }
        }
}

function LCendEditing(){
            if (LCeditIndex == undefined){return true}
            if ($('#LinkConfigTab').datagrid('validateRow', LCeditIndex)){
                
                $('#LinkConfigTab').datagrid('endEdit', LCeditIndex);
                
                LCeditIndex = undefined;
                return true;
            } else {
                return false;
            }
}


$(function(){
    
    $("#BFind").css({"width":"130px"});
    $("#DelNoQR").css({"width":"130px"});
    InitPatListTabDataGrid();
    
    $("#PatSave").click(function() {
            
            PatSave(); 
            
    });
    $("#LinkConfig").click(function() {
            
            LinkConfig(); 
            
    });
    $("#BFind").click(function() {
            
            BFind(); 
            
    });
     $("#papmino").keydown(function(e) {
            
            if(e.keyCode==13){
                BFind();
            }
            
        });

    $("#DelNoQR").click(function() {
            
            DelNoQR(); 
            
    });
    $("#DoTel").click(function() {
            
            DoMakeCall(); 
            
    });
    $("#StopTel").click(function() {
            
            DoHangupCall(); 
            
    });
    $("#DoRadio").click(function() {
            
            DoRadio(); 
            
    });
    $("#ZSCondition").checkbox(
    
    {
        onChecked: function(e,value){
            $("#Condition").checkbox('uncheck');
        }}
    
    );
    
    $("#Condition").checkbox(
    
    {
        onChecked: function(e,value){
            $("#ZSCondition").checkbox('uncheck');
        }}
    
    );
     var PatLocObj = $HUI.combobox("#PatLoc",{
        url:$URL+"?ClassName=web.DHCCRM.GetBaseInfo&QueryName=SearchCTLoc&ResultSetType=array",
        valueField:'CTLOC_RowId',
        textField:'CTLOC_Desc',
        mode:'remote',
        onBeforeLoad: function (param) {
            param.Desc = param.q;
            
        }
    });
    
    var fusubjectObj = $HUI.combobox("#fusubject",{
        url:$URL+"?ClassName=web.DHCCRM.CRMBaseSet&QueryName=SearchFUSubject&ResultSetType=array",
        valueField:'RowId',
        rowStyle:'checkbox',
        textField:'Desc',multiple:true,selectOnNavigation:false,panelHeight:300,editable:false
    });
    
    var LinkCondition1Obj = $HUI.combobox("#LinkCondition1",{
        url:$URL+"?ClassName=web.DHCCRM.CRMBaseSet&QueryName=FindContractReason1&ResultSetType=array",
        valueField:'id',
        textField:'Reason'
    });
    var LinkCondition2Obj = $HUI.combobox("#LinkCondition2",{
        url:$URL+"?ClassName=web.DHCCRM.CRMBaseSet&QueryName=FindContractReason1&ResultSetType=array",
        valueField:'id',
        textField:'Reason'
    });
    
    var LinkCondition3Obj = $HUI.combobox("#LinkCondition3",{
        url:$URL+"?ClassName=web.DHCCRM.CRMBaseSet&QueryName=FindContractReason1&ResultSetType=array",
        valueField:'id',
        textField:'Reason'
    });
    
    $HUI.datagrid("#LinkConfigTab",{
        url:$URL,
        fit : true,
        border : false,
        fitColumns : false,
        autoRowHeight : false,
        singleSelect: true,
        selectOnCheck: false,
        onClickRow: LCClickRow,
        
        queryParams:{
            ClassName:"web.DHCCRM.CRMBaseSet",
            QueryName:"FindContractReason"
                
        },
        columns:[[
            {field:'id',hidden: true},
            {field:'Code',title:'����',editor:'text',width:150},
            {field:'Reason',title:'ԭ��',editor:'text',width:250},
            {field:'Type',title:'����',width:150,
            formatter:function(value,row){
                    return row.TypeDesc;
                },
            editor:{
                    type:'combobox',
                    options:{
                        valueField:'id',
                        textField:'text',
                        data:[
                            {id:'Z',text:'��ʱ��ϵ����'},{id:'L',text:'��ϵ����'}
                        ]
                        
                    }
                }
            
            
            
            
            },
            {field:'Seq',title:'˳��',editor:'text',width:100},
            {field:'Active',title:'����',editor:{type:'icheckbox',options:{on:'Y',off:'N'}},formatter:function(data, value, index) {
                return data=="Y"?"��":"��";}}
            
        ]],
        toolbar:[{
            iconCls:'icon-add',
            text:'����',
            handler: function(){
                
                
                
                if(LCeditIndex != undefined)
                {
                    $.messager.alert("��ʾ","����δ��������ݣ������޸�!","info");    
                    return
                    
                }
                else
                {
                var rows = $("#LinkConfigTab").datagrid("getRows");
                $('#LinkConfigTab').datagrid('insertRow',{
                    index: 0,
                    row: {
                        id: '',
                        Code: '',
                        Reason: '',
                        Type: '',
                        Seq:'',
                        Active:''
                        }
                });
                
                LCClickRow(0);
                
                }
            }
        },{
            iconCls:'icon-write-order',
            text:'�޸�',
            handler: function(){
                LCendEditing();
            }
        }
        ],
        onAfterEdit:function(rowIndex,rowData,changes){
            
            var ID=rowData.id;
            var Code=rowData.Code;
            var Reason=rowData.Reason;
            var Type=rowData.Type;
            var Seq=rowData.Seq;
            var Active=rowData.Active;
            
            if((Code=="")||(Reason=="")||(Type=="")||(Seq==""))
            {
                $.messager.alert('��ʾ',"���롢ԭ�����ͺ�˳����Ϊ�գ�","error");
                return false;
            }
            
            
            
            var flag=tkMakeServerCall("web.DHCCRM.CRMBaseSet","UpdateLinkReason",ID,Code,Reason,Type,Seq,Active);
            if (flag==0)
            {
                $("#LinkConfigTab").datagrid("load",{ClassName:"web.DHCCRM.CRMBaseSet",QueryName:"FindContractReason"}); 

            }
            else 
            {
                $.messager.alert("��ʾ",flag,"info"); 
                $("#LinkConfigTab").datagrid("load",{ClassName:"web.DHCCRM.CRMBaseSet",QueryName:"FindContractReason"}); 

            }
            
        }
            
    });
    
})

function closeAllTabs(id){  
         var arrTitle = new Array();  
         var id = "#"+id;//Tab���ڵĲ��ID  
         var tabs = $(id).tabs("tabs");//�������СTab  
         var tCount = tabs.length;  
         if(tCount>0){  
                     //�ռ�����Tab��title  
             for(var i=0;i<tCount;i++){  
                 arrTitle.push(tabs[i].panel('options').title)  
             }  
                     //�����ռ���titleһ��һ��ɾ��=====���Tab  
             for(var i=0;i<arrTitle.length;i++){  
                 $(id).tabs("close",arrTitle[i]);  
             }  
         }  
 };  
 

function InitPatListTabDataGrid()
{
    
    $HUI.datagrid("#PatListTab",{
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
            ClassName:"web.DHCCRM.PatInfo",
            QueryName:"SearchPatInfo"
        },
        columns:[[
            {field:'fuprowid',title:'ID',hidden:true},
            {field:'pattype',title:'����'},
            {field:'papmino',title:'�ǼǺ�'},
            {field:'mrid',title:'������'},
            {field:'mrname',title:'����'},
            {field:'mrgender',title:'�Ա�'}, 
            {field:'mrbirthday',title:'����'},
            {field:'mrcardid',title:'���֤��'}, 
            {field:'mrtel',title:'�绰'},
            {field:'admdate',title:'��Ժ/��������'},
            {field:'disdate',title:'��Ժ����'}, 
            {field:'disdiag',title:'���'},  
            {field:'disroom',title:'��Ժ����'},
            {field:'DocName',title:'����ҽʦ'},
            {field:'mraddress',title:'��ϵ��ַ'},  
            {field:'deadflag',title:'Ժ������'},
            {field:'fupDate',title:'�ƻ��������'}
        ]],
        onSelect: function (rowIndex, rowData) {
            setValueById("fusubject",rowData.fusrowid)
            setValueById("mrname",rowData.mrname)      
            setValueById("mrtel",rowData.mrtel)   
            setValueById("PersonID",rowData.papmiid)
            setValueById("FuplanID",rowData.fuprowid) 
            
            var paadm=rowData.paadm
            var frm = parent.parent.parent.document.forms['fEPRMENU'];
            var frmEpisodeID = frm.EpisodeID;
            frmEpisodeID.value = paadm;
            var frmPatientID = frm.PatientID;
            frmPatientID.value = "";
            
            RTime=0;
            qtask="";
            $("#RTimeLabel").empty();
            closeAllTabs('QuestionTab');
            var childquestion=tkMakeServerCall('web.DHCCRM.PatInfo',"GetChildQuestion",rowData.fuprowid);
            childquestion=childquestion.split("^")
            for(var i=0;i<childquestion.length;i++)
            {
                var childstr=childquestion[i].split("@");
                var url="dhcrm.questiondetailset.csp?FuplanID="+childstr[0]+"&WriteFlag="+childstr[2];
                var tabframe="tabframe"+childstr[0];
                var contentstr = '<iframe id="'+tabframe+'" scrolling="yes" frameborder="0"  src="'+url+'" style="width:100%;height:99%;"></iframe>';
       
                icon="icon-paper";
                var chiletitle="һ�����";
                if(childstr[1]==2) chiletitle="�������";
                if(childstr[1]==3) chiletitle="�������";
                $('#QuestionTab').tabs('add',{
                    selected:false,
                    id:childstr[0],
                    title:chiletitle,
                    content: contentstr
                });
                
                
            }
            
            $('#QuestionTab').tabs('select',0);
            
            if(rowData.deadflag=="����")
            $("#SetDead").checkbox('setValue',true);
           else 
            $("#SetDead").checkbox('setValue',false); 
            
            var str = tkMakeServerCall('web.DHCCRM.FUSubject',"GetLinkNum", rowData.fuprowid);
            
            var reason = str.split("^")[1].split(";");
            setValueById("LinkCondition1","")
            setValueById("LinkCondition2","")
            setValueById("LinkCondition3","")
            if(reason[0]) 
            {
                var reason1=reason[0].split("@")[0];
                if(reason1) 
                {
                    setValueById("LinkCondition1",reason1);
                    
                    $("#LinkCondition1").combobox("disable");
                }
                
            }
            
            if(reason[1]) 
            {
                var reason2=reason[1].split("@")[0];
                if(reason2) {
                    setValueById("LinkCondition2",reason2);
                    $("#LinkCondition2").combobox("disable");
                }
            }
            if(reason[2]) 
            {
                var reason3=reason[2].split("@")[0];
                if(reason3) {
                    setValueById("LinkCondition3",reason3);
                    $("#LinkCondition3").combobox("disable");
                }
            }
        }
        
            
    })
    
    
 }
function PatSave()
{
    var newtel=getValueById("mrtel");
    var personid=getValueById("PersonID");
    //�绰
    var ret = tkMakeServerCall("web.DHCCRM.PatInfo", "UpdateTel", personid,newtel);
    
    
    var iSetDead="0";
    var SetDead=$("#SetDead").checkbox('getValue');
    if(SetDead) {iSetDead="1";}
    var fupid=getValueById("FuplanID");
    //����
    var ret = tkMakeServerCall("web.DHCCRM.FUSubject", "SetDeadFlag", iSetDead,fupid);
    
    var str = tkMakeServerCall('web.DHCCRM.FUSubject',"GetLinkNum", fupid);
    var num = str.split("^")[0];
    var oldreason = str.split("^")[1];
    num = parseInt(num) + 1;
    
    
    var ret=tkMakeServerCall('web.DHCCRM.FUSubject', "SetLinkInfo", fupid, "Z")
    var RealLinkFlag="";
    if(num==1)
    {
    //��ϵ���1
    var reason=getValueById("LinkCondition1");
    RealLinkFlag=tkMakeServerCall('web.DHCCRM.CRMBaseSet', "GetRealLinkFlag",reason)
    if(RealLinkFlag=="L") tkMakeServerCall('web.DHCCRM.FUSubject', "SetLinkInfo", fupid, "L") 
    if(reason!="") var ret = tkMakeServerCall('web.DHCCRM.FUSubject', "SetLinkFlag",fupid, num, reason)
    }
    if(num==2)
    {
    //��ϵ���2
    var reason2=getValueById("LinkCondition2");
    RealLinkFlag=tkMakeServerCall('web.DHCCRM.CRMBaseSet', "GetRealLinkFlag",reason2)
    if(RealLinkFlag=="L") tkMakeServerCall('web.DHCCRM.FUSubject', "SetLinkInfo", fupid, "L") 
    var reason = oldreason + ";" + reason2;
    
    if(reason2!="") var ret = tkMakeServerCall('web.DHCCRM.FUSubject', "SetLinkFlag",fupid, num, reason)
    }
    if(num==3)
    {
    //��ϵ���3
    var reason3=getValueById("LinkCondition3");
    RealLinkFlag=tkMakeServerCall('web.DHCCRM.CRMBaseSet', "GetRealLinkFlag",reason3)
    if(RealLinkFlag=="L") tkMakeServerCall('web.DHCCRM.FUSubject', "SetLinkInfo", fupid, "L") 
    var reason = oldreason + ";" + reason3;
    if(reason3!="") var ret = tkMakeServerCall('web.DHCCRM.FUSubject', "SetLinkFlag",fupid, num, reason)
    }
    
    
    if (num == 3)
            tkMakeServerCall('web.DHCCRM.FUSubject', "SetLinkInfo", fupid, "L")
    
    
    
    if(ret==0){
            $.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
            
            var papmino=getValueById("papmino");
            var patname=getValueById("patname");
            var telno=getValueById("telno");
            var PatLoc=getValueById("PatLoc");
            var BeginDate=getValueById("BeginDate");
            var EndDate=getValueById("EndDate");
            var Condition=$("#Condition").checkbox('getValue');
            var ZSCondition=$("#ZSCondition").checkbox('getValue');
            var FollowFlag=$("#FollowFlag").checkbox('getValue');
            $("#PatListTab").datagrid('load',{
                ClassName:"web.DHCCRM.PatInfo",
                QueryName:"SearchPatInfo",
                patno:papmino,
                patname:patname,
                patdisdiag:"",
                startdate:BeginDate,
                enddate:EndDate,
                FollowFlag:FollowFlag,
                OutHosLoc:PatLoc,
                Condition:Condition,
                TelNo:telno,
                ZSCondition:ZSCondition
                }); 
        }else{
            $.messager.alert('������ʾ',"����ʧ��","error");
        }
    
    
}

function BFind()
{
    
    var CTLocID=session['LOGON.CTLOCID'];
    var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength",CTLocID);
    var papmino= $("#papmino").val();
    
    if (papmino.length<RegNoLength && papmino.length>0) { 
            papmino=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",papmino,CTLocID);
            $("#papmino").val(papmino);
    }
    
    
    var patname=getValueById("patname");
    var telno=getValueById("telno");
    var PatLoc=getValueById("PatLoc");
    var BeginDate=getValueById("BeginDate");
    var EndDate=getValueById("EndDate");
    var Condition=$("#Condition").checkbox('getValue');
    var ZSCondition=$("#ZSCondition").checkbox('getValue');
    var FollowFlag=$("#FollowFlag").checkbox('getValue');
    //$("#patform").form("clear");
    closeAllTabs('QuestionTab');
    $("#PatListTab").datagrid('load',{
                ClassName:"web.DHCCRM.PatInfo",
                QueryName:"SearchPatInfo",
                patno:papmino,
                patname:patname,
                patdisdiag:"",
                startdate:BeginDate,
                enddate:EndDate,
                FollowFlag:FollowFlag,
                OutHosLoc:PatLoc,
                Condition:Condition,
                TelNo:telno,
                ZSCondition:ZSCondition
         }); 
    
}

function DelNoQR()
{
    
    var plan=getValueById("FuplanID");
    if(plan=="")
    {
        $.messager.alert("��ʾ","��ѡ��Ҫɾ���ļ�¼!","info");
        return false; 
        
    }
    
    var ret = tkMakeServerCall("web.DHCCRM.FUSubject", "DeleteFupById",plan);
    if(ret==0){
            setValueById("FuplanID","") 
            $.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
            
        }else{
            if(ret==1) ret="����ò�����ɾ��!"
            $.messager.alert('������ʾ',"ɾ��ʧ��:"+ret,"error");
        }
        
    BFind();
}
function jump(){
            
            
            RTime = RTime + 1;
            
            $("#RTimeLabel").empty();
            var qtd='<p><h1><br><FONT SIZE =3 color=red>��¼��ʱ��'+ RTime + '��</FONT></h1></p>'
            $("#RTimeLabel").append(qtd);
            
����          
}
function DoMakeCall(){
        var telnumber=getValueById("mrtel");
        var telfup=getValueById("FuplanID");
        if(telfup=="")
        {
            $.messager.alert("��ʾ","��ѡ��Ҫ�����ļ�¼!","info");
            return false; 
        
        }
        try
        {
        DHCTel.InitFrom(Job);
        DHCTel.Dialing(telnumber);
        
        var savefile="D:\\"+telfup+".wav";
        
        DHCTel.StartRecord(savefile,1);
        var saveret = tkMakeServerCall("web.DHCCRM.PatInfo", "SaveSound",savefile,telfup);
        var saveret=tkMakeServerCall("web.DHCCRM.PatInfo", "SaveStartTime",telfup);
        
        
        qtask=setInterval("jump()",1000); 
        }
        catch(err) {
            $.messager.alert('������ʾ',"δ���Ӳ����豸�����Ӳ��ɹ���","error");
        }
        
    }
    
function DoHangupCall()
    {
        var telfup=getValueById("FuplanID");
        try
        {
        DHCTel.StopRecord();
        DHCTel.HangTel();
        clearInterval(qtask);
        var saveret = tkMakeServerCall("web.DHCCRM.PatInfo", "SaveEndTime",telfup);
        var RadioTime=tkMakeServerCall("web.DHCCRM.PatInfo", "GetRadioTime",telfup);
        if(RadioTime<30)
        {
            //$.messager.alert("��ʾ","¼��ʱ������30��!","info");
            //return false; 
        }
        }
        catch(err) {
            $.messager.alert('������ʾ',"δ���Ӳ����豸�����Ӳ��ɹ���","error");
        }
       
    }
function DoRadio()
{
    
    var telfup = getValueById("FuplanID");
    var LuYinFile=tkMakeServerCall("web.DHCCRM.PatInfo", "GetSound",telfup);
    
    if (LuYinFile == "") {
        $.messager.alert("��ʾ","δ�ҵ�¼���ļ�!","info");
            return false; 
                        
     }
     
     $HUI.window("#lywindow",{
        title:"����¼��",
        iconCls:"icon-w-run",
        collapsible:false,
        minimizable:false,
        maximizable:false,
        resizable:false,
        modal:true,
        width:420,
        height:400,
        content:'<embed width="420" height="360" src='+ LuYinFile + '></embed>'
    });
    
    
 }
 
 
 function LinkConfig()
 {
    $("#LinkConfigDiv").show();
    $HUI.window("#LinkConfigDiv",{
        title:"��ϵ����ԭ��ά��",
        collapsible:false,
        minimizable:false,
        iconCls:'icon-w-paper',
        modal:true
    });
    
    $("#LinkConfigTab").datagrid("load",{ClassName:"web.DHCCRM.PatInfo",QueryName:"QueryAll",Parref:ParrefRowId}); 
    LCeditIndex=undefined;
     
 }