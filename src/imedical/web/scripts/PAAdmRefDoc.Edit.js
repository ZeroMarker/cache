// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 9.05.02 - 22570 - fills clinic from doctor lookup

//function DocumentLoadHandler()
//{
//
//}
//
//document.body.onload = DocumentLoadHandler;

function LookupDoctorFill(str)
{
	//alert(str);
		
  	var lu = str.split("^");
	var obj=document.getElementById("refddoctid");
	if (obj) obj.value=lu[4];
	var obj=document.getElementById("refdoclinid");
	if (obj) obj.value=lu[8];
	var obj=document.getElementById("CLNCode");
	if (obj) obj.innerText=lu[7];
	var obj=document.getElementById("REFDDesc");
	if (obj) obj.value=lu[1];
	var obj=document.getElementById("CLNAddress1");
	if (obj) obj.innerText=lu[10];
	var obj=document.getElementById("CLNAddress2");
	if (obj) obj.innerText=lu[23];
	var obj=document.getElementById("CTCITDesc");
	if (obj) obj.innerText=lu[18];
	
	
}

function TypeCodeConvert (str) 
{
	//alert(str);
  	var lu = str.split("^");
	var obj=document.getElementById("TypeCode");
	if (obj) obj.value=lu[2];	
}
