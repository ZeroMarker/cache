/*
 * @Author: qunianpeng
 * @Date: 2022-08-11 16:28:44
 * @Descripttion: 说明
 * @version: V1.0
 * @LastEditors: qnp
 * @LastEditTime: 2022-08-18 12:36:31
 */

var searchDrugId = ""; // 检索框中选中的具体的药品id
$(function() {

    // 设置屏幕缩放比例(win10会默认放放大页面)
    setRatio();
	
	// 初始化检索框 $('#editable-select').on会导致插件被多次创建,因此on需要放在初始化的位置
	$('#editable-select').editableSelect({}).on('select.editable-select', function (e,dom) {
		searchDrugId = dom.attr("data-id");
    	$('.searchbtn').click();    
	});	 

    // 初始化tab
    initTab('#tab');    
   
    // 初始化按钮绑定事件
	initButton();
	
	//return false禁用鼠标滚动页面
	/* window.onmousewheel=function(){
	    return false
	} */
	/* //return true启用鼠标滚动页面
	window.onmousewheel=function(){
	    return true
	} */
	
})
/**
 * @description:  设置屏幕缩放比例(用于防止win10默认放大)
 * @param {*} 
 * @return {*}
 */
function setRatio(){
    
    var defaultRatio = 1;//默认缩放比
    var ratio=0;
    var screen=window.screen;
    var ua=navigator.userAgent.toLowerCase();
 
    if(window.devicePixelRatio !== undefined)
    {
        ratio=window.devicePixelRatio;    
    }
    else if(~ua.indexOf('msie'))
    {
        if(screen.deviceXDPI && screen.logicalXDPI)
        {
            ratio=screen.deviceXDPI/screen.logicalXDPI;        
        }
    
    }
    else if(window.outerWidth !== undefined && window.innerWidth !== undefined)
    {
        ratio=window.outerWidth/window.innerWidth;
    }
 
    if(ratio > 1)
    {
        
        var setZoom = defaultRatio/window.devicePixelRatio; //默认zoom
        document.body.style.zoom = setZoom.toFixed(6);
        //var a = setZoom.toFixed(6);

    }
    // return ratio;
}

/**
 * @Author: qunianpeng
 * @Date: 2022-08-11 20:52:46
 * @Description: 初始化tab
 */
function initTab(id) {

    var tabData = initTabData();
    var option = {
        id: id,
        data: tabData,
        goPage:goPage,
        userinfo:LoginInfo
    }
    var tab = new Tab(option);
}

/**
 * @Author: qunianpeng
 * @Date: 2022-08-11 20:55:43
 * @Description: 初始化tab数据
 */
function initTabData(params) {

	var tabData = ""
	runClassMethod("web.DHCCKBPdssIndex","queryDrugCat",{},function(res){
		tabData = res;
	},'json',false);
						
	return tabData;
 
}

/**
 * @description: 分页跳转功能
 * @param {*} pageIndex 跳转页数
 * @param {*} total 总数
 * @return {*}
 */
function goPage(pageIndex,option) {

   /* if (typeof option == "string"){
	   option = eval('(' + option + ')');
   } */
   jsPage('divpage',12, pageIndex, 'goPage',option,showDrugBox);

}

/**
 * @description: 药品列表数据加载
 * @param {*} drugData 药品数据
 * @return {*}
 */
function showDrugBox(drugData,option){
	if ((JSON.stringify(drugData) === "{}")||(drugData.total <= 0)){
		notDataTips();		
		return;
	}
	$(".t_cont").hide();
	//$('.drugcont').show();
	$('.drugcont .notdatatips').remove();
	$('.drugcont .drugbox').empty();
    var drubbox = createDrugBox(drugData['data']);
    $('.drugcont .drugbox').append(drubbox);
    
    showControl('list');
    createDrugTips(option.params.input,option);

}

/**
 * @description: 没有药品数据的提示
 * @param {*} 
 * @return {*}
 */
