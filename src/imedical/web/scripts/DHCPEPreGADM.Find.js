/// DHCPEPreGADM.Find.js

///预约?查询团体预约


var TFORM="tDHCPEPreGADM_Find";	//团体记录集元素

var CurrentSel=0;	//当前团体记录

var CurrentConponent="";	//分组目标组件名

var CurrentAdmType="";	//当前分组类型

function BodyLoadHandler() {

	var obj;
	
	//按钮 查询
	obj=document.getElementById("BFind");
	if (obj){ obj.onclick=BFind_click; }

	//清屏
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }

	//zhouli
	obj=document.getElementById("PrintGroupPerson");
	if (obj){ obj.onclick=PrintGroupPerson_Click; }
	
	obj=document.getElementById("BAllowToCharge");
	if (obj){ obj.onclick=BAllowToCharge_Click; }
	
	var obj=document.getElementById("Contract");
	if (obj) obj.onchange=Contract_change;
	
	//按钮 主场设定
	obj=document.getElementById("HomeSet");
	if (obj){obj.onclick=HomeSet_Click; }
    
	
	//按钮 人员分组
	//obj=document.getElementById("BITeam");
	//if (obj){ 
	//	obj.onclick=BITeam_click;
	//	obj.disabled=true;
	//}
	
	//按钮 团体分组
	//obj=document.getElementById("BGTeam");
	//if (obj){ 
	//	obj.onclick=BGTeam_click;
	//	obj.disabled=true;
	//}
	
	//按钮  打印团体体检凭条
	obj=document.getElementById("PrintTeamPerson");
	if (obj){ obj.onclick=PrintTeamPerson_Click; }
	//按钮  打印基本信息条码
	obj=document.getElementById("BPrintBaseInfo");
	if (obj){ obj.onclick=BPrintBaseInfo_Click; }
	
	//复制分组
	obj=document.getElementById("BCopyTeam");
	if (obj){ obj.onclick=BCopyTeam_click; }
	
	//按钮 修改预约信息
	obj=document.getElementById("Update");

	if (obj){
		obj.onclick=Update_click;
		obj.disabled=true;
		obj.style.color = "gray";
	}
	
	//按钮 中间加项
	obj=document.getElementById("BModifyItem");

	if (obj){
		obj.onclick=ModifyItem_click;
		//obj.onclick=BModifyItem_click
		obj.disabled=true;
		obj.style.color = "gray"
	}
	//按钮 取消预约
	obj=document.getElementById("BCancelPre");
	if (obj){
		obj.onclick=BCancelPre_click;
		obj.disabled=true;
		obj.style.color = "gray"
	}
	DHCP_GetXMLConfig("InvPrintEncrypt","OEItemPrint");
	iniForm();
	InitRowObj();
	/*
   document.getElementById("Status_PREREG").checked=true;
   document.getElementById("Status_REGISTERED").checked=true;  //add
   document.getElementById("Status_ARRIVED").checked=true;
   */

   //add by gwj 
   //document.getElementById("Status_UNCHARGED").checked=false;
   //Button Export
   //obj=document.getElementById("B_Export");
   // if (obj){ obj.onclick=BExport_click; }
//********
}
function BCopyTeam_click()
{
	var obj,encmeth="",ID;
	
	obj=document.getElementById('RowId');
	if (obj) {
		var ID=obj.value; 
	}
	
	if (ID=="" || ID==undefined){
		return;	
	}
	
	var wwidth=1200;
	var wheight=500;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var repUrl="dhcpeteamcopy.csp?ToGID="+ID;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(repUrl,"_blank",nwin)	
}
function BAllowToCharge_Click()
{
	var obj,encmeth="",ID;
	obj=document.getElementById("PGADM_RowIdz"+CurrentSel);
	if (obj) ID=obj.value;
	if (ID=="") return false;
	var encmethobj=document.getElementById("AllowToChargeClass");
	if (encmethobj) var encmeth=encmethobj.value;
	var Type="Group";
	//var ReturnStr=cspRunServerMethod(encmeth,ID_"^"_"1",Type);
	var ReturnStr=cspRunServerMethod(encmeth,ID+"^"+"1",Type,"Pre");
	if (ReturnStr==""){
		alert("修改完成");
	}else{
		alert("还没有登记,不允许缴费");
	}
}
function BCancelPre_click()
{
	var obj,encmeth="",ID,Status;
	
	obj=document.getElementById("BCancelPre");
	if (obj && obj.disabled){ return false; }
	var Type=obj.innerHTML.substr(obj.innerHTML.length-4,4)
	Status="PREREG"
	if (Type=="取消预约") Status="CANCELPREREG"
	obj=document.getElementById("StatusBox");
	if (obj) encmeth=obj.value;
	if (encmeth=="") return false;
	if (CurrentSel==0) return false;
	obj=document.getElementById("PGADM_RowIdz"+CurrentSel)
	if (obj) ID=obj.value;
	var Flag=cspRunServerMethod(encmeth,ID,Status);
	if (Flag!="0")
	{
		alert(t["01"])
		return;
	}
	window.location.reload();
}
function iniForm(){
	var obj;
	//////
	obj=document.getElementById("Status_REGISTERED");
	if (obj) { obj.value=1; }

	// 查询条件 预约状态
	obj=document.getElementById("Status");
	if (obj) {
		var iStatus=obj.value;
		if (""==iStatus) { SetStatus(iStatus); }
		else { SetStatus(iStatus); }
	}
	
	//ShowCurRecord(1);
	
	//GetURL(CurrentConponent,CurrentAdmType); 	
	//处于页面框架下时 获取目标框架
	//if ("DHCPEPreGADM.Find"==self.name) {
	//	obj=parent.frames["DHCPEPreTeam"].document.getElementById("TFORM");
	//	if (obj) { CurrentConponent=obj.value; }
	//}
	
}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];

}

