CompObj.cls = "dhc.sync.web.System";
CompObj.compName = "dhc_sync_data_System";
CompObj.tabelPre = "Sys";
//,"Ensemble"
CompObj.model = ["RowId","Code","Name","PublicKey","PrivateKey","Active","Enc","WSDLUrl","ClsName","MthName"];
CompObj.modelUi=["","","","","",
	{type:"combobox",data:[{Code:"Y",Desc:"����"},{Code:"N",Desc:"������"}]},
	{type:"combobox",data:[{Code:"Y",Desc:"����"},{Code:"N",Desc:"������"}]}
	,"","",""
];
//	{type:"combobox",data:[{Code:"Y",Desc:"���ü���ƽ̨"},{Code:"N",Desc:"���ü���ƽ̨"}]}
$(initEvent)
$(function(){
	$("#WSDLUrl").width(600);
	$("#ClsName").width(300);
});