//当前表头id
var GetCurrHeadDR=tkMakeServerCall("Nur.DHCNurRecHeadChangeRec","getcurrrow",EpisodeID,session['LOGON.USERID'],EmrCode);
//打印的表头标题
var HeadParr=EmrCode+"^"+session['LOGON.CTLOCID']+"^"+EpisodeID+"^"+session['LOGON.USERID'];
var GetLableRecHead=tkMakeServerCall("Nur.DHCNurChangeLableRec","GetLableRec",HeadParr);

var GetPGDId=tkMakeServerCall("Nur.DHCMoudData","GetId",EmrCode,EpisodeID);
if(NurRecId!=="") GetPGDId=NurRecId;
var WebUrl=WebIp+"/imedical/web/DWR.DoctorRound.cls";




//评估单打印
function butPGDPrintFn(ItmName)
{
	if(ItmName=="") return;
	
	//是否生成图片 Y 生成，N 不生成
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeTemp",EmrCode,"N");
	//是否生成图片 Y 生成，N 不生成
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakePic",EmrCode,"N");
	//是否开始生成图片
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","StartMakePic",EmrCode,"N");
	//生成的图片是否上传ftp
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","IfUpload",EmrCode,"N");
	//是否生成所有页 ，默认是否(从原来最后一页开始生成)；"Y"--从第一页开始生成
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeAllPages",EmrCode,"N");
	
	var GetPGDId=tkMakeServerCall("Nur.DHCMoudData","GetId",EmrCode,EpisodeID);
	if(NurRecId!=="") GetPGDId=NurRecId;
	var parr="@"+EpisodeID+"@"+EmrCode;
	var EmrType=3;  //1:混合单 2：记录单 3：评估单
	//var MthArr="web.DHCNurMouldDataComm:GetPrnValComm&parr:"+parr;
	var MthArr="Nur.DHCMoudData:getVal$parr:"+GetPGDId+"!";	
	var link=WebIp+"/dhcmg/PrintComm/PrintCommPic.application?method=PrintOut&EpisodeID="+EpisodeID+"&EmrCode="+EmrCode+"&EmrType="+EmrType+"&ItmName="+ItmName+"&MthArr="+MthArr+"&WebUrl="+WebUrl;
	window.location.href=link;
}
//不良事件上报
function butPGDPrintFnSB(ItmName,EpisodeID2,EmrCode2,NurRecId2)
{
	//alert(ItmName+"^"+EpisodeID2+"^"+EmrCode2+"^"+NurRecId2)
	if(ItmName=="") return;
	
	//是否生成图片 Y 生成，N 不生成
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeTemp",EmrCode2,"N");
	//是否生成图片 Y 生成，N 不生成
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakePic",EmrCode2,"N");
	//是否开始生成图片
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","StartMakePic",EmrCode2,"N");
	//生成的图片是否上传ftp
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","IfUpload",EmrCode2,"N");
	//是否生成所有页 ，默认是否(从原来最后一页开始生成)；"Y"--从第一页开始生成
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeAllPages",EmrCode2,"N");
	
	var parr="@"+EpisodeID2+"@"+EmrCode2;
	var EmrType=3;  //1:混合单 2：记录单 3：评估单
	var MthArr="Nur.DHCNurSBData:getVal2$parr:"+NurRecId2+"!";	
	var link=WebIp+"/dhcmg/PrintComm/PrintCommPic.application?method=PrintOut&EpisodeID="+EpisodeID2+"&EmrCode="+EmrCode2+"&EmrType="+EmrType+"&ItmName="+ItmName+"&MthArr="+MthArr+"&WebUrl="+WebUrl;
	window.location.href=link;
}
//评估单生成图片
 function MakePicturePGd(prncode)
 {
    if(prncode=="") return;
	var GetPGDId=tkMakeServerCall("Nur.DHCMoudData","GetId",EmrCode,EpisodeID);
	if(GetPGDId)
	{   
		var MthArr="Nur.DHCMoudData:getVal$parr:"+GetPGDId+"!";	
		//是否生成图片 Y 生成，N 不生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeTemp",EmrCode,"Y");
		//是否生成图片 Y 生成，N 不生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakePic",EmrCode,"Y");
		//是否开始生成图片
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","StartMakePic",EmrCode,"Y");
		//生成的图片是否上传ftp
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","IfUpload",EmrCode,"Y");
		//是否生成所有页 ，默认是否(从原来最后一页开始生成)；"Y"--从第一页开始生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeAllPages",EmrCode,"Y");
		var EmrType=3; 
		var link=WebIp+"/dhcmg/PrintComm/PrintCommPic.application?method=PrintOut&EpisodeID="+EpisodeID+"&EmrCode="+EmrCode+"&EmrType="+EmrType+"&ItmName="+prncode+"&MthArr="+MthArr+"&WebUrl="+WebUrl;
		window.location.href=link;
		
		var link=WebIp+"/dhcmg/PrintComm/PrintCommPic.application?method=MakePicture&EpisodeID="+EpisodeID+"&EmrCode="+EmrCode+"&EmrType="+EmrType+"&ItmName="+prncode+"&MthArr="+MthArr+"&WebUrl="+WebUrl;
		window.location.href=link;
	}
  } 
