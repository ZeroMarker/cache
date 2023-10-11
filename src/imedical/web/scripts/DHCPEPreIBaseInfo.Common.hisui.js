//DHCPEPreIBaseInfo.Common.hisui.js


function BodyIni() {
	var obj;


	/*/患者类型 必输入
	obj=document.getElementById('PatType_DR_Name');
	if (obj) {
		obj.onkeydown = PatType_DR_Name_keydown;
		//obj.onblur = PatType_DR_Name_blur;
		//obj.onchange = PatType_DR_Name_change;
	}*/
	
	//姓名
	obj=document.getElementById('Name');
	if (obj) {
		obj.onkeydown = nextfocus;
		obj.onchange = Name_change;
	}

	//身份证号
	obj=document.getElementById('IDCard');
	if (obj) { obj.onkeydown = nextfocus; }

	/*/性别
	obj=document.getElementById('Sex_DR_Name');
	if (obj) {
		obj.onkeydown = Sex_DR_Name_keydown;
		obj.onblur = Sex_DR_Name_blur;
		obj.onchange = Sex_DR_Name_change;
	}

	//生日
	obj=document.getElementById('DOB');
	if (obj) {
		obj.onkeydown = DOB_keydown;
		//obj.onchange = DOB_change;
	}*/

	//民族
	obj=document.getElementById('Nation');
	if (obj) { obj.onkeydown = nextfocus; }

	//婚姻状况
	obj=document.getElementById('Married_DR_Name');
	if (obj) {
		//obj.onkeydown = Married_DR_Name_keydown;
		obj.onblur = Married_DR_Name_blur;
		obj.onchange = Married_DR_Name_change;
	}

	//血型
	obj=document.getElementById('Blood_DR_Name');
	if (obj) {
		obj.onkeydown = Blood_DR_Name_keydown;
		
	}

	//职业
	obj=document.getElementById('Vocation');
	if (obj) { obj.onkeydown = nextfocus; }

	//移动电话
	obj=document.getElementById('MobilePhone');
	if (obj) { obj.onkeydown = nextfocus; }

	//电话
	obj=document.getElementById('Tel1');
	if (obj) { obj.onkeydown = nextfocus; }

	//电话 2
	obj=document.getElementById('Tel2');
	if (obj) { obj.onkeydown = nextfocus; }

	//电子邮件
	obj=document.getElementById('Email');
	if (obj) { obj.onkeydown = nextfocus; }

	//联系地址
	obj=document.getElementById('Address');
	if (obj) { obj.onkeydown = nextfocus; }

	//邮编
	obj=document.getElementById('Postalcode');
	if (obj) { obj.onkeydown = nextfocus; }

	//公司
	obj=document.getElementById('Company');
	if (obj) { obj.onkeydown = nextfocus; }

	//职位
	obj=document.getElementById('Position');
	if (obj) { obj.onkeydown = nextfocus; }


}
BodyIni();

