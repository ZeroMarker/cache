
//名称    dhcpedocpatient.hisui.js
//功能    
//创建    
//创建人  yp

var vRoomRecordID="";
function SetRoomInfo()
{
    var Info=GetComputeInfo("IP");  //计算机名称  DHCPECommon.js
    var RoomID=tkMakeServerCall("web.DHCPE.RoomManager","GetRoomIDByCompute",Info);
   
    if (RoomID=="") return false;
    
    $('#PersonTab').tabs('select',"叫号列表");
    setValueById("RoomID",RoomID.split("$")[0]);
}

var init = function(){
    
    $("#PersonTab").tabs({
            tools:[
            /*{
            iconCls:'icon-w-update',
            handler:function(){
                
            }
            },*/
            {
            iconCls:'icon-arrow-left',
            handler:function(){
                $('#DocPanel').layout('collapse','west');
                $("#StationTab").tabs("resize");
            }
            }]
        });
    
    
    
    $('#PersonTab').tabs('select',"体检列表");
    
    SetRoomInfo();
    
    $("#RegNo").focus();
    
    /// 病人信息列表  卡片样式
    function setCellLabel(value, rowData, rowIndex){
        var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;">'+ rowData.Name
         +'</h3><h3 style="float:right;background-color:transparent;"><span>'+ rowData.Sex +'/'+ rowData.Age 
         +'</span></h3><br>'+'<h3 style="float:left;background-color:transparent;"><span>'+ rowData.AdmDate
         +'</span></h3>';
         
        
        if((rowData.Status=="NE")||(rowData.Status=="N")){
            
        if(rowData.DetailStatus=="E"){
                    htmlstr = htmlstr + '<h3 style="float:right;background-color:transparent;"><span>'+ '正检'
                    +'</span></h3>';
            
                }
                
        if(rowData.DetailStatus=="C"){
                    htmlstr = htmlstr + '<h3 style="float:right;background-color:transparent;"><span>'+ '呼叫'
                    +'</span></h3>';
            
                }       
        if(rowData.DetailStatus==""){
                    htmlstr = htmlstr + '<h3 style="float:right;background-color:transparent;"><span>'+ '等待'
                    +'</span></h3>';
            
                }   
        }       
                
        if(rowData.Status=="P"){
                    htmlstr = htmlstr + '<h3><a><img style="float:right;background-color:transparent;" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel_order.png"  title="过号启用" border="0" onclick="ReStartPass('+rowData.RecordID+')"></a></h3>';
            
                }
        
        htmlstr = htmlstr + '<br> <h4 style="float:left;background-color:transparent;">ID:'+ rowData.PAPMINo +'</h4>';
        var classstyle="color: #18bc9c";
        if(rowData.VIPLevel!=""){
            if(rowData.VIPLevel==3) {classstyle="color: #f9bf3b"};
            if(rowData.VIPLevel==1) {classstyle="color: #3c78d8"};
            if(rowData.VIPLevel==2) {classstyle="color: #f22613"};
            htmlstr = htmlstr +'<h4 style="float:right;background-color:transparent;"><span style="'+classstyle+'" style="width:50%;padding-bottom: 0px;padding-top: 0px">'+rowData.VIPDesc+'</span></h4>';
        }
        htmlstr = htmlstr +'</div>';
        return htmlstr;
    }
    
    var VIPObj = $HUI.combobox("#VIP",{
        url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
        valueField:'id',
        textField:'desc'
        })
    
    $("#Query").click(function(){
            Query();
        });
    $("#CallQuery").click(function(){
            CallQuery();
        }); 
        
    $("#NowData").click(function(){
            NowData();
        });
    
    $("#RegNo").change(function(){
            RegNoOnChange();
        });
        
    
    $("#RegNo").keydown(function(e) {
            
            if(e.keyCode==13){
                RegNoOnChange();
            }
            
        });
     
    $("#Name").keydown(function(e) {
            
            if(e.keyCode==13){
                Query();
            }
            
        }); 

    $("#CallRegNo").change(function(){
            CallRegNoOnChange();
        });
        
    
    $("#CallRegNo").keydown(function(e) {
            
            if(e.keyCode==13){
                
                CallRegNoOnChange();
            }
            
        });   
    
    
    
    
    
    
    if(OtherPAADM!="")
    {
        var Flag=tkMakeServerCall("web.DHCPE.ResultNew","IsOPPerson",OtherPAADM)
        if(Flag=="1")
        {
            $("#tPEDate").css('display','none');//隐藏
            $("#tVIPLevel").css('display','none');//隐藏
            $("#tPEDateLine").css('display','none');//隐藏
            $("#tVIPLevelLine").css('display','none');//隐藏
        }else{
            $("#tPEDate").css('display','block');//显示
            $("#tVIPLevel").css('display','block');//显示
            $("#tPEDateLine").css('display','block');//显示
            $("#tVIPLevelLine").css('display','block');//显示
            
        }

        var info=tkMakeServerCall("web.DHCPE.BarPrint","GetPatientInfo",OtherPAADM)
        var ParInfo=info.split("^")
            $('#patName').text(ParInfo[4]);
            $('#sexName').text(ParInfo[3]);
            $('#Age').text(ParInfo[7]);
            $('#PatNo').text(ParInfo[0]);
            $('#PEDate').text("");
            $('#VIPLevel').text("");
            //$('#PatNoName').text("登记号：");
            if (ParInfo[3] == '男') {
                //$('#sex').removeClass('woman').addClass('man');
            } else {
                //$('#sex').removeClass('man').addClass('woman');
            }
        
        //$('#DocPanel').layout('collapse','west');
        PEShowPicByPatientIDForDoc(ParInfo[12],"sex");
        $("#PAADM_Hidden").val(OtherPAADM);
        ShowStationPanel(OtherPAADM);
        
    }
    
    var CallVoiceListObj = $HUI.datagrid("#CallVoiceList",{
        url:$URL,
        showHeader:false,
        border:false,
        pagination:true,
        singleSelect:true,
        pageSize:20,
        showRefresh:false,
        displayMsg:"",
        showPageList:false,
        fit:true,
        queryParams:{
            ClassName:"web.DHCPE.ResultNew",
            QueryName:"FindCallVoicePatInfo",
            RegNo:"",
            RoomID:getValueById("RoomID"),
            HospID:session['LOGON.HOSPID']

        },
        columns:[[
            {field:'PatLabel',title:'',width:260,formatter:setCellLabel},
            {field:'PaadmID',hidden:true},
            {field:'PaPatID',hidden:true},
            {field:'PAPMINo',title:'登记号',width:50,hidden:true},
            {field:'AdmDate',title:'体检日期',width:50,hidden:true},
            {field:'Name',title:'姓名',width:50,hidden:true},
            {field:'Age',title:'年龄',width:50,hidden:true},
            {field:'Sex',title:'性别',width:50,hidden:true},
            {field:'VIPLevel',title:'VIP',width:50,hidden:true},
            {field:'VIPDesc',title:'VIP等级',width:50,hidden:true},
            {field:'Status',title:'状态',width:50,hidden:true},
            {field:'RecordID',width:50,hidden:true},
            {field:'DetailStatus',width:50,hidden:true}
        ]],
        onLoadSuccess:function(e){   
        var eSrc=window.event.srcElement;
        
        var tab = $('#PersonTab').tabs('getSelected');
        //alert(tab)
        var index = $('#PersonTab').tabs('getTabIndex',tab)
        //alert(index)
        //debugger;  //33
        if($("#CallRegNo").val()=="") return false;
        //debugger; // 77
        if(index!=0) return false;
            var rows=$('#CallVoiceList').datagrid("getRows");
            if (rows.length > 0) {
            var row=rows[0];
            var RoomID=getValueById("RoomID")
                var PAADM=row.PaadmID
                var ret=tkMakeServerCall("web.DHCPE.RoomManager","CanCheck",RoomID,PAADM);
                if (ret=="1"){
                    alert("存在必须先检查的项目,请先去做相关检查")
                    return false;
                }
                if (ret=="-1"){
                    alert("该诊室已经放弃,不允许操作")
                    return false;
                }
                var ret=tkMakeServerCall("web.DHCPE.RoomManager","ArriveByPAADM",RoomID,PAADM);
                
                var Arr=ret.split("^");
                var ret=Arr[0];
                if (ret==""){  //不在当前诊室
                    
                    vRoomRecordID="";
                    return false;
                }else{ //在当前诊室
                    var Record=Arr[0];
                    var Status=Arr[1];
                    var DetailStatus=Arr[2];
                    if (Status=="N"){  //判断是不是同一个人
                        if (DetailStatus==""){ //还没有叫号
                            return false;
                        }
                        if (DetailStatus!="E"){  //不是正检状态的，设置正检，下屏
                            vRoomRecordID=Record;
                            var UserID=session['LOGON.USERID'];
                            var ret=tkMakeServerCall("web.DHCPE.RoomManager","ArriveCurRoom",Record,UserID,RoomID);
                            $('#patName').text(row.Name);
                            $('#patName').text(row.Name);
                            $('#sexName').text(row.Sex);
                            $('#Age').text(row.Age);
                            $('#PatNo').text(row.PAPMINo);
                            $('#PEDate').text(row.AdmDate);
                            $('#VIPLevel').text(row.VIPDesc);
                            //$('#PatNoName').text("登记号：");
            
                            PEShowPicByPatientIDForDoc(row.PaPatID,"sex")
                            ShowStationPanel(row.PaadmID);
                             setValueById("EpisodeID",row.PaadmID)
                            return false;
                            
                        }
                        if (DetailStatus=="E"){  //不是正检状态的，设置正检，下屏
                            
                            
                        }
                    }
                    
                    
                }
             
              
            }
        },
        onDblClickRow:function(rowIndex, rowData){

                var HospID=session['LOGON.HOSPID'];
                var RoomID=getValueById("RoomID");
                var PAADM=rowData.PaadmID;
                var ret=tkMakeServerCall("web.DHCPE.RoomManager","CanCheck",RoomID,PAADM);
                if (ret=="1"){
                    alert("存在必须先检查的项目,请先去做相关检查")
                    return false;
                }
                if (ret=="-1"){
                    alert("该诊室已经放弃,不允许操作");
                    return false;
                }
                var ret=tkMakeServerCall("web.DHCPE.RoomManager","ArriveByPAADM",RoomID,PAADM);
                
                var Arr=ret.split("^");
                var ret=Arr[0];
                if (ret==""){  //不在当前诊室
                    var TypeFlag=Arr[1];
                    if  (TypeFlag=="2"){
                        if (!confirm("体检者未排队到本诊室,是否查体?")) return false;
                    }else if (TypeFlag=="1"){
                        if (!confirm("已完成本科室检查,是否需要修改?")) return false;
                    }
                    vRoomRecordID="";
                }else{ //在当前诊室
                    var Record=Arr[0];
                    var Status=Arr[1];
                    var DetailStatus=Arr[2];
                    if (Status=="N"){  //判断是不是同一个人
                        if (DetailStatus==""){ //还没有叫号
                            if (!confirm("到达者和叫号者不是同一个人,是否继续?")) return false;
                        }
                        if (DetailStatus!="E"){  //不是正检状态的，设置正检，下屏
                            var UserID=session['LOGON.USERID'];
                            var ret=tkMakeServerCall("web.DHCPE.RoomManager","ArriveCurRoom",Record,UserID,RoomID);
                            
                        }
                    }
                    $("#CallVoiceList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindCallVoicePatInfo",RegNo:"",RoomID:getValueById("RoomID"),HospID:HospID}); 

                    vRoomRecordID=Record;
                }
            
            
            
            $('#patName').text(rowData.Name);
            $('#sexName').text(rowData.Sex);
            $('#Age').text(rowData.Age);
            $('#PatNo').text(rowData.PAPMINo);
            $('#PEDate').text(rowData.AdmDate);
            $('#VIPLevel').text(rowData.VIPDesc);
            //$('#PatNoName').text("登记号：");
            $('#ReMark').text(rowData.ReMark);
            $("#GName").text(rowData.GName);
            /*
            if (rowData.Sex == '男') {
                $('#sex').removeClass('woman').addClass('man');
            } else {
                $('#sex').removeClass('man').addClass('woman');
            }
            */
            PEShowPicByPatientIDForDoc(rowData.PaPatID,"sex");
            ShowStationPanel(rowData.PaadmID);
            setValueById("EpisodeID",rowData.PaadmID);
        }
    });
    
    
    
    
    var NoCheckListObj = $HUI.datagrid("#NoCheckList",{
        url:$URL,
        showHeader:false,
        border:false,
        pagination:true,
        singleSelect:true,
        pageSize:20,
        showRefresh:false,
        displayMsg:"",
        showPageList:false,
        fit:true,
        queryParams:{
            ClassName:"web.DHCPE.ResultNew",
            QueryName:"FindPatInfo",
            RegNo:"",
            CFlag:"N",
            OtherPAADM:OtherPAADM,
            HospID:session['LOGON.HOSPID']

        },
        columns:[[
            {field:'PatLabel',title:'',width:250,formatter:setCellLabel},
            {field:'PaadmID',hidden:true},
            {field:'PaPatID',hidden:true},
            {field:'PAPMINo',title:'登记号',width:50,hidden:true},
            {field:'AdmDate',title:'体检日期',width:50,hidden:true},
            {field:'Name',title:'姓名',width:50,hidden:true},
            {field:'Age',title:'年龄',width:50,hidden:true},
            {field:'Sex',title:'性别',width:50,hidden:true},
            {field:'VIPLevel',title:'VIP',width:50,hidden:true},
            {field:'VIPDesc',title:'VIP等级',width:50,hidden:true}
        ]],
        onClickRow:function(rowIndex, rowData){
            
            $('#patName').text(rowData.Name);
            $('#sexName').text(rowData.Sex);
            $('#Age').text(rowData.Age);
            $('#PatNo').text(rowData.PAPMINo);
            $('#PEDate').text(rowData.AdmDate);
            $('#VIPLevel').text(rowData.VIPDesc);
            //$('#PatNoName').text("登记号：");
            $('#ReMark').text(rowData.ReMark);
            $("#GName").text(rowData.GName);
            /*
            if (rowData.Sex == '男') {
                $('#sex').removeClass('woman').addClass('man');
            } else {
                $('#sex').removeClass('man').addClass('woman');
            }
            */
            PEShowPicByPatientIDForDoc(rowData.PaPatID,"sex")
            var ArriveFlag=tkMakeServerCall("web.DHCPE.ResultEdit","IsArrivedStatu",rowData.PaadmID);
            var PIADM=tkMakeServerCall("web.DHCPE.DHCPECommon","GetPIADMByPaadm",rowData.PaadmID)
            if((ArriveFlag==0)&&(PIADM!="")){
                $.messager.confirm("提示", "该客户没到达，确认要到达吗?", function (r) {
                if (r) {
                    
                    var rtn=tkMakeServerCall("web.DHCPE.DHCPEIAdm","IAdmArrived",PIADM);
                    if(rtn==0){
                        $("#PAADM_Hidden").val(rowData.PaadmID);
                        ShowStationPanel(rowData.PaadmID);
                        setValueById("EpisodeID",rowData.PaadmID);
                     }else{
                        $.messager.alert("提示","操作失败:"+flag,"info");
                        return false;

                      }
                }
                else
                {
                    closeAllTabs('StationTab');
                    
                }
             });
        
            } 
      if(ArriveFlag!=0){
            
            $("#PAADM_Hidden").val(rowData.PaadmID);
            
            ShowStationPanel(rowData.PaadmID);
            setValueById("EpisodeID",rowData.PaadmID)
      }
        },
        onLoadSuccess:function(e){   
        /*
        var eSrc=window.event.srcElement;
        var tab = $('#PersonTab').tabs('getSelected');
        
        var index = $('#PersonTab').tabs('getTabIndex',tab)
        
        if(index!=1) return false
            var rows=$('#NoCheckList').datagrid("getRows");
            if (rows.length > 0) {
            var row=rows[0];
            
            
            $('#patName').text(row.Name);
            $('#sexName').text(row.Sex);
            $('#Age').text(row.Age);
            $('#PatNo').text(row.PAPMINo);
            $('#PEDate').text(row.AdmDate);
            $('#VIPLevel').text(row.VIPDesc);
            $('#PatNoName').text("登记号：");
            
            PEShowPicByPatientIDForDoc(row.PaPatID,"sex")
            
            
            $("#PAADM_Hidden").val(row.PaadmID);
            
            ShowStationPanel(row.PaadmID);
            setValueById("EpisodeID",row.PaadmID)
            
                
              
            }
         */
        }
    });
    
    var HadCheckListObj = $HUI.datagrid("#HadCheckList",{
        url:$URL,
        showHeader:false,
        pagination:true,
        singleSelect:true,
        border:false,
        pageSize:20,
        showRefresh:false,
        displayMsg:"",
        showPageList:false,
        fit:true,
        queryParams:{
            ClassName:"web.DHCPE.ResultNew",
            QueryName:"FindPatInfo",
            RegNo:"",
            CFlag:"Y",
            OtherPAADM:OtherPAADM,
            HospID:session['LOGON.HOSPID']

        },
        columns:[[
            {field:'PatLabel',title:'',width:250,formatter:setCellLabel},
            {field:'PaadmID',hidden:true},
             {field:'PaPatID',hidden:true},
            {field:'PAPMINo',title:'登记号',width:50,hidden:true},
            {field:'AdmDate',title:'体检日期',width:50,hidden:true},
            {field:'Name',title:'姓名',width:50,hidden:true},
            {field:'Age',title:'年龄',width:50,hidden:true},
            {field:'Sex',title:'性别',width:50,hidden:true},
            {field:'VIPLevel',title:'VIP',width:50,hidden:true},
            {field:'VIPDesc',title:'VIP等级',width:50,hidden:true}
        ]],
        onClickRow:function(rowIndex, rowData){
            
            $('#patName').text(rowData.Name);
            $('#sexName').text(rowData.Sex);
            $('#Age').text(rowData.Age);
            $('#PatNo').text(rowData.PAPMINo);
            $('#PEDate').text(rowData.AdmDate);
            $('#VIPLevel').text(rowData.VIPDesc);
            //$('#PatNoName').text("登记号：");
            $('#ReMark').text(rowData.ReMark);
            $("#GName").text(rowData.GName);
             /*
            if (rowData.Sex == '男') {
                $('#sex').removeClass('woman').addClass('man');
            } else {
                $('#sex').removeClass('man').addClass('woman');
            }
            */
            PEShowPicByPatientIDForDoc(rowData.PaPatID,"sex")
            
            $("#PAADM_Hidden").val(rowData.PaadmID);
            ShowStationPanel(rowData.PaadmID);
            setValueById("EpisodeID",rowData.PaadmID)
        }
    });
    if(CheckFlag=="Y") $("#CheckListAc").accordion("select", "已检队列");
    
};
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
 
