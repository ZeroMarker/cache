//added by xy 20181119
//function:ת��
//js:hisui/DHCPEMoveTeam.js

function BodyLoadHandler() {
	 	
	 	var iParRef=getValueById("ParRef");	
}

var selectrow=-1;
function SelectRowHandler(index,rowdata) {
	
	selectrow=index;
	if (selectrow=="-1") {
		$.messager.alert("��ʾ","��ѡ�����","info");
		return
		}
		$.messager.confirm("ȷ��", "�Ƿ�ȷ��ת�Ƶ�����", function(r){
		if (r){
			if(index==selectrow)
		{
		var PGTeam=rowdata.PGT_RowId;
		var Sex=rowdata.PGT_Sex_Desc;
		var UpperLimit=rowdata.PGT_UpperLimit;
		var LowerLimit=rowdata.PGT_LowerLimit;
		
		var Married=rowdata.PGT_Married_Desc;
		
	   	var iParRef=getValueById("ParRef");
		var iPIADMRowId=getValueById("PIADMRowId");
		var iPGTeam=getValueById("PGTeam");
		var string=Sex+"^"+Married+"^"+UpperLimit+"^"+LowerLimit;
	  	//var MoveFlag=tkMakeServerCall("web.DHCPE.PreIADM","IsSatisfyTeamInfo",iPIADMRowId,PGTeam,string)
		var MoveFlag=tkMakeServerCall("web.DHCPE.PreIADM","IsAllSatisfyTeamInfo",iPIADMRowId,PGTeam,string)
		var MoveCanFlag=MoveFlag.split("^")
		if (MoveCanFlag[0]!=='0')
 		{
	 		$.messager.alert("��ʾ",MoveCanFlag[1]+",����ת��","info");
		 	return false;

		}
	
		var SucFlag=0,ErrName=""
	iPIADMRowIdArr=iPIADMRowId.split("^");
	for (var i=0;i<iPIADMRowIdArr.length;i++)
	{
		iPIADMRowId=iPIADMRowIdArr[i];
		
		var Ret=tkMakeServerCall("web.DHCPE.CancelPE","CancelPE",iPIADMRowId,"I",0)
        var PIADM=iPIADMRowId+"^CRM";
  		var BaseInfo=tkMakeServerCall("web.DHCPE.BarPrint","GetPersonInfo",PIADM)
        var Name=BaseInfo.split("^")[1];

		var iPIBIDR=tkMakeServerCall("web.DHCPE.PreIADM","GetPIBIByPIADM",iPIADMRowId)
		var flag=tkMakeServerCall("web.DHCPE.PreIADM","InsertIADMInGTeam",iPIBIDR,iParRef,PGTeam)
		var flag=flag.split("^")
		if ('0'!=flag[0]) {
			
			if(ErrName=="") {var ErrName=Name;}
			else{var ErrName=ErrName+" "+Name;} 
		}
		
		if(i==iPIADMRowIdArr.length-1){var SucFlag=1;}
		

	}
	if ('1'==SucFlag) {
		
		    if(ErrName!=""){
				$.messager.alert("��ʾ",ErrName+"ת��ʧ��","error");
			} 
			else{
				$.messager.alert("��ʾ","ת�����","success"); 
			} 
		}

		//window.close();
		window.opener.$("#TeamGrid").datagrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:iParRef});
	
		window.opener.$("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:iPGTeam,RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
		
	
		
	}else
	{
		selectrow=-1;
	
	}
			
		}
	});
	

		

}
/*		
function SelectRowHandler(index,rowdata) {
	if (!confirm("�Ƿ�ȷ��ת�Ƶ�����")) return false;
	//$.messager.confirm("ȷ��", "�Ƿ�ȷ��ת�Ƶ�����", function(r){if (!r) { return false; }});
	selectrow=index;
	if (selectrow=="-1") {
		$.messager.alert("��ʾ","��ѡ�����","info");
		return
		}

	if(index==selectrow)
	{
		var PGTeam=rowdata.PGT_RowId;
		var Sex=rowdata.PGT_Sex_Desc;
		var UpperLimit=rowdata.PGT_UpperLimit;
		var LowerLimit=rowdata.PGT_LowerLimit;
		
		var Married=rowdata.PGT_Married_Desc;
		
	   	var iParRef=getValueById("ParRef");
		var iPIADMRowId=getValueById("PIADMRowId");
		var iPGTeam=getValueById("PGTeam");
		var string=Sex+"^"+Married+"^"+UpperLimit+"^"+LowerLimit;
	  	var MoveFlag=tkMakeServerCall("web.DHCPE.PreIADM","IsSatisfyTeamInfo",iPIADMRowId,PGTeam,string)

		var MoveCanFlag=MoveFlag.split(",")
 		if (MoveCanFlag[0]==-1)
 		{
	 		alert(MoveCanFlag[1]+",����ת��")
		 	return false;

		}
		if (MoveCanFlag[0]==-2)
 		{
	 		//$.messager.alert("��ʾ",MoveCanFlag[1]);
	 		alert(MoveCanFlag[1])
		 	return false;
		
		}
	
		var Ret=tkMakeServerCall("web.DHCPE.CancelPE","CancelPE",iPIADMRowId,"I",0)
   
		var iPIBIDR=tkMakeServerCall("web.DHCPE.PreIADM","GetPIBIByPIADM",iPIADMRowId)
		var flag=tkMakeServerCall("web.DHCPE.PreIADM","InsertIADMInGTeam",iPIBIDR,iParRef,PGTeam)
		var flag=flag.split("^")
		if ('0'==flag[0]) {
			//$.messager.alert("��ʾ","ת��ɹ�");
			alert("ת��ɹ�");    
			window.close();
			window.opener.$("#TeamGrid").datagrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:iParRef});
	
			window.opener.$("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:iPGTeam,RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
		}
		
	}else
	{
		selectrow=-1;
	
	}	

}
*/


document.body.onload = BodyLoadHandler;