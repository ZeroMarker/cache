

//Ƕ��ʽ�����������
//���������
//	EpisodeID:����ID
//	ConfigCode:�������ô���
//	ObjectID:������ĿID
//  Action:1--����  2--ɾ�����
//���������
//	����������룬��"^"�ָ�
function EmbedControl(EpisodeID, ConfigCode ,ObjectID, Action)
{
	var ret = null;
	try
	{
		if(tkMakeServerCall != null)
		{
			ret = tkMakeServerCall("DHCMed.CCService.EmbedCtrl.CoreVM", "EmbedControl", EpisodeID, ConfigCode, ObjectID, Action);
		}else
		{
			if(window.getElementById("EmbedControl") == null)
			{
				alert('û������cspRunServerMethod�ĺ���ǩ����������ѡ�DHCMed.CCService.EmbedCtrl.CoreVM.EmbedControl����ӵ�ҳ���������������У�');
				return null;
			}
		
			ret = cspRunServerMethod(
				window.getElementById("EmbedControl").value,
				EpisodeID, 
				ConfigCode, 
				ObjectID,
				Action
			);
		}
		var objRet = eval("(" + ret + ")");
	}catch(error)
	{
		alert(error.message);
	}
	return ret;
}

//window.alert("Ƕ��ʽ���������~~~~~~");