function ShowStationPanel(PAADM)
{
    closeAllTabs('StationTab');
    var LocID=session['LOGON.CTLOCID'];
    var UserID=session['LOGON.USERID'];
    var GroupID=session['LOGON.GROUPID'];

    var DStFlag=0;
   
    var DefaultStation=tkMakeServerCall("web.DHCPE.DocPatientFind","GetDefaultStation",UserID,LocID,GroupID);
    var StationInfo=tkMakeServerCall("web.DHCPE.DocPatientFind","GetStationList",PAADM,UserID,LocID,GroupID);

    if(StationInfo==""){
        $.messager.alert("提示","没有可录入的医嘱","info");
          return false;

    }
    var StationList=StationInfo.split(",");
    for(var i=0;i<StationList.length;i++)
    {
        var StationDetail=StationList[i].split("^");
        if(StationDetail[1]==DefaultStation){var DStFlag=1;}
        
        if (StationDetail[0] == "SYMPTOM") {  // 症状
            var url = "dhcpe.occu.symptomsinfo.csp?PAADM=" + PAADM;
        } else if (StationDetail[0] == "OCCINFO") {  // 职业健康信息
            var url = "dhcpeoccupationalinfo.hisui.csp?PAADM=" + PAADM;
        } else {
            var url = "dhcpedocpatient.station.hisui.csp?PAADM="+PAADM+"&StationID="+StationDetail[0];
        }
        
        var tabframe="tabframe"+StationDetail[0];
        var contentstr = '<iframe id="'+tabframe+'" scrolling="yes" frameborder="0"  src="'+PEURLAddToken(url)+'" style="width:100%;height:99%;"></iframe>';
        var icon="";
        //alert(StationDetail[2]+"StationDetail[2]")
        if(StationDetail[2]>0){
             icon="icon-accept";
        }
        $('#StationTab').tabs('add',{
            selected:false,
            id:StationDetail[0],
            title:StationDetail[1],
            content: contentstr,
            icon:icon
        });
    
    }
    
    /*var DefaultStation=tkMakeServerCall("web.DHCPE.DocPatientFind","GetDefaultStation");
    $('#StationTab').tabs('select',0);
    $('#StationTab').tabs('select',DefaultStation);
    */
    if(DStFlag=="1"){$('#StationTab').tabs('select',DefaultStation);}
    else{$('#StationTab').tabs('select',0);}
    
}   

