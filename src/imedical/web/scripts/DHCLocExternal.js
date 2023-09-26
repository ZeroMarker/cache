
var SelectedRow=0

function BodyLoadHandler() {
	initForm();
	var obj=document.getElementById("ADD");
	if(obj){obj.onclick=ADD_click;}
	var obj=document.getElementById("Delete")
	if(obj){obj.onclick=Delete_click;}
	var obj=document.getElementById('LocDesc')
	if (obj){obj.onkeyup=LocDesc_Change}
}
function initForm(){
	var obj=document.getElementById('LEActive')
	if(obj){
		obj.size=1;
		obj.multiple=false;
		obj.options[0]=new Option("激活","Y");///显示的是激活 但它的值是¨YES〃
		obj.options[1]=new Option("未激活","N");///这句话是往listbox中添加值
		}
	}
function ADD_click(){
	var CTLocDr,LocDesc,LECode,LEDesc,LEActive=""
	var obj=document.getElementById('CTLocDr')
	if(obj){var CTLocDr=obj.value}
	if (CTLocDr==""){alert("请选择需要对照的科室");return}
	var obj=document.getElementById('LocDesc')
	if(obj){var LocDesc=obj.value}
	var obj=document.getElementById('LECode')
	if(obj){var LECode=obj.value}
	if (LECode==""){alert("请输入需要对照的外部科室代码");return}
	var obj=document.getElementById('LEDesc')
	if(obj){var LEDesc=obj.value}
	if (LEDesc==""){alert("请输入需要对照的外部科室描述");return}
	var obj=document.getElementById('LEActive')
	if(obj){var LEActive=obj.value}
	if (LEActive==""){alert("请选择可用标志");return}
	InString=CTLocDr+"^"+LocDesc+"^"+LECode+"^"+LEDesc+"^"+LEActive
	var Ins=document.getElementById('ins');
	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
	
	var OutString=cspRunServerMethod(encmeth,InString)
	if (OutString==0) {location.reload();}
	else{alert("添加失败")}

	}
function Delete_click(){
	var selectrow=SelectedRow; 
    if(selectrow==0) return;
	var TLExternalRowid=document.getElementById('TLExternalRowidz'+SelectedRow).value;
	var Del=document.getElementById('Del');
	if (Del) {var encmeth=Del.value} else {var encmeth=''};

	var OutStr=cspRunServerMethod(encmeth,TLExternalRowid)
	if(OutStr==0){location.reload();}
	else{alert("删除失败")
		}
	}

function SetLoc(value)     
{   
    var str=value
    var str1=str.split("^")
	var obj=document.getElementById('LocDesc');
	obj.value=str1[1];
	var obj=document.getElementById('CTLocDr');
	obj.value=str1[2];

}
function ClearMedUnit()
{	
	var obj=document.getElementById('LocDesc');
	if(obj){obj.value="";}
	var obj=document.getElementById('LECode');
	if(obj){obj.value="";}
	var obj=document.getElementById('LEDesc');
	if(obj){obj.value="";}
	var obj=document.getElementById('LEActive');
	if(obj){obj.value="";}
	var obj=document.getElementById('CTLocDr');
	if(obj){obj.value="";}
}	

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCLocExternal');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow)return;
	if (SelectedRow!=selectrow){
		var obj=document.getElementById('LocDesc')
		if(obj){
			var SelRowObj=document.getElementById('TLELocDescz'+selectrow);
			obj.value=SelRowObj.innerText;
		}
		var obj=document.getElementById('CTLocDr')
		if(obj){
			var SelRowObj=document.getElementById('TLELocDescz'+selectrow);
			obj.value=SelRowObj.value;
			}
	
		var obj=document.getElementById('LEDesc')
		if(obj){
			var SelRowObj=document.getElementById('TLEExtDescz'+selectrow);
			obj.value=SelRowObj.innerText;
			}
		var obj=document.getElementById('LECode')
		if(obj){
			var SelRowObj=document.getElementById('TLEExtCodez'+selectrow);
			obj.value=SelRowObj.innerText;
			}
		var obj=document.getElementById('LEActive')
		if(obj){
			var SelRowObj=document.getElementById('TableLEActivez'+selectrow);
			obj.value=SelRowObj.value;
			}
 	SelectedRow=selectrow;
 	}
 	
	else {

		SelectedRow=0;
		ClearMedUnit();
	}

}

function LocDesc_Change()
{
	var obj=document.getElementById('LocDesc');
	if (obj.value==""){
		var obj=document.getElementById('CTLocDr');
		if (obj){obj.value=""}
	}
}
document.body.onload = BodyLoadHandler;