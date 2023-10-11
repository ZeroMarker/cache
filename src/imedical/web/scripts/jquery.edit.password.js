;(function($){
	/*����persistPWD�ж�,��ͨ��encryItem��̨�ж�*/
	var defaultOpts = {
		isContainWordAndNum:false, //Ĭ��ǿ�Ʋ�����
		PasswordOtherValid:"",
		minLength:"0",encryHandler:null,
		oldLabel:"������",newLabel:"������",cnfLabel:"ȷ������",updateLabel:'�޸�����',
		persistent:"",validEnc:"",saveEnc:"",userName:"",saving:false,hideOldPsw:false,successCallback:function(){}
	};
	$g = window.$g || function(a){return a;};
	//����ǿ��
	//�ж��������������
	function CharMode(iN) {
		if (iN >= 48 && iN <= 57) //����
		return 1;
		if (iN >= 65 && iN <= 90) //��д
		return 2;
		if (iN >= 97 && iN <= 122) //Сд
		return 4;
		else return 8;
	} 
	//bitTotal����
	//��������ģʽ
	function bitTotal(num) {
		modes = 0;
		for (i = 0; i < 4; i++) {
			if (num & 1) modes++;
			num >>>= 1;
		}
		return modes;
	} //����ǿ�ȼ���
	function checkStrong(sPW) {
		if (sPW.length <= 4) return 0; //����̫��
		Modes = 0;
		for (i = 0; i < sPW.length; i++) { //����ģʽ
			Modes |= CharMode(sPW.charCodeAt(i));
		}
		return bitTotal(Modes);
	} 
	//��ʾ��ɫ
	var pwStrength = function(p,pwd) {
		O_color = "#eeeeee";
		L_color = "#FF0000";
		M_color = "#FF9900";
		H_color = "#33CC00";
		if (pwd == null || pwd == '') {
			Lcolor = Mcolor = Hcolor = O_color;
		} else {
			S_level = checkStrong(pwd);
			switch (S_level) {
			case 0:
				Lcolor = Mcolor = Hcolor = O_color;
			case 1:
				Lcolor = L_color;
				Mcolor = Hcolor = O_color;
				break;
			case 2:
				Lcolor = Mcolor = M_color;
				Hcolor = O_color;
				break;
			default:
				Lcolor = Mcolor = Hcolor = H_color;
			}
		}
		p.find(".strength-L").css("background",Lcolor);
		p.find(".strength-M").css("background",Mcolor);
		p.find(".strength-H").css("background",Hcolor);
		return;
	}
	$.fn.editpassword = function (opt){
		opt = $.extend({},defaultOpts,opt);
		var pswTipSpan= "";
		var UserNamePswTipSpan = opt.userName+"���ã�ϵͳ�ѿ�������ǿ�ȼ�⣺"
		if (opt.minLength>0){
			pswTipSpan = '���볤�ȱ������'+opt.minLength+'λ';
		}
		if (opt.isContainWordAndNum){
			if (pswTipSpan!="") pswTipSpan += '��';
			pswTipSpan += '���������������ĸ�������ַ�';
		}
		if (opt.PasswordOtherValid){
			if (pswTipSpan!="") pswTipSpan += '��';
			var arr = opt.PasswordOtherValid.split("|");
			var x = arr[0] ? arr[0] : "";
			var y = arr[1] ? arr[1] : "";
			var z = arr[2] ? arr[2] : "";
			if(x == "1") {
				pswTipSpan += "���벻�ܰ���>=3������������ĸ�����֣�";
			}
			if(y == "1") {
				pswTipSpan +=  "���벻�ܰ���ABAB��ABCABC����ĸ�����֣�";
			}
			if(z == "1") {
				pswTipSpan +=  '���벻�ܰ���"password"��';
			}
		}
		if(opt.uniUserPwdComplexityCfg && typeof getPasswordComplexityTip=='function') {  //�µ�ͳһ���븴�Ӷ���ʾ���ݻ�ȡ
			pswTipSpan=getPasswordComplexityTip(opt.uniUserPwdComplexityCfg);
		}
		
		var _tpl = '<table class="edit-password-panel">';
		if (!opt.hideOldPsw) _tpl+='<tr><td class="r-label">'+opt.oldLabel+'</td><td><input class="old-psw textbox"  type="password" data-next=".new-psw"/></td><td class=\'tipmsg\' style="color:red;width: 200px;"></td></tr>';
		_tpl+='<tr><td class="r-label">'+opt.newLabel+'</td><td><input class="new-psw textbox" disabled type="password" data-next=".cnf-psw"/></td><td class=\'tipmsg\' style="color:red;width: 200px;"></td></tr>\
			<tr><td class="r-label"></td><td><div sytle="text-align:left; width: 315px; margin: 2px 0pt;height:25px;"><span class="strength-L" style="text-align: center;margin-right: 1px;float: left;display: block;width: 55px;line-height: 25px;background:eeeeee;">'+$g("��")+'</span><span class="strength-M" style="text-align: center;margin-right: 1px;float: left;display: block;width: 55px;line-height: 25px;background:eeeeee;">'+$g("��")+'</span><span class="strength-H" style="text-align: center;margin-right: 1px;float: left;display: block;width: 55px;line-height: 25px;background:eeeeee;">'+$g("ǿ")+'</span></div></td><td></td></tr>\
			<tr><td class="r-label">'+opt.cnfLabel+'</td><td><input class="cnf-psw textbox" disabled type="password" data-next=".edit-password-btn" data-sameval=".new-psw"/></td><td class=\'tipmsg\' style="color:red;width: 200px;"></td></tr>\
			<tr><td></td><td><a href="javascript:void(0)" class="edit-password-btn" data-options="stopAllEventOnDisabled:true,disabled:true,iconCls:\'icon-w-edit\'">'+opt.updateLabel+'</a></td></tr>\
			<tr><td colspan="2" style="padding: 10px 0px; "><span style="color:red;line-height: 22px;">'
		if (pswTipSpan!="") _tpl += UserNamePswTipSpan + pswTipSpan;
		_tpl += '</span></td></tr></table>';
		var valid1 = function(p,o){
			var srcObj = p.find(".old-psw");
			var oldpsw = srcObj.val();
			var tipObj = srcObj.parent().parent().find(".tipmsg");
			tipObj.html("");
			if (oldpsw==""){
				tipObj.html($g("����ԭ����"));
				srcObj.focus();
				return false;
			}
			var encOldPsw = hex_md5(dhc_cacheEncrypt(oldpsw));
			if ('function'==typeof opt.encryHandler){
				encOldPsw = opt.encryHandler.call(this,oldpsw);
			}
			if (o.persistent!=""){ //ѡ��֤persist
				if(o.persistent!==encOldPsw){
					tipObj.html($g("�������"));
					srcObj.focus();
					return false;
				}else{
					p.find(".edit-password-btn").linkbutton("enable")
					p.find(".new-psw").prop("disabled",false);
					p.find(srcObj.data("next")).focus();
					//tipObj.html("������ȷ");
				}
				return true;
			}
			if (o.validEnc==""){
				tipObj.html(" encryItem Null ");
				return false;
			}
			$cm({
				EncryItemName:o.validEnc,username:o.userName,password:encOldPsw,RSID:RSID,dataType:'text'
			},function(rtn){
				var arr = rtn.split("^");
				if(arr[0]<0){
					if (arr[1]=="UserExceptionAction"){
						$.messager.alert($g("Tip"),$g("�û���Ϊ�쳣"));
					}else{
						tipObj.html($g("�������"));
						srcObj.focus();
					}
				}else{
					p.find(".edit-password-btn").linkbutton("enable")
					p.find(".new-psw").prop("disabled",false);
					p.find(srcObj.data("next")).focus();
				}
			})
		};
		var valid2 = function(p,o){
			//if (!valid1(p,o)) return false;
			var srcObj = p.find(".new-psw");
			var tipObj = srcObj.parent().parent().find(".tipmsg");
			var newpsw = srcObj.val();
			tipObj.html("");
			
			if (newpsw==""){
				tipObj.html($g("������Ϊ��"));
				srcObj.focus();
				return ;
			}
			if(opt.uniUserPwdComplexityCfg && typeof validPasswordComplexity=='function') {  //�µ�ͳһ���븴�Ӷ���֤ 2023-02-07
				var validRet=validPasswordComplexity(newpsw,opt.uniUserPwdComplexityCfg);
				if(validRet===true) { //��֤ͨ��
					p.find(".cnf-psw").prop("disabled",false);
					p.find(srcObj.data("next")).focus();
					return true;
				}else{
					tipObj.html( '<font color="red">'+$g(validRet)+'</font>' );
					srcObj.focus();
					return ;
				}
			}

			if (newpsw.length<opt.minLength){
				tipObj.html($g("���볤�Ȳ���С��")+opt.minLength);
				srcObj.focus();
				return ;
			}
			if(opt.isContainWordAndNum){
				if (!(/[0-9]+/.test(newpsw))){
					tipObj.html("<font color='red'>������Ҫ��������!</font>");
					srcObj.focus();
					return;
				}
				if (!/[a-zA-Z]/.test(newpsw)){
					tipObj.html("<font color='red'>������Ҫ������ĸ!</font>");
					srcObj.focus();
					return;
				}
				if (!newpsw.match(/[\u0021-\u002F\u003A-\u0040\u005B-\u0060\u007B-\u007E]/g)){
					tipObj.html("<font color='red'>������Ҫ��������!</font>");
					srcObj.focus();
					return;
				}
				if (!/[a-z]/.test(newpsw)){
					tipObj.html("<font color='red'>������Ҫ����Сд��ĸ!</font>");
					srcObj.focus();
					return;
				} 
				if (!/[A-Z]/.test(newpsw)){
					tipObj.html("<font color='red'>������Ҫ������д��ĸ!</font>");
					srcObj.focus();
					return;
				}
				var patrn = /[`~!@#$%^&*()_\-+=<>?:"{}|,.\/;'\\[\]]/im; 
				if (!patrn.test(newpsw)){
					tipObj.html("<font color='red'>������Ҫ���������ַ�!</font>");
					srcObj.focus();
					return;
				}				
			}
			if(!!opt.PasswordOtherValid){
				//����У��
				var rtmMsg = strictComplex(opt.PasswordOtherValid, newpsw);
				if (rtmMsg != ""){
					tipObj.html(rtmMsg);
					srcObj.focus();
					return;
				}
			}
			p.find(".cnf-psw").prop("disabled",false);
			p.find(srcObj.data("next")).focus();
			return true;
		};
		function strictComplex(reg, str)  {
			var arr = reg.split("|");
			var x = arr[0] ? arr[0] : "";
			var y = arr[1] ? arr[1] : "";
			var z = arr[2] ? arr[2] : "";
			if(x == "1" && sequentialString(str)) {
				return "���� ����>=3������������ĸ������";
			}
			if(y == "1" && repeatString(str)) {
				return "���� ����ABAB��ABCABC����ĸ������";
			}
			var temp = str.toLowerCase();
			if(z == "1" && temp.indexOf("password") > -1) {
				return "���� ����password";
			}
			return "";
		}
		/**
		 * �Ƿ�������3���ַ� ����>=3������������ĸ������
		 * @param str ԭ�ַ�
		 * @returns true ������3���ַ�
		 */
		function sequentialString(str) {
			var arr = str.split('');
			for (var i = 2; i < arr.length; i++) {
				if(arr[i] == arr[i - 2] && arr[i - 2] == arr[i - 1]) {
					return true;
				}
			}
			for (var i = 2; i < arr.length; i++) {
				if(Math.abs(arr[i].charCodeAt() - arr[i - 1].charCodeAt()) == 1 && Math.abs(arr[i - 1].charCodeAt() - arr[i - 2].charCodeAt()) == 1 ) {
					return true;
				}
			}
			return false;
		}

		/**
		 * ����ABAB��ABCABC����ĸ������
		 * @param str ԭ�ַ�
		 * @returns true ��
		 */
		function repeatString(str) {
			var arr = str.split('');
			for (var i = 3; i < arr.length; i++) {
				if(arr[i] == arr[i - 2] && arr[i - 1] == arr[i - 3]) {
					return true;
				}
			}
			for (var i = 5; i < arr.length; i++) {
				if(arr[i] == arr[i - 3] && arr[i - 1] == arr[i - 4] && arr[i - 2] == arr[i - 5]) {
					return true;
				}
			}
			return false;
		}
		var valid3 = function(p,o){
			if (o.saving) return ;
			var srcObj =  p.find(".cnf-psw");
			var sameSelector = srcObj.data("sameval");
			var sameObj = p.find(sameSelector);
			var tipObj = srcObj.parent().parent().find(".tipmsg");
			tipObj.html("");
			if(srcObj.val()==""){
				tipObj.html($g("ȷ������Ϊ��"));
				return false;
			}
			if ((sameObj.val()!="")&&(srcObj.val()!="")){
				if(sameObj.val()!=srcObj.val()){
					//����������������ʱ���ı佹��
					if (p.find("input:focus").length==0){
						srcObj.focus();
					}
					tipObj.html($g("�������������Ĳ�һ��"));
					return false;
				}
			}
			return true;
		};
		var save = function(p,o){
			var newp = p.find(".new-psw").val();
			var oldp = p.find(".old-psw").val();
			if ('function'==typeof opt.encryHandler){
				newp = opt.encryHandler.call(this,newp);;
				oldp = opt.encryHandler.call(this,oldp);;
			}else{
				newp = dhc_cacheEncrypt(newp);
				oldp = dhc_cacheEncrypt(oldp);
			}
			if (o.saveEnc==""){return ;}
			$cm({
				EncryItemName:o.saveEnc,
				newPsw:newp,
				oldPsw:oldp,
				userCode:o.userName,
				RSID:window.RSID||""
			},function(rtn){
				if(rtn.success==1){
					if (o.hideOldPsw){
						if (o.successCallback) o.successCallback.call(this);
					}else{
						opt.persistent = hex_md5(newp);
						opt.saving = true;
						$(".old-psw").val("");
						$(".new-psw").val("").prop("disabled",true);
						$(".cnf-psw").val("").prop("disabled",true); //-->�ᴥ��cnf-pws-blur�¼�
						$.messager.alert("��ʾ",rtn.msg);
						if (opt.closeAfterSave){
							websys_showModal('close');
						}					
						opt.saving = false;
					}
				}else{
					$.messager.alert("��ʾ",rtn.msg);
					$(".new-psw").val("");
					$(".cnf-psw").val("");
				}
			});
		}
		this.each(function(ind,item){
			var _t = $(this);
			$(_tpl).appendTo(_t);
			var epp = _t.find(".edit-password-panel");
			epp.find(".edit-password-btn").linkbutton();
			if (!opt.hideOldPsw){
				epp.find(".old-psw").on("keydown",function(e){
					if(e.key=="Enter"){
						//epp.find($(this).data("next")).focus();
						valid1(epp,opt);
					}else{
						$(this).parent().parent().find(".tipmsg").html("");
					}
					//.on("input",function(){$(this).parent().parent().find(".tipmsg").html("");})
				}).on("blur",function(){
					valid1(epp,opt);
				});
			}else{
				$(".new-psw").prop("disabled",false).focus();
			}
			//--------------new
			epp.find(".new-psw").on("keydown",function(e){
				if(epp.find(".old-psw").val()==""){epp.find(".old-psw").focus();}
				if(e.key=="Enter"){
					valid2(epp,opt);
					//epp.find($(this).data("next")).focus();
				}else{
					setTimeout(function () {
						pwStrength(epp, epp.find(".new-psw").val());
					}, 0);
					$(this).parent().parent().find(".tipmsg").html("");
				}
			}).on("blur",function(){
				valid2(epp,opt);
			});
			//------------confirm-------
			epp.find(".cnf-psw").on("keydown",function(e){
				if(epp.find(".new-psw").val()==""){epp.find(".new-psw").focus();}
				if(e.key=="Enter"){
					//epp.find($(this).data("next")).focus();
					if (valid3(epp,opt)) {
						epp.find($(this).data("next")).linkbutton("enable").trigger("hover").trigger("mouseenter").focus();
					}
				}else{
					$(this).parent().parent().find(".tipmsg").html("");
				}
			}).on("blur",function(){
				if (valid3(epp,opt)) {
					epp.find($(this).data("next")).linkbutton("enable").trigger("hover").trigger("mouseenter").focus();
				}
			});
			epp.find(".edit-password-btn").click(function(){
				if (valid2(epp,opt) && valid3(epp,opt)){ //�����ť ��Ҫ��У��һ�� ������������ cryze 2019-07-01
					save(epp,opt);
				}
			});
		});
	}
})(jQuery)