
//����	DHCPESelectPIADMRecord.hisui.js
//����	ѡ������¼
//����	2018.09.12
//������  xy
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
			{field:'PIBIPAPMINo',width:'100',title:'�ǼǺ�'},
			{field:'PIADMPIBIDRName',width:'100',title:'����'},
			{field:'IADMPGADMDRName',width:'100',title:'��������'},
			{field:'PIADMPGTeamDRName',width:'220',title:'��������'},
			{field:'PIADMPEDateBegin',width:'255',title:'�������'},
			{field:'PIADMOldHPNo',width:'255',title:'�����'},
			{field:'id',hidden:true},
			{field:'PIADMPIBIDR',hidden:true}
			
			
		]]
	
	})
}

