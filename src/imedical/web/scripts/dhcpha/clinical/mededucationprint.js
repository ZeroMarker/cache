
/// ��ҩ������Ժ��ҩ��ӡ 2015-03-07 bianshuai
function print_medEducationrap(medEduID)
{
    if(medEduID==""){alert("��ҩ����IDΪ��,�����ԣ�");return;}
    
    //��ϸ����
	var retval=tkMakeServerCall("web.DHCPHMEDEDUCATION","getOutMedEdu",medEduID);
	if(retval==""){
		alert("ȡ��ϸ��Ϣ����");
		return;
	}

	var retvalArr=retval.split("^");  //��¼��[��������]
	var locDesc=retvalArr[0]; //����
	var patBed=retvalArr[1]; 	  //����
	var patNo=retvalArr[2];   //סԺ��
	var patName=retvalArr[3]; //����
	var patSex=retvalArr[4];  //�Ա�
	var patAge=retvalArr[5];  //����
	var patDiag=retvalArr[6]; //��Ժ���
	var therSchedule=retvalArr[7]; //�������Ʒ���
	
	var param="&locDesc="+locDesc+"&patBed="+patBed+"&patNo="+patNo+"&patName="+patName+"&patSex="+patSex+"&patAge="+patAge+"&patDiag="+patDiag+"&therSchedule="+therSchedule;
    
	var p_URL='dhccpmrunqianreport.csp?reportName=DHCST_PHCM_MedEduOut.raq&medEduID='+medEduID+param;
	window.open(p_URL,"��ҩ����","top=20,left=20,width=930,height=660,scrollbars=1");
}
