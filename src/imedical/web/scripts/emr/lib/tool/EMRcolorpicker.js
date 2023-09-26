/**
 * jQuery插件：重写颜色拾取器,专门为 EMR-电子病历书写提供的.
 * 说明：引用此插件时,需要在csp中定义colorpanelshow变量,初始值为"0",判断颜色面板是否显示;选则颜色触发success函数中的自定义方法;
 * @author  niucaicai
 * @name    EMRcolorpicker.js
 * @since   2015-6-15 15:08:08
 */
(function($) {
    var ColorHex=new Array('00','33','66','99','CC','FF');
    var SpColorHex=new Array('FF0000','00FF00','0000FF','FFFF00','00FFFF','FF00FF');
    $.fn.colorpicker = function(options) {
        var opts = jQuery.extend({}, jQuery.fn.colorpicker.defaults, options);
        initColor();
        return this.each(function(){
            var obj = $(this);
            obj.bind(opts.event,function(){
                //定位
                var ttop  = $(this).offset().top;     //控件的定位点高
                var thei  = $(this).height();  //控件本身的高
                var tleft = $(this).offset().left;    //控件的定位点宽
                $("#colorpanel").css({
                    top:ttop-75,
                    left:tleft+25
				});
                //}).show();
				
                var target = opts.target ? $(opts.target) : obj;
                if(target.data("color") == null){
                    target.data("color",target.css("color"));
                }
                if(target.data("value") == null){
                    target.data("value",target.val());
                }
				
                $("#CT tr td").unbind("click").mouseover(function(){
                    var color=$(this).css("background-color");
                    $("#DisColor").css("background",color);
                }).click(function(){
                    var color=$(this).attr("rel");
                    color = opts.ishex ? color : getRGBColor(color);
                    if(opts.fillcolor) target.val(color);
                    target.css("color",color);
                    $("#colorpanel").hide();
					colorpanelshow = "0";
                    opts.success(obj,color);
                });
				
            });
        });
        function initColor(){
            $("body").append('<div id="colorpanel" style="position:absolute;z-index: 10;top: 10; display: none;background-color:#FFCC99; "></div>');
            var colorTable = '';
			
			colorTable=colorTable+'<tr height=12>' //第一行
			colorTable=colorTable+'<td width=11 rel="#000000" style="background-color:#000000">'  //黑色
			colorTable=colorTable+'<td width=11 rel="#993300" style="background-color:#993300">'  //褐色
			colorTable=colorTable+'<td width=11 rel="#333300" style="background-color:#333300">'  //橄榄色
			colorTable=colorTable+'<td width=11 rel="#003300" style="background-color:#003300">'  //深绿色
			colorTable=colorTable+'<td width=11 rel="#003366" style="background-color:#003366">'  //深青色
			colorTable=colorTable+'<td width=11 rel="#000080" style="background-color:#000080">'  //深蓝色
			colorTable=colorTable+'<td width=11 rel="#333399" style="background-color:#333399">'  //靛蓝色
			colorTable=colorTable+'<td width=11 rel="#333333" style="background-color:#333333">'  //灰色80%

			colorTable=colorTable+'<tr height=12>' //第二行
			colorTable=colorTable+'<td width=11 rel="#800000" style="background-color:#800000">'  //深红色
			colorTable=colorTable+'<td width=11 rel="#FF6600" style="background-color:#FF6600">'  //橙色
			colorTable=colorTable+'<td width=11 rel="#808000" style="background-color:#808000">'  //深黄色
			colorTable=colorTable+'<td width=11 rel="#008000" style="background-color:#008000">'  //绿色
			colorTable=colorTable+'<td width=11 rel="#008080" style="background-color:#008080">'  //青色
			colorTable=colorTable+'<td width=11 rel="#0000FF" style="background-color:#0000FF">'  //蓝色
			colorTable=colorTable+'<td width=11 rel="#666699" style="background-color:#666699">'  //蓝-灰色
			colorTable=colorTable+'<td width=11 rel="#808080" style="background-color:#808080">'  //灰色50%

			colorTable=colorTable+'<tr height=12>' //第三行
			colorTable=colorTable+'<td width=11 rel="#FF0000" style="background-color:#FF0000">'  //红色
			colorTable=colorTable+'<td width=11 rel="#FF9900" style="background-color:#FF9900">'  //浅橙色
			colorTable=colorTable+'<td width=11 rel="#99CC00" style="background-color:#333300">'  //酸橙色
			colorTable=colorTable+'<td width=11 rel="#339966" style="background-color:#339966">'  //海绿色
			colorTable=colorTable+'<td width=11 rel="#33CCCC" style="background-color:#33CCCC">'  //水绿色
			colorTable=colorTable+'<td width=11 rel="#3366FF" style="background-color:#3366FF">'  //浅蓝色
			colorTable=colorTable+'<td width=11 rel="#800080" style="background-color:#800080">'  //紫罗兰色
			colorTable=colorTable+'<td width=11 rel="#969696" style="background-color:#969696">'  //灰色40%

			colorTable=colorTable+'<tr height=12>' //第四行
			colorTable=colorTable+'<td width=11 rel="#FF00FF" style="background-color:#FF00FF">'  //粉红色
			colorTable=colorTable+'<td width=11 rel="#FFCC00" style="background-color:#FFCC00">'  //金色
			colorTable=colorTable+'<td width=11 rel="#FFFF00" style="background-color:#FFFF00">'  //黄色
			colorTable=colorTable+'<td width=11 rel="#00FF00" style="background-color:#00FF00">'  //鲜绿色
			colorTable=colorTable+'<td width=11 rel="#00FFFF" style="background-color:#00FFFF">'  //青绿色
			colorTable=colorTable+'<td width=11 rel="#00CCFF" style="background-color:#00CCFF">'  //天蓝色
			colorTable=colorTable+'<td width=11 rel="#993366" style="background-color:#993366">'  //梅红色
			colorTable=colorTable+'<td width=11 rel="#C0C0C0" style="background-color:#C0C0C0">'  //灰色25%

			colorTable=colorTable+'<tr height=12>' //第五行
			colorTable=colorTable+'<td width=11 rel="#FF99CC" style="background-color:#FF99CC">'  //玫瑰红色
			colorTable=colorTable+'<td width=11 rel="#FFCC99" style="background-color:#FFCC99">'  //茶色
			colorTable=colorTable+'<td width=11 rel="#FFFF99" style="background-color:#FFFF99">'  //浅黄色
			colorTable=colorTable+'<td width=11 rel="#CCFFCC" style="background-color:#CCFFCC">'  //浅绿色
			colorTable=colorTable+'<td width=11 rel="#CCFFFF" style="background-color:#CCFFFF">'  //浅青绿色
			colorTable=colorTable+'<td width=11 rel="#99CCFF" style="background-color:#99CCFF">'  //淡蓝色
			colorTable=colorTable+'<td width=11 rel="#CC99FF" style="background-color:#CC99FF">'  //淡紫色
			colorTable=colorTable+'<td width=11 rel="#FFFFFF" style="background-color:#FFFFFF">'  //白色
			
			colorTable='<table style="border:1px solid #99CCFF;background-color:#F0F0EE">'
			+'<tr><td>'
            +'<table cellpadding="1"><tr><td><input type="text" size="18" id="DisColor" disabled style="border:solid 1px #000000;background-color:#000000"></td></tr></table>'
			+'</td></tr>'
            +'<tr><td>'
			+'<table id="CT" cellspacing="6" cellpadding="0" style="border:solid 1px #99CCFF;cursor:pointer;background-color:#99CCCF">'
            +colorTable+'</table>'
			+'</td></tr>'
			+'</table>'

            $("#colorpanel").html(colorTable);
			
	    var str = '<iframe frameborder="0" tabindex="-1" src="javascript:false;" style="display:block;position:absolute;z-index:-1;filter:Alpha(Opacity=0);opacity:0;';
	    str += 'top:0px;left:0px;width:'+150+';height:'+135+';"/>';
            $("#colorpanel").append(str);
        }
        
        function getRGBColor(color) {
            var result;
            if ( color && color.constructor == Array && color.length == 3 )
                color = color;
            if (result = /rgb\(\s*([0-9]{1,3})\s*,\s*([0-9]{1,3})\s*,\s*([0-9]{1,3})\s*\)/.exec(color))
                color = [parseInt(result[1]), parseInt(result[2]), parseInt(result[3])];
            if (result = /rgb\(\s*([0-9]+(?:\.[0-9]+)?)\%\s*,\s*([0-9]+(?:\.[0-9]+)?)\%\s*,\s*([0-9]+(?:\.[0-9]+)?)\%\s*\)/.exec(color))
                color =[parseFloat(result[1])*2.55, parseFloat(result[2])*2.55, parseFloat(result[3])*2.55];
            if (result = /#([a-fA-F0-9]{2})([a-fA-F0-9]{2})([a-fA-F0-9]{2})/.exec(color))
                color =[parseInt(result[1],16), parseInt(result[2],16), parseInt(result[3],16)];
            if (result = /#([a-fA-F0-9])([a-fA-F0-9])([a-fA-F0-9])/.exec(color))
                color =[parseInt(result[1]+result[1],16), parseInt(result[2]+result[2],16), parseInt(result[3]+result[3],16)];
            return "rgb("+color[0]+","+color[1]+","+color[2]+")";
        }
    };
    jQuery.fn.colorpicker.defaults = {
        ishex : true, //是否使用16进制颜色值
        fillcolor:false,  //是否将颜色值填充至对象的val中
        target: null, //目标对象
        event: 'click', //颜色框显示的事件
        success:function(obj,color){
			setFontColor(color);
		}, //回调函数
        reset:function(){}
    };
})(jQuery);