function IBISetPatient_Sel(value,DataType) {

	var obj;
	var Data=value.split("^");
	var iLLoop=0;

	//	PIBI_RowId	0
	//obj=document.getElementById("RowId");
	//if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	
	//	PIBI_PAPMINo	登记号	1
	iLLoop=iLLoop+1;
	obj=document.getElementById("PAPMINo");
	if (obj && Data[iLLoop]) {
		 setValueById("PAPMINo",Data[iLLoop]);
		obj.disabled=true;
	}
	
	//	PIBI_Name	姓名	2
	iLLoop=iLLoop+1;
	obj=document.getElementById("Name");
	if (obj && Data[iLLoop]) { setValueById("Name",Data[iLLoop]); }
	
	//	PIBI_Sex_DR	性别	3
	iLLoop=iLLoop+1;
	obj=document.getElementById("Sex_DR");
	if (obj && Data[iLLoop]) { 
		setValueById("Sex_DR",Data[iLLoop]);
	}

	obj=document.getElementById("Sex_DR_Name");
	if (obj && Data[iLLoop]) { 
		setValueById("Sex_DR_Name",Data[iLLoop]);
	}

	//	3.1
	iLLoop=iLLoop+1;
	
	
	//	PIBI_DOB	生日	4
	iLLoop=iLLoop+1;
	obj=document.getElementById("DOB");
	if (obj && Data[iLLoop]) {
		/*
	if ((Data[iLLoop].split("/")[2].length)==2)             //add by zhouli 处理生日显示格式以及年份为20开头的数据
    {var DOB="19"+Data[iLLoop].split("/")[2]+"-"+Data[iLLoop].split("/")[1]+"-"+Data[iLLoop].split("/")[0]} //add by zhouli
    else {var DOB=Data[iLLoop].split("/")[2]+"-"+Data[iLLoop].split("/")[1]+"-"+Data[iLLoop].split("/")[0]} //add by zhouli
	 obj.value=DOB; */
	 obj.value=Data[iLLoop];
	 }
	
	/*
	var Year
	if (Data[iLLoop]!="")
	{ 
		var Year=Data[iLLoop].split("/")[2];
		var D   =   new   Date();
		var Year1=D.getFullYear();
		if (Year.length==2) Year="19"+Year;
		Year=Year1-Year;
		obj=document.getElementById("Age");
		if (obj){
		obj.value=Year
		
	}
	}
	*/
	//	PIBI_PatType_DR	客人类型	5
	iLLoop=iLLoop+1;
	obj=document.getElementById("PatType_DR");
	if (obj && Data[iLLoop]) { setValueById("PatType_DR",Data[iLLoop]); }
	
	obj=document.getElementById("PatType_DR_Name");
	if (obj && Data[iLLoop]) { setValueById("PatType_DR_Name",Data[iLLoop]); }	
	
	//	客人类型	5.1
	iLLoop=iLLoop+1;
	
	
	// PIBI_Tel1 电话号码1 6
	iLLoop=iLLoop+1;
	obj=document.getElementById("Tel1");
	if (obj && Data[iLLoop]) { setValueById("Tel1",Data[iLLoop]); }
	
	// PIBI_Tel2 电话号码2 7
	iLLoop=iLLoop+1;
	obj=document.getElementById("Tel2");
	if (obj && Data[iLLoop]) { setValueById("Tel2",Data[iLLoop]); }

   // PIBI_MobilePhone 移动电话 8
	iLLoop=iLLoop+1;
	obj=document.getElementById("MobilePhone");
	if (obj && Data[iLLoop]) {  setValueById("MobilePhone",Data[iLLoop]); }
	

	//	PIBI_IDCard	身份证号	9
	iLLoop=iLLoop+1;
	obj=document.getElementById("IDCard");
	if (obj && Data[iLLoop]) {  setValueById("IDCard",Data[iLLoop]); }
	
	
	//	PIBI_Vocation	职业	10
	iLLoop=iLLoop+1;
	obj=document.getElementById("Vocation");
	if (obj && Data[iLLoop]) { setValueById("Vocation",Data[iLLoop]); }
	
	
	//	PIBI_Position	职位	11
	iLLoop=iLLoop+1;
	obj=document.getElementById("Position");
	if (obj && Data[iLLoop]) { setValueById("Position",Data[iLLoop]); }
	
	
	//	PIBI_Company	公司	12
	iLLoop=iLLoop+1;
	obj=document.getElementById("Company");
	if (obj && Data[iLLoop]) {  setValueById("Company",Data[iLLoop]); }
	
	
	//	PIBI_Postalcode	邮编	13
	iLLoop=iLLoop+1;
	obj=document.getElementById("Postalcode");
	if (obj && Data[iLLoop]) { setValueById("Postalcode",Data[iLLoop]); }
	
	
	//	PIBI_Address	联系地址	14
	iLLoop=iLLoop+1;
	obj=document.getElementById("Address");
	if (obj && Data[iLLoop]) { setValueById("Address",Data[iLLoop]); }
	
	
	//	PIBI_Nation	民族	15
	iLLoop=iLLoop+1;
	obj=document.getElementById("CTNationDR");
	if (obj && Data[iLLoop]) { setValueById("CTNationDR",Data[iLLoop]); }
	//obj=document.getElementById("NationDesc");
	//if (obj && Data[iLLoop]) { setValueById("NationDesc",Data[iLLoop]); }
	
	
	//	PIBI_Email	电子邮件	16
	iLLoop=iLLoop+1;
	obj=document.getElementById("Email");
	if (obj && Data[iLLoop]) { setValueById("Email",Data[iLLoop]); }
		
	//	PIBI_Married	婚姻状况	17
	iLLoop=iLLoop+1;
	obj=document.getElementById("Married_DR");
	if (obj && Data[iLLoop]) {  setValueById("Married_DR",Data[iLLoop]); }

	obj=document.getElementById("Married_DR_Name");
	if (obj && Data[iLLoop]) {  setValueById("Married_DR_Name",Data[iLLoop]); }	
	
	//	17.1
	iLLoop=iLLoop+1;
		
	//	PIBI_Blood	血型	18
	iLLoop=iLLoop+1;
	obj=document.getElementById("Blood_DR");
	if (obj && Data[iLLoop]) { setValueById("Blood_DR",Data[iLLoop]); }
	
	obj=document.getElementById("Blood_DR_Name");
	if (obj && Data[iLLoop]) { setValueById("Blood_DR_Name",Data[iLLoop]); }	
	
	//	18.1
	iLLoop=iLLoop+1;	
	
	//	PIBI_UpdateDate	日期	19
	iLLoop=iLLoop+1;
	obj=document.getElementById("UpdateDate");
	if (obj && Data[iLLoop]) { setValueById("UpdateDate",Data[iLLoop]); }
	
	//	PIBI_UpdateUser_DR	更新人	20
	iLLoop=iLLoop+1;
	obj=document.getElementById("UpdateUser_DR");
	if (obj && Data[iLLoop]) { setValueById("UpdateUser_DR",Data[iLLoop]);}
	
	//	20.1
	iLLoop=iLLoop+1;
	obj=document.getElementById("UpdateUser_DR_Name");
	if (obj && Data[iLLoop]) { setValueById("UpdateUser_DR_Name",Data[iLLoop]); }
	//体检号
	iLLoop=iLLoop+1;
	obj=document.getElementById("HPNo");
	if (obj && Data[iLLoop]) { setValueById("HPNo",Data[iLLoop]); }
	//年龄
	iLLoop=iLLoop+1;
	obj=document.getElementById("Age");  //SexNV.split("^")
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop].split("Y")[0]; }
	//合同单位
	iLLoop=iLLoop+1;
	obj=document.getElementById("hcpdr");
	if (obj && Data[iLLoop]) { setValueById("hcpdr",Data[iLLoop]); }
	
	//健康地区
	iLLoop=iLLoop+1;
	obj=document.getElementById("HCRDR");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	
	//健康区域
	iLLoop=iLLoop+1;
	obj=document.getElementById("HCADR");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	
	//健康区域
	iLLoop=iLLoop+1;
	obj=document.getElementById("HCADesc");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	//CardNo
	iLLoop=iLLoop+1;
	obj=document.getElementById("CardNo");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	//VIP
	iLLoop=iLLoop+1;
	obj=document.getElementById("VIPLevel");
	if (obj && Data[iLLoop]) { setValueById("VIPLevel",Data[iLLoop]); }
	
		
	//医保号
	iLLoop=iLLoop+1;
	//iLLoop=iLLoop+1;
	obj=document.getElementById("MedicareCode");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	
	//证件类型
	//iLLoop=iLLoop+1;
	iLLoop=iLLoop+1;
	obj=document.getElementById("PAPMICardType_DR_Name");
	if (obj && Data[iLLoop]) { 
		//setValueById("PAPMICardType_DR_Name",Data[iLLoop]);
		$("#PAPMICardType_DR_Name").combobox('setValue',Data[iLLoop])
		}

	iLLoop=iLLoop+1;
	iLLoop=iLLoop+1;
	
	obj=document.getElementById("CTNationDR");
	if (obj && Data[iLLoop]) { setValueById("CTNationDR",Data[iLLoop]); }

    //体检特殊客户类型
    iLLoop=iLLoop+1;
    $("#SpecialType").combobox('setValue',Data[iLLoop]);

	return true;
	
}


