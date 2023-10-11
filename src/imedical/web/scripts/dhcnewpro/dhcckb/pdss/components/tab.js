/*
 * @Author: qunianpeng
 * @Date: 2022-08-11 08:45:58
 * @Descripttion: 知识浏览器首页tab
 * @version: V1.0
 * @LastEditors: 
 * @LastEditTime: 2022-08-16 21:54:16
 */
 
 (function(window){
	 
 	var Tab = function(option){
		this.option = option;
        this.main = $(option.id);
        this.id = option.id;
        this.data = option.data;     
        this.init();
 	}
 	
 	Tab.prototype = {
		constructor : Tab,
		init:function(){

	        // 清空元素中的内容
	        this.main.empty();

	        // 初始化tab头部
	        this.initTabHead();

	        // 初始化tab内容区域
	        this.initTabCont();

	        // 初始化tab的tc_nav区域
	        // $.stop(false,false).initTabContNav()
	        this.initTabContNav();

	        // tc_nav区域的hover
	        this.tabNavHover();

	        // tc_left区域的hover
	        this.tabLeftHover();

	        // tab中的点击事件绑定
	        this.tabClick();

	        // tab的header鼠标右键事件
	        this.headRightClick();

    	},

    	// 初始化tab头部
    	initTabHead:function() {

	        if (this.main.find('.t_header').length >= 0) {
	            this.main.find('.t_header').remove(); // 删除t_header
	        }
	        // th_logo部分
	        var headArr = this.data['data'];
	     
	        var headcardArr = [];
	        $.each(headArr, function(index, value) {	      
	            var key = value.type;	       
	            var keylogo = index == 0 ? key + 'logo.png' : key + 'logo_gray.png';
	            // var cardstr = '<div class = "th_card"><img src = "../scripts/dhcnewpro/pdss/images/' + key +'.png"><h4>' + value[key] + '</h4></div > '
	            var carddiv = index == 0 ? '<div class = "th_card active" data-type=' + key + '>' : '<div class = "th_card" data-type=' + key + '>';
	            var cardstr = carddiv + '<img src = "../scripts/dhcnewpro/dhcckb/pdss/images/' + keylogo + '"><h4>' + value.typeName + '</h4></div > '
	            headcardArr.push(cardstr);
	        });
	        var th_logo = '<div class="th_logo clearfix">' + headcardArr.join('') + '</div>';

	        // th_nav部分
	        var th_nav = '<div class="th_nav" style="display:none"><ul> <li class="th_first"><span class = "iconfont icon-config"></span></li></ul></div>'
	            // <li>抗感染药物<span class="iconfont icon-cancel"></span></li>
	            // t_header部分
	        var t_header = '<div class="t_header clearfix">' + th_logo + th_nav + '</div>';
	        this.main.append(t_header);
	        // this.main.append(t_header);   
   		},

	    // 初始化tab内容区域
	    initTabCont:function(){

	        if (this.main.find('.t_cont').length > 0) {
	            // 删除t_cont
	            this.main.find('.t_cont').remove();
	        }

	        var firstArr = this.data['data'];
	        if (firstArr.length == 0) {
	            this.main.append('<div class="t_cont">此处需要一张图片 </div>')
	            return;
	        }

	        var res = this.data['data'];
	        var htmls = ''
	        $.each(res, function(i, item) {
	            var tc_nav = '<div class = "tc_nav"></div>';
	            var tc_left = '<div class = "tc_left"></div>';
	            var tc_center = '<div class = "tc_center"></div>';
	            if (i == 0) {
	                var tc_cont = '<div class="t_cont" data-type=' + item.type + ' data-typename="' + item.typeName + '">' + tc_nav + tc_left + tc_center + '</div>';
	            } else {
	                var tc_cont = '<div style="display:none"; class="t_cont" data-type=' + item.type + ' data-typename="' + item.typeName + '">' + tc_nav + tc_left + tc_center + '</div>';
	            }
	            htmls += tc_cont;
	        });
	 
	        this.main.append(htmls);

	    },

	    initTabContNav:function(){

	        var res = this.data['data'];
	        var that = this;
	        $.each(res, function(i, item) {

	            // 内容区域的nav部分
	            var filter = '.t_cont[data-type="' + item.type + '"]';
	            var domTcNav = that.main.find(filter).find('.tc_nav');
	            if (domTcNav.length <= 0) {
	                return;
	            }
	            domTcNav.empty();
	            domTcNav.stop(true); // 加载前先结束页面的动画，防止出现屏闪效果
	            var firstArr = item['data'];
	            if (firstArr.length == 0) {
	                return;
	            }
	            var tc_navArr = [];
	            $.each(firstArr, function(index, value) {
		            if (value['name']||""){
			        	var $li = '<li data-id=' + value['id'] + '>';
	                	var $li_a = index == 0 ? '<a class="active">' : '<a>';
	                	$li += $li_a + '<span> ' + value['name'] + '</span>' + (index == 0 ? '<img src="..//scripts/dhcnewpro/dhcckb/pdss/images/arrow.png" alt="" />' : '') + '</a>';
	                	$li += '</li>';
	                	tc_navArr.push($li);
			        }
	                
	            })
	            var tc_nav = '<span class="uparrow"></span>';
	            tc_nav += '<ul>' + tc_navArr.join('') + '</ul>';
	            domTcNav.append(tc_nav);
	            that.sildeNavTab(firstArr[0], item.type);

	        })

	    },

	    sildeNavTab:function(data, type) {

	        // 内容区域的left部分
	        var domTcLoft = this.main.find('.t_cont[data-type="' + type + '"]').find('.tc_left');
	        if (domTcLoft.length <= 0) {
	            return;
	        }
	        domTcLoft.empty().attr('style', '');
	        domTcLoft.stop(true); // 加载前先结束页面的动画，防止出现屏闪效果
	        this.main.find('.t_cont[data-type="' + type + '"]').find('.tc_center').empty().attr('style', '');

	        var secondArr = data.children;
	        if ((secondArr == undefined) || (secondArr.length == 0)) {
		        domTcLoft.append('<div style="margin-top: 400px;">列表空空如也~</div>');
		        domTcLoft.css('text-align','center');
	            if (domTcLoft.attr("style").indexOf("background") == -1) {
	                domTcLoft.css('background', 'url(..//scripts/dhcnewpro/dhcckb/pdss/images/rownull.png) no-repeat center');
	            }
	            return;
	        } else {
	            domTcLoft.attr('style', '');
	        }

	        var tc_left = '';
	        var tc_leftArr = [];
	        $.each(secondArr, function(index, value) {
	            var $li = '<li data-id=' + value['id'] + '>';
	            var $li_a = index == 0 ? '<a class = "active">' : '<a>';
	            $li += $li_a + '<span>' + value['name'] + '</span>' + (index == 0 ? '<img src="..//scripts/dhcnewpro/dhcckb/pdss/images/arrow.png" alt="" />' : '') + '</a>';
	            $li += '</li>';
	            tc_leftArr.push($li);
	        })
	        tc_left += '<ul>' + tc_leftArr.join('') + '</ul>';
	        domTcLoft.append(tc_left);

	        this.sildeLeftTab(secondArr[0], type);

	    },

	    sildeLeftTab:function(data, type) {

	        // 内容区域center部分
	        var domTcCenter = this.main.find('.t_cont[data-type="' + type + '"]').find('.tc_center');
	        if (domTcCenter.length <= 0) {
	            return;
	        }
	        domTcCenter.empty();	       
	        var thirdArr = data.children;
	        if ((thirdArr == undefined) || (thirdArr.length == 0)) {
		        	domTcCenter.css('text-align','center');
	                domTcCenter.append('<div style="margin-top: 420px;">暂无记录，去其他地方看看吧~</div>');
	            if (domTcCenter.attr("style").indexOf("background") == -1) {
	                domTcCenter.css('background', 'url(..//scripts/dhcnewpro/dhcckb/pdss/images/notdata.png) no-repeat center');	                
	            }
	            return;
	        } else {
	            domTcCenter.attr('style', '');
	        }

	        var tc_centerArr = [];
	        $.each(thirdArr, function(index, value) {
	            var $div = '<div>';
	            // $div += ' <h3>' + value['name'] + '</h3>';
	            $div += ' <div class="centertxt"><a data-id=' + value['id'] + '><span>' + value['name'] + '</span></a></div>';
	            var fourArr = value.children;
	            if ((fourArr != undefined) && (fourArr.length != 0)) {
	                var rowgroup = '<div class="rowgroup">';
	                $.each(fourArr, function(index, value) {
	                    rowgroup += ' <dl class="clearfix"><dt><a><span data-id=' + value['id'] + '>' + value['name'] + '</span></a></dt>';
	                    var fiveArr = value.children;
	                    if ((fiveArr != undefined) && (fiveArr.length != 0)) {
	                        rowgroup += ' <dd>';
	                        var ddArr = [];
	                        $.each(fiveArr, function(index, value) {
	                            // ddArr.push('<span><i></i><a href="#">' + value["name"] + '</a></span>');
	                            ddArr.push('<a><i></i><span data-id=' + value['id'] + '>' + value["name"] + '</span></a>');
	                        })
	                        rowgroup += ddArr.join('') + '</dd>';
	                    }
	                    rowgroup += '</dl>';
	                })
	                rowgroup += '</div>';
	                $div += rowgroup;
	            }
	            $div += '</div>';
	            tc_centerArr.push($div);
	        })
	        var tc_center = tc_centerArr.join('');

	        domTcCenter.append(tc_center);

	    },

	    tabNavHover:function() {

	        var navlis = this.main.find('.t_cont .tc_nav li');
	        this.navlis = navlis;
	        if (navlis.length == 0) {
	            return;
	        }
	        this.selNavli = $(navlis[0]);
	        var that = this;
	        var e = ""
	        navlis.stop().hover(this.liDebounce(that.changeTest,10,that),function() {})
	        //navlis.stop().mouseenter(this.liDebounce(that.changeTest,10,that))
	       /*  navlis.hover(function() {
		        
	            // 默认会选中第一个，判断一到默认选中的则不需要切换
	            if ($(this).find('a').hasClass('active')) {
	                return;
	            }
	            $(this).siblings().find('a').removeClass('active');
	            $(this).siblings().find('a').find('img').remove();
	            $(this).find('a').addClass('active');
	            $(this).find('a').append('<img src="..//scripts/dhcnewpro/dhcckb/pdss/images/arrow.png" alt="" />');

	            that.selNavli = $(this);
	            var type = $(this).parents('.t_cont').attr('data-type');
	            var typeindex = type == "xy" ? 0 : (type == 'zcy' ? 1 : 2);
	            var index = $(this).index();
	            var data = that.data['data'][typeindex]['data'][index];
	            that.sildeNavTab(data, type);
	            that.tabLeftHover();
	        }, function() {}) */

	    },

		/// li搜索防抖
		liDebounce:function (fn, delay,that) {
			var delays=delay||10;
		    var timer;
		    return function(){
		        var th=this;
		        var args=arguments;
		        args[0] = that;
		        if (timer) {
		            clearTimeout(timer);
		        }
		        timer=setTimeout(function () {
		                timer=null;
		                fn.apply(th,args);
		        }, delays);
		    };
		},
		changeTest:function(){
			// 默认会选中第一个，判断一到默认选中的则不需要切换
			var that = arguments[0];
			 // 默认会选中第一个，判断一到默认选中的则不需要切换
            if ($(this).find('a').hasClass('active')) {
                return;
            }
            $(this).siblings().find('a').removeClass('active');
            $(this).siblings().find('a').find('img').remove();
            $(this).find('a').addClass('active');
            $(this).find('a').append('<img src="..//scripts/dhcnewpro/dhcckb/pdss/images/arrow.png" alt="" />');

            that.selNavli = $(this);
            var type = $(this).parents('.t_cont').attr('data-type');
            var typeindex = type == "xy" ? 0 : (type == 'zcy' ? 1 : 2);
            var index = $(this).index();
            var data = that.data['data'][typeindex]['data'][index];
            that.sildeNavTab(data, type);
            that.tabLeftHover();
		},

	    tabLeftHover:function() {
	        var navlis = this.main.find('.t_cont .tc_left li');
	        this.leftlis = navlis;
	        if (navlis.length == 0) {
	            return;
	        }
	        var that = this;
	        navlis.hover(function() {
	            if ($(this).find('a').hasClass('active')) {
	                return;
	            }
	            $(this).siblings().find('a').removeClass('active');
	            $(this).siblings().find('a').find('img').remove();
	            $(this).find('a').addClass('active');
	            $(this).find('a').append('<img src="..//scripts/dhcnewpro/dhcckb/pdss/images/arrow.png" alt="" />');

	            var type = $(this).parents('.t_cont').attr('data-type');
	            var typeindex = type == "xy" ? 0 : (type == 'zcy' ? 1 : 2);
	            // left下选中的li序号 从0开始
	            var index = $(this).index();
	            // nav下选中的li的序号 从0开始
	            var navliIndex = that.selNavli == undefined ? '' : that.selNavli.index();
	            var data = that.data['data'][typeindex]['data'][navliIndex];
	            that.sildeLeftTab(data['children'][index], type);

	        }, function() {})
	    },

	    tabClick:function() {

	        // 使用$(docment).on 可以解决动态添加元素绑定事件问题。同时避免被重复绑定，导致事件多次触发，需要先解绑
	        var data = {
	            that: this,
	            callback: this.slideTop
	        }
	        var selnavlis = this.navlis.selector;
	        var selleftlis = this.leftlis.selector;
	        var selcentertxt = this.main.find('.tc_center .centertxt a').selector;
	        var selrowgroup = this.main.find('.tc_center .rowgroup span').selector;
	        var selheadnavli = this.main.find('.t_header .th_nav li').selector;
	        var selheadnavlispan = this.main.find('.t_header .th_nav li span').selector;

	        $(document).off('click', selnavlis).on('click', selnavlis, data, this.addTab);
	        $(document).off('click', selleftlis).on('click', selleftlis, data, this.addTab);
	        $(document).off('click', selcentertxt).on('click', selcentertxt, data, this.addTab);
	        $(document).off('click', selrowgroup).on('click', selrowgroup, data, this.addTab);
	        $(document).off('click', selheadnavli).on('click', selheadnavli, data, this.loadDrug);
	        $(document).off('click', selheadnavlispan).on('click', selheadnavlispan, this, this.closeTab);

	        var logocard = '.t_header .th_logo .th_card';
	        //var logocard =  this.main.find('.t_header .th_logo .th_card').selector;
	        $(document).off('mouseover', logocard).on('mouseover', logocard, this, function(event) {

	            var that = event.data;
	            $('.drugcont').hide();
	            $('.details').hide();	 
	            $(".drugtips").hide();            
	            var type = $(this).attr('data-type');
	            that.main.find('.t_cont').hide();
	            that.main.find('.t_cont[data-type="' + type + '"]').show();

	            // 没有active时，添加active
	            if (!$(this).hasClass('active')) {
	                // 切换tab中的t_cont
	                var type = $(this).attr('data-type');
	                // that.main.find('.t_cont').hide();
	                // that.main.find('.t_cont[data-type="' + type + '"]').show();
	                // 给当前选中的元素替换图片                
	                var newactiveimg = '../scripts/dhcnewpro/dhcckb/pdss/images/' + type + 'logo.png';
	                $(this).children('img').attr('src', newactiveimg);
	                // 给当前选中的元素增加active,并替换图片
	                $(this).addClass('active');

	                // 替换之前active的图片
	                var oldactive = $(this).siblings('.active').removeClass('active');
	                var activeimg = oldactive.children('img').attr('src');
	                if (activeimg != undefined) {
	                    oldactive.children('img').attr('src', activeimg.split('.png')[0] + '_gray.png');
	                }

	                // 动态计算箭头的位置
	                var parentLeft = parseInt($(this).parent().css('marginLeft'));
	                var curDomWidth = $(this)[0].offsetWidth;
	                var curIndex = $(this).index();
	                var arrowLeft = 0;
	                switch (curIndex) {
	                    case 0:
	                        arrowLeft = parentLeft + Math.ceil((curDomWidth / 2)) - 9;
	                        break;

	                    case 1:
	                        var cardRight = parseInt(that.main.find('.th_card').eq(0).css('marginRight'));
	                        var firstCardWidth = parseInt(that.main.find('.th_card').eq(0)[0].offsetWidth);
	                        arrowLeft = parentLeft + Math.ceil((curDomWidth / 2)) + firstCardWidth + curIndex * cardRight - 9;

	                        break;

	                    case 2:
	                        var cardRight = parseInt(that.main.find('.th_card').eq(0).css('marginRight'));
	                        var firstCardWidth = parseInt(that.main.find('.th_card').eq(0)[0].offsetWidth);
	                        var secordCardWidth = parseInt(that.main.find('.th_card').eq(1)[0].offsetWidth);

	                        arrowLeft = parentLeft + Math.ceil((curDomWidth / 2)) + firstCardWidth + secordCardWidth + curIndex * cardRight - 9;

	                        break;
	                }
	                if (arrowLeft > 0) {
	                    that.main.find('.t_cont .tc_nav .uparrow').css('left', arrowLeft + 'px');
	                }


	            }

	        }, function() {});


	        // var selthnavli = selthnav.selector + 'li';
	        // $(document).off('click', selthnavli).on('click',selthnavli,this, this.loadDrug);
	        // this.navlis.on("click", '', this, this.addTab);
	        // this.leftlis.on("click", '', this, this.addTab);
	        // this.main.find('.tc_center').find('.centertxt').on("click", '', this, this.addTab);
	        // this.main.find('.tc_center').find('.rowgroup').find('a').on("click", '', this, this.addTab);
	        // this.navlis.live("click",this.addTab)        

	    },

	    addTab:function(event) {

	        if (!$('.drugcont').is(":visible")) {
	            $('.drugcont').show();
	            $(this.main).hide();
	        }

	        var data = event.data;
	        var that = data.that;
	        var selthnav = that.main.find('.t_header .th_nav');
	        if (selthnav.css("display") == 'none') {
	            selthnav.show();
	        }

	        var title = $(this).text();
	        var id = $(this).attr('data-id');
	        var cattype = $(this).parents(".t_cont").attr("data-type")||"";

	        if (selthnav.find('li[data-id="' + id + '"]').length <= 0) {
	            var $li = '<li data-id=' + id + ' data-type='+cattype+ '>' + title + '<span class="iconfont icon-cancel"></span></li>';
	            selthnav.find('ul').append($li);
	        }

	        that.loadDrug({ data: { that: that,clickId:id,cattype:cattype } })
	            // 需要add完成后，才能进行滑动，此处使用回调函数
	        data.callback();
	    },

	    slideTop:function() {
	        var lastli = this.that.main.find('.t_header .th_nav li:last');
	        // 视窗 div
	        var navScreen = lastli.parent().parent();
	        var navScreenWidth = navScreen[0].offsetWidth;
	        var marginLeft = parseInt(lastli.parent().css('marginLeft')); //已经移动的左距离
	        marginLeft = marginLeft >= 0 ? marginLeft : -marginLeft;

	        var lastliWidth = lastli[0].offsetWidth;
	        var lastliLeft = lastli[0].offsetLeft + marginLeft;
	        if (lastliWidth + lastliLeft > navScreenWidth) {
	            // 向左移动距离： (元素左距离+已经移动的左距离) + 元素自身宽 - 视窗宽
	            var marginLeft = -(lastliLeft + lastliWidth - navScreenWidth);
	            lastli.parent().css('margin-left', marginLeft + 'px');

	        }
	    },

	    closeTab:function(event) {
	        event.stopPropagation();
	        // preventDefault
	        
	        if ($(this).attr("class").indexOf('iconfont icon-config') == 0){
		        return;
			}
				        
	        // 当前点击的li
	        var liWidth = $(this).parent()[0].offsetWidth;
	        // ui的左移动距离
	        var marginLeft = parseInt($(this).parent().parent().css('marginLeft'));
	        marginLeft = marginLeft >= 0 ? marginLeft : -marginLeft;
	        if (marginLeft > 0) {
	            marginLeft = marginLeft - liWidth >= 0 ? marginLeft - liWidth : 0;
	            $(this).parent().parent().css('margin-left', -marginLeft + 'px');

	        }
	        $(this).parent().remove();

	    },

	    headRightClick:function(event) {
	        // event.preventDefault()
	        var headli = this.main.find('.tab .t_header .th_nav li');
	        $(document).off('mousedown', headli).on('mousedown', headli, function(event) {
	            if (event.which == 3) {
	               // alert(12)
	            }
	        });
	        // if (headli.length > 0) {
	        //     headli.mousedown(function () { 
	        //         alert(1)
	        //     })

	        // }
	    },
	    loadDrug:function(event) {
	        var data = event.data;
	        var that = data.that;
	        var clickId = data.clickId||"";
	        var cattype = data.cattype||"";
	        // that.main.find('.drugbox').show();
	        
	        var litype = "",liid = ""
	        // 头部导航栏中的li点击时
	        if (this !=  that){
		        if (($(this).attr("class")||""!="")&&($(this).attr("class").indexOf('th_first') == 0)){
			        return;
			     }       
				
		        liid = $(this).attr('data-id')||"";
		        clickId = liid == "" ? clickId : liid;
		    	litype = $(this).attr('data-type')||"";
		    	cattype = litype == "" ? cattype : litype;
		    }
	        
	        that.main.find('.t_cont').hide();
	        $('.drugcont').show();	
	        $('.drugcont .drugbox').empty();
	        var option = {params:{type:"cat",input:clickId,userInfo:that.option.userinfo,cattype:cattype}}	        
	        that.option.goPage(1,option);
	       	//that.option.loadDrugList("cat",clickId,that.option.userinfo);        
	        
	    },
	    //切换功能
	    toggleTab:function(that) {}
	 }; 
	 window.Tab = Tab;
 })(this);



//$(window).on({
//    // contextmenu: function(){//禁止右击
//    //     return false;
//    // },
//    dragstart: function() { //禁止拖拉
//        return false;
//    },
//    selectstart: function() { //文字禁止鼠标选中
//        　　　　
//        document.selection.empty();　　　 //  return false;
//    },
//    // copy: function(){//禁止复制文本
//    //     document.selection.empty();
//    // },
//    // beforecopy: function(){
//    //     return false;
//    // },
//    // mouseup: function(){//禁止点击
//    //     return false
//    // }
//})