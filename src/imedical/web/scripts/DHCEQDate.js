var dtseparator='/';
var dtformat='DMY';
function DateMsg(itemname) {
  var msg='';
  try {
	if (!IsValidDate(document.getElementById(itemname))) {
		msg+="\'" + t[itemname] + "\' " + t['XDATE'] + "\n";
		if (focusat==null) focusat=document.getElementById(itemname);
	}
	return msg;
  } catch(e) {return msg;};
}

function isLeapYear(y) 
{
	return ((y%4)==0)&&(!(((y%100)==0)&&((y%400)!=0)));
}

function ReWriteDate(d,m,y) 
{
	y=parseInt(y,10);
	if (y<15) y+=2000; else if (y<100) y+=1900;
	if ((y>99)&&(y<1000)) y+=1900;
	if ((d<10)&&(String(d).length<2)) d='0'+d;
	if ((m<10)&&(String(m).length<2)) m='0'+m;
	var newdate='';
	newdate=d+'/'+m+'/'+y;
	return newdate;
}

function IsValidDate(fld) 
{
	var dt=fld.value;
	var re = /^(\s)+/ ; dt=dt.replace(re,'');
	var re = /(\s)+$/ ; dt=dt.replace(re,'');
	var re = /(\s){2,}/g ; dt=dt.replace(re,' ');
	if (dt=='') {fld.value=''; return 1;}
	re = /[^0-9A-Za-z]/g ;
	dt=dt.replace(re,'/');
	for (var i=0;i<dt.length;i++) 
	{
		var type=dt.substring(i,i+1).toUpperCase();
		if (type=='T'||type=='W'||type=='M'||type=='Y') 
		{
			if (type=='T') 
			{return ConvertTDate(fld);} 
			else {return ConvertWMYDate(fld,i,type);}
			break;
		}
	}
	if ((dt.indexOf('/')==-1)&&(dt.length>2)) dt=ConvertNoDelimDate(dt);
	var dtArr=dt.split('/');
	var len=dtArr.length;
	if (len>3) return 0;
	for (i=0; i<len; i++) 
	{if (dtArr[i]=='') return 0;}
 	var dy,mo,yr;
 	for (i=len; i<3; i++) dtArr[i]='';
 	dy=dtArr[0];mo=dtArr[1];yr=dtArr[2];
 	if ((String(yr).length!=2)&&(String(yr).length!=4)&&(String(yr).length!=0)) return 0;
 	if ((String(yr).length==4)&&(yr<1840)) return 0;
 	var today=new Date();
 	if (yr=='') 
 	{
	 	yr=today.getYear();
	 	if (mo=='') mo=today.getMonth()+1;
  	}
 	if ((isNaN(dy))||(isNaN(mo))||(isNaN(yr))) return 0;
 	if ((dy<1)||(dy>31)||(mo<1)||(mo>12)||(yr<0)) return 0;
 	if (mo==2) 
 	{
  		if (dy>29) return 0;
  		if ((!isLeapYear(yr))&&(dy>28)) return 0;
 	}
 	if (((mo==4)||(mo==6)||(mo==9)||(mo==11))&&(dy>30)) return 0;
 	if (isMaxedDate(dy,mo,yr)) return 0;
 	fld.value=ReWriteDate(dy,mo,yr);
 	websys_returnEvent();
 	return 1;
}

function isMaxedDate(dy,mo,yr) 
{
	var maxDate = new Date();
	maxDate.setTime(maxDate.getTime() + (1000*24*60*60*1000));
	yr = parseInt(yr,10); if (yr<15) yr+=2000; else if (yr<100) yr+=1900;
	if ((yr>99)&&(yr<1000)) yr+=1900;
	var objDate = new Date(yr,mo-1,dy,0,0,0);
	if (maxDate.getTime() < objDate.getTime()) return 1;
	return 0;
}

function ConvertTDate(fld) 
{
	var today=new Date();
	var dt=fld.value;
	var re = /(\s)+/g ;
	dt=dt.replace(re,'');
	if (dt.charAt(0).toUpperCase()=='T') 
	{
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

function ConvertWMYDate(fld,pos,type) 
{
	var today=new Date();
	var dt=fld.value;
	var re = /(\s)+/g ;
	dt=dt.replace(re,'');
	var x = dt.substring(0,pos);xmn=0;xyr=0;
	if (x=='') x=1;
	if (isNaN(x)) return 0;
	if (dt.substring(pos+1,dt.length)!='') return 0;
	if (type=='M') 
	{
		while (x>11) {xyr++;x=x-12}
		xmn=today.getMonth()+eval(x);
		if (xmn>=11) {xyr++;today.setMonth(eval(xmn-12));} else {today.setMonth(xmn);}
	} 
	else if (type=='Y') 
	{	xyr=x; } 
	else {today.setTime(today.getTime() + (x * 7 * 24 * 60 * 60 * 1000));}
	if (isMaxedDate(today.getDate(),today.getMonth()+1,today.getFullYear()+eval(xyr))) return 0;
	fld.value=ReWriteDate(today.getDate(),today.getMonth()+1,today.getFullYear()+eval(xyr));
	websys_returnEvent();
	return 1;
 }
 
function ConvertNoDelimDate(dt)  
{
	var len = dt.length;
	if (len%2) return dt;
	if (len>8) return dt;
	var dy=dt.slice(0,2); var mn=dt.slice(2,4); var yr=dt.slice(4);
	if (yr=='') 
	{
		var today = new Date();
		yr=today.getYear();
 	}
 	var dtconv=dy+'/'+mn+'/'+yr;
 	return dtconv
}