//获取当前时间，格式YYYY-MM-DD
function getNowFormatDate() {
        var date = new Date();
        var seperator1 = "-";
        var year = date.getFullYear();
        var month = date.getMonth() + 1;
        var strDate = date.getDate();
        if (month >= 1 && month <= 9) {
            month = "0" + month;
        }
        if (strDate >= 0 && strDate <= 9) {
            strDate = "0" + strDate;
        }
        var currentdate = year + seperator1 + month + seperator1 + strDate;
        return currentdate;
    }
function NowData()
{
    var HospID=session['LOGON.HOSPID']
    var NowDate=getNowFormatDate();
    var VIP=getValueById("VIP")
    $("#NoCheckList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindPatInfo",RegNo:"",BDate:NowDate,EDate:"",VIP:VIP,CFlag:"N",HospID:HospID}); 
    $("#HadCheckList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindPatInfo",RegNo:"",BDate:NowDate,EDate:"",VIP:VIP,CFlag:"Y",HospID:HospID}); 
}

function RegNoOnChange()
{
    var CTLocID=session['LOGON.CTLOCID'];
    var HospID=session['LOGON.HOSPID'];
    var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength",CTLocID);
    var iRegNo= $("#RegNo").val();
    if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
            iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo,CTLocID);
            $("#RegNo").val(iRegNo);
    }
    
    $("#NoCheckList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindPatInfo",RegNo:$("#RegNo").val(),CFlag:"N",HospID:HospID});  
    $("#HadCheckList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindPatInfo",RegNo:$("#RegNo").val(),CFlag:"Y",HospID:HospID}); 
}
function CallRegNoOnChange()
{
    var CTLocID=session['LOGON.CTLOCID'];
    var HospID=session['LOGON.HOSPID'];
    var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength",CTLocID);
    var iRegNo= $("#CallRegNo").val();
    if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
            iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo,CTLocID);
            $("#CallRegNo").val(iRegNo);
    }
    
    $("#CallVoiceList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindCallVoicePatInfo",RegNo:$("#CallRegNo").val(),RoomID:$("#RoomID").val(),HospID:HospID}); 
   
}

