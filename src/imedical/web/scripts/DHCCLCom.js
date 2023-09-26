
// Set element objTarget by objSource value
// Element value access depend on type (V:obj.value,I:obj.innerText)
// If source value equals omitStr,set defaultStr
function SetElementByElement(targetElementName,typeT,sourceElementName,typeS,omitStr,defaultStr)
{
	var objTarget=document.getElementById(targetElementName);
	if (! objTarget) return;
	var objSource=document.getElementById(sourceElementName);
	if (! objSource) return;
	
	var value=defaultStr;
	switch (typeS)
	{
		case "V":
			value=objSource.value;
			break;
		case "I":
			value=objSource.innerText;
	}
	if (omitStr==value) value=defaultStr
	switch (typeT)
	{
		case "V":
			objTarget.value=value;
			break;
		case "I":
			objTarget.innerText=value;
			break;
	}
}

// Set element object value
// Element value access depend on type (V:obj.value,I:obj.innerText)
function SetElementValue(elementName,type,value)
{	
	var obj=document.getElementById(elementName);
	if (! obj) return;
	switch (type)
	{
		case "V":
			obj.value=value;
			break;
		case "I":
			obj.innerText=value;
			break;
	}
}

// Get element object value
// Element value access depend on type (V:obj.value,I:obj.innerText)
function GetElementValue(elementName,type)
{
	var obj=document.getElementById(elementName);
	if (! obj) return "";
	var value="";
	switch (type)
	{
		case "V":
			value=obj.value;
			break;
		case "I":
			value=obj.innerText;
			break;
	}
	return value;
}

// If mainElement's value equals conditionValue,set attachElement with setValue. 
// Element value access depend on type (V:obj.value,I:obj.innerText)
// Use as clear attach Element value
function SetAttachElementByName(mainElementName,mainType,conditionValue,attachElementName,attachType,setValue)
{
	var objMain=document.getElementById(mainElementName);
	if (objMain) 
	{
		mainValue=GetElementValue(mainElementName,mainType)
		if (mainValue==conditionValue)
		{
			SetElementValue(attachElementName,attachType,setValue)
		}
	}
}

// Set two element from a list (value splitted by delimit),at each pos.
// Element value access depend on type (V:obj.value,I:obj.innerText)
// Use in put selected query data into element.
function SetElementFromListByName(firstElementName,firstType,secondElementName,secondType,value,delimit,firstPos,secondPos)
{
	var objFirst=document.getElementById(firstElementName);
	if (! objFirst) return "First object is null!";
	var objSecond=document.getElementById(secondElementName);
	if (! objSecond) return "Second object is null!";
	var valueList=value.split(delimit)
	if ((valueList.length<=firstPos)||(valueList.length<=secondPos)) return  "Index exceed list length!";
	SetElementValue(firstElementName,firstType,valueList[firstPos]);
	SetElementValue(secondElementName,secondType,valueList[secondPos]);
}

// Set element from a list (value splitted by delimit)at pos,return value at returnPos
// Element value access depend on type (V:obj.value,I:obj.innerText)
// Use in put selected query data into element and a variable.
function SetElementAndReturnFromList(elementName,type,value,delimit,pos,returnPos)
{
	var obj=document.getElementById(elementName);
	if (! obj) return "";
	var valueList=value.split(delimit);
	if ((valueList.length<=pos)||(valueList.length<=returnPos)) return "";
	SetElementValue(elementName,type,valueList[pos]);
	return valueList[returnPos];
}
