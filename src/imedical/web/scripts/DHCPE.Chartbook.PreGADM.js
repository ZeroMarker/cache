/// DHCPE.Chartbook.PreGADM.js
/// ����ʱ��		2006.06.27
/// ������			xuwm
/// ��Ҫ����		ִ�в��ҳ��Ĺ���
/// ʹ��ҳ��		DHCPEPreGADM.Edit.csp,DHCPEPreGADM.Query.csp
/// ����޸�ʱ��	
/// ����޸���	
/// ���

//��Ƕ�׿���� ���µĴ���
function OpenIFRAMEWindow(IfFrameName,lnk) {
	var df=document.getElementById(IfFrameName);
	if (df) { df.src=lnk; }
}

// ��Ƕ�׿���� ˢ�´���
function ReloadIFRAMEWindow(lnk) {

	var df=document.getElementById("dataframe");
	if (df) { df.src=lnk; }

}

// //////////////////////////////////////////////////////////////////////////////
// ���º��� �ο� epr.chartbook.show.csp
function setDataFrameSize() {

	//if (websys_isIE) 
	if ((window.navigator.appName=='Microsoft Internet Explorer')||(window.navigator.appName=='Netscape')){

      if(window.navigator.appVersion.indexOf("rv:11") > -1)
       { 
        remainHgt = document.body.scrollHeight -3 -offsetHgt;
		remainWdt = document.body.offsetWidth -3 -offsetWdt;
       }
       else{
	       remainHgt = document.body.offsetHeight -3 -offsetHgt;
		   remainWdt = document.body.offsetWidth -3 -offsetWdt;
       }
		
	  
		//set data frame to length and width of remaining page, and widen to fit charttabs
		var obj=document.getElementById("charttabs");
		var posLeft = obj.offsetWidth;
		obj.style.width = posLeft;
	
		var obj=document.getElementById("chartbook");
		remainHgt -= obj.offsetTop;
		remainWdt -= obj.offsetLeft;
	
		posLeft += obj.offsetWidth;
		var obj=document.getElementById("data");
		obj.style.left = posLeft;
		remainWdt -= posLeft;

		resizeframe(remainWdt,remainHgt)
	} else {
		document.frames["dataframe"].window.resizeTo(screen.width,screen.height);
	}
}

function resizeframe(remainWdt,remainHgt)
{
	try {
		//document.frames["dataframe"].window.resizeTo(remainWdt,remainHgt);
		
		
		var df=document.getElementById("dataframe");
		if (df) {
			df.style.height=remainHgt
			df.style.width=remainWdt
		}

	}
	catch (e) {
		setDataFrameSize();
	}
}

window.onresize = setDataFrameSize;