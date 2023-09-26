function BodyLoadHandler() {
	var	obj=document.getElementById('udep');
	if (obj) obj.multiple=false;
	if (obj) obj.onchange = uDep_change;
	if (obj) obj.ondblclick = uDep_dbclick;
	var obj=document.getElementById('alldep');
	if (obj) obj.ondblclick = allDep_dbclick;
	
	var	obj=document.getElementById('Badd');
	if (obj) obj.onclick = Badd_click;
	
	var	obj=document.getElementById('Bdel');
	if (obj) obj.onclick = Bdel_click;
	
	var	obj=document.getElementById('Bsave');
	if (obj) obj.onclick = Bsave_click;
	var	obj=document.getElementById('LocNameDesc');
	//if (obj) obj.onchange = LocNameDesc_change;
	if (obj) obj.onkeydown = LocNameDesc_keydown;

	
}
function LocNameDesc_change(){
	BuildAllDeptList();
}
function LocNameDesc_keydown(){
	var key=websys_getKey(e);
	if (key==13){
		BuildAllDeptList();
	}
}
function uDep_dbclick(){
	Bdel_click();
}
function allDep_dbclick(){
	Badd_click();
}
function uDep_change() {
  	ClearList('udoc');
  	var obj=document.getElementById('udep');
	var selectObj=obj.options[obj.selectedIndex];	
	if (selectObj) 
	{
		var LocID=selectObj.value
	} 
	else {var LocID=''};
	if (LocID==""){
		alert("请先选择一个科室");
		return flase;
	}
	var obj=document.getElementById('useID');
	var userID="";
	if (obj) userID=obj.value;
	if (userID==""){
		alert("请先选择一个排班员");
		return false;
	}
	var GetDocMethod=document.getElementById('seldoc');
	if (GetDocMethod) {var encmeth=GetDocMethod.value} else {var encmeth=''};
	var ret=cspRunServerMethod(encmeth,userID,LocID);
	BuildList(ret,"udoc");
}

function Bsave_click() {
	var tmp=document.getElementById('udep');
	var selectObj=tmp.options[tmp.selectedIndex];
	if(selectObj){
		var Item=selectObj.value
	}else{
		var Item=""
	}
	//var Item=tmp.options[tmp.selectedIndex].value;
	if (Item==""){
		alert("请先选择一个排班科室");
		return false;
	}
	var useid=document.getElementById('useID').value;
	if (useid==""){
		alert("请先选择一个排班员");
		return false;
	}
	var flag=0
	var udoc=document.getElementById('udoc');
    for (var j=0;j<udoc.length;++j){
		if (udoc.options[j].selected==true)
		{
			flag=1
		}
    }
    if (flag==0){
	    alert("请先选择排班医生");
	    return false;
    }
	var del=document.getElementById('del');	
	if (del) {var encmeth=del.value} else {var encmeth=''};
	var ret=cspRunServerMethod(encmeth,'','',useid,Item);
	if (ret!="0"){
		alert("删除原有数据错误");
		return false;
	}
	var udoc=document.getElementById('udoc');
    for (var j=0;j<udoc.length;++j){
		if (udoc.options[j].selected==true)
		{ 
			var docid=udoc.options[j].value; 
			var ins=document.getElementById('ins');	
			if (ins) {var encmeth=ins.value} else {var encmeth=''};
			if (cspRunServerMethod(encmeth,'','',useid,Item,docid)=='0') {
				//obj.className='clsInvalid';
				//return websys_cancel();
			}
	    //break ;
	    }    
    }
    alert ("更新完成")
    ////////////////
}

function Bdel_click() {
	
 	var obj=document.getElementById('useID');
	var userID="";
	if (obj) userID=obj.value;
	if (userID==""){
		alert("请先选择一个排班员");
		return false;
	}
	var obj=document.getElementById('udep');
	var length=obj.length;
	
	for(i=length-1;i>=0;i--){
		if (obj.options[i].selected){
			if (!(confirm("确实要删除选中的科室吗?"))) {  return false; }
			var value=obj.options[i].value;
			var text=obj.options[i].text;
			var del=document.getElementById('del');	
			if (del) {var encmeth=del.value} else {var encmeth=''};
			var ret=cspRunServerMethod(encmeth,'','',userID,value);
			if (ret!="0"){
				alert("删除原有数据错误");
				return false;
			}
			obj.remove(i);
			ClearList('udoc');
			AddList("alldep",text,value);
		}
	}
}

function Badd_click() {
	var obj=document.getElementById('useID');
	var userID="";
	if (obj) userID=obj.value;
	if (userID==""){
		alert("请先选择一个排班员")
		return false;
	}
	var obj=document.getElementById('alldep');
	var length=obj.length;
	for(i=length-1;i>=0;i--){
		if (obj.options[i].selected){
			var value=obj.options[i].value;
			var text=obj.options[i].text;
			obj.remove(i);
			AddList("udep",text,value);
		}
	}
}
function uselook(str) {
	if (str=="") return false;
	var obj=document.getElementById('useID');
	var tem=str.split("^");
	obj.value=tem[1];
	BuildAllDeptList();
	BuildUseDeptList();
	ClearList('udoc');
}
function BuildUseDeptList(){
	var UserID="",Desc="";
	var obj=document.getElementById('useID');
	if (obj) UserID=obj.value;
	if (UserID==""){
		alert("请先选择一个排班员")
		return false;
	}
	var ret=tkMakeServerCall("web.DHCUserGroup","GetLocInfo",UserID,Desc,"USE","res");
	BuildList(ret,"udep");
}
function BuildAllDeptList(){
	var UserID="",Desc="";
	var obj=document.getElementById('useID');
	if (obj) UserID=obj.value;
	if (UserID==""){
		alert("请先选择一个排班员")
		return false;
	}
	var obj=document.getElementById('LocNameDesc');
	if (obj) Desc=obj.value;
	var ret=tkMakeServerCall("web.DHCUserGroup","GetLocInfo",UserID,Desc,"ALL","res");
	BuildList(ret,"alldep");
}
function BuildList(value,ElementName){
	ClearList(ElementName);
	if (value=="") return false;
	var char1="\1";
	var char2="\2";
	var arr=value.split(char2);
	var i=arr.length;
	for (j=0;j<i;j++){
		var oneValue=arr[j];
		var oneArr=oneValue.split(char1);
		AddList(ElementName,oneArr[0],oneArr[1],oneArr[2]);
	}
}

function AddList(ElementName,value,text,Selected){

	var obj=document.getElementById(ElementName);
	var length=obj.length;
	obj.options[length] = new Option(value,text);
	if (Selected==1) obj.options[length].selected=true;
}
function ClearList(ElementName){
	var obj=document.getElementById(ElementName);	
	var length=obj.length
	for(i=length-1;i>=0;i--){
		obj.remove(i);
	} //先清空
}
document.body.onload = BodyLoadHandler;