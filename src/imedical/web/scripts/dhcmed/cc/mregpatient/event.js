var CHR_1=String.fromCharCode(1);

function InitwinViewportEvent(obj)
{
	obj.InitArgument = function()
	{
		var sAppCode=ExtTool.GetParam(window, "AppCode");
		if (sAppCode=="")
		{
			ExtTool.alert("��ʾ","û�����ü������!");
			return;
		}
		var objAppCols = ExtTool.StaticServerObject("DHCMed.CCService.SubAppColsSrv");
		var retStr = objAppCols.GetGridHeader(sAppCode);
		if (retStr=="")
		{
			ExtTool.alert("��ʾ","�������û������չ�ַ�ʽ!");
			return;
		}
		var retList=retStr.split(CHR_1);
		if (retList.length>=2)
		{
			obj.AppCode=sAppCode;
			obj.ShowClassName=retList[0];
			obj.ShowQueryName=retList[1];
			window.eval(retList[2]);
			obj.ShowColModel=colModel;
		}
	}
	
	obj.LoadEvent = function(args)
	{
	  	try{
	  		var colModel = obj.ShowColModel;
	  		var store = ExtTool.CreateDataStoreByQuery(
		  		obj.ShowClassName,
		  		obj.ShowQueryName,
		  		function()
		  		{
		  			return [
		  			obj.AppCode
		  			,''
		  			];
		  		}
	  		);
	  		obj.rstGridPanel.reconfigure(store, colModel);
	  		store.load({});
	  	}catch(e){
	  		window.alert(e.description);
	  	}
  	};
  	
	obj.btnQuery_click = function()
	{
			var FromDate=obj.dtFromDate.getRawValue();
			var ToDate=obj.dtToDate.getRawValue();
			var AdmType="I";
			var Condition='aAdmType=' + AdmType + '&aFromDate=' + FromDate + '&aToDate=' + ToDate;
	  		var colModel = obj.ShowColModel;
	  		var store = ExtTool.CreateDataStoreByQuery(
		  		obj.ShowClassName,
		  		obj.ShowQueryName,
		  		function()
		  		{
		  			return [
		  			obj.AppCode
		  			,Condition
	  			];
	  		}
  		);
  		obj.rstGridPanel.reconfigure(store, colModel);
  		store.load({}); 
	};
/*winViewport��������ռλ��*/
}
function InitmainwinViewportEvent(obj)
{	obj.LoadEvent = function(args)
	{
	}
	obj.btnQuery_click = function()
	{
	};
/*mainwinViewport��������ռλ��*/
}
