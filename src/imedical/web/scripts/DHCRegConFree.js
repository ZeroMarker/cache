var SelectedRow=0

function BodyLoadHandler() {
	var obj=document.getElementById("AddItem");
	if(obj){obj.onclick=ADD_click;}
	var obj=document.getElementById("Delete")
	if(obj){obj.onclick=Delete_click;}
	initForm();
	var obj=document.getElementById("UpDate")
	if(obj){obj.onclick=UpDate_click;}
}

function initForm() {
	var obj=document.getElementById("FeeCate");
	if(obj){
		obj.size=1; ///就是说listbox只显示1行
		obj.multiple=false;
		var Category=document.getElementById('Category');
		if (Category) {var encmeth=Category.value} else {var encmeth=''};
		var OutStr=cspRunServerMethod(encmeth)
		if(OutStr!=""){
			var VerArr1=OutStr.split("|");
			var ArrTxt= new Array(VerArr1.length-1);
			var ArrValue = new Array(VerArr1.length-1);
			for(i=1;i<VerArr1.length;i++){
				var VerArr2=VerArr1[i].split("^");
				ArrTxt[i-1]=VerArr2[1];
				ArrValue[i-1]=VerArr2[0];
			}
			ClearAllList(obj);
			AddItemToList(obj,ArrTxt,ArrValue)
		}	
	}
}
				

function ADD_click()
{	var obj=document.getElementById("FeeCate")
    if(obj){RCFAdmReasonDr=obj.value
		 if(RCFAdmReasonDr==""){
		    alert(t['01'])
		    return;
		    }
	    }
	var obj=document.getElementById('StartDate')
	if(obj){
		StartDate=obj.value
		if(StartDate==""){
			alert(t['02'])
			return;
			}
	}
	var obj=document.getElementById('EndDate')
	if(obj){EndDate=obj.value}
 
    var obj=document.getElementById('StartTime')
	if(obj){StartTime=obj.value
		if(StartTime==""){
			alert(t['03'])
			return;
			}
	}
	var obj=document.getElementById('EndTime')
	if(obj){EndTime=obj.value} 
	var FreeAllFee
	var obj=document.getElementById('FreeAllFee')
	if(obj){
		if(obj.checked==true){FreeAllFee="Y"}
		else{FreeAllFee="N"}
	} 
	var FreeAppFee
	var obj=document.getElementById('FreeAppFee')
	if(obj){FreeAppFee=obj.value
	if(!isNaN(FreeAppFee)){}
	else{
		 alert(t['04']);
		 return;}   
} 
	var FreeOtherFee
	var obj=document.getElementById('FreeOtherFee')
	if(obj){
		FreeOtherFee=obj.value
			if(!isNaN(FreeOtherFee)){}
			else{
		 		alert(t['04']);
		 		return;}  
		 	}
	var FreeRegFee
	var obj=document.getElementById('FreeRegFee')
	if(obj){
		FreeRegFee=obj.value
		if(!isNaN(FreeRegFee)){}
			else{
		 		alert(t['04']);
		 		return;}} 
	var FreeCheckFee
	var obj=document.getElementById('FreeCheckFee')
	if(obj){
		FreeCheckFee=obj.value
		if(!isNaN(FreeCheckFee)){}
		else{
			alert(t['04']);
		 	return;}} 
	var InString=RCFAdmReasonDr+"^"+StartDate+"^"+StartTime+"^"+EndDate+"^"+EndTime+"^"+FreeRegFee+"^"+FreeCheckFee+"^"+FreeAllFee+"^"+FreeAppFee+"^"+FreeOtherFee
	var SaveMethod=document.getElementById('SaveMethod');
	if (SaveMethod) {var encmeth=SaveMethod.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,InString)) {
		location.reload();                ///从新加载页面
	}
	else{
		alert("添加失败")
	}
}