function CallQuery()
{

      var HospID=session['LOGON.HOSPID']
    $("#CallVoiceList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindCallVoicePatInfo",RegNo:$("#CallRegNo").val(),RoomID:$("#RoomID").val(),HospID:HospID}); 
}

function Query()
{
    var CTLocID=session['LOGON.CTLOCID'];
    var HospID=session['LOGON.HOSPID'];
    var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength",CTLocID);
    var iRegNo= $("#RegNo").val();
    if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
            iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo,CTLocID);
            $("#RegNo").val(iRegNo);
    }
    
    var Name=$("#Name").val();
    var BDate=getValueById("BDate");
    var EDate=getValueById("EDate");
    var VIP=getValueById("VIP");

    $("#NoCheckList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindPatInfo",RegNo:iRegNo,BDate:BDate,EDate:EDate,VIP:VIP,CFlag:"N",PatName:Name,HospID:HospID}); 
    $("#HadCheckList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindPatInfo",RegNo:iRegNo,BDate:BDate,EDate:EDate,VIP:VIP,CFlag:"Y",PatName:Name,HospID:HospID}); 
}

function GetNextInfo(IsCall)
{
    if(IsCall==undefined) IsCall="N";
    var RoomID=getValueById("RoomID")
    if (RoomID=="") 
    {
        $.messager.alert("提示","该诊室未启用排队叫号！","info");
        return false;
    }
    debugger; // 1
    var Info=tkMakeServerCall("web.DHCPE.RoomManagerEx","GetNextInfo",RoomID,IsCall)
    debugger; // Info
    return Info;
}
function Call()
{
    var Info=GetNextInfo("Y");
    var Arr=Info.split("^");
    var RecordID=Arr[0];
    var CallName=Arr[1];
    if (RecordID==""){
        $.messager.alert("提示","没有排队记录！","info");
        return false;
    }
    CallApp(RecordID,CallName);
}

