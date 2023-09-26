document.body.onload = BodyLoadHandler;
var SelectedRow=0;
function BodyLoadHandler()
{
	var obj=document.getElementById("BtnSave");
	if (obj){ obj.onclick=SaveClickHandler;}
	var obj=document.getElementById("BtnDel");
	if (obj){ obj.onclick=DelClickHandler;}
	}
function LookUpLoc(value){
	var temp; 
 temp=value.split("^");
 LocId=temp[1];
 document.getElementById('LocID').value=LocId;
}
function LookUpDoc(value){
var temp;
 temp=value.split("^");
 DocId=temp[1];
 document.getElementById('DocID').value=DocId;
}

function DelClickHandler(){
	var RID=document.getElementById("ID").value;
	if(RID==""){alert("请选择记录");return;}
	var DelMethodOBJ=document.getElementById('DelMethod')
	if(DelMethodOBJ){ var encmeth=DelMethodOBJ.value;}  else{var encmeth=""};
		if (encmeth!=""){
			var ret=cspRunServerMethod(encmeth,RID)
			if (ret==1){
				alert("删除成功！");
				location.reload();
				}else{
					alert("删除失败！")};
			}	
	}
function SaveClickHandler(){
	var Active,IsConLoc,SepecialLocFlag
	var ID=document.getElementById("ID").value;
	var LocID=document.getElementById("LocID").value;
	if(LocID==""){
		alert("科室不能为空！")
		return;
		}
	var LocCode=document.getElementById("LocCode").value;
	if(LocCode==""){
		alert("科室代码不能为空！");
		return;
		}
	var IsConLocOBJ=document.getElementById('isConLoc');
	if (IsConLocOBJ){IsConLoc=IsConLocOBJ.checked;}
	
	var ActiveOBJ=document.getElementById('IsActive');
	if (ActiveOBJ){Active=ActiveOBJ.checked;}
	
	var IsSpecialLocOBJ=document.getElementById("isSpecialLoc");
	if (IsSpecialLocOBJ){ SepecialLocFlag=IsSpecialLocOBJ.checked;}
	
	if(ID==""){
		var IsUnique=CheckUnique(LocID)
		if(IsUnique==true){
			alert("该科室已经维护,请重新选择")
			return;
		}
	}
	
	var savedata=ID+"^"+LocID+"^"+LocCode+"^"+Active+"^"+IsConLoc+"^"+SepecialLocFlag
	//alert(savedata)
	var SaveMethodOBJ=document.getElementById('SaveMthod');
	if(SaveMethodOBJ){ var encmeth=SaveMethodOBJ.value;}  else{var encmeth=""};
		if(encmeth!=""){
			var ret=cspRunServerMethod(encmeth,savedata);
			//alert(ret)
			if(ret!=-1){
				alert("保存成功！");
				location.reload();   
				}else{
					alert("保存失败！")};
			}
	}
function CheckUnique(LocID){
	var UniqueOBJ=document.getElementById('CheckUniqueMethod');
	if(UniqueOBJ){var encmeth=UniqueOBJ.value;}else{var encmeth=""};
	if(encmeth!=""){
		var ret=cspRunServerMethod(encmeth,LocID);
		if(ret==1){
			return true;
			}else{
				return false;
				}
		}
}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCAntiConsultLocInfo');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (selectrow!=SelectedRow){
		var obj1=document.getElementById('Loc');
		var obj2=document.getElementById('LocID');
		var obj3=document.getElementById('LocCode');
		var obj4=document.getElementById('isSpecialLoc');
		var obj5=document.getElementById('isConLoc');
		var obj6=document.getElementById('IsActive');
		var obj7=document.getElementById("ID")
	 
		var Tobj1=document.getElementById('TAntiConLocz'+selectrow);
		var Tobj2=document.getElementById('Tdepidz'+selectrow);
		var Tobj3=document.getElementById('TLocCodez'+selectrow);
		var Tobj4=document.getElementById('TSpecLocz'+selectrow);
		var Tobj5=document.getElementById('TIsConLocz'+selectrow);
		var Tobj6=document.getElementById('TIsActivez'+selectrow);
		var Tobj7=document.getElementById('TRowidz'+selectrow);
	    obj1.value=Tobj1.innerText;
		obj2.value=Tobj2.value;
		obj3.value=Tobj3.innerText;
		if(Tobj4.checked==true){
			obj4.checked=1
			}else{obj4.checked=0}
		if(Tobj5.checked==true){
			obj5.checked=1
			}else{obj5.checked=0}
		if(Tobj6.checked==true){
			obj6.checked=1
			}else{obj6.checked=0}
		obj7.value=Tobj7.value;
		SelectedRow=selectrow;
		return;
		}else{
			SelectedRow=0;
			clearNull();
			}
	}
function clearNull()
{
	var obj=document.getElementById('Loc');
	if(obj){obj.value="";}
	var obj=document.getElementById('LocID');
	if(obj){obj.value="";}
	var obj=document.getElementById('LocCode');
	if(obj){obj.value="";}
	var obj=document.getElementById('isSpecialLoc');
	if(obj){obj.checked=0;}
	var obj=document.getElementById('isConLoc');
	if(obj){obj.checked=0;}
	var obj=document.getElementById('IsActive');
	if(obj){obj.checked=0;}
	var obj=document.getElementById('ID');
	if(obj){obj.value="";}
	}