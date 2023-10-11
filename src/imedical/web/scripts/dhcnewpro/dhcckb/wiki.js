/// JQuery 初始化页面
$(function(){ 
	initAnchor();
	initCrumbs();
	initData();
})
//动态右侧导航栏 sunhuiyong 2021-8-5
function initAnchor(){
	/**定于延时执行函数**/
    var timeFun = null;
    
    /**找到当前页面滚动到的锚点位置**/
    var findHref = function(){
        var $links = $('div .para-title');
        var windowScrollTop = $(window).scrollTop();
        var maxDistance = 10000;
        var result = $links.eq(0);
        $.each($links,function(i,link){
            var curDistanceToTop = Math.abs($links.eq(i).offset().top - windowScrollTop);
            /**if(maxDistance > curDistanceToTop && ($links.eq(i).offset().top < (windowScrollTop + $(window).height()))){
                maxDistance = curDistanceToTop;
                result = $links.eq(i);
            }**/
            maxDistance > curDistanceToTop && $links.eq(i).offset().top < windowScrollTop + $(window).height() && (maxDistance = curDistanceToTop,result = $links.eq(i))
        });
        return result;
    };
    
    /***使用jQuery创建移动动画*/
    $('div #anchor').css("overflow-y","hidden");  //优化去掉滚动条 shy 2022-1-1
    var move = function (dis) {
        $('div #anchor').animate({  
		  scrollTop:dis 
		}, 'normal');
    }
    
	/**滚轮事件Handler**/
	var wheelHandler = function(e){
	    clearTimeout(timeFun);
	    timeFun = setTimeout(function(){
	        var href = findHref();
	        /**由于id格式问题添加改进**/
	       // $('div ul li div').removeAttr("style");   	   //清空其他选中标识
	        $('div ul li div').attr("class","circle");
	        var id =  href[0].id;
	        id="li #"+id;
	        id=id.replace("-List","");
	        //$(id).prev().css("background-color","black");  //滑动选中标识
	        $(id).prev().attr("class","circle-check") //addClass("circle-check");  优化copy百度gif shy 2022-1-1
	        
	        var curtext = href[0].innerText;
	        var index = 0;
	        $.each(href.prevObject,function(i){
	        if(href.prevObject[i].innerText == curtext)
	        {
	        	index=i;    //根据名称计算导航索引
	        }
	        });
	        
	        var dis = 30*(index-1)+10;  //根据索引和列高 判断 scrollTop 的值
	        move(dis);
	    },600);
	};
    
    /***注册滚轮事件*/
    $('body').on('mousewheel',wheelHandler);
    
    /**点击事件**/
	$('.anchor-point').click(function() {
		var id=$(this).attr("id")
		id="#"+id+"-List"
		$(window).scrollTop($(id).offset().top);
		//改造相应效果
		//$('div ul li div').removeAttr("style");          //清空其他选中标识
		$('div ul li div').attr("class","circle");
		//$(this).prev().css("background-color","black")   //点击选中标识
		$(this).prev().attr("class","circle-check") //addClass("circle-check");  优化copy百度gif shy 2022-1-1
	})
	if (window.parent.resize){
		window.parent.resize();	
	}
	
}

function initCrumbs(){

	var catId=$("#catId").val(),incId=$("#IncId").val(),input=$("#input").val(),inputType=$("#inputType").val();
	var crumbHtml=getCrumbs(catId,incId,input,inputType);
	$("#tableTb").html(crumbHtml);
}

/// 界面数据显示
function initData(){
	
	if ((IncId == "")||(IncId == undefined)){
		$(".side-content").hide();
		$(".no-data").show();
	}
}
//相关药品跳转
function goCrumb(id,hospID){
	goCrumbWiki(id,"","","","",hospID)
	
	}
//相关文献跳转
function openLiter(url){
	if(url !=""){
		window.open(url)
	}
	}