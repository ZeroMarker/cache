
//����     dhcpe/ct/reportsetting.js
//����    ��챨������
//����    2021.08.15
//������  yupeng
var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
        
    GetLocComp(SessionStr)    
        
   
    InitReportSettingGrid();
   
    //����
    $("#BSave").click(function() {  
        BSave_click();      
     });
    
     //���������б�change
    $("#LocList").combobox({
       onSelect:function(){  
            LocList_change();   
        }
    }) 

     //��鱨���ϴ�ftp
    $("#PhotoFTP").click(function() {   
        PhotoFTP_click();       
        });
        
    //��챨���ϴ�ftp
    $("#ReportFTP").click(function() {  
        ReportFTP_click();      
        });
   
})

//��鱨���ϴ�ftp
function PhotoFTP_click()
{
  $("#PhotoFTPWin").show();
  
 $('#PhotoFTPform-save').form("clear");
  
 var SelectLocID=$("#SelectLocID").val();
 if(SelectLocID!=""){
      
    //��ȡ��鱨���ϴ�ftp��Ϣ
    var PhotoFTPStr=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",SelectLocID,"PhotoFTP");
	
	if(PhotoFTPStr==""){
	     var PhotoFTPStr="^^^^"
    }

    var PhotoFTPStrArr=PhotoFTPStr.split("^");
    $("#PhotoFTPWinIP").val(PhotoFTPStrArr[0]);
    $("#PhotoFTPWinUser").val(PhotoFTPStrArr[1]);
     
    var PassWord = Base64.decode(PhotoFTPStrArr[2]);// ����
    $("#PhotoFTPWinPassWord").val(PassWord);
   
    $("#PhotoFTPWinPort").val(PhotoFTPStrArr[3]);
    $("#PhotoFTPWinFile").val(PhotoFTPStrArr[4]);
   
 }
 var PhotoFTPWin = $HUI.dialog("#PhotoFTPWin",{
            iconCls:'icon-w-export',
            resizable:true,
            title:'��鱨���ϴ�ftp',
            modal:true,
            buttonAlign:'center',
            buttons:[
                    {
                iconCls:'icon-w-save',
                text:'����',
                id:'SavePhotoFTP_btn',
                handler:function(){
                    SavePhotoFTPForm(SelectLocID)
                }
            },{
                iconCls:'icon-w-close',
                text:'�ر�',
                handler:function(){
                  PhotoFTPWin.close();
                }
                
            }]
        });
    
    
}

SavePhotoFTPForm=function(id)
{
    //����
     var NowLoc=$("#LocList").combobox('getValue')
     var IP=$("#PhotoFTPWinIP").val();
     var User=$("#PhotoFTPWinUser").val(); 
     var PassWord=$("#PhotoFTPWinPassWord").val();
     var PassWord = Base64.encode(PassWord);  // ����
     var Port=$("#PhotoFTPWinPort").val();
     var File=$("#PhotoFTPWinFile").val();
     if((IP=="")&&(User=="")&&(PassWord=="")&&(Port=="")&&(File=="")){
            
     }else{
         
     
         if (""==IP) {
            $.messager.alert('��ʾ','IP����Ϊ��!',"info");
            return false;
        }
        
        if (""==User) {
            $.messager.alert('��ʾ','�û�����Ϊ��!',"info");
            return false;
        }
        
    }
    
    var str=IP+"^"+User+"^"+PassWord+"^"+Port+"^"+File;
    if(id!="") {var NowLoc=id;}
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"PhotoFTP",str);
    if(ret=="0"){ 
       $.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
       $('#PhotoFTPWin').dialog('close'); 
    }
    
    
    
}

