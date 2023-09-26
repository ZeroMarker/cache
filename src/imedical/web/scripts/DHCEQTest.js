function BodyLoadHandler() 
{
	InitPage();
	var a=[];
	//a[1]=1;
	a[2]=0;
	a[3]=1;
	//alertShow(a[0]);
}

function InitPage()
{
	var obj=document.getElementById("ItemB");
	if (obj) obj.onclick=ItemB_Clicked;
	var obj=document.getElementById("ItemC");
	if (obj) obj.onclick=ItemC_Clicked;	
}

function ItemB_Clicked()
{
	var objtbl=document.getElementById('tDHCEQTest');
	var rows=objtbl.rows.length;
	///alertShow(objtbl.rows[0].cells[0].innerText);
	var oldrow=objtbl.rows[objtbl.rows.length-1]
	//alertShow(oldrow.cells[0].innerText);
	var newrow=oldrow.cloneNode(true);
	
	var rowitems=newrow.all; //IE only
	if (!rowitems) rowitems=newrow.getElementsByTagName("*"); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			arrId[arrId.length-1]=parseInt(arrId[arrId.length-1])+1;
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
			//alertShow(rowitems[j].id);
			//if (rowitems[j].tagName=='LABEL'){rowitems[j].innerText=""}else{rowitems[j].value=""}
		}
	}
	
	//alertShow('a');
	//make sure objtbl is the tbody element,
	//之所以要走tk_getTBody?是因为TBody不包括THead,而且TBody只有appendChild,但只用通过rowobj才能取得TBody
	//tUDHCOEOrder_List_Custom是包括THeader和Tbody
	//tUDHCOEOrder_List_Custom.rows和TBody.rows是不同的?后者一般比前者少1
	
	var objtbody=tk_getTBody(oldrow);	
	objtbody.appendChild(newrow);
	return;
	
	
	
	
	var lnk=window.location.href;
	lnk=ToPage(lnk,9)
	window.location.href=lnk;
	//window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQTest&
}

function ItemC_Clicked()
{
	var lnk=window.location.href;
	lnk=ToPage(lnk,0)
	window.location.href=lnk;
}

function ToPage(lnk,page)
{
	var index=lnk.indexOf("&TPAGCNT=")
	if (index>-1)
	{
		var pre=lnk.substring(0,index);
		var suf=lnk.substring(index+9);
		index=suf.indexOf("&")
		if (index>-1)
		{
			suf=suf.substring(index);
		}
		else
		{	suf=""; }
		lnk=pre+"&TPAGCNT="+page+suf;
	}
	else
	{
		lnk=lnk+"&TPAGCNT="+page
	}
	return lnk;
}



document.body.onload = BodyLoadHandler;