function notDataTips(){
	
	$(".t_cont").hide();
	$('.drugcont').show();
	$('.drugcont .notdatatips').remove();
	$('.drugcont .drugbox').empty();
	$('.drugcont .divpage').empty();
	$('.drugcont').append('<div class="notdatatips"><img src="../scripts/dhcnewpro/dhcckb/pdss/images/notdata.png"><h3>暂无记录，去其他地方看看吧~</h3></div>');
   
}

/**
 * @description: 动态生成药品卡片(使用了模板字符串，m的js会显示报错，但可以使用)
 * @param {*} data 药品数据数组arr
 * @return {*}
 */
function createDrugBox(dataArr) {
	if ((dataArr == undefined)||(dataArr == "")||(dataArr.length == 0)){
		return;
	}
    var str = `<li>
        <div class="boxtop">
            <em>{{index}}</em>
            <i></i>
            <h4 class="nowrap">{{genername}}</h4>
            <h5 class="nowrap">{{name}}</h5>
        </div>
        <div class="boxbd" data-id="{{id}}">
            <h4 class="nowrap"><span>规格:</span><span>{{spec}}</span></h4>
            <h4 class="nowrap"><span>剂型:</span><span>{{form}}</span></h4>
            <h4 class="nowrap"><span>成分:</span><span>{{ingr}}</span></h4>
            <h4 class="nowrap"><span>厂家:</span><span>{{manf}}</span></h4>
            <h4 class="nowrap"><span>批准文号:</span><span>{{approvalnum}}</span></h4>
            <div class="foot">{{useflaghtml}}<button data-id="{{id}}" onclick="goinstrucion(this)">详情</button></div>       
        </div>
    </li>`;

    var useflaghtml = '<div class="useflag"><i></i><span>本院在用</span></div>';
    var drugboxArr = [];
    dataArr.forEach(function(item, index) {
        //item.index = index + 1;
        item.useflaghtml = item.useflag == 'Y' ? useflaghtml : '';
        var reghtml = str;
        for (var key in item) {
            var reg = new RegExp('{{' + key + '}}', 'g');
            reghtml = reghtml.replace(reg, item[key] || "")
        }
        drugboxArr.push(reghtml);
    });

    return drugboxArr.length > 0 ? '<ul class="clearfix">' + drugboxArr.join('') + '</ul>' : '';

}

/**
 * @description:  说明书详情加载事件
 * @param {*} event:当前点击的event
 * @return {*}
 */
function goinstrucion(event) {

    var drugId = $(event).attr('data-id');
    if ((drugId || "") == "") {
        return;
    }
	
	var drugData = ""
	runClassMethod("web.DHCCKBPdssIndex","queryDrugDetail",{"drugId":drugId,"userInfo":LoginInfo},function(res){
		drugData = res;
	},'json',false);
	
    //  动态创建药品明细
    createDrugDetails(drugData.data);  
	initDrugStep();
}

/**
 * @description:  动态创建药品说明书详情内容
 * @param {*} drugData
 * @return {*}
 */
function createDrugDetails(drugData) {
    
    if (drugData == '') {
        return;
    }    
    var details = new DrugDetail(drugData);   
    var html = details.init(); 
    $('.details').empty();   
    $('.details').append(html);
    //$('.details').show();
    //$('.drugtips').show();
    //$('#tab .t_cont').hide();
    //$('.drugcont').hide();    
    showControl('detail');
}


/**
 * @description:  按钮绑定初始化方法
 * @param {*} 
 * @return {*}
 */