//护理记录单打印
function printNurCareRec(prncode)
{
	    if(prncode=="") return;
		if(!CurrHeadDr) var CurrHeadDr="";
		var page=tkMakeServerCall("NurEmr.webheadchange","getheadpagerow",EpisodeID,EmrCode,"",CurrHeadDr,"","")  			//计算当期表头起始页码		
		if (page=="") page=0
		var zkflag=0; 	
		if (zkflag=="1") //转科
		{
		   var PrnLoc=patloc ;  //转科打印时设置床号 如果没更新转科这句屏蔽
		}
		else
		{
		  var PrnLoc=session['LOGON.CTLOCID']; 
		}
		var GetLableRec=document.getElementById('GetLableRec');
		var LabHead=cspRunServerMethod(GetLableRec.value,EmrCode+"^"+session['LOGON.CTLOCID']+"^"+EpisodeID+"^"+session['LOGON.USERID']);
		LabHead=LabHead.replace(/&/g,"$");
		//alert(LabHead)
		var stdate=""
		var stim="" 
		var edate="" 
		var etim=""
		//是否启用转科开关，默认不启用：1 启用；0 不启用		
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","tranflag",EmrCode,zkflag);
		//续打开关，默认不许打-- 0：不续打；1:启用续打功能
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","xuflag",EmrCode,"0");
		//打印起始页的页码
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","curPages",EmrCode,page);
		//转科打印时是否换页立即换页，默认换页 ---1 换页  0 不换页
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","SplitPage",EmrCode,"0");
		//打印内容线条类型，默认是一条记录打印一直线：1 一条记录一条线；0 一行文字打印一条线 
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","dxflag",EmrCode,"1");
		//预览打印 设置起始页和打印机 0 不弹出 1 弹出
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","previewPrint",EmrCode,"1");
		//外框打印，Y--打印所有，其他--按内容行高打印
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","AllLine",EmrCode,"Y");
		//是否生成打印记录
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","Makeprintinfo",EmrCode,"Y");
		//是否生成奇偶打印记录
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeInfo",EmrCode,"N");
		//是否预览
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","PreView",EmrCode,"1");
		
		//是否生成图片 Y 生成，N 不生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeTemp",EmrCode,"N");
		//是否生成图片 Y 生成，N 不生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakePic",EmrCode,"N");
		//是否开始生成图片
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","StartMakePic",EmrCode,"N");
		//生成的图片是否上传ftp
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","IfUpload",EmrCode,"N");
		//是否生成所有页 ，默认是否(从原来最后一页开始生成)；"Y"--从第一页开始生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeAllPages",EmrCode,"N");
		
		//默认不启用CA打印 1：启用；0：不启用		
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","CAStart",EmrCode,"0");
		//科室是否启用CA--0 不启用；1 启用
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","IsVerifyCALoc",EmrCode,"0");
		var EmrType=2;  //1:混合单 2：记录单 3：评估单
		var parr=EpisodeID+"!"+stdate+"!"+stim+"!"+edate+"!"+etim+"!"+EmrCode+"!"+CurrHeadDr;
		//alert(parr)	
		var link=WebIp+"/dhcmg/PrintComm/PrintCommPic.application?method=PrintOut&EpisodeID="+EpisodeID+"&EmrCode="+EmrCode+"&EmrType="+EmrType+"&ItmName="+prncode+"&Parrm="+parr+"&PrnLoc="+PrnLoc+"&PrnBed="+bedCode+"&LabHead="+LabHead+"&curhead="+CurrHeadDr+"&WebUrl="+WebUrl;
		//alert(link)
		window.location.href=link;		
}
//护理记录单续打
function printNurCareRecXu(prncode)
{
	    if(prncode=="") return;
		var zkflag=0; 	
		if (zkflag=="1") //转科
		{
		   var PrnLoc=patloc ;  //转科打印时设置床号 如果没更新转科这句屏蔽
		}
		else
		{
		  var PrnLoc=session['LOGON.CTLOCID']; 
		}
		var GetLableRec=document.getElementById('GetLableRec');
		var LabHead=cspRunServerMethod(GetLableRec.value,EmrCode+"^"+session['LOGON.CTLOCID']+"^"+EpisodeID+"^"+session['LOGON.USERID']);
		LabHead=LabHead.replace(/&/g,"$");
		//alert(LabHead)
		var stdate=""
		var stim="" 
		var edate="" 
		var etim=""
		//是否启用转科开关，默认不启用：1 启用；0 不启用		
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","tranflag",EmrCode,zkflag);
		//续打开关，默认不许打-- 0：不续打；1:启用续打功能
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","xuflag",EmrCode,"1");
		//打印起始页的页码
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","curPages",EmrCode,0);
		//转科打印时是否换页立即换页，默认换页 ---1 换页  0 不换页
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","SplitPage",EmrCode,"0");
		//打印内容线条类型，默认是一条记录打印一直线：1 一条记录一条线；0 一行文字打印一条线 
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","dxflag",EmrCode,"1");
		//预览打印 设置起始页和打印机 0 不弹出 1 弹出
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","previewPrint",EmrCode,"0");
		//外框打印，Y--打印所有，其他--按内容行高打印
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","AllLine",EmrCode,"Y");
		//是否生成打印记录
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","Makeprintinfo",EmrCode,"N");
		//是否生成奇偶打印记录
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeInfo",EmrCode,"N");
		//是否预览
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","PreView",EmrCode,"1");
		
		//是否生成图片 Y 生成，N 不生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeTemp",EmrCode,"N");
		//是否生成图片 Y 生成，N 不生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakePic",EmrCode,"N");
		//是否开始生成图片
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","StartMakePic",EmrCode,"N");
		//生成的图片是否上传ftp
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","IfUpload",EmrCode,"N");
		//是否生成所有页 ，默认是否(从原来最后一页开始生成)；"Y"--从第一页开始生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeAllPages",EmrCode,"N");
		var EmrType=2;  //1:混合单 2：记录单 3：评估单
		var parr=EpisodeID+"!"+stdate+"!"+stim+"!"+edate+"!"+etim+"!"+EmrCode+"!"+CurrHeadDr;
		//alert(parr)	
		var link=WebIp+"/dhcmg/PrintComm/PrintCommPic.application?method=PrintOut&EpisodeID="+EpisodeID+"&EmrCode="+EmrCode+"&EmrType="+EmrType+"&ItmName="+prncode+"&Parrm="+parr+"&PrnLoc="+PrnLoc+"&PrnBed="+bedCode+"&LabHead="+LabHead+"&curhead="+CurrHeadDr+"&WebUrl="+WebUrl;
		//alert(link)
		window.location.href=link;
}
//混合单打印
function printNurRecHHD(prncode)
{
	    if(prncode=="") return;
		var zkflag=0; 	
		if (zkflag=="1") //转科
		{
		   var PrnLoc=patloc ;  //转科打印时设置床号 如果没更新转科这句屏蔽
		}
		else
		{
		  var PrnLoc=session['LOGON.CTLOCID']; 
		}
		var GetLableRec=document.getElementById('GetLableRec');
		var LabHead=cspRunServerMethod(GetLableRec.value,EmrCode+"^"+session['LOGON.CTLOCID']+"^"+EpisodeID+"^"+session['LOGON.USERID']);
		LabHead=LabHead.replace(/&/g,"$");
		//alert(LabHead)
		var stdate=""
		var stim="" 
		var edate="" 
		var etim=""
		
		var GetPGDId=tkMakeServerCall("Nur.DHCMoudData","GetId",EmrCode,EpisodeID);
		if(NurRecId!=="") GetPGDId=NurRecId;
		var mth1="Nur.DHCMoudData:getVal$parr:"+GetPGDId+"!";				
		//alert(NurRecId)
		//是否启用转科开关，默认不启用：1 启用；0 不启用		
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","tranflag",EmrCode,zkflag);
		//续打开关，默认不许打-- 0：不续打；1:启用续打功能
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","xuflag",EmrCode,"0");
		//打印起始页的页码
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","curPages",EmrCode,0);
		//转科打印时是否换页立即换页，默认换页 ---1 换页  0 不换页
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","SplitPage",EmrCode,"0");
		//打印内容线条类型，默认是一条记录打印一直线：1 一条记录一条线；0 一行文字打印一条线 
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","dxflag",EmrCode,"1");
		//预览打印 设置起始页和打印机 0 不弹出 1 弹出
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","previewPrint",EmrCode,"1");
		//外框打印，Y--打印所有，其他--按内容行高打印
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","AllLine",EmrCode,"Y");
		//是否生成打印记录
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","Makeprintinfo",EmrCode,"N");
		//是否生成奇偶打印记录
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeInfo",EmrCode,"N");
		//是否预览
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","PreView",EmrCode,"1");
		
		//是否生成图片 Y 生成，N 不生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeTemp",EmrCode,"N");
		//是否生成图片 Y 生成，N 不生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakePic",EmrCode,"N");
		//是否开始生成图片
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","StartMakePic",EmrCode,"N");
		//生成的图片是否上传ftp
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","IfUpload",EmrCode,"N");
		//是否生成所有页 ，默认是否(从原来最后一页开始生成)；"Y"--从第一页开始生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeAllPages",EmrCode,"N");
		
		//默认不启用CA打印 1：启用；0：不启用		
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","CAStart",EmrCode,"0");
		//科室是否启用CA--0 不启用；1 启用
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","IsVerifyCALoc",EmrCode,"0");
		var EmrType=1;  //1:混合单 2：记录单 3：评估单
		var parr=EpisodeID+"!"+stdate+"!"+stim+"!"+edate+"!"+etim+"!"+EmrCode+"!";
		//alert(parr)	
		var link=WebIp+"/dhcmg/PrintComm/PrintCommPic.application?method=PrintOut&EpisodeID="+EpisodeID+"&EmrCode="+EmrCode+"&EmrType="+EmrType+"&ItmName="+prncode+"&Parrm="+parr+"&PrnLoc="+PrnLoc+"&PrnBed="+bedCode+"&LabHead="+LabHead+"&curhead="+"&MthArr="+mth1+"&WebUrl="+WebUrl;
		//alert(link)
		window.location.href=link;	
		
}
//生成打印痕迹
//生成每条记录的痕迹  不含混合单
function makeRechj(prncode)
{
		if(prncode=="") return;
		if(!CurrHeadDr) var CurrHeadDr="";
		var page=tkMakeServerCall("NurEmr.webheadchange","getheadpagerow",EpisodeID,EmrCode,"",CurrHeadDr,"","")  			//计算当期表头起始页码		
		if (page=="") page=0
		var zkflag=0; 	
		if (zkflag=="1") //转科
		{
		   var PrnLoc=patloc ;  //转科打印时设置床号 如果没更新转科这句屏蔽
		}
		else
		{
		  var PrnLoc=session['LOGON.CTLOCID']; 
		}
		var GetLableRec=document.getElementById('GetLableRec');
		var LabHead=cspRunServerMethod(GetLableRec.value,"DHCNURBG_HZHL^"+session['LOGON.CTLOCID']+"^"+EpisodeID+"^"+session['LOGON.USERID']);
		LabHead=LabHead.replace(/&/g,"$");
		var stdate="" //tm[2];
		var stim="" //tm[3];
		var edate="" //tm[4];
		var etim="" //tm[5];
		
		//是否启用转科开关，默认不启用：1 启用；0 不启用		
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","tranflag",EmrCode,zkflag);
		//续打开关，默认不许打-- 0：不续打；1:启用续打功能
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","xuflag",EmrCode,"0");
		//打印起始页的页码
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","curPages",EmrCode,"0");
		//转科打印时是否换页立即换页，默认换页 ---1 换页  0 不换页
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","SplitPage",EmrCode,"1");
		//打印内容线条类型，默认是一条记录打印一直线：1 一条记录一条线；0 一行文字打印一条线 
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","dxflag",EmrCode,"1");
		//预览打印 设置起始页和打印机 0 不弹出 1 弹出
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","previewPrint",EmrCode,"0");
		//外框打印，Y--打印所有，其他--按内容行高打印
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","AllLine",EmrCode,"Y");
		//是否生成打印记录
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","Makeprintinfo",EmrCode,"Y");
		//是否生成奇偶打印记录
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeInfo",EmrCode,"N");
		//是否预览
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","PreView",EmrCode,"1");
		
		//是否生成图片 Y 生成，N 不生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeTemp",EmrCode,"N");
		//是否生成图片 Y 生成，N 不生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakePic",EmrCode,"N");
		//是否开始生成图片
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","StartMakePic",EmrCode,"N");
		//生成的图片是否上传ftp
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","IfUpload",EmrCode,"N");
		//是否生成所有页 ，默认是否(从原来最后一页开始生成)；"Y"--从第一页开始生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeAllPages",EmrCode,"N");
		
		var EmrType=2;  //1:混合单 2：记录单 3：评估单
		var parr=EpisodeID+"!"+stdate+"!"+stim+"!"+edate+"!"+etim+"!"+EmrCode+"!"+CurrHeadDr;
		//alert(parr)	
		var link=WebIp+"/dhcmg/PrintComm/PrintCommPic.application?method=PrintOut&EpisodeID="+EpisodeID+"&EmrCode="+EmrCode+"&EmrType="+EmrType+"&ItmName="+prncode+"&Parrm="+parr+"&PrnLoc="+PrnLoc+"&PrnBed="+bedCode+"&LabHead="+LabHead+"&curhead="+CurrHeadDr+"&WebUrl="+WebUrl;
		//alert(link)
		window.location.href=link;	
			
		setTimeout("find()",5000);	
}
//护理记录单奇偶打印
function printNurCareRecJO(prncode)
{
	  if(prncode=="") return;
	  if(!CurrHeadDr) var CurrHeadDr="";
	  var page=tkMakeServerCall("NurEmr.webheadchange","getheadpagerow",EpisodeID,EmrCode,"",CurrHeadDr,"","")  //计算当期表头起始页码		
	  if (page=="") page=0	   
	  var zkflag=0; 	
		if (zkflag=="1") //转科
		{
		   var PrnLoc=patloc ;  //转科打印时设置床号 如果没更新转科这句屏蔽
		}
		else
		{
		  var PrnLoc=session['LOGON.CTLOCID']; 
		}
		var GetLableRec=document.getElementById('GetLableRec');
		var LabHead=cspRunServerMethod(GetLableRec.value,EmrCode+"^"+session['LOGON.CTLOCID']+"^"+EpisodeID+"^"+session['LOGON.USERID']);
		LabHead=LabHead.replace(/&/g,"$");
		//alert(LabHead)
		var stdate=""
		var stim="" 
		var edate="" 
		var etim=""
		//是否启用转科开关，默认不启用：1 启用；0 不启用		
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","tranflag",EmrCode,zkflag);
		//续打开关，默认不许打-- 0：不续打；1:启用续打功能
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","xuflag",EmrCode,"0");
		//打印起始页的页码
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","curPages",EmrCode,page);
		//转科打印时是否换页立即换页，默认换页 ---1 换页  0 不换页
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","SplitPage",EmrCode,"0");
		//打印内容线条类型，默认是一条记录打印一直线：1 一条记录一条线；0 一行文字打印一条线 
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","dxflag",EmrCode,"1");
		//预览打印 设置起始页和打印机 0 不弹出 1 弹出
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","previewPrint",EmrCode,"1");
		//外框打印，Y--打印所有，其他--按内容行高打印
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","AllLine",EmrCode,"Y");
		//是否生成打印痕迹
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","Makeprintinfo",EmrCode,"N");
		//是否生成奇偶打印痕迹
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeInfo",EmrCode,"Y");
		//是否预览
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","PreView",EmrCode,"1");
		
		//是否生成图片 Y 生成，N 不生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeTemp",EmrCode,"N");
		//是否生成图片 Y 生成，N 不生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakePic",EmrCode,"N");
		//是否开始生成图片
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","StartMakePic",EmrCode,"N");
		//生成的图片是否上传ftp
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","IfUpload",EmrCode,"N");
		//是否生成所有页 ，默认是否(从原来最后一页开始生成)；"Y"--从第一页开始生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeAllPages",EmrCode,"N");
		var EmrType=2;  //1:混合单 2：记录单 3：评估单
		var parr=EpisodeID+"!"+stdate+"!"+stim+"!"+edate+"!"+etim+"!"+EmrCode+"!"+CurrHeadDr;
		//alert(parr)	
		var link=WebIp+"/dhcmg/PrintComm/PrintCommPic.application?method=PrintOut&EpisodeID="+EpisodeID+"&EmrCode="+EmrCode+"&EmrType="+EmrType+"&ItmName="+prncode+"&Parrm="+parr+"&PrnLoc="+PrnLoc+"&PrnBed="+bedCode+"&LabHead="+LabHead+"&curhead="+CurrHeadDr+"&WebUrl="+WebUrl;
		//alert(link)
		window.location.href=link;			
		
		var link=WebIp+"/dhcmg/PrintComm/PrintCommPic.application?method=PrintOutAll&EpisodeID="+EpisodeID+"&EmrCode="+EmrCode+"&EmrType="+EmrType+"&ItmName="+prncode+"&Parrm="+parr+"&PrnLoc="+PrnLoc+"&PrnBed="+bedCode+"&LabHead="+LabHead+"&curhead="+CurrHeadDr+"&WebUrl="+WebUrl;
		//alert(link)
		window.location.href=link;
}
//护理记录单生成图片
//生成图片
function MakeRecPicture(prncode)
{
	if(prncode=="") return;
	if(!CurrHeadDr) var CurrHeadDr="";
	var page=tkMakeServerCall("NurEmr.webheadchange","getheadpagerow",EpisodeID,EmrCode,"",CurrHeadDr,"","")  			//计算当期表头起始页码		
	if (page=="") page=0
	var zkflag=0; 	
	if (zkflag=="1") //转科
	{
		var PrnLoc=patloc ;  //转科打印时设置床号 如果没更新转科这句屏蔽
	}
	else
	{
		var PrnLoc=session['LOGON.CTLOCID']; 
	}
	var GetLableRec=document.getElementById('GetLableRec');
	var LabHead=cspRunServerMethod(GetLableRec.value,EmrCode+"^"+session['LOGON.CTLOCID']+"^"+EpisodeID+"^"+session['LOGON.USERID']);
	LabHead=LabHead.replace(/&/g,"$");
	//alert(LabHead)
	var stdate=""
	var stim="" 
	var edate="" 
	var etim=""
	//是否启用转科开关，默认不启用：1 启用；0 不启用		
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","tranflag",EmrCode,zkflag);
	//续打开关，默认不许打-- 0：不续打；1:启用续打功能
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","xuflag",EmrCode,"0");
	//打印起始页的页码
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","curPages",EmrCode,page);
	//转科打印时是否换页立即换页，默认换页 ---1 换页  0 不换页
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","SplitPage",EmrCode,"0");
	//打印内容线条类型，默认是一条记录打印一直线：1 一条记录一条线；0 一行文字打印一条线 
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","dxflag",EmrCode,"1");
	//预览打印 设置起始页和打印机 0 不弹出 1 弹出
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","previewPrint",EmrCode,"1");
	//外框打印，Y--打印所有，其他--按内容行高打印
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","AllLine",EmrCode,"Y");
	//是否生成打印记录
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","Makeprintinfo",EmrCode,"N");
	//是否生成奇偶打印记录
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeInfo",EmrCode,"N");
	//是否预览
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","PreView",EmrCode,"1");
	var IfMakePicFlag="Y";
	var WillUploadFlag="Y";
	var prnmodes=tkMakeServerCall("User.DHCNURMoudelLink","getPrintCode",EmrCode) //根据界面模板获取打印模板
	if (prnmodes!="")
	{
		var prnarr=prnmode.split('|')
		IfMakePicFlag=prnarr[3]  //是否生成图片
		WillUploadFlag=prnarr[4] //是否上传ftp
	}
	if(IfMakePicFlag!=="Y") return;
	//是否生成图片 Y 生成，N 不生成
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeTemp",EmrCode,IfMakePicFlag);
	//是否生成图片 Y 生成，N 不生成
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakePic",EmrCode,IfMakePicFlag);
	//是否开始生成图片
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","StartMakePic",EmrCode,IfMakePicFlag);
	//生成的图片是否上传ftp
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","IfUpload",EmrCode,WillUploadFlag);
	//是否生成所有页 ，默认是否(从原来最后一页开始生成)；"Y"--从第一页开始生成
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeAllPages",EmrCode,"Y");
	var EmrType=2;  //1:混合单 2：记录单 3：评估单
	var parr=EpisodeID+"!"+stdate+"!"+stim+"!"+edate+"!"+etim+"!"+EmrCode+"!"+CurrHeadDr;
	//alert(parr)	
	var link=WebIp+"/dhcmg/PrintComm/PrintCommPic.application?method=PrintOut&EpisodeID="+EpisodeID+"&EmrCode="+EmrCode+"&EmrType="+EmrType+"&ItmName="+prncode+"&Parrm="+parr+"&PrnLoc="+PrnLoc+"&PrnBed="+bedCode+"&LabHead="+LabHead+"&curhead="+CurrHeadDr+"&WebUrl="+WebUrl;
	window.location.href=link;

	var link=WebIp+"/dhcmg/PrintComm/PrintCommPic.application?method=MakePicture&EpisodeID="+EpisodeID+"&EmrCode="+EmrCode+"&EmrType="+EmrType+"&ItmName="+prncode+"&Parrm="+parr+"&PrnLoc="+PrnLoc+"&PrnBed="+bedCode+"&LabHead="+LabHead+"&curhead="+CurrHeadDr+"&WebUrl="+WebUrl;
	window.location.href=link;	
	
}

