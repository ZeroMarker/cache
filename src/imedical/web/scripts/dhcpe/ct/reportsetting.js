
//名称     dhcpe/ct/reportsetting.js
//功能    体检报告配置
//创建    2021.08.15
//创建人  yupeng
var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
        
    GetLocComp(SessionStr)    
        
   
    InitReportSettingGrid();
   
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

     //检查报告上传ftp
    $("#PhotoFTP").click(function() {   
        PhotoFTP_click();       
        });
        
    //体检报告上传ftp
    $("#ReportFTP").click(function() {  
        ReportFTP_click();      
        });
   
})

//检查报告上传ftp
function PhotoFTP_click()
{
  $("#PhotoFTPWin").show();
  
 $('#PhotoFTPform-save').form("clear");
  
 var SelectLocID=$("#SelectLocID").val();
 if(SelectLocID!=""){
      
    //获取检查报告上传ftp信息
    var PhotoFTPStr=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",SelectLocID,"PhotoFTP");
	
	if(PhotoFTPStr==""){
	     var PhotoFTPStr="^^^^"
    }

    var PhotoFTPStrArr=PhotoFTPStr.split("^");
    $("#PhotoFTPWinIP").val(PhotoFTPStrArr[0]);
    $("#PhotoFTPWinUser").val(PhotoFTPStrArr[1]);
     
    var PassWord = Base64.decode(PhotoFTPStrArr[2]);// 解密
    $("#PhotoFTPWinPassWord").val(PassWord);
   
    $("#PhotoFTPWinPort").val(PhotoFTPStrArr[3]);
    $("#PhotoFTPWinFile").val(PhotoFTPStrArr[4]);
   
 }
 var PhotoFTPWin = $HUI.dialog("#PhotoFTPWin",{
            iconCls:'icon-w-export',
            resizable:true,
            title:'检查报告上传ftp',
            modal:true,
            buttonAlign:'center',
            buttons:[
                    {
                iconCls:'icon-w-save',
                text:'保存',
                id:'SavePhotoFTP_btn',
                handler:function(){
                    SavePhotoFTPForm(SelectLocID)
                }
            },{
                iconCls:'icon-w-close',
                text:'关闭',
                handler:function(){
                  PhotoFTPWin.close();
                }
                
            }]
        });
    
    
}

SavePhotoFTPForm=function(id)
{
    //科室
     var NowLoc=$("#LocList").combobox('getValue')
     var IP=$("#PhotoFTPWinIP").val();
     var User=$("#PhotoFTPWinUser").val(); 
     var PassWord=$("#PhotoFTPWinPassWord").val();
     var PassWord = Base64.encode(PassWord);  // 加密
     var Port=$("#PhotoFTPWinPort").val();
     var File=$("#PhotoFTPWinFile").val();
     if((IP=="")&&(User=="")&&(PassWord=="")&&(Port=="")&&(File=="")){
            
     }else{
         
     
         if (""==IP) {
            $.messager.alert('提示','IP不能为空!',"info");
            return false;
        }
        
        if (""==User) {
            $.messager.alert('提示','用户不能为空!',"info");
            return false;
        }
        
    }
    
    var str=IP+"^"+User+"^"+PassWord+"^"+Port+"^"+File;
    if(id!="") {var NowLoc=id;}
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"PhotoFTP",str);
    if(ret=="0"){ 
       $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
       $('#PhotoFTPWin').dialog('close'); 
    }
    
    
    
}

