/// DHCPEPreIADM.Team.js

var CurrentSel=0
function BodyLoadHandler() {
	var obj;
	//团体组列表
	obj=document.getElementById("GTeamList");
	if (obj){ obj.onchange=TeamList_click; }
	
	//新建项目 BNewItem_click
	obj=document.getElementById("BNewItem");
	if (obj){ 
		obj.onclick=BNewItem_click; 
		websys_disable(obj);
	}
	//分组人员导入
	obj=document.getElementById("PreTImport");
	if (obj){ 
		obj.onclick = ReadInfo; 
		//obj.disabled=true;
	}
	//额外加项MLH
	obj=document.getElementById("BAddItem");
	if (obj){ 
		obj.onclick=AddItem_click; 
		websys_disable(obj);
		
	}
	//额外加项MLH
	obj=document.getElementById("BPreOver");
	if (obj){ 
		obj.onclick=CancelADM_click; 
		websys_disable(obj);
	}
	
	//新建小组成员             
	obj=document.getElementById("BNewIADM");
	if (obj){ 
		obj.onclick=BNewIADM_click;
		websys_disable(obj);
	}
	//删除小组成员
	obj=document.getElementById("BDelete");
	if (obj) { 
		obj.onclick=BDelete_click; 
		websys_disable(obj);
		
	}
	
	//打印个人团体个人体检凭条
	obj=document.getElementById("PrintTeamSelf");
	if (obj){ obj.onclick=PrintTeamSelf_click; }

	//撤销选取人员
	obj=document.getElementById("BCancelSelect");
	if (obj){ obj.onclick=BCancelSelect_click; }
	
	//登记号
	obj=document.getElementById('RegNo');
	if (obj) { obj.onchange = RegNoChange; }
	obj=document.getElementById('RegNo');
	if (obj) { obj.onkeydown = RegNo_keydown; }
	
	obj=document.getElementById("CardNo");
	if (obj) {
		obj.onchange=CardNo_Change;
		//obj.onkeydown=CardNo_KeyDown;
		 obj.onkeydown= CardNo_keydown;
	}

	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCard_Click;}
	
	//查询
	obj=document.getElementById("BFind");
	if (obj) {obj.onclick=BFind_Click;}

	//转组
	obj=document.getElementById("BMoveTeam");
	if (obj) {obj.onclick=BMoveTeam_Click;}

	
	iniForm();
	SetSort("tDHCPEPreIADM_Team","Sequence");
	// 打印 打印单
	DHCP_GetXMLConfig("InvPrintEncrypt","OEItemPrint");
	
	//卡类型
	initialReadCardButton()
}


//added by xy 20180427
function BMoveTeam_Click()
{
	var obj;
	var iRowId="";
	
	obj=document.getElementById("PIADM_RowId");
	if (obj && ""!=obj.value) { var iRowId=obj.value; }
	if(iRowId==""){
		alert("未选择转租人员");
		return false;
	}
	if (!confirm("是否确定转组")) return false;
	
	var flag=tkMakeServerCall("web.DHCPE.CancelPE","CheckIAdmCanCancel",iRowId);
	if(flag=="1") {
		alert("存在已执行或者已交费的项目,不能转组");
		return false;
	}
	
	obj=document.getElementById("PGADM_DR");
	if (obj) { var iPGADM=obj.value; }
	
	obj=document.getElementById("GTeam");
	if (obj) { var iGTeam=obj.value; }
   
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEMoveTeam"
	+"&ParRef="+iPGADM
	+"&PIADMRowId="+iRowId
	+"&PGTeam="+iGTeam
	;
	
	var wwidth=560;
	var wheight=300;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin);
}

function CardNo_keydown(e)
{
	var key=websys_getKey(e);
	if (13==key) {
		CardNo_Change();
	}
}

