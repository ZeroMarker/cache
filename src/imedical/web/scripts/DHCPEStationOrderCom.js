/// DHCPEStationOrderCom.js
/// 创建时间		2006.03.16
/// 创建人		xuwm
/// 主要功能		站点和体检大项(医嘱)对照表
/// 对应表		DHC_PE_StationOrder
/// 最后修改时间	
/// 最后修改人	

var CurrentSel=0;

function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	
	obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click }
	
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }

	//就餐限制
	obj=document.getElementById("Preprandial");
	if (obj){ obj.onclick=Diet_click; }
	obj=document.getElementById("Postprandial");
	if (obj){ obj.onclick=Diet_click; }	
	 obj=document.getElementById("NoLimited");
	if (obj){ obj.onclick=Diet_click; }
	
	obj=document.getElementById("GroupPrint");
	if (obj) obj.onclick=GroupPrint_click;
	
	obj=document.getElementById("RequestPrintType");
	if (obj) obj.onclick=RequestPrintType_click;
	
	obj=document.getElementById("BFind")
	if (obj){obj.onclick=Find_click;}
	obj=document.getElementById("SelectLoc")    //add   
	if(obj) {obj.onclick=SelectLoc_click}       //add 
	iniForm()   
	info();                                     //add
	//var obj=document.getElementById("STORD_ARCIM_Descz1");
	//if (obj) {obj.click();}

}  
function Find_click()
{
	var obj,ParRef="",ParRefName="",ARCIMDesc="";
	obj=document.getElementById("ParRefBox");
	if (obj) ParRef=obj.value;
	obj=document.getElementById("ParRefNameBox");
	if (obj) ParRefName=obj.value;
	obj=document.getElementById("ARCIMDesc");
	if (obj) ARCIMDesc=obj.value;
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEStationOrderCom"
			+"&ParRef="+ParRef+"&ParRefName="+ParRefName+"&ARCIMDesc="+ARCIMDesc;

	window.location.href=lnk; 
}
function iniForm(){	

	var SelRowObj;
	var obj;
	
	SelRowObj=document.getElementById('ParRefBox');	
	obj=document.getElementById('ParRef');
	if (SelRowObj && obj) {obj.value=SelRowObj.value; }

	if (obj && ""==obj.value)
	{
		obj=document.getElementById("ParRef_Name");
	    if (obj) { obj.value="未选择站点"; }
	}
	else
	{
		SelRowObj=document.getElementById('ParRefNameBox');	
		obj=document.getElementById('ParRef_Name');
		if (SelRowObj && obj) {obj.value=SelRowObj.value; }
		
		//ShowCurRecord(1);
	}

	if(SelRowObj.value.indexOf("病理")<0) { 
	var obj=document.getElementById("PISCode");
	if(obj) obj.style.display="none";
	var obj=document.getElementById("cPISCode"); 
	if(obj) obj.style.display="none"; 
	var obj=document.getElementById("PISCodeNew");
	if(obj) obj.style.display="none";
	var obj=document.getElementById("cPISCodeNew"); 
	if(obj) obj.style.display="none"; 
		
	}
	
	var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSendPisInterface");
	if(flag=="1"){
	
	var obj=document.getElementById("PISCode");
	if(obj) obj.style.display="none";
	var obj=document.getElementById("cPISCode"); 
	if(obj) obj.style.display="none"; 
	
	}else{
	var obj=document.getElementById("PISCodeNew");
	if(obj) obj.style.display="none";
	var obj=document.getElementById("cPISCodeNew"); 
	if(obj) obj.style.display="none"; 
     }

}

 function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
 }	

