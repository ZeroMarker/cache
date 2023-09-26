function BodyLoadHandler()
{	

	setDefaultDate();

	var obj=document.getElementById("SelectYes")
	if (obj) obj.checked=1

		var obj=document.getElementById("SelectNo")
	if (obj) obj.checked=1
	
	//隐藏 同样处方号的选择打钩
	var tmpPrescno="0"
 	var prescNo;
	var obj=document.getElementById("t"+"DHCPHA_PRESCCOMMENTSSEARCH")
	var cnt=getRowcount(obj)
 	var i;
	for (i=1;i<=cnt;i++)
 	{
			var objx=document.getElementById("Tprescno"+"z"+i);
			if (objx) prescNo=objx.innerText //.value ;
			//alert("prescNo="+i+","+prescNo)
			if( tmpPrescno==prescNo)
			{
				document.getElementById("Tprescno"+"z"+i).innerText=""
				document.getElementById("Tipno"+"z"+i).innerText=""
				document.getElementById("Tpaname"+"z"+i).innerText=""
				document.getElementById("Tpasex"+"z"+i).innerText=""
				document.getElementById("Tpaage"+"z"+i).innerText=""
				document.getElementById("Tdiagnose"+"z"+i).innerText=""
				document.getElementById("Tdoctor"+"z"+i).innerText=""
				
				tmpPrescno=prescNo
				prescNo=""
				
			}
			else
			{
				tmpPrescno=prescNo
			}
 	}
	
}
function setDefaultDate()
{
	var t=today();
	
	var obj=document.getElementById("StartDate") ;
	if (obj) obj.value=t;
	
	var obj=document.getElementById("EndDate") ;
	if (obj) obj.value=t;
	}


document.body.onload=BodyLoadHandler;