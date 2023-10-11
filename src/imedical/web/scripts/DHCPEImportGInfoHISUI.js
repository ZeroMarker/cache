//DHCPEImportGInfoHISUI.js    ����������Ϣ
//ReadInfo   ��֤��Ϣ����ȷ��
//ImportInfo ������Ϣ
//GInString RegNo^GName^Tel^LinkMan^PostCode^Email^StartDate^EndDate^GReportSend^IReportSend^AsCharged^ChargedMode^AddItem^AddItemLimit^AddItemAmount^Remark^AddMedical^AddMedicalLimit^AddMedicalAmount^Rebate^Address
//TInString  TName^StartDate^EndDate^AddItem^AddItemLimit^AddItemAmount^AddMedical^AddMedicalLimit^AddMedicalAmount^Sex^AgeMax^AgeMin^Married
//IInString TName^RegNo^Name^CardNo^Sex^Age^Birth^Married^MoveTel^Tel^Address^StartDate^EndDate^AsCharged^IReportSend^ChargedMode^AddItem^AddItemLimit^AddItemAmount^AddMedical^AddMedicalLimit^AddMedicalAmount
document.write('<input type= "file" id= "File" style= "display:none">');

var StrValue=""
var aCity={11:"����",12:"���",13:"�ӱ�",14:"ɽ��",15:"���ɹ�",21:"����",22:"����",23:"������",31:"�Ϻ�",32:"����",33:"�㽭",34:"����",35:"����",36:"����",37:"ɽ��",41:"����",42:"����",43:"����",44:"�㶫",45:"����",46:"����",50:"����",51:"�Ĵ�",52:"����",53:"����",54:"����",61:"����",62:"����",63:"�ຣ",64:"����",65:"�½�",71:"̨��",81:"���",82:"����",91:"����"}

function CheckInfo()
{
	if(EnableLocalWeb==1){
		return ReadInfoApp_cmdshell("Check");
	}
	ReadInfoApp("Check");
}
function ReadInfo()
{
	if(EnableLocalWeb==1){
		return ReadInfoApp_cmdshell("Import");
	}
	ReadInfoApp("Import");
}

/**
 * [�м����ʽ]
 * @param    {[String]}    Type [Import�����룬Check����Ϣ��֤]
 * @Author   wangguoying
 * @DateTime 2020-03-25
 */
function ReadInfoApp_cmdshell(Type)
{
	$("#tempType").val(Type);
	$("#fileNew").filebox("reset")
	$("#SelectTemplate").window("open");
}

/**
 * [ģ��ȷ���¼�]
 * @Author   wangguoying
 * @DateTime 2020-03-25
 */
function confirm_file()
{
	var fileList=$("#fileNew").filebox("files");
    if(fileList.length==0){
    	$.messager.alert("��ʾ",$g("��ѡ��ģ�壡"),"info");
    	return false;
    }
    getExcelJsonArr(fileList[0],0,function(excelArr){
    	$("#SelectTemplate").window("close");
    	$('#Loading').fadeIn('fast'); 
    	ReadInfoApp_new(excelArr,$("#tempType").val());
    });  	
}
/**
 * [��ȡExcel����Ļص�����]
 * @param    {[JSONArray]}    excelArr [Excel����]
 * @param    {[String]}    Type [Import�����룬Check����Ϣ��֤]
 * @Author   wangguoying
 * @DateTime 2020-03-25
 */
