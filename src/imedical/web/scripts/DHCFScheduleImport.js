 
var FileOpenObj = document.getElementById("cOpenFile");
FileOpenObj.innerHTML="<input type='file' id='FileOpen' style='width:500px'/> " 
var TableDataObj=document.getElementById("cTableData")
var ss="<div id='DataAll'>"
	ss=ss+"<TABLE id='TableDataAll' class=tblList CELLSPACING=1 width='100%' border=1>";
	ss=ss+"<tr>"+"<table id='TableDataTitle' width='100%'>"
	  ss=ss+"<tr><th NOWRAP>�к�</th><th NOWRAP>���Ҵ���</th><TH NOWRAP>��������</TH>";
	  ss=ss+"<TH NOWRAP>ҽ������</TH><TH NOWRAP>ҽ������</TH><TH  NOWRAP>����</TH>";
	  ss=ss+"<TH   NOWRAP>��ʼʱ��</TH><TH   NOWRAP>����ʱ��</TH><TH   NOWRAP>����ʱ��</TH>";
	  ss=ss+"<TH   NOWRAP>�����޶�</TH><TH   NOWRAP>ԤԼ�޶�</TH><TH   NOWRAP>ԤԼ��ʼ��</TH>";
	  ss=ss+"<TH   NOWRAP>�Ӻ��޶�</TH><TH   NOWRAP>����</TH><TH   NOWRAP>����</TH>";
	  ss=ss+"<TH   NOWRAP>�Һ�ְ��</TH><TH   NOWRAP>��רҵ</TH><TH   NOWRAP>�޶λ</TH>";
	  ss=ss+"<TH   NOWRAP>�޶�</TH><TH   NOWRAP>����</TH>"
	ss=ss+"</tr>"
	ss=ss+"</table>"
	ss=ss+"<tr>"+"<div style="+"overflow:auto;height=400"+">"
	ss=ss+"<table id='TableData' width='100%' border=1></table></tr></div>"
	ss=ss+"</TABLE></div>";
	ss=ss+"<textarea style='width:800;height:150' name='ErrorText' id='ErrorText'>"
var DataAllText="<TABLE id='TableDataAll' class=tblList CELLSPACING=1 width='100%' border=1>";
	DataAllText=DataAllText+"<tr>"+"<table id='TableDataTitle' width='100%'>"
	  DataAllText=DataAllText+"<tr><th NOWRAP>�к�</th><th NOWRAP>���Ҵ���</th><TH NOWRAP>��������</TH>";
	  DataAllText=DataAllText+"<TH  NOWRAP>ҽ������</TH><TH NOWRAP>ҽ������</TH><TH  NOWRAP>����</TH>";
	  DataAllText=DataAllText+"<TH   NOWRAP>��ʼʱ��</TH><TH   NOWRAP>����ʱ��</TH><TH   NOWRAP>����ʱ��</TH>";
	  DataAllText=DataAllText+"<TH   NOWRAP>�����޶�</TH><TH   NOWRAP>ԤԼ�޶�</TH><TH   NOWRAP>ԤԼ��ʼ��</TH>";
	  DataAllText=DataAllText+"<TH   NOWRAP>�Ӻ��޶�</TH><TH   NOWRAP>����</TH><TH   NOWRAP>����</TH>";
	  DataAllText=DataAllText+"<TH   NOWRAP>�Һ�ְ��</TH><TH   NOWRAP>��רҵ</TH><TH   NOWRAP>�޶λ</TH>";
	  DataAllText=DataAllText+"<TH   NOWRAP>�޶�</TH><TH   NOWRAP>����</TH>"
	DataAllText=DataAllText+"</tr>"
	DataAllText=DataAllText+"</table>"
	DataAllText=DataAllText+"<tr>"+"<div style="+"overflow:auto;height=400"+">"
	DataAllText=DataAllText+"<table id='TableData' width='100%' border=1></table></tr>"
	DataAllText=DataAllText+"</TABLE>"
