//收费时像小的显示屏发送信息  DHCPECashierEx.js
//找零
function RunSingPaidAmt()
{
	
   var obj=document.getElementById("Change");
   var Changemoney=obj.value;
   if (Changemoney==" ") {Changemoney=""}
   var SingStr="03"
   WriteTextIni(SingStr,Changemoney)
   Run()    	
}
//收费
function RunSingReceiveAmt()
{
	var obj=document.getElementById("Amount");
   var Actualmoney=obj.value;
   if (Actualmoney==" ") {Actualmoney=""}
   if ((Actualmoney=="")||(Actualmoney==0)) return;
   var SingStr="01"
   	   
   WriteTextIni(SingStr,Actualmoney)
   Run()    	
}
function Run()   
{
	var strPath="D:\\SEND\\send.exe";
   try      
   {      
    var objShell = new ActiveXObject("wscript.shell");      
    objShell.Run(strPath);      
    objShell = null;      
   }      
   catch(e)   
   {   
        //alert('找不到文件"'+strPath+'"(或它的组件之一)。请确定路径和文件名是否正确.')      
   }      
}
function WriteTextIni(SingStr,myFootSum)
{
	var strPath1="D:\\SEND\\data.ini";
	try      
   { 
   fso = new ActiveXObject("Scripting.FileSystemObject");
   
  
   tf = fso.CreateTextFile(strPath1, true);  
   
   tf.WriteLine("[settings]");
   tf.WriteLine("commport=1");   
   
   tf.WriteLine("name=顾客您好");
   var ReadStr="charge="+myFootSum   
   tf.WriteLine(ReadStr);
   tf.WriteLine("sound="+SingStr);
   tf.WriteLine("language=2");
   tf.Close();
   }      
   catch(e)   
   {   
        //alert('文件不存在')      
   }      
} 