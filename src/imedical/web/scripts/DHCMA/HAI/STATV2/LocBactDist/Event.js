function InitLocBactDistWinEvent(obj){
	obj.LoadEvent = function(args){
	 $('#ReportFrame').css('display', 'block');
	 setTimeout(function(){
		 obj.LoadRep();
	 },50);
	 //表的点击事件
	 $('#btnSearchTable').on('click',function(e,value){
		 $('#ReportFrame').css('display', 'block');
		 $('#EchartDiv').css('display', 'none');
		 obj.LoadRep();
	 });
	}
 
	obj.LoadRep = function(){
	 var aHospID 	= $('#cboHospital').combobox('getValues').join('|');
	 var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
	 var aDateTo	= $('#dtDateTo').datebox('getValue');
	 var aStatNum 	= $('#cboStatNum').combobox('getText');
	 var aDateType 	= $('#cboDateType').combobox('getValue');
	 var aDrugLevel = $('#cboDrugLevel').combobox('getValue');
	 var aStatUnit  = Common_CheckboxValue('chkStatunit');
	 if (aStatUnit=="W"){
		 aStatUnit=1;
	 }else{
		 aStatUnit=2;
	 }
	 ReportFrame = document.getElementById("ReportFrame");
	 
	 if(aDateFrom > aDateTo){
		 $.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
		 return;
	 }
	 if ((aDateFrom=="")||(aDateTo=="")){
		 $.messager.alert("提示","请选择开始日期、结束日期！", 'info');
		 return;
	 }
	 if ($('#cboInfType').combobox('getValue')==""){
		 obj.TypeCode="";
	 }
	 p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.LocBactDist.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aDateType='+aDateType+'&aSpecID='+obj.SpecDr+'&aStatNum='+aStatNum+'&aDrugLevel='+aDrugLevel+'&aStatUnit='+aStatUnit+'&aTypeCode='+obj.TypeCode+'&aLocIDs='+""+'&aPath='+cspPath;	
	 if(!ReportFrame.src){
		 ReportFrame.frameElement.src=p_URL;
	 }else{
		 ReportFrame.src = p_URL;
	 }
 }
 obj.up=function(x,y){
	 return y.InfPatCnt-x.InfPatCnt
 }
}