;(function($){
	/*����persistPWD�ж�,��ͨ��encryItem��̨�ж�*/
	var defaultOpts = {
		isContainWordAndNum:false, //Ĭ��ǿ�Ʋ�����
		minLength:"0",
		oldLabel:"������",newLabel:"������",cnfLabel:"ȷ������",updateLabel:'�޸�����',
		persistent:"",validEnc:"",saveEnc:"",userName:"",saving:false
	};
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
		var _tpl = '<table class="edit-password-panel">\
			<tr><td class="r-label">'+opt.oldLabel+'</td><td><input class="old-psw textbox"  type="password" data-next=".new-psw"/></td><td class=\'tipmsg\' style="color:red;width: 200px;"></td></tr>\
			<tr><td class="r-label">'+opt.newLabel+'</td><td><input class="new-psw textbox" disabled type="password" data-next=".cnf-psw"/></td><td class=\'tipmsg\' style="color:red;width: 200px;"></td></tr>\
			<tr><td class="r-label"></td><td><div sytle="text-align:left; width: 315px; margin: 2px 0pt;height:25px;"><span class="strength-L" style="text-align: center;margin-right: 1px;float: left;display: block;width: 55px;line-height: 25px;background:eeeeee;">'+$g("��")+'</span><span class="strength-M" style="text-align: center;margin-right: 1px;float: left;display: block;width: 55px;line-height: 25px;background:eeeeee;">'+$g("��")+'</span><span class="strength-H" style="text-align: center;margin-right: 1px;float: left;display: block;width: 55px;line-height: 25px;background:eeeeee;">'+$g("ǿ")+'</span></div></td><td></td></tr>\
			<tr><td class="r-label">'+opt.cnfLabel+'</td><td><input class="cnf-psw textbox" disabled type="password" data-next=".edit-password-btn" data-sameval=".new-psw"/></td><td class=\'tipmsg\' style="color:red;width: 200px;"></td></tr>\
			<tr><td></td><td><a href="javascript:void(0)" class="edit-password-btn" data-options="stopAllEventOnDisabled:true,disabled:true,iconCls:\'icon-w-edit\'">'+opt.updateLabel+'</a></td></tr>\
		</table>'
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
				EncryItemName:o.validEnc,username:o.userName,password:encOldPsw,dataType:'text'
			},function(rtn){
				var arr = rtn.split("^");
				if(arr[0]<0){
					tipObj.html($g("�������"));
					srcObj.focus();
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
			if (newpsw.length<opt.minLength){
				tipObj.html($g("���볤�Ȳ���С��")+opt.minLength);
				srcObj.focus();
				return ;
			}
			if(opt.isContainWordAndNum){
				if (!(/[0-9]+/.test(newpsw))){
					tipObj.html($g("������Ҫ��������"));
					srcObj.focus();
					return;
				}
				if (!/[a-zA-Z]/.test(newpsw)){
					tipObj.html($g("������Ҫ������ĸ"));
					srcObj.focus();
					return;
				} 	
			}
			p.find(".cnf-psw").prop("disabled",false);
			p.find(srcObj.data("next")).focus();
			return true;
		};
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
			newp = dhc_cacheEncrypt(newp);
			oldp = dhc_cacheEncrypt(oldp);
			if (o.saveEnc==""){return ;}
			$cm({
				EncryItemName:o.saveEnc,
				newPsw:newp,
				oldPsw:oldp,
				userCode:o.userName
			},function(rtn){
				if(rtn.success==1){
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
			//--------------new
			epp.find(".new-psw").on("keydown",function(e){
				if(epp.find(".old-psw").val()==""){epp.find(".old-psw").focus();}
				if(e.key=="Enter"){
					valid2(epp,opt);
					//epp.find($(this).data("next")).focus();
				}else{
					pwStrength(epp,epp.find(".new-psw").val());
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