function CardNo_Change()
{
	CardNoChangeApp("RegNo","CardNo","RegNoChange()","Clear_click()","0");
}
function ReadCard_Click()
{
	ReadCardApp("RegNo","RegNoChange()","CardNo");
	
}
//团体打印单个人员体检凭条方法
function PrintTeamSelf_click()
{
	var rows;
	var objtbl=document.getElementById('tDHCPEPreIADM_Team');
	if (objtbl){
		rows=objtbl.rows.length;
	}
	var iRowID="";
	//alert(rows)
	for (var i=1;i<rows;i++)
	{	
		chkobj=document.getElementById('TSelect'+'z'+i);		
		if ((chkobj)&&(chkobj.checked))
		{
			var RowIDObj=document.getElementById('PIADM_RowId'+'z'+i);
			if (RowIDObj){
				var RowID=RowIDObj.value;
				if (iRowID==""){
					iRowID=RowID
				}else{
					iRowID=iRowID+"^"+RowID;
				}
			}
		}
	}
	PrintGPerson_click(iRowID)
	
}
function PrintGPerson_click(iRowIDStr)
{
	
	try{
	var obj;
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPrintTeamPerson.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称

    var myDate = new Date();
    myDate.getFullYear();
    
    var obj=document.getElementById("DateBox");
    if (obj) {var encmeth=obj.value} else{var encmeth=""}
    
   	var temprow=iRowIDStr.split("^");
   	if(temprow=="")
   	{
		alert("您没有选择任何一个人员!")
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
	        Rows=11;  
	        Cols=0;    
	    }
	    if (j==4){
	        Rows=11; 
	        Cols=7; 	    
	    }
	    if (j==5){
	        Rows=22;  
	        Cols=0; 		    
	    }
	    if (j==0){
	   	    Rows=22;
	   	    Cols=7;
	    }
	    xlsheet.cells(Rows+2,Cols+2)=tempcol[2]; //姓名
	    xlsheet.cells(Rows+2,Cols+4)=tempcol[3]; //性别
	    xlsheet.cells(Rows+2,Cols+6)=tempcol[4]; //年龄
	    xlsheet.cells(Rows+3,Cols+3)=tempcol[13]; //电话
	    xlsheet.cells(Rows+4,Cols+3)="*"+tempcol[1]+"*"; //编号或条码
	    xlsheet.cells(Rows+6,Cols+3)=tempcol[9] //PIADMName; //单位名称
	    xlsheet.cells(Rows+7,Cols+3)=tempcol[6]; //所属部门
	    
		    
		var HOSPID=session['LOGON.HOSPID'];
	    var HospitalName=""
	    var HospitalName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",HOSPID);
	    if(HospitalName.indexOf("[")>0) var HospitalName=HospitalName.split("[")[0]
	    xlsheet.cells(Rows+1,Cols+1)=(myDate.getFullYear())+"年"+HospitalName+"体检凭条";
	   
	    //xlsheet.cells(Rows+1,Cols+1)=(myDate.getFullYear())+"年北京协和医院体检中心体检凭条";
	    xlsheet.cells(Rows+2,Cols+1)="姓名:";
	    xlsheet.cells(Rows+2,Cols+3)="性别:";
	    xlsheet.cells(Rows+2,Cols+5)="年龄:";
	    xlsheet.cells(Rows+3,Cols+1)="联系电话:";
	    xlsheet.cells(Rows+4,Cols+1)="编号(或编码):";
	    xlsheet.cells(Rows+6,Cols+1)="单位名称：";
	    xlsheet.cells(Rows+7,Cols+1)="所属部门:";
	    xlsheet.cells(Rows+8,Cols+1)="★注:抽血时间:上午8:00---9:30";
	   if(session['LOGON.CTLOCID']=='572')
	    {
		    xlsheet.cells(Rows+9,Cols+1)="体检地址:";
	    	xlsheet.cells(Rows+10,Cols+1)="体检电话:";    
		    
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
function CancelADM_click() {
	var Src=window.event.srcElement;
	if (Src.disabled) { return false; }
	Src.disabled=true;
	var obj;
	var iRowId="",iStatus="PREREGED",iUpdateUserDR="";
	var Instring="";
	if (Src.innerHTML.substr(Src.innerHTML.length-4,4)=="取消完成") iStatus="PREREG"
	obj=document.getElementById("PIADM_RowId");
	if (obj && ""!=obj.value) { iRowId=obj.value; }
	iUpdateUserDR==session['LOGON.USERID'];
	
	Instring=iRowId+"^"+iStatus+"^"+iUpdateUserDR;
	
	var Ins=document.getElementById('BUpdateStatus');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring)

	if ('0'==flag) {
		//alert("Update Success!");
		location.reload();
	}
	else if ('NoItem'==flag)
	{
		alert(t[flag])
	}	
	else
	{
		alert(t["02"]);
	}
	
}
function iniForm() {
	var iGTeam="",TeamName="";
	var obj;
	
	obj=document.getElementById("Status");
	if (obj) { SetStatus(obj.value); }

	
	//根据当前页面类型?显示可操作的功能
	obj=document.getElementById("OperType");
	
	// 编辑
	if (obj && "E"==obj.value){

		//登记号
		obj=document.getElementById("RegNo");
		if (obj) { obj.style.display = "inline"; }
		obj=document.getElementById("cRegNo");
		if (obj) { obj.style.display = "inline"; }
		
		//姓名
		obj=document.getElementById("Name");
		if (obj) { obj.style.display = "inline";}
		obj=document.getElementById("cName");
		if (obj) { obj.style.display = "inline"; }
		obj=document.getElementById("ld50577iName");
		if (obj) { obj.style.display = "inline"; }

		//新建人员
		obj=document.getElementById("BNewIADM");
		//if (obj) { obj.style.display = "inline"; }		

		//新建项目
		obj=document.getElementById("BNewItem");
		if (obj) { 
			//obj.style.display = "inline";
			if (session['LOGON.GROUPDESC']=="体检主任"){
				//obj.style.display = "inline";
			}
		}

		//额外加项
		obj=document.getElementById("BAddItem");
		//if (obj) { obj.style.display = "inline"; }

		
		//新建项目
		obj=document.getElementById("BDelete");
		//if (obj) { obj.style.display = "inline"; }
		
		//完成预约
		obj=document.getElementById("BPreOver");
		//if (obj) { obj.style.display = "inline"; }
		obj=document.getElementById("ld50577iName");
		if (obj) { obj.style.display = "none"; }
			
	}
	
	
		
	//obj=document.getElementById("OperType");
	// 查询
	if (obj && "Q"==obj.value){
		//登记号
		obj=document.getElementById("RegNo");
		if (obj) { obj.style.display = "inline"; }
		obj=document.getElementById("cRegNo");
		if (obj) { obj.style.display = "inline"; }
		
		//姓名
		obj=document.getElementById("Name");
		if (obj) { obj.style.display = "inline";}
		obj=document.getElementById("cName");
		if (obj) { obj.style.display = "inline"; }
		
		obj=document.getElementById("ld50577iName");
		if (obj) { obj.style.display = "inline"; }
		
		//新建项目
		obj=document.getElementById("BNewItem");
		if (obj) { obj.style.display = "none"; }
		//额外加项
		obj=document.getElementById("BAddItem");
		if (obj) { obj.style.display = "none"; }
		
		//完成预约
		obj=document.getElementById("BPreOver");
		if (obj) { obj.style.display = "none";}
		
		//新建人员
		obj=document.getElementById("BNewIADM");
		if (obj) { obj.style.display = "none"; }
		
		//选取已有人员
		obj=document.getElementById("BSelectPre");
		if (obj) { obj.style.display = "none"; }
		
	}
	// 中间加项
	if (obj && "T"==obj.value){
		//新建项目
		obj=document.getElementById("BNewItem");
		if (obj) { obj.style.display = "inline"; }
		//额外加项
		obj=document.getElementById("BAddItem");
		if (obj) { obj.style.display = "inline"; }
		
		//完成预约
		obj=document.getElementById("BPreOver");
		if (obj) { obj.style.display = "inline";}
		
		//新建人员
		obj=document.getElementById("BNewIADM");
		if (obj) { obj.style.display = "inline"; }
		
		//登记号
		obj=document.getElementById("RegNo");
		if (obj) { obj.style.display = "inline"; }
		obj=document.getElementById("cRegNo");
		if (obj) { obj.style.display = "inline"; }
		
		//姓名
		obj=document.getElementById("Name");
		if (obj) { obj.style.display = "inline";}
		obj=document.getElementById("cName");
		if (obj) { obj.style.display = "inline"; }
		
		obj=document.getElementById("ld50577iName");
		if (obj) { obj.style.display = "inline"; }	
	}
			
	// 显示当前页面的分组
	obj=document.getElementById("GTeamList");
	if (obj) { 
		var TeamName=obj.value; 
	}
	
	if (TeamName=="" ) TeamName="请选择分组"
	obj=document.getElementById("CGName");
	if (obj) { 
		obj.innerText=TeamName; 
	}
	//ShowCurRecord(1);
}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

// //////////////////////////////////////////////////////////////////////////////
//选择团体组 查询团体组客户
function TeamList_click() {
	
	var obj;
	var iGTeam="";
	var iParRef="",iParRefName="";
	
	//团体组编码
	obj=document.getElementById("GTeamList");
	if (obj) {
		iGTeam=obj.value; 
		if (""==iGTeam) { return false; }
	}
	
	//团体编码
	obj=document.getElementById("ParRef");
	if (obj) { iParRef=obj.value; }
	
	//团体名称
	obj=document.getElementById("ParRefName");
	if (obj) { iParRefName=obj.value; }
	
	//目标组件
	var tForm="";
	obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	var iOperType="";
	obj=document.getElementById("OperType");
	if (obj){ iOperType=obj.value; }
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+tForm
			+"&GTeam="+iGTeam
			+"&GTeamName="+iGTeamName
			+"&ParRef="+iParRef
			+"&ParRefName="+iParRefName
			+"&OperType="+iOperType
			;
	
	location.href=lnk;
}

// ////////////////////////////////////////////////////////////////////////
function RegNo_keydown(e) {

	var key=websys_getKey(e);
	if ( 13==key) {
		RegNoChange()
	}

	
}
function RegNoChange()
{
	var obj;
		
		obj=document.getElementById("BNewIADM");
		if (obj){ 
				 websys_disable(obj);
		    }
		
		
		var iRegNo="";
		obj=document.getElementById('RegNo');
		if (!obj)                           //Add 20080708
   		{                                   //Add 20080708
			return false;                  //Add 20080708
   		}
   		else if (obj && ""!=obj.value) { 
			iRegNo = obj.value;
			iRegNo = RegNoMask(iRegNo);
		}
		else { 
			SetPreIBaseInfo();         //Add 20080708
			return false; 
		}		
		//add
		var encmethObj=document.getElementById("GetPIBIIDByADM");
		if (encmethObj && ""!=encmethObj.value){
			encmeth=encmethObj.value;
			var IBaseInfoID=cspRunServerMethod(encmeth,iRegNo);
			if (IBaseInfoID==""){
				obj=document.getElementById('RegNo');
				obj.value="";
				obj=document.getElementById('CardNo');
				obj.value="";
				obj=document.getElementById("Name");
				if (obj) { obj.value=""; }	
				alert(t["01"]);
				return false;
			}
		}
		else{
			return false;
		}
		//end
		iRegNo="^"+iRegNo+"^";
		FindPatDetail(iRegNo);
}
//	ID 格式 RowId^PAPMINo^Name
function FindPatDetail(ID){
	var Instring=ID;

	var Ins=document.getElementById('GetDetail');
	if (Ins) { var encmeth=Ins.value} else {var encmeth=''};

	var flag=cspRunServerMethod(encmeth,'SetPatient_Sel','',Instring+"$"+m_SelectCardTypeRowID);

}

//
function SetPatient_Sel(value) {

	var obj;
	var Data=value.split("^");
	var iLLoop=0;
	
	iRowId=Data[iLLoop];
	iLLoop=iLLoop+1;
	
	if ("0"==iRowId){
		//	PIBI_PAPMINo	登记号	1
		obj=document.getElementById("PIBI_RowId");
		if (obj) { obj.value=""; }	
	
		obj=document.getElementById("RegNo");
		if (obj) { obj.value=""; }
		
		alert("无效登记号!");
		
		return false;
	};
	obj=document.getElementById("PIBI_RowId");
	if (obj) { obj.value=Data[0]; }
	
	obj=document.getElementById("RegNo");
	if (obj) { obj.value=Data[1]; }	
	
	obj=document.getElementById("Name");
	if (obj) { obj.value=Data[2]; }			
	obj=document.getElementById("CardNo");
	//if (obj) { obj.value=Data[Data.length-1]; }	
	if (obj) { obj.value=Data[Data.length-4]; }
	obj=document.getElementById("BNewIADM");
	if (obj){ 
		websys_enable(obj,BNewIADM_click);
	 }	
	
	websys_setfocus('BNewIADM');
	
}

// 团体成员修改预约信息?预约日期?预约时间? 返回修改当前页面的预约时间
function ChilidWindowReturn(value) {
	
	if (""==value ) { return false;} 
	var Values=value.split("^");

	var SelRowObj,obj,objtbl;
	
	objtbl=document.getElementById("tDHCPEPreIADM_Team");
	if (!(objtbl)) { return false;}
	
	for (var iLLoop=0;iLLoop<=objtbl.rows.length-1;iLLoop++) {

		
		SelRowObj=document.getElementById('PIADM_RowId'+'z'+iLLoop);

		if (SelRowObj && ""!=SelRowObj.value && Values[0]==SelRowObj.value){
			SelRowObj=document.getElementById('PIADM_PEDate'+'z'+iLLoop);
			if (SelRowObj) {SelRowObj.innerText=Values[1]; }
			SelRowObj=document.getElementById('PIADM_PETime'+'z'+iLLoop);
			if (SelRowObj) {SelRowObj.innerText=Values[2]; }
		}
	
	}
}
//按姓名查找/添加团体组受检人
function SearchName(value){
	
	obj=document.getElementById("BNewIADM");
	if (obj){ websys_disable(obj);
	 	 }
	
	if (""==value) { return false;}
	
	var obj;
	var Data=value.split("^");

	obj=document.getElementById("Name");
	if (obj) { obj.value=Data[0]; }	
	
	obj=document.getElementById("RegNo");
	if (obj) { obj.value=Data[1]; }	
	
		
	obj=document.getElementById("PIBI_RowId");
	if (obj) { obj.value=Data[2]; }
	
	obj=document.getElementById("BNewIADM");
	if (obj){ websys_enable(obj,BNewIADM_click);
			}
	websys_setfocus('BNewIADM');

}
// ///////////////////////////////////////////////////////////////////////////////

// ///////////////////////////////////////////////////////////////////////////////
//当前客户新增项目
function BNewItem_click() {
	
	//var eSrc=window.event.srcElement;
	var eSrc=document.getElementById("BNewItem");
	if (eSrc.disabled) { return false;}
	/*
	var iRowId="";
	var obj=document.getElementById("PIADM_RowId");
	if (obj) { iRowId=obj.value; }
	*/
	var iRowId=GetSelectADM();
	if (""==iRowId) { 
	
	
	}
	if (""==iRowId) { return false;}
	
	var PreOrAdd="PRE"  //是否公费加项
	
	var lnk="dhcpepreitemlist.main.csp"+"?AdmType=PERSON"
			+"&AdmId="+iRowId+"&PreOrAdd="+PreOrAdd
			;
	var wwidth=1000;
	var wheight=600; 
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes, '
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	window.open(lnk,"_blank",nwin)	

	return true;
}

//额外加项---MLH
function AddItem_click() {
	var eSrc=document.getElementById("BAddItem");
	if (eSrc.disabled) { return false;}
	/*
	var iRowId="";
	var obj=document.getElementById("PIADM_RowId");
	if (obj) { iRowId=obj.value; }
	*/
	var iRowId=GetSelectADM();
	if (""==iRowId) { return false;}
	var PreOrAdd="ADD" //是否公费加项
	
	var lnk="dhcpepreitemlist.main.csp"+"?AdmType=PERSON"
			+"&AdmId="+iRowId+"&PreOrAdd="+PreOrAdd
			;
	var wwidth=1000;
	var wheight=600; 
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes, '
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	window.open(lnk,"_blank",nwin)	

	return true;
}


// ///////////////////////////////////////////////////////////////////////////////
// 增加组人员
function BNewIADM_click() {

	var eSrc=document.getElementById("BNewIADM");
	if (eSrc.disabled) { return false;}	

	var iRowId="";
	var iPIBIDR="", iPGADMDR="", iPGTeamDR="", iPEDateBegin="", iPEDateEnd="", iPETime="", iPEDeskClerkDR="", 
		iStatus="", iAsCharged="", iAccountAmount="", iDiscountedAmount="", iSaleAmount="", 
		iFactAmount="", iAuditUserDR="", iAuditDate="", iUpdateUserDR="", iUpdateDate=""
		iChargedStatus="", iCheckedStatus="", iAddOrdItem="", iAddOrdItemLimit="", 
		iAddOrdItemAmount="", iAddPhcItem="", iAddPhcItemLimit="", iAddPhcItemAmount="", 
		iIReportSend="", iDisChargedMode=""
		;
	var obj;

	// 0
	//obj=document.getElementById("PIADM_RowId");
	//if (obj) { iRowId=obj.value; }
	iRowId="";
	
	//预登记个人基本信息号 PIADM_PIBI_DR 1
	obj=document.getElementById("PIBI_RowId");
	//obj=document.getElementById("PIBI_DR");
	if (obj) { iPIBIDR=obj.value; }
	
	//对应团体的ADM PIADM_PGADM_DR 2
	obj=document.getElementById("ParRef");
	if (obj) { 
		iPGADMDR=obj.value;
		if (""==iPGADMDR) {
			//无效团体组
			alert(t["Err 06"]);
			return false;
		}
	}

	//对应组ADM PIADM_PGTeam_DR 3
	obj=document.getElementById("GTeam");
	if (obj) { 
		iPGTeamDR=obj.value;
		if (""==iPGTeamDR) {
			//无效团体组
			alert(t["Err 08"]);
			return false;
		} 
		
	}
	
	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,iPIBIDR,iPGADMDR,iPGTeamDR)
	if (flag=="Err Audit")
	{
		alert(t[flag]);
		return false;
	}
	
	if (""==iRowId) { 
		var Rets=flag.split("^");
		flag=Rets[0];
		
	}
	if ('0'==flag) {
		//alert("Update Success!");
		//alert(t['info 01']);
		location.reload(); 
	}
	else if ('Err 07'==flag) {
		//alert("受检人在团体或团体组已存在")
		alert(t['Err 07']);
		return false;		
	}
	else if ('Err 09'==flag) {
		//alert("增加团体组成员失败")
		alert(t['Err 09']+":"+Rets[1]);
		return false;		
	}
	else {
		//alert("Insert error.ErrNo="+flag);
		alert(t['02']+flag);
		return false;
	}
	websys_setfocus('RegNo');
	// 刷新页面
	return true;
	
}

function BDelete_click() {
	//var eSrc=window.event.srcElement;
	var eSrc=document.getElementById("BDelete");
	if (eSrc.disabled) { return false;}	
	
	var iRowId="";
	var iDType="0"; //删除类型
	var InString="";
	
	var obj;

	var obj=document.getElementById("PIADM_RowId");
	if (obj) { iRowId=obj.value; }

	if (""==iRowId) {
		//alert("Please select the row to be deleted.");
		alert(t["03"]);
		return false;
	}
	InString=iDType+"^"+iRowId;

	//if (confirm("Are you sure delete it?")){
	if (confirm(t["04"])) {
			var Ins=document.getElementById('DeleteBox');
			if (Ins) {var encmeth=Ins.value; } 
			else {var encmeth=''; };

			var flag=cspRunServerMethod(encmeth,'','',InString);
			if (flag=='0') {}
			else{
				//alert("Delete error.ErrNo="+flag)
				alert(t['05']+flag)
			}
			location.reload();
	}
}

function ShowCurRecord(CurRecord) {

	var selectrow=CurRecord;
	if (CurRecord==0)
	{
		//按钮 新建项目
		obj=document.getElementById("BNewItem");
		if (obj){ 
				websys_disable(obj);
		}
		//额外加项
		obj=document.getElementById("BAddItem");
		if (obj){ 
				websys_disable(obj);
		}
		
		//新建项目
		obj=document.getElementById("BDelete");
		if (obj){ 
				websys_disable(obj);
		}
		//完成预约
		obj=document.getElementById("BPreOver");
		if (obj){ 
				websys_disable(obj);
		 }
		return;
	}
	var SelRowObj;
	var obj;
	SelRowObj=document.getElementById('PIADM_RowId'+'z'+selectrow);
	obj=document.getElementById("PIADM_RowId");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }
	else{ obj.value=""; }
	obj=document.getElementById('TStatus'+'z'+selectrow);
	if (obj) Status=obj.value;
	obj=document.getElementById('TSelect'+'z'+selectrow);
	if (obj) obj.checked=true;
	//REGISTERED
	if (Status=="PREREG")
	{
		//按钮 新建项目
		obj=document.getElementById("BNewItem");
		if (obj){ 
			websys_enable(obj,BNewItem_click);
		
		 }
		//额外加项
		obj=document.getElementById("BAddItem");
		if (obj){ 
			websys_enable(obj,AddItem_click);
		}
		
		//新建项目
		obj=document.getElementById("BDelete");
		if (obj){ 
			websys_enable(obj,BDelete_click);
		  }
		//完成预约
		obj=document.getElementById("BPreOver");
		if (obj){ 
		obj.innerHTML="<img SRC='../images/websys/update.gif' BORDER='0'>预约完成"
		 websys_enable(obj,CancelADM_click);
		 
		}
	}
	if (Status=="PREREGED")
	{
		//按钮 新建项目
		obj=document.getElementById("BNewItem");
		if (obj){ websys_enable(obj,BNewItem_click);
		}
		//额外加项
		obj=document.getElementById("BAddItem");
		if (obj){ websys_enable(obj,AddItem_click);
		 }
		
		//
		obj=document.getElementById("BDelete");
		if (obj){ 
				websys_disable(obj);
		}
		//完成预约
		obj=document.getElementById("BPreOver");
		if (obj){ 
		obj.innerHTML="<img SRC='../images/websys/update.gif' BORDER='0'>取消完成"
		 websys_enable(obj,CancelADM_click);
		}
	}
	
	if ((Status=="ARRIVED")||(Status=="REGISTERED"))
	{
		//按钮 新建项目
		obj=document.getElementById("BNewItem");
		if (obj){ websys_enable(obj,BNewItem_click);
		}
		//额外加项
		obj=document.getElementById("BAddItem");
		if (obj){ websys_enable(obj,AddItem_click);
		 }
		
		//新建项目
		obj=document.getElementById("BDelete");
		if (obj){ websys_disable(obj);
		}
		//完成预约
		obj=document.getElementById("BPreOver");
		if (obj){ 
		obj.innerHTML="<img SRC='../images/websys/update.gif' BORDER='0'>预约完成"
		 websys_disable(obj);
		}
	}
	if (Status=="CANCELPREREG")
	{
		//按钮 新建项目
		obj=document.getElementById("BNewItem");
		if (obj){ websys_enable(obj,BNewItem_click);
		}
		//额外加项
		obj=document.getElementById("BAddItem");
		if (obj){ websys_enable(obj,AddItem_click);
		}
		
		//新建项目
		obj=document.getElementById("BDelete");
		if (obj){ websys_enable(obj,BDelete_click);
		}
		//完成预约
		obj=document.getElementById("BPreOver");
		if (obj){
		obj.innerHTML="<img SRC='../images/websys/update.gif' BORDER='0'>预约完成"
		websys_enable(obj,CancelADM_click);
		 
		}
	}
	if (Status=="CANCELARRIVED")
	{
		obj=document.getElementById("BNewItem");
		if (obj){websys_disable(obj);
		}
		//obj.innerHTML="<img SRC='../images/websys/update.gif' BORDER='0'>预约"}
		obj=document.getElementById("BAddItem");
		if (obj) {websys_disable(obj);
		}
		obj=document.getElementById("BDelete");
		if (obj) {websys_disable(obj);
		}
		obj=document.getElementById("BPreOver");
		if (obj) {websys_disable(obj);
		}
	}
	return
	
	
	
	if (""!=obj.value) {
		//按钮 新建项目
		obj=document.getElementById("BNewItem");
		if (obj){ websys_enable(obj,BNewItem_click); }
		//额外加项
		obj=document.getElementById("BAddItem");
		if (obj){ websys_enable(obj,AddItem_click); }
		
		//新建项目
		obj=document.getElementById("BDelete");
		if (obj){ websys_enable(obj,BDelete_click); }
	}
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
	if (CurrentSel==selectrow)
	{
		CurrentSel=0
	}
	else
	{
		CurrentSel=selectrow;
	}
	ShowCurRecord(CurrentSel);

}

