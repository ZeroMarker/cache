/*
/Created by Robert 2006/2/16
/Filename: DHCPE.Toolets.ctls.JS
/Description: 对TrakCare页面处理时?对控件进行处理的公用函数
/filename: Bob.Toolets.Ctls.JS
/方法列表:
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
/Descripiton: 在CSP面页中?用给定的字符串来填充页面中控件的值
/Parameters
/		 DataStr: 在数据字符串,如"Robert^1234^男^1980/1/1^"
/		 MatchCtlsSpec: 在页面中的控件ID名称,同DataStr的格式一致,对不存在的控件以"_"开始. 如:
/		 				"Name^ID^gender^_birthday"
/		 Splitor: 字符串中的分隔符. 如"^"
*/
function FillCtls(DataStr, MatchCtlsSpec, Splitor)
{
	var arrData=DataStr.split(Splitor);
	var arrCtls=MatchCtlsSpec.split(Splitor);
	if (arrData.length!=arrCtls.length)
	{
		alert("在填充数据时?数据不相符! DataStr= " + DataStr + "    MatchCtlsSpec = " + MatchCtlsSpec );
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
/Descripiton: 在CSP面页中, 将页面中控件的值按给定的字符串的格式来返回
/Parameters
/		 CtlsSpec: 要返回控件的格式. 如"Name^ID^gender^_birthday"
/		 Splitor: 字符串中的分隔符. 如"^"
/Return: 按CtlsSpec的格式返回各控件的值. 如:"robert^1234^男^1999-1-1"
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
/Descripiton: 在CSP面页中, 给指定的控件设置指定的值
/Parameters
/		 ctlID: 控件ID
/		 ctlValue 要设置的值
/		 withAlert: 控件不存在时是否提示报警
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
		alert("控件: " + ctlID + "  不存在?");
}

/*
/Created by robert 2006/2/17
/Descripiton: 在CSP面页中, 取指定的控件的值
/Parameters
/		 ctlID: 控件ID
/		 withAlert: 控件不存在时是否提示报警
/Return: 控件的值, 不存在进返回空
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
		if (withAlert) alert("控件: " + ctlID + "  不存在?");
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
