function GetRequest() {

   var url = location.search; //获取url中"?"符后的字串
   

   var theRequest = new Object();

   if (url.indexOf("?") != -1) {

      var str = url.substr(1);

      strs = str.split("&");

      for(var i = 0; i < strs.length; i ++) {
		  

         theRequest[strs[i].split("=")[0]]=unescape(strs[i].split("=")[1]);

      }

   }

   return theRequest;

}



//加载js liangqiang 2014-05-20
function ImportJavaScript(url)
{

	  	var script=document.createElement("script");  
		script.setAttribute("type", "text/javascript");  
		script.setAttribute("src", url);  
		var heads = document.getElementsByTagName("head");
		if(heads.length) 
		{
			 heads[0].appendChild(script); 
		} 
		    
		else  {
			document.documentElement.appendChild(script);
		}

}

//加载CSS liangqiang 2014-05-20
function ImportCssByLink(url){  
   var doc=document;  
    var link=doc.createElement("link");  
    link.setAttribute("rel", "stylesheet");  
    link.setAttribute("type", "text/css");  
    link.setAttribute("href", url);  
  
    var heads = doc.getElementsByTagName("head");  
    if(heads.length)  
        heads[0].appendChild(link);  
    else  
        doc.documentElement.appendChild(link); 

     
}



//加载JqueryUI相关环境 liangqiang 2014-05-27
function ImportJqueryUI()
{
    
    var url="../scripts_lib/jquery-easyui-1.3.5/jquery-1.7.2.min.js"
	ImportJavaScript(url)
	var url="../scripts_lib/jquery-easyui-1.3.5/jquery.easyui.min.js"
    ImportJavaScript(url)
	var url="../scripts_lib/jquery-easyui-1.3.5/themes/default/easyui.css"
	ImportCssByLink(url)
	var url="../scripts_lib/jquery-easyui-1.3.5/themes/icon.css"
	ImportCssByLink(url)
	var url="../scripts_lib/jquery-easyui-1.3.5/locale/easyui-lang-zh_CN.js"
    ImportJavaScript(url)

}

function GetGridOpt(grid)
{
	var opt=$(grid).datagrid('options');
	return opt
}