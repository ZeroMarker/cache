//�շ�ʱ��С����ʾ��������Ϣ  DHCPECashierEx.js
//����
function RunSingPaidAmt()
{
	
   var obj=document.getElementById("Change");
   var Changemoney=obj.value;
   if (Changemoney==" ") {Changemoney=""}
   var SingStr="03"
   WriteTextIni(SingStr,Changemoney)
   Run()    	
}
//�շ�
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
        //alert('�Ҳ����ļ�"'+strPath+'"(���������֮һ)����ȷ��·�����ļ����Ƿ���ȷ.')      
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
   
   tf.WriteLine("name=�˿�����");
   var ReadStr="charge="+myFootSum   
   tf.WriteLine(ReadStr);
   tf.WriteLine("sound="+SingStr);
   tf.WriteLine("language=2");
   tf.Close();
   }      
   catch(e)   
   {   
        //alert('�ļ�������')      
   }      
} 