// Creat by ZX 2017-03-23
// easyui自定义校验规则
// 通过扩展 jQuery.fn.validatebox.defaults.rules 实现
// 调用方式 data-options="validType:'phoneRex'
// 验证结果 boolen b=jQuery('#providertel').textbox("isValid");
jQuery.extend(jQuery.fn.validatebox.defaults.rules, {
	//增加 phoneRex 方法,对电话格式进行校验
	phoneRex:{
		validator: function(value){
			var rex=/^1[3-8]+\d{9}$/;
			//var rex=/^(([0\+]\d{2,3}-)?(0\d{2,3})-)(\d{7,8})(-(\d{3,}))?$/;
			//区号：前面一个0，后面跟2-3位数字 ： 0\d{2,3}
			//电话号码：7-8位数字： \d{7,8
			//分机号：一般都是3位数字： \d{3,}
			//这样连接起来就是验证电话的正则表达式了：/^((0\d{2,3})-)(\d{7,8})(-(\d{3,}))?$/		 
			var rex2=/^((0\d{2,3})-)(\d{7,8})(-(\d{3,}))?$/;
			if(rex.test(value)||rex2.test(value))
			{
			 	// alertShow('t'+value);
				return true;
			}else
			{
			 	//alertShow('false '+value);
				return false;
			}
		  
		},
		message: '请输入正确电话或手机格式'
	},
	intOrFloat: {
		// 验证整数或小数
        validator: function (value) {
        	return /^\d+(\.\d+)?$/i.test(value);
        },
        message: '请输入数字，并确保格式正确'
    }
});
