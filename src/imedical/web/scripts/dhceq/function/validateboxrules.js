// Creat by ZX 2017-03-23
// easyui�Զ���У�����
// ͨ����չ jQuery.fn.validatebox.defaults.rules ʵ��
// ���÷�ʽ data-options="validType:'phoneRex'
// ��֤��� boolen b=jQuery('#providertel').textbox("isValid");
jQuery.extend(jQuery.fn.validatebox.defaults.rules, {
	//���� phoneRex ����,�Ե绰��ʽ����У��
	phoneRex:{
		validator: function(value){
			var rex=/^1[3-8]+\d{9}$/;
			//var rex=/^(([0\+]\d{2,3}-)?(0\d{2,3})-)(\d{7,8})(-(\d{3,}))?$/;
			//���ţ�ǰ��һ��0�������2-3λ���� �� 0\d{2,3}
			//�绰���룺7-8λ���֣� \d{7,8
			//�ֻ��ţ�һ�㶼��3λ���֣� \d{3,}
			//������������������֤�绰��������ʽ�ˣ�/^((0\d{2,3})-)(\d{7,8})(-(\d{3,}))?$/		 
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
		message: '��������ȷ�绰���ֻ���ʽ'
	},
	intOrFloat: {
		// ��֤������С��
        validator: function (value) {
        	return /^\d+(\.\d+)?$/i.test(value);
        },
        message: '���������֣���ȷ����ʽ��ȷ'
    }
});
