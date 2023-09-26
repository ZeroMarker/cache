var row;
var rows;
var paths;
var remarks;

function BodyLoadHandler() 
{
	//return;
	//alertShow(document.body.style.display);
	row=GetElementValue("Row");
	rows=GetElementValue("Rows");
	paths=GetElementValue("paths");
	remarks=GetElementValue("remarks");
	InitUserInfo();
	InitButton();
	InitPic();
}

function DisableAllButton(value)
{
	DisableBElement("BPrev",value);
	DisableBElement("BNext",value);
}

function InitButton()
{
	var obj=document.getElementById("BPrev");
	if (obj) obj.onclick=BPrev_Click;	
	var obj=document.getElementById("BNext");
	if (obj) obj.onclick=BNext_Click;
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Click;
	if (row==1) DisableBElement("BPrev",true);	
	if (row==rows) DisableBElement("BNext",true);
}

function InitPic()
{
	var obj=document.getElementById("Pic1");
	if (obj)
	{		
		ImageResize(obj.width,obj.height);
	}
}

function ImageResize(newwidth,newheight)
{
	var resizeWidth,resizeHeight;
  	resizeWidth=800;//最大宽度
  	resizeHeight=560;//最大高度
  	if (newheight>resizeHeight)
   		{newwidth=newwidth*(resizeHeight/newheight);
   		newheight=newheight*(resizeHeight/newheight);}
  	if (newwidth>resizeWidth) 
   		{newheight=newheight*(resizeWidth/newwidth);
  		newwidth=newwidth*(resizeWidth/newwidth);}
  	var obj=document.getElementById("Pic1");
  	obj.style.width=newwidth;
 	obj.style.height=newheight;
 	
 	window.resizeTo(newwidth+100,newheight+160);
}

function BPrev_Click()
{
	ShowPic(row-1);
}

function BNext_Click()
{
	ShowPic(parseInt(row)+1);
}


function ShowPic(vrow)
{
	var arypath=GetElementValue("Paths").split(",");
	var aryremark=GetElementValue("Remarks").split(",");
	var path=arypath[vrow];
	var remark=aryremark[vrow];
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQViewFile&Paths='+paths+'&Remarks='+remarks+'&Rows='+rows+'&Row='+vrow+'&Path='+path+'&Remark='+remark;
	location.href=lnk;
}

function BClose_Click() 
{
	window.close();
}

document.body.onload = BodyLoadHandler;
