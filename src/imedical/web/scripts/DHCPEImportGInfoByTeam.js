//DHCPEImportGInfoByTeam.js    根据分组Id导入团体信息 DHCPEPreIADM.Team
//ReadInfo   验证信息的正确性
//ImportInfo 导入信息
//GInString RegNo^GName^Tel^LinkMan^PostCode^Email^StartDate^EndDate^GReportSend^IReportSend^AsCharged^ChargedMode^AddItem^AddItemLimit^AddItemAmount^Remark^AddMedical^AddMedicalLimit^AddMedicalAmount^Rebate^Address
//TInString  TName^StartDate^EndDate^AddItem^AddItemLimit^AddItemAmount^AddMedical^AddMedicalLimit^AddMedicalAmount^Sex^AgeMax^AgeMin^Married
//IInString TName^RegNo^Name^CardNo^Sex^Age^Birth^Married^MoveTel^Tel^Address^StartDate^EndDate^AsCharged^IReportSend^ChargedMode^AddItem^AddItemLimit^AddItemAmount^AddMedical^AddMedicalLimit^AddMedicalAmount
var StrValue=""
function ReadInfo()
{
	var job=session['LOGON.USERID'];
	var obj=document.getElementById("Job");
	if (obj) job=obj.value;
	
	var xlApp,xlsheet,xlBook;
	var Template,GInString="",TInString="",IInString="";
	var encmeth="",encmethObj,ReturnValue;
	var Flag=1,i=2;
	var obj=document.getElementById("PGTeam_DR");
	var TeamID=""
	if (obj) TeamID=obj.value;
	if (TeamID==""){
		alert(t["Err 08"])	
		return;
	}
	var obj=document.getElementById("CGName");
	var TName="人员信息";
	if (obj) TName=obj.innerText;
	KillImportGlobal(job);
	try
	{
		var OpenFile = new ActiveXObject("MSComDlg.CommonDialog")   
  		OpenFile.Filter="Excel文件|*.xls";
  		OpenFile.MaxFileSize=260;
  		OpenFile.ShowOpen();
  		Template=OpenFile.FileName;
		if (Template=="") return "";
		//Template="d:\\导入团体模版Team.xls"
		xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(Template);
		//验证个人信息
		xlsheet = xlBook.WorkSheets(TName);
		var encmethObj=document.getElementById("CheckIInfo");
		if (encmethObj) encmeth=encmethObj.value;
		i = 2
		xlsheet.Columns(7).NumberFormatLocal="@";
		var GenModel=GetGenModel();
		while (Flag=1)
		{
			IInString=""
			StrValue=StringIsNull(xlsheet.cells(i,1).Value);
			IInString=StrValue; //TName1
			if (StrValue=="") break;
			StrValue=StringIsNull(xlsheet.cells(i,2).Value);
			var RegNo=StrValue
			IInString=IInString+"^"+StrValue; //RegNo2
			StrValue=StringIsNull(xlsheet.cells(i,3).Value);
			
			if (GenModel!="NoGen")
			{
				if (RegNo=="")
				{
					alert('a'+i);
					return false;
				}
			}
			else
			{
				if (StrValue=="")
				{
					alert('b'+i);
					return false;
				}	
			}
			
			IInString=IInString+"^"+StrValue; //Name3
			StrValue=StringIsNull(xlsheet.cells(i,4).Value);
			IInString=IInString+"^"+StrValue; //CardNo4
			
			var Birth=GetBirthByIDCard(StrValue)
			
			StrValue=StringIsNull(xlsheet.cells(i,5).Value);
			IInString=IInString+"^"+StrValue; //Sex5
			
			StrValue=StringIsNull(xlsheet.cells(i,6).Value);
			IInString=IInString+"^"+StrValue; //Age6
			if (Birth!=""){StrValue=Birth}
			else {StrValue=StringIsNull(xlsheet.cells(i,7).Value);}
			IInString=IInString+"^"+StrValue; //Birth7
			StrValue=StringIsNull(xlsheet.cells(i,8).Value);
			IInString=IInString+"^"+StrValue; //Married8
			StrValue=StringIsNull(xlsheet.cells(i,9).Value);
			IInString=IInString+"^"+StrValue; //MoveTel9
			StrValue=StringIsNull(xlsheet.cells(i,10).Value);
			IInString=IInString+"^"+StrValue; //Tel10
			
			StrValue=StringIsNull(xlsheet.cells(i,11).Value);
			IInString=IInString+"^"+StrValue; //Address11
			StrValue=StringIsNull(xlsheet.cells(i,12).Value);
			IInString=IInString+"^"+StrValue; //StartDate12
			StrValue=StringIsNull(xlsheet.cells(i,13).Value);
			IInString=IInString+"^"+StrValue; //EndDate13
			StrValue=StringIsNull(xlsheet.cells(i,14).Value);
			IInString=IInString+"^"+StrValue; //AsCharged14
			StrValue=StringIsNull(xlsheet.cells(i,15).Value);
			IInString=IInString+"^"+StrValue; //IReportSend15
			
			StrValue=StringIsNull(xlsheet.cells(i,16).Value);
			IInString=IInString+"^"+StrValue; //ChargedMode16
			StrValue=StringIsNull(xlsheet.cells(i,17).Value);
			IInString=IInString+"^"+StrValue; //AddItem17
			StrValue=StringIsNull(xlsheet.cells(i,18).Value);
			IInString=IInString+"^"+StrValue; //AddItemLimit18
			StrValue=StringIsNull(xlsheet.cells(i,19).Value);
			IInString=IInString+"^"+StrValue; //AddItemAmount19
			StrValue=StringIsNull(xlsheet.cells(i,20).Value);
			IInString=IInString+"^"+StrValue; //AddMedical20
		
			StrValue=StringIsNull(xlsheet.cells(i,21).Value);
			IInString=IInString+"^"+StrValue; //AddMedicalLimit21
			StrValue=StringIsNull(xlsheet.cells(i,22).Value);
			IInString=IInString+"^"+StrValue; //AddMedicalAmount22
			StrValue=StringIsNull(xlsheet.cells(i,23).Value);
			IInString=IInString+"^"+StrValue; //工作单位23
			StrValue=StringIsNull(xlsheet.cells(i,24).Value);
			IInString=IInString+"^"+StrValue; //民族24
			StrValue=StringIsNull(xlsheet.cells(i,25).Value);
			IInString=IInString+"^"+StrValue; //新发卡25
			StrValue=StringIsNull(xlsheet.cells(i,26).Value);
			IInString=IInString+"^"+StrValue; //职业26
			StrValue=StringIsNull(xlsheet.cells(i,27).Value);
			IInString=IInString+"^"+StrValue; //类型
			StrValue=StringIsNull(xlsheet.cells(i,28).Value);
			IInString=IInString+"^"+StrValue; //健康区域
			StrValue=StringIsNull(xlsheet.cells(i,29).Value);
			IInString=IInString+"^"+StrValue; //就诊卡号
			StrValue=StringIsNull(xlsheet.cells(i,30).Value);
			IInString=IInString+"^"+StrValue; //VIPLevel
			ReturnValue=cspRunServerMethod(encmeth,IInString,"Import",TeamID,"TeamId",job);
			
			if (ReturnValue!=0)
			{
				alert("个人第"+i+"行,"+ReturnValue);
				return "";
			}
			i = i+1
		}
		//xlsheet.printout	    
		xlBook.Close (savechanges=false);
		xlApp=null;
		xlsheet=null;
		var encmethObj=document.getElementById("ImportInfo");
		if (encmethObj) encmeth=encmethObj.value;
		
		var Return=ImportInfo(encmeth,TeamID,job);
		if (Return!=0) return;
		location.reload();
		
		return Return;
	}
	catch(e)
	{
		alert(e+"^"+e.message)
	}
}
//导入团体信息
function ImportInfo(encmeth,TeamID,job)
{
	var Return=cspRunServerMethod(encmeth,TeamID,job);
	var ReturnStr=Return.split("^")
	var Flag=ReturnStr[0];
	if (Flag!=0)
	{
		alert("导入团体信息不成功.Error:"+Flag)
	}
	else
	{
		alert("导入团体信息成功");
	}
	return Flag;
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
		var Str=a[3]+"-"+a[4]+"-"+a[5];
		return Str;
		
	}
	return "";
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