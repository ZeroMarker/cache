//DHCPECACommon.js
function PESaveCASign(SignType,ExpStr,Data)
{
	//ExpStr����ǿ����ύ  PAADM%վ��ID
	var IsVerifyCA=tkMakeServerCall("web.DHCPE.CA.Main","GetIsVerifyCA",session['LOGON.CTLOCID']);
	if (IsVerifyCA==1)
   	{
		var ContainerName="";
		var i;
		var strTemp =GetUserList();
		var i=strTemp.indexOf("&&&");
		if (i <= 0) 
		{
			alert("�����Ukey!")
			return false;
		}
		else
		{
			var strOption = strTemp.substring(0,i);
			var strUniqueID = strOption.substring(strOption.indexOf("||") + 2, strOption.length);  //CA KEY
		    var CAid=tkMakeServerCall("CA.UsrSignatureInfo","GetUsrIdByKey",strUniqueID)
		    if (CAid!=session['LOGON.USERID'])
		    {
		    	alert("Key��Ӧ����Ա�����ǵ�ǰ��Ա");
		    	return false;
		    }
		    //ÿ��ǩ������Ҫ����Key��Ӧ�����룬��ע�����沿��
		    /*
		    VerifyUKeySession=0
		    if (VerifyUKeySession==0)
		    { 	 
		    	var result = window.showModalDialog("../csp/dhcpecaaudit.csp", window, "dialogWidth:300px;dialogHeight:250px;center:yes;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;");
				if ((result=="")||(result=="undefined")||(result==null)) 
				{
					alert("û����Чǩ��,�޷������");
					return false;
				}
				ContainerName=result;
			}
			else
			{
				ContainerName=strUniqueID;
			}
			//var GenUKeySession=tkMakeServerCall("web.DHCPE.CA.Main","GenUKeySession",ContainerName);
			*/
			//������沿�ֲ�ע�ͣ��Ͱ�������������ע��
			var ContainerName=session['ContainerName'];
		    var CAInit=tkMakeServerCall("web.DHCPE.CA.Main","CASessionDataInit");
		
		}
   	 	
		if (Data=="") Data=tkMakeServerCall("web.DHCPE.CA.Main","GetSignData",SignType,ExpStr);
		
		return SaveCASign(Data,ContainerName,SignType,ExpStr);
   }
   else{
	   return true;
   }
}
function SaveCASign(Data,ContainerName,SaveType,SourceID)
{
	var RecMainXMLHash=HashData(Data);
	var SignedData=SignedData(RecMainXMLHash,ContainerName);
	var varCert = GetSignCert(SubstrContainerName);		  
	var varCertCode= GetUniqueID(varCert);
	if ((RecMainXMLHash!="")&&(varCert!="")&&(SignedData!=""))
	{
		var ExpStr=SaveType+"^"+session['LOGON.USERID']+"^"+SourceID
		var ret=tkMakeServerCall("web.DHCPE.CA.Main","SaveCASign",RecMainXMLHash,varCertCode,varCert,SignedData,ExpStr);		 
		var Arr=ret.split("^");
		if (Arr[0]!="1")
		{
			alert(Arr[1]);
			return false;
		}else{
			return true;
		}	
	}
	else
	{
		alert("����ǩ������");
	  	return false;
	}
}