//病情变化措施及处理
function RecMeasureNew()
{
	MeasureRel = new Hashtable();
	var grid1=Ext.getCmp('mygrid');
	var objRow=grid1.getSelectionModel().getSelections();
	if (objRow.length == 0) 
	{
	 alert("请先选择一条护理记录!"); 
	 return; 
	}
	var par=grid1.getSelectionModel().getSelections()[0].get("par"); 
	var rw=grid1.getSelectionModel().getSelections()[0].get("rw"); 
	var rowid=par+"||"+rw;
	if (par==undefined)
	{
		rowid="";
	}
	var parr=EmrCode+"^"+EpisodeID+"^CaseMeasureXml^"+rowid;
	tkMakeServerCall("Nur.DHCNurEmrXml","killTempCaseMeasure",session['LOGON.USERID']);
    //var emrknowurl="dhcnuremrknow.csp?EmrCode=DHCNurKnowldge&Parr="+parr+"&EpisodeID="+EpisodeID; 
    var emrknowurl=WebIp+"/dhcmg/KnowLedge/DesignForm.application?method=GetXmlData&EpisodeID="+EpisodeID+"&EmrCode="+"DHCNurKnowldge"+"&Parr="+parr+"&LogLoc="+session['LOGON.CTLOCID']+"&Ward="+session['LOGON.CTLOCID']+"&DepId="+session['LOGON.CTLOCID']+"&webIp="+WebIp+"&logUser="+session['LOGON.USERID']+"&WebUrl="+WebUrl;	
	window.location.href=emrknowurl;
	
	setTimeout("setMval()",5000);
}
function setMval()
{
	var grid1=Ext.getCmp('mygrid');
	var ret="";
	while((ret==""))
	{
		ret=tkMakeServerCall("Nur.DHCNurEmrXml","getTempCaseMeasure",session['LOGON.USERID']);
		if(ret!=-1) 
		{
			var CaseMeasure=grid1.getSelectionModel().getSelections()[0].get("CaseMeasure"); 
			if(ret=="") 
			{
				grid1.getSelectionModel().getSelections()[0].set("CaseMeasure",CaseMeasure);
			}
			else
			{
				grid1.getSelectionModel().getSelections()[0].set("CaseMeasure",ret);
			}
			
		}
	}
	
}


