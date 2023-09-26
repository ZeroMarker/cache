function BodyLoadHandler()
{
		var obj=document.getElementById("Addfun");
		if (obj){
			obj.onclick=Addfun_Click;
		}
		var obj=document.getElementById("Delfun");
		if (obj){
			obj.onclick=Delfun_Click;
		}
		var obj=document.getElementById("savefunbtn");
		if (obj){
			obj.onclick=savefunbtn_Click;
		}	
			
  iniFormAllFun();
  iniFormSelFun();
  var obj=document.getElementById("nodes");
  obj.value=BuildStr();
  //alert(obj.value)

}
function savefunbtn_Click(){
	var str=BuildStr();
	var ret=tkMakeServerCall("web.DHCCAbFeeConfig","SaveSelFun",session['LOGON.USERID'],str)
	if (ret==""){
		alert("±£´æ³É¹¦")
	}

}
function Addfun_Click(){
	TransListDataA("AllFun","SelFun")
  var obj=document.getElementById("nodes");
  obj.value=BuildStr();
}
function Delfun_Click(){
	TransListDataB("SelFun","AllFun")
  var obj=document.getElementById("nodes");
  obj.value=BuildStr();
}
function TransListDataA(SName,TName)
{
	var sobj=document.getElementById(SName);
	var tobj=document.getElementById(TName);
	if((sobj)&&(tobj)){
		var myIdx=sobj.options.selectedIndex;
		if (myIdx>=0){
			var myoptobj=sobj.options[myIdx];
			var myListIdx=tobj.length;
			tobj.options[myListIdx]=new Option(myoptobj.text, myoptobj.value);
			//sobj.options[myIdx]= null;
			if ((myIdx+1)<sobj.options.length){
				//sobj.options[myIdx].selected=true;
			}else{
				//sobj.options[myIdx-1].selected=true;
			}
		}
	}
}
function TransListDataB(SName,TName)
{
	var sobj=document.getElementById(SName);
	var tobj=document.getElementById(TName);
	if((sobj)&&(tobj)){
		var myIdx=sobj.options.selectedIndex;
		if (myIdx>=0){
			var myoptobj=sobj.options[myIdx];
			var myListIdx=tobj.length;
			//tobj.options[myListIdx]=new Option(myoptobj.text, myoptobj.value);
			sobj.options[myIdx]= null;
			if ((myIdx+1)<sobj.options.length){
				sobj.options[myIdx].selected=true;
			}else{
				sobj.options[myIdx-1].selected=true;
			}
		}
	}
}
function BuildStr(){
	
	//var myary=new Array();
	

	var myarcstr="";
	var obj=document.getElementById("SelFun");
	if (obj){
		var mylen=obj.options.length;
		for(var i=0;i<mylen;i++){
			if(myarcstr==""){
				myarcstr=obj.options[i].value;
			}else{
				myarcstr=myarcstr+"^"+obj.options[i].value;
			}
		}
	}
	var myInfo=myarcstr;
	return myInfo;
}
function iniFormAllFun(){
	var obj=document.getElementById("AllFun");
	if (obj){
		obj.size=3; 
	 	obj.multiple=false;
	 	i=0
		var ret=tkMakeServerCall("web.DHCCAbFeeConfig","getAllFun","")
     	var Temp1=ret.split(String.fromCharCode(2))
     	for (var i=0;i<Temp1.length;i++){
			Temp2=Temp1[i].split("^")
			obj.options[i]=new Option(Temp2[1],Temp2[0]);
		}     
	}
}
function iniFormSelFun(){
	var obj=document.getElementById("SelFun");
	if (obj){
		obj.size=3; 
	 	obj.multiple=false;
	 	i=0
		var ret=tkMakeServerCall("web.DHCCAbFeeConfig","getSelFun",session['LOGON.USERID'])
		if (ret==""){return false;}
     	var Temp1=ret.split(String.fromCharCode(2))
     	for (var i=0;i<Temp1.length;i++){
			Temp2=Temp1[i].split("^")
			obj.options[i]=new Option(Temp2[1],Temp2[0]);
		}     
	}
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
}
function getwardid(value)	{
	var val=value.split("^");
	var obj=document.getElementById('wardid');
	obj.value=val[1];

}
document.body.onload = BodyLoadHandler;