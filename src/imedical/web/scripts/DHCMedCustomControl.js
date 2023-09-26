function isLeapYeAr(y) {
 return ((y%4)==0)&&(!(((y%100)==0)&&((y%400)!=0)));
}
function ReWriteDate(d,m,y) {
 y=parseInt(y,10);
 if (y<15) y+=2000; else if (y<100) y+=1900;
 if ((y>99)&&(y<1000)) y+=1900;
 if ((d<10)&&(String(d).length<2)) d='0'+d;
 if ((m<10)&&(String(m).length<2)) m='0'+m;
 var newdate='';
 newdate=d+'/'+m+'/'+y;
 return newdate;
}
function IsValidDate(fld) {
 var dt=fld.value;
 var re = /^(\s)+/ ; dt=dt.replace(re,'');
 var re = /(\s)+$/ ; dt=dt.replace(re,'');
 var re = /(\s){2,}/g ; dt=dt.replace(re,' ');
 if (dt=='') {fld.value=''; return 1;}
 re = /[^0-9A-Za-z]/g ;
 dt=dt.replace(re,'/');

 for (var i=0;i<dt.length;i++) {
    var type=dt.substring(i,i+1).toUpperCase();
    if (type=='T'||type=='W'||type=='M'||type=='Y') {
       if (type=='T') {return ConvertTDate(fld);} else {return ConvertWMYDate(fld,i,type);}
       break;
    }
 }
 if ((dt.indexOf('/')==-1)&&(dt.length>2)) dt=ConvertNoDelimDate(dt);
 var dtArr=dt.split('/');
 var len=dtArr.length;
 if (len>3) return 0;
 for (i=0; i<len; i++) {
  if (dtArr[i]=='') return 0;
 }
 var dy,mo,yr;
 for (i=len; i<3; i++) dtArr[i]='';
 dy=dtArr[0];mo=dtArr[1];yr=dtArr[2];
 if ((String(yr).length!=2)&&(String(yr).length!=4)&&(String(yr).length!=0)) return 0;
 if ((String(yr).length==4)&&(yr<1840)) return 0;
 var today=new Date();
 if (yr=='') {
  yr=today.getYear();
  if (mo=='') mo=today.getMonth()+1;
 }
 if ((isNaN(dy))||(isNaN(mo))||(isNaN(yr))) return 0;
 if ((dy<1)||(dy>31)||(mo<1)||(mo>12)||(yr<0)) return 0;
 if (mo==2) {
  if (dy>29) return 0;
  if ((!isLeapYear(yr))&&(dy>28)) return 0;
 }
 if (((mo==4)||(mo==6)||(mo==9)||(mo==11))&&(dy>30)) return 0;
 if (isMaxedDate(dy,mo,yr)) return 0;
 fld.value=ReWriteDate(dy,mo,yr);
 websys_returnEvent();
 return 1;
}

