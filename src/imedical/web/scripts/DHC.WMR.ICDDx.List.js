function initEvent()
{
	document.getElementById("txtAlias").onkeydown=onkeydownAlias;
	document.getElementById("cmdQuery").onclick=onclickQuery;
}

function onclickQuery()
{
	DisplayICDDxList();
	return false;
}

function onkeydownAlias()
{
	if(window.event.keyCode != 13){return;}
	DisplayICDDxList();
	return false;
}

function DisplayICDDxList()
{
	var obj=document.getElementById("txtAlias");
	if (obj){
		var cAlias=obj.value;
		/*
		//var lnk=parent.dataframe.location.href;        //modify by liyi2013-02-02
		var lnk=parent.frames[1].location.href;
		var tmpList=lnk.split("&Alias")
		if (tmpList.length>1){
			lnk=tmpList[0];
		}
		lnk=lnk+"&Alias="+cAlias;
		*/
		link="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.ICDDx.List&Alias="+cAlias
		//parent.dataframe.location.href=lnk;   //modify by liyi2013-02-02
		window.location.href=link;
	}
}

initEvent();