//清除输入的信息
function IBIClearNew_click() {
	var obj;	
	    
	//	PIBI_RowId
	setValueById("RowId","");
	
	//	PIBI_PAPMINo	登记号
	setValueById("PAPMINo","");
	
	//	PIBI_Name	姓名
	setValueById("Name","");
	
	//	PIBI_Sex_DR	性别
	setValueById("Sex_DR","");
	setValueById("Sex_DR_Name","");

	//	PIBI_DOB	生日
	setValueById("DOB","");

	//	PIBI_PatType_DR	客人类型
	setValueById("PatType_DR","");
	setValueById("PatType_DR_Name","");

	//	PIBI_Tel1	电话号码1
	setValueById("Tel1","");

	//	PIBI_Tel2	电话号码2
	setValueById("Tel2","");

	//	PIBI_MobilePhone	移动电话
	setValueById("MobilePhone","");

	//	PIBI_IDCard	身份证号
	setValueById("IDCard","");

	//	PIBI_Vocation	职业
	setValueById("Vocation","");

	//	PIBI_Position	职位
	setValueById("Position","");

	//	PIBI_Company	公司
	setValueById("Company","");

	//	PIBI_Postalcode	邮编
	setValueById("Postalcode","");

	//	PIBI_Address	联系地址
	setValueById("Address","");

	//	PIBI_Nation	民族
	//setValueById("NationDesc","");
    setValueById("CTNationDR","");
    
	//	PIBI_Email	电子邮件
	setValueById("Email","");

	//	PIBI_Married	婚姻状况
	setValueById("Married_DR","");
	setValueById("Married_DR_Name","");
		
	//	PIBI_Blood	血型
	setValueById("Blood_DR","");
	setValueById("Blood_DR_Name","");
	
	//	PIBI_UpdateDate	日期
	setValueById("UpdateDate","");

	//	PIBI_UpdateUser_DR	更新人
	setValueById("UpdateUser_DR","");
	setValueById("UpdateUser_DR_Name","");
	
	setValueById("HPNo","");
	setValueById("Age","");
	setValueById("hcpdr","");
	setValueById("HCRDR","");
	setValueById("HCADR","");
	setValueById("HCADesc","");
	
	setValueById("MedicareCode","");
	setValueById("GroupDesc","");
	setValueById("GroupDR","");
	setValueById("TeamDesc","");
	setValueById("TeamDR","");

	//证件类型
	setValueById("PAPMICardType_DR_Name","");
	
	//vip等级
	setValueById("VIPLevel","");
	SetDefault();
	return true;
}