function SelectRowHandler()	{   
    tempobj=document.getElementById('AddItem');
    if(tempobj){
	   tempobj.disabled=true;
	    }
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRegConFree');
	///得到表格的总行数
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	///把表格中被选中的那一行赋值到rowObj中
	var rowObj=getRow(eSrc);
	///得到选中行的序号selectrow它是一个全局变量
	var selectrow=rowObj.rowIndex;
	///如果没有选中任何行,"更新"按钮变灰如果选择某一行¨更新〃按钮可用
	if (!selectrow)return;
	///如果重新选中的行与原选中行不同则更改
	if (selectrow!=SelectedRow){
		var obj=document.getElementById('FeeCate');
		if (obj){
			var	SelRowObj=document.getElementById('TRCFAdmReasonDrz'+selectrow);
			var RCFAdmReasonDrz=SelRowObj.value
			var selectindex=DHCC_SelectOptionByValue("FeeCate",RCFAdmReasonDrz)
		}
		var obj=document.getElementById('StartDate');
		if (obj){
			var SelRowObj=document.getElementById('TRCFStartDatez'+selectrow);
			obj.value=SelRowObj.innerText;	
		}
		var obj=document.getElementById('EndDate');
		if (obj){
			var SelRowObj=document.getElementById('TRCFEndDatez'+selectrow);
			obj.value=SelRowObj.innerText;	
		
		}
		var obj=document.getElementById('StartTime');
		if (obj){
			var SelRowObj=document.getElementById('TRCFStartTimez'+selectrow);
			obj.value=SelRowObj.innerText;                     
		}
		var obj=document.getElementById('EndTime');
		if (obj){
			var SelRowObj=document.getElementById('TRCFEndTimez'+selectrow);
			obj.value=SelRowObj.innerText;
		}
		var obj=document.getElementById('FreeAllFee');
		if (obj){
			var SelRowObj=document.getElementById('TRCFFreeAllFeez'+selectrow);
			if(SelRowObj.innerText=="是"){obj.checked=true;}
			else{obj.checked=false}
		}
		var FreeRegFee
		var obj=document.getElementById('FreeRegFee');
		if (obj){
			var SelRowObj=document.getElementById('TRCFFreeRegFeez'+selectrow);
			obj.value=SelRowObj.innerText
		}
		var FreeOtherFee
		var obj=document.getElementById('FreeOtherFee');
		if (obj){
			var SelRowObj=document.getElementById('TRCFFreeOtherFeez'+selectrow);
			obj.value=SelRowObj.innerText
		}
		var FreeAppFee
		var obj=document.getElementById('FreeAppFee');
		if (obj){
			var SelRowObj=document.getElementById('TRCFFreeAppFeez'+selectrow);
			obj.value=SelRowObj.innerText
		}
		var FreeCheckFee
		var obj=document.getElementById('FreeCheckFee');
		if (obj){
			var SelRowObj=document.getElementById('TRCFFreeCheckFeez'+selectrow);
			obj.value=SelRowObj.innerText
		}
		SelectedRow=selectrow;	
	}
	else {
		///重复选择某行我们认为是取消选择把内容清空
		SelectedRow=0;
		ClearMedUnit();
	}
}
function ClearMedUnit()
{	
	var obj=document.getElementById('StartDate');
	if(obj){obj.value="";}
	var obj=document.getElementById('EndDate');
	if(obj){obj.value="";}
	var obj=document.getElementById('StartTime');
	if(obj){obj.value="";}
	var obj=document.getElementById('EndTime');
	if(obj){obj.value="";}
	var obj=document.getElementById('FreeAllFee');
	if(obj){obj.checked=false;}
	var obj=document.getElementById('FreeRegFee');
	if(obj){obj.value="";}
    var obj=document.getElementById('FreeOtherFee');
    if(obj){obj.value="";}	
	var obj=document.getElementById('FreeAppFee');
    if(obj){obj.value="";}	
	var obj=document.getElementById('FreeCheckFee');
    if(obj){obj.value="";}	
	tempobj=document.getElementById('AddItem');
	if(tempobj){tempobj.disabled=false;}
}	

