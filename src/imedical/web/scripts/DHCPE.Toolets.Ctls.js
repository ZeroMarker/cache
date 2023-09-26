/*
/Created by Robert 2006/2/16
/Filename: DHCPE.Toolets.ctls.JS
/Description: ��TrakCareҳ�洦��ʱ?�Կؼ����д���Ĺ��ú���
/filename: Bob.Toolets.Ctls.JS
/�����б�:
/-------------------
/	function FillCtls(DataStr, MatchCtlsSpec, Splitor)
/	function GetCtlsValue(CtlsSpec, Splitor)
/	function SetCtlValueById(ctlID, ctlValue, withAlert)
/	function GetCtlValueById(ctlID, withAlert)
/	function AddElementToList(myList, myInnerText, myValue){
/	function DisabledCtls(tagType,isToDisabled)
*/
///------------------------------------------------

/*
/Created by robert 2006/2/16
/Descripiton: ��CSP��ҳ��?�ø������ַ��������ҳ���пؼ���ֵ
/Parameters
/		 DataStr: �������ַ���,��"Robert^1234^��^1980/1/1^"
/		 MatchCtlsSpec: ��ҳ���еĿؼ�ID����,ͬDataStr�ĸ�ʽһ��,�Բ����ڵĿؼ���"_"��ʼ. ��:
/		 				"Name^ID^gender^_birthday"
/		 Splitor: �ַ����еķָ���. ��"^"
*/
function FillCtls(DataStr, MatchCtlsSpec, Splitor)
{
	var arrData=DataStr.split(Splitor);
	var arrCtls=MatchCtlsSpec.split(Splitor);
	if (arrData.length!=arrCtls.length)
	{
		alert("���������ʱ?���ݲ����! DataStr= " + DataStr + "    MatchCtlsSpec = " + MatchCtlsSpec );
	 	return;
	}
	var i;
	for(i=0;i<arrData.length;i++)
	{
		if (arrCtls[i].indexOf("_")==0) 
			continue;		
		SetCtlValueByID(arrCtls[i], arrData[i],true);
	}
}

/*
/Created by robert 2006/2/17
/Descripiton: ��CSP��ҳ��, ��ҳ���пؼ���ֵ���������ַ����ĸ�ʽ������
/Parameters
/		 CtlsSpec: Ҫ���ؿؼ��ĸ�ʽ. ��"Name^ID^gender^_birthday"
/		 Splitor: �ַ����еķָ���. ��"^"
/Return: ��CtlsSpec�ĸ�ʽ���ظ��ؼ���ֵ. ��:"robert^1234^��^1999-1-1"
*/
function GetCtlsValue(CtlsSpec, Splitor)
{	
	var arrCtls=CtlsSpec.split(Splitor);
	var returnData=GetCtlValueById(arrCtls[0], true);
	for(var i=1;i<arrCtls.length;i++)
	{
		returnData=returnData + Splitor + GetCtlValueById(arrCtls[i], true);		
	}
	return returnData;
}

/*
/Created by robert 2006/2/17
/Descripiton: ��CSP��ҳ��, ��ָ���Ŀؼ�����ָ����ֵ
/Parameters
/		 ctlID: �ؼ�ID
/		 ctlValue Ҫ���õ�ֵ
/		 withAlert: �ؼ�������ʱ�Ƿ���ʾ����
/Return: null
*/
function SetCtlValueById(ctlID, ctlValue, withAlert){
	SetCtlValueByID(ctlID, ctlValue, withAlert)
}
function SetCtlValueByID(ctlID, ctlValue, withAlert)
{
	var myObject=document.getElementById(ctlID);
	if (myObject)
		myObject.value=ctlValue;
	else if (withAlert)
		alert("�ؼ�: " + ctlID + "  ������?");
}

/*
/Created by robert 2006/2/17
/Descripiton: ��CSP��ҳ��, ȡָ���Ŀؼ���ֵ
/Parameters
/		 ctlID: �ؼ�ID
/		 withAlert: �ؼ�������ʱ�Ƿ���ʾ����
/Return: �ؼ���ֵ, �����ڽ����ؿ�
*/
function GetCtlValueById(ctlID, withAlert)
{
	if (ctlID=="")
		return "";
	var myObject=document.getElementById(ctlID);
	if (myObject){
		if (myObject.type=="checkbox") return myObject.status;
		//if (myObject.tag=="label") return myObject.innerText;
		return myObject.value;
		}
	else {
		if (withAlert) alert("�ؼ�: " + ctlID + "  ������?");
		return "";
	}
}

function AddElementToList(myList, myInnerText, myValue){
	var oOption = document.createElement("OPTION");
	myList.options.add(oOption);
	oOption.innerText = myInnerText;
	oOption.value = myValue;
	//myList.options.add(newElement);
}

//Description: disable/Enable all the controls which is special tag.
//parameters:
/*
function DisabledCtls(tagName,isToDisabled, tagType){
	if (tagType==null) {tagType="";	}
	var doc_ctls = document.all.tags(tagName);
	for (i=0; i<doc_ctls.length; i++)
	{
		if ((tagType!="")&&(doc_ctls(i).type!=tagType)){
			continue;
		}
		if (doc_ctls(i).id.substring(0,3)=="tbM") continue;
	    if (tagName!="input"){
	    doc_ctls(i).disabled=isToDisabled;}
	    else{
	    	doc_ctls(i).readonly=isToDisabled;}
	    if (tagName.toLowerCase()=="a"){
		    doc_ctls(i).onclick=function(){return false;};
    	}
	}
}
*/

function DisabledCtls(tagName,isToDisabled, tagType){
	if (tagType==null) {tagType="";	}
	var doc_ctls = document.all.tags(tagName);
	for (i=0; i<doc_ctls.length; i++)
	{
		if ((tagType!="")&&(doc_ctls(i).type!=tagType)){
			continue;
		}
		if (doc_ctls(i).id.substring(0,3)=="tbM") continue;
		if (doc_ctls(i).id=="DBRAudit") continue;
	    doc_ctls(i).disabled=isToDisabled;
	    if (tagName.toLowerCase()=="a"){
		    doc_ctls(i).onclick=function(){return false;};
    	}
	}
}
