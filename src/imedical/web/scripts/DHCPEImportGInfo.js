//DHCPEImportGInfo.js    ����������Ϣ
//ReadInfo   ��֤��Ϣ����ȷ��
//ImportInfo ������Ϣ
//GInString RegNo^GName^Tel^LinkMan^PostCode^Email^StartDate^EndDate^GReportSend^IReportSend^AsCharged^ChargedMode^AddItem^AddItemLimit^AddItemAmount^Remark^AddMedical^AddMedicalLimit^AddMedicalAmount^Rebate^Address
//TInString  TName^StartDate^EndDate^AddItem^AddItemLimit^AddItemAmount^AddMedical^AddMedicalLimit^AddMedicalAmount^Sex^AgeMax^AgeMin^Married
//IInString TName^RegNo^Name^CardNo^Sex^Age^Birth^Married^MoveTel^Tel^Address^StartDate^EndDate^AsCharged^IReportSend^ChargedMode^AddItem^AddItemLimit^AddItemAmount^AddMedical^AddMedicalLimit^AddMedicalAmount
document.write('<input type= "file" id= "File" style= "display:none">');

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
	var GID="";
	var obj=document.getElementById("ID");
	if (obj) GID=obj.value;
	if (GID==""){
		alert("��û��ԤԼ������Ϣ!")
		return false;
	} 
	var obj=document.getElementById("Desc");
	if (obj) var Desc=obj.value;
	
	var AllowCF="0";
	var obj=document.getElementById("AllowCF");
	if (obj&&obj.checked) AllowCF="1";
	
	KillImportGlobal(job);
	try
	{
		var Template="";
		var obj=document.getElementById("File")
		if (obj)
		{
			obj.click(); 
			Template=obj.value;
			obj.outerHTML=obj.outerHTML; //���ѡ���ļ�����
		}
		if (Template=="") return false;
		var extend = Template.substring(Template.lastIndexOf(".")+1);
		if(!(extend=="xls"||extend=="xlsx")){
			alert("��ѡ��xls�ļ�")
			return false;
		}    
		//Template="d:\\��������ģ��.xls"
		xlApp = new ActiveXObject("Excel.Application");
		
		xlBook = xlApp.Workbooks.Add(Template);
		
		//��֤������Ϣ
		xlsheet = xlBook.WorkSheets("��Ա��Ϣ");
		xlsheet1 = xlBook.WorkSheets("Sheet1");
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
			
			StrValue=StringIsNull(xlsheet.cells(i,2).Value);
			var RegNo=StrValue
			IInString=IInString+"^"+StrValue; //RegNo2
			StrValue=StringIsNull(xlsheet.cells(i,3).Value);
			if (StrValue=="") break;
			IInString=IInString+"^"+StrValue; //Name3
			//�������֤һЩ�������
			StrValue=StringIsNull(xlsheet.cells(i,4).Value);
			StrValue=ReplaceStr(StrValue,"'","");
			StrValue=ReplaceStr(StrValue,String.fromCharCode(10),"");
			StrValue=ReplaceStr(StrValue,String.fromCharCode(13),"")
			IInString=IInString+"^"+StrValue; //���֤��
			var Birth=GetBirthByIDCard(StrValue);
			var Sex="";
			var Arr=Birth.split("^");
			Birth=Arr[0];
			if (Birth!="")
			{
				 
				if (!IsDate(Birth))
				{  
					xlsheet.cells(i,34).Value=StringIsNull(xlsheet.cells(i,34).Value)+"���֤¼������ղ���";
					xlsheet.Rows(i).Copy;
				
					xlsheet1.Rows(2).Insert;
					i = i+1
					continue;
	
				}
				Sex=Arr[1];
			}
			
			StrValue=StringIsNull(xlsheet.cells(i,5).Value);
			if ((Sex!="")&&(StrValue!="")&&(StrValue!=Sex))
			{
				xlsheet.cells(i,34).Value=StringIsNull(xlsheet.cells(i,34).Value)+"���֤�е��Ա��ģ��¼����Ա�һ��";
				xlsheet.Rows(i).Copy;
				
				xlsheet1.Rows(2).Insert;
				i = i+1
				continue;
			}
			if (Sex!="") StrValue=Sex;
			IInString=IInString+"^"+StrValue; //Sex5
	
			StrValue=StringIsNull(xlsheet.cells(i,6).Value);
			IInString=IInString+"^"+StrValue; //Age6
			if (Birth!=""){StrValue=Birth;}
			else {StrValue=StringIsNull(xlsheet.cells(i,7).Value);}
			
			if (StrValue!="")
			{
				if (!IsDate(StrValue))
				{ 
					xlsheet.cells(i,34).Value=StringIsNull(xlsheet.cells(i,34).Value)+"���ղ���ȷ";
					xlsheet.Rows(i).Copy;
				
					xlsheet1.Rows(2).Insert;
					i = i+1
					continue;
				}
				
			}
			IInString=IInString+"^"+StrValue; //Birth7
			StrValue=StringIsNull(xlsheet.cells(i,8).Value);
			if (StrValue=="") StrValue="�ѻ�";


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
			IInString=IInString+"^"+StrValue; //������λ23
			StrValue=StringIsNull(xlsheet.cells(i,24).Value);
			StrValue=tkMakeServerCall("web.DHCPE.PreCommon","GetNationDR",StrValue)
			IInString=IInString+"^"+StrValue; //����24
			StrValue=StringIsNull(xlsheet.cells(i,25).Value);
			IInString=IInString+"^"+StrValue; //�·���25
			StrValue=StringIsNull(xlsheet.cells(i,26).Value);
			IInString=IInString+"^"+StrValue; //��λ26
			StrValue=StringIsNull(xlsheet.cells(i,27).Value);
			IInString=IInString+"^"+StrValue; //����
			StrValue=StringIsNull(xlsheet.cells(i,28).Value);
			IInString=IInString+"^"+StrValue; //��������
			StrValue=StringIsNull(xlsheet.cells(i,29).Value);
			IInString=IInString+"^"+StrValue; //���￨��
			StrValue=StringIsNull(xlsheet.cells(i,30).Value);
			IInString=IInString+"^"+StrValue; //VIPLevel
			StrValue=StringIsNull(xlsheet.cells(i,31).Value);
			IInString=IInString+"^"+StrValue; //����
			StrValue=StringIsNull(xlsheet.cells(i,32).Value);
			IInString=IInString+"^"+StrValue; //������
			StrValue=StringIsNull(xlsheet.cells(i,33).Value);
			IInString=IInString+"^"+StrValue; //ְ��
			
			StrValue=StringIsNull(xlsheet.cells(i,34).Value);
			IInString=IInString+"^"+StrValue; //����  
			StrValue=StringIsNull(xlsheet.cells(i,35).Value);
			IInString=IInString+"^"+StrValue; //�Ӻ�����

			ReturnValue=cspRunServerMethod(encmeth,GID,IInString,Type,job,Desc,AllowCF);
			
			
			if (ReturnValue!=0)
			{
				
				var RetArr=ReturnValue.split("&");

				//xlsheet.cells(i,34).Value=StringIsNull(xlsheet.cells(i,34).Value)+RetArr[0];
				//xlsheet.cells(i,35).Value=StringIsNull(xlsheet.cells(i,35).Value)+RetArr[1];
				xlsheet.cells(i,37).Value=StringIsNull(xlsheet.cells(i,37).Value)+RetArr[0];
				xlsheet.cells(i,38).Value=StringIsNull(xlsheet.cells(i,38).Value)+RetArr[1];
				xlsheet.Rows(i).Copy;
				
				xlsheet1.Rows(2).Insert;
				i = i+1
				continue;
			}
			i = i+1
		}
		if (Type=="Import")
		{
			//alert(Template)
			//xlBook.saveas("d:\\��������ģ��BAK.xls");
			xlBook.SaveCopyAs(Template);
		}
		    
		CloseExcel(xlApp,xlBook,xlsheet)
		if (Type=="Check")
		{
			KillImportGlobal(job);
			alert("��֤���")	
			return "";
		}
		var encmethObj=document.getElementById("ImportInfo");
		if (encmethObj) encmeth=encmethObj.value;
		var Return=ImportInfo(encmeth,GID,job);
		var lnk="dhcpepregadm.edit.csp?"
			+"ParRef="+Return
			+"&ParRefName="
			+"&OperType="+"E"
			;
		parent.location.href=lnk;
		
		return Return;
	}
	catch(e)
	{
		alert(e+"^"+e.message);
	}
}
//����������Ϣ
function ImportInfo(encmeth,GID,job)
{
	var Return=cspRunServerMethod(encmeth,GID,job);
	var ReturnStr=Return.split("^");
	var Flag=ReturnStr[0];
	if (Flag!=0)
	{
		if (Flag=="-119") Flag="���������ظ�";
		alert("����������Ϣ���ɹ�.Error:"+Flag);
	}
	else
	{
		alert("����������Ϣ�ɹ�,����������"+ReturnStr[3]+"��"+ReturnStr[2]);
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
