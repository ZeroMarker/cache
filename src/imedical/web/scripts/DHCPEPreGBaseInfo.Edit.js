/// DHCPEPreGBaseInfo.Edit.js
/// 创建时间		2006.06.06
/// 创建人		xuwm
/// 主要功能		?预登记?团体客户基本信息表
/// 对应表		DHC_PE_PreGBaseInfo
/// 最后修改时间	
/// 最后修改人	
/// 完成

var FRegNo="";

function BodyLoadHandler() {

	var obj;
	//更新
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	
	//删除
	obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click; }
	
	//清除
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }
	
	//单位编码	PGBI_Code	1
	obj=document.getElementById('Code');
	if (obj) { 
		obj.onkeydown = Code_keydown;
		obj.onchange=CodeChange;
	}
	
	//
	obj=document.getElementById('PAPMINo');
	if (obj) { 
		obj.onchange = PAPMINoChange;
		obj.onkeydown= PAPMINo_keydown;
	}
	
	//描    述	PGBI_Desc	2
	obj=document.getElementById('Desc');
	if (obj) { obj.onkeydown = nextfocus; }

	//地    址	PGBI_Address	3
	obj=document.getElementById('Address');
	if (obj) { obj.onkeydown = nextfocus; }
	
	//邮政编码	PGBI_Postalcode	4
	obj=document.getElementById('Postalcode');
	if (obj) { obj.onkeydown = nextfocus; }
	
	//联系人	PGBI_Linkman1	5
	obj=document.getElementById('Linkman1');
	if (obj) { obj.onkeydown = nextfocus; }
	
	//业务银行	PGBI_Bank	6
	obj=document.getElementById('Bank');
	if (obj) { obj.onkeydown = nextfocus; }
	
	//帐    号	PGBI_Account	7
	obj=document.getElementById('Account');
	if (obj) { obj.onkeydown = nextfocus; }
	
	//联系电话1	PGBI_Tel1	8
	obj=document.getElementById('Tel1');
	if (obj) { obj.onkeydown = nextfocus; }
	
	//联系电话2	PGBI_Tel2	9
	obj=document.getElementById('Tel2');
	if (obj) { obj.onkeydown = nextfocus; }
	
	//电子邮件	PGBI_Email	10
	obj=document.getElementById('Email');
	if (obj) { obj.onkeydown = nextfocus; }
	
	//联系人	PGBI_Linkman2	11
	obj=document.getElementById('Linkman2');
	if (obj) { obj.onkeydown = nextfocus; }
	
	//传真 PGBI_FAX 12
	obj=document.getElementById('FAX');
	if (obj) { obj.onkeydown = nextfocus; }
	
	// 就诊号 PGBI_PAPMINo 13
	//obj=document.getElementById('PAPMINo');
	//if (obj) { obj.onkeydown = nextfocus; }
	obj=document.getElementById("IBIUpdateModel");
	
	//
	if (obj && "NoGen"==obj.value) {websys_setfocus("Desc");}

	//
	if (obj && "Gen"==obj.value) {
		websys_setfocus("PAPMINo");
	}
	obj=document.getElementById("CardNo");
	if (obj) {
		obj.onchange=CardNo_Change;
		//obj.onkeydown=CardNo_KeyDown;
		obj.onkeydown= CardNo_keydown;
	}
	
	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCard_Click;}

	
	iniForm();
	//卡类型初始化
	initialReadCardButton()
}
function ReadCard_Click()
{
	//var rtn=DHCACC_ReadMagCard();
	//obj=document.getElementById("CardNo");
	//if (obj) obj.value=rtn.split("^")[1];
	//CardNo_Change();
	ReadCardApp("PAPMINo","PAPMINoChange()","CardNo");
	
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
	CardNoChangeApp("PAPMINo","CardNo","PAPMINoChange()","Clear_click()","1");	
}
function iniForm(){
	var ID=""
	var obj;
	
	obj=document.getElementById('ID');
	
	if (obj && ""!=obj.value) { 
		ID="^"+obj.value;
		
		FindPatDetail(ID);
	}
	
	//更新
	obj=document.getElementById("Update");
	//if (obj){ obj.style.display="inline"; }
	
	//删除
	obj=document.getElementById("Delete");
	//if (obj){ obj.style.display="inline"; }
	
	//清除
	obj=document.getElementById("Clear");
	//if (obj){ obj.style.display="inline"; }
	
	
	websys_setfocus('Code');
}
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

