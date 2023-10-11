//名称 dhcpediagnosispatient.hisui.js
//功能 总检初审hisui
//创建日期 
//创建人 yupeng

var init = function(){
    
    $("#RegNo").focus();
    if(MainDoctor=="Y")
    {
        $HUI.radio("#NoGS").disable();
        
    }
    /// 病人信息列表  卡片样式
    function setCellLabel(value, rowData, rowIndex){
        var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;">'+ rowData.Name
         +'</h3><h3 style="float:right;background-color:transparent;"><span>'+ rowData.Sex +'/'+ rowData.Age 
         +'</span></h3><br>'+'<h3 style="float:left;background-color:transparent;"><span>'+ rowData.AdmDate
         +'</span></h3>'
         
        if(rowData.TCAAuditFlag == "1"){
            htmlstr += "<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/ca_green.png'>"
        }
        if(rowData.TCAMainFlag == "1"){
            htmlstr += "<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/ca_green.png'>"
        }
         
        var classstyle="color: #18bc9c";
        if(rowData.GSStatus!=""){
            if(rowData.GSStatus=="未初审") {classstyle="color: #f22613"};
            if(rowData.GSStatus=="未复审") {classstyle="color: #f22613"};
            if(rowData.GSStatus=="已初审") {classstyle="color: #3c78d8"};
            htmlstr = htmlstr +'<h4 style="float:right;background-color:transparent;"><span style="'+classstyle+'" style="width:50%;padding-bottom: 0px;padding-top: 0px">'+rowData.GSStatus+'</span></h4>';
        }
         
        htmlstr = htmlstr +'<br>';
        
        htmlstr = htmlstr + '<h4 style="float:left;background-color:transparent;">ID:'+ rowData.PAPMINo +'</h4>';
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
        
    //团体
    var GroupObj = $HUI.combogrid("#Group",{
        panelWidth:490,
        url:$URL+"?ClassName=web.DHCPE.PreGADM&QueryName=SearchPreGADMShort",
        mode:'remote',
        delay:200,
        idField:'Hidden',
        textField:'Name',
        onBeforeLoad:function(param){
            param.Code = param.q;
        },
        
        columns:[[
            {field:'Hidden',hidden:true},
            {field:'Name',title:'团体名称',width:140},
            {field:'Code',title:'编码',width:100},
            {field:'Begin',title:'开始日期',width:100},
            {field:'End',title:'截止日期',width:100},
            {field:'DelayDate',title:'状态',width:50}
            
            
        ]]
        }) 

        
    $("#Query").click(function(){
            Query();
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

    
    var CanDiagnosisListObj = $HUI.datagrid("#CanDiagnosisList",{
        url:$URL,
        showHeader:false,
        pagination:true,
        singleSelect:true,
        pageSize:20,
        showRefresh:false,
        displayMsg:"",
        showPageList:false,
        fit:true,
        queryParams:{
            ClassName:"web.DHCPE.ResultNew",
            QueryName:"FindDiagnosisPatInfo",
            MainDoctor:MainDoctor,
            GenStatus:"",
            RegNo:"",
            OtherPAADM:OtherPAADM,
            HospID:session['LOGON.HOSPID']

        },
        columns:[[
            {field:'PatLabel',title:'',width:260,formatter:setCellLabel},
            {field:'PaadmID',hidden:true},
            {field:'PAPMINo',title:'登记号',width:50,hidden:true},
            {field:'AdmDate',title:'体检日期',width:50,hidden:true},
            {field:'Name',title:'姓名',width:50,hidden:true},
            {field:'Age',title:'年龄',width:50,hidden:true},
            {field:'Sex',title:'性别',width:50,hidden:true},
            {field:'VIPLevel',title:'VIP',width:50,hidden:true},
            {field:'VIPDesc',title:'VIP等级',width:50,hidden:true},
            {field:'GName',title:'团体名称',width:200,hidden:true},
            {field:'GSStatus',title:'总检状态',width:200,hidden:true}
        ]],
        onClickRow:function(rowIndex, rowData){
            
            $('#patName').text(rowData.Name);
            $('#sexName').text(rowData.Sex);
            $('#Age').text(rowData.Age);
            $('#PatNo').text(rowData.PAPMINo);
            $('#PEDate').text(rowData.AdmDate);
            $('#VIPLevel').text(rowData.VIPDesc);
            //$('#PatNoName').text("登记号：");
            $('#Remark').text(rowData.ReMark);
            //blue：炫彩 lite：极简
            var HISUIStyleCode=tkMakeServerCall("websys.StandardTypeItem","GetIdFromCodeOrDescription","websys","HISUIDefVersion");
            
            if (rowData.Sex == '男') {
                if (HISUIStyleCode== 'blue') {
                    $('#sex').removeClass('woman').addClass('man');
                }else{
                    $('#sex').removeClass('woman_lite').addClass('man_lite');
                }
            } else {
                if (HISUIStyleCode== 'blue') {
                   $('#sex').removeClass('man').addClass('woman');
                }else{
                    $('#sex').removeClass('man_lite').addClass('woman_lite');
                }
            }
            $("#PAADM_Hidden").val(rowData.PaadmID);
            $("#GName").text(rowData.GName);
            ShowDiagnosisPanel(rowData.PaadmID);
            
        }
    });
    
    $("#PersonPanel").panel({
            tools:[
            /*{
            iconCls:'icon-w-update',
            handler:function(){
                
            }
            },*/
            {
            iconCls:'icon-arrow-left',
            handler:function(){
                $('#DiagnosisPanel').layout('collapse','west');
                $("#DiagnosisTab").tabs("resize");
            }
            }]
        });
    
    
};

/**
 * [设置Iframe的size]
 * @param    {[int]}    flag [0 展开  1 折叠]
 * @Author   wangguoying
 * @DateTime 2019-09-04
 */
function setFramSize(flag){
    
            var tabframeId="tabframediagnosis";
            var tabframe=window.frames[tabframeId];
            if(tabframe){           
                if(tabframe.contentWindow){
                    tabframe.contentWindow.setLayoutSize(flag);
                }else{
                    tabframe.setLayoutSize(flag);   
                }
                
            }
    tabSelect("传染病上报",3);
}          


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
 
function ShowDiagnosisPanel(PAADM)
{
    
    
    closeAllTabs('DiagnosisTab');
    //业务锁
    var lockRet=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","LockAuditByPAADM",PAADM,MainDoctor);   
    if(lockRet!=""){
        $.messager.alert("提示",lockRet,"warning");
        return false;
    }
   
   /***初审提交后，患者列表状态刷新 start***/
    var RegNo=$("#RegNo").val();
    var Name=$("#Name").val();
    var Group=$("#Group").combogrid('getValue',"");
    if (($("#Group").combogrid('getValue')==undefined)||($("#Group").combogrid('getText')=="")){var Group="";}
    var BDate=getValueById("BDate");
    var EDate=getValueById("EDate");
    var VIP=getValueById("VIP");
    var GenStatus=$('input[name="GenStatus"]:checked').val();
    var ExpStr=RegNo+"^"+Name+"^"+Group+"^"+BDate+"^"+EDate+"^"+VIP+"^"+GenStatus+"^"+OtherPAADM;
  /**初审提交后，患者列表状态刷新 end***/
    var url="dhcpenewdiagnosis.diagnosis.hisui.csp?EpisodeID="+PAADM+"&MainDoctor="+MainDoctor+"&OnlyRead="+OnlyRead+"&ExpStr="+ExpStr+"&HWFlag=1";
    var content = '<iframe id="tabframediagnosis" scrolling="auto" frameborder="0"  src="'+PEURLAddToken(url)+'" style="width:100%;height:99%;"></iframe>';
    
    $('#DiagnosisTab').tabs('add', {
          selected:false,
          title:"总检信息",
          content:content
            
    });
    
    //var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEContrastWithLast"+"&PAADM="+PAADM;
    var url="dhcperesultcontrast.hisui.csp?PAADM="+PAADM;
    var content = '<iframe id="tabframehistory" scrolling="auto" frameborder="0"  src="'+PEURLAddToken(url)+'" style="width:100%;height:99%;"></iframe>';
    
    $('#DiagnosisTab').tabs('add', {
          fit:true,
          selected:false,
          title:"历史结果",
          content:content
            
    });
    
    
    var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSendPisInterface");
    if(flag=="1"){
        //新产品组方法
         //url=tkMakeServerCall("web.DHCEMInterface","GetRepLinkUrl",PAADM,"","E");
           url=tkMakeServerCall("web.DHCAPPInterface","GetRepLinkUrl",PAADM,"","E");
        }else{
        //pacs组件
        lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCRisclinicQueryOEItem"+"&EpisodeID="+PAADM;
        }
    
    var content = '<iframe id="tabframerisreport" scrolling="auto" frameborder="0"  src="'+url+'" style="width:98%;height:99%;"></iframe>';

    
    
    $('#DiagnosisTab').tabs('add', {
          fit:true,
          selected:false,
          title:"检查报告",
          content:content
            
    });
    
    
    
    var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSendPisInterface");
    if(flag=="1"){
        //新产品组方法
         //url=tkMakeServerCall("web.DHCEMInterface","GetRepLinkUrl",PAADM,"","L");
          url=tkMakeServerCall("web.DHCAPPInterface","GetRepLinkUrl",PAADM,"","L");
        }else{
        //pacs组件
        lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCRisclinicQueryOEItem"+"&EpisodeID="+PAADM;
        }
    
    var content = '<iframe id="tabframelisreport" scrolling="auto" frameborder="0"  src="'+url+'" style="width:99%;height:99%;"></iframe>';
    
    $('#DiagnosisTab').tabs('add', {
          fit:true,
          selected:false,
          title:"检验报告",
          content:content
            
    });
    

    var url="dhcma.epd.report.csp?EpisodeID="+PAADM+"&PortalFlag=1";
    var content = '<iframe id="tabframecmareport" scrolling="auto" frameborder="0" src="'+url+'" style="width:99%;height:99%;"></iframe>';
    $('#DiagnosisTab').tabs('add', {
          fit:true,
          selected:false,
          title:"传染病上报",
          content:content
            
    });
    

    $('#DiagnosisTab').tabs('select',"总检信息");
    
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

    $("#CanDiagnosisList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindDiagnosisPatInfo",RegNo:iRegNo,MainDoctor:MainDoctor,GenStatus:"",HospID:HospID}); 
    
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
    var Group=$("#Group").combogrid('getValue',"");
    if (($("#Group").combogrid('getValue')==undefined)||($("#Group").combogrid('getText')=="")){var Group="";}
    var BDate=getValueById("BDate");
    var EDate=getValueById("EDate");
    var VIP=getValueById("VIP");
    var GenStatus=$('input[name="GenStatus"]:checked').val();
    
    $("#CanDiagnosisList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindDiagnosisPatInfo",RegNo:iRegNo,BDate:BDate,EDate:EDate,VIP:VIP,PatName:Name,Group:Group,MainDoctor:MainDoctor,GenStatus:GenStatus,HospID:HospID,OtherPAADM:OtherPAADM}); 
    
}
window.onbeforeunload = function(){
    //关闭时释放业务锁
    var lockRet=tkMakeServerCall("web.DHCPE.Lock","LockClearTypeAndSession",MainDoctor == "Y" ? "MAR" : "AR","");   
    
};
function tabSelect(title,index){
    if(title == "传染病上报"){
        iframeResize("tabframecmareport")  //传染病上报
    }
}

function iframeResize(iframeId){
    var iframe = window.frames[iframeId];  
    if(iframe){
        var dWidth=$(window).width();
        var flag = $("#PersonPanel").css("display")=="none" ? 1 :0;
        var leftWidth= flag == 1 ? 15 : $("#PersonPanel").width()-5;
        $("#"+iframeId).width(dWidth-leftWidth);
        $("#EPDReport",iframe).layout("resize");  //传染病上报里面的layout
    }
}
$(init);