// 打印导检单
function PatItemPrint() {
	if (CurrentSel==0) return;
	obj=document.getElementById("PIADM_RowId");
	if (obj){ CRMId=obj.value; }
	if (CRMId=="") return;
	var DietFlag="TRUE"
	var Diet=document.getElementById('DietFlag');
	if (Diet) DietFlag=Diet.checked;
	var Instring=CRMId+"^"+DietFlag+"^CRM";
			
	var Ins=document.getElementById('GetOEOrdItemBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,'','',Instring);
	Print(value);
		
}
function CancelPE()
{
	if (!confirm(t["06"])) return;
	//CancelPECommon('PIADM_RowIdz',"I",CurrentSel,0)
	var flag=0;
	var CancelFlag=0;
	var Id="";
	
	var obj=document.getElementById("tDHCPEPreIADM_Team"); 
	if(obj) {var row=obj.rows.length;}
	
	for (var iLLoop=1;iLLoop<=row;iLLoop++) {
		var obj=document.getElementById('TSelectz'+iLLoop); 
		if(obj && obj.checked){var  flag=1;}
		else {continue;}
		
		var obj=document.getElementById('PIADM_RowIdz'+iLLoop);
		if (obj){var Id=obj.value;}
		if (Id=="") {continue;}
		
		var obj=document.getElementById("CancelPEClass");
		if (obj){var encmeth=obj.value;}
		else{return false;}

		var Ret=cspRunServerMethod(encmeth,Id,"I","0");
		
		if (Ret[1]!="完成取消体检操作")
	   {  CancelFlag=1;   
	   }
	}
	//alert("flag:"+flag)
	if (flag=="1"){
	if (CancelFlag=="0") 
	 {alert("完成取消体检操作");} 
    window.location.reload();}
    else{alert("请先选择需要取消体检的客户");}
    
}


function UnCancelPE()
{
	if (!confirm(t["02"])) return;
	CancelPECommon('PIADM_RowIdz',"I",CurrentSel,0)
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

function SetSort(TableName,ItemName)
{
	var objtbl=document.getElementById(TableName);	
	
	if (objtbl) { var rows=objtbl.rows.length; }
	for (var j=1;j<rows;j++)
	{
		var obj=document.getElementById(ItemName+"z"+j);
		if (obj) obj.innerText=j;	
	}
}
//客户信息
function SetPreIBaseInfo() {
	var obj;
	var PAPMINo;
	var name
	
	//	PIBI_PAPMINo	登记号	1
	obj=document.getElementById("RegNo");
	if (obj) { var PAPMINo=obj.value;}	

	//	PIBI_Name	姓名	2
	obj=document.getElementById("Name");	
	//alert("IDCardSave:"+IDCardSave);
	var ParRef=""
	obj=document.getElementById("ParRef");
	if (obj) { ParRef=obj.value;}
	
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreIBaseInfo.Edit"
		+"&PAPMINo="+"&IDCard="+"&ReturnComponent=DHCPEPreIADM.Team"
		+"&GTeam="+ParRef+"&ComponentName=DHCPEPreIADM.Team";
		
	var wwidth=800;
	var wheight=600; 
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes'
		+',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
		;
	window.open(lnk,"_blank",nwin)	
	return false;
}

function SetPatInfo(regno)
{
	obj=document.getElementById("RegNo");
	if (obj) { obj.value=regno;}	
	if (regno!="") RegNoChange();
	
}
function GetSelectADM()
{
	var IDs=""
	var objtbl=document.getElementById("tDHCPEPreIADM_Team");		
	if (objtbl) { var rows=objtbl.rows.length; }
	for (var i=1;i<rows;i++)
	{
		var obj=document.getElementById("TSelectz"+i);
		if (obj&&obj.checked){
			var obj=document.getElementById("PIADM_RowIdz"+i);
			if (obj) ID=obj.value;
			if (IDs==""){
				IDs=ID
			}else{
				IDs=IDs+"^"+ID
			}
		}
	}
	if (IDs==""){
		var obj=document.getElementById("PIADM_RowId");
		if (obj) { IDs=obj.value; }
	}
	return IDs
}
function PrintRisRequest()
{
	var PreIADMDR="";
	var obj=document.getElementById("PIADM_RowId");  
	if (obj){ PreIADMDR=obj.value; }
	if (PreIADMDR=="") return ;
	PrintRisRequestApp(PreIADMDR,"","PreIADM");
	return false;
}
function BCancelSelect_click()
{
	var PreIADMDR="";
	var obj=document.getElementById("PIADM_RowId");  
	if (obj){ PreIADMDR=obj.value; }
	if (PreIADMDR=="") return ;
	var ret=tkMakeServerCall("web.DHCPE.SelectPreInfo","Cancel",PreIADMDR);
	var Arr=ret.split("^");
	if (Arr[0]==0){
		window.location.reload();
	}else{
		alert(arr[1])
	}
}
function UpdatePreAudit()
{
	alert("分组人员费用请在个人预约查询界面查看");
	return false;
}

function BFind_Click()
{
	var obj;
	var iGTeam="",iRegNo="",iName="",iDepartName="",iOperType="",iStatus="";
	
	obj=document.getElementById("GTeam");
	if (obj){ 
		iGTeam=obj.value;
	}
	obj=document.getElementById("RegNo");
	if (obj){ 
		iRegNo=obj.value;
	}
	obj=document.getElementById("Name");
	if (obj){ 
		iName=obj.value;
	}
	obj=document.getElementById("DepartName");
	if (obj){ 
		iDepartName=obj.value;
	}
	obj=document.getElementById("OperType");
	if (obj){ 
		iOperType=obj.value;
	}
	iStatus=GetStatus();
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreIADM.Team"
			+"&GTeam="+iGTeam
			+"&RegNo="+iRegNo
			+"&Name="+iName
			+"&DepartName="+iDepartName
			+"&OperType="+iOperType
			+"&Status="+iStatus
			;
			//alert(lnk)
	location.href=lnk;
	
}

function GetStatus() {
	var obj;
	var iStatus="";

	// PREREG 预约
	obj=document.getElementById("PREREG");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"PREREG"; }

	// REGISTERED 登记
	obj=document.getElementById("REGISTERED");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"REGISTERED"; }
	
	// REGISTERED 到达
	obj=document.getElementById("ARRIVED");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"ARRIVED"; }
	
	iStatus=iStatus+"^"
	return iStatus;
}


function SetStatus(Status) {
	var obj;
	var values=Status.split(":");
	var value=values[0];
		
	// PREREG 预约
	obj=document.getElementById("PREREG");
	if (obj) {
		if (value.indexOf("^PREREG^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
	
	// REGISTERED 登记
	obj=document.getElementById("REGISTERED");
	if (obj) {
		if (value.indexOf("^REGISTERED^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
	// REGISTERED 到达
	obj=document.getElementById("ARRIVED");
	if (obj) {
		if (value.indexOf("^ARRIVED^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
	
		
		
}

document.body.onload = BodyLoadHandler;