//多次评估单打印
function butMultiPGDPrintFn(ItmName,LinkCode)
{
	if(ItmName=="") return;

	//是否生成图片 Y 生成，N 不生成
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeTemp",EmrCode,"N");
	//是否生成图片 Y 生成，N 不生成
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakePic",EmrCode,"N");
	//是否开始生成图片
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","StartMakePic",EmrCode,"N");
	//生成的图片是否上传ftp
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","IfUpload",EmrCode,"N");
	//是否生成所有页 ，默认是否(从原来最后一页开始生成)；"Y"--从第一页开始生成
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeAllPages",EmrCode,"N");
	
	
	var subId=tkMakeServerCall("Nur.DHCMoudData","getMoudId",EpisodeID,LinkCode);
  	var recId=tkMakeServerCall("Nur.DHCMoudData","getAllLinkSubId",subId,EpisodeID,LinkCode);

	var EmrType=6;  //1:混合单 2：记录单 3：评估单
	var MthArr= "Nur.DHCMoudDataSub:getVal1$parr:" + recId + "!flag:";	
	var link=WebIp+"/dhcmg/PrintComm/PrintCommPic.application?method=PrintOut&EpisodeID="+EpisodeID+"&EmrCode="+EmrCode+"&EmrType="+EmrType+"&ItmName="+ItmName+"&MthArr="+MthArr+"&WebUrl="+WebUrl;
	window.location.href=link;
}

