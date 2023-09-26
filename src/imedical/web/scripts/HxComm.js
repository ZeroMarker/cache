 function $(element) {
  if (arguments.length > 1) {
    for (var i = 0, elements = [], length = arguments.length; i < length; i++)
      elements.push($(arguments[i]));
    return elements;
   }
  if (typeof element=="string")
   return document.getElementById(element);
 }


 function $V(element) {
  if($(element).nodeName=="LABEL")
  return $(element).innerText;
  else
  return $(element).value;
}

  function addHand(h,k,r )
  {
    if(h.addEventListener)
     h.addEventListener(k,r,false)
     else if(h.attachEvent)
     h.attachEvent(k,r)
     else{
	 var M=h[k];
      h[k]=function(){
	  var x=M.apply(this,arguments),t=r.apply(this,arguments);
      return x==undefined?t:(t==undefined?x:t&&x)
      }
	 }
  }
var quickK={
f7:function(){ window.location.href =window.location.href ;},
f8:'',
f9:'',
addMethod : function()
{
  if(typeof this.f7 =='function')
  addHand(document.body,'onkeydown',function(){if(event.keyCode==118) quickK.f7();});
  if(typeof this.f8 =='function')
  addHand(document.body,'onkeydown',function(){if(event.keyCode==119) quickK.f8();});
  if(typeof this.f9 =='function')
  addHand(document.body,'onkeydown',function(){if(event.keyCode==120) quickK.f9();});
}
};

 String.prototype.toDate = function()
 {
  
  var dd = this.split(/\D/);
  if(dd.length==0) return "";
  if(dd.length==1&&this.length>2) {
   dd[0]=this.substring(0,4);
   dd[1]=this.substring(4,6);
   dd[2]=this.substring(6,8);
   }

  var tmp =new Date();
  if(dd.length>3) return "";
  if(dd.length==1){
   dd[0]=tmp.getFullYear();
   dd[1]=tmp.getMonth()+1;
   dd[2]=this;
  }
   if(dd.length==2){
   dd[2]=dd[1];
   dd[1]=dd[0];
   dd[0]=tmp.getFullYear();
  
  
  }
  if(dd[1].length==1) dd[1]="0"+dd[1];
  if(dd[2].length==1) dd[2]="0"+dd[2];
  var str = dd.join('-');
  if(!str.match(/^\d{4}\-\d\d?\-\d\d?$/)){return   "";}   
  var ar=str.replace(/\-0/g,"-").split("-");   
  ar=new Array(parseInt(ar[0]),parseInt(ar[1])-1,parseInt(ar[2]));   
  var d=new Date(ar[0],ar[1],ar[2]);   
  if( d.getFullYear()==ar[0]   &&   d.getMonth()==ar[1]   &&   d.getDate()==ar[2])
  return str;
  return "";
 
 }
  String.prototype.toTime=function()
 {
  var tt = this.split(/\D/);
  if(tt.length==1) {
   tt[0]=this.substring(0,2);
   tt[1]=this.substring(2,4);
   tt[2]=this.substring(4,6);
   }
  if(tt[1]=="") tt[1]="0";
  if(tt[2]=="") tt[2]="0";
  if(tt.length!=3) return "";
  if(tt[0].length==1) tt[0]="0"+tt[0];
  if(tt[1].length==1) tt[1]="0"+tt[1];
  if(tt[2].length==1) tt[2]="0"+tt[2];
  var str = tt.join(':');

  var a = str.match(/^(\d{1,2})(:)?(\d{1,2})\2(\d{1,2})$/); 
  if (a == null) {return "";} 
  if (a[1]>24 || a[3]>60 || a[4]>60) 
  { 
   
    return "" 
  }
  return str;

}
 

 function rowItemObj(tr)
  {
  	
   var rowItems = tr.getElementsByTagName("td");
 
	 var obj = new Object();
	 for(var i=0;i<rowItems.length;i++)
	 {
	 	if(rowItems[i].style.display=="none")
	 	{
		  var hidentd=rowItems[i];
			for(var j=0;j<hidentd.childNodes.length;j++)
			{
			  if(hidentd.childNodes[j].nodeName!="#text")
			  obj[getName(hidentd.childNodes[j].id)] = getValue(hidentd.childNodes[j]);
			}
	 	}
	  obj[getName(rowItems[i].firstChild.id)] = getValue(rowItems[i].firstChild);
   }
	
	tr.setAttribute("Item",obj);
  }
  function getName(name)
  {
    return name.substring(0,name.indexOf("z"));
  }

  function getValue(obj)
  {
   if(obj.nodeName=="INPUT")
	 return obj.value;
	 if(obj.nodeName =="LABEL")
	 return obj.innerText;
	 
  }
  function trim(str)
  {
  	return str.replace(/(^[\s]*)|([\s]*$)/g, "");
  }
  function trimCard(str)
	{

		var groups=[145,143,141,142];
		for(var i=0;i<groups.length;i++)
		{
			if(session['LOGON.GROUPID']==groups[i])
			{
				return str.replace(/(^[\;]?)|([\?]?$)/g, "");
			}
		}
		return str;
		
	}
	function GetPy(chinese,sp)
	{
		var py=$('HXPY').CovertPinYin(chinese,sp);
		var ins =py.indexOf("\0");
		return py.substring(0,ins);
	}
	
	function GetPyLeader(chinese)
	{
		var py= $('HXPY').CovertPinYin(chinese);
		var ins =py.indexOf("\0");
		return py.substring(0,ins);
	}