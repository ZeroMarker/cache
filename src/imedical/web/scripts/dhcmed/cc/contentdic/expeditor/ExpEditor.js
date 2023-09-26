
var objEditorPanel = null;

function InsertText(txt)
{
		var objEditor = document.getElementById("txtExpression");
		objEditor.SelLength = 0;
		objEditor.SelText = txt;
}

function txtExpression_Change()
{
	var intEnd = 0;
	var intStart = 0;
	var flag = false;
	var changeColorFlag = false;
	intPos = objTxtExp.SelStart;
	intEndPos = objTxtExp.SelStart;
	//window.alert("SelStart"+objTxtExp.SelStart+ "   length:"+objTxtExp.Text.length);
	for(var i = objTxtExp.SelStart; i <= objTxtExp.Text.length-1; i ++)
	{
		var strChar = objTxtExp.Text.substr(i, 1);
		if((strChar == "\r")||(strChar == "\n"))
			break;
		intEndPos = i;
	}
	for(var i = intEndPos; i > 0; i --)
	{
		var strChar = objTxtExp.Text.substr(i, 1);
		if((strChar == "\r")||(strChar == "\n"))
			break;
		switch(strChar)
		{
			case "]":
				//if(intPos == i + 1)
				//{
					intEnd = i;
					flag = true;
				//}
				break;
			case "[":
				if(flag)
				{
					intStart = i;
					flag = false;
					objTxtExp.SelStart = intStart;
					objTxtExp.SelLength = intEnd - intStart + 1;
					objTxtExp.SelColor = 255; //red
					//objTxtExp.SelStart = intEnd + 1;
					//objTxtExp.SelStart = intPos;
					//objTxtExp.SelColor = 0;
					//return;
				}
				break;
		}
		if(changeColorFlag)
			break;
	}
	objTxtExp.SelStart = intPos;
	objTxtExp.SelColor = 0;
	
}


function txtExpression_DoubleClick()
{
	var objEditor = document.getElementById("txtExpression");
	var intStart = -1;
	var intEnd = -1;
	for(var i = objEditor.SelStart; i >= 0; i --)
	{
		var strChar = objEditor.Text.substr(i, 1);
		if(strChar == "]")
			return;
		if(strChar == "[")
		{
			intStart = i;
			break;
		}
	}
	for(var i = objEditor.SelStart; i < objEditor.Text.length; i ++)
	{
		var strChar = objEditor.Text.substr(i, 1);
		if(strChar == "[")
			return;
		if(strChar == "]")
		{
			intEnd = i;
			break;
		}
	}
	if((intStart > -1) && (intEnd > -1))
	{
		var selText = objEditor.Text.substr(intStart + 1, intEnd - intStart-1);
		var arryTmp = selText.split("||");
		
		
		objEditorPanel.Interface.call(objEditorPanel, arryTmp[0], intStart, intEnd);
	}
}

function ProcessInputHelperEvent(StartPos, EndPos, Text)
{
	var objEditor = document.getElementById("txtExpression");
	objEditor.SelStart = StartPos;
	objEditor.SelLength = EndPos - StartPos + 1;
	objEditor.SelText = Text
}