TableDataObj.innerHTML=ss;
TableDataObj=document.getElementById("TableData")
var DataAllObj=document.getElementById("DataAll")
var TestDataObj=document.getElementById("TestData")
var LoadFileObj=document.getElementById("LoadFile")
var FileOpenObj=document.getElementById("FileOpen")
var TableObj=document.getElementById('tDHCFScheduleImport');
var AppendDataObj=document.getElementById("AppendData")
var ErrorTextObj=document.all.ErrorText
var ErrorText=""
	
function DisplayError(RetClass,i)
{
	window.status="��������:"+i+"��"
	if ((RetClass!="")&&(RetClass!="Ok"))
		{
			RetStr=ConvertEnter("��"+(i)+"��"+RetClass);
			if (ErrorText=="") {ErrorText=RetStr;}
			else {ErrorText=ErrorText+"\n"+RetStr;}
		}		
}
function BodyOnLoad()
{  	if (TestDataObj)
	{  TestDataObj.onclick=TestDataObjClick;}
	if (LoadFileObj)
	{  LoadFileObj.onclick=LoadFileObjClick;}
    if (AppendDataObj)
    {	AppendDataObj.onclick=AppendDataObjClick}
	var StartDateObj = document.getElementById("StartDate");	
	if (StartDateObj)
	{  
		StartDateObj.onkeydown=StartDateObjOnClick
	}

}
function StartDateObjOnClick()
{  
	if (event.keyCode==13)	{	event.keyCode=9	}
}
function TestDataObjClick()
{	ChangeData("Test")}
function AppendDataObjClick()
{	ChangeData("Append")}
function ChangeData(ChangeType)
{  	
	window.status="���������";
	if ((ChangeType=="")||(ChangeType==undefined)) {ChangeType="Test"}
	ErrorTextObj.value="";
	ErrorText="";
	var StartDateObj=document.getElementById("StartDate")
	if (!StartDateObj || StartDateObj.value=="") {alert("���ڲ���");StartDateObj.focus();window.status="���";return;}
	var RetStr="";
	var RetClass="";
	var TableRows=TableDataObj.rows.length;
	if (TableDataObj.rows.length<1) {alert("û������");window.status="���";return;}
	var CircleNum=TableRows/FetchRows;
	var CircleNum=Math.ceil(CircleNum);
	var ClearGlobalObj=document.getElementById("ClearGlobal");
	var SetGlobalObj=document.getElementById("SetStrToGloble");
	var UpDataObj=document.getElementById("UpData");
	//var UpDataBatchObj=document.getElementById("UpDataBatch");
	//cspRunServerMethod(ClearGlobalObj.value,"Schedule");
	var Tmpstr=UpDataObj.value
	var DateStr=StartDateObj.value
	for (var m=0;m<CircleNum;m++)
		{   var TmpArray=TableRead("TableData",m);
			for (var i=0;i<TmpArray.length;i++)
				{	//cspRunServerMethod(SetGlobalObj.value,TmpArray[i],"Schedule");

					RetClass=cspRunServerMethod(Tmpstr,ChangeType,TmpArray[i],"Schedule",DateStr);
					DisplayError(RetClass,m*FetchRows+i+1);
					delete TmpArray[i];
				}
		}
    ErrorTextObj.value=ErrorText;
	ErrorText="";
	window.status="���";
}
function LoadFileObjClick()
{  DataAllObj.innerHTML=DataAllText;
   TableDataObj=document.getElementById("TableData")
	var TableRows=TableDataObj.rows.length
	for (var i=1;i<TableRows;i++) 
	{   TableDataObj.deleteRow(1);}
	if (!FileOpenObj || FileOpenObj.value=="") {alert("û��Ҫװ����ļ�");FileOpenObj.focus();window.status="���";return}
		CircleNums=2
		for (Circle=1;Circle<CircleNums;Circle++)
				{
					var TemData=ReadFromExcel(FileOpenObj.value,Circle);
					if (Circle==1) 
					{
						
						TableFill("TableDataTitle",TemData,1,1);
						TableFill("TableData",TemData,2,"")
					}
					else 
					{ TableFill("TableData",TemData,1,"")
					}
				}
		window.status="���"
		ErrorTextObj.value=""
		//SetTableWidth("TableDataTitle","TableDataTitle2")
}

document.body.onload = BodyOnLoad;