function GetURL(ConponentName,AdmType) {
	
	//团体编码
	var obj;
	obj=document.getElementById('RowId');
	if (obj) {
		var iRowId=obj.value; 
		if (""==iRowId) { return false; }
	}
	
	//团体名称
	obj=document.getElementById('RowId_Name');
	if (obj) {
		var iName=obj.value; 
		if (""==iName) { return false; }
	}
	var GBookDate="",GBookTime="";
	obj=document.getElementById('GBookDate');
	if (obj ) { GBookDate=obj.value; }
	
	obj=document.getElementById('GBookTime');
	if (obj ) { GBookTime=obj.value; }
	
	// 
	parent.SetGADM(iRowId+"^"+iName+"^"+GBookDate+"^"+GBookTime+"^"+"Q");
	return true;
	
	/*
	//分组框架
	var lnk="dhcpepregadm.edit.csp"+"?IsQuery="+"Y"
			+"&ParRef="+iRowId
			+"&ParRefName="+iName
			+"&OperType="+"Q"; //操作类型 查询
			;

	parent.frames["DHCPEPreTeam"].location.href=lnk;
	*/
}
//双击团体记录
function PreGADM_click() {

	var eSrc=window.event.srcElement;
	
	var obj=document.getElementById(TFORM);
	if (obj){ var tForm=obj.value; }
	
	var objtbl=document.getElementById(tForm);	
	
	if (objtbl) { var rows=objtbl.rows.length; }

	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	
	/*
	if (selectrow==CurrentSel)
	{
	    CurrentSel=0;
	    return;
	}
	*/
	if (CurrentSel==selectrow)
	{
		CurrentSel=0;
	}
	else
	{
		CurrentSel=selectrow;
	}
	ShowCurRecord(CurrentSel);
 	//GetURL(CurrentConponent,CurrentAdmType);
}

//单击团体记录 选择记录
function ShowCurRecord(CurrentSel) {

	//站点编码 显示	    
	var SelRowObj;
	var obj;
	var iRowId="";
	var iComplete=""       //add by zl20100722
	if (CurrentSel==0)
	{
		obj=document.getElementById("Update");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";
		}
		
		obj=document.getElementById("BCancelPre");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";
		}
		
		// 中间加项 
		obj=document.getElementById("BModifyItem");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";
		}
	}
	SelRowObj=document.getElementById('PGADM_RowId'+'z'+CurrentSel);	
	obj=document.getElementById('RowId');
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }

	SelRowObj=document.getElementById('PGADM_PGBI_DR_Name'+'z'+CurrentSel);
	obj=document.getElementById('RowId_Name');
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.innerText); }
	
	SelRowObj=document.getElementById('PGADM_BookDate'+'z'+CurrentSel);
	obj=document.getElementById('GBookDate');
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.innerText); }	
	
	SelRowObj=document.getElementById('PGADM_BookTime'+'z'+CurrentSel);
	obj=document.getElementById('GBookTime');
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.innerText); }
	SelRowObj=document.getElementById('PGADM_CompleteStatus'+'z'+CurrentSel);        //add by zl20100722
	if (SelRowObj){var iComplete=SelRowObj.innerText}                                //add by zl20100722	
	
	GetURL(CurrentConponent,CurrentAdmType);
	
	SelRowObj=document.getElementById('PGADM_Status'+'z'+CurrentSel);
	if (SelRowObj) {
		var Status=SelRowObj.value;
		if (Status=="PREREG")
		{
			obj=document.getElementById("Update");
			if(obj){obj.disabled=false;
			obj.style.color = "blue";
			}
			obj=document.getElementById("BModifyItem");
			if(obj){obj.disabled=false;
			obj.style.color = "blue";
			}
			obj=document.getElementById("BCancelPre");
			if(obj){obj.disabled=false;
			obj.style.color = "blue";
			obj.innerHTML="<img SRC='../images/websys/update.gif' BORDER='0'>取消预约";
			}
			
			return;
		}
		if (Status=="CANCELPREREG")
		{
			obj=document.getElementById("Update");
			if(obj){obj.disabled=true;
			obj.style.color = "gray";
			}
			obj=document.getElementById("BModifyItem");
			if(obj){obj.disabled=true;
			obj.style.color = "gray";
			}
			obj=document.getElementById("BCancelPre");
			if(obj){obj.disabled=false;
			obj.style.color = "blue";
			obj.innerHTML="<img SRC='../images/websys/update.gif' BORDER='0'>预约";
			}
			return;
		}
		
		obj=document.getElementById("Update");
		if(obj){obj.disabled=false;
			obj.style.color = "blue";
		}
		if (iComplete=="已完成"){                          
		obj.disabled=true; 
		obj.style.color = "gray";
		}                              
		obj=document.getElementById("BModifyItem");
		if(obj){obj.disabled=false;
		obj.style.color = "blue";
		}
		if (iComplete=="已完成"){                         
		obj.disabled=true; 
		obj.style.color = "gray";
		}                             
		obj=document.getElementById("BCancelPre");
		if(obj){obj.disabled=true;
		obj.style.color = "gray";
		}
		return;
		// 编辑
		obj=document.getElementById("Update");
		if ("PREREG"==SelRowObj.value && obj) { obj.disabled=false; 
		obj.style.color = "blue";
		}
		else{ obj.disabled=true; 
		obj.style.color = "gray";
		}
		
		obj=document.getElementById("BCancelPre");
		if ("PREREG"==SelRowObj.value && obj) { obj.disabled=false; obj.innerHTML="取消预约";obj.style.color = "blue";}
		else if ("CANCELPREREG"==SelRowObj.value && obj) {obj.disabled=false; obj.innerHTML="预约";obj.style.color = "blue";}
		else{obj.disabled=true;obj.style.color = "gray";}
		// 中间加项 
		obj=document.getElementById("BModifyItem");
		if ((("ARRIVED"==SelRowObj.value)||("CHECKED"==SelRowObj.value)) && obj) { obj.disabled=false;obj.style.color = "blue"; }
		else{ obj.disabled=true; 
		obj.style.color = "gray";}
	}	
}
// 中间加项
function ModifyItem_click() {
	

	var obj;
	
	obj=document.getElementById("BModifyItem");
	if (obj && obj.disabled){ return false; }
	
	var iRowId="";
	var iName="";
	
	obj=document.getElementById("RowId");
	if (obj){ iRowId=obj.value; }
	
	obj=document.getElementById('RowId_Name');
	if (obj){ iName=obj.value; }
	var lnk="dhcpepregadm.team.csp?"
	//var lnk="DHCPEPreGADM.Edit.csp?"
			+"ParRef="+iRowId
			+"&ParRefName="+iName
			+"&OperType="+"T"
			;
	window.location.href=lnk;

}