//清除输入的信息
function IBIClear_click() {
	setValueById("CardNo","");	
	 IBIClearNew_click (); 
	return true;
	
}

function nextfocus() {
	var eSrc=window.event.srcElement;
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
}

// ************************************************************************************
// 性别
function Sex_DR_Name_blur() {
	obj=document.getElementById("Sex_DR");
	if (obj && ""==obj.value) {
		obj=document.getElementById("Sex_DR_Name");
		//obj.className='clsInvalid';
		//websys_setfocus(obj.id);
	}
}

function Sex_DR_Name_change() {
	var src=window.event.srcElement;
	src.classname='';
}

function Sex_DR_Name_keydown(e) {
	var key=websys_getKey(e);
	var eSrc=window.event;
	
	var obj=document.getElementById("Sex_DR_Name");
	if (obj) { obj.className=''; }
	
	if ( (9==key) || (13==key) ) {
		// 显示列表
		obj=document.getElementById("Sex_DR_Name");
		if (obj && (("不确定"==obj.value)||(""==obj.value))) {
			eSrc.keyCode=117;
			Sex_DR_Name_lookuphandler(117); 
		}
		else { websys_nexttab(eSrc.srcElement.tabIndex); }
	}else{
		obj=document.getElementById("Sex_DR");
		if (obj) { obj.value=''; }
	}
}
function GetSex(value) {
	var aiList=value.split("^");
	alert(aiList)
	if (""==value){ return false; }
	else{
		var obj;
	
		obj=document.getElementById("Sex_DR_Name");
		if (obj) {
			//obj.value=aiList[0];
			obj.value=aiList[0];
			websys_nexttab(obj.tabIndex);
		}

		obj=document.getElementById("Sex_DR");
		if (obj) { obj.value=aiList[2]; }
		
	}
}



