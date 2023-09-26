document.body.onload = BodyLoadHandler;
var SelectedRow=0;
function BodyLoadHandler()
{ 
	var obj=document.getElementById("BtDelete");
	if (obj){ obj.onclick=DelClickHandler;}
	var obj=document.getElementById("BtSave");
	if (obj){ obj.onclick=SaveClickHandler;}
	}

function DelClickHandler(){
	var rowid=document.getElementById("rowid").value;
	var DelMethodOBJ=document.getElementById('DelMethod')
	if(DelMethodOBJ){ var encmeth=DelMethodOBJ.value;}  else{var encmeth=""};
		if (encmeth!=""){
			var ret=cspRunServerMethod(encmeth,rowid)
			if (ret==1){
				alert("删除成功！");
				location.reload();
				}else{
					alert("删除失败！")};
			}	
	}
function SaveClickHandler(){
	var code,desc,Active,Resume,input
	var rowid=document.getElementById("rowid").value;
	var CodeObj=document.getElementById('Code');
	if(CodeObj){ code=CodeObj.value;}
	if(code==""){
		alert("代码不能为空")
		return;
		}
	var DescObj=document.getElementById('Desc');
	if(DescObj){ desc=DescObj.value;}
	if(desc==""){
		alert("描述不能为空值");
		return;
		}
	var ActiveOBJ=document.getElementById('IsActive');
	if (ActiveOBJ){Active=ActiveOBJ.checked;}
	var ResumeOBJ=document.getElementById('Resume');
	if (ResumeOBJ){Resume=ResumeOBJ.value;}
	input=rowid+"^"+code+"^"+desc+"^"+Active+"^"+Resume
	var SaveMethodOBJ=document.getElementById('SaveMethod')
	if(SaveMethodOBJ){ var encmeth=SaveMethodOBJ.value;}  else{var encmeth=""};
		if(encmeth!=""){
			var ret=cspRunServerMethod(encmeth,input);
			if (ret==-99){
				alert("该记录已存在！");
				return;
			}else if(ret!=-1){
				alert("保存成功！");
				location.reload();   
				}else{
					alert("保存失败！")
					return;
					};
			}
	}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCDocInfPart');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (selectrow!=SelectedRow){
		var Code=document.getElementById('Code');
		var Desc=document.getElementById('Desc');
		var IsActive=document.getElementById('IsActive');
		var Resume=document.getElementById('Resume');
		var rowid=document.getElementById('rowid');
	 
		var tIPCode=document.getElementById('tIPCodez'+selectrow);
		var tIPDesc=document.getElementById('tIPDescz'+selectrow);
		var tIPActive=document.getElementById('tIPActivez'+selectrow);
		var tIPResume=document.getElementById('tIPResumez'+selectrow);
		var tRowid=document.getElementById('tRowidz'+selectrow);
	
	    Code.value=tIPCode.innerText;
		Desc.value=tIPDesc.innerText;
		var active=tIPActive.innerText;
		if (active=="是"){
			IsActive.checked=1
			}else(
				IsActive.checked=0
				)
		Resume.value=tIPResume.innerText;
		rowid.value=tRowid.value;
		SelectedRow=selectrow;
		return;
		}else{
			SelectedRow=0;
			clearNull();
			}
	}
function clearNull()
{
	var obj=document.getElementById('Code');
	if(obj){obj.value="";}
	var obj=document.getElementById('Desc');
	if(obj){obj.value="";}
	var obj=document.getElementById('IsActive');
	if(obj){obj.checked=0;}
	var obj=document.getElementById('Resume');
	if(obj){obj.value="";}
	var obj=document.getElementById('rowid');
	if(obj){obj.value="";}
	}