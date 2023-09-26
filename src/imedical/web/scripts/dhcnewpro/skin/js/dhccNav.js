;(function ($) {
	var method = {
		initNavDom : function($this,options){
			var _this1 = $this;
			if(!_this1.is('.dhcc-nav'))
				_this1.addClass('dhcc-nav');
			
			$('.dhcc-nav>li>ul').each(function(){
				var _this2 = $(this);
				if(!_this2.is('.dhcc-nav-two'))
					_this2.addClass('dhcc-nav-two');
				
				var _this3 = _this2.find('ul');
				if(_this3.length)
					if(!_this3.is('.dhcc-nav-three'))
						_this3.addClass('dhcc-nav-three');
			})	
		},
		initNavCss : function($this,options){
			$this.css("width",options.width);
			if(options.height!="100%"){
				$this.css("height",options.height);
			}
			$this.find("ul").each(function(){
				if($this.width()>100){
					$(this).css("width",options.width=="100%"?$this.width():options.width);
				}
			})
		},
		initNavDate : function($this,options){
			if(options.url){
				dhccNavCuid.getData(options);
			}
			
		},
		initNavBindMethod : function($this,options){

			$this.find("li").on('click',function(){
				options.onClick($(this),$(this).children("a").text());
				return false;        //防止冒泡
			})
		},
		initOp : function(){
			var $one_nav =  $('.dhcc-nav');
			var $two_nav =$('.dhcc-nav-three');
			var $three_nav =$('.dhcc-nav-two') 
			var _this1=null;                            ///1级菜单展开指针
			$('.dhcc-nav>li').hover(function(){
			_this1=$(this);                         ///2级菜单展开指针
			_this1.find('.dhcc-nav-two').show();
			var _this2=null;
			_this1.find('.dhcc-nav-two').find('li').hover(function(){
			    _this2=$(this);
			    _this2.find('.dhcc-nav-three').show();
			    _this2.find('.dhcc-nav-three').hover(function(){
			        $(this).show();
			    },function(){
			        $(this).hide();
			    });
			},function(){
			    _this2.find('.dhcc-nav-three').hide();
			});
			},function(){
				_this1.find('.dhcc-nav-two').hide();
			});
			
			$('.dhcc-nav').find("li").on('click',function(){
				$two_nav.hide();
				$three_nav.hide();
				return false;        //防止冒泡
			})
		}
	}	
	
	var dhccNavCuid = {
		addOneItm : function(itm){
			var itmHtm = '<li title='+itm.value+'><a href="#" data-id='+itm.id+'><span class="img-nav-main"></span><span><strong>'+itm.value.substring(0,10)+'</strong></span></a></li>';
			$(".dhcc-nav").append(itmHtm);
		},
		getData : function(options){
			$.ajax({
				type: "POST",
				url:options.url,
				data:options.data,
				async: false,
				dataType: "json", 
				success: function(data){
					$.each(data, function(idx, obj) {
	   					dhccNavCuid.addOneItm(obj);
					});	
				}
			});	
		}	
	}
	
	var defaults = {
		"width":"100%",
		"height":"100%",
		url:"",
		data:"",
		onClick:function($ele,text){}
	}
	
	$.fn.dhccNav = function (options) {
		
		var _element= this;

		var settings = $.extend({},defaults,options);

		return this.each(function () {
			var $this = $(this);
			method.initNavDom($this,settings);   ///设置基本的Nav的class
			method.initNavCss($this,settings);   ///设置Nav基本格式
			method.initNavDate($this,settings);
			method.initNavBindMethod($this,settings);   ///设置绑定的方法
			method.initOp();                           ///具体导航实现的方法
		});
	};
	
})(jQuery);

/**************************************************/

window.onload = function(){
    $(".dhcc-nav-panel-title").on("click",function(){
        if($(this).parent(".dhcc-nav-panel").hasClass("dhcc-nav-panel-open")){
            $(".updateStyle").attr("href","../scripts/dhcnewpro/skin/css/closeNav.css");
        }else{
            $(".updateStyle").attr("href","../scripts/dhcnewpro/skin/css/openNav.css");
        }
        $(this).parent(".dhcc-nav-panel").toggleClass("dhcc-nav-panel-open");
    })
	   
	var UserList=LgUserID+"^"+LgCtLocID+"^"+LgGroupID;
		
    $("#dhcc-nav").dhccNav({
	    url: 'dhcadv.repaction.csp',
		data: "action=GetRepTypeList&UserList="+UserList,
        onClick:function($ele,text){
        	//alert(text+":"+$ele.children("a").attr("data-id"));
        	InterfaceJump($ele.children("a").attr("data-id"),text); // 调用跳转页面方法 2017-09-06 congyue
        }
   });
}
