
		var Sys = {};
		var ua = navigator.userAgent.toLowerCase();
		var s;
		(s = ua.match(/msie ([\d.]+)/)) ? Sys.ie = s[1] :
		(s = ua.match(/firefox\/([\d.]+)/)) ? Sys.firefox = s[1] :
		(s = ua.match(/chrome\/([\d.]+)/)) ? Sys.chrome = s[1] :
		(s = ua.match(/opera.([\d.]+)/)) ? Sys.opera = s[1] :
		(s = ua.match(/version\/([\d.]+).*safari/)) ? Sys.safari = s[1] : 0;
        
        //以下进行测试    "&extfilename=App/BDPSystem/BDPMain"
        if(!Sys.ie){
	        window.location.href="dhc.bdp.bootstrap.default.csp"; 
        }else{
        	window.location.href="dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/BDPExtMain"; 
        }
        
          //获取浏览器版本   
        var browerInfo="" 
        if(Sys.ie) browerInfo='IE:'+Sys.ie;
        else if(Sys.firefox) browerInfo='Firefox:'+Sys.firefox;
        else if(Sys.chrome) browerInfo='Chrome:'+Sys.chrome;
        else if(Sys.opera) browerInfo='Opera:'+Sys.opera;
        else if(Sys.safari) browerInfo='Safari:'+Sys.safari;
        else if (!!window.ActiveXObject || "ActiveXObject" in window)
		{
			browerInfo="IE:11"
		}
		else
		{
			browerInfo=""
		}
		//alert(browerInfo)
		///保存到后台去
		tkMakeServerCall("web.DHCBL.BDP.BDPSysErrorLog","SaveBrowerInfo",browerInfo);
	 