function Clear_click(){
	    
	//医嘱编码
	obj=document.getElementById("ARCIMCode");
	if (obj) { obj.value=""; }

	//医嘱名称
	obj=document.getElementById("ARCIMDesc");
	if (obj) { obj.value=""; }
	    
	//医嘱记录号
	obj=document.getElementById("ARCIMDR");
	if (obj) { obj.value=""; }
	    
	//记录编码 
	obj=document.getElementById("Childsub");
	if (obj) { obj.value=""; }
	
	//记录编号
	obj=document.getElementById("Rowid");
	if (obj) { obj.value=""; }
	
	//就餐标志
	obj=document.getElementById("Diet");
	if (obj){ obj.checked=false; }

	//就餐标志
	obj=document.getElementById("IsHaveChilud");
	if (obj) { obj.value=""; }
	
	// 医嘱套名称
	obj=document.getElementById("ARCOS_DR_Name");
	if (obj) { obj.value=""; }
	
	// 医嘱套编码
	obj=document.getElementById("ARCOS_DR");
	if (obj) { obj.value=""; }
	
	// 报告格式
	obj=document.getElementById("ReportFormat");
	if (obj) { obj.value=""; }
	
	obj=document.getElementById("AlowAddFlag");
	if (obj) { obj.checked=false; }

	
	// STORD_Notice	注意事项 
	obj=document.getElementById("Notice");
	if (obj) { obj.value=""; }
	// STORD_Notice	自动回传 
	obj=document.getElementById("AutoReturn");
	if (obj) { obj.checked=true; }
	obj=document.getElementById("TempName");
	if (obj) { obj.value=""; }
	obj=document.getElementById("PatItemName");
	if (obj) { obj.value=""; }
	obj=document.getElementById("ExtendItem");
	obj.checked=false;
	obj=document.getElementById("ShowOrHide");
	if (obj) { obj.checked=false; }
	obj=document.getElementById("PatFeeType_DR_Name");
	if (obj) { obj.value=""; }
	// STORD_Notice	时间 
	obj=document.getElementById("Minute");
	if (obj) { obj.value=""; }
		//报告类别
	obj=document.getElementById("ReportItemName");
	if (obj) { obj.value=""; }
	obj=document.getElementById("Sort");
	if (obj) { obj.value=""; }
	
	obj=document.getElementById("PatPrintOrder");
	if (obj) obj.value="";
	obj=document.getElementById("IFPrint");
	if (obj) obj.checked=true;
} 

