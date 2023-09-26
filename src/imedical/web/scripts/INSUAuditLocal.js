//INSUAuditLocal.js
var RegNo

function BodyLoadHandler() {
	Guser=session['LOGON.USERID'];
	getpath();
	obj=document.getElementById("AdmNo");
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;	
	
	}

	var obl=document.getElementById("RegNo");
	if(obl) obl.onkeydown=RegNoKeyDown;
	var obj=document.getElementById("AdmNo");
	if (obj){obj.onchange=selejzh;}	
	var Audit=document.getElementById("Audit") ;
	if (Audit)  Audit.onclick=Audit_Click;
	var ResumeObj=document.getElementById("Resume") ;
	if (ResumeObj)  ResumeObj.onclick=Resume_Click;
	var Refuse=document.getElementById("Refuse") ;
	if (Refuse)  Refuse.onclick=Refuse_Click;
	var obj=document.getElementById("ReadCard");   //add hwq 2010 10 25	
   	if (obj){ obj.onclick=ReadCardClickHandler;	}
	var obj=document.getElementById("PrintBXD");   //add hwq 2010 11 12	
   	if (obj){ obj.onclick=Print_Click;	}
	var objtbl=document.getElementById("tINSUAuditLocal");
    var now= new Date()
    var hour= now.getHours();
	if (objtbl)
	{
		//objtbl.ondblclick=RowChanged;
		for (i=1;i<objtbl.rows.length-1;i++)
		{
			var item=document.getElementById("Selectz"+i);	
			item.checked=true;

			var TabAuditFlag=document.getElementById("TAuditFlagz"+i).innerText;
 			if ((TabAuditFlag==" "))
			{
				item.checked=true;
			}
	var objitem1=document.getElementById("ZFBLz"+i)  //add hwq 2010 12 14 
	var objitem2=document.getElementById("TZFBLz"+i)   //隐藏  后台取出
	var item=document.getElementById("TZFBLz"+i).value;
	objitem1.size=1;
	objitem1.multiple=false;		
			 if (item!=""){
			   var arytxt=item.split("!");
			   var lstlen=objitem1.length;
			   for (j=0;j<arytxt.length;j++){

				 objitem1.options[lstlen] = new Option(arytxt[j],arytxt[j]);
			
				 lstlen++;
			   }
			 }
		}
	}
	
	ReadCardType();
	//DHCC_SetListStyle("CardType",false);
	//卡类型
	var obj=document.getElementById('CardType');
	//因为dhtmlXComboFromSelect要判断isDefualt属性,
	if (obj) obj.setAttribute("isDefualt","true");
	combo_CardType=dhtmlXComboFromSelect("CardType");
	if (combo_CardType) {
		combo_CardType.enableFilteringMode(true);
	}
}

function GetCardTypeRowId(){
	var CardTypeRowId="";
	var CardTypeValue=combo_CardType.getSelectedValue();
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardTypeRowId=CardTypeArr[0];
	}
	return CardTypeRowId;
}

function GetCardEqRowId(){
	var CardEqRowId="";
	var CardTypeValue=combo_CardType.getSelectedValue();
	
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardEqRowId=CardTypeArr[14];
	}
	return CardEqRowId;
}

function ReadCardClickHandler(){
	var CardTypeRowId=GetCardTypeRowId();
	var CardEqRowId=GetCardEqRowId();
	var myoptval=combo_CardType.getSelectedValue();
	//通过读卡按钮时调用函数需要这个
	m_CCMRowID=GetCardEqRowId();
	//alert(CardTypeRowId+"&&"+m_CCMRowID+"&&"+myoptval)
	var myrtn=DHCACC_GetAccInfo(CardTypeRowId,myoptval);
	var myary=myrtn.split("^");
	var rtn=myary[0];
    //alert(myrtn);
	switch (rtn){
		case "0": //卡有效
				var PatientNo=myary[5];
				var obl=document.getElementById("RegNo") ;
			    if(obl)obl.value=PatientNo
			    RegNo=PatientNo
			    GetRegInfo();
			break;
		case "-200": //卡无效
			alert(t['InvaildCard']);
			break;
		default:
	}
}