function initButton(){
	
	/// 检索框发生改变
	$('#editable-select').bind('input propertychange',iputDebounce(searchKeyWord,500));
	/*
	 function() {

   		if(timeout){
	    	clearTimeout(timeout)
	  	}
		timeout = setTimeout('searchKeyWord('+this.value+')', 500) // 500ms后执行 search 函数
	
		//searchKeyWord(this.value);
	}*/
	// 检索框失去焦点
	/*$("#keyword").blur(function() {
		$("#searchlist").empty();
		$("#searchlist").hide();		
	});*/
	
	// 搜索按钮点击事件
	$('.searchbtn').bind('click', function() {
		var input = $('#editable-select').val().trim();
		var type = $(".searchnav li a[class='active']").parent().attr("data-type");	
		type = (type == "")||(type==undefined)?"drug":type;		
		$('#editable-select').editableSelect('hide');
		if ((type == "edu")||(type == "book")||(type == "check")){
			createEduInfo(searchDrugId);
		}
		else{
			var option= {params:{type:type,input:input,userInfo:LoginInfo}}	 
			goPage(1,option);
		}
				
	});
	
	// 搜索框上方的tab点击事件
	$(".searchnav li").on('click',searchNavClick);
	
	 $(document).off('click', '.anchor_list li').on('click', '.anchor_list li',function(){
		$(this).siblings().removeClass('active');
		$(this).addClass('active');
		$(this).siblings().children('.circle_check').removeClass('circle_check').addClass('circle');
		$(this).children('.circle').removeClass('circle').addClass('circle_check');
		$(this).siblings().children('.anchor_txt_check').removeClass('anchor_txt_check').addClass('anchor_txt');
		$(this).children('.anchor_txt').removeClass('anchor_txt').addClass('anchor_txt_check');
	
	});	
	
	// 返回头部事件
	$(".totop").on('click',function(){
		//window.scrollTo(0,0);
		// 由快到慢  （每次开启定时器都重新计算速度）
        timer = setInterval( function(){
            //获取滚动条的滚动高度
            var scrollTop = document.documentElement.scrollTop || document.body.scrollTop;
            //用于设置速度差，产生缓动的效果
            var speed = Math.floor(-scrollTop / 8);
            document.documentElement.scrollTop = document.body.scrollTop = scrollTop + speed;//用纯数字赋值
            isTop =true;  //用于阻止滚动事件清除定时器
            if(scrollTop == 0){
                clearInterval(timer);
            }
        },20 );
	});
	
	window.onscroll = function () {
        //让谁进行滚动 body html（有的浏览器获取不到body或html），所以做一个兼容的方式
        //scrollTop据顶部的滑动的距离
        var res = document.body.scrollTop || document.documentElement.scrollTop;
        if (res >= 300) {//当大于400px，按钮出现
           $('.totop').show();
        } else {
	       $('.totop').hide();
        }

    }

}

/// input搜索防抖
function iputDebounce(fn, delay) {
	var delays=delay||500;
    var timer;
    return function(){
        var th=this;
        var args=arguments;
        if (timer) {
            clearTimeout(timer);
        }
        timer=setTimeout(function () {
                timer=null;
                fn.apply(th,args);
        }, delays);
    };
}

/**
 * @description:  检索框查询事件
 * @param {*} val:录入的内容
 * @return {*}
 */
function searchKeyWord(e){
	
	var type = $(".searchnav li a[class='active']").parent().attr("data-type");	
	type = (type == "")||(type==undefined)?"drug":type;
	if ((type != "drug")&&((type != "edu"))){
		return;
	}	
	//var val = e.target.value||e;
	var val = e.target.value||"";		
	if (val == ""){
		$(".es-list").empty();
		$('#editable-select').editableSelect('clear');	
		return;
	}
	if (val.trim() == ""){
		$(".es-list").empty();
		$('#editable-select').editableSelect('clear');	
		return;
	}
	runClassMethod("web.DHCCKBPdssIndex","SearchKeyList",{"input":val},function(res){	
	 	if ((res == "")||(res.length == 0)) {
		 	return;
		 }
	 	keyArr = res;
	 	var keyArr = [];		 	
	 	res.forEach(function (item,index) {
		 	var tmpli = ""
		 	if ((val!="")&&(item.name.indexOf(val)!= -1)){
			 	tmpli = '<li class="es-visible" data-key="'+item.name+'" data-id="'+item.id+'">'+item.name.replace(val,'<span style="color:#018EE8">'+val+'</span>')+'</li>';			 
			}else{
				tmpli = '<li class="es-visible" data-key="'+item.name+'" data-id="'+item.id+'">'+item.name+'</li>';
			}
	
            keyArr.push(tmpli);   
            
        }); 
        $(".es-list").empty().append(keyArr.join(''));
        $(".es-list").show();
        $(".es-list li").show();  
	
	},'json',false)
}

