 
function PrintSelSYCARDLS(){
	PrintSelSYCARD("^NORM^OM^ONE^OUT^STAT^PRN^");
}
function PrintSelSYCARD(PrintType)
 {
	myData=$("#execTable").dhccTableM("getSelections");
	//resStr=QueryPrintData();
	//if(myData.length<=0){
	//	alert("没有打印数据");
	//	return;
	//}
	//if (resStr!="0"){alert(resStr); return;}   
	var Bar= new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN 
	alert(Bar);
	var i,j;
    j=0
    for (i=0;i<myData.length;i++)
    {
	   var oeori=myData[i].oeoriId;
	   var oecprCode=GetOrdPrior(oeori);    //得到医嘱(长期，临时，即可)
	   //if (PrintType.indexOf("^"+oecprCode+"^")<0) continue;   //
	   switch (oecprCode) {  
			case "S": sytyp="长期"; break;
			case "OMST": sytyp="长期"; break;
			case "NORM": sytyp="临时"; break;
			case "OM": sytyp="临时"; break;
			case "ONE": sytyp="取药"; break;
			case "OUT": sytyp="带药"; break;
			case "STAT": sytyp="即刻"; break;
			case "PRN": sytyp="PRN"; break;
			default:  sytyp=""; break;
	   } 
	   var ret = MyRunClassMethod("web.DHCLCNUREXCUTE","SyCard",{"oeorid":oeori});
	   if (ret=="") continue;
	   var syd=ret.split("@");
	   for(j=0;j<syd.length;j++)
	   {
		 if (syd[j]!="")
		 {
			retStr=1
			var tem=syd[j].split("^");
			Bar.Ord=tem[0];
			Bar.PatLoc=tem[5];
			Bar.PatName=tem[1];
			Bar.BedCode=tem[2];
			Bar.PhFactor=tem[0].split("!")[0].split("|")[4];
			Bar.SYTYP = sytyp;
			Bar.SYCWIDTH =3500;
			Bar.SYDHEIGHT =3910;
			Bar.GridWidth=3000;
			Bar.PrintSYCARD();
		  }
	   }
   }
   if(retStr==0)
   {
	   alert("没有打印数据?");
	   return
	}
   Bar.NewPage();
   Bar.EndDoc();
   Bar=null;
 }
 
function QueryPrintData()
{

    
    var gap="",rows=0,printFlag;
    
    var tmpList=new Array();   
    var patList=new Array();
    var retStr=""
   
    var TmpNum = MyRunClassMethod("web.DHCLCNUREXCUTE","GetTmpDataNum",{"user":LgUserID});
    var tem=new Array();
    var temstr,disposeStatCode;
    for (j=1;j<=TmpNum;j++)
    {
	var itemData=MyRunClassMethod("web.DHCLCNUREXCUTE","GetTmpData",{"user":LgUserID,"num":j});   //GetTmpData(user, num)  web.DHCLCNUREXCUTE.GetTmpData
	tmpList=(itemData).split("!");
	disposeStatCode=tmpList[tmpList.length-2];
  	if ((disposeStatCode=="Discontinue")||(disposeStatCode=="ExecDiscon")) continue;
		temstr=tmpList[tmpList.length-4]+"!"+tmpList[tmpList.length-1]
		tem=temstr.split("!");
		//if(tem[1]!="Y")               //WKZ add 070921
		if(tem[1].indexOf("Y")<0)       //WKZ add 070921
		{
			rows=rows+1
			myData[rows-1]=tem
		}
	}
	if (TmpNum!=0)
	{retStr=0;}
    return retStr;
}


function GetOrdPrior(ordId)
{
	var str="";
	str = MyRunClassMethod("web.DHCLCNUREXCUTE","GetOrdPrior",{"oeorid":ordId});  //判断医嘱是什么类型
	return str;	
}


///这个方法是直接运行后将结果返回
function MyRunClassMethod(ClassName,MethodName,Datas){
   Datas=Datas||{};
   var RtnStr = "";
   runClassMethod(ClassName,MethodName,
   Datas,
   function (data){
	  	RtnStr=data;
	  },
	"text",false
	);
	return RtnStr;
}
