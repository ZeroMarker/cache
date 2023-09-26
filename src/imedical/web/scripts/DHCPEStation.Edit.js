//名称	DHCPEStation.Edit.js
//功能	站点编辑 跟新?删除
//组件	DHCPEStation.Edit
//对象	DHCPEStationCom
//创建	2006.05.11
//最后修改时间	
//最后修改人	
//完成
var TFORM="";
function BodyLoadHandler() {

	var obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	
	var obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click; }

	var obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }
	
	iniForm();
}

function iniForm(){
	var ID=""
	var obj;
	obj=document.getElementById('TFORM');
	if (obj) { TFORM=obj.value; }	
	
	obj=document.getElementById('ID');	
	if (obj && ""!=obj.value) { 
		ID=obj.value;
		FindPatDetail(ID);
	}	
	websys_setfocus('Code');
}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];

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
		if (obj) { obj.value="未找到记录"; }

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
	obj=document.getElementById('Place');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//邮政编码	PGBI_Postalcode	4
	obj=document.getElementById('Sequence');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//联系人	PGBI_Linkman	5
	obj=document.getElementById('Active');
	if (obj && "Y"==Data[iLLoop]) { obj.checked=true; }
	else { obj.checked=false; }

	return true;
}
function Update_click() {
	var iRowId="";
	var iCode="", iDesc="", iPlace="", iSequence="", iActive="";

	//ST_RowId		1
	var obj;
	obj=document.getElementById("RowId");
	if (obj){iRowId=obj.value; } 

	//ST_Code	编码	2
	obj=document.getElementById("Code");
	if (obj){iCode=obj.value; } 

	//ST_Desc	描述	3
	obj=document.getElementById("Desc");
	if (obj){iDesc=obj.value; } 

	//ST_Place	站点所在位置	4
	obj=document.getElementById("Place");
	if (obj){iPlace=obj.value; } 

	//ST_Sequence	顺序	5
	obj=document.getElementById("Sequence");
	if (obj){iSequence=obj.value; } 

	//ST_Active	激活	6
	obj=document.getElementById("Active");
	if (obj){
		if (obj.checked){ iActive="Y"; }
		else{ iActive="N"; }
	}  
  
	//输入数据验证
	if ((iDesc=="")||(iCode=="")) {
		//alert("Please entry all information.");
		alert(t['01']);
		return false;
	}  

	var Instring=	trim(iRowId)	//ST_RowId	1
				+"^"+trim(iCode)	//ST_Code	编码	2
				+"^"+trim(iDesc)	//ST_Desc	描述	3
				+"^"+trim(iPlace)	//ST_Place	站点所在位置	4
				+"^"+trim(iSequence)	//ST_Sequence	顺序	5
				+"^"+trim(iActive)	//ST_Active	激活	6
				
				;
	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring)
	if (""==iRowId) { //插入操作
		var Data=flag.split("^");
		flag=Data[0];
		iRowId=Data[1];
	}	
	if ('0'==flag) {
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+TFORM
				+"&ID="+iRowId
				;
		location.href=lnk;
	}
	else{
		//alert("Insert error.ErrNo="+flag)
		alert(t['02']+flag);
	}
}

function Delete_click() {

	var iRowID="";

	var obj=document.getElementById("RowID");
	if (obj){ iRowID=obj.value; }

	if (""==iRowID)	{
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

			var flag=cspRunServerMethod(encmeth,'','',iRowID)
			if ('0'==flag) {
				var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+TFORM
				;
				location.href=lnk;			
			}
			else{
				//alert("Delete error.ErrNo="+flag)
				alert(t['05']+flag)
			}
		}
	}
}

function Clear_click() {
	var obj;	
	    
	//ST_Code	编码
	obj=document.getElementById("Code");
	obj.value="";
	
	//ST_Desc	描述
	obj=document.getElementById("Desc");
	obj.value="";

	//ST_Place	站点所在位置
	obj=document.getElementById("Place");
	obj.value="";

	//ST_Sequence	顺序
	obj=document.getElementById("Sequence");
	obj.value="";

	//ST_Active	激活
	obj=document.getElementById("Active");
	obj.checked=false;
	
	//ST_RowId	记录编码 	
	obj=document.getElementById("RowId");
	obj.value="";	  

}

document.body.onload = BodyLoadHandler;


