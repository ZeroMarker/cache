//DHCPEImportGInfoHISUI.js    导入团体信息
//ReadInfo   验证信息的正确性
//ImportInfo 导入信息
//GInString RegNo^GName^Tel^LinkMan^PostCode^Email^StartDate^EndDate^GReportSend^IReportSend^AsCharged^ChargedMode^AddItem^AddItemLimit^AddItemAmount^Remark^AddMedical^AddMedicalLimit^AddMedicalAmount^Rebate^Address
//TInString  TName^StartDate^EndDate^AddItem^AddItemLimit^AddItemAmount^AddMedical^AddMedicalLimit^AddMedicalAmount^Sex^AgeMax^AgeMin^Married
//IInString TName^RegNo^Name^CardNo^Sex^Age^Birth^Married^MoveTel^Tel^Address^StartDate^EndDate^AsCharged^IReportSend^ChargedMode^AddItem^AddItemLimit^AddItemAmount^AddMedical^AddMedicalLimit^AddMedicalAmount
document.write('<input type= "file" id= "File" style= "display:none">');

var StrValue=""
var aCity={11:"北京",12:"天津",13:"河北",14:"山西",15:"内蒙古",21:"辽宁",22:"吉林",23:"黑龙江",31:"上海",32:"江苏",33:"浙江",34:"安徽",35:"福建",36:"江西",37:"山东",41:"河南",42:"湖北",43:"湖南",44:"广东",45:"广西",46:"海南",50:"重庆",51:"四川",52:"贵州",53:"云南",54:"西藏",61:"陕西",62:"甘肃",63:"青海",64:"宁夏",65:"新疆",71:"台湾",81:"香港",82:"澳门",91:"国外"}

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
 * [中间件方式]
 * @param    {[String]}    Type [Import：导入，Check：信息验证]
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
 * [模板确认事件]
 * @Author   wangguoying
 * @DateTime 2020-03-25
 */
function confirm_file()
{
	var fileList=$("#fileNew").filebox("files");
    if(fileList.length==0){
    	$.messager.alert("提示",$g("请选择模板！"),"info");
    	return false;
    }
    getExcelJsonArr(fileList[0],0,function(excelArr){
    	$("#SelectTemplate").window("close");
    	$('#Loading').fadeIn('fast'); 
    	ReadInfoApp_new(excelArr,$("#tempType").val());
    });  	
}
/**
 * [读取Excel数组的回调函数]
 * @param    {[JSONArray]}    excelArr [Excel数组]
 * @param    {[String]}    Type [Import：导入，Check：信息验证]
 * @Author   wangguoying
 * @DateTime 2020-03-25
 */
