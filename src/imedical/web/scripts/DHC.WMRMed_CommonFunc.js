var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_Up="^";
var CHR_Tilted="/";
/**********************************************
/
***********************************************/
function gClearAllList(ListName) {
	var obj=document.getElementById(ListName);
	for (var i=obj.options.length-1; i>=0; i--) {
		obj.options[i] = null;
		}
}

/**********************************************
/
***********************************************/
function gGetObjType(objname){	
	var obj=document.getElementById(objname);
	if (obj){
		alert(obj.type);
		}
	}

/**********************************************
/
***********************************************/
function gGetObjValue(objname)
{
	var obj=document.getElementById(objname);
	var ret="";
	if (obj){
		switch (obj.type)
		{
			case "select-one":
				myidx=obj.selectedIndex;
				ret=obj.options[myidx].text;
				break;
			case "checkbox":
				ret=obj.checked;
				break;
			default:
				ret=obj.value;
				break;
		}
	}
	return ret;
}

/**********************************************
/
***********************************************/
function gSetObjValue(objname,val)
{
	var obj=document.getElementById(objname);
	if (obj){
		obj.value=val;
		}
	return;
}
/**********************************************
/
***********************************************/
function gGetListData(objname)
{
	var obj=document.getElementById(objname);
	var ret="";
	if (obj){
		switch (obj.type)
		{
			case "select-one":
			    if (obj.options.length==0) break;
				myidx=obj.selectedIndex;
				ret=obj.options[myidx].value;
				break;
			case "checkbox":
				if (obj.checked==true){
					ret="Yes";
				}else{
					ret="No";
				}
				break;
			default:
				ret=obj.value;
				break;
		}
	}
	return ret;
}
/**********************************************
/
***********************************************/
function gSetListValue(objname,txt,val){
	var obj=document.getElementById(objname);
	if (obj){
		var oOption = document.createElement("OPTION");
        oOption.text=txt;
        oOption.value=val;
        obj.add(oOption);
		}
	}
/**********************************************
/
***********************************************/
function gSetListIndex(objname,Index){
	var obj=document.getElementById(objname);
	if (obj){
		//obj.selectedIndex=Index;
		obj.options[Index].selected=true;
		}
	}
function gSetListIndexByVal(objname,val){
	var obj=document.getElementById(objname);
	if (obj){
		for (i=0;i<obj.options.length;i++){
			if (val==obj.options[i].value){
				obj.options[i].selected=true;
				return;
				}
			}
		}
	}

/**********************************************
/
***********************************************/
function gGetListCodes(objname){
	var obj=document.getElementById(objname);
	var s=""
	if (obj){
		for (i=0;i<obj.options.length;i++){
			if (obj.options[i].selected==true) s+=obj.options[i].value+CHR_Up
			}		
		}
	if (s!="") s=s.substr(0,s.length-1)
	return s
	}
	
/**********************************************
/
***********************************************/
function gFormatDate(val){
	if (val==""){
		return "";
		}
	else{
		var TempPlist=val.split("-");
		var ret=TempPlist[2]+"/"+TempPlist[1]+"/"+TempPlist[0];
		return ret;
		}
	}
/**********************************************
/
***********************************************/
function gFormatDateA(val){
	if (val==""){
		return "";
		}
	else{
		var TempPlist=val.split("/");
		var ret=TempPlist[2]+"-"+TempPlist[1]+"-"+TempPlist[0];
		return ret;
		}
	}

/**********************************************
/
***********************************************/
function gHiddenElement(eleName){
	var obj=document.getElementById(eleName);
    if (obj){obj.style.visibility="hidden";}
	}
/**********************************************
/
***********************************************/
function gSetFocus(eleName){
	var obj=document.getElementById(eleName);
    if (obj){obj.focus();}
	}

//****************************************************************
//
//****************************************************************
function cTrim(sInputString,iType)
{
  var sTmpStr = ' '
  var i = -1

  if(iType == 0 || iType == 1)
  {
     while(sTmpStr == ' ')
     {
       ++i
       sTmpStr = sInputString.substr(i,1)
     }
     sInputString = sInputString.substring(i)
  }

  if(iType == 0 || iType == 2)
  {
    sTmpStr = ' '
    i = sInputString.length
    while(sTmpStr == ' ')
    {
       --i
       sTmpStr = sInputString.substr(i,1)
    }
    sInputString = sInputString.substring(0,i+1)
  }
  return sInputString
}