function ReadCardType(){
	DHCC_ClearList("CardType");
	var encmeth=DHCC_GetElementData("CardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardType");
	}
}
function GetSelectItem()
{
	var TarRowIdRowIdStr="",TabOEORIRowIdStr="",ZFBLStr=""
	var OEORIRowId="",TarRowId=""
	var objtbl=document.getElementById("tINSUAuditLocal") ;
	if (objtbl)
	{		for (i=1;i<objtbl.rows.length-1;i++)
		{
			var item=document.getElementById("Selectz"+i);
			if(item.checked==true)
			{
				var TarRowId=document.getElementById("tardrz"+i).value
				if(TarRowIdRowIdStr=="") var TarRowIdRowIdStr=TarRowId
				else   var TarRowIdRowIdStr=TarRowIdRowIdStr+"^"+TarRowId
				
				var OEORIRowId=document.getElementById("TabOEORIRowIdz"+i).innerText
				if(TabOEORIRowIdStr=="") var TabOEORIRowIdStr=OEORIRowId
				else   var TabOEORIRowIdStr=TabOEORIRowIdStr+"^"+OEORIRowId

				var CellObj=document.getElementById("ZFBLz"+i); 	 //add hwq 2010 12 14

				var ZFBL=CellObj.value
					//var ZFBLt=ZFBLs.split("^");
					//var ZFBL=ZFBLt[0]
					//alert("1"+ZFBL)
					if (ZFBL==""){
						//var ZFBL=CellObj.options[0].value
						var ZFBL=""
						}		
				//}
				
				//var ZFBL=CellObj.options[CellObj.selectedIndex].text;
				//var ZFBL=CellObj.value
				if (ZFBLStr=="") var ZFBLStr=ZFBL
				else   var ZFBLStr=ZFBLStr+"^"+ZFBL
			}
		}
	}
	alert(ZFBLStr)
	var Out=TarRowIdRowIdStr+"="+TabOEORIRowIdStr+"="+ZFBLStr
	return Out
	//return TabOEORIRowIdStr

}

///登记号回车事件，格式化登记号并查询
function RegNoKeyDown(){
	var eSrc=window.event.srcElement;
	var key=websys_getKey(e);
	if (key==13){
		FormatRegNo();
		if (RegNo=="")  return
		else{
			GetRegInfo();
	}		


		}
	}

function GetRegInfo(){
	var Reg=document.getElementById("RegNo") ;
	Reg.value=RegNo
		var getadminfo=document.getElementById("getadminfo")
		if (getadminfo){var encmeth=getadminfo.value} else {var encmeth=''}	
		var rtn=cspRunServerMethod(encmeth,RegNo);
		//alert(rtn)
		var Str=rtn.split("^");
		var Name=Str[1];
		var AdmReaDr=Str[2];
		//alert("AdmReaDr"+AdmReaDr)
		var AdmDesc=Str[3];
		var DiagDesc=Str[4];
		var InsuNo=Str[5];
		var obj=document.getElementById("Name") ;
		obj.value=Name
		var obj=document.getElementById("AdmReaDr");
		obj.value=AdmReaDr
		var obj=document.getElementById("DiagDesc") ;
		obj.value=DiagDesc
		var obj=document.getElementById("AdmReason") ;
		obj.value=AdmDesc
		var obj=document.getElementById("InsuNo");
		obj.value=InsuNo
		var obj=document.getElementById("AdmNo");	
		obj.options.length=0;
		var Ins=document.getElementById("ClassAdmList");
  		if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
 		var OutStr=cspRunServerMethod(encmeth,'','',RegNo); 
 		//alert(OutStr)		 
		if (OutStr==""){
			alert("就诊记录不存在!");
			return;
		}	
		else{
			aData=OutStr.split("^")	     		
			for (i=0;i<aData.length-1;i++){
				if (aData[i]=="") Showtext="";
				else{
					TempPlist=aData[i].split("!")
					Showtext=TempPlist[4]+"  "+TempPlist[0]+"   "+TempPlist[3]
				}
				obj.options[i]=new Option(Showtext,aData[i]) ;
		}
		}
	var obj=document.getElementById("AdmNo");		
	var TempAdm=obj.options[0].value
	var AdmDr=document.getElementById("AdmDr");
	TempAdmdr=TempAdm.split("!");
	var PaadmRowId=TempAdmdr[1];  //adm
	AdmDr.value=PaadmRowId
    //alert(AdmDr.value)
}
//登记号补零
function FormatRegNo(){
	RegNo=DHCC_GetElementData("RegNo")
	if (RegNo!=''){
	if((RegNo.length<10)&&(RegNo.length!=0)) {
		for (var i=(10-RegNo.length-1); i>=0;i--){
			RegNo="0"+RegNo;
	    }
	  }
	}
	return RegNo
}