function CallApp(RecordID,CallName)
{
    debugger; //22
    var OldRecord=vRoomRecordID;
    
    if ((OldRecord!=RecordID)&&(OldRecord!=""))
    {
        var Status=tkMakeServerCall("web.DHCPE.RoomManagerEx","GetRecordStatus",OldRecord)
        
        var StatusArr=Status.split("^");
        var DetailStatus=StatusArr[1];
        var Status=StatusArr[0];
        if (Status=="N"){
            if (!confirm("当前体检者,还没有完成,是否开始下一个?")){
                return false;
            }
        }
    }
    
    
    var rtn=tkMakeServerCall("web.DHCPE.RoomManager","CallCurRoom",RecordID)
    
    var Arr=rtn.split("^");
    if (Arr[0]!="0"){
        alert(Arr[1]);
    }
    var myDiv=document.getElementById("WaitInfo");
    myDiv.innerText="正在呼叫："+CallName;
    vRoomRecordID=RecordID;
    
    
}
function Delay()
{
    var HospID=session['LOGON.HOSPID'];

    $.messager.confirm("提示", "确认要顺延吗?", function (r) {
    if (r) {
        
    var Info=GetNextInfo();
    var Arr=Info.split("^");
    var RecordID=Arr[0];
    
    if (RecordID==""){
        $.messager.alert("提示","没有排队记录！","info");
        return false;
    }
    var CallName=Arr[1];
    var rtn=tkMakeServerCall("web.DHCPE.RoomManager","DelayCurRoomInfo",RecordID)
    
    var Arr=rtn.split("^");
    if (Arr[0]!="0"){
        alert(Arr[1]);
    }
    $("#CallVoiceList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindCallVoicePatInfo",RegNo:"",RoomID:getValueById("RoomID"),HospID:HospID}); 
    } else {
        return false;
    }
    });
    
    
    
}