function isMaxedDate(dy,mo,yr) {
 var maxDate = new Date();
 maxDate.setTime(maxDate.getTime() + (1000*24*60*60*1000));
 yr = parseInt(yr,10); if (yr<15) yr+=2000; else if (yr<100) yr+=1900;
 if ((yr>99)&&(yr<1000)) yr+=1900;
 var objDate = new Date(yr,mo-1,dy,0,0,0);
 if (maxDate.getTime() < objDate.getTime()) return 1;
 return 0;
}
function ConvertTDate(fld) {
 var today=new Date();
 var dt=fld.value;
 var re = /(\s)+/g ;
 dt=dt.replace(re,'');
 if (dt.charAt(0).toUpperCase()=='T') {
  xdays = dt.slice(2);
  if (xdays=='') xdays=0;
  if (isNaN(xdays)) return 0;
  if ((dt.charAt(1)=='+')&&(xdays>1000)) return 0;
  xdays_ms = xdays * 24 * 60 * 60 * 1000;
  if (dt.charAt(1) == '+') today.setTime(today.getTime() + xdays_ms);
  else if (dt.charAt(1) == '-') today.setTime(today.getTime() - xdays_ms);
  else if (dt.length>1) return 0;
  fld.value=ReWriteDate(today.getDate(),today.getMonth()+1,today.getFullYear());
  websys_returnEvent();
  return 1;
 }
 return 0;
}
function ConvertWMYDate(fld,pos,type) {
 var today=new Date();
 var dt=fld.value;
 var re = /(\s)+/g ;
 dt=dt.replace(re,'');
 var x = dt.substring(0,pos);xmn=0;xyr=0;
 if (x=='') x=1;
 if (isNaN(x)) return 0;
 if (dt.substring(pos+1,dt.length)!='') return 0;
 if (type=='M') {
 while (x>11) {xyr++;x=x-12}
 xmn=today.getMonth()+eval(x);
 if (xmn>=11) {xyr++;today.setMonth(eval(xmn-12));} else {today.setMonth(xmn);}
 } else if (type=='Y') {xyr=x;
 } else {today.setTime(today.getTime() + (x * 7 * 24 * 60 * 60 * 1000));}
 if (isMaxedDate(today.getDate(),today.getMonth()+1,today.getFullYear()+eval(xyr))) return 0;
 fld.value=ReWriteDate(today.getDate(),today.getMonth()+1,today.getFullYear()+eval(xyr));
 websys_returnEvent();
 return 1;
 }
function ConvertNoDelimDate(dt)  {
 var len = dt.length;
 if (len%2) return dt;
 if (len>8) return dt;
 var dy=dt.slice(0,2); var mn=dt.slice(2,4); var yr=dt.slice(4);
 if (yr=='') {
  var today = new Date();
  yr=today.getYear();
 }
 var dtconv=dy+'/'+mn+'/'+yr;
 return dtconv
}
var tmseparator=':';
function ReWriteTime(h,m,s) {
 var newtime='';
 if (h<10) h='0'+h;
 if (m<10) m='0'+m;
 if (s<10) s='0'+s;
 newtime=h+':'+m ;
 return newtime;
}
function IsValidTime(fld) {
 var TIMER=0;
 var tm=fld.value;
 var re = /^(\s)+/ ; tm=tm.replace(re,'');
 var re = /(\s)+$/ ; tm=tm.replace(re,'');
 var re = /(\s){2,}/g ; tm=tm.replace(re,' ');
 tm=tm.toUpperCase();
 var x=tm.indexOf(' AM');
 if (x==-1) x=tm.indexOf(' PM');
 if (x!=-1) tm=tm.substring(0,x)+tm.substr(x+1);
 if (tm=='') {fld.value=''; return 1;}
 re = /[^0-9A-Za-z]/g ;
 tm=tm.replace(re,':');
 if (isNaN(tm.charAt(0))) return ConvNTime(fld);
 if ((tm.indexOf(':')==-1)&&(tm.length>2)) tm=ConvertNoDelimTime(tm);
 symIdx=tm.indexOf('PM');
 if (symIdx==-1) {
  symIdx=tm.indexOf('AM');
  if (symIdx!=-1) {
   if (tm.slice(symIdx)!='AM') return 0;
   else {
    tm=tm.slice(0,symIdx);
    TIMER=1;
  }}
 } else {
  if (tm.slice(symIdx)!='PM') return 0;
  else {
   tm=tm.slice(0,symIdx);
   TIMER=2;
  }
 }
 if (tm=='') return 0;
 var tmArr=tm.split(':');
 var len=tmArr.length;
 if (len>3) return 0;
 for (i=0; i<len; i++) {
  if (tmArr[i]=='') return 0;
 }
 var hr=tmArr[0];
 var mn=tmArr[1];
 var sc=tmArr[2];
 if (len==1) {
  mn=0;
  sc=0;
 } else if (len==2) {
  if (mn.length!=2) return 0;
  sc=0;
 } else if (len==3) {
  if (mn.length!=2) return 0;
  if (sc.length!=2) return 0;
 }
 if ((hr>12)&&(TIMER==1)) return 0;
 if ((hr==12)&&(TIMER==1)) hr=00;
 if ( isNaN(hr)||isNaN(mn)||isNaN(sc) ) return 0;
 hr=parseInt(hr,10);
 mn=parseInt(mn,10);
 sc=parseInt(sc,10);
 if ((hr>23)||(hr<0)||(mn>59)||(mn<0)||(sc>59)||(sc<0)) return 0;
 if ((hr<12)&&(TIMER==2)) hr+=12;
 fld.value=ReWriteTime(hr,mn,sc);
 websys_returnEvent();
 return 1;
}
function ConvNTime(fld) {
 var now=new Date();
 var tm=fld.value;
 var re = /(\s)+/g ;
 tm=tm.replace(re,'');
 if (tm.charAt(0).toUpperCase()=='N') {
  xmin = tm.slice(2);
  if (xmin=='') xmin=0;
  if (isNaN(xmin)) return 0;
  xmin_ms = xmin * 60 * 1000;
  if (tm.charAt(1) == '+') now.setTime(now.getTime() + xmin_ms);
  else if (tm.charAt(1) == '-') now.setTime(now.getTime() - xmin_ms);
  else if (tm.length>1) return 0;
  fld.value=ReWriteTime(now.getHours(),now.getMinutes(),now.getSeconds());
  websys_returnEvent();
  return 1;
 }
 return 0;
}
function ConvertNoDelimTime(tm)  {
 if (isNaN(tm)) return tm;
 var hr=tm.slice(0,2);
 var mn=tm.slice(2);
 var tmconv=hr+':'+mn;
 return tmconv
}
function IsInteger(fld){
	var objStr=fld.value;
	var reg=/^\+?[0-9]*[0-9][0-9]*$/;
	var ret=objStr.match(reg);
	if(ret==null){return false}else{return true}
}
function IsNumber(fld){
	var objStr=fld.value;
	var strRef = "-1234567890.";
	var tempChar="";
	for (i=0;i<objStr.length;i++) {
		tempChar= objStr.substring(i,i+1);
		if (strRef.indexOf(tempChar,0)==-1) {return false;}
	}
	return true;
}