//验证是否为浮点数
function IsFloat(Value) {
	
	var reg;
	
	if(""==trim(Value)) {
		//容许为空
		return true; 
	}else { Value=Value.toString(); }
	
	reg=/^((-?|\+?)\d+)(\.\d+)?$/;

	var r=Value.match(reg);
	if (null==r) { return false; }
	else { return true; }
}

//输入编码 查找相应的信息
function Code_keydown(e) {

	var key=websys_getKey(e);
	if (13==key) {
		CodeChange();
	}
}
//输入编码 查找相应的信息
function CodeChange() {

		var obj;
		var iCode="";
		obj=document.getElementById('Code');
		if (obj && ""!=obj.value) { 
			iCode = obj.value;
		}
		else { return false; }		
		
		var ID="^"+iCode; //PGBI_RowId+"^"+PGBI_Code
		
		FindPatDetail(ID);

}
function FindPatDetail(ID){
	var Instring=ID;
	var Ins=document.getElementById('GetDetail');
	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
	var flag=cspRunServerMethod(encmeth,'SetPatient_Sel','',Instring);
	if (flag=='0') {

		//obj.className='clsInvalid';
		return websys_cancel();
	}
	websys_setfocus('Desc');
}
//输入编码 查找相应的信息
function PAPMINo_keydown(e) {

	var key=websys_getKey(e);

	if (13==key) {
		PAPMINoChange();
	}
}
//输入编码 查找相应的信息
function PAPMINoChange() {

	//var key=websys_getKey(e);

	//if (9==key || 13==key) {
		var obj;
		var iCode="";
		obj=document.getElementById('PAPMINo');
		if (obj && ""!=obj.value) { 
			iPAPMINo = obj.value;
		}
		else { return false; }		
		iPAPMINo = RegNoMask(iPAPMINo);
		var GetCodeMethodObj=document.getElementById("GetGCodeByADM")
		if (GetCodeMethodObj && ""!=GetCodeMethodObj.value) { 
			GetCodeMethod = GetCodeMethodObj.value;
		}
		else { return false; }
		var GCode=cspRunServerMethod(GetCodeMethod,iPAPMINo)	
		if (GCode==""){
		var ID="^"+iPAPMINo+"^"; //PGBI_RowId+"^"+PGBI_Code
		FindGBaseDetail(ID);}
		else{
		var ID="^"+GCode; //PGBI_RowId+"^"+PGBI_Code
		FindPatDetail(ID);}
//	}
}
function FindGBaseDetail(ID){
	var Instring=ID;

	var Ins=document.getElementById('GetHISInfo');
	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
	var flag=cspRunServerMethod(encmeth,'SetHISInfo_Sel','',Instring);
	if (flag=='0') {

		//obj.className='clsInvalid';
		return websys_cancel();
	}
	else if(flag==""){
		obj=document.getElementById("IBIUpdateModel");
	
	//
	if (obj && "FreeCreate"==obj.value) {}
	
	//
	if (obj && "FreeCreate"!=obj.value) {
		alert("登记号不存在");
		Clear_click();
	}
		
	}
	websys_setfocus('Desc');
}
function SetHISInfo_Sel(value) {
	var obj;
	Clear_click();
	var Data=value.split("^");
	var iLLoop=0;

	iLLoop=iLLoop+1;
	//描    述	PGBI_Desc	2
	obj=document.getElementById('PAPMINo');
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//描    述	PGBI_Desc	2
	obj=document.getElementById('Desc');
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	//描    述	PGBI_Desc	2
	obj=document.getElementById('CardNo');
	if (obj) { obj.value=Data[iLLoop]; }
}
//
function SetPatient_Sel(value) {
	var obj;

	Clear_click();

	var Data=value.split("^");
	var iLLoop=0;

	var iRowId=Data[iLLoop];	

	iLLoop=iLLoop+1;

	//单位编码	PGBI_Code	1
	obj=document.getElementById('Code');
	if (obj) { obj.value=Data[iLLoop]; }	

	if ("0"==iRowId) {	//未找到记录
		//描    述	PGBI_Desc	2
		obj=document.getElementById('Desc');
		if (obj) { obj.value="未用"; }

		return false;
	}else{
		//0
		obj=document.getElementById('RowId');
		if (obj) { obj.value=iRowId; }		
	}
		
	//单位编码	PGBI_Code	1
	obj=document.getElementById('Code');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//描    述	PGBI_Desc	2
	obj=document.getElementById('Desc');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//地    址	PGBI_Address	3
	obj=document.getElementById('Address');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//邮政编码	PGBI_Postalcode	4
	obj=document.getElementById('Postalcode');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//联系人	PGBI_Linkman1	5
	obj=document.getElementById('Linkman1');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//业务银行	PGBI_Bank	6
	obj=document.getElementById('Bank');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//帐    号	PGBI_Account	7
	obj=document.getElementById('Account');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//联系电话1	PGBI_Tel1	8
	obj=document.getElementById('Tel1');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//联系电话2	PGBI_Tel2	9
	obj=document.getElementById('Tel2');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//电子邮件	PGBI_Email	10
	obj=document.getElementById('Email');
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//联系人	PGBI_Linkman2	11
	obj=document.getElementById('Linkman2');
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//传真 PGBI_FAX 12
	obj=document.getElementById('FAX');
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	// 就诊号 PGBI_PAPMINo 13
	obj=document.getElementById('PAPMINo');
	if (obj) { obj.value=Data[iLLoop]; }
	
	// 折扣率  14 wrz
	iLLoop=iLLoop+1;
	obj=document.getElementById('Rebate');
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	obj=document.getElementById('CardNo');
	if (obj) { obj.value=Data[iLLoop]; }
	return true;
}

