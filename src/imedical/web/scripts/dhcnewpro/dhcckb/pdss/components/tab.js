/*
 * @Author: qunianpeng
 * @Date: 2022-08-11 08:45:58
 * @Descripttion: ֪ʶ�������ҳtab
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

	        // ���Ԫ���е�����
	        this.main.empty();

	        // ��ʼ��tabͷ��
	        this.initTabHead();

	        // ��ʼ��tab��������
	        this.initTabCont();

	        // ��ʼ��tab��tc_nav����
	        // $.stop(false,false).initTabContNav()
	        this.initTabContNav();

	        // tc_nav�����hover
	        this.tabNavHover();

	        // tc_left�����hover
	        this.tabLeftHover();

	        // tab�еĵ���¼���
	        this.tabClick();

	        // tab��header����Ҽ��¼�
	        this.headRightClick();

    	},

    	// ��ʼ��tabͷ��
    	initTabHead:function() {

	        if (this.main.find('.t_header').length >= 0) {
	            this.main.find('.t_header').remove(); // ɾ��t_header
	        }
	        // th_logo����
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

	        // th_nav����
	        var th_nav = '<div class="th_nav" style="display:none"><ul> <li class="th_first"><span class = "iconfont icon-config"></span></li></ul></div>'
	            // <li>����Ⱦҩ��<span class="iconfont icon-cancel"></span></li>
	            // t_header����
	        var t_header = '<div class="t_header clearfix">' + th_logo + th_nav + '</div>';
	        this.main.append(t_header);
	        // this.main.append(t_header);   
   		},

	    // ��ʼ��tab��������
	    initTabCont:function(){

	        if (this.main.find('.t_cont').length > 0) {
	            // ɾ��t_cont
	            this.main.find('.t_cont').remove();
	        }

	        var firstArr = this.data['data'];
	        if (firstArr.length == 0) {
	            this.main.append('<div class="t_cont">�˴���Ҫһ��ͼƬ </div>')
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

	            // ���������nav����
	            var filter = '.t_cont[data-type="' + item.type + '"]';
	            var domTcNav = that.main.find(filter).find('.tc_nav');
	            if (domTcNav.length <= 0) {
	                return;
	            }
	            domTcNav.empty();
	            domTcNav.stop(true); // ����ǰ�Ƚ���ҳ��Ķ�������ֹ��������Ч��
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

	        // ���������left����
	        var domTcLoft = this.main.find('.t_cont[data-type="' + type + '"]').find('.tc_left');
	        if (domTcLoft.length <= 0) {
	            return;
	        }
	        domTcLoft.empty().attr('style', '');
	        domTcLoft.stop(true); // ����ǰ�Ƚ���ҳ��Ķ�������ֹ��������Ч��
	        this.main.find('.t_cont[data-type="' + type + '"]').find('.tc_center').empty().attr('style', '');

	        var secondArr = data.children;
	        if ((secondArr == undefined) || (secondArr.length == 0)) {
		        domTcLoft.append('<div style="margin-top: 400px;">�б�տ���Ҳ~</div>');
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

	        // ��������center����
	        var domTcCenter = this.main.find('.t_cont[data-type="' + type + '"]').find('.tc_center');
	        if (domTcCenter.length <= 0) {
	            return;
	        }
	        domTcCenter.empty();	       
	        var thirdArr = data.children;
	        if ((thirdArr == undefined) || (thirdArr.length == 0)) {
		        	domTcCenter.css('text-align','center');
	                domTcCenter.append('<div style="margin-top: 420px;">���޼�¼��ȥ�����ط�������~</div>');
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
		        
	            // Ĭ�ϻ�ѡ�е�һ�����ж�һ��Ĭ��ѡ�е�����Ҫ�л�
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

		/// li��������
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
			// Ĭ�ϻ�ѡ�е�һ�����ж�һ��Ĭ��ѡ�е�����Ҫ�л�
			var that = arguments[0];
			 // Ĭ�ϻ�ѡ�е�һ�����ж�һ��Ĭ��ѡ�е�����Ҫ�л�
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
	            // left��ѡ�е�li��� ��0��ʼ
	            var index = $(this).index();
	            // nav��ѡ�е�li����� ��0��ʼ
	            var navliIndex = that.selNavli == undefined ? '' : that.selNavli.index();
	            var data = that.data['data'][typeindex]['data'][navliIndex];
	            that.sildeLeftTab(data['children'][index], type);

	        }, function() {})
	    },

	    tabClick:function() {

	        // ʹ��$(docment).on ���Խ����̬���Ԫ�ذ��¼����⡣ͬʱ���ⱻ�ظ��󶨣������¼���δ�������Ҫ�Ƚ��
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

	            // û��activeʱ�����active
	            if (!$(this).hasClass('active')) {
	                // �л�tab�е�t_cont
	                var type = $(this).attr('data-type');
	                // that.main.find('.t_cont').hide();
	                // that.main.find('.t_cont[data-type="' + type + '"]').show();
	                // ����ǰѡ�е�Ԫ���滻ͼƬ                
	                var newactiveimg = '../scripts/dhcnewpro/dhcckb/pdss/images/' + type + 'logo.png';
	                $(this).children('img').attr('src', newactiveimg);
	                // ����ǰѡ�е�Ԫ������active,���滻ͼƬ
	                $(this).addClass('active');

	                // �滻֮ǰactive��ͼƬ
	                var oldactive = $(this).siblings('.active').removeClass('active');
	                var activeimg = oldactive.children('img').attr('src');
	                if (activeimg != undefined) {
	                    oldactive.children('img').attr('src', activeimg.split('.png')[0] + '_gray.png');
	                }

	                // ��̬�����ͷ��λ��
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
	            // ��Ҫadd��ɺ󣬲��ܽ��л������˴�ʹ�ûص�����
	        data.callback();
	    },

	    slideTop:function() {
	        var lastli = this.that.main.find('.t_header .th_nav li:last');
	        // �Ӵ� div
	        var navScreen = lastli.parent().parent();
	        var navScreenWidth = navScreen[0].offsetWidth;
	        var marginLeft = parseInt(lastli.parent().css('marginLeft')); //�Ѿ��ƶ��������
	        marginLeft = marginLeft >= 0 ? marginLeft : -marginLeft;

	        var lastliWidth = lastli[0].offsetWidth;
	        var lastliLeft = lastli[0].offsetLeft + marginLeft;
	        if (lastliWidth + lastliLeft > navScreenWidth) {
	            // �����ƶ����룺 (Ԫ�������+�Ѿ��ƶ��������) + Ԫ������� - �Ӵ���
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
				        
	        // ��ǰ�����li
	        var liWidth = $(this).parent()[0].offsetWidth;
	        // ui�����ƶ�����
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
	        // ͷ���������е�li���ʱ
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
	    //�л�����
	    toggleTab:function(that) {}
	 }; 
	 window.Tab = Tab;
 })(this);



//$(window).on({
//    // contextmenu: function(){//��ֹ�һ�
//    //     return false;
//    // },
//    dragstart: function() { //��ֹ����
//        return false;
//    },
//    selectstart: function() { //���ֽ�ֹ���ѡ��
//        ��������
//        document.selection.empty();������ //  return false;
//    },
//    // copy: function(){//��ֹ�����ı�
//    //     document.selection.empty();
//    // },
//    // beforecopy: function(){
//    //     return false;
//    // },
//    // mouseup: function(){//��ֹ���
//    //     return false
//    // }
//})