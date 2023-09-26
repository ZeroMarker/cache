var SelectedRow = 0,preRowInd=0;
var ancvcCodeold=0;
function BodyLoadHandler(){
	var obj=document.getElementById('ADD')
	if(obj) obj.onclick=ADD_click;
	var obj=document.getElementById('UPDATE')
	if(obj) obj.onclick=UPDATE_click;
	var obj=document.getElementById('DELETE')
	if(obj) obj.onclick=DELETE_click;
	var obj=document.getElementById('GetHPDeves');
	
	if(obj) {
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth);
	    var devesEdit=document.getElementById('hpDevs');
	    devesEdit.value=resStr;
	    var setDevesBtn=document.getElementById('setDevesBtn');
	    setDevesBtn.onclick=SETDEVES_click;
	    var obj=document.getElementById('Find');
		if(obj)obj.onclick=Sch_click;
	}
	var obj=document.getElementById('GetMSrvIP');	
	if(obj) {
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth);
	    var mSrvIPEdit=document.getElementById('MSrvIP');
	    var sysTypeEdit=document.getElementById('Source'); // 系统类型：A:手麻，I:ICU
	    var strArray=resStr.split("^");
	    if (strArray.length >= 2){
	    mSrvIPEdit.value=strArray[0];
	    sysTypeEdit.value=strArray[1];
	    }
	}
	var obj=document.getElementById('copyBtn');
	if(obj)obj.onclick=Copy_click;

}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCANCCollectType');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('Rowid');
	var obj1=document.getElementById('Code');
    var obj2=document.getElementById('Desc');
	var obj3=document.getElementById('ANCCTActive');
	var obj4=document.getElementById('Source');

	var SelRowObj=document.getElementById('trowidz'+selectrow);
	var SelRowObj1=document.getElementById('tCodez'+selectrow);
	var SelRowObj2=document.getElementById('tDescz'+selectrow);
	var SelRowObj3=document.getElementById('tANCCTActivez'+selectrow);
	var SelRowObj4=document.getElementById('tSourcez'+selectrow);
    if (preRowInd==selectrow){
	   obj.value=""; 
       obj1.value="";
       obj2.value="";
       obj3.value=""; 
       obj4.value="";   
    }
   else{
	   	obj.value=SelRowObj.innerText;
		obj1.value=SelRowObj1.innerText;
		obj2.value=SelRowObj2.innerText;
		obj3.value=SelRowObj3.innerText;
		obj4.value=SelRowObj4.innerText;
		preRowInd=selectrow;
   }
   	parent.frames['RPBottom'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCANCCollectTypeItem&MDIRowid="+obj.value+"&Source="+SelRowObj4.innerText; 
	return;
}
function ADD_click(){
	var ANCCTCode,ANCCTDesc,ANCCTActive,source="";
	var obj=document.getElementById('Code')
	if(obj) ANCCTCode=obj.value;
	if(ANCCTCode==""){
		alert("代码不能为空！") 
		return;
		}
	var obj=document.getElementById('Desc')
	if(obj)  ANCCTDesc=obj.value;
	if(ANCCTDesc==""){
		alert("名称不能为空！") 
		return;
		}
	var obj=document.getElementById('Source')
	if(obj)  source=obj.value;
	if(source==""){
		alert("Source不能为空！") 
		return;
		}
    var obj2=document.getElementById('ANCCTActive');
    if(obj2)
    { 
      ANCCTActive=(obj2.value=="是")?"Y":"N";
    }
	var obj=document.getElementById('inserDHCANCCollectType')
	if(obj) {
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,ANCCTCode, ANCCTDesc, ANCCTActive, source)
	    if (resStr!='0'){
			alert("操作失败！");
			return;
			}	
		else  {alert("操作成功");
		location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCANCCollectType";
		}
	}
}
function UPDATE_click(){
	if (preRowInd<1) return;
	var ANCCTCode,ANCCTDesc,ANCCTActive;
	var obj=document.getElementById('Code')
	if(obj) ANCCTCode=obj.value;
	if(ANCCTCode==""){
		alert(t['alert:ancvccodeFill']) 
		return;
		}
	var obj=document.getElementById('Desc')
	if(obj)  ANCCTDesc=obj.value;
	if(ANCCTDesc==""){
		alert(t['alert:ancvcdescFill']) 
		return;
		}
    var obj1=document.getElementById('Rowid');
    if(obj1) Rowid=obj1.value;
    var obj2=document.getElementById('ANCCTActive');
    if(obj2) ANCCTActive=obj2.value;	
	var obj=document.getElementById('UPDATEDHCANCCollectType')
	if(obj) {
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,Rowid,ANCCTCode ,ANCCTDesc, ANCCTActive);
	    if (resStr!='0'){
			alert(t['alert:baulk']+" "+"Code="+resStr);
			return;
			}	
		else  {alert(t['alert:success']);
	    location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCANCCollectType";
		}
	}
}
function DELETE_click(){
	if (preRowInd<1) return;
	var Rowid,IcuApply;
	var obj=document.getElementById('Rowid')
	if(obj) Rowid=obj.value;
	if(Rowid==""){
		alert(t['alert:Please Select One']) 
		return;
		}
	var obj=document.getElementById('DeleteDHCANCCollectType')
	if(obj) var encmeth=obj.value;
	var resStr=cspRunServerMethod(encmeth,Rowid)
	if (resStr!='0')
		{alert(t['alert:baulk']);
		return;}	
	else {alert(t['alert:success'])
	  location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCANCCollectType";
	}
}
function getitemANCCTActive(str)
{
	var anmth=str.split("^");
	var obj=document.getElementById('ANCCTActive')
	obj.value=anmth[0];
}
function SETDEVES_click()
{
	var obj=document.getElementById('SetHPDeves');
	var encmeth=obj.value;
	var devesEdit=document.getElementById('hpDevs');
	var resStr=cspRunServerMethod(encmeth,devesEdit.value);
	
	var obj=document.getElementById('SetMSrvIP');
	var encmeth=obj.value;
	var mSrvIPEdit=document.getElementById('MSrvIP');
	var resStr=cspRunServerMethod(encmeth,mSrvIPEdit.value);
	alert("操作成功");
}

function Sch_click(){
	var sysTypeEdit=document.getElementById('Source'); // 系统类型：A:手麻，I:ICU
	var url = location.href; 
	url=url.split("&")[0];// 去掉request
	if (sysTypeEdit!=null && sysTypeEdit.value==""){
		// 查找所有
		location.href = url+"&Source=ALL";
		}
	else{
		// 按条件查寻
		location.href = url+"&Source="+sysTypeEdit.value;
		}
	}
function Copy_click(){
	if(srcDev!="" && dstDev!=""){
		var obj=document.getElementById('CopyDevChNo');			
		if(obj) {
			var encmeth=obj.value;
	    	var resStr=cspRunServerMethod(encmeth,srcDev,dstDev);
	    	if(resStr!=0){
		    	alert("Failed:"+resStr);
		    	}
			}
		}
	}
function LookUpSrcDevType(str){
	id = str.split('^')[0];
	name = str.split('^')[2];
	var obj=document.getElementById('srcDev')
	obj.value=name;
	srcDev=id;
	}
function LookUpDstDevType(str){
	id = str.split('^')[0];
	name = str.split('^')[2];
	var obj=document.getElementById('dstDev')
	obj.value=name;
	dstDev=id;
	}

document.body.onload = BodyLoadHandler;