function Update_click(){

	var iParRef="", iRowId="", iChildSub="",iAutoReturn="N",iPatItemName="",iExtend="",iShowOrHide="",iSex="";
	var iARCIMDR="",iDiet="N",iARCOSDR="",iReportFormat="",iNotice="";iPrintInPatItem="",iSignItem="",iPhoto="",iYGCheck="",iSpecialItem="";
	var Minute="";
	var iVIPLevel="",iAlowAddFlag="0";
	var iReportItemName="",iSort="",iBaseInfoBar="0";
	var iPreNum="";
	var iAgeMax="",iAgeMin="",iMarriedDR="";
	var obj;
	
	
	obj=document.getElementById("PreNum");
	if (obj) iPreNum=obj.value;
	//父项 站点编号	
	obj=document.getElementById("ParRef");  
	if (obj) { iParRef=obj.value; }
	
	iRowid=""
	//alert("1")
	//记录编码
	obj=document.getElementById("ChildSub");  
	if (obj) { iChildSub=obj.value; }
	
	//医嘱编号
	obj=document.getElementById("ARCIMDR");  
	if (obj){iARCIMDR=obj.value; }

	//
	obj=document.getElementById("ARCOS_DR");  
	if (obj){
		iARCOSDR=trim(obj.value);
		obj=document.getElementById("ARCOS_DR_Name");
		if (obj && ""==obj.value) { iARCOSDR="" }
	}
	
	//报告格式
	obj=document.getElementById("ReportFormat");  
	if (obj){
		iReportFormat=trim(obj.value);
		
		iReportFormat=iReportFormat.toUpperCase();
	}

	
	//就餐标志
	iDiet=GetDiet();

	// STORD_Notice	注意事项 
	obj=document.getElementById("Notice");
	if (obj) { iNotice=obj.value }
	
	obj=document.getElementById("SignItem");
	if (obj) {
		if (true==obj.checked){iSignItem="Y"; }
		else{ iSignItem="N"; }	
		}  
		
	obj=document.getElementById("PhotoItem");
	if (obj) {
		if (true==obj.checked){iPhoto="Y"; }
		else{ iPhoto="N"; }	
	}
	var TempName=""    //打印检查告知单的模版文件
	obj=document.getElementById("TempName");
	if (obj) {
		TempName=obj.value;	
	}  

    //obj=document.getElementById("PrintInPatItem");
	//if (obj){
	//	if (obj.checked==true){ iPrintInPatItem="Y"; }
	//	else{ iPrintInPatItem="N"; }
	//}
	//输入数据验证
	if ((""==iARCIMDR)||(""==iParRef)){
		//alert("Please entry all information.");
		alert(t['XMISSING']);
		return false;
	}  
	
	var obj=document.getElementById("PatItemName");
	if (obj) iPatItemName=obj.value;
	if (iPatItemName=="")
	{
		alert("导检单类别不能为空");
		websys_setfocus("PatItemName");
		return false;
	}
	
	obj=document.getElementById("AutoReturn");
	if (obj&&obj.checked) iAutoReturn="Y"
	//继承上次检查结果
	obj=document.getElementById("ExtendItem");
	if (obj) {
		if (true==obj.checked){iExtend="Y"; }
		else{ iExtend="N"; }	
	}
	obj=document.getElementById("ShowOrHide");
	if (obj&&obj.checked) iShowOrHide="Y"
	
	
      //是否为乙肝检查	
     obj=document.getElementById("YGCheck");
	if (obj) {
		if (true==obj.checked){iYGCheck="Y"; }
		else{ iYGCheck="N"; }	
	}
	
	    //是否为特需检查	
     obj=document.getElementById("PatFeeType_DR_Name");
	if (obj) {
		iSpecialItem=obj.value;	
	}
	// STORD_Notice	时间 
	obj=document.getElementById("Minute");
	if (obj) {Minute= obj.value; }
	
	obj=document.getElementById("Sex_DR_Name");
	if (obj) iSex=obj.value;
	
	//报告类别更新验证
	var obj=document.getElementById("ReportItemName");
	if (obj) iReportItemName=obj.value;
	if (iReportItemName=="")
	{
		//alert("报告类别不能为空");
		//websys_setfocus("ReportItemName");
		//return false;
	}
	
	// 导检单上医嘱顺序
	var obj=document.getElementById("PatPrintOrder");
	if (obj) iPatPrintOrder=obj.value;
	if (iPatPrintOrder=="")
	{
		//alert("导检单顺序不能为空");
		//websys_setfocus("PatPrintOrder");
		//return false;
	}
	
	///是否打印
	var iIFPrint="Y"
	obj=document.getElementById("IFPrint");
	if (obj) {
		if (true==obj.checked){iIFPrint="Y"; }
		else{ iIFPrint="N"; }	
	}
	//VIP等级
	var obj=document.getElementById("VIPLevel")
	//alert(obj.value)
	if (obj) iVIPLevel=trim(obj.value);
	//alert(iVIPLevel);
	var obj=document.getElementById("Sort");
	if (obj) iSort=obj.value;
	obj=document.getElementById("PrintBaseBar");
	if (obj&&obj.checked) iBaseInfoBar="1"
	
	//PIs标本类型
	var iPISCode="";
	var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSendPisInterface");
	if(flag=="1"){
		var obj=document.getElementById("PISCodeNew");
		if (obj) iPISCode=trim(obj.value);
	}else{
	var obj=document.getElementById("PISCode");
	if (obj) iPISCode=trim(obj.value);
	}


	//允许重复
	obj=document.getElementById("AlowAddFlag");
	if (obj&&obj.checked) iAlowAddFlag=1;
	
	//年龄上下限
	obj=document.getElementById("AgeMax");
	if (obj) iAgeMax=obj.value;
	obj=document.getElementById("AgeMin");
	if (obj) iAgeMin=obj.value;
	
	//婚姻
	obj=document.getElementById("Married_DR_Name");
	if (obj) iMarriedDR=obj.value;


	var Instring=trim(iParRef)			// 1 
				+"^"+trim(iRowId)		// 2 
				+"^"+trim(iChildSub)	// 3 
				+"^"+trim(iARCIMDR)		// 4 
				+"^"+trim(iDiet)		// 5 
				+"^"+trim(iARCOSDR)		// 6 
				+"^"+trim(iReportFormat)	// 7 
				+"^"+trim(iNotice)		// 8
				+"^"+trim(iAutoReturn)		// 9
				+"^"+trim(iSignItem)
				+"^"+trim(iPhoto)
				+"^"+trim(TempName)
				+"^"+trim(iPatItemName)
    			+"^"+trim(iExtend)
    			+"^"+trim(iShowOrHide)
    			+"^"+trim(iYGCheck)
    			+"^"+trim(iSpecialItem)
    			+"^"+trim(Minute)
    			+"^"+trim(iSex)
    			+"^"+trim(iReportItemName)
    			+"^"+trim(iSort)
				+"^"+iBaseInfoBar
				+"^"+iPatPrintOrder
				+"^"+iIFPrint
				+"^"+trim(iVIPLevel)
				+"^"+trim(iPreNum)
				+"^"+trim(iPISCode)
				+"^"+iAlowAddFlag
				+"^"+trim(iAgeMax)
				+"^"+trim(iAgeMin)
				+"^"+trim(iMarriedDR);

				;
 
	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } 
	else { var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring);
	if ('0'==flag) {
		location.reload();
	}else if ('-119'==flag||'-120'==flag) {
		//alert("此项目已被使用!!!");
		alert(t['-119']);
	}else{
		//alert("Insert error.ErrNo="+flag);
		alert(t['02']+flag);
	}
}