//��챨���ϴ�ftp
function ReportFTP_click()
{
  $("#ReportFTPWin").show();
 
  $('#ReportFTPform-save').form("clear");
  
  var SelectLocID=$("#SelectLocID").val();
 
 if(SelectLocID!=""){
      
    //��ȡ��鱨���ϴ�ftp��Ϣ
    var ReportFTPStr=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",SelectLocID,"ReportFTP");
    if(ReportFTPStr==""){
	     var ReportFTPStr="^^^^"
    }
    var ReportFTPStrArr=ReportFTPStr.split("^");
    $("#ReportFTPWinIP").val(ReportFTPStrArr[0]);
    $("#ReportFTPWinUser").val(ReportFTPStrArr[1]);
    var PassWord = Base64.decode(ReportFTPStrArr[2]); //����
    $("#ReportFTPWinPassWord").val(PassWord);
    $("#ReportFTPWinPort").val(ReportFTPStrArr[3]);
    $("#ReportFTPWinFile").val(ReportFTPStrArr[4]);
   
 }
 var ReportFTPWin = $HUI.dialog("#ReportFTPWin",{
            iconCls:'icon-w-export',
            resizable:true,
            title:'��챨���ϴ�ftp',
            modal:true,
            buttonAlign:'center',
            buttons:[
                    {
                iconCls:'icon-w-save',
                text:'����',
                id:'SaveReportFTP_btn',
                handler:function(){
                    SaveReportFTPForm(SelectLocID);
                }
            },{
                iconCls:'icon-w-close',
                text:'�ر�',
                handler:function(){
                  ReportFTPWin.close();
                }
                
            }]
        });
    
    
}

SaveReportFTPForm=function(id)
{
    //����
    var NowLoc=$("#LocList").combobox('getValue')
    var IP=$("#ReportFTPWinIP").val();
    var User=$("#ReportFTPWinUser").val();
    var PassWord=$("#ReportFTPWinPassWord").val();
    var PassWord = Base64.encode(PassWord); // ����
    var Port=$("#ReportFTPWinPort").val();
    var File=$("#ReportFTPWinFile").val();
    //alert(IP+"^"+User+"^"+PassWord+"^"+Port+"^"+File)
    if((IP=="")&&(User=="")&&(PassWord=="")&&(Port=="")&&(File=="")){
            
        
    }else{
         if (""==IP) {
            $.messager.alert('��ʾ','IP����Ϊ��!',"info");
            return false;
        }
        if (""==User) {
            $.messager.alert('��ʾ','�û�����Ϊ��!',"info");
            return false;
        }
    }
    
    
    var str=IP+"^"+User+"^"+PassWord+"^"+Port+"^"+File;
    if(id!="") {var NowLoc=id;}
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"ReportFTP",str);
        
   if(ret=="0"){
       $.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
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
    //����
    var NowLoc=$("#LocList").combobox('getValue')
    if (($("#LocList").combobox('getValue')==undefined)||($("#LocList").combobox('getText')=="")){var NowLoc="";}
    if(NowLoc=="") 
    {
        $.messager.alert("��ʾ","��ѡ����Ҫ���õĿ���!","info");
        return;
    }
    
    if(NowLoc!="")
    {
        if (($("#LocList").combobox('getValue'))==($("#LocList").combobox('getText')))  {
            $.messager.alert("��ʾ","����ѡ����ȷ!","info");
            return false;
        }
        
    }
    
    //��鱨���ϴ�ftp
    //var str=$("#PhotoFTP").val();
    //tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"PhotoFTP",str);
    
    //��챨��ftp
    //var str=$("#ReportFTP").val();
    //tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"ReportFTP",str);
    
    
    //���ϲ鿴����
    var str=$("#NetReport").switchbox("getValue");
    if(str) {str="Y",NetReport="Y";}
    else {str="N",NetReport="N"; }
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"NetReport",str);
    
    //��챨���ʽ
     var str=getValueById("NewVerReport")
    if(str=="Word") { NewVerReport="Y";}
    else {NewVerReport="N";}
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"NewVerReport",str);
     
     if((NewVerReport=="Y")&&(NetReport=="N")){
        $.messager.alert("��ʾ","�°汨�����ã����ϲ鿴�����������!","info");
        return false;
        }
        
     //�������
     var str=$("#ReportCode").val();
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"ReportCode",str);
    
    //�����ӡ����
    var str=$("#MainReportPrint").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"MainReportPrint",str);
    
    //�ϲ��걾�Ŵ�ӡ����
    var str=$("#LisReportMerge").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"LisReportMerge",str);
    
    
    //�ϲ����Ŵ�ӡ���
    var str=$("#RisReportMerge").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"RisReportMerge",str);
    
    
    //��ʾ������۷���
    var str=$("#ShowEDDiagnosisSign").switchbox("getValue");
    if(str) str="Y"
    else str="N"   
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"ShowEDDiagnosisSign",str);
    
    //���۽���ֿ�
    var str=$("#SplitSummary").switchbox("getValue");
    if(str) str="Y"
    else str="N"
    tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"SplitSummary",str);
    
    $.messager.alert("��ʾ","���óɹ�!","success");
    
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

