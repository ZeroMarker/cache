//ȫ�ֱ�����������������
var idTmr=""
var valRegNo=""
function outPutInfo(infoStr,stationName,gName){
	//����һ��excel������
	var xls=createExcle();
	var xlBook = xls.Workbooks.Add;
	//xlBook=xls.Workbooks.Open(""d:\\dhcpeTemp\\test.xls");
	var fdir="d:\\dhcpeTemp";
	//����Ŀ¼
	createFolder(fdir);

	//��������
	//alert(infoStr)
	valRegNo="";
	xlBood=writer(xls,xlBook,infoStr);

	//����excel�ļ�
	var xlsName=gName+"_"+stationName
	xlBood=saveXls(xlBood,fdir,xlsName);
	
	//���excel�Ľ���
	cleanXlsObj(xls,xlBook);

}
///cteator:wangfujian
//cteateDate:2009-03-16
///description:����һ��excel���
///return:excel������
function createExcle(){
	 try {
      var xls    = new ActiveXObject ( "Excel.Application" );
     }
    catch(e) {
         alert( "Ҫ��ӡ�ñ�?�����밲װExcel���ӱ�����?ͬʱ�������ʹ��?ActiveX �ؼ�??���������������ִ�пؼ�? ����?����?�˽���������÷���?");
              return "";
     }
	  xls.visible =false;  //����excelΪ���ɼ�
	 xls.UserControl = true;  //����Ҫ,����ʡ��,��Ȼ������� ��˼��excel�����û�����
	return xls;
}
///cteator:wangfujian
//cteateDate:2009-03-16
///description:��һ��excel�ı���
///input:excel���xlBook?����������?λ��
///return:Sheet����
function openSheet(xlBook,sheetName,sheetNum){

    var xlsheet = xlBook.Worksheets(sheetNum);
    xlsheet.Name=sheetName;
	return xlsheet;
}
//cteateDate:2009-03-16
///description:��excel�еĹ�����д������
///return:excel�Ĺ���������,д�����ݵ��ַ���?
//"�����ϴ�_���,������^00111^24^��^����%������$�ĵ�@����&�ڿ�%�ڿ�רҵ���$�ĵ�@����##"
function writer(xls,xlBook,inStr){
	
	//var inStr="�ڿ�,�����ϴ�_���||������^00111^24^��^����%������$�ĵ�@����&�ڿ�%�ڿ�רҵ���$�ĵ�@����##������^00111^24^��^����%������$�ĵ�@����&�ڿ�%�ڿ�רҵ���$�ĵ�@����#������^00111^24^��^����%������$�ĵ�@����&�ڿ�%�ڿ�רҵ���$�ĵ�@����#������^00111^24^��^����%������$�ĵ�@����&�ڿ�%�ڿ�רҵ���$�ĵ�@����#������^00111^24^��^����%������$�ĵ�@����&�ڿ�%�ڿ�רҵ���$�ĵ�@����#������^00111^24^��^����%������$�ĵ�@����&�ڿ�%�ڿ�רҵ���$�ĵ�@����#������^00111^24^��^����%������$�ĵ�@����&�ڿ�%�ڿ�רҵ���$�ĵ�@����#������^00111^24^��^����%������$�ĵ�@����&�ڿ�%�ڿ�רҵ���$�ĵ�@����#������^00111^24^��^����%������$�ĵ�@����&�ڿ�%�ڿ�רҵ���$�ĵ�@����#;�����ϴ�_�շ�,�����^00111^24^��^;"
    var ExcelSheet = "";
    var station=inStr.split(",")[0];
    var groups=inStr.split(",")[1];

	var groupsStr=groups.split(";");
	var teamNum=0;
	//���һ�������Ϣ
	for (var i=0;i<groupsStr.length ;i++ ){
		if(groupsStr[i]==""){
			continue;
		}
		
		var groupInfo=groupsStr[i];
		var groupName=groupInfo.split("||")[0];
		var title=groupName;
		var persons=groupInfo.split("||")[1];
		teamNum=teamNum+1;
		var currRow=1;
		//Ϊһ�����½�һ������
		ExcelSheet=openSheet(xlBook,groupName,teamNum);
		//���ñ���,�и�
		ExcelSheet.Rows(currRow).RowHeight = 25;
		ExcelSheet.Range(ExcelSheet.Cells(currRow,1),ExcelSheet.Cells(currRow,4)).Interior.ColorIndex=34;
		ExcelSheet.Range(ExcelSheet.Cells(currRow,1),ExcelSheet.Cells(currRow,4)).mergecells=true;
		ExcelSheet.Range(ExcelSheet.Cells(currRow,1),ExcelSheet.Cells(currRow,4)).value=title;
		currRow=currRow+1
		var personsInfo=persons.split("#");
		//alert(personsInfo)
		//���һ����Ա��Ϣ
		for (var j=0;j<personsInfo.length ;j++ )
		{
			if (personsInfo[j]=="")
			{
				continue;
			}
			//alert(personsInfo[j])
			currRow=putPersonInfo(ExcelSheet,personsInfo[j],currRow);
		
			
		
		}
	//�������Զ���Ӧ����?��ȫ�����ݶ���ʾ����
	ExcelSheet.Columns("A:D").ColumnWidth =25;
	ExcelSheet.Range( ExcelSheet.Cells(1,1),ExcelSheet.Cells(1,4)).HorizontalAlignment =3;//����
	
		
	}
	return xlBook;
	
}