function Delete_click(){

	var iParRef="", iChildSub="";
	
	var obj;

	//站点编号
	obj=document.getElementById("ParRef");
	if (obj) { iParRef=obj.value; }
	
	//当前记录编号
	obj=document.getElementById("ChildSub");
	if (obj) { iChildSub=obj.value; }
    
	if ((iParRef=="")||(iChildSub=="")){
		//alert("Please select the row to be deleted.");
		//alert(t['03']);
		alert("请先选择待删除的记录");
		return false;
	} 
	else{ 
		//var iIsHaveChilud="",strShowAlert="";
		//obj=document.getElementById("IsHaveChilud");
		//if (obj) { var IsHaveChilud=obj.value; }
		//if ("Y"==iIsHaveChilud) { strShowAlert=t['04']; } //if (confirm("Are you sure delete it?")) {
		//else { strShowAlert=t['05']; } //
		
		if (confirm(t['04'])) {
			var Ins=document.getElementById('DeleteBox');
			if (Ins) {var encmeth=Ins.value; } 
			else {var encmeth=''};
			var flag=cspRunServerMethod(encmeth,'','',iParRef,iChildSub);
			if ('0'==flag) {}
			else{ 
				//alert("Delete error.ErrNo="+flag); 
				alert(t['05']+flag);
			}
			location.reload(); 
		}
	}

}
function FromTableToItem(Dobj,Sobj,selectrow) {

	var SelRowObj;
	var obj;
	var LabelValue="";

	SelRowObj=document.getElementById(Sobj+'z'+selectrow);
	if (!(SelRowObj)) { return null; }
	LabelValue=SelRowObj.tagName.toUpperCase();
   	obj=document.getElementById(Dobj);
   	if (!(obj)) { return null; }
   	
   	if ("LABEL"==LabelValue) {		
		obj.value=trim(SelRowObj.innerText);
		return obj;
	}
	
	if ("INPUT"==LabelValue) {
		LabelValue=SelRowObj.type.toUpperCase();
		
		if ("CHECKBOX"==LabelValue) {
			obj.checked=SelRowObj.checked;
			return obj;
		}
		
		if ("HIDDEN"==LabelValue) {
			obj.value=trim(SelRowObj.value);
			return obj;
		}
		
		if ("TEXT"==LabelValue) {
			obj.value=trim(SelRowObj.value);
			return obj;
		}

		obj.value=SelRowObj.type+trim(SelRowObj.value);
		return obj;
	}

}