function txtDate_changehandler(e) {
	var eSrc=websys_getSrcElement(e);
	if (!IsValidDate(eSrc)) {
		eSrc.className='clsInvalid';
		websys_setfocus(eSrc.id);
		return websys_cancel();
	} else {
		eSrc.className='';
		return 1;
	}
}

function txtTime_changehandler(e) {
	var eSrc=websys_getSrcElement(e);
	if (!IsValidTime(eSrc)) {
		eSrc.className='clsInvalid';
		websys_setfocus(eSrc.id);
		return websys_cancel();
	} else {
		eSrc.className='';
		return 1;
	}
}

function txtNumber_changehandler(e) {
	var eSrc=websys_getSrcElement(e);
	if (!IsNumber(eSrc)) {
		eSrc.className='clsInvalid';
		websys_setfocus(eSrc.id);
		return websys_cancel();
	} else {
		eSrc.className='';
		return 1;
	}
}

function txtInteger_changehandler(e) {
	var eSrc=websys_getSrcElement(e);
	if (!IsInteger(eSrc)) {
		eSrc.className='clsInvalid';
		websys_setfocus(eSrc.id);
		return websys_cancel();
	} else {
		eSrc.className='';
		return 1;
	}
}

function txtDate_keydownhandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if ((keycode==9)||(keycode==13)){
		txtDate_changehandler(e);
		return 1;
	}else{
		return websys_cancel();
	}
}

function txtTime_keydownhandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if ((keycode==9)||(keycode==13)){
		txtTime_changehandler(e);
		return 1;
	}else{
		return websys_cancel();
	}
}

function txtNumber_keydownhandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if ((keycode==9)||(keycode==13)){
		txtNumber_changehandler(e);
		return 1;
	}else{
		return websys_cancel();
	}
}
function txtInteger_keydownhandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if ((keycode==9)||(keycode==13)){
		txtInteger_changehandler(e);
		return 1;
	}else{
		return websys_cancel();
	}
}