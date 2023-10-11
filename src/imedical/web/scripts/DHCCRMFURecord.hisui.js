//名称    DHCCRMFURecord.hisui.js
//功能    随访记录 HISUI
//创建    2020-11-26
//创建人  yupeng

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
            {field:'Code',title:'编码',editor:'text',width:150},
            {field:'Reason',title:'原因',editor:'text',width:250},
            {field:'Type',title:'类型',width:150,
            formatter:function(value,row){
                    return row.TypeDesc;
                },
            editor:{
                    type:'combobox',
                    options:{
                        valueField:'id',
                        textField:'text',
                        data:[
                            {id:'Z',text:'暂时联系不上'},{id:'L',text:'联系不上'}
                        ]
                        
                    }
                }
            
            
            
            
            },
            {field:'Seq',title:'顺序',editor:'text',width:100},
            {field:'Active',title:'激活',editor:{type:'icheckbox',options:{on:'Y',off:'N'}},formatter:function(data, value, index) {
                return data=="Y"?"是":"否";}}
            
        ]],
        toolbar:[{
            iconCls:'icon-add',
            text:'新增',
            handler: function(){
                
                
                
                if(LCeditIndex != undefined)
                {
                    $.messager.alert("提示","还有未保存的数据，请点击修改!","info");    
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
            text:'修改',
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
                $.messager.alert('提示',"编码、原因、类型和顺序不能为空！","error");
                return false;
            }
            
            
            
            var flag=tkMakeServerCall("web.DHCCRM.CRMBaseSet","UpdateLinkReason",ID,Code,Reason,Type,Seq,Active);
            if (flag==0)
            {
                $("#LinkConfigTab").datagrid("load",{ClassName:"web.DHCCRM.CRMBaseSet",QueryName:"FindContractReason"}); 

            }
            else 
            {
                $.messager.alert("提示",flag,"info"); 
                $("#LinkConfigTab").datagrid("load",{ClassName:"web.DHCCRM.CRMBaseSet",QueryName:"FindContractReason"}); 

            }
            
        }
            
    });
    
})

