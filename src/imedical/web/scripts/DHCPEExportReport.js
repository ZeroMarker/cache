
/// DHCPEExportReport.js, 对于文件  dhcpepatresulthistory.csp

function SaveData()
{
    var ADMStr="",GSCID="",GSCDetail=""
    var obj=document.getElementById("ADMStr")
    if(obj) {ADMStr=obj.value;}
    var obj=document.getElementById("GSCID")
    if(obj) {GSCID=obj.value;}
    var obj=document.getElementById("GSCDetail")
    if(obj) {GSCDetail=obj.value;}
    var GSCId=tkMakeServerCall("web.DHCPE.ResultContrast","UpdateGSCDetail",GSCID,GSCDetail,ADMStr)
    $.messager.alert("提示", "保存成功！", "info");
}

//细项对比
function LisHistory_click(e)
{
    var admstr=e.id;
    var IADMStr=admstr.split("$")[1];
    //var lnk="dhcpelisresulthistory.ext.csp?AdmId="+IADMStr;
   // websys_lu(lnk,false,'width=1000,height=650,hisui=true,title=化验对比');
    var lnk="dhcpelisresulthistory.hisui.csp?AdmId="+IADMStr;
	$HUI.window("#ODContrastWin", {
        title: "细项对比",
        iconCls: "",
        collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false,
        closable: true,
        modal: true,
        width: 1200,
        height: 700,
        content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
    });
    return true;
    
}

function ShowResultHistory(IADMStr)
{
    var lnk="dhcpepatresulthistory.csp?AdmId="+IADMStr;
    
   // websys_lu(lnk,false,'width=1300,height=650,hisui=true,title=结果对比')
   $HUI.window("#ResultHistoryWin", {
        title: $g("结果对比"),
        collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false,
        closable: true,
        modal: true,
        width: 1300,
        height: 720,
        content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
    });
    
    return true;
}
function PrintData()
{
    var ADMStr=""
    var obj=document.getElementById("ADMStr")
    if(obj) {ADMStr=obj.value;}
    
    
    var lnk="dhcpeireport.constrast.csp?PatientID="+ADMStr;
    
    //var ret=window.showModalDialog(lnk, "", "dialogwidth:800px;dialogheight:600px;center:1"); 
    PEPrintReport("P",ADMStr,"","TJDB");
    //PEPrintHistoryReport("P",ADMStr,"");
    return true;
}
var init = function(){
    
    
    $("#Save").click(function() {
            
            SaveData(); 
            
        });
    $("#Print").click(function() {
            
            PrintData();    
            
        });
    $HUI.datagrid("#PatResultHistoryList",{
        url:$URL,
        fit : true,
        border : false,
        striped : true,
        fitColumns : false,
        autoRowHeight : false,
        rownumbers:true,
        pagination : true,  
        rownumbers : true,  
        pageSize: 100,
        pageList : [100,200],
        displayMsg:"",//隐藏分页下面的文字"显示几页到几页,共多少条数据"
        singleSelect: false,
        selectOnCheck: true,
        queryParams:{
            ClassName:"web.DHCPE.ResultContrast",
            QueryName:"HistoryList",
            RegNo:"",
            CTLocID:""
        },
        
        columns:[[
            {field:'ID',title:'编码',width:80},
            {field:'Name',width:120,title:'姓名'},
            {field:'ADMString',width:200,title:'就诊号',
            formatter:function(value,rowData,rowIndex){ 
                return "<a href='#'  class='grid-td-text' onclick=ShowResultHistory("+rowData.ADMString+"\)>"+rowData.ADMString+"</a>";
            
            }},
            {field:'DBDate',width:120,title:'对比时间'},
            {field:'DBUser',width:120,title:'对比人'}
            
        ]]
        
    
    })
    
}

$(init);