
function Ini(){
	//DisabledCtls("a",true);
	DAlert("document loaded!");	
	var obj=document.getElementById("button1");
	obj.onclick=btn_onclick;
	
	
}
function btn_onclick(){
	var encmeth=GetCtlValueById("txtServerScr");
	var myParam="1";
	var flag=cspRunServerMethod(encmeth,myParam);
	alert("myParam="+myParam);
	var myObj=new myObjF;
	myObj.aa=2	
	testPara(myObj);
	alert("myParam="+myObj.aa);   
}

function myObjF(){
	//string aa="bb";
	var aa=1;
	var bb=2;
}
   
function testPara(myParam){
	myParam.aa=myParam.aa+1;	
}

document.body.onload = Ini;
