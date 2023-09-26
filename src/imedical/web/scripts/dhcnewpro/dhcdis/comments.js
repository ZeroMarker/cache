/// creator:dws
/// 2017-02-13
/// Descript:评价星星图标相关

jQuery.fn.rater	= function(options) {
		
	// 默认参数
	var settings = {
		enabled	: true,
		url		: '',
		method	: 'post',
		min		: 1,
		max		: 5,
		step	: 1,
		value	: null,
		after_click	: null,
		before_ajax	: null,
		after_ajax	: null,
		title_format	: null,
		info_format	: null,
		image	: '../scripts/emr/lib/tool/comment/images/comment/stars.jpg',
		imageAll :'../scripts/emr/lib/tool/comment/images/comment/stars-all.gif',
		defaultTips :true,
		clickTips :true,
		width	: 24,
		height	: 24
	}; 
	
	// 自定义参数
	if(options) {  
		jQuery.extend(settings, options); 
	}
	
	//外容器
	var container	= jQuery(this);
	
	// 主容器
	var content	= jQuery('<ul class="rater-star"></ul>');
	content.css('background-image' , 'url(' + settings.image + ')');
	content.css('height' , settings.height);
	content.css('width' , (settings.width*settings.step) * (settings.max-settings.min+settings.step)/settings.step);
	
	// 当前选中的
	var item	= jQuery('<li class="rater-star-item-current"></li>');
	item.css('background-image' , 'url(' + settings.image + ')');
	item.css('height' , settings.height);
	item.css('width' , 0);
	item.css('z-index' , settings.max / settings.step + 1);
	if (settings.value) {
		item.css('width' , ((settings.value-settings.min)/settings.step+1)*settings.step*settings.width);
	};
	content.append(item);

	
	// 星星
	for (var value=settings.min ; value<=settings.max ; value+=settings.step) {
		item	= jQuery('<li class="rater-star-item"><div class="popinfo"></div></li>');
		if (typeof settings.info_format == 'function') {
			item.attr('title' , settings.title_format(value));
			item.find(".popinfo").html(settings.info_format(value));
			item.find(".popinfo").css("left",(value-1)*settings.width)
		}
		else {
			item.attr('title' , value);
		}
		item.css('height' , settings.height);
		item.css('width' , (value-settings.min+settings.step)*settings.width);
		item.css('z-index' , (settings.max - value) / settings.step + 1);
		item.css('background-image' , 'url(' + settings.image + ')');
		
		if (!settings.enabled) {	// 若是不能更改，则隐藏
			item.hide();
		}
		
		content.append(item);
	}
	
	content.mouseover(function(){
		if (settings.enabled) {
			jQuery(this).find('.rater-star-item-current').hide();
		}
	}).mouseout(function(){
			jQuery(this).find('.rater-star-item-current').show();
	})
	// 添加鼠标悬停/点击事件
	var shappyWidth=(settings.max-2)*settings.width;
	var happyWidth=(settings.max-1)*settings.width;
	var fullWidth=settings.max*settings.width;
	content.find('.rater-star-item').mouseover(function() {
		jQuery(this).prevAll('.rater-star-item-tips').hide();
		jQuery(this).attr('class' , 'rater-star-item-hover');
		jQuery(this).find(".popinfo").show();
		
		//当3分时用笑脸表示
		if(parseInt(jQuery(this).css("width"))==shappyWidth){
			jQuery(this).addClass('rater-star-happy');
		}
		//当4分时用笑脸表示
		if(parseInt(jQuery(this).css("width"))==happyWidth){
			jQuery(this).addClass('rater-star-happy');
		}
		//当5分时用笑脸表示
		if(parseInt(jQuery(this).css("width"))==fullWidth){
			jQuery(this).removeClass('rater-star-item-hover');
			jQuery(this).css('background-image' , 'url(' + settings.imageAll + ')');
			jQuery(this).css({cursor:'pointer',position:'absolute',left:'0',top:'0'});
		}
	}).mouseout(function() {
		var outObj=jQuery(this);
		outObj.css('background-image' , 'url(' + settings.image + ')');
		outObj.attr('class' , 'rater-star-item');
		outObj.find(".popinfo").hide();
		outObj.removeClass('rater-star-happy');
		jQuery(this).prevAll('.rater-star-item-tips').show();
		//var startTip=function () {
		//outObj.prevAll('.rater-star-item-tips').show();
		//};
		//startTip();
	}).click(function() {
		//jQuery(this).prevAll('.rater-star-item-tips').css('display','none');
		jQuery(this).parents(".rater-star").find(".rater-star-item-tips").remove();
		jQuery(this).parents(".goods-comm-stars").find(".rater-click-tips").remove();
		jQuery(this).prevAll('.rater-star-item-current').css('width' , jQuery(this).width());
		   if(parseInt(jQuery(this).prevAll('.rater-star-item-current').css("width"))==happyWidth||parseInt(jQuery(this).prevAll('.rater-star-item-current').css("width"))==shappyWidth){	
			jQuery(this).prevAll('.rater-star-item-current').addClass('rater-star-happy');
			}
		else{
			jQuery(this).prevAll('.rater-star-item-current').removeClass('rater-star-happy');
			}
			if(parseInt(jQuery(this).prevAll('.rater-star-item-current').css("width"))==fullWidth){	
			jQuery(this).prevAll('.rater-star-item-current').addClass('rater-star-full');
			}
		else{
			jQuery(this).prevAll('.rater-star-item-current').removeClass('rater-star-full');
			}
		var star_count		= (settings.max - settings.min) + settings.step;
		var current_number	= jQuery(this).prevAll('.rater-star-item').size()+1;
		var current_value	= settings.min + (current_number - 1) * settings.step;
		$("#lb_Num").text(current_value);
		switch(current_value){
			case 1 : 
				$("#signpraise").text("");
				$("#signpraise").text("非常差,有待提高！");
				getScoreModuleDesc(0,20);
				break;
			case 2 : 
				$("#signpraise").text("");
				$("#signpraise").text("很差,还需改进！");
				getScoreModuleDesc(20,40);
				break;
			case 3 : 
				$("#signpraise").text("");
				$("#signpraise").text("一般,希望服务完善！");
				getScoreModuleDesc(40,60);
				break;
			case 4 : 
				$("#signpraise").text("");
				$("#signpraise").text("很好,继续努力！");
				getScoreModuleDesc(60,80);
				break;
			case 5 : 
				$("#signpraise").text("");
				$("#signpraise").text("非常好,无可挑剔！");
				getScoreModuleDesc(80,100);
				break;
			default :
				alert("评价出错！");
				break;
		};
		//alert(current_value);
		
		//显示当前分值
		if (typeof settings.title_format == 'function') {
			jQuery(this).parents().nextAll('.rater-star-result').html(current_value+'分&nbsp;');
		}
		
		$("#StarNum").val(current_value);
		$("#result").val(current_value);
		//jQuery(this).parents().next('.rater-star-result').html(current_value);
		//jQuery(this).unbind('mouseout',startTip)
	})
	
	jQuery(this).html(content);
	
}

