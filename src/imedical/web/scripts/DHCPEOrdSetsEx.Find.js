
///组件:DHCPEOrdSetsEx.Find
///医嘱套功能扩展
var CurrentSel=0;
function BodyLoadHandler() {
 	
	var obj;
	
	//查找
	obj=document.getElementById("BFind");
	if (obj){ obj.onclick=BFind_click; }
	
	//新建
	obj=document.getElementById("BNew");
	if (obj){ obj.onclick=BNew_click; }	
	
	//更新
	obj=document.getElementById("BUpdate");
	if (obj){ obj.onclick=BUpdate_click; }	
	
	//删除
	obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click; }
	
	//清屏
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }
	
	
   
}

function BUpdate_click()
{
	var CurRow = selectedRowObj.rowIndex;
	try{
		if(CurRow>0){
			BNew_click();
		}
		else{ alert("请选择医嘱套！");return false; }
	}
	
	catch(e){
		alert("更新失败！"+e.message);
	}
	
	
}

function trim(s) 
{
	
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
    return (m == null) ? "" : m[1];
}


function BNew_click()
{
	var obj;
	var iRowId="",iOrdSetsDR="", iBreak="",iOEItemName="",iBarPrintName="",iPrintOrdSets="",iSex="",iTarItem="";
	
	//OSE_RowId
	obj=document.getElementById("RowId");
	if (obj) { iRowId=obj.value; }

	//OSE_OrdSets_DR	医嘱套
	obj=document.getElementById("OrdSets_DR");
	if (obj) { iOrdSetsDR=obj.value; }

	//OSE_Break	可否拆分
	obj=document.getElementById("aBreak");
	if (obj && obj.checked) { iBreak="Y"; }
	else { iBreak="N"; }
	
	//是否老年套餐
	obj=document.getElementById("IFOLD");
	if (obj && obj.checked) { iIFOLD="Y"; }
	else { iIFOLD="N"; }
	
	obj=document.getElementById("aPrint");
	if (obj && obj.checked) { iPrintOrdSets="Y"; }
	else { iPrintOrdSets="N"; }
      
    obj=document.getElementById("ShowOEItemName");
	if (obj) { iOEItemName=obj.value; }
	 
	obj=document.getElementById("ShowBarName");
	if (obj) { iBarPrintName=obj.value; }

 	var SpecialItem="";
 	obj=document.getElementById("PatFeeType_DR_Name");
	if (obj) { SpecialItem=obj.value; }

 	obj=document.getElementById("Sex_DR_Name");
	if (obj) { iSex=obj.value; }

	//输入数据验证
	if (""==iOrdSetsDR) {
		alert(t['XMISSING']);
		return false;
	}  
	obj=document.getElementById("TarItemId");
	if (obj) { iTarItem=obj.value; }
 
	var Instring=trim(iRowId)
				+"^"+trim(iOrdSetsDR)	
				+"^"+trim(iBreak)		
				+"^"+trim(iPrintOrdSets)
				+"^"+trim(iOEItemName)	
				+"^"+trim(iBarPrintName)		
				+"^"+SpecialItem
				+"^"+iSex
				+"^"+trim(iIFOLD)
				+"^"+trim(iTarItem)	
				;
	//alert(Instring)
	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var flag=cspRunServerMethod(encmeth,'','',Instring)
	//alert(flag)
	if (flag=='0') {
		if (""==iRowId) { iRowId="-1"; }
        var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEOrdSetsEx.Find"
				+"&ID="+iRowId
				; 
		location.href=lnk;
	}
	else if ('-119'==flag) {
		alert(t['Err 01']);
		return false;	}
	else {
		alert(t['02']);
		return false;
	}
	
	location.reload();
			
}


function ARCOrdSetsList(value) {
	
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;

		obj=document.getElementById("aOrdSets");
		if (obj) { obj.value=aiList[0]; }


		obj=document.getElementById("OrdSets_DR");
		if (obj) { obj.value=aiList[2]; }

	}
}

function clickTaritem(value)
{
 	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;

		obj=document.getElementById("TarItem");
		if (obj) { obj.value=aiList[2]; }

		obj=document.getElementById("TarItemId");
		if (obj) { obj.value=aiList[0]; }

	} 
}


function BFind_click()
{
	var obj;
	var iaOrdSets="",iaBreak="",iaPrint="";
	obj=document.getElementById("aOrdSets");
	if (obj){ iaOrdSets=obj.value; }
	obj=document.getElementById("aBreak");
	if (obj&&obj.checked){ iaBreak="on"; }
	obj=document.getElementById("aPrint");
	if (obj&&obj.checked){ iaPrint=obj.value; }
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEOrdSetsEx.Find"
			+"&aOrdSets="+iaOrdSets
			+"&aBreak="+iaBreak
			+"&aPrint="+iaPrint
			;
	//alert(lnk)		
	location.href=lnk;
}