//cteateDate:2009-03-16
///description:��������д��һ���˵���Ϣ
///input:excel�Ĺ���������?������Ϣ?��ǰ�Ŀ�ʼ����
///return:��ǰ��������:"rurrRow#ExcelSheet"
function putPersonInfo(ExcelSheet,personInfo,currRow){
	
	var colorRow=currRow;
	//���ø��˵Ļ�����Ϣ
	var iAdm=personInfo;
	var name=iAdm.split("^")[0];
	var regNo=iAdm.split("^")[1];
	var sex=iAdm.split("^")[3];
	var age=iAdm.split("^")[2];
	var orders=iAdm.split("^")[4];
	if (regNo!=valRegNo)
	{
		ExcelSheet.Cells(currRow,1).Value="����";
		ExcelSheet.Cells(currRow,2).Value="�ǼǺ�";
		ExcelSheet.Cells(currRow,3).Value="�Ա�";
		ExcelSheet.Cells(currRow,4).Value="����";
		
		currRow=currRow+1;
		//�˵Ļ�����Ϣ
		ExcelSheet.Cells(currRow,1).Value=name;
		ExcelSheet.Cells(currRow,2).Value=regNo;	
		ExcelSheet.Cells(currRow,3).Value=sex;
		ExcelSheet.Cells(currRow,4).Value=age;
		//��ÿ���˶�������Ϣ���ϱ���ɫ
		ExcelSheet.Range(ExcelSheet.Cells(colorRow,1),ExcelSheet.Cells(currRow,4)).Interior.ColorIndex=15;
		ExcelSheet.Range( ExcelSheet.Cells(currRow-1,1),ExcelSheet.Cells(currRow,4)).HorizontalAlignment =3;//����
		currRow=currRow+1;
		valRegNo=regNo;
	}
			
	var orderArray=orders.split("&");
	for (var m=1;m<=orderArray.length ;m++ )
	{
		if (orderArray[m-1]=="")
		{
			continue;
		}
		var orderTitle=orderArray[m-1].split("$")[0];
		var orderDetails=orderArray[m-1].split("$")[1]
		//���ô���ı���
		var station=orderTitle.split("%")[0];
		var orderName=orderTitle.split("%")[1];
		/* ����������ע�͵���ȥ���˿�����һ��*/
		//ExcelSheet.Cells(currRow,1).Value=station;
		//currRow=currRow+1;
		ExcelSheet.Cells(currRow,1).Value=orderName;
		var detailArray=orderDetails.split("@");
		if (detailArray.length>1){
			if 	(!(detailArray[1].split("-�����").length>1)) ExcelSheet.Cells(currRow,2).Value="���";
		}
		ExcelSheet.Range(ExcelSheet.Cells(currRow,2),ExcelSheet.Cells(currRow,4)).mergecells=true;
		currRow=currRow+1;
		
		for (var n=0;n<detailArray.length ;n++ )
		{
			if 	(detailArray[n].split("-�����").length>1) continue;
			ExcelSheet.Cells(currRow,1).Value=detailArray[n];
			ExcelSheet.Range(ExcelSheet.Cells(currRow,2),ExcelSheet.Cells(currRow,4)).mergecells=true;
						
			currRow=currRow+1;
		}
		

	}
	return currRow;
			
}
//cteateDate:2009-03-16
///description:����һ��������
///input:excel�Ĺ���������
function saveXls(xlBook,fdir,fName){
	var flag=2
	//��һ���ļ�����
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	for(var i=1;i<flag;i++){
		if(!fso.FileExists(fdir+"\\"+fName+i+".XLS")){
			xlBook.SaveAs(fdir+"\\"+fName+i+".XLS");  // ������
		}else{
			flag=flag+1;
		}
	}
	
}

//cteateDate:2009-03-16
///description:������й������Ķ���
///input:
function cleanXlsObj(xls,xlBook){
	xlBook.Close(savechanges=true) ;
	xls.Quit();
	xls=null;
	xlBook=null;
	//���˽�����������
	 idTmr = window.setInterval("Cleanup();",1);

}

//cteateDate:2009-03-16
///description:js����������
///input:
  function Cleanup() {
    window.clearInterval(idTmr);
    CollectGarbage();
  }

