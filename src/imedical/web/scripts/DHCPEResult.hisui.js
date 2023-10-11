//名称	 DHCPEResult.hisui.js
//功能	 结果明细
//创建	 2023.02.18
//创建人 xueying

$(function(){
 
    Init();
    
	InitResultGrid();
	
})

function Init(){
	var LocID=session['LOGON.CTLOCID'];
   	var UserID=session['LOGON.USERID'];
   	
	$("#ArcDesc,#OEORDStatus,#AuditDoc,#AuditDate,#TransResultFun,#InterfaceReturn").val("");
	
	$("#OEORDID").val(OEORDID);
	
	var ret=tkMakeServerCall("web.DHCPE.TransResultDetail","GetInfoByOEORDID",OEORDID);
	var retone=ret.split("^");
	$("#ArcDesc").val(retone[0]);
	$("#OEORDStatus").val(retone[1]);
	$("#AuditDoc").val(retone[2]);
	$("#AuditDate").val(retone[3]);
	var ArcItemId=retone[4];
	
	var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","IsLisRisStation",ArcItemId,LocID);
	if(flag==1){
		var TRRet=tkMakeServerCall("web.DHCPE.TransResultDetail","GetTransResultInfo",OEORDID,LocID,UserID);
		var TRRetOne=TRRet.split("^");
		$("#TransResultFun").val(TRRetOne[0]);
		$("#InterfaceReturn").val(TRRetOne[1]);
	}
	
}


function InitResultGrid(){
	$HUI.datagrid("#ResultGrid",{
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
			OEORDID:OEORDID   
		},columns:[[ 
			{field:'RLTID',title:'结果ID',width:100},
            {field:'ODDesc',width:150,title:'项目名称'},
            {field:'Result',width:200,title:'结果'},
            {field:'TSInfo',width:80,title:'异常标记'},
            {field:'ODUnit',width:90,title:'单位'},
            {field:'Standard',width:120,title:'参考范围'}
           
		]]
	
	})
}
