var SearchCardNoModeobj
document.body.onload = BodyLoadHandler;
function BodyLoadHandler(){
	SearchCardNoModeobj= document.getElementById("SearchCardNoMode");
	if (SearchCardNoModeobj){
		SearchCardNoModeobj.size=1;
		SearchCardNoModeobj.multiple=false;
	}
	var obj = document.getElementById("Save"); 
	if (obj) obj.onclick = Save_click;
	var SearchCardNoMode=document.getElementById("GetCardNoSearchMode").value
	if(SearchCardNoMode=="TC"){
		SearchCardNoModeobj.selectedIndex = 2;
	}
	if(SearchCardNoMode=="PC"){
		SearchCardNoModeobj.selectedIndex = 1;
	}
}
function Save_click()
{
	var obj=document.getElementById("SaveCardNoSearchMode");
	if(obj){var encmeth=obj.value} else{encmeth=""}
	var mSearchCardNoMode = SearchCardNoModeobj.options[SearchCardNoModeobj.selectedIndex].value;
	var rtn=cspRunServerMethod(encmeth,"SearchCardNoModeConfig",mSearchCardNoMode);
	if(rtn=="0"){
		alert("±£´æ³É¹¦!")
	}
}