//显示当前记录
function ShowCurRecord(CurRecord){
	
	var selectrow=CurRecord;
	var SelRowObj;
	var obj;
		
	//输入框 项目编码 显示
	SelRowObj=document.getElementById('STORD_ARCIM_Code'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("ARCIMCode");
    	obj.value=trim(SelRowObj.innerText);
	}
	//输入框 项目名称 显示
	SelRowObj=document.getElementById('STORD_ARCIM_Desc'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("ARCIMDesc");
		obj.value=trim(SelRowObj.innerText);
	}
	
		//输入框 项目编号 显示
		//SelRowObj=document.getElementById('STORD_ParRef_Name'+'z'+selectrow);
		//obj=document.getElementById("ParRef_Name");
		//obj.value=trim(SelRowObj.value);

		//需要从当前记录取得当前页面父节点
		//SelRowObj=document.getElementById('STORD_ParRef'+'z'+selectrow);
		//obj=document.getElementById("ParRef");	
		//obj.value=trim(SelRowObj.value);

	//ParRef 仅作保留 使用页面传输参数 
	SelRowObj=document.getElementById('STORD_Childsub'+'z'+selectrow);
	if (SelRowObj) {
		//obj=document.getElementById("Childsub");
		obj=document.getElementById("ChildSub");
		obj.value=SelRowObj.value;
	}
	
	//医嘱编号
	SelRowObj=document.getElementById('STORD_ARCIM_DR'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("ARCIMDR");
		obj.value=SelRowObj.value;
	}
	
	//就餐标志	STORD_Diet
	SelRowObj=document.getElementById('STORD_Diet1'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("Diet");
		SetDiet(trim(SelRowObj.innerText));	
	}
	
	//是否有子项	STORD_IsHaveChilud
	SelRowObj=document.getElementById('STORD_IsHaveChilud'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("IsHaveChilud");
		obj.value=SelRowObj.value;
	}
	
	// STORD_ARCOS_DR
	SelRowObj=document.getElementById('STORD_ARCOS_DR_Name'+'z'+selectrow);
	obj=document.getElementById("ARCOS_DR_Name");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.innerText); }
	
	// STORD_ARCOS_DR


	SelRowObj=document.getElementById('STORD_ARCOS_DR'+'z'+selectrow);
	obj=document.getElementById("ARCOS_DR");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }	
	
	// STORD_ReportFormat
	SelRowObj=document.getElementById('STORD_ReportFormat'+'z'+selectrow);
	obj=document.getElementById("ReportFormat");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.innerText); }
	
	//STORD_Notice	注意事项
	SelRowObj=document.getElementById('STORD_Notice'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("Notice");
		obj.value=SelRowObj.value;
	}
	//STORD_Notice	注意事项
	SelRowObj=document.getElementById('TAutoReturn'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("AutoReturn");
		obj.checked=SelRowObj.checked;
	}	
	
	SelRowObj=document.getElementById('TSignItem'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("SignItem");
		obj.checked=SelRowObj.checked;
	}	
	
	SelRowObj=document.getElementById('TPhotoItem'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("PhotoItem");
		obj.checked=SelRowObj.checked;
	}
	
       SelRowObj=document.getElementById('TYGCheck'+'z'+selectrow);  //add by zl 0830
	if (SelRowObj) {
		obj=document.getElementById("YGCheck");
		obj.checked=SelRowObj.checked;
	
	
	}
	SelRowObj=document.getElementById('TTempName'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("TempName");
		obj.value=trim(SelRowObj.innerText);
	}
	SelRowObj=document.getElementById('TPatItemNameID'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("PatItemName");
		obj.value=SelRowObj.value;
	}
	SelRowObj=document.getElementById('TExtendItem'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("ExtendItem");
		obj.checked=SelRowObj.checked;
	}
	SelRowObj=document.getElementById('TShowOrHide'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("ShowOrHide");
		obj.checked=SelRowObj.checked;
	
	}
	/*
	SelRowObj=document.getElementById('TGroupPrint'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("GroupPrint");
		obj.checked=SelRowObj.checked;
	
	}
	SelRowObj=document.getElementById('TRequestPrintType'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("RequestPrintType");
		obj.checked=SelRowObj.checked;
	
	}
	*/
	SelRowObj=document.getElementById('TSpecialItem'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("PatFeeType_DR_Name");
		obj.value=SelRowObj.innerText;
	
	}
	//STORD_Notice	时间
	SelRowObj=document.getElementById('TMinute'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("Minute");
		obj.value=SelRowObj.innerText;
	}
	
	SelRowObj=document.getElementById('TSex'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("Sex_DR_Name");
		obj.value=SelRowObj.value;
	
	}
	/*
	 //报告类别
    SelRowObj=document.getElementById('TReportItemNameId'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("ReportItemName");
		obj.value=SelRowObj.value;
	}
	*/
	SelRowObj=document.getElementById('TSort'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("Sort");
		obj.value=trim(SelRowObj.innerText);
	}
	SelRowObj=document.getElementById('TBaseBar'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("PrintBaseBar");
		obj.checked=SelRowObj.checked;
	
	}
	
	/// 导检单站点内打印顺序和是否打印 协和20130914 add by sun 
	SelRowObj=document.getElementById('TIFPrint'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("IFPrint");
		obj.checked=SelRowObj.checked;
	
	}
	
	SelRowObj=document.getElementById('TPatPrintOrder'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("PatPrintOrder");
		obj.value=trim(SelRowObj.innerText);
	}
	
	//vip等级 add by 20131023
	SelRowObj=document.getElementById('TVIPLevelId'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("VIPLevel");
		//alert(SelRowObj.innerText);
		obj.value=trim(SelRowObj.value);	
	}
	
	SelRowObj=document.getElementById('TPreNum'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("PreNum");
		obj.value=trim(SelRowObj.innerText);
	}
	
	SelRowObj=document.getElementById('TPISCodeID'+'z'+selectrow);
	if (SelRowObj) {
		var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSendPisInterface");
		if(flag!="1"){
		obj=document.getElementById("PISCode");
		obj.value=trim(SelRowObj.value);
		}
		if(flag=="1"){
		var obj=document.getElementById("PISCodeNew");
		obj.value=trim(SelRowObj.value);
		}
		
	}

	
	SelRowObj=document.getElementById('TAlowAddFlag'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("AlowAddFlag");
		obj.checked=SelRowObj.checked;
	} 

	SelRowObj=document.getElementById('TAgeMax'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("AgeMax");

		obj.value=trim(SelRowObj.innerText);
	}
	SelRowObj=document.getElementById('TAgeMin'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("AgeMin");
		obj.value=trim(SelRowObj.innerText);
	}
	SelRowObj=document.getElementById('TMarried'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("Married_DR_Name");
		obj.value=trim(SelRowObj.value);
	}

	
}		
	
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var tForm="";
	
	var obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	
	var objtbl=document.getElementById('t'+tForm);		
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);

	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	
	if (selectrow==CurrentSel){

		Clear_click();
		CurrentSel=0
		return;
	}

	CurrentSel=selectrow;

	ShowCurRecord(selectrow); 
	info(); 
}

