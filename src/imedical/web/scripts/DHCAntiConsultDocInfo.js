document.body.onload=BodyLoadHandler;
var SelectedRow=0
function BodyLoadHandler(){
	var obj=document.getElementById("BtnSave");
	if (obj){ obj.onclick=SaveClickHandler;}
	var obj=document.getElementById("BtnDelete");
	if (obj){ obj.onclick=DelClickHandler;}
	
	var locId = document.getElementById("LocID").value;
	var locdesc = tkMakeServerCall("web.DHCAntiConsultLocInfo","GetLocDesc",locId);
	var obj = document.getElementById("LocDesc");
	obj.value = locdesc;
	obj.disabled = true;
	}
function LookupDoc(value){
	var temp;
	temp=value.split("^");
	DocID=temp[1];
	document.getElementById("ConDocID").value=DocID;
	}
function SaveClickHandler(){
	var Active;
	var rowid=document.getElementById("rowid").value;
	var locid=document.getElementById("LocID").value;
	var docid=document.getElementById("ConDocID").value;
	if(docid==""){
		alert("请选择维护的会诊医生！");
		return;
		}
	var activeOBJ=document.getElementById("Active");
	if(activeOBJ){
		Active=activeOBJ.checked;
		}
	if(rowid==""){
		
		var IsUnique=CheckUniqueDoc(locid,docid)
		if(IsUnique==true){
			alert("该会诊医生已经维护,请重新选择");
			ClearNull();
			return;
			}
		}
	var input=rowid+"^"+locid+"^"+docid+"^"+Active;
	var SaveMethodOBJ=document.getElementById("SaveMethod");
	if(SaveMethodOBJ){var encmeth=SaveMethodOBJ.value;} else{var encmeth=""};
	if(encmeth){
		var ret=cspRunServerMethod(encmeth,input);
		if(ret!=-1){
			alert("保存成功！");
			location.reload();   
			}else{
				alert("保存失败！");
				}
		}
	
	}
function DelClickHandler(){
	var rowid=document.getElementById("rowid").value;
	if(rowid==""){
		alert("请选择记录");
		return;
		}
	var DelMethodOBJ=document.getElementById('DelMethod');
	if(DelMethodOBJ){ var encmeth=DelMethodOBJ.value;}  else{var encmeth=""};
	if(encmeth!=""){
		var ret=cspRunServerMethod(encmeth,rowid);
		if (ret==1){
				alert("删除成功！");
				location.reload();
				}else{
					alert("删除失败！")
					};
		}
	}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCAntiConsultDocInfo');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (selectrow!=SelectedRow){
		var obj1=document.getElementById('ConDoc');
		var obj2=document.getElementById('ConDocID');
		var obj3=document.getElementById('Active');
		var obj4=document.getElementById('rowid');
	 
		var Tobj1=document.getElementById('TConDocz'+selectrow);
		var Tobj2=document.getElementById('TConDocIDz'+selectrow);
		var Tobj3=document.getElementById('TActivez'+selectrow);
		var Tobj4=document.getElementById('TRowidz'+selectrow);
		
		obj1.value=Tobj1.innerText;
		obj2.value=Tobj2.value;
		if(Tobj3.checked==true){
			obj3.checked=1;
			}else{obj3.checked=0;}
		obj4.value=Tobj4.value;
		SelectedRow=selectrow;	
		return;
		}else{
			SelectedRow=0;
			ClearNull();
			}
	}
function ClearNull(){
	var obj=document.getElementById('ConDoc');
	if(obj){obj.value="";}
	var obj=document.getElementById('ConDocID');
	if(obj){obj.value="";}
	var obj=document.getElementById('Active');
	if(obj){obj.checked=0;}
	var obj=document.getElementById('rowid');
	if(obj){obj.value="";}
	}
function CheckUniqueDoc(Locid,Docid){
	var UniqueOBJ=document.getElementById('CheckUniMethod');
	if(UniqueOBJ){var encmeth=UniqueOBJ.value;}else{var encmeth=""};
	if(encmeth!=""){
		var ret=cspRunServerMethod(encmeth,Locid,Docid);
		if(ret==1){
			return true;
			}else{
				return false;
				}
		}
	}