function ClearAllList(obj) {
	if (obj.options.length>0) {
	for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
	}
}	

function AddItemToList(obj,arytxt,aryval) {
	if (arytxt.length>0) {
		if (arytxt[0]!="") {
			var lstlen=obj.length;
			for (var i=0;i<arytxt.length;i++) {
				//alert(i)
				obj.options[lstlen] = new Option(arytxt[i],aryval[i]); 
				lstlen++;}
		}
	}
}
function Delete_click()

{	var selectrow=SelectedRow;
    if(selectrow==0) {return;}
	var SelRowObj=document.getElementById('TRCFRowIDz'+selectrow);
	TRCFRowID=SelRowObj.value;
	var Deleterow=document.getElementById('Deleterow');
	if (Deleterow) {var encmeth=Deleterow.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,TRCFRowID)==0) {
		location.reload();  
	}

}

function UpDate_click()
{	var selectrow=SelectedRow;
    if(selectrow==0) {return;}
    var obj=document.getElementById("FeeCate")
    if(obj){RCFAdmReasonDr=obj.value
		 if(RCFAdmReasonDr==""){
		    alert(t['01'])
		    return;
		    }
	    }
	var obj=document.getElementById('StartDate')
	if(obj){
		StartDate=obj.value
		if(StartDate==""){
			alert(t['02'])
			return;
			}
	}
	var obj=document.getElementById('EndDate')
	if(obj){
		EndDate=obj.value}
 
    var obj=document.getElementById('StartTime')
	if(obj){StartTime=obj.value
		if(StartTime==""){
			alert(t['03'])
			return;
			}
	}
	var obj=document.getElementById('EndTime')
	
	if(obj){
		EndTime=obj.value
		EndTime=cTrim(EndTime,0)
	} 
	var obj=document.getElementById('FreeAllFee')
	if(obj){
		if(obj.checked==true){FreeAllFee="Y"}
		else{FreeAllFee="N"}
	} 
	var FreeAppFee
	var obj=document.getElementById('FreeAppFee')
	if(obj){FreeAppFee=obj.value} 
	var FreeOtherFee
	var obj=document.getElementById('FreeOtherFee')
	if(obj){FreeOtherFee=obj.value;}

	var FreeRegFee
	var obj=document.getElementById('FreeRegFee')
	if(obj){FreeRegFee=obj.value;} 
	var FreeCheckFee
	var obj=document.getElementById('FreeCheckFee')
	if(obj){FreeCheckFee=obj.value;}	
	var SelRowObj=document.getElementById('TRCFRowIDz'+selectrow);
	TRCFRowID=SelRowObj.value;
	var InString=TRCFRowID+"^"+RCFAdmReasonDr+"^"+StartDate+"^"+StartTime+"^"+EndDate+"^"+EndTime+"^"+FreeRegFee+"^"+FreeCheckFee+"^"+FreeAllFee+"^"+FreeAppFee+"^"+FreeOtherFee

	var UpDaterow=document.getElementById('UpDaterow');
	if (UpDaterow) {var encmeth=UpDaterow.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,InString)==0) {
		location.reload();  
	}
}
function cTrim(sInputString,iType)
{
  var sTmpStr = ' '
  var i = -1

  if(iType == 0 || iType == 1)
  {
     while(sTmpStr == ' ')
     {
       ++i
       sTmpStr = sInputString.substr(i,1)
     }
     sInputString = sInputString.substring(i)
  }

  if(iType == 0 || iType == 2)
  {
    sTmpStr = ' '
    i = sInputString.length
    while(sTmpStr == ' ')
    {
       --i
       sTmpStr = sInputString.substr(i,1)
    }
    sInputString = sInputString.substring(0,i+1)
  }
  return sInputString
}


document.body.onload = BodyLoadHandler;

