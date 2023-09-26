$(function(){
	var tabheadHeight=$(".tabs-header").outerHeight(true);
	var windowHeight=window.innerHeight;
	//$("#mainheadtab").css({height:window.innerHeight-60});
	//$("#maintabs").css({"width":window.innerWidth});
    //$(tabs.getTab("主页")).css({"height":window.innerHeight-45})
	//var options=tabs.options()
	var containorHeight=windowHeight-tabheadHeight-16
	$("#appscontainor").height(containorHeight);
	$("#apptoolscontainor").height(containorHeight);
	/*$HUI.accordion("#apptoolscontainor",{
		height:windowHeight-tabheadHeight-12,
		border:false,
		fit:true
	});*/
	var panelHeadHeight=$(".panel-header").outerHeight(true);
	var toolContainorHeight=containorHeight-panelHeadHeight*4+22;
	$("#apptoolrecent").height(parseInt(toolContainorHeight/2));
	$("#apptoolusage").height(parseInt(toolContainorHeight/2)+1);
	var tabs=$HUI.tabs("#maintabs");
	var TAB_CONTTEMP=[
	    '<iframe id="',
	    , //1:frameId
	    '"name="',
	    , // 3 frameName
	    '" frameborder="0" marginheight="0px" marginwidth="0px" scrolling="auto" seamless="seamless"  src="',
	    , // 5:menuURL
	    '" height="',
	    , //7: height
	    'px" width="',
	    , // 9: widthz
	    '"></iframe>'
	  ];
	TAB_CONTTEMP[7]=window.innerHeight-tabheadHeight-5;
	TAB_CONTTEMP[9]="100%";
	$(".app-item-title").click(function(e){
	  var $href=$(this);
	  
	  var openTab=tabs.getTab($href.attr("data-title"));
	  if(tabs.exists($href.attr("data-title"))){
		  tabs.select($href.attr("data-title"));
		  return true;
	  }
	  TAB_CONTTEMP[1]=$href.attr("data-code");
	  TAB_CONTTEMP[3]=$href.attr("data-code");
	  TAB_CONTTEMP[5]="/dthealth/web/csp/dhcwlredirect.csp?url="+$href.attr("data-url");
	  
	  tabs.add({
		"id":$href.attr("data-code"),
	    "selected":true,
	    "closable":true,
	    "cache":false,
	    "width":"auto",
	    "title":$href.attr("data-title"),
	    //"href":$href.attr("data-url")
	    "content":TAB_CONTTEMP.join('')
	  });
	});
	//Context Menu
	/*$('html').on('contextmenu', function (){return false;}).click(function(){  
        //alert("close");  
    });  
    $('#appscontainor').on('contextmenu',function (e){  
        
        //var popupmenu = kyoPopupMenu.sys();  
        //l = ($(document).width() - e.clientX) < popupmenu.width() ? (e.clientX - popupmenu.width()) : e.clientX;  
        //t = ($(document).height() - e.clientY) < popupmenu.height() ? (e.clientY - popupmenu.height()) : e.clientY;  
        //popupmenu.css({left: l,top: t}).show();  
        //alert("show");
        return true;  
    });  */
    
   
});
/*
	//add by wz. 2018-05-23.  三查询调用 
	function addTab(item){
	var tabheadHeight=$(".tabs-header").outerHeight(true);
	var windowHeight=window.innerHeight;
	var containorHeight=windowHeight-tabheadHeight-16
	$("#appscontainor").height(containorHeight);
	$("#apptoolscontainor").height(containorHeight);
	var panelHeadHeight=$(".panel-header").outerHeight(true);
	var tabs=$HUI.tabs("#maintabs");
	var TAB_CONTTEMP=[
	    '<iframe id="',
	    , //1:frameId
	    '"name="',
	    , // 3 frameName
	    '" frameborder="0" marginheight="0px" marginwidth="0px" scrolling="auto" seamless="seamless"  src="',
	    , // 5:menuURL
	    '" height="',
	    , //7: height
	    'px" width="',
	    , // 9: width
	    '"></iframe>'
	  ];
	TAB_CONTTEMP[7]=window.innerHeight-tabheadHeight-5;
	TAB_CONTTEMP[9]="100%";		
		
	  var $href=item;
	  var openTab=tabs.getTab($href.attr("data-title"));
	  if(tabs.exists($href.attr("data-title"))){
		  tabs.select($href.attr("data-title"));
		  return true;
	  }
	  TAB_CONTTEMP[1]=$href.attr("data-code");
	  TAB_CONTTEMP[3]=$href.attr("data-code");
	  TAB_CONTTEMP[5]="/dthealth/web/csp/dhcwlredirect.csp?url="+$href.attr("data-url");
	  
	  tabs.add({
		"id":$href.attr("data-code"),
	    "selected":true,
	    "closable":true,
	    "cache":false,
	    "width":"auto",
	    "title":$href.attr("data-title"),
	    "content":TAB_CONTTEMP.join('')
	  });		
	} 
	*/