/*
 * copy自hisui.js
 */
function ConvertTDate(dt) {
	var xdays = 0;
	var today=new Date();
	var re = /(\s)+/g ;
	dt=dt.replace(re,'');
	if (dt.charAt(0).toUpperCase()=='T') {
		xdays = dt.slice(2);
		if (xdays=='') xdays=0;
		if (isNaN(xdays)) return 0;
		xdays_ms = xdays * 24 * 60 * 60 * 1000;
		if (dt.charAt(1) == '+') today.setTime(today.getTime() + xdays_ms);
		else if (dt.charAt(1) == '-') today.setTime(today.getTime() - xdays_ms);
		else if (dt.length>1) return today;
		return today;
	}
	return today;
}

(function($){
	$.extend($.fn.datagrid.defaults.editors, {
		timespinner: {
			init: function(container, options){
				var input = $('<input>').appendTo(container);
				var _options = {
					min:'00:00:00',
					max:'23:59:59',
					showSeconds:true
				};
				var settings  = jQuery.extend({}, _options,options);
				input.timespinner(settings);
				return input;
			},
			destroy: function(target){
				$(target).timespinner('destroy');
			},
			getValue: function(target){
				return $(target).timespinner('getValue');
			},
			setValue: function(target, value){
				$(target).timespinner('setValue', value);
			},
			resize: function(target, width){
				$(target).timespinner('resize', width);
			}
		},
		numberbox: {
			init: function (container, options) {
				var ParserType = '';
				if(options && options.parserType){
					ParserType = options.parserType;
				}
				var Precision = 2;
				if(!isEmpty(ParserType)){
					Precision = tkMakeServerCall('web.DHCSTMHUI.Util.DrugUtil', 'DecLenByFmtType', ParserType, session['LOGON.HOSPID']);
				}
				var input = $('<input type="text">').appendTo(container);
				var _options = {
					precision: Precision,
					parser: function (s) {
						s = s + "";
						var opts = $(this).numberbox("options");
						if (parseFloat(s) != s) {
							if (opts.prefix) {
								s = $.trim(s.replace(new RegExp("\\" + $.trim(opts.prefix), "g"), ""));
							}
							if (opts.suffix) {
								s = $.trim(s.replace(new RegExp("\\" + $.trim(opts.suffix), "g"), ""));
							}
							if (opts.groupSeparator) {
								s = $.trim(s.replace(new RegExp("\\" + opts.groupSeparator, "g"), ""));
							}
							if (opts.decimalSeparator) {
								s = $.trim(s.replace(new RegExp("\\" + opts.decimalSeparator, "g"), "."));
							}
							s = s.replace(/\s/g, "");
						}
						//var val = parseFloat(s).toFixed(opts.precision);
						//这里按需进行toFixed
						var val = parseFloat(s) == parseFloat(s).toFixed(opts.precision)? parseFloat(s) : parseFloat(s).toFixed(opts.precision);
						
						if (isNaN(val)) {
							val = "";
						} else {
							if (typeof (opts.min) == "number" && val < opts.min) {
								//val = opts.min.toFixed(opts.precision);
								val = opts.min == opts.min.toFixed(opts.precision)? opts.min : opts.min.toFixed(opts.precision);
							} else {
								if (typeof (opts.max) == "number" && val > opts.max) {
									//val = opts.max.toFixed(opts.precision);
									val = opts.max == opts.max.toFixed(opts.precision)? opts.max : opts.max.toFixed(opts.precision);
								}
							}
						}
						return val;
					}
				};
				options = $.extend(_options, options);
				return input.numberbox(options);
			},
			destroy: function (target) {
				$(target).numberbox('destroy');
			},
			getValue: function (target) {
				var value = $(target).val();
				return value;
			},
			setValue: function (target, value) {
				return $(target).numberbox('setValue',value);
			},
			resize: function (target, width) {
				$(target).numberbox("resize", width);
			}
		},
		datebox: {
			init: function (container, options) {
				var input = $('<input />').appendTo(container);
				var _options = {
					//2019-12-01 此处封装仅添加了ShowPanelFlag控制,其他实现和hisui.js一致(enter,qurey).
					keyHandler: {
						enter: function(e){
							var ShowPanelFlag = $.data(this, 'combo').panel.panel('options').closed;
							if(!ShowPanelFlag){
								var _this = $.data(this, 'datebox');
								var opts = _this.options;
								var current = _this.calendar.calendar('options').current;
								if (current) {
									var CurrentDate = opts.formatter.call(this, current);
									$(this).combo('setValue', CurrentDate);
									_this.calendar.calendar('moveTo', opts.parser.call(this, CurrentDate));
									$(this).combo('hidePanel');
								}
							}
						},
						query: function(q, e){
							var _this = $.data(this, 'datebox');
							var opts = _this.options;
							if (q.indexOf('t') > -1){
								q = ConvertTDate(q);
								q = opts.formatter.call(this, q);
							}
							
							$(this).combo('setValue', q);
							_this['calendar'].calendar('moveTo', opts.parser.call(this, q));
						}
					}
				};
				
				options = $.extend(true, _options, options);
				return input.datebox(options);
			},
			destroy: function (target) {
				$(target).datebox('destroy');
			},
			getValue: function (target) {
				return $(target).datebox('getValue');
			},
			setValue: function (target, value) {
				return $(target).datebox('setValue',value);
			},
			resize: function (target, width) {
				$(target).datebox('resize', width);
			}
		}
	});
})(jQuery);