function ReadInfoApp_new(excelArr,Type){
	if(excelArr=="" || excelArr== "undefind" || excelArr.length==0){
		$.messager.alert("��ʾ",$g("δ��ȡ��ģ�����ݣ����飡"),"info");
		$('#Loading').fadeOut('fast');
		return false;
	}
	var job = session['LOGON.USERID'];
	var obj = document.getElementById("Job");
	if (obj) job = obj.value;
	var GID = "";
	var obj = document.getElementById("ID");
	if (obj) GID = obj.value;

	if ((GID == "") || (GID == "0")) {
		$.messager.alert("��ʾ", $g("��û��ԤԼ������Ϣ��"), "info");
		$('#Loading').fadeOut('fast');
		return false;
	}
	var ret = tkMakeServerCall("web.DHCPE.ImportGInfo", "GetTeamStatus", GID);
	if (ret == "") {
		$.messager.alert("��ʾ", $g("��û�з�����Ϣ��"), "info");
		$('#Loading').fadeOut('fast');
		return false;
	}
	var Desc = $("#GroupDesc").combogrid("getText")

	var AllowCF = "0";
	iAllowCF = getValueById("AllowCF")
	if (iAllowCF) {
		AllowCF = 1;
	}
	KillImportGlobal(job);
	var errMsg="";
	for(var i=0;i<excelArr.length;i++){
		var obj=excelArr[i];
		var IInString = "";
		var TeamName="";
		if(obj.��������) TeamName = StringIsNull(obj.��������);
		IInString = TeamName; 								//TName1
		var RegNo ="";
		if(obj.�ǼǺ�) RegNo = StringIsNull(obj.�ǼǺ�);
		IInString = IInString + "^" + RegNo; 				//RegNo2
		var Name="";
		if(obj.����) Name = StringIsNull(obj.����);
		IInString = IInString + "^" + Name; 				//Name3
		if(Name=""){
			errMsg=errMsg+$g("\n��")+(i+2)+$g("������Ϊ��");
			continue;
		}
		var IDCard="";
		if(obj.���֤��) IDCard = StringIsNull(obj.���֤��);
		IDCard = ReplaceStr(IDCard, "'", "");
		IDCard = ReplaceStr(IDCard, String.fromCharCode(10), "");
		IDCard = ReplaceStr(IDCard, String.fromCharCode(13), "")
		var IsvalidIDCard = isCardID(IDCard);
		if (IsvalidIDCard != true) {
			errMsg=errMsg+$g("\n��")+(i+2)+$g("��")+IsvalidIDCard;
			continue;
		}
		IInString = IInString + "^" + IDCard; 				//IDCard4

		var Birth = GetBirthByIDCard(IDCard);
		var Sex = "";
		var Arr = Birth.split("^");
		Birth = Arr[0];
		if (Birth != "") {
			if (!IsDate(Birth)) {
				errMsg=errMsg+$g("\n��")+(i+2)+$g("�����֤¼������ղ���");
				continue;
			}
			Sex = Arr[1];
		}
		var ExcelDesc="";
		if(obj.�Ա�) ExcelDesc = StringIsNull(obj.�Ա�);
		if ((Sex != "") && (ExcelDesc != "") && (ExcelDesc != Sex)) {
			errMsg=errMsg+&g("\n��")+(i+2)+$g("�����֤�е��Ա��ģ��¼����Ա�һ��");
			continue;
		}
		if (Sex != "") ExcelDesc = Sex;
		IInString = IInString + "^" + ExcelDesc; 			//Sex5

		var Age="";
		if(obj.����) Age = StringIsNull(obj.����);
		IInString = IInString + "^" + Age; 					//Age6
		var ExcelBirth="";
		if (Birth != "") {
			ExcelBirth = Birth;
		} else {
			if(obj.����) ExcelBirth = StringIsNull(obj.����);
		}
		if (ExcelBirth != "") {
			if (!IsDate(ExcelBirth)) {
				errMsg=errMsg+$g("\n��")+(i+2)+$g("�����ղ���ȷ");
				continue;
			}
		}
		IInString = IInString + "^" + ExcelBirth; 			//Birth7

		var StrValue="";
		if(obj.����״��) StrValue = StringIsNull(obj.����״��);
		if (StrValue == "") StrValue = "�ѻ�";
		IInString = IInString + "^" + StrValue; 			//Married8
		StrValue="";
		if(obj.�ƶ��绰) StrValue = StringIsNull(obj.�ƶ��绰);
		IInString = IInString + "^" + StrValue; 			//MoveTel9
		StrValue="";
		if(obj.��ϵ�绰) StrValue = StringIsNull(obj.��ϵ�绰);
		IInString = IInString + "^" + StrValue; 			//Tel10
		StrValue="";
		if(obj.����) StrValue = StringIsNull(obj.����);
		IInString = IInString + "^" + StrValue; 			//Address11
		StrValue="";
		if(obj.��ʼ����) StrValue = StringIsNull(obj.��ʼ����);
		IInString = IInString + "^" + StrValue; 			//StartDate12		
		StrValue="";
		if(obj.��������) StrValue = StringIsNull(obj.��������);
		IInString = IInString + "^" + StrValue; 			//EndDate13
		StrValue="";
		if(obj.��ͬ�շ�) StrValue = StringIsNull(obj.��ͬ�շ�);
		IInString = IInString + "^" + StrValue;				//AsCharged14
		StrValue="";
		if(obj.���˱�����ȡ) StrValue = StringIsNull(obj.���˱�����ȡ);
		IInString = IInString + "^" + StrValue; 			//IReportSend15
		StrValue="";
		if(obj.���㷽ʽ) StrValue = StringIsNull(obj.���㷽ʽ);
		IInString = IInString + "^" + StrValue; 			//ChargedMode16
		StrValue="";
		if(obj.���Ѽ���) StrValue = StringIsNull(obj.���Ѽ���);
		IInString = IInString + "^" + StrValue; 			//AddItem17
		StrValue="";
		if(obj.����������) StrValue = StringIsNull(obj.����������);
		IInString = IInString + "^" + StrValue; 			//AddItemLimit18
		StrValue="";
		if(obj.������) StrValue = StringIsNull(obj.������);
		IInString = IInString + "^" + StrValue; 			//AddItemAmount19
		StrValue="";
		if(obj.���Ѽ�ҩ) StrValue = StringIsNull(obj.���Ѽ�ҩ);
		IInString = IInString + "^" + StrValue; 			//AddMedical20
		StrValue="";
		if(obj.��ҩ�������) StrValue = StringIsNull(obj.��ҩ�������);
		IInString = IInString + "^" + StrValue; 			//AddMedicalLimit21
		StrValue="";
		if(obj.��ҩ���) StrValue = StringIsNull(obj.��ҩ���);
		IInString = IInString + "^" + StrValue; 			//AddMedicalAmount22
		StrValue="";
		if(obj.������λ) StrValue = StringIsNull(obj.������λ);
		IInString = IInString + "^" + StrValue; 			//������λ23
		StrValue="";
		if(obj.����) StrValue = StringIsNull(obj.����);
		StrValue = tkMakeServerCall("web.DHCPE.PreCommon", "GetNationDR", StrValue)
		IInString = IInString + "^" + StrValue; 			//����24
		StrValue="";
		if(obj.�·���) StrValue = StringIsNull(obj.�·���);
		IInString = IInString + "^" + StrValue; 			//�·���25
		StrValue="";
		if(obj.��ϵ��ַ) StrValue = StringIsNull(obj.��ϵ��ַ);
		IInString = IInString + "^" + StrValue; 			//����ϵ��ַ26
		StrValue="";
		if(obj.��������) StrValue = StringIsNull(obj.��������);
		IInString = IInString + "^" + StrValue;				 //��������27
		StrValue="";
		if(obj.��������) StrValue = StringIsNull(obj.��������);
		IInString = IInString + "^" + StrValue; 			//��������28
		StrValue="";
		if(obj.���￨��) StrValue = StringIsNull(obj.���￨��);
		IInString = IInString + "^" + StrValue; 			//���￨��29
		StrValue="";
		if(obj.VIP�ȼ�) StrValue = StringIsNull(obj.VIP�ȼ�);
		IInString = IInString + "^" + StrValue; 			//VIP�ȼ�30
		StrValue="";
		if(obj.����) StrValue = StringIsNull(obj.����);
		IInString = IInString + "^" + StrValue; 			//����31
		StrValue="";
		if(obj.������) StrValue = StringIsNull(obj.������);
		IInString = IInString + "^" + StrValue; 			//������32
		StrValue="";
		if(obj.ְ��) StrValue = StringIsNull(obj.ְ��);
		IInString = IInString + "^" + StrValue; 			//ְ��33
		StrValue="";

		if(obj.����) StrValue = StringIsNull(obj.����);
		IInString = IInString + "^" + StrValue; 			//���� 34 
		StrValue="";
		if(obj.�Ӻ�����) StrValue = StringIsNull(obj.�Ӻ�����);
		IInString = IInString + "^" + StrValue; 			//�Ӻ�����35
		
		IInString=IInString+"^"+(i+2);    //�кŷŵ����
		ReturnValue = tkMakeServerCall("web.DHCPE.ImportGInfo", "GetGPersonInfo", GID, IInString, Type, job, Desc, AllowCF);
		if (ReturnValue != 0) {
			var RetArr = ReturnValue.split("&");
			if(ReturnValue.indexOf("&")>-1){
				errMsg=errMsg+$g("\n��")+(i+2)+$g("��")+RetArr[0]+":"+RetArr[1];
			}else{
				errMsg=errMsg+$g("\n��")+(i+2)+$g("��")+RetArr[0];
			}

			continue;
		}
	}
	$('#Loading').fadeOut('fast');
	if(errMsg!=""){
		$.messager.alert("��ʾ",$g("���ݴ���")+errMsg,"info");
		return false;
	}
	if (Type == "Check") {
		KillImportGlobal(job);
		$.messager.alert("��ʾ", "��֤���", "success");
		return "";
	}
	var Return = ImportInfo(GID, job);
	return Return;
}
		

	
	



