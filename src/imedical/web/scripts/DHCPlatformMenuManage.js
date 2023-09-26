function cspProcessResponse(req) {
	if(req.status != 200) {
		var err='Unexpected status code, unable to process HyperEvent: ' + req.statusText + ' (' + req.status + ')';
		if (typeof cspRunServerMethodError == 'function')
			return cspRunServerMethodError(err);
		alert(err);
		return null;
	}

	var i;
	var result=req.responseText;
	var lines = result.split("\r\n");
	var ok = 0;
	var len=lines.length;
	if (lines[len-1]=="") len=len-1;
	for (i=2; i<len; i++) {
		if (lines[i]=="#OK") {
			ok = i;
			break;
		}
	}

	if ((ok==0) || ((lines[1]!="#R") && (lines[1]!="#V"))) {
		var err='Http object response incomplete or invalid.'+ok+","+lines[1];
		if (typeof cspRunServerMethodError == 'function')
			return cspRunServerMethodError(err);
		alert(err);
		return null;
	}

	var result = null;
	if (lines[1] == "#R") {
		var result = "";
		if (ok+1 < len) {
			result = lines[ok+1];
			for (i = ok + 2; i < len; i++) {
				result = result + "\r\n" + lines[i];
			}
		}
	}

	var js = '';
	if (ok > 2) {
		js = lines[2];
		for (i = 3; i < ok; i++) js = js + "\r\n" + lines[i];
		try {
			var bidding = new Function('CSPPage', js);
			bidding(self);
		} catch (ex) {
			var err = 'A JavaScript exception was caught during execution of HyperEvent:\n';
			err += ex.name + ': ' + ex.message + '\n';
			err += '--------------------------------------\nResult: ' + result + '\n';
			err += '--------------------------------------\nJavaScript code:\n';
			err += js;
			/*
			if (typeof cspRunServerMethodError == 'function') return cspRunServerMethodError(err);
			*/
			//alert(err);
		}
	}

	// Allow caller to display a debug window.
	if ((typeof cspRunServerDebugWindow != "undefined") && cspRunServerDebugWindow) {
		var debugwin=window.open("","DebugWindow","scrollbars,resizable,height=400,width=700");
		if (debugwin.document.f == null) {
			debugwin.document.write("<html><head></head><body>");
			debugwin.document.title="HyperEvent Debug Window";
			debugwin.document.write('<form name="f">');
			debugwin.document.write('<br>Javascript<br><textarea name="js" cols="80" rows="12">');
			debugwin.document.write(js);
			debugwin.document.write('</textarea>');
			debugwin.document.write('<br>Return Value<br><textarea name="r" cols="80" rows="2">');
			debugwin.document.write(result);
			debugwin.document.write('</textarea>');
			debugwin.document.write('</form>');
			debugwin.document.write("</body></html>");
		} else {
			debugwin.document.f.js.value = js;
			debugwin.document.f.r.value = result;
		}
	}

	return result;
}
function $DHCAjax(itemName){
	var obj = document.getElementById(itemName) ; 
	if (obj) {
		var encmeth = obj.value ;
	}else{
		alert("没有发现元素:\n\n\t" + itemName) ;
		return ;
	}
	arguments[0] = encmeth ;
	var rtn = cspRunServerMethod.apply(this,arguments) ;
	return rtn ;
}
function update(v){
	document.getElementById("MenuTextPath").value = v;
	
}
function launchPopupWindow(page,features,pageName)
{
	if (features == null) {
		features = "status,scrollbars,resizable";
	}
	var wid = self.screen.width;
	var hgt = self.screen.height;
	wid = wid * 0.8;
	hgt = hgt * 0.8;
	var top = self.screen.height * 0.1;
	var left = self.screen.width * 0.1;
  	var id = '$ID1=';
  	var questionmark = page.split("?");
  	var url;
  	if (questionmark.length > 1) {
	  	url = escape(questionmark[0]) + "?" + questionmark[1];
	  	url = url + "&" + id;
  	} else {
	  	url = page + "?" + id;
  	}
	if (pageName == null) {
		pageName = 'autopagePopup';
	}
	self.autopagePopupWindow = window.open(url,pageName,'left='+left+',top='+top+',width='+wid+',height='+hgt+(features==''?'':','+features));
	self.autopagePopupWindow.focus();
}
function gotoBrowse(number,param)
{
	if (number == 1) var remotefile = document.getElementById("MenuTextPath").value;
	else var remotefile = document.getElementById("LocalFileName").value;
	var url = "/csp/sys/UtilFileSelect.csp?$NAMESPACE=DHC-APP&Dir=" + cspEncodeUTF8(remotefile) + "&" + param;
	return launchPopupWindow(url);
}
function browseOnclickHandler(){
	gotoBrowse(1,"Wizard=Save&Wild=*.xml");
}
function exportOnclickHandler(){
	var groupRowid = document.getElementById("GroupRowid").value;
	var menuName = document.getElementById("MenuName").value;
	var path = document.getElementById("MenuTextPath").value;
	if(path=="") {alert(t['SelectPath']);return ;}
	var rtn = "";
	if(menuName!=""){
		var rtn = $DHCAjax("DownLoadMenus",menuName,path)
	}else if(groupRowid!=""){
		rtn = $DHCAjax("DownLoadMenusByGroup",groupRowid,path);
	}else{
		rtn = t['SelectMenuOrGroup']
	}
	alert(rtn);
}
function importOnclickHandler(){
	var path = document.getElementById("MenuTextPath").value;
	if(path=="") {alert(t['SelectPath']);return ;}
	var overload = document.getElementById("overload").checked;
	overload = overload==true ? 1 : 0;
	var rtn = $DHCAjax("UpLoadMenus",path,overload);
	alert(rtn);
}
function getGroupRowid(str){
	document.getElementById("GroupRowid").value = str.split("^")[1];
}
function bodyOnloadHandler(){
	var obj = document.getElementById("RemoteBrowse");
	if(obj){
		obj.onclick = browseOnclickHandler;
	}
	obj = document.getElementById("RemoteExport");
	if(obj){
		obj.onclick = exportOnclickHandler;
	}
	obj = document.getElementById("RemoteImport");
	if(obj){
		obj.onclick = importOnclickHandler;
	}
}
document.body.onload = bodyOnloadHandler;