//********************************
//3:选择病人就诊记录                *
//******************************** 
 function selejzh(){	
	//clear();
	//alert("选择病人就诊记录");

	var obj=document.getElementById("AdmNo");	
	TemArry=obj[obj.selectedIndex].value;
	//alert(TemArry)
    if (TemArry==""){
	    alert("请选择就诊记录!");
	    return false;
    }
    jzh=TemArry
		GetPaAdmInfo();
		//getybcardno(); 不取卡号 Lou 2010-02-09

 }

    
///得到病人就诊记录
function GetPaAdmInfo(){
	var TemArry,TmpList
	var obj
	TemArry=jzh
	//alert("22"+jzh)
	if (TemArry==""){
		//clear();
		alert("选择就诊信息!");
		return false;
	}
	TempBl=TemArry.split("!");
	var PaadmRowId=TempBl[1];  //adm
	var Ins=document.getElementById('ClassBrjzxx');
  	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
 	var OutStr=cspRunServerMethod(encmeth,'','',PaadmRowId); 	
    //alert(OutStr)
    TmpList=OutStr.split("!");
    if (TmpList[0]=="-1"){
	    //clear();	    
	    return false ;	    
	}
	else{
		var AdmDr=document.getElementById("AdmDr");
		AdmDr.value=PaadmRowId
		var AdmReaDr=document.getElementById("AdmReaDr")
		AdmReaDr=AdmReaDr.value
		/*

    	//Lou 2010-02-28
    	var AdmReasonStr=TmpList[1].split("=")[5]
    	obj=document.getElementById("AdmReasonDr")
    	if (obj) {obj.value=aData[27];}
    	obj=document.getElementById("AdmReasonNationalCode")
    	if (obj) {obj.value=AdmReasonStr.split("^")[5];}
        
        if(obj.value==t['INSUTYPE01'])
       	{
	        InsuType="SDA";	
	    }
       	if(obj.value==t['INSUTYPE02'])
       	{
	        InsuType="SDB";	
	    }
	    if(obj.value==t['INSUTYPE03'])
       	{
	        InsuType="NBC";	
	    }
	    if(obj.value==t['INSUTYPE04'])
       	{
	        InsuType="NBD";	
	    }	    
       	
	    //Lou 2010-02-25
	    document.getElementById("HisLocCode").value=aData[3]
	    */
	}
}

//医嘱审核，标志存global
function Audit_Click()
{
	var TarOrdRowIdStr=GetSelectItem()
	var AdmDr=document.getElementById("AdmDr");
	AdmDr=AdmDr.value
	var MedAudit=document.getElementById("SetAudit").value ;
	//var aryStr=TabTarRowIdStr.split("=");  //add hwq 2010 12 14 添加支付比例
	//TabTarRowIdStr=aryStr[0]
	//TabOEORIRowIdStr=aryStr[1]
	//TabZFBL=aryStr[2]
    var ret=cspRunServerMethod(MedAudit,AdmDr,TarOrdRowIdStr,"Y",Guser);
    if (ret!=0)
    {
		alert("更新标志失败!")
	}
    Find_click()
}