/**
 * @description:  搜索框上方的tab点击事件
 * @param {*}
 * @return {*}
 */
function searchNavClick(){
	initPageStatus();
	var sel = $(".searchnav li a[class='active']").text();	
	if ($(this).text() != sel){			
		$(this).siblings().find('a').removeClass('active');
		$(this).find('a').addClass('active');
		$('#editable-select').val("");		
		$('#editable-select').editableSelect('clear');		
	}	
	
	var type = $(this).attr("data-type");	
	if ((type == "drug")||(type == "edu")){
		$('.es-input').css('background','url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA8AAAALCAYAAACgR9dcAAAAAXNSR0IArs4c6QAAARFJREFUKFNjZGBgYAic97juP8N/R0YGBkYQnxD4/5/hPjc7dz5j4MInav///L1JSAO6PBMjQwZjw/7/LBfvP7r8/z+DBrEGMDIyfmdiZNQHOzNw0SOd/78ZTjIw/OcixgBGJsbk9Yly8+B+DJz7MO4/A8NCwpoZF2xIlksEqUMJoMC5D2f9Z2BIxWkAI+NlVh5G89Vhst8xNCfM/8/x4f+j4wz/GQywGPCZkYXZZH28zC2YHEbUBCx4pMz49//Z/wwM/MgGMDIxhK1PlF+NIobNiUFzHwf+Y/i3Dm4DI8Ok9Uny+ehqcSaKwLmPWv8z/K9iZGQ8KKon6zrLhPE30ZpBCoMWv5bUixF52cDI+A+bCwGVoVI44tXl+gAAAABJRU5ErkJggg==) right center no-repeat');
		//$('#editable-select').bind('input propertychange',iputDebounce(searchKeyWord,500));
	}else{
		$('#editable-select').editableSelect('hide');	
		$('.es-input').css('background','none');
		//$('.es-list').hide();
		//$('#editable-select').unbind();
	}
	//if ((type == "indic")||(type == "contr")||(type == "check")||(type == "book"))
	
}

/**
 * @description:  页面的显示控制
 * @param {*}
 * @return {*}
 */
function showControl(flag){
	
	if ((flag == "cat")||((flag == ""))||((flag == undefined))){	// 显示五级分类页面
		$("#tab").show();
		$(".drugtips").hide();
		$(".details").hide();
		$(".drugcont").hide();		
	}
	else if (flag == "list"){
		$("#tab .t_cont").hide();
		$(".drugtips").show();
		$(".details").hide();
		$(".drugcont").show();	
	}
	else if (flag == "detail"){
		$("#tab .t_cont").hide();
		$(".drugtips").show();
		$(".details").show();
		$(".drugcont").hide();	
	}    
	
	return;
}


/**
 * @description: 
 * @param {*}
 * @return {*}
 */
