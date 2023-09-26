function InitForm()
{
	var obj=document.getElementById('btnUpdate');
	if (obj){ obj.onclick=Update_click;}
	var obj=document.getElementById('cboNoType');
	if (obj){
		obj.size=1;
		obj.multiple=false;
	}
}

function Update_click()
{
	var ParRef='',ChildSub='',NoLength='',NoHead='',StartNo='',EndNo='',NoTypeID='';
	obj=document.getElementById('txtParRef');
	if (obj){ParRef=obj.value;}
	obj=document.getElementById('txtChildSub');
	if (obj){ChildSub=obj.value;}
	obj=document.getElementById('txtNoLength');
	if (obj){NoLength=obj.value;}
	obj=document.getElementById('txtNoHead');
	if (obj){NoHead=obj.value;}
	obj=document.getElementById('txtStartNo');
	if (obj){StartNo=obj.value;}
	obj=document.getElementById('txtEndNo');
	if (obj){EndNo=obj.value;}
	var obj=document.getElementById('cboNoType');
	if (obj){
		var Idx=obj.options.selectedIndex;
		if (Idx==-1){NoTypeID='';}
		else{NoTypeID=obj.options[Idx].value;}
	}
	if ((ParRef=='')||(NoTypeID=='')) return;
	var InStr=ParRef + '^' + ChildSub + '^' + NoLength + '^' + NoHead + '^' + StartNo + '^' + EndNo + '^' + NoTypeID + '^^';
	var obj=document.getElementById('MethodUpdate');
	if (obj) {var encmeth=obj.value} else {var encmeth=''}
	var flg=cspRunServerMethod(encmeth,InStr);
	if (flg<0){alert(t['UpdateFalse']);}
	else{alert(t['UpdateTrue']);}
	lnk='websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.MrNoLenExt.Edit&MrType='+ParRef;
	location.href=lnk;
}

function SelectRowHandler(){
	var ParRef='',ChildSub='',NoLength='',NoHead='',StartNo='',EndNo='',NoTypeID='';
	var objtbl=document.getElementById('tDHC_WMR_MrNoLenExt_Edit');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var eSrc=window.event.srcElement;
	var objRow=getRow(eSrc);
	var selectrow=objRow.rowIndex;
	if (selectrow <= 0) return;
	
	obj=document.getElementById('ParRefz'+selectrow);
	if (obj){ParRef=obj.value;}
	obj=document.getElementById('ChildSubz'+selectrow);
	if (obj){ChildSub=obj.value;}
	obj=document.getElementById('NoLengthz'+selectrow);
	if (obj){NoLength=obj.innerText;}
	obj=document.getElementById('NoHeadz'+selectrow);
	if (obj){NoHead=obj.innerText;}
	obj=document.getElementById('StartNoz'+selectrow);
	if (obj){StartNo=obj.innerText;}
	obj=document.getElementById('EndNoz'+selectrow);
	if (obj){EndNo=obj.innerText;}
	obj=document.getElementById('NoTypeIDz'+selectrow);
	if (obj){NoTypeID=obj.value;}
	
	var obj=document.getElementById('txtParRef');
	if (obj){obj.value=ParRef;}
	var obj=document.getElementById('txtChildSub');
	if (obj){obj.value=ChildSub;}
	var obj=document.getElementById('txtNoLength');
	if (obj){obj.value=Trim(NoLength);}
	var obj=document.getElementById('txtNoHead');
	if (obj){obj.value=Trim(NoHead);}
	var obj=document.getElementById('txtStartNo');
	if (obj){obj.value=Trim(StartNo);}
	var obj=document.getElementById('txtEndNo');
	if (obj){obj.value=Trim(EndNo);}
	var obj=document.getElementById('cboNoType');
	if (obj)
	{
		for (var i=0;i<obj.options.length;i++)
		{
			if (obj.options[i].value==NoTypeID){obj.options.selectedIndex=i;}
		}
	}
}
InitForm();
