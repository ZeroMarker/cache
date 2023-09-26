//需求处理记录
var CurrentSel=0,TypeIndex,file
function BodyLoadHandler()
{
	var obj=document.getElementById("str");
	if (obj){ obj.onchange=OnChange;}
	var tables = document.getElementsByTagName("table");
	//alert(tables.length);
	trRep = tables[4];
	trRep.style.display = 'none';
	trRep1 = tables[5];
	trRep1.style.display = 'none';
	trRep2 = tables[6];
	trRep2.style.display = 'none';
}
function OnChange()
{
   var obj=document.getElementById("str");
   lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementHand1&str="+obj.value;
   location.href=lnk;
	}
function SelectRowHandler()	
{
  var eSrc=window.event.srcElement;	
  var objtbl=document.getElementById('tPMPImprovementHand');
  var rowObj=getRow(eSrc);
  var selectrow=rowObj.rowIndex;
  if (!selectrow) return;
  var SelRowObj
	var obj	
	if (selectrow==CurrentSel){	
	CurrentSel=0;
	var tables = document.getElementsByTagName("table");
	//alert(tables.length);
	trRep = tables[4];
	trRep.style.display = 'none';
	trRep1 = tables[5];
	trRep1.style.display = 'none';
	trRep2 = tables[6];
	trRep2.style.display = 'none';
	 return;
	}		
  CurrentSel=selectrow;
  var row=selectrow;
  var TYPRowid=document.getElementById('TYP1IDz'+row);
  var TYPRowidValue=TYPRowid.value;
  TYP1MENU_click(TYPRowidValue);
  //var obj=document.getElementById('TYP1MENUz'+row);
  //if (obj){ obj.onclick=TYP1MENU_click(TYPRowidValue);}
}
function FrameEnterkeyCode()
{
	var e=window.event;
	switch (e.keyCode){
		//上下移动光标键
	case 38:
		var objtbl=window.document.getElementById('tPMPImprovementHand1');
		if (iSeldRow==1) {break;}
		var objrow=objtbl.rows[iSeldRow-1];
		objrow.click();
		break;
	case 40:
		var objtbl=window.document.getElementById('tPMPImprovementHand1');
		var rows=objtbl.rows.length-1;
		if (iSeldRow==rows) {break;}
		var objrow=objtbl.rows[iSeldRow+1];
		objrow.click();
		break;
	}
}
function TYP1MENU_click(TYPRowidValue)
{
	str=tkMakeServerCall("web.PMP.PMPImprovementList","jichushujv",TYPRowidValue);
	VerStr=str.split("^");
	if(VerStr[0]==t["gtjl"]){
		var tables = document.getElementsByTagName("table");
	   //alert(tables.length);
	   trRep = tables[5];
	   trRep.style.display = '';
	   tables[4].style.display = 'none'
	   tables[6].style.display = 'none'
	   //      标志         状态(审核结果)	      用户         内容      项目人员   用户          沟通日期             沟通时间
	   var obj=document.getElementById('GTyonghu');
       obj.value=VerStr[5];
       var obj=document.getElementById('GTuser');
       obj.value=VerStr[4];
       var obj=document.getElementById('GTdate');
       obj.value=VerStr[6];
       var obj=document.getElementById('GTtime');
       obj.value=VerStr[7];
       var obj=document.getElementById('GTneirong');
       obj.value=VerStr[3];
		}
	else{
		if((VerStr[0]==t["yysh"])||(VerStr[0]==t["xmsh"])){
		var tables = document.getElementsByTagName("table");
	    //alert(tables.length);
	    trRep = tables[4];
	    trRep.style.display = '';
	    tables[5].style.display = 'none'
	    tables[6].style.display = 'none'
	    var obj=document.getElementById('XQshenheren');
        obj.value=VerStr[2];
        var obj=document.getElementById('XQshenhejieguo');
        obj.value=VerStr[1];
        var obj=document.getElementById('XQbeizhu');
        obj.value=VerStr[3];	
		}
		else{
			var tables = document.getElementsByTagName("table");
	         //alert(tables.length);
	        trRep = tables[6];
	        trRep.style.display = '';
	        tables[4].style.display = 'none'
	        tables[5].style.display = 'none'
	        var obj=document.getElementById('QTneirong');
            obj.value=VerStr[3];
			}
		}
	}
document.body.onload = BodyLoadHandler;