//体检报告上传ftp
function ReportFTP_click()
{
  $("#ReportFTPWin").show();
 
  $('#ReportFTPform-save').form("clear");
  
  var SelectLocID=$("#SelectLocID").val();
 
 if(SelectLocID!=""){
      
    //获取检查报告上传ftp信息
    var ReportFTPStr=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",SelectLocID,"ReportFTP");
    if(ReportFTPStr==""){
	     var ReportFTPStr="^^^^"
    }
    var ReportFTPStrArr=ReportFTPStr.split("^");
    $("#ReportFTPWinIP").val(ReportFTPStrArr[0]);
    $("#ReportFTPWinUser").val(ReportFTPStrArr[1]);
    var PassWord = Base64.decode(ReportFTPStrArr[2]); //解密
    $("#ReportFTPWinPassWord").val(PassWord);
    $("#ReportFTPWinPort").val(ReportFTPStrArr[3]);
    $("#ReportFTPWinFile").val(ReportFTPStrArr[4]);
   
 }
 var ReportFTPWin = $HUI.dialog("#ReportFTPWin",{
            iconCls:'icon-w-export',
            resizable:true,
            title:'体检报告上传ftp',
            modal:true,
            buttonAlign:'center',
            buttons:[
                    {
                iconCls:'icon-w-save',
                text:'保存',
                id:'SaveReportFTP_btn',
                handler:function(){
                    SaveReportFTPForm(SelectLocID);
                }
            },{
                iconCls:'icon-w-close',
                text:'关闭',
                handler:function(){
                  ReportFTPWin.close();
                }
                
            }]
        });
    
    
}

SaveReportFTPForm=function(id)
{
    //科室
    var NowLoc=$("#LocList").combobox('getValue')
    var IP=$("#ReportFTPWinIP").val();
    var User=$("#ReportFTPWinUser").val();
    var PassWord=$("#ReportFTPWinPassWord").val();
    var PassWord = Base64.encode(PassWord); // 加密
    var Port=$("#ReportFTPWinPort").val();
    var File=$("#ReportFTPWinFile").val();
    //alert(IP+"^"+User+"^"+PassWord+"^"+Port+"^"+File)
    if((IP=="")&&(User=="")&&(PassWord=="")&&(Port=="")&&(File=="")){
            
        
    }else{
         if (""==IP) {
            $.messager.alert('提示','IP不能为空!',"info");
            return false;
        }
        if (""==User) {
            $.messager.alert('提示','用户不能为空!',"info");
            return false;
        }
    }
    
    
    var str=IP+"^"+User+"^"+PassWord+"^"+Port+"^"+File;
    if(id!="") {var NowLoc=id;}
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"ReportFTP",str);
        
   if(ret=="0"){
       $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
       $('#ReportFTPWin').dialog('close'); 
   }
}

function LocList_change(){
    
    var LocID=session['LOGON.CTLOCID'];
    var LocListID=$("#LocList").combobox('getValue');
    if(LocListID!=""){var LocID=LocListID; };
    var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);

     $("#ReportSettingGrid").datagrid('load',{
            ClassName:"web.DHCPE.HISUICommon",
            QueryName:"FindReportSetting",
            LocID:LocID,
            HospID:hospId
        }); 

    $("#ReportCode,#PhotoFTP,#ReportFTP,#SelectLocID").val("");
    $('#NewVerReport').combobox('setValue','Lodop')
    $(".hisui-switchbox").switchbox("setValue",true);       
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
    
    //检查报告上传ftp
    //var str=$("#PhotoFTP").val();
    //tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"PhotoFTP",str);
    
    //体检报告ftp
    //var str=$("#ReportFTP").val();
    //tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"ReportFTP",str);
    
    
    //网上查看报告
    var str=$("#NetReport").switchbox("getValue");
    if(str) {str="Y",NetReport="Y";}
    else {str="N",NetReport="N"; }
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"NetReport",str);
    
    //体检报告格式
     var str=getValueById("NewVerReport")
    if(str=="Word") { NewVerReport="Y";}
    else {NewVerReport="N";}
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"NewVerReport",str);
     
     if((NewVerReport=="Y")&&(NetReport=="N")){
        $.messager.alert("提示","新版报告启用，网上查看报告必须启用!","info");
        return false;
        }
        
     //报告代码
     var str=$("#ReportCode").val();
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"ReportCode",str);
    
    //复查打印报告
    var str=$("#MainReportPrint").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"MainReportPrint",str);
    
    //合并标本号打印化验
    var str=$("#LisReportMerge").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"LisReportMerge",str);
    
    
    //合并检查号打印检查
    var str=$("#RisReportMerge").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"RisReportMerge",str);
    
    
    //显示建议结论符号
    var str=$("#ShowEDDiagnosisSign").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"ShowEDDiagnosisSign",str);
    
    //结论建议分开
    var str=$("#SplitSummary").switchbox("getValue");
    if(str) str="Y"
    else str="N"
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"SplitSummary",str);
    
    $.messager.alert("提示","设置成功!","success");
    
    var LocID=$("#LocList").combobox('getValue');
    var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
     
    $("#ReportSettingGrid").datagrid('load',{
            ClassName:"web.DHCPE.HISUICommon",
            QueryName:"FindReportSetting",
            LocID:LocID,
            HospID:hospId
            
        });
        
    BClear_click();
}

