var TopFrame=parent.frames['dhcpha.seekpharetreqitmtoret'];
function BodyLoadHandler()
{
	
}

function SelectRowHandler()
 {
	 var row=DHCWeb_GetRowIdx(window);
     Find();
	
 }
function Find()
 {
	ReqStr=getCheckedRegnos();

    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.seekpharetreqitmtoret&RetReqNo="+ReqStr	
	parent.frames['dhcpha.seekpharetreqitmtoret'].location.href=lnk;
 }
 
function getCheckedRegnos()
{
	 var ReqStr="";
     var objtbl=document.getElementById("t"+"dhcpha_seekpharetrequestno")
     if (objtbl){rowcnt=getRowcount(objtbl) }
     	
     if (rowcnt>0)
     {  
	     
		  for (i=1;i<=rowcnt;i++)
		  {
			  var objsel=document.getElementById("TSel"+"z"+i)
			  if (objsel)
			  {
				  if(objsel.checked==true)
				  {
			         
					  var objitem=document.getElementById("TReqNoz"+i) ;
					  retReqNo=objitem.innerText;
					  var treqitm=TopFrame.document.getElementById("Tretrqrowidz"+1)
					  if (treqitm){
					  	var checkward=tkMakeServerCall("web.DHCSTRETREQUEST","CompareWardByReq",retReqNo,treqitm.value)
					  	if(checkward==0){
							alert("��ѡ����ͬ����������ҩ!")
							document.getElementById("TSel"+"z"+i).checked=false;
							continue;  
						}
					  }
					  if (ReqStr=="")
					  {ReqStr=retReqNo}
					  else
					  {ReqStr=ReqStr+"^"+retReqNo}
					  
				  }
			  }
		  }
     }
     	
	if (ReqStr=="") 
	{
		//var row=DHCWeb_GetRowIdx(window); yunhaibao20161018,ͳһ��ѡ�����ϸ
		//var objRetReqNo=document.getElementById("TReqNoz"+row) ;
		//ReqStr=objRetReqNo.innerText;
	}
	
    return ReqStr;
} 
 
document.body.onload=BodyLoadHandler;