/*
	��ȡ��ѡ��������ȿؼ���ֵ
*/
function GetListValue(listObj)
{
	var result = ""
	if (listObj)
	{
		for (x in listObj)
		{
			var value = listObj[x].Value;
			if (result == "")
			{
				var result = value	
			}else{
				var result = result+","+value
			}
		}	
	}
	return result;
}

/*
	��ȡ��ѡ��������ȿؼ����ı�
*/
function GetListText(listObj)
{
	var result = ""
	if (listObj)
	{
		for (x in listObj)
		{
			var value = listObj[x].Text;
			if (result == "")
			{
				var result = value	
			}else{
				var result = result+","+value
			}
		}	
	}
	return result;
}

function isObjectElement(id)
{
	if (id.indexOf("RadioElement") != -1 
		|| id.indexOf("CheckElement") != -1 
		|| id.indexOf("DropListElement") != -1
		|| id.indexOf("DropRadioElement") != -1
		|| id.indexOf("DropCheckboxElement") != -1
		)
	{
		return true;
	}
	return false;
}

// ��ȡת�����ֵ
function getTransferValue(id)
{
	if (isObjectElement(id))
	{
		var listObj = GetValueByName(id)
		var listText = GetListText(listObj);
		return listText;
	}
	return GetValueByName(id);
}

// ��ɱ��浽���ݿ�ĸ�ʽ
// formatDBValue("CheckElement_3","Item1")
// json��ʽ��[{"NumberValue":"1","Text":"��","Value":"1"}]
function fmtItemValueByElementName(id,itemName)
{
	var result = ""
	// ��ѡѡ���
	if (isObjectElement(id))
	{
		var json = []
		// ��ȡ��ѡѡ���ֵ
		var listObj = GetValueByName(id)
		var listText = GetListText(listObj);
		if (listText != "")
		{
			var arr = listText.split(",")
			for (i in arr)
			{
				var text = arr[i]
				var object = {}
				object.Text = text
				json.push(object)
			}
		}
		result = JSON.stringify(json)
	}else
	{
		// �ı���
		result = GetValueByName(id)
	}
	return result;
}

// �򿪻���ƻ��ƶ�ҳ��
function OpenPlanWindow(func,paramEpisodeID,emrCode,itemArray)
{
	// �������ɻ�������
	makeQuestion(paramEpisodeID,emrCode,itemArray)
	
	// url ����
	// var formatItemValue = encodeURI(formatItemValue)
	var urlPartParam = 'EpisodeID=' + paramEpisodeID + '&Redirect=1' + '&emrCode=' + emrCode; // + '&formatItemValue=' + formatItemValue;
	var windowsInfo = {width: $(window).width() - 20, height: $(window).height() - 5}
	OpenWindow('nur.hisui.nurseplanmake',func,null,urlPartParam,windowsInfo)
	//return func;
}

// ������-ǰ�˵����ť ֱ�Ӵ�������
function makeQuestion(episodeID,emrCode,itemArray)
{
	var wardId = session['LOGON.WARDID'];
	var ctLocId = session['LOGON.CTLOCID'];
	var recUserId = session['LOGON.USERID'];
	var hospDR = session['LOGON.HOSPID'];
	
	var extMap = {}
	extMap.emrCode = emrCode
	extMap.recUserId = recUserId
	extMap.itemArray = itemArray
	
	var result = $m({
		ClassName: "Nur.NIS.Service.Base.Assess",
		MethodName: "AssessToQuestion",
		episodeID:episodeID, 
		wardId:wardId,
		locId:"",
		emrRecordId:"",
		bodyAssess:"",
		hospDR:hospDR, 
		AssessToQueFlag:"",
		extMap:JSON.stringify(extMap)
	},false);
	
	return result;
}

// ����ƻ�ҳ��رպ�ص���������ƻ����ݣ����⡢Ŀ�ꡢ��ʩ��
function getPlanRecordByPage(episodeID,emrCode,itemArray)
{
	var result = ""
	// ǰ�˹�ѡ����
	if (itemArray && itemArray != "[]" && itemArray!="")
	{
		var ret = $cm({
			ClassName: "Nur.NIS.Service.NursingPlan.QuestionRecord",
			MethodName: "GetPlanRecordByPage",
			episodeID:episodeID, 
			emrCode:emrCode,
			itemList:JSON.stringify(itemArray)
		},false);
		
		if (ret)
		{
			var result = ret
		}
	}
	// ����ձ���
	if (result == "")
	{
		var result = {queWord:"",intervWord:""}
	}
	return result;
}

// ��ȡ��֯����������
// args : {item:itemName,value:itemValue} ...args --IE �²����ݶ�̬����,chromeû����
function getOutArray(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15)
{
	var array = [] 
	if (arg1){array.push(arg1)};
	if (arg2){array.push(arg2)};
	if (arg3){array.push(arg3)};
	if (arg4){array.push(arg4)};
	if (arg5){array.push(arg5)};
	if (arg6){array.push(arg6)};
	if (arg7){array.push(arg7)};
	if (arg8){array.push(arg8)};
	if (arg9){array.push(arg9)};
	if (arg10){array.push(arg10)};
	if (arg11){array.push(arg11)};
	if (arg12){array.push(arg12)};
	if (arg13){array.push(arg13)};
	if (arg14){array.push(arg14)};
	if (arg15){array.push(arg15)};
    return array;
}

// ��ȡ����ѡ���+������ı��� --�ϲ����ȡ���յ����� 2021.7.15
function GetOtherValue(normalCheckValue, otherCheckValue, otherText)
{
	var finalstr = otherText
	if (otherCheckValue == "" && normalCheckValue != "")
	{
		finalstr = "," + otherText;
	}
	if (otherCheckValue != "")
	{
		finalstr = otherText;
	}
	if (otherCheckValue == "" && otherText == "")
	{
		finalstr = ""
	}
	return finalstr;
}


// ����ؼ�����ѡʱ��ƴ����ֵ������  2021.7.15
function GetValueExceptEmpty(preStr, value)
{
	if (preStr != "" && value != "")
	{
		return preStr + value;
	}
	return "";
}

// ����ַ�����һλ�Ƕ��Ż���������ţ���Ҫȥ��
function removeSpecFirstChar(str)
{
	var final = ""
	if (str != "")
	{
		var tmp = str.substr(0, 1)
		if (tmp == "," || tmp== "," || tmp == ":" || tmp == "��" || tmp == ";" || tmp == "��")
		{
			if (str.length >=2)
			{
				final = str.substr(1,str.length - 1)
			}
		}else
		{
			final = str
		}
	}
	return final;
}