function closeAllTabs(id){  
         var arrTitle = new Array();  
         var id = "#"+id;//Tab所在的层的ID  
         var tabs = $(id).tabs("tabs");//获得所有小Tab  
         var tCount = tabs.length;  
         if(tCount>0){  
                     //收集所有Tab的title  
             for(var i=0;i<tCount;i++){  
                 arrTitle.push(tabs[i].panel('options').title)  
             }  
                     //根据收集的title一个一个删除=====清空Tab  
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
        displayMsg:"",//隐藏分页下面的文字"显示几页到几页,共多少条数据"
        singleSelect: true,
        selectOnCheck: true,
        queryParams:{
            ClassName:"web.DHCCRM.PatInfo",
            QueryName:"SearchPatInfo"
        },
        columns:[[
            {field:'fuprowid',title:'ID',hidden:true},
            {field:'pattype',title:'类型'},
            {field:'papmino',title:'登记号'},
            {field:'mrid',title:'病案号'},
            {field:'mrname',title:'姓名'},
            {field:'mrgender',title:'性别'}, 
            {field:'mrbirthday',title:'年龄'},
            {field:'mrcardid',title:'身份证号'}, 
            {field:'mrtel',title:'电话'},
            {field:'admdate',title:'入院/就诊日期'},
            {field:'disdate',title:'出院日期'}, 
            {field:'disdiag',title:'诊断'},  
            {field:'disroom',title:'出院科室'},
            {field:'DocName',title:'主治医师'},
            {field:'mraddress',title:'联系地址'},  
            {field:'deadflag',title:'院外死亡'},
            {field:'fupDate',title:'计划随访日期'}
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
                var chiletitle="一级随访";
                if(childstr[1]==2) chiletitle="二级随访";
                if(childstr[1]==3) chiletitle="三级随访";
                $('#QuestionTab').tabs('add',{
                    selected:false,
                    id:childstr[0],
                    title:chiletitle,
                    content: contentstr
                });
                
                
            }
            
            $('#QuestionTab').tabs('select',0);
            
            if(rowData.deadflag=="死亡")
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
    //电话
    var ret = tkMakeServerCall("web.DHCCRM.PatInfo", "UpdateTel", personid,newtel);
    
    
    var iSetDead="0";
    var SetDead=$("#SetDead").checkbox('getValue');
    if(SetDead) {iSetDead="1";}
    var fupid=getValueById("FuplanID");
    //死亡
    var ret = tkMakeServerCall("web.DHCCRM.FUSubject", "SetDeadFlag", iSetDead,fupid);
    
    var str = tkMakeServerCall('web.DHCCRM.FUSubject',"GetLinkNum", fupid);
    var num = str.split("^")[0];
    var oldreason = str.split("^")[1];
    num = parseInt(num) + 1;
    
    
    var ret=tkMakeServerCall('web.DHCCRM.FUSubject', "SetLinkInfo", fupid, "Z")
    var RealLinkFlag="";
    if(num==1)
    {
    //联系情况1
    var reason=getValueById("LinkCondition1");
    RealLinkFlag=tkMakeServerCall('web.DHCCRM.CRMBaseSet', "GetRealLinkFlag",reason)
    if(RealLinkFlag=="L") tkMakeServerCall('web.DHCCRM.FUSubject', "SetLinkInfo", fupid, "L") 
    if(reason!="") var ret = tkMakeServerCall('web.DHCCRM.FUSubject', "SetLinkFlag",fupid, num, reason)
    }
    if(num==2)
    {
    //联系情况2
    var reason2=getValueById("LinkCondition2");
    RealLinkFlag=tkMakeServerCall('web.DHCCRM.CRMBaseSet', "GetRealLinkFlag",reason2)
    if(RealLinkFlag=="L") tkMakeServerCall('web.DHCCRM.FUSubject', "SetLinkInfo", fupid, "L") 
    var reason = oldreason + ";" + reason2;
    
    if(reason2!="") var ret = tkMakeServerCall('web.DHCCRM.FUSubject', "SetLinkFlag",fupid, num, reason)
    }
    if(num==3)
    {
    //联系情况3
    var reason3=getValueById("LinkCondition3");
    RealLinkFlag=tkMakeServerCall('web.DHCCRM.CRMBaseSet', "GetRealLinkFlag",reason3)
    if(RealLinkFlag=="L") tkMakeServerCall('web.DHCCRM.FUSubject', "SetLinkInfo", fupid, "L") 
    var reason = oldreason + ";" + reason3;
    if(reason3!="") var ret = tkMakeServerCall('web.DHCCRM.FUSubject', "SetLinkFlag",fupid, num, reason)
    }
    
    
    if (num == 3)
            tkMakeServerCall('web.DHCCRM.FUSubject', "SetLinkInfo", fupid, "L")
    
    
    
    if(ret==0){
            $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
            
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
            $.messager.alert('操作提示',"保存失败","error");
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
        $.messager.alert("提示","请选择要删除的记录!","info");
        return false; 
        
    }
    
    var ret = tkMakeServerCall("web.DHCCRM.FUSubject", "DeleteFupById",plan);
    if(ret==0){
            setValueById("FuplanID","") 
            $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
            
        }else{
            if(ret==1) ret="已随访不允许删除!"
            $.messager.alert('操作提示',"删除失败:"+ret,"error");
        }
        
    BFind();
}
function jump(){
            
            
            RTime = RTime + 1;
            
            $("#RTimeLabel").empty();
            var qtd='<p><h1><br><FONT SIZE =3 color=red>已录音时间'+ RTime + '秒</FONT></h1></p>'
            $("#RTimeLabel").append(qtd);
            
　　          
}
function DoMakeCall(){
        var telnumber=getValueById("mrtel");
        var telfup=getValueById("FuplanID");
        if(telfup=="")
        {
            $.messager.alert("提示","请选择要操作的记录!","info");
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
            $.messager.alert('操作提示',"未连接拨号设备或连接不成功！","error");
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
            //$.messager.alert("提示","录音时间少于30秒!","info");
            //return false; 
        }
        }
        catch(err) {
            $.messager.alert('操作提示',"未连接拨号设备或连接不成功！","error");
        }
       
    }
function DoRadio()
{
    
    var telfup = getValueById("FuplanID");
    var LuYinFile=tkMakeServerCall("web.DHCCRM.PatInfo", "GetSound",telfup);
    
    if (LuYinFile == "") {
        $.messager.alert("提示","未找到录音文件!","info");
            return false; 
                        
     }
     
     $HUI.window("#lywindow",{
        title:"播放录音",
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
        title:"联系不上原因维护",
        collapsible:false,
        minimizable:false,
        iconCls:'icon-w-paper',
        modal:true
    });
    
    $("#LinkConfigTab").datagrid("load",{ClassName:"web.DHCCRM.PatInfo",QueryName:"QueryAll",Parref:ParrefRowId}); 
    LCeditIndex=undefined;
     
 }