function Update_click() {

	var iRowId="",iCardNo;
	var iCode="", iDesc="", iAddress="", iPostalcode="", iLinkman1="", 
		iBank="", iAccount="", iTel1="", iTel2="", iEmail=""
		iLinkman2="", iFAX="", iPAPMINo=""
		;
	var obj;
	
	//						1
	obj=document.getElementById("RowId");
	if (obj) { iRowId=obj.value; }

	//单位编码	PGBI_Code	2
	obj=document.getElementById("Code");
	if (obj) { iCode=obj.value; }

	//描    述	PGBI_Desc	3
	obj=document.getElementById("Desc");
	if (obj) { iDesc=obj.value; }

	//地    址	PGBI_Address	4
	obj=document.getElementById("Address");
	if (obj) { iAddress=obj.value; }

	//邮政编码	PGBI_Postalcode	5
	obj=document.getElementById("Postalcode");
	if (obj) { iPostalcode=obj.value; }
	if(!IsPostalcode(iPostalcode)){
		websys_setfocus(obj.id);
		return;
	}


	//联系人	PGBI_Linkman	6
	obj=document.getElementById("Linkman1");
	if (obj) { iLinkman1=obj.value; }

	//业务银行	PGBI_Bank	7
	obj=document.getElementById("Bank");
	if (obj) { iBank=obj.value; }

	//帐    号	PGBI_Account	8
	obj=document.getElementById("Account");
	if (obj) { iAccount=obj.value; }

	//联系电话1	PGBI_Tel1	9
	obj=document.getElementById("Tel1");
	if (obj) { iTel1=obj.value; }
	if(!IsTel(iTel1)){
		websys_setfocus(obj.id);
		return;
	}


	//联系电话2	PGBI_Tel2	10
	obj=document.getElementById("Tel2");
	if (obj) { iTel2=obj.value; }
	if(!IsTel(iTel2)){
		websys_setfocus(obj.id);
		return;
	}


	//电子邮件	PGBI_Email	11
	obj=document.getElementById("Email");
	if (obj) { iEmail=obj.value; }
	if(!IsEMail(iEmail)){
		websys_setfocus(obj.id);
		return;
	}

	
	//联系人	PGBI_Linkman2	12
	obj=document.getElementById('Linkman2');
	if (obj) { iLinkman2=obj.value; }
	
	//传真 PGBI_FAX 13
	obj=document.getElementById('FAX');
	if (obj) { iFAX=obj.value; }
	
	// 就诊号 PGBI_PAPMINo 13
	obj=document.getElementById('PAPMINo');
	if (obj) { iPAPMINo=obj.value; }
	
	//折扣率 wrz
	obj=document.getElementById('Rebate');
	if (obj) { iRebate=obj.value; }
	//折扣率 wrz
	obj=document.getElementById('CardNo');
	if (obj) { iCardNo=obj.value; }
	var iHospitalCode=""                      //add by zl20100228 start
	var HospitalCode=document.getElementById("HospitalCode");
	if (HospitalCode) iHospitalCode=HospitalCode.value;    //add by zl20100228 end
	var CardRelate=document.getElementById("CardRelate");
	if (CardRelate)
	{
		if ((CardRelate.value=="Yes")&&(iCardNo=="")&&(iHospitalCode!="SHDF"))
		{
			//alert("卡号不能为空")
			//websys_setfocus("BReadCard");
			//return;
		}
	}
	
	/*
	//输入数据验证
	if (""==iCode) {
		//alert("Please entry all information.");
		alert(t['XMISSING']);
		websys_setfocus('Code');
		return false;
	}
	*/
	//输入数据验证
	if (""==iDesc) {
		//alert(t['XMISSING']);
		alert("团体名称不能为空");
		websys_setfocus('Desc');
		return false;
	} 
	obj=document.getElementById("IBIUpdateModel");
	
	
	if (obj && "NoGen"==obj.value) {}

	if (obj && "Gen"==obj.value) {
		// 登记号必须
		if (""==iPAPMINo) {
			obj=document.getElementById("PAPMINo")
			if (obj) {
				obj.value="";
				websys_setfocus(obj.id);
				obj.className='clsInvalid';
			}
			alert(t['01']);
			return false;
		} 
	}
	if (obj&&"FreeCreate"==obj.value)
	{
		if (""==iPAPMINo) {
			obj=document.getElementById("PAPMINo")
			if (obj) {
				obj.value="";
				websys_setfocus(obj.id);
				obj.className='clsInvalid';
			}
			alert(t['01']);
			return false;
		}
		if (isNaN(iPAPMINo)){
			obj=document.getElementById("PAPMINo")
			if (obj) {
				websys_setfocus(obj.id);
				obj.className='clsInvalid';
			}
			alert('登记号不是数字');
			return false;
		}
	}
	if (""==iLinkman1) {
		//alert(t['XMISSING']);
		alert("联系人1不能为空");
		websys_setfocus('Linkman1');
		return false;
	}
 	if (""==iTel1) {
		//alert(t['XMISSING']);
		alert("联系电话1不能为空");
		websys_setfocus('Tel1');
		return false;
	}
	
	var Instring= trim(iRowId)			//			1
				+"^"+trim(iCode)		//单位编码	2
				+"^"+trim(iDesc)		//描    述	3
				+"^"+trim(iAddress)		//地    址	4
				+"^"+trim(iPostalcode)	//邮政编码	5
				+"^"+trim(iLinkman1)	//联系人	6
				+"^"+trim(iBank)		//业务银行	7
				+"^"+trim(iAccount)		//帐    号	8
				+"^"+trim(iTel1)		//联系电话1	9
				+"^"+trim(iTel2)		//联系电话2	10
				+"^"+trim(iEmail)		//电子邮件	11
				+"^"+trim(iLinkman2)		//联系人2	12
				+"^"+trim(iFAX)		//传真	13
				+"^"+trim(iPAPMINo)		//登记号	14
				+"^"+trim(iRebate)  //折扣率  15
				+"^"+trim(iCardNo)  //CardNo
				;
	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring)
	
	if (""==iCode) { //插入操作
		var Data=flag.split("^");
		flag=Data[0];
		iRowId=Data[1];
		iCode=Data[2];
		iRegNo=Data[3];
	}
	if (flag=='0') {
		alert(t['info 01']);
		obj=document.getElementById('RowId');
		if (obj) obj.value=iRowId;
		obj=document.getElementById('PAPMINo');
		if (obj) obj.value=iRegNo;
		obj=document.getElementById("Code");
		if (obj) obj.value=iCode;
		websys_setfocus('Name');
		
		if (opener) {
			// 调用父窗口 DHCPEPreGADM.Edit 的返回函数
			opener.NewWondowReturn(iDesc+"^"+iCode+"^"+iRowId);
			close(); 
		}
		
		//Clear_click();
		return ;
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreGBaseInfo.Edit"
				+"&ID="+iCode;
		location.href=lnk;

	}
	else if('Err 01'==flag){
		//alert("编码已使用?不能增加");
		alert(t['Err 01']);
		return false;		
	}
	else if('Err 02'==flag){
		//alert("编码被其他记录使用?无法修改");
		alert(t['Err 02']);
		return false;
	}else if('-119'==flag){
		alert("该团体已经存在")
		return false;
	}
	else {
		//alert("Insert error.ErrNo="+flag);
		alert(t['02']+flag);
		return false;
	}

	//刷新页面
	//.reload(); 
	return true;
}