function Resume_Click()
{
	var TarOrdRowIdStr=GetSelectItem()
	var AdmDr=document.getElementById("AdmDr");
	AdmDr=AdmDr.value
	alert(AdmDr+TarOrdRowIdStr)
	var MedAudit=document.getElementById("SetAudit").value ;
    var ret=cspRunServerMethod(MedAudit,AdmDr,TarOrdRowIdStr,"",Guser);
    if (ret!=0)
    {
		alert("更新标志失败!")
	}
    Find_click()
}

//拒绝
function Refuse_Click()
{
	var TarOrdRowIdStr=GetSelectItem()
	var AdmDr=document.getElementById("AdmDr");
	AdmDr=AdmDr.value
	alert(AdmDr)
	var MedAudit=document.getElementById("SetAudit").value ;
	//var aryStr=TabOEORIRowIdStr.split("!");  //add hwq 2010 12 14 添加支付比例
	//TabOEORIRowIdStr=aryStr[0]
    var ret=cspRunServerMethod(MedAudit,AdmDr,TarOrdRowIdStr,"N",Guser);
    if (ret!=0)
    {
		alert("更新标志失败!")
	}
    Find_click()
}

function Print_Click()
{
	var obj=document.getElementById("InsuNo");
	var InsuNo=obj.value
	var obj=document.getElementById("AdmReaDr");
	var AdmReaDr=obj.value
	var LocInfo=document.getElementById("getInLocInfo").value ;
    var ret=cspRunServerMethod(LocInfo,InsuNo,AdmReaDr);
    if (ret!=0){
	    alert(ret)
	    var Str=ret.split("^");
	    var DWDesc=Str[18]
	    
	    }

	 var xlApp,obook,osheet,xlsheet,xlBook,temp,str,vbdata,i,j 
     var Template,GuserName,StDate,EndDate
      //path="http://10.10.142.1/trakcarelivenyfy/trak/med/Templates/"
     Template=path+"INSU_AuditLocal.xls"	  
     //alert(Template)
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet  
	    var objOP=document.getElementById('tINSUAuditLocal');
      for (i=1;i<objOP.rows.length;i++){
        for (j=1;j<objOP.rows(1).cells.length;j++)   ///
         {
	     if(i=objOP.rows.length-1){
		     var aa=objOP.rows(i).cells(6).innerText
		    // alert(aa)
		    xlsheet.cells(4,6).value=objOP.rows(i).cells(6).innerText
		    xlsheet.cells(13,6).value=objOP.rows(i).cells(6).innerText
		    xlsheet.cells(5,2).value=objOP.rows(i).cells(15).innerText
		    xlsheet.cells(5,7).value=objOP.rows(i).cells(16).innerText
		    xlsheet.cells(15,2).value=objOP.rows(i).cells(15).innerText
		    xlsheet.cells(15,7).value=objOP.rows(i).cells(16).innerText
	     		}
	     }
	    }
  
	 xlsheet.cells(3,3).value=document.getElementById("Name").value;
 	 xlsheet.cells(12,3).value=document.getElementById("Name").value;
 	 xlsheet.cells(2,2).value=DWDesc
 	  xlsheet.cells(11,2).value=DWDesc
	// xlsheet.cells(2,2).value=PrtArry[2]+"-"+PrtArry[1]+"-"+PrtArry[0]
	// EndArry=EndDate.split("/")
	 //xlsheet.cells(2,4).value=EndArry[2]+"-"+EndArry[1]+"-"+EndArry[0]
	 //xlsheet.cells(5,2).value=objOP.rows(1).cells(1).innerText 
	// var Num=3+objOP.rows.length-1
	// xlsheet.cells(Num,1).value="合计"
	 //xlsheet.cells(Num,6).value="审核人签名："
	  // xlApp.Visible=true
	   	//xlsheet.PrintPreview();	
	   	xlsheet.printout
	    xlBook.Close (savechanges=false);
	    xlApp.Quit();
	    xlApp=null;
	    xlsheet=null    
}
	
function getLocInfo(){
	

    		
	
}
function getpath(){

		var getpath=document.getElementById('getpath')
		if (getpath){var encmeth=getpath.value} else {var encmeth=''}	
		path=cspRunServerMethod(encmeth,'','');
	
	}
	
document.body.onload = BodyLoadHandler;