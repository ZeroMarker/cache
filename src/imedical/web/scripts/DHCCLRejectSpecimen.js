var obj=document.getElementById('queryRegNo');
if (obj){
	obj.onkeydown=regNo_keydown;
}

function regNo_keydown(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	try {
		if ((keycode==13)||(keycode==9)){
			var obj=document.getElementById("queryRegNo");	
		  if ((obj)&&(obj.value!="")){
				websys_setfocus("regNo");
				return websys_cancel();
			}
		}
	}catch(e) {}
	//return websys_cancel();
}