//清屏
function BClear_click(){

    $("#ReportCode,#PhotoFTP,#ReportFTP").val("");
    $(".hisui-combobox").combobox("setValue","");
    $(".hisui-combogrid").combogrid("setValue","");
    $(".hisui-switchbox").switchbox("setValue",true);
    
}

function SetReportDataByLoc(loc)
{
    
    //体检报告ftp
   // var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"ReportFTP");
   // $("#ReportFTP").val(ret)
    
    
    //检查报告上传ftp
    //var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"PhotoFTP");
   // $("#PhotoFTP").val(ret)
    
    //体检报告格式
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"NewVerReport");
    $('#NewVerReport').combobox('setValue',ret)
    
    //报告代码
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"ReportCode");
    $("#ReportCode").val(ret)
    
    //复查打印报告
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"MainReportPrint");
    if(ret=="Y")    $("#MainReportPrint").switchbox("setValue",true);
    else    $("#MainReportPrint").switchbox("setValue",false);
    
    //网上查看报告
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"NetReport");
    if(ret=="Y")    $("#NetReport").switchbox("setValue",true);
    else    $("#NetReport").switchbox("setValue",false)

    //合并标本号打印化验
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"LisReportMerge");
    if(ret=="Y")    $("#LisReportMerge").switchbox("setValue",true);
    else    $("#LisReportMerge").switchbox("setValue",false)
    
    //合并检查号打印检查
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"RisReportMerge");
    if(ret=="Y")    $("#RisReportMerge").switchbox("setValue",true);
    else    $("#RisReportMerge").switchbox("setValue",false)
    
    //显示建议结论符号
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"ShowEDDiagnosisSign");
    if(ret=="Y")    $("#ShowEDDiagnosisSign").switchbox("setValue",true);
    else    $("#ShowEDDiagnosisSign").switchbox("setValue",false)
    
    //结论建议分开
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"SplitSummary");
    if(ret=="Y")    $("#SplitSummary").switchbox("setValue",true);
    else    $("#SplitSummary").switchbox("setValue",false)
}
function InitReportSettingGrid()
{
    var LocID=session['LOGON.CTLOCID'];
    var LocListID=$("#LocList").combobox('getValue');
    if(LocListID!=""){var LocID=LocListID; };
    var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
    
    $HUI.datagrid("#ReportSettingGrid",{
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
            QueryName:"FindReportSetting",
            LocID:LocID,
            HospID:hospId
        },
        columns:[[
        {field:'Loc',title:'Loc'},
        {field:'LocDesc',title:'科室'},
        //{field:'PhotoFTP',title:'检查报告上传ftp'},
        //{field:'ReportFTP',title:'体检报告ftp'},
        {field:'NetReport',title:'网上查看报告'},
        {field:'NewVerReport',title:'体检报告格式'},
        {field:'ReportCode',title:'报告代码'},
        {field:'MainReportPrint',title:'复查打印报告'},
        {field:'LisReportMerge',title:'合并标本号打印化验'},
        {field:'RisReportMerge',title:'合并检查号打印检查'},
        {field:'ShowEDDiagnosisSign',title:'显示建议结论符号'},
        {field:'SplitSummary',title:'结论建议分开'},
        {field:'IReportSetting',title:'报告设置',
            formatter:function(val, row, ind){
                return "<a href='#' onclick='ShowRSPage(\""+row.Loc+"\", \"" + "REPORTDATA" + "\")'>\
                            <img src='../scripts_lib/hisui-0.1.0/dist/css/icons/add_report.png' border=0/>\
                        </a>";
            }
        }

        ]],
        onSelect: function (rowIndex, rowData) {
               
            var loc=rowData.Loc;
            var LocDesc=rowData.LocDesc;
            $("#SelectLocID").val(loc);
            //$('#NowLoc').combogrid('grid').datagrid('reload',{'q':LocDesc});
            setValueById("LocList",loc)
            SetReportDataByLoc(loc) 
                
        }
        
            
    })
    
}