// 团体预约编辑
function Update_click() {
	
	var obj;
	
	obj=document.getElementById("Update");
	if (obj && obj.disabled){ return false; }
	
	var iRowId="";
	var iName="";
	
	obj=document.getElementById("RowId");
	if (obj){ iRowId=obj.value; }
	
	obj=document.getElementById('RowId_Name');
	if (obj){ iName=obj.value; }
	var lnk="dhcpepregadm.edit.csp?"
	//var lnk="DHCPEPreGADM.Edit.csp?"
			+"ParRef="+iRowId
			+"&ParRefName="+iName
			+"&OperType="+"E"
			;
	parent.location.href=lnk;

}
//查询团体
function BFind_click() {
	
	var obj;
	
	var iCode="";
	var iName="";
	var iBookDate="";
	var iBookTime="";
	var iStatus="";
	var iBeginDate="";   //Add
	var iEndDate="";     //Add
	var iRegDateFrom="";
	var iRegDateTo="";
	/*obj=document.getElementById("TFORM");
	if (obj){ var tForm=obj.value; }
	else { return false; }*/
	

	obj=document.getElementById("Code");
	if (obj){ iCode=obj.value; }

	obj=document.getElementById("Name");
	if (obj){ iName=obj.value; }

	obj=document.getElementById("BookDate");
	if (obj){ iBookDate=obj.value; }

	obj=document.getElementById("BookTime");
	if (obj){ iBookTime=obj.value; }
	obj=document.getElementById("BeginDate");    //Add
	if (obj){ iBeginDate=obj.value; }            //Add
	
	obj=document.getElementById("EndDate");      //Add
	if (obj){ iEndDate=obj.value; }              //Add
		
	obj=document.getElementById("Status_PREREG");
	if (obj){sss=obj.value; }	

	iStatus=GetStatus();

	iReportGroup="1"
	obj=document.getElementById("ShowPrintGroup");
	if (obj){
		if (!obj.checked) iReportGroup="0"
	}
	obj=document.getElementById("RegDateFrom");    //Add by 20110907
	if (obj){ iRegDateFrom=obj.value; }              //Add by 20110907
	
	obj=document.getElementById("RegDateTo");      //Add by 20110907
	if (obj){ iRegDateTo=obj.value; }                //Add by 20110907
	var iPersonNum="";
	obj=document.getElementById("PersonNum"); 
	if (obj){ iPersonNum=obj.value; } 
	var iContractID="";
	obj=document.getElementById("ContractID"); 
	if (obj){ iContractID=obj.value; }
	//add by gwj 
	iCSta=GetCStatus()
	//*********
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+tForm
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreGADM.Find"
			+"&Code="+iCode
			+"&Name="+iName
			+"&BookDate="+iBookDate
			+"&BookTime="+iBookTime
			+"&Status="+iStatus
			+"&ReportGroup="+iReportGroup
			+"&BeginDate="+iBeginDate     //Add
			+"&EndDate="+iEndDate         //Add
			+"&ChargeStatus="+iCSta //Add by gwj 
			+"&RFind=1"
			+"&RegDateFrom="+iRegDateFrom //Add by gwj 
			+"&RegDateTo="+iRegDateTo
			+"&PersonNum="+iPersonNum
			+"&ContractID="+iContractID
			;
			

	location.href=lnk;
}

function Clear_click() {
	var obj;
	
	//团体编码 
	obj=document.getElementById("Code");
	obj.value="";
	
	//团体名称
	obj=document.getElementById("Name");
	obj.value="";
	
	//预约开始日期
	obj=document.getElementById("BeginDate");
	obj.value="";
	
	//预约结束日期
	obj=document.getElementById("EndDate");
	obj.value="";
	
	//登记开始日期
	obj=document.getElementById("RegDateFrom");
	obj.value="";
	
	//登记截止日期
	obj=document.getElementById("RegDateTo");
	obj.value="";
	
	//部门
	obj=document.getElementById("Depart");
	obj.value="";
	
	//人数
	obj=document.getElementById("PersonNum");
	obj.value="";
	
	//合同
	obj=document.getElementById("Contract");
	obj.value="";
	
	obj=document.getElementById("ContractID");
	obj.value="";
	
   
   //凭条类型
   obj=document.getElementById("VIPLevel");
	obj.value="";
   


}
		
function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	var tForm="";
	
	var obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	
	var objtbl=document.getElementById(tForm);	
	
	if (objtbl) { var rows=objtbl.rows.length; }

	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	/*
	if (selectrow==CurrentSel)
	{	    
	
	    Clear_click();
	    CurrentSel=0;
	    return;
	}
	*/
	if (CurrentSel==selectrow)
	{
		CurrentSel=0;
	}
	else
	{
		CurrentSel=selectrow;
	}
	
	ShowCurRecord(CurrentSel);

}

