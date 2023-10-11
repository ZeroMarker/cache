
//名称    DHCPEAdmRecordList.hisui.js
//功能    个人日志操作记录
//创建    2020.12.17
//创建人  xy

$(function(){
    

    Info();

    InitAdmRecordListGrid();  
     
  
})

function Info(){
    
    var Info=tkMakeServerCall("web.DHCPE.AdmRecordManager","GetBaseInfo",AdmId);
    var Arr=Info.split("^");
    $("#Name").val(Arr[0]);
    $("#Sex").val(Arr[1]);
    $("#Dob").val(Arr[2]);
    $("#IDCard").val(Arr[3]);
    $("#IDCardType").val(Arr[8]);
    
    var CSPName="dhcpeadmrecordlist.hisui.csp";
    var RemarkInfo=tkMakeServerCall("web.DHCPE.AdmRecordManager","GetAdmRecordReMarkInfo",AdmId,CSPName);
     $("#ReMark").val(RemarkInfo);
}

function InitAdmRecordListGrid(){
    
    $HUI.datagrid("#AdmRecordListGrid",{
        url:$URL,
        fit : true,
        border : false,
        striped : false,
        fitColumns : false,
        autoRowHeight : false,
        rownumbers:true,
        pagination : true,  
        rownumbers : true,  
        pageSize: 20,
        pageList : [20,100,200],
        
        queryParams:{
            ClassName:"web.DHCPE.AdmRecordManager",
            QueryName:"FindAdmRecord",
            AdmId:AdmId,
            CSPName:"dhcpeadmrecordlist.hisui.csp"
                
        },
        columns:[[

            {field:'TDate',width:'120',title:'日期'},
            {field:'TTime',width:'100',title:'时间'},
            {field:'TType',width:'120',title:'类型'},
            {field:'TRemark',width:'450',title:'信息'},
            {field:'TUser',width:'90',title:'操作人'},
            {field:'TID',title:'ID',hidden: true}
                        
        ]]
            
    })
        
}


