document.body.onload = BodyLoadHandler;
var Str;
var SelectedRow=0;
function BodyLoadHandler()
{	 var Str="";
	var objtbl=document.getElementById('tDHCDocItemDefaultOrder');
	var rows=objtbl.rows.length; 
	for (var i=1;i<rows;i++)
	{
		var obj=document.getElementById('Chosez'+i);
	 	if (i==1){
		 	obj.checked=true;
		 	obj.disabled=false;
		 	var objrow=objtbl.rows[1];
		    objrow.click();
		}else{
			obj.disabled=true;
		}
	 }
	var obj=document.getElementById("Chose");
	if (obj){obj.onclick=ChoseOrder;}
	var obj=document.getElementById("Close");
	if (obj){obj.onclick=Closeobj;}
    var tbl=document.getElementById("tDHCDocItemDefaultOrder");
	if(tbl) tbl.ondblclick=TblDblClick;
	document.onkeydown = Doc_OnKeyDown;
}
function Doc_OnKeyDown(e){
	 var keycode = websys_getKey(e);
	 if (keycode==27){
		 Closeobj();
	 }
	 if (keycode=="38"){
		 //up
		 UpSelRow();
	 }
	 if (keycode=="40"){
		 //down
		 DownSelRow();
	 }
	 if (keycode=="13"){
		var objtbdl=document.getElementById('tDHCDocItemDefaultOrder');
	    var rows=objtbdl.rows.length;
	    for(var u=1;u<rows;u++){
		    var obj=document.getElementById('Chosez'+u);
		    if (obj.checked==true){
			    ChoseOrder();
			}
		}
	 }
}
function UpSelRow(){
	var objtbdl=document.getElementById('tDHCDocItemDefaultOrder');
	var rows=objtbdl.rows.length;
	if (rows>2){
	   if (SelectedRow==1){
		   //var objrow=objtbdl.rows[1];
		   //objrow.click();
		   SelectedRow=1;
	   }else{
		   var objrow=objtbdl.rows[SelectedRow-1];
		   objrow.click();
	   }
	   ChangeChose();
	} 
}
function DownSelRow(){
	var objtbdl=document.getElementById('tDHCDocItemDefaultOrder');
	var rows=objtbdl.rows.length;
	if (rows>2){
		if (SelectedRow==(rows-1)){
		   //var objrow=objtbdl.rows[1];
		   //objrow.click();
		   SelectedRow=rows-1;
	   }else{
		   var objrow=objtbdl.rows[SelectedRow+1];
		   objrow.click();
	   }
	   ChangeChose();
	}
}
function ChangeChose(){
	var obj=document.getElementById('Chosez'+SelectedRow);
    obj.checked=true;
    obj.disabled=false;
    var objtbl=document.getElementById('tDHCDocItemDefaultOrder'); 
	var rows=objtbl.rows.length;
    for(var u=1;u<rows;u++){
	    if(u!=SelectedRow){
		    var obj=document.getElementById('Chosez'+u);
		    obj.checked=false;
		    obj.disabled=true;
		}
	 }
}
function Closeobj()
{
	window.returnValue="";
	window.close();
}
function ChoseOrder()
{	var Str="";
	var objtbdl=document.getElementById('tDHCDocItemDefaultOrder');
	var rows=objtbdl.rows.length; 
	for (var i=1;i<rows;i++)
	{	
		var obj=document.getElementById('Chosez'+i);
	 	if (obj.checked==true)
	 	{
		 	var obj=document.getElementById('Rowidz'+i);  //医嘱名称
	 	 if (obj){var Rowidz=obj.value;};
		 	
		 var obj=document.getElementById('TabArcimDescz'+i);  //医嘱名称
	 	 if (obj){var TabArcimDescz=obj.innerText;};
	 	 var obj=document.getElementById('TabARCIMDRz'+i);  //医嘱id
	 	 if (obj){var TabARCIMDRz=obj.value;};
	 	 
	 	 var obj=document.getElementById('TabPHFreqDRz'+i); //频次id
	 	 if (obj){var TabPHFreqDRz=obj.value;};
	 	 
	 	 var obj=document.getElementById('TabPriorityDRz'+i); //医嘱类型id
	 	 if (obj){var TabPriorityDRz=obj.value;};
	 	 var obj=document.getElementById('TabDosez'+i);//单次计量
	 	 if (obj){var TabDosez=obj.innerText;};
	 	
	 	 var obj=document.getElementById('TabRelevanceNoz'+i); //关联
	 	 if (obj){var TabRelevanceNoz=obj.innerText;};
	 	 var obj=document.getElementById('TabDoseUomDRz'+i); //计量单位id
	 	 if (obj){var TabDoseUomDRz=obj.value;};
	 	 var obj=document.getElementById('TabInstrDRz'+i); //用法id
	 	 if (obj){var TabInstrDRz=obj.value;};
	 	
	 	 var obj=document.getElementById('TabPackQtyz'+i);//数量  数量后的单位缺失
	 	 if (obj){var TabPackQtyz=obj.innerText;};
	 	 var obj=document.getElementById('TabArcimDexzscz'+i); //疗程id
	 	 if (obj){var TabArcimDexzscz=obj.innerText;};
	 	 var obj=document.getElementById('TabSkinTestz'+i);//是否皮试
	 	 if (obj){var TabSkinTestz=obj.innerText;};
	 	 
	 	 var obj=document.getElementById('TabSkinActionDRz'+i);//皮试备注id
	 	 if (obj){var TabSkinActionDRz=obj.value;};
	 	 var Str=Rowidz
	 	 //var Str=TabArcimDescz+"^"+TabARCIMDRz+"^"+TabPHFreqDRz+"^"+TabPriorityDRz+"^"+TabDosez+"^"+TabRelevanceNoz+"^"+TabDoseUomDRz+"^"+TabInstrDRz+"^"+TabPackQtyz+"^"+TabArcimDexzscz+"^"+TabSkinTestz+"^"+TabSkinActionDRz;
		//else Str=Str+"*"+TabArcimDescz+"^"+TabARCIMDRz+"^"+TabPHFreqDRz+"^"+TabPriorityDRz+"^"+TabDosez+"^"+TabRelevanceNoz+"^"+TabDoseUomDRz+"^"+TabInstrDRz+"^"+TabPackQtyz+"^"+TabArcimDescz+"^"+TabSkinTestz+"^"+TabSkinActionDRz;
		
		 }
	}
	window.returnValue=Str;
	window.close();


	}
function SelectRowHandler()
 {  
    var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCDocItemDefaultOrder'); 
	var rows=objtbl.rows.length;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	SelectedRow=selectrow
	for(var k=1;k<rows;k++){var obj=document.getElementById('Chosez'+k);obj.disabled=false;}
	for(var u=1;u<rows;u++)
		{
	 	 	var obj=document.getElementById('Chosez'+u).checked;
	 	 	if(obj==true)
	 	 	{for(var s=1;s<rows;s++){if(s!=u){var obj=document.getElementById('Chosez'+s);obj.disabled=true;}}}
	 	 	  
		 }
 
	
}
function TblDblClick()
{
	var eSrc=window.event.srcElement;
	Objtbl=document.getElementById('tDHCDocItemDefaultOrder');
	Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('Rowidz'+selectrow);  //医嘱名称
	 	 if (obj){var Rowidz=obj.value;};
	 	 var Str=Rowidz
	 	 window.returnValue=Str;
	     window.close();
	 	 
}
	

	
	