document.body.onload = BodyLoadHandler;
// //////////////////////////////////////////////////////////////
function Diet_click() {
	var eSrc=window.event.srcElement;
	SetDiet(eSrc.name);
}

function SetDiet(value) {
	var obj;
	
	obj=document.getElementById("Preprandial");
	if (obj){ obj.checked=false; }

	obj=document.getElementById("Postprandial");
	if (obj){ obj.checked=false; }
	
	obj=document.getElementById("NoLimited");
	if (obj){ obj.checked=false; }
		
	if ("Preprandial"==value || "PRE"==value) {
		obj=document.getElementById("Preprandial");
		if (obj){ obj.checked=true; }
		return obj;
	}
	
	if ("Postprandial"==value || "POST"==value) {
		obj=document.getElementById("Postprandial");
		if (obj){ obj.checked=true; }
		return obj;
	}
		
	if ("NoLimited"==value || "N"==value) {
		obj=document.getElementById("NoLimited");
		if (obj){ obj.checked=true; }
		return obj;
	}
	
	if (""==value) {
		obj=document.getElementById("NoLimited");
		if (obj){ obj.checked=true; }
		return obj;
	}	
	
}

function GetDiet() {
	var obj;
	
	obj=document.getElementById("Preprandial");
	if (obj && obj.checked){ return "PRE"; }

	obj=document.getElementById("Postprandial");
	if (obj && obj.checked){ return "POST"; }
	
	obj=document.getElementById("NoLimited");
	if (obj && obj.checked){ return "N"; }
	
	return "N";

}
// ////////////////////////////////////////////////////////////////////
//搜索医嘱 处理选择的结果
function SearchArcItmmast(value){
	var aiList=value.split("^");
	if (""==value){return false}
	else{
		var obj;
		
		//默认选择新的项目是要增加
		Clear_click();

		//医嘱编码
		obj=document.getElementById("ARCIMCode");
		obj.value=aiList[0];

		//医嘱名称
		obj=document.getElementById("ARCIMDesc");
		obj.value=aiList[1];

		//医嘱编号
		obj=document.getElementById("ARCIMDR");
		obj.value=aiList[2];
		
	}
}