function Delete_click() {

	var iRowId="";

	var obj=document.getElementById("RowId");
	if (obj){ iRowId=obj.value; }

	if (""==iRowId)	{
		//alert("Please select the row to be deleted.");
		alert(t['03']);
		return false
	} 
	else{ 
		//if (confirm("Are you sure delete it?")){
		if (confirm(t['04'])) {
			var Ins=document.getElementById('DeleteBox');
			if (Ins) {var encmeth=Ins.value; } 
			else {var encmeth=''; };

			var flag=cspRunServerMethod(encmeth,'','',iRowId)
			if ('0'==flag) { New_click(); }
			else{
				//alert("Delete error.ErrNo="+flag)
				alert(t['05']+flag);
				
			}
		
		}
	}
}

function nextfocus() {
	var eSrc=window.event.srcElement;
	var key=websys_getKey(e);
	if (key==13) {
		
		websys_nexttab(eSrc.tabIndex);
	}
}

//清除输入的信息
function Clear_click() {
	var obj;	
	    
	//			PGBI_RowId
	obj=document.getElementById("RowId");
	if (obj) {obj.value=""; }

	//单位编码	PGBI_Code
	obj=document.getElementById('Code');
	if (obj) { obj.value=''; }

	//描    述	PGBI_Desc
	obj=document.getElementById('Desc');
	if (obj) { obj.value=''; }

	//地    址	PGBI_Address
	obj=document.getElementById('Address');
	if (obj) { obj.value=''; }

	//邮政编码	PGBI_Postalcode
	obj=document.getElementById('Postalcode');
	if (obj) { obj.value=''; }

	//联系人	PGBI_Linkman
	obj=document.getElementById('Linkman1');
	if (obj) { obj.value=''; }

	//业务银行	PGBI_Bank
	obj=document.getElementById('Bank');
	if (obj) { obj.value=''; }

	//帐    号	PGBI_Account
	obj=document.getElementById('Account');
	if (obj) { obj.value=''; }

	//联系电话1	PGBI_Tel1
	obj=document.getElementById('Tel1');
	if (obj) { obj.value=''; }

	//联系电话2	PGBI_Tel2
	obj=document.getElementById('Tel2');
	if (obj) { obj.value=''; }

	//电子邮件	PGBI_Email
	obj=document.getElementById('Email');
	if (obj) { obj.value=''; }
	
	//联系人	PGBI_Linkman2	11
	obj=document.getElementById('Linkman2');
	if (obj) { obj.value=''; }
	
	//传真 PGBI_FAX 12
	obj=document.getElementById('FAX');
	if (obj) { obj.value=''; }
	
	// 就诊号 PGBI_PAPMINo 13
	obj=document.getElementById('PAPMINo');
	if (obj) { obj.value=''; }
	
	// 就诊号 PGBI_PAPMINo 13
	obj=document.getElementById('Rebate');
	if (obj) { obj.value=''; }
	// 卡号
	obj=document.getElementById('CardNo');
	if (obj) { obj.value=''; }
	websys_setfocus('PAPMINo');
}

document.body.onload = BodyLoadHandler;