function createDrugTips(catId,option){
	
	$('.drugtips .tipstext').empty();
  	option.id = catId;
  /* 	var option = {
	  	id:"22"
	  	} */
  	var input = 1
	var dataArr = [];
	runClassMethod("web.DHCCKKBIndex","GetCrumb",{"queryCat":catId},function(res){		
		dataArr = res;	
		if((dataArr == "") || (dataArr.length == 0)){
			return;
		}
		var htmlstr = ""
		var len = dataArr.length-1;
		for (var i=len; i>=0; i--){
			if(i<len){
				htmlstr += "<span  style='padding:0px 5px 0px 5px;color: #017bce'>/</span>";	
			}
			htmlstr += "<a href='javascript:void(0);' ";
			if(dataArr[i].type=="cat"){
				htmlstr += "onclick='goPage(\""+input+"\",\""+JSON.stringify(option).replace(/\"/g, "'")+"\")' "
			}else if(data[i].type=="input"){				
				htmlstr += "onclick='goCrumbList(\""+input+"\",\""+inputType+"\")' "
			}else{
				htmlstr += "onclick='goPage("+dataArr[i].id+")' "
			}
			htmlstr += " >" +dataArr[i].desc+"</a>";
		}
		$('.drugtips .tipstext').append(htmlstr);
	},'json',false);
	
}

/**
 * @description: 创建用药教育信息
 * @param {*}
 * @return {*}
 */
function createEduInfo(drugId){

	$(".tab").hide();
	$(".drugtips").hide();
	$(".details").hide();
	$(".drugcont").hide();
	$('#edu').show();
	$('#edu').html("");	
	if ((drugId == "")||(drugId == undefined)){
		var html = '<div class="detail_notdata"><div class="detail_notdata-tips">暂无记录，去其他地方看看吧~</div></div>';
		$('#edu').append(html);
		return;	
	}	
	runClassMethod("web.DHCCKBPdssIndex","GetEduInfo",{"drugId":drugId},function(res){			
		if (res.state == "104"){
			var html = '<div class="detail_notdata"><div class="detail_notdata-tips">暂无记录，去其他地方看看吧~</div></div>';
			//var html = '<div class="notdatatips"><img src="../scripts/dhcnewpro/dhcckb/pdss/images/notdata.png"><h3>暂无记录，去其他地方看看吧~</h3></div>';
			$('#edu').append(html);
			return;
		}	
		
		var dataArr = res.data;	
		if((dataArr == "") || (dataArr.length == 0)){
			return;
		}
		var htmlstr = ""
		var len = dataArr.length-1;
		var contArr = [];
		for (var i=0; i<=len; i++){
			var guideObj = dataArr[i];
			contArr.push('<div class="e_edu_title">');
            contArr.push('<h3 class="nowrap">'+ guideObj.name +'</h3>');
            contArr.push('</div>');
            
            for (var j=0; j<=guideObj.book.length-1; j++){
	            var msgObj = guideObj.book[j];
	            if (j == 0){
	        		contArr.push('<div class="e_edu_type">');
            		contArr.push('<span>'+ "药品说明书:" +'</span>');
           			contArr.push('</div>'); 
		        }	            
	        	contArr.push('<div class="e_edu_text">');
            	contArr.push('<span>'+ msgObj.msg +'</span>');
           		contArr.push('</div>');  
	        }
	        
            for (var k=0; k<=guideObj.outBook.length-1; k++){
	            var msgObj = guideObj.outBook[k];
	            if (k == 0){
	        		contArr.push('<div class="e_edu_type">');
            		contArr.push('<span>'+ "文献参考:" +'</span>');
           			contArr.push('</div>'); 
		        }	            
	        	contArr.push('<div class="e_edu_text">');
            	contArr.push('<span>'+ msgObj.msg +'</span>');
           		contArr.push('</div>');  
	        }
            
           
		}
		$('#edu').append(contArr.join(''));
	},'json',false);
}

/**
 * @description: 初始化页面显示状态
 * @param {*}
 * @return {*}
 */
function initPageStatus(){
	
	$("#tab").show();
	$(".drugtips").hide();
	$(".details").hide();
	$(".drugcont").hide();
	$(".drugedu").hide();		
}

/**
 * @description: 初始化固定步骤条
 * @param {*}
 * @return {*}
 */
function initDrugStep() {
    var nav = $(".scrollbar");
    var win = $(window);
    var sc = $(document);
	win.scroll(function() {
		console.log(sc.scrollTop());
		if(sc.scrollTop() >= 800) {
			nav.addClass("fix");
		}
		else {
			nav.removeClass("fix");
		}
	});
}
