//DHCPEImportGInfo.js    导入团体信息
//ReadInfo   验证信息的正确性
//ImportInfo 导入信息
//GInString RegNo^GName^Tel^LinkMan^PostCode^Email^StartDate^EndDate^GReportSend^IReportSend^AsCharged^ChargedMode^AddItem^AddItemLimit^AddItemAmount^Remark^AddMedical^AddMedicalLimit^AddMedicalAmount^Rebate^Address
//TInString  TName^StartDate^EndDate^AddItem^AddItemLimit^AddItemAmount^AddMedical^AddMedicalLimit^AddMedicalAmount^Sex^AgeMax^AgeMin^Married
//IInString TName^RegNo^Name^CardNo^Sex^Age^Birth^Married^MoveTel^Tel^Address^StartDate^EndDate^AsCharged^IReportSend^ChargedMode^AddItem^AddItemLimit^AddItemAmount^AddMedical^AddMedicalLimit^AddMedicalAmount
var StrValue=""
function CheckInfo()
{
	ReadInfoApp("Check");
}
function ReadInfo()
{
	ReadInfoApp("Import");
}
function ReadInfoApp(Type)
{
	var job=session['LOGON.USERID'];
	var obj=document.getElementById("Job");
	if (obj) job=obj.value;
	var xlApp,xlsheet,xlBook;
	var Template,GInString="",TInString="",IInString="";
	var encmeth="",encmethObj,ReturnValue;
	var Flag=1,i=2;
	KillImportGlobal(job);
	try
	{
		/*var OpenFile = new ActiveXObject("MSComDlg.CommonDialog")   
  		OpenFile.Filter="Excel文件|*.xls";
  		OpenFile.MaxFileSize=260;
  		OpenFile.ShowOpen();
  		Template=OpenFile.FileName;
		if (Template=="") return "";*/
		Template="d:\\导入团体模版.xls"
		xlApp = new ActiveXObject("Excel.Application");
		
		xlBook = xlApp.Workbooks.Add(Template);
		//验证个人信息
		xlsheet = xlBook.WorkSheets("人员信息");
		var encmethObj=document.getElementById("CheckIInfo");
		if (encmethObj) encmeth=encmethObj.value;
		i = 2
		xlsheet.Columns(7).NumberFormatLocal="@";
		var GenModel=GetGenModel();
		while (Flag==1)
		{
			var encmethObj=document.getElementById("CheckIInfo");
			if (encmethObj) encmeth=encmethObj.value;
			IInString=""
			
			StrValue=StringIsNull(xlsheet.cells(i,1).Value);
			var RegNo=StrValue
			
			IInString=IInString+"^"+StrValue; //RegNo2
			StrValue=StringIsNull(xlsheet.cells(i,2).Value);
	
			if (StrValue=="") break;

			if (GenModel!="NoGen")
			{
				if (RegNo=="")
				{
					alert('a'+i);
					CloseExcel(xlApp,xlBook,xlsheet)
					return false;
				}
			}
			else
			{
				if (StrValue=="")
				{
					alert('b'+i);
					CloseExcel(xlApp,xlBook,xlsheet)
					return false;
				}	
			}
			
			IInString=IInString+"^"+StrValue; //Name3
			StrValue=StringIsNull(xlsheet.cells(i,3).Value);
			IInString=IInString+"^"+StrValue; //CardNo4
			var Birth=GetBirthByIDCard(StrValue)
			if (Birth!="")
			{
				if (!IsDate(Birth))
				{
					alert("第"+i+"行??身份证录入的生日不对")
					CloseExcel(xlApp,xlBook,xlsheet)
					return false
				}
				
			}
			StrValue=StringIsNull(xlsheet.cells(i,4).Value);
			IInString=IInString+"^"+StrValue; //Sex5
			
			StrValue=StringIsNull(xlsheet.cells(i,5).Value);
			IInString=IInString+"^"+StrValue; //Age6
			if (Birth!=""){StrValue=Birth;}
			else {StrValue=StringIsNull(xlsheet.cells(i,6).Value);}
			IInString=IInString+"^"+StrValue; //Birth7
			StrValue=StringIsNull(xlsheet.cells(i,7).Value);
			IInString=IInString+"^"+StrValue; //Married8
			StrValue=StringIsNull(xlsheet.cells(i,8).Value);
			IInString=IInString+"^"+StrValue; //MoveTel9
			StrValue=StringIsNull(xlsheet.cells(i,9).Value);
			IInString=IInString+"^"+StrValue; //Tel10
			
			StrValue=StringIsNull(xlsheet.cells(i,10).Value);
			IInString=IInString+"^"+StrValue; //Address11
			StrValue=StringIsNull(xlsheet.cells(i,11).Value);
			IInString=IInString+"^"+StrValue; //StartDate12
			StrValue=StringIsNull(xlsheet.cells(i,12).Value);
			IInString=IInString+"^"+StrValue; //EndDate13
			StrValue=StringIsNull(xlsheet.cells(i,13).Value);
			IInString=IInString+"^"+StrValue; //AsCharged14
			StrValue=StringIsNull(xlsheet.cells(i,14).Value);
			IInString=IInString+"^"+StrValue; //IReportSend15
			
			StrValue=StringIsNull(xlsheet.cells(i,15).Value);
			IInString=IInString+"^"+StrValue; //ChargedMode16
			StrValue=StringIsNull(xlsheet.cells(i,16).Value);
			IInString=IInString+"^"+StrValue; //AddItem17
			StrValue=StringIsNull(xlsheet.cells(i,17).Value);
			IInString=IInString+"^"+StrValue; //AddItemLimit18
			StrValue=StringIsNull(xlsheet.cells(i,18).Value);
			IInString=IInString+"^"+StrValue; //AddItemAmount19
			StrValue=StringIsNull(xlsheet.cells(i,19).Value);
			IInString=IInString+"^"+StrValue; //AddMedical20
		
			StrValue=StringIsNull(xlsheet.cells(i,20).Value);
			IInString=IInString+"^"+StrValue; //AddMedicalLimit21
			StrValue=StringIsNull(xlsheet.cells(i,21).Value);
			IInString=IInString+"^"+StrValue; //AddMedicalAmount22
			StrValue=StringIsNull(xlsheet.cells(i,22).Value);
			IInString=IInString+"^"+StrValue; //工作单位23
			StrValue=StringIsNull(xlsheet.cells(i,23).Value);
			IInString=IInString+"^"+StrValue; //民族24
			StrValue=StringIsNull(xlsheet.cells(i,24).Value);
			IInString=IInString+"^"+StrValue; //新发卡25
			StrValue=StringIsNull(xlsheet.cells(i,25).Value);
			IInString=IInString+"^"+StrValue; //职业26
			StrValue=StringIsNull(xlsheet.cells(i,26).Value);
			IInString=IInString+"^"+StrValue; //类型
			StrValue=StringIsNull(xlsheet.cells(i,27).Value);
			IInString=IInString+"^"+StrValue; //健康区域
			StrValue=StringIsNull(xlsheet.cells(i,28).Value);
			IInString=IInString+"^"+StrValue; //就诊卡号
			StrValue=StringIsNull(xlsheet.cells(i,29).Value);
			IInString=IInString+"^"+StrValue; //VIPLevel
		    StrValue=StringIsNull(xlsheet.cells(i,30).Value);
			IInString=IInString+"^"+StrValue;	//TeamLEVEL
	       var obj=document.getElementById("PGADM_RowId");
		   if (obj) PGADMRowId=obj.value;
		   alert(IInString)
		   alert(Type)
		   alert(job)
		   alert(PGADMRowId)
		   ReturnValue=cspRunServerMethod(encmeth,IInString,Type,"","",job,PGADMRowId);
			if (ReturnValue!=0)
			{
				if (Type=="Import")
				{
					alert("个人第"+i+"行,"+ReturnValue);
					CloseExcel(xlApp,xlBook,xlsheet)
					return "";
				}
				var RetArr=ReturnValue.split("&");
				xlsheet.cells(i,31).Value=StringIsNull(xlsheet.cells(i,31).Value)+RetArr[0];
				xlsheet.cells(i,32).Value=StringIsNull(xlsheet.cells(i,32).Value)+RetArr[1];
			}
			
		i = i+1
		}
		if (Type=="Check")
		{
			xlBook.saveas("d:\\导入团体模版BAK.xls");
		}
		//xlsheet.printout	    
		CloseExcel(xlApp,xlBook,xlsheet)
		if (Type=="Check")
		{
			alert("验证完毕")	
			return "";
		}
		var encmethObj=document.getElementById("ImportInfo");
		if (encmethObj) encmeth=encmethObj.value;
		var Return=ImportInfo(encmeth,job);
		var lnk="dhcpepregadm.edit.csp?"
		//var lnk="DHCPEPreGADM.Edit.csp?"
			+"ParRef="+Return
			+"&ParRefName="
			+"&OperType="+"E"
			;
		//parent.location.href=lnk;
		
		return Return;
	}
	catch(e)
	{
		alert(e+"^"+e.message);
	}
}
//导入团体信息
function ImportInfo(encmeth,job)
{
	var Return=cspRunServerMethod(encmeth,job);
	var ReturnStr=Return.split("^");
	alert("ReturnStr1:"+ReturnStr)
	var Flag=ReturnStr[0];
	if (Flag!=0)
	{
		if (Flag=="-119") Flag="团体名称重复";
		alert("导入团体信息不成功.Error:"+Flag);
	}
	else
	{
		alert("导入团体信息成功");
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
function StringIsNull(String)
{
	if (String==null) return ""
	return String
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
		}
		else
		{
			var D = new Date(a[3]+"/"+a[4]+"/"+a[5]);
			var B = D.getFullYear()==a[3]&&(D.getMonth()+1)==a[4]&&D.getDate()==a[5];
		}
		if (!B)
		{
			//alert("输入的身份证号 "+ a[0] +" 里出生日期不对?");
			//websys_setfocus("IDCard"); //DGV2DGV2
			return "";
		}
		if (a[3].length==2) a[3]="19"+a[3];
		var Str=a[3]+"-"+a[4]+"-"+a[5];
		return Str;
		
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
	var encmethObj;
	var encmeth;
	encmethObj=document.getElementById("KillImportGlobal");
	if (encmethObj) encmeth=encmethObj.value;
	var ReturnValue=cspRunServerMethod(encmeth,job);
	return ReturnValue;
}
function GetGenModel()
{
	var obj;
	var GenModel="Gen";
	obj=document.getElementById("IBIUpdateModel");
	if (obj) GenModel=obj.value;
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