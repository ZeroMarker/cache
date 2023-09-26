CompObj.cls = "dhc.sync.web.System";
CompObj.compName = "dhc_sync_data_System";
CompObj.tabelPre = "Sys";
//,"Ensemble"
CompObj.model = ["RowId","Code","Name","PublicKey","PrivateKey","Active","Enc","WSDLUrl","ClsName","MthName"];
CompObj.modelUi=["","","","","",
	{type:"combobox",data:[{Code:"Y",Desc:"激活"},{Code:"N",Desc:"不激活"}]},
	{type:"combobox",data:[{Code:"Y",Desc:"加密"},{Code:"N",Desc:"不加密"}]}
	,"","",""
];
//	{type:"combobox",data:[{Code:"Y",Desc:"调用集成平台"},{Code:"N",Desc:"不用集成平台"}]}
$(initEvent)
$(function(){
	$("#WSDLUrl").width(600);
	$("#ClsName").width(300);
});