//多次评估单续打
function butMultiPGDPrintFnXu(prncode,linkCode)
{
	if(prncode=="") return;

	var subId=tkMakeServerCall("Nur.DHCMoudData","getMoudId",EpisodeID,linkCode);
	var recId=tkMakeServerCall("Nur.DHCMoudData","getAllLinkSubId",subId,EpisodeID,linkCode); 
	var ifCan=tkMakeServerCall("Nur.DHCNurMultiPgdPrint","IfCanXuPrint",EpisodeID,prncode,recId);
	if(ifCan!=""){
		alert(ifCan)
		return;
	}

	//是否生成图片 Y 生成，N 不生成
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeTemp",EmrCode,"N");
	//是否生成图片 Y 生成，N 不生成
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakePic",EmrCode,"N");
	//是否开始生成图片
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","StartMakePic",EmrCode,"N");
	//生成的图片是否上传ftp
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","IfUpload",EmrCode,"N");
	//是否生成所有页 ，默认是否(从原来最后一页开始生成)；"Y"--从第一页开始生成
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeAllPages",EmrCode,"N");
	//续打开关，默认不许打-- 0：不续打；1:启用续打功能
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","xuflag",EmrCode,"1");
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","PreView",EmrCode,"1");

    var printRecId=tkMakeServerCall("Nur.DHCNurMultiPgdPrint","getPrintRecId",recId,EpisodeID,prncode);//续打转化Id,打印过的转化成none
    var MthArr= "Nur.DHCMoudDataSub:getVal1$parr:" + printRecId + "!flag:";

	var EmrType=6;  //1:混合单 2：记录单 3：评估单
	var link=WebIp+"/dhcmg/PrintComm/PrintCommPic.application?method=PrintOut&EpisodeID="+EpisodeID+"&EmrCode="+EmrCode+"&EmrType="+EmrType+"&ItmName="+prncode+"&MthArr="+MthArr+"&WebUrl="+WebUrl+"&PrintRecId="+recId;
	window.location.href=link;
}
