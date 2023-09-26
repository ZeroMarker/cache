//名称	DHCPEPreGBaseInfo.Edit.js
//功能	团体基本信息维护
//组件	DHCPEPreGBaseInfo.Edit	
//创建	2018.09.05
//创建人  xy

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
	
	//单位编码	
	obj=document.getElementById('Code');
	if (obj) { 
		obj.onkeydown = Code_keydown;
		obj.onchange=CodeChange;
	}
	
	
	obj=document.getElementById('PAPMINo');
	if (obj) { 
		obj.onchange = PAPMINoChange;
		obj.onkeydown= PAPMINo_keydown;
	}
	
	//描   述	
	obj=document.getElementById('Desc');
	if (obj) { obj.onkeydown = nextfocus; }

	//地    址
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
	
	//读卡
	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCard_Click;}

	
	iniForm();

	obj=document.getElementById("IBIUpdateModel");
	if (obj && "NoGen"==obj.value) {
		websys_setfocus("Desc");
		obj=document.getElementById("Code");
		if (obj) { var iCode=obj.value;}
		if(iCode!=""){
			obj=document.getElementById('PAPMINo');
			if(obj) websys_disable(obj);
			}
		}

	//卡类型初始化
	initialReadCardButton()
}

function ReadCard_Click()
{
	var myrtn=DHCACC_GetAccInfo7(CardTypeCallBack);
	
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
	 var obj=document.getElementById("CardNo"); 
	if (obj){ var myCardNo=obj.value;}
	//alert(myCardNo)
	if (myCardNo=="") return;
		var myrtn=DHCACC_GetAccInfo("",myCardNo,"","PatInfo",CardTypeCallBack);
		return false;
}

function CardTypeCallBack(myrtn){
   var myary=myrtn.split("^");
   var rtn=myary[0];
	switch (rtn){
		case "0": //卡有效有帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#CardNo").focus().val(CardNo);
			$("#PAPMINo").val(PatientNo);
			PAPMINoChange();
			event.keyCode=13; 
			break;
		case "-200": //卡无效
			$.messager.alert("提示","卡无效","info",function(){$("#CardNo").focus();});
			break;
		case "-201": //卡有效无帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#CardNo").focus().val(CardNo);
			$("#PAPMINo").val(PatientNo);
			PAPMINoChange();
			event.keyCode=13;
			break;
		default:
	}
}

function iniForm(){
	var ID=""
	var obj;
	
	obj=document.getElementById("ID");
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
	if(!CheckTelOrMobile(iTel1,"Tel1","联系电话1")){
		websys_setfocus(obj.id);
		return;
	}
   



	//联系电话2	PGBI_Tel2	10
	obj=document.getElementById("Tel2");
	if (obj) { iTel2=obj.value; }
	if(iTel2!=""){
	if(!CheckTelOrMobile(iTel2,"Tel2","联系电话2")){
		websys_setfocus(obj.id);
		return;
	}
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
	
	
	//输入数据验证
	if (""==iDesc) {
		$.messager.alert("提示","团体名称不能为空","info");
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
			$.messager.alert("提示","登记号不是数字","info");
			return false;
		}
	}
	if (""==iLinkman1) {
		$.messager.alert("提示","联系人1不能为空","info");
		websys_setfocus('Linkman1');
		return false;
	}
 	if (""==iTel1) {
		$.messager.alert("提示","联系电话1不能为空","info");
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
		//$.messager.alert("提示",t['info 01']);
		alert("更新成功")
		websys_showModal("close"); 
		return false

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
		
		
		var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEPreGBaseInfo.Edit"
				+"&ID="+iCode;
		location.href=lnk;

	}
	else if('Err 01'==flag){
		$.messager.alert("提示",t['Err 01'],"info");
		return false;		
	}
	else if('Err 02'==flag){
		$.messager.alert("提示",t['Err 02'],"info");
		return false;
	}else if('-119'==flag){
		$.messager.alert("提示","该团体已经存在","info");
		return false;
	}
	else {
		$.messager.alert("提示",t['02']+flag,"info");
		return false;
	}

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

function nextfocus(e) {
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

//电子邮箱 
function  IsEMail(elem){
if (elem=="") return true;
 var pattern=/^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
 if(pattern.test(elem)){
  return true;
 }else{
	 $.messager.alert("提示","电子邮箱格式不正确","info");
  return false;
 }
}


//电话号码(移动和座机电话)
/* 
用途：检查输入是否正确的电话和手机号 
输入： 
value：字符串 
返回： 
如果通过验证返回true,否则返回false 
*/  
function IsTel(telephone){ 

	var teleReg1 = /^((0\d{2,3})-)(\d{7,8})$/;
	var teleReg2 = /^((0\d{2,3}))(\d{7,8})$/; 
	var mobileReg =/^1[3|4|5|6|7|8|9][0-9]{9}$/;
	if (!teleReg1.test(telephone)&& !teleReg2.test(telephone) && !mobileReg.test(telephone)){ 
		return false; 
	}else{ 
	
		return true; 
	} 
}
//功能：核对手机号和电话是否正确
//参数：telephone:电话号码 Name:元素名称 Type:元素描述
function CheckTelOrMobile(telephone,Name,Type){
	if (telephone.length==8) return true;
	if (IsTel(telephone)) return true;
	if (telephone.substring(0,1)==0){
		if (telephone.indexOf('-')>=0){
			$.messager.alert("提示",Type+": 固定电话长度错误,固定电话区号长度为【3】或【4】位,固定电话号码长度为【7】或【8】位,并以连接符【-】连接,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("提示",Type+": 固定电话长度错误,固定电话区号长度为【3】或【4】位,固定电话号码长度为【7】或【8】位,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}else{
		if(telephone.length!=11){
			$.messager.alert("提示",Type+": 联系电话电话长度应为【11】位,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("提示",Type+": 不存在该号段的手机号,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}
	return true;
}




//邮政编码
function  IsPostalcode(elem){
if (elem=="") return true;
 var pattern=/[0-9]\d{5}(?!\d)/;
 if(pattern.test(elem)){
  return true;
 }else{
   $.messager.alert("提示","邮政编码格式不正确","info");
   //alert("邮政编码格式不正确");
  return false;
 }
}
function RegNoMask(RegNo)
{
	if (RegNo=="") return RegNo;
	var RegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",RegNo);
	return RegNo;
}

document.body.onload = BodyLoadHandler;