// 星星打分
$(function(){
	var options	= {
	max	: 5,
	title_format	: function(value) {
		var title = '';
		switch (value) {
			case 1 : 
				title	= '非常差';
				break;
			case 2 : 
				title	= '很差';
				break;
			case 3 : 
				title	= '一般';
				break;
			case 4 : 
				title	= '很好';
				break;
			case 5 : 
				title	= '非常好';
				break;
			default :
				title = value;
				break;
		}
		return title;
	},
	info_format	: function(value) {
		var info = '';
		switch (value) {
			case 1 : 
				info	= '<div class="info-box">1分&nbsp;</div>';
				break;
			case 2 : 
				info	= '<div class="info-box">2分&nbsp;</div>';
				break;
			case 3 : 
				info	= '<div class="info-box">3分&nbsp;</div>';
				break;
			case 4 : 
				info	= '<div class="info-box">4分&nbsp;</div>';
				break;
			case 5 : 
				info	= '<div class="info-box">5分&nbsp;</div>';
				break;
			default :
				info = value;
				break;
		}
			return info;
		}
	}
	$('#rate-comm-1').rater(options);
});

///获取相应评分下的评价模块
function getScoreModuleDesc(startScore,endScore){
	$("#tag").html("");
	runClassMethod("web.DHCDISAppraise","getScoreModuleDesc",{startScore:startScore,endScore:endScore},function(jsonObj){
		praiseNum=jsonObj.total;
		for(var i=0;i<praiseNum;i++){
			$("#tag").append('<span class="tag" tempVal='+jsonObj.rows[i].AIRowId+' onclick="changePraiseStatus(this);">'+jsonObj.rows[i].AIDesc+'</span>');
		}
	});
}