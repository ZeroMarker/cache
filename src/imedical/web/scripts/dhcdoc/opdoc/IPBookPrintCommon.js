function IPBookPrint(BookID){
	//打印XML模板
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCDocIPBookPrt");
	var MyPara="";
	var PDlime=String.fromCharCode(2);
	if (BookID==""){
		$.messager.alert('警告','缺少预约信息!');
		return false;
	}
	var BookMesag=$.cm({
		ClassName:"web.DHCDocIPBookNew",
		MethodName:"GetBookMesage",
		BookID:BookID,
		dataType:"text"
	},false);
	if (BookMesag==""){
		$.messager.alert('警告','缺少预约信息!');
		return false;
	}
	var BookMesagArry=BookMesag.split("^");
	var PatID=BookMesagArry[1];
	var PatMes=$.cm({
		ClassName:"web.DHCDocIPBookNew",
		MethodName:"GetPatDetail",
		PatientID:PatID, PatientNO:"", AdmID:"",
		dataType:"text"
	},false);
	var PatMesArry=PatMes.split("^");
	//按照住院证初始化诊断信息
	var DiagnoseStr=BookMesagArry[36];
	var DiagnoseStrArry=DiagnoseStr.split('!');
	var DiaS="";
	for (var i=0;i<DiagnoseStrArry.length;i++){
		var Desc=DiagnoseStrArry[i].split(String.fromCharCode(2))[1];
		if (DiaS==""){DiaS=Desc}
		else{DiaS=DiaS+","+Desc}
	}
	//姓名 性别 年龄 登记号 社会地位 工作单位 住址 联系电话 联系人 关系 联系人电话 诊断
	//住院科室 住院天数（不用） 首诊医院（不用） 操作用户姓名 操作日期 预约日期
	MyPara=MyPara+"PatName"+PDlime+PatMesArry[2]+"^"+"PatSex"+PDlime+PatMesArry[3]+"^"+"PatAge"+PDlime+PatMesArry[5];
	MyPara=MyPara+"^"+"PatRegNo"+PDlime+PatMesArry[1]+"^"+"PatStat"+PDlime+PatMesArry[19];
	MyPara=MyPara+"^"+"PatCom"+PDlime+PatMesArry[15]+"^"+"PatAdd"+PDlime+PatMesArry[17];
	MyPara=MyPara+"^"+"PatTel"+PDlime+PatMesArry[13];
	MyPara=MyPara+"^"+"PatContact"+PDlime+PatMesArry[20]+"^"+"PatRelation"+PDlime+PatMesArry[22];
	MyPara=MyPara+"^"+"PatReTel"+PDlime+PatMesArry[21]+"^"+"PatMR"+PDlime+DiaS;
	MyPara=MyPara+"^"+"PatInDep"+PDlime+BookMesagArry[30]+"^"+"PatInDays"+PDlime+"";
	MyPara=MyPara+"^"+"PatFirHos"+PDlime+""+"^"+"PatUserCode"+PDlime+session['LOGON.USERNAME'];
	MyPara=MyPara+"^"+"PatDocSign"+PDlime+"________"+"^"+"CreatDate"+PDlime+BookMesagArry[4];
	MyPara=MyPara+"^"+"BookDate"+PDlime+BookMesagArry[10];
	MyPara=MyPara+"^"+"Price"+PDlime+BookMesagArry[17];
	MyPara=MyPara+"^"+"StateIDDesc"+PDlime+BookMesagArry[25]; 
	MyPara=MyPara+"^"+"CreatUserDesc"+PDlime+BookMesagArry[26]; 
	MyPara=MyPara+"^"+"CreatDocIDDesc"+PDlime+BookMesagArry[27]; 
	MyPara=MyPara+"^"+"WardIdDesc"+PDlime+BookMesagArry[28]; 
	MyPara=MyPara+"^"+"BedDesc"+PDlime+BookMesagArry[29]; 
	MyPara=MyPara+"^"+"ICDDesc"+PDlime+BookMesagArry[31]; 
	MyPara=MyPara+"^"+"AdmInitStateDesc"+PDlime+BookMesagArry[32]; 
	MyPara=MyPara+"^"+"InReasnDesc"+PDlime+BookMesagArry[33]; 
	MyPara=MyPara+"^"+"InSourceDesc"+PDlime+BookMesagArry[34]; 
	MyPara=MyPara+"^"+"InBedTypeDesc"+PDlime+BookMesagArry[35]; 
	MyPara=MyPara+"^"+"ICDListStr"+PDlime+BookMesagArry[36]; 
	MyPara=MyPara+"^"+"UpdateUserDesc"+PDlime+BookMesagArry[37]; 
	MyPara=MyPara+"^"+"UpdateDate"+PDlime+BookMesagArry[38]; 
	MyPara=MyPara+"^"+"UpdateTime"+PDlime+BookMesagArry[39];
	MyPara=MyPara+"^"+"PatitnLevel"+PDlime+BookMesagArry[40]; 
	MyPara=MyPara+"^"+"CTLocMedUnit"+PDlime+BookMesagArry[41]; 
	MyPara=MyPara+"^"+"InDoctorDR"+PDlime+BookMesagArry[42]; 
	MyPara=MyPara+"^"+"TreatedPrinciple"+PDlime+BookMesagArry[43]; 
	MyPara=MyPara+"^"+"IPBookingNo"+PDlime+BookMesagArry[44]; 
	MyPara=MyPara+"^"+"PatitnLevelDesc"+PDlime+BookMesagArry[45]; 
	MyPara=MyPara+"^"+"CTLocMedUnitDesc"+PDlime+BookMesagArry[46]; 
	MyPara=MyPara+"^"+"InDoctorDesc"+PDlime+BookMesagArry[47]; 
	MyPara=MyPara+"^"+"TreatedPrincipleDesc"+PDlime+BookMesagArry[48]; 
	MyPara=MyPara+"^"+"HospDesc"+PDlime+BookMesagArry[49]; 
	MyPara=MyPara+"^"+"PatDate"+PDlime+BookMesagArry[50]; 
	MyPara=MyPara+"^"+"ReAdmission"+PDlime+(BookMesagArry[62]=="Y"?"是":"否"); 
	MyPara=MyPara+"^"+"InAdmReason"+PDlime+BookMesagArry[64]; 
	//
	if (BookMesagArry[25]=="预住院"){
	MyPara=MyPara+"^"+"PreFlag"+PDlime+"预"; }
	//var myobj=document.getElementById("ClsBillPrint");
	//DHCP_PrintFunNew(myobj,MyPara,"");
	DHC_PrintByLodop(getLodop(),MyPara,"","","");
}