function Delete_click() {
	
	var iRowID="";
	var obj=document.getElementById("RowId");
	if (obj && ""!=obj.value){ iRowID=obj.value; } 
	if (iRowID=="")	{
		alert(t['03']);
		return false
	} 
	else{ 
		if (confirm(t['04'])) {
			var Ins=document.getElementById('DeleteBox');
			if (Ins) {var encmeth=Ins.value; } 
			else {var encmeth=''; };
			var flag=cspRunServerMethod(encmeth,'','',iRowID)
			if (flag=='0') {
				location.reload();
			}
			else{
				alert(t['05']+flag)
			}
			
			
		}
	}
}


function SelectRowHandler() {

	var eSrc=window.event.srcElement;

	var objtbl=document.getElementById("tDHCPEOrdSetsEx_Find");	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;

	if (CurrentSel==selectrow)
	{
		CurrentSel=0;
	}
	else
	{
		CurrentSel=selectrow;
	}

	ShowCurRecord(CurrentSel);

}
function ShowCurRecord(CurrentSel) {
   
	var SelRowObj;
	var obj;
	var iRowId="";
	var iTAdmId=""
	if (CurrentSel==0)
	{
		obj=document.getElementById("RowId");
		if (obj) obj.value=iRowId
		return false;
	}
	SelRowObj=document.getElementById('OSE_RowId'+'z'+CurrentSel);
	obj=document.getElementById("RowId");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }
	
	SelRowObj=document.getElementById('OSE_OrdSets_DR'+'z'+CurrentSel);
	obj=document.getElementById("OrdSets_DR");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }
	
	SelRowObj=document.getElementById('OSE_OrdSets_DR_Name'+'z'+CurrentSel);
	obj=document.getElementById("aOrdSets");
	if (SelRowObj && obj) { obj.value=SelRowObj.innerText; }
	
	SelRowObj=document.getElementById('OSE_Break'+'z'+CurrentSel);
	obj=document.getElementById("aBreak");
	if (SelRowObj && obj) { obj.checked=SelRowObj.checked;}
	
	SelRowObj=document.getElementById('OSE_Print'+'z'+CurrentSel);
	obj=document.getElementById("aPrint");
	if (SelRowObj && obj) { obj.checked=SelRowObj.checked;}
	
	SelRowObj=document.getElementById('OSE_OEItem'+'z'+CurrentSel);
	obj=document.getElementById("ShowOEItemName");
	if (SelRowObj && obj) { obj.value=SelRowObj.innerText; }
	
	SelRowObj=document.getElementById('OSE_BarPrint'+'z'+CurrentSel);
	obj=document.getElementById("ShowBarName");
	if (SelRowObj && obj) { obj.value=SelRowObj.innerText; }
	
	SelRowObj=document.getElementById('IFOLD'+'z'+CurrentSel);
	obj=document.getElementById("IFOLD");
	if (SelRowObj && obj) { obj.checked=SelRowObj.checked;}
	
	SelRowObj=document.getElementById('TarItem'+'z'+CurrentSel);
	obj=document.getElementById("TarItem");
	if (SelRowObj && obj) { obj.value=SelRowObj.innerText; }
	
	SelRowObj=document.getElementById('TarItemId'+'z'+CurrentSel);
	obj=document.getElementById("TarItemId");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }
	
	SelRowObj=document.getElementById('TSex_DR_Name'+'z'+CurrentSel);
	obj=document.getElementById("Sex_DR_Name");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }

	SelRowObj=document.getElementById('TSpecialItemDR'+'z'+CurrentSel);
	obj=document.getElementById("PatFeeType_DR_Name");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }
	
}


function Clear_click() {
	var obj;	
	    
	//OSE_RowId
	obj=document.getElementById("RowId");
	if (obj) {obj.value=""; }

	//OSE_OrdSets_DR	医嘱套
	obj=document.getElementById('OrdSets_DR');
	if (obj) { obj.value=''; }

	//
	obj=document.getElementById('aOrdSets');
	if (obj) { obj.value=''; }

	//OSE_Break	可否拆分
	obj=document.getElementById('aBreak');
	if (obj) { obj.checked=false; }
	
	//导检单上显示
	obj=document.getElementById('ShowOEItemName');
	if (obj) { obj.value=''; }
	
	//条码上显示
	obj=document.getElementById('ShowBarName');
	if (obj) { obj.value=''; }
	
	//是否打印医嘱套
	obj=document.getElementById('aPrint');
	if (obj) { obj.checked=false; }
	
	//是否老年套餐
	obj=document.getElementById('IFOLD');
	if (obj) { obj.checked=false; }
	
	//收费项
	obj=document.getElementById('TarItem');
	if (obj) { obj.value=''; }
	
	//收费项ID
	obj=document.getElementById('TarItemId');
	if (obj) { obj.value=''; }
	
	//费用类型
	obj=document.getElementById('PatFeeType_DR_Name');
	if (obj) { obj.value=""; }
	
	//性别
	obj=document.getElementById("Sex_DR_Name");
	if (obj) { obj.value=""; }

	
}

document.body.onload = BodyLoadHandler;