//����
function BClear_click(){

    $("#ReportCode,#PhotoFTP,#ReportFTP").val("");
    $(".hisui-combobox").combobox("setValue","");
    $(".hisui-combogrid").combogrid("setValue","");
    $(".hisui-switchbox").switchbox("setValue",true);
    
}

function SetReportDataByLoc(loc)
{
    
    //��챨��ftp
   // var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"ReportFTP");
   // $("#ReportFTP").val(ret)
    
    
    //��鱨���ϴ�ftp
    //var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"PhotoFTP");
   // $("#PhotoFTP").val(ret)
    
    //��챨���ʽ
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"NewVerReport");
    $('#NewVerReport').combobox('setValue',ret)
    
    //�������
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"ReportCode");
    $("#ReportCode").val(ret)
    
    //�����ӡ����
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"MainReportPrint");
    if(ret=="Y")    $("#MainReportPrint").switchbox("setValue",true);
    else    $("#MainReportPrint").switchbox("setValue",false);
    
    //���ϲ鿴����
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"NetReport");
    if(ret=="Y")    $("#NetReport").switchbox("setValue",true);
    else    $("#NetReport").switchbox("setValue",false)

    //�ϲ��걾�Ŵ�ӡ����
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"LisReportMerge");
    if(ret=="Y")    $("#LisReportMerge").switchbox("setValue",true);
    else    $("#LisReportMerge").switchbox("setValue",false)
    
    //�ϲ����Ŵ�ӡ���
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"RisReportMerge");
    if(ret=="Y")    $("#RisReportMerge").switchbox("setValue",true);
    else    $("#RisReportMerge").switchbox("setValue",false)
    
    //��ʾ������۷���
    var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"ShowEDDiagnosisSign");
    if(ret=="Y")    $("#ShowEDDiagnosisSign").switchbox("setValue",true);
    else    $("#ShowEDDiagnosisSign").switchbox("setValue",false)
    
    //���۽���ֿ�
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
        {field:'LocDesc',title:'����'},
        //{field:'PhotoFTP',title:'��鱨���ϴ�ftp'},
        //{field:'ReportFTP',title:'��챨��ftp'},
        {field:'NetReport',title:'���ϲ鿴����'},
        {field:'NewVerReport',title:'��챨���ʽ'},
        {field:'ReportCode',title:'�������'},
        {field:'MainReportPrint',title:'�����ӡ����'},
        {field:'LisReportMerge',title:'�ϲ��걾�Ŵ�ӡ����'},
        {field:'RisReportMerge',title:'�ϲ����Ŵ�ӡ���'},
        {field:'ShowEDDiagnosisSign',title:'��ʾ������۷���'},
        {field:'SplitSummary',title:'���۽���ֿ�'},
        {field:'IReportSetting',title:'��������',
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
    websys_showModal({title:'��������', url:lnk, width:'1200',height:'650',iconCls:'icon-add-report',onClose:function(){}});
}

//����ļ��ܡ�����
var Base64 = {
    _keyStr: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",
    
    //����
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
 
    //����
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