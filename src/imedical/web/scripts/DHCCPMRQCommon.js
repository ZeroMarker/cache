////DHCCPMRQCommon.js
/// ����Applet



///4.0��Ǭֱ�Ӵ�ӡ
/// ��ʽ: {��������.raq}{��������.raq(par1=val1;par2=val2)}
function DHCCPM_RQDirectPrint4(filename)
{
	if (filename==""){
		alert("�����뱨�����ƺͱ������");
		return;
	}
	var printobj=window.document.Dtreport1_directPrintApplet;
	var rqappserver=""
	$m({                
		ClassName:'web.DHCBL.RQ.WebServerConfig',
		MethodName:'GetReportName',
		strName:filename				
	},function(txtData){
		rqappserver=txtData; 
		//rqappserver="{"+rqappserver+"}";
		alert("rqappserver-------"+rqappserver);
		try{
			printobj.print(rqappserver);
		}catch(e){
		
		}
	
	})
	
}

// ������Ǭ��ӡ
/// ��ʽ:  1.��������.raq���߱�������.rpx
///        2.��������.rpx&arg1=val1&arg2=val2
/// �ڶ���������  width
/// ������������  height
function DHCCPM_RQPrint(parameter) {
	//use window.open so we can close this window, without closing everything
	//format reportname(reportarg1=value;reportarg2=value)
	var args = arguments.length
	var width = 800;
	var height= 300;
	var parm = ""
	if(args>=1){
		if (arguments[0]==""){
			alert("�����뱨�����ƺͱ������");
			return;
		}
		parm=arguments[0];
	}
	if(args>=2){
		if(arguments[1]!=""){
			width=arguments[1];
		}
	}
	if(args>=3){
		if(arguments[2]!=""){
			height=arguments[2];
		}
	}
	var url = tkMakeServerCall("web.DHCBL.RQ.WebServerConfig","GetURLReportArgName",parm,"2");
	websys_createWindow(url,1,"width=" + width + ",height=" + height + ",top=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
	/*
	$m({                
		ClassName:'web.DHCBL.RQ.WebServerConfig',
		MethodName:'GetURLReportArgName',
		strName:parm,
		strType:1				
	},function(txtData){
		rqappserver=txtData; 
		//rqappserver="{"+rqappserver+"}";
		alert("rqappserver-------"+rqappserver);
		var url=rqappserver;
		///var url="dhccpmrunqianreport.csp?reportName="+rqappserver;
		//var url="http://192.168.0.112:8080/runqianReport2018/report/jsp/dhccpmrunqianreportprint.jsp?report=DHCBILL-OPBILL-%E9%97%A8%E8%AF%8A%E6%94%B6%E6%8D%AE%E6%98%8E%E7%BB%86.rpx";
		websys_createWindow(url,1,"width=" + width + ",height=" + height + ",top=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
	
	})
	*/
	
}




///��Ǭֱ�Ӵ�ӡ
/// ��ʽ: {�޲�����������.rpx}{�в�����������.raq(par1=val1;par2=val2)}
function DHCCPM_RQDirectPrint(filename)
{
	if (filename==""){
		alert("�����뱨�����ƺͱ������");
		return;
	}else{
		var reportName =filename.substring(filename.indexOf("{")+1,filename.indexOf("("));
		//�������������.raq 4.0�������ת����.rpx
		if(reportName.lastIndexOf(".raq")!=-1){
			//reportName=reportName.substring(0,reportName.indexOf("."))+".rpx";
			reportName=reportName.replace(".raq",".rpx");    
		}
		//var reportNamebak=reportName.substring(0,reportName.indexOf("."));
		var paramString =filename.substring(filename.indexOf("(")+1,filename.indexOf(")"));
		//alert("�������ƣ�"+reportName);
		//alert("���������"+paramString);
	}
	
	var rqappserver = tkMakeServerCall("web.DHCBL.RQ.WebServerConfig","GetProjectURL");
	var runqianurl="";
	var runqianurl1=rqappserver+"raqsoft/pdfjs/pdfDirectPrint.jsp?src=";
	var runqianurl2="";
	if(paramString.length>0){
		runqianurl2=rqappserver+"reportServlet?action=6&file="+reportName+"&paramString="+paramString+"&columns=0&srcType=file&print=1&printPages=all";
	}else{
		runqianurl2=rqappserver+"reportServlet?action=6&file="+reportName+"&columns=0&srcType=file&print=1&printPages=all";
	}
	runqianurl2=encodeURIComponent(runqianurl2); //����ת��
		//runqianurl2=encodeURI(runqianurl2);
	runqianurl=runqianurl1+runqianurl2;
	//alert("runqianurl:"+runqianurl);
	var BroswerName = getBroswer();
	//alert("broswer:"+BroswerName.broswer+" version:"+BroswerName.version);
	if(BroswerName.broswer=="IE"){
		var html='<iframe id="BIrunqianPDFIfr" src="'+runqianurl+'" width=0 height=0></iframe>';
		//alert("IE"+html);
		$("body").append(html);
	}else{
		open(runqianurl,"TRAK_hidden");
	}
		
}

///mzc
///2020-03-05
///������������ͼ��汾
function getBroswer(){
	    var Sys = {};
	    var ua = navigator.userAgent.toLowerCase();
	    var s;
	    (s = ua.match(/edge\/([\d.]+)/)) ? Sys.edge = s[1] :
	    (s = ua.match(/rv:([\d.]+)\) like gecko/)) ? Sys.ie = s[1] :
	    (s = ua.match(/msie ([\d.]+)/)) ? Sys.ie = s[1] :
	    (s = ua.match(/firefox\/([\d.]+)/)) ? Sys.firefox = s[1] :
	    (s = ua.match(/chrome\/([\d.]+)/)) ? Sys.chrome = s[1] :
	    (s = ua.match(/opera.([\d.]+)/)) ? Sys.opera = s[1] :
	    (s = ua.match(/version\/([\d.]+).*safari/)) ? Sys.safari = s[1] : 0;
	 
	    if (Sys.edge) return { broswer : "Edge", version : Sys.edge };
	    if (Sys.ie) return { broswer : "IE", version : Sys.ie };
	    if (Sys.firefox) return { broswer : "Firefox", version : Sys.firefox };
	    if (Sys.chrome) return { broswer : "Chrome", version : Sys.chrome };
	    if (Sys.opera) return { broswer : "Opera", version : Sys.opera };
	    if (Sys.safari) return { broswer : "Safari", version : Sys.safari };
	    
	    return { broswer : "", version : "0" };
	}