function ReadInfoApp_new(excelArr,Type){
	if(excelArr=="" || excelArr== "undefind" || excelArr.length==0){
		$.messager.alert("提示",$g("未读取到模板数据，请检查！"),"info");
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
		$.messager.alert("提示", $g("还没有预约团体信息！"), "info");
		$('#Loading').fadeOut('fast');
		return false;
	}
	var ret = tkMakeServerCall("web.DHCPE.ImportGInfo", "GetTeamStatus", GID);
	if (ret == "") {
		$.messager.alert("提示", $g("还没有分组信息！"), "info");
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
		if(obj.分组名称) TeamName = StringIsNull(obj.分组名称);
		IInString = TeamName; 								//TName1
		var RegNo ="";
		if(obj.登记号) RegNo = StringIsNull(obj.登记号);
		IInString = IInString + "^" + RegNo; 				//RegNo2
		var Name="";
		if(obj.姓名) Name = StringIsNull(obj.姓名);
		IInString = IInString + "^" + Name; 				//Name3
		if(Name=""){
			errMsg=errMsg+$g("\n第")+(i+2)+$g("行姓名为空");
			continue;
		}
		var IDCard="";
		if(obj.身份证号) IDCard = StringIsNull(obj.身份证号);
		IDCard = ReplaceStr(IDCard, "'", "");
		IDCard = ReplaceStr(IDCard, String.fromCharCode(10), "");
		IDCard = ReplaceStr(IDCard, String.fromCharCode(13), "")
		var IsvalidIDCard = isCardID(IDCard);
		if (IsvalidIDCard != true) {
			errMsg=errMsg+$g("\n第")+(i+2)+$g("行")+IsvalidIDCard;
			continue;
		}
		IInString = IInString + "^" + IDCard; 				//IDCard4

		var Birth = GetBirthByIDCard(IDCard);
		var Sex = "";
		var Arr = Birth.split("^");
		Birth = Arr[0];
		if (Birth != "") {
			if (!IsDate(Birth)) {
				errMsg=errMsg+$g("\n第")+(i+2)+$g("行身份证录入的生日不对");
				continue;
			}
			Sex = Arr[1];
		}
		var ExcelDesc="";
		if(obj.性别) ExcelDesc = StringIsNull(obj.性别);
		if ((Sex != "") && (ExcelDesc != "") && (ExcelDesc != Sex)) {
			errMsg=errMsg+&g("\n第")+(i+2)+$g("行身份证中的性别和模版录入的性别不一致");
			continue;
		}
		if (Sex != "") ExcelDesc = Sex;
		IInString = IInString + "^" + ExcelDesc; 			//Sex5

		var Age="";
		if(obj.年龄) Age = StringIsNull(obj.年龄);
		IInString = IInString + "^" + Age; 					//Age6
		var ExcelBirth="";
		if (Birth != "") {
			ExcelBirth = Birth;
		} else {
			if(obj.生日) ExcelBirth = StringIsNull(obj.生日);
		}
		if (ExcelBirth != "") {
			if (!IsDate(ExcelBirth)) {
				errMsg=errMsg+$g("\n第")+(i+2)+$g("行生日不正确");
				continue;
			}
		}
		IInString = IInString + "^" + ExcelBirth; 			//Birth7

		var StrValue="";
		if(obj.婚姻状况) StrValue = StringIsNull(obj.婚姻状况);
		if (StrValue == "") StrValue = "已婚";
		IInString = IInString + "^" + StrValue; 			//Married8
		StrValue="";
		if(obj.移动电话) StrValue = StringIsNull(obj.移动电话);
		IInString = IInString + "^" + StrValue; 			//MoveTel9
		StrValue="";
		if(obj.联系电话) StrValue = StringIsNull(obj.联系电话);
		IInString = IInString + "^" + StrValue; 			//Tel10
		StrValue="";
		if(obj.部门) StrValue = StringIsNull(obj.部门);
		IInString = IInString + "^" + StrValue; 			//Address11
		StrValue="";
		if(obj.开始日期) StrValue = StringIsNull(obj.开始日期);
		IInString = IInString + "^" + StrValue; 			//StartDate12		
		StrValue="";
		if(obj.结束日期) StrValue = StringIsNull(obj.结束日期);
		IInString = IInString + "^" + StrValue; 			//EndDate13
		StrValue="";
		if(obj.视同收费) StrValue = StringIsNull(obj.视同收费);
		IInString = IInString + "^" + StrValue;				//AsCharged14
		StrValue="";
		if(obj.个人报告领取) StrValue = StringIsNull(obj.个人报告领取);
		IInString = IInString + "^" + StrValue; 			//IReportSend15
		StrValue="";
		if(obj.结算方式) StrValue = StringIsNull(obj.结算方式);
		IInString = IInString + "^" + StrValue; 			//ChargedMode16
		StrValue="";
		if(obj.公费加项) StrValue = StringIsNull(obj.公费加项);
		IInString = IInString + "^" + StrValue; 			//AddItem17
		StrValue="";
		if(obj.加项金额限制) StrValue = StringIsNull(obj.加项金额限制);
		IInString = IInString + "^" + StrValue; 			//AddItemLimit18
		StrValue="";
		if(obj.加项金额) StrValue = StringIsNull(obj.加项金额);
		IInString = IInString + "^" + StrValue; 			//AddItemAmount19
		StrValue="";
		if(obj.公费加药) StrValue = StringIsNull(obj.公费加药);
		IInString = IInString + "^" + StrValue; 			//AddMedical20
		StrValue="";
		if(obj.加药金额限制) StrValue = StringIsNull(obj.加药金额限制);
		IInString = IInString + "^" + StrValue; 			//AddMedicalLimit21
		StrValue="";
		if(obj.加药金额) StrValue = StringIsNull(obj.加药金额);
		IInString = IInString + "^" + StrValue; 			//AddMedicalAmount22
		StrValue="";
		if(obj.工作单位) StrValue = StringIsNull(obj.工作单位);
		IInString = IInString + "^" + StrValue; 			//工作单位23
		StrValue="";
		if(obj.民族) StrValue = StringIsNull(obj.民族);
		StrValue = tkMakeServerCall("web.DHCPE.PreCommon", "GetNationDR", StrValue)
		IInString = IInString + "^" + StrValue; 			//民族24
		StrValue="";
		if(obj.新发卡) StrValue = StringIsNull(obj.新发卡);
		IInString = IInString + "^" + StrValue; 			//新发卡25
		StrValue="";
		if(obj.联系地址) StrValue = StringIsNull(obj.联系地址);
		IInString = IInString + "^" + StrValue; 			//部联系地址26
		StrValue="";
		if(obj.病人类型) StrValue = StringIsNull(obj.病人类型);
		IInString = IInString + "^" + StrValue;				 //病人类型27
		StrValue="";
		if(obj.健康区域) StrValue = StringIsNull(obj.健康区域);
		IInString = IInString + "^" + StrValue; 			//健康区域28
		StrValue="";
		if(obj.就诊卡号) StrValue = StringIsNull(obj.就诊卡号);
		IInString = IInString + "^" + StrValue; 			//就诊卡号29
		StrValue="";
		if(obj.VIP等级) StrValue = StringIsNull(obj.VIP等级);
		IInString = IInString + "^" + StrValue; 			//VIP等级30
		StrValue="";
		if(obj.工号) StrValue = StringIsNull(obj.工号);
		IInString = IInString + "^" + StrValue; 			//工号31
		StrValue="";
		if(obj.病案号) StrValue = StringIsNull(obj.病案号);
		IInString = IInString + "^" + StrValue; 			//病案号32
		StrValue="";
		if(obj.职务) StrValue = StringIsNull(obj.职务);
		IInString = IInString + "^" + StrValue; 			//职务33
		StrValue="";

		if(obj.工种) StrValue = StringIsNull(obj.工种);
		IInString = IInString + "^" + StrValue; 			//工种 34 
		StrValue="";
		if(obj.接害工龄) StrValue = StringIsNull(obj.接害工龄);
		IInString = IInString + "^" + StrValue; 			//接害工龄35
		
		IInString=IInString+"^"+(i+2);    //行号放到最后
		ReturnValue = tkMakeServerCall("web.DHCPE.ImportGInfo", "GetGPersonInfo", GID, IInString, Type, job, Desc, AllowCF);
		if (ReturnValue != 0) {
			var RetArr = ReturnValue.split("&");
			if(ReturnValue.indexOf("&")>-1){
				errMsg=errMsg+$g("\n第")+(i+2)+$g("行")+RetArr[0]+":"+RetArr[1];
			}else{
				errMsg=errMsg+$g("\n第")+(i+2)+$g("行")+RetArr[0];
			}

			continue;
		}
	}
	$('#Loading').fadeOut('fast');
	if(errMsg!=""){
		$.messager.alert("提示",$g("数据错误：")+errMsg,"info");
		return false;
	}
	if (Type == "Check") {
		KillImportGlobal(job);
		$.messager.alert("提示", "验证完毕", "success");
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
		$.messager.alert("提示", "还没有预约团体信息！", "info");
		return false;
	}

	var ret = tkMakeServerCall("web.DHCPE.ImportGInfo", "GetTeamStatus", GID);
	if (ret == "") {
		$.messager.alert("提示", "还没有分组信息！", "info");
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
			obj.outerHTML = obj.outerHTML; //清空选择文件名称
		}
		if (Template == "") return false;
		var extend = Template.substring(Template.lastIndexOf(".") + 1);
		if (!(extend == "xls" || extend == "xlsx")) {
			$.messager.alert("提示", "请选择xls文件", "info");
			return false;
		}

		xlApp = new ActiveXObject("Excel.Application");

		xlBook = xlApp.Workbooks.Add(Template);

		//验证个人信息
		xlsheet = xlBook.WorkSheets("人员信息");
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
			//过滤身份证一些特殊符号
			StrValue = StringIsNull(xlsheet.cells(i, 4).Value);
			StrValue = ReplaceStr(StrValue, "'", "");
			StrValue = ReplaceStr(StrValue, String.fromCharCode(10), "");
			StrValue = ReplaceStr(StrValue, String.fromCharCode(13), "")
			/// add by sxt 身份证号码有效性
			var IsvalidIDCard = isCardID(StrValue)
			if (IsvalidIDCard != true) {
				xlsheet.cells(i, 34).Value = StringIsNull(xlsheet.cells(i, 34).Value) + IsvalidIDCard;
				xlsheet.Rows(i).Copy;

				xlsheet1.Rows(2).Insert;
				i = i + 1
				continue;

			}

			IInString = IInString + "^" + StrValue; //身份证号
			var Birth = GetBirthByIDCard(StrValue);
			var Sex = "";
			var Arr = Birth.split("^");
			Birth = Arr[0];
			if (Birth != "") {

				if (!IsDate(Birth)) {
					xlsheet.cells(i, 34).Value = StringIsNull(xlsheet.cells(i, 34).Value) + $g("身份证录入的生日不对");
					xlsheet.Rows(i).Copy;

					xlsheet1.Rows(2).Insert;
					i = i + 1
					continue;

				}
				Sex = Arr[1];
			}

			StrValue = StringIsNull(xlsheet.cells(i, 5).Value);
			if ((Sex != "") && (StrValue != "") && (StrValue != Sex)) {
				xlsheet.cells(i, 34).Value = StringIsNull(xlsheet.cells(i, 34).Value) + $g("身份证中的性别和模版录入的性别不一致");
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
					xlsheet.cells(i, 34).Value = StringIsNull(xlsheet.cells(i, 34).Value) + $g("生日不正确");
					xlsheet.Rows(i).Copy;

					xlsheet1.Rows(2).Insert;
					i = i + 1
					continue;
				}

			}
			IInString = IInString + "^" + StrValue; //Birth7
			StrValue = StringIsNull(xlsheet.cells(i, 8).Value);
			if (StrValue == "") StrValue = "已婚";


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
			IInString = IInString + "^" + StrValue; //工作单位23
			StrValue = StringIsNull(xlsheet.cells(i, 24).Value);
			StrValue = tkMakeServerCall("web.DHCPE.PreCommon", "GetNationDR", StrValue)
			IInString = IInString + "^" + StrValue; //民族24
			StrValue = StringIsNull(xlsheet.cells(i, 25).Value);
			IInString = IInString + "^" + StrValue; //新发卡25
			StrValue = StringIsNull(xlsheet.cells(i, 26).Value);
			IInString = IInString + "^" + StrValue; //部位26
			StrValue = StringIsNull(xlsheet.cells(i, 27).Value);
			IInString = IInString + "^" + StrValue; //类型
			StrValue = StringIsNull(xlsheet.cells(i, 28).Value);
			IInString = IInString + "^" + StrValue; //健康区域
			StrValue = StringIsNull(xlsheet.cells(i, 29).Value);
			IInString = IInString + "^" + StrValue; //就诊卡号
			StrValue = StringIsNull(xlsheet.cells(i, 30).Value);
			IInString = IInString + "^" + StrValue; //VIPLevel
			StrValue = StringIsNull(xlsheet.cells(i, 31).Value);
			IInString = IInString + "^" + StrValue; //工号
			StrValue = StringIsNull(xlsheet.cells(i, 32).Value);
			IInString = IInString + "^" + StrValue; //病案号
			StrValue = StringIsNull(xlsheet.cells(i, 33).Value);
			IInString = IInString + "^" + StrValue; //职务

			StrValue = StringIsNull(xlsheet.cells(i, 34).Value);
			IInString = IInString + "^" + StrValue; //工种  
			StrValue = StringIsNull(xlsheet.cells(i, 35).Value);
			IInString = IInString + "^" + StrValue; //接害工龄



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
			$.messager.alert("提示", "验证完毕", "success");
			return "";
		}

		var Return = ImportInfo(GID, job);



		return Return;
	} catch (e) {
		$.messager.alert("提示", e + "^" + e.message, "info");
	}
}
//导入团体信息
function ImportInfo(GID,job)
{
	var Return=tkMakeServerCall("web.DHCPE.ImportGInfo","Main",GID,job);
	
	var ReturnStr=Return.split("^");
	var Flag=ReturnStr[0];
	if (Flag!=0)
	{
		if (Flag=="-119") Flag="团体名称重复";
		$.messager.alert("提示",$g("导入团体信息不成功.Error:")+Flag,"info");	
	}
	else
	{
		$.messager.alert("提示",$g("导入团体信息成功,导入人数：")+ReturnStr[3]+"，"+ReturnStr[2],"info");
	}
	return ReturnStr[1];
}
//验证是否为数字
function CheckNum(Num)
{
	if (isNaN(Num))
	{
		return false;
	}
	return true;
}
//验证格式为yyyy-mm-dd的日期
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
//验证是否为电话
function CheckTel(Tel)
{
	var pattern=/(^[0-9]{3,4}\-[0-9]{3,8}$)|(^[0-9]{3,8}$)|(^\([0-9]{3,4}\)[0-9]{3,8}$)|(^0{0,1}13|15[0-9]{9}$)/;
 	if(pattern.test(Tel)){
  	return true;
 	}else{
  	return false;
 	}
}
//验证是否为移动电话
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
//去除字符串两端的空格
function Trim(String)
{
	if (""==String) { return ""; }
	var m = String.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

//去除字符串的空格
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

//去除字符串两端的空格
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
		//alert("输入的不是数字?");
		return "";
	}
	var len = num.length;
	var re;
	if (len == 15) re = new RegExp(/^(\d{6})()?(\d{2})(\d{2})(\d{2})(\d{3})$/);
	else if (len == 18) re = new RegExp(/^(\d{6})()?(\d{4})(\d{2})(\d{2})(\d{3})(\d)$/);
	else {//alert("身份证号输入的数字位数不对?");
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
			//alert("输入的身份证号 "+ a[0] +" 里出生日期不对?");
			
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
			SexNV="男";
		}
		else
		{
			SexNV="女";
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
       // 开始日期的逻辑判断??是否为合法的日期 
       var array = str.split('-'); 
       var date = new Date(array[0], parseInt(array[1], 10) - 1, array[2]); 
       if(!((date.getFullYear() == parseInt(array[0], 10)) 
           && ((date.getMonth() + 1) == parseInt(array[1], 10)) 
           && (date.getDate() == parseInt(array[2], 10)))) 
       { 
           // 不是有效的日期 
           return false; 
       } 
       return true; 
   } 

   // 日期格式错误 
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
//彻底清除打开的Excel进程
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
 if(!/^\d{17}(\d|x)$/i.test(sId)) return "你输入的身份证长度或格式错误";
 sId=sId.replace(/x$/i,"a");
 if(aCity[parseInt(sId.substr(0,2))]==null) return "你的身份证地区非法";
 sBirthday=sId.substr(6,4)+"-"+Number(sId.substr(10,2))+"-"+Number(sId.substr(12,2));
 var d=new Date(sBirthday.replace(/-/g,"/")) ;
 if(sBirthday!=(d.getFullYear()+"-"+ (d.getMonth()+1) + "-" + d.getDate()))return "身份证上的出生日期非法";
 for(var i = 17;i>=0;i --) iSum += (Math.pow(2,i) % 11) * parseInt(sId.charAt(17 - i),11) ;
 if(iSum%11!=1) return "你输入的身份证号非法";
 //aCity[parseInt(sId.substr(0,2))]+","+sBirthday+","+(sId.substr(16,1)%2?"男":"女");//此次还可以判断出输入的身份证号的人性别
 return true;
} 