function Pass()
{
    var HospID=session['LOGON.HOSPID'];
    $.messager.confirm("提示", "确认要过号吗?", function (r) {
    if (r) {
    var Info=GetNextInfo();
    var Arr=Info.split("^");
    var RecordID=Arr[0];
    if (RecordID==""){
        $.messager.alert("提示","没有排队记录！","info");
        return false;
    }
    
    var CallName=Arr[1];
    
    var rtn=tkMakeServerCall("web.DHCPE.RoomManager","PassCurRoomInfo",RecordID)
    var Arr=rtn.split("^");
    if (Arr[0]!="0"){
        alert(Arr[1]);
    }
    vRoomRecordID="";
    $("#CallVoiceList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindCallVoicePatInfo",RegNo:"",RoomID:getValueById("RoomID"),HospID:HospID}); 
    } else {
            return false;
    }
    });
    
    
    
    
}
function BComplete()
{

    if(OtherPAADM!=""){
        return false; //住院体检
    }
    var HospID=session['LOGON.HOSPID'];
    var RecordID="";
    var HospID=session['LOGON.HOSPID'];
    var RecordID="";
    var PAADM=getValueById("EpisodeID")
    var RoomID=getValueById("RoomID")
    if (RoomID=="") 
    {
        return false;
    }
    
    if (PAADM==""){
        $.messager.alert("提示","没有就诊记录!","info");
        return false;
    }
    
    var ret=tkMakeServerCall("web.DHCPE.RoomManager","CompleteCurRoom",RecordID,PAADM,RoomID)
    
    var Arr=ret.split("^");
    
    vRoomRecordID="";
    $("#CallVoiceList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindCallVoicePatInfo",RegNo:"",RoomID:getValueById("RoomID"),HospID:HospID}); 

    var WaitInfo=tkMakeServerCall("web.DHCPE.RoomManager","GetWaitInfo",PAADM)
    var myDiv=document.getElementById("WaitInfo");
    myDiv.innerText=WaitInfo;

}