//cteateDate:2009-03-16
///description:�����ļ���,����ļ��д���?������?�������򴴽�
///input:�ļ��е�·��?��?"d:\\dhcpeTemp"
function createFolder(fdir){
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	if(!fso.FolderExists(fdir)){
		fso.CreateFolder(fdir);
	}
}
///author:wangfujian
///createDate:2009-03-26
///description:��վ�㵼��һ������������Ա��Ϣ��ҽ����Ϣ��excel����
function outputInfo_click(){
 
	var obj=window.event.srcElement;
	if(obj.disabled){
		return;
	}
	//�ȳ�ʼ����Ҫ������վ����
	var stationsObj=document.getElementById("getStationBox");
	var encahe=stationsObj.value;
	//var stations="һ����,^�ڿ�,^���,^����,^�ۿ�,^���Ǻ��,"
	var stations=cspRunServerMethod(encahe);
	var outputInfo=stations.split("^");
   
	//ȡ�������PreGADMRowid����������
	var preGADMRowid=""
	obj=document.getElementById("RowId");
	if (obj){ 
		preGADMRowid=obj.value; 
	}
	obj=document.getElementById('RowId_Name');
	if (obj){ 
		GName=obj.value; 
	}
 
	//ͨ��preGADMRowid��ø���������г�Ա��PAADM
	obj=document.getElementById("getPAADMsByPreGADMBox");
	var encahe=obj.value;
	var PAADMs=cspRunServerMethod(encahe,preGADMRowid);
	//PAADMs="10988^39394"
	if(PAADMs==""){
		alert("û����Ҫ��������Ϣ!");
		return;
	}
	 
	//ȡ����������
	var patientNum="";
	var PAADMArray=PAADMs.split("^");
	patientNum=PAADMArray.length;
	for(var i=0;i<patientNum;i++){
		var currPAADMInfo=PAADMArray[i];
		var currPAADMRowid=currPAADMInfo.split("#")[0]
		var currPatientTeamName=currPAADMInfo.split("#")[1]
		//ͬ��PAADM�õ�������Ҫ��������Ϣ
		var encache="";
		var obj=document.getElementById("outputInfoBox");
		if(obj){
			var encache=obj.value;
		}
		//�õ�һ���˵���Ϣ
		
		var admInfo=cspRunServerMethod(encache,currPAADMRowid);

		//��������?һ����?�ڿ�?���?����?�ۿ�?���Ǻ��?���һ��Ҫ��վ����ϵ��
		var iadmBaseInfo= admInfo.split("#")[0];
		var stationInfo=admInfo.split("#")[1];
		
		var iadmStationInfo=stationInfo.split("&");
      
		for(var m=0;m<iadmStationInfo.length;m++){
			
			if(iadmStationInfo[m]==""){
				continue;
			}
			for(var j=0;j<outputInfo.length;j++){
				
				var sation=outputInfo[j].split(",")[0];
				
				var teamInfo=outputInfo[j].split(",")[1];
				if(iadmStationInfo[m].split("%")[0]==sation){
					//�Ѹ�����Ϣ���뵽��Ӧ��վ��ͷ���
				
					if(teamInfo==""){
						outputInfo[j]=sation+","+currPatientTeamName+"||"+iadmBaseInfo+"^"+iadmStationInfo[m]+"#;";
					}else{
						//outputInfo[j]="�ڿ�,cache||wangfujian#wanghuicai;java||wangfujian#wanghuicai"
						var allTeams=teamInfo.split(";")
						var isNewTeamFlag=0
						for(var k=0;k<allTeams.length;k++){
							if(allTeams[k]==""){
								continue;
							}
			
							if(allTeams[k].split("||")[0]==currPatientTeamName){
								//allTeams[k]=allTeams[k]+iadmBaseInfo+"^"+iadmStationInfo[m]
								if(k==0){
									outputInfo[j]=sation+","+allTeams[k]+iadmBaseInfo+"^"+iadmStationInfo[m]+"#;";
								}else{
									outputInfo[j]=outputInfo[j]+allTeams[k]+iadmBaseInfo+"^"+iadmStationInfo[m]+"#;";
								}
								isNewTeamFlag=1
							}else{
								if(k==0){
									outputInfo[j]=sation+","+allTeams[k]+";";
								}else{
									outputInfo[j]=outputInfo[j]+allTeams[k]+";"
								}
							}
						}
						if(isNewTeamFlag==0){
							outputInfo[j]=outputInfo[j]+currPatientTeamName+"||"+iadmBaseInfo+"^"+iadmStationInfo[m]+"#;";
						}
					}
	
				}
			}
			
		}
	}
	
	//�����е���Ϣ��������
	var outFlag=0
	for(var j=0;j<outputInfo.length;j++){

		if(outputInfo[j].split(",")[1]!=""){
			
			//������Ϣ
			//dhcpeOutputAdmInfo.JS��
			//վ������
			var stationName=outputInfo[j].split(",")[0]

			outPutInfo(outputInfo[j],stationName,GName);
			outFlag=1
			
		}
	}
	if(outFlag==1){
		alert("�ɹ�������D:\dhcpeTempĿ¼��!")
	}else{
		alert("û����Ҫ��������Ϣ!")
	}
	
}