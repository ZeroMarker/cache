
//名称	DHCPESelectPIADMRecord.hisui.js
//功能	选择就诊记录
//创建	2018.09.12
//创建人  xy
$(function(){
	alert(12)
	
	InitSelectPIADMRecordGrid();
	
})
function InitSelectPIADMRecordGrid(){
	$HUI.datagrid("#dhcpeselectpiadmrecord",{
		url:$URL,
		nowrap:false,
		queryParams:{
			ClassName:"web.DHCPE.PreIADMEx",
			QueryName:"SearchPreIADM", 
			PIADMs:PIADMs
			
		},columns:[[ 
			{field:'PIBIPAPMINo',width:'100',title:'登记号'},
			{field:'PIADMPIBIDRName',width:'100',title:'姓名'},
			{field:'IADMPGADMDRName',width:'100',title:'团体名称'},
			{field:'PIADMPGTeamDRName',width:'220',title:'分组名称'},
			{field:'PIADMPEDateBegin',width:'255',title:'体检日期'},
			{field:'PIADMOldHPNo',width:'255',title:'体检编号'},
			{field:'id',hidden:true},
			{field:'PIADMPIBIDR',hidden:true}
			
			
		]]
	
	})
}