function SetStatus(value) {
	var obj;

	obj=document.getElementById("Status_PREREG");
	if (obj) {
		if (value.indexOf("^PREREG")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
	
	obj=document.getElementById("Status_CHECKED");
	if (obj) {
		if (value.indexOf("^CHECKED")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
	
	obj=document.getElementById("Status_REGISTERED");
	if (obj) {
		if (value.indexOf("^REGISTERED")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
	obj=document.getElementById("Status_CANCELPREREG");
	if (obj) {
		if (value.indexOf("^CANCELPREREG")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
	obj=document.getElementById("Status_CANCELPE");
	if (obj) {
		if (value.indexOf("^CANCELPE")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
	obj=document.getElementById("Status_ARRIVED");
	if (obj) {
		if (value.indexOf("^ARRIVED")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}

}
function GetStatus() {
	var iStatus="";
	obj=document.getElementById("Status_PREREG");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"PREREG"; }
	obj=document.getElementById("Status_REGISTERED");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"REGISTERED";}
	obj=document.getElementById("Status_CANCELPREREG");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"CANCELPREREG"; }
	obj=document.getElementById("Status_CANCELPE");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"CANCELPE"; }
	obj=document.getElementById("Status_ARRIVED");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"ARRIVED"; }
	return iStatus;
}

   //ZHOULI 2008-04-21
function PrintGroupPerson_Click()
{ 
    try{
	var obj;
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPrintGPerson.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称
	
	

    var obj=document.getElementById("RowId");
    if(obj)  {var PIADM=obj.value;} 
   
    
    if ((""==PIADM)){
		alert("未选择团体");
		return false;	}
    
    var Instring=PIADM;
    var obj=document.getElementById("DateBox");
    if (obj) {var encmeth=obj.value} else{var encmeth=""}
 
    
    var obj=document.getElementById("RowId_Name");
    if(obj)  {var PIADMName=obj.value;} 
    var returnval=cspRunServerMethod(encmeth,Instring,"N");
    
	//var strinfo=returnval  //str_"&&"_num
    //var info=strinfo.split("&&")
 
	var str=returnval; //[0]
	//var num=info[1]      //组的个数
	//循环行
   	var temprow=str.split("^");
   	if(temprow=="")
   	{
		alert("该团体人员名单为空")
	   	return;
	}
   	k=2; 
   	var tmp=0; 
  	// xlsheet.cells(2,1)="团体名称:"+PIADMName;
   	encmeth=document.getElementById("GetOneInfoClass").value;
   
             //表示execl的行
	for(i=0;i<=(temprow.length-1);i++)
	{  
	    var row=cspRunServerMethod(encmeth,temprow[i]);
		var tempcol=row.split("^");
	    var id=i+1;
		itemrowid=tempcol[7];
		//本次组rowid不等于上次组rowid并且不是第一组时则行加2
		if((itemrowid != tmp))
		{   var count=1;
			k=k+1;
			xlsheet.Rows(k+1).insert();
			k=k+1;
			xlsheet.Rows(k+1).insert(); 
			
			
			xlsheet.cells(k-1,1)=tempcol[8]; //写组名
		    
			var Range=xlsheet.Cells(k-1,1);
	        xlsheet.Range(xlsheet.Cells(k-1,1),xlsheet.Cells(k-1,6)).mergecells=true; //合并单元格
			xlsheet.cells(k,1)="序号"
			xlsheet.cells(k,2)="登记号" 
			xlsheet.cells(k,3)="姓名" 
			xlsheet.cells(k,4)="性别"
			xlsheet.cells(k,5)="年龄"
			//xlsheet.cells(k,6)="婚姻状况"
			xlsheet.cells(k,6)="部门"
			//xlsheet.cells(k,8)="优惠金额"
			//xlsheet.cells(k,9)="实际金额"
			//var Range=xlsheet.Cells(k,1)
			//xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(1,5)).HorizontalAlignment =-4108;//居中
			//xlsheet.Range(xlsheet.Cells(k,1),xlsheet.Cells(k,5)).HorizontalAlignment =-4108;//居中
			
			
			xlsheet.Columns(2).NumberFormatLocal="@";  //设置登记号为文本型 
			xlsheet.Columns(5).NumberFormatLocal="@";                            
		}
		//tempcol[0]=count;
		count=count+1;
		xlsheet.Rows(k+1).insert();         //插入一行
		//alert(tempcol)
		//循环列
		/*
		for(j=0;j<=tempcol.length-10;j++)
			{   
				xlsheet.cells(k+1,j+1).Value=tempcol[j];
					
			}*/
			xlsheet.cells(k+1,1).Value=tempcol[0];
			xlsheet.cells(k+1,2).Value=tempcol[1];
			xlsheet.cells(k+1,3).Value=tempcol[2];
			xlsheet.cells(k+1,4).Value=tempcol[3];
			xlsheet.cells(k+1,5).Value=tempcol[4];
			xlsheet.cells(k+1,6).Value=tempcol[6];      //tempcol[12];
			//xlsheet.cells(k+1,7).Value=tempcol[6];
		//xlsheet.cells(k+1,9).Value=tempcol[10];
		//xlsheet.cells(k+1,10).Value=tempcol[11];
		//xlsheet.cells(k+1,j+1).Value=tempcol[tempcol.length-1];	 
	   tmp=itemrowid;   //将本次组rowid赋给一个临时变量?待与下次取得的组rowid比较
	   k=k+1;
	   xlsheet.cells(2,1)="团体名称:"+PIADMName+"(共"+id+"人)";
	}
///删除最后的空行
xlsheet.Rows(k+1).Delete;
///删除最后的空行
xlsheet.Rows(k+1).Delete;
///删除最后的空行
xlsheet.Rows(k+1).Delete;
///删除最后的空行
xlsheet.Rows(k+1).Delete;
xlsheet.SaveAs("d:\\团体人员名单.xls");
xlApp.Visible = true;
xlApp.UserControl = true;	
idTmr   =   window.setInterval("Cleanup();",1); 
    /*
    xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null

	idTmr   =   window.setInterval("Cleanup();",1); 
	*/
}

catch(e)
	{
		alert(e+"^"+e.message);
	}
}

function   Cleanup()   { 
	window.clearInterval(idTmr);   
	CollectGarbage();
  
}
//打印基本信息条码
function BPrintBaseInfo_Click()
{
	var obj=document.getElementById("RowId");
   	if(obj)  {var PIADM=obj.value;} 
  
   	if ((""==PIADM)){
		alert(t['NoAdm']);
		return false;
	}
   	var Instring=PIADM;
   	var obj=document.getElementById("DateBox");
   	if (obj) {var encmeth=obj.value} else{var encmeth=""}
   	var NewHPNo="",VIPLevel="";
	var obj=document.getElementById("Code");
    if(obj)  {NewHPNo=obj.value;}
    var obj=document.getElementById("VIPLevel");
    if(obj)  {VIPLevel=obj.value;}
   	var returnval=cspRunServerMethod(encmeth,Instring,"Y",NewHPNo,VIPLevel);
   	var str=returnval; //[0]
	var temprow=str.split("^");
	if(temprow=="")
	{
		alert("该团体人员名单为空")
   		return;
	} 
	encmeth=document.getElementById("GetOneInfoClass").value;
	for(i=0;i<=(temprow.length-1);i++)
	{  
    	var row=cspRunServerMethod(encmeth,temprow[i]);
		var tempcol=row.split("^");
    	var Amount=tkMakeServerCall("web.DHCPE.HandlerPreOrds","IGetAmount4Person",temprow[i]); 
		var FactAmount=Amount.split('^')[1]+'元';
   		//var Info=RegNo+"^"+Name+"  "+FactAmount+"^"+"^"+"^"+"^"+Sex+String.fromCharCode(1)+"^"+Age+"^"+RegNo;
		var Info=tempcol[1]+"^"+tempcol[2]+"  "+FactAmount+"^"+"^"+"^"+"^"+tempcol[3]+String.fromCharCode(1)+"^"+tempcol[4]+"^"+tempcol[1]+"^"+"";
		PrintBarRis(Info);
	}

}
//打印团体体检凭条

function PrintTeamPerson_Click (){
	try{
	var obj;
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPrintTeamPerson.xls';
		//alert(Templatefilepath);
	}else{
		alert("无效模板路径");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称
	    var obj=document.getElementById("RowId");
    if(obj)  {var PIADM=obj.value;} 
   
    if ((""==PIADM)){
		alert(t['NoAdm']);
		return false;	}
    var myDate = new Date();
    myDate.getFullYear();
    //alert(myDate.getFullYear());
    var Instring=PIADM;
    //alert(PIADM);
    var obj=document.getElementById("DateBox");
    if (obj) {var encmeth=obj.value} else{var encmeth=""}
    
    var obj=document.getElementById("RowId_Name");
    if(obj)  {var PIADMName=obj.value;}
	var NewHPNo="",VIPLevel="";
	var obj=document.getElementById("Code");
    if(obj)  {NewHPNo=obj.value;}
    var obj=document.getElementById("VIPLevel");
    if(obj)  {VIPLevel=obj.value;}
	var returnval=cspRunServerMethod(encmeth,Instring,"Y",NewHPNo,VIPLevel);
    var str=returnval; //[0]
   	var temprow=str.split("^");
   	if(temprow=="")
   	{
		//alert("该团体人员名单为空")
		alert("该团体已没有可打印的凭条")
	   	return;
	} 
   	encmeth=document.getElementById("GetOneInfoClass").value;
	for(i=0;i<=(temprow.length-1);i++)
	{  
	    var row=cspRunServerMethod(encmeth,temprow[i]);
		var tempcol=row.split("^");
	    var j=(i+1)%6;
	    var Rows,Cols;
	    if (j==1){
	        Rows=0; 
	        Cols=0; 
	    }
	    if (j==2){
	        Rows=0;  
	        Cols=7; 		    
	    }
	    if (j==3){
	        Rows=12;  
	        Cols=0;    
	    }
	    if (j==4){
	        Rows=12; 
	        Cols=7; 	    
	    }
	    if (j==5){
	        Rows=24;  
	        Cols=0; 		    
	    }
	    if (j==0){
	   	    Rows=24;
	   	    Cols=7;
	    } 
	   // alert(" "+j+"^"+Rows+"^"+Cols+"^"+tempcol)
	    xlsheet.cells(Rows+2,Cols+2)=tempcol[2]; //姓名
	    xlsheet.cells(Rows+2,Cols+4)=tempcol[3]; //性别
	    xlsheet.cells(Rows+2,Cols+6)=tempcol[4]; //年龄
	    //xlsheet.cells(Rows+3,Cols+3)=tempcol[13]; //电话
	    xlsheet.cells(Rows+3,Cols+3)=tempcol[15]; //体检号
	    xlsheet.cells(Rows+4,Cols+3)="*"+tempcol[1]+"*"; //编号或条码
	    xlsheet.cells(Rows+6,Cols+3)=PIADMName; //单位名称
	    xlsheet.cells(Rows+7,Cols+3)=tempcol[6]; //所属部门
	    //xlsheet.cells(Rows+1,Cols+1)=(myDate.getFullYear())+"年北京协和医院体检中心体检凭条";
		var HOSPID=session['LOGON.HOSPID'];
	    var HospitalName=""
	    var HospitalName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",HOSPID);
	    if(HospitalName.indexOf("[")>0) var HospitalName=HospitalName.split("[")[0]
	    xlsheet.cells(Rows+1,Cols+1)=(myDate.getFullYear())+"年"+HospitalName+"体检凭条";

	    xlsheet.cells(Rows+2,Cols+1)="姓名:";
	    xlsheet.cells(Rows+2,Cols+3)="性别:";
	    xlsheet.cells(Rows+2,Cols+5)="年龄:";
	    //xlsheet.cells(Rows+3,Cols+1)="联系电话:";
	    xlsheet.cells(Rows+3,Cols+1)="体检号:";
	    xlsheet.cells(Rows+4,Cols+1)="编号(或编码):";
	    xlsheet.cells(Rows+6,Cols+1)="单位名称：";
	    xlsheet.cells(Rows+7,Cols+1)="所属部门:";
	    xlsheet.cells(Rows+8,Cols+1)="★注:抽血时间:上午8:00---9:30";
	    xlsheet.cells(Rows+11,Cols+1)="预约网址:";
	    if(session['LOGON.CTLOCID']=='572')
	    {
		    xlsheet.cells(Rows+9,Cols+1)="体检地址:";
	    	xlsheet.cells(Rows+10,Cols+1)="体检电话:";    
		    xlsheet.cells(Rows+8,Cols+1)="★注:登记时间:上午7:45---10:00";
		}
		else
		{
			if
	 		(tempcol[14]=="2"){
		    	xlsheet.cells(Rows+9,Cols+1)="体检地址:";
	    		xlsheet.cells(Rows+10,Cols+1)="体检电话:";
	    	}else{
	    		xlsheet.cells(Rows+9,Cols+1)="体检地址:";
	    		xlsheet.cells(Rows+10,Cols+1)="体检电话:";
	    	}
		}
	    if(j==0){
		    //alert("ccc");
		    xlsheet.printout;
            for(m=1;m<40;m++){
	            for(n=1;n<20;n++){
		            xlsheet.cells(m,n)="";
		            }
	            }
		    }
	}
	/*
xlsheet.SaveAs("d:\\团体体检凭条.xls");
xlApp.Visible = true;
xlApp.UserControl = true;	
idTmr   =   window.setInterval("Cleanup();",1); 
*/
//alert(j+"aa");
 	if(j!=0){
	 
	xlsheet.printout;
	} 	
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null;

	idTmr   =   window.setInterval("Cleanup();",1); 
	
}

catch(e)
	{
		alert(e+"^"+e.message);
	}
	
	
}


// 打印导检单
function PatItemPrint() {
	if (CurrentSel==0) return;
	obj=document.getElementById("RowId");
	if (obj){ CRMId=obj.value; }
	if (CRMId=="") return;
	var DietFlag="TRUE"
	var Diet=document.getElementById('DietFlag');
	if (Diet) DietFlag=Diet.checked;
	
	var Ins=document.getElementById('GetAdmListBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,CRMId,"G");
	if (value=="") return;
	var AdmList=value.split("^");
	var i=AdmList.length;
	for (var iLLoop=0;iLLoop<i;iLLoop++)
	{
		var ID=AdmList[iLLoop]
		var Instring=ID+"^"+DietFlag+"^CRM";
		var Ins=document.getElementById('GetOEOrdItemBox');
		if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
		var value=cspRunServerMethod(encmeth,'','',Instring);
		//Print(value,iLLoop+1);
		Print(value,1);
	}
}
function PrintRisRequest() {
	if (CurrentSel==0) return;
	obj=document.getElementById("RowId");
	if (obj){ CRMId=obj.value; }
	if (CRMId=="") return;
	var DietFlag="TRUE"
	var Diet=document.getElementById('DietFlag');
	if (Diet) DietFlag=Diet.checked;
	
	var Ins=document.getElementById('GetAdmListBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,CRMId,"G");
	if (value=="") return;
	var AdmList=value.split("^");
	var i=AdmList.length;
	for (var iLLoop=0;iLLoop<i;iLLoop++)
	{
		var ID=AdmList[iLLoop]
		PrintRisRequestApp(ID,"","PreIADM")
	}
	
}
function PrintReportRJ()
{
	obj=document.getElementById("RowId");
	if (obj){ CRMId=obj.value; }
	if (CRMId=="") return;
	var DietFlag="TRUE"
	var Diet=document.getElementById('DietFlag');
	if (Diet) DietFlag=Diet.checked;
	
	var Ins=document.getElementById('GetAdmListBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,CRMId,"G");
	if (value=="") return;
	var AdmList=value.split("^");
	var i=AdmList.length;
	for (var iLLoop=0;iLLoop<i;iLLoop++)
	{
		var ID=AdmList[iLLoop]
		PrintReportRJApp(ID,"PreIADM");
	}
	
}
function CancelPE()
{
	if (!confirm(t["02"])) return;
	CancelPECommon('PGADM_RowIdz',"G",CurrentSel,0)
}
function UnCancelPE()
{
	var PGADM="",Status="";
	var SelRowObj=document.getElementById('PGADM_RowId'+'z'+CurrentSel);
	if(SelRowObj){var PGADM=SelRowObj.value;}
	if(PGADM==""){
		alert("未选择待撤销体检的人员");
		return false;
	}
	var SelRowObj=document.getElementById('PGADM_Status_Desc'+'z'+CurrentSel);
	if(SelRowObj){var Status=SelRowObj.innerText;}
	if(Status!="取消体检"){
		alert("不是取消体检状态,不能撤销取消体检");
		return false;
	}

	if (!confirm(t["02"])) return;
	CancelPECommon('PGADM_RowIdz',"G",CurrentSel,1)
}
function CancelPECommon(ElementName,Type,CurRow,DoType)
{
	var obj=document.getElementById(ElementName+CurRow);
	if (obj)
	{
		var Id=obj.value;
	}
	else
	{
		return false;
	}
	
	var obj=document.getElementById("CancelPEClass");
	if (obj)
	{
		var encmeth=obj.value;
	}
	else
	{
		return false;
	}
	var Ret=cspRunServerMethod(encmeth,Id,Type,DoType);
	Ret=Ret.split("^");
	alert(Ret[1]);
}

function Getinfody()
{  
var obj;
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPERGdy.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称

	 
    var Ins=document.getElementById('Getgroupinfo');
     
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth);
	
	var String=value.split(";");
	
	for (var i=0;i<String.length;i++){
	
		FData=String[i].split("^");	
		xlsheet.cells(6+i,1).Value=FData[0];
        xlsheet.cells(2,2).Value=FData[1];
		xlsheet.cells(3,2).Value=FData[2]; 
		xlsheet.cells(6+i,2).Value=FData[3]; 
		xlsheet.cells(6+i,3).Value=FData[4]; 
		xlsheet.cells(6+i,4).Value=FData[5]; 
        xlsheet.cells(6+i,5).Value=FData[6]; 

	}
	//xlsheet.printout;
	//xlBook.Close (savechanges=false);
	//xlApp=null;
	//xlsheet=null;
	
    xlsheet.SaveAs("d:\\团体打印.xls");
    xlApp.Visible = true;
    xlApp.UserControl = true;	
}

document.body.onload = BodyLoadHandler;

function LinkGFeeCat()
{
	var obj,iRowId
	obj=document.getElementById("RowId");
	if (obj){ iRowId=obj.value; }
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEGroupFeeCat&GroupID="+iRowId;
	var wwidth=560;
	var wheight=300;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
}

function GetCStatus() {
	var iCStatus="";
	obj=document.getElementById("Status_UNCHARGED");
	if (obj && obj.checked){ iCStatus=0; }
	obj=document.getElementById("Status_CHARGED");
	if (obj && obj.checked){ iCStatus=1;}
	obj=document.getElementById("Status_PartCHARGED");
	if (obj && obj.checked){ iCStatus=2;}
	return iCStatus;
}

function BExport_click()
{
	try{
	var obj;
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEGUncharged.xls';
	}else{
		alert("无效的打印模板路径");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application"); //??
	xlBook = xlApp.Workbooks.Add(Templatefilepath); //??
	xlsheet = xlBook.WorkSheets("Sheet1");
	
	obj=document.getElementById('GetRowNum');
		if(obj){NumStr=obj.value}
		var Num=NumStr.split("^")
		k=3
		for (j=0;j<Num.length;j++)
		{ 
			var Ins=document.getElementById('GetInfoBox');
		 if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
		 var DataStr=cspRunServerMethod(encmeth,Num[j]);
		 if (""==DataStr) { return false; }
		 //alert(DataStr);
		 var Data=DataStr.split("^")
		 xlsheet.cells(k+j,1)=Data[8]
		 xlsheet.cells(k+j,2)=Data[1] 
			xlsheet.cells(k+j,3)=Data[9] 
			xlsheet.cells(k+j,4)=Data[10]
			xlsheet.cells(k+j,5)=Data[2]
			xlsheet.cells(k+j,6)=Data[3]
			xlsheet.cells(k+j,7)=Data[6]	
			xlsheet.Range( xlsheet.Cells(k+j,1),xlsheet.Cells(k+j,7)).Borders.LineStyle = 1
       
			 
		} 
		obj=document.getElementById('savepath');
		if(obj){var SaveDir=obj.value}
		//"d:\????.xls";
		xlsheet.SaveAs(SaveDir);
		xlApp.Visible = true;
		xlApp.UserControl = true; 
	}
	catch(e)
	{
		alert(e+"^"+e.message);
	}
}

function PEComplete()
{
	
	
	var obj;
	obj=document.getElementById("RowId");
	if (obj){ var ID=obj.value;}
	else{return false;}
	if (ID=="") return false;
	obj=document.getElementById("PECompleteBox");
	if (obj) var encmeth=obj.value;
	var Return=cspRunServerMethod(encmeth,ID)
	if (Return==""){(alert("Update Success!"));
	window.location.reload();}
	
}
//预约到达日期
function AppointArrivedDate()

{
	
	var obj;
	var obj=document.getElementById("RowId");  
	if (obj) { var ID=obj.value; }
	if (""==ID) { return false;}
	var Type="G"
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEAppointArrivedDate"
			+"&ID="+ID+"&Type="+Type
	
	var wwidth=350;
	var wheight=200;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
	}
	
function PrintCashierNotes()
{
	
	var obj;
	var obj=document.getElementById("RowId");
	if (obj) { var ID=obj.value; }
	if (""==ID) { 
	 alert(t["NoRecord"])
	 return false;}
	var obj=document.getElementById('PGADM_PGBI_DR_Name'+'z'+CurrentSel);
	if (obj) var Name=obj.innerText;
	var Type="G"
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPrintCashierNotes"
			+"&ID="+ID+"&Name="+Name+"&Type="+Type
		var wwidth=350;
	var wheight=200;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
	}
function CancelCashierNotes()    
{     	var obj=""
        obj=document.getElementById('RowId');
       
		if(obj){
			var PGADM=obj.value
		 
			if (PGADM=="")
			{ alert(t["NoRecord"])
			  return;}
			
			}
         var Ins=document.getElementById('Cancel');
		 if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	
		 var Flag=cspRunServerMethod(encmeth,"G",PGADM,"");
         if (Flag==""){alert(t["CancelSuccess"])}
         if (Flag=="NoCashier"){alert(t["NoCashier"])} 
	
	
	}
function UpdatePreAudit()
{
	var Type="G";
	var obj;
	obj=document.getElementById("RowId");
	if (obj){ var ID=obj.value;}
	else{return false;}
	if (ID=="") return false;
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreAudit.Edit"
	//		+"&CRMADM="+ID+"&ADMType="+Type+"&GIADM=";
	var lnk="dhcpepreaudit.csp?CRMADM="+ID+"&ADMType="+Type+"&GIADM="+"&RowID=";
	var wwidth=800;
	var wheight=500;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
}
function PrintGroupItem_Click()
{ 
    try{
		var obj;
		obj=document.getElementById("prnpath");
		if (obj && ""!=obj.value) {
			var prnpath=obj.value;
			var Templatefilepath=prnpath+'DHCPEGroupPersonItem.xls';
		}else{
			alert("无效模板路径");
			return;
		}
		xlApp = new ActiveXObject("Excel.Application");  //固定
		xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
		xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称
		
	    var obj=document.getElementById("RowId");
	    if(obj)  {var PIADM=obj.value;} 
	  	if (PIADM=="")  return false;
	    
	    
	  	var obj=document.getElementById("GetGroupPersonBox");
	    if (obj) {var encmeth=obj.value} else{var encmeth=""}
	    var locType="";
	    var ExecFlag="";
	    var obj=document.getElementById("NoExceFlag");
	    if ((obj)&&(obj.checked)){
	    	ExecFlag="N";
	    }
	    var obj=document.getElementById("RecLoc");
	    if ((obj)&&(obj.checked)){
	    	locType="RecLoc";
	    }
	    var ReturnStr=cspRunServerMethod(encmeth,PIADM,locType,ExecFlag);
	    var IADMStr=ReturnStr.split("%")[1];
	    var ItemStr=ReturnStr.split("%")[0];
	    var String=ItemStr.split("&");
		var Cols=String.length;
		for (j=0;j<Cols;j++)
		  {
		   var ItemColData=String[j].split("^");
		   var Col=ItemColData[0];
		   var DataStr=ItemColData[1];
		 
		   xlsheet.cells(1,+Col).value=DataStr}
		   var IADM=IADMStr.split("^");
		   
	       var IADMRows=IADM.length;
	    
		var row=0;
	    for (k=0;k<IADMRows;k++)
	    {   
		    var obj=document.getElementById("GetGroupItemBox");
	        if (obj) {var encmeth=obj.value} else{var encmeth=""}
			
	        var FeeStr=cspRunServerMethod(encmeth,IADM[k]);
	        if (FeeStr==0) continue;
	        row=row+1;
	        var Str=FeeStr.split("&");
	
		    var FeeCols=Str.length;
		    for (i=0;i<FeeCols;i++)
		  {
		   var FeeColData=Str[i].split("^");
		   var FeeCol=FeeColData[0];
		   var FeeData=FeeColData[1];
		   xlsheet.cells(row+1,+FeeCol).value=FeeData
		  
		   }
		 
    	
	    }
	   
	    var n=row+2

	    var obj=document.getElementById("GetItemFeeBox");
	    if (obj) {var encmeth=obj.value} else{var encmeth=""}
	    var TotalFeeString=cspRunServerMethod(encmeth);
	    var TotalFeeStr=TotalFeeString.split("&");
		var TotalFeeCols=TotalFeeStr.length;
		for (i=0;i<TotalFeeCols;i++)
		  {
		   var TFeeColData=TotalFeeStr[i].split("^");
		   //alert(TFeeColData)
		   var TFeeCol=TFeeColData[0];
		   var TFeeData=TFeeColData[1];
		   xlsheet.cells(n,+TFeeCol).value=TFeeData}
    	   
	    
		var GroupDesc=""
		var obj=document.getElementById('RowId_Name');
		if (obj) GroupDesc=obj.value;
		xlsheet.SaveAs("d:\\"+GroupDesc+"费用清单.xls");
		//xlBook.Close (savechanges=false);
		//xlApp=null;
		//xlsheet=null;
	   xlApp.Visible = true;
	   xlApp.UserControl = true;
	 
	}
	    
    
	catch(e)
	{
		alert(e+"^"+e.message);
	}
}
function Contract_change()
{
	var obj=document.getElementById("ContractID");
	if (obj) obj.value="";
}
function ContractFindAfter(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	
	var obj=document.getElementById("Contract");
	if (obj) obj.value=Arr[2];
	var obj=document.getElementById("ContractID");
	if (obj) obj.value=Arr[0];
}

function HomeSet_Click()
{
	var obj,encmeth="",ID;
	
	obj=document.getElementById('RowId');
	if (obj) {
		var ID=obj.value; 
	}
	
	if (ID=="" || ID==undefined){
		return;	
	}
	//var repUrl="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreGADM.Home&PGADMDr="+ID+"&Type=G";
	//window.open(repUrl,"","dialogHeight: 600px; dialogWidth: 800px");
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreGADM.Home&PGADMDr="+ID+"&Type=G";
	var wwidth=900;
	var wheight=650;
	
	var xposition = (screen.width - wwidth) / 2;
	var yposition = ((screen.height - wheight) / 2)-10;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin) 


	

}

function InitRowObj(){
	
	var objtbl=document.getElementById('tDHCPEPreGADM_Find');
	if(objtbl){
		
		var rows=objtbl.rows.length;
		var lastrowindex=rows - 1;
		for (var i=1;i<=lastrowindex;i++){
			
			var Obj=document.getElementById("TMarkz"+i);
			if (Obj){
			      Obj.onblur=MarkBlurHandler; //事件在用户离开输入框时执行
			}

		}
   }
}

function MarkBlurHandler(e){
	
	var obj=websys_getSrcElement(e);
	var Row=GetEventRow(e);
	var Mark=obj.value;
	var Obj=document.getElementById("PGADM_RowIdz"+Row);
	if(Obj){var PGADM=Obj.value;}
	var rtn=tkMakeServerCall("web.DHCPE.PreGADM","UpDateGMark",PGADM,Mark)
	
}


function GetEventRow(e)
{
	var obj=websys_getSrcElement(e);
	var Id=obj.id;
	var arrId=Id.split("z");
	var Row=arrId[arrId.length-1];
	return Row;
}