function ReadInfoApp(Type)
{
	var job = session['LOGON.USERID'];
	var obj = document.getElementById("Job");
	if (obj) job = obj.value;
	var xlApp, xlsheet, xlBook;
	var Template, GInString = "",
		TInString = "",
		IInString = "";
	var encmeth = "",
		encmethObj, ReturnValue;
	var Flag = 1,
		i = 2;
	var GID = "";
	var obj = document.getElementById("ID");
	if (obj) GID = obj.value;

	if ((GID == "") || (GID == "0")) {
		$.messager.alert("��ʾ", "��û��ԤԼ������Ϣ��", "info");
		return false;
	}

	var ret = tkMakeServerCall("web.DHCPE.ImportGInfo", "GetTeamStatus", GID);
	if (ret == "") {
		$.messager.alert("��ʾ", "��û�з�����Ϣ��", "info");
		return false;
	}


	var Desc = $("#GroupDesc").combogrid("getText")

	var AllowCF = "0";
	iAllowCF = getValueById("AllowCF")
	if (iAllowCF) {
		AllowCF = 1;
	}


	KillImportGlobal(job);
	try {
		var Template = "";
		var obj = document.getElementById("File")
		if (obj) {
			obj.click();
			Template = obj.value;
			obj.outerHTML = obj.outerHTML; //���ѡ���ļ�����
		}
		if (Template == "") return false;
		var extend = Template.substring(Template.lastIndexOf(".") + 1);
		if (!(extend == "xls" || extend == "xlsx")) {
			$.messager.alert("��ʾ", "��ѡ��xls�ļ�", "info");
			return false;
		}

		xlApp = new ActiveXObject("Excel.Application");

		xlBook = xlApp.Workbooks.Add(Template);

		//��֤������Ϣ
		xlsheet = xlBook.WorkSheets("��Ա��Ϣ");
		xlsheet1 = xlBook.WorkSheets("Sheet1");


		i = 2
		xlsheet.Columns(7).NumberFormatLocal = "@";
		var GenModel = GetGenModel();

		while (Flag = 1) {
			IInString = ""
			StrValue = StringIsNull(xlsheet.cells(i, 1).Value);
			IInString = StrValue; //TName1

			StrValue = StringIsNull(xlsheet.cells(i, 2).Value);
			var RegNo = StrValue
			IInString = IInString + "^" + StrValue; //RegNo2
			StrValue = StringIsNull(xlsheet.cells(i, 3).Value);
			if (StrValue == "") break;
			IInString = IInString + "^" + StrValue; //Name3
			//�������֤һЩ�������
			StrValue = StringIsNull(xlsheet.cells(i, 4).Value);
			StrValue = ReplaceStr(StrValue, "'", "");
			StrValue = ReplaceStr(StrValue, String.fromCharCode(10), "");
			StrValue = ReplaceStr(StrValue, String.fromCharCode(13), "")
			/// add by sxt ���֤������Ч��
			var IsvalidIDCard = isCardID(StrValue)
			if (IsvalidIDCard != true) {
				xlsheet.cells(i, 34).Value = StringIsNull(xlsheet.cells(i, 34).Value) + IsvalidIDCard;
				xlsheet.Rows(i).Copy;

				xlsheet1.Rows(2).Insert;
				i = i + 1
				continue;

			}

			IInString = IInString + "^" + StrValue; //���֤��
			var Birth = GetBirthByIDCard(StrValue);
			var Sex = "";
			var Arr = Birth.split("^");
			Birth = Arr[0];
			if (Birth != "") {

				if (!IsDate(Birth)) {
					xlsheet.cells(i, 34).Value = StringIsNull(xlsheet.cells(i, 34).Value) + $g("���֤¼������ղ���");
					xlsheet.Rows(i).Copy;

					xlsheet1.Rows(2).Insert;
					i = i + 1
					continue;

				}
				Sex = Arr[1];
			}

			StrValue = StringIsNull(xlsheet.cells(i, 5).Value);
			if ((Sex != "") && (StrValue != "") && (StrValue != Sex)) {
				xlsheet.cells(i, 34).Value = StringIsNull(xlsheet.cells(i, 34).Value) + $g("���֤�е��Ա��ģ��¼����Ա�һ��");
				xlsheet.Rows(i).Copy;

				xlsheet1.Rows(2).Insert;
				i = i + 1
				continue;
			}
			if (Sex != "") StrValue = Sex;
			IInString = IInString + "^" + StrValue; //Sex5

			StrValue = StringIsNull(xlsheet.cells(i, 6).Value);
			IInString = IInString + "^" + StrValue; //Age6
			if (Birth != "") {
				StrValue = Birth;
			} else {
				StrValue = StringIsNull(xlsheet.cells(i, 7).Value);
			}

			if (StrValue != "") {
				if (!IsDate(StrValue)) {
					xlsheet.cells(i, 34).Value = StringIsNull(xlsheet.cells(i, 34).Value) + $g("���ղ���ȷ");
					xlsheet.Rows(i).Copy;

					xlsheet1.Rows(2).Insert;
					i = i + 1
					continue;
				}

			}
			IInString = IInString + "^" + StrValue; //Birth7
			StrValue = StringIsNull(xlsheet.cells(i, 8).Value);
			if (StrValue == "") StrValue = "�ѻ�";


			IInString = IInString + "^" + StrValue; //Married8
			StrValue = StringIsNull(xlsheet.cells(i, 9).Value);

			IInString = IInString + "^" + StrValue; //MoveTel9
			StrValue = StringIsNull(xlsheet.cells(i, 10).Value);
			IInString = IInString + "^" + StrValue; //Tel10

			StrValue = StringIsNull(xlsheet.cells(i, 11).Value);
			IInString = IInString + "^" + StrValue; //Address11
			StrValue = StringIsNull(xlsheet.cells(i, 12).Value);
			IInString = IInString + "^" + StrValue; //StartDate12
			StrValue = StringIsNull(xlsheet.cells(i, 13).Value);
			IInString = IInString + "^" + StrValue; //EndDate13
			StrValue = StringIsNull(xlsheet.cells(i, 14).Value);
			IInString = IInString + "^" + StrValue; //AsCharged14
			StrValue = StringIsNull(xlsheet.cells(i, 15).Value);
			IInString = IInString + "^" + StrValue; //IReportSend15

			StrValue = StringIsNull(xlsheet.cells(i, 16).Value);
			IInString = IInString + "^" + StrValue; //ChargedMode16
			StrValue = StringIsNull(xlsheet.cells(i, 17).Value);
			IInString = IInString + "^" + StrValue; //AddItem17
			StrValue = StringIsNull(xlsheet.cells(i, 18).Value);
			IInString = IInString + "^" + StrValue; //AddItemLimit18
			StrValue = StringIsNull(xlsheet.cells(i, 19).Value);
			IInString = IInString + "^" + StrValue; //AddItemAmount19
			StrValue = StringIsNull(xlsheet.cells(i, 20).Value);
			IInString = IInString + "^" + StrValue; //AddMedical20

			StrValue = StringIsNull(xlsheet.cells(i, 21).Value);
			IInString = IInString + "^" + StrValue; //AddMedicalLimit21
			StrValue = StringIsNull(xlsheet.cells(i, 22).Value);
			IInString = IInString + "^" + StrValue; //AddMedicalAmount22
			StrValue = StringIsNull(xlsheet.cells(i, 23).Value);
			IInString = IInString + "^" + StrValue; //������λ23
			StrValue = StringIsNull(xlsheet.cells(i, 24).Value);
			StrValue = tkMakeServerCall("web.DHCPE.PreCommon", "GetNationDR", StrValue)
			IInString = IInString + "^" + StrValue; //����24
			StrValue = StringIsNull(xlsheet.cells(i, 25).Value);
			IInString = IInString + "^" + StrValue; //�·���25
			StrValue = StringIsNull(xlsheet.cells(i, 26).Value);
			IInString = IInString + "^" + StrValue; //��λ26
			StrValue = StringIsNull(xlsheet.cells(i, 27).Value);
			IInString = IInString + "^" + StrValue; //����
			StrValue = StringIsNull(xlsheet.cells(i, 28).Value);
			IInString = IInString + "^" + StrValue; //��������
			StrValue = StringIsNull(xlsheet.cells(i, 29).Value);
			IInString = IInString + "^" + StrValue; //���￨��
			StrValue = StringIsNull(xlsheet.cells(i, 30).Value);
			IInString = IInString + "^" + StrValue; //VIPLevel
			StrValue = StringIsNull(xlsheet.cells(i, 31).Value);
			IInString = IInString + "^" + StrValue; //����
			StrValue = StringIsNull(xlsheet.cells(i, 32).Value);
			IInString = IInString + "^" + StrValue; //������
			StrValue = StringIsNull(xlsheet.cells(i, 33).Value);
			IInString = IInString + "^" + StrValue; //ְ��

			StrValue = StringIsNull(xlsheet.cells(i, 34).Value);
			IInString = IInString + "^" + StrValue; //����  
			StrValue = StringIsNull(xlsheet.cells(i, 35).Value);
			IInString = IInString + "^" + StrValue; //�Ӻ�����



			ReturnValue = tkMakeServerCall("web.DHCPE.ImportGInfo", "GetGPersonInfo", GID, IInString, Type, job, Desc, AllowCF);



			if (ReturnValue != 0) {

				var RetArr = ReturnValue.split("&");


				xlsheet.cells(i, 37).Value = StringIsNull(xlsheet.cells(i, 37).Value) + RetArr[0];
				xlsheet.cells(i, 38).Value = StringIsNull(xlsheet.cells(i, 38).Value) + RetArr[1];
				xlsheet.Rows(i).Copy;

				xlsheet1.Rows(2).Insert;
				i = i + 1
				continue;
			}
			i = i + 1
		}
		if (Type == "Import") {

			xlBook.SaveCopyAs(Template);
		}

		CloseExcel(xlApp, xlBook, xlsheet)
		if (Type == "Check") {
			KillImportGlobal(job);
			$.messager.alert("��ʾ", "��֤���", "success");
			return "";
		}

		var Return = ImportInfo(GID, job);



		return Return;
	} catch (e) {
		$.messager.alert("��ʾ", e + "^" + e.message, "info");
	}
}
//����������Ϣ
function ImportInfo(GID,job)
{
	var Return=tkMakeServerCall("web.DHCPE.ImportGInfo","Main",GID,job);
	
	var ReturnStr=Return.split("^");
	var Flag=ReturnStr[0];
	if (Flag!=0)
	{
		if (Flag=="-119") Flag="���������ظ�";
		$.messager.alert("��ʾ",$g("����������Ϣ���ɹ�.Error:")+Flag,"info");	
	}
	else
	{
		$.messager.alert("��ʾ",$g("����������Ϣ�ɹ�,����������")+ReturnStr[3]+"��"+ReturnStr[2],"info");
	}
	return ReturnStr[1];
}
//��֤�Ƿ�Ϊ����
function CheckNum(Num)
{
	if (isNaN(Num))
	{
		return false;
	}
	return true;
}
//��֤��ʽΪyyyy-mm-dd������
function chkdate(datestr) 
{ 
 	var lthdatestr 
 	if (datestr != "") 
 		lthdatestr= datestr.length ; 
 	else 
 		lthdatestr=0; 
   
 	var tmpy=""; 
 	var tmpm=""; 
 	var tmpd=""; 
 	//var datestr; 
 	var status; 
 	status=0; 
 	if ( lthdatestr== 0) 
 		return false 


 	for (i=0;i<lthdatestr;i++) 
 	{
	 	if (datestr.charAt(i)== '-') 
 		{ 
   			status++; 
  		} 
  		if (status>2) 
  		{ 
   			return false; 
  		} 
  		if ((status==0) && (datestr.charAt(i)!='-')) 
  		{ 
   			tmpy=tmpy+datestr.charAt(i) 
  		} 
  		if ((status==1) && (datestr.charAt(i)!='-')) 
  		{ 
   			tmpm=tmpm+datestr.charAt(i) 
  		} 
  		if ((status==2) && (datestr.charAt(i)!='-')) 
  		{ 
   			tmpd=tmpd+datestr.charAt(i) 
  		} 

 	} 
 	year=new String (tmpy); 
 	month=new String (tmpm); 
 	day=new String (tmpd) 
 	//tempdate= new String (year+month+day); 
 	//alert(tempdate); 
 	if ((tmpy.length!=4) || (tmpm.length>2) || (tmpd.length>2)) 
 	{ 
 		return false; 
 	} 
 	if (!((1<=month) && (12>=month) && (31>=day) && (1<=day)) ) 
 	{ 
  		return false; 
 	} 
 	if (!((year % 4)==0) && (month==2) && (day==29)) 
 	{ 
  		return false; 
 	} 
 	if ((month<=7) && ((month % 2)==0) && (day>=31)) 
 	{ 
 		return false; 
  
 	} 
 	if ((month>=8) && ((month % 2)==1) && (day>=31)) 
 	{ 
  		return false; 
 	} 
 	if ((month==2) && (day==30)) 
 	{ 
  		return false; 
 	} 
  
 	return true; 
} 
//��֤�Ƿ�Ϊ�绰
function CheckTel(Tel)
{
	var pattern=/(^[0-9]{3,4}\-[0-9]{3,8}$)|(^[0-9]{3,8}$)|(^\([0-9]{3,4}\)[0-9]{3,8}$)|(^0{0,1}13|15[0-9]{9}$)/;
 	if(pattern.test(Tel)){
  	return true;
 	}else{
  	return false;
 	}
}
//��֤�Ƿ�Ϊ�ƶ��绰
function CheckMoveTel(MoveTel)
{
	if (MoveTel=="") return true;
	var pattern=/^0{0,1}13|15[0-9]{9}$/;
	if(pattern.test(MoveTel)){
	return true;
	}else{
  	return false;
 	}
}
//ȥ���ַ������˵Ŀո�
function Trim(String)
{
	if (""==String) { return ""; }
	var m = String.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

//ȥ���ַ����Ŀո�
function jsTrim(str) 
{
	var reg=/\s/;
	if(!reg.test(str)){return str;}
	return str.replace(/\s+/g,"");
}

function StringIsNull(String)
{
	if (String==null) return ""
	//return String
	return jsTrim(String)
}

//ȥ���ַ������˵Ŀո�
function ReplaceStr(s,Split,LinkStr)
{
	if (""==s) { return ""; }
	var SArr=s.split(Split)
	s=SArr.join(LinkStr)
	return s
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

function GetBirthByIDCard(num)
{
	if (num=="") return "";
	//alert(toString(num))
	var ShortNum=num.substr(0,num.length-1)
	if (isNaN(ShortNum))
	{
		//alert("����Ĳ�������?");
		return "";
	}
	var len = num.length;
	var re;
	if (len == 15) re = new RegExp(/^(\d{6})()?(\d{2})(\d{2})(\d{2})(\d{3})$/);
	else if (len == 18) re = new RegExp(/^(\d{6})()?(\d{4})(\d{2})(\d{2})(\d{3})(\d)$/);
	else {//alert("���֤�����������λ������?");
	//websys_setfocus("IDCard");
	return "";}
	var a = (ShortNum+"1").match(re);
	if (a != null)
	{
		if (len==15)
		{
			var D = new Date("19"+a[3]+"/"+a[4]+"/"+a[5]);
			var B = D.getYear()==a[3]&&(D.getMonth()+1)==a[4]&&D.getDate()==a[5];
			var SexFlag=num.substr(14,1);
		}
		else
		{
			var D = new Date(a[3]+"/"+a[4]+"/"+a[5]);
			var B = D.getFullYear()==a[3]&&(D.getMonth()+1)==a[4]&&D.getDate()==a[5];
			var SexFlag=num.substr(16,1);
		}
		
		
		if (!B)
		{
			//alert("��������֤�� "+ a[0] +" ��������ڲ���?");
			
			//websys_setfocus("IDCard"); //DGV2DGV2
			if (a[3].length==2) a[3]="19"+a[3];
			Str=a[3]+"-"+a[4]+"-"+a[5];
			return Str;
		}
		if (a[3].length==2) a[3]="19"+a[3];
		var Str=a[3]+"-"+a[4]+"-"+a[5];
		
		
		var SexNV=""
		if (SexFlag%2==1)
		{
			SexNV="��";
		}
		else
		{
			SexNV="Ů";
		}
		
		
		return Str+"^"+SexNV;
		
	}
	return "";
}
function IsDate(str) 
{ 
   var re = /^\d{4}-\d{1,2}-\d{1,2}$/; 
   if(re.test(str)) 
   { 
       // ��ʼ���ڵ��߼��ж�??�Ƿ�Ϊ�Ϸ������� 
       var array = str.split('-'); 
       var date = new Date(array[0], parseInt(array[1], 10) - 1, array[2]); 
       if(!((date.getFullYear() == parseInt(array[0], 10)) 
           && ((date.getMonth() + 1) == parseInt(array[1], 10)) 
           && (date.getDate() == parseInt(array[2], 10)))) 
       { 
           // ������Ч������ 
           return false; 
       } 
       return true; 
   } 

   // ���ڸ�ʽ���� 
   return false; 
} 

function KillImportGlobal(job)
{
	var ReturnValue=tkMakeServerCall("web.DHCPE.ImportGInfo","KillImportGlobal",job);
	
	return ReturnValue;
}
function GetGenModel()
{
	var obj;
	var GenModel="Gen";
	GenModel=tkMakeServerCall("web.DHCPE.Public.Setting","GetPAPMINoGenModel");
	
	return GenModel;
}
//��������򿪵�Excel����
function CloseExcel(xlApp,xlBook,xlsheet)
{
	xlBook.Close (savechanges=false);
		
	xlApp.Quit();     
	xlApp   =   null; 
	xlsheet=null;  
	//CollectGarbage(); 
	idTmr   =   window.setInterval("Cleanup();",1);   
		
	
}
var   idTmr   =   ""; 
function   Cleanup()   {   
	window.clearInterval(idTmr);   
	CollectGarbage(); 
}
function isCardID(sId){
 var iSum=0 ;
 var info="" ;
 if(sId=="") return true;
 if(!/^\d{17}(\d|x)$/i.test(sId)) return "����������֤���Ȼ��ʽ����";
 sId=sId.replace(/x$/i,"a");
 if(aCity[parseInt(sId.substr(0,2))]==null) return "������֤�����Ƿ�";
 sBirthday=sId.substr(6,4)+"-"+Number(sId.substr(10,2))+"-"+Number(sId.substr(12,2));
 var d=new Date(sBirthday.replace(/-/g,"/")) ;
 if(sBirthday!=(d.getFullYear()+"-"+ (d.getMonth()+1) + "-" + d.getDate()))return "���֤�ϵĳ������ڷǷ�";
 for(var i = 17;i>=0;i --) iSum += (Math.pow(2,i) % 11) * parseInt(sId.charAt(17 - i),11) ;
 if(iSum%11!=1) return "����������֤�ŷǷ�";
 //aCity[parseInt(sId.substr(0,2))]+","+sBirthday+","+(sId.substr(16,1)%2?"��":"Ů");//�˴λ������жϳ���������֤�ŵ����Ա�
 return true;
} 
