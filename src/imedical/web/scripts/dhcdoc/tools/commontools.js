var ShortcutKeyJson=[];
$(document.body).bind("keydown",BodykeydownHandler);
function InitCSPShortcutKey(cspName){
	ShortcutKeyJson=$.cm({
		ClassName:"DHCDoc.Util.Base",
		MethodName:"GetCSPShortcutKeyJSON",
		cspName:cspName
	},false);
	for (var i=0;i<ShortcutKeyJson.length;i++){
		var id=ShortcutKeyJson[i].id;
		var ShortcutKey=ShortcutKeyJson[i].ShortcutKey;
		if (ShortcutKey=="") continue;
		if (($("#"+id).length==1)&&($("#"+id).hasClass('l-btn'))){
			var _$BtnText=$("#"+id+" .l-btn-text");
			var innerText=_$BtnText[0].innerText;
			_$BtnText[0].innerText=innerText+"("+ShortcutKey+")";
		}
	}
}
function BodykeydownHandler(e){
   if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
   }else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
   }
   //浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
       if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
       }else{   
            keyEvent=true;   
       }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }  
    for (var i=0;i<ShortcutKeyJson.length;i++){
	    var ShortcutKeyCode=ShortcutKeyJson[i].KeyCode;
	    if (ShortcutKeyCode==keyCode){
		    var callBackFun=ShortcutKeyJson[i].callBackFun;
		    if (callBackFun) eval('(' + callBackFun + ')')();
		    break;
		}
	}
}