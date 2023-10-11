(function ($) {
	var pswTran = $g('密码');
	var baseHtml = '<div class="validpassword-cont" style="width:220px;margin:10px auto;"><span class="validpassword-user" style="display: block;margin: 10px 0;"">';
	var baseHtml2 = '</span><label class="r-label">'+pswTran+'</label><input type="password" class="textbox f-validpassword-input"></div>';
	function init (target){
      	var status = $.data(target, 'validpassword');
		var opts = status.options;
		status.cont = $(baseHtml + opts.userHello + baseHtml2).appendTo(target);
		$(target).dialog($.extend({}, opts, {
			buttons: [{
				text: '确定', handler: function () {
					if (isValid(target)) {
						$.messager.popover({
							msg: '密码正确',
							type: 'success',
							timeout: 2000,
							showType: 'slide'
						});
						if (opts.success) opts.success.call();
						$(target).dialog('close');
						
					} else {
						$.messager.popover({
							msg: '密码错误',
							type: 'error',
							timeout: 2000,
							showType: 'slide'
						});
					};
				}
			},{
				text: "取消", handler: function () {
					$(target).dialog('close');
				}
			}]
        }));
	};
  
    $.fn.validpassword = function (opts, params) {
		if (typeof opts == "string") {
			return $.fn.validpassword.methods[opts](this, params);
		}
		opts = opts || {};
		return this.each(function () {
			var state = $.data(this, "validpassword");
			if (state) {
				$.extend(state.options, opts);
			} else {
				$.data(this, "validpassword", { options: $.extend({}, $.fn.validpassword.defaults, $.fn.validpassword.parseOptions(this), opts) });
			}
			init(this);
		});
	};
	function isValid(target) {
		var status = $.data(target, 'validpassword');
	  	var opts = status.options;
		var psw = status.cont.find('.f-validpassword-input').val();
		var isValidUserEncypt = opts.isValidUserEncypt;
		if (true){ // old password, old project
			var enpsw = hex_md5(dhc_cacheEncrypt(psw));
			enpsw = enpsw+opts.encodeKey;
			enpsw = hex_md5(enpsw);
			if(enpsw==opts.popsw){
				return true;
			}
		}
		if ('string'==typeof isValidUserEncypt){
			var FIXKEY="ABCDEF0123456789";
			var sid = ""+Math.ceil(Math.random()*100000);
			var k = FIXKEY+(sid-1),l=sid.length;
			var encpsw = e7(psw,k.slice(l));
			var rtn = $m({EncryItemName:isValidUserEncypt,username:opts.usercode, password:encpsw, overrideauthentication:0, RSID:sid},false);
			if (parseInt(rtn)>0){return true};
		}
		return false;
	}
	$.fn.validpassword.methods = {
		options: function (jq) {
			return $.data(jq[0], "validpassword").options;
		}, destroy: function (jq) {
			return jq.each(function () {
				//_41f(this);
			});
		}
	};	
	$.fn.validpassword.parseOptions = function (target) {
        return $.extend({}, $.fn.dialog.parseOptions(target), $.parser.parseOptions(target, ["usercode", "username"]));
    };
    
    $.fn.validpassword.defaults = $.extend({}, $.fn.dialog.defaults, {
		title: '验证密码',
		modal:true,
        encodeKey: "",
        usercode:"",
        username:"",
        popsw:"",
		isValidUserEncypt: "",
		success: null,
		buttons:null
    });
})(jQuery);