function ReStartPass(RecordID)
{
    var HospID=session['LOGON.HOSPID'];
    if (RecordID==""){
        $.messager.alert("提示","没有排队记录！","info");
        return false;
        }
    
    $.messager.confirm("提示", "确认要过号启用吗?", function (r) {
    if (r) {
        
    var rtn=tkMakeServerCall("web.DHCPE.RoomManager","ReStartCurRoomInfo",RecordID)
    
    var Arr=rtn.split("^");
    if (Arr[0]!="0"){
        alert(Arr[1]);
    }
    $("#CallVoiceList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindCallVoicePatInfo",RegNo:"",RoomID:getValueById("RoomID"),HospID:HospID}); 

                } else {
                    return false;
                }
    });
            
    
    
    }
/**
 * [设置Iframe的size]
 * @param    {[int]}    flag [0 展开  1 折叠]
 * @Author   wangguoying
 * @DateTime 2019-09-04
 */
function setFramSize(flag){
    var CurPAADM= $("#PAADM_Hidden").val();
    if(CurPAADM!=""){
        var StationInfo=tkMakeServerCall("web.DHCPE.DocPatientFind","GetStationList",CurPAADM);
        var StationList=StationInfo.split(",");
        for(var i=0;i<StationList.length;i++)
        {   
            var tabframeId="tabframe"+StationList[i].split("^")[0];
            var tabframe=window.frames[tabframeId];
            if(tabframe){
                if(tabframe.contentWindow){
                    tabframe.contentWindow.setLayoutSize(flag);
                }else{
                    tabframe.setLayoutSize(flag);
                }
            }
        }
    }   
}          

$(init);