//患者类型
function PatType_DR_Name_blur() {
	obj=document.getElementById("PatType_DR");
	if (obj && ""==obj.value) {
		obj=document.getElementById("PatType_DR_Name");
		obj.value='';
		//obj.className='clsInvalid';
		//websys_setfocus(obj.id);
	}
}
function PatType_DR_Name_change() {
	var src=window.event.srcElement;
	src.classname='';
}
function PatType_DR_Name_keydown(e) {
	var key=websys_getKey(e);
	var eSrc=window.event;
	
	var obj=document.getElementById("PatType_DR_Name");
	if (obj) { obj.className=''; }
	// 显示列表
	if ( (9==key) || (13==key) ) {
		obj=document.getElementById("PatType_DR");
		if (obj && ""==obj.value) {
			eSrc.keyCode=117;
			PatType_DR_Name_lookuphandler(117);
		}
		else { websys_nexttab(eSrc.srcElement.tabIndex); }
	}else{
		obj=document.getElementById("PatType_DR");
		if (obj) { obj.value=''; }
	}
}
function GetPatType(value) {
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;

		obj=document.getElementById("PatType_DR_Name");
		if (obj) {
			//obj.value=aiList[0];
			obj.value=aiList[2];
			websys_nexttab(obj.tabIndex);
		}


		obj=document.getElementById("PatType_DR");
		if (obj) { obj.value=aiList[2]; }
		
	}
}




//婚姻状况
function Married_DR_Name_blur() {
	obj=document.getElementById("Married_DR");
	if (obj && ""==obj.value) {
		obj=document.getElementById("Married_DR_Name");
		//obj.className='clsInvalid';
		//websys_setfocus(obj.id);
	}
}
function Married_DR_Name_change() {
	var src=window.event.srcElement;
	src.classname='';
}
function Married_DR_Name_keydown(e) {
	var obj=document.getElementById("Married_DR_Name");
	if (obj) { obj.className=''; }
	
	var key=websys_getKey(e);
	var eSrc=window.event;
	
	// 显示列表
	if ( (9==key) || (13==key) ) {
		obj=document.getElementById("Married_DR");
		if (obj && ""==obj.value) {
			eSrc.keyCode=117;
			Married_DR_Name_lookuphandler(117);
			
		}
		else { websys_nexttab(eSrc.srcElement.tabIndex); }
	}else{
		obj=document.getElementById("Married_DR");
		if (obj) { obj.value=''; }
	}
	
}
function GetMarital(value) {
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;

		obj=document.getElementById("Married_DR_Name");
		if (obj) {
			//obj.value=aiList[0];
			obj.value=aiList[2];
			websys_nexttab(obj.tabIndex);
		}

		obj=document.getElementById("Married_DR");
		if (obj) { obj.value=aiList[2]; }
	}
}

function Name_change() {
	var src=window.event.srcElement;
	src.classname='';
}

// 生日
function DOB_keydown(e) {
	var key=websys_getKey(e);
	var eSrc=window.event;
	
	if ( (9==key) || (13==key) ) {
		obj=document.getElementById("DOB");
		// 显示列表
		if (obj && (("12/08/2005"==obj.value)||(""==obj.value))) {
			eSrc.keyCode=117;
			DOB_lookuphandler(117);
		}
		else { websys_nexttab(eSrc.srcElement.tabIndex); }
	}
}
function DOB_change() {

}



//血型
function Blood_DR_Name_keydown(e) {
	var key=websys_getKey(e);
	var eSrc=window.event;
	
	if ( (9==key) || (13==key) ) {
		//eSrc.keyCode=117;
		//Blood_DR_Name_lookuphandler(117);
		websys_nexttab(eSrc.srcElement.tabIndex);
	}
}
function GetBloodType(value) {
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;

		obj=document.getElementById("Blood_DR_Name");
		if (obj) {
			//obj.value=aiList[0];
			obj.value=aiList[2];
			websys_nexttab(obj.tabIndex);
		}


		obj=document.getElementById("Blood_DR");
		if (obj) { obj.value=aiList[2]; }
	}
}