// ////////////////////////////////////////////////////////////////////
//选择医嘱套
function SearchARCOrdSet(value){
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;

		//医嘱名称
		obj=document.getElementById("ARCOS_DR_Name");
		if (obj) { obj.value=aiList[1]; }

		//医嘱编号
		obj=document.getElementById("ARCOS_DR");
		if (obj) { obj.value=aiList[2]; }
		
	}
}
function info()
{  
	var ParrefRowId=""
  	//obj=document.getElementById("Childsub");
  	obj=document.getElementById("ChildSub");
	var iChildsub=obj.value;
	obj=document.getElementById("ParRef");
	if(obj){var iPreRef=obj.value;}
	var Ins=document.getElementById("Info")	
    if (Ins) {var encmeth=Ins.value} 
	else {var encmeth=""} 
    var flag=cspRunServerMethod(encmeth,iPreRef,iChildsub)
	obj=document.getElementById("Loc");
	if (obj){obj.value=flag;}
}

function SelectLoc_click()
{
	var SelRowObj,rowid=""
	SelRowObj=document.getElementById('STORD_RowId'+'z'+CurrentSel)
	if(SelRowObj) {rowid=SelRowObj.value}
    var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCPESelectLoc&RowId='+rowid
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,top=200,left=500,width=600,height=400')
}
function GroupPrint_click()
{
	var obj;
	var printFlag=0,iARCIMDR="";
	
	obj=document.getElementById("ARCIMDR");
	iARCIMDR=obj.value;
	if (iARCIMDR=="") return;
	obj=document.getElementById("GroupPrint");
	if (obj&&obj.checked) printFlag=1;
	tkMakeServerCall("web.DHCPE.StationOrder","SetGroupPrint",iARCIMDR,printFlag) ;
	alert("设置完成");
}
function RequestPrintType_click()
{
	var obj;
	var printFlag=0,iARCIMDR="";
	
	obj=document.getElementById("ARCIMDR");
	iARCIMDR=obj.value;
	if (iARCIMDR=="") return;
	obj=document.getElementById("RequestPrintType");
	if (obj&&obj.checked) printFlag=1;
	tkMakeServerCall("web.DHCPE.StationOrder","SetRequestPrintType",iARCIMDR,printFlag) ;
	alert("设置完成");
}

/*
//搜索站点 处理选择的结果
function SearchStation(value){
	
		//容许改变当前站点
		var aiList=value.split("^");
		if (""==value){return false}
		else {
			var obj;
			
			Clear_click();
			
			//父项 站点编号
			obj=document.getElementById("ParRef");
			obj.value=aiList[2];

			//站点名称
			obj=document.getElementById("ParRef_Name");
			obj.value=aiList[0];

		}

}
*/
// ////////////////////////////////////////////////////////////////////