function ShowRSPage(LocId, Code) {
    var lnk = "dhcpe.ct.ireportsetting.csp?TheCode=" + Code + "&LocID=" + LocId;
    websys_showModal({title:'报告配置', url:lnk, width:'1200',height:'650',iconCls:'icon-add-report',onClose:function(){}});
}

//密码的加密、解密
var Base64 = {
    _keyStr: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",
    
    //加密
    encode: function(e) {
        var t = "";
        var n, r, i, s, o, u, a;
        var f = 0;
        e = Base64._utf8_encode(e);
        while (f < e.length) {
            n = e.charCodeAt(f++);
            r = e.charCodeAt(f++);
            i = e.charCodeAt(f++);
            s = n >> 2;
            o = (n & 3) << 4 | r >> 4;
            u = (r & 15) << 2 | i >> 6;
            a = i & 63;
            if (isNaN(r)) {
                u = a = 64
            } else if (isNaN(i)) {
                a = 64
            }
            t = t + this._keyStr.charAt(s) + this._keyStr.charAt(o) + this._keyStr.charAt(u) + this._keyStr.charAt(a)
        }
        return t
    },
 
    //解密
    decode: function(e) {
        var t = "";
        var n, r, i;
        var s, o, u, a;
        var f = 0;
        e=e.replace(/[^A-Za-z0-9\+\/\=]/g,"");
        while(f < e.length){
            s = this._keyStr.indexOf(e.charAt(f++));
            o = this._keyStr.indexOf(e.charAt(f++));
            u = this._keyStr.indexOf(e.charAt(f++));
            a = this._keyStr.indexOf(e.charAt(f++));
            n = s << 2 | o >> 4;
            r = (o & 15) << 4 | u >> 2;
            i = (u & 3) << 6 | a;
            t = t + String.fromCharCode(n);
            if (u != 64) {
                t = t + String.fromCharCode(r)
            }
            if (a != 64) {
                t = t + String.fromCharCode(i)
            }
        }
        t = Base64._utf8_decode(t);
        return t
    },
    
    
    
 _utf8_encode: function(e) {
    e = e.replace(/rn/g, "n");
    var t = "";
    for (var n = 0; n < e.length; n++) {
        var r = e.charCodeAt(n);
        if (r < 128) {
            t += String.fromCharCode(r)
        } else if (r > 127 && r < 2048) {
            t += String.fromCharCode(r >> 6 | 192);
            t += String.fromCharCode(r & 63 | 128)
        } else {
             t += String.fromCharCode(r >> 12 | 224);
            t += String.fromCharCode(r >> 6 & 63 | 128);
            t += String.fromCharCode(r & 63 | 128)
        }
    }
    return t
 },
 
 
 _utf8_decode: function(e) {
    var t = "";
    var n = 0;
    var r = c1 = c2 = 0;
    while (n < e.length) {
        r = e.charCodeAt(n);
        if (r < 128) {
             t += String.fromCharCode(r);
                n++
        } else if (r > 191 && r < 224) {
            c2 = e.charCodeAt(n + 1);
            t += String.fromCharCode((r & 31) << 6 | c2 & 63);
            n += 2
         } else {
            c2 = e.charCodeAt(n + 1);
            c3 = e.charCodeAt(n + 2);
            t += String.fromCharCode((r & 15) << 12 | (c2 & 63) << 6 | c3 & 63);
            n += 3
        }
    }
  return t
 }
 
}