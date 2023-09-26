
/// 用药教育出院带药打印 2015-03-07 bianshuai
function print_medEducationrap(medEduID)
{
    if(medEduID==""){alert("用药教育ID为空,请重试！");return;}
    
    //明细数据
	var retval=tkMakeServerCall("web.DHCPHMEDEDUCATION","getOutMedEdu",medEduID);
	if(retval==""){
		alert("取明细信息错误");
		return;
	}

	var retvalArr=retval.split("^");  //记录数[处方总数]
	var locDesc=retvalArr[0]; //科室
	var patBed=retvalArr[1]; 	  //床号
	var patNo=retvalArr[2];   //住院号
	var patName=retvalArr[3]; //姓名
	var patSex=retvalArr[4];  //性别
	var patAge=retvalArr[5];  //年龄
	var patDiag=retvalArr[6]; //出院诊断
	var therSchedule=retvalArr[7]; //康复治疗方案
	
	var param="&locDesc="+locDesc+"&patBed="+patBed+"&patNo="+patNo+"&patName="+patName+"&patSex="+patSex+"&patAge="+patAge+"&patDiag="+patDiag+"&therSchedule="+therSchedule;
    
	var p_URL='dhccpmrunqianreport.csp?reportName=DHCST_PHCM_MedEduOut.raq&medEduID='+medEduID+param;
	window.open(p_URL,"用药教育","top=20,left=20,width=930,height=660,scrollbars=1");
}
