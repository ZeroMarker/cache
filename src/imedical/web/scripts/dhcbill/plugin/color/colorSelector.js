// scripts/dhcbill/plugin/color/colorSelector.js
(function($){
	$.fn.extend({
		selectColor:function(){
			var _d = new Date();
			var _tem = _d.getTime();
			return this.each(function(){
				var showColor = function(_obj){
					var _left = parseInt($(_obj).offset().left);
					var _top = parseInt($(_obj).offset().top);
					var _width = parseInt($(_obj).width());
					var _height = parseInt($(_obj).height());
					var _maxindex = function(){
						var ___index = 0;
						$.each($("*"),function(i,n){
							var __tem = $(n).css("z-index");
							if(__tem>0){
								if(__tem > ___index){
									___index = __tem + 1;
								}
							}
						});
						return ___index;
					}();
					var colorH = new Array('00','33','66','99','CC','FF');
					var ScolorH = new Array('FF0000','00FF00','0000FF','FFFF00','00FFFF','FF00FF');
					var _str = new Array();
					for(var n = 0 ; n < 6 ; n++){
						_str.push('<tr height="11">');
						_str.push('<td style="width:11px;background-color:#'+colorH[n]+colorH[n]+colorH[n]+'"></td>');
						for(var i = 0 ; i < 3; i++){
							for(var j = 0 ; j < 6 ; j++){
								_str.push('<td style="width:11px;background-color:#'+colorH[i]+colorH[j]+colorH[n]+'"></td>');
							}
						}
						_str.push('</tr>');
					}
					for(var n = 0 ; n < 6 ; n++){
						_str.push('<tr height="11">');
						_str.push('<td style="width:11px;background-color:#'+ScolorH[n]+'"></td>')
						for(var i = 3 ; i < 6; i++){
							for(var j = 0 ; j < 6 ; j++){
								_str.push('<td style="width:11px;background-color:#'+colorH[i]+colorH[j]+colorH[n]+'"></td>');
							}
						}
						_str.push('</tr>');
					}
					debugger;
					var colorName = $(_obj).val()
					var colorStr = '<div id="colorShowDiv_'+_tem+'" style="width:229px;position:absolute;z-index:'+_maxindex+';left:'+(_left+_width)+'px;top:'+(_top+_height)+'px;"><table style="width:100%; height:30px; background-color:#CCCCCC;"><tr><td style="width:40%;"><div id="colorShow_'+_tem+'" style="width:80px; height:18px; border:solid 1px #000000; background-color:'+colorName+';"></div></td><td style="width:60%;"><input id="color_txt_'+_tem+'" type="text" style="width:100px; height:16px;" value="'+colorName+'" /></td></tr></table><table id="colorShowTable_'+_tem+'" cellpadding="0" cellspacing="1" style="background-color:#000000;">'+_str.join('')+'</table></div>'
					$("body").append(colorStr);
					var _currColor;
					var _currColor2;
					$("#colorShowTable_"+_tem+" td").mouseover(function(){
						var _color = $(this).css("background-color");
						if(_color.indexOf("rgb")>=0){
							var _tmeColor = _color;
							_tmeColor = _color.replace("rgb","");
							_tmeColor = _tmeColor.replace("(","");
							_tmeColor = _tmeColor.replace(")","");
							_tmeColor = _tmeColor.replace(new RegExp(" ","gm"),"");
							var _arr = _tmeColor.split(",");
							var _tmeColorStr = "#";
							for(var ii = 0 ; ii < _arr.length ; ii++){
								var _temstr = parseInt(_arr[ii]).toString(16);
								_temstr = _temstr.length < 2 ? "0"+_temstr : _temstr;
								_tmeColorStr += _temstr;
							}
						}
						$("#color_txt_"+_tem).val(_tmeColorStr);
						$("#colorShow_"+_tem).css("background-color",_color);
						_currColor = _color;
						_currColor2 = _tmeColorStr;
						$(this).css("background-color","#FFFFFF");
					});
					$("#colorShowTable_"+_tem+" td").mouseout(function(){
						$(this).css("background-color",_currColor);
					});
					$("#colorShowTable_"+_tem+" td").click(function(){
						$(_obj).val(_currColor2);
						//$(_obj).css('background-color', _currColor2);
					});
				}
				$(this).click(function(){
					showColor(this);
				});
				var _sobj = this;
				$(document).click(function(e){
					e = e ? e : window.event;
					var tag = e.srcElement || e.target;
					if(_sobj.id==tag.id) return;
					var _temObj = tag;
					while(_temObj){
						if(_temObj.id=="colorShowDiv_"+_tem) return;
						_temObj = _temObj.parentNode;
					}
					$("#colorShowDiv_"+_tem).remove();
				});
			});
		}
	});
})(jQuery);