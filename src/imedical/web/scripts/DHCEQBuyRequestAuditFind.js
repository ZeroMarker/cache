var OperType;

function BodyLoadHandler() 
{	
	setOperType();
		
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;	
}

function setOperType()
{
	OperType=0;
	var obj=document.getElementById("GetOperType");
	if (obj&&obj.value!="")	{	OperType=obj.value;	}
	var obj=document.getElementById("BAdd");
	if (OperType==1)	
		{	obj.style.visibility="hidden";}
	else	
		{	obj.onclick=BAdd_Click;	}
	
	
}

function BAdd_Click() 
{
	var str='dhceqbuyrequest.csp?OperType='+OperType+'&EquipDR=1';
    window.open(str,'_self','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
}

function BFind_Click() 
{
}

document.body.onload = BodyLoadHandler;