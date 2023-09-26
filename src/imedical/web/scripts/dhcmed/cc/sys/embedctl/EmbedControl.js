

//嵌入式监控主函数：
//输入参数：
//	EpisodeID:就诊ID
//	ConfigCode:主题配置代码
//	ObjectID:数据项目ID
//  Action:1--正常  2--删除结果
//输出参数：
//	触发子类代码，用"^"分割
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
				alert('没有设置cspRunServerMethod的函数签名隐藏域，请把【DHCMed.CCService.EmbedCtrl.CoreVM.EmbedControl】添加到页面或组件的隐藏域中！');
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

//window.alert("嵌入式监控已启动~~~~~~");