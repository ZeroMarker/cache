
//����	    DHCPETransResultDetail.hisui.js
//����	    ���Խ��
//����	    2023.01.10
//������  	xueying

$(function(){	

	IniTransResultDetailGrid();  
	
	Init(); 
})

function Init(){
   	var LocID=session['LOGON.CTLOCID'];
   	var UserID=session['LOGON.USERID'];
   
	$("#OEORDID").val(OEORI);
	$("#OEORDStatus").val(Status);
	$("#OEORDLabNo").val(LabNo);
	
	var ret=tkMakeServerCall("web.DHCPE.TransResultDetail","GetTransResultInfo",OEORI,LocID,UserID);
	var retone=ret.split("^");
	$("#TransResultFun").val(retone[0]);
	
	$("#InterfaceReturn").val(retone[1]);
	$("#ExsistResult").val(retone[2]);
  
}
function IniTransResultDetailGrid(){

    $HUI.datagrid("#TransResultDetailGrid",{
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
            ClassName:"web.DHCPE.TransResultDetail",
            QueryName:"FindResultDetail",
            OEORDID:OEORI   
        },
        columns:[[
            {field:'RLTID',title:'���ID',width:100},
            {field:'ODDesc',width:120,title:'��Ŀ����'},
            {field:'Result',width:200,title:'���'},
            {field:'ODUnit',width:90,title:'��λ'},
            {field:'Standard',width:120,title:'�ο���Χ'},
            {field:'UserName',width:150,title:'���ҽ��'},
            {field:'ReportDoc',width:150,title:'����ҽ��'},
            {field:'AuditDoc',width:150,title:'���ҽ��'}   
        ]]
                
    })
}

